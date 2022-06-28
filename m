Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B7655C681
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243734AbiF1Ejh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 00:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbiF1Ejf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 00:39:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C51E15A37
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 21:39:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE88161714
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 04:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A662C341C6
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 04:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656391174;
        bh=vEJu1oZwuKkP4sBnKGantwQbdbmdKuEM9kvKcvXORIo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=J8zsUFEJfijGpRX/0D1LiQGo5k7B50T3C6ssw64umd/e5BV2IQMk0u8yyZjPr+dIL
         SvKWl+R7EkyB2Rik1nssxpVc46YfGzNVyFF4LIWxKcFvNFiyfEgHs4j21PVJm/06AH
         dXU+YAQJNTSo+h9AJ7QtzLC8l6q/tbTNSFfv1EpCxfyGc38HtWTKUXqkQ4IGxYHeRc
         hWFCbc+xAh4UvTMfqzQp/uwM6qZxFHip3qD9xrpJ3y4HfOUjWk3plsIZlV1JVfBb0y
         xYLDsoN2cr5zNeSbvdvkQrSDySxtYdX09oca7/6NmipAkcGeEAL0XekHVDULnzSOfB
         cheUytwbswwEA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1B654CC13B5; Tue, 28 Jun 2022 04:39:34 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216177] kvm-unit-tests vmx has about 60% of failure chance
Date:   Tue, 28 Jun 2022 04:39:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jmattson@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216177-28872-K60n1GdV2D@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216177-28872@https.bugzilla.kernel.org/>
References: <bug-216177-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216177

--- Comment #8 from Jim Mattson (jmattson@google.com) ---
On Mon, Jun 27, 2022 at 8:54 PM Nadav Amit <nadav.amit@gmail.com> wrote:

> The failure on bare-metal that I experienced hints that this is either a =
test
> bug or (much less likely) a hardware bug. But I do not think it is likely=
 to
> be
> a KVM bug.

KVM does not use the VMX-preemption timer to virtualize L1's
VMX-preemption timer (and that is why KVM is broken). The KVM bug was
introduced with commit f4124500c2c1 ("KVM: nVMX: Fully emulate
preemption timer"), which uses an L0 CLOCK_MONOTONIC hrtimer to
emulate L1's VMX-preemption timer. There are many reasons that this
cannot possibly work, not the least of which is that the
CLOCK_MONOTONIC timer is subject to time slew.

Currently, KVM reserves L0's VMX-preemption timer for emulating L1's
APIC timer. Better would be to determine whether L1's APIC timer or
L1's VMX-preemption timer is scheduled to fire first, and use L0's
VMX-preemption timer to trigger a VM-exit on the nearest alarm.
Alternatively, as Sean noted, one could perhaps arrange for the
hrtimer to fire early enough that it won't fire late, but I don't
really think that's a viable solution.

I can't explain the bare-metal failures, but I will note that the test
assumes the default treatment of SMIs and SMM. The test will likely
fail with the dual-monitor treatment of SMIs and SMM. Aside from the
older CPUs with broken VMX-preemption timers, I don't know of any
relevant errata.

Of course, it is possible that the test itself is buggy. For the
person who reported bare-metal failures on Ice Lake and Cooper Lake,
how long was the test in VMX non-root mode past the VMX-preemption
timer deadline?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
