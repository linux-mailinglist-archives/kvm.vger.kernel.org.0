Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715BF2E8D15
	for <lists+kvm@lfdr.de>; Sun,  3 Jan 2021 17:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbhACQYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Jan 2021 11:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbhACQYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Jan 2021 11:24:14 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4B7C061573
        for <kvm@vger.kernel.org>; Sun,  3 Jan 2021 08:23:34 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id k8so23138759ilr.4
        for <kvm@vger.kernel.org>; Sun, 03 Jan 2021 08:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc;
        bh=feHhG6Psk88aTpcLO1gfxXXzhMpjv7QUIy5dI8FYCg4=;
        b=WBZCSPXhBjElbmgtLPAp5yeCB3GcCr2B66/Ym2yQt1U/zumXFzrJpSxmQiZ2Uz+cCj
         IyBAThi+4p/RJijALURLixklrBjvrlKyeGkhBmi2ON7a4I70FzakF8kpAFqMs5Cqst1v
         uslIPJAngJoKVHbYBtPTDzepwVgcq0tmijr3GFt9fWToFOjrEEMd4jhxNiNQBkn413Sy
         cFghkEADokv6BWejgO+tFGJTohSzAjY9UawF5ZrbXDZU86MA4X5JmkUhEAscHBf1uecp
         oye8y/z9395NFpr0n2w28+e/61fcYzme+e+oSX0GGOvGsVQzLOF2hl4ZK2949Vw+3UAt
         aMpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:cc;
        bh=feHhG6Psk88aTpcLO1gfxXXzhMpjv7QUIy5dI8FYCg4=;
        b=Bs6y8igT0UzJS2PmGwzxdzOCQsTS4f5jMUvIJtaDk5KavCg72VuGYFMOfZInQTgXiC
         PPDy/hkjxX1JaJs1GXj7le9DOc06zAnLk/hDdShcFYw+FOpH7dBh7xiWQfq6yy6oOUQO
         0QVrIGNgC0/1yiQPmoohqWoGR+kwz0x9PQnzEu41GXt7EzuLE8eed4JHLjhy3AUX1Fwa
         u+hRkAKPZyWQ/Y/yE501/uO3U5EA5s9CX+W40ZJkw0kPa0LKEZw9KURWwyj77JQefGQ1
         pORBgFrHgVP4jy+Wmu0detUEFl+07SK4Ze6G5/wJE6vEpK1dAq5aQ3qHMBoMcpnaWLOU
         N5dg==
X-Gm-Message-State: AOAM531D+tBLEwh4NRYoYIGyPMNPXjNIUFNITOmxLpzEXC2/BixScR48
        YZoim3sshfbIvXYHaphc5LTkUomu1myAhsR/nhcAoOF+rw==
X-Google-Smtp-Source: ABdhPJzDqaP7loggHFac86+JQ4oyT4Pc9SL+VQDCRYNUi8diAyHChobOGGyIyqTePW+QDNAz5x41AdeuZ9BsnBliF80=
X-Received: by 2002:a92:d1cd:: with SMTP id u13mr50306530ilg.186.1609691013739;
 Sun, 03 Jan 2021 08:23:33 -0800 (PST)
MIME-Version: 1.0
Reply-To: whiteheadm@acm.org
From:   tedheadster <tedheadster@gmail.com>
Date:   Sun, 3 Jan 2021 11:23:20 -0500
Message-ID: <CAP8WD_bZXpQnENCay5hDaoTQDHm26nRj9Lsa1PMQsd2wNHxe5A@mail.gmail.com>
Subject: kvm_arch_para_features() call triggers invalid opcode on i486
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,
  I am doing regression testing on a first generation i486 and came up
with a kernel crash because it incorrectly thinks the processor
supports KVM features. Yes, we do still support the ancient i486.

This processor does NOT have the cpuid instruction, and I believe
testing for it returns -1 (not supported) in two's-compliment form.

I think the -1 is not checked for, and this is causing
kvm_arch_para_features() to think it _does_ support
KVM_CPUID_FEATURES, causing it to later execute an invalid opcode
(cpuid).

Here is the dmesg output:

[    0.580000] clocksource: pit: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 1601818034827 ns
[    0.584000] invalid opcode: 0000 [#1] PREEMPT
[    0.584000] CPU: 0 PID: 1 Comm: swapper Not tainted
5.4.86.i486-i486-m486-i486 #7707
[    0.584000] EIP: kvm_arch_para_features+0x15/0x1a
[    0.584000] Code: 74 12 55 89 e5 31 c9 31 d2 b8 03 4d 56 4b e8 8b
fb ff ff 5d c3 3e 8d 74 26 00 55 89 e5 53 e8 67 fc ff ff 0d 01 00 00
40 31 c9 <0f> a2 5b 5d c3 55 89 e5 53 89 c3 e8 db ff ff ff 88 d9 d3 e8
83 e0
[    0.584000] EAX: 40000001 EBX: 00000009 ECX: 00000000 EDX: c15e7080
[    0.584000] ESI: c167282f EDI: ffffffff EBP: cf06ff20 ESP: cf06ff1c
[    0.584000] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00010246
[    0.584000] CR0: 80050033 CR2: 00000000 CR3: 016e3000 CR4: 00000000
[    0.584000] Call Trace:
[    0.584000]  kvm_para_has_feature+0xb/0x15
[    0.584000]  kvm_setup_pv_tlb_flush+0x12/0x46
[    0.584000]  do_one_initcall+0x4c/0x163
[    0.584000]  ? kernel_init_freeable+0xcf/0x18f
[    0.584000]  kernel_init_freeable+0xfe/0x18f
[    0.584000]  ? rest_init+0x93/0x93
[    0.584000]  kernel_init+0xd/0xda
[    0.584000]  ret_from_fork+0x19/0x30
[    0.584000] Modules linked in:
[    0.588000] ---[ end trace d6d5e35d5ec118f1 ]---


The call is coming from arch/x86/kernel/kvm.c:

unsigned int kvm_arch_para_features(void)
{
        return cpuid_eax(kvm_cpuid_base() | KVM_CPUID_FEATURES);
}

# grep cpuid /proc/cpuinfo
cpuid level     : -1

# /usr/bin/cpuid
CPU 0:
[ 1035.325926] traps: cpuid[140] trap invalid opcode ip:49bf31
sp:bfe36280 error:0[ 1035.331956]  in cpuid[480000+3f000]
Illegal instruction

- Matthew
