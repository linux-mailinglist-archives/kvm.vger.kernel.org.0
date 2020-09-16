Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299FF26C9BA
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 21:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbgIPTUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 15:20:47 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:33392 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbgIPTTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 15:19:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600283993; x=1631819993;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=4G92LblP+1H6oAa+GVhgexdhtGi8dq80NdTtJ+rzVQk=;
  b=XCYTBjdsdiShTUQyuL95RBx9DWJFdiajQcRisaDc/CJvV7RZ/bK88UuY
   VgM6enNw0tyoroNh8aMlUyqldPVwEYFElckafT/lvLXMQjS8IqPyi2Rj3
   bEc+T62h9gaUbV29yOYG8wASdrUkMbXPUMDS/2pHgRzBgyN5FZQWWJXnr
   w=;
X-IronPort-AV: E=Sophos;i="5.76,434,1592870400"; 
   d="scan'208";a="75575499"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 16 Sep 2020 19:16:04 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id 0698DA1817;
        Wed, 16 Sep 2020 19:15:59 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 19:15:59 +0000
Received: from freeip.amazon.com (10.43.161.146) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 19:15:55 +0000
Subject: Re: [PATCH v6 1/7] KVM: x86: Deflect unknown MSR accesses to user
 space
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Aaron Lewis <aaronlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        kvm list <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200902125935.20646-1-graf@amazon.com>
 <20200902125935.20646-2-graf@amazon.com>
 <CAAAPnDFGD8+5KBCLKERrH0hajHEwU9UdEEGqp3RZu3Lws+5rmw@mail.gmail.com>
 <186ccace-2fad-3db3-0848-cd272b1a64ba@amazon.com>
 <20200916170839.GD10227@sjchrist-ice>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <f45fb79a-d09a-bdbb-8529-77219171435b@amazon.com>
Date:   Wed, 16 Sep 2020 21:15:53 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200916170839.GD10227@sjchrist-ice>
Content-Language: en-US
X-Originating-IP: [10.43.161.146]
X-ClientProxiedBy: EX13D45UWB001.ant.amazon.com (10.43.161.115) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16.09.20 19:08, Sean Christopherson wrote:
> =

> On Wed, Sep 16, 2020 at 11:31:30AM +0200, Alexander Graf wrote:
>> On 03.09.20 21:27, Aaron Lewis wrote:
>>>> @@ -412,6 +414,15 @@ struct kvm_run {
>>>>                           __u64 esr_iss;
>>>>                           __u64 fault_ipa;
>>>>                   } arm_nisv;
>>>> +               /* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
>>>> +               struct {
>>>> +                       __u8 error; /* user -> kernel */
>>>> +                       __u8 pad[3];
>>>
>>> __u8 pad[7] to maintain 8 byte alignment?  unless we can get away with
>>> fewer bits for 'reason' and
>>> get them from 'pad'.
>>
>> Why would we need an 8 byte alignment here? I always thought natural u64
>> alignment on x86_64 was on 4 bytes?
> =

> u64 will usually (always?) be 8 byte aligned by the compiler.  "Natural"
> alignment means an object is aligned to its size.  E.g. an 8-byte object
> can split a cache line if it's only aligned on a 4-byte boundary.

For some reason I always thought that x86_64 had a special hack that =

allows u64s to be "naturally" aligned on a 32bit boundary. But I just =

double checked what you said and indeed, gcc does pad it to an actual =

natural boundary.

You never stop learning :).

In that case, it absolutely makes sense to make the padding explicit =

(and pull it earlier)!


Alex




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



