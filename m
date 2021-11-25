Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA6545D1D0
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353079AbhKYA0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:26:06 -0500
Received: from mga14.intel.com ([192.55.52.115]:6415 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352880AbhKYAYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="235649699"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="235649699"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:11 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042192"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:11 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v3 25/59] KVM: x86: Add support for vCPU and device-scoped KVM_MEMORY_ENCRYPT_OP
Date:   Wed, 24 Nov 2021 16:20:08 -0800
Message-Id: <2afae6ea803290415814b96b7ac118bc5364780f.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f12eec3f05ab..74c3c1629563 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1483,7 +1483,9 @@ struct kvm_x86_ops {
 	int (*leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 
+	int (*mem_enc_op_dev)(void __user *argp);
 	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
+	int (*mem_enc_op_vcpu)(struct kvm_vcpu *vcpu, void __user *argp);
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e0bccbd3c44..f2091c4b928a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4339,6 +4339,12 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	case KVM_GET_SUPPORTED_HV_CPUID:
 		r = kvm_ioctl_get_supported_hv_cpuid(NULL, argp);
 		break;
+	case KVM_MEMORY_ENCRYPT_OP:
+		r = -EINVAL;
+		if (!kvm_x86_ops.mem_enc_op_dev)
+			goto out;
+		r = kvm_x86_ops.mem_enc_op_dev(argp);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -5516,6 +5522,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_SET_DEVICE_ATTR:
 		r = kvm_vcpu_ioctl_device_attr(vcpu, ioctl, argp);
 		break;
+	case KVM_MEMORY_ENCRYPT_OP:
+		r = -EINVAL;
+		if (!kvm_x86_ops.mem_enc_op_vcpu)
+			goto out;
+		r = kvm_x86_ops.mem_enc_op_vcpu(vcpu, argp);
+		break;
 	default:
 		r = -EINVAL;
 	}
-- 
2.25.1

