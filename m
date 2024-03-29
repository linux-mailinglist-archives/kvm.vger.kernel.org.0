Return-Path: <kvm+bounces-13247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00E96893512
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A64A528CAC9
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF4A514D6EA;
	Sun, 31 Mar 2024 16:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZP/7DMTG"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6762816F91D;
	Sun, 31 Mar 2024 16:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903653; cv=fail; b=cbs7Ov4Zs6wAJGIOEf52cxS73dsmEFUlQlt3z1s5IBbdBLpXQIe/peZNQCcouTA+5/CoITylCroLctvRE8eHP7lYFbfpZwAxvVeuRP8zC/Ne1ipzNqgBm2bFJQVkybVSfRXUuFGWlD6A0Fls1VdBAQm/DEnMLK+WQPpATov2IqQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903653; c=relaxed/simple;
	bh=MgaLjQ/x5PlwV7lmlvb+D4K+1qFZkfJj7vQady8Oci4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YsZWt/uWzux+pdXzuTzkrQW52INVNI2Pc9nWFimBiec5fb8/pOrSOUWsnSHmUr6gGkSNWmSGyuLZZejkLwqT6M+rnZ8haSAwBF4fG1GG5rT2qWT9tQTOa3tMQKm7XISvdxNpEX9sDjG2XrZxFu15LnSDWpFQFVvglu9s0F0LIlg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZP/7DMTG reason="signature verification failed"; arc=fail smtp.client-ip=40.107.236.40; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 37CE220754;
	Sun, 31 Mar 2024 18:47:27 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MmzESzuzFWdA; Sun, 31 Mar 2024 18:47:24 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 256EA2083F;
	Sun, 31 Mar 2024 18:47:16 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 256EA2083F
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id 5359C800050;
	Sun, 31 Mar 2024 18:40:15 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:15 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:17 +0000
X-sender: <kvm+bounces-13113-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
 NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAJuYHy0vkvxLoOu7fW2WcxcPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQALABcAvgAAALMpUnVJ4+pPsL47FHo+lvtDTj1EQjIsQ049RGF0YWJhc2VzLENOPUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpLENOPUFkbWluaXN0cmF0aXZlIEdyb3VwcyxDTj1zZWN1bmV0LENOPU1pY3Jvc29mdCBFeGNoYW5nZSxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAA4AEQBACf3SYEkDT461FZzDv+B7BQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUAPAACAAAPADYAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0Lk1haWxSZWNpcGllbnQuRGlzcGxheU5hbWUPAA0AAABXZWJlciwgTWFydGluBQAMAAIAAAUAbAACAAAFAFgAFwBGAAAAm5gfLS+S/Eug67t9bZZzF0NOPVdlYmVyIE1hcnRpbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAWUmmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBiAAoAfgAAAM2KAAAFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 33107
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.199.223; helo=ny.mirrors.kernel.org; envelope-from=kvm+bounces-13113-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 075B02032C
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZP/7DMTG"
X-Original-To: kvm@vger.kernel.org
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
Content-Transfer-Encoding: quoted-printable
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

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documen=
tation/virt/kvm/x86/amd-memory-encryption.rst
index f7c007d34114..a10b817c162d 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -459,6 +459,25 @@ issued by the hypervisor to make the guest ready for e=
xecution.
=20
 Returns: 0 on success, -negative on error
=20
+18. KVM_SEV_SNP_LAUNCH_START
+----------------------------
+
+The KVM_SNP_LAUNCH_START command is used for creating the memory encryptio=
n
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
+                __u8 gosvw[16];         /* Guest OS visible workarounds. *=
/
+        };
+
+See the SEV-SNP spec [snp-fw-abi]_ for further detail on the launch input.
+
 Device attribute API
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
@@ -490,9 +509,11 @@ References
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
=20
-See [white-paper]_, [api-spec]_, [amd-apm]_ and [kvm-forum]_ for more info=
.
+See [white-paper]_, [api-spec]_, [amd-apm]_, [kvm-forum]_, and [snp-fw-abi=
]_
+for more info.
=20
 .. [white-paper] https://developer.amd.com/wordpress/media/2013/12/AMD_Mem=
ory_Encryption_Whitepaper_v7-Public.pdf
 .. [api-spec] https://support.amd.com/TechDocs/55766_SEV-KM_API_Specificat=
ion.pdf
 .. [amd-apm] https://support.amd.com/TechDocs/24593.pdf (section 15.34)
 .. [kvm-forum]  https://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendac=
ky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
+.. [snp-fw-abi] https://www.amd.com/system/files/TechDocs/56860.pdf
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 725b75cfe9ff..350ddd5264ea 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -693,6 +693,9 @@ enum sev_cmd_id {
 	/* Second time is the charm; improved versions of the above ioctls.  */
 	KVM_SEV_INIT2,
=20
+	/* SNP-specific commands */
+	KVM_SEV_SNP_LAUNCH_START,
+
 	KVM_SEV_NR_MAX,
 };
=20
@@ -818,6 +821,11 @@ struct kvm_sev_receive_update_data {
 	__u32 pad2;
 };
=20
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u8 gosvw[16];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
=20
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3d9771163562..6c7c77e33e62 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -25,6 +25,7 @@
 #include <asm/fpu/xcr.h>
 #include <asm/fpu/xstate.h>
 #include <asm/debugreg.h>
+#include <asm/sev.h>
=20
 #include "mmu.h"
 #include "x86.h"
@@ -58,6 +59,10 @@ static u64 sev_supported_vmsa_features;
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
=20
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
=20
+static int snp_decommission_context(struct kvm *kvm);
+
 struct enc_region {
 	struct list_head list;
 	unsigned long npages;
@@ -94,12 +101,17 @@ static int sev_flush_asids(unsigned int min_asid, unsi=
gned int max_asid)
 	down_write(&sev_deactivate_lock);
=20
 	wbinvd_on_all_cpus();
-	ret =3D sev_guest_df_flush(&error);
+
+	if (sev_snp_enabled)
+		ret =3D sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, &error);
+	else
+		ret =3D sev_guest_df_flush(&error);
=20
 	up_write(&sev_deactivate_lock);
=20
 	if (ret)
-		pr_err("SEV: DF_FLUSH failed, ret=3D%d, error=3D%#x\n", ret, error);
+		pr_err("SEV%s: DF_FLUSH failed, ret=3D%d, error=3D%#x\n",
+		       sev_snp_enabled ? "-SNP" : "", ret, error);
=20
 	return ret;
 }
@@ -1967,6 +1979,102 @@ int sev_dev_get_attr(u64 attr, u64 *val)
 	}
 }
=20
+/*
+ * The guest context contains all the information, keys and metadata
+ * associated with the guest that the firmware tracks to implement SEV
+ * and SNP features. The firmware stores the guest context in hypervisor
+ * provide page via the SNP_GCTX_CREATE command.
+ */
+static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct sev_data_snp_addr data =3D {};
+	void *context;
+	int rc;
+
+	/* Allocate memory for context page */
+	context =3D snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
+	if (!context)
+		return NULL;
+
+	data.address =3D __psp_pa(context);
+	rc =3D __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &arg=
p->error);
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
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_activate data =3D {0};
+
+	data.gctx_paddr =3D __psp_pa(sev->snp_context);
+	data.asid =3D sev_get_asid(kvm);
+	return sev_issue_cmd(kvm, SEV_CMD_SNP_ACTIVATE, &data, error);
+}
+
+static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_start start =3D {0};
+	struct kvm_sev_snp_launch_start params;
+	int rc;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	/* Don't allow userspace to allocate memory for more than 1 SNP context. =
*/
+	if (sev->snp_context) {
+		pr_debug("SEV-SNP context already exists. Refusing to allocate an additi=
onal one.");
+		return -EINVAL;
+	}
+
+	sev->snp_context =3D snp_context_create(kvm, argp);
+	if (!sev->snp_context)
+		return -ENOTTY;
+
+	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET) {
+		pr_debug("SEV-SNP hypervisor does not support limiting guests to a singl=
e socket.");
+		return -EINVAL;
+	}
+
+	if (!(params.policy & SNP_POLICY_MASK_SMT)) {
+		pr_debug("SEV-SNP hypervisor does not support limiting guests to a singl=
e SMT thread.");
+		return -EINVAL;
+	}
+
+	start.gctx_paddr =3D __psp_pa(sev->snp_context);
+	start.policy =3D params.policy;
+	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
+	rc =3D __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &a=
rgp->error);
+	if (rc) {
+		pr_debug("SEV_CMD_SNP_LAUNCH_START command failed, rc %d\n", rc);
+		goto e_free_context;
+	}
+
+	sev->fd =3D argp->sev_fd;
+	rc =3D snp_bind_asid(kvm, &argp->error);
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
@@ -2054,6 +2162,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *a=
rgp)
 	case KVM_SEV_RECEIVE_FINISH:
 		r =3D sev_receive_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r =3D snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r =3D -EINVAL;
 		goto out;
@@ -2249,6 +2360,33 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, un=
signed int source_fd)
 	return ret;
 }
=20
+static int snp_decommission_context(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_addr data =3D {};
+	int ret;
+
+	/* If context is not created then do nothing */
+	if (!sev->snp_context)
+		return 0;
+
+	data.address =3D __sme_pa(sev->snp_context);
+	down_write(&sev_deactivate_lock);
+	ret =3D sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
+	if (WARN_ONCE(ret, "failed to release guest context")) {
+		up_write(&sev_deactivate_lock);
+		return ret;
+	}
+
+	up_write(&sev_deactivate_lock);
+
+	/* free the context page now */
+	snp_free_firmware_page(sev->snp_context);
+	sev->snp_context =3D NULL;
+
+	return 0;
+}
+
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
@@ -2290,7 +2428,15 @@ void sev_vm_destroy(struct kvm *kvm)
 		}
 	}
=20
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
=20
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
=20
 struct kvm_svm {
--=20
2.25.1


X-sender: <linux-kernel+bounces-125487-steffen.klassert=3Dsecunet.com@vger.=
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
X-ExtendedProps: BQBjAAoAWUmmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2Vj=
dW5ldC5jb20FAAYAAgABBQApAAIAAQ8ACQAAAENJQXVkaXRlZAIAAQUAAgAHAAEAAAAFAAMABwA=
AAAAABQAFAAIAAQUAYgAKAIEAAADNigAABQBkAA8AAwAAAEh1Yg=3D=3D
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 33241
Received: from cas-essen-01.secunet.de (10.53.40.201) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Fri, 29 Mar 2024 23:59:53 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Fri, 29 Mar 2024 23:59:53 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id A97F12032C
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:59:53 +0100 (CET)
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
	with ESMTP id UKNPQtZCaYj3 for <steffen.klassert@secunet.com>;
	Fri, 29 Mar 2024 23:59:52 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D139.178.88.99; helo=3Dsv.mirrors.kernel.org; envelope-from=3Dlinux-kerne=
l+bounces-125487-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 46151200BB
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"ZP/7DMTG"
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id 46151200BB
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:59:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AABE284496
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 22:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A601513E6A0;
	Fri, 29 Mar 2024 22:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"ZP/7DMTG"
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11=
on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF1313CF91;
	Fri, 29 Mar 2024 22:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.236.40
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753171; cv=3Dfail; b=3Djcayv/9uC4T8P77oFK+iKjXiPda/yTMegLjI59U/clJ=
BPkoiIJ8ErPpZ2PlVQhoCTfRelgXTfdoP81/auei39z7Cd+/bYhHK1kWn9a7Bvok5bTqu5bHX6O=
h9HXIEAG/I1mo5CmXHqmq8CJD8B6FuQfwggWQv2BLlvWl7lGpJl/c=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753171; c=3Drelaxed/simple;
	bh=3D5c8zhDfcMbpsXLVQsZOnYPgv5aHR2rf5q1ILo5PbHMc=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DOs3eu02qBp9/vs/KmBhy0MByeKMmof1Cz6+cmle3GZ=
n2HF2mjuOHlQxn88FJPntD1wD3KvaU3RnDv3A9zndXKrH0+tFsRL9gUg8bKaQoUHSLW9u5+sS3G=
G9GM14Ye0v2tQwbx9QP/AAJjn0ixq30DIYE8a+1Zs6zma9Q7Yslmbs=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3DZP/7DMTG; arc=3Dfail smtp.client-ip=3D40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3Da+RJHf/rVZH530XT1GCJWPwJ6Mpc1hKrcQvYd4xL54lLlm+ytsJmysKthG2vCa7fCEw8QU=
SV/HKIe5jFMCkHOeRvUw/7+pN3VsWTxZBOw4PlFqBlrXYiTuXB/4wrqxVKhAzhd+t1QS506zNTd=
5y0Cxu+NJgrOgizSjsM6VQMZH2sMSKLGTBt9M4kkFoy9FMLN1nINWolJ6fhtFXgOKJr0UpIf9xs=
Gnln6A+V3apqvIG2W/EDB2VaA9d1jPe/7fPbOVSKSJOegSLtF11EvPOlwvwjald09QeoJHYDsST=
+dXS0IE+zgnR/GlQAfIg/IfoSDFINh5htMZ3UDkg9ssVd9g=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3Dg4F0v4TXhVkzuRwLgbfEWUQkfmsL+Uf1rI69FDB8x/8=3D;
 b=3DTuqSH36JyOXmYccLiUXWdFEih5He/146zy7PY2/vd0g6VC/PTWaQFiHts+uuRyJcYKnTRW=
f5+UtbofHWWFYZ5O11xxJvCkGBNuMF20+G7x/HYtz3/W0Djy2WtYCsNU4892Bzp72PRz4MMl/Il=
wWbmbDSddD97KPirj9rKQ4SL4PyskhEalF9gp+b8JyZzdJwUWS65A/DUikIgoAImTNHuL83Qo1o=
nV/Ag8TxdPXhlLiD9knQ61afh+kEMZesJL3c/ZkDtJ41VGGBndZa3ntrzJqc+jZ79GZ8sPg3Hcm=
RjoH5eKw0+iHfEdbRxal2pS+if8CN1RNOAAOOhiOXfwwgqg=3D=3D
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
 bh=3Dg4F0v4TXhVkzuRwLgbfEWUQkfmsL+Uf1rI69FDB8x/8=3D;
 b=3DZP/7DMTGJLB9Yii5sXMLLSiTJTEwT+kEdYoYzl0aGj81F+Dh5bNz2ZpxpgG6OKG/7RH7Di=
fdvlDGg5ioSSL4KWF/dfpgDwucUIToufxWW7twWOS3RzAqReBBqpa83c9GfG8/jtbTIfxTgGCX4=
d2X78viqbON2UTpouGMWD1B19A=3D
Received: from BYAPR06CA0006.namprd06.prod.outlook.com (2603:10b6:a03:d4::1=
9)
 by PH8PR12MB6721.namprd12.prod.outlook.com (2603:10b6:510:1cc::18) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Fri, 29 =
Mar
 2024 22:59:25 +0000
Received: from SJ1PEPF00001CDF.namprd05.prod.outlook.com
 (2603:10b6:a03:d4:cafe::54) by BYAPR06CA0006.outlook.office365.com
 (2603:10b6:a03:d4::19) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Front=
end
 Transport; Fri, 29 Mar 2024 22:59:25 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDF.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 22:59:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 17:59:21 -0500
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|PH8PR12MB6721:EE_
X-MS-Office365-Filtering-Correlation-Id: a9179cff-2565-428c-c1f4-08dc5043e0=
56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N0Q/ob1ES6c3vUyxIlbqNB1kiL8OchYZphqdYFkd=
XJpTeOncGhrxGWgpCPK3lwltWnf6Oi2ReoR2DcLJUy+jBMH9sC0SYt3rWAAol+BcQ7Jhf2NEHsz=
iRkhN1DSQ1Dl+zorUbf0dQl9qJSO9/jFwPuJ53q/yhLZAN9Cx5sipS9ZxyPaBmuhSScBnshrZnT=
UScfBuq6KXgc6hm+a8ba6nC9pw5J/u1BKP6Vi7t4jpT5Pnrv/GYBHQRJ++N5tWPHBFMHwONq3UG=
pHOQEjboXryDCoBsahNlrjw8O9Fhx5u9dfruz5kBDa1M7EXOTC2FRiK0McBIhsrbp/pu/h9xbfi=
Nz/rYkbHHj6+pt2BbW/e0yQzyRRO4fCGwMUyryyv3wV1Y0/CGDHJMwcf/+KEwK5sfbvJzkNIPB9=
BWrvh+J7FBHoLiD1sPPbJM+EwI0hSU/J85LJsGzpGDcmTvkASBALQkAriYslf9x8KopxE/h1aHB=
3jxThDLZZoruvoTKonOZ/K17BI//ZZac0gITuyIqitRIiWcYTmxozfE5O94AO0yXbmGkXAN656j=
wxiw59sppRQWWHK/lxH3E0mDKpu7nZ+dUOb1PO3cTy/3nw0Wn7hTGUEBVAtgazKKPxEh3iUp6pU=
1stIxfRcV6vWBay3UcQ1YVZiEBjzohCsXR2NabzELLKGFdknfV/2XZZHzZk/eUNmjdRmQOIMz6q=
CBgJr4CsQww=3D=3D
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230031)=
(7416005)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 22:59:23.5330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9179cff-2565-428c-c1f4-08dc5=
043e056
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDF.namprd05.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6721
Return-Path: linux-kernel+bounces-125487-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 22:59:53.7218
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 1095868b-7c5a-431c-6ffb-08dc=
5043f242
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-02.secunet.de:TOTAL-HUB=3D0.416|SMR=3D0.329(SMRDE=3D0.005|SMRC=3D0.323(=
SMRCL=3D0.103|X-SMRCR=3D0.322))|CAT=3D0.086(CATOS=3D0.001
 |CATRESL=3D0.029(CATRESLP2R=3D0.020)|CATORES=3D0.051(CATRS=3D0.051(CATRS-T=
ransport
 Rule Agent=3D0.001 (X-ETREX=3D0.001)|CATRS-Index Routing
 Agent=3D0.048))|CATORT=3D0.001(CATRT=3D0.001));2024-03-29T22:59:54.158Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 22023
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-01.secunet.de:TO=
TAL-FE=3D0.020|SMR=3D0.009(SMRPI=3D0.007(SMRPI-FrontendProxyAgent=3D0.007))=
|SMS=3D0.011
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-02
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-02
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAZcVAAAPAAADH4sIAAAAAAAEAMVaC3fb=
tpKmZEuy5Sh23k
 2bdlHf01zb0dtvu+nWcZTWJ35kLSftPdkeLk1CFjeSqCUpO769+VX7
 B3dmQFAgRdl53N3VSSQSHAwGg2++GYD+799euE53iz1z7f/kXps17d
 5Zm/14Km7LHt7+bHStsul0fyrkC/mXbw70ZuON3jx8pe/vvD7c/VVv
 nuwcn7BTfmb3POa3OesYg57ZZn3XMbnnsZbjMqPHoFcJerGzAff8ci
 F/ApKgtWv0LGb3bN82OvbfuccMZrqXfd85c41+2zaZZZ9BBxDt+fy9
 zwYet5jv4L3nuwPTL+RxzC43vIHLu7znM6dFZoiB2BFcu3Ikj5lgCr
 T0mOHDL3z1HRv6nPJCXqruOIZV4T0yg1mGb4B90Bzq/KsnDZZTtbvG
 GS+jf17AZLuOy0EC5t01fNvpMY9z6i1d4PW5abdsk55St6Z91uNWyW
 m1SqeXH70csV47XtuGTi+NjmuwHw26K7/DO6XP267lbrG207HArHPd
 4obp2+eGz/WOY75jF+ga0+h0YCi0V989eE6L/byxe3RwsNds7h0d/j
 Ey9IFttg3eYceOD/Z2xV3ZhTtl6FKpVMizcrlcObddv/LuvFt5v7FW
 AYFSl4PTLkuB09ErLqw5fP7BWH2ZPXmCPQ3XbFMPu2d2BhavDIy+XT
 G8Lqoqt1n0Az3ZBnui9sMRPfzPz8smG/P5B6ut1mHE2KeUqChh3IgB
 NTJghbXsDkAbvNI741aR1TaqABCPuzhVb+HJYhFkLN7h4r60iJiw7F
 aLlUpnts+MynPHHCC4CTIf67/Tz+pWyNs9i79nrXWzWl23lldqtZVy
 2ahVTzdq62ZtrW6xWrW6trJCK/qZthXy4NPPNvDnn1lpZXWzuMae4E
 99lUGL7XkDCODTS4q19mWfu+e2B/EIsds13vFhADOXG9YlERN/z81B
 GIbsmPsDt+dtsSrDuB2YyGBFVurxM7DwnGMrd13HRekntY0yG0eI8L
 h0xQcewz/kQFIQZ9OQGD1BeGiqCVb7GJaC79AxbOgY0CYpEoVVupGM
 iyO+Mlyjy33uemzB7i1uMUGijIHXdSQEr9fXBavpnm+4vuj2CX5B8a
 0t8StDIRhk3BjsT0VWfnR9sLYC7Nyxzcttpb2yxH6hRRSPcHXBRWW2
 VElWssHOHO/84m1t7Y/tUSVHTQYgsU87nF047jvDdQaQJWLaPmyL6T
 QTeJy9hdmUWhcl49T+QyfftwYu5RyL+4bdQdcoWdHu9QfBYrDn/Nw2
 OWQi37VPBz5nO6/2oPlpwgfxRqjfrBY32ZPV6maxVkPUH/MWdwEG3I
 v0RHmIT7T47UXb9nmpb0BA/KEX2VtgzRKaLm4gyox+F0xHvL2FJSrB
 HAbdYC5hLisH8/9IbcWIqqJQrnoK1MX1U3KIDsDavt/3tioVi5/zjg
 NN5SCfVGC5rL4LMKx0uWUblXq1tlyp1Ss7kLAOKDr0Rhgd+m+olHTq
 5+ulV4NTwE65b7WCMcNJhAN6g37fcf1wuBNutoGsvMrq6vraGoZ86e
 WBDgumNyPZXNEZ+OJ6lXUgsWXsyRY8blLJUFstL68sBpqGnmShsouL
 izIk6cH7EiY/xz2rUBHiVdYr6yuVav19dWOndNJ2uoan7/OeZZjvLk
 vgG09/AyQ7wGLL8KH0SfAV2tVzOs7ZpZjNE7RBWbuIDXIy3qXn826F
 Ep3irLWNtarQEkln16Xy0+skZJJar6+erq+aLb7ZapXLy6tVy7JW62
 sr3IglqWv1iXx0rRgG4drmMqYe/NnEGOS9QZeqKbNr6baFdKYQTZMD
 MUNhaXc58jlyARQCbncbykaokc+B3s+BjzHzy9LVOIVmZjum3wEuIj
 KSCmW+2TvcO6kXKQ0pQx2+Ksnicljyqlw2Ll0VBSPFpA6P9YOd3+EZ
 UaCY/EZtAye/Ua8FDBQjd5ebHDKCPuhbWFVS/aw4BBh5uc76hlXfDt
 U++YT8EEkLkWaV6OFBQNrsLxZv2T2RZ3+vQ8DuUtS+bjb05fqzvRN9
 73lTTRkLtdf7++zHH1l1cXzv53vNnWf7Df3Z8dHO892d5on+b6/3jl
 8qvWujNdyYOvR0zAMJ8WVrc329VltbXl2rl8tr5rq5vs6Xl/lafRzE
 Y2piyI49xTWtr+KSwvc6LCjOOkA/7iIgpvuDynvTLbd/Sn4Ea+TzpK
 cWPx2cufyMnj2JPsPR27SlHHaa73YH5fZ8pAkspiY0c5WQBwVfrSqA
 B5RrMsQDoUbQK7f0865n6C2olmBH6G0rq7jzSj9uNBsn+q9H+8/1w5
 2G3njTODyJVw21sV0Omsf6q+Ojk6N4lzrhGEJwx2OiJ1WislJ4Ybvd
 CwNS3c6zvSKDEgPKg3lRgbwiKM8HJYccFuPz1dH+3u7fIAKbL/XmQc
 RKxC0AbaG2tnhVp73DXwCkzaPdl42TYac6IhtDQzpwg/wHRYR+avvb
 wwew59vfOW7ox781GwcLCdvFxYjwi73Dhn7w+qTxO8mCrq7RD+WIOG
 kB15eLG+r69TzaTOIum/Vc3fBsy1MUh887DhS/S6gaRQL9VwsCGXUM
 uxvrQIxDXXBIZBuLI1vCDgLzX1BHLwxZiS3B1+K29Bo1o7sA25isFX
 oLHnZsz9fbsMugq+3h86iNvT6m7MA5myvFGmw8a1Ug1nXFP2QjzKXV
 GXht4Z2FiM+6kMWxuRh1Zdd4T82Lw9Et56KnX7hQCi08HrOcQ+GLU7
 t3bungEKPT0c3+wFtAgVLw2OU+e0qG0f5Ct1rCwoXHtBEIvCX52aba
 RlA77xlQb6Nd8Xp9qNNyMJkuRE4gXugv9l83fy2yQ0BxkSnjBN15x+
 NXKR1rqLI+/Y/2D04JdC8OXSI/fVcH1QvzYP0Wk2azFmwGcPMPfZ7+
 AL80+tMf/vL+33vz1Bo0qTNK0PiD97E6E/ZDAUijC8H+lc0jS82zLT
 Y/Yspwwi5tAvGHUrdAbW1zbR2Dura5jrxcp514gFgLfc59HTc4C0jT
 eFEkwl46NzoKMD8IhUShaPYSOwk363Jbi78GnjECHKlKUo7Yiuwdv/
 RolwG7WwOLDqHG8DzHtGEBLXZh+23lDIAO//C2JbnZd6FI9nBDCYVZ
 R5wlgsMDRaAamVymlTJZGPb1fNjIeIp6abXdU44ihCos+mzIbRj8sP
 s0xJ4SEP7L7snv+u5xY+ekIau3MnWpDBnr3IECcwlXLxhBp3MBHmer
 Yrwug3BiS4Z71se4UwqqQIzWC9xGwDAsyxUnn0/Znx8UPIrRg5GVdl
 xx14yGPCbDDoQNGCePK+gYI3AMzV4tTeWDp8TIBnbVpX91lF745cUr
 /WXj+LCxr+/s7h69PjxRYwXj8ftASTK3IHqRO6J24jzLOGM8rH4KlW
 Tf68N4C1KVMoRrkgD6ik6biKPQp6WfiKEhAlXGUtYT6ArHgR8hPhLp
 xCbmYtJRCAQ/+KC3MP+Cop1Ov2nNw/IiMLWIBv5gsdaFTvrh+goWAG
 HYlydbEzIFrETL5Ty2EAmuGePmYXwrHg9kFBgFz2NZGRKQRSlsFNwo
 siTMToSzRD1yBJUCsHCPfUen9vPuAuZzsWgosX1NOARJIAyJ6ocECJ
 2Z/ntwD4aOgiJQBOMMw1X1mUAezE/mJ+RKnK6sNqL+isKO3KCibWf3
 ZO+NCrXhqia7V91ifSl9/FP9Hdn7ie/Q6cnDjvTq4zmndw1DEWPI7k
 TbZOd48ig1Do9OTv42qsV0+pcQKE5XH3jcXXgshqdUp4MXsFHvQxIU
 4YYTXQQP23/nTmtByC5eOeyLndf7JyP0+tzp/dXHdOhc4Bmo6/UNky
 M9GAm8SydtkPR6rMYUzogedQZlWhSxYziJdndUkqgcBGOL03X+Hipf
 SJPHvDXw6NhasQusgECxMXUbeELKy/NXkEmpsXf4Zmc8n8QtDlJILE
 ESqgnB8aQxMuNPB4BYxHJwJv346q3YR3pUeYVhOVBc9ByIBrHJhW1F
 16aXAQRbKloMhm7uQC0CpSr3v8ij5JbrJ3Vwsvi/PBfc9/ptRNSXIQ
 RJ4TMYWvQLHPCURRyiiEGYmf3LhWAUPIUqStngLhLronHxCyqLyNEd
 e0wDf25tMVypRPXhu6hwr4E1htizmElLcubAAnJRNoxWigmR28L8p8
 417pdoLUBx/EVTHdZRqJXtNPee401yNfVPmmkA1GpAHdFeW4pHxp1G
 DE8gYipFVhOjhVsvQCQd6NAZ8mhypzpep7wUZvWEYww1+Qe/wWFFvb
 q6QmeGtbW6OAT/kpGDj2l4PDx7Pm7sNvbeNPQXe4d7zV+3hlLy4wZV
 kzxwbtk9G3b1Ah6BtYvbo/1OgU3eKesUGTWO/q0EygkQGSmfRkaN95
 KjynuLt4xBxx8zryGfxZ8S5pyBL9ehvkKvwevLa9Xi8rK6ELB2VJbg
 YshUiCXK6JpEjo08Z+Ca4E313Ghk5/+ZJ2j/B6X6uJ0r1X9kf7SG2m
 sNt+oiLYlywRJ/JWQ52NbG7BSvkz6hbKhGhx3ZcXpdfu1e4fqjO4UX
 rjhFU/6OJ9wp4G4tzqK/7Rwf6keHu40FOg+ab4Wk6fIOx5iJHHTMJ1
 cC156njfFYsFRBY5RKr9cZWWEkWvHWTT156EHNrK7omJ3ulcXBaNk5
 erqgIiDgaKLAIEItcKHrXCZEyhV0/NGRIhhis1pcB4ZYqW8Ua/SXMh
 9pQOzzIXJcNzz1REWDXiw/k29gs2F1eBxYCRuuJOSQ6FXJMLGX/AzR
 WwPsDhM+gSH8o5hhqgdEv8Mgxxl8Dyk/CZpRiCYIfFAQS4fRSRZ+ir
 sCwCg96UUGTgLduBiy8TXvGePv1CMP5HvGFaNaMzZqlrV5ulkuG8tm
 bbO6tlI3V9evfc+Y+AY99pRecdQxV8H3esKLY0L1Va9SujZWe5DPfP
 dyGyP7NXjYwL8YRRlG7fgGXch5kdfmgTLAESRD4PLggtTQ32zCPTPP
 XGfQZ4ZpOoOeLzlfqjB8p2ubOio5c+nUGUzW+65zhjw+ckiqEEPwd0
 fiBX3sfDg8Bg3ehUe8AsH4J3q9kK+X66vlmvirHk2b1LI5bSqj5XIp
 7R5eZCe0yQltaiKlfYUX+C+r5aAdvsU1yMNFWpsAmRwJZKgF2me0Gy
 ktXdBuCrFJLQNi09oMPIVH2AWFUduUNg3XQgC+oSWt3Iq+8E+ohX9k
 Q150AVXCsNCAgnY7m9IKZGGauozMKKsKkLYctNwlY0gAHtGIKe2ONp
 nXZoQBuagrbmizsYHQgahnSlg7kbqxREYK+Xva/YlUPq1paW06nE74
 NJW6m9K0lJYNW2T7NxOaNqE9HGn/FuVTWeqVzuDQ0yQ5mU/NisZpbW
 6SzEultDVai4gxY9txCW5oN2+kCllNy8I6JotNJ7enYFKgOkPmpcU1
 zRphI9YdXCoWlzCQFW6f1mZhCsJyeJrT8gAMuMgE88qM4HBJrPtdBZ
 ng0lCzwBW057WCAKqKk4x2I484zGQTED6TbIn2DSI/LvyILu5lhhN8
 RGZnadZzhOcJioj5mA0AGLjOiwgiJwh4Cy+R8hvwPQ1oT30/zqt57T
 tcspQ2g54ESW0KNU/LUbLCddMyNgnMU1d2mZLy06KvtDDsflP2zcHF
 f2hT0xSPtIj5DGE4nAKstVhuIo1wrCx03KVwFh3BwwIGoiOASgiTPW
 jqUoJwJpeCoNYyWiGcIEj+F4nJWEYbxDrCBfyboui7CcErbRMDyTni
 WMshWiSuwhGDgNLSCSGspce0T8QDKlksl9yeyo4uPYEz4Kg8iaW1W2
 Bq6PkMzVTgVngDIDqBfCXAj9c3yJNTdB2F9B1ouRmoBW6fuyKiQfIb
 khTQndRuE0hmkyLlDl3cUaNDiD0igYnANvDz3GRqSvChEHgsBXIENl
 joUCC2IkOGVJZDaRy7FopMLqExlUUWSk0KJwyvEZbTSt9seEvAC27B
 z+qjsFfYmErlRvUPnUyk8Q3FFxg2pRWQJVLaA5pOQKSpewIV4x9NCy
 JS8zWRZCYTpPVg1e6Q8dR3NpAMjMkJgW+lAMXUVFRmOmAwpAjhFuyV
 Q+xRCh5mVZTMIg5zon1WqE3NjHF1RsQvwhJpBCY4LSM66E4m5dXGBz
 KassSlwpNfYfouCMQixWkzYl55NOA22QB8kiGumxWMkU3dGC5KaiIe
 BaR2VqYzYWTIddHb2UkcCH2uuAKLltuS+Se1WxNk/G1SSKkHXHQ3LU
 ehQPh6IpI+hqlQhG0GFwh63ZrEZD2q7Y70YcQMHEK7D4+yRIbwT4pl
 s5Q1KIKmKLiImbWHijDG13j5R4rx4MwZ6n6HPF9AGhfFTCotrinpB4
 6dk/MSeJ4USU1jgi5gHadkZM1oBZn9b4rKTciEJYEAJyWsaZlN8uGj
 UCHI5LU5lYcVgEFBK8g28KoAksRSRmBJgh8gJOao3RraD413qd6+TY
 t1JxydRryVo5T0gIwR8BMD0dDAn1CLfi3IFuvSFNQnabHo+DSVmaVb
 kQGFkVmqUYXO0JNZ1IyzAJCkUeBBGgMZsB1UMsLsXLBkwB5IqiFsgA
 bSIpVrD0HsPukU1uaoUprUviWDb4cBUgjmngl9RRi4Kwa6ERZFxGB5
 gWpRw8jYEZL3pCdxuCARzKFmEVmpqdAhooCZQfvvTIr0PRwI+U0oLA
 wLhowaR1MIIfRPVoGisgm6ark/fjoP5XSE5kxQfBaSciiMe4umNpcm
 U2VCh1EeZBGHyBKTmL4FfWUFP8+SN8LwmSS4ZnGZoMsDwVoQFCATQp
 H8KSqNNAHgXlr6h/z5SCUQCRKxQZsShYf4phLrIQ30L0r3vBo75Dea
 0VDg63A6ZOr0SN75ZtSAMOQFJwgYg/0k/0jYIBhbKFQy3cNP0kbLES
 hEerkSeLRqlOwISOTtXLDxDC5uXx22UQxMZWizqYZtaHkMLWI50kE5
 BML3YUYphEea4pQhwxNO5HCFEFdy351NHEt4Q8ioFUVIFInDZVM5UT
 UpjbfVjDxBdAFmiHC7JaejRpxgrTDQZOjJjVVqejSbiPrhI3TOCrK9
 P6xpH6aol4LVrJwsBM7cZMLO9KtUlCtiXQDbVMzQpj7JWlFXCGsfKZ
 ErK5nA5mCHi7UKeozaC+OLnNufykuxhEUyd4c1pLSHWu7GgzdY6NlY
 hooQckIhNDda1ahHLrRGc4LipiU+BRTpqAcA/11SYfMVOeFR0qP70T
 3XXCyXqQar9EU1m5jjDYGBm0EK/nSHp/LjMDBGc3lYLcs0mhXFWyQj
 PExHkTChfR/4LSD2yTCKZeUzLQ6yUtp3We0x+C1pIBblh8L/9xYsE/
 XznFrAy/1FXsBPqJVnMneFZA4xPCkvcrI6yuUhpeICoTHTWHWI/HhH
 sCXB4FZYMU6KIiGgoBlhpNgs4PX/AFRqziAVQQAAAQrDAzw/eG1sIH
 ZlcnNpb249IjEuMCIgZW5jb2Rpbmc9InV0Zi0xNiI/Pg0KPEVtYWls
 U2V0Pg0KICA8VmVyc2lvbj4xNS4wLjAuMDwvVmVyc2lvbj4NCiAgPE
 VtYWlscz4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iMjEiPg0KICAg
 ICAgPEVtYWlsU3RyaW5nPmJyaWplc2guc2luZ2hAYW1kLmNvbTwvRW
 1haWxTdHJpbmc+DQogICAgPC9FbWFpbD4NCiAgICA8RW1haWwgU3Rh
 cnRJbmRleD0iNDczIiBQb3NpdGlvbj0iT3RoZXIiPg0KICAgICAgPE
 VtYWlsU3RyaW5nPmFzaGlzaC5rYWxyYUBhbWQuY29tPC9FbWFpbFN0
 cmluZz4NCiAgICA8L0VtYWlsPg0KICAgIDxFbWFpbCBTdGFydEluZG
 V4PSI1OTYiIFBvc2l0aW9uPSJPdGhlciI+DQogICAgICA8RW1haWxT
 dHJpbmc+bWljaGFlbC5yb3RoQGFtZC5jb208L0VtYWlsU3RyaW5nPg
 0KICAgIDwvRW1haWw+DQogIDwvRW1haWxzPg0KPC9FbWFpbFNldD4B
 DJ0FPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTE2Ij
 8+DQo8Q29udGFjdFNldD4NCiAgPFZlcnNpb24+MTUuMC4wLjA8L1Zl
 cnNpb24+DQogIDxDb250YWN0cz4NCiAgICA8Q29udGFjdCBTdGFydE
 luZGV4PSI2Ij4NCiAgICAgIDxQZXJzb24gU3RhcnRJbmRleD0iNiI+
 DQogICAgICAgIDxQZXJzb25TdHJpbmc+QnJpamVzaCBTaW5naDwvUG
 Vyc29uU3RyaW5nPg0KICAgICAgPC9QZXJzb24+DQogICAgICA8QnVz
 aW5lc3MgU3RhcnRJbmRleD0iMTA5Ij4NCiAgICAgICAgPEJ1c2luZX
 NzU3RyaW5nPlNOUDwvQnVzaW5lc3NTdHJpbmc+DQogICAgICA8L0J1
 c2luZXNzPg0KICAgICAgPEVtYWlscz4NCiAgICAgICAgPEVtYWlsIF
 N0YXJ0SW5kZXg9IjIxIj4NCiAgICAgICAgICA8RW1haWxTdHJpbmc+
 YnJpamVzaC5zaW5naEBhbWQuY29tPC9FbWFpbFN0cmluZz4NCiAgIC
 AgICAgPC9FbWFpbD4NCiAgICAgIDwvRW1haWxzPg0KICAgICAgPENv
 bnRhY3RTdHJpbmc+QnJpamVzaCBTaW5naCAmbHQ7YnJpamVzaC5zaW
 5naEBhbWQuY29tJmd0Ow0KDQpLVk1fU0VWX1NOUF9MQVVOQ0hfU1RB
 UlQgYmVnaW5zIHRoZSBsYXVuY2ggcHJvY2VzcyBmb3IgYW4gU0VWLV
 NOUDwvQ29udGFjdFN0cmluZz4NCiAgICA8L0NvbnRhY3Q+DQogIDwv
 Q29udGFjdHM+DQo8L0NvbnRhY3RTZXQ+AQ7QAVJldHJpZXZlck9wZX
 JhdG9yLDEwLDA7UmV0cmlldmVyT3BlcmF0b3IsMTEsNDtQb3N0RG9j
 UGFyc2VyT3BlcmF0b3IsMTAsMTtQb3N0RG9jUGFyc2VyT3BlcmF0b3
 IsMTEsMDtQb3N0V29yZEJyZWFrZXJEaWFnbm9zdGljT3BlcmF0b3Is
 MTAsMTA7UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLD
 ExLDA7VHJhbnNwb3J0V3JpdGVyUHJvZHVjZXIsMjAsMTI=3D
X-MS-Exchange-Forest-IndexAgent: 1 6878
X-MS-Exchange-Forest-EmailMessageHash: 10974F98
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

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

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documen=
tation/virt/kvm/x86/amd-memory-encryption.rst
index f7c007d34114..a10b817c162d 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -459,6 +459,25 @@ issued by the hypervisor to make the guest ready for e=
xecution.
=20
 Returns: 0 on success, -negative on error
=20
+18. KVM_SEV_SNP_LAUNCH_START
+----------------------------
+
+The KVM_SNP_LAUNCH_START command is used for creating the memory encryptio=
n
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
+                __u8 gosvw[16];         /* Guest OS visible workarounds. *=
/
+        };
+
+See the SEV-SNP spec [snp-fw-abi]_ for further detail on the launch input.
+
 Device attribute API
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
@@ -490,9 +509,11 @@ References
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
=20
-See [white-paper]_, [api-spec]_, [amd-apm]_ and [kvm-forum]_ for more info=
.
+See [white-paper]_, [api-spec]_, [amd-apm]_, [kvm-forum]_, and [snp-fw-abi=
]_
+for more info.
=20
 .. [white-paper] https://developer.amd.com/wordpress/media/2013/12/AMD_Mem=
ory_Encryption_Whitepaper_v7-Public.pdf
 .. [api-spec] https://support.amd.com/TechDocs/55766_SEV-KM_API_Specificat=
ion.pdf
 .. [amd-apm] https://support.amd.com/TechDocs/24593.pdf (section 15.34)
 .. [kvm-forum]  https://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendac=
ky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
+.. [snp-fw-abi] https://www.amd.com/system/files/TechDocs/56860.pdf
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 725b75cfe9ff..350ddd5264ea 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -693,6 +693,9 @@ enum sev_cmd_id {
 	/* Second time is the charm; improved versions of the above ioctls.  */
 	KVM_SEV_INIT2,
=20
+	/* SNP-specific commands */
+	KVM_SEV_SNP_LAUNCH_START,
+
 	KVM_SEV_NR_MAX,
 };
=20
@@ -818,6 +821,11 @@ struct kvm_sev_receive_update_data {
 	__u32 pad2;
 };
=20
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u8 gosvw[16];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
=20
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3d9771163562..6c7c77e33e62 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -25,6 +25,7 @@
 #include <asm/fpu/xcr.h>
 #include <asm/fpu/xstate.h>
 #include <asm/debugreg.h>
+#include <asm/sev.h>
=20
 #include "mmu.h"
 #include "x86.h"
@@ -58,6 +59,10 @@ static u64 sev_supported_vmsa_features;
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
=20
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
=20
+static int snp_decommission_context(struct kvm *kvm);
+
 struct enc_region {
 	struct list_head list;
 	unsigned long npages;
@@ -94,12 +101,17 @@ static int sev_flush_asids(unsigned int min_asid, unsi=
gned int max_asid)
 	down_write(&sev_deactivate_lock);
=20
 	wbinvd_on_all_cpus();
-	ret =3D sev_guest_df_flush(&error);
+
+	if (sev_snp_enabled)
+		ret =3D sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, &error);
+	else
+		ret =3D sev_guest_df_flush(&error);
=20
 	up_write(&sev_deactivate_lock);
=20
 	if (ret)
-		pr_err("SEV: DF_FLUSH failed, ret=3D%d, error=3D%#x\n", ret, error);
+		pr_err("SEV%s: DF_FLUSH failed, ret=3D%d, error=3D%#x\n",
+		       sev_snp_enabled ? "-SNP" : "", ret, error);
=20
 	return ret;
 }
@@ -1967,6 +1979,102 @@ int sev_dev_get_attr(u64 attr, u64 *val)
 	}
 }
=20
+/*
+ * The guest context contains all the information, keys and metadata
+ * associated with the guest that the firmware tracks to implement SEV
+ * and SNP features. The firmware stores the guest context in hypervisor
+ * provide page via the SNP_GCTX_CREATE command.
+ */
+static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct sev_data_snp_addr data =3D {};
+	void *context;
+	int rc;
+
+	/* Allocate memory for context page */
+	context =3D snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
+	if (!context)
+		return NULL;
+
+	data.address =3D __psp_pa(context);
+	rc =3D __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &arg=
p->error);
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
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_activate data =3D {0};
+
+	data.gctx_paddr =3D __psp_pa(sev->snp_context);
+	data.asid =3D sev_get_asid(kvm);
+	return sev_issue_cmd(kvm, SEV_CMD_SNP_ACTIVATE, &data, error);
+}
+
+static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_start start =3D {0};
+	struct kvm_sev_snp_launch_start params;
+	int rc;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	/* Don't allow userspace to allocate memory for more than 1 SNP context. =
*/
+	if (sev->snp_context) {
+		pr_debug("SEV-SNP context already exists. Refusing to allocate an additi=
onal one.");
+		return -EINVAL;
+	}
+
+	sev->snp_context =3D snp_context_create(kvm, argp);
+	if (!sev->snp_context)
+		return -ENOTTY;
+
+	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET) {
+		pr_debug("SEV-SNP hypervisor does not support limiting guests to a singl=
e socket.");
+		return -EINVAL;
+	}
+
+	if (!(params.policy & SNP_POLICY_MASK_SMT)) {
+		pr_debug("SEV-SNP hypervisor does not support limiting guests to a singl=
e SMT thread.");
+		return -EINVAL;
+	}
+
+	start.gctx_paddr =3D __psp_pa(sev->snp_context);
+	start.policy =3D params.policy;
+	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
+	rc =3D __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &a=
rgp->error);
+	if (rc) {
+		pr_debug("SEV_CMD_SNP_LAUNCH_START command failed, rc %d\n", rc);
+		goto e_free_context;
+	}
+
+	sev->fd =3D argp->sev_fd;
+	rc =3D snp_bind_asid(kvm, &argp->error);
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
@@ -2054,6 +2162,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *a=
rgp)
 	case KVM_SEV_RECEIVE_FINISH:
 		r =3D sev_receive_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r =3D snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r =3D -EINVAL;
 		goto out;
@@ -2249,6 +2360,33 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, un=
signed int source_fd)
 	return ret;
 }
=20
+static int snp_decommission_context(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_addr data =3D {};
+	int ret;
+
+	/* If context is not created then do nothing */
+	if (!sev->snp_context)
+		return 0;
+
+	data.address =3D __sme_pa(sev->snp_context);
+	down_write(&sev_deactivate_lock);
+	ret =3D sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
+	if (WARN_ONCE(ret, "failed to release guest context")) {
+		up_write(&sev_deactivate_lock);
+		return ret;
+	}
+
+	up_write(&sev_deactivate_lock);
+
+	/* free the context page now */
+	snp_free_firmware_page(sev->snp_context);
+	sev->snp_context =3D NULL;
+
+	return 0;
+}
+
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
@@ -2290,7 +2428,15 @@ void sev_vm_destroy(struct kvm *kvm)
 		}
 	}
=20
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
=20
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
=20
 struct kvm_svm {
--=20
2.25.1



