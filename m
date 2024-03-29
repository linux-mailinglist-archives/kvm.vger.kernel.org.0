Return-Path: <kvm+bounces-13193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F09E989327F
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:09:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7333F1F2140D
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DEC8145FE3;
	Sun, 31 Mar 2024 16:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0OzfLPfd"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC395144314;
	Sun, 31 Mar 2024 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711901241; cv=fail; b=pBxCRT3q4ozxVSR10gN28mkUHAN1cxDNiHpdahGxHVokbub0rwNxMXwPnJhOUlcCGy4cr69ILZo3CYrmLEPjrTKNy7bLQ7RzzxI2daOuf+Cbzg6znx15aPVKX0UEAOCYMnyEyI0CA6gc1uy03ek7Yu9+eIUsiNuCgeWvkV+d32U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711901241; c=relaxed/simple;
	bh=qZPj3CEGMb0u2H+tMOH+bglgYmtgpsr6mF2LbMEkLxE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mv9aqrC024eT1lo8w9qmd9KwQP0yWBeRp3vWFyXlWNGFofP16bFnpM6ScaQknqt1eIAkChGmo4yhrBUlLkpmqMmztQqpWNbYzbhMJbwfmu1NVSpgIwMQ1JVhB44ATCDWe/I1sE0LEe+F+afhX0jg6tQdPxHzBnWivTEUHWLaU1g=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0OzfLPfd reason="signature verification failed"; arc=fail smtp.client-ip=40.107.93.84; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 8E401208A6;
	Sun, 31 Mar 2024 18:07:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jfhfeAETk3C7; Sun, 31 Mar 2024 18:07:16 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id E9B11208A3;
	Sun, 31 Mar 2024 18:07:15 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com E9B11208A3
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id 97733800050;
	Sun, 31 Mar 2024 18:02:12 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:02:12 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 15:52:41 +0000
X-sender: <linux-crypto+bounces-3102-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAPDFCS25BAlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAwAAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAbw5rGbMv3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2VjdW5ldC5jb20FAAYAAgABBQApAAIAAQ8ACQAAAENJQXVkaXRlZAIAAQUAAgAHAAEAAAAFAAMABwAAAAAABQAFAAIAAQUAYgAKACwAAADNigAABQBkAA8AAwAAAEh1Yg==
X-Source: SMTP:Default MBX-ESSEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 21957
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.199.223; helo=ny.mirrors.kernel.org; envelope-from=linux-crypto+bounces-3102-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 35888200BB
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0OzfLPfd"
X-Original-To: linux-crypto@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.84
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753482; cv=fail; b=dd/YUqMpHBY7oBs5X7SJOiSD3bZfm6eJnCuVCTszpQqnzTDkDKUeRP0iv9EciozkVY8bezMtlbRHd/iLI+yvb+p1bQFsmu/OsIPjT00dM5IAY1m6ISG6JDINDEjBldjIWObBWi6T/XnIiSdV7e32gep2BJbGzysEKgdgHqoO7UY=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753482; c=relaxed/simple;
	bh=qoE8VoSWxjBvaAC97qUKIp53Zv00INjbIDhNg0iLQGE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B9CB091b0+dhtD6NETV1KuvYYZmR5dKUqin7Zm8T2FAZKou24eKMBSaitIZydavGd9wMfihrYo5fpuyyxi73UKVMX9dl/E2+di82Uo5+Tl1lNZrIUtpP28gsDD5evwDmGss43HrhW5J52SYODJ9ubqFlXvOsxa/UKRJkIzyO9as=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0OzfLPfd; arc=fail smtp.client-ip=40.107.93.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmzppQt3HHdjSlx0Gcjy/1PafDG91jVT2gWT6ZmmBD1P5Oy7FzF6ZAELsthIFY4l4NjcT4q9mF3jH9rEI/XxZLC4W+Krss0yyIqiU7QKwXoNN+p+S2leM1L8gjm1SsHxQxhB1mRlAbhefkjg/XjHeybpqc8l9rmvJxQ2NXtbno2NgOkS4vbbVkruSJJDO8S1QLsf4N4r7v8M6TcrzLEkG2Ejvq5E5kzu3/w3AHwMHw6pakgYdZVr60jlVvBdL++32/krngqO04PDcwZjiPK5sKJabSVmgcT3XzQmtF5JJgVbUIJuP7mjmqMS2rXM7s888oQkAFmXbxfxc0b14ZgNUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aN5dRXX67F3gVsuDDIwedEmcnOL9iN4vQ9udAxqxhqc=;
 b=m9mGWEjH0U3miudpcZmIumfJrISSJe9DcuZa8ArNfPdM/TIhHhtVyMzMvJBWKpUzXeAvelyQ+uXjxYOFJOvVVZ+k7FCsWBgNe2pUaz8u1IRSOgOh8savUt/pneP5I5XO+hfDPFDXLGYwmf/uCt+NSnyO8jmG8+Q0J75I9Rn2Loh211AqxMWFEfAB7iGNkzOzSZIVCWpY4c7r1/mXbKgE2/uULmFVhqVL8xny3t7zea3GzgEJzxoI+Ww3RH9+hEvCuWV213vSpwp0gpHYUJEJy7N8t5z7HFWlsIyz01+nOCVXLbhhUysz88QVvWfnJsNadcR2GsggrzZIfoNCjx4YLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aN5dRXX67F3gVsuDDIwedEmcnOL9iN4vQ9udAxqxhqc=;
 b=0OzfLPfdr5awgBaOBCPyFx1LEtkyYimJdcJO9s39y5mukIUnCecs8bCnDqPw0s9Yi6eBCfJoFR8qhbo2SyzxtmFZjPrJiu6nk58F16qzNsdmUNb/mhANHx72woZ3d7YnyY6SbLOwYfHJlrKhIAOitM0TWuofnBsofRvp0j5afl0=
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
Subject: [PATCH v12 23/29] KVM: x86: Implement gmem hook for determining max NPT mapping level
Date: Fri, 29 Mar 2024 17:58:29 -0500
Message-ID: <20240329225835.400662-24-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|CH3PR12MB8755:EE_
X-MS-Office365-Filtering-Correlation-Id: e38e48d9-38a0-4b49-1d02-08dc50449b4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WM4cVZMM979iNHWUqg/R2qcnt+pYRBbuuCYpB3Fbz+oMUwGukB7l5dTzoGYJ1QuNky1ktimVX8cuhGtUgxBhYpn47T6T2eGyQhnk7eFm8sbikzk757e2b4xCdHGMolMOLIMFfSDyV8ZyJkaRB+H7HJnzvEhaSpj+YANSzx7jPPss9B4M9w0plIWzPvZkcq9JI506ArfELOZSJ6fTz8CWxidzPGf3mqvyewtgxcp9qLS6LwWQTbw5b8otbYADH1b0jWIrgye3c7sniPOhv6kECmI13mWJuVjJeaZ8R5peOO6TiMFUBqP52DovBAqt+x3XLRjmSxJSwoLN/hV7UaFlwZVPqfU+xDdRTf+AoQ5FmH9tTR3JRUc8uuwA6MlSp449hDpBwyNaTJsYLU+9LTCdGc3OLoa5xG5jqilSk/qclO5m/hHpQhd23abF4Vq4k0Pkt56LWJFyfKuQAfwoTgmjkjJ//4Zy9+bgqDPPkgtMDhM2cmqv/Ongly+IWlbsz3O9LAAf3sGFEy6UL7OgAsfL71pe/84AtNPeRr+b3D7U2W1aw/o08N5EPdnWxKJysjJrZfeKc7leOpKvxpp6qr+46mFUlafO89kBQy474AgtI+Sjz28UvkgW5DoCE/LyNst6sNyMfhXSoBldD5N+H5PsSpMZdGp7N5LJ1rVjaSmCvf7Z0JSh5SJlG8P9adn/znoTe1fgeegHa3PZRXOK1J/pjEPBGDIIwTAj0cKlOBybOYPUcFfhtXyx39Mz0URsw6kg
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(376005)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:04:37.2636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e38e48d9-38a0-4b49-1d02-08dc50449b4f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8755
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
2MB mapping in the guest's nested page table depends on whether or not
any subpages within the range have already been initialized as private
in the RMP table. The existing mixed-attribute tracking in KVM is
insufficient here, for instance:

  - gmem allocates 2MB page
  - guest issues PVALIDATE on 2MB page
  - guest later converts a subpage to shared
  - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
  - KVM MMU splits NPT mapping to 4K
  - guest later converts that shared page back to private

At this point there are no mixed attributes, and KVM would normally
allow for 2MB NPT mappings again, but this is actually not allowed
because the RMP table mappings are 4K and cannot be promoted on the
hypervisor side, so the NPT mappings must still be limited to 4K to
match this.

Implement a kvm_x86_ops.gmem_validate_fault() hook for SEV that checks
for this condition and adjusts the mapping level accordingly.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  7 +++++++
 3 files changed, 40 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 87d621d013a4..31f6f4786503 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4443,3 +4443,35 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t =
end)
 		pfn +=3D use_2m_update ? PTRS_PER_PMD : 1;
 	}
 }
+
+/*
+ * Re-check whether an #NPF for a private/gmem page can still be serviced,=
 and
+ * adjust maximum mapping level if needed.
+ */
+int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, boo=
l is_private,
+			    u8 *max_level)
+{
+	int level, rc;
+	bool assigned;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	rc =3D snp_lookup_rmpentry(pfn, &assigned, &level);
+	if (rc) {
+		pr_err_ratelimited("SEV: RMP entry not found: GFN %llx PFN %llx level %d=
 error %d\n",
+				   gfn, pfn, level, rc);
+		return -ENOENT;
+	}
+
+	if (!assigned) {
+		pr_err_ratelimited("SEV: RMP entry is not assigned: GFN %llx PFN %llx le=
vel %d\n",
+				   gfn, pfn, level);
+		return -EINVAL;
+	}
+
+	if (level < *max_level)
+		*max_level =3D level;
+
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b456906f2670..298b4ce77a5f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5081,6 +5081,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =3D =
{
=20
 	.gmem_prepare =3D sev_gmem_prepare,
 	.gmem_invalidate =3D sev_gmem_invalidate,
+	.gmem_validate_fault =3D sev_gmem_validate_fault,
 };
=20
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3f1f6d3d3ade..746f819a6de4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -732,6 +732,8 @@ void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_or=
der);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
+int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, boo=
l is_private,
+			    u8 *max_level);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -753,6 +755,11 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kv=
m_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
+static inline int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, =
gfn_t gfn,
+					  bool is_private, u8 *max_level)
+{
+	return 0;
+}
=20
 #endif
=20
--=20
2.25.1


X-sender: <linux-kernel+bounces-125504-steffen.klassert=3Dsecunet.com@vger.=
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
X-ExtendedProps: BQBjAAoAbw5rGbMv3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2Vj=
dW5ldC5jb20FAAYAAgABBQApAAIAAQ8ACQAAAENJQXVkaXRlZAIAAQUAAgAHAAEAAAAFAAMABwA=
AAAAABQAFAAIAAQUAYgAKAC8AAADNigAABQBkAA8AAwAAAEh1Yg=3D=3D
X-Source: SMTP:Default MBX-ESSEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 21712
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-essen-01.secunet.de (10.53.40.197) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 30 Mar 2024 00:05:02 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:05:02 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 5C22D208AC
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:05:02 +0100 (CET)
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
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C9d0pOCtIuDe for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:05:00 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.80.249; helo=3Dam.mirrors.kernel.org; envelope-from=3Dlinux-kerne=
l+bounces-125504-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com F2C682087D
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id F2C682087D
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:04:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AC961F268C0
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85DC413DBB3;
	Fri, 29 Mar 2024 23:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"0OzfLPfd"
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10=
on2084.outbound.protection.outlook.com [40.107.93.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FF7383A5;
	Fri, 29 Mar 2024 23:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.93.84
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753482; cv=3Dfail; b=3Ddd/YUqMpHBY7oBs5X7SJOiSD3bZfm6eJnCuVCTszpQq=
nzTDkDKUeRP0iv9EciozkVY8bezMtlbRHd/iLI+yvb+p1bQFsmu/OsIPjT00dM5IAY1m6ISG6JD=
INDEjBldjIWObBWi6T/XnIiSdV7e32gep2BJbGzysEKgdgHqoO7UY=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753482; c=3Drelaxed/simple;
	bh=3DqoE8VoSWxjBvaAC97qUKIp53Zv00INjbIDhNg0iLQGE=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DB9CB091b0+dhtD6NETV1KuvYYZmR5dKUqin7Zm8T2F=
AZKou24eKMBSaitIZydavGd9wMfihrYo5fpuyyxi73UKVMX9dl/E2+di82Uo5+Tl1lNZrIUtpP2=
8gsDD5evwDmGss43HrhW5J52SYODJ9ubqFlXvOsxa/UKRJkIzyO9as=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3D0OzfLPfd; arc=3Dfail smtp.client-ip=3D40.107.93.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DNmzppQt3HHdjSlx0Gcjy/1PafDG91jVT2gWT6ZmmBD1P5Oy7FzF6ZAELsthIFY4l4NjcT4=
q9mF3jH9rEI/XxZLC4W+Krss0yyIqiU7QKwXoNN+p+S2leM1L8gjm1SsHxQxhB1mRlAbhefkjg/=
XjHeybpqc8l9rmvJxQ2NXtbno2NgOkS4vbbVkruSJJDO8S1QLsf4N4r7v8M6TcrzLEkG2Ejvq5E=
5kzu3/w3AHwMHw6pakgYdZVr60jlVvBdL++32/krngqO04PDcwZjiPK5sKJabSVmgcT3XzQmtF5=
JJgVbUIJuP7mjmqMS2rXM7s888oQkAFmXbxfxc0b14ZgNUA=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DaN5dRXX67F3gVsuDDIwedEmcnOL9iN4vQ9udAxqxhqc=3D;
 b=3Dm9mGWEjH0U3miudpcZmIumfJrISSJe9DcuZa8ArNfPdM/TIhHhtVyMzMvJBWKpUzXeAvel=
yQ+uXjxYOFJOvVVZ+k7FCsWBgNe2pUaz8u1IRSOgOh8savUt/pneP5I5XO+hfDPFDXLGYwmf/uC=
t+NSnyO8jmG8+Q0J75I9Rn2Loh211AqxMWFEfAB7iGNkzOzSZIVCWpY4c7r1/mXbKgE2/uULmFV=
hqVL8xny3t7zea3GzgEJzxoI+Ww3RH9+hEvCuWV213vSpwp0gpHYUJEJy7N8t5z7HFWlsIyz01+=
nOCVXLbhhUysz88QVvWfnJsNadcR2GsggrzZIfoNCjx4YLQ=3D=3D
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
 bh=3DaN5dRXX67F3gVsuDDIwedEmcnOL9iN4vQ9udAxqxhqc=3D;
 b=3D0OzfLPfdr5awgBaOBCPyFx1LEtkyYimJdcJO9s39y5mukIUnCecs8bCnDqPw0s9Yi6eBCf=
JoFR8qhbo2SyzxtmFZjPrJiu6nk58F16qzNsdmUNb/mhANHx72woZ3d7YnyY6SbLOwYfHJlrKhI=
AOitM0TWuofnBsofRvp0j5afl0=3D
Received: from DM6PR01CA0002.prod.exchangelabs.com (2603:10b6:5:296::7) by
 CH3PR12MB8755.namprd12.prod.outlook.com (2603:10b6:610:17e::16) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 =
Mar
 2024 23:04:37 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:5:296:cafe::7) by DM6PR01CA0002.outlook.office365.com
 (2603:10b6:5:296::7) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Front=
end
 Transport; Fri, 29 Mar 2024 23:04:37 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:04:37 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:04:36 -0500
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
Subject: [PATCH v12 23/29] KVM: x86: Implement gmem hook for determining ma=
x NPT mapping level
Date: Fri, 29 Mar 2024 17:58:29 -0500
Message-ID: <20240329225835.400662-24-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|CH3PR12MB8755:EE_
X-MS-Office365-Filtering-Correlation-Id: e38e48d9-38a0-4b49-1d02-08dc50449b=
4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WM4cVZMM979iNHWUqg/R2qcnt+pYRBbuuCYpB3Fb=
z+oMUwGukB7l5dTzoGYJ1QuNky1ktimVX8cuhGtUgxBhYpn47T6T2eGyQhnk7eFm8sbikzk757e=
2b4xCdHGMolMOLIMFfSDyV8ZyJkaRB+H7HJnzvEhaSpj+YANSzx7jPPss9B4M9w0plIWzPvZkcq=
9JI506ArfELOZSJ6fTz8CWxidzPGf3mqvyewtgxcp9qLS6LwWQTbw5b8otbYADH1b0jWIrgye3c=
7sniPOhv6kECmI13mWJuVjJeaZ8R5peOO6TiMFUBqP52DovBAqt+x3XLRjmSxJSwoLN/hV7UaFl=
wZVPqfU+xDdRTf+AoQ5FmH9tTR3JRUc8uuwA6MlSp449hDpBwyNaTJsYLU+9LTCdGc3OLoa5xG5=
jqilSk/qclO5m/hHpQhd23abF4Vq4k0Pkt56LWJFyfKuQAfwoTgmjkjJ//4Zy9+bgqDPPkgtMDh=
M2cmqv/Ongly+IWlbsz3O9LAAf3sGFEy6UL7OgAsfL71pe/84AtNPeRr+b3D7U2W1aw/o08N5EP=
dnWxKJysjJrZfeKc7leOpKvxpp6qr+46mFUlafO89kBQy474AgtI+Sjz28UvkgW5DoCE/LyNst6=
sNyMfhXSoBldD5N+H5PsSpMZdGp7N5LJ1rVjaSmCvf7Z0JSh5SJlG8P9adn/znoTe1fgeegHa3P=
ZRXOK1J/pjEPBGDIIwTAj0cKlOBybOYPUcFfhtXyx39Mz0URsw6kg
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(1800799015)(82310400014)(376005)(7416005)(36860700004);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:04:37.2636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e38e48d9-38a0-4b49-1d02-08dc5=
0449b4f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017092.namprd03.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8755
Return-Path: linux-kernel+bounces-125504-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:05:02.4011
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 799a2402-d345-4053-2529-08dc=
5044aa3f
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-01.secunet.de:TOTAL-HUB=3D0.204|SMR=3D0.134(SMRDE=3D0.003|SMRC=3D0.130(=
SMRCL=3D0.106|X-SMRCR=3D0.130))|CAT=3D0.068(CATRESL=3D0.025
 (CATRESLP2R=3D0.003)|CATORES=3D0.039(CATRS=3D0.039(CATRS-Index Routing
 Agent=3D0.038))|CATORT=3D0.001 (CATRT=3D0.001));2024-03-29T23:05:02.610Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 15616
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D5.000|SMR=3D0.005(SMRPI=3D0.003(SMRPI-FrontendProxyAgent=3D0.003))
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-01
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAdEIAAAPAAADH4sIAAAAAAAEAM1XbW/b=
yBFeStYbbfWSS5
 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
 qMOcedCKBkiLtTCysTU/oyDJyJinp8pR+jKgwWwIJ+Y4VHc6Qfo8IW
 8iYFWostN79K5BZ1Ev8r4jcrRrUoBAZ90ZzSgk4DIygKRpGR5HSbMT
 Ba4o34Qf6xXUkBUCgzr3lxL8891XGaVLB3RW+kLYvvEHSZQXK8pr7o
 jNCodEDLFAvKGhzSsWCbt9iauM94OJRFlmshzzgzYOi1kLZJb4YwSS
 ePc2yhQhvd1UmXo8xCa/dyvKqaSjEv7heNEiP/JpfygNuxRFGoywVx
 O0fO3kfj37Isl0U1n3qRZrSmWneWNG8cvlUNmwHcK1IB+S5HMH670J
 qWPdMybzBj6kFqB4cqqZsP0gbSeCf1qPw/lBYDGBeibIZm2kjvA62f
 ErpsiFsc8ZK4s0S1EaVYzcjyXja1Z+Vx97/m5pLAh87l3LStVZ3JIO
 1ymV6pTOnRh2ktqqTVe26aJiclofw5ms9PdW5+SRaX/6MphhW7VEwv
 Or9SGPoonHXzNr4WyMi47HzL6VYyTFMfwcbyVZJ1mRpr6ctZyomVNC
 MqKcjP58rM7vuFjG1lGKtki1KKZ6VgVLWn5KORp/a/AEJ80O+9GAAA
 AQrxATw/eG1sIHZlcnNpb249IjEuMCIgZW5jb2Rpbmc9InV0Zi0xNi
 I/Pg0KPEVtYWlsU2V0Pg0KICA8VmVyc2lvbj4xNS4wLjAuMDwvVmVy
 c2lvbj4NCiAgPEVtYWlscz4NCiAgICA8RW1haWwgU3RhcnRJbmRleD
 0iMTA1MiIgUG9zaXRpb249IlNpZ25hdHVyZSI+DQogICAgICA8RW1h
 aWxTdHJpbmc+bWljaGFlbC5yb3RoQGFtZC5jb208L0VtYWlsU3RyaW
 5nPg0KICAgIDwvRW1haWw+DQogIDwvRW1haWxzPg0KPC9FbWFpbFNl
 dD4BDLMEPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLT
 E2Ij8+DQo8Q29udGFjdFNldD4NCiAgPFZlcnNpb24+MTUuMC4wLjA8
 L1ZlcnNpb24+DQogIDxDb250YWN0cz4NCiAgICA8Q29udGFjdCBTdG
 FydEluZGV4PSIxMDM4IiBQb3NpdGlvbj0iU2lnbmF0dXJlIj4NCiAg
 ICAgIDxQZXJzb24gU3RhcnRJbmRleD0iMTAzOCIgUG9zaXRpb249Il
 NpZ25hdHVyZSI+DQogICAgICAgIDxQZXJzb25TdHJpbmc+TWljaGFl
 bCBSb3RoPC9QZXJzb25TdHJpbmc+DQogICAgICA8L1BlcnNvbj4NCi
 AgICAgIDxFbWFpbHM+DQogICAgICAgIDxFbWFpbCBTdGFydEluZGV4
 PSIxMDUyIiBQb3NpdGlvbj0iU2lnbmF0dXJlIj4NCiAgICAgICAgIC
 A8RW1haWxTdHJpbmc+bWljaGFlbC5yb3RoQGFtZC5jb208L0VtYWls
 U3RyaW5nPg0KICAgICAgICA8L0VtYWlsPg0KICAgICAgPC9FbWFpbH
 M+DQogICAgICA8Q29udGFjdFN0cmluZz5NaWNoYWVsIFJvdGggJmx0
 O21pY2hhZWwucm90aEBhbWQuY29tPC9Db250YWN0U3RyaW5nPg0KIC
 AgIDwvQ29udGFjdD4NCiAgPC9Db250YWN0cz4NCjwvQ29udGFjdFNl
 dD4BDs8BUmV0cmlldmVyT3BlcmF0b3IsMTAsMTtSZXRyaWV2ZXJPcG
 VyYXRvciwxMSwxO1Bvc3REb2NQYXJzZXJPcGVyYXRvciwxMCwwO1Bv
 c3REb2NQYXJzZXJPcGVyYXRvciwxMSwwO1Bvc3RXb3JkQnJlYWtlck
 RpYWdub3N0aWNPcGVyYXRvciwxMCwyO1Bvc3RXb3JkQnJlYWtlckRp
 YWdub3N0aWNPcGVyYXRvciwxMSwwO1RyYW5zcG9ydFdyaXRlclByb2 R1Y2VyLDIwLDI1
X-MS-Exchange-Forest-IndexAgent: 1 3291
X-MS-Exchange-Forest-EmailMessageHash: 8139CF1E
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
2MB mapping in the guest's nested page table depends on whether or not
any subpages within the range have already been initialized as private
in the RMP table. The existing mixed-attribute tracking in KVM is
insufficient here, for instance:

  - gmem allocates 2MB page
  - guest issues PVALIDATE on 2MB page
  - guest later converts a subpage to shared
  - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
  - KVM MMU splits NPT mapping to 4K
  - guest later converts that shared page back to private

At this point there are no mixed attributes, and KVM would normally
allow for 2MB NPT mappings again, but this is actually not allowed
because the RMP table mappings are 4K and cannot be promoted on the
hypervisor side, so the NPT mappings must still be limited to 4K to
match this.

Implement a kvm_x86_ops.gmem_validate_fault() hook for SEV that checks
for this condition and adjusts the mapping level accordingly.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  7 +++++++
 3 files changed, 40 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 87d621d013a4..31f6f4786503 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4443,3 +4443,35 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t =
end)
 		pfn +=3D use_2m_update ? PTRS_PER_PMD : 1;
 	}
 }
+
+/*
+ * Re-check whether an #NPF for a private/gmem page can still be serviced,=
 and
+ * adjust maximum mapping level if needed.
+ */
+int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, boo=
l is_private,
+			    u8 *max_level)
+{
+	int level, rc;
+	bool assigned;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	rc =3D snp_lookup_rmpentry(pfn, &assigned, &level);
+	if (rc) {
+		pr_err_ratelimited("SEV: RMP entry not found: GFN %llx PFN %llx level %d=
 error %d\n",
+				   gfn, pfn, level, rc);
+		return -ENOENT;
+	}
+
+	if (!assigned) {
+		pr_err_ratelimited("SEV: RMP entry is not assigned: GFN %llx PFN %llx le=
vel %d\n",
+				   gfn, pfn, level);
+		return -EINVAL;
+	}
+
+	if (level < *max_level)
+		*max_level =3D level;
+
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b456906f2670..298b4ce77a5f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5081,6 +5081,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =3D =
{
=20
 	.gmem_prepare =3D sev_gmem_prepare,
 	.gmem_invalidate =3D sev_gmem_invalidate,
+	.gmem_validate_fault =3D sev_gmem_validate_fault,
 };
=20
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3f1f6d3d3ade..746f819a6de4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -732,6 +732,8 @@ void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_or=
der);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
+int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, boo=
l is_private,
+			    u8 *max_level);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -753,6 +755,11 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kv=
m_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
+static inline int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, =
gfn_t gfn,
+					  bool is_private, u8 *max_level)
+{
+	return 0;
+}
=20
 #endif
=20
--=20
2.25.1



