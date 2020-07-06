Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CC621555C
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 12:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgGFKQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 06:16:49 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:14888 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbgGFKQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 06:16:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1594030609; x=1625566609;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=y00OdWof8B7hX3dUalznp6ro8iF6vV1F6rc05AqrTuo=;
  b=FVZleZOIqP4m68NM+Hy+GuOBL8/TgVokmGKBl7P7yDQ7Mlp6pZ9l19jF
   gj767n9GpYqRNbqnBhM81gtsocXj9pfNLiRR3UdfFp884a2GOqKPQW9S5
   PRhERtMLMYs179LnxCXQ7HmzLAZl7XvaXDA0lsuDqs/WY/1KtnRE1TuIB
   w=;
IronPort-SDR: 1kq6ENwe75TG9tIJtksKVDAXdmE/a6qJF4ZtUjVWQ1Cc+NGiwCJji5z2yR4HeYrSZ+J0zJSphh
 IG1N1Qj8jLHw==
X-IronPort-AV: E=Sophos;i="5.75,318,1589241600"; 
   d="scan'208";a="40182548"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 06 Jul 2020 10:16:48 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 1CB19A0719;
        Mon,  6 Jul 2020 10:16:46 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 10:16:45 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.156) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 10:16:40 +0000
Subject: Re: [PATCH v4 10/18] nitro_enclaves: Add logic for enclave image load
 info
To:     Andra Paraschiv <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-11-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <817700cd-1db2-558b-ae62-fdb279bca6ed@amazon.de>
Date:   Mon, 6 Jul 2020 12:16:31 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-11-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.156]
X-ClientProxiedBy: EX13D31UWC002.ant.amazon.com (10.43.162.220) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.20 22:03, Andra Paraschiv wrote:
> Before setting the memory regions for the enclave, the enclave image
> needs to be placed in memory. After the memory regions are set, this
> memory cannot be used anymore by the VM, being carved out.
> =

> Add ioctl command logic to get the offset in enclave memory where to
> place the enclave image. Then the user space tooling copies the enclave
> image in the memory using the given memory offset.
> =

> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
> =

> v3 -> v4
> =

> * Use dev_err instead of custom NE log pattern.
> * Set enclave image load offset based on flags.
> * Update the naming for the ioctl command from metadata to info.
> =

> v2 -> v3
> =

> * No changes.
> =

> v1 -> v2
> =

> * New in v2.
> ---
>   drivers/virt/nitro_enclaves/ne_misc_dev.c | 25 +++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
> =

> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nit=
ro_enclaves/ne_misc_dev.c
> index d6777008f685..cfdefa52ed2a 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -536,6 +536,31 @@ static long ne_enclave_ioctl(struct file *file, unsi=
gned int cmd,
>   		return rc;
>   	}
>   =

> +	case NE_GET_IMAGE_LOAD_INFO: {
> +		struct ne_image_load_info image_load_info =3D {};
> +
> +		if (copy_from_user(&image_load_info, (void *)arg,
> +				   sizeof(image_load_info))) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Error in copy from user\n");

The -EFAULT tells you all you need. Just remove this print.

> +
> +			return -EFAULT;
> +		}
> +
> +		if (image_load_info.flags =3D=3D NE_EIF_IMAGE)
> +			image_load_info.memory_offset =3D NE_EIF_LOAD_OFFSET;
> +
> +		if (copy_to_user((void *)arg, &image_load_info,
> +				 sizeof(image_load_info))) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Error in copy to user\n");

Same here.


Alex

> +
> +			return -EFAULT;
> +		}
> +
> +		return 0;
> +	}
> +
>   	default:
>   		return -ENOTTY;
>   	}
> =




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



