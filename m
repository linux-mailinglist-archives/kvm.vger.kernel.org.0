Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3316A2F5676
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbhANBsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbhANAjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:39:51 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6026C0617B0
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:47 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id t18so2950849qva.6
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=6IjwYJ9nQQQ0VcUn254Dijwa+O3I16q70UCT60xMF6g=;
        b=CO4UFIoLHaCRpVB2MjOZf8UkbKvNnAkg+a0HFbJqY/bV7n5GCIPVyL3/wiX4o6EsFB
         UqlIyhryQEk16FL3egk36ZjVrvK02kg5Cg3+7NhDC6WdUUVNY2NtXQ7ZvK0hkrcwmImh
         pb7tGFWUarWoyf6QgqhP/vpYkLm+a+/dkiJz6B1eDLdUPrFIkQEJw/+XtZboQcA3Me3v
         ufXrBMtYm5C80Yk5OEaOSiVwx9UBzW6d+4MaQXQemOSVUWrbzPR31G3gFw8AIG96PPQ7
         WfqUar0PVfuJUjUZ8bjP2BJvema0KPNvYaFWLi4EGlhy6Gdvl1vgYtkvFbQuBPbcWRGP
         oLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=6IjwYJ9nQQQ0VcUn254Dijwa+O3I16q70UCT60xMF6g=;
        b=FYitcNxkowo+iMt+rGx+gdnduIlc/xRxdZ3WbUZyKrLxOOkji2BIgrF1p9gYhb1ovY
         ezrJbvPtP8Li/7Zi0qzFZM2Cokyzs1qC1UH8m24u+XoKf9tUPliLOHgsUtEmrPfu4mOB
         irGr1xQ8gcHBFM61pSDZvjoiVEqUK3YhnUVD40UBLlMTrunGDl/vH7RWzhsNNm7Sc1tP
         2W5iXJAI3KtOSYa24A+nhPhLb1L9Mjc7uNRto+nmiHgWOs3/kbvxVvkjH2kBCdC6Me6c
         9OlyqICMLmyr0d0dS+wMjcX9p8WzeRuzKHXi2kiwF6unFHeJsETXM0P7gxK2pXh6jMgS
         AvfA==
X-Gm-Message-State: AOAM532XTUXcMrchP7r7pIKxjDZdQr6WrFzf2bzuVXpkS6arcxUg97s4
        l90XJqTM9LTfm6eJsUQH3QyDXa0LIGQ=
X-Google-Smtp-Source: ABdhPJzmJiGQ2Jk2secJV5cIicU0Y2tSxcoH20LMR4/CzPqNn4te3nKLeCzKG255Qo5g47HTjNbiMwC2yDU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a0c:bd9f:: with SMTP id n31mr4853531qvg.42.1610584667050;
 Wed, 13 Jan 2021 16:37:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Jan 2021 16:36:59 -0800
In-Reply-To: <20210114003708.3798992-1-seanjc@google.com>
Message-Id: <20210114003708.3798992-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210114003708.3798992-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 05/14] KVM: x86: Override reported SME/SEV feature flags
 with host mask
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

Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
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
2.30.0.284.gd98b1dd5eaa7-goog

