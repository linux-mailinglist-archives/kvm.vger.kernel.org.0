Return-Path: <kvm+bounces-54314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92449B1E3C5
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 09:46:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E325189702A
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 07:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BBCA253939;
	Fri,  8 Aug 2025 07:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="p2bKavNs"
X-Original-To: kvm@vger.kernel.org
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013033.outbound.protection.outlook.com [40.107.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1668324679F;
	Fri,  8 Aug 2025 07:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754639148; cv=fail; b=qJRFFEpQsAH1yKYNJIjLaPiqniKH8/ZwgzSzd9lLc6t9c0lGaWmsCArGWgsJybUgjdGgfGxLQ+uC70TDJAd0JstG9601RuzGn2SqRz1pUqlnngKiSLCZTqaH8hyY4KFr//6Q0Svy4zkENnt3wTGzIgjPNkiq+B9ULzzxDzeHXe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754639148; c=relaxed/simple;
	bh=zmXJIJZLPIJkB3Qv+fnnp7ZQ4ZndEmnqw3E+n4vvIqA=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=SEKPsVsovJpTioHLHEALUmZqo4CqBCyVBHKDdtzWTOgpnCvilpmlw5Jnu/yBBriLje57p/nG+zYBfO0xymCVT7zpFbwwRhFFjobRT5m9yisxjEZxqwCSs8PaQdSO4QcRLnku5VL/p51Rw0qbjzN7DRQ/HI/Vph3hnRGPrbIkwEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=p2bKavNs; arc=fail smtp.client-ip=40.107.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tFz1/3BQmaAopUs8zqQ6YSQI61hbFJHJ3FGiXo2p8nCNCsRE+jVofHdSxRrdduhkhfFcl9XmlkWdmUMi9r4USXIIGzt2xUP20+hYB/sAiC4E82K4fvKOEUwm75Xoi2pJcSU+vCl4sVF7igYNLQQYk8mqZmjl4AEB9KhgP1Dxw+ZFMnI5VWgcbc5uQrpNhahFcOjKiGwy7lhQvE4zaUn50z49vcMWq+kalOggOq3GFUyHrF2Mny+dfxEsq1GVQuPqK93BeJYeXGDf+38TahwEXa3fwkfIiY3QE7FExLmlApljl/M6nBS5vLflIwUblof5z0lfOiOLuCwtwLZqpI4tgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vAtWBl7/l81mQX7D0RScC2YnqR0SXdwPI7Ga+eS5NE=;
 b=Iavg19rLHH84jMe8RLknBm9l+hJE6BK1gKhlslN3CswdDWwiO0SQ1lrMH9b1FRM+h8xx1DOg1AeJWFtfUA3YzVvntRlos+hOdl9phXoKHFgp1PQOzuEVwknLzCEoNidJzvqR2g39ywi2TUXRoPRz2RVA+ufM94EZsvKY3/pKOHSH6QnC5451EquKP0hEE/hX8mTeuaUwG4ubO2RqPhnlkoVs4wmc+V8AA732nawdkH8F8hX8d18V9c3DRCtW79Ckgp0RZyVx1hmnhqd1s4dRSL6uYuinIlXqct8edhurjBUg8bla1ZjyTZO5YuZk/R/yN7zKKLHQdI8ngclXax/95A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vAtWBl7/l81mQX7D0RScC2YnqR0SXdwPI7Ga+eS5NE=;
 b=p2bKavNs5rYePvqD2nuRCGG8Vg9dS6XjVgYvdxTBq8S5A4QfdubdcszDRMtumEymJ3dpnqg5pg3igCk/HTTtBqOI0/1OhKE9kXDlRsdjac9NZUrmuN7rZ06s8OnJB4ygjCAuJ7eMISBkWQVxluNfgcx8UnpTRtBBKrfGtCZ2a+sraUs2cpsIc0Nn7rKNEkCj00yu+3oxvdSgPL6CBU++WsZTaV5aBNy4o1qiOhfoOE2b+6SpxxY32LpYGRIelek+oXxhI51tD3P6IIWIS/qjp63A8QEyWWjPK7aEPJwQ82wLc0OFdFrcgIxGjpQSxVoB37xUfPGmM+kp2g93nRJUAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 PUZPR06MB5586.apcprd06.prod.outlook.com (2603:1096:301:e8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.18; Fri, 8 Aug 2025 07:45:43 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.9009.013; Fri, 8 Aug 2025
 07:45:43 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] KVM: TDX: Remove redundant __GFP_ZERO
Date: Fri,  8 Aug 2025 15:45:32 +0800
Message-Id: <20250808074532.215098-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY4PR01CA0079.jpnprd01.prod.outlook.com
 (2603:1096:405:36c::14) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|PUZPR06MB5586:EE_
X-MS-Office365-Filtering-Correlation-Id: 5881e147-7541-4f27-fb53-08ddd64f9413
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|52116014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VhlnhgZkY+ZSkTFtGMbp0wd+NvlgaYri8rVueywIJQONqPY2YUQXQsnrHIxa?=
 =?us-ascii?Q?r6KuSfr1UTPP8Q6zejVGHqFX6HCkYzX6xrmGhWrEPPYNKykDomNn5SUBKbG3?=
 =?us-ascii?Q?QV2PSRfYVmh0wZyoRTIuFF628SeLnwZywvh/+ZM3QBeC+Q/f4bCc7I7pCIN+?=
 =?us-ascii?Q?ZZ0BA6/obRsu9cmDFnOToaQ0Px0WkteegYA5uJI7Lo7z7pkldwHpzW1nVkap?=
 =?us-ascii?Q?1V8f6n/diuCvYjkpFnODrJe4tUHcDUn3+SQpJUA1QJaQ8Z3SnWu4XwIs6DTv?=
 =?us-ascii?Q?jzU8GScYhKsZlBbuZJ8uuMh2fmpdl/lOujQV9/0+8UxXMgOB4xzLl3Pql6DK?=
 =?us-ascii?Q?nb4txKir8IFb5s5iF1NVFHO71lEKgeqWiqWI8HNdQboYh26NSEiHFUk9Brib?=
 =?us-ascii?Q?42+I8UCFV/ad6s9rAR+LnJCBbSi6GvB446SKVDHGmEemxVQy8AA7P8zRTOA3?=
 =?us-ascii?Q?U70H9OZP6Ps8y37sMOTaTqVdy2bGIX7PmcRNOe9oLggUjMu5ptl42brHzKfT?=
 =?us-ascii?Q?hxYb5nDTUUlVydhk+6+2qnheqycB9cVcDziOoVLGN43cdMgfuu85VOUHmpci?=
 =?us-ascii?Q?iM6ENbfRkn+MCF4aR8Q4X+J/8uQyTnWUidqhGtTUQ67WZLEFLV+xRSjIxhvw?=
 =?us-ascii?Q?IBlYdlKrncwnJZOPXmM8jWGeELwo93EmuTSZEMBgwWTw/ketsZs6Rjo06lUf?=
 =?us-ascii?Q?Dl3dpW9mScN2Kv+JOjByRwWjDOi61jTbnMKyY0sQUYYI6AQSfeCQKu69tN1S?=
 =?us-ascii?Q?zR/+4wJAv+jLEcBNt/jxNatNdBsCmj/I6KWWe8LT1yfWZ2tpiA4FjjgiOPw+?=
 =?us-ascii?Q?UQxczfawKXtFcV1dheqLBi6/jjFIEDwaRJ8wD5qxm4j8Nxk1fAjSJZOQ9aII?=
 =?us-ascii?Q?Lcft0KBsBYoD5ci2bP/ykevzS3FR5r/YBXmUV/HFzbffiOJLst0Z2iG1IDvi?=
 =?us-ascii?Q?kSXnMb9Fsd2+Wt0YgV+lmtbw6kSeQ7/+o/AEfOG8yoQ54sIWxoH9DH59rw9U?=
 =?us-ascii?Q?wYTUDV4NWKmktg0nse1DALz7LTfNJDdLmHgPA/2xWnOrRcDjvgHXeXNK3e++?=
 =?us-ascii?Q?cQHuOKmgCQbFWmOekEJK3NbOrbYd36t34cjWNlb2G5jzO0opuKBz8D4yeO3t?=
 =?us-ascii?Q?IlnGZvVEdHoHJzBNa35bM1wHhaaIyfMuKV4WVUgyIG3xF9cX3S5NPkXbtOlI?=
 =?us-ascii?Q?5emsgZKsms5efXHN9776ZrSQimFcBgaV8g/ao4c2mRwfHdL2h0TxLVQTNRlx?=
 =?us-ascii?Q?JsUavGT3odJH8FTNDqAMnm5rONH5gM4t1MPWLESi+JYw1aD+GsKFK6rhIFQc?=
 =?us-ascii?Q?hsQ0M0AyWKFcC5iIp/85/b2c7dSX2TGVkKEonOO3I0Uijc42rNjvw3ZY6WMu?=
 =?us-ascii?Q?g/fRLPUp7KrPiCsVbnv94xBuMAx6ib0c5wKqERNM+aFaxRfmrO4sovz/Rbn/?=
 =?us-ascii?Q?QkrUe3z4i1ZTbdYjiKhq4pP92AIQZGu+39ntjZcEzbtPIVX9rKcvnoqWI6oi?=
 =?us-ascii?Q?bmB4KgrVsnxPy4k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(52116014)(376014)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c1IILCU50jCMGPpilmTwufXxWh0BFVa49QTGxqK/ISPEzwzw3w11jpBb0+OD?=
 =?us-ascii?Q?ixHynl/RZvL1nu94x4Q8dKzotBepZKJ+bkuGSnqIW3ue9/P3+1hMdLntMuxG?=
 =?us-ascii?Q?TeiutBhEVPkwDE4DzOF8dCkl0sFYl3IwWmvx2nGs8Zb7P1vPFq0G0yWBA0Yg?=
 =?us-ascii?Q?eBj/w/+eSOV+nhmW7ew4x2tYt2PmttApDP97YH2MFBYVrnbEqZQbMZqzePH3?=
 =?us-ascii?Q?1THXficJG2Kog0gsv8SmTUB4vQyg1RjnHFLbEqTOhVeEEQUX04WCDJPq276f?=
 =?us-ascii?Q?/Mut6ZcNO3Nv/lAD7ckKCdAvKPm6WLcFIyLyzWpSHRf1PayAFl0SXCcZ8R/W?=
 =?us-ascii?Q?U2tn5qC0WNkMaG4gGRfk0rgrLAXY9RE6MZ1tB6BXu2+JVZm3GTO5gVvoKPWO?=
 =?us-ascii?Q?YCE2wZBbYH6X14BYvOgt9CFZqfDaqpD4gxmzeIPtCczXUWMaUqKAe6cuXuaX?=
 =?us-ascii?Q?0Whba61xzpP6iW8v3JzMH+IkP2puzf+MAbcIQZ5WqQ/YKBDbi8eFhP418eLc?=
 =?us-ascii?Q?XwQ/hT+jglfcL9UmFKkvqve807VsiQoZrZ3LeADlj45uI8P+VYZngK2Wb3P6?=
 =?us-ascii?Q?UsanxcergGPBxq62pidhFQ/bRTVxcu3pOXHEfPAETFodvsfK2JxR/iTAX47G?=
 =?us-ascii?Q?7J8iJis9hOn/InelKyOeJJ51i+VVXBsxrPfmlqbCzGiWt8yPLeAMN7YSbGK7?=
 =?us-ascii?Q?6cn+1Dg73okmSQBEA9wYEGayz5EkkzwxY68uobV/h/nugJKu4pKz6xfTCsJ8?=
 =?us-ascii?Q?VMTBJE5k9ONLjYhGZM1Bds3oSxwmuonNlRD6fDue1KHQZ/XVK0PJ27gvL2wy?=
 =?us-ascii?Q?2iUVw26qelWQx6YRJYO921iY9nV+EPbfwSw41KbmRXVspRcCNXsAdJ9HjWoF?=
 =?us-ascii?Q?6MSwttam5NcU5OnP7VUkFQ4OED+x4ZGXpltaTCkcvhyGKQ1Hxi3XjT+pmw18?=
 =?us-ascii?Q?FzVtJ+fLr4QOhtUKkJZ5+Up4TEfg6iORgUl2lFlR4Ntd7/aBk2om83Tabwzd?=
 =?us-ascii?Q?75jemhMz7zjeIcer5ujizuGDkwoMYxrFZ0EAVTdXhpwgKcyR7AxBbW3D2fyK?=
 =?us-ascii?Q?OJY7+Ed00N33nmZ972ebZLCVVyj2oPv5AU8C3MuKG5VdJZxo06ww9sjnmhbZ?=
 =?us-ascii?Q?dwjCKwDTUKlL0A8sXzOfaEt94ECFL1psxlF7Ferk4pYVP3reRo6P8Nclh6TY?=
 =?us-ascii?Q?P+B4Rz4v1viFu5z+g2U91nUnDOfS7KDXGpKBwU5gbIBAXvhTVs5IcA6vGmq+?=
 =?us-ascii?Q?LJm2HX9zUxSY3WAJvcb5FOqvO2U9u3WOu71iFcQ5LawuoFsxXe3rTcYgjuRD?=
 =?us-ascii?Q?BRpT58Ib9/t3yqxIbLXtTp9UfQfR0vF2xLfCrbPkaaU/QvK2YexuHIVFeGqP?=
 =?us-ascii?Q?aWVCsO8EH/BPQAdGD4Npe4ugameI+PZzqRHlGklGR9yfVvFnd3x3bMFKt4o7?=
 =?us-ascii?Q?Nkt+7ZoNV/Re0/UJdszmbMYcf5puRBYFC/r6UQ3mEPEsmM8jkzCucEG87OTB?=
 =?us-ascii?Q?gRIGg62YDbBpYSzN0UbUG2hgO2Wl82Idmr79zu8gphBrAbyP6yOnFdWNfqyN?=
 =?us-ascii?Q?6lp4A6oaShu2d3NB2c6jgY6hGMxMBY/GPOOTrO9m?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5881e147-7541-4f27-fb53-08ddd64f9413
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 07:45:43.3730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tb0poGNs7seT68NDaCXcsBCavX0pKGmZkouQAG5sQwQA/W9cYtuuuzcOxHQ91u7/Mgdzppc9CkV/nW7JEMtr5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5586

Remove the redundant __GFP_ZERO flag from kcalloc() since kcalloc()
inherently zeroes memory.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 arch/x86/kvm/vmx/tdx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 573d6f7d1694..c44c8f0a4190 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2483,7 +2483,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	/* TDVPS = TDVPR(4K page) + TDCX(multiple 4K pages), -1 for TDVPR. */
 	kvm_tdx->td.tdcx_nr_pages = tdx_sysinfo->td_ctrl.tdvps_base_size / PAGE_SIZE - 1;
 	tdcs_pages = kcalloc(kvm_tdx->td.tdcs_nr_pages, sizeof(*kvm_tdx->td.tdcs_pages),
-			     GFP_KERNEL | __GFP_ZERO);
+			     GFP_KERNEL);
 	if (!tdcs_pages)
 		goto free_tdr;
 
-- 
2.34.1


