Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB71F675F90
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 22:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjATVUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 16:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjATVUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 16:20:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C80EC55;
        Fri, 20 Jan 2023 13:20:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57E76B829FB;
        Fri, 20 Jan 2023 21:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A04EC433EF;
        Fri, 20 Jan 2023 21:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674249633;
        bh=F8IpSOi2yAsoDoJtoZ+I9NR2c/7qvXeB0K1/DdBRsNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ND9fVSSJQ8Sdt6aDyGMKj6L0Pk+kfUC0xhp9OzbiQ/MwP1P2i/fY/4x70eG08kFP+
         FP/JzlzKcIwTfDuYnjZkj5Apjc+uSXOxq1vvelxt/4Ru+uzopag4DNPO/Uywaq4FLI
         lPR8GD0GpVv1bwxvW1lMIcOpGlQsaqt4wEXyFmu4X+WYIhVm5t4VVaqt2LvnsTH8Aq
         vdMcLamh7xyew6Ujc02MhTwLFJTdt4CNomQaoE9IZOdVBfZy4CVVFykaoBSy7eaDGz
         7YP9emKOeK3RyjYyuyu0uf1e05N12b5TcHPsvFPQ0rKucbHZdxWZrw1dR5YHVEueVt
         bJ8MVSTtdE8Gw==
Date:   Fri, 20 Jan 2023 21:20:30 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Michael Roth <michael.roth@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, ashish.kalra@amd.com,
        harald@profian.com, Nikunj A Dadhania <nikunj@amd.com>,
        chao.p.peng@linux.intel.com
Subject: Re: [PATCH RFC v7 03/64] KVM: SVM: Advertise private memory support
 to KVM
Message-ID: <Y8sFnsk2GvnUCVFI@kernel.org>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-4-michael.roth@amd.com>
 <Y6Xd0ruz3kMij/5F@zn.tnic>
 <20230105021419.rs23nfq44rv64tsd@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105021419.rs23nfq44rv64tsd@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 04, 2023 at 08:14:19PM -0600, Michael Roth wrote:
> On Fri, Dec 23, 2022 at 05:56:50PM +0100, Borislav Petkov wrote:
> > On Wed, Dec 14, 2022 at 01:39:55PM -0600, Michael Roth wrote:
> > > +       bool (*private_mem_enabled)(struct kvm *kvm);
> > 
> > This looks like a function returning boolean to me. IOW, you can
> > simplify this to:
> 
> The semantics and existing uses of KVM_X86_OP_OPTIONAL_RET0() gave me the
> impression it needed to return an integer value, since by default if a
> platform doesn't implement the op it would "return 0", and so could
> still be called unconditionally.
> 
> Maybe that's not actually enforced, by it seems awkward to try to use a
> bool return instead. At least for KVM_X86_OP_OPTIONAL_RET0().
> 
> However, we could just use KVM_X86_OP() to declare it so we can cleanly
> use a function that returns bool, and then we just need to do:
> 
>   bool kvm_arch_has_private_mem(struct kvm *kvm)
>   {
>           if (kvm_x86_ops.private_mem_enabled)
>                   return static_call(kvm_x86_private_mem_enabled)(kvm);

I guess this is missing:

        return false;

>   }
>     
> instead of relying on default return value. So I'll take that approach
> and adopt your other suggested changes.
> 
> ...
> 
> On a separate topic though, at a high level, this hook is basically a way
> for platform-specific code to tell generic KVM code that private memslots
> are supported by overriding the kvm_arch_has_private_mem() weak
> reference. In this case the AMD platform is using using kvm->arch.upm_mode
> flag to convey that, which is in turn set by the
> KVM_CAP_UNMAPPED_PRIVATE_MEMORY introduced in this series.
> 
> But if, as I suggested in response to your PATCH 2 comments, we drop
> KVM_CAP_UNAMMPED_PRIVATE_MEMORY in favor of
> KVM_SET_SUPPORTED_MEMORY_ATTRIBUTES ioctl to enable "UPM mode" in SEV/SNP
> code, then we need to rethink things a bit, since KVM_SET_MEMORY_ATTRIBUTES
> in-part relies on kvm_arch_has_private_mem() to determine what flags are
> supported, whereas SEV/SNP code would be using what was set by
> KVM_SET_MEMORY_ATTRIBUTES to determine the return value in
> kvm_arch_has_private_mem().

Does this mean that internal calls to  kvm_vm_set_region_attr() will
cease to exist, and it will rely for user space to use the ioctl
properly instead?

> So, for AMD, the return value of kvm_arch_has_private_mem() needs to rely
> on something else. Maybe the logic can just be:
> 
>   bool svm_private_mem_enabled(struct kvm *kvm)
>   {
>     return sev_enabled(kvm) || sev_snp_enabled(kvm)
>   }
> 
> (at least in the context of this patchset where UPM support is added for
> both SEV and SNP).
> 
> So I'll plan to make that change as well.
> 
> -Mike
> 
> > 
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index 82ba4a564e58..4449aeff0dff 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -129,6 +129,7 @@ KVM_X86_OP(msr_filter_changed)
> >  KVM_X86_OP(complete_emulated_msr)
> >  KVM_X86_OP(vcpu_deliver_sipi_vector)
> >  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> > +KVM_X86_OP_OPTIONAL_RET0(private_mem_enabled);
> >  
> >  #undef KVM_X86_OP
> >  #undef KVM_X86_OP_OPTIONAL
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 1da0474edb2d..1b4b89ddeb55 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1574,6 +1574,7 @@ struct kvm_x86_ops {
> >  
> >  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> >  			     int root_level);
> > +	bool (*private_mem_enabled)(struct kvm *kvm);
> >  
> >  	bool (*has_wbinvd_exit)(void);
> >  
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index ce362e88a567..73b780fa4653 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4680,6 +4680,14 @@ static int svm_vm_init(struct kvm *kvm)
> >  	return 0;
> >  }
> >  
> > +static bool svm_private_mem_enabled(struct kvm *kvm)
> > +{
> > +	if (sev_guest(kvm))
> > +		return kvm->arch.upm_mode;
> > +
> > +	return IS_ENABLED(CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING);
> > +}
> > +
> >  static struct kvm_x86_ops svm_x86_ops __initdata = {
> >  	.name = "kvm_amd",
> >  
> > @@ -4760,6 +4768,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >  
> >  	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
> >  
> > +	.private_mem_enabled = svm_private_mem_enabled,
> > +
> >  	.has_wbinvd_exit = svm_has_wbinvd_exit,
> >  
> >  	.get_l2_tsc_offset = svm_get_l2_tsc_offset,
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 823646d601db..9a1ca59d36a4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12556,6 +12556,11 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
> >  }
> >  EXPORT_SYMBOL_GPL(__x86_set_memory_region);
> >  
> > +bool kvm_arch_has_private_mem(struct kvm *kvm)
> > +{
> > +	return static_call(kvm_x86_private_mem_enabled)(kvm);
> > +}
> > +
> >  void kvm_arch_pre_destroy_vm(struct kvm *kvm)
> >  {
> >  	kvm_mmu_pre_destroy_vm(kvm);
> > 
> > -- 
> > Regards/Gruss,
> >     Boris.
> > 
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpeople.kernel.org%2Ftglx%2Fnotes-about-netiquette&data=05%7C01%7Cmichael.roth%40amd.com%7C319e89ce555a46eace4d08dae506b51a%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638074114318137471%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=aG11K7va1BhemwlKCKKdcIXEwXGUzImYL%2BZ9%2FQ7XToI%3D&reserved=0

BR, Jarkko
