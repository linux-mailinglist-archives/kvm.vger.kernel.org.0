Return-Path: <kvm+bounces-70917-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wEuAACNzjWn42gAAu9opvQ
	(envelope-from <kvm+bounces-70917-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:28:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D4E12AAA5
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:28:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 13B3230B82A8
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E75B29ACF0;
	Thu, 12 Feb 2026 06:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f86RtunR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="O2C1WaFL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D6929617D
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877602; cv=none; b=R4htm2WDuIzxvz47GOWA4vVUGD8+ofGMamPvnVBnszQG7FtprzgcOjRMTwPiOjleGr+NdFL/yDyaM0eaC2ZDx9JJHMyyNKG8F7uawmCCK99IwssQZIlUu/DejdW7Tdgnw91vBJfWmblWnBeiTzjdbHJSI++bLs790/m3wOvZF5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877602; c=relaxed/simple;
	bh=EqcKRiS6NcIXMAUcXM4zzez6e3UUPe2Gm3nK5nSp5Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBunc1uMAvhbNncK8gd8M6IY51kl9HMQP0ph1ezDl4/4HC3pDv4ji+mSTWuVmiQ7aqjBqtjQptIefE/Zms6g5ypieEjNRc8lN1Ji5HQHN0hS5bamuP4b485uRy6eq2IzwrIvMTUhS72FUq0VEWEcEucRVy9q9CsW0t5i9FUnWQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f86RtunR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=O2C1WaFL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0DJOQ6jwEso0pRS4a8bCDrKdsF6L0AYtEV0u9zd/jaU=;
	b=f86RtunRO69zLdgB1lcijOUwBf/trYRSfGwhrQuxJBeI62DqEdpo5soAvjefQjnz1Syxbx
	Jhv363T9nFJEHNfHPdPZNAXcPug0MwfRy4EdSztNs3L2rDWbfbWUoMFQxFB2vFkx+rnHZC
	5Cf2DPKqTadI0XmU3CkQ+ZNX6b+XDII=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-VukL9cstMwqr49bCuMJmAQ-1; Thu, 12 Feb 2026 01:26:39 -0500
X-MC-Unique: VukL9cstMwqr49bCuMJmAQ-1
X-Mimecast-MFC-AGG-ID: VukL9cstMwqr49bCuMJmAQ_1770877598
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35678f99c6eso1528744a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877598; x=1771482398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0DJOQ6jwEso0pRS4a8bCDrKdsF6L0AYtEV0u9zd/jaU=;
        b=O2C1WaFLoBL7f47oxnOQ8t4UueqWkTxv6v0mDGq/46pJ9+87OyKV2izihL6SZqGpcC
         QOAjhvDQlypLpm7Dpkw32nliWPRHv2dceHqG6/GvyrDreMAD2Acj2Po9+WrhTWijnoYI
         3LiqvOtTvm8hnDGIhdq53SnCY+8T3dC+nAvyoe0HfcHNmsKjih6IqLenBQ2u6XLfJWY4
         9t+/04wu5nXVQVZVAg5TZiET6AWTBubXHHxWOzHi5/tYS3NvSJid6fQk6NlGk8Q01F58
         Dk0yn4k9mWoLNjy8UTPML3HL8iK1JLyBfDnu1Zv15UCO/H8bae99ZkfF/KeHxxFfJNBk
         u+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877598; x=1771482398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0DJOQ6jwEso0pRS4a8bCDrKdsF6L0AYtEV0u9zd/jaU=;
        b=Gx/Iva0f6k4ooB46HPtCEax7u3wqHgLcLCZ2VkfWmaTADhkDnbTQKLkfRfwl77TNE2
         T8sq89urHmBO6ePqkYfAocSXhw7LVJxJ2NfWgkwpTV1lEg4xTpN8IDvcY3bRzQByi3ec
         myIqJd7evR++yoMU3Q0f4s/B3o0sbzUDcpURjmwop3v3GOPFQMBLnsV5oe1Pc41JvVES
         tgXbKah3qvDDYu5ldVHIHVRZDaAgYHnlFZqbUE9uhew5njZ2WTr+oN/YPNHaM7Wswz9a
         h2mKVVYlVqjLN4Ioooy6AKtgSDx6qxIRrhdvKAuzwIvfhwkaATJLH4Sk+I26wBG5Vk7j
         XmKw==
X-Forwarded-Encrypted: i=1; AJvYcCUNT4j9+Jc7im6tue1DO/gGDxGE4X5qixGrMhR38hitMPh4/Gpn/EgD6DOttHnSFghr/NQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5v8RboyogVDnBdUujk/AUhoesFygpou/XAHrkZ+j2sMybQutf
	cpmElr20MgjVnuHGPPRkvebRFaj0zj3spm7L3HPxIEiQkrn2r4oEWY5UXrbphjEE+AWOSjdVEAB
	tP2cP0FwPIKMKfVAGv4rGJS7Ool4jbyIx6y778atMp1i5mpkKK8aNDg==
X-Gm-Gg: AZuq6aJ9s1l9MaE0iMpCoZ435H+4zOTRnOQ69Cn7AICpo4BsWB9ZI3gOZc5tQhc9jCj
	GoVD+LxtUchuH7bRGhJ76yjLO/7m7Sl6jLRbrBH2vHXfpUAS3Ogh7ekqZYhjJakMNl9kqjskVX1
	WFjxYmy6LD7EuvGxaikQvEbk4zesSppPeNBUmYhcVHKImxY5iavqirj7ufyT/BI4M61cyoecLyx
	GKSxtmwOMK4H3FDTUyrf/dDuyrOJx6X6c2A3EP51PgtdXWoAzrfbyIcMXTaBDyFy+SnePIH9ozx
	BInwN94u4G9kRgmys6frQDte1v3NwuVyRb+AQHdKX8cnHoOYalmFFP43DO4nEDLSpp10DU2/bfm
	hmc6XskJ3e9YDDTiZjWa3mUi1PeGkSvpdFe608XQckRRh9bxqENeQIwk=
X-Received: by 2002:a17:90a:d78c:b0:34c:6124:3616 with SMTP id 98e67ed59e1d1-3568f41819amr1375486a91.27.1770877598304;
        Wed, 11 Feb 2026 22:26:38 -0800 (PST)
X-Received: by 2002:a17:90a:d78c:b0:34c:6124:3616 with SMTP id 98e67ed59e1d1-3568f41819amr1375471a91.27.1770877597934;
        Wed, 11 Feb 2026 22:26:37 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:26:37 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 20/31] i386/sev: add support for confidential guest reset
Date: Thu, 12 Feb 2026 11:55:04 +0530
Message-ID: <20260212062522.99565-21-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260212062522.99565-1-anisinha@redhat.com>
References: <20260212062522.99565-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70917-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 92D4E12AAA5
X-Rspamd-Action: no action

When the KVM VM file descriptor changes as a part of the confidential guest
reset mechanism, it necessary to create a new confidential guest context and
re-encrypt the VM memory. This happens for SEV-ES and SEV-SNP virtual machines
as a part of SEV_LAUNCH_FINISH, SEV_SNP_LAUNCH_FINISH operations.

A new resettable interface for SEV module has been added. A new reset callback
for the reset 'exit' state has been implemented to perform the above operations
when the VM file descriptor has changed during VM reset.

Tracepoints has been added also for tracing purpose.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c        | 58 ++++++++++++++++++++++++++++++++++++++++
 target/i386/trace-events |  1 +
 2 files changed, 59 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index b3893e431c..549e624176 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -30,8 +30,10 @@
 #include "system/kvm.h"
 #include "kvm/kvm_i386.h"
 #include "sev.h"
+#include "system/cpus.h"
 #include "system/system.h"
 #include "system/runstate.h"
+#include "system/reset.h"
 #include "trace.h"
 #include "migration/blocker.h"
 #include "qom/object.h"
@@ -86,6 +88,10 @@ typedef struct QEMU_PACKED PaddedSevHashTable {
     uint8_t padding[ROUND_UP(sizeof(SevHashTable), 16) - sizeof(SevHashTable)];
 } PaddedSevHashTable;
 
+static void sev_handle_reset(Object *obj, ResetType type);
+
+SevKernelLoaderContext sev_load_ctx = {};
+
 QEMU_BUILD_BUG_ON(sizeof(PaddedSevHashTable) % 16 != 0);
 
 #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
@@ -129,6 +135,7 @@ struct SevCommonState {
     uint8_t build_id;
     int sev_fd;
     SevState state;
+    ResettableState reset_state;
 
     QTAILQ_HEAD(, SevLaunchVmsa) launch_vmsa;
 };
@@ -1666,6 +1673,11 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
             error_setg(&sev_mig_blocker,
                        "SEV: Migration is not implemented");
             migrate_add_blocker(&sev_mig_blocker, &error_fatal);
+            /*
+             * mark SEV guest as resettable so that we can reinitialize
+             * SEV upon reset.
+             */
+            qemu_register_resettable(OBJECT(sev_common));
         }
     }
 }
@@ -1991,6 +2003,41 @@ static int sev_snp_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     return 0;
 }
 
+/*
+ * handle sev vm reset
+ */
+static void sev_handle_reset(Object *obj, ResetType type)
+{
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+    SevCommonStateClass *klass = SEV_COMMON_GET_CLASS(sev_common);
+
+    if (!sev_common) {
+        return;
+    }
+
+    if (!runstate_is_running()) {
+        return;
+    }
+
+    sev_add_kernel_loader_hashes(&sev_load_ctx, &error_fatal);
+    if (sev_es_enabled() && !sev_snp_enabled()) {
+        sev_launch_get_measure(NULL, NULL);
+    }
+    if (!sev_check_state(sev_common, SEV_STATE_RUNNING)) {
+        /* this calls sev_snp_launch_finish() etc */
+        klass->launch_finish(sev_common);
+    }
+
+    trace_sev_handle_reset();
+    return;
+}
+
+static ResettableState *sev_reset_state(Object *obj)
+{
+    SevCommonState *sev_common = SEV_COMMON(obj);
+    return &sev_common->reset_state;
+}
+
 int
 sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp)
 {
@@ -2469,6 +2516,8 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
         return false;
     }
 
+    /* save the context here so that it can be re-used when vm is reset */
+    memcpy(&sev_load_ctx, ctx, sizeof(*ctx));
     return klass->build_kernel_loader_hashes(sev_common, area, ctx, errp);
 }
 
@@ -2729,8 +2778,16 @@ static void
 sev_common_class_init(ObjectClass *oc, const void *data)
 {
     ConfidentialGuestSupportClass *klass = CONFIDENTIAL_GUEST_SUPPORT_CLASS(oc);
+    ResettableClass *rc = RESETTABLE_CLASS(oc);
 
     klass->kvm_init = sev_common_kvm_init;
+    /*
+     * the exit phase makes sure sev handles reset after all legacy resets
+     * have taken place (in the hold phase) and IGVM has also properly
+     * set up the boot state.
+     */
+    rc->phases.exit = sev_handle_reset;
+    rc->get_state = sev_reset_state;
 
     object_class_property_add_str(oc, "sev-device",
                                   sev_common_get_sev_device,
@@ -2780,6 +2837,7 @@ static const TypeInfo sev_common_info = {
     .abstract = true,
     .interfaces = (const InterfaceInfo[]) {
         { TYPE_USER_CREATABLE },
+        { TYPE_RESETTABLE_INTERFACE },
         { }
     }
 };
diff --git a/target/i386/trace-events b/target/i386/trace-events
index 51301673f0..b320f655ee 100644
--- a/target/i386/trace-events
+++ b/target/i386/trace-events
@@ -14,3 +14,4 @@ kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data
 kvm_sev_snp_launch_start(uint64_t policy, char *gosvw) "policy 0x%" PRIx64 " gosvw %s"
 kvm_sev_snp_launch_update(uint64_t src, uint64_t gpa, uint64_t len, const char *type) "src 0x%" PRIx64 " gpa 0x%" PRIx64 " len 0x%" PRIx64 " (%s page)"
 kvm_sev_snp_launch_finish(char *id_block, char *id_auth, char *host_data) "id_block %s id_auth %s host_data %s"
+sev_handle_reset(void) ""
-- 
2.42.0


