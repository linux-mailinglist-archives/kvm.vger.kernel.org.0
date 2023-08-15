Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51B177D41B
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbjHOUat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbjHOUaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1BE1BF1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A59860ACB
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 20:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C18ADC433C8
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 20:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692131417;
        bh=u8sf22ClvyoN5faIqPVo5jRIUePf2ddJ1EOz4P/KMWs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NTY0Kq2cyVVpP4B+rRD4mO7Mfe4KdFz31diBtM/L0nUHqUF1E5rNSD2ORgLgbTk6Q
         /ZztnMpM5Mte75oATqRJwIHgs8dtf/mC14ffoiagpLphZy9n0e+76b84Kk2ziJvI/G
         X8qpn6joYqu7gtloBkuneBDUTYmR78SEUgQ56pEOnEJc9PiQCqrr/cBR2IoIBjsOb3
         QdGJ1OUPZX2KI4n6F+AhBGpGxH93K5dtXEWAPAHlAEUn++DyaiHr90EJ2DsB5m5ON/
         kaL7smpdAkx8t7u6PjysN/hPvCwxaxEpj0EVGYLlE0YIMmsdwLfWxNlXZ/3zRJs/2p
         VukCYBZHoM8Xg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A2F8BC53BD3; Tue, 15 Aug 2023 20:30:17 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217796] latest Zen Inception fixes breaks nested kvm
 virtualization on AMD
Date:   Tue, 15 Aug 2023 20:30:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217796-28872-4RXWu2ZX06@https.bugzilla.kernel.org/>
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

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #2 from Sean Christopherson (seanjc@google.com) ---
This is going to sound completely ridiculous, but can you try the fix for t=
he
guest RFLAGS corruption issue in the return thunk?  It's definitely unlikely
that the _only_ symptom is an unexpected OOM, but it's theoretically possib=
le,
e.g. if your setup only triggers KVM (bare metal host) emulation in a handf=
ul
of flows, and one of those flows just happens to send a single Jcc in the w=
rong
direction.

https://lore.kernel.org/all/20230811155255.250835-1-seanjc@google.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
