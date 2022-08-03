Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084C0589254
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 20:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237807AbiHCSgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 14:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbiHCSgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 14:36:32 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE3313F86;
        Wed,  3 Aug 2022 11:36:30 -0700 (PDT)
Date:   Wed, 3 Aug 2022 18:36:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1659551788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CQjdEyiPeZH0XY6Swr9OAQufmU7RMOqySCXDJe1q8wA=;
        b=FpQ6/YOMVGN27MEiJGxc1sN/F1GpwndYCHPdgsGGyKeQDLU2G0qpUPmDvhqG13J5DwwbB3
        URLdhm51PAuPDVRn0/ZjVe81TURy8wcwJaIjoBcTc3lqMNGDo5xSkpyIFUskVneCAqf2Iz
        4AXu0mZikTKtHpPtNuBuOVuhy+EXlFI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: x86: Get vmcs12 pages before checking pending
 interrupts
Message-ID: <YurAKLuw2RTtMJVT@google.com>
References: <20220802230718.1891356-1-mizhang@google.com>
 <20220802230718.1891356-2-mizhang@google.com>
 <060419e118445978549f0c7d800f96a9728c157c.camel@redhat.com>
 <YuqmKkxEsDwBvayo@google.com>
 <Yuqpqr/aE6KN5MLv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yuqpqr/aE6KN5MLv@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022 at 05:00:26PM +0000, Mingwei Zhang wrote:
> On Wed, Aug 03, 2022, Mingwei Zhang wrote:
> > On Wed, Aug 03, 2022, Maxim Levitsky wrote:
> > > On Tue, 2022-08-02 at 23:07 +0000, Mingwei Zhang wrote:
> > > > From: Oliver Upton <oupton@google.com>
> > > > 
> > > > vmx_guest_apic_has_interrupts implicitly depends on the virtual APIC
> > > > page being present + mapped into the kernel address space. However, with
> > > > demand paging we break this dependency, as the KVM_REQ_GET_VMCS12_PAGES
> > > > event isn't assessed before entering vcpu_block.
> > > > 
> > > > Fix this by getting vmcs12 pages before inspecting the guest's APIC
> > > > page. Note that upstream does not have this issue, as they will directly
> > > > get the vmcs12 pages on vmlaunch/vmresume instead of relying on the
> > > > event request mechanism. However, the upstream approach is problematic,
> > > > as the vmcs12 pages will not be present if a live migration occurred
> > > > before checking the virtual APIC page.
> > > 
> > > Since this patch is intended for upstream, I don't fully understand
> > > the meaning of the above paragraph.
> > 
> > My apology. Some of the statement needs to be updated, which I should do
> > before sending. But I think the point here is that there is a missing
> > get_nested_state_pages() call here within vcpu_block() when there is the
> > request of KVM_REQ_GET_NESTED_STATE_PAGES.

This was my poorly written changelog, sorry about that Mingwei :)

> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index 5366f884e9a7..1d3d8127aaea 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -10599,6 +10599,23 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
> > > >  {
> > > >  	bool hv_timer;
> > > >  
> > > > +	/*
> > > > +	 * We must first get the vmcs12 pages before checking for interrupts
> > > > +	 * that might unblock the guest if L1 is using virtual-interrupt
> > > > +	 * delivery.
> > > > +	 */
> > > > +	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
> > > > +		/*
> > > > +		 * If we have to ask user-space to post-copy a page,
> > > > +		 * then we have to keep trying to get all of the
> > > > +		 * VMCS12 pages until we succeed.
> > > > +		 */
> > > > +		if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
> > > > +			kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> > > > +			return 0;
> > > > +		}
> > > > +	}
> > > > +
> > > >  	if (!kvm_arch_vcpu_runnable(vcpu)) {
> > > >  		/*
> > > >  		 * Switch to the software timer before halt-polling/blocking as
> > > 
> > > 
> > > If I understand correctly, you are saying that if apic backing page is migrated in post copy
> > > then 'get_nested_state_pages' will return false and thus fail?
> > 
> > What I mean is that when the vCPU was halted and then migrated in this
> > case, KVM did not call get_nested_state_pages() before getting into
> > kvm_arch_vcpu_runnable(). This function checks the apic backing page and
> > fails on that check and triggered the warning.
> > > 
> > > AFAIK both SVM and VMX versions of 'get_nested_state_pages' assume that this is not the case
> > > for many things like MSR bitmaps and such - they always uses non atomic versions
> > > of guest memory access like 'kvm_vcpu_read_guest' and 'kvm_vcpu_map' which
> > > supposed to block if they attempt to access HVA which is not present, and then
> > > userfaultd should take over and wake them up.
> > 
> > You are right here.
> > > 
> > > If that still fails, nested VM entry is usually failed, and/or the whole VM
> > > is crashed with 'KVM_EXIT_INTERNAL_ERROR'.
> > > 
> 
> Ah, I think I understand what you are saying. hmm, so basically the
> patch here is to continuously request vmcs12 pages if failed. But what
> you are saying is that we just need to call 'get_nested_state_pages'
> once. If it fails, then the VM fails to work. Let me double check and
> get back.

IIRC the reason we reset the request on a nonzero return was because our
local implementation of the VMX hook was non-blocking and would bail on
the first page that needed to be demanded from the source. So, you
effectively keep hitting the request until all the pages are pulled in.

--
Thanks,
Oliver


