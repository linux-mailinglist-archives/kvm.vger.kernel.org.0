Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8B2509682
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 07:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384319AbiDUFQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 01:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384245AbiDUFQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 01:16:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E52F12ABE
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 22:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650518006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e0g3mBb+ynPHD4DJjbvIQMVAKnaFWx4DSoUHFihzCfc=;
        b=VI71jqp8KMsQL51oI6lBq3u1BUvOsoTCEF/21xQDj7T7+HZIn2n1fAaC+SW59oX/8Uh9bw
        vCzzotb84dsCKjZ7sOSK9H7e3ZVBmmDFxyXhWz2rrBGOKc8b92zmzf+Yp/65RTsI+5lULp
        LAF67e56Y0T7S437vJdKkydYVKwr2yc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-zdEv8QKuNvOaoaf16ssl_A-1; Thu, 21 Apr 2022 01:13:22 -0400
X-MC-Unique: zdEv8QKuNvOaoaf16ssl_A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB0802805336;
        Thu, 21 Apr 2022 05:13:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DD9B145BA5A;
        Thu, 21 Apr 2022 05:13:14 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, x86@kernel.org,
        David Airlie <airlied@linux.ie>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [RFC PATCH v2 05/10] KVM: x86: lapic: don't allow to change APIC ID when apic acceleration is enabled
Date:   Thu, 21 Apr 2022 08:12:39 +0300
Message-Id: <20220421051244.187733-6-mlevitsk@redhat.com>
In-Reply-To: <20220421051244.187733-1-mlevitsk@redhat.com>
References: <20220421051244.187733-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No normal guest has any reason to change physical APIC IDs, and
allowing this introduces bugs into APIC acceleration code.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/lapic.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 66b0eb0bda94e..56996aeca9881 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2046,10 +2046,20 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 
 	switch (reg) {
 	case APIC_ID:		/* Local APIC ID */
-		if (!apic_x2apic_mode(apic))
-			kvm_apic_set_xapic_id(apic, val >> 24);
-		else
+		if (apic_x2apic_mode(apic)) {
 			ret = 1;
+			break;
+		}
+		/*
+		 * Don't allow setting APIC ID with any APIC acceleration
+		 * enabled to avoid unexpected issues
+		 */
+		if (enable_apicv && ((val >> 24) != apic->vcpu->vcpu_id)) {
+			kvm_vm_bugged(apic->vcpu->kvm);
+			break;
+		}
+
+		kvm_apic_set_xapic_id(apic, val >> 24);
 		break;
 
 	case APIC_TASKPRI:
@@ -2617,8 +2627,16 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 		struct kvm_lapic_state *s, bool set)
 {
-	if (apic_x2apic_mode(vcpu->arch.apic)) {
-		u32 *id = (u32 *)(s->regs + APIC_ID);
+	u32 *id = (u32 *)(s->regs + APIC_ID);
+
+	if (!apic_x2apic_mode(vcpu->arch.apic)) {
+		/* Don't allow setting APIC ID with any APIC acceleration
+		 * enabled to avoid unexpected issues
+		 */
+		if (enable_apicv && (*id >> 24) != vcpu->vcpu_id)
+			return -EINVAL;
+	} else {
+
 		u32 *ldr = (u32 *)(s->regs + APIC_LDR);
 		u64 icr;
 
-- 
2.26.3

