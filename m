Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC03444288
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 14:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhKCNkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 09:40:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36845 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230282AbhKCNkP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 09:40:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635946659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rMu63iUD3r/xeDyMQoKUwAY/LuoKz9YzLTb2ev00ODY=;
        b=PfVAtf1oFN2Zcqw2f7dD5ljQMdoOK+XkhGoMQS2Suxz2h+fDA+E/vrCUWurJDSwJCP/2qo
        e1j7247Oo5zOgt+dPTI20X2Iy+cfx+lszJsNTZl2PgX1MD3/H+atd9eN+MnrqRnnKoyroy
        bPBaZLlx4vTsYKg0FazSWi1ptAL1bAM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-KK0j65ptMh2c_JXIQmTp2w-1; Wed, 03 Nov 2021 09:37:37 -0400
X-MC-Unique: KK0j65ptMh2c_JXIQmTp2w-1
Received: by mail-wr1-f72.google.com with SMTP id f1-20020a5d64c1000000b001611832aefeso427605wri.17
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 06:37:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rMu63iUD3r/xeDyMQoKUwAY/LuoKz9YzLTb2ev00ODY=;
        b=tQ6T+UJdubjrEsR5LNDolE7WQtdqTKU3dDlsyToTNeKhT6j12mpvoyloUjVbCgrRZo
         a8v4zIihIR/hGRdjWZkZvTPuYmdMz+znPD6t1ZJhzCfn6k///n0jx/vnxAwuFGjVM8P+
         CbC9AHMLrAddvErifep02ftS6BMpDm36uAJptdIsPzbiX+A8qny+0cuWzNNu3PpxJGqH
         +y7DyjwE0fevanmuptZuFxvXocQkr+ne/r6sPm8s69wAV7C3sWEXhHyROZYCAhO35mRl
         AY/F7r6BpTMhpqvQmlYNUXuNmYOcWyBkjDeAr4rcCI5OzGI2fzpj98uDhWEQBwo3x/me
         ZK6w==
X-Gm-Message-State: AOAM5326vSZiI2gLqOMwkaVoIB/kOS9+SUgQXRPo7VRUcheIg4QxJ0tt
        RMmDNxfV97Ylr7fAGL8W34VAuu6RWtvclxZTZaY1ahr59brYe/X2Ox70N3ILNjgIfNPH07/YgaK
        qhdpp/+X/rtCF
X-Received: by 2002:adf:fa0b:: with SMTP id m11mr2373016wrr.152.1635946656686;
        Wed, 03 Nov 2021 06:37:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCs2xSr7v8Y7euJQWLhn6ADY5m5To8G9MDDka3tTWPgV+611WBhEykKk8wQsUWt3yKaOVuvw==
X-Received: by 2002:adf:fa0b:: with SMTP id m11mr2372983wrr.152.1635946656506;
        Wed, 03 Nov 2021 06:37:36 -0700 (PDT)
Received: from localhost.localdomain ([2a04:ee41:4:31cb:e591:1e1e:abde:a8f1])
        by smtp.gmail.com with ESMTPSA id h15sm1752271wmq.32.2021.11.03.06.37.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 06:37:35 -0700 (PDT)
Subject: Re: [PATCH v4 0/7] KVM: nSVM: avoid TOC/TOU race when checking vmcb12
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20211103115230.720154-1-eesposit@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <bbf65931-6f5b-7017-df7c-54789fe7c833@redhat.com>
Date:   Wed, 3 Nov 2021 14:37:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211103115230.720154-1-eesposit@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Apologies, I did not rebase this series on kvm/queue branch, but on 
linux/master. I will rebase and resend once more.

Emanuele

On 03/11/2021 12:52, Emanuele Giuseppe Esposito wrote:
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
> 
> ---
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
>   arch/x86/kvm/svm/svm.h    |  57 ++++++++-
>   3 files changed, 212 insertions(+), 102 deletions(-)
> 

