Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABADC32F7A4
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 03:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhCFB7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 20:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhCFB71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 20:59:27 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B79C06175F
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 17:59:27 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id o7so3263038qtw.7
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 17:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=aLMlOWEZttp+WzQHkudkX6mdG2AM7wgPUhrApJPjk7c=;
        b=MQNx28BQ0KGA9ZFHN5O9mEIrlXkZw6u5GB8aVkvdAfBoezRb7G00sOAzUvFfnl0AGU
         3U0xryA9xi+u1COvzxPRLHq+aQ3XroNyAwa3ZkfZI2pJ5iGTbO0o6VvqWJGqQjqtnj/h
         RgJzvIkY99FUGW18LxpV6RInOW+XLYWcwRgKShk6A3DuJfhNIAImA78K4z8xVChILnHS
         l8R99CmR/yejjFyn1WyIqg4L/EyEUBqaDnmjNEvz5AY615N1iRz9qwVt8WYULKKmIW4g
         En30wfpx1aM+ZzIEdQ7bHfbXpgpawSf1x+nCEjh5p4MllbJVfZeRLkdg5EeUkJRaOxA8
         F3ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=aLMlOWEZttp+WzQHkudkX6mdG2AM7wgPUhrApJPjk7c=;
        b=F0rglUG8ReAUamn6LIoZq+wTNP2hrXNyTeyKGTm1lmWg8qn77B2g34fFgI2o0MlAXR
         8+k8tMmz9M5I8tuyRvmSPqzeoeB2kVmbYnUY9Fe3+lLmtSgrswGwVfeOExSaveV7kI2r
         2VPnaJl8wbY3Tl7biCEIjcDyXsBk3XFmUHAjxICr8naRyXrlNYhGK7rZ7KqZ0cJthU98
         8vLd91UPunsHAw8dOrtBh5h6TyNGoEDzmn2oa6RwFSM/kmSXWBncHSyHQfvVH/edacJf
         We7q26zZMXh6s6wMrm3vEzTSnVkXC1ajfHKRzBwae4JqZwKa3qBtQzb4oniDFLCIggP7
         Vgsw==
X-Gm-Message-State: AOAM530vAQqrozRIGS3SI/HthyR9QS/wG/r5PfimzcldpZcmEC8WvuDy
        XBPpZtUTrMKJjiSwDFQATOZeazgq1SA=
X-Google-Smtp-Source: ABdhPJwcpw78iVfnFmNDXyD/mD0kLqfEQl4B4rcpnMaO6YIKKkhIT+/hDSqgKvEINd/iCAZrgdEV6P+jAsM=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:fc04:f9df:1efb:bf0c])
 (user=seanjc job=sendgmr) by 2002:a0c:c248:: with SMTP id w8mr11883236qvh.58.1614995966156;
 Fri, 05 Mar 2021 17:59:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 17:58:55 -0800
In-Reply-To: <20210306015905.186698-1-seanjc@google.com>
Message-Id: <20210306015905.186698-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210306015905.186698-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 04/14] KVM: x86: Do not advertise SME, VM_PAGE_FLUSH, or
 unknown features
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a reverse-CPUID entry for the memory encryption word, 0x8000001F.EAX,
and use it to override the supported CPUID flags reported to userspace.
Masking the reported CPUID flags avoids over-reporting KVM support, e.g.
without the mask a SEV-SNP capable CPU may incorrectly advertise SNP
support to userspace.

Explicitly omit SME and VM_PAGE_FLUSH, which are used by KVM, but not
exposed to the guest, e.g. guest access to related MSRs will fault.
Continue advertising SEV and SEV-ES, which guests of the associated type
may expect to see present, as well as SME_COHERENT, which lets the guest
know it can skip CLFLUSH operations.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 6 ++++++
 arch/x86/kvm/cpuid.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6bd2f8b830e4..45745c6c2161 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -514,6 +514,10 @@ void kvm_set_cpu_caps(void)
 	 */
 	kvm_cpu_cap_mask(CPUID_8000_000A_EDX, 0);
 
+	kvm_cpu_cap_mask(CPUID_8000_001F_EAX,
+		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
+		F(SME_COHERENT));
+
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
@@ -871,6 +875,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	case 0x8000001F:
 		if (!boot_cpu_has(X86_FEATURE_SEV))
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		else
+			cpuid_entry_override(entry, CPUID_8000_001F_EAX);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 2a0c5064497f..b3042ac6b5dc 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -80,6 +80,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
+	[CPUID_8000_001F_EAX] = {0x8000001f, 1, CPUID_EAX},
 };
 
 /*
-- 
2.30.1.766.gb4fecdf3b7-goog

