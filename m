Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5166F125E
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 09:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345528AbjD1HaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 03:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345508AbjD1HaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 03:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5A5469E
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 00:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5885B64167
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 07:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BDAB4C4339C
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 07:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682667014;
        bh=4UPL+R512sDXg3F8cpovsU7C/T4sWCKyZG/hxe4T4FQ=;
        h=From:To:Subject:Date:From;
        b=QggVcZFE+yAlRUkIi3pw1GvLX+s2CZfIIoXWHOqUplePpbZ3IUTyJzFiMx/P4i5xi
         FjzHgKqXFjhjMfTHL3BA0hUmXaCpH7vDaDggFyXeR2z3N6AsFOOIbGAmxVMuLdl2oQ
         tiOV3tAC8/PwQ0Dhlwn3KtBaKGrHMibRianJcfpZt9QjOv97x/KLp5h/MU7xTYnJBO
         ZNPjTxuXB6Tn6dWqzXPXxK8wdrehfz+80KtWX6UDG5ekRhVzPHuybvwzCYR0m/ClfR
         XXFV7pEVvjtqYAE6TdNeswNcj+FCOO+Ib0nOrjqAqbj+QpEJj3VNM6v8vKE2pnieSb
         VJQonRi6eFaDA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id ACD5BC43144; Fri, 28 Apr 2023 07:30:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217380] New: Latency issues in creating kvm-nx-lpage-recovery
 kthread
Date:   Fri, 28 Apr 2023 07:30:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zhuangel570@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-217380-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217380

            Bug ID: 217380
           Summary: Latency issues in creating kvm-nx-lpage-recovery
                    kthread
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: zhuangel570@gmail.com
        Regression: No

Hi

We found some latency issue in high-density and high-concurrency scenarios,=
 we
are using cloud hypervisor as vmm for lightweight VM, using VIRTIO net and
block for VM. In our test, we got about 50ms to 100ms+ latency in creating =
VM
and register irqfd, after trace with funclatency (a tool of bcc-tools,
https://github.com/iovisor/bcc), we found the latency introduced by followi=
ng
functions:

- kvm_vm_create_worker_thread introduce tail latency more than 100ms.
  This function was called when create "kvm-nx-lpage-recovery" kthread when
  create a new VM, this patch was introduced to recovery large page to reli=
ef
  performance loss caused by software mitigation of ITLB_MULTIHIT, see
  b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation") and 1aa9b9572b10
  ("kvm: x86: mmu: Recovery of shattered NX large pages").

Here is a simple case, which can emulate the latency issue (the real latency
is lager). The case create 800 VM as background do nothing, then repeatedly
create 20 VM then destroy them after 400ms, just trace the two function
latency,=20
you will reproduce such kind latency issue. Here is a trace log on Xeon(R)
Platinum 8255C server (96C, 2 sockets) with linux 6.2.20.

Reproduce Case
https://github.com/zhuangel/misc/blob/main/test/kvm_irqfd_fork/kvm_irqfd_fo=
rk.c
Reproduce log
https://github.com/zhuangel/misc/blob/main/test/kvm_irqfd_fork/test.log

To fix these latencies, I didn't have a graceful method, just simple ideas
is give user a chance to avoid these latencies, like a module parameter to
disable "kvm-nx-lpage-recovery" kthread.

Any suggestion to fix the issue if welcomed.

Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
