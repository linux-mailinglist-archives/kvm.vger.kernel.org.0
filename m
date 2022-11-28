Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C2F63B0F3
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 19:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbiK1SSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 13:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbiK1SSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 13:18:10 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296162A73B
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 10:01:46 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id cg5so7215630qtb.12
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 10:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UwG5p8IQE1UGVQWrYep9M1WjUfwCOY/agkbTrcq5miU=;
        b=RCyHi9hwDSE3J/AHA8jw4Z7EA6VS7KMiUpq3n8a/WKUZ+1PMtN1fIeZcYe5vbYxyE6
         Tc2GNHRRRoZ2KcD0oTOSebGeBI3WqUvLVlk6pPKSwgA8yjip1qGO9CDZN0PhQS7M4PzP
         APP1EZjQ1rGxPlI1NvrbmPQqr5OxtwhdYdYImwk+t25jqXpAlyIXUtlb6Vw6rhMVKOJ1
         ed0LtB/T/p5iNpTSXsZytoGz8kPMXGznEwLHWfZqDN+p3vpI+sqkQUUBvgSSHZ5Qriy0
         xartjVPPOo7T6gjYa74uqBlXbIuFLxRa3CmVjzZSBdwL2G37gVo2vdjiK2ErU1b3KX+y
         7tlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwG5p8IQE1UGVQWrYep9M1WjUfwCOY/agkbTrcq5miU=;
        b=BZbQ5Qq89QMTCTzdTstMIpaErX42Hz5g/yJRbUYiDvaolXILicYAy/stbQn5GS4RkX
         VsfrkvrL5D/2S/+bRgMaC0opPESw/O5OYKXyxm79xR96ORKOmCFaIsEcVNICjGrTm5QV
         zdHsuppsvv3jDz8wFKCTJUHNTQaD+BC8LE9oPC4G1efacap2/xylv4NsMVscf7EbtJ4H
         N7Jv5qIlffA0tZBowdSBpcKyJOFCgs6JtYNObRPOVhGxglb+jWMb3/srtmZVRQ4QIPc3
         aRmaob5k5af9WExSRpzuPFMtuInVRlM/EI20xYA0RZ0sDeuJcARX+lo42P5xhKa1Enjx
         MUyQ==
X-Gm-Message-State: ANoB5pmQYMrOetjtRWsTkE2Tat6NjckTVrPX+72ruZ8aTn0KLzMYoAAQ
        cZPKk6Zhj8XQvZEQYLS8JA+sjw==
X-Google-Smtp-Source: AA0mqf6XoOey/AP2fzMVBKOHGLrKr/wvWMVuMThokL6wgvIHZ1YXKjAMcEltHKgLC3qNwC1u/LQ0HQ==
X-Received: by 2002:ac8:67d0:0:b0:399:acab:ed6d with SMTP id r16-20020ac867d0000000b00399acabed6dmr49642544qtp.101.1669658505287;
        Mon, 28 Nov 2022 10:01:45 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id h4-20020a05620a284400b006bb29d932e1sm8798602qkp.105.2022.11.28.10.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 10:01:44 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oziRr-00GboS-3d;
        Mon, 28 Nov 2022 14:01:43 -0400
Date:   Mon, 28 Nov 2022 14:01:43 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Marc Zyngier <maz@kernel.org>
Cc:     chenxiang <chenxiang66@hisilicon.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, linuxarm@huawei.com
Subject: Re: [PATCH v2] vfio/pci: Verify each MSI vector to avoid invalid MSI
 vectors
Message-ID: <Y4T3h+rzGBPo7FLj@ziepe.ca>
References: <1669167756-196788-1-git-send-email-chenxiang66@hisilicon.com>
 <Y3+xTLC0io6wvPpf@ziepe.ca>
 <871qpquful.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qpquful.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 26, 2022 at 11:15:14AM +0000, Marc Zyngier wrote:

> > Physical hardware doesn't do this, virtual emulation shouldn't either.
> 
> If you want to fix VFIO, be my guest. My rambling about the sorry
> state of this has been in the kernel for 5 years (ed8703a506a8).

We are talking about things. Stuff we want to do doesn't work, or is
completely insane right now.

> > People are taking too many liberties with trapping the PCI MSI
> > registers through VFIO. :(
> 
> Do you really want to leave access to the MSI BAR to userspace? The
> number of ways this can go wrong is mind-boggling. 

Yeah, actually I do. This is basically mandatory to do something like
IMS, SIOV, etc.

> Starting with having to rebuild the interrupt translation tables on
> the host side to follow what the guest does, instead of keeping the
> two independent.

At least on x86 most of the discussion has been about teaching the
interrupt controller to go to the hypervisor to get help when
establishing interrupts. The hypervisor can tell the guest what the
real MSI data is.

This is following the example of hyperv which plugs in a hyper call to
HVCALL_MAP_DEVICE_INTERRUPT in its remapping irq_chip. This allows the
hypervisor to tell the guest a real addr/data pair and the hypervisor
does not have to involve itself in the device programming.

We haven't reached a point of thinking in detail about ARM, but I would
guess the general theme would still apply.

Jason
