Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4EBF4AC50D
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 17:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392243AbiBGQEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 11:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242977AbiBGP7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 10:59:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D85D5C0401CE
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 07:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644249552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PA0ZlhnyV8+URLprs6c44r6sDD4SwJewRmeM2u7HZ1o=;
        b=jMPFZ/gt5tFdRYiobreHN4+W4V4Y6O0LMq1QmlWHrXenrJTzEkx4r7NNva81pFaKSxonzL
        BXjrhG0rhxCxDGS5fJ+wX8diE0qqq/oU3BWFblCVphn8ZfwP5ZPVuVMr0tJaTN1rvIqa9W
        m9DOXhKj0wZu4YrreQlSnaLv0Rmwi6M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-CJQeKoKLORqhqrfN0EJQcg-1; Mon, 07 Feb 2022 10:59:08 -0500
X-MC-Unique: CJQeKoKLORqhqrfN0EJQcg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1522F3E743;
        Mon,  7 Feb 2022 15:58:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 923C89652D;
        Mon,  7 Feb 2022 15:58:47 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        David Airlie <airlied@linux.ie>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH RESEND 18/30] KVM: x86: mmu: add strict mmu mode
Date:   Mon,  7 Feb 2022 17:54:35 +0200
Message-Id: <20220207155447.840194-19-mlevitsk@redhat.com>
In-Reply-To: <20220207155447.840194-1-mlevitsk@redhat.com>
References: <20220207155447.840194-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an (mostly debug) option to force KVM's shadow mmu
to never have unsync pages.

This is useful in some cases to debug it.

It is also useful for some legacy guest OSes which don't
flush TLBs correctly, and thus don't work on modern
CPUs which have speculative MMUs.

Using this option together with legacy paging (npt/ept=0)
allows to correctly simulate such old MMU while still
getting most of the benefits of the virtualization.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 43c7abdd6b70f..fa2da6990703f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -91,6 +91,10 @@ __MODULE_PARM_TYPE(nx_huge_pages_recovery_period_ms, "uint");
 static bool __read_mostly force_flush_and_sync_on_reuse;
 module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
 
+
+bool strict_mmu;
+module_param(strict_mmu, bool, 0644);
+
 /*
  * When setting this variable to true it enables Two-Dimensional-Paging
  * where the hardware walks 2 page tables:
@@ -2703,7 +2707,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
-			   true, host_writable, &spte);
+			   !strict_mmu, host_writable, &spte);
 
 	if (*sptep == spte) {
 		ret = RET_PF_SPURIOUS;
@@ -5139,6 +5143,11 @@ static u64 mmu_pte_write_fetch_gpte(struct kvm_vcpu *vcpu, gpa_t *gpa,
  */
 static bool detect_write_flooding(struct kvm_mmu_page *sp)
 {
+	/*
+	 * When using non speculating MMU, use a bit higher threshold
+	 * for write flood detection
+	 */
+	int threshold = strict_mmu ? 10 :  3;
 	/*
 	 * Skip write-flooding detected for the sp whose level is 1, because
 	 * it can become unsync, then the guest page is not write-protected.
@@ -5147,7 +5156,7 @@ static bool detect_write_flooding(struct kvm_mmu_page *sp)
 		return false;
 
 	atomic_inc(&sp->write_flooding_count);
-	return atomic_read(&sp->write_flooding_count) >= 3;
+	return atomic_read(&sp->write_flooding_count) >= threshold;
 }
 
 /*
-- 
2.26.3

