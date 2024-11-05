Return-Path: <kvm+bounces-30619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E96B9BC4A9
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:26:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 388971C210E9
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E2E1BE223;
	Tue,  5 Nov 2024 05:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B0FUTtF3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5457C1B4F0F
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730784357; cv=fail; b=bjAWDeFcpd4ZiIMfcLDFGKqCKROUHfnvNlsvmpZ0PGQOJJLCVaf1XH3oJFGloN4hzz93J80TbbKAA883ohTdu6ZoXFaQF8g/0WGQhNnpmPTzOMVANfEJ2IgSYEjg2dLm4PluJL61ls08rRfPwdYRuk764iyaRiN4Od9GCED3dUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730784357; c=relaxed/simple;
	bh=Y82Tu3Da6gCyncC907xlDgzQHQTL9Aj0qht9zg2xWz4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ouElO12Xy2V0R8GK42vseuxcUIa0tqGlUUiNAIELse6QG5KReASYH77b+X3j30S34rZBreLrRSCMgziNi8o9DOE6vXUwvosQKCIGKPtLL2lkhirQQjiH1cVulODS9jBkVlE1FW1iloURJ6UBBL0ixn27YPzGcu+DxXnNrfdNHCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B0FUTtF3; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730784356; x=1762320356;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y82Tu3Da6gCyncC907xlDgzQHQTL9Aj0qht9zg2xWz4=;
  b=B0FUTtF3YV7TkaaBs7DSTY46nswuZ3bBNT57wsqNeHXak13OxYoUHU7X
   3lnwu6YFRWOWHfxUXFkMwMqZkqs/1y5mMlrHCyHvTYF6qcJ99olIk4LFs
   K8q42+IHiqJirx/AjAuHGKSyQXukP0YIDYCUDFtiWPW10Zdh31gvv7/5E
   pXgvW8tnCSvdc99cHa474GjD4+nglp+IVOAUYQA1a6uiWF4gCZdsOvaGu
   DF5vj5rHatPYMpuOPYarcu5Jwgi1pcj7LFccW8a57cL1O0uD3ETrE7nuf
   g5WDJoBVp/5L1j2HjNnFbBjAs85xATCYcl0/KHQkvCtGDgRaleFY8e8kh
   w==;
X-CSE-ConnectionGUID: 7SfIQt+iQ2WvEkIdVOMIog==
X-CSE-MsgGUID: DcrZoVCbSYuDNndCzB0f4A==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="34294133"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="34294133"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 21:25:56 -0800
X-CSE-ConnectionGUID: CWDedePwTdCMWa+IHSzjeg==
X-CSE-MsgGUID: SkL1P22GQxadBJNIX4CeuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="88387678"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 21:25:55 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 21:25:55 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 21:25:55 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 21:25:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mlk9TYQbPJ771po5p+PLscbmXHOV6luPql1gsUHVOwvra7XBKXVy3AWQRWx2ee09mhivF9Leb8/EhUUf86TjYvv1b/M3/zxJfyH2SlyM85iWmLX1qzXg+PALnHZKQSNw1vuDipFh3bO7eN58EkIut6FBVcE0hv8jDrRe5YUgqHyefeybracViRqC5rXXwgYfnP0izjCTKo8nsUxX8Sp/VBmkPcJGAm3Q1HkE+nX/fZRnHTbq+J6o6EWz5bj33guXKohVnqO72VhCHOTM16/kQXKKodLATeKloudXxyOQ2/0SrroKKcEWBgq9fZZiPl6VHV60yahuIWG+5i1Y4WjChw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f5qO7JCyOuBR1M20M6IWvhvBi91sPUEKTpDK0ua8tH8=;
 b=RvnJAurg2DSuWvoOD+imV1+lGyu2iKkpyEA2bCdMIRCPuXbLOCCWmjvTTHaqO5R6AFOyl3ZxANMEw1E0BDzQV8Tn4AuZoJ68UyGaW2a5iyAueDp88JnglUK5KLj8BcmIWlVX5Ycrx7WEzQmU1a7GInBjtN7Ipud1TDqqeAZPaW94I/asFnkFCisUPtqt0JkARLgQd1rhFw3o4LVEwRnzSvcvkyGprNTqXqm1DEBfbdcAreZh2M7VOh/kPmvYkJGULStCm9qRB5SvdcZRD7sl14qNTujuxmzXe32AX9lqrzxu7dfh0Ysng0O+fiz1dHHY82f9IHMjnQWuyoofjJLnog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB8364.namprd11.prod.outlook.com (2603:10b6:610:174::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 05:25:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 05:25:47 +0000
Message-ID: <2b6a427e-bd3b-436d-9f24-b44d28ec4778@intel.com>
Date: Tue, 5 Nov 2024 13:30:24 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/13] iommu/vt-d: Fail SVA domain replacement
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>,
	<will@kernel.org>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-11-yi.l.liu@intel.com>
 <0781f329-49a5-4652-ae94-d0bbefa8dbb0@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <0781f329-49a5-4652-ae94-d0bbefa8dbb0@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0045.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::19) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH3PR11MB8364:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c063282-f17a-4ac3-78ca-08dcfd5a4dec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cXBWcWVvU25yR3FyTmVKMThRSXNhNmp6ek1jTzJYNEpKdVhIdlBUTXYvb211?=
 =?utf-8?B?UnZyZjdIWXNCNGtPWVF3LzBseHk3T0YxOFNGaFp6ak1zcXFkdGlyazNRb01R?=
 =?utf-8?B?TndwSi9KQXZjNlVRUHBkRk5BL1crbzRZYWZ1VkxHV3BlamhJWGxnSTZEajFU?=
 =?utf-8?B?RUk4R3lrdVlIZkVkbk4rc1M4NnRjYWErOEJvbUpRWDNpUm91MDlDRGN5bjgx?=
 =?utf-8?B?QTczS1E4Y2kzRjBoZy9WaXpxRW4vS04xVVRDUFQyQkZtcHJQOThrSlRCZGlZ?=
 =?utf-8?B?Z092eVRtUlgxV21HWnhkWEhqQXViTDZqRTZobUZFc21PeW9kdkk0cjdzVEVs?=
 =?utf-8?B?bW1tTjFTU0hyc3hUdnFaZGs0RWdjc3p2UldTWUlxOElnSFFTSDloZ0cya3Jj?=
 =?utf-8?B?QUUrOXdleGtlMG42RFRsOWRCTjRLdHNSUGdkSHBESW8vRGE3aWRZRWtMN3Ax?=
 =?utf-8?B?bWs2V0dMNWUzYTV1VGpYdTNXaXp2a3pUamRxQVZuTnFtbXlGQ01DN1k5NzNv?=
 =?utf-8?B?SU5adjM3dHhHTjJ3T3JiSlNBaEhkRDBYMlB3UVc0cFVzT2xyeE1FbE9KdHFQ?=
 =?utf-8?B?VzlDN05VTU1vWi9Iamd3MDRTNlk3OHJmMXpkb2o2RUtOM0QvQmljWjZtS1Vt?=
 =?utf-8?B?dzZoR1pxVUovRDVIVUtKNVBHVktoVTZDSnVmZ0FaZWx2alY2bXhDVFpCWnho?=
 =?utf-8?B?aUFVV3dQVUt0ZnpWM2JCb3h1STdLNG9xdzRXZHJVaDhTNS95NjF3bG9MREpi?=
 =?utf-8?B?aU9KVXEyMHZvNFkyWmxFdFNFZ0RIbStjcTFtK3BCcWEzSFUyUkZucitzZlBI?=
 =?utf-8?B?SFdHZG1yc2VKWnpDdm8xVjR5a1JKTXFZY1ZpOTNHS3BSbFplTnFwTEJ1YXZK?=
 =?utf-8?B?d1VoMkZoam9YS3IraUkxSkJSVjZrWXMya2pERTZvaTdTVG1JWWhUaWNJWVZ0?=
 =?utf-8?B?QVl1UTRBL2ltM094WmhOelNxNXJMSEJxNFFDM0M1YStRRTB4dXJHOTF2Ulkw?=
 =?utf-8?B?dmdoUjFEcFFGTGlPd244UnY4OU80K0RHUGl4WEtOZ1g1bFo5UzZkZW1DMmhS?=
 =?utf-8?B?WGdYS0gyUnNLRHlYSDRZR1l4Nzh1a2V5UTE3eHkrZnU4RCt6YnlSRldBU0tL?=
 =?utf-8?B?bFJrcTJ5VWduSkZrdGFYK3Rxd25lVHNxYUxFS2pJeXE2TlVTeWJWRVM0THVI?=
 =?utf-8?B?aTlGY0VUcHJqVGpiUVpjWDhPZXVKam5FMkVaaXRWZGlYTkVKZ0dSWVY4bDR4?=
 =?utf-8?B?aGxoQ3pXNDhncHFETHFlYlQzNTFVRVJyR2w4U0ovRG5KcUFHbkZaRGZmU2ZY?=
 =?utf-8?B?VjltYUVobG5KdUIvTHVGVDk3YS9kbkZDM1B6NXVKWnI2cEkybHd5NldMSTZK?=
 =?utf-8?B?V05vTllXS2NCalV1c0hiNEsxdzRna0dkd29uOW5mUDF1a0wvWTR6ZmdxYndt?=
 =?utf-8?B?TUExWkJ6SldrazBsR2l0MWlVelR4cTQvbVNIczVRRklLNldzRU5HaTJxSWFz?=
 =?utf-8?B?ZUJXM1JFaWFDeFJhT2xwUlpsVnFZUW5IYWNaanlMZGtzZjE3V0pCZTR6VW51?=
 =?utf-8?B?UmthNTcvbXFGcXg3ZzBWOC9ydnZLMVA1NmlsWE9QOEFSMGFBOWsrUkh0VmNZ?=
 =?utf-8?B?QVpuUjNndFpvSllpNE5OR1hlMkY4M2FNcGFPdDdYbjNQMlhYV0VMMGxxSnJG?=
 =?utf-8?B?bk5nWTZaQm9MVG9hbStUbityZ3c0M3g4N25iSG9JUzBaVURJMWhTZk5wZUFP?=
 =?utf-8?Q?5x3UH3gjcY9DXfCSDE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnVaM2J2alM5TUt6RGF0d3RYZ1Y0STM3S1NjYTY5UlR3anF6eHY2UHQwWmpX?=
 =?utf-8?B?ejc5YVRCQmp1UWxCRks2MGwwV1NIVzZ0NXREVXFQMFJJeG45Q3dSc3ZsREd3?=
 =?utf-8?B?NXhDOFc5WWY3VDRVWkhabWZOR2M3U2loWktRM0g2U2VvdFo2T0N4Snh0dExu?=
 =?utf-8?B?dnJlSFczejZaZCtJNFJhRzJJQm1pb2NHNkRRVDFlOE1YOHVyRDAxSWoxOFlw?=
 =?utf-8?B?U0t4R3B0bTk4VmF4b21hZEJKZVBiWkY2Y2pqT2lwVjVhTHJMOS9jTmNUb1Fp?=
 =?utf-8?B?OTIyVDFUa25yUWhubGY0dk93QzdWZzFIZHVrMlR6NFR3akNvbGtnRE1vV2hO?=
 =?utf-8?B?Z0diODBMWjV4cTgyWjNpeFA5ejNLRXNSV2lkMDNZRzJlWS93V3pqMUQzNmZL?=
 =?utf-8?B?KzIyNUt1M3VUN0tCTjBZZU1ScDhjeEduWEVOVlBsckZjM3J4R1FNNDBzTnlx?=
 =?utf-8?B?b0U4azF5eTJEcHpzN2FxSXdrbkdMemhZZXd1WEMvS0FvMmgwK0hQOUMxNnFX?=
 =?utf-8?B?NXExTHF4S256ek8vQk9aNHpKMGY3djFXdmQ0MUxkRGlFdGkxZUR3UklQcjZr?=
 =?utf-8?B?Z2c1bzJKSFRKaG5lVXhkVkR1RGJNZHJwM0IxNDRuWnhZOWNCNFRURXAyV3hD?=
 =?utf-8?B?Z2t6TVJwZ2JEZFl4VFZHSWFYZVpVSFRJNmUrZjI0cmsxT1hBYUszczhwd0Vo?=
 =?utf-8?B?V3MrczNXdnozTVNBcGY4djl6Zm1CTEVUMTIxQUVsN2NtQ1phczJMUDhXdVhn?=
 =?utf-8?B?bHZaZmU4TVlSbDRNSXNlamowM0NLNlJ6cXQyeHVONEhmUGRZdGx2cWM3anll?=
 =?utf-8?B?VFJFYzI0YVRHZ2QyVVNoUUJhTGxNTzlINHhwaythSU9UR1ROaitXUHJvckU3?=
 =?utf-8?B?Nm42ek1FS2V1SHBaNHQ2ZnRxa0dGSGx6WFNnK0E3R0JTUlNGMXY5Z1VlMHNP?=
 =?utf-8?B?MmRFMkNUL3pjRXZ2dThPZGNEUlVqaTAzdlJFZGpTYWgxMTBkQlpOeE9HTHlM?=
 =?utf-8?B?SFJTajJpWmRCeGFnNmtETTloMHFyQVBwN3JQRzVMNTQ0RDR1OEhqcG1PZUpC?=
 =?utf-8?B?TVAvaHpCdnErSlRJZUtiYURJcWRoVHpSLy83a1FTNk5hR1VGdEdCL2lOWkZj?=
 =?utf-8?B?VTIwb1hqczBYZmFyMC8rZTVzNm9FK3p6KzlyZkMwcVdnMFpncXNqWVQ2Vmxj?=
 =?utf-8?B?Z3FpUWFtV3l3TUxmREVRUU80UGZKUVpJOHpDdXpERE00a05JUlhvdlc4bmY5?=
 =?utf-8?B?dVJZSXo4ZHl6MnFnQVhJK0FSWEpWZG0veTV5bDdFZnhDb3ZpOGJyNEkyM1BS?=
 =?utf-8?B?alVVL2ZONWMxZFNXNUJ6VFJiSU9UVndXLzB3b0JqaWJkUGhvb3Q2RU8rcy91?=
 =?utf-8?B?WGVVUU5PczBlOXg1OUh4ODFLOUFoanpWUmRjSlRGb0lINy95Wk5vNFE5ZGJy?=
 =?utf-8?B?TkNRYysya0x3L2hlQTFzUmUyTndrKzBzb1k1TUJGcllMcllYWWpyRENkdWsx?=
 =?utf-8?B?dzBXWlRJTEpEcE9kcUFEbGlVdmhXY2xReTl3NEtVMmFSa3R0cVFmbTU3THdF?=
 =?utf-8?B?QTE1YUgwQktpZjlLOFZ5S3UrTEVnWi9CeDhqT2J0Vy8rS0Zldi9MVnRoY0Fs?=
 =?utf-8?B?c0RhZWpFOWJhYkpBaDJVOVllTmpDNVpGbE1HVEZqR2lldHk1ZUg5dzhablJJ?=
 =?utf-8?B?blVKR09LSTR4ZE53L0ZlSzNORWlHWEh3VGF5RElDWGFlQ3Q1U3lIK3JUSDZt?=
 =?utf-8?B?VjBJWFRHK1ZWWEFUSzloR1JFKzNrZmVjdWNwQ3IzOTlxV3BROUJsQVVsTHBK?=
 =?utf-8?B?a05rZWRrcVMyaUY3ZnFOQlJtbUpjZyt0Y0tvUWxJakZQdVJYYmxWMEk0UFMx?=
 =?utf-8?B?elUyS0ZBbFo5Ukx3UFlpQXpzTER6Vjg4eWRZalhrNllhOXpFUXhqS0dwNUM1?=
 =?utf-8?B?dWlsUVdyVVRHZStWY3AwWFN0N29SZVJjUmFzSk94VXRqa3ltdUkwRzBhYjV3?=
 =?utf-8?B?VW54cHpKUmVtbUd6MllwRHE5bzNPY1loUGdZZjJkcUtHNVVFcFFpNFNvK1FK?=
 =?utf-8?B?dEVDQTY0K0Y1eEVFRzhzSDZtbmpxVWVBR01NT1A3NXJ4ZktFb3hoNHcrWGRJ?=
 =?utf-8?Q?EVj9e0xy8/8/RSBmOA2x3r4tX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c063282-f17a-4ac3-78ca-08dcfd5a4dec
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 05:25:47.8941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rm/u+urKofZl84t3SRiECxOFrynqB0p3liEPGAVuoYgl6hw/K8sPitfnxrltBnCgffeHpj/SVp93dZ8408kVDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8364
X-OriginatorOrg: intel.com

On 2024/11/5 11:30, Baolu Lu wrote:
> On 11/4/24 21:18, Yi Liu wrote:
>> There is no known usage that will attach SVA domain or detach SVA domain
>> by replacing PASID to or from SVA domain. It is supposed to use the
>> iommu_sva_{un}bind_device() which invoke the  
>> iommu_{at|de}tach_device_pasid().
>> So Intel iommu driver decides to fail the domain replacement if the old
>> domain or new domain is SVA type.
> 
> I would suggest dropping this patch.
> 
> The iommu driver now supports switching SVA domains to and from other
> types of domains. The current limitation comes from the iommu core,
> where the SVA interface doesn't use replace.

I also noticed other iommu drivers (like ARM SMMUv3 and AMD iommu) would
support SVA replacement. So may we also make intel_svm_set_dev_pasid() be
able to handle the case in which @old==non-null? At first, it looks to be
dead code when SVA interface does not use replace. But this may make all
drivers aligned.

> Looking forward, iommu_detach_device_pasid() will be converted to switch
> an SVA domain to a blocking domain. Once this is implemented, perhaps
> the check and failure scenario will no longer be relevant.

you are right.

-- 
Regards,
Yi Liu

