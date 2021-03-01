Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8C13287F0
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 18:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237670AbhCARau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 12:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238052AbhCARWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 12:22:04 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B418BC0611BE
        for <kvm@vger.kernel.org>; Mon,  1 Mar 2021 09:20:23 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o6so12327034pjf.5
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 09:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CkOp2ds10H7JHrs2ACjlS7kM4oIeGR3JMxdGORMrv/w=;
        b=ul130P/TIyb4+FqEAleYjjEP35j0ynkGb8FGZvO7ybk9+E8Ttp1/wVE0s9d8mLssHi
         YPotvWzJs4KD0i5lw4jRhewDIfn5fFK3O4Us5qzO73lUeuZK8TlhHxc965MNW95rlYfb
         KBESgBdJfO2UluZ9d6LR93XaSd7HBDocksZOa0hU1jC59/q8k2aYFQNidOAglwfqssr1
         M/Z9emdUmE6f+XeNXx40BidwWBM8Cg/44on2D+j7e8LO/tdJj5Iul0KquNDq4l+O4aI8
         ex/8vRGweOSl5QwFb88cFY/LsvwC77ubMmvZjkDZ+G2Eou3uymY9mKho74/mtVOM6Mpo
         +9Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CkOp2ds10H7JHrs2ACjlS7kM4oIeGR3JMxdGORMrv/w=;
        b=ShK763qTY50LYUY2JqrfFRPQECYS4u9c8Q45rUcrqxxqsLffc5tBFENXKY7SxDkn5n
         HAw/tS4OXRJkv7ktmWu0hMpz0jyq3WV8o3N0+meHX2JSvmq4cNntCGsz2euEv6pNxF6v
         ipUpgJZRXwRiA9ziStcbwklCojiRMPhZCvisrhTApVme0FoSiLvbqrYLB7QvMtmqCLKI
         hXkahAp/hGfK8hQo62qGuDyXE6rtf2EUOQeaSuV+2uYPtJc7k0FTOJQkoGT0+5NAyj08
         jH5xhD99SoC1SVFKyrXTk88fsCCbHwkZaAha2H54H6UyTWPSB6xP+3d0DS1uR11YmA25
         E7VQ==
X-Gm-Message-State: AOAM532wiP+FaDntahXaJtyLVpBVirXjr9HquPhhoz/yWXw/pDTdvEJS
        YyYShtwcAiPtPJjFN1sjq6uxNQ==
X-Google-Smtp-Source: ABdhPJw+36HCmWr/OqL/LXYgXeqn2jhJQa4myfL54PrCkCfEQWuGiprII1E/lXZIaQSsCIM5DAp7Zg==
X-Received: by 2002:a17:902:aa49:b029:e4:3825:dcd2 with SMTP id c9-20020a170902aa49b02900e43825dcd2mr16353250plr.39.1614619223032;
        Mon, 01 Mar 2021 09:20:23 -0800 (PST)
Received: from google.com ([2620:15c:f:10:5d06:6d3c:7b9:20c9])
        by smtp.gmail.com with ESMTPSA id o3sm16706871pgm.60.2021.03.01.09.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:20:22 -0800 (PST)
Date:   Mon, 1 Mar 2021 09:20:15 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [PATCH 21/25] KVM: VMX: Add SGX ENCLS[ECREATE] handler to
 enforce CPUID restrictions
Message-ID: <YD0iT3c8FMPGUNjo@google.com>
References: <cover.1614590788.git.kai.huang@intel.com>
 <58db33aae58582de8f644b686fc99b27f39d4d8f.1614590788.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58db33aae58582de8f644b686fc99b27f39d4d8f.1614590788.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 01, 2021, Kai Huang wrote:
> +static int handle_encls_ecreate(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpuid_entry2 *sgx_12_0, *sgx_12_1;
> +	gva_t pageinfo_gva, secs_gva;
> +	gva_t metadata_gva, contents_gva;
> +	gpa_t metadata_gpa, contents_gpa, secs_gpa;
> +	unsigned long metadata_hva, contents_hva, secs_hva;
> +	struct sgx_pageinfo pageinfo;
> +	struct sgx_secs *contents;
> +	u64 attributes, xfrm, size;
> +	u32 miscselect;
> +	struct x86_exception ex;
> +	u8 max_size_log2;
> +	int trapnr, r;
> +

(see below)

--- cut here --- >8

> +	sgx_12_0 = kvm_find_cpuid_entry(vcpu, 0x12, 0);
> +	sgx_12_1 = kvm_find_cpuid_entry(vcpu, 0x12, 1);
> +	if (!sgx_12_0 || !sgx_12_1) {
> +		kvm_inject_gp(vcpu, 0);

This should probably be an emulation failure.  This code is reached iff SGX1 is
enabled in the guest, userspace done messed up if they enabled SGX1 without
defining CPUID.0x12.1.  That also makes it more obvious that burying this in a
helper after a bunch of other checks isn't wrong, i.e. KVM has already verified
that SGX1 is enabled in the guest.

> +		return 1;
> +	}

---

> +
> +	if (sgx_get_encls_gva(vcpu, kvm_rbx_read(vcpu), 32, 32, &pageinfo_gva) ||
> +	    sgx_get_encls_gva(vcpu, kvm_rcx_read(vcpu), 4096, 4096, &secs_gva))
> +		return 1;
> +
> +	/*
> +	 * Copy the PAGEINFO to local memory, its pointers need to be
> +	 * translated, i.e. we need to do a deep copy/translate.
> +	 */
> +	r = kvm_read_guest_virt(vcpu, pageinfo_gva, &pageinfo,
> +				sizeof(pageinfo), &ex);
> +	if (r == X86EMUL_PROPAGATE_FAULT) {
> +		kvm_inject_emulated_page_fault(vcpu, &ex);
> +		return 1;
> +	} else if (r != X86EMUL_CONTINUE) {
> +		sgx_handle_emulation_failure(vcpu, pageinfo_gva, size);
> +		return 0;
> +	}
> +
> +	if (sgx_get_encls_gva(vcpu, pageinfo.metadata, 64, 64, &metadata_gva) ||
> +	    sgx_get_encls_gva(vcpu, pageinfo.contents, 4096, 4096,
> +			      &contents_gva))
> +		return 1;
> +
> +	/*
> +	 * Translate the SECINFO, SOURCE and SECS pointers from GVA to GPA.
> +	 * Resume the guest on failure to inject a #PF.
> +	 */
> +	if (sgx_gva_to_gpa(vcpu, metadata_gva, false, &metadata_gpa) ||
> +	    sgx_gva_to_gpa(vcpu, contents_gva, false, &contents_gpa) ||
> +	    sgx_gva_to_gpa(vcpu, secs_gva, true, &secs_gpa))
> +		return 1;
> +
> +	/*
> +	 * ...and then to HVA.  The order of accesses isn't architectural, i.e.
> +	 * KVM doesn't have to fully process one address at a time.  Exit to
> +	 * userspace if a GPA is invalid.
> +	 */
> +	if (sgx_gpa_to_hva(vcpu, metadata_gpa, &metadata_hva) ||
> +	    sgx_gpa_to_hva(vcpu, contents_gpa, &contents_hva) ||
> +	    sgx_gpa_to_hva(vcpu, secs_gpa, &secs_hva))
> +		return 0;
> +	/*
> +	 * Copy contents into kernel memory to prevent TOCTOU attack. E.g. the
> +	 * guest could do ECREATE w/ SECS.SGX_ATTR_PROVISIONKEY=0, and
> +	 * simultaneously set SGX_ATTR_PROVISIONKEY to bypass the check to
> +	 * enforce restriction of access to the PROVISIONKEY.
> +	 */
> +	contents = (struct sgx_secs *)__get_free_page(GFP_KERNEL);
> +	if (!contents)
> +		return -ENOMEM;

--- cut here --- >8

> +
> +	/* Exit to userspace if copying from a host userspace address fails. */
> +	if (sgx_read_hva(vcpu, contents_hva, (void *)contents, PAGE_SIZE))

This, and every failure path below, will leak 'contents'.  The easiest thing is
probably to wrap everything in "cut here" in a separate helper.  The CPUID
lookups can be , e.g.

	contents = (struct sgx_secs *)__get_free_page(GFP_KERNEL);
	if (!contents)
		return -ENOMEM;

	r = __handle_encls_ecreate(vcpu, &pageinfo, secs);

	free_page((unsigned long)contents);
	return r;

And then the helper can be everything below, plus the CPUID lookup:

	sgx_12_0 = kvm_find_cpuid_entry(vcpu, 0x12, 0);
	sgx_12_1 = kvm_find_cpuid_entry(vcpu, 0x12, 1);
	if (!sgx_12_0 || !sgx_12_1) {
		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
		vcpu->run->internal.ndata = 0;
		return 0;
	}


> +		return 0;
> +
> +	miscselect = contents->miscselect;
> +	attributes = contents->attributes;
> +	xfrm = contents->xfrm;
> +	size = contents->size;
> +
> +	/* Enforce restriction of access to the PROVISIONKEY. */
> +	if (!vcpu->kvm->arch.sgx_provisioning_allowed &&
> +	    (attributes & SGX_ATTR_PROVISIONKEY)) {
> +		if (sgx_12_1->eax & SGX_ATTR_PROVISIONKEY)
> +			pr_warn_once("KVM: SGX PROVISIONKEY advertised but not allowed\n");
> +		kvm_inject_gp(vcpu, 0);
> +		return 1;
> +	}
> +
> +	/* Enforce CPUID restrictions on MISCSELECT, ATTRIBUTES and XFRM. */
> +	if ((u32)miscselect & ~sgx_12_0->ebx ||
> +	    (u32)attributes & ~sgx_12_1->eax ||
> +	    (u32)(attributes >> 32) & ~sgx_12_1->ebx ||
> +	    (u32)xfrm & ~sgx_12_1->ecx ||
> +	    (u32)(xfrm >> 32) & ~sgx_12_1->edx) {
> +		kvm_inject_gp(vcpu, 0);
> +		return 1;
> +	}
> +
> +	/* Enforce CPUID restriction on max enclave size. */
> +	max_size_log2 = (attributes & SGX_ATTR_MODE64BIT) ? sgx_12_0->edx >> 8 :
> +							    sgx_12_0->edx;
> +	if (size >= BIT_ULL(max_size_log2))
> +		kvm_inject_gp(vcpu, 0);
> +
> +	pageinfo.metadata = metadata_hva;
> +	pageinfo.contents = (u64)contents;
> +
> +	r = sgx_virt_ecreate(&pageinfo, (void __user *)secs_hva, &trapnr);
> +
> +	free_page((unsigned long)contents);
> +
> +	if (r)
> +		return sgx_inject_fault(vcpu, secs_gva, trapnr);
> +
> +	return kvm_skip_emulated_instruction(vcpu);

---

> +}
> +
>  static inline bool encls_leaf_enabled_in_guest(struct kvm_vcpu *vcpu, u32 leaf)
>  {
>  	if (!enable_sgx || !guest_cpuid_has(vcpu, X86_FEATURE_SGX))
> @@ -41,6 +286,8 @@ int handle_encls(struct kvm_vcpu *vcpu)
>  	} else if (!sgx_enabled_in_guest_bios(vcpu)) {
>  		kvm_inject_gp(vcpu, 0);
>  	} else {
> +		if (leaf == ECREATE)
> +			return handle_encls_ecreate(vcpu);
>  		WARN(1, "KVM: unexpected exit on ENCLS[%u]", leaf);
>  		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
>  		vcpu->run->hw.hardware_exit_reason = EXIT_REASON_ENCLS;
> -- 
> 2.29.2
> 
