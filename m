Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FC06DB4F5
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 22:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjDGUOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 16:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDGUOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 16:14:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C4D10F8
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 13:14:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D53262D67
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 20:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92BE8C4339B
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 20:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680898472;
        bh=W2fDetF4y7sPbxd4mURqinaraJ6vPZ8n17310MQts4c=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aQbK7FNNJlQoklFpFF+gQcdzb8rIzkmixjSKNYkJDxxbEwgLr1IHlJzaNuik+IDBU
         CXfIEQCAXfvyGPnH0NoHdgCW7JI5muP8RS19Di0bE45HaEl4Ti8yvJdI9qNDuBc8bF
         KEsw25z+6sJHhH5FtvnjqvCX/ol0GcASr3GYe4K0f3T6fx3LmDwcX8eZwvHcjb3YKp
         c72tjWHQ2+ss/v9iq0Jln/ouOhKJT0lTp2UaHykHiCTShqaMSROC3QjQah9g3pb5hy
         uwQTh7IP+6TYhDL2j6ByMXQphYz1p4oUL7RxHkabtLxrdvP6ImH9kCWaTDiPjHh4RR
         WZfI5/qehxcoQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7B035C43145; Fri,  7 Apr 2023 20:14:32 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217304] KVM does not handle NMI blocking correctly in nested
 virtualization
Date:   Fri, 07 Apr 2023 20:14:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixiaoyi13691419520@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217304-28872-a5z8K12AKP@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217304-28872@https.bugzilla.kernel.org/>
References: <bug-217304-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217304

--- Comment #2 from Eric Li (lixiaoyi13691419520@gmail.com) ---
<bugzilla-daemon@kernel.org> =E4=BA=8E2023=E5=B9=B44=E6=9C=886=E6=97=A5=E5=
=91=A8=E5=9B=9B 15:14=E5=86=99=E9=81=93=EF=BC=9A
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217304
>
> --- Comment #1 from Sean Christopherson (seanjc@google.com) ---
> On Thu, Apr 06, 2023, bugzilla-daemon@kernel.org wrote:
> Ya, KVM blocks NMIs on nested NMI VM-Exits, but doesn't unblock NMIs for =
all
> other
> exit types.  I believe this is the fix (untested):
>
Thanks for the fix. I tested it on Linux 5.19.14, and it passes my experime=
nts.

Detail: I wrote 30 experiments (i.e., tests), numbered from 1 to 30.
Before this bug fix, KVM passes 21 experiments. After this bug fix,
KVM passes 3 more experiments (3, 13, and 14) without introducing any
regression in my experiments. There are 6 more experiments that KVM
still fails (2, 4, 6, 18, 19, and 24). I think we can address them in
another bug on Bugzilla.

> --
> You may reply to this email to add a comment.
>
> You are receiving this mail because:
> You are on the CC list for the bug.
> You reported the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
