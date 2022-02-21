Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01ADE4BDD44
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380281AbiBUQXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380252AbiBUQXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDA82275E4
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wHGN6zxyDVkn7jr8uMe3K7F2sy2WSgPe2xYpHBh23mU=;
        b=Mi9zj+BwDPBQlk92OctU/Uf8ac4N39PlIBaJXmeweWf1wRNU2EVS6/Tgh5smKCxsQqrka8
        w1bD7RZjIq/jgNtU+1RHS+y+CH4FD6qTGHFdnpVlfsYW6vi8jRb+l7tzBwxE0XeLB0NJUR
        8VPtIo48wgjcIg2776xmcWKavs7tilI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-6jTrldkjMgWmgswhnEZgEw-1; Mon, 21 Feb 2022 11:22:54 -0500
X-MC-Unique: 6jTrldkjMgWmgswhnEZgEw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6504181424C;
        Mon, 21 Feb 2022 16:22:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 076C578AA5;
        Mon, 21 Feb 2022 16:22:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 18/25] KVM: x86/mmu: remove valid from extended role
Date:   Mon, 21 Feb 2022 11:22:36 -0500
Message-Id: <20220221162243.683208-19-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The level and direct field of the CPU mode can act as a marker for validity
instead: exactly one of them is guaranteed to be nonzero, so a zero value
for both means that the role is invalid and the MMU properties will be
computed again.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 4 +---
 arch/x86/kvm/mmu/mmu.c          | 8 +++-----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 14f391582738..b8b115b2038f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -342,8 +342,7 @@ union kvm_mmu_page_role {
  * kvm_mmu_extended_role complements kvm_mmu_page_role, tracking properties
  * relevant to the current MMU configuration.   When loading CR0, CR4, or EFER,
  * including on nested transitions, if nothing in the full role changes then
- * MMU re-configuration can be skipped. @valid bit is set on first usage so we
- * don't treat all-zero structure as valid data.
+ * MMU re-configuration can be skipped.
  *
  * The properties that are tracked in the extended role but not the page role
  * are for things that either (a) do not affect the validity of the shadow page
@@ -360,7 +359,6 @@ union kvm_mmu_page_role {
 union kvm_mmu_extended_role {
 	u32 word;
 	struct {
-		unsigned int valid:1;
 		unsigned int execonly:1;
 		unsigned int cr4_pse:1;
 		unsigned int cr4_pke:1;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eb7c62c11700..d657e2e2ceec 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4699,7 +4699,6 @@ kvm_calc_cpu_mode(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 		role.ext.efer_lma = ____is_efer_lma(regs);
 	}
 
-	role.ext.valid = 1;
 	return role;
 }
 
@@ -4874,7 +4873,6 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 
 	role.ext.word = 0;
 	role.ext.execonly = execonly;
-	role.ext.valid = 1;
 
 	return role;
 }
@@ -4994,9 +4992,9 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.root_mmu.root_role.word = 0;
 	vcpu->arch.guest_mmu.root_role.word = 0;
 	vcpu->arch.nested_mmu.root_role.word = 0;
-	vcpu->arch.root_mmu.cpu_mode.ext.valid = 0;
-	vcpu->arch.guest_mmu.cpu_mode.ext.valid = 0;
-	vcpu->arch.nested_mmu.cpu_mode.ext.valid = 0;
+	vcpu->arch.root_mmu.cpu_mode.as_u64 = 0;
+	vcpu->arch.guest_mmu.cpu_mode.as_u64 = 0;
+	vcpu->arch.nested_mmu.cpu_mode.as_u64 = 0;
 	kvm_mmu_reset_context(vcpu);
 
 	/*
-- 
2.31.1


