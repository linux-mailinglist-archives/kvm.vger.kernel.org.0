Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5D7644802
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 16:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbiLFP2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 10:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiLFP2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 10:28:17 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8677028715
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 07:28:15 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id v3so13678514pgh.4
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 07:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UbvbC5wWAbTk1+A45QMi3yV7gKIuXUVlv7TRLX6QDzQ=;
        b=o2pfBKad+xs/gHyi3mDpxXl3Ejx08rQwd7nDOZGu8tih+03yTLG9XNmst/u1NsCpd2
         kyGJtZ5d7CWoKzweigchYufl1D8gierL43WqERJwGSSQeRHqmRZWusQ6eSD0wl6ytQAR
         PFhlOF+Zravyw5C5LhmVc6V5UXDs6Ieixn7Z71yBPjdl7i+Rhqodee7VZzSZxM6gbJ+M
         mUv+e7BMb1dEYVIavlac4VR+uJPX1dz2MgumEnsBWeA5UZ3V9ne5rWYEA66kFu8C1QG1
         JYeIna0Nvi7bBdxHdo5P39G0mu/SsSFQ/pA0afbIWx+7D7CDy0/xKN1Q9huuXlirg552
         jxng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UbvbC5wWAbTk1+A45QMi3yV7gKIuXUVlv7TRLX6QDzQ=;
        b=lI4cjvuu0h+yuJhG2VFCUbKeEHooGHAPxJ8NO+hFOld/bSkkGGRXqo4FnmzTPjACiL
         8DDsXwzsPSdUBW0m9gi1yXWs/Bazg9LIAySue9aLg5PxQFhuurIO0RqIpgvaAUKJ05Qc
         w3KxvdUZRmQK4HylRTh2flfbe0zVUIKvwbKp2etcpBahICReObvFJF9oqvKbmnTCdNkF
         O3KXjNLFF2yRJO1I8o5VKzKNiTvlGUDpgcq2qKUoZk3j6JBlzm3Jy0Hdk7kuVoNULC+u
         eTdyFxtPLRk0gX0WPAqpSUHaxB0/KY6zvsZu9HXi14FHiOKySkZMWIjnIoFhDFW0T1MD
         N0zw==
X-Gm-Message-State: ANoB5pkqPBQPcf37wNNv3fLbOuKNfFKfTpH9rKkIR/sP6HLrqc6efbPS
        yKPWUqvT1sM+vHwwnTC5V0z3Nw==
X-Google-Smtp-Source: AA0mqf55x7M4sv2x3tayft1I7V3sSjX0b6B+H4EoWIBSX/GlBW1IkeeiP/C1ZdGWLs42NtueKdU4uw==
X-Received: by 2002:a63:1865:0:b0:478:b1f4:1661 with SMTP id 37-20020a631865000000b00478b1f41661mr10871408pgy.317.1670340495049;
        Tue, 06 Dec 2022 07:28:15 -0800 (PST)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id d12-20020a170903230c00b0016c9e5f291bsm12848547plh.111.2022.12.06.07.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 07:28:14 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2Zrg-004crv-OQ;
        Tue, 06 Dec 2022 11:28:12 -0400
Date:   Tue, 6 Dec 2022 11:28:12 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Lei Rao <lei.rao@intel.com>, kbusch@kernel.org, axboe@fb.com,
        kch@nvidia.com, sagi@grimberg.me, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Message-ID: <Y49fjFD6foGorhmp@ziepe.ca>
References: <20221206055816.292304-6-lei.rao@intel.com>
 <20221206062604.GB6595@lst.de>
 <Y48+AaG5rSCviIhl@ziepe.ca>
 <20221206130901.GB24358@lst.de>
 <Y49JNvdmRPNWw26q@ziepe.ca>
 <20221206140002.GB27689@lst.de>
 <Y49PqoAhZOeraLVa@ziepe.ca>
 <20221206143126.GB30297@lst.de>
 <Y49WNo7XWZ2aFfds@ziepe.ca>
 <20221206150131.GA32365@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206150131.GA32365@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 04:01:31PM +0100, Christoph Hellwig wrote:

> So this isn't really about a VF live cycle, but how to manage life
> migration, especially on the receive / restore side.  And restoring
> the entire controller state is extremely invasive and can't be done
> on a controller that is in any classic form live.  In fact a lot
> of the state is subsystem-wide, so without some kind of virtualization
> of the subsystem it is impossible to actually restore the state.

I cannot speak to nvme, but for mlx5 the VF is laregly a contained
unit so we just replace the whole thing.

From the PF there is some observability, eg the VF's MAC address is
visible and a few other things. So the PF has to re-synchronize after
the migration to get those things aligned.

> To cycle back to the hardware that is posted here, I'm really confused
> how it actually has any chance to work and no one has even tried
> to explain how it is supposed to work.

I'm interested as well, my mental model goes as far as mlx5 and
hisillicon, so if nvme prevents the VFs from being contained units, it
is a really big deviation from VFIO's migration design..

Jason
