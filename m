Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CAB4350E7
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhJTRIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:08:04 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:56586 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230335AbhJTRIB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 13:08:01 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KGAxU9000812;
        Wed, 20 Oct 2021 17:05:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=pMXeCGjgHvfb3F5HVnTVAPhex1Y3C2nV445iWS4EZX0=;
 b=IhN+VJKfbmRw9gZ0vplPa0eR9qwNq9hIdHC4GL2hdqBB64k7Upg47tQtUan1bSX/m0dt
 Oug3IQ7Pwv5e1XTFNMLVNm945ZP6Ada5IHDDNCRi5uqeACg/MTa2x+OonVrzidb19RD1
 YjHrGVhl+GhZ7OBRuVURxuBJWyLffUL2UjO7g9AgpNeks+26PKbZeSvBJUriuEne8oYL
 ZVtBw+mU5cE+LtGwuk2pygR5jRf20MMZcWqpBt6mv+/Tg7cjh5D+rW8Ota2RPE6L5Acv
 wUNTPiYNFcikFKBWSLL5+l8dhB6kFX6HpEdCZZsxzCES4xtCmdQdRMywnRjCNiQzXOHK VA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkw4scdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KH5ZCR005957;
        Wed, 20 Oct 2021 17:05:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3bqkv0cqwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUNZSzKuUcB6Xsna82K5ZH0Or7ZtxpHbACgh+s1sKjp80v7MKmZEbNwXg0G0RA6+Z1HL+pdtReTt2/03ObpQNfjmIRwoGrLvla+2QLdGAdtSoqzuuiOKX1LHrnYvsYCxOWKrEq3znnJwQcFz0X8yEpEOq9XDHfYgqbbzjjdiE8H1veRcuC0pzuuf3zuee7M1DQIq326/WdE9sWHQYmo++W58c247bc0ddvMgJAp11+HHOUgE2xuPCmpRWKEK2sMJm4hZHbDrMDA1XPgLtwmSkqeOa2P1UFHovFP36LGoRLQdjBeNyiMzsv2e/mrTmzyKWKXTlBECA89LRh3STWisoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pMXeCGjgHvfb3F5HVnTVAPhex1Y3C2nV445iWS4EZX0=;
 b=eezn6MDlnE89Z3brdtVUrD+0ab8By3Ghf8l/7FOjJ0widiuv5CtgCG8jbrH/pzlpTIST4gVqg5XRxh3bratHBsLPwuBhrHKk/qPJcAaURZmtd1REs9FWBny5+ltMPYpRLdNobkF3z7mu4EIUNxOcMWS/PsNy27uxY/klvGQd/kpCs6JNMngt6wt+HXWYZob4sNbWP++kGujjRlBdipKfDwshyzhdzJcVBfjBo9lHtSk5RREhjEAmqNcXIEiA1LCNlPBwXI8tpkrk4EcAHTmj4tWsEiGEL8KdfxQjU1gyarTO3jUdtuvZlZqoiCTzuZWumM7LHQorXBFmPZpKYyJPZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMXeCGjgHvfb3F5HVnTVAPhex1Y3C2nV445iWS4EZX0=;
 b=PWBoGDi3JprvOikrq9qdd4ojQVLlrm/eowHW92oDlDwXnERPbiDhvncdvLT3ISRYzOrSAaVEM/C33lrP6fmNiBV+jGhnZLaKwqr44kBj66G/vFAspKQhBSxkjfvpWulX9lE7ECQeDaBednFbRW/HWl0aoanzpQ796kFTSpndtFs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CO1PR10MB4577.namprd10.prod.outlook.com (2603:10b6:303:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:05:27 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d%4]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 17:05:27 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH v2 05/14] x86/cpuid: add X86_FEATURE_MOVNT_SLOW
Date:   Wed, 20 Oct 2021 10:02:56 -0700
Message-Id: <20211020170305.376118-6-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211020170305.376118-1-ankur.a.arora@oracle.com>
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0040.namprd04.prod.outlook.com
 (2603:10b6:303:6a::15) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
Received: from localhost (148.87.23.11) by MW4PR04CA0040.namprd04.prod.outlook.com (2603:10b6:303:6a::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Wed, 20 Oct 2021 17:05:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfa51988-de29-4053-4799-08d993ebd019
X-MS-TrafficTypeDiagnostic: CO1PR10MB4577:
X-Microsoft-Antispam-PRVS: <CO1PR10MB45774432623CEFF02E56A725CEBE9@CO1PR10MB4577.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8ne4ok1/pE+LQ8+gtf0WOfTIO+gsxtpUDkXstFpQFSwxpLWwyKaQdUJGi1AI?=
 =?us-ascii?Q?RCgG0Jtxl/TxOKD4jpwVVnKfOv2RuaTb81VSO0xPJo46USS1XKDweLzEoD8Y?=
 =?us-ascii?Q?68SxLEqih8ZZ9t2XVuJbilbonBGaLKHkEhA/ud9vb1hr9irdQHsT1L6LLGoo?=
 =?us-ascii?Q?nLcndLFS04KV93cl5IzPvey4uGsWb/DVk0Uol3IreIq5PvrwJk+vBebjnjtw?=
 =?us-ascii?Q?lG29ewnumtVteMjfbP6L8l7IrFUa1xpfkVFoFlreLSOZXF75MoKgvoU2Ee6r?=
 =?us-ascii?Q?ZR3a+LeatTdehkW7DfNTMlhumavsw91cFdqPrWJ0/o5RZo+ZYEd22akgYhgr?=
 =?us-ascii?Q?EYAuIpowPIV/xg6Tlfczb4mziggRd+xaQjJKh5rH6CKNjdiyiBIACOzjB0lM?=
 =?us-ascii?Q?vk8sPCDc/ux6oBbEWCxWLDiCLPzhqjKbbHwpmF+WlWmqBpfm0w2+zwDJmj9p?=
 =?us-ascii?Q?g5/tNYwnUhMsB+Ea3GJHGPZRLi8ri/WkI9Y8+nU8f/Kzpx5OI0C+WsWOLE3N?=
 =?us-ascii?Q?qx8CT8vLtXegBmGZx+OWqnjjXTCw+Jq5QoPSr+XFconI/ry8EVUu2Aq2WmEI?=
 =?us-ascii?Q?BELfH3oCaH56JCyvRNG7sWmmc53I2pXzFaR+NVkchetaYb9NUzWaXfhD3jeo?=
 =?us-ascii?Q?wago4TulAIUYBYuuBJtVhuMeJigtmMI0ikyV97zky5QamYdVVidmKyMVieZE?=
 =?us-ascii?Q?JQWZxdc5IACDMKwg8EyBbr9sMnxZYACBxaAoprmH2ngdE/WU6V50kJs29rR3?=
 =?us-ascii?Q?x/weAi6o0OH1lqkmFizcRmoQNqSCuBiLsRRcmy7qbWslHQSHw2s7XCQ7YgGJ?=
 =?us-ascii?Q?VdCqksCpko+MK9UKZM7IyQbJynpuEADOt8KE4zJYJKmXfh7xtKlqzUbTK+he?=
 =?us-ascii?Q?jjJj4HyjhrcQ8p4NnKV3JGXu+m5sVoQxWr1XzgXWgDTSoP/uHF8mHiMJtzaQ?=
 =?us-ascii?Q?U4nHIXdIWqxaUiycRnaNMqz9cRR+dOchJGMG2GmWxdsjH/N4JJnbTLAYwtLY?=
 =?us-ascii?Q?W/GIV5OBOZUEPBEr+rB5kGxMSeNFEI/bQpdEdKaK8ZjhvZ8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(66946007)(66476007)(956004)(66556008)(8936002)(36756003)(6486002)(5660300002)(83380400001)(2616005)(4326008)(2906002)(107886003)(186003)(1076003)(26005)(6666004)(38350700002)(8676002)(38100700002)(508600001)(6496006)(316002)(52116002)(86362001)(103116003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qywhtWxTqBggR6jadk+/hncKRxLkFYiaQH4imAE8Tr7bagDR6gqOhj/SrgyR?=
 =?us-ascii?Q?TgzcyFv+1Z8Rh80iJ+wxZ8ImNsTWo0+I/OFQGOd9iUxDNUjPc3ekTeyQ7OEs?=
 =?us-ascii?Q?JqFWAH/iZ3OIpSfdwiu4EAM1hGYCaamJxzE0Ytzq27y3DZUzUf8AyXqJZ+az?=
 =?us-ascii?Q?E4TYKWZaO4+EW49kdZpdABSAcEVFwbTsMJygDGPYg3WS2+1ChtUmj4EtbqMm?=
 =?us-ascii?Q?opbg3oLw3BJWg7BxizS6giSbjrjXxuWcWxieG7t9YCMxetxxFilAW+da7xlU?=
 =?us-ascii?Q?qxcdU1MYz9R+N3X4kETd2GtRyWlKcy7AD2pyehrCrnBWA9bics8P8uZbIiOo?=
 =?us-ascii?Q?J0LoupumXvdPkiZFz3oowHoFQaDDX4So4LGB5c/7BbergFA8b8NMn97ZPVZv?=
 =?us-ascii?Q?RVV1DS0610cNgSlcxI0oQIjtkHq/G1hjnrROvWFiCNTCSYa0+7cgKDuf5AOV?=
 =?us-ascii?Q?kNhkguIjRnsZ9Ri1cRCpep0eUmg9hgeV4+Axyc//X64NptSZShtI1lV5Sh3h?=
 =?us-ascii?Q?558kmlL9e1kQNdYMp4CufQjqoVSu043tGjWaYO+QLgZDjZaP69niMdz0+ML4?=
 =?us-ascii?Q?bPFl2T34fGSbHybjilLcqcIl29Q8fhiNbBuTnDGDAMC12qyQKc89W8sdkTWW?=
 =?us-ascii?Q?VWzdKkMx6m+j0RJ5VOIDYnqidWlkYgSuB7uWOvy0VE0NkIvz8MrmoTkQHiBD?=
 =?us-ascii?Q?1N2D/RdcLHI7zpokf4WfNg8JlW6dnnIurEsXEXkSeUnzkJifUtRs7O+AdGZU?=
 =?us-ascii?Q?BrXcCOmyrjPbzDbo6Fx86BrzSGuQ174kUWqPjXbNm5NgxuMy+IbfZQv/FW3n?=
 =?us-ascii?Q?Qqt0gHfyAkic7PCvdL6eLGE1HYbJd5TrwTkkh4NHMVbatWnLmcudJ6+Lb1EM?=
 =?us-ascii?Q?p4c25O7P60ov6mIWfh4UjMIbu7mLeGtLpOxGhq2AeGv8W3zZEjb+q2xkEeWE?=
 =?us-ascii?Q?lODlH/USWnVp5a2yPxCtMHHG+ATub8gKnLnUXb65oeIfG6L75Sxv8HueC0Ix?=
 =?us-ascii?Q?/n8R8Cq8HvfjcFchU5pAoZHclwqYTApjXm8jgLTnZFtyk6A40U1y8Uz44OC2?=
 =?us-ascii?Q?O0zpuN3Bb/+DJkhO/K69Fu++nua4nz02OPGK4Is7eYRbrbXFav4wXXuCsSzG?=
 =?us-ascii?Q?K1rn0HJPm2YNZvILpaKwO7CBZC5gnzXQG9Qgdqnw9+pb3B1g1tl0B9UcEXgN?=
 =?us-ascii?Q?SvV4I1jskyrmTFzpiJZlPwibDhyBoF413ujZvwO5I7EV0J/hHymHCzEEVgsk?=
 =?us-ascii?Q?+PavIYAQ0YRrCsKZm+dx+nNAnYjx1/xxXGQswBRfg7sfT3MxtZoYZQ2utryM?=
 =?us-ascii?Q?o+5B8gL2n35/zl0wiuqDmESvTbHGjKFRcES/YSVJVIQkbbGEXsXuR8YToHLT?=
 =?us-ascii?Q?iy/3zledIQreI4L+4AJ+CNiLLXXo11z86RK3LJOqKfsyxVAWh+JNvXyvmnvo?=
 =?us-ascii?Q?SYitjxU7AMWQgcrD6Tbklp7Hrg8+GsOi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfa51988-de29-4053-4799-08d993ebd019
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:05:27.0089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ankur.a.arora@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4577
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200096
X-Proofpoint-GUID: I1FTLLqN1gywCPHo1sRsT0WJjUjXaZo6
X-Proofpoint-ORIG-GUID: I1FTLLqN1gywCPHo1sRsT0WJjUjXaZo6
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enabled on microarchitectures where MOVNT is slower for
bulk page clearing than the standard cached clear_page()
idiom.

Also add check_movnt_quirks() where we would set this.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/amd.c          |  2 ++
 arch/x86/kernel/cpu/bugs.c         | 15 +++++++++++++++
 arch/x86/kernel/cpu/cpu.h          |  2 ++
 arch/x86/kernel/cpu/intel.c        |  1 +
 5 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index d0ce5cfd3ac1..69191f175c2c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -294,6 +294,7 @@
 #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
 #define X86_FEATURE_SGX1		(11*32+ 8) /* "" Basic SGX */
 #define X86_FEATURE_SGX2		(11*32+ 9) /* "" SGX Enclave Dynamic Memory Management (EDMM) */
+#define X86_FEATURE_MOVNT_SLOW		(11*32+10) /* MOVNT is slow. (see check_movnt_quirks()) */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 2131af9f2fa2..5de83c6fe526 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -915,6 +915,8 @@ static void init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 >= 0x10)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 
+	check_movnt_quirks(c);
+
 	/* get apicid instead of initial apic id from cpuid */
 	c->apicid = hard_smp_processor_id();
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index ecfca3bbcd96..4e1558d22a5f 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -84,6 +84,21 @@ EXPORT_SYMBOL_GPL(mds_idle_clear);
  */
 DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
+void check_movnt_quirks(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_64
+	/*
+	 * Check if MOVNT is slower than the model specific clear_page()
+	 * idiom (movq/rep-stosb/rep-stosq etc) for bulk page clearing.
+	 * (Bulk is defined here as LLC-sized or larger.)
+	 *
+	 * Condition this check on CONFIG_X86_64 so we don't have
+	 * to worry about any CONFIG_X86_32 families that don't
+	 * support SSE2/MOVNT.
+	 */
+#endif /* CONFIG_X86_64*/
+}
+
 void __init check_bugs(void)
 {
 	identify_boot_cpu();
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 95521302630d..72e3715d63ea 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -83,4 +83,6 @@ extern void update_srbds_msr(void);
 
 extern u64 x86_read_arch_cap_msr(void);
 
+void check_movnt_quirks(struct cpuinfo_x86 *c);
+
 #endif /* ARCH_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8321c43554a1..36a2f8e88b74 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -666,6 +666,7 @@ static void init_intel(struct cpuinfo_x86 *c)
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
 	if (c->x86 == 6)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+	check_movnt_quirks(c);
 #else
 	/*
 	 * Names for the Pentium II/Celeron processors
-- 
2.29.2

