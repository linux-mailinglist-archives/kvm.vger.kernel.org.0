Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E112735C3B
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 18:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjFSQiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 12:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjFSQiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 12:38:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFB58E
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 09:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF01260D33
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 16:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BA9EC433C8
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 16:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687192694;
        bh=VhbgRtp37ASaCm3oPdjqF7PCUjet4V1L8zzuoKOkaNs=;
        h=From:To:Subject:Date:From;
        b=OMFGIyQbda04fy4hCWwmD4vHJcbddMv7JjlHWUNnNErD2W5wQkzDeT3K++LAzhg3A
         QMUjGEEoroXgzWGJn0CDWIHIlw9UYsRaoTuHiZ0QGx48PmHFkGrRI5xYiEKQqQMz/7
         FfNMPIBGqOLzKLQZCj3048qTf6cysylz3V21nMjmkV8ilR7CiOpShE8u6bdjOx2qqD
         BLZjlSi/IQB2V30ufmzu+IdYYutDV0BtCQCJjvrtnU92a8RqhFXlToWHr2Vcphs5Lp
         MhFbKR24QvmL0/D0zk5cHWm4gqm7wn50gscBNXzmE7/lqgGkeFStEYZ0ENUh7l/Y2/
         2vE3kXfsiNFjg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 064C6C53BCD; Mon, 19 Jun 2023 16:38:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217574] New: kvm_intel loads only after suspend
Date:   Mon, 19 Jun 2023 16:38:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: drigoslkx@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-217574-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217574

            Bug ID: 217574
           Summary: kvm_intel loads only after suspend
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: blocking
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: drigoslkx@gmail.com
        Regression: No

Hi, I tested this bug on Slackware 5.15.29, 5.15.97 and 6.1
I tested too on ubuntu 23.04, Fedora 38 and Linux Mint 21.01 and got the sa=
me
results.

When I boot Linux, it shows the error
kvm: CPU 0 feature inconsistency!
(Depending on the kernel version it throws this message for each cpu core)

The kernel loads the kvm module but not kvm_intel.
(Without kvm_intel kvm doens't work).
If I try a manual load, doing modprobe kvm_intel it shows
modprobe: ERROR: could not insert 'kvm_intel': Input/output error

So I take some time break, when I back, the system was suspended, I turned =
it
on again, and tried to load modprobe kvm_intel, it works, and kvm got worki=
ng
now.

Tested this in all other distros described above and got the same results.
I only get kvm works after a suspend.

My specs
Motherboard Jingsha x99
CPU Intel(R) Xeon(R) CPU E5-2696 v3 @ 2.30GHz

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
