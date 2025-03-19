Return-Path: <kvm+bounces-41473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD61A6831E
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 03:20:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29B3E1897DBB
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 02:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18772248BB;
	Wed, 19 Mar 2025 02:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BNvV5+P/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEDEC2FA
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 02:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742350772; cv=none; b=WBGPvuWFUrjmtcDqSx65LwFTHtykyAIhGWl5YhN5ONXYbaEzyk4QtTofhxnpsqigwGXrzRKwJ5d4hxIEL6IRyJCt5qx5Id1/0oXO6IAC0wAKT4r1xOdiTX0EbpQNjGYcrRlSswUVly8O6A7zQ20uzlJBMZivPrOm2FTmHDbZKjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742350772; c=relaxed/simple;
	bh=T6h+eGb6IctvvRb2yKa6vpmcJTKcV40EmcIUDwKAMOc=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=iVX2QFnTeuOQeZTUWJMwE9OWnPJkBXmK15okFzLB0Pu4+LzFgpfnD6PlBKaxh34QMhxSVb4II4ZTq1l1d5zDf0H1axIH5ZKpw8F3T//SvYj0nmzKwitnAi73hmJ8SoR/6PNPu7m7R2+gTkTEuKzWxKYPT9J91PGFoGlf1uXwy7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BNvV5+P/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742350769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eY1Sfwx7qn9rsWmVUan2KMr9bf5fBfzYPb+q3lvb8Tw=;
	b=BNvV5+P/YsKX92VOlfahUNsI+mmisFT0+1FLnW+feqKXEPAwtQ+4XbdBHJB2fsz8Ks2jQZ
	LbIOxZjzTR1vTSBLNc5MmtdsheE4md10ipBgfTyVWGYbWlfz4rufPtnHV3giw8OMbS36xu
	eu4VP5ggaCHw4ylP2/h+EaZdvLlEwnc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-d0UrPlp7NWqMYM-QaFKUfQ-1; Tue, 18 Mar 2025 22:19:28 -0400
X-MC-Unique: d0UrPlp7NWqMYM-QaFKUfQ-1
X-Mimecast-MFC-AGG-ID: d0UrPlp7NWqMYM-QaFKUfQ_1742350767
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7bb849aa5fbso80005985a.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 19:19:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742350767; x=1742955567;
        h=content-transfer-encoding:mime-version:user-agent:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eY1Sfwx7qn9rsWmVUan2KMr9bf5fBfzYPb+q3lvb8Tw=;
        b=OB3uW1M47SIPQfl5A7WAsqm5zN7jkKJ+PqYf3bfvlEKhUo9wfXsYECWuBH2hhiumNk
         WDlGsbFGPtWAUUyqw74NqEH6raBw0ZZTfi2yT/1cpzDhq3LZ+g9Xt3ez53nmFEpgbPed
         PFvP2EEld0uI2GALr9oQb6w9NosEbJsFgbOi+cZ6tjAGOg1kjCebpwnXhkd+S18lVMgt
         h5TNaLdgKkK9PI3hGKCQUrZ5cZ/kReYzWrfyMsjku7FVWp2irKpf1QUqiJj8oCk21JQ+
         LXLBBaRsI7QTJLKF8zg2l2/uaHszyAblVsSFl1TNNP+hq/ekZMF874B9DwVvGfLytyBA
         zfJw==
X-Gm-Message-State: AOJu0YyORxyQwADbQXujRuK03VVYBI7DC5oexE4tP6FSn4mIfMmngg/j
	hURz5NOlN0F7oB0mR8+c0xRrGmxo6K/mqbQlUmqjFWdwgFqCpXZsdxvZX5VmkN1+LfYue7q22gs
	QgL9iv8J/pep2zTrhivLTkH1xZpPZKzzxSmMTuXAoOZI0djDoqMlFguZkkecxUK5QEYJEt99jGI
	nBexidRE/RXcJcPl+qUdsD7zIzjyZVNhIEQQ==
X-Gm-Gg: ASbGncvK8rgZcZMjROB/sdo7j2XaeLW2B4dw41ITlpVwbWSSI0bM7kgIlRsKfxnQzRP
	Npx5hGWXfdw0jUAJppz+8f472I0glS16e+ATTV0ld9K3VVCKJxlH2KA4SDTwAJw0anei3fYtbW7
	2/QJRIb4L790CkGrCLmIBWRRKzpKqzWodG2VyvGeucmDqQQgAgq9e8gDMdBdHLml4NCzaWHKJQH
	nramxx17caR6xYb1OTLttlh/6Tu+tTN6zHhR1rQyOCMZ1YJ5TOUk88G0nHIiVIZnT7Gg4EXot9P
	gxlablNkz6Cj2yM=
X-Received: by 2002:a05:620a:2616:b0:7c5:3da2:fc75 with SMTP id af79cd13be357-7c5a8396adbmr109086185a.24.1742350767329;
        Tue, 18 Mar 2025 19:19:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHn7/OU2Op2wJ7aHTTJIs0jJI8LibDmh5scuCyc5IYt6dTixRCDoszxg8Lg4XYhnX55Zt/Ylw==
X-Received: by 2002:a05:620a:2616:b0:7c5:3da2:fc75 with SMTP id af79cd13be357-7c5a8396adbmr109084885a.24.1742350766932;
        Tue, 18 Mar 2025 19:19:26 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c573c4f53csm796461785a.22.2025.03.18.19.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 19:19:26 -0700 (PDT)
Message-ID: <e61d23ddc87cb45063637e0e5375cc4e09db18cd.camel@redhat.com>
Subject: Lockdep failure due to 'wierd' per-cpu wakeup_vcpus_on_cpu_lock lock
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Date: Tue, 18 Mar 2025 22:19:25 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Hi!

I recently came up with an interesting failure in the CI pipeline.


[  592.704446] WARNING: possible circular locking dependency detected 
[  592.710625] 6.12.0-36.el10.x86_64+debug #1 Not tainted 
[  592.715764] ------------------------------------------------------ 
[  592.721946] swapper/19/0 is trying to acquire lock: 
[  592.726823] ff110001b0e64ec0 (&p->pi_lock)\{-.-.}-\{2:2}, at: try_to_wake_up+0xa7/0x15c0 
[  592.734761]  
[  592.734761] but task is already holding lock: 
[  592.740596] ff1100079ec0c058 (&per_cpu(wakeup_vcpus_on_cpu_lock, cpu))\{-...}-\{2:2}, at: pi_wakeup_handler+0x60/0x130 [kvm_intel] 
[  592.752185]  
[  592.752185] which lock already depends on the new lock. 
[  592.752185]  
[  592.760357]  
[  592.760357] the existing dependency chain (in reverse order) is: 
[  592.767837]  
[  592.767837] -> #2 (&per_cpu(wakeup_vcpus_on_cpu_lock, cpu))\{-...}-\{2:2}: 
[  592.776027]        __lock_acquire+0xcac/0x1d20 
[  592.780489]        lock_acquire.part.0+0x11b/0x360 
[  592.785300]        _raw_spin_lock+0x37/0x80 
[  592.789484]        pi_enable_wakeup_handler+0x11a/0x5a0 [kvm_intel] 
[  592.795776]        vmx_vcpu_pi_put+0x1d3/0x230 [kvm_intel] 
[  592.801282]        vmx_vcpu_put+0x12/0x20 [kvm_intel] 
[  592.806360]        kvm_arch_vcpu_put+0x494/0x7a0 [kvm] 
[  592.811592]        kvm_sched_out+0x161/0x1c0 [kvm] 
[  592.816456]        prepare_task_switch+0x36c/0xe20 
[  592.821247]        __schedule+0x481/0x1a50 
[  592.825346]        schedule+0xd4/0x280 
[  592.829100]        kvm_vcpu_block+0xe4/0x1d0 [kvm] 
[  592.833964]        kvm_vcpu_halt+0x1a2/0x800 [kvm] 
[  592.838824]        vcpu_run+0x53f/0x9e0 [kvm] 
[  592.843263]        kvm_arch_vcpu_ioctl_run+0x371/0x1480 [kvm] 
[  592.849078]        kvm_vcpu_ioctl+0x45e/0xc70 [kvm] 
[  592.854034]        __x64_sys_ioctl+0x12e/0x1a0 
[  592.858481]        do_syscall_64+0x92/0x180 
[  592.862685]        entry_SYSCALL_64_after_hwframe+0x76/0x7e 
[  592.868276]  
[  592.868276] -> #1 (&rq->__lock)\{-.-.}-\{2:2}: 
[  592.874038]        __lock_acquire+0xcac/0x1d20 
[  592.878485]        lock_acquire.part.0+0x11b/0x360 
[  592.883277]        _raw_spin_lock_nested+0x3b/0x70 
[  592.888069]        raw_spin_rq_lock_nested+0x2e/0x130 
[  592.893121]        __task_rq_lock+0xdb/0x570 
[  592.897393]        wake_up_new_task+0x750/0x1050 
[  592.902014]        kernel_clone+0x13e/0x5f0 
[  592.906209]        user_mode_thread+0xa4/0xe0 
[  592.910568]        rest_init+0x1e/0x1c0 
[  592.914407]        start_kernel+0x3ab/0x3b0 
[  592.918592]        x86_64_start_reservations+0x24/0x30 
[  592.923732]        x86_64_start_kernel+0x9c/0xa0 
[  592.928353]        common_startup_64+0x13e/0x141 
[  592.932988]  
[  592.932988] -> #0 (&p->pi_lock)\{-.-.}-\{2:2}: 
[  592.938754]        check_prev_add+0x1b7/0x23e0 
[  592.943200]        validate_chain+0xa8a/0xf00 
[  592.947557]        __lock_acquire+0xcac/0x1d20 
[  592.952005]        lock_acquire.part.0+0x11b/0x360 
[  592.956797]        _raw_spin_lock_irqsave+0x46/0x90 
[  592.961676]        try_to_wake_up+0xa7/0x15c0 
[  592.966035]        rcuwait_wake_up+0x80/0x190 
[  592.970396]        kvm_vcpu_wake_up+0x19/0xa0 [kvm] 
[  592.975353]        pi_wakeup_handler+0xf4/0x130 [kvm_intel] 
[  592.980950]        sysvec_kvm_posted_intr_wakeup_ipi+0x9c/0xd0 
[  592.986783]        asm_sysvec_kvm_posted_intr_wakeup_ipi+0x1a/0x20 
[  592.992964]        finish_task_switch.isra.0+0x228/0x830 
[  592.998275]        __schedule+0x7c7/0x1a50 
[  593.002376]        schedule_idle+0x59/0x90 
[  593.006477]        do_idle+0x155/0x200 
[  593.010244]        cpu_startup_entry+0x54/0x60 
[  593.014693]        start_secondary+0x212/0x290 
[  593.019138]        common_startup_64+0x13e/0x141 
[  593.023758]  
[  593.023758] other info that might help us debug this: 
[  593.023758]  
[  593.031757] Chain exists of: 
[  593.031757]   &p->pi_lock --> &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock, cpu) 
[  593.031757]  
[  593.043932]  Possible unsafe locking scenario: 
[  593.043932]  
[  593.049852]        CPU0                    CPU1 
[  593.054384]        ----                    ---- 
[  593.058918]   lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu)); 
[  593.064576]                                lock(&rq->__lock);
[  593.070323]                                lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu)); 
[  593.078496]   lock(&p->pi_lock); 
[  593.081745]  
[  593.081745]  *** DEADLOCK *** 
[  593.081745]  
[  593.087666] 2 locks held by swapper/19/0: 
[  593.091679]  #0: ff1100079ec0c058 (&per_cpu(wakeup_vcpus_on_cpu_lock, cpu))\{-...}-\{2:2}, at: pi_wakeup_handler+0x60/0x130 [kvm_intel] 
[  593.103692]  #1: ffffffffa9b3eec0 (rcu_read_lock)\{....}-\{1:2}, at: rcuwait_wake_up+0x22/0x190 
[  593.112227]  

[  593.112227] stack backtrace: 
[  593.116590] CPU: 19 UID: 0 PID: 0 Comm: swapper/19 Kdump: loaded Not tainted 6.12.0-36.el10.x86_64+debug #1 
[  593.126338] Hardware name: Dell Inc. PowerEdge R660/0R5JJC, BIOS 2.1.5 03/14/2024 
[  593.133818] Call Trace: 
[  593.136271]  <IRQ> 
[  593.138291]  dump_stack_lvl+0x6f/0xb0 
[  593.141965]  print_circular_bug.cold+0x38/0x48 
[  593.146427]  check_noncircular+0x308/0x3f0 
[  593.150545]  ? __pfx_check_noncircular+0x10/0x10 
[  593.155180]  ? __module_address+0x95/0x240 
[  593.159300]  ? alloc_chain_hlocks+0x33b/0x520 
[  593.163675]  check_prev_add+0x1b7/0x23e0 
[  593.167620]  validate_chain+0xa8a/0xf00 
[  593.171478]  ? __pfx_validate_chain+0x10/0x10 
[  593.175850]  ? mark_lock+0x78/0x860 
[  593.179360]  ? __pfx_lockdep_lock+0x10/0x10 
[  593.183549]  __lock_acquire+0xcac/0x1d20 
[  593.187494]  ? __pfx_validate_chain+0x10/0x10 
[  593.191867]  lock_acquire.part.0+0x11b/0x360 
[  593.196156]  ? try_to_wake_up+0xa7/0x15c0 
[  593.200172]  ? __pfx_lock_acquire.part.0+0x10/0x10 
[  593.204980]  ? rcu_is_watching+0x15/0xb0 
[  593.208907]  ? trace_lock_acquire+0x1b9/0x280 
[  593.213265]  ? try_to_wake_up+0xa7/0x15c0 
[  593.217294]  ? lock_acquire+0x31/0xc0 
[  593.220961]  ? try_to_wake_up+0xa7/0x15c0 
[  593.224975]  _raw_spin_lock_irqsave+0x46/0x90 
[  593.229351]  ? try_to_wake_up+0xa7/0x15c0 
[  593.233362]  try_to_wake_up+0xa7/0x15c0 
[  593.237220]  ? trace_lock_acquire+0x1b9/0x280 
[  593.241581]  ? __pfx_try_to_wake_up+0x10/0x10 
[  593.245958]  rcuwait_wake_up+0x80/0x190 
[  593.249816]  kvm_vcpu_wake_up+0x19/0xa0 [kvm] 
[  593.254260]  pi_wakeup_handler+0xf4/0x130 [kvm_intel] 
[  593.259338]  sysvec_kvm_posted_intr_wakeup_ipi+0x9c/0xd0 
[  593.264668]  </IRQ> 
[  593.266772]  <TASK> 
[  593.268880]  asm_sysvec_kvm_posted_intr_wakeup_ipi+0x1a/0x20 
[  593.274557] RIP: 0010:finish_task_switch.isra.0+0x228/0x830 
[  593.280147] Code: 41 ff 4d 00 0f 84 95 03 00 00 81 7d d0 80 00 00 00 0f 84 bd 03 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc <49> 8d be 00 05 00 00 48 b8 00 00 00 00 00 fc ff df
48 89 fa 48 c1 
[  593.298894] RSP: 0018:ffa0000000747cd8 EFLAGS: 00000206 
[  593.304137] RAX: 000000000016e47d RBX: ff1100079ec08e40 RCX: 0000000000000000 
[  593.311269] RDX: 0000000000000000 RSI: ffffffffa82f4140 RDI: ffffffffa85a2fa0 
[  593.318403] RBP: ffa0000000747d18 R08: 0000000000000001 R09: 0000000000000000 
[  593.325534] R10: 0000000000000001 R11: 0000000000000000 R12: ff110001b0e63f80 
[  593.332667] R13: 0000000000000000 R14: ff11000101dabf80 R15: ff1100079ec09e60 
[  593.339803]  ? finish_task_switch.isra.0+0x1b9/0x830 
[  593.344785]  ? __switch_to+0xc31/0xfa0 
[  593.348537]  ? __switch_to_asm+0x3d/0x70 
[  593.352483]  __schedule+0x7c7/0x1a50 
[  593.356077]  ? __pfx___schedule+0x10/0x10 
[  593.360107]  ? __pfx_sched_ttwu_pending+0x10/0x10 
[  593.364829]  ? rcu_is_watching+0x15/0xb0 
[  593.368777]  schedule_idle+0x59/0x90 
[  593.372370]  do_idle+0x155/0x200 
[  593.375605]  cpu_startup_entry+0x54/0x60 
[  593.379547]  start_secondary+0x212/0x290 
[  593.383483]  ? __pfx_start_secondary+0x10/0x10 
[  593.387945]  ? startup_64_load_idt+0xc1/0xf0 
[  593.392235]  common_startup_64+0x13e/0x141 
[  593.396355]  </TASK> 


I reproduced the failure upstream as well. 
In fact it reproduces well on a Sapphire Rapids system which I use for testing
('Intel(R) Xeon(R) Silver 4410Y')

To reproduce I just need to run the kvm selftests on a lockdep enabled kernel.

If I am not mistaken the following happens:


1. pi_enable_wakeup_handler() is called when the current vCPU is scheduled out

   it will then
	- *disable interrupts*
	- take a per-cpu lock 'wakeup_vcpus_on_cpu_lock' of the *current CPU*
	- add the current vCPU to the per-cpu list which is protected by the lock above.
	- enable interrupts


2. pi_wakeup_handler (IRQ handler) will also
	- take wakeup_vcpus_on_cpu_lock of *current CPU*
	- go over the vCPUs in the wakeup_vcpus_on_cpu list of *current CPU*, and kick them.


AFAIK, (1) and (2) can't race with each other and in fact no locking is needed here to prevent
a race.

The lock is required to prevent race with another place with needs access to the 'wakeup_vcpus_on_cpu' list:

(3)

When a sleeping vCPU is waken up it is scheduled to run (e.g. due to the kick above or other reason)
CPU, then  *vmx_vcpu_pi_load* will

	- disable interrupts (to avoid race with (1))
	- take wakeup_vcpus_on_cpu_lock (maybe of a different cpu)
	- remove this vCPU from the wakeup_vcpus_on_cpu list of that different CPU
	- release the lock and re-enable interrupts.

As far as I see, there is no race, but lockdep doesn't understand this.

It thinks that:

1. pi_enable_wakeup_handler is called from schedule() which holds rq->lock, and it itself takes wakeup_vcpus_on_cpu_lock lock

2. pi_wakeup_handler takes wakeup_vcpus_on_cpu_lock and then calls try_to_wake_up which can eventually take rq->lock
(at the start of the function there is a list of cases when it takes it)

I don't know lockdep well yet, but maybe a lockdep annotation will help, 
if we can tell it that there are multiple 'wakeup_vcpus_on_cpu_lock' locks.


What do you think?

Best regards,
	Maxim Levitsky






