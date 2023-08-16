Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B35377E026
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 13:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244531AbjHPLSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 07:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244506AbjHPLRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 07:17:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904D31FDC
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 04:17:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A99A6149A
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 11:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F0B4C433CD
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 11:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692184664;
        bh=GW3j3vfEakJPQFCHRc6bQoGc21S6JkHd/xO4cnUCXac=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=MoJUylSwXzIx1TtjJl5xOLUrlDb3L823cbQtmd+XLU2uQyweFbnUkF0NW5wUkzp7E
         S5+JavwIPS1mnsUnhWh5Gru4zXw1+p75RIBP6J87JV/YtMXKqGu1yLnmAi5LazkStL
         cQxV0ULTj/YiTly24WdMBUOPhh1uUMnZ5UgpnJ5MQig2lZyk+XvC+QQAzE+65TAz09
         JTcq4yJNYi/SUTGdGiAFeVSeIUMZhn4Ff7ATBHiXyBTcAxFi9Y2p+cdSFjJfKEyYra
         N6c14hgYWO+QzLa2SSXmC/Pq1wAvOEJGFppo8iMKt7+OO+4G5N+qSTtrbzW63tpoUc
         bae/xBUC5TNYw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7C0CAC53BD0; Wed, 16 Aug 2023 11:17:44 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217799] kvm: Speculative RAS Overflow mitigation breaks old
 Windows guest VMs
Date:   Wed, 16 Aug 2023 11:17:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rm+bko@romanrm.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc cf_kernel_version short_desc
Message-ID: <bug-217799-28872-bRBmGsg2K8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217799-28872@https.bugzilla.kernel.org/>
References: <bug-217799-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217799

Roman Mamedov (rm+bko@romanrm.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bp@alien8.de
     Kernel Version|                            |6.1.44
            Summary|kvm: Windows Server 2003 VM |kvm: Speculative RAS
                   |fails to work on 6.1.44     |Overflow mitigation breaks
                   |(works fine on 6.1.43)      |old Windows guest VMs

--- Comment #4 from Roman Mamedov (rm+bko@romanrm.net) ---
Borislav, as you are author of the patch adding Speculative RAS Overflow
mitigation, could you maybe take a look what could be wrong here? Thanks

Windows XP-era 64-bit guest VMs in KVM no longer work with it enabled.

Windows 7 (and likely newer) does work.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
