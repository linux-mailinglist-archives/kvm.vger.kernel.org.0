Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29C174DE77
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 21:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjGJTrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 15:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjGJTrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 15:47:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4241C13E
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:47:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4E79611C3
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 19:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E035C433D9
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 19:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689018425;
        bh=g6Z4oY/wf5I24Nstd+O4lQ0Eag6tsTUNNPnyMZam5gw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FJ2Wpjx0i0wGfWgIblJQ/bynfGi6Zm56XHZDBq88+QXVFc9mMnURqU8stoeitgMK5
         F7yXdgJEs8BBMxyTsVtTqPiywgPIM3t3ZnMhRsNQD8UN6BzDbE2iDUyAcYBMdMchSn
         Qyb2ozz3tSIRYp9OI/Ih7jp71qkgPKFMM9F3/e6UdHWtBbZvoXHpWANz5Qd0/pwiAA
         o/Cz+8dUTtdFnWTjBHZiYCsMyizgWItYnJ3JFmy3uJx7ZHW09s2v8O0wcqPg4vNhGb
         4Eo01aoeJct6xnoRKhfFqfGm7TGPZNSnkA1Pm+2KFU8+wSIvm9jqPYVbXICoqkyc2K
         jF5t1nNzNo+Zg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2ED07C4332E; Mon, 10 Jul 2023 19:47:05 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Mon, 10 Jul 2023 19:47:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217307-28872-zb32orXLA7@https.bugzilla.kernel.org/>
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

--- Comment #18 from Sean Christopherson (seanjc@google.com) ---
> it seems that my problem is something that exclusively affects 12th gen a=
nd
> above

Can you try running a single vCPU VM, and pin that vCPU to a pCPU on a P-Co=
re?=20
If this is indeed specific to 12th gen CPUs, then my guess is that hybrid C=
PUs
are to blame.  E.g. KVM already disables vPMU (commit 4d7404e5ee00 "KVM:
x86/pmu: Disable vPMU support on hybrid CPUs (host PMUs)"), I wouldn't be at
all surprised if there are more problems lurking.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
