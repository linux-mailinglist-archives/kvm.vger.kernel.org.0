Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328463B1AAA
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 15:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhFWNER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 09:04:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40910 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230454AbhFWNEQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 09:04:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624453318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TyzGFBztt+s07R786vixast5a60Y52xKVtpSjaEcYoA=;
        b=Ea33kkjWQje3aqnox6tBvTk7OAskUl7R4wIrSE7/pnZbybgNhXSFxBpi7Zbik0+lsHOKy5
        +er38r+fvCJVps+hFAZLL0d117MrOhih5nAjlh+zn+5ZahOQryxclWEkwtrt2dugt8obVz
        JVgDn1N21RpAUmZ0S1jb6zLf43uCog4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-fGOYNdKuOe20KKvS4uxNMg-1; Wed, 23 Jun 2021 09:01:57 -0400
X-MC-Unique: fGOYNdKuOe20KKvS4uxNMg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB5E0802C80;
        Wed, 23 Jun 2021 13:01:55 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAE0910246F1;
        Wed, 23 Jun 2021 13:01:49 +0000 (UTC)
Message-ID: <53a9f893cb895f4b52e16c374cbe988607925cdf.camel@redhat.com>
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
Date:   Wed, 23 Jun 2021 16:01:48 +0300
In-Reply-To: <a3918bfa-7b4f-c31a-448a-aa22a44d4dfd@redhat.com>
References: <20210623074427.152266-1-vkuznets@redhat.com>
         <a3918bfa-7b4f-c31a-448a-aa22a44d4dfd@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-06-23 at 11:39 +0200, Paolo Bonzini wrote:
> On 23/06/21 09:44, Vitaly Kuznetsov wrote:
> > - RFC: I'm not 100% sure my 'smart' idea to use currently-unused HSAVE area
> > is that smart. Also, we don't even seem to check that L1 set it up upon
> > nested VMRUN so hypervisors which don't do that may remain broken. A very
> > much needed selftest is also missing.
> 
> It's certainly a bit weird, but I guess it counts as smart too.  It 
> needs a few more comments, but I think it's a good solution.
> 
> One could delay the backwards memcpy until vmexit time, but that would 
> require a new flag so it's not worth it for what is a pretty rare and 
> already expensive case.
> 
> Paolo
> 

Hi!

I did some homework on this now and I would like to share few my thoughts on this:

First of all my attention caught the way we intercept the #SMI
(this isn't 100% related to the bug but still worth talking about IMHO)

A. Bare metal: Looks like SVM allows to intercept SMI, with SVM_EXIT_SMI, 
 with an intention of then entering the BIOS SMM handler manually using the SMM_CTL msr.
 On bare metal we do set the INTERCEPT_SMI but we emulate the exit as a nop.
 I guess on bare metal there are some undocumented bits that BIOS set which
 make the CPU to ignore that SMI intercept and still take the #SMI handler,
 normally but I wonder if we could still break some motherboard
 code due to that.


B. Nested: If #SMI is intercepted, then it causes nested VMEXIT.
 Since KVM does enable SMI intercept, when it runs nested it means that all SMIs 
 that nested KVM gets are emulated as NOP, and L1's SMI handler is not run.


About the issue that was fixed in this patch. Let me try to understand how
it would work on bare metal:

1. A guest is entered. Host state is saved to VM_HSAVE_PA area (or stashed somewhere
  in the CPU)

2. #SMI (without intercept) happens

3. CPU has to exit SVM, and start running the host SMI handler, it loads the SMM
    state without touching the VM_HSAVE_PA runs the SMI handler, then once it RSMs,
    it restores the guest state from SMM area and continues the guest

4. Once a normal VMexit happens, the host state is restored from VM_HSAVE_PA

So host state indeed can't be saved to VMC01.

I to be honest think would prefer not to use the L1's hsave area but rather add back our
'hsave' in KVM and store there the L1 host state on the nested entry always.

This way we will avoid touching the vmcb01 at all and both solve the issue and 
reduce code complexity.
(copying of L1 host state to what basically is L1 guest state area and back
even has a comment to explain why it (was) possible to do so.
(before you discovered that this doesn't work with SMM).

Thanks again for fixing this bug!

Best regards,
	Maxim Levitsky

