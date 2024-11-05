Return-Path: <kvm+bounces-30738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F889BCFA0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 15:43:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 489F31F233CB
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 14:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B261D968A;
	Tue,  5 Nov 2024 14:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cWvSkcyP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBB638DD6
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 14:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730817826; cv=fail; b=jXQsUcdyUBtTDmlPjzEBdi8sCUBUNFau9PRFEEqezSZs9uI1WcSnw/MFa+l6Y/OFCenLOEOldQeBLqdYCa6rgP5GnrB/oHjLFexRM4ydsKYTKRO99hxD/NaSAiaefM7Sw99TCySNsDawIMmqrRY0Nk7hve76Fkrf7O2MtfSsBow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730817826; c=relaxed/simple;
	bh=2Ih1Yt3Jjj8N8om2jyTv0TRuRK2ZAHEw0aUmHIsq8tE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RXqhkjlczAlwFZEX06yL7VWY37m2teb62z5mXwLh+G37d22p91hvzoGPbBMnZMBFgU1SvFzKx/33lxkH39F07ltAuWz/xXagSgJLPNc9W8G4VkWsdybHaXPO7N2Bi+ergKyEOkOK5egUpZjimjgjnGtN3k5YymXCFgVkjooATqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cWvSkcyP; arc=fail smtp.client-ip=40.107.100.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tbjQK5dm/LUUvy4VQlcZRqVaesv3LSa3LnglVlxbXHcMkPTfm6VLKM7T0M6GDGU+TggBNXHEdRTg/khPHeGdK9Fwj3yjY1IubCc1rh1GjNrrLEmXcGFfsmdyZze3xVRLAZjUc67EuMZoDU6QAsCNZlZ1i/xNn9jZqSu5cM7eooqLajYqb8vYwSweWCcCWmi2uPHRDPis4FsR/qB3TRwy0pBABM3yAS43qWDPvzKq/C5Hz3pC6mJ+MELbiJtsl+6X9z4YA5xn+2egrg74wkpnBXteuHMnMztwh1QNUniJBFrltqpKcADmrZlEcLDb7JpbtPqDOR1e4PJewK3UvfyYlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vjkje89S9kUIqvCG/X5myjrEWqxT0gDA1EFZKDO05Y=;
 b=HxoJu1tYSTem1bGPX8cZ7H7Zuwm58ze6H4CeEhxXfI0aZGQZYKKg+1OMSJjrEBJPBUmUiM4S7Zk1R1qq6dpl6zdp/9kWWUpqvi/OOTfQ4c8GtFkOgEAENl062H4zUO2+1eREX8Jx8UdUIolvPUK9yOCT+RjMFoB8vSWiqF7YSzXK99E0by2dDwIQ5MU8kYq/dT/pySIa9LaivU+uWg51Ah1h+huN/60P6oXOTtRdpTr9UYKZ2wRgVAcJeLZzeYXG+ynsaJ/8A2bhYIX+tkpCVuGCt0UbM5KwSNsYM5T94VhIXbTHziPSkZQFvgkrpEGdO5+vBFFRl+6pDvGOL+chbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vjkje89S9kUIqvCG/X5myjrEWqxT0gDA1EFZKDO05Y=;
 b=cWvSkcyPyOPrtkbhCeXB6Bhc8q30n2mHVPngZwOTBtBnmTsJ08uDMPFrwTiNHOaain+8FvM2QVeEixsinMD6B7vPJkKcsE7GvekM/2tfjZTdhJDYr0TJqKndFddsNfxM9X3HJLhji6DRKbdk6wgAWj/4s6p37c6uWmwK9DBPV31Qu0wQ2xR/vScn1/m5GoF4lxGV6pv8GQzQ63laoP8Nfnyfu6ecYe6OZL2qHjztV5gNbWqkV6fe/SAxvBUoGhk6FKXk91mRSuPl1AhTcZsSR2CZdIYTmKoOaTQ9KvWjkKo9som/EW7+rKngiYYGEIRIV7rx7z9HDa2EqJ7NFtp3Ow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB5790.namprd12.prod.outlook.com (2603:10b6:8:75::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Tue, 5 Nov
 2024 14:43:40 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.018; Tue, 5 Nov 2024
 14:43:40 +0000
Date: Tue, 5 Nov 2024 10:43:39 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, kevin.tian@intel.com,
	alex.williamson@redhat.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
Subject: Re: [PATCH v4 10/13] iommu/vt-d: Fail SVA domain replacement
Message-ID: <20241105144339.GB458827@nvidia.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-11-yi.l.liu@intel.com>
 <0781f329-49a5-4652-ae94-d0bbefa8dbb0@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0781f329-49a5-4652-ae94-d0bbefa8dbb0@linux.intel.com>
X-ClientProxiedBy: BL6PEPF00013DF7.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:9) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS7PR12MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: 075fc945-dfd2-4fab-5ce1-08dcfda83d17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BVKuac6Hb+5/tm51RXxx/NKG1keS4EWXTYfmsv3ZoFlbQbLynGDx0e+gWksm?=
 =?us-ascii?Q?yiEl387dsRbSfcpkTp9gdSD0kW/csXLHfYENR4RvaRuqAruGjfwrDNw1ImN3?=
 =?us-ascii?Q?fsGOvnQ/KoS0Mhm5Y8vle8oryS2XxUNSeQwIi1k9YQb8qihqJrD0t5EAQc3N?=
 =?us-ascii?Q?S2yHpI70ILXx8KoyjjJOwgYLZFODGXC7JPDZCTXLN2+oiDQ8IhS9WvAcyOa9?=
 =?us-ascii?Q?bw89zE3VptQEsPhemISuR0uK9RZJN6VF2ApdbWcuNrISSqpLk53aZdgwOIRd?=
 =?us-ascii?Q?Xfp08/3PpS2wNZHMQEaDNrbhin0dPOml9X+QFGmcZ3DMyMQajVwCVU8W4IJn?=
 =?us-ascii?Q?aj3SL0JToo9zQVlmK0fvH8OF0SPoBx/FkkemcE0YGuI8/3Q30qI6+UoR2KJ/?=
 =?us-ascii?Q?3PZfUjlnjFHYr+VdItFtg/pjAAU/jivOt5Ln5uIkZhN5uyL89r0AZ/K0MFdM?=
 =?us-ascii?Q?JQyg9j6UxOOP/dv8szg2gmwyPRzLSLrH+0T7yngFsenKlSNse43du8R785C8?=
 =?us-ascii?Q?e51fhQCfYFNllFqFZLaFeKehNmxOyHEtnUTveTQMWkkQZLgcBhf+H0vhCmT3?=
 =?us-ascii?Q?2z2fhH7H8isF1UPBK/o+8MwA169Fx1750/ZQUZeYy+t75F8KKG79fFAxFRxv?=
 =?us-ascii?Q?m37vkPvYvHOqrsKy6C5MO+q4wVtPMuuN8cW0EMp/Tbee+01bvgvrly6/4maG?=
 =?us-ascii?Q?7xZUab7Xlc+rEVs6lq2RoYalyh9un1F2KdE2H+NSy49Gyh5Q3tvAOWPkW04r?=
 =?us-ascii?Q?HLcCUX1T59h6+l91wuDmMaNu3OPss8rKyW3O2vENAKmhPD06lEWVPB3g04C+?=
 =?us-ascii?Q?jYTjW3oYFLX7cmJl7J+6Cl0SPq0AvL27cj0j2ZCCO419kb6kjg0G9zg3HaGb?=
 =?us-ascii?Q?pwlX2bfnVv2l/esCcxJuvq6c0rqXiXb5suSCa3RADiUSjhlkvktsdorje5XN?=
 =?us-ascii?Q?bFLCK3W8q5/Y5LdP7L9HmqCqsDcuGDsrd5q4xpxkPOO5zkuW1VXWrc3wx/9H?=
 =?us-ascii?Q?SWXLUJkDYICjP7T4q11EV4qqdVjwKjF1V3ZROBR/+nxzdCO/B2BoyfxCiV1N?=
 =?us-ascii?Q?/ZYkJm586N9RtvVDIfiYXBDHKihe3cH0z5gh0L6tBc2MCb5KmFePf5qbd0Dk?=
 =?us-ascii?Q?TqpXI8L2AVS1/JVjphBpLJvaJCOom7xbomhyshTrmtiOdbMr4RulxUqEA6mf?=
 =?us-ascii?Q?J8w+ll+qzQq1myIlJqI/UbC24gRylFbeKYOobiRWzUHl3NA5BTqBrozXN8+c?=
 =?us-ascii?Q?kQOB/hU3I0+7WZDfZCtGsQDJe8is4fxcdxAANzvizDH9DeDDPjaO6mTw/MHS?=
 =?us-ascii?Q?11DtDOtmwlscr2W25BOJGXRj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FOUH4/MYSG2RIJ7rt+P3/FfVLxchRM//qNUWdVBscPWuTmJKr5zICnS9J7yT?=
 =?us-ascii?Q?tz+RtbrS1cMNqkxDDFKNRfxSALlhVupBF8F9zqucQsam5jNbG00b6oEXovH0?=
 =?us-ascii?Q?qMfwV/g0hwn1dO4Yx2iRcoi1gdTZY36730W6gq5zWCyELQXP7w+bL+1sbVjQ?=
 =?us-ascii?Q?hwVed1osHpTfk12WK7XRzXjsz7d8jQG+C3Y3WxlAgpVsCta0kCoOoAvyfpPc?=
 =?us-ascii?Q?FgIFrNu/lKBHnWVXK7P89W/rSHszCON5ZIe592U/2dfJTn74I79I6GJEoHCq?=
 =?us-ascii?Q?eiaDrdBZgFaCSWMTNtOOIB7l1hfa0F1fMRt5ZkMAlbSEG4ml3QuwEHF2eGBP?=
 =?us-ascii?Q?Rh3IkogT0o4NQBfOn8rw0MMhkDb+lvAJEA9eGGoz0JxnrtK1R7146+NSGDVq?=
 =?us-ascii?Q?RNY9gINb4FoxIZcSgD4kkdIg3vcUQEBFs4viBDxXox+1tqPZH6Bj9zhgHbD4?=
 =?us-ascii?Q?Lf2skNdwbWwastTvGTqDO27ZsJ/kV1BkW981go9t0S6CLAq9T6IvghviSDY+?=
 =?us-ascii?Q?05GXp/l3r6WcX8eV4R12Bt69rBzVs8rNfNt0VbXhjsP1bZATMcwIJFGBm//o?=
 =?us-ascii?Q?C1zP3B1A3N2Pz6E6acHK5zeabv7oh62aKZ1DySZRgb5Y1FXZwGI4Y57suTeN?=
 =?us-ascii?Q?H5wuoicJ9BEd3c7qd6po/1UG1J13zQZH9aEJnSRcvHCGdO4XMIqVeFGVT8ED?=
 =?us-ascii?Q?hhG2hCAr4UvailY4ioPMXY3bcBYAkBuryiOI88qd1plzVpBYtMsAwfNlSpPK?=
 =?us-ascii?Q?GmdSOK+C5GIcPKSTQwkqV5QFicv2niOfxvzYeHWo2vRAzA85Chi6DacP5tVN?=
 =?us-ascii?Q?bS8eHc4+vbYmNhtXWt2YE3O7ihogvNDue0y5A69BHhHtXsG+3zsYryu9O/bN?=
 =?us-ascii?Q?u4SonDS/YizM0czGSvNwQcFLMH4Yjz7tA2qs1FpGjxV9VbA+3ikYPH8fZfbM?=
 =?us-ascii?Q?lGKoUGMMaU8k5GSz89IzWNUPRI2OMrfPSFeo7FDWsuDB1yHn7SZXsxHR4cci?=
 =?us-ascii?Q?4kC9CX4WR5Moxn53YmrigyK4CZtgvjOfMdTLOleAi0zDK+d8Ivayr7ZnSyLg?=
 =?us-ascii?Q?ftXZYPmOJa/IdGFlll16Uiyf+fvPN8FsFEd7LLRL2Zl6FmJRMoVaERhCqJ2z?=
 =?us-ascii?Q?ru7Q9WKEehjk6FQe+n4Cs80pbWKawEJ1oA8IEZF9tSL3jvGxLtR+bhCnHDBe?=
 =?us-ascii?Q?rSMbniFAOfugNxADCHV4NiGiEc8IENt6hQSilekfK+24DF8CDWyjWG3MQp1I?=
 =?us-ascii?Q?Xk+XkWqhq/TwMLFZf7ro1SVdO23Q4IxACjsKbwq6QMpBFbQgRRGRy2rvk3LJ?=
 =?us-ascii?Q?aDSto8ajs4w/DBfsfSdLGTgEJgm/0XfWxa1PODK3TExoqBPXFsW32FMS/b4t?=
 =?us-ascii?Q?SvCod9khup0gIJO8KNSpkABEKG3Q1fKQA31fxKrRSPHfBeE9qiCZiAeLLMkd?=
 =?us-ascii?Q?aZFwD9RYu6YXbize3BMxbZnHSgGErN7AQeatiyV0EocIZp2vrVP3ZHouDSHS?=
 =?us-ascii?Q?v4ncbvbcofZ7OI9lhGcWEX/d37dpHLNWwhHOV00Ex7ehur1MJe52fntx6i4O?=
 =?us-ascii?Q?bJ47aGRILYJgUToBugjz4bNzjo2/IpP6XPIfUVCo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 075fc945-dfd2-4fab-5ce1-08dcfda83d17
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 14:43:40.2637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: couzwRVqcu/TVhJb/phFNKEOyK8RUSJb7IlNYKyv1LTxYQZLzsI41h16GwR1itEX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5790

On Tue, Nov 05, 2024 at 11:30:25AM +0800, Baolu Lu wrote:
> On 11/4/24 21:18, Yi Liu wrote:
> > There is no known usage that will attach SVA domain or detach SVA domain
> > by replacing PASID to or from SVA domain. It is supposed to use the
> > iommu_sva_{un}bind_device() which invoke the  iommu_{at|de}tach_device_pasid().
> > So Intel iommu driver decides to fail the domain replacement if the old
> > domain or new domain is SVA type.
> 
> I would suggest dropping this patch.

Me too

Drivers should not make assumptions like this, the driver facing API
is clear, set_dev_pasid() is supposed to make the pasid domain the
translation for the pasid and replace whatever happened to be there.
Ideally hitlessly.

Good driver structure should not require caring what used to be
attached to the PASID.

Jason

