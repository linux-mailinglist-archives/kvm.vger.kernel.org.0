Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB6A4559E3
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343650AbhKRLRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343866AbhKRLOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:14:49 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D7AC061A09;
        Thu, 18 Nov 2021 03:09:33 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id h63so4991332pgc.12;
        Thu, 18 Nov 2021 03:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t9lt885omYyDf9Kd0EGpZtn1YqCcccm2P44/Ln1qvGg=;
        b=iW3CIwzwxDatI0opTJwJRL70urQsh/wQQIwUiXFYIXUUu5i92gE3V0Z4Wecunjv/8U
         TSJ7fRKUN31k2cQESGh8lOABknBNeDp7NicF7HsWrUKmUTqUCgXMw6mVOriUhEU3HTP8
         lJIPyGeGjiJHPX9eoRlYj66g9kAnNgruPtbKgR9GZjQlvcZ2wrb+wCT4i7HcXE0j9wAu
         UYS7PF76qTLSPhWAhGGaobD5dxyrTRB2D9Uk1sNqRjMFMPPCzxN5Dk3JBbSApzQoZg9N
         cNnlXpQsaOb5k8cV+LKjaJ6TVaWGN7XJh2JMeJVZtc8rf48TwzV71rOXxUP2MF+V+aqm
         RsfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t9lt885omYyDf9Kd0EGpZtn1YqCcccm2P44/Ln1qvGg=;
        b=7vHjCIqfc3wuQs02/AOuvQ5ou4gy3AUa7LZJgzD2qsO9PVsFuvakZ0E+oNHcJT+rFy
         wRH2Z0NkAU4VmhqPHvdu/0P8Ku7hg/5E08HJTwso9E2ugHBoVfVSs9krAlm97+aDRr9U
         j5hLTo1HNlnvDov6S8ZZdzx/COKfRbiWYQoVIAA2sfrBhyoFQLJpB8mcDx9O1WeBVbOf
         kuwMSqu9ZQcIWFVbDSmK6yecInrH30o77/P0Qji1FcPXYA76OT//QY7phbvgMKCgmSdL
         VUH2TRm4aJObPPaZzvN8lpZWzX6JCkpzB4HzJKjJjKBxr+2MT9X1Bwir8M7HRoImqn1N
         6Dig==
X-Gm-Message-State: AOAM530ccySGvfd/3TSY1ORZxhAB1IsRNM6mTCtnBCoO3YGBPspSfpC/
        NUWkjEfhwHWApEq0lAPp7eCQ4bfD3cM=
X-Google-Smtp-Source: ABdhPJysfV6ZF1b48jNjfeA5unjw7i0pMoensupDBHqUH5EXrEv9f4ZuMreR0OZDjV5qmRXjQ8hN5Q==
X-Received: by 2002:a63:788d:: with SMTP id t135mr10393119pgc.2.1637233772985;
        Thu, 18 Nov 2021 03:09:32 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id c2sm3238776pfv.112.2021.11.18.03.09.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:09:32 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Subject: [PATCH 15/15] KVM: X86: Always set gpte_is_8_bytes when direct map
Date:   Thu, 18 Nov 2021 19:08:14 +0800
Message-Id: <20211118110814.2568-16-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

When direct map, gpte_is_8_bytes has no meaning, but it is true for all
other cases except direct map when nonpaping.

Setting gpte_is_8_bytes to true when nonpaping can ensure that
!gpte_is_8_bytes means 32-bit gptes for shadow paging.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 Documentation/virt/kvm/mmu.rst | 2 +-
 arch/x86/kvm/mmu/mmu.c         | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
index f60f5488e121..5d1086602759 100644
--- a/Documentation/virt/kvm/mmu.rst
+++ b/Documentation/virt/kvm/mmu.rst
@@ -179,7 +179,7 @@ Shadow pages contain the following information:
     unpinned it will be destroyed.
   role.gpte_is_8_bytes:
     Reflects the size of the guest PTE for which the page is valid, i.e. '1'
-    if 64-bit gptes are in use, '0' if 32-bit gptes are in use.
+    if direct map or 64-bit gptes are in use, '0' if 32-bit gptes are in use.
   role.efer_nx:
     Contains the value of efer.nx for which the page is valid.
   role.cr0_wp:
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6948f2d696c3..0c92cbc07320 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2083,7 +2083,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	role.level = level;
 	role.direct = direct;
 	role.access = access;
-	if (!direct_mmu && !role.gpte_is_8_bytes) {
+	if (!role.gpte_is_8_bytes) {
 		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
@@ -4777,7 +4777,7 @@ kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
 
 	role.base.smep_andnot_wp = role.ext.cr4_smep && !____is_cr0_wp(regs);
 	role.base.smap_andnot_wp = role.ext.cr4_smap && !____is_cr0_wp(regs);
-	role.base.gpte_is_8_bytes = ____is_cr0_pg(regs) && ____is_cr4_pae(regs);
+	role.base.gpte_is_8_bytes = !____is_cr0_pg(regs) || ____is_cr4_pae(regs);
 
 	return role;
 }
-- 
2.19.1.6.gb485710b

