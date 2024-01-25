Return-Path: <kvm+bounces-7012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE9883C3EE
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 14:43:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0E0628E5F2
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 13:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 717115677F;
	Thu, 25 Jan 2024 13:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vv2zRfZi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2042.outbound.protection.outlook.com [40.107.102.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1638B481BA;
	Thu, 25 Jan 2024 13:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706190221; cv=fail; b=dK6Sh+GvjJbPSqyof/klyTn/tlZBCSgJLM0iV5MvT378AztDyG8YuoTBwwnP07MkJn7m3kiGWfFiJdLDAiC5GO3JyMnCz08mjsC5mt4wGPg9/aN4RLrpuYmOetF7bC+0t7piVILldZHDapjyJS9/PiFsUbS9phdE0rsj5ZjuQ5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706190221; c=relaxed/simple;
	bh=cZ9tIGduhs2fIrLQFeMAklmwJmkBWtzhRlbplmpksj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fiXnrL1sx6CWqemomePvDiNeSh6gSprShvABX0+PxOXBQuq4lCkme/yx7kYKiSgHgALFHa5SbwSiKXok4OpKf3wwYBrvwbtpcGaB54y/qc8C3v9SqxvGT/urIWDX7WDt6aFCLuUVPRFfKbMwhvq3EOnln3+X67O384nTFNry8TQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vv2zRfZi; arc=fail smtp.client-ip=40.107.102.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbyRFoqxXH5ym3EvAgco+F8v3q0HuWP/x4BmCGETOlYOHeOlrliPNzllTd0EeIS8KaQRqWTA5s/GGZOUlc3+MILzdmZY9quagGs1eVRu7MKl8imfccbBS/KzQ++gBOpKbPaDm0egSSe8vRA0ESRisIQ60x0pejTA9Wy7RYARyZRfsW5ENHud93UE0iqhXvUjMN3g2lfIyRbISGbnX29QiLeA0E6AR7X+tsTLsjxXkvLgEMsAyzhCcYevgp3gYDx8roYDXwZmERwRRl6fa9gyKltYZcc1BKDFQbUzJcKdfIEwhH8xgctrrAR5gFW74ziOqmli9XKdE8gtZRRTB3JbUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WLGwO6EbtEsOcT2+wkj0YhDE8L7pwTEbu+BZd5pyDTk=;
 b=mmq6vDbtKTA4l80kAybPOrNtqxiFmqQrxZ8wl7AA1PBSVn9CaWPPeGPgId5144mBKVC9eUi7x6ZSZDu+CNsqNPMnkqiZLUDe6lcSg01KrDsSv7S+yjZpI1Up1kZYtvxJ15GOiCq9RPAJDQXX9WTYdntA704kSToSO4QZME2BTv4yj/HqnpqzlDR0xE5B6Dfe11l/RCaFSOclrrEvCUAcPf0NztMVfyOxJ9nUl0iLFrtlYD1GQuyXqXwJ1tjZV/8+EZBeqNF7YRBOTkseP8Z5bj67MNfBStEN10+VPCz+lXoZhLGvt2hd+09BM6HrQzAfMwHu1sO5azgKht9Ry4M//A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLGwO6EbtEsOcT2+wkj0YhDE8L7pwTEbu+BZd5pyDTk=;
 b=Vv2zRfZi4FnLG7Kx42niN3lgGsSmB8UEJz+SkR9QVVCwaPezbAjSJb6t8PPKc8FDWXYggtQDRGJmb31Wdpa1Du8XOcozGNznCR8fSD1rIIpGEwjfBq3AYliNcU5aHWNBlMqm2ke/9MYxgjdUuk+Ra4/GoFQB9ZVP72i9NwWT2CY5q0nlwEY3rSYmzKYfAoq45cii/5ULEoZA0xau7v8LF85Ayqbn4RpfZTHjf/bC8V1yTQFJr5qlSHJrfMvoKHpv7MSJDpq90w57KB3eP/vnl4nuEmTGCVxcVplu6ZAmXnqhxZ0F+qqmEwcsJcW6df/okMJMUPDeyLTXXCl81XSIOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6304.namprd12.prod.outlook.com (2603:10b6:8:a2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7228.22; Thu, 25 Jan 2024 13:43:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 13:43:37 +0000
Date: Thu, 25 Jan 2024 09:43:37 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Joel Granados <j.granados@samsung.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 01/16] iommu: Move iommu fault data to linux/iommu.h
Message-ID: <20240125134337.GN1455070@nvidia.com>
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
 <20240122054308.23901-2-baolu.lu@linux.intel.com>
 <CGME20240125091737eucas1p2091d853e27e669b3b12cea8ee3bbe34e@eucas1p2.samsung.com>
 <20240125091734.chekvxgof2d5zpcg@localhost>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240125091734.chekvxgof2d5zpcg@localhost>
X-ClientProxiedBy: BL1PR13CA0271.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6304:EE_
X-MS-Office365-Filtering-Correlation-Id: 44fdaf58-2950-449a-1b9f-08dc1daba20f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GKdLoJC+QTR7KQd17130SfOXI69mB8+1FWwtYnVowudCM+Tv8mSaI6ertd0q26Yd2sqpsABTQeal/0/0t4BBwMBy9tf82HjFYvY3n62dzsS0AJulHoSFHs2XdK717ELjKis9scnlpcVng5c21JQAozdstdGrcpmGWfZ5vwprrvYZGxSA86F69jo/zq7jvnxgykVJmzijaab/OnTUt10xqCcpu3KTOARquzlq1bDGwmg7MLI3gtcRhgjiCdtU0WQFckvNbMQ/XDz3L21Qom20LAYCSJm5rB7UEqXVazltPNwdUXTwJSUArQOn3IrnvUBqSxNUttT/FJaVfR+dtaJ9sSlSaD3l4RuVAmwBlXI1eQTf8muvt8tNlSO/t7nObazlZg2Zb/u+sLJ8giD6rNI2cEHVAgroGFT4sh5fhhUZ0B7YfnwqlUVbfbhublOeCxDbzSZ4izi8N1cCfk2rFhIQ+2R8SS0Tq3jFLFzM/u+z+NpuDM+ptEsuKd8ma9H4MYQ4wE/QFQvIJVE8MVh1nUnKAaglwLxq0kmvp3jhb7RS/UPfoSYpEiorV/ozRuFAPqN+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(396003)(136003)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(41300700001)(26005)(2616005)(1076003)(6506007)(8936002)(4326008)(8676002)(83380400001)(6512007)(66476007)(6916009)(66556008)(54906003)(66946007)(6486002)(478600001)(86362001)(316002)(38100700002)(36756003)(4744005)(7416002)(33656002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FQtehZrnP5OxHGZ1Bo3KEO09bSlp89vcwEMXKNCWCWeNa9yrVujrQehkJzqx?=
 =?us-ascii?Q?789sMy7aYgg2qlNzQOSokMwpL8ugBEfJs8TCFNWLleTQuBH1Y30WsUhtb/1A?=
 =?us-ascii?Q?Wiuv//W15VC4MXcT9jjh/Hhnmb9rWp2Q85KLb+/m72R9SbYyJ+ni3ANHOGXd?=
 =?us-ascii?Q?YJl0llHDmdPDASezMzQ9X6oaomOOCLD7KTHMKTffMmhHj7+rBFZytQNrze1n?=
 =?us-ascii?Q?EqKmX6/6D+Fnqn9v/flHxmdYhpuw3GBN8+EDr8M08fn3jBzwVVTE/WzuedK/?=
 =?us-ascii?Q?GAJomQVR9vq6AwI/SwInexuVI0tf3AHgTSNbaalNo37yEeMTm7lTHQ5FHiTt?=
 =?us-ascii?Q?E7dj+IPLdL6X1031ClbR0crozyGukumHib59Gu1XADOpnOPrsSEu6Cz+kxNw?=
 =?us-ascii?Q?OJdCFe4HpHoCyb/seYnO25PqPTVZdwuO5IUFGApX9T6Al8sZPLXmFdoF/jBi?=
 =?us-ascii?Q?oCOORH2Bi93dSJ707xFhDpRXP52FuEaZgLgwDr6YZZUXulZ2aiLovq41bGW7?=
 =?us-ascii?Q?3pfGMdMasjCXroF3xaLo8FI7ZQ91ENi3W+VMq+4YP/y1IjubaG2SeYF0ZjrZ?=
 =?us-ascii?Q?1UDC0RHRRPJrr+ZXi+PadV45CzZJWmP/aZkmN8U18hGl2/qpm6SLcFGThfi2?=
 =?us-ascii?Q?dIHhU8FShpmbPlJRhBIfjrX/aaORiKEqED6GgwPXjxFyCtKXX0vq0XKP64yK?=
 =?us-ascii?Q?bv1yeAaqmQ0OgOcRH9XhKjEsPN0mx6jdh2YPOAmDUnfuFg/iPlpCRc/QaCkh?=
 =?us-ascii?Q?6olQpYVkbMFwA7qOe4UnXUm4UnQ7xmwYTE1WCNxTT3inNzKWyiWiAA1ZyiSN?=
 =?us-ascii?Q?IDf5m/b3jgBeunzJJTM6KyjRVCbP0ON44OrzdpTf0j1LvQVGZKgWeUcpVFLj?=
 =?us-ascii?Q?w03SYBz+E263b1vjvs7jgEdYZBf88W8aMmhqEkPYvGucMRgVb5jLkWgkHA9o?=
 =?us-ascii?Q?rzRe9lrPhGV239doKYFKgmSkT/Mm7BDfEFMIoZV6O84wq8jXJop5ESGniACN?=
 =?us-ascii?Q?fbOjYdO2DBQaHwrNQ7Y6+9V6tSJH0hi9zU3l4ilq3dQtEaeO6rdfUe+P7Poc?=
 =?us-ascii?Q?FIu2j0LGJHxmcw5U9no3A02310q5DYDAdgXwWtKNuTgWiEAUFOs0geHtI1YD?=
 =?us-ascii?Q?x4BQSPj8/9E4McfvigVmlFhye04IbIgqBUflnHlHJzlYFiCBlDEiJLxIPeMY?=
 =?us-ascii?Q?NYEn5336vZVaMu8IV2y+dDaVhBl4uMgYKlmilZRfPmefoqrKyUCOQt+/6hwQ?=
 =?us-ascii?Q?Y91QSh36CmXvG2Kr0plljlAfm1e7+rz6ya+ICF3+w9mwdhqLtDkUnMbDVAhd?=
 =?us-ascii?Q?iuBnMhc4E98WetUBILvDBUMi7a4/vMZsClRext7364fG1ruBTjnDVC6KxiXu?=
 =?us-ascii?Q?l5IE5kzG2v4tCGPIadbiJKKy28OSunQYTi9J4yE3VtfA+gnQ0/m1gTlEWYVu?=
 =?us-ascii?Q?p5V6vs+fQnbV9dqM5k8cbkyPjCd8tpHdl4mrOx/MwlabvrtXLv0bXANqaiIN?=
 =?us-ascii?Q?jXjvHILfAz750ujrs1C3rlpy5Cz82KsSjnDfbJLEwvpug85p34euxeI8rvtS?=
 =?us-ascii?Q?kRsFIcQsmbPofW0HA7YGusYwfUqQr8pjWEkfKyUp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44fdaf58-2950-449a-1b9f-08dc1daba20f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 13:43:37.6195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yIKvQZp9k1Ars97fJ84b7MXLz4270aYc/XsQGSinTtd2EDwSHvxgS2TFN3sGPxfz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6304

On Thu, Jan 25, 2024 at 10:17:34AM +0100, Joel Granados wrote:
> On Mon, Jan 22, 2024 at 01:42:53PM +0800, Lu Baolu wrote:
> > The iommu fault data is currently defined in uapi/linux/iommu.h, but is
> > only used inside the iommu subsystem. Move it to linux/iommu.h, where it
> > will be more accessible to kernel drivers.
> > 
> > With this done, uapi/linux/iommu.h becomes empty and can be removed from
> > the tree.
> 
> The reason for removing this [1] is that it is only being used by
> internal code in the kernel. What happens with usespace code that have
> used these definitions? Should we deprecate instead of just removing?

There was never an in-tree kernel implementation. Any userspace that
implemented this needs to decide on its own if it will continue to
support the non-mainline kernel and provide a copy of the definitions
itself..

(it was a process mistake to merge a uapi header without a
corresponding uapi implementation, sorry)

Jason

