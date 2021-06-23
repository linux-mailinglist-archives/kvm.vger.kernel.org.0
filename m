Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C423B18ED
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 13:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhFWLcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 07:32:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43004 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230334AbhFWLco (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 07:32:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624447826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TquVtTCbnLzpTbg39PywmBoKSBaaFYHIsdoy9/8Ebns=;
        b=EHo8IN7fqN9lQ/hEHROfEcp/rQ+2VueqTOE56nh3169t09HXl9oex6sOd20MBRzJdbJeqB
        qQGvKfl+HSMfvYm3ngijMtVALjJn2zzVdBBjCC4zcvIowiuUEpPacMDWEABWqEzn4IeN8F
        C+kfgENknGRYuvzm2IPh2eZ7NULksh4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-g0zL71t6MY-L7bLI9-xOrg-1; Wed, 23 Jun 2021 07:30:24 -0400
X-MC-Unique: g0zL71t6MY-L7bLI9-xOrg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50F2F81C85F;
        Wed, 23 Jun 2021 11:30:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B0E85D6D7;
        Wed, 23 Jun 2021 11:30:19 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 03/10] KVM: x86: rename apic_access_page_done to apic_access_memslot_enabled
Date:   Wed, 23 Jun 2021 14:29:55 +0300
Message-Id: <20210623113002.111448-4-mlevitsk@redhat.com>
In-Reply-To: <20210623113002.111448-1-mlevitsk@redhat.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This better reflects the purpose of this variable on AMD, since
on AMD the AVIC's memory slot can be enabled and disabled dynamically.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/svm/avic.c         | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cadb09c6fb0e..9ed5c55be352 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1022,7 +1022,7 @@ struct kvm_arch {
 	struct kvm_apic_map __rcu *apic_map;
 	atomic_t apic_map_dirty;
 
-	bool apic_access_page_done;
+	bool apic_access_memslot_enabled;
 	unsigned long apicv_inhibit_reasons;
 
 	gpa_t wall_clock;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a9abed054cd5..1d01da64c333 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -236,7 +236,7 @@ static int avic_update_access_page(struct kvm *kvm, bool activate)
 	 * APICv mode change, which update APIC_ACCESS_PAGE_PRIVATE_MEMSLOT
 	 * memory region. So, we need to ensure that kvm->mm == current->mm.
 	 */
-	if ((kvm->arch.apic_access_page_done == activate) ||
+	if ((kvm->arch.apic_access_memslot_enabled == activate) ||
 	    (kvm->mm != current->mm))
 		goto out;
 
@@ -249,7 +249,7 @@ static int avic_update_access_page(struct kvm *kvm, bool activate)
 		goto out;
 	}
 
-	kvm->arch.apic_access_page_done = activate;
+	kvm->arch.apic_access_memslot_enabled = activate;
 out:
 	mutex_unlock(&kvm->slots_lock);
 	return r;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ab6f682645d7..e4491e6a7f89 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3621,7 +3621,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	int ret = 0;
 
 	mutex_lock(&kvm->slots_lock);
-	if (kvm->arch.apic_access_page_done)
+	if (kvm->arch.apic_access_memslot_enabled)
 		goto out;
 	hva = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
 				      APIC_DEFAULT_PHYS_BASE, PAGE_SIZE);
@@ -3641,7 +3641,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	 * is able to migrate it.
 	 */
 	put_page(page);
-	kvm->arch.apic_access_page_done = true;
+	kvm->arch.apic_access_memslot_enabled = true;
 out:
 	mutex_unlock(&kvm->slots_lock);
 	return ret;
-- 
2.26.3

