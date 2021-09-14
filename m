Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99FB40ACA0
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 13:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhINLk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 07:40:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232420AbhINLkx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 07:40:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631619575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VXsGLVph1NbqQ2nkvDoWH9B2JiDcc6lqU3jEfo1REJk=;
        b=SWLmyt/kaSxpj4MLSWPnV9hKO8tEBoiocDkndHhrqdufWdoI+3xW0YmSR242T8d3e0O9Rh
        2Xbr/h2kBNAuWN6dABimbyur9/WxHRyblAu2Q6s2tS47K7v3OeUxwtVKGrw3GLZrmJyH9h
        B2aVJ+HLAbhTIJ6imDM18qouvZRQWU0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-WrrSKas9MgCaVgh6GAv1lQ-1; Tue, 14 Sep 2021 07:39:32 -0400
X-MC-Unique: WrrSKas9MgCaVgh6GAv1lQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 498B71811EC1;
        Tue, 14 Sep 2021 11:39:30 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16CA81002388;
        Tue, 14 Sep 2021 11:39:24 +0000 (UTC)
Message-ID: <5fec07dfcfd53421293c3814796f1aa4add4a126.camel@redhat.com>
Subject: Re: [RFC PATCH 3/3] nSVM: use svm->nested.save to load vmcb12
 registers and avoid TOC/TOU races
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Date:   Tue, 14 Sep 2021 14:39:23 +0300
In-Reply-To: <a1ab92dd-6e76-fb30-d570-582cd3ebecd3@redhat.com>
References: <20210903102039.55422-1-eesposit@redhat.com>
         <20210903102039.55422-4-eesposit@redhat.com>
         <21d2bf8c4e3eb3fc5d297fd13300557ec686b625.camel@redhat.com>
         <73b5a5bb-48f2-3a08-c76b-a82b5b69c406@redhat.com>
         <9585f1387b2581d30b74cd163a9aac2adbd37a93.camel@redhat.com>
         <2b1e17416cef1e37f42e9bc8b2283b03d2651cb2.camel@redhat.com>
         <ee207b0c-eab3-13ba-44be-999f849008d2@redhat.com>
         <fb828c752fac255c6a1d997ff27dfc5264a5c658.camel@redhat.com>
         <a1ab92dd-6e76-fb30-d570-582cd3ebecd3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-09-14 at 12:52 +0200, Emanuele Giuseppe Esposito wrote:
> > I would do it this way:
> > 
> > struct svm_nested_state {
> >          ...
> > 	/* cached fields from the vmcb12 */
> > 	struct  vmcb_control_area_cached ctl;
> > 	struct  vmcb_save_area_cached save;
> >          ...
> > };
> > 
> > 
> 
> The only thing that requires a little bit of additional work when 
> applying this is svm_get_nested_state() (and theoretically 
> svm_set_nested_state(), in option 2). In this function, nested.ctl is 
> copied in user_vmcb->control. But now nested.ctl is not anymore a 
> vmcb_control_area, so the sizes differ.
> 
> There are 2 options here:
> 1) copy nested.ctl into a full vmcb_control_area, and copy it to user 
> space without modifying the API. The advantage is that the API is left 
> intact, but an additional copy is required.

Thankfully there KVM_GET_NESTED_STATE is not performance critical at all,
so a copy isn't that big problem, other that it is a bit ugly.
Ugh..

> 
> 2) modify KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE to handle 
> vmcb_control_area_cached. Advantage is that there is a lightweight copy 
> + the benefits explained by you in the previous email (no unset field).

That would break the KVM_GET_NESTED_STATE ABI without a very good reason,
especially since some of the currently unused fields in the ctl (there
are I think very few of them), might became used later on, needing
to break the ABI again.

Best regards,
	Maxim Levitsky



> 
> I am not sure which one is the preferred way here.
> 
> Thank you,
> Emanuele
> 


