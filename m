Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8E7401A88
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 13:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237245AbhIFLX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 07:23:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231815AbhIFLX6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 07:23:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630927373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BGwfvEWhPcux+PIUI2boLtU32tDpQ6UGvcizmy6RoBs=;
        b=Xf3VUCk33hXgQeeNrYbj2YNedmdCq6xvVWxUE633Od+KaZuWV7vjU3Zjvm3QZ7Jygak6Xm
        /RpZFTR2Cx6MMRXVjpTAE8iQhmEB4lkhsd3KVJvdDjUUv5dKTv6DnIvpMQ1cSV4R9eLh7W
        v7dXTlVutBjgVmqD3q4R47grE0gPTOI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-PIZwGeaLMUaVdKeWtslTkA-1; Mon, 06 Sep 2021 07:22:52 -0400
X-MC-Unique: PIZwGeaLMUaVdKeWtslTkA-1
Received: by mail-wm1-f71.google.com with SMTP id z18-20020a1c7e120000b02902e69f6fa2e0so2216290wmc.9
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 04:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BGwfvEWhPcux+PIUI2boLtU32tDpQ6UGvcizmy6RoBs=;
        b=oNJ6NK3spl9YswPvOFx1ltFwFxHpbW35gx7vYoDG3tf9Dresdd16j22tmYI59sDe69
         H86ZC33ABzgMVg/QY/PGesfLEipTslRhkgDxEEdPFSdSttu13f/l0PsTvGcNDrHIKAAJ
         YjweUM0gsp7TkIBKOMwjaY36Fxizif7pg6kVs7nrkZkPkds5B5jDp9lHBTyCQiWLzFpH
         kjuZISqIutl9+n8uSW5upyb8G35ZyVoJDr4NDHcKyUud2kTHBJK0XYMpfAlczcHQsZDQ
         gSmC8hSmH23jXvgvgFIKZfeddn1qAyBGHJ6MfZDX1DAO1ia2L4E/hr0qb7H4BjF9wygy
         qf2w==
X-Gm-Message-State: AOAM532xTpVBTJb+o9Jhkh1pr3X85cwy2qRSJTuaI4i7h/IcKCg0/FP4
        3HC3ct6Y7UKSRCghBMzbSrWXu9EtVjaxF9BjTfBYjeJbfCqwEOYUGQdhnGhdHaAFDzT6IP2Dezb
        EjhS2f1b4/dBX
X-Received: by 2002:a7b:c18c:: with SMTP id y12mr10782047wmi.3.1630927370855;
        Mon, 06 Sep 2021 04:22:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIaHHIds/tZnD3Oefj97zXNdBn3IO4a5V08lISda1PJLYo7l+c6IKytev/esLB8HsvvHzGbg==
X-Received: by 2002:a7b:c18c:: with SMTP id y12mr10782032wmi.3.1630927370638;
        Mon, 06 Sep 2021 04:22:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w20sm4933082wrg.1.2021.09.06.04.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 04:22:50 -0700 (PDT)
Subject: Re: [PATCH] Guest system time jumps when new vCPUs is hot-added
To:     Zelin Deng <zelin.deng@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
References: <1619576521-81399-1-git-send-email-zelin.deng@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9f0d0543-db41-fbb0-019c-7df5b9319c33@redhat.com>
Date:   Mon, 6 Sep 2021 13:22:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1619576521-81399-1-git-send-email-zelin.deng@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/21 04:22, Zelin Deng wrote:
> Hello,
> I have below VM configuration:
> ...
>      <vcpu placement='static' current='1'>2</vcpu>
>      <cpu mode='host-passthrough'>
>      </cpu>
>      <clock offset='utc'>
>          <timer name='tsc' frequency='3000000000'/>
>      </clock>
> ...
> After VM has been up for a few minutes, I use "virsh setvcpus" to hot-add
> second vCPU into VM, below dmesg is observed:
> [   53.273484] CPU1 has been hot-added
> [   85.067135] SMP alternatives: switching to SMP code
> [   85.078409] x86: Booting SMP configuration:
> [   85.079027] smpboot: Booting Node 0 Processor 1 APIC 0x1
> [   85.080240] kvm-clock: cpu 1, msr 77601041, secondary cpu clock
> [   85.080450] smpboot: CPU 1 Converting physical 0 to logical die 1
> [   85.101228] TSC ADJUST compensate: CPU1 observed 169175101528 warp. Adjust: 169175101528
> [  141.513496] TSC ADJUST compensate: CPU1 observed 166 warp. Adjust: 169175101694
> [  141.513496] TSC synchronization [CPU#0 -> CPU#1]:
> [  141.513496] Measured 235 cycles TSC warp between CPUs, turning off TSC clock.
> [  141.513496] tsc: Marking TSC unstable due to check_tsc_sync_source failed
> [  141.543996] KVM setup async PF for cpu 1
> [  141.544281] kvm-stealtime: cpu 1, msr 13bd2c080
> [  141.549381] Will online and init hotplugged CPU: 1
> 
> System time jumps from 85.101228 to 141.51.3496.
> 
> Guest:                                   KVM
> -----                                    ------
> check_tsc_sync_target()
> wrmsrl(MSR_IA32_TSC_ADJUST,...)
>                                           kvm_set_msr_common(vcpu,...)
>                                           adjust_tsc_offset_guest(vcpu,...) //tsc_offset jumped
>                                           vcpu_enter_guest(vcpu) //tsc_timestamp was not changed
> ...
> rdtsc() jumped, system time jumped
> 
> tsc_timestamp must be updated before go back to guest.
> 
> ---
> Zelin Deng (1):
>    KVM: x86: Update vCPU's hv_clock before back to guest when tsc_offset
>      is adjusted
> 
>   arch/x86/kvm/x86.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 

While Thomas is right in general, what you found is indeed a bug with 
the KVM->userspace API to set up the vCPU TSC adjust.  So I'm queueing 
the patch for 5.15.

Thanks,

Paolo

