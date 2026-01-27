Return-Path: <kvm+bounces-69198-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SPsRI+RKeGn2pAEAu9opvQ
	(envelope-from <kvm+bounces-69198-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:19:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 91A3D900E6
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:19:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F36FE305FFE0
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB234329391;
	Tue, 27 Jan 2026 05:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="et/y6KJu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iGTLnVIL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8538F242925
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491046; cv=none; b=gwDggjh2W+iqfsRsRUh7+y2IdmUo7PylR2jHz3pUQtUlF4HYPEHl+2ZwAw1YY7YbX7TAgjwEo7wgDZEfpVpFRDbDe3rfOKbubNAMReU9SJIJpJXHGyrvTY4/9ur3ZghvKyrfOgDfPCpQbNLBf0mDYV0a3dK+fdiQSTDwmk0/n8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491046; c=relaxed/simple;
	bh=D/HcMH8qipGU081+wbDh7ZzNQ1av8MpUMvJwp4zTjnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caWw3S2JDxqzTFzHwBcyc6A/q0vdjgRJZvys1cs8dDMe9WzAU0QFfPs5B+E8J3juFqV15AbTcKEiyM4jJuMPXURrhnsvwYI+ziqC10AS8yhthUX8CJ2JoqX5n7F4uj+y6i8tQOcXG0pUq+3RzsauCciBnpl0vcunmBtNg7vfHHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=et/y6KJu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iGTLnVIL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r0oM0RRyjLelkT0G5RoaNy8SGcq/Mnkz7KKwnwr3WCA=;
	b=et/y6KJu/aHqVWV0I+qVjbDkGCIuxh/ISKglEVriQ0l7prY+aCkJes6VF+ILdKSDgpVrLt
	jB11evUnPv34bYvDMceVBN7mLFJPllvkyYdEMFzvRCg1OZrgxp+pyAX3JmRqe3WQNfv1vM
	ykem0G/C3AsC2CZRFV21VlBCtQPhZBQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-aZuQj2zGMSuB58R_F_wKtA-1; Tue, 27 Jan 2026 00:17:22 -0500
X-MC-Unique: aZuQj2zGMSuB58R_F_wKtA-1
X-Mimecast-MFC-AGG-ID: aZuQj2zGMSuB58R_F_wKtA_1769491041
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34c64cd48a8so5491838a91.0
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491041; x=1770095841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r0oM0RRyjLelkT0G5RoaNy8SGcq/Mnkz7KKwnwr3WCA=;
        b=iGTLnVIL/2WMppzZ6hk8TdprKzZUBXFFTLLm9oWVqx/7VAcqmmCJCpDT1xhG0PbUeg
         K3DTGGrBCVAtsTPfrAfPsQ8+6Lb9puJjR14NuUoHdL9xl7Uab5zigqRt3swpQKQ/OAe9
         uKOmcMELWNYpaivo4wqjH6D6FckqKZKhoZqKEE/+FzJoZKcz+iLsBiy7OdTidGnvZNJJ
         CoGBXvRMcjU5sV+qD4BmMkOYO2+ne/pM9dUCnVoxHdq55CzI0Lfsplbw5kn9luxeFRXM
         Mr9NiN1Tvgq1vDVwtl8o2UqezdlUun91R8HYLZMtx5ZriZtJC296ILt+fRewVpF2ma/3
         iUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491041; x=1770095841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r0oM0RRyjLelkT0G5RoaNy8SGcq/Mnkz7KKwnwr3WCA=;
        b=e08eG615ueMe6qHcRQ4R8xutmjBZgYuMM9m8tUUG5xIQlWhh4Vx7HK+a7OBvk/WClm
         CQw7+BrDYcwo08AH4QcpXxLOwIzo6o7mp4HwiKSqWsN7S6B1EL/j5VdUZ1ldjhSsaIxs
         NKhSHuIPvlronPUOWiv/HRQVjbCTSgyFxwPagnt9nuSIPeu0hE8c8DmNP32e3DlLtaCQ
         zSkEUn6aARCLBk3uRivpbhluXA+3jOjMM0n5BqZZtl9aOyr7A62Oo1b9KE87KKpePawo
         11NOKZ1c5yTdzWd1B4GWPsMHhaIcmcsAFadsPlaYrj1oaDwpgEMtP3mZIdp+b2ZL8uTK
         kI8w==
X-Forwarded-Encrypted: i=1; AJvYcCX2ZnN4p4qG5aMg/7Uejos6BxK1fwTG7yOZcidjAxqI9QlVWjIRisboY1DXASRJvTgnhIs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmMdN46SMafHNo2fceK/cXTPop2D0AH09wyjbQcBMFTM6hg/B1
	m2bxAsGThlvsmr/vb5JdDxWOsepf2XzvE00nwvHnLmWbG89StvN1bDZf8dm843tfz80A3+9MVmQ
	h0JB2n+TxpaHwc75ly+fR0lwdQFOyOvkrwFSdWByjo0IYvNbAuihdsA==
X-Gm-Gg: AZuq6aLbweBWNseH45PgIaQp2PhotV1m6oFJ41WP0Vy5/mKVdSKvA3j8/CmNB3WZ9tx
	O477sHBtxFepx9+BlDYo7z/d+ujtDSOdvYcc5rOU0EqTT6oJmmqVjBL9hnkiRJqfzA8u9T7LliD
	z5umvLvVfeBiEdysPkiXyEBHMOqp/Qwau1r3blE1dTI82dTBare3u4Y/EEp2PlS6MbnE0NlZZJY
	K8jh6/SmR4+nvepijthPLFX2ZqE8H6csn9TxFuNbFgyRzkvWThb7k0PrdwIulv8df8pewKZFeJe
	wnZN9322OxUzHd+XXKbGkrPT8fga3t+2dVlWzNJhtZG4MaTGJemN+hAND/q5Iuvg7BTAC12zVH2
	vH0Rpm74pJN3gODsSXZKhE2mfPPPDB5jX+cKbb5f9zg==
X-Received: by 2002:a17:90b:3ccf:b0:353:356c:6821 with SMTP id 98e67ed59e1d1-353fecd0906mr710447a91.8.1769491040982;
        Mon, 26 Jan 2026 21:17:20 -0800 (PST)
X-Received: by 2002:a17:90b:3ccf:b0:353:356c:6821 with SMTP id 98e67ed59e1d1-353fecd0906mr710436a91.8.1769491040627;
        Mon, 26 Jan 2026 21:17:20 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:17:20 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 15/33] i386/tdx: refactor TDX firmware memory initialization code into a new function
Date: Tue, 27 Jan 2026 10:45:43 +0530
Message-ID: <20260127051612.219475-16-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69198-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 91A3D900E6
X-Rspamd-Action: no action

A new helper function is introduced that refactors all firmware memory
initialization code into a separate function. No functional change.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/tdx.c | 73 ++++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 33 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index a3e81e1c0c..fd8e3de969 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -295,14 +295,51 @@ static void tdx_post_init_vcpus(void)
     }
 }
 
-static void tdx_finalize_vm(Notifier *notifier, void *unused)
+static void tdx_init_fw_mem_region(void)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
     TdxFirmwareEntry *entry;
-    RAMBlock *ram_block;
     Error *local_err = NULL;
     int r;
 
+    for_each_tdx_fw_entry(tdvf, entry) {
+        struct kvm_tdx_init_mem_region region;
+        uint32_t flags;
+
+        region = (struct kvm_tdx_init_mem_region) {
+            .source_addr = (uintptr_t)entry->mem_ptr,
+            .gpa = entry->address,
+            .nr_pages = entry->size >> 12,
+        };
+
+        flags = entry->attributes & TDVF_SECTION_ATTRIBUTES_MR_EXTEND ?
+                KVM_TDX_MEASURE_MEMORY_REGION : 0;
+
+        do {
+            error_free(local_err);
+            local_err = NULL;
+            r = tdx_vcpu_ioctl(first_cpu, KVM_TDX_INIT_MEM_REGION, flags,
+                               &region, &local_err);
+        } while (r == -EAGAIN || r == -EINTR);
+        if (r < 0) {
+            error_report_err(local_err);
+            exit(1);
+        }
+
+        if (entry->type == TDVF_SECTION_TYPE_TD_HOB ||
+            entry->type == TDVF_SECTION_TYPE_TEMP_MEM) {
+            qemu_ram_munmap(-1, entry->mem_ptr, entry->size);
+            entry->mem_ptr = NULL;
+        }
+    }
+}
+
+static void tdx_finalize_vm(Notifier *notifier, void *unused)
+{
+    TdxFirmware *tdvf = &tdx_guest->tdvf;
+    TdxFirmwareEntry *entry;
+    RAMBlock *ram_block;
+
     tdx_init_ram_entries();
 
     for_each_tdx_fw_entry(tdvf, entry) {
@@ -339,37 +376,7 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
     tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
 
     tdx_post_init_vcpus();
-
-    for_each_tdx_fw_entry(tdvf, entry) {
-        struct kvm_tdx_init_mem_region region;
-        uint32_t flags;
-
-        region = (struct kvm_tdx_init_mem_region) {
-            .source_addr = (uintptr_t)entry->mem_ptr,
-            .gpa = entry->address,
-            .nr_pages = entry->size >> 12,
-        };
-
-        flags = entry->attributes & TDVF_SECTION_ATTRIBUTES_MR_EXTEND ?
-                KVM_TDX_MEASURE_MEMORY_REGION : 0;
-
-        do {
-            error_free(local_err);
-            local_err = NULL;
-            r = tdx_vcpu_ioctl(first_cpu, KVM_TDX_INIT_MEM_REGION, flags,
-                               &region, &local_err);
-        } while (r == -EAGAIN || r == -EINTR);
-        if (r < 0) {
-            error_report_err(local_err);
-            exit(1);
-        }
-
-        if (entry->type == TDVF_SECTION_TYPE_TD_HOB ||
-            entry->type == TDVF_SECTION_TYPE_TEMP_MEM) {
-            qemu_ram_munmap(-1, entry->mem_ptr, entry->size);
-            entry->mem_ptr = NULL;
-        }
-    }
+    tdx_init_fw_mem_region();
 
     /*
      * TDVF image has been copied into private region above via
-- 
2.42.0


