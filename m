Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAA956AF4B
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 02:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbiGHAHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 20:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237040AbiGHAHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 20:07:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D04F6EE92
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 17:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08143625CA
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 00:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CB98C341CA
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 00:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657238853;
        bh=nBZtOcAnVbYnARGT/oo/ZIRqbJ4smIwV/qirbbVu71I=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=U12i02JrPmE5+WPdn6edCt/CqyrQuNguGJzbY59wHyTc97hQlCn/KG53rqVYP4rJe
         POEq41Zy5yz4dibLXwiMqcdkMaAFcGaet/vLX+WaXHJksH/28SjO5cGr8O38PhI4tX
         nk38HaGJ7g4sgGT5f5XISGn7yPi9dHbOzPsKdx43OtKHDmEp3CTQ8yNNUEnKn5EYWN
         oMCqAiZVTEF0djojpW+y7DhyT/9dKXVmZuhWzcLmjn7uUjXxbtVW19C7CEC5DmTfoA
         uwpIl0ZzApat7fE2qTn4dTJ+ggg+QbUW+gdXjuzm1+jaYb1xa3Z9RBlMJR9t5Wvcjl
         iGrj9p/qo4Vfw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 424D5CC13B1; Fri,  8 Jul 2022 00:07:33 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216212] KVM does not handle nested guest enable PAE paging
 correctly when CR3 is not mapped in EPT
Date:   Fri, 08 Jul 2022 00:07:33 +0000
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
Message-ID: <bug-216212-28872-2bMFm9XnKi@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216212-28872@https.bugzilla.kernel.org/>
References: <bug-216212-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216212

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
On Thu, Jul 07, 2022, bugzilla-daemon@kernel.org wrote:
> Likely stack trace and cause of this bug (Linux source code version is
> 5.18.9):
>=20
> Stack trace:
>=20
> handle_cr
>     kvm_set_cr0
>         load_pdptrs
>             kvm_translate_gpa

Yeah, load_pdptrs() needs to call kvm_inject_emulated_page_fault() to injec=
t a
TDP fault if translating the L2 GPA to an L1 GPA fails.  That part is easy =
to
fix,
but communicating up the stack that the instruction has already faulted is
going
to be painful due to the use of kvm_complete_insn_gp().  Ugh, and the emula=
tor
gets
involved too.

Not that it makes things worse than they already are, but I'm pretty sure M=
OV
CR3
(via the emulator) and MOV CR4 are also affected.

I suspect the least awful solution will be to use proper error codes instea=
d of
0/1
so that kvm_complete_insn_gp() and friends can differentiate between "succe=
ss",
"injected #GP", and "already exploded", but it's still going to require a l=
ot
of
churn.

A more drastic, but maybe less painful (though as I type this out, it's
becoming
ridiculously painful) alternative would be to not intercept CR0/CR4 paging =
bits
when running L2 and TDP is enabled, which would in theory allow KVM to drop
the call to kvm_translate_gpa().  load_pdptrs() would still be reachable via
the
emulator, but I think iff the guest is playing TLB, so KVM could probably j=
ust
resume the guest in that case.

The primary reason KVM intercepts CR0/CR4 paging bits even when using TDP i=
s so
that KVM doesn't need to refresh state to do software gva->gpa walks, e.g. =
to
correctly emulate memory accesses and reserved PTE bits.  The argument for
intercepting is that changing paging modes is a rare guest operation, where=
as
emulating some form of memory access is relatively common.  And it's also
simpler
in the sense that KVM can use common code for TDP and !TDP (shadow paging
heavily
depends on caching paging state).

But emulating on behalf of L2 is quite rare, and having to deal with this b=
ug
counters the "it's simpler" argument to some extent.  I _think_ ensuring the
nested
MMU is properly initialized could be solved by adding a nested_gva_to_gpa()
wrapper
instead of directly wiring mmu->gva_to_gpa() to the correct helper.

The messier part would be handling intercepts.  VMX would have to adjust
vmcs02.CRx_READ_SHADOW and resume the guest to deal with incidental
interception,
e.g. if the guest toggles both CR0.CD and CR0.PG.  SVM is all or nothing for
intercepts, but PAE under NPT isn't required to load PDTRs at MOV CR, so we
could
just drop that entire path for SVM+NPT.  But that would rely on KVM correct=
ly
handling L1 NPT faults during PDPTE accesses on behalf of L2, which of cour=
se
KVM
doesn't get right.

So yeah, maybe KVM can avoid some of the PAE pain in the long term if KVM s=
tops
intercepting CR0/CR4 paging bits, but it's probably a bad idea for an immed=
iate
fix.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
