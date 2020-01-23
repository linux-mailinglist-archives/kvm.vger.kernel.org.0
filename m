Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 805E2147179
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 20:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgAWTJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 14:09:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42453 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728709AbgAWTJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 14:09:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579806549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CVnbh8HU2D1CHz2shEx/+7LoktnChzwhzRO+F+tdk+E=;
        b=QdCOrxf2ZmjYgcy5m2JRBy5urepkcKOHbq3HF7+z+YruKE8XjD0zTIHtLDJ6sTCwEII5Dw
        On7E9IpmKkxUOJmuTVHWJI2McFGQzttQZn6TRyd6l4MVlSRr8HkZS8AaN8DdcdXBHvW02i
        N1Ih62o1gdjQyUhncWkymVxBdC9TT8w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-Jvi5OLUBPauaj9toBZ853g-1; Thu, 23 Jan 2020 14:09:06 -0500
X-MC-Unique: Jvi5OLUBPauaj9toBZ853g-1
Received: by mail-wr1-f69.google.com with SMTP id t3so2332304wrm.23
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 11:09:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=CVnbh8HU2D1CHz2shEx/+7LoktnChzwhzRO+F+tdk+E=;
        b=gU6MSaO1RL5r459woKBwhmc75BZWJbbBqWhVE6CLSO7cVjtr5Crs7TVIWdCXa3LsPE
         V3ktq1ttr8A/jNNFZTZPnJr8ICD1PfZMBDV1hyZOomeR8SqC4kAvY8ecTVyts1v/gxzG
         QfciR+NNmSEYSM07nJKMQ7gszaE/h4vD0Skfuqu3sAIQe8hTWx7Z8YOoVKM7rHYh/l9q
         o+dSW3g/g+3CMi/R/GM8e2bheKqg1y3rHZlt5vpzpUX1gsxJEmBtJ150T94TvrNkgwkx
         nE/xCZ6OBRGcXiLMC8U2QllYvhRrBd+dzZ25y3NEt3hQT+KwALyA9y/Z7RmoIy+BbeK1
         98Ew==
X-Gm-Message-State: APjAAAUErKzOksR1HvM+f8aalOY2ikPdod3SReVN+DXtgh9dDfL0YOxt
        CHKfyv/QTeGxpkju6Jq+fEqKWpRmrnkxc3aw01NT5CPDvKdeY8XE5Fd8RMAJLJQXsB/kIWr4rZV
        /ZIemqmRzZKS3
X-Received: by 2002:adf:b64b:: with SMTP id i11mr20131899wre.58.1579806544991;
        Thu, 23 Jan 2020 11:09:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqxhHAI+4XBKY/NA4TwevDsu40I1kE/M4h9jsZP1lj8js0WQLrhkO57jgoIYF23sM7nfjFL84g==
X-Received: by 2002:adf:b64b:: with SMTP id i11mr20131866wre.58.1579806544727;
        Thu, 23 Jan 2020 11:09:04 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t5sm4071069wrr.35.2020.01.23.11.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 11:09:03 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()
In-Reply-To: <87zheer0si.fsf@vitty.brq.redhat.com>
References: <20200115171014.56405-1-vkuznets@redhat.com> <20200115171014.56405-3-vkuznets@redhat.com> <6c4bdb57-08fb-2c2d-9234-b7efffeb72ed@redhat.com> <20200122054724.GD18513@linux.intel.com> <9c126d75-225b-3b1b-d97a-bcec1f189e02@redhat.com> <87eevrsf3s.fsf@vitty.brq.redhat.com> <20200122155108.GA7201@linux.intel.com> <87blqvsbcy.fsf@vitty.brq.redhat.com> <f15d9e98-25e9-2031-2db5-6aaa6c78c0eb@redhat.com> <87zheer0si.fsf@vitty.brq.redhat.com>
Date:   Thu, 23 Jan 2020 20:09:03 +0100
Message-ID: <87lfpyq9bk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Paolo Bonzini <pbonzini@redhat.com> writes:
>
>> On 22/01/20 17:29, Vitaly Kuznetsov wrote:
>>> Yes, in case we're back to the idea to filter things out in QEMU we can
>>> do this. What I don't like is that every other userspace which decides
>>> to enable eVMCS will have to perform the exact same surgery as in case
>>> it sets allow_unsupported_controls=0 it'll have to know (hardcode) the
>>> filtering (or KVM_SET_MSRS will fail) and in case it opts for
>>> allow_unsupported_controls=1 Windows guests just won't boot without the
>>> filtering.
>>> 
>>> It seems to be 1:1, eVMCSv1 requires the filter.
>>
>> Yes, that's the point.  It *is* a hack in KVM, but it is generally
>> preferrable to have an easier API for userspace, if there's only one way
>> to do it.
>>
>> Though we could be a bit more "surgical" and only remove
>> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES---thus minimizing the impact on
>> non-eVMCS guests.  Vitaly, can you prepare a v2 that does that and adds
>> a huge "hack alert" comment that explains the discussion?
>
> Yes, sure. I'd like to do more testing to make sure filtering out
> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES is enough for other Hyper-V
> versions too (who knows how many bugs are there :-)

... and the answer is -- more than one :-)

I've tested Hyper-V 2016/2019 BIOS and UEFI-booted and the minimal
viable set seems to be:

MSR_IA32_VMX_PROCBASED_CTLS2: 
	~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES

MSR_IA32_VMX_ENTRY_CTLS/MSR_IA32_VMX_TRUE_ENTRY_CTLS:
	~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL

MSR_IA32_VMX_EXIT_CTLS/MSR_IA32_VMX_TRUE_EXIT_CTLS:
	~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL
 
with these filtered out all 4 versions are at least able to boot with >1
vCPU and run a nested guest (different from Windows management
partition).

This still feels a bit fragile as who knows under which circumstances
Hyper-V might want to enable additional (missing) controls.

If there are no objections and if we still think it would be beneficial
to minimize the list of controls we filter out (and not go with the full
set like my RFC suggests), I'll prepare v2. (v1, actually, this was RFC).

-- 
Vitaly

