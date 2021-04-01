Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F34B351E91
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbhDASno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:43:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237214AbhDASdD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617301981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zV8gIwvUm/KU6YRC6HTfZNfZbn7owoKKDfoum0B8FQg=;
        b=HOsMbCNlsc5dnN1kqa3CFueKiy/ZqlGFJP2GV688DnITeIy73HwhV9F9hi4LUD+4+vt2HD
        vIvFxPs6QqkSS69WXlFpsKjrxBvC24tfmi/X17JLo91vCFsmFjABMzU3YbS5xWunRPVqZu
        ojExcdzka0ZmcKmp3x8mjrrMFnAETrs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-D6KiXHksP924FMNonTS-8Q-1; Thu, 01 Apr 2021 11:31:25 -0400
X-MC-Unique: D6KiXHksP924FMNonTS-8Q-1
Received: by mail-ed1-f70.google.com with SMTP id k8so3006512edn.19
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 08:31:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zV8gIwvUm/KU6YRC6HTfZNfZbn7owoKKDfoum0B8FQg=;
        b=WPzf0xdz4K2+WMWhvXl+5WBznYaure6MV+iXz19emAsuECqzFNySbSl9S4EcG5VFPq
         7SuXhSXxGwnLRjVFVgrdnwxNMp7dJg/8ZzA6aTBBrtIpaEg3M4X0rIj9blFVw3JT9rYk
         0CpSJi4qGBGyncXkr2X+08cRWyDDkbb+rlGCJsoopfSWMOkzDGk/Qtwj36p9/oCwcsHJ
         Cjf6A59tB2CQs8ces0XXTRJL7YWBAJEWNjJATDuqKC5vDDIphxd7im4C1iPS8TKeWouW
         yJQrxyLghxykWlgpWliOiKtS8i8fbVYuHfAcBmcZDRdML6/+/G6u38L3TjLCq395jtES
         udFA==
X-Gm-Message-State: AOAM5334Bu7ZkPQNmi0Bdoo8vvEj8STBg6Y6ZtJmK7VRUlTGP4CNwfWj
        7AhNd9zBW7NCWyqQaOdgru9NuIHqFxAqK1wmkqD1e1dztLpOy76hgvU8jSsOATp2pKIHdF/VWOn
        rCL2fa0ebgeeD
X-Received: by 2002:a17:907:76b3:: with SMTP id jw19mr9506193ejc.202.1617291084874;
        Thu, 01 Apr 2021 08:31:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2OyaXOnqsMAdV9O9/OpOj49/Etytctob8p7D5zvVV46D//28nISt7Li1rmBfAywC50ToRKA==
X-Received: by 2002:a17:907:76b3:: with SMTP id jw19mr9506170ejc.202.1617291084698;
        Thu, 01 Apr 2021 08:31:24 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a17sm2918642ejf.20.2021.04.01.08.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:31:24 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 2/2] KVM: nSVM: improve SYSENTER emulation on AMD
In-Reply-To: <6f138606-d6c3-d332-9dc2-9ba4796fd4ce@redhat.com>
References: <20210401111928.996871-1-mlevitsk@redhat.com>
 <20210401111928.996871-3-mlevitsk@redhat.com>
 <87h7kqrwb2.fsf@vitty.brq.redhat.com>
 <6f138606-d6c3-d332-9dc2-9ba4796fd4ce@redhat.com>
Date:   Thu, 01 Apr 2021 17:31:23 +0200
Message-ID: <87zgyic984.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 01/04/21 15:03, Vitaly Kuznetsov wrote:
>>> +		svm->sysenter_eip_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
>> 
>> (Personal taste) I'd suggest we keep the whole 'sysenter_eip'/'sysenter_esp'
>> even if we only use the upper 32 bits of it. That would reduce the code
>> churn a little bit (no need to change 'struct vcpu_svm').
>
> Would there really be less changes?  Consider that you'd have to look at 
> the VMCB anyway because svm_get_msr can be reached not just for guest 
> RDMSR but also for ioctls.
>

I was thinking about the hunk in arch/x86/kvm/svm/svm.h tweaking
vcpu_svm. My opinion is not strong at all here)

-- 
Vitaly

