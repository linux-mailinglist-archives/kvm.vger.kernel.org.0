Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8831562E451
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 19:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239716AbiKQSeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 13:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240424AbiKQSdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 13:33:53 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2055.outbound.protection.outlook.com [40.107.100.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD288515A;
        Thu, 17 Nov 2022 10:33:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jN16b2yATdx3fXlUNTznFnQqqPwnAqo7QlN7gWIpKxuZFM7qWiMaO5aurJQ+FggQvM3FAmb1Ubg8uGisjMBghCGvoQtUSUZjIOdt4vIvN47TaEhRfpqLbTFHht0Kht+EcJk7aI0iImN8lFwTZNCxFas6QbuByq62vXkp0VapkCZvCXLL9De2rhN8LK8RjVZEF5xQLkWLCf6uQneV374tjioap1vgMhpfRpxRJ2Fuu7pkLfsM+ZgU/OyWh4IivKtabWCf6vxaLWpzDoI44loXzY87AUrLZpy/7xs2R4Ikn7qsNozqDGhC7HJn7rSJ6V/yK0zytK/ZwlxnUjqyhk9hqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MemQumk9zZ4qQFcBJ8FOwHf2bP/Vf41iY1o/AYqhW6k=;
 b=fuFnMeFab4tpQOuLt6bj7YdF5K5wLTyKQUCR5fpSqMHy/QVG9X/8DcVZQz7nWGzONumfjavgY8aNXoW+mdM3eovt0/gZ8YZ2jYEcWlQsVBTTQKkQSCd4MlTLY+NnrKORRaELbnjXM79IBDIkt7Sak2H3a478Wn8BdDn9JSd72x4t/Qmh4Qd9IVqgAaGDelTA2kzigj9R73ZMlDuGPWsIyk9v2g6Ifa0ASa/f97W3eYaVRX/OTJvksC1ffPs8Yi1GK2Hh0pweMnNHQCNLIojmVdARhN5DaIaSDm4//fHlvNSQH9k5SZnFatw5U11oHlxVJDceYw8ZjuJ4c7wIZocgnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MemQumk9zZ4qQFcBJ8FOwHf2bP/Vf41iY1o/AYqhW6k=;
 b=w7gvriWHHOqXMAc0YIKzDbU2hJivbgF62vJyWgEMewMZ6BCCB/bpVang2UqwQ1q2jVtFZijGJ2+crN+ZszaiBUBHi2UfBpH7u9C0/9GajWfdJDTlbhyLa3MnvavAI1CDN0GPy11+fzqXWRkBtP0cngcF8kDG/rU7YjWpfNwZgD0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from MN0PR19MB6407.namprd19.prod.outlook.com (2603:10b6:208:3c0::20)
 by CY5PR19MB6172.namprd19.prod.outlook.com (2603:10b6:930:2b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Thu, 17 Nov
 2022 18:33:12 +0000
Received: from MN0PR19MB6407.namprd19.prod.outlook.com
 ([fe80::db4d:6649:2aef:bae9]) by MN0PR19MB6407.namprd19.prod.outlook.com
 ([fe80::db4d:6649:2aef:bae9%5]) with mapi id 15.20.5813.017; Thu, 17 Nov 2022
 18:33:12 +0000
Date:   Thu, 17 Nov 2022 11:33:10 -0700
From:   Greg Edwards <gedwards@ddn.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Greg Edwards <gedwards@ddn.com>
Subject: [PATCH v3] KVM: x86: Allow APICv APIC ID inhibit to be cleared
Message-ID: <20221117183247.94314-1-gedwards@ddn.com>
References: <20221114202037.254176-1-gedwards@ddn.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114202037.254176-1-gedwards@ddn.com>
X-Mailer: git-send-email 2.38.1
X-ClientProxiedBy: CH0PR03CA0249.namprd03.prod.outlook.com
 (2603:10b6:610:e5::14) To MN0PR19MB6407.namprd19.prod.outlook.com
 (2603:10b6:208:3c0::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR19MB6407:EE_|CY5PR19MB6172:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cd21526-adc6-4752-63b7-08dac8ca2ef0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pkdW8hBRNUZyX5B9k0/s+ZXFCph9QZgVMCm1s3Vv1gVFwSTotk/I2BQzjIJTzz175k+oGD7jPwSB3IAJMMOhGSal4e/tWSkorvMMSSNc11XsuKAp11e+kGvUJ7gvoDa37xAHyVIb31ZBAO4LQdMCHF0nrelyNsyyG0OHYZ/dTd2WgrI+7pkG+vKi1i3NZAmhR0pF1IZfjxQrC6mFDbiJAxq0HGJavG1pqWVg/thwJj9UqDqftaR3USpVJSvehVj1W0M1q0SOgMgAuFsOacJdrcC4RtziWLvFIDKD24uXWCjliwpoP/fvdAg2LwR6xZ9ORYJIOwYhAkrB5LHXufe+98yUwWVzpMMnNQfcF1ijDj6pEhKGfEEM6YC7Sj1VmP/sslsOMVARxyrOvXbSlduxV1pqlGoFWvzcGQuZ8pyOu/mg/EL9uo0Gf+q5QLy6+EA6Fwp/+NBWWZIaqEHuYGMvNgELtKGvI1YenyMg+7O6fcl8Dyn5hgzKpcnSnXHkIv/MAp+37dAnQ9Jx5cFyulUoNOKbTU+wa0o8iImHFc4q0yZHN7gZ1XZjQ7KkkERzMo9gYSsDGJdeIuFKgdilTe2MXs0Tp5trwvc2TUXLX3j8x0mureMknYEKHJjYbXk/lHuotdwHVmyKNST3fmyIiTBO3MiODA9T+GX+gZzb0adXBAo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR19MB6407.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(39850400004)(366004)(376002)(451199015)(83380400001)(86362001)(38100700002)(478600001)(966005)(6486002)(6506007)(8676002)(4326008)(66556008)(66476007)(66946007)(6512007)(316002)(2616005)(54906003)(8936002)(41300700001)(1076003)(186003)(2906002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TrOg5oSkb1tggt29PTw28KQld8/rF41KIpOF60BksVrSM8CYq7x3u8dfBvEV?=
 =?us-ascii?Q?DgsCHKN+k9+YKpA10xYMb5Zmc0JP+ANtdVCGuNDjyOozCKqivClNA/oxIqZg?=
 =?us-ascii?Q?dU9Ou4b446NrC7BnSDumsVyJl20oBnRKMddaUToMwnt75xfppuNH7F14u5Fw?=
 =?us-ascii?Q?FuTdrpOoQNtjPMkjVwwpteUqR3UEvr+3cqZ+DSE699PGuAlSTAOmvQmS3uoN?=
 =?us-ascii?Q?KtN0eFG5yeVsdhE8AU/HQdHytYbD73QPQBO32322J93s4cM5zmDmltmcyQaz?=
 =?us-ascii?Q?GZQc7KzEj4nUXHfYmQynTrAPeVxgTntlugkhDjYD1vbWxs+oJataLhVuIjr5?=
 =?us-ascii?Q?jRpEW8X6HOoEiDkgoPi5uVXq/9tVyVk6OA0Pf+/TKW+o/zbffH1tFOQTCMIR?=
 =?us-ascii?Q?FRsrGadxv0WozdvXBH2L9S2yKeC2dBFtGaitlyt/LH56gpknOKaIEHW3IdCb?=
 =?us-ascii?Q?fTZEAGfOcqpfOP6TbYGvoE9723vOxoDWkAWmG5WkgaA4GvRF49cim5RWag8B?=
 =?us-ascii?Q?KmRXLP7s8r0U/IfyeWftzjVjedYm2s2bEkEeqxwNfwEZ94wzKH5Pv/Vw6uFq?=
 =?us-ascii?Q?8p9u9rMhR5JFWWIEshS0uLXqhvWgM89cEfLWi5TBklt/0lfMOV2EPvIrxnc7?=
 =?us-ascii?Q?1CV/LZ4kG7JAHIMbOCe1GMStrKfQVNZuYAj6ArMbRxBJ4VtgZEXa1ONN6y78?=
 =?us-ascii?Q?qHyyIo7Xm7NtzIXAnZp+GO3gnYBxJMrc+oZRcPPrRcIB99GyPyutnOVH6V1L?=
 =?us-ascii?Q?bjOKseKfpRqEdzaPrXE7odzmBGs10tZbtJV7nYDf3an4ZSGH36EkAkok7zEd?=
 =?us-ascii?Q?ZYrXwYJTBYMNZ5AENerIYummbbE7FFP2Wjh0ti7fs1twNEKqmeC603kiXKXL?=
 =?us-ascii?Q?XNXi2xB5G095CCRDi3QzQI8Ff4TYwFSGSDwvBfD/LSDFOyCMJfu9NRgWgqCB?=
 =?us-ascii?Q?QEzBe2U19vYG3DMHwLgoOOjC1mcfTzd38UZqFpQ6zhJ5isQSMJQGF+76S6VX?=
 =?us-ascii?Q?WSIoTBHmXo1ouyV88dI+9ryLnTA8WwSh3lAus78F8kLzEcWWEc+j2yaBs+ag?=
 =?us-ascii?Q?9EINIVmk2xMWqJAgtFxShNp9gq6PatCd1ll0cFW2B95nQd886DWzF4vfpsju?=
 =?us-ascii?Q?87prvMCHSu9/FYfDEwZmsa0UDJJgENrvRPMpMxwO85svM14q2pnlQONtVkLz?=
 =?us-ascii?Q?73rc0SNH4j7qB8OB2qP6vipK6i7K3CuAeMbitxF4JadznDYi3QiSTtD6BLXW?=
 =?us-ascii?Q?joMiB/GJ6tHXhjjFBnfq8WyBmiGpFxVJ9n6/ay68fWT9X4Zh/9jMZN2VBjgx?=
 =?us-ascii?Q?AS2+VuGmJE26AsGCuWM+I2NQ8NV+wBAjZUWZL5nFmWkDgSHX7RFQs5uVIlGS?=
 =?us-ascii?Q?7u6qfhRjSpWaH6xmk1l79SSMSQl5wYckj1kTyqnFzXSHDBoD0Tq8S2zTgdyP?=
 =?us-ascii?Q?syZo0iY+Ll1DHjqGsXpm1UTCQXR38vmunlp3jJicDsXFG7S2/j35LYKrft3i?=
 =?us-ascii?Q?ZZHkRgKlRVRFVlcPew8olaLxhPtr6OtF3IOq4bQfLwSSWp8qJjE1QFYOo2Pb?=
 =?us-ascii?Q?mU9PTSG5yPvZd6GhmB+3q7SEicSQKEML9oYOrwL4RPrE9Eawfzoum/3vaQ9R?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd21526-adc6-4752-63b7-08dac8ca2ef0
X-MS-Exchange-CrossTenant-AuthSource: MN0PR19MB6407.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 18:33:12.5301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HVm9ShSclAcKBalQ6yEI17ys23jYrQ5KYZXdcXD0jwVmJiVXGOPZJPYSfVznMr1f8v7oDxs2z5Z3rprBh+exOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR19MB6172
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
kvm_recalculate_apic_map(), as this allows examining all APICs in one
pass.

Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
Signed-off-by: Greg Edwards <gedwards@ddn.com>
---
Changes from v2:
  * Comment and variable name tweaks.  [Sean]

Changes from v1:
  * Fold kvm_lapic_xapic_id_updated() into kvm_recalculate_apic_map() and
    verify no APICs in xAPIC mode have a modified APIC ID before clearing
    APICV_INHIBIT_REASON_APIC_ID_MODIFIED.  [Sean]
  * Rebase on top of Sean's APIC fixes+cleanups series.  [Sean]
    https://lore.kernel.org/all/20221001005915.2041642-1-seanjc@google.com/

 arch/x86/kvm/lapic.c | 41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9b3af49d2524..5224d73cd84a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -236,6 +236,7 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 	u32 max_id = 255; /* enough space for any xAPIC ID */
+	bool xapic_id_mismatch = false;
 
 	/* Read kvm->arch.apic_map_dirty before kvm->arch.apic_map.  */
 	if (atomic_read_acquire(&kvm->arch.apic_map_dirty) == CLEAN)
@@ -285,6 +286,15 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		xapic_id = kvm_xapic_id(apic);
 		x2apic_id = kvm_x2apic_id(apic);
 
+		/*
+		 * Deliberately truncate the vCPU ID when detecting a mismatched
+		 * APIC ID to avoid false positives if the vCPU ID, i.e. x2APIC
+		 * ID, is a 32-bit value.  Any unwanted aliasing due to
+		 * truncation results will be detected below.
+		 */
+		if (!apic_x2apic_mode(apic) && xapic_id != (u8)vcpu->vcpu_id)
+			xapic_id_mismatch = true;
+
 		/*
 		 * Apply KVM's hotplug hack if userspace has enable 32-bit APIC
 		 * IDs.  Allow sending events to vCPUs by their x2APIC ID even
@@ -396,6 +406,11 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	else
 		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
 
+	if (xapic_id_mismatch)
+		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
+	else
+		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
+
 	old = rcu_dereference_protected(kvm->arch.apic_map,
 			lockdep_is_held(&kvm->arch.apic_map_lock));
 	rcu_assign_pointer(kvm->arch.apic_map, new);
@@ -2155,28 +2170,6 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
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
@@ -2197,7 +2190,6 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_ID:		/* Local APIC ID */
 		if (!apic_x2apic_mode(apic)) {
 			kvm_apic_set_xapic_id(apic, val >> 24);
-			kvm_lapic_xapic_id_updated(apic);
 		} else {
 			ret = 1;
 		}
@@ -2919,9 +2911,6 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
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

