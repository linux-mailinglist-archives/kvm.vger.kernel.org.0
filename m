Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1DA67976BA
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbjIGQP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbjIGQPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:15:04 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA3349E9
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 09:11:50 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6c0828c3c2dso786280a34.1
        for <kvm@vger.kernel.org>; Thu, 07 Sep 2023 09:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1694103022; x=1694707822; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SgLgd1SPc6YB6mb40hQjfa5ZZlpVScz+27QCEpD3rcU=;
        b=PvqWNVZ72aqJKocMPOHuyuwt4A24MkVtvk28ry9JUqvOXCRVp9iJPLlZhqtBcL2U5+
         m9nkYcyhJAB8Yb6fYnVpf6HzOzh2UHa6emd6G2JaBA+qJ6+omTdfcoQqnAWS74A22W+g
         QlW/A0LBbQZWXrcBEc1fiyT2PrKDQ97iQIPk5l97yZQgGqn/YVgMBH/6w2bfn6S6y+Gi
         XABVnMtijGnMIUCLBpzS641pXSCfVe9fNBVAmhdSOn/D9O+npQFLHqOG2Pj3cT65vhbW
         Or838FCQqZTHjYKUMAlq8n+c7QhwMTD5K3NAshC1j3/dtFoBe807O7Z6hc9bbPBHtmp0
         +iBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694103022; x=1694707822;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SgLgd1SPc6YB6mb40hQjfa5ZZlpVScz+27QCEpD3rcU=;
        b=eiSbC9GLOGUVAHCB4QgeG9doc56yL+Kc2IgBonsqbLVN1Z2ruq9xPZRCQ/neFceZo0
         Sr0UHqWCmDiZ3g/SbVvZtMKEAz5/dQCNq+vc7Dvg5MAkYe3kcL8kGok1SJkGF4mkbCLY
         Urk4C3A+H3J1mN81PYUgmiOwSQEh8gsMlMz4GhmpDgv+gjJ/TPd2o45mDund1hx5Jo3R
         kI0C1vIyuAvtW5niXOpi7nCTV14I7u7Bu9jNfD9XWHipuOM5sTPbsL6ZIU/72KYx2R9t
         ax11ZblGcwkQ1G4t+2qczzr7KlWaEUHRQenzC+hUmIPfUlBfVHvmFvhwyDlcB+MbvpQb
         VqbQ==
X-Gm-Message-State: AOJu0YzZTX0wU/KMBKzwoaCj+Pi58/SOhykjnMFRNL1/zenMGbK/qi1X
        yccWvGq5gygyxo8Aigv3fzGwRw==
X-Google-Smtp-Source: AGHT+IERsBNl+Au3IHrRw2kUYGqmyQ32p3bRKRylRe/SD4Zg8jGBdBHeqpIHcghYXGcvloCt2IKYGg==
X-Received: by 2002:a05:6358:52c8:b0:134:e964:134c with SMTP id z8-20020a05635852c800b00134e964134cmr8509262rwz.11.1694103022523;
        Thu, 07 Sep 2023 09:10:22 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-134-41-202-196.dhcp-dynamic.fibreop.ns.bellaliant.net. [134.41.202.196])
        by smtp.gmail.com with ESMTPSA id m17-20020a0cdb91000000b006418c076f59sm6395881qvk.100.2023.09.07.09.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 09:10:21 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qeHaG-00170I-NH;
        Thu, 07 Sep 2023 13:10:20 -0300
Date:   Thu, 7 Sep 2023 13:10:20 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kim Phillips <kim.phillips@amd.com>, joro@8bytes.org,
        iommu@lists.linux.dev, Michael Roth <michael.roth@amd.com>,
        "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-coco@lists.linux.dev
Subject: Re: [PATCH] iommu/amd: remove amd_iommu_snp_enable
Message-ID: <ZPn17E94bVUKIs+U@ziepe.ca>
References: <20230831123107.280998-1-hch@lst.de>
 <d33f6abe-5de1-fdba-6a69-51bcbf568c81@amd.com>
 <20230901055020.GA31908@lst.de>
 <ZPiAUx9Qysw0AKNq@ziepe.ca>
 <d230d9f5-53bd-8ea1-d4c7-717b0e8be9b9@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d230d9f5-53bd-8ea1-d4c7-717b0e8be9b9@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 07, 2023 at 04:55:52PM +0700, Suthikulpanit, Suravee wrote:

> > I've said this many times lately. There are other things in this
> > driver that have no upstream justification too, like nesting
> > "support".
> 
> Jason, there is no need to keep repeating and polluting this thread. I am
> happy to discuss and clarify any points of your concern on the "nesting
> support" in a separate discussion thread :)

It is not polluting this thread. We are, again, asking AMD to follow
the rules please.

None of the other threads about the nesting has resulted in acceptance
that code needs to be removed as well. Go respond in one of those if
you have something to add.

Jason
