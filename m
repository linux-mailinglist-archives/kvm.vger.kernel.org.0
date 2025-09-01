Return-Path: <kvm+bounces-56440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A66FB3E46B
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 15:16:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C70441882E97
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 13:16:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4551E5B63;
	Mon,  1 Sep 2025 13:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="oRY1MLCy"
X-Original-To: kvm@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012068.outbound.protection.outlook.com [40.107.75.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8941EA6F;
	Mon,  1 Sep 2025 13:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756732581; cv=fail; b=BCyO68Tff2tkaaYjpLyBtwLXXgk2HO5DRAM3s5j97fIrm2u6XF5SKtRuhP0bR30a0I7pIZgkhLzcmwA5AbROkaJacmmYFXVm3Hw6UsObbPsMFaxhAI80YM5gCJuCZqtpVhGt+5+FUNadwPIkt6vs7GXUruz1FHxAKyUa5IQzO4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756732581; c=relaxed/simple;
	bh=Lf42zaxX/x/Xs008z0gVf3QOtrDBudRrvZy+oFb2vRk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=TJpETt+3QhdaKFjP7vsxb4MVElCW3bwiSphHrJA0mOWth08R+x2fw4MGcN7x+HlGAtIdM4G7yvSApkd55UanuzMvgBkaqD9SdszjSfTxmUieKNk4rVz6sF0Sn/BMw580v6o9/qRqzneZZrlfA+ZCe7zpNt4Puudsxvc85TRIDLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=oRY1MLCy; arc=fail smtp.client-ip=40.107.75.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kAabzDgtLLd7dc1H9h3bwTPos2PXXMnyIVgOJCpFzuYaLE5OqadAwlQfszehAUxsdt6ugl4j5OA6fPOim3dJg2oxnaUmG9cepl/esJij0burQvtt7Zk0gN+j8FTUzinGTHZdZoGq66ESeEa/ZciqozWgJE1Z2KxkLDtYj5jlw9KyY9mOv3kO8OlPqxJlchuAt2LWpZT7aCgmtVOCHFkaYsLdOswy1ot+TpmzCpkgd3/Mlj0f+cA8sGN/NNqS66gq5OUUTQJVzrbUE1QeZ4LHevuOrg99pV3swvQ3AKgMnQIoGHIfmFPG7Sg6ZLw9YhEgdN59Tu6S5hYDEoRe67us/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHYRzjB/nuyZd7sJ7GiuHPKxCefOmmGqxYUPuaQHEBI=;
 b=JdqLv5w/FG1g9EfkMra6WJyV8o0q0bVjN/s/BxU8gk6oqsJUwnuvDWD6zchWkR5cyvUHB0GhGWTgOZbSLkD1boUvIcozXjSVq+mktmtIU0bDTkgFeEWGs7AYfDpxTFYxvVELNy6J52uVBfcwb1LYlz1JCnugTnwNmhAhFmAnAfc4umhBGy3rvlSx8RS67Mtsdj25js9DV0DvSiQk4ti3kokV77YdLv9x0KOpBdXfo6B3H9+rVTTsJPXB+wmSNUQPyXyOcJOrsZWYY8kiDQBjW9LwsNystS4kg45JdZdA+Th/pXyvhSK0yEC3FWcGW2lqzd2S1+V/9GGahbtaUFSqug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHYRzjB/nuyZd7sJ7GiuHPKxCefOmmGqxYUPuaQHEBI=;
 b=oRY1MLCy9c+tB0GzTEF+TiVxlSBSyINt25SPVrLqZvl/H0dqw/7Qmj7A18B0bIWP92Ey6JI+34PzQU3ioC33Si7kYkLhDisevi7URsfoCpdi7GKPVKWfH+R7B0dxOoj0+XEWaP7aXzltws3cok1S+rGNrYkWxZEId9TLr5ZQw8TDFR1EgJGxDm63hR0mQWchdl9FfOn9aSVeF5sqHLUzduuzsMLdbXnpFQo5yKyPl4kJK99r3KGLwGGlOyMwJE+Y8TysIqFsBPM8K0ZHcaTSNcoEnTHCMIvdtcBPmy9bPL/9QbLC0YPYVKmApNNEPx/ixO8uBkSVzXikoLw1VYXATg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by TY0PR06MB4982.apcprd06.prod.outlook.com (2603:1096:400:1ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.23; Mon, 1 Sep
 2025 13:16:15 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%7]) with mapi id 15.20.9073.026; Mon, 1 Sep 2025
 13:16:15 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org (open list:KVM X86 HYPER-V (KVM/hyper-v)),
	linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH] KVM: x86: hyper-v: Use guard() instead of mutex_lock() to simplify code
Date: Mon,  1 Sep 2025 21:16:04 +0800
Message-Id: <20250901131604.646415-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0148.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::16) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|TY0PR06MB4982:EE_
X-MS-Office365-Filtering-Correlation-Id: e884da59-dde0-4ef2-955d-08dde959bab0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|7416014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5AbVQxw/5HT32XYbPXSvcWOK+lwY2eL7I0VFIptlSu2qV4BuGo/Ygqddf5kc?=
 =?us-ascii?Q?553v+cBhMm1bLWuDu0QbDreza/rRgoEHMBUlVX4Nw0L3AOYZom/OkEyypGt1?=
 =?us-ascii?Q?SbWVDhVHxiMDu6+2+UcEeqdo8gilc++UjrXO7WCqPAscqcO1vZZO7dRNcT7Y?=
 =?us-ascii?Q?ODmdVTBNotEMEp4U/PtZ4LB8v7vk2g+fx7ELZ4JPS/KIMJIupMhsVePcl6EN?=
 =?us-ascii?Q?9UejObZ8jEi3VaDgc3qJ97lV16Dd4lJ6jmQYgnIX8fpE3N12bwPfeeyrBV34?=
 =?us-ascii?Q?D4eBFusA3NfqWxIb74ytEmVtW8DVDgCCHwXRVX1WUBTTDzW/NIWZWU3vbtvV?=
 =?us-ascii?Q?yNzvNk6W2iS/ebC53XpSjPR5H43UqYtrfD6h7AE/h4QxWCwDViuBwLmYDcUy?=
 =?us-ascii?Q?vbeywf84M+38diW7jikPkrvJlzLwhcOOeGTqgMIF0i7EyLxmKDxi90AjRScF?=
 =?us-ascii?Q?gE9So8gsLBQgm+IslLst6zfUNNWci9HrVj0Sj1z37N+2b3OWq7NqxvaPmgpp?=
 =?us-ascii?Q?eF28i99EyjbdjquMQhEOaBuj1SWBNoS9ytLtUSeVsL620XU+IQC5LFH1TK1G?=
 =?us-ascii?Q?eew7KG9auyYTqWajOiuOLRGPJfaio29DvHT5KtG1Se+gmKYUjIwmemBW402S?=
 =?us-ascii?Q?d6K6WYsW5CigCqY1AbefARSFM8vXnNeDmDpYPx8fYCqcNzGUvBY4r3DRKZQQ?=
 =?us-ascii?Q?D4CMbVN8Aoc6pGN5f8vUrmt800foQ1wPKk4bazvUKsvzT40D8tyt7cVTzCqb?=
 =?us-ascii?Q?8O22FBmpyeCtCVMJxKFYC6xsJQuNwuFF2yx0D7Z82vP5ka2sCdnHuTMHcPO6?=
 =?us-ascii?Q?K0VCwBfQMK/8hgofeqs1FuacTWm0gm/8bpDtUqkYdqizOk0nrnWf2u8IbJ8D?=
 =?us-ascii?Q?1BOjVKr+yQ98gukPDmGgur7T19McPGuTbbvfGGGXgEPEIaXJ8HBvBcT52OIw?=
 =?us-ascii?Q?f4LDQs1R+i9Ln1cYt+W+kcnwNsUmBUEt3TEjwv6Ivons+U/tWyGmLPMyJXgA?=
 =?us-ascii?Q?7yM027cCeWaWevLJOpZaTXHj4EBlhfQ4/E7ZRn0He6mP4yFXD+QmfZC6nvd7?=
 =?us-ascii?Q?XWtO0eUMHXJFGp3SkS28LyvUi5cFZky2Fv+Kai02aN4JRMONHE3Ep+vrud2O?=
 =?us-ascii?Q?JZPDEMtLMMIJ/jjs/ohdmNsT8ZBn5jqhIVUtTpxTMio5M2CkGWqfMrjgdEdi?=
 =?us-ascii?Q?PZPbO+txurAgnOyAZh/LP+Pg4oJXUAZCmBbcwW0ivZ7JSP7qHQR8oAaxo/pp?=
 =?us-ascii?Q?rR2Rm/JUxTwANjumEpSoL2jNo6vlSdC8asD9GlR7kSToT1495tHQxSaZDLXg?=
 =?us-ascii?Q?9kuOEq7dLMt84/qXkY4xy5RO9MVHKOHXJyqG2ZjNz18jznbfxllCFFfe/q/b?=
 =?us-ascii?Q?LmlPBVR/2APnhzODilPadN14IOlgfXajuR2kSIxpLdNAisw4LNqVo6wVGwt0?=
 =?us-ascii?Q?k7HBpAJNg55ittbQNpk0LH2P6ahDChK7xSUZJXFYh2GswlbWfRz0aC94P7es?=
 =?us-ascii?Q?4lyOG/DNU5i1sJ8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(7416014)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KwNiURnw3FMERLQHIt2wjGxUFz0AsiBuFZRzR+/ieawzpCIlPS+8KhEAy8eI?=
 =?us-ascii?Q?ioWsGqOK8k3c8efU2g/3Doff9xCNwmwHqAs1l63nUHEg8ebsK8M+iwrH/UcD?=
 =?us-ascii?Q?+aRcLWZ3pOie0Icu9D7gAa4o3W0if5LciuYR9N5cfeQM7P42V0O1s7VTCKoD?=
 =?us-ascii?Q?lpjQGWcBogKvkwilGw9rvGWbHv/bz0kDI4oVR9jK9gA98zotWziCfJXxOBQr?=
 =?us-ascii?Q?5vhqtgqK5Uw6Yptc2NVKDilAyHaV/lUy5VdGNPGfiWK4f7P59Rcjf3+TcLvd?=
 =?us-ascii?Q?bjgyxvu+Rsbm2InxW7ASGk3aVnyxBUVE+EN1EKNAHZcKczJ5O5yGA+dkRG6D?=
 =?us-ascii?Q?Cv6RfJbSO2xl+TFgJdNZqN9B+kntXm0v2JRxCvs2PK+BpDGnSuj3MLOru3gm?=
 =?us-ascii?Q?jKjkk1JKs98W/FYCY2Av9tBX/sr3gJYk8v5sEsJTgwbD+ZCqmZbGIvRYPb+I?=
 =?us-ascii?Q?TgqL7JKrbBU8R1NCSFWCnt/XqA134XqCrvwDk/kJ5FAqqHSnbds5pBTG7QJC?=
 =?us-ascii?Q?htQyQQ2Pw0eB2UtxTbvqsgDrx/pMoVEJWwXRciauMQGdT38remKxxMpraJXG?=
 =?us-ascii?Q?ifJARhHV8TgqRCJHc2RX3NQKc5RhwuiJLzb7vKGxRS1/T3fErx3xkdRTZrSg?=
 =?us-ascii?Q?0fz5gOl3+yjaMLrwm9IQn99oSeCA9SrirC6suCQuPqXzQ8H8bm3nlIySi9sV?=
 =?us-ascii?Q?e6KemdoMT0l3KV40ijxWNWb+2g4+O9xoW0K4iaDTGy5t+Q6NH5v0dgansGQP?=
 =?us-ascii?Q?9AbktkIZDZcM6WqvF51qcYwFk/OPYfIwwSBEuibLnr6rYvdS3Fy79tjTAQeV?=
 =?us-ascii?Q?tYG49rGyLkHZR1goyLF9Htox8I2WzxVoxvU1Qt03xucUZ0tdhmz8FymA2JJZ?=
 =?us-ascii?Q?oor64iadbIW/xqhQNDlYKnY7ZE9tz7ItDOIeLgxrT/9m8JnR7F3zpEBYwKaF?=
 =?us-ascii?Q?V2jDnaElfO+R/CENleDn93yqTrkzJrGvKMss1s8mN8bY+FvSpNcUyaFcFNgO?=
 =?us-ascii?Q?QHwv43WqoWtG6/j8ctI07ctDwwTgv3XyR/dQvpsUgHOVOaAQsW4eilRI1JwU?=
 =?us-ascii?Q?OdHBsREsaEH+m2UrLoCijnLA9tOQIz/Ijaecoy0QWp2Sznbv0nFHJBzZOw+I?=
 =?us-ascii?Q?n3O4D0YHaWstkwYLSfYfQEoyeXVvIXguvfSjB0LOZBLgNSTJMXEJof1eFGFS?=
 =?us-ascii?Q?mfRan5aOu3T8fNrx4JX1dDq93U4qIVbEPbaSfv7VgF181hwMgDngkPpZPTrv?=
 =?us-ascii?Q?IVDLQVZgUgNEMoEFeW6UptP1lN67w/NY0Lha8BU5SqvenxtTWGb8J4IyKaTD?=
 =?us-ascii?Q?MSF0h8VS107Bgb2MPBJFdink2zgQfsZGFRsaZj7j4IC9/QqCccfjMpsyxPde?=
 =?us-ascii?Q?SE8ebXkZQk7uHP89DHZ9xi3z5D86zn7wDHafUWdTTX2QY4TxiE7nUGSuTiFL?=
 =?us-ascii?Q?kEBw7G4nqZUyx95HLQoudya4kTfTduUM5Moqo9dV3iD0INxWd6c0RsKAgEN1?=
 =?us-ascii?Q?rfxny1UMvtebKuE5RlKePr7kvYiWdkOEr3sR/vgSb/E5AaQGp6seoraXpi8z?=
 =?us-ascii?Q?mMAlViMCSl2uO/cNgxxmJpw4+kXO4B2eUTBCBPLw?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e884da59-dde0-4ef2-955d-08dde959bab0
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 13:16:15.1738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TZSGbmq43d2CWXpleQov4Vq6dgGxbR2VQR5BCKyB5DkQb70kGt6q8AgOTz56/OzFMfvNfIYIYv7OhtnOidYOoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB4982

Using guard(mutex) instead of mutex_lock/mutex_unlock pair. Simplifies the
error handling to just return in case of error. No need for the
'out_unlock' label anymore so remove it.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 arch/x86/kvm/hyperv.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 72b19a88a776..a471900c7325 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1168,15 +1168,15 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	BUILD_BUG_ON(sizeof(tsc_seq) != sizeof(hv->tsc_ref.tsc_sequence));
 	BUILD_BUG_ON(offsetof(struct ms_hyperv_tsc_page, tsc_sequence) != 0);
 
-	mutex_lock(&hv->hv_lock);
+	guard(mutex)(&hv->hv_lock);
 
 	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
 	    hv->hv_tsc_page_status == HV_TSC_PAGE_SET ||
 	    hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET)
-		goto out_unlock;
+		return;
 
 	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
-		goto out_unlock;
+		return;
 
 	gfn = hv->hv_tsc_page >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
 	/*
@@ -1192,7 +1192,7 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 			goto out_err;
 
 		hv->hv_tsc_page_status = HV_TSC_PAGE_SET;
-		goto out_unlock;
+		return;
 	}
 
 	/*
@@ -1228,12 +1228,10 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 		goto out_err;
 
 	hv->hv_tsc_page_status = HV_TSC_PAGE_SET;
-	goto out_unlock;
+	return;
 
 out_err:
 	hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
-out_unlock:
-	mutex_unlock(&hv->hv_lock);
 }
 
 void kvm_hv_request_tsc_page_update(struct kvm *kvm)
-- 
2.34.1


