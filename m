Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E98867E622
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 14:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbjA0NJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 08:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbjA0NJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 08:09:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E6A7F688
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 05:08:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C8F561C2C
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71F5CC433D2
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674824856;
        bh=7WzKig9+FvNxSSCq9OzWUj/JmDoVDn12xHMXzIlWu3Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=k6qvw6Gi+NssFLS0HU9SfCCKRdmZ+27fFC+e77utqqm0/7vn3Od4jiJ3kku0+DGie
         kQRe1rUDcxoJ3PpneEn/O4UqbxayLrHEFajVXdejD0fH9C6edMDziO3GCfMP7ugfoe
         eOZ+P47tm2Bv0bIyk03mZ1h68rJloAkrLCAwRChGzhf2ttDpPexNOjN2ZLaE7xRp7f
         rY7Gqs5glQVVM1gwKBd4J2YQXtSw234Gh3dRUrG3/1EPFWHqIdhjo4pmZd0HIM98qj
         So2PLzZJI+WqbpbmCquyLHEbkd7vQ/j+Je8MbUQVS9PjfNE4KLqXevedwygxyW4iSq
         LAoq0bpaBCFNg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 610D2C43141; Fri, 27 Jan 2023 13:07:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 75331] "soft lockup CPU#0 stuck for 23s" regression on 32bit
 3.13.0+ kernels.
Date:   Fri, 27 Jan 2023 13:07:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: devzero@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-75331-28872-60iatlljj1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-75331-28872@https.bugzilla.kernel.org/>
References: <bug-75331-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D75331

Roland Kletzing (devzero@web.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |devzero@web.de

--- Comment #2 from Roland Kletzing (devzero@web.de) ---
this may be caused by intense IO on the host if your VM is not using virtio
dataplance.

i have seen such when copying data or live migrating virtual machines

have a look at=20
https://bugzilla.kernel.org/show_bug.cgi?id=3D199727 and
https://gitlab.com/qemu-project/qemu/-/issues/819

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
