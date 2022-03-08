Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038754D1229
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 09:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbiCHI1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 03:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbiCHI1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 03:27:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5E53F318
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 00:26:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9C35B817D4
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 08:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9806CC340F7
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 08:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646727965;
        bh=guvk9x1Op97zuzURP3QqZ9xuFIprOfjMyPIa+lWEAsc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=t3hrTae4TGY+vb2jQsHaUn6k2adXAJdkW2QsLACHLr12mp00/FtJeAI8wlpqiXXJO
         qsDd+0k8Oio/WUZGZoHMi2q6vycg36dOfOsdS2AYeLK3mbCuJkyilw6Me0L9ieQTo+
         fN8VXOY9nvSUoF713yte4JhbRAIXi2LXpcLPOoQAtQEfb7zYQ5mUp1OP8wxArNmPQW
         ghTed4ZCB7/237HXifLjV8RdbgwCTY/3r8BmUjMlrXnQUa2CitD4g82VJNnRCgqQWk
         BE0htlcRn/fUiiVnIIVbAj+4Ln4UwIMjiTtIrAh0IVJ56sNZMCB12Q9QaK5LCk7s+t
         +Nydu84w+0ouw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 86887C05FD6; Tue,  8 Mar 2022 08:26:05 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Tue, 08 Mar 2022 08:26:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: stefanha@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-gXV1Zq937Z@https.bugzilla.kernel.org/>
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

--- Comment #16 from Stefan Hajnoczi (stefanha@gmail.com) ---
On Tue, 8 Mar 2022 at 08:01, <bugzilla-daemon@kernel.org> wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D199727
>
> --- Comment #15 from Roland Kletzing (devzero@web.de) ---
> yes, i was using cache=3Dnone and io_uring also caused issues.
>
> >aio=3Dthreads avoids softlockups because the preadv(2)/pwritev(2)/fdatas=
ync(2)
> > syscalls run in worker threads that don't take the QEMU global mutex.
> >Therefore vcpu threads can execute even when I/O is stuck in the kernel =
due
> to
> >a lock.
>
> yes, that was a long search/journey to get to this information/params....
>
> regarding io_uring - after proxmox enabled it as default, it was taken ba=
ck
> again after some issues had been reported.
>
> have look at:
> https://github.com/proxmox/qemu-server/blob/master/debian/changelog
>
> maybe it's not ready for primetime yet !?
>
> -- Proxmox Support Team <support@proxmox.com>  Fri, 30 Jul 2021 16:53:44
> +0200
> qemu-server (7.0-11) bullseye; urgency=3Dmedium
> <snip>
>   * lvm: avoid the use of io_uring for now
> <snip>
> -- Proxmox Support Team <support@proxmox.com>  Fri, 23 Jul 2021 11:08:48
> +0200
> qemu-server (7.0-10) bullseye; urgency=3Dmedium
> <snip>
>   * avoid using io_uring for drives backed by LVM and configured for
>   write-back
>     or write-through cache
> <snip>
>  -- Proxmox Support Team <support@proxmox.com>  Mon, 05 Jul 2021 20:49:50
>  +0200
> qemu-server (7.0-6) bullseye; urgency=3Dmedium
> <snip>
>   * For now do not use io_uring for drives backed by Ceph RBD, with KRBD =
and
>     write-back or write-through cache enabled, as in that case some
>     polling/IO
>     may hang in QEMU 6.0.
> <snip>

Changelog messages mention cache=3Dwritethrough and cache=3Dwriteback,
which are both problematic because host memory pressure will interfere
with guest performance. That is probably not an issue with io_uring
per se, just another symptom of using cache=3Dwriteback/writethrough in
cases where it's inappropriate.

If you have trace data showing io_uring_enter(2) hanging with
cache=3Dnone then Jens Axboe and other io_uring developers may be able
to help resolve that.

Stefan

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
