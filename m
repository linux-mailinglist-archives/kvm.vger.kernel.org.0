Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC486592992
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 08:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiHOGZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 02:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiHOGZa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 02:25:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A749910AE
        for <kvm@vger.kernel.org>; Sun, 14 Aug 2022 23:25:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63A2FB80D1E
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 06:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 230BDC433C1
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 06:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660544726;
        bh=q9wAkh0SgtR4zqFtfsRlk31cOvS3rIYi4LzGEYXvUpU=;
        h=From:To:Subject:Date:From;
        b=eXCH4avVOOxqc3EJ9iAM9PFBZrD2kAQs4g0TY1Rh/sXdWkMnq4JAffw5/XmIB5JMe
         yVme8Gt+3jvse3AU9h6lfxnAqdLOfE9kV4yioACBmT9/neDg44Jkt5dwLhI4n1u+4C
         1GfQa2GWX+sGpKXIE3VE4VzTcKdSNdRzCVg6WU3N2hCFE3H8/jVML/9o4Cv4KQ8UzC
         yPFwjiy0A5mli0CjuUo61jaNHkV2aymR/IB/e6E6OyOHdYHYbnhJq2jgf62IpIfffZ
         YnonxsLg5GBDSvrBNalK+e3s3EftrmFB32LXkbxd47vaKKMtcU4P7t3Jkd2tpMLZKW
         3P0MR76reRQzg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0AEF4C433E9; Mon, 15 Aug 2022 06:25:26 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216364] New: [Kernel IBT][kvm] There was "Missing ENDBR" in kvm
 when syzkaller tests
Date:   Mon, 15 Aug 2022 06:25:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: pengfei.xu@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216364-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216364

            Bug ID: 216364
           Summary: [Kernel IBT][kvm] There was "Missing ENDBR" in kvm
                    when syzkaller tests
           Product: Virtualization
           Version: unspecified
    Kernel Version: v5.19 mainline kernel
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: pengfei.xu@intel.com
        Regression: No

Created attachment 301563
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301563&action=3Dedit
Host_kernel_missing_endbr_from_kvm

I used syzkaller and found the "Missing ENDBR: andw_ax_dx+0x0/0x10 [kvm]" B=
UG
in the host.

Platform: ADL-P/TGL-U or TGL-H

Host Kernel:   v5.19 mainline kernel with kernel IBT
Guest kernel: v5.19 mainline kernel without kernel IBT, moved kconfig
"CONFIG_X86_KERNEL_IBT=3Dy".

Host kernel enabled kernel IBT by adding the KCONFIG "CONFIG_X86_KERNEL_IBT=
=3Dy".

In syzkaller guest kernel, guest didn't enable kernel IBT and used 5.19
mainline kernel also.

After launched the syzkaller test about 2 hours.

There was  "Missing ENDBR: andw_ax_dx+0x0/0x10 [kvm]" info generated in host
kernel.

[    0.000000] Linux version 5.19.0-m2 (root@xpf.sh.intel.com) (gcc (GCC) 8=
.5.0
20210514 (Red Hat 8.5.0-10), GNU ld version 2.36.1-2.el8) #1 SMP
PREEMPT_DYNAMIC Mon Aug 1 14:23:55 CST 2022
[ 5048.057266] traps: Missing ENDBR: andw_ax_dx+0x0/0x10 [kvm]
[ 5048.057440] ------------[ cut here ]------------
[ 5048.057457] kernel BUG at arch/x86/kernel/traps.c:253!

Host dmesg was in attached.


Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
