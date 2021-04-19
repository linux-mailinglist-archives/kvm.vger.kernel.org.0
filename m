Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0943647CD
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242575AbhDSQDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:03:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33767 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242321AbhDSQCy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 12:02:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618848144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xzXJ0fqMhO34LTNXk4s+XbzarJu9fdziD+Dr92OHm/o=;
        b=CENA/adsQgkt8flrlbEW1pYWV5ED9aNB2tSfi4qlr0uXKVFPOHy3LvUsKf+v7liHxCePst
        VACpd3+qx4mrPInFlzx6X5oECSAUMadgXQV0TtSwhe94hRqQHGplmmSMjeSQSdjK+XhrtB
        2Ltrpi0EbT3cbB8KNStj2AETkSONdyk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-7QY8MAdHP-qhGdo-MFZzxA-1; Mon, 19 Apr 2021 12:02:22 -0400
X-MC-Unique: 7QY8MAdHP-qhGdo-MFZzxA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8788C8030C9;
        Mon, 19 Apr 2021 16:02:21 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76E6919809;
        Mon, 19 Apr 2021 16:02:19 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/30] KVM: x86: hyper-v: Check access to HVCALL_NOTIFY_LONG_SPIN_WAIT hypercall
Date:   Mon, 19 Apr 2021 18:01:18 +0200
Message-Id: <20210419160127.192712-22-vkuznets@redhat.com>
In-Reply-To: <20210419160127.192712-1-vkuznets@redhat.com>
References: <20210419160127.192712-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TLFS6.0b states that partition issuing HVCALL_NOTIFY_LONG_SPIN_WAIT must
posess 'UseHypercallForLongSpinWait' privilege but there's no
corresponding feature bit. Instead, we have "Recommended number of attempts
to retry a spinlock failure before notifying the hypervisor about the
failures. 0xFFFFFFFF indicates never notify." Use this to check access to
the hypercall. Also, check against zero as the corresponding CPUID must
be set (and '0' attempts before re-try is weird anyway).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 4f0ab0c50c44..bd424f2d4294 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2024,6 +2024,17 @@ static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, bool fast, u64 param)
 
 static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 {
+	if (!hv_vcpu->enforce_cpuid)
+		return true;
+
+	switch (code) {
+	case HVCALL_NOTIFY_LONG_SPIN_WAIT:
+		return hv_vcpu->cpuid_cache.enlightenments_ebx &&
+			hv_vcpu->cpuid_cache.enlightenments_ebx != U32_MAX;
+	default:
+		break;
+	}
+
 	return true;
 }
 
-- 
2.30.2

