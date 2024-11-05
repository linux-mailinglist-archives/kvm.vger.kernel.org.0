Return-Path: <kvm+bounces-30698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A8D139BC79A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 08:57:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04ECDB22909
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D691FEFC7;
	Tue,  5 Nov 2024 07:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BPcFtPTn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C769B1FEFB1
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 07:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730793436; cv=fail; b=ZvApJMbo1/s6hjEH0V70rvGxpbuMUR1oySDH94EOlxr3JAs7edSpQnrq4SqpNuE/yl4hgjeMrsANz5wV+J/yLoz3FN2I/Kgzz/fziFA3VSipIkD5lqGlAplSoDph2xqyuz7WIQnmziXtX+l51Q02pzlyFNQETfc2XYSPJ8i3hCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730793436; c=relaxed/simple;
	bh=g3HGQbcmo1AtinJMO2LYGaI06chTTX8uQh3IDGfHYSI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=exTYdZFJT3ubmu1y0SthkPlTClgkuqz4iZAzvMm+5tJoFUBe/lrKDgOcRTwCMR77tkNyoy/b/sdQ6mhGZXPI1Ht1pxu2WJqi2vfwThy2gsi7XKc4F5cSxurwcEwM/tB87+BAJ9Ir7LYxjgdZZL6ZddutAgtXGFa7Eb87hbb/RcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BPcFtPTn; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730793435; x=1762329435;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g3HGQbcmo1AtinJMO2LYGaI06chTTX8uQh3IDGfHYSI=;
  b=BPcFtPTnzWpQPfV777YCY63OEQ6SA2RWZ1SQPysRMQsVavmVKzhvvBoN
   YC8G5pAroQolNP894YHd3+a8HpMDseW0W5aDb4VbNMQ9Bs/Kh28gSY+zr
   +XMs50MkyHN9ljOJBbEj/fcPw+NZsPb/7xDWJkYQS5V/Zlf+qlkgVQzvj
   6PKTkgRQ48gi9QW1ZX3hDx0zK9h4MXv+o+zTNh2Y1YKaEgNxMcw7QGMd2
   7r14ea4oRWlQ01s91NbWGb1yxcym4olIMBCqiW9RswojEupxQgxgZOp58
   Rc/3hXr0QZwtViS25cYw4ukuYD5gCrYbZSmJI0CqMiNso5ByQBi/7kjTp
   Q==;
X-CSE-ConnectionGUID: YwOGd9tDTPuokq3AfhwuWQ==
X-CSE-MsgGUID: oFQGs2WaQDiF3N5DVa5Y5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41114620"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="41114620"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 23:57:14 -0800
X-CSE-ConnectionGUID: ui8INiTlQ5iWu43aW/JSXA==
X-CSE-MsgGUID: ODBj31zyTaK9XKlg9Zh5Lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83439027"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 23:57:14 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 23:57:13 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 23:57:13 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 23:57:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PEKKKNtddT9JpF6F35WtNpDDS8+tXi6+P6RXagerL6uCJXHzzzkjzfXuWE0xN2n9PxhUw8KUItM68wCKapXSkph/4O9WgMWtLFMR4rsPBq2ZcfgDyDk4/dyiRz0CCG81cuYhf6OchPZUDr3OclSq+zN7ZrLy6uea+/xoA9L5o97TyxVpRAvDU3J4l6g3o4Sv/dqK3St+0thQ4vo1feeTAWE66NAAwIg49tH13XVXF8K+dmjprg8ccPCIQLqX5C8ZbVKhnNm20h/p5G8TUxw+wiXrALJEf2Ka79ydjPtq3zzSbikKzbj1NqahvR514fgYNufjnTapTbcHFw+WDX53Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NaNIWToFCtrmfy3TMGssM0ZpM1GTSElfDiEYnqhj7B8=;
 b=TwFIihuS+vjOhpY9d+om55bPDqQlR+3Jky539NPWDDzAVFBSQsYZR13JhcgVOJ6XQ3C/8PQCxh05HEl5Z5nxgtebO1rHl6v1ROrDZboGOJUgGejABJQGsGfVasFAT7ktXkb/1e0/xciOX4kdUwWt24p4zsGTIXoUcGSeVi74sUj1dVZ1IKS3r5IkIjXacKZXnEc0Dq/jT6Sei77yfLmMMmPtzOs8HUKx9JXBOJMjGzfKBfMTAEFGFO7yIVol4KwyARmXjCrUxMUbpk1RXl+yPsYU6SePMlhap+kxU05PftyRyp9WsZqeMAsvo2PGBFUI8HAXY3SLaR3F1mIqUaWVJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by CH3PR11MB8153.namprd11.prod.outlook.com (2603:10b6:610:163::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Tue, 5 Nov
 2024 07:57:06 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29%3]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 07:57:06 +0000
Message-ID: <a7cf853d-be52-4a61-8e0b-3638d0559853@intel.com>
Date: Tue, 5 Nov 2024 16:01:43 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/12] iommufd: Refactor __fault_domain_replace_dev()
 to be a wrapper of iommu_replace_group_handle()
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-3-yi.l.liu@intel.com>
 <7c0367f7-634c-485f-8c87-879ddfa2d29d@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <7c0367f7-634c-485f-8c87-879ddfa2d29d@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:194::21) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|CH3PR11MB8153:EE_
X-MS-Office365-Filtering-Correlation-Id: b1347d99-bc72-48d4-27cd-08dcfd6f7108
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TVk4QW9NK2lOOE82YTNpcUlmMFM0dXMySmxJSlI5bW5PclRPUEVwTXE4TFMy?=
 =?utf-8?B?V1hMQXJ1M3Zjc0xvVUI1RXB4a2dVdnF4OENQNFNyK0h1OXFlUmRXRS9TQmg3?=
 =?utf-8?B?NGJ1SUxqZGNybDBLM3dBN1orUlE2SytCWnBRK2pTZ0c4TTB0alZZZjNQcGxY?=
 =?utf-8?B?d2Mwbjh1bHdpU0NFRERyWXJ0STE2TVdjY0ZKNGJDbmVSeDdQZnhwZlV6Z1ox?=
 =?utf-8?B?YzZiRWVlSlpGTkY1UEMyYk55VUJIdWd2RHhZWWFxc2VvNnhYbFBaaEcvbUR1?=
 =?utf-8?B?cUxJd3AzTUxLMXR3NlBPc21ZVjRmSHBZV0ZkWGdwTXFUUkxUaU83bjdWWFV3?=
 =?utf-8?B?eVVzamNnajhGWlRMaWpDN2ttSVQ5bXNCMXNvR2l4V1c5K0FIb21PS3VuQndk?=
 =?utf-8?B?eDhBdXRTUUxwY28vWDhyazZXRHpTd0oxejZTOFgzRHhXNmFtcHFuK081ZGhi?=
 =?utf-8?B?LzNzMXJQS29IWjdiR0piOS9pMDYwSFdTWHMzbzdtYVI0Z2dhNmVMd0JQaHly?=
 =?utf-8?B?aURHWnorWG9ndk9kR3NLSFUxUnBRR01kamk4OUt5R0VIZTdjYml6ZjYxY1hk?=
 =?utf-8?B?VlR5dmRjYS9NclcwUU92RWtuVWFwZXRFU21Bb01nbzRwUXVaQ0xwQW9wTnov?=
 =?utf-8?B?a3BKcUlSSVZRa0FvWHhrMmhodGk2OVUvSlRXUGloVnptNkFjU3czUnBEYm9G?=
 =?utf-8?B?S01mVzVmYzJZcmRNc0RvNGF6TGxGckpleVhObm0rWW9nMm1YSk1nKzRoS0hr?=
 =?utf-8?B?eU94cWRYM0ZITy8xVEFvank2NVRuT012b1JNL245N0pXUThnU1FUd2UvR05O?=
 =?utf-8?B?VWtqc0FYVEU2SGdueFZuWS84cTVuM3NoNWxFVVp2VUJMNkR4UmJqSmcyT2xJ?=
 =?utf-8?B?bEZoTWZFb0RCNEZPQUtQTzlsY3hWRGlDSno0ZUsxMWQwVUI3cmlwUzByYmh1?=
 =?utf-8?B?dWtuc3YrSWsvVExNMVQ4RlhzVzZTR09pRzNWUHNvSnV0NnJjWklrSWhURTB0?=
 =?utf-8?B?OWZ4NlRuRVdKS1VwVzB4bjZXQ3JpNERjUnJOaUJUK1V3TUFBY1FOcVBLUXZL?=
 =?utf-8?B?N0xlM2c4eTBaLzk0MSt0UHpPTnI5NzB0RlAvM3dQZTV3Z284UjFGUXM0enlT?=
 =?utf-8?B?bEtFdmFPT2RqZ0JOS2tNbktITzNsU0NiSWRWalB5QjlFeXozUlcyb1NXVUFI?=
 =?utf-8?B?OFU0Zm5qN2JQb054R01uSHVSbUJ3L2o1Q0M5MlRGS0twNmIydCt6dmlVaElp?=
 =?utf-8?B?L0tQTGFZelpTTmFQRlFKSmIra0ZRQmxrSXcwV2FEdlZLN29Ybjl4cjljMDlU?=
 =?utf-8?B?ajlWdEZBZm5ySWRDY0pmUXJlTURxenlEOG1sc0lZdTN5bXZnVVN0UFd4Rjlx?=
 =?utf-8?B?U0VJSTJHTFlJZWlvY1pPVHpUYlJINTFwWUZ0dmhNZDNlcWx1SjVSWVRjVHRF?=
 =?utf-8?B?V0JwNTVZMkU3d3IxZ2pKSjYxMFBaZ1B0VFI2akdRZnQxOEtYK1RXcHJaWXJZ?=
 =?utf-8?B?T29NMTZEemFia2QzVUpibnNvd0haTXFpYjdxY3VuWGFaTnI3dVBqVk5ValFE?=
 =?utf-8?B?N1cycFc0L1JWUXpPRHBSSHBKVGNCUEhPeXg2SVY1ZTI3TTR6UzFRMGl2blJS?=
 =?utf-8?B?SDUxL3A5OEpGc1ppTmpJU1MrNWFwUkRmdk9veGI5cjg4emVxR1NrSGNIZFlw?=
 =?utf-8?B?Uks3YTJDN25kUmFZUnIyL1BTWTllT2pUa2N1cjBLbGxYSy9uYXlCS3VOZGhT?=
 =?utf-8?Q?x5n5+KFku1rsAsn7Bg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2loekFUOXBYNGRsUXdPdXhQeXQwb013YXdQdE5ic0ltSW56R0VqNzJ6clNN?=
 =?utf-8?B?WXFXSkFHb3RzbWtITy8wR1djRExDQWhtcVhteDlxdkRpOGtoNWtPdWU1N3Vm?=
 =?utf-8?B?azRzdE9rSjNUVUZTQk4xdlVRK2MxTy9oNkZCZGt6eHlPRWV0aWZEN2YzZ2h6?=
 =?utf-8?B?OXBCMnFuY0MvOUN6RCtCZWdKdFVuQ1RuTlU4KzFKblZEdzlHRWxGdi9EcXox?=
 =?utf-8?B?TWhHdCt5WGQ5MDdPd01rUGtzenZaWmxSNWgzVjNvdUFmOW5rYU1tbWRoTllW?=
 =?utf-8?B?RWkzdzZOZnJ5emJIenJOUVFPaVRYbFAvb2FQVks0ZkQ5ejZvdnBxV2JqN0hm?=
 =?utf-8?B?ZmZHTEg1cmRZUGl6OVM1RG9jVUFWM0dCQmZzK2MwbEg5MWNvMWpMM21xbDl1?=
 =?utf-8?B?ZzJadXg1Zzc4Y255VEdwM1hlWFRjUjQzZ2lsbDRCTWFUYVllU0VVTWUyZ1NH?=
 =?utf-8?B?blI5S2VDb2ZETlpVYVB4dGZ2WnJ0UUp1WkR1M2JxSUoxdjFyTXhzQlRLVXZS?=
 =?utf-8?B?enFRRS9lSkVLK3p3NW1Zb3ZvT3FGblloUnJJVGJtZ2NKUEJ0YldyOU01VG41?=
 =?utf-8?B?NmJlQXB3RFA3Ymd3cWNaa2NvdXlMcDBESmFyL2RMbEJGcDJwcDg1NWZXcEhy?=
 =?utf-8?B?aWlNSzV2d1NFUG1LcFIrRk1JbmF4TkdtaytkeWJ1SEJDMk9vekwyM0EydW03?=
 =?utf-8?B?bzdoS3NxdTcvM3pWME5SOUJjZjJYTitVSnpwUFZ0ZXNQVGlnZmxsUE9tQVdZ?=
 =?utf-8?B?OHdjeWlValhOaXJHc3ZwMDlpWUw1S1N5T2RDa0Vaamo4NnFSeGJscVhtY3ZK?=
 =?utf-8?B?U1hvTStqb21nRzJqdVJVUEl3ZVJSYnkvcmpWVFd0b1lCT0VxTFpack5lYVVX?=
 =?utf-8?B?Nm1CV0xqU0JkR200NmRSOEwvZllvWENSK0VjdVJHd3VQSnhVaHlyS1dwOTha?=
 =?utf-8?B?ZlAwU3JySmdYcEZESzRWYk9PQmRjbjB1UjEwY0pQOGxValNQbmsxT0ZvYTNh?=
 =?utf-8?B?QnNySXhodkJlbXhPakE5QlFuSFJ5ZGtIdEFZaGljcXpGYVVWWUREQnpxQzQ5?=
 =?utf-8?B?VlVLTjZseGpMcjM3eWZFRmx2SFJzSDVFdVFNN0dVZFN6K3luUktqT0RYYWlo?=
 =?utf-8?B?TXVBaHpDdGZ6S3M1bld6SHllQll5aTZKZU1sdXM2WEFWTFNpOGJIcmw1OGY5?=
 =?utf-8?B?VnhPeEQ3ZlIrZ05BRWowNVZvMjRWbWxIS25YOGZZWlhLQmpPMEQ1TUthREpK?=
 =?utf-8?B?cUJ5Q2UrYnBJN1ZrQ3dwa0MyRlhSZnppZzdkZGlMMTRzSUpncjZHYWJQRW1m?=
 =?utf-8?B?c1pzNlNtZGppQVgzcUZ4bjk4dUF6WmdkR2FsOGNRRExsQlVMd2FzRkJyd21u?=
 =?utf-8?B?dmFsMDY5N1UwSXNucVlXcldMeTZqL1VKRXJJZjYvaksvcG1hUUdQb1B1TzdY?=
 =?utf-8?B?d0pEaXpqTitWbEp6ZytuZ2ZNVDljM3RPb2dsVkQyR1NrSU9jUFFUOFcyQjVO?=
 =?utf-8?B?QUlXemJGanh2YUNhS2xJQjNpR1pLbk5NSUVkdWlHRkFBWGtnaGRwaDJpRjJZ?=
 =?utf-8?B?OFlyeXdtYWZrcytvQThuQmUyNUhMSWQ3UldZWmZqek5IY09wbXBMa2o3Myt2?=
 =?utf-8?B?R1FCWUxQdzZhRUJWcll0bmt2SjFmUGpnZzNaMkFFQkpQbXN3TlFVUmVITDRR?=
 =?utf-8?B?QXNCaHFqcGhNUWY4eXpCL3NRb002NzNaZlpZMGRBZFZkS3lFN2w1WFJCS1o3?=
 =?utf-8?B?UktUUThaT0xBeXBxQlF6NHA0eE5uRU5sNWFEZ1BEdUt4OTlOczZKWk9kM3U0?=
 =?utf-8?B?RzcrY2xqd2pjRWJLYUJaZHZJVU52cm5za3NaR2J1V2lQN3oxdTdIUGhwZGZy?=
 =?utf-8?B?aDR0TzlicmhaRENMRHAybXRleFNMUEIrdzBudWhNOXRYTTdRc0RlRVRvRHpN?=
 =?utf-8?B?MVlxL1ZxcHVRVHZQeDR2clRnS3Rtb2hxZGszRCtTNmtjaG9yNWhGQ2o4U0Z5?=
 =?utf-8?B?OUxyVE1wZGNqYUVzbFpVWmIrNTZsMHlqQmlqakN2Z1JHQkU0bFNhQzdUL3BH?=
 =?utf-8?B?SmFRdktza2N6OUZzb2w5VlU5VlZHd2ZLekdZdGxkK0I4QXJGeG1CblppSHpQ?=
 =?utf-8?Q?f9EZxwdJs4ZCkPe3PxM2D17Lk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1347d99-bc72-48d4-27cd-08dcfd6f7108
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 07:57:06.2615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /hhXUcGM2CCwg4ZMfQ7Uj5UgZS0wMEAcqTZUTExFYTTjwQZFFol745MNjIhr3OqDUtx0q0yHmiHYdj23FaMzLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8153
X-OriginatorOrg: intel.com

On 2024/11/5 13:06, Baolu Lu wrote:
> On 11/4/24 21:25, Yi Liu wrote:
>> There is a wrapper of iommu_attach_group_handle(), so making a wrapper for
>> iommu_replace_group_handle() for further code refactor. No functional change
>> intended.
> 
> This patch is not a simple, non-functional refactoring. It allocates
> attach_handle for all devices in domain attach/replace interfaces,
> regardless of whether the domain is iopf-capable. Therefore, the commit
> message should be rephrased to accurately reflect the patch's purpose
> and rationale.

This patch splits the __fault_domain_replace_dev() a lot, the else branch 
of the below code was lifted to the iommufd_fault_domain_replace_dev().
While the new __fault_domain_replace_dev() will only be called when the
hwpt->fault is valid. So the iommu_attach_handle is still allocated only
for the iopf-capable path. When the hwpt->fault is invalid, the
iommufd_fault_domain_replace_dev() calls iommu_replace_group_handle() with
a null iommu_attach_handle. What you described is done in the patch 04 of
this series. :)

-	if (hwpt->fault) {
-		handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-		if (!handle)
-			return -ENOMEM;
-
-		handle->idev = idev;
-		ret = iommu_replace_group_handle(idev->igroup->group,
-						 hwpt->domain, &handle->handle);
-	} else {
-		ret = iommu_replace_group_handle(idev->igroup->group,
-						 hwpt->domain, NULL);
-	}

-- 
Regards,
Yi Liu

