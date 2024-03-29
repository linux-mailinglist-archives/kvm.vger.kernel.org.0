Return-Path: <kvm+bounces-13246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A1F5893511
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62C561F23A44
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30328170A4B;
	Sun, 31 Mar 2024 16:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xnn0YoyP"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5301F16F83C;
	Sun, 31 Mar 2024 16:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903652; cv=fail; b=jCGPaBe/4Kt2IDORZfx4H0soUXY/fExBVYIWYJaCUpbHvluiEXDqsLWI8Dc47KtGhShnB0SNYnCtcMxwu26FuMMN7Pw/6Gg1yOahT9o+iPXjCAovT3EptroDzL4z6VqcmBC4145qR+p6SSBzNeBGOE2ta3iRyhsvZfllkY0E1Yw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903652; c=relaxed/simple;
	bh=joSRWTNb+VHccO3iXds/SG6TVzpEfuyfywKJW+Wcs6c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MjY+ab9tgL/jeQQbNtnb/kU9ay1zLKhDZmUUUsywu08vPaE4ATubzwoDWByOW1DUukp5spO5e8uFcdttVM8HP5kbceprWTB1WHGb1LTk+VTsLclvgdDEU4ktZxfc/UAN0Mm8fB9PrOmfCcBMUI0gqND0hnBN+1WkC5CSZIY7ZU4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xnn0YoyP reason="signature verification failed"; arc=fail smtp.client-ip=40.107.220.62; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id B2F562084A;
	Sun, 31 Mar 2024 18:47:24 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e6s9DfkYvMCh; Sun, 31 Mar 2024 18:47:21 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 2345F207FD;
	Sun, 31 Mar 2024 18:47:16 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 2345F207FD
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id CB99C800056;
	Sun, 31 Mar 2024 18:40:19 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:19 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:18 +0000
X-sender: <linux-crypto+bounces-3090-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAPDFCS25BAlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAwAAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAm0mmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2VjdW5ldC5jb20FAAYAAgABBQApAAIAAQ8ACQAAAENJQXVkaXRlZAIAAQUAAgAHAAEAAAAFAAMABwAAAAAABQAFAAIAAQUAYgAKABUAAADOigAABQBkAA8AAwAAAEh1Yg==
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 31370
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.80.249; helo=am.mirrors.kernel.org; envelope-from=linux-crypto+bounces-3090-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com D3F682087B
X-Original-To: linux-crypto@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.62
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753230; cv=fail; b=uZhgEsPvzM/O5hYoPvgVIjlWXaSncWu/gH+CMWkulPd23+p3QPC07Xcnvdc1pEegop+1fw5FWQt9xrKIhggwnnc/cJxhZmvY+efDK8zTDVGgPMZ1OBnPCJ1svuKjpe/xapUf2zfGgrB87DdADrHQzinKcE/FLI1mCdSAohMJ7OM=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753230; c=relaxed/simple;
	bh=q4vzPdo0+oii9a1ZolELIlylzfsIrazGRpbjD/k5aUY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ko9KEZg3yLMXSxkN960Y/B2POJkn5tv0c1SE4wQqMBJNeTCF+VtC3I5Rs/cG3vbuvj3mVK5BMvEK9Yegm31H3BjyyNl7K1T0LCemXg4usQSAgVIu4IbicWvb3FBKu3DMFE8ZSoRJpC6bFHCBONslTx3MM6W14Bvvg8XrK8Um0Lw=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xnn0YoyP; arc=fail smtp.client-ip=40.107.220.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koAhSHTroS7Six8Mk2ptjimEuKhzjh+UOZ0BKjgCc81mT+BeIOoN5WsMBdVaZUUy0R+PvNTm4fC8i+uwFGBJV8NQMJkhjHeFNHs9v7dqfn1NGIFcfGChcbS/FPOvmOVVYpB/pw5U7oG2gLnAwxc20CK7NLojtWh4NCJ6M9OY8OY2nW344YP5M7kPGqBhcAq4W9kwvwslxNGFFGDAer3lswUX447A9LE0/fnMv5jbJ83rm5ix4N0K58GDPEx9VUGhhOgggVbAfXgKVio1kRzvNH8kJtZzXieWO/wEifcUb+WRXxN3ZBE88A4zgVuKZm7/Oqe/HvOr/XrFZWS7gVA25Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrYjCWIu6wNf/NkduP5S/uOo7LBR9vnyryH5vZHAlfA=;
 b=LVmfJFAum0chfh8MZAu/WI+/8Q1sh2O9o7TULA0rPfys5d3XWI3rdAqs/rYpjoaI+XLbCnHEgvanj9y++g3Pa/6WeAuyuUZZP+r2ZuuqLZc6edOigte0P3F00JsEgpwhi4L//QOMpICtIepUxvGLpwvRyID4b85yTfLiPEsYzfzxDzMtwa6xyDWidl6wddXopfSMfQOn4cp+NLLaX0CGH64ADEMNjDgJRUx5k4b/vRjK7TOLrW1vnz5Ty62s6kgRDA13YMF0niFXxzCeK2SekIWp/623ludL5H2O+JvT+5Bk3UU6+HQWzVWe4SzWyVmdcw+PiS9jlTsjHpiAmnR1Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JrYjCWIu6wNf/NkduP5S/uOo7LBR9vnyryH5vZHAlfA=;
 b=Xnn0YoyPydUttY9jZm4o1iMO+E8KBjfMOPusb4Vj5axJk8hQRG/osW1QECRxvBowisK2iaRPpIm14+OOzYXxmMPkAt9nxcFBlrEsW8iRuNHSFxG83FlEnCf0xJ4+jqhhyl6Gtqjia8oulEv9c2cH+koDudTK+LTVXbryYxTNGZM=
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
	<brijesh.singh@amd.com>, Harald Hoyer <harald@profian.com>
Subject: [PATCH v12 12/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
Date: Fri, 29 Mar 2024 17:58:18 -0500
Message-ID: <20240329225835.400662-13-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE2:EE_|DS0PR12MB8197:EE_
X-MS-Office365-Filtering-Correlation-Id: 640e01f2-0a92-4152-816e-08dc50440591
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: maS+wkIOrEV5dsQi+1Ucl7Dek3wbv2EkPTvamXV0iSrN3blKHKdzKy2sIgDkiuuCucCw1OYKPEXgE5LMW8sdaz4286tIVkN+6PYuPsOVvp7iv1rneuIp9shRSXhmHDARnXxJmXnr0iJa+9y2ATf3fTJJo5La1aeAucorCGMUeZYKun+1WQUJA1HQ3EOcWxwO84rEOPNsqnSbmycdcDtS590W5Ec83CUA4agPDbAh4zj2CzuSejnH/9AfsThwsQHoNe6C0wP3YOSooNdigv7LS1g8Gv/K22w1hhc+2MjW7fKBuX9EGyBoPr2TiquiVGKTnfSA5CUdNUY8ebM82UWYw4VCzSjz8oNq06u7n8KmAJsEuQ+xDxDZ9+8UlUNuQmxbCqDLfOyyZTLQjuhoDsTsM7dZuGpqkAcvYHMMabFFq/mztOspe6IHwNWZuktMUfkhQT7jfXyNaEZMCch7qF1cFC/up6WcdI0HYTFJ1UW7LBjeIob+EJ9kPY8h7Mga93hhX3a55AynoannyjJkB/w916AFKVrRl53kdOW6ZUE+bCya4N3zsIQugolgebJDaVz3Zpt1Fdmee3h+45NUEoPhjIZIHrNfM8rK95aSy6fqixSHZ+oWPMkaTbYOYHhxpFXjMNlLe99ies3YgJ497umzrqGnQvGumS2jFNXz7xNkuKy2goBVtLNt3XHkMtD/fCYNc3oZE47i9tYjl+Soj5sN/JHUGL8jIuyLlq4kRQ30VQqSLpzThuTSB+XGQ31m+C8/
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(82310400014)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:00:25.9312
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 640e01f2-0a92-4152-816e-08dc50440591
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CE2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8197
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

Add a KVM_SEV_SNP_LAUNCH_FINISH command to finalize the cryptographic
launch digest and stores it as the measurement of the guest at launch
time. Also extend the existing SNP firmware data structures to support
enforcing the use of Version Loaded Endorsement Keys by guests as part
of this command.

While finalizing the launch flow, it also issues the LAUNCH_UPDATE SNP
firmware commands to encrypt/measure the initial VMSA pages for each
configured vCPU. This involves setting the RMP entries for those pages
to provide, so also add handling to clean up the RMP entries for these
pages whening free'ing vCPUs.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Harald Hoyer <harald@profian.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: always measure BSP first to get consistent launch measurements]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  26 ++++
 arch/x86/include/uapi/asm/kvm.h               |  15 ++
 arch/x86/kvm/svm/sev.c                        | 137 ++++++++++++++++++
 include/linux/psp-sev.h                       |   4 +-
 4 files changed, 181 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documen=
tation/virt/kvm/x86/amd-memory-encryption.rst
index 4268aa5c380e..a49e8cff9133 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -517,6 +517,32 @@ where the allowed values for page_type are #define'd a=
s::
 See the SEV-SNP spec [snp-fw-abi]_ for further details on how each page ty=
pe is
 used/measured.
=20
+20. KVM_SEV_SNP_LAUNCH_FINISH
+-----------------------------
+
+After completion of the SNP guest launch flow, the KVM_SEV_SNP_LAUNCH_FINI=
SH
+command can be issued to make the guest ready for execution.
+
+Parameters (in): struct kvm_sev_snp_launch_finish
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_finish {
+                __u64 id_block_uaddr;
+                __u64 id_auth_uaddr;
+                __u8 id_block_en;
+                __u8 auth_key_en;
+                __u8 vlek_required;
+                __u8 host_data[32];
+                __u8 pad[6];
+        };
+
+
+See SEV-SNP specification [snp-fw-abi]_ for SNP_LAUNCH_FINISH further deta=
ils
+on launch finish input parameters.
+
 Device attribute API
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 956eb548c08e..2b08fcbe039a 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -696,6 +696,7 @@ enum sev_cmd_id {
 	/* SNP-specific commands */
 	KVM_SEV_SNP_LAUNCH_START,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
=20
 	KVM_SEV_NR_MAX,
 };
@@ -841,6 +842,20 @@ struct kvm_sev_snp_launch_update {
 	__u8 type;
 };
=20
+#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
+#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
+#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
+
+struct kvm_sev_snp_launch_finish {
+	__u64 id_block_uaddr;
+	__u64 id_auth_uaddr;
+	__u8 id_block_en;
+	__u8 auth_key_en;
+	__u8 vlek_required;
+	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
+	__u8 pad[6];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
=20
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a8a8a285b4a4..3d6c030091c2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -63,6 +63,8 @@ static u64 sev_supported_vmsa_features;
 #define SNP_POLICY_MASK_SMT		BIT_ULL(16)
 #define SNP_POLICY_MASK_SINGLE_SOCKET	BIT_ULL(20)
=20
+#define INITIAL_VMSA_GPA 0xFFFFFFFFF000
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2283,6 +2285,125 @@ static int snp_launch_update(struct kvm *kvm, struc=
t kvm_sev_cmd *argp)
 	return ret;
 }
=20
+static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *arg=
p)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_update data =3D {};
+	bool boot_vcpu_handled =3D false;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	int ret;
+
+	data.gctx_paddr =3D __psp_pa(sev->snp_context);
+	data.page_type =3D SNP_PAGE_TYPE_VMSA;
+
+handle_remaining_vcpus:
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vcpu_svm *svm =3D to_svm(vcpu);
+		u64 pfn =3D __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+
+		/* Handle boot vCPU first to ensure consistent measurement of initial st=
ate. */
+		if (!boot_vcpu_handled && vcpu->vcpu_id !=3D 0)
+			continue;
+
+		if (boot_vcpu_handled && vcpu->vcpu_id =3D=3D 0)
+			continue;
+
+		/* Perform some pre-encryption checks against the VMSA */
+		ret =3D sev_es_sync_vmsa(svm);
+		if (ret)
+			return ret;
+
+		/* Transition the VMSA page to a firmware state. */
+		ret =3D rmp_make_private(pfn, INITIAL_VMSA_GPA, PG_LEVEL_4K, sev->asid, =
true);
+		if (ret)
+			return ret;
+
+		/* Issue the SNP command to encrypt the VMSA */
+		data.address =3D __sme_pa(svm->sev_es.vmsa);
+		ret =3D __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+				      &data, &argp->error);
+		if (ret) {
+			snp_page_reclaim(pfn);
+			return ret;
+		}
+
+		svm->vcpu.arch.guest_state_protected =3D true;
+
+		if (!boot_vcpu_handled) {
+			boot_vcpu_handled =3D true;
+			goto handle_remaining_vcpus;
+		}
+	}
+
+	return 0;
+}
+
+static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_snp_launch_finish params;
+	struct sev_data_snp_launch_finish *data;
+	void *id_block =3D NULL, *id_auth =3D NULL;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	/* Measure all vCPUs using LAUNCH_UPDATE before finalizing the launch flo=
w. */
+	ret =3D snp_launch_update_vmsa(kvm, argp);
+	if (ret)
+		return ret;
+
+	data =3D kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	if (params.id_block_en) {
+		id_block =3D psp_copy_user_blob(params.id_block_uaddr, KVM_SEV_SNP_ID_BL=
OCK_SIZE);
+		if (IS_ERR(id_block)) {
+			ret =3D PTR_ERR(id_block);
+			goto e_free;
+		}
+
+		data->id_block_en =3D 1;
+		data->id_block_paddr =3D __sme_pa(id_block);
+
+		id_auth =3D psp_copy_user_blob(params.id_auth_uaddr, KVM_SEV_SNP_ID_AUTH=
_SIZE);
+		if (IS_ERR(id_auth)) {
+			ret =3D PTR_ERR(id_auth);
+			goto e_free_id_block;
+		}
+
+		data->id_auth_paddr =3D __sme_pa(id_auth);
+
+		if (params.auth_key_en)
+			data->auth_key_en =3D 1;
+	}
+
+	data->vcek_disabled =3D params.vlek_required;
+
+	memcpy(data->host_data, params.host_data, KVM_SEV_SNP_FINISH_DATA_SIZE);
+	data->gctx_paddr =3D __psp_pa(sev->snp_context);
+	ret =3D sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->error)=
;
+
+	kfree(id_auth);
+
+e_free_id_block:
+	kfree(id_block);
+
+e_free:
+	kfree(data);
+
+	return ret;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2376,6 +2497,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *a=
rgp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r =3D snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_FINISH:
+		r =3D snp_launch_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r =3D -EINVAL;
 		goto out;
@@ -2866,11 +2990,24 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
=20
 	svm =3D to_svm(vcpu);
=20
+	/*
+	 * If it's an SNP guest, then the VMSA was marked in the RMP table as
+	 * a guest-owned page. Transition the page to hypervisor state before
+	 * releasing it back to the system.
+	 */
+	if (sev_snp_guest(vcpu->kvm)) {
+		u64 pfn =3D __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+
+		if (host_rmp_make_shared(pfn, PG_LEVEL_4K, true))
+			goto skip_vmsa_free;
+	}
+
 	if (vcpu->arch.guest_state_protected)
 		sev_flush_encrypted_page(vcpu, svm->sev_es.vmsa);
=20
 	__free_page(virt_to_page(svm->sev_es.vmsa));
=20
+skip_vmsa_free:
 	if (svm->sev_es.ghcb_sa_free)
 		kvfree(svm->sev_es.ghcb_sa);
 }
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 3705c2044fc0..903ddfea8585 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -658,6 +658,7 @@ struct sev_data_snp_launch_update {
  * @id_auth_paddr: system physical address of ID block authentication stru=
cture
  * @id_block_en: indicates whether ID block is present
  * @auth_key_en: indicates whether author key is present in authentication=
 structure
+ * @vcek_disabled: indicates whether use of VCEK is allowed for attestatio=
n reports
  * @rsvd: reserved
  * @host_data: host-supplied data for guest, not interpreted by firmware
  */
@@ -667,7 +668,8 @@ struct sev_data_snp_launch_finish {
 	u64 id_auth_paddr;
 	u8 id_block_en:1;
 	u8 auth_key_en:1;
-	u64 rsvd:62;
+	u8 vcek_disabled:1;
+	u64 rsvd:61;
 	u8 host_data[32];
 } __packed;
=20
--=20
2.25.1


X-sender: <kvm+bounces-13116-martin.weber=3Dsecunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=3Drfc822;martin.weber@secunet.=
com NOTIFY=3DNEVER; X-ExtendedProps=3DBQAVABYAAgAAAAUAFAARAJuYHy0vkvxLoOu7f=
W2WcxcPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNS=
ZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAU=
AEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWU=
RJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQALABcAvgAAA=
LMpUnVJ4+pPsL47FHo+lvtDTj1EQjIsQ049RGF0YWJhc2VzLENOPUV4Y2hhbmdlIEFkbWluaXN0=
cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpLENOPUFkbWluaXN0cmF0aXZlIEdyb3Vwcyx=
DTj1zZWN1bmV0LENOPU1pY3Jvc29mdCBFeGNoYW5nZSxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cm=
F0aW9uLERDPXNlY3VuZXQsREM9ZGUFAA4AEQBACf3SYEkDT461FZzDv+B7BQAdAA8ADAAAAG1ie=
C1lc3Nlbi0wMQUAPAACAAAPADYAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0Lk1haWxS=
ZWNpcGllbnQuRGlzcGxheU5hbWUPAA0AAABXZWJlciwgTWFydGluBQAMAAIAAAUAbAACAAAFAFg=
AFwBGAAAAm5gfLS+S/Eug67t9bZZzF0NOPVdlYmVyIE1hcnRpbixPVT1Vc2VycyxPVT1NaWdyYX=
Rpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc=
3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5U=
cmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQA=
jAAIAAQ=3D=3D
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAm0mmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0=
LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAA=
FAAUAAgABBQBiAAoAFwAAAM6KAAAFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 31432
Received: from cas-essen-01.secunet.de (10.53.40.201) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:01:01 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:01:01 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id 214F82032C
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 00:01:01 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -2.85
X-Spam-Level:
X-Spam-Status: No, score=3D-2.85 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.099, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_NONE=3D-0.0001, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dham autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Damd.com
Received: from b.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DNJ6gDc25nHX for <martin.weber@secunet.com>;
	Sat, 30 Mar 2024 00:00:57 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.80.249; helo=3Dam.mirrors.kernel.org; envelope-from=3Dkvm+bounces=
-13116-martin.weber=3Dsecunet.com@vger.kernel.org; receiver=3Dmartin.weber@=
secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 6E0D2200BB
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"Xnn0YoyP"
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id 6E0D2200BB
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 00:00:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EEAC71F25708
	for <martin.weber@secunet.com>; Fri, 29 Mar 2024 23:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A0D13D240;
	Fri, 29 Mar 2024 23:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"Xnn0YoyP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11=
on2062.outbound.protection.outlook.com [40.107.220.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513D513E401;
	Fri, 29 Mar 2024 23:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.220.62
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753230; cv=3Dfail; b=3DuZhgEsPvzM/O5hYoPvgVIjlWXaSncWu/gH+CMWkulPd=
23+p3QPC07Xcnvdc1pEegop+1fw5FWQt9xrKIhggwnnc/cJxhZmvY+efDK8zTDVGgPMZ1OBnPCJ=
1svuKjpe/xapUf2zfGgrB87DdADrHQzinKcE/FLI1mCdSAohMJ7OM=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753230; c=3Drelaxed/simple;
	bh=3Dq4vzPdo0+oii9a1ZolELIlylzfsIrazGRpbjD/k5aUY=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3Dko9KEZg3yLMXSxkN960Y/B2POJkn5tv0c1SE4wQqMB=
JNeTCF+VtC3I5Rs/cG3vbuvj3mVK5BMvEK9Yegm31H3BjyyNl7K1T0LCemXg4usQSAgVIu4Ibic=
Wvb3FBKu3DMFE8ZSoRJpC6bFHCBONslTx3MM6W14Bvvg8XrK8Um0Lw=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3DXnn0YoyP; arc=3Dfail smtp.client-ip=3D40.107.220.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DkoAhSHTroS7Six8Mk2ptjimEuKhzjh+UOZ0BKjgCc81mT+BeIOoN5WsMBdVaZUUy0R+PvN=
Tm4fC8i+uwFGBJV8NQMJkhjHeFNHs9v7dqfn1NGIFcfGChcbS/FPOvmOVVYpB/pw5U7oG2gLnAw=
xc20CK7NLojtWh4NCJ6M9OY8OY2nW344YP5M7kPGqBhcAq4W9kwvwslxNGFFGDAer3lswUX447A=
9LE0/fnMv5jbJ83rm5ix4N0K58GDPEx9VUGhhOgggVbAfXgKVio1kRzvNH8kJtZzXieWO/wEifc=
Ub+WRXxN3ZBE88A4zgVuKZm7/Oqe/HvOr/XrFZWS7gVA25Q=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DJrYjCWIu6wNf/NkduP5S/uOo7LBR9vnyryH5vZHAlfA=3D;
 b=3DLVmfJFAum0chfh8MZAu/WI+/8Q1sh2O9o7TULA0rPfys5d3XWI3rdAqs/rYpjoaI+XLbCn=
HEgvanj9y++g3Pa/6WeAuyuUZZP+r2ZuuqLZc6edOigte0P3F00JsEgpwhi4L//QOMpICtIepUx=
vGLpwvRyID4b85yTfLiPEsYzfzxDzMtwa6xyDWidl6wddXopfSMfQOn4cp+NLLaX0CGH64ADEMN=
jDgJRUx5k4b/vRjK7TOLrW1vnz5Ty62s6kgRDA13YMF0niFXxzCeK2SekIWp/623ludL5H2O+Jv=
T+5Bk3UU6+HQWzVWe4SzWyVmdcw+PiS9jlTsjHpiAmnR1Mw=3D=3D
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
 bh=3DJrYjCWIu6wNf/NkduP5S/uOo7LBR9vnyryH5vZHAlfA=3D;
 b=3DXnn0YoyPydUttY9jZm4o1iMO+E8KBjfMOPusb4Vj5axJk8hQRG/osW1QECRxvBowisK2ia=
RPpIm14+OOzYXxmMPkAt9nxcFBlrEsW8iRuNHSFxG83FlEnCf0xJ4+jqhhyl6Gtqjia8oulEv9c=
2cH+koDudTK+LTVXbryYxTNGZM=3D
Received: from SJ0PR03CA0173.namprd03.prod.outlook.com (2603:10b6:a03:338::=
28)
 by DS0PR12MB8197.namprd12.prod.outlook.com (2603:10b6:8:f1::16) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 =
Mar
 2024 23:00:26 +0000
Received: from SJ1PEPF00001CE2.namprd05.prod.outlook.com
 (2603:10b6:a03:338:cafe::51) by SJ0PR03CA0173.outlook.office365.com
 (2603:10b6:a03:338::28) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Front=
end
 Transport; Fri, 29 Mar 2024 23:00:26 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE2.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:00:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:00:24 -0500
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
	<brijesh.singh@amd.com>, Harald Hoyer <harald@profian.com>
Subject: [PATCH v12 12/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
Date: Fri, 29 Mar 2024 17:58:18 -0500
Message-ID: <20240329225835.400662-13-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE2:EE_|DS0PR12MB8197:EE_
X-MS-Office365-Filtering-Correlation-Id: 640e01f2-0a92-4152-816e-08dc504405=
91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: maS+wkIOrEV5dsQi+1Ucl7Dek3wbv2EkPTvamXV0=
iSrN3blKHKdzKy2sIgDkiuuCucCw1OYKPEXgE5LMW8sdaz4286tIVkN+6PYuPsOVvp7iv1rneuI=
p9shRSXhmHDARnXxJmXnr0iJa+9y2ATf3fTJJo5La1aeAucorCGMUeZYKun+1WQUJA1HQ3EOcWx=
wO84rEOPNsqnSbmycdcDtS590W5Ec83CUA4agPDbAh4zj2CzuSejnH/9AfsThwsQHoNe6C0wP3Y=
OSooNdigv7LS1g8Gv/K22w1hhc+2MjW7fKBuX9EGyBoPr2TiquiVGKTnfSA5CUdNUY8ebM82UWY=
w4VCzSjz8oNq06u7n8KmAJsEuQ+xDxDZ9+8UlUNuQmxbCqDLfOyyZTLQjuhoDsTsM7dZuGpqkAc=
vYHMMabFFq/mztOspe6IHwNWZuktMUfkhQT7jfXyNaEZMCch7qF1cFC/up6WcdI0HYTFJ1UW7LB=
jeIob+EJ9kPY8h7Mga93hhX3a55AynoannyjJkB/w916AFKVrRl53kdOW6ZUE+bCya4N3zsIQug=
olgebJDaVz3Zpt1Fdmee3h+45NUEoPhjIZIHrNfM8rK95aSy6fqixSHZ+oWPMkaTbYOYHhxpFXj=
MNlLe99ies3YgJ497umzrqGnQvGumS2jFNXz7xNkuKy2goBVtLNt3XHkMtD/fCYNc3oZE47i9tY=
jl+Soj5sN/JHUGL8jIuyLlq4kRQ30VQqSLpzThuTSB+XGQ31m+C8/
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(376005)(1800799015)(82310400014)(7416005)(36860700004);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:00:25.9312
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 640e01f2-0a92-4152-816e-08dc5=
0440591
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CE2.namprd05.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8197
Return-Path: kvm+bounces-13116-martin.weber=3Dsecunet.com@vger.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:01:01.1638
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: a7f21cc1-bc8e-4458-4436-08dc=
50441a75
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-02.secunet.de:TOTAL-HUB=3D0.203|SMR=3D0.132(SMRDE=3D0.006|SMRC=3D0.126(=
SMRCL=3D0.102|X-SMRCR=3D0.126))|CAT=3D0.070(CATOS=3D0.001
 (CATSM=3D0.001)|CATRESL=3D0.028(CATRESLP2R=3D0.022)|CATORES=3D0.038(CATRS=
=3D0.038(CATRS-Index
 Routing Agent=3D0.036 )));2024-03-29T23:01:01.383Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 21124
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-01.secunet.de:TO=
TAL-FE=3D0.016|SMR=3D0.005(SMRPI=3D0.003(SMRPI-FrontendProxyAgent=3D0.003))=
|SMS=3D0.011
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-02
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-02
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAfkTAAAPAAADH4sIAAAAAAAEAMU6DXfT=
xpaSPxMTk/DRAo
 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
 0FnXzsG+s52S8tfEkEfXEsxNr4HJXRiRgB/S9myA/nUP9wi2TzqD3Q
 xqIIihRptThOtndyWBFup4Qby9D4Ri2ig12XisqJHLWoHCYt406wdJ
 9Q7oQ68FzQzwv3VlXgphAwnDdILUtkrK9JbxC8eerr5oLYJNe9Rb1Z
 wDOODPMoZmpe08nl7gTii8oSNHU5AlsgsGxibSUvDaJY0flrOtQkq8
 WHmAcQEipFWehc+rzsKG6LRVlPQ/lHUXgQmCaRz2uaTskhqcpP8El0
 /i3GJy0yweciVTQSsyIYk5U9yhih3E/JYhHU929FYpG3UsBvxCIV/W
 sCnq6/Fp2wyqs58UhcJ/UDSwJ4RpYWchVV4Cc15HMq3m+TCYQgC1HB
 l7Lj0Cgq2y2S3SketetB/AatSBDCgn4QuSqWVSesz08WVtEefAbNxU
 yCRPf0aDIJGfdOFpX2xSgQ1NSu3CNcyTB2Gnp6fE0DtdB24I2hCnsj
 WuYeCodUxwV5lRNkRgrPR9Al4lCJqsuRznNBcQEwuCbN3JqneSGgma
 MaF85XlC3vXVVe74vEdVvxI3QeLkwiNELJ7duUlDFcDh6I6KPrgsiB
 kR31m9fIwQSpBWI7oxKp4mohtMtiSjmwohBg3ZGOEXqEpRz3lS1ufG
 CnFndiMaHFnYDJJyxOH46Sas1iaDpAZxOHMOIQCche1xZhsA0rHBQo
 AETDk4cZf5xh5NOcPPpIC0hBRCWWgoAJ0mDQOUDXhNS0HJ5OqFSjsO
 bVuJ1Pq6OtOf3Wl0gaG4WWIqOQnhbVPzIQqUX0PTnoFccjkpzoE56G
 Jm7oPxcFeyJC8fp/AFSmq3C9PAAAAQLcAjw/eG1sIHZlcnNpb249Ij
 EuMCIgZW5jb2Rpbmc9InV0Zi0xNiI/Pg0KPFRhc2tTZXQ+DQogIDxW
 ZXJzaW9uPjE1LjAuMC4wPC9WZXJzaW9uPg0KICA8VGFza3M+DQogIC
 AgPFRhc2sgU3RhcnRJbmRleD0iNTIwIj4NCiAgICAgIDxUYXNrU3Ry
 aW5nPnRvIHByb3ZpZGUsIHNvIGFsc28gYWRkIGhhbmRsaW5nIHRvIG
 NsZWFuIHVwIHRoZSBSTVAgZW50cmllcyBmb3IgdGhlc2U8L1Rhc2tT
 dHJpbmc+DQogICAgICA8QXNzaWduZWVzPg0KICAgICAgICA8RW1haW
 xVc2VyIElkPSJrdm1Admdlci5rZXJuZWwub3JnIiAvPg0KICAgICAg
 PC9Bc3NpZ25lZXM+DQogICAgPC9UYXNrPg0KICA8L1Rhc2tzPg0KPC
 9UYXNrU2V0PgEKxwQ8P3htbCB2ZXJzaW9uPSIxLjAiIGVuY29kaW5n
 PSJ1dGYtMTYiPz4NCjxFbWFpbFNldD4NCiAgPFZlcnNpb24+MTUuMC
 4wLjA8L1ZlcnNpb24+DQogIDxFbWFpbHM+DQogICAgPEVtYWlsIFN0
 YXJ0SW5kZXg9IjY1NSIgUG9zaXRpb249Ik90aGVyIj4NCiAgICAgID
 xFbWFpbFN0cmluZz5icmlqZXNoLnNpbmdoQGFtZC5jb208L0VtYWls
 U3RyaW5nPg0KICAgIDwvRW1haWw+DQogICAgPEVtYWlsIFN0YXJ0SW
 5kZXg9IjcwOCIgUG9zaXRpb249Ik90aGVyIj4NCiAgICAgIDxFbWFp
 bFN0cmluZz5oYXJhbGRAcHJvZmlhbi5jb208L0VtYWlsU3RyaW5nPg
 0KICAgIDwvRW1haWw+DQogICAgPEVtYWlsIFN0YXJ0SW5kZXg9Ijc1
 OCIgUG9zaXRpb249Ik90aGVyIj4NCiAgICAgIDxFbWFpbFN0cmluZz
 5hc2hpc2gua2FscmFAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAg
 PC9FbWFpbD4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iODgxIiBQb3
 NpdGlvbj0iT3RoZXIiPg0KICAgICAgPEVtYWlsU3RyaW5nPm1pY2hh
 ZWwucm90aEBhbWQuY29tPC9FbWFpbFN0cmluZz4NCiAgICA8L0VtYW
 lsPg0KICA8L0VtYWlscz4NCjwvRW1haWxTZXQ+AQ7PAVJldHJpZXZl
 ck9wZXJhdG9yLDEwLDI7UmV0cmlldmVyT3BlcmF0b3IsMTEsMjtQb3
 N0RG9jUGFyc2VyT3BlcmF0b3IsMTAsMTtQb3N0RG9jUGFyc2VyT3Bl
 cmF0b3IsMTEsMDtQb3N0V29yZEJyZWFrZXJEaWFnbm9zdGljT3Blcm
 F0b3IsMTAsNjtQb3N0V29yZEJyZWFrZXJEaWFnbm9zdGljT3BlcmF0
 b3IsMTEsMDtUcmFuc3BvcnRXcml0ZXJQcm9kdWNlciwyMCwxMw=3D=3D
X-MS-Exchange-Forest-IndexAgent: 1 6274
X-MS-Exchange-Forest-EmailMessageHash: 9C18AEDE
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

Add a KVM_SEV_SNP_LAUNCH_FINISH command to finalize the cryptographic
launch digest and stores it as the measurement of the guest at launch
time. Also extend the existing SNP firmware data structures to support
enforcing the use of Version Loaded Endorsement Keys by guests as part
of this command.

While finalizing the launch flow, it also issues the LAUNCH_UPDATE SNP
firmware commands to encrypt/measure the initial VMSA pages for each
configured vCPU. This involves setting the RMP entries for those pages
to provide, so also add handling to clean up the RMP entries for these
pages whening free'ing vCPUs.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Harald Hoyer <harald@profian.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: always measure BSP first to get consistent launch measurements]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  26 ++++
 arch/x86/include/uapi/asm/kvm.h               |  15 ++
 arch/x86/kvm/svm/sev.c                        | 137 ++++++++++++++++++
 include/linux/psp-sev.h                       |   4 +-
 4 files changed, 181 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documen=
tation/virt/kvm/x86/amd-memory-encryption.rst
index 4268aa5c380e..a49e8cff9133 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -517,6 +517,32 @@ where the allowed values for page_type are #define'd a=
s::
 See the SEV-SNP spec [snp-fw-abi]_ for further details on how each page ty=
pe is
 used/measured.
=20
+20. KVM_SEV_SNP_LAUNCH_FINISH
+-----------------------------
+
+After completion of the SNP guest launch flow, the KVM_SEV_SNP_LAUNCH_FINI=
SH
+command can be issued to make the guest ready for execution.
+
+Parameters (in): struct kvm_sev_snp_launch_finish
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_finish {
+                __u64 id_block_uaddr;
+                __u64 id_auth_uaddr;
+                __u8 id_block_en;
+                __u8 auth_key_en;
+                __u8 vlek_required;
+                __u8 host_data[32];
+                __u8 pad[6];
+        };
+
+
+See SEV-SNP specification [snp-fw-abi]_ for SNP_LAUNCH_FINISH further deta=
ils
+on launch finish input parameters.
+
 Device attribute API
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 956eb548c08e..2b08fcbe039a 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -696,6 +696,7 @@ enum sev_cmd_id {
 	/* SNP-specific commands */
 	KVM_SEV_SNP_LAUNCH_START,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
=20
 	KVM_SEV_NR_MAX,
 };
@@ -841,6 +842,20 @@ struct kvm_sev_snp_launch_update {
 	__u8 type;
 };
=20
+#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
+#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
+#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
+
+struct kvm_sev_snp_launch_finish {
+	__u64 id_block_uaddr;
+	__u64 id_auth_uaddr;
+	__u8 id_block_en;
+	__u8 auth_key_en;
+	__u8 vlek_required;
+	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
+	__u8 pad[6];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
=20
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a8a8a285b4a4..3d6c030091c2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -63,6 +63,8 @@ static u64 sev_supported_vmsa_features;
 #define SNP_POLICY_MASK_SMT		BIT_ULL(16)
 #define SNP_POLICY_MASK_SINGLE_SOCKET	BIT_ULL(20)
=20
+#define INITIAL_VMSA_GPA 0xFFFFFFFFF000
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2283,6 +2285,125 @@ static int snp_launch_update(struct kvm *kvm, struc=
t kvm_sev_cmd *argp)
 	return ret;
 }
=20
+static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *arg=
p)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_update data =3D {};
+	bool boot_vcpu_handled =3D false;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	int ret;
+
+	data.gctx_paddr =3D __psp_pa(sev->snp_context);
+	data.page_type =3D SNP_PAGE_TYPE_VMSA;
+
+handle_remaining_vcpus:
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vcpu_svm *svm =3D to_svm(vcpu);
+		u64 pfn =3D __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+
+		/* Handle boot vCPU first to ensure consistent measurement of initial st=
ate. */
+		if (!boot_vcpu_handled && vcpu->vcpu_id !=3D 0)
+			continue;
+
+		if (boot_vcpu_handled && vcpu->vcpu_id =3D=3D 0)
+			continue;
+
+		/* Perform some pre-encryption checks against the VMSA */
+		ret =3D sev_es_sync_vmsa(svm);
+		if (ret)
+			return ret;
+
+		/* Transition the VMSA page to a firmware state. */
+		ret =3D rmp_make_private(pfn, INITIAL_VMSA_GPA, PG_LEVEL_4K, sev->asid, =
true);
+		if (ret)
+			return ret;
+
+		/* Issue the SNP command to encrypt the VMSA */
+		data.address =3D __sme_pa(svm->sev_es.vmsa);
+		ret =3D __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+				      &data, &argp->error);
+		if (ret) {
+			snp_page_reclaim(pfn);
+			return ret;
+		}
+
+		svm->vcpu.arch.guest_state_protected =3D true;
+
+		if (!boot_vcpu_handled) {
+			boot_vcpu_handled =3D true;
+			goto handle_remaining_vcpus;
+		}
+	}
+
+	return 0;
+}
+
+static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_snp_launch_finish params;
+	struct sev_data_snp_launch_finish *data;
+	void *id_block =3D NULL, *id_auth =3D NULL;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	/* Measure all vCPUs using LAUNCH_UPDATE before finalizing the launch flo=
w. */
+	ret =3D snp_launch_update_vmsa(kvm, argp);
+	if (ret)
+		return ret;
+
+	data =3D kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	if (params.id_block_en) {
+		id_block =3D psp_copy_user_blob(params.id_block_uaddr, KVM_SEV_SNP_ID_BL=
OCK_SIZE);
+		if (IS_ERR(id_block)) {
+			ret =3D PTR_ERR(id_block);
+			goto e_free;
+		}
+
+		data->id_block_en =3D 1;
+		data->id_block_paddr =3D __sme_pa(id_block);
+
+		id_auth =3D psp_copy_user_blob(params.id_auth_uaddr, KVM_SEV_SNP_ID_AUTH=
_SIZE);
+		if (IS_ERR(id_auth)) {
+			ret =3D PTR_ERR(id_auth);
+			goto e_free_id_block;
+		}
+
+		data->id_auth_paddr =3D __sme_pa(id_auth);
+
+		if (params.auth_key_en)
+			data->auth_key_en =3D 1;
+	}
+
+	data->vcek_disabled =3D params.vlek_required;
+
+	memcpy(data->host_data, params.host_data, KVM_SEV_SNP_FINISH_DATA_SIZE);
+	data->gctx_paddr =3D __psp_pa(sev->snp_context);
+	ret =3D sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->error)=
;
+
+	kfree(id_auth);
+
+e_free_id_block:
+	kfree(id_block);
+
+e_free:
+	kfree(data);
+
+	return ret;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2376,6 +2497,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *a=
rgp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r =3D snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_FINISH:
+		r =3D snp_launch_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r =3D -EINVAL;
 		goto out;
@@ -2866,11 +2990,24 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
=20
 	svm =3D to_svm(vcpu);
=20
+	/*
+	 * If it's an SNP guest, then the VMSA was marked in the RMP table as
+	 * a guest-owned page. Transition the page to hypervisor state before
+	 * releasing it back to the system.
+	 */
+	if (sev_snp_guest(vcpu->kvm)) {
+		u64 pfn =3D __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+
+		if (host_rmp_make_shared(pfn, PG_LEVEL_4K, true))
+			goto skip_vmsa_free;
+	}
+
 	if (vcpu->arch.guest_state_protected)
 		sev_flush_encrypted_page(vcpu, svm->sev_es.vmsa);
=20
 	__free_page(virt_to_page(svm->sev_es.vmsa));
=20
+skip_vmsa_free:
 	if (svm->sev_es.ghcb_sa_free)
 		kvfree(svm->sev_es.ghcb_sa);
 }
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 3705c2044fc0..903ddfea8585 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -658,6 +658,7 @@ struct sev_data_snp_launch_update {
  * @id_auth_paddr: system physical address of ID block authentication stru=
cture
  * @id_block_en: indicates whether ID block is present
  * @auth_key_en: indicates whether author key is present in authentication=
 structure
+ * @vcek_disabled: indicates whether use of VCEK is allowed for attestatio=
n reports
  * @rsvd: reserved
  * @host_data: host-supplied data for guest, not interpreted by firmware
  */
@@ -667,7 +668,8 @@ struct sev_data_snp_launch_finish {
 	u64 id_auth_paddr;
 	u8 id_block_en:1;
 	u8 auth_key_en:1;
-	u64 rsvd:62;
+	u8 vcek_disabled:1;
+	u64 rsvd:61;
 	u8 host_data[32];
 } __packed;
=20
--=20
2.25.1


X-sender: <linux-kernel+bounces-125491-steffen.klassert=3Dsecunet.com@vger.=
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
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAm0mmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2Vj=
dW5ldC5jb20FAAYAAgABBQApAAIAAQ8ACQAAAENJQXVkaXRlZAIAAQUAAgAHAAEAAAAFAAMABwA=
AAAAABQAFAAIAAQUAYgAKABkAAADOigAABQBkAA8AAwAAAEh1Yg=3D=3D
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 31491
Received: from cas-essen-01.secunet.de (10.53.40.201) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:01:09 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:01:09 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id B74D720375
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:01:09 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -5.15
X-Spam-Level:
X-Spam-Status: No, score=3D-5.15 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.099, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_MED=3D-2.3, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dunavailable autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Damd.com
Received: from b.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2FRRxC-dgc2R for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:01:08 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D139.178.88.99; helo=3Dsv.mirrors.kernel.org; envelope-from=3Dlinux-kerne=
l+bounces-125491-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 904C4200BB
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"Xnn0YoyP"
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id 904C4200BB
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:01:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDBA3284466
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CA0C13CFB6;
	Fri, 29 Mar 2024 23:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"Xnn0YoyP"
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11=
on2062.outbound.protection.outlook.com [40.107.220.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513D513E401;
	Fri, 29 Mar 2024 23:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.220.62
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753230; cv=3Dfail; b=3DuZhgEsPvzM/O5hYoPvgVIjlWXaSncWu/gH+CMWkulPd=
23+p3QPC07Xcnvdc1pEegop+1fw5FWQt9xrKIhggwnnc/cJxhZmvY+efDK8zTDVGgPMZ1OBnPCJ=
1svuKjpe/xapUf2zfGgrB87DdADrHQzinKcE/FLI1mCdSAohMJ7OM=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753230; c=3Drelaxed/simple;
	bh=3Dq4vzPdo0+oii9a1ZolELIlylzfsIrazGRpbjD/k5aUY=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3Dko9KEZg3yLMXSxkN960Y/B2POJkn5tv0c1SE4wQqMB=
JNeTCF+VtC3I5Rs/cG3vbuvj3mVK5BMvEK9Yegm31H3BjyyNl7K1T0LCemXg4usQSAgVIu4Ibic=
Wvb3FBKu3DMFE8ZSoRJpC6bFHCBONslTx3MM6W14Bvvg8XrK8Um0Lw=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3DXnn0YoyP; arc=3Dfail smtp.client-ip=3D40.107.220.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DkoAhSHTroS7Six8Mk2ptjimEuKhzjh+UOZ0BKjgCc81mT+BeIOoN5WsMBdVaZUUy0R+PvN=
Tm4fC8i+uwFGBJV8NQMJkhjHeFNHs9v7dqfn1NGIFcfGChcbS/FPOvmOVVYpB/pw5U7oG2gLnAw=
xc20CK7NLojtWh4NCJ6M9OY8OY2nW344YP5M7kPGqBhcAq4W9kwvwslxNGFFGDAer3lswUX447A=
9LE0/fnMv5jbJ83rm5ix4N0K58GDPEx9VUGhhOgggVbAfXgKVio1kRzvNH8kJtZzXieWO/wEifc=
Ub+WRXxN3ZBE88A4zgVuKZm7/Oqe/HvOr/XrFZWS7gVA25Q=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DJrYjCWIu6wNf/NkduP5S/uOo7LBR9vnyryH5vZHAlfA=3D;
 b=3DLVmfJFAum0chfh8MZAu/WI+/8Q1sh2O9o7TULA0rPfys5d3XWI3rdAqs/rYpjoaI+XLbCn=
HEgvanj9y++g3Pa/6WeAuyuUZZP+r2ZuuqLZc6edOigte0P3F00JsEgpwhi4L//QOMpICtIepUx=
vGLpwvRyID4b85yTfLiPEsYzfzxDzMtwa6xyDWidl6wddXopfSMfQOn4cp+NLLaX0CGH64ADEMN=
jDgJRUx5k4b/vRjK7TOLrW1vnz5Ty62s6kgRDA13YMF0niFXxzCeK2SekIWp/623ludL5H2O+Jv=
T+5Bk3UU6+HQWzVWe4SzWyVmdcw+PiS9jlTsjHpiAmnR1Mw=3D=3D
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
 bh=3DJrYjCWIu6wNf/NkduP5S/uOo7LBR9vnyryH5vZHAlfA=3D;
 b=3DXnn0YoyPydUttY9jZm4o1iMO+E8KBjfMOPusb4Vj5axJk8hQRG/osW1QECRxvBowisK2ia=
RPpIm14+OOzYXxmMPkAt9nxcFBlrEsW8iRuNHSFxG83FlEnCf0xJ4+jqhhyl6Gtqjia8oulEv9c=
2cH+koDudTK+LTVXbryYxTNGZM=3D
Received: from SJ0PR03CA0173.namprd03.prod.outlook.com (2603:10b6:a03:338::=
28)
 by DS0PR12MB8197.namprd12.prod.outlook.com (2603:10b6:8:f1::16) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 =
Mar
 2024 23:00:26 +0000
Received: from SJ1PEPF00001CE2.namprd05.prod.outlook.com
 (2603:10b6:a03:338:cafe::51) by SJ0PR03CA0173.outlook.office365.com
 (2603:10b6:a03:338::28) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Front=
end
 Transport; Fri, 29 Mar 2024 23:00:26 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE2.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:00:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:00:24 -0500
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
	<brijesh.singh@amd.com>, Harald Hoyer <harald@profian.com>
Subject: [PATCH v12 12/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
Date: Fri, 29 Mar 2024 17:58:18 -0500
Message-ID: <20240329225835.400662-13-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE2:EE_|DS0PR12MB8197:EE_
X-MS-Office365-Filtering-Correlation-Id: 640e01f2-0a92-4152-816e-08dc504405=
91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: maS+wkIOrEV5dsQi+1Ucl7Dek3wbv2EkPTvamXV0=
iSrN3blKHKdzKy2sIgDkiuuCucCw1OYKPEXgE5LMW8sdaz4286tIVkN+6PYuPsOVvp7iv1rneuI=
p9shRSXhmHDARnXxJmXnr0iJa+9y2ATf3fTJJo5La1aeAucorCGMUeZYKun+1WQUJA1HQ3EOcWx=
wO84rEOPNsqnSbmycdcDtS590W5Ec83CUA4agPDbAh4zj2CzuSejnH/9AfsThwsQHoNe6C0wP3Y=
OSooNdigv7LS1g8Gv/K22w1hhc+2MjW7fKBuX9EGyBoPr2TiquiVGKTnfSA5CUdNUY8ebM82UWY=
w4VCzSjz8oNq06u7n8KmAJsEuQ+xDxDZ9+8UlUNuQmxbCqDLfOyyZTLQjuhoDsTsM7dZuGpqkAc=
vYHMMabFFq/mztOspe6IHwNWZuktMUfkhQT7jfXyNaEZMCch7qF1cFC/up6WcdI0HYTFJ1UW7LB=
jeIob+EJ9kPY8h7Mga93hhX3a55AynoannyjJkB/w916AFKVrRl53kdOW6ZUE+bCya4N3zsIQug=
olgebJDaVz3Zpt1Fdmee3h+45NUEoPhjIZIHrNfM8rK95aSy6fqixSHZ+oWPMkaTbYOYHhxpFXj=
MNlLe99ies3YgJ497umzrqGnQvGumS2jFNXz7xNkuKy2goBVtLNt3XHkMtD/fCYNc3oZE47i9tY=
jl+Soj5sN/JHUGL8jIuyLlq4kRQ30VQqSLpzThuTSB+XGQ31m+C8/
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(376005)(1800799015)(82310400014)(7416005)(36860700004);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:00:25.9312
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 640e01f2-0a92-4152-816e-08dc5=
0440591
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CE2.namprd05.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8197
Return-Path: linux-kernel+bounces-125491-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:01:09.8227
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 22dd6ec8-82d0-4e01-8306-08dc=
50441f9e
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-02.secunet.de:TOTAL-HUB=3D0.201|SMR=3D0.133(SMRDE=3D0.003|SMRC=3D0.129(=
SMRCL=3D0.102|X-SMRCR=3D0.128))|CAT=3D0.066(CATRESL=3D0.027
 (CATRESLP2R=3D0.020)|CATORES=3D0.036(CATRS=3D0.036(CATRS-Transport Rule
 Agent=3D0.001|CATRS-Index Routing Agent=3D0.034 )));2024-03-29T23:01:10.04=
1Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 21177
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-01.secunet.de:TO=
TAL-FE=3D0.017|SMR=3D0.008(SMRPI=3D0.005(SMRPI-FrontendProxyAgent=3D0.005))=
|SMS=3D0.010
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-02
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-02
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAfkTAAAPAAADH4sIAAAAAAAEAMU6DXfT=
xpaSPxMTk/DRAo
 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
 0FnXzsG+s52S8tfEkEfXEsxNr4HJXRiRgB/S9myA/nUP9wi2TzqD3Q
 xqIIihRptThOtndyWBFup4Qby9D4Ri2ig12XisqJHLWoHCYt406wdJ
 9Q7oQ68FzQzwv3VlXgphAwnDdILUtkrK9JbxC8eerr5oLYJNe9Rb1Z
 wDOODPMoZmpe08nl7gTii8oSNHU5AlsgsGxibSUvDaJY0flrOtQkq8
 WHmAcQEipFWehc+rzsKG6LRVlPQ/lHUXgQmCaRz2uaTskhqcpP8El0
 /i3GJy0yweciVTQSsyIYk5U9yhih3E/JYhHU929FYpG3UsBvxCIV/W
 sCnq6/Fp2wyqs58UhcJ/UDSwJ4RpYWchVV4Cc15HMq3m+TCYQgC1HB
 l7Lj0Cgq2y2S3SketetB/AatSBDCgn4QuSqWVSesz08WVtEefAbNxU
 yCRPf0aDIJGfdOFpX2xSgQ1NSu3CNcyTB2Gnp6fE0DtdB24I2hCnsj
 WuYeCodUxwV5lRNkRgrPR9Al4lCJqsuRznNBcQEwuCbN3JqneSGgma
 MaF85XlC3vXVVe74vEdVvxI3QeLkwiNELJ7duUlDFcDh6I6KPrgsiB
 kR31m9fIwQSpBWI7oxKp4mohtMtiSjmwohBg3ZGOEXqEpRz3lS1ufG
 CnFndiMaHFnYDJJyxOH46Sas1iaDpAZxOHMOIQCche1xZhsA0rHBQo
 AETDk4cZf5xh5NOcPPpIC0hBRCWWgoAJ0mDQOUDXhNS0HJ5OqFSjsO
 bVuJ1Pq6OtOf3Wl0gaG4WWIqOQnhbVPzIQqUX0PTnoFccjkpzoE56G
 Jm7oPxcFeyJC8fp/AFSmq3C9PAAAAQLcAjw/eG1sIHZlcnNpb249Ij
 EuMCIgZW5jb2Rpbmc9InV0Zi0xNiI/Pg0KPFRhc2tTZXQ+DQogIDxW
 ZXJzaW9uPjE1LjAuMC4wPC9WZXJzaW9uPg0KICA8VGFza3M+DQogIC
 AgPFRhc2sgU3RhcnRJbmRleD0iNTIwIj4NCiAgICAgIDxUYXNrU3Ry
 aW5nPnRvIHByb3ZpZGUsIHNvIGFsc28gYWRkIGhhbmRsaW5nIHRvIG
 NsZWFuIHVwIHRoZSBSTVAgZW50cmllcyBmb3IgdGhlc2U8L1Rhc2tT
 dHJpbmc+DQogICAgICA8QXNzaWduZWVzPg0KICAgICAgICA8RW1haW
 xVc2VyIElkPSJrdm1Admdlci5rZXJuZWwub3JnIiAvPg0KICAgICAg
 PC9Bc3NpZ25lZXM+DQogICAgPC9UYXNrPg0KICA8L1Rhc2tzPg0KPC
 9UYXNrU2V0PgEKxwQ8P3htbCB2ZXJzaW9uPSIxLjAiIGVuY29kaW5n
 PSJ1dGYtMTYiPz4NCjxFbWFpbFNldD4NCiAgPFZlcnNpb24+MTUuMC
 4wLjA8L1ZlcnNpb24+DQogIDxFbWFpbHM+DQogICAgPEVtYWlsIFN0
 YXJ0SW5kZXg9IjY1NSIgUG9zaXRpb249Ik90aGVyIj4NCiAgICAgID
 xFbWFpbFN0cmluZz5icmlqZXNoLnNpbmdoQGFtZC5jb208L0VtYWls
 U3RyaW5nPg0KICAgIDwvRW1haWw+DQogICAgPEVtYWlsIFN0YXJ0SW
 5kZXg9IjcwOCIgUG9zaXRpb249Ik90aGVyIj4NCiAgICAgIDxFbWFp
 bFN0cmluZz5oYXJhbGRAcHJvZmlhbi5jb208L0VtYWlsU3RyaW5nPg
 0KICAgIDwvRW1haWw+DQogICAgPEVtYWlsIFN0YXJ0SW5kZXg9Ijc1
 OCIgUG9zaXRpb249Ik90aGVyIj4NCiAgICAgIDxFbWFpbFN0cmluZz
 5hc2hpc2gua2FscmFAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAg
 PC9FbWFpbD4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iODgxIiBQb3
 NpdGlvbj0iT3RoZXIiPg0KICAgICAgPEVtYWlsU3RyaW5nPm1pY2hh
 ZWwucm90aEBhbWQuY29tPC9FbWFpbFN0cmluZz4NCiAgICA8L0VtYW
 lsPg0KICA8L0VtYWlscz4NCjwvRW1haWxTZXQ+AQ7PAVJldHJpZXZl
 ck9wZXJhdG9yLDEwLDA7UmV0cmlldmVyT3BlcmF0b3IsMTEsMjtQb3
 N0RG9jUGFyc2VyT3BlcmF0b3IsMTAsMTtQb3N0RG9jUGFyc2VyT3Bl
 cmF0b3IsMTEsMDtQb3N0V29yZEJyZWFrZXJEaWFnbm9zdGljT3Blcm
 F0b3IsMTAsNTtQb3N0V29yZEJyZWFrZXJEaWFnbm9zdGljT3BlcmF0
 b3IsMTEsMDtUcmFuc3BvcnRXcml0ZXJQcm9kdWNlciwyMCwxMw=3D=3D
X-MS-Exchange-Forest-IndexAgent: 1 6274
X-MS-Exchange-Forest-EmailMessageHash: 9C18AEDE
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

Add a KVM_SEV_SNP_LAUNCH_FINISH command to finalize the cryptographic
launch digest and stores it as the measurement of the guest at launch
time. Also extend the existing SNP firmware data structures to support
enforcing the use of Version Loaded Endorsement Keys by guests as part
of this command.

While finalizing the launch flow, it also issues the LAUNCH_UPDATE SNP
firmware commands to encrypt/measure the initial VMSA pages for each
configured vCPU. This involves setting the RMP entries for those pages
to provide, so also add handling to clean up the RMP entries for these
pages whening free'ing vCPUs.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Harald Hoyer <harald@profian.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: always measure BSP first to get consistent launch measurements]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  26 ++++
 arch/x86/include/uapi/asm/kvm.h               |  15 ++
 arch/x86/kvm/svm/sev.c                        | 137 ++++++++++++++++++
 include/linux/psp-sev.h                       |   4 +-
 4 files changed, 181 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documen=
tation/virt/kvm/x86/amd-memory-encryption.rst
index 4268aa5c380e..a49e8cff9133 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -517,6 +517,32 @@ where the allowed values for page_type are #define'd a=
s::
 See the SEV-SNP spec [snp-fw-abi]_ for further details on how each page ty=
pe is
 used/measured.
=20
+20. KVM_SEV_SNP_LAUNCH_FINISH
+-----------------------------
+
+After completion of the SNP guest launch flow, the KVM_SEV_SNP_LAUNCH_FINI=
SH
+command can be issued to make the guest ready for execution.
+
+Parameters (in): struct kvm_sev_snp_launch_finish
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_finish {
+                __u64 id_block_uaddr;
+                __u64 id_auth_uaddr;
+                __u8 id_block_en;
+                __u8 auth_key_en;
+                __u8 vlek_required;
+                __u8 host_data[32];
+                __u8 pad[6];
+        };
+
+
+See SEV-SNP specification [snp-fw-abi]_ for SNP_LAUNCH_FINISH further deta=
ils
+on launch finish input parameters.
+
 Device attribute API
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 956eb548c08e..2b08fcbe039a 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -696,6 +696,7 @@ enum sev_cmd_id {
 	/* SNP-specific commands */
 	KVM_SEV_SNP_LAUNCH_START,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
=20
 	KVM_SEV_NR_MAX,
 };
@@ -841,6 +842,20 @@ struct kvm_sev_snp_launch_update {
 	__u8 type;
 };
=20
+#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
+#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
+#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
+
+struct kvm_sev_snp_launch_finish {
+	__u64 id_block_uaddr;
+	__u64 id_auth_uaddr;
+	__u8 id_block_en;
+	__u8 auth_key_en;
+	__u8 vlek_required;
+	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
+	__u8 pad[6];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
=20
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a8a8a285b4a4..3d6c030091c2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -63,6 +63,8 @@ static u64 sev_supported_vmsa_features;
 #define SNP_POLICY_MASK_SMT		BIT_ULL(16)
 #define SNP_POLICY_MASK_SINGLE_SOCKET	BIT_ULL(20)
=20
+#define INITIAL_VMSA_GPA 0xFFFFFFFFF000
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2283,6 +2285,125 @@ static int snp_launch_update(struct kvm *kvm, struc=
t kvm_sev_cmd *argp)
 	return ret;
 }
=20
+static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *arg=
p)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_update data =3D {};
+	bool boot_vcpu_handled =3D false;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	int ret;
+
+	data.gctx_paddr =3D __psp_pa(sev->snp_context);
+	data.page_type =3D SNP_PAGE_TYPE_VMSA;
+
+handle_remaining_vcpus:
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vcpu_svm *svm =3D to_svm(vcpu);
+		u64 pfn =3D __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+
+		/* Handle boot vCPU first to ensure consistent measurement of initial st=
ate. */
+		if (!boot_vcpu_handled && vcpu->vcpu_id !=3D 0)
+			continue;
+
+		if (boot_vcpu_handled && vcpu->vcpu_id =3D=3D 0)
+			continue;
+
+		/* Perform some pre-encryption checks against the VMSA */
+		ret =3D sev_es_sync_vmsa(svm);
+		if (ret)
+			return ret;
+
+		/* Transition the VMSA page to a firmware state. */
+		ret =3D rmp_make_private(pfn, INITIAL_VMSA_GPA, PG_LEVEL_4K, sev->asid, =
true);
+		if (ret)
+			return ret;
+
+		/* Issue the SNP command to encrypt the VMSA */
+		data.address =3D __sme_pa(svm->sev_es.vmsa);
+		ret =3D __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+				      &data, &argp->error);
+		if (ret) {
+			snp_page_reclaim(pfn);
+			return ret;
+		}
+
+		svm->vcpu.arch.guest_state_protected =3D true;
+
+		if (!boot_vcpu_handled) {
+			boot_vcpu_handled =3D true;
+			goto handle_remaining_vcpus;
+		}
+	}
+
+	return 0;
+}
+
+static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_snp_launch_finish params;
+	struct sev_data_snp_launch_finish *data;
+	void *id_block =3D NULL, *id_auth =3D NULL;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	/* Measure all vCPUs using LAUNCH_UPDATE before finalizing the launch flo=
w. */
+	ret =3D snp_launch_update_vmsa(kvm, argp);
+	if (ret)
+		return ret;
+
+	data =3D kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	if (params.id_block_en) {
+		id_block =3D psp_copy_user_blob(params.id_block_uaddr, KVM_SEV_SNP_ID_BL=
OCK_SIZE);
+		if (IS_ERR(id_block)) {
+			ret =3D PTR_ERR(id_block);
+			goto e_free;
+		}
+
+		data->id_block_en =3D 1;
+		data->id_block_paddr =3D __sme_pa(id_block);
+
+		id_auth =3D psp_copy_user_blob(params.id_auth_uaddr, KVM_SEV_SNP_ID_AUTH=
_SIZE);
+		if (IS_ERR(id_auth)) {
+			ret =3D PTR_ERR(id_auth);
+			goto e_free_id_block;
+		}
+
+		data->id_auth_paddr =3D __sme_pa(id_auth);
+
+		if (params.auth_key_en)
+			data->auth_key_en =3D 1;
+	}
+
+	data->vcek_disabled =3D params.vlek_required;
+
+	memcpy(data->host_data, params.host_data, KVM_SEV_SNP_FINISH_DATA_SIZE);
+	data->gctx_paddr =3D __psp_pa(sev->snp_context);
+	ret =3D sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->error)=
;
+
+	kfree(id_auth);
+
+e_free_id_block:
+	kfree(id_block);
+
+e_free:
+	kfree(data);
+
+	return ret;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2376,6 +2497,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *a=
rgp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r =3D snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_FINISH:
+		r =3D snp_launch_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r =3D -EINVAL;
 		goto out;
@@ -2866,11 +2990,24 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
=20
 	svm =3D to_svm(vcpu);
=20
+	/*
+	 * If it's an SNP guest, then the VMSA was marked in the RMP table as
+	 * a guest-owned page. Transition the page to hypervisor state before
+	 * releasing it back to the system.
+	 */
+	if (sev_snp_guest(vcpu->kvm)) {
+		u64 pfn =3D __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+
+		if (host_rmp_make_shared(pfn, PG_LEVEL_4K, true))
+			goto skip_vmsa_free;
+	}
+
 	if (vcpu->arch.guest_state_protected)
 		sev_flush_encrypted_page(vcpu, svm->sev_es.vmsa);
=20
 	__free_page(virt_to_page(svm->sev_es.vmsa));
=20
+skip_vmsa_free:
 	if (svm->sev_es.ghcb_sa_free)
 		kvfree(svm->sev_es.ghcb_sa);
 }
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 3705c2044fc0..903ddfea8585 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -658,6 +658,7 @@ struct sev_data_snp_launch_update {
  * @id_auth_paddr: system physical address of ID block authentication stru=
cture
  * @id_block_en: indicates whether ID block is present
  * @auth_key_en: indicates whether author key is present in authentication=
 structure
+ * @vcek_disabled: indicates whether use of VCEK is allowed for attestatio=
n reports
  * @rsvd: reserved
  * @host_data: host-supplied data for guest, not interpreted by firmware
  */
@@ -667,7 +668,8 @@ struct sev_data_snp_launch_finish {
 	u64 id_auth_paddr;
 	u8 id_block_en:1;
 	u8 auth_key_en:1;
-	u64 rsvd:62;
+	u8 vcek_disabled:1;
+	u64 rsvd:61;
 	u8 host_data[32];
 } __packed;
=20
--=20
2.25.1




