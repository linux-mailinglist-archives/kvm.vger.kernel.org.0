Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145125EAE4D
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 19:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiIZRiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 13:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiIZRib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 13:38:31 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7B87B29E
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 10:00:54 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id w10so6777248pll.11
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 10:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=z5Lh0ZhCLRw/22KvXbygZ6bO5ygerKn8ycKcsm/8PeY=;
        b=GF29IhcRkn0LFKGpPlho8n9jNHDJuVjJJl/tu6MpVOjKY/AnTlaX5+CLBpFUS/a/m7
         CP+vp4FkmFbwv61qjmlFHTlYhMB9OeEzTDO+QPi+QXV3LZFxTY/+6hnGjmedgdJExQm6
         5HzvJdv/1E6rESOwnVzeKmFBWlksph7/+m+QHnN3i88tBqwmVQaQUWDaV0luanNx5VRM
         jHXv0GAOHgF/MXkFXuarv+dVxVzXkH5PEgjvb400JFKombpcoU/5QgoqrUE89gKovUhP
         INWrlCf0KZVM+341Fh1yEapH9hBpCCiWyNFyubq3N2jAe5/oHKOPFPbSPPlLimuOWtqt
         exQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=z5Lh0ZhCLRw/22KvXbygZ6bO5ygerKn8ycKcsm/8PeY=;
        b=F/uJbYQqYpT2GuHc7DATV63Y12+VIsk96C6W6c3am37uF8FSds/8i3lw7yv5XUKZhs
         iIkrEzSXTwPj1xpHh48E4hA2YVztf7wjjmda8uFHDjNBBaS1bLWMVNI2ZeNzlpzfiZ4l
         C9L4juCflVgJ2GH5sL3KTFeQqpjnn2QtJ5P9n4vMaOZ03vkUlFhdugqcPuMWBzO9M1Nt
         4ivC2bWY0d3r53hShFnDdCzBBB26QaqYCC06jVJ6hcGvsos1Ge//uGmtiVvZqRzNfOfF
         0oiCff+V/OYck/xP0J3Ha2NhD98nYw4EraLgwdMuU0nY1iKEoz6V5ygYG/KgjYTfYw22
         x7hg==
X-Gm-Message-State: ACrzQf0YVJB9OTVo91J14Sn0ATXLYaTWmf6YwlfIHRmCREp7ybqBsR6k
        Mkm3H8XdzqSAMuQwyisdxFbaKg==
X-Google-Smtp-Source: AMsMyM6ahqFXSv7YPIk5kT0Cm18LWgqTBk9xRe/9LMgLfpWknm6OmYdDCsh9UwwPPP1A7tJZ3WE2Bw==
X-Received: by 2002:a17:902:bb88:b0:178:24f6:4dfc with SMTP id m8-20020a170902bb8800b0017824f64dfcmr22660977pls.169.1664211653540;
        Mon, 26 Sep 2022 10:00:53 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u11-20020a17090a400b00b0020396a060cdsm6783923pjc.13.2022.09.26.10.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 10:00:53 -0700 (PDT)
Date:   Mon, 26 Sep 2022 17:00:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH v3 07/28] KVM: x86: Inhibit APIC memslot if x2APIC and
 AVIC are enabled
Message-ID: <YzHawRN8vpEzP7XD@google.com>
References: <20220920233134.940511-1-seanjc@google.com>
 <20220920233134.940511-8-seanjc@google.com>
 <e84ebf0a7ac9322bd0cfa742ef6dd2bbfdac0df9.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e84ebf0a7ac9322bd0cfa742ef6dd2bbfdac0df9.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 23, 2022, Maxim Levitsky wrote:
> On Tue, 2022-09-20 at 23:31 +0000, Sean Christopherson wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 2c96c43c313a..6475c882b359 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1132,6 +1132,17 @@ enum kvm_apicv_inhibit {
> >  	 * AVIC is disabled because SEV doesn't support it.
> >  	 */
> >  	APICV_INHIBIT_REASON_SEV,
> > +
> > +	/*
> > +	 * Due to sharing page tables across vCPUs, the xAPIC memslot must be
> > +	 * deleted if any vCPU has x2APIC enabled as SVM doesn't provide fully
> > +	 * independent controls for AVIC vs. x2AVIC, and also because SVM
> > +	 * supports a "hybrid" AVIC mode for CPUs that support AVIC but not
> > +	 * x2AVIC.  Note, this isn't a "full" inhibit and is tracked separately.
> > +	 * AVIC can still be activated, but KVM must not create SPTEs for the
> > +	 * APIC base.  For simplicity, this is sticky.
> > +	 */
> > +	APICV_INHIBIT_REASON_X2APIC,
> 
> Hi Sean!
> 
> So assuming that I won't object to making it SVM specific (I still think
> that VMX should also inhibit this memslot because this is closer to x86 spec,
> but if you really want it this way, I won't fight over it):

Heh, I don't necessarily "want" it this way, it's more that I don't see a compelling
reason to change KVM's behavior and risk silently causing a performance regression.
If KVM didn't already have the "APIC base may have RAM semantics" quirk, and/or if
this were the initial APICv implementation and thus no possible users, then I would
probably also vote to give APICv the same treatment.

> I somewhat don't like this inhibit, because now it is used just to say
> 'I am AVIC'.
> 
> What do you think if you just move the code that removes the memslot to SVM,
> to avic_set_virtual_apic_mode?

Suffers the same SRCU issue (see below) :-/

Given the SRCU problem, I'd prefer to keep the management of the memslot in common
code, even though I agree it's a bit silly.  And KVM_REQ_UNBLOCK is a perfect fit
for dealing with the SRCU issue, i.e. handling this in AVIC code would require
another hook on top of spreading the memslot management across x86 and SVM code.

> > @@ -1169,10 +1180,11 @@ struct kvm_arch {
> >  	struct kvm_apic_map __rcu *apic_map;
> >  	atomic_t apic_map_dirty;
> >  
> > -	/* Protects apic_access_memslot_enabled and apicv_inhibit_reasons */
> > -	struct rw_semaphore apicv_update_lock;
> > -
> >  	bool apic_access_memslot_enabled;
> > +	bool apic_access_memslot_inhibited;
> 
> So the apic_access_memslot_enabled currently tracks if the memslot is enabled.
> As I see later in the patch when you free the memslot, you set it to false,
> which means that if a vCPU is created after that (it can happen in theory),
> the memslot will be created again :(
> 
> I say we need 'enabled', and 'allocated' booleans instead. Inhibit will set
> enabled to false, and then on next vcpu run, that will free the memslot.
> 
> when enabled == false, the code needs to be changed to not allocate it again.

This should be handled already.  apic_access_memslot_enabled is toggled from
true=>false if and only if apic_access_memslot_inhibited is set, and the "enabled"
flag is protected by slots_lock.  Thus, newly created vCPUs are guaranteed to
either see apic_access_memslot_enabled==true or apic_access_memslot_inhibited==true.

  int kvm_alloc_apic_access_page(struct kvm *kvm)
  {
	struct page *page;
	void __user *hva;
	int ret = 0;

	mutex_lock(&kvm->slots_lock);
	if (kvm->arch.apic_access_memslot_enabled ||
	    kvm->arch.apic_access_memslot_inhibited)  <=== prevents reallocation
		goto out;

  out:
	mutex_unlock(&kvm->slots_lock);
	return ret;
  }

That could be made more obvious by adding a WARN in kvm_free_apic_access_page(), i.e.

  void kvm_free_apic_access_page(struct kvm *kvm)
  {
	WARN_ON_ONCE(!kvm->arch.apic_access_memslot_inhibited);

	mutex_lock(&kvm->slots_lock);

	if (kvm->arch.apic_access_memslot_enabled) {
		__x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT, 0, 0);
		kvm->arch.apic_access_memslot_enabled = false;
	}

	mutex_unlock(&kvm->slots_lock);
  }

> > +
> > +	/* Protects apicv_inhibit_reasons */
> > +	struct rw_semaphore apicv_update_lock;
> >  	unsigned long apicv_inhibit_reasons;
> >  
> >  	gpa_t wall_clock;
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 99994d2470a2..70f00eda75b2 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2394,9 +2394,26 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
> >  		}
> >  	}
> >  
> > -	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
> > +	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE)) {
> >  		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
> >  
> > +		/*
> > +		 * Mark the APIC memslot as inhibited if x2APIC is enabled and
> > +		 * the x2APIC inhibit is required.  The actual deletion of the
> > +		 * memslot is handled by vcpu_run() as SRCU may or may not be
> > +		 * held at this time, i.e. updating memslots isn't safe.  Don't
> > +		 * check apic_access_memslot_inhibited, this vCPU needs to
> > +		 * ensure the memslot is deleted before re-entering the guest,
> > +		 * i.e. needs to make the request even if the inhibit flag was
> > +		 * already set by a different vCPU.
> > +		 */
> > +		if (vcpu->kvm->arch.apic_access_memslot_enabled &&
> > +		    static_call(kvm_x86_check_apicv_inhibit_reasons)(APICV_INHIBIT_REASON_X2APIC)) {
> > +			vcpu->kvm->arch.apic_access_memslot_inhibited = true;
> > +			kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
> 
> You are about to remove the KVM_REQ_UNBLOCK in other patch series.

No, KVM_REQ_UNHALT is being removed.  KVM_REQ_UNBLOCK needs to stay, although it
has a rather weird name, e.g. KVM_REQ_WORK would probably be better.

> How about just raising KVM_REQ_APICV_UPDATE on current vCPU
> and having a special case in kvm_vcpu_update_apicv of 
> 
> if (apic_access_memslot_enabled == false && apic_access_memslot_allocaed == true) {
> 	drop srcu lock

This was my initial thought as well, but the issue is that SRCU may or may not be
held, and so the unlock+lock would need to be conditional.  That's technically a
solvable problem, as it's possible to detect if SRCU is held, but I really don't
want to rely on kvm_vcpu.srcu_depth for anything other than proving that KVM doesn't
screw up SRCU.

> 	free the memslot
> 	take srcu lock
> }
