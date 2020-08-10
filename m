Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440242404BA
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 12:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgHJKdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 06:33:18 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:42149 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgHJKdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 06:33:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597055597; x=1628591597;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=qlXDRQQXRVfw+FXAe+8LM3wbs/mNAwokZ6hKDNOIsrA=;
  b=uzKVjdyOXC7t19I5gtIPpO9HBanQy1o5ApfqDKs6+wylbsVK6WFvOL4W
   nvAvxV44PVOoIm7diaR9sCvFqbFhBUmsDyOzTzZNN3YaHrOENzmydVIJO
   e3YG8Vf76WL6lebIiSzFgm1xrXaRtr/rxWin0L/8ehOxejxRb21Ub8Cyq
   8=;
IronPort-SDR: SpL0IH0k3fM1pgbWwfWxwQgYefDo2Owqr3k2uTFKcaczYm6RYgkN16BHwwfKZrwhUSS+e9XjKI
 OD0w5b/8JPkA==
X-IronPort-AV: E=Sophos;i="5.75,457,1589241600"; 
   d="scan'208";a="47063205"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-60ce1996.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 10 Aug 2020 10:33:15 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-60ce1996.us-west-2.amazon.com (Postfix) with ESMTPS id 20B18A2E4D;
        Mon, 10 Aug 2020 10:33:14 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 10:33:13 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.145) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 10:33:05 +0000
Subject: Re: [PATCH v6 12/18] nitro_enclaves: Add logic for starting an
 enclave
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
 <20200805091017.86203-13-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <f119fa50-6909-0cae-1c55-bbda097f63b9@amazon.com>
Date:   Mon, 10 Aug 2020 12:33:03 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200805091017.86203-13-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D10UWB004.ant.amazon.com (10.43.161.121) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.08.20 11:10, Andra Paraschiv wrote:
> After all the enclave resources are set, the enclave is ready for
> beginning to run.
> =

> Add ioctl command logic for starting an enclave after all its resources,
> memory regions and CPUs, have been set.
> =

> The enclave start information includes the local channel addressing -
> vsock CID - and the flags associated with the enclave.
> =

> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>

Reviewed-by: Alexander Graf <graf@amazon.com>


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



