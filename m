Return-Path: <kvm+bounces-29351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44BD69A9E95
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 11:34:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0048E283744
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 09:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D341990C7;
	Tue, 22 Oct 2024 09:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kFDz3ttd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AF11990AE
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 09:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729589650; cv=fail; b=E9CdhXhlu1aEK3b69PI0CpfjxYMoC4W86dKntCrRmhHDDDhp/BgcuKLP4Rwtfm6BX0jqM73TqGqtGw6mC88adI0pS3dI+gsVdhNrfJL20S813kisrDZHQLrqzJqY4Nhga0OHWR6eZf+50iFDq3zzkGoPgEev73HOyqP5zgco1WI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729589650; c=relaxed/simple;
	bh=NV+tFX4nSp25WInQp7CM/zuQup+++nr9KPcuJ3b7VlM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZrUBXtfMHb+TMqDq5XpfTxHEJGGqtDVqHop5lvTDmDmRo9t0GwMAm1CMurvqwmAFWqLQPBPLJ38jNRvPncmOo8hYjOaO0xVs+bMH1cALPDchLIMWSrNU0NumiAe2x1tdM6I8bKOYaay5piA4I1XwqNwoiLq0pMqHfsrV7wdfhiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kFDz3ttd; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729589649; x=1761125649;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NV+tFX4nSp25WInQp7CM/zuQup+++nr9KPcuJ3b7VlM=;
  b=kFDz3ttdNuctA9c2x+wOXzY3juMG6tfvAgCcvHNdpQFlwtcbD8icu+1V
   FE+Dw7fYHNgaTpvAc5wGnF4RaZw84SFPBx7XUNLkahpczjmo+TjltoGrm
   4SeR+1eh8BmxjktLRLvjob0nmW5diEp436RjjiO4H+IxDHZ9PFlNJobqX
   o05ujCRiy1b04vnWHps9nYiWQMw5xUYIlT/g30/EFUwJUhlgWCEQ4FUIg
   zl1rVXytScsAcv33CeJl8KqMQ67NnqIZCUcbJsBPDjK3kPYh0vbBmGCxy
   1rNVvMjZ+G9YdIPA7+2hrCEPZcxa8iV1M4gfTl/BSt5OGfQqIA3fj1sOL
   w==;
X-CSE-ConnectionGUID: lUvBx7Z7THaYlXj43EzhbQ==
X-CSE-MsgGUID: OmEMGXo0Qb6y9lQoi9Gbrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11232"; a="16738993"
X-IronPort-AV: E=Sophos;i="6.11,222,1725346800"; 
   d="scan'208";a="16738993"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 02:34:08 -0700
X-CSE-ConnectionGUID: un8f/glYSpaH1vXWQ4H1Yw==
X-CSE-MsgGUID: lsE2893YR3GKR6ivgq+SCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,222,1725346800"; 
   d="scan'208";a="79742195"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Oct 2024 02:34:07 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 22 Oct 2024 02:34:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 22 Oct 2024 02:34:05 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 22 Oct 2024 02:34:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r7RA+xe0HdkEv7j7MY2XrdOeZUxpjzWBth49ZZHgIn1qY1kPvDYnPoeqCqlX2Ysb3EYKQKqeyIfnZO9sc10VzIoQpcesZFmNBzeD2+7NzM0nNU2T4VfoBnnRUlYxxLgfxGPk5OOtEuUqDh3ZAc5Ak4udIt3OqymOLuMhWdOffOWRoWO3Us6ow34+IokX3x3suxKfOkIO+4at3j6GHJmfAE3Kty5fZYFEDpHo5l0BBFrpS8z/bkbDhTfI6IoLYeFgCYpBEocyt11/HrhFT6JmelTJpO42c7d/tzmNoJIhX4yfRWlLNjgzNv9rYuNxUerY1lXJS9LydzsTCt7PUjx0aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gx0KxBK2O0hEVPmAjgx5GpE3RLa/ikyfj6h6lvg1bOU=;
 b=EmRGYSn2VYzmdzUe3FfqmB7ysjVd/gZ7A8zpdSOSKqdb2DIJMffNAKWwFNjTwrvxRfHdV4D/oB4r0rLX38+aWLRfKOn9FnHgC5ctBqaCvWYv6LEJTjX5BO0dqEkU9xgGG2qJcdD/GkSDoloMBBDjPjbyB56GcezikhPhWadmq8Q5CYQVfrWWZofogtag39Gil0s7g2ijlsmh8b0JxadbAyWBNWGVuiljPs2FLSZEmFA3hGiy1zffY3u0qMq62/y+WIJJ2bDsbFVR4t/SzZrlLXwZQ34E6LP6NgSxajAQmtYM4Ca4siWdts4+P/m/iAOSE0P6XOfarrFtPlT07zFGTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW3PR11MB4618.namprd11.prod.outlook.com (2603:10b6:303:5f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Tue, 22 Oct
 2024 09:34:02 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 09:34:02 +0000
Message-ID: <fe88f071-0d06-4838-9ce6-a5bcccf10163@intel.com>
Date: Tue, 22 Oct 2024 17:38:38 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] iommu/vt-d: Let intel_pasid_tear_down_entry()
 return pasid entry
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>, <will@kernel.org>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-4-yi.l.liu@intel.com>
 <e5cd1de4-37f7-4d55-aa28-f37d49d46ac6@linux.intel.com>
 <521b4f3e-1979-46f5-bfad-87951db2b6ed@intel.com>
 <ce78d006-53d8-4194-ae9d-249ab38c1d6d@linux.intel.com>
 <bab356e9-de34-41bb-9942-de639ee7d3de@intel.com>
 <9d726285-730a-400d-8d45-f494b2c62205@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <9d726285-730a-400d-8d45-f494b2c62205@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0017.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::10) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MW3PR11MB4618:EE_
X-MS-Office365-Filtering-Correlation-Id: d5020664-d8dc-4968-aad1-08dcf27ca9d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SEVWYkhSYmhxaVkzMlpuZHFPYkM5VEZpamJ1THcwRzFpZC80Y09LZUplVU1h?=
 =?utf-8?B?RGdJT0dFeVRSL1BEektJamMyYkJ2RWdEa1k1L0xoZUwxRWtrd2dNdXpHSDNO?=
 =?utf-8?B?QkowWU1RZHZWeE0wSUI5VW5zUUZiN1RzZ051S1IzR1FXVkgxbWlZMnFvZ3Ez?=
 =?utf-8?B?K2JDRDYrS0VQQlFrMEQvZEszZzE5Vnl4NlNFaHpsbVhLRG1jY1dYZUlSNUhE?=
 =?utf-8?B?bHNPcWRndFRRbXlaMjRZU0JzY3NMd3puVmI4Ly9aem9RUUdLL0lNdXNtS2xi?=
 =?utf-8?B?RGhCOW9Kdjlyc3pFRnJLWFhKUFdRbEozQUJ3TmdRZVg0TnVlaTVPMUh3aVJp?=
 =?utf-8?B?N0F5UjJoeFBQa0NROGtIaENTOHJJcitXZVYwL3BjUThUb2NSalpMb1hGYkp5?=
 =?utf-8?B?RzBDNTlXS3Z0VktNcUpXQXQ2RitJUFBUdEJzZS9YUXRmcmhjN3ZGREVtOXM0?=
 =?utf-8?B?am9RY1RCRCtyR0VObWpqNkhQK2xxWGpvWStVeVpndFMvOUIyNWc1ZFRRSEVD?=
 =?utf-8?B?M1MyUHFRdUtZWkZtYkZDbVFQVHlCeDRldnN6UW8zSmZHNmxJbDZHc2t3c1hk?=
 =?utf-8?B?N2crcnNJTDR5VUZNYWkrTjZEYzBDYTJDSXd2TnBlcmN5ODlJamgyclgrNGFw?=
 =?utf-8?B?WUVBNGZ2bmFRZkJLODB2MDhtQWd2cXhsbW80Y3J1MnhSWjVSMmo2dmdmNzhp?=
 =?utf-8?B?SnhGMXZUMFlPMjlUOUhXRkdLOG1pZ3R0eU84TDdFQWFSeWptSFVpclZDMlQ5?=
 =?utf-8?B?NFkySk1JdFN1WTVRR1dpZVpzazZOcllreVI0ZkRpa3JaRGU3NGNZWlp0TWZs?=
 =?utf-8?B?aDJscExodnhoRUd0Q0xMdlZweXU2OVgyVWRaa3c1QVJYblZZKy8zdjJXdkl4?=
 =?utf-8?B?VW9ZUnVXeE13eDI3a2M4Y2QrNWNzb3FnNi9MSzdCOXdaK3E5d1I1QnRNNys3?=
 =?utf-8?B?ZnhGVXdhbnEwZ01Tem02QmN5M2docGlmWVRQK2pQOWhkMi9WeDJ6WTVMWk1V?=
 =?utf-8?B?SXlpOXpySnFjZ3ZKOS8wdmJkQTJMb0Z6TXJsT09BZnpONDVNTlBFNjVyY2ZY?=
 =?utf-8?B?VktUZkJmRG1OeTY4dkgrWmpEUHI3SloxZ1BURFZkaTB1bDZHelZveUxyWnhm?=
 =?utf-8?B?dVlZZUJReG1PdGMyZzZQUkppWjRNd2xMalRhTzRHYWdJVzJSNGlZamc5ZDFo?=
 =?utf-8?B?UE95cE54Ym0xL3lmWGtiYTVFdDY0VWkyY284QU96c2VCVUN3SlpGYjVCc1lj?=
 =?utf-8?B?bm1qbE1ZYllsYW93OTNvck12aklBZnh1clBOeDJFeFRoOVJvMFhVYXVHOG1W?=
 =?utf-8?B?SG1wZytvRXEyZEpsMzJXQkxicEMxTU1TNEdkYUpvTjdkUVR4RjJDVXF5VmZF?=
 =?utf-8?B?bW52bVJHbExBbWUxalh4eXVUVE94RjJFQ1hXckVVeDQySFh1V24zNEJXTEE0?=
 =?utf-8?B?S0VDUDVLMGt5WWdSbWcyNkgrNGlsQ3ZMeDIyWWFoQUxoa3RDTTg5bVhvWFg3?=
 =?utf-8?B?eTJTN0U0bGlQRTdwNitVRk84aDhyMFRHL3NaZzcxc3dON3pVcldTbkliK2ZW?=
 =?utf-8?B?dUNTR05yLzFiY1FmRzk1akFnL28wMEI3RjBkOTd3UTdOcTBsRmlpU3hBdUVn?=
 =?utf-8?B?T2lIcnFtZEhwdDFqaGkyRTgrMDRzMzBYdit2MVo3a3lMaEFCWUh4NUtMRW80?=
 =?utf-8?B?Yzk4cXJIcGtLZUpGaXRjUTM0YnM5dzFSV1Nld2wzMGprUjk2ekFmQmFJaExS?=
 =?utf-8?Q?2pS9Hb48/rlS6b5JFs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzIwSTdGWG1BVXB0eFJZQVpRT2FDd3NDejQ3SmJVMXd1aFg1dWg2WUF5ZWdw?=
 =?utf-8?B?RERRVWZRTXhWaVZMSWhPTTIzNjRVdnZtb0VpZW1MRUdiQzFMajZwczNUMlJM?=
 =?utf-8?B?RVBPZFg2a2lUaktlWGFJUzhMUCsyY2o4dGpWeUxmOG53ekgyc1A2M2J4MTNN?=
 =?utf-8?B?UWw3eFB5MzIxd1NnSDZYSG5ENXF5WXBtSEhnTnlNajJ4a2tRWG9KZTg1d1ZP?=
 =?utf-8?B?UzBuYVRoUk4zd0praUM4KzNlc1ZyeUZGZktrT2psOHdFVE55NjVxZmJaMGJz?=
 =?utf-8?B?M2NEbXZFcU9GdE9QaEQvT2ZvNE9oZWd2QllXY2xoRENVcVRiYklvcFpSVWZy?=
 =?utf-8?B?OFV6NzlQWkFxUlRwSFZieUMvQVRtNStFcjl4RGxpNG9xNDJqbVk3dTNnczEy?=
 =?utf-8?B?WHlYNWM0eTNWUWUyK2plZmF0UDMrbmYrZzdXWFpqdTBMS0tRM0VWaGU0SWVL?=
 =?utf-8?B?SitlQU5TN3I2U1J5ZHFlUjlOK3BwS3dwbVVsZmpoRjIxaUp0OXZIQ0trOW4z?=
 =?utf-8?B?VUZKN2hudTh3cEErQ0p4dVIxWDZwaldMbE14MmFjQmFOcVVQRm9BdktiVkNG?=
 =?utf-8?B?ZVNma0JMNVc2OW9rTEtlWS9xQS9EclVDR3hHdVBDM1RDcEJjRGJpUFBzZFcy?=
 =?utf-8?B?UmtwaGRUYTMrUm5pLy8yQjMyMXE3TjdDSTUxU1lLTXQyWUxaNHRlY3NHSE0v?=
 =?utf-8?B?R0lYRDVFVTJMYWV3M2hzVm5pN2NZUW5qVHI5dEhGZDlVK3FDMWRHN2kwckxu?=
 =?utf-8?B?WE0xVlphRURCWi9aZTY1VVBXMEoweitacHlSaE5iZnR3MWtJNmxMWExFSTRG?=
 =?utf-8?B?SmljaGplaUVEcWdRcG9uV0ZERms4YXFhRXRKQVdmOExUL2RDNC9jcWRjMGhE?=
 =?utf-8?B?ckNaMHFRV3ZYZU1zNFVRZXRraXk1NmI2SWJQTmVyU3ovL1I3L3lvdGJjc3Aw?=
 =?utf-8?B?L0o4NnZVeWNUK3pScG11RDlobzVueWQ0SUpTV0pjZ3F2T2NNTXEzVVIvckdw?=
 =?utf-8?B?NDdUU1BYeC9jaDVIZGc2RGg5RCttZFE5Rkdma2dkYmpTTHdjRS9NVGd4QjRY?=
 =?utf-8?B?Uy8wdU9BOTQydUtRbUFDNGU3eHpjS3I3U2JON0FnSW1xOG9Kc3VGVDk5c2NO?=
 =?utf-8?B?V2p1TmtEaFVrMWYzMi9nR1A5dFRxemNDRzRiK3g0UVh4M0pYUkNQU013SC85?=
 =?utf-8?B?TklTOWl4aVd6TFEwVUttbGo5aWF2elIrL3FDRVdrUHdRbnZnb3V3UGFpUjJV?=
 =?utf-8?B?UnBWNXBrbGhXSTY3NEpaQXZuMXlyM29xNCtNdjVHbURyTmF4WDg1WlJmVTN4?=
 =?utf-8?B?LzdtTWxpSVY1RVdTSVllRWIzZG5jbnJrd1JkWlZZRTd0VEQvbmlqNzE3TnIx?=
 =?utf-8?B?NVZkblJiR1NMUmVKV1A5ZmZPZFZVTFhxd3BaS1ZtTE5Zek5QQnptdUR3Y0J1?=
 =?utf-8?B?b1FJVXJyVFZDcXNiVGM0ZmF5cFVZaWVzU2I4RjJBODBLcHdjbmlTVkloWTdT?=
 =?utf-8?B?S3JENXlXT1hSdjRvTFJ4QUg2OUdJQ1BOeGJkN29aZDlFT1N4RzNlMjNrWktQ?=
 =?utf-8?B?NXFWelRWRnhPOHd0WnRjc0dwSE9Eb2VKRTNFdlhraURLTnNQZnZuK0toYSt6?=
 =?utf-8?B?Z2h5bmp2a0FES3kvQWlacTU1ZTdaeGtKK2R1bzlKTTNFcjF4MndYY0Z3ZkNp?=
 =?utf-8?B?Z2Fha2IrT2lIeTFGeWhIM0VMY2syY1REWHpudndQRnIyVHBZZlpubGkvY2pu?=
 =?utf-8?B?anZRU1VFNk1oUllIU3JLV0VPSTRmZkRYazNlbTFkUEtScVNiYmZWNlhkU3RG?=
 =?utf-8?B?eG5PM256RlJ4Yzl5UzBtZlh6cE9EYlhnb2xUcEltdXpzSjN6aEltaEwvRXF2?=
 =?utf-8?B?OHdTL2RRRUJHZ0lyZlNxR3dxdnBRaVIwWTZCK1lzVkw4KzhCeGFTMzFvYVF0?=
 =?utf-8?B?VTVDb3ZTTTZtVUo0c3c3Mm1mNUEvbFFLK2NYdnNsZU5FVVJjQzZQd0ZMTGVo?=
 =?utf-8?B?R0ZndVBrakxXbnFnZGVCQVl4b1V5eTkyQ0ZWWmw5WmsyU3daKzAyT3JYcHlh?=
 =?utf-8?B?SVZzamVMWUF6d256bDZBQWZ5MVNtckVLMC83QUZLSjd5Nm5nbDB3c2JZQ2J4?=
 =?utf-8?Q?uK1TZUSoO7dEKaCRSX5hXT1PU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5020664-d8dc-4968-aad1-08dcf27ca9d6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 09:34:02.0177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JMEEfPsH2jePg1m4MSKGrHMPQHGmaLbiYV8JtzjqDaB8XjLXqrzjktn18V8vzVC1/OReEnp8oYWKazTQBZaSGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4618
X-OriginatorOrg: intel.com

On 2024/10/22 17:23, Baolu Lu wrote:
> On 2024/10/21 15:24, Yi Liu wrote:
>> On 2024/10/21 14:59, Baolu Lu wrote:
>>> On 2024/10/21 14:35, Yi Liu wrote:
>>>> On 2024/10/21 14:13, Baolu Lu wrote:
>>>>> On 2024/10/18 13:53, Yi Liu wrote:
>>>>>> intel_pasid_tear_down_entry() finds the pasid entry and tears it down.
>>>>>> There are paths that need to get the pasid entry, tear it down and
>>>>>> re-configure it. Letting intel_pasid_tear_down_entry() return the pasid
>>>>>> entry can avoid duplicate codes to get the pasid entry. No functional
>>>>>> change is intended.
>>>>>>
>>>>>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>>>>>> ---
>>>>>>   drivers/iommu/intel/pasid.c | 11 ++++++++---
>>>>>>   drivers/iommu/intel/pasid.h |  5 +++--
>>>>>>   2 files changed, 11 insertions(+), 5 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>>>>>> index 2898e7af2cf4..336f9425214c 100644
>>>>>> --- a/drivers/iommu/intel/pasid.c
>>>>>> +++ b/drivers/iommu/intel/pasid.c
>>>>>> @@ -239,9 +239,12 @@ devtlb_invalidation_with_pasid(struct 
>>>>>> intel_iommu *iommu,
>>>>>>   /*
>>>>>>    * Caller can request to drain PRQ in this helper if it hasn't done 
>>>>>> so,
>>>>>>    * e.g. in a path which doesn't follow remove_dev_pasid().
>>>>>> + * Return the pasid entry pointer if the entry is found or NULL if no
>>>>>> + * entry found.
>>>>>>    */
>>>>>> -void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct 
>>>>>> device *dev,
>>>>>> -                 u32 pasid, u32 flags)
>>>>>> +struct pasid_entry *
>>>>>> +intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device 
>>>>>> *dev,
>>>>>> +                u32 pasid, u32 flags)
>>>>>>   {
>>>>>>       struct pasid_entry *pte;
>>>>>>       u16 did, pgtt;
>>>>>> @@ -250,7 +253,7 @@ void intel_pasid_tear_down_entry(struct 
>>>>>> intel_iommu *iommu, struct device *dev,
>>>>>>       pte = intel_pasid_get_entry(dev, pasid);
>>>>>>       if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
>>>>>>           spin_unlock(&iommu->lock);
>>>>>> -        return;
>>>>>> +        goto out;
>>>>>
>>>>> The pasid table entry is protected by iommu->lock. It's  not reasonable
>>>>> to return the pte pointer which is beyond the lock protected range.
>>>>
>>>> Per my understanding, the iommu->lock protects the content of the entry,
>>>> so the modifications to the entry need to hold it. While, it looks not
>>>> necessary to protect the pasid entry pointer itself. The pasid table 
>>>> should
>>>> exist during device probe and release. is it?
>>>
>>> The pattern of the code that modifies a pasid table entry is,
>>>
>>>      spin_lock(&iommu->lock);
>>>      pte = intel_pasid_get_entry(dev, pasid);
>>>      ... modify the pasid table entry ...
>>>      spin_unlock(&iommu->lock);
>>>
>>> Returning the pte pointer to the caller introduces a potential race
>>> condition. If the caller subsequently modifies the pte without re-
>>> acquiring the spin lock, there's a risk of data corruption or
>>> inconsistencies.
>>
>> it appears that we are on the same page about if pte pointer needs to be
>> protected or not. And I agree the modifications to the pte should be
>> protected by iommu->lock. If so, will documenting that the caller must hold
>> iommu->lock if is tries to modify the content of pte work? Also, it might
>> be helpful to add lockdep to make sure all the modifications of pte entry
>> are under protection.
> 
> People will soon forget about this lock and may modify the returned pte
> pointer without locking, introducing a race condition silently.
> 
>> Or any suggestion from you given a path that needs to get pte first, check
>> if it exists and then call intel_pasid_tear_down_entry(). For example the
>> intel_pasid_setup_first_level() [1], in my series, I need to call the
>> unlock iommu->lock and call intel_pasid_tear_down_entry() and then lock
>> iommu->lock and do more modifications on the pasid entry. It would invoke
>> the intel_pasid_get_entry() twice if no change to
>> intel_pasid_tear_down_entry().
> 
> There is no need to check the present of a pte entry before calling into
> intel_pasid_tear_down_entry(). The helper will return directly if the
> pte is not present:
> 
>          spin_lock(&iommu->lock);
>          pte = intel_pasid_get_entry(dev, pasid);
>          if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
>                  spin_unlock(&iommu->lock);
>                  return;
>          }
> 
> Does it work for you?

This is not I'm talking about. My intention is to avoid duplicated
intel_pasid_get_entry() call when calling intel_pasid_tear_down_entry() in
intel_pasid_setup_first_level(). Both the two functions call the
intel_pasid_get_entry() to get pte pointer. So I think it might be good to
save one of them.

-- 
Regards,
Yi Liu

