Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D08449847
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 16:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240802AbhKHPbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 10:31:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238982AbhKHPbP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 10:31:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636385309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hi00ablbtPW4mDM5Uzsd1+FtR4HNpZDQEP+LPADyONk=;
        b=di/OfKhBrslPptf+Tf4F5ucnaFYBIpd7HAL2qmAHZz1OVC/Tk9MFzsi1qY3t+YsEpiYt1/
        Vpnu1Tru2b2tlNnUrH96kIjirXtzzmiH5pMhj1f5YCN7cPHjE6eJJ+v6Ve0iT1LH20dqFC
        9+9msY9IdodVSxznMCh4BZKJv8+o4fY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-8SyeynDTN6eRrKzcpJdleg-1; Mon, 08 Nov 2021 10:28:28 -0500
X-MC-Unique: 8SyeynDTN6eRrKzcpJdleg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F48B87D542;
        Mon,  8 Nov 2021 15:28:27 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 891E6794A4;
        Mon,  8 Nov 2021 15:28:25 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Li RongQing <lirongqing@baidu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: Don't update vcpu->arch.pv_eoi.msr_val when a bogus value was written to MSR_KVM_PV_EOI_EN
Date:   Mon,  8 Nov 2021 16:28:19 +0100
Message-Id: <20211108152819.12485-3-vkuznets@redhat.com>
In-Reply-To: <20211108152819.12485-1-vkuznets@redhat.com>
References: <20211108152819.12485-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When kvm_gfn_to_hva_cache_init() call from kvm_lapic_set_pv_eoi() fails,
MSR write to MSR_KVM_PV_EOI_EN results in #GP so it is reasonable to
expect that the value we keep internally in KVM wasn't updated.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/lapic.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3573b50d9036..4388d22df500 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2857,20 +2857,25 @@ int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
 	u64 addr = data & ~KVM_MSR_ENABLED;
 	struct gfn_to_hva_cache *ghc = &vcpu->arch.pv_eoi.data;
 	unsigned long new_len;
+	int ret;
 
 	if (!IS_ALIGNED(addr, 4))
 		return 1;
 
-	vcpu->arch.pv_eoi.msr_val = data;
-	if (!pv_eoi_enabled(vcpu))
-		return 0;
+	if (data & KVM_MSR_ENABLED) {
+		if (addr == ghc->gpa && len <= ghc->len)
+			new_len = ghc->len;
+		else
+			new_len = len;
 
-	if (addr == ghc->gpa && len <= ghc->len)
-		new_len = ghc->len;
-	else
-		new_len = len;
+		ret = kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, new_len);
+		if (ret)
+			return ret;
+	}
+
+	vcpu->arch.pv_eoi.msr_val = data;
 
-	return kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, new_len);
+	return 0;
 }
 
 int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
-- 
2.31.1

