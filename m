Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFC270CD9A
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 00:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjEVWPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 18:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjEVWPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 18:15:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41ACAF
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:14:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BD9562C37
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 22:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADD39C4339E
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 22:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684793698;
        bh=tZ7x3hkdegMcW19usARVxz1KndnNS6jW5XBdAyeWggw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iwr0K8YqqDbxCwLvCXk6fbhe7mSfIYPrQp1Rugmk6TLEnWNHf0CxjFzOTUabkIGVq
         avHyvE1KyawzYze90gqxSvoOwu/iwKKP0Z4gxUAsD7mhllW09FKxa8wzt6f0KAaoun
         O3ngu5wlXeyPmNlHB2lKdiRgAtehNM/4aWdZDM7X8yJOWVtvb3mDep5iqt3SR7+e59
         2IDr2h2GqdpO+ScyjMJn/by/lRl/AbEZ8NyHFT5CZyq645njsdsZ/y4wyXK/6qZm5G
         2xDl9PTjyhTpM+wX3D9vOsDxTN9Rtuf6jYp3GLUlVfsjzMuwvyV7bmK52p4fY8/Sec
         gk3NSsBTpXJlQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 941E9C43141; Mon, 22 May 2023 22:14:58 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Mon, 22 May 2023 22:14:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217307-28872-vU3HGubX7G@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217307-28872@https.bugzilla.kernel.org/>
References: <bug-217307-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217307

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #4 from Sean Christopherson (seanjc@google.com) ---
There isn't much to go on in the trace.  The guest is "voluntarily" rebooti=
ng
by writing I/O port 0xcf9, e.g. it's not a triple fault shutdown due to KVM
injecting an exception that the guest doesn't expect.

My best (but nearly blind) guess would be that Windows expects functionalit=
y to
exist, e.g. is querying CPUID and MSRs to enumerate platform features, and =
goes
into recovery mode when the expected feature(s) aren't found.  But that's v=
ery
much a wild guess.=20
 Unfortunately, trace_kvm_exit doesn't provide guest GPRs, so it's impossib=
le
to glean information from the CPUID, RDMSR, and WRMSR exits, e.g. to see wh=
at
Windows appears to be doing.

The easiest way to debug this probably to get the guest into a debugger, ev=
en a
rudimentary one like QEMU's interactive monitor.  That would hopefully prov=
ide
some insight into why Windows decides to reboot.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
