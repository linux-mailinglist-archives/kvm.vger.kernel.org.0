Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A10664AB27
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 00:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbiLLXJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 18:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiLLXJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 18:09:02 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB7260D4
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 15:08:59 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id cg5so10407416qtb.12
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 15:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nzTpm5EijSJdDm8aOtLCGeOGNMrMf2l2lMAGSj6pSgM=;
        b=ZCIuGIvwDdej5bfp1xc75QGUEnprbyJhozWYfGyHCJ+wrne4wRU0iNIA1Q/tCDo14/
         1eCPunQ4D12Xvti3u/nCCtbtS3eMhdER5snIldsF+0lgAwsFAtonYH8/Vp0PoDZgAfvf
         bjPyyOWcfoeM3GMbFZd3sTfBT4DVh1BePwmf80A5qW1w5XNHKl53KOoL+B7Vj/wXTPcj
         Hzl6EFRe+iyQMC0PH2BE5gFF0O6rL/joagFCqwHg4WuhxcvTYtzMnVT3kCLL1fEf+FyU
         0s4KWsUQ0OPKVO+fs0iF9P8L08GnSFJvKP989hCKNtpwmJTkjQJbKOD4y/LP7kfNcHFL
         e7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nzTpm5EijSJdDm8aOtLCGeOGNMrMf2l2lMAGSj6pSgM=;
        b=G86mWWYY5FK9qjWEtLU4D8WrvjG10DMxd0oYfZS36NAd/KkT/fuqPRbzBegyUmpVmH
         PNpDsuLgve1A13+53hLae0dVmt6131q1ab+4aHXhWO98tnKU+bLcbcfcKyGLarrC74Qn
         BTwicQiHPpZe8R2IlEDay8bro10tdsTS5logP4VF9RDhG7AB91P0GFBOUWqfA978Auom
         x8SuPE2BL7Q846Vp471AmZy0can3F+luvxYUimQtSr56gAb1aCDorOFFxBos8mcUv/No
         Qj14f/P4YdSjzqdL7KgTi0vbHPjSnPc70uV2ixSnfejiU5rY1oGKvfsM/wszYkr+KGEP
         lq1A==
X-Gm-Message-State: ANoB5pnOPU0cS83MAB26IIsp8eD1wAB5Nx0x+g8MQJPdlNzxygN+DDEP
        3u75P/DznLJ5eiMWOMOtXpsiBQ==
X-Google-Smtp-Source: AA0mqf5cBxr/czn2tcmqK2bf565ifLOGx1x/ogWDFM86zMuRAGRfEWJp0uFGCey9Ommr0Aw/sd05bA==
X-Received: by 2002:a05:622a:4184:b0:39c:da20:f705 with SMTP id cd4-20020a05622a418400b0039cda20f705mr25198296qtb.41.1670886538935;
        Mon, 12 Dec 2022 15:08:58 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-50-193.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.50.193])
        by smtp.gmail.com with ESMTPSA id e2-20020ac845c2000000b003a5c6ad428asm6418411qto.92.2022.12.12.15.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 15:08:58 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p4rur-008z7X-EE;
        Mon, 12 Dec 2022 19:08:57 -0400
Date:   Mon, 12 Dec 2022 19:08:57 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Steven Sistare <steven.sistare@oracle.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Message-ID: <Y5e0icoO89Qnlc/z@ziepe.ca>
References: <20221208094008.1b79dd59.alex.williamson@redhat.com>
 <b265b4ae-b178-0682-66b8-ef74a1489a8e@oracle.com>
 <20221209124212.672b7a9c.alex.williamson@redhat.com>
 <5f494e1f-536d-7225-e2c7-5ec9c993f13a@oracle.com>
 <20221209140120.667cb658.alex.williamson@redhat.com>
 <6914b4eb-cd82-0c3e-6637-c7922092ef11@oracle.com>
 <Y5cqAk1/6ayzmTjg@ziepe.ca>
 <20221212085823.5d760656.alex.williamson@redhat.com>
 <8f29aad0-7378-ef7a-9ac5-f98b3054d5eb@oracle.com>
 <20221212142651.263dd6ae.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212142651.263dd6ae.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 12, 2022 at 02:26:51PM -0700, Alex Williamson wrote:
> On Mon, 12 Dec 2022 15:59:11 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
> 
> > On 12/12/2022 10:58 AM, Alex Williamson wrote:
> > > On Mon, 12 Dec 2022 09:17:54 -0400
> > > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >   
> > >> On Sat, Dec 10, 2022 at 09:14:06AM -0500, Steven Sistare wrote:
> > >>  
> > >>> Thank you for your thoughtful response.  Rather than debate the degree of
> > >>> of vulnerability, I propose an alternate solution.  The technical crux of
> > >>> the matter is support for mediated devices.      
> > >>
> > >> I'm not sure I'm convinced about that. It is easy to make problematic
> > >> situations with mdevs, but that doesn't mean other cases don't exist
> > >> too eg what happens if userspace suspends and then immediately does
> > >> something to trigger a domain attachment? Doesn't it still deadlock
> > >> the kernel?  
> > > 
> > > The opportunity for that to deadlock isn't obvious to me, a replay
> > > would be stalled waiting for invalid vaddrs, but this is essentially
> > > the user deadlocking themselves.  There's also code there to handle the
> > > process getting killed while waiting, making it interruptible.  Thanks,  
> > 
> > I will submit new patches tomorrow to exclude mdevs.  Almost done.
> 
> I've dropped the removal commits from my next branch in the interim.

Woah, please don't do that - I already built and sent pull requests
assuming this, there are conflicts.

Why would we not revert everything from 6.2 - that is what we agreed
to do?

Jason
