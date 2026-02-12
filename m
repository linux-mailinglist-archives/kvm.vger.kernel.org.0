Return-Path: <kvm+bounces-70911-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wKciG5hyjWn42gAAu9opvQ
	(envelope-from <kvm+bounces-70911-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3447312A96D
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EC3263029F73
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE21C296BBA;
	Thu, 12 Feb 2026 06:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fGRnX71G";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ewa+2sPT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1D029AB15
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877584; cv=none; b=M2lA6NzaE0K2023XEI/SXdMIPgqEDf28AgoFbsE7sCFaPUBAjjTG5T75k5dRWavZf/plIAM0DJwWqo2UaHlclMW4N/0Vy5XD9fZJ0ivvFimukRYEXH0buAQp2Dm1nwCQWLrOhIya8sGRJV7J2VVrHXuON2mDcsK2Qi10FpoLNts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877584; c=relaxed/simple;
	bh=D/HcMH8qipGU081+wbDh7ZzNQ1av8MpUMvJwp4zTjnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfP9+ffaKY6fwAJ/sAp+XJhyJmj/xesybGU9/sOIHqb8sR+P7a1mmSUsCWf9Hx1Hg9J3h6kHQW7+uVnROcrAHULN9h6zt3Mz79JjUkVztGdSACk/knQLVcyG9Iec7zLvs6gkwyy89Z+VIUP1BFZvvBqRabavQ19sptly5eV+wOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fGRnX71G; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ewa+2sPT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r0oM0RRyjLelkT0G5RoaNy8SGcq/Mnkz7KKwnwr3WCA=;
	b=fGRnX71GZoCIBlz6/VE0TQ4CLRcX++ecFB5Sw5Lh8QDYjBgDPtk+hS04UiTKr5vIvPGB1m
	afbP0qEfczZ6Sp3fsf9B/ueO/LUZZbuU908ClhEGknCOxftXS8s2c00jzTccs7BqoVJAqj
	qPJGCIgIgWgrDPt2ld/5bdrGsOjsT6o=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-_Fd-BexpPBqT37brPMieng-1; Thu, 12 Feb 2026 01:26:20 -0500
X-MC-Unique: _Fd-BexpPBqT37brPMieng-1
X-Mimecast-MFC-AGG-ID: _Fd-BexpPBqT37brPMieng_1770877580
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aad60525deso124462055ad.1
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877579; x=1771482379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r0oM0RRyjLelkT0G5RoaNy8SGcq/Mnkz7KKwnwr3WCA=;
        b=ewa+2sPTUdND3n73k5oqA+VotXCleV7MJLZVHvqdcqY7sOSKGaYkjcPACotIuo364K
         YoXX1mzDhecNm9C65QKHggm/OENFCZrIG/Z0sad918EreQRjG2B2HADnQOOyG15VTTL7
         FCWuXEn57acllb+yStfWJ1/xsQpIFm7DIw+EFJIRUXZL+rl/9edyZ7ZHF9K75Lf3KvjR
         76+K61eYAQlTeM9GtUSJZJVc/A/Ah2PfrfiQhFVsjblY0GBLxwufU0M5mxxjVi7XUshu
         yYPFyVv3ZfrYRyKDdJgOvbSQPd7Y8KWWI+oWyG6pPDVfcTTTErGrYZMzTFDm+eUfE08j
         uyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877579; x=1771482379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r0oM0RRyjLelkT0G5RoaNy8SGcq/Mnkz7KKwnwr3WCA=;
        b=JzsYsA5O8IzZLm1ubelso9CuRsvmgEtEN382TqWB7cDKoUk+5TyCXp0Cy6lXfuOuSV
         YV7kap/WEnJphqhZN7CLUBHJSUtvjpR2TfAnONuTKQXagm8GN9ixyQ8trkeQzx04XxpP
         ixJ1Ta4Ph/g4UafIUQv91fUt3CUzyS3NyRn4JwlfOQRPO8lYdNJG/X8G2SYl516cuhM6
         aTeO1bzjEByANc7ki5lIksY3vKFHNo9QYqln1sh4onNvw9f8T0iuHxkm133zojfHC8Ab
         rMkQgAVAhFOYJ1yDSZ7zmWHs5EiRkq2uxwlZ19SEcDkWGT6bpjgSiBTuvGDz4KZDyvEj
         HWmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGZYnJbByUhuTe5dzuYfo9rFg2ASccI6L72rmjVPVPlhalUG9DMaY/glDfZmYI/Ggo978=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+KKJ4y6x/rPkQkZUUaFpaNlX7bIwknzVEojzdxyVQ524W/Kz9
	tRFwE8L0vC+O2q8Rh92rvHWgJplSq/9lF+TJGi1MJ+TCCKcwO9C6OFEfSb7tHpUN/Bd2fc0/hfm
	aYHDfzWD8muIAEpYteKbF6QesFN+W41l3+zYY1NuBPZlIaeFj26TmBAmuWulE/w==
X-Gm-Gg: AZuq6aLOv5hliBzHSQ70+ed2Wb1Xd381R8lC6SVxd3qh3N/dQtK85KLWbAuK1BDsHcO
	K+a+q0/nvNhkbzCXU+3nDtY8zX3wkjpOEa25B+0Yz8p5ARBMShJG3oScij01U8kt9IpHs5uygyS
	uL8F+SonpkqnXwRIiBrFF3sDkRA8ivvlE7hff9VzYT9DjaUQTODYl+GXxtii0NVk9cWARrlNmCx
	UHVgGBNKK0o649cYZIR/N8rd5BwH+was/UU8Qq1IGv7XJoHiTXU5C/7zTADp/VW2/8vBoNlIbLL
	6PpyDUqaL/5riaBrnCS01QJ7SMw4yq4JbXIPWt1cPNe2E3lB58Y81vQnBZtmhRZpBVE3n/HNtPC
	Yt9FofgzjzL/mO0Z5lwYFTMqrIuaZ12LVKkkLo2I/JjHLa7RhKEbENE4=
X-Received: by 2002:a05:6a20:430c:b0:394:426b:6791 with SMTP id adf61e73a8af0-3944897ea20mr1572074637.79.1770877579382;
        Wed, 11 Feb 2026 22:26:19 -0800 (PST)
X-Received: by 2002:a05:6a20:430c:b0:394:426b:6791 with SMTP id adf61e73a8af0-3944897ea20mr1572056637.79.1770877579043;
        Wed, 11 Feb 2026 22:26:19 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:26:18 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 14/31] i386/tdx: refactor TDX firmware memory initialization code into a new function
Date: Thu, 12 Feb 2026 11:54:58 +0530
Message-ID: <20260212062522.99565-15-anisinha@redhat.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70911-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3447312A96D
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


