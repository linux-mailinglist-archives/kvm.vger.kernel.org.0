Return-Path: <kvm+bounces-71232-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mE2+BhumlWkQTAIAu9opvQ
	(envelope-from <kvm+bounces-71232-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:44:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AF794155FE8
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:44:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6CFBB30514BB
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BDE130DEB5;
	Wed, 18 Feb 2026 11:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ib+htBLw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SHalvQ40"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5682DCC1F
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771415017; cv=none; b=gdMW1Lc5rOq8ONLxv2Ybp9nXk3aGDzjD/42ATJ5No6GZ9G0ku8050sQ9HtQK4iphZZOKZp1DZNFtc1ZmioaXEQ4LrAwKf0+TCtQJ52heMqi07iIlFhAbX313yv4zuL+0axVAVgLZxMDoPaven22AVrxRDXxjUAMvG6kYvTWfaok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771415017; c=relaxed/simple;
	bh=D/HcMH8qipGU081+wbDh7ZzNQ1av8MpUMvJwp4zTjnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGPXSQGT4hhkVizThNWIme6CmTs15CRKy2F/oJX6BjwCJLaYx/3ZR1raHIUpxTpm87A6SQ1pBT9WSIDBEFXzGIzkwb7VtMlNdsT4iMvy6iFSwWCFaxZ6pcnqb9bJwRL9D8VvX7fTu9WEa1mdxgGOPpfF2DrA70F+AkFx6jFVlhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ib+htBLw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SHalvQ40; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771415015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r0oM0RRyjLelkT0G5RoaNy8SGcq/Mnkz7KKwnwr3WCA=;
	b=Ib+htBLw6RhuhGWNazDCUD9voHOh9NShtPMgH+omV66DfoGJiBqC4yjDa+ARsLMvZAqnV7
	NdebflcX/xYdqjnyVWaddNhWReGpXFVVi+1GBKqggdufZpTGlwtX5jDhe2G6xMC4QAs+I7
	vrAwnleHxDzI1cdbs5H1VlhdDdcnZ8Y=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-PeDKT6EqNC-arEebBHXTqw-1; Wed, 18 Feb 2026 06:43:33 -0500
X-MC-Unique: PeDKT6EqNC-arEebBHXTqw-1
X-Mimecast-MFC-AGG-ID: PeDKT6EqNC-arEebBHXTqw_1771415012
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a7a98ba326so11886705ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771415012; x=1772019812; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r0oM0RRyjLelkT0G5RoaNy8SGcq/Mnkz7KKwnwr3WCA=;
        b=SHalvQ40JHG3y1lG+87ChWtS07DFOObCmO3avmV/dn2Apftsh7kFmaDvVbZfUPkPoT
         JAMd6WzOb2LryyjiHyx/Kd7xl/YFe/s3JZvv5cNaehGg4mCjTieELUSEpHwxTnPawfe+
         BrnxNXlihsd4TQFaHC2ptxEYBpp0VvCjCHSZSmx5yviAOyAhmY9PPx+rF9I9SFmxwDnE
         QXgIQ9Q0fm4LktS+6RzqtX+iuABRn7H6ZqRxFIRtTc/S6Yk7rYQiubzxtE90NTIhDAQU
         clUx6HtumMknxXW7pTIJGQjr1xiU9b4O90cQRsY+Bb0xixV2rSW1uq1PFxBaHD9lIPxr
         jnaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415012; x=1772019812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r0oM0RRyjLelkT0G5RoaNy8SGcq/Mnkz7KKwnwr3WCA=;
        b=tAxwnN5ZMnFLxG7J1whplCdGTFv2G9gC9mi6o4RdFog+TVK3hl5SuoVSwg6FrxQjmE
         DlLqTZg2+Nl0N0053f0KXBnbR2BkdyJCKeh/kXmnvLo//5VZU4iqIZT0BAVF7pmqlQOl
         JuwGdU/rQs2D47gMG50Deq/5Ld3MD0B8pDs9EP0l3ywwz9aYqmuGP135TQrfD8cH+/FJ
         gDYqu0Vw6Gl/R4eZIjpiSZ7otOS0wW1gdpVi/rmCt3LyFgNfsNUP9a6htyV0YevqKKtv
         VpFvkNQj7r3VGhBrJKHqgWZZCB4b66wees7H5rq/OTI2ByUSyJUCgDHJCxMSE28U0G7Y
         BfrA==
X-Forwarded-Encrypted: i=1; AJvYcCU8agVih2ptJ9SWZvkYtc/bdpeHISiovLZf+8AWuo7jJ5W3jHbrgyzWb3yFmgYZ2+3xl1g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCYbi1c+P6tuIPPwVT/vmFE2zTmfsMYXoOgaLXPR/WlO+2o+bo
	7Wx+jGqYTnRcsDnycbw2qs1zkHZVOhO2f1IXNijcnFujWe6IkwjIiKc67kyA++R58Ov0F2388A1
	f7uG5nEO4ZY+k6Ar9jnqqCvZODYhGl/EDVMbqfWRZBmQDeZHmIOpv/A==
X-Gm-Gg: AZuq6aITBVQ4ZCgq+zmbgYQq+THXt5DzQR9vwrLts2oULiBMEq3/YbvkMbT6C/q+tKq
	IO829jpeAqRUHTU0yYwVDIAbCU8VXea+QFgFfX6XfC/XCfrfxLUrw7Hj3YBaIA+5aQ66COWGKlM
	23xjLj5knoPdz9UnS8lcn3SoBiJ4NfLgKkYy/jyp25MbgIinqSIOv0zsNj6yYi+wA/D2axtk680
	7xngufDFtLuaBSRRrtjCDRH2KY+6Vljr4beTe8MBSnSjsbOLK/6RsStn+rJsEnbkGdDOoGeX50S
	vycwvmR1FzzovvCPYggGxADjhT2AH97clrg7A6RkCltujKEJV/PWiiV4ba9ItYKfPVILVKVNoBv
	BX87rfWRxCfcGRHMIqyCrjQYVd+4DyxmfQXT7mmTbvtqahShkK6Qp
X-Received: by 2002:a17:903:3ba5:b0:2a7:aac1:7201 with SMTP id d9443c01a7336-2ad50b5a062mr13233285ad.3.1771415012225;
        Wed, 18 Feb 2026 03:43:32 -0800 (PST)
X-Received: by 2002:a17:903:3ba5:b0:2a7:aac1:7201 with SMTP id d9443c01a7336-2ad50b5a062mr13233165ad.3.1771415011824;
        Wed, 18 Feb 2026 03:43:31 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:43:31 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 15/34] i386/tdx: refactor TDX firmware memory initialization code into a new function
Date: Wed, 18 Feb 2026 17:12:08 +0530
Message-ID: <20260218114233.266178-16-anisinha@redhat.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71232-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AF794155FE8
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


