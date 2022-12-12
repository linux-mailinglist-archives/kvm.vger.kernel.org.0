Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46E664A00A
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 14:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbiLLNTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 08:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiLLNSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 08:18:50 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA8813D06
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 05:17:56 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3bfd998fa53so144942087b3.5
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 05:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y7MvI0l6U01NL+JgWVWVhPKtCnV5a2AKEYcx/fldpjY=;
        b=eWLtylRDBk2dOZkHT6UlxUnpckauw8t+CToAP39TwpMZUkzVIVdRIzIW5TYnSSWYM2
         rWZIIYnVy2icwTKmmmMpVVs03+bi8riOVfTbhfPzTKkgfsr/5NNGk5TnBIkeevGogdw7
         YlPPtB1IIZZR4t9elJS3ux1rL7NLzCjw6hLysX3VqKwvkBuvs/bintm+f3UhB6rRe0H6
         9GmeIQ/8tjn1/FOpTEFOhSdxQL7dFMFd0oXLNCQc8EA73ZglSJiJL1fBwkpxImAJ6HPU
         qabznTuvnjDbwio9q/oIJYmN1khfUNmQm7gQ7gDTBuYEwX4ypwEwxMiSd1GsEUxlywxJ
         gfJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7MvI0l6U01NL+JgWVWVhPKtCnV5a2AKEYcx/fldpjY=;
        b=RT23W6MZrxOATtg27+EPH1CAAAHSrMuka/6Awzx+sfyGS1dhQmgIRjynZ3E5dX0dxW
         TRED+L7myl0yQV3wYY0LuhL+wlrU6FZ0B/i5qbfNcNdyqjpvQHAFTg7wtMLl5FlRm0TW
         7uo3yqyA4VhWm4KkUsdQ2Lpq1AU7bDAG3QJO795CqHPGZ0mPjeDJk0p10vEAR4VGRBku
         f0gIlZzEK3nXjCaHggaBElzrzvAGaghbxbn86+kCsg77bcJdlcjx8dqY5Tipb5UoaXdn
         gEHdXXLtO9+n2FsS/TDvzRtcnfzYiRlndc3VMIZg3Kqi4LKcA7BANWdL6ygevlytEENf
         9fyw==
X-Gm-Message-State: ANoB5pkY5puQpmC9/M7e2MbV5GcbJOstRY4JlzmX497No7v1Os9MMmbX
        gP88R7JgXa1NFhQ+kNv4Cu9ONK9GzehCbanw
X-Google-Smtp-Source: AA0mqf7fd/L7xUFraGI/lU35uHxXsrEZq4UJzo3P6d6uWEmmB5G4VFinTVCyVdcIyy6rL1ar2EnL7Q==
X-Received: by 2002:a05:7500:1c4d:b0:ea:7e6b:1c36 with SMTP id dz13-20020a0575001c4d00b000ea7e6b1c36mr1151295gab.31.1670851075731;
        Mon, 12 Dec 2022 05:17:55 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-50-193.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.50.193])
        by smtp.gmail.com with ESMTPSA id t30-20020a37ea1e000000b006eef13ef4c8sm5724075qkj.94.2022.12.12.05.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 05:17:54 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p4igs-008dzE-6i;
        Mon, 12 Dec 2022 09:17:54 -0400
Date:   Mon, 12 Dec 2022 09:17:54 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Message-ID: <Y5cqAk1/6ayzmTjg@ziepe.ca>
References: <167044909523.3885870.619291306425395938.stgit@omen>
 <BN9PR11MB5276222DAE8343BBEC9A79E98C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20221208094008.1b79dd59.alex.williamson@redhat.com>
 <b265b4ae-b178-0682-66b8-ef74a1489a8e@oracle.com>
 <20221209124212.672b7a9c.alex.williamson@redhat.com>
 <5f494e1f-536d-7225-e2c7-5ec9c993f13a@oracle.com>
 <20221209140120.667cb658.alex.williamson@redhat.com>
 <6914b4eb-cd82-0c3e-6637-c7922092ef11@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6914b4eb-cd82-0c3e-6637-c7922092ef11@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 10, 2022 at 09:14:06AM -0500, Steven Sistare wrote:

> Thank you for your thoughtful response.  Rather than debate the degree of
> of vulnerability, I propose an alternate solution.  The technical crux of
> the matter is support for mediated devices.  

I'm not sure I'm convinced about that. It is easy to make problematic
situations with mdevs, but that doesn't mean other cases don't exist
too eg what happens if userspace suspends and then immediately does
something to trigger a domain attachment? Doesn't it still deadlock
the kernel?

Honestly, I'm not sure I see the big deal, just don't backport these
reverts to your disto kernel.

Jason
