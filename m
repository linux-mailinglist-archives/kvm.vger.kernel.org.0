Return-Path: <kvm+bounces-13232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F06C68934E4
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 676471F245B1
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 734F316DED4;
	Sun, 31 Mar 2024 16:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nJd0FNpE"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731B816D4F4;
	Sun, 31 Mar 2024 16:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903589; cv=fail; b=KpVficgrUEN6D9AtCWmCVQN4Ewvmn+26iQ1v8RtHzyyJdrqA+zqcaLBI9/9j2c3gZB8WPBGxYSeeQy8r5UcxKFIQm8XEb3kASv6X+Nt/FFTqgQszdxeYcGpcapDHJKbwk7Y/Ygjsw0MFHQJXJGxMxFndpEto8tUGeOKDB5jKAOA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903589; c=relaxed/simple;
	bh=PUpbj09vNmmUqFYviZ/KkZpstLgfXlU76USNosOwveA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BMI9haTRgfSRmjtkIi8/GUL2Mi3wQPpkBcTeDUNyCxByrEEG2dE1Lhc4EclRbGhCqo2RsVhWw6xyp2KchhPW/oUbdsiO3JSy7Pq5pH6jgaiNZ8ROa1SOubv8lo0doi9+qXQo8V5onULTwHhR5ynYhjGItPaq1R3H/yFdejDW0qU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nJd0FNpE reason="signature verification failed"; arc=fail smtp.client-ip=40.107.244.79; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id ED4EC208E6;
	Sun, 31 Mar 2024 18:46:23 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aMQ-QBca_P6R; Sun, 31 Mar 2024 18:46:22 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 452ED208E9;
	Sun, 31 Mar 2024 18:46:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 452ED208E9
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 54DB4800056;
	Sun, 31 Mar 2024 18:40:20 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:20 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:18 +0000
X-sender: <kvm+bounces-13122-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
 NOTIFY=NEVER;
 X-ExtendedProps=BQBYABcARgAAAJuYHy0vkvxLoOu7fW2WcxdDTj1XZWJlciBNYXJ0aW4sT1U9VXNlcnMsT1U9TWlncmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAGwAAgAABQAMAAIAAA8ANgAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5EaXNwbGF5TmFtZQ8ADQAAAFdlYmVyLCBNYXJ0aW4FADwAAgAABQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUADgARAEAJ/dJgSQNPjrUVnMO/4HsFAAsAFwC+AAAAsylSdUnj6k+wvjsUej6W+0NOPURCMixDTj1EYXRhYmFzZXMsQ049RXhjaGFuZ2UgQWRtaW5pc3RyYXRpdmUgR3JvdXAgKEZZRElCT0hGMjNTUERMVCksQ049QWRtaW5pc3RyYXRpdmUgR3JvdXBzLENOPXNlY3VuZXQsQ049TWljcm9zb2Z0IEV4Y2hhbmdlLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQBHAAIAAAUARgAHAAMAAAAFAEMAAgAABQAWAAIAAAUAagAJAAEAAAAAAAAABQAUABEAm5gfLS+S/Eug67t9bZZzFwUAFQAWAAIAAAAPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAIwACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAmAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAs0mmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0LmNvbQUABgACAAEPACoAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LlJlc3VibWl0Q291bnQHAAEAAAAPAAkAAABDSUF1ZGl0ZWQCAAEFAAIABwABAAAABQADAAcAAAAAAAUABQACAAEFAGIACgAtAAAAzooAAAUAZAAPAAMAAABIdWIFACkAAgAB
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 19560
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=139.178.88.99; helo=sv.mirrors.kernel.org; envelope-from=kvm+bounces-13122-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com A06712087D
X-Original-To: kvm@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753357; cv=fail; b=CnD98z3ZUOwU0Tcy3RqD0gyAkrnN5b1ldo5eUMVKqh3pVgnDvfQI6IH+KphojYxG10zMt1H4SJEEb2Te+EYZ84P1SnQE4RfaG674qQHAHJ5FeIFS1Ma2Q/YgV7vdzB8kNO3HGyGnnhlVJG4XKDQ7KQRUm7ZAolOF6nyDOjfYfvs=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753357; c=relaxed/simple;
	bh=rzoYg6yb3vHZMJ/gAtL8sptVcyyDchJvZSk4qD76D20=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C5bs3yVBRgVwss9PNW+hlvly3s50zrB7ZRFQLCnJhuAnknQ+lF62B7Q+WyEm4KirYCxyBpWe/epX7dxWXiPB6hKcefqCpkDtUPz87qkSGl+bGzOQjH/0PUERWVejZfKnp2L/v/ozj8pLc1JLjnI02HdYREygL5prF0Ap/1xSsVs=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nJd0FNpE; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9nvo6eBhbgPjtPXu0xnnyp72TJQVHBGnW32Vu6+7UF0UWR/zZyprQngagSihfAvP2I8N6RcWN4pN70Vz2KAO6YAJOKJjIPmvJ6uQSRQbZvZj46KTaV7ZbGolbxjzp/ENiDpUgzqNSQf1t4izA2wzc8UeUoFsid4jVtdL+Cmz9DWgO+UqsfKRlX7KBjxxz/XFJvbQ+sBpPGjtUSmdcLzRqucC2o3cgiCQNU1WV7mBfUmJk62vCFAcr4fikUqcWc+Dtf2jjxpB1SZH6FmPbPpz6ECCiqsdT2e/OX1lxZ8ZWD3WV93N1Z5bRB49oQEFiPzX/pN1ah8xe3Jo8avVbpj1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cPtnxwXR3HxXghrg+jsGljcAyqyGp05CTmM/JTEbm7I=;
 b=oZpcG1Uby2hF4z2z1qQaLHMfTbngrNmuDJuv7xkLpKdakeMcAsg8GSMkp3PXhHM3ORBQgq/WqZ5te7vNMrGOZKQ4C+vTR/9VpHlG1cnRU7RdZE6stCA2+Eg0FtPb7Tv1khcCDv9CdW4TSZTwHQgrTfTthYHGWD5Slaq1D3y7qJnCwjCuBfwbfd2NNmFkJa8lL5h0z0NuC6EcsbhX7HG3ONpkKQLVdvRgiioN3c1fl+OLqmXpnzn2MTq/CKJXyK0vOD4D7aDmuUq47ZzNSJNyq5xxA7FixP/9VLIZQgnBBvqXKmyZnipjOpuFVeyyfamDW82JLQ6dkOshGU96nZtjCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPtnxwXR3HxXghrg+jsGljcAyqyGp05CTmM/JTEbm7I=;
 b=nJd0FNpEnmoA97VLtAdvvRqwcTXRWfdy+7PRqwaAVGJlwuFkZrcdnJDxxZ191fXLpsyrPoiNf1HMbgpNHcPufg4PgOVweDxr5AANGZzCPlwn/KLSdCqWG2qmz7rBOWY4ulCD5purB3bXLadtxdiYvDjRx1+akFPDXBEsGyF84LE=
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v12 18/29] KVM: SEV: Use a VMSA physical address variable for populating VMCB
Date: Fri, 29 Mar 2024 17:58:24 -0500
Message-ID: <20240329225835.400662-19-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|DS7PR12MB6263:EE_
X-MS-Office365-Filtering-Correlation-Id: 853ebb6e-eee5-48bc-cc52-08dc50445030
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nz5hZ8S6No72r/L6gB4kaz0Y4t1Mjv9U3hCzFnFjw6sxbokZNok2Hzy/whFWRlxCXUzBlb3oYXiE5XjoC40RNsNjRcJHayR1t/4p9Zedz9k/fmW1JZVuAyhjxlii4fMylNwOjZ/7vNXHSR3l2wsRPsXnulOOSgcqlypvoYo6IpQW4IByJfovYePzBMd8l7p+rfqzIuxCoCFP9F0EYNqaiM8x2yPz1jwxGAQKf7NZA9Y0BUfO65ArW6YLlGsSMtSqlZfZU8jXqGQ73tL8FgVDjE5avAR8U+ehPH/OOp5REFKmhiEGMYBdJYjJPPM2PqeJyrMSWwUazlY8khh1HRVKtIuvhiRDHYzqrhNEklqPdaAoz+LGq0n3TSE9gZdROvWlj+7VH7yurnT/bHZfTpUTDjira51pRviiRZydHHWqdZmiPiVMHniqJx03/uqyr72XjYYKgwiOC/2ykE0UpeOlURj2vLw5ABhgEWqIQQX0r6SJfdISGeehDTxJ+ET7XLVc1t3V8c5q5p+YxSt1J+aPE8zjEUqnpXsNH3zCioNXy/VYoCvBMTpVTTkDwOTPExnDdfq7wsMtizU/eRcCeMuRVu857AY+ZUcDuuReRY3rpKlS1VqfwStrZHba9ttjbxNPnP2ZLKG6ZbYMP/nMFRV3/nEVSZat8g+Iv9JZAEcdTl8t4B70UtlTCyAYO/Fvf2CBDgcadLlMDh+mkHcGckRuaE+VomcWWSrnoCQjZAu40o8vmTuZCUg3J56yCG/om+sG
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:02:31.1891
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 853ebb6e-eee5-48bc-cc52-08dc50445030
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6263
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

From: Tom Lendacky <thomas.lendacky@amd.com>

In preparation to support SEV-SNP AP Creation, use a variable that holds
the VMSA physical address rather than converting the virtual address.
This will allow SEV-SNP AP Creation to set the new physical address that
will be used should the vCPU reset path be taken.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 arch/x86/kvm/svm/svm.c | 9 ++++++++-
 arch/x86/kvm/svm/svm.h | 1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a0a88471f9ab..ce1c727bad23 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3780,8 +3780,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	 * the VMSA will be NULL if this vCPU is the destination for intrahost
 	 * migration, and will be copied later.
 	 */
-	if (svm->sev_es.vmsa)
-		svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
+	svm->vmcb->control.vmsa_pa = svm->sev_es.vmsa_pa;
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
 	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 648a05ca53fc..e036a8927717 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1451,9 +1451,16 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
-	if (vmsa_page)
+	if (vmsa_page) {
 		svm->sev_es.vmsa = page_address(vmsa_page);
 
+		/*
+		 * Do not include the encryption mask on the VMSA physical
+		 * address since hardware will access it using the guest key.
+		 */
+		svm->sev_es.vmsa_pa = __pa(svm->sev_es.vmsa);
+	}
+
 	svm->guest_state_loaded = false;
 
 	return 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c0675ff2d8a2..8cce3315b46c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -199,6 +199,7 @@ struct vcpu_sev_es_state {
 	struct ghcb *ghcb;
 	u8 valid_bitmap[16];
 	struct kvm_host_map ghcb_map;
+	hpa_t vmsa_pa;
 	bool received_first_sipi;
 	unsigned int ap_reset_hold_type;
 
-- 
2.25.1


X-sender: <linux-kernel+bounces-125498-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=rfc822;steffen.klassert@secunet.com
X-CreatedBy: MSExchange15
X-HeloDomain: mbx-dresden-01.secunet.de
X-ExtendedProps: BQBjAAoA5EmmlidQ3AgFADcAAgAADwA8AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50Lk9yZ2FuaXphdGlvblNjb3BlEQAAAAAAAAAAAAAAAAAAAAAADwA/AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLk1haWxEZWxpdmVyeVByaW9yaXR5DwADAAAATG93
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 10.53.40.199
X-EndOfInjectedXHeaders: 14736
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:03:09 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Sat, 30 Mar 2024 00:03:09 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 3678B20882
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:03:09 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -2.85
X-Spam-Level:
X-Spam-Status: No, score=-2.85 tagged_above=-999 required=2.1
	tests=[BAYES_00=-1.9, DKIMWL_WL_HIGH=-0.099, DKIM_SIGNED=0.1,
	DKIM_VALID=-0.1, DKIM_VALID_AU=-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=0.249, MAILING_LIST_MULTI=-1,
	RCVD_IN_DNSWL_NONE=-0.0001, SPF_HELO_NONE=0.001, SPF_PASS=-0.001]
	autolearn=unavailable autolearn_force=no
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=pass (1024-bit key) header.d=amd.com
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MEh_3f9EqTey for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:03:08 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.199.223; helo=ny.mirrors.kernel.org; envelope-from=linux-kernel+bounces-125498-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 7E07A2087D
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 7E07A2087D
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:03:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 499A51C20C16
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 772A913E890;
	Fri, 29 Mar 2024 23:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nJd0FNpE"
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC04913DDAC;
	Fri, 29 Mar 2024 23:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753357; cv=fail; b=CnD98z3ZUOwU0Tcy3RqD0gyAkrnN5b1ldo5eUMVKqh3pVgnDvfQI6IH+KphojYxG10zMt1H4SJEEb2Te+EYZ84P1SnQE4RfaG674qQHAHJ5FeIFS1Ma2Q/YgV7vdzB8kNO3HGyGnnhlVJG4XKDQ7KQRUm7ZAolOF6nyDOjfYfvs=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753357; c=relaxed/simple;
	bh=rzoYg6yb3vHZMJ/gAtL8sptVcyyDchJvZSk4qD76D20=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C5bs3yVBRgVwss9PNW+hlvly3s50zrB7ZRFQLCnJhuAnknQ+lF62B7Q+WyEm4KirYCxyBpWe/epX7dxWXiPB6hKcefqCpkDtUPz87qkSGl+bGzOQjH/0PUERWVejZfKnp2L/v/ozj8pLc1JLjnI02HdYREygL5prF0Ap/1xSsVs=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nJd0FNpE; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9nvo6eBhbgPjtPXu0xnnyp72TJQVHBGnW32Vu6+7UF0UWR/zZyprQngagSihfAvP2I8N6RcWN4pN70Vz2KAO6YAJOKJjIPmvJ6uQSRQbZvZj46KTaV7ZbGolbxjzp/ENiDpUgzqNSQf1t4izA2wzc8UeUoFsid4jVtdL+Cmz9DWgO+UqsfKRlX7KBjxxz/XFJvbQ+sBpPGjtUSmdcLzRqucC2o3cgiCQNU1WV7mBfUmJk62vCFAcr4fikUqcWc+Dtf2jjxpB1SZH6FmPbPpz6ECCiqsdT2e/OX1lxZ8ZWD3WV93N1Z5bRB49oQEFiPzX/pN1ah8xe3Jo8avVbpj1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cPtnxwXR3HxXghrg+jsGljcAyqyGp05CTmM/JTEbm7I=;
 b=oZpcG1Uby2hF4z2z1qQaLHMfTbngrNmuDJuv7xkLpKdakeMcAsg8GSMkp3PXhHM3ORBQgq/WqZ5te7vNMrGOZKQ4C+vTR/9VpHlG1cnRU7RdZE6stCA2+Eg0FtPb7Tv1khcCDv9CdW4TSZTwHQgrTfTthYHGWD5Slaq1D3y7qJnCwjCuBfwbfd2NNmFkJa8lL5h0z0NuC6EcsbhX7HG3ONpkKQLVdvRgiioN3c1fl+OLqmXpnzn2MTq/CKJXyK0vOD4D7aDmuUq47ZzNSJNyq5xxA7FixP/9VLIZQgnBBvqXKmyZnipjOpuFVeyyfamDW82JLQ6dkOshGU96nZtjCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPtnxwXR3HxXghrg+jsGljcAyqyGp05CTmM/JTEbm7I=;
 b=nJd0FNpEnmoA97VLtAdvvRqwcTXRWfdy+7PRqwaAVGJlwuFkZrcdnJDxxZ191fXLpsyrPoiNf1HMbgpNHcPufg4PgOVweDxr5AANGZzCPlwn/KLSdCqWG2qmz7rBOWY4ulCD5purB3bXLadtxdiYvDjRx1+akFPDXBEsGyF84LE=
Received: from BYAPR21CA0021.namprd21.prod.outlook.com (2603:10b6:a03:114::31)
 by DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 23:02:31 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:a03:114:cafe::4e) by BYAPR21CA0021.outlook.office365.com
 (2603:10b6:a03:114::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.8 via Frontend
 Transport; Fri, 29 Mar 2024 23:02:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:02:31 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:02:30 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v12 18/29] KVM: SEV: Use a VMSA physical address variable for populating VMCB
Date: Fri, 29 Mar 2024 17:58:24 -0500
Message-ID: <20240329225835.400662-19-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org
List-Id: <linux-kernel.vger.kernel.org>
List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|DS7PR12MB6263:EE_
X-MS-Office365-Filtering-Correlation-Id: 853ebb6e-eee5-48bc-cc52-08dc50445030
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nz5hZ8S6No72r/L6gB4kaz0Y4t1Mjv9U3hCzFnFjw6sxbokZNok2Hzy/whFWRlxCXUzBlb3oYXiE5XjoC40RNsNjRcJHayR1t/4p9Zedz9k/fmW1JZVuAyhjxlii4fMylNwOjZ/7vNXHSR3l2wsRPsXnulOOSgcqlypvoYo6IpQW4IByJfovYePzBMd8l7p+rfqzIuxCoCFP9F0EYNqaiM8x2yPz1jwxGAQKf7NZA9Y0BUfO65ArW6YLlGsSMtSqlZfZU8jXqGQ73tL8FgVDjE5avAR8U+ehPH/OOp5REFKmhiEGMYBdJYjJPPM2PqeJyrMSWwUazlY8khh1HRVKtIuvhiRDHYzqrhNEklqPdaAoz+LGq0n3TSE9gZdROvWlj+7VH7yurnT/bHZfTpUTDjira51pRviiRZydHHWqdZmiPiVMHniqJx03/uqyr72XjYYKgwiOC/2ykE0UpeOlURj2vLw5ABhgEWqIQQX0r6SJfdISGeehDTxJ+ET7XLVc1t3V8c5q5p+YxSt1J+aPE8zjEUqnpXsNH3zCioNXy/VYoCvBMTpVTTkDwOTPExnDdfq7wsMtizU/eRcCeMuRVu857AY+ZUcDuuReRY3rpKlS1VqfwStrZHba9ttjbxNPnP2ZLKG6ZbYMP/nMFRV3/nEVSZat8g+Iv9JZAEcdTl8t4B70UtlTCyAYO/Fvf2CBDgcadLlMDh+mkHcGckRuaE+VomcWWSrnoCQjZAu40o8vmTuZCUg3J56yCG/om+sG
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:02:31.1891
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 853ebb6e-eee5-48bc-cc52-08dc50445030
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6263
Return-Path: linux-kernel+bounces-125498-steffen.klassert=secunet.com@vger.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:03:09.2428
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 4c787faf-8036-465c-8fb4-08dc504466cc
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.secunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=cas-essen-01.secunet.de:TOTAL-FE=0.008|SMR=0.008(SMRPI=0.006(SMRPI-FrontendProxyAgent=0.006));2024-03-29T23:03:09.251Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-OriginalSize: 14189
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=Low
X-MS-Exchange-Organization-Prioritization: 2:ShadowRedundancy
X-MS-Exchange-Organization-IncludeInSla: False:ShadowRedundancy

From: Tom Lendacky <thomas.lendacky@amd.com>

In preparation to support SEV-SNP AP Creation, use a variable that holds
the VMSA physical address rather than converting the virtual address.
This will allow SEV-SNP AP Creation to set the new physical address that
will be used should the vCPU reset path be taken.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 arch/x86/kvm/svm/svm.c | 9 ++++++++-
 arch/x86/kvm/svm/svm.h | 1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a0a88471f9ab..ce1c727bad23 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3780,8 +3780,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	 * the VMSA will be NULL if this vCPU is the destination for intrahost
 	 * migration, and will be copied later.
 	 */
-	if (svm->sev_es.vmsa)
-		svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
+	svm->vmcb->control.vmsa_pa = svm->sev_es.vmsa_pa;
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
 	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 648a05ca53fc..e036a8927717 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1451,9 +1451,16 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
-	if (vmsa_page)
+	if (vmsa_page) {
 		svm->sev_es.vmsa = page_address(vmsa_page);
 
+		/*
+		 * Do not include the encryption mask on the VMSA physical
+		 * address since hardware will access it using the guest key.
+		 */
+		svm->sev_es.vmsa_pa = __pa(svm->sev_es.vmsa);
+	}
+
 	svm->guest_state_loaded = false;
 
 	return 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c0675ff2d8a2..8cce3315b46c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -199,6 +199,7 @@ struct vcpu_sev_es_state {
 	struct ghcb *ghcb;
 	u8 valid_bitmap[16];
 	struct kvm_host_map ghcb_map;
+	hpa_t vmsa_pa;
 	bool received_first_sipi;
 	unsigned int ap_reset_hold_type;
 
-- 
2.25.1



