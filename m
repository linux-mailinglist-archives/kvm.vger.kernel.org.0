Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D5E5B2E6B
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 08:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiIIGE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 02:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiIIGE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 02:04:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DBDBD0
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 23:04:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54660B822BC
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 06:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A112C433B5
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 06:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662703461;
        bh=bP/pZ2FGFxjVycZ4CCSMTSKhvsMKzQm2cVi7mYcrYFo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gmNvO/f2xXK9cMZGjShX5ZFopoF1hVHH9SiPYD2Az8jyJuyQexbwwQx/fQcYWjMvG
         405GL1J0NBmZ+SoT8HDuSJvszRY65iYV0Nk20e2roi/c54deMilcFECkYSYeEsrPby
         N4Y8RR1mr2dxjGkODYs1C62JVPj99MSMccwsx4WenzAAi1PCKnybssOQEOo0vTSAGN
         /oXdyaahHdp3vk4iDhbYBb2BPnl5lYBDC/JvD8WdAr1Mc3rhDyHlm4cWOOffpXxyiW
         HOJ/vnQtFzsPL3WEpjeOxjQOWe+phQZDSumYSeUEN9ukh8lkSM2aWXo3vNKEUpFxd/
         u+oOPOURf9Kxw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0737DC433E9; Fri,  9 Sep 2022 06:04:21 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216365] kvm selftests build fail
Date:   Fri, 09 Sep 2022 06:04:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: lixiao.yang@intel.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DOCUMENTED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216365-28872-idL2ewQHCY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216365-28872@https.bugzilla.kernel.org/>
References: <bug-216365-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216365

Yang Lixiao (lixiao.yang@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |DOCUMENTED

--- Comment #1 from Yang Lixiao (lixiao.yang@intel.com) ---
The failure is because kernel headers are not installed. Executing "make
headers_install" on top level Makefile prior to building selftest can solve
this problem. KVM has stoped using KSFT_KHDR_INSTALL after july 8 2022 and
can't install kernel headers automatically when build selftest.

Some details could be seen in the following patches :
f2745dc0ba3dadd8fa2b2c33f48253d78e133a12 selftests: stop using
KSFT_KHDR_INSTALL
49de12ba06efcba76332054379830f9d04541492 selftests: drop KSFT_KHDR_INSTALL =
make
target

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
