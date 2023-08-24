Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD515787B1A
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 00:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243766AbjHXWA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 18:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243846AbjHXWAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 18:00:24 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F30E1BD4;
        Thu, 24 Aug 2023 15:00:19 -0700 (PDT)
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OKRHsA020061;
        Thu, 24 Aug 2023 21:59:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pps0720;
 bh=CASWTq5OVcRru8tc6k2AOfuwFzR62vtIBb/D4ZT1Ld4=;
 b=oeNIPxZyiEEwh49S0qMv2u7t1Gzhhe6YRS81IFhnrhVDabWZMmRnn74MXA29g904tA0M
 x718oPTlwtvhIy9lD6hbHwOqZVRJINPpp71h9e1I9+fDnNuDBPvPZSmPxqYm+/rpcCiL
 D85no9wIBGjYjdNphHmOMVaEGhmSqii0bbhYOXxFFkdEpNZ+3VNTj+tQ+ZwR1Akq8myL
 DuAw6oQZc4+/2v/rs6ur5PidgryDjI5CmAIgYgu3m1V4eDBgnQjLTMnv/Sl63YN3+0yM
 IYjm6I2ReQKzR9K+uBbeRSb0PDGk101KIVKJeAfOoFYrR9+uWwd4zU7OLEMo1D3nsQUf Ew== 
Received: from p1lg14878.it.hpe.com ([16.230.97.204])
        by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 3sp69adf7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 21:59:38 +0000
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by p1lg14878.it.hpe.com (Postfix) with ESMTPS id E7574D2EA;
        Thu, 24 Aug 2023 21:59:37 +0000 (UTC)
Received: from dog.eag.rdlabs.hpecorp.net (unknown [16.231.227.39])
        by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTP id F2285809623;
        Thu, 24 Aug 2023 21:59:36 +0000 (UTC)
Received: by dog.eag.rdlabs.hpecorp.net (Postfix, from userid 48777)
        id 482A0302F47FB; Thu, 24 Aug 2023 16:59:36 -0500 (CDT)
From:   Kyle Meyer <kyle.meyer@hpe.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     russ.anderson@hpe.com, dimitri.sivanich@hpe.com,
        steve.wahl@hpe.com, Kyle Meyer <kyle.meyer@hpe.com>
Subject: [PATCH v3] KVM: x86: Add CONFIG_KVM_MAX_NR_VCPUS
Date:   Thu, 24 Aug 2023 16:52:46 -0500
Message-Id: <20230824215244.3897419-1-kyle.meyer@hpe.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: CiGzJTnl_NVB2nZUSj8HY8a4321aT84J
X-Proofpoint-ORIG-GUID: CiGzJTnl_NVB2nZUSj8HY8a4321aT84J
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_18,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308240191
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a Kconfig entry to set the maximum number of vCPUs per KVM guest and
set the default value to 4096 when MAXSMP is enabled.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
---
v2 -> v3: Default KVM_MAX_VCPUS to 1024 when CONFIG_KVM_MAX_NR_VCPUS is not
defined. This prevents build failures in arch/x86/events/intel/core.c and
drivers/vfio/vfio_main.c when KVM is disabled.

 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/Kconfig            | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3bc146dfd38d..cd27e0a00765 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -39,7 +39,11 @@
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
+#ifdef CONFIG_KVM_MAX_NR_VCPUS
+#define KVM_MAX_VCPUS CONFIG_KVM_MAX_NR_VCPUS
+#else
 #define KVM_MAX_VCPUS 1024
+#endif
 
 /*
  * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 89ca7f4c1464..e730e8255e22 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -141,4 +141,15 @@ config KVM_XEN
 config KVM_EXTERNAL_WRITE_TRACKING
 	bool
 
+config KVM_MAX_NR_VCPUS
+	int "Maximum number of vCPUs per KVM guest"
+	depends on KVM
+	range 1024 4096
+	default 4096 if MAXSMP
+	default 1024
+	help
+	  Set the maximum number of vCPUs per KVM guest. Larger values will increase
+	  the memory footprint of each KVM guest, regardless of how many vCPUs are
+	  configured.
+
 endif # VIRTUALIZATION
-- 
2.26.2

