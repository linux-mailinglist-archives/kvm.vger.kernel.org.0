Return-Path: <kvm+bounces-7050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2296083D364
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A29641F225CE
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A394BE4C;
	Fri, 26 Jan 2024 04:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sWifEGm6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336B5C2FD;
	Fri, 26 Jan 2024 04:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706242491; cv=fail; b=gaL0XgYgdQlA9xfP6ZGY0F+i9vLHZHE46QcpOZ5/qLudZFV3hM0Nt6qo8i0EcuM3C9QIPzAmdrP7CxeOTG1ASdnR7Ukg8qwiiASseE+wlb+yR4yTpp5Hf68bnLxO/zJcYgzuZO9+K/Liz9LjZvwBQHBXBOGOFMQuWysLVUXcAWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706242491; c=relaxed/simple;
	bh=5RytehwruOiKS3cu53xxOQHqYtSyhPvXqy/2seZhXV4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HZjL5zzFttDY/DdF1B5flyc8sccxIye7/y/cDGE/N5SVXqaPPzvPWhEOk3TNuFqC/psJbVFxU6iPfl3D7eCI2tr6lUWcZ7nrIg1b9/OZSvrBO+OM9TmrmasfP1RqivUUhdputAMrhmCp6+nLR4MpXHZqjBzJ0Z0eYWYqA/4eNX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sWifEGm6; arc=fail smtp.client-ip=40.107.93.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZoTGzaeH2DUQle4e1T15iL0gjhgPgSSNyFtKoX2gU1a2PjSMPWellzBoY6Co91vRYmV27mYHVqf2KVrzvhxKBdUKsRJ0y0adyHETk0zjUCuMtPSHhQZfTsIaZBPdYawbONPtXmFGfmt9awcb3tTU4xNP2Oy9A3lPVBgM+Yx/5pKBJcjs/JkRXhTYSXtzFCqVCsgSL41ViVINYvPhvOkLSzn5AjB5KxdbK5qeAnWZ3X33asMA05sHc2NFUeK8/5vvpM0wUtwzUTKwb31cVZbmzLHH9/CkKn/rrU2JGZ/S2CVfSmuaZT/O4eIIZTM6QXdTHwKsaXbFNHLaXfsZw8WjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KuTLI/e4rw8UMbyjzDaRsBOuInrsZy4AaAHurzAMwYc=;
 b=Jm0OBTh3FpHxrpFXU9/V9eE2ZvCTQRpaS5lJOqYq1auMS1msZF/TXTNP5tu/WmUuicofebbDjW/gSVolDmq3hwYpF+n327WIHNISbVMFcXt7LelxM4N6S7VhThpuDbB1Vg2N4Hgo1z/KVi/GS52Oe4XTsKvlSivPQotphn7YOp3LTyREuWaSQtJfx8jjyXQbTT7ZHmEO2em1NhFV1pmadkG4XrHczdx1HjpjsdfFsggmn7lxB6DZbVPTIPQ5yZkIrfcDODTe4uWezLgMebkhx7mcVxtJVcD3DkQZWzfbimGk2X/coot+P3uoe43NfZPwMo/NBO7Up8h4VezKOGRb4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KuTLI/e4rw8UMbyjzDaRsBOuInrsZy4AaAHurzAMwYc=;
 b=sWifEGm6CmbrjuvtsIT4rI3rUARgvntc55exjKXtSg7xbrJEBsmP70X40TzvF9OGOP3WMSC6oEpGXg8YHyqs3IQ4vK6Gx0mf4CKy9GtnsMSJtZgN1C0deX6FrZ+OkPtxcIQ/fUalaD9YseGzLi/dRzzyxqo6VEGzUSJsh9cUEw4=
Received: from BY3PR10CA0008.namprd10.prod.outlook.com (2603:10b6:a03:255::13)
 by SN7PR12MB6672.namprd12.prod.outlook.com (2603:10b6:806:26c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Fri, 26 Jan
 2024 04:14:46 +0000
Received: from SJ1PEPF00001CE3.namprd05.prod.outlook.com
 (2603:10b6:a03:255:cafe::9a) by BY3PR10CA0008.outlook.office365.com
 (2603:10b6:a03:255::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27 via Frontend
 Transport; Fri, 26 Jan 2024 04:14:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE3.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7202.16 via Frontend Transport; Fri, 26 Jan 2024 04:14:46 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:14:42 -0600
Date: Thu, 25 Jan 2024 21:44:26 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>, Marc Orr <marcorr@google.com>
Subject: Re: [PATCH v1 22/26] KVM: SEV: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
Message-ID: <20240126034426.f2v6p7sjmaaopwig@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-23-michael.roth@amd.com>
 <20240121115121.GMZa0FOViBESjYbBz7@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240121115121.GMZa0FOViBESjYbBz7@fat_crate.local>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE3:EE_|SN7PR12MB6672:EE_
X-MS-Office365-Filtering-Correlation-Id: bcef9d13-4e26-47ec-4bb9-08dc1e255496
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zkhqXp9OOlKdenbyecaDpwVqz2w6LzER5rt9/VtD0ulPp5jjf71eJzFM/DDjp2QdNY+RJvh86rhs10oL1upwtafkBOH71fDujFDbfLAF1UbkeZVaH7sUtx8VErvzgom+WOJC4ta0qfj78yAlBkTV/pUyap5eiVh2UGqHyQuAy+vR8Fzmtm4WZ4Q80ysCNEt6HQE9LO3kQrF6YAYv5rnLyFBMzJ7LJF/RH2qYY/MNLb3zguQ7AgO2RUOCSOnqZPBg0lpUJtE/C2THJiaLswOF2yRXEjasYD8eRUq+HcEHWbu7MsdamJjR/lWAu35gOA72tMYN+vvMe8nq1OFTHu7MdCHZau1wR5Rq02HuBr7w7RfykGVypiZUOK4W7Zyt2LHwkxnAa6f5CwARVtS7rR+jugQpuDTWAgrBk/pHyiZv8cBwqCtg/htFetPosmJTltThqWY7Fn5pli7wOeGO1hKUD5nesrKWa8VIGccNOvNBPTRdrRg9L3+58O1p0vFxbJYcND2q6eYrpj6QCvqQdGS6KxviCHgB2V9jAavJ4etX5wLrQ1MlDXicSd3qUz0DuapIeJzp+XWGttsTQGqFrzTiJLLZXvy4mLDbZ6p+zv4aqOUv1VzksqnC04laxKs0u2W8OfLBt3aQ3yYSRenp2coX3TQMF83oJpccYiBZDTAUv9X12QGXSKswAgv/iy8eM7ZKpEdpeYXDVhZFoZzbXh3qflz3adxUCG6tDRjk/RHPe6crqC9J4vB+cY8MdqgAHFwH
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(376002)(396003)(136003)(230922051799003)(82310400011)(1800799012)(451199024)(186009)(64100799003)(40470700004)(46966006)(36840700001)(40480700001)(40460700003)(966005)(82740400003)(47076005)(478600001)(44832011)(1076003)(6666004)(86362001)(356005)(336012)(36756003)(426003)(2616005)(81166007)(83380400001)(4744005)(54906003)(70206006)(316002)(6916009)(4326008)(8936002)(8676002)(70586007)(36860700001)(7406005)(7416002)(5660300002)(26005)(16526019)(2906002)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:14:46.0276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcef9d13-4e26-47ec-4bb9-08dc1e255496
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6672

On Sun, Jan 21, 2024 at 12:51:21PM +0100, Borislav Petkov wrote:
> On Sat, Dec 30, 2023 at 10:19:50AM -0600, Michael Roth wrote:
> >  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> >  arch/x86/include/asm/kvm_host.h    |  1 +
> >  arch/x86/kvm/lapic.c               |  5 ++++-
> >  arch/x86/kvm/svm/nested.c          |  2 +-
> >  arch/x86/kvm/svm/sev.c             | 32 ++++++++++++++++++++++++++++++
> >  arch/x86/kvm/svm/svm.c             | 17 +++++++++++++---
> >  arch/x86/kvm/svm/svm.h             |  1 +
> >  7 files changed, 54 insertions(+), 5 deletions(-)
> 
> This one belongs in the second part, the KVM set.

If we enable the RMP table (the following patch) without this patch in
place, it can still cause crashes for legacy guests.

I'd moved it earlier into this part of the series based on Paolo's concerns
about that, so my hope was that he'd be willing to give it an Acked-by if
needed so it can go through your tree.

-Mike

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

