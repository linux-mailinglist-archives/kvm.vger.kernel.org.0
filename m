Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51B046E69A
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 11:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhLIKda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 05:33:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234403AbhLIKda (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 05:33:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639045796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=avqglDHR3vd4/WSSWtIhIY1zOoetjsGwKLe9cebJDlg=;
        b=McIadoxlRbVKcPowe1FOfSsiVwDF3mTuvy+zvRrPBByuD5O61Lf97ztyZdi3v+CXlSbA0w
        t85oEFfQiCjhFbtrnCimg84cviiXErhSWgfqBYLJzm2jVLgpiL1RVV39v3T5NvN2MfKe7Y
        AY4oajtphRn3szE08YbjX84UavAxTcg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-53954IRTPKi4HdSagMG3jA-1; Thu, 09 Dec 2021 05:29:55 -0500
X-MC-Unique: 53954IRTPKi4HdSagMG3jA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C711100D09F;
        Thu,  9 Dec 2021 10:29:54 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09A7D5ED2C;
        Thu,  9 Dec 2021 10:29:38 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Wait for IPIs to be delivered when handling Hyper-V TLB flush hypercall
Date:   Thu,  9 Dec 2021 11:29:37 +0100
Message-Id: <20211209102937.584397-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prior to commit 0baedd792713 ("KVM: x86: make Hyper-V PV TLB flush use
tlb_flush_guest()"), kvm_hv_flush_tlb() was using 'KVM_REQ_TLB_FLUSH |
KVM_REQUEST_NO_WAKEUP' when making a request to flush TLBs on other vCPUs
and KVM_REQ_TLB_FLUSH is/was defined as:

 (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)

so KVM_REQUEST_WAIT was lost. Hyper-V TLFS, however, requires that
"This call guarantees that by the time control returns back to the
caller, the observable effects of all flushes on the specified virtual
processors have occurred." and without KVM_REQUEST_WAIT there's a small
chance that the vCPU making the TLB flush will resume running before
all IPIs get delivered to other vCPUs and a stale mapping can get read
there.

Fix the issue by adding KVM_REQUEST_WAIT flag to KVM_REQ_TLB_FLUSH_GUEST:
kvm_hv_flush_tlb() is the sole caller which uses it for
kvm_make_all_cpus_request()/kvm_make_vcpus_request_mask() where
KVM_REQUEST_WAIT makes a difference.

Cc: stable@kernel.org
Fixes: 0baedd792713 ("KVM: x86: make Hyper-V PV TLB flush use tlb_flush_guest()")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
- Note, the issue was found by code inspection. Sporadic crashes of
big Windows guests using Hyper-V TLB flush enlightenment were reported
but I have no proof that these crashes are anyhow related.
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e41ad1ead721..8afb21c8a64f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -97,7 +97,7 @@
 	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_TLB_FLUSH_CURRENT	KVM_ARCH_REQ(26)
 #define KVM_REQ_TLB_FLUSH_GUEST \
-	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_NO_WAKEUP)
+	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_APF_READY		KVM_ARCH_REQ(28)
 #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
 #define KVM_REQ_UPDATE_CPU_DIRTY_LOGGING \
-- 
2.33.1

