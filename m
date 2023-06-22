Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6284E73A99F
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 22:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjFVUmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 16:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbjFVUmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 16:42:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82151987
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 13:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B468618EB
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 20:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6407C433CB
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 20:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687466565;
        bh=BvyuLyGcYdAtsNRnUMqzH4tVBeIrAJJ5VFkCrY4f0Oo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AiWkZLsMoiwgSm3Cqq2+TVY/7ij0YImPGY8NX25hCbzgsz8Q5debtC0xbvTtwObL2
         4RWjYaSdZ4RoKz4cTXBrXVfbtj5gQcWk6Eiv/7GyveW6zpZr/H0jZHfHVhVBw/8qEI
         sYQ1e1KaXf1OGJTszM5+ASSnVhWvKn0oN/gKrL86pLjMqb+0K7WGzd6i7O/0agVOaQ
         TgPlKuKgzsoIXMby5mtCkAxQ/+30UPO9LS+hqaM65ebisOB82Fws7JU4HmdcPmIooq
         elYlHdNyDG3Am+wM9Z8/9TJINOwxcqCEQ0nVMaHSNdMgILEatyBR+QDxnpGkqMUSFK
         NY3iD8LRICJVA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 882C8C53BD3; Thu, 22 Jun 2023 20:42:45 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217574] kvm_intel loads only after suspend
Date:   Thu, 22 Jun 2023 20:42:45 +0000
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
Message-ID: <bug-217574-28872-rlTdA5EIs7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217574-28872@https.bugzilla.kernel.org/>
References: <bug-217574-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217574

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #2 from Sean Christopherson (seanjc@google.com) ---
Ya, as Chao alluded to, the problem appears to be that not all CPUs have ha=
ve
the same VMX configuration, which is reflected in the MSRs Chao mentioned. =
 My
best guess is that going through a suspend+resume cycle either wipes out a
problematic ucode update, or applies a "good" ucode update to all CPUs, and
thus resolves the inconsistent VMX configuration across CPUs.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
