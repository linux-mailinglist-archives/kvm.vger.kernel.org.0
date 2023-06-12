Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFA772BC48
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 11:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbjFLJ13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 05:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbjFLJ0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 05:26:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A0944BF
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 02:20:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 740DD62213
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 09:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFD10C433A1
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 09:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686561649;
        bh=x7de2ZpiSKgA4tP8O5k33PZnKEGlRntOSZucHv/Nlm4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JXDHtDLI7kYfItW73khtB4VAFBd/P5a3qhP8pCQzaTUXTHHnjg1HqLWonSeYzZ+wH
         gg/VIkoZF2dkgf8te21kqcb8IrZi9Skymxw1S8PSEHayTYwqHIXSITFJPgs+YGVM/+
         ReiNSmTN3syeYqAZ4QFTU2jF3UmV43eJnhrlDGdGWFuZ5BFGkQEA/L0CUhdFuAZhfo
         Mi4XqS1bU3D4n5s90BHNxGPLjbEYQsM0jnUUwwN42RRRtFb9O1z9S/XQdmQuXEI9z/
         eVBFXcqWBWyWm6T/Zjz1f+hXewVEzZT8wxokyIJ5qnfCNjTAEmBPHB5R70tjBf5dbS
         asTQeGFdxu53Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BF2A1C43142; Mon, 12 Jun 2023 09:20:49 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217516] FAIL: TSC reference precision test when do hyperv_clock
 test of kvm unit test
Date:   Mon, 12 Jun 2023 09:20:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: vkuznets@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217516-28872-g4Gl1Tzcr6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217516-28872@https.bugzilla.kernel.org/>
References: <bug-217516-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217516

vkuznets@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bonzini@gnu.org,
                   |                            |vkuznets@redhat.com

--- Comment #4 from vkuznets@redhat.com ---
It seems this is just an unstable test. It merges the divergence between MSR
based clock and TSC page over one second and then expects delta to stay wit=
hin
the measured range over another two seconds. This works well for a complete=
ly
idle system but if tasks get scheduled out, rescheduled to a different CPU,=
...
the test fails. Widening the range help, e.g.:

diff --git a/x86/hyperv_clock.c b/x86/hyperv_clock.c
index f1e7204a8ea9..57d25770a2d0 100644
--- a/x86/hyperv_clock.c
+++ b/x86/hyperv_clock.c
@@ -79,7 +79,7 @@ static void hv_clock_test(void *data)
                min_delta =3D delta < min_delta ? delta : min_delta;
                if (t < msr_sample) {
                        max_delta =3D delta > max_delta ? delta: max_delta;
-               } else if (delta < 0 || delta > max_delta * 3 / 2) {
+               } else if (delta < 0 || delta > max_delta * 1024) {
                        printf("suspecting drift on CPU %d? delta =3D %d,
acceptable [0, %d)\n", smp_id(),
                               delta, max_delta);
                        ok[i] =3D false;

but I wouldn't be surprised if on a busy system even '1024 * max_delta' is =
not
going to be sufficient. Maybe we should make this a warning and not fail the
whole test as I don't see
how we can make it reliable.

Paolo (as you're the author), wdyt?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
