Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BC7486E45
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 01:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343662AbiAGADJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 19:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245631AbiAGADJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 19:03:09 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C12C061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 16:03:08 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id iy13so3756259pjb.5
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 16:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l1t9kIfl1gk+1GwOXc/6jik8uobFLWDwlvLVoOnYJFM=;
        b=a0q5vxcCsEkI+tSuc9EvSVS6Pu/p5qSJqJKtSQRcvsSjhTNe/45UDkSVNffDctrjGe
         axvr3FbZiJq4uqoYX3Cvx2PVuu88L/F3Zowhc7dhUHPI1t7YLIz/vo7wK410S8GSYJhp
         4nJbjQB7moguCRHTDal6iGf8zEYN1Ior18HRDjIzqrMiDPotb6w6MTrXuowdowPX52k3
         ViY3xU0oc6p1auCUg2BkuypGiSWSwCdlpRFdyDO5EasDF0B6l9L0wh1lOALxhq49kLO+
         yMbOr9CsFhtK2MlI7uISRTkwLGKIXQdZFYLbJQFefiwQCeOy9lwetdP5v4GhEWnlFBm8
         UZwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l1t9kIfl1gk+1GwOXc/6jik8uobFLWDwlvLVoOnYJFM=;
        b=4T1ErhDFu5lvfKapVBMgKw6stkfkLZrZ/cXuaHoBOQTaCFXZ+SX7cusw9DHAsAxs6u
         oSUyhjUX8qjQ6Wtiqlz8zhGovTO4MKzMvKjgQ83LcSrih5Kxx3XCvjt2Gw1Dwdsiq/QA
         6axJaNQwN+lAXgWDm7oCSNuEhzqOYGgXlk6hCEFtBtJeEKrdk01FKXfoDd0FYqcKvvj8
         2/HFntWUSOA4MeStOp2phsLIj64+EPcR+3/NPP/ZOm0iQdRCTb+x6ei7obXQtE7J71In
         4aRRtTno0BSHN60Gz4jiT9BhRf6CmN83a89zdp2zmeyx6ykpX+1P0UxysXYZTdpY3KKb
         yciQ==
X-Gm-Message-State: AOAM533oEk+8BrGaP+vcjP5zQF9+wODo7kLEQFDotBmEKg71Nh6Yvx6x
        5bS4jQtHqanrbFk1RQitwCw71g==
X-Google-Smtp-Source: ABdhPJx1RVbPdRhyykBG75L7cdWUYFilTBiikqMjDdiinOKIeFIAMo5m15T9DZ/92uEZxSVU6poHqQ==
X-Received: by 2002:a17:902:a502:b0:149:c5a5:5329 with SMTP id s2-20020a170902a50200b00149c5a55329mr14185766plq.164.1641513788028;
        Thu, 06 Jan 2022 16:03:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n14sm2853684pgd.80.2022.01.06.16.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 16:03:07 -0800 (PST)
Date:   Fri, 7 Jan 2022 00:03:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: nVMX: Allow VMREAD when Enlightened VMCS is in
 use
Message-ID: <YdeDNzho8LihsF5o@google.com>
References: <20211214143859.111602-1-vkuznets@redhat.com>
 <20211214143859.111602-6-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214143859.111602-6-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 14, 2021, Vitaly Kuznetsov wrote:
> Hyper-V TLFS explicitly forbids VMREAD and VMWRITE instructions when
> Enlightened VMCS interface is in use:
> 
> "Any VMREAD or VMWRITE instructions while an enlightened VMCS is
> active is unsupported and can result in unexpected behavior.""
> 
> Windows 11 + WSL2 seems to ignore this, attempts to VMREAD VMCS field
> 0x4404 ("VM-exit interruption information") are observed. Failing
> these attempts with nested_vmx_failInvalid() makes such guests
> unbootable.
> 
> Microsoft confirms this is a Hyper-V bug and claims that it'll get fixed
> eventually but for the time being we need a workaround. (Temporary) allow

Temporarily.  And for the record, I highly doubt this will be temporary :-)

> VMREAD to get data from the currently loaded Enlightened VMCS.

...

> @@ -5074,27 +5075,44 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>  	if (!nested_vmx_check_permission(vcpu))
>  		return 1;
>  
> +	/* Normal or Enlightened VMPTRLD must be performed first */
> +	if (vmx->nested.current_vmptr == INVALID_GPA &&
> +	    !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +		return nested_vmx_failInvalid(vcpu);

I believe this is wrong, as it allows this combination

	current_vmptr == INVALID_GPA && evmptr_is_valid() && is_guest_mode()

which is eVMCS with VMCS shadowing exposed to L2.  SECONDARY_EXEC_SHADOW_VMCS is
listed in EVMCS1_UNSUPPORTED_2NDEXEC, so it should be impossible for VMCS shadowing
to be enabled for L2.  And if VMCS shadowing is not enabled, all VMREADs cause
exits to L1, i.e. shouldn't reach this point.  If we want to allow that behavior,
then I think that should be a separate change.

Assuming eVMCS really isn't compatible with shadow VMCS, I believe we can do:

	/*
	 * Decode instruction info and find the field to read.  This can be
	 * done speculatively as there are no side effects
	 */
	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));

	if (!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
		/*
		 * In VMX non-root operation, when the VMCS-link pointer is
		 * INVALID_GPA, any VMREAD sets the ALU flags for VMfailInvalid.
		 */
		if (vmx->nested.current_vmptr == INVALID_GPA ||
		    (is_guest_mode(vcpu) &&
		     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
			return nested_vmx_failInvalid(vcpu);

		offset = vmcs12_field_offset(field);
		if (offset < 0)
			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);

		if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
			copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);

		/* Read the field, zero-extended to a u64 value */
		value = vmcs12_read_any(vmcs12, field, offset);
	} else {
		/*
		 * <snarky comment about Hyper-V>
		 */
		if (WARN_ON_ONCE(is_guest_mode(vcpu))
			return nested_vmx_failInvalid(vcpu);

		offset = evmcs_field_offset(field, NULL);
		if (offset < 0)
			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);

		/* Read the field, zero-extended to a u64 value */
		value = evmcs_read_any(vmx->nested.hv_evmcs, field, offset);
	}
