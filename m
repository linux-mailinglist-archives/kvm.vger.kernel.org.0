Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0AB2091E
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 16:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfEPOIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 10:08:20 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:6509 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfEPOIU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 10:08:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1558015698; x=1589551698;
  h=subject:to:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding;
  bh=6AsMPu5n7/xRBGeC8coqQ6zOLFCMjhjLX1aaMredl0k=;
  b=mPSmqab5dSEFK8tno9rFh8ca7PhUYtvYaO1ylJecA0QfeTQPA///Hf4w
   FBtc2MDZBo/BIOGVPR5elZi5REOBv53bweRgDYjbCnYCA6l9Yz+tHCghk
   IBkMoQ+cOyH+FbL4BPg4/QCEbJ6UtfmptHSnunmL45VQt0P2aksINyPyf
   c=;
X-IronPort-AV: E=Sophos;i="5.60,476,1549929600"; 
   d="scan'208";a="805009174"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 16 May 2019 14:08:16 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x4GE8EcT105508
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 May 2019 14:08:15 GMT
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 16 May 2019 14:08:15 +0000
Received: from macbook-2.local (10.43.161.34) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 16 May
 2019 14:08:14 +0000
Subject: Re: [Xen-devel] [PATCH v2 1/2] KVM: Start populating /sys/hypervisor
 with KVM entries
To:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Filippo Sironi <sironi@amazon.de>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <borntraeger@de.ibm.com>, <boris.ostrovsky@oracle.com>,
        <cohuck@redhat.com>, <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-2-git-send-email-sironi@amazon.de>
 <e976f31b-2ccd-29ba-6a32-2edde49f867f@amazon.com>
 <7aae3e49-5b1c-96d1-466e-5b061305dc9d@citrix.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <22fadfb1-e48d-ccb6-0e42-c105b7335d7a@amazon.com>
Date:   Thu, 16 May 2019 07:08:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <7aae3e49-5b1c-96d1-466e-5b061305dc9d@citrix.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D27UWB002.ant.amazon.com (10.43.161.167) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 16.05.19 07:02, Andrew Cooper wrote:
> On 16/05/2019 14:50, Alexander Graf wrote:
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
>>>  drivers/Kconfig              |  2 ++
>>>  drivers/Makefile             |  2 ++
>>>  drivers/kvm/Kconfig          | 14 ++++++++++++++
>>>  drivers/kvm/Makefile         |  1 +
>>>  drivers/kvm/sys-hypervisor.c | 30 ++++++++++++++++++++++++++++++
>>>  5 files changed, 49 insertions(+)
>>>  create mode 100644 drivers/kvm/Kconfig
>>>  create mode 100644 drivers/kvm/Makefile
>>>  create mode 100644 drivers/kvm/sys-hypervisor.c
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
>> "<denied>".
> This string comes straight from Xen.
>
> It was an effort to reduce the quantity of interesting fingerprintable
> data accessable by default to unprivileged guests.
>
> See
> https://xenbits.xen.org/gitweb/?p=xen.git;a=commitdiff;h=a2fc8d514df2b38c310d4f4432fe06520b0769ed


What a great design :). My point is mostly that we should be as common
as possible when it comes to /sys/hypervisor, so that tools don't have
to care about the HV they're working against.

By being first to implement <denied> you just created precedence, so we
can either simulate the same behavor for KVM or be different. And since
commonality is good, I'd rather be the same.

That said, I couldn't find in the patdch above whether Xen even emits
<denied> for the uuid. Does it have that capability? If not, we may as
well go with (null).


Alex


