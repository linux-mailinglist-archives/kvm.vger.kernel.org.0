Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CBB3B2A3F
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 10:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhFXIW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 04:22:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231713AbhFXIWu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 04:22:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624522831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yzCIhgWSWB1sGxIlTQQBY+Zll9G7G2k/fD0vgf07hXQ=;
        b=QhjDroefQcTiQLipjoThTmLc/Mnv0cybC5SxrGjb/GkQt5Qv9BgdNGyaVWWbxk7mXyTlh9
        yoPam/i8WGDRXMfW+A8MgtcEgsoFkz7VYRTxkrjJjCHUEclCXNRngtPizhsKALNYC8NROM
        2eHeckQKSUoGQU9APOxv6lCaJE247ZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-f1BdehLZN8ywnuYFBfwzeA-1; Thu, 24 Jun 2021 04:20:30 -0400
X-MC-Unique: f1BdehLZN8ywnuYFBfwzeA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E72B21054F9A;
        Thu, 24 Jun 2021 08:20:28 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 189FC1001281;
        Thu, 24 Jun 2021 08:20:25 +0000 (UTC)
Message-ID: <83affeedb9a3d091bece8f5fdd5373342298dcd3.camel@redhat.com>
Subject: Re: [PATCH RFC] KVM: nSVM: Fix L1 state corruption upon return from
 SMM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Thu, 24 Jun 2021 11:20:24 +0300
In-Reply-To: <82327cd1-92ca-9f6b-3af0-8215e9d21eae@redhat.com>
References: <20210623074427.152266-1-vkuznets@redhat.com>
         <a3918bfa-7b4f-c31a-448a-aa22a44d4dfd@redhat.com>
         <53a9f893cb895f4b52e16c374cbe988607925cdf.camel@redhat.com>
         <ac98150acd77f4c09167bc1bb1c552db68925cf2.camel@redhat.com>
         <87pmwc4sh4.fsf@vitty.brq.redhat.com>
         <5fc502b70a89e18034716166abc65caec192c19b.camel@redhat.com>
         <YNNc9lKIzM6wlDNf@google.com> <YNNfnLsc+3qMsdlN@google.com>
         <82327cd1-92ca-9f6b-3af0-8215e9d21eae@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-06-23 at 22:37 +0200, Paolo Bonzini wrote:
> On 23/06/21 18:21, Sean Christopherson wrote:
> > On Wed, Jun 23, 2021, Sean Christopherson wrote:
> > > And I believe this hackery is necessary only because nested_svm_vmexit() isn't
> > > following the architcture in the first place.  I.e. using vmcb01 to restore
> > > host state is flat out wrong.
> > 
> > Ah, that's not true, using vmcb01 is allowed by "may store some or all host state
> > in hidden on-chip memory".
> 
> And also, "Different implementations may choose to save the hidden parts 
> of the host’s segment registers as well as the selectors".
> 
> >  From a performance perspective, I do like the SMI/RSM shenanigans.  I'm not
> > totally opposed to the trickery since I think it will break a guest if and only
> > if the L1 guest is also violating the APM.  And we're not fudging the spec thaat
> > much :-)
> 
> Yeah, that was my reasoning as well.  Any reference to "hidden on-chip 
> memory", plus the forbidding modifications of the host save area, sort 
> of implies that the processor can actually flush that hidden on-chip 
> memory for whatever reason (such as on some sleep states?!?).
> 
> Paolo
> 

Let me explain my thoughts about this again, now that I hopefully
understand this correctly:

L1 register state is stored in VMCB01 since the CPU stores it there,
every time L1 VMexits.

Now L1 is a host for L2, and therefore this is also L1 "host" state.

When we switch to L2, it is therefore natural to keep that state in
vmcb01, and not copy it to VM_HSAVE_PA area.

So when running SMM code in L1, since we must not corrupt this state,
It makes sense to back it up somewhere,
but as I said I prefer to store/migrate it out of band instead of
saving it in the guest memory, although Paolo's reasoning that CPU
might *sometimes* write VM_HSAVE_PA and that *sometimes* is allowed to be
when we enter SMM,  does make sense.
Thus I don't have a strong opinion on this anymore, as long as it works.

Something else to note, just for our information is that KVM 
these days does vmsave/vmload to VM_HSAVE_PA to store/restore 
the additional host state, something that is frowned upon in the spec, 
but there is some justification of doing this in the commit message,
citing an old spec which allowed this.
This shoudn't affect anything, but just FYI.

https://patchwork.kernel.org/project/kvm/patch/20201210174814.1122585-1-michael.roth@amd.com/

Best regards,
	Maxim Levitsky

