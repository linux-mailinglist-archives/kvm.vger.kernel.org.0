Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E179544B12C
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 17:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240015AbhKIQbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 11:31:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240006AbhKIQbl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Nov 2021 11:31:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636475334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vpwXm4scS3HvFAD7QzJwJsKTDOpf7pWzPg3GOUbGsxI=;
        b=hkYjqPxR1MXb5cQLT4TGwlxF+j5aHRTTsAiajhLCgBo4CH2lI0VpMwTpO//NsoUo2QJRoX
        1c2r0/0j/4Amb/y0oi49wQDwzov+r5KyohOngHDvRcFUO+Wy1URds+F2lvHl/J7ZxEjIEE
        xxQuqL5Y3m5JnWgi82Eg7ooYiONFMDQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-9bvWwb-VNwC7XRM-QD3sKQ-1; Tue, 09 Nov 2021 11:28:51 -0500
X-MC-Unique: 9bvWwb-VNwC7XRM-QD3sKQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CD101019983;
        Tue,  9 Nov 2021 16:28:50 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37A6664188;
        Tue,  9 Nov 2021 16:28:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/8] KVM: VMX: Macrofy the MSR bitmap getters and setters
Date:   Tue,  9 Nov 2021 17:28:30 +0100
Message-Id: <20211109162835.99475-4-vkuznets@redhat.com>
In-Reply-To: <20211109162835.99475-1-vkuznets@redhat.com>
References: <20211109162835.99475-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Add builder macros to generate the MSR bitmap helpers to reduce the
amount of copy-paste code, especially with respect to all the magic
numbers needed to calc the correct bit location.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
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
2.31.1

