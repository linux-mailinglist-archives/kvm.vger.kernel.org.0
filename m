Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F9B30A9C4
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 15:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhBAOaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 09:30:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229566AbhBAOaR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 09:30:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612189730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+vZ66VqPrxvnrqTCUTK/999/9ewUHwH+ZXDKtfFOdSk=;
        b=aKLGXUxGWcu2dw9R6MIMFlsCWqpG5wwiioWfO+DSCENdmsbFiADGsB4lNyNDg45tG7wavL
        gmeE49VvLzW2qIZSj8o45P7kmvBWvk0/1njOGtOyVQ9kfTxSlK1zk4xMrVOepCp5JvW0bF
        l5zpl0FaTsoip/c1xqxQYYPIzINNr70=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-ZLKHlcPBMhKSpKoJddYSzQ-1; Mon, 01 Feb 2021 09:28:49 -0500
X-MC-Unique: ZLKHlcPBMhKSpKoJddYSzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C57B1801AC4;
        Mon,  1 Feb 2021 14:28:47 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A38D8100239A;
        Mon,  1 Feb 2021 14:28:44 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH] KVM: x86: Supplement __cr4_reserved_bits() with X86_FEATURE_PCID check
Date:   Mon,  1 Feb 2021 15:28:43 +0100
Message-Id: <20210201142843.108190-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 7a873e455567 ("KVM: selftests: Verify supported CR4 bits can be set
before KVM_SET_CPUID2") reveals that KVM allows to set X86_CR4_PCIDE even
when PCID support is missing:

==== Test Assertion Failure ====
  x86_64/set_sregs_test.c:41: rc
  pid=6956 tid=6956 - Invalid argument
     1	0x000000000040177d: test_cr4_feature_bit at set_sregs_test.c:41
     2	0x00000000004014fc: main at set_sregs_test.c:119
     3	0x00007f2d9346d041: ?? ??:0
     4	0x000000000040164d: _start at ??:?
  KVM allowed unsupported CR4 bit (0x20000)

Add X86_FEATURE_PCID feature check to __cr4_reserved_bits() to make
kvm_is_valid_cr4() fail.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c5ee0f5ce0f1..0f727b50bd3d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -425,6 +425,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_UMIP;        \
 	if (!__cpu_has(__c, X86_FEATURE_VMX))           \
 		__reserved_bits |= X86_CR4_VMXE;        \
+	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
+		__reserved_bits |= X86_CR4_PCIDE;       \
 	__reserved_bits;                                \
 })
 
-- 
2.29.2

