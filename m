Return-Path: <kvm+bounces-20766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35FD191D968
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:50:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4CAE283914
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 811147D412;
	Mon,  1 Jul 2024 07:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DEpl/aSN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9698EC144;
	Mon,  1 Jul 2024 07:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719820230; cv=fail; b=CmJPt520+a/JSmiLDS462dCZA9VzKgRi6zXtz7QhowF6rDbi/WLABqV2LJdsIs03A1/0Zj1KcOKM/qOLKVfo28SFoEPz4Unx4e4+nErkmmgPtIQFVuSBPVM27drtMP8XhfZzDbznBIR4RdsEWtu2RnXe66TdJ9Ds/6F6rcki2ys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719820230; c=relaxed/simple;
	bh=z0sfT+yHGGy7FRqt3GuYdSITXjS9kmrn4BTgkCcZ8GQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s7mAittW957fyojR/A+wPSHqK88kZY9CVG89GIZa7bi1itqC6fK5oDNuQXSB3LaVsohx5CtLWkjz6BabHa7J6wtvuGtGHI8zUeY9FLRBZbgzxO3t6El88hBMnwWdnXxA5V6i5gybvh+tEEn+sPhHdioJGq45kz/zPO2afzDIXgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DEpl/aSN; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719820229; x=1751356229;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z0sfT+yHGGy7FRqt3GuYdSITXjS9kmrn4BTgkCcZ8GQ=;
  b=DEpl/aSNtDebPxXhJcpGEwmBQjcMkXoi/EqZHwBwL0Ag0r6cfp/9OuB3
   CkR4BnqV1ySWKE1WSTEtJ6XXp8GybNVAIOge/sR9NhdWUVqF9BOWOZ5qp
   yvgSS45wZbfgxCYkJ6lvufHB0mzxUy3v+wCbMFjL4OnPO2nP1QL86bcMn
   5ZdTYzng85Fq6M/f2snO9GZ/3henxmNsb5qP9TmQi9yVWovY95qJqHig4
   5z57XndSw9eZHwwEBTwy06KbEh7++aAXKLvH2OKsYfU47g9vX2xHpoJHx
   xLhUUWNog5BJ/I+BsS5b2dr/u6UYjUoVUVCKjmtlryBTwnST8F7c+VyEi
   Q==;
X-CSE-ConnectionGUID: gAFOGbfIQWa1o0MOpEDioA==
X-CSE-MsgGUID: HS9UMlLRQ5CFAdTPtMyQBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="17147155"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="17147155"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 00:50:27 -0700
X-CSE-ConnectionGUID: ko4ioir0RPuPLAMPZgLBIA==
X-CSE-MsgGUID: AiC8VfdEQ32Qaqqz3EyfLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="45320494"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Jul 2024 00:50:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 00:50:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 00:50:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 1 Jul 2024 00:50:26 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 1 Jul 2024 00:50:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hd3N+emJ7Zf7TCnNQmG7/gDL9ZHzKALiTWctsFsYDwu87XUHS5kcpkZ67AyHu8HwblWZe3wWY7/jyElH6NqMSY0Ft40f9uS/npVpoh83griydDW8tkY8v/5Xu55NAZEcZaF6z999HJKvKr9rT+2C8o6oGeqHgGOlvBoJEe58W4WoLhCyP6fU72AXFJxEZBNXcbmU/zrv55OgF/YwoS+QjUkvbBOjnTR9H0Mmu0gC3jjHt4ngYUTUG3XxWbxaLZZITt8cWopRhTJJwbULM/WfVGUH+zQi92JWqkRzn4MxpxqgcJ0Uual6P4+ZkIvnL2uht9ZxeiinXZffYkr6aHa1sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uu+PW+qM5pXif1pk//DI6HEvcOSacfRTVOjsdsv5xqA=;
 b=ZnOUrVuEonEPmwPrGnbx4XnLCcWs/TihhfgJJTZuGAVsnY4P6UUKTwEpDrSFaG4jravLzxoZHGFinxprk3DfYhVR30jUQsptEy5QtuHef0PWOA6YfHMWls0Wz+Wgw7SQenmzqpjSo6sOZCbGm7OxtwL9OzB2h8WSCB47BZQPNytRyVvQDT6uMUMCAFIgfNN6BKER9UYTZ5B6bjdqRJsuNyGGN5B0l+HMP6PNfs1Ixe2cf4HzDBZNbibcCBIM2o3lwzTUzDQSS/VA6ark928wbyAnadue++/qfeDQOHzJtwq2k5K1sS8IOj8gzhiZXNfuEdA6c33v3yohTy2geTwDHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7687.namprd11.prod.outlook.com (2603:10b6:930:74::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Mon, 1 Jul
 2024 07:50:24 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7719.022; Mon, 1 Jul 2024
 07:50:24 +0000
Message-ID: <edc71108-2e2e-455d-b109-4542a845cf6e@intel.com>
Date: Mon, 1 Jul 2024 15:54:19 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
To: Yan Zhao <yan.y.zhao@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<peterx@redhat.com>, <ajones@ventanamicro.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240617095332.30543-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::31)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY8PR11MB7687:EE_
X-MS-Office365-Filtering-Correlation-Id: f721255f-bd90-483f-5012-08dc99a276ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K3g3d1kyUHpLbE45Yk5kM3kwRVUrS0dmbVVVRUpvZVM0VXQvZ3ZnenFTZkRk?=
 =?utf-8?B?NGxMcHBZSkwzTmxGR0JMdDAyNnRpdDU2NWdYL3lWakp4eVFTaGRyM3Y5Z1Ro?=
 =?utf-8?B?MUdGSTdkNnpzdzNBbkk2aWQ1aCt2QzFrb01EWGcrS1FFWElET2xXMlhHVnhW?=
 =?utf-8?B?dlo0RG40RmFrbWdCbVBwaWV2dHB0eWh6T3BPelpQb05EWFVmSGxwTXhzckMv?=
 =?utf-8?B?aDlBd0xHZ04vaWQ0YWZ3a1dtR0x4c1IvTlFVeHpyR2N5cmVVc0c3ekZYc0la?=
 =?utf-8?B?TVR6d0ZGdnVqTWg4V1VxdGNnbzJxb1UwcVc4VEwzayticUVTZUdaZUFTLzJK?=
 =?utf-8?B?N216T1FKQm8wMGI3Nkx1TVp4SkRPeEJrMURKUklDMnFxdFNNREJnWE1uejB4?=
 =?utf-8?B?MHhlSG53VXczSXF1K0hOZG95NzJCR1pPRE1GbUNFMDJsOFVvSUE5eVpqWGlN?=
 =?utf-8?B?MEhnSU9Yam96djBJUm94SXUvMmxKWHlvclM0aWw5bVVQeWIraVc4V1VuLzRo?=
 =?utf-8?B?YjdNNkh1M2ZGLzlDemtLZnZGZ1N6MVprWml1Z3lQR0NNVllqQUpVRWtMSm9r?=
 =?utf-8?B?VlZQSkhsZlNJMzJhengwUjVpb0tEQWNVMEhBVFY2UzU3eFk2K1p0ZHY3TkRt?=
 =?utf-8?B?c3FmaEFkZEMvdkJYL3psaDZvTjFRQzZrcWJUcjlvSUFMTWRyRE43ZEF4Vzlp?=
 =?utf-8?B?amIyU3d1bzJ2Y2xWOWVzUGc1OURQV25JYTJ0UkZFK2htZ213YWJKN1VUQ0Q2?=
 =?utf-8?B?cmRadXkyZ05IUWpBNDZiR2k5ZkxDSTdSUGhUUmlUaEVYNzFjam1mYjQxTVNk?=
 =?utf-8?B?dUVxWStqellJWkdsV2lYWGlUbVhaamZKalgyYXlSVFhCT2REVVNNa3phVnlH?=
 =?utf-8?B?ZHhSY3JJRjE2cmM2UVlja2JJZlY4R2l4UTRWc0lYY2J1dlJBRzV0Z3VQZGFn?=
 =?utf-8?B?VnpnZFpEOHVvVERLRzhYb0dRcW15UXUyKzlOakhtMjRQRG5Cc1pTQkxOSjFm?=
 =?utf-8?B?WjFRSEhqcTNWbnNzbkZxZnhiSWtBZjVRMVdiSEkxV2xwTFE4cDFOVUljMzE0?=
 =?utf-8?B?WitUQVJyZXU2b2pyT3poRkhob3NrbXdQQXlQcTc0U2NrblFlaVdBQldOY3Bo?=
 =?utf-8?B?bW9KRXpOaW11VkZjZldiTzlkSzY0SVpXMldsRWdzK09rSVRCdEZzNnhlSllX?=
 =?utf-8?B?OWhGVStSOGlKNmxKQnNwTjl6QjMxaGdHVFRqVmUzazB6MnJVNVdkblRTUjE2?=
 =?utf-8?B?RXVIeFAwR0dPcUhkeDVkZlc2WEkxNXp2WUxTSjJqTjhTeFhudmpqSHhhdytM?=
 =?utf-8?B?OHJBTnloWEQ3eTZSU3N4MnpscHhYVFU2MU0vWXVoVXArSGZnZ3AzN3RTWDVN?=
 =?utf-8?B?ZnNEeW41MENvUE9rTGE4aUxTWmdEWmtONWVIU2krVUdJOTJkdVhEV0xpWVJ3?=
 =?utf-8?B?WEI5Sjh4blB0NElsTTB3dm5KTCtPR0d4ZzRDdCt6a24vQjV0T2JrWVhXcXp3?=
 =?utf-8?B?WmlnQmpOcmZsanlMcEd4RDhZb1crQ0VHanpTWDJDeWVtQ2U2dVVScVRmUmtU?=
 =?utf-8?B?b2JiODJtUWowWEU5eDZ4U285anFWTGVzMzBjUEtvanBWTXlMdGZRWlYxZ2tW?=
 =?utf-8?B?Z1VSUFZTNVh5bXYvWWdWVVBiZVh1eVFuSFNtYmJGVHhmWm5XT1FVMm9iWkRj?=
 =?utf-8?B?OStQbXFTUmt5M0dmdlBEaGIwbVNwM1FCYTY3TkVuY0Z3djdGS2preTVRd3BY?=
 =?utf-8?B?UHFjelIwUVpINlI4NzRVQTR5UmJkOUtmSmVGalgrRGpqd2ZoZnYxcStpQjIv?=
 =?utf-8?B?WHloMkwwdVZsQlhYRmxBZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0puNjhaQkMxT2FqRDdlZmw5R2djZ0MwbTdtVWdqK01IVkV5bWhERG9QRHps?=
 =?utf-8?B?OVlxQ0oyQjJJVXlpNGY1MHhmY3EyRmJZaG5ZVGpGZ3JrY0FpZE54Q3gvUDMz?=
 =?utf-8?B?YXFZNkcxSi9wQXFETXMwcDRlSldHeHF6MHRuMmMvdHhmdERnY1hTUGRQTmF5?=
 =?utf-8?B?Nkgwd21YczBGUW1XQWcxN3pyaTFkelYxdzVNRUVrTlBVVUU3ZjZsWDUwSVBz?=
 =?utf-8?B?VnFjd0ZMcjVoVFBSY3BCYS9McEc2WjNodmoxUU5OVis3blpLbXBNQll2Rnph?=
 =?utf-8?B?ZHpZTEhPRStHeFZvUGczQkFTMzJWMVBoTGtxMjhZOTZlM1hQaDd3SjF3ZEpi?=
 =?utf-8?B?MUt2S0hWM2RIZFVyaEpDSitLOVFwUmxMS1Bac1NkTlMrQ0Fsb3JTei9sbTU2?=
 =?utf-8?B?WHY0S2NyWDdkOUJGcTR5QXpxV09jQTFjWkxaQ0hwR2VIUE5YMjNDcUVBRm9i?=
 =?utf-8?B?OGVGYlBsL3puSjQzbUJhbWpFTjlKOXRNVDlsb2VJNVdSQ3dxcXNhWkxscWIy?=
 =?utf-8?B?dFhnZllHYzNhSlhSODRKWFpDTXhQU2lIWS9DREYrenUvRFg3OW9YdHhlT1Zy?=
 =?utf-8?B?UkRlSDdxbkxVeHVzb0pQMEVodVdtWVc0U2hhVWFuTG1oSGl6OTdUdkdRUWFV?=
 =?utf-8?B?b0MzQnYvcUxuc3EwdXR6RmY2OFVsTzN6TVhiOFdUMDduUVpBS3o5UklnNUpY?=
 =?utf-8?B?d01icUVLNFloVU1LMlZnNzJFVHJuV25zV1ZFR1k1OTNrTWNaNFFkUzBiejla?=
 =?utf-8?B?RCtFMkN2YmRKditxajBDVkRjbk5weEtEYzNkZTIvb0V6VW50SWs2TkZiZ2R5?=
 =?utf-8?B?Vzc5TDlMWDJiQXVSZURSbzU1SWZCS2FHcXlsSVNGdkIxOFNjeURkMVNtaTNB?=
 =?utf-8?B?akJNb2pZeUIrOG1PZWR4d0NtWTdWQ1dwNnNSZ3B2WlBFUUZnRWJ1QVhtb2tu?=
 =?utf-8?B?WWNvUUpIWjBJYnFaK1Q5dFFRR3VIT2JrZ2Rzb0w0OTcrallvZzMxVWVodjI1?=
 =?utf-8?B?R3pqNzJvS2Q3cEMxUmQvUnpkampueW9udFdwQThKaGxxUHNGYXhxcHBiVC9s?=
 =?utf-8?B?d3prdG5FaFFUdHF3M3lYdjlhdXV6OUpSOStsR2RPQ29QcHdnak9NbHFmOU1C?=
 =?utf-8?B?MFozaEZ2eWxLNWVPK011RnUvRVl3UG51R2tGaTFxNXpaNFVJTS9XMXRxa2xo?=
 =?utf-8?B?UUV2MGkyYWpvajlENGVrOVJWajFSR0dmUjUweThGV0J2dFZHbHBxemcwUlVY?=
 =?utf-8?B?OVExbDd2Z0hpNHgzOFRvTXFoc1o1NnlJeEdON2dyM1VXTzZHWEpmZXVNdXRX?=
 =?utf-8?B?ZXkrZ3RBYWlENEFHQmJqYXk0UGNBbGRDc3kyeXBvaE5jUW83dkxZQWhuUnFh?=
 =?utf-8?B?dndDdVJ2NnBkZ3BpUVFEWXJpNGY1ekMyNlRWdVNrQ0FaRjBlNUwyMDU3UnJw?=
 =?utf-8?B?ZjJzWmg3YWV3bjBKNUtSM1g5dHNVTTJSUW1xTVNnOHJNbVd2RG5RVlBSdXds?=
 =?utf-8?B?ektUMmFSUmVkZ1FXNkp0cW93TGpUbnB4MWZoZXFBRVBoSXhUU1d5S3ZFaU5I?=
 =?utf-8?B?TWxGaEQrc1BQbG9xNlZXNDNhWlVkdGQwMnN0R0dUc3B6NnVlTkRxSFUra09J?=
 =?utf-8?B?MTZUMHBqSWNUY21YOTJWdmtlUWtKdWt4bzBuSzhDNllCZTJJT0NMa2VycFl6?=
 =?utf-8?B?aHIwSnNjVFQyQzVLSjEwbWIrZXlYeXZxbTc4TWJEeVBsWG12Nnh4QmVRcUY1?=
 =?utf-8?B?NHY4bDBnZHkwY2twdFFmaTEydS9nVWNvd1BoenowZXNnTEdEbkFVLzRwTXVW?=
 =?utf-8?B?WkZnTEJ1ZjY2dStjTDlDeUtmc1ZsbmZZb2VDT2pQY3Vqakx5L0x0UU5IRVhi?=
 =?utf-8?B?NXNpcWZuT1FIcGZWOEhxZlBSQmVyeVdZRFZxS0tsUVppVHhjR21XZWMwNjJq?=
 =?utf-8?B?eEs1empSd0ZQYVk5cUludlpyYWVrRHRETTN4SjRnRE53cUR1WlVndDRnWnRW?=
 =?utf-8?B?ZnZYN3pDVFF3dXFkdnUxQ2ZFVWtOYTljbURUNGlvNE8rSlhrai92b21rcXl3?=
 =?utf-8?B?dUJ5NVhYdm85dTRwc2Jtd0UyUDJlNHFwRmg5V2phSXVuZlYvQkdlckJ0OFFG?=
 =?utf-8?Q?mFVp/N8XkpI9SzCqR14Qbe0mF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f721255f-bd90-483f-5012-08dc99a276ea
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 07:50:24.1623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ic1WKcZFGfjq7OPJMF5e60YC+tppbBvpq2fm10SxqFaSX0YHC5DeN+po8HJQPvmQRhoiTb53EMS71XmmAqlMAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7687
X-OriginatorOrg: intel.com

On 2024/6/17 17:53, Yan Zhao wrote:
> Reuse file f_inode as vfio device inode and associate pseudo path file
> directly to inode allocated in vfio fs.
> 
> Currently, vfio device is opened via 2 ways:
> 1) via cdev open
>     vfio device is opened with a cdev device with file f_inode and address
>     space associated with a cdev inode;
> 2) via VFIO_GROUP_GET_DEVICE_FD ioctl
>     vfio device is opened via a pseudo path file with file f_inode and
>     address space associated with an inode in anon_inode_fs.
> 

You can simply say the cdev path and group path. :)

> In commit b7c5e64fecfa ("vfio: Create vfio_fs_type with inode per device"),
> an inode in vfio fs is allocated for each vfio device. However, this inode
> in vfio fs is only used to assign its address space to that of a file
> associated with another cdev inode or an inode in anon_inode_fs.
> 
> This patch
> - reuses cdev device inode as the vfio device inode when it's opened via
>    cdev way;
> - allocates an inode in vfio fs, associate it to the pseudo path file,
>    and save it as the vfio device inode when the vfio device is opened via
>    VFIO_GROUP_GET_DEVICE_FD ioctl.

So Alex's prior series only makes use of the i_mapping of the inode instead
of associating the inode with the pseudo path file?

> File address space will then point automatically to the address space of
> the vfio device inode. Tools like unmap_mapping_range() can then zap all
> vmas associated with the vfio device.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   drivers/vfio/device_cdev.c |  9 ++++---
>   drivers/vfio/group.c       | 21 ++--------------
>   drivers/vfio/vfio.h        |  2 ++
>   drivers/vfio/vfio_main.c   | 49 +++++++++++++++++++++++++++-----------
>   4 files changed, 43 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index bb1817bd4ff3..a4eec8e88f5c 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -40,12 +40,11 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>   	filep->private_data = df;
>   
>   	/*
> -	 * Use the pseudo fs inode on the device to link all mmaps
> -	 * to the same address space, allowing us to unmap all vmas
> -	 * associated to this device using unmap_mapping_range().
> +	 * mmaps are linked to the address space of the inode of device cdev.
> +	 * Save the inode of device cdev in device->inode to allow
> +	 * unmap_mapping_range() to unmap all vmas.
>   	 */
> -	filep->f_mapping = device->inode->i_mapping;
> -
> +	device->inode = inode;
>   	return 0;
>   
>   err_put_registration:
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index ded364588d29..aaef188003b6 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -268,31 +268,14 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
>   	if (ret)
>   		goto err_free;
>   
> -	/*
> -	 * We can't use anon_inode_getfd() because we need to modify
> -	 * the f_mode flags directly to allow more than just ioctls
> -	 */
> -	filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
> -				   df, O_RDWR);
> +	filep = vfio_device_get_pseudo_file(device);
>   	if (IS_ERR(filep)) {
>   		ret = PTR_ERR(filep);
>   		goto err_close_device;
>   	}
> -
> -	/*
> -	 * TODO: add an anon_inode interface to do this.
> -	 * Appears to be missing by lack of need rather than
> -	 * explicitly prevented.  Now there's need.
> -	 */
> +	filep->private_data = df;
>   	filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
>   
> -	/*
> -	 * Use the pseudo fs inode on the device to link all mmaps
> -	 * to the same address space, allowing us to unmap all vmas
> -	 * associated to this device using unmap_mapping_range().
> -	 */
> -	filep->f_mapping = device->inode->i_mapping;
> -
>   	if (device->group->type == VFIO_NO_IOMMU)
>   		dev_warn(device->dev, "vfio-noiommu device opened by user "
>   			 "(%s:%d)\n", current->comm, task_pid_nr(current));
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 50128da18bca..1f8915f79fbb 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -35,6 +35,7 @@ struct vfio_device_file *
>   vfio_allocate_device_file(struct vfio_device *device);
>   
>   extern const struct file_operations vfio_device_fops;
> +struct file *vfio_device_get_pseudo_file(struct vfio_device *device);
>   
>   #ifdef CONFIG_VFIO_NOIOMMU
>   extern bool vfio_noiommu __read_mostly;
> @@ -420,6 +421,7 @@ static inline void vfio_cdev_cleanup(void)
>   {
>   }
>   #endif /* CONFIG_VFIO_DEVICE_CDEV */
> +struct file *vfio_device_get_pseduo_file(struct vfio_device *device);
>   
>   #if IS_ENABLED(CONFIG_VFIO_VIRQFD)
>   int __init vfio_virqfd_init(void);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index a5a62d9d963f..e81d0f910c70 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -192,7 +192,6 @@ static void vfio_device_release(struct device *dev)
>   	if (device->ops->release)
>   		device->ops->release(device);
>   
> -	iput(device->inode);
>   	simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
>   	kvfree(device);
>   }
> @@ -248,20 +247,50 @@ static struct file_system_type vfio_fs_type = {
>   	.kill_sb = kill_anon_super,
>   };
>   
> -static struct inode *vfio_fs_inode_new(void)
> +/*
> + * Alloc pseudo file from inode associated of vfio.vfs_mount.

nit: s/Alloc/Allocate/ and s/of/with/

> + * This is called when vfio device is opened via pseudo file.

group path might be better. Is this pseudo file only needed for the device
files opened in the group path? If so, might be helpful to move the related
codes into group.c.

> + * mmaps are linked to the address space of the inode of the pseudo file.
> + * Save the inode in device->inode for unmap_mapping_range() to unmap all vmas.
> + */
> +struct file *vfio_device_get_pseudo_file(struct vfio_device *device)
>   {
> +	const struct file_operations *fops = &vfio_device_fops;
>   	struct inode *inode;
> +	struct file *filep;
>   	int ret;
>   
> +	if (!fops_get(fops))
> +		return ERR_PTR(-ENODEV);
> +
>   	ret = simple_pin_fs(&vfio_fs_type, &vfio.vfs_mount, &vfio.fs_count);
>   	if (ret)
> -		return ERR_PTR(ret);
> +		goto err_pin_fs;
>   
>   	inode = alloc_anon_inode(vfio.vfs_mount->mnt_sb);
> -	if (IS_ERR(inode))
> -		simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
> +	if (IS_ERR(inode)) {
> +		ret = PTR_ERR(inode);
> +		goto err_inode;
> +	}
> +
> +	filep = alloc_file_pseudo(inode, vfio.vfs_mount, "[vfio-device]",
> +				  O_RDWR, fops);
> +
> +	if (IS_ERR(filep)) {
> +		ret = PTR_ERR(filep);
> +		goto err_file;
> +	}
> +	device->inode = inode;

The group path allows multiple device fd get, hence this will set the
device->inode multiple times. It does not look good. Setting it once
should be enough?

> +	return filep;
> +
> +err_file:
> +	iput(inode);

If the vfio_device_get_pseudo_file() succeeds, who will put inode? I
noticed all the other iput() of this file are removed.

> +err_inode:
> +	simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
> +err_pin_fs:
> +	fops_put(fops);
>   
> -	return inode;
> +	return ERR_PTR(ret);
>   }
>   
>   /*
> @@ -282,11 +311,6 @@ static int vfio_init_device(struct vfio_device *device, struct device *dev,
>   	init_completion(&device->comp);
>   	device->dev = dev;
>   	device->ops = ops;
> -	device->inode = vfio_fs_inode_new();
> -	if (IS_ERR(device->inode)) {
> -		ret = PTR_ERR(device->inode);
> -		goto out_inode;
> -	}
>   
>   	if (ops->init) {
>   		ret = ops->init(device);
> @@ -301,9 +325,6 @@ static int vfio_init_device(struct vfio_device *device, struct device *dev,
>   	return 0;
>   
>   out_uninit:
> -	iput(device->inode);
> -	simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
> -out_inode:
>   	vfio_release_device_set(device);
>   	ida_free(&vfio.device_ida, device->index);
>   	return ret;
> 
> base-commit: 6ba59ff4227927d3a8530fc2973b80e94b54d58f

-- 
Regards,
Yi Liu

