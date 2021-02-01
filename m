Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7CC30ADC0
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 18:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhBAR0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 12:26:52 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:19576 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbhBAR0i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 12:26:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1612200395; x=1643736395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=6XZVkuKV3mgPC5hyMw49kI7JAdzbX6z3meX2yRYqchI=;
  b=I/EX7xN9Z7HNdaUnL622qxfGGRolheRqU8kw5+3GH4KAv3+EpGIGOcIL
   pu/pAIDocPpty1bLO45JPTyRaolhvVdcTj7qcXudBiWK5oYlMGn3w6AVX
   tVXvuJjI1A2GEVTBiRRqWkufqVBvn2bmVXzzeTwiCcljJnjWY2LGcvrKU
   Y=;
X-IronPort-AV: E=Sophos;i="5.79,393,1602547200"; 
   d="scan'208";a="79082184"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 01 Feb 2021 17:25:43 +0000
Received: from EX13D08EUB004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id A9841A2701;
        Mon,  1 Feb 2021 17:25:39 +0000 (UTC)
Received: from uf6ed9c851f4556.ant.amazon.com (10.43.161.253) by
 EX13D08EUB004.ant.amazon.com (10.43.166.158) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Feb 2021 17:25:24 +0000
From:   Adrian Catangiu <acatan@amazon.com>
To:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <graf@amazon.com>,
        <rdunlap@infradead.org>, <arnd@arndb.de>, <ebiederm@xmission.com>,
        <rppt@kernel.org>, <0x7f454c46@gmail.com>,
        <borntraeger@de.ibm.com>, <Jason@zx2c4.com>, <jannh@google.com>,
        <w@1wt.eu>, <colmmacc@amazon.com>, <luto@kernel.org>,
        <tytso@mit.edu>, <ebiggers@kernel.org>, <dwmw@amazon.co.uk>,
        <bonzini@gnu.org>, <sblbir@amazon.com>, <raduweis@amazon.com>,
        <corbet@lwn.net>, <mst@redhat.com>, <mhocko@kernel.org>,
        <rafael@kernel.org>, <pavel@ucw.cz>, <mpe@ellerman.id.au>,
        <areber@redhat.com>, <ovzxemul@gmail.com>, <avagin@gmail.com>,
        <ptikhomirov@virtuozzo.com>, <gil@azul.com>, <asmehra@redhat.com>,
        <dgunigun@redhat.com>, <vijaysun@ca.ibm.com>, <oridgar@gmail.com>,
        <ghammer@redhat.com>, Adrian Catangiu <acatan@amazon.com>
Subject: [PATCH v5 1/2] drivers/misc: sysgenid: add system generation id driver
Date:   Mon, 1 Feb 2021 19:24:53 +0200
Message-ID: <1612200294-17561-2-git-send-email-acatan@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612200294-17561-1-git-send-email-acatan@amazon.com>
References: <1612200294-17561-1-git-send-email-acatan@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D24UWB002.ant.amazon.com (10.43.161.159) To
 EX13D08EUB004.ant.amazon.com (10.43.166.158)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Background and problem

The System Generation ID feature is required in virtualized or
containerized environments by applications that work with local copies
or caches of world-unique data such as random values, uuids,
monotonically increasing counters, etc.
Such applications can be negatively affected by VM or container
snapshotting when the VM or container is either cloned or returned to
an earlier point in time.

Furthermore, simply finding out about a system generation change is
only the starting point of a process to renew internal states of
possibly multiple applications across the system. This process could
benefit from a driver that provides an interface through which
orchestration can be easily done.

- Solution

The System Generation ID is a simple concept meant to alleviate the
issue by providing a monotonically increasing u32 counter that changes
each time the VM or container is restored from a snapshot.

The `sysgenid` driver exposes a monotonic incremental System Generation
u32 counter via a char-dev FS interface that provides sync and async
SysGen counter updates notifications. It also provides SysGen counter
retrieval and confirmation mechanisms.

The counter starts from zero when the driver is initialized and
monotonically increments every time the system generation changes.

The `sysgenid` driver exports the `void sysgenid_bump_generation()`
symbol which can be used by backend drivers to drive system generation
changes based on hardware events.
System generation changes can also be driven by userspace software
through a dedicated driver ioctl.

Userspace applications or libraries can then (a)synchronously consume
the system generation counter through the provided FS interface to make
any necessary internal adjustments following a system generation
update.

Signed-off-by: Adrian Catangiu <acatan@amazon.com>
---
 Documentation/misc-devices/sysgenid.rst            | 236 ++++++++++++++++
 Documentation/userspace-api/ioctl/ioctl-number.rst |   1 +
 MAINTAINERS                                        |   8 +
 drivers/misc/Kconfig                               |  16 ++
 drivers/misc/Makefile                              |   1 +
 drivers/misc/sysgenid.c                            | 307 +++++++++++++++++++++
 include/uapi/linux/sysgenid.h                      |  17 ++
 7 files changed, 586 insertions(+)
 create mode 100644 Documentation/misc-devices/sysgenid.rst
 create mode 100644 drivers/misc/sysgenid.c
 create mode 100644 include/uapi/linux/sysgenid.h

diff --git a/Documentation/misc-devices/sysgenid.rst b/Documentation/misc-devices/sysgenid.rst
new file mode 100644
index 0000000..4337ca0
--- /dev/null
+++ b/Documentation/misc-devices/sysgenid.rst
@@ -0,0 +1,236 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+========
+SYSGENID
+========
+
+The System Generation ID feature is required in virtualized or
+containerized environments by applications that work with local copies
+or caches of world-unique data such as random values, UUIDs,
+monotonically increasing counters, etc.
+Such applications can be negatively affected by VM or container
+snapshotting when the VM or container is either cloned or returned to
+an earlier point in time.
+
+The System Generation ID is a simple concept meant to alleviate the
+issue by providing a monotonically increasing counter that changes
+each time the VM or container is restored from a snapshot.
+The driver for it lives at ``drivers/misc/sysgenid.c``.
+
+The ``sysgenid`` driver exposes a monotonic incremental System
+Generation u32 counter via a char-dev FS interface accessible through
+``/dev/sysgenid`` that provides sync and async SysGen counter update
+notifications. It also provides SysGen counter retrieval and
+confirmation mechanisms.
+
+The counter starts from zero when the driver is initialized and
+monotonically increments every time the system generation changes.
+
+The ``sysgenid`` driver exports the ``void sysgenid_bump_generation()``
+symbol which can be used by backend drivers to drive system generation
+changes based on hardware events.
+System generation changes can also be driven by userspace software
+through a dedicated driver ioctl.
+
+Userspace applications or libraries can (a)synchronously consume the
+system generation counter through the provided FS interface, to make
+any necessary internal adjustments following a system generation update.
+
+Driver FS interface:
+
+``open()``:
+  When the device is opened, a copy of the current Sys-Gen-Id (counter)
+  is associated with the open file descriptor. The driver now tracks
+  this file as an independent *watcher*. The driver tracks how many
+  watchers are aware of the latest Sys-Gen-Id counter and how many of
+  them are *outdated*; outdated being those that have lived through
+  a Sys-Gen-Id change but not yet confirmed the new generation counter.
+
+``read()``:
+  Read is meant to provide the *new* system generation counter when a
+  generation change takes place. The read operation blocks until the
+  associated counter is no longer up to date, at which point the new
+  counter is provided/returned.
+  Nonblocking ``read()`` uses ``EAGAIN`` to signal that there is no
+  *new* counter value available. The generation counter is considered
+  *new* for each open file descriptor that hasn't confirmed the new
+  value following a generation change. Therefore, once a generation
+  change takes place, all ``read()`` calls will immediately return the
+  new generation counter and will continue to do so until the
+  new value is confirmed back to the driver through ``write()``.
+  Partial reads are not allowed - read buffer needs to be at least
+  32 bits in size.
+
+``write()``:
+  Write is used to confirm the up-to-date Sys Gen counter back to the
+  driver.
+  Following a VM generation change, all existing watchers are marked
+  as *outdated*. Each file descriptor will maintain the *outdated*
+  status until a ``write()`` confirms the up-to-date counter back to
+  the driver.
+  Partial writes are not allowed - write buffer should be exactly
+  32 bits in size.
+
+``poll()``:
+  Poll is implemented to allow polling for generation counter updates.
+  Such updates result in ``EPOLLIN`` polling status until the new
+  up-to-date counter is confirmed back to the driver through a
+  ``write()``.
+
+``ioctl()``:
+  The driver also adds support for waiting on open file descriptors
+  that haven't acknowledged a generation counter update, as well as a
+  mechanism for userspace to *force* a generation update:
+
+  - SYSGENID_WAIT_WATCHERS: blocks until there are no more *outdated*
+    watchers, or if a ``timeout`` argument is provided, until the
+    timeout expires.
+    If the current caller is *outdated* or a generation change happens
+    while waiting (thus making current caller *outdated*), the ioctl
+    returns ``-EINTR`` to signal the user to handle event and retry.
+  - SYSGENID_FORCE_GEN_UPDATE: forces a generation counter increment.
+    It takes a ``minimum-generation`` argument which represents the
+    minimum value the generation counter will be incremented to. For
+    example if current generation is ``5`` and ``SYSGENID_FORCE_GEN_UPDATE(8)``
+    is called, the generation counter will increment to ``8``.
+    This IOCTL can only be used by processes with CAP_CHECKPOINT_RESTORE
+    or CAP_SYS_ADMIN capabilities.
+
+``mmap()``:
+  The driver supports ``PROT_READ, MAP_SHARED`` mmaps of a single page
+  in size. The first 4 bytes of the mapped page will contain an
+  up-to-date u32 copy of the system generation counter.
+  The mapped memory can be used as a low-latency generation counter
+  probe mechanism in critical sections - see examples.
+
+``close()``:
+  Removes the file descriptor as a system generation counter *watcher*.
+
+Example application workflows
+-----------------------------
+
+1) Watchdog thread simplified example::
+
+	void watchdog_thread_handler(int *thread_active)
+	{
+		unsigned int genid;
+		int fd = open("/dev/sysgenid", O_RDWR | O_CLOEXEC, S_IRUSR | S_IWUSR);
+
+		do {
+			// read new gen ID - blocks until VM generation changes
+			read(fd, &genid, sizeof(genid));
+
+			// because of VM generation change, we need to rebuild world
+			reseed_app_env();
+
+			// confirm we're done handling gen ID update
+			write(fd, &genid, sizeof(genid));
+		} while (atomic_read(thread_active));
+
+		close(fd);
+	}
+
+2) ASYNC simplified example::
+
+	void handle_io_on_sysgenfd(int sysgenfd)
+	{
+		unsigned int genid;
+
+		// read new gen ID - we need it to confirm we've handled update
+		read(fd, &genid, sizeof(genid));
+
+		// because of VM generation change, we need to rebuild world
+		reseed_app_env();
+
+		// confirm we're done handling the gen ID update
+		write(fd, &genid, sizeof(genid));
+	}
+
+	int main() {
+		int epfd, sysgenfd;
+		struct epoll_event ev;
+
+		epfd = epoll_create(EPOLL_QUEUE_LEN);
+
+		sysgenfd = open("/dev/sysgenid",
+		               O_RDWR | O_CLOEXEC | O_NONBLOCK,
+		               S_IRUSR | S_IWUSR);
+
+		// register sysgenid for polling
+		ev.events = EPOLLIN;
+		ev.data.fd = sysgenfd;
+		epoll_ctl(epfd, EPOLL_CTL_ADD, sysgenfd, &ev);
+
+		// register other parts of your app for polling
+		// ...
+
+		while (1) {
+			// wait for something to do...
+			int nfds = epoll_wait(epfd, events,
+				MAX_EPOLL_EVENTS_PER_RUN,
+				EPOLL_RUN_TIMEOUT);
+			if (nfds < 0) die("Error in epoll_wait!");
+
+			// for each ready fd
+			for(int i = 0; i < nfds; i++) {
+				int fd = events[i].data.fd;
+
+				if (fd == sysgenfd)
+					handle_io_on_sysgenfd(sysgenfd);
+				else
+					handle_some_other_part_of_the_app(fd);
+			}
+		}
+
+		return 0;
+	}
+
+3) Mapped memory polling simplified example::
+
+	/*
+	 * app/library function that provides cached secrets
+	 */
+	char * safe_cached_secret(app_data_t *app)
+	{
+		char *secret;
+		volatile unsigned int *const genid_ptr = get_sysgenid_mapping(app);
+	again:
+		secret = __cached_secret(app);
+
+		if (unlikely(*genid_ptr != app->cached_genid)) {
+			app->cached_genid = *genid_ptr;
+			barrier();
+
+			// rebuild world then confirm the genid update (thru write)
+			rebuild_caches(app);
+
+			ack_sysgenid_update(app);
+
+			goto again;
+		}
+
+		return secret;
+	}
+
+4) Orchestrator simplified example::
+
+	/*
+	 * orchestrator - manages multiple applications and libraries used by
+	 * a service and tries to make sure all sensitive components gracefully
+	 * handle VM generation changes.
+	 * Following function is called on detection of a VM generation change.
+	 */
+	int handle_sysgen_update(int sysgen_fd, unsigned int new_gen_id)
+	{
+		// pause until all components have handled event
+		pause_service();
+
+		// confirm *this* watcher as up-to-date
+		write(sysgen_fd, &new_gen_id, sizeof(unsigned int));
+
+		// wait for all *others* for at most 5 seconds.
+		ioctl(sysgen_fd, VMGENID_WAIT_WATCHERS, 5000);
+
+		// all applications on the system have rebuilt worlds
+		resume_service();
+	}
diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index a4c75a2..d74fed4 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -356,6 +356,7 @@ Code  Seq#    Include File                                           Comments
 0xDB  00-0F  drivers/char/mwave/mwavepub.h
 0xDD  00-3F                                                          ZFCP device driver see drivers/s390/scsi/
                                                                      <mailto:aherrman@de.ibm.com>
+0xE4  01-02  uapi/linux/sysgenid.h                                   SysGenID misc driver
 0xE5  00-3F  linux/fuse.h
 0xEC  00-01  drivers/platform/chrome/cros_ec_dev.h                   ChromeOS EC driver
 0xF3  00-3F  drivers/usb/misc/sisusbvga/sisusb.h                     sisfb (in development)
diff --git a/MAINTAINERS b/MAINTAINERS
index d3e847f..f1158b0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17203,6 +17203,14 @@ L:	linux-mmc@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/sdhci-pci-dwc-mshc.c
 
+SYSGENID
+M:	Adrian Catangiu <acatan@amazon.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	Documentation/misc-devices/sysgenid.rst
+F:	drivers/misc/sysgenid.c
+F:	include/uapi/linux/sysgenid.h
+
 SYSTEM CONFIGURATION (SYSCON)
 M:	Lee Jones <lee.jones@linaro.org>
 M:	Arnd Bergmann <arnd@arndb.de>
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index fafa8b0..931d716 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -456,6 +456,22 @@ config PVPANIC
 	  a paravirtualized device provided by QEMU; it lets a virtual machine
 	  (guest) communicate panic events to the host.
 
+config SYSGENID
+	tristate "System Generation ID driver"
+	default N
+	help
+	  This is a System Generation ID driver which provides a system
+	  generation counter. The driver exposes FS ops on /dev/sysgenid
+	  through which it can provide information and notifications on system
+	  generation changes that happen because of VM or container snapshots
+	  or cloning.
+	  This enables applications and libraries that store or cache
+	  sensitive information, to know that they need to regenerate it
+	  after process memory has been exposed to potential copying.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sysgenid.
+
 config HISI_HIKEY_USB
 	tristate "USB GPIO Hub on HiSilicon Hikey 960/970 Platform"
 	depends on (OF && GPIOLIB) || COMPILE_TEST
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index d23231e..4b4933d 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_HABANA_AI)		+= habanalabs/
 obj-$(CONFIG_UACCE)		+= uacce/
 obj-$(CONFIG_XILINX_SDFEC)	+= xilinx_sdfec.o
 obj-$(CONFIG_HISI_HIKEY_USB)	+= hisi_hikey_usb.o
+obj-$(CONFIG_SYSGENID)		+= sysgenid.o
diff --git a/drivers/misc/sysgenid.c b/drivers/misc/sysgenid.c
new file mode 100644
index 0000000..95b3421
--- /dev/null
+++ b/drivers/misc/sysgenid.c
@@ -0,0 +1,307 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * System Generation ID driver
+ *
+ * Copyright (C) 2020 Amazon. All rights reserved.
+ *
+ *	Authors:
+ *	  Adrian Catangiu <acatan@amazon.com>
+ *
+ */
+#include <linux/acpi.h>
+#include <linux/kernel.h>
+#include <linux/minmax.h>
+#include <linux/miscdevice.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/poll.h>
+#include <linux/random.h>
+#include <linux/uuid.h>
+#include <linux/sysgenid.h>
+
+struct sysgenid_data {
+	unsigned long		map_buf;
+	wait_queue_head_t	read_waitq;
+	atomic_t		generation_counter;
+
+	unsigned int		watchers;
+	atomic_t		outdated_watchers;
+	wait_queue_head_t	outdated_waitq;
+	spinlock_t		lock;
+};
+static struct sysgenid_data sysgenid_data;
+
+struct file_data {
+	unsigned int acked_gen_counter;
+};
+
+static void sysgenid_uevent(unsigned int gen_counter);
+
+static int equals_gen_counter(unsigned int counter)
+{
+	return counter == atomic_read(&sysgenid_data.generation_counter);
+}
+
+static void _bump_generation(int min_gen)
+{
+	unsigned long flags;
+	int counter;
+
+	spin_lock_irqsave(&sysgenid_data.lock, flags);
+	counter = max(min_gen, 1 + atomic_read(&sysgenid_data.generation_counter));
+	atomic_set(&sysgenid_data.generation_counter, counter);
+	*((int *) sysgenid_data.map_buf) = counter;
+	atomic_set(&sysgenid_data.outdated_watchers, sysgenid_data.watchers);
+
+	wake_up_interruptible(&sysgenid_data.read_waitq);
+	wake_up_interruptible(&sysgenid_data.outdated_waitq);
+	spin_unlock_irqrestore(&sysgenid_data.lock, flags);
+
+	sysgenid_uevent(counter);
+}
+
+void sysgenid_bump_generation(void)
+{
+	_bump_generation(0);
+}
+EXPORT_SYMBOL(sysgenid_bump_generation);
+
+static void put_outdated_watchers(void)
+{
+	if (atomic_dec_and_test(&sysgenid_data.outdated_watchers))
+		wake_up_interruptible(&sysgenid_data.outdated_waitq);
+}
+
+static int sysgenid_open(struct inode *inode, struct file *file)
+{
+	struct file_data *fdata = kzalloc(sizeof(struct file_data), GFP_KERNEL);
+	unsigned long flags;
+
+	if (!fdata)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&sysgenid_data.lock, flags);
+	fdata->acked_gen_counter = atomic_read(&sysgenid_data.generation_counter);
+	++sysgenid_data.watchers;
+	spin_unlock_irqrestore(&sysgenid_data.lock, flags);
+
+	file->private_data = fdata;
+
+	return 0;
+}
+
+static int sysgenid_close(struct inode *inode, struct file *file)
+{
+	struct file_data *fdata = file->private_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sysgenid_data.lock, flags);
+	if (!equals_gen_counter(fdata->acked_gen_counter))
+		put_outdated_watchers();
+	--sysgenid_data.watchers;
+	spin_unlock_irqrestore(&sysgenid_data.lock, flags);
+
+	kfree(fdata);
+
+	return 0;
+}
+
+static ssize_t sysgenid_read(struct file *file, char __user *ubuf,
+							 size_t nbytes, loff_t *ppos)
+{
+	struct file_data *fdata = file->private_data;
+	ssize_t ret;
+	int gen_counter;
+
+	if (nbytes == 0)
+		return 0;
+	/* disallow partial reads */
+	if (nbytes < sizeof(gen_counter))
+		return -EINVAL;
+
+	if (equals_gen_counter(fdata->acked_gen_counter)) {
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+		ret = wait_event_interruptible(
+			sysgenid_data.read_waitq,
+			!equals_gen_counter(fdata->acked_gen_counter)
+		);
+		if (ret)
+			return ret;
+	}
+
+	gen_counter = atomic_read(&sysgenid_data.generation_counter);
+	ret = copy_to_user(ubuf, &gen_counter, sizeof(gen_counter));
+	if (ret)
+		return -EFAULT;
+
+	return sizeof(gen_counter);
+}
+
+static ssize_t sysgenid_write(struct file *file, const char __user *ubuf,
+							  size_t count, loff_t *ppos)
+{
+	struct file_data *fdata = file->private_data;
+	unsigned int new_acked_gen;
+	unsigned long flags;
+
+	/* disallow partial writes */
+	if (count != sizeof(new_acked_gen))
+		return -EINVAL;
+	if (copy_from_user(&new_acked_gen, ubuf, count))
+		return -EFAULT;
+
+	spin_lock_irqsave(&sysgenid_data.lock, flags);
+	/* wrong gen-counter acknowledged */
+	if (!equals_gen_counter(new_acked_gen)) {
+		spin_unlock_irqrestore(&sysgenid_data.lock, flags);
+		return -EINVAL;
+	}
+	if (!equals_gen_counter(fdata->acked_gen_counter)) {
+		fdata->acked_gen_counter = new_acked_gen;
+		put_outdated_watchers();
+	}
+	spin_unlock_irqrestore(&sysgenid_data.lock, flags);
+
+	return (ssize_t)count;
+}
+
+static __poll_t sysgenid_poll(struct file *file, poll_table *wait)
+{
+	__poll_t mask = 0;
+	struct file_data *fdata = file->private_data;
+
+	if (!equals_gen_counter(fdata->acked_gen_counter))
+		return EPOLLIN | EPOLLRDNORM;
+
+	poll_wait(file, &sysgenid_data.read_waitq, wait);
+
+	if (!equals_gen_counter(fdata->acked_gen_counter))
+		mask = EPOLLIN | EPOLLRDNORM;
+
+	return mask;
+}
+
+static long sysgenid_ioctl(struct file *file,
+						   unsigned int cmd, unsigned long arg)
+{
+	struct file_data *fdata = file->private_data;
+	unsigned long timeout_ns, min_gen;
+	ktime_t until;
+	int ret = 0;
+
+	switch (cmd) {
+	case SYSGENID_WAIT_WATCHERS:
+		timeout_ns = arg * NSEC_PER_MSEC;
+		until = timeout_ns ? ktime_set(0, timeout_ns) : KTIME_MAX;
+
+		ret = wait_event_interruptible_hrtimeout(
+			sysgenid_data.outdated_waitq,
+			(!atomic_read(&sysgenid_data.outdated_watchers) ||
+					!equals_gen_counter(fdata->acked_gen_counter)),
+			until
+		);
+		break;
+	case SYSGENID_FORCE_GEN_UPDATE:
+		if (!checkpoint_restore_ns_capable(current_user_ns()))
+			return -EACCES;
+		min_gen = arg;
+		_bump_generation(min_gen);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int sysgenid_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct file_data *fdata = file->private_data;
+
+	if (vma->vm_pgoff != 0 || vma_pages(vma) > 1)
+		return -EINVAL;
+
+	if ((vma->vm_flags & VM_WRITE) != 0)
+		return -EPERM;
+
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_flags &= ~VM_MAYWRITE;
+	vma->vm_private_data = fdata;
+
+	return vm_insert_page(vma, vma->vm_start,
+						  virt_to_page(sysgenid_data.map_buf));
+}
+
+static const struct file_operations fops = {
+	.owner		= THIS_MODULE,
+	.mmap		= sysgenid_mmap,
+	.open		= sysgenid_open,
+	.release	= sysgenid_close,
+	.read		= sysgenid_read,
+	.write		= sysgenid_write,
+	.poll		= sysgenid_poll,
+	.unlocked_ioctl	= sysgenid_ioctl,
+};
+
+static struct miscdevice sysgenid_misc = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "sysgenid",
+	.fops = &fops,
+};
+
+static void sysgenid_uevent(unsigned int gen_counter)
+{
+	char event_string[22];
+	char *envp[] = { event_string, NULL };
+	struct device *dev = sysgenid_misc.this_device;
+
+	if (dev) {
+		sprintf(event_string, "SYSGENID=%u", gen_counter);
+		kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
+	}
+}
+
+static int __init sysgenid_init(void)
+{
+	int ret;
+
+	sysgenid_data.map_buf = get_zeroed_page(GFP_KERNEL);
+	if (!sysgenid_data.map_buf)
+		return -ENOMEM;
+
+	atomic_set(&sysgenid_data.generation_counter, 0);
+	atomic_set(&sysgenid_data.outdated_watchers, 0);
+	init_waitqueue_head(&sysgenid_data.read_waitq);
+	init_waitqueue_head(&sysgenid_data.outdated_waitq);
+	spin_lock_init(&sysgenid_data.lock);
+
+	ret = misc_register(&sysgenid_misc);
+	if (ret < 0) {
+		pr_err("misc_register() failed for sysgenid\n");
+		goto err;
+	}
+
+	return 0;
+
+err:
+	free_pages(sysgenid_data.map_buf, 0);
+	sysgenid_data.map_buf = 0;
+
+	return ret;
+}
+
+static void __exit sysgenid_exit(void)
+{
+	misc_deregister(&sysgenid_misc);
+	free_pages(sysgenid_data.map_buf, 0);
+	sysgenid_data.map_buf = 0;
+}
+
+module_init(sysgenid_init);
+module_exit(sysgenid_exit);
+
+MODULE_AUTHOR("Adrian Catangiu");
+MODULE_DESCRIPTION("System Generation ID");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.1");
diff --git a/include/uapi/linux/sysgenid.h b/include/uapi/linux/sysgenid.h
new file mode 100644
index 0000000..ba370c8
--- /dev/null
+++ b/include/uapi/linux/sysgenid.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+
+#ifndef _UAPI_LINUX_SYSGENID_H
+#define _UAPI_LINUX_SYSGENID_H
+
+#include <linux/ioctl.h>
+
+#define SYSGENID_IOCTL			0xE4
+#define SYSGENID_WAIT_WATCHERS		_IO(SYSGENID_IOCTL, 1)
+#define SYSGENID_FORCE_GEN_UPDATE	_IO(SYSGENID_IOCTL, 2)
+
+#ifdef __KERNEL__
+void sysgenid_bump_generation(void);
+#endif /* __KERNEL__ */
+
+#endif /* _UAPI_LINUX_SYSGENID_H */
+
-- 
2.7.4




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

