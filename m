Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 610C417AADC
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 17:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgCEQt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 11:49:28 -0500
Received: from mga12.intel.com ([192.55.52.136]:42731 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgCEQt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 11:49:28 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 08:49:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,518,1574150400"; 
   d="scan'208";a="320257512"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 05 Mar 2020 08:49:26 -0800
Date:   Thu, 5 Mar 2020 08:49:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com,
        peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 8/8] x86: vmx: virtualize split lock detection
Message-ID: <20200305164926.GH11500@linux.intel.com>
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
 <20200206070412.17400-9-xiaoyao.li@intel.com>
 <20200303193012.GV1439@linux.intel.com>
 <fb22d13d-60f5-5050-ccc7-4422f5b25739@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb22d13d-60f5-5050-ccc7-4422f5b25739@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 05, 2020 at 10:16:40PM +0800, Xiaoyao Li wrote:
> On 3/4/2020 3:30 AM, Sean Christopherson wrote:
> >On Thu, Feb 06, 2020 at 03:04:12PM +0800, Xiaoyao Li wrote:
> >>--- a/arch/x86/kvm/vmx/vmx.c
> >>+++ b/arch/x86/kvm/vmx/vmx.c
> >>@@ -1781,6 +1781,25 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
> >>  	}
> >>  }
> >>+/*
> >>+ * Note: for guest, feature split lock detection can only be enumerated through
> >>+ * MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT bit. The FMS enumeration is invalid.
> >>+ */
> >>+static inline bool guest_has_feature_split_lock_detect(struct kvm_vcpu *vcpu)
> >>+{
> >>+	return vcpu->arch.core_capabilities & MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT;
> >>+}
> >>+
> >>+static inline u64 vmx_msr_test_ctrl_valid_bits(struct kvm_vcpu *vcpu)
> >>+{
> >>+	u64 valid_bits = 0;
> >>+
> >>+	if (guest_has_feature_split_lock_detect(vcpu))
> >>+		valid_bits |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
> >>+
> >>+	return valid_bits;
> >>+}
> >>+
> >>  /*
> >>   * Reads an msr value (of 'msr_index') into 'pdata'.
> >>   * Returns 0 on success, non-0 otherwise.
> >>@@ -1793,6 +1812,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >>  	u32 index;
> >>  	switch (msr_info->index) {
> >>+	case MSR_TEST_CTRL:
> >>+		if (!msr_info->host_initiated &&
> >>+		    !guest_has_feature_split_lock_detect(vcpu))
> >>+			return 1;
> >>+		msr_info->data = vmx->msr_test_ctrl;
> >>+		break;
> >>  #ifdef CONFIG_X86_64
> >>  	case MSR_FS_BASE:
> >>  		msr_info->data = vmcs_readl(GUEST_FS_BASE);
> >>@@ -1934,6 +1959,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >>  	u32 index;
> >>  	switch (msr_index) {
> >>+	case MSR_TEST_CTRL:
> >>+		if (!msr_info->host_initiated &&
> >
> >Host initiated writes need to be validated against
> >kvm_get_core_capabilities(), otherwise userspace can enable SLD when it's
> >supported in hardware and the kernel, but can't be safely exposed to the
> >guest due to SMT being on.
> 
> How about making the whole check like this:
> 
> 	if (!msr_info->host_initiated &&
> 	    (!guest_has_feature_split_lock_detect(vcpu))
> 		return 1;
> 
> 	if (data & ~vmx_msr_test_ctrl_valid_bits(vcpu))

Whoops, the check on kvm_get_core_capabilities() should be done in
"case MSR_IA32_CORE_CAPS:", i.e. KVM shouldn't let host userspace advertise
split-lock support unless it's allowed by KVM.

Then this code doesn't need to do a check on host_initiated=true.

Back to the original code, I don't think we need to make the existence of
MSR_TEST_CTRL dependent on guest_has_feature_split_lock_detect(), i.e. this
check can simply be:

	if (!msr_info->host_initiated &&
	    (data & ~vmx_msr_test_ctrl_valid_bits(vcpu)))
		return 1;

and vmx_get_msr() doesn't need to check anything, i.e. RDMSR always
succeeds.  This is actually aligned with real silicon behavior because
MSR_TEST_CTRL exists on older processors, it's just wasn't documented until
we decided to throw in SPLIT_LOCK_AC, e.g. the LOCK# suppression bit is
marked for deprecation in the SDM, which wouldn't be necessary if it didn't
exist :-)

  Intel ISA/Feature                          Year of Removal
  TEST_CTRL MSR, bit 31 (MSR address 33H)    2019 onwards

  31 Disable LOCK# assertion for split locked access

On my Haswell box:

  $ rdmsr 0x33
  0
  $ wrmsr 0x33 0x20000000
  wrmsr: CPU 0 cannot set MSR 0x00000033 to 0x0000000020000000
  $ wrmsr 0x33 0x80000000
  $ rdmsr 0x33
  80000000
  $ wrmsr 0x33 0x00000000
  $ rdmsr 0x33
  0

That way the guest_has_feature_split_lock_detect() helper isn't needed
since its only user is vmx_msr_test_ctrl_valid_bits(), i.e. it can be
open coded there.

> >>+		    (!guest_has_feature_split_lock_detect(vcpu) ||
> >>+		     data & ~vmx_msr_test_ctrl_valid_bits(vcpu)))
> >>+			return 1;
> >>+		vmx->msr_test_ctrl = data;
> m>+		break;
