Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBDA6D9447
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 12:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237297AbjDFKja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 06:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjDFKj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 06:39:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B74B55A6
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 03:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE392644D1
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 10:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24B7FC4339B
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 10:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680777568;
        bh=uHnQvHgWzzdn6DqUeocqA19gUpXxxY/48R9u5KRWOBs=;
        h=From:To:Subject:Date:From;
        b=n++6bI8GskZrek9dqYy+RsZE81xir7zNjSe3NhXM6G+xko4twmIU0P5MejfjifG4o
         3BT0y9uHxSUgtoC+DeE8SPv0zgSDf9rfoTsLIBEtGb85MGNRZdo6FDdlA+UTPV2jm1
         IHCWdOBRf15lLE9/2vj+UV7fbMzF8BtZVCuuaj42Oi3h4yTHfQ1Q1imrmHOujc2ciA
         Sav7qzE2GuLTNqqf/9CJlb5HHX0vqGIQFqUL72AnRzrj01BarrGoBXskQOUmJQYFXw
         6+gOspdNrESawc7yCL3MN+nlzznQvHDIinPC7GfdhJtnxzu8oJsFdCG0vZDvbOxkF+
         LFsgk79ZLej2w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0EAD4C43144; Thu,  6 Apr 2023 10:39:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] New: windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Thu, 06 Apr 2023 10:39:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: webczat@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-217307-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217307

            Bug ID: 217307
           Summary: windows guest entering boot loop when nested
                    virtualization enabled and hyperv installed
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: webczat@outlook.com
        Regression: No

Environment:
My host is fedora 37, currently running linux 6.2.5, but this is present fo=
r a
long time.
CPU is intel alderlake, core i7 12700h.
The os has kvm_intel module loaded with nested=3Dy parameter, so nested
virtualization is enabled.
The guest vm is a q35 x86_64 vm with cpu=3Dhost set, running on qemu version
7.0.0, accel=3Dkvm, smm, uefi, secureboot and tpm enabled.
Command line for qemu is attached to the bug.
VM is running a windows 11 pro 64 bit os.

What happens is that the moment I install any HyperV features on the window=
s11
os and then reboot, it does not boot again.
Basically it self reboots once and goes into recovery. Because I am blind I
cannot really say whether it shows some blue screen of death before rebooti=
ng,
but I actually don't think so.
The only thing i can do to make it work is to disable nested virtualization.
There is no known workaround which leaves it enabled, unless i disable the =
vmx
cpu feature, but that's not what I want to achieve, my goal is mostly to
run/test wsl2 or to play with docker.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
