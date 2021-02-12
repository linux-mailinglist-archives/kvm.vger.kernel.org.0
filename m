Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B1A319784
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 01:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhBLAfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 19:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhBLAfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 19:35:00 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6E8C061788
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 16:34:20 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id bc13so5196886qvb.9
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 16:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=M+eyZ12tarq6UkDTGfT0OACpGX3Sqrl84N/PdHAw1yU=;
        b=noaYGPU2lYBspzZciBFmGhYBxjzuQ7nsmNTnWE7bK+VXu1VfCXybGuUI3vhsNy0Vkw
         m4sEnBsWWYJPdfib4mqj77emep6BvLkp66x6M3B2dC4bFuaYLcJ9I6blaCgrgMwyzeER
         n9vW4Ya5T967d1I+JLEJ8J1m4ifdoqOEBxbKcBtmgv6oTFBIGGF3lanJrary0UbAZc+N
         fv9kgzA/qPiarqOAkcyFYTTAUOdOhI+uBHmIW3AgJNukRZEifAcJZQPaSFddjjYWGhEB
         zxDXK6DlOqRKWSb/e2ccRbj31QToEOqObrRgGoK51y+eP6O7zkK2E+w9eSJDv5XKhqGi
         T3aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=M+eyZ12tarq6UkDTGfT0OACpGX3Sqrl84N/PdHAw1yU=;
        b=uPSJd1+t6pa2zHFTxd+G27XNiWuGIUTNjUpRWCx3hpuSpTDjk7VXJrQXlJxmhW2Glq
         zd5QeWkY21aZgZ7Zx7IQC4Pn75yKjVkd/TwgFzlcZ6ME4WIYMsA8VNH5cq0FyxtUc/hk
         jUMRn4XRTDww1lycdkyeeTnVOLLYNpRStHWIfeWqfwCF2d+ZxFuH1xAhB9m4N03Il+Lk
         +wHSS8TZGHulR58kIl11d2c9oEXWRR5Q/MHbPmYGVlFhWtiJodFpon6MIo3lqd4Rx/Qg
         +OWRNOILaQcXpUoi3R1uX9V7X9l6yKR0uxb8yZn1CWEyDke0l4ZIucqbfn2HFzdZZ2eU
         WlMA==
X-Gm-Message-State: AOAM532bzyq1QgKu6KhT5KPlUvWY8HDdXOZYdgrjgcfYDnTk8NPEDa+v
        f5c4FmI0m1NLzxa0YP1vsK7c+0vP+1A=
X-Google-Smtp-Source: ABdhPJxEkdaoRqPqf5oFS/oyQj2EMhabB41ggzQAHTxQMUh2tIPzigyF9exo98vwfWsvOTuVsIo8wFsMAVw=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f588:a708:f347:3ebb])
 (user=seanjc job=sendgmr) by 2002:ad4:4b30:: with SMTP id s16mr520658qvw.62.1613090059665;
 Thu, 11 Feb 2021 16:34:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 Feb 2021 16:34:10 -0800
In-Reply-To: <20210212003411.1102677-1-seanjc@google.com>
Message-Id: <20210212003411.1102677-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210212003411.1102677-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 2/3] KVM: x86: Advertise INVPCID by default
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Advertise INVPCID by default (if supported by the host kernel) instead
of having both SVM and VMX opt in.  INVPCID was opt in when it was a
VMX only feature so that KVM wouldn't prematurely advertise support
if/when it showed up in the kernel on AMD hardware.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c   | 2 +-
 arch/x86/kvm/svm/svm.c | 3 ---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c8f2592ccc99..6bd2f8b830e4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -408,7 +408,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_mask(CPUID_7_0_EBX,
 		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
-		F(BMI2) | F(ERMS) | 0 /*INVPCID*/ | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
+		F(BMI2) | F(ERMS) | F(INVPCID) | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
 		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
 		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
 		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | 0 /*INTEL_PT*/
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ca9706c2f99b..f4eca77f65c6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -926,9 +926,6 @@ static __init void svm_set_cpu_caps(void)
 	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
-
-	/* Enable INVPCID feature */
-	kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
 }
 
 static __init int svm_hardware_setup(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e0a3a9be654b..6d265b2523f8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7330,8 +7330,8 @@ static __init void vmx_set_cpu_caps(void)
 	/* CPUID 0x7 */
 	if (kvm_mpx_supported())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_MPX);
-	if (cpu_has_vmx_invpcid())
-		kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
+	if (!cpu_has_vmx_invpcid())
+		kvm_cpu_cap_clear(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
 
-- 
2.30.0.478.g8a0d178c01-goog

