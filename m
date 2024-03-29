Return-Path: <kvm+bounces-13236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 548EE8934F2
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:18:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 746021C23EE6
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7610148827;
	Sun, 31 Mar 2024 16:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pVQbPIWb"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058BE1465B0;
	Sun, 31 Mar 2024 16:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903641; cv=fail; b=rj6KpQurpPv9t16H0cF4Q0G2Gk4WlBrpdor72XHhCFnCmkuq1G93ylkTVz13zx5X2B1b2AQtwO4C4HILAi+u+8uIDK70P21ZwSrDNiI4dtgCLfNeeLe1lJjrlVnDFATbrrmzOV8O0uKsLuxtRSpHs4bZLk0VDslrY1TvLPRaToc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903641; c=relaxed/simple;
	bh=xuYbFPeVPDBp/bSWDDuwFyAyAVIgE5nOY7qlKsPnmvM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X6CIiVTbMRXqbYSXa+Au9Nz9Y67VLkIU2OtWI3fpAE5BORbbW9BapEZE2sBPr89xgwAKr5E96AsHbEP3vK0mwM22hYGWluqc+sPw4sVWpuzcq66Eq5GG3fm75qVYWWgDQ5AfvKyIYfZAKpGB1jBsdrBTVm3WynBg+G7BTY3xxHU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pVQbPIWb reason="signature verification failed"; arc=fail smtp.client-ip=40.107.101.48; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 9C5FF2084C;
	Sun, 31 Mar 2024 18:47:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oLrIFc9wglF9; Sun, 31 Mar 2024 18:47:16 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id F1D22201C7;
	Sun, 31 Mar 2024 18:47:15 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com F1D22201C7
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id BCD4680005A;
	Sun, 31 Mar 2024 18:40:24 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:24 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:44 +0000
X-sender: <linux-crypto+bounces-3106-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com;
 X-ExtendedProps=DwA1AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLklzUmVzb3VyY2UCAAAFABUAFgACAAAABQAUABEA8MUJLbkECUOS0gjaDTZ+uAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAGwAAgAABQBYABcASgAAAPDFCS25BAlDktII2g02frhDTj1LbGFzc2VydCBTdGVmZmVuLE9VPVVzZXJzLE9VPU1pZ3JhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAMAAIAAAUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoA6kmmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2VjdW5ldC5jb20FAAYAAgABDwAqAAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5SZXN1Ym1pdENvdW50BwACAAAADwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBiAAoATgAAAM6KAAAFAGQADwADAAAASHViBQApAAIAAQ8APwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRGlyZWN0b3J5RGF0YS5NYWlsRGVsaXZlcnlQcmlvcml0eQ8AAwAAAExvdw==
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 22703
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.80.249; helo=am.mirrors.kernel.org; envelope-from=linux-crypto+bounces-3106-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 01E05200BB
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pVQbPIWb"
X-Original-To: linux-crypto@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.48
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753565; cv=fail; b=nySl60dntVQyPamC5zHokQ59i8eUA14VcdmUSIxZVrv4o47wSi2elTNxC+0KAI+xBvRR1sZ2v8HUEYX4B2acaXAd+qH0TnIR7Q7+sZsumOQ9ZNju1Fx6OSRxJjn4j0p84rj90JPzlqxNnU9GHhvHZNXZWDRlF+W/GuH+aAiTJug=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753565; c=relaxed/simple;
	bh=1mt+dPqGVGgxhVCKEG3pXqMiUa4XApuT0BM0owhsWto=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MiA9QHfN5QPr81nmkTuaS5BtC7vny4OCpm2fNYUYj783qUCLSPRTm9S1SoUx3OCOiP2TV1katS6TRLP7s1Hn+O7vKGjZzdlBAc0uDl496/6oAq8XFpbE1NnIimM/kIBiMn52lb2Ivs1No1ZN9z6NUmFXuH98rYfvzDBSIsRaAAQ=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pVQbPIWb; arc=fail smtp.client-ip=40.107.101.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=imaqi7zO++Pueh1kiczxyzbdLQbAvufU75qRWyu2zj1Gky5hCoS3w+yInJ0L3dUXfuaFx9DN08KYjvM03AxEFOUF1M700WDoWkkppUeah6369frkyhubt9gmIPSzEJupYZDwODCSA7DU2A/QdTKWtIvajcJYH+UfhcoaOwL8rbBfvy2IZTm7BukJIUrD6yjpky4ro99oL7ugAgDAIYnTLgywKVhVkw3JZA2jDJmw3s1UPHwouImDX6DyfV8MusvmSstKSkVyQDunHM7KEzBPEyneL7ih4zbEvEb1YRSzyQce/Swsfc3YtoduzRQ9kO36itueeu7Kz2yuT97MVHXOXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFi7FUdlAWZbxIeQZPeXjgozeEMcnuRszCmTYDdmjJw=;
 b=jr3CpJ2B9ia9wR1FHBCqA3R/rAM6kID2KydtbDP63g9WFvHXi453xc7V7PwiJhBUZYCUj89Xzes5WQvlV0sh/cFMXbKXRy3Ym5LJIngzSC3Vqj55baspbaJHUWtMWx1OUZraxO/2tnABuT/ZhXYqfWXp3U/8WNP/DhkXylSlqMqcIGJ1rp2fZI7/9h6kK6I3pO9kIh3sw/VP9XIA4Q9tdF4fcH+MxqkCVJkBSj7eWj6ZKV9UQ8CPArPPbdh1+nqisbzHp5SyIalfBZnmAv2U/QkEVLAntvMg8ecAQE9lvv9LUqwM6UbuPL2wpiGXvA/uDycwDsIEV1wxijg+TN3tMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFi7FUdlAWZbxIeQZPeXjgozeEMcnuRszCmTYDdmjJw=;
 b=pVQbPIWbese89EZLyabCbuNSndnvJlEBLQ0FbXJsU/BU5bRdWBMXFlEV5gp+Ry0aZm+Qr6tDyl90OpotfnuRujcOYxMvAlkxrHJvJLYBQCU7ctGa6tenr4X0tdWCCVzDbi7ndk8u5ZUER2aAQ944jHEIlPJOWvsMJVItu6bqIwY=
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
Subject: [PATCH v12 27/29] crypto: ccp: Add the SNP_VLEK_LOAD command
Date: Fri, 29 Mar 2024 17:58:33 -0500
Message-ID: <20240329225835.400662-28-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017094:EE_|DS0PR12MB6389:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c5ce47d-5076-4cef-2387-08dc5044cd0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M108XjrRq0MG2qHrQcGm9f5QoZTpFMpGESUVMEAwEi0Jg/7J8Sx0JfHp3iC8H9S89d26XnzK5RVaR+N6ZfBRD7fWFThxq8QMDl68ulJk2Mf74+t6uO5YrRyhRhGmhr4yV/FrtLRjhb0oVT9g6eoMg4qUNl56tP7p0Krb8gQXsV1NVbL38MQrAiRhb3Y3OZ2XOQiASoe36x+FrWtjv17hp2luILOtcD49WV56UuLNfoTkyMu2hja3vxe8rGXeY6Sf8VqdOWqCz2lXkkVeVDW3NsxzZthoO860rK1TI9ukxS7YiyieJ7TFE7mWV02s5//sfWqDQEzl2784/fSh1eGv3Hp9Yt24EmhxIkqfkxCrV1JpR91l5nCDMwm/MxcL9VqtfoZowhaf9TiT2WXqATZoAMuxhmdA2nHqXz/7pIKpcA2ZYz80Cj0NrJ7fxQIiOGV/WYLsdspbT0crbgqWrSC947+aQzX3g192HkGgthx9y0Vt/xC26IOIGJq4DAI5cBLoAfwrUI5I87osChI5eKSPC9yb9tdrG3NBWVv5rihbacgKtUF9N3oe6SpKfBllelkVPDKY9NAZedjB9+W5QTua9kkbKUWCihKwymTqhwX21WuOjeGGRkq0V8uvQu6vITHwXdcMeuhXZn7ECZfLVvq7zLSf2T5+QxW0AocGlILVlcHt9omD7TQJLkhluUkwsSy+zCjBpvKY+PNuAyzevoWp7/aDmFS5H30wB41TKsS3LdL66ZIodV4x0jQ2fT+hIy4G
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(376005)(82310400014)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:06:00.7175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5ce47d-5076-4cef-2387-08dc5044cd0d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017094.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6389
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

When requesting an attestation report a guest is able to specify whether
it wants SNP firmware to sign the report using either a Versioned Chip
Endorsement Key (VCEK), which is derived from chip-unique secrets, or a
Versioned Loaded Endorsement Key (VLEK) which is obtained from an AMD
Key Derivation Service (KDS) and derived from seeds allocated to
enrolled cloud service providers (CSPs).

For VLEK keys, an SNP_VLEK_LOAD SNP firmware command is used to load
them into the system after obtaining them from the KDS. Add a
corresponding userspace interface so to allow the loading of VLEK keys
into the system.

See SEV-SNP Firmware ABI 1.54, SNP_VLEK_LOAD for more details.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 36 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h | 27 +++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2102377f727b..97a7959406ee 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2027,6 +2027,39 @@ static int sev_ioctl_do_snp_set_config(struct sev_is=
sue_cmd *argp, bool writable
 	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
 }
=20
+static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool wri=
table)
+{
+	struct sev_device *sev =3D psp_master->sev_data;
+	struct sev_user_data_snp_vlek_load input;
+	void *blob;
+	int ret;
+
+	if (!sev->snp_initialized || !argp->data)
+		return -EINVAL;
+
+	if (!writable)
+		return -EPERM;
+
+	if (copy_from_user(&input, u64_to_user_ptr(argp->data), sizeof(input)))
+		return -EFAULT;
+
+	if (input.len !=3D sizeof(input) || input.vlek_wrapped_version !=3D 0)
+		return -EINVAL;
+
+	blob =3D psp_copy_user_blob(input.vlek_wrapped_address,
+				  sizeof(struct sev_user_data_snp_wrapped_vlek_hashstick));
+	if (IS_ERR(blob))
+		return PTR_ERR(blob);
+
+	input.vlek_wrapped_address =3D __psp_pa(blob);
+
+	ret =3D __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
+
+	kfree(blob);
+
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long=
 arg)
 {
 	void __user *argp =3D (void __user *)arg;
@@ -2087,6 +2120,9 @@ static long sev_ioctl(struct file *file, unsigned int=
 ioctl, unsigned long arg)
 	case SNP_SET_CONFIG:
 		ret =3D sev_ioctl_do_snp_set_config(&input, writable);
 		break;
+	case SNP_VLEK_LOAD:
+		ret =3D sev_ioctl_do_snp_vlek_load(&input, writable);
+		break;
 	default:
 		ret =3D -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index b7a2c2ee35b7..2289b7c76c59 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -31,6 +31,7 @@ enum {
 	SNP_PLATFORM_STATUS,
 	SNP_COMMIT,
 	SNP_SET_CONFIG,
+	SNP_VLEK_LOAD,
=20
 	SEV_MAX,
 };
@@ -214,6 +215,32 @@ struct sev_user_data_snp_config {
 	__u8 rsvd1[52];
 } __packed;
=20
+/**
+ * struct sev_data_snp_vlek_load - SNP_VLEK_LOAD structure
+ *
+ * @len: length of the command buffer read by the PSP
+ * @vlek_wrapped_version: version of wrapped VLEK hashstick (Must be 0h)
+ * @rsvd: reserved
+ * @vlek_wrapped_address: address of a wrapped VLEK hashstick
+ *                        (struct sev_user_data_snp_wrapped_vlek_hashstick=
)
+ */
+struct sev_user_data_snp_vlek_load {
+	__u32 len;				/* In */
+	__u8 vlek_wrapped_version;		/* In */
+	__u8 rsvd[3];				/* In */
+	__u64 vlek_wrapped_address;		/* In */
+} __packed;
+
+/**
+ * struct sev_user_data_snp_vlek_wrapped_vlek_hashstick - Wrapped VLEK dat=
a
+ *
+ * @data: Opaque data provided by AMD KDS (as described in SEV-SNP Firmwar=
e ABI
+ *        1.54, SNP_VLEK_LOAD)
+ */
+struct sev_user_data_snp_wrapped_vlek_hashstick {
+	__u8 data[432];				/* In */
+} __packed;
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
--=20
2.25.1


X-sender: <linux-kernel+bounces-125510-steffen.klassert=3Dsecunet.com@vger.=
kernel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=3Drfc822;steffen.klassert@=
secunet.com NOTIFY=3DNEVER; X-ExtendedProps=3DDwA1AAAATWljcm9zb2Z0LkV4Y2hhb=
mdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLklzUmVzb3VyY2UCAAAFABUAFgACAAAABQAUABEA=
8MUJLbkECUOS0gjaDTZ+uAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQB=
HAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3=
VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4Y=
wUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5n=
ZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl=
2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ0=
49Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAH=
QAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5z=
cG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAGw=
AAgAABQBYABcASgAAAPDFCS25BAlDktII2g02frhDTj1LbGFzc2VydCBTdGVmZmVuLE9VPVVzZX=
JzLE9VPU1pZ3JhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAMAAIAAAUAJgACAAEFACIADwAxAAAAQ=
XV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8ALwAAAE1p=
Y3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmV=
yc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ=3D=3D
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoA6kmmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2Vj=
dW5ldC5jb20FAAYAAgABDwAqAAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5SZXN1Ym1=
pdENvdW50BwACAAAADwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAg=
ABBQBiAAoATwAAAM6KAAAFAGQADwADAAAASHViBQApAAIAAQ8APwAAAE1pY3Jvc29mdC5FeGNoY=
W5nZS5UcmFuc3BvcnQuRGlyZWN0b3J5RGF0YS5NYWlsRGVsaXZlcnlQcmlvcml0eQ8AAwAAAExv=
dw=3D=3D
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 22661
Received: from cas-essen-01.secunet.de (10.53.40.201) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:06:39 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:06:39 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id 9C3452032C
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:06:39 +0100 (CET)
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
	with ESMTP id l4pwceeobCkH for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:06:39 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.199.223; helo=3Dny.mirrors.kernel.org; envelope-from=3Dlinux-kern=
el+bounces-125510-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com CF6F6200BB
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"pVQbPIWb"
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223=
])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id CF6F6200BB
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:06:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D67FB1C2146E
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F404B13F435;
	Fri, 29 Mar 2024 23:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"pVQbPIWb"
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04=
on2048.outbound.protection.outlook.com [40.107.101.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807FB4B5DA;
	Fri, 29 Mar 2024 23:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.101.48
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753565; cv=3Dfail; b=3DnySl60dntVQyPamC5zHokQ59i8eUA14VcdmUSIxZVrv=
4o47wSi2elTNxC+0KAI+xBvRR1sZ2v8HUEYX4B2acaXAd+qH0TnIR7Q7+sZsumOQ9ZNju1Fx6OS=
RxJjn4j0p84rj90JPzlqxNnU9GHhvHZNXZWDRlF+W/GuH+aAiTJug=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753565; c=3Drelaxed/simple;
	bh=3D1mt+dPqGVGgxhVCKEG3pXqMiUa4XApuT0BM0owhsWto=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DMiA9QHfN5QPr81nmkTuaS5BtC7vny4OCpm2fNYUYj7=
83qUCLSPRTm9S1SoUx3OCOiP2TV1katS6TRLP7s1Hn+O7vKGjZzdlBAc0uDl496/6oAq8XFpbE1=
NnIimM/kIBiMn52lb2Ivs1No1ZN9z6NUmFXuH98rYfvzDBSIsRaAAQ=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3DpVQbPIWb; arc=3Dfail smtp.client-ip=3D40.107.101.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3Dimaqi7zO++Pueh1kiczxyzbdLQbAvufU75qRWyu2zj1Gky5hCoS3w+yInJ0L3dUXfuaFx9=
DN08KYjvM03AxEFOUF1M700WDoWkkppUeah6369frkyhubt9gmIPSzEJupYZDwODCSA7DU2A/Qd=
TKWtIvajcJYH+UfhcoaOwL8rbBfvy2IZTm7BukJIUrD6yjpky4ro99oL7ugAgDAIYnTLgywKVhV=
kw3JZA2jDJmw3s1UPHwouImDX6DyfV8MusvmSstKSkVyQDunHM7KEzBPEyneL7ih4zbEvEb1YRS=
zyQce/Swsfc3YtoduzRQ9kO36itueeu7Kz2yuT97MVHXOXg=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DCFi7FUdlAWZbxIeQZPeXjgozeEMcnuRszCmTYDdmjJw=3D;
 b=3Djr3CpJ2B9ia9wR1FHBCqA3R/rAM6kID2KydtbDP63g9WFvHXi453xc7V7PwiJhBUZYCUj8=
9Xzes5WQvlV0sh/cFMXbKXRy3Ym5LJIngzSC3Vqj55baspbaJHUWtMWx1OUZraxO/2tnABuT/Zh=
XYqfWXp3U/8WNP/DhkXylSlqMqcIGJ1rp2fZI7/9h6kK6I3pO9kIh3sw/VP9XIA4Q9tdF4fcH+M=
xqkCVJkBSj7eWj6ZKV9UQ8CPArPPbdh1+nqisbzHp5SyIalfBZnmAv2U/QkEVLAntvMg8ecAQE9=
lvv9LUqwM6UbuPL2wpiGXvA/uDycwDsIEV1wxijg+TN3tMA=3D=3D
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
 bh=3DCFi7FUdlAWZbxIeQZPeXjgozeEMcnuRszCmTYDdmjJw=3D;
 b=3DpVQbPIWbese89EZLyabCbuNSndnvJlEBLQ0FbXJsU/BU5bRdWBMXFlEV5gp+Ry0aZm+Qr6=
tDyl90OpotfnuRujcOYxMvAlkxrHJvJLYBQCU7ctGa6tenr4X0tdWCCVzDbi7ndk8u5ZUER2aAQ=
944jHEIlPJOWvsMJVItu6bqIwY=3D
Received: from DM5PR08CA0040.namprd08.prod.outlook.com (2603:10b6:4:60::29)=
 by
 DS0PR12MB6389.namprd12.prod.outlook.com (2603:10b6:8:cf::9) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA=
384) id
 15.20.7409.32; Fri, 29 Mar 2024 23:06:01 +0000
Received: from DS1PEPF00017094.namprd03.prod.outlook.com
 (2603:10b6:4:60:cafe::4f) by DM5PR08CA0040.outlook.office365.com
 (2603:10b6:4:60::29) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Front=
end
 Transport; Fri, 29 Mar 2024 23:06:01 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017094.mail.protection.outlook.com (10.167.17.137) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:06:00 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:06:00 -0500
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
Subject: [PATCH v12 27/29] crypto: ccp: Add the SNP_VLEK_LOAD command
Date: Fri, 29 Mar 2024 17:58:33 -0500
Message-ID: <20240329225835.400662-28-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017094:EE_|DS0PR12MB6389:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c5ce47d-5076-4cef-2387-08dc5044cd=
0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M108XjrRq0MG2qHrQcGm9f5QoZTpFMpGESUVMEAw=
Ei0Jg/7J8Sx0JfHp3iC8H9S89d26XnzK5RVaR+N6ZfBRD7fWFThxq8QMDl68ulJk2Mf74+t6uO5=
YrRyhRhGmhr4yV/FrtLRjhb0oVT9g6eoMg4qUNl56tP7p0Krb8gQXsV1NVbL38MQrAiRhb3Y3OZ=
2XOQiASoe36x+FrWtjv17hp2luILOtcD49WV56UuLNfoTkyMu2hja3vxe8rGXeY6Sf8VqdOWqCz=
2lXkkVeVDW3NsxzZthoO860rK1TI9ukxS7YiyieJ7TFE7mWV02s5//sfWqDQEzl2784/fSh1eGv=
3Hp9Yt24EmhxIkqfkxCrV1JpR91l5nCDMwm/MxcL9VqtfoZowhaf9TiT2WXqATZoAMuxhmdA2nH=
qXz/7pIKpcA2ZYz80Cj0NrJ7fxQIiOGV/WYLsdspbT0crbgqWrSC947+aQzX3g192HkGgthx9y0=
Vt/xC26IOIGJq4DAI5cBLoAfwrUI5I87osChI5eKSPC9yb9tdrG3NBWVv5rihbacgKtUF9N3oe6=
SpKfBllelkVPDKY9NAZedjB9+W5QTua9kkbKUWCihKwymTqhwX21WuOjeGGRkq0V8uvQu6vITHw=
XdcMeuhXZn7ECZfLVvq7zLSf2T5+QxW0AocGlILVlcHt9omD7TQJLkhluUkwsSy+zCjBpvKY+PN=
uAyzevoWp7/aDmFS5H30wB41TKsS3LdL66ZIodV4x0jQ2fT+hIy4G
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(36860700004)(1800799015)(376005)(82310400014)(7416005);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:06:00.7175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5ce47d-5076-4cef-2387-08dc5=
044cd0d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017094.namprd03.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6389
Return-Path: linux-kernel+bounces-125510-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:06:39.6710
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: e96fe527-a006-49ca-5d2b-08dc=
5044e439
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-02.secunet.de:TOTAL-HUB=3D33145.636|SMR=3D0.142(SMRDE=3D0.003|SMRC=3D0.=
138(SMRCL=3D0.103|X-SMRCR=3D0.138))|CAT=3D0.076(CATOS=3D0.001
 |CATRESL=3D0.028(CATRESLP2R=3D0.022)|CATORES=3D0.043(CATRS=3D0.043(CATRS-T=
ransport
 Rule Agent=3D0.001 (X-ETREX=3D0.001)|CATRS-Index Routing
 Agent=3D0.041)))|QDM=3D13523.031|SMSC=3D0.582(X-SMSDR=3D0.020
 )|SMS=3D5.485(SMSMBXD-INC=3D4.967)|QDM=3D19611.141|CAT=3D0.016(CATMS=3D0.0=
03|CATRESL=3D0.010(CATRESLP2R=3D0.007
 ))|UNK=3D0.001|QDM=3D5.237|CAT=3D0.176(CATRESL=3D0.175(CATRESLP2R=3D0.021)=
);2024-03-30T08:19:05.324Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 15889
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-01.secunet.de:TO=
TAL-FE=3D0.015|SMR=3D0.010(SMRPI=3D0.007(SMRPI-FrontendProxyAgent=3D0.007))=
|SMS=3D0.005
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-02
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-02
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAV4JAAAPAAADH4sIAAAAAAAEAK1Xe0/b=
WBa/zsMhhtBS+u
 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
 CpjpgBvwXAFg8LsM1EHqkA3ENyjbQvwKFKBIlMRQFilmErCQKjV8pL
 hTEZsoJSJOKsxpZyJAfOJ8gEpsnn6OkCW1xQSipjKluYQlaYfK5AHF
 leUdEeJSPXZI+aUL5gORlr8hdDgFeEFYEcYTvHHqhKYZllCKuspASy
 B8RF26KK2QIa7yfCn6eES+SnCH8izzWUM5clSKO1wuaQ954keDEcQc
 L/Pgm5R2YsZfAqD5T3WG4+ugLhgMzDDCp6Aes8W4ZwA2qLJIFsLkiW
 pI6IsUAJ+Txmz+UVVkSz5bkGLuQwW/JYj8o8Bf2hJM7F4OQiFfkhYl
 ZNcC6nPJIZVWSPQRckhBrh9lRSypjm2PKwXm0uDgpcZRV1PEaP4hjl
 oj4wRy4/RDlsmYK1CL85wq1IoaEt3KpYQXhSkK0gyx7koqs5WoD84n
 iOERT5H5a5KMkWo0R6JhNgLDPniOUvFPF8qpyfSPqxZFMT+gJ7TlF7
 RurUdCWOlnBciWPnkytxjKww+VyBtIE+m5MoDdZo530gW6ZmpbKlOP
 OXUoAspZxdimQqi9jWlLwUKNeD0lbY01ReUfZm49qfV9kjSfOYaJLE
 SHfIInuUpQhKPGVviWcBWKWlkjnq53H2zkuyDE2fOXZvnDKBqMj+Pr
 0KlqeU/AMy4G8ZLPZsSviz+IQwYS9hm6UyjwmeZnCYPpZia6OzQCpd
 iOYjtQ7pshyvchhlaFDKoZYaMffHRszidL+eSCMxB9DIgUlxV1SpOl
 RNeSSDSzMli+v/AbeVQTFLGQAAAQrwATw/eG1sIHZlcnNpb249IjEu
 MCIgZW5jb2Rpbmc9InV0Zi0xNiI/Pg0KPEVtYWlsU2V0Pg0KICA8Vm
 Vyc2lvbj4xNS4wLjAuMDwvVmVyc2lvbj4NCiAgPEVtYWlscz4NCiAg
 ICA8RW1haWwgU3RhcnRJbmRleD0iNzIwIiBQb3NpdGlvbj0iU2lnbm
 F0dXJlIj4NCiAgICAgIDxFbWFpbFN0cmluZz5taWNoYWVsLnJvdGhA
 YW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD4NCiAgPC
 9FbWFpbHM+DQo8L0VtYWlsU2V0PgEMsAQ8P3htbCB2ZXJzaW9uPSIx
 LjAiIGVuY29kaW5nPSJ1dGYtMTYiPz4NCjxDb250YWN0U2V0Pg0KIC
 A8VmVyc2lvbj4xNS4wLjAuMDwvVmVyc2lvbj4NCiAgPENvbnRhY3Rz
 Pg0KICAgIDxDb250YWN0IFN0YXJ0SW5kZXg9IjcwNiIgUG9zaXRpb2
 49IlNpZ25hdHVyZSI+DQogICAgICA8UGVyc29uIFN0YXJ0SW5kZXg9
 IjcwNiIgUG9zaXRpb249IlNpZ25hdHVyZSI+DQogICAgICAgIDxQZX
 Jzb25TdHJpbmc+TWljaGFlbCBSb3RoPC9QZXJzb25TdHJpbmc+DQog
 ICAgICA8L1BlcnNvbj4NCiAgICAgIDxFbWFpbHM+DQogICAgICAgID
 xFbWFpbCBTdGFydEluZGV4PSI3MjAiIFBvc2l0aW9uPSJTaWduYXR1
 cmUiPg0KICAgICAgICAgIDxFbWFpbFN0cmluZz5taWNoYWVsLnJvdG
 hAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAgICAgIDwvRW1haWw+
 DQogICAgICA8L0VtYWlscz4NCiAgICAgIDxDb250YWN0U3RyaW5nPk
 1pY2hhZWwgUm90aCAmbHQ7bWljaGFlbC5yb3RoQGFtZC5jb208L0Nv
 bnRhY3RTdHJpbmc+DQogICAgPC9Db250YWN0Pg0KICA8L0NvbnRhY3
 RzPg0KPC9Db250YWN0U2V0PgEOzwFSZXRyaWV2ZXJPcGVyYXRvciwx
 MCwxO1JldHJpZXZlck9wZXJhdG9yLDExLDI7UG9zdERvY1BhcnNlck
 9wZXJhdG9yLDEwLDE7UG9zdERvY1BhcnNlck9wZXJhdG9yLDExLDA7
 UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLDEwLDQ7UG
 9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLDExLDA7VHJh
 bnNwb3J0V3JpdGVyUHJvZHVjZXIsMjAsMjM=3D
X-MS-Exchange-Forest-IndexAgent: 1 3428
X-MS-Exchange-Forest-EmailMessageHash: 7CFE3980
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=3DLow
X-MS-Exchange-Organization-Prioritization: 2:AMS:44612/1048576|ARC:76/50
X-MS-Exchange-Organization-IncludeInSla: False:AccRecipCountThresholdExceed=
ed

When requesting an attestation report a guest is able to specify whether
it wants SNP firmware to sign the report using either a Versioned Chip
Endorsement Key (VCEK), which is derived from chip-unique secrets, or a
Versioned Loaded Endorsement Key (VLEK) which is obtained from an AMD
Key Derivation Service (KDS) and derived from seeds allocated to
enrolled cloud service providers (CSPs).

For VLEK keys, an SNP_VLEK_LOAD SNP firmware command is used to load
them into the system after obtaining them from the KDS. Add a
corresponding userspace interface so to allow the loading of VLEK keys
into the system.

See SEV-SNP Firmware ABI 1.54, SNP_VLEK_LOAD for more details.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 36 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h | 27 +++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2102377f727b..97a7959406ee 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2027,6 +2027,39 @@ static int sev_ioctl_do_snp_set_config(struct sev_is=
sue_cmd *argp, bool writable
 	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
 }
=20
+static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool wri=
table)
+{
+	struct sev_device *sev =3D psp_master->sev_data;
+	struct sev_user_data_snp_vlek_load input;
+	void *blob;
+	int ret;
+
+	if (!sev->snp_initialized || !argp->data)
+		return -EINVAL;
+
+	if (!writable)
+		return -EPERM;
+
+	if (copy_from_user(&input, u64_to_user_ptr(argp->data), sizeof(input)))
+		return -EFAULT;
+
+	if (input.len !=3D sizeof(input) || input.vlek_wrapped_version !=3D 0)
+		return -EINVAL;
+
+	blob =3D psp_copy_user_blob(input.vlek_wrapped_address,
+				  sizeof(struct sev_user_data_snp_wrapped_vlek_hashstick));
+	if (IS_ERR(blob))
+		return PTR_ERR(blob);
+
+	input.vlek_wrapped_address =3D __psp_pa(blob);
+
+	ret =3D __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
+
+	kfree(blob);
+
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long=
 arg)
 {
 	void __user *argp =3D (void __user *)arg;
@@ -2087,6 +2120,9 @@ static long sev_ioctl(struct file *file, unsigned int=
 ioctl, unsigned long arg)
 	case SNP_SET_CONFIG:
 		ret =3D sev_ioctl_do_snp_set_config(&input, writable);
 		break;
+	case SNP_VLEK_LOAD:
+		ret =3D sev_ioctl_do_snp_vlek_load(&input, writable);
+		break;
 	default:
 		ret =3D -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index b7a2c2ee35b7..2289b7c76c59 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -31,6 +31,7 @@ enum {
 	SNP_PLATFORM_STATUS,
 	SNP_COMMIT,
 	SNP_SET_CONFIG,
+	SNP_VLEK_LOAD,
=20
 	SEV_MAX,
 };
@@ -214,6 +215,32 @@ struct sev_user_data_snp_config {
 	__u8 rsvd1[52];
 } __packed;
=20
+/**
+ * struct sev_data_snp_vlek_load - SNP_VLEK_LOAD structure
+ *
+ * @len: length of the command buffer read by the PSP
+ * @vlek_wrapped_version: version of wrapped VLEK hashstick (Must be 0h)
+ * @rsvd: reserved
+ * @vlek_wrapped_address: address of a wrapped VLEK hashstick
+ *                        (struct sev_user_data_snp_wrapped_vlek_hashstick=
)
+ */
+struct sev_user_data_snp_vlek_load {
+	__u32 len;				/* In */
+	__u8 vlek_wrapped_version;		/* In */
+	__u8 rsvd[3];				/* In */
+	__u64 vlek_wrapped_address;		/* In */
+} __packed;
+
+/**
+ * struct sev_user_data_snp_vlek_wrapped_vlek_hashstick - Wrapped VLEK dat=
a
+ *
+ * @data: Opaque data provided by AMD KDS (as described in SEV-SNP Firmwar=
e ABI
+ *        1.54, SNP_VLEK_LOAD)
+ */
+struct sev_user_data_snp_wrapped_vlek_hashstick {
+	__u8 data[432];				/* In */
+} __packed;
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
--=20
2.25.1




