Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0670A48E91B
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 12:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbiANLWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 06:22:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49450 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231705AbiANLWm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 06:22:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642159361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iLTg4wwf72c5vthIOvKqfSt1SY2KDa4Mpvj4k6lWWOY=;
        b=Ro7/qVjrqkChgn4uK96sl/45qXLTH3IkCXnGPooKtjh46JACZKkqHGv9gAwYz3F8ktJoAH
        y2nRi0Mb0xiWYTJa1O8cmzf0vXvPeY3IZ9SHU4moBPEht6L4G7ySoTKZ9hNtxEHiKtdBw5
        P3sVt6IAkWVQ+Tvuql3VQC2tQD+4b0A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-V6Od8ojPMRuCmlLGSj4f2A-1; Fri, 14 Jan 2022 06:22:40 -0500
X-MC-Unique: V6Od8ojPMRuCmlLGSj4f2A-1
Received: by mail-ed1-f71.google.com with SMTP id h1-20020aa7cdc1000000b0040042dd2fe4so6826697edw.17
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 03:22:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iLTg4wwf72c5vthIOvKqfSt1SY2KDa4Mpvj4k6lWWOY=;
        b=yomFeyGAJcmGjwxBc1c3owit6Mz5B4z0JsiQ6mL/1DAVTJbzQxNXx/fvWkdZ53MVVE
         oStlyoeXI/vebh14kl7RGav0phPjFrURztnxGCh+bTCL3TnTTFD+WGMFvt7ONDybO1CO
         VkK1B/gFIiwbl1nmYVQwYEhKt+Vlj5MyLRwW4YMEskbnZJ3ShfIG1h73mS6AXPmfR3Pk
         QpwtRIukBAfWrSEWZjgGwHJNiHZ+BVmS/kZwjlEn7520VAtsa2/OAcBIY4IyBN1ElwW8
         HSOARd3w5tTOVZg9pmYdov+PoW7J/7KFQCixPgbupuaKLq7+xJJp+Sgzak0+GfKImhNR
         /stA==
X-Gm-Message-State: AOAM531Z1/4h0vfwTgoNACDXvA3cEMyJ2AB/1q1o8/J+0mPPIq2TpjAZ
        iD/L6uDsT3t/xr/cHUNORTx7gDVz6kh9RzT/S7HA4lf20nhLuuFrzKp7y6hrYxYsfNDYxLR9A5S
        Amb44jJNv8jOl
X-Received: by 2002:a17:906:1f51:: with SMTP id d17mr6899085ejk.759.1642159358840;
        Fri, 14 Jan 2022 03:22:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsMqgdRzO68qhSabKf+XHaTzty5JGMJ6wQ+em+6w7fAZnYL54Sg4c0WDYyOb2SwQQYgsuOww==
X-Received: by 2002:a17:906:1f51:: with SMTP id d17mr6899069ejk.759.1642159358643;
        Fri, 14 Jan 2022 03:22:38 -0800 (PST)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 4sm1723923ejc.168.2022.01.14.03.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 03:22:38 -0800 (PST)
Date:   Fri, 14 Jan 2022 12:22:37 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Message-ID: <20220114122237.54fa8c91@redhat.com>
In-Reply-To: <87ilummznd.fsf@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
        <20211122175818.608220-3-vkuznets@redhat.com>
        <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
        <20211227183253.45a03ca2@redhat.com>
        <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
        <87mtkdqm7m.fsf@redhat.com>
        <20220103104057.4dcf7948@redhat.com>
        <YeCowpPBEHC6GJ59@google.com>
        <20220114095535.0f498707@redhat.com>
        <87ilummznd.fsf@redhat.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jan 2022 10:31:50 +0100
Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> Igor Mammedov <imammedo@redhat.com> writes:
> 
> > On Thu, 13 Jan 2022 22:33:38 +0000
> > Sean Christopherson <seanjc@google.com> wrote:
> >  
> >> On Mon, Jan 03, 2022, Igor Mammedov wrote:  
> >> > On Mon, 03 Jan 2022 09:04:29 +0100
> >> > Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >> >     
> >> > > Paolo Bonzini <pbonzini@redhat.com> writes:
> >> > >     
> >> > > > On 12/27/21 18:32, Igor Mammedov wrote:      
> >> > > >>> Tweaked and queued nevertheless, thanks.      
> >> > > >> it seems this patch breaks VCPU hotplug, in scenario:
> >> > > >> 
> >> > > >>    1. hotunplug existing VCPU (QEMU stores VCPU file descriptor in parked cpus list)
> >> > > >>    2. hotplug it again (unsuspecting QEMU reuses stored file descriptor when recreating VCPU)
> >> > > >> 
> >> > > >> RHBZ:https://bugzilla.redhat.com/show_bug.cgi?id=2028337#c11
> >> > > >>       
> >> > > >
> >> > > > The fix here would be (in QEMU) to not call KVM_SET_CPUID2 again. 
> >> > > > However, we need to work around it in KVM, and allow KVM_SET_CPUID2 if 
> >> > > > the data passed to the ioctl is the same that was set before.      
> >> > > 
> >> > > Are we sure the data is going to be *exactly* the same? In particular,
> >> > > when using vCPU fds from the parked list, do we keep the same
> >> > > APIC/x2APIC id when hotplugging? Or can we actually hotplug with a
> >> > > different id?    
> >> > 
> >> > If I recall it right, it can be a different ID easily.    
> >> 
> >> No, it cannot.  KVM doesn't provide a way for userspace to change the APIC ID of
> >> a vCPU after the vCPU is created.  x2APIC flat out disallows changing the APIC ID,
> >> and unless there's magic I'm missing, apic_mmio_write() => kvm_lapic_reg_write()
> >> is not reachable from userspace.
> >> 
> >> The only way for userspace to set the APIC ID is to change vcpu->vcpu_id, and that
> >> can only be done at KVM_VCPU_CREATE.
> >> 
> >> So, reusing a parked vCPU for hotplug must reuse the same APIC ID.  QEMU handles
> >> this by stashing the vcpu_id, a.k.a. APIC ID, when parking a vCPU, and reuses a
> >> parked vCPU if and only if it has the same APIC ID.  And because QEMU derives the
> >> APIC ID from topology, that means all the topology CPUID leafs must remain the
> >> same, otherwise the guest is hosed because it will send IPIs to the wrong vCPUs.  
> >
> > Indeed, I was wrong.
> > I just checked all cpu unplug history in qemu. It was introduced in qemu-2.7
> > and from the very beginning it did stash vcpu_id,
> > so there is no old QEMU that would re-plug VCPU with different apic_id.
> > Though tells us nothing about what other userspace implementations might do.
> >  
> 
> The genie is out of the bottle already, 5.16 is released with the change
> (which was promissed for some time, KVM was complaining with
> pr_warn_ratelimited()). I'd be brave and say that if QEMU doesn't need
> it then nobody else does (out of curiosity, are there KVM VMMs besides
> QEMU which support CPU hotplug out there?).
> 
> > However, a problem of failing KVM_SET_CPUID2 during VCPU re-plug
> > is still there and re-plug will fail if KVM rejects repeated KVM_SET_CPUID2
> > even if ioctl called with exactly the same CPUID leafs as the 1st call.
> >  
> 
> Assuming APIC id change doesn not need to be supported, I can send v2
> here with an empty allowlist.
As you mentioned in another thread black list would be better
to address Sean's concerns or just revert problematic commit.

