Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000F76F6A62
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 13:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjEDLuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 07:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjEDLuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 07:50:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF121994
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 04:49:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6205B612BC
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 11:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5154C4339C
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 11:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683200998;
        bh=T1lPGCb9cUcG0qL2ThryvV77gSg6Wd+sbgjjpzxS3PU=;
        h=From:To:Subject:Date:From;
        b=TMHlxPiVskv6GwO1cyB8EPmGtCwnCsDa6I0J0WVynVFHz9Rp2ycZG/vHsZEDt6ls0
         sfCav/N0/pfVQWrbWGoe7xqpYZdNnKOGqlh1B8P2LiwADUKs079SQR8T+QIRHRTD6v
         pSBkBaAVY5MkZI0atlR0BsrYFdHgIzDJhR3LfZsGfYRwqAUvnwDrnl79fNM5aIr3Kn
         e1radAFtiSw4zpcqjRtQtIbyeLdfQwzgW7T9flyndAOkBh/R1AJfG7gZk6jGe3+8z3
         Z1G62Lvc9Gu9TGB7E1SnBiKq5byM1x/u5sVH/1RKLc/Hj7y+8FD9RA8WEDqLjzxHuu
         N9W3wTy09fwKA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B1ACEC43144; Thu,  4 May 2023 11:49:58 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217400] New: Bugged RMRR prevents PCIe Passthrough of KVM VMs
 on certain platforms
Date:   Thu, 04 May 2023 11:49:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: bugtracker@fischbytes.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-217400-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217400

            Bug ID: 217400
           Summary: Bugged RMRR prevents PCIe Passthrough of KVM VMs on
                    certain platforms
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: bugtracker@fischbytes.de
        Regression: No

Certain vendors that are under the assumption that standards are for jerks =
and
Intel's specifications are a loose optional guideline have implemented RMRR=
 in
such a way that every PCI device is marked as reserved and therefore cannot=
 be
passed through to a virtual machine. This issue has been very well document=
ed
by some people that have a lot more experience than I do at the below linked
resource. I was hoping that the upstream Linux kernel could implement the
Relaxed RMRR option, enabled by a kernel parameter at boot time, on these
bugged platforms as that would re-enable or rather enable a lot of broken
servers for the first time ever to use PCIe Passthrough. I can verify the i=
ssue
exists on a HPE DL360e Gen8 with trying to passthrough a GPU to a KVM/QEMU
machine. This bug is very much hardware specific, but seems to only exist on
Linux systems as they try to honor the Intel specifications as much as
possible, it was reported that other systems (e.g. VMWare ESXi) do not have
this issue as they ignore RMRR out-of-the-box.=20

https://github.com/Aterfax/relax-intel-rmrr

I can confirm the patched Proxmox-Kernel works fine on an HPE DL360e Gen8. =
The
same bug was also reported to the openSUSE maintainers, they suggested to
report it here instead.

https://bugzilla.opensuse.org/show_bug.cgi?id=3D1211069

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
