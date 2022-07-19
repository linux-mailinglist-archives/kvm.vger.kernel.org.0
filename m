Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4AC57A3F9
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 18:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238218AbiGSQLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 12:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbiGSQLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 12:11:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72894C623
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 09:11:37 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id z12-20020a17090a7b8c00b001ef84000b8bso21869378pjc.1
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 09:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4S78VtofUWZcLD3smu3YQaQ6ipdIwnYqA0VG5V6it8o=;
        b=O78k5k7gAgtOSwNcRElQY19y0b/kSOwc4EZJpIS00juXi0rosYm/cZoye3UiJ2o/VC
         BKwrAgka3yoZh6ahASkVbkBt+8CddQ3MGGfpEJCx/fxvTqWhyL9Jd+O992nzpmevzPo8
         yaD8bzMMY0i5trzRFIHUTD4Jv52SHF+QHHtNX9M7+yCSAZ49kv3jnfTfvZO50sgyJEh0
         ZK5sQQ02ZpFMW4kL8EbTuct9M10OU7xXuwTAlzD0xXUuL2wpLEle8iYLkfp4jtRzZvxa
         ftvYA7pOHoMVhMH7aEv3C35pS+aTyTYEBpa8BY2IKTbHInrq4nV9MkZYfPkeW8IIR9R+
         pUlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4S78VtofUWZcLD3smu3YQaQ6ipdIwnYqA0VG5V6it8o=;
        b=oPcyNf6xqpWy7pkcjpSLQ1wv5c02kM24rRJyehETiy4+Ubt4wfQjiQ3l5014bfgDs6
         LS2de0n8uEXpuFeyz04ES9YQaZymbmXhQc7pKLND2rIBT7fZns+Nbx08IQV8wJ9pYbqZ
         X30CPVKFAywfRueODBi1gzVIthAuE7SLtODX+EbalSFfgXK0hvVbXekp/PT+7PBuoGBs
         OmXwih0BlxXYGwOOSOuD8J09kAQ6IfgnUO+sV1mOsrC8xHFr3hWc9KRN4O/Rl9KqvPME
         P1wS8PPaBEhzr59FhYGsQgt4+Lsl6i480FtHxWsDQ6YRw5TnnzvUiaoTRAK1C0OjsfbU
         RAOw==
X-Gm-Message-State: AJIora9UOR/4bL+uJeAFuqE0ZorPyAfAVxSN+/FuR+ouzK/8CATvDmdK
        6sfHbpUt81ni4DTyS7U32LoSfA==
X-Google-Smtp-Source: AGRyM1vUyro/iAOLLyROK/nb8SXYB7YRLZ3NilG4bW5+YlrVQjdinO4SPE5yLuAIW46BwikQbfPCVA==
X-Received: by 2002:a17:902:ba84:b0:16d:b62:bc6e with SMTP id k4-20020a170902ba8400b0016d0b62bc6emr3780986pls.148.1658247096916;
        Tue, 19 Jul 2022 09:11:36 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id k6-20020aa79986000000b00528c22038f5sm12136083pfh.14.2022.07.19.09.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 09:11:36 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:11:32 +0000
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
Message-ID: <YtbXtI/lEnNL7fHQ@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <YsXfyVp6sg5XRVAp@google.com>
 <20220708162359.GA6286@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708162359.GA6286@willie-the-truck>
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

Apologies for the slow reply.

On Fri, Jul 08, 2022, Will Deacon wrote:
> On Wed, Jul 06, 2022 at 07:17:29PM +0000, Sean Christopherson wrote:
> > On Thu, Jun 30, 2022, Will Deacon wrote:
> > The lack of documentation and the rather terse changelogs make this really hard
> > to review for folks that aren't intimately familiar with pKVM.  I have a decent
> > idea of the end goal of "shadowing", but that's mostly because of my involvement in
> > similar x86 projects.  Nothing in the changelogs ever explains _why_ pKVM uses
> > shadows.
> 
> That's understandable, but thanks for persevering; this series is pretty
> down in the murky depths of the arm64 architecture and EL2 code so it
> doesn't really map to the KVM code most folks are familiar with. It's fair
> to say we're assuming a lot of niche prior knowledge (which is quite common
> for arch code in my experience),

Assuming prior knowledge is fine so long as that prior knowledge is something
that can be gained by future readers through public documentation.  E.g. arch code
is always littered with acronyms, but someone can almost always decipher the
acronyms by reading specs or just searching the interwebs.

My objection to the changelogs is that they talk about "shadow" VMs, vCPUs, state,
structures, etc., without ever explaining what a shadow is, how it will be used,
or what its end purpose is.

A big part of the problem is that "shadow" is not unique terminology _and_ isn't
inherently tied to "protected kvm", e.g. a reader can't intuit that a "shadow vm"
is the the trusted hypervisors instance of the VM.  And I can search for pKVM and
get relevant, helpful search results.  But if I search for "shadow vm", I get
unrelated results, and "pkvm shadow vm" just leads me back to this series.

> but I wanted to inherit the broader cc list so you were aware of this
> break-away series. Sadly, I don't think beefing up the commit messages would
> get us to a point where somebody unfamiliar with the EL2 code already could
> give a constructive review, but we can try to expand them a bit if you
> genuinely think it would help.

I'm not looking at it just from a review point, but also from a future readers
perspective.  E.g. someone that looks at this changelog in isolation is going to
have no idea what a "shadow VM" is:

  KVM: arm64: Introduce pKVM shadow VM state at EL2

  Introduce a table of shadow VM structures at EL2 and provide hypercalls
  to the host for creating and destroying shadow VMs.

Obviously there will be some context available in surrounding patches, but if you
avoid the "shadow" terminology and provide a bit more context, then it yields
something like:

  KVM: arm64: Add infrastructure to create and track pKVM instances at EL2

  Introduce a global table (and lock) to track pKVM instances at EL2, and
  provide hypercalls that can be used by the untrusted host to create and
  destroy pKVM VMs.  pKVM VM/vCPU state is directly accessible only by the
  trusted hypervisor (EL2).  

  Each pKVM VM is directly associated with an untrusted host KVM instance,
  and is referenced by the host using an opaque handle.  Future patches will
  provide hypercalls to allow the host to initialize/set/get pKVM VM/vCPU
  state using the opaque handle.
   
> On the more positive side, we'll be speaking at KVM forum about what we've
> done here, so that will be a great place to discuss it further and then we
> can also link back to the recordings in later postings of the mega-series.
> 
> > I put "shadowing" in quotes because if the unstrusted host is aware that the VM
> > and vCPU it is manipulating aren't the "real" VMs/vCPUs, and there is an explicit API
> > between the untrusted host and pKVM for creating/destroying VMs/vCPUs, then I would
> > argue that it's not truly shadowing, especially if pKVM uses data/values verbatim
> > and only verifies correctness/safety.  It's definitely a nit, but for future readers
> > I think overloading "shadowing" could be confusing.
> 
> Ah, this is really interesting and nicely puts the ball back in my court as
> I'm not well versed with x86's use of "shadowing".

It's not just an x86, e.g. see https://en.wikipedia.org/wiki/Shadow_table.  The
use in pKVM is _really_ close in that what pKVM calls the shadow is the "real"
data that's used, but pKVM inverts the typical virtualization usage, which is
why I find it confusing.  I.e. instead of shadowing state being written by the
guest, pKVM is "shadowing" state written by the host.  If there ever comes a need
to actually shadow guest state, e.g. for nested virtualization, then using shadow
to refer to the protected state is going to create a conundrum.

Honestly, I think pKVM is simply being too cute in picking names.  And not just
for "shadow", e.g. IMO the flush/sync terminology in patch 24 is also unnecessarily
cute.  Instead of coming up with clever names, just be explicit in what the code
is doing.  E.g. something like:

  flush_shadow_state() => sync_host_to_pkvm_vcpu()
  sync_shadow_state()  => sync_pkvm_to_host_vcpu()

Then readers know the two functions are pairs, and will have a decent idea of
what the functions do even if they don't fully understand pKVM vs. host.

"shadow_area_size" is another case where it's unnecessarily cryptic, e.g. just
call it "donated_memory_size".

> Perhaps we should s/shadow/hyp/ to make this a little clearer?

Or maybe just "pkvm"?  I think that's especially viable if you do away with
kvm_shadow_vcpu_state.  As of this series at least, kvm_shadow_vcpu_state is
completely unnecessary.  kvm_vcpu.kvm can be used to get at the VM, and thus pKVM
state via container_of().  Then the host_vcpu can be retrieved by using the
vcpu_idx, e.g.

	struct pkvm_vm *pkvm_vm = to_pkvm_vm(pkvm_vcpu->vm);
	struct kvm_vcpu *host_vcpu;

	host_vcpu = kvm_get_vcpu(pkvm_vm->host_vm, pkvm_vcpu->vcpu_idx);

Even better is to not have to do that in the first place.  AFAICT, there's no need
to do such a lookup in handle___kvm_vcpu_run() since pKVM already has pointers to
both the host vCPU and the pKVM vCPU.

E.g. I believe you can make the code look like this:

struct kvm_arch {
	...

	/*
	 * For an unstructed host VM, pkvm_handle is used to lookup the
	 * associated pKVM instance.
	 */
	pvk_handle_t pkvm_handle;
};

struct pkvm_vm {
	struct kvm kvm;

	/* Backpointer to the host's (untrusted) KVM instance. */
	struct kvm *host_kvm;

	size_t donated_memory_size;

	struct kvm_pgtable pgt;
};

static struct kvm *pkvm_get_vm(pkvm_handle_t handle)
{
	unsigned int idx = pkvm_handle_to_idx(handle);

	if (unlikely(idx >= KVM_MAX_PVMS))
		return NULL;

	return pkvm_vm_table[idx];
}

struct kvm_vcpu *pkvm_vcpu_load(pkvm_handle_t handle, unsigned int vcpu_idx)
{
	struct kvm_vpcu *pkvm_vcpu = NULL;
	struct kvm *vm;

	hyp_spin_lock(&pkvm_global_lock);
	vm = pkvm_get_vm(handle);
	if (!vm || atomic_read(&vm->online_vcpus) <= vcpu_idx)
		goto unlock;

	pkvm_vcpu = kvm_get_vcpu(vm, vcpu_idx);
	hyp_page_ref_inc(hyp_virt_to_page(vm));
unlock:
	hyp_spin_unlock(&pkvm_global_lock);
	return pkvm_vcpu;
}

struct kvm_vcpu *pkvm_vcpu_put(struct kvm_vcpu *pkvm_vcpu)
{
	hyp_spin_lock(&pkvm_global_lock);
	hyp_page_ref_dec(hyp_virt_to_page(pkvm_vcpu->kvm));
	hyp_spin_unlock(&pkvm_global_lock);
}

static void sync_host_to_pkvm_vcpu(struct kvm_vcpu *pkvm_vcpu, struct kvm_vcpu *host_vcpu)
{
	pkvm_vcpu->arch.ctxt		= host_vcpu->arch.ctxt;

	pkvm_vcpu->arch.sve_state	= kern_hyp_va(host_vcpu->arch.sve_state);
	pkvm_vcpu->arch.sve_max_vl	= host_vcpu->arch.sve_max_vl;

	pkvm_vcpu->arch.hw_mmu		= host_vcpu->arch.hw_mmu;

	pkvm_vcpu->arch.hcr_el2		= host_vcpu->arch.hcr_el2;
	pkvm_vcpu->arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
	pkvm_vcpu->arch.cptr_el2	= host_vcpu->arch.cptr_el2;

	pkvm_vcpu->arch.iflags		= host_vcpu->arch.iflags;
	pkvm_vcpu->arch.fp_state	= host_vcpu->arch.fp_state;

	pkvm_vcpu->arch.debug_ptr	= kern_hyp_va(host_vcpu->arch.debug_ptr);
	pkvm_vcpu->arch.host_fpsimd_state = host_vcpu->arch.host_fpsimd_state;

	pkvm_vcpu->arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;

	pkvm_vcpu->arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
}

static void sync_pkvm_to_host_vcpu(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *pkvm_vcpu)
{
	struct vgic_v3_cpu_if *pkvm_cpu_if = &pkvm_vcpu->arch.vgic_cpu.vgic_v3;
	struct vgic_v3_cpu_if *host_cpu_if = &host_vcpu->arch.vgic_cpu.vgic_v3;
	unsigned int i;

	host_vcpu->arch.ctxt		= pkvm_vcpu->arch.ctxt;

	host_vcpu->arch.hcr_el2		= pkvm_vcpu->arch.hcr_el2;
	host_vcpu->arch.cptr_el2	= pkvm_vcpu->arch.cptr_el2;

	host_vcpu->arch.fault		= pkvm_vcpu->arch.fault;

	host_vcpu->arch.iflags		= pkvm_vcpu->arch.iflags;
	host_vcpu->arch.fp_state	= pkvm_vcpu->arch.fp_state;

	host_cpu_if->vgic_hcr		= pkvm_cpu_if->vgic_hcr;
	for (i = 0; i < pkvm_cpu_if->used_lrs; ++i)
		host_cpu_if->vgic_lr[i] = pkvm_cpu_if->vgic_lr[i];
}

static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
{
	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 1);
	int ret;

	host_vcpu = kern_hyp_va(host_vcpu);

	if (unlikely(is_protected_kvm_enabled())) {
		struct kvm *host_kvm = kern_hyp_va(host_vcpu->kvm);
		struct kvm_vcpu *pkvm_vcpu;

		pkvm_vcpu = pkvm_vcpu_load(host_kvm, host_vcpu);
		if (!pkvm_vcpu) {
			ret = -EINVAL;
			goto out;
		}

		sync_host_to_pkvm_vcpu(pkvm_vcpu, host_vcpu);

		ret = __kvm_vcpu_run(pkvm_vcpu);

		sync_pkvm_to_host_vcpu(host_vcpu, pkvm_vcpu);

		pkvm_vcpu_put(pkvm_vcpu);
	} else {
		ret = __kvm_vcpu_run(host_vcpu);
	}

out:
	cpu_reg(host_ctxt, 1) =  ret;
}
