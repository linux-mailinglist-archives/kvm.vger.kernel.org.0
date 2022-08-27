Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB14B5A39C6
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 21:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiH0Tmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Aug 2022 15:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiH0Tmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Aug 2022 15:42:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332624AD6B
        for <kvm@vger.kernel.org>; Sat, 27 Aug 2022 12:42:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C14F660E9F
        for <kvm@vger.kernel.org>; Sat, 27 Aug 2022 19:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 276D9C433B5
        for <kvm@vger.kernel.org>; Sat, 27 Aug 2022 19:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661629355;
        bh=Dpj+w742vv8Q9/d2Qx1ahhVLXPtkhG/pLzN/sIYBxJc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gPgo+ZFKmPK0GhGMxwtmEoYTTiJURmYmNAvUPYTWkuNyIb9vaHe/BSQAHBoppRsGf
         R6J8Sopno4Qmi/EC6pGXW/3SN2yduUAQ5UmmRBFGdskugaHDC9X+qG6eennMPvAt56
         cZgrNMWPoLdkbZqQbRe0l84SqA61BW6uB9NcSTc7nNhiHUZdltSxcbKpjkcNXv7A2B
         30t7oN9vU60amp3vgy2LYj4k6CeVMvskjuQDiitZW6RnsTPlpHNhTR4xVZhCi1f2y8
         rnKDFdvRzWyiQAr0lYX0DLEADQaDMsSH3nT+PL64lUqtD3uzjALMVAUxu4A/mFwcq7
         HDxPQpXVIwbnA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 129B0C433E6; Sat, 27 Aug 2022 19:42:35 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Sat, 27 Aug 2022 19:42:34 +0000
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
Message-ID: <bug-216388-28872-Bw2DeK04yH@https.bugzilla.kernel.org/>
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

--- Comment #4 from Robert Dinse (nanook@eskimo.com) ---
     I am not seeing this particular CPU stall on 5.19.4, but I am seeing o=
ther
CPU stalls.  I've opened three different tickets on CPU stalls because they=
've
all been in completely different tasks but at this point I have to wonder if
there isn't some common code that they are all calling or a broken structure
they are all using or something similar.  Rather than open 40 more tickets =
that
all end up being a duplicate, perhaps someone familiar with the internal
workings could look at these two tickets in addition to this one, #216399,
which is a stall on an MDRAID task, and #216405, and then before I open yet
another ticket, here is yet another CPU stall in a task worker:

[  489.383957] INFO: task worker:11403 blocked for more than 122 seconds.
[  489.383962]       Not tainted 5.19.4 #1
[  489.383964] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this
message.
[  489.383965] task:worker          state:D stack:    0 pid:11403 ppid:    =
 1
flags:0x00004002
[  489.383968] Call Trace:
[  489.383970]  <TASK>
[  489.383973]  __schedule+0x367/0x1400
[  489.383980]  schedule+0x58/0xf0
[  489.383983]  io_schedule+0x46/0x80
[  489.383985]  folio_wait_bit_common+0x11e/0x350
[  489.383989]  ? filemap_invalidate_unlock_two+0x50/0x50
[  489.383992]  folio_wait_bit+0x18/0x20
[  489.383994]  folio_wait_writeback+0x2c/0x80
[  489.383997]  wait_on_page_writeback+0x18/0x50
[  489.383999]  __filemap_fdatawait_range+0x98/0x140
[  489.384003]  file_write_and_wait_range+0x83/0xb0
[  489.384005]  ext4_sync_file+0xf3/0x320
[  489.384009]  __x64_sys_fdatasync+0x4e/0xa0
[  489.384012]  ? syscall_enter_from_user_mode+0x50/0x70
[  489.384014]  do_syscall_64+0x58/0x80
[  489.384017]  ? sysvec_apic_timer_interrupt+0x4b/0xa0
[  489.384020]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  489.384022] RIP: 0033:0x7f96e331bb1b
[  489.384025] RSP: 002b:00007f96788c75d0 EFLAGS: 00000293 ORIG_RAX:
000000000000004b
[  489.384027] RAX: ffffffffffffffda RBX: 00005639414e0860 RCX:
00007f96e331bb1b
[  489.384029] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
000000000000000b
[  489.384030] RBP: 0000563941270890 R08: 0000000000000000 R09:
0000000000000000
[  489.384031] R10: 00007f96788c75f0 R11: 0000000000000293 R12:
0000000000000000
[  489.384033] R13: 00005639412708f8 R14: 00005639425cedd0 R15:
00007ffded76f3d0
[  489.384036]  </TASK>

If this appears to be related I will not generate a ticket but I am not
knowledgable enough about the internals to know.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
