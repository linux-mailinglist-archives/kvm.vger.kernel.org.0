Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE798215936
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 16:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgGFOPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 10:15:42 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:9538 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbgGFOPm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 10:15:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594044942; x=1625580942;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=d4PtA/PnsPkuQy2jWbwgjkialcWBF3QdJN51/memhrA=;
  b=brssue4stFDk2QMIh8oi45r0tsjAQXJ7+HHUa4+rqRSNjILlapMTL2Zz
   JTAOR1Gith/9Gmpdses0yEt2c3OCWFgLFc4nIcX6wHDuTv91WM5TGL4Rn
   nt9Whnb8q8y8ETlgCkq3PVYQCptt7sScSzsgEH+2TbH6w+Xj+wHOsDTQ7
   o=;
IronPort-SDR: kIexPVF4X3xMERMadp+fNVHSJjVaOeB9LwiKWOaOoGF0e48oS7ANsVXeUy4v1TAsnEhVezNfGl
 X83FWLEuQ93w==
X-IronPort-AV: E=Sophos;i="5.75,320,1589241600"; 
   d="scan'208";a="40236267"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 06 Jul 2020 14:15:38 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 2C045A05EB;
        Mon,  6 Jul 2020 14:15:36 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 14:15:35 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.145) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 14:15:27 +0000
Subject: Re: [PATCH v4 13/18] nitro_enclaves: Add logic for enclave
 termination
To:     Alexander Graf <graf@amazon.com>, <linux-kernel@vger.kernel.org>
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
 <20200622200329.52996-14-andraprs@amazon.com>
 <34a0bee8-aaf4-d221-cd6e-41b5f3d8f335@amazon.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <61c164f7-3849-9c46-b65b-7cd8d4788793@amazon.com>
Date:   Mon, 6 Jul 2020 17:15:22 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <34a0bee8-aaf4-d221-cd6e-41b5f3d8f335@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D27UWA003.ant.amazon.com (10.43.160.56) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/07/2020 14:26, Alexander Graf wrote:
>
>
> On 22.06.20 22:03, Andra Paraschiv wrote:
>> An enclave is associated with an fd that is returned after the enclave
>> creation logic is completed. This enclave fd is further used to setup
>> enclave resources. Once the enclave needs to be terminated, the enclave
>> fd is closed.
>>
>> Add logic for enclave termination, that is mapped to the enclave fd
>> release callback. Free the internal enclave info used for bookkeeping.
>>
>> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>
> Reviewed-by: Alexander Graf <graf@amazon.com>

Added. Thanks for review.

Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

