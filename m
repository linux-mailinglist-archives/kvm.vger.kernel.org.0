Return-Path: <kvm+bounces-56982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6D64B49223
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 16:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED9BE3AE268
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 14:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FACD30BB86;
	Mon,  8 Sep 2025 14:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="WrFz8aU8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436752F5474
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 14:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757343323; cv=none; b=dmg5HMRiuWfVbSt2Nk+XisZT3PwrU8x0CLUtiX6AxFopoJ4GkPXsWwqM1OR15OWb+XxB8NTMaX7h0bmS/w6z0p50sBSp7YRQ68/Z46kPS8kXy0OGEg1n3PTP4+rZwgFqO9LuLHVesGMbIjYw063Z14x/cwHUBq2FHiZCsUHPoDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757343323; c=relaxed/simple;
	bh=Ee3FEGF3xAzaNWyedS6bEV11L5ZuNpo5FfZvcXJOKIQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=FUofdX/984Lmti4ojDoxqojcCtuYh+ngQIyV8Zk6T7fk1UiT83oJPh74JOT9fhIm8mtHokvxaxWZ6LmwC8OvdjEF1lnEhZ+aKkrWYt2XUDhsA4SNCcxb9JszGQpEPgSZEJBwqGBWuKNKDW0Vct9oD/SSVQk5sBcQtxEmaWydDIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=WrFz8aU8; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-32b70820360so3454408a91.2
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 07:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1757343320; x=1757948120; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VWM7u6gzgr9T/MqWNSjboANbXNdcmY+DYtZN3CoqJLg=;
        b=WrFz8aU8p7aB1ILxDWI832H5VvrsRdjoiaPxI1Myvd/5fDN0aXYJLu52zkjUg0rJOT
         Md9oyxrt4MO5Dgla+NaN1did9fnTXMeebdHzKIpRDYcPx+QXlgM7JHH/BLV1esb2DMNh
         GiMlOrw0BS/dWnq9hHt/I89LlGUJHpsShqwswRjFOfupir+OR1qMDfIZK4umAS3MR4/m
         LtmQy+fnuQ6nMCM261lYz48JLiNKmxSEi0yipkurgIDDZYAVV1sRdFRtOpSbCq0t0CXN
         NrIlK0DgarI/JwxeQVOufonJNzFcw3CnzZmiQvFrMomnzEc7EI1s4SSlhaQz5DPXMl0A
         0XPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757343320; x=1757948120;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VWM7u6gzgr9T/MqWNSjboANbXNdcmY+DYtZN3CoqJLg=;
        b=frEZztwscSEr8kgnGbdRTHSx6yfqm4+j2M0KTgTL9GOOt7dRjyCKT9Yk1btXe+8NF0
         EzkQEODge03QEdMQpj3n1G/8fxEgZQ3r9FZqtn2aJ890Sz2DXsz9WqiUCHhyIIq+VOqI
         c6sWTEcDSmB1V1oMGLAlXWXsyaTM/Qok9GSrFafFkJlxXN0g2P4CEvXkFQ+wtwMhEqjX
         si4It1qEI1Q5OHlkOOQm8wW7KlAj3OLlgQTd7oX+eFGVLXKpp0cXLD+Ji/9RtX1PPqKJ
         RlonQcuIBdGFY989L3dxMXWROaqwplUc6C4oeUkPJRIoTaqMNoojDeOKoLXMCUNYqfAj
         ByYA==
X-Forwarded-Encrypted: i=1; AJvYcCUIjso6fnUAPSDuNZBgejy93SjznRFbA3SWWSCC/Vb4yyE0b64KB4UZOPnbwwNG4UY/+Ls=@vger.kernel.org
X-Gm-Message-State: AOJu0YyimNhuswz1biogGaHbb8UbJZVfPMkCpMhDJywPhHOpI/XvSKnq
	GAqAQUBA//jRrD8rO9lTtSvJrEe5TvhXX7NMc++OuKkHO4T7K1ENxWZih23W377oXZc=
X-Gm-Gg: ASbGncvG2viTzYX3fABZeRpT4Z2UP1+N1N4jJhDMjNcA58X7Z34VEq1qmXkq+Dzyqet
	4DlUo29QvyowGYPooFKr7SaD9ERxLmvOzPxXmK3yZ6vO4R5/Y+EdRgIQE9IKWbR26R1l47t+a7E
	wQ0Wbn0y51RjqvCcL55O0pVKp7Li30/7/dxC/DP+qpCTVA1hIshEZ9KecnEftgRXOZMuwzopbUN
	Uh9qp3ZTuuuUSlZAGyM7VOIaGhJh/ijd8B4czJeaeGpOnNSe79QJ20OS97vYU2V7QSckzCuW8Li
	8qBW+OZJmGo3k7PkrHQWkl0VdeW+FAePEQSx6sun/UmyrVFhXr4j1lfkdt25cLNHtbmJSR0XZjD
	z2B+nIgoy8uzxqsF2C/ycT43Cm/16MI8yaNPB72X0KfCJNYN5zsu8k+LyC1frrGo=
X-Google-Smtp-Source: AGHT+IHQQxVqMdGburuSqybk1K9hiDqhGVVKjqoe0QgNVws6jTvHrNuDup3Nz5V5FroJtX3PJ2Ck5A==
X-Received: by 2002:a17:90b:530b:b0:31f:ca:63cd with SMTP id 98e67ed59e1d1-32d43ef0790mr9924165a91.2.1757343320170;
        Mon, 08 Sep 2025 07:55:20 -0700 (PDT)
Received: from [10.4.109.2] ([139.177.225.231])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32d7d4074b4sm3854864a91.4.2025.09.08.07.55.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 07:55:19 -0700 (PDT)
Message-ID: <c2979c40-0cf9-4238-9fb5-5cef6dd9f411@bytedance.com>
Date: Mon, 8 Sep 2025 22:55:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [PATCH] KVM: x86: Latch INITs only in specific CPU
 states in KVM_SET_VCPU_EVENTS
From: Fei Li <lifei.shirley@bytedance.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, liran.alon@oracle.com, hpa@zytor.com,
 wanpeng.li@hotmail.com, kvm@vger.kernel.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20250827152754.12481-1-lifei.shirley@bytedance.com>
 <aK8r11trXDjBnRON@google.com>
 <CABgObfYqVTK3uB00pAyZAdX=Vx1Xx_M0MOwUzm+D1C04mrVfig@mail.gmail.com>
 <f904b674-98ba-4e13-a64c-fd30b6ac4a2e@bytedance.com>
 <CABgObfb4ocYcaZixoPD_VZL5Z_SieTGJW3GBCFB-_LuOH5Ut2g@mail.gmail.com>
 <d686f056-180c-4a22-a359-81eadb062629@bytedance.com>
Content-Language: en-US
In-Reply-To: <d686f056-180c-4a22-a359-81eadb062629@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 9/5/25 10:59 PM, Fei Li wrote:
>
> On 8/29/25 12:44 AM, Paolo Bonzini wrote:
>> On Thu, Aug 28, 2025 at 5:13 PM Fei Li <lifei.shirley@bytedance.com> 
>> wrote:
>>> Actually this is a bug triggered by one monitor tool in our production
>>> environment. This monitor executes 'info registers -a' hmp at a fixed
>>> frequency, even during VM startup process, which makes some AP stay in
>>> KVM_MP_STATE_UNINITIALIZED forever. But this race only occurs with
>>> extremely low probability, about 1~2 VM hangs per week.
>>>
>>> Considering other emulators, like cloud-hypervisor and firecracker 
>>> maybe
>>> also have similar potential race issues, I think KVM had better do some
>>> handling. But anyway, I will check Qemu code to avoid such race. Thanks
>>> for both of your comments. 🙂
>> If you can check whether other emulators invoke KVM_SET_VCPU_EVENTS in
>> similar cases, that of course would help understanding the situation
>> better.
>>
>> In QEMU, it is possible to delay KVM_GET_VCPU_EVENTS until after all
>> vCPUs have halted.
>>
>> Paolo
>>
> Hi Paolo and Sean,
>
>
> Sorry for the late response, I have been a little busy with other 
> things recently. The complete calling processes for the bad case are 
> as follows:
>
> `info registers -a` hmp per 2ms[1]      AP(vcpu1) thread[2]           
> BSP(vcpu0) send INIT/SIPI[3]
>
>                                  [2]
>                                  KVM: KVM_RUN and then
>                           schedule() in kvm_vcpu_block() loop
>
> [1]
> for each cpu: cpu_synchronize_state
> if !qemu_thread_is_self()
> 1. insert to cpu->work_list, and handle asynchronously
> 2. then kick the AP(vcpu1) by sending SIG_IPI/SIGUSR1 signal
>
>                       [2]
>                       KVM: checks signal_pending, breaks loop and 
> returns -EINTR
> Qemu: break kvm_cpu_exec loop, run
>   1. qemu_wait_io_event()
>   => process_queued_cpu_work => cpu->work_list.func()
>        e.i. do_kvm_cpu_synchronize_state() callback
>        => kvm_arch_get_registers
>             => kvm_get_mp_state /* KVM: get_mpstate also calls
>            kvm_apic_accept_events() to handle INIT and SIPI */
>        => cpu->vcpu_dirty = true;
>   // end of qemu_wait_io_event
>
>                                   [3]
>                                   SeaBIOS: BSP enters non-root mode 
> and runs reset_vector() in SeaBIOS.
>                                            send INIT and then SIPI by 
> writing APIC_ICR during smp_scan
>                                   KVM: BSP(vcpu0) exits, then => 
> handle_apic_write
>                                        => kvm_lapic_reg_write => 
> kvm_apic_send_ipi to all APs
>                                        => for each AP: 
> __apic_accept_irq, e.g. for AP(vcpu1)
>                                             => case APIC_DM_INIT: 
> apic->pending_events = (1UL << KVM_APIC_INIT)
>                                                  (not kick the AP yet)
>                                             => case APIC_DM_STARTUP: 
> set_bit(KVM_APIC_SIPI, &apic->pending_events)
>                                                  (not kick the AP yet)
>
>   [2]
>   2. kvm_cpu_exec()
>   => if (cpu->vcpu_dirty):
>      => kvm_arch_put_registers
>         => kvm_put_vcpu_events
>                       KVM: kvm_vcpu_ioctl_x86_set_vcpu_events
>  => clear_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending_events);
>       e.i. pending_events changes from 11b to 10b
>  // end of kvm_vcpu_ioctl_x86_set_vcpu_events
> Qemu: => after put_registers, cpu->vcpu_dirty = false;
>         => kvm_vcpu_ioctl(cpu, KVM_RUN, 0)
>                       KVM: KVM_RUN
>  => schedule() in kvm_vcpu_block() until Qemu's next SIG_IPI/SIGUSR1 
> signal
>  /* But AP(vcpu1)'s mp_state will never change from 
> KVM_MP_STATE_UNINITIALIZED
>    to KVM_MP_STATE_INIT_RECEIVED, even then to KVM_MP_STATE_RUNNABLE
> without handling INIT inside kvm_apic_accept_events(), considering BSP 
> will never
>    send INIT/SIPI again during smp_scan. Then AP(vcpu1) will never enter
>    non-root mode */
>
>                                   [3]
>                                   SeaBIOS: waits CountCPUs == 
> expected_cpus_count and loops forever
>                                   e.i. the AP(vcpu1) stays: 
> EIP=0000fff0 && CS =f000 ffff0000
>                                         and BSP(vcpu0) appears 100% 
> utilized as it is in a while loop.
>
> As for other emulators (like cloud-hypervisor and firecracker), there 
> is no interactive command like 'info registers -a'.
> But sorry again that I haven't had time to check code to confirm 
> whether they invoke KVM_SET_VCPU_EVENTS in similar cases, maybe later. :)
>
>
> Have a nice day, thanks
> Fei
>

By the way, this doesn't seem to be a Qemu bug, since calling "info 
registers -a" is allowed regardless of the vcpu state (including when 
the VM is in the bootloader). Thus the INIT should not be latched in 
this case. To fix this, I think we need add the 
kvm_apic_init_sipi_allowed() condition: only latch INITs in specific CPU 
states. Or change mp_state to KVM_MP_STATE_INIT_RECEIVED and then clear 
INIT here. Should I send a v2 patch with a clearer commit message?
Have a nice day, thanks
Fei

