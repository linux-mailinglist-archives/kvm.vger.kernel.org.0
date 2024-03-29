Return-Path: <kvm+bounces-13238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F2878934F8
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:18:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 982E31F21411
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F1E0152533;
	Sun, 31 Mar 2024 16:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0qaiMEu3"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12EF1465AC;
	Sun, 31 Mar 2024 16:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903644; cv=fail; b=j6Sc0uucFZrn4ymFPNmzCKtnNKCS5/GMeKfFP2AeN9lLA3pAb5MMi1vBqyzhHdEXYuHRe3mmvcJh8WY8/U1G++LMVAeUSPdOJMfewjsXFbxdXJApDtqe2ajgrZMJM4LN8nkR6gk71nHNGPyQWZf6umNI4eajCrxi6SigpT0MDlU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903644; c=relaxed/simple;
	bh=mvzIG3trjxBIGUfnzun48CJIut02n10RvryGZ0nczpY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E2Hmy3B7aMsnvlGR3PsHjJ56VydB2qNreqmU+lwL30c50U4G402fPzhAu8/XvsbpeJT5tMo6zgipVZNb6gpPM83tZcH9Ksqo1SsdI9fR38eeCh8IJlPuAAHsK1vNl6PJVxBWAt3+Lpvi0f8nPErYpW8GorLh9kCjLEPZiOWsKeU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0qaiMEu3 reason="signature verification failed"; arc=fail smtp.client-ip=40.107.236.41; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 7FF8020728;
	Sun, 31 Mar 2024 18:47:19 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MoAwov_z7mvw; Sun, 31 Mar 2024 18:47:17 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 00D9B20754;
	Sun, 31 Mar 2024 18:47:16 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 00D9B20754
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id 8594D800058;
	Sun, 31 Mar 2024 18:40:20 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:20 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:18 +0000
X-sender: <linux-kernel+bounces-125500-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAPDFCS25BAlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAwAAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAs0mmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2VjdW5ldC5jb20FAAYAAgABBQApAAIAAQ8ACQAAAENJQXVkaXRlZAIAAQUAAgAHAAEAAAAFAAMABwAAAAAABQAFAAIAAQUAYgAKADYAAADOigAABQBkAA8AAwAAAEh1Yg==
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 18215
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.199.223; helo=ny.mirrors.kernel.org; envelope-from=linux-kernel+bounces-125500-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com E8D9A2087D
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753398; cv=fail; b=HFuT+KiiVQI+Uuq+VlznNW/DuqEPEGdVllPpUv17O8ePjG+WbrcEpMCo6qNhMUd8BqLav2NVptOiY/nxIFoHjcDsRqvjvPhBLQShi9fHpvjLUPY3wvijuj4sqYN1ZBQ2yWqaXL9vC08nLaUCVIAjTJXi6v0eeXf3TaOehg0IYf8=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753398; c=relaxed/simple;
	bh=ADKCuQ5ZPgcMUSBkIs3y/3J0nN07ibiIkpAjcxmMd9k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zt+t+EbaeVaNcu/qmoayx6Y1SCFsErGu4f6sFreT4/PBxdyt6UYNsmZyuFKEw+9plmB3zaES5zt7eohvx8DPVnjMo0Dxep+n5IAmAXtfplSqlHeyGXWYjSBE+Fmyo1rsfjq81pmCrSfE95U7XYjkrNtl4/Ikg1IAaThdwo6KBzk=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0qaiMEu3; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ad/NYbmdBkY5J3ovtCg2lgYBkwmWXGapNT6gLIfx47F38R6sLdvQ+OwyCEN7TGJOo11LNY1+2RoN24BqXXErFTKSdUAOBf6ViEtI/sp+c9D9ZbNccJEHBvssoTrlm01adFBVWB7wiLiaIdTM5k5Cq1ENaDisxohOCA757aYnZrW9f+eMCbsksV8r0EZf+RQ+/PMyWLmJqzS8fDGg6e1OA92fveLe2YPqHxuCElB2NdhzrFSLMnEIfnC/gv86B0S77VuZJSGQV+nhMMVKIrHpKNQrKhGTQHIEkmDGzzr/gKBAWUfLUQdtmUHshvBTXqiwqslsC0rxIt87Pj+eKbP+Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VvmmF8DWUNh/hIchD9go/drdRtrw4d4tU0BqDNiQuvs=;
 b=Kz/bVd4b2iwTHvBSc8p77Ogb7ZOhyYmb8GtLurWpdBI1Hh+2xzrDBz2ervY1ZEYi0y4Id8vBLp6KuE/8tUIKf153QqcBPt5i7rwykTs+YKrY5Vmh18rijsQKifno53VbGxNUzMEAlIr+cDKW6NhZOqQJ2Mbn9/kVHdaMUDmOYtFtuIy7jy1oRQQaZCCKL0SuZ17iCpfspvb5VNn0IWrT5IqyTJIlnlg4IF1a1hdqcJ2DO69FUW7xeAEhKR7LSbLWK/2TCAghxVEqoEe286aQfCaEpIcl30F0kAMxA/cS2y4PDwW2uqCLp4ebgiqomVk/JC1EkGm1DxFgZ9pAmK4q1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VvmmF8DWUNh/hIchD9go/drdRtrw4d4tU0BqDNiQuvs=;
 b=0qaiMEu3a2xCIbByvz6b7XPeqlnhpALKFapsKh9b+47gc1Gbw8LLkKirYQKunZX+bJ17MC0cImJCKVaKNb5f3aHzFTsePWYxqwEyBBtK7RFruSJ7JDlA7Ig/+nmlEHMIxemW4VE0ZWBfkVBBFZKbGFS4+XgHDD8N8BiccQ6Xbz8=
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
Subject: [PATCH v12 20/29] KVM: SEV: Add support for GHCB-based termination requests
Date: Fri, 29 Mar 2024 17:58:26 -0500
Message-ID: <20240329225835.400662-21-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|IA1PR12MB8493:EE_
X-MS-Office365-Filtering-Correlation-Id: 6480f0c9-db72-4f68-283f-08dc50446929
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4xNaBWQcZ3bIgw+WuiB0tPsj3M5ahRIiRsRfiLY4T5qkgl1AixP6rmkzIdpZST/4jN0hjto5zAc5KXbIT6KacSBmjKKL+MBBbxtr2MJSCvUxS+xVI3vV/DQGCUfGHznXR+EnN38dhiKcAhlMaa0ocbk1w08IC5xf67rewBVQ1NkNZ6ZKQ5feBTUU2uzaa+qRJaicoeJjQeCqPJiKGKHKZLGN33eoq6JMXYyZS0Qhc6VXy028sjkjJSaWA8UaTOzXFANuMMhUtrPe9hm8oLPeiR/3svkX+YJrvp3QZ2ZKVD12v1DWPDXgiKU8yqWmZuWSA+xioJTER3y61jnKaQJ+4FrLFwkw4Nb85NpXKLjmMFQy4CkHkJ2sP82tQTirBrMqdFoKOwG9IHI4FYE9gH9waqc+3Q2nsU5TM43f/GoDWrQUJuP5jKzBwPqRs+ll4YPeETw+ZWnxiJWWolArSpP/XSG5pRJVrsCAAR4jf28M/pe8Txme/s7c+NMozsNPZzNGNxHL4vlVS+BiwCXLSjK5n5m6HrvJp1p5YouSoi+B8EKMbvRaL6WrQtdtrvmQ10fc9IGsxf6F/MDu/HllBMUWR5rn3sTGNjIV7ejxxNsTJb+PkcZShe6FZHg1fBoSoBWuV/Zr89XISGb4ri/q05z/v/tVfL8MDyvaodW29RekXa8Axpt3TWQhse71SdHiJa7FGxYXcPUl7FIz4maHPeHYTaOCJf4LH/gXj0d7cxKuIyE6/ec7AHZRKQlx+bVjlu+E
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(7416005)(1800799015)(82310400014);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:03:13.0821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6480f0c9-db72-4f68-283f-08dc50446929
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8493
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

GHCB version 2 adds support for a GHCB-based termination request that
a guest can issue when it reaches an error state and wishes to inform
the hypervisor that it should be terminated. Implement support for that
similarly to GHCB MSR-based termination requests that are already
available to SEV-ES guests via earlier versions of the GHCB protocol.

See 'Termination Request' in the 'Invoking VMGEXIT' section of the GHCB
specification for more details.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7dfbf12b454b..9ea13c2de668 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3214,6 +3214,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *s=
vm)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_TERM_REQUEST:
 		break;
 	default:
 		reason =3D GHCB_ERR_INVALID_EVENT;
@@ -3889,6 +3890,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
=20
 		ret =3D 1;
 		break;
+	case SVM_VMGEXIT_TERM_REQUEST:
+		pr_info("SEV-ES guest requested termination: reason %#llx info %#llx\n",
+			control->exit_info_1, control->exit_info_2);
+		vcpu->run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
+		vcpu->run->system_event.type =3D KVM_SYSTEM_EVENT_SEV_TERM;
+		vcpu->run->system_event.ndata =3D 1;
+		vcpu->run->system_event.data[0] =3D control->ghcb_gpa;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=3D%#llx, exit_info_2=3D%#=
llx\n",
--=20
2.25.1


X-sender: <kvm+bounces-13124-martin.weber=3Dsecunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=3Drfc822;martin.weber@secunet.=
com; X-ExtendedProps=3DBQBYABcARgAAAJuYHy0vkvxLoOu7fW2WcxdDTj1XZWJlciBNYXJ0=
aW4sT1U9VXNlcnMsT1U9TWlncmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAGwAAgAABQAMAAIAAA8=
ANgAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5EaXNwbGF5Tm=
FtZQ8ADQAAAFdlYmVyLCBNYXJ0aW4FADwAAgAABQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUADgARA=
EAJ/dJgSQNPjrUVnMO/4HsFAAsAFwC+AAAAsylSdUnj6k+wvjsUej6W+0NOPURCMixDTj1EYXRh=
YmFzZXMsQ049RXhjaGFuZ2UgQWRtaW5pc3RyYXRpdmUgR3JvdXAgKEZZRElCT0hGMjNTUERMVCk=
sQ049QWRtaW5pc3RyYXRpdmUgR3JvdXBzLENOPXNlY3VuZXQsQ049TWljcm9zb2Z0IEV4Y2hhbm=
dlLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAEgAPAF4AA=
AAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIz=
U1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQBHAAIAAAUARgAHAAMAAAA=
FAEMAAgAABQAWAAIAAAUAagAJAAEAAAAAAAAABQAUABEAm5gfLS+S/Eug67t9bZZzFwUAFQAWAA=
IAAAAPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZ=
XNvdXJjZQIAAAUAIwACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5z=
bWl0SGlzdG9yeTogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXh=
wYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAmAAIAAQ=3D=3D
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoA6kmmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0=
LmNvbQUABgACAAEPACoAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LlJlc3VibWl0Q29=
1bnQHAAEAAAAPAAkAAABDSUF1ZGl0ZWQCAAEFAAIABwABAAAABQADAAcAAAAAAAUABQACAAEFAG=
IACgA0AAAAzooAAAUAZAAPAAMAAABIdWIFACkAAgABDwA/AAAATWljcm9zb2Z0LkV4Y2hhbmdlL=
lRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLk1haWxEZWxpdmVyeVByaW9yaXR5DwADAAAATG93
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 18830
Received: from cas-essen-01.secunet.de (10.53.40.201) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:03:37 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:03:36 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id ECF2120882
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 00:03:36 +0100 (CET)
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
	with ESMTP id MGdZUkQ7Ejog for <martin.weber@secunet.com>;
	Sat, 30 Mar 2024 00:03:33 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.80.249; helo=3Dam.mirrors.kernel.org; envelope-from=3Dkvm+bounces=
-13124-martin.weber=3Dsecunet.com@vger.kernel.org; receiver=3Dmartin.weber@=
secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com A73D02087D
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id A73D02087D
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 00:03:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FEA71F267C0
	for <martin.weber@secunet.com>; Fri, 29 Mar 2024 23:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B2D013E408;
	Fri, 29 Mar 2024 23:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"0qaiMEu3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11=
on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7893A13DBB3;
	Fri, 29 Mar 2024 23:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.236.41
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753398; cv=3Dfail; b=3DHFuT+KiiVQI+Uuq+VlznNW/DuqEPEGdVllPpUv17O8e=
PjG+WbrcEpMCo6qNhMUd8BqLav2NVptOiY/nxIFoHjcDsRqvjvPhBLQShi9fHpvjLUPY3wvijuj=
4sqYN1ZBQ2yWqaXL9vC08nLaUCVIAjTJXi6v0eeXf3TaOehg0IYf8=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753398; c=3Drelaxed/simple;
	bh=3DADKCuQ5ZPgcMUSBkIs3y/3J0nN07ibiIkpAjcxmMd9k=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DZt+t+EbaeVaNcu/qmoayx6Y1SCFsErGu4f6sFreT4/=
PBxdyt6UYNsmZyuFKEw+9plmB3zaES5zt7eohvx8DPVnjMo0Dxep+n5IAmAXtfplSqlHeyGXWYj=
SBE+Fmyo1rsfjq81pmCrSfE95U7XYjkrNtl4/Ikg1IAaThdwo6KBzk=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3D0qaiMEu3; arc=3Dfail smtp.client-ip=3D40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DAd/NYbmdBkY5J3ovtCg2lgYBkwmWXGapNT6gLIfx47F38R6sLdvQ+OwyCEN7TGJOo11LNY=
1+2RoN24BqXXErFTKSdUAOBf6ViEtI/sp+c9D9ZbNccJEHBvssoTrlm01adFBVWB7wiLiaIdTM5=
k5Cq1ENaDisxohOCA757aYnZrW9f+eMCbsksV8r0EZf+RQ+/PMyWLmJqzS8fDGg6e1OA92fveLe=
2YPqHxuCElB2NdhzrFSLMnEIfnC/gv86B0S77VuZJSGQV+nhMMVKIrHpKNQrKhGTQHIEkmDGzzr=
/gKBAWUfLUQdtmUHshvBTXqiwqslsC0rxIt87Pj+eKbP+Uw=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DVvmmF8DWUNh/hIchD9go/drdRtrw4d4tU0BqDNiQuvs=3D;
 b=3DKz/bVd4b2iwTHvBSc8p77Ogb7ZOhyYmb8GtLurWpdBI1Hh+2xzrDBz2ervY1ZEYi0y4Id8=
vBLp6KuE/8tUIKf153QqcBPt5i7rwykTs+YKrY5Vmh18rijsQKifno53VbGxNUzMEAlIr+cDKW6=
NhZOqQJ2Mbn9/kVHdaMUDmOYtFtuIy7jy1oRQQaZCCKL0SuZ17iCpfspvb5VNn0IWrT5IqyTJIl=
nlg4IF1a1hdqcJ2DO69FUW7xeAEhKR7LSbLWK/2TCAghxVEqoEe286aQfCaEpIcl30F0kAMxA/c=
S2y4PDwW2uqCLp4ebgiqomVk/JC1EkGm1DxFgZ9pAmK4q1w=3D=3D
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
 bh=3DVvmmF8DWUNh/hIchD9go/drdRtrw4d4tU0BqDNiQuvs=3D;
 b=3D0qaiMEu3a2xCIbByvz6b7XPeqlnhpALKFapsKh9b+47gc1Gbw8LLkKirYQKunZX+bJ17MC=
0cImJCKVaKNb5f3aHzFTsePWYxqwEyBBtK7RFruSJ7JDlA7Ig/+nmlEHMIxemW4VE0ZWBfkVBBF=
ZKbGFS4+XgHDD8N8BiccQ6Xbz8=3D
Received: from SJ0PR03CA0024.namprd03.prod.outlook.com (2603:10b6:a03:33a::=
29)
 by IA1PR12MB8493.namprd12.prod.outlook.com (2603:10b6:208:447::12) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 =
Mar
 2024 23:03:13 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::70) by SJ0PR03CA0024.outlook.office365.com
 (2603:10b6:a03:33a::29) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Front=
end
 Transport; Fri, 29 Mar 2024 23:03:13 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:03:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:03:12 -0500
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
Subject: [PATCH v12 20/29] KVM: SEV: Add support for GHCB-based termination=
 requests
Date: Fri, 29 Mar 2024 17:58:26 -0500
Message-ID: <20240329225835.400662-21-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|IA1PR12MB8493:EE_
X-MS-Office365-Filtering-Correlation-Id: 6480f0c9-db72-4f68-283f-08dc504469=
29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4xNaBWQcZ3bIgw+WuiB0tPsj3M5ahRIiRsRfiLY4=
T5qkgl1AixP6rmkzIdpZST/4jN0hjto5zAc5KXbIT6KacSBmjKKL+MBBbxtr2MJSCvUxS+xVI3v=
V/DQGCUfGHznXR+EnN38dhiKcAhlMaa0ocbk1w08IC5xf67rewBVQ1NkNZ6ZKQ5feBTUU2uzaa+=
qRJaicoeJjQeCqPJiKGKHKZLGN33eoq6JMXYyZS0Qhc6VXy028sjkjJSaWA8UaTOzXFANuMMhUt=
rPe9hm8oLPeiR/3svkX+YJrvp3QZ2ZKVD12v1DWPDXgiKU8yqWmZuWSA+xioJTER3y61jnKaQJ+=
4FrLFwkw4Nb85NpXKLjmMFQy4CkHkJ2sP82tQTirBrMqdFoKOwG9IHI4FYE9gH9waqc+3Q2nsU5=
TM43f/GoDWrQUJuP5jKzBwPqRs+ll4YPeETw+ZWnxiJWWolArSpP/XSG5pRJVrsCAAR4jf28M/p=
e8Txme/s7c+NMozsNPZzNGNxHL4vlVS+BiwCXLSjK5n5m6HrvJp1p5YouSoi+B8EKMbvRaL6WrQ=
tdtrvmQ10fc9IGsxf6F/MDu/HllBMUWR5rn3sTGNjIV7ejxxNsTJb+PkcZShe6FZHg1fBoSoBWu=
V/Zr89XISGb4ri/q05z/v/tVfL8MDyvaodW29RekXa8Axpt3TWQhse71SdHiJa7FGxYXcPUl7FI=
z4maHPeHYTaOCJf4LH/gXj0d7cxKuIyE6/ec7AHZRKQlx+bVjlu+E
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(36860700004)(376005)(7416005)(1800799015)(82310400014);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:03:13.0821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6480f0c9-db72-4f68-283f-08dc5=
0446929
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDE.namprd05.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8493
Return-Path: kvm+bounces-13124-martin.weber=3Dsecunet.com@vger.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:03:36.9862
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 298ac77f-6204-432f-b92a-08dc=
50447755
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-02.secunet.de:TOTAL-HUB=3D36986.368|SMR=3D0.131(SMRDE=3D0.004|SMRC=3D0.=
126(SMRCL=3D0.103|X-SMRCR=3D0.125))|CAT=3D0.081(CATOS=3D0.001
 |CATRESL=3D0.029(CATRESLP2R=3D0.021)|CATORES=3D0.048(CATRS=3D0.048(CATRS-T=
ransport
 Rule Agent=3D0.002 (X-ETREX=3D0.001)|CATRS-Index Routing
 Agent=3D0.044)))|UNK=3D0.001|QDM=3D3591.088|SMSC=3D0.637
 (X-SMSDR=3D0.013)|SMS=3D5.786(SMSMBXD-INC=3D5.285)|UNK=3D0.001|QDM=3D5817.=
802|SMSC=3D0.609(X-SMSDR=3D0.018
 )|SMS=3D5.877(SMSMBXD-INC=3D5.374)|QDM=3D6123.529|SMSC=3D0.161|SMS=3D4.393=
(SMSMBXD-INC=3D4.326
 )|QDM=3D12183.235|SMSC=3D0.258(X-SMSDR=3D0.017)|SMS=3D1.648(SMSMBXD-INC=3D=
1.532)|QDM=3D9251.300
 |UNK=3D0.101|CAT=3D0.008(CATRESL=3D0.007(CATRESLP2R=3D0.003));2024-03-30T0=
9:20:03.369Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 13443
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-01.secunet.de:TO=
TAL-FE=3D0.014|SMR=3D0.007(SMRPI=3D0.005(SMRPI-FrontendProxyAgent=3D0.005))=
|SMS=3D0.006
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-02
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-02
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAf8EAAAPAAADH4sIAAAAAAAEAJVVDU/b=
Rhg+J3Y+TMy+WK
 GTKp26TdASB5KmlI+B6Dq3RVsYS0K0aZssx74kFv7IfI4L0v7s/sne
 u3OCIQlqLWPunnvveZ/3udfOf6vv3r/5ESckom4Y4Aa2HIdiOhmPwy
 jGgzDCFmYRet+ixMExiXw3sGIWG5F/JoTGOB5ZsaZaeMhnthVgl9IJ
 wR9GBIYxxFn2iFAMCySKgJHGVkxg6uAPLmUrcYjdAHL5mhqPCB7djE
 mUuBRCGTfjoKNw4jm4T2YKiFPDZ/7YIz4J4juChR7q+q5nRd4NY+c1
 tjrt5VVQkcqKQJgHip0bKCmxgKLvEUbRMXq60RFFUpy4FibA7pJo6h
 3F4QAz+TzZOArj0A69mqZqaocQvNnNJG2LpJtQNt+yeRYk4ZUbDHGv
 9c74/ay7iSmxeWiGFIoaE9sduLZgYcX6ISh2SAxKqcjlDgPi6OFgoP
 dvDnHLtUcW8XA7jEf4B1/MaiBudGr5Ts0O/RNN1XVdU6F2e7Rzvb+3
 c5X4O5T9kaRm43/xAd6eXhBWxwMXLAGiYEicKqy6ASURU0S3tp8xDY
 47GGBdH8LBWTtLaPtLFjTVDRxyjV85g/6g3ug3Xzb7tdoBseov7IZD
 9vb2cX13d6/Z5LKX8msqqH0gyekp1l806s3qHt7m/19hgFhnujYUBB
 1FEpNQM7E814FuMxN/SK7deIvG0cSOcWKPJybw4efwgKJxetnQYLjT
 a5npQZqX553Li4tf213jJ9PoGefdwweC3/fMt8br7mXb6DwUdtF5A8
 vby5a7Rrtlto3fLo1ONtv06kN7Xx3d4g4ZWBMvXhAJgRT67Jh3n2m0
 2+bZee/1L2dpJUepjfv7B9zG/YPdar3JfJwaCD3ieHPewVGYzD/8nD
 15x8xnjiFt/Wi5+o+tfvve/nFksm/N1tPsCz39Ctz9NhxODfj+W8+7
 5p8oMfwreFqdZ54dVxjEUejpJ6xmnsysVxehjWdH8yzMEv0kmgRp5O
 wMfoYaeYGdPzpdozU7ggcI6A2U5JskgU9kLYavakqTZTDBB+7ZJ1AF
 8EZY6fl87B625c/dv2HXzInhyO6bw7G1gOV+j37Sa5WVYk4CF34ltt
 i4Oh+SvZ6mbXqIJ0H6ewL9wNVjHWcO85g3QTUDNY4zfcE+po1a42Wt
 zjpbUxGSkVKUShJCEsqxMSrlkczGElKRoqDCCqoAKKMCgDCFVXhCZA
 7lAYcnTAVeQEWYFjiDilZEjABVVCkjVZADFYwBhIC8hMqcELKUUJkh
 SC6isgiA1QKSBQnHSxDDcEailJCWRwqXJ0BAykV2l6YxBQ2tiuAiqk
 ABGufJcSpYLUpojQ1Y0jyqTAfpLUkys0VavTVHKouxir6QOZXA7+xC
 uUUgc6mCViuSVkBQVGVRTHEBKIG3SJEKXEnudowU4QlYtM4t4rWXAA
 SiEiOBe1U4/ITXC0Yp6HOBrHOE7/pKIJ9xZLZlI7UIfPsGdsGzAKcj
 oUfpAZUUaWVeWA6hHO8EYPiS94OQlGeS2HHI6HE+1b82E5PNBd4VWW
 MUZkev8G5ZQeBbmR+lsP1JketZQYosKZwwP4d8zXjYlIFsO0C8GUCS
 gjbEKqipsGlB5jofc9min2W0fi9GSd+Utft704yK0MD9fzQrMOP/xl
 RMUUbfQTAHS3dlyzPNGQQ6oSysZiZLeTb+H2LkSZIgCwAAAQrwATw/
 eG1sIHZlcnNpb249IjEuMCIgZW5jb2Rpbmc9InV0Zi0xNiI/Pg0KPE
 VtYWlsU2V0Pg0KICA8VmVyc2lvbj4xNS4wLjAuMDwvVmVyc2lvbj4N
 CiAgPEVtYWlscz4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iNDkyIi
 BQb3NpdGlvbj0iU2lnbmF0dXJlIj4NCiAgICAgIDxFbWFpbFN0cmlu
 Zz5taWNoYWVsLnJvdGhAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogIC
 AgPC9FbWFpbD4NCiAgPC9FbWFpbHM+DQo8L0VtYWlsU2V0PgEMsAQ8
 P3htbCB2ZXJzaW9uPSIxLjAiIGVuY29kaW5nPSJ1dGYtMTYiPz4NCj
 xDb250YWN0U2V0Pg0KICA8VmVyc2lvbj4xNS4wLjAuMDwvVmVyc2lv
 bj4NCiAgPENvbnRhY3RzPg0KICAgIDxDb250YWN0IFN0YXJ0SW5kZX
 g9IjQ3OCIgUG9zaXRpb249IlNpZ25hdHVyZSI+DQogICAgICA8UGVy
 c29uIFN0YXJ0SW5kZXg9IjQ3OCIgUG9zaXRpb249IlNpZ25hdHVyZS
 I+DQogICAgICAgIDxQZXJzb25TdHJpbmc+TWljaGFlbCBSb3RoPC9Q
 ZXJzb25TdHJpbmc+DQogICAgICA8L1BlcnNvbj4NCiAgICAgIDxFbW
 FpbHM+DQogICAgICAgIDxFbWFpbCBTdGFydEluZGV4PSI0OTIiIFBv
 c2l0aW9uPSJTaWduYXR1cmUiPg0KICAgICAgICAgIDxFbWFpbFN0cm
 luZz5taWNoYWVsLnJvdGhAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQog
 ICAgICAgIDwvRW1haWw+DQogICAgICA8L0VtYWlscz4NCiAgICAgID
 xDb250YWN0U3RyaW5nPk1pY2hhZWwgUm90aCAmbHQ7bWljaGFlbC5y
 b3RoQGFtZC5jb208L0NvbnRhY3RTdHJpbmc+DQogICAgPC9Db250YW
 N0Pg0KICA8L0NvbnRhY3RzPg0KPC9Db250YWN0U2V0PgEOzwFSZXRy
 aWV2ZXJPcGVyYXRvciwxMCwyO1JldHJpZXZlck9wZXJhdG9yLDExLD
 I7UG9zdERvY1BhcnNlck9wZXJhdG9yLDEwLDE7UG9zdERvY1BhcnNl
 ck9wZXJhdG9yLDExLDA7UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY0
 9wZXJhdG9yLDEwLDE7UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09w
 ZXJhdG9yLDExLDA7VHJhbnNwb3J0V3JpdGVyUHJvZHVjZXIsMjAsMj g=3D
X-MS-Exchange-Forest-IndexAgent: 1 2309
X-MS-Exchange-Forest-EmailMessageHash: 8FAD1D8B
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=3DLow
X-MS-Exchange-Organization-Prioritization: 2:RC:REDACTED-e1aa58100ed18495dc=
96381fb27ebbe9@secunet.com:13/10|SR
X-MS-Exchange-Organization-IncludeInSla: False:RecipientCountThresholdExcee=
ded

GHCB version 2 adds support for a GHCB-based termination request that
a guest can issue when it reaches an error state and wishes to inform
the hypervisor that it should be terminated. Implement support for that
similarly to GHCB MSR-based termination requests that are already
available to SEV-ES guests via earlier versions of the GHCB protocol.

See 'Termination Request' in the 'Invoking VMGEXIT' section of the GHCB
specification for more details.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7dfbf12b454b..9ea13c2de668 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3214,6 +3214,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *s=
vm)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_TERM_REQUEST:
 		break;
 	default:
 		reason =3D GHCB_ERR_INVALID_EVENT;
@@ -3889,6 +3890,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
=20
 		ret =3D 1;
 		break;
+	case SVM_VMGEXIT_TERM_REQUEST:
+		pr_info("SEV-ES guest requested termination: reason %#llx info %#llx\n",
+			control->exit_info_1, control->exit_info_2);
+		vcpu->run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
+		vcpu->run->system_event.type =3D KVM_SYSTEM_EVENT_SEV_TERM;
+		vcpu->run->system_event.ndata =3D 1;
+		vcpu->run->system_event.data[0] =3D control->ghcb_gpa;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=3D%#llx, exit_info_2=3D%#=
llx\n",
--=20
2.25.1


X-sender: <linux-crypto+bounces-3098-steffen.klassert=3Dsecunet.com@vger.ke=
rnel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=3Drfc822;steffen.klassert@=
secunet.com
X-CreatedBy: MSExchange15
X-HeloDomain: mbx-dresden-01.secunet.de
X-ExtendedProps: BQBjAAoA6UmmlidQ3AgFADcAAgAADwA8AAAATWljcm9zb2Z0LkV4Y2hhbm=
dlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50Lk9yZ2FuaXphdGlvblNjb3BlEQAAAAAAAAAAAAAAA=
AAAAAAADwA/AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLk1h=
aWxEZWxpdmVyeVByaW9yaXR5DwADAAAATG93
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 10.53.40.199
X-EndOfInjectedXHeaders: 14204
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:03:34 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:03:33 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id D88CA2032C
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:03:33 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -5.15
X-Spam-Level:
X-Spam-Status: No, score=3D-5.15 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.099, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_MED=3D-2.3, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dham autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Damd.com
Received: from b.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2omFL42wNLeP for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:03:30 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.199.223; helo=3Dny.mirrors.kernel.org; envelope-from=3Dlinux-cryp=
to+bounces-3098-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=3D=
steffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com E101D200BB
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"0qaiMEu3"
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223=
])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id E101D200BB
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:03:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03ACA1C20AD3
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A93E13E3EC;
	Fri, 29 Mar 2024 23:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"0qaiMEu3"
X-Original-To: linux-crypto@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11=
on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7893A13DBB3;
	Fri, 29 Mar 2024 23:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.236.41
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753398; cv=3Dfail; b=3DHFuT+KiiVQI+Uuq+VlznNW/DuqEPEGdVllPpUv17O8e=
PjG+WbrcEpMCo6qNhMUd8BqLav2NVptOiY/nxIFoHjcDsRqvjvPhBLQShi9fHpvjLUPY3wvijuj=
4sqYN1ZBQ2yWqaXL9vC08nLaUCVIAjTJXi6v0eeXf3TaOehg0IYf8=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753398; c=3Drelaxed/simple;
	bh=3DADKCuQ5ZPgcMUSBkIs3y/3J0nN07ibiIkpAjcxmMd9k=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DZt+t+EbaeVaNcu/qmoayx6Y1SCFsErGu4f6sFreT4/=
PBxdyt6UYNsmZyuFKEw+9plmB3zaES5zt7eohvx8DPVnjMo0Dxep+n5IAmAXtfplSqlHeyGXWYj=
SBE+Fmyo1rsfjq81pmCrSfE95U7XYjkrNtl4/Ikg1IAaThdwo6KBzk=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3D0qaiMEu3; arc=3Dfail smtp.client-ip=3D40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DAd/NYbmdBkY5J3ovtCg2lgYBkwmWXGapNT6gLIfx47F38R6sLdvQ+OwyCEN7TGJOo11LNY=
1+2RoN24BqXXErFTKSdUAOBf6ViEtI/sp+c9D9ZbNccJEHBvssoTrlm01adFBVWB7wiLiaIdTM5=
k5Cq1ENaDisxohOCA757aYnZrW9f+eMCbsksV8r0EZf+RQ+/PMyWLmJqzS8fDGg6e1OA92fveLe=
2YPqHxuCElB2NdhzrFSLMnEIfnC/gv86B0S77VuZJSGQV+nhMMVKIrHpKNQrKhGTQHIEkmDGzzr=
/gKBAWUfLUQdtmUHshvBTXqiwqslsC0rxIt87Pj+eKbP+Uw=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DVvmmF8DWUNh/hIchD9go/drdRtrw4d4tU0BqDNiQuvs=3D;
 b=3DKz/bVd4b2iwTHvBSc8p77Ogb7ZOhyYmb8GtLurWpdBI1Hh+2xzrDBz2ervY1ZEYi0y4Id8=
vBLp6KuE/8tUIKf153QqcBPt5i7rwykTs+YKrY5Vmh18rijsQKifno53VbGxNUzMEAlIr+cDKW6=
NhZOqQJ2Mbn9/kVHdaMUDmOYtFtuIy7jy1oRQQaZCCKL0SuZ17iCpfspvb5VNn0IWrT5IqyTJIl=
nlg4IF1a1hdqcJ2DO69FUW7xeAEhKR7LSbLWK/2TCAghxVEqoEe286aQfCaEpIcl30F0kAMxA/c=
S2y4PDwW2uqCLp4ebgiqomVk/JC1EkGm1DxFgZ9pAmK4q1w=3D=3D
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
 bh=3DVvmmF8DWUNh/hIchD9go/drdRtrw4d4tU0BqDNiQuvs=3D;
 b=3D0qaiMEu3a2xCIbByvz6b7XPeqlnhpALKFapsKh9b+47gc1Gbw8LLkKirYQKunZX+bJ17MC=
0cImJCKVaKNb5f3aHzFTsePWYxqwEyBBtK7RFruSJ7JDlA7Ig/+nmlEHMIxemW4VE0ZWBfkVBBF=
ZKbGFS4+XgHDD8N8BiccQ6Xbz8=3D
Received: from SJ0PR03CA0024.namprd03.prod.outlook.com (2603:10b6:a03:33a::=
29)
 by IA1PR12MB8493.namprd12.prod.outlook.com (2603:10b6:208:447::12) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 =
Mar
 2024 23:03:13 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::70) by SJ0PR03CA0024.outlook.office365.com
 (2603:10b6:a03:33a::29) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Front=
end
 Transport; Fri, 29 Mar 2024 23:03:13 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:03:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:03:12 -0500
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
Subject: [PATCH v12 20/29] KVM: SEV: Add support for GHCB-based termination=
 requests
Date: Fri, 29 Mar 2024 17:58:26 -0500
Message-ID: <20240329225835.400662-21-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|IA1PR12MB8493:EE_
X-MS-Office365-Filtering-Correlation-Id: 6480f0c9-db72-4f68-283f-08dc504469=
29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4xNaBWQcZ3bIgw+WuiB0tPsj3M5ahRIiRsRfiLY4=
T5qkgl1AixP6rmkzIdpZST/4jN0hjto5zAc5KXbIT6KacSBmjKKL+MBBbxtr2MJSCvUxS+xVI3v=
V/DQGCUfGHznXR+EnN38dhiKcAhlMaa0ocbk1w08IC5xf67rewBVQ1NkNZ6ZKQ5feBTUU2uzaa+=
qRJaicoeJjQeCqPJiKGKHKZLGN33eoq6JMXYyZS0Qhc6VXy028sjkjJSaWA8UaTOzXFANuMMhUt=
rPe9hm8oLPeiR/3svkX+YJrvp3QZ2ZKVD12v1DWPDXgiKU8yqWmZuWSA+xioJTER3y61jnKaQJ+=
4FrLFwkw4Nb85NpXKLjmMFQy4CkHkJ2sP82tQTirBrMqdFoKOwG9IHI4FYE9gH9waqc+3Q2nsU5=
TM43f/GoDWrQUJuP5jKzBwPqRs+ll4YPeETw+ZWnxiJWWolArSpP/XSG5pRJVrsCAAR4jf28M/p=
e8Txme/s7c+NMozsNPZzNGNxHL4vlVS+BiwCXLSjK5n5m6HrvJp1p5YouSoi+B8EKMbvRaL6WrQ=
tdtrvmQ10fc9IGsxf6F/MDu/HllBMUWR5rn3sTGNjIV7ejxxNsTJb+PkcZShe6FZHg1fBoSoBWu=
V/Zr89XISGb4ri/q05z/v/tVfL8MDyvaodW29RekXa8Axpt3TWQhse71SdHiJa7FGxYXcPUl7FI=
z4maHPeHYTaOCJf4LH/gXj0d7cxKuIyE6/ec7AHZRKQlx+bVjlu+E
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(36860700004)(376005)(7416005)(1800799015)(82310400014);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:03:13.0821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6480f0c9-db72-4f68-283f-08dc5=
0446929
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDE.namprd05.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8493
Return-Path: linux-crypto+bounces-3098-steffen.klassert=3Dsecunet.com@vger.=
kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:03:33.9161
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 6a86f7aa-2754-4351-699e-08dc=
50447581
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dcas-es=
sen-01.secunet.de:TOTAL-FE=3D0.023|SMR=3D0.023(SMRPI=3D0.021(SMRPI-Frontend=
ProxyAgent=3D0.021));2024-03-29T23:03:33.940Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-OriginalSize: 13657
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=3DLow
X-MS-Exchange-Organization-Prioritization: 2:ShadowRedundancy
X-MS-Exchange-Organization-IncludeInSla: False:ShadowRedundancy

GHCB version 2 adds support for a GHCB-based termination request that
a guest can issue when it reaches an error state and wishes to inform
the hypervisor that it should be terminated. Implement support for that
similarly to GHCB MSR-based termination requests that are already
available to SEV-ES guests via earlier versions of the GHCB protocol.

See 'Termination Request' in the 'Invoking VMGEXIT' section of the GHCB
specification for more details.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7dfbf12b454b..9ea13c2de668 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3214,6 +3214,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *s=
vm)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_TERM_REQUEST:
 		break;
 	default:
 		reason =3D GHCB_ERR_INVALID_EVENT;
@@ -3889,6 +3890,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
=20
 		ret =3D 1;
 		break;
+	case SVM_VMGEXIT_TERM_REQUEST:
+		pr_info("SEV-ES guest requested termination: reason %#llx info %#llx\n",
+			control->exit_info_1, control->exit_info_2);
+		vcpu->run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
+		vcpu->run->system_event.type =3D KVM_SYSTEM_EVENT_SEV_TERM;
+		vcpu->run->system_event.ndata =3D 1;
+		vcpu->run->system_event.data[0] =3D control->ghcb_gpa;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=3D%#llx, exit_info_2=3D%#=
llx\n",
--=20
2.25.1



