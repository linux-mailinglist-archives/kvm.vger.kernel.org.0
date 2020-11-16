Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838212B4FB5
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388282AbgKPSbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:31:46 -0500
Received: from mga06.intel.com ([134.134.136.31]:20632 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388086AbgKPS2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:07 -0500
IronPort-SDR: 1d5VERfjlxyyJO5+vvxDeYX3iJnR8rQBLWOYEMc5rdHAtUKclbwkHnK/AZ/IRl4Wp/Io9a31sA
 M7uWCFQzO+tw==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410036"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410036"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:05 -0800
IronPort-SDR: Ws7KFcD1VWTxivoZy45znlk81pJhdslnPXH2pnnNBT1RnLATydKvOSjWlJTNtZY8XBTsj79hzY
 ZWMm2BnFzHGA==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528022"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:04 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 27/67] KVM: x86: Add support for vCPU and device-scoped KVM_MEMORY_ENCRYPT_OP
Date:   Mon, 16 Nov 2020 10:26:12 -0800
Message-Id: <69f91c5f7625f3e63e15bba4de17ac3765853071.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 01c78eeefef4..32e995327944 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1276,7 +1276,9 @@ struct kvm_x86_ops {
 	int (*pre_leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 
+	int (*mem_enc_op_dev)(void __user *argp);
 	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
+	int (*mem_enc_op_vcpu)(struct kvm_vcpu *vcpu, void __user *argp);
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 22e956f01ddc..7b8bbdc98492 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3882,6 +3882,12 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	case KVM_GET_MSRS:
 		r = msr_io(NULL, argp, do_get_msr_feature, 1);
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
@@ -5020,6 +5026,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
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
2.17.1

