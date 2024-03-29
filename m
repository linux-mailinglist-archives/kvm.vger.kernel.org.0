Return-Path: <kvm+bounces-13229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BC9E8934DA
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C02811C22704
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B489A16D9C2;
	Sun, 31 Mar 2024 16:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZW+f0SdB"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5B014E2D1;
	Sun, 31 Mar 2024 16:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903585; cv=fail; b=Asz9lPC5G6TdBotGlGZYZbd04gSrbTOUcVJDPLoVMRmE0WPY519B4ffHySkHSJVIuoGEMOme/z4kcdi2JjDOgWMFkG/OQ0C3CR38AnurfBeVB+M7a8AP4sGwh6EJERQsCbUuSHzk6o30jAT8MR/UXR6bnFHzyeT5+cJsPwZse0c=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903585; c=relaxed/simple;
	bh=PG3kV1LwVK0K2JBwamJWaWdHPUVAgEf8b91i9o6tB0A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a5ySAWDGO0q7btAjpmOAQ33sUaoa1HP932Oak/yGndSWbx8rmtWYXQFNbK/fASB+PQMZAHRolU5NtLCLP3hkrasbnFgb47qBCT98+AWPRfDwhntMrCbo5PVJavOI+e0aqlvyd9DPWm1XLMXJr/tGi4um1U5XjpgNagAt3pOFiBk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZW+f0SdB reason="signature verification failed"; arc=fail smtp.client-ip=40.107.96.41; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 80455208ED;
	Sun, 31 Mar 2024 18:46:20 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VZGyIn65lKIR; Sun, 31 Mar 2024 18:46:19 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 38ACC208E0;
	Sun, 31 Mar 2024 18:46:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 38ACC208E0
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 80ED380005C;
	Sun, 31 Mar 2024 18:40:29 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:29 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:18 +0000
X-sender: <kvm+bounces-13140-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
 NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAJuYHy0vkvxLoOu7fW2WcxcPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQALABcAvgAAALMpUnVJ4+pPsL47FHo+lvtDTj1EQjIsQ049RGF0YWJhc2VzLENOPUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpLENOPUFkbWluaXN0cmF0aXZlIEdyb3VwcyxDTj1zZWN1bmV0LENOPU1pY3Jvc29mdCBFeGNoYW5nZSxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAA4AEQBACf3SYEkDT461FZzDv+B7BQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUAPAACAAAPADYAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0Lk1haWxSZWNpcGllbnQuRGlzcGxheU5hbWUPAA0AAABXZWJlciwgTWFydGluBQAMAAIAAAUAbAACAAAFAFgAFwBGAAAAm5gfLS+S/Eug67t9bZZzF0NOPVdlYmVyIE1hcnRpbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoALEqmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBiAAoAZgAAAM6KAAAFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 23661
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.80.249; helo=am.mirrors.kernel.org; envelope-from=kvm+bounces-13140-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 35184200BB
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZW+f0SdB"
X-Original-To: kvm@vger.kernel.org
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
Content-Transfer-Encoding: 8bit
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

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index b463fcbd4b90..01261f7054ad 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -54,8 +54,10 @@
 	(((unsigned long)fn) << 32))
 
 /* AP Reset Hold */
-#define GHCB_MSR_AP_RESET_HOLD_REQ	0x006
-#define GHCB_MSR_AP_RESET_HOLD_RESP	0x007
+#define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
+#define GHCB_MSR_AP_RESET_HOLD_RESP		0x007
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 58019f1aefed..7f5faa0d4d4f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -49,6 +49,10 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+#define AP_RESET_HOLD_NONE		0
+#define AP_RESET_HOLD_NAE_EVENT		1
+#define AP_RESET_HOLD_MSR_PROTO		2
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2718,6 +2722,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->sev_es.ghcb)
 		return;
 
@@ -2929,6 +2936,22 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_AP_RESET_HOLD_REQ:
+		svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_MSR_PROTO;
+		ret = kvm_emulate_ap_reset_hold(&svm->vcpu);
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
 
@@ -3028,6 +3051,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NAE_EVENT;
 		ret = kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -3271,15 +3295,31 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		return;
 	}
 
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
 
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	default:
+		break;
+	}
 }
 
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
 
 	/* SEV-ES scratch area support */
 	u64 sw_scratch;
-- 
2.25.1


X-sender: <linux-crypto+bounces-3114-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=rfc822;steffen.klassert@secunet.com
X-CreatedBy: MSExchange15
X-HeloDomain: mbx-essen-01.secunet.de
X-ExtendedProps: BQBjAAoAMkqmlidQ3AgFADcAAgAADwA8AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50Lk9yZ2FuaXphdGlvblNjb3BlEQAAAAAAAAAAAAAAAAAAAAAADwA/AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLk1haWxEZWxpdmVyeVByaW9yaXR5DwADAAAATG93
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 10.53.40.197
X-EndOfInjectedXHeaders: 17170
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:09:28 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Sat, 30 Mar 2024 00:09:28 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 4A94720885
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:09:28 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -2.85
X-Spam-Level:
X-Spam-Status: No, score=-2.85 tagged_above=-999 required=2.1
	tests=[BAYES_00=-1.9, DKIMWL_WL_HIGH=-0.099, DKIM_SIGNED=0.1,
	DKIM_VALID=-0.1, DKIM_VALID_AU=-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=0.249, MAILING_LIST_MULTI=-1,
	RCVD_IN_DNSWL_NONE=-0.0001, SPF_HELO_NONE=0.001, SPF_PASS=-0.001]
	autolearn=ham autolearn_force=no
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=pass (1024-bit key) header.d=amd.com
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JrHynT0d2DEq for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:09:24 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.80.249; helo=am.mirrors.kernel.org; envelope-from=linux-crypto+bounces-3114-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 6D3BE20754
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 6D3BE20754
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:09:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 217E61F23B03
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF65D13E6B8;
	Fri, 29 Mar 2024 23:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZW+f0SdB"
X-Original-To: linux-crypto@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2041.outbound.protection.outlook.com [40.107.96.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDED4383A5;
	Fri, 29 Mar 2024 23:08:50 +0000 (UTC)
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
Received: from DS7PR03CA0306.namprd03.prod.outlook.com (2603:10b6:8:2b::14) by
 MN2PR12MB4376.namprd12.prod.outlook.com (2603:10b6:208:26c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 23:08:48 +0000
Received: from DS1PEPF00017090.namprd03.prod.outlook.com
 (2603:10b6:8:2b:cafe::a7) by DS7PR03CA0306.outlook.office365.com
 (2603:10b6:8:2b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Frontend
 Transport; Fri, 29 Mar 2024 23:08:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017090.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:08:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
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
Subject: [PATCH v12 07/29] KVM: SEV: Add support to handle AP reset MSR protocol
Date: Fri, 29 Mar 2024 17:58:13 -0500
Message-ID: <20240329225835.400662-8-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Return-Path: linux-crypto+bounces-3114-steffen.klassert=secunet.com@vger.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:09:28.3267
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 27d03283-cc44-4d4d-05de-08dc504548c0
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.secunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=cas-essen-01.secunet.de:TOTAL-FE=0.007|SMR=0.006(SMRPI=0.005(SMRPI-FrontendProxyAgent=0.005));2024-03-29T23:09:28.333Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-OriginalSize: 16625
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=Low
X-MS-Exchange-Organization-Prioritization: 2:ShadowRedundancy
X-MS-Exchange-Organization-IncludeInSla: False:ShadowRedundancy

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

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index b463fcbd4b90..01261f7054ad 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -54,8 +54,10 @@
 	(((unsigned long)fn) << 32))
 
 /* AP Reset Hold */
-#define GHCB_MSR_AP_RESET_HOLD_REQ	0x006
-#define GHCB_MSR_AP_RESET_HOLD_RESP	0x007
+#define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
+#define GHCB_MSR_AP_RESET_HOLD_RESP		0x007
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 58019f1aefed..7f5faa0d4d4f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -49,6 +49,10 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+#define AP_RESET_HOLD_NONE		0
+#define AP_RESET_HOLD_NAE_EVENT		1
+#define AP_RESET_HOLD_MSR_PROTO		2
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2718,6 +2722,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->sev_es.ghcb)
 		return;
 
@@ -2929,6 +2936,22 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_AP_RESET_HOLD_REQ:
+		svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_MSR_PROTO;
+		ret = kvm_emulate_ap_reset_hold(&svm->vcpu);
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
 
@@ -3028,6 +3051,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NAE_EVENT;
 		ret = kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -3271,15 +3295,31 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		return;
 	}
 
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
 
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	default:
+		break;
+	}
 }
 
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
 
 	/* SEV-ES scratch area support */
 	u64 sw_scratch;
-- 
2.25.1



