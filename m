Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4BB3BDF8B
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 01:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhGFXDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 19:03:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34112 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229753AbhGFXDC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 19:03:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625612423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wnM7uWD8h8sAb0bplJlOFaFK57xyFhpXU767h7vFsIE=;
        b=jUpmPGkzc5kYu/DyQyIeMYm4QtrTycc3qmOk0gwvJsIbolGlQDvb2C9DyExL+V73pfoqvn
        z5ZGlqp4Eyp3OyUaRR+LKv1/NZqDsYkX9Y0YdqkiFXxTp5q9YNVMnjijncGDPCPeg3yb5P
        p7jLbq7Jbu5NBYX+KcI6ixwuZRFpTrk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-tJtWOjXBOFWrj_6B9vPIqw-1; Tue, 06 Jul 2021 19:00:21 -0400
X-MC-Unique: tJtWOjXBOFWrj_6B9vPIqw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11582100C661;
        Tue,  6 Jul 2021 23:00:20 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38BBB5C1D5;
        Tue,  6 Jul 2021 23:00:15 +0000 (UTC)
Message-ID: <6c0a0ffe6103272b648dbc3099f0445d5458059b.camel@redhat.com>
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     stsp <stsp2@yandex.ru>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Date:   Wed, 07 Jul 2021 02:00:14 +0300
In-Reply-To: <20b01f9d-de7a-91a3-e086-ddd4ae27629f@yandex.ru>
References: <20210628124814.1001507-1-stsp2@yandex.ru>
         <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
         <7969ff6b1406329a5a931c4ae39cb810db3eefcd.camel@redhat.com>
         <7f264d9f-cb59-0d10-d435-b846f9b61333@yandex.ru>
         <71e0308e9e289208b8457306b3cb6d6f23e795f9.camel@redhat.com>
         <20b01f9d-de7a-91a3-e086-ddd4ae27629f@yandex.ru>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-07-07 at 00:50 +0300, stsp wrote:
> 06.07.2021 23:29, Maxim Levitsky пишет:
> > On Tue, 2021-07-06 at 15:06 +0300, stsp wrote:
> > > 06.07.2021 14:49, Maxim Levitsky пишет:
> > > > Now about the KVM's userspace API where this is exposed:
> > > >    
> > > > I see now too that KVM_SET_REGS clears the pending exception.
> > > > This is new to me and it is IMHO *wrong* thing to do.
> > > > However I bet that someone somewhere depends on this,
> > > > since this behavior is very old.
> > > What alternative would you suggest?
> > > Check for ready_for_interrupt_injection
> > > and never call KVM_SET_REGS if it indicates
> > > "not ready"?
> > > But what if someone calls it nevertheless?
> > > Perhaps return an error from KVM_SET_REGS
> > > if exception is pending? Also KVM_SET_SREGS
> > > needs some treatment here too, as it can
> > > also be called when an exception is pending,
> > > leading to problems.
> > As I explained you can call KVM_GET_VCPU_EVENTS before calling
> > KVM_SET_REGS and then call KVM_SET_VCPU_EVENTS with the struct
> > that was filled by KVM_GET_VCPU_EVENTS.
> > That will preserve all the cpu events.
> 
> The question is different.
> I wonder how _should_ the KVM
> API behave when someone calls
> KVM_SET_REGS/KVM_SET_SREGS

KVM_SET_REGS should not clear the pending exception.
but fixing this can break API compatibilitly if some
hypervisor (not qemu) relies on it.

Thus either a new ioctl is needed or as I said,
KVM_GET_VCPU_EVENTS/KVM_SET_VCPU_EVENTS can be used
to preserve the events around that call as workaround.

Best regards,
	Maxim Levitsky


> while the exception is pending.
> This is currently not handled properly.
> We can add/fix the indication with
> ready_for_interrupt_injection,
> but someone will ignore that
> indication, so some handling
> (like returning an error) should
> be added.
> So what would you propose the
> KVM_SET_REGS should do if it is
> called when an exception is pending?


> The question is here because
> currently KVM_SET_REGS and
> KVM_SET_SREGS handle that differently:
> one is trying to cancel the pending
> excpetion, and the other one
> does nothing, but both are wrong.
> 


