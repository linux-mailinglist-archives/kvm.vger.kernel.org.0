Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1251B3B1DD5
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 17:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhFWPwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 11:52:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20279 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231433AbhFWPwB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 11:52:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624463383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tXdBCM10slZlb/55bnauNdGrWpZkExrnqJ+22N/X4ww=;
        b=IleIdMYk/7UGB2l+1ZHC+4wU2kbAHeqd1IUhATdrzO3ViXfaLgqLI1aRQb4NMr9IQ8txdT
        M0uuWb5yzzhavq2/ny7Qd0tkcSnHmvJdd0MdoLBfluXGsicNFR0lRBddI9Jglwl6JPRxAl
        k1yiyrNz/bzGB3E8qhCltF9YhxzUzds=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-Rb131Br6OCKqNpEQY0xeNg-1; Wed, 23 Jun 2021 11:49:42 -0400
X-MC-Unique: Rb131Br6OCKqNpEQY0xeNg-1
Received: by mail-ej1-f71.google.com with SMTP id ci22-20020a170906c356b0290492ca430d87so1135592ejb.14
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 08:49:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tXdBCM10slZlb/55bnauNdGrWpZkExrnqJ+22N/X4ww=;
        b=fqcZ/hWDTTO//n77oZhG+Yj7ztlhUIk8a965gO6uLToaLO6SqcnwIh4L41BvbIcpee
         wZWUMzVUeWYggo6witTBEE09wC/Vz26MGdCZ+qSb5amP4bS34C3UUMkyYtkzS/lASZzX
         8hNLxH/kO7knN4Jq3RWF5F+W0lJfVyN0vRfbGdpn0TQnsq4wpeMuhy1pxckFSCJiDIGQ
         +AW7Ji+pdD4hvXyNmvQwJrxAL1cIJeKiEMDnEicwo1sq1GMklwxLxZI4sTtlVM5B56gK
         w3Oz3oK/2Z9tJoDODXH8uizD/CBok4pVHethPOOv8DBddc0rcu/PqqrTRbN7BS3RMO6b
         5pMQ==
X-Gm-Message-State: AOAM532Lw6LoMx2MvQoug7FYKMNNY0DFPd8RP2Wo78kHRRqJQTXs2nl9
        dSbJoGF9I47X/NuJjFKpPtzMvHUBFUsmsQOWhm5E+8dQlrBhAg1mcJlgp/wR1wEhr7hbBrrbWrn
        Ysv5nzhzawElm
X-Received: by 2002:a17:907:986c:: with SMTP id ko12mr664856ejc.377.1624463380809;
        Wed, 23 Jun 2021 08:49:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0oh+yE6jc4noHd8UNYnAteFUd33tpUfhMoc3jM9EZ0PA4Xd0gj+XsjZpiUF0JwrfRxdkgWw==
X-Received: by 2002:a17:907:986c:: with SMTP id ko12mr664836ejc.377.1624463380599;
        Wed, 23 Jun 2021 08:49:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q20sm78128ejb.71.2021.06.23.08.49.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 08:49:39 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-11-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/54] KVM: x86/mmu: Replace EPT shadow page shenanigans
 with simpler check
Message-ID: <8ce36922-dba0-9b53-6f74-82f3f68b443c@redhat.com>
Date:   Wed, 23 Jun 2021 17:49:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622175739.3610207-11-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 19:56, Sean Christopherson wrote:
> Replace the hack to identify nested EPT shadow pages with a simple check
> that the size of the guest PTEs associated with the shadow page and the
> current MMU match, which is the intent of the "8 bytes == PAE" test.
> The nested EPT hack existed to avoid a false negative due to the is_pae()
> check not matching for 32-bit L2 guests; checking the MMU role directly
> avoids the indirect calculation of the guest PTE size entirely.

What the commit message doesn't say is, did we miss this opportunity all
along, or has there been a change since commit 47c42e6b4192 ("KVM: x86:
fix handling of role.cr4_pae and rename it to 'gpte_size'", 2019-03-28)
that allows this?

I think the only change needed would be making the commit something like
this:

==========
KVM: x86/mmu: Use MMU role to check for matching guest page sizes

Originally, __kvm_sync_page used to check the cr4_pae bit in the role
to avoid zapping 4-byte kvm_mmu_pages when guest page size are 8-byte
or the other way round.  However, in commit 47c42e6b4192 ("KVM: x86: fix
handling of role.cr4_pae and rename it to 'gpte_size'", 2019-03-28) it
was observed that this did not work for nested EPT, where the page table
size would be 8 bytes even if CR4.PAE=0.  (Note that the check still
has to be done for nested *NPT*, so it is not possible to use tdp_enabled
or similar).

Therefore, a hack was introduced to identify nested EPT shadow pages
and unconditionally call __kvm_sync_page() on them.  However, it is
possible to do without the hack to identify nested EPT shadow pages:
if EPT is active, there will be no shadow pages in non-EPT format,
and all of them will have gpte_is_8_bytes set to true; we can just
check the MMU role directly, and the test will always be true.

Even for non-EPT shadow MMUs, this test should really always be true
now that __kvm_sync_page() is called if and only if the role is an
exact match (kvm_mmu_get_page()) or is part of the current MMU context
(kvm_mmu_sync_roots()).  A future commit will convert the likely-pointless
check into a meaningful WARN to enforce that the mmu_roles of the current
context and the shadow page are compatible.
==========


Paolo

> Note, this should be a glorified nop now that __kvm_sync_page() is called
> if and only if the role is an exact match (kvm_mmu_get_page()) or is part
> of the current MMU context (kvm_mmu_sync_roots()).  A future commit will
> convert the likely-pointless check into a meaningful WARN to enforce that
> the mmu_roles of the current context and the shadow page are compatible.
> 
> Cc: Vitaly Kuznetsov<vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson<seanjc@google.com>

