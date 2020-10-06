Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149CF284FB3
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 18:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJFQTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 12:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFQTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 12:19:15 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0A8C061755
        for <kvm@vger.kernel.org>; Tue,  6 Oct 2020 09:19:15 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id b2so604045ilr.1
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 09:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0j7bVQ6cY/IsqAnGK/p9cg6aukVwH5ix8kDzesCNboA=;
        b=RH88NPMx9E+aRwvEY4rKKzUD280fWlrZVPTnOr8RnD703+WHY5rB0mJC1gjuZHaGhv
         wyUeMoQ5zHiul1Hh+Bjwkf2v/t25MP9p1Oa7kKxFfHU74ezEQSFofbCHdY2oDJ0uH8eE
         BYYc1yJgEC2z47diXJ1Bzgh2N4pAQoUwSykJy2x3coZ9UFZEHxb+WANEY+PDUaNR//rm
         dndfLhN+R43uf2oqNqqM1oB3qMMAobPUDlDQv6ma55/67LT5uwE+a2aegJ2XHY3zx0O+
         62xrYB6p+EhaXjMKTC8oB9+dTxt305IvoUoHAJyM52Qe/n2HhbhS+GKBfOzOh5t4OO54
         GiBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0j7bVQ6cY/IsqAnGK/p9cg6aukVwH5ix8kDzesCNboA=;
        b=C+MO7Ps6Yd+lBhIOg9mXB/2YCKXLeHRTa+r/8yUrhB9rCNbLrSHTZA6mhdZtydMPLs
         9bWH5uLjglchOob6P4pfLVwzrBE+qMe5SsTcJomi23I8IC2k+T59NRCyy9xfBI9amJe5
         a9G+S6H7is3e07C+LU4l1xrEFQUtGw+erdj+ThnsaAbpHw2TVEcimGT4qCz53E9sX2Go
         gztJB1WP6/kfsrRECuAXIoME6G239EG0MwHa3ZLiJ+mnl4qpaRt+BM2V8XAzbEUvOJDM
         h2J9svWV3iWSpaCfuSGVvi66DKYdaoIM3RMLgLCoPQ3/6vjcSYS695HVCqGbT7SK86DH
         Uhbg==
X-Gm-Message-State: AOAM530qx2BU8yikCLNkrrGpzdna80ny6CaqrGJj0m3G1gEB2BwnuYd9
        MhLnPzGWkKWsugUITUjRc9ZTYX2uHKT5QxcElOQ00Q==
X-Google-Smtp-Source: ABdhPJzz+JeP8oqfK1RVFwCsta0Hg6sDbIwZA5aojZStfrI42gMldVM3A0o45lFEPIhb8o9qCyrdaFLtzusNryIEF9s=
X-Received: by 2002:a92:7914:: with SMTP id u20mr4198094ilc.203.1602001153962;
 Tue, 06 Oct 2020 09:19:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-23-bgardon@google.com>
 <a95cacdb-bc65-e11e-2114-b5c045b0eac5@redhat.com> <CANgfPd83xGh_82OZEjHQO-+vX0kuCFQPwOTwSGYErd9whyjycw@mail.gmail.com>
 <20201005234401.GE15803@linux.intel.com>
In-Reply-To: <20201005234401.GE15803@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 6 Oct 2020 09:19:02 -0700
Message-ID: <CANgfPd_9cvCQCNkqMZiBq0FjxYDVpXmEERKEBujREZrOOmt04w@mail.gmail.com>
Subject: Re: [PATCH 22/22] kvm: mmu: Don't clear write flooding count for
 direct roots
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 5, 2020 at 5:07 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Oct 05, 2020 at 03:48:09PM -0700, Ben Gardon wrote:
> > On Fri, Sep 25, 2020 at 6:25 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >
> > > On 25/09/20 23:23, Ben Gardon wrote:
> > > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > > index 42dde27decd75..c07831b0c73e1 100644
> > > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > > @@ -124,6 +124,18 @@ static struct kvm_mmu_page *find_tdp_mmu_root_with_role(
> > > >       return NULL;
> > > >  }
> > > >
> > > > +hpa_t kvm_tdp_mmu_root_hpa_for_role(struct kvm *kvm,
> > > > +                                 union kvm_mmu_page_role role)
> > > > +{
> > > > +     struct kvm_mmu_page *root;
> > > > +
> > > > +     root = find_tdp_mmu_root_with_role(kvm, role);
> > > > +     if (root)
> > > > +             return __pa(root->spt);
> > > > +
> > > > +     return INVALID_PAGE;
> > > > +}
> > > > +
> > > >  static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
> > > >                                                  int level)
> > > >  {
> > > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > > > index cc0b7241975aa..2395ffa71bb05 100644
> > > > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > > > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > > > @@ -9,6 +9,8 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> > > >  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
> > > >
> > > >  bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
> > > > +hpa_t kvm_tdp_mmu_root_hpa_for_role(struct kvm *kvm,
> > > > +                                 union kvm_mmu_page_role role);
> > > >  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
> > > >  void kvm_tdp_mmu_put_root_hpa(struct kvm *kvm, hpa_t root_hpa);
> > > >
> > >
> > > Probably missing a piece since this code is not used and neither is the
> > > new argument to is_root_usable.
> > >
> > > I'm a bit confused by is_root_usable since there should be only one PGD
> > > for the TDP MMU (the one for the root_mmu).
> >
> > *facepalm* sorry about that. This commit used to be titled "Implement
> > fast CR3 switching for the TDP MMU" but several refactors later most
> > of it was not useful. The only change that should be part of this
> > patch is the one to avoid clearing the write flooding counts. I must
> > have failed to revert the other changes.
>
> Tangentially related, isn't it possible to end up with multiple roots if the
> MAXPHYSADDR is different between vCPUs?  I.e. if userspace coerces KVM into
> using a mix of 4-level and 5-level EPT?
>
> Not saying that's a remotely valid config...

We'll also end up with multiple TDP MMU roots if using SMM, and being
able to switch back and forth between "legacy/shadow MMU" roots and
TDP MMU roots improves nested performance since we can use the TDP MMU
for L1.
Since the TDP MMU associates struct kvm_mmu_pages with all its roots,
no special casing should be needed for root switching.
At one point in this patch set I was using some alternative data
structure to replace struct kvm_mmu_page for the TDP MMU, but I
abandoned that approach.
