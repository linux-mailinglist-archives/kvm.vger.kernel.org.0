Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8DF4E59BC
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 21:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343691AbiCWUT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 16:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239619AbiCWUT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 16:19:27 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA4A8BF15
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 13:17:57 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id y38so2141182ybi.8
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 13:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+f+hkXEMqCDbBc5k9itvwvl/EyJykaOvhcwPJN5igM8=;
        b=cgJ5PdNPSnzZO53gJodR4J6UqkOLzbinHvabBtMW9HEiEwzobQs/HEA0DX5wJQhqJ8
         wcq0ZpWhgVTaXL6ym68hyA+Iw7b6slyEn2XEMmkMraqOwCDf5nCwDX4rWzVWIhdh/DAW
         zzylVqv0dJHs0tgjPuBwWspI9L49c+m8Gmwy8buYp3OxUhHyka764i5BLu5jxjzLD13v
         eu1pq1U5K8Kyhwo68WR+/EekLa99GqF/CBJJGUIRm/p7IQRuK6pvtc0EOXaEP516MBi4
         i4+IdwDeVF4DB7ZYAn3uQoRAhSm5m2fs9BX3P1XRKkFUp+ghy4Yq7uahkcl/RkU4AM1w
         IX6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+f+hkXEMqCDbBc5k9itvwvl/EyJykaOvhcwPJN5igM8=;
        b=DD85V8TiGxAa4xkYqTkhpTpXhipIG0KC5Bpb/DuI31F7qy/Kb6AtyjOBxDWDacCuNL
         ftpJRNjxSpYkZ3lyBO7q9WgAMZ4D5d0BUtN4KvmktsjoE3sZqNMWBmPx8wXeac+yWz4E
         zFlfekO9LiUPgXYfZcBzAG0TAe8xHu2D8ReyPT7otQfehkn02CYTTSQy4tDv2W8bI5K9
         S0pRR67gs1YdnVbdPy00pxUKSg9tm6FnA61UIDqWMM5r8OEPTsAxfnMfWPmK+kswy9Bs
         Uw/VAKkCitUf3Ph3R/pfE7zru/2JiTBTA3LJtigI+dyRHcxPl36Lm2OBQAlRMhnNtw4Q
         BblA==
X-Gm-Message-State: AOAM531pFxVMseWpiVuMNzBwZf657Xvx1pFLATXu3ccPDu5bNITTMN0B
        Bimso84+ei+sBujr+uQMF95h95zW9hVQJaSmCScpeg==
X-Google-Smtp-Source: ABdhPJyAMqmsqsOhRiAmhz+lBqJttS0XHfqfbeokZE5gB4NHjjgwuACok/noPo6+zxu6wq+bOBMZJNdRNSIhWic2BFA=
X-Received: by 2002:a25:7387:0:b0:633:8a4d:ae8 with SMTP id
 o129-20020a257387000000b006338a4d0ae8mr1790817ybc.286.1648066676402; Wed, 23
 Mar 2022 13:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <6e096d8509ef40ce3e25c1e132643e772641241b.1646422845.git.isaku.yamahata@intel.com>
 <CAAYXXYy-LU+FCt3VDubjhwYPk1TEKc9qshPp2r8tTvcXXPRnOQ@mail.gmail.com> <20220323190812.GH1964605@ls.amr.corp.intel.com>
In-Reply-To: <20220323190812.GH1964605@ls.amr.corp.intel.com>
From:   Erdem Aktas <erdemaktas@google.com>
Date:   Wed, 23 Mar 2022 13:17:45 -0700
Message-ID: <CAAYXXYwW9dMMz=tp9kM6P9P29xBMNhgkPA90vX-mEjNaActFiw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 073/104] KVM: TDX: track LP tdx vcpu run and
 teardown vcpus on descroing the guest TD
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So the tdh_vp_flush should always succeed while vm is being torn down.
Thanks Isaku for the explanation, and I think it would be great to add
the error message.

-Erdem

On Wed, Mar 23, 2022 at 12:08 PM Isaku Yamahata
<isaku.yamahata@gmail.com> wrote:
>
> On Tue, Mar 22, 2022 at 05:54:45PM -0700,
> Erdem Aktas <erdemaktas@google.com> wrote:
>
> > On Fri, Mar 4, 2022 at 11:50 AM <isaku.yamahata@intel.com> wrote:
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index a6b1a8ce888d..690298fb99c7 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -48,6 +48,14 @@ struct tdx_capabilities tdx_caps;
> > >  static DEFINE_MUTEX(tdx_lock);
> > >  static struct mutex *tdx_mng_key_config_lock;
> > >
> > > +/*
> > > + * A per-CPU list of TD vCPUs associated with a given CPU.  Used when a CPU
> > > + * is brought down to invoke TDH_VP_FLUSH on the approapriate TD vCPUS.
> > > + * Protected by interrupt mask.  This list is manipulated in process context
> > > + * of vcpu and IPI callback.  See tdx_flush_vp_on_cpu().
> > > + */
> > > +static DEFINE_PER_CPU(struct list_head, associated_tdvcpus);
> > > +
> > >  static u64 hkid_mask __ro_after_init;
> > >  static u8 hkid_start_pos __ro_after_init;
> > >
> > > @@ -87,6 +95,8 @@ static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
> > >
> > >  static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
> > >  {
> > > +       list_del(&to_tdx(vcpu)->cpu_list);
> > > +
> > >         /*
> > >          * Ensure tdx->cpu_list is updated is before setting vcpu->cpu to -1,
> > >          * otherwise, a different CPU can see vcpu->cpu = -1 and add the vCPU
> > > @@ -97,6 +107,22 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
> > >         vcpu->cpu = -1;
> > >  }
> > >
> > > +void tdx_hardware_enable(void)
> > > +{
> > > +       INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, raw_smp_processor_id()));
> > > +}
> > > +
> > > +void tdx_hardware_disable(void)
> > > +{
> > > +       int cpu = raw_smp_processor_id();
> > > +       struct list_head *tdvcpus = &per_cpu(associated_tdvcpus, cpu);
> > > +       struct vcpu_tdx *tdx, *tmp;
> > > +
> > > +       /* Safe variant needed as tdx_disassociate_vp() deletes the entry. */
> > > +       list_for_each_entry_safe(tdx, tmp, tdvcpus, cpu_list)
> > > +               tdx_disassociate_vp(&tdx->vcpu);
> > > +}
> > > +
> > >  static void tdx_clear_page(unsigned long page)
> > >  {
> > >         const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> > > @@ -230,9 +256,11 @@ void tdx_mmu_prezap(struct kvm *kvm)
> > >         struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > >         cpumask_var_t packages;
> > >         bool cpumask_allocated;
> > > +       struct kvm_vcpu *vcpu;
> > >         u64 err;
> > >         int ret;
> > >         int i;
> > > +       unsigned long j;
> > >
> > >         if (!is_hkid_assigned(kvm_tdx))
> > >                 return;
> > > @@ -248,6 +276,17 @@ void tdx_mmu_prezap(struct kvm *kvm)
> > >                 return;
> > >         }
> > >
> > > +       kvm_for_each_vcpu(j, vcpu, kvm)
> > > +               tdx_flush_vp_on_cpu(vcpu);
> > > +
> > > +       mutex_lock(&tdx_lock);
> > > +       err = tdh_mng_vpflushdone(kvm_tdx->tdr.pa);
> >
> > Hi Isaku,
>
> Hi.
>
>
> > I am wondering about the impact of the failures on these functions. Is
> > there any other function which recovers any failures here?
> > When I look at the tdx_flush_vp function, it seems like it can fail
> > due to task migration so tdx_flush_vp_on_cpu might also fail and if it
> > fails, tdh_mng_vpflushdone returns err. Since tdx_vm_teardown does not
> > return any error , how the VMM can free the keyid used in this TD.
> > Will they be forever in "used state"?
> > Also if tdx_vm_teardown fails, the kvm_tdx->hkid is never set to -1
> > which will prevent tdx_vcpu_free to free and reclaim the resources
> > allocated for the vcpu.
>
> mmu_prezap() is called via release callback of mmu notifier when the last mmu
> reference of this process is dropped.  It is after all kvm vcpu fd and kvm vm
> fd were closed.  vcpu will never run.  But we still hold kvm_vcpu structures.
> There is no race between tdh_vp_flush()/tdh_mng_vpflushdone() here and process
> migration.  tdh_vp_flush()/tdh_mng_vp_flushdone() should success.
>
> The cpuid check in tdx_flush_vp() is for vcpu_load() which may race with process
> migration.
>
> Anyway what if one of those TDX seamcalls fails?  HKID is leaked and will be
> never used because there is no good way to free and use HKID safely.  Such
> failure is due to unknown issue and probably a bug.
>
> One mitigation is to add pr_err() when HKID leak happens.  I'll add such message
> on next respin.
>
> thanks,
> --
> Isaku Yamahata <isaku.yamahata@gmail.com>
