Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF19557BE14
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 20:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiGTStN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 14:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiGTStL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 14:49:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E26E73586
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 11:49:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E6FE61983
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 18:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF93C341C7;
        Wed, 20 Jul 2022 18:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658342947;
        bh=08+Q+ucM7zcCNE6VbGiO3oIo7eApyt+93Izjlu+1QBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I5gDqg3ywx4qWRFZdqk2of8EjGxUwRP32WqTD3A6zedGZCkRpKUr07J2YyY2VOvtH
         odIeq+MaBWBPl29VbjTYBkjxxWSkaMAb8dcNRLwRQ+dTnpJQmDHyLkGLAQkjsiOGM7
         mtZWTAJSwC67EdecVJP1U7BILEn1WqlO9TWMl9kk52Qfn3QIkbe8qXyYTR+/qXdgkJ
         u0x857jsmj1+Eu+tlUUO3oyqTRWRYrXMKq+l5rVsrUDZCp2biBvFkzXWm/MiUFidl/
         drl3U8SY0zufJAPUvVbgQluKsTWrDmSFbmNhGSZTP4W4QV0QcJLz8LNCsve0S5mmOM
         2vgsJ5MzLryYw==
Date:   Wed, 20 Jul 2022 19:48:59 +0100
From:   Will Deacon <will@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 00/24] KVM: arm64: Introduce pKVM shadow state at EL2
Message-ID: <20220720184859.GD16603@willie-the-truck>
References: <20220630135747.26983-1-will@kernel.org>
 <YsXfyVp6sg5XRVAp@google.com>
 <20220708162359.GA6286@willie-the-truck>
 <YtbXtI/lEnNL7fHQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtbXtI/lEnNL7fHQ@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Tue, Jul 19, 2022 at 04:11:32PM +0000, Sean Christopherson wrote:
> Apologies for the slow reply.

No problem; you've provided a tonne of insightful feedback here, so it was
worth the wait. Thanks!

> On Fri, Jul 08, 2022, Will Deacon wrote:
> > but I wanted to inherit the broader cc list so you were aware of this
> > break-away series. Sadly, I don't think beefing up the commit messages would
> > get us to a point where somebody unfamiliar with the EL2 code already could
> > give a constructive review, but we can try to expand them a bit if you
> > genuinely think it would help.
> 
> I'm not looking at it just from a review point, but also from a future readers
> perspective.  E.g. someone that looks at this changelog in isolation is going to
> have no idea what a "shadow VM" is:
> 
>   KVM: arm64: Introduce pKVM shadow VM state at EL2
> 
>   Introduce a table of shadow VM structures at EL2 and provide hypercalls
>   to the host for creating and destroying shadow VMs.
> 
> Obviously there will be some context available in surrounding patches, but if you
> avoid the "shadow" terminology and provide a bit more context, then it yields
> something like:
> 
>   KVM: arm64: Add infrastructure to create and track pKVM instances at EL2
> 
>   Introduce a global table (and lock) to track pKVM instances at EL2, and
>   provide hypercalls that can be used by the untrusted host to create and
>   destroy pKVM VMs.  pKVM VM/vCPU state is directly accessible only by the
>   trusted hypervisor (EL2).  
> 
>   Each pKVM VM is directly associated with an untrusted host KVM instance,
>   and is referenced by the host using an opaque handle.  Future patches will
>   provide hypercalls to allow the host to initialize/set/get pKVM VM/vCPU
>   state using the opaque handle.

Thanks, that's much better. I'll have to summon up the energy to go through
the others as well...

> > Perhaps we should s/shadow/hyp/ to make this a little clearer?
> 
> Or maybe just "pkvm"?

I think the "hyp" part is useful to distinguish the pkvm code running at EL2
from the pkvm code running at EL1. For example, we have a 'pkvm' member in
'struct kvm_arch' which is used by the _host_ at EL1.

So I'd say either "pkvm_hyp" or "hyp" instead of "shadow". The latter is
nice and short...

> I think that's especially viable if you do away with
> kvm_shadow_vcpu_state.  As of this series at least, kvm_shadow_vcpu_state is
> completely unnecessary.  kvm_vcpu.kvm can be used to get at the VM, and thus pKVM
> state via container_of().  Then the host_vcpu can be retrieved by using the
> vcpu_idx, e.g.
> 
> 	struct pkvm_vm *pkvm_vm = to_pkvm_vm(pkvm_vcpu->vm);
> 	struct kvm_vcpu *host_vcpu;
> 
> 	host_vcpu = kvm_get_vcpu(pkvm_vm->host_vm, pkvm_vcpu->vcpu_idx);

Using container_of() here is neat; we can definitely go ahead with that
change. However, looking at this in more detail with Fuad, removing
'struct kvm_shadow_vcpu_state' entirely isn't going to work:

> E.g. I believe you can make the code look like this:
> 
> struct kvm_arch {
> 	...
> 
> 	/*
> 	 * For an unstructed host VM, pkvm_handle is used to lookup the
> 	 * associated pKVM instance.
> 	 */
> 	pvk_handle_t pkvm_handle;
> };
> 
> struct pkvm_vm {
> 	struct kvm kvm;
> 
> 	/* Backpointer to the host's (untrusted) KVM instance. */
> 	struct kvm *host_kvm;
> 
> 	size_t donated_memory_size;
> 
> 	struct kvm_pgtable pgt;
> };
> 
> static struct kvm *pkvm_get_vm(pkvm_handle_t handle)
> {
> 	unsigned int idx = pkvm_handle_to_idx(handle);
> 
> 	if (unlikely(idx >= KVM_MAX_PVMS))
> 		return NULL;
> 
> 	return pkvm_vm_table[idx];
> }
> 
> struct kvm_vcpu *pkvm_vcpu_load(pkvm_handle_t handle, unsigned int vcpu_idx)
> {
> 	struct kvm_vpcu *pkvm_vcpu = NULL;
> 	struct kvm *vm;
> 
> 	hyp_spin_lock(&pkvm_global_lock);
> 	vm = pkvm_get_vm(handle);
> 	if (!vm || atomic_read(&vm->online_vcpus) <= vcpu_idx)
> 		goto unlock;
> 
> 	pkvm_vcpu = kvm_get_vcpu(vm, vcpu_idx);

kvm_get_vcpu() makes use of an xarray to hold the vCPUs pointers and this is
really something which we cannot support at EL2 where, amongst other things,
we do not have support for RCU. Consequently, we do need to keep our own
mapping from the shad^H^H^H^Hhyp vCPU to the host vCPU.

We also end up expanding the 'struct kvm_shadow_vcpu_state' structure later
to track additional vCPU state in the hypervisor, for example in the
mega-series:

https://lore.kernel.org/kvmarm/20220519134204.5379-78-will@kernel.org/#Z31arch:arm64:kvm:hyp:include:nvhe:pkvm.h

Cheers,

Will
