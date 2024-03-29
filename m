Return-Path: <kvm+bounces-13244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E45D893508
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:19:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43D8B28CAA0
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2669D16F848;
	Sun, 31 Mar 2024 16:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0OzfLPfd"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC056152512;
	Sun, 31 Mar 2024 16:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903648; cv=fail; b=d93ywBaIxePXDVW+OmIGS6cBntOMoIbJjG1Y6CfxTZPwUaUFUWfDUj9BTBGmzfuqHp5nVqKTlUy1vwGYOYX/YIF7+rDc8O8oI8/6YhrQbAClmh9ApUg/AXNDhjMhF2K6cBMeYxGlnsEkEUFKWn4O+77wID5dtpyOrel5F0DoZAQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903648; c=relaxed/simple;
	bh=VHIiWOVkfAy+1ZRJPL5d94ZuAwTJ85rhICnJa09syzk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JOJ89fofe0eyBH18U/GoILZsbdrjmatgBnlNWkC41OExa169JimpkBi07SOBxbeLy8yvFmAStIicO7xIx4C5Xi3+BCdFq32uXL7LVxpl+WQvbWdQ7tAUdwYIdiMN4mwwgjAUSg1wEGKb8cogPMbklusEzEO7fJXjzEg1+MV3LqM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0OzfLPfd reason="signature verification failed"; arc=fail smtp.client-ip=40.107.93.84; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 13E502082B;
	Sun, 31 Mar 2024 18:47:22 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k2_0NNgFfPVD; Sun, 31 Mar 2024 18:47:20 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 2346E20826;
	Sun, 31 Mar 2024 18:47:16 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 2346E20826
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id EB1B9800059;
	Sun, 31 Mar 2024 18:40:20 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:20 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:18 +0000
X-sender: <kvm+bounces-13128-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
 NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAJuYHy0vkvxLoOu7fW2WcxcPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQALABcAvgAAALMpUnVJ4+pPsL47FHo+lvtDTj1EQjIsQ049RGF0YWJhc2VzLENOPUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpLENOPUFkbWluaXN0cmF0aXZlIEdyb3VwcyxDTj1zZWN1bmV0LENOPU1pY3Jvc29mdCBFeGNoYW5nZSxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAA4AEQBACf3SYEkDT461FZzDv+B7BQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUAPAACAAAPADYAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0Lk1haWxSZWNpcGllbnQuRGlzcGxheU5hbWUPAA0AAABXZWJlciwgTWFydGluBQAMAAIAAAUAbAACAAAFAFgAFwBGAAAAm5gfLS+S/Eug67t9bZZzF0NOPVdlYmVyIE1hcnRpbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoA6kmmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBiAAoAQQAAAM6KAAAFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 21882
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.80.249; helo=am.mirrors.kernel.org; envelope-from=kvm+bounces-13128-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 09E0D200BB
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0OzfLPfd"
X-Original-To: kvm@vger.kernel.org
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
Content-Transfer-Encoding: 8bit
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
@@ -4443,3 +4443,35 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 		pfn += use_2m_update ? PTRS_PER_PMD : 1;
 	}
 }
+
+/*
+ * Re-check whether an #NPF for a private/gmem page can still be serviced, and
+ * adjust maximum mapping level if needed.
+ */
+int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,
+			    u8 *max_level)
+{
+	int level, rc;
+	bool assigned;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
+	if (rc) {
+		pr_err_ratelimited("SEV: RMP entry not found: GFN %llx PFN %llx level %d error %d\n",
+				   gfn, pfn, level, rc);
+		return -ENOENT;
+	}
+
+	if (!assigned) {
+		pr_err_ratelimited("SEV: RMP entry is not assigned: GFN %llx PFN %llx level %d\n",
+				   gfn, pfn, level);
+		return -EINVAL;
+	}
+
+	if (level < *max_level)
+		*max_level = level;
+
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b456906f2670..298b4ce77a5f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5081,6 +5081,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
+	.gmem_validate_fault = sev_gmem_validate_fault,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3f1f6d3d3ade..746f819a6de4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -732,6 +732,8 @@ void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
+int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,
+			    u8 *max_level);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -753,6 +755,11 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
+static inline int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
+					  bool is_private, u8 *max_level)
+{
+	return 0;
+}
 
 #endif
 
-- 
2.25.1


X-sender: <linux-kernel+bounces-125504-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=rfc822;steffen.klassert@secunet.com
X-CreatedBy: MSExchange15
X-HeloDomain: mbx-essen-01.secunet.de
X-ExtendedProps: BQBjAAoA/0mmlidQ3AgFADcAAgAADwA8AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50Lk9yZ2FuaXphdGlvblNjb3BlEQAAAAAAAAAAAAAAAAAAAAAADwA/AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLk1haWxEZWxpdmVyeVByaW9yaXR5DwADAAAATG93
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 10.53.40.197
X-EndOfInjectedXHeaders: 16161
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:05:02 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Sat, 30 Mar 2024 00:05:02 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 5C22D208AC
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:05:02 +0100 (CET)
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
	with ESMTP id C9d0pOCtIuDe for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:05:00 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.80.249; helo=am.mirrors.kernel.org; envelope-from=linux-kernel+bounces-125504-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com F2C682087D
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id F2C682087D
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:04:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AC961F268C0
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85DC413DBB3;
	Fri, 29 Mar 2024 23:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0OzfLPfd"
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FF7383A5;
	Fri, 29 Mar 2024 23:04:40 +0000 (UTC)
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
Received: from DM6PR01CA0002.prod.exchangelabs.com (2603:10b6:5:296::7) by
 CH3PR12MB8755.namprd12.prod.outlook.com (2603:10b6:610:17e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 23:04:37 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:5:296:cafe::7) by DM6PR01CA0002.outlook.office365.com
 (2603:10b6:5:296::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Frontend
 Transport; Fri, 29 Mar 2024 23:04:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:04:37 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
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
Subject: [PATCH v12 23/29] KVM: x86: Implement gmem hook for determining max NPT mapping level
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
Return-Path: linux-kernel+bounces-125504-steffen.klassert=secunet.com@vger.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:05:02.4011
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 799a2402-d345-4053-2529-08dc5044aa3f
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.secunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=cas-essen-02.secunet.de:TOTAL-FE=0.005|SMR=0.005(SMRPI=0.003(SMRPI-FrontendProxyAgent=0.003));2024-03-29T23:05:02.407Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-OriginalSize: 15616
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=Low
X-MS-Exchange-Organization-Prioritization: 2:ShadowRedundancy
X-MS-Exchange-Organization-IncludeInSla: False:ShadowRedundancy

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
@@ -4443,3 +4443,35 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 		pfn += use_2m_update ? PTRS_PER_PMD : 1;
 	}
 }
+
+/*
+ * Re-check whether an #NPF for a private/gmem page can still be serviced, and
+ * adjust maximum mapping level if needed.
+ */
+int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,
+			    u8 *max_level)
+{
+	int level, rc;
+	bool assigned;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
+	if (rc) {
+		pr_err_ratelimited("SEV: RMP entry not found: GFN %llx PFN %llx level %d error %d\n",
+				   gfn, pfn, level, rc);
+		return -ENOENT;
+	}
+
+	if (!assigned) {
+		pr_err_ratelimited("SEV: RMP entry is not assigned: GFN %llx PFN %llx level %d\n",
+				   gfn, pfn, level);
+		return -EINVAL;
+	}
+
+	if (level < *max_level)
+		*max_level = level;
+
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b456906f2670..298b4ce77a5f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5081,6 +5081,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
+	.gmem_validate_fault = sev_gmem_validate_fault,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3f1f6d3d3ade..746f819a6de4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -732,6 +732,8 @@ void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
+int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,
+			    u8 *max_level);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -753,6 +755,11 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
+static inline int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
+					  bool is_private, u8 *max_level)
+{
+	return 0;
+}
 
 #endif
 
-- 
2.25.1



