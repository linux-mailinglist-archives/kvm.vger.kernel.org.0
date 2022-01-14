Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF3248E6FB
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 09:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237541AbiANIzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 03:55:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22218 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229948AbiANIzl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 03:55:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642150540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UO215vY0TsZ7UGo51cf2geQhbDmO34SD1bUwZDInbqI=;
        b=Jhrwfc9oAxExFcRLG/DJWwBIKkbw13wSs7L2jS1HlgO5Oqv2j9KOqvvNhN7uyjio7NQczK
        FOH13btCervn1rE0sbRfR+7K/9Jazj/gEUwROyh2JO8+6QM0z/PeRiki0D87OCZ18ftWLt
        avPKogEG/aj8D8mnWPxltfp5mMu1sE4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-4TX-Bne7PRuLcC0H27vhTA-1; Fri, 14 Jan 2022 03:55:39 -0500
X-MC-Unique: 4TX-Bne7PRuLcC0H27vhTA-1
Received: by mail-wm1-f71.google.com with SMTP id v190-20020a1cacc7000000b0034657bb6a66so2039707wme.6
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 00:55:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UO215vY0TsZ7UGo51cf2geQhbDmO34SD1bUwZDInbqI=;
        b=kLWwNaMr3xyCPpI0ekUkkfaTeFE+RKT2YXBCf4aMZR30lg5piny8+nrCdbQkl+iosX
         IhWSibr4HrgsTCfvIQhlc0y9ow0q3DxM5tl7VPgqttayrwwvHUVXc5iB83NVXVYDCbEQ
         JM2KT1+cvVb3mZarA8jWqjFIoemjyPWPF/UTbvFsVAjtJQX+Lf9qb1QPkfIoiYynZE6R
         jTMkjxbnWANoR23WL43JItbKJllmfM1TNdZX6tFAV83F4kgjmg6mHwf3Jlymy18LTb47
         TjZZIUY6ABGhji7k3RQUR39m5Jqm4mCeeeVhQnm+a8iVSkzbUVX9+y4Qg5CWLF8/yD2a
         p05g==
X-Gm-Message-State: AOAM532QgtHBfRQ3UsCydNiRQwDzK3ZLTgab8thbSnIc4RR2t7952JKY
        Pf0ld6CJuTtnqnVhy2v6Ui1Rlby9klQnHbdqelWFj+36j+Ksvq63rq33LDuaxdzvZkQOpWnu8Gy
        +9XlGucg4vSvo
X-Received: by 2002:a1c:770b:: with SMTP id t11mr7386895wmi.61.1642150537726;
        Fri, 14 Jan 2022 00:55:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzIO5huFyW3FnXxDXwl3aS4/QSRgEkcnYKKgfAejE8iqE1Tc9WIb6Q1yxCQ6lkdhH96uPNJYA==
X-Received: by 2002:a1c:770b:: with SMTP id t11mr7386870wmi.61.1642150537479;
        Fri, 14 Jan 2022 00:55:37 -0800 (PST)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h10sm5961643wmh.0.2022.01.14.00.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 00:55:36 -0800 (PST)
Date:   Fri, 14 Jan 2022 09:55:35 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Message-ID: <20220114095535.0f498707@redhat.com>
In-Reply-To: <YeCowpPBEHC6GJ59@google.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
        <20211122175818.608220-3-vkuznets@redhat.com>
        <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
        <20211227183253.45a03ca2@redhat.com>
        <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
        <87mtkdqm7m.fsf@redhat.com>
        <20220103104057.4dcf7948@redhat.com>
        <YeCowpPBEHC6GJ59@google.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jan 2022 22:33:38 +0000
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Jan 03, 2022, Igor Mammedov wrote:
> > On Mon, 03 Jan 2022 09:04:29 +0100
> > Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >   
> > > Paolo Bonzini <pbonzini@redhat.com> writes:
> > >   
> > > > On 12/27/21 18:32, Igor Mammedov wrote:    
> > > >>> Tweaked and queued nevertheless, thanks.    
> > > >> it seems this patch breaks VCPU hotplug, in scenario:
> > > >> 
> > > >>    1. hotunplug existing VCPU (QEMU stores VCPU file descriptor in parked cpus list)
> > > >>    2. hotplug it again (unsuspecting QEMU reuses stored file descriptor when recreating VCPU)
> > > >> 
> > > >> RHBZ:https://bugzilla.redhat.com/show_bug.cgi?id=2028337#c11
> > > >>     
> > > >
> > > > The fix here would be (in QEMU) to not call KVM_SET_CPUID2 again. 
> > > > However, we need to work around it in KVM, and allow KVM_SET_CPUID2 if 
> > > > the data passed to the ioctl is the same that was set before.    
> > > 
> > > Are we sure the data is going to be *exactly* the same? In particular,
> > > when using vCPU fds from the parked list, do we keep the same
> > > APIC/x2APIC id when hotplugging? Or can we actually hotplug with a
> > > different id?  
> > 
> > If I recall it right, it can be a different ID easily.  
> 
> No, it cannot.  KVM doesn't provide a way for userspace to change the APIC ID of
> a vCPU after the vCPU is created.  x2APIC flat out disallows changing the APIC ID,
> and unless there's magic I'm missing, apic_mmio_write() => kvm_lapic_reg_write()
> is not reachable from userspace.
> 
> The only way for userspace to set the APIC ID is to change vcpu->vcpu_id, and that
> can only be done at KVM_VCPU_CREATE.
> 
> So, reusing a parked vCPU for hotplug must reuse the same APIC ID.  QEMU handles
> this by stashing the vcpu_id, a.k.a. APIC ID, when parking a vCPU, and reuses a
> parked vCPU if and only if it has the same APIC ID.  And because QEMU derives the
> APIC ID from topology, that means all the topology CPUID leafs must remain the
> same, otherwise the guest is hosed because it will send IPIs to the wrong vCPUs.

Indeed, I was wrong.
I just checked all cpu unplug history in qemu. It was introduced in qemu-2.7
and from the very beginning it did stash vcpu_id,
so there is no old QEMU that would re-plug VCPU with different apic_id.
Though tells us nothing about what other userspace implementations might do.

However, a problem of failing KVM_SET_CPUID2 during VCPU re-plug
is still there and re-plug will fail if KVM rejects repeated KVM_SET_CPUID2
even if ioctl called with exactly the same CPUID leafs as the 1st call.


>   static int do_kvm_destroy_vcpu(CPUState *cpu)
>   {
>     struct KVMParkedVcpu *vcpu = NULL;
> 
>     ...
> 
>     vcpu = g_malloc0(sizeof(*vcpu));
>     vcpu->vcpu_id = kvm_arch_vcpu_id(cpu); <=== stash the APIC ID when parking
>     vcpu->kvm_fd = cpu->kvm_fd;
>     QLIST_INSERT_HEAD(&kvm_state->kvm_parked_vcpus, vcpu, node);
> err:
>     return ret;
>   }
> 
>   static int kvm_get_vcpu(KVMState *s, unsigned long vcpu_id)
>   {
>     struct KVMParkedVcpu *cpu;
> 
>     QLIST_FOREACH(cpu, &s->kvm_parked_vcpus, node) {
>         if (cpu->vcpu_id == vcpu_id) {  <=== reuse if APIC ID matches
>             int kvm_fd;
> 
>             QLIST_REMOVE(cpu, node);
>             kvm_fd = cpu->kvm_fd;
>             g_free(cpu);
>             return kvm_fd;
>         }
>     }
> 
>     return kvm_vm_ioctl(s, KVM_CREATE_VCPU, (void *)vcpu_id);
>   }
> 

