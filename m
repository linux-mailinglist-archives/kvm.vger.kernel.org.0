Return-Path: <kvm+bounces-13194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E150F893282
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0281A1C21C04
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A7EC14601B;
	Sun, 31 Mar 2024 16:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZW+f0SdB"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5582E145321;
	Sun, 31 Mar 2024 16:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711901243; cv=fail; b=qf/l4BiZYGP9VfT078mFk5Hbpvc5b4lx2CCb/BKsa2EjuN9SJ4Do1l4ZQfIwpWQSuSwb9TfqG2+a1ogJE0GuDH0DwqD5JkgpCowN+/IyVWU6e5ggnwIOza44Qvk2y+7JZ6+NbZ0OeNH5JzIbbuXMQmZ6cIXJsnmpI05gZfoIcN0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711901243; c=relaxed/simple;
	bh=gImMUUedcfTzVQJ4gk6MKGA+wGZKBnAOyz3cR2OXzqQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E2pxjLpkSDpGVGwS9xn40Nc6N00Bdo4ZQwuEM/uE4YJBq3L1dhQv6SnLOet8fuJwhy4ZGNcXiSa5ZbLrWU1RYiN850OA4XqI29YNQ8nSeSeSM32cfO+bk2d8jzIOZf/WaA5MfW71lSD6WZGTMchIIdVHUgtvoLZAhY0+065wsXU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZW+f0SdB reason="signature verification failed"; arc=fail smtp.client-ip=40.107.96.41; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id C1151208A3;
	Sun, 31 Mar 2024 18:07:18 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XGSHGD6xzKVu; Sun, 31 Mar 2024 18:07:17 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id F04D2208C3;
	Sun, 31 Mar 2024 18:07:15 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com F04D2208C3
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id A913F800056;
	Sun, 31 Mar 2024 18:02:13 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:02:13 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 15:52:42 +0000
X-sender: <linux-crypto+bounces-3114-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAPDFCS25BAlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAwAAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoApQ5rGbMv3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2VjdW5ldC5jb20FAAYAAgABBQApAAIAAQ8ACQAAAENJQXVkaXRlZAIAAQUAAgAHAAEAAAAFAAMABwAAAAAABQAFAAIAAQUAYgAKAFQAAADNigAABQBkAA8AAwAAAEh1Yg==
X-Source: SMTP:Default MBX-ESSEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 23644
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.80.249; helo=am.mirrors.kernel.org; envelope-from=linux-crypto+bounces-3114-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 6D3BE20754
X-Original-To: linux-crypto@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.41
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753732; cv=fail; b=HXA54uEOx4U08FcBDgSqvviREzi+lKBX5DCw5taE4ma20wzNKJJu7vjQpBwTp0kBvA/jRheHANkP95TFBZIlUrua016nxsm+Nf2b8pqaQsm6OLkBbjgchf1rIU8BITpabPTx5HKJm4E/3X9oj/JGOJTtBdZjU8ShX1AzSANnrNI=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753732; c=relaxed/simple;
	bh=UaLzkFPtN/SodI46VstA0k6umNe/4uzZNKK0L/0lUIU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TKyGgbNhJNyQyp9kf+hR7roRSnQoZPFgsdK1cZ4d3XD657plPZxBDxL+XedUtOl/EEvupxfjhHFL4lg5aHMewIgrBIshQCuqlYgICsNre+mbSsDhVL6QeZ2hbO8wrxWd3N7lNyFHmu428xmJJ4ghUC2HNWPGjsA4sQmYFni8uJo=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZW+f0SdB; arc=fail smtp.client-ip=40.107.96.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kd48xQGMs6l8Wsq/ZayS8rrd8yBNq8cYn0BTD+7MwJ/8IG0JWZZaW6J81LYGXNOcMVELtpNrQ4pHR3jtOrB3KDwskexHLqgV7y1IiN844W4yK65Yb1DqxUvX9egLQV45Fd+PlAdptUbrGFLo528XU034aj8HSMg2j2NkzRw+FN7EHJUddXlqc9tqxdH+UIRy0XGc5BxJWCFq19Fz6Pd5TrC7BS95+2FE7ap+6HdqihtZsgQcuCvW4q54Bf/4+nsa9Sw8fYnVkp9/9IAX1IvBSNPpdb1lzARhSANFCdj5vqYzTmW9pK6fRJ0g0JfUTg/knYRB+0rN0kxgyd0LB2B7qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1AFRG57mttmXjFWMb643ENWLHkROqQ93l3fHvqGJYHY=;
 b=kdf0Mf2kouGQ2I/dHZ0U7pwg8Il7DeU7Fb3gEClJ2DDCfVK9KrOZYvjHx8Le0H6jMlJhPZTPNDvTTOlXBV9K6qVcJ79cBe5zEQTdH4r+COtNbFojgqlb18wwJWpyPAs6kq1LJ/6uuCYkFFpn62LlgQCENvhT4jTf/Qq9JqqoLPhTHi9Tc/R9bRwzCo6j191isf0kxdDPI3+Db2kU/SVlTR4767Iz1s1wTsNcH5IRJ08UC0bIwb6Gmz+LU/3ooAtKy76yN2TlnE4VQSMcWC9OJ6HAdwMT4UeGxPQIEc1ImptmPovTUxBGwPb4Z1cUAlt1qzH5+Z0gS9TqLLfdbf62rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1AFRG57mttmXjFWMb643ENWLHkROqQ93l3fHvqGJYHY=;
 b=ZW+f0SdBfrs9YBGmZ5MqUaSyht+jf0ENPNv3aQaOP13tcTnzOGshXHEFp9o21MaFAQi9kU7xRzyr/hUKBIMZG01jlk5FRNosxV7RlNciOvlXZs4XprDBQq7/OdGO1qcB4BlR6qGfjUhkYACzDQxK3iPBImVa8/+ZvJsfAjx/ghQ=
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
Subject: [PATCH v12 07/29] KVM: SEV: Add support to handle AP reset MSR protocol
Date: Fri, 29 Mar 2024 17:58:13 -0500
Message-ID: <20240329225835.400662-8-michael.roth@amd.com>
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
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017090:EE_|MN2PR12MB4376:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c1abc47-f575-4af9-20dd-08dc504530f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0mKpJG/uxzEab6B4XKgJfwukxLY79REcLmwLNtuqi/H9D+NoBbniOtAVmYlSHlV0tv1bxPqaW/kJi2HIcj4OtvSXnSSbQF7GBum0G7En3satbbgeDaUBW9ocGCpyfIJ49+ThlYy6E8BAenA9zEwUAV+2VkcvhO6sOnICNMgECSTsDY9w3H0hkU5WRDJUhCzs1rxcP/DSKN6mCSy9DYUNHGPH8hx4p/E9fD2GVWV6KroyjEFXHjBwHzAYjUsUwvZT06zT06UYm2ctZZwFEGRvsue+bgC96l4HSaZeUzrQ7qtHNHlifi/r87lCFeX6mKjyjtD5hXo3cNR0pLqVtM3IZvz3Y+Zermqf1KD6J8LJbjKHp+hwaD5uXTJE4XEK3mQ272QTnZWJwSN3R7KtQKCy0/rylHCujemA9A5Q0QYFxLpNOkgOHvVr4Qu80RkfYmv7CS/a1wdVUbtbhAAvkASnzGijSJ7HTBbj+2dqBWzmqj8VjXqgZ415MOZmOc8ZTr3LkhSCScgGOtDDQdRrNeEYiGfaj2gIBdlOWDViWLmyZgC1oRgNf1Oh+tkzQB8fGXrcnsuDqNKAkjCsHWSWr8WYDjwg9k0SLwzwq7zPogMcIpCOE1vRO3jDrYlpcDXHMozyCIK1wgEwZ/mVMocE2M5rZ/oGh7U4Y6HVMrZWsHlpl3zeEtIiVcHEugb9AB8x/4T8IIYEOGEvFKulfOduYAEGjXS2GBFQKIQ+SzKQrHqvhVowbJ75CUzWo/OekDIGoEK0
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:08:48.2995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c1abc47-f575-4af9-20dd-08dc504530f0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017090.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4376
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
available in version 2 of the GHCB specification.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  6 ++--
 arch/x86/kvm/svm/sev.c            | 56 ++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h            |  1 +
 3 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-c=
ommon.h
index b463fcbd4b90..01261f7054ad 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -54,8 +54,10 @@
 	(((unsigned long)fn) << 32))
=20
 /* AP Reset Hold */
-#define GHCB_MSR_AP_RESET_HOLD_REQ	0x006
-#define GHCB_MSR_AP_RESET_HOLD_RESP	0x007
+#define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
+#define GHCB_MSR_AP_RESET_HOLD_RESP		0x007
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
=20
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 58019f1aefed..7f5faa0d4d4f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -49,6 +49,10 @@ static bool sev_es_debug_swap_enabled =3D true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
=20
+#define AP_RESET_HOLD_NONE		0
+#define AP_RESET_HOLD_NAE_EVENT		1
+#define AP_RESET_HOLD_MSR_PROTO		2
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2718,6 +2722,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *s=
vm)
=20
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->sev_es.ap_reset_hold_type =3D AP_RESET_HOLD_NONE;
+
 	if (!svm->sev_es.ghcb)
 		return;
=20
@@ -2929,6 +2936,22 @@ static int sev_handle_vmgexit_msr_protocol(struct vc=
pu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_AP_RESET_HOLD_REQ:
+		svm->sev_es.ap_reset_hold_type =3D AP_RESET_HOLD_MSR_PROTO;
+		ret =3D kvm_emulate_ap_reset_hold(&svm->vcpu);
+
+		/*
+		 * Preset the result to a non-SIPI return and then only set
+		 * the result to non-zero when delivering a SIPI.
+		 */
+		set_ghcb_msr_bits(svm, 0,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_MASK,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_POS);
+
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
=20
@@ -3028,6 +3051,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret =3D 1;
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->sev_es.ap_reset_hold_type =3D AP_RESET_HOLD_NAE_EVENT;
 		ret =3D kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -3271,15 +3295,31 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *=
vcpu, u8 vector)
 		return;
 	}
=20
-	/*
-	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
-	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
-	 * non-zero value.
-	 */
-	if (!svm->sev_es.ghcb)
-		return;
+	/* Subsequent SIPI */
+	switch (svm->sev_es.ap_reset_hold_type) {
+	case AP_RESET_HOLD_NAE_EVENT:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
+		 */
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		break;
+	case AP_RESET_HOLD_MSR_PROTO:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set GHCB data field to a non-zero value.
+		 */
+		set_ghcb_msr_bits(svm, 1,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_MASK,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_POS);
=20
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	default:
+		break;
+	}
 }
=20
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 717cc97f8f50..157eb3f65269 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -199,6 +199,7 @@ struct vcpu_sev_es_state {
 	u8 valid_bitmap[16];
 	struct kvm_host_map ghcb_map;
 	bool received_first_sipi;
+	unsigned int ap_reset_hold_type;
=20
 	/* SEV-ES scratch area support */
 	u64 sw_scratch;
--=20
2.25.1


X-sender: <linux-kernel+bounces-125521-steffen.klassert=3Dsecunet.com@vger.=
kernel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=3Drfc822;steffen.klassert@=
secunet.com NOTIFY=3DNEVER; X-ExtendedProps=3DBQAVABYAAgAAAAUAFAARAPDFCS25B=
AlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURh=
dGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQB=
HAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3=
VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4Y=
wUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5n=
ZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl=
2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ0=
49Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAH=
QAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5z=
cG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAw=
AAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbi=
xPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQ=
XV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8ALwAAAE1p=
Y3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmV=
yc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ=3D=3D
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoApQ5rGbMv3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2Vj=
dW5ldC5jb20FAAYAAgABBQApAAIAAQ8ACQAAAENJQXVkaXRlZAIAAQUAAgAHAAEAAAAFAAMABwA=
AAAAABQAFAAIAAQUAYgAKAFUAAADNigAABQBkAA8AAwAAAEh1Yg=3D=3D
X-Source: SMTP:Default MBX-ESSEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 23551
Received: from cas-essen-01.secunet.de (10.53.40.201) by
 mbx-essen-01.secunet.de (10.53.40.197) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 30 Mar 2024 00:09:40 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:09:40 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 0C2F920885
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:09:40 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -2.85
X-Spam-Level:
X-Spam-Status: No, score=3D-2.85 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.099, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_NONE=3D-0.0001, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dunavailable autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Damd.com
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qfZ0_23Ukn2Y for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:09:39 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.199.223; helo=3Dny.mirrors.kernel.org; envelope-from=3Dlinux-kern=
el+bounces-125521-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 399BB20754
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223=
])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 399BB20754
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09CBC1C21090
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62CFE13F456;
	Fri, 29 Mar 2024 23:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"ZW+f0SdB"
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02=
on2041.outbound.protection.outlook.com [40.107.96.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDED4383A5;
	Fri, 29 Mar 2024 23:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.96.41
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753732; cv=3Dfail; b=3DHXA54uEOx4U08FcBDgSqvviREzi+lKBX5DCw5taE4ma=
20wzNKJJu7vjQpBwTp0kBvA/jRheHANkP95TFBZIlUrua016nxsm+Nf2b8pqaQsm6OLkBbjgchf=
1rIU8BITpabPTx5HKJm4E/3X9oj/JGOJTtBdZjU8ShX1AzSANnrNI=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753732; c=3Drelaxed/simple;
	bh=3DUaLzkFPtN/SodI46VstA0k6umNe/4uzZNKK0L/0lUIU=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DTKyGgbNhJNyQyp9kf+hR7roRSnQoZPFgsdK1cZ4d3X=
D657plPZxBDxL+XedUtOl/EEvupxfjhHFL4lg5aHMewIgrBIshQCuqlYgICsNre+mbSsDhVL6Qe=
Z2hbO8wrxWd3N7lNyFHmu428xmJJ4ghUC2HNWPGjsA4sQmYFni8uJo=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3DZW+f0SdB; arc=3Dfail smtp.client-ip=3D40.107.96.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DKd48xQGMs6l8Wsq/ZayS8rrd8yBNq8cYn0BTD+7MwJ/8IG0JWZZaW6J81LYGXNOcMVELtp=
NrQ4pHR3jtOrB3KDwskexHLqgV7y1IiN844W4yK65Yb1DqxUvX9egLQV45Fd+PlAdptUbrGFLo5=
28XU034aj8HSMg2j2NkzRw+FN7EHJUddXlqc9tqxdH+UIRy0XGc5BxJWCFq19Fz6Pd5TrC7BS95=
+2FE7ap+6HdqihtZsgQcuCvW4q54Bf/4+nsa9Sw8fYnVkp9/9IAX1IvBSNPpdb1lzARhSANFCdj=
5vqYzTmW9pK6fRJ0g0JfUTg/knYRB+0rN0kxgyd0LB2B7qQ=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3D1AFRG57mttmXjFWMb643ENWLHkROqQ93l3fHvqGJYHY=3D;
 b=3Dkdf0Mf2kouGQ2I/dHZ0U7pwg8Il7DeU7Fb3gEClJ2DDCfVK9KrOZYvjHx8Le0H6jMlJhPZ=
TPNDvTTOlXBV9K6qVcJ79cBe5zEQTdH4r+COtNbFojgqlb18wwJWpyPAs6kq1LJ/6uuCYkFFpn6=
2LlgQCENvhT4jTf/Qq9JqqoLPhTHi9Tc/R9bRwzCo6j191isf0kxdDPI3+Db2kU/SVlTR4767Iz=
1s1wTsNcH5IRJ08UC0bIwb6Gmz+LU/3ooAtKy76yN2TlnE4VQSMcWC9OJ6HAdwMT4UeGxPQIEc1=
ImptmPovTUxBGwPb4Z1cUAlt1qzH5+Z0gS9TqLLfdbf62rA=3D=3D
ARC-Authentication-Results: i=3D1; mx.microsoft.com 1; spf=3Dpass (sender i=
p is
 165.204.84.17) smtp.rcpttodomain=3Dvger.kernel.org smtp.mailfrom=3Damd.com=
;
 dmarc=3Dpass (p=3Dquarantine sp=3Dquarantine pct=3D100) action=3Dnone
 header.from=3Damd.com; dkim=3Dnone (message not signed); arc=3Dnone (0)
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Damd.com; s=
=3Dselector1;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-S=
enderADCheck;
 bh=3D1AFRG57mttmXjFWMb643ENWLHkROqQ93l3fHvqGJYHY=3D;
 b=3DZW+f0SdBfrs9YBGmZ5MqUaSyht+jf0ENPNv3aQaOP13tcTnzOGshXHEFp9o21MaFAQi9kU=
7xRzyr/hUKBIMZG01jlk5FRNosxV7RlNciOvlXZs4XprDBQq7/OdGO1qcB4BlR6qGfjUhkYACzD=
QxK3iPBImVa8/+ZvJsfAjx/ghQ=3D
Received: from DS7PR03CA0306.namprd03.prod.outlook.com (2603:10b6:8:2b::14)=
 by
 MN2PR12MB4376.namprd12.prod.outlook.com (2603:10b6:208:26c::16) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 =
Mar
 2024 23:08:48 +0000
Received: from DS1PEPF00017090.namprd03.prod.outlook.com
 (2603:10b6:8:2b:cafe::a7) by DS7PR03CA0306.outlook.office365.com
 (2603:10b6:8:2b::14) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Front=
end
 Transport; Fri, 29 Mar 2024 23:08:48 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017090.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:08:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:08:47 -0500
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
Subject: [PATCH v12 07/29] KVM: SEV: Add support to handle AP reset MSR pro=
tocol
Date: Fri, 29 Mar 2024 17:58:13 -0500
Message-ID: <20240329225835.400662-8-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017090:EE_|MN2PR12MB4376:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c1abc47-f575-4af9-20dd-08dc504530=
f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0mKpJG/uxzEab6B4XKgJfwukxLY79REcLmwLNtuq=
i/H9D+NoBbniOtAVmYlSHlV0tv1bxPqaW/kJi2HIcj4OtvSXnSSbQF7GBum0G7En3satbbgeDaU=
BW9ocGCpyfIJ49+ThlYy6E8BAenA9zEwUAV+2VkcvhO6sOnICNMgECSTsDY9w3H0hkU5WRDJUhC=
zs1rxcP/DSKN6mCSy9DYUNHGPH8hx4p/E9fD2GVWV6KroyjEFXHjBwHzAYjUsUwvZT06zT06UYm=
2ctZZwFEGRvsue+bgC96l4HSaZeUzrQ7qtHNHlifi/r87lCFeX6mKjyjtD5hXo3cNR0pLqVtM3I=
Zvz3Y+Zermqf1KD6J8LJbjKHp+hwaD5uXTJE4XEK3mQ272QTnZWJwSN3R7KtQKCy0/rylHCujem=
A9A5Q0QYFxLpNOkgOHvVr4Qu80RkfYmv7CS/a1wdVUbtbhAAvkASnzGijSJ7HTBbj+2dqBWzmqj=
8VjXqgZ415MOZmOc8ZTr3LkhSCScgGOtDDQdRrNeEYiGfaj2gIBdlOWDViWLmyZgC1oRgNf1Oh+=
tkzQB8fGXrcnsuDqNKAkjCsHWSWr8WYDjwg9k0SLwzwq7zPogMcIpCOE1vRO3jDrYlpcDXHMozy=
CIK1wgEwZ/mVMocE2M5rZ/oGh7U4Y6HVMrZWsHlpl3zeEtIiVcHEugb9AB8x/4T8IIYEOGEvFKu=
lfOduYAEGjXS2GBFQKIQ+SzKQrHqvhVowbJ75CUzWo/OekDIGoEK0
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(82310400014)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:08:48.2995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c1abc47-f575-4af9-20dd-08dc5=
04530f0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017090.namprd03.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4376
Return-Path: linux-kernel+bounces-125521-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:09:40.0731
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: fe8c8051-c467-4c11-8993-08dc=
50454fc0
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-01.secunet.de:TOTAL-HUB=3D0.404|SMR=3D0.341(SMRDE=3D0.006|SMRC=3D0.334(=
SMRCL=3D0.103|X-SMRCR=3D0.334))|CAT=3D0.062(CATRESL=3D0.026
 (CATRESLP2R=3D0.019)|CATORES=3D0.034(CATRS=3D0.034(CATRS-Index Routing
 Agent=3D0.032)));2024-03-29T23:09:40.503Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 16594
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-01.secunet.de:TO=
TAL-FE=3D26.000|SMR=3D0.025(SMRPI=3D0.022(SMRPI-FrontendProxyAgent=3D0.022)=
)
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-01
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAT4KAAAPAAADH4sIAAAAAAAEANVYC2/b=
yBFe6mkplhO7SZ
 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
 JzaW9uPg0KICA8RW1haWxzPg0KICAgIDxFbWFpbCBTdGFydEluZGV4
 PSIyMCI+DQogICAgICA8RW1haWxTdHJpbmc+dGhvbWFzLmxlbmRhY2
 t5QGFtZC5jb208L0VtYWlsU3RyaW5nPg0KICAgIDwvRW1haWw+DQog
 ICAgPEVtYWlsIFN0YXJ0SW5kZXg9IjI2MCIgUG9zaXRpb249Ik90aG
 VyIj4NCiAgICAgIDxFbWFpbFN0cmluZz5icmlqZXNoLnNpbmdoQGFt
 ZC5jb208L0VtYWlsU3RyaW5nPg0KICAgIDwvRW1haWw+DQogICAgPE
 VtYWlsIFN0YXJ0SW5kZXg9IjMxMyIgUG9zaXRpb249Ik90aGVyIj4N
 CiAgICAgIDxFbWFpbFN0cmluZz5hc2hpc2gua2FscmFAYW1kLmNvbT
 wvRW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD4NCiAgICA8RW1haWwg
 U3RhcnRJbmRleD0iMzY1IiBQb3NpdGlvbj0iT3RoZXIiPg0KICAgIC
 AgPEVtYWlsU3RyaW5nPm1pY2hhZWwucm90aEBhbWQuY29tPC9FbWFp
 bFN0cmluZz4NCiAgICA8L0VtYWlsPg0KICA8L0VtYWlscz4NCjwvRW
 1haWxTZXQ+AQzyAzw/eG1sIHZlcnNpb249IjEuMCIgZW5jb2Rpbmc9
 InV0Zi0xNiI/Pg0KPENvbnRhY3RTZXQ+DQogIDxWZXJzaW9uPjE1Lj
 AuMC4wPC9WZXJzaW9uPg0KICA8Q29udGFjdHM+DQogICAgPENvbnRh
 Y3QgU3RhcnRJbmRleD0iNiI+DQogICAgICA8UGVyc29uIFN0YXJ0SW
 5kZXg9IjYiPg0KICAgICAgICA8UGVyc29uU3RyaW5nPlRvbSBMZW5k
 YWNreTwvUGVyc29uU3RyaW5nPg0KICAgICAgPC9QZXJzb24+DQogIC
 AgICA8RW1haWxzPg0KICAgICAgICA8RW1haWwgU3RhcnRJbmRleD0i
 MjAiPg0KICAgICAgICAgIDxFbWFpbFN0cmluZz50aG9tYXMubGVuZG
 Fja3lAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAgICAgIDwvRW1h
 aWw+DQogICAgICA8L0VtYWlscz4NCiAgICAgIDxDb250YWN0U3RyaW
 5nPlRvbSBMZW5kYWNreSAmbHQ7dGhvbWFzLmxlbmRhY2t5QGFtZC5j
 b208L0NvbnRhY3RTdHJpbmc+DQogICAgPC9Db250YWN0Pg0KICA8L0
 NvbnRhY3RzPg0KPC9Db250YWN0U2V0PgEOzwFSZXRyaWV2ZXJPcGVy
 YXRvciwxMCwxO1JldHJpZXZlck9wZXJhdG9yLDExLDI7UG9zdERvY1
 BhcnNlck9wZXJhdG9yLDEwLDE7UG9zdERvY1BhcnNlck9wZXJhdG9y
 LDExLDA7UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLD
 EwLDU7UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLDEx
 LDA7VHJhbnNwb3J0V3JpdGVyUHJvZHVjZXIsMjAsMTI=3D
X-MS-Exchange-Forest-IndexAgent: 1 3920
X-MS-Exchange-Forest-EmailMessageHash: 12DDD32C
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
available in version 2 of the GHCB specification.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  6 ++--
 arch/x86/kvm/svm/sev.c            | 56 ++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h            |  1 +
 3 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-c=
ommon.h
index b463fcbd4b90..01261f7054ad 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -54,8 +54,10 @@
 	(((unsigned long)fn) << 32))
=20
 /* AP Reset Hold */
-#define GHCB_MSR_AP_RESET_HOLD_REQ	0x006
-#define GHCB_MSR_AP_RESET_HOLD_RESP	0x007
+#define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
+#define GHCB_MSR_AP_RESET_HOLD_RESP		0x007
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
=20
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 58019f1aefed..7f5faa0d4d4f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -49,6 +49,10 @@ static bool sev_es_debug_swap_enabled =3D true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
=20
+#define AP_RESET_HOLD_NONE		0
+#define AP_RESET_HOLD_NAE_EVENT		1
+#define AP_RESET_HOLD_MSR_PROTO		2
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2718,6 +2722,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *s=
vm)
=20
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->sev_es.ap_reset_hold_type =3D AP_RESET_HOLD_NONE;
+
 	if (!svm->sev_es.ghcb)
 		return;
=20
@@ -2929,6 +2936,22 @@ static int sev_handle_vmgexit_msr_protocol(struct vc=
pu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_AP_RESET_HOLD_REQ:
+		svm->sev_es.ap_reset_hold_type =3D AP_RESET_HOLD_MSR_PROTO;
+		ret =3D kvm_emulate_ap_reset_hold(&svm->vcpu);
+
+		/*
+		 * Preset the result to a non-SIPI return and then only set
+		 * the result to non-zero when delivering a SIPI.
+		 */
+		set_ghcb_msr_bits(svm, 0,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_MASK,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_POS);
+
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
=20
@@ -3028,6 +3051,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret =3D 1;
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->sev_es.ap_reset_hold_type =3D AP_RESET_HOLD_NAE_EVENT;
 		ret =3D kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -3271,15 +3295,31 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *=
vcpu, u8 vector)
 		return;
 	}
=20
-	/*
-	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
-	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
-	 * non-zero value.
-	 */
-	if (!svm->sev_es.ghcb)
-		return;
+	/* Subsequent SIPI */
+	switch (svm->sev_es.ap_reset_hold_type) {
+	case AP_RESET_HOLD_NAE_EVENT:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
+		 */
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		break;
+	case AP_RESET_HOLD_MSR_PROTO:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set GHCB data field to a non-zero value.
+		 */
+		set_ghcb_msr_bits(svm, 1,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_MASK,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_POS);
=20
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	default:
+		break;
+	}
 }
=20
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 717cc97f8f50..157eb3f65269 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -199,6 +199,7 @@ struct vcpu_sev_es_state {
 	u8 valid_bitmap[16];
 	struct kvm_host_map ghcb_map;
 	bool received_first_sipi;
+	unsigned int ap_reset_hold_type;
=20
 	/* SEV-ES scratch area support */
 	u64 sw_scratch;
--=20
2.25.1




