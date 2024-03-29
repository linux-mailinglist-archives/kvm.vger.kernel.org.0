Return-Path: <kvm+bounces-13209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC077893376
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:41:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 039721C22850
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F219814601A;
	Sun, 31 Mar 2024 16:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JPIXhziK"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D5A63087;
	Sun, 31 Mar 2024 16:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711902978; cv=fail; b=gPQUa6lJ9JcCBiEWUhzainqodo5v1A9U4UndUa6Vqr/P3qwwIUBxYalZ6tuAkiUBRpLHacA9MHw6rEDehkNA0DJIvvUa7BBWz97FSW3N2mCALDe0VJ5aO/4PKzEt8VQ9t8T0RVHKXn4pOleDRglE2W0RmiOOdzEgq1WNESxBdbA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711902978; c=relaxed/simple;
	bh=ou2AdDZ2pEpFeysjGA/ox75LNd5qqXJAxxgUPc0HZ1A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g2JP5ZSlzKIvldFltX6BeZhNFr6GXaVlSp8mYWlGMuCnJeUjewacSo9THyu+j7rs6jBz0IWASHAzhDo1XDQNaY553MxXslZB/CY20M/tvayHWr1UPVluVEP6c2bbdO9PEbkR0lbNaUsZADHrqR3ua1ZghzDu15LShwoJVta+Oq4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JPIXhziK; arc=fail smtp.client-ip=40.107.94.40; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 1FD96207BB;
	Sun, 31 Mar 2024 18:36:14 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BHxWRzUbCdeZ; Sun, 31 Mar 2024 18:36:13 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 1DB75207FD;
	Sun, 31 Mar 2024 18:36:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 1DB75207FD
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 43C8B80004E;
	Sun, 31 Mar 2024 18:26:30 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:26:30 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:23:35 +0000
X-sender: <kvm+bounces-13120-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
 NOTIFY=NEVER;
 X-ExtendedProps=BQBYABcARgAAAJuYHy0vkvxLoOu7fW2WcxdDTj1XZWJlciBNYXJ0aW4sT1U9VXNlcnMsT1U9TWlncmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAGwAAgAABQAMAAIAAA8ANgAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5EaXNwbGF5TmFtZQ8ADQAAAFdlYmVyLCBNYXJ0aW4FADwAAgAABQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUADgARAEAJ/dJgSQNPjrUVnMO/4HsFAAsAFwC+AAAAsylSdUnj6k+wvjsUej6W+0NOPURCMixDTj1EYXRhYmFzZXMsQ049RXhjaGFuZ2UgQWRtaW5pc3RyYXRpdmUgR3JvdXAgKEZZRElCT0hGMjNTUERMVCksQ049QWRtaW5pc3RyYXRpdmUgR3JvdXBzLENOPXNlY3VuZXQsQ049TWljcm9zb2Z0IEV4Y2hhbmdlLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQBHAAIAAAUARgAHAAMAAAAFAEMAAgAABQAWAAIAAAUAagAJAAEAAAAAAAAABQAUABEAm5gfLS+S/Eug67t9bZZzFwUAFQAWAAIAAAAPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAIwACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAmAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAEJTp8x1Q3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgAaAAAAjYoAAAUABAAUIAEAAAAYAAAAbWFydGluLndlYmVyQHNlY3VuZXQuY29tBQAGAAIAAQ8AKgAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuUmVzdWJtaXRDb3VudAcAAQAAAA8ACQAAAENJQXVkaXRlZAIAAQUAAgAHAAEAAAAFAAMABwAAAAAABQAFAAIAAQUAZAAPAAMAAABIdWIFACkAAgAB
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 19922
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.80.249; helo=am.mirrors.kernel.org; envelope-from=kvm+bounces-13120-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 5FEAA205CD
X-Original-To: kvm@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.40
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753315; cv=fail; b=jDYEClVUmR6/HwwwKkuuSuSFCYXUEUIThZNmckpSpJZDfXPqoqu5lFqdt64jnBz62THG8POs8tQCBTlS1Bq8BUAxJe7hO7u0JtNZfnhITJgQIAus3UVkRsZlYTzSk03iB30tbNTyEkIQ3rYwRqeD9SpHQqUgb/4NeiLoy7BvzHQ=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753315; c=relaxed/simple;
	bh=ou2AdDZ2pEpFeysjGA/ox75LNd5qqXJAxxgUPc0HZ1A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s6Q82AbG9ZzngLbFuz5qvGX2Kmcg4d557z6J6BsG7PMNgwF884JpTJz9iCdgUKAKeYVC9Sb3N/5oU5mjR6nESaE13pg06gpMNk+aaL9z8YaX/HuhuLbrMAbgUfnffLAO0LuP9dHuDkqdu7YJr9VAN2Wm2O71xrCkiOOv0roe3r0=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JPIXhziK; arc=fail smtp.client-ip=40.107.94.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRWOhZNhABJ/YKRS3BVDp/bMinsSHrbR2hX/jw4SfInhr0rFOxRsXzJrDLnMuIfKp1CihafDNRYi2LoltyF6ABan/xHubEFGj6MoFI0ihMWEK8fHpJ+KHVi7IGEAkl+2GUTRKgXO8Gph0xxYzIW1UFRlarpejMpMBrQly9Ve01u5XGlN1fQQHJDv9wuDaazzA4//1bG6NnBJeSdVX9riJCN1lVkmbAAG0TGn5aY7t1r1fJszBWQwRBl73GjbxlssaQmcHTEcvwdxNzXMbLrCk4E0tFsxc1LBkMsSrovXToev1s3KPwxMnVa4odg6zpGPOzNhtjSsuFgIh+Y/K0k3wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N9Lx9TYwv7hSTBNIzxDlO2i4fLCh7C2Jf3GSDM7iz04=;
 b=jHVAcTB2AdJt23egZTJN2P4JFvpaGQ2m+JGo8Ia2JP3zWHfXoSyvyKNOIZ53DE6iI8AImHdfGrwQMfromZDaj3Fctt951dKojGQFJcg8Lf0FeKnwj3rbRqe7ZJwyvNanlP2jZpzsOjLGFZUWpa1hMwsn9l9e/CC1717g4epMhWc5nD7Dpoemw5HkXCUXHY1FrVr1MNvznYat0k3BPN5VIZWzCGZ7hYuUJrFUY46y8OZ+ARWaDr2zMNHMM6kKXVk/6xxcJgqDJXOKbNj879VR0v5jlVWotETr5gLlEe1o5rYeHJduV3C8F3GATX4o8Z0y5SjCRRnOqtpKf5PZu4XQaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9Lx9TYwv7hSTBNIzxDlO2i4fLCh7C2Jf3GSDM7iz04=;
 b=JPIXhziKk90/SBn+XVrA9jNGZR5kO9mlu33MH7gud6UBn90dH1KmgxUoBCRQ8SyLdDSdYvuuIpsiUEBU9BrDdmkIIx9rFJNdvbFAi7bYjx4vqTyqLmQsNCpc1haajFInd99F2rqVoE9EcrQCSyO0wQS757HBfhILf6VvVs2Onoc=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v12 16/29] KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
Date: Fri, 29 Mar 2024 17:58:22 -0500
Message-ID: <20240329225835.400662-17-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE0:EE_|MN0PR12MB6056:EE_
X-MS-Office365-Filtering-Correlation-Id: 0be1ae25-3851-4dc2-3e2d-08dc50443732
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hsRQuXwijR9JtUHtibIgbnGxjeGZd/eENPi0IRKgKA13fq2bDiBFIxchmmBCwuYgyckJlsWcy8vcrw/4dHlgJ+1foO2oUAPKl65AwHE5zLM62FL+Ol9cz6C9f3RJWPcbXTbGywonF5/PnzdOHHueJtRGv/FDhCYhM79JOjBXl+Wd0I0vOUw0VAvgf772qp5LlTmTmeJ6agFJibdk35cZntGL0nWfHXRZpqbWhubCBqp0SL7EoIXl31aLnOZMxuRe1ub9NAmTv1T31VXpJv0BmZaCrSPbasTFgDEELopSJbKhtzG2kjOznmTvuy6x8/SmGbGgasiD67mRMOyL7qOrnWFYMpHqMZhpoJCGBSLCIFrM/8FXbX8bVC/MI3k2uBS6HvzG+UCiW6aYBkJTt1eTo3OUg+q7HENiKMdnSanzgi8WU7n0zeXaxsmmsGuy4q6E+Vvtmvfzeo8YRs6AR1wq0aJha3QiWCk2GIl9Pc2AteK8tjjTaobbyoR9lXDLgHmYoOdJu6P9nsbw5nZhRemtZARFOCUk62PEHcOK15C8pwQVs4mABACTLTxqpgFGtb4rzZ+R3GpgSypXdvZtgQLxwhjCix26yeFq8gdvOaHFv7pI2cu/L8mJUlRclzSlYzL//55YOENWNt0uDay9hQkwDsUQUYGAo/KGQRatu2z+XRjC/+n2IeKo9qHIM+ownha6X4nQiGYOfoIYoLJiDMM1EbkA+OBHy5q2t7wpTkbqwwW8S7VnJGBytl0kxVBg32V+
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(7416005)(1800799015)(82310400014);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:01:49.2555
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0be1ae25-3851-4dc2-3e2d-08dc50443732
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CE0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6056
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

From: Brijesh Singh <brijesh.singh@amd.com>

While resolving the RMP page fault, there may be cases where the page
level between the RMP entry and TDP does not match and the 2M RMP entry
must be split into 4K RMP entries. Or a 2M TDP page need to be broken
into multiple of 4K pages.

To keep the RMP and TDP page level in sync, zap the gfn range after
splitting the pages in the RMP entry. The zap should force the TDP to
gets rebuilt with the new page level.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu.h              | 2 --
 arch/x86/kvm/mmu/mmu.c          | 1 +
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a3f8eba8d8b6..49b294a8d917 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1950,6 +1950,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
+void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2c54ba5b0a28..89da37be241a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -253,8 +253,6 @@ static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
 	return __kvm_mmu_honors_guest_mtrrs(kvm_arch_has_noncoherent_dma(kvm));
 }
 
-void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
-
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0049d49aa913..c5af52e3f0c5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6772,6 +6772,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 
 	return need_tlb_flush;
 }
+EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
 
 static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 					   const struct kvm_memory_slot *slot)
-- 
2.25.1



