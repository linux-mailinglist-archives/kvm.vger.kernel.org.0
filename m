Return-Path: <kvm+bounces-7048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB61683D35C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:13:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 337071F2181A
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E1A1BA4B;
	Fri, 26 Jan 2024 04:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KaMyBT9W"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2083.outbound.protection.outlook.com [40.107.102.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03395D26B;
	Fri, 26 Jan 2024 04:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706242404; cv=fail; b=lx0k/L3WEbZ70jYSfde0eS5R8I6C4/Ch/Oh9ds1ob3CpBfnpT3CO+TB2qScy918vDEhLBSkkPxsBGPveZzmVIqYemQQZQ9Q9Y10AMk1QCxuFBOLrEx/FnFv17K8+8RGBMAmLijofSMoRYsS74+ucGV4WdLd5a2tWED+lHayr0kY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706242404; c=relaxed/simple;
	bh=pYfM9IwmJyyGjYeDAzotoOejXJxFkVl0d9cbNE7pXRg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CvVqwJgOMMMpyNhuKglaKDZgQtr6pYv8RWcCspmWjdgrvagC1LZtEFDq6jNsVEUDo7RdVmrnVdKE0UTjWd/NDthQ91oFSLKqA5OASBBDNmQ0+M9L2drQ5Cf6TDakb8/CDqF1vqph4ehWFTAMYXH/Zt+DncqAI+HGdmMf5zvaozU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KaMyBT9W; arc=fail smtp.client-ip=40.107.102.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9dSoh2VujHke1Q7e7XYwv6p2DsYXEd6fihzUL5AEsb8HNbJeZFT0vCRIcroF7FqXWzV1RSOk3K0UmaZyliIQ6L2/tXl7V93PKleuCQJisHo4ZOK1+JItLKZKb5jWktGX11sRPkdpfAZ8OEMz4k55kE5huoHO8p5Ey9xzlU8kxImqar61D58IcvuFqZk8IJT5f0ER8rO4ek+Cb0HljHNg3aThtl8wT+4/s8eJZWh9ua91/rOD4JWaNyPrnCgENqgwrVjfA/XbSWZotVeWE7p9O7MH8l7ngFVWUBuAJ8tNhcVYeNWQEvI0ULidXmiv7tEkiorRER7CW7qHt/0i+REKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30bqNEPSXx00DdyDHfErp0hXLeARwrgeWUSkeh5nqlw=;
 b=KtSDrr5N8HmR5EhtkS5Q+LY9NI7KHWd3L8iN+QYNEjOOWj9o6BQaUOVv6VfE0OVt6pAN+4HXBPjoe853lI6gadeCYmZUA5g6EJUYmDbG+asvPmAKojtdorQpTBd06OerYaXfgeHKhEezTjFlW5ybTRscl4KCemlSm87G1rr7pXfXaWjX0ODlsSzz4cuiAr6Ic9IRkTxjtEj3/7xOK/Xb2kR0U6/AEZNMtXj9RqGdEsLeGssZWCuGV2Abw8QD2Ezi0iliZ6wziM3xCLZAuRE93rB8D/S8ABLhGB50MjKeBL3LCz1AYhahWT/w8r6L75cK0i1tB/z9hHW6awKN1xwQxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30bqNEPSXx00DdyDHfErp0hXLeARwrgeWUSkeh5nqlw=;
 b=KaMyBT9W7HHcjIQKLiSW5JyGteFr08Gyx4EJhIiAJsFSLi8gXlRVhdxwEL22GwurEtWdcixxeJ52gQ1wpttn/a50cjcN6U/I+eviJboNIwn9pA+xRY+A6IQvAcJLMDgSe15MufZRQ/6NCk3cHefDGFd4DvaV+ciImmOiF0TX/V8=
Received: from SJ2PR07CA0017.namprd07.prod.outlook.com (2603:10b6:a03:505::17)
 by SA1PR12MB7222.namprd12.prod.outlook.com (2603:10b6:806:2bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Fri, 26 Jan
 2024 04:13:20 +0000
Received: from SJ1PEPF00001CDD.namprd05.prod.outlook.com
 (2603:10b6:a03:505:cafe::50) by SJ2PR07CA0017.outlook.office365.com
 (2603:10b6:a03:505::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22 via Frontend
 Transport; Fri, 26 Jan 2024 04:13:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDD.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7202.16 via Frontend Transport; Fri, 26 Jan 2024 04:13:19 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:13:17 -0600
Date: Thu, 25 Jan 2024 20:48:34 -0600
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
	<pankaj.gupta@amd.com>, "liam.merwick@oracle.com Brijesh Singh"
	<brijesh.singh@amd.com>, Jarkko Sakkinen <jarkko@profian.com>
Subject: Re: [PATCH v1 13/26] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Message-ID: <20240126024834.asrwn67nhkt6jdtr@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-14-michael.roth@amd.com>
 <20240115195334.GHZaWNPiqbTg82QS_A@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240115195334.GHZaWNPiqbTg82QS_A@fat_crate.local>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDD:EE_|SA1PR12MB7222:EE_
X-MS-Office365-Filtering-Correlation-Id: f9b80b06-85af-4fba-e451-08dc1e2520ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aEOHZhsYxazF+oY+l9qlpZbYXHNUY2sw86FFPb5ReR/Zbt+ioVQlTeACL9msWdggzYV70k/aBHSWoxHoExxHL+sjDIn2z0O1DmmzCwuHxiLeqO7awWL+mGgTDqLn3w3QbcvBajNt1EiX17a/U58Lh4ExdmW3djP+MDrnPP+tmCmHzaBZHrSWvBEJoMdKS09QE5yqzljv4ls+ryWuZt6sEZtcsvdT3PpqeMzBy+Z1qOfr4vG8bhujcRCtWxYa/YUskWGnk1gJ21RWwajtDhks7sZRES5eii1PkgvRtuk8ZnmQ2ddck5FM4NNr5XZOHku27icjEgndQDn78ARuW+Hnc+dVUNSOe0rSsJmiwPahpKA4kRlTeL7VNl3yloweuqBqizRsrGYCQcxUHx78/bo/n5FUc+S46xwu2LxHcwVgGRAOZUxV5GFfVnObSL+VXEC25M7hZyRAVAfBfUJcEKxoaM8EyodsjSM3ZZmOPO9qSqZ1N3xuchhhpIYi2v2Qh+pqWBYbRB9fDoO9fVJuhzV4Tt/Fp1dngf7Q962zEGKpOo7975r+cu8R2yphW/qzQAoJkhcwCs7MkAzkbGX2iXeMQm/SB0di2Ng9DhV/QjdNSKPed3M1lMnNAPvh51yIPmvqRxmMYMaZiPGY8Qj5QuJRGFEHxgGfwzR8LAGehAEYkB95TleLW9pRC6N5UYU75hCcZDTpfdYKJS/td7kI/yMAPF/8PeEQW9vp9xwV7lQA4lrUFBGetENM2mTizp8HDEMe5lgEqkFE60C+SpOeau9mLw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(136003)(376002)(230922051799003)(64100799003)(451199024)(1800799012)(82310400011)(186009)(36840700001)(46966006)(40470700004)(6666004)(82740400003)(36860700001)(5660300002)(7406005)(7416002)(81166007)(2906002)(44832011)(36756003)(356005)(41300700001)(336012)(4326008)(16526019)(26005)(426003)(8936002)(86362001)(966005)(47076005)(1076003)(2616005)(54906003)(8676002)(6916009)(83380400001)(478600001)(70586007)(316002)(70206006)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:13:19.3602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b80b06-85af-4fba-e451-08dc1e2520ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7222

On Mon, Jan 15, 2024 at 08:53:46PM +0100, Borislav Petkov wrote:
> On Sat, Dec 30, 2023 at 10:19:41AM -0600, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > Before SNP VMs can be launched, the platform must be appropriately
> > configured and initialized. Platform initialization is accomplished via
> > the SNP_INIT command. Make sure to do a WBINVD and issue DF_FLUSH
> > command to prepare for the first SNP guest launch after INIT.
> 							  ^^^^^^
> Which "INIT"?
> 
> Sounds like after hipervisor's init...

This is referring to the WBINVD/DF_FLUSH needs after SNP_INIT and before
launch of first SNP guest. I'd actually already removed this line from
the commit msg since it's explained in better detail in comments below
and it seemed out of place where it originally was.

-Mike

> 
> > During the execution of SNP_INIT command, the firmware configures
> > and enables SNP security policy enforcement in many system components.
> > Some system components write to regions of memory reserved by early
> > x86 firmware (e.g. UEFI). Other system components write to regions
> > provided by the operation system, hypervisor, or x86 firmware.
> > Such system components can only write to HV-fixed pages or Default
> > pages. They will error when attempting to write to other page states
> 
> "... to pages in other page states... "
> 
> > after SNP_INIT enables their SNP enforcement.
> 
> And yes, this version looks much better. Some text cleanups ontop:
> 
> ---
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 85634d4f8cfe..7942ec730525 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -549,24 +549,22 @@ static int __sev_snp_init_locked(int *error)
>  		return 0;
>  	}
>  
> -	/*
> -	 * The SNP_INIT requires the MSR_VM_HSAVE_PA must be set to 0h
> -	 * across all cores.
> -	 */
> +	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
>  	on_each_cpu(snp_set_hsave_pa, NULL, 1);
>  
>  	/*
> -	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list of
> -	 * system physical address ranges to convert into the HV-fixed page states
> -	 * during the RMP initialization.  For instance, the memory that UEFI
> -	 * reserves should be included in the range list. This allows system
> +	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list
> +	 * of system physical address ranges to convert into HV-fixed page
> +	 * states during the RMP initialization.  For instance, the memory that
> +	 * UEFI reserves should be included in the that list. This allows system
>  	 * components that occasionally write to memory (e.g. logging to UEFI
> -	 * reserved regions) to not fail due to RMP initialization and SNP enablement.
> +	 * reserved regions) to not fail due to RMP initialization and SNP
> +	 * enablement.
>  	 */
>  	if (sev_version_greater_or_equal(SNP_MIN_API_MAJOR, 52)) {
>  		/*
>  		 * Firmware checks that the pages containing the ranges enumerated
> -		 * in the RANGES structure are either in the Default page state or in the
> +		 * in the RANGES structure are either in the default page state or in the
>  		 * firmware page state.
>  		 */
>  		snp_range_list = kzalloc(PAGE_SIZE, GFP_KERNEL);
> @@ -577,7 +575,7 @@ static int __sev_snp_init_locked(int *error)
>  		}
>  
>  		/*
> -		 * Retrieve all reserved memory regions setup by UEFI from the e820 memory map
> +		 * Retrieve all reserved memory regions from the e820 memory map
>  		 * to be setup as HV-fixed pages.
>  		 */
>  		rc = walk_iomem_res_desc(IORES_DESC_NONE, IORESOURCE_MEM, 0, ~0,
> @@ -599,14 +597,13 @@ static int __sev_snp_init_locked(int *error)
>  	}
>  
>  	/*
> -	 * The following sequence must be issued before launching the
> -	 * first SNP guest to ensure all dirty cache lines are flushed,
> -	 * including from updates to the RMP table itself via RMPUPDATE
> -	 * instructions:
> +	 * The following sequence must be issued before launching the first SNP
> +	 * guest to ensure all dirty cache lines are flushed, including from
> +	 * updates to the RMP table itself via the RMPUPDATE instruction:
>  	 *
> -	 * - WBINDV on all running CPUs
> +	 * - WBINVD on all running CPUs
>  	 * - SEV_CMD_SNP_INIT[_EX] firmware command
> -	 * - WBINDV on all running CPUs
> +	 * - WBINVD on all running CPUs
>  	 * - SEV_CMD_SNP_DF_FLUSH firmware command
>  	 */
>  	wbinvd_on_all_cpus();
> 
> 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

