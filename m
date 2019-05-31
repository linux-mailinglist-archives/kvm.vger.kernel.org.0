Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9B030B12
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 11:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfEaJGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 05:06:22 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:53594 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbfEaJGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 05:06:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559293581; x=1590829581;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=IUMbb8sG3OoGniCTVKK5CLJC3zT+OvvZpa9d+vLzxDc=;
  b=GWmhBh1EqDB4YNTE9mKCS3afHxFFUVasT1HgblRnGrEG4DnDDWMqPD1C
   iJm/O8j1RQf5KwQGxQK5sq24SV2u54eAgb+EE9ngHFlyrBsev/LpqKgdu
   TBkH7ewLw06Cg7/xPXwlMS4J6RtlRlK6BBYjRV+wBQCPhwXm1NF11/Aar
   Q=;
X-IronPort-AV: E=Sophos;i="5.60,534,1549929600"; 
   d="scan'208";a="735510243"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 31 May 2019 09:06:19 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id AFEBFA2211;
        Fri, 31 May 2019 09:06:18 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 May 2019 09:06:18 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.74) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 May 2019 09:06:15 +0000
Subject: Re: [PATCH v2 1/2] KVM: Start populating /sys/hypervisor with KVM
 entries
To:     "Sironi, Filippo" <sironi@amazon.de>
CC:     LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "Marc Zyngier" <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-2-git-send-email-sironi@amazon.de>
 <e976f31b-2ccd-29ba-6a32-2edde49f867f@amazon.com>
 <3D2C4EE3-1C2E-4032-9964-31A066E542AA@amazon.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <6b3dadf9-6240-6440-b784-50bec605bf2c@amazon.com>
Date:   Fri, 31 May 2019 11:06:13 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <3D2C4EE3-1C2E-4032-9964-31A066E542AA@amazon.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.162.74]
X-ClientProxiedBy: EX13D02UWB001.ant.amazon.com (10.43.161.240) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 17.05.19 17:41, Sironi, Filippo wrote:
>> On 16. May 2019, at 15:50, Graf, Alexander <graf@amazon.com> wrote:
>>
>> On 14.05.19 08:16, Filippo Sironi wrote:
>>> Start populating /sys/hypervisor with KVM entries when we're running on
>>> KVM. This is to replicate functionality that's available when we're
>>> running on Xen.
>>>
>>> Start with /sys/hypervisor/uuid, which users prefer over
>>> /sys/devices/virtual/dmi/id/product_uuid as a way to recognize a virtual
>>> machine, since it's also available when running on Xen HVM and on Xen PV
>>> and, on top of that doesn't require root privileges by default.
>>> Let's create arch-specific hooks so that different architectures can
>>> provide different implementations.
>>>
>>> Signed-off-by: Filippo Sironi <sironi@amazon.de>
>> I think this needs something akin to
>>
>>   https://www.kernel.org/doc/Documentation/ABI/stable/sysfs-hypervisor-xen
>>
>> to document which files are available.
>>
>>> ---
>>> v2:
>>> * move the retrieval of the VM UUID out of uuid_show and into
>>>   kvm_para_get_uuid, which is a weak function that can be overwritten
>>>
>>> drivers/Kconfig              |  2 ++
>>> drivers/Makefile             |  2 ++
>>> drivers/kvm/Kconfig          | 14 ++++++++++++++
>>> drivers/kvm/Makefile         |  1 +
>>> drivers/kvm/sys-hypervisor.c | 30 ++++++++++++++++++++++++++++++
>>> 5 files changed, 49 insertions(+)
>>> create mode 100644 drivers/kvm/Kconfig
>>> create mode 100644 drivers/kvm/Makefile
>>> create mode 100644 drivers/kvm/sys-hypervisor.c
>>>
>> [...]
>>
>>> +
>>> +__weak const char *kvm_para_get_uuid(void)
>>> +{
>>> +	return NULL;
>>> +}
>>> +
>>> +static ssize_t uuid_show(struct kobject *obj,
>>> +			 struct kobj_attribute *attr,
>>> +			 char *buf)
>>> +{
>>> +	const char *uuid = kvm_para_get_uuid();
>>> +	return sprintf(buf, "%s\n", uuid);
>> The usual return value for the Xen /sys/hypervisor interface is
>> "<denied>". Wouldn't it make sense to follow that pattern for the KVM
>> one too? Currently, if we can not determine the UUID this will just
>> return (null).
>>
>> Otherwise, looks good to me. Are you aware of any other files we should
>> provide? Also, is there any reason not to implement ARM as well while at it?
>>
>> Alex
> This originated from a customer request that was using /sys/hypervisor/uuid.
> My guess is that we would want to expose "type" and "version" moving
> forward and that's when we hypervisor hooks will be useful on top
> of arch hooks.
>
> On a different note, any idea how to check whether the OS is running
> virtualized on KVM on ARM and ARM64?  kvm_para_available() isn't an


Yeah, ARM doesn't have any KVM PV FWIW. I also can't find any explicit 
hint passed into guests that we are indeed running in KVM. The closest 
thing I can see is the SMBIOS product identifier in QEMU which gets 
patched to "KVM Virtual Machine". Maybe we'll have to do with that for 
the sake of backwards compatibility ...


> option and the same is true for S390 where kvm_para_available()
> always returns true and it would even if a KVM enabled kernel would
> be running on bare metal.


For s390, you can figure the topology out using the sthyi instruction. 
I'm not sure if there is a nice in-kernel API to leverage that though. 
In fact, kvm_para_available() probably should check sthyi output to 
determine whether we really can use it, no? Christian?


Alex


>
> I think we will need another arch hook to call a function that says
> whether the OS is running virtualized on KVM.
>
>>> +}
>>> +
>>> +static struct kobj_attribute uuid = __ATTR_RO(uuid);
>>> +
>>> +static int __init uuid_init(void)
>>> +{
>>> +	if (!kvm_para_available())
>>> +		return 0;
>>> +	return sysfs_create_file(hypervisor_kobj, &uuid.attr);
>>> +}
>>> +
>>> +device_initcall(uuid_init);
