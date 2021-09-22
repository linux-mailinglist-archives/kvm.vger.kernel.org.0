Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C155414C22
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbhIVOhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 10:37:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30714 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236199AbhIVOhb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 10:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632321361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J7r7WZi73y3jeV35KrEBClZuwOQN1huGyHTnf+LlAgM=;
        b=g+6q/fhQFf0jJurUARcNjAfvYUgC3Gbvifin48VPHbIrYRGY/XxpkfBQhrbzXvyOMp3IwU
        +c2oqSZj7pFZQdYlYQxxxGg9HEH0uHMhWgol+KUhKWugLUt9grmNB4r2ug5RN+WoMNI12n
        IQWIjtKungDKP53zjruxtb/4nrCQoh0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-m1GhIckwPT61sS9ZRqHHJg-1; Wed, 22 Sep 2021 10:35:59 -0400
X-MC-Unique: m1GhIckwPT61sS9ZRqHHJg-1
Received: by mail-ed1-f70.google.com with SMTP id h6-20020a50c386000000b003da01adc065so3309300edf.7
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 07:35:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J7r7WZi73y3jeV35KrEBClZuwOQN1huGyHTnf+LlAgM=;
        b=PWYAMZmYLMnKYVCDyo9/Eu3vCrUZUVBZmgeX8VSnpYMdrk8fCQlQ80KEDyB8rS/lYU
         GHK20/L4RCWp5ky3TDXYIsv8mPpKnWhB3qVaWPh166kPFHhfpgcGB4bvvoTaodmGr/Hh
         PiC3ym3n8eMHthHtg/cwFqTS0b1B2BtvTfpqJ4j5wAZLtzZiz0vwHuXjaPstIOlnJhlT
         D68AGC7ZwGba2nLfQBDaaUY26FqbwhBHWdLp9++/vHJ76wRE6TzUYT2Z0mgMEZF83fmH
         4AtHTfsF4EnY6p4auvgat5ZgEV2g4UQECyw0FyVn4IK7ZDnOZsgTgBtk7/BRC5a9Nc9m
         8nuQ==
X-Gm-Message-State: AOAM532h5ymsG6dF7gIFc8rZ3ksJDLMmIjGOYKvJM/ElvRPjq+IvTlx2
        M/fMu99dbauLwLoc/kdZOWDf6z18/Nu9toP2h52yihPgya39AzmlSEInd0C+IvdGBdhsR/mTm5z
        otAKIrKiW5PSH
X-Received: by 2002:a50:e10d:: with SMTP id h13mr37418808edl.77.1632321358689;
        Wed, 22 Sep 2021 07:35:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxn2x/yjc20i/TrMOEcSyioIKKrKNDEeRWr2kJLseHFMqmfh1cKMw6mI4XIbBhSjmEXMTUjnA==
X-Received: by 2002:a50:e10d:: with SMTP id h13mr37418782edl.77.1632321358479;
        Wed, 22 Sep 2021 07:35:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c10sm1136294eje.37.2021.09.22.07.35.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 07:35:57 -0700 (PDT)
Subject: Re: [PATCH v3 0/7] KVM: few more SMM fixes
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>
References: <20210913140954.165665-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <22916f0c-2e3a-1fd6-905e-5d647c15c45b@redhat.com>
Date:   Wed, 22 Sep 2021 16:35:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210913140954.165665-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/09/21 16:09, Maxim Levitsky wrote:
> These are few SMM fixes I was working on last week.
> 
> * Patch 1,2 fixes a minor issue that remained after
>    commit 37be407b2ce8 ("KVM: nSVM: Fix L1 state corruption upon return from SMM")
> 
>    While now, returns to guest mode from SMM work due to restored state from HSAVE
>    area, the guest entry still sees incorrect HSAVE state.
> 
>    This for example breaks return from SMM when the guest is 32 bit, due to PDPTRs
>    loading which are done using incorrect MMU state which is incorrect,
>    because it was setup with incorrect L1 HSAVE state.
> 
>    V3: updated with review feedback from Sean.
> 
> * Patch 3 fixes a theoretical issue that I introduced with my SREGS2 patchset,
>    which Sean Christopherson pointed out.
> 
>    The issue is that KVM_REQ_GET_NESTED_STATE_PAGES request is not only used
>    for completing the load of the nested state, but it is also used to complete
>    exit from SMM to guest mode, and my compatibility hack of pdptrs_from_userspace
>    was done assuming that this is not done.
> 
>    V3: I moved the reset of pdptrs_from_userspace to common x86 code.
> 
> * Patch 4 makes SVM SMM exit to be a bit more similar to how VMX does it
>    by also raising KVM_REQ_GET_NESTED_STATE_PAGES requests.
> 
>    I do have doubts about why we need to do this on VMX though. The initial
>    justification for this comes from
> 
>    7f7f1ba33cf2 ("KVM: x86: do not load vmcs12 pages while still in SMM")
> 
>    With all the MMU changes, I am not sure that we can still have a case
>    of not up to date MMU when we enter the nested guest from SMM.
>    On SVM it does seem to work anyway without this.
> 
> * Patch 5 fixes guest emulation failure when unrestricted_guest=0 and we reach
>    handle_exception_nmi_irqoff.
>    That function takes stale values from current vmcs and fails not taking into account
>    the fact that we are emulating invalid guest state now, and thus no VM exit happened.
> 
> * Patch 6 fixed a corner case where return from SMM is slightly corrupting
>    the L2 segment register state when unrestricted_guest=0 due to real mode segement
>    caching register logic, but later it restores it correctly from SMMRAM.
>    Fix this by not failing nested_vmx_enter_non_root_mode and delaying this
>    failure to the next nested VM entry.
> 
> * Patch 7 fixes another corner case where emulation_required was not updated
>    correctly on nested VMexit when restoring the L1 segement registers.
> 
> I still track 2 SMM issues:
> 
> 1. When HyperV guest is running nested, and uses SMM enabled OVMF, it crashes and
>     reboots during the boot process.
> 
> 2. Nested migration on VMX is still broken when L1 floods itself with SMIs.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (7):
>    KVM: x86: nSVM: refactor svm_leave_smm and smm_enter_smm
>    KVM: x86: nSVM: restore the L1 host state prior to resuming nested
>      guest on SMM exit
>    KVM: x86: reset pdptrs_from_userspace when exiting smm
>    KVM: x86: SVM: call KVM_REQ_GET_NESTED_STATE_PAGES on exit from SMM
>      mode
>    KVM: x86: VMX: synthesize invalid VM exit when emulating invalid guest
>      state
>    KVM: x86: nVMX: don't fail nested VM entry on invalid guest state if
>      !from_vmentry
>    KVM: x86: nVMX: re-evaluate emulation_required on nested VM exit
> 
>   arch/x86/kvm/svm/nested.c |   9 ++-
>   arch/x86/kvm/svm/svm.c    | 131 ++++++++++++++++++++------------------
>   arch/x86/kvm/svm/svm.h    |   3 +-
>   arch/x86/kvm/vmx/nested.c |   9 ++-
>   arch/x86/kvm/vmx/vmx.c    |  28 ++++++--
>   arch/x86/kvm/vmx/vmx.h    |   1 +
>   arch/x86/kvm/x86.c        |   7 ++
>   7 files changed, 113 insertions(+), 75 deletions(-)
> 

Queued, thanks.  However, I'm keeping patch 1 for 5.16 only.

Paolo

