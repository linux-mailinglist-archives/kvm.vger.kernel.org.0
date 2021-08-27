Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3BA3F96DE
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 11:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244747AbhH0J03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 05:26:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244723AbhH0J02 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 05:26:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630056339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tEDo7g7U+rIYHXrY4zIonyyVXbr2M0Ko1oY9VVL5whU=;
        b=E5p7xpNrHTdDf0OEJeJmZTWc+zWNi220kkfQ5qLJBe2uep76klFWpchpUf7IIzOHQ6Yn1k
        /JSVbECIKlVNLk/QNR0dazB2tsGR2MKcvXT3n7VVpIqPba6TgDkqg9x7sJgPvzdaGzlgD/
        l8ImEcpgF1vq99aGoJPQeOBBp912tXM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-J6KPa_gZPsmnwNwSFN461w-1; Fri, 27 Aug 2021 05:25:35 -0400
X-MC-Unique: J6KPa_gZPsmnwNwSFN461w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F19E879A01;
        Fri, 27 Aug 2021 09:25:34 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 737EB60C5F;
        Fri, 27 Aug 2021 09:25:31 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/8] KVM: x86: hyper-v: Avoid calling kvm_make_vcpus_request_mask() with vcpu_mask==NULL
Date:   Fri, 27 Aug 2021 11:25:11 +0200
Message-Id: <20210827092516.1027264-4-vkuznets@redhat.com>
In-Reply-To: <20210827092516.1027264-1-vkuznets@redhat.com>
References: <20210827092516.1027264-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to making kvm_make_vcpus_request_mask() use for_each_set_bit()
switch kvm_hv_flush_tlb() to calling kvm_make_all_cpus_request() for 'all cpus'
case.

Note: kvm_make_all_cpus_request() (unlike kvm_make_vcpus_request_mask())
currently dynamically allocates cpumask on each call and this is suboptimal.
Both kvm_make_all_cpus_request() and kvm_make_vcpus_request_mask() are
going to be switched to using pre-allocated per-cpu masks.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index fe4a02715266..783a7f2441bd 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1839,16 +1839,19 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 
 	cpumask_clear(&hv_vcpu->tlb_flush);
 
-	vcpu_mask = all_cpus ? NULL :
-		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
-					vp_bitmap, vcpu_bitmap);
-
 	/*
 	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
 	 * analyze it here, flush TLB regardless of the specified address space.
 	 */
-	kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
-				    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
+	if (all_cpus) {
+		kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH_GUEST);
+	} else {
+		vcpu_mask = sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
+						    vp_bitmap, vcpu_bitmap);
+
+		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
+					    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
+	}
 
 ret_success:
 	/* We always do full TLB flush, set 'Reps completed' = 'Rep Count' */
-- 
2.31.1

