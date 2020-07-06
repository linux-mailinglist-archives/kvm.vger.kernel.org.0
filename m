Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F5A215384
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 09:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgGFHxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 03:53:20 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:58574 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728248AbgGFHxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 03:53:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1594022000; x=1625558000;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=qpdzQXh8yHeKmVHBY0FoswgkSFVUN86DBPAeWg6rgMA=;
  b=iz+ZDUghPSl+66ynmCqg8L8HWqwaXbjlsVKDcRge9a977BdOXiUOiYEq
   BVovgTvtNnz9jditd8sBwDwn3Q9x7K+zkYd8GpLkL/CEwdBIKDjk0kN9Q
   ZbZYjdQiIJxCyO7UapuCwz3AsWARfA4D6corfINlRamLn+sKZvc/ddQxE
   Y=;
IronPort-SDR: J4BHAmsCdvtE3uSoEB48J6P7orv5dMMTNv+ZlyN54du0DCBuu9IPh05MFmA9wXjTLqpGNAO20G
 XleOfQzBD9vw==
X-IronPort-AV: E=Sophos;i="5.75,318,1589241600"; 
   d="scan'208";a="57534681"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 06 Jul 2020 07:53:14 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 6D8C5A1D86;
        Mon,  6 Jul 2020 07:53:13 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 07:53:13 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.140) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 07:53:04 +0000
Subject: Re: [PATCH v4 08/18] nitro_enclaves: Add logic for enclave vm
 creation
To:     Andra Paraschiv <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
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
From:   Alexander Graf <graf@amazon.de>
Message-ID: <906a959e-38c9-02e6-f09e-a83cd5b0b294@amazon.de>
Date:   Mon, 6 Jul 2020 09:53:00 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-9-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D46UWB004.ant.amazon.com (10.43.161.204) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.20 22:03, Andra Paraschiv wrote:
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

Reviewed-by: Alexander Graf <graf@amazon.com>


Alex




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



