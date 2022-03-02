Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B0C4CA21D
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 11:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240973AbiCBK0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 05:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236253AbiCBK0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 05:26:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A8ABAD11C
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 02:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646216746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fSrRNDpTZsFhlMpsmENClsaKs1lidW/Xhq22SIV8IOg=;
        b=SGucAioKE2xe2otWSekWafpbw6mtwfHrybJUpLFrF/6qH0YgrELrE7AUO8GJfhEOr1ScXl
        Jjlf+JsON4qzB57Nr926SVoHcMqIG6jVMDtuzCeL1+jRNpiZfMZpcSZ2qiDJ/b1y7dDlys
        5ApX39ma5qY89AgnN4x6KyzyNKtq+us=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-_QMKm25sPWiww5mBf2CnDQ-1; Wed, 02 Mar 2022 05:25:43 -0500
X-MC-Unique: _QMKm25sPWiww5mBf2CnDQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E96DA1006AA6;
        Wed,  2 Mar 2022 10:25:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AEA77B6F3;
        Wed,  2 Mar 2022 10:24:58 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: x86: mmu: trace kvm_mmu_set_spte after the new SPTE was set
Date:   Wed,  2 Mar 2022 12:24:57 +0200
Message-Id: <20220302102457.588450-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It makes more sense to print new SPTE value than the
old value.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 94f077722b290..0e209f0b2e1d2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2690,8 +2690,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	if (*sptep == spte) {
 		ret = RET_PF_SPURIOUS;
 	} else {
-		trace_kvm_mmu_set_spte(level, gfn, sptep);
 		flush |= mmu_spte_update(sptep, spte);
+		trace_kvm_mmu_set_spte(level, gfn, sptep);
 	}
 
 	if (wrprot) {
-- 
2.26.3

