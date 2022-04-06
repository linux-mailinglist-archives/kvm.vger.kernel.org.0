Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1755A4F6ED9
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 01:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbiDFXy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 19:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiDFXyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 19:54:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB308B8985
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 16:52:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 075DA61D5F
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 23:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 630F3C385AC
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 23:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649289146;
        bh=khWGNGOtDxJKNTLQT6ZcquCIiz4nqFQcYjHz85RBvI0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JVRV0VM4MrDrWh9xMwjzUAQT6xnFACLmpaA/A32qeEC3qXCi1afIVGWm2J4mWocmr
         a3gCwcMEtV4VWEbae2fS1gBBEe+646Yzv+BVubqQPQnHI0h5QaaJS1zyuTdWF5H13o
         8mJ8DXWrc4x7kb6xoxIGdpQISe39enV5/PipRspAq3uIS37y2ZPxHf4+UMEYw2bVUA
         Q6V6bX/I3P4FPOzbq5jBuhT+FF6tJVN5DlQeCW8AJCr7pPMYFJnlbGHtGSzS85TjfB
         fD0B8eh5dHrVa1nv2HTQnBoo3dqeLGPSOL6sKrMLxMGDlmzJWETgGmomTyjYtxX3Xs
         /f40Bz9iQVUZg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4F8FCCAC6E2; Wed,  6 Apr 2022 23:52:26 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Wed, 06 Apr 2022 23:52:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: gkovacs@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-0XZsKfXy6C@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #18 from Gergely Kovacs (gkovacs@gmail.com) ---
Thank you Roland Kletzing for your exhaustive investigation and Stefan Hajn=
oczi
for your insightful comments. This is a problem that has been affecting us =
(and
many many users of Proxmox and likely vanilla KVM) for more than a decade, =
yet
the Proxmox developers were unable to solve it or even reproduce it (despite
the large number of forum threads and bugs filed), hence the reason for me
creating this bugreport 4 years ago.

It looks like we are closing in: the KVM global mutex could be the real
culprit, as in our case the problems were only mostly gone by moving all ou=
r VM
storage to NVMe (increasing IO bandwidth by a LOT), but fully gone after
setting VirtIO SCSI Single / iothread=3D1 / aio=3Dthreads on all our KVM gu=
ests.
For many years VM migrations or restores could render other VMs on the same
host practically unusable for the duration of the heavy IO, now these
operations can be safely done.

I will experiment with io_uring in the near future and report back my findi=
ngs,
will leave the status NEW since I reckon attention should be given to the r=
ing
io code to achieve the same stability as threaded io.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
