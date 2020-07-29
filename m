Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C88231C2E
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 11:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgG2JfK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 05:35:10 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:8150 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgG2JfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 05:35:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596015309; x=1627551309;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=CPmDRa3vuqU1bbMybyLZQXed2NrY1QiIjCcEH2vVDEM=;
  b=Sp0yevnku/n+yQedw3Xt7zNCXi+x1jJqczQy5zal1aPJfJszI7j5u/wv
   hP5/Wd0onpiunVHSA/1y4upZfwpqzREZiSUVvL6y06kh3LHSWLYQqJ9TV
   vDnU9+7PQDvcTO0Tu9qWYI33ijTdk7UC2JLfaA66ja43tgCBEFurd7PXh
   E=;
IronPort-SDR: w2DBh91tML0IAP7do9j+bfo0znMxsdkk2qzBipPBtq7ve6zc2+h2HCUWOv6iF0xyqoe3P2heAy
 6Nem7+gPmiXw==
X-IronPort-AV: E=Sophos;i="5.75,409,1589241600"; 
   d="scan'208";a="44781944"
Subject: Re: [PATCH] KVM: x86: Deflect unknown MSR accesses to user space
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 29 Jul 2020 09:35:08 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 5C5FFA22AD;
        Wed, 29 Jul 2020 09:35:04 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 29 Jul 2020 09:35:03 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.203) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 29 Jul 2020 09:35:00 +0000
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
 <173948e8-4c7a-6dc4-de17-99151bc56d91@amazon.com>
 <87pn8ellp6.fsf@vitty.brq.redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <983a46c5-c5e2-ce12-f1e9-19ed0040f5dc@amazon.com>
Date:   Wed, 29 Jul 2020 11:34:58 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87pn8ellp6.fsf@vitty.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.203]
X-ClientProxiedBy: EX13D38UWC003.ant.amazon.com (10.43.162.23) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 29.07.20 11:22, Vitaly Kuznetsov wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you can confirm the sender and know t=
he content is safe.
> =

> =

> =

> Alexander Graf <graf@amazon.com> writes:
> =

>> On 29.07.20 10:23, Vitaly Kuznetsov wrote:
>>>
>>>
>>>
>>> Jim Mattson <jmattson@google.com> writes:
>>>
>>>> On Tue, Jul 28, 2020 at 5:41 AM Alexander Graf <graf@amazon.com> wrote:
>>>>>
>>>
>>> ...
>>>
>>>>> While it does feel a bit overengineered, it would solve the problem t=
hat
>>>>> we're turning in-KVM handled MSRs into an ABI.
>>>>
>>>> It seems unlikely that userspace is going to know what to do with a
>>>> large number of MSRs. I suspect that a small enumerated list will
>>>> suffice.
>>>
>>> The list can also be 'wildcarded', i.e.
>>> {
>>>    u32 index;
>>>    u32 mask;
>>>    ...
>>> }
>>>
>>> to make it really short.
>>
>> I like the idea of wildcards, but I can't quite wrap my head around how
>> we would implement ignore_msrs in user space with them?
>>
> =

> For that I think we can still deflect all unknown MSR accesses to
> userspace (when the CAP is enabled of course ) but MSRs which are on the
> list will *have to be deflected*, i.e. KVM can't handle them internally
> without consulting with userspace.
> =

> We can make it tunable through a parameter for CAP enablement if needed.

That would still make the set of MSRs implemented in KVM a de-facto ABI, no?

Another thing that might be worth bringing up here is that we have an =

in-house mechanism to set up a allowlist for KVM handling MSR accesses. =

What if we combine the two?

int kvm_rdmsr(...)
{
     switch (msr) {
     [...]
     default:
         return -ENOENT;
     }
}

int rdmsr(...) {
     if (!has_allowlist || msr_read_is_allowed(msr))
         return kvm_rdmsr();

     return -ENOENT;
}

int handle_rdmsr(...)
{
     switch (rdmsr(msr)) {
     case 0:
         return 1;
     case 1:
         inject_gp();
         return 1;
     case -ENOENT:
         if (cap_msr_exit) {
             run->exit_reason =3D MSR;
             return 0;
         } else {
             inject_gp();
             return 1;
         }
     }
}

That way user space can either say "I don't care what you implement, =

just tell me all the MSRs you could not handle" or it says "I want you =

to handle this exact subset of MSRs, tell me any time there's an out of =

bounds access".

That would give us the best of both worlds, right?


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



