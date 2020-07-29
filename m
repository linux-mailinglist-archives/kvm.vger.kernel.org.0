Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D0B231BD6
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 11:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgG2JJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 05:09:38 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:48659 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgG2JJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 05:09:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596013777; x=1627549777;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=SciFhlKfOyQgoHR3W2u7HoyEVe3pSryfx/QBiBfKds8=;
  b=pmZEnPWomMJY0KtcEhkzCIU6S1wsBHtwU2FcLwE5RL/dyAmflqLrGZpj
   buZtwtLWD+uDJLdYDd1ac6JtjEiCJk0Eck+6RQ88IkdtdHoAO0lENHIRP
   XADF7GesljeYckuvCb62xv+3jD8zNjj3nSTjYS8w81txPOi6IWjs+EKAc
   M=;
IronPort-SDR: iGhMXsEFZ7rmehllBU/6DXbQhQ9ceJjM/OTGQL0+l9iOw433CMybv2oqS2CGcWtQPX5PXSPwfO
 aV5zYwDbdVxA==
X-IronPort-AV: E=Sophos;i="5.75,409,1589241600"; 
   d="scan'208";a="44709903"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 29 Jul 2020 09:09:35 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 4DA8628392C;
        Wed, 29 Jul 2020 09:09:31 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 29 Jul 2020 09:09:31 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.109) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 29 Jul 2020 09:09:28 +0000
Subject: Re: [PATCH] KVM: x86: Deflect unknown MSR accesses to user space
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>
References: <20200728004446.932-1-graf@amazon.com>
 <87d04gm4ws.fsf@vitty.brq.redhat.com>
 <a1f30fc8-09f5-fe2f-39e2-136b881ed15a@amazon.com>
 <CALMp9eQ3OxhQZYiHPiebX=KyvjWQgxQEO-owjSoxgPKsOMRvjw@mail.gmail.com>
 <87y2n2log7.fsf@vitty.brq.redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <173948e8-4c7a-6dc4-de17-99151bc56d91@amazon.com>
Date:   Wed, 29 Jul 2020 11:09:26 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87y2n2log7.fsf@vitty.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.109]
X-ClientProxiedBy: EX13D03UWC003.ant.amazon.com (10.43.162.79) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 29.07.20 10:23, Vitaly Kuznetsov wrote:
> =

> =

> =

> Jim Mattson <jmattson@google.com> writes:
> =

>> On Tue, Jul 28, 2020 at 5:41 AM Alexander Graf <graf@amazon.com> wrote:
>>>
> =

> ...
> =

>>> While it does feel a bit overengineered, it would solve the problem that
>>> we're turning in-KVM handled MSRs into an ABI.
>>
>> It seems unlikely that userspace is going to know what to do with a
>> large number of MSRs. I suspect that a small enumerated list will
>> suffice.
> =

> The list can also be 'wildcarded', i.e.
> {
>   u32 index;
>   u32 mask;
>   ...
> }
> =

> to make it really short.

I like the idea of wildcards, but I can't quite wrap my head around how =

we would implement ignore_msrs in user space with them?


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



