Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BC257D14C
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbiGUQSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbiGUQRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:17:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0CFA52E4E
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 09:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658420240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iVqv0DH0Rdu3Hx2gmqiPwyuJENuZAXX6QoeoOvG6sKo=;
        b=WUtq0fPdHt0ecQIF2RWwnhxySVXjeARyRQysrWBDnsi9uA93xaLy/g34JvKH0sk3Yyii2O
        59dhQWeK75NpZi6q4oPfi2z7uXi4w+2kGmIha9EXYZlUDNnJ5BPqMXDXS/LUUwfCnUg1Vy
        4z+1wa6hVsCcA4p4ipfbF6Zi5Ha6uJo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-UsMk2uezMCyR3rV2bxDVBw-1; Thu, 21 Jul 2022 12:17:17 -0400
X-MC-Unique: UsMk2uezMCyR3rV2bxDVBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B66BD858EFE;
        Thu, 21 Jul 2022 16:17:16 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49590909FF;
        Thu, 21 Jul 2022 16:17:14 +0000 (UTC)
Message-ID: <23f156d46033a6434591186b0a7bcce3d8a138d1.camel@redhat.com>
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
Date:   Thu, 21 Jul 2022 19:17:13 +0300
In-Reply-To: <Ytl6GLui7UQFi3FO@google.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
         <20220709134230.2397-5-santosh.shukla@amd.com>
         <Yth5hl+RlTaa5ybj@google.com>
         <c5acc3ac2aec4b98f9211ca3f4100c358bf2f460.camel@redhat.com>
         <Ytlpxa2ULiIQFOnj@google.com>
         <413f59cd3c0a80c5b71a0cd033fdaad082c5a0e7.camel@redhat.com>
         <Ytl6GLui7UQFi3FO@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-21 at 16:08 +0000, Sean Christopherson wrote:
> On Thu, Jul 21, 2022, Maxim Levitsky wrote:
> > On Thu, 2022-07-21 at 14:59 +0000, Sean Christopherson wrote:
> > > Yep.  Dropping an NMI in the last case is ok, AFAIK no CPU will pend multiple NMIs
> > > while another is in-flight.  But triggering an immediate exit in svm_nmi_allowed()
> > > will hang the vCPU as the second pending NMI will never go away since the vCPU
> > 
> > The idea is to trigger the immediate exit only when a NMI was just injected (V_NMI_PENDING=1)
> > but not masked (that is currently in service, that is V_NMI_MASK=0).
> 
> I assume you mean "and an NMI is currently NOT in service"?

Yes
> 
> Anyways, we're on the same page, trigger an exit if and only if there's an NMI pending
> and the vCPU isn't already handling a vNMI.  We may need to explicitly drop one of
> the pending NMIs in that case though, otherwise the NMI that _KVM_ holds pending could
> get "injected" well after NMIs are unmasked, which could suprise the guest.  E.g.
> guest IRETs from the second (of three) NMIs, KVM doesn't "inject" that third NMI
> until the next VM-Exit, which could be a long time in the future.
> 
> > In case both bits are set, the NMI is dropped, that is no immediate exit is requested.
> > 
> > In this case, next VM entry should have no reason to not inject the NMI and then VM exit
> > on the interrupt we raised, so there should not be a problem with forward progress.
> > 
> > There is an issue still, the NMI could also be masked if we are in SMM (I suggested
> > setting the V_NMI_MASK manually in this case), thus in this case we won't have more
> > that one pending NMI, but I guess this is not that big problem.
> > 
> > We can btw also in this case "open" the NMI window by waiting for RSM intercept.
> > (that is just not inject the NMI, and on RSM inject it, I think that KVM already does this)
> > 
> > I think it should overal work, but no doubt I do expect issues and corner cases,
> > 
> > 
> > > won't make forward progress to unmask NMIs.  This can also happen if there are
> > > two pending NMIs and GIF=0, i.e. any time there are multiple pending NMIs and NMIs
> > > are blocked.
> > 
> > GIF=0 can be dealt with though, if GIF is 0 when 2nd pending NMI arrives, we can
> > delay its injection to the moment the STGI is executed and intercept STGI.
> > 
> > We I think already do something like that as well.
> 
> Yep, you're right, svm_enable_nmi_window() sets INTERCEPT_STGI if VGIF is enabled
> and GIF=0 (and STGI exits unconditional if VGIF=0?

Its not unconditional but KVM has to set the intercept, otherwise the guest
will control the host's GIF.

Best regards,
	Maxim Levitsky


> ).
> 
> So we have a poor man's NMI-window exiting.

Yep, we also intercept IRET for the same purpose, and RSM interception
is also a place the NMI are evaluated.

We only single step over the IRET, because NMIs are unmasked _after_ the IRET
retires.

Best regards,
	Maxim Levitsky
> 


