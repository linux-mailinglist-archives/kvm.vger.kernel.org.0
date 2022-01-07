Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC20487440
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 09:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346162AbiAGItM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 03:49:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231298AbiAGItM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 03:49:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641545351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6palvWqfH5KyhGR0Cfbu8us1WPnz3WY1UKlbwit/wL8=;
        b=CeId4hW5k2GWCAAEsfj5vpR25JkiFJXgkg3cpAMCFYTz05uc9Ll2tY/xFdPHjAvbOuqTrG
        BtNEW2EPGfjo8+gO4BLwnkSpe/OSQAqxnfhZ3YZzULw4KKU/vZL/vqYMzquiGf+vLT2e5m
        Wu7wgwi8GRSGLz7JfD5IFqvKR9TamFI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-YuZO87M_OcKNFhmTxtW6Wg-1; Fri, 07 Jan 2022 03:49:10 -0500
X-MC-Unique: YuZO87M_OcKNFhmTxtW6Wg-1
Received: by mail-wm1-f72.google.com with SMTP id b9-20020a7bc249000000b00347c5699809so294187wmj.1
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 00:49:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6palvWqfH5KyhGR0Cfbu8us1WPnz3WY1UKlbwit/wL8=;
        b=mV6+8Kfos7AMJyuy76AoFJ7zJhB8yfxClaqGVa4KtO2AqsJg2qMj7Tuou5KvcSWCRX
         TkBQEko8/XS9vjbDhTtqp9IcYBB/Cqk9bQNTUd+I/gTdd3jGGb/9ounBSp0zcbDOzxob
         nCcz/AB7qwGOIpu6Cy3SQRlJqLCRS2TjbfSa/9n6jvIQpyWFup4HClyoysosrPSoRO9U
         UYa3a6hICRPOvW9V8glcPJcelBQCEtw5F3fAuelHp/VxlfCmbAf8hOQdY9AdcXEfoIi6
         93geGZHoUf9vZ0m8mTgi0t5aoXUM1l+gX5bHK8MP3b6g25gLd1PhAXAWhuMnpMTdKFQH
         iYyw==
X-Gm-Message-State: AOAM533dfNQVBPYFf0Z10YraTn+YOMkrU5M5cZf1gn9X2utBfAmiixWi
        TELpA0UXEzjnYbscLwPxADoBl7izCZ9qdrwy9IYbMCBd2x2UZr3+D1GTZAJCM1vPnz7TyoXUttK
        NEuZ/xls80Jvi
X-Received: by 2002:adf:fc50:: with SMTP id e16mr9390768wrs.554.1641545349270;
        Fri, 07 Jan 2022 00:49:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJySkbXqG2xki3KSYdnsJVvy9VoZM4eO74+AV/DdBkYX9hu/aqfLJUkycWON9qrUR2HHBlANow==
X-Received: by 2002:adf:fc50:: with SMTP id e16mr9390755wrs.554.1641545349083;
        Fri, 07 Jan 2022 00:49:09 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u12sm4111477wrf.60.2022.01.07.00.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 00:49:08 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: nVMX: Allow VMREAD when Enlightened VMCS is in
 use
In-Reply-To: <YdeDNzho8LihsF5o@google.com>
References: <20211214143859.111602-1-vkuznets@redhat.com>
 <20211214143859.111602-6-vkuznets@redhat.com>
 <YdeDNzho8LihsF5o@google.com>
Date:   Fri, 07 Jan 2022 09:49:07 +0100
Message-ID: <87a6g8orr0.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Dec 14, 2021, Vitaly Kuznetsov wrote:
>> Hyper-V TLFS explicitly forbids VMREAD and VMWRITE instructions when
>> Enlightened VMCS interface is in use:
>> 
>> "Any VMREAD or VMWRITE instructions while an enlightened VMCS is
>> active is unsupported and can result in unexpected behavior.""
>> 
>> Windows 11 + WSL2 seems to ignore this, attempts to VMREAD VMCS field
>> 0x4404 ("VM-exit interruption information") are observed. Failing
>> these attempts with nested_vmx_failInvalid() makes such guests
>> unbootable.
>> 
>> Microsoft confirms this is a Hyper-V bug and claims that it'll get fixed
>> eventually but for the time being we need a workaround. (Temporary) allow
>
> Temporarily.  And for the record, I highly doubt this will be temporary :-)
>

I'm just trying to be optimistic, at least in commit messages, you know :-)

>> VMREAD to get data from the currently loaded Enlightened VMCS.
>
> ...
>
>> @@ -5074,27 +5075,44 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>>  	if (!nested_vmx_check_permission(vcpu))
>>  		return 1;
>>  
>> +	/* Normal or Enlightened VMPTRLD must be performed first */
>> +	if (vmx->nested.current_vmptr == INVALID_GPA &&
>> +	    !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
>> +		return nested_vmx_failInvalid(vcpu);
>
> I believe this is wrong, as it allows this combination
>
> 	current_vmptr == INVALID_GPA && evmptr_is_valid() && is_guest_mode()
>
> which is eVMCS with VMCS shadowing exposed to L2.  SECONDARY_EXEC_SHADOW_VMCS is
> listed in EVMCS1_UNSUPPORTED_2NDEXEC, so it should be impossible for VMCS shadowing
> to be enabled for L2.  And if VMCS shadowing is not enabled, all VMREADs cause
> exits to L1, i.e. shouldn't reach this point.  If we want to allow that behavior,
> then I think that should be a separate change.

I think you're right, there's no need to allow for that. I'll use your
suggestion from below, thanks!

>
> Assuming eVMCS really isn't compatible with shadow VMCS, I believe we can do:
>
> 	/*
> 	 * Decode instruction info and find the field to read.  This can be
> 	 * done speculatively as there are no side effects
> 	 */
> 	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
>
> 	if (!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
> 		/*
> 		 * In VMX non-root operation, when the VMCS-link pointer is
> 		 * INVALID_GPA, any VMREAD sets the ALU flags for VMfailInvalid.
> 		 */
> 		if (vmx->nested.current_vmptr == INVALID_GPA ||
> 		    (is_guest_mode(vcpu) &&
> 		     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
> 			return nested_vmx_failInvalid(vcpu);
>
> 		offset = vmcs12_field_offset(field);
> 		if (offset < 0)
> 			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
>
> 		if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
> 			copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
>
> 		/* Read the field, zero-extended to a u64 value */
> 		value = vmcs12_read_any(vmcs12, field, offset);
> 	} else {
> 		/*
> 		 * <snarky comment about Hyper-V>
> 		 */
> 		if (WARN_ON_ONCE(is_guest_mode(vcpu))
> 			return nested_vmx_failInvalid(vcpu);
>
> 		offset = evmcs_field_offset(field, NULL);
> 		if (offset < 0)
> 			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
>
> 		/* Read the field, zero-extended to a u64 value */
> 		value = evmcs_read_any(vmx->nested.hv_evmcs, field, offset);
> 	}
>

-- 
Vitaly

