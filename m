Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738F5303F64
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405204AbhAZNz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:55:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405397AbhAZNuM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 08:50:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611668920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+yLoZhm1WKDfe6FlyEgA0CnCHASPICgm9/1IhF5RC0c=;
        b=DuLxbTbE5KpJPNNeQm1AWKj69iuLPV62xzDGMtqzpd5fcHA5vmsvAHX5VEtkwrAOSNh14W
        y0XhkrADu6gnN26wcX+zb8nh1ebZrDEnc7zEa68bWaPzewvfnPeFEzyW+p3FIcUo2QvLA+
        V5uBZvAHWmq0G4DUcIg/VzWM4mWrfOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-Ys4EluelPj-zbUndGyRmyg-1; Tue, 26 Jan 2021 08:48:38 -0500
X-MC-Unique: Ys4EluelPj-zbUndGyRmyg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91947192CC4A;
        Tue, 26 Jan 2021 13:48:37 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 371605D9C2;
        Tue, 26 Jan 2021 13:48:36 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 09/15] KVM: x86: hyper-v: Stop shadowing global 'current_vcpu' variable
Date:   Tue, 26 Jan 2021 14:48:10 +0100
Message-Id: <20210126134816.1880136-10-vkuznets@redhat.com>
In-Reply-To: <20210126134816.1880136-1-vkuznets@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'current_vcpu' variable in KVM is a per-cpu pointer to the currently
scheduled vcpu. kvm_hv_flush_tlb()/kvm_hv_send_ipi() functions used
to have local 'vcpu' variable to iterate over vCPUs but it's gone
now and there's no need to use anything but the standard 'vcpu' as
an argument.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index d60f60ac53f1..9a52a07fab81 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1491,11 +1491,10 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
 	return vcpu_bitmap;
 }
 
-static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
-			    u16 rep_cnt, bool ex)
+static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool ex)
 {
-	struct kvm *kvm = current_vcpu->kvm;
-	struct kvm_vcpu_hv *hv_vcpu = &current_vcpu->arch.hyperv;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
 	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
@@ -1593,10 +1592,10 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
 	}
 }
 
-static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
+static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, u64 ingpa, u64 outgpa,
 			   bool ex, bool fast)
 {
-	struct kvm *kvm = current_vcpu->kvm;
+	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
 	struct hv_send_ipi send_ipi;
 	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
-- 
2.29.2

