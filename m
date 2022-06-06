Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA5253ED9D
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 20:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiFFSJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 14:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiFFSJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 14:09:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB4D399809
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 11:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654538944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JNRXKCMXNZiJcdlXlKMcIh/iU12ISsDJJO9JisSCbQU=;
        b=Z7K1qcVRasVkN8+I3Y2yo+Fg2hKDobvHqW6O6V1yJpY1JyNjzydJtMlQAPpoTwSIgWR4+6
        776i4mb5BgZp8FABc0k7wOtjiJwcusfqqlCOLenhv07kKzVMmJe4UXbPZtrFgHG7nSHJmC
        BYlOsMvAkjOuoKAa3xxxqh1P4To2x6c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-vpSNwr0LNgaO7NBPnh9iUQ-1; Mon, 06 Jun 2022 14:08:58 -0400
X-MC-Unique: vpSNwr0LNgaO7NBPnh9iUQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 804DB185A79C;
        Mon,  6 Jun 2022 18:08:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17D611121314;
        Mon,  6 Jun 2022 18:08:53 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6/7] KVM: x86: disable preemption around the call to kvm_arch_vcpu_{un|}blocking
Date:   Mon,  6 Jun 2022 21:08:28 +0300
Message-Id: <20220606180829.102503-7-mlevitsk@redhat.com>
In-Reply-To: <20220606180829.102503-1-mlevitsk@redhat.com>
References: <20220606180829.102503-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On SVM, if preemption happens right after the call to finish_rcuwait
but before call to kvm_arch_vcpu_unblocking on SVM/AVIC, it itself
will re-enable AVIC, and then we will try to re-enable it again
in kvm_arch_vcpu_unblocking which will lead to a warning
in __avic_vcpu_load.

The same problem can happen if the vCPU is preempted right after the call
to kvm_arch_vcpu_blocking but before the call to prepare_to_rcuwait
and in this case, we will end up with AVIC enabled during sleep -
Ooops.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 virt/kvm/kvm_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5e511fcec80d7..642dba492c65d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3337,9 +3337,11 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.generic.blocking = 1;
 
+	preempt_disable();
 	kvm_arch_vcpu_blocking(vcpu);
-
 	prepare_to_rcuwait(wait);
+	preempt_enable();
+
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
@@ -3349,9 +3351,11 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		waited = true;
 		schedule();
 	}
-	finish_rcuwait(wait);
 
+	preempt_disable();
+	finish_rcuwait(wait);
 	kvm_arch_vcpu_unblocking(vcpu);
+	preempt_enable();
 
 	vcpu->stat.generic.blocking = 0;
 
-- 
2.26.3

