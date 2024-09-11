Return-Path: <kvm+bounces-26599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BB374975D65
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 00:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D2961F23757
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:52:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15EE11B78E3;
	Wed, 11 Sep 2024 22:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TNtEo9Uv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF2015442D;
	Wed, 11 Sep 2024 22:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726095139; cv=fail; b=HMUdpxW/qN4k+AJLD2i8m9fTREHGsED9iA8sPlmrZHseGd6HC/o7qgPo3264Mq7RT4iYaBqqW76n0EA68N8Xw2qpsKVIJn1+mWh+zy9RH2RXeicbg3UoO+puqyzAp6nLpmdPQq8sr9K8uMmcX/qEX2BXJD15rCwKWiIuC9pgQrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726095139; c=relaxed/simple;
	bh=NwbgQglYc2HHJTSROXtXKE+oCJCvuuUGWdYi0ukDHWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mvOZBZqsvwOHmOKojoehItFrcK9YnWrsSA2CTVgwmCxOQ9ANQNnakeJHlQukerRJfohUgITfVh5vs0rW8Vy0UwGHYIy6BjvEX7h4AQPJQSfGhu0CElCwLzeN+XSEm0BYtBNzeJFLBxjG9t6L522BikT1Z3QE5yYQAVgtxyZYGFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TNtEo9Uv; arc=fail smtp.client-ip=40.107.94.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ae1e0Z6vAFLzpxJym6ZIE57BT32l12WeqRR4ZAwMWOlVl+04tNQ6v3HK+p7e9uMpCpJUoxj4Kau5ax2wGF098h1aSsB57I/fNc1FBWsib4pH+velGTZc+LAuYHDyIgjd7wx2RArNLCnAsv/g8YiiwQzShoSEXiJw/i+AOZD/qqx1h+499iPE5DjuMF02Xenx5aCYrQ3/bs19a3TpkAeq+spMIgzwCPOPtqsTZcgFh+2JqE7XbEUwvhpSS33woo4aEabeSyvS3AP1O+1aI5aI9tPsLBvrLkA47Wvml3m6eRdLIsxRhZfb9nPFTR1BC+UmKbePEPG3621h+dVRREmYTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2r+klOB93/ojT3nj18nNqYTkhzxDm/hynO30kLimPRI=;
 b=mYUEEvaA+AoyINu2x+ouDfrvAVvOIhsfYFwNIP93JZPsWUCXHhHikyC8QylBRq6wAlvZStFfYRfsWEmEKxA4hF/OjROlH8zTeYTC0YZsjgoydg1h2ozSEMpQdwZb31GUoGPVG018mH2y1yTsv/vJ8sdJJXWTp/VLN+pbl2xS/iCZoHq5el+TB2cVhuHDCOxcZPswwjy9hSFi6TrU49vHCZCsMxmXg9EiIw0y/tHZhT1bobw1mj3UhzkgSDHSNCYDhUR2WEbkSbjRYlw8GkKGkC2R9FptEgQjFSnZZPsHOyWSim0OaDkAHG73KCdEg7QSunr16+w9oedvqQyeCv/ulw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2r+klOB93/ojT3nj18nNqYTkhzxDm/hynO30kLimPRI=;
 b=TNtEo9UvhFq3nKdcNcc7dOILjlPyIcVjdC5jEgAvIOOmV1jfVZ1Lz3h2oPVueMRyeTNFxcXgslxSfmWpADgd1/YrdwVJJsg27eVWhyv1AUxE2imt+om9YP+zTcGOVLgI7ntVWhcTXZSPkkMCIvNAoeVFI/hVOl+GtGiy2mhhtRbccocI0cBgEpZYyhyO9cvqEKjVguzV9IJjCRP+Razp8LZKdGSZ77mHodHlw4XZya+1MuY7fG6YMy1ZsBe12cDdpfbegIUV1jji3ASoWhn6mb9Zw8b7KnUtPiE3I571yrnxHuEMkFY2c4A+nsowZG6A00sY4tkOC/eriA+ZAyVXNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6958.namprd12.prod.outlook.com (2603:10b6:806:262::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Wed, 11 Sep
 2024 22:52:14 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%5]) with mapi id 15.20.7939.022; Wed, 11 Sep 2024
 22:52:14 +0000
Date: Wed, 11 Sep 2024 19:52:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>,
	"Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <20240911225212.GO58321@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <85aa5e8eb6f243fd9df754fdc96471b8@huawei.com>
 <20240904150015.GH3915968@nvidia.com>
 <7482d2b872304e0ebf0f8fe7424616ac@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7482d2b872304e0ebf0f8fe7424616ac@huawei.com>
X-ClientProxiedBy: YQBPR01CA0084.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:3::20) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6958:EE_
X-MS-Office365-Filtering-Correlation-Id: 72eb34a8-481b-411a-997a-08dcd2b460d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cloXdKiPrtzLbbleewnYD9OGtwpZ1QMi8mmn88f1IZxG+cNwWDIRbBw4J6JU?=
 =?us-ascii?Q?8oZbGfBGJVLI2+0BTH2FAZ9GxGDDVGei8MC4FA53TzNJ0Y7NxdssmXwKMbtY?=
 =?us-ascii?Q?4qY/uHs5BmZBcIG5cGe2PZMTt1zYyWtlA9aUUL1mK3vaxdKgMz3s46lOpJIZ?=
 =?us-ascii?Q?WmLrzooWjBOLyA9JAxFgaYow9Dij82seNeIfcuun7rYBcmeQZjAUOu2zVUl7?=
 =?us-ascii?Q?rJKsk89zqRQiKKkghXIFgTyJNvQF37dlGWh1V7rEjLZNnfgzn8xaYuBgsuFa?=
 =?us-ascii?Q?9kXT9IAbmlWizVif9Iuxt4LVb/oiCxT0LE51SKngN0us4ILELjnC5i7rm1nE?=
 =?us-ascii?Q?b9HkCRM4Ehb5ezEt80xVhNFV7Xn+n6RsMkxt3vDqN263JCeyVhe3U2G6EOF9?=
 =?us-ascii?Q?df5Qx7zXTU0WI1B5wPWYKlWETZ0tdKaNgE4UoDUcEn6eOTyBpjiJ2gvfPgc2?=
 =?us-ascii?Q?Hh1pgfW1kq2WVWGncJ5exnP0Y9YawMKbkpGtwHcfR9hdSUwTKJDrJbUqgU/a?=
 =?us-ascii?Q?1sGXIcr8lbrIFo0ZVlefRubAtFSbMLG11Z8wToOq4TVeA3QOz1sdfga06oAH?=
 =?us-ascii?Q?D4OO/C0Mwp7mFNkUeYJArVRy9sY9Mx6H1gdyLcDaoGb4TihKBkc1aAi1GwTU?=
 =?us-ascii?Q?NWBOnEdbi7MkyYHNsSZUT2C3A7lPV8h0ndhSHOIkVt2hiSuRWSz45Dnvcu7q?=
 =?us-ascii?Q?j7Ig4QcsxnJIaaTYkel5DE8PBuW8UPoFDoNNH3Mn4m7MwAtQXrfPkn3Z8TYN?=
 =?us-ascii?Q?ZoJS2Kk8tNUhQw0lcBMoDQMvmLVOSRkuMUF90fxk+46HPu+qkkfQcltWJy3P?=
 =?us-ascii?Q?4/yhxZDkv679MCURKqcD2eSWLva/z/zbM+xepSFJbWXrk94IqTADmSl/A/xZ?=
 =?us-ascii?Q?pMEOF67g7MWiFF69q95pphqqQo0dMZdRq4TAgueMGnXDJFZU8RlRo0ihBocJ?=
 =?us-ascii?Q?R1CV9ZnhNlaorm7BvlKfKn4M17BxzCs6USN2u6tfwmEOR/dqGVjQqK9eBU08?=
 =?us-ascii?Q?wfMNst0t3trEn1pkHJn+BXvFu9RnMw8TFmyGgSpM57RevcsJyYhgHtogr2mw?=
 =?us-ascii?Q?hILFpMc1ilbgoDXINFdSCphmqshOWX5VJbdFnLfwXDBAq87eo1EHNysEFPYl?=
 =?us-ascii?Q?oQdtMVwblEkp7A9UXv/qW7LZHWqXYJXGih+Em5mLqhOGO3AlKpXYy2//g+iD?=
 =?us-ascii?Q?4JWwUw9KXFrg79PBmWu1D8OFAmf8pznWRW9x9vKtC7gJLZQzGC3mz0yhEkHW?=
 =?us-ascii?Q?oFd2AFHRhDkif6NcgO64vX+4T5Tb57nDXu9SX5esEmeEkqumeAHClsZ2gQSA?=
 =?us-ascii?Q?iRQyVO3XaNE3uyzbeOC3O7YYlqmAISTC4VN52AQgH+KGRw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Meb6jG8uYkbVI6qEfurYY8auDxk+7nwC0TlusKahC2Qwd++gh0Ly68LPrJjB?=
 =?us-ascii?Q?C1xDqxoNZueIR2KPfKBXnuhrxzoz1kE+S73PznAxQuA59ATd/s4q2mSOYr5U?=
 =?us-ascii?Q?3ohcGRHJWNT9+IkyhvGvLuFtJ847i3o6GZ8SmQtZDb7dN9q665tiV/7z81hh?=
 =?us-ascii?Q?dzga0UNhavkkVJWiFgBB+Gr3j2PR8KqxYD15ujRLLJ2XvINH6q1e1EgYWShk?=
 =?us-ascii?Q?1tlykH//fIOywmVvjJbMes04YzKndSTqdEQ5SkZtl/KkmvB16JCGoFz30noq?=
 =?us-ascii?Q?9OoEgvfmx+o3ViuqOnqTEtQAsEWAYtbRKEq9r3fI5zeOW82xfTUlsPOiVH6V?=
 =?us-ascii?Q?ZXXYJ9UYjI8aY8eW0sK2NSIkEz1dWKDQuD9uC1oMdx6WicU8me9yNWUuHMeR?=
 =?us-ascii?Q?ccHyBPL6N+4so3wHA7b/yi+tGoHNicwWYco1JA8MFlekwyQyVmR8p1jg2T9x?=
 =?us-ascii?Q?+nQc0bceyq/UXjaxdDaxZOVxelT8299p/BVRYp/Tlc5WpyAQIPWd1EWCjIfu?=
 =?us-ascii?Q?o3P0ZQ8JRSnPl1dl70EZ6vLdavKHNTtmkcvyBPHHo6XepAM6CxSKknBVTpPW?=
 =?us-ascii?Q?duCoDz70ULBz6A6e0phGdjyd6zp6u/Kvn4ol3o6ISNmFauE211uUQ0sw5lIM?=
 =?us-ascii?Q?x+biHIEtmzVrcGGmE+nLdyPhyKW1YBWFlDg8j2NWOJaYchPj0y0WKVCX14UT?=
 =?us-ascii?Q?jXKd9HJ3bVzM7vHjZ7FdW9G0Cj+EUgKulZ6GSJkeKwmGU/29m0az8BLp4mYN?=
 =?us-ascii?Q?R48kY+QIcajYCarz2qKWbGMAO79oJVehVeTiXt7DDsxxETLDuW9mbv7BLgEl?=
 =?us-ascii?Q?Jg6lRIfYh6QRJZRCxxQQWrYs4fZxR/3lOxKy0fFY3/I8tVu16NM45mvXDndH?=
 =?us-ascii?Q?4oXE7PI7xKUTE6C2OsEaC0zTC9Is3/Y/a3qGtA+JzKJw3wx9iRNJZX/KCAvW?=
 =?us-ascii?Q?DE1npVevbpxVvrYCvKNWRcifyAOuW8kdL3cDMBKT3CRIZvRysl2e2tWebrT0?=
 =?us-ascii?Q?EJxzFZ/cTwDXZGCSkWbH7Non2MuPIs2hliMeRjcpIA2cM8W5hUb5CfCDCYc1?=
 =?us-ascii?Q?EAE3EaBGMe+TYvRRnJslCQBJRNrosaE8k+M5VBYOL1Nr+lCAw4F0MRQOXTMe?=
 =?us-ascii?Q?QAO4G3ozphpY6k/s4aUGbwDsM74fMVAqJjW/5oc9t1rwNx1uRU2IkKaIizRi?=
 =?us-ascii?Q?ebCAdcSlEiIIguRel+k5tfzshMxmNsypfMkgR82FLMWHTvj3Tj2uUni2j3nz?=
 =?us-ascii?Q?Cddzpx5fuB2gyIR6W139QLKecfJhgOFwr2de7HBX/4ow+pw3lfDzpdhLXnid?=
 =?us-ascii?Q?dEYFzxH5XWql6UT3JRJTw7RnFHisGw74rMzxngaJYDLksWdgAmyjIUzRoOwH?=
 =?us-ascii?Q?MR1uYo18QC9EjGQyCkH0qYMVSD2/BsLYUvn+DdywGsuKmvl34OioxSCnwg0S?=
 =?us-ascii?Q?oExLjJ8UrIIfEWuphABf8wE+BneNP8absizUsyhT719pAWeXes652jE6ySCU?=
 =?us-ascii?Q?SR6hHohlpkhg7qKb0XKyZOUuSeu3qmeY57lmyKXN6m9VAYYI3oxPcv1Oj/ar?=
 =?us-ascii?Q?ExZsTf0qEKWMBHlGcDy7AnGmH37eFMTIKtP6z4M+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72eb34a8-481b-411a-997a-08dcd2b460d4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2024 22:52:14.1472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EalOJEq0WiReLjoM7lMZmrIuMSORw22RUkLvUicz23PBUTLDN1bPcxYFoNX5jV9z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6958

On Tue, Sep 10, 2024 at 11:25:55AM +0000, Shameerali Kolothum Thodi wrote:
> > Try to isolate if S2FWB is the exact cause by disabling it in the kernel on this
> > system vs something else wrong?
> 
> It looks like not related to S2FWB. I tried  commenting out S2FWB and issue is still
> there.  Probably something related to this test setup.

Okay, so not these patches. You managed to get some DMA through the
S2FWB so that is encouraging.

Thanks,
Jason

