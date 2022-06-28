Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2773555D7D2
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245437AbiF1GMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 02:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245135AbiF1GMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 02:12:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8722B2610A
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 23:12:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25AED61762
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 06:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82A31C341CC
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 06:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656396719;
        bh=KzaVj/7ZKXJWjbCX+0ipAinB3nK9DGr0cYFr2kmgqsU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pFezKz2z2IlSwEkdBIeT5S2eGeOW50cfBD+iM4xH3bmow3MGxRen0JLpCtaCwBCgs
         zoRKcddlsPL+SnLaDE4/Ayf+ZLUFCkXXe+y44ZZC4keSyjRR8hQORbegKgZIcrEq1x
         9ZjF+FwdsC+PuHN7Aia14d5esilARXIfr0dDsYmVFmJ024VdM9kfp6q0NzINH6YuFr
         BttFIZZyM7EeCes5Avsd4qad/f8GQZ2yG7F2lQlFnQjcmSHxsfsMfTUgwzg1Li8XnQ
         YLMeTGpuBTD75k8Ia6306qsHpAHA+rf6ME0dwAmwXGKLLqi0E9idnhlTH5KrYtNYQy
         /8NQG6YbzNO0Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 68308CC13B2; Tue, 28 Jun 2022 06:11:59 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216177] kvm-unit-tests vmx has about 60% of failure chance
Date:   Tue, 28 Jun 2022 06:11:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixiao.yang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216177-28872-0chfaxaqsi@https.bugzilla.kernel.org/>
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

--- Comment #9 from Yang Lixiao (lixiao.yang@intel.com) ---
(In reply to Jim Mattson from comment #8)
> On Mon, Jun 27, 2022 at 8:54 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
> > The failure on bare-metal that I experienced hints that this is either a
> test
> > bug or (much less likely) a hardware bug. But I do not think it is like=
ly
> to
> > be
> > a KVM bug.
>=20
> KVM does not use the VMX-preemption timer to virtualize L1's
> VMX-preemption timer (and that is why KVM is broken). The KVM bug was
> introduced with commit f4124500c2c1 ("KVM: nVMX: Fully emulate
> preemption timer"), which uses an L0 CLOCK_MONOTONIC hrtimer to
> emulate L1's VMX-preemption timer. There are many reasons that this
> cannot possibly work, not the least of which is that the
> CLOCK_MONOTONIC timer is subject to time slew.
>=20
> Currently, KVM reserves L0's VMX-preemption timer for emulating L1's
> APIC timer. Better would be to determine whether L1's APIC timer or
> L1's VMX-preemption timer is scheduled to fire first, and use L0's
> VMX-preemption timer to trigger a VM-exit on the nearest alarm.
> Alternatively, as Sean noted, one could perhaps arrange for the
> hrtimer to fire early enough that it won't fire late, but I don't
> really think that's a viable solution.
>=20
> I can't explain the bare-metal failures, but I will note that the test
> assumes the default treatment of SMIs and SMM. The test will likely
> fail with the dual-monitor treatment of SMIs and SMM. Aside from the
> older CPUs with broken VMX-preemption timers, I don't know of any
> relevant errata.
>=20
> Of course, it is possible that the test itself is buggy. For the
> person who reported bare-metal failures on Ice Lake and Cooper Lake,
> how long was the test in VMX non-root mode past the VMX-preemption
> timer deadline?

On the first Ice lake:
Test suite: vmx_preemption_timer_expiry_test
FAIL: Last stored guest TSC (28067103426) < TSC deadline (28067086048)

On the second Ice lake:
Test suite: vmx_preemption_timer_expiry_test
FAIL: Last stored guest TSC (27014488614) < TSC deadline (27014469152)

On Cooper lake:
Test suite: vmx_preemption_timer_expiry_test
FAIL: Last stored guest TSC (29030585690) < TSC deadline (29030565024)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
