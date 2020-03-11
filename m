Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A830C181CC4
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 16:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbgCKPsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 11:48:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52791 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729977AbgCKPsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 11:48:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583941681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UcFcy+P5OSEH/ZlLu1SpwRmiQzxtCziFp2P7AeR9cGw=;
        b=Ow8hyoAH4xXVp0O9hXoN+S6T9/NKYxSOGue/RdnzjHg6oVsH4ydXftD5/nkJLf3NbA4wNd
        4UH+WLIFZamHbeAdAaGOswdp01fWYyUg9MILCX6wsH9lUJiDP8K3U28yfDJOyDK9J2BC7o
        mBdFAt3Rs4ZKLDN4ahUpuW1ci8MbiDQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-l7dWPsJ1OFO0_BN3Bsfawg-1; Wed, 11 Mar 2020 11:47:59 -0400
X-MC-Unique: l7dWPsJ1OFO0_BN3Bsfawg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A78918A72A3;
        Wed, 11 Mar 2020 15:47:58 +0000 (UTC)
Received: from [10.36.118.12] (unknown [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EADFA60BEE;
        Wed, 11 Mar 2020 15:47:51 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v6 07/13] arm/arm64: ITS:
 its_enable_defaults
To:     Andrew Jones <drjones@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        peter.maydell@linaro.org, andre.przywara@arm.com, thuth@redhat.com,
        yuzenghui@huawei.com, alexandru.elisei@arm.com
References: <20200311135117.9366-1-eric.auger@redhat.com>
 <20200311135117.9366-8-eric.auger@redhat.com>
 <20200311153842.knuyqfnzqopb35gj@kamzik.brq.redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <75e9a1b2-8bd1-232a-91e4-5bd606c70c1a@redhat.com>
Date:   Wed, 11 Mar 2020 16:47:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200311153842.knuyqfnzqopb35gj@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,
On 3/11/20 4:38 PM, Andrew Jones wrote:
> On Wed, Mar 11, 2020 at 02:51:11PM +0100, Eric Auger wrote:
>> +/* must be called after gicv3_enable_defaults */
>> +void its_enable_defaults(void)
>> +{
>> +	int i;
>> +
>> +	/* Allocate LPI config and pending tables */
>> +	gicv3_lpi_alloc_tables();
>> +
>> +	for (i = 0; i < nr_cpus; i++)
>> +		gicv3_lpi_rdist_enable(i);
> 
> You still haven't explained what's wrong with for_each_present_cpu.

The previous comment you did was related to a spurious change I made in
gicv3_lpi_alloc_tables. This change was removed in v5:
[kvm-unit-tests PATCH v5 05/13] arm/arm64: gicv3: Set the LPI config and
pending tables

I did not understand from your comment you wanted all locations to use
for_each_present_cpu(). I have nothing against it ;-)

 Also,
> I see you've added 'i < nr_cpus' loops in arm/gic.c too. I'd prefer we not
> assume that all cpu's are present (even though, currently, they must be),
> because we may want to integrate cpu hotplug tests with these tests at
> some point.

OK

Thanks

Eric
> 
>> +
>> +	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);
>> +}
>> -- 
>> 2.20.1
>>
>>
> 

