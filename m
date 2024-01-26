Return-Path: <kvm+bounces-7047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5286083D35A
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:13:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AEDCEB231A1
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1094BA57;
	Fri, 26 Jan 2024 04:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QDScF4xs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C769473;
	Fri, 26 Jan 2024 04:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706242385; cv=fail; b=Tf3uCqwk26VP2GncAOdYpoCsbSSxi25uXY+Mywtzm+kYb97EdLxuKqDDVmvJM2rfFDEd3/EqEiFVo3waBMZPeWQq5BbZYk4ofvEmXDrICvqMMdj1vM6iYCCW4hKQtvZbLzj+bTK80mQvC0z4iZ6q+sPAMBVaBALg9IJnYauTiUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706242385; c=relaxed/simple;
	bh=BrP2+2cs6pDQFuZM0SRXFRJzUhS6VsUDrWE6Y4jto3k=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LpH4cjH6Ink1ixQ1E/YIcvDhXRmnGeUSYwp6ROAMz7/I8vvafZ2GD7Wg2JESQCJY8cD8FVED1jrLMeNffIYDxgLDHTfPQDQQeayiJbyNpZp/s2v+2BStvn0YjkqLKjYw9pd9boUIpHRTUHhzE88t4ldLFsFxQ3DYR0GWb7pLpaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QDScF4xs; arc=fail smtp.client-ip=40.107.237.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMsYq/LfmVzVD8JLkGFN4ZloqEeSLgBz4X8Omf+1AjS1Ill3veouq3QxmWzLhnGeZUm0Nb1yhRMrkn+pRh/AcaJdVlwCm39uf28XpnilTIcIiUzYFzNxzwazxvhqSOW96DxDncfYHwjTHl9pib7EBXbrWtBsZ4si3t9qcB5mTUHzEaPwn409nOn1M/GG+VFWuBSv0AI2WulH/z9mVb+jKPavAA9aPFkEIeicqrce0Xot6fwjAEm7QcsqP1KbuJV3vDPouPGjBTKjEXWkbjNZJv7eJ3rYQ8yyF4mqL15xdJvFvifbiLzfWcJcJP+fHMV8TBJasBSUQ8g2Ug5JrkonxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2aoYMd5BFF3lA5I85qP6E8VmiI1tgcmMTa2P650tSGc=;
 b=PInTksBEzY7Yh9Zz408KP9kZ6jQaQOE5hjNaUVKDxObspqoCC4ViJHEmvA9HoE7jU00lpVU5pzdyPupGWIFcKiMeYnWNJUvQHnGtcebmETHT97Cy+PLVFrZYeBJ0GHlTHwII6Me1W59yNLwoljx+MrsVMmMEAL8a2IKe35b6cD4f98Y7c7AbO7x7hvB0e7AmVXRUzK71jwg8WlrsFdOUJMCZh7F7Rrk8DtmntHF7BKCCXqpCA/RdEqmdR3JL3Gs52EiANuMHxhAH8sDnqAgSoOYp5deqa8xfdZGjmN7tFRMmP7wgG1cF2UminQCjT4dJm7czMPr6w4q++yhBDuR6jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aoYMd5BFF3lA5I85qP6E8VmiI1tgcmMTa2P650tSGc=;
 b=QDScF4xsK/8z+eTMu6Zp+3WKnM8pnXcbiQLc4hTMphSsubDFY8Vi2fHj0Mau3YppjAiHNwwVBDyXhyuBn2Mbkdj7ZyYao0odQQ7Lve1zkO/+HlHOVhdfWcIG8wOM46qIMyHzIr/kCxe2nPqcq6Ehf8RkMFYbQCGWnGERLkXOQRc=
Received: from SJ2PR07CA0023.namprd07.prod.outlook.com (2603:10b6:a03:505::9)
 by PH0PR12MB7488.namprd12.prod.outlook.com (2603:10b6:510:1e9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Fri, 26 Jan
 2024 04:13:00 +0000
Received: from SJ1PEPF00001CDD.namprd05.prod.outlook.com
 (2603:10b6:a03:505:cafe::47) by SJ2PR07CA0023.outlook.office365.com
 (2603:10b6:a03:505::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27 via Frontend
 Transport; Fri, 26 Jan 2024 04:13:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDD.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7202.16 via Frontend Transport; Fri, 26 Jan 2024 04:12:58 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:12:57 -0600
Date: Thu, 25 Jan 2024 19:56:19 -0600
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
	<brijesh.singh@amd.com>
Subject: Re: [PATCH v1 12/26] crypto: ccp: Define the SEV-SNP commands
Message-ID: <20240126015619.rjcid65vgo3s27za@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-13-michael.roth@amd.com>
 <20240115094103.GFZaT9r4zX8V_ax8lv@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240115094103.GFZaT9r4zX8V_ax8lv@fat_crate.local>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDD:EE_|PH0PR12MB7488:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ec5f402-94c8-4efe-4593-08dc1e25143c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	l8X6yHzKrzsEolfGLpWoMnfuis0XOfeD4+LECyxP9eRIvLAejlGDUwiMZ8nDjJ/xKe0Duj29olEJAyiU+wqLNU4NqFAzO1LAa9RhQHEiIMQdrkiCYU2dct20H9faN0NV2yBS4p1vg8wKlE43izapxhkmvZTyjJth1UP8vR6QQaCUmUsp3RngIr8bBs076tacSoNdwOD/zcxdQqVb6lojiSSyArJVjsbY9Idm3xH6VW0beoKjqkF33n+L+fVmW8TJS3zx9qdNqLqhBd4rxBjPhbI9DzlPjEAhcqu/BujdtzoBzVtqxibP0MnlQrkloi/J4HlPyxY5CEzywxv+UQZ2Rs1g6xbSTbtfydf/ESoBcGE0w5cx1czECnrqJQYibdP/SbBMEOG9Hh7DiAUIfFnVj4SAdWWDpv+vuxdKaNCDVbSjQCT9rBdVe9K97M/H8OFjsus4whR8bbw1XLqqM6xn70v7IFIqliuXO8KvxEQRmglDVFRbOp9zSmU25bb5/uw3UKOvzrJDpdm48yQ1435uoClZqSZ0nV7rgBWQe8QhXnSqx1eKTMtjv7T+T6Ofn3zOIUzuq6bnzqm699QY1mwRFmwHPttvCgiAZtlXFb4tGcG5gLSsI1eq5cJ/zeCebFCbrDtc3xGgImkHSNXjWyZNP/XlhiyK27FbjdMwFU9QUZ+39kVr/znr4iAz4TNuChScZQ39n7bRmL9ryMBnd3meDoSVEeNoR2BIcl/715exlkCKvd3FNfdaxyqm+TvmZei9h++H6t+DvNgN8630tZHO2w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(346002)(396003)(136003)(230922051799003)(82310400011)(186009)(451199024)(64100799003)(1800799012)(40470700004)(36840700001)(46966006)(83380400001)(41300700001)(1076003)(47076005)(2616005)(16526019)(336012)(26005)(8936002)(82740400003)(356005)(36860700001)(966005)(81166007)(8676002)(7416002)(70586007)(4326008)(5660300002)(7406005)(44832011)(70206006)(426003)(478600001)(2906002)(316002)(54906003)(6916009)(6666004)(36756003)(86362001)(84970400001)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:12:58.0635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec5f402-94c8-4efe-4593-08dc1e25143c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7488

On Mon, Jan 15, 2024 at 10:41:12AM +0100, Borislav Petkov wrote:
> On Sat, Dec 30, 2023 at 10:19:40AM -0600, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > AMD introduced the next generation of SEV called SEV-SNP (Secure Nested
> > Paging). SEV-SNP builds upon existing SEV and SEV-ES functionality
> > while adding new hardware security protection.
> > 
> > Define the commands and structures used to communicate with the AMD-SP
> > when creating and managing the SEV-SNP guests. The SEV-SNP firmware spec
> > is available at developer.amd.com/sev.
> > 
> > Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > [mdr: update SNP command list and SNP status struct based on current
> >       spec, use C99 flexible arrays, fix kernel-doc issues]
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  drivers/crypto/ccp/sev-dev.c |  16 +++
> >  include/linux/psp-sev.h      | 264 +++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/psp-sev.h |  56 ++++++++
> >  3 files changed, 336 insertions(+)
> 
> More ignored feedback:
> 
> https://lore.kernel.org/r/20231124143630.GKZWC07hjqxkf60ni4@fat_crate.local
> 
> Lemme send it to you as a diff then - it'll work then perhaps.
> 
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 983d314b5ff5..1a76b5297f03 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -104,7 +104,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_PAGE_RECLAIM	= 0x0C7,
>  	SEV_CMD_SNP_PAGE_UNSMASH	= 0x0C8,
>  	SEV_CMD_SNP_CONFIG		= 0x0C9,
> -	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX	= 0x0CA,
> +	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>  	SEV_CMD_SNP_COMMIT		= 0x0CB,
>  	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
>  
> @@ -624,7 +624,8 @@ enum {
>   * @gctx_paddr: system physical address of guest context page
>   * @page_size: page size 0 indicates 4K and 1 indicates 2MB page
>   * @page_type: encoded page type
> - * @imi_page: indicates that this page is part of the IMI of the guest
> + * @imi_page: indicates that this page is part of the IMI (Incoming
> + * Migration Image) of the guest

I'd added it in sev_data_snp_launch_start kernel-doc where you originally
mentioned it. I've gone ahead and clarification for all kernel-doc occurances
of IMI.

-Mike

>   * @rsvd: reserved
>   * @rsvd2: reserved
>   * @address: system physical address of destination page to encrypt
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

