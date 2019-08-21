Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458A6974F4
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 10:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfHUI0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 04:26:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39166 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfHUI0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 04:26:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id i63so1195955wmg.4;
        Wed, 21 Aug 2019 01:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nwX/48Ia7d2dRgMHoMgDxjTtTXX3pmd4YgGY1f3Mcbg=;
        b=ZULk9xeIJuv1XoFXog3/KZs2+L80kTNWp4MkFqWfibqPuHiMoIYJ1EHN5CXMu87HKk
         TXsZ3YK9TdmFxEhnPy2G2nhjyaglkv+pyMaDM0djtXs7FNeHSjHxXdkscuKKwhCz6bHo
         Ysw7c0sulOGiQWZwa3lZ8eWk2FLi9/DHJ7oshYYNrA707T5EUQyRTme2ErNeYs7hkvrr
         hO44+hOKaXEd6U4opIUnBjIyFRS2nU5l+WdZDPKJaB7khl3fut4+9uavVOw/H5kWfLv+
         dqfcHBBfM0E+84nNhPh8OC5yBQjNW8iry7YMaHHiYL5ldaLSoQj/p5FkyOW2XL3IBsdD
         h4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=nwX/48Ia7d2dRgMHoMgDxjTtTXX3pmd4YgGY1f3Mcbg=;
        b=PygTowU/BVJGwiye0FWZ1z7AMm1VXyLjqf4IPK4cI+VzkzwHhZMosMjQS6ad7yEkde
         5eK5FIGN8UZsDsm50Gn76M8E4BQ3MFQHQvNcXDRUt3+6IXGX+XIuQibZvilKWkm8SJbO
         5/CcApTY4YsV8GREdDKe6HDL409kqpoyodYosnnpDBzuh+0lg9CtZ+ZiWa5pvNIadXGZ
         Fw9zJULfpT1May8HeFGO1cntyRbVJ9J8Wes8EFr77NJQkKlfAGijsW41fYgY8OsovSvK
         Cpq91E05pFG1/9rX0qHk1iuJWBrOFtAmiyPbIf2kuBFevIlzhLi4hEg9nqd3oWFEuKXc
         hNng==
X-Gm-Message-State: APjAAAXHAAO+6Y1XrlmOVH/QJEGsOUgByd/0BnC/yYESo4uw/cv3QhFg
        jka3VFlQRV4xMR9NWRk54LuWxf4udHI=
X-Google-Smtp-Source: APXvYqynhnmicUQQOOG75MVstq+5H1fNWaUgK9qQiE62egUfeFJKxzkXHxu7i6FLV/9QLM/pzsl6Sw==
X-Received: by 2002:a7b:c5c2:: with SMTP id n2mr4835665wmk.9.1566376005834;
        Wed, 21 Aug 2019 01:26:45 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w5sm2931892wmm.43.2019.08.21.01.26.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 01:26:45 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@redhat.com, ehabkost@redhat.com, konrad.wilk@oracle.com
Subject: [PATCH 1/3] KVM: x86: fix reporting of AMD speculation bug CPUID leaf
Date:   Wed, 21 Aug 2019 10:26:40 +0200
Message-Id: <1566376002-17121-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566376002-17121-1-git-send-email-pbonzini@redhat.com>
References: <1566376002-17121-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AMD_* bits have to be set from the vendor-independent
feature and bug flags, because KVM_GET_SUPPORTED_CPUID does not care
about the vendor and they should be set on Intel processors as well.
On top of this, SSBD, STIBP and AMD_SSB_NO bit were not set, and
VIRT_SSBD does not have to be added manually because it is a
cpufeature that comes directly from the host's CPUID bit.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 22c2720cd948..43caeb6059b9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -729,18 +729,23 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			g_phys_as = phys_as;
 		entry->eax = g_phys_as | (virt_as << 8);
 		entry->edx = 0;
+		entry->ebx &= kvm_cpuid_8000_0008_ebx_x86_features;
+		cpuid_mask(&entry->ebx, CPUID_8000_0008_EBX);
 		/*
-		 * IBRS, IBPB and VIRT_SSBD aren't necessarily present in
-		 * hardware cpuid
+		 * AMD has separate bits for each SPEC_CTRL bit.
+		 * arch/x86/kernel/cpu/bugs.c is kind enough to
+		 * record that in cpufeatures so use them.
 		 */
-		if (boot_cpu_has(X86_FEATURE_AMD_IBPB))
+		if (boot_cpu_has(X86_FEATURE_IBPB))
 			entry->ebx |= F(AMD_IBPB);
-		if (boot_cpu_has(X86_FEATURE_AMD_IBRS))
+		if (boot_cpu_has(X86_FEATURE_IBRS))
 			entry->ebx |= F(AMD_IBRS);
-		if (boot_cpu_has(X86_FEATURE_VIRT_SSBD))
-			entry->ebx |= F(VIRT_SSBD);
-		entry->ebx &= kvm_cpuid_8000_0008_ebx_x86_features;
-		cpuid_mask(&entry->ebx, CPUID_8000_0008_EBX);
+		if (boot_cpu_has(X86_FEATURE_STIBP))
+			entry->ebx |= F(AMD_STIBP);
+		if (boot_cpu_has(X86_FEATURE_SSBD))
+			entry->ebx |= F(AMD_SSBD);
+		if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
+			entry->ebx |= F(AMD_SSB_NO);
 		/*
 		 * The preference is to use SPEC CTRL MSR instead of the
 		 * VIRT_SPEC MSR.
-- 
1.8.3.1


