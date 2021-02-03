Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6D230D4B9
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 09:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhBCIMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 03:12:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232517AbhBCIMU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 03:12:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612339854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qxlXtUCPUeDfRWWdGs58ehxYjicvlUrYs8aprR3WwAE=;
        b=XJtnqlg5aTvBtbWzC57vY78urAR7wdgdjrlrHiAmPi4kL193eAuLoB2Knf3WTpcRvYN0M6
        /u8r8mhPH6TC6AUpitgXD6+MkuWLTG7hRInOebpOH5mVYzW4YmeOxzNktLwXY5786fOYjs
        WUNmxI/h2AXtlG/ICtVKqPCykwIJN/U=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-Th6WZHO2NNO_uGGlscf03g-1; Wed, 03 Feb 2021 03:10:52 -0500
X-MC-Unique: Th6WZHO2NNO_uGGlscf03g-1
Received: by mail-ej1-f70.google.com with SMTP id dc21so11541328ejb.19
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 00:10:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qxlXtUCPUeDfRWWdGs58ehxYjicvlUrYs8aprR3WwAE=;
        b=iZUIilSsOBhUFb1vgPsT7Du0wGtT5O3Kcf0i9XjGEot34m4yZ+ZgiKl3kiHRr2f3BH
         wNieV6K12HcQJsjRTc0SuWJU7i6o9FjJ8ttyXpA0f22dCHr4y/EBzzpMzojGqvkFK9xb
         FSYVGxPiZzhJxG9OeByJPVdXoMPvC2L9Jl68ahhzDZmHj2n++Hc8Uzoh024iZYZlbGLl
         l9/ewlhqPIsh18XOBTxW4gysMndImuLMYVsrsEc15X1q1QKg3tGRrc676IodoFYkrer7
         20X8NP2gKWesIBli4eDTH8SaSzzuUjmaHf5scCdi5CUQyW9LQUOvPncnFszaoEOzB4W2
         z7FA==
X-Gm-Message-State: AOAM531HHwB/5St/xebAP7FjPqcQD+BxitRJESmXuVFOjmzC55NW1YT3
        olE6g8rrxW+0KcEJxP0GqpXWzrJ2WQNyCj8wC4P/1wfw0JiTu60ljOXP+hTXRBpQzsq/trEBefq
        7VIqjq5LI+UBF
X-Received: by 2002:a17:906:3a13:: with SMTP id z19mr2089431eje.317.1612339851653;
        Wed, 03 Feb 2021 00:10:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzYcHpwc0BPgrV3N2uDbuR6bYtfOV5NkueP9/jpG4V6U9MMpK9Zj+GI5O9JjhnaMhgYAv3E9g==
X-Received: by 2002:a17:906:3a13:: with SMTP id z19mr2089410eje.317.1612339851484;
        Wed, 03 Feb 2021 00:10:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o10sm625592eju.89.2021.02.03.00.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 00:10:50 -0800 (PST)
Subject: Re: [PATCH v4 0/3] KVM: SVM: Refactor vcpu_load/put to use
 vmload/vmsave for host state
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20210202190126.2185715-1-michael.roth@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bad29417-94de-bbf6-a2ea-765bfc78f25b@redhat.com>
Date:   Wed, 3 Feb 2021 09:10:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202190126.2185715-1-michael.roth@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 20:01, Michael Roth wrote:
> Hi Sean, Paolo,
> 
> Following up from previous v3 discussion:
> 
>    https://lore.kernel.org/kvm/X%2FSfw15OWarseivB@google.com/
> 
> I got bit in internal testing by a bug in v3 of this series that Sean had
> already pointed out in v3 comments, so I thought it might be good to go
> ahead and send a v4 with those fixes included. I also saw that Sean's vmsave
> helpers are now in kvm/queue, so I've rebased these on top of those, and
> made use of the new vmsave/vmload helpers:
> 
>    https://lore.kernel.org/kvm/8880fedc-14aa-1f14-b87b-118ebe0932a2@redhat.com/
> 
> Thanks!
> 
> -Mike
> 
> = Overview =
> 
> This series re-works the SVM KVM implementation to use vmload/vmsave to
> handle saving/restoring additional host MSRs rather than explicit MSR
> read/writes, resulting in a significant performance improvement for some
> specific workloads and simplifying some of the save/load code (PATCH 1).
> 
> With those changes some commonalities emerge between SEV-ES and normal
> vcpu_load/vcpu_put paths, which we then take advantage of to share more code,
> as well as refactor them in a way that more closely aligns with the VMX
> implementation (PATCH 2 and 3).

Queued, thanks.

Paolo

> v4:
>   - rebased on kvm/queue
>   - use sme_page_pa() when accessing save area (Sean)
>   - make sure vmload during host reboot is handled (Sean)
>   - introduce vmload() helper like we have with vmsave(), use that instead
>     of moving the introduce to ASM (Sean)
> 
> v3:
>   - rebased on kvm-next
>   - remove uneeded braces from host MSR save/load loops (Sean)
>   - use page_to_phys() in place of page_to_pfn() and shifting (Sean)
>   - use stack instead of struct field to cache host save area outside of
>     per-cpu storage, and pass as an argument to __svm_vcpu_run() to
>     handle the VMLOAD in ASM code rather than inlining ASM (Sean/Andy)
>   - remove now-uneeded index/sev_es_restored fields from
>     host_save_user_msrs list
>   - move host-saving/guest-loading of registers to prepare_guest_switch(),
>     and host-loading of registers to prepare_host_switch, for both normal
>     and sev-es paths (Sean)
> 
> v2:
>   - rebase on latest kvm/next
>   - move VMLOAD to just after vmexit so we can use it to handle all FS/GS
>     host state restoration and rather than relying on loadsegment() and
>     explicit write to MSR_GS_BASE (Andy)
>   - drop 'host' field from struct vcpu_svm since it is no longer needed
>     for storing FS/GS/LDT state (Andy)
> 
>   arch/x86/kvm/svm/sev.c     |  30 +-----------------------------
>   arch/x86/kvm/svm/svm.c     | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------
>   arch/x86/kvm/svm/svm.h     |  29 +++++------------------------
>   arch/x86/kvm/svm/svm_ops.h |   5 +++++
>   4 files changed, 67 insertions(+), 104 deletions(-)
> 
> 

