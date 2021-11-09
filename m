Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D0C44A41D
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 02:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241510AbhKIBnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 20:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238941AbhKIBnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 20:43:11 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E516CC07926C
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 17:30:55 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id t75-20020a63784e000000b002993a9284b0so11148230pgc.11
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 17:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Cek4ungJsGyjoKuyz53izX26dC8LXwab+OTQ+vEEjQA=;
        b=kDnW+htoA3Jr+pOfiv6PMG59PPWkSEcMBpTjhdW/gWwOVTHyvWeJ6ZxkdzUEnQ2e13
         csdKjf4khL85fsMP8GtozP2YO2v53HdkkagcZxfLJIXeHS2tVYH+1pGDUijDbGQVbuXn
         cebZgn907/SQJuQgyDea8xgHro4I6XyS2tBFnO7FDAlgwksCTX2aunHzPTv2VjHbuNY1
         6faXkAXWgvia9hDDdQXY8SUX7pYZzsdBE9vdohVavQTagoRDqV6Ltx48J8qeDJ6SCKQO
         w1ttch14IYyU+giWBQkPseDXOKx5wAGpTg0KQf/liF2jDnY/nka35JxaEDxpl9sWffD2
         3JwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Cek4ungJsGyjoKuyz53izX26dC8LXwab+OTQ+vEEjQA=;
        b=7gAEJcds9umyDwb0sfRDTCDlr3J02lAZ5fsvC1txxpgmKA8rxRbaOQbnFiRb2xO09Y
         Es55nSUWIy1ImyexR2UBsP3JQ3Iy0hOBHNFOmuER5IwsmRvz/9xvuIDGxPXtlBLDyGd5
         wJXAvGt+Kri8T3Wd4NSc1iJAoVl9kZKuVYs/ghChMUyrA2j/lrnO1HSXSL6qiOr5yX7H
         duWRp7LIqvemkKpSyUzHi6F4jht/9Z28Mh2oTwbwiLwdcr4kwz8vNE13aNYcXgUcKYQs
         5z1mgSm3UY4sWQc04RiktmaSSlhEjHD/ar/wE5c+IX3q+F9ycAQ7tAeszBHNKDowCXaE
         ghow==
X-Gm-Message-State: AOAM531Ym/2cXspteveouR65ms5Mh0U+5JQXCWu1Pv8BJd8SLx+rv4pP
        UFPG7DYNp2oAV5xK5zWAivpDxHyyjEc=
X-Google-Smtp-Source: ABdhPJzS59VvxMe/VQxdUCepyufz8RGy7ZdZPt3tuG6Z6rhQZOhNRURdYoCEVjuxE01aOvaPjQ2mlcuUfA8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:6905:b0:142:9e19:702e with SMTP id
 j5-20020a170902690500b001429e19702emr3815769plk.34.1636421455434; Mon, 08 Nov
 2021 17:30:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Nov 2021 01:30:46 +0000
In-Reply-To: <20211109013047.2041518-1-seanjc@google.com>
Message-Id: <20211109013047.2041518-4-seanjc@google.com>
Mime-Version: 1.0
References: <20211109013047.2041518-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 3/4] KVM: VMX: Macrofy the MSR bitmap getters and setters
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>
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
index d51311fa9ffc..83a14b61c80f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -400,68 +400,25 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 
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
2.34.0.rc0.344.g81b53c2807-goog

