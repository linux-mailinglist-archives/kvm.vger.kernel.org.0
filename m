Return-Path: <kvm+bounces-4957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D5781A43C
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 17:17:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4DFB1C234BE
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31C33482F5;
	Wed, 20 Dec 2023 16:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xogbklVY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D33482F3;
	Wed, 20 Dec 2023 16:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vv6gQRQdpDbu4DPyzLPtUBAtVQTr2h/ORVga5MlzY9l3WVFkXjP9qQ1T1/bUj/O1aopXj+jQEviYr20ULI0+yU444mamH56oSi6K0FljrHd6rL+6cuBboK+F75oPDgkslDIHsDqifBBB5LdH1lz7UdtfgT2a7uUWDuB7Evh4EVBIOZfedurdeCFfECzojDNY+PWMnVRP+3gd7g1sCgoBAt9VkmRmB4TwuDltMHFR1/wX38WgUNzMZlwjxB6A81agtLCIL62p+bSvKbqG5zYE+p7FmMH3bkkVt+dxsApQi6Kx+eXLU6HRM1zel5g8joSXogWH24go4NvsA4iznA7ATw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LMjJTc+GpWuNtXghuhJzFXtI91YHxY729XnHr+vspBs=;
 b=e5mOgmRi5A9nIahjSfsjvKkvH87fw2k6uJ5F3VPejaqC4Njph70b4ts/aA13NafltPdcR4F0v8oZNNrgdREa8A5WoaHrXrA+GfMAyblrP96AZfpcMmMyGau/VIefEpWdkGgnyB+y0BxE/FN8Kh2NPJ/b6EYE0GpHpZUj9SWNDr9mdGcPzidxLuKEL5wS1iZFVisPK3MabcNQeCjpCwYY/zCYpFAgFhcQbQ1CzBDU+gM8harZMJ/znhxge5EblRkkkFUQBkxBINpZkPDoU0NQULt3f0+BG24gjtr6VLZy0dg5tbhZ9MT62eBH1QcyMoms4a2jbTlDTNgectT4x5UnKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMjJTc+GpWuNtXghuhJzFXtI91YHxY729XnHr+vspBs=;
 b=xogbklVYVegafxKcUJsywltHjlToNBsWasKdEmuezh7qIEdYy1vNz4GpUaBhTE9gYDYlLI+yzg+gIo3NQxPdsA7Sy83PvCoVud4OhXss1/6/dmFia/RwTc1JsawMR39a2XKP9QAeicgNOw877SzGkU7zc6swc0Gur8Uo92zeY2M=
Received: from SN7PR18CA0030.namprd18.prod.outlook.com (2603:10b6:806:f3::7)
 by MN2PR12MB4127.namprd12.prod.outlook.com (2603:10b6:208:1d1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 16:12:26 +0000
Received: from SA2PEPF00001504.namprd04.prod.outlook.com
 (2603:10b6:806:f3:cafe::fa) by SN7PR18CA0030.outlook.office365.com
 (2603:10b6:806:f3::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Wed, 20 Dec 2023 16:12:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001504.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 16:12:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 10:12:21 -0600
Date: Wed, 20 Dec 2023 01:07:03 -0600
From: Michael Roth <michael.roth@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
	<tony.luck@intel.com>, <marcorr@google.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 06/50] x86/sev: Add the host SEV-SNP initialization
 support
Message-ID: <20231220070703.24rfvmjegrvozkfr@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
 <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001504:EE_|MN2PR12MB4127:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cd86037-9562-42fa-b8ba-08dc017674e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UT61sSIdBxumW9GK6D154EmEAAaLb0r6XAWOQ0DmzQq5wvjM44CSxVk43UXCzwqBoDg0FM7ABvMvmoMvSvCGsVUO5MDag+FhkZsY+m0nlLlH5amSaGYMUDhrL1l+BPwY/f0Gyu8hNe/r8Q6BHCRLl+O+B4iJCwhwdXFW1CQUYE7i0CKxdMPek4VSyMhLZftBNHCZQgAW8rIDbPlIzhAUQWsR9iJnObv5PzZQmZxY8pbbN4X9Z99OQcBd5J9HNd+9soPEIS7fYm/WDE76zM5caDKfgqICUVGOIRU+qfD63FW8YSm41D3vh72bbpuz2oORCWOOYEqfO0WQugrWho2MQZzHkyyfXquHdV1cT2sMIC0LJIRUdpGdFp02x/UxDwE1YoMEb+CG6Ra9K/suzr0ZF2gP4LIZnP6SZssev+GtRYdbrQ0E1qPjtkSiVHVC04gJ43suhwQeG4i38oGp3/+x2L4ivYcT/688MlRXV4cEWhB/hEKDY5rZ0zF2bUCoLXVpoEvaYO2oQ8UJoxjrLW0Ms35jOkl9cXcHgkqRGZUnGwCayrW55xCDekQ8+ByVxLpppoNgbW8BKmQZ5uiblHLFLJrjtR9LRWD+eXymM27wF5cJodwSda4G5oiadoiF8UX294S8EPhW1/0aZ97LNhGEoCoooOHedZavgNeUr2jzsT7WbBIjxuQ+YLu8dQFZ/j1Enp0k6Iomk4xk2nj+JJNwz/7iVVCEWL2X3hPBgwU2KRieJPk0aAXgAZ5+m5qtLoERqJ+8teCZCTActoH8AdgcHQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(346002)(376002)(396003)(230922051799003)(451199024)(82310400011)(186009)(64100799003)(1800799012)(40470700004)(36840700001)(46966006)(356005)(81166007)(82740400003)(26005)(41300700001)(86362001)(36860700001)(16526019)(36756003)(83380400001)(336012)(47076005)(426003)(2616005)(7406005)(7416002)(1076003)(5660300002)(2906002)(8936002)(8676002)(4326008)(6916009)(316002)(70586007)(70206006)(54906003)(40480700001)(478600001)(40460700003)(6666004)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 16:12:25.7927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd86037-9562-42fa-b8ba-08dc017674e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001504.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4127

On Tue, Nov 07, 2023 at 05:31:42PM +0100, Borislav Petkov wrote:
> On Mon, Oct 16, 2023 at 08:27:35AM -0500, Michael Roth wrote:
> > +static bool early_rmptable_check(void)
> > +{
> > +	u64 rmp_base, rmp_size;
> > +
> > +	/*
> > +	 * For early BSP initialization, max_pfn won't be set up yet, wait until
> > +	 * it is set before performing the RMP table calculations.
> > +	 */
> > +	if (!max_pfn)
> > +		return true;
> 
> This already says that this is called at the wrong point during init.
> 
> Right now we have
> 
> early_identify_cpu -> early_init_amd -> early_detect_mem_encrypt
> 
> which runs only on the BSP but then early_init_amd() is called in
> init_amd() too so that it takes care of the APs too.
> 
> Which ends up doing a lot of unnecessary work on each AP in
> early_detect_mem_encrypt() like calculating the RMP size on each AP
> unnecessarily where this needs to happen exactly once.
> 
> Is there any reason why this function cannot be moved to init_amd()
> where it'll do the normal, per-AP init?
> 
> And the stuff that needs to happen once, needs to be called once too.

I've renamed/repurposed snp_get_rmptable_info() to
snp_probe_rmptable_info(). It now reads the MSRs, sanity-checks them,
and stores the values into ro_after_init variables on success.

Subsequent code uses those values to initialize the RMP table mapping
instead of re-reading the MSRs.

I've moved the call-site for snp_probe_rmptable_info() to
bsp_init_amd(), which gets called right after early_init_amd(), so
should still be early enough to clear X86_FEATURE_SEV_SNP such that
AutoIBRS doesn't get disabled if SNP isn't available on the system. APs
don't call bsp_init_amd(), so that should avoid doing multiple MSR reads.

And I think Ashish has all the other review comments addressed now.

Thanks,

Mike

