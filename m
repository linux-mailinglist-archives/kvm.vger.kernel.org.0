Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9657E574E4D
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 14:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239638AbiGNMrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 08:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239183AbiGNMqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 08:46:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1EA6860510
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 05:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657802701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=D+G2aBYdpaVHU1+GCJKc9Xlzh4Vv7A/JYiBlhqiWbx4=;
        b=gOr7FPBlH8locUCfEPnz+yT74jU56QlIWPoGPbqEY3vDnNDZAIQovr+6qmWpjtnPOCUZED
        0D/r7Gh9zYDIgksLazhtP54dw7rxAu+n9TW/1XYmnzyBAtKn3Z6NgIgBsc7M6dp1O2WBAJ
        VbceeMzZH7+y+qV0LP/3/2VntXWo6WY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-NhUgbxy5NuisEU3v6EPlOg-1; Thu, 14 Jul 2022 08:44:59 -0400
X-MC-Unique: NhUgbxy5NuisEU3v6EPlOg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B5ED395AFE7;
        Thu, 14 Jul 2022 12:44:58 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F1E8401473;
        Thu, 14 Jul 2022 12:44:54 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: SVM: fix task switch emulation on INTn instruction.
Date:   Thu, 14 Jul 2022 15:44:53 +0300
Message-Id: <20220714124453.188655-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recently KVM's SVM code switched to re-injecting software interrupt events,
if something prevented their delivery.

Task switch due to task gate in the IDT, however is an exception
to this rule, because in this case, INTn instruction causes
a task switch intercept and its emulation completes the INTn
emulation as well.

Add a missing case to task_switch_interception for that.

This fixes 32 bit kvm unit test taskswitch2.

Fixes: 7e5b5ef8dca322 ("KVM: SVM: Re-inject INTn instead of retrying the insn on "failure"")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 41bd7c5aa06a1e..638dd94f6e11f6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2399,6 +2399,7 @@ static int task_switch_interception(struct kvm_vcpu *vcpu)
 			kvm_clear_exception_queue(vcpu);
 			break;
 		case SVM_EXITINTINFO_TYPE_INTR:
+		case SVM_EXITINTINFO_TYPE_SOFT:
 			kvm_clear_interrupt_queue(vcpu);
 			break;
 		default:
-- 
2.34.3

