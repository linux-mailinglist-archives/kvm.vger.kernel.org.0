Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2424337EFEF
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 01:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhELXhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 19:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377069AbhELXKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 19:10:13 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E98C06175F
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 16:08:47 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id k19so19931992pfu.5
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 16:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Wb492hLROD3rznrPy6wf7KJkHzULIirqNRRIhlDd1kk=;
        b=Wp04QAxK78mttLcAyJONeic541wFKI87ox2A0TllkYbwUq3DRVQ2h8CaP5mWFhE7Eh
         XgJ5I3eiobAgct8DsIBapJ7K5VA4nBu/MlGApscGVtz2ks7XES8IqS72W6IHkSa/X7FB
         CbQbFHxOWiA1yuQ6rMIohTwo+3QXEXp2/JDMc0rbPeg+DlV4ZPpZ5EwGFvm3K1OY1xRP
         uvLLAbhG7GMhycc3g/idyewYyd22b/58+z4PVoUS5r8WBFdWAPoFYywxzeOKIT2jV36Z
         oI0YAVl3TpO+XkVakcP2LQq1Awfx98GUPY+6A+JWQ/yOMFyK4sZJtCiDyE5V6ylds1rz
         1d7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Wb492hLROD3rznrPy6wf7KJkHzULIirqNRRIhlDd1kk=;
        b=ndEn7nbm/OXb3t7/QdLTu2ToZdmbh25uiX0LTl8NI+j33EGn+eLjHeHEoYR9XWUV7h
         Kf5m574SVpolC9MlddncS0vTqMyIdlYvRIZWdQ7pKCq6/wCcoItnQXYmnWe8mbVhG2UT
         805oR/rYEVhmMfW+o5FeIpxpEkYqqx2uiKhTmhHEVLsKstJ5kr9HdekpYd/HtL4bK7xa
         BxS0KWW2llKflJh7Dhc7G9GlW9rA8TN7P2Cw72Kqn9VE/MQHrP1xmMnkQvPyNTcolr6S
         DcXMiA5p//3NFeVr+xWuFSWgBjN6zI2kPSYrKOjgMQZl1elI9KpY5MAy+6FecPudPlQ2
         p8aA==
X-Gm-Message-State: AOAM530n7zwEKPOMRhGagh8CuVh/5VQkKgw7Di0iCuGk5fgqQKP5euAN
        I6TzuTq68sXuijhkMxeHaIgFOw==
X-Google-Smtp-Source: ABdhPJyXJaa8FXXCaZ/ZKjzEibYMgOb8b0ELox5A9RF2nt4VMaDXntZEjjVnN2/8DY0lu4XYGqdpHQ==
X-Received: by 2002:a17:90a:fb97:: with SMTP id cp23mr1035851pjb.169.1620860927121;
        Wed, 12 May 2021 16:08:47 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id b6sm728181pfb.27.2021.05.12.16.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 16:08:46 -0700 (PDT)
Date:   Wed, 12 May 2021 23:08:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Mcgaire <kevinmcgaire@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH] kvm: x86: Don't dirty guest memory on every vcpu_put()
Message-ID: <YJxf+ho/iu8Gpw6+@google.com>
References: <20200116001635.174948-1-jmattson@google.com>
 <FE5AE42B-107F-4D7E-B728-E33780743434@oracle.com>
 <CANgfPd8wFZx977enc+kbbTP1DfMdxkbi5uzhAgpRZhU0yXOzKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANgfPd8wFZx977enc+kbbTP1DfMdxkbi5uzhAgpRZhU0yXOzKg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021, Ben Gardon wrote:
> On Wed, Jan 15, 2020 at 4:32 PM Liran Alon <liran.alon@oracle.com> wrote:
> >
> >
> >
> > > On 16 Jan 2020, at 2:16, Jim Mattson <jmattson@google.com> wrote:
> > >
> > > Beginning with commit 0b9f6c4615c99 ("x86/kvm: Support the vCPU
> > > preemption check"), the KVM_VCPU_PREEMPTED flag is set in the guest
> > > copy of the kvm_steal_time struct on every call to vcpu_put(). As a
> > > result, guest memory is dirtied on every call to vcpu_put(), even when
> > > the VM is quiescent.
> > >
> > > To avoid dirtying guest memory unnecessarily, don't bother setting the
> > > flag in the guest copy of the struct if it is already set in the
> > > kernel copy of the struct.
> >
> > I suggest adding this comment to code as-well.
> 
> Ping. I don't know if a v2 of this change with the comment in code is
> needed for acceptance, but I don't want this to fall through the
> cracks and get lost.

A version of this was committed a while ago.  The CVE number makes me think it
went stealthily...

commit 8c6de56a42e0c657955e12b882a81ef07d1d073e
Author: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Date:   Wed Oct 30 19:01:31 2019 +0000

    x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit

    kvm_steal_time_set_preempted() may accidentally clear KVM_VCPU_FLUSH_TLB
    bit if it is called more than once while VCPU is preempted.

    This is part of CVE-2019-3016.

    (This bug was also independently discovered by Jim Mattson
    <jmattson@google.com>)

    Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
    Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf917139de6b..8c9369151e9f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3504,6 +3504,9 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
        if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
                return;

+       if (vcpu->arch.st.steal.preempted)
+               return;
+
        vcpu->arch.st.steal.preempted = KVM_VCPU_PREEMPTED;

        kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.st.stime,


> > > If a different vCPU thread clears the guest copy of the flag, it will
> > > no longer get reset on the next call to vcpu_put, but it's not clear
> > > that resetting the flag in this case was intentional to begin with.
> >
> > I agree… I find it hard to believe that guest vCPU is allowed to clear the flag
> > and expect host to set it again on the next vcpu_put() call. Doesn’t really make sense.
> >
> > >
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > Tested-by: Kevin Mcgaire <kevinmcgaire@google.com>
> > > Reviewed-by: Ben Gardon <bgardon@google.com>
> > > Reviewed-by: Oliver Upton <oupton@google.com>
> >
> > Good catch.
> > Reviewed-by: Liran Alon <liran.alon@oracle.com>
> >
> > -Liran
> >
> > >
> > > ---
> > > arch/x86/kvm/x86.c | 3 +++
> > > 1 file changed, 3 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index cf917139de6b..3dc17b173f88 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -3504,6 +3504,9 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
> > >       if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
> > >               return;
> > >
> > > +     if (vcpu->arch.st.steal.preempted & KVM_VCPU_PREEMPTED)
> > > +             return;
> > > +
> > >       vcpu->arch.st.steal.preempted = KVM_VCPU_PREEMPTED;
> > >
> > >       kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.st.stime,
> > > --
> > > 2.25.0.rc1.283.g88dfdc4193-goog
> > >
> >
