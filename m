Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C412366611
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 09:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbhDUHKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 03:10:53 -0400
Received: from 3.mo51.mail-out.ovh.net ([188.165.32.156]:56618 "EHLO
        3.mo51.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbhDUHKv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 03:10:51 -0400
X-Greylist: delayed 2322 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Apr 2021 03:10:50 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.108.1.125])
        by mo51.mail-out.ovh.net (Postfix) with ESMTPS id 5AF05280626;
        Wed, 21 Apr 2021 08:31:33 +0200 (CEST)
Received: from kaod.org (37.59.142.97) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Wed, 21 Apr
 2021 08:31:32 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-97G002e998e6ca-db5a-48ff-8671-b7c8d58cae9d,
                    3FD145AD23CDC28BEDADD0458B38E3079EC5C648) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 90.89.73.13
Subject: Re: [PATCH v5 3/3] ppc: Enable 2nd DAWR support on p10
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
CC:     <paulus@samba.org>, <mpe@ellerman.id.au>, <mikey@neuling.org>,
        <pbonzini@redhat.com>, <mst@redhat.com>, <qemu-ppc@nongnu.org>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <cohuck@redhat.com>, <groug@kaod.org>
References: <20210412114433.129702-1-ravi.bangoria@linux.ibm.com>
 <20210412114433.129702-4-ravi.bangoria@linux.ibm.com>
 <YH0M1YdINJqbdqP+@yekko.fritz.box>
 <ca21d852-4b54-01d3-baab-cc8d0d50e505@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <8020c404-d8ce-2758-d936-fc5e851017f0@kaod.org>
Date:   Wed, 21 Apr 2021 08:31:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <ca21d852-4b54-01d3-baab-cc8d0d50e505@linux.ibm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.97]
X-ClientProxiedBy: DAG9EX2.mxp5.local (172.16.2.82) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 621233e5-729b-4b55-94fb-826174eaf06d
X-Ovh-Tracer-Id: 14322854192763145208
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrvddtjedguddtjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuvfhfhffkffgfgggjtgfgihesthekredttdefheenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeeglefgjeevheeifeffudeuhedvveeftdeliedukeejgeeviefgieefhfdtffeftdenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddrleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehgrhhouhhgsehkrghougdrohhrgh
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/21 8:20 AM, Ravi Bangoria wrote:
> Hi David,
> 
> On 4/19/21 10:23 AM, David Gibson wrote:
>> On Mon, Apr 12, 2021 at 05:14:33PM +0530, Ravi Bangoria wrote:
>>> As per the PAPR, bit 0 of byte 64 in pa-features property indicates
>>> availability of 2nd DAWR registers. i.e. If this bit is set, 2nd
>>> DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to
>>> find whether kvm supports 2nd DAWR or not. If it's supported, allow
>>> user to set the pa-feature bit in guest DT using cap-dawr1 machine
>>> capability. Though, watchpoint on powerpc TCG guest is not supported
>>> and thus 2nd DAWR is not enabled for TCG mode.
>>>
>>> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
>>> Reviewed-by: Greg Kurz <groug@kaod.org>
>>
>> So, I'm actually not sure if using an spapr capability is what we want
>> to do here.  The problem is that presumably the idea is to at some
>> point make the DAWR1 capability default to on (on POWER10, at least).
>> But at that point you'll no longer to be able to start TCG guests
>> without explicitly disabling it.  That's technically correct, since we
>> don't implement DAWR1 in TCG, but then we also don't implement DAWR0
>> and we let that slide... which I think is probably going to cause less
>> irritation on balance.
> 
> Ok. Probably something like this is what you want?
> 
> Power10 behavior:
>   - KVM does not support DAWR1: Boot the guest without DAWR1
>     support (No warnings). Error out only if user tries with
>     cap-dawr1=on.
>   - KVM supports DAWR1: Boot the guest with DAWR1 support, unless
>     user specifies cap-dawr1=off.
>   - TCG guest: Ignore cap-dawr1 i.e. boot as if there is only
>     DAWR0 (Should be fixed in future while adding PowerPC watch-
>     point support in TCG mode)
> 
> Power10 predecessor behavior:
>   - KVM guest: Boot the guest without DAWR1 support. Error out
>     if user tries with cap-dawr1=on.
>   - TCG guest: Ignore cap-dawr1 i.e. boot as if there is only
>     DAWR0 (Should be fixed in future while adding PowerPC watch-
>     point support in TCG mode)
> 
>> I'm wondering if we're actually just better off setting the pa feature
>> just based on the guest CPU model.  TCG will be broken if you try to
>> use it, but then, it already is.  AFAIK there's no inherent reason we
>> couldn't implement DAWR support in TCG, it's just never been worth the
>> trouble.
> 
> Correct. Probably there is no practical usecase for DAWR in TCG mode.

What's the expected behavior ? Is it to generate a DSI if we have a DAWR
match ? 

C. 
 
