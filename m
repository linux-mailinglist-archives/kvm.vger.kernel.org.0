Return-Path: <kvm+bounces-17847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 397598CB1EA
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 18:07:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96C1CB22C01
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 16:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC441CD13;
	Tue, 21 May 2024 16:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="anQo9Ma0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2084.outbound.protection.outlook.com [40.107.96.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082A61BF37;
	Tue, 21 May 2024 16:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716307649; cv=fail; b=Z5YBsasN7gdxyY3YS5v/01hHgx8yY5m2s+89xZ1wr+47i+Z+KhQ+KHqdjfUODfYEzGC4NP2Z8eYcOaAKrqzdOOI5tsaLTntFAKG9CkSch203MLuix3re3RuuSUiG4EbwGfyx2NA2mEsIRCDqa1VVU8FZvClgkG8qAPpP864NGhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716307649; c=relaxed/simple;
	bh=oXDJcqOq5yOT7c30V6beLyjDvoWUn7jVXl6Fzg6blqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lmC1U73E189QGBBJF3LmPt1b4QiLPKQLsd9Z5R5R0I8yqPFhmezHMrs0MgGbK9f8Q6j/RV7gmLGD8AVPP/U0MixGei8hk35T7A3lvFizFUL4kCl5bJzohad3edY1e/4ZO8vZwUnv6YvRtqIudHMBxU4fueBkARCOQH80jcWoBHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=anQo9Ma0; arc=fail smtp.client-ip=40.107.96.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3sObzLTn3PhIVIHd2Yq0RqvTzJzeV3yRlLeypcYd4lxgCBoz5EEZXxRCnmAbkQ9b9+e0fex7ZfzxpMKmVgkilHbujAKql91AK8ms5A8runQfxyeIhmStgjAAFf6VnW4t9W6l8g+dK+0vUNM+1rPup+oKFQwOrmBQU19D7zLqLnqFxvhJHjMkWfF1KSbTOTmT8Ngif2V4hsfEFFjOOYVZY7jFHWnApFtohXEzZJH9crjrN90n+l6Kpl/L8XFsqmRz8G1QHWnUP1cSU4A54TjlL6DzCqGd+EIQUyh3m5S4bxOuvkoWpH2Btg5rbEkdbRlmd23TLmwDZQLUgbIustNKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NC3+Igcayr9K0olomDpHVuN+lMHWwy96W+fTA0nscEo=;
 b=PB00midKY0rK2ahzf9YMqbU3RfDQU/HfdAAPhkq4fbz+4nFkmm5coMpB98QuSYlGPVPmi8IM0+2jlf5COu68/t4yZUwbYBifR708kozc2bJy7t717QJ/taGTqoZEHAchIGkDhohj6rWFt+3f9MmFZLJcM4mWJWwIygJayMNrwUWO6VDBxZw5mS5lYOPyi5IIGamt4tad1merwJxDBD9sTd/VPQK/6bv1yFdQTPC2DL2DvtlNkrTZ8hfSNqWZsli9BnhDd8RsV5dJA6wTFjQJDlhrdKnjSDhvBlHxX8MHM5ydOsIqCGB0AWEiIRy3pm0XLR1iM5KEu5oWyj/K1x6TJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NC3+Igcayr9K0olomDpHVuN+lMHWwy96W+fTA0nscEo=;
 b=anQo9Ma0Gtjf1k1njTjtazVnCGaajedzbwxvBqowt05b85DlGTIJzJTMah2KcAv0pljlQSYF619K+CI0qiEglyTbuT9Yx3+RA1eWzQSzaixKi3FY1L8acfJ2foV70Cw1eHtGwOB8LROmF5x1GrGCrrcz986qX6n30L9cwzbaHUtOTuWAebopbCyTItm/9qxuDliDLHT2xFlA7nnSEPrHnZ7BtObD948hMUSWV7ZjuF/xCL0Nfrt7geKcj0+8ndU/DcWOTOQzUoZ7dGP1leUVJtp+fSY9Vjaj7ldzAHUBclE+USh+tScOYHmKzBkcP2GUjwQfevrmsca8SHbXftBaEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN2PR12MB4318.namprd12.prod.outlook.com (2603:10b6:208:1d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Tue, 21 May
 2024 16:07:15 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7587.035; Tue, 21 May 2024
 16:07:15 +0000
Date: Tue, 21 May 2024 13:07:14 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240521160714.GJ20229@nvidia.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062138.20465-1-yan.y.zhao@intel.com>
 <20240509121049.58238a6f.alex.williamson@redhat.com>
 <Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
 <20240510105728.76d97bbb.alex.williamson@redhat.com>
 <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
 <BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240516143159.0416d6c7.alex.williamson@redhat.com>
 <20240517171117.GB20229@nvidia.com>
 <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT3PR01CA0130.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::13) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN2PR12MB4318:EE_
X-MS-Office365-Filtering-Correlation-Id: 03ada3f0-2e19-4a0d-65f6-08dc79b01533
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n5K/M7fZTpq7NTApTyRAawQZ6xqdut5TRMGUaIREvtOaDeCVYII7cm3Yrpl5?=
 =?us-ascii?Q?CYVKCETupmukX11cfbMAxRq22jr0h3RE+pm5iwMwMrw8yGlVexoE812C5w51?=
 =?us-ascii?Q?RchJ+cV723pfnyyxTVScxAShBA5DjUshORDvnW6u80K+t8w9jDeGuuWhmo8r?=
 =?us-ascii?Q?2zf9C9eiVrCkuRgPhA5gwRtrTHxnLCWqDrkWG/NXndqVDoxPZhEJlzXiswVW?=
 =?us-ascii?Q?hAcj5JGZ2NX0wQkt3nZmZpLK+ymmM6SuRw/bvV7I0CJwlLzQOm2rW0WNokxc?=
 =?us-ascii?Q?NMPUtK8Qq0QEj4JRnPrtc8Kzi4HWVc7aka7Pa5sdEazHlhi4c1jqsPbsgYk3?=
 =?us-ascii?Q?drw6STgZjmh5Ta72Xc3tuXqTyKLohEaNH9Cuw7hiqLVFb90xOmsZ/mzwbuhF?=
 =?us-ascii?Q?Ivx1RTayg/2ecQpm5ID5UXOCZ0SkVUE3VDosFOfyDsF1tq3eIOef1ztRsVB1?=
 =?us-ascii?Q?tZKSIY+c4BblSR+RT6Tlov2dcTWxpEnutnTYn7SMHq8M+ZhDea9ptinRUPX9?=
 =?us-ascii?Q?MacuBHF5M8+xsPG318glhMkWAscEWanqZHYCozE6d2F6KGoUDpVIRfUsyMaG?=
 =?us-ascii?Q?caKe+BP8EOJBFLLhUHfcaLB+AQcSOxXVsGw4Z4aRxZuhNgHL4JGA8OBpSsek?=
 =?us-ascii?Q?X6ZGqnjai73kOJmlKtiREtITO8bIeldlxnO4oxdUcRNSoGWFSvdAqPnSqAA+?=
 =?us-ascii?Q?guRTfLa3iyyIX7HZG+JP8p0XPhVfnycJmmqO7TjE10SLcF4DtcDRxwlhFM4v?=
 =?us-ascii?Q?KEgNTtVkHP8/LrcbbByd854jgFmb1kc/9GCThTBCmpZUweDcSiiixKsiXG4W?=
 =?us-ascii?Q?0eyFVOF5XbycfvZvGkuHwlN0dxmdzizozIZw+0jp+nnIj56rNOxz/PTyBe2p?=
 =?us-ascii?Q?ASnXrINtXtm3ACZ0tXiBMZfr6+ixSepaPfzyq4Hb31EL77rZRhW1q1WPwd+0?=
 =?us-ascii?Q?TsuE9fAFPd2NN0qhhMjfb8kYjrE3ulaK8q0naTYL54B6EgBWEgi9weFT8WHV?=
 =?us-ascii?Q?mZbiEKLVapgSVZDoq1dUgDJl+G6mY0D4TceMA+yR+BO/ls2pYcdLHBxenOio?=
 =?us-ascii?Q?olyKXo7pPVOUKxvrMyHvFlLEwAVELp3MGu1bMO1wOtNmL09c02L8x/tfxTy3?=
 =?us-ascii?Q?tatQjrRwGMV/cmxooKcgtHOudyqrKg7l7NefA9KUnv+KBv1vyaNvvx64nnya?=
 =?us-ascii?Q?hTNqRjVaxKY9VYi3co8iYjYu1bsJM1IKaI1GfDq2Ud/OfISDbN5+vD85obrn?=
 =?us-ascii?Q?Wz6BZ2+4BOrYR06rZgr3NI9fGp4qYydVyIImU/sbng=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xWmnCLUj1nFGw6BewyVgPyufuwP19wyl9oM+pe5Alm12P7ZXCWd8cZn+w64w?=
 =?us-ascii?Q?dzVimAXFN767CQcQRDMGW98tlQ+vlHpL3VXg9mcVqu1r32xkXlnDS5qY3yEA?=
 =?us-ascii?Q?rmSAK7MOuVvm7qQ9qyJO51GJRfyaRgwLc2OyM2VEcJx1dkPNC7FSn5cxjBnK?=
 =?us-ascii?Q?j2WCaM8Ptzt0B9oMxsefQ3GKi4/s4dAF/al5IIF82p/eMqqLg4wJCpCgK5zj?=
 =?us-ascii?Q?pblMCvGtqAbrKwytCYMrcQl3xT8Q8W3D6DwpEUD6csdA9m2cK+bQq+zPmYAg?=
 =?us-ascii?Q?bVZloWJ1vCQUevnnTW/+To0X47XtTrxOl5ot7OvIWy7TpO4jvzEfQsOudcDs?=
 =?us-ascii?Q?oYZqKOwfHd6UrpZBdupk0z8pocs4FBvTw1rf6BiKFfSWMTFv7DjUp989jJtE?=
 =?us-ascii?Q?kXIH7R0o5c847+L/MVReDmmFPZ1OjkGFtdToJWq5ncyAJcR8ncL7WUPtbsQR?=
 =?us-ascii?Q?ySnGVJtqsHKa63/URPacEbpKLfWVZnfBwBTGup9ooUfl1u/9+TFQDfZMjVvO?=
 =?us-ascii?Q?TTKZr8DaZfn5FlW7UsPz+ASB/Af4ktqBC6+pX347aQoTVglDG/ub8l1kiIHi?=
 =?us-ascii?Q?BvPpDJa/63fFowKeKKxr30Fyyd7ekYeaUdVvS1fkS7NdgnVWAVOkam30wiSP?=
 =?us-ascii?Q?xFfZaRfnoCKm1iF+3bhQEgwJrQ7eGY7/rz21bHDjgdgRO3w+/ZaA/qf/KjBc?=
 =?us-ascii?Q?vLhY7xcnTPmmJF1Ik3qFKtA0ZL97VlkP/YZ4k6Rx9DT/n1IGK2ZfV/2xcKhK?=
 =?us-ascii?Q?Paofk6NBJzFqIcBXp6SSqkLhk9u4FGgtg8xBrgnDyxVqVlU3k+39uFraIABC?=
 =?us-ascii?Q?Gkjj5aizTvlx8CVtlgebIPTDaHqvEfS5GcxMr1BURrTCC322ed85Gi8Nepr6?=
 =?us-ascii?Q?u8OHYAAyQ86+xdllpycucRhLOMbqZkP16mzCXcxJZu8cCOKa82vJWii66il5?=
 =?us-ascii?Q?MHGGeZTaNlsr45OvuJhximfSxpTN4beX2jIZT6A7istj3Tln6DY/0YKtI+ph?=
 =?us-ascii?Q?MoIRLR6qYr5SMErCw7foAQUbwS3Igzwafx/ElOTiYKwCIzUfHhMX26tWZeZm?=
 =?us-ascii?Q?BJE2dHiQH0L0jzjwjbTadONqsvOfmojB1zZvfFOzD9AZL66SQIxjSmkBOlC9?=
 =?us-ascii?Q?W9yn8w6OVy/ScLNg/3t+c3kOAw9LqDnFYIlDFyYBQVnZLyttQwFQKixSKSYJ?=
 =?us-ascii?Q?hJZoCZQHLWB0mGZh8JRDWb2tJRUfKp2GYVNEt3gl4qBFM4wzdgqPYvtZIDcj?=
 =?us-ascii?Q?8NVE9wdX5dBS439gw0y7o+JVBID2jzA/p/ZJHoLHD3GVrCmvZlSbLSqjJbOl?=
 =?us-ascii?Q?2rDVt5heZ7RtZ9jgcLD0e3ETRWW+a14aUOwJQuWvrzVtzuWrfknZSXTu4IzI?=
 =?us-ascii?Q?zrRkrcIaJSlqpIB2SvBa00kMHAFMky7lugdnYdFZAvHXU9rPlfztYq5t2ue4?=
 =?us-ascii?Q?9RkkK0yTk3ZJM+tNv9Gun7hQb37ttEw+Sya24JvS3bqv5g+C1S0AJ/Z+G5dI?=
 =?us-ascii?Q?L07PogWv9P7l/zWxbL+xchz1fqrx0j/4qES3kUBqomSFwfkWg+fdPMeN7iUP?=
 =?us-ascii?Q?tjkgy3viyNcqAe38bHqPl2gcTf8inVjdoNi3h+mr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03ada3f0-2e19-4a0d-65f6-08dc79b01533
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 16:07:15.7914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LofwvGrYrhqrOoecWxv3fVCIY/c8WWolRcK5J2SkibcxaEq2Z4VZDL1ee82JcqAJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4318

On Mon, May 20, 2024 at 02:52:43AM +0000, Tian, Kevin wrote:
> +Daniel
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Saturday, May 18, 2024 1:11 AM
> > 
> > On Thu, May 16, 2024 at 02:31:59PM -0600, Alex Williamson wrote:
> > 
> > > Yes, exactly.  Zero'ing the page would obviously reestablish the
> > > coherency, but the page could be reallocated without being zero'd and as
> > > you describe the owner of that page could then get inconsistent
> > > results.
> > 
> > I think if we care about the performance of this stuff enough to try
> > and remove flushes we'd be better off figuring out how to disable no
> > snoop in PCI config space and trust the device not to use it and avoid
> > these flushes.
> > 
> > iommu enforcement is nice, but at least ARM has been assuming that the
> > PCI config space bit is sufficient.
> > 
> > Intel/AMD are probably fine here as they will only flush for weird GPU
> > cases, but I expect ARM is going to be unhappy.
> > 
> 
> My impression was that Intel GPU is not usable w/o non-coherent DMA,
> but I don't remember whether it's unusable being a functional breakage
> or a user experience breakage. e.g. I vaguely recalled that the display
> engine cannot afford high resolution/high refresh rate using the snoop
> way so the IOMMU dedicated for the GPU doesn't implement the force
> snoop capability.
> 
> Daniel, can you help explain the behavior of Intel GPU in case nosnoop
> is disabled in the PCI config space?
> 
> Overall it sounds that we are talking about different requirements. For
> Intel GPU nosnoop is a must but it is not currently done securely so we
> need add proper flush to fix it, while for ARM looks you don't have a
> case which relies on nosnoop so finding a way to disable it is more
> straightforward?

Intel GPU weirdness should not leak into making other devices
insecure/slow. If necessary Intel GPU only should get some variant
override to keep no snoop working.

It would make alot of good sense if VFIO made the default to disable
no-snoop via the config space.

Jason

