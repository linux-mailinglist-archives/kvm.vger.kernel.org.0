Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4581467E610
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 14:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbjA0NGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 08:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjA0NGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 08:06:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5A47CCA3
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 05:06:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B67F8B82102
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64F83C4339C
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674824773;
        bh=SIoGaS3jrUmp16Jdwo1+SIexcHJwz5xp+8oLxQS98oM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OnIuaFtSiY08qhhe79n5uh5GAK3dPCaQLCkHAFSeZiIHBrXn25/9q0bUzVNKHAq5D
         ATqg0MJBEN/mp2dKHEGQSD6Jv64UMREEpLSgq22M9a82AJsIE71plIBN93ZpY153Xq
         lzQcn3pvnBCD8GnuyB8/G0Fmz6jpsSlvO7K2UWRFFAN5QYIvcUolzsNmJmmyPZNmHQ
         XJ9KSJLkA89wUTLGkfEOpeemvmDNDwAFxvTF1i4N+zwgEy5RTCa+sXmes5GaUVx+Ng
         btUb9pmlZLp1DcZlzKhCv8Wmns1PXk7huBHw5yAsvrMC0U2XT97Ma7G20wZu9HAdDr
         Aa7Ki7MRVMmAw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4462EC43144; Fri, 27 Jan 2023 13:06:13 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 204293] When destroying guests, hypervisor freezes for some
 seconds and get BUG: soft lockup - CPU* stuck for Xs
Date:   Fri, 27 Jan 2023 13:06:12 +0000
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
Message-ID: <bug-204293-28872-EM1D7nNips@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204293-28872@https.bugzilla.kernel.org/>
References: <bug-204293-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D204293

Roland Kletzing (devzero@web.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |devzero@web.de

--- Comment #1 from Roland Kletzing (devzero@web.de) ---
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
