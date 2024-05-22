Return-Path: <kvm+bounces-17953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE128CC146
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 14:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9EA61F2353C
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 12:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3274513D63A;
	Wed, 22 May 2024 12:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OUY+iKiC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C400C13D61E;
	Wed, 22 May 2024 12:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716380987; cv=fail; b=q4ku6OuHgDGz2SddtvC42LSvEt5DH7o7ux3LEtuTI4crln5Khi3gFwjMRSQ8d5CoYsMtIvzpPWXDR+aOSb32c7l4M0+wbbtOVrul+UT2E0KcYtCjV5FCll/onsePjmFbCq4tqesSZpRDQz0eGPWL4LlEQ8ZP3WqvlYxPr+o3D3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716380987; c=relaxed/simple;
	bh=+PRWCQRMaqH2fyZwIuSHJQk7DThqzKcnRwA02rnapww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LbxyKav+L+Uv+lHgNLO3AxXA8He2uFp5r31hdswyCYe6fkqymwO9mvr++T1j9hpXOEXwhQQzqC1qG7k0Q+ITw9goSBq0kiACZQC9zBEfrt+JUbUNOmMi6QkPOEIUXzOoWbFDrW5xGRWARQwmI+aHnnCKB9a7bMAeYg0n/VciB4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OUY+iKiC; arc=fail smtp.client-ip=40.107.244.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsIq1pgJj3OlUoterhNIdmVlDvZuBFE5lREpuFOglIzymKb0QlOHZBSnxJdQ8VrK6wa/JMR6M7lPBcCVeZMKru9faz9QH9qOaQZsg9q5YyCN5cClkmjYyCIjOnSORIRG3gms/GcHeK9tuhHayNEb5rT298rcieSRrFgYsW3Tqy7s4viaisWzr1uoHPqtJfJw0pykQ3D5ZwgxglCaQY/y4/Qvw1o6ktpkOa1KTD9yVwklpxDE/zdXTPZsNsYGgf7nqUSXXVCzd18V44EvUwjs1uG03xSJ7ehTIkv6BEoAjFvnejg3pXKK5Y1uJ0Sd2Unuo18Z+fj2ktuT9GhGy841QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=douoZVAzNZZBAqYeFDgYNp+UekMGS6gBkxzdePXwM88=;
 b=ArsPu7tsK2zIQWoeCKhFhXFNfvyYi1tv6IWlBVcPP8U8fbxD0GLD2L2dkbCpFJzu9aHoP98dO8SzTAFjMqO6KAu7rr8/ngTnPxVHfBOpT8/foivF1QXCLh5UYCfL7YFE0DvJlP4sK5zSSjHNwz6pWObtbK0lRjUcLQGUBjwyJvtJYh/v51ftQEA1ilfNoOUr2AMh5gcQgYwv0FuLQTU8TXMNZy9az3KqKw6Y1wf2YxQGCT+8+fv2BdxFLbVD/BVaaJKVu5foYy5ZDfzuiKukuQz6fPSHGLwpE2nEKvNKxnn6r8zlgVqb1oG2gvqUnAz5ejQIcNHSWpWi05LFhqNkvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=douoZVAzNZZBAqYeFDgYNp+UekMGS6gBkxzdePXwM88=;
 b=OUY+iKiCQsTE+euwYX5IXmkpFbOK3u0yTYGWs7sFux3VWiiaFgRUB9mSJwm0uAZl4tAPpaetfZ319DId85deguRqlUCkaf0dVHgDplphGPG+FAQOrt0s3G9SGLAQrVmdkL8dckpOkRUL5TXMtTLCIbWk5E94yJ6u8IWx3KSrjWhMMZ7jmjqKBQcm99ZLiAdCk+BC6zwBVvq3Af9c4kC0l77Eikxf4K8sFPyu3ZzkIrg6SBsgbh+jdHvTNamG3N8ZA65AfciGqGrswFTi3/MnVoJY1kwg8TQnd+aS/Hr3Dbj8P50LIgc81h6cAdCuYkm6nsPWg0IQmrYF57e8NNcoUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB7126.namprd12.prod.outlook.com (2603:10b6:806:2b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Wed, 22 May
 2024 12:29:41 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7587.035; Wed, 22 May 2024
 12:29:41 +0000
Date: Wed, 22 May 2024 09:29:39 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240522122939.GT20229@nvidia.com>
References: <BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240516143159.0416d6c7.alex.williamson@redhat.com>
 <20240517171117.GB20229@nvidia.com>
 <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240521160714.GJ20229@nvidia.com>
 <20240521102123.7baaf85a.alex.williamson@redhat.com>
 <20240521163400.GK20229@nvidia.com>
 <20240521121945.7f144230.alex.williamson@redhat.com>
 <20240521183745.GP20229@nvidia.com>
 <BN9PR11MB52769E209C5B978C7094A5C08CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB52769E209C5B978C7094A5C08CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL6PEPF00013E10.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB7126:EE_
X-MS-Office365-Filtering-Correlation-Id: 4167d802-ee59-44ac-7fef-08dc7a5adad3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RkFxUUpmN2o1TFZ1N0N2Y3lBdUNMcnd4dlZmMDQrREJLbGk4Sjh5MENmWXpK?=
 =?utf-8?B?YXpWWlNlakRWWS9BNzJQU0t2YjlwNStFWVZYd2Z1aEVzdDZZbDBUSDlWWlEw?=
 =?utf-8?B?TEVaZlpNckJLcXV5aWhEL3hTZUFhcHZ2MlJYSUg5TG9aVFRWUW0yNlhPMlNK?=
 =?utf-8?B?aWR4QmdQd1ZHclp5SHZMU1pOSTdrN0p0VlJZcTNsdHlxaENXWXBlYjdZK21I?=
 =?utf-8?B?eFJabXY5U0Y1YTd6ZGVHVUM0RTk2dmtrODBmb1g2RDA4SVhGR1M4SVFKU0lK?=
 =?utf-8?B?SjRvNXVpYVcyVnhIMTRtQXhsRTUwaU54R1orT0hFeWxIamlRY2dOSlZST0sr?=
 =?utf-8?B?T0wyckdTUjh2RWRKa0xPNHhKTVBhK2NGTjloc2ZFbk8vM21nMVJYRW1CaFFu?=
 =?utf-8?B?ZW9vVUdnM08vT2l6NU5LcHV0YVNiR2hsd0xLRFhPVkZXdW43VnFoMnluK1Nq?=
 =?utf-8?B?dFJTK2xJekdUcUNaL2x4Nk1RdnY2NUdGckJkWVZlSmx1VUhObWhCWFdWWUlE?=
 =?utf-8?B?eDNVWXIzbERYcTZoTlhiTys4c3lSQXJ1QjFsaEFUZkFLQnpYaFIxcnVBSzdk?=
 =?utf-8?B?YXY4SXlHZUFmcFpzeHVFYnBjRm1FbHJFSVpIZ1BtczNwTzd3T3F1SGl4cVJS?=
 =?utf-8?B?QlNsbTdaTXBnVHk0c3ZQR1plNWJncFZXVFpMVDJsai9YckZzclJsT1Mya0h2?=
 =?utf-8?B?aDVtQmZBZCtBL1AzazhEazBRZ2dkekpBWXdJVEpZRy9yMnNUdW5yMXVuejNk?=
 =?utf-8?B?c1VLejdwbUlXT1hXa3cxTHkwaUdqN1RqVnNTZk5BdDlHakRhOFFCK1U4Z2Jz?=
 =?utf-8?B?ZE5pM2p5RDY4Y0dvZDVIWmp0VmQ5SDdHc2lmSy9HQlgxUVY5SGl5T2FuMVZv?=
 =?utf-8?B?TmcvZ0VxOHVZYVRHMlg4T0U5M0hPUDVlYStEZzlxMWY2RGtsRlF4QVdOaTR3?=
 =?utf-8?B?YUp3cHZWaTNzU0p6OUhJa2U2Y1NRcWJEK05aQW5ZYzVhTzJuT3FvcjZ5dnR2?=
 =?utf-8?B?L2VMRjVxS3JISVZ3WnZ5dmt2N1lpT1NVSDdoR2pLREluQWRGakQzZUdoWDRS?=
 =?utf-8?B?OExTWURONmRZV3FFWmNCV1FqYlpRNGZxQ1JXcHVSM2d0bGtuQ0RodUJDVk5M?=
 =?utf-8?B?amlReEhrSjhBWHU0ZVFwNWtBa3JLRXZGeWdCMmE0Wmh0bkpvMGRBTWVDaTZ5?=
 =?utf-8?B?bnJOUjZSRUY1T3J4a0VsaDJqSjZiQ24raFRMMFA1NytITzRnUmQxVlYrQ0o1?=
 =?utf-8?B?LzByK0JWb1I3eHJXRDZ4M2lCU29PTDVIMFFTS0NwMlAyeUpyWlJLK1UvcUdV?=
 =?utf-8?B?Q3dHZ2FHZ3p3bGhXdE9WdHJORWxRdGRpRWhOMjAvODFCVGhiOVpDWlhTVktq?=
 =?utf-8?B?MmtRY2x6YzNpLzRTNDg1YW1xUUVEU3V1STVwbDF6SlRRK3EzdnR4MjVZeVIy?=
 =?utf-8?B?eVBKSlhMZWhEV0Nmb0NHRmZrZUtxaWFBQSsxa3lpbDdXenhBOUhrNDFOSnpL?=
 =?utf-8?B?YjE4cWFyR0NJM3VGNDdEdnVCbzNEVW9XaFV2MUxpT1V1d1FxYlVhT1l3QndC?=
 =?utf-8?B?bkdhMFhXTWppS2xDUGRhSDdrdHczUjZCM0tSd3FUdTdoTGIzc1I1a1lxMmx6?=
 =?utf-8?B?aTdNcStkWm55T1hRWWlOa2IwSjRrTXlkeExVRnFIS3NoUW9lU2w1WTJjSXZu?=
 =?utf-8?B?blB1QVFTZWRnMXFweDhsVzh3SWdMT09zUmU3VWpWTDZjNFNzYnZIT1d3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXRJcXl4c1h1dkdyVVNpTW9lSGFDejdLLzRzVnFOZWZaelgyNHVPMFVDWkFL?=
 =?utf-8?B?bXVJdzlJbFpkKzVtTHBnb3c1RTI0ZzI2eWprOEh4S1ZXRDJkOFlZdDMrREpQ?=
 =?utf-8?B?QjhmVHdiaytvK3kzdmEzZjZDVjgvZjExV3hHSGREL3puYTg5dFB3R1RkMW05?=
 =?utf-8?B?T1BLbWsxaXlGZjZiMnZFU3FGNjBlay9KV2NDQkkzRVRFdGVCMUwyVG9pV0Ur?=
 =?utf-8?B?TFFsa1phVmxZSzlZZ1hzNTB3L0hGM1lidVBvVDBjYVdieWdJMWprdWZsc3Zv?=
 =?utf-8?B?Z2dTS3dIRE5xUGZ4MTUwT2RTR21xSXJTSnVmSHg4TG9mai9jMUpDc2xZMHg0?=
 =?utf-8?B?MnpoakVmVUNjLzl3Zm1rUEp4SWJuNlpOTUY1NURHV3ZyWUtlYThQS0J2Zldx?=
 =?utf-8?B?SmpMNjgrWjRUM216dVQ2OHhoR1pCRWhyWlhKRkh6Z0VuQi9qdVNNU1pzYXlh?=
 =?utf-8?B?ZkZvRGJiL0J0OVBWZE1raHVIQlJWc3JNd2NsTGJFendnTmRBdFpXcGN4cGlH?=
 =?utf-8?B?bHhCL1FDcXlMQnZoWjBVYXdMdllXZVQrKzNvSnMyWUt6dEszZ3pDTStsRGxw?=
 =?utf-8?B?aXFoY0syQ2RVWG8xYVVRdVdiVUlnaWVOWFl5ck9Lb1BkclN3TE1YRTFGWmw1?=
 =?utf-8?B?MHNnaXM1NWt6YXZUVjgxM3ZyNm13ams5cko3UUo2QUs2bFVxeFhOdlRVL3J4?=
 =?utf-8?B?c0MrcEh5Qm40eXkwYzBleEorTmJOYUhDWnhOK0F1Z2ZVNkplV0JCSis4eVFJ?=
 =?utf-8?B?Sm5XcFk5bFdKSVRrTE1tWW9ZQ1VBQm9oc1I1cmdDNkZnTzV0UDJiSHFRTjFP?=
 =?utf-8?B?MGpocFU2SmVKWHBHWm04YUlwMjVYZ0daU0h0elo5QTRCaWlPeGtpbmlEQWsx?=
 =?utf-8?B?bUhObzc2dFZZL1hkU2NsM2ZuZ1Bza3JFZDJkOUNVL1ZvQWx5RGxpTjRqR2ha?=
 =?utf-8?B?YkE2S3JSZXREQWt6WlcwdXk5UzhuVEFVT0NHd0lhUXVRUzFvRHNPZ2YxQ3pX?=
 =?utf-8?B?V3pRTmhRODQ3aXJzajY4UTljRDdvdDQwU25tcDN1R28xU1JHU3Jtd1dtdytF?=
 =?utf-8?B?V0lPZjc4WlI2eVhqdlJETUpsVHJZS2tsUkQ2Z2J5c1gvMHVCcExLYVBpclo0?=
 =?utf-8?B?ZmZhK0V6TFVrUUdJNVBlNjFoOUFZSnB0YmlMaVA0cTNROXpKZHFUbXJldU55?=
 =?utf-8?B?dkM1T0owaWZuUlJyZS9NVkdXTU5md0NSSE5PMWdHMk42VmdlazAzSVJUMmhJ?=
 =?utf-8?B?TnF3WVd4U2xpREQrcFhRVkVqTkJ6VHFJUDVUazE4MEJ3QlRVZWlyWG91M1RK?=
 =?utf-8?B?dnR2dVFkVzhoQU5jNHZvckpQeWxuYS9wM2M4S0hyanptU3ovaEh1N2h2RFF0?=
 =?utf-8?B?RnRKbzdlTHh4OWlZL2RoMUlWWlNQV3M2Yk9HSEYzMlRQOWNsZEN2c2NtNmx0?=
 =?utf-8?B?TUY4cU9xV2J5dVNuYU1mWUtJR2kycGRvOGVSVXY0SEV3MTYvOEluQnljOGxa?=
 =?utf-8?B?cGhXT1FQa3VKampKY3dKaFNSZFBHelpyVEFCbHJaOXVqRmxjL0liY1RkUWQ2?=
 =?utf-8?B?WUdiTUwzU0dJUUVWdmV4MWE2R2RnWXNnM0pYeThkMUF3d1d4OWpwWFVXMlha?=
 =?utf-8?B?MHA4WmN2ckhtRVhuOFJVcThvNGtoeXVjckdLRlNqdHpRRDM1UGJCa1lveVZZ?=
 =?utf-8?B?UDdmc1ZHcU1YbXlQOWZCTTd2aHlIa3RjdVo3UjlvUWY2NXI5Z1ZOMW9NZVhE?=
 =?utf-8?B?Yk5KSEFNQW9zUnhCWDdPNm0zdXNDQjlBMTREelQyZFNQZzc5V3hQVk1PYUpD?=
 =?utf-8?B?dWNTamtPby9xMDlpMkV1VFZBbXB0REVXZm16SDhzaUNDOGxRZGZuNnZjQ3lK?=
 =?utf-8?B?RmVNSFdab2xuNVVWM2FCNk9nZ0UrZ2ZrNzN0eGlQalR6T3BtTko0UWIwZUNU?=
 =?utf-8?B?Nk1KeG92OFhEb2U2aXhjK3p4cmM2a05qYmRlTzRtQkkybjV5SW9aUDhqdWMz?=
 =?utf-8?B?TzBQbUxBSm95ajhUcUphQm1lcnBMV1gvdnQyZUpoTEMzK050ZXFmTVhyOTlH?=
 =?utf-8?B?ekRNbkw0ZzRxbzJtc3hwUDRrWTRhd09tRzIwNTc4WWlyZmtKV2FpZHBuVmFK?=
 =?utf-8?Q?isJ0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4167d802-ee59-44ac-7fef-08dc7a5adad3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 12:29:41.7713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x4JZP/t1c5Vrk4lSq5X3VqWE0L0BV8DVsZq6Epl9TTiGb2ixsz2V1C4/Mi1RaLvP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7126

On Wed, May 22, 2024 at 06:24:14AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, May 22, 2024 2:38 AM
> > 
> > On Tue, May 21, 2024 at 12:19:45PM -0600, Alex Williamson wrote:
> > > > I'm OK with this. If devices are insecure then they need quirks in
> > > > vfio to disclose their problems, we shouldn't punish everyone who
> > > > followed the spec because of some bad actors.
> > > >
> > > > But more broadly in a security engineered environment we can trust the
> > > > no-snoop bit to work properly.
> > >
> > >  The spec has an interesting requirement on devices sending no-snoop
> > >  transactions anyway (regarding PCI_EXP_DEVCTL_NOSNOOP_EN):
> > >
> > >  "Even when this bit is Set, a Function is only permitted to Set the No
> > >   Snoop attribute on a transaction when it can guarantee that the
> > >   address of the transaction is not stored in any cache in the system."
> > >
> > > I wouldn't think the function itself has such visibility and it would
> > > leave the problem of reestablishing coherency to the driver, but am I
> > > overlooking something that implicitly makes this safe?
> > 
> > I think it is just bad spec language! People are clearly using
> > no-snoop on cachable memory today. The authors must have had some
> > other usage in mind than what the industry actually did.
> 
> sure no-snoop can be used on cacheable memory but then the driver
> needs to flush the cache before triggering the no-snoop DMA so it
> still meets the spec "the address of the transaction is not stored
> in any cache in the system".

Flush does not mean evict.. The way I read the above it is trying to
say the driver must map all the memory non-cachable to ensure it never
gets pulled into a cache in the first place.

> > Maybe not entire, but as an additional step to reduce the cost of
> > this. ARM would like this for instance.
> 
> I searched PCI_EXP_DEVCTL_NOSNOOP_EN but surprisingly it's not
> touched by i915 driver. sort of suggesting that Intel GPU doesn't follow
> the spec to honor that bit...

Or the BIOS turns it on and the OS just leaves it..

> I'm fine to do a special check in the attach path to enable the flush
> only for Intel GPU.

We already effectively do this already by checking the domain
capabilities. Only the Intel GPU will have a non-coherent domain.

> or alternatively could ARM SMMU driver implement
> @enforce_cache_coherency by disabling PCI nosnoop cap when
> the SMMU itself cannot force snoop? Then VFIO/IOMMUFD could
> still check enforce_cache_coherency generally to apply the cache
> flush trick... 😊

I like this a lot less than having vfio understand it..

Jason

