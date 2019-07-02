Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 858D15D469
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfGBQjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:39:00 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36979 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfGBQjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:39:00 -0400
Received: by mail-wm1-f66.google.com with SMTP id f17so1750507wme.2
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:38:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kQCwhDkd+adrjWulJDMrfB6RaCVRg+9pt7Pln9EQadU=;
        b=AG9N26OiubaIkYx2jRgkyBVD3jWXJYk8L6975TXD9duwc9JTzoAeaVhVu5PZKd5a/P
         EiW7/X29mC0l7sdSplcvqqaULojm9e+mwQoqyZoHS/DeyH+G7Hvsc6Uume8bjyYJmLIO
         9hovXGLtSN9KsSzegGQNysv7sW/9Swz8aUl1cLQMKO+3vxF0TawnhV6tGYTMVt1oLjgN
         Z/lURc3PScj5863pTW52/tH8dZhxXmIGY6HFO1AnlLftJxlSAGFoCUCcm6uUuVBm/dLh
         HjiYHIQ57DIoBLugvUbWeqc0cX8rCm7CAxJIxlzB0eU+prR8vhlxwMt1W0cxM2Sv4/Oa
         y5CA==
X-Gm-Message-State: APjAAAWKqGuh/w3kIeNW//TaRlXpIO61NZ99NoE3nloABaaqmfmLcyoX
        0KxihAddaw6LAEbrYeJ1+fjchA==
X-Google-Smtp-Source: APXvYqxPnamW93gW07ox1CwpZBoHKRzOdtXDqbFbqsJ7PrXNkj4xiKRuUFDtjNygF4OYLSfBPSizDw==
X-Received: by 2002:a1c:67c2:: with SMTP id b185mr3812943wmc.98.1562085537670;
        Tue, 02 Jul 2019 09:38:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id f7sm3111041wrp.55.2019.07.02.09.38.56
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:38:57 -0700 (PDT)
Subject: Re: [PATCH v5 0/4] KVM: LAPIC: Implement Exitless Timer
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1fbd236a-f7f9-e66a-e08c-bf2bac901d15@redhat.com>
Date:   Tue, 2 Jul 2019 18:38:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/06/19 11:39, Wanpeng Li wrote:
> Dedicated instances are currently disturbed by unnecessary jitter due 
> to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
> There is no hardware virtual timer on Intel for guest like ARM. Both 
> programming timer in guest and the emulated timer fires incur vmexits.
> This patchset tries to avoid vmexit which is incurred by the emulated 
> timer fires in dedicated instance scenario. 
> 
> When nohz_full is enabled in dedicated instances scenario, the unpinned 
> timer will be moved to the nearest busy housekeepers after commit
> 9642d18eee2cd (nohz: Affine unpinned timers to housekeepers) and commit 
> 444969223c8 ("sched/nohz: Fix affine unpinned timers mess"). However, 
> KVM always makes lapic timer pinned to the pCPU which vCPU residents, the 
> reason is explained by commit 61abdbe0 (kvm: x86: make lapic hrtimer 
> pinned). Actually, these emulated timers can be offload to the housekeeping 
> cpus since APICv is really common in recent years. The guest timer interrupt 
> is injected by posted-interrupt which is delivered by housekeeping cpu 
> once the emulated timer fires. 
> 
> The host admin should fine tuned, e.g. dedicated instances scenario w/ 
> nohz_full cover the pCPUs which vCPUs resident, several pCPUs surplus 
> for busy housekeeping, disable mwait/hlt/pause vmexits to keep in non-root  
> mode, ~3% redis performance benefit can be observed on Skylake server.

Marcelo,

does this patch work for you or can you still see the oops?

Thanks,

Paolo

> w/o patchset:
> 
>             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time   Avg time
> 
> EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.09us   0.71us ( +-   1.09% )
> 
> w/ patchset:
> 
>             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time         Avg time
> 
> EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.88us   0.72us ( +-   4.02% )
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> 
> v4 -> v5:
>  * update patch description in patch 1/4
>  * feed latest apic->lapic_timer.expired_tscdeadline to kvm_wait_lapic_expire()
>  * squash advance timer handling to patch 2/4
> 
> v3 -> v4:
>  * drop the HRTIMER_MODE_ABS_PINNED, add kick after set pending timer
>  * don't posted inject already-expired timer
> 
> v2 -> v3:
>  * disarming the vmx preemption timer when posted_interrupt_inject_timer_enabled()
>  * check kvm_hlt_in_guest instead
> 
> v1 -> v2:
>  * check vcpu_halt_in_guest
>  * move module parameter from kvm-intel to kvm
>  * add housekeeping_enabled
>  * rename apic_timer_expired_pi to kvm_apic_inject_pending_timer_irqs
> 
> 
> Wanpeng Li (4):
>   KVM: LAPIC: Make lapic timer unpinned
>   KVM: LAPIC: Inject timer interrupt via posted interrupt
>   KVM: LAPIC: Ignore timer migration when lapic timer is injected by pi
>   KVM: LAPIC: Don't inject already-expired timer via posted interrupt
> 
>  arch/x86/kvm/lapic.c            | 68 +++++++++++++++++++++++++++--------------
>  arch/x86/kvm/lapic.h            |  3 +-
>  arch/x86/kvm/svm.c              |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  5 +--
>  arch/x86/kvm/x86.c              | 11 ++++---
>  arch/x86/kvm/x86.h              |  2 ++
>  include/linux/sched/isolation.h |  2 ++
>  kernel/sched/isolation.c        |  6 ++++
>  8 files changed, 67 insertions(+), 32 deletions(-)
> 

