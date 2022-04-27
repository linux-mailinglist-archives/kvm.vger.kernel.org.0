Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D34751234D
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 22:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbiD0UG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 16:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235244AbiD0UGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 16:06:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E55DD10C4
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 13:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651089815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O/591BE30Gw+sLgR7wcCQy4XNcbdAfVRmL/PYPXct/c=;
        b=XPkkeYEAWFap96lYZxwrLKAMl5g2xvRV6SZcEsytJrK2mZoVUj0SutUScXd36DMtPib1ZU
        hJFDhXkoIqTqAJDY1vylPIwYQGr3Ozl5H4tghMIujI7p89iL+sku38GtrdUUnS0F3z7eX2
        6mojn0yqqe3JJmF8IOk9ZcVfa4xEQCg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-dQOqBeYMObyNtmOAhvPWIA-1; Wed, 27 Apr 2022 16:03:30 -0400
X-MC-Unique: dQOqBeYMObyNtmOAhvPWIA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06EDD8039D7;
        Wed, 27 Apr 2022 20:03:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6323F9E82;
        Wed, 27 Apr 2022 20:03:23 +0000 (UTC)
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
Subject: [RFC PATCH v3 01/19] KVM: x86: document AVIC/APICv inhibit reasons
Date:   Wed, 27 Apr 2022 23:02:56 +0300
Message-Id: <20220427200314.276673-2-mlevitsk@redhat.com>
In-Reply-To: <20220427200314.276673-1-mlevitsk@redhat.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These days there are too many AVIC/APICv inhibit
reasons, and it doesn't hurt to have some documentation
for them.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f164c6c1514a4..63eae00625bda 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1046,14 +1046,29 @@ struct kvm_x86_msr_filter {
 };
 
 enum kvm_apicv_inhibit {
+	/* APICv/AVIC is disabled by module param and/or not supported in hardware */
 	APICV_INHIBIT_REASON_DISABLE,
+	/* APICv/AVIC is inhibited because AutoEOI feature is being used by a HyperV guest*/
 	APICV_INHIBIT_REASON_HYPERV,
+	/* AVIC is inhibited on a CPU because it runs a nested guest */
 	APICV_INHIBIT_REASON_NESTED,
+	/* AVIC is inhibited due to wait for an irq window (AVIC doesn't support this) */
 	APICV_INHIBIT_REASON_IRQWIN,
+	/*
+	 * AVIC is inhibited because i8254 're-inject' mode is used
+	 * which needs EOI intercept which AVIC doesn't support
+	 */
 	APICV_INHIBIT_REASON_PIT_REINJ,
+	/* AVIC is inhibited because the guest has x2apic in its CPUID*/
 	APICV_INHIBIT_REASON_X2APIC,
+	/* AVIC/APICv is inhibited because KVM_GUESTDBG_BLOCKIRQ was enabled */
 	APICV_INHIBIT_REASON_BLOCKIRQ,
+	/*
+	 * AVIC/APICv is inhibited because the guest didn't yet
+	 * enable kernel/split irqchip
+	 */
 	APICV_INHIBIT_REASON_ABSENT,
+	/* AVIC is disabled because SEV doesn't support it */
 	APICV_INHIBIT_REASON_SEV,
 };
 
-- 
2.26.3

