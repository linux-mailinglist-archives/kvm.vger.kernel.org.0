Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FA16EB056
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 19:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbjDURL4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 21 Apr 2023 13:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbjDURLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 13:11:45 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE1F09016
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 10:11:33 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02F1115A1;
        Fri, 21 Apr 2023 10:12:17 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A9FA3F6C4;
        Fri, 21 Apr 2023 10:11:32 -0700 (PDT)
Date:   Fri, 21 Apr 2023 18:11:29 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     kvm@vger.kernel.org, will@kernel.org, suzuki.poulose@arm.com
Subject: Re: [PATCH kvmtool 14/16] Factor epoll thread
Message-ID: <20230421181129.182396a7@donnerap.cambridge.arm.com>
In-Reply-To: <20230419132119.124457-15-jean-philippe@linaro.org>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
        <20230419132119.124457-15-jean-philippe@linaro.org>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Apr 2023 14:21:18 +0100
Jean-Philippe Brucker <jean-philippe@linaro.org> wrote:

Hi,

> Both ioeventfd and ipc use an epoll thread roughly the same way. In
> order to add a new epoll user, factor the common bits into epoll.c
> 
> Slight implementation changes which shouldn't affect behavior:
> 
> * At the moment ioeventfd mixes file descriptor (for the stop event) and
>   pointers in the epoll_event.data union, which could in theory cause
>   aliasing. Use a pointer for the stop event instead. kvm-ipc uses only
>   file descriptors. It could be changed but since epoll.c compares the
>   stop event pointer first, the risk of aliasing with an fd is much
>   lower there.
> 
> * kvm-ipc uses EPOLLET, edge-triggered events, but having the stop event
>   level-triggered shouldn't make a difference.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  Makefile            |   1 +
>  include/kvm/epoll.h |  17 ++++++++
>  epoll.c             |  89 ++++++++++++++++++++++++++++++++++++++
>  ioeventfd.c         |  94 ++++++----------------------------------
>  kvm-ipc.c           | 103 +++++++++++++-------------------------------
>  5 files changed, 149 insertions(+), 155 deletions(-)
>  create mode 100644 include/kvm/epoll.h
>  create mode 100644 epoll.c
> 
> diff --git a/Makefile b/Makefile
> index 86e19339..6b742369 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -80,6 +80,7 @@ OBJS	+= virtio/vhost.o
>  OBJS	+= disk/blk.o
>  OBJS	+= disk/qcow.o
>  OBJS	+= disk/raw.o
> +OBJS	+= epoll.o
>  OBJS	+= ioeventfd.o
>  OBJS	+= net/uip/core.o
>  OBJS	+= net/uip/arp.o
> diff --git a/include/kvm/epoll.h b/include/kvm/epoll.h
> new file mode 100644
> index 00000000..dbb5a8d9
> --- /dev/null
> +++ b/include/kvm/epoll.h
> @@ -0,0 +1,17 @@
> +#include <sys/epoll.h>
> +#include "kvm/kvm.h"
> +
> +typedef void (*epoll__event_handler_t)(struct kvm *kvm, struct epoll_event *ev);
> +
> +struct kvm__epoll {
> +	int fd;
> +	int stop_fd;
> +	struct kvm *kvm;
> +	const char *name;
> +	pthread_t thread;
> +	epoll__event_handler_t handle_event;
> +};
> +
> +int epoll__init(struct kvm *kvm, struct kvm__epoll *epoll,
> +		const char *name, epoll__event_handler_t handle_event);
> +int epoll__exit(struct kvm__epoll *epoll);
> diff --git a/epoll.c b/epoll.c
> new file mode 100644
> index 00000000..e0725a57
> --- /dev/null
> +++ b/epoll.c
> @@ -0,0 +1,89 @@
> +#include <sys/eventfd.h>
> +
> +#include "kvm/epoll.h"
> +
> +#define EPOLLFD_MAX_EVENTS	20
> +
> +static void *epoll__thread(void *param)
> +{
> +	u64 stop;
> +	int nfds, i;
> +	struct kvm__epoll *epoll = param;
> +	struct kvm *kvm = epoll->kvm;
> +	struct epoll_event events[EPOLLFD_MAX_EVENTS];
> +
> +	kvm__set_thread_name(epoll->name);
> +
> +	for (;;) {
> +		nfds = epoll_wait(epoll->fd, events, EPOLLFD_MAX_EVENTS, -1);
> +		for (i = 0; i < nfds; i++) {
> +			if (events[i].data.ptr == &epoll->stop_fd)
> +				goto done;
> +
> +			epoll->handle_event(kvm, &events[i]);
> +		}
> +	}
> +done:
> +	read(epoll->stop_fd, &stop, sizeof(stop));
> +	write(epoll->stop_fd, &stop, sizeof(stop));

read(2) and write(2) (sys)calls without checking the return value upsets
Ubuntu's compiler:

epoll.c: In function ‘epoll__thread’:
epoll.c:27:2: error: ignoring return value of ‘read’, declared with attribute warn_unused_result [-Werror=unused-result]
   27 |  read(epoll->stop_fd, &stop, sizeof(stop));
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(same for the write in the line after)
Since we use -Werror, this is fatal.

I fixed it for now with:
	if (read(epoll->stop_fd, &stop, sizeof(stop)) < 0)
		return NULL;

Not sure if there is a more meaningful way to bail out at this point.

Cheers,
Andre

> +	return NULL;
> +}
> +
> +int epoll__init(struct kvm *kvm, struct kvm__epoll *epoll,
> +		const char *name, epoll__event_handler_t handle_event)
> +{
> +	int r;
> +	struct epoll_event stop_event = {
> +		.events = EPOLLIN,
> +		.data.ptr = &epoll->stop_fd,
> +	};
> +
> +	epoll->kvm = kvm;
> +	epoll->name = name;
> +	epoll->handle_event = handle_event;
> +
> +	epoll->fd = epoll_create(EPOLLFD_MAX_EVENTS);
> +	if (epoll->fd < 0)
> +		return -errno;
> +
> +	epoll->stop_fd = eventfd(0, 0);
> +	if (epoll->stop_fd < 0) {
> +		r = -errno;
> +		goto err_close_fd;
> +	}
> +
> +	r = epoll_ctl(epoll->fd, EPOLL_CTL_ADD, epoll->stop_fd, &stop_event);
> +	if (r < 0)
> +		goto err_close_all;
> +
> +	r = pthread_create(&epoll->thread, NULL, epoll__thread, epoll);
> +	if (r < 0)
> +		goto err_close_all;
> +
> +	return 0;
> +
> +err_close_all:
> +	close(epoll->stop_fd);
> +err_close_fd:
> +	close(epoll->fd);
> +
> +	return r;
> +}
> +
> +int epoll__exit(struct kvm__epoll *epoll)
> +{
> +	int r;
> +	u64 stop = 1;
> +
> +	r = write(epoll->stop_fd, &stop, sizeof(stop));
> +	if (r < 0)
> +		return r;
> +
> +	r = read(epoll->stop_fd, &stop, sizeof(stop));
> +	if (r < 0)
> +		return r;
> +
> +	close(epoll->stop_fd);
> +	close(epoll->fd);
> +	return 0;
> +}
