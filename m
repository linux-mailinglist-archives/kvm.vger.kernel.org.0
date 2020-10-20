Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A5F28389B
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 16:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgJEO7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 10:59:30 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:59701 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726567AbgJEO7a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 10:59:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UB3KJNM_1601909961;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UB3KJNM_1601909961)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 05 Oct 2020 22:59:22 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] KVM: x86: filter guest NX capability for cpuid2
Date:   Mon,  5 Oct 2020 22:59:21 +0800
Message-Id: <20201005145921.84848-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Original KVM_SET_CPUID has removed NX on non-NX hosts as it did
before. but KVM_SET_CPUID2 does not. The two should be consistent.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/x86/kvm/cpuid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3fd6eec202d7..3e7ba2b11acb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -257,6 +257,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 		goto out;
 	}
 
+	cpuid_fix_nx_cap(vcpu);
 	kvm_update_cpuid_runtime(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 out:
-- 
2.24.3 (Apple Git-128)

