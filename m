Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B25873BF39
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 22:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbjFWUIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 16:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbjFWUIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 16:08:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589F5271F
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 13:08:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D668B61B07
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 20:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45C18C433CC
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 20:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687550932;
        bh=CEZYZlgGc+70Gcmcw3iurb8+ImYt81sWNJMxVJQ77EM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PICAG2L9NJibUy+1YLOzHwBy6xwoYR/35iuX6ucFHkXwXv/fu7gqCKcbpPaGeRVxA
         Ugp45MEjC/imxC9AZK/e+4JgsoZ6hQ+snAOuDh9cDYJ2pKbEIir1+x8ukIyuazT14K
         CfmYapab76BMhKqLLdG9svOs7igW79cGENeONQi7QTjkb6KIgJcX3y8f7pcoTCZx1I
         G4VbE0MbygC4A6+Qi3ya0stBNrhuVhbig4aUF6uJ50SSiqSjzUy1ZWDdji70Vgb4Dj
         qV6eUS/CI2nQ6yzZ8EL00L1ZC7PON3GKiO5VMBmaS5cfCdVgBluYq83pgPscnRph0P
         PcHv6nfj/1LSA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2F22EC53BD0; Fri, 23 Jun 2023 20:08:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217574] kvm_intel loads only after suspend
Date:   Fri, 23 Jun 2023 20:08:51 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217574-28872-VH9xAa5Vaj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217574-28872@https.bugzilla.kernel.org/>
References: <bug-217574-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217574

--- Comment #4 from Sean Christopherson (seanjc@google.com) ---
Can you check all MSRs in the range 0x480-0x491, i.e. all the known VMX MSR=
s,
and just report back any divergences between CPUs?  The values for MSRs that
are consistent across all CPUs aren't interesting at this time.  What we
*suspect* is going on is that one or more CPUs has different MSRs in one or
more of the VMX MSRs.  Before we can debug further, we need to first confirm
that that is indeed why KVM is refusing to load.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
