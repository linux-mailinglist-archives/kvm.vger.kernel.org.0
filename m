Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DACB340A6A
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 17:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhCRQmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 12:42:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230509AbhCRQmK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 12:42:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616085729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w9mQxWNnMTssOskHnAPG1oAnNBJ6d1DSK5jOvwHv+88=;
        b=OYSMdjkpO/odgg70qJmLJlyjoXC4zXZu5dz2eGPu87Bct2PJRKuhU+6t0vC930EUO3YGGx
        jizxf7vXSoiEYtPgrRBhvLkoAmWEFMNteW45QOFpeSYJHhkeuGNO/PqtXvg0IPDhD8gKmH
        dBCIE7DaM/qmauHt+kvRgy4SgC/kA8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-WcOpsJfMMjmIsOroWLMHuQ-1; Thu, 18 Mar 2021 12:42:06 -0400
X-MC-Unique: WcOpsJfMMjmIsOroWLMHuQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CF31801817;
        Thu, 18 Mar 2021 16:42:03 +0000 (UTC)
Received: from starship (unknown [10.35.206.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DE4810023B0;
        Thu, 18 Mar 2021 16:41:58 +0000 (UTC)
Message-ID: <7169229dde171c8e10fb276ff8e1a869af99b39d.camel@redhat.com>
Subject: Re: [PATCH 3/3] KVM: SVM: allow to intercept all exceptions for
 debug
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>
Date:   Thu, 18 Mar 2021 18:41:57 +0200
In-Reply-To: <YFOBTITk7EkGdzR2@google.com>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
         <20210315221020.661693-4-mlevitsk@redhat.com> <YFBtI55sVzIJ15U+@8bytes.org>
         <4116d6ce75a85faccfe7a2b3967528f0561974ae.camel@redhat.com>
         <YFMbLWLlGgbOJuN/@8bytes.org>
         <8ba6676471dc8c8219e35d6a1695febaea20bb0b.camel@redhat.com>
         <YFN2HGG7ZTdamM7k@8bytes.org> <YFOBTITk7EkGdzR2@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-03-18 at 16:35 +0000, Sean Christopherson wrote:
> On Thu, Mar 18, 2021, Joerg Roedel wrote:
> > On Thu, Mar 18, 2021 at 11:24:25AM +0200, Maxim Levitsky wrote:
> > > But again this is a debug feature, and it is intended to allow the user
> > > to shoot himself in the foot.
> > 
> > And one can't debug SEV-ES guests with it, so what is the point of
> > enabling it for them too?
You can create a special SEV-ES guest which does handle all exceptions via
#VC, or just observe it fail which can be useful for some whatever reason.
> 
> Agreed.  I can see myself enabling debug features by default, it would be nice
> to not having to go out of my way to disable them for SEV-ES/SNP guests.
This does sound like a valid reason to disable this for SEV-ES.

> 
> Skipping SEV-ES guests should not be difficult; KVM could probably even
> print a message stating that the debug hook is being ignored.  One thought would
> be to snapshot debug_intercept_exceptions at VM creation, and simply zero it out
> for incompatible guests.  That would also allow changing debug_intercept_exceptions
> without reloading KVM, which IMO would be very convenient.
> 
So all right I'll disable this for SEV-ES. 
The idea to change the debug_intercept_exceptions on the fly is also a good idea,
I will implement it in next version of the patches.

Thanks for the review,
Best regards,
	Maxim Levitsky

