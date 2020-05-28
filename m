Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00C91E6E04
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 23:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436637AbgE1Vpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 17:45:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:38476 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436611AbgE1Vp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 17:45:28 -0400
IronPort-SDR: j+wnX68FzzdKDVsz9aEpfFDjQz/p2foDQBGPpfY7fTKRa8iuZhaXLd1M+N9R/vNGW+2OAZrfFq
 Z5TBxVzU6zFw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 14:45:28 -0700
IronPort-SDR: rSm6c/v+LlVK78vdByExP6+/8/l1hNrXWUuX6gh+nSe1tOqnaQKNth5JVRd9QCgfnVkbi0BGUF
 E2Clqd945DSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="267358478"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 28 May 2020 14:45:28 -0700
Date:   Thu, 28 May 2020 14:45:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests] access: disable phys-bits=36 for now
Message-ID: <20200528214527.GG30353@linux.intel.com>
References: <20200528124742.28953-1-pbonzini@redhat.com>
 <87d06o2fbb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d06o2fbb.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 28, 2020 at 06:29:44PM +0200, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
> > Support for guest-MAXPHYADDR < host-MAXPHYADDR is not upstream yet,
> > it should not be enabled.  Otherwise, all the pde.36 and pte.36
> > fail and the test takes so long that it times out.
> >
> > Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  x86/unittests.cfg | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index bf0d02e..d658bc8 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -116,7 +116,7 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
> >  [access]
> >  file = access.flat
> >  arch = x86_64
> > -extra_params = -cpu host,phys-bits=36
> > +extra_params = -cpu host
> >  
> >  [smap]
> >  file = smap.flat
> 
> Works both VMX and SVM, thanks!

What's the status of the "guest-MAXPHYADDR < host-MAXPHYADDR" work?  I ask
because the AC_PTE_BIT51 and AC_PDE_BIT51 subtests are broken on CPUs with
52 bit PAs.  Is it worth sending a patch to temporarily disable those tests
if MAXPHYADDR=52?
