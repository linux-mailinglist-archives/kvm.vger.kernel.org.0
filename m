Return-Path: <kvm+bounces-13206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 871EF89336B
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C73FC1F226FA
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0F7148854;
	Sun, 31 Mar 2024 16:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zw5+RhL/"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85639146A88;
	Sun, 31 Mar 2024 16:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711902743; cv=fail; b=Uh2NgStjcSWJ5AC4AQziqMj/EkEemuMA4f5LNvIP6nk1qCNp4nSbDCnCGbVCcwWz5eP+konJRBafWDz85aSAhJfzTmrfnmgJDABP8h4KZl92aclqwnOqbB2q5FY4TVzA7ij6X41qeMpIJEdUDLdTx9dsXiJO8/aDlBLVa9PFtOk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711902743; c=relaxed/simple;
	bh=JxQGMoMv3QSbtvLnVoXmyvOsb9Bg+6ww+Txc3tjqNFI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VjJZ45SrlKaF+R5D2F4UJ2Brm6V2+GYUQSEB0132janqjcrSbaMMxDWUoP7UgpUJhxYB67hfoqM4kVg/BES6bRw5iBej8OeKmeYDB+aVSa1KIbycDZTdD1uODVIzVxB1hZrrZtsqSn3QnWvEDBSJlcQv8eo7rdBphgrP2fD7mzg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zw5+RhL/ reason="signature verification failed"; arc=fail smtp.client-ip=40.107.243.48; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 1ADD8207BB;
	Sun, 31 Mar 2024 18:32:18 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9ZB_cXIBB25U; Sun, 31 Mar 2024 18:32:16 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 05062207C6;
	Sun, 31 Mar 2024 18:32:16 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 05062207C6
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id 8689580004A;
	Sun, 31 Mar 2024 18:26:30 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:26:30 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:23:35 +0000
X-sender: <linux-crypto+bounces-3095-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAPDFCS25BAlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAwAAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAEJTp8x1Q3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgAdAAAAjYoAAAUABAAUIAEAAAAcAAAAc3RlZmZlbi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg==
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 29696
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.199.223; helo=ny.mirrors.kernel.org; envelope-from=linux-crypto+bounces-3095-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com D29732087D
X-Original-To: linux-crypto@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753336; cv=fail; b=LzVM2oPKxcDMPhTGrN1EjkcJHNwS3bh+14wE3eIZAlJcRpZ7fViydGmITkkNSe8XdfvC3xvChzx8OBTDynOtxHCmdWezcu5S7Dq9sVn5pZrUfVrtHU8hLP2DTEkow3G+9GQeOf7uuaruamqj7HblM3eLI9JBtPEJe6L6IfchT5k=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753336; c=relaxed/simple;
	bh=ve0Q/9IkEDuMVauLWMMuYGROPkz8VDXCebbb2IciUSs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m4D9/d/1CgNnpUIXnIDmC2BOqXfLvwWQE5n+ZA+DbK77nW1C3Gq/zLoGVjYJD1/X1NedCKLg6IqZSPipXMyBrCxPdo4/HVpFBHPSJYkuDjnrmZY9Wuca7bQBJBYJ7HwfvE9hBP4nosUGj9Hm+UQqsjhqtaqFMPvbH6J9Dzl87c4=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zw5+RhL/; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rpv0NaEcWWmOacEWTJ4zXiLzuFIvhF2pgNzp6IXt+9RIVisgGJK/84XT195gmZgaB6bW/Jelueaazeq5ZGNQkOcWEt0QZJMBz4ceYMBXPXx8aNGhDdcx2RThLdqEanGR4/Y5HLyV0tROWvkbeHUURtdLSthwd30o6EGkEWi2FEe4dUvKI8tifAgUN0MD4EMCmAF5qzBHcM+XCHaCKXu9W8HK7hljQIZ/SGX1fvtWmjFpzTDsxWYWtV1pNl4UU4/L27x57bT7+tfALgs8/bUGVRdCboU/1nMCQEUARiZkwltyFuUkDPvqxy7C9kRSUG6EbtyBC2Uw0sHyoSNa+r3YzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aREpckIK1aTtdsTDTyZ9MXdMoxILhHALRKMNW8mq2U4=;
 b=JyShgHcZa2/wma0PqUHAezNHvPONlHryO8/XJB1I50gnnfxl57oFiWU9/wHoVVmqKtNAmbMEqDws0sNbUmQdLKdYvDX8KOXqiwgGZ5ItdSaTdW/hVRFsmTBSoNbqdPnj1B8AdltPC1n+HdqzfZzgurDzO0CylqwZk75MdK4+xiUUjoMv8PsYAbh0RISnlEuZKdeEYhyqnKtAJ+kWpJFukP8S0JfNY50G4S5e1V5VJMJRpzixURLISWViF222MI8R6S+WQg938MqizQF/+d4OBkjUK+Zb54xcLAcgaB5WCpFDRnSe2RhlrwTlHbJ4lbVwKWCIFLoNtRKfXsXhUVRH4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aREpckIK1aTtdsTDTyZ9MXdMoxILhHALRKMNW8mq2U4=;
 b=zw5+RhL/bwPs4XPGs8H1awi574VvDZOke4fiosae+nVYgXxK3ZQB45aDqrxVN5DHDKXl7Shji5iXQVxjNKXJod67K1kmhzWGQ5lEqQQidigjKYIoL7zsO9fG5TZk8w1DmfuO5IEzGLcDKiiPO513qLKjuoFmKnmLnkv2EOGR9Xc=
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
Subject: [PATCH v12 17/29] KVM: SEV: Add support to handle RMP nested page faults
Date: Fri, 29 Mar 2024 17:58:23 -0500
Message-ID: <20240329225835.400662-18-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE0:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 28caeec9-eaaa-4720-7f97-08dc5044445d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JXTCISndS2/r5x6NMJ2t51Vfu/p6ZmdNWROhuaETSgas9t4XpeEnKggbccuOh7Q+j+6ibsqRa10T6H+RNY/f7HovlDKdRM/wNfHnuxFCPsZ1gh6AiyjHtHZN4EZ2PLlUmQ90dvSUfdVy+1kAAusLmfVCZf59F4BZNReSwwjSihPdwVwSFllZSq582E2WT80rAqlcmuio+b2fZleaW5lP+scaBjnoY1wi3IC4CvKrwM2OQ5U2tfSboz1tzbhquIVdcUgyeulo5Iub4yHrEdlDmJPb1K0Edzo25153XHHRyqHeAaDOOEJt2x5/aDcRU9U38Qx9KSQRY/Djcy9kc7RzY7IRKLjH3XRsmWiLh/27noGI41o9DlAy3/3lidY9/kmDiMdbdDz1pwncBITDWkznU2rBxDb4b5ogSI+Hrvfuy3o2MzNdiIfswSUM/Iw+a/nxja45nLrfM+NyMztnK2extIPkV9UZaGw6yVTBQ21iYqDlCT2txUgbQEPJ+PftUWsXsTjF1hBEfmu07FvQdvieUKOgYsyG4LCBifEr8aJBh4ETKlfuMYVIUbOSRnYYFvALURQQwP6VG5Vv/7UiZrnVaeS8teVws3JcH6k5U7eg42YN4aD9Ucv1ImJHU8BtYr/QLLY/8/H/+PThTFCmnKDgkd2ySOnuz2XqMkYTTZ8QKQ/hxcGDPYcEJRCSpXamJXssFD0CU4VYsq9C3230r2w28ZYLzVfsQv1V00F+qLQ1NQK64I/hVdR//ANKXyKG/AAP
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:02:11.3650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28caeec9-eaaa-4720-7f97-08dc5044445d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CE0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

From: Brijesh Singh <brijesh.singh@amd.com>

When SEV-SNP is enabled in the guest, the hardware places restrictions
on all memory accesses based on the contents of the RMP table. When
hardware encounters RMP check failure caused by the guest memory access
it raises the #NPF. The error code contains additional information on
the access type. See the APM volume 2 for additional information.

When using gmem, RMP faults resulting from mismatches between the state
in the RMP table vs. what the guest expects via its page table result
in KVM_EXIT_MEMORY_FAULTs being forwarded to userspace to handle. This
means the only expected case that needs to be handled in the kernel is
when the page size of the entry in the RMP table is larger than the
mapping in the nested page table, in which case a PSMASH instruction
needs to be issued to split the large RMP entry into individual 4K
entries so that subsequent accesses can succeed.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h |   3 ++
 arch/x86/kvm/svm/sev.c     | 103 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     |  21 ++++++--
 arch/x86/kvm/svm/svm.h     |   3 ++
 4 files changed, 126 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 780182cda3ab..234a998e2d2d 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -91,6 +91,9 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 /* RMUPDATE detected 4K page and 2MB page overlap. */
 #define RMPUPDATE_FAIL_OVERLAP		4
=20
+/* PSMASH failed due to concurrent access by another CPU */
+#define PSMASH_FAIL_INUSE		3
+
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
 #define RMP_PG_SIZE_2M			1
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c35ed9d91c89..a0a88471f9ab 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3397,6 +3397,13 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 v=
alue)
 	svm->vmcb->control.ghcb_gpa =3D value;
 }
=20
+static int snp_rmptable_psmash(kvm_pfn_t pfn)
+{
+	pfn =3D pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+
+	return psmash(pfn);
+}
+
 static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
@@ -3956,3 +3963,99 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vc=
pu)
=20
 	return p;
 }
+
+void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code=
)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm *kvm =3D vcpu->kvm;
+	int order, rmp_level, ret;
+	bool assigned;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+
+	gfn =3D gpa >> PAGE_SHIFT;
+
+	/*
+	 * The only time RMP faults occur for shared pages is when the guest is
+	 * triggering an RMP fault for an implicit page-state change from
+	 * shared->private. Implicit page-state changes are forwarded to
+	 * userspace via KVM_EXIT_MEMORY_FAULT events, however, so RMP faults
+	 * for shared pages should not end up here.
+	 */
+	if (!kvm_mem_is_private(kvm, gfn)) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault for non-private GPA 0x%ll=
x\n",
+				    gpa);
+		return;
+	}
+
+	slot =3D gfn_to_memslot(kvm, gfn);
+	if (!kvm_slot_can_be_private(slot)) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, non-private slot for GPA=
 0x%llx\n",
+				    gpa);
+		return;
+	}
+
+	ret =3D kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order);
+	if (ret) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for priv=
ate GPA 0x%llx\n",
+				    gpa);
+		return;
+	}
+
+	ret =3D snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
+	if (ret || !assigned) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry fo=
und for GPA 0x%llx PFN 0x%llx error %d\n",
+				    gpa, pfn, ret);
+		goto out;
+	}
+
+	/*
+	 * There are 2 cases where a PSMASH may be needed to resolve an #NPF
+	 * with PFERR_GUEST_RMP_BIT set:
+	 *
+	 * 1) RMPADJUST/PVALIDATE can trigger an #NPF with PFERR_GUEST_SIZEM
+	 *    bit set if the guest issues them with a smaller granularity than
+	 *    what is indicated by the page-size bit in the 2MB RMP entry for
+	 *    the PFN that backs the GPA.
+	 *
+	 * 2) Guest access via NPT can trigger an #NPF if the NPT mapping is
+	 *    smaller than what is indicated by the 2MB RMP entry for the PFN
+	 *    that backs the GPA.
+	 *
+	 * In both these cases, the corresponding 2M RMP entry needs to
+	 * be PSMASH'd to 512 4K RMP entries.  If the RMP entry is already
+	 * split into 4K RMP entries, then this is likely a spurious case which
+	 * can occur when there are concurrent accesses by the guest to a 2MB
+	 * GPA range that is backed by a 2MB-aligned PFN who's RMP entry is in
+	 * the process of being PMASH'd into 4K entries. These cases should
+	 * resolve automatically on subsequent accesses, so just ignore them
+	 * here.
+	 */
+	if (rmp_level =3D=3D PG_LEVEL_4K) {
+		pr_debug_ratelimited("%s: Spurious RMP fault for GPA 0x%llx, error_code =
0x%llx",
+				     __func__, gpa, error_code);
+		goto out;
+	}
+
+	pr_debug_ratelimited("%s: Splitting 2M RMP entry for GPA 0x%llx, error_co=
de 0x%llx",
+			     __func__, gpa, error_code);
+	ret =3D snp_rmptable_psmash(pfn);
+	if (ret && ret !=3D PSMASH_FAIL_INUSE) {
+		/*
+		 * Look it up again. If it's 4K now then the PSMASH may have raced with
+		 * another process and the issue has already resolved itself.
+		 */
+		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) && assigned &&
+		    rmp_level =3D=3D PG_LEVEL_4K) {
+			pr_debug_ratelimited("%s: PSMASH for GPA 0x%llx failed with ret %d due =
to potential race",
+					     __func__, gpa, ret);
+			goto out;
+		}
+		pr_err_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x=
%llx ret %d\n",
+				   gpa, pfn, ret);
+	}
+
+	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
+out:
+	put_page(pfn_to_page(pfn));
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2c162f6a1d78..648a05ca53fc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2043,15 +2043,28 @@ static int pf_interception(struct kvm_vcpu *vcpu)
 static int npf_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
+	int rc;
=20
 	u64 fault_address =3D svm->vmcb->control.exit_info_2;
 	u64 error_code =3D svm->vmcb->control.exit_info_1;
=20
 	trace_kvm_page_fault(vcpu, fault_address, error_code);
-	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
-			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
-			svm->vmcb->control.insn_bytes : NULL,
-			svm->vmcb->control.insn_len);
+	rc =3D kvm_mmu_page_fault(vcpu, fault_address, error_code,
+				static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
+				svm->vmcb->control.insn_bytes : NULL,
+				svm->vmcb->control.insn_len);
+
+	/*
+	 * rc =3D=3D 0 indicates a userspace exit is needed to handle page
+	 * transitions, so do that first before updating the RMP table.
+	 */
+	if (error_code & PFERR_GUEST_RMP_MASK) {
+		if (rc =3D=3D 0)
+			return rc;
+		sev_handle_rmp_fault(vcpu, fault_address, error_code);
+	}
+
+	return rc;
 }
=20
 static int db_interception(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bb04d63012b4..c0675ff2d8a2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -722,6 +722,7 @@ void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
+void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code=
);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -735,6 +736,8 @@ static inline void sev_hardware_unsetup(void) {}
 static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
 static inline int sev_dev_get_attr(u64 attr, u64 *val) { return -ENXIO; }
 #define max_sev_asid 0
+static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, =
u64 error_code) {}
+
 #endif
=20
 /* vmenter.S */
--=20
2.25.1


X-sender: <linux-kernel+bounces-125497-steffen.klassert=3Dsecunet.com@vger.=
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
X-ExtendedProps: BQBjAAoAEJTp8x1Q3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgAfAAAAjYoAAAUABAAUIAEAAAAcAAAAc3RlZmZl=
bi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQA=
CAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg=3D=3D
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 29656
Received: from cas-essen-01.secunet.de (10.53.40.201) by
 mbx-dresden-01.secunet.de (10.53.40.199) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:02:52 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:02:52 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 89E3B20882
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:02:52 +0100 (CET)
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
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wHNyzjsIKDhp for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:02:51 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D139.178.88.99; helo=3Dsv.mirrors.kernel.org; envelope-from=3Dlinux-kerne=
l+bounces-125497-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 793422087D
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 793422087D
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:02:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A6352832F1
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECE2213F006;
	Fri, 29 Mar 2024 23:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"zw5+RhL/"
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12=
on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A08713E414;
	Fri, 29 Mar 2024 23:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.243.48
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753336; cv=3Dfail; b=3DLzVM2oPKxcDMPhTGrN1EjkcJHNwS3bh+14wE3eIZAlJ=
cRpZ7fViydGmITkkNSe8XdfvC3xvChzx8OBTDynOtxHCmdWezcu5S7Dq9sVn5pZrUfVrtHU8hLP=
2DTEkow3G+9GQeOf7uuaruamqj7HblM3eLI9JBtPEJe6L6IfchT5k=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753336; c=3Drelaxed/simple;
	bh=3Dve0Q/9IkEDuMVauLWMMuYGROPkz8VDXCebbb2IciUSs=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3Dm4D9/d/1CgNnpUIXnIDmC2BOqXfLvwWQE5n+ZA+DbK=
77nW1C3Gq/zLoGVjYJD1/X1NedCKLg6IqZSPipXMyBrCxPdo4/HVpFBHPSJYkuDjnrmZY9Wuca7=
bQBJBYJ7HwfvE9hBP4nosUGj9Hm+UQqsjhqtaqFMPvbH6J9Dzl87c4=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3Dzw5+RhL/; arc=3Dfail smtp.client-ip=3D40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DRpv0NaEcWWmOacEWTJ4zXiLzuFIvhF2pgNzp6IXt+9RIVisgGJK/84XT195gmZgaB6bW/J=
elueaazeq5ZGNQkOcWEt0QZJMBz4ceYMBXPXx8aNGhDdcx2RThLdqEanGR4/Y5HLyV0tROWvkbe=
HUURtdLSthwd30o6EGkEWi2FEe4dUvKI8tifAgUN0MD4EMCmAF5qzBHcM+XCHaCKXu9W8HK7hlj=
QIZ/SGX1fvtWmjFpzTDsxWYWtV1pNl4UU4/L27x57bT7+tfALgs8/bUGVRdCboU/1nMCQEUARiZ=
kwltyFuUkDPvqxy7C9kRSUG6EbtyBC2Uw0sHyoSNa+r3YzA=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DaREpckIK1aTtdsTDTyZ9MXdMoxILhHALRKMNW8mq2U4=3D;
 b=3DJyShgHcZa2/wma0PqUHAezNHvPONlHryO8/XJB1I50gnnfxl57oFiWU9/wHoVVmqKtNAmb=
MEqDws0sNbUmQdLKdYvDX8KOXqiwgGZ5ItdSaTdW/hVRFsmTBSoNbqdPnj1B8AdltPC1n+Hdqzf=
ZzgurDzO0CylqwZk75MdK4+xiUUjoMv8PsYAbh0RISnlEuZKdeEYhyqnKtAJ+kWpJFukP8S0JfN=
Y50G4S5e1V5VJMJRpzixURLISWViF222MI8R6S+WQg938MqizQF/+d4OBkjUK+Zb54xcLAcgaB5=
WCpFDRnSe2RhlrwTlHbJ4lbVwKWCIFLoNtRKfXsXhUVRH4Q=3D=3D
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
 bh=3DaREpckIK1aTtdsTDTyZ9MXdMoxILhHALRKMNW8mq2U4=3D;
 b=3Dzw5+RhL/bwPs4XPGs8H1awi574VvDZOke4fiosae+nVYgXxK3ZQB45aDqrxVN5DHDKXl7S=
hji5iXQVxjNKXJod67K1kmhzWGQ5lEqQQidigjKYIoL7zsO9fG5TZk8w1DmfuO5IEzGLcDKiiPO=
513qLKjuoFmKnmLnkv2EOGR9Xc=3D
Received: from SJ0PR03CA0276.namprd03.prod.outlook.com (2603:10b6:a03:39e::=
11)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Fri, 29 =
Mar
 2024 23:02:11 +0000
Received: from SJ1PEPF00001CE0.namprd05.prod.outlook.com
 (2603:10b6:a03:39e:cafe::9a) by SJ0PR03CA0276.outlook.office365.com
 (2603:10b6:a03:39e::11) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Front=
end
 Transport; Fri, 29 Mar 2024 23:02:11 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE0.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:02:11 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:02:09 -0500
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
Subject: [PATCH v12 17/29] KVM: SEV: Add support to handle RMP nested page =
faults
Date: Fri, 29 Mar 2024 17:58:23 -0500
Message-ID: <20240329225835.400662-18-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE0:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 28caeec9-eaaa-4720-7f97-08dc504444=
5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JXTCISndS2/r5x6NMJ2t51Vfu/p6ZmdNWROhuaET=
Sgas9t4XpeEnKggbccuOh7Q+j+6ibsqRa10T6H+RNY/f7HovlDKdRM/wNfHnuxFCPsZ1gh6Aiyj=
HtHZN4EZ2PLlUmQ90dvSUfdVy+1kAAusLmfVCZf59F4BZNReSwwjSihPdwVwSFllZSq582E2WT8=
0rAqlcmuio+b2fZleaW5lP+scaBjnoY1wi3IC4CvKrwM2OQ5U2tfSboz1tzbhquIVdcUgyeulo5=
Iub4yHrEdlDmJPb1K0Edzo25153XHHRyqHeAaDOOEJt2x5/aDcRU9U38Qx9KSQRY/Djcy9kc7Rz=
Y7IRKLjH3XRsmWiLh/27noGI41o9DlAy3/3lidY9/kmDiMdbdDz1pwncBITDWkznU2rBxDb4b5o=
gSI+Hrvfuy3o2MzNdiIfswSUM/Iw+a/nxja45nLrfM+NyMztnK2extIPkV9UZaGw6yVTBQ21iYq=
DlCT2txUgbQEPJ+PftUWsXsTjF1hBEfmu07FvQdvieUKOgYsyG4LCBifEr8aJBh4ETKlfuMYVIU=
bOSRnYYFvALURQQwP6VG5Vv/7UiZrnVaeS8teVws3JcH6k5U7eg42YN4aD9Ucv1ImJHU8BtYr/Q=
LLY/8/H/+PThTFCmnKDgkd2ySOnuz2XqMkYTTZ8QKQ/hxcGDPYcEJRCSpXamJXssFD0CU4VYsq9=
C3230r2w28ZYLzVfsQv1V00F+qLQ1NQK64I/hVdR//ANKXyKG/AAP
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(7416005)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:02:11.3650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28caeec9-eaaa-4720-7f97-08dc5=
044445d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CE0.namprd05.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
Return-Path: linux-kernel+bounces-125497-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:02:52.5860
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: bd609fe2-c0bb-4657-f0c0-08dc=
50445cde
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-dr=
esden-01.secunet.de:TOTAL-HUB=3D0.455|SMR=3D0.363(SMRDE=3D0.035|SMRC=3D0.32=
8(SMRCL=3D0.104|X-SMRCR=3D0.328))|CAT=3D0.090(CATOS=3D0.017
 (CATSM=3D0.017(CATSM-Malware
 Agent=3D0.016))|CATRESL=3D0.041(CATRESLP2R=3D0.019)|CATORES=3D0.030
 (CATRS=3D0.029(CATRS-Index Routing Agent=3D0.028)));2024-03-29T23:02:53.04=
1Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-dresden-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 20168
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-01.secunet.de:TO=
TAL-FE=3D0.007|SMR=3D0.006(SMRPI=3D0.004(SMRPI-FrontendProxyAgent=3D0.004))
X-MS-Exchange-Organization-AVStamp-Enterprise: 1.0
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Organization-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAQISAAAPAAADH4sIAAAAAAAEAL06a3Pb=
RpLgW6Iky46dy2
 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
 ac1bTINlLp8ZhTnqxyKT4vsvyXpb6YYPkKLjA27zgt8hKZ9MJYquNd
 C59bzYISC3n57yqVcxyo2eTyeAUuFimmQVk+TwgS/4QoluLL14UCyc
 uWRUGFnyMf7Irk2CpiJBEZ2QkyPlFWqzltBciWN+U0By4c/wvgNFJn
 DTcAAAEC2AI8P3htbCB2ZXJzaW9uPSIxLjAiIGVuY29kaW5nPSJ1dG
 YtMTYiPz4NCjxUYXNrU2V0Pg0KICA8VmVyc2lvbj4xNS4wLjAuMDwv
 VmVyc2lvbj4NCiAgPFRhc2tzPg0KICAgIDxUYXNrIFN0YXJ0SW5kZX
 g9IjgyOCI+DQogICAgICA8VGFza1N0cmluZz5uZWVkcyB0byBiZSBp
 c3N1ZWQgdG8gc3BsaXQgdGhlIGxhcmdlIFJNUCBlbnRyeSBpbnRvIG
 luZGl2aWR1YWwgNEs8L1Rhc2tTdHJpbmc+DQogICAgICA8QXNzaWdu
 ZWVzPg0KICAgICAgICA8RW1haWxVc2VyIElkPSJrdm1Admdlci5rZX
 JuZWwub3JnIiAvPg0KICAgICAgPC9Bc3NpZ25lZXM+DQogICAgPC9U
 YXNrPg0KICA8L1Rhc2tzPg0KPC9UYXNrU2V0PgEKxQM8P3htbCB2ZX
 JzaW9uPSIxLjAiIGVuY29kaW5nPSJ1dGYtMTYiPz4NCjxFbWFpbFNl
 dD4NCiAgPFZlcnNpb24+MTUuMC4wLjA8L1ZlcnNpb24+DQogIDxFbW
 FpbHM+DQogICAgPEVtYWlsIFN0YXJ0SW5kZXg9IjIxIj4NCiAgICAg
 IDxFbWFpbFN0cmluZz5icmlqZXNoLnNpbmdoQGFtZC5jb208L0VtYW
 lsU3RyaW5nPg0KICAgIDwvRW1haWw+DQogICAgPEVtYWlsIFN0YXJ0
 SW5kZXg9IjEwMzMiIFBvc2l0aW9uPSJPdGhlciI+DQogICAgICA8RW
 1haWxTdHJpbmc+bWljaGFlbC5yb3RoQGFtZC5jb208L0VtYWlsU3Ry
 aW5nPg0KICAgIDwvRW1haWw+DQogICAgPEVtYWlsIFN0YXJ0SW5kZX
 g9IjExMzciIFBvc2l0aW9uPSJPdGhlciI+DQogICAgICA8RW1haWxT
 dHJpbmc+YXNoaXNoLmthbHJhQGFtZC5jb208L0VtYWlsU3RyaW5nPg
 0KICAgIDwvRW1haWw+DQogIDwvRW1haWxzPg0KPC9FbWFpbFNldD4B
 Ds8BUmV0cmlldmVyT3BlcmF0b3IsMTAsMDtSZXRyaWV2ZXJPcGVyYX
 RvciwxMSwxO1Bvc3REb2NQYXJzZXJPcGVyYXRvciwxMCwwO1Bvc3RE
 b2NQYXJzZXJPcGVyYXRvciwxMSwwO1Bvc3RXb3JkQnJlYWtlckRpYW
 dub3N0aWNPcGVyYXRvciwxMCwzO1Bvc3RXb3JkQnJlYWtlckRpYWdu
 b3N0aWNPcGVyYXRvciwxMSwwO1RyYW5zcG9ydFdyaXRlclByb2R1Y2 VyLDIwLDE0
X-MS-Exchange-Forest-IndexAgent: 1 5637
X-MS-Exchange-Forest-EmailMessageHash: F8649D9E
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

From: Brijesh Singh <brijesh.singh@amd.com>

When SEV-SNP is enabled in the guest, the hardware places restrictions
on all memory accesses based on the contents of the RMP table. When
hardware encounters RMP check failure caused by the guest memory access
it raises the #NPF. The error code contains additional information on
the access type. See the APM volume 2 for additional information.

When using gmem, RMP faults resulting from mismatches between the state
in the RMP table vs. what the guest expects via its page table result
in KVM_EXIT_MEMORY_FAULTs being forwarded to userspace to handle. This
means the only expected case that needs to be handled in the kernel is
when the page size of the entry in the RMP table is larger than the
mapping in the nested page table, in which case a PSMASH instruction
needs to be issued to split the large RMP entry into individual 4K
entries so that subsequent accesses can succeed.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h |   3 ++
 arch/x86/kvm/svm/sev.c     | 103 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     |  21 ++++++--
 arch/x86/kvm/svm/svm.h     |   3 ++
 4 files changed, 126 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 780182cda3ab..234a998e2d2d 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -91,6 +91,9 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 /* RMUPDATE detected 4K page and 2MB page overlap. */
 #define RMPUPDATE_FAIL_OVERLAP		4
=20
+/* PSMASH failed due to concurrent access by another CPU */
+#define PSMASH_FAIL_INUSE		3
+
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
 #define RMP_PG_SIZE_2M			1
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c35ed9d91c89..a0a88471f9ab 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3397,6 +3397,13 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 v=
alue)
 	svm->vmcb->control.ghcb_gpa =3D value;
 }
=20
+static int snp_rmptable_psmash(kvm_pfn_t pfn)
+{
+	pfn =3D pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+
+	return psmash(pfn);
+}
+
 static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
@@ -3956,3 +3963,99 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vc=
pu)
=20
 	return p;
 }
+
+void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code=
)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm *kvm =3D vcpu->kvm;
+	int order, rmp_level, ret;
+	bool assigned;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+
+	gfn =3D gpa >> PAGE_SHIFT;
+
+	/*
+	 * The only time RMP faults occur for shared pages is when the guest is
+	 * triggering an RMP fault for an implicit page-state change from
+	 * shared->private. Implicit page-state changes are forwarded to
+	 * userspace via KVM_EXIT_MEMORY_FAULT events, however, so RMP faults
+	 * for shared pages should not end up here.
+	 */
+	if (!kvm_mem_is_private(kvm, gfn)) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault for non-private GPA 0x%ll=
x\n",
+				    gpa);
+		return;
+	}
+
+	slot =3D gfn_to_memslot(kvm, gfn);
+	if (!kvm_slot_can_be_private(slot)) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, non-private slot for GPA=
 0x%llx\n",
+				    gpa);
+		return;
+	}
+
+	ret =3D kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order);
+	if (ret) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for priv=
ate GPA 0x%llx\n",
+				    gpa);
+		return;
+	}
+
+	ret =3D snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
+	if (ret || !assigned) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry fo=
und for GPA 0x%llx PFN 0x%llx error %d\n",
+				    gpa, pfn, ret);
+		goto out;
+	}
+
+	/*
+	 * There are 2 cases where a PSMASH may be needed to resolve an #NPF
+	 * with PFERR_GUEST_RMP_BIT set:
+	 *
+	 * 1) RMPADJUST/PVALIDATE can trigger an #NPF with PFERR_GUEST_SIZEM
+	 *    bit set if the guest issues them with a smaller granularity than
+	 *    what is indicated by the page-size bit in the 2MB RMP entry for
+	 *    the PFN that backs the GPA.
+	 *
+	 * 2) Guest access via NPT can trigger an #NPF if the NPT mapping is
+	 *    smaller than what is indicated by the 2MB RMP entry for the PFN
+	 *    that backs the GPA.
+	 *
+	 * In both these cases, the corresponding 2M RMP entry needs to
+	 * be PSMASH'd to 512 4K RMP entries.  If the RMP entry is already
+	 * split into 4K RMP entries, then this is likely a spurious case which
+	 * can occur when there are concurrent accesses by the guest to a 2MB
+	 * GPA range that is backed by a 2MB-aligned PFN who's RMP entry is in
+	 * the process of being PMASH'd into 4K entries. These cases should
+	 * resolve automatically on subsequent accesses, so just ignore them
+	 * here.
+	 */
+	if (rmp_level =3D=3D PG_LEVEL_4K) {
+		pr_debug_ratelimited("%s: Spurious RMP fault for GPA 0x%llx, error_code =
0x%llx",
+				     __func__, gpa, error_code);
+		goto out;
+	}
+
+	pr_debug_ratelimited("%s: Splitting 2M RMP entry for GPA 0x%llx, error_co=
de 0x%llx",
+			     __func__, gpa, error_code);
+	ret =3D snp_rmptable_psmash(pfn);
+	if (ret && ret !=3D PSMASH_FAIL_INUSE) {
+		/*
+		 * Look it up again. If it's 4K now then the PSMASH may have raced with
+		 * another process and the issue has already resolved itself.
+		 */
+		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) && assigned &&
+		    rmp_level =3D=3D PG_LEVEL_4K) {
+			pr_debug_ratelimited("%s: PSMASH for GPA 0x%llx failed with ret %d due =
to potential race",
+					     __func__, gpa, ret);
+			goto out;
+		}
+		pr_err_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x=
%llx ret %d\n",
+				   gpa, pfn, ret);
+	}
+
+	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
+out:
+	put_page(pfn_to_page(pfn));
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2c162f6a1d78..648a05ca53fc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2043,15 +2043,28 @@ static int pf_interception(struct kvm_vcpu *vcpu)
 static int npf_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
+	int rc;
=20
 	u64 fault_address =3D svm->vmcb->control.exit_info_2;
 	u64 error_code =3D svm->vmcb->control.exit_info_1;
=20
 	trace_kvm_page_fault(vcpu, fault_address, error_code);
-	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
-			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
-			svm->vmcb->control.insn_bytes : NULL,
-			svm->vmcb->control.insn_len);
+	rc =3D kvm_mmu_page_fault(vcpu, fault_address, error_code,
+				static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
+				svm->vmcb->control.insn_bytes : NULL,
+				svm->vmcb->control.insn_len);
+
+	/*
+	 * rc =3D=3D 0 indicates a userspace exit is needed to handle page
+	 * transitions, so do that first before updating the RMP table.
+	 */
+	if (error_code & PFERR_GUEST_RMP_MASK) {
+		if (rc =3D=3D 0)
+			return rc;
+		sev_handle_rmp_fault(vcpu, fault_address, error_code);
+	}
+
+	return rc;
 }
=20
 static int db_interception(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bb04d63012b4..c0675ff2d8a2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -722,6 +722,7 @@ void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
+void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code=
);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -735,6 +736,8 @@ static inline void sev_hardware_unsetup(void) {}
 static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
 static inline int sev_dev_get_attr(u64 attr, u64 *val) { return -ENXIO; }
 #define max_sev_asid 0
+static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, =
u64 error_code) {}
+
 #endif
=20
 /* vmenter.S */
--=20
2.25.1



