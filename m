Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECCB659BD4
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 21:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbiL3UHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 15:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiL3UHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 15:07:53 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2208F1AA29;
        Fri, 30 Dec 2022 12:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=MydDErlf0p2Elc8XRPiBelXsjalT5pPXeWspcIgHS68=; b=Ke6V2T929M654AAxtU5zc4tpPM
        4xY7vfOUjS5MZYcrIm9KqqEucgZ1WjCHHxyC+sShYDyaHnkA8ggGn169x0SUym3jpbnbHjV/lJJvW
        vxKPz3XK5wnebDlPAjHF2qbFE8OynZLrQqTGfU60wgPy8/ZYpiDQILeUkhfiGG2nczKSjFL6vVqEH
        7ME06c8qfxTA9toX6L64Rc2wuesFMfQvg0+W2pvMlRJ3I+iY+w9S80WuB1hVnmEglLMJYP41WWuEf
        K/0HNAtjvBb7sIA/aSlIzYjzbqKehmQwzVV2p7dn4jfOgbI143H7Y9ZVZ9Lh5KxoLo0GLRFLY6AeS
        fzr9lUGw==;
Received: from [2001:8b0:10b:5:ace3:8d6b:ae0:b73f] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pBLfK-00GwnQ-2m;
        Fri, 30 Dec 2022 20:07:43 +0000
Date:   Fri, 30 Dec 2022 20:07:44 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Major Saheb <majosaheb@gmail.com>
CC:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhenzhong Duan <zhenzhong.duan@gmail.com>
Subject: =?US-ASCII?Q?Re=3A_DMAR=3A_=5BDMA_Read_NO=5FPASID=5D_?= =?US-ASCII?Q?Request_device_=5B0b=3A00=2E0=5D_fault_?= =?US-ASCII?Q?addr_0xffffe000_=5Bfault_reason_0?= =?US-ASCII?Q?x06=5D_PTE_Read_access_is_not_set?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20221230192042.GA697217@bhelgaas>
References: <20221230192042.GA697217@bhelgaas>
Message-ID: <29F6A46D-FBE0-40E3-992B-2C5CC6CD59D7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30 December 2022 19:20:42 GMT, Bjorn Helgaas <helgaas@kernel=2Eorg> wro=
te:
>Hi Major,
>
>Thanks for the report!
>
>On Wed, Dec 21, 2022 at 08:38:46PM +0530, Major Saheb wrote:
>> I have an ubuntu guest running on kvm , and I am passing it 10 qemu
>> emulated nvme drives
>>     <iommu model=3D'intel'>
>>       <driver intremap=3D'on' eim=3D'on'/>
>>     </iommu>
>> <qemu:arg value=3D'pcie-root-port,id=3Dpcie-root-port%d,slot=3D%d'/>
>> <qemu:arg value=3D'nvme,drive=3DNVME%d,serial=3D%s_%d,id=3DNVME%d,bus=
=3Dpcie-root-port%d'/>
>>=20
>> kernel
>> Linux node-1 5=2E15=2E0-56-generic #62-Ubuntu SMP ----- x86_64 x86_64
>> x86_64 GNU/Linux
>>=20
>> kernel command line
>> intel_iommu=3Don
>>=20
>> I have attached these drives to vfio-pcie=2E
>>=20
>> when I try to send IO commands to these drives VIA a userspace nvme
>> driver using VFIO I get
>> [ 1474=2E752590] DMAR: DRHD: handling fault status reg 2
>> [ 1474=2E754463] DMAR: [DMA Read NO_PASID] Request device [0b:00=2E0]
>> fault addr 0xffffe000 [fault reason 0x06] PTE Read access is not set
>>=20
>> Can someone explain to me what's happening here ?
>
>I'm not an IOMMU expert, but I think the device (0b:00=2E0, I assume an
>nvme device) did a DMA read to 0xffffe000 (which looks suspiciously
>like a null pointer (-8192 off a null pointer)), and the IOMMU had no
>mapping for that address=2E

We tend to assign I/O virtual addresses from the top of the 4GiB address s=
pace and going downwards, so that could just be the first or second page ma=
pped=2E

>Can you point us to the userspace nvme driver?  I'm not a VFIO expert
>either, but I assume it uses something like a VFIO_IOMMU_MAP_DMA ioctl
>to map buffers and get IOVAs to give to the device?
>
>Can you collect a dmesg log and output of "sudo lspci -vv" for your
>guest?  Is this something that worked in the past and broke on a newer
>kernel?  It looks like you're using a 5=2E15 kernel; have you tried any
>newer kernels?
>
>Bjorn
