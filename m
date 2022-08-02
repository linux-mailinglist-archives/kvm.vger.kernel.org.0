Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B315884A4
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 01:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbiHBXHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 19:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiHBXHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 19:07:23 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E53633E23
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 16:07:22 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id f13-20020a170902ce8d00b0016eebfe70fcso3955826plg.7
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 16:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to:from:to:cc;
        bh=fFphbo8KZzGdlj3Rs1F3qGjBl4/p8Fpo/C7D4jcBsTg=;
        b=CAhkAPcVrLVja80fBodsgJg+xcMo1udDW0lDFK0mtx8yqo/P8lqLdB6PS9kP6NnemU
         pLuAANHB+/jmTwBRiBWRbwqw10aDGn8J6mXWSbwGDWpbdDcVKQ4VMkJuej+0wrPkg3yx
         ZY8uO7+Y0HcO/0V/QBUgQx3OEq5AaM7el3hn7ukj6lxbG9m4O4f1o7JNxCG1iF2bY/kK
         P0apYkw79NwbobSEzAuj81zH9BhCay1pjXA3KC+1tbKO4dffTqP2cWxE8oMLXxkRjRrt
         NoYwPiE5KW5Z8a8qiUWmMPDt6Xa/J7SMnjI4zEPPeaNqVkgpblwta4Nxjj2epmZEUTWw
         jBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=fFphbo8KZzGdlj3Rs1F3qGjBl4/p8Fpo/C7D4jcBsTg=;
        b=gNXRPedv/zVXxRQ5vFzfuKa6c1HKeDn4yVuX2kH2Z8fOerdiVPv0tDQwecOdXwpMgy
         XonqcBmjhPLg8F84VoZ/mOceckTA6JMedsFh8+3JIkS3VAUWypaCCJ2xGWJt9trSnWaL
         N0ftD/YgZe9V/kkv5VZIa8Cukt8HkMvxdCKjNuc72uZdN5h63L/D0s6IpMAwCsu1sd34
         ehKxIRkHOVGZ76RpGM+fNkoDVwx1+YHZZpFcsu1vQOl6toT3uJR0/BEp0k9EJlGyRhZW
         wOe2JWXdohlgJlEfwOD5gpZqG/f9uxke/32N0eDij2xWMlJYEwt8q5zPO+CNrxQ5N/Yi
         3hPg==
X-Gm-Message-State: ACgBeo3jfV/+2cvW5I5ttuAHpdvD7X+4r+3C+17iJ7UhQ0gmEHzdAaNc
        KFE3unYDGCS/FyJ29X+TG3ORcfD6moaa
X-Google-Smtp-Source: AA6agR6cPCxGVY14jLflVvKxQG4qcDiEul+hYeBodKwrBMtckMmV3O0nswQk557OSQWQNIU1ZSDPI6J0LN4s
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr162519pje.0.1659481641637; Tue, 02 Aug
 2022 16:07:21 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue,  2 Aug 2022 23:07:13 +0000
Message-Id: <20220802230718.1891356-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH 0/5] Fix a race between posted interrupt delivery and
 migration in a nested VM
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set aims to fix a race condition between posted interrupt
delivery and migration for a nested VM. In particular, we proves that when
a nested vCPU is halted and just migrated, it will lose a posted
interrupt from another vCPU in the same VM.

The patches consist of 1 kernel change which is the fix and the rest of
the changes generate a selftest that articulates such a racing scenario
to prove the existence of the race. In summary, running this test on an
unpatched kernel will generate a warning [1] and with that, we proves that
there is the loss of a posted interrupt. Note, the warning will only happen
once per reboot, since it is a WARN_ON_ONCE.

[1] The kernel warning happens at arch/x86/kvm/vmx/vmx.c:

static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
{
	...
	if (WARN_ON_ONCE(!is_guest_mode(vcpu)) ||
		!nested_cpu_has_vid(get_vmcs12(vcpu)) ||
		WARN_ON_ONCE(!vmx->nested.virtual_apic_map.gfn)) <= HERE
		return false;
	...
}

The dump is there:

[237880.809453] ------------[ cut here ]------------
[237880.809455] WARNING: CPU: 21 PID: 112454 at
arch/x86/kvm/vmx/vmx.c:3973 vmx_guest_apic_has_interrupt+0x79/0xe0
[kvm_intel]
[237880.809469] Modules linked in: kvm_intel vfat fat i2c_mux_pca954x
i2c_mux spidev cdc_acm xhci_pci xhci_hcd sha3_generic gq(O)
[237880.809479] CPU: 21 PID: 112454 Comm: vmx_migrate_pi_ Tainted: G S
O      5.19.0-smp-DEV #2
		......
[237880.809484] RIP: 0010:vmx_guest_apic_has_interrupt+0x79/0xe0
[kvm_intel]
[237880.809491] Code: c6 76 2d 41 81 e6 f0 00 00 00 48 8b 83 68 25 00 00
b9 f0 00 00 00 23 88 a0 00 00 00 44 39 f1 0f 92 c0 eb c0 0f 0b 31 c0 eb
ba <0f> 0b 31 c0 eb b4 80 3d 41 c9 02 00 00 74 39 48 c7 c7 18 f3 12 c0
[237880.809493] RSP: 0018:ffff88815c9e7d80 EFLAGS: 00010246
[237880.809495] RAX: ffff88813acbd000 RBX: ffff8881943ec9c0 RCX:
00000000ffffffff
[237880.809497] RDX: 0000000000000000 RSI: ffff8881d8676000 RDI:
ffff8881943ec9c0
[237880.809499] RBP: ffff88815c9e7d90 R08: ffff88815c9e7ce8 R09:
ffff88815c9e7cf0
[237880.809500] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000009aa8
[237880.809501] R13: ffff8881943ec9c0 R14: ffff8881943ed101 R15:
ffff8881943ec9c0
[237880.809503] FS:  00000000006283c0(0000) GS:ffff88af80740000(0000)
knlGS:0000000000000000
[237880.809505] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[237880.809506] CR2: 00007f9314b4f001 CR3: 00000001cd7b0005 CR4:
00000000003726e0
[237880.809508] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[237880.809509] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[237880.809511] Call Trace:
[237880.809512]  <TASK>
[237880.809514]  kvm_vcpu_has_events+0xe1/0x150
[237880.809519]  vcpu_run+0xee/0x2c0
[237880.809523]  kvm_arch_vcpu_ioctl_run+0x355/0x610
[237880.809526]  kvm_vcpu_ioctl+0x551/0x610
[237880.809531]  ? do_futex+0xc8/0x160
[237880.809537]  __se_sys_ioctl+0x77/0xc0
[237880.809541]  __x64_sys_ioctl+0x1d/0x20
[237880.809543]  do_syscall_64+0x44/0xa0
[237880.809549]  ? irqentry_exit+0x12/0x30
[237880.809552]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[237880.809555] RIP: 0033:0x471777
...
[237880.809570]  </TASK>
[237880.809571] ---[ end trace 0000000000000000 ]---



Jim Mattson (1):
  selftests: KVM: Test if posted interrupt delivery race with migration

Mingwei Zhang (3):
  selftests: KVM/x86: Add APIC state into kvm_x86_state
  selftests: KVM: Introduce vcpu_run_interruptable()
  selftests: KVM: Add support for posted interrupt handling in L2

Oliver Upton (1):
  kvm: x86: get vmcs12 pages before checking pending interrupts

 arch/x86/kvm/x86.c                            |  17 ++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |  12 +
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/include/x86_64/vmx.h        |  10 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  11 +
 .../selftests/kvm/lib/x86_64/processor.c      |   2 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  16 +
 .../kvm/x86_64/vmx_migrate_pi_pending.c       | 289 ++++++++++++++++++
 10 files changed, 360 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_migrate_pi_pending.c

-- 
2.37.1.455.g008518b4e5-goog

