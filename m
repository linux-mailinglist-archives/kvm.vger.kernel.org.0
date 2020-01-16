Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D32413E2D6
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 17:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732459AbgAPQ6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 11:58:39 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46891 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733222AbgAPQ5l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jan 2020 11:57:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579193859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NL2NSi1XWLGU3r+xrG79oV00EN+7idfCniN3jKXSuTs=;
        b=P5uqVFk4sAQSdYZHMe1Iczzmj6JgMmXfHnQn3JcD+vPbS4Cqo83OVJzSfhR259/ss9Ufuq
        +O53cOPxzZ0YeabF/WKxmLAGT6I2eKQBDYOq1gozNmHBJVdiDyB+wx+B4WNmEiq6wanwC1
        i0LLSaubAXmsq4U8ik/tuS2GR+jdboQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-6Fd8WRHhOVeSYI76B0QUXg-1; Thu, 16 Jan 2020 11:57:35 -0500
X-MC-Unique: 6Fd8WRHhOVeSYI76B0QUXg-1
Received: by mail-wr1-f72.google.com with SMTP id y7so9501661wrm.3
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 08:57:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NL2NSi1XWLGU3r+xrG79oV00EN+7idfCniN3jKXSuTs=;
        b=iSLZlGSB0aA2RZ4syDN0R1mpB2zZTk7Zbtk6uGoWj+AUuUfMpU8+yDQYxSHHNl0nI7
         WhvzBr34IU3vMxSCKqsFe9hkUbCdMd/fk6cKi3/4pD/qazEpIODluhPNZnOc7r2OjwPf
         yVE85dzF3L3sLYisbciWOat0FBdLdDMb9fmMKSbr+fp8Oe1LmtXciK4eO7WF+r96UQwX
         +ZWuAgAddIw6SI+RI5FahD5NNeE+alq6dkosBhjYmWZPB7FlOkogHqXs34I7FmlseyU7
         AlEOyihFO3phjIYM8p2dhp4y1zRLYKH9UWqnSr4yhLc1X9sa0Zna7uroj7yWQJT3OV6P
         aQYw==
X-Gm-Message-State: APjAAAXi45YH4N+SWzzeo6/kkg4xDn7gRE0UwBRth6jjc8THoLQelGKa
        oYcBaNDk639izKiRh3aq4fBx5P2H3Vt2cElgI+e27BcONuc1JNcszqrPjZhtp429VykyWpP2RK5
        u8FIJPtIpUycm
X-Received: by 2002:a05:600c:1003:: with SMTP id c3mr8949wmc.120.1579193853995;
        Thu, 16 Jan 2020 08:57:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqxgb+xpT3o5iuo3KQIaczTCpPBwxe0nKRKV4XX4+9W7V2XQaL7x9/ponSvixwnMk5Cph4hYxg==
X-Received: by 2002:a05:600c:1003:: with SMTP id c3mr8935wmc.120.1579193853782;
        Thu, 16 Jan 2020 08:57:33 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n189sm1680407wme.33.2020.01.16.08.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 08:57:33 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Liran Alon <liran.alon@oracle.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()
In-Reply-To: <20200116161928.GC20561@linux.intel.com>
References: <20200115171014.56405-1-vkuznets@redhat.com> <20200115171014.56405-3-vkuznets@redhat.com> <20200115232738.GB18268@linux.intel.com> <C6C4003E-0ADD-42A5-A580-09E06806E160@oracle.com> <877e1riy1o.fsf@vitty.brq.redhat.com> <20200116161928.GC20561@linux.intel.com>
Date:   Thu, 16 Jan 2020 17:57:31 +0100
Message-ID: <87o8v3gwzo.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Thu, Jan 16, 2020 at 09:51:47AM +0100, Vitaly Kuznetsov wrote:
>> Liran Alon <liran.alon@oracle.com> writes:
>> 
>> >> On 16 Jan 2020, at 1:27, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
>> >> 
>> >> On Wed, Jan 15, 2020 at 06:10:13PM +0100, Vitaly Kuznetsov wrote:
>> >>> With fine grained VMX feature enablement QEMU>=4.2 tries to do KVM_SET_MSRS
>> >>> with default (matching CPU model) values and in case eVMCS is also enabled,
>> >>> fails.
>> >> 
>> >> As in, Qemu is blindly throwing values at KVM and complains on failure?
>> >> That seems like a Qemu bug, especially since Qemu needs to explicitly do
>> >> KVM_CAP_HYPERV_ENLIGHTENED_VMCS to enable eVMCS.
>> >
>> > See: https://patchwork.kernel.org/patch/11316021/
>> > For more context.
>> 
>> Ya,
>> 
>> while it would certainly be possible to require that userspace takes
>> into account KVM_CAP_HYPERV_ENLIGHTENED_VMCS (which is an opt-in) when
>> doing KVM_SET_MSRS there doesn't seem to be an existing (easy) way to
>> figure out which VMX controls were filtered out after enabling
>> KVM_CAP_HYPERV_ENLIGHTENED_VMCS: KVM_GET_MSRS returns global
>> &vmcs_config.nested values for VMX MSRs (vmx_get_msr_feature()).
>
> Ah, I was looking at the call to vmx_get_vmx_msr(&vmx->nested.msrs, ...)
> in vmx_get_msr().
>
> Why not just do this in Qemu?  IMO that's not a major ask, e.g. Qemu is
> doing a decent amount of manual adjustment anyways.  And Qemu isn't even
> using the result of KVM_GET_MSRS so I don't think it's fair to say this is
> solely KVM's fault.
>
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 1d10046a6c..6545bb323e 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -2623,6 +2623,23 @@ static void kvm_msr_entry_add_vmx(X86CPU *cpu, FeatureWordArray f)
>               MSR_VMX_EPT_UC | MSR_VMX_EPT_WB : 0);
>      uint64_t fixed_vmx_ept_vpid = kvm_vmx_ept_vpid & fixed_vmx_ept_mask;
>
> +    /* Hyper-V's eVMCS does't support certain features, adjust accordingly. */
> +    if (cpu->hyperv_evmcs) {
> +        f[FEAT_VMX_PINBASED_CTLS] &= ~(VMX_PIN_BASED_VMX_PREEMPTION_TIMER |
> +                                       VMX_PIN_BASED_POSTED_INTR);
> +        f[FEAT_VMX_EXIT_CTLS] &= ~VMX_VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> +        f[FEAT_VMX_ENTRY_CTLS] &= ~VMX_VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> +        f[FEAT_VMX_SECONDARY_CTLS] &= ~(VMX_SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
> +                                        VMX_SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
> +                                        VMX_SECONDARY_EXEC_APIC_REGISTER_VIRT |
> +                                        VMX_SECONDARY_EXEC_ENABLE_PML |
> +                                        VMX_SECONDARY_EXEC_ENABLE_VMFUNC |
> +                                        VMX_SECONDARY_EXEC_SHADOW_VMCS |
> +                                        /* VMX_SECONDARY_EXEC_TSC_SCALING | */
> +                                        VMX_SECONDARY_EXEC_PAUSE_LOOP_EXITING);
> +        f[FEAT_VMX_VMFUNC]         &= ~MSR_VMX_VMFUNC_EPT_SWITCHING;
> +    }
> +
>      kvm_msr_entry_add(cpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS,
>                        make_vmx_msr_value(MSR_IA32_VMX_TRUE_PROCBASED_CTLS,
>                                           f[FEAT_VMX_PROCBASED_CTLS]));
>

I accuse you of not reading my PATCH0 :-)

https://lists.nongnu.org/archive/html/qemu-devel/2020-01/msg00123.html
does exactly this :-) 

P.S. I expect Paolo to comment on which hack he hates less :-)

-- 
Vitaly

