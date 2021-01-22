Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8019F30113A
	for <lists+kvm@lfdr.de>; Sat, 23 Jan 2021 00:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbhAVXyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 18:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbhAVXwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 18:52:32 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75362C061793
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 15:51:01 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id m8so5001304qvt.14
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 15:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9HbYgD5kKLF76E9UKDJgPHiC7w7cXDOH2uRR80TQ++M=;
        b=AE7iUuGS1m8Sp+o5DCp0RddSP+E0iHcSBOlAHoenw9iBHFl8iMuY+9NPpYdHZRB100
         Uy3FMD4EuqVzghsnPSLz7K0HgtS9LjPBrYYjHQPylwS3IF35Sfxeb6rUCKvrMUxlyRw6
         MALKKDKzIn0eJOpZ1RdvJacxv0iM9t7PA+ysLohcflK+2tsByabpmdZoUJ5eQ158KHgN
         Y9StW2WOQT/IUs4eDwtafQGVjYdcUp68vC45HVLRJkh8KTOjOOxUdVtSBwLI3MVkTVP8
         KXZkFvfWlA/p0ju9IpmrS5YDMQ1kzY/qGmwS+gGmPH8crom4zF6bMw/HAZ5OQbnu4MVP
         KxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9HbYgD5kKLF76E9UKDJgPHiC7w7cXDOH2uRR80TQ++M=;
        b=ale3WuN7KqGpaTWL3SDXNypDF4R0e9BdLxpZL+PVJZtnrg48gf67S83J4boDOXx9d8
         9l+oGnWphHPz7Gvri1/O11XR1PnnN3wKnA+mU2SXzL5sNagUDKiofA12Fjev442C0B2I
         gJ3gasPupJiJz7QwNJXGvK13/N9Nsjjvupk3iVePL/5Q6erYUXkap7bX2+etOTxowFr9
         O9VC9qudE7PGlUx3kI5Cz8gbMUdh//Uwckp9BFrLUX+v1ym1rbz3dgImZ89nyo7W012N
         9wSIohfcpanUoYaAPmipUuz67AmCKrn9qO0xgw4hFhQ3n+1h9P/22NnRWwk6owlDGnmZ
         RIIQ==
X-Gm-Message-State: AOAM533YiycBbNEH1KtonmFJLKUZMJ8h1e77Cc+5rmwMrkuyJR7Irauk
        QJci13i/TA7zj8VrDOT02lOEQd9rvgA=
X-Google-Smtp-Source: ABdhPJw45xfbWk0/F1Ioz6RnLEPQgDuhUe6NW4Te0ZVGomPG8tHNq57wsrgLqjRa0ChnDaPM5CiLy3LL50o=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a0c:e5d1:: with SMTP id u17mr3253789qvm.34.1611359460666;
 Fri, 22 Jan 2021 15:51:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 15:50:47 -0800
In-Reply-To: <20210122235049.3107620-1-seanjc@google.com>
Message-Id: <20210122235049.3107620-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210122235049.3107620-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH 1/3] KVM: SVM: Unconditionally sync GPRs to GHCB on VMRUN of
 SEV-ES guest
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the per-GPR dirty checks when synchronizing GPRs to the GHCB, the
GRPs' dirty bits are set from time zero and never cleared, i.e. will
always be seen as dirty.  The obvious alternative would be to clear
the dirty bits when appropriate, but removing the dirty checks is
desirable as it allows reverting GPR dirty+available tracking, which
adds overhead to all flavors of x86 VMs.

Note, unconditionally writing the GPRs in the GHCB is tacitly allowed
by the GHCB spec, which allows the hypervisor (or guest) to provide
unnecessary info; it's the guest's responsibility to consume only what
it needs (the hypervisor is untrusted after all).

  The guest and hypervisor can supply additional state if desired but
  must not rely on that additional state being provided.

Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c8ffdbc81709..ac652bc476ae 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1415,16 +1415,13 @@ static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
 	 * to be returned:
 	 *   GPRs RAX, RBX, RCX, RDX
 	 *
-	 * Copy their values to the GHCB if they are dirty.
+	 * Copy their values, even if they may not have been written during the
+	 * VM-Exit.  It's the guest's responsibility to not consume random data.
 	 */
-	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RAX))
-		ghcb_set_rax(ghcb, vcpu->arch.regs[VCPU_REGS_RAX]);
-	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RBX))
-		ghcb_set_rbx(ghcb, vcpu->arch.regs[VCPU_REGS_RBX]);
-	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RCX))
-		ghcb_set_rcx(ghcb, vcpu->arch.regs[VCPU_REGS_RCX]);
-	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RDX))
-		ghcb_set_rdx(ghcb, vcpu->arch.regs[VCPU_REGS_RDX]);
+	ghcb_set_rax(ghcb, vcpu->arch.regs[VCPU_REGS_RAX]);
+	ghcb_set_rbx(ghcb, vcpu->arch.regs[VCPU_REGS_RBX]);
+	ghcb_set_rcx(ghcb, vcpu->arch.regs[VCPU_REGS_RCX]);
+	ghcb_set_rdx(ghcb, vcpu->arch.regs[VCPU_REGS_RDX]);
 }
 
 static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
-- 
2.30.0.280.ga3ce27912f-goog

