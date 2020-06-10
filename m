Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A9D1F5C2D
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 21:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730310AbgFJTrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 15:47:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:47507 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727038AbgFJTrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 15:47:39 -0400
IronPort-SDR: y7yfGGrmlytIE06CqEttsoWJHGAATeU1svuJaDXogwv5D+PPIf6q+JM0xqXHEgxd9agdc6ZU/t
 IIAdZDzV1f1g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2020 12:47:38 -0700
IronPort-SDR: zwsDaZkbBTj0lednQXl1zdUaM7MuxdMUT/XCO8fVZzLlLxwpQr2q5ueRRJ7kjHHo1OraSddyEs
 5JivjUsJxnTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,497,1583222400"; 
   d="scan'208";a="306723019"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga002.fm.intel.com with ESMTP; 10 Jun 2020 12:47:38 -0700
Date:   Wed, 10 Jun 2020 12:47:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: async_pf: Inject 'page ready' event only if
 'page not present' was previously injected
Message-ID: <20200610194738.GE18790@linux.intel.com>
References: <20200610175532.779793-1-vkuznets@redhat.com>
 <20200610175532.779793-2-vkuznets@redhat.com>
 <20200610193211.GB243520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610193211.GB243520@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 03:32:11PM -0400, Vivek Goyal wrote:
> On Wed, Jun 10, 2020 at 07:55:32PM +0200, Vitaly Kuznetsov wrote:
> > 'Page not present' event may or may not get injected depending on
> > guest's state. If the event wasn't injected, there is no need to
> > inject the corresponding 'page ready' event as the guest may get
> > confused. E.g. Linux thinks that the corresponding 'page not present'
> > event wasn't delivered *yet* and allocates a 'dummy entry' for it.
> > This entry is never freed.
> > 
> > Note, 'wakeup all' events have no corresponding 'page not present'
> > event and always get injected.
> > 
> > s390 seems to always be able to inject 'page not present', the
> > change is effectively a nop.
> > 
> > Suggested-by: Vivek Goyal <vgoyal@redhat.com>
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > ---
> >  arch/s390/include/asm/kvm_host.h | 2 +-
> >  arch/s390/kvm/kvm-s390.c         | 4 +++-
> >  arch/x86/include/asm/kvm_host.h  | 2 +-
> >  arch/x86/kvm/x86.c               | 7 +++++--
> >  include/linux/kvm_host.h         | 1 +
> >  virt/kvm/async_pf.c              | 2 +-
> >  6 files changed, 12 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> > index 3d554887794e..cee3cb6455a2 100644
> > --- a/arch/s390/include/asm/kvm_host.h
> > +++ b/arch/s390/include/asm/kvm_host.h
> > @@ -978,7 +978,7 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
> >  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
> >  			       struct kvm_async_pf *work);
> >  
> > -void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> > +bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> >  				     struct kvm_async_pf *work);
> 
> Hi Vitaly,
> 
> A minor nit. Using return code to figure out if exception was injected
> or not is little odd. How about we pass a pointer instead as parameter
> and kvm_arch_async_page_not_present() sets it to true if page not
> present exception was injected. This probably will be easier to
> read.
> 
> If for some reason you don't like above, atleats it warrants a comment
> explaining what do 0 and 1 mean.
> 
> Otherwise both the patches look good to me. I tested and I can confirm
> that now page ready events are not being delivered to guest if page
> not present was not injected.

Why does kvm_arch_async_page_not_present() need to "return" anything?  It
has access to @work, e.g. simply replace "return true" with
"work->notpresent_injected = true".
