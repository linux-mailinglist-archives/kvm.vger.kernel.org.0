Return-Path: <kvm+bounces-65840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 18211CB9103
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:09:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B9FD930D69F0
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB00321F5F;
	Fri, 12 Dec 2025 15:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A8H9t/mk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ik/wyTnx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267EA32145E
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551928; cv=none; b=vEb7BbuE0vJMD21tccXM61ETrIWU+xBTkEeMpev6/FklRAs1aMyTBx5oP+MlWgpNyWxha+YfxodjWHZ4XKdxraUZ4d7NaA9Jge0Uu5fi3p/e0ZtpM+t0fXB/2vIboTJQah2nle7j1/qaKX9aBpiibRumZyDTACxGjZaoWINcUlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551928; c=relaxed/simple;
	bh=6Xd4fRHnFZ2TMlXNgUh0Oux2G3JI+a4zgQLXr0s3IeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/6PbNF2OQGbe/QpVv3msutZWA4+J9UhQyC7woL0GOicqhjLSSFkgjJMLOwcKyNY/OVy6deAlPaGF5MS0SfvHsahDSbiZJf/xkcjbwzVzAw2Hu4SZoj3lD9qsubRCjYT0qRwAz5yMeQM5HPLSe3KWWYcIaCJ8nVKH4QTMosVbbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A8H9t/mk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ik/wyTnx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N2VTrzg+qE8VL3OOG3OpyC5OygKIGSBEXRIlgut+Wko=;
	b=A8H9t/mkNnfs4Vy8a0UkXlRTnZbBetct7XHsZNcWh7zQ37UBLkDCvLjv5ZcUYR66PVaA9n
	xKAlL6ywab0JW8Ie8qlxVvTC8u4+AaYB7WUf2USuy7f7LSew/JqTA4o9Qk3L9k/E7/t7Ek
	F+G63yNEMDcC/PBPqS8h6jXXmjKQit0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-JEr6m_55OgqcDdWExAoJvw-1; Fri, 12 Dec 2025 10:05:24 -0500
X-MC-Unique: JEr6m_55OgqcDdWExAoJvw-1
X-Mimecast-MFC-AGG-ID: JEr6m_55OgqcDdWExAoJvw_1765551923
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2958a134514so17997825ad.2
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551923; x=1766156723; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2VTrzg+qE8VL3OOG3OpyC5OygKIGSBEXRIlgut+Wko=;
        b=ik/wyTnxKK0+HXrl3JiTH9z0dpBgiPU8MOb22zG5QvQLGXyXhbhnosRyU73p9ZiWjP
         FapPyt7RaakJHQK5OBoadQBpVIfrVR1r8rc1XjW4CEfHP2+Z673BeD2T5ByDORltKKSY
         VpIcJpIzj3rdQ6NxFLQDEnUpmBgJ84CBiFAXU9feE7a7D6UvFpm4UKZovdTcIRNe2Sh1
         /I88+HPeUpd8xORuKpiJrdZ7Jx0GsnjIJtAMX5of4IZb8M5wwRZGBitnFPcnq2pdIQWh
         EYsepe23eO6n5R9KM4XuKnk7Xrd3rOTaIpoouk1AynXOkYm3L66KR5kK4yNEFWBfQQXr
         HY/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551923; x=1766156723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N2VTrzg+qE8VL3OOG3OpyC5OygKIGSBEXRIlgut+Wko=;
        b=q7wjKpDCujkwYcC29lyIefeyIU2fWfbhMWahv1BpAMl08C9j/wbE3m7yCRwEIgSd5i
         PRE5YoHmGz745FgRsJFguVhH/6o7c/vGbvhK4yDhkxKWGH1QwklW+N5WwN6lWf5ZOcWb
         NJJn0M48sdRJNFu14FTkZFl71Ht5vtiLU2mccWaLwuX6fsdY9Pd0vRLKuimAHOkkbOy3
         5Zfz28ws//ENhON0TRMdNGS0BUzNFbmH3h30rgwrX2MsWb+gAxq5qgsZ14RLI0oUzNGh
         hvy4PVxWK8x6omXzgoN4lziidDoppCltaw95qt8rMczcpYLQ9LTOb4UipEkiW5JDtfOo
         9WSw==
X-Forwarded-Encrypted: i=1; AJvYcCVnAe4XF7lgZo1IY6CIkDEDeaufBCEX0HB4HK9nx+S2eYoELcLe2yxq4U6idKMTYzbbOcY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiTz1dHo1ZNmkcBrKgrz2yte1qZlGrU3xD3LXOu07PAC6OoHp2
	O2Fq6RaCpOOvLj1+RlWy2Nu45hpf7LkhDZEoqPVsevr3EbTeareW9UTGNvP3uHLSH4WbyX529ae
	5+6RpXRHm7SZhi6lU58BxyK2k4OwInsplfmbzl1CfeK1c7L8oPZB/og==
X-Gm-Gg: AY/fxX6QmldtMVidZzJmRGDKCsosisd1tHrrD2VcVO2Sw2eYcIyYJekOhHeNzjvl8DS
	tkkbBgTtlWsugHiLDqV5A6Ubxt4pedY+DN/vpKmSLMGpOQ5SStIyKWxK9/gVuHDg8mOZMKopt8I
	6Mt1o2QRkF/Kp+jkYKxG/bN8RupoeLIj70PBJCpqDiJen4ZzB3X262rMRdysIz4/AwQBuAJRjNH
	5HZXFOpa/L9XG9r8u4V5iOjunxjXf+MmtJjPDQYq3r5hBDuCbVoFaOdIUIcKTm14CpTPAg0MOGb
	GT+sRLuazAW6MC+LucHGucO+0YxsgxAUp+dgSPDwapOgQCAva+VWhkEZ6lqcEtHnzDdoRBJdSk3
	9SRmf5PGWm5SNE2FFqs+et1l4BdJ4iQL/b5Z5lwXMuwE=
X-Received: by 2002:a17:903:120e:b0:295:24ab:fb06 with SMTP id d9443c01a7336-29f23b7620amr27812165ad.22.1765551922746;
        Fri, 12 Dec 2025 07:05:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE/6tfMT8Kl8RrzWhiMsAQY3ed5KCyrUemoiU+97igw8z0Kogz5KW2sb29zObkJjgdkQ5BxpA==
X-Received: by 2002:a17:903:120e:b0:295:24ab:fb06 with SMTP id d9443c01a7336-29f23b7620amr27811645ad.22.1765551922141;
        Fri, 12 Dec 2025 07:05:22 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:05:21 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 18/28] i386/sev: add support for confidential guest reset
Date: Fri, 12 Dec 2025 20:33:46 +0530
Message-ID: <20251212150359.548787-19-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20251212150359.548787-1-anisinha@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the KVM VM file descriptor changes as a part of the confidential guest
reset mechanism, it necessary to create a new confidential guest context and
re-encrypt the VM memeory. This happens for SEV-ES and SEV-SNP virtual machines
as a part of SEV_LAUNCH_FINISH, SEV_SNP_LAUNCH_FINISH operations.

A new resettable interface for SEV module has been added. A new reset callback
for the reset 'exit' state has been implemented to perform the above operations
when the VM file descriptor has changed during VM reset.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 83b9bfb2ae..246a58c752 100644
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
@@ -84,6 +86,10 @@ typedef struct QEMU_PACKED PaddedSevHashTable {
     uint8_t padding[ROUND_UP(sizeof(SevHashTable), 16) - sizeof(SevHashTable)];
 } PaddedSevHashTable;
 
+static void sev_handle_reset(Object *obj, ResetType type);
+
+SevKernelLoaderContext sev_load_ctx = {};
+
 QEMU_BUILD_BUG_ON(sizeof(PaddedSevHashTable) % 16 != 0);
 
 #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
@@ -127,6 +133,7 @@ struct SevCommonState {
     uint8_t build_id;
     int sev_fd;
     SevState state;
+    ResettableState reset_state;
 
     QTAILQ_HEAD(, SevLaunchVmsa) launch_vmsa;
 };
@@ -2012,6 +2019,37 @@ static int sev_snp_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
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
+    if (!sev_check_state(sev_common, SEV_STATE_RUNNING)) {
+        /* this calls sev_snp_launch_finish() etc */
+        klass->launch_finish(sev_common);
+    }
+
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
@@ -2490,6 +2528,8 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
         return false;
     }
 
+    /* save the context here so that it can be re-used when vm is reset */
+    memcpy(&sev_load_ctx, ctx, sizeof(*ctx));
     return klass->build_kernel_loader_hashes(sev_common, area, ctx, errp);
 }
 
@@ -2750,8 +2790,16 @@ static void
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
@@ -2786,6 +2834,8 @@ sev_common_instance_init(Object *obj)
     cgs->get_mem_map_entry = cgs_get_mem_map_entry;
     cgs->set_guest_policy = cgs_set_guest_policy;
 
+    qemu_register_resettable(OBJECT(sev_common));
+
     QTAILQ_INIT(&sev_common->launch_vmsa);
 }
 
@@ -2800,6 +2850,7 @@ static const TypeInfo sev_common_info = {
     .abstract = true,
     .interfaces = (const InterfaceInfo[]) {
         { TYPE_USER_CREATABLE },
+        { TYPE_RESETTABLE_INTERFACE },
         { }
     }
 };
-- 
2.42.0


