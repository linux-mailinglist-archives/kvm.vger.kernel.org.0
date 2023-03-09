Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E6D6B2C77
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 18:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjCIR6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 12:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjCIR6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 12:58:51 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B550E8409;
        Thu,  9 Mar 2023 09:58:50 -0800 (PST)
Received: from [192.168.2.1] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id A6E632057638;
        Thu,  9 Mar 2023 09:58:47 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A6E632057638
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1678384729;
        bh=0Mb9VmyxtLOc/ZYJTsWlEXJ43JLJGvVD3RE9OPhfBig=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZwbdDMXl/GtTmWLjAcdL74wt5PkHfEdWTC581wVqcL1mHHUELen0FnHztS9XpAIVc
         zn0ZUu4wqdWuJhCHtICcVDn5sJTeyIQ47u6V6spIh/cz1i/fzR8x460qUK83ZUiggT
         Azb+ezNDNkWiTAM/udgriRP4duDW0Pm5CWO81kE0=
Message-ID: <7ae57680-e657-48d3-56c1-bb818d73dd38@linux.microsoft.com>
Date:   Thu, 9 Mar 2023 18:58:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
Content-Language: en-US
To:     alexander.grest@microsoft.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <ZAd2MRNLw1JAXmOf@google.com>
 <CABgObfa1578yKuw3sqnCeLXpyyKmMPgNaftP9HCdgHNM9Tztjw@mail.gmail.com>
 <ZAfZPA5Ed7STUT2B@google.com>
 <fb088e26-8c9c-bcac-6083-5945d2d9c16e@linux.microsoft.com>
 <ZAjd/ktCeT8D5anK@google.com>
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <ZAjd/ktCeT8D5anK@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

@Alex,
do you know the answer to Sean's question below about ASID handling in Hyper-V?
Any other comments about how we're intending to fix things are also welcome.

Jeremi

On 08/03/2023 20:11, Sean Christopherson wrote:
> On Wed, Mar 08, 2023, Jeremi Piotrowski wrote:
>> On 08/03/2023 01:39, Sean Christopherson wrote:
>>> On Wed, Mar 08, 2023, Paolo Bonzini wrote:
>>>> On Tue, Mar 7, 2023 at 6:36 PM Sean Christopherson <seanjc@google.com> wrote:
>>>>> Thinking about this more, I would rather revert commit 1e0c7d40758b ("KVM: SVM:
>>>>> hyper-v: Remote TLB flush for SVM") or fix the thing properly straitaway.  KVM
>>>>> doesn't magically handle the flushes correctly for the shadow/legacy MMU, KVM just
>>>>> happens to get lucky and not run afoul of the underlying bugs.
>>>>
>>>> I don't think it's about luck---the legacy MMU's zapping/invalidation
>>>> seems to invoke the flush hypercall correctly:
>>>
>>> ...for the paths that Jeremi has exercised, and for which a stale TLB entry is
>>> fatal to L2.  E.g. kvm_unmap_gfn_range() does not have a range-based TLB flush
>>> in its path and fully relies on the buggy kvm_flush_remote_tlbs().
>>>
>>
>> Why do you say "buggy kvm_flush_remote_tlbs"? kvm_flush_remote_tlbs calls the
>> hypercall that is needed, I don't see how this might be an issue of a missing
>> "range-based TLB flush".
> 
> Doh, I forgot that the arch hook in kvm_flush_remote_tlbs() leads to the Hyper-V
> hook.
> 
> svm_flush_tlb_current is very much broken, but in practice it doesn't matter outside
> of the direct call from kvm_mmu_load(), because in all other paths KVM will flow
> through a Hyper-V flush if KVM actually modifies its MMU in any ways.  E.g. the
> request from kvm_mmu_new_pgd() when force_flush_and_sync_on_reuse=true is neutered,
> but that exists only as a safeguard against MMU bugs.  And for things like
> kvm_invalidate_pcid() and kvm_post_set_cr4(), my understanding is that Hyper-V
> will still flush the bare metal TLB, it's only Hyper-V's shadow page tables that
> are stale.
> 
> Depending on how Hyper-V handles ASIDs, pre_svm_run() may also be broken.  If
> Hyper-V tracks and rebuilds only the current ASID, then bumping the ASID won't
> rebuild potentially stale page tables.  But I'm guessing Hyper-V ignores the ASID
> since the hypercall takes only the root PA.
> 
> The truly problematic case is kvm_mmu_load(), where KVM relies on the flush to
> force Hyper-V to rebuild shadow page tables for an old, possibly stale nCR3.  This
> affects only the TDP MMU because of an explicit optimization in the TDP MMU.  So
> in practice we could squeak by with something like this:
> 
> 	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb)
> 		hyperv_flush_guest_mapping(vcpu->arch.mmu->root.hpa);
> 	else
> 		static_call(kvm_x86_flush_tlb_current)(vcpu);
> 
> but I'm not convinced that avoiding a hypercall in svm_flush_tlb_current() just
> to avoid overhead when running an L3 (nested VM from L1 KVM's perspective) is
> worthwhile.  The real problem there is that KVM nested SVM TLB/ASID support is an
> unoptimized mess, and I can't imagine someone running an L3 is going to be super
> concerned with performance.
> 
> I also think we should have a sanity check in the flush_tlb_all() path, i.e. WARN
> if kvm_flush_remote_tlbs() falls back.
> 
> Something like this (probably doesn't compile, likely needs #ifdefs or helpers):
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7ef4f9e3b35a..38afc5cac1c4 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3770,7 +3770,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>         svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
>  }
>  
> -static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> +static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
>  
> @@ -3794,6 +3794,23 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
>                 svm->current_vmcb->asid_generation--;
>  }
>  
> +static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> +{
> +       if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb &&
> +           VALID_PAGE(vcpu->arch.mmu->root.hpa))
> +               hyperv_flush_guest_mapping(vcpu->arch.mmu->root.hpa);
> +
> +       svm_flush_tlb_asid(vcpu);
> +}
> +
> +static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
> +{
> +       if (WARN_ON_ONCE(kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb))
> +               hv_remote_flush_tlb(vcpu->kvm);
> +
> +       svm_flush_tlb_asid(vcpu);
> +}
> +
>  static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4786,10 +4803,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>         .set_rflags = svm_set_rflags,
>         .get_if_flag = svm_get_if_flag,
>  
> -       .flush_tlb_all = svm_flush_tlb_current,
> +       .flush_tlb_all = svm_flush_tlb_all,
>         .flush_tlb_current = svm_flush_tlb_current,
>         .flush_tlb_gva = svm_flush_tlb_gva,
> -       .flush_tlb_guest = svm_flush_tlb_current,
> +       .flush_tlb_guest = svm_flush_tlb_asid,
>  
>         .vcpu_pre_run = svm_vcpu_pre_run,
>         .vcpu_run = svm_vcpu_run,
