Return-Path: <kvm+bounces-69204-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gNSqHkZLeGkKpQEAu9opvQ
	(envelope-from <kvm+bounces-69204-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:21:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C6A409015F
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:21:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6B6A73085D01
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E2E329391;
	Tue, 27 Jan 2026 05:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PDtSzCA9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="E3AAEWWq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB2715B971
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491065; cv=none; b=pM/COy9VwTdsr1vO7taJVcFjsDGd+u9mpVrXrP+5x34hQ81uc0Sw8hjRS9sbXhRXo4wFZvPwhYApELGJAqn7W43/MKFsIZVwsE0nzb7QSzzMb0J7yEfB03ItH9wGZFKPkpG4EA6ptr8VmivZpvdNSxWlEK1Rw8yL5++6hHYjiL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491065; c=relaxed/simple;
	bh=NsQQTsqOtRRgXvsn1dhFnhqH9U9kJ5SqeAgwU94rVk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSOoNE/XaS1cRHIE/8jxo4Mx/1yXc+0Yiw74qS2XUWzDGiTT3z6DxndKAcyWAjJX5AjAFiDmygesImyf7WL9jeKQu76atdRrc4jYZKopVouefb27I6FvE72JNSYGX6NyJuyW7Tlte/QuoDCDCNgFiiOHx+IJG7jb0vqWzJGoZ+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PDtSzCA9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=E3AAEWWq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4BnmYW2pBzdLKLKUKm7VVppCSo8wKNLqPmySN8D7FQ=;
	b=PDtSzCA9/jxsTv4aNd41U5FFJ0EGZcdf+FGjm5vZ97q4z3eji/cbDj3k+CN+JtPclgrlUJ
	SAmKt/6wJ592Xblt+8o5SQV4aBbstSymnciQOh3nKyma8l52foE8xE0Ygmp0rrEOayWrW1
	GqdKes7WBCH5+u/nb6cJdG2bKD6Vm48=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-QLQY-51QNbW1qiNJmtCZ0w-1; Tue, 27 Jan 2026 00:17:39 -0500
X-MC-Unique: QLQY-51QNbW1qiNJmtCZ0w-1
X-Mimecast-MFC-AGG-ID: QLQY-51QNbW1qiNJmtCZ0w_1769491059
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a0f47c0e60so111485785ad.3
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491059; x=1770095859; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M4BnmYW2pBzdLKLKUKm7VVppCSo8wKNLqPmySN8D7FQ=;
        b=E3AAEWWqBdeRbrQVR6qCg1t5EjBeOnN3K2Y7MpJ/Yqi5cXs/qATEPecKO/RSvupShp
         RbjZvmulsxD7VcSfOxiV5rVlzZ2sOhNuvUQ+3NpTLubiF8rWLCDFDJy7vVlbNfY5cT5x
         CxogWgOgMnAbe/alQHbonjN+apd3tytvpn2GKJ6P+cQ13jHGcRqbFYeOggwM3Kr/7+fp
         r2LMdQRbwblxLis0+P7I0bFnnY2SHyMve7XtmeZpMY+gXZq9Nf0jY0XcMA99foNpizrS
         wAfx+WDjK65h6bYmaxxkvHIraBjp7kYNfLABX7igN5gNuX05wUui2zion0/xHu3J28vh
         W7Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491059; x=1770095859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M4BnmYW2pBzdLKLKUKm7VVppCSo8wKNLqPmySN8D7FQ=;
        b=WeVxQsDtQQE4+Dn3JbDZU05hhcz8l+AHDwo5Xtwr+8g8SMuYxDEunz9fHAzCmMIoIq
         CiU8GbWzJxr3ciTE+c9m6c1U43AdVPL6nan20trSx/kG75g18O+SnPmZbM3YSVCDMnpT
         fl0R24kS6YkTSQAPoMPcZOCwTusBrH/0OJYxCuzqw/Xyikp92r3VuWg3kK4tpq12Z4Rh
         vpodjvVGK1eYA4m3c+t7E4AteVeRzjdOAcrmEBIa+bMbUNtMKCW4ZBUcAmLm4IXJOc/6
         xIoT0cDniSmya4QoGFhy8XIF7DvVOtV3mvsDxOLuuAqQ6/46TTStByu9I7iRD59oksrr
         Pf6w==
X-Forwarded-Encrypted: i=1; AJvYcCVdj5biFHHqK0zdCbCqHNUWhYMxl5dWjRKFlZl/9FEKf1X9jOYV++GDPtsOZ4qdOeLOqZo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFq1MpCGUndPZOnqOtWj51dzvP/NoHLglupm1nhNwBdGF7sg8P
	/vitY4dgjX3PQDQ2XGMRZ6QPg11O7e1zDO/VeinUZ2wSefKX8BZwBxGSYNr1iOhQnx828JXUepo
	Yv/upm+tFl2cIIYLxdTgB2Yeqkp5Hbhqd+o0LlGetSdSiOmiJ4pc2Zw==
X-Gm-Gg: AZuq6aKbOSH1cDyXqAwD8cpqLFssYMBKOYyOUTTaLsF9CsxRxOUEsJKBa7KEjnI6NAi
	Hvhyd/mffaU5vhXU5Tu+iZDPzRtxLgXtyWD6A64qaGSpgM5oLxywlxiQfnlNVHJq1oujPssOa44
	ZydIgu5zuifmYf1mvPQuf/fJSGMoEaDogkVW4956rXW5D7cqq2C22emweGBCKPlAsROSW8x9Grr
	VxMPdJIEugo26b9JZpks2c9GYl2pE+jLLdaxqy5WWXWngRalcnI80SEHREq4Q98+cWult4wUZTF
	qdteH+jMxlaHxV/bYyg6bEATiGnt94ZLzpAyfNkj0TF8xQt/T8zFOvAhMnfLQJUHim9CA5xkcX2
	s1kA9JdnHS4d10OKKJEDnBOxMKWLTKORRfb0uQrkuYg==
X-Received: by 2002:a17:902:ea0d:b0:2a7:63dd:3496 with SMTP id d9443c01a7336-2a870dd5288mr8218955ad.46.1769491058625;
        Mon, 26 Jan 2026 21:17:38 -0800 (PST)
X-Received: by 2002:a17:902:ea0d:b0:2a7:63dd:3496 with SMTP id d9443c01a7336-2a870dd5288mr8218645ad.46.1769491058214;
        Mon, 26 Jan 2026 21:17:38 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:17:37 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 21/33] i386/sev: add support for confidential guest reset
Date: Tue, 27 Jan 2026 10:45:49 +0530
Message-ID: <20260127051612.219475-22-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260127051612.219475-1-anisinha@redhat.com>
References: <20260127051612.219475-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69204-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C6A409015F
X-Rspamd-Action: no action

When the KVM VM file descriptor changes as a part of the confidential guest
reset mechanism, it necessary to create a new confidential guest context and
re-encrypt the VM memeory. This happens for SEV-ES and SEV-SNP virtual machines
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
index d1dc0f3c1d..a53b4696e2 100644
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
@@ -85,6 +87,10 @@ typedef struct QEMU_PACKED PaddedSevHashTable {
     uint8_t padding[ROUND_UP(sizeof(SevHashTable), 16) - sizeof(SevHashTable)];
 } PaddedSevHashTable;
 
+static void sev_handle_reset(Object *obj, ResetType type);
+
+SevKernelLoaderContext sev_load_ctx = {};
+
 QEMU_BUILD_BUG_ON(sizeof(PaddedSevHashTable) % 16 != 0);
 
 #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
@@ -128,6 +134,7 @@ struct SevCommonState {
     uint8_t build_id;
     int sev_fd;
     SevState state;
+    ResettableState reset_state;
 
     QTAILQ_HEAD(, SevLaunchVmsa) launch_vmsa;
 };
@@ -1665,6 +1672,11 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
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


