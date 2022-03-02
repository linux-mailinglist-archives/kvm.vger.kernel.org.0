Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CD84CA616
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 14:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242255AbiCBNec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 08:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240656AbiCBNeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 08:34:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4574C5D5E6
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 05:33:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2B1BB81F1B
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 13:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9AB5C340F4
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 13:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646228025;
        bh=t4FFf16vq/qHGgAxTeFAj5ycJuoVKQXacxJzBiYbock=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=b/Xp4Z4+T9cKvsNXbHEsshxR2sJtuaQwiySHo4DZ92WohQc/RgeCgM08DdmxuYNSG
         ajwGEUSblXPdLKY1HqOm+pn4o0GySHExO1T10QAgQSvlOjVCeBHgd1wpXiFIH+7aZ7
         Gbbv9GJUkDEu4cn/9lIcH+XsdxXSTts3qoRNlE0ph7D4kMSKss1PGKp1TuwPueS0nc
         GtfN92PUu0wuEIqC5laA0eulhFyLy7su3hEDHwZztAcwzW4RYSHDj2XXSEhlGsL7fR
         h31HjDibBgvNMIStjM263fX2URG+5pcLJuSfZSpGyEMLOiui0ACZZmDtXJyDOeRUgK
         IjG/ByWe9Gm3A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A7BC7C05FF5; Wed,  2 Mar 2022 13:33:45 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Wed, 02 Mar 2022 13:33:45 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-199727-28872-Gxzfvt3L4z@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

Stefan Hajnoczi (stefanha@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |stefanha@gmail.com

--- Comment #12 from Stefan Hajnoczi (stefanha@gmail.com) ---
Hi,
I contribute to QEMU and have encountered similar issues in the past. QEMU
configuration options that should allow you to avoid this issue and it soun=
ds
like you have found options that work for you.

If io_submit(2) is blocking with aio=3Dnative, try aio=3Dio_uring. If that =
is not
available (older kernels), use aio=3Dthreads to work around this particular
problem.

I recommend cache=3Dnone. Although cache=3Dwriteback can shift the problem =
around
it doesn't solve it and leaves the VMs open to unpredictable performance
(including I/O stalls like this) due to host memory pressure and host page
cache I/O.

Regarding the original bug report, it's a limitation of that particular QEMU
configuration. I don't think anything will be done about it in the Linux
kernel. Maybe Proxmox can adjust the QEMU configuration to avoid it.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
