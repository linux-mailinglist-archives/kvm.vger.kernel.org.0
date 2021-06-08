Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C0239FD40
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 19:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhFHRLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 13:11:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26161 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232185AbhFHRLN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 13:11:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623172160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4aTv++9v+jHosRvyRVghjaKt2DPiDkrKt5JmZVhhooA=;
        b=YaTjoCpb1dIqcJaCpQy8MKTD3/xGjf66VnnGSlxzJpCJse0Swd7NI3bSLCxwPp0TwfOlAG
        cdpeukHgo1OPrHrayb7Q1OYnjN8LcTlbsMmMITtdw7RfPncnRZvLnbyrBDQ7FQbaKmkmBe
        pHaMR1ItC648BSeu3T8Tle4XRtozlps=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-n4taijigPueArmB3S09vIQ-1; Tue, 08 Jun 2021 13:09:18 -0400
X-MC-Unique: n4taijigPueArmB3S09vIQ-1
Received: by mail-wr1-f72.google.com with SMTP id u5-20020adf9e050000b029010df603f280so9694650wre.18
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 10:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4aTv++9v+jHosRvyRVghjaKt2DPiDkrKt5JmZVhhooA=;
        b=lBqFJlyg+zhc039kpv2+w08NJypNdRSUvD7i9QnCQkpoUaMYa8N9cB3S5vwCtGafnk
         RulCDXiNaYdTyCJ04BW6lushACagHLWvhzR+9VffdCebtrV1fFkWUv6GM1OWYoYfIiyn
         IGCq5ks7Ufv4IhUTzIieLcGtL3dX58P5mVWBWgAyxaEIapTJyp/QDAItvxAK0aBOO+iX
         kwR2SWn5kSbeOM+4JxMlmknjkzHM6XikuLeKDoKZH77zfXYDBPjE7SS1HjAf2/Dwcrxw
         9cRvY6OTyfXtS4uC59uSxr/icVe04WNjD+b7sqcIE9iTLTzYWLu+UVjo5nWu5Lhq49+f
         adMw==
X-Gm-Message-State: AOAM533KiYj69Xsb6UAWlWqMy4kEzo2pK1GbjBXPqRMf2bUogc21O1td
        QJ29bjUvz6Ty1n8t7GGiqkZS2cuvKgcv3DIjwwb1Ht4qnUf8Brlvo0lb/xB2zHK/8qQZNCBShz8
        NIQgix4pMKTzX
X-Received: by 2002:adf:fc0e:: with SMTP id i14mr23914023wrr.71.1623172157756;
        Tue, 08 Jun 2021 10:09:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzg3pijJDkOWV1K1StKFPv9eD9m5caNakqtBsOQvOJiqGjJiVCeQ1fY7daMvHMOukzBkfCpdA==
X-Received: by 2002:adf:fc0e:: with SMTP id i14mr23914001wrr.71.1623172157576;
        Tue, 08 Jun 2021 10:09:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u20sm13394042wmq.24.2021.06.08.10.09.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 10:09:16 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org
References: <20201120095517.19211-1-jiangshanlai@gmail.com>
 <20210603052455.21023-1-jiangshanlai@gmail.com> <YLkYkcn+1MJhQYMf@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V2] KVM: X86: MMU: Use the correct inherited permissions
 to get shadow page
Message-ID: <cbbb803b-a16d-48f5-97d0-916d0eba6a04@redhat.com>
Date:   Tue, 8 Jun 2021 19:09:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YLkYkcn+1MJhQYMf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/06/21 19:59, Sean Christopherson wrote:
> Maybe drop the first two paragraphs and combine the info into something like this?
> 
>    When computing the access permissions of a shadow page, use the effective
>    permissions of the walk up to that point, i.e. the logic AND of its parents'
>    permissions.  Two guest PxE entries that point at the same table gfn need to
>    be shadowed with different shadow pages if their parents' permissions are
>    different.  KVM currently uses the effective permissions of the last
>    non-leaf entry for all non-leaf entries, which can lead to incorrectly
>    reusing a shadow page if a lower-level entry has more restrictve permissions,
>    and eventually result in a missing guest protection page fault.

And also a rewritten description of the sequence leading to the bug:

- First, the guest reads from ptr1 first and KVM prepares a shadow
   page table with role.access=u--, from ptr1's pud1 and ptr1's pmd1.
   "u--" comes from the effective permissions of pgd, pud1 and
   pmd1, which are stored in pt->access.  "u--" is used also to get
   the pagetable for pud1, instead of "uw-".

- Then the guest writes to ptr2 and KVM reuses pud1 which is present.
   The hypervisor set up a shadow page for ptr2 with pt->access is "uw-".
   However the pud1 pmdthe pud1 pmd (because of the incorrect argument to
   kvm_mmu_get_page in the previous step) has role.access="u--".

- Then the guest reads from ptr3.  The hypervisor reuses pud1's
   shadow pmd for pud2, because both use "u--" for their permissions.
   Thus, the shadow pmd already includes entries for both pmd1 and pmd2.

- At last, the guest writes to ptr4.  This causes no vmexit or pagefault,
   because pud1's shadow page structures included an "uw-" page even though
   its role.access was "u--".

Queued, thanks.

Paolo

