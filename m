Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B616032A6D7
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575885AbhCBPxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:53:46 -0500
Received: from mga03.intel.com ([134.134.136.65]:15924 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238045AbhCBAzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 19:55:47 -0500
IronPort-SDR: 830Tlm/yRY1u5PWZ65qxSSe7m4ZYKHXcVm2/rF/PR/iG7ZPzT1YIIbZLvjwze5JPVvkWTbKCbj
 tx6O7lAi/Ung==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="186699970"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="186699970"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:54:44 -0800
IronPort-SDR: pcL/gSin5IPrKGR4yEFLKXeoLMmDuU79vvGCDOKZx1G5lW+8HeDKGOHuJLM8X/37JS/H1bjoPR
 uJStPXHjcfxw==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="406475662"
Received: from yueliu2-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.139.111])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:54:39 -0800
Date:   Tue, 2 Mar 2021 13:54:37 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [PATCH 21/25] KVM: VMX: Add SGX ENCLS[ECREATE] handler to
 enforce CPUID restrictions
Message-Id: <20210302135437.36a274c7395953219cd3d417@intel.com>
In-Reply-To: <YD0iT3c8FMPGUNjo@google.com>
References: <cover.1614590788.git.kai.huang@intel.com>
        <58db33aae58582de8f644b686fc99b27f39d4d8f.1614590788.git.kai.huang@intel.com>
        <YD0iT3c8FMPGUNjo@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Mar 2021 09:20:15 -0800 Sean Christopherson wrote:
> On Mon, Mar 01, 2021, Kai Huang wrote:
> > +static int handle_encls_ecreate(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_cpuid_entry2 *sgx_12_0, *sgx_12_1;
> > +	gva_t pageinfo_gva, secs_gva;
> > +	gva_t metadata_gva, contents_gva;
> > +	gpa_t metadata_gpa, contents_gpa, secs_gpa;
> > +	unsigned long metadata_hva, contents_hva, secs_hva;
> > +	struct sgx_pageinfo pageinfo;
> > +	struct sgx_secs *contents;
> > +	u64 attributes, xfrm, size;
> > +	u32 miscselect;
> > +	struct x86_exception ex;
> > +	u8 max_size_log2;
> > +	int trapnr, r;
> > +
> 
> (see below)
> 
> --- cut here --- >8
> 
> > +	sgx_12_0 = kvm_find_cpuid_entry(vcpu, 0x12, 0);
> > +	sgx_12_1 = kvm_find_cpuid_entry(vcpu, 0x12, 1);
> > +	if (!sgx_12_0 || !sgx_12_1) {
> > +		kvm_inject_gp(vcpu, 0);
> 
> This should probably be an emulation failure.  This code is reached iff SGX1 is
> enabled in the guest, userspace done messed up if they enabled SGX1 without
> defining CPUID.0x12.1.  That also makes it more obvious that burying this in a
> helper after a bunch of other checks isn't wrong, i.e. KVM has already verified
> that SGX1 is enabled in the guest.

Agreed.

> 
> > +		return 1;
> > +	}
> 
> ---
> 
> > +
> > +	if (sgx_get_encls_gva(vcpu, kvm_rbx_read(vcpu), 32, 32, &pageinfo_gva) ||
> > +	    sgx_get_encls_gva(vcpu, kvm_rcx_read(vcpu), 4096, 4096, &secs_gva))
> > +		return 1;
> > +
> > +	/*
> > +	 * Copy the PAGEINFO to local memory, its pointers need to be
> > +	 * translated, i.e. we need to do a deep copy/translate.
> > +	 */
> > +	r = kvm_read_guest_virt(vcpu, pageinfo_gva, &pageinfo,
> > +				sizeof(pageinfo), &ex);
> > +	if (r == X86EMUL_PROPAGATE_FAULT) {
> > +		kvm_inject_emulated_page_fault(vcpu, &ex);
> > +		return 1;
> > +	} else if (r != X86EMUL_CONTINUE) {
> > +		sgx_handle_emulation_failure(vcpu, pageinfo_gva, size);
> > +		return 0;
> > +	}
> > +
> > +	if (sgx_get_encls_gva(vcpu, pageinfo.metadata, 64, 64, &metadata_gva) ||
> > +	    sgx_get_encls_gva(vcpu, pageinfo.contents, 4096, 4096,
> > +			      &contents_gva))
> > +		return 1;
> > +
> > +	/*
> > +	 * Translate the SECINFO, SOURCE and SECS pointers from GVA to GPA.
> > +	 * Resume the guest on failure to inject a #PF.
> > +	 */
> > +	if (sgx_gva_to_gpa(vcpu, metadata_gva, false, &metadata_gpa) ||
> > +	    sgx_gva_to_gpa(vcpu, contents_gva, false, &contents_gpa) ||
> > +	    sgx_gva_to_gpa(vcpu, secs_gva, true, &secs_gpa))
> > +		return 1;
> > +
> > +	/*
> > +	 * ...and then to HVA.  The order of accesses isn't architectural, i.e.
> > +	 * KVM doesn't have to fully process one address at a time.  Exit to
> > +	 * userspace if a GPA is invalid.
> > +	 */
> > +	if (sgx_gpa_to_hva(vcpu, metadata_gpa, &metadata_hva) ||
> > +	    sgx_gpa_to_hva(vcpu, contents_gpa, &contents_hva) ||
> > +	    sgx_gpa_to_hva(vcpu, secs_gpa, &secs_hva))
> > +		return 0;
> > +	/*
> > +	 * Copy contents into kernel memory to prevent TOCTOU attack. E.g. the
> > +	 * guest could do ECREATE w/ SECS.SGX_ATTR_PROVISIONKEY=0, and
> > +	 * simultaneously set SGX_ATTR_PROVISIONKEY to bypass the check to
> > +	 * enforce restriction of access to the PROVISIONKEY.
> > +	 */
> > +	contents = (struct sgx_secs *)__get_free_page(GFP_KERNEL);
> > +	if (!contents)
> > +		return -ENOMEM;
> 
> --- cut here --- >8
> 
> > +
> > +	/* Exit to userspace if copying from a host userspace address fails. */
> > +	if (sgx_read_hva(vcpu, contents_hva, (void *)contents, PAGE_SIZE))
> 
> This, and every failure path below, will leak 'contents'.  The easiest thing is
> probably to wrap everything in "cut here" in a separate helper.  The CPUID
> lookups can be , e.g.
> 
> 	contents = (struct sgx_secs *)__get_free_page(GFP_KERNEL);
> 	if (!contents)
> 		return -ENOMEM;
> 
> 	r = __handle_encls_ecreate(vcpu, &pageinfo, secs);
> 
> 	free_page((unsigned long)contents);
> 	return r;
> 
> And then the helper can be everything below, plus the CPUID lookup:
> 
> 	sgx_12_0 = kvm_find_cpuid_entry(vcpu, 0x12, 0);
> 	sgx_12_1 = kvm_find_cpuid_entry(vcpu, 0x12, 1);
> 	if (!sgx_12_0 || !sgx_12_1) {
> 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> 		vcpu->run->internal.ndata = 0;
> 		return 0;
> 	}
> 

Hmm.. Obviously I wasn't careful enough. Thanks for pointing out.

Will do in your way.

> 
> > +		return 0;
> > +
> > +	miscselect = contents->miscselect;
> > +	attributes = contents->attributes;
> > +	xfrm = contents->xfrm;
> > +	size = contents->size;
> > +
> > +	/* Enforce restriction of access to the PROVISIONKEY. */
> > +	if (!vcpu->kvm->arch.sgx_provisioning_allowed &&
> > +	    (attributes & SGX_ATTR_PROVISIONKEY)) {
> > +		if (sgx_12_1->eax & SGX_ATTR_PROVISIONKEY)
> > +			pr_warn_once("KVM: SGX PROVISIONKEY advertised but not allowed\n");
> > +		kvm_inject_gp(vcpu, 0);
> > +		return 1;
> > +	}
> > +
> > +	/* Enforce CPUID restrictions on MISCSELECT, ATTRIBUTES and XFRM. */
> > +	if ((u32)miscselect & ~sgx_12_0->ebx ||
> > +	    (u32)attributes & ~sgx_12_1->eax ||
> > +	    (u32)(attributes >> 32) & ~sgx_12_1->ebx ||
> > +	    (u32)xfrm & ~sgx_12_1->ecx ||
> > +	    (u32)(xfrm >> 32) & ~sgx_12_1->edx) {
> > +		kvm_inject_gp(vcpu, 0);
> > +		return 1;
> > +	}
> > +
> > +	/* Enforce CPUID restriction on max enclave size. */
> > +	max_size_log2 = (attributes & SGX_ATTR_MODE64BIT) ? sgx_12_0->edx >> 8 :
> > +							    sgx_12_0->edx;
> > +	if (size >= BIT_ULL(max_size_log2))
> > +		kvm_inject_gp(vcpu, 0);
> > +
> > +	pageinfo.metadata = metadata_hva;
> > +	pageinfo.contents = (u64)contents;
> > +
> > +	r = sgx_virt_ecreate(&pageinfo, (void __user *)secs_hva, &trapnr);
> > +
> > +	free_page((unsigned long)contents);
> > +
> > +	if (r)
> > +		return sgx_inject_fault(vcpu, secs_gva, trapnr);
> > +
> > +	return kvm_skip_emulated_instruction(vcpu);
> 
> ---
> 
> > +}
> > +
> >  static inline bool encls_leaf_enabled_in_guest(struct kvm_vcpu *vcpu, u32 leaf)
> >  {
> >  	if (!enable_sgx || !guest_cpuid_has(vcpu, X86_FEATURE_SGX))
> > @@ -41,6 +286,8 @@ int handle_encls(struct kvm_vcpu *vcpu)
> >  	} else if (!sgx_enabled_in_guest_bios(vcpu)) {
> >  		kvm_inject_gp(vcpu, 0);
> >  	} else {
> > +		if (leaf == ECREATE)
> > +			return handle_encls_ecreate(vcpu);
> >  		WARN(1, "KVM: unexpected exit on ENCLS[%u]", leaf);
> >  		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
> >  		vcpu->run->hw.hardware_exit_reason = EXIT_REASON_ENCLS;
> > -- 
> > 2.29.2
> > 
