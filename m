Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEB251929C
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 02:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244527AbiEDAP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 20:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244514AbiEDAP6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 20:15:58 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA9B10FF8
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 17:12:23 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h9-20020a631209000000b0039cc31b22aeso9142720pgl.9
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 17:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=Thdv07o77AyCQR2v+zg5M0kWZciZMbIvPbKlk2mT+Pg=;
        b=aUhtXr5iHqZDJQ3dP7V3pR69p5L2aIpiZK3iLzox1OsFiJ6pnBEij2AfmoWVxNdX8b
         cYe9WhRwtn7TKjyASaz6Br1IyvLQLj0dcncpHug7Du30glSXEeuY03pcepA+3vN+JZcb
         Ax1A7fXudNCtFUheSnLKOlXFy8KVcTr4YAfGQhqJLF8N5gvKjpuB+Q6KIINTCZ7Xsvo4
         et4Sw29rGSz3Ikn5VzbxJL2qIl+jIsnE6qQzMuHsR6KLFferWFZIKu0UHhxZNc+PbiWC
         gT6218lm/GoPL7Anbe0K6ScmuZHhgTfhvKGuQjsMgt4bdgviiWXUHUdmfg9dqTxOEXeF
         /u+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=Thdv07o77AyCQR2v+zg5M0kWZciZMbIvPbKlk2mT+Pg=;
        b=x22CgejtKW4BmBtm1kvTcOaBSLCsHOVjeSjlIR7CefuC+BIzb34WDi9ddw+4H5sOM3
         i519InL88UbnZyvqMaonC78hH/DAI/hABlNAPpeoDUQEIUanqhEwC6Qdxt+7fT9/iw45
         GLBG+xQVEUijYWYFIT06dVahtO4QgF/2IPqepTYu7eMNJB8yZf0RTZJIqQQzYvjpU7S1
         ll+caVK2MsU8tq6fpdxGg+dpbX0ec1o7uonfePU/tNJgmpLEaYVygsV7YVA5AOmuACBH
         f1sIdAk90AzwFYmQakFDK7hhX4wTgQG549VRuEfB007hSLaK73g/gKp1hbL0291tExLM
         7v6w==
X-Gm-Message-State: AOAM533EuwlPed0Hg+1uWwLJ8nUynAp+G2710dD8tDBegykAegKnlOoC
        6INlHNErHGdIeGayuijJlfIju8U5VsQ=
X-Google-Smtp-Source: ABdhPJyFUyzOUPUqceH9/VHV4kcN1GZrV4bcWzszOTXSgWwJQrayXaApWuomlaJD9MyKXDcXRf64WbGjdKM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:164c:b0:50a:472a:6b0a with SMTP id
 m12-20020a056a00164c00b0050a472a6b0amr18559030pfc.77.1651623143199; Tue, 03
 May 2022 17:12:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 00:12:19 +0000
Message-Id: <20220504001219.983513-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH] x86/fpu: KVM: Set the base guest FPU uABI size to
 sizeof(struct kvm_xsave)
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Zdenek Kaspar <zkaspar82@gmail.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the starting uABI size of KVM's guest FPU to 'struct kvm_xsave',
i.e. to KVM's historical uABI size.  When saving FPU state for usersapce,
KVM (well, now the FPU) sets the FP+SSE bits in the XSAVE header even if
the host doesn't support XSAVE.  Setting the XSAVE header allows the VM
to be migrated to a host that does support XSAVE without the new host
having to handle FPU state that may or may not be compatible with XSAVE.

Setting the uABI size to the host's default size results in out-of-bounds
writes (setting the FP+SSE bits) and data corruption (that is thankfully
caught by KASAN) when running on hosts without XSAVE, e.g. on Core2 CPUs.

WARN if the default size is larger than KVM's historical uABI size; all
features that can push the FPU size beyond the historical size must be
opt-in.

  ==================================================================
  BUG: KASAN: slab-out-of-bounds in fpu_copy_uabi_to_guest_fpstate+0x86/0x130
  Read of size 8 at addr ffff888011e33a00 by task qemu-build/681
  CPU: 1 PID: 681 Comm: qemu-build Not tainted 5.18.0-rc5-KASAN-amd64 #1
  Hardware name:  /DG35EC, BIOS ECG3510M.86A.0118.2010.0113.1426 01/13/2010
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x45
   print_report.cold+0x45/0x575
   kasan_report+0x9b/0xd0
   fpu_copy_uabi_to_guest_fpstate+0x86/0x130
   kvm_arch_vcpu_ioctl+0x72a/0x1c50 [kvm]
   kvm_vcpu_ioctl+0x47f/0x7b0 [kvm]
   __x64_sys_ioctl+0x5de/0xc90
   do_syscall_64+0x31/0x50
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>
  Allocated by task 0:
  (stack is not available)
  The buggy address belongs to the object at ffff888011e33800
   which belongs to the cache kmalloc-512 of size 512
  The buggy address is located 0 bytes to the right of
   512-byte region [ffff888011e33800, ffff888011e33a00)
  The buggy address belongs to the physical page:
  page:0000000089cd4adb refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11e30
  head:0000000089cd4adb order:2 compound_mapcount:0 compound_pincount:0
  flags: 0x4000000000010200(slab|head|zone=1)
  raw: 4000000000010200 dead000000000100 dead000000000122 ffff888001041c80
  raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
  page dumped because: kasan: bad access detected
  Memory state around the buggy address:
   ffff888011e33900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   ffff888011e33980: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  >ffff888011e33a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                     ^
   ffff888011e33a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   ffff888011e33b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ==================================================================
  Disabling lock debugging due to kernel taint

Fixes: be50b2065dfa ("kvm: x86: Add support for getting/setting expanded xstate buffer")
Fixes: c60427dd50ba ("x86/fpu: Add uabi_size to guest_fpu")
Reported-by: Zdenek Kaspar <zkaspar82@gmail.com>
Cc: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/fpu/core.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index c049561f373a..99caae7e8b01 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -14,6 +14,8 @@
 #include <asm/traps.h>
 #include <asm/irq_regs.h>
 
+#include <uapi/asm/kvm.h>
+
 #include <linux/hardirq.h>
 #include <linux/pkeys.h>
 #include <linux/vmalloc.h>
@@ -247,7 +249,20 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	gfpu->fpstate		= fpstate;
 	gfpu->xfeatures		= fpu_user_cfg.default_features;
 	gfpu->perm		= fpu_user_cfg.default_features;
-	gfpu->uabi_size		= fpu_user_cfg.default_size;
+
+	/*
+	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
+	 * to userspace, even when XSAVE is unsupported, so that restoring FPU
+	 * state on a different CPU that does support XSAVE can cleanly load
+	 * the incoming state using its natural XSAVE.  In other words, KVM's
+	 * uABI size may be larger than this host's default size.  Conversely,
+	 * the default size should never be larger than KVM's base uABI size;
+	 * all features that can expand the uABI size must be opt-in.
+	 */
+	gfpu->uabi_size		= sizeof(struct kvm_xsave);
+	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
+		gfpu->uabi_size = fpu_user_cfg.default_size;
+
 	fpu_init_guest_permissions(gfpu);
 
 	return true;

base-commit: b91c0922bf1ed15b67a6faa404bc64e3ed532ec2
-- 
2.36.0.464.gb9c8b46e94-goog

