Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253B9525400
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 19:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357237AbiELRqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 13:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357230AbiELRqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 13:46:12 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1350D18352;
        Thu, 12 May 2022 10:46:07 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CFW1Zd004684;
        Thu, 12 May 2022 10:45:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=LiCQupQbuUHNbYzvtjuqJRuy+JCJr6sGRK4sejsc+uA=;
 b=gVIam8haGVaL3t2ZeNYn23+RMGfrWDca+Ui4MJ1X+a1FhIvli1vl2kxVVyOzJo+rZoZJ
 8hcx+iF7NekvGtIkAegtySQHKxAiQbS1dFcxVs4Q2vxQHvvHzAODEdXp/XYF3ojqcf9o
 WqArWVzsP0EGbdQ9VRGG7ef/Qr3w3X+6Z5uqYVhf/9+kaA1x90FATYlgjVljV0h2Mm0p
 iniqSyFctsawWduy2ke8oVU/S4LoywIJEQp45IK2ktfSlUKH3uW6znWSC1xjuG4sLuTd
 9OsyYOcmTR0yo8f6gU02pmJ8X25XYj7/3Obg3XbsnOzbEEFREqX0c+xxE94xw/2AhnFL Yg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fwmp8bm4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 10:45:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOrmUFfpWdIZQyG2LhG+Fr0mq1mgAC9mUlVtXDe3KqwPS0ttMqPXZgqxCdjvcaN6MnIZH3pxtazMd+JhchO0SVyaFQwDzT3YUyxZJntHyOuqZNJ6iClWTeY53TPHI5AAx8T/CQRrU1GW1Si/5xV0WuCr558lpHK8wyUjbs0Lc+5tAuHxXuRubuTgHg68N+IhsqoM54TyFsma3TWinEYva5/KdUIdfXYKL7nm3U89RBh3ndttSG1Xy3M8CVR6XCI78HglMtfIGh7Jmo4ToFsd1adm/8khYzPeggWUMcrSt4Ui9os0PC6UuLl98gDyNnStpUghNpJMCSynrc3aRRhuIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LiCQupQbuUHNbYzvtjuqJRuy+JCJr6sGRK4sejsc+uA=;
 b=XJQTlPxx5OsKmjSwMCuXrEHK4G1EvI1TFdpXvSrks1OnjSSV96BacSy0qSZQ89Px44yClhe7YzfU3A+VK0lNPZuER1CSHCs0Zt1hz5WEMHTCvR/ZsHnfw7LIGaecFG+YspemQlJGL7AzSwzSdABjLGnf+E2h84CwhTMaJWJP96UVaHMPym/LP0D2aeBNjBxrNXYLuIPoVGyGmu2/OmoQvJtx5QlSRKvFCgaIs9xmnEmFpAmXdbDffEKzf7A+Lv1K+jmqffHFSke1JEolv4j5jVJxeisVBPGNBPFC1+hZxBrK3bAd9ZeTx9VRQAPpBuAnOFOwJFRnl6auS6c6cV5H7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by DM6PR02MB6559.namprd02.prod.outlook.com (2603:10b6:5:1bc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Thu, 12 May
 2022 17:45:05 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 17:45:05 +0000
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
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jon Kohler <jon@nutanix.com>
Subject: [PATCH] KVM: VMX: do not disable interception for MSR_IA32_SPEC_CTRL on eIBRS
Date:   Thu, 12 May 2022 13:44:27 -0400
Message-Id: <20220512174427.3608-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::31) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95794bad-5c81-4302-ba49-08da343f25d0
X-MS-TrafficTypeDiagnostic: DM6PR02MB6559:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB6559EB5FCF16AED2C39E105FAFCB9@DM6PR02MB6559.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mnD5/MCw2YxKjjQtIw053WuR/QCuJLBfFtstp0yrLYPirfJDDfiFmQFziH5kwj7y/8vewAtwl63TP7LZ4zQpOqO882sEEdgIPQN33Z2SoYwTCURT37/q8+I+hXjLmmE20dnSaYMzmWZmUigsaMkGsdOsx+AuAo9jv9Ew41LoX+dJiX0VnAGxBVLtmJtPmaEDEyP/I+fa3JLd7UAtif2mDv9yQ3g9kPHpceySfHyHEzQ6jVDU5eZrnZ5gF13BrrIibeR1jYQM2cjU9j/pi1/srrn9UJglAiLk9hOGRgkO9HZO1fUH8SyLIDw+MOb7RqChv9DIl9EYLkv7g2lfcwSpeVAKkJd8UY1HkZ137zzxyAdIDlvoOeZ35inQIl398w/2kVPxg+nYIfIzC4zhI3yGdSohPAgCY6UZb842gPepPdztUVvJ4cjZEKS3V3XzTXvBctn57IzCnzX+TF2Ylr+40HfIjJreapKbJJ4oiJnwtahlpjIQqjPGASS1bfs45v61xIdLSKmx8C/K6AIwV2DL0wo+SLFKRXTBnj83z1wJYlzMEMQSZ+fnW0jYIABM+TRt1RbTRwafOxm8vgkeFJgvBi3r1nM0dTTEQzIkrhbQ5ud3ztnx+ujswPcm9+DEW42NjRq9nLOyhl/jXGuRi+8ivOhDNojKZXO0+VcKNwRIxrnUnwAkqi4QYcT+Qp9mQs9/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(2906002)(316002)(186003)(36756003)(8676002)(52116002)(83380400001)(921005)(66946007)(4326008)(107886003)(1076003)(6486002)(38100700002)(66476007)(66556008)(110136005)(86362001)(508600001)(7416002)(5660300002)(6506007)(6666004)(8936002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H1vsMrM8Z1Do+oUEYx3N0cgCASK+borf8iTOvBSEDeJCIEG55FOqxcIiL9nG?=
 =?us-ascii?Q?F+sHJdXeChggEaL4xA8NEMRtYZIuUR8y/XbDaSuvq/u99R31ZRegALG51ER5?=
 =?us-ascii?Q?qiiIiL5Q26/GtPnp1ENl0wIY3lMxigRj/EnOXn/j46RcKPqYRXp0G5wE1w5G?=
 =?us-ascii?Q?NXB+mFcs36EwSBgsHEcub9p/b6OYEQjUEBXh0mzSoHPVUCX5bvIfhc4Zr4wN?=
 =?us-ascii?Q?fJIG9Z6+YPmG2ifASFSEo3rQhi3zcZKhb5goDNwEJ8dT6lP4j8VSfsmH0D9I?=
 =?us-ascii?Q?1NFlOaLNuFIrKUwVJlM0BYFYFSCgIhlqSz51jpZV7zIlZuP1k1vrG6R8NbgO?=
 =?us-ascii?Q?9miD3KzIee+5NIMmB+Azg6nudqX+vzhLw2OynJJiS93BP5h62vzJUHHMJoFA?=
 =?us-ascii?Q?LHKwgDcW7hUx/Ah1fPGH+gSofvsZqINwNLgUmPKc7dXO+WdhLCnhnGKqp/3l?=
 =?us-ascii?Q?rL+2fuQDvxaL8W5NPbBLhh89mRbCAD1S5IhrfaNpIuER7X4uU2CtCSHiF3bU?=
 =?us-ascii?Q?A0MJbcoxN3Wpo1yiM1CTrEimZn65UZ6i3OYxZjBCZZwWsJbOGiGrvFw5luG9?=
 =?us-ascii?Q?1NhctRhq6PcoPQKKzSX+GXMapkgUFweck1dQTfVIHVjsPOgxbjidqiwgdNyi?=
 =?us-ascii?Q?nsKXqLSrSjos34uVJYpaWMhir/pQe0R1dB1TcUZoax/0rdtpJhO+bzgEhbN8?=
 =?us-ascii?Q?AvFTN6ueQyGuPIzrIsA5TCkgCcb/su/mczJF1XgfO4IpIhpJiQO8cD/FPVv/?=
 =?us-ascii?Q?KV4RXgGODDHqlnGKhqE/O+LvZW3JJjLFEGzhYv5q2lDsySz0Cmf5xA7Aigod?=
 =?us-ascii?Q?p5Wwb1ow/EmQqHolm0P4wt2/3O6UgjvfAciq8R/W9P3vgy/XUjTGBC1F7WDY?=
 =?us-ascii?Q?NucnjhBHE8RI5t5z7kC+B0STuzbO+dO2oLjxQ1u9/SUFDLvS2rGKCf8K8mlR?=
 =?us-ascii?Q?nAgc83ctogEf0K+ZvTXIT0gjwXolFtYwHSqq0piFr8LJ90nbnbY4eNDSJsP0?=
 =?us-ascii?Q?w3DthlNeRGnKZki4zECXONC/Px3ngCqrk+gGXDE7m2qghf71jZEL/NmDbCPo?=
 =?us-ascii?Q?qzPtoyQW4MQjuFj86V9eGBVUp8HP/tct4or8MtVsfcaPQ9yIRLrheOomkenT?=
 =?us-ascii?Q?qsov5cQav7ggBKaXgyFY0A0UXGtAKncgtKvQhGldgH1vroe2GvM/rWSsWjbi?=
 =?us-ascii?Q?zgghB/vou6ulvLEfCnqznzwDHMRhuKw+wIChIsMY53ZdA+4N1hZ13QVNqs+s?=
 =?us-ascii?Q?Y4YlOHcuNz3X7SB7t+eUQOwfftmXa8uq8H93hTFhxTsx3Q7YG2CeV5RUbY/M?=
 =?us-ascii?Q?k37hHGfZVTSSlHavNhaYR69uXvPMJwDs2daiNwO1bC3wSTjzWDQdQuev1g9v?=
 =?us-ascii?Q?8FOSaZra3WuKkCm53CuRbqBEccQ1YtbSxWDDPcqicINwgwBWtWpeUk7xep9J?=
 =?us-ascii?Q?Igzm7eNpw6VR/9uds/UYqt+ch0YxbFy5c6tGL98yhAP/cCEl5YXvFyWzBpJw?=
 =?us-ascii?Q?Ps9XI6R2hRk9p+SjTJXGsfXu5F5yQraUXHksfpMD8zWVK6+dZekocv3Z/hXT?=
 =?us-ascii?Q?GVag5kUE+HzuTTxUWC5+FcB1mqQzwQ14OvKMRN79Ite/lxk79Gw1jY4TWcLw?=
 =?us-ascii?Q?HjkmrSDHQlDKgKG/0/gpPL3LREfFlabHwMpufFX4/uHH1m38A0aQ3N9stJ8O?=
 =?us-ascii?Q?waNCTMXVo9OSIvVx32YMVL3Gq+hMSJgOTjjN9k43qgnuyKb0bpGO694YJzGn?=
 =?us-ascii?Q?0vDOgoez2hSRDAF3cRnkdKRmgWVRCv3yh+msQRfvBvx0uqxBxL5Q524yUGxY?=
X-MS-Exchange-AntiSpam-MessageData-1: 4Ssf0nrY8LvYiX7FvhJUEjUeo9c4E0h2voo=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95794bad-5c81-4302-ba49-08da343f25d0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 17:45:05.2272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZwnQlWRkUahum9D9lsuDy8Jxm1l3PG9g8mRtAId27D/lZAiLkwj06Gmw6Yd3ADVH97QBxUBqfMG6WTADFU6RViP+gHceuPjdBMk38SPEP0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6559
X-Proofpoint-GUID: 3uqTGsPGcjSJEUJj3IusDPfgg2ZSW-Dd
X-Proofpoint-ORIG-GUID: 3uqTGsPGcjSJEUJj3IusDPfgg2ZSW-Dd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_14,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
the MSR bitmap.

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

Update relevant comments in vmx_vcpu_run() with appropriate SDM
references for future onlookers.

Fixes: 2f46993d83ff ("x86: change default to spec_store_bypass_disable=prctl spectre_v2_user=prctl")
Signed-off-by: Jon Kohler <jon@nutanix.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Waiman Long <longman@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 46 +++++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d58b763df855..d9da6fcecd8c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2056,6 +2056,25 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (kvm_spec_ctrl_test_value(data))
 			return 1;

+		/*
+		 * For Intel eIBRS, IBRS (SPEC_CTRL_IBRS aka 0x00000048 BIT(0))
+		 * only needs to be set once and can be left on forever without
+		 * needing to be constantly toggled. If the guest attempts to
+		 * write that value, let's not disable interception. Guests
+		 * with eIBRS awareness should only be writing SPEC_CTRL_IBRS
+		 * once per vCPU per boot.
+		 *
+		 * The guest can still use other SPEC_CTRL features on top of
+		 * eIBRS such as SSBD, and we should disable interception for
+		 * those situations to avoid a multitude of VM-Exits's;
+		 * however, we will need to check SPEC_CTRL on each exit to
+		 * make sure we restore the host value properly.
+		 */
+		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) && data == BIT(0)) {
+			vmx->spec_ctrl = data;
+			break;
+		}
+
 		vmx->spec_ctrl = data;
 		if (!data)
 			break;
@@ -6887,19 +6906,22 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
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
+	 * SDM 25.1.3 - handle conditional exit for MSR_IA32_SPEC_CTRL.
+	 * To prevent constant VM exits for SPEC_CTRL, kernel may
+	 * disable interception in the MSR bitmap for SPEC_CTRL MSR,
+	 * such that the guest can read and write to that MSR without
+	 * trapping to KVM; however, the guest may set a different
+	 * value than the host. For exit handling, do rdmsr below if
+	 * interception is disabled, such that we can save the guest
+	 * value for restore on VM entry, as it does not get saved
+	 * automatically per SDM 27.3.1.
 	 *
-	 * For nested case:
-	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
+	 * This behavior is optimized on eIBRS enabled systems, such
+	 * that the kernel only disables interception for MSR_IA32_SPEC_CTRL
+	 * when guests choose to use additional SPEC_CTRL features
+	 * above and beyond IBRS, such as STIBP or SSBD. This
+	 * optimization allows the kernel to avoid doing the expensive
+	 * rdmsr below.
 	 */
 	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
 		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
--
2.30.1 (Apple Git-130)

