Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78ACD3A1D4C
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhFIS7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:59:36 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:54240 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhFIS7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:59:35 -0400
Received: by mail-yb1-f202.google.com with SMTP id s186-20020a2577c30000b02905353e16ab17so32860670ybc.20
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qmBiYG2Q8fhlMt9vEycHJMHDLIYJ0FuvQVOhlHRcPKQ=;
        b=F75V2on7xGSHGc3PiOmR0dqrBKE8LlmZ30KRE72p0ddy5YdgfqhYt+i0zs4ZUNwcmf
         Ic8hgyG0bUOOGX6vUeCJbREq+QRz2mF9t6Ka3+vgrw+w/BawtxU7+wQFymMjd9jVzaEL
         Yf/br30ykbskmsFk3HZ2fGe9ojBKceFlyZmb1RW4WMNK/REP6Hqr/ZncYOdRPmtl2abU
         1cMIpqh6DNK4WUnSpXDSf171FBx2A8L47LZ5eligF0Qs0xoWuY0Xvh4x8eSV5oLnpHHD
         ukBIdhI75DJUQctT9oMnHibXgoZUCAjPTuzGGQNF5jlMr8j7E3ZzJRRaJRKRVZXb5mpZ
         7AUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qmBiYG2Q8fhlMt9vEycHJMHDLIYJ0FuvQVOhlHRcPKQ=;
        b=FoM5tRnymKd/kb2mrQFsxObdce0eiyMT1ei7ge0zU4Dg9nF22kfRANZxrbgOZphgE2
         7pNgsRLSPPRLFZa4dHp+qdcZsRiJbwfGAhRdM1uFJ4/XGnkE07rJN6wESci9B3FLLU7u
         4G/oh+D2tr0FRO42LKrvG9KGKArYsZ018YZOQVlD+sIa2xoejGR/RE3AobqdXdMBL6Ac
         Ic2QbZb94HV71Ezhy5vdmIvSUtKBqvTyrw21Z2ND9V34VXOE/YA02HLg01IDke0dMNH5
         cIsw0M4IRcs6gDnDUW8FTVdfHdUYV0EFhyd101Do+1F6w2ptRxMLxBfX5E1fGjKuK6E+
         HpEw==
X-Gm-Message-State: AOAM532SrbJ4ESgbHO080XG6ASU+usJYT22ZyI1ge5PEwRHAcnotg/NG
        lzvxH6cteygvwsO/xOXEqnrC2jkXVvU=
X-Google-Smtp-Source: ABdhPJy6xwXMm+i4eNVeH/U3OwdKvm3UqsFRa8RnRqIkX7DUC1cJfhlxygZ9lkhXeGaIXtMknGHuNUZ89qc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:bfdc:c2e5:77b1:8ef3])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4a2:: with SMTP id
 r2mr1955589ybs.286.1623265000119; Wed, 09 Jun 2021 11:56:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 11:56:14 -0700
In-Reply-To: <20210609185619.992058-1-seanjc@google.com>
Message-Id: <20210609185619.992058-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210609185619.992058-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 4/9] KVM: x86: Invoke kvm_smm_changed() immediately after
 clearing SMM flag
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

Move RSM emulation's call to kvm_smm_changed() from .post_leave_smm() to
.exiting_smm(), leaving behind the MMU context reset.  The primary
motivation is to allow for future cleanup, but this also fixes a bug of
sorts by queueing KVM_REQ_EVENT even if RSM causes shutdown, e.g. to let
an INIT wake the vCPU from shutdown.  Of course, KVM doesn't properly
emulate a shutdown state, e.g. KVM doesn't block SMIs after shutdown, and
immediately exits to userspace, so the event request is a moot point in
practice.

Moving kvm_smm_changed() also moves the RSM tracepoint.  This isn't
strictly necessary, but will allow consolidating the SMI and RSM
tracepoints in a future commit (by also moving the SMI tracepoint).
Invoking the tracepoint before loading SMRAM state also means the SMBASE
that reported in the tracepoint will point that the state that will be
used for RSM, as opposed to the SMBASE _after_ RSM completes, which is
arguably a good thing if the tracepoint is being used to debug a RSM/SMM
issue.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 69a71c5019c1..76ba28865824 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7109,7 +7109,7 @@ static void emulator_exiting_smm(struct x86_emulate_ctxt *ctxt)
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 
 	vcpu->arch.hflags &= ~(HF_SMM_MASK | HF_SMM_INSIDE_NMI_MASK);
-	kvm_mmu_reset_context(vcpu);
+	kvm_smm_changed(vcpu);
 }
 
 static int emulator_pre_leave_smm(struct x86_emulate_ctxt *ctxt,
@@ -7120,7 +7120,7 @@ static int emulator_pre_leave_smm(struct x86_emulate_ctxt *ctxt,
 
 static void emulator_post_leave_smm(struct x86_emulate_ctxt *ctxt)
 {
-	kvm_smm_changed(emul_to_vcpu(ctxt));
+	kvm_mmu_reset_context(emul_to_vcpu(ctxt));
 }
 
 static void emulator_triple_fault(struct x86_emulate_ctxt *ctxt)
-- 
2.32.0.rc1.229.g3e70b5a671-goog

