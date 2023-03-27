Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6116CA913
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 17:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbjC0Pch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 11:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjC0Pcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 11:32:36 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818863AB9
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 08:32:34 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id i192-20020a6287c9000000b0062a43acb7faso4405444pfe.8
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 08:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679931154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sISSKx05F8MRym/UKKq+npfFrAdwJ3vGFlOsmkSSnbo=;
        b=ZnSdzbqTC6vcPJL4j+aStfDNreQEGFhDlcaXpW2rEUxwzkVZDyd6+FgKnCMDk47MaV
         L7Ubt+AtJeu9lbDgT/86WAD2rQ4B1ljQj24+AzS4n6aiM2F0dJjk927BCYwEXiTv9tL/
         VsOMeAaudsXgENZJyC+oybCPWwO3pvJfsI1g8XRWGiYpkOcv2DJc84452Wn323H0jI7J
         VVseZiPE8W87dw74CrQij88VFqFIGKpSbSzyIadU3XJTSJHGSL/60w1Orx/JGZE5aayb
         Wt177gx41H+ghTgcM7DWmcqQMOc+O7Z3Hz7K2aux7lWef/g4TSq2kZdy4HQ8zPnHpYQA
         03MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679931154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sISSKx05F8MRym/UKKq+npfFrAdwJ3vGFlOsmkSSnbo=;
        b=i+h1Xep65mFi4w5+6WHMCA9cbSggtnJSxxlVyiygUHNFimyR/Vxwu24TcbuiuVjovO
         5us3ihQjGYqPajrZ8XGQetUXgwLTaXNMOUJMdXJwE2dhmszvtjDDkxgiIE1JlAGrZ3ck
         qU4Bm4Z58dGnw/s0/4uXo3x5etMqe3wL35P8XoCAAvC1kHdma2yYQAOBnZ/uPZ7/wlmb
         g2Y/VZvvzh1LYlt0RjPuZ0Y6NAR3pBY+lghVVMhO+hKFaiBFLvcVN1zOSRn5zBPeNqXo
         hBupiVrh2dMZMdl9YtE44cHAS//nhcmsARE7/IPbs22+MzTSKDIR7pRQfa5qDk3naNys
         lOwg==
X-Gm-Message-State: AAQBX9dtRVk1nKrBMhf6QmYL6pKPCg+Bd0l5KcdKcvNmi4DruCbDmk+o
        tmr8AhYpO2EEaM/iafR/FHwxc+n7VII=
X-Google-Smtp-Source: AKy350Yhy3f1HCzqD/OJgsnic75NrVRUrzyzmK2zDom2vmrQ3g8e6TvK8ZS/Gax454qLPBYYNxq8csdczkM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:3487:b0:23b:4e4b:fc2 with SMTP id
 p7-20020a17090a348700b0023b4e4b0fc2mr3639740pjb.0.1679931154000; Mon, 27 Mar
 2023 08:32:34 -0700 (PDT)
Date:   Mon, 27 Mar 2023 08:32:32 -0700
In-Reply-To: <bug-217247-28872@https.bugzilla.kernel.org/>
Mime-Version: 1.0
References: <bug-217247-28872@https.bugzilla.kernel.org/>
Message-ID: <ZCG3EH0gte1/BrjO@google.com>
Subject: Re: [Bug 217247] New: BUG: kernel NULL pointer dereference, address:
 000000000000000c / speculation_ctrl_update
From:   Sean Christopherson <seanjc@google.com>
To:     bugzilla-daemon@kernel.org
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+tglx

On Sat, Mar 25, 2023, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=217247
> 
>             Bug ID: 217247
>            Summary: BUG: kernel NULL pointer dereference, address:
>                     000000000000000c / speculation_ctrl_update
>            Product: Virtualization
>            Version: unspecified
>     Kernel Version: 6.1.20
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: hvtaifwkbgefbaei@gmail.com
>         Regression: No
> 
> Created attachment 304023
>   --> https://bugzilla.kernel.org/attachment.cgi?id=304023&action=edit
> kernel config
> 
> This is 6.1.20 with only ZFS 2.1.9 module added.
> I booted kernel with acpi=off because this old Ryzen 1600X system is getting
> unreliable (so only one CPU is online with acpi=off, and it has been reliable
> before this splat).
> 
> 2023-03-25T13:28:40,794781+02:00 BUG: kernel NULL pointer dereference, address:
> 000000000000000c
> 2023-03-25T13:28:40,794786+02:00 #PF: supervisor read access in kernel mode
> 2023-03-25T13:28:40,794788+02:00 #PF: error_code(0x0000) - not-present page
> 2023-03-25T13:28:40,794790+02:00 PGD 0 P4D 0 
> 2023-03-25T13:28:40,794793+02:00 Oops: 0000 [#1] PREEMPT SMP NOPTI
> 2023-03-25T13:28:40,794795+02:00 CPU: 0 PID: 917598 Comm: qemu-kvm Tainted: P  
>      W  O       6.1.20+ #12
> 2023-03-25T13:28:40,794798+02:00 Hardware name: To Be Filled By O.E.M. To Be
> Filled By O.E.M./X370 Taichi, BIOS P6.20 01/03/2020
> 2023-03-25T13:28:40,794800+02:00 RIP: 0010:do_raw_spin_lock+0x6/0xb0

This looks like amd_set_core_ssb_state() explodes when it tries to acquire
ssb_state.shared_state.lock.

Aha!  With acpi=off, I assume __apic_intr_mode_select() will return
APIC_VIRTUAL_WIRE_NO_CONFIG:

	/* Check MP table or ACPI MADT configuration */
	if (!smp_found_config) {
		disable_ioapic_support();
		if (!acpi_lapic) {
			pr_info("APIC: ACPI MADT or MP tables are not detected\n");
			return APIC_VIRTUAL_WIRE_NO_CONFIG;
		}
		return APIC_VIRTUAL_WIRE;
	}

Which will cause native_smp_prepare_cpus() to bail early and not run through
speculative_store_bypass_ht_init(), leaving a NULL ssb_state.shared_state:

	switch (apic_intr_mode) {
	case APIC_PIC:
	case APIC_VIRTUAL_WIRE_NO_CONFIG:
		disable_smp();
		return;
	case APIC_SYMMETRIC_IO_NO_ROUTING:
		disable_smp();
		/* Setup local timer */
		x86_init.timers.setup_percpu_clockev();
		return;
	case APIC_VIRTUAL_WIRE:
	case APIC_SYMMETRIC_IO:
		break;
	}

I believe this will remedy your problem.  I don't see anything that will obviously
break in native_smp_prepare_cpus() by continuing on with a "bad" APIC.  Hopefully
Thomas can weigh in on whether or not it's a sane change.

---
 arch/x86/kernel/smpboot.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9013bb28255a..ff69f8e3c392 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1409,22 +1409,17 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	case APIC_PIC:
 	case APIC_VIRTUAL_WIRE_NO_CONFIG:
 		disable_smp();
-		return;
+		break;
 	case APIC_SYMMETRIC_IO_NO_ROUTING:
 		disable_smp();
-		/* Setup local timer */
-		x86_init.timers.setup_percpu_clockev();
-		return;
+		fallthrough;
 	case APIC_VIRTUAL_WIRE:
 	case APIC_SYMMETRIC_IO:
+		x86_init.timers.setup_percpu_clockev();
+		smp_get_logical_apicid();
 		break;
 	}
 
-	/* Setup local timer */
-	x86_init.timers.setup_percpu_clockev();
-
-	smp_get_logical_apicid();
-
 	pr_info("CPU0: ");
 	print_cpu_info(&cpu_data(0));
 

base-commit: b0d237087c674c43df76c1a0bc2737592f3038f4
-- 

> 2023-03-25T13:28:40,794805+02:00 Code: 05 00 00 48 8d 88 60 07 00 00 48 c7 c7
> 18 66 af 9e e8 49 a9 28 01 e9 4c 8d 32 01 66 0f 1f 84 00 00 00 00 00 0f 1f 44
> 00 00 53 <8b> 47 04 48 89 fb 3d ad 4e ad de 75 60 48 8b 53 10 65 48 8b 04 25
> 2023-03-25T13:28:40,794807+02:00 RSP: 0018:ffffa9110f3cbc58 EFLAGS: 00010046
> 2023-03-25T13:28:40,794809+02:00 RAX: 0000000000000000 RBX: 0000000000000020
> RCX: 0000000000000000
> 2023-03-25T13:28:40,794810+02:00 RDX: 0000000000000000 RSI: 0000000000000000
> RDI: 0000000000000008
> 2023-03-25T13:28:40,794812+02:00 RBP: 0000000000000000 R08: 0000000000000000
> R09: 0000000000000000
> 2023-03-25T13:28:40,794813+02:00 R10: 0000000000000000 R11: 0000000000000000
> R12: 0000000000000002
> 2023-03-25T13:28:40,794814+02:00 R13: 0206800000000010 R14: ffff9ceffe81fba0
> R15: 0000000000000400
> 2023-03-25T13:28:40,794816+02:00 FS:  000074963adfd6c0(0000)
> GS:ffff9ceffe800000(0000) knlGS:0000000000000000
> 2023-03-25T13:28:40,794818+02:00 CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> 2023-03-25T13:28:40,794819+02:00 CR2: 000000000000000c CR3: 00000005227da000
> CR4: 00000000003506f0
> 2023-03-25T13:28:40,794821+02:00 Call Trace:
> 2023-03-25T13:28:40,794823+02:00  <TASK>
> 2023-03-25T13:28:40,794826+02:00  speculation_ctrl_update+0xe2/0x1e0
> 2023-03-25T13:28:40,794830+02:00  svm_vcpu_run+0x4db/0x790 [kvm_amd]
> 2023-03-25T13:28:40,794838+02:00  kvm_arch_vcpu_ioctl_run+0x8f0/0x1730 [kvm]
> 2023-03-25T13:28:40,794876+02:00  ? kvm_vm_ioctl+0x386/0x1260 [kvm]
> 2023-03-25T13:28:40,794907+02:00  kvm_vcpu_ioctl+0x22b/0x670 [kvm]
> 2023-03-25T13:28:40,794937+02:00  ? kvm_vm_ioctl_irq_line+0x23/0x50 [kvm]
> 2023-03-25T13:28:40,794971+02:00  ? _copy_to_user+0x21/0x40
> 2023-03-25T13:28:40,794974+02:00  ? kvm_vm_ioctl+0x386/0x1260 [kvm]
> 2023-03-25T13:28:40,795004+02:00  ? do_iter_readv_writev+0xdf/0x150
> 2023-03-25T13:28:40,795008+02:00  __x64_sys_ioctl+0x1b3/0x930
> 2023-03-25T13:28:40,795012+02:00  ? exit_to_user_mode_prepare+0x1e/0x110
> 2023-03-25T13:28:40,795015+02:00  do_syscall_64+0x5b/0x90
> 2023-03-25T13:28:40,795019+02:00  ? exit_to_user_mode_prepare+0x1e/0x110
> 2023-03-25T13:28:40,795021+02:00  ? syscall_exit_to_user_mode+0x25/0x50
> 2023-03-25T13:28:40,795023+02:00  ? do_syscall_64+0x67/0x90
> 2023-03-25T13:28:40,795025+02:00  ? do_syscall_64+0x67/0x90
> 2023-03-25T13:28:40,795027+02:00  ? exit_to_user_mode_prepare+0x101/0x110
> 2023-03-25T13:28:40,795029+02:00  ? syscall_exit_to_user_mode+0x25/0x50
> 2023-03-25T13:28:40,795031+02:00  ? do_syscall_64+0x67/0x90
> 2023-03-25T13:28:40,795033+02:00  entry_SYSCALL_64_after_hwframe+0x63/0xcd
