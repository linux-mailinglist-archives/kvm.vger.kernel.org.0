Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338306B92B1
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 13:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCNMHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 08:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjCNMHL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 08:07:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A83A0F36
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 05:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678795441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MkvZhNM1t39M096NVBy9IojYv95X5G5zpBGWQK5Uqpk=;
        b=GfMua+AfN969/ac6pXcfinuudsrOKifHbl1uLXn3RHzl6dPGds9OlMBx05Lb7e4nHzv77h
        ev/abIt0Lf9aNPhbEwAqIZkqufGd0hi2SQkB5IQDKHC4ZsN50HCmw11H29RmqRafzXjvj/
        ucT1bWoPBkRJYOTrWC7LVwIwJzFp2bM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-frR9oI5qOaOvDYO_c4DA6A-1; Tue, 14 Mar 2023 08:00:17 -0400
X-MC-Unique: frR9oI5qOaOvDYO_c4DA6A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C75D857F43;
        Tue, 14 Mar 2023 12:00:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60BCA2A68;
        Tue, 14 Mar 2023 12:00:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH] KVM: nVMX: remove unnecessary #ifdef
Date:   Tue, 14 Mar 2023 08:00:16 -0400
Message-Id: <20230314120016.3038336-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nested_vmx_check_controls() has already run by the time KVM checks host state,
so the "host address space size" exit control can only be set on x86-64 hosts.
Simplify the condition at the cost of adding some dead code to 32-bit kernels.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bceb5ad409c6..535c85a332ad 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2902,7 +2902,7 @@ static int nested_vmx_check_address_space_size(struct kvm_vcpu *vcpu,
 static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 				       struct vmcs12 *vmcs12)
 {
-	bool ia32e;
+	bool ia32e = !!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE);
 
 	if (CC(!nested_host_cr0_valid(vcpu, vmcs12->host_cr0)) ||
 	    CC(!nested_host_cr4_valid(vcpu, vmcs12->host_cr4)) ||
@@ -2922,12 +2922,6 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 					   vmcs12->host_ia32_perf_global_ctrl)))
 		return -EINVAL;
 
-#ifdef CONFIG_X86_64
-	ia32e = !!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE);
-#else
-	ia32e = false;
-#endif
-
 	if (ia32e) {
 		if (CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
 			return -EINVAL;
-- 
2.39.1

