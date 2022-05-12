Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2C2524F6D
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 16:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355014AbiELOGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 10:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355084AbiELOGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 10:06:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA2220BE9
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 07:06:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10C3061B1F
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 14:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 743B2C34116
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 14:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652364377;
        bh=PBVifdds2GsXPdiuGn6rSZiwhOHgiTlwPE93bO5Cfds=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tefAN5YKjt4/AJys3MgtJi8PZccpX+/4lwSZHrNrW3DWg//59mVJI1SzF1CdIQ4LW
         nnKxXLej9cekalWYTv0y1OVNlsE7iBPkbneviRpLBpiVLRwuw9LW2TEligfQyJEdPY
         AR9I0mYAdRBkgcWuHwfiZhBHqTUSLXnyXfIVCuGLAUlPFgS+c5u9qQjsI6N6BpQZvd
         pBCNN7qhiE2OcSL/2kGOnJ9MmRRpQELcBOQ/INYdQnX1rHFaWQ/Zo2WWqU3stwKOIH
         SF5xYoYda0yda0AzD78aZRZDcb3Pl/kFC91boIe06htUX8TjZnWuoup4TzmE9Dkfan
         DWKSku+YgHy4g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5DF78CC13B0; Thu, 12 May 2022 14:06:17 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215964] nVMX: KVM(L0) does not perform a platform reboot when
 guest(L2) trigger a reboot event through IO-Port-0xCF9
Date:   Thu, 12 May 2022 14:06:17 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215964-28872-hTIOr72Rhq@https.bugzilla.kernel.org/>
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

--- Comment #5 from Sean Christopherson (seanjc@google.com) ---
Definitely sounds like a QEMU bug.  Jim pointed out that you might have an
older version of QEMU, which seems likely given the fix went into v5.1.0 and
lack of clearing HF_GUEST_MASK would result in the behavior you're seeing.

Can you try running v5.1.0 or later?  Specifically, something with this com=
mit.

commit b16c0e20c74218f2d69710cedad11da7dd4d2190
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed May 20 10:49:22 2020 -0400

    KVM: add support for AMD nested live migration

    Support for nested guest live migration is part of Linux 5.8, add the
    corresponding code to QEMU.  The migration format consists of a few
    flags, is an opaque 4k blob.

    The blob is in VMCB format (the control area represents the L1 VMCB
    control fields, the save area represents the pre-vmentry state; KVM does
    not use the host save area since the AMD manual allows that) but QEMU
    does not really care about that.  However, the flags need to be
    copied to hflags/hflags2 and back.

    In addition, support for retrieving and setting the AMD nested
virtualization
    states allows the L1 guest to be reset while running a nested guest, but
    a small bug in CPU reset needs to be fixed for that to work.

    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e46ab8f774..008fd93ff1 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5968,6 +5968,7 @@ static void x86_cpu_reset(DeviceState *dev)
     /* init to reset state */

     env->hflags2 |=3D HF2_GIF_MASK;
+    env->hflags &=3D ~HF_GUEST_MASK;

     cpu_x86_update_cr0(env, 0x60000010);
     env->a20_mask =3D ~0x0;

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
