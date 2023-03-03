Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705D26A910B
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 07:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjCCGdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 01:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCCGdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 01:33:37 -0500
Received: from devnull.tasossah.com (devnull.tasossah.com [IPv6:2001:41d0:1:e60e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B75E1165F
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 22:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=devnull.tasossah.com; s=vps; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:Subject:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OCgCe+SftXVyGAKci/3Z6KLMadf9ZlNGlaAVtPIH0BQ=; b=AZNP1zRk7dgjNUyW37NcfoMpDc
        ntTu8GL4xR9gDXktyKRZSNzejao12myR1eiiSePEwjaHfKzOfI1uKee1Wwrc0m6EJYSJkPVeXLwf/
        lNGRu2cJeHGo1mqwazjgMLF3E2uRtQMF78jekvXFg/AGn5YQw2DmF/6NOjIwfn5DPxk8=;
Received: from [2a02:587:6a02:3a00::298]
        by devnull.tasossah.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <tasos@tasossah.com>)
        id 1pXyys-00CROu-Cz; Fri, 03 Mar 2023 08:33:26 +0200
Message-ID: <5682fc52-d2a3-8fd9-47e8-eb12d5f87c57@tasossah.com>
Date:   Fri, 3 Mar 2023 08:33:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>, kvm@vger.kernel.org
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
 <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
 <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
 <20230228114606.446e8db2.alex.williamson@redhat.com>
 <7c1980ec-d032-11c1-b09d-4db40611f268@tasossah.com>
 <20230301071049.0f8f88ae.alex.williamson@redhat.com>
 <4c079c5a-f8e2-ce4d-a811-dc574f135cff@tasossah.com>
 <20230302133655.2966f2e3.alex.williamson@redhat.com>
Content-Language: en-US, en-GB
From:   Tasos Sahanidis <tasos@tasossah.com>
Subject: Re: Bug: Completion-Wait loop timed out with vfio
In-Reply-To: <20230302133655.2966f2e3.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-03-02 22:36, Alex Williamson wrote:
> Yes, the fact that the NIC works suggests there's not simply a blatant
> chip defect where we should blindly disable D3 power state support for
> this downstream port.  I'm also not seeing any difference in the
> downstream port configuration between the VM running after the port has
> resumed from D3hot and the case where the port never entered D3hot.

Agreed.

> But it suddenly dawns on me that you're assigning a Radeon HD 7790,
> which is one of the many AMD GPUs which is plagued by reset problems.
> I wonder if that's a factor there.  This particular GPU even has
> special handling in QEMU to try to manually reset the device, and which
> likely has never been tested since adding runtime power management
> support.  In fact, I'm surprised anyone is doing regular device
> assignment with an HD 7790 and considers it a normal, acceptable
> experience even with the QEMU workarounds.

I had no idea. I always assumed that because it worked out of the box
ever since I first tried passing it through, it wasn't affected by these
reset issues. I never had any trouble with it until now.

> I certainly wouldn't feel comfortable proposing a quirk for the
> downstream port to disable D3hot for an issue only seen when assigning
> a device with such a nefarious background relative to device
> assignment.  It does however seem like there are sufficient options in
> place to work around the issue, either disabling power management at
> the vfio-pci driver, or specifically for the downstream port via sysfs.
> I don't really have any better suggestions given our limited ability to
> test and highly suspect target device.  Any other ideas, Abhishek?
> Thanks,
> 
> Alex

This actually gave me an idea on how to check if it's the graphics card
that's at fault, or if it is QEMU's workarounds.

I booted up the system as usual and let vfio-pci take over the device.
Both the device itself and the PCIe port were at D3hot. I manually
forced the PCIe port to switch to D0, with the GPU remaining at D3hot. I
then proceeded to start up the VM, and there were no errors in dmesg.

If it's even possible, it sounds like QEMU might be doing something
before the PCIe port is (fully?) out of D3hot, and thus the card tries
to do something which makes the IOMMU unhappy.

Is there something in either the rpm trace, or elsewhere that can help
me dig into this further?

--
Tasos
