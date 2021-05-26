Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB6B391C76
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 17:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235405AbhEZPyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 11:54:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53750 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234798AbhEZPyG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 11:54:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622044354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0VyAuC1F8BnKggqnnpy3D59/MnIA3mks41oudTXHz3o=;
        b=Pb88UE4t3ilGfXvk+N0juJYilTGbfG2QKoKxcDbyPEqEV8oXRaSGNe7kvj+vt5exyqTxuD
        nCBvLz8CJlkpVyv0zgJyPEZDKZ8l8oMoVaQdZRQmIqlmEyuDghs9ixEIyGFY7J4kh5EhtP
        Uu9TbVPR0u6zFRe4MIIiwpL+2ZpTRVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-aXZAA8OlNuShkeCY2-xiPA-1; Wed, 26 May 2021 11:52:29 -0400
X-MC-Unique: aXZAA8OlNuShkeCY2-xiPA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F330801817;
        Wed, 26 May 2021 15:52:28 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5DBE5D723;
        Wed, 26 May 2021 15:52:25 +0000 (UTC)
Message-ID: <8e2570c580baf6d4d650ebc28b98a5ed76cb4f9b.camel@redhat.com>
Subject: Re: [PATCH v2 3/5] KVM: x86: Use common 'enable_apicv' variable for
 both APICv and AVIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Date:   Wed, 26 May 2021 18:52:24 +0300
In-Reply-To: <YK5kQcTh8LmE0+8I@google.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
         <20210518144339.1987982-4-vkuznets@redhat.com>
         <1b9a654596f755ee5ef42ce11136ed2bbb3995a0.camel@redhat.com>
         <YK5kQcTh8LmE0+8I@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-05-26 at 15:07 +0000, Sean Christopherson wrote:
> On Wed, May 26, 2021, Maxim Levitsky wrote:
> > On Tue, 2021-05-18 at 16:43 +0200, Vitaly Kuznetsov wrote:
> > > Unify VMX and SVM code by moving APICv/AVIC enablement tracking to common
> > > 'enable_apicv' variable. Note: unlike APICv, AVIC is disabled by default.
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 9b6bca616929..23fdbba6b394 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -209,6 +209,9 @@ EXPORT_SYMBOL_GPL(host_efer);
> > >  bool __read_mostly allow_smaller_maxphyaddr = 0;
> > >  EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
> > >  
> > > +bool __read_mostly enable_apicv = true;
> > 
> > Nitpick: I don't like this asymmetry.
> > 
> > VMX and the common code uses the enable_apicv module param and variable,
> > while SVM uses avic, which sets the enable_apicv variable.
> >  
> > I'll prefer both VMX and SVM have their own private variable for their
> > avic/apicv module param, which should set a common variable later.
> 
> I don't love the intermediate "avic" either, but there isn't a good alternative.
> Forcing VMX to also use an intermediate doesn't make much sense, we'd be penalizing
> ourselves in the form of unnecessary complexity just because AVIC needs to be
> disabled by default for reasons KVM can't fix.
This is also something we should eventually reconsider. 
These days, the AVIC works quite well and disables itself when needed.
When do you think it will be the time to enable it by default?

> 
> As for the asymmetry, I actually like it because it makes "avic" stand out and
> highlights that there is weirdness with enabling AVIC.
You mean that it is disabled by default?

Anyway I don't have that strong opinion on this,
so let it be like this.

Best regards,
	Maxim Levitsky


> 


