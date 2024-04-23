Return-Path: <kvm+bounces-15686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA7F8AF42A
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66E242850FB
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD211DFF9;
	Tue, 23 Apr 2024 16:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OI9CW0u3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7635E3217;
	Tue, 23 Apr 2024 16:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713889939; cv=fail; b=I14tUtFYWBtgSccw/iaPAKcnVJptuRioc0BOeMX95O1klyxYBNPdY9Hqo85khVX7nrVc9ZV3efMyKA9ZTLIkELjXl0aaggLulqBuLJrxLZBwCcjAOWj36QCcTZvG3O3jRA/9phQMuQzAzSo9K60aNAZTov3djMHJJYId85UcgAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713889939; c=relaxed/simple;
	bh=oWQbavaizd3MHCPas86JdWOgMd0+CMuQqjDDAzvwe8U=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:CC:
	 To:Date:Message-ID; b=JHCJ4g26Man4zD0OP0TADhdwNciJDRUuTWXFZtgBL48oDDoHt39aQHGWHSKKorHPY2dvG/GqBILmaor8I20OhWvni+iSQ1NuuYNXNk+GwvQVeHvug44I/Uw96jx+g3wNX2dDg2Hdf/ctu67x+K9mmBrKBb7IXsn+TWOUqPeRukE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OI9CW0u3; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsTwHAU4sZ9iBFpISsFpajj+eKbeCiJWRdsAcp5zeW2qeQf8SCW956cyhfMORyInlKdAbWSOw4OV3qVOnZlZOxjBQZsKzfzQp/z/FL106e6PSKEfjTMh+X/kx2/1aByyB1xdUwD8h5ddkdewUmsF3hbDUJlFYDIwxjjUJVY8Zq4uzADswhNIpqiZ6cCs/7B2THubrgGWeGswu5VWjwvUbluaVYARyPBJ7GEMpjsNbCqZTNnpu9zU3Bf7vtkeEFZp0z2rAmWpkr2jZgoDjjEdUDtHA5gA2LHhm3uWB/g+4MxXxgW8remwAZJk/MbtJDlj/luXLevot2sjXrOeG4iT7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1/MD3a7C5GLx96Ue1RmzC2OyzAylDOJ09+yC+W99IzQ=;
 b=RQV11kUIqyTOrvE1zvkYWWCyivab1xVc1uF27CL+bdADOF1xzTIvx1P4vyAkhfqYQyuKbahh5QaK2DOQF2cgpKMfTBoyg1rPaVDGigb4lCcnPlnPgPumTg7c1V4AhGKQ9T7TMxPPpc3vTqPDaSFXTyYscsNSZLiSAf8AgINYjiGQpJVVOS/ICygupeE3G5y4Nsx7XrqL6kZ5pLOjHXwEPikZamVDAD0oSOs5Q5x5AOMyqEBL+IBs0P03eEO4/YSr8xkLiXhts2chWxrAwo5iAcbCNBkQ3C4Oul6V5mmyb+iFD/G908vCu8k+TZOE0Y6GtaTBkVdVxMN/gvmpJb0ktg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/MD3a7C5GLx96Ue1RmzC2OyzAylDOJ09+yC+W99IzQ=;
 b=OI9CW0u3WRLO3ViA6KvZfJgmF3fOz6R1Lr0nQZDIvZMv3UKowmvIGVUyMiacNppNzcqowKkmYycR+NKuwos2jNXO7E6erIdzjpO9gNBkrmT926vXUDSps1oXyjPehrr+We0QxYR/SJhGkHaFxnbIIZENGnmEcgknRPNLMnyBIf0=
Received: from MW4PR03CA0140.namprd03.prod.outlook.com (2603:10b6:303:8c::25)
 by CH3PR12MB7594.namprd12.prod.outlook.com (2603:10b6:610:140::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 16:32:14 +0000
Received: from CO1PEPF000042A7.namprd03.prod.outlook.com
 (2603:10b6:303:8c:cafe::27) by MW4PR03CA0140.outlook.office365.com
 (2603:10b6:303:8c::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.34 via Frontend
 Transport; Tue, 23 Apr 2024 16:32:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042A7.mail.protection.outlook.com (10.167.243.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Tue, 23 Apr 2024 16:32:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 23 Apr
 2024 11:32:08 -0500
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240421180122.1650812-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
Subject: Re: [PATCH v14 00/22] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
From: Michael Roth <michael.roth@amd.com>
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
To: <kvm@vger.kernel.org>
Date: Tue, 23 Apr 2024 11:31:53 -0500
Message-ID: <171388991368.1780702.14461882076074410508@amd.com>
User-Agent: alot/0.9
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A7:EE_|CH3PR12MB7594:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f30532-0467-4c79-fdf2-08dc63b2ebe6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OGUrcUhQM2hGSTBoK1B5S24rZkw4VXVGeWZ1ckpmR1BKK0loTURhalpsVGgx?=
 =?utf-8?B?L2s5NWRxQkthTHd4czYrekgrMkFacnJrc3o4eWxtbUg5MVhNWjBjTkMxdW8x?=
 =?utf-8?B?ZndaMjFkNzBlN2NGeStJMktRRlp6NWtzb0didUQ5Y3U5VmVrbDZWMmhPWnRF?=
 =?utf-8?B?cUhUaGprVFZnK0xPNE9jSVpQamVaMEo2T056TFpVVFlHSW0vY0F1Ukd5TzRt?=
 =?utf-8?B?N1VRNVFpZHpnMmI5ejdHYjVZUktyTm5ZbVVKRUxyeEZvSWNwc2lWZ1BJMGpU?=
 =?utf-8?B?bTNGamsxV3lKaldHVzBwVjFvbXg4dld1Y3hHM3VndlBsclRCNTZOZTNOb1Zz?=
 =?utf-8?B?dGlKWVhQRGpnK2h3RmVWbHllNENJWnp1S2t6enRpblk1Rk5KZTJhNHZXRnk3?=
 =?utf-8?B?U0VyczBhc1ZMSXZxdUtIQkM3SmZLdDRRcmEyZE0wckdCYVNHVXVPNDNwVGdS?=
 =?utf-8?B?RE1VcWdzMDNCckRFTGl0UE5iS3pyWEVsYnNwZkM5RG50ZUFJUy9ibStUNzYw?=
 =?utf-8?B?ejZwcG5RRUJGYTBIMjhXemhTOGQ4L0N0cldsYUFzdjMxMldGT2RCcmkyS2FP?=
 =?utf-8?B?VU41Wmh0Ni9DRjVNWlpLVGV3emRiWWtMTzcxc2UwQ2E4dWFVV2ZXWit3dFl2?=
 =?utf-8?B?NHdIWTVKVS9oeENvaDhHb1RhZHY3STlia0IxQ0dHNklEcHdmU1JlTDN6K002?=
 =?utf-8?B?TWw2MFdIRHFzc0JzaUtqaUtOY3hTOUlxTi9qUzhOR1U5M0tUSGpXSjFuMmxO?=
 =?utf-8?B?SENacHdHT25nMUJJMnVIQVc3VmZGSmg0cWFVWUoxKzVheEdXREdUYVJWU0Qw?=
 =?utf-8?B?aDdvVDRLV3NhaWVaZEJlVUhWY3h4S20xdDROVGxwelVuNGtod21UZUpCMDh0?=
 =?utf-8?B?VDRuNnk1RmFSTlJEUW1kclFxSmM5elAxWWhKa1VmdkdidU5FR3Bhd2NyMXUy?=
 =?utf-8?B?bUFpUFJHS2cvL0pCZzlrTEY1QUxqUnpTbVIxOXN3ZmoyZ1MxZU92NDV6dVR2?=
 =?utf-8?B?THA5V1c1MUcyaEM1c3RPYTJBdDNRdUxReXFZYnhMekFLa0FZL1R4UkdDQ1dy?=
 =?utf-8?B?VmU4aTIzbGZMT29yckFpM1hTbmR1RktwaDJEaHRKdWRndE8wTTZYVjhmSmwy?=
 =?utf-8?B?OW5vMmdVNnZoNXpVbTlZd1FKNmFNWHFmamVlVnAxNzhyZFB0RU4wSzgyK1pk?=
 =?utf-8?B?WWs5QW1hdTBwYXg2a2UrbHgreDFqdUZFZWtKdXhBMU5BTG9GQjlHQjg0cUJi?=
 =?utf-8?B?b0kxVDUyUWV1cXdiN3V4R3l2bVg5R2xuMXhqMlZGVE5hMitYSlRkSEtadUxw?=
 =?utf-8?B?aUNNSXBzdTBOZWlvelRyQVpqMWhvMlg4cFg1SzZYQW53OWVQamw3UWkxTlhR?=
 =?utf-8?B?TEFWYUQ0UEYrNnFQWlJZSVNIWUFMeDFjVXM2ME1STENWNkh4akNmakZDY0Jy?=
 =?utf-8?B?THJkelg2dUlaL1FMSURqWUVJUmdtYTgwanhpcyt6bkZld04yL0dNTzN1cGIy?=
 =?utf-8?B?TUVTY1ZMckxTeEVJU2RhQkFhU1g5K0phNkY2NzAzQmIzUjVNaTFxcGl2dnU2?=
 =?utf-8?B?OXJkS016YlBWNVlSeUp4d05wZVdTOHVXVlNVRlptTDA1aXhySHZwYmNqR2tD?=
 =?utf-8?B?Zzd6Z2lETmhIMzdFRnd0SFRxWGdTcm9od2h5RDdsVVBiVVhseHhSeDV5bTNQ?=
 =?utf-8?B?TEVSUkoxMVI0QWFTa01DclNuUUxXOHpJVmVvY0RQMGxSb2dUektsOUx4TDFo?=
 =?utf-8?B?REtDNXN1cEJ6dUR5Sm5OWnRFbWV4MG9sME1vc2o4RHFtc3F2T1d3bkYwdHBu?=
 =?utf-8?B?cW5TVG9UWjlwV2ZGdDJYMm1rb0l6QTNpOUllMHZWNnQ2K1drbGV1SGJwUlJu?=
 =?utf-8?Q?SygGM+i6Ww5/O?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(36860700004)(7416005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 16:32:09.1474
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f30532-0467-4c79-fdf2-08dc63b2ebe6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7594

Quoting Michael Roth (2024-04-21 13:01:00)
> This patchset is also available at:
>=20
>   https://github.com/amdese/linux/commits/snp-host-v14
>=20
> and is based on commit 20cc50a0410f (just before the v13 SNP patches) fro=
m:
>=20
>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=3Dkvm-coco-queue
>=20
>=20
> Patch Layout
> ------------
>=20
> 01-04: These patches add some basic infrastructure and introduces a new
>        KVM_X86_SNP_VM vm_type to handle differences verses the existing
>        KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.
>=20
> 05-07: These implement the KVM API to handle the creation of a
>        cryptographic launch context, encrypt/measure the initial image
>        into guest memory, and finalize it before launching it.
>=20
> 08-13: These implement handling for various guest-generated events such
>        as page state changes, onlining of additional vCPUs, etc.
>=20
> 14-17: These implement the gmem hooks needed to prepare gmem-allocated
>        pages before mapping them into guest private memory ranges as
>        well as cleaning them up prior to returning them to the host for
>        use as normal memory. Because this supplants certain activities
>        like issued WBINVDs during KVM MMU invalidations, there's also
>        a patch to avoid duplicating that work to avoid unecessary
>        overhead.
>=20
> 18:    With all the core support in place, the patch adds a kvm_amd module
>        parameter to enable SNP support.
>=20
> 19-22: These patches all deal with the servicing of guest requests to han=
dle
>        things like attestation, as well as some related host-management
>        interfaces.

I just sent an additional set of fixups, patches 23-29. These add some
additional input validation on GHCB requests, mainly ensuring that
SNP-specific requests from non-SNP guests result in an error as soon as
they are received rather than reaching an error state indirectly further
into the call stack.

It's a small diff (included below), but a bit of a pain to squash in
patch by patch due to close proximity with each other, so I've pushed an
updated branch here that already has them squashed in:

  https://github.com/amdese/linux/commits/snp-host-v14b

If preferred I can also resubmit as v15, just let me know.

Full diff is below.

Thanks!

-Mike


diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1cec466e593b..1137a7f4136b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3280,6 +3280,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *s=
vm)
 			goto vmgexit_err;
 		break;
 	case SVM_VMGEXIT_AP_CREATION:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto vmgexit_err;
 		if (lower_32_bits(control->exit_info_1) !=3D SVM_VMGEXIT_AP_DESTROY)
 			if (!kvm_ghcb_rax_is_valid(svm))
 				goto vmgexit_err;
@@ -3289,10 +3291,19 @@ static int sev_es_validate_vmgexit(struct vcpu_svm =
*svm)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
-	case SVM_VMGEXIT_PSC:
 	case SVM_VMGEXIT_TERM_REQUEST:
+		break;
+	case SVM_VMGEXIT_PSC:
 	case SVM_VMGEXIT_GUEST_REQUEST:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto vmgexit_err;
+		if (!kvm_ghcb_rax_is_valid(svm) ||
+		    !kvm_ghcb_rbx_is_valid(svm))
+			goto vmgexit_err;
 		break;
 	default:
 		reason =3D GHCB_ERR_INVALID_EVENT;
@@ -3970,6 +3981,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcp=
u_svm *svm)
 				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
 	case GHCB_MSR_PREF_GPA_REQ:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto out_terminate;
+
 		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_NONE, GHCB_MSR_GPA_VALUE_MASK,
 				  GHCB_MSR_GPA_VALUE_POS);
 		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_RESP, GHCB_MSR_INFO_MASK,
@@ -3978,6 +3992,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcp=
u_svm *svm)
 	case GHCB_MSR_REG_GPA_REQ: {
 		u64 gfn;
=20
+		if (!sev_snp_guest(vcpu->kvm))
+			goto out_terminate;
+
 		gfn =3D get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
 					GHCB_MSR_GPA_VALUE_POS);
=20
@@ -3990,6 +4007,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcp=
u_svm *svm)
 		break;
 	}
 	case GHCB_MSR_PSC_REQ:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto out_terminate;
+
 		ret =3D snp_begin_psc_msr(vcpu, control->ghcb_gpa);
 		break;
 	case GHCB_MSR_TERM_REQ: {
@@ -4004,12 +4024,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vc=
pu_svm *svm)
 		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
 			reason_set, reason_code);
=20
-		vcpu->run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
-		vcpu->run->system_event.type =3D KVM_SYSTEM_EVENT_SEV_TERM;
-		vcpu->run->system_event.ndata =3D 1;
-		vcpu->run->system_event.data[0] =3D control->ghcb_gpa;
-
-		return 0;
+		goto out_terminate;
 	}
 	default:
 		/* Error, keep GHCB MSR value as-is */
@@ -4020,6 +4035,14 @@ static int sev_handle_vmgexit_msr_protocol(struct vc=
pu_svm *svm)
 					    control->ghcb_gpa, ret);
=20
 	return ret;
+
+out_terminate:
+	vcpu->run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
+	vcpu->run->system_event.type =3D KVM_SYSTEM_EVENT_SEV_TERM;
+	vcpu->run->system_event.ndata =3D 1;
+	vcpu->run->system_event.data[0] =3D control->ghcb_gpa;
+
+	return 0;
 }
=20
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu)

