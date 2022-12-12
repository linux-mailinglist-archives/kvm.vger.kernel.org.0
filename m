Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAB564A981
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 22:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiLLV2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 16:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbiLLV14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 16:27:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87F11741A
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 13:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670880416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ESzb52BjV28O9Vn0affkyljMBG0fZ0DdXYD2mD//kKk=;
        b=MzIU5E80SNVivInvXQiQWZPus/GGJ2mr3srny/KUTVdU95Yozn3jQqOjDkGheoLAucR5yU
        UN/DiiLaFuKRS7MbBn/G1dLvtwCt/CcT1LNNvH5wGYJkm3nxR6JXpMcaXR0w4yfj+5X6xk
        5BkoUYhN/cqiQJDzCBuUKfQhCxdLrBU=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-616-icvrY9odMnyoj0fTdF90vg-1; Mon, 12 Dec 2022 16:26:54 -0500
X-MC-Unique: icvrY9odMnyoj0fTdF90vg-1
Received: by mail-il1-f198.google.com with SMTP id x9-20020a056e021ca900b003037ca1af0cso6085491ill.16
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 13:26:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ESzb52BjV28O9Vn0affkyljMBG0fZ0DdXYD2mD//kKk=;
        b=ZbQMJLgqmT0V1RJ/yK5xEo1ibhylB2o9iWgd/auL3x1LDXWsBCP4Nx+fGnAIycWQCj
         mEv3Stbq33R7M1sGWDjdrVvacfVuQ+2TSlqJyv3Iej6zs3rRe8Jq+g7FXnvL9PkXsJ+P
         TsKNNRt7WWgL3d/jB4VTc3LUpipXCakuV25D6HeEljMNckzwHRZx0BYLa0547AKtxEik
         Z+QOSrwV3rtS2DnxxLj9/H/ZIJwzfWiJljbMzZ/Q4hgODnEDM7FLC8gP96TSaTBuDr+U
         fWJ5e/pPyeiLEt6cCJheV69v8OWFvhFi0Ch76/hjl2UwOGUjOUFecDM3GfyvUbEGS6N8
         UV8A==
X-Gm-Message-State: ANoB5pk02Od6tY/KZSn1/Vymd/YCwl/f2HAn0BUzrD6tt5GMCGfIgXCd
        C6fDQdEq4ouBPxZmjgI+2peVSY20w22iMSnKtBFgx88+yrrhZ9avKJy2Fqb0SImjrUjS7brxX6w
        j5LRBSZYz6vaY
X-Received: by 2002:a05:6602:1d4:b0:6df:e4f7:8c20 with SMTP id w20-20020a05660201d400b006dfe4f78c20mr9833123iot.14.1670880414009;
        Mon, 12 Dec 2022 13:26:54 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7v6Ul6nwS26XZd/iOTb8ZkMEzRCGY9PUjpxPpUAioVUp3lRXGnXSwiAa+CdB0kjNlvAEGgCA==
X-Received: by 2002:a05:6602:1d4:b0:6df:e4f7:8c20 with SMTP id w20-20020a05660201d400b006dfe4f78c20mr9833118iot.14.1670880413778;
        Mon, 12 Dec 2022 13:26:53 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i189-20020a6bb8c6000000b006dfb7d199dasm4506948iof.7.2022.12.12.13.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 13:26:53 -0800 (PST)
Date:   Mon, 12 Dec 2022 14:26:51 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Message-ID: <20221212142651.263dd6ae.alex.williamson@redhat.com>
In-Reply-To: <8f29aad0-7378-ef7a-9ac5-f98b3054d5eb@oracle.com>
References: <167044909523.3885870.619291306425395938.stgit@omen>
        <BN9PR11MB5276222DAE8343BBEC9A79E98C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20221208094008.1b79dd59.alex.williamson@redhat.com>
        <b265b4ae-b178-0682-66b8-ef74a1489a8e@oracle.com>
        <20221209124212.672b7a9c.alex.williamson@redhat.com>
        <5f494e1f-536d-7225-e2c7-5ec9c993f13a@oracle.com>
        <20221209140120.667cb658.alex.williamson@redhat.com>
        <6914b4eb-cd82-0c3e-6637-c7922092ef11@oracle.com>
        <Y5cqAk1/6ayzmTjg@ziepe.ca>
        <20221212085823.5d760656.alex.williamson@redhat.com>
        <8f29aad0-7378-ef7a-9ac5-f98b3054d5eb@oracle.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 12 Dec 2022 15:59:11 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 12/12/2022 10:58 AM, Alex Williamson wrote:
> > On Mon, 12 Dec 2022 09:17:54 -0400
> > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >   
> >> On Sat, Dec 10, 2022 at 09:14:06AM -0500, Steven Sistare wrote:
> >>  
> >>> Thank you for your thoughtful response.  Rather than debate the degree of
> >>> of vulnerability, I propose an alternate solution.  The technical crux of
> >>> the matter is support for mediated devices.      
> >>
> >> I'm not sure I'm convinced about that. It is easy to make problematic
> >> situations with mdevs, but that doesn't mean other cases don't exist
> >> too eg what happens if userspace suspends and then immediately does
> >> something to trigger a domain attachment? Doesn't it still deadlock
> >> the kernel?  
> > 
> > The opportunity for that to deadlock isn't obvious to me, a replay
> > would be stalled waiting for invalid vaddrs, but this is essentially
> > the user deadlocking themselves.  There's also code there to handle the
> > process getting killed while waiting, making it interruptible.  Thanks,  
> 
> I will submit new patches tomorrow to exclude mdevs.  Almost done.

I've dropped the removal commits from my next branch in the interim.
Thanks,

Alex

