Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E800598C50
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 21:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344883AbiHRTFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 15:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbiHRTFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 15:05:19 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D07B959D;
        Thu, 18 Aug 2022 12:05:17 -0700 (PDT)
Date:   Thu, 18 Aug 2022 21:05:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660849515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NLXxzLfpertkCh7pqMuyBZ0dtciDt6C/zyyyhRKQC5k=;
        b=QbDRhjd3503yNjCD2mOOhYXLkQ2FBbucLznvFoZTl5FUXbmKCok/YevU8XVEOKaMib5vTU
        3ElBIrnxbnHrsmPs8ejqKTk124Phc1ETIGOKc/2b30+8XKh9/QAfMuOOl6b7toR4o8vd0h
        ebKKD+PNN1PJv8geoltKMbA6iN1Jh8c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcorr@google.com,
        michael.roth@amd.com, thomas.lendacky@amd.com, joro@8bytes.org,
        mizhang@google.com, pbonzini@redhat.com, vannapurve@google.com
Subject: Re: [V3 10/11] KVM: selftests: Add ucall pool based implementation
Message-ID: <20220818190514.ny77xpfwiruah6m5@kamzik>
References: <20220810152033.946942-1-pgonda@google.com>
 <20220810152033.946942-11-pgonda@google.com>
 <20220816161350.b7x5brnyz5pyi7te@kamzik>
 <Yv5iKJbjW5VseagS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv5iKJbjW5VseagS@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 18, 2022 at 04:00:40PM +0000, Sean Christopherson wrote:
> On Tue, Aug 16, 2022, Andrew Jones wrote:
> > On Wed, Aug 10, 2022 at 08:20:32AM -0700, Peter Gonda wrote:
> > > diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> > > index 132c0e98bf49..ee70531e8e51 100644
> > > --- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> > > +++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> > > @@ -81,12 +81,16 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
> > >  
> > >  	if (run->exit_reason == KVM_EXIT_MMIO &&
> > >  	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
> > > -		vm_vaddr_t gva;
> > > +		uint64_t ucall_addr;
> > 
> > Why change this vm_vaddr_t to a uint64_t? We shouldn't, because...
> > 
> > >  
> > >  		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
> > >  			    "Unexpected ucall exit mmio address access");
> > > -		memcpy(&gva, run->mmio.data, sizeof(gva));
> > > -		return addr_gva2hva(vcpu->vm, gva);
> > > +		memcpy(&ucall_addr, run->mmio.data, sizeof(ucall_addr));
> > 
> > ...here we assume it's a vm_vaddr_t and only...
> > 
> > > +
> > > +		if (vcpu->vm->use_ucall_pool)
> > > +			return (void *)ucall_addr;
> > 
> > ...here do we know otherwise. So only here should be any casting.
> 
> It technically should be a union, because if sizeof(vm_vaddr_t) < sizeof(void *)
> then declaring it as a vm_addr_t will do the wrong thing.  But then it's possible
> that this could read too many bytes and inducs failure.  So I guess what we really
> need is a "static_assert(sizeof(vm_vaddr_t) == sizeof(void *))".

ack

> 
> But why is "use_ucall_pool" optional?  Unless there's a use case that fundamentally
> conflicts with the pool approach, let's make the pool approach the _only_ approach.
> IIRC, ARM's implementation isn't thread safe, i.e. there's at least one other use
> case that _needs_ the pool implementation.

Really? The ucall structure is on the vcpu's stack like the other
architectures. Ah, you're probably thinking about the shared address used
to exit to userspace. The address doesn't matter as long as no VM maps
it, but, yes, a multi-VM test where the VMs have different maps could end
up breaking ucalls for one or more VMs. It wouldn't be hard to make that
address per-VM, though, if ever necessary.

> 
> By supporting both, we are signing ourselves up for extra maintenance and pain,
> e.g. inevitably we'll break whichever option isn't the default and not notice for
> quite some time.

uc pools are currently limited to a single VM. That could be changed, but
at the expense of even more code to maintain. The simple uc implementation
is, well, simple, and also supports multiple VMs. I'd prefer we keep that
one and keep it as the default.

Thanks,
drew
