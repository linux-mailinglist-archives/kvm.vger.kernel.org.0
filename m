Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9933D6474A7
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 17:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiLHQuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 11:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiLHQuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 11:50:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F4BAFCCB;
        Thu,  8 Dec 2022 08:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8598661FBE;
        Thu,  8 Dec 2022 16:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB23CC433D2;
        Thu,  8 Dec 2022 16:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670518209;
        bh=ED+quA3q1cPoazrtWjwRDtKSWpEhe+MZiD9yUS5rEqw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=M4CJW1h/SBhGhCYh8Ju4lJI4nHuijFmc/UJRDyxtbW8Zs5/pK8sqyRtHfq1tL484a
         h4/YdSz4QYkA4r2qL80QzOhLK0FaaqiK7yAJBPM8TM61rvnNah8oSxQ0goHkRzRtF/
         cHJuixrglGMjaQQLIxRTC0g79zuOw5fp1SU/+OruMjmcHmhf8U6gM/fsg22heJhMvj
         hzMFzf8W/ql0roCuVycvGjiPx+Yj4hSar/UB8z7/l8fHAXRjrVIejJQC69AZBADcbJ
         3e27C69pSFWXFGwOgklh7STNJogYnfK15iOYwIrbvIVeRh7SPfsKj9WyesIy2CTcd4
         ZXVNsZW1Uk+fA==
Date:   Thu, 8 Dec 2022 10:50:08 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Major Saheb <majosaheb@gmail.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhenzhong Duan <zhenzhong.duan@gmail.com>, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: vfio-pci rejects binding to devices having same pcie vendor id
 and device id
Message-ID: <20221208165008.GA1547952@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANBBZXPWe56VYJtzXdimEnkFgF+A=G15TXrd8Z5kBcUOGgHeRw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+cc VFIO folks and Zhenzhong (author of the commit you mention)]

On Thu, Dec 08, 2022 at 09:24:31PM +0530, Major Saheb wrote:
> I have a linux system running in kvm, with 6 qemu emulated NVMe
> drives, as expected all of them have the same PCIe Vendor ID and
> Device ID(VID: 0x1b36 DID: 0x0010).
>
> When I try to unbind them from the kernel NVMe driver and bind it to
> vfio-pci one by one, I am getting "write error: File exists" when I
> try to bind the 2nd(and other) drive to vfio-pci.
> 
> Kernel version
> 
> 5.15.0-56-generic #62-Ubuntu SMP Tue Nov 22 19:54:14 UTC 2022 x86_64
> x86_64 x86_64 GNU/Linux
> 
> lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme0n1 -> ../devices/pci0000:00/0000:00:03.0/nvme/nvme0/nvme0n1
> lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme1n1 -> ../devices/pci0000:00/0000:00:04.0/nvme/nvme1/nvme1n1
> lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme2n1 -> ../devices/pci0000:00/0000:00:05.0/nvme/nvme2/nvme2n1
> lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme3n1 -> ../devices/pci0000:00/0000:00:06.0/nvme/nvme3/nvme3n1
> lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme4n1 -> ../devices/pci0000:00/0000:00:07.0/nvme/nvme4/nvme4n1
> lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme5n1 -> ../devices/pci0000:00/0000:00:08.0/nvme/nvme5/nvme5n1
> 
> Steps for repro
> ubind nvme2 from kernel NVMe driver and bind it to vfio
> $ ls -l /sys/bus/pci/drivers/vfio-pci/
> lrwxrwxrwx 1 root root    0 Dec  8 13:04 0000:00:05.0 -> ../../../../devices/pci0000:00/0000:00:05.0
> --w------- 1 root root 4096 Dec  8 13:07 bind
> lrwxrwxrwx 1 root root    0 Dec  8 13:07 module -> ../../../../module/vfio_pci
> --w------- 1 root root 4096 Dec  8 13:04 new_id
> --w------- 1 root root 4096 Dec  8 13:07 remove_id
> --w------- 1 root root 4096 Dec  8 11:32 uevent
> --w------- 1 root root 4096 Dec  8 13:07 unbind
> 
> Unbind nvme3 from  kernel NVMe driver
> Try binding to vfio-pci
> # echo "0x1b36  0x0010" >  /sys/bus/pci/drivers/vfio-pci/new_id
> -bash: echo: write error: File exists
> 
> Not sure but this seems interesting
> https://github.com/torvalds/linux/commit/3853f9123c185eb4018f5ccd3cdda5968efb5e10#diff-625d2827bff96bb3a019fa705d99f0b89ec32f281c38a844457b3413d9172007
> 
> Can some help ?
