Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC4233DCC9
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 19:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240084AbhCPSpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 14:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240100AbhCPSo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 14:44:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D06C0613D7
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 11:44:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 131so43056581ybp.16
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 11:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uokSLKbb37fBaJRA5O/UQcn6HWuEqVi13AsKxTChtB0=;
        b=tebd2rrKFs9TgFy0l6OBB9NypB5/Oo3zIge8XITaQ18YhW1TbhhoouoQXJD0AvDvRE
         JlG7/nCcIdqC5+LOd9liA+x42seeNV1KyQyfssscCYmupMOTdvveP+sbemN5ZCPc3ulv
         8o49bOp1FbUzaZpzWfDELa/OwLEF4np2iRzL4DNLd4yNGbE1zg095419g/UlIQHWdFVB
         RPNL41hos4vi5Qb8Uwhc3mdwm0LllseH0tIAoIkoCea5TeDe8qsuigVaRjppkv7/XDEb
         xuV5oemqsbxlhUNCNtDGA+QwEr15NzFiEo/EFXHBYVnGks+hQvVz7AyCh3Fm7ijNYLw1
         FOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uokSLKbb37fBaJRA5O/UQcn6HWuEqVi13AsKxTChtB0=;
        b=DwH3FaRKGO1D25yJQPI/8nNomHjUKMxzjWxU6gusrWGeMMsY9M+2JiGgy/2KuOso7+
         JGx5dYg+lvn8JSV7TnSwSPKg0tXinH4oVdctUagvhxehsWvEK2fYWB7YjfV/DV1d8bHN
         z/PWrPfFYLbZ4Vnpm7KbHuyDdcfWHalgBUTmnXE2yLcXbjvEnC8xoX9i3g3TU8IfIkZ1
         s/8b7tSNsahXvzcFmGd9hwXtExJJi4v5mxQ6DWmu6PU8HBmZ4BbrJU38vdrSwJDn5Hlg
         /b2fZhpcZUC2mh8ZbBtfRNo0yvI7uJtNElvXQDxDsQ82ak/S7Rdfn5XwNKP2tuzake4D
         dbUg==
X-Gm-Message-State: AOAM531wMOZwaQE9flLYZCJUbkczhNNyEp2h+uduvlMmcwwwqaI7Lve8
        gwBI5g3c5PGKKAZ+LEGoG+g207m5eKE=
X-Google-Smtp-Source: ABdhPJzdhnwUrtWz1ELPuQCJOUYre9QoRYjCoDsOOfHlMrHwoCAfG9p3u4dgYXkMls0LbR06aonzlcNjH64=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e113:95c2:2d1:e304])
 (user=seanjc job=sendgmr) by 2002:a25:c503:: with SMTP id v3mr364721ybe.397.1615920292434;
 Tue, 16 Mar 2021 11:44:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 16 Mar 2021 11:44:35 -0700
In-Reply-To: <20210316184436.2544875-1-seanjc@google.com>
Message-Id: <20210316184436.2544875-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210316184436.2544875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH 3/4] KVM: VMX: Macrofy the MSR bitmap getters and setters
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
 arch/x86/kvm/vmx/vmx.h | 82 ++++++++++++------------------------------
 1 file changed, 22 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a6000c91b897..aab89e713c8e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -393,68 +393,30 @@ void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
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
+#define VMX_MSR_BITMAP_BASE_read	0x0
+#define VMX_MSR_BITMAP_BASE_write	0x800
+
+#define BUILD_VMX_MSR_BITMAP_HELPER(ret, action, type, pre...)		      \
+static inline ret vmx_##action##_msr_bitmap_##type(unsigned long *msr_bitmap, \
+						   u32 msr)		      \
+{									      \
+	int base = VMX_MSR_BITMAP_BASE_##type;				      \
+	int f = sizeof(unsigned long);					      \
+									      \
+	if (msr <= 0x1fff)						      \
+		return pre##action##_bit(msr, msr_bitmap + base / f);	      \
+	else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff))		      \
+		return pre##action##_bit(msr & 0x1fff,			      \
+					 msr_bitmap + (base + 0x400) / f);    \
+	return (ret)true;						      \
 }
 
+BUILD_VMX_MSR_BITMAP_HELPER(bool, test, read)
+BUILD_VMX_MSR_BITMAP_HELPER(bool, test, write)
+BUILD_VMX_MSR_BITMAP_HELPER(void, clear, read, __)
+BUILD_VMX_MSR_BITMAP_HELPER(void, clear, write, __)
+BUILD_VMX_MSR_BITMAP_HELPER(void, set, read, __)
+BUILD_VMX_MSR_BITMAP_HELPER(void, set, write, __)
 
 static inline u8 vmx_get_rvi(void)
 {
-- 
2.31.0.rc2.261.g7f71774620-goog

