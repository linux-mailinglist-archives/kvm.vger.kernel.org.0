Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE62241632
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 08:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgHKGMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 02:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgHKGMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 02:12:03 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5A2C06174A
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 23:12:02 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id m22so11804036eje.10
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 23:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=EC2s2UxAm9/B/AAbw5pjnToVaeHtj6aEjb+OHmHkEnU=;
        b=erWOVI6Z+9H4X2KZ/elUdD2sNK7q9M4sJyALqDzZLf1EMnQQGYGxiumeX9KM1JwReR
         0RsoTkCdzCWFPdSnKlJq0s0BXeKhmBzlm+ESBLr107+jhB1TU9WviRybvHwln/7WbxzJ
         +M42exsmRngYm0QIVxbFRrHfADe1zDbVxd6BhLX2jYVwEXsy2qFQ5MEx/GgOau1qtsvD
         8LFe5Ga+uv/jhbcCmgVgR86FyeqEFmV7XYOGXTTrTXZieh8qV7oVDeXuaGx5fT3/UZFw
         M6TqMjQCGLi3zk+KVfVaX0vC33rIL2Wk6OR9UAVfFhZNGriQPI74aWwXc1xIk+WxqCH2
         6qjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=EC2s2UxAm9/B/AAbw5pjnToVaeHtj6aEjb+OHmHkEnU=;
        b=JN8QVeO8hzGqHE/S+7Rof36cqFMrKcMK5PEFVG3DrBWnpO4N0FC6j53WlDeIyxQUfe
         CYguyQWFkbTIZ7D06oVt974SG+0nhkK0n96Dpwu1AZ7QSUcQF5BjGs3lUvveUaW3dKpV
         rG9P8HCb5fBdb2ilPwwA2flRQBK62g8inNVOnqak2QeT7lmdzRkEhWCPy9l0plZwOVfm
         UYMbM33RFZowB0EDO1fPmjJcKvZIg5xeg7xCz2fft9f20CcPjEBDTOMbIDjw/uRU/Snd
         R6oX7nFHcffHCS5Zj7MScPxx6heqH2S7PYLnIhAcuswj1x8g45mDFhozk0k5ZsLhR8tF
         Rk5Q==
X-Gm-Message-State: AOAM5335iYgTF5SUuqJL9U39YKzxl1nLzd2f6Hm0hiDsBCDAtCEzZuMM
        y72xeclpAengyzT03XxyJfSbHR5rODhhhj60zyDAO1s6QHc=
X-Google-Smtp-Source: ABdhPJwX+YR04ULERVjS0Kfv3k3ccXZeggNWqR4rp0P70pqScIcb3h31rkxVtfaartuXrhRRcHferOylvUz04u6lihw=
X-Received: by 2002:a17:906:a116:: with SMTP id t22mr25621694ejy.353.1597126321124;
 Mon, 10 Aug 2020 23:12:01 -0700 (PDT)
MIME-Version: 1.0
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 11 Aug 2020 08:11:50 +0200
Message-ID: <CAMGffEmmxYydk8E-nRMatG0KTUqWnBg3Tj=M24M4AJBkO+-hkQ@mail.gmail.com>
Subject: [BUG]stack-protector: Kernel stack is corrupted in:
 apic_update_ppr+0x65/0x70 [kvm]
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, experts,

We hit a panic in kvm on AMD Opteron 6386 SE with follow call trace:

[398397.405320] Kernel panic - not syncing: stack-protector: Kernel
stack is corrupted in: apic_update_ppr+0x65/0x70 [kvm]
[398397.405596] CPU: 4 PID: 13026 Comm: qemu-5.0 Kdump: loaded
Tainted: G           O      4.19.105-pserver #4.19.105-8~deb9
[398397.405852] Hardware name: Supermicro SBA-7142G-T4/BHQGE, BIOS
3.50a      05/22/2015
[398397.406124] Call Trace:
[398397.406283]  dump_stack+0x50/0x6b
[398397.406440]  panic+0xde/0x242
[398397.406606]  ? svm_vcpu_run+0x2a9/0x780 [kvm_amd]
[398397.406804]  ? apic_update_ppr+0x65/0x70 [kvm]
[398397.406962]  __stack_chk_fail+0x15/0x20
[398397.407156]  apic_update_ppr+0x65/0x70 [kvm]
[398397.407373]  ? kvm_set_cr8.part.157+0xf/0x30 [kvm]
[398397.407535]  ? svm_vcpu_run+0x435/0x780 [kvm_amd]
[398397.407731]  ? kvm_arch_vcpu_ioctl_run+0x87f/0x1a70 [kvm]
[398397.407928]  ? kvm_arch_vcpu_ioctl_run+0x87f/0x1a70 [kvm]
[398397.408088]  ? futex_wake+0x91/0x170
[398397.408273]  ? kvm_vcpu_ioctl+0x388/0x5d0 [kvm]
[398397.408460]  ? kvm_vcpu_ioctl+0x388/0x5d0 [kvm]
[398397.408647]  ? __switch_to_asm+0x35/0x70
[398397.408802]  ? __switch_to_asm+0x41/0x70
[398397.408957]  ? __switch_to_asm+0x35/0x70
[398397.409113]  ? __switch_to_asm+0x41/0x70
[398397.409267]  ? __switch_to_asm+0x35/0x70
[398397.409421]  ? __switch_to_asm+0x41/0x70
[398397.409575]  ? __switch_to_asm+0x35/0x70
[398397.409756]  ? __switch_to_asm+0x41/0x70
[398397.409912]  ? __switch_to_asm+0x35/0x70
[398397.410069]  ? __switch_to_asm+0x41/0x70
[398397.410232]  ? do_vfs_ioctl+0xa2/0x620
[398397.410389]  ? __x64_sys_futex+0x88/0x180
[398397.410548]  ? ksys_ioctl+0x70/0x80
[398397.410705]  ? __x64_sys_ioctl+0x16/0x20
[398397.410861]  ? do_syscall_64+0x48/0x100
[398397.411043]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

crash> dis -l apic_update_ppr
0xffffffffc07e6660 <apic_update_ppr>:    nopl   0x0(%rax,%rax,1) [FTRACE NOP]
0xffffffffc07e6665 <apic_update_ppr+5>:    push   %rbx
0xffffffffc07e6666 <apic_update_ppr+6>:    mov    %rdi,%rbx
0xffffffffc07e6669 <apic_update_ppr+9>:    sub    $0x10,%rsp
0xffffffffc07e666d <apic_update_ppr+13>:    lea    0x4(%rsp),%rsi
0xffffffffc07e6672 <apic_update_ppr+18>:    mov    %gs:0x28,%rax
0xffffffffc07e667b <apic_update_ppr+27>:    mov    %rax,0x8(%rsp)
0xffffffffc07e6680 <apic_update_ppr+32>:    xor    %eax,%eax
0xffffffffc07e6682 <apic_update_ppr+34>:    callq  0xffffffffc07e65c0
<__apic_update_ppr>
0xffffffffc07e6687 <apic_update_ppr+39>:    test   %al,%al
0xffffffffc07e6689 <apic_update_ppr+41>:    jne    0xffffffffc07e66a1
<apic_update_ppr+65>
0xffffffffc07e668b <apic_update_ppr+43>:    mov    0x8(%rsp),%rax
0xffffffffc07e6690 <apic_update_ppr+48>:    xor    %gs:0x28,%rax
0xffffffffc07e6699 <apic_update_ppr+57>:    jne    0xffffffffc07e66c0
<apic_update_ppr+96>
0xffffffffc07e669b <apic_update_ppr+59>:    add    $0x10,%rsp
0xffffffffc07e669f <apic_update_ppr+63>:    pop    %rbx
0xffffffffc07e66a0 <apic_update_ppr+64>:    retq
0xffffffffc07e66a1 <apic_update_ppr+65>:    mov    0x4(%rsp),%esi
0xffffffffc07e66a5 <apic_update_ppr+69>:    mov    %rbx,%rdi
0xffffffffc07e66a8 <apic_update_ppr+72>:    callq  0xffffffffc07e57d0
<apic_has_interrupt_for_ppr>
0xffffffffc07e66ad <apic_update_ppr+77>:    cmp    $0xffffffff,%eax
0xffffffffc07e66b0 <apic_update_ppr+80>:    je     0xffffffffc07e668b
<apic_update_ppr+43>
0xffffffffc07e66b2 <apic_update_ppr+82>:    mov    0x90(%rbx),%rax
0xffffffffc07e66b9 <apic_update_ppr+89>:    lock orb $0x40,0x31(%rax)
0xffffffffc07e66be <apic_update_ppr+94>:    jmp    0xffffffffc07e668b
<apic_update_ppr+43>
0xffffffffc07e66c0 <apic_update_ppr+96>:    callq  0xffffffff8a06fa60
<__stack_chk_fail>
crash> dis -l apic_update_ppr+0x65
0xffffffffc07e66c5 <apic_update_ppr+101>:    nop
crash>

possible call stack on AMD: kvm_set_cr8() can call kvm_lapic_set_tpr()
-> apic_set_tpr() -> apic_update_ppr()

I'm confused about "apic_update_ppr+101" is nop and it will make more
sense if it is "apic_update_ppr+96" to me.

Anyone see this bug before, I checked the latest mainline, couldn't
find any fix looks relevant, maybe I missed something, or it is simply
because the machine is too old it's a 6+ years old machine. lscpu
result attached
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                64
On-line CPU(s) list:   0-63
Thread(s) per core:    2
Core(s) per socket:    8
Socket(s):             4
NUMA node(s):          8
Vendor ID:             AuthenticAMD
CPU family:            21
Model:                 2
Model name:            AMD Opteron(tm) Processor 6386 SE
Stepping:              0
CPU MHz:               1398.628
CPU max MHz:           2800,0000
CPU min MHz:           1400,0000
BogoMIPS:              5600.23
Virtualization:        AMD-V
L1d cache:             16K
L1i cache:             64K
L2 cache:              2048K
L3 cache:              6144K
NUMA node0 CPU(s):     0-7
NUMA node1 CPU(s):     8-15
NUMA node2 CPU(s):     16-23
NUMA node3 CPU(s):     24-31
NUMA node4 CPU(s):     32-39
NUMA node5 CPU(s):     40-47
NUMA node6 CPU(s):     48-55
NUMA node7 CPU(s):     56-63
Flags:                 fpu vme de pse tsc msr pae mce cx8 apic sep
mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx
mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl
nonstop_tsc cpuid extd_apicid amd_dcm aperfmperf pni pclmulqdq monitor
ssse3 fma cx16 sse4_1 sse4_2 popcnt aes xsave avx f16c lahf_lm
cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch
osvw ibs xop skinit wdt fma4 tce nodeid_msr tbm topoext perfctr_core
perfctr_nb cpb hw_pstate ssbd ibpb vmmcall bmi1 arat npt lbrv svm_lock
nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter
pfthreshold

Any comments are appreciated.
-- 
Jinpu Wang
Linux Kernel Developer (IONOS Cloud)
