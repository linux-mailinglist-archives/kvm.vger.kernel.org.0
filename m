Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA31284344
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 02:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgJFAS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 20:18:57 -0400
Received: from mga03.intel.com ([134.134.136.65]:36429 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgJFAS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 20:18:57 -0400
IronPort-SDR: LWWIhWsOSZgvJBdB8qq6IU4BXTfvyCWfN7/4CIV8/cIIMM8Fg8eNBTi4v2xg34CQ7FqZTM/lEI
 8uchs/Z1fVvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="164329657"
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="164329657"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 17:03:37 -0700
IronPort-SDR: TIIgG3qVcmMZyKW8Hp0JaApHMLv6ExYGKE+R2bMa47QZnvqxC20WmqZoHNgwfRGY5X7SyuW32t
 fbprILPW1cjA==
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="341687905"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 16:44:03 -0700
Date:   Mon, 5 Oct 2020 16:44:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
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
Subject: Re: [PATCH 22/22] kvm: mmu: Don't clear write flooding count for
 direct roots
Message-ID: <20201005234401.GE15803@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-23-bgardon@google.com>
 <a95cacdb-bc65-e11e-2114-b5c045b0eac5@redhat.com>
 <CANgfPd83xGh_82OZEjHQO-+vX0kuCFQPwOTwSGYErd9whyjycw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd83xGh_82OZEjHQO-+vX0kuCFQPwOTwSGYErd9whyjycw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 05, 2020 at 03:48:09PM -0700, Ben Gardon wrote:
> On Fri, Sep 25, 2020 at 6:25 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 25/09/20 23:23, Ben Gardon wrote:
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index 42dde27decd75..c07831b0c73e1 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -124,6 +124,18 @@ static struct kvm_mmu_page *find_tdp_mmu_root_with_role(
> > >       return NULL;
> > >  }
> > >
> > > +hpa_t kvm_tdp_mmu_root_hpa_for_role(struct kvm *kvm,
> > > +                                 union kvm_mmu_page_role role)
> > > +{
> > > +     struct kvm_mmu_page *root;
> > > +
> > > +     root = find_tdp_mmu_root_with_role(kvm, role);
> > > +     if (root)
> > > +             return __pa(root->spt);
> > > +
> > > +     return INVALID_PAGE;
> > > +}
> > > +
> > >  static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
> > >                                                  int level)
> > >  {
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > > index cc0b7241975aa..2395ffa71bb05 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > > @@ -9,6 +9,8 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> > >  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
> > >
> > >  bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
> > > +hpa_t kvm_tdp_mmu_root_hpa_for_role(struct kvm *kvm,
> > > +                                 union kvm_mmu_page_role role);
> > >  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
> > >  void kvm_tdp_mmu_put_root_hpa(struct kvm *kvm, hpa_t root_hpa);
> > >
> >
> > Probably missing a piece since this code is not used and neither is the
> > new argument to is_root_usable.
> >
> > I'm a bit confused by is_root_usable since there should be only one PGD
> > for the TDP MMU (the one for the root_mmu).
> 
> *facepalm* sorry about that. This commit used to be titled "Implement
> fast CR3 switching for the TDP MMU" but several refactors later most
> of it was not useful. The only change that should be part of this
> patch is the one to avoid clearing the write flooding counts. I must
> have failed to revert the other changes.

Tangentially related, isn't it possible to end up with multiple roots if the
MAXPHYSADDR is different between vCPUs?  I.e. if userspace coerces KVM into
using a mix of 4-level and 5-level EPT?

Not saying that's a remotely valid config...
