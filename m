Return-Path: <kvm+bounces-71238-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WLk3KkqmlWkQTAIAu9opvQ
	(envelope-from <kvm+bounces-71238-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:45:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 40CF815604F
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:45:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5DAC0306295D
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764D730DD37;
	Wed, 18 Feb 2026 11:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cd3Zc/wV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jdTMWUD2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6183630DEB8
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771415035; cv=none; b=Fmbxunm4OHgECS7ByveGT4R29eWE5VtrhCCd09TgcT8FDbE03Ul6hMVEtuiO7wrZ79aJ+4VZXUERhCPpQ7x3lZk0qy5Ldt+qt1f3VvacQ+VHDgbskxWnp9x7qR9Y6ErQIOmpohm+x67E+RlfncRzO5Fm+22HJ6cwdgmvaakKBnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771415035; c=relaxed/simple;
	bh=EqcKRiS6NcIXMAUcXM4zzez6e3UUPe2Gm3nK5nSp5Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLepWzu8M7Oehb2GxZzTfJXhVvzuANaSIscOM7OvU21ho+RDIZY8tNLlVOIMQsdfK9HV2EOz6wIhy1vuHDQlLZ/DDXittpjyarDGb1gSGvBYr8/9WQqMxtgL83+A1dR/GvG4yQsSup3joaXKfdHZNUjO9Cd83IJWhpDodoiMie0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cd3Zc/wV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jdTMWUD2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771415033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0DJOQ6jwEso0pRS4a8bCDrKdsF6L0AYtEV0u9zd/jaU=;
	b=Cd3Zc/wVJmu8Xz/lZJzFHKI8TLaEy03SjB3tXL0kzo6FxnF7sgUghIU0DaOTEqD6XkRoYF
	oTXhpTfo3rfxBWlpytHqi5K+5mPFh/2A+RF3cutzyhrV+2+7aGJnx+MGoW8UFdaucBlbfN
	ZMBshtzo/HsD5l64Cyi8hJnOalMQoRA=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-FOkj2TDTNwaUBYFqCjrmsw-1; Wed, 18 Feb 2026 06:43:52 -0500
X-MC-Unique: FOkj2TDTNwaUBYFqCjrmsw-1
X-Mimecast-MFC-AGG-ID: FOkj2TDTNwaUBYFqCjrmsw_1771415031
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a944e6336eso304907655ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771415031; x=1772019831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0DJOQ6jwEso0pRS4a8bCDrKdsF6L0AYtEV0u9zd/jaU=;
        b=jdTMWUD25QTEiG0EQvQeXHoqCdSiRXTHVW2+1YEK5nxPD1aXu6ltZLFVpc1UesF7nk
         fonJx/agvAxTnGb4xLREzS9CrqoH8VpaQVAUo+N9YkFRwOspNiy6DfHK2Itq2XskYcQi
         1/NcjaW5g/N3+XNQJfgdpqLrORpI049VrL/Ljd3A1BInuKtiv87rfHM9q+v8MIpLxcuB
         MIBESezahU6vt3scodaYKmBJmxTJYvbumBcgY3iFmehrwh8xDquDfS3l8XoWf75E/i2Q
         kR1G8oesBVP7FS3iCkt70ZfbUcnjs8sspEi3Fb65EJ0UyObN1FSZYaREp2ZGFmsKbDJz
         QDPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415031; x=1772019831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0DJOQ6jwEso0pRS4a8bCDrKdsF6L0AYtEV0u9zd/jaU=;
        b=lnMU8aZy+omVznjqv6rlRk/LvhStmaPUUReQ6Kr7R1VLJq0JW9FdEgOsUs7QrJHR9A
         l7lOVmbhGS84H11IWex7TLkLWPZANyzu3/CA47T+EIVIkcYmPTHy8R++AQMGpsCM4Hye
         NSBHEKX1tSYrsYBJC4Ko2MIcCZ9E5yQoEUgF6s4eATejLUcdBIYeA/buenkONWFU9S87
         abzrsG6YhK7LQa1XpSd/R+mSUgvIjA3snQOEnXwUxGc8Z/i19oseqLRVsddPDHRrRSTu
         bYY/0HyRzkA6iO7dJ6KbLe74ye8tHI08wVQge8Wns98amSbWZCerj1MaigRiLKEFvbDH
         WYsA==
X-Forwarded-Encrypted: i=1; AJvYcCXonvR6nJcGMnYTGxpBirMJUfN6BxdWpQhu2KtQ4AOtOKL+MVtT/fZlZynyoOeRnsE6jqU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk/9QwWxmp9GityU9H7NSt189BiRa0e1dCYKtecDvk+c/ra2YF
	DY3sWeVvL6nFhQhZSIEj1pGvHOkbrFr6k6hxSPixwHICSSIawretPQplnflftGBCaH3a8sAG+G9
	gRzTbJmTI9dnHe1+bam7/3WqFNwuZGeupmebRK/Hi9OAdPupRhzxsYw==
X-Gm-Gg: AZuq6aJxRF3ZG+MmqSjBVyANPXxCvgNaNGHdvdaxAY+MkTzV20c9JIvZnpmHMP0LiHp
	BYvFhwYsjQdSd7PfRkn0N93ISAuLpt4CQN7673dF5PC6hsEzNzexriRfPj7pg/ijcd2dTPFo72p
	1SglKB9Ea0TVn6aix3EhRvYFnwJv1oOg53rZBCiArCoZwJsHTgyv79507soT58SICRCBTA51rlM
	8BP7Anrevn9T80dAgsHe288sOJdYADE6TiVp8NLXbbnl8RlVaAGE3QTz1tWiEmLpwXO/aiXwcEl
	R9xcoAfV0wXplDAQeJUeG6u4aOkC0/5mW5uaEYLJiiK0cRokLVcDXusc298hRgCHtJRV1i2O6vR
	ofTSfi/GH6rAQtJ0dDJGVymmId5Nat4nSAdiYHqzcfJIsCv+a+o3P
X-Received: by 2002:a17:902:da8c:b0:2aa:f43d:7c4b with SMTP id d9443c01a7336-2ad50e9a45emr15686135ad.19.1771415031025;
        Wed, 18 Feb 2026 03:43:51 -0800 (PST)
X-Received: by 2002:a17:902:da8c:b0:2aa:f43d:7c4b with SMTP id d9443c01a7336-2ad50e9a45emr15686015ad.19.1771415030642;
        Wed, 18 Feb 2026 03:43:50 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:43:50 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 21/34] i386/sev: add support for confidential guest reset
Date: Wed, 18 Feb 2026 17:12:14 +0530
Message-ID: <20260218114233.266178-22-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260218114233.266178-1-anisinha@redhat.com>
References: <20260218114233.266178-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71238-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 40CF815604F
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


