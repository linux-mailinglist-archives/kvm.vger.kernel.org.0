Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6532C7443
	for <lists+kvm@lfdr.de>; Sat, 28 Nov 2020 23:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388741AbgK1Vto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 16:49:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732513AbgK1TB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Nov 2020 14:01:56 -0500
Received: from kernel.org (unknown [77.125.7.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F478222EB;
        Sat, 28 Nov 2020 10:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606558581;
        bh=SXZ50O0tZ9SfgxO8cbDzArUsagGX8/+Yhh5eFFtIV3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yZdliu4g5VM7aPv77CfA4Drg0lJGOysCszVmHduFA3ju2GDAiX1KFB119cnjPZb6B
         ynWOzkQsPzH2rVyUnuaqIq+iA1CduHiSQyl0AQKoH1yJV6NYTIldrCTHzas/4lMJMD
         6j7DGWWd/IYAF/1hu4n5YcAlfspmE3DEfZxmv6+A=
Date:   Sat, 28 Nov 2020 12:16:04 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     "Catangiu, Adrian Costin" <acatan@amazon.com>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Alexander Graf <graf@amazon.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>, Willy Tarreau <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "areber@redhat.com" <areber@redhat.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Andrey Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v3] drivers/virt: vmgenid: add vm generation id driver
Message-ID: <20201128101604.GC557259@kernel.org>
References: <3E05451B-A9CD-4719-99D0-72750A304044@amazon.com>
 <300d4404-3efe-880e-ef30-692eabbff5f7@de.ibm.com>
 <da1a1fa7-a1de-d0e6-755b-dd587687765e@amazon.de>
 <20201119173800.GD8537@kernel.org>
 <1cdb6fac-0d50-3399-74a6-24c119ebbaa5@amazon.de>
 <106f56ca-49bc-7cad-480f-4b26656e90ce@gmail.com>
 <96625ce2-66c6-34b8-ef81-7c17c05b4c7a@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <96625ce2-66c6-34b8-ef81-7c17c05b4c7a@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Adrian,

Usually each version of a patch is a separate e-mail thread

On Fri, Nov 27, 2020 at 08:26:02PM +0200, Catangiu, Adrian Costin wrote:
> - Background
> 
> The VM Generation ID is a feature defined by Microsoft (paper:
> http://go.microsoft.com/fwlink/?LinkId=260709) and supported by
> multiple hypervisor vendors.
> 
> The feature is required in virtualized environments by apps that work
> with local copies/caches of world-unique data such as random values,
> uuids, monotonically increasing counters, etc.
> Such apps can be negatively affected by VM snapshotting when the VM
> is either cloned or returned to an earlier point in time.
> 
> The VM Generation ID is a simple concept meant to alleviate the issue
> by providing a unique ID that changes each time the VM is restored
> from a snapshot. The hw provided UUID value can be used to
> differentiate between VMs or different generations of the same VM.
> 
> - Problem
> 
> The VM Generation ID is exposed through an ACPI device by multiple
> hypervisor vendors but neither the vendors or upstream Linux have no
> default driver for it leaving users to fend for themselves.
> 
> Furthermore, simply finding out about a VM generation change is only
> the starting point of a process to renew internal states of possibly
> multiple applications across the system. This process could benefit
> from a driver that provides an interface through which orchestration
> can be easily done.
> 
> - Solution
> 
> This patch is a driver that exposes a monotonic incremental Virtual
> Machine Generation u32 counter via a char-dev FS interface. The FS
> interface provides sync and async VmGen counter updates notifications.
> It also provides VmGen counter retrieval and confirmation mechanisms.
> 
> The generation counter and the interface through which it is exposed
> are available even when there is no acpi device present.
> 
> When the device is present, the hw provided UUID is not exposed to
> userspace, it is internally used by the driver to keep accounting for
> the exposed VmGen counter. The counter starts from zero when the
> driver is initialized and monotonically increments every time the hw
> UUID changes (the VM generation changes).
> On each hw UUID change, the new hypervisor-provided UUID is also fed
> to the kernel RNG.
> 
> If there is no acpi vmgenid device present, the generation changes are
> not driven by hw vmgenid events but can be driven by software through
> a dedicated driver ioctl.
> 
> This patch builds on top of Or Idgar <oridgar@gmail.com>'s proposal
> https://lkml.org/lkml/2018/3/1/498
> 
> - Future improvements
> 
> Ideally we would want the driver to register itself based on devices'
> _CID and not _HID, but unfortunately I couldn't find a way to do that.
> The problem is that ACPI device matching is done by
> '__acpi_match_device()' which exclusively looks at
> 'acpi_hardware_id *hwid'.
> 
> There is a path for platform devices to match on _CID when _HID is
> 'PRP0001' - but this is not the case for the Qemu vmgenid device.
> 
> Guidance and help here would be greatly appreciated.
> 
> Signed-off-by: Adrian Catangiu <acatan@amazon.com>
> 
> ---
 
Please put the history in the descending order next time

v2 -> v3:
...

v1 -> v2:
...

> v1 -> v2:
> 
>   - expose to userspace a monotonically increasing u32 Vm Gen Counter
>     instead of the hw VmGen UUID
>   - since the hw/hypervisor-provided 128-bit UUID is not public
>     anymore, add it to the kernel RNG as device randomness
>   - insert driver page containing Vm Gen Counter in the user vma in
>     the driver's mmap handler instead of using a fault handler
>   - turn driver into a misc device driver to auto-create /dev/vmgenid
>   - change ioctl arg to avoid leaking kernel structs to userspace
>   - update documentation
>   - various nits
>   - rebase on top of linus latest
> 
> v2 -> v3:
> 
>   - separate the core driver logic and interface, from the ACPI device.
>     The ACPI vmgenid device is now one possible backend.
>   - fix issue when timeout=0 in VMGENID_WAIT_WATCHERS
>   - add locking to avoid races between fs ops handlers and hw irq
>     driven generation updates
>   - change VMGENID_WAIT_WATCHERS ioctl so if the current caller is
>     outdated or a generation change happens while waiting (thus making
>     current caller outdated), the ioctl returns -EINTR to signal the
>     user to handle event and retry. Fixes blocking on oneself.
>   - add VMGENID_FORCE_GEN_UPDATE ioctl conditioned by
>     CAP_CHECKPOINT_RESTORE capability, through which software can force
>     generation bump.
> ---
>  Documentation/virt/vmgenid.rst | 240 +++++++++++++++++++++++
>  drivers/virt/Kconfig           |  17 ++
>  drivers/virt/Makefile          |   1 +
>  drivers/virt/vmgenid.c         | 435 +++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vmgenid.h   |  14 ++
>  5 files changed, 707 insertions(+)
>  create mode 100644 Documentation/virt/vmgenid.rst
>  create mode 100644 drivers/virt/vmgenid.c
>  create mode 100644 include/uapi/linux/vmgenid.h
> 
> diff --git a/Documentation/virt/vmgenid.rst b/Documentation/virt/vmgenid.rst
> new file mode 100644
> index 0000000..b6a9f8d
> --- /dev/null
> +++ b/Documentation/virt/vmgenid.rst
> @@ -0,0 +1,240 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +============
> +VMGENID
> +============

The "==" line should be the same length as the title, I think.

> +
> +The VM Generation ID is a feature defined by Microsoft (paper:
> +http://go.microsoft.com/fwlink/?LinkId=260709) and supported by
> +multiple hypervisor vendors.
> +
> +The feature is required in virtualized environments by apps that work

Please spell 'applications' fully

> +with local copies/caches of world-unique data such as random values,
> +uuids, monotonically increasing counters, etc.

UUIDs

> +Such apps can be negatively affected by VM snapshotting when the VM

       ^applications

> +is either cloned or returned to an earlier point in time.
> +
> +The VM Generation ID is a simple concept meant to alleviate the issue
> +by providing a unique ID that changes each time the VM is restored
> +from a snapshot. The hw provided UUID value can be used to

                       ^hardware (and below as well)

> +differentiate between VMs or different generations of the same VM.
> +
> +The VM Generation ID is exposed through an ACPI device by multiple
> +hypervisor vendors. The driver for it lives at
> +``drivers/virt/vmgenid.c``
> +
> +The ``vmgenid`` driver exposes a monotonic incremental Virtual
> +Machine Generation u32 counter via a char-dev FS interface that
> +provides sync and async VmGen counter updates notifications. It also
> +provides VmGen counter retrieval and confirmation mechanisms.

It would be nice to memntion here the name of the chardev :)

> +This counter and the interface through which it is exposed are
> +available even when there is no acpi device present.
> +
> +When the device is present, the hw provided UUID is not exposed to
> +userspace, it is internally used by the driver to keep accounting for
> +the exposed VmGen counter. The counter starts from zero when the
> +driver is initialized and monotonically increments every time the hw
> +UUID changes (the VM generation changes).
> +On each hw UUID change, the new UUID is also fed to the kernel RNG.
> +
> +If there is no acpi vmgenid device present, the generation changes are
> +not driven by hw vmgenid events and thus should be driven by software
> +through a dedicated driver ioctl.
> +
> +Driver interface:
> +
> +``open()``:
> +  When the device is opened, a copy of the current Vm-Gen-Id (counter)
> +  is associated with the open file descriptor. The driver now tracks
> +  this file as an independent *watcher*. The driver tracks how many
> +  watchers are aware of the latest Vm-Gen-Id counter and how many of
> +  them are *outdated*; outdated being those that have lived through
> +  a Vm-Gen-Id change but not yet confirmed the new generation counter.
> +
> +``read()``:
> +  Read is meant to provide the *new* VM generation counter when a
> +  generation change takes place. The read operation blocks until the
> +  associated counter is no longer up to date - until HW vm gen id
> +  changes - at which point the new counter is provided/returned.
> +  Nonblocking ``read()`` uses ``EAGAIN`` to signal that there is no
> +  *new* counter value available. The generation counter is considered
> +  *new* for each open file descriptor that hasn't confirmed the new
> +  value, following a generation change. Therefore, once a generation
> +  change takes place, all ``read()`` calls will immediately return the
> +  new generation counter and will continue to do so until the
> +  new value is confirmed back to the driver through ``write()``.
> +  Partial reads are not allowed - read buffer needs to be at least
> +  ``sizeof(unsigned)`` in size.
> +
> +``write()``:
> +  Write is used to confirm the up-to-date Vm Gen counter back to the
> +  driver.
> +  Following a VM generation change, all existing watchers are marked
> +  as *outdated*. Each file descriptor will maintain the *outdated*
> +  status until a ``write()`` confirms the up-to-date counter back to
> +  the driver.
> +  Partial writes are not allowed - write buffer should be exactly
> +  ``sizeof(unsigned)`` in size.
> +
> +``poll()``:
> +  Poll is implemented to allow polling for generation counter updates.
> +  Such updates result in ``EPOLLIN`` polling status until the new
> +  up-to-date counter is confirmed back to the driver through a
> +  ``write()``.
> +
> +``ioctl()``:
> +  The driver also adds support for tracking count of open file
> +  descriptors that haven't acknowledged a generation counter update.
> +  This is exposed through two IOCTLs:
> +
> +  - VMGENID_GET_OUTDATED_WATCHERS: immediately returns the number of
> +    *outdated* watchers - number of file descriptors that were open
> +    during a VM generation change, and which have not yet confirmed the
> +    new generation counter.
> +  - VMGENID_WAIT_WATCHERS: blocks until there are no more *outdated*
> +    watchers, or if a ``timeout`` argument is provided, until the
> +    timeout expires.
> +    If the current caller is *outdated* or a generation change happens
> +    while waiting (thus making current caller *outdated*), the ioctl
> +    returns ``-EINTR`` to signal the user to handle event and retry.
> +  - VMGENID_FORCE_GEN_UPDATE: forces a generation counter bump. Can only
> +    be used by processes with CAP_CHECKPOINT_RESTORE or CAP_SYS_ADMIN
> +    capabilities.
> +
> +``mmap()``:
> +  The driver supports ``PROT_READ, MAP_SHARED`` mmaps of a single page
> +  in size. The first 4 bytes of the mapped page will contain an
> +  up-to-date copy of the VM generation counter.
> +  The mapped memory can be used as a low-latency generation counter
> +  probe mechanism in critical sections - see examples.
> +
> +``close()``:
> +  Removes the file descriptor as a Vm generation counter watcher.
> +
> +Example application workflows
> +-----------------------------
> +
> +1) Watchdog thread simplified example::
> +
> +    void watchdog_thread_handler(int *thread_active)
> +    {
> +        unsigned genid;
> +        int fd = open("/dev/vmgenid", O_RDWR | O_CLOEXEC, S_IRUSR |
> S_IWUSR);
> +
> +        do {
> +            // read new gen ID - blocks until VM generation changes
> +            read(fd, &genid, sizeof(genid));
> +
> +            // because of VM generation change, we need to rebuild world
> +            reseed_app_env();
> +
> +            // confirm we're done handling gen ID update
> +            write(fd, &genid, sizeof(genid));
> +        } while (atomic_read(thread_active));
> +
> +        close(fd);
> +    }
> +
> +2) ASYNC simplified example::
> +
> +    void handle_io_on_vmgenfd(int vmgenfd)
> +    {
> +        unsigned genid;
> +
> +        // read new gen ID - we need it to confirm we've handled update
> +        read(fd, &genid, sizeof(genid));
> +
> +        // because of VM generation change, we need to rebuild world
> +        reseed_app_env();
> +
> +        // confirm we're done handling the gen ID update
> +        write(fd, &genid, sizeof(genid));
> +    }
> +
> +    int main() {
> +        int epfd, vmgenfd;
> +        struct epoll_event ev;
> +
> +        epfd = epoll_create(EPOLL_QUEUE_LEN);
> +
> +        vmgenfd = open("/dev/vmgenid",
> +                       O_RDWR | O_CLOEXEC | O_NONBLOCK,
> +                       S_IRUSR | S_IWUSR);
> +
> +        // register vmgenid for polling
> +        ev.events = EPOLLIN;
> +        ev.data.fd = vmgenfd;
> +        epoll_ctl(epfd, EPOLL_CTL_ADD, vmgenfd, &ev);
> +
> +        // register other parts of your app for polling
> +        // ...
> +
> +        while (1) {
> +            // wait for something to do...
> +            int nfds = epoll_wait(epfd, events,
> +                MAX_EPOLL_EVENTS_PER_RUN,
> +                EPOLL_RUN_TIMEOUT);
> +            if (nfds < 0) die("Error in epoll_wait!");
> +
> +            // for each ready fd
> +            for(int i = 0; i < nfds; i++) {
> +                int fd = events[i].data.fd;
> +
> +                if (fd == vmgenfd)
> +                    handle_io_on_vmgenfd(vmgenfd);
> +                else
> +                    handle_some_other_part_of_the_app(fd);
> +            }
> +        }
> +
> +        return 0;
> +    }
> +
> +3) Mapped memory polling simplified example::
> +
> +    /*
> +     * app/library function that provides cached secrets
> +     */
> +    char * safe_cached_secret(app_data_t *app)
> +    {
> +        char *secret;
> +        volatile unsigned *const genid_ptr = get_vmgenid_mapping(app);
> +    again:
> +        secret = __cached_secret(app);
> +
> +        if (unlikely(*genid_ptr != app->cached_genid)) {
> +            // rebuild world then confirm the genid update (thru write)
> +            rebuild_caches(app);
> +
> +            app->cached_genid = *genid_ptr;
> +            ack_vmgenid_update(app);
> +
> +            goto again;
> +        }
> +
> +        return secret;
> +    }
> +
> +4) Orchestrator simplified example::
> +
> +    /*
> +     * orchestrator - manages multiple apps and libraries used by a service
> +     * and tries to make sure all sensitive components gracefully handle
> +     * VM generation changes.
> +     * Following function is called on detection of a VM generation change.
> +     */
> +    int handle_vmgen_update(int vmgen_fd, unsigned new_gen_id)
> +    {
> +        // pause until all components have handled event
> +        pause_service();
> +
> +        // confirm *this* watcher as up-to-date
> +        write(vmgen_fd, &new_gen_id, sizeof(unsigned));
> +
> +        // wait for all *others* for at most 5 seconds.
> +        ioctl(vmgen_fd, VMGENID_WAIT_WATCHERS, 5000);
> +
> +        // all apps on the system have rebuilt worlds
> +        resume_service();
> +    }
> diff --git a/drivers/virt/Kconfig b/drivers/virt/Kconfig
> index 80c5f9c1..5d5f37b 100644
> --- a/drivers/virt/Kconfig
> +++ b/drivers/virt/Kconfig
> @@ -13,6 +13,23 @@ menuconfig VIRT_DRIVERS
>  
>  if VIRT_DRIVERS
>  
> +config VMGENID
> +    tristate "Virtual Machine Generation ID driver"
> +    depends on ACPI

I think this is not needed. We have /dev/vmgenid regardless of ACPI
device for container usecase and we may have a different HW emulation
for s390 and PowerPC.

> +    default N
> +    help
> +      This is a Virtual Machine Generation ID driver which provides
> +      a virtual machine generation counter. The driver exposes FS ops
> +      on /dev/vmgenid through which it can provide information and
> +      notifications on VM generation changes that happen on snapshots
> +      or cloning.
> +      This enables applications and libraries that store or cache
> +      sensitive information, to know that they need to regenerate it
> +      after process memory has been exposed to potential copying.
> +
> +      To compile this driver as a module, choose M here: the
> +      module will be called vmgenid.
> +
>  config FSL_HV_MANAGER
>      tristate "Freescale hypervisor management driver"
>      depends on FSL_SOC
> diff --git a/drivers/virt/Makefile b/drivers/virt/Makefile
> index f28425c..889be01 100644
> --- a/drivers/virt/Makefile
> +++ b/drivers/virt/Makefile
> @@ -4,6 +4,7 @@
>  #
>  
>  obj-$(CONFIG_FSL_HV_MANAGER)    += fsl_hypervisor.o
> +obj-$(CONFIG_VMGENID)        += vmgenid.o
>  obj-y                += vboxguest/
>  
>  obj-$(CONFIG_NITRO_ENCLAVES)    += nitro_enclaves/
> diff --git a/drivers/virt/vmgenid.c b/drivers/virt/vmgenid.c
> new file mode 100644
> index 0000000..c4d4683
> --- /dev/null
> +++ b/drivers/virt/vmgenid.c
> @@ -0,0 +1,435 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Virtual Machine Generation ID driver
> + *
> + * Copyright (C) 2018 Red Hat Inc. All rights reserved.
> + *
> + * Copyright (C) 2020 Amazon. All rights reserved.
> + *
> + *    Authors:
> + *      Adrian Catangiu <acatan@amazon.com>
> + *      Or Idgar <oridgar@gmail.com>
> + *      Gal Hammer <ghammer@redhat.com>
> + *
> + */
> +#include <linux/acpi.h>
> +#include <linux/kernel.h>
> +#include <linux/miscdevice.h>
> +#include <linux/mm.h>
> +#include <linux/module.h>
> +#include <linux/poll.h>
> +#include <linux/random.h>
> +#include <linux/uuid.h>
> +#include <linux/vmgenid.h>
> +
> +#define DEV_NAME "vmgenid"
> +ACPI_MODULE_NAME(DEV_NAME);
> +
> +struct acpi_data {
> +    uuid_t uuid;
> +    void   *uuid_iomap;
> +};
> +
> +struct driver_data {

I'd suggest vmgenid_data

> +    unsigned long     map_buf;

We use tab=8 for indentation. Please run your patch though
scripts/checkpatch.pl to make sure it conforms the coding style.

> +    wait_queue_head_t read_waitq;
> +    atomic_t          generation_counter;
> +
> +    unsigned int      watchers;
> +    atomic_t          outdated_watchers;
> +    wait_queue_head_t outdated_waitq;
> +    spinlock_t        lock;
> +
> +    struct acpi_data  *acpi_data;
> +};
> +struct driver_data driver_data;

static 

> +
> +struct file_data {
> +    unsigned int acked_gen_counter;
> +};
> +
> +static int equals_gen_counter(unsigned int counter)
> +{
> +    return counter == atomic_read(&driver_data.generation_counter);
> +}
> +
> +static void vmgenid_bump_generation(void)
> +{
> +    unsigned long flags;
> +    int counter;
> +
> +    spin_lock_irqsave(&driver_data.lock, flags);
> +    counter = atomic_inc_return(&driver_data.generation_counter);
> +    *((int *) driver_data.map_buf) = counter;
> +    atomic_set(&driver_data.outdated_watchers, driver_data.watchers);
> +
> +    wake_up_interruptible(&driver_data.read_waitq);
> +    wake_up_interruptible(&driver_data.outdated_waitq);
> +    spin_unlock_irqrestore(&driver_data.lock, flags);
> +}
> +
> +static void vmgenid_put_outdated_watchers(void)
> +{
> +    if (atomic_dec_and_test(&driver_data.outdated_watchers))
> +        wake_up_interruptible(&driver_data.outdated_waitq);
> +}
> +
> +static int vmgenid_open(struct inode *inode, struct file *file)
> +{
> +    struct file_data *fdata = kzalloc(sizeof(struct file_data),
> GFP_KERNEL);
> +    unsigned long flags;
> +
> +    if (!fdata)
> +        return -ENOMEM;
> +
> +    spin_lock_irqsave(&driver_data.lock, flags);
> +    fdata->acked_gen_counter =
> atomic_read(&driver_data.generation_counter);
> +    ++driver_data.watchers;
> +    spin_unlock_irqrestore(&driver_data.lock, flags);
> +
> +    file->private_data = fdata;
> +
> +    return 0;
> +}
> +
> +static int vmgenid_close(struct inode *inode, struct file *file)
> +{
> +    struct file_data *fdata = file->private_data;
> +    unsigned long flags;
> +
> +    spin_lock_irqsave(&driver_data.lock, flags);
> +    if (!equals_gen_counter(fdata->acked_gen_counter))
> +        vmgenid_put_outdated_watchers();
> +    --driver_data.watchers;
> +    spin_unlock_irqrestore(&driver_data.lock, flags);
> +
> +    kfree(fdata);
> +
> +    return 0;
> +}
> +
> +static ssize_t
> +vmgenid_read(struct file *file, char __user *ubuf, size_t nbytes,

Please keep the function name at the same line as return type and wrap
parameters to the next line.

> loff_t *ppos)
> +{
> +    struct file_data *fdata = file->private_data;
> +    ssize_t ret;
> +    int gen_counter;
> +
> +    if (nbytes == 0)
> +        return 0;
> +    /* disallow partial reads */
> +    if (nbytes < sizeof(gen_counter))
> +        return -EINVAL;
> +
> +    if (equals_gen_counter(fdata->acked_gen_counter)) {
> +        if (file->f_flags & O_NONBLOCK)
> +            return -EAGAIN;
> +        ret = wait_event_interruptible(
> +            driver_data.read_waitq,
> +            !equals_gen_counter(fdata->acked_gen_counter)
> +        );
> +        if (ret)
> +            return ret;
> +    }
> +
> +    gen_counter = atomic_read(&driver_data.generation_counter);
> +    ret = copy_to_user(ubuf, &gen_counter, sizeof(gen_counter));
> +    if (ret)
> +        return -EFAULT;
> +
> +    return sizeof(gen_counter);
> +}
> +
> +static ssize_t vmgenid_write(struct file *file, const char __user *ubuf,
> +                size_t count, loff_t *ppos)
> +{
> +    struct file_data *fdata = file->private_data;
> +    unsigned int new_acked_gen;
> +    unsigned long flags;
> +
> +    /* disallow partial writes */
> +    if (count != sizeof(new_acked_gen))
> +        return -EINVAL;
> +    if (copy_from_user(&new_acked_gen, ubuf, count))
> +        return -EFAULT;
> +
> +    spin_lock_irqsave(&driver_data.lock, flags);
> +    /* wrong gen-counter acknowledged */
> +    if (!equals_gen_counter(new_acked_gen)) {
> +        spin_unlock_irqrestore(&driver_data.lock, flags);
> +        return -EINVAL;
> +    }
> +    if (!equals_gen_counter(fdata->acked_gen_counter)) {
> +        fdata->acked_gen_counter = new_acked_gen;
> +        vmgenid_put_outdated_watchers();
> +    }
> +    spin_unlock_irqrestore(&driver_data.lock, flags);
> +
> +    return (ssize_t)count;
> +}
> +
> +static __poll_t
> +vmgenid_poll(struct file *file, poll_table *wait)
> +{
> +    __poll_t mask = 0;
> +    struct file_data *fdata = file->private_data;
> +
> +    if (!equals_gen_counter(fdata->acked_gen_counter))
> +        return EPOLLIN | EPOLLRDNORM;
> +
> +    poll_wait(file, &driver_data.read_waitq, wait);
> +
> +    if (!equals_gen_counter(fdata->acked_gen_counter))
> +        mask = EPOLLIN | EPOLLRDNORM;
> +
> +    return mask;
> +}
> +
> +static long vmgenid_ioctl(struct file *file,
> +        unsigned int cmd, unsigned long arg)
> +{
> +    struct file_data *fdata = file->private_data;
> +    unsigned long timeout_ns;
> +    ktime_t until;
> +    int ret = 0;
> +
> +    switch (cmd) {
> +    case VMGENID_GET_OUTDATED_WATCHERS:
> +        ret = atomic_read(&driver_data.outdated_watchers);
> +        break;
> +    case VMGENID_WAIT_WATCHERS:
> +        timeout_ns = arg * NSEC_PER_MSEC;
> +        until = timeout_ns ? ktime_set(0, timeout_ns) : KTIME_MAX;
> +
> +        ret = wait_event_interruptible_hrtimeout(
> +            driver_data.outdated_waitq,
> +            (!atomic_read(&driver_data.outdated_watchers) ||
> +                    !equals_gen_counter(fdata->acked_gen_counter)),
> +            until
> +        );
> +        if (atomic_read(&driver_data.outdated_watchers))
> +            ret = -EINTR;
> +        else
> +            ret = 0;
> +        break;
> +    case VMGENID_FORCE_GEN_UPDATE:
> +        if (!checkpoint_restore_ns_capable(current_user_ns()))
> +            return -EACCES;
> +        vmgenid_bump_generation();
> +        break;
> +    default:
> +        ret = -EINVAL;
> +        break;
> +    }
> +    return ret;
> +}
> +
> +static int vmgenid_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +    struct file_data *fdata = file->private_data;
> +
> +    if (vma->vm_pgoff != 0 || vma_pages(vma) > 1)
> +        return -EINVAL;
> +
> +    if ((vma->vm_flags & VM_WRITE) != 0)
> +        return -EPERM;
> +
> +    vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
> +    vma->vm_flags &= ~VM_MAYWRITE;
> +    vma->vm_private_data = fdata;
> +
> +    return vm_insert_page(vma, vma->vm_start,
> +                          virt_to_page(driver_data.map_buf));
> +}
> +
> +static const struct file_operations fops = {
> +    .owner          = THIS_MODULE,
> +    .mmap           = vmgenid_mmap,
> +    .open           = vmgenid_open,
> +    .release        = vmgenid_close,
> +    .read           = vmgenid_read,
> +    .write          = vmgenid_write,
> +    .poll           = vmgenid_poll,
> +    .unlocked_ioctl = vmgenid_ioctl,
> +};
> +
> +struct miscdevice vmgenid_misc = {

static

> +    .minor = MISC_DYNAMIC_MINOR,
> +    .name = "vmgenid",
> +    .fops = &fops,
> +};
> +
> +static int vmgenid_acpi_map(struct acpi_data *priv, acpi_handle handle)
> +{
> +    int i;
> +    phys_addr_t phys_addr;
> +    struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> +    acpi_status status;
> +    union acpi_object *pss;
> +    union acpi_object *element;
> +
> +    status = acpi_evaluate_object(handle, "ADDR", NULL, &buffer);
> +    if (ACPI_FAILURE(status)) {
> +        ACPI_EXCEPTION((AE_INFO, status, "Evaluating ADDR"));
> +        return -ENODEV;
> +    }
> +    pss = buffer.pointer;
> +    if (!pss || pss->type != ACPI_TYPE_PACKAGE || pss->package.count != 2)
> +        return -EINVAL;
> +
> +    phys_addr = 0;
> +    for (i = 0; i < pss->package.count; i++) {
> +        element = &(pss->package.elements[i]);
> +        if (element->type != ACPI_TYPE_INTEGER)
> +            return -EINVAL;
> +        phys_addr |= element->integer.value << i * 32;
> +    }
> +
> +    priv->uuid_iomap = acpi_os_map_memory(phys_addr, sizeof(uuid_t));
> +    if (!priv->uuid_iomap) {
> +        pr_err("Could not map memory at 0x%llx, size %u\n",
> +               phys_addr,
> +               (u32) sizeof(uuid_t));
> +        return -ENOMEM;
> +    }
> +
> +    memcpy_fromio(&priv->uuid, priv->uuid_iomap, sizeof(uuid_t));
> +
> +    return 0;
> +}
> +
> +static int vmgenid_acpi_add(struct acpi_device *device)
> +{
> +    int ret;
> +
> +    if (!device)
> +        return -EINVAL;
> +
> +    driver_data.acpi_data = kzalloc(sizeof(struct acpi_data), GFP_KERNEL);
> +    if (!driver_data.acpi_data) {
> +        pr_err("vmgenid: failed to allocate acpi_data\n");
> +        return -ENOMEM;
> +    }
> +    device->driver_data = &driver_data;
> +
> +    ret = vmgenid_acpi_map(driver_data.acpi_data, device->handle);
> +    if (ret < 0) {
> +        pr_err("vmgenid: failed to map acpi device\n");
> +        goto err;
> +    }
> +
> +    return 0;
> +
> +err:
> +    kfree(driver_data.acpi_data);
> +    driver_data.acpi_data = NULL;
> +
> +    return ret;
> +}
> +
> +static int vmgenid_acpi_remove(struct acpi_device *device)
> +{
> +    struct acpi_data *priv;
> +
> +    if (!device || !acpi_driver_data(device))
> +        return -EINVAL;
> +
> +    device->driver_data = NULL;
> +    priv = driver_data.acpi_data;
> +    driver_data.acpi_data = NULL;
> +
> +    if (priv && priv->uuid_iomap)
> +        acpi_os_unmap_memory(priv->uuid_iomap, sizeof(uuid_t));
> +    kfree(priv);
> +
> +    return 0;
> +}
> +
> +static void vmgenid_acpi_notify(struct acpi_device *device, u32 event)
> +{
> +    struct acpi_data *priv;
> +    uuid_t old_uuid;
> +
> +    if (!device || !acpi_driver_data(device)) {
> +        pr_err("VMGENID notify with NULL private data\n");
> +        return;
> +    }
> +    priv = driver_data.acpi_data;
> +
> +    /* update VM Generation UUID */
> +    old_uuid = priv->uuid;
> +    memcpy_fromio(&priv->uuid, priv->uuid_iomap, sizeof(uuid_t));
> +
> +    if (memcmp(&old_uuid, &priv->uuid, sizeof(uuid_t))) {
> +        /* HW uuid updated */
> +        vmgenid_bump_generation();
> +        add_device_randomness(&priv->uuid, sizeof(uuid_t));
> +    }
> +}
> +
> +static const struct acpi_device_id vmgenid_ids[] = {
> +    {"QEMUVGID", 0},
> +    {"", 0},
> +};
> +
> +static struct acpi_driver acpi_vmgenid_driver = {
> +    .name = "vm_generation_id",
> +    .ids = vmgenid_ids,
> +    .owner = THIS_MODULE,
> +    .ops = {
> +        .add = vmgenid_acpi_add,
> +        .remove = vmgenid_acpi_remove,
> +        .notify = vmgenid_acpi_notify,
> +    }
> +};
> +
> +static int __init vmgenid_init(void)
> +{
> +    int ret;
> +
> +    driver_data.map_buf = get_zeroed_page(GFP_KERNEL);
> +    if (!driver_data.map_buf)
> +        return -ENOMEM;
> +
> +    atomic_set(&driver_data.generation_counter, 0);
> +    atomic_set(&driver_data.outdated_watchers, 0);
> +    init_waitqueue_head(&driver_data.read_waitq);
> +    init_waitqueue_head(&driver_data.outdated_waitq);
> +    spin_lock_init(&driver_data.lock);
> +    driver_data.acpi_data = NULL;
> +
> +    ret = misc_register(&vmgenid_misc);
> +    if (ret < 0) {
> +        pr_err("misc_register() failed for vmgenid\n");
> +        goto err;
> +    }
> +
> +    ret = acpi_bus_register_driver(&acpi_vmgenid_driver);
> +    if (ret < 0)
> +        pr_warn("No vmgenid acpi device found\n");

I think this needs to be reworked to support no-ACPI version. For
instance we can call here something like

	ret = vmgenid_hw_register();

and have 

#ifdef CONFIG_ACPI
static int vmgenid_hw_register(void)
{
	return acpi_bus_register_driver(&acpi_vmgenid_driver);
}
#else
static int vmgenid_hw_register(void)
{
	return 0;
}
#endif

> +
> +    return 0;
> +
> +err:
> +    free_pages(driver_data.map_buf, 0);
> +    driver_data.map_buf = 0;
> +
> +    return ret;
> +}
> +
> +static void __exit vmgenid_exit(void)
> +{
> +    acpi_bus_unregister_driver(&acpi_vmgenid_driver);
> +
> +    misc_deregister(&vmgenid_misc);
> +    free_pages(driver_data.map_buf, 0);
> +    driver_data.map_buf = 0;
> +}
> +
> +module_init(vmgenid_init);
> +module_exit(vmgenid_exit);
> +
> +MODULE_AUTHOR("Adrian Catangiu");
> +MODULE_DESCRIPTION("Virtual Machine Generation ID");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION("0.1");
> diff --git a/include/uapi/linux/vmgenid.h b/include/uapi/linux/vmgenid.h
> new file mode 100644
> index 0000000..9316b00
> --- /dev/null
> +++ b/include/uapi/linux/vmgenid.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> +
> +#ifndef _UAPI_LINUX_VMGENID_H
> +#define _UAPI_LINUX_VMGENID_H
> +
> +#include <linux/ioctl.h>
> +
> +#define VMGENID_IOCTL 0x2d
> +#define VMGENID_GET_OUTDATED_WATCHERS _IO(VMGENID_IOCTL, 1)
> +#define VMGENID_WAIT_WATCHERS         _IO(VMGENID_IOCTL, 2)
> +#define VMGENID_FORCE_GEN_UPDATE      _IO(VMGENID_IOCTL, 3)
> +
> +#endif /* _UAPI_LINUX_VMGENID_H */
> +
> -- 
> 2.7.4
> 

-- 
Sincerely yours,
Mike.
