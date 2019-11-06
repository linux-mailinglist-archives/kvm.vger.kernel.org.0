Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4556CF206E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 22:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbfKFVKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 16:10:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726680AbfKFVKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 16:10:34 -0500
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ACE827C0A7
        for <kvm@vger.kernel.org>; Wed,  6 Nov 2019 21:10:33 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id c2so8363881wrt.1
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 13:10:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C3LgI3FZCo4MFBwXeZWw6RGjP/s+c0ceBa3NjK+vj58=;
        b=shV9bVj61lgw6/FTuwtCV956sc80YkzpLYFDtZVKA6OfZosdfTsltWSUNg7SacEIdV
         yHKQx7A0CPrUrHEJ9qDtmTgFMe+w4vcrBj/MnfGQ12RRAnTDwyw9rMaSUbcYXmdgHSYV
         VHbTYBGXdmsVcEgCQyISJ2T7UjhWGaQMAwYfr95BoWDUPht2ZrS3OuzX3s2xMzVJyggD
         VS3UxBZpKrwefNA/K8FHWo6YY2xrhCOVkUdgjkRGyWgLDvtJzitZ4RkijONoLA8Gxe9J
         eDxS4LpS7c9bwRic7M3zwiPYqSU/pHUvsPOTEyofpyEplhzllBUCydptJh+k5CDObqqN
         +Yig==
X-Gm-Message-State: APjAAAWvyyIQS2nQOzJmJwTaBDKqnkFa3sS1Gtj8DarGHSWEwwyWgxkc
        +BPUw5iO8IY0Hu4BREW1f1aVPsS+mgCyYj6wizo6Oicja92ozW7tht+xoxB/CmFw3rvXB8UrAzM
        jnK+XEyJG3ErS
X-Received: by 2002:a1c:ab0a:: with SMTP id u10mr4714783wme.0.1573074632302;
        Wed, 06 Nov 2019 13:10:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqy5XOZTrhpzonDUnIja4CnKgKdNvmgOSOp4dSYjni1Ag4Vj3+2b5CH/cGa2EdkBk6Mn3zZ5IQ==
X-Received: by 2002:a1c:ab0a:: with SMTP id u10mr4714761wme.0.1573074631888;
        Wed, 06 Nov 2019 13:10:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id t185sm4344643wmf.45.2019.11.06.13.10.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2019 13:10:31 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: MMU: Do not treat ZONE_DEVICE pages as being
 reserved
To:     Dan Williams <dan.j.williams@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>
References: <20191106170727.14457-1-sean.j.christopherson@intel.com>
 <20191106170727.14457-2-sean.j.christopherson@intel.com>
 <CAPcyv4gJk2cXLdT2dZwCH2AssMVNxUfdx-bYYwJwy1LwFxOs0w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com>
Date:   Wed, 6 Nov 2019 22:09:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gJk2cXLdT2dZwCH2AssMVNxUfdx-bYYwJwy1LwFxOs0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/19 19:04, Dan Williams wrote:
> On Wed, Nov 6, 2019 at 9:07 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
>>
>> Explicitly exempt ZONE_DEVICE pages from kvm_is_reserved_pfn() and
>> instead manually handle ZONE_DEVICE on a case-by-case basis.  For things
>> like page refcounts, KVM needs to treat ZONE_DEVICE pages like normal
>> pages, e.g. put pages grabbed via gup().  But KVM needs special handling
>> in other flows where ZONE_DEVICE pages lack the underlying machinery,
>> e.g. when setting accessed/dirty bits and shifting refcounts for
>> transparent huge pages.
>>
>> This fixes a hang reported by Adam Borowski[*] in dev_pagemap_cleanup()
>> when running a KVM guest backed with /dev/dax memory, as KVM straight up
>> doesn't put any references to ZONE_DEVICE pages acquired by gup().
>>
>> [*] http://lkml.kernel.org/r/20190919115547.GA17963@angband.pl
>>
>> Reported-by: Adam Borowski <kilobyte@angband.pl>
>> Debugged-by: David Hildenbrand <david@redhat.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> ---
>>  arch/x86/kvm/mmu.c       |  8 ++++----
>>  include/linux/kvm_host.h |  1 +
>>  virt/kvm/kvm_main.c      | 19 +++++++++++++++----
>>  3 files changed, 20 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 24c23c66b226..bf82b1f2e834 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -3306,7 +3306,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>>          * here.
>>          */
>>         if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
>> -           level == PT_PAGE_TABLE_LEVEL &&
>> +           !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
>>             PageTransCompoundMap(pfn_to_page(pfn)) &&
>>             !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
>>                 unsigned long mask;
>> @@ -5914,9 +5914,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>>                  * the guest, and the guest page table is using 4K page size
>>                  * mapping if the indirect sp has level = 1.
>>                  */
>> -               if (sp->role.direct &&
>> -                       !kvm_is_reserved_pfn(pfn) &&
>> -                       PageTransCompoundMap(pfn_to_page(pfn))) {
>> +               if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
>> +                   !kvm_is_zone_device_pfn(pfn) &&
>> +                   PageTransCompoundMap(pfn_to_page(pfn))) {
>>                         pte_list_remove(rmap_head, sptep);
>>
>>                         if (kvm_available_flush_tlb_with_range())
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index a817e446c9aa..4ad1cd7d2d4d 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -966,6 +966,7 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
>>  void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
>>
>>  bool kvm_is_reserved_pfn(kvm_pfn_t pfn);
>> +bool kvm_is_zone_device_pfn(kvm_pfn_t pfn);
>>
>>  struct kvm_irq_ack_notifier {
>>         struct hlist_node link;
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index b8534c6b8cf6..0a781b1fb8f0 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -151,12 +151,23 @@ __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
>>
>>  bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
>>  {
>> +       /*
>> +        * ZONE_DEVICE pages currently set PG_reserved, but from a refcounting
>> +        * perspective they are "normal" pages, albeit with slightly different
>> +        * usage rules.
>> +        */
>>         if (pfn_valid(pfn))
>> -               return PageReserved(pfn_to_page(pfn));
>> +               return PageReserved(pfn_to_page(pfn)) &&
>> +                      !is_zone_device_page(pfn_to_page(pfn));
> 
> This is racy unless you can be certain that the pfn and resulting page
> has already been pinned by get_user_pages().

What is the race exactly?

In general KVM does not use pfn's until after having gotten them from
get_user_pages (or follow_pfn for VM_IO | VM_PFNMAP vmas, for which
get_user_pages fails, but this is not an issue here).  It then creates
the page tables and releases the reference to the struct page.

Anything else happens _after_ the reference has been released, but still
from an mmu notifier; this is why KVM uses pfn_to_page quite pervasively.

If this is enough to avoid races, then I prefer Sean's patch.  If it is
racy, we need to fix kvm_set_pfn_accessed and kvm_set_pfn_dirty first,
and second at transparent_hugepage_adjust and kvm_mmu_zap_collapsible_spte:

- if accessed/dirty state need not be tracked properly for ZONE_DEVICE,
then I suppose David's patch is okay (though I'd like to have a big
comment explaining all the things that went on in these emails).  If
they need to work, however, Sean's patch 1 is the right thing to do.

- if we need Sean's patch 1, but it is racy to use is_zone_device_page,
we could first introduce a helper similar to kvm_is_hugepage_allowed()
from his patch 2, but using pfn_to_online_page() to filter out
ZONE_DEVICE pages.  This would cover both transparent_hugepage_adjust
and kvm_mmu_zap_collapsible_spte.

> This is why I told David
> to steer clear of adding more is_zone_device_page() usage, it's
> difficult to audit. Without an existing pin the metadata to determine
> whether a page is ZONE_DEVICE or not could be in the process of being
> torn down. Ideally KVM would pass around a struct { struct page *page,
> unsigned long pfn } tuple so it would not have to do this "recall
> context" dance on every pfn operation.

Unfortunately once KVM has created its own page tables, the struct page*
reference is lost, as the PFN is the only thing that is stored in there.

Paolo
