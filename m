Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD525B259B
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 20:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbiIHSZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 14:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbiIHSZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 14:25:02 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EF22B25E;
        Thu,  8 Sep 2022 11:24:58 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id u132so458642pfc.6;
        Thu, 08 Sep 2022 11:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=WWPpV4ixsV0K1cIJ9BDV3bxoua94lxlJko1XjEnfsYc=;
        b=pM9SToCvqdevFaHVOaqDTNZrhKS0g/Ftkr23Id9BY8c+KV0OVyacoAwhh1drTjgjxm
         6khMYPG/6BUAcnGRg8KVZSDwUIST6gk66eB2ydkmpfX3M0Lbb/tXONzs6qMwgx+/pTP0
         /ufcUUZr1cSUvHO05KIM7zG4qmdaBheE0NDLUdqb6WT/jE5ovuSAfu8gSU2dmbTWetlz
         bj2sX06VYfCOump+E01E0qbBH5Vx0r6rqYz67yXEHliJ1J7A2CI5a92TRe9jBhi5Yf8C
         98fhjcxnYq0e/jht9sWQv9nWFThsSM6YIlHS1SYUf+pxSPmjQTrrNNeogwvxPRxvQ3Eu
         HXzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=WWPpV4ixsV0K1cIJ9BDV3bxoua94lxlJko1XjEnfsYc=;
        b=DZPscz+eQCNCUYN0wzIJlH9ACc57l/CrRHGMPQMUVAeF6dw8xrC6Jl6Jcstb0cTtPd
         GOS6H2n9nVrHCXUxqg5XhKtQkvGmKfOcEEr1xzoaU0FYXdPFF4QLpG4kP6lA95wjZdgP
         02+NTu6xPgcQiam6lJD30Ms7qEXa5Fefi27aBziJp1EZ/YzzmxviZ42jyot95kVoQZ7t
         5+1JOf7LAZT4biTJKQm5LaolN6xxOTt4TNbaKU6AjVV9JbS2yBHpNwzyMCLCIalPrw7B
         MgYhmP805dfa9BjG9WAdracbni3dqNuDNrQfx4Y8hSKsqHK+AD9wlQbYZmWT4edP/MqO
         uHrw==
X-Gm-Message-State: ACgBeo1TR/DSHGwo935UJC4RbYc+a0UN6lsL5Y065EI398uH6nTbtxUz
        1OKO+mMDHU8iFYQLKDusqec=
X-Google-Smtp-Source: AA6agR5F7cfkIReRaItziRe8yXomRsYGYlINs+dvdY454/GMAkN5TCUaTBO2KGp5TQsvzhdIxJvM7A==
X-Received: by 2002:a05:6a00:801:b0:53e:5e35:336c with SMTP id m1-20020a056a00080100b0053e5e35336cmr10412755pfk.62.1662661496949;
        Thu, 08 Sep 2022 11:24:56 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id m3-20020a170902f64300b0016c9e5f291bsm14841888plg.111.2022.09.08.11.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 11:24:56 -0700 (PDT)
Date:   Thu, 8 Sep 2022 11:24:55 -0700
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
Message-ID: <20220908182455.GB470011@ls.amr.corp.intel.com>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <20212af31729ba27e29c3856b78975c199b5365c.1662084396.git.isaku.yamahata@intel.com>
 <20220906024643.ti66dw2y6m6jgch2@yy-desk-7060>
 <87pmg9ui6h.wl-maz@kernel.org>
 <20220906214434.GA443010@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220906214434.GA443010@ls.amr.corp.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 02:44:34PM -0700,
Isaku Yamahata <isaku.yamahata@gmail.com> wrote:

> On Tue, Sep 06, 2022 at 07:32:22AM +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> 
> > On Tue, 06 Sep 2022 03:46:43 +0100,
> > Yuan Yao <yuan.yao@linux.intel.com> wrote:
> > > 
> > > On Thu, Sep 01, 2022 at 07:17:45PM -0700, isaku.yamahata@intel.com wrote:
> > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > >
> > > > Because kvm_count_lock unnecessarily complicates the KVM locking convention
> > > > Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock for
> > > > simplicity.
> > > >
> > > > Opportunistically add some comments on locking.
> > > >
> > > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > ---
> > > >  Documentation/virt/kvm/locking.rst | 14 +++++-------
> > > >  virt/kvm/kvm_main.c                | 34 ++++++++++++++++++++----------
> > > >  2 files changed, 28 insertions(+), 20 deletions(-)
> > > >
> > > > diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
> > > > index 845a561629f1..8957e32aa724 100644
> > > > --- a/Documentation/virt/kvm/locking.rst
> > > > +++ b/Documentation/virt/kvm/locking.rst
> > > > @@ -216,15 +216,11 @@ time it will be set using the Dirty tracking mechanism described above.
> > > >  :Type:		mutex
> > > >  :Arch:		any
> > > >  :Protects:	- vm_list
> > > > -
> > > > -``kvm_count_lock``
> > > > -^^^^^^^^^^^^^^^^^^
> > > > -
> > > > -:Type:		raw_spinlock_t
> > > > -:Arch:		any
> > > > -:Protects:	- hardware virtualization enable/disable
> > > > -:Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
> > > > -		migration.
> > > > +                - kvm_usage_count
> > > > +                - hardware virtualization enable/disable
> > > > +:Comment:	Use cpus_read_lock() for hardware virtualization enable/disable
> > > > +                because hardware enabling/disabling must be atomic /wrt
> > > > +                migration.  The lock order is cpus lock => kvm_lock.
> > > >
> > > >  ``kvm->mn_invalidate_lock``
> > > >  ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index fc55447c4dba..082d5dbc8d7f 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -100,7 +100,6 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
> > > >   */
> > > >
> > > >  DEFINE_MUTEX(kvm_lock);
> > > > -static DEFINE_RAW_SPINLOCK(kvm_count_lock);
> > > >  LIST_HEAD(vm_list);
> > > >
> > > >  static cpumask_var_t cpus_hardware_enabled;
> > > > @@ -4996,6 +4995,8 @@ static void hardware_enable_nolock(void *caller_name)
> > > >  	int cpu = raw_smp_processor_id();
> > > >  	int r;
> > > >
> > > > +	WARN_ON_ONCE(preemptible());
> > > 
> > > This looks incorrect, it may triggers everytime when online CPU.
> > > Because patch 7 moved CPUHP_AP_KVM_STARTING *AFTER*
> > > CPUHP_AP_ONLINE_IDLE as CPUHP_AP_KVM_ONLINE, then cpuhp_thread_fun()
> > > runs the new CPUHP_AP_KVM_ONLINE in *non-atomic* context:
> > > 
> > > cpuhp_thread_fun(unsigned int cpu) {
> > > ...
> > > 	if (cpuhp_is_atomic_state(state)) {
> > > 		local_irq_disable();
> > > 		st->result = cpuhp_invoke_callback(cpu, state, bringup, st->node, &st->last);
> > > 		local_irq_enable();
> > > 
> > > 		WARN_ON_ONCE(st->result);
> > > 	} else {
> > > 		st->result = cpuhp_invoke_callback(cpu, state, bringup, st->node, &st->last);
> > > 	}
> > > ...
> > > }
> > > 
> > > static bool cpuhp_is_atomic_state(enum cpuhp_state state)
> > > {
> > > 	return CPUHP_AP_IDLE_DEAD <= state && state < CPUHP_AP_ONLINE;
> > > }
> > > 
> > > The hardware_enable_nolock() now is called in 2 cases:
> > > 1. in atomic context by on_each_cpu().
> > > 2. From non-atomic context by CPU hotplug thread.
> > > 
> > > so how about "WARN_ONCE(preemptible() && cpu_active(cpu))" ?
> > 
> > I suspect similar changes must be applied to the arm64 side (though
> > I'm still looking for a good definition of cpu_active()).
> 
> It seems plausible. I tested cpu online/offline on x86. Let me update arm64 code
> too.

On second thought, I decided to add preempt_disable/enable() instead of fixing
up possible arch callback and let each arch handle it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
