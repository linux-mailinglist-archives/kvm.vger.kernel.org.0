Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB8C4B5B46
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 21:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiBNUqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 15:46:19 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiBNUp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 15:45:56 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788F3245FED
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 12:44:03 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id 13so594193oiz.12
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 12:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lUDAX0UaDPTHJ9u8BBzfbhja83Bgj8HqOrB2yYnjOXM=;
        b=VFULTseLnwoWoQSLrikwObkqrgWEDJsgEoShox8nAP9wuMRLYLSmINgZVPuS4zJCYq
         AY+rJI2tTabEed97CNniygA5XGKmOrXxLL+dqf5LJsVaIMA+QxlQKmlOxLVW3MPyEQOW
         ZtZ4oDJOQLly/BilNjT4JcO3Qc4hVnFdspg2L6GzChP02kiowqdnpSk3qcJBLKZzsP0E
         LQOUETeZSPr1OgoOyaK1JtHOTBP1ihk0bK5wukpFaWyN8SjOlX96peTYbEzeUHuSIcP3
         kErjTwCsp+aGM83fy1ZyKBkFtKkFORMEFCjsOWRHwsOb1sx0pkSNSAWQmxneJL40R6Rz
         fXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lUDAX0UaDPTHJ9u8BBzfbhja83Bgj8HqOrB2yYnjOXM=;
        b=pHS35SKSeZiv0s9Uzebg3JMraPd/vPPrAaUcZdWDUG3WnCJtsohvY70KFQEurq37J/
         CiNV6sc6qq1cEp31nmYZPQs7ERl85IqL4VNv23ZAvYU5Nwh2Yh8xqu/wpuFDB+8vPm9w
         lU9cpfYjfRr1WmhFO1x69J6XHsOztnZX4Vd/sow9QfC2xVOlnjvGdY07lEPd+ZYsuKha
         w6hpF1gdBkOZ048t8yLHTNttqJPcXFuQADHogw2LMXJgEpQKH5dXYzE6tIoBAjLVy4kH
         ab5hEjxqfyliHKlWeK0OqaEobYcuMQUCvDJ9KhG8u28ZR+fLRn+vw61MbLMGdtlrVSXi
         i/HA==
X-Gm-Message-State: AOAM5330PgIU8tZRqnXIY1fr9uaQ6fukjgv8WONKpfhJUkLRnb8dbQXl
        rdJUPDm6cXiHVpLhUBEIfve6xreTRGQN8g==
X-Google-Smtp-Source: ABdhPJxxpY4/tEbGo0g+V8BNk8kQ7NowXtqTBM2bOEDe8a9owPVdSth3Obtc2+mwubfJzK+qB57Q9Q==
X-Received: by 2002:a17:90a:1b2c:b0:1b8:ab57:309f with SMTP id q41-20020a17090a1b2c00b001b8ab57309fmr248913pjq.48.1644866647585;
        Mon, 14 Feb 2022 11:24:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nn16sm15099137pjb.2.2022.02.14.11.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 11:24:06 -0800 (PST)
Date:   Mon, 14 Feb 2022 19:24:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 12/12] KVM: x86: do not unload MMU roots on all role
 changes
Message-ID: <YgqsU8j80M1ZpWPx@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-13-pbonzini@redhat.com>
 <YgavcP/jb5njjKKn@google.com>
 <5f42d1ef-f6b7-c339-32b9-f4cf48c21841@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f42d1ef-f6b7-c339-32b9-f4cf48c21841@redhat.com>
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

On Mon, Feb 14, 2022, Paolo Bonzini wrote:
> On 2/11/22 19:48, Sean Christopherson wrote:
> > On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> > > @@ -5045,8 +5046,8 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >   void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
> > >   {
> > > -	kvm_mmu_unload(vcpu);
> > >   	kvm_init_mmu(vcpu);
> > > +	kvm_mmu_new_pgd(vcpu, vcpu->arch.cr3);
> > 
> > This is too risky IMO, there are far more flows than just MOV CR0/CR4 that are
> > affected, e.g. SMM transitions, KVM_SET_SREG, etc...
> 
> SMM exit does flush the TLB because RSM clears CR0.PG (I did check this :)).
> SMM re-entry then does not need to flush.  But I don't think SMM exit should
> flush the TLB *for non-SMM roles*.

I'm not concerned about the TLB flush aspects so much as the addition of
kvm_mmu_new_pgd() in new paths.

> For KVM_SET_SREGS I'm not sure if it should flush the TLB, but I agree it is
> certainly safer to keep it that way.
> 
> > Given that kvm_post_set_cr{0,4}() and kvm_vcpu_reset() explicitly handle CR0.PG
> > and CR4.SMEP toggling, I highly doubt the other flows are correct in all instances.
> > The call to kvm_mmu_new_pgd() is also
> 
> *white noise*
> 
> > To minimize risk, we should leave kvm_mmu_reset_context() as is (rename it if
> > necessary) and instead add a new helper to handle kvm_post_set_cr{0,4}().  In
> > the future we can/should work on avoiding unload in all paths, but again, future
> > problem.
> 
> I disagree on this.  There aren't many calls to kvm_mmu_reset_context.

All the more reason to do things incrementally.  I have no objection to allowing
all flows to reuse a cached (or current) root, I'm objecting to converting them
all in a single patch.  

> > > -	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
> > > +	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS) {
> > > +		/* Flush the TLB if CR0 is changed 1 -> 0.  */
> > > +		if ((old_cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PG))
> > > +			kvm_mmu_unload(vcpu);
> > 
> > Calling kvm_mmu_unload() instead of requesting a flush isn't coherent with respect
> > to the comment, or with SMEP handling.  And the SMEP handling isn't coherent with
> > respect to the changelog.  Please elaborate :-)
> 
> Yep, will do (the CR0.PG=0 case is similar to the CR0.PCIDE=0 case below).

Oh, you're freeing all roots to ensure a future MOV CR3 with NO_FLUSH and PCIDE=1
can't reuse a stale root.  That's necessary if and only if the MMU is shadowing
the guest, non-nested TDP MMUs just need to flush the guest's TLB.  The same is
true for the PCIDE case, i.e. we could optimize that too, though the main motivation
would be to clarify why all roots are unloaded.

> Using kvm_mmu_unload() avoids loading a cached root just to throw it away
> immediately after,

The shadow paging case will throw it away, but not the non-nested TDP MMU case?

> but I can change this to a new KVM_REQ_MMU_UPDATE_ROOT flag that does
> 
> 	kvm_mmu_new_pgd(vcpu, vcpu->arch.cr3);

I don't think that's necessary, I was just confused by the discrepancy.

> By the way, I have a possibly stupid question.  In kvm_set_cr3 (called e.g.
> from emulator_set_cr()) there is
> 
>  	if (cr3 != kvm_read_cr3(vcpu))
> 		kvm_mmu_new_pgd(vcpu, cr3);
> 
> What makes this work if mmu_is_nested(vcpu)?

Hmm, nothing.  VMX is "broken" anyways because it will kick out to userspace with
X86EMUL_UNHANDLEABLE due to the CR3 intercept check.  SVM is also broken in that
it doesn't check INTERCEPT_CR3_WRITE, e.g. will do the wrong thing even if L1 wants
to intercept CR3 accesses.

> Should this also have an "if (... & !tdp_enabled)"?

Yes?  That should avoid the nested mess.  This patch also needs to handle CR0 and
CR4 modifications if L2 is active, e.g. if L1 choose not to intercept CR0/CR4.
kvm_post_set_cr_reinit_mmu() would be a lovely landing spot for that check :-D
