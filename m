Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6A3341079
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 23:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbhCRWnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 18:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhCRWnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 18:43:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1572C06174A
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 15:43:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v92so7473210ybi.12
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 15:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=77EhQ2wiyvQkkpWDHBwQ63WL6CQbHYQ2QwkWHK42ktA=;
        b=RZBH/8GoGf+A4KEAwsf+dNlbb1dfmW/E2QuidwQetRa+cKkeRrI0PA8w0fKz1EkXH9
         PjYQYRg09bN6i0xBJreH8Vctq50Z6acolUMaCR7Fz8Q6qfsmlTEMHZMbIMvUzv3as4Ev
         J/Y5wJ/gwL+o0vHUcAMsx+vUqcJjDR2Kd0iWh7lW9w4Rj100eESoyeoJgr0DWkj6M1NM
         Ejol8YBS+6+Fo3g2RH4TDK5nlmvAuxAMd5IYs+mYWx58l9bfdnoYdZH0ivgz2DeaQUkA
         91V/l/6WtjOJzz/DbDmCSksaH4BmjwCoU2n3A3G1qb734C0lcIwvP/JDnJIXK1e3T3KV
         UUOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=77EhQ2wiyvQkkpWDHBwQ63WL6CQbHYQ2QwkWHK42ktA=;
        b=RFTAPQg5BYx1mXnEcSAR1AYRQQfdlkp4a7uO+ita46iLDRn8Pm2o90cu39M47j4lsG
         N/EAR/I1PK4ZDYSNbVVzpy2poDVUFhP0g2+g0ufUdiGHMhOCoikJMwA551dcws9ar+Mj
         z0sxFRjYxP2oPP2yeuDXjX7kC9iGbZ8iC36gLTgKS1DcifwUCuYWv0jP2kPnjSL/ylMB
         CfdbF0HRbexFMCJI4n++BI7uoUjLY8gNVJ2JmXEDYTXWlI+BqQs6JqMvBBOK6cE7mTBP
         FF6gc6R0wWAifJrNUDiB0OAmJ3wcTx8mYMvBQ3xJVmED7Tp050OCXJYQHhm7coPolSxG
         bDrQ==
X-Gm-Message-State: AOAM530BCPHZanBjy9KpMd99wl2oOLR03FGsUvRy20RQY3uEOBeY4YCl
        Ggcr26gKVIP3LrJA4Uoy5fWYwpiG0j8=
X-Google-Smtp-Source: ABdhPJyGtDXgmDstodtsMHSUiv5Y0nqQOLIAWyCHcntjCIFseI1djytwUNrY6a/FPhyouwaXxErLbXFs6e4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:25e0:6b8b:f878:23d1])
 (user=seanjc job=sendgmr) by 2002:a25:7449:: with SMTP id p70mr2263002ybc.167.1616107400146;
 Thu, 18 Mar 2021 15:43:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 18 Mar 2021 15:43:09 -0700
In-Reply-To: <20210318224310.3274160-1-seanjc@google.com>
Message-Id: <20210318224310.3274160-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210318224310.3274160-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v2 3/4] KVM: VMX: Macrofy the MSR bitmap getters and setters
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Yuan Yao <yaoyuan0329os@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add builder macros to generate the MSR bitmap helpers to reduce the
amount of copy-paste code, especially with respect to all the magic
numbers needed to calc the correct bit location.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.h | 77 ++++++++++--------------------------------
 1 file changed, 17 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a6000c91b897..42c25fc79427 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -393,68 +393,25 @@ void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
 	u32 msr, int type, bool value);
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 
-static inline bool vmx_test_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
-{
-	int f = sizeof(unsigned long);
-
-	if (msr <= 0x1fff)
-		return test_bit(msr, msr_bitmap + 0x000 / f);
-	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
-		return test_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
-	return true;
-}
-
-static inline bool vmx_test_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
-{
-	int f = sizeof(unsigned long);
-
-	if (msr <= 0x1fff)
-		return test_bit(msr, msr_bitmap + 0x800 / f);
-	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
-		return test_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
-	return true;
-}
-
-static inline void vmx_clear_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
-{
-	int f = sizeof(unsigned long);
-
-	if (msr <= 0x1fff)
-		__clear_bit(msr, msr_bitmap + 0x000 / f);
-	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
-		__clear_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
-}
-
-static inline void vmx_clear_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
-{
-	int f = sizeof(unsigned long);
-
-	if (msr <= 0x1fff)
-		__clear_bit(msr, msr_bitmap + 0x800 / f);
-	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
-		__clear_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
-}
-
-static inline void vmx_set_msr_bitmap_read(ulong *msr_bitmap, u32 msr)
-{
-	int f = sizeof(unsigned long);
-
-	if (msr <= 0x1fff)
-		__set_bit(msr, msr_bitmap + 0x000 / f);
-	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
-		__set_bit(msr & 0x1fff, msr_bitmap + 0x400 / f);
-}
-
-static inline void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
-{
-	int f = sizeof(unsigned long);
-
-	if (msr <= 0x1fff)
-		__set_bit(msr, msr_bitmap + 0x800 / f);
-	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))
-		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
+#define __BUILD_VMX_MSR_BITMAP_HELPER(rtype, action, bitop, access, base)      \
+static inline rtype vmx_##action##_msr_bitmap_##access(unsigned long *bitmap,  \
+						       u32 msr)		       \
+{									       \
+	int f = sizeof(unsigned long);					       \
+									       \
+	if (msr <= 0x1fff)						       \
+		return bitop##_bit(msr, bitmap + base / f);		       \
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))		       \
+		return bitop##_bit(msr & 0x1fff, bitmap + (base + 0x400) / f); \
+	return (rtype)true;						       \
 }
+#define BUILD_VMX_MSR_BITMAP_HELPERS(ret_type, action, bitop)		       \
+	__BUILD_VMX_MSR_BITMAP_HELPER(ret_type, action, bitop, read,  0x0)     \
+	__BUILD_VMX_MSR_BITMAP_HELPER(ret_type, action, bitop, write, 0x800)
 
+BUILD_VMX_MSR_BITMAP_HELPERS(bool, test, test)
+BUILD_VMX_MSR_BITMAP_HELPERS(void, clear, __clear)
+BUILD_VMX_MSR_BITMAP_HELPERS(void, set, __set)
 
 static inline u8 vmx_get_rvi(void)
 {
-- 
2.31.0.rc2.261.g7f71774620-goog

