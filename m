Return-Path: <kvm+bounces-65835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC7DCB90DC
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:08:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3CEEE3095E7A
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2556319604;
	Fri, 12 Dec 2025 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dgufqcb9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sA2whNaV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED583176F4
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551911; cv=none; b=F+VBzXvMs27Oikrh+C+nOPKwZHQmEfzxZUhUX4QTnS7Y/GIL6yrmUcXbHr6+NcYhJcc7qtLEcBr4toa+JSzug+4fmdMwLkRWlVGLeaJDohGJRItD6U+ui5CUParNaUFU8gZImyMslBawwWpUj9YSIeTlHFfgvcd1zXMV871N3QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551911; c=relaxed/simple;
	bh=81Yn9dXth6xN3HTqQxwmxYHBGw2Q9kVfmuhnlsxL7UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfdGkqpchtSQqTCs67I5H9IQNjUYWeAlUo7lHmgT3CccJ1bvMCSp7UcjM8Ho/ye8RIiNP2Cc01NJ3kq9MZ4vNGyWJ4xKe/0sv88a/twqVmw7BcY/1z3lmpmURu+rvPV/3bDG55GE7Q/uZKB2YGRtY+ohrOpFug0VVzbS66tRpCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dgufqcb9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sA2whNaV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QEPt+WowIb7JNUH1z2t2M9hX2SLVHr72KxzuR57IAVY=;
	b=Dgufqcb9fmsobKcCbWXCW7um5hmgDMl5p2x4mUUmsaNd6GDzqTL33Q89/EdqQe3keVxya6
	xqYBvIVbTOi/q6/SLgh/gz01Ub4gsbTnhvryZyNW79b74vbyFlJQxTD3zUVQxzFtoNqVIe
	VENyMfVzcekJAVqzs0+S9ZT1A+zFP+Q=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-VMonQU5GPhypfyzBc1VCqg-1; Fri, 12 Dec 2025 10:05:04 -0500
X-MC-Unique: VMonQU5GPhypfyzBc1VCqg-1
X-Mimecast-MFC-AGG-ID: VMonQU5GPhypfyzBc1VCqg_1765551903
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2982b47ce35so15036665ad.2
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551903; x=1766156703; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QEPt+WowIb7JNUH1z2t2M9hX2SLVHr72KxzuR57IAVY=;
        b=sA2whNaVArLEOpQiZ/ZAKAHfi3qrWVQP2rJYaHqWmUZCI21iMr7jGp4BE8xQj8ae6H
         z7dIQRch5fHti9taHKqcbXHzLTOWGQJ5A4gTaUS6nqjOQTgVy9Uue0H7QJQf7jtI9RsM
         6mJ46g/FFKb2iPhMEgklFMNEmdbc77o+/XssUHFUyg4rwokrOlEKsmtt4VHzP3yAclEH
         vMqsEluqt/UOcWdPAvS8gL27qnjqnzlk91Nk81i2qOcpMxG5p5bDWwU/Ejlls/tAx5Wl
         QiKS4GVOjDGH/WI5Qx6PAmJ+QZ9tZwFT/Hk4kDOT0ejHnTRgfEpP7Cb35B8sjkzKPrCi
         Bvew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551903; x=1766156703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QEPt+WowIb7JNUH1z2t2M9hX2SLVHr72KxzuR57IAVY=;
        b=FdkhZS6xFTTkqqgnhbUA/ftB1CfJTAkHYqnQXT/wd3J4YOZjQnm/ScdE+mppd4w07E
         Im4C4UsuVxhfZFm/Uhyx3f1sWLjga/jPQcza5/zF/iePzEcQSNZEd2EzE/B7Kg445gsp
         Ve5U3I6dkEo4w9hW2YrgxHBczPyECXfoJsznNH2HXe+Ma7QnJNwHSS2nULGybQVlv5xT
         c/pjjfndba/SQxLgS63wx4/YlA+cNEFk0ZpC6sgiOIVR7QLDzc1zezFDIXRFanf8h/WT
         6VAisDjEKxgS0uR5Jbtq+5NLEpzwpxoScxFjTyAn2Wrc+zymsTaEPEmqC+LZsc6idd89
         QHBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMbA7V6/mE+XEk4+eNl33JzUyg53RdEnWeuvmJXxHVMkWb+O8M6mVlV5goi/fDXILz8bA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQVgG/HiQ+Mhp35ORSuqFm4Ujql8rGJ3zrqlzeuQkrBA+UwmDO
	Z56izgf8xdrdpDmTT8IGs/RZEBY4SbahmMeiebqyN68RtJroRY3IEWX4DPGqZbpKfHoYx4zoxXl
	Q6Qu22+qmldbVBz5gLWiHwrC2puBzTlEJiYicJtSDqpWJ9xR76ujx2A==
X-Gm-Gg: AY/fxX7vJAxYb1G5dBM4OTzu9n6Vc80CJbe2QJ2IBR0mxxtXiIz+29ZAEEftYGaRoh3
	Yh0ZKJaHpFhFi4l7evm3sTT3fNS8Vl6tY8/Rmrp7gv0jKDg2lVb0bkhdbbLxDpkTIbnXreg4E3O
	zsdHLzl+/YWej1RFrGtpBEm62FNGULbvm4mApOGYpY73p9ciw2sx2WgJjNCIcPwngABabnXWOGo
	wnvZNnhtKR9MzrVCR4DSDKnHtkKJm7nKCgFfXWOspIZTt58jwL2teWmomUWgSGe8/9akMIyDvOr
	stWue43ayCIejI36GwgEaj134tDc4W/KPuaJq+uakP+GRE2TDBQeDcila44p8StyLYCrv2Z3DJZ
	wJQR1P1Gw1VxRiFZOMu1uiKpe0trBwr5BiZSrQLlOODs=
X-Received: by 2002:a17:903:3bad:b0:290:91d2:9304 with SMTP id d9443c01a7336-29f23dd3f75mr20990435ad.4.1765551903321;
        Fri, 12 Dec 2025 07:05:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFCuDP1WPBimYZnnChi088VUoRgeHW+JpdMIlzKSP9VG3LKJNNtQYHbpwf2LR+NQccXZsDqQ==
X-Received: by 2002:a17:903:3bad:b0:290:91d2:9304 with SMTP id d9443c01a7336-29f23dd3f75mr20990085ad.4.1765551902848;
        Fri, 12 Dec 2025 07:05:02 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:05:02 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 12/28] i386/tdx: refactor TDX firmware memory initialization code into a new function
Date: Fri, 12 Dec 2025 20:33:40 +0530
Message-ID: <20251212150359.548787-13-anisinha@redhat.com>
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

A new helper function is introduced that refactors all firmware memory
initialization code into a separate function. No functional change.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/tdx.c | 73 ++++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 33 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index dbf0fa2c91..bafaf62cdb 100644
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


