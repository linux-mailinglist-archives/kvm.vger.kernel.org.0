Return-Path: <kvm+bounces-16142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C346D8B527E
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 09:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A652281DC6
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 07:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408B715E85;
	Mon, 29 Apr 2024 07:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dmc5UlLM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C26EED4
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 07:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714376428; cv=fail; b=go2ivCq035goh5za0GL9aDQ4rltgH+SHei95IvgkuVsM3zTZNjNHQFNgkgGLOTgcuCXpSvG5uXblbBtncGXrLKlaQXpOMb3d467rO4ftnG/QcgIZJuGvaKPggQZd1begKB9K28Yaf2OXDFv55IKWef8x+H3i+agPBuv90hELXxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714376428; c=relaxed/simple;
	bh=VnMTr0AGh3xCFUbJkGu0qTfIXZ1JfOSMc9kXSIviXXE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=at3h9UnyXnQGyEGkHFF+OjeyueP0YQ+SkPAhkIcwEawm6DAYUp8ywhscU3OyVwRO95A9SC0xWp/uiHSEEnwRDGZ8GVM4Ck1d4gQYKUIMIt+R09D1+3d081G4vTqssKNiiDH6Ys/LYrSIdDdXJYrS/RiT/kdwojg7+SAnJu8RNAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dmc5UlLM; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714376427; x=1745912427;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VnMTr0AGh3xCFUbJkGu0qTfIXZ1JfOSMc9kXSIviXXE=;
  b=dmc5UlLMY8Mz/2QCnTetosNDaWZX1GRwf5hUIS44ELU/65zjzcSzbGyw
   o85vBmaPA/abtCxqJ/iGcp2KP/myWFPPH5dDPKpazrDDUV6FtiNY8EzUs
   j8MAOCSCKrOGW4Ln+EFayywQXFaYGHON07ZdQq6SnCurVc92ljTypLgka
   wI0zmWwO2TPDqWko0yE7RQ3DrZdIYdg4As03KCL6Tp1BUemolHnh2L+1K
   9gSO/05CdULt65pd8kGGOlgOj80oHsq90y51yAHaoKaLgmPeDfTak7yEI
   9VR9ahonOuJxvmanMpW+GgOdGXMaGNCp1AQHrN4ZxsefGQ+6jwBUOK1EB
   A==;
X-CSE-ConnectionGUID: +i9bYi2ZTf6NxfCcYBAaVQ==
X-CSE-MsgGUID: 5++f5N62T9CuiqrdhxMaGg==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="21177211"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="21177211"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 00:40:27 -0700
X-CSE-ConnectionGUID: +MLZ3WIPTFuvgGILp343sQ==
X-CSE-MsgGUID: Jmx7Bel2TxOtwL8G7ZeJwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26545178"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Apr 2024 00:40:26 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Apr 2024 00:40:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 29 Apr 2024 00:40:25 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 29 Apr 2024 00:40:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOiTP+v2NiH0tPG6gy1ILzKQx7I1dyUV0edNH6PwYqBviRA9LrQgdLzjjxS9Bju1L2mpmOPiQTCGX+2bMhdwtjSzqf525BMym5s/y7RLzaSahnthioi7ldTWEX4zhpYzMEka6QJXMuZgVlEl+mfUYiYdc47Z7JV6P520OBwF8CktzgvIEe8v6nrAKF1mUnYnQ/RZid4KO2TNKFEDe0FtItUjmy+22k/Hy1SuZZinSuClSpODmoLoSEv86kvRMjEoJ4JgOr1uau8lYT2kEGMOsonUWQ1213OaBBPKZE8PTMXl0PsWEm/+0UmWcI2s9EMGkZ3OuPYuas7A2W59wREsiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIGcfRoOREuwcEoLmgi2O70uKP35hJG3A8TcdmqTRKE=;
 b=aYJTy9qjNEL4Pdf61CTLU2L8sIKtwfkek/i1B33akNdIla8VDM8iI/iIcQcG379Xd/z08kL2nGVTEBJCvyitE8VWNoxw0mw8Ow1As2tnPIr746rHY06TKK1qWfyA86tKtQnurRC6T2VkGAatkdW4n58pSUUKW87AK/itxUckm7koX6W6wdRbxpp2KDyEwVeeXRfaNZ8Nz9asKCOyfqOm5FDfyjdYlLfNkcXSvy/wyTtPg7CPn//dRQAFWM7FgfugfQjnI6yR+4CKgWVlAlmh+To/I1gKWc/9/RwNE6iBKnA2YHwibCKWfo2oiovwSCKvZ01czuSvl5AC99jElK0JvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB6425.namprd11.prod.outlook.com (2603:10b6:510:1f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Mon, 29 Apr
 2024 07:40:15 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 07:40:15 +0000
Message-ID: <888f261d-fff7-47be-843a-8368be3bf08f@intel.com>
Date: Mon, 29 Apr 2024 15:43:49 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
	<clg@redhat.com>
References: <20240418143747.28b36750.alex.williamson@redhat.com>
 <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
 <20240424122437.24113510.alex.williamson@redhat.com>
 <20240424183626.GT941030@nvidia.com>
 <20240424141349.376bdbf9.alex.williamson@redhat.com>
 <20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
 <BL1PR11MB527133859BC129E2F65A61718C142@BL1PR11MB5271.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BL1PR11MB527133859BC129E2F65A61718C142@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYWPR01CA0045.jpnprd01.prod.outlook.com
 (2603:1096:400:17f::15) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH7PR11MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: 21a6f776-279f-4ede-bd19-08dc681f9c0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V1VjTERuamZlelNEcUZVQmE2NjNKOWJ0d2RMaCsyV0NrV2NYS082T0ZjNUVi?=
 =?utf-8?B?S2xJdGhHT1UvRzFPQ2EvSm9FdWRodzJsdjB3Zlp2VFkwSmQ1WjgyTTd4cHY3?=
 =?utf-8?B?YU5tZkc2eEMyRmZZQ0dGZWhLZGpPZU9wVTFVQ25QOGVFMnZUMWt3eXFXaFZH?=
 =?utf-8?B?K2QzMTdvQ0dndXhEbm1nSENnMU1rM2VrbEVwQWZlaldYZTVTcStIaE5RWVly?=
 =?utf-8?B?YWU0YnZ4bkZxcy9sQUxjODd1QVEreHlxNVJxZ0Erdy93ZWpybzV0K3dsRFJk?=
 =?utf-8?B?aC9pck9nb2NrYmZDcFNwMnhIdFJZdFRBMi9PM1kzcFpvSFdwQVRHVXliVlNN?=
 =?utf-8?B?QmZVeDh0M1lDVEQ0V2dPWWVlT2dGTWRscnhZd1M4dFBUUEdJcDFtYUdXUlFt?=
 =?utf-8?B?WXkyRUxhVFE2U2pFV0szNjJvRzhidHBieU5ZWGxtK09aaHdjQnJNeHZIZ3Ez?=
 =?utf-8?B?UWxXbEhUTGV5WkZyRitYd3NtSElzcllKOW5pVGorU3Q2Sk9md0xSNjlOQS9m?=
 =?utf-8?B?WlEzN1l2SnQ2VGs4M0UxcnJKb0tSMC9SUi9xOFlPUHd4UXgrd0d5NkhyalA2?=
 =?utf-8?B?cmo2djJncDVUTzN3d1BEcm5pRnRpMnB5L0dYNWFTTHZxa2xtcW14aFRKRFVt?=
 =?utf-8?B?dzdUM1FWYWNGTlpMTEoyL1VkR1VBV296U1ZKanVwTFJuaG00cGpSWGdQbFMz?=
 =?utf-8?B?amVqOFp5UTVzTmxsWFBXeXNFVThjMmVDekw3bkE3c28yZ2V1RkMrYzlpeXpP?=
 =?utf-8?B?eG52ZTVORXlZV0dUbHFPSllXL29PNWR4bFNUUWxxVzlhbXJVejJWVTg1WUw0?=
 =?utf-8?B?ejNvVCtENTNpSnF2a3FDWEZNMnROeDJlLzhncnNoejZxT3hDOWVNU0dyYUVi?=
 =?utf-8?B?a1FxR1k2RzBVMkpDYVdMd0ZqSGdCSmdUdjA2aDJURG9lV1B0VG1tY3pMT0Js?=
 =?utf-8?B?WDRQb3FMYW9HS1dYRWdXaFd5S2s5Y2x4cjEvalZYUTN6RmRDQ0J6amZOcEhF?=
 =?utf-8?B?M3JkK2Q3dURYVEVEaHprdXFFY2k2Q1VGMTdHYWVYdThWVEI4L1ZGNHViUTQ1?=
 =?utf-8?B?MEJaVEE5WTgrYWx3MTlwd3hzMTBPcks4V0dnZm9iUk5jZ2cvV0xPSU5BbDBG?=
 =?utf-8?B?N1hnZk9VS0c2anAvV3crNitLbUxCUUJLWGN2RWtpSVBzS3pxOENQYW1Bd0ZB?=
 =?utf-8?B?QkZxM2p1bVBEWWtVL3lKOVpkOG84NWtqRTMvSVNOUEFEM2RWeURUM2lmSDVv?=
 =?utf-8?B?ckE0UzF0TmlNbXMxbGtzS05hZ3lsN2VaaDNUVmJQM3N3c2tBL0toRm1yL2M2?=
 =?utf-8?B?YVJRMEtxMUd1VzBsaWx0aitlUkdnMjJwb1N4MWgwdXNIeXNRWFJ1aVRJd1RM?=
 =?utf-8?B?SVZ0NzdUQlVYT3Zxa2w4b2pVSXJsckRaNUliUFVuMkdJUFVIK1pPTVgwZUdI?=
 =?utf-8?B?elRXZFFBa3RwSGM5cjFkTENzSUhIL0dLdVBvQWRjMmZUeU9XTC8wUnpVSTJG?=
 =?utf-8?B?WWNzS2pYTW42L0t6NnJkSG9GQU1YOWF6UkpJdFZncFFTNTk4L3VaQmQrQjRL?=
 =?utf-8?B?QkVPaGRpWlZCVEFaQzU3MkFwQnhtd3ZQRlhSRUlEWWR0ZzJKVGhvamUxb3Vm?=
 =?utf-8?B?YkJsTloxM2s4MXFaazFwMFdUOGY1bHBONnVzL0JETHRBUlBmVVVBQzNqcENL?=
 =?utf-8?B?MUhRVnRPV3FHNE5VNnZyL3U0N1FnR1NwZUpXaGV0T0dnSHMxZDBmWlV3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eThxLzhid3A0TkQzdHMxSTFUclZDRzRuTnJ6QndkWDB3bk9hYTU3VDFoc2k2?=
 =?utf-8?B?QVo3R2lvZGdERUFEcVRlUVFzc3hoWHlhTE43Y2w4R1laZFZqdVhZSnIxVmtM?=
 =?utf-8?B?NEhVM1lyYUg5KzN5aW1qeG1LRGI1WTlvdkxDK2xlWjBlNVovK3kvS3JBbmQx?=
 =?utf-8?B?OTh3M1RVS0NvOG5sZDdhTnY3by9xdi9aYmV2TzAxU0IxWG02dmJPRHdyMzlE?=
 =?utf-8?B?TEY2SzN4ZFVlSDZUdXViUnlZdXZqU3JVV0RlSGVEWmpxUHZKaHV4NjNhd3Z2?=
 =?utf-8?B?SjVwZk0zMXhsQW1iSWhwOEgvSmgzLzlDRCtYREZuQ3VEL0c3QUxRdU84d21p?=
 =?utf-8?B?YjNDQmt3aWlHTkd5NnYxL0VoRnJqWkpCM3EzaWtlMS9sR2VpYldXWUZ4N0FP?=
 =?utf-8?B?Z0x3OUxsNGlwenl0Y2V4WC9IcUd2cUJzT2w0NEJVd3JubUllV29zQVVCYUNp?=
 =?utf-8?B?UkRtdUkwUFEvRzNKWTM3U0FWbkNqd3l6WTZYNExOWFdmQjh0T1Yyb0FVRWJC?=
 =?utf-8?B?VnBIR3AxYmtwWUpCNWRDV1N1V3lOeDZncElieXRsa1JuOGxkYU5ieGt3TEl4?=
 =?utf-8?B?eVZ6VWUvVTVrQWJIN0t6Tzc4NW0zS2N1eWJPOEVXaTlUN3VqblkwZ3FnQUVn?=
 =?utf-8?B?Q1VoK0VUeXdVaitzT2hqTk9obi9ud0pYZG12S3NxcFBhNzZ2c1pFR2RKa0dM?=
 =?utf-8?B?eE8vWldaekNndEZSNk9EbjVUbGtJNTVtMVFXMzNsLy9LQnJHK1ZkUjV0RFB2?=
 =?utf-8?B?alJ4WE91c3VhMUxOcmQvbi94bmNEdGZIdVdQUFZkVGN6NTdJbG93M2x2MExh?=
 =?utf-8?B?eXVIeDIwRC82NW9PWGNtM2tEalppVWVmeGJWSUdrVE11cWZCNFFNOTYwTkU4?=
 =?utf-8?B?Wk1TMzZFK3BWekJMb210VFRkbjBFUnVZdjlNNldiSmVPcUx1UThKbHVHODlN?=
 =?utf-8?B?dW00RnU5SWNQTU1INURvUVRsZktBbFk2UlBNRy84aEFXVUI4N3lPY2cxTzMy?=
 =?utf-8?B?emx5TWtScXhEVXRBaXJQT2JJM0pyeHg2bVcvQThVNTdjWTBpS3NnMmxaNkdZ?=
 =?utf-8?B?K2RpMTBHOHV0TUhZWHZGOHIxZVRNK29GU29aMVRVTFF5SHpTUFBtNWNtMEhw?=
 =?utf-8?B?TC96c2VwOXlSc29oYjh0aTVSOWpCSHJ4N2Rza2xKTldHZG5IWkJIaWdUTWli?=
 =?utf-8?B?YW9YM3NNM3pBYWF2bnZvOTgyYlBmdWo5T3cyN0lRWWRxRWJKK2Q3bE9MeklW?=
 =?utf-8?B?enRTSklzMGNTUytBQjNPU2NlNW9HUDYrS2Yycm1sVlNDQ3ZBdW40aFMvMnZu?=
 =?utf-8?B?RzVKSTBhbENBdmdZVmtJS1hZVnRyMmtlUlNFUDZ0ZlUwek5pWTc3MTFGdVps?=
 =?utf-8?B?YklldkowNVEyV294bHJzb3NlYlE5bUtjMEdObG1vNzdtUEhpNkREZ1VkUVA4?=
 =?utf-8?B?elMrYzZySTV6QXRKMDhwUXZZTWtpZnMxSVZtNzRqWUluc2hmKzM0WEdDM3Qz?=
 =?utf-8?B?M2VLK01WWU4xNEpCYlBTYjAyYWlDY0RFM2ZxNVg1TmZzN0xNWHRWZ1hDaHA4?=
 =?utf-8?B?cnlvL1p4dzhHUmRLSG9iTkhrc2VwUThwSHVCREdRcHRjTUpGMDFVYjAxUFAr?=
 =?utf-8?B?dVBINWcxNEczRTlyclJCSCtzUDcvcXd1Y1EwcnlFSnVMK0FIN1dLVFZKd0w3?=
 =?utf-8?B?SkpVRXJtUGRzUmpOU2hnK2pIYTRtVURiajQ0NXF4R2pwVEwzQVcrblpadnd2?=
 =?utf-8?B?N0R3MExaYUZRcFVZbEliRnJrSzFld3ZaY1p3UlF0UkR5K3RpZUN3M244TGVU?=
 =?utf-8?B?UmtEdFFZdTZYVnlIWGxUTGZnM2F0VWNuVE5lam9UNVV2dk9sYlUxQmlBdjhr?=
 =?utf-8?B?eWh1QzhGRzFtdHVZa3RHSGRURVZlazdMaU05bm9PaEdqVGt3ZW5TZjRMZEJl?=
 =?utf-8?B?V28rb2t4YW1VVnF5eFNibGwyWmNwSGVBMzdXOVdtcmZpekJuSys4TFdMM1dO?=
 =?utf-8?B?NXg5VkFXN1UwTzdPTUgxdUtTN2JqOXRxWDFoeUlURjhZRlFFSEdOZFBTSWJU?=
 =?utf-8?B?M1BIZ1g4NnQ4RXc3UWpxVGxNTTh6Um1XcExqMGw4MXFlaHMrOE9SemJsdkJ3?=
 =?utf-8?Q?cujCyDKQmsgA+gqKerdcV4lXR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21a6f776-279f-4ede-bd19-08dc681f9c0b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 07:40:15.2589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w5PeGBv2OhXkEb9YIV09wkHFshZ6Kk68ZyGT23v+3BrCu7wiIqoSBAI/AUmv2K5QpcZ9faOiKYQQwIAwjiuMfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6425
X-OriginatorOrg: intel.com

On 2024/4/28 14:19, Tian, Kevin wrote:
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Saturday, April 27, 2024 4:14 AM
>>
>> On Fri, 26 Apr 2024 11:11:17 -0300
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>>> On Wed, Apr 24, 2024 at 02:13:49PM -0600, Alex Williamson wrote:
>>>
>>>> This is kind of an absurd example to portray as a ubiquitous problem.
>>>> Typically the config space layout is a reflection of hardware whether
>>>> the device supports migration or not.
>>>
>>> Er, all our HW has FW constructed config space. It changes with FW
>>> upgrades. We change it during the life of the product. This has to be
>>> considered..
>>
>> So as I understand it, the concern is that you have firmware that
>> supports migration, but it also openly hostile to the fundamental
>> aspects of exposing a stable device ABI in support of migration.
>>
>>>> If a driver were to insert a
>>>> virtual capability, then yes it would want to be consistent about it if
>>>> it also cares about migration.  If the driver needs to change the
>>>> location of a virtual capability, problems will arise, but that's also
>>>> not something that every driver needs to do.
>>>
>>> Well, mlx5 has to cope with this. It supports so many devices with so
>>> many config space layouts :( I don't know if we can just hard wire an
>>> offset to stick in a PASID cap and expect that to work...
> 
> Are those config space layout differences usually also coming with
> mmio-side interface change? If yes there are more to handle for
> running V1 instance on V2 device and it'd make sense to manage
> everything about compatibility in one place.
> 
> If we pursue the direction deciding the vconfig layout in VMM, does
> it imply that anything related to mmio layout would also be put in
> VMM too?
> 
> e.g. it's not unusual to see a device mmio layout as:
> 
> 	REG_BASE:  base addr of a register block in a BAR
> 	REG_FEAT1_OFF: feature1 regs offset in the register block
> 	REG_FEAT2_OFF: feature2 regs offset in the register block
> 	...

Should we also consider the possibility of vBAR address difference between
the src and dst? It should be impossible that the guest driver mmaps vBAR
again if it has already been loaded.

> Driver accesses registers according to those read-only offsets.
> 
> A FW upgrade may lead to change of offsets but functions stay the
> same. An instance created on an old version can be migrated to
> the new version as long as accesses to old offsets are trapped
> and routed to the new offsets.
> 
> Do we envision things like above in the variant driver or in VMM?
> 
>>>>
>>>> What are you actually proposing?
>>>
>>> Okay, what I'm thinking about is a text file that describes the vPCI
>>> function configuration space to create. The community will standardize
>>> this and VMMs will have to implement to get PASID/etc. Maybe the
>>> community will provide a BSD licensed library to do this job.
>>>
>>> The text file allows the operator to specify exactly the configuration
>>> space the VFIO function should have. It would not be derived
>>> automatically from physical. AFAIK qemu does not have this capability
>>> currently.
>>>
>>> This reflects my observation and discussions around the live migration
>>> standardization. I belive we are fast reaching a point where this is
>>> required.
>>>
>>> Consider standards based migration between wildly different
>>> devices. The devices will not standardize their physical config space,
>>> but an operator could generate a consistent vPCI config space that
>>> works with all the devices in their fleet.
> 
> It's hard to believe that 'wildly different' devices only have difference
> in the layout of vPCI config space.
> 
>>>
>>> Consider the usual working model of the large operators - they define
>>> instance types with some regularity. But an instance type is fixed in
>>> concrete once it is specified, things like the vPCI config space are
>>> fixed.
>>>
>>> Running Instance A on newer hardware with a changed physical config
>>> space should continue to present Instance A's vPCI config layout
>>> regardless. Ie Instance A might not support PASID but Instance B can
>>> run on newer HW that does. The config space layout depends on the
>>> requested Instance Type, not the physical layout.
>>>
>>> The auto-configuration of the config layout from physical is a nice
>>> feature and is excellent for development/small scale, but it shouldn't
>>> be the only way to work.
>>>
>>> So - if we accept that text file configuration should be something the
>>> VMM supports then let's reconsider how to solve the PASID problem.
>>>
>>> I'd say the way to solve it should be via a text file specifying a
>>> full config space layout that includes the PASID cap. From the VMM
>>> perspective this works fine, and it ports to every VMM directly via
>>> processing the text file.
>>>
>>> The autoconfiguration use case can be done by making a tool build the
>>> text file by deriving it from physical, much like today. The single
>>> instance of that tool could have device specific knowledge to avoid
>>> quirks. This way the smarts can still be shared by all the VMMs
>>> without going into the kernel. Special devices with hidden config
>>> space could get special quirks or special reference text files into
>>> the tool repo.
>>>
>>> Serious operators doing production SRIOV/etc would negotiate the text
>>> file with the HW vendors when they define their Instance Type. Ideally
>>> these reference text files would be contributed to the tool repo
>>> above. I think there would be some nice idea to define fully open
>>> source Instance Types that include VFIO devices too.
>>
>> Regarding "if we accept that text file configuration should be
>> something the VMM supports", I'm not on board with this yet, so
>> applying it to PASID discussion seems premature.
>>
>> We've developed variant drivers specifically to host the device specific
>> aspects of migration support.  The requirement of a consistent config
>> space layout is a problem that only exists relative to migration.  This
>> is an issue that I would have considered the responsibility of the
>> variant driver, which would likely expect a consistent interface from
>> the hardware/firmware.  Why does hostile firmware suddenly make it the
>> VMM's problem to provide a consistent ABI to the config space of the
>> device rather than the variant driver?
>>
>> Obviously config maps are something that a VMM could do, but it also
>> seems to impose a non-trivial burden that every VMM requires an
>> implementation of a config space map and integration for each device
>> rather than simply expecting the exposed config space of the device to
>> be part of the migration ABI.  Also this solution specifically only
>> addresses config space compatibility without considering the more
>> generic issue that a variant driver can expose different device
>> personas.  A versioned persona and config space virtualization in the
>> variant driver is a much more flexible solution.  Thanks,
>>
> 
> and looks this community lacks of a clear criteria on what burden
> should be put in the kernel vs. in the VMM.
> 
> e.g. in earlier nvgrace-gpu discussion a major open was whether
> the PCI bar emulation should be done by the variant driver or
> by the VMM (with variant driver providing a device feature).
> 
> It ends up to be in the variant driver with one major argument
> that doing so avoids the burden in various VMMs.
> 
> But now seems the 'text-file' proposal heads the opposite direction?
> 
> btw while this discussion may continue some time, I wonder whether
> this vPASID reporting open can be handled separately from the
> pasid attach/detach series so we can move the ball and merge
> something already in agreement. anyway it's just a read-only cap so
> won't affect how VFIO/IOMMUFD handles the pasid related requests.
> 
> Thanks
> Kevin
> 

-- 
Regards,
Yi Liu

