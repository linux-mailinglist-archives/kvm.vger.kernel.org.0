Return-Path: <kvm+bounces-16072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E1248B3E55
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 19:35:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F79EB25524
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 17:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06CA615FA7C;
	Fri, 26 Apr 2024 17:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="x1T1Q2+q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D1D14AD38;
	Fri, 26 Apr 2024 17:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714152942; cv=fail; b=pn7IdDfT1qF+61tFyyBpIwK39vOWVobIJnb8rYsUlurkGFw0yXJWL7f6Z23OvuTIW5YD7D5TxuQtMhdMap5H+7fEMp9HxdFHRouvEbHXkxuLHuigQ9DNRvoq+fZpakXfwuf/TOFhVc4/WJgyre5wYK7MhscYlIDyLmwFE8w0vgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714152942; c=relaxed/simple;
	bh=WvuzVQ7vyAEGS94a5+Ael6YtTl7X9WQbKHyM377n2Mk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EIsbsIMcxt1j4glSXq2wC8D97SPgKzjZQh3yS9y1jAX80bvil8Dkzb9gVukpSkS/7ieP6J7eAVNocAc76JHWQ4GG/ZexRNIuLmRivApGTTvhIHSd+PN8oK7/h+Eck0IRiKz9RT6GAuGl1K8n5iffG8Kqa1wJo8aZo1EPIwSS1MA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=x1T1Q2+q; arc=fail smtp.client-ip=40.107.223.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HX7ANoK86EgkHUCeEG5y+zPhm6ubWYGHt4B3Pou731BAelgPcIuAQ7Qt9YWg5D8Z2jr4BKK/Gy7aFJZ8NJFJEVrzknKge4AOc5sJxeA2JEoY5eKw7XK1KKJ+uUL3XpaGGgHnL851NqmhKOE/snDAEuW5I6UKBmPGWKkmTiJXGpS2gQggOfAtJOc57gF+6zaGQCOs+bjd8WZnk+rWlwMVctPFROAiWVo2r13rkgnSbhQjYOMcgtMWaUAzOnTzImO/QsrXCO3haojDU2mB3NQAaczTQeJ/bt59tNLIPh6fqZnFwQgmRkDRX1pPqptnsAKn7+J2bbVCUGR7mbpsF6dRFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQ6aB01tREZRK2BxCUo7YikW7fNwqNQx4adthGUH25A=;
 b=V1La7kZ2AIDTsgJLWCmTOjoX7LSquUeSBgExRchLx4oMJQ1WL2Xo94GHtmUi5viY/j7ilb6+DYZWfP29xE2OIONHV/ojxmMIBIDGUubRy3LiMNQbtASKmFzu6LJUL6UWphu2nNiw4S/1eG5z/OR0sE9/OdO3NG56Ia9NoiM5LYNwvIfyTJO7+IaRfF+vfWjBfaxOGBcyLsBh2uLOJZytoVvxptu2N/Z9NkmFde5V4Zz5RGybCnn8TGkq+cUNYsMZ+vHxedVI5GeAfLTxOa2LtujJnE3fBKakTBsFsrOPhj3Pjl2ID6DqqtwQ62nQCeDCfUPke9mGW+MOgwBhObh+Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQ6aB01tREZRK2BxCUo7YikW7fNwqNQx4adthGUH25A=;
 b=x1T1Q2+q5LhQ6PvDWpMZkUFOUXJz9FkHwc11tyMj8wLmQKPeDxGlR+43s2xqThh/do/D7wRot3LLKGwgFDTwdqMYq0Agwjvyg9H7ILcmVd4pfPZ//5A416nqtiL3aqtDDPCDmgix6bUcldMK5COZxQi7ZGEtgW1Qc2YLHK74Bg0=
Received: from BYAPR11CA0066.namprd11.prod.outlook.com (2603:10b6:a03:80::43)
 by CY5PR12MB6178.namprd12.prod.outlook.com (2603:10b6:930:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Fri, 26 Apr
 2024 17:35:35 +0000
Received: from CO1PEPF000044F4.namprd05.prod.outlook.com
 (2603:10b6:a03:80:cafe::2) by BYAPR11CA0066.outlook.office365.com
 (2603:10b6:a03:80::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22 via Frontend
 Transport; Fri, 26 Apr 2024 17:35:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F4.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Fri, 26 Apr 2024 17:35:34 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 26 Apr
 2024 12:35:33 -0500
Date: Fri, 26 Apr 2024 12:35:15 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: Re: [PATCH v14 21/22] crypto: ccp: Add the
 SNP_{PAUSE,RESUME}_ATTESTATION commands
Message-ID: <20240426173515.6pio42iqvjj2aeac@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-22-michael.roth@amd.com>
 <ZimgrDQ_j2QTM6s5@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZimgrDQ_j2QTM6s5@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F4:EE_|CY5PR12MB6178:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b72732d-421d-40e6-c104-08dc66174778
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ohc/yF+0HU04Q5mCL3Uz0J/wvHzGHj6nfmG+TYngFEAOR/M3tHeIMOrzr1/a?=
 =?us-ascii?Q?R+UFGXRdUMkSHT3nffwjqtCePDTNvZW352S68Vx8HgEyOFiikoGrgozlhfFJ?=
 =?us-ascii?Q?H29S7Dh3P8Z3bwy2N7boWxQk9yauoNFFQDj758ux3jAml8ftYfWdB4SENJaw?=
 =?us-ascii?Q?PqYKAiIMybIw3MyIwugmi/VTA0TvnwcfXNHty1xAoitWJm3KjaVG7gLIUdCA?=
 =?us-ascii?Q?PhsUN+Ka48u0KUEjo/09WjKrzsvwOh/maQ9FScxaQ6T/nwgnecOSqa8r8ww6?=
 =?us-ascii?Q?UXv+wPl/0529CYYM1xNuXb5/oMwPa59r/fMTULvOV6cBzqpKst0T0NZdlrcC?=
 =?us-ascii?Q?iP9xgVLCv5g8VCZlvILZBvGXHxxikNDvvHx7qZXM/6GP2bdEM/y7M1A59xit?=
 =?us-ascii?Q?Skg0+LqpwlwL41wp/A1ON50N51U2BFLKuD3V9pdU/bwMfnutrbYNDMD2FM8C?=
 =?us-ascii?Q?ntpgQxzmaKXaFxgQec6erdNbWVEHZhh6Xp3YmBUJefhpL1a67cD7OdSjqx00?=
 =?us-ascii?Q?Zy74+qNI3RwOtgFLHX5Hd+/o7FRbjL56EAXx9WaXSpRsuLpzkoTrH0naDCne?=
 =?us-ascii?Q?aW8O4BBIxA/vIHewVYfQv8yAzTxmbWtJcnCjbAuHDjs0xPrKJCBQVh2P42ql?=
 =?us-ascii?Q?s2/IjgaExe2v5wSfYqB6RZH5cGnSzyWASQqnNGmGZiA/529XhI/xLPq/p728?=
 =?us-ascii?Q?BFY6O2lcxLi50h/UwCCD9V08RdpUrG23PsvRUizrRr777Z5Lz5xOKpIc0p3B?=
 =?us-ascii?Q?KynR7Kk2c4o95+7Ed6+VQp1anDVBKLpNPO4hOAxqSwHEWmwxhRIEYDjc4Nbf?=
 =?us-ascii?Q?gN6/UKlr7jRx9gKhjY8d1fgz+qUeMngATFKcoaxujVrNYSvhp7FgTNxup3wq?=
 =?us-ascii?Q?3KV9BXADTYaZCjHubzB9Wh4QoCtsVl81H6ot7rIcR4QQa6I40KZS+B00iXr1?=
 =?us-ascii?Q?ca+5+2CkCoOUmp3VfCP0SxNaoPf0j02ImylJHTsl//OW5XFmnr/DKMYABCim?=
 =?us-ascii?Q?5lboHhuJTcv8/0tk5hJQ1kcEpU8kT7TiAzsg9RhJjNx1ZMiAXGj8CPZPrhul?=
 =?us-ascii?Q?hAISBps0w6RWdFG/GhROSTr/mUEEkRPt/ggWcUQGCFEV9QWOtAo1lohVAp8I?=
 =?us-ascii?Q?6moJI9RYj1pz2cQERPPV9Kh2AG5J9qZUxIe6mF46lFPKvtUMVmd7ng+G2UYm?=
 =?us-ascii?Q?jOdI0rUrbFhouKWTSPgY6tlAjXTzwGTO1AnOpxp4Rc8XL51LlVAU5LcAuu0R?=
 =?us-ascii?Q?Gp58OdahsePIiHCLLTv5o+6EcNNvhh1aGR73am/jSr4LeiSK2rcbxGlFF3of?=
 =?us-ascii?Q?EsWRSiU4fzkE0PjVmGnFERDAgTEnUFJOga+FBl7Kqr+fPpJ1jTO8I8+qxW+U?=
 =?us-ascii?Q?/55FKWOGMtUUijKZySZVM9XjEAiz?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(36860700004)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 17:35:34.6957
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b72732d-421d-40e6-c104-08dc66174778
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6178

On Wed, Apr 24, 2024 at 05:15:40PM -0700, Sean Christopherson wrote:
> On Sun, Apr 21, 2024, Michael Roth wrote:
> > These commands can be used to pause servicing of guest attestation
> > requests. This useful when updating the reported TCB or signing key with
> > commands such as SNP_SET_CONFIG/SNP_COMMIT/SNP_VLEK_LOAD, since they may
> > in turn require updates to userspace-supplied certificates, and if an
> > attestation request happens to be in-flight at the time those updates
> > are occurring there is potential for a guest to receive a certificate
> > blob that is out of sync with the effective signing key for the
> > attestation report.
> > 
> > These interfaces also provide some versatility with how similar
> > firmware/certificate update activities can be handled in the future.
> 
> Wait, IIUC, this is using the kernel to get two userspace components to not
> stomp over each other.   Why is this the kernel's problem to solve?

It's not that they are stepping on each other, but that kernel and
userspace need to coordinate on updating 2 components whose updates need
to be atomic from a guest perspective. Take an update to VLEK key for
instance:

 1) management gets a new VLEK endorsement key from KDS along with
    associated certificate chain
 2) management uses SNP_VLEK_LOAD to update key
 3) management updates the certs at the path VMM will grab them
    from when the EXT_GUEST_REQUEST userspace exit is issued

If an attestation request comes in after 2), but before 3), then the
guest sees an attestation report signed with the new key, but still
gets the old certificate.

If you reverse the ordering:

 1) management gets a new VLEK endorsement key from KDS along with
    associated certificate chain
 2) management updates the certs at the path VMM will grab them
    from when the EXT_GUEST_REQUEST userspace exit is issued
 3) management uses SNP_VLEK_LOAD to update key

then an attestation request between 2) and 3) will result in the guest
getting the new cert, but getting an attestation report signed with an old
endorsement key.

Providing a way to pause guest attestation requests prior to 2), and
resume after 3), provides a straightforward way to make those updates
atomic to the guest.

-Mike

