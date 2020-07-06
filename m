Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB59215817
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 15:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbgGFNNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 09:13:09 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:8829 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbgGFNNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 09:13:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594041188; x=1625577188;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Puo7H/it5cyhO+c5XlQobL6J1Ajj2+CNag80ZS7bOtM=;
  b=JR9Zv2wCQWTnUQ+L/a+iDcTFJM6/FvCg+ftD9rp2nq2ryaXp117BFuHe
   J50/Fmne5GGIAVppZAgfibSDMwKKokhIMXhnEVRx5EQZhPnqQ35BOi38G
   wuuzB/ctybkmib6CNnV6I1xOfUkjCTVVIw3ByZeOA2/V8AkbgGii4VFqB
   8=;
IronPort-SDR: exQDzZjMiKUm567zHXsMZnoh4+h0knE1lnsLbvU+7iHcS1Ks1uTvTHPMHf1uyklP6xB7ErNDeR
 TeoXWKajPaFw==
X-IronPort-AV: E=Sophos;i="5.75,320,1589241600"; 
   d="scan'208";a="56380786"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 06 Jul 2020 13:12:56 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id C24B0A2344;
        Mon,  6 Jul 2020 13:12:55 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 13:12:55 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.140) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 13:12:47 +0000
Subject: Re: [PATCH v4 08/18] nitro_enclaves: Add logic for enclave vm
 creation
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
 <20200622200329.52996-9-andraprs@amazon.com>
 <906a959e-38c9-02e6-f09e-a83cd5b0b294@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <c68a8a89-b2c4-51cf-ee0f-646eb5533480@amazon.com>
Date:   Mon, 6 Jul 2020 16:12:41 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <906a959e-38c9-02e6-f09e-a83cd5b0b294@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D29UWA004.ant.amazon.com (10.43.160.33) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/07/2020 10:53, Alexander Graf wrote:
>
>
> On 22.06.20 22:03, Andra Paraschiv wrote:
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
>
> Reviewed-by: Alexander Graf <graf@amazon.com>

Added. Thank you.

Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

