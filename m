Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0429974F8
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 10:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfHUI0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 04:26:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51584 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbfHUI0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 04:26:50 -0400
Received: by mail-wm1-f67.google.com with SMTP id k1so1192946wmi.1;
        Wed, 21 Aug 2019 01:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u4jqzd2Sa7cqOfxmJTjO2EUX/kBXhO1wvG+CPlLawDo=;
        b=cYeQS8nqwJ2nxYaJvnK5iDKIc/f+MXApfpkaO7wT56NzwajB+RULs7NWeTMiIJLuy3
         FfSXxk66yXF9qOYAKazW8bMiCkzcL7gPrZOu5UFiIlomiHsuGvkaddQrOKgY4Ygpv2KN
         3C50QCTd664WoIJZ90u/4xdn0U0ti7rR1cD0TO3lj4YXiHnRbcsG3r2eMCCcVNDDd/ve
         C7OKQx3cBCUgDmvtJ7KZc4VdWlU9THd1DDITdKNVUWg64DcZ9YGJs1exHkTiiEZm9bQB
         dCu9U21FZRGx5z6hsJXbVdjTM9HjfIv4eAy8rRzJx7VNrxBfqwttbq+Ty8rYIDr4fF52
         v9Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=u4jqzd2Sa7cqOfxmJTjO2EUX/kBXhO1wvG+CPlLawDo=;
        b=AUwEJ2ntt9BC7jDrGLTO1aPtbKjp1vXNVABT826IeF8tGUi+pZsN4obsNDKFHbW83Z
         MUnOuW5+5tqdQoSKH0UsNJVG5kn1wB7uYJGLY6H7C6CbaghxEtJHnsQx+SqPSzGbTTjk
         mn12B03QUQUuYyGRJtu7aTRODqOiK6V7CLcK+HfNle8NsZLtk/JeT8esVRVmVxeMiKH+
         IbSWzGWCZEvY0grx3PJjpkSV0IlTbI6WVV0M064Y6/2b5E3Rw3v+nN+TfPrqaqxyd8au
         iQXvygwsX8VaNR4Zl1byyTYkt/THdVm/UzsvHPOMzP9oD9IJFAkPCk9jXisgONqtSRYL
         5vBQ==
X-Gm-Message-State: APjAAAV+v1rQD0g2duNU5FAe1pykBLBT27sDaACVp0a6Lf6JUW/wp6dW
        maiim/v6FMsjgGNOPwdEfIcH/hDrrlM=
X-Google-Smtp-Source: APXvYqyAE6UPHqryx0y2r5NIOdeFRnqkZSNLDgNCY7aIoVDEcZTIp4OMhLAwcnKfO0wfabKsIRa4Vg==
X-Received: by 2002:a7b:c952:: with SMTP id i18mr4882470wml.44.1566376007688;
        Wed, 21 Aug 2019 01:26:47 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w5sm2931892wmm.43.2019.08.21.01.26.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 01:26:47 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@redhat.com, ehabkost@redhat.com, konrad.wilk@oracle.com
Subject: [PATCH 3/3] KVM: x86: use Intel speculation bugs and features as derived in generic x86 code
Date:   Wed, 21 Aug 2019 10:26:42 +0200
Message-Id: <1566376002-17121-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566376002-17121-1-git-send-email-pbonzini@redhat.com>
References: <1566376002-17121-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to AMD bits, set the Intel bits from the vendor-independent
feature and bug flags, because KVM_GET_SUPPORTED_CPUID does not care
about the vendor and they should be set on AMD processors as well.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 6 ++++++
 arch/x86/kvm/x86.c   | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 43caeb6059b9..dd5985eb61b4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -392,6 +392,12 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 
 		entry->edx &= kvm_cpuid_7_0_edx_x86_features;
 		cpuid_mask(&entry->edx, CPUID_7_EDX);
+		if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
+			entry->edx |= F(SPEC_CTRL);
+		if (boot_cpu_has(X86_FEATURE_STIBP))
+			entry->edx |= F(INTEL_STIBP);
+		if (boot_cpu_has(X86_FEATURE_SSBD))
+			entry->edx |= F(SPEC_CTRL_SSBD);
 		/*
 		 * We emulate ARCH_CAPABILITIES in software even
 		 * if the host doesn't support it.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93b0bd45ac73..6b81c7609d09 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1254,6 +1254,13 @@ static u64 kvm_get_arch_capabilities(void)
 	if (l1tf_vmx_mitigation != VMENTER_L1D_FLUSH_NEVER)
 		data |= ARCH_CAP_SKIP_VMENTRY_L1DFLUSH;
 
+	if (!boot_cpu_has_bug(X86_BUG_CPU_MELTDOWN))
+		data |= ARCH_CAP_RDCL_NO;
+	if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
+		data |= ARCH_CAP_SSB_NO;
+	if (!boot_cpu_has_bug(X86_BUG_MDS))
+		data |= ARCH_CAP_MDS_NO;
+
 	return data;
 }
 
-- 
1.8.3.1

