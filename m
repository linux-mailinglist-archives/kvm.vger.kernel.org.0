Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D294BAB65
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 22:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244048AbiBQVEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 16:04:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242800AbiBQVEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 16:04:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77F81D1080
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 13:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645131825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vLJOjKLZ39eFv5+IT8kSwjIWjbjOHHgriRQmWUrdZO4=;
        b=KdR7BYdFSL9qe0IBPj6WNHWXTjZoAPePXjhDDFw0h0R+1FzpNkBzS+6vm77YMaKcHC7VhD
        Q8rSNU1Pwsy2uihlVV0naUs2J/t7J5ipkWZy07sQsF6prhudRgIuz7V+GUwoKXZkul/Zp9
        KWM81C+Dx5dYgCyRsKLnG4AAxPJbRv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-NlK-EqKMMwa3o5ycz1cgAw-1; Thu, 17 Feb 2022 16:03:44 -0500
X-MC-Unique: NlK-EqKMMwa3o5ycz1cgAw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9CDF1006AA0;
        Thu, 17 Feb 2022 21:03:42 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BEB146982;
        Thu, 17 Feb 2022 21:03:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 03/18] KVM: x86/mmu: WARN if PAE roots linger after kvm_mmu_unload
Date:   Thu, 17 Feb 2022 16:03:25 -0500
Message-Id: <20220217210340.312449-4-pbonzini@redhat.com>
In-Reply-To: <20220217210340.312449-1-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 296f8723f9ae..a67071ac80f3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5086,12 +5086,21 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+static void __kvm_mmu_unload(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
+{
+	int i;
+	kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOTS_ALL);
+	WARN_ON(VALID_PAGE(mmu->root_hpa));
+	if (mmu->pae_root) {
+		for (i = 0; i < 4; ++i)
+			WARN_ON(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
+	}
+}
+
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
-	kvm_mmu_free_roots(vcpu, &vcpu->arch.root_mmu, KVM_MMU_ROOTS_ALL);
-	WARN_ON(VALID_PAGE(vcpu->arch.root_mmu.root_hpa));
-	kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
-	WARN_ON(VALID_PAGE(vcpu->arch.guest_mmu.root_hpa));
+	__kvm_mmu_unload(vcpu, &vcpu->arch.root_mmu);
+	__kvm_mmu_unload(vcpu, &vcpu->arch.guest_mmu);
 }
 
 static bool need_remote_flush(u64 old, u64 new)
-- 
2.31.1


