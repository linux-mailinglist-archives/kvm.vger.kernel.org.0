Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA346C3041
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 12:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjCULWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 07:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjCULWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 07:22:16 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19AD498B4;
        Tue, 21 Mar 2023 04:21:41 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id j11so18600791lfg.13;
        Tue, 21 Mar 2023 04:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679397699; x=1681989699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uoj6FCTyIPYbsFB5rJ42Dq7STG9j1TgfTfZlYEk8Sgk=;
        b=Jlq4oSD6AonPaeW/84Mh0G2R75J7skPB7leE2fkyeIQ3Z+LuE+DzxR2NHCq0cr72BJ
         fa8weee6OgtFNlZgnWeztPNBsknxKtAe8LA72glyHGDk1Kjtzkf0VI9wWaHzR/6HT81X
         wa7DtoRQEVBpF+PN9nc3c5hdnn94tRKUpYtkmAcwJpV9MinaSrg3rvl6jJSG/+OayG1e
         stXojfFbTfajHJEFwu39eJacf//zjBiwTIozAmJmxOQlaZSZ9l0+9/ylDeJBcDsHIBJU
         kSrMFxdSd2EQGfStequq70RCoV+zsORs64i9qDjtKioBqWQlatL4IbComMy07E2jQjlS
         slng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679397699; x=1681989699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uoj6FCTyIPYbsFB5rJ42Dq7STG9j1TgfTfZlYEk8Sgk=;
        b=3c0iSa7MaUeyJ9hoyZMlnTSZd5AKXaeh2BFSaKmKHjYe5v7BwNnVWAjRkV84aHbLw4
         by5xfXNAeEVq4dHAm/hnsDCUhj5NyKUXxKtHtcDkLDfWLfUnza0YvP4iYLHZaVu6GUWN
         EYabVG5d5JdodRIeKaILBpRlN6qOab358lq1y2aedpeCQUp9A3rrbivF6brV1V7H1FBa
         AE+mXM3/xtdXXG8AX4O27BLGGJem69ewLbSvxUtxfES5fgz7pJ73J38ngTfkZsnjvWSE
         kptedTSHKVxXwtkqiR1Bl0WgwNTL/YCJ/4dnDmZvOnFkHOvORqbY71AoWZ+kPiiz3tqB
         Ol9Q==
X-Gm-Message-State: AO0yUKWVXcxtUGSuNSAAPSphLjWpfoWjeGBv3IZFaMc2bQNHwwqCbaxp
        oJLiZDqgcduGbBmhaUOiR0A=
X-Google-Smtp-Source: AK7set9bY/lyZSGlVklHq9mvTnu5/lAB25Bco255g2AVLzu76Lg82+AplHYe7EPwKFdh0BWGqavn+Q==
X-Received: by 2002:a19:5502:0:b0:4e7:ed3c:68ec with SMTP id n2-20020a195502000000b004e7ed3c68ecmr561246lfe.3.1679397698595;
        Tue, 21 Mar 2023 04:21:38 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id l12-20020a19c20c000000b004e9b42d778esm1217900lfc.26.2023.03.21.04.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 04:21:38 -0700 (PDT)
Date:   Tue, 21 Mar 2023 13:21:36 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>, <kvm@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: Re: [PATCH RFC v8 02/56] KVM: x86: Add 'update_mem_attr' x86 op
Message-ID: <20230321132136.00005234@gmail.com>
In-Reply-To: <20230320180543.ly4jgu54hyamy2gl@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-3-michael.roth@amd.com>
        <20230318045611.GE408922@ls.amr.corp.intel.com>
        <20230320180543.ly4jgu54hyamy2gl@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Mar 2023 13:05:43 -0500
Michael Roth <michael.roth@amd.com> wrote:

> On Fri, Mar 17, 2023 at 09:56:11PM -0700, Isaku Yamahata wrote:
> > On Mon, Feb 20, 2023 at 12:37:53PM -0600,
> > Michael Roth <michael.roth@amd.com> wrote:
> >   
> > > This callback will do any platform-specific handling needed for
> > > converting pages between shared/private.
> > > 
> > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > ---
> > >  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> > >  arch/x86/include/asm/kvm_host.h    |  2 ++
> > >  arch/x86/kvm/mmu/mmu.c             | 13 +++++++++++++
> > >  include/linux/kvm_host.h           |  4 ++++
> > >  virt/kvm/kvm_main.c                | 29 +++++++++++++++++++++++++++++
> > >  5 files changed, 49 insertions(+)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > > index 72183da010b8..a8aaf532c2ab 100644
> > > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > > @@ -132,6 +132,7 @@ KVM_X86_OP(complete_emulated_msr)
> > >  KVM_X86_OP(vcpu_deliver_sipi_vector)
> > >  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> > >  KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
> > > +KVM_X86_OP_OPTIONAL_RET0(update_mem_attr)
> > >  
> > >  #undef KVM_X86_OP
> > >  #undef KVM_X86_OP_OPTIONAL
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index f856d689dda0..2da3fb2d5d1b 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1644,6 +1644,8 @@ struct kvm_x86_ops {
> > >  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> > >  			     int root_level);
> > >  	bool (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
> > > +	int (*update_mem_attr)(struct kvm_memory_slot *slot, unsigned int attr,
> > > +			       gfn_t start, gfn_t end);
> > >  
> > >  	bool (*has_wbinvd_exit)(void);
> > >  
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index fb3f34b7391c..053bd77bbf52 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -7251,4 +7251,17 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
> > >  		linfo_update_mixed(gfn, slot, level, mixed);
> > >  	}
> > >  }
> > > +
> > > +void kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> > > +					 struct kvm_memory_slot *slot,
> > > +					 unsigned long attrs,
> > > +					 gfn_t start, gfn_t end)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = static_call(kvm_x86_update_mem_attr)(slot, attrs, start, end);
> > > +	if (ret)
> > > +		pr_warn_ratelimited("Failed to update GFN range 0x%llx-0x%llx with attributes 0x%lx. Ret: %d\n",
> > > +				    start, end, attrs, ret);
> > > +}
> > >  #endif
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index fdc59479b3e2..d200b8f45583 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -2330,6 +2330,10 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
> > >  				    struct kvm_memory_slot *slot,
> > >  				    unsigned long attrs,
> > >  				    gfn_t start, gfn_t end);
> > > +void kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> > > +					 struct kvm_memory_slot *slot,
> > > +					 unsigned long attrs,
> > > +					 gfn_t start, gfn_t end);
> > >  
> > >  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> > >  {
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index b68574ff6c30..8ec985f1c57d 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -2561,6 +2561,32 @@ static void kvm_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
> > >  		kvm_flush_remote_tlbs(kvm);
> > >  }
> > >  
> > > +static void kvm_post_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
> > > +				       gfn_t start_orig, gfn_t end_orig)
> > > +{
> > > +	struct kvm_memory_slot *slot;
> > > +	struct kvm_memslots *slots;
> > > +	struct kvm_memslot_iter iter;
> > > +	int i;
> > > +
> > > +	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
> > > +		slots = __kvm_memslots(kvm, i);
> > > +
> > > +		kvm_for_each_memslot_in_gfn_range(&iter, slots, start_orig, end_orig) {
> > > +			gfn_t start, end;
> > > +
> > > +			slot = iter.slot;
> > > +			start = max(start_orig, slot->base_gfn);
> > > +			end = min(end_orig, slot->base_gfn + slot->npages);
> > > +
> > > +			if (start >= end)
> > > +				continue;
> > > +
> > > +			kvm_arch_post_set_memory_attributes(kvm, slot, attrs, start, end);
> > > +		}
> > > +	}
> > > +}
> > > +
> > >  static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> > >  					   struct kvm_memory_attributes *attrs)
> > >  {
> > > @@ -2602,6 +2628,9 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> > >  	kvm_mmu_invalidate_end(kvm);
> > >  	KVM_MMU_UNLOCK(kvm);
> > >  
> > > +	if (i > start)
> > > +		kvm_post_mem_attrs_changed(kvm, attrs->attributes, start, i);
> > > +  
> > 
> > Doesn't kvm_arch_set_memory_attributes() work for you? i.e the following patch.
> > The error check and pr_warn_ratelimited() can be pushed down into the callback.  
> 
> This is originally how I had but when CONFIG_PREEMPT_COUNT is set this
> will generate warnings for this callback as well as the invalidation
> callback as reported in v7 here:
> 
>   https://lore.kernel.org/lkml/Y80vhKwQyw8hS%2F22@notebook/
> 
> The main issue is that kvm_mem_attrs_changed() is called while holding
> the KVM MMU lock, which disables preemption. But when updating
> attributes for SNP, we also need to remove private pages from kernel
> directmap, which involves acquiring a mutex which results in
> "BUG: scheduling while atomic" warnings.
> 
> So that's why we ended up somewhat duplicating some of the logic and
> using a separate callback chain that happens out of KVM MMU lock.

Let's split the things of changing memory attributes:

1) Update the memory attributes in the xa array (Both TDX and SNP)
2) Zapping the EPT/NPT mappings (Required by TDX)
3) Update RMP table (Required by SNP)
4) Update the directmap of kernel (SNP, but I guess TDX needs it as well)

Does SNP really need to zap the NPT mappings when changing the memory
attributes? (The new mappings will be created later in the fault). I don't
find this requirement from APM.

If yes, can we postpone the update of the RMP table in the later fault,
like TDX? So that we can save this update_mem_attr x86 ops as things
will be solved in the SNP-specific fault handler.

If no, guess we need a x86 ops to tell if a zapping is required.

Back to the lock, updating RMP table doesn't require a mutex. Taking
the lock is required when updating the directmap. both TDX/SNP requires
this update the directmap when changing memory attributes.

Wouldn't it better to factor the touching directmap of kernel part out?

Then you can call the x86 ops.update_mem_attr() in kvm_mem_attrs_changed().
And update the direct kernel mapping for both TDX/SNP in the
kvm_post_mem_attrs_changed().

> 
> -Mike
> 
> > 
> > From 7c618c1f3c236c382e64680efcbe7d8a672aa870 Mon Sep 17 00:00:00 2001
> > Message-Id: <7c618c1f3c236c382e64680efcbe7d8a672aa870.1679114841.git.isaku.yamahata@intel.com>
> > In-Reply-To: <428a676face7a06a90e59dca1c32941c9b6ee001.1679114841.git.isaku.yamahata@intel.com>
> > References: <428a676face7a06a90e59dca1c32941c9b6ee001.1679114841.git.isaku.yamahata@intel.com>
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > Date: Fri, 17 Mar 2023 12:00:09 -0700
> > Subject: [PATCH 4/4] KVM: x86: Add 'set_mem_attr' x86 op
> > 
> > This callback will do any platform-specific handling needed for
> > converting pages between shared/private.
> > 
> > Originally-by: Michael Roth <michael.roth@amd.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-ops.h | 1 +
> >  arch/x86/include/asm/kvm_host.h    | 2 ++
> >  arch/x86/kvm/mmu/mmu.c             | 1 +
> >  3 files changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index dc5f18ac0bd5..956db2ee25a5 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -100,6 +100,7 @@ KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> >  KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
> >  KVM_X86_OP(load_mmu_pgd)
> >  KVM_X86_OP(fault_is_private)
> > +KVM_X86_OP_OPTIONAL(set_mem_attr)
> >  KVM_X86_OP_OPTIONAL(link_private_spt)
> >  KVM_X86_OP_OPTIONAL(free_private_spt)
> >  KVM_X86_OP_OPTIONAL(split_private_spt)
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 0382d236fbf4..88e11dd3afde 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
> >  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> >  			     int root_level);
> >  	bool (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code);
> > +	void (*set_mem_attr)(struct kvm *kvm, struct kvm_memory_slot *slot,
> > +			     unsigned int attr, gfn_t start, gfn_t end);
> >  
> >  	int (*link_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> >  				void *private_spt);
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 0ec94c72895c..329333486e64 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -7908,6 +7908,7 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
> >  				    gfn_t start, gfn_t end)
> >  {
> >  	kvm_update_lpage_mixed_flag(kvm, slot, true, attrs, start, end);
> > +	static_call(kvm_x86_set_mem_attr)(kvm, slot, attrs, start, end);
> >  }
> >  
> >  void kvm_memory_attributes_create_memslot(struct kvm *kvm,
> > -- 
> > 2.25.1
> > 
> > -- 
> > Isaku Yamahata <isaku.yamahata@gmail.com>  

