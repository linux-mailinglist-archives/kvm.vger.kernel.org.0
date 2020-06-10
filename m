Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA001F5C4D
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 21:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730366AbgFJT5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 15:57:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41422 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728889AbgFJT5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 15:57:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591819051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nl9EIBpQI7NQMzSr/H6WnIrG3wfcWrL6AfGlOWS2QN8=;
        b=GSoCbhkfSqq9VqDcRc4fh0sMTpEzkeXSWsGpwHBSkw747e4P2PM2js8V592cw1TaFqWcmO
        s/tABD2aaW56c9HdVv9mrQtLYf0tsjKEtPds+ljsO0j8sDbgaQ1b++zr1UvnlqFbPriwy6
        L64yDipAhbDAe1XpWwxjmkbwVN8p/88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-CKjwj5d_P8y6-aWOzSjAvw-1; Wed, 10 Jun 2020 15:57:27 -0400
X-MC-Unique: CKjwj5d_P8y6-aWOzSjAvw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03A27461;
        Wed, 10 Jun 2020 19:57:26 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-64.rdu2.redhat.com [10.10.115.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A531A7C08B;
        Wed, 10 Jun 2020 19:57:25 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 2C3CF2205BD; Wed, 10 Jun 2020 15:57:25 -0400 (EDT)
Date:   Wed, 10 Jun 2020 15:57:25 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: async_pf: Inject 'page ready' event only if
 'page not present' was previously injected
Message-ID: <20200610195725.GA263462@redhat.com>
References: <20200610175532.779793-1-vkuznets@redhat.com>
 <20200610175532.779793-2-vkuznets@redhat.com>
 <20200610193211.GB243520@redhat.com>
 <20200610194738.GE18790@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610194738.GE18790@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 12:47:38PM -0700, Sean Christopherson wrote:
> On Wed, Jun 10, 2020 at 03:32:11PM -0400, Vivek Goyal wrote:
> > On Wed, Jun 10, 2020 at 07:55:32PM +0200, Vitaly Kuznetsov wrote:
> > > 'Page not present' event may or may not get injected depending on
> > > guest's state. If the event wasn't injected, there is no need to
> > > inject the corresponding 'page ready' event as the guest may get
> > > confused. E.g. Linux thinks that the corresponding 'page not present'
> > > event wasn't delivered *yet* and allocates a 'dummy entry' for it.
> > > This entry is never freed.
> > > 
> > > Note, 'wakeup all' events have no corresponding 'page not present'
> > > event and always get injected.
> > > 
> > > s390 seems to always be able to inject 'page not present', the
> > > change is effectively a nop.
> > > 
> > > Suggested-by: Vivek Goyal <vgoyal@redhat.com>
> > > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > ---
> > >  arch/s390/include/asm/kvm_host.h | 2 +-
> > >  arch/s390/kvm/kvm-s390.c         | 4 +++-
> > >  arch/x86/include/asm/kvm_host.h  | 2 +-
> > >  arch/x86/kvm/x86.c               | 7 +++++--
> > >  include/linux/kvm_host.h         | 1 +
> > >  virt/kvm/async_pf.c              | 2 +-
> > >  6 files changed, 12 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> > > index 3d554887794e..cee3cb6455a2 100644
> > > --- a/arch/s390/include/asm/kvm_host.h
> > > +++ b/arch/s390/include/asm/kvm_host.h
> > > @@ -978,7 +978,7 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
> > >  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
> > >  			       struct kvm_async_pf *work);
> > >  
> > > -void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> > > +bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> > >  				     struct kvm_async_pf *work);
> > 
> > Hi Vitaly,
> > 
> > A minor nit. Using return code to figure out if exception was injected
> > or not is little odd. How about we pass a pointer instead as parameter
> > and kvm_arch_async_page_not_present() sets it to true if page not
> > present exception was injected. This probably will be easier to
> > read.
> > 
> > If for some reason you don't like above, atleats it warrants a comment
> > explaining what do 0 and 1 mean.
> > 
> > Otherwise both the patches look good to me. I tested and I can confirm
> > that now page ready events are not being delivered to guest if page
> > not present was not injected.
> 
> Why does kvm_arch_async_page_not_present() need to "return" anything?  It
> has access to @work, e.g. simply replace "return true" with
> "work->notpresent_injected = true".

We could do it and I thought about it. But modifying work->notpresent_injected
inside kvm_arch_async_page_not_present() again feels very unintuitive.

I personally find it better that initialization of
work->notpresent_injected is very explicit at the site where this 
structure has been allocated and being initialized. (Instead of a
a callee function silently initializing a filed of this structure).

Thanks
Vivek

