Return-Path: <kvm+bounces-13197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A9D189328F
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF8371F2288D
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1593A144314;
	Sun, 31 Mar 2024 16:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZP/7DMTG"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CC114534C;
	Sun, 31 Mar 2024 16:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711901477; cv=fail; b=Mc6SR7umM147Ay63LUHOLaeLtZV/8o3ihdWZI52KcMvUYZBj33Svj605P+a1837q6EQynC4FKX0w41cXE1xK3sbybtmQohZ83nY4FrM4zVokZnk8xS0K1Pe043+E15dgadk5iKlo00aL7VNKp4TuZ7WiNJcAGBC5NJSIeE/wTK0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711901477; c=relaxed/simple;
	bh=5c8zhDfcMbpsXLVQsZOnYPgv5aHR2rf5q1ILo5PbHMc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rCiAxclINhOV0i+ggJdeDmHwHmcqXqukpSJry2PT9jQUdoo9UXtjDNW8dRj+/G0iPtOo56pcBlDQOoxX6AShQjEuD+x+lKkxlTCoZZf+bdmlP8l2EG8MDrSJ8Up+yIyIQ9Ks4jvi2YMLIQurzY12U/BuKdETRLXylO9HFo/vg90=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZP/7DMTG; arc=fail smtp.client-ip=40.107.236.40; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 5B728208CF;
	Sun, 31 Mar 2024 18:11:13 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c_gukpeqj3t7; Sun, 31 Mar 2024 18:11:12 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 2A229208A3;
	Sun, 31 Mar 2024 18:11:12 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 2A229208A3
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id B743080004A;
	Sun, 31 Mar 2024 18:02:08 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:02:08 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 15:52:41 +0000
X-sender: <linux-crypto+bounces-3087-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAPDFCS25BAlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAwAAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoA+Q1rGbMv3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2VjdW5ldC5jb20FAAYAAgABBQApAAIAAQ8ACQAAAENJQXVkaXRlZAIAAQUAAgAHAAEAAAAFAAMABwAAAAAABQAFAAIAAQUAYgAKAIkAAADMigAABQBkAA8AAwAAAEh1Yg==
X-Source: SMTP:Default MBX-ESSEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 33201
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.199.223; helo=ny.mirrors.kernel.org; envelope-from=linux-crypto+bounces-3087-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com A5041200BB
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZP/7DMTG"
X-Original-To: linux-crypto@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753171; cv=fail; b=jcayv/9uC4T8P77oFK+iKjXiPda/yTMegLjI59U/clJBPkoiIJ8ErPpZ2PlVQhoCTfRelgXTfdoP81/auei39z7Cd+/bYhHK1kWn9a7Bvok5bTqu5bHX6Oh9HXIEAG/I1mo5CmXHqmq8CJD8B6FuQfwggWQv2BLlvWl7lGpJl/c=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753171; c=relaxed/simple;
	bh=5c8zhDfcMbpsXLVQsZOnYPgv5aHR2rf5q1ILo5PbHMc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Os3eu02qBp9/vs/KmBhy0MByeKMmof1Cz6+cmle3GZn2HF2mjuOHlQxn88FJPntD1wD3KvaU3RnDv3A9zndXKrH0+tFsRL9gUg8bKaQoUHSLW9u5+sS3GG9GM14Ye0v2tQwbx9QP/AAJjn0ixq30DIYE8a+1Zs6zma9Q7Yslmbs=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZP/7DMTG; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+RJHf/rVZH530XT1GCJWPwJ6Mpc1hKrcQvYd4xL54lLlm+ytsJmysKthG2vCa7fCEw8QUSV/HKIe5jFMCkHOeRvUw/7+pN3VsWTxZBOw4PlFqBlrXYiTuXB/4wrqxVKhAzhd+t1QS506zNTd5y0Cxu+NJgrOgizSjsM6VQMZH2sMSKLGTBt9M4kkFoy9FMLN1nINWolJ6fhtFXgOKJr0UpIf9xsGnln6A+V3apqvIG2W/EDB2VaA9d1jPe/7fPbOVSKSJOegSLtF11EvPOlwvwjald09QeoJHYDsST+dXS0IE+zgnR/GlQAfIg/IfoSDFINh5htMZ3UDkg9ssVd9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g4F0v4TXhVkzuRwLgbfEWUQkfmsL+Uf1rI69FDB8x/8=;
 b=TuqSH36JyOXmYccLiUXWdFEih5He/146zy7PY2/vd0g6VC/PTWaQFiHts+uuRyJcYKnTRWf5+UtbofHWWFYZ5O11xxJvCkGBNuMF20+G7x/HYtz3/W0Djy2WtYCsNU4892Bzp72PRz4MMl/IlwWbmbDSddD97KPirj9rKQ4SL4PyskhEalF9gp+b8JyZzdJwUWS65A/DUikIgoAImTNHuL83Qo1onV/Ag8TxdPXhlLiD9knQ61afh+kEMZesJL3c/ZkDtJ41VGGBndZa3ntrzJqc+jZ79GZ8sPg3HcmRjoH5eKw0+iHfEdbRxal2pS+if8CN1RNOAAOOhiOXfwwgqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4F0v4TXhVkzuRwLgbfEWUQkfmsL+Uf1rI69FDB8x/8=;
 b=ZP/7DMTGJLB9Yii5sXMLLSiTJTEwT+kEdYoYzl0aGj81F+Dh5bNz2ZpxpgG6OKG/7RH7DifdvlDGg5ioSSL4KWF/dfpgDwucUIToufxWW7twWOS3RzAqReBBqpa83c9GfG8/jtbTIfxTgGCX4d2X78viqbON2UTpouGMWD1B19A=
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
Subject: [PATCH v12 10/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
Date: Fri, 29 Mar 2024 17:58:16 -0500
Message-ID: <20240329225835.400662-11-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|PH8PR12MB6721:EE_
X-MS-Office365-Filtering-Correlation-Id: a9179cff-2565-428c-c1f4-08dc5043e056
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N0Q/ob1ES6c3vUyxIlbqNB1kiL8OchYZphqdYFkdXJpTeOncGhrxGWgpCPK3lwltWnf6Oi2ReoR2DcLJUy+jBMH9sC0SYt3rWAAol+BcQ7Jhf2NEHsziRkhN1DSQ1Dl+zorUbf0dQl9qJSO9/jFwPuJ53q/yhLZAN9Cx5sipS9ZxyPaBmuhSScBnshrZnTUScfBuq6KXgc6hm+a8ba6nC9pw5J/u1BKP6Vi7t4jpT5Pnrv/GYBHQRJ++N5tWPHBFMHwONq3UGpHOQEjboXryDCoBsahNlrjw8O9Fhx5u9dfruz5kBDa1M7EXOTC2FRiK0McBIhsrbp/pu/h9xbfiNz/rYkbHHj6+pt2BbW/e0yQzyRRO4fCGwMUyryyv3wV1Y0/CGDHJMwcf/+KEwK5sfbvJzkNIPB9BWrvh+J7FBHoLiD1sPPbJM+EwI0hSU/J85LJsGzpGDcmTvkASBALQkAriYslf9x8KopxE/h1aHB3jxThDLZZoruvoTKonOZ/K17BI//ZZac0gITuyIqitRIiWcYTmxozfE5O94AO0yXbmGkXAN656jwxiw59sppRQWWHK/lxH3E0mDKpu7nZ+dUOb1PO3cTy/3nw0Wn7hTGUEBVAtgazKKPxEh3iUp6pU1stIxfRcV6vWBay3UcQ1YVZiEBjzohCsXR2NabzELLKGFdknfV/2XZZHzZk/eUNmjdRmQOIMz6qCBgJr4CsQww==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230031)(7416005)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 22:59:23.5330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9179cff-2565-428c-c1f4-08dc5043e056
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6721
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

From: Brijesh Singh <brijesh.singh@amd.com>

KVM_SEV_SNP_LAUNCH_START begins the launch process for an SEV-SNP guest.
The command initializes a cryptographic digest context used to construct
the measurement of the guest. Other commands can then at that point be
used to load/encrypt data into the guest's initial launch image.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: hold sev_deactivate_lock when calling SEV_CMD_SNP_DECOMMISSION]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  23 ++-
 arch/x86/include/uapi/asm/kvm.h               |   8 +
 arch/x86/kvm/svm/sev.c                        | 152 +++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 4 files changed, 180 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index f7c007d34114..a10b817c162d 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -459,6 +459,25 @@ issued by the hypervisor to make the guest ready for execution.
 
 Returns: 0 on success, -negative on error
 
+18. KVM_SEV_SNP_LAUNCH_START
+----------------------------
+
+The KVM_SNP_LAUNCH_START command is used for creating the memory encryption
+context for the SEV-SNP guest.
+
+Parameters (in): struct  kvm_sev_snp_launch_start
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_start {
+                __u64 policy;           /* Guest policy to use. */
+                __u8 gosvw[16];         /* Guest OS visible workarounds. */
+        };
+
+See the SEV-SNP spec [snp-fw-abi]_ for further detail on the launch input.
+
 Device attribute API
 ====================
 
@@ -490,9 +509,11 @@ References
 ==========
 
 
-See [white-paper]_, [api-spec]_, [amd-apm]_ and [kvm-forum]_ for more info.
+See [white-paper]_, [api-spec]_, [amd-apm]_, [kvm-forum]_, and [snp-fw-abi]_
+for more info.
 
 .. [white-paper] https://developer.amd.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
 .. [api-spec] https://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
 .. [amd-apm] https://support.amd.com/TechDocs/24593.pdf (section 15.34)
 .. [kvm-forum]  https://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
+.. [snp-fw-abi] https://www.amd.com/system/files/TechDocs/56860.pdf
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 725b75cfe9ff..350ddd5264ea 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -693,6 +693,9 @@ enum sev_cmd_id {
 	/* Second time is the charm; improved versions of the above ioctls.  */
 	KVM_SEV_INIT2,
 
+	/* SNP-specific commands */
+	KVM_SEV_SNP_LAUNCH_START,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -818,6 +821,11 @@ struct kvm_sev_receive_update_data {
 	__u32 pad2;
 };
 
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u8 gosvw[16];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3d9771163562..6c7c77e33e62 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -25,6 +25,7 @@
 #include <asm/fpu/xcr.h>
 #include <asm/fpu/xstate.h>
 #include <asm/debugreg.h>
+#include <asm/sev.h>
 
 #include "mmu.h"
 #include "x86.h"
@@ -58,6 +59,10 @@ static u64 sev_supported_vmsa_features;
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
 
+/* As defined by SEV-SNP Firmware ABI, under "Guest Policy". */
+#define SNP_POLICY_MASK_SMT		BIT_ULL(16)
+#define SNP_POLICY_MASK_SINGLE_SOCKET	BIT_ULL(20)
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -68,6 +73,8 @@ static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
+static int snp_decommission_context(struct kvm *kvm);
+
 struct enc_region {
 	struct list_head list;
 	unsigned long npages;
@@ -94,12 +101,17 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
 	down_write(&sev_deactivate_lock);
 
 	wbinvd_on_all_cpus();
-	ret = sev_guest_df_flush(&error);
+
+	if (sev_snp_enabled)
+		ret = sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, &error);
+	else
+		ret = sev_guest_df_flush(&error);
 
 	up_write(&sev_deactivate_lock);
 
 	if (ret)
-		pr_err("SEV: DF_FLUSH failed, ret=%d, error=%#x\n", ret, error);
+		pr_err("SEV%s: DF_FLUSH failed, ret=%d, error=%#x\n",
+		       sev_snp_enabled ? "-SNP" : "", ret, error);
 
 	return ret;
 }
@@ -1967,6 +1979,102 @@ int sev_dev_get_attr(u64 attr, u64 *val)
 	}
 }
 
+/*
+ * The guest context contains all the information, keys and metadata
+ * associated with the guest that the firmware tracks to implement SEV
+ * and SNP features. The firmware stores the guest context in hypervisor
+ * provide page via the SNP_GCTX_CREATE command.
+ */
+static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct sev_data_snp_addr data = {};
+	void *context;
+	int rc;
+
+	/* Allocate memory for context page */
+	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
+	if (!context)
+		return NULL;
+
+	data.address = __psp_pa(context);
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
+	if (rc) {
+		pr_warn("Failed to create SEV-SNP context, rc %d fw_error %d",
+			rc, argp->error);
+		snp_free_firmware_page(context);
+		return NULL;
+	}
+
+	return context;
+}
+
+static int snp_bind_asid(struct kvm *kvm, int *error)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_activate data = {0};
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+	data.asid = sev_get_asid(kvm);
+	return sev_issue_cmd(kvm, SEV_CMD_SNP_ACTIVATE, &data, error);
+}
+
+static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_start start = {0};
+	struct kvm_sev_snp_launch_start params;
+	int rc;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	/* Don't allow userspace to allocate memory for more than 1 SNP context. */
+	if (sev->snp_context) {
+		pr_debug("SEV-SNP context already exists. Refusing to allocate an additional one.");
+		return -EINVAL;
+	}
+
+	sev->snp_context = snp_context_create(kvm, argp);
+	if (!sev->snp_context)
+		return -ENOTTY;
+
+	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET) {
+		pr_debug("SEV-SNP hypervisor does not support limiting guests to a single socket.");
+		return -EINVAL;
+	}
+
+	if (!(params.policy & SNP_POLICY_MASK_SMT)) {
+		pr_debug("SEV-SNP hypervisor does not support limiting guests to a single SMT thread.");
+		return -EINVAL;
+	}
+
+	start.gctx_paddr = __psp_pa(sev->snp_context);
+	start.policy = params.policy;
+	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
+	if (rc) {
+		pr_debug("SEV_CMD_SNP_LAUNCH_START command failed, rc %d\n", rc);
+		goto e_free_context;
+	}
+
+	sev->fd = argp->sev_fd;
+	rc = snp_bind_asid(kvm, &argp->error);
+	if (rc) {
+		pr_debug("Failed to bind ASID to SEV-SNP context, rc %d\n", rc);
+		goto e_free_context;
+	}
+
+	return 0;
+
+e_free_context:
+	snp_decommission_context(kvm);
+
+	return rc;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2054,6 +2162,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_FINISH:
 		r = sev_receive_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r = snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2249,6 +2360,33 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
+static int snp_decommission_context(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_addr data = {};
+	int ret;
+
+	/* If context is not created then do nothing */
+	if (!sev->snp_context)
+		return 0;
+
+	data.address = __sme_pa(sev->snp_context);
+	down_write(&sev_deactivate_lock);
+	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
+	if (WARN_ONCE(ret, "failed to release guest context")) {
+		up_write(&sev_deactivate_lock);
+		return ret;
+	}
+
+	up_write(&sev_deactivate_lock);
+
+	/* free the context page now */
+	snp_free_firmware_page(sev->snp_context);
+	sev->snp_context = NULL;
+
+	return 0;
+}
+
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -2290,7 +2428,15 @@ void sev_vm_destroy(struct kvm *kvm)
 		}
 	}
 
-	sev_unbind_asid(kvm, sev->handle);
+	if (sev_snp_guest(kvm)) {
+		if (snp_decommission_context(kvm)) {
+			WARN_ONCE(1, "Failed to free SNP guest context, leaking asid!\n");
+			return;
+		}
+	} else {
+		sev_unbind_asid(kvm, sev->handle);
+	}
+
 	sev_asid_free(sev);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4a01a81dd9b9..a3c190642c57 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -92,6 +92,7 @@ struct kvm_sev_info {
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
+	void *snp_context;      /* SNP guest context page */
 };
 
 struct kvm_svm {
-- 
2.25.1



