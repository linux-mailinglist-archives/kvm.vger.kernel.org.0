Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937ED4D1C55
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347978AbiCHPyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbiCHPyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:54:09 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFF43A1B1
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 07:53:11 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so2783087pjl.4
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 07:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DvGT3bHO3eTMD0KXTbeLdljGXwbAYf6pMl/rX/qRoGc=;
        b=f53CxNhvRcd6gIVul16MgYj35gn1Yjah6ootqVkktMN1C1a1wH4BtM8mkG+vLNz5Ju
         3/oV7D5zLvOCUxBkC//RaLlhGuBOOMH8GRKzS15lTpbxqScwAFbVKGX0GQ+IHlraIVVc
         ZYgtsekraPJ6jfiZo59YSxT/ibNx7Q5+/LYkGGF6SckhUD87JM/430BvFbv0yDPtMLQI
         UPvaEebIbjjFnMleatlRaOT/5n0g2VbB5yZQBo9oAsIhIPTxDHP/YocMRzUu33YbQr0y
         rIpY2AHiyJU0exLHYo2lbeHSRwSOp/rGBTtJpIqHxXWpNi51MPcwbYdKknY20jiVY5QU
         0VQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DvGT3bHO3eTMD0KXTbeLdljGXwbAYf6pMl/rX/qRoGc=;
        b=TxRx4HXqaz8f+gL74Jwjs2HPbzsp5yr5MfNybcZRanDAhuqtX4F9vHk2ZKRj4j2pkX
         bGo8fK/KMXFAg2bXNDzeUWLx9zIY5IISkpSD0mHSAjP6Wf3rfsQK3Kvda9MC1J8DGLZJ
         +sUXbRaolki6ZQaorKDA59DA/91mRNMmPjwsVNYNrYMF4Yazj+dNzDNwKB2JgE1M8O/e
         /adC6Zm00oqd/v/W7Rr+Un+PyYk7ZExPLBBYfojvSXl7VDydE+/iHXwbykjpvlw2MHdt
         rNeA8jIM68WtbRqEWBiMFh7fxWDrdhwFKoPqeg9hIdsjYkgXnub5/I1yB6VhjH9A0yMm
         vT0Q==
X-Gm-Message-State: AOAM533p/hMJMy25z/lJke7MzSTto305Cv+dJXEGWZOhGnHjNaFzglCE
        EhP8DrGYcNlk/EtFnq5P7F/W21erc/0JGg==
X-Google-Smtp-Source: ABdhPJz0YaRP5SVfSTDDnadJfYWRblCfhFuHMQtgYMJ53i34cH9p2wG0+2iQE171iRz2GnyOLhrJhQ==
X-Received: by 2002:a17:90b:1b4c:b0:1bf:d91:e157 with SMTP id nv12-20020a17090b1b4c00b001bf0d91e157mr5391516pjb.82.1646754790341;
        Tue, 08 Mar 2022 07:53:10 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b17-20020a056a000a9100b004e1b7cdb8fdsm21428055pfl.70.2022.03.08.07.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 07:53:09 -0800 (PST)
Date:   Tue, 8 Mar 2022 15:53:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Shivam Kumar <shivam.kumar1@nutanix.com>, kvm@vger.kernel.org,
        agraf@csgraf.de
Subject: Re: [PATCH v2 0/1] KVM: Dirty quota-based throttling
Message-ID: <Yid74seFMjB49FIZ@google.com>
References: <20211220055722.204341-1-shivam.kumar1@nutanix.com>
 <f05cc9a6-f15b-77f8-7fad-72049648d16c@nutanix.com>
 <YdR9TSVgalKEfPIQ@google.com>
 <652f9222-45a8-ca89-a16b-0a12456e2afc@nutanix.com>
 <76606ce7-6bbf-dc92-af2c-ee3e54169ecd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <76606ce7-6bbf-dc92-af2c-ee3e54169ecd@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 08, 2022, Paolo Bonzini wrote:
> On 1/5/22 16:39, Shivam Kumar wrote:
> > 
> > > On Mon, Jan 03, 2022, Shivam Kumar wrote:
> > > > I would be grateful if I could receive some feedback on the
> > > > dirty quota v2
> > > > patchset.
> > >    'Twas the week before Christmas, when all through the list,
> > >    not a reviewer was stirring, not even a twit.
> > > 
> > > There's a reason I got into programming and not literature. 
> > > Anyways, your patch
> > > is in the review queue, it'll just be a few days/weeks. :-)
> > Thank you so much Sean for the update!
> 
> Hi, are you going to send v3?

https://lore.kernel.org/all/20220306220849.215358-1-shivam.kumar1@nutanix.com
