Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D7D2C8BB3
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 18:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgK3RuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 12:50:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57002 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727476AbgK3RuB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 12:50:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606758514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pQ4WpiPqnnYL566UEzHdmnDQQhCQF6P/OZJyfbS45g8=;
        b=NPL8HPxXTJjCaBumm8MvGpcJsx0MsuDfJRYCFxTKrCJ4Y4eBKZhB6snATGXJRDGdrtz3sl
        wG2XRHTXiD0sue75iHW0rCWHl4L00IyeUnUo73kUyiZsV0ey7bZJaCO9zHfnD5a+NJIVGz
        JIJYx7NgzzH9tr4MvoU501q3ItDjxSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-fOZeDxu5PhmzgVVkZbmwww-1; Mon, 30 Nov 2020 12:48:29 -0500
X-MC-Unique: fOZeDxu5PhmzgVVkZbmwww-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F11C7190A7A1;
        Mon, 30 Nov 2020 17:48:27 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 534425D6A8;
        Mon, 30 Nov 2020 17:48:25 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 10/10] arm64: gic: Use IPI test checking
 for the LPI tests
To:     Zenghui Yu <yuzenghui@huawei.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     andre.przywara@arm.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-11-alexandru.elisei@arm.com>
 <a7069b1d-ef11-7504-644c-8d341fa2aabc@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <23be6c11-fd2e-0d41-df06-91d87cf1a465@redhat.com>
Date:   Mon, 30 Nov 2020 18:48:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a7069b1d-ef11-7504-644c-8d341fa2aabc@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru, Zenghui
On 11/26/20 10:30 AM, Zenghui Yu wrote:
> On 2020/11/25 23:51, Alexandru Elisei wrote:
>> The reason for the failure is that the test "dev2/eventid=20 now triggers
>> an LPI" triggers 2 LPIs, not one. This behavior was present before this
>> patch, but it was ignored because check_lpi_stats() wasn't looking at the
>> acked array.
>>
>> I'm not familiar with the ITS so I'm not sure if this is expected, if the
>> test is incorrect or if there is something wrong with KVM emulation.
> 
> I think this is expected, or not.
> 
> Before INVALL, the LPI-8195 was already pending but disabled. On
> receiving INVALL, VGIC will reload configuration for all LPIs targeting
> collection-3 and deliver the now enabled LPI-8195. We'll therefore see
> and handle it before sending the following INT (which will set the
> LPI-8195 pending again).
> 
>> Did some more testing on an Ampere eMAG (fast out-of-order cores) using
>> qemu and kvmtool and Linux v5.8, here's what I found:
>>
>> - Using qemu and gic.flat built from*master*: error encountered 864 times
>>    out of 1088 runs.
>> - Using qemu: error encountered 852 times out of 1027 runs.
>> - Using kvmtool: error encountered 8164 times out of 10602 runs.
> 
> If vcpu-3 hadn't seen and handled LPI-8195 as quickly as possible (e.g.,
> vcpu-3 hadn't been scheduled), the following INT will set the already
> pending LPI-8195 pending again and we'll receive it *once* on vcpu-3.
> And we won't see the mentioned failure.
> 
> I think we can just drop the (meaningless and confusing?) INT.
Yes I agree with Zenghui, we can remove the INT and just check the
pending LPI set while disabled eventually hits

Thanks

Eric
> 
> 
> Thanks,
> Zenghui
> 

