Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024C752F49F
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 22:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241610AbiETUoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 16:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238621AbiETUoP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 16:44:15 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75E6193233;
        Fri, 20 May 2022 13:44:12 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KDhIgq008987;
        Fri, 20 May 2022 13:43:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=Kx/PS7NPNfHFg9zGQ2Q1gDGHQAeuhrYYNL8XVRNyoV8=;
 b=IsHcmGMrDhMYYiOhHaaYSArpNX5JyeB+F4W7c+n8i5yU75ypovCuYe0ZwVmTa5K3dk2J
 M1d4tDJbKz3cjhiWHKPpoQC3Erkd+v6Z1iR3lVdWgU/aujvPFNAqNLL0oYTS0P9cxKhp
 eWFjzPzovsqhCuc78LH8X8l1oajKJUe2sCOX+ymZvRolkqwsJL9zXlOf8cSFCLNxiMGA
 nV+9orJ+iv/4G/TQ0l8yHkySVBPSdJp053CgKr1hdhTI1Lqo6e9eBtNMxEI+cUI8OO9d
 1IhDO4CWee/MXhb2jPRu4BFieo+Uhnw/u7LLyAAK6rMEUqEWaA88Qy9wq0LtT4cKvWo0 8w== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3g28ruxdp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 13:43:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQwX5z17OWkyC+lN4tNgtjwvm1AoXcdQ+czuz/n6PCUq4oIAYEAsTwezwFL6lwcIuPUa5FnnV2CKn66YHCsLPBJLvFxrJWLatBnuBKwOlmsqYFplOjI++0I97uGuV4l8GM2UMtMERUtZYnarqURZY481EezmYPCBw7skG7L9V3okbz2xcuuly3lhtmYmiIkAXA/V9AVFtsfppOyy9gLO/L26ftPysvAIsiQhnYIdyZ7MhUYBsVKiV+Y58Ap4Nkmo+j2B0qAQyOkV6jp3nwu2C3raOxZWE1hR4zpkgxVLHAsx72qM+9MdxToy3sgQM0KkU+dGTM1J7l/CxC6aaiXtMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kx/PS7NPNfHFg9zGQ2Q1gDGHQAeuhrYYNL8XVRNyoV8=;
 b=kKbE3/vQAVEI20NZjMz+UkD9Zm94JkmHzbx5r0/w/Uu9DeHAWMqtYGNZHamEAabx16+qUG7mzQRoDwuNhvEt4aqEBOtZQXqVJpEAf4kpcxeK/FJ47VgQhY0tgMA+wrCb0Ad5/tR+h+iS3600rCXWrR0KExCCUzp9X57/ZED12/ywv4WapBsaIJ+aMVdDJunPQPP5NEny7rzXTxD9Lf2vEbKCQbI7OjT/RZDHLaPWu+RijoywbR2vK7N1xT5bEjiRy91B04JIOtKusBqpbrtFkGoKI0srTtWUNbEUEtpiU8WbkP5Avrm/1c7F4tyNNw975s+HeUW1ARFguXq+YDBPHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by SA1PR02MB8350.namprd02.prod.outlook.com (2603:10b6:806:1e5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Fri, 20 May
 2022 20:43:18 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 20:43:18 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jon Kohler <jon@nutanix.com>
Subject: [PATCH v3] KVM: VMX: do not disable interception for MSR_IA32_SPEC_CTRL on eIBRS
Date:   Fri, 20 May 2022 16:41:15 -0400
Message-Id: <20220520204115.67580-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::11) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bc2e77d-1ee6-4f20-a146-08da3aa15edb
X-MS-TrafficTypeDiagnostic: SA1PR02MB8350:EE_
X-Microsoft-Antispam-PRVS: <SA1PR02MB8350E8808BC070AC949BB484AFD39@SA1PR02MB8350.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X6hdob1BmOGy7irRmwjh8biYESzy5IDjA42dDPOaMCZbvnhU/cMba0p7aazRJHaV0oINLxwKG0nWet8eX0PBwcdVJWsYULKvRYAuY/yZQUM4httrggYpahB7uw1fuaMA8cZ6LyM+mXLTHOzRGwg75ShYSoG2S8hH4lf4KvcuwNlFenUXcOAc5rVR1Ejx3XcwzkAx/awiBnYOFEuytsiu/yyAP1/M7qY4mCgcak7QCVHfVczes0Bp7V1e/G7mWqr8YvhqnjGJ18BhAn8btU5wMHNk43Fjew5YBBj8CT3DKWpyk5OQsXh0Z2cUOrs2YOEMpO13KfjSqfPDlig/mh+uBAAOSxVm9RtQ0EbhAOJrl8yxsKAkMXu7+4O5vbW2Q3gaRVQFxwslwHmfheWBmCXsthhJLxKRq34fRQlkJvDtX3jh0euazloauoV1K5uZK9M9V+m5QW2bMpLAIubEQPbtgVAkjYW67k8Kt1xW6QQsqGX119mF/2W0l4T2RjvW940Q2WGRdiC+WrVFxRybFJmbeK43WDUXEj2+3zp3uNiq4fUgSUiCKzkNoIoMiADnYfXF0P+ELXuwcjmzm73Kc5TJLIcg7mQoN4VLn4/wZHrWHragcy6p6Cxzp2PwjoF+ac41Q9soesGq8OaeTSbfCv7LBGDBUF4MIZ9odeSVcSEvHcn+3Y/ApVVFyHWY0kEPkVZAEisi9lELeq7/Alvm9muWtjepUmaYUidCMNvfVbfZMeOTai2Zkp5hLhwxsnEP//22hlKqC7nCsHbnyz7rI6LBoSZ92wK+7imV57jljtg7i/WAb2wW2+u4jQ+6iUBRR9ff
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66946007)(86362001)(66476007)(110136005)(52116002)(4326008)(8676002)(38100700002)(316002)(921005)(6512007)(6666004)(6506007)(6486002)(966005)(186003)(1076003)(107886003)(508600001)(36756003)(2616005)(2906002)(5660300002)(83380400001)(7416002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5I22inVWd8OAS8BQp/WWAQ4EzwXW6WtE/1MxiQ9YoYbZYbsKbDtnhXOGZJAd?=
 =?us-ascii?Q?3I8zQNnvGqaV0VEBLo195btgt0p0FZS7xiU/P+mks549jCZX+QLB93z9LpAH?=
 =?us-ascii?Q?MVGBeRSc/bhG3KCYBfikRoGDop6p2V0RikWlBIRCwtxidLsK75ogr9Buj8JM?=
 =?us-ascii?Q?hssj7mgNFJf7OVx3TXH+2UGVIKZgpUM7qZGeSBODxlm5+daFvF92l/5U4pGe?=
 =?us-ascii?Q?b2rYNnEheEyrDkoB6WvkTSV2JyYVPPKdmu3+x6Y9CzG2JPriRx/PbZJ0Qp9+?=
 =?us-ascii?Q?h7TpmwPql0M2E1jQ8eRRb8AiRuLINww0aPvvQFoIWn1jtTQGJZS7vN/XwhDO?=
 =?us-ascii?Q?R9TURPIsakJG461Wpx6ax3xlMUmq9DIkqVuVgHUVL2lcSmEeJQFMEmIkCmi0?=
 =?us-ascii?Q?fdLt6Lz2mHIdb3vaxAXJjSZu7Yfm/GpUnvJhyrUpm23oyXVSzGHzR1JBbiA8?=
 =?us-ascii?Q?W3N2A0VIKrxl8er2q4/RsxPQD0KzdYTsTf7r8hfa09o+okki/pXfLJWJk/yl?=
 =?us-ascii?Q?Clbxh9Gj7N7LR0/PMjAbMsiVQ8doYlVvDH7WQKJ2VYWSxTOSFj1Zc2IwgSQO?=
 =?us-ascii?Q?U3z1o8PY/w6d342lCuQE1GgH2Eo9LI/jMPCUoWf0c2GEOD4lWAkiZI4UNbgF?=
 =?us-ascii?Q?1ntfIYMmwKwQdej00M2VMkiRqOirgmxcy1fiAZuUMl61VhTQDlN0rSl8i4mc?=
 =?us-ascii?Q?SsR9jm4er1ZVB1oklblrMiaJPYhxw0McxONR57Lx4jVZWq1/J53xWBxU1Oyg?=
 =?us-ascii?Q?AdABscQ8MpHUJWrEL7c3C7J/ae0k80+yGdA03t/dAqt5IFEnAlXY49zpqVIU?=
 =?us-ascii?Q?X65liK36R/zIHRc4BuKzRgbntYISBkH6x63OTq8u4BDdKBUZBsg3hC/0j7Hg?=
 =?us-ascii?Q?rcvqDpeCsH4XhUy/XJIIHCwfXUR76Z7nbFG4+gzIDhdMw0Lo7Ee8UgyK7PPd?=
 =?us-ascii?Q?kaK76djzphDKVQJn8AMTksNqTrbjQeUQFMdNbrDEEYg9t/k2W95FwX2hB1xf?=
 =?us-ascii?Q?A6ClLtjm+fHR+82BJEAx27zl+g3/RVcciPFCdpwcB+k7/8QwX3KaCggJ2dKr?=
 =?us-ascii?Q?46Agbbb8v1d87s2XgpvoWbPFtL3RRdfYO/SVEOtM/kzGc85tSrKgwQ46iuox?=
 =?us-ascii?Q?/um8MRzCAbvkeOd7RdSA7fnPV3B1lg6VSIJ0T32nQ1HvegHbbYJpHOcHrJuj?=
 =?us-ascii?Q?4OCnEDIrXiSf9/1hX2dZgHtG535vBPfxo5m/rlGB9X/Zi1rTU2P7fUlw3buB?=
 =?us-ascii?Q?VmzkcNiWS4KNJv1nHS/n6Aw0Na62e0BI/rz0yv2TnJY7RFxshzw2Uv1Qerpm?=
 =?us-ascii?Q?zbObV3fnrPhwQojtnPQ4Nu2ZvDqpVa2A2yq36fwI/XabQXH9+vNwQ6DPKGKg?=
 =?us-ascii?Q?4sXwjyUwM446Rg0HIxtRM0dfJH4iuw7KracDp7SHyOz4/MdZiifGuOjCtKl9?=
 =?us-ascii?Q?nVm4+yGG/l4yVGpN4HrRhCrna46wZoLmPOYiIcYHc2FEkvxytLVNiluIXcFN?=
 =?us-ascii?Q?cWND0aRrtRrw7rkHbEHgnkM5i0ZI1Fq/e2Qn4368shjVGKb7vccaJcupk8rF?=
 =?us-ascii?Q?yPURvY+u4UDlkBoFssocTr53Q1ymjm46NcK5wkUdtIwSUEFjUe+sXU7TjZqA?=
 =?us-ascii?Q?iKr6izJPqZjc53Ftvn21HNsnWaTx7TlhRjTDQcnKgOlc2NJkckkjOFUffSdk?=
 =?us-ascii?Q?rx7ppF56bBfLRvIc0iLtXakifqEIiGhBmFdHhSxeEXHpzAVm7Hfh19APT7Mh?=
 =?us-ascii?Q?QFoSBaX+yZ5acUvb6KJoo1LGRFm8y7FIVzWsKmqeeFKFt2gUwWRa97CUzJxe?=
X-MS-Exchange-AntiSpam-MessageData-1: 7k6CUaw0vze9dT1FxljHaxHdNqgpxRlqQRtN9KXe93FJiQXltBIN4W27
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bc2e77d-1ee6-4f20-a146-08da3aa15edb
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 20:43:18.7881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYzQXUFzZt6afXF6DPXXAI3+N6h5pHWeGioJIve/PIu1f5j3YTY2zssFfZOmYhQH+bJ/+Jm1s0qdQ8c1a3Xe6lpdY3kuB9v059sbku/KYDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8350
X-Proofpoint-GUID: LiASeBWgwOntxPXwZz2PqjEX-BvIQGhf
X-Proofpoint-ORIG-GUID: LiASeBWgwOntxPXwZz2PqjEX-BvIQGhf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_07,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid expensive rdmsr on every VM Exit for MSR_IA32_SPEC_CTRL on
eIBRS enabled systems iff the guest only sets IA32_SPEC_CTRL[0] (IBRS)
and not [1] (STIBP) or [2] (SSBD) by not disabling interception in
the MSR bitmap. Note: this logic is only for eIBRS, as Intel's guidance
has long been that eIBRS only needs to be set once, so most guests with
eIBRS awareness should behave nicely. We would not want to accidentally
regress misbehaving guests on pre-eIBRS systems, who might be spamming
IBRS MSR without the hypervisor being able to see it today.

eIBRS enabled guests using just IBRS will only write SPEC_CTRL MSR
once or twice per vCPU on boot, so it is far better to take those
VM exits on boot than having to read and save this msr on every
single VM exit forever. This outcome was suggested on Andrea's commit
2f46993d83ff ("x86: change default to spec_store_bypass_disable=prctl spectre_v2_user=prctl")
however, since interception is still unilaterally disabled, the rdmsr
tax is still there even after that commit.

This is a significant win for eIBRS enabled systems as this rdmsr
accounts for roughly ~50% of time for vmx_vcpu_run() as observed
by perf top disassembly, and is in the critical path for all
VM-Exits, including fastpath exits.

Update relevant comments in vmx_vcpu_run() and opportunistically
update comments for both MSR_IA32_SPEC_CTRL and MSR_IA32_PRED_CMD to
make it clear how L1 vs L2 handling works.

Fixes: 2f46993d83ff ("x86: change default to spec_store_bypass_disable=prctl spectre_v2_user=prctl")
Signed-off-by: Jon Kohler <jon@nutanix.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Waiman Long <longman@redhat.com>
---
v1
 - https://lore.kernel.org/all/20220512174427.3608-1-jon@nutanix.com/
v1 -> v2:
 - https://lore.kernel.org/all/20220520195303.58692-1-jon@nutanix.com/
 - Addressed comments on approach from Sean.
v2 -> v3:
 - Addressed comments on approach from Sean.

 arch/x86/kvm/vmx/vmx.c | 62 ++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 610355b9ccce..1c725d17d984 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2057,20 +2057,32 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;

 		vmx->spec_ctrl = data;
-		if (!data)
+
+		/*
+		 * Disable interception on the first non-zero write, unless the
+		 * guest is hosted on an eIBRS system and setting only
+		 * SPEC_CTRL_IBRS, which is typically set once at boot and never
+		 * touched again.  All other bits are often set on a per-task
+		 * basis, i.e. may change frequently, so the benefit of avoiding
+		 * VM-exits during guest context switches outweighs the cost of
+		 * RDMSR on every VM-Exit to save the guest's value.
+		 */
+		if (!data ||
+			(data == SPEC_CTRL_IBRS &&
+			 (vcpu->arch.arch_capabilities & ARCH_CAP_IBRS_ALL)))
 			break;

 		/*
-		 * For non-nested:
-		 * When it's written (to non-zero) for the first time, pass
-		 * it through.
-		 *
-		 * For nested:
-		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_vmx_prepare_msr_bitmap. We should not touch the
-		 * vmcs02.msr_bitmap here since it gets completely overwritten
-		 * in the merging. We update the vmcs01 here for L1 as well
-		 * since it will end up touching the MSR anyway now.
+		 * Update vmcs01.msr_bitmap even if L2 is active, i.e. disable
+		 * interception for the vCPU on the first write regardless of
+		 * whether the WRMSR came from L1 or L2.  vmcs02's bitmap is a
+		 * combination of vmcs01 and vmcs12 bitmaps, and will be
+		 * recomputed by nested_vmx_prepare_msr_bitmap() on the next
+		 * nested VM-Enter.  Note, this does mean that future WRMSRs
+		 * from L2 will be intercepted until the next nested VM-Exit if
+		 * L2 was the first to write, but L1 exposing the MSR to L2
+		 * without first writing it is unlikely and not worth the
+		 * extra bit of complexity.
 		 */
 		vmx_disable_intercept_for_msr(vcpu,
 					      MSR_IA32_SPEC_CTRL,
@@ -2098,15 +2110,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);

 		/*
-		 * For non-nested:
-		 * When it's written (to non-zero) for the first time, pass
-		 * it through.
-		 *
-		 * For nested:
-		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_vmx_prepare_msr_bitmap. We should not touch the
-		 * vmcs02.msr_bitmap here since it gets completely overwritten
-		 * in the merging.
+		 * Disable interception on the first IBPB, odds are good IBPB
+		 * will be a frequent guest action.  See the comment for
+		 * MSR_IA32_SPEC_CTRL for details on the nested interaction.
 		 */
 		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W);
 		break;
@@ -6887,19 +6893,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx_vcpu_enter_exit(vcpu, vmx);

 	/*
-	 * We do not use IBRS in the kernel. If this vCPU has used the
-	 * SPEC_CTRL MSR it may have left it on; save the value and
-	 * turn it off. This is much more efficient than blindly adding
-	 * it to the atomic save/restore list. Especially as the former
-	 * (Saving guest MSRs on vmexit) doesn't even exist in KVM.
-	 *
-	 * For non-nested case:
-	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 *
-	 * For nested case:
-	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
+	 * Save SPEC_CTRL if it may have been written by the guest, the current
+	 * value in hardware is used by x86_spec_ctrl_restore_host() to avoid
+	 * WRMSR if the current value matches the host's desired value.
 	 */
 	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
 		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
--
2.30.1 (Apple Git-130)

