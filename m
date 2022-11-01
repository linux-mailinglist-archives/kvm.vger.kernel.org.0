Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA678614D86
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 15:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbiKAO6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 10:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiKAO6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 10:58:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08081CFF8
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1bn23DGHuJOa2uXbtn/9jgCJGNZShoq3hWZ0GP4Sfr8=;
        b=NLr30ojmJZjLa6/ZzFJ8uylCwkvn/6M5Hm6TaczzLtmDyt3mX9T+ekX2KeJws7nIJjivMP
        O9e7PpcsFKt0YqgBS6YegvA4Sg4RTP3UkuLs0T7I1eN6BAGwtz1hNxfLqu3Aw0vpd4tFMT
        M2duellFKRzgz1xctBQlrhZqlfAtH/8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-qSAHqCQgOyyNXniR85J26g-1; Tue, 01 Nov 2022 10:56:00 -0400
X-MC-Unique: qSAHqCQgOyyNXniR85J26g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B4EA3826A44;
        Tue,  1 Nov 2022 14:55:59 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54F47C15BA5;
        Tue,  1 Nov 2022 14:55:57 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v13 29/48] KVM: x86: Expose Hyper-V L2 TLB flush feature
Date:   Tue,  1 Nov 2022 15:54:07 +0100
Message-Id: <20221101145426.251680-30-vkuznets@redhat.com>
In-Reply-To: <20221101145426.251680-1-vkuznets@redhat.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With both nSVM and nVMX implementations in place, KVM can now expose
Hyper-V L2 TLB flush feature to userspace.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 15880da73a7b..2c7f2a26421e 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2779,6 +2779,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 		case HYPERV_CPUID_NESTED_FEATURES:
 			ent->eax = evmcs_ver;
+			ent->eax |= HV_X64_NESTED_DIRECT_FLUSH;
 			ent->eax |= HV_X64_NESTED_MSR_BITMAP;
 			ent->ebx |= HV_X64_NESTED_EVMCS1_PERF_GLOBAL_CTRL;
 			break;
-- 
2.37.3

