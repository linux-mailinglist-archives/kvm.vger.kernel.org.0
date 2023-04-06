Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1EB6DA0CA
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 21:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240547AbjDFTOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 15:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240332AbjDFTO1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 15:14:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3DB211F
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 12:14:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D363643F8
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 19:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A36BCC433A0
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 19:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808465;
        bh=tUJS5FqgfSdGL0XmZdaZdPp5IGbXOJurU/M5m5V/EXY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kNovv9anETlftfXY+uu5Oa0HVKe0pqGK4QP8AXhGk2V52edIlYsPAuOLVW9Sp6Kv9
         3h7Bxc3VFa0D8X0TQr6QcW1gA0gEj7P8otUBS7UczoCs0BniL8ApP1zuhaRq2JFw/0
         HdB3qdAIdJxY47jw8mA99SBYUNiEaT7Js3ShCqhFfaKqLOWTpjKtYW/wn7JzYdZzQ5
         tcGc97CAY4o4PSmSxWmKEJxD0eDloKO/quDOqNpqVPHejCQkwDxtkVmA+P48TdxGpK
         BPZHssQJP/mzRc8MUQcxTdr0dzSFpNByvP7uvhAdD7mpqRVKNU8vq0kNgxri7v8lCY
         Eu7cEs+nZNSSQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8ACB0C43165; Thu,  6 Apr 2023 19:14:25 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217304] KVM does not handle NMI blocking correctly in nested
 virtualization
Date:   Thu, 06 Apr 2023 19:14:25 +0000
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
Message-ID: <bug-217304-28872-obRYeQMhMS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217304-28872@https.bugzilla.kernel.org/>
References: <bug-217304-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217304

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
On Thu, Apr 06, 2023, bugzilla-daemon@kernel.org wrote:
> Assume KVM runs in L0, LHV runs in L1, the nested guest runs in L2.
>=20
> The code in LHV performs an experiment (called "Experiment 13" in serial
> output) on CPU 0 to test the behavior of NMI blocking. The experiment ste=
ps
> are:
> 1. Prepare state such that the CPU is currently in L1 (LHV), and NMI is
> blocked
> 2. Modify VMCS12 to make sure that L2 has virtual NMIs enabled (NMI exiti=
ng =3D
> 1, Virtual NMIs =3D 1), and L2 does not block NMI (Blocking by NMI =3D 0)
> 3. VM entry to L2
> 4. L2 performs VMCALL, get VM exit to L1
> 5. L1 checks whether NMI is blocked.
>=20
> The expected behavior is that NMI should be blocked, which is reproduced =
on
> real hardware. According to Intel SDM, NMIs should be unblocked after VM
> entry
> to L2 (step 3). After VM exit to L1 (step 4), NMI blocking does not chang=
e,
> so
> NMIs are still unblocked. This behavior is reproducible on real hardware.
>=20
> However, when running on KVM, the experiment shows that at step 5, NMIs a=
re
> blocked in L1. Thus, I think NMI blocking is not implemented correctly in
> KVM's
> nested virtualization.

Ya, KVM blocks NMIs on nested NMI VM-Exits, but doesn't unblock NMIs for all
other
exit types.  I believe this is the fix (untested):

---
 arch/x86/kvm/vmx/nested.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 96ede74a6067..4240a052628a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4164,12 +4164,7 @@ static int vmx_check_nested_events(struct kvm_vcpu
*vcpu)
                nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
                                  NMI_VECTOR | INTR_TYPE_NMI_INTR |
                                  INTR_INFO_VALID_MASK, 0);
-               /*
-                * The NMI-triggered VM exit counts as injection:
-                * clear this one and block further NMIs.
-                */
                vcpu->arch.nmi_pending =3D 0;
-               vmx_set_nmi_mask(vcpu, true);
                return 0;
        }

@@ -4865,6 +4860,13 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32
vm_exit_reason,
                                INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
                }

+               /*
+                * NMIs are blocked on VM-Exit due to NMI, and unblocked by=
 all
+                * other VM-Exit types.
+                */
+               vmx_set_nmi_mask(vcpu, (u16)vm_exit_reason =3D=3D
EXIT_REASON_EXCEPTION_NMI &&
+                                      !is_nmi(vmcs12->vm_exit_intr_info));
+
                if (vm_exit_reason !=3D -1)
                        trace_kvm_nested_vmexit_inject(vmcs12->vm_exit_reas=
on,
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
vmcs12->exit_qualification,

base-commit: 0b87a6bfd1bdb47b766aa0641b7cf93f3d3227e9

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
