Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89DB5B102F
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 01:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiIGXHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 19:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiIGXHH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 19:07:07 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72618C3F4F
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 16:07:05 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id a10so11631140qkl.13
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 16:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Y6pRZpUk+zqaAgkCeIzS94fxs7LngDZcMEpib2+hGHU=;
        b=XCUZAaiRUr0RkAx/wyAOWDoxJGpoaofe4IUIO/Z4Oj23HH/8Urq1SfH3RW3VimcAP5
         IOTaBqpNj8onlQC3ycH4M0G0A4WmAc1fT0FEeWGmMat1xZzbccHl8J4HnZYU/aknykxv
         tRd4/RckrstTOXlmLCrRpfC5iEPklCqhMK6zyPVQUlpEFYEr6HSfvArSgh71TLa391za
         rDDJABnJcSSOQnCQA1lgy8iDR3JABCqHo9GsZFYp6FRlXfyac/6rhXAwER6RNXhVkegu
         ORCJhcreg7IMOa/nzMPQCFubSlyUpUI/QniDJb8ekn3YwPl1WozkLuyMLSVXRMO+Uhbv
         8Z/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Y6pRZpUk+zqaAgkCeIzS94fxs7LngDZcMEpib2+hGHU=;
        b=tzOTLNd7S2lm1TKeDemj6HSSKWEt4R9tDE2PDtEr4VJ1/UBhhJAnVhrcc2OlLzx3s3
         87Tlb6NGT2G/miQrYalx8H2xs2W/iK1StKPggUiaB/oDomcu2ukUnZFkxXo623wkVSoE
         UeADpPM3h7vW61QpkgwlyjHAGbLLXRbn863ka1fjxdrdmmKBrxrtmTqUGbpWY46NKWkQ
         +b4Mbb5Zi2HT/V9L7vE8MAkRy/lASb9RLhq3BXNVO7DloDQGeAUQWkUeJ2M7abIY6EEA
         d84s+N0LiGziiRtqIhCeJ8W9jyayaDyZDHo5MockrB92PqduVlyDjLxjZWsRR5ZEhNbG
         xxUQ==
X-Gm-Message-State: ACgBeo2tSYOk59/9lCKHjD5C0LEVTn4ewLTUy948DDuC8psG3HGG9z3f
        rUpgtuz7r8rVMdDljjmFA1+GiA==
X-Google-Smtp-Source: AA6agR46JVb2VgdODErJDQ3TfpF3Ib1qSU9Zudl8rH41hD23soYZBVWx17Pt9oLzp9F++lek2CxVTw==
X-Received: by 2002:a05:620a:2805:b0:6bc:5d4a:9618 with SMTP id f5-20020a05620a280500b006bc5d4a9618mr4640301qkp.116.1662592024471;
        Wed, 07 Sep 2022 16:07:04 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id bq30-20020a05620a469e00b006b95b0a714esm15301930qkb.17.2022.09.07.16.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 16:07:03 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oW48M-008nme-E3;
        Wed, 07 Sep 2022 20:07:02 -0300
Date:   Wed, 7 Sep 2022 20:07:02 -0300
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
Message-ID: <YxkkFiToNSw3CgrP@ziepe.ca>
References: <BN9PR11MB527655973E2603E73F280DF48C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d71160d1-5a41-eae0-6405-898fe0a28696@redhat.com>
 <YxfX+kpajVY4vWTL@ziepe.ca>
 <b365f30b-da58-39c0-08e9-c622cc506afa@redhat.com>
 <YxiTOyGqXHFkR/DY@ziepe.ca>
 <20220907095552.336c8f34.alex.williamson@redhat.com>
 <YxjJlM5A0OLhaA7K@ziepe.ca>
 <20220907125627.0579e592.alex.williamson@redhat.com>
 <Yxj3Ri8pfqM1SxWe@ziepe.ca>
 <20220907142416.4badb879.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907142416.4badb879.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022 at 02:24:16PM -0600, Alex Williamson wrote:

> Also, I want to clarify, is this a recommendation relative to the
> stable patch proposed here, or only once we get rid of shared zero page
> pinning?  We can't simply do accounting on the shared zero page since a
> single user can overflow the refcount.

Yes, here I would account properly in a way that keeps working for
future GUP changes because if something goes wrong with this simple
patch it has a simple fix.

Trialing it will get some good data to inform what David's patch
should do.

Overall have the feeling that a small group of people might grumble
that their limits break, but with a limit adjustment they can probably
trivially move on. It would be very interesting to see if someone
feels like the issue is important enough to try and get something
changed.

You could also fix it by just using FOLL_FORCE (like RDMA/io_uring
does), which fixes the larger issue Kevin noted that the ROM doesn't
become visible to DMA.

Jason
