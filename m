Return-Path: <kvm+bounces-18805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 806288FBCBA
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 21:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F3DB1C22266
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 19:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0C9D14B945;
	Tue,  4 Jun 2024 19:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W4so/42z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFFBB644;
	Tue,  4 Jun 2024 19:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717530301; cv=fail; b=BIK0BLFfnuxTq8a5cl8uF3aqO1CGIDKVYUWpDcBKOZ+meeYUbZFpqxAuT683jaiwb/RJjMM+eKx8yV4FAwGmFb9G9JREVdvJ88/hf6UBOb74Clif0JlSKJhntsfJPrtmDCxtQXgDhSVa3ELPLQr1lXas12HVU9oOjVAcHCdQ8Qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717530301; c=relaxed/simple;
	bh=vpAv83AfVgGnzARve34Fqi2Y2Od/87w2zK8XwXD09WI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QMoV/sBh7ZKaURQiX03IyJ+mnsfuNuPkwxaCiBaLaANTSJ+MRnrskMS5hlfGqQj8EmbMQ2UXKuTeMWFWze8xUK2JjPLYHbxMMYCBlb4d7p/ays84PWhu6D9VkVAVfJ0mY3H9EFxb9+tAUfCu76TcHRbtpNe8COmeZXckPIEiy84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W4so/42z; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717530299; x=1749066299;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vpAv83AfVgGnzARve34Fqi2Y2Od/87w2zK8XwXD09WI=;
  b=W4so/42zJ3jwv0upmdKRBM/8OVmYNJq4W+Dlf4U6adujVpOVpIV84vAc
   tCCR1vE9ZrQNl4HqxyFpjbr6uKf4HoDdvL4oU5y93BwTdYfZkyUoCzX9Q
   LgxAb8ku7ZXZ6RkHgeo6N5yVEn0/vThzy91Kw6CGWpGjRBRMV8ASZsoWk
   gVrz9+2gYoBYxRf5mFcOi2LCQE9S+wUoL/10XvZLj3OAalpmUliFAo1jt
   SPQr/a5MTsyYfcjsi7D3Dd+xIeGezp092Km6pBr6f6oVT5TRYFWup/x9b
   4bVd55RCmIQFM920Y//sC8OPDrOsfF/58OUbiJweOXi62Tmw0WUio0An9
   A==;
X-CSE-ConnectionGUID: t4jghvTBQ/69yPbIr1r3pg==
X-CSE-MsgGUID: CUv9NpMDS5ibanbqiAJBbQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11093"; a="13947308"
X-IronPort-AV: E=Sophos;i="6.08,214,1712646000"; 
   d="scan'208";a="13947308"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2024 12:44:58 -0700
X-CSE-ConnectionGUID: jH90SjgVS8KF+3eKrjrypw==
X-CSE-MsgGUID: JKLESqeOQFejx7E/WxpVmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,214,1712646000"; 
   d="scan'208";a="41777162"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jun 2024 12:44:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 4 Jun 2024 12:44:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 4 Jun 2024 12:44:57 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 4 Jun 2024 12:44:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DH9JEk3Vl/+AM8bVI3pnJ2Au5i1wzDOmbSeXPtCfpT0wU9h51JAUSQB6S45nFU6CfpiwHTjzhIIiwhwJbFRE3UpXk+KnLoi9Azlti++OwEVxpO6IZwMvuf8+1vc1+xgcAjNcg4d2cr87ZZlz1d2VLLgc6CJkKNI6dgEriBGZ7g1rLHvhCLmcEwhd/AwKRlR6YEMMqMSQ3ArfX2xB2bGzM0trKP2sHdKGr9GoXy8wIGjRqaDm/QirAllEKWWzPuRYzpLI6py+4RveX2ki2aXEL+1F1gRPs5hqFzfUjtWQWJBwGjdt34INp93tfgar3+/rTcJaYnLgOT+GV5BxsL7yEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M+4O2DOtdxzxHBE4wzq/h+s091o0FcTYxa2gahBQ7R4=;
 b=ZGwmJpEpCX+YHnXxNq8CDv9JCNRuJZRY/VfKeUMXMtO+82fvjQ8n8oBkqjDwZC1vGuGHkuOUwuC9pOBaZ3Tde+p/jF5Mbn7m/FiBg4hGEt8HS4l/F+wkPwK7V9Rwjklhw8NkbFsaqCOHr7HMqO+G7vZmGOINOKQsTCAxbv/mvR2otb/pfFdtA9LKsD134Y54zIw8AaAMHk3B2g5l2ItVqDziFwdBXqJsP/G4IwWGEOHRfajexMTyxNzex9D5ckMnlujobaR+TMsi1zULPNE1AuqiFv5x9hqNr8RZQ6svkMSf60FIt/QA39z9USr3I8utb2ZCykF1y4SLmtWcN2ON9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2535.namprd11.prod.outlook.com (2603:10b6:a02:be::32)
 by BL3PR11MB6412.namprd11.prod.outlook.com (2603:10b6:208:3bb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.27; Tue, 4 Jun
 2024 19:44:55 +0000
Received: from BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7]) by BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7%2]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 19:44:55 +0000
Message-ID: <e5626d58-b7db-402f-8edc-816882924ea1@intel.com>
Date: Tue, 4 Jun 2024 12:44:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/pci: Add iowrite64 and ioread64 support for vfio pci
To: Gerd Bayer <gbayer@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <alex.williamson@redhat.com>, <schnelle@linux.ibm.com>,
	<kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>, <ankita@nvidia.com>,
	<yishaih@nvidia.com>, <pasic@linux.ibm.com>, <julianr@linux.ibm.com>,
	<bpsegal@us.ibm.com>, <kevin.tian@intel.com>
References: <20240522232125.548643-1-ramesh.thomas@intel.com>
 <20240524140013.GM69273@ziepe.ca>
 <bfb273b2-fc5e-4a8b-a40d-56996fc9e0af@intel.com>
 <7dcc8e25c81c03effc8f23c2022a607c8040ea8d.camel@linux.ibm.com>
Content-Language: en-US
From: Ramesh Thomas <ramesh.thomas@intel.com>
In-Reply-To: <7dcc8e25c81c03effc8f23c2022a607c8040ea8d.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::30) To BYAPR11MB2535.namprd11.prod.outlook.com
 (2603:10b6:a02:be::32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2535:EE_|BL3PR11MB6412:EE_
X-MS-Office365-Filtering-Correlation-Id: dfcea5c4-c6fd-43cb-77d6-08dc84cecef5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cG5qOHFyamNIeDFBaE8rSHJwazRraDRKUTRQR2R5NTcxeml4YjI3aklKNnFM?=
 =?utf-8?B?dkdmUTZURjJHbThrRm1pUUVoWjlXQXVLSDQ3RG1YdTEwRjFOalMxY251a0c2?=
 =?utf-8?B?eFRYbHI5cVgvNkZtYXlFY2xnRk5MRXJsOXpFQzZWdkI2djc3K3pjMENwVS9M?=
 =?utf-8?B?b2UrcVU2V1pJRFJRMU02ZHcrWlVodTJvY1ZqRDdwV2pVM1U2bStnUWdtWkZX?=
 =?utf-8?B?L1ZDYW40K0wyaTUzRlJUb29ISE9sRVlrSjlYTmk0KzNLc1N2TTlhS01JYnIw?=
 =?utf-8?B?djBOUUl5UHd0Y1krK1F6RE9YZVRzSGJkSlZOWlVUV1pQcitLM2NXRkNLSkwx?=
 =?utf-8?B?c2dMbEdXWGxWc3BmWWJsOU9sNkpQVHNjSE1VVDdZNy9IdzliMjd6anU1OWg1?=
 =?utf-8?B?aTNJOXdWdDlZcVdkN3dKM0lRa0lCbytFTU1kR0UweXhyTW14MmltWXFuNHRS?=
 =?utf-8?B?NVQ0R2lTcXNWSU1UckZoYnhleHhoYW43enlYR2czTG9kaFNURXZFQ3FxVHVy?=
 =?utf-8?B?RDUyOVNwbkZJN3U3TGgzRHJyTXJJNWd0QTNhVC9GWUlZNWJnczY4QUNhK0FK?=
 =?utf-8?B?QjFYL1R1U1hFTkZWdTBnQ3pXeTdOWERPUDIyaHJtWk11V0Y1OFJmd3loYXcw?=
 =?utf-8?B?b25iUGJaL3paa1l4VzRlMWRscUpnR2V4OXdTMFM1Z09zdWZESjlyVEVCZC9N?=
 =?utf-8?B?L0xzU09zejQ2cjJ1Smg1dVE2SldkWEpKbENIczJvSktvWEZSRVNKRE14cGls?=
 =?utf-8?B?ZVc1NjZDSHM0ZW1Lc3YvYnZMbmpaYXRxWlJaQUVVMDdRS0g3TlpuOXE1bVlo?=
 =?utf-8?B?S2VrT24wYkRXWTlZbzQ3WHZpeS9wMEt1d2dLTU5HcUNWNXFKMEtYRC9vaDlH?=
 =?utf-8?B?bzdhcjNFb2QxQjd2R0RZb1pwU0Nzb2JpZmhvcnluVFR1cTBZcGQzRldacG9y?=
 =?utf-8?B?VnZSMlBVRndFTjZBbHlXem1mYVEzZUFySWtQUm5QeUJDazUvbERGdlZpa2JJ?=
 =?utf-8?B?bDd5bUt5Z0lZNTJ6bW5YNXNrb2JLd2NrT1ZFVmF2dVkxZVFzVkk1eEtQdFg5?=
 =?utf-8?B?M3FXNmd0UFRBVmVGNTFwT2dOT211Z2FwUUlrYktiY0VQQ3hwQjhIRlE0MHZq?=
 =?utf-8?B?U3d5eGRPdEZ5Vm90UlFCL1FrYW9XeFdOa1dNRkd6L2VucHdidW44QWx0Tzdu?=
 =?utf-8?B?MWc1OHN0TDVWb1AzeE1UMTk0cVg3SGdMNmIzT3gveHJvM25vaytMWGxBVFdM?=
 =?utf-8?B?NytOUGVUYjMrOVUvM3BJNGJQRmJYUGZCWkRUOVV3b3MxVTBGUmQveU5qbG00?=
 =?utf-8?B?UXdRckx4Z0RzZDJML3craE45T2t4L21QN1pBYUdaWloyNzJSWmZhdDBlNWUy?=
 =?utf-8?B?UHdUbS92ZmpvS3U3TkFRSmpQSGZyR2VyVG1JMVJ2UUhxcG12VDd4N1R5R0JW?=
 =?utf-8?B?aW5mMjZtT3dNU01rTE9MYmw1dm9SaGlvaFhydDhGQjNUcWEyWkE2dCtJcER3?=
 =?utf-8?B?TmRsTFpsZTNHc2dJa1BvMUc4UDJDVVNBOExnR2JwT2tMUWpDUVUvUkl3UGdS?=
 =?utf-8?B?aExESm9jV0Z5N09YbnhyVnBkWVRpOE8rOWRQUTBHc3NCT1FyTFh4UWFTNHNN?=
 =?utf-8?B?M1VjdERzUjlYYnRJT2ZLd0Vxc1FydXpsTXlqWUVCV3RtZkE2SlQ2Z0JxNVlx?=
 =?utf-8?B?YmxQdEVDVEtvMHZOYU9JQzVKN0RTVi9BbnF3eWJ4bUdkbzFNQWh0elB3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2535.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0dtZFp1dWdLQzZZOXB6NmNaYjNacUptOHJQZ1lGZVVRQlhYTEJlMjAyZGkz?=
 =?utf-8?B?UTBVQitKQTU4dmFVTC9pN1pESjNUV0JxVEVIQk1vdGlrV1VhT210ODNDc1Jw?=
 =?utf-8?B?YUxkeGRRK3Blc1FjNjh6Q3pQT3V6c0d2ODlFSk1laXJvbWdhTGYycXg3czZv?=
 =?utf-8?B?OU1KcnQ0ZkRSZmtBV21LNUh4QUxQQSsxRXZETlFSSFF4bnRMUElrVEZ3UGtD?=
 =?utf-8?B?MXFKRFBOdnFLQm9td3MrL2JxUWt5N0hId3d5UVFzTVM2ZE9uVFRYenQzQklG?=
 =?utf-8?B?SUNOek8vcVFtNy9XSzlzY0hrYlVFU0ZXRHp6Rkw2TXJtcVRBdjU4aHZJMGpx?=
 =?utf-8?B?SkpoZGdORTRKM3JGeHh4cVVFbVp6SEtXdUMwQ0Q5cElHMTZ1ZG45TnVVK3Zh?=
 =?utf-8?B?cWtKVnJaV09MMGg1RW5nR1FKKytJWCtFS21kNURpd3RHRlZFMkZaaG1aOUVi?=
 =?utf-8?B?T3NmMGlMQUoxOExYTWtxdXlrc2F0REZ6N0hMeXU1aGh5c3ZtQTlXTVgvM3V0?=
 =?utf-8?B?NVJ3aXE5N1BlVkIzZUhKUlhNbnNBWW5VcHNzOUFHR25aanBsQlY5Wll1eTlF?=
 =?utf-8?B?Wk5yQVc3SDc0aEN6VVh0WENkOEg1M3NwaTl6UXI1U0k1SHlPdTIwdjI4SzBI?=
 =?utf-8?B?THBZVmtQUTZtakpRUktzL1pJNWNaRVRvd2hPT0toMXB0MzFVb3U5eXFPclp1?=
 =?utf-8?B?QzRRZTJSUENNdWMrc2VBQm9FVlNvRTFxcWphOXhabUMwNUVQUjRZbjBPUHB2?=
 =?utf-8?B?UDJnSk1YUU5MV1VlNlJ1YmxFNy9WWjFxRW5JK2FocWdNR1FMUHRma2t3MlBi?=
 =?utf-8?B?NkRlc1UybHMrNnZRT1dmQTZhMjhZNDk2VkV6cHJ6N0lKSFFoVnBIMjhSYnFh?=
 =?utf-8?B?dWFnK2N3MzJxQ0Z6b3pDKzRyYXl5TS9vVUt6SjdFMFoySzZidWY1cTlHTmhp?=
 =?utf-8?B?ZXZiSVN5YmtWQTN2S2VNQ1dTWXRaMC92a1ROajM3aXlBTFJKTWVYRXU1enEy?=
 =?utf-8?B?ekJXdnJNWGJRRFYxMWJ0ZmlyZnl5S1Z6eXpiYkFIeVh4UEF1bXk5ak1ZLzE5?=
 =?utf-8?B?NFR5YUJ3N3pjRUlqNjNhMTIzQm9nTnhXczZ1enZaNklwTHZadWxmTklTS2dm?=
 =?utf-8?B?Z2FQVWhVUTNrMXFNYVVFaDdvTUFZdjVVc3dBVGZoMjIyMWdxWEIvcERNQ2l6?=
 =?utf-8?B?NHJMTktFbjlSSGJGeXZvbmxnaVNJZFBDUnZWY3l6Z0tkZ2JPWVdtRCt0YWdF?=
 =?utf-8?B?ZUIxVlRDMkYwL25QSHVRNHN5QTdWR0ZmVU1rZWZOQTdZeEZvOU9qMDc1OWQy?=
 =?utf-8?B?OHFYL0ZuT0V2cU9OOTB1WW5HQ0o3ZmhONjNJc1d6VjZia3NSYURIdlIxREpR?=
 =?utf-8?B?U2Z3RUMzS1EybVhWZjVTTzgrd0NON2NwODRYSHlPdHppMXY3NjZTaDRkQlBV?=
 =?utf-8?B?NUVFZmhhbzl5T3FXUmdvVWdmVExjMytGQTZMbnNGRXZiaU1vVGVqYzR4SWg2?=
 =?utf-8?B?Rm1CNzl6N3BaWkdCeDRsREJRdHNsNVJOSFpEblplcmR4bWF0RThJSDZsL1Jz?=
 =?utf-8?B?b3I3VFJFeEZiNXF3K1d1Q3VkcWVIa1loR1Fra3d0WlZaS2xxUjllSm53bDBx?=
 =?utf-8?B?ZHVtZ3B0WWNCcGhjQyt5NjUxTDNRQU12OHZPN1V2bVNJTDlLZ1hwc1dwNlli?=
 =?utf-8?B?WFFlMmkzMStLSnVuUVRKZnYzRDRPaFNKYjJCcE5GOHVOdC81ck42ajQ2V2ZL?=
 =?utf-8?B?UGp3bEZ1MDdKK1ZmNlE5dkI1a0Q3MitZRk04Z1RkZEFYK2htN0dHeVJiZXJl?=
 =?utf-8?B?N0ZuWmR1bEdzc2RzK1R5ZU04VzhsQjQ3QVEwODc3Q25ud01rUWoxUUh6VWtU?=
 =?utf-8?B?b3J5aG5kd2tBRWpwVFRpejgwZFdNb2l5a2NPbVB3NHZxcDZFVjNNaFA4cnZM?=
 =?utf-8?B?d0R3MDB0cHprZ2JONDJnakx2dFVhcjlBN3RWSGtmdFVodzl0T0xvbUpKaGhQ?=
 =?utf-8?B?bSs3UDYwRlhWTzBqU1NrTjNJWmhIQ1hsbXRUSmJrU0JXOFBuallJdTdiZ2xO?=
 =?utf-8?B?bG1oR3ZqMTZQNVZ3ZmV0MXRVUnRtSlRHc1B6aUZCcFpzellpelVtQTZOZGxj?=
 =?utf-8?Q?z6ikvCXVETsyQw4cjEjpndqMw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dfcea5c4-c6fd-43cb-77d6-08dc84cecef5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2535.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 19:44:55.1031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F1ujHkkg1I8nCCI9vJpByS0DCdgbGOxUM36Efx8GQ1OdMHoK+pnVbH6J17hl0gocYmUREFGjylbbC5mTwJ5xKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6412
X-OriginatorOrg: intel.com

On 6/4/2024 4:46 AM, Gerd Bayer wrote:
> Hi Ramesh, hi Jason,
> 
> being back from a short vacation, I think I'm sold on enabling x86 for
> the 64bit accessors in vfio/pci.
> 
> On Tue, 2024-05-28 at 15:48 -0700, Ramesh Thomas wrote:
>> Hi Jason,
>>
>>
>> On 5/24/2024 7:00 AM, Jason Gunthorpe wrote:
>>> On Wed, May 22, 2024 at 04:21:25PM -0700, Ramesh Thomas wrote:
>>>> ioread64 and iowrite64 macros called by vfio pci implementations
>>>> are
>>>> defined in asm/io.h if CONFIG_GENERIC_IOMAP is not defined.
>>>> Include
>>>> linux/io-64-nonatomic-lo-hi.h to define iowrite64 and ioread64
>>>> macros
>>>> when they are not defined. io-64-nonatomic-lo-hi.h maps the
>>>> macros to
>>>> generic implementation in lib/iomap.c. The generic implementation
>>>> does 64 bit rw if readq/writeq is defined for the architecture,
>>>> otherwise it would do 32 bit back to back rw.
>>>>
>>>> Note that there are two versions of the generic implementation
>>>> that
>>>> differs in the order the 32 bit words are written if 64 bit
>>>> support is
>>>> not present. This is not the little/big endian ordering, which is
>>>> handled separately. This patch uses the lo followed by hi word
>>>> ordering
>>>> which is consistent with current back to back implementation in
>>>> the
>>>> vfio/pci code.
>>>>
>>>> Refer patch series the requirement originated from:
>>>> https://lore.kernel.org/all/20240522150651.1999584-1-gbayer@linux.ibm.com/
>>>>
>>>> Signed-off-by: Ramesh Thomas <ramesh.thomas@intel.com>
>>>> ---
>>>>    drivers/vfio/pci/vfio_pci_priv.h | 1 +
>>>>    1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/vfio/pci/vfio_pci_priv.h
>>>> b/drivers/vfio/pci/vfio_pci_priv.h
>>>> index 5e4fa69aee16..5eab5abf2ff2 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_priv.h
>>>> +++ b/drivers/vfio/pci/vfio_pci_priv.h
>>>> @@ -3,6 +3,7 @@
>>>>    #define VFIO_PCI_PRIV_H
>>>>    
>>>>    #include <linux/vfio_pci_core.h>
>>>> +#include <linux/io-64-nonatomic-lo-hi.h>
>>>
>>> Why include it here though?
>>>
>>> It should go in vfio_pci_rdwr.c and this patch should remove all
>>> the "#ifdef iowrite64"'s from that file too.
>>
>> I was trying to make it future proof, but I agree it should be
>> included only where iowrite64/ioread64 is getting called. I will make
>> both the changes.
>>
>> Thanks,
>> Ramesh
>>
>>>
>>> But the idea looks right to me
>>>
>>> Thanks,
>>> Jason
> 
> So how should we go about this?
> To keep the scope that I can test manageable, my proposal would be:
> 
> I'll post a v5 of my series with the conditional compiles for
> "ioread64"/"iowrite64" (effectively still excluding x86) - and you
> Ramesh run this patch (add the include + change #ifdef's) as an
> explicit patch on top?

Hi Gerd,

Sounds good. Meanwhile I am also trying to get this tested in x86.

Thanks,
Ramesh

> 
> Thanks,
> Gerd
> 


