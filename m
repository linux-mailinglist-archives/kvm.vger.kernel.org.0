Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6C465C9C7
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 23:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbjACWtC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 17:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbjACWtA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 17:49:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E49C1401C
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 14:48:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3E466151C
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 22:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11E29C43392
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 22:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672786138;
        bh=PK8LhXsExAUD9uU0pOYt6GHn4aYLjy3SFsrHN0PzEZY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FaaIlk0TO8ht/iv5N9GsTzeRch0sxgToOPZjewhaYYF+xtePAwbFiP0tIe02QNrGJ
         CBpxwZ3mUiIj5qAui7cf4+kPD+OFgmAS9H6z2qyIc5JUSZpcLqCddcNSFhj5RlGWGi
         Z6K2gcbe0H0lL/EIhC5tH5wkq/qSzM+gF8HRIgdZV5lzfOypQABahiz44xmiC2zXdC
         wocS7seq+ipFRcKsIAOeim3sYx+W5RJcNcd9eKTOFnF4yUbkyPg23u7oD0MCYuc9o0
         1suqTxSToJnK12xuVFI8Un0GsjITFMZic0XCirSsh5pXETgN5HI61xUIeN9h3hHG8b
         u7PVIfRUO+BMA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id EB47CC43144; Tue,  3 Jan 2023 22:48:57 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216867] KVM instruction emulation breaks LOCK instruction
 atomicity when CMPXCHG fails
Date:   Tue, 03 Jan 2023 22:48:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ercli@ucdavis.edu
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: WILL_NOT_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216867-28872-TIi2SL0fkT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216867-28872@https.bugzilla.kernel.org/>
References: <bug-216867-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216867

--- Comment #3 from Eric Li (ercli@ucdavis.edu) ---
Just FYI: VMware Workstation Player 16.2.4 has the same behavior, which is
reported in
https://communities.vmware.com/t5/VMware-Workstation-Player/LOCK-instructio=
n-atomicity-broken-on-VGA-memory-mapped-IO/m-p/2946505#M39982

I tested on the following hypervisors / emulators, and do not see this bug:
* Virtual Box (version 6.1.40)
* QEMU TCG (version 5.2.0)
* Hyper-V

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
