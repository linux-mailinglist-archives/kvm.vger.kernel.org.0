Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB8A262AAC
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 10:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIIIn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 04:43:57 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:2290 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgIIIn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 04:43:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599641036; x=1631177036;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=lHG13q4oh+i/9HDrkU/99B0v9sg5oHwRUwfGLVJvGbg=;
  b=RhY6+MShDX+qvEDN+LmEU3RFXuPXGoWIjvh2cgi9Dx0a8cCxTIMvSHOc
   qxHh2afD42H+dMZzUtDSGg4zXNCx42HyzaVDmzw9Adf+UahSP07A1Iud2
   yICoKtFenuMASoRgWtsQcQl7Y0rH2pu/NVOz90+OPPhZTlz0Y5q4euVS9
   Q=;
X-IronPort-AV: E=Sophos;i="5.76,409,1592870400"; 
   d="scan'208";a="74720871"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 09 Sep 2020 08:43:51 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 67F78A1836;
        Wed,  9 Sep 2020 08:43:50 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 9 Sep 2020 08:43:49 +0000
Received: from Alexanders-MacBook-Air.local (10.43.162.55) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 9 Sep 2020 08:43:46 +0000
Subject: Re: [PATCH v2] KVM: arm64: Allow to limit number of PMU counters
To:     Andrew Jones <drjones@redhat.com>
CC:     <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>
References: <20200908205730.23898-1-graf@amazon.com>
 <20200909062534.zsqadaeewfeqsgsj@kamzik.brq.redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <fcb9ccab-2118-af76-3109-4d491d888c7c@amazon.com>
Date:   Wed, 9 Sep 2020 10:43:41 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200909062534.zsqadaeewfeqsgsj@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.55]
X-ClientProxiedBy: EX13D17UWC003.ant.amazon.com (10.43.162.206) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Drew!

On 09.09.20 08:25, Andrew Jones wrote:
> =

> On Tue, Sep 08, 2020 at 10:57:30PM +0200, Alexander Graf wrote:
>> We currently pass through the number of PMU counters that we have availa=
ble
>> in hardware to guests. So if my host supports 10 concurrently active PMU
>> counters, my guest will be able to spawn 10 counters as well.
>>
>> This is undesireable if we also want to use the PMU on the host for
>> monitoring. In that case, we want to split the PMU between guest and
>> host.
>>
>> To help that case, let's add a PMU attr that allows us to limit the numb=
er
>> of PMU counters that we expose. With this patch in place, user space can
>> keep some counters free for host use.
> =

> Hi Alex,
> =

> Is there any reason to use the device API instead of just giving the user
> control over the necessary PMCR_EL0 bits through set/get-one-reg?

I mostly used the attr interface because I was in that particular mental =

mode after looking at the filtering bits :).

Today, the PMCR_EL0 register gets reset implicitly on every vcpu reset =

call. How would we persist the counter field across resets? Would we in =

the first place?

I'm slightly hazy how the ONE_REG API would look like here. Do you have =

recommendations?


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



