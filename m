Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199004707EF
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 18:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244807AbhLJSBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 13:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbhLJSBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 13:01:06 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2B0C061746
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 09:57:31 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id s137so8675226pgs.5
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 09:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=82cgqNZK1adHE0HobiyEbRDBVUx9eE73SYr9I2nNyBY=;
        b=bAxOlM6nwNJz2aFiHLm2kw45u+tCMwgRkGll+2hl2aKK36NOHSb8/qohj0Du6sBrEN
         poYIBuPO+eb9yrLR3zP/FZzQ1k2ELeC40duu8IE41paoPEkZq+n1VVCEZ636hJnm9SU4
         CX+LEVAz9ZOjIDHr9Y9ZprVWDGdjUKoN4y7bjRlPl5S6LxY/CBP7J+Qa6K+pwysa7pJy
         fMk4iKL13F+5DwM5MlOJMorAcfqtvikp2qlFDpE83UKvK8tXN3qOLZoIxnLVuzY6498F
         4GDw/G+exuP3cipx8II11J4lyRezJF3tYubf93+EAPk/rWQiD4nbUAp+1cuDgrJu10u8
         +Olw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=82cgqNZK1adHE0HobiyEbRDBVUx9eE73SYr9I2nNyBY=;
        b=qEUvUMZ/dU0siauBsQ3FSGaDv+8WGwXledeLBiaA0hbvN0B6PXnVOkmcwS0nKG4b4E
         4BZjuA9pyInQ89sQA8QdnN9JItl7/xmrNwVTr2yR0WhoKQJ/mdhsdvfwf50FZFoLVqEu
         gG7DtMIo1LIgICHRgjhYJ6OhntzO1J32byOQmfmYuda5EtBIqbjVYcM7C4SI2CUPRLZb
         GZ+2uhXv2CADnlXApvJ+RS8U0JWYCcxMWNjX1ki4iuBeRr1WJa0mtEUgFiaaOPu7dWsP
         pNcwpRXc37Bpanr6Ix3o/CITW9/Mm91lDkxicw1z/YaQiuY8q8gX5cSGOGqCDtuis+i9
         9+DQ==
X-Gm-Message-State: AOAM532YZvHEpRtsHL3bAkEcJl/35Ne5vMA5FFSBKh5+bBzAsgN86yfI
        h5JKuhuU2/aB59JXWLDG68Otloqa10cVug==
X-Google-Smtp-Source: ABdhPJyUq++fuNJEjEGe6PETiXGkhrVmaChJlvc0wAYNor8J7yLH81X/Ux0zZh8s48JCW3rG3qrCtQ==
X-Received: by 2002:a62:d0c3:0:b0:4ad:51e9:963e with SMTP id p186-20020a62d0c3000000b004ad51e9963emr19190404pfg.36.1639159050250;
        Fri, 10 Dec 2021 09:57:30 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id z14sm4204704pfh.60.2021.12.10.09.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 09:57:29 -0800 (PST)
Date:   Fri, 10 Dec 2021 17:57:24 +0000
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        laijs@linux.alibaba.com
Subject: VM_BUG_ON in vmx_prepare_switch_to_guest->__get_current_cr3_fast at
 kvm/queue
Message-ID: <YbOVBDCcpuwtXD/7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While testing some patches I ran into a VM_BUG_ON that I have been able to
reproduce at kvm/queue commit 45af1bb99b72 ("KVM: VMX: Clean up PI
pre/post-block WARNs").

To repro run the kvm-unit-tests on a kernel built from kvm/queue with
CONFIG_DEBUG_VM=y. I was testing on an Intel Cascade Lake host and have not
tested in any other environments yet. The repro is not 100% reliable, although
it's fairly easy to trigger and always during a vmx* kvm-unit-tests

Given the details of the crash, commit 15ad9762d69f ("KVM: VMX: Save HOST_CR3
in vmx_prepare_switch_to_guest()") and surrounding commits look most suspect.

The splat:

[  698.724442] ------------[ cut here ]------------
[  698.729095] kernel BUG at arch/x86/mm/tlb.c:1082!
[  698.733838] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[  698.740475] CPU: 29 PID: 63256 Comm: qemu-kvm-system Tainted: G S         O      5.16.0-dbg-DEV #1
[  698.756882] RIP: 0010:__get_current_cr3_fast+0xe6/0x110
[  698.762134] Code: 3b 4d f8 75 27 48 83 c4 10 5d c3 0f 0b eb df 0f 0b eb 98 0f 0b eb a2 66 85 c9 75 15 48 39 d0 76 17 48 8b 0d dc a7 b9 01 eb 1c <0f> 0b e8 23 8c ba 00 0f 0b 48 39 d0 77 e9 48 c7 c1 00 00 00 80 48
[  698.780967] RSP: 0018:ffffc90039c6fa50 EFLAGS: 00010297
[  698.786209] RAX: 00000060674f2005 RBX: ffff88e0911d5380 RCX: 00000060674f2006
[  698.793366] RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffff88e0985eec18
[  698.800524] RBP: ffffc90039c6fa60 R08: ffff893e5bf40000 R09: 0000000000000000
[  698.807682] R10: 00000000000206dd R11: 0000000000000000 R12: ffff88e0985ec8c0
[  698.814838] R13: 0000000000000000 R14: ffff88e0985eec18 R15: ffff893e5bf40000
[  698.821997] FS:  00007f5b823ff700(0000) GS:ffff893e5bf40000(0000) knlGS:0000000000000000
[  698.830114] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  698.835877] CR2: 0000000000000000 CR3: 00000060674f2006 CR4: 00000000003726e0
[  698.843034] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  698.850192] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  698.857349] Call Trace:
[  698.859801]  <TASK>
[  698.861907]  vmx_prepare_switch_to_guest+0x11f/0x290 [kvm_intel]
[  698.867945]  vcpu_enter_guest+0x128b/0x24b0 [kvm]
[  698.872719]  ? __this_cpu_preempt_check+0x13/0x20
[  698.877446]  ? lock_is_held_type+0xff/0x170
[  698.881646]  ? __this_cpu_preempt_check+0x13/0x20
[  698.886371]  ? lock_is_held_type+0xff/0x170
[  698.890568]  ? __lock_acquire+0x91e/0xf00
[  698.894599]  ? __lock_acquire+0x91e/0xf00
[  698.898622]  ? __this_cpu_preempt_check+0x13/0x20
[  698.903348]  ? lock_acquire+0xda/0x210
[  698.907111]  ? trace_kvm_pio+0x2c/0xd0 [kvm]
[  698.911422]  vcpu_run+0x90/0x370 [kvm]
[  698.915211]  kvm_arch_vcpu_ioctl_run+0x173/0x330 [kvm]
[  698.920394]  kvm_vcpu_ioctl+0x5e3/0x6b0 [kvm]
[  698.924792]  ? rcu_lock_release+0x10/0x20
[  698.928824]  ? __fget_files+0x1bb/0x1d0
[  698.932672]  __se_sys_ioctl+0x77/0xc0
[  698.936355]  __x64_sys_ioctl+0x1d/0x20
[  698.940116]  do_syscall_64+0x44/0xa0
[  698.943702]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  698.948769] RIP: 0033:0x7f5b8b60b947
[  698.952355] Code: 73 01 c3 48 8b 0d 31 f5 16 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 01 f5 16 00 f7 d8 64 89 01 48
[  698.971187] RSP: 002b:00007f5b823fe4d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  698.978780] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f5b8b60b947
[  698.985937] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000e
[  698.993093] RBP: 00007f5b823fe5c0 R08: 0000000000000400 R09: 00000000000000ff
[  699.000251] R10: 0000550e7e92ed00 R11: 0000000000000246 R12: 00007f5b8a4a6000
[  699.007410] R13: 0000550e7f95c000 R14: 0000000000000000 R15: 0000550e7f95c000
[  699.014571]  </TASK>
[  699.034357] ---[ end trace ee35b3363814d971 ]---

... which is the following VM_BUG_ON:

  1074 unsigned long __get_current_cr3_fast(void)
  1075 {
  1076          unsigned long cr3 = build_cr3(this_cpu_read(cpu_tlbstate.loaded_mm)->pgd,
  1077                 this_cpu_read(cpu_tlbstate.loaded_mm_asid));
  1078
  1079         /* For now, be very restrictive about when this can be called. */
  1080         VM_WARN_ON(in_nmi() || preemptible());
  1081
  1082         VM_BUG_ON(cr3 != __read_cr3());  <------------
  1083         return cr3;
  1084 }
