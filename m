Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C50562CB7D
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 21:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbiKPUwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 15:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234443AbiKPUwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 15:52:06 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75FF63CFE;
        Wed, 16 Nov 2022 12:51:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QO7MQFENY+81+i24xoYpTfbrtraJLWvaUheqJ2znX8hHV1+imUxGSsO4uVNofPd7Q7BAxQNMzGnc5rPfgFk5UXfEyd0oCzVo7tzD1a2iiHqBHR4vZsr2jJhVPBCjrdbcbVTDWyG6uh30R74k8Zo81iJSjQw24gEZy10PC7X0mpC5ddNb0ql7gNYZ62eovD2Aq9HyX7aoJdwEryKqZAJ9PrpfRG8Tpl5bgb5qUw3bpKa3/6b8ZfupjUHYsHHHa61ZToPpXgOEqb0/7NJDIuqnaM4Cj6eW8WvFXcb+OZyxD9H+SQVXLZT2opo9AJU+PAs6ZilvdGKcX8zf+e/fzcIeQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oz6dbP+0E/wfqulCBGKhPtkqzmJ1DHOrBpgLay51ycU=;
 b=glDqmW4y225JsE95h/qUuJr/O+SNDQe+sT70rXAG2xOyi7Sh9hRv+4bu1nq37y8KueiVqgHTswJNARvSdmZPfbzUaCqPvD3AHBJmhW604k57yT0zIphJx+NBRhJ8OIDF6sJSGjiTweC6cwMIx5n1+PxE72LoZynt+6BP+O5PRHFQ2gZU0agvu5CJEm+razQ9gccBDnkI5NXWhBNyDlkC0hX/O3+ofb49fGGJFB2vjz3ZUZDhYsAJfnoSLrJ2t9W0djAsmfSQuJNwJEkKuT8wNlVFSqytvupqY7wlJd6u1ikFFKyoK0tpbuAJiEmQUyR8naoMswyKRTpMU3/+sPqVDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oz6dbP+0E/wfqulCBGKhPtkqzmJ1DHOrBpgLay51ycU=;
 b=uVqfKcTsWEzSa9r9QRohkokfK1r4pzmMec3qj8EgFw+yzmAMQEnW8guni23D9HffDx2+4+0mPdBHuw8+snPiTOJZHvxJ+uTPeg+ZoM/YaXWzEM4otPCpLtL6djPX0qKouGld+ypOhDCwxxUfNaJZxFOEJMm7B6g5HMvVf80Zpqs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from MN0PR19MB6407.namprd19.prod.outlook.com (2603:10b6:208:3c0::20)
 by MW3PR19MB4332.namprd19.prod.outlook.com (2603:10b6:303:45::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Wed, 16 Nov
 2022 20:51:47 +0000
Received: from MN0PR19MB6407.namprd19.prod.outlook.com
 ([fe80::db4d:6649:2aef:bae9]) by MN0PR19MB6407.namprd19.prod.outlook.com
 ([fe80::db4d:6649:2aef:bae9%5]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 20:51:47 +0000
Date:   Wed, 16 Nov 2022 13:51:44 -0700
From:   Greg Edwards <gedwards@ddn.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Greg Edwards <gedwards@ddn.com>
Subject: [PATCH v2] KVM: x86: Allow APICv APIC ID inhibit to be cleared
Message-ID: <20221116205123.18737-1-gedwards@ddn.com>
References: <20221114202037.254176-1-gedwards@ddn.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114202037.254176-1-gedwards@ddn.com>
X-Mailer: git-send-email 2.38.1
X-ClientProxiedBy: CH0PR03CA0222.namprd03.prod.outlook.com
 (2603:10b6:610:e7::17) To MN0PR19MB6407.namprd19.prod.outlook.com
 (2603:10b6:208:3c0::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR19MB6407:EE_|MW3PR19MB4332:EE_
X-MS-Office365-Filtering-Correlation-Id: d53271ff-1738-42f0-82b0-08dac8146082
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yDWkzjNPxXnO8R8PqsWoA2EoIBNSHjjEket4cLVLSsjFa8AZ8q6SKcX0V6jUq9aLBV57ZrO1XFR4JYuyxwymnET7GHNbvXDRMIMjIvzHthlA9WGeA11CcG9Odsq7OUh/HBGVw03hhRHJaCKWsmD6ZUNEo9HdFiCBb2EyhpTGY9KjZRDmcl9n4BaVKduzTVGEvHr0Q+jhlLGlSr/9fS3veL63dxnOcvd3RUpPBecDQ0bJxR6SSY+QluCicn45OTBAPHylDOuZ+S6g62ySTcR/3x1ZlvxjsToLAPEOTwp7qFSw2G5iM7dsm4VLA1IKXjqNrzEeLieZyHUI6JyTNOXFY1urwBO48LDs3wYHdaW80d/uzYXCMQpQ7T0r9lQNrQa9h6idaE69VrzMZ5NYQBvy+zDhY+mZD3VQ9AYlgbAj1FVqBP1f6YoktEAsIaFpWQn37Th16arTz2KA0cN4ijFjsOHuzIbY7yTzKt7rG6XhSeJnFtm14iv4ghleR13/zUfa4xFU8OG5TkWoVTrSPLIIBPPkzMomOACRoPxeNECpZ71WjpaDa3agQEmaIPITfhmlJGZGPFLfBWLjm+T8io+MwdiE9+RtsVDFl6b389QVFW27aPc2afAo+WSLgGrjZUAOmgXWXuwwlWEjSP2oA6rwv27EK9liIEZ79fBkmb/W0O1dpRNjhHzAfbDlb+6OwC55Frnfy8sgc6G2FQCnV0Jh7rxRi5t3e4U/astbT0SQxwY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR19MB6407.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(366004)(376002)(346002)(396003)(136003)(451199015)(66556008)(66476007)(66946007)(4326008)(8676002)(8936002)(83380400001)(5660300002)(186003)(1076003)(2616005)(36756003)(38100700002)(6506007)(6666004)(6512007)(316002)(54906003)(2906002)(478600001)(41300700001)(86362001)(966005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dnsFSZREIK3dZxeBfrs4PySK51srPBOBKDOfC8J+t7LkFM0Osu8qvFGt+eMB?=
 =?us-ascii?Q?WiXVHSegNmj6S9fxaX7OhJJSSAwNPNErL1PdIngSZSYWJF77YzTUWSM7bs5t?=
 =?us-ascii?Q?qHThYnY1PK55IkdG8ONIphBXgHHIzZ/MfjdJolwPctZvg3h3nJFXR7VJqHjs?=
 =?us-ascii?Q?R7SnDMxsOPkUr4mzSiizWrb+Y5UFuLnzy53odxQO+lgWDxBUrBp+9Winb9iV?=
 =?us-ascii?Q?3+DvXL3vdPIu3EwhcgQlsFtWbBYa2kza/rFTKG600jpXyxLHx87X6ivl1iE/?=
 =?us-ascii?Q?2Hsv6sQ8+kX7H6ra+4XiUdviEQ6FfCi3PBOXF9Eh8KeRCVRGAUgSvGmRPqDv?=
 =?us-ascii?Q?UaP/Io3giykUD1rylUffFT69Xt9Q3VXvSi8SH+JxLZeEhdqi/N+Cyz2P+4qJ?=
 =?us-ascii?Q?xDt5ZpMiM+sSkwto8oQ5nYsiRvjcilHdAqvG4RSCSLYThPANHLPZ1CnjJTcx?=
 =?us-ascii?Q?k2npzx43N0HuQ3mdOnjIWN1XYhteJ4qIWxXG4KVKDGg5MqpB8WXaVSuek5T5?=
 =?us-ascii?Q?DxtFQLxSUI+MAJw3n3ujCakCJAVj3YsG8NIYOZgf8XrEIG//8qfMrQ4faSEP?=
 =?us-ascii?Q?4urXW6AKBVyxj706ieqYYMd7QwvuHI/3oe1JBxy3X7wKphFhDImN68rFcr3L?=
 =?us-ascii?Q?hhS4SZFzcX/UOyRXJnHngzyy6ghtGj+p3Y//NbFXmxbA7mftijwHhICqo/gh?=
 =?us-ascii?Q?vlV2lTTCt9MLqly2MPZMNFGLb5il/c+OnAVp12l7u7sKWph2YSh0+ioUO4Ov?=
 =?us-ascii?Q?OhSmjns6dGI4whoKzT8/AsE0ZVecAhdYmB3gjQr6aFzH9Fa3LHt/LV9aZIcf?=
 =?us-ascii?Q?inPkBzSHsqL297cBPV+qPvfHHfoRh6oxQr7kYokJFvLkyXgSPSEowNdwhKM0?=
 =?us-ascii?Q?DGS5HQu7ntNdB0grlJSA4ffWkbCBXboh1ntaollN2b7W1QSKKT7gHCoaRqwf?=
 =?us-ascii?Q?OMhg9uRV4vj8Dz/tosEN4ix2trbDF3VcZOcbkElOPHSqkKhxzEOtEbiNvPkH?=
 =?us-ascii?Q?OuyiptBo2QRhDDd7P1gKVWZpVpDQmtsEPX98Bj0VL8NquU7nmZI+bE7an6zL?=
 =?us-ascii?Q?lqvg4WmrBMMa4NESi9DsdVS1qHyry1XYir/YMfV50EVpJaIaj/YkDoYFBvAD?=
 =?us-ascii?Q?y42LpVVd07TOZfyKFq5sDv0t7y9tHfJFmQ7s9qiw8uikyoLWZJVCsKRNg+Gk?=
 =?us-ascii?Q?v9b3NDbZBsXQt1MO+xhGkpOI7pMnYicSr9ziGn72/t2BLAfdwwb3XHuHQrpP?=
 =?us-ascii?Q?ne2Cc43nS3ETJ9RdqPvv0gQ11sVOirGSRbnC06gIGIp79tVqxbXqgWuzqAdT?=
 =?us-ascii?Q?nkTOICH+xMX5bpZ8umvOuMDK4ypSXfKmALbqDUmzCNsRCfGDUX6uMCSdJMwf?=
 =?us-ascii?Q?AqREc02gUGjZ16i3HrCjKdC+sLxOczLw2lVbuzTvxp1/GUKmJLxuzSQNX+tG?=
 =?us-ascii?Q?AIaBxw1lkdHWsP4S7byUWWph3KcVYjGpvYrJ05vkZVJzCu53G/bfEmfzkIET?=
 =?us-ascii?Q?YatmgCVirA+LKLST5xwVsXj+lKJlRa5M62Lh2Fb914GWy891BcvIVKBJtEOR?=
 =?us-ascii?Q?pLVxmjlWU/CxBCm2tfAijjixLv4jo/1c51TFKUhOyedEVmPSAhvcbi1an/sL?=
 =?us-ascii?Q?Rg=3D=3D?=
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d53271ff-1738-42f0-82b0-08dac8146082
X-MS-Exchange-CrossTenant-AuthSource: MN0PR19MB6407.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 20:51:47.2913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1dofWd8RCR95Wb5XWqOwN/QaXsaEJN35KDF9mPpJb39f4uuFrBvfIeKS3Xlt8FEQBdwKlB5SL0LgoLL4YS/QNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR19MB4332
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Legacy kernels prior to commit 4399c03c6780 ("x86/apic: Remove
verify_local_APIC()") write the APIC ID of the boot CPU twice to verify
a functioning local APIC.  This results in APIC acceleration inhibited
on these kernels for reason APICV_INHIBIT_REASON_APIC_ID_MODIFIED.

Allow the APICV_INHIBIT_REASON_APIC_ID_MODIFIED inhibit reason to be
cleared if/when all APICs in xAPIC mode set their APIC ID back to the
expected vcpu_id value.

Fold the functionality previously in kvm_lapic_xapic_id_updated() into
kvm_recalculate_apic_map(), as this allows us examine all APICs in one
pass.

Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
Signed-off-by: Greg Edwards <gedwards@ddn.com>
---
Changes from v1:
  * Fold kvm_lapic_xapic_id_updated() into kvm_recalculate_apic_map() and
    verify no APICs in xAPIC mode have a modified APIC ID before clearing
    APICV_INHIBIT_REASON_APIC_ID_MODIFIED.  [Sean]
  * Rebase on top of Sean's APIC fixes+cleanups series.  [Sean]
    https://lore.kernel.org/all/20221001005915.2041642-1-seanjc@google.com/

 arch/x86/kvm/lapic.c | 45 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9b3af49d2524..362472da6e7f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -236,6 +236,7 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 	u32 max_id = 255; /* enough space for any xAPIC ID */
+	bool xapic_id_modified = false;
 
 	/* Read kvm->arch.apic_map_dirty before kvm->arch.apic_map.  */
 	if (atomic_read_acquire(&kvm->arch.apic_map_dirty) == CLEAN)
@@ -285,6 +286,19 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		xapic_id = kvm_xapic_id(apic);
 		x2apic_id = kvm_x2apic_id(apic);
 
+		if (!apic_x2apic_mode(apic)) {
+			/*
+			 * Deliberately truncate the vCPU ID when detecting a
+			 * modified APIC ID to avoid false positives if the
+			 * vCPU ID, i.e. x2APIC ID, is a 32-bit value.  If the
+			 * wrap/truncation results in unwanted aliasing, APICv
+			 * will be inhibited as part of updating KVM's
+			 * optimized APIC maps.
+			 */
+			if (xapic_id != (u8)x2apic_id)
+				xapic_id_modified = true;
+		}
+
 		/*
 		 * Apply KVM's hotplug hack if userspace has enable 32-bit APIC
 		 * IDs.  Allow sending events to vCPUs by their x2APIC ID even
@@ -396,6 +410,11 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	else
 		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
 
+	if (xapic_id_modified)
+		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
+	else
+		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
+
 	old = rcu_dereference_protected(kvm->arch.apic_map,
 			lockdep_is_held(&kvm->arch.apic_map_lock));
 	rcu_assign_pointer(kvm->arch.apic_map, new);
@@ -2155,28 +2174,6 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
 	}
 }
 
-static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
-{
-	struct kvm *kvm = apic->vcpu->kvm;
-
-	if (!kvm_apic_hw_enabled(apic))
-		return;
-
-	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
-		return;
-
-	/*
-	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
-	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
-	 * value.  If the wrap/truncation results in unwatned aliasing, APICv
-	 * will be inhibited as part of updating KVM's optimized APIC maps.
-	 */
-	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
-		return;
-
-	kvm_set_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
-}
-
 static int get_lvt_index(u32 reg)
 {
 	if (reg == APIC_LVTCMCI)
@@ -2197,7 +2194,6 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_ID:		/* Local APIC ID */
 		if (!apic_x2apic_mode(apic)) {
 			kvm_apic_set_xapic_id(apic, val >> 24);
-			kvm_lapic_xapic_id_updated(apic);
 		} else {
 			ret = 1;
 		}
@@ -2919,9 +2915,6 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	}
 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
 
-	if (!apic_x2apic_mode(vcpu->arch.apic))
-		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
-
 	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	kvm_recalculate_apic_map(vcpu->kvm);
 	kvm_apic_set_version(vcpu);
-- 
2.38.1

