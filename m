Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A046D24181C
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 10:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgHKIRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 04:17:34 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:37290 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728254AbgHKIRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 04:17:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597133854; x=1628669854;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=v7JpzSx2FavY0/FUZq+eRVDiZaVL9bvJQqJgwlhhNNE=;
  b=rbxFIy2znfTIJbJ0aWVlNAQiyXOI36mRzAXGyTzBiw3lm0YB5/Wt2CwE
   s16l6eWqnG0KzBs8xTqfukdbo8zyCaBvvbw+XnP19HBfkdL5W9vxPlX10
   ADmZOGqPP+q3Vt5TnrUpykSbwqEtcpkfKF4n7G/BOhqXCN2WAMDIJQuBn
   U=;
IronPort-SDR: Ey/6A3yszZrQ8q8Gt+ljZsEc9sDOwZJ+JqPqCHuxy4ESyl3Jtmd8SjRfWjD9KPWOEZx/crBSVu
 SbxzvYQtSDZQ==
X-IronPort-AV: E=Sophos;i="5.75,460,1589241600"; 
   d="scan'208";a="65828774"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 11 Aug 2020 08:17:32 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 48EF1A21D7;
        Tue, 11 Aug 2020 08:17:31 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 11 Aug 2020 08:16:34 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.156) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 11 Aug 2020 08:16:25 +0000
Subject: Re: [PATCH v6 08/18] nitro_enclaves: Add logic for creating an
 enclave VM
To:     Alexander Graf <graf@amazon.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "David Duncan" <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Karen Noel <knoel@redhat.com>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20200805091017.86203-1-andraprs@amazon.com>
 <20200805091017.86203-9-andraprs@amazon.com>
 <77f71395-d7ba-f198-56dc-3b0a954a98de@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <666a72eb-0170-ea53-d8f6-6fb71835cd4e@amazon.com>
Date:   Tue, 11 Aug 2020 11:16:20 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.0
MIME-Version: 1.0
In-Reply-To: <77f71395-d7ba-f198-56dc-3b0a954a98de@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.160.156]
X-ClientProxiedBy: EX13D37UWA004.ant.amazon.com (10.43.160.23) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/08/2020 09:11, Alexander Graf wrote:
>
>
> On 05.08.20 11:10, Andra Paraschiv wrote:
>> Add ioctl command logic for enclave VM creation. It triggers a slot
>> allocation. The enclave resources will be associated with this slot and
>> it will be used as an identifier for triggering enclave run.
>>
>> Return a file descriptor, namely enclave fd. This is further used by the
>> associated user space enclave process to set enclave resources and
>> trigger enclave termination.
>>
>> The poll function is implemented in order to notify the enclave process
>> when an enclave exits without a specific enclave termination command
>> trigger e.g. when an enclave crashes.
>>
>> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>> Reviewed-by: Alexander Graf <graf@amazon.com>
>> ---
>> Changelog
>>
>> v5 -> v6
>>
>> * Update the code base to init the ioctl function in this patch.
>> * Update documentation to kernel-doc format.
>>
>> v4 -> v5
>>
>> * Release the reference to the NE PCI device on create VM error.
>> * Close enclave fd on copy_to_user() failure; rename fd to enclave fd
>> =A0=A0 while at it.
>> * Remove sanity checks for situations that shouldn't happen, only if
>> =A0=A0 buggy system or broken logic at all.
>> * Remove log on copy_to_user() failure.
>>
>> v3 -> v4
>>
>> * Use dev_err instead of custom NE log pattern.
>> * Update the NE ioctl call to match the decoupling from the KVM API.
>> * Add metadata for the NUMA node for the enclave memory and CPUs.
>>
>> v2 -> v3
>>
>> * Remove the WARN_ON calls.
>> * Update static calls sanity checks.
>> * Update kzfree() calls to kfree().
>> * Remove file ops that do nothing for now - open.
>>
>> v1 -> v2
>>
>> * Add log pattern for NE.
>> * Update goto labels to match their purpose.
>> * Remove the BUG_ON calls.
>> ---
>> =A0 drivers/virt/nitro_enclaves/ne_misc_dev.c | 229 ++++++++++++++++++++=
++
>> =A0 1 file changed, 229 insertions(+)
>>
>> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c =

>> b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> index 472850250220..6c8c12f65666 100644
>> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>
> [...]
>
>> +/**
>> + * ne_ioctl() - Ioctl function provided by the NE misc device.
>> + * @file:=A0=A0=A0 File associated with this ioctl function.
>> + * @cmd:=A0=A0=A0 The command that is set for the ioctl call.
>> + * @arg:=A0=A0=A0 The argument that is provided for the ioctl call.
>> + *
>> + * Context: Process context.
>> + * Return:
>> + * * Ioctl result (e.g. enclave file descriptor) on success.
>> + * * Negative return value on failure.
>> + */
>> +static long ne_ioctl(struct file *file, unsigned int cmd, unsigned =

>> long arg)
>> +{
>> +=A0=A0=A0 switch (cmd) {
>> +=A0=A0=A0 case NE_CREATE_VM: {
>> +=A0=A0=A0=A0=A0=A0=A0 int enclave_fd =3D -1;
>> +=A0=A0=A0=A0=A0=A0=A0 struct file *enclave_file =3D NULL;
>> +=A0=A0=A0=A0=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D NULL;
>> +=A0=A0=A0=A0=A0=A0=A0 /* TODO: Find another way to get the NE PCI devic=
e =

>> reference. */
>> +=A0=A0=A0=A0=A0=A0=A0 struct pci_dev *pdev =3D pci_get_device(PCI_VENDO=
R_ID_AMAZON,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 PCI_DEVICE_ID_NE, NULL);
>
> This should go away if you set misc_dev.parent.
>
>> +=A0=A0=A0=A0=A0=A0=A0 int rc =3D -EINVAL;
>> +=A0=A0=A0=A0=A0=A0=A0 u64 slot_uid =3D 0;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 ne_pci_dev =3D pci_get_drvdata(pdev);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 mutex_lock(&ne_pci_dev->enclaves_list_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 enclave_fd =3D ne_create_vm_ioctl(pdev, ne_pci_de=
v, &slot_uid);
>> +=A0=A0=A0=A0=A0=A0=A0 if (enclave_fd < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D enclave_fd;
>> +
>> + mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pci_dev_put(pdev);
>
> This should also disappear.

Correct. I'll follow the misc dev parent approach to get the PCI device =

and include all the necessary code base updates in v7.

Thanks,
Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

