Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EB92158A2
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 15:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbgGFNgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 09:36:21 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:47682 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729286AbgGFNgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 09:36:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594042580; x=1625578580;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=2i10p3zHZtcsjkGHAB08tLjw+aVWWu3Y8lozHTN4nT4=;
  b=fgGjNz476DaX64NiLwtNO4Bg6y6hbcF/PUW8H76UhiDE0Au2RWLrNNGd
   XtRT02LZ9aepgdlv7hTZlhYFtYPRjg5jkT1GKdySZ5/4tRh9az7MdM2UK
   /t8jnwqQdeQo5aZ/+P6qTLhmsF7QH4MceubEpbaxN7cG1C5T7fV81PYTV
   o=;
IronPort-SDR: csDJiQyAkPskSeMUpPzF9fAUTAf4fh+mx6xOBL18dP1Zb4OYcfjJ1z+U4xy36E64H9kombM0A3
 pZiFB/GlFtmg==
X-IronPort-AV: E=Sophos;i="5.75,320,1589241600"; 
   d="scan'208";a="41679877"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 06 Jul 2020 13:35:50 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 89A01A15CA;
        Mon,  6 Jul 2020 13:35:47 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 13:35:46 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.26) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 13:35:37 +0000
Subject: Re: [PATCH v4 10/18] nitro_enclaves: Add logic for enclave image load
 info
To:     Alexander Graf <graf@amazon.de>, <linux-kernel@vger.kernel.org>
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
 <817700cd-1db2-558b-ae62-fdb279bca6ed@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <e72d3477-50f0-2a92-ac1d-0ad66dd35170@amazon.com>
Date:   Mon, 6 Jul 2020 16:35:27 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <817700cd-1db2-558b-ae62-fdb279bca6ed@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D16UWB002.ant.amazon.com (10.43.161.234) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/07/2020 13:16, Alexander Graf wrote:
>
>
> On 22.06.20 22:03, Andra Paraschiv wrote:
>> Before setting the memory regions for the enclave, the enclave image
>> needs to be placed in memory. After the memory regions are set, this
>> memory cannot be used anymore by the VM, being carved out.
>>
>> Add ioctl command logic to get the offset in enclave memory where to
>> place the enclave image. Then the user space tooling copies the enclave
>> image in the memory using the given memory offset.
>>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>> ---
>> Changelog
>>
>> v3 -> v4
>>
>> * Use dev_err instead of custom NE log pattern.
>> * Set enclave image load offset based on flags.
>> * Update the naming for the ioctl command from metadata to info.
>>
>> v2 -> v3
>>
>> * No changes.
>>
>> v1 -> v2
>>
>> * New in v2.
>> ---
>> =A0 drivers/virt/nitro_enclaves/ne_misc_dev.c | 25 +++++++++++++++++++++=
++
>> =A0 1 file changed, 25 insertions(+)
>>
>> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c =

>> b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> index d6777008f685..cfdefa52ed2a 100644
>> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> @@ -536,6 +536,31 @@ static long ne_enclave_ioctl(struct file *file, =

>> unsigned int cmd,
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 return rc;
>> =A0=A0=A0=A0=A0 }
>> =A0 +=A0=A0=A0 case NE_GET_IMAGE_LOAD_INFO: {
>> +=A0=A0=A0=A0=A0=A0=A0 struct ne_image_load_info image_load_info =3D {};
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (copy_from_user(&image_load_info, (void *)arg,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(image_loa=
d_info))) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_=
device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
Error in copy from user\n");
>
> The -EFAULT tells you all you need. Just remove this print.

Removed the log from here and the other occurrences in the patch series.

Thanks,
Andra

>
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EFAULT;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (image_load_info.flags =3D=3D NE_EIF_IMAGE)
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 image_load_info.memory_offset =3D NE_=
EIF_LOAD_OFFSET;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (copy_to_user((void *)arg, &image_load_info,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(image_load_info=
))) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_=
device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
Error in copy to user\n");
>
> Same here.
>
>
> Alex
>
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EFAULT;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return 0;
>> +=A0=A0=A0 }
>> +
>> =A0=A0=A0=A0=A0 default:
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENOTTY;
>> =A0=A0=A0=A0=A0 }
>>




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

