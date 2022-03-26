Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5784E81C4
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 16:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbiCZPTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Mar 2022 11:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbiCZPTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Mar 2022 11:19:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47DFDF4B8
        for <kvm@vger.kernel.org>; Sat, 26 Mar 2022 08:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41D6F60F59
        for <kvm@vger.kernel.org>; Sat, 26 Mar 2022 15:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A26DEC34112
        for <kvm@vger.kernel.org>; Sat, 26 Mar 2022 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648307854;
        bh=YPrfOJP5ADDUVUCLHiKe836O/TCScjHzZzVVSuQ3aIk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=U5Sxwj4eUVjzbDHS+LcRhRz9TCpRsy9DBRxjj1ZOazqBSiQ4qN1YrsYt23E0Sf78i
         LggDXmelhO31MTOwPpr4VXG9gZpNK4EzKPaAreLM2xSs4VFUqpSvyn1xwWKatHet0Q
         ejrTX+FrM98xGPVPVVAZu8hXK6s19f9UP6pNmHIg4r8TUQelGikmN984sR/UiZoJ3L
         jLL/UopTMySSnNd3j3C9kU8Mi6oqBV1BoZkedVaaI5Iz8XJlAatzuAJ11vD0JrJNy3
         6h/xnUhBjIxOf9piL8wpaLpnqRpF5A3NwKLrTTRHIj8lm6iVCQIc99Q2C0SVFObnBC
         fJEVEeuSEydkQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8F819C05FCE; Sat, 26 Mar 2022 15:17:34 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Sat, 26 Mar 2022 15:17:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: cmultari@mpihq.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-199727-28872-reIpIAqpGg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

Chris M (cmultari@mpihq.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |cmultari@mpihq.com

--- Comment #17 from Chris M (cmultari@mpihq.com) ---
Experiencing the same issue with Proxmox 7 under high IO load. To achieve t=
he
highest stability, are you setting all VMs to async IO Threads/IO Thread/Vi=
rtio
SCSI Single, or just the machines with the highest load?  I moved our higher
load machines to those settings but still experience the issue at times.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
