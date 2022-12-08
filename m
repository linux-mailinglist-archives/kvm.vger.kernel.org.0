Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F3B6474E6
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 18:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLHRPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 12:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLHRPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 12:15:45 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CD67DA7C
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 09:15:45 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id j13so1089744qka.3
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 09:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3zAEindOiDw3p/QUnojUCi9zb5fCUbsCVu9Sm2mbL70=;
        b=B+FW31yj55gsXTk6nvxmJifRtRFBRkfUyjyBA5htz6Sq/iqRU03Ej6IZiuESR7Bknc
         QIPL5AFqtbk6oVZp6VFLfHrmTLfLHeaMdjM2tO3DaFWLbnIWDGZF+nVU/n4pL+Qv9uFX
         t+cr6KOwwq7jwohZQj7XcnukGnnZVxYS69BQK4fePHOXq3jBjy/EKLg8eO0OXBCmgLyI
         aKM0CeU9Bs+4sHdOPlrCR8QQvN88xgoBQzApwf2RnQ2gH+oGGETHx3htOMlKLaTliYPk
         5XLZFO/NOQEJ8S2BlPSjuQ9kKwY5sd3XL2G5OrG2e0fYZJ7WoUC5iMuSKNRYYREkSUfn
         DTeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3zAEindOiDw3p/QUnojUCi9zb5fCUbsCVu9Sm2mbL70=;
        b=T3zxEDQsow8I+wOZuVA72bDShXfOQ+PYipe03ZbXD51ITE3fMzzZ6ToGUxCZZ6cXDw
         n5eOAUIwZRiXTxOzVcy0anQXR0LsMZepjOX0yja1NCycz2njV2dhNSrLmAA8xE1jJO1w
         h6EL5kg1aFIdr7uQ/gTs0xmvkE03Yl6rde3YgUx8gDl3eypcrkXPO3VLK/Sq14Sn6g8S
         D2ljfjjlqI4YIplEzvvkp5vc8LqDFFB+Qon+VdHmdUTEcveKFQLIdEM4b1MSXPXiYxiV
         kFoXlGKuddHE6yF1i/HxNoFaxqkOKdXOhGbR78gdVFZ3IMsQ3vAmY0ehVchPIaBBfGqV
         snGg==
X-Gm-Message-State: ANoB5pm/3DaEXLy/a2Wra91laneVxZKXOWMRk6yST0U7rCj7PDCTvMOs
        q5xvmV4RPVf07H6d/daBSlZiGA==
X-Google-Smtp-Source: AA0mqf4pZoYlrJ8F0Jt5n340oU+nlu49XdQFj5sVnc0ew/a0XeYDX4vYZdf6oljAq04Ha67S3TccyQ==
X-Received: by 2002:a37:a853:0:b0:6ff:d9d:e395 with SMTP id r80-20020a37a853000000b006ff0d9de395mr146587qke.757.1670519744177;
        Thu, 08 Dec 2022 09:15:44 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id x12-20020ac8538c000000b003a7e38055c9sm7901992qtp.63.2022.12.08.09.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 09:15:43 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p3KUo-006Nwx-Ny;
        Thu, 08 Dec 2022 13:15:42 -0400
Date:   Thu, 8 Dec 2022 13:15:42 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V1 7/8] vfio: change dma owner
Message-ID: <Y5Ibvv9PNMifi0NF@ziepe.ca>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
 <1670363753-249738-8-git-send-email-steven.sistare@oracle.com>
 <Y5DGPcfxTJGk7IZm@ziepe.ca>
 <0f6d9adb-b5b9-ca52-9723-752c113e97c4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f6d9adb-b5b9-ca52-9723-752c113e97c4@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 08, 2022 at 11:48:08AM -0500, Steven Sistare wrote:

> > Anyhow, I came up with this thing. Needs a bit of polishing, the
> > design is a bit odd for performance reasons, and I only compiled it.
> 
> Thanks, I'll pull an iommfd development environment together and try it.
> However, it will also need an interface to change vaddr for each dma region.
> In general the vaddr will be different when the memory object is re-mapped 
> after exec.

Ahh that is yuky :\

So I still like the one shot approach because it has nice error
handling properties, and it lets us use the hacky very expensive "stop
the world" lockng to avoid slowing the fast paths.

Passing in a sorted list of old_vaddr,new_vaddr is possibly fine, the
kernel can bsearch it as it goes through all the pages objects.

Due to the way iommufd works, especially with copy, you end up with
the 'pages' handle that holds the vaddr that many different IOVAs may
refer to. So it is kind of weird to ask to change a single IOVA's
mapping, it must always change all the mappings that have been copied
that share vaddr, pin accounting and so forth.

This is another reason why I liked the one-shot global everything
approach, as narrowing the objects to target cannot be done by IOVA -
at best you could target a specific mm and vaddr range.

FWIW, there is a nice selftest in iommufd in
tools/testing/selftests/iommu/iommufd.c and the way to develop
something like this is to add a simple selftes to exercise your
scenario and get everything sorted like that before going to qemu.

Using the vfio compat you can keep the existing qemu vfio type1 and
just hack in a call the IOMMUFD ioctl in the right spot. No need to
jump to the iommfd version of qemu for testing.

Jason
