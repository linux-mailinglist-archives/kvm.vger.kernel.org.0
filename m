Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E9253ED90
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 20:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbiFFSIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 14:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiFFSIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 14:08:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 358032FE64
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 11:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654538922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SPSXt1XSzzkippZ/X9Z436U7ru2Jelf5JT0BkruxIf4=;
        b=hq32IaSIBi6GOWxu0xjhE7WV21Dd0MO1WOuilMlhHSN+zFBixaWO+fYHzmh9e4+SyaNToJ
        i3qUIq0IUhIbolYobPwTbwrNh0S9b758cRbOIo7RzsVpcG1HzdX/pJHNMhFjaUkiJl7+a8
        EXU6UwBNyaxtBgsWgYayCe51ieVOGJU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-bv9FlcHRPKeBOZ_6uK9ObQ-1; Mon, 06 Jun 2022 14:08:39 -0400
X-MC-Unique: bv9FlcHRPKeBOZ_6uK9ObQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56A19811E75;
        Mon,  6 Jun 2022 18:08:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E30B11121314;
        Mon,  6 Jun 2022 18:08:34 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/7] KVM: x86: document AVIC/APICv inhibit reasons
Date:   Mon,  6 Jun 2022 21:08:23 +0300
Message-Id: <20220606180829.102503-2-mlevitsk@redhat.com>
In-Reply-To: <20220606180829.102503-1-mlevitsk@redhat.com>
References: <20220606180829.102503-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/kvm_host.h | 59 +++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6cf5d77d78969..d7fb3ade44501 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1065,14 +1065,69 @@ struct kvm_x86_msr_filter {
 };
 
 enum kvm_apicv_inhibit {
+
+	/********************************************************************/
+	/* INHIBITs that are relevant to both Intel's APICv and AMD's AVIC. */
+	/********************************************************************/
+
+	/*
+	 * APIC acceleration is disabled by a module parameter
+	 * and/or not supported in hardware.
+	 */
 	APICV_INHIBIT_REASON_DISABLE,
+
+	/*
+	 * APIC acceleration is inhibited because AutoEOI feature is
+	 * being used by a HyperV guest.
+	 */
 	APICV_INHIBIT_REASON_HYPERV,
+
+	/*
+	 * APIC acceleration is inhibited because the userspace didn't yet
+	 * enable the kernel/split irqchip.
+	 */
+	APICV_INHIBIT_REASON_ABSENT,
+
+	/* APIC acceleration is inhibited because KVM_GUESTDBG_BLOCKIRQ
+	 * (out of band, debug measure of blocking all interrupts on this vCPU)
+	 * was enabled, to avoid AVIC/APICv bypassing it.
+	 */
+	APICV_INHIBIT_REASON_BLOCKIRQ,
+
+	/******************************************************/
+	/* INHIBITs that are relevant only to the AMD's AVIC. */
+	/******************************************************/
+
+	/*
+	 * AVIC is inhibited on a vCPU because it runs a nested guest.
+	 *
+	 * This is needed because unlike APICv, the peers of this vCPU
+	 * cannot use the doorbell mechanism to signal interrupts via AVIC when
+	 * a vCPU runs nested.
+	 */
 	APICV_INHIBIT_REASON_NESTED,
+
+	/*
+	 * On SVM, the wait for the IRQ window is implemented with pending vIRQ,
+	 * which cannot be injected when the AVIC is enabled, thus AVIC
+	 * is inhibited while KVM waits for IRQ window.
+	 */
 	APICV_INHIBIT_REASON_IRQWIN,
+
+	/*
+	 * PIT (i8254) 're-inject' mode, relies on EOI intercept,
+	 * which AVIC doesn't support for edge triggered interrupts.
+	 */
 	APICV_INHIBIT_REASON_PIT_REINJ,
+
+	/*
+	 * AVIC is inhibited because the guest has x2apic in its CPUID.
+	 */
 	APICV_INHIBIT_REASON_X2APIC,
-	APICV_INHIBIT_REASON_BLOCKIRQ,
-	APICV_INHIBIT_REASON_ABSENT,
+
+	/*
+	 * AVIC is disabled because SEV doesn't support it.
+	 */
 	APICV_INHIBIT_REASON_SEV,
 };
 
-- 
2.26.3

