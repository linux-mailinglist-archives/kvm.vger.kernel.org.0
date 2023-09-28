Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF187B2400
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 19:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbjI1RfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 13:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjI1RfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 13:35:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC0AE5
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 10:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695922457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jEwA8CyX78/GkMVoiAVbpRnGMlV0gBkCqcXscfLzkHs=;
        b=AibIh1zeF+jQE/xbRMvCpy1Wdvg3LY8HTTRaQ4/hoBdW69EkRvsyaZWA/+FJB1m/la36ib
        kn4vDh5JqP0FjKFDvgTol5jJOMWiCm0PoR88L8uERgC3MLm2Z+RTvgw+v3y2xxG+jxOcWP
        iNxl2IFjhYzq+q1NjKZ75LVejtZutVA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-8q4-2IX4M9GzgZ9LF6aO2A-1; Thu, 28 Sep 2023 13:34:12 -0400
X-MC-Unique: 8q4-2IX4M9GzgZ9LF6aO2A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C8F9185A790;
        Thu, 28 Sep 2023 17:34:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.226.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B43D14171CB;
        Thu, 28 Sep 2023 17:34:07 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     iommu@lists.linux.dev, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>, stable@vger.kernel.org
Subject: [PATCH v2 3/4] x86: KVM: SVM: refresh AVIC inhibition in svm_leave_nested()
Date:   Thu, 28 Sep 2023 20:33:53 +0300
Message-Id: <20230928173354.217464-4-mlevitsk@redhat.com>
In-Reply-To: <20230928173354.217464-1-mlevitsk@redhat.com>
References: <20230928173354.217464-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

svm_leave_nested() similar to a nested VM exit, get the vCPU out of nested
mode and thus should end the local inhibition of AVIC on this vCPU.

Failure to do so, can lead to hangs on guest reboot.

Raise the KVM_REQ_APICV_UPDATE request to refresh the AVIC state of the
current vCPU in this case.

Fixes: f44509f849fe ("KVM: x86: SVM: allow AVIC to co-exist with a nested guest running")
Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index dd496c9e5f91f28..3fea8c47679e689 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1253,6 +1253,9 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
 
 		nested_svm_uninit_mmu_context(vcpu);
 		vmcb_mark_all_dirty(svm->vmcb);
+
+		if (kvm_apicv_activated(vcpu->kvm))
+			kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
 	}
 
 	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
-- 
2.26.3

