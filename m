Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DD25AA18A
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 23:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbiIAVhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 17:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiIAVhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 17:37:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5239C7331E
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 14:37:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15FC3B825A0
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 21:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C82CAC433C1
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 21:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662068221;
        bh=kwmnhsSsmL3Bpyz3SJyjA2AzvuLb2cnC2QInrpvSmSs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TO54/Jr0zbNAv7jU0IPNMu5V8/lhxvNZKAXHCU0K2WQIaK2vp0v7eyKYrO8145dSb
         stYDq8yr6smMKLkWP9J1+QMICCFJkfjHbCqy/NjWv7MRIhossIcRvO67r1YDY0V3xi
         m/iPjKWTD0Tff4qp1QkyDSGNESNdoimA5JJpHBR8Q4/2iQg9Dxw1qUhrLljIhkB2xy
         wAbOXrj4wPXMAdiy68Z8kr7YmqZUbQsK/Fyqq/ue2XF8pL7SvAAG0gia0lNTdwu8+p
         1tAV/rWqudeCxH9pH/yF3Cue2uwdYtx4GTpIhWoK1SRrfYr3YWkN9qjiboHNd9aHkd
         j8wN9y8aupKRA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id AE1F4C433E4; Thu,  1 Sep 2022 21:37:01 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Thu, 01 Sep 2022 21:37:01 +0000
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
Message-ID: <bug-216388-28872-Gyj0r7lnsG@https.bugzilla.kernel.org/>
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

--- Comment #9 from Robert Dinse (nanook@eskimo.com) ---
I spent some time digging through web server logs, these are the logs from =
the
machine that produced the last three CPU stall messages, but this time the
stall occurred on apache2, this is cool because that is something I can rea=
dily
test.  Here is the stall message:

Sep  1 14:26:53 ftp kernel: [   18.819394][  T298] rcu: INFO: rcu_sched
detected expedited stalls on CPUs/tasks: { 3-... } 4 jiffies s: 441 root: 0=
x8/.
Sep  1 14:26:53 ftp kernel: [   18.819413][  T298] rcu: blocking rcu_node
structures (internal RCU debug):
Sep  1 14:26:53 ftp kernel: [   18.819417][  T298] Task dump for CPU 3:
Sep  1 14:26:53 ftp kernel: [   18.819418][  T298] task:httpd           sta=
te:R
 running task     stack:    0 pid: 2798 ppid:  2460 flags:0x0000400a
Sep  1 14:26:53 ftp kernel: [   18.819424][  T298] Call Trace:
Sep  1 14:26:53 ftp kernel: [   18.819428][  T298]  <TASK>
Sep  1 14:26:53 ftp kernel: [   18.819437][  T298]  ? alloc_pages+0x90/0x1a0
Sep  1 14:26:53 ftp kernel: [   18.819443][  T298]  ? allocate_slab+0x274/0=
x460
Sep  1 14:26:53 ftp kernel: [   18.819445][  T298]  ? xa_load+0xa6/0xc0
Sep  1 14:26:53 ftp kernel: [   18.819448][  T298]  ?
___slab_alloc.constprop.0+0x50b/0x5f0
Sep  1 14:26:53 ftp kernel: [   18.819451][  T298]  ?
kmem_cache_alloc_lru+0x297/0x360
Sep  1 14:26:53 ftp kernel: [   18.819456][  T298]  ? nfs_find_actor+0x90/0=
x90
[nfs]
Sep  1 14:26:53 ftp kernel: [   18.819504][  T298]  ? nfs_alloc_inode+0x21/=
0x60
[nfs]
Sep  1 14:26:53 ftp kernel: [   18.819519][  T298]  ? alloc_inode+0x23/0xc0
Sep  1 14:26:53 ftp kernel: [   18.819526][  T298]  ?
nfs_alloc_fhandle+0x30/0x30 [nfs]
Sep  1 14:26:53 ftp kernel: [   18.819541][  T298]  ? iget5_locked+0x53/0xa0
Sep  1 14:26:53 ftp kernel: [   18.819543][  T298]  ? list_lru_add+0x13f/0x=
190
Sep  1 14:26:53 ftp kernel: [   18.819547][  T298]  ? nfs_fhget+0xd2/0x6d0
[nfs]
Sep  1 14:26:53 ftp kernel: [   18.819570][  T298]  ?
nfs_readdir_entry_decode+0x31e/0x440 [nfs]
Sep  1 14:26:53 ftp kernel: [   18.819581][  T298]  ?
nfs_readdir_page_filler+0x10d/0x4f0 [nfs]
Sep  1 14:26:53 ftp kernel: [   18.819592][  T298]  ?
nfs_readdir_xdr_to_array+0x45e/0x4a0 [nfs]
Sep  1 14:26:53 ftp kernel: [   18.819602][  T298]  ? nfs_readdir+0x2e6/0xe=
a0
[nfs]
Sep  1 14:26:53 ftp kernel: [   18.819613][  T298]  ? iterate_dir+0x9b/0x1d0
Sep  1 14:26:53 ftp kernel: [   18.819615][  T298]  ?
__x64_sys_getdents64+0x84/0x120
Sep  1 14:26:53 ftp kernel: [   18.819616][  T298]  ?
__ia32_sys_getdents64+0x120/0x120
Sep  1 14:26:53 ftp kernel: [   18.819618][  T298]  ? do_syscall_64+0x5b/0x=
80
Sep  1 14:26:53 ftp kernel: [   18.819620][  T298]  ?
do_user_addr_fault+0x1c1/0x620
Sep  1 14:26:53 ftp kernel: [   18.819622][  T298]  ?
exit_to_user_mode_prepare+0x41/0x1e0
Sep  1 14:26:53 ftp kernel: [   18.819625][  T298]  ?
irqentry_exit_to_user_mode+0x9/0x30
Sep  1 14:26:53 ftp kernel: [   18.819626][  T298]  ? irqentry_exit+0x1d/0x=
30
Sep  1 14:26:53 ftp kernel: [   18.819627][  T298]  ? exc_page_fault+0x86/0=
x160
Sep  1 14:26:53 ftp kernel: [   18.819628][  T298]  ?
entry_SYSCALL_64_after_hwframe+0x63/0xcd
Sep  1 14:26:53 ftp kernel: [   18.819631][  T298]  </TASK>

     Now that process is gone, but the parent process is still running and
Apache still seems to be responding fine.  Checking the error log, there we=
re
no errors with that PID.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
