Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417EA2FC3A7
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 23:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbhASWgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 17:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbhASWgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 17:36:10 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036C4C061573;
        Tue, 19 Jan 2021 14:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=OtL4sdAGsJ08z7fCxeCmMVsJDaQwBot6LG44qZyyGSk=; b=DXq12zrUsz5JbfiOkM3/P+/8RC
        RVJssaknA/7T+p+K1KP2P7Sc4lQOv1swnQ+FwXP4oSwuCDe5IOLaHX2Ajp6t/wJbb6hzSJC01rsuX
        MsegCFIS23WG4OTrofNGyE1GuKF6m4qq9rU/ObWUy1s5/taEm7+hlJHxrltuO/LgxeYAAcSU4wZnF
        A7VGnrMdtgpDsxEbHE2gHVm+oogiA0eiKzPk3I+pxtKTmlN3wUySac8uDXl3G4h3VibiZHmo6sdcQ
        ktwmyM50mI9O6KIwfVx7I02IwEs/kmZA6Wt0IaTHTExSlyJzLDwJIT8DR/+pLQCCByDxwzqDhTFqf
        oTk/e/sA==;
Received: from [2601:1c0:6280:3f0::9abc]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l1za7-0002Cl-CZ; Tue, 19 Jan 2021 22:34:36 +0000
Subject: Re: [PATCH v4 1/2] drivers/misc: sysgenid: add system generation id
 driver
To:     Adrian Catangiu <acatan@amazon.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, graf@amazon.com, arnd@arndb.de,
        ebiederm@xmission.com, rppt@kernel.org, 0x7f454c46@gmail.com,
        borntraeger@de.ibm.com, Jason@zx2c4.com, jannh@google.com,
        w@1wt.eu, colmmacc@amazon.com, luto@kernel.org, tytso@mit.edu,
        ebiggers@kernel.org, dwmw@amazon.co.uk, bonzini@gnu.org,
        sblbir@amazon.com, raduweis@amazon.com, corbet@lwn.net,
        mst@redhat.com, mhocko@kernel.org, rafael@kernel.org, pavel@ucw.cz,
        mpe@ellerman.id.au, areber@redhat.com, ovzxemul@gmail.com,
        avagin@gmail.com, ptikhomirov@virtuozzo.com, gil@azul.com,
        asmehra@redhat.com, dgunigun@redhat.com, vijaysun@ca.ibm.com,
        oridgar@gmail.com, ghammer@redhat.com
References: <1610453760-13812-1-git-send-email-acatan@amazon.com>
 <1610453760-13812-2-git-send-email-acatan@amazon.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2764a194-934c-5426-728a-cd755a6e395f@infradead.org>
Date:   Tue, 19 Jan 2021 14:34:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1610453760-13812-2-git-send-email-acatan@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi--

On 1/12/21 4:15 AM, Adrian Catangiu wrote:
> - Background and problem
> 

> ---
>  Documentation/misc-devices/sysgenid.rst | 240 +++++++++++++++++++++++++
>  drivers/misc/Kconfig                    |  16 ++
>  drivers/misc/Makefile                   |   1 +
>  drivers/misc/sysgenid.c                 | 298 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/sysgenid.h           |  18 ++
>  5 files changed, 573 insertions(+)
>  create mode 100644 Documentation/misc-devices/sysgenid.rst
>  create mode 100644 drivers/misc/sysgenid.c
>  create mode 100644 include/uapi/linux/sysgenid.h
> 
> diff --git a/Documentation/misc-devices/sysgenid.rst b/Documentation/misc-devices/sysgenid.rst
> new file mode 100644
> index 0000000..0b31ccf
> --- /dev/null
> +++ b/Documentation/misc-devices/sysgenid.rst
> @@ -0,0 +1,240 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +========
> +SYSGENID
> +========
> +
> +The System Generation ID feature is required in virtualized or
> +containerized environments by applications that work with local copies
> +or caches of world-unique data such as random values, UUIDs,
> +monotonically increasing counters, etc.
> +Such applications can be negatively affected by VM or container
> +snapshotting when the VM or container is either cloned or returned to
> +an earlier point in time.
> +
> +The System Generation ID is a simple concept meant to alleviate the
> +issue by providing a monotonically increasing counter that changes
> +each time the VM or container is restored from a snapshot.
> +The driver for it lives at ``drivers/misc/sysgenid.c``.
> +
> +The ``sysgenid`` driver exposes a monotonic incremental System
> +Generation u32 counter via a char-dev FS interface accessible through
> +``/dev/sysgenid`` that provides sync and async SysGen counter updates

                                                                 update

> +notifications. It also provides SysGen counter retrieval and
> +confirmation mechanisms.
> +
> +The counter starts from zero when the driver is initialized and
> +monotonically increments every time the system generation changes.
> +
> +The ``sysgenid`` driver exports the ``void sysgenid_bump_generation()``
> +symbol which can be used by backend drivers to drive system generation
> +changes based on hardware events.
> +System generation changes can also be driven by userspace software
> +through a dedicated driver ioctl.
> +
> +Userspace applications or libraries can (a)synchronously consume the
> +system generation counter through the provided FS interface, to make
> +any necessary internal adjustments following a system generation update.
> +
> +Driver FS interface:
> +
> +``open()``:
> +  When the device is opened, a copy of the current Sys-Gen-Id (counter)
> +  is associated with the open file descriptor. The driver now tracks
> +  this file as an independent *watcher*. The driver tracks how many
> +  watchers are aware of the latest Sys-Gen-Id counter and how many of
> +  them are *outdated*; outdated being those that have lived through
> +  a Sys-Gen-Id change but not yet confirmed the new generation counter.
> +
> +``read()``:
> +  Read is meant to provide the *new* system generation counter when a
> +  generation change takes place. The read operation blocks until the
> +  associated counter is no longer up to date, at which point the new
> +  counter is provided/returned.
> +  Nonblocking ``read()`` uses ``EAGAIN`` to signal that there is no
> +  *new* counter value available. The generation counter is considered
> +  *new* for each open file descriptor that hasn't confirmed the new
> +  value following a generation change. Therefore, once a generation
> +  change takes place, all ``read()`` calls will immediately return the
> +  new generation counter and will continue to do so until the
> +  new value is confirmed back to the driver through ``write()``.
> +  Partial reads are not allowed - read buffer needs to be at least
> +  ``sizeof(unsigned)`` in size.

Please use (unsigned int), not just (unsigned).
(Linux style)

> +
> +``write()``:
> +  Write is used to confirm the up-to-date Sys Gen counter back to the
> +  driver.
> +  Following a VM generation change, all existing watchers are marked
> +  as *outdated*. Each file descriptor will maintain the *outdated*
> +  status until a ``write()`` confirms the up-to-date counter back to
> +  the driver.
> +  Partial writes are not allowed - write buffer should be exactly
> +  ``sizeof(unsigned)`` in size.

ditto.

> +
> +``poll()``:
> +  Poll is implemented to allow polling for generation counter updates.
> +  Such updates result in ``EPOLLIN`` polling status until the new
> +  up-to-date counter is confirmed back to the driver through a
> +  ``write()``.
> +
> +``ioctl()``:
> +  The driver also adds support for tracking count of open file
> +  descriptors that haven't acknowledged a generation counter update,
> +  as well as a mechanism for userspace to *force* a generation update:
> +
> +  - SYSGENID_GET_OUTDATED_WATCHERS: immediately returns the number of
> +    *outdated* watchers - number of file descriptors that were open
> +    during a system generation change, and which have not yet confirmed
> +    the new generation counter.
> +  - SYSGENID_WAIT_WATCHERS: blocks until there are no more *outdated*
> +    watchers, or if a ``timeout`` argument is provided, until the
> +    timeout expires.
> +    If the current caller is *outdated* or a generation change happens
> +    while waiting (thus making current caller *outdated*), the ioctl
> +    returns ``-EINTR`` to signal the user to handle event and retry.
> +  - SYSGENID_FORCE_GEN_UPDATE: forces a generation counter increment.
> +    It takes a ``minimum-generation`` argument which represents the
> +    minimum value the generation counter will be incremented to. For
> +    example if current generation is ``5`` and ``SYSGENID_FORCE_GEN_UPDATE(8)``
> +    is called, the generation counter will increment to ``8``.
> +    This IOCTL can only be used by processes with CAP_CHECKPOINT_RESTORE
> +    or CAP_SYS_ADMIN capabilities.
> +
> +``mmap()``:
> +  The driver supports ``PROT_READ, MAP_SHARED`` mmaps of a single page
> +  in size. The first 4 bytes of the mapped page will contain an
> +  up-to-date u32 copy of the system generation counter.
> +  The mapped memory can be used as a low-latency generation counter
> +  probe mechanism in critical sections - see examples.
> +
> +``close()``:
> +  Removes the file descriptor as a system generation counter *watcher*.
> +
> +Example application workflows
> +-----------------------------
> +
> +1) Watchdog thread simplified example::
> +
> +	void watchdog_thread_handler(int *thread_active)
> +	{
> +		unsigned genid;

		unsigned int genid;

> +		int fd = open("/dev/sysgenid", O_RDWR | O_CLOEXEC, S_IRUSR | S_IWUSR);
> +
> +		do {
> +			// read new gen ID - blocks until VM generation changes
> +			read(fd, &genid, sizeof(genid));
> +
> +			// because of VM generation change, we need to rebuild world
> +			reseed_app_env();
> +
> +			// confirm we're done handling gen ID update
> +			write(fd, &genid, sizeof(genid));
> +		} while (atomic_read(thread_active));
> +
> +		close(fd);
> +	}
> +
> +2) ASYNC simplified example::
> +
> +	void handle_io_on_sysgenfd(int sysgenfd)
> +	{
> +		unsigned genid;

		unsigned int genid;

> +
> +		// read new gen ID - we need it to confirm we've handled update
> +		read(fd, &genid, sizeof(genid));
> +
> +		// because of VM generation change, we need to rebuild world
> +		reseed_app_env();
> +
> +		// confirm we're done handling the gen ID update
> +		write(fd, &genid, sizeof(genid));
> +	}
> +
> +	int main() {
> +		int epfd, sysgenfd;
> +		struct epoll_event ev;
> +
> +		epfd = epoll_create(EPOLL_QUEUE_LEN);
> +
> +		sysgenfd = open("/dev/sysgenid",
> +		               O_RDWR | O_CLOEXEC | O_NONBLOCK,
> +		               S_IRUSR | S_IWUSR);
> +
> +		// register sysgenid for polling
> +		ev.events = EPOLLIN;
> +		ev.data.fd = sysgenfd;
> +		epoll_ctl(epfd, EPOLL_CTL_ADD, sysgenfd, &ev);
> +
> +		// register other parts of your app for polling
> +		// ...
> +
> +		while (1) {
> +			// wait for something to do...
> +			int nfds = epoll_wait(epfd, events,
> +				MAX_EPOLL_EVENTS_PER_RUN,
> +				EPOLL_RUN_TIMEOUT);
> +			if (nfds < 0) die("Error in epoll_wait!");
> +
> +			// for each ready fd
> +			for(int i = 0; i < nfds; i++) {
> +				int fd = events[i].data.fd;
> +
> +				if (fd == sysgenfd)
> +					handle_io_on_sysgenfd(sysgenfd);
> +				else
> +					handle_some_other_part_of_the_app(fd);
> +			}
> +		}
> +
> +		return 0;
> +	}
> +
> +3) Mapped memory polling simplified example::
> +
> +	/*
> +	 * app/library function that provides cached secrets
> +	 */
> +	char * safe_cached_secret(app_data_t *app)
> +	{
> +		char *secret;
> +		volatile unsigned *const genid_ptr = get_sysgenid_mapping(app);

		         unsigned int

> +	again:
> +		secret = __cached_secret(app);
> +
> +		if (unlikely(*genid_ptr != app->cached_genid)) {
> +			app->cached_genid = *genid_ptr;
> +			barrier();
> +
> +			// rebuild world then confirm the genid update (thru write)
> +			rebuild_caches(app);
> +
> +			ack_sysgenid_update(app);
> +
> +			goto again;
> +		}
> +
> +		return secret;
> +	}
> +
> +4) Orchestrator simplified example::
> +
> +	/*
> +	 * orchestrator - manages multiple applications and libraries used by
> +	 * a service and tries to make sure all sensitive components gracefully
> +	 * handle VM generation changes.
> +	 * Following function is called on detection of a VM generation change.
> +	 */
> +	int handle_sysgen_update(int sysgen_fd, unsigned new_gen_id)

	                                        unsigned int

> +	{
> +		// pause until all components have handled event
> +		pause_service();
> +
> +		// confirm *this* watcher as up-to-date
> +		write(sysgen_fd, &new_gen_id, sizeof(unsigned));

		                                     unsigned int

> +
> +		// wait for all *others* for at most 5 seconds.
> +		ioctl(sysgen_fd, VMGENID_WAIT_WATCHERS, 5000);
> +
> +		// all applications on the system have rebuilt worlds
> +		resume_service();
> +	}


> diff --git a/include/uapi/linux/sysgenid.h b/include/uapi/linux/sysgenid.h
> new file mode 100644
> index 0000000..ea38fd3
> --- /dev/null
> +++ b/include/uapi/linux/sysgenid.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> +
> +#ifndef _UAPI_LINUX_SYSGENID_H
> +#define _UAPI_LINUX_SYSGENID_H
> +
> +#include <linux/ioctl.h>
> +
> +#define SYSGENID_IOCTL 0x2d

Please document new IOCTL major/magic values in
Documentation/userspace-api/ioctl/ioctl-number.rst.



thanks.
-- 
~Randy
"He closes his eyes and drops the goggles.  You can't get hurt
by looking at a bitmap.  Or can you?"
(Neal Stephenson: Snow Crash)
