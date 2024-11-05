Return-Path: <kvm+bounces-30695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61B709BC723
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 08:40:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3B841F21C5C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B511F1FDF9D;
	Tue,  5 Nov 2024 07:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BEOP/U53"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B672EEBA
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 07:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730792408; cv=fail; b=L4USNP33HgKlzwEUBALs/h/fh3b0tXgU2Vrt/EOyphaIFngxWw4wPIBwMOSlkmi4qMnccpRLB5J/DDOlbajpTG8CNDElaTfGEVEfc8dC+IHHMC39JN/0QhR7GJ1nF4IGBsN2cvyEr8D+oUxmXj06Qf279wL0ZZbttPLJL96wd9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730792408; c=relaxed/simple;
	bh=f31i6h7bQKH9CIp5hYtSuPq9HGO6elREgsV036xTLMc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BunGzqH0oyeUCycMNvC/MzqTAEQ6y3lDLZ1Fkof/hjer82vdFyYnO0dmy/+peh7i6BjZM3/Ud7mmI2Cn/Rea3QvBqaixF2iLhIrDkjlRlDf/gYqIizTLKKQJ6oyaOkOnukfuccFbhL31EAwBvpzXcDG6zXjt993ihgMMCldm3uk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BEOP/U53; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730792406; x=1762328406;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f31i6h7bQKH9CIp5hYtSuPq9HGO6elREgsV036xTLMc=;
  b=BEOP/U53BQEVmV+XP2/kOGxT1hE6Xcb5J9A58cZgSJ7vYPy2ADbTPONy
   hRFdPjAyZCXApz0HOS6MjYjHToub28Ay8wxIdo0eXgjkKQwK2WGx3Y3KP
   vK7ob8NZ7YOQgup/SM3gMN+hy77My7F8j/SwfvOujJD7Bjj25h6gMvrAN
   3cSHGdlbP2SLg72W/HjgabSF7zUyH3WQLZYgSVUnxCR12E4ig1POuOWbe
   hl5M+6KHlR0/7+PZv7hM8omQOg9Jz1Jr1cTbx/EfBi2IrDqCpBmkSHQk8
   KalJbud9VY9alFvEB29Sc/TDiGXfttYieEZrvSIA5Ri4tNbqeYD78JYyS
   Q==;
X-CSE-ConnectionGUID: q3NOCrjGRkKMPIwS0Pi36A==
X-CSE-MsgGUID: u/ztFpDlQjupDUnXdxhGYQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41893404"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="41893404"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 23:40:05 -0800
X-CSE-ConnectionGUID: UlNDj9r0Rs6qQIkwwTOFwQ==
X-CSE-MsgGUID: BnS4UEXbSYKlH9CtbBXKXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="107240711"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 23:40:04 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 23:40:04 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 23:40:04 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 23:40:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j2WUtJe+XwEi9m5PtH5DDbZywEqkDizO3MV1hAQqTO/tutZTjTE0aF0/Ov9w6ikgu0nkM6Zuuw3TDcnCZJlh46Tl6hH/b1a7JzpK2rU+HnHF1fyTVab4f+46toL92DJGHUyg9k3YLbheBoRYBvOMq+/FCrO4jWmuwG/eOiaxFvd+gwT99b9WEKxyu/jpLxmV7p7FnuHDU3W3ysFatQAElLfYzMPpgyVROOKwR3a2n4YZ8Co07hcGGyktLxyUZcb+xxzOy3SmMbYbP/i0kp7U318tg+STBNXTSwfvx+en+8QoBMJhFClLapmgU4QKdSSOX3+lqIRfNRgaQfC8uv/RKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yZR08UmHJjQJuCHqHZnFQCHSoztHcrqmIjorrRJY2z8=;
 b=ISH4Q2zx8WyKFb3LXqF0/49Cr04V19kI7IHiXaRA/xFR8FGgE2UuPJWGc0qbR/q5dbLc885XANpH/WuJGvE0ozW+M/1R4Hi1zM9ZDsbWOlXZFGZYEgbilolRRzP4THmYvsnK8smFTiTWCo40Pj4rdsDOVoqIL2tw6k9nwGul//VksLFeulHCyXXxtyciDflIjvuxD/RsiDHEvKBoIyQjrInQ9Fjym5bawVl52X3nopel8IdV4wWnr7OXFZMR8QJCeO4HlD3QinTNjDiqgRN8zpMYj9dgULhWbYUJ275h50oB3xcIbC+OHg3vDGz3tPaxrzq7vh3J5ViunEjpTUErQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by PH7PR11MB6905.namprd11.prod.outlook.com (2603:10b6:510:201::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 07:39:56 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29%3]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 07:39:56 +0000
Message-ID: <dfdc9aab-cb30-44bb-9fb2-397c60150e51@intel.com>
Date: Tue, 5 Nov 2024 15:44:31 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support
 pasid
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <kevin.tian@intel.com>, <joro@8bytes.org>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<baolu.lu@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<vasant.hegde@amd.com>, <willy@infradead.org>
References: <20241104132732.16759-1-yi.l.liu@intel.com>
 <20241104132732.16759-4-yi.l.liu@intel.com>
 <20241104140020.2c98173d.alex.williamson@redhat.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241104140020.2c98173d.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0003.APCP153.PROD.OUTLOOK.COM (2603:1096::13) To
 SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|PH7PR11MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: ef6eb260-12d1-4ead-ef59-08dcfd6d0b3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SDl1MnI3SUhDUm9VWlh1cEMzZnZOWFc1SW84U0ZoRjVRYUJ1VFRsLzNSV2h0?=
 =?utf-8?B?SFB5SXlvUFZqUGVLNUEvdm80SHhLR29YTnJVU29FbTN5UGpFbTVTUDVVUDFM?=
 =?utf-8?B?aWd5d3plWkhtZ1pIcHpuNWN3WTBmSU05dlo4M2FoWmtjN0JneWtpdlVyMVR2?=
 =?utf-8?B?SjVNRVFFbTY0bFFHK3g3ZHR5b1F2RTk2K3hmclkyRkJFMnkzQUJsM3JDdmJl?=
 =?utf-8?B?WU9GOWhRVXd1Z2JkWFNWWEZYR29jMWlXcDF6WmowWG9UM2tVeDU3c3RPWWlT?=
 =?utf-8?B?YTBIbjRnMENJT2MyU0lJaUFDQXVoOTVkNklkUnBGN1FNWDFvTC9lMkpnTmdW?=
 =?utf-8?B?YStNdzlQNERZZ3FnbCtuZ0d4Q3puVHEvaFJiOE5qN21FL1VNd2EvTFZsNyt5?=
 =?utf-8?B?QlM3T0ZVMGY3TGZDRGd6cWFJamViQ0YvdWM0UEJycXRUYUExYmxHajlBZ2Vq?=
 =?utf-8?B?RkNjZURRMFdDZ2xqeC9CdUV6UVd6TkdhMXR2VUYzUkU4TFV0d0QyUkxYdFFv?=
 =?utf-8?B?dFZjVE41QnVYcGcva1l4dGZnc1lxcmo4WFl4ZlpNQlBrN2RSbzA2SzNXUUdu?=
 =?utf-8?B?anJpekNIamJ4VG5hU3ZFdmlMTzh4L21WZ3NUcXBscUZuNG9QcGdwSHQrdTcw?=
 =?utf-8?B?ZngwMWZmejJzYm0yUmRMR01TdUZCTEEzcGM1MTN1NkNvUEVCRXBWKy9QRU9y?=
 =?utf-8?B?NGVwcC9LUkppWUh4SUIvekxFeDVJaGU5bmhqYUlMT2dvd0RWWmJWOWliVk81?=
 =?utf-8?B?Y2duYjNKa1pCV3ZnZGdTL0plZVB1clVzbXUxNSt3cE4waTF3TlZjT2dsK3VB?=
 =?utf-8?B?ZmRpWXp3aUhObnJlSmdrMjYxZVozM1ZoZkpnci90VHc3VHJqVW96SmxsSmtZ?=
 =?utf-8?B?UHdjT1RtL3RLc3ppK080SDFTZnlZbFc0akxXYzFQYTFwaGI5NDgxWVBoN1Yy?=
 =?utf-8?B?RXFRSmNnS3JtczczYWtZUisyWWpBOG9BdUFvbXFnc0FSU1hweU04MzJuckhj?=
 =?utf-8?B?R0NnclpwVXF2Qk9sRXZlMmlYWFVjdXhzdTFDL3Z1L1ROVkJtWm9vY0Y2eXBB?=
 =?utf-8?B?bVdYelRoWGJJaG1McnljNWluZGZxaFhJUWQ5bFFGY1lvbGxWeS9LM2x0SnpX?=
 =?utf-8?B?dE9USkZiREszdU5vR3JsUjlSV1YvZ21FVER3eVVDNmowRy9LQml6djBsSHpF?=
 =?utf-8?B?U2N2SVROa1NFOWlBREprdzlyalNFeFF2OTY0bGYwbzNWSWFuSEdudkNyY0lV?=
 =?utf-8?B?a0FSUTZid3hGKy9Mc0xjR0FaaGVlWUh6S2tzOE9yV2R3dTNNdEFMcWN1R2Z5?=
 =?utf-8?B?aXRPWVFyZlk3OTFoL2I5MmdVRmdqTDZSL2dSU2JQOXI3UWdzczJ5TjJycVBY?=
 =?utf-8?B?RFJ0RmtPTkptTlBUUkNmSG5NajU3TGVvT1I5UE91UUdHZlVFMTFYRmpGMGNv?=
 =?utf-8?B?VlZaVG1kVldYeEZpZmRmSUNkeDhQcTF1NDhFbmJhNFIzRkJMb0UySnA3ZVky?=
 =?utf-8?B?eklnWFc5U1RhT24yc2JXaVJzNjFPeE9NL2QyRUh2SVM5eDV1MHE1dXRGRFJH?=
 =?utf-8?B?aThRaThXcXZ4d1k5WUhGVzAzaTBrUmlLOWVpRUxRbWFEOWE5L1M1UnRITVJV?=
 =?utf-8?B?V2lnMG5hRHF3OUtSR0lNWk1MNVg3bjNJZjdiZ1N2eENaMTVGR2pvVXJHRmxn?=
 =?utf-8?B?M2IyUnZMcVQwRnhiL2p6WkxBdGJjMStCWEpFOTI3OHE0RUJTWjdXMSt3Y3lo?=
 =?utf-8?Q?LQJYSXHOmCeZFoNSLk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEJYS1Boc0RQdzZDd0JXYWlTdGdwWitucHdENkh6b1FFUVBLSWRGTFVUbXdm?=
 =?utf-8?B?NW81eGwwWGcvTG12Rzl1Z2J4S3d0ZG5sY1RQb1RFQjc3eHJoM2MvdmQyMzhs?=
 =?utf-8?B?ZmNlNlc4a0VLeHluTHg5NW4xcnh5TWdXRjFZVkVQaUNJWk4rd3RjN2pmblNF?=
 =?utf-8?B?OFpuZyt1K3dXL0doTjBESHRMMUh3MXdteWQ2ZnFkMlc5US9uYkZuOGl3QXRE?=
 =?utf-8?B?U0tsd05iOHdvTVJuYlpEQVgyV0NjN1cxWmNtOGg1ZFY5WDMxbmRpb29xNG1N?=
 =?utf-8?B?R2lRS0xiTzBsSDFjTFIvL3BhUytwTmJ1cnJENExmdW1XWklsTEFzVXFRL1NQ?=
 =?utf-8?B?TFFLOHFMeEcxT0dXek53S09LVER1cUF1NmtxTFZ5ckxrMnUxVUhyNjdSYldC?=
 =?utf-8?B?c1dTaUlUS21xMnFQZDhEa1NKR0xadUs4V2gvd0FxcGlkaHV6UWVsS0lYR0FN?=
 =?utf-8?B?N0prM2NYczJiU2kzck1weFRwV2J0L2RmU2RjRUxMdzExbFNCUTZVTUFPOTVr?=
 =?utf-8?B?QzAvSWRzeXNCanQwMmFVL0JjUUtvRHZRNUViM0lvajN1RXpibTJzS1lhajR3?=
 =?utf-8?B?T0xTejlnQUN5RStZcmtRditqZzNMRko2SHNLMkRNZWpkWW9DTWZseGczaU1r?=
 =?utf-8?B?Sjd3SkFERUxSUmtSL21Va0ZlcjB5V2NVejBhWlo2bVRsUFl1aG8zWmNORElK?=
 =?utf-8?B?MW9iZDEwenpJVi9mUGZ3TGZyRWh1M2RwejBmNWllUzB3dFRqKytYWUVLMzhZ?=
 =?utf-8?B?eGJJNWlqRmZPWDFoRG1rd0twTksycEdsZ1dyNXlMcW1haWtXeU5RY0JPM1Qw?=
 =?utf-8?B?TkJCZGEvUHA3OTZrTFlIYlBhd29seFMwVFpmK2NtVFRLMGgvdWM5SmNQdHJW?=
 =?utf-8?B?TmcwcUx6TFlneHNnb2RFQURsRXdqbGtITFNuYzJXZnROOC8yelQ3Z0tEZURT?=
 =?utf-8?B?aHhZS2JKdWNWZG9ZRVZGNUZMZEhQaXpiakE0SmdUU3FtdnBDSXp0RExZMFBX?=
 =?utf-8?B?eGZDSEREZmhiYStkTnowS29ZYndCcCthV3IyMVJuUmthbTRDc1l3VEVBcjZo?=
 =?utf-8?B?QXhkbnFmQytidktrUFYrSkR0UlVnajVvY2ZadXY5Z1E3Q2JzRDIzMzAzVkVN?=
 =?utf-8?B?SmhhUHV2cTFzd0lrckdwNzFFSW93KzNsQzVPTUdtVm52ZzNlYW8zSGZqcHlM?=
 =?utf-8?B?blNNTHNsZHY2L1BlZkkvVU96c25hTlF3ekdvcTdLT042bXBPQlN5V2F6S1pE?=
 =?utf-8?B?Zjk4RFIzV2c0NEpNZjN0N1QxR3pDWUxpRExCaW93aWtqckp1Y1dZL1JtTXM1?=
 =?utf-8?B?Q1B2cWozV3ZlclhPek9WNXdNeTkyZzVuencxOU5wTS91U3kxelh0QkYrSVdw?=
 =?utf-8?B?a01iK25vZTJmbzlyelhmUVh6a3JjZEZZU0EvdjBXZ29NMU1EalpNWm5nZHRk?=
 =?utf-8?B?K1hMc1h0NU1MYkZkM0lHNGMvMkFXQUNTS2ppZUp3Z094UUpBcm42UzNPZU9N?=
 =?utf-8?B?SnBoZlhtUm1rZlJpZE5HRDhtMjNXTHlnY3YveGtlZjYyamhTbitrS0REWUQr?=
 =?utf-8?B?UHFQaStnK0VvM3VjRmJuMWFkVmRUVU84aUpyRndTTDJCaG1BMmJqN2FxcDdm?=
 =?utf-8?B?c1pRaHkwdmU4SGprbWppelhPbzl4ZFV3RHNKNkFielJNNmhtQnZiRDZTTTE4?=
 =?utf-8?B?NUdNNlNDcmZYNVk2NFdqei9XSkZXN09kOXBMRDNlcEo2bXBEQlEyWDdjUWVi?=
 =?utf-8?B?Z3Z6TGtFZDNvUGgrNTdQNE43djdQQm1aMFdyNVJwK3N0RmY4QkVLbldiY0s1?=
 =?utf-8?B?NzFNV0VsVHVmaytMUEJrWWMwVmVXYkZMZ2Q5Ti9hT2FTdXg4Ti80b0t4WGdK?=
 =?utf-8?B?MkZpZWpyeTNTL2ZkWWlHc0ZBRFRlSHNiWXVFRmk3Uk1LWVVaVm1SNzg0aE41?=
 =?utf-8?B?ZkJqN2ZSUjhRUmhzR2d2c3pTbEw3bDJqUnNUaXpTZkVzbEt6TkFmdzNFZW9w?=
 =?utf-8?B?VmsrRDFWSHJKQkRUeU9kYXdmc1RpeDRhSTFJSmNnRHRJdy9yNytMT0JjOVQz?=
 =?utf-8?B?ZjlDMDdieXZzWmc5RmhKdTVNTWR3WlZveGxCczAxbG8wNzNlcUlsNWlUMEQ4?=
 =?utf-8?Q?kfFTDhNhL3nwFUE37o+Vch5M2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef6eb260-12d1-4ead-ef59-08dcfd6d0b3c
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 07:39:56.2742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dMCevHQx4C2zP3NHohSoFcdDrB7+6/I5Ewzcq5wVte09OuQ/US+h/TD9IUycsOUFxjxPt+DQ2oO3PaQqooOnHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6905
X-OriginatorOrg: intel.com

On 2024/11/5 05:00, Alex Williamson wrote:
> On Mon,  4 Nov 2024 05:27:31 -0800
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
>> This extends the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT ioctls to attach/detach
>> a given pasid of a vfio device to/from an IOAS/HWPT.
>>
>> vfio_copy_from_user() is added to copy the user data for the case in which
>> the existing user struct has introduced new fields. The rule is not breaking
>> the existing usersapce. The kernel only copies the new fields when the
>> corresponding flag is set by the userspace. For the case that has multiple
>> new fields marked by different flags, kernel checks the flags one by one to
>> get the correct size to copy besides the minsz. Such logics can be shared by
>> the other uapi extensions, hence add a helper for it.
>>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/vfio/device_cdev.c | 62 +++++++++++++++++++++++++++-----------
>>   drivers/vfio/vfio.h        | 18 +++++++++++
>>   drivers/vfio/vfio_main.c   | 55 +++++++++++++++++++++++++++++++++
>>   include/uapi/linux/vfio.h  | 29 ++++++++++++------
>>   4 files changed, 136 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
>> index bb1817bd4ff3..bd13ddbfb9e3 100644
>> --- a/drivers/vfio/device_cdev.c
>> +++ b/drivers/vfio/device_cdev.c
>> @@ -159,24 +159,44 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
>>   	vfio_device_unblock_group(device);
>>   }
>>   
>> +#define VFIO_ATTACH_FLAGS_MASK VFIO_DEVICE_ATTACH_PASID
>> +static unsigned long
>> +vfio_attach_xends[ilog2(VFIO_ATTACH_FLAGS_MASK) + 1] = {
>> +	XEND_SIZE(VFIO_DEVICE_ATTACH_PASID,
>> +		  struct vfio_device_attach_iommufd_pt, pasid),
>> +};
>> +
>> +#define VFIO_DETACH_FLAGS_MASK VFIO_DEVICE_DETACH_PASID
>> +static unsigned long
>> +vfio_detach_xends[ilog2(VFIO_DETACH_FLAGS_MASK) + 1] = {
>> +	XEND_SIZE(VFIO_DEVICE_DETACH_PASID,
>> +		  struct vfio_device_detach_iommufd_pt, pasid),
>> +};
> 
> Doesn't this rather imply that every valid flag bit indicates some new
> structure field?
> 
> For example, we start out with:
> 
> struct vfio_device_attach_iommufd_pt {
>          __u32   argsz;
>          __u32   flags;
>          __u32   pt_id;
> };
> 
> And then here it becomes:
> 
> struct vfio_device_attach_iommufd_pt {
> 	__u32	argsz;
> 	__u32	flags;
> #define VFIO_DEVICE_ATTACH_PASID	(1 << 0)
> 	__u32	pt_id;
> 	__u32	pasid;
> };
> 
> What if the next flag is simply related to the processing of @pt_id and
> doesn't require @pasid?
> 
> The xend array necessarily expands, but what's the value?  Logically it
> would be offsetofend(, pt_id), so the array becomes { 16, 12 }.

You are right.

> 
> Similarly, rather than pasid we might have reused a previously
> reserved field, for instance what if we already expanded the structure
> as:
> 
> struct vfio_device_attach_iommufd_pt {
> 	__u32	argsz;
> 	__u32	flags;
> #define VFIO_DEVICE_ATTACH_FOO		(1 << 0)
> 	__u32	pt_id;
> 	__u32	reserved;
> 	__u64	foo;
> };
> 
> If we then want to add @pasid, we might really prefer to take advantage
> of that reserved field and the array becomes { 24, 16 }.

yes.

> I think these can work (see below), but this seems like a pretty
> complicated generalization.  It might make sense to initially open code
> the handling for @pasid with a follow-on patch with this sort of
> generalization so we can evaluate them separately.

sure. If don't mind, I'd like to mention the two examples in the commit
message when adding the generalization. To let future people understand
how should the array be programmed.

> 
> BTW, don't feel obligated to use "xend" based on my email sample code.

TBH. I don't see a better name besides it yet. :) If you don't mind, I
may keep using it in later versions.

> 
>> +
>>   int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>>   			    struct vfio_device_attach_iommufd_pt __user *arg)
>>   {
>> -	struct vfio_device *device = df->device;
>>   	struct vfio_device_attach_iommufd_pt attach;
>> -	unsigned long minsz;
>> +	struct vfio_device *device = df->device;
>>   	int ret;
>>   
>> -	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
>> -
>> -	if (copy_from_user(&attach, arg, minsz))
>> -		return -EFAULT;
>> +	ret = VFIO_COPY_USER_DATA((void __user *)arg, &attach,
>> +				  struct vfio_device_attach_iommufd_pt,
>> +				  pt_id, VFIO_ATTACH_FLAGS_MASK,
>> +				  vfio_attach_xends);
>> +	if (ret)
>> +		return ret;
>>   
>> -	if (attach.argsz < minsz || attach.flags)
>> -		return -EINVAL;
>> +	if ((attach.flags & VFIO_DEVICE_ATTACH_PASID) &&
>> +	    !device->ops->pasid_attach_ioas)
>> +		return -EOPNOTSUPP;
>>   
>>   	mutex_lock(&device->dev_set->lock);
>> -	ret = device->ops->attach_ioas(device, &attach.pt_id);
>> +	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
>> +		ret = device->ops->pasid_attach_ioas(device, attach.pasid,
>> +						     &attach.pt_id);
>> +	else
>> +		ret = device->ops->attach_ioas(device, &attach.pt_id);
>>   	if (ret)
>>   		goto out_unlock;
>>   
>> @@ -198,20 +218,26 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>>   int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
>>   			    struct vfio_device_detach_iommufd_pt __user *arg)
>>   {
>> -	struct vfio_device *device = df->device;
>>   	struct vfio_device_detach_iommufd_pt detach;
>> -	unsigned long minsz;
>> -
>> -	minsz = offsetofend(struct vfio_device_detach_iommufd_pt, flags);
>> +	struct vfio_device *device = df->device;
>> +	int ret;
>>   
>> -	if (copy_from_user(&detach, arg, minsz))
>> -		return -EFAULT;
>> +	ret = VFIO_COPY_USER_DATA((void __user *)arg, &detach,
>> +				  struct vfio_device_detach_iommufd_pt,
>> +				  flags, VFIO_DETACH_FLAGS_MASK,
>> +				  vfio_detach_xends);
>> +	if (ret)
>> +		return ret;
>>   
>> -	if (detach.argsz < minsz || detach.flags)
>> -		return -EINVAL;
>> +	if ((detach.flags & VFIO_DEVICE_DETACH_PASID) &&
>> +	    !device->ops->pasid_detach_ioas)
>> +		return -EOPNOTSUPP;
>>   
>>   	mutex_lock(&device->dev_set->lock);
>> -	device->ops->detach_ioas(device);
>> +	if (detach.flags & VFIO_DEVICE_DETACH_PASID)
>> +		device->ops->pasid_detach_ioas(device, detach.pasid);
>> +	else
>> +		device->ops->detach_ioas(device);
>>   	mutex_unlock(&device->dev_set->lock);
>>   
>>   	return 0;
>> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
>> index 50128da18bca..9f081cf01c5a 100644
>> --- a/drivers/vfio/vfio.h
>> +++ b/drivers/vfio/vfio.h
>> @@ -34,6 +34,24 @@ void vfio_df_close(struct vfio_device_file *df);
>>   struct vfio_device_file *
>>   vfio_allocate_device_file(struct vfio_device *device);
>>   
>> +int vfio_copy_from_user(void *buffer, void __user *arg,
>> +			unsigned long minsz, u32 flags_mask,
>> +			unsigned long *xend_array);
>> +
>> +#define VFIO_COPY_USER_DATA(_arg, _local_buffer, _struct, _min_last,          \
>> +			    _flags_mask, _xend_array)                         \
>> +	vfio_copy_from_user(_local_buffer, _arg,                              \
>> +			    offsetofend(_struct, _min_last) +                \
>> +			    BUILD_BUG_ON_ZERO(offsetof(_struct, argsz) !=     \
>> +					      0) +                            \
>> +			    BUILD_BUG_ON_ZERO(offsetof(_struct, flags) !=     \
>> +					      sizeof(u32)),                   \
>> +			    _flags_mask, _xend_array)
> 
> We have a precedence in vfio_alloc_device() that macros wrapping
> functions don't need to be all caps.

got it. :)

> 
>> +
>> +#define XEND_SIZE(_flag, _struct, _xlast)                                    \
>> +	[ilog2(_flag)] = offsetofend(_struct, _xlast) +                      \
>> +			 BUILD_BUG_ON_ZERO(_flag == 0)                       \
>> +
>>   extern const struct file_operations vfio_device_fops;
>>   
>>   #ifdef CONFIG_VFIO_NOIOMMU
>> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>> index a5a62d9d963f..7df94bf121fd 100644
>> --- a/drivers/vfio/vfio_main.c
>> +++ b/drivers/vfio/vfio_main.c
>> @@ -1694,6 +1694,61 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
>>   }
>>   EXPORT_SYMBOL(vfio_dma_rw);
>>   
>> +/**
>> + * vfio_copy_from_user - Copy the user struct that may have extended fields
>> + *
>> + * @buffer: The local buffer to store the data copied from user
>> + * @arg: The user buffer pointer
>> + * @minsz: The minimum size of the user struct, it should never bump up.
>> + * @flags_mask: The combination of all the falgs defined
>> + * @xend_array: The array that stores the xend size for set flags.
>> + *
>> + * This helper requires the user struct put the argsz and flags fields in
>> + * the first 8 bytes.
>> + *
>> + * Return 0 for success, otherwise -errno
>> + */
>> +int vfio_copy_from_user(void *buffer, void __user *arg,
>> +			unsigned long minsz, u32 flags_mask,
>> +			unsigned long *xend_array)
>> +{
>> +	unsigned long xend = 0;
>> +	struct user_header {
>> +		u32 argsz;
>> +		u32 flags;
>> +	} *header;
>> +	unsigned long flags;
>> +	u32 flag;
>> +
>> +	if (copy_from_user(buffer, arg, minsz))
>> +		return -EFAULT;
>> +
>> +	header = (struct user_header *)buffer;
>> +	if (header->argsz < minsz)
>> +		return -EINVAL;
>> +
>> +	if (header->flags & ~flags_mask)
>> +		return -EINVAL;
>> +
>> +	/* Loop each set flag to decide the xend */
>> +	flags = header->flags;
>> +	for_each_set_bit(flag, &flags, BITS_PER_LONG) {
> 
> I suppose it doesn't matter, but there's a logical inconsistency
> searching BITS_PER_LONG on a buffer initialized by a u32.

how about using BITS_PER_TYPE(u32) or hard-code 32 here?

> 
>> +		if (xend_array[flag])
> 
> Given the earlier concern, this should be:
> 
> 		if (xend_array[flags] > xend)

yes.

> 
> Thanks,
> Alex
> 
>> +			xend = xend_array[flag];
>> +	}
>> +
>> +	if (xend) {

I may change this check as the below. Hence we don't bother to
do the check and funtion call at all.

	if (xend != minsz) {

>> +		if (header->argsz < xend)
>> +			return -EINVAL;
>> +
>> +		if (copy_from_user(buffer + minsz,
>> +				   arg + minsz, xend - minsz))
>> +			return -EFAULT;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   /*
>>    * Module/class support
>>    */

-- 
Regards,
Yi Liu

