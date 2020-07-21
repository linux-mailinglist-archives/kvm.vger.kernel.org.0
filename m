Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEAC228420
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 17:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgGUPrf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 11:47:35 -0400
Received: from mga18.intel.com ([134.134.136.126]:25738 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgGUPrf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 11:47:35 -0400
IronPort-SDR: 94oebsorumOKhMBFikMS4GcSNFmeQw6X1tVxQQWRN2k8XnY0EpEAETWVz4h7ljL0GgEJaUZhzt
 epmejd3pH3FA==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="137654416"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="137654416"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 08:47:34 -0700
IronPort-SDR: 9GlHVtXFYmJ5YIJuaam9Dhj7rUEU4iVcVpg4AjATfw6wFGLNu290PKV4hPUCClBSRyOFq9Lds5
 atSYYf5hfHlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="271751941"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 21 Jul 2020 08:47:34 -0700
Date:   Tue, 21 Jul 2020 08:47:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Fix names of implemented kvm_x86_ops in VMX
 and SVM modules
Message-ID: <20200721154734.GD22083@linux.intel.com>
References: <20200720220728.11140-1-krish.sadhukhan@oracle.com>
 <20200720220728.11140-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720220728.11140-2-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 20, 2020 at 06:07:28PM -0400, Krish Sadhukhan wrote:
> Some of the names do not have a corresponding 'vmx_' or 'svm_' prefix. Also,
> the order of the words in some of the names is not the same as that in the
> kvm_x86_ops structure. Fixing the naming will help in better readability of
> the code and maintenance.

If we're going to do a massive rename, I would strongly prefer to
simultaneously enforce the "correct" names by adding a macro to generate the
kvm_x86_ops hooks[*] (sample patch below).  I'd like to realize long term
benefits if we're going to incur merge conflicts on everyone's in-flight
development.

I had a series for this, but it got derailed when svm.c was fractured and I
haven't found time to get back to it.  Code is on
https://github.com/sean-jc/linux/tree/vmx/x86_ops_macros if you have bandwidth
to pick it up.

[*] https://lkml.kernel.org/r/30b847cf-98db-145f-8aa0-a847146d5649@redhat.com


commit 83b835803554f6288af438a519be2c2559d77d89
Author: Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Fri Apr 3 14:12:28 2020 -0700

    KVM: VMX: Fill in conforming vmx_x86_ops via macro

    Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
    Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
    Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4a8b5a21dcd2e..adb75e21fd021 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6279,14 +6279,16 @@ void nested_vmx_hardware_unsetup(void)
        }
 }

+#define KVM_X86_NESTED_OP(name) .name = nested_vmx_##name
+
 static struct kvm_x86_nested_ops vmx_nested_ops __initdata = {
-       .check_events = nested_vmx_check_events,
-       .get_state = nested_vmx_get_state,
-       .set_state = nested_vmx_set_state,
-       .get_vmcs12_pages = nested_vmx_get_vmcs12_pages,
-       .enable_evmcs = nested_vmx_enable_evmcs,
-       .get_evmcs_version = nested_vmx_get_evmcs_version,
-       .write_log_dirty = nested_vmx_write_log_dirty,
+       KVM_X86_NESTED_OP(check_events),
+       KVM_X86_NESTED_OP(get_state),
+       KVM_X86_NESTED_OP(set_state),
+       KVM_X86_NESTED_OP(get_vmcs12_pages),
+       KVM_X86_NESTED_OP(enable_evmcs),
+       KVM_X86_NESTED_OP(get_evmcs_version),
+       KVM_X86_NESTED_OP(write_log_dirty),
 };

 __init int nested_vmx_hardware_setup(struct kvm_x86_nested_ops *nested_ops,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8453c5b6f090c..447acda22af17 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7626,134 +7626,136 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
        return supported & BIT(bit);
 }

+#define KVM_X86_OP(name) .name = vmx_##name
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
-       .hardware_unsetup = vmx_hardware_unsetup,
+       KVM_X86_OP(hardware_unsetup),

-       .hardware_enable = vmx_hardware_enable,
-       .hardware_disable = vmx_hardware_disable,
-       .cpu_has_accelerated_tpr = vmx_cpu_has_accelerated_tpr,
-       .has_emulated_msr = vmx_has_emulated_msr,
+       KVM_X86_OP(hardware_enable),
+       KVM_X86_OP(hardware_disable),
+       KVM_X86_OP(cpu_has_accelerated_tpr),
+       KVM_X86_OP(has_emulated_msr),

...
