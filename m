Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BF177E30C
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 15:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245665AbjHPNvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 09:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245725AbjHPNvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 09:51:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1651626A9
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 06:50:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E445659E4
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 13:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10CFCC433D9
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 13:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692193855;
        bh=E8y5+JDyjAjsLlfb+pjXj6prN4MGwFOI1xWqzB3Fjxs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XN/1OtJh/5BUS2+itH0Up6vH8M9xLd63gY148QcrGlV7i5es2aZuK/JthTKXowDke
         50N0dNHbwa0eEDwR0HJaSJZG0tVSquTO1FDcxkMH7dqLqm79tSeeKoTzj2jAp1PCWZ
         6pyjj/Xv/mZndNLva4pmVvwIY1Y46K4N2x6gGQUFCVeyuTEbpSnASQensYp/yi4SWI
         2c3S6yuFUi8u1Yc4YO+zjZdN6+MurXCDlput9gKVUNAB0qMilYQRFFS5YbDNtOGZWY
         0dfxnymhmByRD3Vy59H55jlWhk2gP6Yxq8KpiGXbkEeVaCipUkZa+XiKaTcR2aeVYn
         XPSlYomMTNxUg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F1B99C53BD4; Wed, 16 Aug 2023 13:50:54 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217799] kvm: Speculative RAS Overflow mitigation breaks old
 Windows guest VMs
Date:   Wed, 16 Aug 2023 13:50:54 +0000
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
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217799-28872-J69CVoMgQs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217799-28872@https.bugzilla.kernel.org/>
References: <bug-217799-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217799

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #5 from Sean Christopherson (seanjc@google.com) ---
As pointed out by Vitaly, this is probably the guest RFLAGS corruption bug[=
*],
especially since it's XP specific (more likely to trigger emulation).  The =
fix
should make its way to Linus' tree this week, and hopefully to stable kerne=
ls
shortly thereafter.  Though if you can manually apply and test the fix befo=
re
then, that would be very helpful.

[*] https://lore.kernel.org/all/20230811155255.250835-1-seanjc@google.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
