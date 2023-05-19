Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFC8709186
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 10:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjESIRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 04:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjESIRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 04:17:36 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A385710D;
        Fri, 19 May 2023 01:17:30 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-53482b44007so763284a12.2;
        Fri, 19 May 2023 01:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684484250; x=1687076250;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pIn44GlIkUSHR9NPd+HhQz6XW7R0sVim+0/fBrzpEgk=;
        b=AQVNDPLt5jt81iQAXe4qXMvSCzNJAYOHBuxJYE5KRuaPCyHYRP4jq1g8KQ2V63IxAE
         ZuxnpjqwV3MoRsKNb4D9ZqeUKAH9SYFGSiys66XCjKC0aZW83E2+f+Ug4a8yHtEjH4zF
         pI4hCfn/H2pbGkflAZ/1RCKo7TgXBJH4iIKxH36FmbTavxl7/8nNRB905M7N7UZbbK71
         7JA/CTE0IHxi6suBNRUdM3CmAkeCVJ4n5vo/YfdA8p0zsZn6Z6hGg7GHe81m2Fv9X4Sz
         0MYRpSkn08b86yEtWI9yFQYWeLgi0semaIHy/3uQHa3R1Rl2nxnFe09M8NOXfx5ybEad
         fyvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684484250; x=1687076250;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pIn44GlIkUSHR9NPd+HhQz6XW7R0sVim+0/fBrzpEgk=;
        b=U9fRkAcnm3mghhIczYv+4Dk1j3Nxrwy86J4skSJ+WD3WfPdI/RXSHF8N0Wqy97XG8C
         /zLZQjJ28v2UjBw8wE0haMRMFu/qNtIayBMm1SkMs55z5FKDn94cJIwrTAqbjKj0oF6Q
         CcRV+aP7C4sf9FWy+UOLoOuKkxtAb11AJ8SRiHUE9Up2iF+q8IpUZtJ2Px9d6bUznXev
         8Z9Hetmj6+1U5Wy5iS4dso5hsIBrn2FVX06AbELDU7hkMrtsC+Wr7N674L9sHkk8DuTS
         YnkDlSDCPxn2+26Ng7v7RW0lIF912sjNAVeau0YBW9W46mo/dO3eCknHFtQnpYBSyH/2
         hWhA==
X-Gm-Message-State: AC+VfDwgXbPUH6g20sn4+JEI96njwx84sIY5W4BAWKYSf36hEnOWA+bf
        g7bsSnbNh7/H1XpJ8Xf//fQ=
X-Google-Smtp-Source: ACHHUZ4HJ6W+i9ZOHujorFlZvsNJvYi+zcDceQE67y7nLQrgjQvW74O3gJzrTG5lZfBVjdvH3Sg8YQ==
X-Received: by 2002:a17:902:6b48:b0:1a6:87e3:db50 with SMTP id g8-20020a1709026b4800b001a687e3db50mr1900566plt.1.1684484250058;
        Fri, 19 May 2023 01:17:30 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id l11-20020a170903244b00b001ac937171e4sm2778714pls.254.2023.05.19.01.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 01:17:29 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Drop "struct kvm_mmu *mmu" from __kvm_mmu_invalidate_addr()
Date:   Fri, 19 May 2023 16:17:11 +0800
Message-Id: <20230519081711.72906-1-likexu@tencent.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Remove incoming parameter "struct kvm_mmu *mmu" that are no longer used.
Whether the func is using "vcpu->arch.root_mmu" or "vcpu->arch.guest_mmu",
it can be referenced as expected via "vcpu->arch.mmu". Thus the "*mmu"
is replaced by the use of "vcpu->arch.mmu" in commit 19ace7d6ca15 ("KVM:
x86/mmu: Skip calling mmu->sync_spte() when the spte is 0").

No functional change is intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8961f45e3b1..160c40c83330 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5790,8 +5790,8 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
-static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-				      u64 addr, hpa_t root_hpa)
+static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, u64 addr,
+				      hpa_t root_hpa)
 {
 	struct kvm_shadow_walk_iterator iterator;
 
@@ -5839,11 +5839,11 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		return;
 
 	if (roots & KVM_MMU_ROOT_CURRENT)
-		__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->root.hpa);
+		__kvm_mmu_invalidate_addr(vcpu, addr, mmu->root.hpa);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		if (roots & KVM_MMU_ROOT_PREVIOUS(i))
-			__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
+			__kvm_mmu_invalidate_addr(vcpu, addr, mmu->prev_roots[i].hpa);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_addr);

base-commit: f1fcbaa18b28dec10281551dfe6ed3a3ed80e3d6
-- 
2.40.1

