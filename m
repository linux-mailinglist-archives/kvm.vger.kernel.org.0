Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA183C60DE
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 18:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbhGLQzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 12:55:18 -0400
Received: from foss.arm.com ([217.140.110.172]:58396 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232710AbhGLQzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 12:55:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C5A51FB;
        Mon, 12 Jul 2021 09:52:29 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1437A3F694;
        Mon, 12 Jul 2021 09:52:26 -0700 (PDT)
Date:   Mon, 12 Jul 2021 17:51:55 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     drjones@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
        lvivier@redhat.com, kvm-ppc@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, vivek.gautam@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 1/5] lib: arm: Print test exit status
 on exit if chr-testdev is not available
Message-ID: <20210712175155.7c6f8dc3@slackpad.fritz.box>
In-Reply-To: <20210702163122.96110-2-alexandru.elisei@arm.com>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
        <20210702163122.96110-2-alexandru.elisei@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Jul 2021 17:31:18 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> The arm64 tests can be run under kvmtool, which doesn't emulate a
> chr-testdev device. In preparation for adding run script support for
> kvmtool, print the test exit status so the scripts can pick it up and
> correctly mark the test as pass or fail.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/chr-testdev.h |  1 +
>  lib/arm/io.c      | 10 +++++++++-
>  lib/chr-testdev.c |  5 +++++
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/chr-testdev.h b/lib/chr-testdev.h
> index ffd9a851aa9b..09b4b424670e 100644
> --- a/lib/chr-testdev.h
> +++ b/lib/chr-testdev.h
> @@ -11,4 +11,5 @@
>   */
>  extern void chr_testdev_init(void);
>  extern void chr_testdev_exit(int code);
> +extern bool chr_testdev_available(void);
>  #endif
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 343e10822263..9e62b571a91b 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -125,7 +125,15 @@ extern void halt(int code);
>  
>  void exit(int code)
>  {
> -	chr_testdev_exit(code);
> +	if (chr_testdev_available()) {
> +		chr_testdev_exit(code);
> +	} else {
> +		/*
> +		 * Print the test return code in the format used by chr-testdev
> +		 * so the runner script can parse it.
> +		 */
> +		printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);

It's more me being clueless here rather than a problem, but where does
this "EXIT: STATUS" line come from? In lib/chr-testdev.c I see "%dq",
so it this coming from QEMU (but I couldn't find it in there)?

But anyways the patch looks good and matches what PPC and s390 do.

Cheers,
Andre


> +	}
>  	psci_system_off();
>  	halt(code);
>  	__builtin_unreachable();
> diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
> index b3c641a833fe..301e73a6c064 100644
> --- a/lib/chr-testdev.c
> +++ b/lib/chr-testdev.c
> @@ -68,3 +68,8 @@ void chr_testdev_init(void)
>  	in_vq = vqs[0];
>  	out_vq = vqs[1];
>  }
> +
> +bool chr_testdev_available(void)
> +{
> +	return vcon != NULL;
> +}

