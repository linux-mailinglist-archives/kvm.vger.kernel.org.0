Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04C3593436
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 19:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbiHORxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 13:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiHORxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 13:53:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1C36286EC
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 10:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660585979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=15DarLJ2UNtljDu/NGD1MWWRNaKZ/jpeSOvRGy2XtIg=;
        b=YuqRUBH/BEqFF5Kww4+daSIsSBvtoqPAOW9EH6UuNPK0cspB1qXzWy7e8c1sSyPYjkYI04
        6XpFLiSk2WrXU5vVxsD2VIyao1MIj+rmNw3Cas0mr/Vvnb43awOQYE6YjTCiau0+9bwRP2
        2Af931QoKpOeF4Al6fi85zvbQr20Mqk=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-621-BwYB6hMmMAqJwCKOLoM0MA-1; Mon, 15 Aug 2022 13:52:58 -0400
X-MC-Unique: BwYB6hMmMAqJwCKOLoM0MA-1
Received: by mail-il1-f198.google.com with SMTP id q10-20020a056e020c2a00b002dedb497c7fso5516195ilg.16
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 10:52:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=15DarLJ2UNtljDu/NGD1MWWRNaKZ/jpeSOvRGy2XtIg=;
        b=guR/T8xlHOsP2LNZyaZwiObCMwcc92/U71sSADOpk1VFcjIrTiy2b7mPXthNHq1aJh
         zBL2RpfHfF+dH/BOMp31pfeRK76ikMCozhjR2eO9HgpN3LNOSX+Aoimk6GwrnS+1WECx
         sLIaDW7kL7PWAzG+lPOZjTaNF072v5IK14XiENpetA25rlEQGrgwqImqQ1Ni+alIChdp
         eHor0/P+3EM1fDvVF6j1ZQhat3/lcSXDfliA2pKKcMy4ia/qlQlMjlM/BYC8+dNFnT71
         fLLWbjUnGigtYYjdaz2iO5awZiHTff4ukx/CrLhYHu3blDAnljbsZEQDn4ujKHRZ0Xdt
         SfBg==
X-Gm-Message-State: ACgBeo3dvOyvGBFgXW9WlpjgtFqfGU6r7AYYf5SueQ3xZOlR+upHRNn3
        vP3xTPkqDbYqrDhYPoVXTc7c2oPanthc2cbQt6i1ff/YP0IRBzdWznDwvrE++XZGTSyVHtvgpYH
        xTAb67adKr5cg
X-Received: by 2002:a05:6638:3042:b0:341:d6bc:7bcb with SMTP id u2-20020a056638304200b00341d6bc7bcbmr7980397jak.258.1660585977760;
        Mon, 15 Aug 2022 10:52:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5i405dJBqXB2wpppUqalkB8ihdyscxF3U7r8/rlm/W+0QAFhdvG9A3oewmE0CBh6DjjHAFNA==
X-Received: by 2002:a05:6638:3042:b0:341:d6bc:7bcb with SMTP id u2-20020a056638304200b00341d6bc7bcbmr7980385jak.258.1660585977539;
        Mon, 15 Aug 2022 10:52:57 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i19-20020a02b693000000b0034340aa5ecdsm3614653jam.23.2022.08.15.10.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 10:52:57 -0700 (PDT)
Date:   Mon, 15 Aug 2022 11:52:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, <idok@nvidia.com>
Cc:     <alex.sierra@amd.com>, <akpm@linux-foundation.org>,
        jason Gunthorpe <jgg@nvidia.com>,
        "maor Gottlieb" <maorg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: Bug report: vfio over kernel 5.19 - mm area
Message-ID: <20220815115255.60eaee8b.alex.williamson@redhat.com>
In-Reply-To: <0e8a0d16-3c6f-a649-44b3-ab960801d90f@nvidia.com>
References: <a99ed393-3b17-887f-a1f8-a288da9108a0@nvidia.com>
        <3391f2e5-149a-7825-f89e-8bde3c6d555d@nvidia.com>
        <20220615080228.7a5e7552.alex.williamson@redhat.com>
        <0e8a0d16-3c6f-a649-44b3-ab960801d90f@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Aug 2022 18:46:40 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 15/06/2022 17:02, Alex Williamson wrote:
> > On Wed, 15 Jun 2022 13:52:10 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >  
> >> Adding some extra relevant people from the MM area.
> >>
> >> On 15/06/2022 13:43, Yishai Hadas wrote:  
> >>> Hi All,
> >>>
> >>> Any idea what could cause the below break in 5.19 ? we run QEMU and
> >>> immediately the machine is stuck.
> >>>
> >>> Once I run, echo l > /proc/sysrq-trigger could see the below task
> >>> which seems to be stuck..
> >>>
> >>> This basic flow worked fine in 5.18.  
> > Spent Friday bisecting this and posted this fix:
> >
> > https://lore.kernel.org/all/165490039431.944052.12458624139225785964.stgit@omen/
> >
> > I expect you're hotting the same.  Thanks,
> >
> > Alex  
> 
> Alex,
> 
> It seems that we got the same bug again in V6.0 RC1 ..
> 
> The below code [1] from commit [2], put back the 'is_zero_pfn()' under 
> the !(..) and seems buggy.
> 
> I would expect the below fix for that [3].
> 
> Alex Sierra,
> 
> Can you please review the below suggested fix for your patch and send a 
> patch for RC2 accordingly ?
> 

https://lore.kernel.org/all/166015037385.760108.16881097713975517242.stgit@omen/

It's in the mm tree, hopefully it'll get pushed in an early rc.  Thanks,

Alex

