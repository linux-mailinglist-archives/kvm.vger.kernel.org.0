Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8724E58ED
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 20:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344046AbiCWTJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 15:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238380AbiCWTJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 15:09:44 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B26E6431;
        Wed, 23 Mar 2022 12:08:14 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id p17so2449315plo.9;
        Wed, 23 Mar 2022 12:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T9cEFUgZOXaQ/vzN5D/naAp9zAmzy1GxcpGvVsKY8Hw=;
        b=PQDzITIOqjNQsmrORP1m8PslVp9pELPXPgTsxIvG8O4ldLoMl1vFAHUxUUbdDUbS0K
         nWDY/H1FOZrdjPTH4Clbwii7e2z6oa6qmLdSo3QWNdJL36YgdR1nxZOWp2owyYCMIws9
         sxyG3ngcUoaelTZJUoilpXzeah9c+BAg2tHpPsklIpZ9dhFJdmJlquz7CllLGKvpwbK5
         mPnrQy68OIQiCD4jaic+Dw9aYicfRsqX2J+5RSYmy1qwf4cKDwP0xoHD8bxdRvp6+nKu
         YJqA0jZsf3VNBSE97CYjrn+86BdiVTPCPoZtHD9CgmyfacbVeqEAvXsFoIPQ28w7Q+Lo
         Gdsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T9cEFUgZOXaQ/vzN5D/naAp9zAmzy1GxcpGvVsKY8Hw=;
        b=VyxSaw01qiggD9OEFgsWY3Za3qfeEpm7+hAzz+Xd4qMQbvoLg0uA9xMmpSbv7EUQIF
         76pXYFvHKBmcrbGRnt9WeFV8+8mYvyDohY2IPUn4peRpffDKvOjeeEkEij+Fv4Iz5bv6
         6YTgWVAePGcVTe+1c4WrtUGNcTidsI27BV5SVlgMOitUX4QS338rHXvjxsiZkB/srsmc
         YLL5TzO6gP0Nug6b0gI/Qcbt+t4U932CTzAlWXoPgOIdlurQmDD6ewch1HokHZAuWxk5
         l7ENmmXxeVSCkttDlo2L3z54eMHjN4V++NsgE5L4Owmxlg2M4GrSmhCHNXMN7kTWQ9qS
         Ocdw==
X-Gm-Message-State: AOAM531YroTzQIRtth620m6ICYHKm8L+mS0DaSWqmPOXaE3GI3EZX6Zo
        NfdI+Qn/96Bht19pWgYsNEg=
X-Google-Smtp-Source: ABdhPJzUZU/GsUv1TDau7l+3XBBkjFme6BKm1O2k+UlOeQc84aqHHTeen1a2E5DBy4jaeIKSF7bjIg==
X-Received: by 2002:a17:90a:7147:b0:1bd:24ac:13bd with SMTP id g7-20020a17090a714700b001bd24ac13bdmr13508510pjs.70.1648062493634;
        Wed, 23 Mar 2022 12:08:13 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id f5-20020a056a00238500b004fae3e50e14sm612570pfc.214.2022.03.23.12.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 12:08:13 -0700 (PDT)
Date:   Wed, 23 Mar 2022 12:08:12 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Erdem Aktas <erdemaktas@google.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 073/104] KVM: TDX: track LP tdx vcpu run and
 teardown vcpus on descroing the guest TD
Message-ID: <20220323190812.GH1964605@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <6e096d8509ef40ce3e25c1e132643e772641241b.1646422845.git.isaku.yamahata@intel.com>
 <CAAYXXYy-LU+FCt3VDubjhwYPk1TEKc9qshPp2r8tTvcXXPRnOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYXXYy-LU+FCt3VDubjhwYPk1TEKc9qshPp2r8tTvcXXPRnOQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 05:54:45PM -0700,
Erdem Aktas <erdemaktas@google.com> wrote:

> On Fri, Mar 4, 2022 at 11:50 AM <isaku.yamahata@intel.com> wrote:
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index a6b1a8ce888d..690298fb99c7 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -48,6 +48,14 @@ struct tdx_capabilities tdx_caps;
> >  static DEFINE_MUTEX(tdx_lock);
> >  static struct mutex *tdx_mng_key_config_lock;
> >
> > +/*
> > + * A per-CPU list of TD vCPUs associated with a given CPU.  Used when a CPU
> > + * is brought down to invoke TDH_VP_FLUSH on the approapriate TD vCPUS.
> > + * Protected by interrupt mask.  This list is manipulated in process context
> > + * of vcpu and IPI callback.  See tdx_flush_vp_on_cpu().
> > + */
> > +static DEFINE_PER_CPU(struct list_head, associated_tdvcpus);
> > +
> >  static u64 hkid_mask __ro_after_init;
> >  static u8 hkid_start_pos __ro_after_init;
> >
> > @@ -87,6 +95,8 @@ static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
> >
> >  static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
> >  {
> > +       list_del(&to_tdx(vcpu)->cpu_list);
> > +
> >         /*
> >          * Ensure tdx->cpu_list is updated is before setting vcpu->cpu to -1,
> >          * otherwise, a different CPU can see vcpu->cpu = -1 and add the vCPU
> > @@ -97,6 +107,22 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
> >         vcpu->cpu = -1;
> >  }
> >
> > +void tdx_hardware_enable(void)
> > +{
> > +       INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, raw_smp_processor_id()));
> > +}
> > +
> > +void tdx_hardware_disable(void)
> > +{
> > +       int cpu = raw_smp_processor_id();
> > +       struct list_head *tdvcpus = &per_cpu(associated_tdvcpus, cpu);
> > +       struct vcpu_tdx *tdx, *tmp;
> > +
> > +       /* Safe variant needed as tdx_disassociate_vp() deletes the entry. */
> > +       list_for_each_entry_safe(tdx, tmp, tdvcpus, cpu_list)
> > +               tdx_disassociate_vp(&tdx->vcpu);
> > +}
> > +
> >  static void tdx_clear_page(unsigned long page)
> >  {
> >         const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> > @@ -230,9 +256,11 @@ void tdx_mmu_prezap(struct kvm *kvm)
> >         struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> >         cpumask_var_t packages;
> >         bool cpumask_allocated;
> > +       struct kvm_vcpu *vcpu;
> >         u64 err;
> >         int ret;
> >         int i;
> > +       unsigned long j;
> >
> >         if (!is_hkid_assigned(kvm_tdx))
> >                 return;
> > @@ -248,6 +276,17 @@ void tdx_mmu_prezap(struct kvm *kvm)
> >                 return;
> >         }
> >
> > +       kvm_for_each_vcpu(j, vcpu, kvm)
> > +               tdx_flush_vp_on_cpu(vcpu);
> > +
> > +       mutex_lock(&tdx_lock);
> > +       err = tdh_mng_vpflushdone(kvm_tdx->tdr.pa);
> 
> Hi Isaku,

Hi.


> I am wondering about the impact of the failures on these functions. Is
> there any other function which recovers any failures here?
> When I look at the tdx_flush_vp function, it seems like it can fail
> due to task migration so tdx_flush_vp_on_cpu might also fail and if it
> fails, tdh_mng_vpflushdone returns err. Since tdx_vm_teardown does not
> return any error , how the VMM can free the keyid used in this TD.
> Will they be forever in "used state"?
> Also if tdx_vm_teardown fails, the kvm_tdx->hkid is never set to -1
> which will prevent tdx_vcpu_free to free and reclaim the resources
> allocated for the vcpu.

mmu_prezap() is called via release callback of mmu notifier when the last mmu
reference of this process is dropped.  It is after all kvm vcpu fd and kvm vm
fd were closed.  vcpu will never run.  But we still hold kvm_vcpu structures.
There is no race between tdh_vp_flush()/tdh_mng_vpflushdone() here and process
migration.  tdh_vp_flush()/tdh_mng_vp_flushdone() should success.

The cpuid check in tdx_flush_vp() is for vcpu_load() which may race with process
migration. 

Anyway what if one of those TDX seamcalls fails?  HKID is leaked and will be
never used because there is no good way to free and use HKID safely.  Such
failure is due to unknown issue and probably a bug.

One mitigation is to add pr_err() when HKID leak happens.  I'll add such message
on next respin.

thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
