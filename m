Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F22973A7BA
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 19:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbjFVRwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 13:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbjFVRwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 13:52:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4591988
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 10:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0735E618D1
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 17:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EE3BC433CA
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 17:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687456301;
        bh=wBa/cVYSsMexYufK/vz8DU9upfhEblf5HovA5DtarWA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iNIxgHJeViJxU6HD5Yh9d/tAxrzfAMzzoQ9du/zDPXsZRtMlQbYcWcLDabHgjMSrK
         hxj4AFSvACn83UQZh3zizYO/kXCTBZ5L/Tlqk7Rf/Q4ScA5xT3dXvlHeBBMZNC+QmL
         Hx6P1kAx6Wi8Ctx+EYO7aa7hYRXxJmrNfpAnh/HUvQp3ujoHEpuD1TWet/C4nVBOWN
         F0av8sEl7QkQogQ3bvNNyJDsLsbxU6QPfwN2iAdcHFQYKanAGiJ0sWF2V4d+wXfHxZ
         5QxENWGLQ8vWRM9vVSc90G97mKbkztj9uXeEM+qwO8sMfHyxgxpvPyhvCwPuAdnij9
         ZUbFAfqbJuhyQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5A1F3C53BC6; Thu, 22 Jun 2023 17:51:41 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217562] kernel NULL pointer dereference on deletion of guest
 physical memory slot
Date:   Thu, 22 Jun 2023 17:51:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: arnaud.lefebvre@clever-cloud.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217562-28872-nbfYtxtk57@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217562-28872@https.bugzilla.kernel.org/>
References: <bug-217562-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217562

--- Comment #2 from Arnaud Lefebvre (arnaud.lefebvre@clever-cloud.com) ---
Thanks a lot for that very detailed reply!

> TL;DR: I'm 99% certain you're hitting a race that results in KVM doing a
> list_del()
> before a list_add().  I am planning on sending a patch for v5.15 to disab=
le
> the
> TDP MMU by default, which will "fix" this bug, but I have an extra long
> weekend
> and won't get to that before next Thursday or so.

> In the meantime, you can effect the same fix by disabling the TDP MMU via
> module
> param, i.e. add kvm.tdp_mmu=3Dfalse to your kernel/KVM command line.

Alright, thanks for the tip. We'll probably just upgrade to the 6.1 LTS, th=
is
was planned but we weren't sure if the bug were there too.

> If you're feeling particularly masochistic, I bet you could reproduce this
> more
> easily by introducing a delay between setting the SPTE and linking the pa=
ge,
> e.g.
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 6c2bb60ccd88..1fb10d4156aa 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1071,6 +1071,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gp=
a,
> u32 error_code,
>                                                      !shadow_accessed_mas=
k);
>=20=20
>                         if (tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kv=
m,
>                         &iter, new_spte)) {
> +                               udelay(100);
>                                 tdp_mmu_link_page(vcpu->kvm, sp,
>                                                   huge_page_disallowed &&
>                                                   req_level >=3D iter.lev=
el);

We might try that if we can find some time in the upcoming weeks, just to be
sure that we can actually reproduce the bug and put this behind us.

Regarding this bug report, how do we proceed from now on? Should we close i=
t?
Keep it open for a few weeks until we can confirm that we don't have this i=
ssue
in 6.1 anymore? Let you handle it once you disable TDP MMU by default on the
v5.15 LTS?

Thanks for your advice.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
