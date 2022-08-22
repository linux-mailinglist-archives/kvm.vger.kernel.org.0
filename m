Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6394159C4A5
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 19:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbiHVRHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 13:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbiHVRHH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 13:07:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74560422FC
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661188021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5bNOqGSR9yvKD1buQh/L2OPhAjHEoxThdFo1kzTHjdc=;
        b=Y2+2ehl9R1Wr67oUaLZmeSdLgy2csXzvkF8qKqca3NDJURbkySvz9LsMEtLgYXMzeqy0Kk
        di7YeJWlQiU5dtbjhoYfxE7xpbb6c61P2nq1TOQxt5wjciWyh9RbF0Z+tYZXfunEjb3/Jn
        SS9WwbBBi1cMeLPlN7aPoRQ+xpOKrLQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-cZmUnaBeNN-Fdtd8DM_WFQ-1; Mon, 22 Aug 2022 13:06:59 -0400
X-MC-Unique: cZmUnaBeNN-Fdtd8DM_WFQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FD7F3801F52;
        Mon, 22 Aug 2022 17:06:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E8309458A;
        Mon, 22 Aug 2022 17:06:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH v3 1/7] KVM: x86: check validity of argument to KVM_SET_MP_STATE
Date:   Mon, 22 Aug 2022 13:06:53 -0400
Message-Id: <20220822170659.2527086-2-pbonzini@redhat.com>
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

An invalid argument to KVM_SET_MP_STATE has no effect other than making the
vCPU fail to run at the next KVM_RUN.  Since it is extremely unlikely that
any userspace is relying on it, fail with -EINVAL just like for other
architectures.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7374d768296..4d719ba21553 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10652,7 +10652,8 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 	case KVM_MP_STATE_INIT_RECEIVED:
 		break;
 	default:
-		return -EINTR;
+		WARN_ON_ONCE(1);
+		break;
 	}
 	return 1;
 }
@@ -11093,9 +11094,22 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 
 	vcpu_load(vcpu);
 
-	if (!lapic_in_kernel(vcpu) &&
-	    mp_state->mp_state != KVM_MP_STATE_RUNNABLE)
+	switch (mp_state->mp_state) {
+	case KVM_MP_STATE_UNINITIALIZED:
+	case KVM_MP_STATE_HALTED:
+	case KVM_MP_STATE_AP_RESET_HOLD:
+	case KVM_MP_STATE_INIT_RECEIVED:
+	case KVM_MP_STATE_SIPI_RECEIVED:
+		if (!lapic_in_kernel(vcpu))
+			goto out;
+		break;
+
+	case KVM_MP_STATE_RUNNABLE:
+		break;
+
+	default:
 		goto out;
+	}
 
 	/*
 	 * KVM_MP_STATE_INIT_RECEIVED means the processor is in
-- 
2.31.1


