Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B031C7E41
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 01:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgEFX6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 19:58:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:27430 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728445AbgEFX6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 19:58:51 -0400
IronPort-SDR: HVlQB4KZRhGhh/S/jDIjfcQ8SutAkTUrnqRx77sKqB08hfVzlqJQuc2ppkZpo70kY8OmBflG0p
 ncw3GHm9UfPQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 16:58:51 -0700
IronPort-SDR: 8nSc+RMIJMvcPTQETj0t5MsuXTF62MCTfopQuBcvBjCsA6OhOsrmofg5y184eAjOql0lUxE0kZ
 APhOHgWm+Owg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,361,1583222400"; 
   d="scan'208";a="435086067"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 06 May 2020 16:58:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: nVMX: Skip IPBP when switching between vmcs01 and vmcs02, redux
Date:   Wed,  6 May 2020 16:58:50 -0700
Message-Id: <20200506235850.22600-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200506235850.22600-1-sean.j.christopherson@intel.com>
References: <20200506235850.22600-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Skip the Indirect Branch Prediction Barrier that is triggered on a VMCS
switch when temporarily loading vmcs02 to synchronize it to vmcs12, i.e.
give copy_vmcs02_to_vmcs12_rare() the same treatment as
vmx_switch_vmcs().

Make vmx_vcpu_load() static now that it's only referenced within vmx.c.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 4 ++--
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 arch/x86/kvm/vmx/vmx.h    | 1 -
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7d1e19149ef46..4f770eed66cc9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3915,12 +3915,12 @@ static void copy_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 
 	cpu = get_cpu();
 	vmx->loaded_vmcs = &vmx->nested.vmcs02;
-	vmx_vcpu_load(&vmx->vcpu, cpu);
+	vmx_vcpu_load_vmcs(vcpu, cpu, &vmx->vmcs01);
 
 	sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
 
 	vmx->loaded_vmcs = &vmx->vmcs01;
-	vmx_vcpu_load(&vmx->vcpu, cpu);
+	vmx_vcpu_load_vmcs(vcpu, cpu, &vmx->nested.vmcs02);
 	put_cpu();
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ddbd8fae24927..bc5e5cf1d4cc8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1383,7 +1383,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
  */
-void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4a6f382b05b49..298ddef79d009 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -322,7 +322,6 @@ struct kvm_vmx {
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
 void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 			struct loaded_vmcs *buddy);
-void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 int allocate_vpid(void);
 void free_vpid(int vpid);
 void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
-- 
2.26.0

