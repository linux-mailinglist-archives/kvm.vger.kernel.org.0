Return-Path: <kvm+bounces-7142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D7583DB17
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:40:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D7651C20FBA
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 13:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E4D1B963;
	Fri, 26 Jan 2024 13:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SgJJOgf+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD941BF4E;
	Fri, 26 Jan 2024 13:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706276369; cv=fail; b=HjkbYLXZBMI7d+r6ohUuDOiDVbrXNIK53NUh2bim6MH3IOhnWHxD+OBrqHlF01WNvQJdWYmeUj1mZnE4En1ubW7sKj6e+7A8U84XuMWQ/yC1cQ1/XUhZhqF/OlfJDUF2GV4xs2Irgutai+Nu1vLtYUbxp4U3kpPXkbyFV/IMWag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706276369; c=relaxed/simple;
	bh=pKpbKCPrqY0CBIWmu68/dGpC1htehyiHbLn5M3shDFk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2A960Pbfuc7PZX2ffHj8JKo9LPJzAE63Slch5eq/u15uHRowoynP8npJtBsXFXmmdo6lG/o0UkvwaR95yszfW/qIf9QhVSDbO92k1Sd/mFGPHgLW4e06lxsmIP1bskwN6SCOefocgGk8AWtd3ZjdQ5rfqmhmO2nr6eefGTZV+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SgJJOgf+; arc=fail smtp.client-ip=40.107.244.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gn7ZVLZS58vayPogvEKeCYrUemCNbQMUJ1ej6pKi9V4y8FexNOQrbwV8DeP8IEmKCLaKZhw316MtDLWcewTyA8EtrlLfxYosoZdh26y2krB8AtfFODTpe8rlrJPZUXEZUxKzzXLYr/Vyp5DIeIlRa7U5L+7+Eq+aGMtplGFDCl3aTccLoDMHfreH93K3JwftPlcpKQ8ZtchEGik0jVoq8HtFUv8nRPH3pqsYJ+ukLR4oSi053oTA1gz/5/SfZwgapkf48B4gztaItt5nTIzYqe0LTS/LLPb/h5HyMG0UxAlwDgbKvHpGUG4AaCdwXHaJ3bAPTowe+BI0ZmE/v8+i4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=puosVlpQpS52Ge3Gq6Zq3LUdc2fSyxH6zIuXs7Ico5w=;
 b=eIRRMjX88sThLGicQ0QWakBVASxbjLOQ0UNIhT5E78qlTGk+vRNqJVAI2QAUxHuMqjdUkcNt2XLcRDC03fttiNQdligMrs9jPWnNhy2IyQNHCDVRM3cE71g+4wQNKBvY3rpFcISYzHJWKB3hKniEFFbuyu9BtqEE52dfsQWZiizOynIWnS3M94fyrf0GmBY/MxH7VHqKcpe2m1xIBr7TM/4SW5cwY0wP/a5GQCeUkHv+tin1vTgOgoSASf/ULDl4hF9XHpSIlh9P+jXxOyJRocad7I1JWLMZ+ByLrGBQJbOn/v+0+2PxXQhQBFbOP+NnUeYvz3IXs8LrQbkM3upLkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puosVlpQpS52Ge3Gq6Zq3LUdc2fSyxH6zIuXs7Ico5w=;
 b=SgJJOgf+fXpXpDZuIyhFN6Nnin7jOKvPhFs9/SFwF8jtycNgVTf6rzvK3kRZl6f1xwBCGfdxnkn4BzdHEUXyMsPMiMOmcsuD2upl7ieW8spHJeuGw5OOjDSreEJ1T7KzUSSB1UED4CHWFKNz3mwMxuCEuLM5KP47FoaSbwdvk9M=
Received: from BN0PR02CA0027.namprd02.prod.outlook.com (2603:10b6:408:e4::32)
 by LV2PR12MB5893.namprd12.prod.outlook.com (2603:10b6:408:175::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 13:39:23 +0000
Received: from BN1PEPF0000468B.namprd05.prod.outlook.com
 (2603:10b6:408:e4:cafe::d3) by BN0PR02CA0027.outlook.office365.com
 (2603:10b6:408:e4::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.28 via Frontend
 Transport; Fri, 26 Jan 2024 13:39:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000468B.mail.protection.outlook.com (10.167.243.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 13:39:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Fri, 26 Jan
 2024 07:39:23 -0600
Date: Fri, 26 Jan 2024 07:30:36 -0600
From: Michael Roth <michael.roth@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>, Alexey Kardashevskiy <aik@amd.com>, Dionna Glaze
	<dionnaglaze@google.com>
Subject: Re: [PATCH v1 26/26] crypto: ccp: Add the SNP_SET_CONFIG command
Message-ID: <20240126133036.q2o7of7yqeroqupj@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-27-michael.roth@amd.com>
 <20240121124102.GPZa0Q3oBHLG0fH_yn@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240121124102.GPZa0Q3oBHLG0fH_yn@fat_crate.local>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468B:EE_|LV2PR12MB5893:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a644811-8888-445d-b87b-08dc1e74351f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NMZElG1faHv2CBAVc/uAOPK1iJBPR1isDJ35dmkzoduXpiGRz+leNH5Ar+mmKSrXvvE89Niy1adpZnz87CPuS2hoP+NV/3c5FbqYmC9eEtI46/D31nBPUZbMeXv2WIyDx82C71uIzN2HMpeIuHcPREr+rTUHHMPdvE/rpIsNjtaOPZvfr/WaKnYQUS3kuKJvDja6QBdgMlGa1ze9M0seYqeQ6wlBa/U8kfLHM9HhhCgerf1Ws96D2I/DrrqLsSBtSoZdb7xT5K8cVuyvl0aXTHmGvsDZdAicINtUMDTsl0XqcjHnlfI2Tqq3wq/rZHUQS0vGTaaEFD2S3peztiaXqmgDt29t7XZpZAxTSIZ4ZNix+WbiB9xgZtwQ3OYGIi6XlZaxJnZIfckM/0AHeVU0YXFk9nWsQ43PXqfwtbhaLwy45tnDlH73FrMMzJg4Wkp7PkJz2aZoUaoPGyw0yIzKkDq+Jt74WcezZDfzs9yxd0VAst0UJxLgLIp69vP+lk2MCHKwTTIjnWXzScGB+wzlaiTf8fAzQj2hoOHmH3JRqU/iMdd0Ed9y6TD/B3kDq9QEMoEKT4hm2dTFjlSYpJ5uoHxX1DpX8Pf4D5FQ3VtU4ttR7DMFUJ+A5cezpwnzwdwK7ZMBujfWKg36pehMKGQDXQEzmLbPZ2wS0uec14odqLLy29kSfG3nJJXshSDpDxdgLym9EmLk4YQkjzkOeyKEGDayrVFXj7cHiO1RenK7SIfOMEhsf4b8vXxoTQKNUNYrvl7Atf719G+HwUc4e9wOJA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(39860400002)(376002)(346002)(230922051799003)(451199024)(186009)(64100799003)(82310400011)(1800799012)(40470700004)(46966006)(36840700001)(1076003)(40480700001)(40460700003)(44832011)(2616005)(82740400003)(47076005)(16526019)(6666004)(36860700001)(336012)(966005)(26005)(426003)(478600001)(8676002)(8936002)(81166007)(4326008)(316002)(70206006)(6916009)(54906003)(70586007)(356005)(5660300002)(86362001)(41300700001)(7416002)(7406005)(36756003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 13:39:23.5297
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a644811-8888-445d-b87b-08dc1e74351f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5893

On Sun, Jan 21, 2024 at 01:41:02PM +0100, Borislav Petkov wrote:
> On Sat, Dec 30, 2023 at 10:19:54AM -0600, Michael Roth wrote:
> > +The SNP_SET_CONFIG is used to set the system-wide configuration such as
> > +reported TCB version in the attestation report. The command is similar to
> > +SNP_CONFIG command defined in the SEV-SNP spec. The current values of the
> > +firmware parameters affected by this command can be queried via
> > +SNP_PLATFORM_STATUS.
> 
> diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
> index 4f696aacc866..14c9de997b7d 100644
> --- a/Documentation/virt/coco/sev-guest.rst
> +++ b/Documentation/virt/coco/sev-guest.rst
> @@ -169,10 +169,10 @@ that of the currently installed firmware.
>  :Parameters (in): struct sev_user_data_snp_config
>  :Returns (out): 0 on success, -negative on error
>  
> -The SNP_SET_CONFIG is used to set the system-wide configuration such as
> -reported TCB version in the attestation report. The command is similar to
> -SNP_CONFIG command defined in the SEV-SNP spec. The current values of the
> -firmware parameters affected by this command can be queried via
> +SNP_SET_CONFIG is used to set the system-wide configuration such as
> +reported TCB version in the attestation report. The command is similar
> +to SNP_CONFIG command defined in the SEV-SNP spec. The current values of
> +the firmware parameters affected by this command can be queried via
>  SNP_PLATFORM_STATUS.
>  
>  3. SEV-SNP CPUID Enforcement
> 
> ---
> 
> Ok, you're all reviewed. Please send a new revision with *all* feedback
> addressed so that I can queue it.

Thanks! Unless otherwise noted, I *think* I got everything this time. :)

-Mike

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

