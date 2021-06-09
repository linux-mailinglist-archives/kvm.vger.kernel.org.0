Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E293A1D4E
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFIS7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:59:38 -0400
Received: from mail-qv1-f73.google.com ([209.85.219.73]:39561 "EHLO
        mail-qv1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhFIS7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:59:37 -0400
Received: by mail-qv1-f73.google.com with SMTP id v19-20020a0ce1d30000b02902187ed4452eso18677400qvl.6
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=MlC9ib6BWZ1SQ+m8RRmgEx61BN+UBV2tfZiRoTbHe5Y=;
        b=LOwliij4l96HVDBUBuAoGJGIq9xZyjVSeLxtVyPgGvsipzIUFqBnsxLWlGfuIy2ea2
         mU2Cwu/bzquiEOVuBZIPtX/swXo0zIAl9J+vF494+e3LhvZ+5czU1U2Kw1PBofsE0E/V
         rfUcrEb7kam0WhSQm6fVc03IePb7EdQysA4TlgIwJ606bLxeT8nMdCTfNZieklvYhuIU
         8/MI4fPcmZOjhMl/K/jguGSqwn99sYZGyCIhWbwsbYIL6bjanwLXLmvNk7v5bWrmbLZH
         IDyo9HHVmbtfGEanRpJ5/34RgReOdB9M7frt9wjxkZZMoAY4GSZ8GkpEMHy6x43WYYYU
         1ZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=MlC9ib6BWZ1SQ+m8RRmgEx61BN+UBV2tfZiRoTbHe5Y=;
        b=DVpbHimE/7axUzW4/ty8hRUGjmHhwb+Ie3ExaoY9CBmZsm/GdTN7mrTNw1dwtH9+q3
         91fhy/+31lOHGekstulHSyYXxtNgXMT493INcDQJwoOdQY9pOkUBnEwRcotebBi7R6Iy
         HwZwYOUZH58jnE4UpkuuVCdaKA+9hEomyBH76Qzm3PRH2Wtq5AbEuR2zAEz5zjjQCou/
         UFiLnVspYEUrTm+0Yk1a6RarmBdaTtPRrRlFiJo2po/VOInq7ILCA1g3zp/DXCMh5+vL
         vbu1pJ5qvY6HS3ETn+fUjYomfQv8wXJgtw0Jm8vjhAwQvhnTbsBOTEzA69pxGP0pko7k
         BCrg==
X-Gm-Message-State: AOAM533/+5DKh+dxgueDL7MQ2xfS3W1JIySRIEcV9NB+RGUM+/FnFWLT
        ls3oqfSByc7y/Wh4ftxxG7bt3XvXxhk=
X-Google-Smtp-Source: ABdhPJxecFRO7FHC/BWyaQhG0QceH33FWaUEmMSdz3X87cK31Nfykv4xoUHrAWmwEOn9qokGwKOw6E4gbLE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:bfdc:c2e5:77b1:8ef3])
 (user=seanjc job=sendgmr) by 2002:a0c:fb4b:: with SMTP id b11mr1439874qvq.51.1623265002049;
 Wed, 09 Jun 2021 11:56:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 11:56:15 -0700
In-Reply-To: <20210609185619.992058-1-seanjc@google.com>
Message-Id: <20210609185619.992058-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210609185619.992058-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 5/9] KVM: x86: Move (most) SMM hflags modifications into kvm_smm_changed()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the core of SMM hflags modifications into kvm_smm_changed() and use
kvm_smm_changed() in enter_smm().  Clear HF_SMM_INSIDE_NMI_MASK for
leaving SMM but do not set it for entering SMM.  If the vCPU is executing
outside of SMM, the flag should unequivocally be cleared, e.g. this
technically fixes a benign bug where the flag could be left set after
KVM_SET_VCPU_EVENTS, but the reverse is not true as NMI blocking depends
on pre-SMM state or userspace input.

Note, this adds an extra kvm_mmu_reset_context() to enter_smm().  The
extra/early reset isn't strictly necessary, and in a way can never be
necessary since the vCPU/MMU context is in a half-baked state until the
final context reset at the end of the function.  But, enter_smm() is not
a hot path, and exploding on an invalid root_hpa is probably better than
having a stale SMM flag in the MMU role; it's at least no worse.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76ba28865824..13a33c962657 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4457,7 +4457,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	memset(&events->reserved, 0, sizeof(events->reserved));
 }
 
-static void kvm_smm_changed(struct kvm_vcpu *vcpu);
+static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm);
 
 static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 					      struct kvm_vcpu_events *events)
@@ -4517,13 +4517,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		vcpu->arch.apic->sipi_vector = events->sipi_vector;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
-		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
-			if (events->smi.smm)
-				vcpu->arch.hflags |= HF_SMM_MASK;
-			else
-				vcpu->arch.hflags &= ~HF_SMM_MASK;
-			kvm_smm_changed(vcpu);
-		}
+		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm)
+			kvm_smm_changed(vcpu, events->smi.smm);
 
 		vcpu->arch.smi_pending = events->smi.pending;
 
@@ -7108,8 +7103,7 @@ static void emulator_exiting_smm(struct x86_emulate_ctxt *ctxt)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 
-	vcpu->arch.hflags &= ~(HF_SMM_MASK | HF_SMM_INSIDE_NMI_MASK);
-	kvm_smm_changed(vcpu);
+	kvm_smm_changed(vcpu, false);
 }
 
 static int emulator_pre_leave_smm(struct x86_emulate_ctxt *ctxt,
@@ -7438,9 +7432,13 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 static int complete_emulated_mmio(struct kvm_vcpu *vcpu);
 static int complete_emulated_pio(struct kvm_vcpu *vcpu);
 
-static void kvm_smm_changed(struct kvm_vcpu *vcpu)
+static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 {
-	if (!(vcpu->arch.hflags & HF_SMM_MASK)) {
+	if (entering_smm) {
+		vcpu->arch.hflags |= HF_SMM_MASK;
+	} else {
+		vcpu->arch.hflags &= ~(HF_SMM_MASK | HF_SMM_INSIDE_NMI_MASK);
+
 		/* This is a good place to trace that we are exiting SMM.  */
 		trace_kvm_enter_smm(vcpu->vcpu_id, vcpu->arch.smbase, false);
 
@@ -8912,7 +8910,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	 */
 	static_call(kvm_x86_pre_enter_smm)(vcpu, buf);
 
-	vcpu->arch.hflags |= HF_SMM_MASK;
+	kvm_smm_changed(vcpu, true);
 	kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, buf, sizeof(buf));
 
 	if (static_call(kvm_x86_get_nmi_mask)(vcpu))
-- 
2.32.0.rc1.229.g3e70b5a671-goog

