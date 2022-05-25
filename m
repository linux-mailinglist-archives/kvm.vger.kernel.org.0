Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B606D5340EA
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 18:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245348AbiEYP7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 11:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245346AbiEYP7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 11:59:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60ADB36F5
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 08:59:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5373E615CA
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 15:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2684C3411F
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 15:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653494341;
        bh=2qn985g0meZ58FXXXz8IOy5XZE+gmnjaLbDkDB0J4ZQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=sk9Ck1pWwresFHNJqUK2ytq5iAdnTc1yrn/QR61yPJc+CKgK2YAPjG8uDHOdNGrXA
         PNlygkAVE2C2E6ko1l9M1s5+0rTgDRUp2QATGFDZpr2hT6CeX2zQ4Kx56DMRpocmFW
         CoBjkUWvvAhFcqhPTt24HCT3xGF7Pe39sAhlXJnjSzPc1A7Gquvkf9uMgS7qyiCW0M
         Swy8OTOk4iOBCT5H6/3XaP+27qV4ujD06ea4734+vXiE2BXtNSxxiNjMZxhQNpzdcK
         UafAzbeCQVJ1mKkqKLHSxbolwDTRU86Z/RnQSy7OWMkJzy0WfeYv7BTQdTRF2KIDoj
         TvhS1dtZBUcKg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9A953CC13AD; Wed, 25 May 2022 15:59:01 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Wed, 25 May 2022 15:59:01 +0000
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
Message-ID: <bug-216026-28872-r8UlFuWvQI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216026-28872@https.bugzilla.kernel.org/>
References: <bug-216026-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #3 from Sean Christopherson (seanjc@google.com) ---
Some of the GCC-12 errors, including this one[*], are likely GCC bugs.  The=
 KVM
code has existed for many, many years, i.e. this wasn't something introduce=
d in
v5.18.  I am working on a small series to guard against KVM bugs in this ar=
ea,
which will in theory squash this warning, but unless someone can prove that=
 an
out-of-bounds access really truly is possible, I doubt any "fix" for this w=
ill
be backported to already-released kernels.

Your best bet is to build with CONFIG_WERROR=3Dn and CONFIG_KVM_WERROR=3Dn =
so that
GCC-12's zealotry doesn't break the build.

[*] https://lore.kernel.org/all/YofQlBrlx18J7h9Y@google.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
