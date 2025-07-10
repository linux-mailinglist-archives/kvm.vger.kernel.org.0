Return-Path: <kvm+bounces-52032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C563AFFFEA
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 13:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5800D7BD521
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 10:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B702E3AFC;
	Thu, 10 Jul 2025 10:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="U0IaOHzU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2048.outbound.protection.outlook.com [40.107.102.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A960D2E11B3
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 10:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752145174; cv=fail; b=ffPnfBUY1bSQ2sRUk14k1NoFfQLKiKOjvzs/qhlELHBq0a15CFKMhyDBYKliTRlFpDhAtviHaRucr582RC++3MrJbxDGwnRbTAC4Dxj+y2627QKzgRet4V+i4EETKtyjYUo1XD8Qn+iouaSvUF95kUm6u8K7fOktl6K6BkSQBzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752145174; c=relaxed/simple;
	bh=yEltx6LR1MCEjShfBLnFB8kiA3emB3nWqxk0wgd8Dn4=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ogEVrbyWM3wu3uzzipLrs5K6TJcJjnZNCh9XiAKngBa9UUdxTHqjx8WV/OK71sFH7GGFP1oxrZHjUApJR4Bc0wQMWmCdGq7qP2nAyTd+TnkYF+RUlFmetQ0hh+8mIoCY/vUIekKjlKMIdhv10oAftZUKSQSAlm3AXsYhiw1uLX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=U0IaOHzU; arc=fail smtp.client-ip=40.107.102.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dwufa5m+mKUwwUdR/a5DzK6fFosEf+6bpRtSWqfsDsm2JNm6gyOULrNTStK3h4euqdiSq35RZsSGBmH2Iiu0EBy37Dwn0bmb4y+H8+7S3SSq0r3vtqpC9lOi9pCKNlQmwQMDgBGjs44CHS4tbPGNXYjK2kbJvdZ/3vdRqLVdTNJ3LQTlREc8swSm0G2Ta6D7qGmH/pHCVD/wcaPse/poDE4av98H5a7Dgv5ESpNmIeM9XA1S5kiaZUZVekqoDjpdR17gnZ0krPbweRM5uQkcHFlM/+qOJ8G/PtIxNqeBwyuS9NHEkPCCTOokH3Dz698yoBkY7IqpsoNzwKeIE4is1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4swwFSI8uTX56SS2SHgcdn3DfVMD0rCdmTcRgo5XYbo=;
 b=mfgBI9CtLL76DVhfbkFJyQapHoNAvbrzUN8F7sBbOCYfskWhKGYOrogq5azLD/3DPtm5MHmURQx4douhU3Kzn/G3mfmXoT0BNFz6MrFjdRHnP0YPxOXYpBwOl7BmQC/03W/ph+gJxAySNjSf8IkE988cKPlzZsI75akuun2+MaMHUWXcQTEeRSTyYxTWUk/yh6f3yD2sLdoNhdudMPcp8uqpw2Q9+4+u6hYCjGXv6sigFfKik9/otfOSZzyiH4vcYjhnQadB1WDVxI1q/MKVE2EFFc1iabjy/O32EkHx7uZHVZxaZ7DcgZ+OSuImwQl/DEIt1gVwKVvFyp59fpBDPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4swwFSI8uTX56SS2SHgcdn3DfVMD0rCdmTcRgo5XYbo=;
 b=U0IaOHzUPGGqoUZ/sFzUJ2tMr315lTPHiXnDnDi0jLDO19iJdvcEIUXzFny9dDV2KFkv4Y+CFkO0/cHraoNpHYoQ1F5xj168Z+rk4VeY976UWvEvMr8PmVw4TU7KJHwSiqoq3QJA0K9c84cWKLyk0qfNOpKh+MJS/3mx5uK0/3g=
Received: from MN2PR01CA0010.prod.exchangelabs.com (2603:10b6:208:10c::23) by
 DS4PR12MB9795.namprd12.prod.outlook.com (2603:10b6:8:29e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.27; Thu, 10 Jul 2025 10:59:29 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:208:10c:cafe::79) by MN2PR01CA0010.outlook.office365.com
 (2603:10b6:208:10c::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.22 via Frontend Transport; Thu,
 10 Jul 2025 11:00:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Thu, 10 Jul 2025 10:59:28 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 10 Jul
 2025 05:59:25 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: Sean Christopherson <seanjc@google.com>, <bp@alien8.de>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <isaku.yamahata@intel.com>,
	<vaishali.thakkar@suse.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
In-Reply-To: <aG5oTKtWWqhwoFlI@google.com>
References: <20250707101029.927906-1-nikunj@amd.com>
 <20250707101029.927906-3-nikunj@amd.com> <aG0tFvoEXzUqRjnC@google.com>
 <63f08c9e-b228-4282-bd08-454ccdf53ecf@amd.com>
 <aG5oTKtWWqhwoFlI@google.com>
Date: Thu, 10 Jul 2025 10:59:17 +0000
Message-ID: <85h5zkuxa2.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|DS4PR12MB9795:EE_
X-MS-Office365-Filtering-Correlation-Id: 3db30ea6-4e1a-4038-b448-08ddbfa0d77e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?paEw4yOBHiOncd3iyFRe7PzwBN6lg79K3jJEQhtwjzfy1EomIOsdn/eDSmjs?=
 =?us-ascii?Q?G0Mq94ypHLJKjtLPVSh2xmVRXF8jMKYKeVqxiyrHuXZ1DJLX2ricB5zPFase?=
 =?us-ascii?Q?gJqVsXRXKkhYjyt7nbEeoatNOzd0eJhtXYIOu7lF58tpV682cbysMVhiFEwn?=
 =?us-ascii?Q?xZeHKa04tvz2JqnG903WNlunMVIfW5udRcSBQomeuEuqiZUrurp7q4DISe85?=
 =?us-ascii?Q?h1UWTSNE2gC8yflb2QoT1WqH4gQCcaRbSUNMthXJfeahlBDuR5pQTShupFOw?=
 =?us-ascii?Q?Kwh5Ow6kFFnzJphp4fsR5b+seaYqOKmDTfVKD4BRYWBWFGuSWItT+L5KvMB4?=
 =?us-ascii?Q?zSSXJFJDkHFfeusRrES89AQKgKfb19nxpEPfJIGFjwSaK1N5gJFhq+yggEmw?=
 =?us-ascii?Q?cagvOz8HsIe6Pv0oLxO39VeHK1hrX98UHP8Sqe8SjAmVZcnqG8sJ/lhGI443?=
 =?us-ascii?Q?GHJ4fHPG1VsvFLAxqMYERtjJkh4DHh4R7r9CrAri3ZV9IhHdPNn4gw66+J5F?=
 =?us-ascii?Q?g0dZ55uywsqRHRbj9lYPsznbutR1zWY6Yhjaovy4jszu/mpTaf3z1qOTqkXq?=
 =?us-ascii?Q?ZQEZw2WWFYDaJU/hNXBRCRzaQC1N+BqVasTSG1PtisBKRBOKTymhS3xWdwcA?=
 =?us-ascii?Q?nDmIRp3WthiE0XoH57wg4pP4O/xZJ5X1hZVhrqPTwV95v2oawI/bsv9qaAIF?=
 =?us-ascii?Q?RfeKf9zePE6aTzUdfX3SNyCQGrR+q+4ny2c9zdC6ifmVDBLEceoeuFNpYTwo?=
 =?us-ascii?Q?w27dJdbmsqYF+s/jhtKNPDMsbNB49gHx8Q+jbh2BebIRS/Oy5kDFaWcTWHTL?=
 =?us-ascii?Q?3ciYwjrpTSr6h1LEbX8HIj8Yq0mkbCA3lveJZ+1Kx7+gf8nMyI5WvOcVbjmp?=
 =?us-ascii?Q?Ps5nmSRsGmFmhSRzzeW7QmaC+XuzUQ3E+3bA8RPs0P7ePgCBCW9J5Pky9a9m?=
 =?us-ascii?Q?l+cZ4G6tD9d+RSO3cF6FRJYbDGTl+dmAyDad+JO479a4tylgeQUIfinuQ2cS?=
 =?us-ascii?Q?9qLrvB5VVwi1M8QJENxANJYrR7g0agg8l3xzyv9xwXBIttgR7nCEZ6BvwdWu?=
 =?us-ascii?Q?t45IDHSoMMGwxlDVFC7yc9RM9jsTZcZ11aAuzqkp3HJHcJGt/OljXfwncn/v?=
 =?us-ascii?Q?+4Znnobrq+ujrm1yRGkTipuCYmv/ulE/5RVGLCW6wUkV2/2i338foRhMnKpK?=
 =?us-ascii?Q?C5yndpPu6eCpMsFH25nFxC5/0QJ243uOgBHBRGbkrXVsaaESHj9q+gv8ay8H?=
 =?us-ascii?Q?VPDNHjT0ROW3H8IRY8ife1BUYgQ61Std4GJDbOe4bWVMU74/uyG06P6DV+MA?=
 =?us-ascii?Q?fi03GLGT0ftAOLiMoVVKkBmqvbsKANZ6vCnVGKEhwvd+kNYDj9ftEyQcQhh7?=
 =?us-ascii?Q?KSnejYDT5R29mkxlUxa/K2Fyiqc87bpWVijcEkO140csoZxC9ir+lPTpjj2k?=
 =?us-ascii?Q?Pe6a5yGf0CYyNbh8D6+JQNP7ZTus1dfyHu4Dta5/BPH8rSX418/9bmCGX1+F?=
 =?us-ascii?Q?PlzaYUSEKBSy13TPhgqGuDBZDSMhnnbH7OxE?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2025 10:59:28.7140
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3db30ea6-4e1a-4038-b448-08ddbfa0d77e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9795

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jul 09, 2025, Nikunj A. Dadhania wrote:
>> On 7/8/2025 8:07 PM, Sean Christopherson wrote:
>> > On Mon, Jul 07, 2025, Nikunj A Dadhania wrote:
>> >> Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
>> >> guest's effective frequency in MHZ when Secure TSC is enabled for SNP
>> >> guests. Disable interception of this MSR when Secure TSC is enabled. Note
>> >> that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
>> >> hypervisor context.
>> > 
>> > ...
>> > 
>> >> @@ -4487,6 +4512,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>> >>  
>> >>  	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
>> >>  	svm_clr_intercept(svm, INTERCEPT_XSETBV);
>> >> +
>> >> +	if (snp_secure_tsc_enabled(svm->vcpu.kvm))
>> >> +		svm_disable_intercept_for_msr(&svm->vcpu, MSR_AMD64_GUEST_TSC_FREQ, MSR_TYPE_RW);
>> > 
>> > KVM shouldn't be disabling write interception for a read-only MSR. 
>> 
>> Few of things to consider here:
>> 1) GUEST_TSC_FREQ is a *guest only* MSR and what is the point in KVM intercepting writes
>>    to that MSR.
>
> Because there's zero point in not intercepting writes, and KVM shouldn't do
> things for no reason as doing so tends to confuse readers.  E.g. I reacted to
> this because I didn't read the changelog first, and was surprised that the guest
> could adjust its TSC frequency (which it obviously can't, but that's what the
> code implies to me).
>

Agree to your point that MSR read-only and having a MSR_TYPE_RW
creates a special case. I can change this to MSR_TYPE_R. The only thing
which looks inefficient to me is the path to generate the #GP when the
MSR interception is enabled.

AFAIU, the GUEST_TSC_FREQ write handling for SEV-SNP guest:

sev_handle_vmgexit()
-> msr_interception()
  -> kvm_set_msr_common()
     -> kvm_emulate_wrmsr()
        -> kvm_set_msr_with_filter()
        -> svm_complete_emulated_msr() will inject the #GP

With MSR interception disabled: vCPU will directly generate #GP

>>    The guest vCPU handles it appropriately when interception is disabled.
>>
>> 2) Guest does not expect GUEST_TSC_FREQ MSR to be intercepted(read or write), guest 
>>    will terminate if GUEST_TSC_FREQ MSR is intercepted by the hypervisor:
>
> But it's read-only, the guest shouldn't be writing.  If the vCPU handles #GPs
> appropriately, then it should have no problem handling #VCs on bad writes.
>
>> 38cc6495cdec x86/sev: Prevent GUEST_TSC_FREQ MSR interception for Secure TSC enabled guests
>
> That's a guest bug, it shouldn't be complaining about the host
> intercepting writes.

The code was written with a perspective that host should not be
intercepting GUEST_TSC_FREQ, as it is a guest-only MSR. To fix guest we
will need to add something like below:

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index e50736d15e02..180a26d5751c 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -32,6 +32,7 @@ enum es_result {
 	ES_DECODE_FAILED,	/* Instruction decoding failed */
 	ES_EXCEPTION,		/* Instruction caused exception */
 	ES_RETRY,		/* Retry instruction emulation */
+	ES_CONTINUE,		/* Continue current operation */
 };
 
 struct es_fault_info {
diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index 9a5e16f70e83..ed4b207ea362 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -369,20 +369,23 @@ static enum es_result __vc_handle_msr_caa(struct pt_regs *regs, bool write)
 }
 
 /*
- * TSC related accesses should not exit to the hypervisor when a guest is
- * executing with Secure TSC enabled, so special handling is required for
- * accesses of MSR_IA32_TSC and MSR_AMD64_GUEST_TSC_FREQ.
+ * Some of the TSC related accesses should not exit to the hypervisor when
+ * a guest is executing with Secure TSC enabled, so special handling is
+ * required for accesses of MSR_IA32_TSC and MSR_AMD64_GUEST_TSC_FREQ.
  */
 static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool write)
 {
 	u64 tsc;
 
+	if (!(sev_status & MSR_AMD64_SNP_SECURE_TSC))
+		return ES_CONTINUE;
+
 	/*
-	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is enabled.
-	 * Terminate the SNP guest when the interception is enabled.
+	 * GUEST_TSC_FREQ read should not be intercepted when Secure TSC is enabled.
+	 * Terminate the SNP guest when the read interception is enabled.
 	 */
 	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ)
-		return ES_VMM_ERROR;
+		return write ? ES_CONTINUE : ES_VMM_ERROR;
 
 	/*
 	 * Writes: Writing to MSR_IA32_TSC can cause subsequent reads of the TSC
@@ -417,8 +420,9 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		return __vc_handle_msr_caa(regs, write);
 	case MSR_IA32_TSC:
 	case MSR_AMD64_GUEST_TSC_FREQ:
-		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
-			return __vc_handle_secure_tsc_msrs(regs, write);
+		ret = __vc_handle_secure_tsc_msrs(regs, write);
+		if (ret != ES_CONTINUE)
+			return ret;
 		break;
 	default:
 		break;

Regards,
Nikunj

