Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5D71C4267
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 19:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729928AbgEDRWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 13:22:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36391 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729645AbgEDRWp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 13:22:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588612964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JzrHLa4yO9piUrvMC3ds7g4OpEiv0B4QEcZSD2qDkrA=;
        b=LgVIWlzxuGLMmVWbGZpE6AaEhgE92gtV/Yt/KXdpaXsHIfu2SUp3k4lPyhCSqHTLtBp5y2
        co5T5hJycv3+rTiL9zEkx7xoDZ17FXLC7ACpAjtZrH3nx76jhzmLMmTVWI0o2AB7ArwJGR
        8wlC0ilh8fBt7eWzuyFgikGL677FFkw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-tADXSwfvONSvSayTu7SNtw-1; Mon, 04 May 2020 13:22:40 -0400
X-MC-Unique: tADXSwfvONSvSayTu7SNtw-1
Received: by mail-wm1-f71.google.com with SMTP id f81so299062wmf.2
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 10:22:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JzrHLa4yO9piUrvMC3ds7g4OpEiv0B4QEcZSD2qDkrA=;
        b=fwNryFJJW7DrMnqS6Uo4oXIO6/czY2/bSHj3L27g87roRME6lEi3Zudt+8J4SfCZ85
         KA5Lw1p7ECefkSGEvtjfDnwGVC+dFFycRbtBoHooY4nprMr4aXyC4XVtEiXfTQv1WwBY
         wuoyNzReFC+A+UB+g7vdAJF3/SV7NGWqXDeq8OEQod7B9YqhPTdMzDO/8ICVbRaCcXmG
         NVRWduAwf/+mVbkZkFUYrYCBF6tkH/BXE6m2EfAnBw6CGDiRAwrrIJuxTw5Q7JEMMG9I
         11ZZuLfI7Oyq39HeVEfFFnPRB0tHw6BdIyQrLMFjtGmNAgCemaxX/GJBNutAJhbpwpJa
         2XDQ==
X-Gm-Message-State: AGi0PuZ+Fz08h9R/fLfYN9fL25AyU1J8MARGM8j37xyzmaZOrA66JGdL
        uLG4LgOE8RNppIK6umtmo+IV433I24yq6zeHDzEZCB2CwUAKiT/hYht09gSXym7rulJRWaitrOw
        VJ4bWwmP+N4+c
X-Received: by 2002:a1c:2e91:: with SMTP id u139mr15337116wmu.18.1588612958982;
        Mon, 04 May 2020 10:22:38 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ7AQYoylVQUK+fEXTNONUM6fSyUA1uFiuC72Sdv+Lm4wvXk2jFjHoC4mb2iB4Rn3OzXU/kzA==
X-Received: by 2002:a1c:2e91:: with SMTP id u139mr15337091wmu.18.1588612958716;
        Mon, 04 May 2020 10:22:38 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id v131sm141677wmb.19.2020.05.04.10.22.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 10:22:38 -0700 (PDT)
Subject: Re: [PATCH v4 0/7] KVM: VMX: Tscdeadline timer emulation fastpath
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8f7fd1b1-51c5-29a4-cfce-5ebe51a486cf@redhat.com>
Date:   Mon, 4 May 2020 19:22:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/20 08:23, Wanpeng Li wrote:
> IPI and Timer cause the main vmexits in cloud environment observation, 
> after single target IPI fastpath, let's optimize tscdeadline timer 
> latency by introducing tscdeadline timer emulation fastpath, it will 
> skip various KVM related checks when possible. i.e. after vmexit due 
> to tscdeadline timer emulation, handle it and vmentry immediately 
> without checking various kvm stuff when possible. 
> 
> Testing on SKX Server.
> 
> cyclictest in guest(w/o mwait exposed, adaptive advance lapic timer is default -1):
> 
> 5540.5ns -> 4602ns       17%
> 
> kvm-unit-test/vmexit.flat:
> 
> w/o avanced timer:
> tscdeadline_immed: 3028.5  -> 2494.75  17.6%
> tscdeadline:       5765.7  -> 5285      8.3%
> 
> w/ adaptive advance timer default -1:
> tscdeadline_immed: 3123.75 -> 2583     17.3%
> tscdeadline:       4663.75 -> 4537      2.7%
> 
> Tested-by: Haiwei Li <lihaiwei@tencent.com>
> Cc: Haiwei Li <lihaiwei@tencent.com>
> 
> v3 -> v4:
>  * fix bad indentation
>  * rename CONT_RUN to REENTER_GUEST
>  * rename kvm_need_cancel_enter_guest to kvm_vcpu_exit_request
>  * rename EXIT_FASTPATH_CONT_RUN to EXIT_FASTPATH_REENTER_GUEST 
>  * introduce EXIT_FASTPATH_NOP 
>  * don't squish several stuffs to one patch
>  * REENTER_GUEST be introduced with its first usage
>  * introduce __handle_preemption_timer subfunction
> 
> v2 -> v3:
>  * skip interrupt notify and use vmx_sync_pir_to_irr before each cont_run
>  * add from_timer_fn argument to apic_timer_expired
>  * remove all kinds of duplicate codes
> 
> v1 -> v2:
>  * move more stuff from vmx.c to lapic.c
>  * remove redundant checking
>  * check more conditions to bail out CONT_RUN
>  * not break AMD
>  * not handle LVTT sepecial
>  * cleanup codes
> 
> Wanpeng Li (7):
>   KVM: VMX: Introduce generic fastpath handler
>   KVM: X86: Enable fastpath when APICv is enabled
>   KVM: X86: Introduce more exit_fastpath_completion enum values
>   KVM: X86: Introduce kvm_vcpu_exit_request() helper
>   KVM: VMX: Optimize posted-interrupt delivery for timer fastpath
>   KVM: X86: TSCDEADLINE MSR emulation fastpath
>   KVM: VMX: Handle preemption timer fastpath
> 
>  arch/x86/include/asm/kvm_host.h |  3 ++
>  arch/x86/kvm/lapic.c            | 18 +++++++----
>  arch/x86/kvm/svm/svm.c          | 11 ++++---
>  arch/x86/kvm/vmx/vmx.c          | 66 +++++++++++++++++++++++++++++++++--------
>  arch/x86/kvm/x86.c              | 44 ++++++++++++++++++++-------
>  arch/x86/kvm/x86.h              |  3 +-
>  virt/kvm/kvm_main.c             |  1 +
>  7 files changed, 110 insertions(+), 36 deletions(-)
> 

Queued all except 2, pending testing (and understanding the rationale
behind patch 2).  I will post separately my version of patch 3.

Thanks,

Paolo

