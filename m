Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D414779BA
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 17:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239826AbhLPQw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 11:52:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239786AbhLPQw0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Dec 2021 11:52:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639673545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g6j5QDQ16FkPLh9q5FUjlBB7oPlxDLlzImTJ67107KE=;
        b=R/3NXQkxWx3rNNoIXO/LRIfOLEW396C+TTY2rVMmvug1+A2h3zjCsepMFmMVSV9UH3ZEFx
        yBW+XU5rgyw2JCyq39i6WZya5vEgbTWQTSjMrwYPLv8qB0AMeykcboLbSPHqaR+yIfcFMG
        Z1wWJfv2KqGSjwHuN01umFA1ErnKvOQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-gx-sTsrRNCyIBs71zCpD2w-1; Thu, 16 Dec 2021 11:52:22 -0500
X-MC-Unique: gx-sTsrRNCyIBs71zCpD2w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9868C81CCB4;
        Thu, 16 Dec 2021 16:52:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59E385ED59;
        Thu, 16 Dec 2021 16:52:18 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, oliver.sang@intel.com,
        Like Xu <like.xu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: selftests: vmx_pmu_msrs_test: Drop tests mangling guest visible CPUIDs
Date:   Thu, 16 Dec 2021 17:52:12 +0100
Message-Id: <20211216165213.338923-2-vkuznets@redhat.com>
In-Reply-To: <20211216165213.338923-1-vkuznets@redhat.com>
References: <20211216165213.338923-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Host initiated writes to MSR_IA32_PERF_CAPABILITIES should not depend
on guest visible CPUIDs and (incorrect) KVM logic implementing it is
about to change. Also, KVM_SET_CPUID{,2} after KVM_RUN is now forbidden
and causes test to fail.

Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/vmx_pmu_msrs_test.c    | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
index 23051d84b907..2454a1f2ca0c 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
@@ -110,22 +110,5 @@ int main(int argc, char *argv[])
 	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
 	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
 
-	/* testcase 4, set capabilities when we don't have PDCM bit */
-	entry_1_0->ecx &= ~X86_FEATURE_PDCM;
-	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
-	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
-	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
-
-	/* testcase 5, set capabilities when we don't have PMU version bits */
-	entry_1_0->ecx |= X86_FEATURE_PDCM;
-	eax.split.version_id = 0;
-	entry_1_0->ecx = eax.full;
-	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
-	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_FW_WRITES);
-	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
-
-	vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, 0);
-	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), 0);
-
 	kvm_vm_free(vm);
 }
-- 
2.33.1

