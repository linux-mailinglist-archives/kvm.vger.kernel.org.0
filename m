Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04301500733
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240689AbiDNHnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240490AbiDNHmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1FFE357144
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uGXfw0TwpBgMaCpL6PaUqyBneoOU1zZyXIhjUfcahI4=;
        b=PIifq11y0dNe3PJ4edgLWrNSHjLJgTZ0wByNmG1fuJYxcqivloy6P8o+pUMPF8vNots6F+
        wyjrJ7L7IxDNHdmMdu/kAwZR11nQgianBwd7UvXF6ZQe3Y215sxvMyCStQQPgaUUREhP9y
        wMuDNZ2920sSUvbOk0BinF3rt211vNs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-XMghqsKXN_mWOZZatSDmPw-1; Thu, 14 Apr 2022 03:40:04 -0400
X-MC-Unique: XMghqsKXN_mWOZZatSDmPw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36D9D804190;
        Thu, 14 Apr 2022 07:40:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18DCEC28100;
        Thu, 14 Apr 2022 07:40:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 12/22] KVM: x86/mmu: cleanup computation of MMU roles for shadow paging
Date:   Thu, 14 Apr 2022 03:39:50 -0400
Message-Id: <20220414074000.31438-13-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the already-computed CPU role, instead of redoing it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6c0287d60781..92dade92462c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4803,15 +4803,14 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_role
 kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				   const struct kvm_mmu_role_regs *regs)
+				   union kvm_mmu_role cpu_role)
 {
-	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
 	union kvm_mmu_role role;
 
 	role = cpu_role;
-	if (!____is_efer_lma(regs))
+	if (!cpu_role.ext.efer_lma)
 		role.base.level = PT32E_ROOT_LEVEL;
-	else if (____is_cr4_la57(regs))
+	else if (cpu_role.ext.cr4_la57)
 		role.base.level = PT64_ROOT_5LEVEL;
 	else
 		role.base.level = PT64_ROOT_4LEVEL;
@@ -4850,16 +4849,15 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
 	union kvm_mmu_role mmu_role =
-		kvm_calc_shadow_mmu_root_page_role(vcpu, regs);
+		kvm_calc_shadow_mmu_root_page_role(vcpu, cpu_role);
 
 	shadow_mmu_init_context(vcpu, context, cpu_role, mmu_role);
 }
 
 static union kvm_mmu_role
 kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
-				   const struct kvm_mmu_role_regs *regs)
+				   union kvm_mmu_role cpu_role)
 {
-	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
 	union kvm_mmu_role role;
 
 	WARN_ON_ONCE(cpu_role.base.direct);
@@ -4879,7 +4877,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 		.efer = efer,
 	};
 	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, &regs);
-	union kvm_mmu_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);;
+	union kvm_mmu_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, cpu_role);
 
 	shadow_mmu_init_context(vcpu, context, cpu_role, mmu_role);
 	kvm_mmu_new_pgd(vcpu, nested_cr3);
-- 
2.31.1


