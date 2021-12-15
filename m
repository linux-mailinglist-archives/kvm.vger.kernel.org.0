Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EEF475D32
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 17:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244732AbhLOQQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 11:16:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244747AbhLOQQn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 11:16:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639585002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8NJRR+a9hlTKwcYiYBaZVulZ3Qw4EA1LMUIGcFZHriw=;
        b=DcOv6pX1U3zwrCdpi+5m1estPT8ifbBRKT6XcQQpbaObkMEG7ZfjJ8Rt1j4JKpL1ijbm8e
        iC4pxEFV1WQii82ehHHdp7PkQ4McaPBCLE97+7yHoTWakHPWo77F2l8dmuaiCqMHkuKZ6l
        7Z9Hk0y+Rh9QVanrrdfCJCDkVvGT3JU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-op_bkYODMPCejNi40MvNyg-1; Wed, 15 Dec 2021 11:16:39 -0500
X-MC-Unique: op_bkYODMPCejNi40MvNyg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA4CD64141;
        Wed, 15 Dec 2021 16:16:37 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E46405E26D;
        Wed, 15 Dec 2021 16:16:18 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, oliver.sang@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: selftests: Avoid KVM_SET_CPUID2 after KVM_RUN in vmx_pmu_msrs_test
Date:   Wed, 15 Dec 2021 17:16:17 +0100
Message-Id: <20211215161617.246563-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN")
forbade chaning vCPU's CPUID data after the first KVM_RUN but
vmx_pmu_msrs_test does exactly that. Test VM needs to be re-created after
vcpu_run().

Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
index 23051d84b907..17882f79deed 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
@@ -99,6 +99,11 @@ int main(int argc, char *argv[])
 	vcpu_run(vm, VCPU_ID);
 	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), PMU_CAP_FW_WRITES);
 
+	/* Re-create guest VM after KVM_RUN so CPUID can be changed */
+	kvm_vm_free(vm);
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+
 	/* testcase 2, check valid LBR formats are accepted */
 	vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, 0);
 	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), 0);
-- 
2.33.1

