Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F303742754F
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 03:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244067AbhJIBDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 21:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbhJIBDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 21:03:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A10C061755
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 18:01:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 124-20020a251182000000b005a027223ed9so14737022ybr.13
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 18:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zwQuCdTORRqikJJrq1qC6FroomOZbrYRK1ulZL74DVc=;
        b=VPL6BD8DqplY2SY6r2wwMp6R71favIqg8UbS1freyl6PspIN7PB/XAXbzy7myyu/xy
         oLkUuGIFLCI0PF4R4nzPJ7dlO3VYAc966eOfv5YO3ZIDALOMl+AmWZEPBOnAdaG/jRi1
         cvV6OVK38x0C1lSI/rdvr2DPbRak4pKgdopBBCQyKs7wlCGEdkBA/PCwu1HoXVWv3r2G
         rwikWFuxpvFWMRorFycOR0xRJaCahXeDPl7+jSd8a/ZZOofDzvUergeS/N9oVr2I8i4z
         7f+4M5DoDcsCUfgpK5ztGpsmpVSAZ6zMTwkoMeXsCxRtlKOk1VpiKF3Sr/PMBJm81Wz1
         Vxcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zwQuCdTORRqikJJrq1qC6FroomOZbrYRK1ulZL74DVc=;
        b=sLrZG1kNJ62LFsyM+jYC0rO156uItlvNhR3fRuAizIHwSgl/Pm80kmuyYWShZTTSnR
         zK7gKk7NaBjqKJOxhR0OCjO21Yc4Xromn9UekfmY4mwtTGDZrkJtKf1tY3Gtaj7Rm6JL
         XVq1Fzh6ina7W/RVrbrWZpBX4IJCEAWyhAiYxxV2hAs4LgokCIJauq4voeVcx60dqJ/o
         e9uDxvgq3Jvl5pjPEMT/c81mgU4CKxGX7fOglxtbc6bjv3VVjBKCNJQrYSEtM+EAG84Z
         7yXKHTltIoLJUehyVzU5p+b6J9ggN+CF47Kb6e7AAJtSR0MGWUThsKuyud3Cc5VJmefg
         aK0Q==
X-Gm-Message-State: AOAM530eMEwqHzBQQCksqHnlheipwTgPUndVEDiBZFZKZpU46N//GFhp
        lkZkX0jxBHLwXeOP7kVHowVEvXr19xY=
X-Google-Smtp-Source: ABdhPJz/lVm1tAyG2/05wptxlPgGKBEsKfdRlSeu5DeabsGON86LvMzMY5MLwtAV5MJ8M4omaOcOR40MoTA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:5093:: with SMTP id e141mr7043195ybb.171.1633741303350;
 Fri, 08 Oct 2021 18:01:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 18:01:35 -0700
In-Reply-To: <20211009010135.4031460-1-seanjc@google.com>
Message-Id: <20211009010135.4031460-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211009010135.4031460-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 2/2] KVM: x86: Simplify APICv update request logic
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop confusing and flawed code that intentionally sets that per-VM APICv
inhibit mask after sending KVM_REQ_APICV_UPDATE to all vCPUs.  The code
is confusing because it's not obvious that there's no race between a CPU
seeing the request and consuming the new mask.  The code works only
because the request handling path takes the same lock, i.e. responding
vCPUs will be blocked until the full update completes.

The concept is flawed because ordering the mask update after the request
can't be relied upon for correct behavior.  The only guarantee provided
by kvm_make_all_cpus_request() is that all vCPUs exited the guest.  It
does not guarantee all vCPUs are waiting on the lock.  E.g. a VCPU could
be in the process of handling an emulated MMIO APIC access page fault
that occurred before the APICv update was initiated, and thus toggling
and reading the per-VM field would be racy.  If correctness matters, KVM
either needs to use the per-vCPU status (if appropriate), take the lock,
or have some other mechanism that guarantees the per-VM status is correct.

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4a52a08707de..960c2d196843 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9431,29 +9431,27 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
 
 void __kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 {
-	unsigned long old, new;
+	unsigned long old;
 
 	if (!kvm_x86_ops.check_apicv_inhibit_reasons ||
 	    !static_call(kvm_x86_check_apicv_inhibit_reasons)(bit))
 		return;
 
-	old = new = kvm->arch.apicv_inhibit_reasons;
+	old = kvm->arch.apicv_inhibit_reasons;
 
 	if (activate)
-		__clear_bit(bit, &new);
+		__clear_bit(bit, &kvm->arch.apicv_inhibit_reasons);
 	else
-		__set_bit(bit, &new);
+		__set_bit(bit, &kvm->arch.apicv_inhibit_reasons);
 
-	if (!!old != !!new) {
+	if (!!old != !!kvm->arch.apicv_inhibit_reasons) {
 		trace_kvm_apicv_update_request(activate, bit);
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
-		kvm->arch.apicv_inhibit_reasons = new;
-		if (new) {
+		if (kvm->arch.apicv_inhibit_reasons) {
 			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
 			kvm_zap_gfn_range(kvm, gfn, gfn+1);
 		}
-	} else
-		kvm->arch.apicv_inhibit_reasons = new;
+	}
 }
 EXPORT_SYMBOL_GPL(__kvm_request_apicv_update);
 
-- 
2.33.0.882.g93a45727a2-goog

