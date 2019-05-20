Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECF62320F
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 13:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732562AbfETLQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 07:16:13 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34907 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730634AbfETLQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 07:16:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id q15so12607698wmj.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 04:16:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=joIiCM9Da390dnqSoP54tpS0tG+Bp+p+mXE87gw748E=;
        b=q8y/Q5KU1tnJQJ2KJNL2Py+X7Ij33FPlQ2TIMAgsoFNb4PcjiQFuLJxC9wROj+hTxt
         C1bbAF1ZxY/2O1xBmHJ3ZTaccpOJ43oY3mLPaN/mKRk6XXomvjNha6QyHiAWAl/Tewmi
         EuSkDD+gSMdCihX7nY8iE68iY+DT/TrpGUOi1WP5dESVMH0pynbchqbjXlKU5Cn9FnDe
         NI1uXT5RgZnbByv7ZDtpMV1FHI6HNCLT+KJuxXkkWln1M9Dyc95iFoVP2HLFOxgHRDRV
         2nYvI7pFsLTMlgZ07gHM3BERD9Bs62bw0Ef+2QizeEoWDBjKZTa5CiuES/Y309NJKd/o
         WXBA==
X-Gm-Message-State: APjAAAWJkFOpu1ymowIzv7BB3MXAruYot5eJIcASygwnecL8muSBtekC
        fGEnKSBLiahOP0HMXuJF1Tuzkw==
X-Google-Smtp-Source: APXvYqyo1i1kPklnr6KsI6wSgJSXhrXqQ6p4hIqkFEkF+YY5nU2Do9SqZs7IX79zGuSbDXRK04IEWQ==
X-Received: by 2002:a1c:48d7:: with SMTP id v206mr10674778wma.152.1558350971238;
        Mon, 20 May 2019 04:16:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id y17sm14693790wrp.70.2019.05.20.04.16.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 04:16:10 -0700 (PDT)
Subject: Re: [PATCH v4 0/5] KVM: LAPIC: Optimize timer latency further
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e6e28a3f-bda7-342c-dc28-5dc899b6fa02@redhat.com>
Date:   Mon, 20 May 2019 13:16:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 10:18, Wanpeng Li wrote:
> Advance lapic timer tries to hidden the hypervisor overhead between the 
> host emulated timer fires and the guest awares the timer is fired. However, 
> it just hidden the time between apic_timer_fn/handle_preemption_timer -> 
> wait_lapic_expire, instead of the real position of vmentry which is 
> mentioned in the orignial commit d0659d946be0 ("KVM: x86: add option to 
> advance tscdeadline hrtimer expiration"). There is 700+ cpu cycles between 
> the end of wait_lapic_expire and before world switch on my haswell desktop.
> 
> This patchset tries to narrow the last gap(wait_lapic_expire -> world switch), 
> it takes the real overhead time between apic_timer_fn/handle_preemption_timer
> and before world switch into consideration when adaptively tuning timer 
> advancement. The patchset can reduce 40% latency (~1600+ cycles to ~1000+ 
> cycles on a haswell desktop) for kvm-unit-tests/tscdeadline_latency when 
> testing busy waits.
> 
> v3 -> v4:
>  * create timer_advance_ns debugfs entry iff lapic_in_kernel() 
>  * keep if (guest_tsc < tsc_deadline) before the call to __wait_lapic_expire()
> 
> v2 -> v3:
>  * expose 'kvm_timer.timer_advance_ns' to userspace
>  * move the tracepoint below guest_exit_irqoff()
>  * move wait_lapic_expire() before flushing the L1
> 
> v1 -> v2:
>  * fix indent in patch 1/4
>  * remove the wait_lapic_expire() tracepoint and expose by debugfs
>  * move the call to wait_lapic_expire() into vmx.c and svm.c
> 
> Wanpeng Li (5):
>   KVM: LAPIC: Extract adaptive tune timer advancement logic
>   KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow
>   KVM: LAPIC: Expose per-vCPU timer_advance_ns to userspace
>   KVM: LAPIC: Delay trace advance expire delta
>   KVM: LAPIC: Optimize timer latency further
> 
>  arch/x86/kvm/debugfs.c | 18 +++++++++++++++
>  arch/x86/kvm/lapic.c   | 60 +++++++++++++++++++++++++++++---------------------
>  arch/x86/kvm/lapic.h   |  3 ++-
>  arch/x86/kvm/svm.c     |  4 ++++
>  arch/x86/kvm/vmx/vmx.c |  4 ++++
>  arch/x86/kvm/x86.c     |  9 ++++----
>  6 files changed, 68 insertions(+), 30 deletions(-)
> 

Queued, thanks (2-3 for 5.2, the rest for 5.3).

Paolo
