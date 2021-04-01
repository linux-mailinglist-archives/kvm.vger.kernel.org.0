Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDC935197A
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbhDARxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:53:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27886 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237272AbhDARvN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:51:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FIS/0wQGTd5OK3BSslmwGX7RkKLHKjJnfRIzlG6zbaM=;
        b=OYmka3utoOkydLxvmY/rLcaliMdQfBiZa48epWfgW/wxeh/7/C67cs7jtrpVJ6fVN99VPt
        Tl2aOA9qs2A6OZ3VFx649Ua/Am5vNl6CvOay/iiyUe1fyDzpkQSZCTk6QRxRsZG8PE+Cpf
        FH5wUJDogEDJa0l14zD+X9/dM9PsFEk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-IBYy-VNRN3KYZxwmugfmAg-1; Thu, 01 Apr 2021 07:19:37 -0400
X-MC-Unique: IBYy-VNRN3KYZxwmugfmAg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E6FD800D53;
        Thu,  1 Apr 2021 11:19:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 070F25F9B8;
        Thu,  1 Apr 2021 11:19:32 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 1/2] KVM: x86: add guest_cpuid_is_intel
Date:   Thu,  1 Apr 2021 14:19:27 +0300
Message-Id: <20210401111928.996871-2-mlevitsk@redhat.com>
In-Reply-To: <20210401111928.996871-1-mlevitsk@redhat.com>
References: <20210401111928.996871-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is similar to existing 'guest_cpuid_is_amd_or_hygon'

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/cpuid.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 2a0c5064497f..ded84d244f19 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -248,6 +248,14 @@ static inline bool guest_cpuid_is_amd_or_hygon(struct kvm_vcpu *vcpu)
 		is_guest_vendor_hygon(best->ebx, best->ecx, best->edx));
 }
 
+static inline bool guest_cpuid_is_intel(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 0, 0);
+	return best && is_guest_vendor_intel(best->ebx, best->ecx, best->edx);
+}
+
 static inline int guest_cpuid_family(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
-- 
2.26.2

