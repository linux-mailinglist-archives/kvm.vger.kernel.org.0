Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D378B43E588
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 17:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhJ1P6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 11:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhJ1P6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 11:58:13 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7799C0613B9
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 08:55:46 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gn3so5066672pjb.0
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 08:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m0tHnHlQJDBdfArgGfCXfVMbH9LdSSnDL35miUYeLjs=;
        b=QQmaJ8nXN2KbyIG5k1JyBoSquPg6yk3b/FNSx1V8PjEEIwsY4bZfol7aYj6Ws7u8lu
         AL3QNRVPk8G4o1zbT2wS3T+0q2unqIYIGvpD4X4hbS+GWLCfdCjK1582SOfCPxgbXaj6
         rp1/zAb/gxsig9wW4x8Hmz3hVUCDwIHJtvbG8WTJj+OyXJ9Qbywk0hsQ9i5L1juwa1hs
         n78Jiehn21G0dcgi1vzqMRfnUHdXLWIscCjEk3VHPYnbJSs6c8My2YAhN/ZegigH9hDg
         LWqS5PZjO6n0Z4WJ0z7BuPmceVWRsCdNKwW5JM9MnEgXi3tzkHrjJO1A1KNXmTOVd/Xz
         cMxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m0tHnHlQJDBdfArgGfCXfVMbH9LdSSnDL35miUYeLjs=;
        b=i/J6Ksioqe6PThVq1hcYL3jOgRadRKzjwt7E/2dXqMdoa4LwTWQX8ND7dRzjUUKyGP
         JYVNBFhLINp32hPWVDzfsQjzLyTILsAjAktyT8enQtNC4cjAh98Cm753nz7+n8iPd1zl
         QVG1hLoNHxZa7KjWMsqphyNnN7ybtORWAig++sJXfOchrB1QHn5opAJQtPDKtD6PWIR8
         7SsENuR1hguCJTd+aGLpXXQU0PZhDpDOMf887drhGqpYjhc5hv9Tv/SKHhqT+7oEc5+I
         xDBVFszsOFGFc2d0sTj1krS7sPPCHzoqxbi0ywBAf41jeGWV1bGVgHicRwMOwxyVgmb2
         9/fQ==
X-Gm-Message-State: AOAM531VXY0Lu9xTX+FY2zJ0eUeA0CVlqbLz+NK3tFmgJi3fsz2CvutR
        ucnS395IBuwBjOYiWCTLs52Weg==
X-Google-Smtp-Source: ABdhPJwGUzCGTG+bFEKCx4HxRTPn7WtM79GFmjO7irPTWNvcrtXMPEuDRtNZ53pGeMNDkz8HGfA6sw==
X-Received: by 2002:a17:90b:17d0:: with SMTP id me16mr13884280pjb.152.1635436545938;
        Thu, 28 Oct 2021 08:55:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s12sm3788591pfg.70.2021.10.28.08.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 08:55:45 -0700 (PDT)
Date:   Thu, 28 Oct 2021 15:55:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v2 26/43] KVM: VMX: Read Posted Interrupt "control"
 exactly once per loop iteration
Message-ID: <YXrH/ZZBOHrWHz4j@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-27-seanjc@google.com>
 <b078cce30f86672d7d8f8eaa0adc47d24def24e2.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b078cce30f86672d7d8f8eaa0adc47d24def24e2.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > Use READ_ONCE() when loading the posted interrupt descriptor control
> > field to ensure "old" and "new" have the same base value.  If the
> > compiler emits separate loads, and loads into "new" before "old", KVM
> > could theoretically drop the ON bit if it were set between the loads.
> > 
> > Fixes: 28b835d60fcc ("KVM: Update Posted-Interrupts Descriptor when vCPU is preempted")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/posted_intr.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> > index 414ea6972b5c..fea343dcc011 100644
> > --- a/arch/x86/kvm/vmx/posted_intr.c
> > +++ b/arch/x86/kvm/vmx/posted_intr.c
> > @@ -53,7 +53,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
> >  
> >  	/* The full case.  */
> >  	do {
> > -		old.control = new.control = pi_desc->control;
> > +		old.control = new.control = READ_ONCE(pi_desc->control);
> >  
> >  		dest = cpu_physical_id(cpu);
> >  
> > @@ -104,7 +104,7 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
> >  	     "Wakeup handler not enabled while the vCPU was blocking");
> >  
> >  	do {
> > -		old.control = new.control = pi_desc->control;
> > +		old.control = new.control = READ_ONCE(pi_desc->control);
> >  
> >  		dest = cpu_physical_id(vcpu->cpu);
> >  
> > @@ -160,7 +160,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
> >  	     "Posted Interrupt Suppress Notification set before blocking");
> >  
> >  	do {
> > -		old.control = new.control = pi_desc->control;
> > +		old.control = new.control = READ_ONCE(pi_desc->control);
> >  
> >  		/* set 'NV' to 'wakeup vector' */
> >  		new.nv = POSTED_INTR_WAKEUP_VECTOR;
> 
> I wish there was a way to mark fields in a struct, as requiring 'READ_ONCE' on them
> so that compiler would complain if this isn't done, or automatically use 'READ_ONCE'
> logic.

Hmm, I think you could make an argument that ON and thus the whole "control"
word should be volatile.  AFAICT, tagging just "on" as volatile actually works.
There's even in a clause in Documentation/process/volatile-considered-harmful.rst
that calls this out as a (potentially) legitimate use case.

  - Pointers to data structures in coherent memory which might be modified
    by I/O devices can, sometimes, legitimately be volatile.

That said, I think I actually prefer forcing the use of READ_ONCE.  The descriptor
requires more protections than what volatile provides, namely that all writes need
to be atomic.  So given that volatile alone isn't sufficient, I'd prefer to have
the code itself be more self-documenting.

E.g. this compiles and does mess up the expected size.

diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 7f7b2326caf5..149df3b18789 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -11,9 +11,9 @@ struct pi_desc {
        union {
                struct {
                                /* bit 256 - Outstanding Notification */
-                       u16     on      : 1,
+                       volatile u16    on      : 1;
                                /* bit 257 - Suppress Notification */
-                               sn      : 1,
+                       u16     sn      : 1,
                                /* bit 271:258 - Reserved */
                                rsvd_1  : 14;
                                /* bit 279:272 - Notification Vector */
@@ -23,7 +23,7 @@ struct pi_desc {
                                /* bit 319:288 - Notification Destination */
                        u32     ndst;
                };
-               u64 control;
+               volatile u64 control;
        };
        u32 rsvd[6];
 } __aligned(64);
