Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA31D647519
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 18:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLHRqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 12:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiLHRqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 12:46:47 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132194AF01
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 09:46:47 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id i12so1447859qvs.2
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 09:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MRpyRZB5lBy9Z1nD/Uad3RYOUJ/MTGJPnzvr8/Vm5uI=;
        b=ESBDWM8vPxtgr0nr0o6lcF9+PB9miEv4jP5ZbHa9Fs4cD791ArcSEB/rv6kNCjl6JG
         14IB+pF+tNDqwEE4xq+Fx9hzWD6Xwh502EUecP57/tIeDIhGKdmYbXMBAIwMmjgP5dCt
         E/rCF31HpP5qBmQzs4Loj/+3bP75Kqhal2oeK507liTIE9NN9hCfRfiwjoEMrBZrZk28
         +NtHenpHSaYyRbU8aKsQzo6gTDSPYg6/DPt8/dfMELEHyMy5TQszDsqndG6G2Qd/SmCI
         lyE2GM+FsLgciqjMnEWop0qOa4iCkwtFUKlJTBAge97HtwnppZQYPCrZT0Y4mNJgZ0J2
         F6/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRpyRZB5lBy9Z1nD/Uad3RYOUJ/MTGJPnzvr8/Vm5uI=;
        b=cyOxAAJPXrTGBrMxm0JMLF/qWi/7l1nG4Bjlumb3jYH/gi9gDToKqTrshXYTdQpim8
         rIXBj5ea9345RRDjYSqiDw8vOZi64U8bowzCmgotdQta7XQ1TmKDNshOZlTx9EiADCgx
         YcPAm6wOAWLBYjYnk3oZACUFXHA3jhfuXduSCPKmH1XKdZJQnxi5lKQWoNxrSjTcv5e1
         Qq9WF1tlq0lF4hphD0fZNZDuA63LrwMxePnkAveUDCrhDF/ieI3SvE53tUZiAbB1+8kF
         xBhvH4yUNfkgzdN8KLrEDEyMVfPA5s3hVFM5DBsgct0t2lzrFQDa22V/UpcGAAGLuMZ/
         6EJA==
X-Gm-Message-State: ANoB5pkaRnXvgUepEvQjOTi5wnhOt6LQ+449EBcPNDCu6iXNmPoHiKWt
        CiLRQKbXQrwn84a+C8xg6HOntA==
X-Google-Smtp-Source: AA0mqf5Aj/5cQw2RBycR0xrfkOuno1mcy2D7sTt5XSqC1DvOpVH+LzxSA2k0oY0cuoZZqKdBSmNaPg==
X-Received: by 2002:a0c:c589:0:b0:4b1:af4a:5c65 with SMTP id a9-20020a0cc589000000b004b1af4a5c65mr67786961qvj.121.1670521606169;
        Thu, 08 Dec 2022 09:46:46 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id 134-20020a37088c000000b006ec771d8f89sm6214606qki.112.2022.12.08.09.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 09:46:45 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p3Kyr-006OSG-0Y;
        Thu, 08 Dec 2022 13:46:45 -0400
Date:   Thu, 8 Dec 2022 13:46:45 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V1 7/8] vfio: change dma owner
Message-ID: <Y5IjBe+IaQC/eVDh@ziepe.ca>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
 <1670363753-249738-8-git-send-email-steven.sistare@oracle.com>
 <Y5DGPcfxTJGk7IZm@ziepe.ca>
 <0f6d9adb-b5b9-ca52-9723-752c113e97c4@oracle.com>
 <Y5Ibvv9PNMifi0NF@ziepe.ca>
 <542e7894-df8c-8e83-c6db-eeb22d9062fb@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542e7894-df8c-8e83-c6db-eeb22d9062fb@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 08, 2022 at 12:39:19PM -0500, Steven Sistare wrote:
> On 12/8/2022 12:15 PM, Jason Gunthorpe wrote:
> > On Thu, Dec 08, 2022 at 11:48:08AM -0500, Steven Sistare wrote:
> > 
> >>> Anyhow, I came up with this thing. Needs a bit of polishing, the
> >>> design is a bit odd for performance reasons, and I only compiled it.
> >>
> >> Thanks, I'll pull an iommfd development environment together and try it.
> >> However, it will also need an interface to change vaddr for each dma region.
> >> In general the vaddr will be different when the memory object is re-mapped 
> >> after exec.
> > 
> > Ahh that is yuky :\
> > 
> > So I still like the one shot approach because it has nice error
> > handling properties, and it lets us use the hacky very expensive "stop
> > the world" lockng to avoid slowing the fast paths.
> > 
> > Passing in a sorted list of old_vaddr,new_vaddr is possibly fine, the
> > kernel can bsearch it as it goes through all the pages objects.
> 
> Sorry, I was imprecise. I meant to say, "it will also need an interface to 
> change all vaddrs".  Passing an array or list of new vaddrs in a one-shot
> ioctl.
> 
> I hope the "very expensive path" is not horribly slow, as it is in the
> critical path for guest pause time.  Right now the pause time is less than
> 100 millisecs.

I think compared to 1 ioctl per map it is probably notably faster, it
is just "horribly expensive" to do the ioctl preamble - eg you would
not want to iterate it.

Jason
