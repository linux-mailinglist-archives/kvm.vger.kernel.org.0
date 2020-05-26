Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E901C7B79
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 22:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgEFUqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 16:46:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:10412 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbgEFUqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 16:46:55 -0400
IronPort-SDR: eLwSlkkeD9bgYUVZyJvrf1CXZFoe2lrRmqJC1y2RgPsOEwAsB/SyiB8uGxPhx399j0fnoMqozf
 Fmt7KXzHNi6A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 13:46:54 -0700
IronPort-SDR: ADWdu/2AJnNYrEuYmusZKmq5/Bt1ju1DiUUzsmwbVmNR23iLMYujA9nPwIo2TisLcL0KDhewdB
 Sge3yu8LYtEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,360,1583222400"; 
   d="scan'208";a="296304662"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 06 May 2020 13:46:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: Remove unused 'ops' param from nested_vmx_hardware_setup()
Date:   Wed,  6 May 2020 13:46:53 -0700
Message-Id: <20200506204653.14683-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove a 'struct kvm_x86_ops' param that got left behind when the nested
ops were moved to their own struct.

Fixes: 33b22172452f0 ("KVM: x86: move nested-related kvm_x86_ops to a separate struct")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 3 +--
 arch/x86/kvm/vmx/nested.h | 3 +--
 arch/x86/kvm/vmx/vmx.c    | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 20a9edca51fa5..fb1548279258a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6425,8 +6425,7 @@ void nested_vmx_hardware_unsetup(void)
 	}
 }
 
-__init int nested_vmx_hardware_setup(struct kvm_x86_ops *ops,
-				     int (*exit_handlers[])(struct kvm_vcpu *))
+__init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 {
 	int i;
 
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 5cc72ae0e277b..758bccc26cf98 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -19,8 +19,7 @@ enum nvmx_vmentry_status {
 void vmx_leave_nested(struct kvm_vcpu *vcpu);
 void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps);
 void nested_vmx_hardware_unsetup(void);
-__init int nested_vmx_hardware_setup(struct kvm_x86_ops *ops,
-				     int (*exit_handlers[])(struct kvm_vcpu *));
+__init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
 void nested_vmx_set_vmcs_shadowing_bitmap(void);
 void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
 enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 94f49c5ae89aa..b413903b55089 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8112,8 +8112,7 @@ static __init int hardware_setup(void)
 		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
 					   vmx_capability.ept);
 
-		r = nested_vmx_hardware_setup(&vmx_x86_ops,
-					      kvm_vmx_exit_handlers);
+		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
 		if (r)
 			return r;
 	}
-- 
2.26.0

