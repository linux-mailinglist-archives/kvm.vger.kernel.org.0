Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCB039FDD3
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 19:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhFHRiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 13:38:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231416AbhFHRiI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 13:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623173775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+D/IqEBsmrawx3z+g1IRuMOSYaHEvwjh/bfd9sGokww=;
        b=hk2Hz6FMsBOWHKKA+eBoZdcY8nzmmnHRBb2YpmSPbrGPEVLTFRvmDbNkITVKCwfWvtiGe5
        Sp/9DN8r28NThQJDYHgFea/ZtliOeKc+JD0dShuoZrTpVqnuDOLqruOnbIwKP4FeaYRs01
        DB8dZtkc+593bi1kRjqu59yImkuwdGc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-LQ37uJpNMma6xVUZeYMQvQ-1; Tue, 08 Jun 2021 13:36:14 -0400
X-MC-Unique: LQ37uJpNMma6xVUZeYMQvQ-1
Received: by mail-wm1-f72.google.com with SMTP id f186-20020a1c1fc30000b02901aaa08ad8f4so1449395wmf.8
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 10:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+D/IqEBsmrawx3z+g1IRuMOSYaHEvwjh/bfd9sGokww=;
        b=ox2kfmIFIQCX/YxF+67bjE/albVbjMl50U160BTbFqiffhWFhIeHN0HCV4T7aOPdO/
         Wh2zKe4R0Dj1ah3vGXvDSjtxlsSYxy632Ip1LKLUmFl5my+x7eJ5ilMj86ESkWSFn39O
         ylIlP8zXz3OBb5b8zgNff0+t/NMrqtiAlrydSJxvlhdqXiPHHl3RgPABhRNl57u92rmW
         RtVa1xp5lwGyNPpTPwIV84FGYjPeUIhzVrQQmlloOVRU5AWhlXcBKgL5xiXU0xRD6T/4
         QXZSoI5Q8g3DSZZwsrwonsWD7rwtoIopuw9mBcKVqex/RxNviGdYPFMhJ4NI5zmgBrVA
         SLrA==
X-Gm-Message-State: AOAM532yY0N+HH5TJv+m0nLrBWVpuLoV+0D0F8fjiBu+nVrdG3Dt3N/f
        Od2nc3VrNBy3qg73d8g8VYA7M/+Qi9mbZL6kzDZJesVmRwOrQMHAPFDLw6r1SlgbxFXgtlYl/Eo
        L7tvUo2MQkManJPy8lflKA6t7Uu/cWZ/BiLN/cCGLox7QPNpHX6kHiXxQNQgwg5j0
X-Received: by 2002:a1c:1bd8:: with SMTP id b207mr22569588wmb.80.1623173772399;
        Tue, 08 Jun 2021 10:36:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDbooef8Nxz/02uzZD+uV6aRsn4tVHqWL+SbZDSTSIy/yJ8iFHb7fZZEnCYEe/Q8oUnz/c7Q==
X-Received: by 2002:a1c:1bd8:: with SMTP id b207mr22569541wmb.80.1623173772118;
        Tue, 08 Jun 2021 10:36:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f14sm20185607wry.40.2021.06.08.10.36.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 10:36:11 -0700 (PDT)
Subject: Re: [PATCH V2] KVM: X86: fix tlb_flush_guest()
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <4c3ef411ba68ca726531a379fb6c9d16178c8513.camel@redhat.com>
 <20210531172256.2908-1-jiangshanlai@gmail.com>
 <9d457b982c3fcd6e7413065350b9f860d45a6e47.camel@redhat.com>
 <YL6z5sv7cnsbZhvT@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3c09b70e-a3fe-8739-98e4-cba1760507e9@redhat.com>
Date:   Tue, 8 Jun 2021 19:36:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YL6z5sv7cnsbZhvT@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/21 02:03, Sean Christopherson wrote:
> On Tue, Jun 08, 2021, Maxim Levitsky wrote:
>> So this patch *does* fix the windows boot without TDP!
> 
> Woot!
> 
>> Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Lai,
> 
> I have a reworded version of your patch sitting in a branch that leverages this
> path to fix similar bugs and do additional cleanup.  Any objection to me gathering
> Maxim's tags and posting the version below?  I'm more than happy to hold off if
> you'd prefer to send your own version, but I don't want to send my own series
> without this fix as doing so would introduce bugs.
> 
> Thanks!
> 
> Author: Lai Jiangshan <laijs@linux.alibaba.com>
> Date:   Tue Jun 1 01:22:56 2021 +0800
> 
>      KVM: x86: Unload MMU on guest TLB flush if TDP disabled to force MMU sync
>      
>      When using shadow paging, unload the guest MMU when emulating a guest TLB
>      flush to all roots are synchronized.  From the guest's perspective,
>      flushing the TLB ensures any and all modifications to its PTEs will be
>      recognized by the CPU.
>      
>      Note, unloading the MMU is overkill, but is done to mirror KVM's existing
>      handling of INVPCID(all) and ensure the bug is squashed.  Future cleanup
>      can be done to more precisely synchronize roots when servicing a guest
>      TLB flush.
>      
>      If TDP is enabled, synchronizing the MMU is unnecessary even if nested
>      TDP is in play, as a "legacy" TLB flush from L1 does not invalidate L1's
>      TDP mappgins.  For EPT, an explicit INVEPT is required to invalidate
>      guest-physical mappings.  For NPT, guest mappings are always tagged with
>      an ASID and thus can only be invalidated via the VMCB's ASID control.
>      
>      This bug has existed since the introduction of KVM_VCPU_FLUSH_TLB, but
>      was only recently exposed after Linux guests stopped flushing the local
>      CPU's TLB prior to flushing remote TLBs (see commit 4ce94eabac16,
>      "x86/mm/tlb: Flush remote and local TLBs concurrently").
>      
>      Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
>      Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>      Fixes: f38a7b75267f ("KVM: X86: support paravirtualized help for TLB shootdowns")
>      Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
>      [sean: massaged comment and changelog]
>      Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1cd6d4685932..3b02528d5ee8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3072,6 +3072,18 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
>   static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
>   {
>          ++vcpu->stat.tlb_flush;
> +
> +       if (!tdp_enabled) {
> +               /*
> +                * Unload the entire MMU to force a sync of the shadow page
> +                * tables.  A TLB flush on behalf of the guest is equivalent
> +                * to INVPCID(all), toggling CR4.PGE, etc...  Note, loading the
> +                * MMU will also do an actual TLB flush.
> +                */

I slightly prefer it in the opposite order (first why, then how):

                /*
                 * A TLB flush on behalf of the guest is equivalent to
                 * INVPCID(all), toggling CR4.PGE, etc., which requires
                 * a forced sync of the shadow page tables.  Unload the
                 * entire MMU here and the subsequent load will sync the
                 * shadow page tables, and also flush the TLB.
                 */

Queued, thanks all!  It's great that this fixes an actual bug.

Paolo

