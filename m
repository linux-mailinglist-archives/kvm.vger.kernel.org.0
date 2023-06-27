Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D8B73F738
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 10:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjF0I3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 04:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbjF0I3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 04:29:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EF22722
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 01:28:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5932760F6B
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 08:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB341C43397
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 08:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687854499;
        bh=4l4dhrfleYNqjZ+0JsA17fatdN91HRNv6542a8/W8mE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XOiOgSQsj+0HYWF7XfHPV+TLvA0GKBFApAGw+drDv24UNEDEcyUGBrMJvZCXlMQQ3
         PzEsUUWdIaTJ6w6XnWq1UJjY2QkMJUnAKgODy5f7vCW4nm4iU01waboodbQHxk3HTz
         9X7k0BfzLW36JtbUbKN8FMmu1Ox7r15RtvdfoOJu2U9oBBRIgx9YRiFOk3QAjT1Hev
         PVOgdU8DwNU+JCKhOVISrhxnKtL938adBHOkF6J+QsRaGwf9O091778cOrspVhjn8A
         EBfNmDLVS8qR2ItxteGpjH/eI51SrZ66kc+oyZdZrZHp0OJVuq4KmeQ5AW1I6qUh14
         iLBYkG6s5w6CQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A2A9DC53BD5; Tue, 27 Jun 2023 08:28:19 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Tue, 27 Jun 2023 08:28:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: vkuznets@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217307-28872-kMkFtlkZcH@https.bugzilla.kernel.org/>
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

--- Comment #7 from vkuznets@redhat.com ---
Assuming this is not a KVM/QEMU regression, I'd suggest to explore two opti=
ons:
1) Change "-cpu host" to a named CPU model. I don't see "alderlake" CPU mod=
els
in QEMU so I'd start with something like "Skylake-Client-v4". Remove all ot=
her
CPU options you have, like "rtm=3Doff,mpx=3Doff,host-cache-info=3Don,l3-cac=
he=3Doff".
Try to find the exact CPU option which breaks things. There were similar but
reversed (works with '-cpu host', doesn't work with a named model) issues in
the past, e.g.
https://lore.kernel.org/qemu-devel/20220308113445.859669-21-pbonzini@redhat=
.com/
2) Try disabling certain Hyper-V enlightenments, start with "hv-evmcs". In
theory, things should work (slowly, but still) without any Hyper-V
enlightenments.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
