Return-Path: <kvm+bounces-25567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60EB1966BC1
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 23:57:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8612E1C21E04
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 21:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 508901BF800;
	Fri, 30 Aug 2024 21:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Le5GyKV8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BA817556C;
	Fri, 30 Aug 2024 21:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055067; cv=fail; b=JUsBM+IMw/fVjx9NhK5Va2tFexggrJia0//fC8ARSTh33GFfnTFLfyOpo+f2414wEEJ6R8LQxfp1I6LMLWdb/W6gOqRQzHCSfscxObiPTqlpHer9yyx36N9ECrdmusEsoxI2N/dCrS8TPq0K+ptFEkZOcODWqMJZrKLwSVDKLrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055067; c=relaxed/simple;
	bh=+5nJ3lBFFmMSxwHSfM+KYxNnQExsiWj9N9biHkOJHvE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QTFZcDWarz6dnq2dVeBvHGSiFNzmql9bmsNrbpkPHtdlN6BgnyDEEXcRQp7bphIhzxDouFlB8+n1PWGsDxAOvGqlJ+rFN+cAeCecX9VOklI+oAweZF01Yb9xwIDvOzcezRZ7q16u62Pq0jvaPR83KXNrjwmoDjnRdRpOPQVES8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Le5GyKV8; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725055065; x=1756591065;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+5nJ3lBFFmMSxwHSfM+KYxNnQExsiWj9N9biHkOJHvE=;
  b=Le5GyKV8U1kbvUIP636zVWqf2rv2FDKnaW9ERdRHTnUmckYZ1rOq8oQd
   mP6btxhxiO8MtZqSxlZHa0l+nVqoXZwTtoUml0pplglttOPLD9iYONdoB
   2rN6nDH+7YegQHOz4IXeNOZ41I70WeWczF62HE5fOFN5X5PHKzj23Xq72
   nqX5urB7ilE6Uj5IdgWPzyXfvL4T42X1OrVsKRJ5BpbhAA+Jnrs9r4i2P
   rOena/+4RCIRDD8ol2TGSWwaUDi72CtjYNh7Vy95kj3Lq1Tv5sQpcVnwX
   pJqXDc8ZqShmfKoCei+kOrJRnYkOmU9ntsCuO4GsF/dhLgnBkPhOs3Nk4
   A==;
X-CSE-ConnectionGUID: dLLUW5QcQBisIIbfmUU7Ug==
X-CSE-MsgGUID: 5WZ/hkGsSMOXOECH3Cy8DA==
X-IronPort-AV: E=McAfee;i="6700,10204,11180"; a="23850703"
X-IronPort-AV: E=Sophos;i="6.10,190,1719903600"; 
   d="scan'208";a="23850703"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 14:57:45 -0700
X-CSE-ConnectionGUID: IFLNnV2+TrOZQEZPhlG6Cg==
X-CSE-MsgGUID: f2AOQppQTBeZvSy6a6veEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,190,1719903600"; 
   d="scan'208";a="68422509"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 14:57:44 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 14:57:43 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 14:57:43 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 14:57:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P+UsvX39rhQVAN/tNT+u54rijEPpkkjLxI0W0rbJ1qMUhbIcZNGauxHsvfmq41Qu9mEnOEf/VKw/LccRrDLeHAscbbyb5sSjkEVTMCfWp13psOkR65R29qf91zjjcGB5c0gQ3+GaXN3qe8w0V6LvM2UWgwQ2oomG187QtuEt9wsm95lDiNzxkxYxV0xicmiVTVco1kIixg+4c3fdVH3v1aU5EOszGmTheuiif1fIG4GNh9+n7nzTdC7GV2d34AqGP/b6S765nEigQr28uLdiJYjw1jndrRX56t2GW28mznW/S1rWwonnT045LKwhyFpV5PZKeX+t7FVj/Runlad3gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tWIDR8C7RUyBpbFwhPd4E5pFKABUL92N8+hvz1OMNwQ=;
 b=b8QcttedmGHGpi92Bvqjipilu9BzU4f0suxn7SxXyV7GQcAYYTVAmUFfCDx8JiKO/MMY4ik1YrHqXgZXsZ/7lODK5hWpZge/WoMQS7aMaJnzI1pOuNXihXqhn3/QcvGJ3UrAh09mGjr6sHvdyc09k4zjlM2PQx+zFw+9ACkgT9EamytVtKKbp5KMgOaGdrIhTlR71msD+ZMpt4AmlXHdhLmqAqISIxQKuAprHTjpTjdG9SEldDSNTZSV+o3f33nT6F+YPMGvhfs1uLSez+wgfgHEorUtUjqtOGHN42LyYcVgBmrXAXfxQzYJAnFIc2v0EeQmEn75PW3tiztUfrJVqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN2PR11MB4711.namprd11.prod.outlook.com (2603:10b6:208:24e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 21:57:41 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%7]) with mapi id 15.20.7897.021; Fri, 30 Aug 2024
 21:57:41 +0000
Date: Fri, 30 Aug 2024 14:57:38 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, Dan Williams
	<dan.j.williams@intel.com>, <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, <pratikrajesh.sampat@amd.com>,
	<michael.day@amd.com>, <david.kaplan@amd.com>, <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 00/21] Secure VFIO, TDISP, SEV TIO
Message-ID: <66d2405234b9d_1836294c1@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <66cf8bfdd0527_88eb2942e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <6cd62b80-9a8d-4f01-a458-4466dac6d27f@amd.com>
 <66d1072ea0590_31daf294e8@dwillia2-xfh.jf.intel.com.notmuch>
 <fd8549e3-c2b3-47f7-b413-3007a60ba82b@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fd8549e3-c2b3-47f7-b413-3007a60ba82b@amd.com>
X-ClientProxiedBy: MW4PR03CA0311.namprd03.prod.outlook.com
 (2603:10b6:303:dd::16) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN2PR11MB4711:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ec37182-0403-43a7-ee30-08dcc93ec527
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?F55EbLprGZvDQhcqvJQZKEvFJIsfY+62i1TzjLGDb8xsHqpwbvdKim9YeNte?=
 =?us-ascii?Q?8a3KDfwRuw+Hb9yn2R6hDfHOxG27IxzN62PePnBKPKKt29mrnxmCE+sWMJBx?=
 =?us-ascii?Q?GOc8m8nlbh7Cm5Rz5dECR7d4oENiSkuU7SWxscmL4fmPIQaOGBmzWM99rh3U?=
 =?us-ascii?Q?t6DqbwsF2XoVv9HKicAU0A7+aoIdOQL84sT0GKjLyn3pBuR4EZqml/XCXLCr?=
 =?us-ascii?Q?47gJq0mzH7jiuf/t3mthKpPB6ivZjyM+akGWR7tVQ0AcFNX0rVLVHG1oWC6m?=
 =?us-ascii?Q?/4uE9m2LE9FG+fQ0PxcM8OXlgr5fmV89t2ktrR0sK/LvY6pkAkrQZfh6p24l?=
 =?us-ascii?Q?4PZv2PrwahO4oQ4mfRal3IiGWso0MRJLDl43softh7qtGmQejmDLy28dvpFr?=
 =?us-ascii?Q?j56IEVFvFPU0NC6neZbYPB7Wa8QGSqRzAtnjirvtu2n98v+68LSxHBwHE/A1?=
 =?us-ascii?Q?b8mt+0zJbM7HI2lVJwlSNieb2f7C+5OlfBVaUvVBRSXFXHUP30g8LEOvZcyp?=
 =?us-ascii?Q?iIYQQZWaKEmJp4GZn6UuOCjUwrT4cWRC4/aw/RBEd1cDL0YU4tsPQWuBgCBs?=
 =?us-ascii?Q?pX962buzGQS/snOGkupPNgIY11qikycrnwJSM8LO9ky4hjZNhFU2yuU19iKb?=
 =?us-ascii?Q?5Mu55zU6+7U/UBIfLKo+Smwx5y7A+swjCZobim8jdxAYhc8rlzC5WVcySZ9P?=
 =?us-ascii?Q?aozytTGSkOfRdpbiX9p9qCFyAk+WowMR8a4JA2LCOtdvWbII4L1LlwNg8FZb?=
 =?us-ascii?Q?uadQvhJoi/MBiMm1su1bv9+GoBYsITv/sjqHMif+pQvVod38qsGjIRKjV5Gk?=
 =?us-ascii?Q?bJeZAG4GdrSOibeNJlwKk1CEspLlhRbS6F/YzPtMR6fBR8OI4G6Hp9z4cdgx?=
 =?us-ascii?Q?Y2q6lPTM49ArXpAz5CQ7o5EDt1Wd1pfI6UAqFH44Cvpt3J0iyO1oHI6ZTmNu?=
 =?us-ascii?Q?vBe7zgOvnE7WgVxIc9kewYc/gVDpXOuR3MEVYMhOfJZK0jChc2P3M6Vhw+Y8?=
 =?us-ascii?Q?l0+FWJeohTrXJAR0k5vu8NOuNWtiQNu6qjGEXZOYJQHIgkHE3d+QGBhflec1?=
 =?us-ascii?Q?Gb5qeAYEdBzbd2jurUA6H2meFa1aYEDCxCsVjVuCLB1xyN9qQCF7/VtYhLDt?=
 =?us-ascii?Q?DsTQGWNsvv5Ns1yDSNp8hI1yoJerFCnTydS5ZQiIoq8/zmJE+hkxIBCVEUpi?=
 =?us-ascii?Q?xOYmfKKOYjSbTh9aqJr9PxM0BsRSuLCgKXnjuqT8R+GvOte53JORrG6wB11G?=
 =?us-ascii?Q?oQs8T/Mb40yNIkNXFzwhLHmWzFsypCaewmXfDVdClqva8pLGKKPSiaBfCvcL?=
 =?us-ascii?Q?qQKaLORBm8orfV5t5571dqhm3UUF73quH5T25DqgaM4ab5IbjfvScW3xSVy/?=
 =?us-ascii?Q?NcAzvuM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yu8LwEpO23Ej14D1LtZoTiT2ZSjl6OEB88wCq7hSlON+eTi6/tyksFQP0gmO?=
 =?us-ascii?Q?xfrfJwRkBdfCuWie9eVLw1BbFmkuvsI/VWiwxBTE+IOsCqbfMEt3uH4ltiXx?=
 =?us-ascii?Q?LdVbSQRqv53WNHRQCFNsdNbW/xVfuhy0u4NZ3iDwNChHJqKJgUGZM7HEIhLN?=
 =?us-ascii?Q?X8qrWB+Byd/PsKZ5JDnh+ltsKsZSb1jzaT0pyHFlv6rf5uImqxjM7DZxXOfW?=
 =?us-ascii?Q?7pIS4ES0wLyj4B5DdPGsJoGkUKgADZlLLKiYiOXVovfey6v4JJHWPdl7/DN1?=
 =?us-ascii?Q?/f6+HRahqnOLGFFnPul6ziwCvkLynDkDrY+HhrPZAGKoEbN0hsQLwlAEIxAf?=
 =?us-ascii?Q?A7gTcxrcUN1bLMW0VZ5p5VyQbHgJ0Pstz1DXqPjJYaMnbnLaCVFiJQhF3LPv?=
 =?us-ascii?Q?0xJlC6GNRFEA7vBHUed+cqJd9oLYgabvSC0jmT2K/PCqMeRQ6E5sVf9nZh4D?=
 =?us-ascii?Q?RfyXyP2xQFEmT8eHpzt1a7iEeBw2v/VcoEVzzIBonpKJDa+jJXQe+pd7Eeif?=
 =?us-ascii?Q?CF5Id12wWtLxpi1Y32griuYdDdS+chnp30DIZ9mXunUfLYl7B6Jweyx3UoY+?=
 =?us-ascii?Q?JC7GnfFaOuSveW2y7YcMec39QtKX5mqm8CphsyjEigV5MEd1ut1Ogx4LPtjW?=
 =?us-ascii?Q?U/ZbV5nPxS+gJ9oW5cMJeFL1t0LO3X57LggPNHO0qzbGwHQ+NzZW4o8r9Daj?=
 =?us-ascii?Q?7EOwY6rTR0fwQ1Co/6pvI1jPQGgJBm1wd60fEZvj02K0MpI6sIZd9+3C3PCz?=
 =?us-ascii?Q?QZicELRoSF7nXMmb+newmYfkuUYjr/7VeGdyRI1cjhTQcwJ5mhZmkwMX6RTG?=
 =?us-ascii?Q?DaPv7OdVzR/xdLNdNNlznmKSPMiFE6Cw63P4viReQY4aRD6GIF/9DdsF1y7L?=
 =?us-ascii?Q?dRHeExDTgN7fGL2qv4go04PzpLLktnNRyTUXmkzRpftzqHLP6X1CiJNKtZaP?=
 =?us-ascii?Q?czhlej9WiizgImY9dI7dx+kLUGav5IFkbtiVFzWSgSYvHSvaNOK9kR3mH2WI?=
 =?us-ascii?Q?snQ+I6SLt8xVLDNi4AijOiUakdr33PYMDtgmgngVPNN0WqDXlgQ2pd8U5zb9?=
 =?us-ascii?Q?ZBq402jkI8mVtBn3lWsYiBhqtggqP0tp9Kn0z1YJeqUfm+t7NpF7cY3G8R+c?=
 =?us-ascii?Q?hDuoJdBZEAyuAHD7cNh/sy0eQR/tsWmw/JFcSdc+2CZiYAQAW+qtm+I6a5Da?=
 =?us-ascii?Q?/kiIV5YwTWcga6AZ2kUSbIpyHN7cxCK2Zm1jSaqETvyLxpp5JjopqGdo56zi?=
 =?us-ascii?Q?Rn7APhzhLcrh/BAROy81WODXmp2Ngms+ZlsRp9F1X92GGSryos41fRqFqSyJ?=
 =?us-ascii?Q?i10enyC1J5BqMiSBDxdI0YA+Awpof9T7GW7g2tVzXZe1f9m/1rNEWWOoU0bv?=
 =?us-ascii?Q?a+VVohvjOXhe15/cAictNQZ3LbekXe97aV0erWdAVt6ueZcIidS0MeyCuiUA?=
 =?us-ascii?Q?pQn5eEp0xFdn8imxkXp+0wb8Xge3BXo4SIEk3nCxLqLPH/qNJQ5onAQpv9oB?=
 =?us-ascii?Q?R3Ml3hnmbLnhJ4o/QWXFeYPz3t2uVWF15OVlGqz3MJh4gcC3R45WdCBbZUD/?=
 =?us-ascii?Q?H/tdtqjiow7pPzjF2QCYVaQvy/FNX7QnprodwsrVrat2G/aIZ3uzFLjC058C?=
 =?us-ascii?Q?EQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ec37182-0403-43a7-ee30-08dcc93ec527
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 21:57:41.3634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJIn2fzWmSclejN4I560050kiDKo9+xBGLxYiL38CEeSYHXJbx/9xggnY2JQrk3qzSYofQ/WGzM6lF2FWI7dD/8whzQNmqzPWq7Cdi/45/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4711
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
[..]
> > I thought existing use cases assume that the CC-VM can trigger page
> > conversions at will without regard to a vTOM concept? It would be nice
> > to have that address-map separation arrangement, has not that ship
> > already sailed?
> 
> Mmm. I am either confusing you too much or not following you :) Any page 
> can be converted, the proposed arrangement would require that 
> convertion-candidate-pages are allocated from a specific pool?
> 
> There are two vTOMs - one in IOMMU to decide on Cbit for DMA trafic (I 
> use this one), one in VMSA ("VIRTUAL_TOM") for guest memory (this 
> exercise is not using it). Which one do you mean?

Dunno, you introduced the vTOM term. Suffice to say if any page can be
converted in this model then I was confused.

> > [..]
> >>> Would the device not just launch in "shared" mode until it is later
> >>> converted to private? I am missing the detail of why passing the device
> >>> on the command line requires that private memory be mapped early.
> >>
> >> A sequencing problem.
> >>
> >> QEMU "realizes" a VFIO device, it creates an iommufd instance which
> >> creates a domain and writes to a DTE (a IOMMU descriptor for PCI BDFn).
> >> And DTE is not updated after than. For secure stuff, DTE needs to be
> >> slightly different. So right then I tell IOMMUFD that it will handle
> >> private memory.
> >>
> >> Then, the same VFIO "realize" handler maps the guest memory in iommufd.
> >> I use the same flag (well, pointer to kvm) in the iommufd pinning code,
> >> private memory is pinned and mapped (and related page state change
> >> happens as the guest memory is made guest-owned in RMP).
> >>
> >> QEMU goes to machine_reset() and calls "SNP LAUNCH UPDATE" (the actual
> >> place changed recenly, huh) and the latter will measure the guest and
> >> try making all guest memory private but it already happened => error.
> >>
> >> I think I have to decouple the pinning and the IOMMU/DTE setting.
> >>
> >>> That said, the implication that private device assignment requires
> >>> hotplug events is a useful property. This matches nicely with initial
> >>> thoughts that device conversion events are violent and might as well be
> >>> unplug/replug events to match all the assumptions around what needs to
> >>> be updated.
> >>
> >> For the initial drop, I tell QEMU via "-device vfio-pci,x-tio=true" that
> >> it is going to be private so there should be no massive conversion.
> > 
> > That's a SEV-TIO RFC-specific hack, or a proposal?
> 
> Not sure at the moment :)

Ok, without more information it looks like a SEV-TIO shortcut.

> > An approach that aligns more closely with the VFIO operational model,
> > where it maps and waits for guest faults / usages, is that QEMU would be
> > told that the device is "bind capable", because the host is not in a
> > position to assume how the guest will use the device. A "bind capable"
> > device operates in shared mode unless and until the guest triggers
> > private conversion.
> 
> True. I just started this exercise without QEMU DiscardManager. Now I 
> rely on it but it either needs to allow dynamic flip from 
> discarded==private to discarded==shared (should do for now) or  allow 3 
> states for guest pages.

As we talked about on the KernelSIG call there is a potentially a
guestmemfd proposal to handle in place conversion without a
DiscardManager:

https://lore.kernel.org/kvm/20240712232937.2861788-1-ackerleytng@google.com/

[..]
> > Per above, the tradeoff should be in ROI, not ugliness. I don't see how
> > OVMF helps when devices might be being virtually hotplugged or reset.
> 
> I have no clue how exactly hotplug works on x86, is not BIOS playing 
> role in it? Thanks,

The hotplug controller can either be native PCIe or firmware managed.
Likely we would pick the path of least of resistance for QEMU to
facilitate device conversion.

