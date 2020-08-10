Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A692401E1
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 08:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgHJGL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 02:11:27 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:25669 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgHJGL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 02:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1597039887; x=1628575887;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=VLIsbXo3BKP5K1zwOJwdSKxO3DWi4xDxkgNQMqNu+WE=;
  b=BfIoXKsNbb1ZUM3+wclz9Q+v0Ufuax78HOf06CQuFVokGoSvnuoaBQ/F
   MT9OZg24nkXcD0XeV8g/jw2I6/1Ns49FMAD/ECAyEDmm9ua/98J16ZKcc
   9YodhB0rsyu5eNjRTQNRVD7oHNJV2IxJ/ygp2nUCk0dn/uzgnCXNDgL8d
   I=;
IronPort-SDR: IsruprfH0VZNbFFBE3Rf0yvA01ANHQDxE38lsRqgzHgOgq9LukYV/kJvcM/rkNu9Mkz57ymYaU
 UgLOYbzvHmvw==
X-IronPort-AV: E=Sophos;i="5.75,456,1589241600"; 
   d="scan'208";a="46992143"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 10 Aug 2020 06:11:25 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 2BA9EA210C;
        Mon, 10 Aug 2020 06:11:23 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 06:11:22 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.71) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 06:11:17 +0000
Subject: Re: [PATCH v6 08/18] nitro_enclaves: Add logic for creating an
 enclave VM
To:     Andra Paraschiv <andraprs@amazon.com>,
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
From:   Alexander Graf <graf@amazon.de>
Message-ID: <77f71395-d7ba-f198-56dc-3b0a954a98de@amazon.de>
Date:   Mon, 10 Aug 2020 08:11:15 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200805091017.86203-9-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.71]
X-ClientProxiedBy: EX13D08UWC002.ant.amazon.com (10.43.162.168) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.08.20 11:10, Andra Paraschiv wrote:
> Add ioctl command logic for enclave VM creation. It triggers a slot
> allocation. The enclave resources will be associated with this slot and
> it will be used as an identifier for triggering enclave run.
> =

> Return a file descriptor, namely enclave fd. This is further used by the
> associated user space enclave process to set enclave resources and
> trigger enclave termination.
> =

> The poll function is implemented in order to notify the enclave process
> when an enclave exits without a specific enclave termination command
> trigger e.g. when an enclave crashes.
> =

> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>
> ---
> Changelog
> =

> v5 -> v6
> =

> * Update the code base to init the ioctl function in this patch.
> * Update documentation to kernel-doc format.
> =

> v4 -> v5
> =

> * Release the reference to the NE PCI device on create VM error.
> * Close enclave fd on copy_to_user() failure; rename fd to enclave fd
>    while at it.
> * Remove sanity checks for situations that shouldn't happen, only if
>    buggy system or broken logic at all.
> * Remove log on copy_to_user() failure.
> =

> v3 -> v4
> =

> * Use dev_err instead of custom NE log pattern.
> * Update the NE ioctl call to match the decoupling from the KVM API.
> * Add metadata for the NUMA node for the enclave memory and CPUs.
> =

> v2 -> v3
> =

> * Remove the WARN_ON calls.
> * Update static calls sanity checks.
> * Update kzfree() calls to kfree().
> * Remove file ops that do nothing for now - open.
> =

> v1 -> v2
> =

> * Add log pattern for NE.
> * Update goto labels to match their purpose.
> * Remove the BUG_ON calls.
> ---
>   drivers/virt/nitro_enclaves/ne_misc_dev.c | 229 ++++++++++++++++++++++
>   1 file changed, 229 insertions(+)
> =

> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nit=
ro_enclaves/ne_misc_dev.c
> index 472850250220..6c8c12f65666 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c

[...]

> +/**
> + * ne_ioctl() - Ioctl function provided by the NE misc device.
> + * @file:	File associated with this ioctl function.
> + * @cmd:	The command that is set for the ioctl call.
> + * @arg:	The argument that is provided for the ioctl call.
> + *
> + * Context: Process context.
> + * Return:
> + * * Ioctl result (e.g. enclave file descriptor) on success.
> + * * Negative return value on failure.
> + */
> +static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long =
arg)
> +{
> +	switch (cmd) {
> +	case NE_CREATE_VM: {
> +		int enclave_fd =3D -1;
> +		struct file *enclave_file =3D NULL;
> +		struct ne_pci_dev *ne_pci_dev =3D NULL;
> +		/* TODO: Find another way to get the NE PCI device reference. */
> +		struct pci_dev *pdev =3D pci_get_device(PCI_VENDOR_ID_AMAZON,
> +						      PCI_DEVICE_ID_NE, NULL);

This should go away if you set misc_dev.parent.

> +		int rc =3D -EINVAL;
> +		u64 slot_uid =3D 0;
> +
> +		ne_pci_dev =3D pci_get_drvdata(pdev);
> +
> +		mutex_lock(&ne_pci_dev->enclaves_list_mutex);
> +
> +		enclave_fd =3D ne_create_vm_ioctl(pdev, ne_pci_dev, &slot_uid);
> +		if (enclave_fd < 0) {
> +			rc =3D enclave_fd;
> +
> +			mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
> +
> +			pci_dev_put(pdev);

This should also disappear.



Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



