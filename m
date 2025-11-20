Return-Path: <kvm+bounces-63977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D8FC7C7608C
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 20:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 004BF4E199C
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 19:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E4C369202;
	Thu, 20 Nov 2025 19:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IBtxIOgy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEAE369235
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 19:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763666039; cv=none; b=NlR7ARflSf+y5BYdcg/00ovASOpZXWH5+Xg2N8n/KplE9B9P4To4Y+Vi/j5+ncxWDF/qkJWMmRE1SPxVShz0GBZ96gPTtGv8ZPa2YmUxfSor54bDC4LPEKRTCPOPGXBv89pFea5nJupUFM05eUs8UzEo3nbJta387a3EwBvM4cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763666039; c=relaxed/simple;
	bh=skTPORwT+VoLjHJdNQtpTplsT9qdEzRmYhtKSaHQcg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=As0//Z3y58qQ+GJoEmK70le3TkeHYSya5GwgSUckE41cZxKAaeqiVShEq4TOhYnlEF2WLqgOUE9jzQ9pE6AGI87xSt9QYqoIfWVQ2QWo/U2YSrc9mYb2pZp/2t3pFbDzqK+K49Grw7vpNjNuyBkPQJAKG29/O9muQcb6z/GMXZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IBtxIOgy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763666036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CbU8I1LM6zZzOVsePXRVxUmmgivtAGdqM7VPg9VNZ8o=;
	b=IBtxIOgyRc1GMgxAlX+Ca7L1M4BERot6Nb4fHw5vaw7C9xamBLOj5iBUBEZ+78zWXoDZXR
	Rno/mn/KnmPr3TaNulDpzkgxm2fSjzCQeU+PczLeHh93wclwew0LizNA0UqCuccvuF/PFY
	j5gB3KiODa4LqY+P0qzldjGVE37Burk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-HrIvBS7YNXey3loTidWDQQ-1; Thu,
 20 Nov 2025 14:13:52 -0500
X-MC-Unique: HrIvBS7YNXey3loTidWDQQ-1
X-Mimecast-MFC-AGG-ID: HrIvBS7YNXey3loTidWDQQ_1763666027
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E64191955F22;
	Thu, 20 Nov 2025 19:13:46 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9DA31940E88;
	Thu, 20 Nov 2025 19:13:45 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 717FA21E65DC; Thu, 20 Nov 2025 20:13:39 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: arei.gonglei@huawei.com,
	pizhenwei@bytedance.com,
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
Subject: [PATCH 09/14] error: Use error_setg_file_open() for simplicity and consistency
Date: Thu, 20 Nov 2025 20:13:34 +0100
Message-ID: <20251120191339.756429-10-armbru@redhat.com>
In-Reply-To: <20251120191339.756429-1-armbru@redhat.com>
References: <20251120191339.756429-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Replace

    error_setg_errno(errp, errno, MSG, FNAME);

by

    error_setg_file_open(errp, errno, FNAME);

where MSG is "Could not open '%s'" or similar.

Also replace equivalent uses of error_setg().

A few messages lose prefixes ("net dump: ", "SEV: ", __func__ ": ").
We could put them back with error_prepend().  Not worth the bother.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 hw/9pfs/9p-local.c        | 2 +-
 hw/acpi/core.c            | 2 +-
 hw/core/loader.c          | 2 +-
 hw/pci-host/xen_igd_pt.c  | 2 +-
 monitor/hmp-cmds-target.c | 2 +-
 net/dump.c                | 2 +-
 net/tap-bsd.c             | 6 +++---
 net/tap-linux.c           | 2 +-
 target/i386/sev.c         | 6 ++----
 ui/ui-qmp-cmds.c          | 3 +--
 util/vfio-helpers.c       | 5 ++---
 11 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/hw/9pfs/9p-local.c b/hw/9pfs/9p-local.c
index 31e216227c..376b377698 100644
--- a/hw/9pfs/9p-local.c
+++ b/hw/9pfs/9p-local.c
@@ -1456,7 +1456,7 @@ static int local_init(FsContext *ctx, Error **errp)
 
     data->mountfd = open(ctx->fs_root, O_DIRECTORY | O_RDONLY);
     if (data->mountfd == -1) {
-        error_setg_errno(errp, errno, "failed to open '%s'", ctx->fs_root);
+        error_setg_file_open(errp, errno, ctx->fs_root);
         goto err;
     }
 
diff --git a/hw/acpi/core.c b/hw/acpi/core.c
index ff16582803..d2677332af 100644
--- a/hw/acpi/core.c
+++ b/hw/acpi/core.c
@@ -277,7 +277,7 @@ void acpi_table_add(const QemuOpts *opts, Error **errp)
         int fd = open(*cur, O_RDONLY | O_BINARY);
 
         if (fd < 0) {
-            error_setg(errp, "can't open file %s: %s", *cur, strerror(errno));
+            error_setg_file_open(errp, errno, *cur);
             goto out;
         }
 
diff --git a/hw/core/loader.c b/hw/core/loader.c
index 590c5b02aa..b56e5eb2f5 100644
--- a/hw/core/loader.c
+++ b/hw/core/loader.c
@@ -379,7 +379,7 @@ void load_elf_hdr(const char *filename, void *hdr, bool *is64, Error **errp)
 
     fd = open(filename, O_RDONLY | O_BINARY);
     if (fd < 0) {
-        error_setg_errno(errp, errno, "Failed to open file: %s", filename);
+        error_setg_file_open(errp, errno, filename);
         return;
     }
     if (read(fd, hdr, EI_NIDENT) != EI_NIDENT) {
diff --git a/hw/pci-host/xen_igd_pt.c b/hw/pci-host/xen_igd_pt.c
index 5dd17ef236..f6016f2cd5 100644
--- a/hw/pci-host/xen_igd_pt.c
+++ b/hw/pci-host/xen_igd_pt.c
@@ -55,7 +55,7 @@ static void host_pci_config_read(int pos, int len, uint32_t *val, Error **errp)
 
     config_fd = open(path, O_RDWR);
     if (config_fd < 0) {
-        error_setg_errno(errp, errno, "Failed to open: %s", path);
+        error_setg_file_open(errp, errno, path);
         goto out;
     }
 
diff --git a/monitor/hmp-cmds-target.c b/monitor/hmp-cmds-target.c
index e982061146..ad4ed2167d 100644
--- a/monitor/hmp-cmds-target.c
+++ b/monitor/hmp-cmds-target.c
@@ -331,7 +331,7 @@ static uint64_t vtop(void *ptr, Error **errp)
 
     fd = open("/proc/self/pagemap", O_RDONLY);
     if (fd == -1) {
-        error_setg_errno(errp, errno, "Cannot open /proc/self/pagemap");
+        error_setg_file_open(errp, errno, "/proc/self/pagemap");
         return -1;
     }
 
diff --git a/net/dump.c b/net/dump.c
index 581234b775..0c39f09892 100644
--- a/net/dump.c
+++ b/net/dump.c
@@ -111,7 +111,7 @@ static int net_dump_state_init(DumpState *s, const char *filename,
 
     fd = open(filename, O_CREAT | O_TRUNC | O_WRONLY | O_BINARY, 0644);
     if (fd < 0) {
-        error_setg_errno(errp, errno, "net dump: can't open %s", filename);
+        error_setg_file_open(errp, errno, filename);
         return -1;
     }
 
diff --git a/net/tap-bsd.c b/net/tap-bsd.c
index bbf84d1828..3fd300d46f 100644
--- a/net/tap-bsd.c
+++ b/net/tap-bsd.c
@@ -68,7 +68,7 @@ int tap_open(char *ifname, int ifname_size, int *vnet_hdr,
         }
     }
     if (fd < 0) {
-        error_setg_errno(errp, errno, "could not open %s", dname);
+        error_setg_file_open(errp, errno, dname);
         return -1;
     }
 
@@ -118,7 +118,7 @@ static int tap_open_clone(char *ifname, int ifname_size, Error **errp)
 
     fd = RETRY_ON_EINTR(open(PATH_NET_TAP, O_RDWR));
     if (fd < 0) {
-        error_setg_errno(errp, errno, "could not open %s", PATH_NET_TAP);
+        error_setg_file_open(errp, errno, PATH_NET_TAP);
         return -1;
     }
 
@@ -166,7 +166,7 @@ int tap_open(char *ifname, int ifname_size, int *vnet_hdr,
         snprintf(dname, sizeof dname, "/dev/%s", ifname);
         fd = RETRY_ON_EINTR(open(dname, O_RDWR));
         if (fd < 0 && errno != ENOENT) {
-            error_setg_errno(errp, errno, "could not open %s", dname);
+            error_setg_file_open(errp, errno, dname);
             return -1;
         }
     }
diff --git a/net/tap-linux.c b/net/tap-linux.c
index 2a90b58467..909c4f1fcf 100644
--- a/net/tap-linux.c
+++ b/net/tap-linux.c
@@ -57,7 +57,7 @@ int tap_open(char *ifname, int ifname_size, int *vnet_hdr,
     if (fd < 0) {
         fd = RETRY_ON_EINTR(open(PATH_NET_TUN, O_RDWR));
         if (fd < 0) {
-            error_setg_errno(errp, errno, "could not open %s", PATH_NET_TUN);
+            error_setg_file_open(errp, errno, PATH_NET_TUN);
             return -1;
         }
     }
diff --git a/target/i386/sev.c b/target/i386/sev.c
index fd2dada013..8660ecd9e4 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -891,8 +891,7 @@ static SevCapability *sev_get_capabilities(Error **errp)
 
     fd = open(sev_device, O_RDWR);
     if (fd < 0) {
-        error_setg_errno(errp, errno, "SEV: Failed to open %s",
-                         sev_device);
+        error_setg_file_open(errp, errno, sev_device);
         g_free(sev_device);
         return NULL;
     }
@@ -1819,8 +1818,7 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     devname = object_property_get_str(OBJECT(sev_common), "sev-device", NULL);
     sev_common->sev_fd = open(devname, O_RDWR);
     if (sev_common->sev_fd < 0) {
-        error_setg(errp, "%s: Failed to open %s '%s'", __func__,
-                   devname, strerror(errno));
+        error_setg_file_open(errp, errno, devname);
         g_free(devname);
         return -1;
     }
diff --git a/ui/ui-qmp-cmds.c b/ui/ui-qmp-cmds.c
index 74fa6c6ec5..d927121676 100644
--- a/ui/ui-qmp-cmds.c
+++ b/ui/ui-qmp-cmds.c
@@ -371,8 +371,7 @@ qmp_screendump(const char *filename, const char *device,
 
     fd = qemu_open_old(filename, O_WRONLY | O_CREAT | O_TRUNC | O_BINARY, 0666);
     if (fd == -1) {
-        error_setg(errp, "failed to open file '%s': %s", filename,
-                   strerror(errno));
+        error_setg_file_open(errp, errno, filename);
         return;
     }
 
diff --git a/util/vfio-helpers.c b/util/vfio-helpers.c
index fdff042ab4..8b1b2e2f05 100644
--- a/util/vfio-helpers.c
+++ b/util/vfio-helpers.c
@@ -309,7 +309,7 @@ static int qemu_vfio_init_pci(QEMUVFIOState *s, const char *device,
     s->container = open("/dev/vfio/vfio", O_RDWR);
 
     if (s->container == -1) {
-        error_setg_errno(errp, errno, "Failed to open /dev/vfio/vfio");
+        error_setg_file_open(errp, errno, "/dev/vfio/vfio");
         return -errno;
     }
     if (ioctl(s->container, VFIO_GET_API_VERSION) != VFIO_API_VERSION) {
@@ -333,8 +333,7 @@ static int qemu_vfio_init_pci(QEMUVFIOState *s, const char *device,
 
     s->group = open(group_file, O_RDWR);
     if (s->group == -1) {
-        error_setg_errno(errp, errno, "Failed to open VFIO group file: %s",
-                         group_file);
+        error_setg_file_open(errp, errno, group_file);
         g_free(group_file);
         ret = -errno;
         goto fail_container;
-- 
2.49.0


