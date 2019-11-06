Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E189F0BE2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 03:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730857AbfKFCDD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 5 Nov 2019 21:03:03 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:55442 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730231AbfKFCDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 21:03:03 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 878439DA6527DF043BB5;
        Wed,  6 Nov 2019 10:03:00 +0800 (CST)
Received: from dggeme715-chm.china.huawei.com (10.1.199.111) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 10:02:59 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme715-chm.china.huawei.com (10.1.199.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 6 Nov 2019 10:02:59 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 6 Nov 2019 10:03:00 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hexin.op@gmail.com" <hexin.op@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] VFIO: PCI: eliminate unnecessary overhead in
 vfio_pci_reflck_find
Thread-Topic: [PATCH] VFIO: PCI: eliminate unnecessary overhead in
 vfio_pci_reflck_find
Thread-Index: AdWURS5mwA5JtK5eSWyCE0M2SPL1fw==
Date:   Wed, 6 Nov 2019 02:02:59 +0000
Message-ID: <1f2dd537556548ed8e1de9df9eb130c5@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Wed, 6 Nov 2019 03:25
Alex Williamson wrote
>> From: Miaohe Lin <linmiaohe@huawei.com>
>> 
>> The driver of the pci device may not equal to vfio_pci_driver, but we 
>> fetch vfio_device from pci_dev unconditionally in func 
>> vfio_pci_reflck_find. This overhead, such as the competition of 
>> vfio.group_lock, can be eliminated by check pci_dev_driver with 
>> vfio_pci_driver first.
>> 
>
>I believe this introduces a race.  When we hold a reference to the vfio device, an unbind from a vfio bus driver will be blocked in vfio_del_group_dev().  Therefore if we test the driver is vfio-pci while holding this reference, we know that it cannot be released and the device_data is a valid vfio_pci_device. Testing the driver prior to acquiring a vfio device reference is meaningless as we have no guarantee that the driver has not changed by the time we acquire a reference.  Are you actually seeing contention here or was this a code inspection optimization?  Thanks,
>
>Alex

Thanks for your reply and patient explanation.  It was a code inspection optimization, and obviously, I missed something. I'm really sorry about that.

Best wishes.
Have a nice day.
