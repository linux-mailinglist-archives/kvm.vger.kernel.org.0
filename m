Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2277727ED24
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 17:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730909AbgI3Pfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 11:35:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728385AbgI3Pfw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 11:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601480151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D1QwD/gfhJf8Y+k1gVt2KLcwaNRaYYrEvjcC92OOkGk=;
        b=LuSty5qI+fQiOOTkZlzWtCaXh39mPoR2vkCIgttT5BNjwiZbdmCuNPKLoQoiUI3CXm1yJ7
        sqy521fzIreqA8CVoDMFEXmRLAutgAsZgwHCLK0OL0ZxkrhMbjaaWE9VYRVObn/rkr3AX6
        WfjUrhYEr7Gc44Xrv496U4oPQ8lvzfw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-b6aPGwHPOryi9V3RvnDFEQ-1; Wed, 30 Sep 2020 11:35:47 -0400
X-MC-Unique: b6aPGwHPOryi9V3RvnDFEQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52E1280EDA9;
        Wed, 30 Sep 2020 15:35:45 +0000 (UTC)
Received: from starship (unknown [10.35.206.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BE165576C;
        Wed, 30 Sep 2020 15:35:41 +0000 (UTC)
Message-ID: <0518490df933d0b12b6dc4b0df2234091cd95ce7.camel@redhat.com>
Subject: Re: [PATCH v6 4/4] KVM: nSVM: implement on demand allocation of the
 nested state
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Date:   Wed, 30 Sep 2020 18:35:40 +0300
In-Reply-To: <20200929051526.GD353@linux.intel.com>
References: <20200922211025.175547-1-mlevitsk@redhat.com>
         <20200922211025.175547-5-mlevitsk@redhat.com>
         <20200929051526.GD353@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-09-28 at 22:15 -0700, Sean Christopherson wrote:
> On Wed, Sep 23, 2020 at 12:10:25AM +0300, Maxim Levitsky wrote:
> > This way we don't waste memory on VMs which don't use nesting
> > virtualization even when the host enabled it for them.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 42 ++++++++++++++++++++++++++++++
> >  arch/x86/kvm/svm/svm.c    | 55 ++++++++++++++++++++++-----------------
> >  arch/x86/kvm/svm/svm.h    |  6 +++++
> >  3 files changed, 79 insertions(+), 24 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 09417f5197410..dd13856818a03 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -467,6 +467,9 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
> >  
> >  	vmcb12 = map.hva;
> >  
> > +	if (WARN_ON(!svm->nested.initialized))
> 
> Probably should use WARN_ON_ONCE, if this is somehow it, userspace could
> easily spam the kernel.
Makes sense. 

> 
> Side topic, do we actually need 'initialized'?  Wouldn't checking for a
> valid nested.msrpm or nested.hsave suffice?

It a matter of taste - I prefer to have a single variable controlling this,
rather than two. 
a WARN_ON(svm->nested.initialized && !svm->nested.msrpm || !svm->nested.hsave))
would probably be nice to have. IMHO I rather leave this like it is if you
don't object.

> 
> > +		return 1;
> > +
> >  	if (!nested_vmcb_checks(svm, vmcb12)) {
> >  		vmcb12->control.exit_code    = SVM_EXIT_ERR;
> >  		vmcb12->control.exit_code_hi = 0;
> > @@ -684,6 +687,45 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> >  	return 0;
> >  }

Best regards,
	Maxim Levitsky


