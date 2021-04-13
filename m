Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0463935DEE1
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345832AbhDMM2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:28:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47009 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345700AbhDMM2A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:28:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FGtFF7jhsw/ykKn6fZnKyKnXNxaVpoMQNCbt41jAeMY=;
        b=KK+N6BLrgmhXhVxBhcXv3ag7FaLDDBEy1iXojUv50kQ7do+EIdpLz6NGnqY7bCbyf4E06Q
        bW9KBxZLYmxg6AKJCzFAiLST359GrgiO1n4Jm/TKVaTBpBg6bkQXI3asK9Awd3uyd5OqS5
        GYmhmDDjG8LU2a8RC/0jZrUls1O0we0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-5wGFQlaKM-K3Pf80d4lldw-1; Tue, 13 Apr 2021 08:27:38 -0400
X-MC-Unique: 5wGFQlaKM-K3Pf80d4lldw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C3A419611AD;
        Tue, 13 Apr 2021 12:27:37 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B21A017BB6;
        Tue, 13 Apr 2021 12:27:32 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 17/22] KVM: x86: hyper-v: Honor HV_POST_MESSAGES privilege bit
Date:   Tue, 13 Apr 2021 14:26:25 +0200
Message-Id: <20210413122630.975617-18-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V partition must possess 'HV_POST_MESSAGES' privilege to issue
HVCALL_POST_MESSAGE hypercalls.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 0df18187d908..6e4bf1da9dcf 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2073,12 +2073,16 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	u64 param, ingpa, outgpa, ret = HV_STATUS_SUCCESS;
 	uint16_t code, rep_idx, rep_cnt;
 	bool fast, rep;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
 	/*
 	 * hypercall generates UD from non zero cpl and real mode
-	 * per HYPER-V spec
+	 * per HYPER-V spec. Fail the call when 'hv_vcpu' context
+	 * was not allocated (e.g. per-vCPU Hyper-V CPUID entries
+	 * are unset) as well.
 	 */
-	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 || !is_protmode(vcpu)) {
+	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 || !is_protmode(vcpu) ||
+	    !hv_vcpu) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
@@ -2125,6 +2129,12 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 			break;
 		fallthrough;	/* maybe userspace knows this conn_id */
 	case HVCALL_POST_MESSAGE:
+		if (unlikely(!(hv_vcpu->cpuid_cache.features_ebx &
+			       HV_POST_MESSAGES))) {
+			ret = HV_STATUS_ACCESS_DENIED;
+			break;
+		}
+
 		/* don't bother userspace if it has no way to handle it */
 		if (unlikely(rep || !to_hv_synic(vcpu)->active)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-- 
2.30.2

