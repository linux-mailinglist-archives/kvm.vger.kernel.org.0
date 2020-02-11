Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 953C31598A3
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 19:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbgBKSbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 13:31:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47937 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727361AbgBKSbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 13:31:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581445864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vQe3nGagGzeCsufC3rqZRuUQ8B4VGRBcrcOfQrGBV8w=;
        b=XizbppCkcIq3S0jPR6Yg3/Y+HDcyF02GFLkUuS+eqEqnhruL49WoKpIjI40/YDmU0CcGE5
        FxxH19lIGS8qlUcOo+uE6iQwKluCR30kSE1VFvNyGnzE0Uigbzn3EgNZc2JYdQYSq3FxwQ
        KQvD88omyJGCgb1qA5XQDq1/s5+E8G0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-MhMVp186MkW1lxqSwApFkQ-1; Tue, 11 Feb 2020 13:31:00 -0500
X-MC-Unique: MhMVp186MkW1lxqSwApFkQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2ED611005510;
        Tue, 11 Feb 2020 18:30:58 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8935689F38;
        Tue, 11 Feb 2020 18:30:53 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 6/9] arm: pmu: Test chained counter
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
 <20200130112510.15154-7-eric.auger@redhat.com>
 <CAFEAcA_jfZKjey8komTt97Mu-oFjWyFNG2cY4-o8yFAP1oGiug@mail.gmail.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <5f11c69b-655a-2fa9-462f-9fd6ebdb501d@redhat.com>
Date:   Tue, 11 Feb 2020 19:30:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA_jfZKjey8komTt97Mu-oFjWyFNG2cY4-o8yFAP1oGiug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2/11/20 5:24 PM, Peter Maydell wrote:
> On Thu, 30 Jan 2020 at 11:26, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> Add 2 tests exercising chained counters. The first one uses
>> CPU_CYCLES and the second one uses SW_INCR.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> +static void test_chained_sw_incr(void)
>> +{
>> +       uint32_t events[] = { 0x0 /* SW_INCR */, 0x0 /* SW_INCR */};
> 
> Cut-n-paste error? This test relies on the CHAIN event but it
> isn't present in this list of events to pass to satisfy_prerequisites(),
> so I suspect the second element should be "0x1e /* CHAIN */" ?
No that's not a cut-n-paste error. I may rename the test into test_sw_incr.

It starts by testing unchained SW_INCR.

chained SW_INCR testing start with
/* 64b SW_INCR */


> 
> (This makes the test fail on QEMU TCG, because we don't implement
> CHAIN.)
OK

Thanks

Eric
> 
> thanks
> -- PMM
> 

