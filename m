Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DCF55CA0C
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238107AbiF1A2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 20:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbiF1A2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 20:28:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826147658
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 17:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15E976162D
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 00:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71286C341CC
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 00:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656376095;
        bh=IlD/HjaeU6hF0Cvp6/OJZZodEDtqJh9FlGCpAHII0ZI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PieSptR+LP0E98/s8nAyxKbOqAIsHKtyEovr8c9cVPCgqj/1Q9SQjyqGyXpKkfGqq
         5lXVtbpO6Mn2McE1Iv6voBXj75JOcI3kwEeymHhOuB+EP9v1v3rE8HZXBEfQdBMfpq
         O3N2ZcLlAbejEoabQTUhMobjOQ0Esc2mKBYFahZC7lMyhkUnr7vHthAzZQLmq8tQsR
         G56GEAQFAPZxy73qYXvhLjbVl5xBURRxQUoFg1vrBHdSuIFcRqRbYSe1z6cPVOIwqg
         b2vUGRt+//1ReiVW2edazqX4hTRMbS78KCd193+sd/cQt8g8S6qi67feM24MZ1xePn
         Df6AiHHXcfB6w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 59088C05FD5; Tue, 28 Jun 2022 00:28:15 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216177] kvm-unit-tests vmx has about 60% of failure chance
Date:   Tue, 28 Jun 2022 00:28:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216177-28872-7AaU43xNGH@https.bugzilla.kernel.org/>
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

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
It's vmx_preemption_timer_expiry_test, which is known to be flaky (though I=
IRC
it's KVM that's at fault).

Test suite: vmx_preemption_timer_expiry_test
FAIL: Last stored guest TSC (28067103426) < TSC deadline (28067086048)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
