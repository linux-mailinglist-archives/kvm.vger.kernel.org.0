Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF4024044B
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 11:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgHJJyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 05:54:41 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:40361 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgHJJyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 05:54:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1597053279; x=1628589279;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=8aroeKp+TU0h9KbgQNdJ0GlbSrv/KIjPx49wzwoNgdY=;
  b=ji1CLJdbfca7/lbvfrDGxIlsK0jhjFtjc6eYhya2SDWRuIpj+G3WjLzz
   /LXlEbvuHhv87xAZ3cf4PRMa9sh4DU1O1I2AkiEr9JRSGG0kAPGIC8WZD
   CwSmxGPIkNS2adTqCqCH6XWeTNh74R6DPnAJHQVmWiE0l/F5WcQ+r4s1j
   s=;
IronPort-SDR: 6jHd86C88g8LHIGDVrhLjCMXAO1W3rp71sqL2wpipWlBI0Buwu/tC04mxFQxhB7seKMpQSucxe
 sgL+Q1oyUorQ==
X-IronPort-AV: E=Sophos;i="5.75,457,1589241600"; 
   d="scan'208";a="58615007"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 10 Aug 2020 09:54:36 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 1B171A1C89;
        Mon, 10 Aug 2020 09:54:35 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 09:54:34 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.71) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 09:54:29 +0000
Subject: Re: [PATCH v6 11/18] nitro_enclaves: Add logic for setting an enclave
 memory region
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
 <20200805091017.86203-12-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <76b87d46-88b6-4c00-4ac7-27e5be020a57@amazon.de>
Date:   Mon, 10 Aug 2020 11:54:27 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200805091017.86203-12-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.71]
X-ClientProxiedBy: EX13d09UWC004.ant.amazon.com (10.43.162.114) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.08.20 11:10, Andra Paraschiv wrote:
> Another resource that is being set for an enclave is memory. User space
> memory regions, that need to be backed by contiguous memory regions,
> are associated with the enclave.
> =

> One solution for allocating / reserving contiguous memory regions, that
> is used for integration, is hugetlbfs. The user space process that is
> associated with the enclave passes to the driver these memory regions.
> =

> The enclave memory regions need to be from the same NUMA node as the
> enclave CPUs.
> =

> Add ioctl command logic for setting user space memory region for an
> enclave.
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



