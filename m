Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3533A7405BA
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 23:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjF0VhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 17:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjF0VhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 17:37:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A75F26A5
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 14:37:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBA9161237
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 21:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3890DC433CC
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 21:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687901824;
        bh=8UvPLKgA1stNcv2vou8XGhvVwWfOFEzp3Y6LWkODwuY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=CNGiccfxK0PnCp03txljL9e2/p7cTsil/BcyxxkcRFICpW03P2U/oxFwkjhgOlws6
         NxZ/pMTmVZ5dCLJpxUyETugxWDfz9R5kwaeGJJseGXvLOmgGGbS8r4b9G0NCp2LPrm
         tjki9n5K1e3fB6Tw13+kjnr+6DPLtGzN0Oc/Bv0Ync+nf4GWU4x2R2tBT5zyEdtySg
         WT/r0Kw4x7w8/20f8t/LF9ptC3YS0eTErJwQS1qEVFD2m+FwPyJecdIX0Zk1RDv1V5
         D7AlJLenqSAQb8pHIuK700T9ACObu4MvDORiVhKG7UneZODn0rFKi9z61agce2s/Dt
         L8WOfRDBXbiXg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1B6EDC53BC6; Tue, 27 Jun 2023 21:37:04 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Tue, 27 Jun 2023 21:37:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217307-28872-AaEYA8tg77@https.bugzilla.kernel.org/>
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

--- Comment #10 from Micha=C5=82 Zegan (webczat@outlook.com) ---
Okay, i have done more tests.
So generally host-passthrough does not work, broadwell-notsx-ibrs,
skylake-notsx-ibrs and also nehalem do not work, kvm64 doesn't work, qemu64
works.
However, qemu64, even when I enable vmx and disable svm, boots without hype=
rv.
Windows shows that second level adress translation  is disabled.

I tried to use libvirt's xml files and even qemu sources to see difference
between qemu64 and broadwell-notsx-ibrs features, then enabled them all, the
effect is exactly the same. I mean cpuid features.

For these tests, everything like devices, secureboot, tpm, hyperv
enlightenments, were enabled.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
