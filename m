Return-Path: <kvm+bounces-63521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F981C682E8
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 09:23:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E4A893469B7
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5122230E84A;
	Tue, 18 Nov 2025 08:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TLau1Is7"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010005.outbound.protection.outlook.com [52.101.46.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70F83081D0;
	Tue, 18 Nov 2025 08:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763453871; cv=fail; b=XQa64/ZyN5otxpDX0EGfKfVjvPeq9f7QcWkPejY8iXSTsm0IG8Mx09RpalkPijuuME1TEdQYpj25WnKGAtnN8KS+Wx781V0o5pTFQu+nQlQzK1SFk/I2AcgnILxEHZJGi6bZhwHtlfQ6iImtzlmHdUSv/g/64W6bnwAHVHPRzMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763453871; c=relaxed/simple;
	bh=jIcpdh9dBj4mqj+aIdR8y5lS+TWPMtDkMvKHnGVuvGM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O4nF3jP7gkd1Okup0idnPKc5reLdzIY5k2Qwd4804fLIxWacmV1MCLtXA5R6HTwbOW4Iayou7FoQYdaItlQqp4BJEdbQluuRkpKNO1W5vV+flj3dl60KmUuNiYxD/DSzJVz92+moQfuowSLrb0mOaz/n/EHPeJEqOllYQMy+/iU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TLau1Is7; arc=fail smtp.client-ip=52.101.46.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dnA/olFp1FR9jAmjA9pivnLy2Nf91cL9vd18ajy+4+bK7abxciUpYvhSNFbBbwVJcBMZbgFdD0iXEHystq+HUJbG54C/jaVgoiWP2KfTUJCxl+oV5yA+2aZnfj+uSkPrg4uQaq/g1ISJXqAh5fDwWHSAL/dQiRUqcVz6trsqrIpRhv3K9KrWcr8xdupLXhS9YSeAuJZ3eqE/sodb0xzgl1vynGo5bHjH6eoWSYwaH68KFjdNlBbgJiTjoD+6ZSJTgDvhTD1O3Ii2LDsDxRkrsMZUT34Ydo43kAwNk2JfdWUK3N1lwoyGY+gqRCVs9jbPSdQVefj2BwKWz9IGHlnWBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2+WJ8N2Cf9h1AXY4Va9cV50qzJBjWoeZwku+rFJoA0M=;
 b=HI21baN+PeaoS098+sCYQe/goty8SbeOOFmQxOhAdwPZoQ4IaamQ4bW1wnYFOPQy6DSVesAfQcDRWBLO+9czVdCiBxS0ZgS3IvH+OJpON+22zGIRh/iIMJkjNhnOa/bUVKJjCn649bR09E0I7XOw87SQi8pTBL1NwjUUGHkf2K5PBQfBjcTeI7HCOgFmVzbnhkwwGDRXMIitWG24dZbXE2WNKRf62shTaAFr7iq3pxYjCIYxisSO9B3w39VQl+ggvybUe2uXOYGuKKaeNaaQUAovg52x1uf05HKWMNWfZ+2bZ3NAa+rzybLSOc2lzLUXh6Zvn1/vPWRz3uvM5/PjTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2+WJ8N2Cf9h1AXY4Va9cV50qzJBjWoeZwku+rFJoA0M=;
 b=TLau1Is7NVz/4PbKautMkGaU3YMgf/BRqIVJLnrGnh395drg5iFzVtKageqt3D3D7ao9xsjlSAST9qJkeLe6CksW0VPv06lmUcM/tT30whuhWAxofc5EedNKrebIIHcJmCl6GKBMFZY0DBRFsRibu8WMHKdpfJQIFqucVsGVwGiqODgZoZ8hPOk1bN9XVQBcd9mF0VakI2l+Jf0swSbsEgr9l+kBeAYqXnk7Ua9pftLDtnM1KQ7iuAQtl0k1ICznYn4+7+3gjmU5CIvFJgyYqzExfktlEVmtCs0IENt7j59s/IW6XsVsZU2Y7e+Cxj2rfh+QxHYiqkUj1ShjVGjSdw==
Received: from MW4PR04CA0279.namprd04.prod.outlook.com (2603:10b6:303:89::14)
 by IA0PR12MB8205.namprd12.prod.outlook.com (2603:10b6:208:400::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 08:17:45 +0000
Received: from SJ1PEPF000023D7.namprd21.prod.outlook.com
 (2603:10b6:303:89:cafe::87) by MW4PR04CA0279.outlook.office365.com
 (2603:10b6:303:89::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Tue,
 18 Nov 2025 08:17:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000023D7.mail.protection.outlook.com (10.167.244.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.1 via Frontend Transport; Tue, 18 Nov 2025 08:17:44 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 00:17:28 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 00:17:27 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 18 Nov 2025 00:17:26 -0800
Date: Tue, 18 Nov 2025 00:17:24 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "afael@kernel.org"
	<afael@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"alex@shazbot.org" <alex@shazbot.org>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "lenb@kernel.org" <lenb@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Jaroszynski, Piotr"
	<pjaroszynski@nvidia.com>, "Sethi, Vikram" <vsethi@nvidia.com>,
	"helgaas@kernel.org" <helgaas@kernel.org>, "etzhao1900@gmail.com"
	<etzhao1900@gmail.com>
Subject: Re: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a
 device
Message-ID: <aRwrlOfuFWa8ODQK@Asurada-Nvidia>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <a166b07a254d3becfcb0f86e4911af556acbe2a9.1762835355.git.nicolinc@nvidia.com>
 <BN9PR11MB52762516D6259BBD8C3740518CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRduRi8zBHdUe4KO@Asurada-Nvidia>
 <BN9PR11MB52761B6B1751BF64AEAA3F948CC9A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRt2/0rcdjcGk1Z1@Asurada-Nvidia>
 <BN9PR11MB527649AD7D251EAAFDFB753A8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRvO9KWjWC5rk/Vx@Asurada-Nvidia>
 <BN9PR11MB527640AE172858646199B1888CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527640AE172858646199B1888CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D7:EE_|IA0PR12MB8205:EE_
X-MS-Office365-Filtering-Correlation-Id: 950c08ff-ef52-4026-6bf4-08de267af38b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qQowyPVVRLs4zpHmc+NHuAMSCwyJ01bJzJtC9IlERwOjtehcWpgrlAv7+3kt?=
 =?us-ascii?Q?0xJE7pOM+DaskhljOQXi7GZRAt9zud6dv2nXOdTMeiz8aMaQFztW0WoMrzR4?=
 =?us-ascii?Q?1qs45/JGnWFZxgER8dewf2zv+2ZDVJ/IfSpn5TnL73VRiwIYPZkFWjIFy8hT?=
 =?us-ascii?Q?EK162lf+fdsX5VH0Ik6wsaGdqe+BAmzWznzxH3aYMvFER5ILVvCNbwki+VtX?=
 =?us-ascii?Q?tv0347yOIfPzI85mWrhTEwmL0jBu5ESP31G9+X+t3bIw3/gJKF3YPxgTr+0w?=
 =?us-ascii?Q?cFLNE8Wmu01LdaHgI82+h9h+Kb0D0YqGS14SiV16GuKFoDVm3uEDpeM5Q8u5?=
 =?us-ascii?Q?fvgQdXiLPe7Cj03tmCy89Vl4s+Z7mT33AEgHwMqIMvvaj8jxRy66FxRq3pVW?=
 =?us-ascii?Q?TB/yWRzBScbzDUpfDWxnpY8bPWnGDDb/EhWfy5PKclqOATPpkGPjXKg2kKDt?=
 =?us-ascii?Q?a/hjBXQXinkMs+bbgBvoMnlWG1NpgWSIk42d1bbbWpkv69H51DVSil0pV4Il?=
 =?us-ascii?Q?OAcmczBdHdrRZk1ocju+PoAlGa2IS0Ja6DMNQ1owVs/Kl56MMWUTv6JNmyNE?=
 =?us-ascii?Q?NgAfPkf3A9CvwlC+0XKnwzHG5+enGOx+9BH7OdWKpjeOFRhUIqhsnnG21TF9?=
 =?us-ascii?Q?81cLrEratdNNXBa3DdK933IpzsHEaxQ/W4cAC4ZR0mz+//R6ViAhBt2fDCAc?=
 =?us-ascii?Q?DG7RnVJndWTUPh8ZmZ9c7XzFzHIHhaCkKyR7kZuONqdQTcKKRIDImj2L+xRn?=
 =?us-ascii?Q?mKtAj2/fObPl/eO9drdedi3FTQQpKu0qJKm1/ckamiCjEjNm9ee7rkczUW2h?=
 =?us-ascii?Q?yEvT0q6AsFLTd3DDADN8++mN44eT34p1YZcWRbKaQ4yaQyFzlWu4pkT0Bvyr?=
 =?us-ascii?Q?B6N8iK3JAZ90StJSavlE7bbS3I71o32qSFWGqYfTplCzIAI233LowfDntUTF?=
 =?us-ascii?Q?OQzhNfa8Q1pf4xpnRBMQoz3zP6u0qcl7us5ZqdKj+vVJNiS53YAcWk8ojdHe?=
 =?us-ascii?Q?Qck6nZ/LKLQ371WW+rHrgoOJMqoUvU88B/NXEiIj7ucLxotXUzVIHjFito2F?=
 =?us-ascii?Q?NjpZY4GOlszmmg0M0zgRciwcBOCUSHQuz3owKBx8qRPCqQbVryGPyvgZDFcK?=
 =?us-ascii?Q?v956ElxXtvH1EMpgzM+FdyX0cpSM6xfBAgnEcxFI2kVVnOVbtXlGqT9vMroJ?=
 =?us-ascii?Q?U0b2hUmhy3fHMyGN0xwO9AJV6QtDonAqaLojnHbgZbqJgCfk56DlDe5BxjX5?=
 =?us-ascii?Q?jCJkWXzZWqoPueppLws3apSzm8n3FwpA/EvFpWWtMFDz4YB0hhKO/qcfrVCk?=
 =?us-ascii?Q?7IRQvKmtVwEhyeHmAtHk0XtP5kHmHOmMaNjam04XZsuin9uKQi4OiaKXG2IZ?=
 =?us-ascii?Q?7EfdF5Zy2weXUl5aABYtHXp7k6lxZQMBcfOhi1Z5kJ9zAd86xXIpXIpGUk3j?=
 =?us-ascii?Q?mZ8fFvyqHzNRKB8va4VtlazZDtcqcs+9gZalcDdgK8CARynPvZAZ5aFKdG+U?=
 =?us-ascii?Q?9PjVMuK1xFvkbQSpbNrO7vk8wijevX8ljypDj4KJkT1Hg8eFGqbDbM6uhBF1?=
 =?us-ascii?Q?2HbdXphapdOTIdOlshU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 08:17:44.5813
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 950c08ff-ef52-4026-6bf4-08de267af38b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8205

On Tue, Nov 18, 2025 at 07:53:27AM +0000, Tian, Kevin wrote:
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > And how do you think of the followings?
> > 
> > /*
> >  * Per PCIe r6.3, sec 10.3.1 IMPLEMENTATION NOTE, software disables ATS
> > before
> >  * initiating a reset. Though not all IOMMU drivers calls pci_enable_ats(), it
> >  * only gets invoked in IOMMU driver. And it is racy to check dev-
> > >ats_enabled
> >  * here, as a concurrent IOMMU attachment can enable ATS right after this
> > line.
> >  *
> >  * Notify the IOMMU driver to stop IOMMU translations until the reset is
> > done,
> >  * to ensure that the ATS function and its related invalidations are disabled.
> >  */
> > 
> 
> I'd remove the words between "Though not ..." and "after this line", which
> could be explained in iommu side following Bjorn's suggestion to not check
> pci_ats_supported() in pci core.

OK. Thanks!

Nicolin

