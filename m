Return-Path: <kvm+bounces-21631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57DB4930F54
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 10:08:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 125DD281C44
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 08:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB8A7184122;
	Mon, 15 Jul 2024 08:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f2Mc/0Cb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C2913C675
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 08:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721030874; cv=fail; b=ZvfHpBat5WaJSeqojWJtvFdA1qcF44RCDUcxXEpv74wWR9Hg4gVlLFawyyZiJytWQmAvtioijoyxVbMwKoom0vHAgRaSv1Y8gyRuSCH+vV63C7fbbWBatMI+QWGP2flTO7nabfY3k8e0V/nF5YWtwm1gDwrSmNgSvenng34h2x8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721030874; c=relaxed/simple;
	bh=h8ODLBnWqLyV9VHZR3NbaWT5e7BZMY1EVVdcjsJGDek=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QtKBgX5VMRW2ZCGu4/+eJSw5F6N9zxuDjVCcKri85EXesV5GyV6bUFmQECBEU5Tv8A2JHclP+q4OWWVGf5c0hF+QxXn+KPDwwIXDYIjF9CLqzkimGFZy/qO4eVBXs1OrS4Hh0pdAEPdO/y76WBDQpDQJtEp2s52n+IKiBObXYlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f2Mc/0Cb; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721030872; x=1752566872;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h8ODLBnWqLyV9VHZR3NbaWT5e7BZMY1EVVdcjsJGDek=;
  b=f2Mc/0CbpLyj55tCK5oHK+pLpfkmkL2/T7VG/9bCFBuExzxxZ/l0fJXY
   tWIatkSutfGP0OVEqb/TJb3eWZZjvi8wTvPVuW5WxiPIrkabmzQWsUVDR
   V6OAk5lUbIq0Hd1hhDSz3SLK2yKjeQ/4NDVZloQ4YcvUc+NYL9X92qUnt
   Ao/jVfsEyruhRsnywuj25MYYBu/Jllrap0S8PJioV849IBVeiPRIZnQsB
   VilxTsGXT76pGDGMWudkVp8aTYKWTOKMgLJ7K+XHnS8W7y2QIFprHwSjM
   0CHq+46Nn/24J9ssFTnmjLOcvigs/RVIiC8QhpMft/go8JoMkty9rhrjJ
   g==;
X-CSE-ConnectionGUID: kV3XG1QFSbuF0w0FkUod8A==
X-CSE-MsgGUID: s8vL8FbHQPqxMV+Cj0DxHQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="22209349"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="22209349"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 01:07:52 -0700
X-CSE-ConnectionGUID: SbEi0dbHQLGXOMiWruyuQg==
X-CSE-MsgGUID: BsZSffrAS16cSxDUlykyxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="49630077"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jul 2024 01:07:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 01:07:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 15 Jul 2024 01:07:51 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 15 Jul 2024 01:07:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KS3Ucxmvg1di0ipgK8swdWkW4k7fKgxhVYZxYPZtnMpDQny9OCkCN9I20m1IcPJLyF61FOmQzLVXCkH4X8IBwUDW1TxT+REqriSeu6IBLNz2tBjyk8CCO0yvQC9E8c89eMXn72/U5bVeJM+dr76/17+ufr0oPzYJzWD52lAWTQoo4FGosvwxXKPW9Pjaf/ux0way8X0G1Uz1zsQryAKDuzhbkumCVBvw8KmL+FElg+hjxlsjeoRr0C0UWn8999Q5ZRdSi1g7q5mtGdDy+ED75Kf4eodysOMcF38MkzptlhhMMPFvs8I30PRx4XTIAllUhv84fX5clj76H2mdbMKdlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QOgdf1elSnzuS1siqc2H1IxDNALU1nwJmbZ8ciE4wJI=;
 b=DpxJfJF26oitNIjNMn4HbezgqJsD7fX1ms1Tj84PDzizDFsQPgiSVnVsRrtqoi8gcA2dGrvQtckdtpg8HA1ATe1hZX3gfwepqRTDv9nJKdmbVI1hbFzcnnEwoCO1FbzbNRtYePPX+Rn/5zNCLsvhO/H9vrcAggcBuB89MCBWZzQ3kJpXHUUGIkJyx9/TAfHXogFO+rNXF7fKHV7lDQERGbgt0WDqOKmI2JiqW+Wq7Pc0FDnANzNRT9CzQ18Hv1TiYNffebxIRloS3mpnGO1k/sg8xfxntqvA67CYm0i9cW6XPXj+scz2NeYjnzGjHGE9xf98BIH/u/bg52SAKt2sDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7193.namprd11.prod.outlook.com (2603:10b6:930:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 08:07:49 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 08:07:49 +0000
Message-ID: <f05200e4-fcec-404e-9a5f-6eaadfbc362b@intel.com>
Date: Mon, 15 Jul 2024 16:11:43 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <joro@8bytes.org>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<alex.williamson@redhat.com>, <robin.murphy@arm.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <20240711183727.GK1482543@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240711183727.GK1482543@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::30)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY8PR11MB7193:EE_
X-MS-Office365-Filtering-Correlation-Id: 73a910bc-4a35-4c97-6572-08dca4a537ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Um5rSHZmM3lhNkxTY20rOWVnYUVoT2RPQTRKRlU1UmtnMjlGQUxOWXkxcWhG?=
 =?utf-8?B?OHViRUZaS0RVK1E2enBpZC9MWWV6ZjVzMStWNmFGaEZuSDA3aEo2Q3ZMdkFu?=
 =?utf-8?B?ZWIyNndBUEEvUE1HcnU1Z0s2R3ovR3YxNXNmSlBOTjNpejJ3MGgwbU5xZk5h?=
 =?utf-8?B?a3h0K2xYM2R6RlhIMzNwN1dKQXkzc2dabG5ZVHJBZGRST3doYVByV0R3Vmxn?=
 =?utf-8?B?WHpxcWl3Tk5CMVNhZlI3WDNkZ1N6dWVzVkhLc1pCRXV6VVZDcTgralJORGN0?=
 =?utf-8?B?MVZOZkpwdGhYMnRkcVdHcVhwZGdyMit6Y2Z1Rm1UazU5VGNMUHUzbjlNTHlj?=
 =?utf-8?B?WGhsb0c4ZlJMOEpYQVJBc1E0bjErVW9uL0xxQWowbDYwN3U3MEFVdjJXZ2JT?=
 =?utf-8?B?dDM3VVVQR3hOZEZHUnZVMEZXSStwZFNIbCtyWDM0M1FXcmNlUkgzS1QwaXFH?=
 =?utf-8?B?anVPUzQrV3kwQmVxYXFRZUNwWmQ1NVhYQWpxajJSVmE5YkFrcXZCN2xSeVdS?=
 =?utf-8?B?ZnM0b3FlRFMzaU12NkNSR1c2dy9tT1FKdTFoZ2VHL0szT1BEckxYQ0J3NFQy?=
 =?utf-8?B?TEdjVFA0bURTMzlGZTB2UldSOXZyOTZubnQydnNuVGRCbDZyOVpFZmlGcE1B?=
 =?utf-8?B?Y2FxdEd0VkpBVlBPZDFtNnVyeFgzKzYxY3oxMExDb2luYWxwQ3lXWktQOU9T?=
 =?utf-8?B?SThnOC9jZG9GRUhXWkhlZld0dGRSOWpVRTczRHRreHZ1dzRpY2MwRThsWHlq?=
 =?utf-8?B?dW94VkVDcHVsdXJkS1FZZlZsS1FEc0ZxUU1XcmhCRUNnL2pKNHp2WWxEYmF1?=
 =?utf-8?B?Ty9YVWx2OENQWU9ITEZUNnhWc1ZPRE56ZTRwTVBlU2szVjZ6dWxtaDVEdGR0?=
 =?utf-8?B?K2syNTdaMXIrUGJIZ01EZHkvaGo4KytTbGdiUlRoQ0wzLzNrYkNabHF1My9Z?=
 =?utf-8?B?cHNGMmhZcWpMMXJlQU5iUHdnK09RRU1EOE1GRlg2MzZHQ3AzYjJ0QklKUHBj?=
 =?utf-8?B?OVI0bEh6dkw3U2VCd05PWUp6Ri9VNXkxVU5nbDgrQk9TdVNvMnhHdWlPK1F2?=
 =?utf-8?B?SU1FcTYzUVVBc1o2eTFGbWRvNDdKakxCTDlDV3VrdGtTOUNuS2IvSE5lUzRu?=
 =?utf-8?B?OXFERis2bEppbDNwQXg2U2RCS3lSOFdFR25qK0ZOUjhCYmo0cHNpdVZpQmtn?=
 =?utf-8?B?OHlaaVAwaWRmaUw1RnJEWFNEOTZuY0pZZmF6VVRjQVNVdEFnNmpIdkFSTFZG?=
 =?utf-8?B?TWkzTW0zS3EvTWN1QUdmSUh5Rmw4WnByV3NPLzlVUDFKZHN0MXNSeXVLL21H?=
 =?utf-8?B?UG1nOUI1b0o5WEVCQ0FCTkZjYzNlTTdwdjZ1QWVSN0ZJVFNSNXJhOVpodHpw?=
 =?utf-8?B?ZWc0Q1dLNUVaM2Q1OUQ1M3VJaENYUHFvRkdoSklEcjcrc2swb0dva0RqVFpG?=
 =?utf-8?B?U1hKTjdSN1c3YWpCL3J6eEp5dWEyRlVHZEs0SXpuMHZyNVJOQ1Npc2VPUWVC?=
 =?utf-8?B?dVl5TVNUaGdMRnpOYkh5K0swejBrR0F0RmM4RUZqTjNROVVQOWZNMDRNUVBv?=
 =?utf-8?B?QzRYSFNRMkV4Y1RvZGFCMmV2WE5iek9KYnphMGFobnV5MmJmRnQzaTVwcEx5?=
 =?utf-8?B?Q0pGV2E1dXAzd0RYVUtNSVJLa3dNRS9xay9FeVNPUm5JRkd2eWpCbkV2RjBB?=
 =?utf-8?B?YlhLd0h5Zk1wNnVHQ0t5V2pHL1BPZUhTNGdaZTNJWSt3dWdaRVcwdXlta05z?=
 =?utf-8?B?M2hYYWVyRzVQUXpDeWZadjR0azdVekkxcXVHTUtaNmdZcmRpaEtadzlTdDRs?=
 =?utf-8?B?WSs0d29IU1l1Qy9qL1ppZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlJETmU2L0J4cmQyTVJUbFFXc0tDZXNQcEJPK094S3ZVVVFJTlE4ZGtEd3I2?=
 =?utf-8?B?aUoxQ1ZEVFAxWjJMWlhROUkvTXIxblFTMVJEeENib3hEKytMRXhDeXA4LzVs?=
 =?utf-8?B?VGFFck0xbkJSY2FFQk9xU1hZeEV0VHB6d2hjN01OSW5PMXVHWkVSZWhyK3lT?=
 =?utf-8?B?SEFpRkl2SnFMaU5tZC9nL0FzTDIvVCt2SjZwcVpJSWxkNmtFSTNtWm9MdGh0?=
 =?utf-8?B?R1FCNXZMRnA1Q3d1bDVoTHV1VDFsd2NzRTNxVUZmWG1lNS84RmFSRTMyL1Nl?=
 =?utf-8?B?OFhYMWk3TTdEWkg3WVQrY1FFbXBXR1hLN2pXOGlZbnpSZ2FSM1ZLZVhyRzU2?=
 =?utf-8?B?MTFPUW5ZM0FnM1lVUTVEYzNwWDZ2MTVsaXpvQmUxVThOTDgzbEhjWUkvV1Jz?=
 =?utf-8?B?eDVVSGlCb0dEMnphMjgwYVEzamlhSzlocFN2R2ZBSVd1WmZuYk4zRVd2WlZh?=
 =?utf-8?B?Qk1ZYUJXWEFldVBNNW02OXM4SmI5aUVFZWxISktDZjVzUFRnRXJjTi9xWExL?=
 =?utf-8?B?QldiekJoR0V4SEJGUjhuMHY3TG04dERLYkJXbzY3a0NmVkgxRHIySVFnSUxL?=
 =?utf-8?B?QVUrcDBrY3QwSFlvZncrY2ZlQnk1ZEI1cjJWK29wdXd2M2VIU3FEWk1WdXpy?=
 =?utf-8?B?SWVQTmRRMGoyeUcxUEZTNWduNnh2R1VUYWNqemRGZmhwVkFDOE5wV1l1RFJ2?=
 =?utf-8?B?Wmo2VStFb2JhN3JxNGhxR2lKWS9XWk14V2NqeEkraGpYM3Fnb1hmclJwZGZ5?=
 =?utf-8?B?dHNXa21SMlp2emZjdHE1anB3N29OYU1sdTFZdWFIVzdQN3BLZHlnemZyemVj?=
 =?utf-8?B?YzBPblIvajlBVHFNMmtzdWIwcnRZd2tGRnhWTTFJeTNsYm1WNWI4SThxRGY2?=
 =?utf-8?B?YkZZNGlSakYvSTdHcks3YlQ4c050RDNEQzM1TUVHZkw0VXhSbStEWlR0bnNn?=
 =?utf-8?B?Q2Q5UGVCL3FMQ3hRb3VhcStJYm5WbWJ3V0l6cStnYU50bm9VTVZSMFBxYVJq?=
 =?utf-8?B?Y3dmL3ZKYmQrSlRwMXVBU3NSTFhhTnB2TUxzbkJhV1FhRDJocm1jVnNKeWJM?=
 =?utf-8?B?ekxzMTZYNzRJSmc5Q29JMmdjSlV2VDV3d0JEVzE1TStlRFZoVjhUU3N2QmNs?=
 =?utf-8?B?VzVOZ2ZycCtPUzR0UHoxeXJEQUF0ZndsUWlrU0JJQlcwa0M0L1NSOVUxeUJ5?=
 =?utf-8?B?S3B2Kzk4MWY2NHJSOVRPcWpuQitFSktNNnQ4eEpEMFVFbEV5RDZRNUNIdk9m?=
 =?utf-8?B?Mnh1RStnaFZPV1FIUVlUZzRGWmg1clpmbGJpbE5lc0NPYzdGUnZmSVpPeVRx?=
 =?utf-8?B?cGlla1lOM0t5Nm4vSzVKL24zYVJKUHVGUUpRYzZQZG9XU25hb04raUZSRGp1?=
 =?utf-8?B?clZYOVJaNHpVZHl4d21UMjU0MENvN25WT3EzT0dKcDVQZHU4UERlVmdHMlhp?=
 =?utf-8?B?NWNHUGgzMnJHaUtWVWZadzdRemhpNllmWEtCcDJ5aElGdUJnMVQzK0oycGti?=
 =?utf-8?B?a1ozRWpHTkp0RE9WYSttOHBicEk0NS93cE9wOUlWM0U4MXhqK2lCTlY5R01Q?=
 =?utf-8?B?UG43OUl3KzkzVzl5N1lYek5JamlCZzdxL2E3U2VPMWxmL3pZUTZsZE1iZGY5?=
 =?utf-8?B?cVpKUmh2Qy9HZlJ6ZWdKVi9ra0lBa092TUZ1MWVFcm5sS1hxbFR0eUQxSkdi?=
 =?utf-8?B?aElmcHhPVG5YM2lmeUVHVlNFUHBFR3JMaXhjbEZXOER1WHZDdk05dENtRkl0?=
 =?utf-8?B?ZlUzVk42amt2T3ZoZHJPT0t6Z3krdWc2ckZnbmdUVkZQV0FSRFJzL0ZhZCt3?=
 =?utf-8?B?ZEtvaTlycFVQRm1QSVkyVkFyV2pmUHFMSmRPaDlUR29Lc2IrbWFnL1RFTVRJ?=
 =?utf-8?B?SDcyYUw0cGhCRHNWVlk1SUN3SlgvZUFmekhFeEZRbERxdXdvdnkxVS92WjV6?=
 =?utf-8?B?dTdjRDVlSkJ2V0dRMkZRbXM0TldrY0Y1K3BkTzRQS0k5K0ZyWDdYNzJNRHlt?=
 =?utf-8?B?YklWbVBUL1N3d3hVSjBKOFlzSEdjb0dkYml1SmFYVnMvekYveVdsNm9IWSsw?=
 =?utf-8?B?a0d5dURaRmZIdEI5Y3VEUmxvcS94T1cySTZkYkszdzAxaGNZRDRJc1dpcC9s?=
 =?utf-8?Q?nheOTtXPJ2Ee1gb02uaH99AhV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a910bc-4a35-4c97-6572-08dca4a537ac
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 08:07:49.3303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WZav9gEVjro8kGTYcHIfMRqDfwYqtS0kCMQXxVZ1Z5osZEyJRJ7iWWX5ag1FqR7I7j5sSYvkmTNfMaIIieN/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7193
X-OriginatorOrg: intel.com

On 2024/7/12 02:37, Jason Gunthorpe wrote:
> On Fri, Jun 28, 2024 at 01:55:32AM -0700, Yi Liu wrote:
>> This splits the preparation works of the iommu and the Intel iommu driver
>> out from the iommufd pasid attach/replace series. [1]
>>
>> To support domain replacement, the definition of the set_dev_pasid op
>> needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
>> should be extended as well to suit the new definition.
>>
>> pasid attach/replace is mandatory on Intel VT-d given the PASID table
>> locates in the physical address space hence must be managed by the kernel,
>> both for supporting vSVA and coming SIOV. But it's optional on ARM/AMD
>> which allow configuring the PASID/CD table either in host physical address
>> space or nested on top of an GPA address space. This series only extends
>> the Intel iommu driver as the minimal requirement.
> 
> Sicne this will be pushed to the next cyle that will have my ARM code
> the smmuv3 will need to be updated too. It is already prepped to
> support replace, just add this please:

thanks. So your related series has made the internal helpers to support
domain replacement in set_dev_pasid path. The below diff just passes the
old_domain across the helpers. Is it? Just to double confirm with you. :)

> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index ead83d67421f10..44434978a218ae 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -350,7 +351,8 @@ void arm_smmu_sva_notifier_synchronize(void)
>   }
>   
>   static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
> -				      struct device *dev, ioasid_t id)
> +				      struct device *dev, ioasid_t id,
> +				      struct iommu_domain *old_domain)
>   {
>   	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>   	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> @@ -367,7 +369,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
>   	 */
>   	arm_smmu_make_sva_cd(&target, master, domain->mm, smmu_domain->asid,
>   			     smmu_domain->btm_invalidation);
> -	ret = arm_smmu_set_pasid(master, smmu_domain, id, &target);
> +	ret = arm_smmu_set_pasid(master, smmu_domain, id, &target, old_domain);
>   
>   	mmput(domain->mm);
>   	return ret;
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 238968b1709936..140aac5cd4ef57 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2943,7 +2943,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>   }
>   
>   static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
> -				      struct device *dev, ioasid_t id)
> +				      struct device *dev, ioasid_t id,
> +				      struct iommu_domain *old_domain)
>   {
>   	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>   	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> @@ -2969,7 +2970,7 @@ static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
>   	 */
>   	arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
>   	return arm_smmu_set_pasid(master, to_smmu_domain(domain), id,
> -				  &target_cd);
> +				  &target_cd, old_domain);
>   }
>   
>   static void arm_smmu_update_ste(struct arm_smmu_master *master,
> @@ -2999,7 +3000,7 @@ static void arm_smmu_update_ste(struct arm_smmu_master *master,
>   
>   int arm_smmu_set_pasid(struct arm_smmu_master *master,
>   		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
> -		       struct arm_smmu_cd *cd)
> +		       struct arm_smmu_cd *cd, struct iommu_domain *old_domain)
>   {
>   	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
>   	struct arm_smmu_attach_state state = {
> @@ -3009,6 +3010,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
>   		 * already attached, no need to set old_domain.
>   		 */
>   		.ssid = pasid,
> +		.old_domain = old_domain,
>   	};
>   	struct arm_smmu_cd *cdptr;
>   	int ret;
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index bcf9ea9d929f5f..447a3cdf1c4e1c 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -828,7 +828,7 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
>   
>   int arm_smmu_set_pasid(struct arm_smmu_master *master,
>   		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
> -		       struct arm_smmu_cd *cd);
> +		       struct arm_smmu_cd *cd, struct iommu_domain *old_domain);
>   
>   int arm_smmu_domain_alloc_id(struct arm_smmu_device *smmu,
>   			     struct arm_smmu_domain *smmu_domain);

-- 
Regards,
Yi Liu

