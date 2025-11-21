Return-Path: <kvm+bounces-64121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D838C78FCC
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 13:16:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 3108B2B63E
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 12:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6EA34C9B7;
	Fri, 21 Nov 2025 12:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OE+VOLIR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6208134CFA1
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 12:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763727297; cv=none; b=Sts5rdtp7go4drciHARAyqLDY4deHfyFsgkibtyqXGzergjExJW9He0tZKqF9fTk0jp/70TwvMIY19Yxm+5UhwDkeA3Xx6J20BWW8whZnqbtd06GGUnQEVf1kna87O2qBdy1G33fcQ1D80MH4RRKUfVxBnQZ9QeRJ+uNcPOnTQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763727297; c=relaxed/simple;
	bh=L06zqv+wVNjlc94EILZlvfo1/OyBGCCt/PJgD+Lm8U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EakHSlODLnq07E1PbS/vNmmeOte57jXEcwqa98aHgXb7kx7GdGuiMmbReIjX4ozoKWBpQjJ7ci7KEKoek+IFltJm2tSpYNB1vA+6WHfg+6p0CCAUnmIojhFCf4JmKTV1vMHyaLrheToAwW57FuW49N5wdJQYzPyWMzqTNBg96hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OE+VOLIR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763727294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C9+n4YIkHnh2mbMl8vw6pyQd6cuiMoiXUxhhscAry0s=;
	b=OE+VOLIRC8MuTeJv7x8h6vYwOnRbTQ1bpzjQo97YbvoI5/WJtVQnXKGRdG7J2Y+RnuVTKJ
	WKx7BrY35V8wvBySF2WFYXwSVtifSfZa+Ser/+fgXuuSLrNbRYko9zLjUAhhggblhMk3+e
	5OXMFkjolXhBAN1GI0nC02QfM9T4fog=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-120-Sv5pPRFTM0qJToJsn2kRMw-1; Fri,
 21 Nov 2025 07:14:51 -0500
X-MC-Unique: Sv5pPRFTM0qJToJsn2kRMw-1
X-Mimecast-MFC-AGG-ID: Sv5pPRFTM0qJToJsn2kRMw_1763727287
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C02061800447;
	Fri, 21 Nov 2025 12:14:46 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B54FE1956045;
	Fri, 21 Nov 2025 12:14:45 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id CB99D21EC344; Fri, 21 Nov 2025 13:14:38 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: arei.gonglei@huawei.com,
	zhenwei.pi@linux.dev,
	alistair.francis@wdc.com,
	stefanb@linux.vnet.ibm.com,
	kwolf@redhat.com,
	hreitz@redhat.com,
	sw@weilnetz.de,
	qemu_oss@crudebyte.com,
	groug@kaod.org,
	mst@redhat.com,
	imammedo@redhat.com,
	anisinha@redhat.com,
	kraxel@redhat.com,
	shentey@gmail.com,
	npiggin@gmail.com,
	harshpb@linux.ibm.com,
	sstabellini@kernel.org,
	anthony@xenproject.org,
	paul@xen.org,
	edgar.iglesias@gmail.com,
	elena.ufimtseva@oracle.com,
	jag.raman@oracle.com,
	sgarzare@redhat.com,
	pbonzini@redhat.com,
	fam@euphon.net,
	philmd@linaro.org,
	alex@shazbot.org,
	clg@redhat.com,
	peterx@redhat.com,
	farosas@suse.de,
	lizhijian@fujitsu.com,
	dave@treblig.org,
	jasowang@redhat.com,
	samuel.thibault@ens-lyon.org,
	michael.roth@amd.com,
	kkostiuk@redhat.com,
	zhao1.liu@intel.com,
	mtosatti@redhat.com,
	rathc@linux.ibm.com,
	palmer@dabbelt.com,
	liwei1518@gmail.com,
	dbarboza@ventanamicro.com,
	zhiwei_liu@linux.alibaba.com,
	marcandre.lureau@redhat.com,
	qemu-block@nongnu.org,
	qemu-ppc@nongnu.org,
	xen-devel@lists.xenproject.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org
Subject: [PATCH v2 13/15] error: Use error_setg_errno() for simplicity and consistency
Date: Fri, 21 Nov 2025 13:14:36 +0100
Message-ID: <20251121121438.1249498-14-armbru@redhat.com>
In-Reply-To: <20251121121438.1249498-1-armbru@redhat.com>
References: <20251121121438.1249498-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Use error_setg_errno() instead of passing the value of strerror() or
g_strerror() to error_setg().

The separator between the error message proper and the value of
strerror() changes from " : ", "", " - ", "- " to ": " in places.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 backends/spdm-socket.c      |  4 ++--
 backends/tpm/tpm_emulator.c | 13 +++++--------
 hw/9pfs/9p.c                |  3 +--
 hw/acpi/core.c              |  3 +--
 hw/intc/openpic_kvm.c       |  3 +--
 hw/intc/xics_kvm.c          |  5 +++--
 hw/remote/vfio-user-obj.c   | 18 +++++++++---------
 hw/sensor/emc141x.c         |  4 ++--
 hw/sensor/tmp421.c          |  4 ++--
 hw/smbios/smbios.c          |  4 ++--
 hw/virtio/vdpa-dev.c        |  4 ++--
 migration/postcopy-ram.c    | 10 +++++-----
 net/slirp.c                 |  5 +++--
 qga/commands-posix-ssh.c    | 23 +++++++++++++----------
 system/vl.c                 |  2 +-
 target/ppc/kvm.c            |  5 ++---
 16 files changed, 54 insertions(+), 56 deletions(-)

diff --git a/backends/spdm-socket.c b/backends/spdm-socket.c
index 6d8f02d3b9..a12bc47f77 100644
--- a/backends/spdm-socket.c
+++ b/backends/spdm-socket.c
@@ -167,7 +167,7 @@ int spdm_socket_connect(uint16_t port, Error **errp)
 
     client_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
     if (client_socket < 0) {
-        error_setg(errp, "cannot create socket: %s", strerror(errno));
+        error_setg_errno(errp, errno, "cannot create socket");
         return -1;
     }
 
@@ -179,7 +179,7 @@ int spdm_socket_connect(uint16_t port, Error **errp)
 
     if (connect(client_socket, (struct sockaddr *)&server_addr,
                 sizeof(server_addr)) < 0) {
-        error_setg(errp, "cannot connect: %s", strerror(errno));
+        error_setg_errno(errp, errno, "cannot connect");
         close(client_socket);
         return -1;
     }
diff --git a/backends/tpm/tpm_emulator.c b/backends/tpm/tpm_emulator.c
index f10b9074fb..f52cb4d435 100644
--- a/backends/tpm/tpm_emulator.c
+++ b/backends/tpm/tpm_emulator.c
@@ -225,8 +225,7 @@ static int tpm_emulator_set_locality(TPMEmulator *tpm_emu, uint8_t locty_number,
     if (tpm_emulator_ctrlcmd(tpm_emu, CMD_SET_LOCALITY, &loc,
                              sizeof(loc), sizeof(loc.u.resp.tpm_result),
                              sizeof(loc)) < 0) {
-        error_setg(errp, "tpm-emulator: could not set locality : %s",
-                   strerror(errno));
+        error_setg_errno(errp, errno, "tpm-emulator: could not set locality");
         return -1;
     }
 
@@ -315,8 +314,7 @@ static int tpm_emulator_stop_tpm(TPMBackend *tb, Error **errp)
 
     if (tpm_emulator_ctrlcmd(tpm_emu, CMD_STOP, &res, 0,
                              sizeof(ptm_res), sizeof(res)) < 0) {
-        error_setg(errp, "tpm-emulator: Could not stop TPM: %s",
-                   strerror(errno));
+        error_setg_errno(errp, errno, "tpm-emulator: Could not stop TPM");
         return -1;
     }
 
@@ -377,8 +375,8 @@ static int tpm_emulator_set_buffer_size(TPMBackend *tb,
     if (tpm_emulator_ctrlcmd(tpm_emu, CMD_SET_BUFFERSIZE, &psbs,
                              sizeof(psbs.u.req), sizeof(psbs.u.resp.tpm_result),
                              sizeof(psbs.u.resp)) < 0) {
-        error_setg(errp, "tpm-emulator: Could not set buffer size: %s",
-                   strerror(errno));
+        error_setg_errno(errp, errno,
+                         "tpm-emulator: Could not set buffer size");
         return -1;
     }
 
@@ -426,8 +424,7 @@ static int tpm_emulator_startup_tpm_resume(TPMBackend *tb, size_t buffersize,
     if (tpm_emulator_ctrlcmd(tpm_emu, CMD_INIT, &init, sizeof(init),
                              sizeof(init.u.resp.tpm_result),
                              sizeof(init)) < 0) {
-        error_setg(errp, "tpm-emulator: could not send INIT: %s",
-                   strerror(errno));
+        error_setg_errno(errp, errno, "tpm-emulator: could not send INIT");
         goto err_exit;
     }
 
diff --git a/hw/9pfs/9p.c b/hw/9pfs/9p.c
index bc4a016ee3..6fbe604ce8 100644
--- a/hw/9pfs/9p.c
+++ b/hw/9pfs/9p.c
@@ -4345,8 +4345,7 @@ int v9fs_device_realize_common(V9fsState *s, const V9fsTransport *t,
      * use co-routines here.
      */
     if (s->ops->name_to_path(&s->ctx, NULL, "/", &path) < 0) {
-        error_setg(errp,
-                   "error in converting name to path %s", strerror(errno));
+        error_setg_errno(errp, errno, "error in converting name to path");
         goto out;
     }
     if (s->ops->lstat(&s->ctx, &path, &stat)) {
diff --git a/hw/acpi/core.c b/hw/acpi/core.c
index d2677332af..82974eb257 100644
--- a/hw/acpi/core.c
+++ b/hw/acpi/core.c
@@ -293,8 +293,7 @@ void acpi_table_add(const QemuOpts *opts, Error **errp)
                 memcpy(blob + bloblen, data, r);
                 bloblen += r;
             } else if (errno != EINTR) {
-                error_setg(errp, "can't read file %s: %s", *cur,
-                           strerror(errno));
+                error_setg_errno(errp, errno, "can't read file %s", *cur);
                 close(fd);
                 goto out;
             }
diff --git a/hw/intc/openpic_kvm.c b/hw/intc/openpic_kvm.c
index 673ea9ca05..0c11bbc963 100644
--- a/hw/intc/openpic_kvm.c
+++ b/hw/intc/openpic_kvm.c
@@ -223,8 +223,7 @@ static void kvm_openpic_realize(DeviceState *dev, Error **errp)
     cd.type = kvm_openpic_model;
     ret = kvm_vm_ioctl(s, KVM_CREATE_DEVICE, &cd);
     if (ret < 0) {
-        error_setg(errp, "Can't create device %d: %s",
-                   cd.type, strerror(errno));
+        error_setg_errno(errp, errno, "Can't create device %d", cd.type);
         return;
     }
     opp->fd = cd.fd;
diff --git a/hw/intc/xics_kvm.c b/hw/intc/xics_kvm.c
index ee72969f5f..61f66d1019 100644
--- a/hw/intc/xics_kvm.c
+++ b/hw/intc/xics_kvm.c
@@ -165,8 +165,9 @@ void icp_kvm_realize(DeviceState *dev, Error **errp)
     if (ret < 0) {
         Error *local_err = NULL;
 
-        error_setg(&local_err, "Unable to connect CPU%ld to kernel XICS: %s",
-                   vcpu_id, strerror(errno));
+        error_setg_errno(&local_err, errno,
+                         "Unable to connect CPU%ld to kernel XICS",
+                         vcpu_id);
         if (errno == ENOSPC) {
             error_append_hint(&local_err, "Try -smp maxcpus=N with N < %u\n",
                               MACHINE(qdev_get_machine())->smp.max_cpus);
diff --git a/hw/remote/vfio-user-obj.c b/hw/remote/vfio-user-obj.c
index 216b4876e2..24c0088f63 100644
--- a/hw/remote/vfio-user-obj.c
+++ b/hw/remote/vfio-user-obj.c
@@ -751,7 +751,7 @@ static void vfu_object_init_ctx(VfuObject *o, Error **errp)
                                 LIBVFIO_USER_FLAG_ATTACH_NB,
                                 o, VFU_DEV_TYPE_PCI);
     if (o->vfu_ctx == NULL) {
-        error_setg(errp, "vfu: Failed to create context - %s", strerror(errno));
+        error_setg_errno(errp, errno, "vfu: Failed to create context");
         return;
     }
 
@@ -776,9 +776,9 @@ static void vfu_object_init_ctx(VfuObject *o, Error **errp)
 
     ret = vfu_pci_init(o->vfu_ctx, pci_type, PCI_HEADER_TYPE_NORMAL, 0);
     if (ret < 0) {
-        error_setg(errp,
-                   "vfu: Failed to attach PCI device %s to context - %s",
-                   o->device, strerror(errno));
+        error_setg_errno(errp, errno,
+                         "vfu: Failed to attach PCI device %s to context",
+                         o->device);
         goto fail;
     }
 
@@ -792,9 +792,9 @@ static void vfu_object_init_ctx(VfuObject *o, Error **errp)
                            VFU_REGION_FLAG_RW | VFU_REGION_FLAG_ALWAYS_CB,
                            NULL, 0, -1, 0);
     if (ret < 0) {
-        error_setg(errp,
-                   "vfu: Failed to setup config space handlers for %s- %s",
-                   o->device, strerror(errno));
+        error_setg_errno(errp, errno,
+                         "vfu: Failed to setup config space handlers for %s",
+                         o->device);
         goto fail;
     }
 
@@ -822,8 +822,8 @@ static void vfu_object_init_ctx(VfuObject *o, Error **errp)
 
     ret = vfu_realize_ctx(o->vfu_ctx);
     if (ret < 0) {
-        error_setg(errp, "vfu: Failed to realize device %s- %s",
-                   o->device, strerror(errno));
+        error_setg_errno(errp, errno, "vfu: Failed to realize device %s",
+                         o->device);
         goto fail;
     }
 
diff --git a/hw/sensor/emc141x.c b/hw/sensor/emc141x.c
index 7b2ce383a1..a51fc44395 100644
--- a/hw/sensor/emc141x.c
+++ b/hw/sensor/emc141x.c
@@ -59,7 +59,7 @@ static void emc141x_get_temperature(Object *obj, Visitor *v, const char *name,
     unsigned tempid;
 
     if (sscanf(name, "temperature%u", &tempid) != 1) {
-        error_setg(errp, "error reading %s: %s", name, g_strerror(errno));
+        error_setg_errno(errp, errno, "error reading %s", name);
         return;
     }
 
@@ -86,7 +86,7 @@ static void emc141x_set_temperature(Object *obj, Visitor *v, const char *name,
     }
 
     if (sscanf(name, "temperature%u", &tempid) != 1) {
-        error_setg(errp, "error reading %s: %s", name, g_strerror(errno));
+        error_setg_errno(errp, errno, "error reading %s", name);
         return;
     }
 
diff --git a/hw/sensor/tmp421.c b/hw/sensor/tmp421.c
index 3421c44086..127edd0ba5 100644
--- a/hw/sensor/tmp421.c
+++ b/hw/sensor/tmp421.c
@@ -117,7 +117,7 @@ static void tmp421_get_temperature(Object *obj, Visitor *v, const char *name,
     int tempid;
 
     if (sscanf(name, "temperature%d", &tempid) != 1) {
-        error_setg(errp, "error reading %s: %s", name, g_strerror(errno));
+        error_setg_errno(errp, errno, "error reading %s", name);
         return;
     }
 
@@ -154,7 +154,7 @@ static void tmp421_set_temperature(Object *obj, Visitor *v, const char *name,
     }
 
     if (sscanf(name, "temperature%d", &tempid) != 1) {
-        error_setg(errp, "error reading %s: %s", name, g_strerror(errno));
+        error_setg_errno(errp, errno, "error reading %s", name);
         return;
     }
 
diff --git a/hw/smbios/smbios.c b/hw/smbios/smbios.c
index 7558b2ad83..b228f9eb85 100644
--- a/hw/smbios/smbios.c
+++ b/hw/smbios/smbios.c
@@ -1281,8 +1281,8 @@ static int save_opt_one(void *opaque,
                 break;
             }
             if (ret < 0) {
-                error_setg(errp, "Unable to read from %s: %s",
-                           value, strerror(errno));
+                error_setg_errno(errp, errno, "Unable to read from %s",
+                                 value);
                 qemu_close(fd);
                 return -1;
             }
diff --git a/hw/virtio/vdpa-dev.c b/hw/virtio/vdpa-dev.c
index 4a7b970976..f97d576171 100644
--- a/hw/virtio/vdpa-dev.c
+++ b/hw/virtio/vdpa-dev.c
@@ -41,8 +41,8 @@ vhost_vdpa_device_get_u32(int fd, unsigned long int cmd, Error **errp)
     uint32_t val = (uint32_t)-1;
 
     if (ioctl(fd, cmd, &val) < 0) {
-        error_setg(errp, "vhost-vdpa-device: cmd 0x%lx failed: %s",
-                   cmd, strerror(errno));
+        error_setg_errno(errp, errno, "vhost-vdpa-device: cmd 0x%lx failed",
+                         cmd);
     }
 
     return val;
diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
index 3f98dcb6fd..5454372ac6 100644
--- a/migration/postcopy-ram.c
+++ b/migration/postcopy-ram.c
@@ -582,7 +582,7 @@ bool postcopy_ram_supported_by_host(MigrationIncomingState *mis, Error **errp)
 
     ufd = uffd_open(O_CLOEXEC);
     if (ufd == -1) {
-        error_setg(errp, "Userfaultfd not available: %s", strerror(errno));
+        error_setg_errno(errp, errno, "Userfaultfd not available");
         goto out;
     }
 
@@ -620,7 +620,7 @@ bool postcopy_ram_supported_by_host(MigrationIncomingState *mis, Error **errp)
      * it was enabled.
      */
     if (munlockall()) {
-        error_setg(errp, "munlockall() failed: %s", strerror(errno));
+        error_setg_errno(errp, errno, "munlockall() failed");
         goto out;
     }
 
@@ -632,7 +632,7 @@ bool postcopy_ram_supported_by_host(MigrationIncomingState *mis, Error **errp)
     testarea = mmap(NULL, pagesize, PROT_READ | PROT_WRITE, MAP_PRIVATE |
                                     MAP_ANONYMOUS, -1, 0);
     if (testarea == MAP_FAILED) {
-        error_setg(errp, "Failed to map test area: %s", strerror(errno));
+        error_setg_errno(errp, errno, "Failed to map test area");
         goto out;
     }
     g_assert(QEMU_PTR_IS_ALIGNED(testarea, pagesize));
@@ -642,14 +642,14 @@ bool postcopy_ram_supported_by_host(MigrationIncomingState *mis, Error **errp)
     reg_struct.mode = UFFDIO_REGISTER_MODE_MISSING;
 
     if (ioctl(ufd, UFFDIO_REGISTER, &reg_struct)) {
-        error_setg(errp, "UFFDIO_REGISTER failed: %s", strerror(errno));
+        error_setg_errno(errp, errno, "UFFDIO_REGISTER failed");
         goto out;
     }
 
     range_struct.start = (uintptr_t)testarea;
     range_struct.len = pagesize;
     if (ioctl(ufd, UFFDIO_UNREGISTER, &range_struct)) {
-        error_setg(errp, "UFFDIO_UNREGISTER failed: %s", strerror(errno));
+        error_setg_errno(errp, errno, "UFFDIO_UNREGISTER failed");
         goto out;
     }
 
diff --git a/net/slirp.c b/net/slirp.c
index 5996fec512..04925f3318 100644
--- a/net/slirp.c
+++ b/net/slirp.c
@@ -1020,8 +1020,9 @@ static int slirp_smb(SlirpState* s, const char *exported_dir,
     }
 
     if (access(exported_dir, R_OK | X_OK)) {
-        error_setg(errp, "Error accessing shared directory '%s': %s",
-                   exported_dir, strerror(errno));
+        error_setg_errno(errp, errno,
+                         "Error accessing shared directory '%s'",
+                         exported_dir);
         return -1;
     }
 
diff --git a/qga/commands-posix-ssh.c b/qga/commands-posix-ssh.c
index 246171d323..661972e34e 100644
--- a/qga/commands-posix-ssh.c
+++ b/qga/commands-posix-ssh.c
@@ -61,20 +61,22 @@ mkdir_for_user(const char *path, const struct passwd *p,
                mode_t mode, Error **errp)
 {
     if (g_mkdir(path, mode) == -1) {
-        error_setg(errp, "failed to create directory '%s': %s",
-                   path, g_strerror(errno));
+        error_setg_errno(errp, errno, "failed to create directory '%s'",
+                         path);
         return false;
     }
 
     if (chown(path, p->pw_uid, p->pw_gid) == -1) {
-        error_setg(errp, "failed to set ownership of directory '%s': %s",
-                   path, g_strerror(errno));
+        error_setg_errno(errp, errno,
+                         "failed to set ownership of directory '%s'",
+                         path);
         return false;
     }
 
     if (chmod(path, mode) == -1) {
-        error_setg(errp, "failed to set permissions of directory '%s': %s",
-                   path, g_strerror(errno));
+        error_setg_errno(errp, errno,
+                         "failed to set permissions of directory '%s'",
+                         path);
         return false;
     }
 
@@ -95,14 +97,15 @@ write_authkeys(const char *path, const GStrv keys,
     }
 
     if (chown(path, p->pw_uid, p->pw_gid) == -1) {
-        error_setg(errp, "failed to set ownership of directory '%s': %s",
-                   path, g_strerror(errno));
+        error_setg_errno(errp, errno,
+                         "failed to set ownership of directory '%s'",
+                         path);
         return false;
     }
 
     if (chmod(path, 0600) == -1) {
-        error_setg(errp, "failed to set permissions of '%s': %s",
-                   path, g_strerror(errno));
+        error_setg_errno(errp, errno, "failed to set permissions of '%s'",
+                         path);
         return false;
     }
 
diff --git a/system/vl.c b/system/vl.c
index 5091fe52d9..2ef5b4b3b2 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -619,7 +619,7 @@ static int parse_add_fd(void *opaque, QemuOpts *opts, Error **errp)
     }
 #endif
     if (dupfd == -1) {
-        error_setg(errp, "error duplicating fd: %s", strerror(errno));
+        error_setg_errno(errp, errno, "error duplicating fd");
         return -1;
     }
 
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 43124bf1c7..3501b5d546 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2699,9 +2699,8 @@ int kvmppc_get_htab_fd(bool write, uint64_t index, Error **errp)
 
     ret = kvm_vm_ioctl(kvm_state, KVM_PPC_GET_HTAB_FD, &s);
     if (ret < 0) {
-        error_setg(errp, "Unable to open fd for %s HPT %s KVM: %s",
-                   write ? "writing" : "reading", write ? "to" : "from",
-                   strerror(errno));
+        error_setg_errno(errp, errno, "Unable to open fd for %s HPT %s KVM",
+                   write ? "writing" : "reading", write ? "to" : "from");
         return -errno;
     }
 
-- 
2.49.0


