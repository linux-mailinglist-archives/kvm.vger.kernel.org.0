Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887601598AA
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 19:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgBKScV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 13:32:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25639 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730274AbgBKScU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 13:32:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581445939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZAgyvfwf3MxzMiPOUvUmlPx5ULbWnylJ3lGwUp9IgdE=;
        b=LQC9pzJcGEpWe+qx0YPkaiWPxZscnV7B8F4l0vsgmgPPpxhknLJUUxadlOtuEfPZvsDzda
        8mU9Kxr82rA3K9k6Y15poxITreTLchY2L+Fn7z3XT/bvzbQYlyDPrrsUTKkPZBHXYA3V9O
        eBX+Kr5+RXO0i9ollSB4nk5E4LKVUzU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-XCCwj2V_O9aRrp398QR0pA-1; Tue, 11 Feb 2020 13:32:10 -0500
X-MC-Unique: XCCwj2V_O9aRrp398QR0pA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48518113784B;
        Tue, 11 Feb 2020 18:32:08 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C54275C1B5;
        Tue, 11 Feb 2020 18:32:03 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 4/9] arm: pmu: Check Required Event
 Support
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Eric Auger <eric.auger.pro@gmail.com>,
        Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <20200130112510.15154-5-eric.auger@redhat.com>
 <CAFEAcA_V3rT+C1FCPPyjmQ8svxF1tMWWOLgZ1Vn_CNQ3N0x-KA@mail.gmail.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e3fc48f2-e31c-c70b-16fe-ca5af4a0708e@redhat.com>
Date:   Tue, 11 Feb 2020 19:32:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA_V3rT+C1FCPPyjmQ8svxF1tMWWOLgZ1Vn_CNQ3N0x-KA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2/11/20 5:28 PM, Peter Maydell wrote:
> On Thu, 30 Jan 2020 at 11:25, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> If event counters are implemented check the common events
>> required by the PMUv3 are implemented.
>>
>> Some are unconditionally required (SW_INCR, CPU_CYCLES,
>> either INST_RETIRED or INST_SPEC). Some others only are
>> required if the implementation implements some other features.
>>
>> Check those wich are unconditionally required.
>>
>> This test currently fails on TCG as neither INST_RETIRED
>> or INST_SPEC are supported.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
> 
>> +static bool is_event_supported(uint32_t n, bool warn)
>> +{
>> +       uint64_t pmceid0 = read_sysreg(pmceid0_el0);
>> +       uint64_t pmceid1 = read_sysreg_s(PMCEID1_EL0);
>> +       bool supported;
>> +       uint64_t reg;
>> +
>> +       /*
>> +        * The low 32-bits of PMCEID0/1 respectly describe
>> +        * event support for events 0-31/32-63. Their High
>> +        * 32-bits describe support for extended events
>> +        * starting at 0x4000, using the same split.
>> +        */
>> +       if (n >= 0x0  && n <= 0x3F)
>> +               reg = (pmceid0 & 0xFFFFFFFF) | ((pmceid1 & 0xFFFFFFFF) << 32);
>> +       else if  (n >= 0x4000 && n <= 0x403F)
>> +               reg = (pmceid0 >> 32) | ((pmceid1 >> 32) << 32);
>> +       else
>> +               abort();
>> +
>> +       supported =  reg & (1UL << (n & 0x3F));
>> +
>> +       if (!supported && warn)
>> +               report_info("event %d is not supported", n);
> 
> As with satisfy_prerequisites(), printing this with "0x%x"
> would probably be more helpful to most users.
OK

Thanks

Eric
> 
> thanks
> -- PMM
> 

