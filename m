Return-Path: <kvm+bounces-6030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1364D82A56C
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 01:53:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C66E1C22FD6
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 00:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CAE2A3C;
	Thu, 11 Jan 2024 00:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kzsProZ9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CCC38F;
	Thu, 11 Jan 2024 00:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjmRCLUHVNu7RwBzqJwsTU4e09FmZPjX6kbyIDEoq5fNc6aZRgo2p6skr8/lIDSOlekJwb5S5zbEHwjl6mXOYOILILd/rzftM0NUlIn5X18mxUfiMfUP0T0pM46xDajIQ56MFlvJ83pLJZPBpavfy8rnM9PPtuI0tVxPwr6MCiCaWmmpv9dvYUpf4gXgWKy/+JaMKxYhblR5cNIxQkwkfBpYM3ymF04vWx2lmQao1WZALE+mKxfKOazkPbuiwBSfBekJ4+zfQpdBnM3Z79brNHSrwYeJ4wMmuLT3znwFvS1GErwmPrBeu1n1RtL3gYVdfNGzeCc0NgCRtjyECnQ1SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LiNlmQy+50+ICzRXNELbWcAURNWZ1VKkvoXSysP8eOU=;
 b=PM2bJY9U6Slth2rEhy4MmAQWchqysF7cywXHt5U0qpF+LukADVzo5fTqWzNm9y0u4fZ7cE3GsMz7EGn6GMjt1ElPFPr99i668QdBmfbvY707aiphD42GBnFEALdj5sIbr1cfunorS4nQJcg1Oyeaes3FERpRXVLdHWPN9+987dqa8+lT4AoiJWzXc0wb3y/uCxYkdlGac+dSnCAQy2yva8iJETCb3beG94lH0JTXToECYqhZ/OBZU828Il/bdSz/8Q6VkXXh1JJ9YeGQjKhUx64/9nRbPvLnXvS7T4zIaq4NhO85W+Mivuj+uDaTDLwf7SMIeOsnCcTnDfMbSNZa3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LiNlmQy+50+ICzRXNELbWcAURNWZ1VKkvoXSysP8eOU=;
 b=kzsProZ9u1w0PHXS19stiCKoOw2khbS/+EWZGnNJ74oMK6bfk0g4M2/vTbK3vopo72IIYxKj92SPvTkaYOY8Vs31+b+v7UaAVe8wd7QNdSHY0owbKVJknrWsLi8N/9jXiqNTYB2lpomSFCbgjOoBfwbTe1Py1CCDigUYKz94VHo=
Received: from CY8PR11CA0008.namprd11.prod.outlook.com (2603:10b6:930:48::20)
 by SA3PR12MB7878.namprd12.prod.outlook.com (2603:10b6:806:31e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Thu, 11 Jan
 2024 00:53:31 +0000
Received: from CY4PEPF0000E9D9.namprd05.prod.outlook.com
 (2603:10b6:930:48:cafe::5c) by CY8PR11CA0008.outlook.office365.com
 (2603:10b6:930:48::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.18 via Frontend
 Transport; Thu, 11 Jan 2024 00:53:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D9.mail.protection.outlook.com (10.167.241.77) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7181.14 via Frontend Transport; Thu, 11 Jan 2024 00:53:31 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 10 Jan
 2024 18:53:30 -0600
Date: Wed, 10 Jan 2024 18:50:03 -0600
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 20/26] crypto: ccp: Add debug support for decrypting
 pages
Message-ID: <20240111005003.7mq74gfabis2ssjq@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-21-michael.roth@amd.com>
 <ZZ6w7A8SYz3_VT3u@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZZ6w7A8SYz3_VT3u@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D9:EE_|SA3PR12MB7878:EE_
X-MS-Office365-Filtering-Correlation-Id: 2111ca72-f091-44f4-9343-08dc123fbb45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1XNNrkgYVTMoEIHMCx8fw+j4I3jAL6KZMddHOjN6DjweQFTIM3XuMC+0+eV3xQRuSUlT+XTznzdnwsklk2a26bAm55eYs56L8ScXB+VOAtdUEJ6L/ALAKwREURRcTJiSmE4RBdOT489zHub5T8R85DuPokoJtb4hL/fuiq/8cmRc07skmDKm/tPcEGPLGHwFE2wo5k8kXTKoz65YDF3Iw/oQ2Gc24e4k0K4htP975CzowYyDqvfmBmYD/K2iqEMebJ2Viq6IYUmJj+Jnew/NHiVBGmI8zBiy1AOCz4ihvZ0Yfx6EI6uYp+dNa5keAC/KC2D5a7l23pSvP7XopVaLsfsQ9e1JGv4QC0YIqfS38RL+2agLP32w2uFiwtkg+VhzcJ+fzmSdUK+CoJpyeRWS6QI7ITrnEkk0A4FU+RAoMUyGjWvpU33s5OQN0MdF6uf0aC90AzfzRf3xU1Cpb8tA8n7VjDLBc7z7tz3un+i5zDB2YI2EnWP1gEVD3UgnNCLqlgbaZCvn5N+AUu6kUr6FWClXd/ikyqzL1e+nXVBJyz1Q+BRasEwC/Ls2jk7IjOoXmAU/Re6TrZqhUsK1tQ1+meEzdhD/Jo8rwUCXGRH+wjWgWxolTzDjhmCIAq9D4peOoXNQKDfTeyIBdJQ91TQ7A/zdVEqkLb+UUKD70O+ySClfBTr7a0PAHNIEx0s5JqzqzZn9fosVxprkjyjXgvDO8cHqGpGrFxovjrkpYBzUYXtAuXVHLYwvUdQeMrafQvE28LY5Gq4Ejx5COYuueCtvrQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(39860400002)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(82310400011)(46966006)(36840700001)(40470700004)(40480700001)(40460700003)(41300700001)(82740400003)(70206006)(70586007)(356005)(81166007)(86362001)(316002)(36756003)(36860700001)(16526019)(47076005)(426003)(1076003)(336012)(26005)(2616005)(6916009)(6666004)(478600001)(2906002)(8676002)(5660300002)(54906003)(4326008)(8936002)(4744005)(7416002)(44832011)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2024 00:53:31.2969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2111ca72-f091-44f4-9343-08dc123fbb45
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7878

On Wed, Jan 10, 2024 at 06:59:56AM -0800, Sean Christopherson wrote:
> On Sat, Dec 30, 2023, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > Add support to decrypt guest encrypted memory. These API interfaces can
> > be used for example to dump VMCBs on SNP guest exit.
> 
> By who?  Nothing in this series, or the KVM series, ever invokes
> snp_guest_dbg_decrypt_page().

There's a VMSA dump patch we've been using internally, but yah, this should
be dropped from the series until that patch is actually submitted upstream.

-Mike

