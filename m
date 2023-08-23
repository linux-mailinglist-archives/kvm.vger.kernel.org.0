Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A467860D2
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 21:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238348AbjHWTlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 15:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238355AbjHWTkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 15:40:49 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E11CE60;
        Wed, 23 Aug 2023 12:40:45 -0700 (PDT)
Received: from pps.filterd (m0148663.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37NFZaDA004726;
        Wed, 23 Aug 2023 19:40:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pps0720;
 bh=NJk7uKqzZfaDUMBpcVV0dSetAcJTOptjUOeTEPfABkM=;
 b=hvbj0T0n4PBkC9AjqnCH4V3IhxSSHSpgKignRsjPAFuuYVnbyHwdpZjW71ouGMDir7Ex
 gBdtVKKtaoWWzShKFcwSpdOA5hEH2dG/zLB4d3z/q0+kuvYhd9zBiTooBpdLlIxEHOQh
 AbaebI+bz31Q3UPNZee6oSVe0r2AthJeJ+LxwEkPnxy/dCabSZLABLY6Iq3fCU+1wmUS
 QBmE2WPVwvXQPiEzp8Q0pezZL9sbfcEzkJq0yLWkk3lLwl6Nmng6bCs8IsHb2oyhywTx
 8YmP5nJSdB/KzAHNcG1uvBjRGNrr2afx+RK0kfMMm+RbpRsMM2iovKQZD3RP4noG09I5 UQ== 
Received: from p1lg14879.it.hpe.com ([16.230.97.200])
        by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 3sngp6cex2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Aug 2023 19:40:05 +0000
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 43D4DD2B7;
        Wed, 23 Aug 2023 19:40:04 +0000 (UTC)
Received: from dog.eag.rdlabs.hpecorp.net (unknown [16.231.227.39])
        by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTP id 3D3AD80D508;
        Wed, 23 Aug 2023 19:40:02 +0000 (UTC)
Received: by dog.eag.rdlabs.hpecorp.net (Postfix, from userid 48777)
        id 78434302F47FB; Wed, 23 Aug 2023 14:40:02 -0500 (CDT)
From:   Kyle Meyer <kyle.meyer@hpe.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     russ.anderson@hpe.com, dimitri.sivanich@hpe.com,
        steve.wahl@hpe.com, Kyle Meyer <kyle.meyer@hpe.com>
Subject: [PATCH v2] KVM: x86: Add CONFIG_KVM_MAX_NR_VCPUS
Date:   Wed, 23 Aug 2023 14:38:43 -0500
Message-Id: <20230823193842.2544394-1-kyle.meyer@hpe.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 1Xa4qXbxoNhfas12PkiDIBWJI_t8cEaY
X-Proofpoint-ORIG-GUID: 1Xa4qXbxoNhfas12PkiDIBWJI_t8cEaY
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-23_13,2023-08-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308230178
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/Kconfig            | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3bc146dfd38d..536317812b52 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -39,7 +39,7 @@
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
-#define KVM_MAX_VCPUS 1024
+#define KVM_MAX_VCPUS CONFIG_KVM_MAX_NR_VCPUS
 
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

