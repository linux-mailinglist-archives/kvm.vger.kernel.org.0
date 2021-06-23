Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA7B3B1ABD
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 15:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhFWNKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 09:10:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbhFWNKV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 09:10:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624453683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wsbXUg23KXttQ8gqZSKKydn8DnRXviPL+Q6v+yRsByU=;
        b=AvXSE1prPGnvLFJwnYrEtQRBrgJ4oFA+AB6caxHzfqCA9UoHRedRmP3uvnRxqigzeCyDbS
        4sxqmSVsTscSb9R6Ac6EA/QACo+7D6b0TVACCvE+AC7FQf+yiTw74D+AB2KsJ8G0P6/p/X
        YcOOzvvpYejiYXdZ/ujaxJbgdnO2dSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-OTyFDim1NHatmF18hobVgQ-1; Wed, 23 Jun 2021 09:08:02 -0400
X-MC-Unique: OTyFDim1NHatmF18hobVgQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF96B100C661;
        Wed, 23 Jun 2021 13:08:00 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EC345E7D9;
        Wed, 23 Jun 2021 13:07:51 +0000 (UTC)
Message-ID: <ac98150acd77f4c09167bc1bb1c552db68925cf2.camel@redhat.com>
Subject: Re: [PATCH RFC] KVM: nSVM: Fix L1 state corruption upon return from
 SMM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kernel@vger.kernel.org
Date:   Wed, 23 Jun 2021 16:07:50 +0300
In-Reply-To: <53a9f893cb895f4b52e16c374cbe988607925cdf.camel@redhat.com>
References: <20210623074427.152266-1-vkuznets@redhat.com>
         <a3918bfa-7b4f-c31a-448a-aa22a44d4dfd@redhat.com>
         <53a9f893cb895f4b52e16c374cbe988607925cdf.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-06-23 at 16:01 +0300, Maxim Levitsky wrote:
> On Wed, 2021-06-23 at 11:39 +0200, Paolo Bonzini wrote:
> > On 23/06/21 09:44, Vitaly Kuznetsov wrote:
> > > - RFC: I'm not 100% sure my 'smart' idea to use currently-unused HSAVE area
> > > is that smart. Also, we don't even seem to check that L1 set it up upon
> > > nested VMRUN so hypervisors which don't do that may remain broken. A very
> > > much needed selftest is also missing.
> > 
> > It's certainly a bit weird, but I guess it counts as smart too.  It 
> > needs a few more comments, but I think it's a good solution.
> > 
> > One could delay the backwards memcpy until vmexit time, but that would 
> > require a new flag so it's not worth it for what is a pretty rare and 
> > already expensive case.
> > 
> > Paolo
> > 
> 
> Hi!
> 
> I did some homework on this now and I would like to share few my thoughts on this:
> 
> First of all my attention caught the way we intercept the #SMI
> (this isn't 100% related to the bug but still worth talking about IMHO)
> 
> A. Bare metal: Looks like SVM allows to intercept SMI, with SVM_EXIT_SMI, 
>  with an intention of then entering the BIOS SMM handler manually using the SMM_CTL msr.
>  On bare metal we do set the INTERCEPT_SMI but we emulate the exit as a nop.
>  I guess on bare metal there are some undocumented bits that BIOS set which
>  make the CPU to ignore that SMI intercept and still take the #SMI handler,
>  normally but I wonder if we could still break some motherboard
>  code due to that.
> 
> 
> B. Nested: If #SMI is intercepted, then it causes nested VMEXIT.
>  Since KVM does enable SMI intercept, when it runs nested it means that all SMIs 
>  that nested KVM gets are emulated as NOP, and L1's SMI handler is not run.
> 
> 
> About the issue that was fixed in this patch. Let me try to understand how
> it would work on bare metal:
> 
> 1. A guest is entered. Host state is saved to VM_HSAVE_PA area (or stashed somewhere
>   in the CPU)
> 
> 2. #SMI (without intercept) happens
> 
> 3. CPU has to exit SVM, and start running the host SMI handler, it loads the SMM
>     state without touching the VM_HSAVE_PA runs the SMI handler, then once it RSMs,
>     it restores the guest state from SMM area and continues the guest
> 
> 4. Once a normal VMexit happens, the host state is restored from VM_HSAVE_PA
> 
> So host state indeed can't be saved to VMC01.
> 
> I to be honest think would prefer not to use the L1's hsave area but rather add back our
> 'hsave' in KVM and store there the L1 host state on the nested entry always.
> 
> This way we will avoid touching the vmcb01 at all and both solve the issue and 
> reduce code complexity.
> (copying of L1 host state to what basically is L1 guest state area and back
> even has a comment to explain why it (was) possible to do so.
> (before you discovered that this doesn't work with SMM).

I need more coffee today. The comment is somwhat wrong actually.
When L1 switches to L2, then its HSAVE area is L1 guest state, but
but L1 is a "host" vs L2, so it is host state.
The copying is more between kvm's register cache and the vmcb.

So maybe backing it up as this patch does is the best solution yet.
I will take more in depth look at this soon.

Best regards,
	Maxim Levitsky

> 
> Thanks again for fixing this bug!
> 
> Best regards,
> 	Maxim Levitsky


