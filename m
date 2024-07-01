Return-Path: <kvm+bounces-20750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3583D91D744
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:04:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52A9C1C221C8
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 05:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1ED336126;
	Mon,  1 Jul 2024 05:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GqRBi7Tt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351AA2F29;
	Mon,  1 Jul 2024 05:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719810285; cv=fail; b=GjPilXIFpcbSSp194lODMnwnGTemx6gPRR0Cknz+sYW6fj2P0ofCBWNFssGto9ZvhA5p1fas6DMzMzz6/Dja54iQI4WlaRUiHe8R8mq5USbhdu2yL1pfs/rqJNCKNRovb3VZU5/sFT9E7iYFU6MH6G5Qaka7uaGZii1G/WU/tHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719810285; c=relaxed/simple;
	bh=hjv+lYOoe4pJI9fGPG4S4Ml6aQJG8LyAbcA1man5owM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TbRYYjayWXsW4dcuQGjwmHZEqx96AtzFsHHUsL2Lq3Ck9/R07NRicWqUrYBNKOE9M2KiDEbGftKwJtik7pMnG6CjL531IUtRKq3e3b4D5tw7/KkoZbWwTy525taTRwBGdpfmaeWIDRVPPjCE0fTac1s2y7QR0NqhrJN7Bb0iqvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GqRBi7Tt; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719810283; x=1751346283;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hjv+lYOoe4pJI9fGPG4S4Ml6aQJG8LyAbcA1man5owM=;
  b=GqRBi7TtG8+kFcMGlKypbL70TckRpE7PQt4f1o4FHQQGT9U8pMUweZNU
   TgWCaa7Svlxx65w0clf99G0WB65E5W7o7ef5Gr2DrRCkmDk8Q/0C4Rbac
   9ciMLJRHR6Sghkkpod2Lu7f+sg1QInED3E7zHIBtipWD8rqcMvyYdrXb5
   uFb4E9H/lTIgQSJQG+EWDerM7plH6QOE9mmM7wBLYm7x0nLOprY+Ah/ri
   r+8i8CcQ1pSKc+M0dRiHVOP+7/F6Hy9+f9n0yl24vy6FiR1k0o04xWTjJ
   RtN61xaTXJxEFHCdf8rtijn+nwePehAhGu08J1Xi0THwHHIKAW3e2qNGx
   A==;
X-CSE-ConnectionGUID: rA4CYk6AQwGjU/Ekyk7SCA==
X-CSE-MsgGUID: O/g/CocYR4qaKJKo6CRheQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="34356798"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="34356798"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2024 22:04:43 -0700
X-CSE-ConnectionGUID: +gMhVFdKTbWUqAApVneiOA==
X-CSE-MsgGUID: wfjaxE2BSW21qkJa/gRXbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="49847033"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jun 2024 22:04:42 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 30 Jun 2024 22:04:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 30 Jun 2024 22:04:41 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 30 Jun 2024 22:04:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 30 Jun 2024 22:04:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLRvq8TSrgDnEKhlQcMxzokAEavnJW7QtJFoSWzyxrNXNk5MN+8nG8lq8AbJWh4fe7iLsC3wr208FJod+14kyHlm6BhleiqHkURWW2Ig3KFGznYs/6E/QH3h44cFAOP9tTBJQwybpztd1OiqPSfpQ65WLnIWoKao5ehsB0JQ6C27oWC9Hiw5w5mUhxPyf+lAvRxLQulN3EuBOGmKNffUasi7C0VNdTEXftVm8BDqKVJ7FZs+GPTDA0n1KXq/V+IXSY9M9rswqYcoyyIo92yVt17XZoD5xrQE4DGl/ufHAhg36PLH3IReTDT44fNFqhYN7jMS4717ttyaHYnZIOWoKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwlPhTeG6hyO38JjA+p54J9QtbT5FLqZrn9MJvptAKM=;
 b=TmQVvHbueUkSWQsYLccKUp1x772mY7CAMUEqN11J5dlJjBhqy7+pnTDcALjjG2smyhX1ZzhzWgovQ2KqtQhWB2u55WYuyOf0ATZ68V3/VE9H3/9lnkMcvJRDtb+scydldt4sFsIpRsXM5VX4pcnZEQsXGwPs00gLnnxO3pfEiYFokZz4CcPZzPGyERkOM13VWofC4hibIZAGJgSOIl7+TLZmKj8MRORIKe+E3eHkiiWOfAjHgBqqWE5eEyeSAUg0hvAoNxuLb38MEi9GejTtGOwx94fAGzNqN/k8+7gHErJjrD2L/Ji81wEFi2jE7vzYF5g2jSLTKTni+JFyA3wpZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB5130.namprd11.prod.outlook.com (2603:10b6:806:11d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.32; Mon, 1 Jul
 2024 05:04:34 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7719.022; Mon, 1 Jul 2024
 05:04:34 +0000
Message-ID: <5187229e-3f0f-4af3-b3f9-4debf68220fd@intel.com>
Date: Mon, 1 Jul 2024 13:08:30 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: Get/put KVM only for the first/last
 vfio_df_open/close in cdev path
To: Yan Zhao <yan.y.zhao@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>
References: <20240628151845.22166-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240628151845.22166-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::19) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA2PR11MB5130:EE_
X-MS-Office365-Filtering-Correlation-Id: 92a7345b-5f2d-42ca-7694-08dc998b4c84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NUtVamtPTDM5ZDJUQjJvTVV0d0VhczBZbkpiaHZLaDFOR243cXpWZ3NhbjZT?=
 =?utf-8?B?dHNoejV3R2RFb3JmbUdMU3dBcHhpR2hHYXBZcEN5RGIyWTFWb0RmSzlDdlF1?=
 =?utf-8?B?OW9aQVdielpoQ1p2NEp6eVhxUDZVYWxzTVBrYm96U25nbjhWaTdiWlo3SVN3?=
 =?utf-8?B?dVRJalphOEgxeStxbEN3RjVpNGNrYzdKVUluUlVtSTBja1NhSFQ3SVkrWWZa?=
 =?utf-8?B?VG1CTEdQRDBBNkVoQkQ3YWlNazFXYUd4dzJCYUJDNFpQYktwRUVDSXBrNGpV?=
 =?utf-8?B?YWhFMWpnRGpXQ1UweVR5MjN6eExMNkdvelhYN0FHeXpPL0RWTCtYLzFhNGk3?=
 =?utf-8?B?R0FGVFIxcGt5amtvaW5TMTlsL2dTaWdRWnFpMm5VY2djN2hnQjh5OXB1d21r?=
 =?utf-8?B?VCtHWlMrWlcwcmJGN3dZbUFhUHZXbCtkamZxb0E5OTkxQ2tPRi9VTTJ4cmVE?=
 =?utf-8?B?dVF0aVZDb2pkUy96QVI2YkM5bFYrUmJkdDhsYlBhVkdEei9vNmhXUWFpbEdU?=
 =?utf-8?B?UEpVeDlWbUpaSVlhZUd1Wi9YcnlGQTIxMkVNeFVCb1lYd0NCUVVZNE91WE5R?=
 =?utf-8?B?Z0lqVitDeE90Nm13Zk5URExGSTFDYnUyTXpBWFBTQ3FBNnNSci9FcStRWGpP?=
 =?utf-8?B?WldJL0JybmFzdHNoMHBvOGliZEdTQVpmZWRySXYxWmRFeUVBaGVYSHd4TlJm?=
 =?utf-8?B?SG9Pc0hEejZja2FvM0k3bmo1OUgwdjVJMHJ0QXl0d2x0dVVpV2xlOXpPSzhW?=
 =?utf-8?B?UjNoRCtkUHgyQnRSTll1THYwS0hneERDMlJhWXR4WDhsUFlLTnA2Wlo5N1pQ?=
 =?utf-8?B?b2VkelNrK1RWcnJ6MCtNUlRjTythWEpMb0YyRHJYRDBERmtzSkh1RHpQQkNk?=
 =?utf-8?B?VjBvSU4rUzhCYWxjZ2hJMy91TjJJV3ZxaDJBc2JqWGxsMzF6UjZ5c3pLWU5z?=
 =?utf-8?B?UGliNmdVbWhyZ1Rsd2F6YUw1eUNDWDRWV3hiMldyUlZPb0dhOWp4bHVWNlcx?=
 =?utf-8?B?WVJvYkU1bWtXOEtWcGh1czY1Lysyc1dSSmJ6cnI5YmhCSkhDSUQ3NWU5eUVW?=
 =?utf-8?B?MmFObmUvUFpGWkpnNFU4bVJiVzYzTmNidmltYWZMdTAyUkRrUFlMMU5UOW1n?=
 =?utf-8?B?OWpXcGduSmpFWUhHRlpUWEN1QWJ3UTdYdWdzelNNUEdSUHpNWFlDdkEvUWdw?=
 =?utf-8?B?Z3JVL2pVWTdJWmxHUmIxcEFFTFFsek14ak1na3J2eHRDOVV0Yk1YQVFnYXp0?=
 =?utf-8?B?KytXeC9DMVJEUnQ0bEI3dDg3VTMvcXhnU2R3Y0Jrb1pZdmh2QU8ydFJHdG12?=
 =?utf-8?B?UlFjVTcvZU96d3BFeWZwazBCZkpIcHRlWUxSU1h3REptRDZTWWl2ME1iaWtw?=
 =?utf-8?B?b1B1dko4RnBWcTJZMGg2RXlVZVlNRXBUeTFHQXByY3BLbGJ6cTJyWmQvMHMw?=
 =?utf-8?B?a0VuVlRHVXhOWDBrakdvZVlaK1Z0SkJTREFFQTdOSjgrTnBsaXR2a0R1cUNZ?=
 =?utf-8?B?THVtRUF6SlJ6MktKQjJCWEY3cDk5MGpuS3FSVDhhMmNKY21POGF4b3Vsamxv?=
 =?utf-8?B?SE9SWklhbDBWbzd5ZXJyUmY4aTVva3RPUEJ3WStzbm56aHRMSGZUdEd6Zk9x?=
 =?utf-8?B?ZjBRSXkxalFITnRjYkNZUll5UUlkY01LSmtZdm1OYldTeHJMZVdscEsxV2Ju?=
 =?utf-8?B?N2RCYTlnQUdleDlIcWlwU0JwWHZFMlpBQmlwQXRMc1R2SUtiWFJQbGc0amNT?=
 =?utf-8?B?MmZ3QlhCQ1RhTFJDMmVESVFMOS90NmYyUW5qaEpzUk1hU2R1WEV5VUl0WXR5?=
 =?utf-8?B?cHAraTdJakRXQndaczZpUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTE5d2tZTUNMdkxUM0Y1TEtxZnJ1MEZWOU5kUHJCTVFQTVZQbnhUZ3YwUGwv?=
 =?utf-8?B?NUFnSWNUWlRqT2lwcUc0akVpT2FPQXZGTkI2L213eEEzZjdCbmdMdUxFSndy?=
 =?utf-8?B?OWF2aFdCbERMdHFkQU5DazBVdGlRaGRZSDZiOFlkUko5ZTYxaGNSemZDaW92?=
 =?utf-8?B?eW5GcjY2R1RiTWs1UENOa3ZlcFJGZXRHSzQzVi9kR0NRZ21EYzFTdGYzb1ZC?=
 =?utf-8?B?VnhaM3J4MUg1cWlHcEhPWGs2THVqejJhRlRkYng1Z2M0V0h4aEZnOGpQT3Vz?=
 =?utf-8?B?TCtSQTV4S3MyQlM2aWlqSFhWcDFSbG5qT1ppb0l2bG83bXYxM0tjOHpQNU1L?=
 =?utf-8?B?Y2txUzlaOEFBTURyNDhhcVVkbXM3aXNqcWQ5Q0w5OXlaOGJ0dFhBMEFCYk1l?=
 =?utf-8?B?cUk2Snp3OGdobGpXZUZKek5tSElqOCtpRk5FcUdSRVJFc1ZxUk1SS1cxUGhN?=
 =?utf-8?B?R1EvOUJmY0RYVjBxeGFyWGdkdHdUdnF1VzE3d3pMWkJoeVlnQXFBYnd3R0pu?=
 =?utf-8?B?cmU1amRnRjhYazBsKzEwVnBqSlFTcEhEQ3NQOFJLZWE5YnJyVEViOHVSM29l?=
 =?utf-8?B?amJPa1FYdlBJL3FLeHFCV0tBMzB5L0JGY2VoZ0lMR1pVdzVjdVVFWWVkQUhF?=
 =?utf-8?B?dHl3K3lwQWRGT3Y5UjdJL3JkRTlrMWpqL1MrY1phWUtVQWVpQVlmRWlJQ1FX?=
 =?utf-8?B?UGtHWjFXcDc5L25wSDlDYjZZZ0hQYlg1K3M1alFlK1ZnVUZoajVFa0Q3YjNZ?=
 =?utf-8?B?WGhpMGZucm4yelNzUkVSL0hMcE1aMzJBdHZ3M2tXKy8xK1BOK0tNTXVsTkZi?=
 =?utf-8?B?WjBYU1dtNjNvTXlPeHkvQVJ6WTBNeEtIMTUxaW5ZQ3dtVXF4Ky9uRjBLY2Rw?=
 =?utf-8?B?TEhsRUt6L0ppMEFhN0NRR2tZcisvVUh5VU5CcUV0VXE5NXNFQnRuQU1WN0RY?=
 =?utf-8?B?YkJhK25URHhVd202cmZNdGc2K1lFOXlWYlZnbU9aN0o4VlF1Ym9DRGM5WUNm?=
 =?utf-8?B?a3ZLL2V2VkJJYUxCNjcwWU53T1dCYVJWUXFocTVFWCtaOWc4dDdKU0drU1JG?=
 =?utf-8?B?NUxHZEllblFsRzZWOEptU0VzaXpmb0JyZi9mc09SSmlKc253U1VnVkNVWGdj?=
 =?utf-8?B?d2lleGx2bURwd3FqMkxKYnkwTWVUTFRTN0FsZ3U2TU9Kai9tb3ova05RMkgz?=
 =?utf-8?B?NmJveU5KWVhlMlFGY0RRVEF6YVhxd1o3Q08yVCs2Rnc0VnVjT1NDQnQ3clZv?=
 =?utf-8?B?cjdiQUpWT0RYcFRBbVMxUk9DaGZKUk5GQUFLNXlkTUVwOVpQUUFoUDF5SHRi?=
 =?utf-8?B?TEd1SFpBS1F1RDI5TnprREVDSUFaK0N0VEo5bElIUXRlTmhuRFZ0c0RIYWo4?=
 =?utf-8?B?REJCSyt3b0l0cW9lTVUwbXZLUWFpanhyN2VXWk9uUzhFS0dqTk1PTFpQM0pm?=
 =?utf-8?B?QzYxWTVqWU5pcjVNam91RktUQ1JLV0NvK08xOVJyM2pRdk5BQkdMdXczMUNK?=
 =?utf-8?B?dnI5RnV5YmgvSWdXR2NaT2VEY3V0Z2R3QmZKNXdEMENHVkRwMDFtdkZURDZl?=
 =?utf-8?B?YUVsOE4rQms2a0t4ZVh3d0M5UWhGaVE1L0w4RXFrQ0RSZkV4ZS90M2dXenov?=
 =?utf-8?B?Nnl6ZWhwOUIxNU96Ni8rL2RFRFRsTk5oVFBvMjhJRitBblNDOE9yMUppQWx4?=
 =?utf-8?B?L3d2Um5ENzRaQmNHWHFxamMrc1c2cEtwaGVtVmloRnRUMDBqYmJlSlArYTBB?=
 =?utf-8?B?a2lTaXlxQ2hCSXZsUFhhVlFVSkVaSXVFTHlKdmhkczhGbGx1R3dMQTFpV2xu?=
 =?utf-8?B?NXhjdFFJaWQzVk9xZ1d1aGdZaWRubGd1UkNZc2ZQV3UyNmVLQU43WllWa3dq?=
 =?utf-8?B?cmZwMlpnTko2SE9POGtJK3B1cHNjSDFweHRzMXpBTEtWRTBoTHkyb01vdndB?=
 =?utf-8?B?TmRuaUE0dE9leStUVE91cGJsY2pxZ0hWa1ljWFBSREpvSndBMHY2T1BwQjhr?=
 =?utf-8?B?c250dWVBdmN1Nm5iVVh6SW5YYjZJSTZidnhTWVdmZUp1WnRGVkpDRHpWaGRT?=
 =?utf-8?B?TlFwMkZycFhDOE9LK0grNjdTbGgrY3RFdno5cERkanFGeEJJMVV5R1llQ3RF?=
 =?utf-8?Q?7FvZBykcMz5i0at4a/Mj08P9w?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a7345b-5f2d-42ca-7694-08dc998b4c84
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 05:04:34.5775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xa5BiXn34yNmb1kFoVS64P6bNNKZEr8EnJ2+Ncpo4MbH2ruWqMc/ueb0k6e1kM8EpKwiGB53BO/DDvtp8ei2+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5130
X-OriginatorOrg: intel.com

On 2024/6/28 23:18, Yan Zhao wrote:
> In the device cdev path, adjust the handling of the KVM reference count to
> only increment with the first vfio_df_open() and decrement after the final
> vfio_df_close(). This change addresses a KVM reference leak that occurs
> when a device cdev file is opened multiple times and attempts to bind to
> iommufd repeatedly.
> 
> Currently, vfio_df_get_kvm_safe() is invoked prior to each vfio_df_open()
> in the cdev path during iommufd binding. The corresponding
> vfio_device_put_kvm() is executed either when iommufd is unbound or if an
> error occurs during the binding process.
> 
> However, issues arise when a device binds to iommufd more than once. The
> second vfio_df_open() will fail during iommufd binding, and
> vfio_device_put_kvm() will be triggered, setting device->kvm to NULL.
> Consequently, when iommufd is unbound from the first successfully bound
> device, vfio_device_put_kvm() becomes ineffective, leading to a leak in the
> KVM reference count.

Good catch!!!

> Below is the calltrace that will be produced in this scenario when the KVM
> module is unloaded afterwards, reporting "BUG kvm_vcpu (Tainted: G S):
> Objects remaining in kvm_vcpu on __kmem_cache_shutdown()".
> 
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x80/0xc0
>   slab_err+0xb0/0xf0
>   ? __kmem_cache_shutdown+0xc1/0x4e0
>   ? rcu_is_watching+0x11/0x50
>   ? lock_acquired+0x144/0x3c0
>   __kmem_cache_shutdown+0x1b7/0x4e0
>   kmem_cache_destroy+0xa6/0x260
>   kvm_exit+0x80/0xc0 [kvm]
>   vmx_exit+0xe/0x20 [kvm_intel]
>   __x64_sys_delete_module+0x143/0x250
>   ? ktime_get_coarse_real_ts64+0xd3/0xe0
>   ? syscall_trace_enter+0x143/0x210
>   do_syscall_64+0x6f/0x140
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   drivers/vfio/device_cdev.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index bb1817bd4ff3..3b85d01d1b27 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -65,6 +65,7 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
>   {
>   	struct vfio_device *device = df->device;
>   	struct vfio_device_bind_iommufd bind;
> +	bool put_kvm = false;
>   	unsigned long minsz;
>   	int ret;
>   
> @@ -101,12 +102,15 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
>   	}
>   
>   	/*
> -	 * Before the device open, get the KVM pointer currently
> +	 * Before the device's first open, get the KVM pointer currently
>   	 * associated with the device file (if there is) and obtain
> -	 * a reference.  This reference is held until device closed.
> +	 * a reference.  This reference is held until device's last closed.
>   	 * Save the pointer in the device for use by drivers.
>   	 */
> -	vfio_df_get_kvm_safe(df);
> +	if (device->open_count == 0) {
> +		vfio_df_get_kvm_safe(df);
> +		put_kvm = true;
> +	}
>   
>   	ret = vfio_df_open(df);
>   	if (ret)
> @@ -129,7 +133,8 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
>   out_close_device:
>   	vfio_df_close(df);
>   out_put_kvm:
> -	vfio_device_put_kvm(device);
> +	if (put_kvm)

you may use if (device->open_count == 0) as well here to save a bool. 
Otherwise looks good to me.

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

> +		vfio_device_put_kvm(device);
>   	iommufd_ctx_put(df->iommufd);
>   	df->iommufd = NULL;
>   out_unlock:
> 
> base-commit: 6ba59ff4227927d3a8530fc2973b80e94b54d58f

BTW. The vfio_device_get_kvm_safe() is not supposed to be invoked multiple
times by design as the second call would override the device->put_kvm and
device->kvm. This does not change the put_kvm nor the kvm though. But not a
good thing anyghow. maybe worth a warn like below.

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index ee72c0b61795..a4bead0e5820 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -408,6 +408,8 @@ void vfio_device_get_kvm_safe(struct vfio_device 
*device, struct kvm *kvm)
  	if (!kvm)
  		return;

+	WARN_ON(device->put_kvm || device->kvm);
+
  	pfn = symbol_get(kvm_put_kvm);
  	if (WARN_ON(!pfn))
  		return;

-- 
Regards,
Yi Liu

