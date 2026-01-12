Return-Path: <kvm+bounces-67741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 64A5ED12C99
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:28:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EB2F3306CA6F
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCFC735971F;
	Mon, 12 Jan 2026 13:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WBCuq6Xv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OFXIjpvV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD5D35970C
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224245; cv=none; b=FOugF2ZvHHaRricvZiNlZmIxsOR04ypdPS8CmDHIajy+P6o5oxC+qzlu6rbdlHo9K1CWDS5z4M+MYWQxxIZUW+MnJX2U8DEdSXIyleR0a6i3xrr0hUT7FsscZeHY6bwkWmRYH1SlMmQslQjW9D+1hKhXOVBcp8LkViIKMMjd8oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224245; c=relaxed/simple;
	bh=CxNbVgTStU7mJe9LuevVmMO0iLIz/EAkSSCXiXn7UuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUerVOKxoYdJIEckyUnqbPM8avdgl35x0Af8uJVOCT5tdRsRBowDeuRiEjeGG6HjdIG6EX4IhBVULwIZqN8RFReN28bAy9pRKeyDO3QnyleJ6JAxxz5+ZBKNcgtdojX/CKMrs+2dpVf/4ji2/z1HeeJucs1/mhOVUMFYXM9Ub8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WBCuq6Xv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OFXIjpvV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=enQS01mePhcqrNpRvIEAIkNk+KPz6jEdRutgiDslPTQ=;
	b=WBCuq6XvU2UYJwDrgK5g2zM1sB3g/E+OOQvtEArpiikx+071rKbfksCHivD6gwu8NExeCC
	ku9sJF8UFvEbTkS0MBJwMv2Uif1/09nMUvvPvLf3BqNdRBpS2BtbgE2RHFKEQz3Jk63cnL
	V2ny4vh621c3LISRJJ2KJxLTUjq5xuo=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-2MDLJ3KyMii3rBrybaZAKQ-1; Mon, 12 Jan 2026 08:24:01 -0500
X-MC-Unique: 2MDLJ3KyMii3rBrybaZAKQ-1
X-Mimecast-MFC-AGG-ID: 2MDLJ3KyMii3rBrybaZAKQ_1768224241
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b6ce1b57b9cso4438841a12.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224240; x=1768829040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=enQS01mePhcqrNpRvIEAIkNk+KPz6jEdRutgiDslPTQ=;
        b=OFXIjpvVHN+HlPieF8HQTHeo9UFvqslNkJJIyTHOho0T2mxMx7pFMJdmwj7T38KICt
         BRUqtKGWeVAarBnD91+ltfs3aHtQ0lXjPjxRbE1besMure0B9cXWivjkIAzF3L9fWjhV
         HLNFrtCCmhbAbC5G7UqB+BwNNMwr4T7Kd9lTEchfO1YxIlBpFOtUR3pBo3JGyhB6l20O
         3ZM7H5CbUE7cQXrTBABksCsH3jVgRNXGLhUyJ+BklpqQ4UYWNObIThXnUpTQcaeOcAuO
         8BiCmJWTHIgV63/+K+TC1GWu7QOmuDRh472dwP21yFi6QhmmW1+Al7GZOgRY/ZGET/ab
         7ziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224240; x=1768829040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=enQS01mePhcqrNpRvIEAIkNk+KPz6jEdRutgiDslPTQ=;
        b=iApyKUrV6psWgPAXJl2XHVRJcWoZBA84Yi6AdS4KYzyTZ1k5pEV4Z4L9HslJ/Vt7N2
         uU7y3WFQM0RpBy0FmTvWS/Nqvh8FMj/gBDsPNznRUWtlI5FFPf4lpavKyinMT1iXvCRw
         ch0K7gnTvSeKU65S02qLcNOKQTAVuudBOIBcGdNXIcFnw/LYOtMR7tHaGAbWeOHihxTv
         irVehjYUjGPF4Er0M2s42kFHNbz2bCHLSiLlv3l5tyyZ+Cuzmcj1Qwlrxyktrh3uvdgY
         vti61IuCnKvNWJBKtESZYhvNvQuEVT6V92UpVEnUPpf6EypqUBtzxGhTW96Z0aY/KzJd
         zYSA==
X-Forwarded-Encrypted: i=1; AJvYcCXPBAzQcEQf165D8eXaY1aSe6cmLoQ5bPbED9vBcaX8htM5IOfelpnLKlz/oYmi5kdCQPM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0XJmZKK/tVpHs/eHM4MpDZHZxLn5dpDWl4EltsgZZKgOjJ60X
	E3cEHOcX2sueOLs9VjQgPPI74sMCkYXGV9Z/iOXmkcvFhMEZvqgHeZa3R7Ir7vcl3TFGfz8/XPC
	qYvNTZ8FAYQ/tF2ZQeI1dAlxTXxTMq3wjvHlG04ujGgVuMj4Q7mvqHXYLLY0BTw==
X-Gm-Gg: AY/fxX4SW7WBW5re2Rm0733Mep9PK/8oQMPm8xhjx1SD3AvEWFAK3jSx7tp1PFEvZjr
	oOICLiI5H6pK9tlAo/leA8ywAJcq8jLEiE90rJ1INflqBVlwwIpOauOmm8j4U9tzlH5BnTuRc0z
	1Ut0ponTYYHGczR1zr4rilCVJ0B9gOkLML0PUJ8pF07Kw2XnjoCKeSLjF8IDNOpWTfTZtyaeQ8O
	DxPJHrb4elG51oAiRWbvhAdXS9HESekztXh8u6OHNTSCk+N54tqkFULFnf+9gj/oEXFr66yjeMe
	2iKKvwkXkVXdTnct+k5Ej5nItS94+rwKv4jgpLJm9N8l23DAB+n0rxaJbkR1kcDWE25rGbZc2oi
	l3un6Ka7fcbgov8B/clNAWQTfBxdJJzYH+v8WJ1omVRM=
X-Received: by 2002:a05:6a20:938e:b0:2ea:41f1:d54a with SMTP id adf61e73a8af0-3898f97ad8cmr14440073637.55.1768224240372;
        Mon, 12 Jan 2026 05:24:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF9AdsORso1hajXEudPS+SoWB6CKZvQc/iJn1g5/STVkIOIrztq9DXKIx4zeqdAO8x58tFeew==
X-Received: by 2002:a05:6a20:938e:b0:2ea:41f1:d54a with SMTP id adf61e73a8af0-3898f97ad8cmr14440059637.55.1768224239987;
        Mon, 12 Jan 2026 05:23:59 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:23:59 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 13/32] i386/tdx: refactor TDX firmware memory initialization code into a new function
Date: Mon, 12 Jan 2026 18:52:26 +0530
Message-ID: <20260112132259.76855-14-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260112132259.76855-1-anisinha@redhat.com>
References: <20260112132259.76855-1-anisinha@redhat.com>
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
index 0161985768..b595eabb6a 100644
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


