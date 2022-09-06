Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAF05AF04D
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 18:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbiIFQYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 12:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238789AbiIFQXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 12:23:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB55A81688
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 08:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BB8BB81920
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 15:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29645C433B5
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662479573;
        bh=1dnneNf5SkiwBvmKcIMxL4sbV/QVFOXHZW+2QJoch6A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=vE/sopaSg/KgQIqYGnpgZJr1xLq+fQ6DhZwUy8dD7+zKFz0WPXAwZvFmvmrhOmsTu
         XBv95iZqd1l8EZsTpztsCtYsXzLOcaxsFJfzLDNZqwlSHbV69lJUxHzZ0MLMZ3Nqsj
         Gw6q2L3ttSULUT3FQNyF9+tUSzCfJ0Q5Drl/r5dPgJVoTQTxdnOV5Yr8V+a/owFR1z
         W3geTYpDzgprEXYu7pQH0Kjk9yXsJcSYCab8w22GttXGYwpc+NSUH8v2b/JLw34Fjw
         nHgiBFO/8E4tqTyhsoJ2D1++j7PcYXVMGRZ3UPhMDEvzLLcB8BnU3fnRa38mJwuICo
         364pInP7h/MlQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 138D6C433EA; Tue,  6 Sep 2022 15:52:53 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Tue, 06 Sep 2022 15:52:52 +0000
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
Message-ID: <bug-216388-28872-21xuO7cPxy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216388-28872@https.bugzilla.kernel.org/>
References: <bug-216388-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216388

--- Comment #19 from Sean Christopherson (seanjc@google.com) ---
On Sat, Sep 03, 2022, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216388
>=20
> --- Comment #15 from Robert Dinse (nanook@eskimo.com) ---
> Please forgive my lack of knowledge regarding git, but is there a way to =
get
> a
> patch that took the kernel from 5.18.19 to 5.19.0 now that earlier releas=
es
> of
> 5.19.x are not on the kernel.org site?

Strictly speaking, no.  Stable branches, i.e. v5.18.x in this case, are
effectively
forks.  After v5.18.0, everything that goes into v5.18.y is a unique commit,
even
if bug fixes are based on an upstream (master branch) commit.

Visually, it's something like this.

v5.18.0 --> v5.18.1 --> v5.18.2 --> v5.18.y
\
 -> ... -> v5.19.0 -> v5.19.1
           \
            -> ... -> v5.20


IIUC, in this situation v5.18.0 isn't stable enough to test on its own, but=
 the
v5.18.19 candidate is fully healthy.  In that case, if you wanted to bisect
between
v5.18.0 and v5.19.0 to figure out what broke in v5.19, the least awful appr=
oach
would be to first find what commit(s) between v5.18.0 and v5.18.19 fixed the
unrelated
instability in v5.18.0, and then manually apply that commit(s) at every sta=
ge
when
bisecting between v5.18.0 and v5.19.0 to identify the buggy commit that
introduced
the CPU/RCU stalls.

> I know there is a patch that goes from 5.18.19 to 5.19.6

I assume you mean v5.18.19 =3D> v5.18.20?

> and one that goes 5.19.5 to 5.19.6 but I just want to look at the changes
> between 5.18.19 and 5.19.0.

If you just want to look at the changes, you can always do

        git diff <commit A>..<commit B>

e.g.

        git diff v5.18.18..v5.19

but that's going to show _all_ changes in a single diff, i.e. pinpointing
exactly
what change broke/fixed something is extremely difficult.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
