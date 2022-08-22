Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C9159C49A
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 19:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237156AbiHVRHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 13:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236591AbiHVRHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 13:07:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDDB422D8
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661188022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zZkv95S055BPxQxJ0Xg6ao2B+lYGdGyl/nfm5oueRnQ=;
        b=U+Qu6e4PUx0B/uWqV9Ch8OUquHpIr6dO1ngwCkRA8Ys/i32Gtrre8TO/Q6VTBToQ8Pvh6G
        JLmJTelrNsmN/JK7RVyETx0b9Qh3DOw+3ab88YxjUGjpfdQBS5w/HYj7N3DNxOz/1m9W6Q
        g8aE7O45CzRtmnamgkjvLcNfJl1aLS4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-ZrE5Lah0O8CgtswDO1ds1w-1; Mon, 22 Aug 2022 13:07:00 -0400
X-MC-Unique: ZrE5Lah0O8CgtswDO1ds1w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CC5480418F;
        Mon, 22 Aug 2022 17:07:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A67E9458A;
        Mon, 22 Aug 2022 17:07:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH v3 5/7] KVM: x86: never write to memory from kvm_vcpu_check_block
Date:   Mon, 22 Aug 2022 13:06:57 -0400
Message-Id: <20220822170659.2527086-6-pbonzini@redhat.com>
In-Reply-To: <20220822170659.2527086-1-pbonzini@redhat.com>
References: <20220822170659.2527086-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_vcpu_check_block() is called while not in TASK_RUNNING, and therefore
it cannot sleep.  Writing to guest memory is therefore forbidden, but it
can happen on AMD processors if kvm_check_nested_events() causes a vmexit.

Fortunately, all events that are caught by kvm_check_nested_events() are
also recognized by kvm_vcpu_has_events() through vendor callbacks such as
kvm_x86_interrupt_allowed() or kvm_x86_ops.nested_ops->has_events(), so
remove the call and postpone the actual processing to vcpu_block().

Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5c5341110876..f901cd872b6d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10637,6 +10637,15 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 			return 1;
 	}
 
+	/*
+	 * Evaluate nested events before exiting the halted state.  This allows
+	 * the halt state to be recorded properly in the VMCS12's activity
+	 * state field (AMD does not have a similar field and a VM-Exit always
+	 * causes a spurious wakeup from HLT).
+	 */
+	if (is_guest_mode(vcpu))
+		kvm_check_nested_events(vcpu);
+
 	if (kvm_apic_accept_events(vcpu) < 0)
 		return 0;
 	switch(vcpu->arch.mp_state) {
@@ -10660,9 +10669,6 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu))
-		kvm_check_nested_events(vcpu);
-
 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted);
 }
-- 
2.31.1


