Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955015AF865
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 01:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiIFXaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 19:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiIFXaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 19:30:06 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A8B71BE3
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 16:30:04 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id h22so9283910qtu.2
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 16:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=8POgIqoCE/xPyio8hhiKc1LdATDOpVqruNWH+Y0oKug=;
        b=R73TDbd1gA/0bvvNJcq4gRiHoZYZFzW4CsEZ10DSuGcQwHAkFDyA6VpeTKLfJmv2Qv
         HEh5ilL7kJrMTFhCUgB0B7MmE+NuB0FFyhFLZu84c18uWOCe7qGaPn66XdXn616jZdYa
         tHrjbeIrjGwloip7SqOCAE4fojGWbC2FtqN21MOjt7fQSUwqMR6Z5Y0asKfEbr4N3DEx
         fsVCxjdO828Lqv2Cc9Bh0fvKoerM6685NRscKaAH/kLE+jJQWAzowWocE+l5GVkyhvmh
         XQtteJRaQqlq2WSRKArOZPMpenPds4VVDl1ATeTcmyg1xTdrL6YCfO0rxOE4wDDDpeYY
         ddBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=8POgIqoCE/xPyio8hhiKc1LdATDOpVqruNWH+Y0oKug=;
        b=obdojRR2hDOCIoie3WgzGf5dW0I+r/nxeNEAB8t5Sm0jbB3Vyh01sDKg6Z53IQEgeG
         eEokFo6WtBHAm+MdTOjd/kh8FoeEHk+VatTFUHik2PYmQhQCNUe+6SB0iFO7qj7ezQTE
         Lgg0bm8E+n5nT7S0gPbGVQYS0tsBaPYE9SS52gGiflX4dYcfD1I7ScQq1YXJt78MxXqi
         Skemnkx2zeg6W1oFYcNCvnB2AK4aX2eqTH46C+8N6P9b/O+Mx8TVITCTM+/Ky5f/oeG8
         4utdjsZH+S6rV4Y9LL98KKxsx6UxpbQiLQ1BR2ORj9CVhNWD0cgBgFIUSuYP47ExbcGn
         TCLA==
X-Gm-Message-State: ACgBeo0ZnAjBssp4AGCd02TwC1OJO8hf5XDa3NDJFiPOdyfnNo9gWjBT
        IkO6BItG9y7tSyabULyh2HlZtg==
X-Google-Smtp-Source: AA6agR53pHqBxzRSu0eppdFz9topCiFtqhk1c/QRotwfhSAlUhqk57CUBsUrbgl1pfSsQwgFgMhN1Q==
X-Received: by 2002:ac8:59c7:0:b0:344:7ec0:2ff2 with SMTP id f7-20020ac859c7000000b003447ec02ff2mr930017qtf.614.1662507003692;
        Tue, 06 Sep 2022 16:30:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id f8-20020ac81348000000b00343681ee2e2sm10608565qtj.35.2022.09.06.16.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 16:30:02 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oVi14-008F48-7A;
        Tue, 06 Sep 2022 20:30:02 -0300
Date:   Tue, 6 Sep 2022 20:30:02 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     David Hildenbrand <david@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lpivarc@redhat.com" <lpivarc@redhat.com>,
        "Liu, Jingqi" <jingqi.liu@intel.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: [PATCH] vfio/type1: Unpin zero pages
Message-ID: <YxfX+kpajVY4vWTL@ziepe.ca>
References: <166182871735.3518559.8884121293045337358.stgit@omen>
 <BN9PR11MB527655973E2603E73F280DF48C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d71160d1-5a41-eae0-6405-898fe0a28696@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d71160d1-5a41-eae0-6405-898fe0a28696@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022 at 10:32:01AM +0200, David Hildenbrand wrote:

> > So I wonder instead of continuing to fix trickiness around the zero
> > page whether it is a better idea to pursue allocating a normal
> > page from the beginning for pinned RO mappings?
> 
> That's precisely what I am working. For example, that's required to get
> rid of FOLL_FORCE|FOLL_WRITE for taking a R/O pin as done by RDMA:

And all these issues are exactly why RDMA uses FOLL_FORCE and it is,
IMHO, a simple bug that VFIO does not.

> I do wonder if that's a real issue, though. One approach would be to
> warn the VFIO users and allow for slightly exceeding the MEMLOCK limit
> for a while. Of course, that only works if we assume that such pinned
> zeropages are only extremely rarely longterm-pinned for a single VM
> instance by VFIO.

I'm confused, doesn't vfio increment the memlock for every page of VA
it pins? Why would it matter if the page was COW'd or not? It is
already accounted for today as though it was a unique page.

IOW if we add FOLL_FORCE it won't change the value of the memlock.

Jason
