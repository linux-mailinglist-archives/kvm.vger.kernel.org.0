Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DD24B0E55
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 14:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242131AbiBJNW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 08:22:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237587AbiBJNW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 08:22:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F101B5
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 05:22:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F6BF60F3D
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 13:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFF27C36AE5
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 13:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644499372;
        bh=lqntHyxh3yODhXtI454WJ2EeYeg2i+NWLYSe98s/sP4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=h2jo0C0HByC4Ywa9SrOTLaNaO0gUqMdl22LhREX+13jGS2qC1hALkNoHUuBIbjhcd
         /4XYlwpQ/VISwfQiiTm3bh6q+IYDOFi1hqq2ZA6I1ue4TNNIVFpolOJjZMlPla7KlC
         DWctypJGFpXiUftD0EdWFAxgN3T+Nj536jiQZEiYRH3Y7pqLxakRpc+TP8Qd7R4TE8
         0bzLSz8dX+9Qu7yjlCtnJrh2OtQjaFwYIb1El+aBDP9cEN8zlZtpBesv7CYqeC72Ir
         NMtbGiMdbdJIfFybfl6Ttl987S62nCrqYV2hMBOBE4RMX3wTuHxXNDhNDLsTk7Dtxm
         aDly9TLxiYWkA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8DC89CC13AB; Thu, 10 Feb 2022 13:22:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Thu, 10 Feb 2022 13:22:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: yann.papouin@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-cr4SPwShq7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #7 from Yann Papouin (yann.papouin@gmail.com) ---
(In reply to Roland Kletzing from comment #5)
> apparently, things got even worse with proxmox 7, as it seems it's using
> async io (via io_uring) by default for all virtual disk IO, i.e. the
> workaround "cache=3Dwriteback" does not work for me anymore.
>=20
> if i set aio=3Dthreads by directly editing VM configuration, things run
> smoothly again.

Are you using "cache=3Dwriteback" with "aio=3Dthreads" ?
For me, using "aio=3Dthreads" reduces the VM freeze (High CPU Load) but it =
still
happens on high disk IO (backup/disk move)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
