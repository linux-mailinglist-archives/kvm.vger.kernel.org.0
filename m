Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D0F3401FC
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 10:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhCRJZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 05:25:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52024 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229927AbhCRJYi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 05:24:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616059478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nykiyaeCBaGeYOGatXJD1GHSD/9h0gHc7oJWiCYB0Xs=;
        b=FktoBDO5YE2lZwVi+NOwIFS9ppnq8xWXZbL9gZzFbASwp9XEAfuiaRT3d558enuEokVhlY
        WOF314Jg1sXJjfgPxJ3dTPwnjetrXaJ9vBdYqjAXvY2UMHKxffVuTsWviwhDznc3ots7MB
        E6JR9/84O+ZcgnKButm1NMICeB/Ix+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-LJKfGCoxN-KNvB0lGcxgKQ-1; Thu, 18 Mar 2021 05:24:34 -0400
X-MC-Unique: LJKfGCoxN-KNvB0lGcxgKQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 836A41084C83;
        Thu, 18 Mar 2021 09:24:32 +0000 (UTC)
Received: from starship (unknown [10.35.206.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 305C010013C1;
        Thu, 18 Mar 2021 09:24:26 +0000 (UTC)
Message-ID: <8ba6676471dc8c8219e35d6a1695febaea20bb0b.camel@redhat.com>
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
Date:   Thu, 18 Mar 2021 11:24:25 +0200
In-Reply-To: <YFMbLWLlGgbOJuN/@8bytes.org>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
         <20210315221020.661693-4-mlevitsk@redhat.com> <YFBtI55sVzIJ15U+@8bytes.org>
         <4116d6ce75a85faccfe7a2b3967528f0561974ae.camel@redhat.com>
         <YFMbLWLlGgbOJuN/@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-03-18 at 10:19 +0100, Joerg Roedel wrote:
> On Tue, Mar 16, 2021 at 12:51:20PM +0200, Maxim Levitsky wrote:
> > I agree but what is wrong with that? 
> > This is a debug feature, and it only can be enabled by the root,
> > and so someone might actually want this case to happen
> > (e.g to see if a SEV guest can cope with extra #VC exceptions).
> 
> That doesn't make sense, we know that and SEV-ES guest can't cope with
> extra #VC exceptions, so there is no point in testing this. It is more a
> way to shot oneself into the foot for the user and a potential source of
> bug reports for SEV-ES guests.

But again this is a debug feature, and it is intended to allow the user
to shoot himself in the foot. Bug reports for a debug feature
are autoclosed. It is no different from say poking kernel memory with
its built-in gdbstub, for example.

Best regards,
	Maxim Levitsky

> 
> 
> > I have nothing against not allowing this for SEV-ES guests though.
> > What do you think?
> 
> I think SEV-ES guests should only have the intercept bits set which
> guests acutally support

> 
> Regards,
> 
> 	Joerg
> 


