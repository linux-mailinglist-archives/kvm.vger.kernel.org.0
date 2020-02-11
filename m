Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60265159874
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 19:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbgBKSXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 13:23:47 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42881 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730230AbgBKSXq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 13:23:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581445425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JtLteavNR/sU8I4FM52dhJ4SSP+pHIXFfOdCu8qBlvk=;
        b=D+JknhB63qBZv3hP1gWIugxrS/KVdIXFV3tj0Fb/F/HPMIjWlvS5D+fTIlev4uVRYtr9Eg
        4Ww48rqeRDC1oCNW2F1MQ+VMDgrQOaYDngNcQ8YTI1t7ZOiGqctr/tnT5qHCAuwk5FS1GQ
        WMFM0feZnVBBlUBfogHGWlHW7VSsdeU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-eLXIxVWWPx6eFNA8tAG7jw-1; Tue, 11 Feb 2020 13:23:38 -0500
X-MC-Unique: eLXIxVWWPx6eFNA8tAG7jw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BF2F18B9FC1;
        Tue, 11 Feb 2020 18:23:37 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A08560BF1;
        Tue, 11 Feb 2020 18:23:31 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 0/9] KVM: arm64: PMUv3 Event Counter
 Tests
To:     Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Cc:     Eric Auger <eric.auger.pro@gmail.com>,
        Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>,
        Andrew Murray <andrew.murray@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <CAFEAcA8iBvM2xguW2_6OFWDjPPEzEorief4F2aoh0Vitp466rQ@mail.gmail.com>
 <20200211160733.zbqh3vbscdfgkkcd@kamzik.brq.redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <7daa10bc-178d-48a1-aee4-a8edcaf37bc3@redhat.com>
Date:   Tue, 11 Feb 2020 19:23:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200211160733.zbqh3vbscdfgkkcd@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/11/20 5:07 PM, Andrew Jones wrote:
> On Tue, Feb 11, 2020 at 03:42:38PM +0000, Peter Maydell wrote:
>> On Thu, 30 Jan 2020 at 11:25, Eric Auger <eric.auger@redhat.com> wrote:
>>>
>>> This series implements tests exercising the PMUv3 event counters.
>>> It tests both the 32-bit and 64-bit versions. Overflow interrupts
>>> also are checked. Those tests only are written for arm64.
>>>
>>> It allowed to reveal some issues related to SW_INCR implementation
>>> (esp. related to 64-bit implementation), some problems related to
>>> 32-bit <-> 64-bit transitions and consistency of enabled states
>>> of odd and event counters (See [1]).
>>>
>>> Overflow interrupt testing relies of one patch from Andre
>>> ("arm: gic: Provide per-IRQ helper functions") to enable the
>>> PPI 23, coming from "arm: gic: Test SPIs and interrupt groups"
>>> (https://patchwork.kernel.org/cover/11234975/). Drew kindly
>>> provided "arm64: Provide read/write_sysreg_s".
>>>
>>> All PMU tests can be launched with:
>>> ./run_tests.sh -g pmu
>>> Tests also can be launched individually. For example:
>>> ./arm-run arm/pmu.flat -append 'chained-sw-incr'
>>>
>>> With KVM:
>>> - chain-promotion and chained-sw-incr are known to be failing.
>>>   [1] proposed a fix.
>>> - On TX2, I have some random failures due to MEM_ACCESS event
>>>   measured with a great disparity. This is not observed on
>>>   other machines I have access to.
>>> With TCG:
>>> - all new tests are skipped
>>
>> I'm having a go at using this patchset to test the support
>> I'm adding for TCG for the v8.1 and v8.4 PMU extensions...
>>
>> Q1: how can I get run_tests.sh to pass extra arguments to
>> QEMU ? The PMU events check will fail unless QEMU gets
>> the '-icount 8' to enable cycle-counting, but although
>> the underlying ./arm/run lets you add arbitrary extra
>> arguments to QEMU, run_tests.sh doesn't seem to. Trying to
>> pass them in via "QEMU=/path/to/qemu -icount 8" doesn't
>> work either.
int arm/unittests.cfg

there are tests related to TCG that are commented.

# Test PMU support (TCG) with -icount IPC=256
#[pmu-tcg-icount-256]
#file = pmu.flat
#extra_params = -icount 8 -append 'cycle-counter 256'
#groups = pmu
#accel = tcg

I wondered why we kept those and commented. Should we start with
separate tests for KVM and TCG?

> 
> Alex Bennee once submit a patch[*] allowing that to work, but
> it never got merged. I just rebased it and tried it, but it
> doesn't work now. Too much has changed in the run scripts
> since his posting. I can try to rework it though.
> 
> [*] https://github.com/rhdrjones/kvm-unit-tests/commit/9a8574bfd924f3e865611688e26bb12e53821747
> 
>>
>> Q2: do you know why arm/pmu.c:check_pmcr() insists that
>> PMCR.IMP is non-zero? The comment says "simple sanity check",
>> but architecturally a zero IMP field is permitted (meaning
>> "go look at MIDR_EL1 instead"). This causes TCG to fail this
>> test on '-cpu max', because in that case we set PMCR.IMP
>> to the same thing as MIDR_EL1.Implementer which is 0
>> ("software use", since QEMU is software...)
indeed
> 
> Probably just a misunderstanding on the part of the author (and
> reviewers). Maybe Eric can fix that while preparing this series.

Yes I can definitively fix that

Thanks

Eric
> 
> Thanks,
> drew
> 

