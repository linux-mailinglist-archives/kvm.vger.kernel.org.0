Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CF51F3755
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 11:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgFIJyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 05:54:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54335 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726765AbgFIJyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 05:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591696453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SC9syHJzq6iNk5VKVHnGheNpsoiQBFm88X04rtBYN08=;
        b=Dg1clPLs289AJsYV0AzFGCaU6Q/dcpoHc7LosfKzz4s+Dgpgl19Biah8ENIoZ9fyIWmNln
        PusxZsJ0ZsSfjkeyXWVxuBqsdRjvvKA12xD91epwupyx8RpttLX9KJdlXRfM8aFi9Cdsli
        KyAuS+Mfp4hitb8uKDWE4p1ghaXIfFk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-SCcVfcc3NkOXZqnHJypDlQ-1; Tue, 09 Jun 2020 05:54:11 -0400
X-MC-Unique: SCcVfcc3NkOXZqnHJypDlQ-1
Received: by mail-wr1-f72.google.com with SMTP id i6so6786412wrr.23
        for <kvm@vger.kernel.org>; Tue, 09 Jun 2020 02:54:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SC9syHJzq6iNk5VKVHnGheNpsoiQBFm88X04rtBYN08=;
        b=EA7wo7GPt8WmooHhqdDWg2pSjBtq18d75LjfBNKnMjvOypweAK3LYbDxBN2jxKiHMY
         H3CVd9Q3RYlKit+l4eGfjzXeEox+0eBHw34qwF+UHAd2MUZon2B8g1D34+dRlj9tIdpA
         A+33kypiPe4/UxSzefdED+R4shKFUX60G2EYms43WE0lJSiFhTEFz39jfqSuxtaHfKQb
         HwzylTElxoL9VIdYSp8PsSq/aYSCKnOTBYcMYa8GpGORxiaVCLvKcxvQWesj1VbYjFEJ
         A68kQfB4Ym8ydabhM4qbT+0VlrT/8QhryKbJK3AeYZuF4ETZqJWYkvkoV7flqlmIaEf0
         g55g==
X-Gm-Message-State: AOAM533T26ybP6vgLppU3MKEmI7TKrnOkux9w6LTn4c2cluXQc/ejafz
        QVgEC0VA+7xQgeF9SIc/PHaxxz/FzFXVtIdF68/oge+6pFGZCCrSs8OxHDFVSN5WIdjSYLyHbj6
        S73shq+VxSLw4
X-Received: by 2002:adf:910e:: with SMTP id j14mr3319821wrj.278.1591696450441;
        Tue, 09 Jun 2020 02:54:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNaCwWIicA8xSDlpgm/W3oiuEgYalTH4d6fD5Fqj+9Mro5lSmTaPsGiPPa7w/Cmzt0VCbrlw==
X-Received: by 2002:adf:910e:: with SMTP id j14mr3319797wrj.278.1591696450189;
        Tue, 09 Jun 2020 02:54:10 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.172.168])
        by smtp.gmail.com with ESMTPSA id n189sm2309651wmb.43.2020.06.09.02.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 02:54:09 -0700 (PDT)
Subject: Re: [RFC PATCH] KVM: x86: Fix APIC page invalidation race
To:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Cc:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Franciosi <felipe@nutanix.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200606042627.61070-1-eiichi.tsukata@nutanix.com>
 <0d9b3313-5d4c-9ef3-63e4-ba08ddbbe7a1@redhat.com>
 <7B9024C7-98D0-4940-91AE-40BCDE555C8F@nutanix.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6d2d2faf-116f-8c71-fda2-3fc052952dee@redhat.com>
Date:   Tue, 9 Jun 2020 11:54:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <7B9024C7-98D0-4940-91AE-40BCDE555C8F@nutanix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/20 03:04, Eiichi Tsukata wrote:
> 
> 
>> On Jun 8, 2020, at 22:13, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 06/06/20 06:26, Eiichi Tsukata wrote:
>>> Commit b1394e745b94 ("KVM: x86: fix APIC page invalidation") tried to
>>> fix inappropriate APIC page invalidation by re-introducing arch specific
>>> kvm_arch_mmu_notifier_invalidate_range() and calling it from
>>> kvm_mmu_notifier_invalidate_range_start. But threre could be the
>>> following race because VMCS APIC address cache can be updated
>>> *before* it is unmapped.
>>>
>>> Race:
>>>  (Invalidator) kvm_mmu_notifier_invalidate_range_start()
>>>  (Invalidator) kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD)
>>>  (KVM VCPU) vcpu_enter_guest()
>>>  (KVM VCPU) kvm_vcpu_reload_apic_access_page()
>>>  (Invalidator) actually unmap page
>>>
>>> Symptom:
>>>  The above race can make Guest OS see already freed page and Guest OS
>>> will see broken APIC register values.
>>
>> This is not exactly the issue.  The values in the APIC-access page do
>> not really matter, the problem is that the host physical address values
>> won't match between the page tables and the APIC-access page address.
>> Then the processor will not trap APIC accesses, and will instead show
>> the raw contents of the APIC-access page (zeroes), and cause the crash
>> as you mention below.
>>
>> Still, the race explains the symptoms and the patch matches this text in
>> include/linux/mmu_notifier.h:
>>
>> 	 * If the subsystem
>>         * can't guarantee that no additional references are taken to
>>         * the pages in the range, it has to implement the
>>         * invalidate_range() notifier to remove any references taken
>>         * after invalidate_range_start().
>>
>> where the "additional reference" is in the VMCS: because we have to
>> account for kvm_vcpu_reload_apic_access_page running between
>> invalidate_range_start() and invalidate_range_end(), we need to
>> implement invalidate_range().
>>
>> The patch seems good, but I'd like Andrea Arcangeli to take a look as
>> well so I've CCed him.
>>
>> Thank you very much!
>>
>> Paolo
>>
> 
> Hello Paolo
> 
> Thanks for detailed explanation!
> I’ll fix the commit message like this:

No need to resend, the patch is good.  Here is my take on the commit message:

    Commit b1394e745b94 ("KVM: x86: fix APIC page invalidation") tried
    to fix inappropriate APIC page invalidation by re-introducing arch
    specific kvm_arch_mmu_notifier_invalidate_range() and calling it from
    kvm_mmu_notifier_invalidate_range_start. However, the patch left a
    possible race where the VMCS APIC address cache is updated *before*
    it is unmapped:
    
      (Invalidator) kvm_mmu_notifier_invalidate_range_start()
      (Invalidator) kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD)
      (KVM VCPU) vcpu_enter_guest()
      (KVM VCPU) kvm_vcpu_reload_apic_access_page()
      (Invalidator) actually unmap page
    
    Because of the above race, there can be a mismatch between the
    host physical address stored in the APIC_ACCESS_PAGE VMCS field and
    the host physical address stored in the EPT entry for the APIC GPA
    (0xfee0000).  When this happens, the processor will not trap APIC
    accesses, and will instead show the raw contents of the APIC-access page.
    Because Windows OS periodically checks for unexpected modifications to
    the LAPIC register, this will show up as a BSOD crash with BugCheck
    CRITICAL_STRUCTURE_CORRUPTION (109) we are currently seeing in
    https://bugzilla.redhat.com/show_bug.cgi?id=1751017.
    
    The root cause of the issue is that kvm_arch_mmu_notifier_invalidate_range()
    cannot guarantee that no additional references are taken to the pages in
    the range before kvm_mmu_notifier_invalidate_range_end().  Fortunately,
    this case is supported by the MMU notifier API, as documented in
    include/linux/mmu_notifier.h:
    
             * If the subsystem
             * can't guarantee that no additional references are taken to
             * the pages in the range, it has to implement the
             * invalidate_range() notifier to remove any references taken
             * after invalidate_range_start().
    
    The fix therefore is to reload the APIC-access page field in the VMCS
    from kvm_mmu_notifier_invalidate_range() instead of ..._range_start().

Thanks,

Paolo

