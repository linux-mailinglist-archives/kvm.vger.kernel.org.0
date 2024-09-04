Return-Path: <kvm+bounces-25805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38FE896AD8D
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 02:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D3F21C23F7E
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 00:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED59C4A21;
	Wed,  4 Sep 2024 00:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IbAq3PKi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7B939B;
	Wed,  4 Sep 2024 00:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725411589; cv=fail; b=mtXNZsIDWIubiyYDEf5jcFinApqa6m+PkZVHl+/WEqwseOYodqB+2lg5sagoWjZwnJzlL4CwAZ73sG4ydMnqBceJ0kdqyQuJx0iJe4EA9+uJqagmakwHmStZEFdJGHVEltkkBQumI/EN+9EaDouHPlOwoSnUzbbXug9QhRfQ9Vc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725411589; c=relaxed/simple;
	bh=GSJB4cT6ifnBbG1yN7Xmt42TH0bokcocGEOSMe4/D18=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=vDkvbQZobZPPg7/vbDL2eei7iGpi1JPJyKfrFEgbvrmuLQsPaKjTzOEVKVP2fmtqgaJKUvD2juWia7JSlC4A72tuvhuIIfHDYS2xtQSG3IuDRrStDAQa8n94WZbfD7lGLOCjj4KR7FeiCG1TI2QFORgyC7hTlVxayCY6WwV8n+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IbAq3PKi; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725411587; x=1756947587;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GSJB4cT6ifnBbG1yN7Xmt42TH0bokcocGEOSMe4/D18=;
  b=IbAq3PKiciPSkck6LkGyv3mDh7snabjDW3PQbEzisYGYVcmKZCW2FYsm
   GKR0TF7n7TXYgTyvU36IO6KM3jlkBngvdHCDXNKTdP2tXZOw0kFLl7u13
   P6m+h4lpckUrGddgxialf+k3sCWncaFLXSMqnmWkPSV223SNM+7S61E31
   xm6aa+3g7JwLqwciIbQfvOxzxrPm1qioN2qz8B+bW9dKe5ezD4Eis1/Ry
   3gGaXFDhEnDVfdcJ9U5CZdX5kptN6ZlCOyL1rbwjp6Vkh7tZV+aOBvxUT
   qBVGpRFt4n5i3brPkyPDq5qbeCytAqe9pgzvSj9UPSgrfU4+wHu1GUn+5
   Q==;
X-CSE-ConnectionGUID: QiIcFNdfR/e4s8Xf0eGNRQ==
X-CSE-MsgGUID: e4FhyEokRMu8jbbIN7w9ug==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23557266"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23557266"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 17:59:46 -0700
X-CSE-ConnectionGUID: 9XtFWrHTQaeVxgNNkAxdwg==
X-CSE-MsgGUID: k/BeLRUCT92GWVbqaM2Oww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65602824"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 17:59:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 17:59:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 17:59:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 17:59:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 17:59:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lo4nkV2+1dpknTrMYzp8b7ewWt4QsT9uAPCmGB6G5R5MTqTI3iWdiCh4B5DWu3kPD98imefnlLXlrD5scSoIAo/+8rDtgvyOj4nHbLO9XDmmIxujEWmK/tdLAO29cdxVWjYUQfZzVPEnL/sf5Wqj0TJ+8zq7o7BbE7WFZBeAUuS6dcmIl1sHhbokGmiNHS0XG0mF6QQv/domj+j33XMRIilqUx7ukFMCN/Tr/EmMfFgdJT4ruLR5kFbHaib3Psh/eahVbes9yPSvSWqTYjDg+h/yUbNloiadmoEcIqB0VNeV2jDOVNGM7cpO91MPgnFhGZAp/RghGr4pgIo+6VwF4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+oPCfhSwjSB3bA3I4JM+NW7mNzshQIU00OlyVegJOc=;
 b=bFLIJ7HKYD6ygTSqBCesAh0rvmvokzCVCXcF/gpP33sRHivoLef9XCYtend+Sp8fvPC8gvxpTPXDT60TL010Z7pfh3IMLZPuLUW8F5IcXiE9r89P33i4WHp80Z/BGF604DawklcSRSCqnmeyDIOVMWjWBZwfon+RgllIkbtcFBm1lGaumUnubZHcIbCWNoeDcETFJE1OvdLayFXwztZ6UVCRX7snmjrkr1bBxuZo0FU6iHaKWfV+6LeKGiL2c+nnmq+Ab8eiMtySK1rPQ7Dr7LOETy9H+TpaFYqglZL8JavtpbE4GgyC/fYvWfRD4u9T031irmba2Xwh4XNt6Rfjgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM6PR11MB4740.namprd11.prod.outlook.com (2603:10b6:5:2ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Wed, 4 Sep
 2024 00:59:42 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 00:59:42 +0000
Date: Tue, 3 Sep 2024 17:59:38 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Dan Williams <dan.j.williams@intel.com>
CC: Xu Yilun <yilun.xu@linux.intel.com>, Mostafa Saleh <smostafa@google.com>,
	"Tian, Kevin" <kevin.tian@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "pratikrajesh.sampat@amd.com"
	<pratikrajesh.sampat@amd.com>, "michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>, "dhaval.giani@amd.com"
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, "david@redhat.com"
	<david@redhat.com>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Message-ID: <66d7b0faddfbd_3975294e0@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
 <20240830123658.GO3773488@nvidia.com>
 <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
 <20240904000225.GA3915968@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240904000225.GA3915968@nvidia.com>
X-ClientProxiedBy: MW4PR03CA0329.namprd03.prod.outlook.com
 (2603:10b6:303:dd::34) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM6PR11MB4740:EE_
X-MS-Office365-Filtering-Correlation-Id: 68b36a55-97ee-4920-f955-08dccc7cdc09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?AJOD8N7qWJgVFKKrSmFdnXZTYmohkudOMtsa0V4cN5eWXPYNJk5vkdz9zWSe?=
 =?us-ascii?Q?HEHtfwAR5LKFU8uHtimB1+8t5KAWbd2dO1jF/38i3eIHk84tpphoUKvHvhwQ?=
 =?us-ascii?Q?jwgKGdKOUC+wj9nE5tuo6zfNH70BVJnBo4utPrrVDjAwhOBG8a27ZCI+xPwK?=
 =?us-ascii?Q?SNiN/81VQCw+gxJE1F3QyeO7ofPGwLo2ety6tO/7FJDMQHvKoQ3tMLXnanQr?=
 =?us-ascii?Q?LiIMDls32FMQ3Uez3xiDt0Oo1hxVAsiR4MwWNF9eJ1EIpb9P3ID3iztccoG3?=
 =?us-ascii?Q?z1OFp5JIVeXzdn4/CFsELib/tD6/7Yp50m4EvHErBZKDUICZV+AC4LvurLOf?=
 =?us-ascii?Q?9hAFRoKb9ri4FxHN4+XQqL4UL9a0j7/tdj7gStMMklrOT6n68w3imYdZLOsC?=
 =?us-ascii?Q?86CDxZlEotG8FwI/aRt1zATc90Q+QgDCzQ2qJTV81uMfLkmAGRLAU+lpdn/q?=
 =?us-ascii?Q?8tqrwBLp3Y7nUhhG7na8h0i92z/6f58Cq8kYLto9BLdqeiieaAuXULsc1qb+?=
 =?us-ascii?Q?SZnJRxOrRksrXdN7EjvHHM/YEst9kVZum0JIquyJ/28a4Uth83s84oEeQf2c?=
 =?us-ascii?Q?Ib0xS6BYK2cssGHYlkQ9fcQHbbsgtZnTv0mysXIkcTdsFV9URUFYqxnK3mvq?=
 =?us-ascii?Q?04ugGbOeXVE/w0S9DrzikDKNGu+49kHu4zXe/jJ8KHM74vtgIm1kaOxOO9QJ?=
 =?us-ascii?Q?2x6NfJoMEbclOsPq+aXOEIFblmI1nFeXOhJ23oT9jUFnGjRfenEENmFZYztm?=
 =?us-ascii?Q?2XY0GzgvKbHE7Adtyy1mJ3KGEykp8/hgTga9rW2v1DaSBtCoZJRh5OINDSVx?=
 =?us-ascii?Q?yVd0jVywpW+DdAEpbhMRne/aPx8+5tcntQ+OBX9hpK6YZ3X6wHKFYWwJKOnJ?=
 =?us-ascii?Q?TfIs5dxSCJfsP0CUrNxJKysnKsKeftRAWlsPJ2BCGsWpNr6WOLYMbqQWbNLq?=
 =?us-ascii?Q?0fq14ynA4OfOc/Td64UVsRN/0M7Yn0wpM67RS6bX6pKGYtnImD2hHqCfQcqY?=
 =?us-ascii?Q?3x3smNzXSyU8Geoq++BB6s7Z2Q8v6LrTjNNWEpbm9FMIsUn2LW5nmHFzuqQQ?=
 =?us-ascii?Q?ePw1zCUDahc9BrMNIrPBh+woyLrgDkvCNiaoU+5hEtTFdMBXsTFSS3np4Y79?=
 =?us-ascii?Q?R3zfWODlkiQQwuGiORxbo9Qr9oGsDMCWTYUG+QswSxh73S0KIBIWm7PFTtE/?=
 =?us-ascii?Q?ybxt2tyrm92cXiG/yibDPcj7RAYj8ufL7Qy2B1uS5yy1gANUlY4uSccu4AWE?=
 =?us-ascii?Q?UrGReLxk62ia6UTLHIPsTMKSstJnHDGV4dg0r+79sT377sOZDeq1OD/+v98s?=
 =?us-ascii?Q?+Tx7/ywU4m4yZ1HWXZpWChrZfcGcX1BNVZ9ApOoJOCB65Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A323g8xWZtZLHQSmya8/wApINldqT9pbu5wv96ZwnEZp6c2kBWfHiBMevYXQ?=
 =?us-ascii?Q?MnSHj5P8lwYqFF2qXM8EsgzVIJxWvB+wSOenFbukf0queN2PvtsYjlpZH38G?=
 =?us-ascii?Q?5tZ0oK/Oqu2cunKkJEJkvMv8/XTBnl4gq7GxmIZk7B6kgg5ADsPcT3EnCX3t?=
 =?us-ascii?Q?2444JgAOtZ88dodOIFH6onShaFDGqJNS46yhPpOnaLR//q2kn/ZzORgtFsyD?=
 =?us-ascii?Q?WMBpEMsPcuOQ1wbGbAm0DuiiewhMFJUMeC1iqN1sOYzefJF+uXHqBT0q+JbU?=
 =?us-ascii?Q?AnWllpXSkXDOT2D0XXQSWggo3Or1beNZvlzsGZW/kxEj0k3SJyuzXk2e7eiZ?=
 =?us-ascii?Q?LoI7Z52cSRU7gOHcHs4xFLm+cmHHmEPwlGn+gffM2XgXCr7FTECg34+TdgbH?=
 =?us-ascii?Q?N0xopJ5k0ZZdv/8GB0PJPyOY7jOi7Y4JpU1MBE5uTLaaZeOWmOPAxq5WNvfE?=
 =?us-ascii?Q?9BZlJIOwn0qzvdaZNfxtAQNoqRJBPFP7s2IaZxfbPMhBojDaLdgfG3ZRsqTQ?=
 =?us-ascii?Q?OEkwf+8hocBJ2D4LSa3XZLVx+cmlErO8wGwAZpbwk+AWFK3oClPjNpAR91cd?=
 =?us-ascii?Q?ziY/wj/hGjui34e8wzRySEwPNQ7dm61bIdfEPgeBbwpun3boR5t00gy6Jye3?=
 =?us-ascii?Q?xLkMKGDKmHPLdsn91d7JGeC8itzlUj+OAw64+IHWRhCsyx/l3V5OhXOXHk42?=
 =?us-ascii?Q?vt0ybIzAvJfZ9URlp6gkXsJeA5wk9rBfqBJXlk4X2m/fZEhL1LDzgwmn27VJ?=
 =?us-ascii?Q?+demo15vckCqB3oIdUbKW6rh63JxrurtX5QW8n3r986qU35YF8/3Lc4UfO1M?=
 =?us-ascii?Q?aLG+ZGvpuk9pambvNPpG6ImrLrIz67XKcnSj4GrgMl2n6buIO1rFBU/fHa7l?=
 =?us-ascii?Q?Hd1/LTrolbHS+h/IbiDYJFofKC4yU/3+fz6qwt4zE4MTubgkR+/b2t6iYkyL?=
 =?us-ascii?Q?tvg60w2z14a3xwsbnJ5+jfFIzbrrXr5tcZ2QophY9f+ZmXl5PR3Pmh3gzodr?=
 =?us-ascii?Q?XeID+6dNYcF7Wbb7nYNRvEn1s2S33Zxx8FhL+eDEtuQMZaOrxHSI8kLwWOu+?=
 =?us-ascii?Q?Lfk9v4ViWcGths0E7fj81bsP4g/Z7I6wjcwMV/r8QA2Vm+A9xDEl6n1to/iT?=
 =?us-ascii?Q?rVCBMQ4jd4cJ5KtRVy4O+JDv4RiUCSRk6OEPUMGqFH8z9rFKFN70FwGq6/Ng?=
 =?us-ascii?Q?zIW7rSakSDnwhdOGZiR4mXlITBLYDmaRjS9YmLtxGO/O66aJzD3TbrlXXCS+?=
 =?us-ascii?Q?UCJjloYaoTf1EfFTHf25aj0eHmUERvHb2/rvgNwyC2+kkms369nVzbL73D3v?=
 =?us-ascii?Q?bxktD+YOudZrVbbXOmbQ8XQeB/KA1WDXNWffVfGnFkaUPGZZBUsdqDZ+INAT?=
 =?us-ascii?Q?KxSOOQiwoAVLq4g8VnI/0prdJuf5pGm1GvSZjZcznsYVMuCZOf4Y4eUf5+Em?=
 =?us-ascii?Q?MSmwnpBtkLLIoC16sK4fyALwREaHNZ2GPHr2B9Z9/xUWCj08Dh6xAAWwD+CS?=
 =?us-ascii?Q?094xq48bO+oEhIiQ6uGqrxmlDSTLSkNzA8/Cs/i1hQ+MD3qjZ0GIBcoSpPur?=
 =?us-ascii?Q?t63LfJ4e9TDVG9jziX1jJtdU0EyHQZM1EA19KNqfal6YhEFJCgD8eWgyTACB?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68b36a55-97ee-4920-f955-08dccc7cdc09
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 00:59:42.0591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PrHSDoXtY7HyOwGTJ/Rqt2MtQWIvOTa+1X7L/UReUR8OpPvbkduwQwgEk+Ic70JxCMFilV9Wh4XSede3zrzkWNtKItFwY2PQ8GY6fYY7OOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4740
X-OriginatorOrg: intel.com

Jason Gunthorpe wrote:
> On Tue, Sep 03, 2024 at 01:34:29PM -0700, Dan Williams wrote:
> > Jason Gunthorpe wrote:
> > > On Fri, Aug 30, 2024 at 01:20:12PM +0800, Xu Yilun wrote:
> > > 
> > > > > If that is true for the confidential compute, I don't know.
> > > > 
> > > > For Intel TDX TEE-IO, there may be a different story.
> > > > 
> > > > Architechturely the secure IOMMU page table has to share with KVM secure
> > > > stage 2 (SEPT). The SEPT is managed by firmware (TDX Module), TDX Module
> > > > ensures the SEPT operations good for secure IOMMU, so there is no much
> > > > trick to play for SEPT.
> > > 
> > > Yes, I think ARM will do the same as well.
> > > 
> > > From a uAPI perspective we need some way to create a secure vPCI
> > > function linked to a KVM and some IOMMUs will implicitly get a
> > > translation from the secure world and some IOMMUs will need to manage
> > > it in untrusted hypervisor memory.
> > 
> > Yes. This matches the line of though I had for the PCI TSM core
> > interface. 
> 
> Okay, but I don't think you should ever be binding any PCI stuff to
> KVM without involving VFIO in some way.
> 
> VFIO is the security proof that userspace is even permitted to touch
> that PCI Device at all.

Right, I think VFIO grows a uAPI to make a vPCI device "bind capable"
which ties together the PCI/TSM security context, the assignable device
context and the KVM context.

> > It allows establishing the connection to the device's
> > security manager and facilitates linking that to a KVM context. So part
> > of the uAPI is charged with managing device-security independent of a
> > VM
> 
> Yes, the PCI core should have stuff for managing device-secuirty for
> any bound driver, especially assuming an operational standard kernel
> driver only.
> 
> > and binding a vPCI device involves a rendezvous of the secure-world
> > IOMMU setup with secure-world PCI via IOMMU and PCI-TSM
> > coordination.
> 
> And this stuff needs to start with VFIO and we can figure out of it is
> in the iommufd subcomponent or not.
> 
> I'd really like to see a clearly written proposal for what the uAPI
> would look like for vPCI function lifecycle and binding that at least
> one of the platforms is happy with :)
> 
> It would be a good starting point for other platforms to pick at. Try
> iommufd first (I'm guessing this is correct) and if it doesn't work
> explain why.

Yes, makes sense. Will take a look at that also to prevent more
disconnects on what this PCI device-security community is actually
building.

