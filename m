Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A5557CEFB
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 17:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiGUPcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 11:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiGUPcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 11:32:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5AF0A13F79
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 08:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658417522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GgKT1VkFHod0SXS+lxkOUzuqRT5Wgmq8Kpjbic6X/pE=;
        b=E8w/MoVMSXnzFV76GOj3ayzUMsPzdPB+NPz7a4q94ck7GvJSlwws2u51fh1IQJTFGiGyqb
        /V/tulmMsJSUi0P6qtcXAF30pWHkVBZp7mcoZ083J/AswGUC9y0IIcosoSLh2CAy7F6/c0
        SqgxJ150Jg++5i/61MtqOg0fayZ6GtE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-Bc2sPCtJPYWTiDUoRGONtw-1; Thu, 21 Jul 2022 11:32:01 -0400
X-MC-Unique: Bc2sPCtJPYWTiDUoRGONtw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F5038037AC;
        Thu, 21 Jul 2022 15:32:00 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A9CD492C3B;
        Thu, 21 Jul 2022 15:31:57 +0000 (UTC)
Message-ID: <413f59cd3c0a80c5b71a0cd033fdaad082c5a0e7.camel@redhat.com>
Subject: Re: [PATCHv2 4/7] KVM: SVM: Report NMI not allowed when Guest busy
 handling VNMI
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Santosh Shukla <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 21 Jul 2022 18:31:56 +0300
In-Reply-To: <Ytlpxa2ULiIQFOnj@google.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
         <20220709134230.2397-5-santosh.shukla@amd.com>
         <Yth5hl+RlTaa5ybj@google.com>
         <c5acc3ac2aec4b98f9211ca3f4100c358bf2f460.camel@redhat.com>
         <Ytlpxa2ULiIQFOnj@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-21 at 14:59 +0000, Sean Christopherson wrote:
> On Thu, Jul 21, 2022, Maxim Levitsky wrote:
> > On Wed, 2022-07-20 at 21:54 +0000, Sean Christopherson wrote:
> > > On Sat, Jul 09, 2022, Santosh Shukla wrote:
> > > > @@ -3609,6 +3612,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
> > > >  {
> > > >  	struct vcpu_svm *svm = to_svm(vcpu);
> > > >  
> > > > +	if (is_vnmi_enabled(svm))
> > > > +		return;
> > > 
> > > Ugh, is there really no way to trigger an exit when NMIs become unmasked?  Because
> > > if there isn't, this is broken for KVM.
> > > 
> > > On bare metal, if two NMIs arrive "simultaneously", so long as NMIs aren't blocked,
> > > the first NMI will be delivered and the second will be pended, i.e. software will
> > > see both NMIs.  And if that doesn't hold true, the window for a true collision is
> > > really, really tiny.
> > > 
> > > But in KVM, because a vCPU may not be run a long duration, that window becomes
> > > very large.  To not drop NMIs and more faithfully emulate hardware, KVM allows two
> > > NMIs to be _pending_.  And when that happens, KVM needs to trigger an exit when
> > > NMIs become unmasked _after_ the first NMI is injected.
> > 
> > This is how I see this:
> > 
> > - When a NMI arrives and neither NMI is injected (V_NMI_PENDING) nor in service (V_NMI_MASK)
> >   then all it is needed to inject the NMI will be to set the V_NMI_PENDING bit and do VM entry.
> > 
> > - If V_NMI_PENDING is set but not V_NMI_MASK, and another NMI arrives we can make the
> >   svm_nmi_allowed return -EBUSY which will cause immediate VM exit,
> > 
> >   and if hopefully vNMI takes priority over the fake interrupt we raise, it will be injected,
> 
> Nit (for other readers following along), it's not a fake interrupt,I would describe
> it as spurious or ignored.  It's very much a real IRQ, which matters because it
> factors into event priority.

Yep, 100% agree.


> 
> >   and upon immediate VM exit we can inject another NMI by setting the V_NMI_PENDING again,
> >   and later when the guest is done with first NMI, it will take the second.
> 
> Yeaaaah.  This depends heavily on the vNMI being prioritized over the IRQ.
> 
> >   Of course if we get a nested exception, then it will be fun....
> > 
> >   (the patches don't do it (causing immediate VM exit), 
> >   but I think we should make the svm_nmi_allowed, check for the case for 
> >   V_NMI_PENDING && !V_NMI_MASK and make it return -EBUSY).
> 
> Yep, though I think there's a wrinkle (see below).
> 
> > - If both V_NMI_PENDING and V_NMI_MASK are set, then I guess we lose an NMI.
> >  (It means that the guest is handling an NMI, there is a pending NMI, and now
> >  another NMI arrived)
> > 
> >  Sean, this is the problem you mention, right?
> 
> Yep.  Dropping an NMI in the last case is ok, AFAIK no CPU will pend multiple NMIs
> while another is in-flight.  But triggering an immediate exit in svm_nmi_allowed()
> will hang the vCPU as the second pending NMI will never go away since the vCPU

The idea is to trigger the immediate exit only when a NMI was just injected (V_NMI_PENDING=1)
but not masked (that is currently in service, that is V_NMI_MASK=0).

In case both bits are set, the NMI is dropped, that is no immediate exit is requested.

In this case, next VM entry should have no reason to not inject the NMI and then VM exit
on the interrupt we raised, so there should not be a problem with forward progress.

There is an issue still, the NMI could also be masked if we are in SMM (I suggested
setting the V_NMI_MASK manually in this case), thus in this case we won't have more
that one pending NMI, but I guess this is not that big problem.

We can btw also in this case "open" the NMI window by waiting for RSM intercept.
(that is just not inject the NMI, and on RSM inject it, I think that KVM already does this)

I think it should overal work, but no doubt I do expect issues and corner cases,


> won't make forward progress to unmask NMIs.  This can also happen if there are
> two pending NMIs and GIF=0, i.e. any time there are multiple pending NMIs and NMIs
> are blocked.

GIF=0 can be dealt with though, if GIF is 0 when 2nd pending NMI arrives, we can
delay its injection to the moment the STGI is executed and intercept STGI.

We I think already do something like that as well.

> 
> One other question: what happens if software atomically sets V_NMI_PENDING while
> the VMCB is in use?  I assume bad things?  I.e. I assume KVM can't "post" NMIs :-)

I can't answer that but I bet that this bit is only checked on VM entry.


Another question about the spec (sorry if I already asked this):

if vGIF is used, and the guest does CLGI, does the CPU set the V_NMI_MASK,
itself, or the CPU considers both the V_GIF and the V_NMI_MASK in the int_ctl,
as a condition of delivering the NMI? I think that the later should be true,
and thus V_NMI_MASK is more like V_NMI_IN_SERVICE.

Best regards,
	Maxim Levitsky

> 


