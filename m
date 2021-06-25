Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8A53B3AB5
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 04:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhFYCGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 22:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbhFYCGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 22:06:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D887C061756
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 19:04:01 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a7-20020a5b00070000b02904ed415d9d84so2084418ybp.0
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 19:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3mP/+BdKrQ7aO+PSZ5ByQH57mwdI9w5uq+kavzIVzf0=;
        b=HEUMCGCMrNL3weObXwwEC1oaATTbBTgyCVnXBcfKkBdMd1tAjLSPXV69HYDjbcSBHM
         zDcxkHhVphG2MHLDuyYAweLM/apXjwpIHMKQf61QXE2u9hX/PdJS6pPiENmgaBdapuUv
         BzlsoFiSfKX+3miGTOAq6McQntrcUyq7aDdluPnPTc7Qx3dOSyWWx2EUMq0SuGiziTbC
         b51m8xJfJfadugJ8vZgFveAa4Q26rjvfXqxsx1p5BQfkQDkkUnlXMsVNzMofq6EYdh1N
         CFLM7iaJ1E451LUewHIdHzatq1nR/tJDYBynqKI+7c3fPNUKVx02IN7Mt87mrSrVl1I6
         QpZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3mP/+BdKrQ7aO+PSZ5ByQH57mwdI9w5uq+kavzIVzf0=;
        b=fMMbF5Qy/0VYsUWxKzNMWm4bkQe7CVsD9SFlyANlVwMONhBr2lL7R9wQEKJqr6MAfP
         9b5WOc3EFYxETRpWRzOrGc+KKUY8oiWCsdab149MuSjzx7BzW+F7S0UDFB9DC+od7u5k
         JZwrzDLX9cG4/aW931le49LdrPYPmbF9k7IpZ55lw1z1HyBn27LEra1ww0zs0af1ZM7d
         2wmLOh2PHNWKUUEX6DVqs11qND4UNatybsns7xaazBuL44YryLyiHZvk94dhTFgkowMg
         hRxWd7Iup5SqNBNrB+4RVMHCMYAEvF5m+Xr1C4mXJzhuryb7/2w5/mWPTzX07ENnET7Y
         WSRA==
X-Gm-Message-State: AOAM532SmX6m3TjsrGPT0qa0tDYv/7O923av3lXlvBlInlqYNO4Ry12Y
        wrkpUPBvYy5BEA9pd0XE7d3NZzZphEE=
X-Google-Smtp-Source: ABdhPJzxQWv2PERq0Ou0NC+2by1+xYTjZM22deN0B4T1wpG7wdXoLFgqX0bVvv4BqAE4aVFGqcdtOfjmyK8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7c83:7704:b3b6:754c])
 (user=seanjc job=sendgmr) by 2002:a05:6902:102a:: with SMTP id
 x10mr8801256ybt.451.1624586640382; Thu, 24 Jun 2021 19:04:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Jun 2021 19:03:53 -0700
In-Reply-To: <20210625020354.431829-1-seanjc@google.com>
Message-Id: <20210625020354.431829-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210625020354.431829-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 1/2] Revert "KVM: x86: Truncate reported guest MAXPHYADDR to
 C-bit if SEV is supported"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It turns out that non-SEV guest can indeed use bit 47, and the unexpected
reserved #PF observed when setting bit 47 is due to a magic 12gb
HyperTransport region being off limits, even for GPAs.  Per Tom:

  I think you may be hitting a special HT region that is at the top 12GB
  of the 48-bit memory range and is reserved, even for GPAs.  Can you
  somehow get the test to use an address below 0xfffd_0000_0000? That
  would show that bit 47 is valid for the legacy guest while staying out
  of the HT region.

And indeed, accessing 0xfffd00000000 generates a reserved #PF, while
dropping down a single page to 0xfffcfffff000 does not.

This reverts commit 3675f005c87c4026713c9f863924de511fdd36c4.

Cc: Peter Gonda <pgonda@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c   | 11 -----------
 arch/x86/kvm/svm/svm.c | 37 ++++++++-----------------------------
 arch/x86/kvm/x86.c     |  3 ---
 arch/x86/kvm/x86.h     |  1 -
 4 files changed, 8 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0edda1fc4fe7..ca7866d63e98 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -955,17 +955,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		else if (!g_phys_as)
 			g_phys_as = phys_as;
 
-		/*
-		 * The exception to the exception is if hardware supports SEV,
-		 * in which case the C-bit is reserved for non-SEV guests and
-		 * isn't a GPA bit for SEV guests.
-		 *
-		 * Note, KVM always reports '0' for the number of reduced PA
-		 * bits (see 0x8000001F).
-		 */
-		if (tdp_enabled && sev_c_bit)
-			g_phys_as = min(g_phys_as, (unsigned int)sev_c_bit);
-
 		entry->eax = g_phys_as | (virt_as << 8);
 		entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 616b9679ddcc..8834822c00cd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -860,26 +860,6 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	}
 }
 
-static __init u8 svm_get_c_bit(bool sev_only)
-{
-	unsigned int eax, ebx, ecx, edx;
-	u64 msr;
-
-	if (cpuid_eax(0x80000000) < 0x8000001f)
-		return 0;
-
-	if (rdmsrl_safe(MSR_AMD64_SYSCFG, &msr) ||
-	    !(msr & MSR_AMD64_SYSCFG_MEM_ENCRYPT))
-		return 0;
-
-	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
-
-	if (sev_only && !(eax & feature_bit(SEV)))
-		return 0;
-
-	return ebx & 0x3f;
-}
-
 /*
  * The default MMIO mask is a single bit (excluding the present bit),
  * which could conflict with the memory encryption bit. Check for
@@ -889,13 +869,18 @@ static __init u8 svm_get_c_bit(bool sev_only)
 static __init void svm_adjust_mmio_mask(void)
 {
 	unsigned int enc_bit, mask_bit;
-	u64 mask;
+	u64 msr, mask;
+
+	/* If there is no memory encryption support, use existing mask */
+	if (cpuid_eax(0x80000000) < 0x8000001f)
+		return;
 
 	/* If memory encryption is not enabled, use existing mask */
-	enc_bit = svm_get_c_bit(false);
-	if (!enc_bit)
+	rdmsrl(MSR_AMD64_SYSCFG, msr);
+	if (!(msr & MSR_AMD64_SYSCFG_MEM_ENCRYPT))
 		return;
 
+	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
 	mask_bit = boot_cpu_data.x86_phys_bits;
 
 	/* Increment the mask bit if it is the same as the encryption bit */
@@ -1028,12 +1013,6 @@ static __init int svm_hardware_setup(void)
 	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
-	/*
-	 * The SEV C-bit location is needed to correctly enumeration guest
-	 * MAXPHYADDR even if SEV is not fully supported.
-	 */
-	sev_c_bit = svm_get_c_bit(true);
-
 	/* Note, SEV setup consumes npt_enabled. */
 	sev_hardware_setup();
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4a597aafe637..13905ef5bb48 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -209,9 +209,6 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU)
 
-u8 __read_mostly sev_c_bit;
-EXPORT_SYMBOL_GPL(sev_c_bit);
-
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index bc3f5c9e3708..44ae10312740 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -328,7 +328,6 @@ extern u64 host_xcr0;
 extern u64 supported_xcr0;
 extern u64 host_xss;
 extern u64 supported_xss;
-extern u8  sev_c_bit;
 
 static inline bool kvm_mpx_supported(void)
 {
-- 
2.32.0.93.g670b81a890-goog

