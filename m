Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A873375FF5
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 07:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhEGF6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 01:58:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17138 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbhEGF6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 01:58:31 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fc04j1xbLzqSvh;
        Fri,  7 May 2021 13:53:57 +0800 (CST)
Received: from [10.67.77.175] (10.67.77.175) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Fri, 7 May 2021
 13:57:04 +0800
To:     <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC:     Marc Zyngier <maz@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Nianyao Tang <tangnianyao@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: Question on guest enable msi fail when using GICv4/4.1
Message-ID: <3a2c66d6-6ca0-8478-d24b-61e8e3241b20@hisilicon.com>
Date:   Fri, 7 May 2021 13:57:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.77.175]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[This letter comes from Nianyao Tang]

Hi,

Using GICv4/4.1 and msi capability, guest vf driver requires 3 vectors and enable msi, will lead to
guest stuck. Qemu gets number of interrupts from Multiple Message Capable field set by guest. This
field is aligned to a power of 2(if a function requires 3 vectors, it initializes it to 2).
However, guest driver just sends 3 mapi-cmd to vits and 3 ite entries is recorded in host.
Vfio initializes msi interrupts using the number of interrupts 4 provide by qemu.
When it comes to the 4th msi without ite in vits, in irq_bypass_register_producer, producer
and consumer will __connect fail, due to find_ite fail, and do not resume guest.

Do we support this case, Guest function using msi interrupts number not aligned to a power of 2?
Or qemu should provide correct msi interrupts number?

Thanks,
Shaokun
