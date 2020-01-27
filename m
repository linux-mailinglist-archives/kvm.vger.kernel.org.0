Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 113D514A753
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 16:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbgA0Pie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 10:38:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44435 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729085AbgA0Pie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 10:38:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580139512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yfROaJ9u/6MLmu7Wj6cHq2rH+Az2BoI1cHZ9b2JYC3Y=;
        b=V9qRsMZBG83tknA6x3HF9JXnGWupG/rf5mEb4sDr5zASpHic8OqyjeQb1Pp0QCgZ3EWM3X
        VSQVNEnHk7jwRa3xRUCiONsEfJVtfylgUw1C8bd6nwA+LJv8wCYvOGnwh7zjFDjJ+w/zH1
        6W4Rmm+IMq7cFBJ8iE3aBgEooFS0RQw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-6pb4-k7vMYq4Mm8QcuhaFg-1; Mon, 27 Jan 2020 10:38:31 -0500
X-MC-Unique: 6pb4-k7vMYq4Mm8QcuhaFg-1
Received: by mail-wr1-f70.google.com with SMTP id j4so6240863wrs.13
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2020 07:38:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yfROaJ9u/6MLmu7Wj6cHq2rH+Az2BoI1cHZ9b2JYC3Y=;
        b=DAXRUvzmo8fkEH2MJ4QFDs2BZ9iP6tpIJ58JVM/fbJquJ6Nm8WfLbGzK6ieo+pKgIz
         MQSsLam3rKrighe67X+XO4AotNK6TIC9CJDLfJ5aaeFCg1BU0BYIIyHOqgnVPsxPgk53
         TbfZNuoR34njDmHn15FQJNctv7DFrx7QSGhD6s9NF1upBWxEe7SYT+79qiG+epKWwGAl
         jqeKo2yPMKUoJGaIIOtOmrSlEm8rt/L+WjE4HDLKIeztpSGLK4OMVWy7qreNNsQzv01/
         waUR+9hO4onQjJ1Jz0ws5icZUyqiQl9r7+QRxxSgG/0Pukc6m4ZFH8OCT3Kk82ZHir1U
         C69g==
X-Gm-Message-State: APjAAAX0OMEKwGXB4+aIxHch58VmK/fAGH8SE2pHI6y+2qR3+kUQlIfp
        nX3O1lPTXI8/LWcbg9kHrcVR+S8faWem4slyQpY/FKgFYXY4S6Ojan3UuR2WYAL2DP3mVoNFmrb
        7tK6mjvYFy6kv
X-Received: by 2002:a5d:630c:: with SMTP id i12mr23196141wru.350.1580139509757;
        Mon, 27 Jan 2020 07:38:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqzFOPhMYVCz4FL0ok/+AfJ9ysrDpwqwB+2XdoqbU49sV5UQBFJf+PQ94Ss0yKTbms7poqnO0g==
X-Received: by 2002:a5d:630c:: with SMTP id i12mr23196109wru.350.1580139509427;
        Mon, 27 Jan 2020 07:38:29 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5sm22170306wrh.5.2020.01.27.07.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 07:38:28 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()
In-Reply-To: <20200124172512.GJ2109@linux.intel.com>
References: <20200115171014.56405-3-vkuznets@redhat.com> <6c4bdb57-08fb-2c2d-9234-b7efffeb72ed@redhat.com> <20200122054724.GD18513@linux.intel.com> <9c126d75-225b-3b1b-d97a-bcec1f189e02@redhat.com> <87eevrsf3s.fsf@vitty.brq.redhat.com> <20200122155108.GA7201@linux.intel.com> <87blqvsbcy.fsf@vitty.brq.redhat.com> <f15d9e98-25e9-2031-2db5-6aaa6c78c0eb@redhat.com> <87zheer0si.fsf@vitty.brq.redhat.com> <87lfpyq9bk.fsf@vitty.brq.redhat.com> <20200124172512.GJ2109@linux.intel.com>
Date:   Mon, 27 Jan 2020 16:38:27 +0100
Message-ID: <875zgwnc3w.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Thu, Jan 23, 2020 at 08:09:03PM +0100, Vitaly Kuznetsov wrote:
>> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>> 
>> > Paolo Bonzini <pbonzini@redhat.com> writes:
>> >
>> >> On 22/01/20 17:29, Vitaly Kuznetsov wrote:
>> >>> Yes, in case we're back to the idea to filter things out in QEMU we can
>> >>> do this. What I don't like is that every other userspace which decides
>> >>> to enable eVMCS will have to perform the exact same surgery as in case
>> >>> it sets allow_unsupported_controls=0 it'll have to know (hardcode) the
>> >>> filtering (or KVM_SET_MSRS will fail) and in case it opts for
>> >>> allow_unsupported_controls=1 Windows guests just won't boot without the
>> >>> filtering.
>> >>> 
>> >>> It seems to be 1:1, eVMCSv1 requires the filter.
>> >>
>> >> Yes, that's the point.  It *is* a hack in KVM, but it is generally
>> >> preferrable to have an easier API for userspace, if there's only one way
>> >> to do it.
>> >>
>> >> Though we could be a bit more "surgical" and only remove
>> >> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES---thus minimizing the impact on
>> >> non-eVMCS guests.  Vitaly, can you prepare a v2 that does that and adds
>> >> a huge "hack alert" comment that explains the discussion?
>> >
>> > Yes, sure. I'd like to do more testing to make sure filtering out
>> > SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES is enough for other Hyper-V
>> > versions too (who knows how many bugs are there :-)
>> 
>> ... and the answer is -- more than one :-)
>> 
>> I've tested Hyper-V 2016/2019 BIOS and UEFI-booted and the minimal
>> viable set seems to be:
>> 
>> MSR_IA32_VMX_PROCBASED_CTLS2: 
>> 	~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES
>> 
>> MSR_IA32_VMX_ENTRY_CTLS/MSR_IA32_VMX_TRUE_ENTRY_CTLS:
>> 	~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL
>> 
>> MSR_IA32_VMX_EXIT_CTLS/MSR_IA32_VMX_TRUE_EXIT_CTLS:
>> 	~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL
>>  
>> with these filtered out all 4 versions are at least able to boot with >1
>> vCPU and run a nested guest (different from Windows management
>> partition).
>> 
>> This still feels a bit fragile as who knows under which circumstances
>> Hyper-V might want to enable additional (missing) controls.
>
> No strong opinion, I'm good either way.
>
>> If there are no objections and if we still think it would be beneficial
>> to minimize the list of controls we filter out (and not go with the full
>> set like my RFC suggests), I'll prepare v2. (v1, actually, this was RFC).
>
> One last idea, can we keep the MSR filtering as is and add the hack in
> vmx_restore_control_msr()?  That way the (userspace) host and guest see
> the same values when reading the affected MSRs, and eVMCS wouldn't need
> it's own hook to do consistency checks.

Yes but (if I'm not mistaken) we'll have then to keep the filtering we
currently do in nested_enable_evmcs(): if userspace doesn't do
KVM_SET_MSR for VMX MSRs (QEMU<4.2) then the filtering in
vmx_restore_control_msr() won't happen and the guest will see the
unfiltered set of controls...

>
> @@ -1181,28 +1181,38 @@ static int
>  vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
>  {
>         u64 supported;
> -       u32 *lowp, *highp;
> +       u32 *lowp, *highp, evmcs_unsupported;
>
>         switch (msr_index) {
>         case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
>                 lowp = &vmx->nested.msrs.pinbased_ctls_low;
>                 highp = &vmx->nested.msrs.pinbased_ctls_high;
> +               if (vmx->nested.enlightened_vmcs_enabled)
> +                       evmcs_unsupported = EVMCS1_UNSUPPORTED_PINCTRL;
>                 break;
>         case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
>                 lowp = &vmx->nested.msrs.procbased_ctls_low;
>                 highp = &vmx->nested.msrs.procbased_ctls_high;
> +               if (vmx->nested.enlightened_vmcs_enabled)
> +                       evmcs_unsupported = 0;
>                 break;
>         case MSR_IA32_VMX_TRUE_EXIT_CTLS:
>                 lowp = &vmx->nested.msrs.exit_ctls_low;
>                 highp = &vmx->nested.msrs.exit_ctls_high;
> +               if (vmx->nested.enlightened_vmcs_enabled)
> +                       evmcs_unsupported = EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
>                 break;
>         case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
>                 lowp = &vmx->nested.msrs.entry_ctls_low;
>                 highp = &vmx->nested.msrs.entry_ctls_high;
> +               if (vmx->nested.enlightened_vmcs_enabled)
> +                       evmcs_unsupported = EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
>                 break;
>         case MSR_IA32_VMX_PROCBASED_CTLS2:
>                 lowp = &vmx->nested.msrs.secondary_ctls_low;
>                 highp = &vmx->nested.msrs.secondary_ctls_high;
> +               if (vmx->nested.enlightened_vmcs_enabled)
> +                       evmcs_unsupported = EVMCS1_UNSUPPORTED_2NDEXEC;
>                 break;
>         default:
>                 BUG();
> @@ -1210,6 +1220,9 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
>
>         supported = vmx_control_msr(*lowp, *highp);
>
> +       /* HACK! */
> +       data &= ~(u64)evmcs_unsupported << 32;
> +
>         /* Check must-be-1 bits are still 1. */
>         if (!is_bitwise_subset(data, supported, GENMASK_ULL(31, 0)))
>

-- 
Vitaly

