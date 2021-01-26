Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57A5303F49
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405463AbhAZNua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:50:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405443AbhAZNuS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 08:50:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611668932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=20zUiY87vUDZMvrWJC15pvKwEDm4ykgyl4LhTgPfhXA=;
        b=U8DhQwiTKk0DwlXjqrSt0P+LYdA9C3/36bBiMxkC7l+Cp19KD0N9MH6dh+rxcztYxpid8Y
        e0XgfmD8+8l24fyxJWl/4DGSKSmBbZ28RTBlVQgt3R0WlRT2lv/fIN+yoZp50rj6RVosKO
        llfjlb7Qxf4qNGkRhj0F7nXIYT77/+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-s7GsOIH_MdauXTTuxrCjVA-1; Tue, 26 Jan 2021 08:48:49 -0500
X-MC-Unique: s7GsOIH_MdauXTTuxrCjVA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA0E2192CC41;
        Tue, 26 Jan 2021 13:48:47 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 796095D9C2;
        Tue, 26 Jan 2021 13:48:46 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 15/15] KVM: x86: hyper-v: Drop hv_vcpu_to_vcpu() helper
Date:   Tue, 26 Jan 2021 14:48:16 +0100
Message-Id: <20210126134816.1880136-16-vkuznets@redhat.com>
In-Reply-To: <20210126134816.1880136-1-vkuznets@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hv_vcpu_to_vcpu() helper is only used by other helpers and
is not very complex, we can drop it without much regret.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.h | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index a0926125495a..1ec3b9a0b644 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -60,11 +60,6 @@ static inline struct kvm_vcpu_hv *to_hv_vcpu(struct kvm_vcpu *vcpu)
 	return vcpu->arch.hyperv;
 }
 
-static inline struct kvm_vcpu *hv_vcpu_to_vcpu(struct kvm_vcpu_hv *hv_vcpu)
-{
-	return hv_vcpu->vcpu;
-}
-
 static inline struct kvm_vcpu_hv_synic *to_hv_synic(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
@@ -74,7 +69,9 @@ static inline struct kvm_vcpu_hv_synic *to_hv_synic(struct kvm_vcpu *vcpu)
 
 static inline struct kvm_vcpu *hv_synic_to_vcpu(struct kvm_vcpu_hv_synic *synic)
 {
-	return hv_vcpu_to_vcpu(container_of(synic, struct kvm_vcpu_hv, synic));
+	struct kvm_vcpu_hv *hv_vcpu = container_of(synic, struct kvm_vcpu_hv, synic);
+
+	return hv_vcpu->vcpu;
 }
 
 static inline struct kvm_hv_syndbg *to_hv_syndbg(struct kvm_vcpu *vcpu)
@@ -118,7 +115,7 @@ static inline struct kvm_vcpu *hv_stimer_to_vcpu(struct kvm_vcpu_hv_stimer *stim
 
 	hv_vcpu = container_of(stimer - stimer->index, struct kvm_vcpu_hv,
 			       stimer[0]);
-	return hv_vcpu_to_vcpu(hv_vcpu);
+	return hv_vcpu->vcpu;
 }
 
 static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
-- 
2.29.2

