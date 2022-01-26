Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C99A49CA8F
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 14:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbiAZNSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 08:18:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23429 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238347AbiAZNSN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 08:18:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643203093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=utFAR93ugTdxvdfcY+avXvlaf0GmpnMgBzRTz2+S36I=;
        b=FMiiOljmfmy/OaluSUPMMeSn+SB+IPNqRGUn0eUjTIYo8ygV+Pf6TBfcWp9qRNEtuDakHt
        kxmpsNS2KiT985sXbH8un6twaBHuwTvbMvkz9qhH0uSE5kmIsNWqJH74Mun+KoCXKCGiia
        4Y5IcBf7T/DMZlIOiE0IVHnbe6yYMFM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-KeciOn9cOsasd1ir2TxtVg-1; Wed, 26 Jan 2022 08:18:09 -0500
X-MC-Unique: KeciOn9cOsasd1ir2TxtVg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F8F883DD28;
        Wed, 26 Jan 2022 13:18:08 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6EAE21ECB;
        Wed, 26 Jan 2022 13:18:05 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Check .flags in kvm_cpuid_check_equal() too
Date:   Wed, 26 Jan 2022 14:18:04 +0100
Message-Id: <20220126131804.2839410-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_cpuid_check_equal() checks for the (full) equality of the supplied
CPUID data so .flags need to be checked too.

Reported-by: Sean Christopherson <seanjc@google.com>
Fixes: c6617c61e8fe ("KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 89d7822a8f5b..ddfd97f62ba8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -133,6 +133,7 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
 		orig = &vcpu->arch.cpuid_entries[i];
 		if (e2[i].function != orig->function ||
 		    e2[i].index != orig->index ||
+		    e2[i].flags != orig->flags ||
 		    e2[i].eax != orig->eax || e2[i].ebx != orig->ebx ||
 		    e2[i].ecx != orig->ecx || e2[i].edx != orig->edx)
 			return -EINVAL;
-- 
2.34.1

