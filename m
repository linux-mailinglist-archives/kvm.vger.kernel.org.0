Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB831DFAFB
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 22:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387909AbgEWUZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 16:25:37 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:44674 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387843AbgEWUZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 16:25:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1590265536; x=1621801536;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=rnNpBpyt3Adc4M7sIngkd5AepOlZo2gMavM2BYghvpE=;
  b=gIecXT2CrqabowQu+8bwT/NCq0U3sxJsJtRrWqGKPCBpsVsas4jZFjaX
   NtBfjjn3Wjs+05yKbC3pAOlDfCefIZpkBxhK2HwmuVXNXhGI/LPeTQuK4
   nTgnxiT+7kghDLra1zqIivlYHL0chUFNJW4xn7XrBmnb9L5V7o0mYdalY
   A=;
IronPort-SDR: XUknxkut3W4z7LQyngKaNhwHCoFUmrV818LitD7OJRM+lKJVAMgMipJKDaX7RUgzdMpqno7EWf
 EcJ9erRpti9Q==
X-IronPort-AV: E=Sophos;i="5.73,426,1583193600"; 
   d="scan'208";a="37199168"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 23 May 2020 20:25:34 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id 045D9A2066;
        Sat, 23 May 2020 20:25:33 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 23 May 2020 20:25:33 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.193) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 23 May 2020 20:25:28 +0000
Subject: Re: [PATCH v2 04/18] nitro_enclaves: Init PCI device driver
To:     Greg KH <greg@kroah.com>, Andra Paraschiv <andraprs@amazon.com>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-5-andraprs@amazon.com>
 <20200522070414.GB771317@kroah.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <68b86d32-1255-f9ce-4366-12219ce07ba6@amazon.de>
Date:   Sat, 23 May 2020 22:25:25 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522070414.GB771317@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.193]
X-ClientProxiedBy: EX13d09UWA002.ant.amazon.com (10.43.160.186) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Greg,

On 22.05.20 09:04, Greg KH wrote:
> =

> On Fri, May 22, 2020 at 09:29:32AM +0300, Andra Paraschiv wrote:
>> +/**
>> + * ne_setup_msix - Setup MSI-X vectors for the PCI device.
>> + *
>> + * @pdev: PCI device to setup the MSI-X for.
>> + *
>> + * @returns: 0 on success, negative return value on failure.
>> + */
>> +static int ne_setup_msix(struct pci_dev *pdev)
>> +{
>> +     struct ne_pci_dev *ne_pci_dev =3D NULL;
>> +     int nr_vecs =3D 0;
>> +     int rc =3D -EINVAL;
>> +
>> +     if (WARN_ON(!pdev))
>> +             return -EINVAL;
> =

> How can this ever happen?  If it can not, don't test for it.  If it can,
> don't warn for it as that will crash systems that do panic-on-warn, just
> test and return an error.

I think the point here is to catch situations that should never happen, =

but keep a sanity check in in case they do happen. This would've usually =

been a BUG_ON, but people tend to dislike those these days because they =

can bring down your system ...

So in this particular case here I agree that it's a bit silly to check =

whether pdev is !=3D NULL. In other device code internal APIs though it's =

not quite as clear of a cut. I by far prefer code that tells me it's =

broken over reverse engineering stray pointer accesses ...

> =

>> +
>> +     ne_pci_dev =3D pci_get_drvdata(pdev);
>> +     if (WARN_ON(!ne_pci_dev))
>> +             return -EINVAL;
> =

> Same here, don't use WARN_ON if at all possible.
> =

>> +
>> +     nr_vecs =3D pci_msix_vec_count(pdev);
>> +     if (nr_vecs < 0) {
>> +             rc =3D nr_vecs;
>> +
>> +             dev_err_ratelimited(&pdev->dev,
>> +                                 NE "Error in getting vec count [rc=3D%=
d]\n",
>> +                                 rc);
>> +
> =

> Why ratelimited, can this happen over and over and over?

In this particular function, no, so here it really should just be =

dev_err. Other functions are implicitly callable from user space through =

an ioctl, which means they really need to stay rate limited.

Thanks a lot for looking through the code and pointing all those bits out :)


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



