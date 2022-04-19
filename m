Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE4F5072AA
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 18:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354402AbiDSQKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 12:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354396AbiDSQKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 12:10:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9DCA026546
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 09:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650384482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lsj8R7ls2S1n9AIL4pyf3g3lvLoo8izrM3SjiEav494=;
        b=Y+0kJLYDK/7vXDjBKhrI6oNcgXCkklIMk6Jg3ooj3W9BuwgmfiD5JCrA46+UYR2fTz+osO
        b/+la0u2UxPP/bZ0yl+V7SDNMCjraDAT+IB6jwq4qhWLQLvQXOnt9FOo+XYadElCZbPcZt
        GPLjNOFNKGW5E8gnqzOV9/HVuFlp5Y0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-VIy7cjpoP2iu3xzLMrW_-A-1; Tue, 19 Apr 2022 12:08:01 -0400
X-MC-Unique: VIy7cjpoP2iu3xzLMrW_-A-1
Received: by mail-wr1-f70.google.com with SMTP id v9-20020adfc409000000b002079e379921so2030706wrf.5
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 09:08:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Lsj8R7ls2S1n9AIL4pyf3g3lvLoo8izrM3SjiEav494=;
        b=KaOsLe0qktjurbhloW3VXGtNlRYjw2RfWnNII7QwNZDck4O4F300CvWPNJYdXn3aQL
         G7E1EdXr7F2noyTozLepFaGcpaMoyvG8d7Efmxy7NYPnCZl34EiQ3WhTF7KpOyuvwwle
         UG3jd0SEmEZwcrE2Ob8PXrTCg2TslpzsbBi81Xa7drQ+unTyPJg6Kt+gtcgl0hWAuZlS
         SluX5cKvEIkqxAEG7Qh6XOPkUJfFNdJycBOu1wi8HFzplhPvyR3Xtu6SMKgHYOYEtUYf
         5SeTJ8XAFuyMXjU2ty623Zwo5BArbYVyzsHCjfVXpweIlCkmi//vb0U0C6pw2IQxutfm
         bN9w==
X-Gm-Message-State: AOAM533ULD2wFo0xKbB8mGvfujl5yq5VeW71mMe6LRHZzyoREqYZLg4r
        KOr8tIZNos3ql7xLJOAa2/Y4EF60j/VnBq2aC3lZSVi0DNt1S/PvnCM4rmF5ByfnUXf/p00B6fr
        9ShqAB1OEBCr8
X-Received: by 2002:a05:6000:1689:b0:20a:a10b:1f4b with SMTP id y9-20020a056000168900b0020aa10b1f4bmr4871071wrd.650.1650384479894;
        Tue, 19 Apr 2022 09:07:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfbc5CED4D2MkAFgQ8SB69R23Rm6LI4SMQzgItbiPzpWiKyQFMrot7UNRiR0ELimp8VPS/bQ==
X-Received: by 2002:a05:6000:1689:b0:20a:a10b:1f4b with SMTP id y9-20020a056000168900b0020aa10b1f4bmr4871058wrd.650.1650384479683;
        Tue, 19 Apr 2022 09:07:59 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l14-20020adffe8e000000b00207af9cdd90sm12668032wrr.39.2022.04.19.09.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 09:07:59 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Anton Romanov <romanton@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
In-Reply-To: <Yl7XmmmuAZzNYiKq@google.com>
References: <20220414183127.4080873-1-romanton@google.com>
 <Ylh3HNlcJd8+P+em@google.com> <877d7l5xdc.fsf@redhat.com>
 <Yl7XmmmuAZzNYiKq@google.com>
Date:   Tue, 19 Apr 2022 18:07:58 +0200
Message-ID: <87o80x3vkx.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Apr 19, 2022, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > +Vitaly
>> >
>> > On Thu, Apr 14, 2022, Anton Romanov wrote:
>> 
>> ...
>> 
>> >> @@ -8646,9 +8659,12 @@ static void tsc_khz_changed(void *data)
>> >>  	struct cpufreq_freqs *freq = data;
>> >>  	unsigned long khz = 0;
>> >>  
>> >> +	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
>> >> +		return;
>> >
>> > Vitaly,
>> >
>> > The Hyper-V guest code also sets cpu_tsc_khz, should we WARN if that notifier is
>> > invoked and Hyper-V told us there's a constant TSC?
>> >
>> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> > index ab336f7c82e4..ca8e20f5ffc0 100644
>> > --- a/arch/x86/kvm/x86.c
>> > +++ b/arch/x86/kvm/x86.c
>> > @@ -8701,6 +8701,8 @@ static void kvm_hyperv_tsc_notifier(void)
>> >         struct kvm *kvm;
>> >         int cpu;
>> >
>> > +       WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_CONSTANT_TSC));
>> > +
>> >         mutex_lock(&kvm_lock);
>> >         list_for_each_entry(kvm, &vm_list, vm_list)
>> >                 kvm_make_mclock_inprogress_request(kvm);
>> >
>> 
>> (apologies for the delayed reply)
>> 
>> No, I think Hyper-V's "Reenlightenment" feature overrides (re-defines?)
>> X86_FEATURE_CONSTANT_TSC. E.g. I've checked a VM on E5-2667 v4
>> (Broadwell) CPU with no TSC scaling. This VM has 'constant_tsc' and will
>> certainly get reenlightenment irq on migration.
>
> Ooh, so that a VM with a constant TSC be live migrated to another system with a
> constant, but different, TSC.  Does the below look correct as fixup for this patch?
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ab336f7c82e4..a944e4ba5532 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8708,10 +8708,18 @@ static void kvm_hyperv_tsc_notifier(void)
>         /* no guest entries from this point */
>         hyperv_stop_tsc_emulation();
>
> -       /* TSC frequency always matches when on Hyper-V */
> -       for_each_present_cpu(cpu)
> -               per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
> -       kvm_max_guest_tsc_khz = tsc_khz;
> +       /*
> +        * TSC frequency always matches when on Hyper-V.  Skip the updates if
> +        * the TSC is "officially" constant, in which case KVM doesn't use the
> +        * per-CPU and max variables.  Note, the notifier can still fire with
> +        * a constant TSC, e.g. if this VM (KVM is a Hyper-V guest) is migrated
> +        * to a system with a different TSC frequency.
> +        */
> +       if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
> +               for_each_present_cpu(cpu)
> +                       per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
> +               kvm_max_guest_tsc_khz = tsc_khz;
> +       }

Looks good for cpu_tsc_khz but I'm not particularly sure about
kvm_max_guest_tsc_khz.

AFAIU, kvm_max_guest_tsc_khz is normally only set when TSC scaling is
available (kvm_has_tsc_control) and Hyper-V wasn't exposing it as the
field was missing in Enlightened VMCS. The most recent version
(https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/datatypes/hv_vmx_enlightened_vmcs),
however, has 'TscMultiplier' so I guess it's possible now. (Note: eVMCS
version remains '1', just a few fields were added, interesting).

Another thing is why do we set kvm_max_guest_tsc_khz to 'tsc_khz' as
normally, this is the maximum possible guest-VM TSC frequency (see
kvm_arch_hardware_setup()). With reenlightenment, the VM can be migrated
to a host with different TSC frequency, this means the maximum possible
guest-VM TSC frequency may change. What do we do with L2 VM with
'unsupported' configurations after that?

TL;DR: I *think* we can drop kvm_max_guest_tsc_khz setting from
kvm_hyperv_tsc_notifier() for now as it a) doesn't seem to be needed for
non-tscscaling case and b) correct for the tsc-scaling case. I'll need
to investigate how recent Hyper-V versions work when CPU offers
TSC-scaling feature.

>
>         list_for_each_entry(kvm, &vm_list, vm_list) {
>                 __kvm_start_pvclock_update(kvm);
>

-- 
Vitaly

