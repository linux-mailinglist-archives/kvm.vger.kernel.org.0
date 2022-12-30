Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0966659B98
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 20:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiL3TUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 14:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiL3TUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 14:20:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8401AD;
        Fri, 30 Dec 2022 11:20:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5435F617E7;
        Fri, 30 Dec 2022 19:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743FEC433D2;
        Fri, 30 Dec 2022 19:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672428044;
        bh=Cxa5GqF/BRtwNF5TaYSaNDpv5IAthq89suBzSJ+3K7M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=EzH8bQtz1p233ZKnVT7fTbeQdIXJIcXX/9dnP+bh/ZHMizYBrKXaHr959KqPynimq
         dhDZoB+7fVkswDr0N5GS8S2udsbkiNBz+R4r5pA5h2989RC7Ry349pLa6L2m0c19jD
         BigBzoqQxAfF5aPdQWhm43NaOUJPIMmpWQskRFZ2IvU8nlkOnL5RQSj61oYdtKE5iJ
         y4zowa9xdfizrTufduLMET/jEQHg8xWZ6GzwbI77eSPEkWIyafjFhNPzn6oioDR8my
         J/3QIYaezxAtX+4SpSh1I67aU78Bclx8moMzicg20H3EaSJt6/A0L6vggwRk3FucIF
         ZAjNXispShBNg==
Date:   Fri, 30 Dec 2022 13:20:42 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Major Saheb <majosaheb@gmail.com>
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhenzhong Duan <zhenzhong.duan@gmail.com>
Subject: Re: DMAR: [DMA Read NO_PASID] Request device [0b:00.0] fault addr
 0xffffe000 [fault reason 0x06] PTE Read access is not set
Message-ID: <20221230192042.GA697217@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANBBZXNCaZx9fmHsre2mF2yr7Ru66BSEZxFT7ou=Y04zv5a8Zw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Major,

Thanks for the report!

On Wed, Dec 21, 2022 at 08:38:46PM +0530, Major Saheb wrote:
> I have an ubuntu guest running on kvm , and I am passing it 10 qemu
> emulated nvme drives
>     <iommu model='intel'>
>       <driver intremap='on' eim='on'/>
>     </iommu>
> <qemu:arg value='pcie-root-port,id=pcie-root-port%d,slot=%d'/>
> <qemu:arg value='nvme,drive=NVME%d,serial=%s_%d,id=NVME%d,bus=pcie-root-port%d'/>
> 
> kernel
> Linux node-1 5.15.0-56-generic #62-Ubuntu SMP ----- x86_64 x86_64
> x86_64 GNU/Linux
> 
> kernel command line
> intel_iommu=on
> 
> I have attached these drives to vfio-pcie.
> 
> when I try to send IO commands to these drives VIA a userspace nvme
> driver using VFIO I get
> [ 1474.752590] DMAR: DRHD: handling fault status reg 2
> [ 1474.754463] DMAR: [DMA Read NO_PASID] Request device [0b:00.0]
> fault addr 0xffffe000 [fault reason 0x06] PTE Read access is not set
> 
> Can someone explain to me what's happening here ?

I'm not an IOMMU expert, but I think the device (0b:00.0, I assume an
nvme device) did a DMA read to 0xffffe000 (which looks suspiciously
like a null pointer (-8192 off a null pointer)), and the IOMMU had no
mapping for that address.

Can you point us to the userspace nvme driver?  I'm not a VFIO expert
either, but I assume it uses something like a VFIO_IOMMU_MAP_DMA ioctl
to map buffers and get IOVAs to give to the device?

Can you collect a dmesg log and output of "sudo lspci -vv" for your
guest?  Is this something that worked in the past and broke on a newer
kernel?  It looks like you're using a 5.15 kernel; have you tried any
newer kernels?

Bjorn
