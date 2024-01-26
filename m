Return-Path: <kvm+bounces-7049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B4F083D361
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:14:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9CC51F21B73
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8F6C139;
	Fri, 26 Jan 2024 04:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yTAm4tuC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259D511185;
	Fri, 26 Jan 2024 04:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706242425; cv=fail; b=N+5MrJLnDBie5Iuv2RfmM9yS4yIZesUIYBtAlw0lx82TTOq+zwebcuAjMjd+uVK8SD5gUD1BSNcdpEMximEtr+5dyVEy6VUYsidltMl1u7jsys9dD99Ft+aJxS53YMGipNUDR0NU3VIiw2iQFhvTKb3NunDW/jUG5vqF10CyB6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706242425; c=relaxed/simple;
	bh=DpbPCd/hTHvzSwUiNLD8cMSENhl1wKS1euFuHWOMcIU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktE/hrX5EPXmUMzGvEdSf1+Ea8WdT0zy9oZFme6izCMOr3UfRZ2XzBkukW3P66ufukWfwxGq13XWawx0DFSNVfS0JTMmsJqpH1s3LZbKOypzzsVmQrgarC+joBesPMWNMOqeaROimwmy3GMBjAaeFYyxI4mQOqZhAeOXEPZU70k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yTAm4tuC; arc=fail smtp.client-ip=40.107.220.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwdWdEizj3ouZSuWmVBoHWCq3MueDhXkRD0JDPHJU6sF/NAOt59mo4jryScfvNhGuIBhsq17dEaKrQEtZCOHREdVGhRvbiqzDIGY1AsvjvoWUX9/2kB0/ALbrZ3GXoKxF0NviL2wVB/KarvNXCz/8L7zFGYfBLPsaxuAzKbr1dldVBWmBjuyxPDN4RZ6iQXVhHOVOFecRCRgFil/apiAY/GEGLQ5gFf5wdcXmPAznL3+QbiG1JGGacuJYjcM4lDQa0jZLUWXCcdYY8FzjazM4ovRYPnFsD75ic20ZFsDhlryrlSTj1wzl2elwVopa/YPgIFZde3gcNeMGnRtpP5JMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FfHEA9E7gZpwVx73Oys9TdNFY4xCLGTn8/pb7CJVLzk=;
 b=BjaVwfoeWc5NC2qWPsKQeYor1EpULdV4qRJ9WaW7FPwXgIjZbw6JcYGatDxwAeNZlql9dbItVc+GR8y2UwAzVGFPzc04YLaypU5SBOiJfmrwciO6DvAjRunZZN65ZPdls8XD7/sKv4Y2HBSARDawa7FN+6Duv3ofJzOimFsk3gFCnk6iT1AIb2IJDu3DUjGt/qnuRMABjPRdOhn1J8YrCdIO8G+hyKyyRDE4Y/5EwbB4ueuweaFO2EKd0vdcLxlo3Q++Vq8NP4cKNzhG9qtTR1n0nTGTNg5NC5Vddd16ZfyAOAtOT0HV3DtN1Rzu7xEIpGbWuCJiBV69fOmHM2kUHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfHEA9E7gZpwVx73Oys9TdNFY4xCLGTn8/pb7CJVLzk=;
 b=yTAm4tuCldxyvBViKdL12JuxFu3coQVa7KYiWG51w9Exnz0zWSyMYYMVeyp67P3z1isO0UBk8U2Yd+QeUZatut6UOKjfF7anWytogprMsdNrwrExK9c7zvbDP83L4QSVCwRFF/aqXX0KramAmXXHPt6LjUz1YAl2n6htLnzDZQM=
Received: from BY3PR10CA0021.namprd10.prod.outlook.com (2603:10b6:a03:255::26)
 by IA0PR12MB8205.namprd12.prod.outlook.com (2603:10b6:208:400::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.36; Fri, 26 Jan
 2024 04:13:41 +0000
Received: from SJ1PEPF00001CE3.namprd05.prod.outlook.com
 (2603:10b6:a03:255:cafe::1e) by BY3PR10CA0021.outlook.office365.com
 (2603:10b6:a03:255::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22 via Frontend
 Transport; Fri, 26 Jan 2024 04:13:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE3.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7202.16 via Frontend Transport; Fri, 26 Jan 2024 04:13:39 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:13:38 -0600
Date: Thu, 25 Jan 2024 21:32:22 -0600
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
Subject: Re: [PATCH v1 24/26] crypto: ccp: Add the SNP_PLATFORM_STATUS command
Message-ID: <20240126033222.roi6j6pqv7s6mk2c@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-25-michael.roth@amd.com>
 <20240121122903.GNZa0OD21W0UxLmOAm@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240121122903.GNZa0OD21W0UxLmOAm@fat_crate.local>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE3:EE_|IA0PR12MB8205:EE_
X-MS-Office365-Filtering-Correlation-Id: 231d92b8-9de6-4aa3-0c67-08dc1e252cff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	C3COM20xgensVgZQ2nXnJ1SXdG2ejSnXbJ7FGRZ/Y1GPUGxtoSE64XJYr52ZVErYzBExnDtK89XqRcPPHtlJ+RyQ+1W9cs29OAruY4bNDjX5j8iHCWQMICyD+oM85K3fyCTuQF0uWFs5+LxAAkufHLgbLd4hU9UF7nkzOF7OsVPH2p7W1CIk+s7ZDQx2xvq7MDIAEXs5qlAeIVzgN4RRlptybVaxiyjXQKJ9X8yci9e9vdyyFmvlRvY7tZO1t86gb6/11pV6QA3Y1CAy7iprxufIEOVXzNxaTdUvws9/9Y2c/tAQiMPiwuTz0ytZ/SAm5o/9zX8LpiElAzUC5hNTXE9t+eIoDu4SVdTedEvG0KqmPmD/+xWoRnT2SZnwL01PshOyaYvqzkHqMPKm407j+KgrguA51laXz9wT64euJM5oZ44FWQnVSyO8pA1AOh1sIEgf0sViMLcgDU4Tn9KNW85F5rHs52+UsMsh9GZ2qQCI11rFy4z4p6dEtzfK1n/jcgbc4tKkJtMa7a3IfCJ9y69XVBBj7nrO1F+9qcdokg1kX0jRb3EukFRTrip8v4MmntmisGL9YXPo1dhQLnMbdigj7AEx9KT9C6wvwspSwtyeoUxogsGZCcJsV2SFZeiBHSmiT1SHkKqBxZBcYplAI5hLm0WjTMaSLYnz5OSqnOC1kVpIdfLwARyMAQHjhEEnbxHidNfNAWHkLqbUgxq7PDofXkK6ZUNzKZ7LI7+fRxq51YlDUpB+eiEAmmMWAbpC
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(136003)(39860400002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(82310400011)(46966006)(40470700004)(36840700001)(47076005)(40480700001)(40460700003)(36860700001)(6666004)(966005)(478600001)(356005)(81166007)(82740400003)(336012)(16526019)(2616005)(83380400001)(5660300002)(44832011)(54906003)(7406005)(86362001)(2906002)(70206006)(8936002)(4326008)(8676002)(7416002)(36756003)(26005)(70586007)(316002)(426003)(6916009)(1076003)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:13:39.5897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 231d92b8-9de6-4aa3-0c67-08dc1e252cff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8205

On Sun, Jan 21, 2024 at 01:29:20PM +0100, Borislav Petkov wrote:
> On Sat, Dec 30, 2023 at 10:19:52AM -0600, Michael Roth wrote:
> > +	/* Change the page state before accessing it */
> > +	if (snp_reclaim_pages(__pa(data), 1, true)) {
> > +		snp_leak_pages(__pa(data) >> PAGE_SHIFT, 1);
> > +		return -EFAULT;
> > +	}
> 
> This looks weird and it doesn't explain why this needs to happen.
> SNP_PLATFORM_STATUS text doesn't explain either.
> 
> So, what's up?

I've adding some clarifying comment in v2, but the page that firmware
writes needs to first be switched to the Firmware-owned state, and
after successful completion it will be put in Reclaim state. But it's
possible a failure might occur before that transition is made by
firmware, maybe the command fails somewhere in the callstack before it
even reaches firmware.

If that happens the page might still be in firmware-owned state, and
need to go through snp_reclaim_pages()/SNP_PAGE_RECLAIM before it can
be switched back to Default state.

Rather than trying to special-case all these possibilities, it's simpler
to just always use snp_reclaim_pages(), which will handle both Reclaim
and Firmware-owned pages.

However, snp_reclaim_pages() will already leak the page when necessary,
so I've dropped that bit.

-Mike

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

