Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897A35220A9
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 18:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347052AbiEJQJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 12:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348510AbiEJQIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 12:08:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821FE9B181
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 09:01:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A08226172A
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 16:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10BACC385C9
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 16:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652198474;
        bh=gC2ZIxdyJv/FhQ1KzXbPDVwwmcd85AVBG1H86sXG1ho=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=m3VS1WheDkmJtsfGt/o3lh/IU7IPjO9k1um4SIklDVt2WF0HN9ewmce+hJiGcM3qf
         jzI/kPRn8f/YXrNYoB6H4tHuvDRQQ3tSFY8WXMqeBQ8nZIX/BORdv01gR3gETUzqAU
         T6AZ2cFohVPl9ocJfo0+xi8LUHPsIMZ1CX2TGf1Fzw+TCHaIuElpZdb+05WzHWrVUn
         X20jTKNpWn1erYyK1DaGWlzyxghq45FkZH2V5F8zAjw3VOOQZ4+t+U9spD+hYhkcVx
         SittFUHQl/sQePHs9YJ+er4rAKCe+4QKkWHyiwy3/LCJZM2nbfP8ze+mks9bEttb3h
         3KeN8TlwOFP0g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id EFDB8CC13B2; Tue, 10 May 2022 16:01:13 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215964] nVMX: KVM(L0) does not perform a platform reboot when
 guest(L2) trigger a reboot event through IO-Port-0xCF9
Date:   Tue, 10 May 2022 16:01:13 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215964-28872-8EZayedt6Z@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215964-28872@https.bugzilla.kernel.org/>
References: <bug-215964-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215964

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
Hmm, so KVM doesn't perform the RESET, that's handled by userspace.  KVM's
responsibility is purely to determine whether the OUT 0xCF9 should be forwa=
rded
to L1 or bounced out to userspace.

Does the 0xCF9 I/O access get sent to userspace?  If not, can you provide L=
1's
VMCS configuration for L2?  Specifically, the settings for USE_IO_BITMAPS a=
nd
the relevant bitmap bits if in use, or UNCOND_IO_EXITING if not using bitma=
ps.

If the I/O access does show up in userspace, then it's likely a userspace b=
ug,
e.g. userspace fails to clear nested state when emulating RESET.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
