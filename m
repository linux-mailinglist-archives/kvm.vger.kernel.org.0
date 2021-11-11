Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3725744D7A1
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 14:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhKKN6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 08:58:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51396 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233606AbhKKN6H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 08:58:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636638918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g/O3KZZnG+ccwWmHRiMCF5W2rXYwMiUgl7PZMmdn82M=;
        b=Yu3YmGMxAwc5a6OLPeVuK+A5u93EJqd8SVUC+s/pvMrIjvyiHBX2O+v/PJadyBcmsYVVQT
        z6vW043WVjQv4eJHS51m7c+bEaolPBadkWMGlTaLcjUkGY0pahf4HC47/5AojQgXjEFNWe
        t0s/t8PiuTTQCWNAAKTZMf1qOMmwg0M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-xX0h9pchNgKADU51X8vhlQ-1; Thu, 11 Nov 2021 08:55:07 -0500
X-MC-Unique: xX0h9pchNgKADU51X8vhlQ-1
Received: by mail-ed1-f71.google.com with SMTP id o15-20020a056402438f00b003e32b274b24so5418077edc.21
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 05:55:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g/O3KZZnG+ccwWmHRiMCF5W2rXYwMiUgl7PZMmdn82M=;
        b=NSDSnRDYdQB0xN733aVuC1E0upbivInovRG1LWsUwEZJUj9EYqSexiJuSmxIcuD8u3
         BzkncMmgKrlI+uF0NSJpWWJZvGg8yBNcDgkDYx9ljhhjgUHAILhX8T1gX4LtlukV5svm
         iyGssP2DQyKbIF/AfOU45iM/HGl3hyIeaezH8gVePkRUl7T7c4N6FjPkH1GeR9wDjoxU
         Kyu0pqGtKvJwez08cx43olf11RHWATeKfkgij6qflvlsGopkD+Nfb+qcfzJArA2dCxpK
         WLrlOfA9et7JF2N0LlnJI8v8Atx1Hn4VlhMAKskD5YX8/D59LKPtKDKHifLvENyz62bi
         rkAg==
X-Gm-Message-State: AOAM531AXqQV+YecPEmjTbvRUvUbjand/qb1kwW8bOwARrNkHN0+Tnr3
        W3AVSAy+cSRvC9IFe1Q99jfv9h8LgBV/FIBVS++KtBZhEpYq61lO77dhbzumCPfLvRhkLpzUiFP
        tbnoFbe7oebTj
X-Received: by 2002:a05:6402:5113:: with SMTP id m19mr10210796edd.312.1636638906088;
        Thu, 11 Nov 2021 05:55:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfni8DXOFxX2t4/GgCBPDg66P/OOyyWROYxX22BmgJ1VW9i1ieIX3iJi4oFOlmw0V/JDNDHQ==
X-Received: by 2002:a05:6402:5113:: with SMTP id m19mr10210761edd.312.1636638905861;
        Thu, 11 Nov 2021 05:55:05 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id u16sm1586313edr.43.2021.11.11.05.55.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 05:55:05 -0800 (PST)
Message-ID: <1ee5abd9-0f5a-06d3-7160-b73b6bbc547d@redhat.com>
Date:   Thu, 11 Nov 2021 14:55:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 0/7] KVM: nSVM: avoid TOC/TOU race when checking vmcb12
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20211103140527.752797-1-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211103140527.752797-1-eesposit@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/21 15:05, Emanuele Giuseppe Esposito wrote:
> Currently there is a TOC/TOU race between the check of vmcb12's
> efer, cr0 and cr4 registers and the later save of their values in
> svm_set_*, because the guest could modify the values in the meanwhile.
> 
> To solve this issue, this series introduces and uses svm->nested.save
> structure in enter_svm_guest_mode to save the current value of efer,
> cr0 and cr4 and later use these to set the vcpu->arch.* state.
> 
> Similarly, svm->nested.ctl contains fields that are not used, so having
> a full vmcb_control_area means passing uninitialized fields.
> 
> Patches 1,3 and 8 take care of renaming and refactoring code.
> Patches 2 and 6 introduce respectively vmcb_ctrl_area_cached and
> vmcb_save_area_cached.
> Patches 4 and 5 use vmcb_save_area_cached to avoid TOC/TOU, and patch
> 7 uses vmcb_ctrl_area_cached.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

Queued (for 5.17).  I changed the helper functions to have a "__" prefix 
since that's more common in Linux.

Paolo

> 
> ---
> v5:
> * rebased on kvm/queue branch
> 
> v4:
> * introduce _* helpers (_nested_vmcb_check_save,
>    _nested_copy_vmcb_control_to_cache, _nested_copy_vmcb_save_to_cache)
>    that take care of additional parameters.
> * svm_set_nested_state: introduce {save, ctl}_cached variables
>    to not pollute svm->nested.{save,ctl} state, especially if the
>    check fails. remove also unnecessary memset added in previous versions.
> * svm_get_nested_state: change stack variable ctl introduced in this series
>   into a pointer that will be zeroed and freed after it has been copied to user
> 
> v3:
> * merge this series with "KVM: nSVM: use vmcb_ctrl_area_cached instead
>    of vmcb_control_area in nested state"
> * rename "nested_load_save_from_vmcb12" in
>    "nested_copy_vmcb_save_to_cache"
> * rename "nested_load_control_from_vmcb12" in
>    "nested_copy_vmcb_control_to_cache"
> * change check functions (nested_vmcb_valid_sregs and nested_vmcb_valid_sregs)
>    to accept only the vcpu parameter, since we only check
>    nested state now
> * rename "vmcb_is_intercept_cached" in "vmcb12_is_intercept"
>    and duplicate the implementation instead of calling vmcb_is_intercept
> 
> v2:
> * svm->nested.save is a separate struct vmcb_save_area_cached,
>    and not vmcb_save_area.
> * update also vmcb02->cr3 with svm->nested.save.cr3
> 
> RFC:
> * use svm->nested.save instead of local variables.
> * not dependent anymore from "KVM: nSVM: remove useless kvm_clear_*_queue"
> * simplified patches, we just use the struct and not move the check
>    nearer to the TOU.
> 
> Emanuele Giuseppe Esposito (7):
>    KVM: nSVM: move nested_vmcb_check_cr3_cr4 logic in
>      nested_vmcb_valid_sregs
>    nSVM: introduce smv->nested.save to cache save area fields
>    nSVM: rename nested_load_control_from_vmcb12 in
>      nested_copy_vmcb_control_to_cache
>    nSVM: use vmcb_save_area_cached in nested_vmcb_valid_sregs()
>    nSVM: use svm->nested.save to load vmcb12 registers and avoid TOC/TOU
>      races
>    nSVM: introduce struct vmcb_ctrl_area_cached
>    nSVM: use vmcb_ctrl_area_cached instead of vmcb_control_area in struct
>      svm_nested_state
> 
>   arch/x86/kvm/svm/nested.c | 250 ++++++++++++++++++++++++--------------
>   arch/x86/kvm/svm/svm.c    |   7 +-
>   arch/x86/kvm/svm/svm.h    |  59 ++++++++-
>   3 files changed, 213 insertions(+), 103 deletions(-)
> 

