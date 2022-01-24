Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CAA497D43
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 11:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbiAXKhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 05:37:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233480AbiAXKhU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 05:37:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643020640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=76KFo7+F7q/+fa6TW0D3p4zQquAYFcS3k3/N/jXiLDk=;
        b=XLahYA1ulLZoEOMl9VVcDarXCB59YgqhAhXrCWoyZprh8Afvs5hCRxYxob9xRDTS+pR122
        l+2ED+Tc+6My6uG2vpt6lOMnpDPhgqmHycZhMlvE9LQKY+ehh4G4M9cL03IahUwVBqtN29
        IBBRQJ2qQQXZ7qLsGaPBmAGAL89NnAQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-_QmXsZ7vPhWpAkpRBoH_XA-1; Mon, 24 Jan 2022 05:37:16 -0500
X-MC-Unique: _QmXsZ7vPhWpAkpRBoH_XA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FCDC425DB;
        Mon, 24 Jan 2022 10:37:15 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FC401F305;
        Mon, 24 Jan 2022 10:37:13 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: Use memcmp in kvm_cpuid_check_equal()
Date:   Mon, 24 Jan 2022 11:36:06 +0100
Message-Id: <20220124103606.2630588-3-vkuznets@redhat.com>
In-Reply-To: <20220124103606.2630588-1-vkuznets@redhat.com>
References: <20220124103606.2630588-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_cpuid_check_equal() should also check .flags equality but instead
of adding it to the existing check, just switch to using memcmp() for
the whole 'struct kvm_cpuid_entry2'.

When .flags are not checked, kvm_cpuid_check_equal() may allow an update
which it shouldn't but kvm_set_cpuid() does not actually update anything
and just returns success.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 89d7822a8f5b..7dd9c8f4f46e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -123,20 +123,11 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 				 int nent)
 {
-	struct kvm_cpuid_entry2 *orig;
-	int i;
-
 	if (nent != vcpu->arch.cpuid_nent)
 		return -EINVAL;
 
-	for (i = 0; i < nent; i++) {
-		orig = &vcpu->arch.cpuid_entries[i];
-		if (e2[i].function != orig->function ||
-		    e2[i].index != orig->index ||
-		    e2[i].eax != orig->eax || e2[i].ebx != orig->ebx ||
-		    e2[i].ecx != orig->ecx || e2[i].edx != orig->edx)
-			return -EINVAL;
-	}
+	if (memcmp(e2, vcpu->arch.cpuid_entries, nent * sizeof(*e2)))
+		return -EINVAL;
 
 	return 0;
 }
-- 
2.34.1

