Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37910241986
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 12:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgHKKRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 06:17:51 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:13120 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgHKKRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 06:17:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597141070; x=1628677070;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=pH/dqPFqn/5c/fFx2x7y3lTOdQqwfNkq66YZ1oLQHaE=;
  b=hkHUyzl9kpqc6B6IDEkk2OnF4YXHCP/80VMugiyGJiKPcJZQfMzY8J2b
   fabmugmKx7xD8+hfTJ+Lp2IJRRP99UwPfzOqJU2i9p+94QEwI7P5IrUf4
   rJw8q0LbGCYyavr5XtDLnI/tAqqwv/cEO7uwHFeYtKCja2tJNWUaNJbdz
   Q=;
IronPort-SDR: /Jfizqq72H/cs+siuKEQ9MKFuSHy05tstZjjnB9QrOJfwKBi5ykGU6svTVGGSO0fjz/aJYFIea
 qIxaItFYFA+Q==
X-IronPort-AV: E=Sophos;i="5.75,460,1589241600"; 
   d="scan'208";a="47084569"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 11 Aug 2020 10:17:49 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 34EF5A272D;
        Tue, 11 Aug 2020 10:17:46 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 11 Aug 2020 10:17:46 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.140) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 11 Aug 2020 10:17:36 +0000
Subject: Re: [PATCH v6 10/18] nitro_enclaves: Add logic for getting the
 enclave image load info
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
 <20200805091017.86203-11-andraprs@amazon.com>
 <70ec8010-cb3b-50a8-5472-a96c5aa2cf8d@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <0ef970b1-eea2-916c-3546-fdc4f2595e99@amazon.com>
Date:   Tue, 11 Aug 2020 13:17:31 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.0
MIME-Version: 1.0
In-Reply-To: <70ec8010-cb3b-50a8-5472-a96c5aa2cf8d@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D12UWC001.ant.amazon.com (10.43.162.78) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/08/2020 12:57, Alexander Graf wrote:
>
>
> On 05.08.20 11:10, Andra Paraschiv wrote:
>> Before setting the memory regions for the enclave, the enclave image
>> needs to be placed in memory. After the memory regions are set, this
>> memory cannot be used anymore by the VM, being carved out.
>>
>> Add ioctl command logic to get the offset in enclave memory where to
>> place the enclave image. Then the user space tooling copies the enclave
>> image in the memory using the given memory offset.
>>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>
> Reviewed-by: Alexander Graf <graf@amazon.com>

Thanks for review. I included the tag for this one and the next 2 patches.

Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

