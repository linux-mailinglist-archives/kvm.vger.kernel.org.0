Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB3F5F9AF
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 16:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfGDOHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 10:07:22 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44782 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727765AbfGDOHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 10:07:21 -0400
Received: by mail-wr1-f66.google.com with SMTP id b2so5551385wrx.11;
        Thu, 04 Jul 2019 07:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TXWY3JXqY8YM2j7DiQgC7j1tlV3rV7fwMb9fAwdKWCE=;
        b=KFu6zdf5PgZ33BpjDy3Jk4WM/6Lhgosg6L7NlXWDTTdDXKGaDfIPyOBR4Ddm2Zt4xT
         OmJImSIwcXPQefb5NVdpo+SYJ2QV7091XW+8GX2mMlUVajWdvPFa1Jwdoaqcdx/UqPSY
         hIfhN1mTvoBmGW6SXu10g84FKxv/gC3r3+/ntE6fCam7K6ZjZ8JiyeMfTmaI1+SWTiML
         cIyz+v5fy+2hIgQYhOlVn4Dbjqa1Dg2jeJTui2WbFrGAD1B0NGGBSJu6VNO0sHjrMqnx
         uKClSx5frsnFgNQEAyRTv0BmBQkoOrncQRw1TgFBVCiyjG/OXO2QlAJDLRzUEzsZM19W
         OTSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=TXWY3JXqY8YM2j7DiQgC7j1tlV3rV7fwMb9fAwdKWCE=;
        b=ixwzs6dm8Y6iazjUFovHlI2BPaQ71g0wgyUkdhICpuhKySRZfJgWyyz08NUkHUUhIa
         stP9qqYN/E2ERFLDNlEkmiEQCA/EBqQoHPoW3ZwrWclWCA7PNbtVICBmPX74BJILO1yN
         3BWPGXdVdX5lqCQ7Jy6I6TbNG6tpxTAAex/HSkWGJX7p60A4ChvWQxgog3b79LcVwu3p
         D7WYLkZNufWPT6c9QPmMKtIjUqakSKgM13tdpd5rYliiCneFl/IwK+rlSeHxtFyG9zb2
         u2LQUj22h6I9zbpbF71K7Cw3oRGEG5PbZzJoCaeu/ZGqAXUlHJQlOg4II/dqoxm7LBbe
         uIlA==
X-Gm-Message-State: APjAAAUZdMoOwjdY+i5o4YsYjCT8CmRthAIbIq7y0MgVfjPGsyWaWNYk
        jJn6rWyIxKqbK0S+HKd3yg2BzI+9zzU=
X-Google-Smtp-Source: APXvYqwvlou9bVWGPndoOXIbWeHQNGZgSOWH07MHueG5zvuIPAv298a9fJNhbGbz64+8lLgfR1q0rw==
X-Received: by 2002:a5d:43d0:: with SMTP id v16mr32643596wrr.252.1562249238125;
        Thu, 04 Jul 2019 07:07:18 -0700 (PDT)
Received: from donizetti.redhat.com (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id n5sm4458060wmi.21.2019.07.04.07.07.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 07:07:17 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jing2.liu@linux.intel.com
Subject: [PATCH 1/5] KVM: cpuid: do_cpuid_ent works on a whole CPUID function
Date:   Thu,  4 Jul 2019 16:07:11 +0200
Message-Id: <20190704140715.31181-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704140715.31181-1-pbonzini@redhat.com>
References: <20190704140715.31181-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename it as well as __do_cpuid_ent and __do_cpuid_ent_emulated to have
"func" in its name, and drop the index parameter which is always 0.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 89 +++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 004cbd84c351..ddffc56c39b4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -294,14 +294,19 @@ static void do_cpuid_1_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 {
 	entry->function = function;
 	entry->index = index;
+	entry->flags = 0;
+
 	cpuid_count(entry->function, entry->index,
 		    &entry->eax, &entry->ebx, &entry->ecx, &entry->edx);
-	entry->flags = 0;
 }
 
-static int __do_cpuid_ent_emulated(struct kvm_cpuid_entry2 *entry,
-				   u32 func, u32 index, int *nent, int maxnent)
+static int __do_cpuid_func_emulated(struct kvm_cpuid_entry2 *entry,
+				    u32 func, int *nent, int maxnent)
 {
+	entry->function = func;
+	entry->index = 0;
+	entry->flags = 0;
+
 	switch (func) {
 	case 0:
 		entry->eax = 7;
@@ -313,21 +318,18 @@ static int __do_cpuid_ent_emulated(struct kvm_cpuid_entry2 *entry,
 		break;
 	case 7:
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-		if (index == 0)
-			entry->ecx = F(RDPID);
+		entry->eax = 0;
+		entry->ecx = F(RDPID);
 		++*nent;
 	default:
 		break;
 	}
 
-	entry->function = func;
-	entry->index = index;
-
 	return 0;
 }
 
-static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
-				 u32 index, int *nent, int maxnent)
+static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
+				  int *nent, int maxnent)
 {
 	int r;
 	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
@@ -431,7 +433,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	if (*nent >= maxnent)
 		goto out;
 
-	do_cpuid_1_ent(entry, function, index);
+	do_cpuid_1_ent(entry, function, 0);
 	++*nent;
 
 	switch (function) {
@@ -496,34 +498,28 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		break;
 	case 7: {
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-		/* Mask ebx against host capability word 9 */
-		if (index == 0) {
-			entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
-			cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
-			// TSC_ADJUST is emulated
-			entry->ebx |= F(TSC_ADJUST);
-			entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
-			f_la57 = entry->ecx & F(LA57);
-			cpuid_mask(&entry->ecx, CPUID_7_ECX);
-			/* Set LA57 based on hardware capability. */
-			entry->ecx |= f_la57;
-			entry->ecx |= f_umip;
-			/* PKU is not yet implemented for shadow paging. */
-			if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
-				entry->ecx &= ~F(PKU);
-			entry->edx &= kvm_cpuid_7_0_edx_x86_features;
-			cpuid_mask(&entry->edx, CPUID_7_EDX);
-			/*
-			 * We emulate ARCH_CAPABILITIES in software even
-			 * if the host doesn't support it.
-			 */
-			entry->edx |= F(ARCH_CAPABILITIES);
-		} else {
-			entry->ebx = 0;
-			entry->ecx = 0;
-			entry->edx = 0;
-		}
 		entry->eax = 0;
+		/* Mask ebx against host capability word 9 */
+		entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
+		cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
+		// TSC_ADJUST is emulated
+		entry->ebx |= F(TSC_ADJUST);
+		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
+		f_la57 = entry->ecx & F(LA57);
+		cpuid_mask(&entry->ecx, CPUID_7_ECX);
+		/* Set LA57 based on hardware capability. */
+		entry->ecx |= f_la57;
+		entry->ecx |= f_umip;
+		/* PKU is not yet implemented for shadow paging. */
+		if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
+			entry->ecx &= ~F(PKU);
+		entry->edx &= kvm_cpuid_7_0_edx_x86_features;
+		cpuid_mask(&entry->edx, CPUID_7_EDX);
+		/*
+		 * We emulate ARCH_CAPABILITIES in software even
+		 * if the host doesn't support it.
+		 */
+		entry->edx |= F(ARCH_CAPABILITIES);
 		break;
 	}
 	case 9:
@@ -750,20 +746,19 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	return r;
 }
 
-static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 func,
-			u32 idx, int *nent, int maxnent, unsigned int type)
+static int do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 func,
+			 int *nent, int maxnent, unsigned int type)
 {
 	if (type == KVM_GET_EMULATED_CPUID)
-		return __do_cpuid_ent_emulated(entry, func, idx, nent, maxnent);
+		return __do_cpuid_func_emulated(entry, func, nent, maxnent);
 
-	return __do_cpuid_ent(entry, func, idx, nent, maxnent);
+	return __do_cpuid_func(entry, func, nent, maxnent);
 }
 
 #undef F
 
 struct kvm_cpuid_param {
 	u32 func;
-	u32 idx;
 	bool has_leaf_count;
 	bool (*qualifier)(const struct kvm_cpuid_param *param);
 };
@@ -836,8 +831,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 		if (ent->qualifier && !ent->qualifier(ent))
 			continue;
 
-		r = do_cpuid_ent(&cpuid_entries[nent], ent->func, ent->idx,
-				&nent, cpuid->nent, type);
+		r = do_cpuid_func(&cpuid_entries[nent], ent->func,
+				  &nent, cpuid->nent, type);
 
 		if (r)
 			goto out_free;
@@ -847,8 +842,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 
 		limit = cpuid_entries[nent - 1].eax;
 		for (func = ent->func + 1; func <= limit && nent < cpuid->nent && r == 0; ++func)
-			r = do_cpuid_ent(&cpuid_entries[nent], func, ent->idx,
-				     &nent, cpuid->nent, type);
+			r = do_cpuid_func(&cpuid_entries[nent], func,
+				          &nent, cpuid->nent, type);
 
 		if (r)
 			goto out_free;
-- 
2.21.0


