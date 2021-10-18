Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F2943117C
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 09:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhJRHl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 03:41:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27482 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229847AbhJRHlz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 03:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634542784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gq/e4iQK0pmS4v2ScRZGktMJTRyYytBPyL7+HOq1baE=;
        b=Ur5tbP2ICjep6tk3li1xdoByxtgGgKYSovE6zgwRjM3BlJ2cUDOal8VT8bdrpxfADQb+14
        awMfqaedtRcb6aPy+FbI/B895yuclhvqPRzwrF+nAzA9UTegVpsy5Znfql049ZkYxjUi6D
        DZrGJA+fGsGFvzanp917aNAcoY0U0EA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-qu5TyOdcMUOx1Ce5O-DAtA-1; Mon, 18 Oct 2021 03:39:43 -0400
X-MC-Unique: qu5TyOdcMUOx1Ce5O-DAtA-1
Received: by mail-wm1-f72.google.com with SMTP id 204-20020a1c01d5000000b003101167101bso1830550wmb.3
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 00:39:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gq/e4iQK0pmS4v2ScRZGktMJTRyYytBPyL7+HOq1baE=;
        b=eZbA0ZhOYFbZaUTmer8+PCAAjpx3H2v7BA/ajs+3EceSOkhJPeZ/7wK61BnE0J6Kh4
         n1BMOCD1PBG7Iq0R2U2ogGKlxb4ogPHDerZKOOgjQxuMkhDfhsXlt32qPdb1Y7bf+Jua
         rLu7IpXfKnzVAo1yh+ScTg6seZJ1fCP+XBpbMvcEHWjh453KHkJki4uP5pnYuKAWSzgx
         rpJYmvs0NG5lk1jKDymLVi0aYesvqdv9mDaFsR0/xOx87TUDL8G/VQtT9N1j8hAeKTPY
         KhlTPQGrea/1lv+HI617Qbp18RW2Fk6pHpoBEjInp/Yadvb9s29N7hzIFi1aDSQYKkkw
         s6Pg==
X-Gm-Message-State: AOAM530rRy6D64zFOqan1HNsT4ricspCKiEPsLNadUy54pfkYPam5bTy
        26nk2n94VCApCOh+LUIgGCUNB0zLB0AGNYaK4mCKNAMRd0oRuSCfSA/c40N7kYRTUr4Ofnpspps
        9Fy1cv5Dm43Ak
X-Received: by 2002:a1c:a747:: with SMTP id q68mr43206711wme.139.1634542781867;
        Mon, 18 Oct 2021 00:39:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxJjxnbbGnpuWkMwlvtfPm90td1oFICeVZPmZtTAXd6JBKYmrWg3hLPkpjoNqm2TmnRvAOAA==
X-Received: by 2002:a1c:a747:: with SMTP id q68mr43206694wme.139.1634542781666;
        Mon, 18 Oct 2021 00:39:41 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z6sm12059165wro.25.2021.10.18.00.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 00:39:41 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Matlack <dmatlack@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] KVM: SVM: reduce guest MAXPHYADDR by one in case
 C-bit is a physical bit
In-Reply-To: <YWmdLPsa6qccxtEa@google.com>
References: <20211015150524.2030966-1-vkuznets@redhat.com>
 <YWmdLPsa6qccxtEa@google.com>
Date:   Mon, 18 Oct 2021 09:39:40 +0200
Message-ID: <87ee8iye6b.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Oct 15, 2021, Vitaly Kuznetsov wrote:
>> Several selftests (memslot_modification_stress_test, kvm_page_table_test,
>> dirty_log_perf_test,.. ) which rely on vm_get_max_gfn() started to fail
>> since commit ef4c9f4f65462 ("KVM: selftests: Fix 32-bit truncation of
>> vm_get_max_gfn()") on AMD EPYC 7401P:
>> 
>>  ./tools/testing/selftests/kvm/demand_paging_test
>>  Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
>>  guest physical test memory offset: 0xffffbffff000
>
> This look a lot like the signature I remember from the original bug[1].  I assume
> you're hitting the magic HyperTransport region[2].  I thought that was fixed, but
> the hack-a-fix for selftests never got applied[3].
>
> [1] https://lore.kernel.org/lkml/20210623230552.4027702-4-seanjc@google.com/

Hey,

it seems I'm only three months late to the party!

> [2] https://lkml.kernel.org/r/7e3a90c0-75a1-b8fe-dbcf-bda16502ace9@amd.com
> [3] https://lkml.kernel.org/r/20210805105423.412878-1-pbonzini@redhat.com
>

This patch helps indeed, thanks! Paolo, any particular reason you
haven't queued it yet?

>>  Finished creating vCPUs and starting uffd threads
>>  Started all vCPUs
>>  ==== Test Assertion Failure ====
>>    demand_paging_test.c:63: false
>>    pid=47131 tid=47134 errno=0 - Success
>>       1	0x000000000040281b: vcpu_worker at demand_paging_test.c:63
>>       2	0x00007fb36716e431: ?? ??:0
>>       3	0x00007fb36709c912: ?? ??:0
>>    Invalid guest sync status: exit_reason=SHUTDOWN
>> 
>> The commit, however, seems to be correct, it just revealed an already
>> present issue. AMD CPUs which support SEV may have a reduced physical
>> address space, e.g. on AMD EPYC 7401P I see:
>> 
>>  Address sizes:  43 bits physical, 48 bits virtual
>> 
>> The guest physical address space, however, is not reduced as stated in
>> commit e39f00f60ebd ("KVM: x86: Use kernel's x86_phys_bits to handle
>> reduced MAXPHYADDR"). This seems to be almost correct, however, APM has one
>> more clause (15.34.6):
>> 
>>   Note that because guest physical addresses are always translated through
>>   the nested page tables, the size of the guest physical address space is
>>   not impacted by any physical address space reduction indicated in CPUID
>>   8000_001F[EBX]. If the C-bit is a physical address bit however, the guest
>>   physical address space is effectively reduced by 1 bit.
>> 
>> Implement the reduction.
>> 
>> Fixes: e39f00f60ebd (KVM: x86: Use kernel's x86_phys_bits to handle reduced MAXPHYADDR)
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>> - RFC: I may have misdiagnosed the problem as I didn't dig to where exactly
>>  the guest crashes.
>> ---
>>  arch/x86/kvm/cpuid.c | 13 ++++++++++---
>>  1 file changed, 10 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 751aa85a3001..04ae280a0b66 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -923,13 +923,20 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>  		 *
>>  		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
>>  		 * provided, use the raw bare metal MAXPHYADDR as reductions to
>> -		 * the HPAs do not affect GPAs.
>> +		 * the HPAs do not affect GPAs. The value, however, has to be
>> +		 * reduced by 1 in case C-bit is a physical bit (APM section
>> +		 * 15.34.6).
>>  		 */
>> -		if (!tdp_enabled)
>> +		if (!tdp_enabled) {
>>  			g_phys_as = boot_cpu_data.x86_phys_bits;
>> -		else if (!g_phys_as)
>> +		} else if (!g_phys_as) {
>>  			g_phys_as = phys_as;
>>  
>> +			if (kvm_cpu_cap_has(X86_FEATURE_SEV) &&
>> +			    (cpuid_ebx(0x8000001f) & 0x3f) < g_phys_as)
>> +				g_phys_as -= 1;
>
> This is incorrect, non-SEV guests do not see a reduced address space.  See Tom's
> explanation[*]
>
> [*] https://lkml.kernel.org/r/324a95ee-b962-acdf-9bd7-b8b23b9fb991@amd.com
>

I see, thanks for the pointer.

>> +		}
>> +
>>  		entry->eax = g_phys_as | (virt_as << 8);
>>  		entry->edx = 0;
>>  		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
>> -- 
>> 2.31.1
>> 
>

-- 
Vitaly

