Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A18F28C581
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 01:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389599AbgJLX7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 19:59:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:47370 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388709AbgJLX7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 19:59:31 -0400
IronPort-SDR: 8rHKqNG44OT6YxsbeBHQpp//nX7AXLvEsIALuIF8FssuwcTiYCUWFqNlrOFiIJ+Ia3yoI+fXtq
 9Ft0YwTgXIGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="153651227"
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; 
   d="scan'208";a="153651227"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 16:59:30 -0700
IronPort-SDR: yjTi45t6rk7br2LsqZKE93BfY/THNmNIlozOo7cj6LaLBU2KOZ+4Mu0Mjm6R9Bqck7+lSwvWBz
 fe4p/zLhep/g==
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; 
   d="scan'208";a="520848155"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 16:59:29 -0700
Date:   Mon, 12 Oct 2020 16:59:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 04/22] kvm: mmu: Allocate and free TDP MMU roots
Message-ID: <20201012235927.GA8949@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-5-bgardon@google.com>
 <20200930060610.GA29659@linux.intel.com>
 <CANgfPd90pTFr_36EhHsZjYkmFdyhyxYsRVxQ4_63znT1ri7jOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd90pTFr_36EhHsZjYkmFdyhyxYsRVxQ4_63znT1ri7jOw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Heads up, you may get this multiple times, our mail servers got "upgraded"
recently and are giving me troubles...

On Mon, Oct 12, 2020 at 03:59:35PM -0700, Ben Gardon wrote:
> On Tue, Sep 29, 2020 at 11:06 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > > @@ -3691,7 +3690,13 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> > >       unsigned i;
> > >
> > >       if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> > > -             root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
> > > +             if (vcpu->kvm->arch.tdp_mmu_enabled) {
> >
> > I believe this will break 32-bit NPT.  Or at a minimum, look weird.  It'd
> > be better to explicitly disable the TDP MMU on 32-bit KVM, then this becomes
> >
> >         if (vcpu->kvm->arch.tdp_mmu_enabled) {
> >
> >         } else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> >
> >         } else {
> >
> >         }
> >
>
> How does this break 32-bit NPT? I'm not sure I understand how we would
> get into a bad state here because I'm not familiar with the specifics
> of 32 bit NPT.

32-bit NPT will have a max TDP level of PT32E_ROOT_LEVEL (3), i.e. will
fail the "shadow_root_level >= PT64_ROOT_4LEVEL" check, and thus won't get
to the tdp_mmu_enabled check.  That would likely break as some parts of KVM
would see tdp_mmu_enabled, but this root allocation would continue using
the legacy MMU.

It's somewhat of a moot point, because IIRC there are other things that will
break with 32-bit KVM, i.e. TDP MMU will be 64-bit only.  But burying that
assumption/dependency in these flows is weird.

> > > +                     root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> > > +             } else {
> > > +                     root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level,
> > > +                                           true);
> > > +             }

