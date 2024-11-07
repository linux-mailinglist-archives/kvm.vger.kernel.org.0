Return-Path: <kvm+bounces-31056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91CFE9BFD22
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 05:01:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 916201F22CA6
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 04:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B641822E5;
	Thu,  7 Nov 2024 04:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RRdjPj2s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C842E18052
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 04:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730952061; cv=fail; b=TmWkQ8ixaNKM2eaIMDjY2MVVjv69eCaBnrgxRv/OqEodrD+VWAxhNmEPPposb3Rv1l29u3AK/jxADW31Av6XNYNg8Qwlt7KI3p9EbP3Kfd+38ybJDrBSgFExz9QOEhhDeT7HQunT0f7RC+GJoVccSj9kQMJni+IhqutTAzI2kN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730952061; c=relaxed/simple;
	bh=DJYT5wczY1LHl3fQhyYJ5qghZCEuvifFZIxwWA6XkAU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PiAkv779tt1pHZT6gSNflFnVEhFIEKPS7LY+2v7g65z48rcIxqm2yQn81Ft/j36/Sl6FGA+IfshXvC9lRFhmJS+jGfCRQMdRbZVOfP7U6BjIpmSAd+ZPzk6pY6y+dnBcCY80Mrpo0gmfPnYcA8oUZhjutQqyhKC6qZ03GmJRXIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RRdjPj2s; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730952060; x=1762488060;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DJYT5wczY1LHl3fQhyYJ5qghZCEuvifFZIxwWA6XkAU=;
  b=RRdjPj2s5ksluvMptHjtIANJ9EA+XGpWtH/iRGRNKA1zW0AfjP+J/GLH
   F0zDrgv6ld3x2cN9/rE/ULqojWt5/rXLBWwB+UwBymhY3QB/0GlRqkGRU
   MsOZthFnPJtZKMftY73Kzx3cAqoyL36xFPlK2G8zP+GFk2+XRUgrq5j4h
   HrAgFPBi4V9anf3OxTAEtVlvIoUxphN+e93MZGwt2YyAn22lisXY3kX1Y
   9O1jfOPPOVvOXzbksLNdU/9ZnRoyQSsgeZnvg6AiOSB1guVlhKbRy3oYu
   8PnrylZta2vPwoWldFGT2JhJHPNF2EMz2b3WVnESBuLZqAu4S9IfH/BVf
   g==;
X-CSE-ConnectionGUID: 8LAl+uebQTSkGXHiv0QOdw==
X-CSE-MsgGUID: TDo6kU9pTUeq4bRXi3UJug==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="41375276"
X-IronPort-AV: E=Sophos;i="6.11,264,1725346800"; 
   d="scan'208";a="41375276"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 20:00:59 -0800
X-CSE-ConnectionGUID: YoB7PUOmQAeawr4NV1YXkA==
X-CSE-MsgGUID: 7G5FN//2RRu5zc9EAwEfBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,264,1725346800"; 
   d="scan'208";a="115730158"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 20:00:59 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 20:00:58 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 20:00:58 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 20:00:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hW81SjCqudOlKMut5tW+WjXL+1xs6kuV+Tw5SpdOKOVVbbN6vEzCMGSje2KWLv4P+Jbyc8kqr5J15o6cmwFZaw0bohfJcWymsYAIonIvokcXN+bhJBXSZ3RzCfGOsIuRN0j9Bz6juTfva34mpz3HtMmib3d2O1zdUwUR6YC9BVNIqeJanFt4ypen7ty7GbPjynkT86YQ2GnrETb1zi9RMgkXXWq2ufxxCqhUFSRP6Z6w040lLfrrW2JdZnoEQDvmto4XtTGzwiciT6JZdahP8cXWveQSgMpf6Z4E94MPDdyBiUMf9BP9cBaaFL1dpACCMNZKnWlJQUf3GT7yA+vOMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXeumcgePXw/JQ4qTSZXqkRwbkkbxQ5b5Chm+UlAcwM=;
 b=l438zUxWsg6rR/72yd4TElFzycuhFDKjgsLep/BrgxyhMkJ4c+OUMGAwvaYZVVVtj5kwoK65MFyJkTEHyiEeecuy8XShpzzfUkspZl2qU/fSz+1+V+OC35RZsRzKt2jjD5+Ju+LGkz6FZCd565bRVfFADAWY/PAr9rA2ZoqPGcslV4H9FxwxtOPozyv9nmW73YLyscYiw0DDSLjhvXwVz9ppEN75yuqxn0Oo264uZLpMsbL3vj9sjZ1zy4E+JqECBKJiEGJzdNrkCD7PTEEI06Jmt1kpC16fAQxrW3sDNGdsle0n/BzyDP0BQkgZDveBBaCBSBC5TsjWEW8y1iwaoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB5163.namprd11.prod.outlook.com (2603:10b6:806:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 04:00:55 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 04:00:55 +0000
Message-ID: <607c6de4-2285-420a-8800-0fa747073b77@intel.com>
Date: Thu, 7 Nov 2024 12:05:29 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/13] iommu/vt-d: Add pasid replace helpers
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>,
	<willy@infradead.org>
References: <20241106154606.9564-1-yi.l.liu@intel.com>
 <20241106154606.9564-5-yi.l.liu@intel.com>
 <0ab4e27c-0ebc-4062-bf5a-121e4e95a16a@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <0ab4e27c-0ebc-4062-bf5a-121e4e95a16a@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0172.apcprd04.prod.outlook.com (2603:1096:4::34)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA2PR11MB5163:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b5d640b-b801-44ec-fa40-08dcfee0c780
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bVRmVHVVbGZxQ3NkRWdGRWhZbnY2ZytuVEE3K3NOUm8xS1ZFYWlSVG5kQTVj?=
 =?utf-8?B?VDdvZjBpTVk2MlUvQmRPdVI0N1plTXEydFlQRzRaUDFjcURQaDNvazE2bGZ4?=
 =?utf-8?B?Y3RpVVpiZTcvMlJPVGgrWFZKRVU0MEVYd3VJVE5sSFFrVUkyN1pKdkdYbFpL?=
 =?utf-8?B?cVFLRFJEdjdsRzErMGN3SlhlTVEwNzhTTDVoY3N0UWZyWmRocWhJemk0d0FE?=
 =?utf-8?B?VVJTL3RHSnE0RzVGWUdHWmFFQytJVytUalNPYVg4ZDlKZUhxck52Nk5iV3R2?=
 =?utf-8?B?NWc0TnpONVFiYjZHWjYybzlSTTAvcFBGbUJLQmlMYkVxQlNzQS90WkhDdVZ4?=
 =?utf-8?B?bjh3RkhBeWo2akxXdVlBeHROSWpyeXAxRVpSazloMWh6clRpK2Y1TEtuZnJ1?=
 =?utf-8?B?M0tWVmc2VDNGMEZmQmY0YzVOeWR2K2Z3bEkvcDlpRWpydFpsbDZJOENOWVIv?=
 =?utf-8?B?bTlSK2RWUGtDd09WVkN6NWxuUktYd2dVdGVYYkh4clVVa09TQjVqMjQxaGxV?=
 =?utf-8?B?WmxGa3BFdzY4NXU3WDdqS1ROeU1uZE5UZ0hvK1dDYlBjbzR1MUROQ3hHOFQ2?=
 =?utf-8?B?K3Z3OXJ0WVo4RHZqcGZ1N3hCY1VBUHkvTGwyTUdvNnQ1Y3ErMDluTFh5UFNT?=
 =?utf-8?B?d1lRemVqcU9McC9xMzZ0RVhzN3FVRjUxUkJ1SUE3c2N0SmlXVDRjV0gySldr?=
 =?utf-8?B?aWZZQlVYNHFqTkdNNHRMKzFWSkt0YWk1R25nSE1PRzFUYzVBR3NIc01QdUpS?=
 =?utf-8?B?RTBvaG15S2ZuL1AzT3pQWE9ncFZvbXB6bzhKS1ZoOE9xTkZhamRCTFZlbXoy?=
 =?utf-8?B?emZuMXRTWjAwZHBNZkwrYmo2bU1oaG8yclpQVVd3OXo4ck1ZUDBhZlZtQmJq?=
 =?utf-8?B?VXpyTCtqc3dCcFB2ekltcFBuelJVdlExMUEraFl5dVJ2T2U5MmxmYW0zS1BM?=
 =?utf-8?B?eGpQMlVyZ0o0bXJOVzhua25zd1RWbHM0YjUxQmxMUHl5dU1nOGlTZGlRU0Vu?=
 =?utf-8?B?bzdLb2FzYVpSY1JkbllzM2t0Y3hBcEZQMHFsMGF2WDNEODFma010Z29FalZ6?=
 =?utf-8?B?aW1ENnEvQytzckZkZUVwdFZNS2lvRUp5SlA2cHNyU0M1L2UwWUQyQko0WGFO?=
 =?utf-8?B?T2VnQ1BBMytrZkdBQ1ZtTEdYSFpLOW9peEt5bzg0aTJlc1NDemR6Y2dDeXU5?=
 =?utf-8?B?c3NMOWlBUzdva2czQ3cvTUhpYUJIRWI5OTlUK3VlMUxXV0c1VGYrcTVIdUQ2?=
 =?utf-8?B?NlRVbnQ1NGVyb2lDSWE0SmZvK3h3bHRMUlVEQ1F1OXFuNFdiKzFFYUNjY0JI?=
 =?utf-8?B?QVd0NjZuK0dPVmV6cVljSGhCZGlxRUhSVEREMDMrb1lHYld6YndPVFhZYWVX?=
 =?utf-8?B?YUxTemVyci9wVjJYVzdxaEVHbEYyL24xclByck0xUE1xUkYyMGNEbUhtM2lC?=
 =?utf-8?B?SW1rdkxXNm1hVmcydk0xaXdjaFRLdkVTalZTL2VXa1A1OENOVU44eTlpWHlx?=
 =?utf-8?B?U25xc1RtdUVhUXp2RndpSThOZCtnc1A1Tk41ODhZcnlmLzNiYVVTMkl1UHNr?=
 =?utf-8?B?MlBUV1YrMXBCU3lPYlBhV2I5VlhtbUNtQ2s5YmUyZVNpZXBrWWhPaFZUQ2RP?=
 =?utf-8?B?UGhVVFFGVm5EWFFGT0ZlblNoOUR3dFFGN0RtTDFPV3F2dHo3TXlzUWIraGdL?=
 =?utf-8?B?MWpOQmE1TWxJaEY1bGcvVFN0Mng3U1ZHZTJ6RVV0YlhtUUU3QkJCT2dJMUFR?=
 =?utf-8?Q?1sTrOnfmd4H4EbUHesteMDwPPPXfNjT5LSb4And?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGliaW10T05kU2J2cVMzVmNVVVJ1aVRpVitOU0EwODhIL2t3QzNSanRxTnlO?=
 =?utf-8?B?RDNEZDFGTHhRKzhOQmxiK2thNW01czBKc0doNVhPRDlxMVlMK2dpUE1JR2Q5?=
 =?utf-8?B?TVJNaWxDeFpVbVFmUEtaOUlxS0x6eWVva2RzSTdZMWlVVGthaW5lUWZDNmtC?=
 =?utf-8?B?S2hjVTNpZk5QWlBaTnB2L3I4SnlxVExoZVlKWSswdlA3US95Z0FTZ1FBVHJ4?=
 =?utf-8?B?R0NvS3JYb1dKSkdaeHRtcWkzaU82TXBwNmg2Z2pLb3ZOVDZZSDVHZ1BzVS9V?=
 =?utf-8?B?Yno2UDBESFcxQVBHRDR6SVB1SHdleUV4ZlVRZ0JaRE9KNWdFK1RDSVpFc25r?=
 =?utf-8?B?d0k0bkM2Z3NadnQ2cEVVQlVXRnlKbTFZK2ZuV1J4R1hsdkpLcFVVaDJnTWN6?=
 =?utf-8?B?cmx1dU5Cam1kSVB6OEpTbStVckFjOHczQ0MrQnlHeS9tcWZlOHZFUUIzQ2d4?=
 =?utf-8?B?OEZMaXNrL1NQZWV2NWdYeVI3bXZoU1pOSzlRdE5PY1ZCdlhrNjVNa2p2d044?=
 =?utf-8?B?K0JZUEZtY3IxMkZmU2pjTFdGVCs3a2lZU2FzeDQ5ZDhmdjFISkpVVjNrYmdh?=
 =?utf-8?B?dmtJQUpnYWVYL2U0UGVCTHBsWmZWSWhJbnd0WTNpV2JyQi81b0NCQTNlbXIx?=
 =?utf-8?B?R1dkWGZUUGZQdE5FZ24rUm9pMU1XOWZjQTliQXFTdnI2L21DYlBpcUFZdmdE?=
 =?utf-8?B?dUZtMXFYVjAxVmZhZmFvcEFobGpZVnFwNU5iS3lLMGVUK1RoMi82V0tvNVJE?=
 =?utf-8?B?RlZWOFU3Z0lxMEpLc1FRbkdKemhBQWx2dm54WG01OXpJSVdBVzhiU1lDdHB3?=
 =?utf-8?B?VXA1a2dXUDVZZjJlbHk0dStqVzNtODhqbEt5NUkvdjRrTTh5c0tCY0RGcWk4?=
 =?utf-8?B?dE0xK2FzOHZSNERJalg3TVBvS3BnY1RCa2lvY2dNSkdSZDh3M1pLcEJKNTh3?=
 =?utf-8?B?MitIZEFlSiswd1FMVDFnTUFPN3pHVDJ1Tm95VkswTnRYSnFrems4My9Za2pv?=
 =?utf-8?B?SXFwVnIwVkUxeVRHdEZ2WE4vcER2UWpHQ1BMT1Z0M0xRYXpYdDFwM3RtaW1t?=
 =?utf-8?B?ZUNmTUF2QjR6L3ZGdmhFVHBWbW9lYTExSjNqL2tIS2xpZEdCMGE3THJVNWR5?=
 =?utf-8?B?OUFNOTArdFF0OWVYWTdhcC8zZ3ZmUC9YQSt3REZIenRuRjZkOHhwRjEyZm5D?=
 =?utf-8?B?NWp4YnpzSWUvcHRteUl2ODNWalJtU2NoZ25yVmRJZ0tDN3NGYmdvdGxpN2o0?=
 =?utf-8?B?OGYvNGxISURtMHR4UlUrdVVFRmxmazZ5SStQblZ1Y2NmeDVqQ0NkQjlmczRv?=
 =?utf-8?B?eVJyeTBGRVMzazEwSHUyY3ZNd2diWUlKaytyNnUzcGNUaVM2SWVzZDFTM0Fj?=
 =?utf-8?B?M2RRZGd5NFpyWE9aVW0vTGZxcitwbDRVeUIxSVA3YTBqdW1OOFRSTXAzeXZJ?=
 =?utf-8?B?OStIY0s3UGhtZ3pwMW9MWC93UDlEWDNxNG1WREtzVTdmR1UvMGJLQThzUXI1?=
 =?utf-8?B?b1BUeFN5dFdUT3p6VUFsN2JVM2dRNTNGc3ZhVXgvNCtvUTgzNFBEcHcrSkVy?=
 =?utf-8?B?Y3BDanUrbzdtRzRmRm9EdDh1ei9WMFRudklXT3REYXhCTHFzaS9IVWNqNkR0?=
 =?utf-8?B?Yk9ONkpQSXRDNDhJeWJvNU5DVlBKejBjSTdyakVwQXdyVkdaOFl2ZkdNOGtn?=
 =?utf-8?B?L0tXUEJxUEJVMWVkZi9kbnVMaTVYd01wclpFRE4xeTlNZ2VGUlBmVFNLNVFq?=
 =?utf-8?B?UFJUNVhkajNoUmNyc0pZdS9RTmo4VkxXTXlMbjJCK2VETVMvOHB2K1RYQjMx?=
 =?utf-8?B?NG9uSitTQTNGY01XR0xNNkFQQ1VjS3VlT1NrK3JaV3RUcXRLbkVCUWRvQUx1?=
 =?utf-8?B?cGlUT2FHN2dBSExIaENVbTJndzNkdDhlUXRncjlFS1d6ak1kVDhQaUliYmI5?=
 =?utf-8?B?VVgzdlM4RGoydndOdk5IZzlOaHlGK1lMU1FSVUpVWHZyRDZabHFFSlVha25E?=
 =?utf-8?B?VmVhZldWUjlZSkgwSFJQanExWWEwZG9VQTZPRSt0UUIvbnh3aDJoVktxZnEr?=
 =?utf-8?B?R1JOYjgrcDYvRjdFb0NEbFJFQ2tGUThXYkV4QVliUHpYUENXbkJoVXF4VWt1?=
 =?utf-8?Q?yE3Gnrh+5LryS3Hdc8PeHOfMx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b5d640b-b801-44ec-fa40-08dcfee0c780
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 04:00:55.6520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tDFUdVippvxa4/WYQ95q1rf/ZI9TwsMmW45QYwJMf2s9s1UfjXq/jtUyPkCi+l+mQdNRXWutkCHFMg6Eq5pbkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5163
X-OriginatorOrg: intel.com

On 2024/11/7 10:57, Baolu Lu wrote:
> On 11/6/24 23:45, Yi Liu wrote:
>> +int intel_pasid_replace_second_level(struct intel_iommu *iommu,
>> +                     struct dmar_domain *domain,
>> +                     struct device *dev, u16 old_did,
>> +                     u32 pasid)
>> +{
>> +    struct pasid_entry *pte;
>> +    struct dma_pte *pgd;
>> +    u64 pgd_val;
>> +    int agaw;
>> +    u16 did;
>> +
>> +    /*
>> +     * If hardware advertises no support for second level
>> +     * translation, return directly.
>> +     */
>> +    if (!ecap_slts(iommu->ecap)) {
>> +        pr_err("No second level translation support on %s\n",
>> +               iommu->name);
>> +        return -EINVAL;
>> +    }
>> +
>> +    pgd = domain->pgd;
>> +    pgd_val = virt_to_phys(pgd);
>> +    did = domain_id_iommu(domain, iommu);
>> +
>> +    spin_lock(&iommu->lock);
>> +    pte = intel_pasid_get_entry(dev, pasid);
>> +    if (!pte) {
>> +        spin_unlock(&iommu->lock);
>> +        return -ENODEV;
>> +    }
>> +
>> +    if (!pasid_pte_is_present(pte)) {
>> +        spin_unlock(&iommu->lock);
>> +        return -EINVAL;
>> +    }
>> +
>> +    WARN_ON(old_did != pasid_get_domain_id(pte));
>> +
>> +    pasid_pte_config_second_level(iommu, pte, pgd_val, agaw,
>> +                      did, domain->dirty_tracking);
>> +    spin_unlock(&iommu->lock);
>> +
>> +    intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
>> +    intel_iommu_drain_pasid_prq(dev, pasid);
>> +
>> +    return 0;
>> +}
> 
> 0day robot complains:
> 
>  >> drivers/iommu/intel/pasid.c:540:53: warning: variable 'agaw' is 
> uninitialized when used here [-Wuninitialized]
>       540 |         pasid_pte_config_second_level(iommu, pte, pgd_val, agaw,
>           |                                                            ^~~~
>     drivers/iommu/intel/pasid.c:509:10: note: initialize the variable 
> 'agaw' to silence this warning
>       509 |         int agaw;
>           |                 ^
>           |                  = 0
> 
> The right fix could be like this:
> 
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index 777e70b539b1..69f12b1b8a2b 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -506,7 +506,6 @@ int intel_pasid_replace_second_level(struct intel_iommu 
> *iommu,
>          struct pasid_entry *pte;
>          struct dma_pte *pgd;
>          u64 pgd_val;
> -       int agaw;
>          u16 did;
> 
>          /*
> @@ -537,7 +536,7 @@ int intel_pasid_replace_second_level(struct intel_iommu 
> *iommu,
> 
>          WARN_ON(old_did != pasid_get_domain_id(pte));
> 
> -       pasid_pte_config_second_level(iommu, pte, pgd_val, agaw,
> +       pasid_pte_config_second_level(iommu, pte, pgd_val, domain->agaw,
>                                        did, domain->dirty_tracking);
>          spin_unlock(&iommu->lock);
> 

yes. will fix it.

-- 
Regards,
Yi Liu

