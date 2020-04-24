Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7F11B80B3
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 22:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgDXUaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 16:30:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:16894 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbgDXUaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 16:30:24 -0400
IronPort-SDR: brofgIqmDv7IY7bU9zN4u5XyH+cLK4hv3GBPI+qCBmUFXB3bo8/qjxYKGrCvnYNxTjj0Lo1Pb7
 S+SN04Bn2zTg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 13:29:22 -0700
IronPort-SDR: aH9zCVNbek8Jbhu3jGAgn44wfAK9ebRNyTB6fmrkHv9xCurFFZFYXERhWpvsFNKX/CkA3hH5Nv
 IepTneY68Xtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,313,1583222400"; 
   d="scan'208";a="403437439"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 24 Apr 2020 13:29:22 -0700
Date:   Fri, 24 Apr 2020 13:29:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] kvm: x86: Rename KVM_DEBUGREG_RELOAD to
 KVM_DEBUGREG_NEED_RELOAD
Message-ID: <20200424202921.GG30013@linux.intel.com>
References: <20200416101509.73526-1-xiaoyao.li@intel.com>
 <20200416101509.73526-2-xiaoyao.li@intel.com>
 <20200423190941.GN17824@linux.intel.com>
 <20200424202103.GA48376@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424202103.GA48376@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 04:21:03PM -0400, Peter Xu wrote:
> On Thu, Apr 23, 2020 at 12:09:42PM -0700, Sean Christopherson wrote:
> > On Thu, Apr 16, 2020 at 06:15:07PM +0800, Xiaoyao Li wrote:
> > > To make it more clear that the flag means DRn (except DR7) need to be
> > > reloaded before vm entry.
> > > 
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h | 2 +-
> > >  arch/x86/kvm/x86.c              | 6 +++---
> > >  2 files changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index c7da23aed79a..f465c76e6e5a 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -511,7 +511,7 @@ struct kvm_pmu_ops;
> > >  enum {
> > >  	KVM_DEBUGREG_BP_ENABLED = 1,
> > >  	KVM_DEBUGREG_WONT_EXIT = 2,
> > > -	KVM_DEBUGREG_RELOAD = 4,
> > > +	KVM_DEBUGREG_NEED_RELOAD = 4,
> > 
> > My vote would be for KVM_DEBUGREG_DIRTY  Any bit that is set switch_db_regs
> > triggers a reload, whereas I would expect a RELOAD flag to be set _every_
> > time a load is needed and thus be the only bit that's checked
> 
> But then shouldn't DIRTY be set as long as KVM_DEBUGREG_BP_ENABLED is set every
> time before vmenter?  Then it'll somehow go back to switch_db_regs, iiuc...
> 
> IIUC RELOAD actually wants to say "reload only for this iteration", that's why
> it's cleared after each reload.  So maybe...  RELOAD_ONCE?

Or FORCE_LOAD, or FORCE_RELOAD?  Those crossed my mind as well.

> (Btw, do we have debug regs tests somewhere no matter inside guest or with
>  KVM_SET_GUEST_DEBUG?)

I don't think so?
