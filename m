Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D303CD09B
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 11:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbhGSInC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 04:43:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59229 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235404AbhGSInB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 04:43:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626686621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9GqID4T7OaGpULAvBbxYFa5ax0SCEaOJ8PLyIMtOMSM=;
        b=L7Owi3r+Kv50EFlCOseqJQapUdDNGwB8eerhT0OOEb0Bod90vqdSd3+DXGskyq1r5Q/WM7
        3Cde9c4lz0cJAgIMcQSioB0OQ9wj69+9hv4DbmZtGHc780PQLkiZNjYNP5+HLkaljn5r2w
        whiTcElm+206cxmjFXfaRrJIbpwx16s=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-95PjW8F0NOekY9lWkiABiw-1; Mon, 19 Jul 2021 05:23:39 -0400
X-MC-Unique: 95PjW8F0NOekY9lWkiABiw-1
Received: by mail-ed1-f69.google.com with SMTP id v14-20020a056402184eb029039994f9cab9so8258855edy.22
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 02:23:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9GqID4T7OaGpULAvBbxYFa5ax0SCEaOJ8PLyIMtOMSM=;
        b=MFTqC4V6/bHBurNrd1WfGbub3QRlKzCUmn+Ssfa0L3KBJL+aLs9nmZQxAKtIv6JVCs
         r8jlcFUlFGyai4yxhXJR/PakvXAwphDYYPxsLmdAhDJOmv+XP6HD1hdB8yv8DJjDa5Av
         9WsUJYU3ecd+lPWPHKYOkedm9407DlfXHlQ1XzVsrVflFy4iZJbbTIq78Qme/XTSTkFK
         t5ayaOWzjlkfiAQIY6lnkZjALIVnZPsk5PybKnuxgu6VyehxejGqGS0S9F83NjtLUb83
         A/Rfr0mq5XVoYFcnnNJ1bGUMKouVFdTAzLyvc+xApeSgxo90LCRKCDDIfZxxAVqlC7/1
         erSg==
X-Gm-Message-State: AOAM530CuDdIadNnZ+9aZ2XfQJFrzeNoo0KyQKUWaYnZHPnp4oJH3aws
        aksGr9YiaPnaZ7Vd0Ez2tl5W19OrwpNXMGLyzm5TnA9Cp/twocY1I+MnV3jrPdqXvqKhKiAVRv9
        wHPbu3nEG5owh
X-Received: by 2002:a05:6402:216:: with SMTP id t22mr32665958edv.70.1626686618714;
        Mon, 19 Jul 2021 02:23:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDoq6MqXcKUH37retGzkvPJnNJR2T4LyDxSw6U1qF5+Rn1F1pvug2dt5BUszcakXHhyZ9sBg==
X-Received: by 2002:a05:6402:216:: with SMTP id t22mr32665939edv.70.1626686618525;
        Mon, 19 Jul 2021 02:23:38 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ee29sm7569047edb.39.2021.07.19.02.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 02:23:38 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2 8/8] KVM: x86: hyper-v: Deactivate APICv only when
 AutoEOI feature is in use
In-Reply-To: <b2978f4868437db23208718b3850b8fb6c0409eb.camel@redhat.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
 <20210713142023.106183-9-mlevitsk@redhat.com>
 <c51d3f0b46bb3f73d82d66fae92425be76b84a68.camel@redhat.com>
 <87wnpmzqw3.fsf@vitty.brq.redhat.com>
 <b2978f4868437db23208718b3850b8fb6c0409eb.camel@redhat.com>
Date:   Mon, 19 Jul 2021 11:23:36 +0200
Message-ID: <87tukqzmg7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Mon, 2021-07-19 at 09:47 +0200, Vitaly Kuznetsov wrote:
>> Maxim Levitsky <mlevitsk@redhat.com> writes:
>> 
>> > On Tue, 2021-07-13 at 17:20 +0300, Maxim Levitsky wrote:
>> > > From: Vitaly Kuznetsov <vkuznets@redhat.com>
>> > > 
>> > > APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
>> > > SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
>> > > however, possible to track whether the feature was actually used by the
>> > > guest and only inhibit APICv/AVIC when needed.
>> > > 
>> > > TLFS suggests a dedicated 'HV_DEPRECATING_AEOI_RECOMMENDED' flag to let
>> > > Windows know that AutoEOI feature should be avoided. While it's up to
>> > > KVM userspace to set the flag, KVM can help a bit by exposing global
>> > > APICv/AVIC enablement: in case APICv/AVIC usage is impossible, AutoEOI
>> > > is still preferred.
>> > > Maxim:
>> > >    - added SRCU lock drop around call to kvm_request_apicv_update
>> > >    - always set HV_DEPRECATING_AEOI_RECOMMENDED in kvm_get_hv_cpuid,
>> > >      since this feature can be used regardless of AVIC
>> > > 
>> > > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>> > > ---
>> > >  arch/x86/include/asm/kvm_host.h |  3 +++
>> > >  arch/x86/kvm/hyperv.c           | 34 +++++++++++++++++++++++++++------
>> > >  2 files changed, 31 insertions(+), 6 deletions(-)
>> > > 
>> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> > > index e11d64aa0bcd..f900dca58af8 100644
>> > > --- a/arch/x86/include/asm/kvm_host.h
>> > > +++ b/arch/x86/include/asm/kvm_host.h
>> > > @@ -956,6 +956,9 @@ struct kvm_hv {
>> > >  	/* How many vCPUs have VP index != vCPU index */
>> > >  	atomic_t num_mismatched_vp_indexes;
>> > >  
>> > > +	/* How many SynICs use 'AutoEOI' feature */
>> > > +	atomic_t synic_auto_eoi_used;
>> > > +
>> > >  	struct hv_partition_assist_pg *hv_pa_pg;
>> > >  	struct kvm_hv_syndbg hv_syndbg;
>> > >  };
>> > > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> > > index b07592ca92f0..6bf47a583d0e 100644
>> > > --- a/arch/x86/kvm/hyperv.c
>> > > +++ b/arch/x86/kvm/hyperv.c
>> > > @@ -85,9 +85,22 @@ static bool synic_has_vector_auto_eoi(struct kvm_vcpu_hv_synic *synic,
>> > >  	return false;
>> > >  }
>> > >  
>> > > +
>> > > +static void synic_toggle_avic(struct kvm_vcpu *vcpu, bool activate)
>> > > +{
>> > > +	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
>> > > +	kvm_request_apicv_update(vcpu->kvm, activate,
>> > > +			APICV_INHIBIT_REASON_HYPERV);
>> > > +	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
>> > > +}
>> > 
>> > Well turns out that this patch still doesn't work (on this
>> > weekend I found out that all my AVIC enabled VMs hang on reboot).
>> > 
>> > I finally found out what prompted me back then to make srcu lock drop
>> > in synic_update_vector conditional on whether the write was done
>> > by the host.
>> >  
>> > Turns out that while KVM_SET_MSRS does take the kvm->srcu lock,
>> > it stores the returned srcu index in a local variable and not
>> > in vcpu->srcu_idx, thus the lock drop in synic_toggle_avic
>> > doesn't work.
>> >  
>> > So it is likely that I have seen it not work, and blamed 
>> > KVM_SET_MSRS for not taking the srcu lock which was a wrong assumption.
>> >  
>> > I am more inclined to fix this by just tracking if we hold the srcu
>> > lock on each VCPU manually, just as we track the srcu index anyway,
>> > and then kvm_request_apicv_update can use this to drop the srcu
>> > lock when needed.
>> > 
>> 
>> Would it be possible to use some magic value in 'vcpu->srcu_idx' and not
>> introduce a new 'srcu_ls_locked' flag?
>
> Well, currently the returned index value from srcu_read_lock is opaque 
> (and we have two SRCU implementations and both I think return small positive numbers, 
> but I haven't studied them in depth).
>  
> We can ask the people that maintain SRCU to reserve a number (like -1)
> or so.
> I probably first add the 'srcu_is_locked' thought and then as a follow up patch
> remove it if they agree.
>

Ah, OK. BTW, I've just discovered srcu_read_lock_held() which sounds
like the function we need but unfortunately it is not.

-- 
Vitaly

