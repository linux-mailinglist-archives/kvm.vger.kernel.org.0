Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E3A6FC867
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 16:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbjEIOBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 10:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbjEIOBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 10:01:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071A346AD
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 07:01:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84F30646BB
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 14:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2BD6C4339E
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 14:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683640889;
        bh=K18kRHXi1pWaVi3uTjRZ4slrk2yzDoXJMWNlmwyn9J0=;
        h=From:To:Subject:Date:From;
        b=jj0alXnc0gVXVGbw5MPDugLiOe5Jk+ZFG7OS4bS9V8ZC8gMzS50+6yV5eNVtThv9J
         KWTRhCDP/JBeIZxMkN5ubimZ6IgZcLLxqb8l6dhrd/foU2IWPbBctwXfS2b30IPHDe
         HAjJKM4R0njUpV6UKv6nhteR4EGLyc2da1DJAoo7n9jKQTuFklLISYkWHKLU9r5nTL
         VcbJrktMXav7mOogkwPCXcUTxAVINdeE2KK0SylvweJ3D46l0R8T5CLr+smv8VazxZ
         4ECAo8F5Gvoj0labZL2b/BE6gCyEchAIfWwfeen2dSTnYXx89NGKZr9TXNFXgNj3Su
         NBuc6J0gf5LaQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B43BFC43144; Tue,  9 May 2023 14:01:29 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217423] New: TSC synchronization issue in VM restore
Date:   Tue, 09 May 2023 14:01:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zhuangel570@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-217423-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217423

            Bug ID: 217423
           Summary: TSC synchronization issue in VM restore
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: zhuangel570@gmail.com
        Regression: No

Hi

We are using lightweight VM with snapshot feature, the VM will be saved with
100ms+, and we found restore such VM will not get correct TSC, which will m=
ake
the VM world stop about 100ms+ after restore (the stop time is same as time
when VM saved).

After Investigation, we found the issue caused by TSC synchronization in
setting MSR_IA32_TSC. In VM save, VMM (cloud-hypervisor) will record TSC of
each
VCPU, then restore the TSC of VCPU in VM restore (about 100ms+ in guest tim=
e).
But in KVM, setting a TSC within 1 second is identified as TSC synchronizat=
ion,
and the TSC offset will not be updated in stable TSC environment, this will
cause the lapic set up a hrtimer expires after 100ms+, the restored VM now =
will
in stop state about 100ms+, if no other event to wake guest kernel in NO_HZ
mode.

More investigation show, the MSR_IA32_TSC set from guest side has disabled =
TSC
synchronization in commit 0c899c25d754 (KVM: x86: do not attempt TSC
synchronization on guest writes), now host side will do TSC synchronization
when
setting MSR_IA32_TSC.

I think setting MSR_IA32_TSC within 1 second from host side should not be
identified as TSC synchronization, like above case, VMM set TSC from host s=
ide
always should be updated as user want.

The MSR_IA32_TSC set code is complicated and with a long history, so I come
here
to try to get help about whether my thought is correct. Here is my fix to s=
olve
the issue, any comments are welcomed:


diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ceb7c5e9cf9e..9380a88b9c1f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2722,17 +2722,6 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcp=
u,
u64 data)
                         * kvm_clock stable after CPU hotplug
                         */
                        synchronizing =3D true;
-               } else {
-                       u64 tsc_exp =3D kvm->arch.last_tsc_write +
-                                               nsec_to_cycles(vcpu, elapse=
d);
-                       u64 tsc_hz =3D vcpu->arch.virtual_tsc_khz * 1000LL;
-                       /*
-                        * Special case: TSC write with a small delta (1
second)
-                        * of virtual cycle time against real time is
-                        * interpreted as an attempt to synchronize the CPU.
-                        */
-                       synchronizing =3D data < tsc_exp + tsc_hz &&
-                                       data + tsc_hz > tsc_exp;
                }
        }

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
