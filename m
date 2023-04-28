Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8F96F1259
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 09:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345451AbjD1H1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 03:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjD1H1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 03:27:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F85B2689
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 00:27:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF66660A0F
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 07:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19E9FC433EF
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 07:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682666858;
        bh=N2G6UrTync2GZX/7lK5vhrNrttWgymPl1i8m7B7tbDQ=;
        h=From:To:Subject:Date:From;
        b=oGy0e35un85ZO5NBnwkHpMLkba0PXzMc8NH6P+Vl/VFim2oYFWlT0NXUZnx0dJ6Jd
         0DMWmptY/GJxlwqGS2u96rwuPK73sJCTDGMuxOZRZckeMQJ2YKheN4eOE/2+Hho4y1
         aA5MNcD8gC1b2UfMB3vfDKAem+zegApFS6YTUcRCP1JMF5qsv1HTk+HsG6NuWh2wgA
         RxZrGeQJKi9/Sf68xuV1hJcIthh9WP9zuy2Q5gRQOEYzbnjXJHXsOSvQHxr58ipzhh
         i9lm0eFzgw0WzIn9zWcrtJ7nzGzVaByr98neXth+Isch/2NPZzy57VmLYwbN/nu7EK
         GCBU21w2aPypw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id ED5A7C43141; Fri, 28 Apr 2023 07:27:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217379] New: Latency issues in irq_bypass_register_consumer
Date:   Fri, 28 Apr 2023 07:27:37 +0000
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
Message-ID: <bug-217379-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217379

            Bug ID: 217379
           Summary: Latency issues in irq_bypass_register_consumer
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: zhuangel570@gmail.com
        Regression: No

We found some latency issue in high-density and high-concurrency scenarios,
we are using cloud hypervisor as vmm for lightweight VM, using VIRTIO net a=
nd
block for VM. In our test, we got about 50ms to 100ms+ latency in creating =
VM
and register irqfd, after trace with funclatency (a tool of bcc-tools,
https://github.com/iovisor/bcc), we found the latency introduced by followi=
ng
functions:

- irq_bypass_register_consumer introduce more than 60ms per VM.
  This function was called when registering irqfd, the function will regist=
er
  irqfd as consumer to irqbypass, wait for connecting from irqbypass produc=
ers,
  like VFIO or VDPA. In our test, one irqfd register will get about 4ms
  latency, and 5 devices with total 16 irqfd will introduce more than 60ms
  latency.

Here is a simple case, which can emulate the latency issue (the real latency
is lager). The case create 800 VM as background do nothing, then repeatedly
create 20 VM then destroy them after 400ms, every VM will do simple thing,
create in kernel irq chip, and register 15 riqfd (emulate 5 devices and eve=
ry
device has 3 irqfd), just trace the "irq_bypass_register_consumer" latency,=
 you
will reproduce such kind latency issue. Here is a trace log on Xeon(R) Plat=
inum
8255C server (96C, 2 sockets) with linux 6.2.20.

Reproduce Case
https://github.com/zhuangel/misc/blob/main/test/kvm_irqfd_fork/kvm_irqfd_fo=
rk.c
Reproduce log
https://github.com/zhuangel/misc/blob/main/test/kvm_irqfd_fork/test.log

To fix these latencies, I didn't have a graceful method, just simple ideas
is give user a chance to avoid these latencies, like new flag to disable
irqbypass for each irqfd.

Any suggestion to fix the issue if welcomed.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
