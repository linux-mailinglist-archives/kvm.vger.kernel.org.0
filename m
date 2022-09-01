Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAA55A8DFD
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 08:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiIAGJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 02:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiIAGJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 02:09:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B15114C61
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 23:09:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 280C9B82452
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 06:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BEE35C433B5
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 06:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662012557;
        bh=sOkvXxIJDLxTmvY+9W0iD6vd1xlFJXX1pZYU6n4nr5s=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=lOsmNXpqgt5OzzI6Icoo4oxpNkCIqolBQqHVrVeOYJyrS8FlQGfYcDWO0XCyf2caP
         9SJHW93/JLoZw2Y5lch3JCgelXWZr030+gVRTtKmCJuvY3263R4oipQL2hfxumiFAQ
         9wKyk3tf64idhTo5SVwk716XPkdOxg5/IzGbMJCbVJeQ4RgXoCa9vkfyjzoLpAw31c
         9FEPEfSxd6ELmk7vHGPWPQvMEE0Xzh3Ah8DU7MDeEcZHuWqi2EeO+NgJaxoe2TlD0m
         itB3vcZcNgj4hJn6tXPYgckT0FB9+IU8qGrFU+GMGgNThmA0Pmu3/mnhhRth0zGCyt
         o2kZUMKFD2C1Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id AB68AC433E6; Thu,  1 Sep 2022 06:09:17 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Thu, 01 Sep 2022 06:09:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216388-28872-L9iQIQTrXh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216388-28872@https.bugzilla.kernel.org/>
References: <bug-216388-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216388

--- Comment #6 from Robert Dinse (nanook@eskimo.com) ---
Installed 5.19.6 on a couple of machines today, still getting CPU stalls bu=
t in
random locations:

[    6.601788] rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks=
: {
4-... } 3 jiffies s: 53 root: 0x10/.=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
[    6.601802] rcu: blocking rcu_node structures (internal RCU debug):=20=
=20=20=20=20=20=20=20=20=20
[    6.601806] Task dump for CPU 4:=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
[    6.601808] task:systemd-udevd   state:R  running task     stack:    0 p=
id:=20
468 ppid:   454 flags:0x0000400a=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20
[    6.604313] Call Trace:=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604324]  <TASK>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604326]  ? cpumask_any_but+0x35/0x50=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
[    6.604336]  ? x2apic_send_IPI_allbutself+0x2f/0x40=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604339]  ? do_sync_core+0x2a/0x30=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
[    6.604342]  ? cpumask_next+0x23/0x30=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
[    6.604344]  ? smp_call_function_many_cond+0xea/0x370=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604347]  ? text_poke_memset+0x20/0x20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
[    6.604350]  ? arch_unregister_cpu+0x50/0x50=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604352]  ? on_each_cpu_cond_mask+0x1d/0x30=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604354]  ? text_poke_bp_batch+0x1fb/0x210=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604358]  ? enter_smm.constprop.0+0x51a/0xa70 [kvm]=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604414]  ? vmx_set_cr0+0x16f0/0x16f0 [kvm_intel]=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604457]  ? enter_smm.constprop.0+0x519/0xa70 [kvm]=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604501]  ? text_poke_bp+0x49/0x70=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
[    6.604504]  ? __static_call_transform+0x7f/0x120=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604506]  ? arch_static_call_transform+0x87/0xa0=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604508]  ? enter_smm.constprop.0+0x519/0xa70 [kvm]=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604552]  ? __static_call_update+0x16e/0x220=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604554]  ? vmx_set_cr0+0x16f0/0x16f0 [kvm_intel]=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604567]  ? kvm_arch_hardware_setup+0x35a/0x17f0 [kvm]=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604611]  ? __kmalloc_node+0x16c/0x380=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
[    6.604615]  ? kvm_init+0xa2/0x400 [kvm]=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
[    6.604654]  ? hardware_setup+0x7e2/0x8cc [kvm_intel]=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604666]  ? vmx_init+0xf9/0x201 [kvm_intel]=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604676]  ? hardware_setup+0x8cc/0x8cc [kvm_intel]=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604685]  ? do_one_initcall+0x47/0x1e0=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
[    6.604689]  ? kmem_cache_alloc_trace+0x16c/0x2b0=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604692]  ? do_init_module+0x50/0x1f0=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
[    6.604694]  ? load_module+0x21bd/0x25e0=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
[    6.604696]  ? ima_post_read_file+0xd5/0x100=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604700]  ? kernel_read_file+0x23d/0x2e0=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604703]  ? __do_sys_finit_module+0xbd/0x130=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604705]  ? __do_sys_finit_module+0xbd/0x130=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604708]  ? __x64_sys_finit_module+0x18/0x20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604710]  ? do_syscall_64+0x58/0x80=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20
[    6.604713]  ? syscall_exit_to_user_mode+0x1b/0x40=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604715]  ? do_syscall_64+0x67/0x80=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20
[    6.604718]  ? switch_fpu_return+0x4e/0xc0=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604720]  ? exit_to_user_mode_prepare+0x184/0x1e0=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604723]  ? syscall_exit_to_user_mode+0x1b/0x40=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604725]  ? do_syscall_64+0x67/0x80=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20
[    6.604728]  ? do_syscall_64+0x67/0x80=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20
[    6.604730]  ? do_syscall_64+0x67/0x80=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20
[    6.604732]  ? sysvec_call_function+0x4b/0xa0=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604735]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.604739]  </TASK>=20=20=20=20=20
[    6.697044] rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks=
: {
4-... } 13 jiffies s: 53 root: 0x10/.=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
[    6.697051] rcu: blocking rcu_node structures (internal RCU debug):=20=
=20=20=20=20=20=20=20=20=20
[    6.697052] Task dump for CPU 4:=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
[    6.697053] task:systemd-udevd   state:R  running task     stack:    0 p=
id:=20
468 ppid:   454 flags:0x0000400a=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20
[    6.697057] Call Trace:=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697058]  <TASK>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697059]  ? cpumask_any_but+0x35/0x50=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
[    6.697065]  ? x2apic_send_IPI_allbutself+0x2f/0x40=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697068]  ? do_sync_core+0x2a/0x30=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
[    6.697071]  ? cpumask_next+0x23/0x30=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
[    6.697072]  ? smp_call_function_many_cond+0xea/0x370=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697075]  ? text_poke_memset+0x20/0x20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
[    6.697077]  ? arch_unregister_cpu+0x50/0x50=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697080]  ? on_each_cpu_cond_mask+0x1d/0x30=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697081]  ? text_poke_bp_batch+0x1fb/0x210=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697084]  ? kvm_set_msr_common+0x939/0x1060 [kvm]=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697133]  ? vmx_set_efer.part.0+0x160/0x160 [kvm_intel]=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697147]  ? kvm_set_msr_common+0x938/0x1060 [kvm]=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697187]  ? text_poke_bp+0x49/0x70=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
[    6.697189]  ? __static_call_transform+0x7f/0x120=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697191]  ? arch_static_call_transform+0x87/0xa0=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697193]  ? kvm_set_msr_common+0x938/0x1060 [kvm]=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697234]  ? __static_call_update+0x16e/0x220=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697236]  ? vmx_set_efer.part.0+0x160/0x160 [kvm_intel]=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697246]  ? kvm_arch_hardware_setup+0x423/0x17f0 [kvm]=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697286]  ? __kmalloc_node+0x16c/0x380=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
[    6.697290]  ? kvm_init+0xa2/0x400 [kvm]=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
[    6.697326]  ? hardware_setup+0x7e2/0x8cc [kvm_intel]=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697336]  ? vmx_init+0xf9/0x201 [kvm_intel]=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697345]  ? hardware_setup+0x8cc/0x8cc [kvm_intel]=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697353]  ? do_one_initcall+0x47/0x1e0=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
[    6.697356]  ? kmem_cache_alloc_trace+0x16c/0x2b0=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697359]  ? do_init_module+0x50/0x1f0=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
[    6.697360]  ? load_module+0x21bd/0x25e0=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
[    6.697362]  ? ima_post_read_file+0xd5/0x100=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697365]  ? kernel_read_file+0x23d/0x2e0=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697368]  ? __do_sys_finit_module+0xbd/0x130=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697370]  ? __do_sys_finit_module+0xbd/0x130=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697372]  ? __x64_sys_finit_module+0x18/0x20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[    6.697373]  ? do_syscall_64+0x58/0x80=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20
[    6.697376]  ? syscall_exit_to_user_mode+0x1b/0x40
[    6.697377]  ? do_syscall_64+0x67/0x80
[    6.697379]  ? switch_fpu_return+0x4e/0xc0
[    6.697382]  ? exit_to_user_mode_prepare+0x184/0x1e0
[    6.697384]  ? syscall_exit_to_user_mode+0x1b/0x40
[    6.697386]  ? do_syscall_64+0x67/0x80
[    6.697387]  ? do_syscall_64+0x67/0x80
[    6.697389]  ? do_syscall_64+0x67/0x80
[    6.697391]  ? sysvec_call_function+0x4b/0xa0
[    6.697393]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[    6.697397]  </TASK>

[    6.798781] rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks=
: {
4-... } 23 jiffies s: 53 root: 0x10/.
[    6.798787] rcu: blocking rcu_node structures (internal RCU debug):
[    6.798833] Task dump for CPU 4:
[    6.798952] task:systemd-udevd   state:R  running task     stack:    0 p=
id:=20
468 ppid:   454 flags:0x0000400a
[    6.798957] Call Trace:
[    6.798959]  <TASK>
[    6.798960]  ? cpumask_any_but+0x35/0x50
[    6.798967]  ? x2apic_send_IPI_allbutself+0x2f/0x40
[    6.798969]  ? do_sync_core+0x2a/0x30
[    6.800010]  ? cpumask_next+0x23/0x30
[    6.800014]  ? smp_call_function_many_cond+0xea/0x370
[    6.800017]  ? text_poke_memset+0x20/0x20
[    6.800019]  ? arch_unregister_cpu+0x50/0x50
[    6.800024]  ? __SCT__kvm_x86_set_rflags+0x8/0x8 [kvm]
[    6.800096]  ? vmx_get_rflags+0x130/0x130 [kvm_intel]
[    6.800109]  ? on_each_cpu_cond_mask+0x1d/0x30
[    6.800110]  ? text_poke_bp_batch+0xaf/0x210
[    6.800113]  ? vmx_get_rflags+0x130/0x130 [kvm_intel]
[    6.800121]  ? __SCT__kvm_x86_set_rflags+0x8/0x8 [kvm]
[    6.800172]  ? vmx_get_rflags+0x130/0x130 [kvm_intel]
[    6.800180]  ? text_poke_bp+0x49/0x70
[    6.800182]  ? __static_call_transform+0x7f/0x120
[    6.800183]  ? arch_static_call_transform+0x58/0xa0
[    6.800185]  ? __SCT__kvm_x86_set_rflags+0x8/0x8 [kvm]
[    6.800233]  ? __static_call_update+0x62/0x220
[    6.800235]  ? vmx_get_rflags+0x130/0x130 [kvm_intel]
[    6.800243]  ? kvm_arch_hardware_setup+0x581/0x17f0 [kvm]
[    6.800284]  ? __kmalloc_node+0x16c/0x380
[    6.800288]  ? kvm_init+0xa2/0x400 [kvm]
[    6.800324]  ? hardware_setup+0x7e2/0x8cc [kvm_intel]
[    6.800334]  ? vmx_init+0xf9/0x201 [kvm_intel]
[    6.800342]  ? hardware_setup+0x8cc/0x8cc [kvm_intel]
[    6.800350]  ? do_one_initcall+0x47/0x1e0
[    6.800352]  ? kmem_cache_alloc_trace+0x16c/0x2b0
[    6.800355]  ? do_init_module+0x50/0x1f0
[    6.800357]  ? load_module+0x21bd/0x25e0
[    6.800358]  ? ima_post_read_file+0xd5/0x100
[    6.800361]  ? kernel_read_file+0x23d/0x2e0
[    6.800364]  ? __do_sys_finit_module+0xbd/0x130
[    6.800365]  ? __do_sys_finit_module+0xbd/0x130
[    6.800368]  ? __x64_sys_finit_module+0x18/0x20
[    6.800369]  ? do_syscall_64+0x58/0x80
[    6.800371]  ? syscall_exit_to_user_mode+0x1b/0x40
[    6.800373]  ? do_syscall_64+0x67/0x80
[    6.800375]  ? switch_fpu_return+0x4e/0xc0
[    6.800377]  ? exit_to_user_mode_prepare+0x184/0x1e0
[    6.800379]  ? syscall_exit_to_user_mode+0x1b/0x40
[    6.800380]  ? do_syscall_64+0x67/0x80
[    6.800382]  ? do_syscall_64+0x67/0x80
[    6.800384]  ? do_syscall_64+0x67/0x80
[    6.800385]  ? sysvec_call_function+0x4b/0xa0
[    6.800387]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[    6.800391]  </TASK>

     Are these related or should I open a new ticket?  These occurred right
after boot.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
