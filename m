Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0C7793DCC
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 15:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241073AbjIFNg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 09:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240756AbjIFNg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 09:36:27 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FA410D3
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 06:36:23 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-26f38171174so2641361a91.3
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 06:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1694007382; x=1694612182; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OwzQ6/Z2kMD31IVSoE96irLcXCzsjxsenR7GQgWXnQk=;
        b=VuCeTQUJ6R+PBz7JGOWeD+87L++NnvWZNIitbHglOhER7WW4eibkuXWf+l1U2zBYau
         Q7JsGAhLlV8KFOYZffm6AGYZ0QBBBb5x5GeeSDLqJPrkFA+bMam1GOJsdmOhhoDrItkx
         +Kb5Sf5fIUjnwyRxLyTxSf7TdxTbwrpb+eOjRO5RtSki2xEMnEnho70q2Due+PjmhFIU
         RIeG3PPHGjmFHHOu1aOOZ944YqtNZSepJS5ohBA7PjSknfdUdSQg0s5fOgxFQfq/oKJw
         f+2pfbyceHWKqr6zoA3qMs9vssQDI7ktGo/cTgviVdvsjSCIOz0WEwgk1NPZQEoiPp2u
         nHzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694007382; x=1694612182;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OwzQ6/Z2kMD31IVSoE96irLcXCzsjxsenR7GQgWXnQk=;
        b=fAf29RsuwUhNjEzFdI7XCHeoHFfVKlHSKMaoKQxr+mcaDby60SVpupapKgW2ToqNgB
         NoeWkWTA6/99mHxguf12Jy1CcN1F1dD7ASQnYkzRv+8Vd26TZQtM1nHE1NMqHH65lgrt
         ml5UCR//5b6tD1ixraQC0+kEjHzLimO8QCLF9EX2kACppNetTjAecg1XRB85NMxMfN7r
         9k8eUApUzHrUYg/9AAvI/DIjwPIgCf3t1bQWzltnsV7bVdWpuEBkkL6sQTAx7orwKKrJ
         Ghs1aBoDxVLa0E6sb/JBViHhKke2tRZrenWwLCaUW+76ayFt+CCuQwu9NPzey9bWimMC
         C38g==
X-Gm-Message-State: AOJu0YyDmhOB4+s8NWwphuki2C2rG1EexMhjeAsLIshqeLgaxVUn4mTy
        s+byOR1sTEFnsFRdflLxVYrdCw==
X-Google-Smtp-Source: AGHT+IGQ4vqLE4lDnmS6Kx79SJrsu1YaEhgU7Y1QgV+88opC+oy++oplaXWLVpq8ZWayNQq4SvaXuA==
X-Received: by 2002:a17:90b:2317:b0:273:441a:dae6 with SMTP id mt23-20020a17090b231700b00273441adae6mr14950231pjb.19.1694007382653;
        Wed, 06 Sep 2023 06:36:22 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id z2-20020a17090ad78200b002680dfd368dsm10901898pju.51.2023.09.06.06.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 06:36:21 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qdshf-000yIH-QK;
        Wed, 06 Sep 2023 10:36:19 -0300
Date:   Wed, 6 Sep 2023 10:36:19 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kim Phillips <kim.phillips@amd.com>, joro@8bytes.org,
        suravee.suthikulpanit@amd.com, iommu@lists.linux.dev,
        Michael Roth <michael.roth@amd.com>,
        "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-coco@lists.linux.dev
Subject: Re: [PATCH] iommu/amd: remove amd_iommu_snp_enable
Message-ID: <ZPiAUx9Qysw0AKNq@ziepe.ca>
References: <20230831123107.280998-1-hch@lst.de>
 <d33f6abe-5de1-fdba-6a69-51bcbf568c81@amd.com>
 <20230901055020.GA31908@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230901055020.GA31908@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 01, 2023 at 07:50:20AM +0200, Christoph Hellwig wrote:
> On Thu, Aug 31, 2023 at 01:03:53PM -0500, Kim Phillips wrote:
> > +Mike Roth, Ashish
> >
> > On 8/31/23 7:31 AM, Christoph Hellwig wrote:
> >> amd_iommu_snp_enable is unused and has been since it was added in commit
> >> fb2accadaa94 ("iommu/amd: Introduce function to check and enable SNP").
> >>
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> >> ---
> >
> > It is used by the forthcoming host SNP support:
> >
> > https://lore.kernel.org/lkml/20230612042559.375660-8-michael.roth@amd.com/
> 
> Then resend it with that support, but don't waste resources and everyones
> time now.

+1

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

I've said this many times lately. There are other things in this
driver that have no upstream justification too, like nesting
"support".

Please organize this SNP support into series that makes sense and are
self complete :( I'm not sure a 51 patch series is a productive way to
approach this..

Jason
