Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C67520B74
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 04:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbiEJCt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 22:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiEJCt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 22:49:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F6227F135
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 19:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81A5BB81A5E
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 02:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27513C385C5
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 02:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652150728;
        bh=f4ggrq2x/I5JJDUQ8U7pqFO583dm/VaY1s3QnkAulXw=;
        h=From:To:Subject:Date:From;
        b=GYK6Hoe0Zcdzzcg90gAT0b5uxBEe1tMdvbavERjZCS3nUmwFSBSqVHgcqYBPAeFQr
         w07YVWymIGxY9MWfX4beKXEfyNexb4gZfDgiZZnzcdzUUdbkeHmxd4l5MA25VlofUo
         5PNk6K09G8O5kjQqIoeIgFQfAHkL51adO5ZeeOqTlmEWQ/huUmnxJG/NEfPOUmb3In
         z3KQc9m5TGvBT4GhqVe4mby6UxGjJcLaf0WsFQEjbPVFKLiZEKGuQG3Mmp/qNVw9Mr
         PLyj38jdqUUoiw9kZ24TaW+qUzfTJK2ghPHj4YfcFFDFrrserHqK5tdLsLtC7qEIlw
         kZiNeUHwlbKXA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 06F3DCC13B0; Tue, 10 May 2022 02:45:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215964] New: nVMX: KVM(L0) does not perform a platform reboot
 when guest(L2) trigger a reboot event through IO-Port-0xCF9
Date:   Tue, 10 May 2022 02:45:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: yadong.qi@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-215964-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215964

            Bug ID: 215964
           Summary: nVMX: KVM(L0) does not perform a platform reboot when
                    guest(L2) trigger a reboot event through IO-Port-0xCF9
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.10+
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: yadong.qi@intel.com
        Regression: No

Background:
  We have a lightweight Hypervisor(iKGT) which aims to monitor very limited
resources and passthrough most resources to its guest. The IO-Port:0x3F9 is
also passthrough to its guest, so when guest tries to trigger a reboot
event(through IO-port:0x3F9), the hardware will do the platform reset direc=
tly.
  We ported it to running under KVM, then it becomes nested virtualization
architecture: KVM(L0), iKGT(L1), Guest(L2).=20


Reproduce Steps:
  Guest(L2) write 0xCF9 to trigger a platform reboot.

Expected result:
  KVM perform a virtual platform reset and reboot guest.

Current result:
  It seems KVM only reset part of the vCPU(L2), but it does not clear the n=
VMX
state, it still tries to emulate VMExit to iKGT(L1). We still can observe
VMExit from iKGT(L1) and the exit reason is not expected.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
