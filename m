Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B781DBAEE
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgETRPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:15:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22608 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726548AbgETRPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 13:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589994950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OEyJRilrGxuJXOTcMvcWPZ35/1jpr23zXv+p55lybnA=;
        b=bVhXeNQVCuB/ZgIdy93a3ruopbXi6hh8wLoYZ86VFQ/87mGpj7ydcUa6JkwDiGMS0BbZYZ
        L+WynT27/CIpoR7/RQoBuJ8r6Dpa8lNxszJWm9caED3CYmUCB5XG5Q2ku47Vn2UzEM8BRx
        n3qZc72U/f0tYWkHZOyiGg9IWRdETOk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-Dpf44b4GOW6_11-q83WEzA-1; Wed, 20 May 2020 13:15:49 -0400
X-MC-Unique: Dpf44b4GOW6_11-q83WEzA-1
Received: by mail-ed1-f69.google.com with SMTP id h21so1523613edj.19
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 10:15:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=OEyJRilrGxuJXOTcMvcWPZ35/1jpr23zXv+p55lybnA=;
        b=sa4Yh9Evoa3VpCxb/Pl5HeOIwWgQSPy8VWgxgQCkFQaD+VWwwLSO5VTOOFS1Fnx4d9
         b48SQFDgvN01cRxbEqCR3XkQM0isLTp7h75ffkZYK2iRhTZLNFqSqGi9IuydRxY9W0U+
         IWAybKg5KCf2ufHbLvfUvctK6zxgCYVDWIJFLSm/emse9tCtxDOAgbENuewj8IFnVaxf
         stxn7E0xaBf7/nhpjQJ2eKBxBQQ4Q7FC0uyfQ3souoo3/ZHJfSrV2ir05HlOFxot/Uxt
         5A4YWOtuaJT/Cl9yk28/oS/24uxutE5YhUW4Tcft9ERbzhUSCMgEI2gdbPfohfMk3N54
         8/ow==
X-Gm-Message-State: AOAM533a8bUNNSt49B8t81xiqmSxmk7dcYX7SEe5uqD4+0V7Vgw8iFnb
        RkBwjErH40CeIJJPCqBvZPv09UnPkU0vf7Vi3zxoolxbunSaoYNa7zTiFSUafoL9qXQPzYzewPO
        IEjawVZTLPTgw
X-Received: by 2002:a17:906:f75b:: with SMTP id jp27mr76830ejb.141.1589994947879;
        Wed, 20 May 2020 10:15:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpCdLX5itcas/cFUfuj2oJYMf6yRY6aXmA8ntcidBs0QcXg28m/fOk+cVMMuG/y4tfPHRcaw==
X-Received: by 2002:a17:906:f75b:: with SMTP id jp27mr76814ejb.141.1589994947639;
        Wed, 20 May 2020 10:15:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c7sm2308838edj.54.2020.05.20.10.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 10:15:46 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL unconditionally
In-Reply-To: <0c1a0c81bbdcfaf4ae9af545f4a38439b1a56d11.camel@redhat.com>
References: <20200520160740.6144-1-mlevitsk@redhat.com> <20200520160740.6144-3-mlevitsk@redhat.com> <874ksatvkr.fsf@vitty.brq.redhat.com> <0c1a0c81bbdcfaf4ae9af545f4a38439b1a56d11.camel@redhat.com>
Date:   Wed, 20 May 2020 19:15:45 +0200
Message-ID: <87sgfusf26.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Wed, 2020-05-20 at 18:33 +0200, Vitaly Kuznetsov wrote:
>> Maxim Levitsky <mlevitsk@redhat.com> writes:
>> 
>> > This msr is only available when the host supports WAITPKG feature.
>> > 
>> > This breaks a nested guest, if the L1 hypervisor is set to ignore
>> > unknown msrs, because the only other safety check that the
>> > kernel does is that it attempts to read the msr and
>> > rejects it if it gets an exception.
>> > 
>> > Fixes: 6e3ba4abce KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
>> > 
>> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>> > ---
>> >  arch/x86/kvm/x86.c | 4 ++++
>> >  1 file changed, 4 insertions(+)
>> > 
>> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> > index fe3a24fd6b263..9c507b32b1b77 100644
>> > --- a/arch/x86/kvm/x86.c
>> > +++ b/arch/x86/kvm/x86.c
>> > @@ -5314,6 +5314,10 @@ static void kvm_init_msr_list(void)
>> >  			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
>> >  			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>> >  				continue;
>> > +			break;
>> > +		case MSR_IA32_UMWAIT_CONTROL:
>> > +			if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
>> > +				continue;
>> 
>> I'm probably missing something but (if I understand correctly) the only
>> effect of dropping MSR_IA32_UMWAIT_CONTROL from msrs_to_save would be
>> that KVM userspace won't see it in e.g. KVM_GET_MSR_INDEX_LIST. But why
>> is this causing an issue? I see both vmx_get_msr()/vmx_set_msr() have
>> 'host_initiated' check:
>> 
>>        case MSR_IA32_UMWAIT_CONTROL:
>>                 if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
>>                         return 1;
>
> Here it fails like that:
>
> 1. KVM_GET_MSR_INDEX_LIST returns this msrs, and qemu notes that
>    it is supported in 'has_msr_umwait' global var
>
> 2. Qemu does kvm_arch_get/put_registers->kvm_get/put_msrs->ioctl(KVM_GET_MSRS)
>    and while doing this it adds MSR_IA32_UMWAIT_CONTROL to that msr list.
>    That reaches 'svm_get_msr', and this one knows nothing about MSR_IA32_UMWAIT_CONTROL.
>
> So the difference here is that vmx_get_msr not called at all.
> I can add this msr to svm_get_msr instead but that feels wrong since this feature
> is not yet supported on AMD.
> When AMD adds support for this feature, then the VMX specific code can be moved to
> kvm_get_msr_common I guess.
>
>

Oh, SVM, I missed that completely) 

>
>> 
>> so KVM userspace should be able to read/write this MSR even when there's
>> no hardware support for it. Or who's trying to read/write it?
>> 
>> Also, kvm_cpu_cap_has() check is not equal to vmx_has_waitpkg() which
>> checks secondary execution controls.
>
> I was afraid that something like that will happen, but in this particular
> case we can only check CPUID support and if supported, the then it means
> we are dealing with intel system and thus vmx_get_msr will be called and
> ignore that msr.
>
> Calling vmx_has_waitpkg from the common code doesn't seem right, and besides,
> it checks the secondary controls which are set by the host and can change,
> at least in theory during runtime (I don't know if KVM does this).
>
> Note that if I now understand correctly, the 'host_initiated' means
> that MSR read/write is done by the host itself and not on behalf of the guest.

Yes, it does that. 

We have kvm_x86_ops.has_emulated_msr() mechanism, can we use it here?
E.g. completely untested

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 38f6aeefeb55..c19a9542e6c3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3471,6 +3471,8 @@ static bool svm_has_emulated_msr(int index)
        case MSR_IA32_MCG_EXT_CTL:
        case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
                return false;
+       case MSR_IA32_UMWAIT_CONTROL:
+               return false;
        default:
                break;
        }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d786c7d27ce5..f45153ef3b81 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1183,7 +1183,6 @@ static const u32 msrs_to_save_all[] = {
        MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
        MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
        MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
-       MSR_IA32_UMWAIT_CONTROL,
 
        MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
        MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
@@ -1266,6 +1265,7 @@ static const u32 emulated_msrs_all[] = {
        MSR_IA32_VMX_PROCBASED_CTLS2,
        MSR_IA32_VMX_EPT_VPID_CAP,
        MSR_IA32_VMX_VMFUNC,
+       MSR_IA32_UMWAIT_CONTROL,
 
        MSR_K7_HWCR,
        MSR_KVM_POLL_CONTROL,

-- 
Vitaly

