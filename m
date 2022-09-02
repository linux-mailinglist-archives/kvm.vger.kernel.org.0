Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12B85AB8AA
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 21:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiIBTBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 15:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiIBTAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:00:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A141C792DC
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C216B82D27
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 19:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F218CC433B5
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 19:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662145213;
        bh=NvE7EpngvgCHOYLk4nel5oW+94+0683fRmV1xEdhBcg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=sXVvxFDACNhlbupPSuCuyZNF74pX6ljwZPwt3lPE2yznEzEubH0E/RsWZRL3OdSTx
         5pNN9EuQViXmt4sG/Ti9UNU/AL+5c70DVEF4y9sCuUpMJOw/NsV8fzEXK/TbkS6WyC
         ZTMr0wVlV6UFctWwqZgs6y89o6tG6NYF2c/iwWRSTpDraX5D+MdxLP3SbMqQIs1Of0
         jPVMYdwP9yPi5vX4gB4PhSbgITCcKgLJUuoaQil/XeAu/nFnQBVmED/zrZqyVRlD/h
         4T9oaxRymErc6uE+bdJrB9rsetudJ+ISfAbDF7OuJGck8VQYypz67f+2yPbhkQmKzZ
         /VDWu5oB5mjOg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DBFF4C04231; Fri,  2 Sep 2022 19:00:12 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216033] KVM VMX nested virtualization: VMXON does not check
 guest CR0 against IA32_VMX_CR0_FIXED0
Date:   Fri, 02 Sep 2022 19:00:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216033-28872-hPMAGWd52K@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216033-28872@https.bugzilla.kernel.org/>
References: <bug-216033-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216033

--- Comment #3 from Sean Christopherson (seanjc@google.com) ---
On Fri, Sep 02, 2022, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216033
>=20
> --- Comment #2 from Eric Li (ercli@ucdavis.edu) ---
> @Sean Christopherson Thanks for submitting the fix to this bug in
> https://lore.kernel.org/lkml/20220607213604.3346000-4-seanjc@google.com/ .
> However, I recently tested this fix and the behavior is not as expected.
>=20
> According to Intel's SDM, VMXON may generate 2 types of exceptions:
>=20
>     IF (register operand) or (CR0.PE =3D 0) or (CR4.VMXE =3D 0) or ...
>         THEN #UD;
>     ELSIF not in VMX operation
>         THEN
>             IF (CPL > 0) or (in A20M mode) or
>             (the values of CR0 and CR4 are not supported in VMX operation=
 ...
>                 THEN #GP(0);
>=20
> For example, when CR4 value is incorrect, different exceptions may be
> generated
> depending on which bit is incorrect. If CR4.VMXE =3D 0, #UD should be
> generated.
> Otherwise, #GP(0) should be generated. However, after the fix, #UD is alw=
ays
> generated.

/facepalm

All that and I overlooked that the other CR0/CR4 checks take a #GP.

On the bright side, it does mean I can blame Jim at least a little bit for
commit
70f3aac964ae ("kvm: nVMX: Remove superfluous VMX instruction fault checks").

Untested, but this should do the trick.

---
 arch/x86/kvm/vmx/nested.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ddd4367d4826..86ee2ab8a497 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4936,25 +4936,32 @@ static int handle_vmxon(struct kvm_vcpu *vcpu)
                | FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;

        /*
-        * Note, KVM cannot rely on hardware to perform the CR0/CR4 #UD che=
cks
-        * that have higher priority than VM-Exit (see Intel SDM's pseudoco=
de
-        * for VMXON), as KVM must load valid CR0/CR4 values into hardware
while
-        * running the guest, i.e. KVM needs to check the _guest_ values.
+        * Note, KVM cannot rely on hardware to perform the CR0.PE and CR4.=
VMXE
+        * #UD checks that have higher priority than VM-Exit (see Intel SDM=
's
+        * pseudocode for VMXON), as KVM must load valid CR0/CR4 values into
+        * hardware while running the guest, i.e. KVM needs to check the
_guest_
+        * values.
         *
         * Rely on hardware for the other two pre-VM-Exit checks, !VM86 and
         * !COMPATIBILITY modes.  KVM may run the guest in VM86 to emulate =
Real
         * Mode, but KVM will never take the guest out of those modes.
         */
+       if (!kvm_read_cr4_bits(vcpu, X86_CR4_VMXE) ||
+           !kvm_read_cr0_bits(vcpu, X86_CR0_PE)) {
+               kvm_queue_exception(vcpu, UD_VECTOR);
+               return 1;
+       }
+
+       /*
+        * All other checks that are lower priority than VM-Exit must be
+        * checked manually, including the other CR0/CR4 reserved bit check=
s.
+        */
        if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
            !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
                kvm_queue_exception(vcpu, UD_VECTOR);
                return 1;
        }

-       /*
-        * CPL=3D0 and all other checks that are lower priority than VM-Exi=
t must
-        * be checked manually.
-        */
        if (vmx_get_cpl(vcpu)) {
                kvm_inject_gp(vcpu, 0);
                return 1;

base-commit: 476d5fb78ea6438941559af4814a2795849cb8f0

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
