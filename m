Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C5357BF7B
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 23:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiGTVRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 17:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiGTVRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 17:17:10 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6905F23152
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 14:17:05 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id b10so7939648pjq.5
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 14:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NaR9N4OauE6F0T95oi/viHvYl6qf1E4qOLQi4oxNhhA=;
        b=mrbEd58TiGtptOCoPLCXhfpXmWL49rNjaSwJG208LF+R4TIixb2rVR7TzJRgou4fHW
         PipSq09eCo0Mdd49eis1z42PYzkWmgRH5uwqBWxE/6U3O2Cfy1tMn+94neVjuL8CrckM
         d+I2u9iLudGhmsEsmJ5ChL8udKBuh3TMg1ehs0ukp4KQXyvZ1LeC6yvR9DBMOh9FDtYv
         u3SwP/6g6zQIulQGL42uGaBJaP/+SEw+/pskUr69kQGUPbKss7VW6jqk7UhsspSMYMJC
         tHRCErtwKmKL/mlpbOWyDSNTXyILnlM/ZEHypjrEorKszAMp8Y8EspKW5UXDeawAN4RL
         4r8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NaR9N4OauE6F0T95oi/viHvYl6qf1E4qOLQi4oxNhhA=;
        b=jOlpHAYskUNFqBhwAmbsJ4I0b7kDx33fMAyUspB+qDgeUsqnSqqWxCqUZYuz9xaswG
         HzkHw52/J2tGSaCB+tdvZ1qqCpin4Mt04JA9jEv96QeU63drPgoVEcK8z+ri5vZwGIi8
         VvKMmqd7is7J25HQl+v43/UywCXLd1UqmeGNi0BSQmdyYr8Ii38FQyQs8xmxWewkPl6S
         q1xFoWHwUPan6Us6dE+CYQb6TrO2yK6LlQ5o3QWdfIiU8SC6dlsmcMsePy8P8z3xOKi7
         SlPvnSg0RGQdhq+Dh3NsNMmGbjcnYqpv1RyInhm4ussr3R/yrhHRfttvi/cxFk9tCBN/
         8XRg==
X-Gm-Message-State: AJIora8w/3frWh5pmDtrBfPMSOGPErwxK0UC4lkfeojFmBPYVEKpWfyZ
        RgOExBqVNd5Bc6117LbyA+AKNg==
X-Google-Smtp-Source: AGRyM1svtaT0JDNnzpkJnrm0ReeF5LwlQes8hUEBf/V2rbihL8ZE5dTWTWPWSE3br/M9nX23k69eog==
X-Received: by 2002:a17:902:a3cc:b0:16d:1af4:6359 with SMTP id q12-20020a170902a3cc00b0016d1af46359mr7373088plb.56.1658351824738;
        Wed, 20 Jul 2022 14:17:04 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id o10-20020a634e4a000000b00401a9bc0f33sm12131866pgl.85.2022.07.20.14.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 14:17:04 -0700 (PDT)
Date:   Wed, 20 Jul 2022 21:17:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Will Deacon <will@kernel.org>
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
Message-ID: <YthwzIS18mutjGhN@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <YsXfyVp6sg5XRVAp@google.com>
 <20220708162359.GA6286@willie-the-truck>
 <YtbXtI/lEnNL7fHQ@google.com>
 <20220720184859.GD16603@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720184859.GD16603@willie-the-truck>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022, Will Deacon wrote:
> Hi Sean,
> 
> On Tue, Jul 19, 2022 at 04:11:32PM +0000, Sean Christopherson wrote:
> > Or maybe just "pkvm"?
> 
> I think the "hyp" part is useful to distinguish the pkvm code running at EL2
> from the pkvm code running at EL1. For example, we have a 'pkvm' member in
> 'struct kvm_arch' which is used by the _host_ at EL1.

Right, my suggestion was to rename that to pkvm_handle to avoid a direct conflict,
and then that naturally yields the "pkvm_handle => pkvm_vm" association.  Or are
you expecting to shove more stuff into the that "pkvm" struct?
 
> So I'd say either "pkvm_hyp" or "hyp" instead of "shadow". The latter is
> nice and short...

I 100% agree that differentating between EL1 and EL2 is important for functions,
structs and global variables, but I would argue it's not so important for fields
and local variables where the "owning" struct/function provides that context.  But
that's actually a partial argument for just using "hyp".

My concern with just using e.g. "kvm_hyp" is that, because non-pKVM nVHE also has
the host vs. hyp split, it could lead people to believe that "kvm_hyp" is also
used for the non-pKVM case.

So, what about a blend?  E.g. "struct pkvm_hyp_vcpu *hyp_vcpu".  That provides
the context that the struct is specific to the EL2 side of pKVM, most usage is
nice and short, and the "hyp" prefix avoids the ambiguity that a bare "pkvm" would
suffer for EL1 vs. EL2.

Doesn't look awful?

static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
{
	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 1);
	int ret;

	host_vcpu = kern_hyp_va(host_vcpu);

	if (unlikely(is_protected_kvm_enabled())) {
		struct pkvm_hyp_vcpu *hyp_vcpu;
		struct kvm *host_kvm;

		host_kvm = kern_hyp_va(host_vcpu->kvm);

		hyp_vcpu = pkvm_load_hyp_vcpu(host_kvm->arch.pkvm.handle,
					      host_vcpu->vcpu_idx);
		if (!hyp_vcpu) {
			ret = -EINVAL;
			goto out;
		}

		flush_pkvm_guest_state(hyp_vcpu);

		ret = __kvm_vcpu_run(shadow_vcpu);

		sync_pkvm_guest_state(hyp_vcpu);

		pkvm_put_hyp_vcpu(shadow_state);
	} else {
		/* The host is fully trusted, run its vCPU directly. */
		ret = __kvm_vcpu_run(host_vcpu);
	}

out:
	cpu_reg(host_ctxt, 1) =  ret;
}

	
 
> > I think that's especially viable if you do away with
> > kvm_shadow_vcpu_state.  As of this series at least, kvm_shadow_vcpu_state is
> > completely unnecessary.  kvm_vcpu.kvm can be used to get at the VM, and thus pKVM
> > state via container_of().  Then the host_vcpu can be retrieved by using the
> > vcpu_idx, e.g.
> > 
> > 	struct pkvm_vm *pkvm_vm = to_pkvm_vm(pkvm_vcpu->vm);
> > 	struct kvm_vcpu *host_vcpu;
> > 
> > 	host_vcpu = kvm_get_vcpu(pkvm_vm->host_vm, pkvm_vcpu->vcpu_idx);
> 
> Using container_of() here is neat; we can definitely go ahead with that
> change. However, looking at this in more detail with Fuad, removing
> 'struct kvm_shadow_vcpu_state' entirely isn't going to work:

> > struct kvm_vcpu *pkvm_vcpu_load(pkvm_handle_t handle, unsigned int vcpu_idx)
> > {
> > 	struct kvm_vpcu *pkvm_vcpu = NULL;
> > 	struct kvm *vm;
> > 
> > 	hyp_spin_lock(&pkvm_global_lock);
> > 	vm = pkvm_get_vm(handle);
> > 	if (!vm || atomic_read(&vm->online_vcpus) <= vcpu_idx)
> > 		goto unlock;
> > 
> > 	pkvm_vcpu = kvm_get_vcpu(vm, vcpu_idx);
> 
> kvm_get_vcpu() makes use of an xarray to hold the vCPUs pointers and this is
> really something which we cannot support at EL2 where, amongst other things,
> we do not have support for RCU. Consequently, we do need to keep our own
> mapping from the shad^H^H^H^Hhyp vCPU to the host vCPU.

Hmm, are there guardrails in place to prevent using "unsafe" fields from "struct kvm"
and "struct kvm_vcpu" at EL2?  If not, it seems like embedding the common structs
in the hyp/pkvm-specific structs is going bite us in the rear at some point.

Mostly out of curiosity, I assume the EL2 restriction only applies to nVHE mode?

And waaaay off topic, has anyone explored adding macro magic to generate wrappers
to (un)marshall registers to parameters/returns for the hyp functions?  E.g. it'd
be neat if you could make the code look like this without having to add a wrapper
for every function:

static int handle___kvm_vcpu_run(unsigned long __host_vcpu)
{
	struct kvm_vcpu *host_vcpu = kern_hyp_va(__host_vcpu);
	int ret;

	if (unlikely(is_protected_kvm_enabled())) {
		struct pkvm_hyp_vcpu *hyp_vcpu;
		struct kvm *host_kvm;

		host_kvm = kern_hyp_va(host_vcpu->kvm);

		hyp_vcpu = pkvm_load_hyp_vcpu(host_kvm->arch.pkvm.handle,
					      host_vcpu->vcpu_idx);
		if (!hyp_vcpu)
			return -EINVAL;

		flush_hypervisor_state(hyp_vcpu);

		ret = __kvm_vcpu_run(shadow_vcpu);

		sync_hypervisor_state(hyp_vcpu);
		pkvm_put_hyp_vcpu(shadow_state);
	} else {
		/* The host is fully trusted, run its vCPU directly. */
		ret = __kvm_vcpu_run(host_vcpu);
	}
	return ret;
}
