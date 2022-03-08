Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A554D101E
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 07:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344470AbiCHGVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 01:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344505AbiCHGVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 01:21:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCC43CA5A
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 22:20:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CB4BB817B3
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 06:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 527B4C340FA
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 06:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646720446;
        bh=39cY+lv1ZzNQSbo3dE5ra/AZNAElz6LPcKd5HatsAP0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=lqaL1pp+MbEenJ4lYNhkHFujMaOEDxgxrIBlxEGW8Bok6fBb0KmIwAs6uRrZMhJu2
         v5fr4SGMlHdUlahfps49fndmz1vG0EXeZd9jXkOAuR03/HQ2vQTyoxJLcMay1w+ES6
         g8mb0bO9pqwZ90izwO1/Ie1tH4AGyli6WUgufHwW0rwlLKdZjjx9aZOKHF7WvvgdEC
         SfaIs3X0xJDiPK9PQCd45TZmoOsso4munOTNHLITtTHKlWn5Kr920DTQswbkVvFfo5
         pS5Fp1W/ORB3AUnjm4NTUTZcPOVWzMEJumUdN9HOXy2VRhjWbmujdkcOeFOxMNtuHJ
         iFW8PvGZW0u1A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2EFD3C05F98; Tue,  8 Mar 2022 06:20:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Tue, 08 Mar 2022 06:20:44 +0000
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
Message-ID: <bug-199727-28872-6hEwyT8rUz@https.bugzilla.kernel.org/>
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

--- Comment #14 from Stefan Hajnoczi (stefanha@gmail.com) ---
(In reply to Roland Kletzing from comment #13)
> hello, thanks - aio=3Dio_uring is no better, the only real way to get to a
> stable system is virtio-scsi-single/iothreads=3D1/aio=3Dthreads
>=20
> the question is why aio=3Dnative and io_uring has issues and threads has =
not...

Are you using cache=3Dnone with io_uring and the io_uring_enter(2) syscall =
is
blocking for a long period of time?

aio=3Dthreads avoids softlockups because the preadv(2)/pwritev(2)/fdatasync=
(2)
syscalls run in worker threads that don't take the QEMU global mutex. There=
fore
vcpu threads can execute even when I/O is stuck in the kernel due to a lock.

io_uring should avoid that problem too because it is supposed to submit I/O
truly asynchronously.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
