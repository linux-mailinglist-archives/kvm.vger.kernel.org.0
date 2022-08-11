Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7321B5905FF
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 19:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiHKRkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 13:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbiHKRj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 13:39:59 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A8E90C7E
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 10:39:58 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id f192so17052374pfa.9
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 10:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=L+RpAHjrFghjSrraTNT3ek1779b4qvURmkDkKl4LVZg=;
        b=M599mjp862F/8rejkM9qorj5l2AbUCBGp914vD5jHOsH9NBtqn8KFnY9V0KkfOH/vv
         tfHM+obkdFit42CAeQtUMorxpLfLGi+C8IJFVpVuDxTiEwfaUKX6i9ZhXGP96X4Aw3IW
         cfi3U2we4ygRCjjFGf3UMQiySGT+522cAl62USOBXPZGLFeW6s8fLC6+qOvHNYFsSkkZ
         sA5ET0zxsQSHUMslEPv1MP4nrLFPj3UipFkQ8HteEb+z6eTZftCg34V9HAlDYMdwq7U6
         34NooR6FfwqNkTqaRV2zGIJ11RNU75UTe7bhcYTZVgfH4RhYUfBJFdw3yW6j9r4Vkbuc
         IK9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=L+RpAHjrFghjSrraTNT3ek1779b4qvURmkDkKl4LVZg=;
        b=sPrj7Mc5UK67GdqB8C+TN1G7MnPsOHWgfwplq8LOp5clAH80K9ZTVu98k0r9HCzKMx
         gTmlgqnWe3mTkqC0Lfb6fxGSE+YWrElT8Rs+aX+ThKc7ILtCMWO/RPIO419mEhIkGap4
         38Zg6JEUC5+YepR5NJbbzxepi0xKScipgKBmoTcfHcwf6o76dyFiT2DSI3yR4rdSaZUV
         LNhA2898jxdEGScMnqNS/LbJoYsv9N48PHmoFzVOVXdpl6oCeFbDjy1cEHVshk5O35CE
         YqRhKqLhnlIBxWqJWsdkoVT0ANCFXSWM4h0Uy7Rak6XPphc7weHrn5V45b68eBFm39Pq
         t0cQ==
X-Gm-Message-State: ACgBeo3BKGJZhXwwNMv10p79slSKGTUsnkZWFWzbrT6Uj9Fm/wCW1tWB
        nASQQpsJUf9E4UryPMPadZ5npA==
X-Google-Smtp-Source: AA6agR5oDzHgOrhCqr0mS08u18mQr4UotTpXxeTcCdSPkI2zMYwAKPGmBvwjp9WqEMXItBWFhy8uNg==
X-Received: by 2002:a05:6a00:189d:b0:52d:d4ae:d9f2 with SMTP id x29-20020a056a00189d00b0052dd4aed9f2mr338433pfh.2.1660239597839;
        Thu, 11 Aug 2022 10:39:57 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm4276909pfv.192.2022.08.11.10.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 10:39:57 -0700 (PDT)
Date:   Thu, 11 Aug 2022 17:39:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v8 003/103] KVM: Refactor CPU compatibility check on
 module initialization
Message-ID: <YvU+6fdkHaqQiKxp@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <4092a37d18f377003c6aebd9ced1280b0536c529.1659854790.git.isaku.yamahata@intel.com>
 <d36802ee3d96d0fdac00d2c11be341f94a362ef9.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d36802ee3d96d0fdac00d2c11be341f94a362ef9.camel@intel.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Will (for arm crud)

On Thu, Aug 11, 2022, Huang, Kai wrote:
> First of all, I think the patch title can be improved.  "refactor CPU
> compatibility check on module initialization" isn't the purpose of this patch. 
> It is just a bonus.  The title should reflect the main purpose (or behaviour) of
> this patch:
> 
> 	KVM: Temporarily enable hardware on all cpus during module loading time

...

> > +	/* hardware_enable_nolock() checks CPU compatibility on each CPUs. */
> > +	r = hardware_enable_all();
> > +	if (r)
> > +		goto out_free_2;
> > +	/*
> > +	 * Arch specific initialization that requires to enable virtualization
> > +	 * feature.  e.g. TDX module initialization requires VMXON on all
> > +	 * present CPUs.
> > +	 */
> > +	kvm_arch_post_hardware_enable_setup(opaque);
> > +	/*
> > +	 * Make hardware disabled after the KVM module initialization.  KVM
> > +	 * enables hardware when the first KVM VM is created and disables
> > +	 * hardware when the last KVM VM is destroyed.  When no KVM VM is
> > +	 * running, hardware is disabled.  Keep that semantics.
> > +	 */
> 
> Except the first sentence, the remaining sentences are more like changelog
> material.  Perhaps just say something below to be more specific on the purpose:
> 
> 	/*
> 	 * Disable hardware on all cpus so that out-of-tree drivers which
> 	 * also use hardware-assisted virtualization (such as virtualbox
> 	 * kernel module) can still be loaded when KVM is loaded.
> 	 */
> 
> > +	hardware_disable_all();
> >  
> >  	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
> >  				      kvm_starting_cpu, kvm_dying_cpu);

I've been poking at the "hardware enable" code this week for other reasons, and
have come to the conclusion that the current implementation is a mess.

x86 overloads "hardware enable" to do three different things:

  1. actually enable hardware
  2. snapshot per-CPU MSR value for user-return MSRs
  3. handle unstable TSC _for existing VMs_ on suspend+resume and/or CPU hotplug

#2 and #3 have nothing to do with enabling hardware, kvm_arch_hardware_enable() just
so happens to be called in a superset of what is needed for dealing with unstable TSCs,
and AFAICT the user-return MSRs is simply a historical wart.  The user-return MSRs
code is subtly very, very nasty, as it means that KVM snaphots MSRs from IRQ context,
e.g. if an out-of-tree module is running VMs, the IRQ can interrupt the _guest_ and
cause KVM to snapshot guest registers.  VMX and SVM kinda sorta guard against this
by refusing to load if VMX/SVM are already enabled, but it's not foolproof.

Eww, and #3 is broken.  If CPU (un)hotplug collides with kvm_destroy_vm() or
kvm_create_vm(), kvm_arch_hardware_enable() could explode due to vm_list being
modified while it's being walked.

Of course, that path is broken for other reasons too, e.g. needs to prevent CPUs
from going on/off-line when KVM is enabling hardware.
https://lore.kernel.org/all/20220216031528.92558-7-chao.gao@intel.com

arm64 is also quite evil and circumvents KVM's hardware enabling logic to some extent.
kvm_arch_init() => init_subsystems() unconditionally enables hardware, and for pKVM
_leaves_ hardware enabled.  And then hyp_init_cpu_pm_notifier() disables/enables
hardware across lower power enter+exit, except if pKVM is enabled.  The icing on
the cake is "disabling" hardware doesn't even do anything (AFAICT) if the kernel is
running at EL2 (which I think is nVHE + not-pKVM?).

PPC apparently didn't want to be left out of the party, and despite having a nop
for kvm_arch_hardware_disable(), it does its own "is KVM enabled" tracking (see
kvm_hv_vm_(de)activated()).  At least PPC gets the cpus_read_(un)lock() stuff right...

MIPS doesn't appear to have any shenanigans, but kvm_vz_hardware_enable() appears
to be a "heavy" operation, i.e. ideally not something that should be done spuriously.

s390 and PPC are the only sane architectures and don't require explicit enabling
of virtualization.

At a glance, arm64 won't explode, but enabling hardware _twice_ during kvm_init()
is all kinds of gross.

Another wart that we can clean up is the cpus_hardware_enabled mask.  I don't see
any reason KVM needs to use a global mask, a per-cpu variable a la kvm_arm_hardware_enabled
would do just fine.

OMG, and there's another bug lurking (I need to stop looking at this code).  Commit
5f6de5cbebee ("KVM: Prevent module exit until all VMs are freed") added an error
path that can cause VM creation to fail _after_ it has been added to the list, but
doesn't unwind _any_ of the stuff done by kvm_arch_post_init_vm() and beyond.

Rather than trying to rework common KVM to fit all the architectures random needs,
I think we should instead overhaul the entire mess.  And we should do that ASAP
ahead of TDX, though obviously with an eye toward not sucking for TDX.

Not 100% thought out at this point, but I think we can do:

  1.  Have x86 snapshot per-CPU user-return MRS on first use (trivial to do by adding
      a flag to struct kvm_user_return_msrs, as user_return_msrs is already per-CPU).

  2.  Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock and
      cpu_read_lock().

  3.  Provide arch hooks that are invoked for "power management" operations (including
      CPU hotplug and host reboot, hence the quotes).  Note, there's both a platform-
      wide PM notifier and a per-CPU notifier...

  4.  Rename kvm_arch_post_init_vm() to e.g. kvm_arch_add_vm(), call it under
      kvm_lock, and pass in kvm_usage_count.

  5a. Drop cpus_hardware_enabled and drop the common hardware enable/disable code.

 or 

  5b. Expose kvm_hardware_enable_all() and/or kvm_hardware_enable() so that archs
      don't need to implement their own error handling and per-CPU flags.

I.e. give each architecture hooks to handle possible transition points, but otherwise
let arch code decide when and how to do hardware enabling/disabling. 

I'm very tempted to vote for (5a); x86 is the only architecture has an error path
in kvm_arch_hardware_enable(), and trying to get common code to play nice with arm's
kvm_arm_hardware_enabled logic is probably going to be weird.

E.g. if we can get the back half kvm_create_vm() to look like the below, then arch
code can enable hardware during kvm_arch_add_vm() if the existing count is zero
without generic KVM needing to worry about when hardware needs to be enabled and
disabled.

	r = kvm_arch_init_vm(kvm, type);
	if (r)
		goto out_err_no_arch_destroy_vm;

	r = kvm_init_mmu_notifier(kvm);
	if (r)
		goto out_err_no_mmu_notifier;

	/*
	 * When the fd passed to this ioctl() is opened it pins the module,
	 * but try_module_get() also prevents getting a reference if the module
	 * is in MODULE_STATE_GOING (e.g. if someone ran "rmmod --wait").
	 */
	if (!try_module_get(kvm_chardev_ops.owner)) {
		r = -ENODEV;
		goto out_err;
	}

	mutex_lock(&kvm_lock);
	cpus_read_lock();
	r = kvm_arch_add_vm(kvm, kvm_usage_count);
	if (r)
		goto out_final;
	kvm_usage_count++;
	list_add(&kvm->vm_list, &vm_list);
	cpus_read_unlock();
	mutex_unlock(&kvm_lock);

	if (r)
		goto out_put_module;

	preempt_notifier_inc();
	kvm_init_pm_notifier(kvm);

	return kvm;

out_final:
	cpus_read_unlock();
	mutex_unlock(&kvm_lock);
	module_put(kvm_chardev_ops.owner);
out_err_no_put_module:
#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
	if (kvm->mmu_notifier.ops)
		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
#endif
out_err_no_mmu_notifier:
	kvm_arch_destroy_vm(kvm);
