Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C0446C3A7
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 20:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhLGTdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 14:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbhLGTdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 14:33:44 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0BAC061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 11:30:14 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x1-20020a17090a294100b001a6e7ba6b4eso146908pjf.9
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 11:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc:content-transfer-encoding;
        bh=RZDJdEo+TXj2k+dSVCDQ2AzEguTcyw2uS1wCo1ivZ6E=;
        b=mBjkjnzZHSw5a5m8R3udoCtgp44Odl07DeMSiUH1hMeDTY3cZRx+OzSGy74poZRguH
         avjhu1fbqWUgXT9AFLOfBv86tFDld/oWN5Nqa3TO+dnNA7szD2BkuAMLgGFbzxh2XrWT
         JMVCwZhgZx9hBDC2eMzZLcLz+jcPCmjhgD9RaHyYL0J2i7w3ZrO7eP3KxUX2WPzPZGtq
         dWGq3tsi3PIGW6u6thTVXBNq5Iw8ceoUVfLoibtgXAQojUXATxvDyyQJPkJpuf6kwwTm
         IXz8NuCLAqxqj49ivPPxcMrsymAqfcpBb8zqK2gSVXSyj/mGU2D24/sMTVTdeh34GX+2
         qn6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc
         :content-transfer-encoding;
        bh=RZDJdEo+TXj2k+dSVCDQ2AzEguTcyw2uS1wCo1ivZ6E=;
        b=KExlSQm+moSFilXffu9ZU3y3iN0KvXU6zNKS770o4jqne6bAp23atZtgbM32BES44q
         hOOJLEC7Kv85u9h1LnjnHA9Smoc/nnCHQxdo/9h9rj486pNTS5CNEW6nPxvw3AvOEARC
         +Zo8USn1ExqKjvwnpoBxOET2ee84M7CFuDmq84v/drZm3xDkUYqmvLOR+NfcCHEcdobT
         kK9/zu1rGXT/PZdCSAr1HAgm2O9pflaJRNQnkZ0o6SWNweIihLtW+Hz657FwGdUs9p/j
         KJplyzjspE0V/rLpbcC5hY1JWOgW5hzdn5QHouUOMbyO80qQZd3aHO7O05y+rGXl4B6g
         ldxQ==
X-Gm-Message-State: AOAM5309t3Xv4k7kO6UjDmiLooIbDEh/Sz7FETQZuI/E2CnHZasmFDvi
        aIzlQUaxNJzcg1p7fijso7pdtkQF2PI=
X-Google-Smtp-Source: ABdhPJx1dKXLJ1J8xSJh33rqAW9M81Lcs2HDhE5aYy0GtuIRFRx02N0+peN4fL+20jn4FIZKd5wfkycE7b4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9a4a:b0:146:8ce2:672 with SMTP id
 x10-20020a1709029a4a00b001468ce20672mr8980672plv.29.1638905413619; Tue, 07
 Dec 2021 11:30:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Dec 2021 19:30:04 +0000
In-Reply-To: <20211207193006.120997-1-seanjc@google.com>
Message-Id: <20211207193006.120997-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211207193006.120997-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 2/4] KVM: nVMX: Synthesize TRIPLE_FAULT for L2 if emulation is required
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Synthesize a triple fault if L2 guest state is invalid at the time of
VM-Enter, which can happen if L1 modifies SMRAM or if userspace stuffs
guest state via ioctls(), e.g. KVM_SET_SREGS.  KVM should never emulate
invalid guest state, since from L1's perspective, it's architecturally
impossible for L2 to have invalid state while L2 is running in hardware.
E.g. attempts to set CR0 or CR4 to unsupported values will either VM-Exit
or #GP.

Modifying vCPU state via RSM+SMRAM and ioctl() are the only paths that
can trigger this scenario, as nested VM-Enter correctly rejects any
attempt to enter L2 with invalid state.

RSM is a straightforward case as (a) KVM follows AMD's SMRAM layout and
behavior, and (b) Intel's SDM states that loading reserved CR0/CR4 bits
via RSM results in shutdown, i.e. there is precedent for KVM's behavior.
Following AMD's SMRAM layout is important as AMD's layout saves/restores
the descriptor cache information, including CS.RPL and SS.RPL, and also
defines all the fields relevant to invalid guest state as read-only, i.e.
so long as the vCPU had valid state before the SMI, which is guaranteed
for L2, RSM will generate valid state unless SMRAM was modified.  Intel's
layout saves/restores only the selector, which means that scenarios where
the selector and cached RPL don't match, e.g. conforming code segments,
would yield invalid guest state.  Intel CPUs fudge around this issued by
stuffing SS.RPL and CS.RPL on RSM.  Per Intel's SDM on the "Default
Treatment of RSM", paraphrasing for brevity:

  IF internal storage indicates that the [CPU was post-VMXON]
  THEN
     enter VMX operation (root or non-root);
     restore VMX-critical state as defined in Section 34.14.1;
     set to their fixed values any bits in CR0 and CR4 whose values must
     be fixed in VMX operation [unless coming from an unrestricted guest];
     IF RFLAGS.VM =3D 0 AND (in VMX root operation OR the
        =E2=80=9Cunrestricted guest=E2=80=9D VM-execution control is 0)
     THEN
       CS.RPL :=3D SS.DPL;
       SS.RPL :=3D SS.DPL;
     FI;
     restore current VMCS pointer;
  FI;

Note that Intel CPUs also overwrite the fixed CR0/CR4 bits, whereas KVM
will sythesize TRIPLE_FAULT in this scenario.  KVM's behavior is allowed
as both Intel and AMD define CR0/CR4 SMRAM fields as read-only, i.e. the
only way for CR0 and/or CR4 to have illegal values is if they were
modified by the L1 SMM handler, and Intel's SDM "SMRAM State Save Map"
section states "modifying these registers will result in unpredictable
behavior".

KVM's ioctl() behavior is less straightforward.  Because KVM allows
ioctls() to be executed in any order, rejecting an ioctl() if it would
result in invalid L2 guest state is not an option as KVM cannot know if
a future ioctl() would resolve the invalid state, e.g. KVM_SET_SREGS, or
drop the vCPU out of L2, e.g. KVM_SET_NESTED_STATE.  Ideally, KVM would
reject KVM_RUN if L2 contained invalid guest state, but that carries the
risk of a false positive, e.g. if RSM loaded invalid guest state and KVM
exited to userspace.  Setting a flag/request to detect such a scenario is
undesirable because (a) it's extremely unlikely to add value to KVM as a
whole, and (b) KVM would need to consider ioctl() interactions with such
a flag, e.g. if userspace migrated the vCPU while the flag were set.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9e415e5a91ab..5307fcee3b3b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5900,18 +5900,14 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu,=
 fastpath_t exit_fastpath)
 		vmx_flush_pml_buffer(vcpu);
=20
 	/*
-	 * We should never reach this point with a pending nested VM-Enter, and
-	 * more specifically emulation of L2 due to invalid guest state (see
-	 * below) should never happen as that means we incorrectly allowed a
-	 * nested VM-Enter with an invalid vmcs12.
+	 * KVM should never reach this point with a pending nested VM-Enter.
+	 * More specifically, short-circuiting VM-Entry to emulate L2 due to
+	 * invalid guest state should never happen as that means KVM knowingly
+	 * allowed a nested VM-Enter with an invalid vmcs12.  More below.
 	 */
 	if (KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm))
 		return -EIO;
=20
-	/* If guest state is invalid, start emulating */
-	if (vmx->emulation_required)
-		return handle_invalid_guest_state(vcpu);
-
 	if (is_guest_mode(vcpu)) {
 		/*
 		 * PML is never enabled when running L2, bail immediately if a
@@ -5933,10 +5929,30 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu,=
 fastpath_t exit_fastpath)
 		 */
 		nested_mark_vmcs12_pages_dirty(vcpu);
=20
+		/*
+		 * Synthesize a triple fault if L2 state is invalid.  In normal
+		 * operation, nested VM-Enter rejects any attempt to enter L2
+		 * with invalid state.  However, those checks are skipped if
+		 * state is being stuffed via RSM or KVM_SET_NESTED_STATE.  If
+		 * L2 state is invalid, it means either L1 modified SMRAM state
+		 * or userspace provided bad state.  Synthesize TRIPLE_FAULT as
+		 * doing so is architecturally allowed in the RSM case, and is
+		 * the least awful solution for the userspace case without
+		 * risking false positives.
+		 */
+		if (vmx->emulation_required) {
+			nested_vmx_vmexit(vcpu, EXIT_REASON_TRIPLE_FAULT, 0, 0);
+			return 1;
+		}
+
 		if (nested_vmx_reflect_vmexit(vcpu))
 			return 1;
 	}
=20
+	/* If guest state is invalid, start emulating.  L2 is handled above. */
+	if (vmx->emulation_required)
+		return handle_invalid_guest_state(vcpu);
+
 	if (exit_reason.failed_vmentry) {
 		dump_vmcs(vcpu);
 		vcpu->run->exit_reason =3D KVM_EXIT_FAIL_ENTRY;
--=20
2.34.1.400.ga245620fadb-goog

