Return-Path: <kvm+bounces-25968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD09F96E615
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 01:08:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23A231F244EF
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 23:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB331B9B4A;
	Thu,  5 Sep 2024 23:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dHpVbRYh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F90E1BAEEE;
	Thu,  5 Sep 2024 23:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725577623; cv=fail; b=j59qkNgbYUjIXdViiwjhuoFPdnx0XDqWWj/EI26278T0JkWgNY+biizyG5XJAwOxb3H7H3U3p/p75vQJWzHzUmzchtmhphx/ZKAJExEy6zLHD+67UaRYZRUnnu4gFjP5isa3BkGu0cLLiT8kVHDpyFmZ2Oy/Y9j2GfaFnzfpoI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725577623; c=relaxed/simple;
	bh=Q/At4CiGjmv3Iq6EmiF3HzkmRiy7lXxYaqk3Flo9J0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Zf/bOmCtO/9vVjTRxAJTTij0uPy5RdlSk0YtKr5UG5iMAHgHlMfh34CWh+whA0g2p5C2GUANXJc3OUovTJ6JLudWw5jMk7rg35/H3hTNMPEh2b1Zqx9ur/BOiIlJoVq23nrrfvZi8ixkHQA5ZMeO6U8N6DtxTk3HZc9KKMvU1rc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dHpVbRYh; arc=fail smtp.client-ip=40.107.94.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yk9Q6zJ3NCVKHCJSV/Uhawtp9SjHFLa7CN58KbtUQ0UNFgjDYnipg4iUkRAu4ZuOBXLCnjlNiQ3GmX8RRpf0HtBE+ERtk+A7WFrYe2nfJu0XdIlzKscaBIrg5Trjb4YqFaMrWI2bHFtVGTnIcCemrzYU54SheKi7Di7AH4vjBkkDTd2zmKFrsGuTF8gJYZNBcxHhJ1jDQ5CMN4kXPwjRdhVOPsFeaEaOZsvHCattX69zWzNtqJKEYwvFoXdnMXo8lBEEabv/gl6A19+FOmIGwd6XYD4Lh4I8XdcoVezcY/KxdqMXH4KrvWfDyXEqeBAJ/n9FTl+bbTJVdgsbBX2Gcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/At4CiGjmv3Iq6EmiF3HzkmRiy7lXxYaqk3Flo9J0E=;
 b=m/npHln9QbxCWLOgT8OK/z+8U8SiGqWhTPNCJaLqmIzhyYPqulUs0E1hYVWbq4oi8oIfEgkvXlIzjiGx97bq1rrRbfNargjGdNqGCztTRkvCRvZ5EsfPiPQpCukCLd5J+63xUT5FYoFjCLq1Y0T3hBS3iFibLRfMWAN6G95X6ONg/+WANsOgDRSYzctaWaylSPlgzm7e+fodDizOah514C4d8U/gjJ/+FQAkgHfrzxIZ41I0RCT1RiExXtMltLevvCr+ZhIK3lzyf35vs7qf1DFhdD/zNTUyhRAFn76qezJq4A9N4umybbAMBGQp6moJJTW1ccj9MP13BelkE3kIZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/At4CiGjmv3Iq6EmiF3HzkmRiy7lXxYaqk3Flo9J0E=;
 b=dHpVbRYhP68o+Ytg3v4AemidCL2rtBV72SfvyCW7TitoxS2fZmdTyq+2wT3gnG1Uzr4hq+dqMTsmsPXf3RqqeZ9pazqODgaams4Ckf3hzqx38rFi6Jb0icpitJpzu84ZktZrwf0xB1ndP5eddYhsDvtff3gb/u9v19Mehhq83jZuhNNNF+mnqySV/OfDntpAscXMEAjZFs74sLRqTFMMhlIQbpHqkUoO7GJ1MJzLhG46zuPVQoItvHpTgNPntxViKDk9qpMt1Fb9UAwLVgeiTNgxGezfE9mGa5Mz0JEfufCGocxi/ddJLgKJjSF/Y9mXt12NyErwoXSrr3seNZFCng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DM6PR12MB4371.namprd12.prod.outlook.com (2603:10b6:5:2a3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Thu, 5 Sep
 2024 23:06:59 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 23:06:59 +0000
Date: Thu, 5 Sep 2024 20:06:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>,
	"dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>,
	"david@redhat.com" <david@redhat.com>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Message-ID: <20240905230657.GB1358970@nvidia.com>
References: <20240829121549.GF3773488@nvidia.com>
 <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
 <20240830123658.GO3773488@nvidia.com>
 <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
 <20240904000225.GA3915968@nvidia.com>
 <66d7b0faddfbd_3975294e0@dwillia2-xfh.jf.intel.com.notmuch>
 <20240905120041.GB1358970@nvidia.com>
 <BN9PR11MB527612F4EF22B4B564E1DEDA8C9D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240905122336.GG1358970@nvidia.com>
 <66da1a47724e8_22a2294ef@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66da1a47724e8_22a2294ef@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: BN8PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:408:70::20) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DM6PR12MB4371:EE_
X-MS-Office365-Filtering-Correlation-Id: 4050f5e8-fb18-4afb-139e-08dccdff71e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Mbp9RQgsqr76SluK3xxqSpqMEa8ROBH4ewVKcF8X+CTaBLnM0F+WdRNjGYAI?=
 =?us-ascii?Q?upGEVxEJSge2xbmnJc+0TgmzOimLNmuLJuCE5i3SrLN8khRwD8bdXDALnkGl?=
 =?us-ascii?Q?84BBqduSduvjz3pQhrWe/XP8VrLMB6TZwhqj/BQBFDmmB7TBnrQkQ9+Weu8h?=
 =?us-ascii?Q?BFZD9njHZ/DQmI4XxXJe2wpsHiSmD/Q800K0425u5MNpR1x2V13ItD20Gnrb?=
 =?us-ascii?Q?qR8zswk3KhI2vWd5ys3Skr37D+e8WC35Q7pOtNpG+xHiMnp5ZNbouwolyOFH?=
 =?us-ascii?Q?+ddNXidVN3xdbfiTJuSXyjd3WQ6QWI9cmiJktpBBZnLQzaliOhAAmjybVfBo?=
 =?us-ascii?Q?4IEnyHwEJcBIRxUuieiEY9KGeQKiExi34L0cpJZdn18bHiamHgu19beTCMn7?=
 =?us-ascii?Q?e9GxQIQZQWCwB8+LmXr+KxXBuJWvbPbtWybcbKBMVHgfC4aEySGeAwGatMsh?=
 =?us-ascii?Q?O6/Ph3I2vqqFcQHFxtTAtP8WstSxOgosjUXLBuH5IAgQAJd6+LZJhzqAOP1I?=
 =?us-ascii?Q?mkoXtvIKa+eZd3mIsuHPf6vW02DbObmZqBWDpCoRZMO4QAnrFTbgdn3as9Ni?=
 =?us-ascii?Q?JsrInDDkgdROPCjjImYS8BxHcvwAcK2HUrYluQKHdAJJ8JYLTASLUdhRypKU?=
 =?us-ascii?Q?S99h3vg9r4EENa+VaM3TO6PutyWsB+s7ebnnU8Q54K4DPBJc76WC3/qsLcJ3?=
 =?us-ascii?Q?80DSBMCFNlDEzEccaeF7ee6qxWGLiKWQxF28WxnCjTnb92/MMhkeozytadOi?=
 =?us-ascii?Q?fht8k9oyHMwjs8ZoXyLc/B1o/fce5lfUm+Y+2Vz/WqqRfV0WFrQbuue3NE0M?=
 =?us-ascii?Q?2wxztQlR6mULFtfSEz83UPmETp2PT9WPavPTOlmGR/LxlEQOsgV3pCeF/B2X?=
 =?us-ascii?Q?n4TpRhduezwkxIm71KcpoeLrSgPt2huXGQjex9qbF6c7fb6KUO0LG+NPCqv/?=
 =?us-ascii?Q?XWs30NncCmIVCA93qO8DXkVHKrIK8J8fl/JGu78yUBsgSiy/YzUTIUr9giyW?=
 =?us-ascii?Q?SW62rQdo0UC+c/F6o/3M7Jya3ZO+kBbsUzuKcDhHnaHFqICpB8h4DL2wrSH2?=
 =?us-ascii?Q?YzeU7T8tbIxPsJBBw4Ul3rkQYDwpDYQorJ/C/TsEe2oTfvPZJPmGs9Rm9yPc?=
 =?us-ascii?Q?VWxnPHEzXYuveYPLxBLdpIg9qO1dHKKrekkTevc24Buaqaa20PCAdhfb4aLK?=
 =?us-ascii?Q?3rZQbuklz6/Y+O2PIoUZbM28S8+s8u08xoK8345JdRrx/q15s6VZCA7FseoQ?=
 =?us-ascii?Q?7bwuXszAmSJB/bOH/cP7IJeX4tnAR1C7/xlP4HJQ9KkRDyiCtKCPMdy2Vy4f?=
 =?us-ascii?Q?zKcyjeGCLNzp+jkMbKpHHRoJTPpXz/H7jJCSESQ8kvyxiQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2dZMwu70EB3+BcMjdOSpLj8+6v6SuoaTiPHXFGM6EwDpxDphCCLobySztYZH?=
 =?us-ascii?Q?gHltzuyCzQqS+55S55Ot60MWpa0Xi+tCIxDwN1GZ2IeMG8YdZP/8zPUZGDxf?=
 =?us-ascii?Q?T/I2V6iBgcFUOq5+07rq9rYtm4YKyBCO6wPrxf5BaYzZ6FX7yNbxHeTeZTmH?=
 =?us-ascii?Q?4wiPEjYw4Ear60hjsRVRR3k0G1F33brTkrxJJI8SvY7c0f0l4n3GTKtXJ+KT?=
 =?us-ascii?Q?Ks/nPj8Ot2FEQVfkfG8P041rW5IFNgUt4OwoWofEZDgfvto8WBDaVvRwc4zY?=
 =?us-ascii?Q?m3Mw4+0D382pBzpY5jh2keRVjQ3rQd8om/eFyYRV8gCbSfNP3qiUDvImtQus?=
 =?us-ascii?Q?nyp7HkWcGnDT+55otPeGPYfoWGfAepeKpTt5cmOHWUbnCmF4qnSjg5j1//GR?=
 =?us-ascii?Q?iB3SnGJsRlttAI6D87kkMYh2VlJdPQOsyyN/8UYyMa9m5S0LjXUxLifnK7Hn?=
 =?us-ascii?Q?dnR9dJA7fLqoeQnof4KN+MrdIK8JWm3xU1UWcoMBe/v2gN6RffvhZTzHGV+F?=
 =?us-ascii?Q?s/JZjfrkhLbGqKVG7BoQYQyo8SP93MpcH/hS4csAeLdtS1uBHsgNUFR+I9xW?=
 =?us-ascii?Q?+9BOI2PC46zQ59lY42tdsO+Q2Y2DQCkazjwZUccSz/Xv0cCB0COAlYCaMJbJ?=
 =?us-ascii?Q?D/wSSOcmUlWurVyacChr3CzCdvn4Ku7/a8l5wJ8dUYFM5i/YuKnuwVluMOLu?=
 =?us-ascii?Q?m4+4wcwwWbbiBoWBR8KVVqJWURHhdTn2kTeNqRTEJXUYMUTzeq/4Gc+v3aK8?=
 =?us-ascii?Q?Jn7FbHxBN87HWDCLCxVVPgHA5Ip8bz5v369Gy/StdjVHYgrZj1qraKAY0gtH?=
 =?us-ascii?Q?iMtpffvm1b1BJVYXEcPPPt1av35CG01q7OiUJYhzJiRmNIIFkKFKzr+cM4Pt?=
 =?us-ascii?Q?fmVHjJqVpdY4nEmwsXKkXuyZu9EwFoLpXDdJm8l+H5ZixkQUtjotAb4zju9p?=
 =?us-ascii?Q?agNFp6fl4O5x87SRpF4UxFAiCGv3sfxmI/Fd2PDfymFnbJ7qA5fupuuOggok?=
 =?us-ascii?Q?ZNFopx5C9+NxKUrGGzMw1FOakxJo7398lTm6GqQ/crpffjGEy0J1eS3rw/Yl?=
 =?us-ascii?Q?8E8hEVdO0elVrYAx1aVh8nXckUtL20nU12sONBo1+kIgOD4ozGskxWLAl6hM?=
 =?us-ascii?Q?+F6Bnk8hKDwihTguCwItdDJnk2J691VeU9/mf+kdQlDSPdIcFfkVW9KqEYjS?=
 =?us-ascii?Q?T7eJwpifVExgrzSLvTEnCCLR8KMR8yrkBVtLrWmcqT8qZoNWxPw5mRS/KqCp?=
 =?us-ascii?Q?N2Luktd9YXBUFVDAo5odXr7iU3aXSfiJcnPmE51LIXPiQmZ/zsxef8khpbbx?=
 =?us-ascii?Q?5kJNQFs+4uVhW5XGxcKjkLCzVi6aSMgtL/pQ32f1i87pC6WckU5xaRaEDv1I?=
 =?us-ascii?Q?JwmVnlFsQf/tW3G3z1Efp84IXTQ4XfjVvhV4t3ZkvKtCJ4yy5Ovf/PuplA4e?=
 =?us-ascii?Q?8tNf4sK6fAkbd4ziCI7NnIHWQE0uPNOd2QzBz4EyswSj7lo02T3rc5d270Z+?=
 =?us-ascii?Q?oCxNnFakWHp4IbcTUc7QxTp4+yLZFvQT4pOdd4Nlh0CavlEWsTirqex56W12?=
 =?us-ascii?Q?zv9NwpLypae/RqGlo4qsH0bIovVN7bu3a7iPZs78?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4050f5e8-fb18-4afb-139e-08dccdff71e7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 23:06:59.2430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mdVt8kHxOzsTJAyxv5J44bTgXiZWhjFuusf26FDTBZPGISj+7SyUjll9QuR0bZ04
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4371

On Thu, Sep 05, 2024 at 01:53:27PM -0700, Dan Williams wrote:

> As mentioned in another thread this entry into the LOCKED state is
> likely nearly as violent as hotplug event since the DMA layer currently
> has no concept of a device having a foot in the secure world and the
> shared world at the same time.

There is also something of a complicated situation where the VM also
must validate that it has received the complete and correct device
before it can lock it. Ie that the MMIO ranges belong to the device,
the DMA goes to the right place (the vRID:pRID is trusted), and so on.

Further, the vIOMMU, and it's parameters, in the VM must also be
validated and trusted before the VM can lock the device. The VM and
the trusted world must verify they have the exclusive control over the
translation.

This is where AMDs model of having the hypervisor control things get a
little bit confusing for me. I suppose there will be some way that the
confidential VM asks the trusted world to control the secure DTE such
that it can select between GCR3, BLOCKED and IDENTITY.

Regardless, I think everyone will need some metadata from the vIOMMU
world into the trusted world to do all of this.

Jason

