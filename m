Return-Path: <kvm+bounces-30911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC2B09BE42A
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:23:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C0981F2370C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 286681DDC35;
	Wed,  6 Nov 2024 10:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V9LoL0E1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29AF188CAE
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 10:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730888575; cv=fail; b=h6o8RyDuearWUUGWZ0ZHBm7OKvMeAiYErmTRtLUBXqXef4z9P8HRxz7rhGgcSar4IKLeCd4rDqcfggtNMdsdCJS36+6ZH0TUfpvgvpC5ujAbSHLxuWJGmFgVtQMW7jY0a6ul9j9IlZYFP8zo7VAnBMUOOfjAFneHhifaEpIq2vA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730888575; c=relaxed/simple;
	bh=ULLsKjy3Eg2yPvWYwX8vCQGZQ0zM4pQpleQnYMMOp4Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n8+K+w6bXvVwqHWqKcErPrd+Ehk6sn0iLnR1Z+4exinvy5aSOpUs18et/lnWlG1nMteKXf9kP3I3+An2CAb5A5ZSlFDWXjATIkBqjB9/fN1FKphlulMH8J924YnECjvqJtkg8Xjd0EZwy+2syUnt2TzSSXi/If8mVSBk/VEk8/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V9LoL0E1; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730888574; x=1762424574;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ULLsKjy3Eg2yPvWYwX8vCQGZQ0zM4pQpleQnYMMOp4Q=;
  b=V9LoL0E1wwRtxMVjduQv1mIXL9jAW+mCI8QulM5SKhEbpHv9emTgeTLs
   Vjpjqv8mJPgF9FB7wSC14QQgD8P4ps2Hj+i87K4Qawhz7xluJCIo6u5TN
   zNDAjlAxfqHHm35R9pxmt0Pm/ltwQBXjj94QQNbYnwoeVB9hYLlmEAi4J
   aObZ419Gl+qQNo8OjY0HbUcElY6zOAZfU6KJK1libDFf2brz2/WHB2ZMn
   7ShiKqZZDNAhh2Gy2n+aVI5H7NiGftLuBb8ovu8Mqxxg8Ft7kdNVVzvM5
   NJNSw92SOK7XIBJjPDPYcXSm9rugx7Bf8Oo0sakqC00Gz+24e3vXAQW/T
   w==;
X-CSE-ConnectionGUID: Cvwn2fn9Q7GzRrJjDkiT8Q==
X-CSE-MsgGUID: qk/vf4yIQvaLqmZBjRdFCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="41271911"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="41271911"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 02:22:53 -0800
X-CSE-ConnectionGUID: s5iVUOSwS/eJC5818GSl0Q==
X-CSE-MsgGUID: JdVW128ASCCbPYiDXjKOYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="121980456"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 02:22:53 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 02:22:52 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 02:22:52 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 02:22:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kSWcUiqlL4bIaBaF4COZCNjjgcDBnvww0LRH6zoHmrwfakiBnuDypn9Wm9rwxMxzAzk95uh4tAjgYYEIVak2duM0RiXcsHXvKQmn0SBMPBkkeQRV7Ja8wCJtWQAB7LJJ4D7IlgffVBgPXrX7XhWfVxNfnJNYbiX2jdyoz2bM9iyRYhCmWPI9a8YPfWYvOea3Mv91z8VlVWb5CC8ZG5Hzv9RW6bFKwnY+kprUWdaJWAAh/q19Oxt4rL/p46MbYvS5rqQ2xj5hoLnbJVmTjK61nGI10SNlAvW1zLc3TNgP+SrdH3wUuV1eyANQo5DbO+UMY0xPapB3MdDE1YCWLA04VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSCJFOlpsI3K9xm5qomOTsvQi79+acv2L7lKuVEcqN8=;
 b=YRBuerkqmvkZtquv6ipTx865XN2M9bzBALHAG2WYHItL7+2EoESnnUmKXg4P2VvAqpPDnwiWNLTox0kA74XTnC2Dq057oAZ/TPpt66ew59wsz/TRE3ubcEbJ3qjIAQLyarRsth+jdH3DRaS4EV4uv0/7CdeYzAqkYW/THbmFbgMXd5ZYJrPZcTJJTXKCFxOesdZ6fP7XqEcb09FxpcpT4C5Xu6LY7CHAnjrnUM5Z87sc366LIMG/tf3iSZlNIhyPirtFfkmdgIl71Dfueay4KGsSLFrilroClRbKQsNoYIrRpwdGnnCabWvbw/KXmv1tPeiT1xBWn/RlOqevaUepzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7788.namprd11.prod.outlook.com (2603:10b6:8:f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 10:22:49 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 10:22:49 +0000
Message-ID: <286fbd5b-a122-46f2-b10a-697c0761fd31@intel.com>
Date: Wed, 6 Nov 2024 18:27:25 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/13] iommu/vt-d: Add pasid replace helpers
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-5-yi.l.liu@intel.com>
 <BN9PR11MB5276B9F6A5D42D30579E05E28C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d218eb1c-ca02-4975-bd6a-310a81b3d88c@intel.com>
 <BN9PR11MB52766A4A2C15C9C58F9513128C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <30114c7f-de39-4023-819f-134ee3b74467@intel.com>
 <BN9PR11MB52769251CB1CE4FFCF4E1DE68C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52769251CB1CE4FFCF4E1DE68C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:3:18::29) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB7788:EE_
X-MS-Office365-Filtering-Correlation-Id: 1278b910-207b-448d-8567-08dcfe4cf6aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VnlXZG1DOTl3SWhvYWRXMjdxemdYeWwwK01yM0k3TE9uekJpdFFrZXdyZDFr?=
 =?utf-8?B?UG1ZR0NtUjBmS0UrdjRkUzZlbmkrQ3lRTWFzUWVtU3lFNzM4b0RLZExUQmkr?=
 =?utf-8?B?ejRmYnlyQllqMWl4TE5UeXduTlVCNjdNcmdTRjJrWHJ0ZkJqOHEydjN3QXBh?=
 =?utf-8?B?N3Y5eWRvUVJHRTVlV1pUNXZ1OVM5alR1MWdkdVNRRzJmUkV6WUFmU3lxVmtF?=
 =?utf-8?B?QTVBWVFCZENPbXZpcU0rVFpORmorTllySWNnVjlhbEowMFBVa3BvbDRjUnJE?=
 =?utf-8?B?UzlxZVFVLzBNOVR4U0IyeHY2WHlkTHcyWHF1aHBaQysvL2J0c3l2eVBnNHB2?=
 =?utf-8?B?TEZGQ1Q4b0QreVhKSU12bWkzVEVzNFM1RmtFL2V6QXNJUkdCR2J6SHFlc3FR?=
 =?utf-8?B?aURoaGI1YlprNEFNVEFMK0lFOXJVdkZ6aU9oRVNKNzNKZk1WOXJzcDRHWlJB?=
 =?utf-8?B?NERFR3NQb2hKZ08vS1ZWVGVKNVRsVXZSTkNCVXNvRjlUV0pObWRVRHdoVlJW?=
 =?utf-8?B?dVdoWU85Vzlucm9XVzZjRFRiSHlrTllxeWFJNmNtcWlvTXFuNmpjeDFvbTZZ?=
 =?utf-8?B?NncwaVZMSXBlb3lpdnI2MGRkKzQ1Z0djRllIaVZHOUZYcVRFaVl2dWpCTktG?=
 =?utf-8?B?OHhLTCtzQVlFellLa1JmeXRxNjBkK0E3dzBMMXEvZEpzUXV2NnV0M2pYQzdJ?=
 =?utf-8?B?UXM4WjNjb3FaSGVnb0FRQnZSQ2V4NTExalMwOTJiaVVGNUJVVTc4WVJtSTMz?=
 =?utf-8?B?elE1aUx4Nm9qM05vQ1RxUU9DWGVtNUIxL2lXaUFzckRKZGFOWUtJSktJajVD?=
 =?utf-8?B?SHRrdEFnTm0wSTFxNkZsTjhiOEVmR1BPNWl1dSsrMkdFQ2c5aXVoTU0waGhE?=
 =?utf-8?B?K0hJVm90Zm9JOGRYM1p5aW1XRGZKbkRYVXdjL3R1NENibzZhUXJmOGhxNDlm?=
 =?utf-8?B?YkcrRUJKRWF0UVN6Q3dobE5USlNFN1QzR0l3bWNNYXZiMUI0dlYvZm9saGdM?=
 =?utf-8?B?MlFTT1RBeGxadDJuejg0dzRsUHJ0NEZIT0F0ZWxwb1ZkajJJVjJQTnNibGtq?=
 =?utf-8?B?WFJ1QXpqTU5sRGlGMDd4dmVBRklyeFR2d1BuME4zUUg3SE1GWkxqQzhDUDFE?=
 =?utf-8?B?MTlrR3BMcjE3ckxQY3Zld2FPcUh1c0xSUnl3MEdDQ294d01kTGFtWGhTaEwz?=
 =?utf-8?B?a0dlRVRzRm5zVjZvTHhWWGRTbCsrdW1YVG4wZmt2MHkrTkY4cTdqT0dxTlFt?=
 =?utf-8?B?dDY5NGxjc2pPOWMxN0t0V0pDTThOQStNb1JONHRZVjlsdXR5MllFTXRHTzVJ?=
 =?utf-8?B?WlQxMExRT1doLzF2T21lVVMwU3JwYWhTYUtxaEtYaS9ZU0N3L0pQd0FHbmpD?=
 =?utf-8?B?L2lFV3FqcnBJTkZISXcwR3owajZIRm1uWnBlbTNUMW1KdEdsNkRiM0VQNXlB?=
 =?utf-8?B?YzBTRVA1MkhTTVFjSTA4YWtlNEhrRTNMdmd1SzMvVVd4dFA5c2Y2NXR1Z08z?=
 =?utf-8?B?RHo2QUluYng3dTRMZzBkMWtCSGZCSEZnayt4dnduVVVjcWV1VnorWDlQNU83?=
 =?utf-8?B?UmdKTHF5UnpTdXFmemJyNlBxYk1CZWxBQllsdEl2Q0FpTU5xdDhKVGZ6ZkxP?=
 =?utf-8?B?Tit1TzRKcjlqaEJMSjM2NG1JbjdlRXZ3VmJ4dEZZbHozZ0hpcEFrbGx4SUY1?=
 =?utf-8?B?bk9HL05PeXlMbmJtTGx4TENNanNRTEZkcGlaYUV0TWtxWUZtVzVkRmpnZ2Za?=
 =?utf-8?Q?kNqvAvaW0Gwa1KDa/jm5cFyt+sktNyaqa7YXHwF?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1Uzc2E4YzNaWVoycXh2LzBBd0tvTGxrbFBqKzJGSENvSjBPV1ErdGdNS1RB?=
 =?utf-8?B?V2JVZE05cldhWDVXLytJaVhpT3pQVWozQkNOeVVYVnFUbG42Mmcwai80dEUy?=
 =?utf-8?B?VHFPaW01QmRXWm9MYnN6OHJZWGFEd2lSVUJSUmJJRlUzTitONmowV1ZWWk1V?=
 =?utf-8?B?cG1weVg5UC80WDlvWkp1SkRKVHFOQ2NzQlhQNDZOR3dZYkhIZUhqdGNoNm5R?=
 =?utf-8?B?NkJHMlVkdkNPMkMvbU9XdzUvdlVoN0h0eGxvYTJhVjQrYUNxcVQ0NFN3cisx?=
 =?utf-8?B?bEcxaEVRU2lNZmRjNFFHT3Nqa3Bidkx4ZWNDQkdoL1pMWStVQW9aY3o2b0hp?=
 =?utf-8?B?Q0lsVWlydkJVYkk5MER0ZkVIWG9qVkZSaHFLWElaM2plaXJxRFBNelRubm1r?=
 =?utf-8?B?Z0dQQkJnOHptcGJZVm5neFMwUjE0Q3Q4TUJadTgxT3pMblZjNFBJOEJ2MGhZ?=
 =?utf-8?B?MHQzcm44UHhHNmxpbnFSR09EOGZ0YjlUZDBZb1RySGk5UG8wSkpvdTlLTHdx?=
 =?utf-8?B?UnJCSHZDUTRDWVNUUnNUWDVVaDdsOXF3aXdIMWdnNFMwWjBsaFJpUW5qcnhw?=
 =?utf-8?B?ZHRqNGlQVVczdU5ISWRGSzhXbXlBQjVSTnNvUEl2RkxMbW1DZWtEZHdLR0Rp?=
 =?utf-8?B?L2hGa3RxU3ZGN2NnTys2SWd2UVpONEE1RW1BbngwRC9jQ3RkZExUazQ5Ykhx?=
 =?utf-8?B?SGM1ek9RM1pnZlExdklXV1lvS0U2MEF1Vlk2ZkhITmp5TkEvUk5SUkZsZUVE?=
 =?utf-8?B?TStoMXg4R3l3Q28zOENMaTZza1Z5YmMxTmc5UHdjTExmSGdVQ2o4Um14Zm9w?=
 =?utf-8?B?VzBDWm15bFMwWkxzTG9CM2lQcGVzMWxrbXFEK1dyQnRmVFczQ3luKzl3QnVH?=
 =?utf-8?B?V0IrMllXaFlWalJVT20wVHpScDdkdUlhcEJlL3JjNXQ5dXdJZnNHZi9rYTFp?=
 =?utf-8?B?UlB4REJJenRYOUw0ZHJPd2ZVVVU5OC9uM1RvZUNDQi9ZSG5idXViV2k2NDNX?=
 =?utf-8?B?OGRJNU5sN253bGJqUkwzU3VMNHRLZ3BWbThJbWFBbjNJVG8yYXhmNGxYeUY3?=
 =?utf-8?B?a0JyWmxGS3RlUFl1aGFRMGxmamZUVHJMT2UwMzZ1SzA1R0g4dFVNVlJjdWZa?=
 =?utf-8?B?dm5lY2JSbTRBNTN1aVRhY2I1aGdhaEZKM1pTVGMyZk1WVUcvOFRhQkpnS0Z5?=
 =?utf-8?B?WUhmYkNYRTc5N01mVEhzY1lGZXlRR0hzcGlCZFZJTm05cnQxbGloQklKdUVk?=
 =?utf-8?B?ZlhQZ3dCcTN1NVNrRDZyL2xVYkhyRWhubjZDZlBQK2tJZTZFOXVpMkxoamRB?=
 =?utf-8?B?bGh3endvVG56dXhwWndFK01CN0REd2xwSjlsTUplOFlmQXc4SXdjNlA0V3JN?=
 =?utf-8?B?RnVvNGdkVDRGNHlWNGZKRjl5SER1dUdjNGQzbnFVQmN1MlI4MlpmU3RWTC8y?=
 =?utf-8?B?SXNReXlMb01tbXgzRUFJOWJKQ0ZSRnNrZDhrMENOQjFIeXpIY2JFZ2NJYldH?=
 =?utf-8?B?Y3l2RmlieGcwdjBkdEdNby9sRElkWEpyZ0EzaWdpS0ZCZ1NBYUFXY28wZkUz?=
 =?utf-8?B?MW5UYVFUcEsvVEN5TDBQU2ZQVU0wdVd5UEJNa3poVkhoQkpkcm0rY2RxVzFt?=
 =?utf-8?B?SVAwb0ZUVGtGQmhKNW9WMm5IdGRiQzUrNUgrNHlwbXhsOWRJbmlZRG8xdUlI?=
 =?utf-8?B?OTFZbUtJVE5iR2JKYmhNcXIyVXA4WGh6STkxbjZwbUgxMkRJVHdFamJVNXZa?=
 =?utf-8?B?SVNjdnRTendzT0ZBRGFZd1dPRVJ4M2VXdVdleThKcDR2TEcrc2c5ZldDYjNt?=
 =?utf-8?B?citobG9uSERXdks0WjNZRDhRaWRwdnRNY00vZk9leE5XdUdCRTlqRENlTTl3?=
 =?utf-8?B?U3p1SmpuVlB2SWRvZHR6UXpOOVBRVHZHNDl1U0xZYnhJR2Nmc0VVQ2VFUG9a?=
 =?utf-8?B?ZTYzNXJubzg3QmJURWJoclorTm54Yis2RkFUM2VhYWFBdnFLKzBabWNwNFFl?=
 =?utf-8?B?SjBWTHdvT0x2cUNGMGpPZ3ZjbXBmUFl6YmJPQ2czTllia0NGQkh6Ymc1cVZr?=
 =?utf-8?B?RGg1SzFhdFJyc2N4QTM2dHhDT2VIeG8rcFhLQXlmZUVTQjhzdHB6TERtVkRI?=
 =?utf-8?Q?VKkJgce7FpzcFuGoV8JC7EezW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1278b910-207b-448d-8567-08dcfe4cf6aa
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 10:22:49.2240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /aJXXBLBFeG4ioIum/AcAfyskgFkhuGvhO139y4n6Pbv93i3i1f+7uYFn5h5LjxCjpJ1CLokuAQIK0or+4X4oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7788
X-OriginatorOrg: intel.com

On 2024/11/6 18:05, Tian, Kevin wrote:

> 
> My personal feeling - it's worth as such rare bug once happening
> would be very difficult to debug. the warning provides useful hint.
> 
> passing did is OK.

deal.

-- 
Regards,
Yi Liu

