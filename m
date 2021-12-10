Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C2546F9AA
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 04:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236447AbhLJDvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 22:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbhLJDvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 22:51:15 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8204C061746;
        Thu,  9 Dec 2021 19:47:40 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so8480163pjb.5;
        Thu, 09 Dec 2021 19:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LkBn5Bx2Q2ONdCf/RNLZYtkOm/cR6MUuUu1fyMhdgZQ=;
        b=ZA/6mTXeWxYNyuDf3PEBcaIxgZxDmf6QdiI2Wc6uemKVQNd3RTKQ7YyHp0UnQC1Li2
         rEzPjduEUeFa45cxu1NqXz5t9EJkQnqddvRgMAZ1PXgpAzqHY3+X9GjJsoiCwXMpfCmi
         +QDjgRd/UBWRTkh3xlx6duYFSxJVfJtp1BCz5aiXrrLw0FBbwsufK+CcyMS3tyWVmg9g
         nASyFu0NtlM3Xrf+RIRhtXIPzVT0A86866hkfUdoDoIDNw4q20WUb79Knx6N+4gKYJJM
         k7TBUkYlaIy3I9gUloj7Zk1wVeMs5tn8ez7heM17W56/Xz+9X1aTKGYK4ZyTVcUEMBw0
         tciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LkBn5Bx2Q2ONdCf/RNLZYtkOm/cR6MUuUu1fyMhdgZQ=;
        b=5esYQYw359K1FaP1/mVB/X5FaQZ+iNbBDtWvU1I4X71ft1CYauIPS7CzaaeGCT8QnB
         f65aKn/reUQfBmQW9SBDWzmar6kLrISRMCa4ihuZKksPk/ctBFG5mtbE+mI7ak4Xy1g+
         +xUwg3PN+qTCsHhQaRReYV0DUl8TDdN21TVaoHrEIsKaA0PTDUprOaXdl5Fjmrcu08X3
         uF014vGpmhAWnZ/C+ym5dgzJ/C2BR73Sp7BVpIXJijD1czPk5KqmqgIDIJ8GGRcdj+So
         438XwHL5G4k5a09ZwB5rdmZRI9BxVFVMSCJUBSKBtJUgxPC29CiLnKlSvKZcrzNGSzx3
         qRRQ==
X-Gm-Message-State: AOAM531o1jJyEE5i+evUYGYEENXTSEaE1LSBtanX4+7R5vStBMfygcxi
        IUVKl36euvcsM/lef03hrdsP1u3q+mJIcMo7OMY=
X-Google-Smtp-Source: ABdhPJz9yIe+Z9e6/r74rQeYTTI3+Zkjq8tcmjGKbgAetJYVNaMtw2LKSZQ2/Td1ohhYrrUg2V+iNQ==
X-Received: by 2002:a17:90b:1c0b:: with SMTP id oc11mr20927651pjb.237.1639108060105;
        Thu, 09 Dec 2021 19:47:40 -0800 (PST)
Received: from localhost.localdomain ([43.128.78.144])
        by smtp.gmail.com with ESMTPSA id g189sm1007210pgc.3.2021.12.09.19.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 19:47:39 -0800 (PST)
Date:   Fri, 10 Dec 2021 11:47:28 +0800
From:   Aili Yao <yaoaili126@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaoaili@kingsoft.com
Subject: Re: [PATCH v2] KVM: LAPIC: Per vCPU control over
 kvm_can_post_timer_interrupt
Message-ID: <20211210114728.043f9437@gmail.com>
In-Reply-To: <YbJJCf20VdHNnpzY@google.com>
References: <20211124125409.6eec3938@gmail.com>
        <Ya/s17QDlGZi9COR@google.com>
        <20211208182158.571fcdee@gmail.com>
        <YbJJCf20VdHNnpzY@google.com>
Organization: ksyun
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Dec 2021 18:20:57 +0000
Sean Christopherson <seanjc@google.com> wrote:

> On Wed, Dec 08, 2021, Aili Yao wrote:
> > On Tue, 7 Dec 2021 23:23:03 +0000
> > Sean Christopherson <seanjc@google.com> wrote:
> >   
> > > 
> > >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
> > >  {
> > > -       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > > +       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > > +              (kvm_mwait_in_guest(vcpu) || kvm_hlt_in_guest(vcpu));
> > >  }
> > > 
> > >  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
> > >  {
> > > -       return kvm_x86_ops.set_hv_timer
> > > -              && !(kvm_mwait_in_guest(vcpu->kvm) ||
> > > -                   kvm_can_post_timer_interrupt(vcpu));
> > > +       /*
> > > +        * Don't use the hypervisor timer, a.k.a. VMX Preemption Timer, if the
> > > +        * guest can execute MWAIT without exiting as the timer will stop
> > > +        * counting if the core enters C3 or lower.  HLT in the guest is ok as
> > > +        * HLT is effectively C1 and the timer counts in C0, C1, and C2.
> > > +        *
> > > +        * Don't use the hypervisor timer if KVM can post a timer interrupt to
> > > +        * the guest since posted the timer avoids taking an extra a VM-Exit
> > > +        * when the timer expires.
> > > +        */
> > > +       return kvm_x86_ops.set_hv_timer &&
> > > +              !kvm_mwait_in_guest(vcpu->kvm) &&
> > > +              !kvm_can_post_timer_interrupt(vcpu));
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
> > >   
> > 
> > Sorry, I am little confused here now:
> > if kvm_can_post_timer_interrupt(vcpu) return true(cpu-pm enabled), then the kvm_can_use_hv_timer will always be false;
> > if kvm_can_post_timer_interrupt(vcpu) return false(cpu-pm disable),then kvm_mwait_in_guest(vcpu->kvm) can't be true ether;
> > It seems we don't need kvm_mwait_in_guest(vcpu->kvm) here?  
> 
> We do, it's to prevent the guest from enter C3+ and stopping the VMX preemption
> timer, e.g. if either kvm_vcpu_apicv_active() or pi_inject_timer evaluates false.

Great thanks for your explanation!
Now i am clear!

--Aili Yao
