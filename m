Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223B142B103
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 02:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbhJMAiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 20:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235857AbhJMAiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 20:38:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4198C061746
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 17:35:59 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i83-20020a252256000000b005b67a878f56so1303394ybi.17
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 17:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=wxPVd2YVM/NV0asUXGPhCOW1ghR651HdWV4ElxJE6gI=;
        b=BxMTJvKfefjN4GsOhLv3KwTFZjuGV0g4plDr+hxNIU/6b6FpXj1B1VBkglSDgEM7yM
         a2sr+kSu2llNOIjZ3b39v18I05joRRnJUv3UhyaiM/jLpyMRa2zFeYlFA75JJmn5G1ze
         RGm/ejnls7Cm4zcY04oMqSgWn7Kkr+zfFkIa7jr4v493BpZVKSlMucG3DEUFioDO7qJ5
         8/M95pDMzVjRnrRHaEXit7C63gpQe+2VMVhz5Ba8sHqCT1V5ogWcUICQ00xq7Oh6QBQy
         rLZY+8z7VpnjqYT+wjKoSFX+YrNDZkegWwKzFsKX2xIbhgy8n/QAHiKAVkIIlKZKSgpa
         NkzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=wxPVd2YVM/NV0asUXGPhCOW1ghR651HdWV4ElxJE6gI=;
        b=GmXLau5Ym33njw5KbCDIMer5ZVisjcaob+D84RE5B7/mNPboun+VTzL6s0GQUxHhkG
         n5kBzsbqzHbBRLWlQNYPeNrd/wXJgoB7/11Wc0t3VrSYT22qIY0x9PspEjyjUhpf+5Ro
         yIvZtql4Is6qye5XVS1zOOi9/WJfFQcoBkMK7GOtTLE0/kDAJeIPKXz13JiAOUA+saJq
         5uDLKYX6zdiKHN+0j4SDM8d1g4UxuhGtGtkSUKucA2ITQsgg2DoG7c9og60ZRrv9tF5H
         76+NqXuhBllIOL/xNH+MsVCfuHt4RD+AZIEZ5TJQMkZM5E6TyAdARGyOsiN+Prga7nkk
         cMaA==
X-Gm-Message-State: AOAM533o3Dn454UPhaCq5zYhp7JA78C+l3TgzRgpVa/G+qeC1q7kaH5s
        rwj5UZWRGTR6zCb69PLSRLXLqtso3H4=
X-Google-Smtp-Source: ABdhPJzMNDc6kxUZXz1K/Xeg/tMAR5mP8cW4h8DpwNn9ej0evGAsXq4YAHyGazXEjkCOtfc3F9r2dKrlFsM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e55e:31ed:7b83:d4a6])
 (user=seanjc job=sendgmr) by 2002:a25:ae66:: with SMTP id g38mr30498139ybe.536.1634085358944;
 Tue, 12 Oct 2021 17:35:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Oct 2021 17:35:53 -0700
In-Reply-To: <20211013003554.47705-1-seanjc@google.com>
Message-Id: <20211013003554.47705-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211013003554.47705-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH 1/2] Revert "KVM: x86: Open code necessary bits of
 kvm_lapic_set_base() at vCPU RESET"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+9fc046ab2b0cf295a063@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Revert a change to open code bits of kvm_lapic_set_base() when emulating
APIC RESET to fix an apic_hw_disabled underflow bug due to arch.apic_base
and apic_hw_disabled being unsyncrhonized when the APIC is created.  If
kvm_arch_vcpu_create() fails after creating the APIC, kvm_free_lapic()
will see the initialized-to-zero vcpu->arch.apic_base and decrement
apic_hw_disabled without KVM ever having incremented apic_hw_disabled.

Using kvm_lapic_set_base() in kvm_lapic_reset() is also desirable for a
potential future where KVM supports RESET outside of vCPU creation, in
which case all the side effects of kvm_lapic_set_base() are needed, e.g.
to handle the transition from x2APIC => xAPIC.

Alternatively, KVM could temporarily increment apic_hw_disabled (and call
kvm_lapic_set_base() at RESET), but that's a waste of cycles and would
impact the performance of other vCPUs and VMs.  The other subtle side
effect is that updating the xAPIC ID needs to be done at RESET regardless
of whether the APIC was previously enabled, i.e. kvm_lapic_reset() needs
an explicit call to kvm_apic_set_xapic_id() regardless of whether or not
kvm_lapic_set_base() also performs the update.  That makes stuffing the
enable bit at vCPU creation slightly more palatable, as doing so affects
only the apic_hw_disabled key.

Opportunistically tweak the comment to explicitly call out the connection
between vcpu->arch.apic_base and apic_hw_disabled, and add a comment to
call out the need to always do kvm_apic_set_xapic_id() at RESET.

Underflow scenario:

  kvm_vm_ioctl() {
    kvm_vm_ioctl_create_vcpu() {
      kvm_arch_vcpu_create() {
        if (something_went_wrong)
          goto fail_free_lapic;
        /* vcpu->arch.apic_base is initialized when something_went_wrong is false. */
        kvm_vcpu_reset() {
          kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event) {
            vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
          }
        }
        return 0;
      fail_free_lapic:
        kvm_free_lapic() {
          /* vcpu->arch.apic_base is not yet initialized when something_went_wrong is true. */
          if (!(vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE))
            static_branch_slow_dec_deferred(&apic_hw_disabled); // <= underflow bug.
        }
        return r;
      }
    }
  }

This (mostly) reverts commit 421221234ada41b4a9f0beeb08e30b07388bd4bd.

Fixes: 421221234ada ("KVM: x86: Open code necessary bits of kvm_lapic_set_base() at vCPU RESET")
Reported-by: syzbot+9fc046ab2b0cf295a063@syzkaller.appspotmail.com
Debugged-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 76fb00921203..7af25304bda9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2321,13 +2321,14 @@ EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
+	u64 msr_val;
 	int i;
 
 	if (!init_event) {
-		vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE |
-				       MSR_IA32_APICBASE_ENABLE;
+		msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
 		if (kvm_vcpu_is_reset_bsp(vcpu))
-			vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
+			msr_val |= MSR_IA32_APICBASE_BSP;
+		kvm_lapic_set_base(vcpu, msr_val);
 	}
 
 	if (!apic)
@@ -2336,11 +2337,9 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	/* Stop the timer in case it's a reset to an active apic */
 	hrtimer_cancel(&apic->lapic_timer.timer);
 
-	if (!init_event) {
-		apic->base_address = APIC_DEFAULT_PHYS_BASE;
-
+	/* The xAPIC ID is set at RESET even if the APIC was already enabled. */
+	if (!init_event)
 		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
-	}
 	kvm_apic_set_version(apic->vcpu);
 
 	for (i = 0; i < KVM_APIC_LVT_NUM; i++)
@@ -2481,6 +2480,11 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 		lapic_timer_advance_dynamic = false;
 	}
 
+	/*
+	 * Stuff the APIC ENABLE bit in lieu of temporarily incrementing
+	 * apic_hw_disabled; the full RESET value is set by kvm_lapic_reset().
+	 */
+	vcpu->arch.apic_base = MSR_IA32_APICBASE_ENABLE;
 	static_branch_inc(&apic_sw_disabled.key); /* sw disabled at reset */
 	kvm_iodevice_init(&apic->dev, &apic_mmio_ops);
 
-- 
2.33.0.1079.g6e70778dc9-goog

