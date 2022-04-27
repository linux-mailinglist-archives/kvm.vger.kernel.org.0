Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9AE51239E
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 22:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbiD0UKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 16:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236168AbiD0UKX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 16:10:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72B548CDAC
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 13:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651089906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Am71f5MoXzQi71Stjn8gBw9OmI6jTzVjTksW/0/1FrU=;
        b=gVzFNcyWyo0IrDGZqp2Z9FG9sXMb6XHN9KmmUxJ89jp7vL2okBDETvwGhcpDw1I8aL9cNy
        fkkb2lqlxWp7rm+tWt5ERWG2Vb1IqeW+zFHUAtxBgmVHP59c6E9uifItja3sZzRNe2KBk1
        2vCiKdM/FXOFFrdRiX4bVTvcNn3xmZs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-56fBFPFpPlCUYVISPPIDqQ-1; Wed, 27 Apr 2022 16:05:03 -0400
X-MC-Unique: 56fBFPFpPlCUYVISPPIDqQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E62C6185A7A4;
        Wed, 27 Apr 2022 20:05:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77F9210725;
        Wed, 27 Apr 2022 20:04:56 +0000 (UTC)
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
Subject: [RFC PATCH v3 15/19] KVM: x86: nSVM: add code to reload AVIC physid table when it is invalidated
Date:   Wed, 27 Apr 2022 23:03:10 +0300
Message-Id: <20220427200314.276673-16-mlevitsk@redhat.com>
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

An AVIC table invalidation is not supposed to happen often, and can
only happen when the guest does something suspicious such as:

  - It places physid page in a memslot that is enabled/disabled and memslot
    flushing happens.

  - It tries to update apic backing page addresses - guest has no
    reason to touch this, and doing so on real hardware will likely
    result in unpredictable results.

  - It writes to reserved bits of a tracked page.


  - It write floods a physid table while no vCPU is using it
    (the page is likely reused at that point to contain something else)


All of the above causes a KVM_REQ_APIC_PAGE_RELOAD request to be raised
on all vCPUS, which kicks them out of the guest mode,
and then first vCPU to reach the handler will re-create the entries of
the physid page, and others will notice this and do nothing.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 13 +++++++++++++
 arch/x86/kvm/svm/svm.c  |  1 +
 arch/x86/kvm/svm/svm.h  |  1 +
 3 files changed, 15 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e6ec525a88625..f13ca1e7b2845 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -379,6 +379,7 @@ static void avic_physid_shadow_table_invalidate(struct kvm *kvm,
 	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
 
 	lockdep_assert_held(&kvm_svm->avic.tables_lock);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
 	avic_physid_shadow_table_erase(kvm, t);
 }
 
@@ -1638,3 +1639,15 @@ bool avic_nested_has_interrupt(struct kvm_vcpu *vcpu)
 			return true;
 	return false;
 }
+
+void avic_reload_apic_pages(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *vcpu_svm = to_svm(vcpu);
+	struct avic_physid_table *t = vcpu_svm->nested.l2_physical_id_table;
+
+	int nentries = vcpu_svm->nested.ctl.avic_physical_id &
+			AVIC_PHYSICAL_ID_TABLE_SIZE_MASK;
+
+	if (t && is_guest_mode(vcpu) && nested_avic_in_use(vcpu))
+		avic_physid_shadow_table_sync(vcpu, t, nentries);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a39bb0b27a51d..d96a73931d1e5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4677,6 +4677,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.enable_nmi_window = svm_enable_nmi_window,
 	.enable_irq_window = svm_enable_irq_window,
 	.update_cr8_intercept = svm_update_cr8_intercept,
+	.reload_apic_pages = avic_reload_apic_pages,
 	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
 	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 17fcc09cf4be1..93fd9d6f5fd85 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -711,6 +711,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void avic_ring_doorbell(struct kvm_vcpu *vcpu);
 unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu);
+void avic_reload_apic_pages(struct kvm_vcpu *vcpu);
 void avic_free_nested(struct kvm_vcpu *vcpu);
 bool avic_nested_has_interrupt(struct kvm_vcpu *vcpu);
 
-- 
2.26.3

