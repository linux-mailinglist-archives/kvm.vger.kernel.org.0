Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10017416323
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 18:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242250AbhIWQZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 12:25:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55605 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242149AbhIWQZb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 12:25:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632414239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J4nZPAKWllqHjqXlqOvmm8xru0EBr9+YJ8WeLqeKUms=;
        b=BPTioePcC5Z+tPlHcas5MP29lRJvDN1AsFqubEimuviSHij8lCaK9sLSD9bYbVkG9KKoN9
        DJSZHGdcK4pAp4FA8udiO7AMEhVE6dIrhGxk8sJQy+fejy1Wes7dmETBBSiyzsr3vFxPsZ
        mv3ye8U4M7L5LqDWoPByqTx6NgmqtJo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-2dWYcjdNMgq_6wDs562PYQ-1; Thu, 23 Sep 2021 12:23:57 -0400
X-MC-Unique: 2dWYcjdNMgq_6wDs562PYQ-1
Received: by mail-ej1-f70.google.com with SMTP id q17-20020a17090676d100b0060d4be6161dso85375ejn.17
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 09:23:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J4nZPAKWllqHjqXlqOvmm8xru0EBr9+YJ8WeLqeKUms=;
        b=EQ/W6BGNrYoRbVThO8lm/IKcJltF0iU7BjFyAztIQl4pmyl+sHf3net28Ll0d/r7kv
         3CunvHZikEho+MY1uI70gFpgep27EkeDYVYHsoZumBDtu/OVz5eMtV5J+SQT0NjeWSRS
         cAXYH00kyGPc7KzdVIovl7rO9xvXUZFRAXwEVQZamj9GqF4FySWS24qaZDY2TOs6Jryl
         4CZQF/WEFwlq5T2TjcrIQLe883WsOkl/ib29QTGXV2MaWP3TPF4O9/KYI96slPCjf18e
         BojPZHVEBZdI/iTwrrJmIL5hSMT+a44fN5oG1wBkd9vpRvlaBwQLkV8ciiaWQ83tmqRL
         +5rA==
X-Gm-Message-State: AOAM531liQUwjCvQUKzewkOSTgdJhEwauPQ917vbc6zpsLCUdlKxrubZ
        T3hdWLbzKJeouUKjR0EmnJ/SjdMaYM6nYKhGM/ZL6AKDkLDLwyp5EBzvrFbn3oflWyRImZEeGus
        nwR7RlCsKwjJT
X-Received: by 2002:a17:906:3fc1:: with SMTP id k1mr6152585ejj.44.1632414236146;
        Thu, 23 Sep 2021 09:23:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDarQFheVOPN7xa/s+ylmVG8oqKx6eZI8L60pSWGlm0nTHdQSHbL9Z5LTTo4wLMFBb7muLoQ==
X-Received: by 2002:a17:906:3fc1:: with SMTP id k1mr6152566ejj.44.1632414235961;
        Thu, 23 Sep 2021 09:23:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m10sm3296604ejx.76.2021.09.23.09.23.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 09:23:55 -0700 (PDT)
Subject: Re: [PATCH v2 00/10] KVM: x86: Clean up RESET "emulation"
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
References: <20210921000303.400537-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4dedad87-a665-1ee7-8915-743926c0b719@redhat.com>
Date:   Thu, 23 Sep 2021 18:23:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210921000303.400537-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/21 02:02, Sean Christopherson wrote:
> Add dedicated helpers to emulate RESET (or at least, the parts of RESET
> that KVM actually emulates) instead of having the relevant code scattered
> throughout vcpu_create() and vcpu_reset().
> 
> Vitaly's innocuous suggestion to WARN on non-zero CR0 led to a wonderful
> bit of git archaeology after, to my complete surprise, it fired on RESET
> due to fx_init() setting CR0.ET (and XCR0.FP).
> 
> v2:
>   - Add patches to drop defunct fx_init() code.
>   - Add patch to zero CR3 at RESET/INIT.
>   - Add patch to mark all regs avail/dirty at creation, not at RESET/INIT.
>   - Add patch to WARN if CRs are non-zero at RESET. [Vitaly]
> 
> v1: https://lkml.kernel.org/r/20210914230840.3030620-1-seanjc@google.com
> 
> Sean Christopherson (10):
>    KVM: x86: Mark all registers as avail/dirty at vCPU creation
>    KVM: x86: Clear KVM's cached guest CR3 at RESET/INIT
>    KVM: x86: Do not mark all registers as avail/dirty during RESET/INIT
>    KVM: x86: Remove defunct setting of CR0.ET for guests during vCPU
>      create
>    KVM: x86: Remove defunct setting of XCR0 for guest during vCPU create
>    KVM: x86: Fold fx_init() into kvm_arch_vcpu_create()
>    KVM: VMX: Drop explicit zeroing of MSR guest values at vCPU creation
>    KVM: VMX: Move RESET emulation to vmx_vcpu_reset()
>    KVM: SVM: Move RESET emulation to svm_vcpu_reset()
>    KVM: x86: WARN on non-zero CRs at RESET to detect improper
>      initalization
> 
>   arch/x86/kvm/svm/sev.c |  6 ++--
>   arch/x86/kvm/svm/svm.c | 29 ++++++++++--------
>   arch/x86/kvm/svm/svm.h |  2 +-
>   arch/x86/kvm/vmx/vmx.c | 68 ++++++++++++++++++++----------------------
>   arch/x86/kvm/x86.c     | 44 +++++++++++++--------------
>   5 files changed, 76 insertions(+), 73 deletions(-)
> 

Queued 3-10 too now, thanks.

Paolo

