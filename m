Return-Path: <kvm+bounces-57051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD53B4A282
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 08:43:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B72E44584B
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 06:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C4A303A24;
	Tue,  9 Sep 2025 06:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Gi+CQB/U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F2528E7
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 06:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757400178; cv=none; b=NH3ls2T+mlq/GzQVR7Xr2W9z8uHP6ZoKZ2WXxSxiOoooO4lpiD5L/+M4+7Vas4m4AiGurjsBJ+VIvOcAN+i6ZKrbpoHCm2edPhDfydCGDGa8VVBYSNSOMqqBi0iIp9z2tZVWHz7Lj1cTpf94nZqeqCWjm9nIvHWvntNKIrOoqTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757400178; c=relaxed/simple;
	bh=s1FfT6BLSwnInXfFheiMNnzu0iQPEBbDhTCXJsGgTmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ui7d0iRVPh8ytIpNhZEVboYGa0fnyaF6fqxBuDGo7RF7vr6bw3nyhbt+2cC31JkqpQbxOdBPyvxOjHRxz/O6SlG5tYJTlFBKhDSsuAI68NLUP9TFWMLanRTb5a9TeLCAEpLE4pYTzokSii3qyRA7F0Zww9UpjnMqGbBwX13+ibQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Gi+CQB/U; arc=none smtp.client-ip=209.85.210.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-7724cacc32bso4027571b3a.0
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 23:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1757400175; x=1758004975; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/GvIWSk/3gbYKeUtKA9FXFsOEEQ7hBCXqeb+YlYiqlM=;
        b=Gi+CQB/Uhw4b6enkw/5xavfFm3u9L1vkc7audV7FIiAVZt9GtUYEcuqAtrak/NYF8W
         GyzL1PJd+CsT+3GKvL8nFEoKtOLwP6lNjM5yaAgtG2iOLZTsixI752ZgRG1cucidCq6X
         oYRT/HR7x7/oS6DDYKqzIfqjI/W+Bc8FzO9EErdPPnlKbRn8y302e9ZPSoRJLUfb+V/4
         pHH3uFmmQOMu4xuGWxlZTXUJKMBEDEWV/R5vvPFs0ONGFaWiS9gjqyCtzoP4993u4xkS
         HxIMsdmDbV6MN47ZC+4OqcQ86WQH4YTKSookYj00wHslZ2MHRyxpeVayecPM8kvoOPOp
         vkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757400175; x=1758004975;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/GvIWSk/3gbYKeUtKA9FXFsOEEQ7hBCXqeb+YlYiqlM=;
        b=qD2uR6wCkWbN6a1IBA0W7km6Yqv79Yc+UEEjR0CmTOQ6fZnCN0F+rjohVq1McWQt0v
         kiXRfwDK7ACFw8IYB6MjeSN73JsB6yMLz6SzuNt3I7SWdmrnVIDknZaNxQAbESRUREMy
         ICyhqE+88RfpnmFviFWvxH8HFOkTeV43gGtE2cJ815tLzIqRouyRm4zhPdL8tUrZYbX6
         PjjHGDg3A/nAzhNfV2uFN4sAil0qbsAXk83U7qfg03/hASQnT9iDNop4WKlfm5/OVCiX
         AnTQWgZWo9LCePctYO9MoqJyi6nRtXDZZNknPRrZTTsRZUwdQK2ahIXOoMXeE5AJNDLs
         qNPg==
X-Forwarded-Encrypted: i=1; AJvYcCWD8YzRPvJIzuUfMHr87xwJGQsa8Blw47oXm6/3WcMwNVAx+GBp+uWTIiC2MlwGgDovIeY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxnq7Cd+20m1Lj7oIpa8jAY7fvl0L/roSROpxHBb+85w3ij0ENV
	eK5k9n5phv6H5yGFGU7X6OiZ+xQh+5qVWXF0iwvNvMJdYRciPExs1Iy3jNOd/IxzleE=
X-Gm-Gg: ASbGncsG41WR/kVxvwAaKLdnU5/3thv+BC5l5Oim58gLKhdybztFVTOteeLtFHjkRFS
	4YjBssZ82UjVWTxdt1JW9XJmjdmDifH5nwHeiChvPSPpNBAOPwtTyT1bx+UDP9ib+yPqyJ1ogYc
	8p9tEPCJPKtNrl4HjejSd2JyShDMuxi3tFTOV93ABhy7o7mLFerLxps9YiVMqJdXV2YVDTXSejS
	lhCHLQCmzgOZBz39xgEYZC94/M1VtA7psPY2Kr0pvv2rKJfAFPZc95aTN3VTPsE7GLXxcIsSg1G
	zDDncdqHWlYE2+C+q1fHNmoM72uy/Q5SY+oL5zBy1vrnWO75Iwso4n3YsUG22z/yuGASDNHRnRj
	q40yGTPPkH6Fs8TrhCWlYR/QqGvOJmdEUbGM7RDHI1tEBEkiIUaQw5jnHz4KvTirBdGJNiPg=
X-Google-Smtp-Source: AGHT+IGYt5vOyFOt20vZvKtxMhw48jTWh2xHSOtkVEUQByr0A4T6BQmilfHwXnXK5Ks1EXc1KJBYgA==
X-Received: by 2002:a05:6a20:9183:b0:246:9192:2789 with SMTP id adf61e73a8af0-2534441fa83mr15956172637.49.1757400175306;
        Mon, 08 Sep 2025 23:42:55 -0700 (PDT)
Received: from [10.4.104.249] ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-774662905bcsm990963b3a.51.2025.09.08.23.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 23:42:54 -0700 (PDT)
Message-ID: <f6706599-0b8e-44bb-9f53-4e6a4db24b6d@bytedance.com>
Date: Tue, 9 Sep 2025 14:42:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Restrict writeback of SMI VCPU state
To: pbonzini@redhat.com, mtosatti@redhat.com, seanjc@google.com,
 kvm@vger.kernel.org
Cc: qemu-devel@nongnu.org
References: <20250909063327.14263-1-lifei.shirley@bytedance.com>
Content-Language: en-US
From: Fei Li <lifei.shirley@bytedance.com>
In-Reply-To: <20250909063327.14263-1-lifei.shirley@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/9/25 2:33 PM, Fei Li wrote:
> Recently, we meet a SMI race bug triggered by one monitor tool in our
> production environment. This monitor executes 'info registers -a' hmp
> at a fixed frequency, even during VM startup process, which makes
> some AP stay in KVM_MP_STATE_UNINITIALIZED forever, thus VM hangs.
> 
> The complete calling processes for the SMI race are as follows:
> 
> //thread1                      //thread2               //thread3
> `info registers -a` hmp [1]    AP(vcpu1) thread [2]    BSP(vcpu0) send INIT/SIPI [3]
> 
>                                 [2]
>                                 KVM: KVM_RUN and then
>                                      schedule() in kvm_vcpu_block() loop
> 
> [1]
> for each cpu: cpu_synchronize_state
> if !qemu_thread_is_self()
> 1. insert to cpu->work_list, and handle asynchronously
> 2. then kick the AP(vcpu1) by sending SIG_IPI/SIGUSR1 signal
> 
>                                 [2]
>                                 KVM: checks signal_pending, breaks loop and returns -EINTR
>                                 Qemu: break kvm_cpu_exec loop, run
>                                       1. qemu_wait_io_event()
>                                       => process_queued_cpu_work => cpu->work_list.func()
>                                          e.i. do_kvm_cpu_synchronize_state() callback
>                                          => kvm_arch_get_registers
>                                             => kvm_get_mp_state /* KVM: get_mpstate also calls
>                                                kvm_apic_accept_events() to handle INIT and SIPI */
>                                       => cpu->vcpu_dirty = true;
>                                       // end of qemu_wait_io_event
> 
>                                                         [3]
>                                                         SeaBIOS: BSP enters non-root mode and runs reset_vector() in SeaBIOS.
>                                                                  send INIT and then SIPI by writing APIC_ICR during smp_scan
>                                                         KVM: BSP(vcpu0) exits, then => handle_apic_write
>                                                              => kvm_lapic_reg_write => kvm_apic_send_ipi to all APs
>                                                              => for each AP: __apic_accept_irq, e.g. for AP(vcpu1)
>                                                              ==> case APIC_DM_INIT: apic->pending_events = (1UL << KVM_APIC_INIT)
>                                                                  (not kick the AP yet)
>                                                              ==> case APIC_DM_STARTUP: set_bit(KVM_APIC_SIPI, &apic->pending_events)
>                                                                  (not kick the AP yet)
> 
>                                 [2]
>                                 Qemu continue:
>                                      2. kvm_cpu_exec()
>                                      => if (cpu->vcpu_dirty):
>                                         => kvm_arch_put_registers
>                                            => kvm_put_vcpu_events
>                                 KVM: kvm_vcpu_ioctl_x86_set_vcpu_events
>                                      => clear_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending_events);
>                                         e.i. pending_events changes from 11b to 10b
>                                        // end of kvm_vcpu_ioctl_x86_set_vcpu_events
>                                 Qemu: => after put_registers, cpu->vcpu_dirty = false;
>                                       => kvm_vcpu_ioctl(cpu, KVM_RUN, 0)
>                                 KVM: KVM_RUN
>                                      => schedule() in kvm_vcpu_block() until Qemu's next SIG_IPI/SIGUSR1 signal
>                                      /* But AP(vcpu1)'s mp_state will never change from KVM_MP_STATE_UNINITIALIZED
>                                        to KVM_MP_STATE_INIT_RECEIVED, even then to KVM_MP_STATE_RUNNABLE without
>                                        handling INIT inside kvm_apic_accept_events(), considering BSP will never
>                                        send INIT/SIPI again during smp_scan. Then AP(vcpu1) will never enter
>                                        non-root mode */
> 
>                                                         [3]
>                                                         SeaBIOS: waits CountCPUs == expected_cpus_count and loops forever
>                                                                  e.i. the AP(vcpu1) stays: EIP=0000fff0 && CS =f000 ffff0000
>                                                                  and BSP(vcpu0) appears 100% utilized as it is in a while loop.
> 
> To fix this, avoid clobbering SMI when not putting "reset" state, just
> like NMI abd SIPI does.
> 
> Signed-off-by: Fei Li <lifei.shirley@bytedance.com>
> ---
>   target/i386/kvm/kvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 369626f8c8..598661799a 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -5056,7 +5056,7 @@ static int kvm_put_vcpu_events(X86CPU *cpu, int level)
>   
>       events.sipi_vector = env->sipi_vector;
>   
> -    if (has_msr_smbase) {
> +    if (has_msr_smbase && level >= KVM_PUT_RESET_STATE) {
>           events.flags |= KVM_VCPUEVENT_VALID_SMM;
>           events.smi.smm = !!(env->hflags & HF_SMM_MASK);
>           events.smi.smm_inside_nmi = !!(env->hflags2 & HF2_SMM_INSIDE_NMI_MASK);

Hi all,
The previous context is from one KVM topic: 
https://lore-kernel.gnuweeb.org/lkml/f904b674-98ba-4e13-a64c-fd30b6ac4a2e@bytedance.com/T/#m80f426b55e272f9b257e2d7f6ff4902b7eb60178

Please help to review this patch, thanks for your time.

Have a nice day, thanks
Fei


