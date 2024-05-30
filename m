Return-Path: <kvm+bounces-18430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 709D98D5018
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 18:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC1D21F2486F
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 16:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F23C3B182;
	Thu, 30 May 2024 16:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Bdmuszkh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57233D579;
	Thu, 30 May 2024 16:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717087710; cv=fail; b=HKPj4UMiPjt1Vjkb8s2fAMuWEZB0MDPiZeolV3VbsQGwWPiPxowGfEHyf6A1mAK0CKQjRGyAXdr9NPnmUaivn8sbPbB+xHtrXn/KH3husryjhQAIZZj7pQhHwqQHisx8K7Gw8UeIMeHyDnj6LDWUUB/dN8mDCn4Qrp+q2wU1giU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717087710; c=relaxed/simple;
	bh=W/Q2vbro6sgx7jwWsUn6+RTfBo2Nbf7eM25AEXiF64E=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f0ncfQJuhx9CBaYslh8DDtONrvu4yS3X9rvr7EKKwL52Z1unzjMLzMhTr47xvL5NwFeJYjiTAyaLAtwiVBZwDZdVrt4zAEX+KxS7+jqTzj/fgagIoiIJZ8qyb5q8CuYOWKndJ32N386FMdfm+bh7UiubrfVNMTgwCz1wZ2eGyyA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Bdmuszkh; arc=fail smtp.client-ip=40.107.243.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9JS5o5JjwBw9Kx129/I/uKu9CxFecgE8RPHHwh9uqZbOGiGI0nUabbVtY62sqKWIEShM7Df6DESZ6ON5uaSEY/eNkS0t0lfcBYtULQApD11iN4XvUE/7wZ4oGcKiwOMLWhDOyl21ox6omwUK7/zmg/O1QDDxOkdSIj9D2HM2m33h/mQLgPQRRWWzwhw003O96gVjwmEjEX01U1t5Y41fsqetHXEeUCmcSXzqyDez7GK9vmk3XXKaD30iLNOVRm2w9b5++avYLkw4VLu0jDvh296AHo0gvmLf+judlys6IObNOo3LrIgo+WDpERNp6Nh87fChIacNx8KyfdbgUhj5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7+/lQipfX4pHlbkV2C/fDtvUeEUskzQiSHgI1DJVy9s=;
 b=G/eG+rbpxnLb2u+N0gVpNmsqREKyMLLXmulefZc4k9bwRPRcYgIoq+m4tJ1W4KtBKZ6UjgvG3uchbuHVv1XHTXZUu7oy7cTD3oslYyBBrlx9rs6Fc6VCsQXIjhRfcVKduGOuu9FFv0bZcGXPPIFRK7mF7IEx/uQfN92UwKbX2dlgh/hfTQrfoa0QsPMWMxk5OCaFHubofFgwiTPBR2tPNtKRHca/fzncPRc0S4L8LspnUNMlY1sJ9e3S+tNulCd7N0ORJ3WA8/k3pOo/s/o3V8T48ZUzLV23zbZGSIhR4oR7eH9MFvgCcsbUrkec5zDXYOw1H0cnK7OyH39hYhSQzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=amd.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+/lQipfX4pHlbkV2C/fDtvUeEUskzQiSHgI1DJVy9s=;
 b=Bdmuszkhy0s7WYKA60BjcrWQ/7H2f9aTkWB+X6a6V7VkGnBESOe4uMVS9ZnKQL0vsPqmOmE8+hzSQP6nLeTLO3OvwumNMvStLPWNt3GQnWyUcD4whNKCQMt8cniNvZBP6gkfZ8Dd2WcvdEeHnkTYRdVbCD8oyFBAqLB27dD9GKMSHISX5bBIRix0vFi8JuxczyQNEqVRRmiqDL10NhrNGpCwb5o8hK05EOviWawKeAxzBDcvuizvrDYINoC9MXuW0twN1Pm/oWqgsuDtYOdPIXW9/ODOsz+kJDp5H8P/mE+I9dC86BTASOhWSEodTyz3fx+M5cZmf2eZJHgCgwzjFg==
Received: from CH0PR04CA0040.namprd04.prod.outlook.com (2603:10b6:610:77::15)
 by IA1PR12MB8585.namprd12.prod.outlook.com (2603:10b6:208:451::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Thu, 30 May
 2024 16:48:24 +0000
Received: from CH3PEPF00000017.namprd21.prod.outlook.com
 (2603:10b6:610:77:cafe::e7) by CH0PR04CA0040.outlook.office365.com
 (2603:10b6:610:77::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21 via Frontend
 Transport; Thu, 30 May 2024 16:48:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH3PEPF00000017.mail.protection.outlook.com (10.167.244.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7656.0 via Frontend Transport; Thu, 30 May 2024 16:48:23 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 30 May
 2024 09:48:09 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 30 May
 2024 09:48:08 -0700
Received: from localhost (10.127.8.9) by mail.nvidia.com (10.129.68.10) with
 Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Thu, 30 May 2024
 09:48:00 -0700
Date: Thu, 30 May 2024 19:47:41 +0300
From: Zhi Wang <zhiw@nvidia.com>
To: Michael Roth <michael.roth@amd.com>
CC: Binbin Wu <binbin.wu@linux.intel.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v15 09/20] KVM: SEV: Add support to handle MSR based
 Page State Change VMGEXIT
Message-ID: <20240530194606.00003f3a.zhiw@nvidia.com>
In-Reply-To: <rczrxq3lhqguarwh4cwxwa35j5riiagbilcw32oaxd7aqpyaq7@6bqrqn6ontba>
References: <20240501085210.2213060-1-michael.roth@amd.com>
	<20240501085210.2213060-10-michael.roth@amd.com>
	<84e8460d-f8e7-46d7-a274-90ea7aec2203@linux.intel.com>
	<CABgObfaXmMUYHEuK+D+2E9pybKMJqGZsKB033X1aOSQHSEqqVA@mail.gmail.com>
	<7d6a4320-89f5-48ce-95ff-54b00e7e9597@linux.intel.com>
	<rczrxq3lhqguarwh4cwxwa35j5riiagbilcw32oaxd7aqpyaq7@6bqrqn6ontba>
Organization: NVIDIA
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000017:EE_|IA1PR12MB8585:EE_
X-MS-Office365-Filtering-Correlation-Id: c12050d6-8097-4c92-eb3d-08dc80c85228
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|7416005|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aG9SWGFRVDBTUnJJSStWQjlHSGlQRk5ISFdTS2J6TjNGbHcrY1lDRzkxcUEw?=
 =?utf-8?B?VFVFeVk0V3N0N04vRXZsdGdINDhyaVVnUis3eDZaUmc0SUVjMXBveFFkWnlF?=
 =?utf-8?B?dDllcGJZSEpXVkNEcGtrV2psSGVnc0xGcHBQQXE4ODZueTFwczlGaDh2Nlcz?=
 =?utf-8?B?aFBMQ0ZOK09sREY5M29ja3lmdk9WTmxLR0NpSTAxeWdtcWJnUUhURXkxZUh1?=
 =?utf-8?B?QkI1V2FBVzdQN2ZRbVVxSHE0ZjJvcnBGdnFmd0hoWVhTdG4zbmZ0NkVhL0tF?=
 =?utf-8?B?d3oxZlNQZDZoUE1rVWZwZVJKV2QzaEJZUkI3a3BneW5MWC9IZzhzcXlFUk41?=
 =?utf-8?B?N1JESnZMQjRxU3ZjQkliSFZ6b2dMOS9MUjNaeGxWcTZKZVpyZm9FYWRDY2hT?=
 =?utf-8?B?SS8zQk5sVGZ4N0x5Q1d3RVlGWXFSMHZDYWFGT2xCQ2xRRjFBNHJyMm53cXVK?=
 =?utf-8?B?YXJpcERIZExwVGNGVWtJbXljZllYdFd6TDV6QjY3UjJSY1FCUlY5YnlkOVN2?=
 =?utf-8?B?RzJXcjdETXcwcDh5UzRmczV3ejFqZ2FEcHFMd1VEa2ZmNkdNNm9ITkJYWm41?=
 =?utf-8?B?TXVtRDd3YUtnMTVPY1RCYmhha3ovUXdJSUNPUy9MNGlLdlRsY2R5T3FIbnNk?=
 =?utf-8?B?ZTJmR1FmZ2dGV2w5NEdJRGRJT1hrU2poWXdMeEhGWmlML0xIRG5xa0xCSjVk?=
 =?utf-8?B?NnpxV2l2V1AxWlE1K0JyaFU4VThHemNaUGxsL3F2OFppNmVpaWdodjdLN3RR?=
 =?utf-8?B?Y2d5dTR0ajFoOTUzV0tLNlFzRVVYdERVL0xHeFptOS85aUM5MnBmWkg1Mit5?=
 =?utf-8?B?VjlwYkl3bnVhbU1sdVhYdUtWZ01ZZk4vOUlrU3czL3JyUUhsY3NveFpRU1E0?=
 =?utf-8?B?RVkrU3o1R3pWZG1Tdm0wWXQ3RkZRUXI4SGNuUkg2a25UcVBYZmc1aFltTTg2?=
 =?utf-8?B?eUZYaURrZlo2bHNGSXdKaENNeWVEaGc2Uis2OGFCZ1JlNTVSbWpBM2RIU2hR?=
 =?utf-8?B?ZmRiVko2V0tLNUIrQkFQS3NjbzZxZlp5VTYzcTBkLzJJSGVHTlROS1d1eDA2?=
 =?utf-8?B?SnR4RUM1TndLdWg5Qyswa3JRdXlIaXRwbVRhTWFSZ0ZNTzVNMm9jbTBtS2tQ?=
 =?utf-8?B?b1FoYUtoSWpsbWQ1MGpvdGlQOWVwclVwL1lmUWdOV3VJMFF6aUpSVUJ4TDF1?=
 =?utf-8?B?VDlYVVFLajhtMktNYW9wcU0rVy9ydW13L1Y0eitrQjc4bW9Ja091dzFrdnQ3?=
 =?utf-8?B?YkZVZUpnN0p5OGsxSHhkaElsOWIxalFDZzZkT0FQa1I1SUZ5czV2Q0VJSFJn?=
 =?utf-8?B?U1BLcEdKdzlqUGw2OUh6WlFIUUgyZXhCSVozSkNsWU56TFk5NnJXd01JMkFL?=
 =?utf-8?B?R0hrOThtcWo0QkR0dUFGWURKb1NaSEVNaXVja0RscC9mNVFyRHlLOXdPZ2tV?=
 =?utf-8?B?R3p0aWMrbDhLWDQ5SDVCd0lNR3YvUzZPTEZMZm1pYjZtcm1IZTR1ZldUQ3Zx?=
 =?utf-8?B?bmR1dkV4UTFXeHNvZHhUejRZZE0yQ2puWnBYam45REZIU29PUzNoZGdRVUVx?=
 =?utf-8?B?eVFqZDIwcW9qZ3RpdkhTMmVieEJnQ0FNSlI4eFl1RVlWRTNwMERuMU1LZk1G?=
 =?utf-8?B?NG5WZE9ZQk9yYnUwcE50cWNQUWE5UHkxUXh6ZUx4SjRxYmVoYkRFc2cvZXlk?=
 =?utf-8?B?c2hxSHdUL0pVOWcvZitEOWwvMEROQi9DdGhnRUthdnBmWXVxVldrTmthRmI0?=
 =?utf-8?B?RjY5eW04alM1VGxHTlo3aG1MZ281UDUxQjFtSjJZSUJ5dEQrSVl2R1NIaWty?=
 =?utf-8?B?TS9TdDd0ZWQ1bjZoVVZFM2MrSXVtV3cvTjJZYnhYNlV4bzZCUTRNc3YzZE1o?=
 =?utf-8?Q?PPPor7U3Ksiv3?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(7416005)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 16:48:23.8589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c12050d6-8097-4c92-eb3d-08dc80c85228
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000017.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8585

On Tue, 21 May 2024 16:49:52 -0500
Michael Roth <michael.roth@amd.com> wrote:

> On Tue, May 21, 2024 at 08:49:59AM +0800, Binbin Wu wrote:
> >=20
> >=20
> > On 5/17/2024 1:23 AM, Paolo Bonzini wrote:
> > > On Thu, May 16, 2024 at 10:29=E2=80=AFAM Binbin Wu
> > > <binbin.wu@linux.intel.com> wrote:
> > > >=20
> > > >=20
> > > > On 5/1/2024 4:51 PM, Michael Roth wrote:
> > > > > SEV-SNP VMs can ask the hypervisor to change the page state
> > > > > in the RMP table to be private or shared using the Page State
> > > > > Change MSR protocol as defined in the GHCB specification.
> > > > >=20
> > > > > When using gmem, private/shared memory is allocated through
> > > > > separate pools, and KVM relies on userspace issuing a
> > > > > KVM_SET_MEMORY_ATTRIBUTES KVM ioctl to tell the KVM MMU
> > > > > whether or not a particular GFN should be backed by private
> > > > > memory or not.
> > > > >=20
> > > > > Forward these page state change requests to userspace so that
> > > > > it can issue the expected KVM ioctls. The KVM MMU will handle
> > > > > updating the RMP entries when it is ready to map a private
> > > > > page into a guest.
> > > > >=20
> > > > > Use the existing KVM_HC_MAP_GPA_RANGE hypercall format to
> > > > > deliver these requests to userspace via KVM_EXIT_HYPERCALL.
> > > > >=20
> > > > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > > > Co-developed-by: Brijesh Singh <brijesh.singh@amd.com>
> > > > > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > > > ---
> > > > >    arch/x86/include/asm/sev-common.h |  6 ++++
> > > > >    arch/x86/kvm/svm/sev.c            | 48
> > > > > +++++++++++++++++++++++++++++++ 2 files changed, 54
> > > > > insertions(+)
> > > > >=20
> > > > > diff --git a/arch/x86/include/asm/sev-common.h
> > > > > b/arch/x86/include/asm/sev-common.h index
> > > > > 1006bfffe07a..6d68db812de1 100644 ---
> > > > > a/arch/x86/include/asm/sev-common.h +++
> > > > > b/arch/x86/include/asm/sev-common.h @@ -101,11 +101,17 @@
> > > > > enum psc_op { /* GHCBData[11:0] */
> > > > > \ GHCB_MSR_PSC_REQ)
> > > > >=20
> > > > > +#define GHCB_MSR_PSC_REQ_TO_GFN(msr) (((msr) &
> > > > > GENMASK_ULL(51, 12)) >> 12) +#define
> > > > > GHCB_MSR_PSC_REQ_TO_OP(msr) (((msr) & GENMASK_ULL(55, 52)) >>
> > > > > 52) + #define GHCB_MSR_PSC_RESP           0x015
> > > > >    #define GHCB_MSR_PSC_RESP_VAL(val)                  \
> > > > >        /* GHCBData[63:32] */                           \
> > > > >        (((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
> > > > >=20
> > > > > +/* Set highest bit as a generic error response */
> > > > > +#define GHCB_MSR_PSC_RESP_ERROR (BIT_ULL(63) |
> > > > > GHCB_MSR_PSC_RESP) +
> > > > >    /* GHCB Hypervisor Feature Request/Response */
> > > > >    #define GHCB_MSR_HV_FT_REQ          0x080
> > > > >    #define GHCB_MSR_HV_FT_RESP         0x081
> > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > index e1ac5af4cb74..720775c9d0b8 100644
> > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > @@ -3461,6 +3461,48 @@ static void set_ghcb_msr(struct
> > > > > vcpu_svm *svm, u64 value) svm->vmcb->control.ghcb_gpa =3D value;
> > > > >    }
> > > > >=20
> > > > > +static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +     struct vcpu_svm *svm =3D to_svm(vcpu);
> > > > > +
> > > > > +     if (vcpu->run->hypercall.ret)
> > > > Do we have definition of ret? I didn't find clear documentation
> > > > about it. According to the code, 0 means succssful. Is there
> > > > any other error codes need to or can be interpreted?
> > > They are defined in include/uapi/linux/kvm_para.h
> > >=20
> > > #define KVM_ENOSYS        1000
> > > #define KVM_EFAULT        EFAULT /* 14 */
> > > #define KVM_EINVAL        EINVAL /* 22 */
> > > #define KVM_E2BIG        E2BIG /* 7 */
> > > #define KVM_EPERM        EPERM /* 1*/
> > > #define KVM_EOPNOTSUPP        95
> > >=20
> > > Linux however does not expect the hypercall to fail for
> > > SEV/SEV-ES; and it will terminate the guest if the PSC operation
> > > fails for SEV-SNP.  So it's best for userspace if the hypercall
> > > always succeeds. :)
> > Thanks for the info.
> >=20
> > For TDX, it wants to restrict the size of memory range for
> > conversion in one hypercall to avoid a too long latency.
> > Previously, in TDX QEMU patchset v5, the limitation is in userspace
> > and=C2=A0 if the size is too big, the status_code will set to
> > TDG_VP_VMCALL_RETRY and the failed GPA for guest to retry is
> > updated.
> > https://lore.kernel.org/all/20240229063726.610065-51-xiaoyao.li@intel.c=
om/
> >=20
> > When TDX converts TDVMCALL_MAP_GPA to KVM_HC_MAP_GPA_RANGE, do you
> > think which is more reasonable to set the restriction? In KVM (TDX
> > specific code) or userspace?
> > If userspace is preferred, then the interface needs to=C2=A0 be extended
> > to support it.
>=20
> With SNP we might get a batch of requests in a single GHCB request,
> and potentially each of those requests need to get set out to
> userspace as a single KVM_HC_MAP_GPA_RANGE. The subsequent patch here
> handles that in a loop by issuing a new KVM_HC_MAP_GPA_RANGE via the
> completion handler. So we also sort of need to split large requests
> into multiple userspace requests in some cases.
>=20
> It seems like TDX should be able to do something similar by limiting
> the size of each KVM_HC_MAP_GPA_RANGE to TDX_MAP_GPA_MAX_LEN, and then
> returning TDG_VP_VMCALL_RETRY to guest if the original size was
> greater than TDX_MAP_GPA_MAX_LEN. But at that point you're
> effectively done with the entire request and can return to guest, so
> it actually seems a little more straightforward than the SNP case
> above. E.g. TDX has a 1:1 mapping between TDG_VP_VMCALL_MAP_GPA and
> KVM_HC_MAP_GPA_RANGE events. (And even similar names :))
>=20
> So doesn't seem like there's a good reason to expose any of these
> throttling details to userspace, in which case existing
> KVM_HC_MAP_GPA_RANGE interface seems like it should be sufficient.
>=20

Is there any rough data about the latency of private-shared and
shared-private page conversion?

Thanks,
Zhi.=20
> -Mike
>=20
> >=20
> >=20
> > >=20
> > > > For TDX, it may also want to use KVM_HC_MAP_GPA_RANGE hypercall
> > > >  to userspace via KVM_EXIT_HYPERCALL.
> > > Yes, definitely.
> > >=20
> > > Paolo
> > >=20
> >=20
>=20


