Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2861650A7CB
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 20:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391265AbiDUSH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 14:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391227AbiDUSHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 14:07:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C01A4B1DE
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 11:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650564289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5uIxmDi2O7UMGYDdP32IiG4VA/mcU5iBq1ojkCkRWbM=;
        b=WHGcdJixFwVfKzYaRoonVNJBEQUueUKL+VEVp/c+zCAlhSHFzwZd4MJms0SkNY3Xjga091
        MEBgGXSCs1+FSd0DIaMPyf9L4p5SALeXADm/9qEXZ+e88Mh/kIE5Fhqz/6y6HoUV6kSkCg
        4t3evyAQ9aDfyzT4PkeWMX57x9PsiKM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-DHhvKqsyPk660OSQyqxA7A-1; Thu, 21 Apr 2022 14:04:45 -0400
X-MC-Unique: DHhvKqsyPk660OSQyqxA7A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D9811E1AE43;
        Thu, 21 Apr 2022 18:04:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6802E40E80F5;
        Thu, 21 Apr 2022 18:04:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     will@kernel.org, maz@kernel.org, apatel@ventanamicro.com,
        atishp@rivosinc.com, seanjc@google.com, pgonda@google.com
Subject: [PATCH 3/4] KVM: RISC-V: replace system_event.flags with ndata and data[0]
Date:   Thu, 21 Apr 2022 14:04:42 -0400
Message-Id: <20220421180443.1465634-4-pbonzini@redhat.com>
In-Reply-To: <20220421180443.1465634-1-pbonzini@redhat.com>
References: <20220421180443.1465634-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The flags datum for KVM_EXIT_SYSTEM_EVENT exits has been
removed because it was defined incorrectly; no padding was
introduced between the 32-bit type and the 64-bit flags,
resulting in different definitions for 32-bit and 64-bit
userspace.

The replacement is a pair of fields, ndata and data[],
with ndata saying how many items are valid in the data array.
In the case of RISC-V that's one for the SRST SBI call (with
flags simply moved to data[0]) and zero for the legacy v0.1
call.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h | 2 +-
 arch/riscv/kvm/vcpu_sbi.c             | 5 +++--
 arch/riscv/kvm/vcpu_sbi_replace.c     | 4 ++--
 arch/riscv/kvm/vcpu_sbi_v01.c         | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 83d6d4d2b1df..c4b10c25264a 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -30,7 +30,7 @@ struct kvm_vcpu_sbi_extension {
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
 void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 				     struct kvm_run *run,
-				     u32 type, u64 flags);
+				     u32 type, bool have_reason, u64 reason);
 const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
 
 #endif /* __RISCV_KVM_VCPU_SBI_H__ */
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index a09ecb97b890..2019ca01b44b 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -83,7 +83,7 @@ void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 				     struct kvm_run *run,
-				     u32 type, u64 flags)
+				     u32 type, bool have_reason, u64 reason)
 {
 	unsigned long i;
 	struct kvm_vcpu *tmp;
@@ -94,7 +94,8 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 
 	memset(&run->system_event, 0, sizeof(run->system_event));
 	run->system_event.type = type;
-	run->system_event.flags = flags;
+	run->system_event.ndata = have_reason;
+	run->system_event.data[0] = reason;
 	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 }
 
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 0f217365c287..a36414a5f59e 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -148,14 +148,14 @@ static int kvm_sbi_ext_srst_handler(struct kvm_vcpu *vcpu,
 		case SBI_SRST_RESET_TYPE_SHUTDOWN:
 			kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
 						KVM_SYSTEM_EVENT_SHUTDOWN,
-						reason);
+						true, reason);
 			*exit = true;
 			break;
 		case SBI_SRST_RESET_TYPE_COLD_REBOOT:
 		case SBI_SRST_RESET_TYPE_WARM_REBOOT:
 			kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
 						KVM_SYSTEM_EVENT_RESET,
-						reason);
+						true, reason);
 			*exit = true;
 			break;
 		default:
diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
index da4d6c99c2cf..9598bc6b4c0e 100644
--- a/arch/riscv/kvm/vcpu_sbi_v01.c
+++ b/arch/riscv/kvm/vcpu_sbi_v01.c
@@ -66,7 +66,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		break;
 	case SBI_EXT_0_1_SHUTDOWN:
 		kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
-						KVM_SYSTEM_EVENT_SHUTDOWN, 0);
+						KVM_SYSTEM_EVENT_SHUTDOWN, false, 0);
 		*exit = true;
 		break;
 	case SBI_EXT_0_1_REMOTE_FENCE_I:
-- 
2.31.1


