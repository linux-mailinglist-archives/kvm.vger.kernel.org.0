Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F9D4D116D
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 09:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344711AbiCHICS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 03:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344719AbiCHICQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 03:02:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F883E0F9
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 00:01:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3404D61667
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 08:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9284AC340F9
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 08:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646726479;
        bh=ivCtQC3bMa4ayLf/ORXW2lRC+T0uGUS8CsGmBMWIDIE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aMyMB7Bs6wHyO5EJbYfkgQdSbDnThP+fHNkgrgpaEH51A/N9sI7wTvFYYjzGjDWpt
         9QNKXOp3Mu4jk0rvN+P0pzswGWSNblhNgKTs2b9gTYngn7iv6fstrHv7RGDIs8N+xw
         aBGJRDGu1u3c1ctsY4Zihi6Ue08fMT+SUIuGPvZ7R2K3FL9J2qy9KtaVLAJ9tuFPEI
         kwKO3Xie3JoMI9156slwsovVF3DMHeeJM0PsQTmmJO/dWO1SslWW4C+hvc4mrrdz2H
         g6B35tHr6ItODpN7Pi0ORkpLQ1t8XT0de2FqdixoQEWZlnApIjjvkB2oXGtebiDhwE
         /sm4eIQhUYkdg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7FD04C05F98; Tue,  8 Mar 2022 08:01:19 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Tue, 08 Mar 2022 08:01:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: devzero@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-ruBssut0qW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #15 from Roland Kletzing (devzero@web.de) ---
yes, i was using cache=3Dnone and io_uring also caused issues.=20

>aio=3Dthreads avoids softlockups because the preadv(2)/pwritev(2)/fdatasyn=
c(2)
> syscalls run in worker threads that don't take the QEMU global mutex.=20
>Therefore vcpu threads can execute even when I/O is stuck in the kernel du=
e to
>a lock.

yes, that was a long search/journey to get to this information/params....

regarding io_uring - after proxmox enabled it as default, it was taken back
again after some issues had been reported.

have look at:
https://github.com/proxmox/qemu-server/blob/master/debian/changelog

maybe it's not ready for primetime yet !?

-- Proxmox Support Team <support@proxmox.com>  Fri, 30 Jul 2021 16:53:44 +0=
200
qemu-server (7.0-11) bullseye; urgency=3Dmedium
<snip>
  * lvm: avoid the use of io_uring for now
<snip>
-- Proxmox Support Team <support@proxmox.com>  Fri, 23 Jul 2021 11:08:48 +0=
200
qemu-server (7.0-10) bullseye; urgency=3Dmedium
<snip>
  * avoid using io_uring for drives backed by LVM and configured for write-=
back
    or write-through cache
<snip>
 -- Proxmox Support Team <support@proxmox.com>  Mon, 05 Jul 2021 20:49:50 +=
0200
qemu-server (7.0-6) bullseye; urgency=3Dmedium
<snip>
  * For now do not use io_uring for drives backed by Ceph RBD, with KRBD and
    write-back or write-through cache enabled, as in that case some polling=
/IO
    may hang in QEMU 6.0.
<snip>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
