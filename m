Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D43B65F9B0
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 16:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfGDOHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 10:07:23 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38039 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbfGDOHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 10:07:22 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so6322846wmj.3;
        Thu, 04 Jul 2019 07:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dE95kEfeLxRq5/Aw3fUKbbO7rlglotHNzErpcx0ZLL4=;
        b=TPJ0MKPP/78c1zv8QTa1Li+Mze4a/pK7Uj5Ph8vLoK5j0w2S9IpB6+bqQKbM5zUMph
         Wn9CPNM0tkotJFBcwDKTVcdt4RMBubEhnd+w9CLsyl/p/pRUl+aUrGcz86u0tP9HJ2kn
         wO8JNQmc8tYpEtNAWHyYbV7kFmO5azscxtbwtr43i/n1SvKRwC1kgO8cG4wH6qTjPvNH
         6oOaSbyUGqMWrmghUGqAegLwXdUWsUWFaY8jFSObI8rbgj6soccY3eI3tTrJSRUQhikI
         HF9yZlkWP2gamUplzs08xw1LstYC/SWlhU7dYXshaqDR9z+9IJEayXVsAT0HUfnNJt0k
         Xx4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=dE95kEfeLxRq5/Aw3fUKbbO7rlglotHNzErpcx0ZLL4=;
        b=nVjtaMOQYn96YfWZz22oC7k5EHNF7z5G4Mk3aFTo71yXMfaSqQiQ+Tl6eE8AvOflGX
         T/3VUcE4eW5DdivnVPf0u4fFNVMxx9bofrW0Kt5oyKlQLm6LY5y8U7F7IzuukG0aYYW3
         7HV3o9lvpWL2iXmJNbUfhggQTaGBG1EXNgiz37ccZjWZFH/ipKXK/GqWeTd2mzoyL3m+
         UBju5MFvVvr0a83bdK5YwKfkXugrgkQIghIOajl77MAmZ7vgDvDl2/s3jodK2O1Ljuvb
         mMJ96YjJjdQUqNYmt7sJ/IBfPy9ebz2jJ7FhADzztORceDquCbhc2NM+pnErVMrDwrqR
         bq5g==
X-Gm-Message-State: APjAAAVU4+YChpNY352BIA6NjiH133xuFWJ5LKJvvSOjM6Rv+TfMj4+I
        lP6bx3D4bnBjN75IQy1Fjm2cT38gVkM=
X-Google-Smtp-Source: APXvYqxh+WgZYqGfDyEocMu0NUZdV5E7qFTcawdOdIhuANRjt1F9+bkIL6eYUkxnDkXqux3enHGmCw==
X-Received: by 2002:a1c:9a03:: with SMTP id c3mr12892796wme.101.1562249240187;
        Thu, 04 Jul 2019 07:07:20 -0700 (PDT)
Received: from donizetti.redhat.com (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id n5sm4458060wmi.21.2019.07.04.07.07.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 07:07:19 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jing2.liu@linux.intel.com
Subject: [PATCH 3/5] KVM: cpuid: set struct kvm_cpuid_entry2 flags in do_cpuid_1_ent
Date:   Thu,  4 Jul 2019 16:07:13 +0200
Message-Id: <20190704140715.31181-4-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704140715.31181-1-pbonzini@redhat.com>
References: <20190704140715.31181-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

do_cpuid_1_ent is typically called in two places by __do_cpuid_func
for CPUID functions that have subleafs.  Both places have to set
the KVM_CPUID_FLAG_SIGNIFCANT_INDEX.  Set that flag, and
KVM_CPUID_FLAG_STATEFUL_FUNC as well, directly in do_cpuid_1_ent.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1c6b9a4a74de..9ebc5ae7fa0e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -298,6 +298,20 @@ static void do_cpuid_1_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 
 	cpuid_count(entry->function, entry->index,
 		    &entry->eax, &entry->ebx, &entry->ecx, &entry->edx);
+
+	switch (function) {
+	case 2:
+		entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
+		break;
+	case 4:
+	case 7:
+	case 0xb:
+	case 0xd:
+	case 0x14:
+	case 0x8000001d:
+		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+		break;
+	}
 }
 
 static int __do_cpuid_func_emulated(struct kvm_cpuid_entry2 *entry,
@@ -497,14 +511,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	case 2: {
 		int t, times = entry->eax & 0xff;
 
-		entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
 		entry->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
 		for (t = 1; t < times; ++t) {
 			if (*nent >= maxnent)
 				goto out;
 
 			do_cpuid_1_ent(&entry[t], function, 0);
-			entry[t].flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
 			++*nent;
 		}
 		break;
@@ -514,7 +526,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	case 0x8000001d: {
 		int i, cache_type;
 
-		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		/* read more entries until cache_type is zero */
 		for (i = 1; ; ++i) {
 			if (*nent >= maxnent)
@@ -524,8 +535,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			if (!cache_type)
 				break;
 			do_cpuid_1_ent(&entry[i], function, i);
-			entry[i].flags |=
-			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 			++*nent;
 		}
 		break;
@@ -540,7 +549,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	case 7: {
 		int i;
 
-		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		for (i = 0; ; ) {
 			do_cpuid_7_mask(&entry[i], i);
 			if (i == entry->eax)
@@ -550,8 +558,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 
 			++i;
 			do_cpuid_1_ent(&entry[i], function, i);
-			entry[i].flags |=
-			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 			++*nent;
 		}
 		break;
@@ -595,7 +601,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	case 0xb: {
 		int i, level_type;
 
-		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		/* read more entries until level_type is zero */
 		for (i = 1; ; ++i) {
 			if (*nent >= maxnent)
@@ -605,8 +610,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			if (!level_type)
 				break;
 			do_cpuid_1_ent(&entry[i], function, i);
-			entry[i].flags |=
-			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 			++*nent;
 		}
 		break;
@@ -619,7 +622,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->ebx = xstate_required_size(supported, false);
 		entry->ecx = entry->ebx;
 		entry->edx &= supported >> 32;
-		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		if (!supported)
 			break;
 
@@ -645,8 +647,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			}
 			entry[i].ecx = 0;
 			entry[i].edx = 0;
-			entry[i].flags |=
-			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 			++*nent;
 			++i;
 		}
@@ -659,12 +659,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		if (!f_intel_pt)
 			break;
 
-		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		for (t = 1; t <= times; ++t) {
 			if (*nent >= maxnent)
 				goto out;
 			do_cpuid_1_ent(&entry[t], function, t);
-			entry[t].flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 			++*nent;
 		}
 		break;
-- 
2.21.0


