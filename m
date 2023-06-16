Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE1973355E
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 18:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344997AbjFPQDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 12:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344428AbjFPQCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 12:02:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AEA269E
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 09:02:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EF81623C6
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 16:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85C20C433CA
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 16:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686931365;
        bh=1tA5puP1Z0RV9u5S9jOpo2y8yn1V+zvYjVRjNWSzpUI=;
        h=From:To:Subject:Date:From;
        b=OnAenTyHTk9kWo9oG5hbsHvLiSOC/BRSd3qeYdmrOlmV2VUCxz78VKTTqBLTns9fz
         7WR/41DIY+o26pPA7ZQnUGdqpfz+rHegpqj7uLIEHvMo1dVv/4QEP/nF/Dyirhy6QU
         JVr762G32p+vQrrFK2qi2Pkg4HnX5aCi3YGFfyfhyJnm/cU8xENPl5+zb1KyJ/iPdd
         9PoXSb8udnuaKRsDRVuqdXgAJJvmuaW5q8OONuWCJLP8oJnb4GP6HN2NSvAODIZU1K
         p4NUzrVYHfMufawXWvzYFXG7aot8tnqbOv7wqgBFInaRjXaZWGXIdxP9+qAz5m00kd
         HpyIuXqJrXOTw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 67744C53BD1; Fri, 16 Jun 2023 16:02:45 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217562] New: kernel NULL pointer dereference on deletion of
 guest physical memory slot
Date:   Fri, 16 Jun 2023 16:02:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: arnaud.lefebvre@clever-cloud.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-217562-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217562

            Bug ID: 217562
           Summary: kernel NULL pointer dereference on deletion of guest
                    physical memory slot
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: arnaud.lefebvre@clever-cloud.com
        Regression: No

Created attachment 304438
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D304438&action=3Dedit
dmesg logs with decoded backtrace

Hello,

We've been having this BUG for the last 6 months on both Intel and AMD hosts
without being able to reproduce it on demand. The issue also occurs randoml=
y:

[Mon Jun 12 10:50:08 UTC 2023] BUG: kernel NULL pointer dereference, addres=
s:
0000000000000008
[Mon Jun 12 10:50:08 UTC 2023] #PF: supervisor write access in kernel mode
[Mon Jun 12 10:50:08 UTC 2023] #PF: error_code(0x0002) - not-present page
[Mon Jun 12 10:50:08 UTC 2023] PGD 0 P4D 0
[Mon Jun 12 10:50:08 UTC 2023] Oops: 0002 [#1] SMP NOPTI
[Mon Jun 12 10:50:08 UTC 2023] CPU: 88 PID: 856806 Comm: qemu Kdump: loaded=
 Not
tainted 5.15.115 #1
[Mon Jun 12 10:50:08 UTC 2023] Hardware name: MCT         Capri=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
         /Capri           , BIOS V2010 04/19/2022
[Mon Jun 12 10:50:08 UTC 2023] RIP: 0010:__handle_changed_spte+0x5f3/0x670
[Mon Jun 12 10:50:08 UTC 2023] Code: b8 a8 00 00 00 e9 4d be 0f 00 4d 8d be=
 60
6a 01 00 4c 89 44 24 08 4c 89 ff e8 69 30 43 01 4c 8b 44 24 08 49 8b 40 08 =
49
8b 10 <48> 89 42 08 48 89 10 48 b8 00 01 00 00 00 00 ad de 49 89 00 48 83
[Mon Jun 12 10:50:09 UTC 2023] RSP: 0018:ffffc90029477840 EFLAGS: 00010246
[Mon Jun 12 10:50:09 UTC 2023] RAX: 0000000000000000 RBX: ffff89581a1f6000 =
RCX:
0000000000000000
[Mon Jun 12 10:50:09 UTC 2023] RDX: 0000000000000000 RSI: 0000000000000002 =
RDI:
ffffc9002d858a60
[Mon Jun 12 10:50:09 UTC 2023] RBP: 0000000000002200 R08: ffff893450426450 =
R09:
0000000000000002
[Mon Jun 12 10:50:09 UTC 2023] R10: 0000000000000001 R11: 0000000000000001 =
R12:
0000000000000001
[Mon Jun 12 10:50:09 UTC 2023] R13: 00000000000005a0 R14: ffffc9002d842000 =
R15:
ffffc9002d858a60
[Mon Jun 12 10:50:09 UTC 2023] FS:  00007fdb6c1ff6c0(0000)
GS:ffff89804d800000(0000) knlGS:0000000000000000
[Mon Jun 12 10:50:09 UTC 2023] CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
[Mon Jun 12 10:50:09 UTC 2023] CR2: 0000000000000008 CR3: 0000005380534005 =
CR4:
0000000000770ee0
[Mon Jun 12 10:50:09 UTC 2023] PKRU: 55555554
[Mon Jun 12 10:50:09 UTC 2023] Call Trace:
[Mon Jun 12 10:50:09 UTC 2023]  <TASK>
[Mon Jun 12 10:50:09 UTC 2023]  ? __die+0x50/0x8d
[Mon Jun 12 10:50:09 UTC 2023]  ? page_fault_oops+0x184/0x2f0
[Mon Jun 12 10:50:09 UTC 2023]  ? exc_page_fault+0x535/0x7d0
[Mon Jun 12 10:50:09 UTC 2023]  ? asm_exc_page_fault+0x22/0x30
[Mon Jun 12 10:50:09 UTC 2023]  ? __handle_changed_spte+0x5f3/0x670
[Mon Jun 12 10:50:09 UTC 2023]  ? update_load_avg+0x73/0x560
[Mon Jun 12 10:50:09 UTC 2023]  __handle_changed_spte+0x3ae/0x670
[Mon Jun 12 10:50:09 UTC 2023]  __handle_changed_spte+0x3ae/0x670
[Mon Jun 12 10:50:09 UTC 2023]  zap_gfn_range+0x21a/0x320
[Mon Jun 12 10:50:09 UTC 2023]  kvm_tdp_mmu_zap_invalidated_roots+0x50/0xa0
[Mon Jun 12 10:50:09 UTC 2023]  kvm_mmu_zap_all_fast+0x178/0x1b0
[Mon Jun 12 10:50:09 UTC 2023]  kvm_page_track_flush_slot+0x4f/0x90
[Mon Jun 12 10:50:09 UTC 2023]  kvm_set_memslot+0x32b/0x8e0
[Mon Jun 12 10:50:09 UTC 2023]  kvm_delete_memslot+0x58/0x80
[Mon Jun 12 10:50:09 UTC 2023]  __kvm_set_memory_region+0x3c4/0x4a0
[Mon Jun 12 10:50:09 UTC 2023]  kvm_vm_ioctl+0x3d1/0xea0
[Mon Jun 12 10:50:09 UTC 2023]  __x64_sys_ioctl+0x8b/0xc0
[Mon Jun 12 10:50:09 UTC 2023]  do_syscall_64+0x3f/0x90
[Mon Jun 12 10:50:09 UTC 2023]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[Mon Jun 12 10:50:09 UTC 2023] RIP: 0033:0x7fdc71e3a5ef
[Mon Jun 12 10:50:09 UTC 2023] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60=
 c7
04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 =
00
0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[Mon Jun 12 10:50:09 UTC 2023] RSP: 002b:00007fdb6c1fc920 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Mon Jun 12 10:50:09 UTC 2023] RAX: ffffffffffffffda RBX: 000000004020ae46 =
RCX:
00007fdc71e3a5ef
[Mon Jun 12 10:50:09 UTC 2023] RDX: 00007fdb6c1fca40 RSI: 000000004020ae46 =
RDI:
000000000000000d
[Mon Jun 12 10:50:09 UTC 2023] RBP: 00007fdc714fa000 R08: 0000000000000002 =
R09:
00007fdc6f7e8e10
[Mon Jun 12 10:50:09 UTC 2023] R10: 00007fdc724966e8 R11: 0000000000000246 =
R12:
00007fdb6c1fca40
[Mon Jun 12 10:50:09 UTC 2023] R13: 0000000001000000 R14: 00007fdb68400000 =
R15:
00000000fd000000
[Mon Jun 12 10:50:09 UTC 2023]  </TASK>
[Mon Jun 12 10:50:09 UTC 2023] CR2: 0000000000000008
[Mon Jun 12 10:50:09 UTC 2023] ---[ end trace 353e5ae9ef11cd10 ]---
[Mon Jun 12 10:50:09 UTC 2023] RIP: 0010:__handle_changed_spte+0x5f3/0x670
[Mon Jun 12 10:50:09 UTC 2023] Code: b8 a8 00 00 00 e9 4d be 0f 00 4d 8d be=
 60
6a 01 00 4c 89 44 24 08 4c 89 ff e8 69 30 43 01 4c 8b 44 24 08 49 8b 40 08 =
49
8b 10 <48> 89 42 08 48 89 10 48 b8 00 01 00 00 00 00 ad de 49 89 00 48 83
[Mon Jun 12 10:50:09 UTC 2023] RSP: 0018:ffffc90029477840 EFLAGS: 00010246
[Mon Jun 12 10:50:09 UTC 2023] RAX: 0000000000000000 RBX: ffff89581a1f6000 =
RCX:
0000000000000000
[Mon Jun 12 10:50:09 UTC 2023] RDX: 0000000000000000 RSI: 0000000000000002 =
RDI:
ffffc9002d858a60
[Mon Jun 12 10:50:09 UTC 2023] RBP: 0000000000002200 R08: ffff893450426450 =
R09:
0000000000000002
[Mon Jun 12 10:50:09 UTC 2023] R10: 0000000000000001 R11: 0000000000000001 =
R12:
0000000000000001
[Mon Jun 12 10:50:09 UTC 2023] R13: 00000000000005a0 R14: ffffc9002d842000 =
R15:
ffffc9002d858a60
[Mon Jun 12 10:50:09 UTC 2023] FS:  00007fdb6c1ff6c0(0000)
GS:ffff89804d800000(0000) knlGS:0000000000000000
[Mon Jun 12 10:50:09 UTC 2023] CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
[Mon Jun 12 10:50:09 UTC 2023] CR2: 0000000000000008 CR3: 0000005380534005 =
CR4:
0000000000770ee0
[Mon Jun 12 10:50:09 UTC 2023] PKRU: 55555554

We've seen this issue with kernel 5.15.115, 5.15.79, some versions between =
the
two, and probably a 5.15.4x (not sure here). At the beginning, only a few
"identical" hosts (same hardware model) had this issue but since then we've
also had crashes on hosts running different hardware. Unfortunately, it
sometimes takes a  few weeks to trigger (last occurrence before this one wa=
s 2
months ago) and we can't really think of a way to reproduce this.

As you can see in the dmesg.log.gz file, this bug then creates soft lockups=
 for
other processes, I guess because they wait for some kind of lock that never
gets released. The host then becomes more and more unresponsive as time goes
by.

Let me know if I can provide any other details.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
