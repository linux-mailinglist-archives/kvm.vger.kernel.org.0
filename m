Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAF34779BC
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 17:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239810AbhLPQwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 11:52:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44530 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239825AbhLPQw2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Dec 2021 11:52:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639673548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YARsa2xCtQyXOeEQD5Ge/WMElnEB2BlxVTO/JbO0Gkg=;
        b=jOrX32Q46KMQOYHa/5xZjXy9MUz0EWojfqAF3YtiQqVJexbSzsKzFNCE9qNbkunzaOnTOo
        0FBXWnqjq8IxZjBEpf1KxFLq7OSlqyPtqmmzq4k8FzRblGn/sBysug45nWg7Uyh6jm6z5F
        WKBINuZwsZ/P/lamUEIWB5btQdkFIYY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-j2Ei-z0bNJOkmXhYPwM94Q-1; Thu, 16 Dec 2021 11:52:24 -0500
X-MC-Unique: j2Ei-z0bNJOkmXhYPwM94Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22F1210144E1;
        Thu, 16 Dec 2021 16:52:23 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 033265ED59;
        Thu, 16 Dec 2021 16:52:20 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, oliver.sang@intel.com,
        Like Xu <like.xu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: x86: Drop guest CPUID check for host initiated writes to MSR_IA32_PERF_CAPABILITIES
Date:   Thu, 16 Dec 2021 17:52:13 +0100
Message-Id: <20211216165213.338923-3-vkuznets@redhat.com>
In-Reply-To: <20211216165213.338923-1-vkuznets@redhat.com>
References: <20211216165213.338923-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ability to write to MSR_IA32_PERF_CAPABILITIES from the host should
not depend on guest visible CPUID entries, even if just to allow
creating/restoring guest MSRs and CPUIDs in any sequence.

Fixes: 27461da31089 ("KVM: x86/pmu: Support full width counting")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0cf1082455df..9a2972fdae82 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3413,7 +3413,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		if (!msr_info->host_initiated)
 			return 1;
-		if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM) && kvm_get_msr_feature(&msr_ent))
+		if (kvm_get_msr_feature(&msr_ent))
 			return 1;
 		if (data & ~msr_ent.data)
 			return 1;
-- 
2.33.1

