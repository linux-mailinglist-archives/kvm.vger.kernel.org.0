Return-Path: <kvm+bounces-60081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D527BDF9CB
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 18:19:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05710401A81
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 16:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0D1F3375D3;
	Wed, 15 Oct 2025 16:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pk3NH6n2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760F62FB979
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 16:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760545144; cv=none; b=ZfzWUaiQ1Q0i1VjqkQRsakHlCvFbqgfiEngQI1VdgLJC1Sq6wzdnfbZxgzxVI4m91O3BoHOnykl6SuGvK7xPmdOKs+Ma/GS+X6w9KfYMaQ1DomhsayTiyEVmoaPgrkc7goJr/38K/m9sM8MZR2WXKfxHvWi4ANzHlOgWJtCFBmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760545144; c=relaxed/simple;
	bh=FpJex7JsXk7MQtcq/KBnp9/x9lu2b3S2dp9cqqH8oVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gaUDiTD5E04v5EQvJ0IXMoIavP59ji/l+Y8XjwMvZ87qBwHsyVsmdVPGUpnG1PztRnfSzL2vDtxM+Ebumamw/VMizdaosazchG9o8o01D8Lx9Svs06YO/syOdZIMK7ON7rEgHrUtLmz7eKrw4k1NN3bUhFYRXlyulyacX4HdzoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pk3NH6n2; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2908ce6ae6fso7715535ad.2
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 09:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760545142; x=1761149942; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=61E+2rntUa5VSBuKjvznhuCkIiLtgLpYCNWPKi7dZz0=;
        b=Pk3NH6n2r0h8DbM7P9D99P5YUbTvuY8CXWF+8Bc7r+HR/rlYZItPjNytBtgcxceWBE
         vhPSIjeADnM9usl7yYDsfYOyv2bqh7j8QTeLIPjNeW7AMC5a1eHDKRDbW7NaGa034Mll
         llDlZt7a1Ul6abldPHnudj/54v4Zq0kLsHviHFt87HQOcynOusKmPM58Io5MByIo38/T
         /15kSzkGJSkuubYjxQ4sn97xY74KlYUiAAMbmLJkAU6MIRCEpyncm0R+KmqdanuUMKXA
         gV1JwbkkdMeehCytZsc3UtSuvuX7Iexd4ofpOtZ/GVc1EKrq5u51f2iXEhBcpPLSAbwC
         skaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760545142; x=1761149942;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=61E+2rntUa5VSBuKjvznhuCkIiLtgLpYCNWPKi7dZz0=;
        b=jAbDTxeNPhJQK9CKT8nSIiuLBOLextrEyDOj8zTJVxg0cRUv2b002Y7QwvdWQ/7qKp
         3lFE9FzVfrVKQG13AL011y+oil4Snc6SEOasj8iSiSfaDdvSBj6JkthBVbEaJtkLaUZU
         xL8/mYoGqb9S7Dqd1+mTAj9SqpGDrTH8MqcxhUUvSklVvjBSO/OP8jqroR9Gvo99fqjt
         ukta3syDJrnvNgiSzrZoNvC045qmf/eWUKsgQ6MFisPB0jADDgsoH8aIKjB+kCFlZNFr
         LWsxKxadmSr4M4kT94ZA6KyOmxoo0KGwo4h1/OBjNMwXbVuNQvf/EmkXUo3rts/h3F0n
         UV6w==
X-Forwarded-Encrypted: i=1; AJvYcCUpGZ2RepKZt0dz6ctrihKW9KURnqggLFxkTC8JzO+KDPKE6XwMmnEr+1fYYBH3i9UOAmg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKlBBj7HRPLM7Xq1HeiQrwku0eY1lCIG3EpiFG3Rfz4j0pz6Q2
	XrsVosLO0LbZpY02qzlvJl76gahvVwE+9d/aQnYop/qPd94wilVAFZiAlCvIYa4aca7An8nWyeg
	7cfWkpg==
X-Google-Smtp-Source: AGHT+IGzaEkOLCnhkXm/4LJkTkzpidbSGxKaRls9P3+1zsup3JOsPnvZFNR4QAFZN56nthUV+TBwpaVPMQY=
X-Received: from pjwd6.prod.google.com ([2002:a17:90a:d3c6:b0:32e:e06a:4668])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b4b:b0:271:479d:3dcb
 with SMTP id d9443c01a7336-29027213537mr377287125ad.6.1760545141459; Wed, 15
 Oct 2025 09:19:01 -0700 (PDT)
Date: Wed, 15 Oct 2025 09:19:00 -0700
In-Reply-To: <aO7w+GwftVK5yLfy@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919214259.1584273-1-seanjc@google.com> <aNvLkRZCZ1ckPhFa@yzhao56-desk.sh.intel.com>
 <aNvT8s01Q5Cr3wAq@yzhao56-desk.sh.intel.com> <aNwFTLM3yt6AGAzd@google.com>
 <aNwGjIoNRGZL3_Qr@google.com> <aO7w+GwftVK5yLfy@yzhao56-desk.sh.intel.com>
Message-ID: <aO_JdH3WhfWr2BKr@google.com>
Subject: Re: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that
 skips WRMSR
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="us-ascii"

+Hou, who is trying to clean up the user-return registration code as well:

https://lore.kernel.org/all/15fa59ba7f6f849082fb36735e784071539d5ad2.1758002303.git.houwenlong.hwl@antgroup.com

On Wed, Oct 15, 2025, Yan Zhao wrote:
> On Tue, Sep 30, 2025 at 09:34:20AM -0700, Sean Christopherson wrote:
> > Ha!  It's technically a bug fix.  Because a forced shutdown will invoke
> > kvm_shutdown() without waiting for tasks to exit, and so the on_each_cpu() calls
> > to kvm_disable_virtualization_cpu() can call kvm_on_user_return() and thus
> > consume a stale values->curr.
> Looks consuming stale values->curr could also happen for normal VMs.
> 
> vmx_prepare_switch_to_guest
>   |->kvm_set_user_return_msr //for all slots that load_into_hardware is true
>        |->1) wrmsrq_safe(kvm_uret_msrs_list[slot], value);
>        |  2) __kvm_set_user_return_msr(slot, value);
>                |->msrs->values[slot].curr = value;
>                |  kvm_user_return_register_notifier
> 
> As vmx_prepare_switch_to_guest() invokes kvm_set_user_return_msr() with local
> irq enabled, there's a window where kvm_shutdown() may call
> kvm_disable_virtualization_cpu() between steps 1) and 2). During this window,
> the hardware contains the shadow guest value while values[slot].curr still holds
> the host value.
> 
> In this scenario, if msrs->registered is true at step 1) (due to updating of a
> previous slot), kvm_disable_virtualization_cpu() could call kvm_on_user_return()
> and find "values->host == values->curr", which would leave the hardware value
> set to the shadow guest value instead of restoring the host value.
> 
> Do you think it's a bug?
> And do we need to fix it by disabling irq in kvm_set_user_return_msr() ? e.g.,

Ugh.  It's technically "bug" of sorts, but I really, really don't want to fix it
by disabling IRQs.

Back when commit 1650b4ebc99d ("KVM: Disable irq while unregistering user notifier")
disabled IRQs in kvm_on_user_return(), KVM blasted IPIs in the _normal_ flow, when
when the last VM is destroyed (and also when enabling virtualization, which created
its own problems).

Now that KVM uses the cpuhp framework to enable/disable virtualization, the normal
case runs in task context, including kvm_suspend() and kvm_resume().  I.e. the only
path that can toggle virtualization via IPI callback is kvm_shutdown().  And on
reboot/shutdown, keeping the hook registered is ok as far as MSR state is concerned,
as the callback will run cleanly and restore host MSRs if the CPU manages to return
to userspace before the system goes down.

The only wrinkle is that if kvm.ko module unload manages to race with reboot, then
leaving the notifier registered could lead to use-after-free.  But that's only
possible on --forced reboot/shutdown, because otherwise userspace tasks would be
frozen before kvm_shutdown() is called, i.e. the CPU shouldn't return to userspace
after kvm_shutdown().  Furthermore, on a --forced reboot/shutdown, unregistering
the user-return hook from IRQ context rather pointless, because KVM could immediately
re-register the hook, e.g. if the IRQ arrives before kvm_user_return_register_notifier()
is called.  I.e. the use-after-free isn't fully defended on --forced reboot/shutdown
anyways.

Given all of the above, my vote is to eliminate the IRQ disabling crud and simply
leave the user-return notifier registered on a reboot.  Then to defend against
a use-after-free due to kvm.ko unload racing against reboot, simply bump the module
refcount.  Trying to account for a rather absurd case in the normal paths adds a
ton of noise for almost no gain.

E.g.

---
 arch/x86/kvm/x86.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b8138bd4857..f03f3ae836f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -582,18 +582,12 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
 	struct kvm_user_return_msrs *msrs
 		= container_of(urn, struct kvm_user_return_msrs, urn);
 	struct kvm_user_return_msr_values *values;
-	unsigned long flags;
 
-	/*
-	 * Disabling irqs at this point since the following code could be
-	 * interrupted and executed through kvm_arch_disable_virtualization_cpu()
-	 */
-	local_irq_save(flags);
 	if (msrs->registered) {
 		msrs->registered = false;
 		user_return_notifier_unregister(urn);
 	}
-	local_irq_restore(flags);
+
 	for (slot = 0; slot < kvm_nr_uret_msrs; ++slot) {
 		values = &msrs->values[slot];
 		if (values->host != values->curr) {
@@ -13079,7 +13073,21 @@ int kvm_arch_enable_virtualization_cpu(void)
 void kvm_arch_disable_virtualization_cpu(void)
 {
 	kvm_x86_call(disable_virtualization_cpu)();
-	drop_user_return_notifiers();
+
+	/*
+	 * Leave the user-return notifiers as-is when disabling virtualization
+	 * for reboot, i.e. when disabling via IPI function call, and instead
+	 * pin kvm.ko (if it's a module) to defend against use-after-free (in
+	 * the *very* unlikely scenario module unload is racing with reboot).
+	 * On a forced reboot, tasks aren't frozen before shutdown, and so KVM
+	 * could be actively modifying user-return MSR state when the IPI to
+	 * disable virtualization arrives.  Handle the extreme edge case here
+	 * instead of trying to account for it in the normal flows.
+	 */
+	if (in_task() || WARN_ON_ONCE(!kvm_rebooting))
+		drop_user_return_notifiers();
+	else
+		__module_get(THIS_MODULE);
 }
 
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
@@ -14363,6 +14371,11 @@ module_init(kvm_x86_init);
 
 static void __exit kvm_x86_exit(void)
 {
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		WARN_ON_ONCE(per_cpu_ptr(user_return_msrs, cpu)->registered);
+
 	WARN_ON_ONCE(static_branch_unlikely(&kvm_has_noapic_vcpu));
 }
 module_exit(kvm_x86_exit);

base-commit: fe57670bfaba66049529fe7a60a926d5f3397589
--

