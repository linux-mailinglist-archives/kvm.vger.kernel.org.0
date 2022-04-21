Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA5F50A7CF
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 20:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391224AbiDUSHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 14:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391226AbiDUSHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 14:07:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9A4D4B1E6
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 11:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650564289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qIkA5gS/4TcUB4YnwbAR5RigtqM4FKrO8JhqbEAAobM=;
        b=GFXae/vSxMUKk8B/c0kWciRzw+7qHWZJIKAQEGJnnbwFIpDBo08ewT3twlqkWo1C9Pw8ce
        /zKUfPDVRrZ9DcekhPgLbNgzjDjAwF+CGxexpqh8XaVO76AGkDMJxR1hVzFe5+EUlWL7cF
        sb+wxBsvTpnvMORf9LOCZbFC9/X/WIY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-VEwMlOExPCGGZSZZiu9E-g-1; Thu, 21 Apr 2022 14:04:44 -0400
X-MC-Unique: VEwMlOExPCGGZSZZiu9E-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 239B5801E67;
        Thu, 21 Apr 2022 18:04:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E287E40E80F5;
        Thu, 21 Apr 2022 18:04:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     will@kernel.org, maz@kernel.org, apatel@ventanamicro.com,
        atishp@rivosinc.com, seanjc@google.com, pgonda@google.com
Subject: [PATCH 1/4] KVM: x86: always initialize system_event.ndata
Date:   Thu, 21 Apr 2022 14:04:40 -0400
Message-Id: <20220421180443.1465634-2-pbonzini@redhat.com>
In-Reply-To: <20220421180443.1465634-1-pbonzini@redhat.com>
References: <20220421180443.1465634-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_SYSTEM_EVENT_NDATA_VALID mechanism that was introduced
contextually with KVM_SYSTEM_EVENT_SEV_TERM is not a good match
for ARM and RISC-V, which want to communicate information even
for existing KVM_SYSTEM_EVENT_* constants.  Userspace is not ready
to filter out bit 31 of type, and fails to process the
KVM_EXIT_SYSTEM_EVENT exit.

Therefore, tie the availability of ndata to a system capability
(which will be added once all architectures are on board).
Userspace written for released versions of Linux has no reason to
check flags, since it was never written, so it is okay to replace
it with ndata and data[0] (on 32-bit kernels) or with data[0]
(on 64-bit kernels).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c   | 3 +--
 arch/x86/kvm/x86.c       | 2 ++
 include/uapi/linux/kvm.h | 1 -
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a93f0d01bb90..51b963ec122b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2739,8 +2739,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 			reason_set, reason_code);
 
 		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM |
-					       KVM_SYSTEM_EVENT_NDATA_VALID;
+		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
 		vcpu->run->system_event.ndata = 1;
 		vcpu->run->system_event.data[1] = control->ghcb_gpa;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4e7f3a8da16a..517c0228881c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10056,12 +10056,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
 			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
+			vcpu->run->system_event.ndata = 0;
 			r = 0;
 			goto out;
 		}
 		if (kvm_check_request(KVM_REQ_HV_RESET, vcpu)) {
 			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_RESET;
+			vcpu->run->system_event.ndata = 0;
 			r = 0;
 			goto out;
 		}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dd1d8167e71f..5a57f74b4903 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -445,7 +445,6 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
 #define KVM_SYSTEM_EVENT_SEV_TERM       4
-#define KVM_SYSTEM_EVENT_NDATA_VALID    (1u << 31)
 			__u32 type;
 			__u32 ndata;
 			__u64 data[16];
-- 
2.31.1


