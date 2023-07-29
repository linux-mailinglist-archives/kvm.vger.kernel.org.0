Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9D0767BEC
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 05:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbjG2DdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 23:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236496AbjG2DdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 23:33:05 -0400
X-Greylist: delayed 723 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 28 Jul 2023 20:33:02 PDT
Received: from ustc.edu.cn (email.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B92C5106
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 20:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Message-ID:Date:
        MIME-Version:User-Agent:From:To:Cc:Subject:Content-Type:
        Content-Transfer-Encoding; bh=zgkAdu+bRUAzX1goJastFrFu1/KsEZ+L3N
        tJb7mZ3+8=; b=lTKJNTAPtgpqnFHFQKNforLCcm7cYgcy+zeeB9hsHHMQWwCzFJ
        PehIw216PCxch7xyHTbE0jFxes1sFVSBiDEpn0j3IrU0D1VfUKnxlAbvvLn99o/4
        ITRV1uJV7LsM/kPSSb0wGihLI0/117fD60RKSH+gCsT+8wtROBvRxZaDA=
Received: from [192.168.199.152] (unknown [180.158.176.68])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygC3vAw3hMRkVCzAAA--.25069S2;
        Sat, 29 Jul 2023 11:15:03 +0800 (CST)
Message-ID: <8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn>
Date:   Sat, 29 Jul 2023 11:15:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From:   wuzongyong <wuzongyo@mail.ustc.edu.cn>
To:     linux-kernel@vger.kernel.org, thomas.lendacky@amd.com,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     linux-coco@lists.linux.dev
Subject: [Question] int3 instruction generates a #UD in SEV VM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygC3vAw3hMRkVCzAAA--.25069S2
X-Coremail-Antispam: 1UD129KBjvJXoW3GF4xWw43WryfCF4xJF48Crg_yoW3JF1fpr
        4rAw43GFW8Gw18ArWUWF1UtryUtF1UAa1DJr1UAF1UJFyUWw1qqr1Uur429FnrJr4fZFy3
        t34Dta12vry7CaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyIb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
        C2z280aVCY1x0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCF04k20xvY0x0EwIxGrwCFx2Iq
        xVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r
        106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AK
        xVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7
        xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWU
        JVW8JbIYCTnIWIevJa73UjIFyTuYvjxUgg_TUUUUU
X-CM-SenderInfo: pzx200xj1rqzxdloh3xvwfhvlgxou0/
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
I am writing a firmware in Rust to support SEV based on project td-shim[1].
But when I create a SEV VM (just SEV, no SEV-ES and no SEV-SNP) with the firmware,
the linux kernel crashed because the int3 instruction in int3_selftest() cause a
#UD.
The stack is as follows:
    [    0.141804] invalid opcode: 0000 [#1] PREEMPT SMP^M
    [    0.141804] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.3.0+ #37^M
    [    0.141804] RIP: 0010:int3_selftest_ip+0x0/0x2a^M
    [    0.141804] Code: eb bc 66 90 0f 1f 44 00 00 48 83 ec 08 48 c7 c7 90 0d 78 83
c7 44 24 04 00 00 00 00 e8 23 fe ac fd 85 c0 75 22 48 8d 7c 24 04 <cc>
90 90 90 90 83 7c 24 04 01 75 13 48 c7 c7 90 0d 78 83 e8 42 fc^M
    [    0.141804] RSP: 0000:ffffffff82803f18 EFLAGS: 00010246^M
    [    0.141804] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000007ffffffe^M
    [    0.141804] RDX: ffffffff82fd4938 RSI: 0000000000000296 RDI: ffffffff82803f1c^M
    [    0.141804] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000fffeffff^M
    [    0.141804] R10: ffffffff82803e08 R11: ffffffff82f615a8 R12: 00000000ff062350^M
    [    0.141804] R13: 000000001fddc20a R14: 000000000090122c R15: 0000000002000000^M
    [    0.141804] FS:  0000000000000000(0000) GS:ffff88801f200000(0000) knlGS:0000000000000000^M
    [    0.141804] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M
    [    0.141804] CR2: ffff888004c00000 CR3: 000800000281f000 CR4: 00000000003506f0^M
    [    0.141804] Call Trace:^M
    [    0.141804]  <TASK>^M
    [    0.141804]  alternative_instructions+0xe/0x100^M
    [    0.141804]  check_bugs+0xa7/0x110^M
    [    0.141804]  start_kernel+0x320/0x430^M
    [    0.141804]  secondary_startup_64_no_verify+0xd3/0xdb^M
    [    0.141804]  </TASK>^M
    [    0.141804] Modules linked in:^M
    [    0.141804] ---[ end trace 0000000000000000 ]--

Then I tried to figure out the problem and do some test with qemu & OVMF in SEV.
But the behaviour is also weird when I create SEV VM with qemu & OVMF.

I found the int3 instruction always generated a #UD if I put a int3 instruction before
gen_pool_create() in mce_gen_pool_create(). But if I put the int3 instruction after the
gen_pool_create() in mce_gen_pool_create(), the int3 instruction generated a #BP rightly.

    // linux/arch/x86/kernel/cpu/mce/genpool.c
    static int mce_gen_pool_create(void)
    {
        struct gen_pool *tmpp;
        int ret = -ENOMEM;
   
        asm volatile ("int3\n\t"); // generated a # UD
        tmpp = gen_pool_create(ilog2(sizeof(struct mce_evt_list)), -1);
        asm volatile ("int3\n\t"); // generated a #BP
        ...
    }

The stack is as follows when I put the int3 instruction before gen_pool_create().

    [    0.094846] invalid opcode: 0000 [#1] PREEMPT SMP^M
    [    0.094994] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.3.0+ #101^M
    [    0.094994] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 2/2/2022^M
    [    0.094994] RIP: 0010:mcheck_cpu_init+0x4e/0x150^M
    [    0.094994] Code: 84 c0 0f 89 97 00 00 00 48 8b 45 28 f6 c4 40 0f 84 8a 00 00 00 e8 c2
e6 ff ff 48 89 ef e8 8a e2 ff ff 85 c0 0f 88 94 00 00 00 <cc> e8 dc 05 00 00 85 c0 75 76
80 0d a1 90 0a 02 20 0f b6 45 01 3c^M
    [    0.094994] RSP: 0000:ffffffff92803ef8 EFLAGS: 00010246^M
    [    0.094994] RAX: 0000000000000000 RBX: 0000000000000058 RCX: 00000000ffffffff^M
    [    0.094994] RDX: 0000000000000002 RSI: 00000000000000ff RDI: ffffffff930ed860^M
    [    0.094994] RBP: ffffffff930ed860 R08: 0000000000000000 R09: 0000000000000000^M
    [    0.094994] R10: 0000000000000000 R11: 0000000000000254 R12: 0000000000000207^M
    [    0.094994] R13: 000000001f9ec018 R14: 000000001fe85928 R15: 0000000000000001^M
    [    0.094994] FS:  0000000000000000(0000) GS:ffff8ae0dca00000(0000) knlGS:0000000000000000^M
    [    0.094994] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M
    [    0.094994] CR2: ffff8ae0dac01000 CR3: 000800001881f000 CR4: 00000000003506f0^M
    [    0.094994] Call Trace:^M
    [    0.094994]  <TASK>^M
    [    0.094994]  identify_cpu+0x2cb/0x500^M
    [    0.094994]  identify_boot_cpu+0x10/0xb0^M
    [    0.094994]  check_bugs+0xf/0x110^M
    [    0.094994]  start_kernel+0x320/0x430^M
    [    0.094994]  secondary_startup_64_no_verify+0xd3/0xdb^M
    [    0.094994]  </TASK>^M
    [    0.094994] Modules linked in:^M
    [    0.094995] ---[ end trace 0000000000000000 ]---^

The stack is as follows when I put the int3 instruction after gen_pool_create().
    [    0.095585] int3: 0000 [#1] PREEMPT SMP^M
    [    0.095590] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.3.0+ #101^M
    [    0.095593] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 2/2/2022^M
    [    0.095594] RIP: 0010:mcheck_cpu_init+0x4f/0x150^M
    [    0.095597] Code: c0 0f 89 97 00 00 00 48 8b 45 28 f6 c4 40 0f 84 8a 00 00 00 e8 c2 e6
ff ff 48 89 ef e8 8a e2 ff ff 85 c0 0f 88 94 00 00 00 cc <e8> dc 05 00 00 85 c0 75 76 80 
0d a1 90 0a 02 20 0f b6 45 01 3c 02^M
    [    0.095598] RSP: 0000:ffffffff86803ef8 EFLAGS: 00000246^M
    [    0.095599] RAX: 0000000000000000 RBX: 0000000000000058 RCX: 00000000ffffffff^M
    [    0.095600] RDX: 0000000000000002 RSI: 00000000000000ff RDI: ffffffff870ed860^M
    [    0.095601] RBP: ffffffff870ed860 R08: 0000000000000000 R09: 0000000000000000^M
    [    0.095601] R10: 0000000000000000 R11: 0000000000000254 R12: 0000000000000207^M
    [    0.095602] R13: 000000001f9ec018 R14: 000000001fe85928 R15: 0000000000000001^M
    [    0.095604] FS:  0000000000000000(0000) GS:ffff901e5ca00000(0000) knlGS:0000000000000000^M
    [    0.095605] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M
    [    0.095606] CR2: ffff901e5ac01000 CR3: 000800001881f000 CR4: 00000000003506f0^M
    [    0.095606] Call Trace:^M
    [    0.095611]  <TASK>^M
    [    0.095612]  identify_cpu+0x2cb/0x500^M
    [    0.095615]  identify_boot_cpu+0x10/0xb0^M
    [    0.095618]  check_bugs+0xf/0x110^M
    [    0.095620]  start_kernel+0x320/0x430^M
    [    0.095622]  secondary_startup_64_no_verify+0xd3/0xdb^M
    [    0.095625]  </TASK>^M
    [    0.095625] Modules linked in:^M
    [    0.096577] ---[ end trace 0000000000000000 ]---^
BTW, if a create a normal VM without SEV by qemu & OVMF, the int3 instruction always generates a
#BP.
So I am confused now about the behaviour of int3 instruction, could anyone help to explain the behaviour?
Any suggestion is appreciated!

[1] https://github.com/confidential-containers/td-shim

Thanks,
Wu Zongyo

