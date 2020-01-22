Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC451459EA
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 17:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgAVQ34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 11:29:56 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22407 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbgAVQ34 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jan 2020 11:29:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579710595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6BGjEFlP6pk9AzCr9C2dlngFIJXwo7QBelNQ/yQKuPQ=;
        b=LVwIC2RCEbI4vlxv/NhglLmr/WWTfmAE0ztgYcUPFHfULrVbbCOOV9DzFY7src33I0Ps18
        4FzfggqDFOsIyy0UrNpvh4vXy92/MGZj3f2bXRT/zPVQRpglyT5K0K90kyfJsEpKiOxSci
        gPllc6rNH9HF17Q3t0E3JWQ9hD62e5I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-AFJfIFzSPGiBs1OnZDHKbA-1; Wed, 22 Jan 2020 11:29:52 -0500
X-MC-Unique: AFJfIFzSPGiBs1OnZDHKbA-1
Received: by mail-wm1-f69.google.com with SMTP id l11so1748619wmi.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 08:29:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6BGjEFlP6pk9AzCr9C2dlngFIJXwo7QBelNQ/yQKuPQ=;
        b=kFT1QutNQQVavcRAhs9CP4MtOjGZQpgYZnzOyaFMytA5Uh7tThdsHfg39o2cINFGTp
         Tp8jAmpg+B51IjkY1qoixSRBNz0GIw5OebUTf7xWxxFr0Tvf2xalpFQyrABDXtMtviUa
         GuiqeVg6D8aQenoAK09OTdmH5QIhWYbItU9Xh5A0LcfzONLIOdrMDHDbLBh6uH0JdGfm
         sbQmCbAvl1zCVYshoK2pUxQGex1rF8pJwwT1BYEv8aECvETTJ5t2b8aIBvHLehCmb6lR
         vz4cxgz6czwqM41FXp72chku7/cGT4oc+sxAnYs9JHil83Wy49g6r6bGD2ekfHsXdUSO
         kWWQ==
X-Gm-Message-State: APjAAAUVtpEMRCn41tLj3GgE/09G4Y9c2uFyvomITtaGGiDt3xKXmIDI
        m9Et9zNT2bCbvA1pgbLWd3SXmj/ZGzJkqow7yBTdbZuHVrc5saSiWnWHzn+W+J2OsZBkCh0eVmN
        HzEo7yG+Y8PAN
X-Received: by 2002:a1c:4d18:: with SMTP id o24mr3757544wmh.35.1579710591507;
        Wed, 22 Jan 2020 08:29:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqxJ9K+QUU3PyMuDPQmAXoLfW9PNaH+1/vdD5DvvoouU9WHRc25Mbc4JtVXKf0S7RK9ZS+ZKmg==
X-Received: by 2002:a1c:4d18:: with SMTP id o24mr3757517wmh.35.1579710591259;
        Wed, 22 Jan 2020 08:29:51 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id v3sm57516171wru.32.2020.01.22.08.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 08:29:50 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()
In-Reply-To: <20200122155108.GA7201@linux.intel.com>
References: <20200115171014.56405-1-vkuznets@redhat.com> <20200115171014.56405-3-vkuznets@redhat.com> <6c4bdb57-08fb-2c2d-9234-b7efffeb72ed@redhat.com> <20200122054724.GD18513@linux.intel.com> <9c126d75-225b-3b1b-d97a-bcec1f189e02@redhat.com> <87eevrsf3s.fsf@vitty.brq.redhat.com> <20200122155108.GA7201@linux.intel.com>
Date:   Wed, 22 Jan 2020 17:29:49 +0100
Message-ID: <87blqvsbcy.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Wed, Jan 22, 2020 at 04:08:55PM +0100, Vitaly Kuznetsov wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>> 
>> > On 22/01/20 06:47, Sean Christopherson wrote:
>> >>> Yes, it most likely is and it would be nice if Microsoft fixed it, but I
>> >>> guess we're stuck with it for existing Windows versions.  Well, for one
>> >>> we found a bug in Hyper-V and not the converse. :)
>> >>>
>> >>> There is a problem with this approach, in that we're stuck with it
>> >>> forever due to live migration.  But I guess if in the future eVMCS v2
>> >>> adds an apic_address field we can limit the hack to eVMCS v1.  Another
>> >>> possibility is to use the quirks mechanism but it's overkill for now.
>> >>>
>> >>> Unless there are objections, I plan to apply these patches.
>> >> Doesn't applying this patch contradict your earlier opinion?  This patch
>> >> would still hide the affected controls from the guest because the host
>> >> controls enlightened_vmcs_enabled.
>> >
>> > It does.  Unfortunately the key sentence is "we're stuck with it for
>> > existing Windows versions". :(
>
> Ah, I didn't understand what "it" referred to :-)
>
>> >> Rather than update vmx->nested.msrs or filter vmx_get_msr(), what about
>> >> manually adding eVMCS consistency checks on the disallowed bits and handle
>> >> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES as a one-off case by simply
>> >> clearing it from the eVMCS?  Or alternatively, squashing all the disallowed
>> >> bits.
>> >
>> > Hmm, that is also a possibility.  It's a very hacky one, but I guess
>> > adding APIC virtualization to eVMCS would require bumping the version to
>> > 2.  Vitaly, what do you think?
>> 
>> As I already replied to Sean I like the idea to filter out unsupported
>> controls from eVMCS but unfortunately it doesn't work: Hyper-V actually
>> expects APIC virtualization to work when it enables
>> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES (I have no idea how without
>> apic_access_addr field but). I checked and at least Hyper-V 2016 doesn't
>> boot (when >1 vCPU).
>
> Nice.
>
> I still don't see what we gain from applying this patch.  Once eVMCS is
> enabled by userspace, which presumably happens before the guest is launched,
> the guest will see the eVMCS-unfriendly controls as being unsupported, both
> for eVMCS and regular VMCS.  AFAICT, we're adding a fairly ugly hack to KVM
> just so that KVM can lie to userspace about what controls will be exposed to
> the guest.
>
> Can we extend the API to use cap->args[1] to control whether or not the
> unsupported controls are removed from vmx->nested.msrs?  Userspace could
> pass '1' to leave the controls untouched and then surgically hide the
> controls that the guest is too dumb to know it shouldn't use by writing the
> appropriate MSRs.  Assuming existing userspace is expected/required to zero
> out args[1..3], this would be fully backwards compatible.

Yes, in case we're back to the idea to filter things out in QEMU we can
do this. What I don't like is that every other userspace which decides
to enable eVMCS will have to perform the exact same surgery as in case
it sets allow_unsupported_controls=0 it'll have to know (hardcode) the
filtering (or KVM_SET_MSRS will fail) and in case it opts for
allow_unsupported_controls=1 Windows guests just won't boot without the
filtering.

It seems to be 1:1, eVMCSv1 requires the filter.

>
>
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 72359709cdc1..241a769be738 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -346,8 +346,8 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
>         return 0;
>  }
>
> -int nested_enable_evmcs(struct kvm_vcpu *vcpu,
> -                       uint16_t *vmcs_version)
> +int nested_enable_evmcs(struct kvm_vcpu *vcpu, uint16_t *vmcs_version,
> +                       bool allow_unsupported_controls)

Personally, I'd call it 'keep_unsupported_controls'.

>  {
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
>         bool evmcs_already_enabled = vmx->nested.enlightened_vmcs_enabled;
> @@ -358,7 +358,7 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>                 *vmcs_version = nested_get_evmcs_version(vcpu);
>
>         /* We don't support disabling the feature for simplicity. */
> -       if (evmcs_already_enabled)
> +       if (evmcs_already_enabled || allow_unsupported_controls)
>                 return 0;
>
>         vmx->nested.msrs.pinbased_ctls_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0cccc52e2d0a..5e1b8d51277b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4005,7 +4005,8 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>         case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
>                 if (!kvm_x86_ops->nested_enable_evmcs)
>                         return -ENOTTY;
> -               r = kvm_x86_ops->nested_enable_evmcs(vcpu, &vmcs_version);
> +               r = kvm_x86_ops->nested_enable_evmcs(vcpu, &vmcs_version,
> +                                                    cap->args[1]);
>                 if (!r) {
>                         user_ptr = (void __user *)(uintptr_t)cap->args[0];
>                         if (copy_to_user(user_ptr, &vmcs_version,
>

-- 
Vitaly

