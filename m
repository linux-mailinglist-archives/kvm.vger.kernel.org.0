Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70DD66A6E0C
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 15:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjCAOLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 09:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjCAOLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 09:11:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF1435A0
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 06:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677679856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SE/htYPZm79nomN7aG5ij+WkKZxeWY2KhpO4NI5P7oM=;
        b=GOttXfzG5jVwB5YN+ckwvdFaix6Z3k+g3PBku/HXsRFt+gt2WLw1q4TXkGOM+ZlluSTAPw
        kzbszE1AclOOpcsCCp7VHIblE9qrqT0XzzoVmCS57Y62JgeCqpp6qalNAkKxF+2tn6R/MK
        vLW7yQEa3Ow5PhBUICbpskhHWb0IfPs=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-592-CKqzfuZpPcCCPuoMhgdtbQ-1; Wed, 01 Mar 2023 09:10:52 -0500
X-MC-Unique: CKqzfuZpPcCCPuoMhgdtbQ-1
Received: by mail-io1-f72.google.com with SMTP id v10-20020a056602058a00b007076e06ba3dso8663765iox.20
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 06:10:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SE/htYPZm79nomN7aG5ij+WkKZxeWY2KhpO4NI5P7oM=;
        b=jl2E3CdCVIu52efI1od8MZ3qYqEKFL4OdmC/66fq5QjtmIXl9k4gUZUgth+zDCQnUn
         IFAy3USiW7vVW+aojwS8+z/FWgsW51tlFkMrlQL+XKeS2uTEdRsKQgWVkxj55Woqh+OF
         Y1fUwD/ULfvyILQS7WIoT5FNN8X/Yf5csLoTg8Dk7HViT/eY2meyFEvlWWBkAm1O1/KN
         9/OXdLPYlHMGat/9tHLAqAmKr0yRz/WP0x6VbOoGJl0jzyZTPDTVkP8wyEZQ5q0/azVa
         9Rf4Rm+Wjjqv0AIk7R46d9fdCcemG9oS9ny/ELxVEIlUPf/M7zs2LXu1K5t58q/zIB6W
         nr6A==
X-Gm-Message-State: AO0yUKWBsjRdah5g1ey12Vazbz5c2PfBqRItqEMyUJanFP35h8cxg5VS
        6Ct1FfhclfkT2bTPcX6LvqdHuof6pBF6TzArV9V9XHbjlErfbWrvKg6Xa3SOzEze48ZKU6KQHGB
        iyKnT6p3vQuu/dSt7rw==
X-Received: by 2002:a05:6e02:152a:b0:316:e453:537c with SMTP id i10-20020a056e02152a00b00316e453537cmr6812137ilu.11.1677679851147;
        Wed, 01 Mar 2023 06:10:51 -0800 (PST)
X-Google-Smtp-Source: AK7set/XhU72Ba6Qmy3DC3jmZlfIP4oD+0cB/0RAuj7PfNrdHOHMtCCXbLCezsrsw8ak6P0ukPGGng==
X-Received: by 2002:a05:6e02:152a:b0:316:e453:537c with SMTP id i10-20020a056e02152a00b00316e453537cmr6812118ilu.11.1677679850841;
        Wed, 01 Mar 2023 06:10:50 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h14-20020a02cd2e000000b00374bf3b62a0sm3730263jaq.99.2023.03.01.06.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 06:10:50 -0800 (PST)
Date:   Wed, 1 Mar 2023 07:10:49 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tasos Sahanidis <tasos@tasossah.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>, kvm@vger.kernel.org
Subject: Re: Bug: Completion-Wait loop timed out with vfio
Message-ID: <20230301071049.0f8f88ae.alex.williamson@redhat.com>
In-Reply-To: <7c1980ec-d032-11c1-b09d-4db40611f268@tasossah.com>
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
        <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
        <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
        <20230228114606.446e8db2.alex.williamson@redhat.com>
        <7c1980ec-d032-11c1-b09d-4db40611f268@tasossah.com>
Organization: Red Hat
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

On Wed, 1 Mar 2023 12:34:32 +0200
Tasos Sahanidis <tasos@tasossah.com> wrote:

> On 2023-02-28 20:46, Alex Williamson wrote:
> > Can you do the same for the root port to the GPU, ex. use lspci -t to
> > find the parent root port.  Since the device doesn't seem to be
> > achieving D3cold (expected on a desktop system), the other significant
> > change of the identified commit is that the root port will also enter a
> > low power state.  Prior to that commit the device would enter D3hot, but
> > we never touched the root port.  Perhaps confirm the root port now
> > enters D3hot and compare lspci for the root port when using
> > disable_idle_d3 to that found when trying to use the device without
> > disable_idle_d3. Thanks,
> > 
> > Alex
> >   
> 
> I seem to have trouble understanding the lspci tree.
> 
> The tree is as follows:
> 
> -[0000:00]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
> [...]      |
>            +-01.2-[02-0d]----00.0-[03-0d]--+-01.0-[04-05]----00.0-[05]--+-00.0  Creative Labs EMU10k2/CA0100/CA0102/CA10200 [Sound Blaster Audigy Series]
>            |                               |                            +-00.1  Creative Labs SB Audigy Game Port
>            |                               |                            +-01.0  Brooktree Corporation Bt878 Video Capture
>            |                               |                            \-01.1  Brooktree Corporation Bt878 Audio Capture
>            |                               +-02.0-[06]--+-00.0  Advanced Micro Devices, Inc. [AMD/ATI] Bonaire XT [Radeon HD 7790/8770 / R7 360 / R9 260/360 OEM]
>            |                               |            \-00.1  Advanced Micro Devices, Inc. [AMD/ATI] Tobago HDMI Audio [Radeon R7 360 / R9 360 OEM]
>            |                               +-03.0-[07-08]----00.0-[08]--+-00.0  Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder
>            |                               |                            \-01.0  Yamaha Corporation YMF-744B [DS-1S Audio Controller]
>            |                               +-05.0-[09]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
>            |                               +-06.0-[0a]--+-00.0  MosChip Semiconductor Technology Ltd. PCIe 9912 Multi-I/O Controller
>            |                               |            +-00.1  MosChip Semiconductor Technology Ltd. PCIe 9912 Multi-I/O Controller
>            |                               |            \-00.2  MosChip Semiconductor Technology Ltd. PCIe 9912 Multi-I/O Controller
>            |                               +-08.0-[0b]--+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Reserved SPP
>            |                               |            +-00.1  Advanced Micro Devices, Inc. [AMD] Matisse USB 3.0 Host Controller
>            |                               |            \-00.3  Advanced Micro Devices, Inc. [AMD] Matisse USB 3.0 Host Controller
>            |                               +-09.0-[0c]----00.0  Advanced Micro Devices, Inc. [AMD] FCH SATA Controller [AHCI mode]
>            |                               \-0a.0-[0d]----00.0  Advanced Micro Devices, Inc. [AMD] FCH SATA Controller [AHCI mode]
> [...]      |
> 
> The parent root port is either 0000:00:01.2 or 0000:00:02.0, correct?

The topology is a bit more complex than usual, the root port is indeed
0000:00:01.2, but we have a PCIe switch.

> 00:01.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge
> 02:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse Switch Upstream

0000:02:00.0 is the upstream port of that switch and 0000:03:02.0 is
the downstream port for the 7790.  0000:03:02.0 is the port that should
also now enter D3hot.

> If so, I tested in 5.18, both before and while running the VM, with 6.2
> both with and without disable_idle_d3, and in all cases they stayed at D0.

In this case the upstream port should always stay in D0, it has quite a
lot more devices under it than just the GPU.  It's interesting that the
MosChip that assigns ok is also under a downstream port of this switch.
That means the downstream port 0000:03:06.0 should also be entering
D3hot when all of the MosChip devices are attached to vfio-pci and
unused.

I'm not convinced thought that the MosChip assignment is a good
comparison device though, as a "multi-i/o" controller, it's possible
that it doesn't actually make use of DMA that would trigger the IOMMU
like the GPU does.  Do you have a NIC card you could replace one of
these with?

It's possible the switch has a problem with D3hot support and it may
need to be disabled or augmented with a PCI quirk.  In addition to
investigating what power state the downstream port is achieving and
reporting lspci -vvv with and without disable_idle_d3, would you mind
reporting "lspci -nns 2:00.0" and "lspci -nns 3:" to report all the
vendor and device IDs of the switch.  Thanks,

Alex

