Return-Path: <kvm+bounces-58874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47A61BA44CE
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 16:54:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E04F1C03103
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 14:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CBB81DE3DC;
	Fri, 26 Sep 2025 14:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="S6WpvQSx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B19A38DE1
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 14:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758898453; cv=none; b=Vp+cUj7ntfbxxzTCPlq9Tj3neRwTi6o5nbYu/5KnulRuUOGbpqLGZHTXKsPNKwy/8YGL1j52Gl3k8mXNG4B9BU6pqY5YH4xZBibELU7odSNirx8vDmy0TwEM8FfbLAU0Ax/np+E0v/gzQxaZ3fQo/+cVGtngwYuqx9ixwFcHkZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758898453; c=relaxed/simple;
	bh=8Xxc/7rtUPc9xnIONdcHNfifm0SJQdHjqk5dmuIuFG4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=VR/dJMOJ3EMQkRa1LbFayOV2yHOCcKh8V7v6ujUYLmRR0SUlapMpXUAyCLLKGOQrxG/AuUrUvf1kLFkadEkeqsqZbO3HhjJLxu59cFOzuTUvVPSn4OzsG+yMxJurQHfA6QjNXP55vHD5YR50osvzv/gVwBIEuZ3Z/ztr+r2b4do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=S6WpvQSx; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b4ee87cc81eso2002544a12.1
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 07:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758898450; x=1759503250; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fQ3d5ngg1DfO7r8b2XH43YDUg6JuZOy/Y/EgRNcVGic=;
        b=S6WpvQSx0pqMGWPV668JhEMW1L5E2FxFL8/5ipU2tZkI7U5fePXC5e5HaF70ZPzdx3
         dCtanS4VyHJGq0i8cTMW2X1nZAsuQtN/4ppV6Y9jl2YpShLNTQKtSn/ji1w2utj8v6TP
         Io4hpZdSfn8u6uVl0Z6bYz9DeeDscHz8E3YoHELyNzUbR5uDMz63yC7GAbmgx0ezSzla
         xJNEF3MvUAI9y5l/dT2iGoZw7Vz0cPi44D38xk3+jJPNwKJPnk84la3HIijE1NQrj4LC
         f4og9qeaNH5aapeFtN6EprcifbSefMF8uM9axsW8iGK45pD/GCMHPt7HYmfZJB0FnU1p
         CMxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758898450; x=1759503250;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fQ3d5ngg1DfO7r8b2XH43YDUg6JuZOy/Y/EgRNcVGic=;
        b=j+dV7Avbd58TGkR/YKziQnlEUKyfNNBs8jP4b8zPrto0QNRjRwJE4fdjGByqQx/bf6
         wVFR+Xu/R5GpzI8QWxR10cDeR84Kg11fkMqXGo4E+a9f8g443mKb9zbGbiWJ4NVESx6G
         xkVG/zRNXwy/G7jxvLfFAyPRH8+VYjQB86hvqlfp+NFcYX6jzn6NEKahzakPVtkjGuWj
         Zh0J4q06tHP7gRuWw+ak2eARTmfeVZ/h6hZIYhApy9j9XflOqbn/FV6Lxp/Pu1UWYlk6
         xOYoFtZu78g91BejYroYRhX6fS2OLeXHowQwyio2AEMbJ7nMdXfQo44BWjnv1HYgM28F
         eOcA==
X-Forwarded-Encrypted: i=1; AJvYcCVWQAKr1ExSwWNQERk08Kwh5OOINJg6zGdtwTmnHnwMTTQh4+Top6GNIlC52FWGzM/mkrI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9TZIxMZnm0lvTcb7mK/q4eVGsdvxQcwjcLS6Z1Lv5CqMHy7rI
	lx4QvFtmp4kgA6JPHcdH9SOae7i+/9hk80OfObBVwLYwXYAJhz8pehqAYLj3yhFKark=
X-Gm-Gg: ASbGncvQadBBKVBhyAAEe6eWMT8QIzjvo7R2H1hKNg8ijl2b39+RSwvrRk0r6o2CnkM
	nwd0oaS+yuD2o6hBFG5n33He6qkrwuy3tnW7KNAzcZa6ay6b3aUEB3sSC2nwZW3AeFOrUoL0frV
	Mn56XyHeqxQTVWethqToaho9wjOVMaXFijo+WSb+sOlIX9/CLwLe638C/PcAIpIOQ7oOhZwfX0A
	c9VZpbyYuMiMIoCEfWychTRYRv4TFYFSBlz8gQYl2L9QQK1YRSvjVoqbEIn2Nk5FSO5BoPNfwMQ
	KjmsT47ZHUlzwwxp583/4yxKakusMhQ9DzZVZ1dp8UAdfoGDPYrYVvi4U0o2bIrwyZ+xPNDovpz
	McOqu/01yU6TQSEyjXqpXOYgn63vlY691m4FdqxW+n4JGmztdZyjccIcRXw==
X-Google-Smtp-Source: AGHT+IEM5gfpTFeny4JGgiwPmQJtjR802N61GuO0pjn187ffL/azsDT3fsFt/ZGKNuDaQhw0bWZGdw==
X-Received: by 2002:a17:903:1a2b:b0:24c:ea17:e322 with SMTP id d9443c01a7336-27ed49df28dmr87377845ad.3.1758898450221;
        Fri, 26 Sep 2025 07:54:10 -0700 (PDT)
Received: from [10.254.228.139] ([139.177.225.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed69bc295sm56361985ad.123.2025.09.26.07.54.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Sep 2025 07:54:09 -0700 (PDT)
Message-ID: <5db494c6-c8dd-4073-bea0-5a62fce170e9@bytedance.com>
Date: Fri, 26 Sep 2025 22:54:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Fei Li <lifei.shirley@bytedance.com>
Subject: Re: [PATCH] KVM: x86: Restrict writeback of SMI VCPU state
To: pbonzini@redhat.com, mtosatti@redhat.com, seanjc@google.com,
 kvm@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Cc: qemu-devel@nongnu.org
References: <20250909063327.14263-1-lifei.shirley@bytedance.com>
Content-Language: en-US
In-Reply-To: <20250909063327.14263-1-lifei.shirley@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


Dear maintainers,

Could you please help to review the patch [PATCH] KVM: x86: Restrict 
writeback of SMI VCPU state? This fixes a race condition causing VM hang 
when frequently running `info registers -a` via HMP during VM startup. 
The issue occurs because unrestricted SMI state writeback conflicts with 
vCPU initialization sequences.

It would be very appreciated for us to know if this patch properly
resolve the race condition, and if validated, we would like to apply it 
to our production environment. Let me know if further details are needed. :)

Best regards, and thanks again!
Fei

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


