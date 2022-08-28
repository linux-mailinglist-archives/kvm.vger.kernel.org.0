Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448F65A3FD6
	for <lists+kvm@lfdr.de>; Sun, 28 Aug 2022 23:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiH1VJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 17:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiH1VI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 17:08:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4A631DF6
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 14:08:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF8DEB80C76
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 21:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C956C433C1
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 21:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661720933;
        bh=1uHYzSoZVm6C9fVvJ7XSBzlotoGT43QZR48ylGsSXIQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=px7fXxqmD/pjoIUJ5b4z6rMhGLRkLfKqUQdbkLJaYBmVUguneoyklQ7ZNrBZPIJmn
         m1sdvz+wathu8mygvQxxQye+B+5nhYfyP9lR0E6j3+0l81kTCCQ5Cal6YjNOOEXF57
         ixHbDZqhEZtChtWe8mBrPihAs/VCYTj/cLK4jOPAOSC9HuldWg9l4R2I02lbfVkRnU
         iQoEab6MCcLxX59JIcHJDpzkvtN4uQhtfsjLnhTpQkgaOCL24mSpVV/SGIlNqi2bew
         bYCQaQf99GupVL4pe1i7m6ZPNB1Tba4qm8YH1g+555CyvT7eU19QelZZ0/sCZCwW7P
         pMlE11pgPwOiA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 566DEC433E9; Sun, 28 Aug 2022 21:08:53 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Sun, 28 Aug 2022 21:08:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216388-28872-pJkc0r710c@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216388-28872@https.bugzilla.kernel.org/>
References: <bug-216388-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216388

--- Comment #5 from Robert Dinse (nanook@eskimo.com) ---
Here is another example:

[98519.357381] Task dump for CPU 10:
[98519.357382] task:Embedded solr q state:R  running task     stack:    0
pid:607931 ppid:     1 flags:0x00000000
[98519.357389] Call Trace:
[98519.357393]  <TASK>
[98519.357399]  ? kvm_clock_get_cycles+0x11/0x20
[98519.357408]  ? ktime_get+0x46/0xc0
[98519.357411]  ? lapic_next_deadline+0x2c/0x40
[98519.357414]  ? clockevents_program_event+0xae/0x130
[98519.357418]  ? tick_program_event+0x43/0x90
[98519.357420]  ? hrtimer_interrupt+0x11f/0x220
[98519.357423]  ? exit_to_user_mode_prepare+0x41/0x1e0
[98519.357427]  ? irqentry_exit_to_user_mode+0x9/0x30
[98519.357430]  ? irqentry_exit+0x1d/0x30
[98519.357432]  ? sysvec_apic_timer_interrupt+0x4b/0xa0
[98519.357436]  ? asm_sysvec_apic_timer_interrupt+0x1b/0x20
[98519.357442]  </TASK>

As you can see these are happening all over hell and back.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
