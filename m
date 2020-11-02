Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEE92A3277
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 19:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgKBSCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 13:02:24 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:20926 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgKBSCY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 13:02:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1604340144; x=1635876144;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=+XbFpuHNO9eDIUZm/3GLfucKC/WQVlQ6KyOzhtsxWVs=;
  b=LIkTqlgq4+fwXnLP/o2kYeM6KS+7Qgt1aZakEgLKxKp+fePcaT5sLgIu
   wLkrA5ZMmFIgqp30pDw+IYfktFuupfgQSTY0gY3MkoA4rEDZlHAe56Dk5
   w0lkcPQZgFUuVNQaI6SK+ecwy/AG1W6c1LZvnEH4k4F/tD6DIc0LlabdY
   g=;
X-IronPort-AV: E=Sophos;i="5.77,445,1596499200"; 
   d="scan'208";a="89791576"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 02 Nov 2020 17:51:00 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 3CC0EA1D33;
        Mon,  2 Nov 2020 17:50:58 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 2 Nov 2020 17:50:57 +0000
Received: from Alexanders-MacBook-Air.local (10.43.160.27) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 2 Nov 2020 17:50:52 +0000
Subject: Re: [PATCH v2] nitro_enclaves: Fixup type and simplify logic of the
 poll mask setup
To:     Andra Paraschiv <andraprs@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "David Duncan" <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20201102173622.32169-1-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <405f71a6-9699-759d-2398-a17120d3fb96@amazon.de>
Date:   Mon, 2 Nov 2020 18:50:51 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201102173622.32169-1-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.27]
X-ClientProxiedBy: EX13D25UWC001.ant.amazon.com (10.43.162.44) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02.11.20 18:36, Andra Paraschiv wrote:
> Update the assigned value of the poll result to be EPOLLHUP instead of
> POLLHUP to match the __poll_t type.
> =

> While at it, simplify the logic of setting the mask result of the poll
> function.
> =

> Changelog
> =

> v1 -> v2
> =

> * Simplify the mask setting logic from the poll function.
> =

> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> Reported-by: kernel test robot <lkp@intel.com>

Reviewed-by: Alexander Graf <graf@amazon.com>


Alex

> ---
>   drivers/virt/nitro_enclaves/ne_misc_dev.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> =

> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nit=
ro_enclaves/ne_misc_dev.c
> index f06622b48d695..f1964ea4b8269 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -1505,10 +1505,8 @@ static __poll_t ne_enclave_poll(struct file *file,=
 poll_table *wait)
>   =

>   	poll_wait(file, &ne_enclave->eventq, wait);
>   =

> -	if (!ne_enclave->has_event)
> -		return mask;
> -
> -	mask =3D POLLHUP;
> +	if (ne_enclave->has_event)
> +		mask |=3D EPOLLHUP;
>   =

>   	return mask;
>   }
> =




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



