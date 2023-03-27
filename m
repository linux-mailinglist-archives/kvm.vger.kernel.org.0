Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1876CA914
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 17:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbjC0Pcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 11:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbjC0Pck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 11:32:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDF340D8
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 08:32:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBAA46132A
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 15:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BA29C4339B
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 15:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679931157;
        bh=uhMN1P6gHXpPH/LlV74QXoHIEcU+k+AsPSYgRIO3ZRA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=G04OZPn5eQlFOplOTTq47lYdTsXcPwqfKwUl9ZewG7FOCC9XxQR+0pmvHhBSnuzPt
         lwV9gQ3lmnq9nVN11af5izYImJ7pyNt//mO3glzNtnaUWeMuvF8HOci2DP0EZnYZSi
         XIhEZ35e9VbVzdISIGH5+gIhLA5i25Y6pfR5oJrL3Pipj63Z+zejU+17WVnwLM4PXw
         OR5QTaZVs7HU/EpZrusCOw55BOxzUhQCeq8fYbh1sN83myq3gIjbqgyMSrRTsGsivC
         NMgXgKSHF6wiVT1NZYeF7JqYwc2Gkqn6EecYqnEUxW/pnugwGGIee0P+IdilVnP7xz
         qEq/g4iv7uZMQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 36860C43145; Mon, 27 Mar 2023 15:32:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217247] BUG: kernel NULL pointer dereference, address:
 000000000000000c / speculation_ctrl_update
Date:   Mon, 27 Mar 2023 15:32:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217247-28872-KWS7YimwyM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217247-28872@https.bugzilla.kernel.org/>
References: <bug-217247-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217247

--- Comment #2 from Sean Christopherson (seanjc@google.com) ---
+tglx

On Sat, Mar 25, 2023, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217247
>=20
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
>=20
> Created attachment 304023
>   --> https://bugzilla.kernel.org/attachment.cgi?id=3D304023&action=3Dedit
> kernel config
>=20
> This is 6.1.20 with only ZFS 2.1.9 module added.
> I booted kernel with acpi=3Doff because this old Ryzen 1600X system is ge=
tting
> unreliable (so only one CPU is online with acpi=3Doff, and it has been re=
liable
> before this splat).
>=20
> 2023-03-25T13:28:40,794781+02:00 BUG: kernel NULL pointer dereference,
> address:
> 000000000000000c
> 2023-03-25T13:28:40,794786+02:00 #PF: supervisor read access in kernel mo=
de
> 2023-03-25T13:28:40,794788+02:00 #PF: error_code(0x0000) - not-present pa=
ge
> 2023-03-25T13:28:40,794790+02:00 PGD 0 P4D 0=20
> 2023-03-25T13:28:40,794793+02:00 Oops: 0000 [#1] PREEMPT SMP NOPTI
> 2023-03-25T13:28:40,794795+02:00 CPU: 0 PID: 917598 Comm: qemu-kvm Tainte=
d: P=20
>      W  O       6.1.20+ #12
> 2023-03-25T13:28:40,794798+02:00 Hardware name: To Be Filled By O.E.M. To=
 Be
> Filled By O.E.M./X370 Taichi, BIOS P6.20 01/03/2020
> 2023-03-25T13:28:40,794800+02:00 RIP: 0010:do_raw_spin_lock+0x6/0xb0

This looks like amd_set_core_ssb_state() explodes when it tries to acquire
ssb_state.shared_state.lock.

Aha!  With acpi=3Doff, I assume __apic_intr_mode_select() will return
APIC_VIRTUAL_WIRE_NO_CONFIG:

        /* Check MP table or ACPI MADT configuration */
        if (!smp_found_config) {
                disable_ioapic_support();
                if (!acpi_lapic) {
                        pr_info("APIC: ACPI MADT or MP tables are not
detected\n");
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

I believe this will remedy your problem.  I don't see anything that will
obviously
break in native_smp_prepare_cpus() by continuing on with a "bad" APIC.=20
Hopefully
Thomas can weigh in on whether or not it's a sane change.

---
 arch/x86/kernel/smpboot.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9013bb28255a..ff69f8e3c392 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1409,22 +1409,17 @@ void __init native_smp_prepare_cpus(unsigned int
max_cpus)
        case APIC_PIC:
        case APIC_VIRTUAL_WIRE_NO_CONFIG:
                disable_smp();
-               return;
+               break;
        case APIC_SYMMETRIC_IO_NO_ROUTING:
                disable_smp();
-               /* Setup local timer */
-               x86_init.timers.setup_percpu_clockev();
-               return;
+               fallthrough;
        case APIC_VIRTUAL_WIRE:
        case APIC_SYMMETRIC_IO:
+               x86_init.timers.setup_percpu_clockev();
+               smp_get_logical_apicid();
                break;
        }

-       /* Setup local timer */
-       x86_init.timers.setup_percpu_clockev();
-
-       smp_get_logical_apicid();
-
        pr_info("CPU0: ");
        print_cpu_info(&cpu_data(0));


base-commit: b0d237087c674c43df76c1a0bc2737592f3038f4

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
