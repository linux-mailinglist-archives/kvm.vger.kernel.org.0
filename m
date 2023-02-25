Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E7A6A27A9
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 08:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjBYHIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 02:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBYHIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 02:08:40 -0500
X-Greylist: delayed 2552 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Feb 2023 23:08:38 PST
Received: from devnull.tasossah.com (devnull.tasossah.com [IPv6:2001:41d0:1:e60e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE19610AB1
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 23:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=devnull.tasossah.com; s=vps; h=Content-Transfer-Encoding:Content-Type:
        Subject:Cc:To:From:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ohy0RkAoH3fZHerb5qaRWkGG3yX08fblmtO1epBkzc4=; b=TGlXod/sNTJ1eT6TcSB/DlEZ8t
        Qh523UBSXqcVzBHrxpJKddwu51EJZ020Iem1Xbd7sRZ18vmeEYFspJrbHZPuBeyUAXpG4o8GFBWJK
        NnUNEYcAwNet9u4QCkaGw/YnW9daoR/DfuH4I2iFSQcPxbciBuKSTHUsOW1kO7T4H7Io=;
Received: from [2a02:587:6a08:c500::298]
        by devnull.tasossah.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <tasos@tasossah.com>)
        id 1pVo0O-00BXtM-IG; Sat, 25 Feb 2023 08:26:00 +0200
Message-ID: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
Date:   Sat, 25 Feb 2023 08:25:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Tasos Sahanidis <tasos@tasossah.com>
To:     alex.williamson@redhat.com
Cc:     abhsahu@nvidia.com, kvm@vger.kernel.org
Content-Language: en-US
Subject: Bug: Completion-Wait loop timed out with vfio
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello everyone,

Attempting to pass through my graphics card to a VM with kernel 
>= 5.19.results in the following (host):

[   72.645091] AMD-Vi: Completion-Wait loop timed out
[   72.791448] AMD-Vi: Completion-Wait loop timed out
[   72.937768] AMD-Vi: Completion-Wait loop timed out
[   73.084388] AMD-Vi: Completion-Wait loop timed out
[   73.231661] AMD-Vi: Completion-Wait loop timed out
[   73.231711] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f000 flags=0x0050]
[   73.231724] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f040 flags=0x0050]
[   73.231734] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f080 flags=0x0050]
[   73.231743] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f0c0 flags=0x0050]
[   73.231752] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f100 flags=0x0050]
[   73.231761] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f140 flags=0x0050]
[   73.231770] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f180 flags=0x0050]
[   73.231779] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f1c0 flags=0x0050]
[   73.231788] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f200 flags=0x0050]
[   73.231797] ahci 0000:0c:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0017 address=0xc5f3f240 flags=0x0050]
[   73.377900] AMD-Vi: Completion-Wait loop timed out
[   73.500538] iommu ivhd0: AMD-Vi: Event logged [IOTLB_INV_TIMEOUT device=06:00.0 address=0x1001e4600]
[   73.546431] AMD-Vi: Completion-Wait loop timed out
[   73.693772] AMD-Vi: Completion-Wait loop timed out
[   73.847385] AMD-Vi: Completion-Wait loop timed out
[   74.001796] AMD-Vi: Completion-Wait loop timed out
[   74.148077] AMD-Vi: Completion-Wait loop timed out
[   74.168380] virbr0: port 2(vnet0) entered learning state
[   74.294937] AMD-Vi: Completion-Wait loop timed out
[   74.296484] ata2.00: exception Emask 0x20 SAct 0x7e703fff SErr 0x0 action 0x6 frozen
[   74.296492] ata2.00: irq_stat 0x20000000, host bus error
[   74.296496] ata2.00: failed command: WRITE FPDMA QUEUED
[   74.296498] ata2.00: cmd 61/08:00:c0:ec:91/00:00:01:00:00/40 tag 0 ncq dma 4096 out
                        res 40/00:34:20:eb:91/00:00:01:00:00/40 Emask 0x20 (host bus error)
[   74.296507] ata2.00: status: { DRDY }
[more ATA errors]
[   74.296724] ata2: hard resetting link
[   74.430739] AMD-Vi: Completion-Wait loop timed out
[   74.502557] iommu ivhd0: AMD-Vi: Event logged [IOTLB_INV_TIMEOUT device=06:00.0 address=0x1001e4660]
[   74.502563] iommu ivhd0: AMD-Vi: Event logged [IOTLB_INV_TIMEOUT device=06:00.0 address=0x1001e4680]
[   74.680713] vfio-pci 0000:06:00.0: enabling device (0000 -> 0003)
[   74.681219] vfio-pci 0000:06:00.0: vfio_ecap_init: hiding ecap 0x19@0x270
[   74.681235] vfio-pci 0000:06:00.0: vfio_ecap_init: hiding ecap 0x1b@0x2d0
[   74.700687] vfio-pci 0000:06:00.1: enabling device (0000 -> 0002)
[   74.772816] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   74.775906] ata2.00: configured for UDMA/133
[   74.775957] ata2: EH complete
[   74.935315] AMD-Vi: Completion-Wait loop timed out
[   75.073590] AMD-Vi: Completion-Wait loop timed out
[   75.212946] AMD-Vi: Completion-Wait loop timed out
[   75.379316] AMD-Vi: Completion-Wait loop timed out
[   75.504512] iommu ivhd0: AMD-Vi: Event logged [IOTLB_INV_TIMEOUT device=06:00.0 address=0x1001e46f0]

Stopping the VM results in similar messages.

The card is an AMD Radeon HD 7790 (1002:665c) and shows up at 06:00.0 on
the host. This is a Ryzen system with an ASUS "TUF GAMING X570-PLUS".
Userspace virt-related packages are all stock from Ubuntu 20.04.

While these messages are printed, sometimes the cursor and audio
stutter. These temporary freezes have also caused file system
corruption. The graphics card is non functional in this state.

Bisecting this shows that the issue was introduced by:
7ab5e10eda02d ("vfio/pci: Move the unused device into low power state with runtime PM").

Reverting that commit in 5.19 results in GPU passthrough working as
expected. The patch doesn't cleanly revert on kernels newer than 5.19.

--
Tasos
