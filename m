Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B0033D22E
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 11:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhCPKvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 06:51:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37571 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230410AbhCPKvd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 06:51:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615891892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nchxxRUQi7eMKbEVfMrV84sz1KWIdt/rbY4tS+YkaWc=;
        b=ZIWbzNAWcZ4RO8lNmiNH5Bf9N6vEZe87IpDQeW3ue1P3TSMPewdrKeDYlEvlSiHVbWPo2W
        w/w1q93KDnIXKWNCFbW8hD86zAqhlLhD5IU2tXPlqm4HjuQ9qd+lGeoocZaWhfkSdJQJUP
        jV6nFOGigfTU/6thYsWmdranGxeS4Os=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-YmjYYYPdN42a1pIdvYDS9w-1; Tue, 16 Mar 2021 06:51:30 -0400
X-MC-Unique: YmjYYYPdN42a1pIdvYDS9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DCAA18460E3;
        Tue, 16 Mar 2021 10:51:28 +0000 (UTC)
Received: from starship (unknown [10.35.207.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55C751A881;
        Tue, 16 Mar 2021 10:51:21 +0000 (UTC)
Message-ID: <4116d6ce75a85faccfe7a2b3967528f0561974ae.camel@redhat.com>
Subject: Re: [PATCH 3/3] KVM: SVM: allow to intercept all exceptions for
 debug
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>
Date:   Tue, 16 Mar 2021 12:51:20 +0200
In-Reply-To: <YFBtI55sVzIJ15U+@8bytes.org>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
         <20210315221020.661693-4-mlevitsk@redhat.com> <YFBtI55sVzIJ15U+@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-03-16 at 09:32 +0100, Joerg Roedel wrote:
> Hi Maxim,
> 
> On Tue, Mar 16, 2021 at 12:10:20AM +0200, Maxim Levitsky wrote:
> > -static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
> > +static int (*svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
> 
> Can you keep this const and always set the necessary handlers? If
> exceptions are not intercepted they will not be used.
> 
> > @@ -333,7 +334,9 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
> >  	struct vmcb *vmcb = svm->vmcb01.ptr;
> >  
> >  	WARN_ON_ONCE(bit >= 32);
> > -	vmcb_clr_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
> > +
> > +	if (!((1 << bit) & debug_intercept_exceptions))
> > +		vmcb_clr_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
> 
> This will break SEV-ES guests, as those will not cause an intercept but
> now start to get #VC exceptions on every other exception that is raised.
> SEV-ES guests are not prepared for that and will not even boot, so
> please don't enable this feature for them.

I agree but what is wrong with that? 
This is a debug feature, and it only can be enabled by the root,
and so someone might actually want this case to happen
(e.g to see if a SEV guest can cope with extra #VC exceptions).

I have nothing against not allowing this for SEV-ES guests though.
What do you think?


Best regards,
	Maxim Levitsky

