Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D596420891
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 15:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfEPNu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 09:50:28 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:23312 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfEPNu2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 09:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1558014627; x=1589550627;
  h=subject:to:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding;
  bh=JOuNpojcOraO39wt6wtg3pPIWv2HnVSSFGiVGtHt9l8=;
  b=WcewTOwALML73elL0hc9mJgtCi2I90JhH85yN4DCcBjPZDtn//38zjRt
   q2HG0320gSL0awkSFG/ce0etAE5PB60dM83h53ZYUrm/3GBJnq8HvjzCi
   arr7x/GCZyAHyDUZbtGJ2K+tcFNNka5VuQyWc8YNxykOx3XpOiO8pg9GZ
   g=;
X-IronPort-AV: E=Sophos;i="5.60,476,1549929600"; 
   d="scan'208";a="800005507"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 16 May 2019 13:50:25 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x4GDoOfG043830
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 May 2019 13:50:24 GMT
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 16 May 2019 13:50:23 +0000
Received: from macbook-2.local (10.43.161.34) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 16 May
 2019 13:50:23 +0000
Subject: Re: [PATCH v2 1/2] KVM: Start populating /sys/hypervisor with KVM
 entries
To:     Filippo Sironi <sironi@amazon.de>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <borntraeger@de.ibm.com>,
        <boris.ostrovsky@oracle.com>, <cohuck@redhat.com>,
        <konrad.wilk@oracle.com>, <xen-devel@lists.xenproject.org>,
        <vasu.srinivasan@oracle.com>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-2-git-send-email-sironi@amazon.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <e976f31b-2ccd-29ba-6a32-2edde49f867f@amazon.com>
Date:   Thu, 16 May 2019 06:50:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1557847002-23519-2-git-send-email-sironi@amazon.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D06UWC002.ant.amazon.com (10.43.162.205) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.05.19 08:16, Filippo Sironi wrote:
> Start populating /sys/hypervisor with KVM entries when we're running on
> KVM. This is to replicate functionality that's available when we're
> running on Xen.
> 
> Start with /sys/hypervisor/uuid, which users prefer over
> /sys/devices/virtual/dmi/id/product_uuid as a way to recognize a virtual
> machine, since it's also available when running on Xen HVM and on Xen PV
> and, on top of that doesn't require root privileges by default.
> Let's create arch-specific hooks so that different architectures can
> provide different implementations.
> 
> Signed-off-by: Filippo Sironi <sironi@amazon.de>

I think this needs something akin to

  https://www.kernel.org/doc/Documentation/ABI/stable/sysfs-hypervisor-xen

to document which files are available.

> ---
> v2:
> * move the retrieval of the VM UUID out of uuid_show and into
>   kvm_para_get_uuid, which is a weak function that can be overwritten
> 
>  drivers/Kconfig              |  2 ++
>  drivers/Makefile             |  2 ++
>  drivers/kvm/Kconfig          | 14 ++++++++++++++
>  drivers/kvm/Makefile         |  1 +
>  drivers/kvm/sys-hypervisor.c | 30 ++++++++++++++++++++++++++++++
>  5 files changed, 49 insertions(+)
>  create mode 100644 drivers/kvm/Kconfig
>  create mode 100644 drivers/kvm/Makefile
>  create mode 100644 drivers/kvm/sys-hypervisor.c
> 

[...]

> +
> +__weak const char *kvm_para_get_uuid(void)
> +{
> +	return NULL;
> +}
> +
> +static ssize_t uuid_show(struct kobject *obj,
> +			 struct kobj_attribute *attr,
> +			 char *buf)
> +{
> +	const char *uuid = kvm_para_get_uuid();
> +	return sprintf(buf, "%s\n", uuid);

The usual return value for the Xen /sys/hypervisor interface is
"<denied>". Wouldn't it make sense to follow that pattern for the KVM
one too? Currently, if we can not determine the UUID this will just
return (null).

Otherwise, looks good to me. Are you aware of any other files we should
provide? Also, is there any reason not to implement ARM as well while at it?

Alex

> +}
> +
> +static struct kobj_attribute uuid = __ATTR_RO(uuid);
> +
> +static int __init uuid_init(void)
> +{
> +	if (!kvm_para_available())
> +		return 0;
> +	return sysfs_create_file(hypervisor_kobj, &uuid.attr);
> +}
> +
> +device_initcall(uuid_init);
> 

