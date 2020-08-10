Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C685D24045A
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 11:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHJJ5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 05:57:14 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:59274 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbgHJJ5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 05:57:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1597053434; x=1628589434;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=fgsFSgHthR1f7WWfooMBWx4lK2mZmhBHIFfrqDvnW3A=;
  b=jqwS+cN5JVZhyhV+0EhC6RZgRcTaMbT+soxl2XDaYbhiP09zCYEKS+BV
   7itQbwfVpF8cIK2PdiSI2CnmLQXuK/IhMj/w5pK2zqGB1t22N/uzJoOiv
   HV6KqJrx54s5zrQ0JdNsO3PIGBz96/go/nimdRrROHxlb8aCh+sv8Ux4m
   U=;
IronPort-SDR: oDdE0v8ZPK5Lkk7yWvz3oUN9YB/R8fiwPqgiI3yviaucVfVSB0zLRy1fm+BvPtfKkoVYNjbbS5
 zt7lO9XkxXog==
X-IronPort-AV: E=Sophos;i="5.75,457,1589241600"; 
   d="scan'208";a="66803826"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 10 Aug 2020 09:57:11 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id BDB1EA1DD4;
        Mon, 10 Aug 2020 09:57:09 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 09:57:09 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.71) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 09:57:04 +0000
Subject: Re: [PATCH v6 10/18] nitro_enclaves: Add logic for getting the
 enclave image load info
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
 <20200805091017.86203-11-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <70ec8010-cb3b-50a8-5472-a96c5aa2cf8d@amazon.de>
Date:   Mon, 10 Aug 2020 11:57:02 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200805091017.86203-11-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.71]
X-ClientProxiedBy: EX13D23UWC002.ant.amazon.com (10.43.162.22) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.08.20 11:10, Andra Paraschiv wrote:
> Before setting the memory regions for the enclave, the enclave image
> needs to be placed in memory. After the memory regions are set, this
> memory cannot be used anymore by the VM, being carved out.
> =

> Add ioctl command logic to get the offset in enclave memory where to
> place the enclave image. Then the user space tooling copies the enclave
> image in the memory using the given memory offset.
> =

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



