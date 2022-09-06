Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5D15AF737
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 23:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiIFVon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 17:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiIFVol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 17:44:41 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B9CBE5;
        Tue,  6 Sep 2022 14:44:36 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id q3so12634599pjg.3;
        Tue, 06 Sep 2022 14:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=x8mslKOrxerhZBDf4i4WSowK5e3x1XEu6u13ONoa8jA=;
        b=UNlD2dFaVpNWRabByhOpoAOnY4KdLLodXqVurRZ0nr9zCTfFRB8OSaEnnHIJ76+aJP
         j8R2wDrO6plS2KABdsGKPUwM+e/WlegpR3VRN7pAVl88P7qWWlg1UTNZzMo39i67fX5S
         R1x2yLAI2a+CAkPp/fR1Lxmijlli7rgjbdJ8WvGumzKmvjj1GyPDRHJi1Q0mp/E2AWOH
         Hf5MXnE6L3lFyr7xuvpKuEB3vigY+RvjhURPvsIbvkmqm81P1Wn2vncPfzmhkWGB0NdG
         sSITWT4kBTJzAXS6CtePjBow4/W8km43vQ5n6WHygLJohxejc7l0edWqQKkwhl+Nv5jx
         8XjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=x8mslKOrxerhZBDf4i4WSowK5e3x1XEu6u13ONoa8jA=;
        b=s9IHcBs8wWmbJ2mFNyxG4AKBhR3HTq3BrRbyFdtzuvtln2ZcPYFh4jI2uygqdvysgN
         4ZwQEbUrDH730blnrY6+mmqh6L1XWk5lQWVwwRf4nglWuuXSKTycdmZz3gb7lNVWBgWQ
         NHtQZ4w8hDyCt4LWDkYi3coKBzgpjNoZcpxWMiUCKLDQfEHjlrM4nsaQzQsLZG90mKD0
         4V/tV5NRD2WcoljqEpt4AagUM78z9kKCgHvVLTpR2173Lh5AxtBg+KGdYuswpxWCcaQv
         AhGX/dvO8cRE4lJBT+ojmSmVjWmv8wV+WNLRQeQtvfD6nqb3mOOdhNM8dl12vNBlEsuU
         m8iA==
X-Gm-Message-State: ACgBeo2DgH9JvagVV7FpAy01KNy8k3kZQDsBAKgs9YcRhQMncdq0S0ia
        1XKdvtB8rfzTLEMdhKSbc1g=
X-Google-Smtp-Source: AA6agR6NPiHCYHAti9Y0sb6IRQjGKv1+B5CoxngMhjEdMhjwpIt9RtbH31pXy6RZn4Mxr7kmhDJArw==
X-Received: by 2002:a17:902:e80a:b0:176:e6a6:a17d with SMTP id u10-20020a170902e80a00b00176e6a6a17dmr297283plg.171.1662500676219;
        Tue, 06 Sep 2022 14:44:36 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id e16-20020aa798d0000000b005360da6b26bsm10618103pfm.159.2022.09.06.14.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 14:44:35 -0700 (PDT)
Date:   Tue, 6 Sep 2022 14:44:34 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Yuan Yao <yuan.yao@linux.intel.com>, isaku.yamahata@intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 10/22] KVM: Drop kvm_count_lock and instead protect
 kvm_usage_count with kvm_lock
Message-ID: <20220906214434.GA443010@ls.amr.corp.intel.com>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <20212af31729ba27e29c3856b78975c199b5365c.1662084396.git.isaku.yamahata@intel.com>
 <20220906024643.ti66dw2y6m6jgch2@yy-desk-7060>
 <87pmg9ui6h.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87pmg9ui6h.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 07:32:22AM +0100,
Marc Zyngier <maz@kernel.org> wrote:

> On Tue, 06 Sep 2022 03:46:43 +0100,
> Yuan Yao <yuan.yao@linux.intel.com> wrote:
> > 
> > On Thu, Sep 01, 2022 at 07:17:45PM -0700, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >
> > > Because kvm_count_lock unnecessarily complicates the KVM locking convention
> > > Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock for
> > > simplicity.
> > >
> > > Opportunistically add some comments on locking.
> > >
> > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > >  Documentation/virt/kvm/locking.rst | 14 +++++-------
> > >  virt/kvm/kvm_main.c                | 34 ++++++++++++++++++++----------
> > >  2 files changed, 28 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
> > > index 845a561629f1..8957e32aa724 100644
> > > --- a/Documentation/virt/kvm/locking.rst
> > > +++ b/Documentation/virt/kvm/locking.rst
> > > @@ -216,15 +216,11 @@ time it will be set using the Dirty tracking mechanism described above.
> > >  :Type:		mutex
> > >  :Arch:		any
> > >  :Protects:	- vm_list
> > > -
> > > -``kvm_count_lock``
> > > -^^^^^^^^^^^^^^^^^^
> > > -
> > > -:Type:		raw_spinlock_t
> > > -:Arch:		any
> > > -:Protects:	- hardware virtualization enable/disable
> > > -:Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
> > > -		migration.
> > > +                - kvm_usage_count
> > > +                - hardware virtualization enable/disable
> > > +:Comment:	Use cpus_read_lock() for hardware virtualization enable/disable
> > > +                because hardware enabling/disabling must be atomic /wrt
> > > +                migration.  The lock order is cpus lock => kvm_lock.
> > >
> > >  ``kvm->mn_invalidate_lock``
> > >  ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index fc55447c4dba..082d5dbc8d7f 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -100,7 +100,6 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
> > >   */
> > >
> > >  DEFINE_MUTEX(kvm_lock);
> > > -static DEFINE_RAW_SPINLOCK(kvm_count_lock);
> > >  LIST_HEAD(vm_list);
> > >
> > >  static cpumask_var_t cpus_hardware_enabled;
> > > @@ -4996,6 +4995,8 @@ static void hardware_enable_nolock(void *caller_name)
> > >  	int cpu = raw_smp_processor_id();
> > >  	int r;
> > >
> > > +	WARN_ON_ONCE(preemptible());
> > 
> > This looks incorrect, it may triggers everytime when online CPU.
> > Because patch 7 moved CPUHP_AP_KVM_STARTING *AFTER*
> > CPUHP_AP_ONLINE_IDLE as CPUHP_AP_KVM_ONLINE, then cpuhp_thread_fun()
> > runs the new CPUHP_AP_KVM_ONLINE in *non-atomic* context:
> > 
> > cpuhp_thread_fun(unsigned int cpu) {
> > ...
> > 	if (cpuhp_is_atomic_state(state)) {
> > 		local_irq_disable();
> > 		st->result = cpuhp_invoke_callback(cpu, state, bringup, st->node, &st->last);
> > 		local_irq_enable();
> > 
> > 		WARN_ON_ONCE(st->result);
> > 	} else {
> > 		st->result = cpuhp_invoke_callback(cpu, state, bringup, st->node, &st->last);
> > 	}
> > ...
> > }
> > 
> > static bool cpuhp_is_atomic_state(enum cpuhp_state state)
> > {
> > 	return CPUHP_AP_IDLE_DEAD <= state && state < CPUHP_AP_ONLINE;
> > }
> > 
> > The hardware_enable_nolock() now is called in 2 cases:
> > 1. in atomic context by on_each_cpu().
> > 2. From non-atomic context by CPU hotplug thread.
> > 
> > so how about "WARN_ONCE(preemptible() && cpu_active(cpu))" ?
> 
> I suspect similar changes must be applied to the arm64 side (though
> I'm still looking for a good definition of cpu_active()).

It seems plausible. I tested cpu online/offline on x86. Let me update arm64 code
too.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
