Return-Path: <kvm+bounces-3999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A029280B9D1
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 09:16:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A84211F2108D
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 08:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C74587477;
	Sun, 10 Dec 2023 08:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="cUETqePm"
X-Original-To: kvm@vger.kernel.org
Received: from AUS01-SY4-obe.outbound.protection.outlook.com (mail-sy4aus01olkn2154.outbound.protection.outlook.com [40.92.62.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BB3CB;
	Sun, 10 Dec 2023 00:15:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APBNDeChfwMh/HYVKhasrfaaR3luvMG36xMw4L7TxhwDNxSZgS924tl0v6/QV1zpDVbEOKS+4ge23yAUqsM9lxCeWM6l5YWWA0Y9Ro270nC5P4zO8uhLpe1cWX0YD064ozQckE482iAzMf4lLg4zR+WLVWJC/0A3qUZDDZLwwF/Sn5YFb5X49ms0RXkqIrR4fs5B83riF5ywGAwizIHG4jkNgdlRfa2a3BbIL3iZz5Oj7eVeB9LeK9YJexVd5WVxouwtXydjb9HLOZ5+W/BGI5wDsWf5Ci24gXZC3JVaZJ/3GJUrSXgJe5c3HZA8LFUA471+QJJU0c8pGmnF2K6sEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1i26DJnKwIxg92MeUs8Z6WMsFGvM3406uFpBVomlXY=;
 b=F4cojM3r6QaxB8USzKJ3l24gKvOrzQW2t5FesoMShpETcsTnl0PQI0Um9cxZZTlR4WhK9y+OMrRVoy4TAj7WLYQpw509lkekKPW128lW+NJxHpMvSKp9U3XDQ07zT/7xOE51PT2vc0OOvjbRXFXyCqn2gf1wLdTumtE1Q8+ehqKL0jL2Rx/Uqh9oijfsc6LA2g72OUtntB3tcz4TSA5eLeHwS8ItGONzFMtEfU78HEngcSZ34qWo71MiVimBgdtpBkpDA22uTN+9U5Nt1JBfWStU2hVHQelrDeGexz4SJlZT12UWAQhZDmPzLQK4+HETrHPISctmdjieSV0JXK6knA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1i26DJnKwIxg92MeUs8Z6WMsFGvM3406uFpBVomlXY=;
 b=cUETqePmG755InfSZkpI8kyawLtZ00ft0n/rLwuSYpd9GOq2ur1ru5G18zQu7j26IN1NxEFeS3wTPAn4hpLKWepFlctqqVMOQQVteWjGkFWgyGW4QTUAJ9ed5fo0Cdfyg2aP3HDbodRwjj0YRBdpTNVVtNDtVdXZ5qxFlDoybvXWd4MJBsGTz4DtIlXgyXZC8r53grOk2D4o8Qcx1EetWxs90cNGO6WtaDQ9EYKscesvOiAZ/YZosyEQHJTr9CRzWN5KIZAFmkHPu0foU+k8eJ2JzJb1jucLSCfoLrEwK4dTTTTmnZei/fNFrhFSrBTPriuvIsZnA4Gak54i80hnBQ==
Received: from SYBPR01MB6870.ausprd01.prod.outlook.com (2603:10c6:10:13d::10)
 by MEYPR01MB7339.ausprd01.prod.outlook.com (2603:10c6:220:15f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.31; Sun, 10 Dec
 2023 08:15:42 +0000
Received: from SYBPR01MB6870.ausprd01.prod.outlook.com
 ([fe80::be5a:160f:5418:9deb]) by SYBPR01MB6870.ausprd01.prod.outlook.com
 ([fe80::be5a:160f:5418:9deb%5]) with mapi id 15.20.7068.030; Sun, 10 Dec 2023
 08:15:42 +0000
From: Tianyi Liu <i.pear@outlook.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	mark.rutland@arm.com,
	mlevitsk@redhat.com,
	maz@kernel.org,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	namhyung@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	Tianyi Liu <i.pear@outlook.com>
Subject: [PATCH v3 3/5] KVM: implement new perf callback interfaces
Date: Sun, 10 Dec 2023 16:15:24 +0800
Message-ID:
 <SYBPR01MB68709E1FE3A5056577AAA82F9D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <SYBPR01MB687069BFC9744585B4EEF8C49D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
References: <SYBPR01MB687069BFC9744585B4EEF8C49D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [v6yvaF+JLPh+PCgNnetddSJEklpOTVwqI2vcLPFcfPuR5Ao+D0+oBw==]
X-ClientProxiedBy: SG2PR06CA0207.apcprd06.prod.outlook.com
 (2603:1096:4:68::15) To SYBPR01MB6870.ausprd01.prod.outlook.com
 (2603:10c6:10:13d::10)
X-Microsoft-Original-Message-ID: <20231210081524.2358-1-i.pear@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB6870:EE_|MEYPR01MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: 959e30c7-68cf-46c7-ed7a-08dbf9583383
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DTWdeCFFWhDPIiCSiU2WhdHULaHA/1d9PaCApNoqxEqZiBgBKu5ooVtxpIxW4RpGaPr7PJ1nDB75vbH2y9QBwDEcHa2Up4VOGoAzIXCpNoh52L7385Fkvi/5KLcek1P328aSvBmwnv+dovEHSVOdyuf+MRHTpeqaHVBK/ZzYSyM59H5Ny5dAJL5HX9tUVqUofJGMYzaj6lD4vaecx8R9O4BG3y+FT0Uuo6uyPDHz3N2OdH4X94t4JwLRKCFtvCGT6VSP1rt7nzCjOVv6+c87+VUQAyoyk0KSWb+qwAHTgtIXyI3QM1fQplz8zr9/Wa2xNsI6TM8g62IWDrxYr9TSHOgUhdmP+KPXWq+eo5Q0jDHiKika9yxJC5LSJDZ8nOHNiFkrTmsHVZ8vOrqHFzypKemeiZQqD27ZvsLTAniCrO/h6zAHbpuKMR+4lUqWgoxUo5+CGpI/vPzV+BsXbfGNJJmTqilmOocu1sp1/sb/+t06ZFeDeC6WK3N+LxyC4IaOpWar+krvZEOMUbUCUwzjYHoR6QlLbnrC1JfTaGoa3Ml590bhrBfpV9DRB73yxWai1myPWshePip52SCPbdhtbO/SKAd5WnepLsdn1YgkZxNzRZomRyrHqAE10Gl/nVFN
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O+3hlnb0oA++e28XlMGGv/Ma7t9Hx7Ixj99e0izFdqv8qZHYSo/xmO7mJsqI?=
 =?us-ascii?Q?9M1XcrJzR43q5M0duQMIVjFLuqDgR+fo6JbZc9R5eFDEZwCn6+qkeOSb+mkG?=
 =?us-ascii?Q?tmPl1xkqHtJMhfxO5y/cg2CSOVbIRIYKIR6/E45vx+YM/l10NrVQvtIxFGGh?=
 =?us-ascii?Q?t0VnuwARQIWjSMRxl/swjHgXS0nHu8Oq7QhquQ3jtUXov9KkbnSHBkf5ZYQf?=
 =?us-ascii?Q?/OuDNRuMrmaOTd6yN6KXNFEVYk42Hm99/GsQxDBrnbw06uatX4j8EM3qmCiz?=
 =?us-ascii?Q?itO2yJ0B6s2+rv+dA5E25D80ML6Q8wkSppG2pPgF7jtW1JOqUqis7JlIYsAr?=
 =?us-ascii?Q?MgdFZ1GVMsAC1QNK/awRyyEAve/AILX2dBza090NN2AmgmTG9hUqZ3BnZFB5?=
 =?us-ascii?Q?8GrcfgNKsLBt7TNWhgzsStBAU7HkEMTcu9F2ex2zX0YuCzik8wkBBFoDUyLa?=
 =?us-ascii?Q?/Pk49KQw2k6Z0W0yf17L2vvjO4isB64V16FS0dh2VtVOLv2GJEDph/yJwNYK?=
 =?us-ascii?Q?nBlutsecTWgr5yKsoR7paHCAuxPu6iYbdQyM80wvDnKhr9Y9ModZ9hC/silu?=
 =?us-ascii?Q?Y/YzIssKtzoUd1pymsq2lGIaFmItrjQUFsobDXgLPJ9F6rvG8a+fq6x2DeBR?=
 =?us-ascii?Q?fAvZfl1axOjVeZ1zoVHhkPXWl2SaK6PbxltPORp8HiswfbgHvKYKODyfII9y?=
 =?us-ascii?Q?tb7LWoKLz0+oR8Hgtk53js/LIi6J4HKUBurpO+NHJ1IrMdQrJ8OXyD54Xx59?=
 =?us-ascii?Q?4xaTJw7Tfr+JPqpcZb+Auk8aE5Kcd8KO9U3WOYfCxZpPov1uqRS6PC2OLfPN?=
 =?us-ascii?Q?7hPUCIKWUrtGFQEcsxSfaD7XBUY9Kg930Ydtlarazi3bLzZXEyULNnbrxD5A?=
 =?us-ascii?Q?kLUTrQ42+qZU9du4BBPR2wyWGuMIDoFuQS8mcO9F+EzMFRF1VuaweCPd/txg?=
 =?us-ascii?Q?jMsqZ8IyDySK3mav40ToOCpFsJUvr8BObDMOsXJbvgquHR5szXwkW7KMgB0e?=
 =?us-ascii?Q?GLGCgGKG0LbdzL/29w7zpF2CfvT9kPiAcctF3mEyWTkKc/7gVvUry03PILZp?=
 =?us-ascii?Q?jBw/OfgY6SH/5OGVDgFkhxIOfFIfV2KLD7HLxzAuMBP6v4sbD3o8nLMBTn9o?=
 =?us-ascii?Q?VgNEndTEMGb0sFW0jgTO60PJ0oihAtUJUNQHzfmX2DJblXu/KsVruYedjgsy?=
 =?us-ascii?Q?ct/jajxwSjoi2ZD+PSCpG4mkrZu7zcmfe8eaAzZbGNluWKzsF219IFcfji8a?=
 =?us-ascii?Q?37OrIAjlO19Uvs2MWWPX?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 959e30c7-68cf-46c7-ed7a-08dbf9583383
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB6870.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2023 08:15:42.2392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MEYPR01MB7339

This patch provides two KVM implementations for the following two new perf
interfaces, just redirecting them to the arch-specific implementations:

- get_unwind_info
- read_virt

Signed-off-by: Tianyi Liu <i.pear@outlook.com>
---
 virt/kvm/kvm_main.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..c47b6c0f8e94 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6032,9 +6032,31 @@ static unsigned long kvm_guest_get_ip(void)
 	return kvm_arch_vcpu_get_ip(vcpu);
 }
 
+static bool kvm_guest_get_unwind_info(struct perf_kvm_guest_unwind_info *info)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (WARN_ON_ONCE(!kvm_arch_pmi_in_guest(vcpu)))
+		return false;
+
+	return kvm_arch_vcpu_get_unwind_info(vcpu, info);
+}
+
+static bool kvm_guest_read_virt(unsigned long addr, void *dest, unsigned int length)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (WARN_ON_ONCE(!kvm_arch_pmi_in_guest(vcpu)))
+		return false;
+
+	return kvm_arch_vcpu_read_virt(vcpu, addr, dest, length);
+}
+
 static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.state			= kvm_guest_state,
 	.get_ip			= kvm_guest_get_ip,
+	.get_unwind_info	= kvm_guest_get_unwind_info,
+	.read_virt		= kvm_guest_read_virt,
 	.handle_intel_pt_intr	= NULL,
 };
 
-- 
2.34.1


