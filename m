Return-Path: <kvm+bounces-71765-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBEJDQtynml0VQQAu9opvQ
	(envelope-from <kvm+bounces-71765-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:52:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CE8021915AC
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:52:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 69E763102468
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85A52BE644;
	Wed, 25 Feb 2026 03:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EezkBWy6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gt+VlxIA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF047257845
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991488; cv=none; b=HGlCDnjF4XYs5tkDCcumv53Dp1FkSwU0xqp8eqIGLPDuGGQ0BiW/Gu1UOmZCFA+TofF96dRSt5KVG9YYrchQyNQAhRJCOucDSUHJtmky7cScHVfJXOBJy0eMPgsaxS1kTUtyketWHCAlEHGcRZpLq7RBzV6WTsswW9Pe4cwKf/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991488; c=relaxed/simple;
	bh=EqcKRiS6NcIXMAUcXM4zzez6e3UUPe2Gm3nK5nSp5Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dd7qcETuX7PhwNKxJUrpaEV3PAc9Wzbd3X8+RnjDawjrUTUH8jDrFwh8YC8qEoJv6DI2ApTjrSZsuPqF1cQXq8H45AGLGnhWVsKCqBaPGOEfZMzY1PtZXblercfUhDYj4lADox2BzjzSjedj5sqUVQkWrp2kuaGpF2jWDxd/fMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EezkBWy6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gt+VlxIA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0DJOQ6jwEso0pRS4a8bCDrKdsF6L0AYtEV0u9zd/jaU=;
	b=EezkBWy6w0GL5Q169VcGQ/286nf8WodaG02PYg7YmeU+O6Q7v72ng8NkpEqzTANXCCD8bN
	cfcCNhMHyZ2H4NR6WzuPWor9kdVkhmsjHMEc41iLNAq3wJzzyxR6rflcZVuCaDKOh49xta
	1bEVSpWDBQ8Ux360/XAjgQT+nt/IBNs=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-rolA1zC1Oh-1W3cqTNaLeA-1; Tue, 24 Feb 2026 22:51:24 -0500
X-MC-Unique: rolA1zC1Oh-1W3cqTNaLeA-1
X-Mimecast-MFC-AGG-ID: rolA1zC1Oh-1W3cqTNaLeA_1771991483
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-354c0eb08ceso39232461a91.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991483; x=1772596283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0DJOQ6jwEso0pRS4a8bCDrKdsF6L0AYtEV0u9zd/jaU=;
        b=gt+VlxIATyaV9zQY3FICcxuLIuhADtPHFynWOUxVYDJ/ug9Z/OxETrNwCN1MA16rWf
         zLl9ptKIzRnB4OdQAXwZ3dM5qy+XpBE+6nqzhDVBU6FJrNrrlgnwXjbPwBDNuksEZKEu
         T8ZRpLGq/3HUTWn+1LqB6t3jOdgOZY8dWciGEmqX8dQNaQY+s9ij5oJhn6VEGhgUYF8w
         oNTA9HNhyU0J0mruTOm0Sj8AQG3ll79S4gXf66jmcEFWT3OMJAyBzvCtRKHLVIlzlEwq
         vvUkVCg6ujXt7ivXBYWa589t0zhsRfTlFkcTG/vCbGPXWJoSaOrSSPum2I/u/oKQf1rh
         s1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991483; x=1772596283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0DJOQ6jwEso0pRS4a8bCDrKdsF6L0AYtEV0u9zd/jaU=;
        b=Co3MsWy1TsEvcVZoep8cMAqchyDGu5L8OeHhshsw8F4NgmfT6rcBHIbZ+nYl6UvLXD
         zZ5NTbpNlPAhc31S9Kqft7e+mKcTrhzS+CRGXu+U8r9EdBkeTEJ7pM7PKo4tYcMM2+Tq
         G+hljOId7xaPoX7ZgQ7/BmXhGLSitkBT6Xw5kZD0OsbExOnOFF/mY2BfBKXXPZEJp/vM
         Ym0TsGw4MPEysLW+KLOC7zyvSmzCApkffIYzMPnDMsvnDGfuaNDkk/TpDVkYWo/QFMnj
         K+iQPADRxpEDngijW+rrCLbQPDrP/cb8rbe2BlSymlcHubj8jStlsSj4fCv5qiJByhnX
         QfHg==
X-Forwarded-Encrypted: i=1; AJvYcCWO02GuhwDGKobzDpiqZuILwWXCdAbeSOiS2owFLG7akptaBQ7UTDuCty95LPgAKBjZroU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu6dta0gFoFZ8NfblHR3qtA0Gbl+1HxAFmotyhV/p+tYaURbkf
	6eKdRr4bQ32YhQV57QiqFqSav3cWew6/L9UNJAizOv+x00QK95scsy/uXSfrNhuPkUf+T5l2i8S
	ZiIDL164ej6QzjW7XQ7an4NXiVoLx8N3zSSeeWH3xAEHWAsiu4pwFjw==
X-Gm-Gg: ATEYQzweug0/VBZK6Oosf5/zXnNnZXKwV9OIPTsbEi+hfDc2cn01vaNFTXjpZnKXXWN
	WihVurGrkCqdot4d0Q93BwMQPWivQ6LNm0jsRHi8za+Cz85KUpB3dGRwFV5HWMOOllUywGwQNBu
	tAvcpOTx4GnehdBwX0WNXnkbRlvZYrcC9LiuygBvjtMWPrJ6mZ38Xk1cfFj/jQLpPRSa/gCRcrt
	VyGkWAT94M3bdEvCOlcd4MudY0Uc3bouJZ1MkYiyuFGNFviLg0aar/lr4+0CqOjrxeaZrpGt9el
	4APH8wCTzploqQacKqQ5qQVL0JMHNyHkoiVpyStnai1jpFK5teAwb9QNIcW+iUhFULQ3i1ZMwNk
	jH+ZIpr0Wenk49ayS7HA+FV3q6s6ScKP9Kf0G7qIGsMIHzIMzHdeC04Y=
X-Received: by 2002:a17:90b:17c8:b0:354:a284:3fff with SMTP id 98e67ed59e1d1-358ae8cfe96mr11145655a91.25.1771991482894;
        Tue, 24 Feb 2026 19:51:22 -0800 (PST)
X-Received: by 2002:a17:90b:17c8:b0:354:a284:3fff with SMTP id 98e67ed59e1d1-358ae8cfe96mr11145638a91.25.1771991482539;
        Tue, 24 Feb 2026 19:51:22 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:51:22 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 22/35] i386/sev: add support for confidential guest reset
Date: Wed, 25 Feb 2026 09:19:27 +0530
Message-ID: <20260225035000.385950-23-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260225035000.385950-1-anisinha@redhat.com>
References: <20260225035000.385950-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71765-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CE8021915AC
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


