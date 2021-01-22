Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482EC300DF2
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 21:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbhAVUm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 15:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730519AbhAVUl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 15:41:57 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD7CC061794
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:41:01 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id l3so6652248ybl.17
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=pyxHmRO3h+haE3GvdjoFL8/WjTXx2t0JBZMhtHNwcy4=;
        b=qULn3gC2JI23ZACklCrVFPH5xhV9FcCh5pr32mrm7ML5uUbqEquuC47toqsDtYjeYz
         /vWQ7/hpxBOldcPTDbwAOysm5k7C/HcrThH5CFikVD0ZDsDbsq6DrneZvkEIY+nbuWwH
         PMBofzdU/eJGwFsp28amnxA6U1Ki0wfxxKcGk3ToFr60xtShikL6mjIN2qXxB0Q4MPKA
         Vy9GzIx5T9GEsSgq9QpF2ukGJN36n5tZMQxICuYaT1/fGJWHlkjqQWzpPPsgy2dUoSgW
         vlnyHmEvceznYufijHCik3v+ir/gEFHJJ0hLfVN0U4tIWihWaT5yrihgYH3qhEhBSX9I
         wApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=pyxHmRO3h+haE3GvdjoFL8/WjTXx2t0JBZMhtHNwcy4=;
        b=g6XpxNBQnr/xNXRZ17B8Z0ZYv6xN7ZRJ9Vz8x9mM5L0hXAk5Kdd+sxqQejGsHXtJvp
         vn9ppG6RUx8t5XYhX1O64Fx9qz9geM6RdilQ5rynka9BH+Bldb4b1pjYw90G7Lud82D0
         pYAZ9E4OprThPREG9jQeNtmXKpvH1qP9PZkoqbB3Xbcq5z+bzH0++p/pNq/J84PtJGVA
         erk9cb6zoySQZp6oO15Mc/HCnLovXVMxwS8rm/yUSPT0vABTQLgB+p+aqoWmQfJ1YOBe
         jZ0AprlIP+VW77oFtXFC/CEoTigamaQgDKE/CSwn2Udo017X6db7zxTbMyG5q58WGZU0
         +8IQ==
X-Gm-Message-State: AOAM531BHvLXmzKZYj0BPimUM0NJPuDtt7L8f1dWTGzkcgpj0hOemGjw
        tnc3W6UVYauGGPeZJR7wWDidGoQEpss=
X-Google-Smtp-Source: ABdhPJwpymYTKSo4i45gzHRjk4zVwg3jh4A09yJceemynb6NjecSeQmF/7Bpp7hRXWbfzC49vBZWry7fx00=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a05:6902:706:: with SMTP id
 k6mr9162371ybt.52.1611348060485; Fri, 22 Jan 2021 12:41:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 12:40:47 -0800
In-Reply-To: <20210122204047.2860075-1-seanjc@google.com>
Message-Id: <20210122204047.2860075-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210122204047.2860075-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v3 2/2] KVM: x86: Override reported SME/SEV feature flags with
 host mask
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a reverse-CPUID entry for the memory encryption word, 0x8000001F.EAX,
and use it to override the supported CPUID flags reported to userspace.
Masking the reported CPUID flags avoids over-reporting KVM support, e.g.
without the mask a SEV-SNP capable CPU may incorrectly advertise SNP
support to userspace.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 2 ++
 arch/x86/kvm/cpuid.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 13036cf0b912..b7618cdd06b5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -855,6 +855,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	case 0x8000001F:
 		if (!boot_cpu_has(X86_FEATURE_SEV))
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		else
+			cpuid_entry_override(entry, CPUID_8000_001F_EAX);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index dc921d76e42e..8b6fc9bde248 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -63,6 +63,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
+	[CPUID_8000_001F_EAX] = {0x8000001f, 1, CPUID_EAX},
 };
 
 /*
-- 
2.30.0.280.ga3ce27912f-goog

