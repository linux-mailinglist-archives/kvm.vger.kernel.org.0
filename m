Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AF857CE65
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbiGUO7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiGUO7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:59:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD0585F97
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:59:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gn24so1847698pjb.3
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4TYOnX676mMgfe6CZ/hiyrJOwKAronPGTJf1JCscAMI=;
        b=TBE6Efk/I3IG2trsP0rFYwkLs1qSNtjYoGlMb3a9lmvCJ4Cj4n1J/ctdvB6TnDE/Gl
         sZe9fxptp+ebfg18+cnQEAGuDi+OAUMxbhn/yJ317xqRDVHwJZXcxxiEkelD3LAIoVtY
         zW0cQxbnnhnqt7Re5ntWLWhB4gWsbtj0U3GCn1W5/FCPgzXJKAc7GRupV4khX723LkT0
         3wB9Ck3D1JRI/X+TA2gtZch0ZxjNCmvo1iC80Pq2xEnP0jYTxy3WOGxkw7gm829c3t4C
         bCvSIgkIHbXQ4bYfvv4eCrhu03St6cijN0Q507L6niKZTlg6dmHa4CRKq6h9i1l5tgYq
         vdSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4TYOnX676mMgfe6CZ/hiyrJOwKAronPGTJf1JCscAMI=;
        b=bzHVsuJEnzBLZck6gPmF3qlemBmTXo5NooK53ZYrJ6b7YaKwvLmKrQeNd/2ihKQvss
         vgIN/DaLZhWcWS8Z9qgObzAq+lCISpwLLrBQ8yo4Cl7oSlX4nn873kwdS5P/wpUO3KbM
         Xg+8aO+XbT5UEsZEYBaVpcw0+Nij6QchgixELX3EMq6R+n4bFL8DSX2TFpzuM52ShVzh
         PpR+uUT0gMHSbMqV5CU+eOKVQjDhW2+TJRpLhY9UPndLkthRTewXYmF9D73bliCiLxA9
         aQgR0P+UIYdDYtiUm//ZPfYr8BvSms0l/Avqd5x0WnaDWVtPKVu+mUGFeM/DSqo/g+io
         ImOg==
X-Gm-Message-State: AJIora9wBsngm3TokBO+6TEWA9zrOX33OeDU8Rb1c/F1i1GTjYgH8H67
        Clz02HUyJ5c5DHEz7SQzRbIkgA==
X-Google-Smtp-Source: AGRyM1sSS193k6aqTgka4Izsgjyj7WnNq/tBz9JnINc2XcYKtN4CoJwPYoOZRPA/diqwLRqIjMHg0Q==
X-Received: by 2002:a17:903:234d:b0:16c:5a7e:f534 with SMTP id c13-20020a170903234d00b0016c5a7ef534mr43136515plh.35.1658415562031;
        Thu, 21 Jul 2022 07:59:22 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id a139-20020a621a91000000b005290553d343sm1885225pfa.193.2022.07.21.07.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 07:59:21 -0700 (PDT)
Date:   Thu, 21 Jul 2022 14:59:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Santosh Shukla <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 4/7] KVM: SVM: Report NMI not allowed when Guest busy
 handling VNMI
Message-ID: <Ytlpxa2ULiIQFOnj@google.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
 <20220709134230.2397-5-santosh.shukla@amd.com>
 <Yth5hl+RlTaa5ybj@google.com>
 <c5acc3ac2aec4b98f9211ca3f4100c358bf2f460.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5acc3ac2aec4b98f9211ca3f4100c358bf2f460.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 21, 2022, Maxim Levitsky wrote:
> On Wed, 2022-07-20 at 21:54 +0000, Sean Christopherson wrote:
> > On Sat, Jul 09, 2022, Santosh Shukla wrote:
> > > @@ -3609,6 +3612,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
> > >  {
> > >  	struct vcpu_svm *svm = to_svm(vcpu);
> > >  
> > > +	if (is_vnmi_enabled(svm))
> > > +		return;
> > 
> > Ugh, is there really no way to trigger an exit when NMIs become unmasked?  Because
> > if there isn't, this is broken for KVM.
> > 
> > On bare metal, if two NMIs arrive "simultaneously", so long as NMIs aren't blocked,
> > the first NMI will be delivered and the second will be pended, i.e. software will
> > see both NMIs.  And if that doesn't hold true, the window for a true collision is
> > really, really tiny.
> > 
> > But in KVM, because a vCPU may not be run a long duration, that window becomes
> > very large.  To not drop NMIs and more faithfully emulate hardware, KVM allows two
> > NMIs to be _pending_.  And when that happens, KVM needs to trigger an exit when
> > NMIs become unmasked _after_ the first NMI is injected.
> 
> 
> This is how I see this:
> 
> - When a NMI arrives and neither NMI is injected (V_NMI_PENDING) nor in service (V_NMI_MASK)
>   then all it is needed to inject the NMI will be to set the V_NMI_PENDING bit and do VM entry.
> 
> - If V_NMI_PENDING is set but not V_NMI_MASK, and another NMI arrives we can make the
>   svm_nmi_allowed return -EBUSY which will cause immediate VM exit,
> 
>   and if hopefully vNMI takes priority over the fake interrupt we raise, it will be injected,

Nit (for other readers following along), it's not a fake interrupt,I would describe
it as spurious or ignored.  It's very much a real IRQ, which matters because it
factors into event priority.

>   and upon immediate VM exit we can inject another NMI by setting the V_NMI_PENDING again,
>   and later when the guest is done with first NMI, it will take the second.

Yeaaaah.  This depends heavily on the vNMI being prioritized over the IRQ.

>   Of course if we get a nested exception, then it will be fun....
> 
>   (the patches don't do it (causing immediate VM exit), 
>   but I think we should make the svm_nmi_allowed, check for the case for 
>   V_NMI_PENDING && !V_NMI_MASK and make it return -EBUSY).

Yep, though I think there's a wrinkle (see below).

> - If both V_NMI_PENDING and V_NMI_MASK are set, then I guess we lose an NMI.
>  (It means that the guest is handling an NMI, there is a pending NMI, and now
>  another NMI arrived)
> 
>  Sean, this is the problem you mention, right?

Yep.  Dropping an NMI in the last case is ok, AFAIK no CPU will pend multiple NMIs
while another is in-flight.  But triggering an immediate exit in svm_nmi_allowed()
will hang the vCPU as the second pending NMI will never go away since the vCPU
won't make forward progress to unmask NMIs.  This can also happen if there are
two pending NMIs and GIF=0, i.e. any time there are multiple pending NMIs and NMIs
are blocked.

One other question: what happens if software atomically sets V_NMI_PENDING while
the VMCB is in use?  I assume bad things?  I.e. I assume KVM can't "post" NMIs :-)
