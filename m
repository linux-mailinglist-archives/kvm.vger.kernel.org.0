Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28CE18F9C2
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 17:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgCWQdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 12:33:15 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:48577 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727334AbgCWQdO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 12:33:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584981193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KCvacwiU6OTRKkamU+WDDamahYADSqAV/L9BazSCR94=;
        b=FyDsCBjAuszSEz/Qix1nNSdnyL8pT1oGIeUj/ny9Rdbll9TDFSuTM/URQBIeIYU7x63+UP
        +uRuUcbVIEcLMaqW76YMJFsfykPuMxx7I4M7qHclek8LX7GBZZSvYTKC1MVAXUS+jMLWNQ
        k5V5YUGm/45UUpjDgSkGbCnRuDn9oDs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-agW3G8k2OPGF3nY442HOFg-1; Mon, 23 Mar 2020 12:33:11 -0400
X-MC-Unique: agW3G8k2OPGF3nY442HOFg-1
Received: by mail-wr1-f71.google.com with SMTP id r9so5503291wrs.13
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 09:33:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KCvacwiU6OTRKkamU+WDDamahYADSqAV/L9BazSCR94=;
        b=XHllpxfJLAiDwj0EdrEwp/b4bx85ctyHAf+l3XZnk1g4PVzWQV3vwXru5cf3+/lNlp
         I4BA1LkygVbFsIsbzCGN3BgG36WJAd7Qr7nE9EUzIRhp5a6XbTeu6clTh9ltB+VvUVzQ
         OZpkvlTEgAXR5/bPztd8Cn9nHp6YJIbLQZhY+4apej24OLCAlzTJbWLgjJaNQyh1Ti79
         eJYleSNIKik+srw1lJyQEh+nTRf+sch1315XGrK9hQpI6m+3eMN0kgQqUKLKx8IIf6jg
         Cj0YHe0YwTBlCMeJLs4MIYaNfGB1W0QIbKDJkfIW3XpRi/CRYjxlrLVijaME9b/kiQzT
         7G9Q==
X-Gm-Message-State: ANhLgQ3GIu3sRyIkoQsxmmHyMjIT8xJw3cn5illhOBhGYg4RrMKc1J5I
        jikJb5B1h3bzxO1VnpKWy2FYs4WYNlCOq2xJ0PdBnqUT0ZXPdrFezJPzSc2qkvYtwipKX9cDZ+R
        HU7aDY2G5TciO
X-Received: by 2002:adf:a387:: with SMTP id l7mr30790724wrb.250.1584981190740;
        Mon, 23 Mar 2020 09:33:10 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu5DQvhi2385iSKFZyFJgeZoUq4ZNFT6SaoQ4GLJpPuvChdtB8xZdp32gM1w6hlQUmPYIQLCg==
X-Received: by 2002:adf:a387:: with SMTP id l7mr30790696wrb.250.1584981190471;
        Mon, 23 Mar 2020 09:33:10 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 61sm26456602wrn.82.2020.03.23.09.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 09:33:09 -0700 (PDT)
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
In-Reply-To: <20200323160432.GJ28711@linux.intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-5-sean.j.christopherson@intel.com> <87v9mv84qu.fsf@vitty.brq.redhat.com> <20200323160432.GJ28711@linux.intel.com>
Date:   Mon, 23 Mar 2020 17:33:08 +0100
Message-ID: <87lfnr820r.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Mon, Mar 23, 2020 at 04:34:17PM +0100, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> 
>> > From: Junaid Shahid <junaids@google.com>
>> >
>> > Free all roots when emulating INVVPID for L1 and EPT is disabled, as
>> > outstanding changes to the page tables managed by L1 need to be
>> > recognized.  Because L1 and L2 share an MMU when EPT is disabled, and
>> > because VPID is not tracked by the MMU role, all roots in the current
>> > MMU (root_mmu) need to be freed, otherwise a future nested VM-Enter or
>> > VM-Exit could do a fast CR3 switch (without a flush/sync) and consume
>> > stale SPTEs.
>> >
>> > Fixes: 5c614b3583e7b ("KVM: nVMX: nested VPID emulation")
>> > Signed-off-by: Junaid Shahid <junaids@google.com>
>> > [sean: ported to upstream KVM, reworded the comment and changelog]
>> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> > ---
>> >  arch/x86/kvm/vmx/nested.c | 14 ++++++++++++++
>> >  1 file changed, 14 insertions(+)
>> >
>> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> > index 9624cea4ed9f..bc74fbbf33c6 100644
>> > --- a/arch/x86/kvm/vmx/nested.c
>> > +++ b/arch/x86/kvm/vmx/nested.c
>> > @@ -5250,6 +5250,20 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
>> >  		return kvm_skip_emulated_instruction(vcpu);
>> >  	}
>> >  
>> > +	/*
>> > +	 * Sync the shadow page tables if EPT is disabled, L1 is invalidating
>> > +	 * linear mappings for L2 (tagged with L2's VPID).  Free all roots as
>> > +	 * VPIDs are not tracked in the MMU role.
>> > +	 *
>> > +	 * Note, this operates on root_mmu, not guest_mmu, as L1 and L2 share
>> > +	 * an MMU when EPT is disabled.
>> > +	 *
>> > +	 * TODO: sync only the affected SPTEs for INVDIVIDUAL_ADDR.
>> > +	 */
>> > +	if (!enable_ept)
>> > +		kvm_mmu_free_roots(vcpu, &vcpu->arch.root_mmu,
>> > +				   KVM_MMU_ROOTS_ALL);
>> > +
>> 
>> This is related to my remark on the previous patch; the comment above
>> makes me think I'm missing something obvious, enlighten me please)
>> 
>> My understanding is that L1 and L2 will share arch.root_mmu not only
>> when EPT is globally disabled, we seem to switch between
>> root_mmu/guest_mmu only when nested_cpu_has_ept(vmcs12) but different L2
>> guests may be different on this. Do we need to handle this somehow?
>
> guest_mmu is used iff nested EPT is enabled, which requires enable_ept=1.
> enable_ept is global and cannot be changed without reloading kvm_intel.
>
> This most definitely over-invalidates, e.g. it blasts away L1's page
> tables.  But, fixing that requires tracking VPID in mmu_role and/or adding
> support for using guest_mmu when L1 isn't using TDP, i.e. nested EPT is
> disabled.  Assuming the vast majority of nested deployments enable EPT in
> L0, the cost of both options likely outweighs the benefits.
>

Yes but my question rather was: what if global 'enable_ept' is true but
nested EPT is not being used by L1, don't we still need to do
kvm_mmu_free_roots(&vcpu->arch.root_mmu) here?

-- 
Vitaly

