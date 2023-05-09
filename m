Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4EA6FC881
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 16:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbjEIOEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 10:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235724AbjEIOEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 10:04:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B414B46AF
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 07:04:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA3786254C
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 14:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFB5CC4339C
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 14:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683641073;
        bh=25+i3J0TqHcemgyXp1sJT2MX0rg7KU38ZOSn9jpbL9k=;
        h=From:To:Subject:Date:From;
        b=FcvAFEcpQG+hVWuFf4mNoDHRq4+WTpCBntWRzJRahohBlIUc2wuy625Jr5dJ5BUIH
         8/HRn5AipPxEoUSsellO0Y+Uhjn6oROImCjZQ7iCUnq/qQNQ/podkjBTGEuWuqTPrF
         HNeQ41STtOUDyMEFdfcJ8sf1nmb7Mun+tprD2o9oeKEuaNDWhfgQWK4nm9JbKufoso
         hrNxOiam7FjWIPIRM6UZ0nZ66hpF7md2acvPyiJGHeHTTfKXGsJx7kqhKZ0GmDde5Q
         ZQx6DjAAjw/3ZZ3AlxZ9mBirBvN70Lmuon7ttfG07Ucd0N2zy7anetDi8awb8tK924
         w52TetU+jb9zw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D7B8CC43144; Tue,  9 May 2023 14:04:32 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217424] New: TSC synchronization issue in VM restore
Date:   Tue, 09 May 2023 14:04:32 +0000
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
Message-ID: <bug-217424-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217424

            Bug ID: 217424
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
