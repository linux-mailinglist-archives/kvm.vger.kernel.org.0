Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85EE918FA95
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 17:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgCWQ5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 12:57:23 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:49987 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727770AbgCWQ5X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 12:57:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584982642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oCiKY/awUsZ/73HEBO+Ebhw+NCIAIbZULxjjUGIv5cM=;
        b=LJJI9X25he9ww4l+OQss/9RcD/lk9pTk1/Q2Fp1rz6tKTMq1ipazhszEBaPIowI3OZEdcF
        wdMiFAYRXAiE8x6/c410S5MOvO2rplqB/Kd7ofq0Q7AaQsXkAMbpawhd9BoPJRhBp8qzJo
        pLgHsP1COixqFXs+3/cIx+wwl5Tl22c=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-YA-8uiLOMASJLsy136obbA-1; Mon, 23 Mar 2020 12:57:20 -0400
X-MC-Unique: YA-8uiLOMASJLsy136obbA-1
Received: by mail-wm1-f71.google.com with SMTP id s14so41530wmj.9
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 09:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=oCiKY/awUsZ/73HEBO+Ebhw+NCIAIbZULxjjUGIv5cM=;
        b=rBtY1EXsFDEHV/GAozCJ/HS/oYjsreXuiJ+Srdw3zX5b3/ZpYSWDRXPECW37JZsx/H
         WbZIz6nSAOl8t3Bu5z34he+qo2mhvdzOZk1pnfrVhanOeRiS5uJAQhb+TIJJYkeX9FkN
         UOAMqdC/wMJUJooDS+UIxbwRH6b+r/z+nHddmsvT6SCQ4zexZ4cY3IiLO+pvcsSruBkR
         YOZID9auCm1SggmGqspv9XcE3uZUSmricXTKTJG3vNSy8hdZUjJyumqkFI1hHVWGiT1F
         iAeEwq9gHIoe/u1LEwD49qKwZ4+E4dBAheorhVoZXa+VtQvyvSaugXd0vJsgqsOQk4Ow
         VRAw==
X-Gm-Message-State: ANhLgQ25kVU1GeOWxrYbzuKAr96iYrOOf2ekbIo0c+VCsBd4SbIrqbGm
        nZvmJ62vNTSiFuMSVLe68r2QLpaUsiji1h21nWTvew7GsdhSW+00ezyxmn82Q/80rqgKmWzMANx
        MDvWBfQIAv5T/
X-Received: by 2002:a1c:6146:: with SMTP id v67mr243978wmb.78.1584982639607;
        Mon, 23 Mar 2020 09:57:19 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuYr+N5szRZN8Ecp0oqemkBbyB46OZWdhGgHWaAh5uIJPuxPPLf/flCu7R0yuGcHI7dDq2oOg==
X-Received: by 2002:a1c:6146:: with SMTP id v67mr243861wmb.78.1584982638429;
        Mon, 23 Mar 2020 09:57:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i4sm25236470wrm.32.2020.03.23.09.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 09:57:17 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 04/37] KVM: nVMX: Invalidate all roots when emulating INVVPID without EPT
In-Reply-To: <20200323165001.GR28711@linux.intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-5-sean.j.christopherson@intel.com> <87v9mv84qu.fsf@vitty.brq.redhat.com> <20200323160432.GJ28711@linux.intel.com> <87lfnr820r.fsf@vitty.brq.redhat.com> <20200323165001.GR28711@linux.intel.com>
Date:   Mon, 23 Mar 2020 17:57:16 +0100
Message-ID: <87imiv80wj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Mon, Mar 23, 2020 at 05:33:08PM +0100, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> 
>> > On Mon, Mar 23, 2020 at 04:34:17PM +0100, Vitaly Kuznetsov wrote:
>> >> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> >> 
>> >> > From: Junaid Shahid <junaids@google.com>
>> >> >
>> >> > Free all roots when emulating INVVPID for L1 and EPT is disabled, as
>> >> > outstanding changes to the page tables managed by L1 need to be
>> >> > recognized.  Because L1 and L2 share an MMU when EPT is disabled, and
>> >> > because VPID is not tracked by the MMU role, all roots in the current
>> >> > MMU (root_mmu) need to be freed, otherwise a future nested VM-Enter or
>> >> > VM-Exit could do a fast CR3 switch (without a flush/sync) and consume
>> >> > stale SPTEs.
>> >> >
>> >> > Fixes: 5c614b3583e7b ("KVM: nVMX: nested VPID emulation")
>> >> > Signed-off-by: Junaid Shahid <junaids@google.com>
>> >> > [sean: ported to upstream KVM, reworded the comment and changelog]
>> >> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> >> > ---
>> >> >  arch/x86/kvm/vmx/nested.c | 14 ++++++++++++++
>> >> >  1 file changed, 14 insertions(+)
>> >> >
>> >> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> >> > index 9624cea4ed9f..bc74fbbf33c6 100644
>> >> > --- a/arch/x86/kvm/vmx/nested.c
>> >> > +++ b/arch/x86/kvm/vmx/nested.c
>> >> > @@ -5250,6 +5250,20 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
>> >> >  		return kvm_skip_emulated_instruction(vcpu);
>> >> >  	}
>> >> >  
>> >> > +	/*
>> >> > +	 * Sync the shadow page tables if EPT is disabled, L1 is invalidating
>> >> > +	 * linear mappings for L2 (tagged with L2's VPID).  Free all roots as
>> >> > +	 * VPIDs are not tracked in the MMU role.
>> >> > +	 *
>> >> > +	 * Note, this operates on root_mmu, not guest_mmu, as L1 and L2 share
>> >> > +	 * an MMU when EPT is disabled.
>> >> > +	 *
>> >> > +	 * TODO: sync only the affected SPTEs for INVDIVIDUAL_ADDR.
>> >> > +	 */
>> >> > +	if (!enable_ept)
>> >> > +		kvm_mmu_free_roots(vcpu, &vcpu->arch.root_mmu,
>> >> > +				   KVM_MMU_ROOTS_ALL);
>> >> > +
>> >> 
>> >> This is related to my remark on the previous patch; the comment above
>> >> makes me think I'm missing something obvious, enlighten me please)
>> >> 
>> >> My understanding is that L1 and L2 will share arch.root_mmu not only
>> >> when EPT is globally disabled, we seem to switch between
>> >> root_mmu/guest_mmu only when nested_cpu_has_ept(vmcs12) but different L2
>> >> guests may be different on this. Do we need to handle this somehow?
>> >
>> > guest_mmu is used iff nested EPT is enabled, which requires enable_ept=1.
>> > enable_ept is global and cannot be changed without reloading kvm_intel.
>> >
>> > This most definitely over-invalidates, e.g. it blasts away L1's page
>> > tables.  But, fixing that requires tracking VPID in mmu_role and/or adding
>> > support for using guest_mmu when L1 isn't using TDP, i.e. nested EPT is
>> > disabled.  Assuming the vast majority of nested deployments enable EPT in
>> > L0, the cost of both options likely outweighs the benefits.
>> >
>> 
>> Yes but my question rather was: what if global 'enable_ept' is true but
>> nested EPT is not being used by L1, don't we still need to do
>> kvm_mmu_free_roots(&vcpu->arch.root_mmu) here?
>
> No, because L0 isn't shadowing the L1->L2 page tables, i.e. there can't be
> unsync'd SPTEs for L2.  The vpid_sync_*() above flushes the TLB for L2's
> effective VPID, which is all that's required.

Ah, stupid me, it's actually EPT and not nested EPT which we care about
here. Thank you for the clarification!

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

