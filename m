Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9431379DEA
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 05:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhEKDqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 23:46:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2768 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEKDqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 23:46:03 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FfNy762Z9zmg73;
        Tue, 11 May 2021 11:41:35 +0800 (CST)
Received: from [127.0.0.1] (10.69.38.196) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Tue, 11 May 2021
 11:44:49 +0800
Subject: Re: [Question] Indefinitely block in the host when remove the PF
 driver
To:     Alex Williamson <alex.williamson@redhat.com>,
        <qemu-devel@nongnu.org>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Linuxarm <linuxarm@huawei.com>
References: <c9466e2c-385d-8298-d03c-80dcfc359f52@hisilicon.com>
 <20210430082940.4b0e0397@redhat.com>
From:   Yicong Yang <yangyicong@hisilicon.com>
Message-ID: <c09fed39-bde5-b7a9-d945-79ef85260e5a@hisilicon.com>
Date:   Tue, 11 May 2021 11:44:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210430082940.4b0e0397@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.38.196]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ +qemu-devel ]

On 2021/4/30 22:29, Alex Williamson wrote:
> On Fri, 30 Apr 2021 15:57:47 +0800
> Yicong Yang <yangyicong@hisilicon.com> wrote:
> 
>> When I try to remove the PF driver in the host, the process will be blocked
>> if the related VF of the device is added in the Qemu as an iEP.
>>
>> here's what I got in the host:
>>
>> [root@localhost 0000:75:00.0]# rmmod hisi_zip
>> [99760.571352] vfio-pci 0000:75:00.1: Relaying device request to user (#0)
>> [99862.992099] vfio-pci 0000:75:00.1: Relaying device request to user (#10)
>> [...]
>>
>> and in the Qemu:
>>
>> estuary:/$ lspci -tv
>> -[0000:00]-+-00.0  Device 1b36:0008
>>            +-01.0  Device 1af4:1000
>>            +-02.0  Device 1af4:1009
>>            \-03.0  Device 19e5:a251 <----- the related VF device
>> estuary:/$ qemu-system-aarch64: warning: vfio 0000:75:00.1: Bus 'pcie.0' does not support hotplugging
>> qemu-system-aarch64: warning: vfio 0000:75:00.1: Bus 'pcie.0' does not support hotplugging
>> qemu-system-aarch64: warning: vfio 0000:75:00.1: Bus 'pcie.0' does not support hotplugging
>> qemu-system-aarch64: warning: vfio 0000:75:00.1: Bus 'pcie.0' does not support hotplugging
>> [...]
>>
>> The rmmod process will be blocked until I kill the Qemu process. That's the only way if I
>> want to end the rmmod.
>>
>> So my question is: is such block reasonable? If the VF devcie is occupied or doesn't
>> support hotplug in the Qemu, shouldn't we fail the rmmod and return something like -EBUSY
>> rather than make the host blocked indefinitely?
> 
> Where would we return -EBUSY?  pci_driver.remove() returns void.
> Without blocking, I think our only option would be to kill the user
> process.
>  

yes. the remove() callback of pci_driver doesn't provide a way to abort the process.

>> Add the VF under a pcie root port will avoid this. Is it encouraged to always
>> add the VF under a pcie root port rather than directly add it as an iEP?
> 
> Releasing a device via the vfio request interrupt is always a
> cooperative process currently, the VM needs to be configured such that
> the device is capable of being unplugged and the guest needs to respond
> to the ejection request.  Thanks,
> 

Does it make sense to abort the VM creation and give some warnings if user try to
pass a vfio pci device to the Qemu and doesn't attach it to a hotpluggable
bridge? Currently I think there isn't such a mechanism in Qemu.

Thanks,
Yicong

