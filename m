Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481013BA5A5
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbhGBWJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:10 -0400
Received: from mga12.intel.com ([192.55.52.136]:50200 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233151AbhGBWH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="188472741"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="188472741"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:25 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814785"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:25 -0700
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
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 34/69] KVM: x86: Add support for vCPU and device-scoped KVM_MEMORY_ENCRYPT_OP
Date:   Fri,  2 Jul 2021 15:04:40 -0700
Message-Id: <68b1d5fb6afc30e41e46be63ef67412ec3b08fab.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
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
index 9791c4bb5198..e3abf077f328 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1377,7 +1377,9 @@ struct kvm_x86_ops {
 	int (*pre_leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 
+	int (*mem_enc_op_dev)(void __user *argp);
 	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
+	int (*mem_enc_op_vcpu)(struct kvm_vcpu *vcpu, void __user *argp);
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7ae0a47e555..da9f1081cb03 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4109,6 +4109,12 @@ long kvm_arch_dev_ioctl(struct file *filp,
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
@@ -5263,6 +5269,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 #endif
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

