Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E632124FE
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 15:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbgGBNmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 09:42:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50408 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729047AbgGBNmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 09:42:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593697350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9MNOdxawbqCNhNwGOQIC2Aifh6aq6wqhAa3zMjCE53g=;
        b=eTAeST4KHJwac3W8YssmUg5l9r3nmuKgFjAt7p5SOIqyzIWYFH9s7P+QxpmGH7XBqY5jut
        AtSTKsEftKZAKNpBg0XbNdDw24ucY3dT6mk29sKKCMY60hLDLBJ4LJn7PWmtGbN+eQ7QH6
        eq3UaryNAhnZoZ0RpP4AtMxmRivdRiI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-4XjQd4sqMCGNhL6LvNKvMQ-1; Thu, 02 Jul 2020 09:42:28 -0400
X-MC-Unique: 4XjQd4sqMCGNhL6LvNKvMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB3BA1083E82;
        Thu,  2 Jul 2020 13:42:26 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D7D679257;
        Thu,  2 Jul 2020 13:42:25 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
To:     Marc Zyngier <maz@kernel.org>
Cc:     Jingyi Wang <wangjingyi11@huawei.com>, drjones@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
 <087ef371-5e7b-e0b2-900f-67b2eacb4e0f@redhat.com>
 <05a3da5fa35568606e55eb6428ce91d8@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <69a37427-7e93-3411-f61c-50525a0ca3e1@redhat.com>
Date:   Thu, 2 Jul 2020 15:42:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <05a3da5fa35568606e55eb6428ce91d8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/2/20 3:08 PM, Marc Zyngier wrote:
> Hi Eric,
> 
> On 2020-07-02 13:57, Auger Eric wrote:
>> Hi Jingyi,
>>
>> On 7/2/20 5:01 AM, Jingyi Wang wrote:
>>> If gicv4.1(sgi hardware injection) supported, we test ipi injection
>>> via hw/sw way separately.
>>>
>>> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
>>> ---
>>>  arm/micro-bench.c    | 45 +++++++++++++++++++++++++++++++++++++++-----
>>>  lib/arm/asm/gic-v3.h |  3 +++
>>>  lib/arm/asm/gic.h    |  1 +
>>>  3 files changed, 44 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
>>> index fc4d356..80d8db3 100644
>>> --- a/arm/micro-bench.c
>>> +++ b/arm/micro-bench.c
>>> @@ -91,9 +91,40 @@ static void gic_prep_common(void)
>>>      assert(irq_ready);
>>>  }
>>>
>>> -static void ipi_prep(void)
>>> +static bool ipi_prep(void)
>> Any reason why the bool returned value is preferred over the standard
>> int?
>>>  {
>>> +    u32 val;
>>> +
>>> +    val = readl(vgic_dist_base + GICD_CTLR);
>>> +    if (readl(vgic_dist_base + GICD_TYPER2) & GICD_TYPER2_nASSGIcap) {
>>> +        val &= ~GICD_CTLR_ENABLE_G1A;
>>> +        val &= ~GICD_CTLR_nASSGIreq;
>>> +        writel(val, vgic_dist_base + GICD_CTLR);
>>> +        val |= GICD_CTLR_ENABLE_G1A;
>>> +        writel(val, vgic_dist_base + GICD_CTLR);
>> Why do we need this G1A dance?
> 
> Because it isn't legal to change the SGI behaviour when groups are enabled.
> Yes, it is described in this bit of documentation nobody has access to.

OK thank you for the explanation. Jingyi, maybe add a comment to avoid
the question again ;-)

Thanks

Eric
> 
> And this code needs to track RWP on disabling Group-1.
> 
>         M.

