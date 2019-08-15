Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3BD88E5A3
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 09:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbfHOHlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 03:41:31 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41231 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730032AbfHOHl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 03:41:29 -0400
Received: by mail-wr1-f67.google.com with SMTP id j16so1400879wrr.8;
        Thu, 15 Aug 2019 00:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id:in-reply-to:references;
        bh=pGynoWXlblqaqhz24Pk3XP4YutRookXWoKTRmTgMTU0=;
        b=lYl7aOHvbW24HvUYbBd68dHX64HOVceBreTgXWfVHKAWyAVT6M5IfzBPmBIqD5P1/i
         n15vS8cyX8YNjpCJB6qKE2miZSDNWMFHrlIrO2ePtppfrf/2jf+BYug5Cu4IEGpbmvLp
         8vSHuMjOOQbGXRmW7zIslvsjtrMoqrwiCE+LWWQX5WHoGTaHJqzl1Ts7Rn9bj2BoxTYN
         BJ2//Um+P8ivm3tnKFRAn8akOgOxrj0wG/fEJIUEem3lkfreGvmRWjfR9jQg1vDvVN01
         WSWjQACnZPmdTDfq8WfD1R+znnVnjXtClwXGaQddJ7fXCNMv9aXxc/Ye5HRq+fJUBhmo
         Y9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :in-reply-to:references;
        bh=pGynoWXlblqaqhz24Pk3XP4YutRookXWoKTRmTgMTU0=;
        b=JfGKAHgR81BQso+tmHNlKH9ECZ/cGZOAummZZXJQqqsv3IhbFtC46nhmIVAJwIFwlz
         LyBfvAHAZnpa1Ho/3iKVPRbs28154igG9u18bukZQv2zl2DZ/j72tdEu1jh1U6wu/C5j
         f/+9RKWkd5ip7HY6tJYcgtwrZIn5F86B1aIqmSuPHsJ+GJfu4HKqC6nFJFVlovSFQGnx
         DhdYfufvAUKebShxih8RLdVX9DxtG77rlRc6apDaUOcNog9Db1tAzfM+Z4AEvz9a2g1d
         10Gwlh6fCBmLcSBiJ/hPQz8tEO4lYfIosRPWH2+8Haz1g63Nk0H3CHXrosOIgEWjNXDt
         UHPg==
X-Gm-Message-State: APjAAAVvzfmPN6PcG12Th0Rf9EBo/vVX4ivuCDZFxHtUvukmG1SPDPO4
        rrY4Y56TKEeJKER7xrtUuMG89zfB
X-Google-Smtp-Source: APXvYqwarX6AHAn2Hb0yLlDjDELHGytPYL7SXIJATgv7gavkZkLdilYVBsv8aWc/pWIfQy9TRsyriw==
X-Received: by 2002:a5d:634c:: with SMTP id b12mr3765541wrw.127.1565854887266;
        Thu, 15 Aug 2019 00:41:27 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id m23sm809796wml.41.2019.08.15.00.41.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 00:41:26 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: fix reporting of AMD speculation bug CPUID leaf
Date:   Thu, 15 Aug 2019 09:41:22 +0200
Message-Id: <1565854883-27019-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565854883-27019-1-git-send-email-pbonzini@redhat.com>
References: <1565854883-27019-1-git-send-email-pbonzini@redhat.com>
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
 arch/x86/kvm/cpuid.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 22c2720cd948..145ec050d45d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -730,15 +730,20 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->eax = g_phys_as | (virt_as << 8);
 		entry->edx = 0;
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
+		if (boot_cpu_has(X86_FEATURE_STIBP))
+			entry->ebx |= F(AMD_STIBP);
+		if (boot_cpu_has(X86_FEATURE_SSBD))
+			entry->ebx |= F(AMD_SSBD);
+		if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
+			entry->ebx |= F(AMD_SSB_NO);
 		entry->ebx &= kvm_cpuid_8000_0008_ebx_x86_features;
 		cpuid_mask(&entry->ebx, CPUID_8000_0008_EBX);
 		/*
-- 
1.8.3.1


