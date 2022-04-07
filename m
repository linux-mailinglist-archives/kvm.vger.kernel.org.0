Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3F54F8458
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345386AbiDGP7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345381AbiDGP7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:59:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F242D444B
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 08:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649347049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OmOrCrOZP+EZ/JIBtJT6NtgP80Gb0qN7vvkABQBA7/0=;
        b=YfW0ImRix/UVDlvJLmv7Fr8ygMI0ROPPNVEXRj4wDQ+8BBuAQGWQphK6gfKNLtOmpGRYc+
        BlqC9hmIElyVrH7fgJ+z1TrhWwjruUTTSflHuagg9AR29BWMLXkOoDk8rOZ36GhmVl/t/T
        49sDf5HTGtdkbI70ag7NVO8EUxDmg5E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-n88tJfXlMteqc3tmY29G5w-1; Thu, 07 Apr 2022 11:57:26 -0400
X-MC-Unique: n88tJfXlMteqc3tmY29G5w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 206CB80159B;
        Thu,  7 Apr 2022 15:57:26 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43D1E427852;
        Thu,  7 Apr 2022 15:57:24 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 17/31] KVM: x86: KVM_REQ_TLB_FLUSH_CURRENT is a superset of KVM_REQ_HV_TLB_FLUSH too
Date:   Thu,  7 Apr 2022 17:56:31 +0200
Message-Id: <20220407155645.940890-18-vkuznets@redhat.com>
In-Reply-To: <20220407155645.940890-1-vkuznets@redhat.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_REQ_TLB_FLUSH_CURRENT is an even stronger operation than
KVM_REQ_TLB_FLUSH_GUEST so KVM_REQ_HV_TLB_FLUSH needs not to be
processed after it.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2074d52b0666..59d19a3f0275 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3338,8 +3338,11 @@ static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
  */
 void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
 {
-	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu)) {
 		kvm_vcpu_flush_tlb_current(vcpu);
+		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
+			kvm_hv_vcpu_empty_flush_tlb(vcpu);
+	}
 
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
 		kvm_vcpu_flush_tlb_guest(vcpu);
-- 
2.35.1

