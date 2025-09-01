Return-Path: <kvm+bounces-56441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DEC2EB3E482
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 15:18:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD1A33AC8FF
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 13:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4E0220F2C;
	Mon,  1 Sep 2025 13:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="TOzde87M"
X-Original-To: kvm@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012036.outbound.protection.outlook.com [40.107.75.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660E314AD20;
	Mon,  1 Sep 2025 13:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756732718; cv=fail; b=s2ljkBazwzFXkd0ujxEVewEG5Oz04dgQKD8sTSv+XTfqhdVFXLw7w6XYLq7JEAb6KBUlv8GKFFGDPWQE8t6UnZbChi2bSr93K3OZV2VOAN90kX0hMrnXJTkDvqzGPSKCem/MSEHiBOjj4VhBRdfGP/JTRs+hqibutMZrStYMZL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756732718; c=relaxed/simple;
	bh=QRSP6bR8ALt8b4+monZhPoZwE3R2icjManEYVevhEP4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=crxLzEJoTtPODDvYXAIQ9UyTmfCH7SfHg7OHMesGpRlnczDG//vdD2MFQWc9o3sV/Fy+JSB6RZ/YV7IzCHrQ7AYJIX3w0tdexKNGVvw8Y3UEVcl0oU8UvgteUsUmeJ0IrHaPpH+ZRW6lFYaFvmlr1XEWou6hy2eeBwK2pcw5ZLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=TOzde87M; arc=fail smtp.client-ip=40.107.75.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vBuFMDs+yFYMwCuwE56w5Ie2mVep0muKCA2d8GC9LGUnrNacj0KmR2Cqb/jC6aC0+PAM7IbNY3QEfXvlmkTwaFKpRfnLStGcquLrQEwFXcZEBo+E4S7jKTkYKUErKzGSt+AiK+rWWSZdRMiQ3+eBybSmnEUz8CUWqnsR7D4cNXmtVfXql/6/5dWXtB8eE4JCnbnjf9S7O28aw+krB7PUVXpao+s0CfWXg3So49goeAtou+KfiAjmT1vXiz9na5lFv/qQuWtkQ4Zr6mlhnfTZXAD8USdz/bY+U1wGPAT5sdnFp8o4O7mz85Y0XjqjfyzDaupz2OtpB8QXUBtl6elJAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LM+7mwJMZhYSI6HX+6aQXctGy2kM6xKx3xiDxJ+wSY0=;
 b=p4dmQQ5undtKUqFl+uMqDuiaQSMtc+P7SYDDF7oZlUBgHvybDPay7R+UIcsd71MMZ7Q0NinxAv7WdE8gS3PHheTQDT8xSX2enk5nSmeC7o4hv15MuQGqltZNO7+XUJjx5TfhkxhxaqIKGrvmjLyRJqWvk+VwiPI0OkKEhXpCCxS9A1ffvR3BUIR1p1E9vfPbIw2MEq/Rpqgj2B2HUMAWmST/+uhEvlivupQxYXjTkG/IX+EnT3b3aNbsWkYYUceyqJauUGk9MTNQF0hrOY6ZTsaLBOg4TT6xGE/Do957kKR8JQOpBAkS/AQ7i67amwSD4kxhIS+6V+4suFuJ9tnB8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LM+7mwJMZhYSI6HX+6aQXctGy2kM6xKx3xiDxJ+wSY0=;
 b=TOzde87M404iMftc5bN3YQa7GeFbrJ7I/jhFm3HSqNJS/sw1xt1RNR2Ak/k4c/8mKDvAq2LDgbjG/ySbahoc9txKkqjLzQ+f/QBc5mJ9dBJ7oNHLN3jAH0GRk4F3ZD/IUVqCnyYNFSi9/dQXEGTkB2pgY7vYNqYv3oFQYN4dirYEM1PfLeJKH1vrgF2YRXz0Qtj8GYVhnslCHGlqV8JEN9CDP8CeKeNKBqwXs7jKqKjCF5l1P4DSKcKDaV0EcKQfwEkyo6ku0P7WVXxlHckpRxzS8JJeCAwcZEVoOLD7S8N8SBXnnKJylUM0FSjk0GR+fe+2QSwhYWjwD8gz+JRMnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by TY0PR06MB4982.apcprd06.prod.outlook.com (2603:1096:400:1ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.23; Mon, 1 Sep
 2025 13:18:34 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%7]) with mapi id 15.20.9073.026; Mon, 1 Sep 2025
 13:18:33 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)),
	linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH] x86/apic: KVM: Use guard() instead of mutex_lock() to simplify code
Date: Mon,  1 Sep 2025 21:18:21 +0800
Message-Id: <20250901131822.647802-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0024.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::11)
 To SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|TY0PR06MB4982:EE_
X-MS-Office365-Filtering-Correlation-Id: 554c2637-48b2-4673-d30b-08dde95a0d34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|7416014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yobBCHCOydLPIUuwFwWRNma7Bl4UK4uE7dQQezSuZRJ2v6TZ/Ztd2LIeJjdE?=
 =?us-ascii?Q?HDT0wcX0MbBg6lLJ04+xtCQMtz1dw/NfZPpyA7Z+XHSSZKPjASTx8zTM9G/w?=
 =?us-ascii?Q?S+8kNBgIcMpRrhMsbEBWzgWFfAnMm9m9vhWSu+Fl9fPJ6I56yGr9o2Xq21+V?=
 =?us-ascii?Q?z5o/RP1kBlVdd73Zc9KuoSiFdPGXP14Gs8gr2E221B5XfwJ/VfwwfGCjwDWs?=
 =?us-ascii?Q?wEFnjBNJls2Ylp6VQ58FnGOumajULnYGePlCQ4XM3pSluhE2xA9ZEb7XpFPz?=
 =?us-ascii?Q?spJq6NKy+WYS7CkVfWgAEEG8ZvD7OChatAxhQayVns2dCuAwLxNkhnnalBi1?=
 =?us-ascii?Q?2V2B9gOBzhsJ/PUtq80Oe0qOYxdSk61PyLUF3dD9c+Tj9g0azg75iYQlml+c?=
 =?us-ascii?Q?FaGtgO5YKpgAKfIyJ8lNIvnJIE3obnqDGmfIeRbVUXOPF8ba+YtWm3xXrwB1?=
 =?us-ascii?Q?KFOVoBGq/DVKgdQRv/QUM+/P05iIBb31FRTk0HNsDz+pPxYziGxL6iQLcHEG?=
 =?us-ascii?Q?KsBb8TXaLqnaxsEQoys4NdyzCFsMJYiyByRRpXUx1APWbbVqOC2xxwY5vJU4?=
 =?us-ascii?Q?QCnLwbePJ+Y976p0imQEneIoUyCTbW9zHJUUBxWZnzFdmQDSQcuEHMlV0mhq?=
 =?us-ascii?Q?Yt4ZJa1LnFbGvyyUtqlcsVmMDnbO3A7dLTCfM+bhlSUizd1Eau4IbPRvUp3r?=
 =?us-ascii?Q?l2FsxyZANhu3Y0FDDS1alALkK8nu2rT1zKyq7yXPP0SehxDP5NIBXK13mrf1?=
 =?us-ascii?Q?wDsRVUMIussuPNhXccItMeVtXpQK00Def2nNUVeqUQXNcSvc1Gn2FqCOH6G9?=
 =?us-ascii?Q?14J30P0M+vjqzPc1SXi7YrDB3DIU9jlJZT7VxEwyzE2G7JYsH4oaebs0xyZa?=
 =?us-ascii?Q?2hO9EKEKqLPVSPls4ZYcwrpsRfNnec899YPlhjKaue1EyyqpoqHvjkonglgj?=
 =?us-ascii?Q?V1WqzF0lRbVLzqd57Cj46bZ7kBrz3idNdzFwziFzYXfnT5Qe9Iyws+/+VjPF?=
 =?us-ascii?Q?U6sUmJ/k0Moh1+j4tN3UxHUa1yWT/VXmafbrJPNyH7G5Q86gbuYjoj90NTat?=
 =?us-ascii?Q?W0tZTV0Rhyof2E0xWR1QTWb/H6LoiwJb6GMr6J84JQ4tCTG6mbLuNzsX59WW?=
 =?us-ascii?Q?aFoa2kvVihYDUGHqP1iDoICCtV0jl/zSoepMre69ZC7s/9sreE5U8Xk9/fbm?=
 =?us-ascii?Q?YHVgqAKCKZOBPR5bRxexicFwh1OPDDy6OcQ7WouSJ8g8xqiV+Lj25qrswIRr?=
 =?us-ascii?Q?2CKdBxIx6nrf38ovt+OTGlNzn50Y2jPevB6En9NedS03GaHLV3gk6mQI6MhA?=
 =?us-ascii?Q?BhD/5C3+EieU6BOb/Uw4GCdBmMUZJGGEVCwD9HxliTU+TG+88s8/j8sgq9ub?=
 =?us-ascii?Q?i+mnGyDENE+uoQk527MIgdwqj7ct2069kc/Pey8ZjogUK6GIJtOHGaFMTm8j?=
 =?us-ascii?Q?QmteltQjF8/hlgGEZMJS2vaHu7ns/wIwlgtDXl+p8emC6QxdlaMjJKFGueK4?=
 =?us-ascii?Q?eDgSZ98LkJbljZc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(7416014)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hZx57vNVbM1T/wHxQro73GfDyy0SvNYXwOBX8B6+GzZW5/pfjkybOz3SE0QM?=
 =?us-ascii?Q?hVt9L62ZaQ4yHqzEk1lvvRqnkVzd8QeOdSADlp0R3B61coEoCXZ50eWAbNbM?=
 =?us-ascii?Q?CP9OZcPj3ipiCrQg5NF7KyB67z2dsQarYXkqYbL4s+VE8fz4iqqDtydKBS3E?=
 =?us-ascii?Q?F/1CI+yIMaTsKwSe/3GWRpQsU3OC0wXGnI8yEkES41/kznkUw7GN+ujjTcj+?=
 =?us-ascii?Q?rMouGFB/P+DYFWCVEWRWmZE+w4u9NKfMy0UKrrtnD54KfKxW5rvE+56IERb7?=
 =?us-ascii?Q?fQkM3rbbbkbNLy2uzcGNgiYQXLCJ+lJcXhlPCE3Uofbt23lgWB8bVrh/Cdfj?=
 =?us-ascii?Q?e8uv9b1X1xg4vv2ihZnA91kJc60ThWN1ay1lqyCtSOebCFUs2TfCjUaI1Ol2?=
 =?us-ascii?Q?vAL9nER8ft/3WctMLcUQPbTwVR/846qrfBUel+X0jc/r7dE37F5poW5ep2VS?=
 =?us-ascii?Q?UNY7i9HSzr1Okgw+88ZdkjRPaqIkONMYsn1BvoW2nrUXaFlh3k6zn1aAiVti?=
 =?us-ascii?Q?I5rgohsOGegpevcMfrgXWotunfnUbyxRDTglw/7lEgD/NJ50Ef5iTDA8ZDmI?=
 =?us-ascii?Q?Jcx+hNnEZBZql699LjXOVCLBXgNbhFkd7HDZ1uL/jtPJBLPBVpy+OEkaGVU+?=
 =?us-ascii?Q?Tqztmaogs5c3vyp0t3pA2ngh4ZQk8Bua5XiSvl1sy4uhRx75p4hIodElyZGA?=
 =?us-ascii?Q?qDy+EEnsNNY0/cfgdalyivfEmwlKgoL3lhveYoz62E8ZmhYCHTtDjQ6GLExW?=
 =?us-ascii?Q?/23WJIdM+qNQJcN0saqRH+c867uN0yPhKF86gEqFO+D2APC12+FSbdm3Fhf1?=
 =?us-ascii?Q?IyB40m7SSWa1Gd3w0Yn1nhHBVz+3PdKAbqC7OjnfuL9NHGRBs7HuGKw/XhRX?=
 =?us-ascii?Q?2MpPZEWZBD0WuJL/IPWVINFDeDsK7vXOaJkmK7zrJWnTJ3bp1ff01w3iltKl?=
 =?us-ascii?Q?5nufO1yd3qNCVCKMK4zyZxWfOUg7ZmXfZ9+6mxTs2j6EvTBkypQS4v8tKpLe?=
 =?us-ascii?Q?iM87bHjYLQD6daFk+DY7thZDrxs77ggzDUQZhz3Y8UqX/emYHbbeCDhqoKRw?=
 =?us-ascii?Q?mncbSRu1QAMboFD0y1kvRG/b3RlXgcWQ+Q2z922MkosKtKocVDhgFCTq5YaT?=
 =?us-ascii?Q?GGY1lnuFaGYiiYlvxotRt8nEC1qLoMW6oGlaVhy6GINm75Yh2iaDBsLpugtK?=
 =?us-ascii?Q?t4M8+EXV8f1yZxFfcCMWQs+/Xwr3AhJElNHhTEgZPTmIXeWsCDj40+pn+haY?=
 =?us-ascii?Q?LiNNi7eu1oPiCN8RmnluCeM3OQSre1xexV9IOmtL8A3lHFtXJJMQDTTBpvDt?=
 =?us-ascii?Q?2R+dke3q2H0jl93uRrs2++8Gy1QEV9WFGO4f0df+eMGyNZejtQ9F31xa4vLZ?=
 =?us-ascii?Q?SLA7LgHPRNwFh217V0QTlk1w4elEDKLUbEq3opWtDyoN6isXG+GNkkGYjqVy?=
 =?us-ascii?Q?cmB6klX9TsJZjiQvhz/HQJfnBT6QMf1EdtSvyTUerg1HgE7t6K1x72vmuaUU?=
 =?us-ascii?Q?0qkwS3HTJL6gWDvbFwP61lUbFobuY7dkeRhcYPSV2zZ1p2PCZgyqSZlZXFH/?=
 =?us-ascii?Q?gB2F+WC7U6+77nB34zUUxUNqZAD1VLx5PCJUT28h?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 554c2637-48b2-4673-d30b-08dde95a0d34
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 13:18:33.6588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MiW6eJytlw86JOaGixXMjovh5B204FmHk5FEaobyFlhsTWOAfzMfwKBeivwuZj8gdP7dGPuFkHnZMBpF3UaOZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB4982

Using guard(mutex) instead of mutex_lock/mutex_unlock pair. Simplifies the
error handling to just return in case of error. No need for the 'out' label
and variable 'ret' anymore so remove it.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 arch/x86/kvm/lapic.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ed636c1f5e58..fa52622bcf5f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2683,24 +2683,20 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 int kvm_alloc_apic_access_page(struct kvm *kvm)
 {
 	void __user *hva;
-	int ret = 0;
 
-	mutex_lock(&kvm->slots_lock);
+	guard(mutex)(&kvm->slots_lock);
 	if (kvm->arch.apic_access_memslot_enabled ||
 	    kvm->arch.apic_access_memslot_inhibited)
-		goto out;
+		return 0;
 
 	hva = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
 				      APIC_DEFAULT_PHYS_BASE, PAGE_SIZE);
-	if (IS_ERR(hva)) {
-		ret = PTR_ERR(hva);
-		goto out;
-	}
+	if (IS_ERR(hva))
+		return PTR_ERR(hva);
 
 	kvm->arch.apic_access_memslot_enabled = true;
-out:
-	mutex_unlock(&kvm->slots_lock);
-	return ret;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_alloc_apic_access_page);
 
-- 
2.34.1


