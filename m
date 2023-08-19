Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C6078190F
	for <lists+kvm@lfdr.de>; Sat, 19 Aug 2023 12:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbjHSKod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Aug 2023 06:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbjHSKoG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Aug 2023 06:44:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF46271B
        for <kvm@vger.kernel.org>; Sat, 19 Aug 2023 03:39:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1A9760FC1
        for <kvm@vger.kernel.org>; Sat, 19 Aug 2023 10:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FC71C43391
        for <kvm@vger.kernel.org>; Sat, 19 Aug 2023 10:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692441578;
        bh=VR8IVsYJQoLxmZrkFwwU1Ry/pOMdhcX63X1Qm3HtzaE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=vLLoqTU5Om1SXSLvv0WxHLZ1VdI6FwqXKatKrQ3uzPeiSrVNUvRBUAqWApmPLYa5A
         llV2nyC4vTZh8igeaWxcT2m/pTKvZvcvuFY+KIj26ZfuTkqC0ECse+o3J0c4/8+m/f
         HrzAv0HvoQ6U5dpnzIIcvkcUlPT5yhYhRY5FCkjKb2CcLMjnbrZBvCgOTW+KMuRUwR
         9HFvJbsdhy7XZ7Apn+Ah9Ut6RJEaEC59I9PgIV5TxKcytZh5058i/qFh4WOoQJ2wvb
         24CA9+S3yhB1dye3E+FyHwTNQsDgexsrWqw4fJ0zi9qgYOjj6VB7sohcG3X/EavHe3
         kfjz7NPQMfpsg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 29629C53BD0; Sat, 19 Aug 2023 10:39:38 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217796] latest Zen Inception fixes breaks nested kvm
 virtualization on AMD
Date:   Sat, 19 Aug 2023 10:39:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: sonst+kernel@o-oberst.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217796-28872-GcvVFBYPGE@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217796-28872@https.bugzilla.kernel.org/>
References: <bug-217796-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217796

--- Comment #3 from sonst+kernel@o-oberst.de ---
Sean,

it does sound ridiculous, but it isn't. I tested the fix you suggested and =
it
works now with that patch applied. In the meantime i switched to a differnet
machine to be able to test your fix and there I could also confirm the prob=
lem
there on a 6.4.11 kernel:=20

Test machine setup:=20

Gentoo, (vanilla) Kernel 6.4.11

Without the patch and spec_rstack_overflow in the default meaning
pec_rstack_overflow=3Dsafe-ret also on this system my nested VMs do not sta=
rt and
get OOM-killed.

I then applied the patch from your link, Sean, and it works now.

Cheers,

Oliver

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
