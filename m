Return-Path: <kvm+bounces-30917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CAA19BE4F4
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:56:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F9151F2559D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4A9A1DE3CD;
	Wed,  6 Nov 2024 10:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BFKEtW1m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3281D193094
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 10:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730890597; cv=fail; b=FJsD45q1KMewGFmQb6woLMOnvuIF/eMLZ10uaDSE5bIza2GJo8Rdo8JZ5n/80Gorecj7FrDOy8I31kOAdcWh1Q7O2As1Sj8jmBY3tIIRhPIRWiSDjg8mb1W1LMVPCq6UHMQEzSqq4Ux2GBUNCYiSribD7jdjCMok9f1DVw25+Sc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730890597; c=relaxed/simple;
	bh=BAFRSX7er+CJpd+IEOrb0cPtxiAMIg00rKnIcXrT0iE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AVRIz9O3KeXe8Gqy2oCqEbyynEJBFimyEwd2qJNu0rh0AQS1O7mFF4MftZPY3ZaVCkX+0FwQmE/ZZo/l0lstw35vLl6NMG8U7PaVDGlEBRRtxDkdAsMEahI1hWBwaNPrOmk75xbtgkSQiXou7laP90PekAl3LYPQldiodLD8mME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BFKEtW1m; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730890596; x=1762426596;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BAFRSX7er+CJpd+IEOrb0cPtxiAMIg00rKnIcXrT0iE=;
  b=BFKEtW1mpieRJbD/2aU32BCdoNUYzW3eUN8pv0B/RNi96rU/2fGvk1bQ
   jjD4QhJX96mS6LLyEnxa6pAgZglxdq05Z/nxeTKMujoMebnc3SGlp7zRF
   QqMfqtlgTS+9gAFSBn+e4cN3R2JiMfqYi7FsqnrXLw5qwD1nflC4sVyq2
   /7f4hwGDN3Qpb4hx95ORYg0+tT+JyCTCiqMrAGrtbRITpTWsJ/SDQJQCr
   V8sZYNOwS52vltVbzJSSZgCFBxum9L8uKgr+5oyDDXNOez4+vutDb0Xzy
   mwJNj7+EGshc1WQ1GHwqo/p4OXtBWopYak1mPg/zzAPd6tG9A2rhQL2BI
   Q==;
X-CSE-ConnectionGUID: TXljiGNzS6i04XZBEMSB5A==
X-CSE-MsgGUID: seyrr3IDSuGND5vtf1WqdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30110141"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="30110141"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 02:56:35 -0800
X-CSE-ConnectionGUID: hEzlnGpRT8OkFST5QZyTng==
X-CSE-MsgGUID: GjLvmTs9ShSssLDBYZWwSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84828860"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 02:56:07 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 02:56:07 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 02:56:07 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 02:56:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g3XW2dOUZAIClY22qAanHlAEXT9AKfJIMrezS+CMO929v1cCTWNSCWl5nSsHnqr+n4+gcu57nlJ4RxnwpxabVGgSKlqs3KvK5U+Hm5bF5B2zaxk9lgeipYrVjmAR7jTnT7VEnJZb3g7/H5MjB0h8oihil9VttR9mQnalLOPIgn7CkQYwsUsK9G2aEaugksev0EHv/VBjs+J3eBVjm4dDQDXKrDqffmZpHm11e0tP3O/lY2NdU28yLm1jCMCMrQEZtZQOg9Sydm4ohQncVjBDYHxkej5yYDmrPoZfYxG5nq2qYVWxN4zzuuljPoGOQDDOvffmpGOuullOPADe4vrITg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OcQp/RJkZDNoLNoHNYZ9n5ibaD1DqOJcusal/J3qats=;
 b=E66cKMkY8hTnVRdeuZeboD5GRNYFaPoU1yP4291EAleiOzGdHnAnWAIVOD+MIYCYwDXjnirgEi9sX0wDBt0BftbGWP9KL/W3nwTimis+262mRAhU0ZR4TcfpywQMd+x58R3Bzqh+BWjypmmmHGvk33fQ83L2ExN9DoFq59eDjrp3beXGA2/3+hc4vISzD/bSct6wBvmdzchoB493xaHrklHPaFGxS/ocKUIpC30NGlEylT1PxbXifEHLwVqJfuCrtH84XvBx1nzNwtU7qMUe91pyUgaC7p/qNZWv2CTeP82GdNqSA3dhN8NeCGJ6pXrSWi7gi4fsTv+7XDlg/VQqcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6489.namprd11.prod.outlook.com (2603:10b6:208:3a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 10:55:59 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 10:55:59 +0000
Message-ID: <348f3139-1ca7-4893-b93a-90c7834ce30b@intel.com>
Date: Wed, 6 Nov 2024 19:00:35 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/13] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
To: Baolu Lu <baolu.lu@linux.intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-12-yi.l.liu@intel.com>
 <BN9PR11MB5276F52B50577B8963A20BEB8C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <778d4e7b-cb4f-48d6-9b5d-de5e18c1a367@linux.intel.com>
 <982f10e2-5fc7-4b13-9877-77042ce20a11@intel.com>
 <ae559732-1586-4099-a753-092fc7a698cf@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <ae559732-1586-4099-a753-092fc7a698cf@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0056.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::7) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|IA1PR11MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: a9a59d7b-c34c-4238-55ea-08dcfe5198be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?emI1c29PZ0pkbk42eXBnVVNkdXYwUWNmTXpYelFJbTVrc2hVaWVsWmcvK3E5?=
 =?utf-8?B?T1d2VlNub2lyNnhxeTFoc2FjZWJkTk84eDc1VnZZMGcyWnd2alZLQTc4dC9U?=
 =?utf-8?B?Q0s1SGpSc3FqOUI0UHF5WEZlaGhjeG91WVJ2MEcwZkFBL1NNSzlqanVNMU8y?=
 =?utf-8?B?REhjbVlxcmNRQzVqeWtzS3dyRVdDWFJ5QTJ2aWhjUTJlck04THEySUJDZ2du?=
 =?utf-8?B?bmE3YWhmRjZSNE9sem85MWdPT1dRZ1plcjI0ME1WVkRPblRJTXkxRU03SllU?=
 =?utf-8?B?bjVEWDZCNDlFOVIxUGpueXZOTUs3cFJDL0pJYnhmT1JHK1FJUElNU0xaQXNv?=
 =?utf-8?B?ZS9KS2FUajBjTXkxWXRoUThSUjVDUEtraDFXcktEV3RoaFZlSGZsZkh3MUFx?=
 =?utf-8?B?ZjRnTE1ScUF1K21COG44aHVEV1Nkc1ZaVGhEK1hKRFlJOHc1dkRYUWNyLzNj?=
 =?utf-8?B?Z2dKUmt3VlFrWG1hT2hyVTJTc3oxSUphcjI5Yk51R1MrcXdDL2JiWXBlbDFM?=
 =?utf-8?B?aEo3TFNQUnY2VDA5U1lPVURiYUsyVERUOXIxMzhMMlNhNzVsVlVMQWw2QS9E?=
 =?utf-8?B?UFJLV2VMdm1XaVJmdTdTaXpUa2Q0SU91QnlFbmQ5elAyVFJ5MmtaWWtIczZP?=
 =?utf-8?B?M0dqRHpzL1ZsMy9uaXBSTHpYbFNBNXNTUWZLcTRiR3UwTGx0Qkw5WktCWnA2?=
 =?utf-8?B?bzZuZG9IaDRoUnZ0ZjhvUU5SVExLTDVmMEJibTBSQXgydDZtM0d5UW95N2pF?=
 =?utf-8?B?cWF3MEUvWnl1OHpyV1puUi9WZzJNWnVqdVY5NitIL0VOTmhzYzVQSXRia2Rx?=
 =?utf-8?B?ZW1uaDYvbEZxNkVLK21GZkxhbjR1K3dEMjVVT294dmxtVDZWeWthbU9GTEdS?=
 =?utf-8?B?TWlna1RVTmlQd2UrQ01XbWJqMzVmR3UyQWNuWnY3SnpabUJ4Rmw0bDRPTVF5?=
 =?utf-8?B?MS9pVzU1ZE1rZlV0MDlPQk9DL3gxK3pMTDdGVy9QMm92SUkvS2VTRXprejVk?=
 =?utf-8?B?cjZVQUljdUV6R1EyWVpoUXhqbzVvWjZuc3FpTDN5L2xhaldBa0g4WjlzYUt5?=
 =?utf-8?B?c3J5dHV6aEJVOVdHMzh0bkFCbnp0bmFOUnM1eE9ZRG13TjVBcVBZNUZyeVhm?=
 =?utf-8?B?M3FmdHhrSC95WlRNL09lR25aSnRQZWFrNVhnbGZiLzdUUkYzOEJ4Ung1bWVh?=
 =?utf-8?B?aVJwaDJWdnFUMlNObUVjd1FYaS9QQVpYcmZjTzNRQUkyUzdCbEMvK05iNDRn?=
 =?utf-8?B?L0pZekVaNGUwL0YvUG0rNFAxVHRaeW84azFpVXlRV2szaWhxT2o5L1k4K2tM?=
 =?utf-8?B?QWpaOFd1ZjJHVlhYVzdOV2phNWFoY1JhR05ldWlMN082alUvVHd5M1RkdzUz?=
 =?utf-8?B?WGxyVTVWOHBsREhUbXZFT1hORWp2ZlUwanNLUzVVUUpyNGo1NWptM2xVd2VI?=
 =?utf-8?B?RG1Jd3QrdDdjc3ZFUjgvMzllNW5jSEFHRTE2cWZrV09aTllwY1lUNWwyYUJT?=
 =?utf-8?B?ZS95VVVVQXRGRG83K1JzbnQ4MHNBSE1LVnU0R2o5eHhhNlJCWE1kS2Z5Nm5q?=
 =?utf-8?B?ZFpsRzY5N3ZxUHZROGpkZDZlVHRKSGxMK2IxRHU0UWtGNE5hSURLbWtVbkhx?=
 =?utf-8?B?a0lsbkJaUkVKNUNpbVkzWW1Qd1FBVy80dnZDbDRqTVFXcHBNR2FLb3hRanU2?=
 =?utf-8?B?b0thdnZFbzRmOFVBa0lPS0cvazRFdkVjenp2bnZGY28rcHZsa2Q0MVhMVnZY?=
 =?utf-8?Q?W3PAyb++KFBE4ykN9vXmosjj9HLq4RymFOzOmp7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dk14TThKV2dkWklLUHNkUm5ubHlMSzVibk8xL2p6bkVXWUdPUXlrbzZ0UWxw?=
 =?utf-8?B?VGFsTGpkc1VNa0pWc0VsOUhIM3NncHErNHVoWlRkeXBvTHRtMG0vc0p4U3Ir?=
 =?utf-8?B?c05ZVVM4V2EwaExRMnVlc0ZlUnNNVGs5N2tPdkhrRHdOOTliMlVMYlFvRWdI?=
 =?utf-8?B?SFNxcDRVTW9ZV3dxNkNKdEJqN0FocGNDcmlvcjErV00xZS9TdGR4dUdhb1Mw?=
 =?utf-8?B?SUs0Yk1zTGFBU2s1anpobmw2cjRmZ3Z4SFlZSWtwcW5GRWpGRldrR3RISVhl?=
 =?utf-8?B?RDlhUHZGY0NubHAvYUhmNWt1S2k4ak1JZ0J0b2pITWZoZzlUV0FVd29XVTJn?=
 =?utf-8?B?NGdXMnZVZTZVMVpOdlc0VlREQnVKc2dOdVdwTGhNL1pGdWN5Z3FRZXRDQkp3?=
 =?utf-8?B?UmNVTVFzSUxIUUZUTDRjSkZSTlMwWVhVendWWmR1b29Hc2dDMVllVHIzWHpK?=
 =?utf-8?B?SXFTbUFUckFvN1VsdFBzek5ua0ZUcHNMSTJXVnVVZkdkQjRsWklxUXhVWkxo?=
 =?utf-8?B?UFZEY2w5NUwzMUhvMWxMc2JvVDBaeE5hbzZKU2xjZjJSdFBXZVQ4cy9iTWRu?=
 =?utf-8?B?RHhjaURvWVBmdjBMSUVFU2dSVEVPZ0xOUlB5WHRMTjNZSVhRZ21rYm1LUWwx?=
 =?utf-8?B?UEFQSG9xUWVXTk1NWlQyeXFPVTM0MmhOL1Byc1VFRUZ1TXBkYjkrWHJFLzd5?=
 =?utf-8?B?dlhOWTVRalpTZkwxeFZ3V29XZXg4d2E1MVR2bURUUGl2ZTZULzJFWmNKWHd4?=
 =?utf-8?B?TU1hSmZPSjJlcSthTzBicmpVN0l4bHBPY2VPWElTbnRKK3Y2VzFodWsvTVU4?=
 =?utf-8?B?dFBaQmlKR2NyRjgySXJYNzBuQlZjQlNkZ3NhbmZJOXJwUUMyaDlpaHk3cmh0?=
 =?utf-8?B?bU1GaHNOSlBVMnB1Z3Y1b3lvVVJla0dock5lY1Z6RXFTMXBuZkFNbU10YVFP?=
 =?utf-8?B?RVZUVE81NlIrRktNT3d6M0ZTS1FuQkJHQkQrU2FYNmdxbXQ3TzZocGQ0cDd5?=
 =?utf-8?B?VEs3QlpzRUd5TU1jVys3WTNsSWUzSVFRQmREU2xtMnpYdzZ4aTd5WE9YZGEx?=
 =?utf-8?B?RWc4OGNZQzRQOWgrSTRVYlZnUmpTY0RRb2ppMS9sUnFJMmlTR2F5dzk1ZlNV?=
 =?utf-8?B?RFFKdlBleW9jcDBPWW8vQWc1eFhFeWhkaHVvOTNiMERyRlhZKzZwN3grbnIv?=
 =?utf-8?B?WnpTTFNTZUFzRzJ0VmN0b21yNmJYL014cjdqNHB3ZDNUdU4rL2ErQXlBZ0ky?=
 =?utf-8?B?cTZ6ald1dHp3L2pqNHR5ekY4MGM2dkFlblRML2VqQUFSQkdMTXlTTlRsdjQ0?=
 =?utf-8?B?cWtrM3c4TEcyWllQd3BDbWxmSHkvTWVFQlFlZ0lWY0hFaURwZTZqUFZHNXZa?=
 =?utf-8?B?Qjd3R21WNWI0aWlLZUlkNEg4dStBckw5TkNMWkJGVDhqdFBnNkt3TjFvTlFu?=
 =?utf-8?B?N0ZBTWFQM3hRNjZpRVRnYVdrTHhkWHY0bVovVU1hRzFZRGswa29sT3lZSDBN?=
 =?utf-8?B?ek1Cb2ZXUUJvb0xubUkwRUZqbjRXSFg2Q1FYWFN0MTd4RHJTcGNibUJKWmU2?=
 =?utf-8?B?eFJyRkoyV0w1YjhmbmFFODdZeUdOSFAyUzFCazIySmhvSHVwT2ljSDRoMS8z?=
 =?utf-8?B?ajg0TmxKVlc5aXFJU0UrbitRdG9nMklNT3dMZTJmTGlIOXczWCt5cXhHTkxO?=
 =?utf-8?B?ZDdwYy9WWHZURWNpNy9BdDAyVVVmdzVwNmNnbktRenVTS0RYV2wrbSt2dDEv?=
 =?utf-8?B?QWZxQUxJWGZReHVQN2xJT09OSHZFNWl5blc1d1hOS0RSNDgwNFUvSkYzWmFF?=
 =?utf-8?B?V0hkZ1dXQzdNVnJSbzd0MTVVbDBtdkZ1b25EU3pHeThuRm9yZ1k4ejlqT3J6?=
 =?utf-8?B?WWRFV3ZlMjcycnh5dXRQbGU4MVdoSCtzRDB2WFpnRjREYllxdTROa2pKcVBJ?=
 =?utf-8?B?aUFlVUZZYTVYQjJhRHI3bU5KdjhlQ0hHR3FhenUzY05wUXl2WGZZanZFZFUz?=
 =?utf-8?B?Um9pQjlMWUl1VlVEdDdjQUIvdWQyc3ZWSmcxZzgxODZGMW4xVkt2Ui92aXVy?=
 =?utf-8?B?MUlEMUxqS2ZienhaczRjL1N4YnlBZmpGS1pHTExodFlPVzRabHFYalVwTkNK?=
 =?utf-8?Q?/sVkfQ1kkW1jJCXIMLMzUFWMQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a59d7b-c34c-4238-55ea-08dcfe5198be
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 10:55:59.1258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5RZtQVeyiFusgYQZEH14FOPwMPZCF7JmALu1D6obpMLoKTkWg+FHxBbotF7xzGoeokNZFBtSUHWDDAbUPthCVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6489
X-OriginatorOrg: intel.com

On 2024/11/6 18:45, Baolu Lu wrote:
> On 2024/11/6 17:14, Yi Liu wrote:
>> On 2024/11/6 16:41, Baolu Lu wrote:
>>> On 2024/11/6 16:17, Tian, Kevin wrote:
>>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>>> Sent: Monday, November 4, 2024 9:19 PM
>>>>>
>>>>> +
>>>>> +    dev_pasid = domain_add_dev_pasid(domain, dev, pasid);
>>>>> +    if (IS_ERR(dev_pasid))
>>>>> +        return PTR_ERR(dev_pasid);
>>>>> +
>>>>> +    ret = domain_setup_nested(iommu, dmar_domain, dev, pasid, old);
>>>>> +    if (ret)
>>>>> +        goto out_remove_dev_pasid;
>>>>> +
>>>>> +    domain_remove_dev_pasid(old, dev, pasid);
>>>>> +
>>>>
>>>> forgot one thing. Why not required to create a debugfs entry for
>>>> nested dev_pasid?
>>>
>>> This debugfs node is only created for paging domain.
>>
>> I think Kevin got one point. The debugfs is added when paging domain
>> is attached. How about the paging domains that is only used as nested
>> parent domain. We seem to lack a debugfs node for such paging domains.
> 
> Are you talking about the nested parent domain? It's also a paging
> domain, hence a debugfs node will be created.

yes, nested parent domains. But as I mentioned, the debugfs node is created
only in the attach point so far. While the nested attach does not attach
the nested parent, it is subjected to the paging_domain_compatible()
check and contributes its pgd to act as SS page table in the pasid entry.
So it's missed though it should be in another patch to add it.

-- 
Regards,
Yi Liu

