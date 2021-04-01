Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9573518AE
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhDARrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:47:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235223AbhDARm0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:42:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FIS/0wQGTd5OK3BSslmwGX7RkKLHKjJnfRIzlG6zbaM=;
        b=V29QjL5AGlfYxOZsKL7ipNev9ipJUHXCvFQejsOHPGdxJlHM9p/nlY43zQLVRJaQNiW9ym
        /BM5ILTiJ/jK9Hs2J+Pgio8yI6coTILfd8xxDojkvLw6uLj93tOeYJmDjFiB3RxJSOyVXy
        2xM5mK+BYtu82J4ullOCwf0Y6DrUR0s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-8mIH6vSUOoe_4kFyAEEnQg-1; Thu, 01 Apr 2021 07:16:25 -0400
X-MC-Unique: 8mIH6vSUOoe_4kFyAEEnQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3787E8030C9;
        Thu,  1 Apr 2021 11:16:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4293B1378E;
        Thu,  1 Apr 2021 11:16:20 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/2] KVM: x86: add guest_cpuid_is_intel
Date:   Thu,  1 Apr 2021 14:16:13 +0300
Message-Id: <20210401111614.996018-2-mlevitsk@redhat.com>
In-Reply-To: <20210401111614.996018-1-mlevitsk@redhat.com>
References: <20210401111614.996018-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

