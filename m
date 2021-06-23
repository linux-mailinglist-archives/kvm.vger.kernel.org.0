Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374A43B18EB
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 13:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhFWLcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 07:32:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230241AbhFWLcj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 07:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624447822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n0QdAravaiJgcCAZHuZxgNOdFK0/TUBAd16VZTru7CQ=;
        b=Q4jDLYWorsTe4y5w9fXvsYLV7b4iuAprvkQqRAAemeYS/lWnqdHziz/lBuQDS/NtX8ymRj
        cqXbXKm494Mw72UJMjxUYT9Ko7d0yIe7ztulZ/zhI93RnQcKzMchlJPTt+FfdtWtorbptY
        z23AZp37Ceg6kdSFk3eaTLdesFvck5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-zWudiY2LPaaJFC9prhqvMg-1; Wed, 23 Jun 2021 07:30:20 -0400
X-MC-Unique: zWudiY2LPaaJFC9prhqvMg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D19B362FB;
        Wed, 23 Jun 2021 11:30:19 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B82D85D6D7;
        Wed, 23 Jun 2021 11:30:13 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 02/10] KVM: x86: APICv: fix race in kvm_request_apicv_update on SVM
Date:   Wed, 23 Jun 2021 14:29:54 +0300
Message-Id: <20210623113002.111448-3-mlevitsk@redhat.com>
In-Reply-To: <20210623113002.111448-1-mlevitsk@redhat.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently on SVM, the kvm_request_apicv_update calls the
'pre_update_apicv_exec_ctrl' without doing any synchronization
and that function toggles the APIC_ACCESS_PAGE_PRIVATE_MEMSLOT.

If there is a mismatch between that memslot state and the AVIC state,
while a vCPU is in guest mode, an APIC mmio write can be lost:

For example:

VCPU0: enable the APIC_ACCESS_PAGE_PRIVATE_MEMSLOT
VCPU1: write to an APIC mmio register.

Since AVIC is still disabled on VCPU1, the access will not be intercepted
by it, and neither will it cause MMIO fault, but rather it will just update
the dummy page mapped into the APIC_ACCESS_PAGE_PRIVATE_MEMSLOT.

Fix that by blocking guest entries while we update the memslot.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9af2fbbe0521..6f0d9c231249 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9231,6 +9231,8 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 	if (!!old == !!new)
 		return;
 
+	kvm_block_guest_entries(kvm);
+
 	trace_kvm_apicv_update_request(activate, bit);
 	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
 		static_call(kvm_x86_pre_update_apicv_exec_ctrl)(kvm, activate);
@@ -9243,6 +9245,8 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 	except = kvm_get_running_vcpu();
 	kvm_make_all_cpus_request_except(kvm, KVM_REQ_APICV_UPDATE,
 					 except);
+
+	kvm_allow_guest_entries(kvm);
 	if (except)
 		kvm_vcpu_update_apicv(except);
 }
-- 
2.26.3

