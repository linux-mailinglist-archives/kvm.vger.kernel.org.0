Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8523535DEF4
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239223AbhDMMaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:30:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345762AbhDMM2N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:28:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IGQywB7E/UfuggqU2qvxH/Kn9lWGAmCZ1u/iTfLS0l0=;
        b=WGr/KztGqlIJmR7Wn7RAPRjjS2CH2mUiFhcIV3wDIJJbTKW6fb/Y6XH7GfL3VZx8vUYlx4
        6perIZPYr9hymYBEgFlKlS6w0NORUEL7NgoyPhAvYgEp1qqjouKr8Cf95s5DHFlQm+2Nxm
        Wy+AKz74lmnQGKMhYKv8Xup500gFbks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-Ps4Cnv96MKyN4Fy3WsCYbw-1; Tue, 13 Apr 2021 08:27:52 -0400
X-MC-Unique: Ps4Cnv96MKyN4Fy3WsCYbw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F17D5A40CC;
        Tue, 13 Apr 2021 12:27:50 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E24CA60C04;
        Tue, 13 Apr 2021 12:27:46 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 22/22] KVM: x86: hyper-v: Check access to HVCALL_NOTIFY_LONG_SPIN_WAIT hypercall
Date:   Tue, 13 Apr 2021 14:26:30 +0200
Message-Id: <20210413122630.975617-23-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 arch/x86/kvm/hyperv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 37b8ff30fc1d..325446833bbe 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2113,6 +2113,12 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 
 	switch (code) {
 	case HVCALL_NOTIFY_LONG_SPIN_WAIT:
+		if (unlikely(!hv_vcpu->cpuid_cache.enlightenments_ebx ||
+			     hv_vcpu->cpuid_cache.enlightenments_ebx == U32_MAX)) {
+			ret = HV_STATUS_ACCESS_DENIED;
+			break;
+		}
+
 		if (unlikely(rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
-- 
2.30.2

