Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8440D64D1ED
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 22:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiLNVng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 16:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiLNVn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 16:43:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BFF379C2
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 13:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671054154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/5kOaiQ5bdlOW+7uJUOh9oZPjjvwDTKBEEXenTlVbno=;
        b=OXSLA2wmX7zJnOnMnEmC+3LYLWVoRyPcnSif5MWwjW5dFjQQKRzu3bX33Yx0zS77ajLKfG
        GMD1yqcMPWvKfytfIt34AUKDSLQns0SkXj6wxtcW94jE/3Lr2bsZjPcI8UeBkKLzdTjTpF
        q4xPbXWA5f1b0AuoIaAvxEKGIOCrbIo=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-427-agNWmfrOMhaRnYGJCpXlLA-1; Wed, 14 Dec 2022 16:42:33 -0500
X-MC-Unique: agNWmfrOMhaRnYGJCpXlLA-1
Received: by mail-io1-f70.google.com with SMTP id n10-20020a6b590a000000b006e03471b3eeso4624924iob.11
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 13:42:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/5kOaiQ5bdlOW+7uJUOh9oZPjjvwDTKBEEXenTlVbno=;
        b=dFnS0qLvbXZBxEXL0s1l23Hw6nTm8EOfO2tiB/JZ12PEauOOPXOmReVWwxsj56ovLA
         NDXSndMg/xRzMBQKMC4IApe0G3EEvZ7VAm9y9B4+IhQLNRk095TwT5CtHKsvNW9TPOzy
         Ap3AWw36C4sv+5bHg/rihq5HUGdf6pKfunGsokrL79GO5+fkpu2T+hwJm2sz2hKnZY14
         TE4+SjHa6+kbjF8IkjGjGLfLv3NewBi5hUlrEnftw+C2qBz1s2mQZ3UE1HF8QlHnYzYa
         55USgWV6IntkUQGONS7fmDRLVLageeAA2s7OPMV2qUwXIeMNtxIFpIUIm6T2DWXGjMpn
         /tRA==
X-Gm-Message-State: ANoB5pmKFCOOBG1YcZXX1lWZ5sF4WFzqQ1Qel5Shj5as5oArcr6yXRpy
        6YOUBI5YkJYH+PoXNn9PyTOS3NK8dk15HugVy1O3Fg2vcWZImLbzVqUvpy7tJsBqPEvJ7ZbxZsl
        MWPN1s4r1zGHw
X-Received: by 2002:a92:1910:0:b0:300:bcdd:919 with SMTP id 16-20020a921910000000b00300bcdd0919mr17359081ilz.22.1671054152348;
        Wed, 14 Dec 2022 13:42:32 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6w3PKGlPj6XomzkCE4zkYt9t+3M4a2+EWYGoW7KGzPMpgc67x3wcpUEBuKusvYKkZI7GPK5A==
X-Received: by 2002:a92:1910:0:b0:300:bcdd:919 with SMTP id 16-20020a921910000000b00300bcdd0919mr17359064ilz.22.1671054152132;
        Wed, 14 Dec 2022 13:42:32 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c2-20020a92dc82000000b00302e4c93a54sm4787794iln.79.2022.12.14.13.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 13:42:31 -0800 (PST)
Date:   Wed, 14 Dec 2022 14:42:29 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V4 0/5] fixes for virtual address update
Message-ID: <20221214144229.43c8348d.alex.williamson@redhat.com>
In-Reply-To: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
References: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
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

On Wed, 14 Dec 2022 13:24:52 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Fix bugs in the interfaces that allow the underlying memory object of an
> iova range to be mapped in a new address space.  They allow userland to
> indefinitely block vfio mediated device kernel threads, and do not
> propagate the locked_vm count to a new mm.
> 
> The fixes impose restrictions that eliminate waiting conditions, so
> revert the dead code:
>   commit 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")
>   commit 487ace134053 ("vfio/type1: implement notify callback")
>   commit ec5e32940cc9 ("vfio: iommu driver notify callback")
> 
> Changes in V2 (thanks Alex):
>   * do not allow group attach while vaddrs are invalid
>   * add patches to delete dead code
>   * add WARN_ON for never-should-happen conditions
>   * check for changed mm in unmap.
>   * check for vfio_lock_acct failure in remap
> 
> Changes in V3 (ditto!):
>   * return errno at WARN_ON sites, and make it unique
>   * correctly check for dma task mm change
>   * change dma owner to current when vaddr is updated
>   * add Fixes to commit messages
>   * refactored new code in vfio_dma_do_map
> 
> Changes in V4:
>   * misc cosmetic changes
> 
> Steve Sistare (5):
>   vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
>   vfio/type1: prevent locked_vm underflow
>   vfio/type1: revert "block on invalid vaddr"
>   vfio/type1: revert "implement notify callback"
>   vfio: revert "iommu driver notify callback"
> 
>  drivers/vfio/container.c        |   5 -
>  drivers/vfio/vfio.h             |   7 --
>  drivers/vfio/vfio_iommu_type1.c | 199 +++++++++++++++++++---------------------
>  include/uapi/linux/vfio.h       |  15 +--
>  4 files changed, 103 insertions(+), 123 deletions(-)
> 

Looks ok to me.  Jason, Kevin, I'd appreciate your reviews regarding
whether this sufficiently addresses the outstanding issues to keep this
interface around until we have a re-implementation in iommufd.  Thanks,

Alex

