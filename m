Return-Path: <kvm+bounces-48239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E2EACBE23
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 03:27:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49C153A3E1D
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 01:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E7B13C9C4;
	Tue,  3 Jun 2025 01:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AJr/EgUo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7A3EACE
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 01:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748914060; cv=fail; b=er5XsopjE5QQIWRMRUPTCybbcPeh989ZFgN/+9Gghk94mel2nEIiChiWphUgixhwXsDveyTKLQS5SgbwWn63kH0M50oGnlsgo0BTgqszFMeqtWOrFYmRsllTE9kXCPoC6QcuSZxXKBF9rc79MQLpzfKY0WHPEYd41Gfn/ItqhYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748914060; c=relaxed/simple;
	bh=RAU83Ef0wdhuHMXEse3T/1QhD7O2xZrioMMlMsSSsGc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M9XsaZjttUSf0N9JrO8NepGOefOal0Fr5NYHoGV5LNIwzKzrt0UEWUgnt5ylT0UTpitx5bWi04XjShYTd9pnnpwxXKaTSleSd1MkbsACF/M3pi+AI1fEDfaabVzUtIXC1QvqEnRB7IotrZtCWyFC1rZh47KxJdV2PNMlG0I8bcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AJr/EgUo; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748914057; x=1780450057;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RAU83Ef0wdhuHMXEse3T/1QhD7O2xZrioMMlMsSSsGc=;
  b=AJr/EgUosIPC4oOCrR0INUXJHdfaamyRl2baXIFw8k5Itq1sv5eYOu0J
   CKw0hjn+2pGhFJT9UYL+Vdon5hbFd5QOksTSx+bnIXNwzGQ8kRCy1hR7l
   /z2mj9f57ACJfCZym3f6zPkqFodx/dqGDizae2rmcIds46C6vYUBcVWCr
   ASV+fBpFNYKpSuBXGHkM9ismFv5GCEDQxdsxIRv/TUoFC5c36v1hgu0mm
   deVx0KMecR4Kv6Y3d/UXv3q8gY2PHJCZfNr1KVYaeOAyWq1jqFiWwrdSz
   sZGKr/WWTXNq01SrWM5uK3/5JO507kavUbyW406DIidPTnqzkNt73aXsa
   g==;
X-CSE-ConnectionGUID: NGtQo60ZQTqq7yaSo2/SoA==
X-CSE-MsgGUID: dF0gt2kdR/ukurQzCcoBIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="50179722"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="50179722"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 18:27:28 -0700
X-CSE-ConnectionGUID: KuaEWLGTTPmDxu42oEcJ1g==
X-CSE-MsgGUID: PuWGAeIjTwaqvYDA+lIcXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="145640085"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 18:27:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 2 Jun 2025 18:27:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 2 Jun 2025 18:27:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.66) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 2 Jun 2025 18:27:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i65ljDAHgECAAhnb7WLf5ZdM/l8SazsQ856+ixLirBlwq93ESK269OQ1lbaCINDWipkwOwYWZLVQ7341e2TQKEV3EoWzi/IFBCUhmmS6A0CV8BBh6EQPdYr0BlNYnORxyufP6+gwZ2entXTn23UFVonqNzpTYfguNg5m0alsHSdh+K3ZBtK5vGtTxqPn9/bBIkX8IDgbualPIIqq1Laa/ZGHyS7yfxrEfRfRPSoptnLeqiYcjqIMfauLtXbvycbPWENkcKIIq6z/mvnB7UOPi2bTB9ZnfY6Yqe9RwCHODgDJgVDL5QY+zJBsqOM5k5h38k8mcgFWfUVjJDfEA0P2PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gr5SFLdMT1qzvxKymu/DEF0j/24Sb/gok7ZduZtYG/4=;
 b=hHE9Z5EoQZ5h0Xj8Jq5riyptvkILz3fw2JEjXaBDf8Yed74x0Z3tOkPfasLUd1pMFw321QxHu7iPR7awu6sgLCqryNQNcirC2HfpFgCSm7lV7XuMCE5OqxaLSd5tCFgVW5zT+dc58xo5SebVwm8u30AsCvdMQYHcV6RgWAUSKxsDPOz9/5km6Uz5lawNUXdVW7RBfN/RDJpcMAchYew6nh9gzJo6brk6Nhl8C+eAs14GSSRs12L05lqoFtBjtrmqeUn/g9/bSva8GgGGq6t1loUCHq9QbpYCtvFjrxas6QoBswJs+S3DNLCwqwDeNCl6gjF8ibfft2pFZPgrY6Uo4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH8PR11MB8106.namprd11.prod.outlook.com (2603:10b6:510:255::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.32; Tue, 3 Jun
 2025 01:26:33 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8769.029; Tue, 3 Jun 2025
 01:26:33 +0000
Message-ID: <9a9bb6bb-f8c0-4849-afb0-7cf5a409dab0@intel.com>
Date: Tue, 3 Jun 2025 09:26:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] ram-block-attributes: Introduce RamBlockAttributes
 to manage RAMBlock with guest_memfd
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>, David Hildenbrand
	<david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>, Peter Xu
	<peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, Alex Williamson
	<alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-5-chenyi.qiang@intel.com>
 <4105d9ad-176e-423a-9b4f-8308205fe204@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <4105d9ad-176e-423a-9b4f-8308205fe204@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KU0P306CA0008.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:17::13) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH8PR11MB8106:EE_
X-MS-Office365-Filtering-Correlation-Id: 61a67e61-4df7-436a-7741-08dda23dac6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V2hqNVlCYjRmajRSamRRZXRzWE5YU1I0WHdtQ0labHNxaE9HbFhTZkVKR2l4?=
 =?utf-8?B?K0kzVFI0Y3RSK3diMCs2ZkRRUlk5SUMzTUVHLzRrQ0VJeXduaU9iS3FURzVH?=
 =?utf-8?B?Rmw1SURBVWpWaG9RWXdqQm5aZ2MvV2pHMEFlSGtkaFg3TjcvNkVhWUdnK1ZU?=
 =?utf-8?B?ZDVWOFVSUUN0SWRabFhEM2xJQ1lhenV4bklDUEQwMXdUVmFFaWNFbnlkMTZY?=
 =?utf-8?B?RWNqS012cU9DODBqdHZ4WmZkcDZ1cXNZMFk5YVNMYmo3aFJDakM3dThNeE1N?=
 =?utf-8?B?RDVIdGFacWh0U1V5QWdzUWkvTjJuSk51VFFOVlQ2Q25tNHg4SzJ6bHRwVDBn?=
 =?utf-8?B?c2twYVEyVmZCK2hxcmg4Uk1ZNE5HRlhnUE83K1dVQVNGVTRVZUtsT1VzNWRy?=
 =?utf-8?B?SkJSV0dCUFVQSXdtc0pWQlNMTXJ0aGxSWUNVcmZtSituSk1ISHhjNXpTS1U0?=
 =?utf-8?B?WkhrU1BIMHhLNmplMUV2aURqZWd5TUwyUThvcTQrdWkrZGphLzVhLys3Vitk?=
 =?utf-8?B?M0QzTlhDRWZXdEV2cWtDaFl1azVTYkVvWWQ0SUhjOHVHM2g2UFBLYXp2M2Zv?=
 =?utf-8?B?V0p0VkJhRDVJTWhvM04yY0RaallaT2ZXaDJnWFp1R0RxY2xZVkdQZjFoQUZk?=
 =?utf-8?B?TUhocHBRenNOZkpjZ1NtZi8wSC9uMjlSQ2hzK3U1K1NhRG40dVJ5Y3FMc2FW?=
 =?utf-8?B?NS8wamdyZERVSjhwdDZGNkdjYmpZRzVORm5OVFEyUnJndFNqT20rMTA1UzlU?=
 =?utf-8?B?OUZKYVlPZXZMdmM5TVVQcHA2ZnRBblpJZjVpbUN2Szd0Tmt1RzQ3M2drRVFq?=
 =?utf-8?B?VWpBK3lHNnNNbloxRjhzcC9rSm1IUks2WnNsTnQ3bEo4MlhzQTlacStjdUlr?=
 =?utf-8?B?Z0k3aVEzUEpYdXZVYkc1R1VCY3luOEdYTndLQjhPRlpCOXkwS1g3Snhqb3RJ?=
 =?utf-8?B?N3ErZWJ4d3Z4TnV4czBNVkFmRmFzWEMxRzJoWlpXUlpPLzJjVzlBaEVycDBu?=
 =?utf-8?B?TjlCRGFEbjJQbm1FbHdoajBBQ3RlUW9TRk9ZV3hKeFVIMVdxQkMyL1ltMVZG?=
 =?utf-8?B?clMyMTluY2NkKzZZWHQ5RUhPUTFMNUcyZ0N4SXBiY2hBSEJaNjY5N05NRXFh?=
 =?utf-8?B?MGRvNjJ6bHhKOVpHckttanVPK3JpdUxrL09uV3pORHYxQnlRVG5LOHY4Tzdp?=
 =?utf-8?B?dVdLWVdyQ2d0UXhteDRUM2ZRVEhNTTNJMDRQZjUzLzA3R1FxOUJYREtpTlpa?=
 =?utf-8?B?cWs5TkVvMmNxMmtac001V2xzYllzb3VuY3N6bVd2MjBMZVJLQnlsRWttVTN4?=
 =?utf-8?B?TDhUb3AwTjFVdkgxRWQ3ZlFkSHhsMU1XdHZlT3FrM0xwWEpiVHNiZDZIZGNK?=
 =?utf-8?B?SjNFbk9GalNZdGVPZU1xQ1VlK3V2dUR4eUFXdGR6a3JXbEVOYytaSEZXbUFu?=
 =?utf-8?B?ck5zc3dsUFNHeXVPeFA1SVVqRjFNVHRxYnh4MEIzU3pFQ3h2L1Y1NmxCWmJL?=
 =?utf-8?B?aGRlRGRtOXpNMVI1YmJrb0dTNW53dFgzdnd4cng4K1lhRUxselpzUkc4aXla?=
 =?utf-8?B?L1NHS2RZYnZPOEJqOUtRTjl0Q0FhclhWNTZReGNsUVhtOWlTRlpVMlk3M1E4?=
 =?utf-8?B?ZzZPUnN6dXRDa1p2OWpDQkU4ell4d2xMN1BBRlIwTVhMajB4RlR2T2N1OGFF?=
 =?utf-8?B?YW9OcGtKQlB4aXZuK29FR0tsWCtpeUk3WWVFMVBnbzJNSlhFRDRTcjlFM0Ra?=
 =?utf-8?B?Y1A3d241VkQwamZWanJjemtSbkVvNFJyazJxdWJINnpkenROVVE3QXBTYkxx?=
 =?utf-8?B?a25JbDYvVEY0ZDNZSDRCVE0xZWRUVXFieTgveDFjM1V1dHFTK1UweGc5cGI5?=
 =?utf-8?B?RzNhRmVQY1dvdWFIdzlOdTR1elloRTlxRnQwcCtWUDB3M0w0ZXFpZWVySEZZ?=
 =?utf-8?Q?GarWiv55+v0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UExhWVpXdEplQUxjWmJjbnRwUnBsbFF5YzE0c3JQSWJqWGpwbVNzOTRXcE94?=
 =?utf-8?B?NENVRVVtQmhoRGE0UnJVU2lHS0ZVdUUweCswUUw0ZFhvWDZRazltK2FsekZl?=
 =?utf-8?B?bjJUcHRBNzN5U0NmZjZ6SGJpVFliRFRUcURqQU9Bc3V0VXJ3TXpNOWxqdURE?=
 =?utf-8?B?dXo5ditKRWc3aE1QMjk5WE1hTDN0Q2E1UVNjOEpMendSY2xiTFJwUmFEUjFi?=
 =?utf-8?B?eVVkVGdrVlVkbDg0TU4yaml5V2g5Tll5RitzSzR1eG9IaGE2ajgvUnpGQ2Rh?=
 =?utf-8?B?SFpUNXNreWtzcG1qa0pwVG1MRGh4aENxdWdpai9iS3dSL0dCYTJWVldmaTQr?=
 =?utf-8?B?aTdyYit1aUNYK280eG9YOEJXWVppUVpMRFVkc2U1aThDd091QWF2a2wvL1ZP?=
 =?utf-8?B?WTlGbjFkeldaQVpzSmNFOWhtSEZxemZVVXppSEVwMXlFVkNjQjlyWEdUZjR1?=
 =?utf-8?B?aFZhTlJCY0REa0tGY1N0ditZOGp4QngvSnNkWWxZdklicjBhN1doaitpcWVw?=
 =?utf-8?B?WkRhVklEeWxkVGtKTWZqOVdyZHMyK3JzK3ZSMDlBYllYbVQzQm9wRGhwYlkr?=
 =?utf-8?B?UGEzVmNiNnVHK0hFNzBJSVgzcmtFTWlvVnNTV3hXMFdlS1FMaHlxOFZFMkF0?=
 =?utf-8?B?R3VvTWRoNGRjRFFuaG5DdjROQ1dIZkdsS2lFYW9PTnlDVEloOEg0dU1OWGhG?=
 =?utf-8?B?K2JieFBFMC8vUlVGRzVPdnpibG5OYlU3cEtCeTVoTDVkb0ZLaVZKbjl0V2xa?=
 =?utf-8?B?d1dyNWpGNDZPRldDSitZQjBZNE4ybk5KOFI1S04zMG8rank0ZDZLRWo3VWhY?=
 =?utf-8?B?WTBjcklCRUVEVUFtRWRTb1kzL1FjaEk3dFlvc2Noa1NzZFdaR21XVE96K2Nj?=
 =?utf-8?B?OU5jNkN6QTZSNkVGMFBCc01ibHZQTkNGckJzTWs1U0t3eUJKODd5amhSV3B2?=
 =?utf-8?B?RlpmWG1qcTdOSlYrS3krNTlGNG5wSUtkQUg3cDhOWm1WNjlleU5FMFBKallm?=
 =?utf-8?B?d1R3Z09xR0VxSU50OE1IYmltSWNiVXVrZmxrSmg3SEtta1ZUNThIZFNQM2xa?=
 =?utf-8?B?K1ZVdkZWc2pPUWdzTDRmbVk5bDA5a0FMWS9veXR0OThXVFNXaG9VM0VKRzRw?=
 =?utf-8?B?bGQyRnZKcDQ1a3ltV1RWbHhxZTdHd2JBcGUwaEowS1VVYnBRZTZtRjdWUXV5?=
 =?utf-8?B?RGQ0NllsL1BMRzhrR0YvT3VOazkzcnU0VmVIMW80YnRPaUVJNDFmRXBUcWl3?=
 =?utf-8?B?bEZvSHlUa0w4M3RqSlIwcUpRdU56WHpqWE5ubmxGcTNWSE1sS2JKY3pJZ1ZQ?=
 =?utf-8?B?MDQwZTB3WTVJY2duSElIVS9aRWJLYlJTNVI1NXlneGh3U3B1eWZNUHpJeHho?=
 =?utf-8?B?VVhVY2RjOWZDTVVnSmxyWVdyWDA5cmlJNzRNN1RmRUxhTWpNOXpRbzJYY1lh?=
 =?utf-8?B?bTRKVHBvK3grb2hRbHpWSndoNmFOcWR2bm9wbDBYNDJ6T0NzQXkrcHdqN2pa?=
 =?utf-8?B?THV6NzB3eXo2enArSjBQNy9mVHBNcGpValEzamZlUjJVc3RqNkdML3hqa283?=
 =?utf-8?B?YWkxUG5jcHcyN3g4OUQzY2xrSUpDTThyOHJJT2JxWVltVGVQQTIydzBlaG9O?=
 =?utf-8?B?ZHZEcS8zNE50V0JRbDh4eXNBcXIxVThUQmxyOU84TVB0S2hVQTlRbS9DR2xw?=
 =?utf-8?B?cXhPWjlRWjdweG85c2hZdDFCSjdMMlBVWkpVMmF2akRaQ0N1RWRtdTdhM05j?=
 =?utf-8?B?QWxpUlVFajRGK2p1YjIzZ0pHK3BpN0NEK0pJSllWUDVnckM1ZzNuOGVCMXNU?=
 =?utf-8?B?VjlVbVM1cFRqNWVscExsM0FrM3hpdGVXd2hOdm16ZHNOODFMWlhTWjQvNnNz?=
 =?utf-8?B?b1JvSy9NQUs3bTlLWGxmVEVVOUJROXBHS3VKVXdCMVVUeDhPY05RUUVORUxJ?=
 =?utf-8?B?NFovdVZDNU42OTRRZUlKdkZIWFpUNjBLazQxeTJkNGswREJ4YVNIRUo3aFNM?=
 =?utf-8?B?OEJaQVpibWdkbWVCcnM4TnJXT0U2YnNSdFM3d0hDLzIxdmFSa0hqSnNxcURE?=
 =?utf-8?B?QVBUczRsZGxlUzY5emdjbjFtUmdCbWMydmtyVWcxeGljWHBiVUJzYy9TR3Qx?=
 =?utf-8?B?ZWlldGhodkYrRDlyZTRLc0Myd3Vnd0lZT1NhajZHRVI1ODh6Y2pyMzZLZzQx?=
 =?utf-8?B?UHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a67e61-4df7-436a-7741-08dda23dac6a
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 01:26:33.0428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JwTNU0WU8fjbxYZUo1G1cd/98TRzBe5X8HSgPuKNzkO/i6UF5xo8cArSRluqGfIWfNjI+zRPDvBuu2JcI7DiPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8106
X-OriginatorOrg: intel.com



On 6/1/2025 5:58 PM, Gupta, Pankaj wrote:
> On 5/30/2025 10:32 AM, Chenyi Qiang wrote:
>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>> discard") highlighted that subsystems like VFIO may disable RAM block
>> discard. However, guest_memfd relies on discard operations for page
>> conversion between private and shared memory, potentially leading to
>> the stale IOMMU mapping issue when assigning hardware devices to
>> confidential VMs via shared memory. To address this and allow shared
>> device assignement, it is crucial to ensure the VFIO system refreshes
>> its IOMMU mappings.
>>
>> RamDiscardManager is an existing interface (used by virtio-mem) to
>> adjust VFIO mappings in relation to VM page assignment. Effectively page
>> conversion is similar to hot-removing a page in one mode and adding it
>> back in the other. Therefore, similar actions are required for page
>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>> facilitate this process.
>>
>> Since guest_memfd is not an object, it cannot directly implement the
>> RamDiscardManager interface. Implementing it in HostMemoryBackend is
>> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
>> have a memory backend while others do not. Notably, virtual BIOS
>> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
>> backend.
>>
>> To manage RAMBlocks with guest_memfd, define a new object named
>> RamBlockAttributes to implement the RamDiscardManager interface. This
>> object can store the guest_memfd information such as bitmap for shared
>> memory and the registered listeners for event notification. In the
>> context of RamDiscardManager, shared state is analogous to populated, and
>> private state is signified as discarded. To notify the conversion events,
>> a new state_change() helper is exported for the users to notify the
>> listeners like VFIO, so that VFIO can dynamically DMA map/unmap the
>> shared mapping.
>>
>> Note that the memory state is tracked at the host page size granularity,
>> as the minimum conversion size can be one page per request and VFIO
>> expects the DMA mapping for a specific iova to be mapped and unmapped
>> with the same granularity. Confidential VMs may perform partial
>> conversions, such as conversions on small regions within larger ones.
>> To prevent such invalid cases and until DMA mapping cut operation
>> support is available, all operations are performed with 4K granularity.
>>
>> In addition, memory conversion failures cause QEMU to quit instead of
>> resuming the guest or retrying the operation at present. It would be
>> future work to add more error handling or rollback mechanisms once
>> conversion failures are allowed. For example, in-place conversion of
>> guest_memfd could retry the unmap operation during the conversion from
>> shared to private. For now, keep the complex error handling out of the
>> picture as it is not required.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v6:
>>      - Change the object type name from RamBlockAttribute to
>>        RamBlockAttributes. (David)
>>      - Save the associated RAMBlock instead MemoryRegion in
>>        RamBlockAttributes. (David)
>>      - Squash the state_change() helper introduction in this commit as
>>        well as the mixture conversion case handling. (David)
>>      - Change the block_size type from int to size_t and some cleanup in
>>        validation check. (Alexey)
>>      - Add a tracepoint to track the state changes. (Alexey)
>>
>> Changes in v5:
>>      - Revert to use RamDiscardManager interface instead of introducing
>>        new hierarchy of class to manage private/shared state, and keep
>>        using the new name of RamBlockAttribute compared with the
>>        MemoryAttributeManager in v3.
>>      - Use *simple* version of object_define and object_declare since the
>>        state_change() function is changed as an exported function instead
>>        of a virtual function in later patch.
>>      - Move the introduction of RamBlockAttribute field to this patch and
>>        rename it to ram_shared. (Alexey)
>>      - call the exit() when register/unregister failed. (Zhao)
>>      - Add the ram-block-attribute.c to Memory API related part in
>>        MAINTAINERS.
>>
>> Changes in v4:
>>      - Change the name from memory-attribute-manager to
>>        ram-block-attribute.
>>      - Implement the newly-introduced PrivateSharedManager instead of
>>        RamDiscardManager and change related commit message.
>>      - Define the new object in ramblock.h instead of adding a new file.
>> ---
>>   MAINTAINERS                   |   1 +
>>   include/system/ramblock.h     |  21 ++
>>   system/meson.build            |   1 +
>>   system/ram-block-attributes.c | 480 ++++++++++++++++++++++++++++++++++
>>   system/trace-events           |   3 +
>>   5 files changed, 506 insertions(+)
>>   create mode 100644 system/ram-block-attributes.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 6dacd6d004..8ec39aa7f8 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3149,6 +3149,7 @@ F: system/memory.c
>>   F: system/memory_mapping.c
>>   F: system/physmem.c
>>   F: system/memory-internal.h
>> +F: system/ram-block-attributes.c
>>   F: scripts/coccinelle/memory-region-housekeeping.cocci
>>     Memory devices
>> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
>> index d8a116ba99..1bab9e2dac 100644
>> --- a/include/system/ramblock.h
>> +++ b/include/system/ramblock.h
>> @@ -22,6 +22,10 @@
>>   #include "exec/cpu-common.h"
>>   #include "qemu/rcu.h"
>>   #include "exec/ramlist.h"
>> +#include "system/hostmem.h"
>> +
>> +#define TYPE_RAM_BLOCK_ATTRIBUTES "ram-block-attributes"
>> +OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttributes, RAM_BLOCK_ATTRIBUTES)
>>     struct RAMBlock {
>>       struct rcu_head rcu;
>> @@ -91,4 +95,21 @@ struct RAMBlock {
>>       ram_addr_t postcopy_length;
>>   };
>>   +struct RamBlockAttributes {
>> +    Object parent;
>> +
>> +    RAMBlock *ram_block;
>> +
>> +    /* 1-setting of the bitmap represents ram is populated (shared) */
>> +    unsigned bitmap_size;
>> +    unsigned long *bitmap;
>> +
>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>> +};
>> +
>> +RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block);
>> +void ram_block_attributes_destroy(RamBlockAttributes *attr);
>> +int ram_block_attributes_state_change(RamBlockAttributes *attr,
>> uint64_t offset,
>> +                                      uint64_t size, bool to_discard);
>> +
>>   #endif
>> diff --git a/system/meson.build b/system/meson.build
>> index c2f0082766..2747dbde80 100644
>> --- a/system/meson.build
>> +++ b/system/meson.build
>> @@ -17,6 +17,7 @@ libsystem_ss.add(files(
>>     'dma-helpers.c',
>>     'globals.c',
>>     'ioport.c',
>> +  'ram-block-attributes.c',
>>     'memory_mapping.c',
>>     'memory.c',
>>     'physmem.c',
>> diff --git a/system/ram-block-attributes.c b/system/ram-block-
>> attributes.c
>> new file mode 100644
>> index 0000000000..514252413f
>> --- /dev/null
>> +++ b/system/ram-block-attributes.c
>> @@ -0,0 +1,480 @@
>> +/*
>> + * QEMU ram block attributes
>> + *
>> + * Copyright Intel
>> + *
>> + * Author:
>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>> later.
>> + * See the COPYING file in the top-level directory
>> + *
>> + */
>> +
>> +#include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>> +#include "system/ramblock.h"
>> +#include "trace.h"
>> +
>> +OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(RamBlockAttributes,
>> +                                          ram_block_attributes,
>> +                                          RAM_BLOCK_ATTRIBUTES,
>> +                                          OBJECT,
>> +                                          { TYPE_RAM_DISCARD_MANAGER },
>> +                                          { })
>> +
>> +static size_t
>> +ram_block_attributes_get_block_size(const RamBlockAttributes *attr)
>> +{
>> +    /*
>> +     * Because page conversion could be manipulated in the size of at
>> least 4K
>> +     * or 4K aligned, Use the host page size as the granularity to
>> track the
>> +     * memory attribute.
>> +     */
>> +    g_assert(attr && attr->ram_block);
>> +    g_assert(attr->ram_block->page_size == qemu_real_host_page_size());
>> +    return attr->ram_block->page_size;
>> +}
>> +
>> +
>> +static bool
>> +ram_block_attributes_rdm_is_populated(const RamDiscardManager *rdm,
>> +                                      const MemoryRegionSection
>> *section)
>> +{
>> +    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +    const uint64_t first_bit = section->offset_within_region /
>> block_size;
>> +    const uint64_t last_bit = first_bit + int128_get64(section-
>> >size) / block_size - 1;
>> +    unsigned long first_discarded_bit;
>> +
>> +    first_discarded_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
>> +                                           first_bit);
>> +    return first_discarded_bit > last_bit;
>> +}
>> +
>> +typedef int (*ram_block_attributes_section_cb)(MemoryRegionSection *s,
>> +                                               void *arg);
>> +
>> +static int
>> +ram_block_attributes_notify_populate_cb(MemoryRegionSection *section,
>> +                                        void *arg)
>> +{
>> +    RamDiscardListener *rdl = arg;
>> +
>> +    return rdl->notify_populate(rdl, section);
>> +}
>> +
>> +static int
>> +ram_block_attributes_notify_discard_cb(MemoryRegionSection *section,
>> +                                       void *arg)
>> +{
>> +    RamDiscardListener *rdl = arg;
>> +
>> +    rdl->notify_discard(rdl, section);
>> +    return 0;
>> +}
>> +
>> +static int
>> +ram_block_attributes_for_each_populated_section(const
>> RamBlockAttributes *attr,
>> +                                                MemoryRegionSection
>> *section,
>> +                                                void *arg,
>> +                                               
>> ram_block_attributes_section_cb cb)
>> +{
>> +    unsigned long first_bit, last_bit;
>> +    uint64_t offset, size;
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +    int ret = 0;
>> +
>> +    first_bit = section->offset_within_region / block_size;
>> +    first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>> +                              first_bit);
>> +
>> +    while (first_bit < attr->bitmap_size) {
>> +        MemoryRegionSection tmp = *section;
>> +
>> +        offset = first_bit * block_size;
>> +        last_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
>> +                                      first_bit + 1) - 1;
>> +        size = (last_bit - first_bit + 1) * block_size;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>> +            break;
>> +        }
>> +
>> +        ret = cb(&tmp, arg);
>> +        if (ret) {
>> +            error_report("%s: Failed to notify RAM discard listener:
>> %s",
>> +                         __func__, strerror(-ret));
>> +            break;
>> +        }
>> +
>> +        first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>> +                                  last_bit + 2);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static int
>> +ram_block_attributes_for_each_discarded_section(const
>> RamBlockAttributes *attr,
>> +                                                MemoryRegionSection
>> *section,
>> +                                                void *arg,
>> +                                               
>> ram_block_attributes_section_cb cb)
>> +{
>> +    unsigned long first_bit, last_bit;
>> +    uint64_t offset, size;
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +    int ret = 0;
>> +
>> +    first_bit = section->offset_within_region / block_size;
>> +    first_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
>> +                                   first_bit);
>> +
>> +    while (first_bit < attr->bitmap_size) {
>> +        MemoryRegionSection tmp = *section;
>> +
>> +        offset = first_bit * block_size;
>> +        last_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>> +                                 first_bit + 1) - 1;
>> +        size = (last_bit - first_bit + 1) * block_size;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>> +            break;
>> +        }
>> +
>> +        ret = cb(&tmp, arg);
>> +        if (ret) {
>> +            error_report("%s: Failed to notify RAM discard listener:
>> %s",
>> +                         __func__, strerror(-ret));
>> +            break;
>> +        }
>> +
>> +        first_bit = find_next_zero_bit(attr->bitmap,
>> +                                       attr->bitmap_size,
>> +                                       last_bit + 2);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static uint64_t
>> +ram_block_attributes_rdm_get_min_granularity(const RamDiscardManager
>> *rdm,
>> +                                             const MemoryRegion *mr)
>> +{
>> +    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>> +
>> +    g_assert(mr == attr->ram_block->mr);
>> +    return ram_block_attributes_get_block_size(attr);
>> +}
>> +
>> +static void
>> +ram_block_attributes_rdm_register_listener(RamDiscardManager *rdm,
>> +                                           RamDiscardListener *rdl,
>> +                                           MemoryRegionSection *section)
>> +{
>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>> +    int ret;
>> +
>> +    g_assert(section->mr == attr->ram_block->mr);
>> +    rdl->section = memory_region_section_new_copy(section);
>> +
>> +    QLIST_INSERT_HEAD(&attr->rdl_list, rdl, next);
>> +
>> +    ret = ram_block_attributes_for_each_populated_section(attr,
>> section, rdl,
>> +                                   
>> ram_block_attributes_notify_populate_cb);
>> +    if (ret) {
>> +        error_report("%s: Failed to register RAM discard listener: %s",
>> +                     __func__, strerror(-ret));
>> +        exit(1);
>> +    }
>> +}
>> +
>> +static void
>> +ram_block_attributes_rdm_unregister_listener(RamDiscardManager *rdm,
>> +                                             RamDiscardListener *rdl)
>> +{
>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>> +    int ret;
>> +
>> +    g_assert(rdl->section);
>> +    g_assert(rdl->section->mr == attr->ram_block->mr);
>> +
>> +    if (rdl->double_discard_supported) {
>> +        rdl->notify_discard(rdl, rdl->section);
>> +    } else {
>> +        ret = ram_block_attributes_for_each_populated_section(attr,
>> +                rdl->section, rdl,
>> ram_block_attributes_notify_discard_cb);
>> +        if (ret) {
>> +            error_report("%s: Failed to unregister RAM discard
>> listener: %s",
>> +                         __func__, strerror(-ret));
>> +            exit(1);
>> +        }
>> +    }
>> +
>> +    memory_region_section_free_copy(rdl->section);
>> +    rdl->section = NULL;
>> +    QLIST_REMOVE(rdl, next);
>> +}
>> +
>> +typedef struct RamBlockAttributesReplayData {
>> +    ReplayRamDiscardState fn;
>> +    void *opaque;
>> +} RamBlockAttributesReplayData;
>> +
>> +static int ram_block_attributes_rdm_replay_cb(MemoryRegionSection
>> *section,
>> +                                              void *arg)
>> +{
>> +    RamBlockAttributesReplayData *data = arg;
>> +
>> +    return data->fn(section, data->opaque);
>> +}
>> +
>> +static int
>> +ram_block_attributes_rdm_replay_populated(const RamDiscardManager *rdm,
>> +                                          MemoryRegionSection *section,
>> +                                          ReplayRamDiscardState
>> replay_fn,
>> +                                          void *opaque)
>> +{
>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>> +    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque =
>> opaque };
>> +
>> +    g_assert(section->mr == attr->ram_block->mr);
>> +    return ram_block_attributes_for_each_populated_section(attr,
>> section, &data,
>> +                                           
>> ram_block_attributes_rdm_replay_cb);
>> +}
>> +
>> +static int
>> +ram_block_attributes_rdm_replay_discarded(const RamDiscardManager *rdm,
>> +                                          MemoryRegionSection *section,
>> +                                          ReplayRamDiscardState
>> replay_fn,
>> +                                          void *opaque)
>> +{
>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>> +    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque =
>> opaque };
>> +
>> +    g_assert(section->mr == attr->ram_block->mr);
>> +    return ram_block_attributes_for_each_discarded_section(attr,
>> section, &data,
>> +                                           
>> ram_block_attributes_rdm_replay_cb);
>> +}
>> +
>> +static bool
>> +ram_block_attributes_is_valid_range(RamBlockAttributes *attr,
>> uint64_t offset,
>> +                                    uint64_t size)
>> +{
>> +    MemoryRegion *mr = attr->ram_block->mr;
>> +
>> +    g_assert(mr);
>> +
>> +    uint64_t region_size = memory_region_size(mr);
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +
>> +    if (!QEMU_IS_ALIGNED(offset, block_size) ||
>> +        !QEMU_IS_ALIGNED(size, block_size)) {
>> +        return false;
>> +    }
>> +    if (offset + size <= offset) {
>> +        return false;
>> +    }
>> +    if (offset + size > region_size) {
>> +        return false;
>> +    }
>> +    return true;
>> +}
>> +
>> +static void ram_block_attributes_notify_discard(RamBlockAttributes
>> *attr,
>> +                                                uint64_t offset,
>> +                                                uint64_t size)
>> +{
>> +    RamDiscardListener *rdl;
>> +
>> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>> +        MemoryRegionSection tmp = *rdl->section;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>> +            continue;
>> +        }
>> +        rdl->notify_discard(rdl, &tmp);
>> +    }
>> +}
>> +
>> +static int
>> +ram_block_attributes_notify_populate(RamBlockAttributes *attr,
>> +                                     uint64_t offset, uint64_t size)
>> +{
>> +    RamDiscardListener *rdl;
>> +    int ret = 0;
>> +
>> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>> +        MemoryRegionSection tmp = *rdl->section;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>> +            continue;
>> +        }
>> +        ret = rdl->notify_populate(rdl, &tmp);
>> +        if (ret) {
>> +            break;
>> +        }
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static bool
>> ram_block_attributes_is_range_populated(RamBlockAttributes *attr,
>> +                                                    uint64_t offset,
>> +                                                    uint64_t size)
>> +{
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +    const unsigned long first_bit = offset / block_size;
>> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
>> +    unsigned long found_bit;
>> +
>> +    found_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
>> +                                   first_bit);
>> +    return found_bit > last_bit;
>> +}
>> +
>> +static bool
>> +ram_block_attributes_is_range_discarded(RamBlockAttributes *attr,
>> +                                        uint64_t offset, uint64_t size)
>> +{
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +    const unsigned long first_bit = offset / block_size;
>> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
>> +    unsigned long found_bit;
>> +
>> +    found_bit = find_next_bit(attr->bitmap, last_bit + 1, first_bit);
>> +    return found_bit > last_bit;
>> +}
>> +
>> +int ram_block_attributes_state_change(RamBlockAttributes *attr,
>> +                                      uint64_t offset, uint64_t size,
>> +                                      bool to_discard)
>> +{
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +    const unsigned long first_bit = offset / block_size;
>> +    const unsigned long nbits = size / block_size;
>> +    bool is_range_discarded, is_range_populated;
>> +    const uint64_t end = offset + size;
>> +    unsigned long bit;
>> +    uint64_t cur;
>> +    int ret = 0;
>> +
>> +    if (!ram_block_attributes_is_valid_range(attr, offset, size)) {
>> +        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
>> +                     __func__, offset, size);
>> +        return -EINVAL;
>> +    }
>> +
>> +    is_range_discarded =
>> ram_block_attributes_is_range_discarded(attr, offset,
>> +                                                                 size);
>> +    is_range_populated =
>> ram_block_attributes_is_range_populated(attr, offset,
>> +                                                                 size);
>> +
>> +    trace_ram_block_attributes_state_change(offset, size,
>> +                                            is_range_discarded ?
>> "discarded" :
>> +                                            is_range_populated ?
>> "populated" :
>> +                                            "mixture",
>> +                                            to_discard ? "discarded" :
>> +                                            "populated");
>> +    if (to_discard) {
>> +        if (is_range_discarded) {
>> +            /* Already private */
>> +        } else if (is_range_populated) {
>> +            /* Completely shared */
>> +            bitmap_clear(attr->bitmap, first_bit, nbits);
>> +            ram_block_attributes_notify_discard(attr, offset, size);
> 
> In this patch series we are only maintaining the bitmap for Ram discard/
> populate state not for regular guest_memfd private/shared?

As mentioned in changelog, "In the context of RamDiscardManager, shared
state is analogous to populated, and private state is signified as
discarded." To keep consistent with RamDiscardManager, I used the ram
"populated/discareded" in variable and function names.

Of course, we can use private/shared if we rename the RamDiscardManager
to something like RamStateManager. But I haven't done it in this series.
Because I think we can also view the bitmap as the state of shared
memory (shared discard/shared populate) at present. The VFIO user only
manipulate the dma map/unmap of shared mapping. (We need to consider how
to extend the RDM framwork to manage the shared/private/discard states
in the future when need to distinguish private and discard states.)

> 



