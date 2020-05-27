Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34CB1E3CB6
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 10:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388192AbgE0IyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 04:54:02 -0400
Received: from mga17.intel.com ([192.55.52.151]:18477 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388019AbgE0IyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 04:54:02 -0400
IronPort-SDR: NzUkZnxz/Kv4fBGO/iVWpVBiC27CNeS8BjFK3dXnmjVLc0VXMqVkw7qv228EKzHaCx6078gWKn
 U57p+20liE3w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 01:54:01 -0700
IronPort-SDR: X4MCtpRkLljsgR7+EkaTcY9qggKkR+7funFrhV7OCKkBeiyURWXENxtDHbdrLfTArkU5NtAPnL
 /hvq1Txw7Frg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,440,1583222400"; 
   d="scan'208";a="284736246"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 27 May 2020 01:54:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+904752567107eefb728c@syzkaller.appspotmail.com
Subject: [PATCH] KVM: x86: Initialize tdp_level during vCPU creation
Date:   Wed, 27 May 2020 01:54:00 -0700
Message-Id: <20200527085400.23759-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Initialize vcpu->arch.tdp_level during vCPU creation to avoid consuming
garbage if userspace calls KVM_RUN without first calling KVM_SET_CPUID.

Fixes: e93fd3b3e89e9 ("KVM: x86/mmu: Capture TDP level when updating CPUID")
Reported-by: syzbot+904752567107eefb728c@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b226fb8abe41b..01a6304056197 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9414,6 +9414,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	fx_init(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
+	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
 
 	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
 
-- 
2.26.0

