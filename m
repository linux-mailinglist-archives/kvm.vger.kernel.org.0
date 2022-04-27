Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1B55123A6
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 22:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236496AbiD0ULs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 16:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235956AbiD0ULi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 16:11:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A080F939C6
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 13:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651089939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yA9Ogh+XZjCqc2vT+o0W3Eipd0C5KqefizxAchXjEVE=;
        b=G0BzpdDZt8lO3qGmM/AZ+rzi5LeKt+0O+mtEEFXY5VpNgvc3ulkHdfZoPfa88hkaUTBBkx
        D+dtGM+6rKhbocibXc+hJe2V4srO8naOoBnhKMp467GymoSpEcULsWLF55tB5bLTiBzuBG
        OUFOghp/UXa8Hm+M+lgojptEfNLkMZw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-qLc1Y9eCOsGgT0TQKKNudg-1; Wed, 27 Apr 2022 16:05:36 -0400
X-MC-Unique: qLc1Y9eCOsGgT0TQKKNudg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D94E980418D;
        Wed, 27 Apr 2022 20:05:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1676E9E74;
        Wed, 27 Apr 2022 20:05:08 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org,
        Sean Christopherson <seanjc@google.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [RFC PATCH v3 17/19] KVM: x86: nSVM: implement nested AVIC doorbell emulation
Date:   Wed, 27 Apr 2022 23:03:12 +0300
Message-Id: <20220427200314.276673-18-mlevitsk@redhat.com>
In-Reply-To: <20220427200314.276673-1-mlevitsk@redhat.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements the doorbell msr emulation
for nested AVIC.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 49 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c  |  2 ++
 arch/x86/kvm/svm/svm.h  |  1 +
 3 files changed, 52 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e8c53fd77f0b1..149df26e17462 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1165,6 +1165,55 @@ unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+int avic_emulate_doorbell_write(struct kvm_vcpu *vcpu, u64 data)
+{
+	int source_l1_apicid = vcpu->vcpu_id;
+	int target_l1_apicid = data & AVIC_DOORBELL_PHYSICAL_ID_MASK;
+	bool target_running, target_nested;
+	struct kvm_vcpu *target;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!svm->avic_enabled || (data & ~AVIC_DOORBELL_PHYSICAL_ID_MASK))
+		return 1;
+
+	target = avic_vcpu_by_l1_apicid(vcpu->kvm, target_l1_apicid);
+	if (!target)
+		/* Guest bug: targeting invalid APIC ID. */
+		return 0;
+
+	target_running = READ_ONCE(target->mode) == IN_GUEST_MODE;
+	target_nested = is_guest_mode(target);
+
+	trace_kvm_avic_nested_doorbell(source_l1_apicid, target_l1_apicid,
+				       target_nested, target_running);
+
+	/*
+	 * Target is not in the nested mode, thus the doorbell doesn't affect it.
+	 * If it just became nested after is_guest_mode was checked,
+	 * it means that it just processed AVIC state and KVM doesn't need
+	 * to send it another doorbell.
+	 */
+	if (!target_nested)
+		return 0;
+
+	/*
+	 * If the target vCPU is in guest mode, kick the real doorbell.
+	 * Otherwise KVM needs to try to wake it up if it was sleeping.
+	 *
+	 * If the target is not longer in guest mode (just exited it),
+	 * it will either halt and before that it will notice pending IRR
+	 * bits, and cancel halting, or it will enter the guest mode again,
+	 * and notice the IRR bits as well.
+	 */
+	if (target_running)
+		wrmsr(MSR_AMD64_SVM_AVIC_DOORBELL,
+		      kvm_cpu_get_apicid(READ_ONCE(target->cpu)), 0);
+	else
+		kvm_vcpu_wake_up(target);
+
+	return 0;
+}
+
 static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d96a73931d1e5..b31bab832360e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2772,6 +2772,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	u32 ecx = msr->index;
 	u64 data = msr->data;
 	switch (ecx) {
+	case MSR_AMD64_SVM_AVIC_DOORBELL:
+		return avic_emulate_doorbell_write(vcpu, data);
 	case MSR_AMD64_TSC_RATIO:
 
 		if (!svm->tsc_scaling_enabled) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 93fd9d6f5fd85..14e2c5c451cad 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -714,6 +714,7 @@ unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu);
 void avic_reload_apic_pages(struct kvm_vcpu *vcpu);
 void avic_free_nested(struct kvm_vcpu *vcpu);
 bool avic_nested_has_interrupt(struct kvm_vcpu *vcpu);
+int avic_emulate_doorbell_write(struct kvm_vcpu *vcpu, u64 data);
 
 struct avic_physid_table *
 avic_physid_shadow_table_get(struct kvm_vcpu *vcpu, gfn_t gfn);
-- 
2.26.3

