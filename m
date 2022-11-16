Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660A262C633
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 18:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbiKPRTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 12:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbiKPRTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 12:19:38 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5971DB
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 09:19:33 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d192so4952201pfd.0
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 09:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yd++ObN+WrxyzCV6eu+IuUH2K33aygMDqpLl7YqP9bQ=;
        b=K5O1OhO9WbRzwyTmhYztgpVTLFrj0jLsQw/X0Y2COhlWg/KCpnb3BuQ/3DWYU/QUyy
         yn6MmJVPG4DpxPGCodjTtHXveMagw2rprK5uLT+OwUN4vOCoVyvMx/lewpri+A2NUKw7
         IATvHrc/GE8CCvbn/3FH8sh8WbpgcGvRCKKhDX9YmnXDsYO8cpZ4JyKmwtEMBqutYZ14
         Ff2cuZRp8Ae8g/u5S2WKIjd493CjipYO/FbPKGh3i4ORxyz3HFK4UsZLQAkDnl2UWzVP
         4w3mooHuX4QS++G0LYjLJnrSgQXT6koq357Hksp4BgysnMT4kd4YH7s6t6H6qB7ovrYS
         2LaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yd++ObN+WrxyzCV6eu+IuUH2K33aygMDqpLl7YqP9bQ=;
        b=7rFJnBQqGAvbbZO/SeSrSOQzIinzv1xUSK1L3eEFj7lMPFaYXpjiq4q23hIASXz+bZ
         8Wd2viZ4r2IWFeFqlwcPL3I3roCSRz/8g8qrenVqGXhZS+IqQC6TIK5+Mo6jqgR2IBBD
         a3cnjU8B6kxCIkasQVUkzCeyEDrjD6RA0QvPfOLssHFgXbFvPnBFGisEHtys4q+IuSlf
         qVwMCVpZXwpurz92wBBhUglKrnEv7MtniKeTHen4cu23CcItsYd9pc1WCO85VhBdKvee
         Dt2RAGU/ewRfHJ/Fe/gokeWPxOYC23GHGN7ZU0im3NATW7Oeytia8+QvxqMUOKOnTslG
         JmKQ==
X-Gm-Message-State: ANoB5pmA+ZunfC4BJb3PFJ+ySRdrK2qYFQI1EF3+tpYQ/z0Q+Ca3xjqN
        FYr1Ngb2EYWJNOmqwwcwfdN//Q==
X-Google-Smtp-Source: AA0mqf7vO0cqTPp+H1qbd2Dp5/UFD3iMJrWGOOmHhwF4ArV24KELQAGgbhwMNKl1+aZ5S+A+ooIaeA==
X-Received: by 2002:a63:221a:0:b0:464:3985:3c63 with SMTP id i26-20020a63221a000000b0046439853c63mr21258516pgi.141.1668619173006;
        Wed, 16 Nov 2022 09:19:33 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id k26-20020aa7999a000000b00561382a5a25sm11102299pfh.26.2022.11.16.09.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 09:19:32 -0800 (PST)
Date:   Wed, 16 Nov 2022 09:19:28 -0800
From:   David Matlack <dmatlack@google.com>
To:     "wangyanan (Y)" <wangyanan55@huawei.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        KVM ARM <kvmarm@lists.cs.columbia.edu>,
        Janosch Frank <frankja@linux.ibm.com>,
        Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Jon Cargille <jcargill@google.com>,
        kvm-ppc <kvm-ppc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jim Mattson <jmattson@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
Message-ID: <Y3UboELxugwDJkIG@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
 <YVHcY6y1GmvGJnMg@google.com>
 <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
 <43e42f5c-9d9f-9e8b-3a61-9a053a818250@de.ibm.com>
 <CABgObfYtS6wiQe=BhF3t5usr7J6q4PWE4=rwZMMukfC9wT_6fA@mail.gmail.com>
 <YVIAdVxc+q2UWB+J@google.com>
 <32810c89-44c6-6780-9d05-e49f6b897b6e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32810c89-44c6-6780-9d05-e49f6b897b6e@huawei.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URI_DOTEDU,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022 at 11:28:56AM +0800, wangyanan (Y) wrote:
> Hi Sean, Paolo,
> 
> I recently also notice the behavior change of param halt_poll_ns.
> Now it loses the ability to:
> 1) dynamically disable halt polling for all the running VMs
> by `echo 0 > /sys`
> 2) dynamically adjust the halt polling interval for all the
> running VMs by `echo * > /sys`
> 
> While in our cases, we usually use above two abilities, and
> KVM_CAP_HALT_POLL is not used yet.

I think the right path forward is to make KVM_CAP_HALT_POLL a pure
override of halt_poll_ns, and restore the pre-existing behavior of
halt_poll_ns whenever KVM_CAP_HALT_POLL is not used. e.g. see the patch
below.

That will fix issues (1) and (2) above for any VM not using
KVM_CAP_HALT_POLL. If a VM is using KVM_CAP_HALT_POLL, it will ignore
all changes to halt_poll_ns. If we truly need a mechanism for admins to
disable halt-polling on VMs using KVM_CAP_HALT_POLL, we can introduce a
separate module parameter for that. But IMO, any setup that is
sophisticated enough to use KVM_CAP_HALT_POLL should also be able to use
KVM_CAP_HALT_POLL to disable halt polling.

If everyone is happy with this approach I can test and send a real patch
to the mailing list.

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e6e66c5e56f2..253ad055b6ad 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -788,6 +788,7 @@ struct kvm {
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
+	bool override_halt_poll_ns;
 	unsigned int max_halt_poll_ns;
 	u32 dirty_ring_size;
 	bool vm_bugged;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 43bbe4fde078..479d0d0da0b5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1198,8 +1198,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 			goto out_err_no_arch_destroy_vm;
 	}
 
-	kvm->max_halt_poll_ns = halt_poll_ns;
-
 	r = kvm_arch_init_vm(kvm, type);
 	if (r)
 		goto out_err_no_arch_destroy_vm;
@@ -3371,7 +3369,7 @@ void kvm_sigset_deactivate(struct kvm_vcpu *vcpu)
 	sigemptyset(&current->real_blocked);
 }
 
-static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
+static void grow_halt_poll_ns(struct kvm_vcpu *vcpu, unsigned int max)
 {
 	unsigned int old, val, grow, grow_start;
 
@@ -3385,8 +3383,8 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
 	if (val < grow_start)
 		val = grow_start;
 
-	if (val > vcpu->kvm->max_halt_poll_ns)
-		val = vcpu->kvm->max_halt_poll_ns;
+	if (val > max)
+		val = max;
 
 	vcpu->halt_poll_ns = val;
 out:
@@ -3501,10 +3499,17 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 {
 	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
 	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
+	unsigned int max_halt_poll_ns;
 	ktime_t start, cur, poll_end;
+	struct kvm *kvm = vcpu->kvm;
 	bool waited = false;
 	u64 halt_ns;
 
+	if (kvm->override_halt_poll_ns)
+		max_halt_poll_ns = kvm->max_halt_poll_ns;
+	else
+		max_halt_poll_ns = READ_ONCE(halt_poll_ns);
+
 	start = cur = poll_end = ktime_get();
 	if (do_halt_poll) {
 		ktime_t stop = ktime_add_ns(start, vcpu->halt_poll_ns);
@@ -3545,17 +3550,16 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 	if (halt_poll_allowed) {
 		if (!vcpu_valid_wakeup(vcpu)) {
 			shrink_halt_poll_ns(vcpu);
-		} else if (vcpu->kvm->max_halt_poll_ns) {
+		} else if (max_halt_poll_ns) {
 			if (halt_ns <= vcpu->halt_poll_ns)
 				;
 			/* we had a long block, shrink polling */
-			else if (vcpu->halt_poll_ns &&
-				 halt_ns > vcpu->kvm->max_halt_poll_ns)
+			else if (vcpu->halt_poll_ns && halt_ns > max_halt_poll_ns)
 				shrink_halt_poll_ns(vcpu);
 			/* we had a short halt and our poll time is too small */
-			else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
-				 halt_ns < vcpu->kvm->max_halt_poll_ns)
-				grow_halt_poll_ns(vcpu);
+			else if (vcpu->halt_poll_ns < max_halt_poll_ns &&
+				 halt_ns < max_halt_poll_ns)
+				grow_halt_poll_ns(vcpu, max_halt_poll_ns);
 		} else {
 			vcpu->halt_poll_ns = 0;
 		}
@@ -4588,6 +4592,7 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 		if (cap->flags || cap->args[0] != (unsigned int)cap->args[0])
 			return -EINVAL;
 
+		kvm->override_halt_poll_ns = true;
 		kvm->max_halt_poll_ns = cap->args[0];
 		return 0;
 	}

> 
> On 2021/9/28 1:33, Sean Christopherson wrote:
> > On Mon, Sep 27, 2021, Paolo Bonzini wrote:
> > > On Mon, Sep 27, 2021 at 5:17 PM Christian Borntraeger
> > > <borntraeger@de.ibm.com> wrote:
> > > > > So I think there are two possibilities that makes sense:
> > > > > 
> > > > > * track what is using KVM_CAP_HALT_POLL, and make writes to halt_poll_ns follow that
> > > > what about using halt_poll_ns for those VMs that did not uses KVM_CAP_HALT_POLL and the private number for those that did.
> > > Yes, that's what I meant.  David pointed out that doesn't allow you to
> > > disable halt polling altogether, but for that you can always ask each
> > > VM's userspace one by one, or just not use KVM_CAP_HALT_POLL. (Also, I
> > > don't know about Google's usecase, but mine was actually more about
> > > using KVM_CAP_HALT_POLL to *disable* halt polling on some VMs!).
> > I kinda like the idea if special-casing halt_poll_ns=0, e.g. for testing or
> > in-the-field mitigation if halt-polling is broken.  It'd be trivial to support, e.g.
> Do we have any plan to repost the diff as a fix?
> I would be very nice that this issue can be solved.
> 
> Besides, I think we may need some Doc for users to describe
> how halt_poll_ns works with KVM_CAP_HALT_POLL, like
> "Documentation/virt/guest-halt-polling.rst".
> > @@ -3304,19 +3304,23 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
> >                  update_halt_poll_stats(vcpu, start, poll_end, !waited);
> > 
> >          if (halt_poll_allowed) {
> > +               max_halt_poll_ns = vcpu->kvm->max_halt_poll_ns;
> > +               if (!max_halt_poll_ns || !halt_poll_ns)  <------ squish the max if halt_poll_ns==0
> > +                       max_halt_poll_ns = halt_poll_ns;
> > +
> Does this mean that KVM_CAP_HALT_POLL will not be able to
> disable halt polling for a VM individually when halt_poll_ns !=0?
> >                  if (!vcpu_valid_wakeup(vcpu)) {
> >                          shrink_halt_poll_ns(vcpu);
> > -               } else if (vcpu->kvm->max_halt_poll_ns) {
> > +               } else if (max_halt_poll_ns) {
> >                          if (halt_ns <= vcpu->halt_poll_ns)
> >                                  ;
> >                          /* we had a long block, shrink polling */
> >                          else if (vcpu->halt_poll_ns &&
> > -                                halt_ns > vcpu->kvm->max_halt_poll_ns)
> > +                                halt_ns > max_halt_poll_ns)
> >                                  shrink_halt_poll_ns(vcpu);
> >                          /* we had a short halt and our poll time is too small */
> > -                       else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
> > -                                halt_ns < vcpu->kvm->max_halt_poll_ns)
> > -                               grow_halt_poll_ns(vcpu);
> > +                       else if (vcpu->halt_poll_ns < max_halt_poll_ns &&
> > +                                halt_ns < max_halt_poll_ns)
> > +                               grow_halt_poll_ns(vcpu, max_halt_poll_ns);
> >                  } else {
> >                          vcpu->halt_poll_ns = 0;
> >                  }
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> > .
> Thanks,
> Yanan
