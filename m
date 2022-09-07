Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165A75B0D8A
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 21:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiIGTz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 15:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiIGTz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 15:55:56 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC95A5C54
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 12:55:53 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id cr9so11283479qtb.13
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 12:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=reg182tBPdMyHHqhIyhd0PReinakkrLNe0xqHZC9tHU=;
        b=HGsl5LOrvfdnuyNEVcB+B1VQp1UuGBIOQoUWByoYPBAOyvlWj9vIrmlIosnh0QOvjp
         9t1pLdGWzfwvo7PTNeeXZpHQeCZDCMAbxR4j6DpbkpqAtHiJ1boF9wUSCWFLMrBlcaHp
         YoTv+kHo4THsJ/Mc63JM+YKqeESn3s2WG47rnSxevKm9v0SgRfxj/b/FSTqHN+FVbbdE
         YRUwQy1C4ktcAsIQk6ZxdocxEK3yR01eWqg2vLczmE6Ww5bfdd1+Dl8taxY2Tf/9XWTX
         2SLCSM/ki21AbuD+egy3jf01r8hYIK/sKWh+WkDXR3hVVPW6f8vUKxGd138OM1Q+9SRg
         KRIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=reg182tBPdMyHHqhIyhd0PReinakkrLNe0xqHZC9tHU=;
        b=IAdJm3n178EcbDrQxkdsmBemwl8zdEBFd/J1uFxYghJMO1oxc/UlJ7kX8Cd0K22Nsd
         fbCAgeY6ehUOVckkvOdzTZ5MQtE2r3/WH6rhzftuJg66ON3A+maih0ZnJmbR9E1AH98Y
         83zU5qcXSpUWTM7YP3JZLRxbiVMllBciiIs4RmB1QpIEobBRLGN0wHenQLR4Ur3Fb3bT
         weLU9tfKojjg5d/uncuWvELFb31nPARCvrvgmWxmSV13Hl0LA5HmoEClpUzcv4zJPb5x
         VlDz3euuEXQb3IuP35A9MxI2Yfn96jqZ4i9jGVUBctSyI9E7j23BjlCQMHFQZ9gA8iql
         2Uig==
X-Gm-Message-State: ACgBeo1wcGTLDkEtkijKG2v4Opy+fB+ypTxS1hxaBmDpvFGjJAFCu4ss
        JWkKwuDZXl+X06lYj+6YADzZCQ==
X-Google-Smtp-Source: AA6agR71wy1OO/ymcMptPhtEDcay7FQ+pBe7sqv5WOFog+U5XySjMiaLOl4gJ+FO5Lod2IyxAWvAbA==
X-Received: by 2002:a05:622a:15c7:b0:344:5321:5874 with SMTP id d7-20020a05622a15c700b0034453215874mr4917567qty.506.1662580552067;
        Wed, 07 Sep 2022 12:55:52 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id m8-20020ac866c8000000b003445d06a622sm12968811qtp.86.2022.09.07.12.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 12:55:51 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oW19K-008kzP-5v;
        Wed, 07 Sep 2022 16:55:50 -0300
Date:   Wed, 7 Sep 2022 16:55:50 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lpivarc@redhat.com" <lpivarc@redhat.com>,
        "Liu, Jingqi" <jingqi.liu@intel.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: [PATCH] vfio/type1: Unpin zero pages
Message-ID: <Yxj3Ri8pfqM1SxWe@ziepe.ca>
References: <166182871735.3518559.8884121293045337358.stgit@omen>
 <BN9PR11MB527655973E2603E73F280DF48C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d71160d1-5a41-eae0-6405-898fe0a28696@redhat.com>
 <YxfX+kpajVY4vWTL@ziepe.ca>
 <b365f30b-da58-39c0-08e9-c622cc506afa@redhat.com>
 <YxiTOyGqXHFkR/DY@ziepe.ca>
 <20220907095552.336c8f34.alex.williamson@redhat.com>
 <YxjJlM5A0OLhaA7K@ziepe.ca>
 <20220907125627.0579e592.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907125627.0579e592.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022 at 12:56:27PM -0600, Alex Williamson wrote:

> I thought we'd already agreed that we were stuck with locked_vm for
> type1 and any compatibility mode of type1 due to this.  Native iommufd
> support can do the right thing since userspace will need to account for
> various new usage models anyway.

We did, that was for the iommufd situation (which will also hit the
same zeropage issue, sigh) - this discussion is about fixing a bug in
vfio and what many consider a bug in GUP.

My point is I'm still not convinced we can really consider these
limits as ABI because it opens a pandoras box of kernel limitations.

> I've raised the issue with David for the zero page accounting, but I
> don't know what the solution is.  libvirt automatically adds a 1GB
> fudge factor to the VM locked memory limits to account for things like
> ROM mappings, or at least the non-zeropage backed portion of those
> ROMs.  I think that most management tools have adopted similar, so the
> majority of users shouldn't notice.  However this won't cover all
> users, so we certainly risk breaking userspace if we introduce hard
> page accounting of zero pages.

It sounds like things will be fine. 1GB fudge is pretty big.

For things like this ABI compat is not about absolute compatability in
the face of any userspace, but a real-world compatibility "does
something that actually exists break?"

So I would be happier if we had an actual deployed thing that breaks..
I would be inclined to go with the simple fix and rely on the
fudge. If someone does come with an actual break then lets do one of
the work arounds.

Given the whole thing is obstensibly for security it is better to keep
it simple and sane then to poke it full of holes.

> module parameter defined limit.  We might also consider whether we
> could just ignore zero page mappings, maybe with a optional "strict"
> mode module option to generate an errno on such mappings.  Thanks,

Once GUP is fixed vfio won't see the zero pages anymore :( That really
limits the choices for a work around :(

Jason 
