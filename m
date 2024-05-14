Return-Path: <kvm+bounces-17393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 120738C5DAC
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 00:41:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 606231F21DFB
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 22:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 022EE182C84;
	Tue, 14 May 2024 22:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JIrExEFh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D79C1DDEE;
	Tue, 14 May 2024 22:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715726481; cv=fail; b=tMYYuLQ8W6zI2PuKiWzP0384nAMkv+0Mj1dRcOUeReY3I3fxFfSsQRAKbEEojiJrfRy5b0gnwLb3gYnGR3cWIaTxpx6dUx++a2kwqXK2Gzn3ZpazNTliYRI//5cXSgRYAJq155hlvbYui6o9bAvihbK13jL9jOp8dfC5p21tco0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715726481; c=relaxed/simple;
	bh=CjkDDz0RBIUn4W0bHwFdfswIU2CqvszVB8IkCZimRVU=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qNUxAy4+UciJaJlC5AhWs4vASTJj7sbZ03Bk3P76MyHDuHl+r2xJimA/7dwvrlrLJ1JBWYCTHEtwbEDKBAFhP8+7Bg5MvzYCtFIyuzfhou8iOBsPutabHqsQu4Swjz+llQthlmYNk1afmaOMmNhErOMObdgYv34gFGFxVZl/NSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JIrExEFh; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715726479; x=1747262479;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CjkDDz0RBIUn4W0bHwFdfswIU2CqvszVB8IkCZimRVU=;
  b=JIrExEFhMJMV/YAXGAGLAWV36kCrJqucqEMrVznpsPoSVufXcbxNK1E2
   FJFrXtBCOdBK4/tINcsOZ6Dc4XU2Fh8p/M98qwGZpWTW+Q6U5VV/PV7za
   QxQCiLHYJ4ACIwxYDxgIIkJEpzFzSoq8FvVNnfXBGD8RFM1t9b/bbeJqG
   eG8vWbp4Ik8xfAyPUckFTfmgxBmiXO3hAlB7LXoBfKfBXD6QfUor7yC1T
   ARnZBOeh4b8BtTzwUOgtnTtaV4oQ/3U+XO1T8ivKWM0agURP41LeGSCPp
   H2EbzlgagiYphvtW0D73GbUIrLYusJxxazUU2D14WLbf/S1GOqtNB9jWu
   Q==;
X-CSE-ConnectionGUID: 9nZT7fuLStms3MbZUFmn1w==
X-CSE-MsgGUID: iiRYVgH6TtedxPa40xQPrA==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="15533901"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="15533901"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 15:41:19 -0700
X-CSE-ConnectionGUID: 9iQr7cWqSl6f74/zuBn5+Q==
X-CSE-MsgGUID: zguZMq/wROGhIj6+9gJiGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="30826366"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 May 2024 15:41:19 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 14 May 2024 15:41:18 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 14 May 2024 15:41:18 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 14 May 2024 15:41:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmORLC+tfXMgNepz73xPM7gp+QwzMELiC4+O7wHQrNx1xQeCIxH8PxctB8062y+h1i+YMA01OxBS5avQ0Q8D4yNBGvM3KdTnSTb0VNVyz8hnCoMMhERX7GmZZfJFyz768EBnYOehrYXosoz83xKci/aqDSs+xhi+ytzXRDbx2lJHw0EC5y8TDZxY/lxZCGBcUhOsmX12zLNjjpGCkvwHpyRSgZGasNd1/j4wStsL8R5Qcihn9x740yGoegbSSLdZDCqVD/qutsQn09JRXuDEQgi+fphZr72q33nwLCdGAzbwEdPWW5HEQJ647iPfpL6WAfhFoj4RLIzwQ/Qchmxnhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hd+s8pq5MHG/WBi3MPkY1f0Chzpu0thXMDfE7hYzYYQ=;
 b=kkrZLjULy0v7u+DBTIDlMvHNPmLWYiawTDNHWF4LgACR4mbH0pREk35leNOdFsMMTT2XM2bCj92GWUZqQxCIA/ZMx8Tkgbfl5wi3piqPov5HlxF66wIfUZkuNDTxAIS8OSCoqTB9Z+abY6wSvMQoKevanVtk4zecH8pB+4QLgYLGgsEYbK20+efBQAchFQy1eAXdT7uRbXAWqMxqDC/2URbYRK3mAhIvz01u3oyn8h7tMHMa23HCnO3Eh3vpuVwcgj9YDdX5/x58m8EHCf/OkR0zzWr4EERUp0vEM1EfqePCy4XM8lIXQZ+SMWqLPReu2GU19k4Zyw6RjOv1P2H1XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4949.namprd11.prod.outlook.com (2603:10b6:510:31::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 22:41:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 22:41:14 +0000
Message-ID: <1dbb09c5-35c7-49b9-8c6f-24b532511f0b@intel.com>
Date: Wed, 15 May 2024 10:41:07 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] x86/reboot: Unconditionally define
 cpu_emergency_virt_cb typedef
From: "Huang, Kai" <kai.huang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <20240425233951.3344485-1-seanjc@google.com>
 <20240425233951.3344485-2-seanjc@google.com>
 <5dfc9eb860a587d1864371874bbf267fa0aa7922.camel@intel.com>
 <ZkI5WApAR6iqCgil@google.com>
 <6100e822-378b-422e-8ff8-f41b19785eea@intel.com>
Content-Language: en-US
In-Reply-To: <6100e822-378b-422e-8ff8-f41b19785eea@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW2PR16CA0062.namprd16.prod.outlook.com
 (2603:10b6:907:1::39) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB4949:EE_
X-MS-Office365-Filtering-Correlation-Id: 84ebba5a-2b9e-497f-389d-08dc7466f5b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VUQ5TmhVMENHc2Jzcm1Db2hDT2c4TURLdnRpZk82SUNnUXdtZzVrdUhzWFFC?=
 =?utf-8?B?RXRmV0c1dS81eFB6T01vZ0lmSWVySDdvUzNLaDd5NDhRZEw2d2labWxxTUI1?=
 =?utf-8?B?ZjFvVzVuV0pZeUwzbmd2YXUzZDlLekM4dERNR3VZRElxdWxZZVVFU3U3M3hE?=
 =?utf-8?B?dm1Lc3RoNmIxTmZGVE9FTkpTSjNJbkNCOUNyR2pBNytSajdIUEx4MkFkWDB3?=
 =?utf-8?B?M2JLcEJ5dXl6d2FnOC9rK3NhNVJoalYxM3hIemU4dlJ0RUdrREZ6Qlh0T2Jt?=
 =?utf-8?B?dXRqUVRpVTI3OURFSVVmZDZ6Y0ZGSjJPZzd0a3R0RktGa3BlNGR2NUtXMVU4?=
 =?utf-8?B?ZjNwT1gwemtXWTlvUldINGphTkgrV2ZMd0laL3cxOXRjN0VOdDlCOE9rZ21l?=
 =?utf-8?B?U3R4cnYvOXY0YWExM2lxQzZDRGxad2l3V1hMVUxIREk2RFNyZHJueE13QUts?=
 =?utf-8?B?cWxuVXg0UmY0K1hxdEEyL0ZHVkNJWjRKcDRjOXJQVHI0RG9jUXFXUG5JbjYr?=
 =?utf-8?B?NWpoOVlLTzBza25DbmM0OVNNeWRMSlBwVXdnUXFrMGdWYWNaeVdsZnVOeEpD?=
 =?utf-8?B?a1crTEdTODJBZHVqUi9BU3JMcGpETW1jZ3FybWtTYVR4cWpWWGFpN1N5Znlh?=
 =?utf-8?B?SzdWUko5ZE9DVmR2eXhvVkpZZlNobnhid0N5bzJ0bUh5UW9lZURiN1lyMDNs?=
 =?utf-8?B?ZjZWbXV1UnIyNWhKdUxkUC9wSDdJalprcjlrNE02TWlyQzVBRXhIb2VKWG1F?=
 =?utf-8?B?TEk5SHFnTSttNkN0RE5CVnQ2YkdKRHRlUmREOVN1a1pmZGdxS0ZtekRKRGw3?=
 =?utf-8?B?U1ZpR2ZvbmdVendKWVp5ODdkbGJGRVo1WXo4N0h3WFJ5bkllb1VtaG01UFRk?=
 =?utf-8?B?cXJUSE53UlRmSGU4Qmh5QXR5M0wrWmpYelBycVFIYUxCK0M0QkRXU3FRcG1T?=
 =?utf-8?B?Tm82OUNKT204TjVmUUk0aWRnZEF1TVk2d21oN2pPRHJMYmhnSG9uc0piVTRJ?=
 =?utf-8?B?a3lCU29RYTFJQ1MxTzhqd3lNYmEreUM3VThhUFlvSXQyL2xVN0NaVzI4elJ2?=
 =?utf-8?B?KzJpTmRYdGhpKysweTJMMjRhWnA0WDZRUFhYWXFjQTJJb1F4SVM2NU93YjdL?=
 =?utf-8?B?OCtFUlEyRmZCa1cyOXk0cm1URGxIb2wvQXBkRTFjZUdveEN1YXdzZ2FSa1VB?=
 =?utf-8?B?cHo0WUxPQnY5UFpNVTk1RTBoV1BqVkc2c2o3TmJSMDlTTjQrNVM0dDkrR2M2?=
 =?utf-8?B?Z3FHS2RYSlhOSGdwSG5sbkx2MWlsQVd4THBWRGlmN1hFSFJsd0srUnZFOFBP?=
 =?utf-8?B?YUpmYVZuVkdVT01iSkh4M2VMaXBsUXV6RlNWNW0zd0E1TUVDOE1JdjNqaVM0?=
 =?utf-8?B?cG5sSFd2emdnZDZzdlZGV3Z0VFN4M3pYL1pSK0RTRVQ0UzNhZkZtMUtqYnd5?=
 =?utf-8?B?NG1Zb1RqbUVodW9pR3pwVjBSTVJtdHMwV0toTkE5ZEtSQm9hR0FyNnlnTjNj?=
 =?utf-8?B?Mk1rMTJEbTdvR0dyOUZySlJSckk5Wm1zbGU0R3hSYXRnbmR0V2NpRkZyc3R2?=
 =?utf-8?B?QWpQRy9XcHVjbVhOKytmTGFha2QxOU9NRFladmNXazFqbjcySXNUN2RBYmVX?=
 =?utf-8?B?SVVTbVFDczh5MEEyWTArWnJCZ3BMaEJtNDZ5VzdpNHBSYXdEemdDN09PMVlK?=
 =?utf-8?B?cnR3UlNVd01XZnNQMEFnOWNDMnB6WHZDRFBmS3Y3aE1qTFF0NjFzQ0tRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmNNc1RBZTc3amlSWVNIZUk0ZVJhMThjdTd5bmhwN3FGNGM2SFF6dU1kMzBp?=
 =?utf-8?B?NEtZMzBPT1NTWFBLQW1rcDFpTkdZa2JVSzJUWnIzZHlFV1RCU0Rlcy9BTWFS?=
 =?utf-8?B?dExMR1RQNHpXZUZWdWgrWGtSOHorTkltWTBWZ2ptY3hQalZrZmlablpwbVAw?=
 =?utf-8?B?UHdYRGdzNlBTaWkzYktwU2p6cEFnQkhsWlk1OWpBQnJxc2lTeGZtSDNDWnFB?=
 =?utf-8?B?OWhaUHlUZmh5dk5LQUEzczJOQk1Sbk4yNTQxczRKUmpxMGNxelFsNHZTczVK?=
 =?utf-8?B?WEl3Y3UweUpTVjNMZlpqaFA0dHR4ODgrR0I3U0VqZXlweGc3cUlVMk81NEJk?=
 =?utf-8?B?RzdYUm9qWElNa3piMk5sTTNZOEpWV3lZTzNVK3BycXlhMVpsekgzY2h2eWoy?=
 =?utf-8?B?VnV5UHpXMXhIQkFhczZDL00ySnAvWnVPc2Q0TzhUbXNYemN4bGRkbU9la21a?=
 =?utf-8?B?RVpSR0U3K3hEbzZsYXBhK0dZQ25NbXJCTUFKODZldXVMakFrc2xoN05OT2Zu?=
 =?utf-8?B?dzdTMFFlaUpLSi9YSGxoakJnMEI3d2VGbVpUZE1xd1RGeC85cDZKMTd5b3Zp?=
 =?utf-8?B?V1pLTlVMMU1JbUVEditKZzMzMmZTTFh0L0c0KzdWM1BRdlZQVU91U2d6MFd2?=
 =?utf-8?B?MWJCdHJCeVkzdmdoUHg4dWllU0JBZU5TRnIybU9zTlJBNWZtZUhxWEE4WVNj?=
 =?utf-8?B?VWpHNUlPdTd1ejFxY1JaVUZ2NVF5OG9vNXNacXpiY2I3WGx2ekFneXFDdEsr?=
 =?utf-8?B?VTdORFhQVHViOEN2VkdsWll1VktvTFc3cytwekJpRVJSNWpDakt4UE5HbGUr?=
 =?utf-8?B?MGNFemhlMVJqcVNaSjVvNTJvU3lGL2lTdHFlNHJYZmI4RDlHaFpYd2hvQUtY?=
 =?utf-8?B?cVdTMHhGc1phMmdMalRSU05Gczg4bEgrN1FBVDJSeUtrSU1HSGsrazBTaFRZ?=
 =?utf-8?B?Y05RUjVWMVo1dFZiL0VjRVBpWDJHZWVYeGcybS9mSThCNlllSDA2SlVMY2po?=
 =?utf-8?B?bDF1NVhNdElGRVJHMVNwOUNNdklzaEFwTmovdStiVmxZaHBqc3g1Mm80RlUy?=
 =?utf-8?B?RDFVTzBXeWd0SnhrbElVVEpXUThRTEtXMDRXcGxkU0tKamcvdUVHMjZmQzN2?=
 =?utf-8?B?cFEvTjVpS0xsUVc0MU54aUExNFN2UzJSV2V3OXVESDVIWWJ1ZnZjN0Z3Ri82?=
 =?utf-8?B?TGlZd0FMWndNalZaS1ZCME5SUzRYNmhqckE5bEpVS2FOWmxORDZUSEN3T0I1?=
 =?utf-8?B?S3NuQlhVbHlNMjV6UTEzcVo5eEJEWUl4cUI4WThSdFh5TnI5T1lQbHNSNEw2?=
 =?utf-8?B?ZDZDOXJKZ0lsMHhEalRpS0RIeVdmY2l2dUUwQmgzWjJPZU9jeWtuTTN2QnlE?=
 =?utf-8?B?YVdmSnRld2Q1eUlOSHZVQWVtWDZTL0drenFYNko4aDd2RVhIODF4eWl1L0pK?=
 =?utf-8?B?UkJRWjJhV3NZWmVTUUhiWm5qbkErOEc4NVMyS1poTnI3R3dsUWZXa0lEQzB0?=
 =?utf-8?B?aWpWZ2x1azNTRWJwWGZqVHhBaWFlVnBKblBYKzFyUzJFeTQ3N2poTDNQeFdy?=
 =?utf-8?B?b0x4T3BwWkJIS1o1blAyWXNiTldIbGNYQlFGSjc4YUgrWVM2elpzNFEyUE04?=
 =?utf-8?B?MEx1VDRNWXV3aHBRNk9QUjlOSzdOTWhLQlZybC9MUDN1YWh0Sk05Mm9YVE84?=
 =?utf-8?B?N2ZQRURmNzZtTzRtalFhbXpjTFJHMzc2U1RjaDc0Wkl5UFY0MEFscnVtbHBK?=
 =?utf-8?B?ekx2YmFmVGhFd0lGNEhuV2h3cFRUeXdSckhpTHBaT1RPTkw1SEFDUGdENDBF?=
 =?utf-8?B?YjBUVi8rUGFDRkJ0VU90OUhYeDhEQXBPdmZqNWVRTWZJQ2R0Y1NPQm5pUkZV?=
 =?utf-8?B?TzVpeFg1TDB1UmhiNDRVOGtYcXlnQlFtaDdBcWZhUzlOeGdnc2phcHhtY3hR?=
 =?utf-8?B?NlI5ek1PblVLNkRyN24rNlJkYTdKdWhtUkFBaTZMNHhNc1N1MmFZM09WTGVr?=
 =?utf-8?B?WTNSNllDaXh5WnlMUW5kK2R1QUpFMGF5VXpOSU5nUDhDNVhZdmo3RFlrb1Zi?=
 =?utf-8?B?UVJwSUI2YW0rdFBid0xjSWw5cHc0UHhPWUdJWGY1YjY3cUFlSGYzcHRzVDhF?=
 =?utf-8?Q?lpK6yerROyAp2qOMmFib6k7mk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ebba5a-2b9e-497f-389d-08dc7466f5b9
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 22:41:13.9352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u33p1PNVBbLPYtGogRohtiut8OlsURN695cVqGHwCh5ajojmhEd6lT2M4iPZhnFNTIt1av8tz99bNgWIdCQ6RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4949
X-OriginatorOrg: intel.com



On 14/05/2024 10:44 am, Huang, Kai wrote:
> 
> 
> On 14/05/2024 4:01 am, Sean Christopherson wrote:
>> On Mon, May 13, 2024, Kai Huang wrote:
>>> On Thu, 2024-04-25 at 16:39 -0700, Sean Christopherson wrote:
>>>> Define cpu_emergency_virt_cb even if the kernel is being built 
>>>> without KVM
>>>> support so that KVM can reference the typedef in asm/kvm_host.h without
>>>> needing yet more #ifdefs.
>>>>
>>>> No functional change intended.
>>>>
>>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>>> ---
>>>>   arch/x86/include/asm/reboot.h | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/reboot.h 
>>>> b/arch/x86/include/asm/reboot.h
>>>> index 6536873f8fc0..d0ef2a678d66 100644
>>>> --- a/arch/x86/include/asm/reboot.h
>>>> +++ b/arch/x86/include/asm/reboot.h
>>>> @@ -25,8 +25,8 @@ void __noreturn machine_real_restart(unsigned int 
>>>> type);
>>>>   #define MRR_BIOS    0
>>>>   #define MRR_APM        1
>>>> -#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
>>>>   typedef void (cpu_emergency_virt_cb)(void);
>>>> +#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
>>>>   void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb 
>>>> *callback);
>>>>   void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb 
>>>> *callback);
>>>>   void cpu_emergency_disable_virtualization(void);
>>>
>>> It looks a little it weird.  If other file wants to include
>>> <asm/kvm_host.h> (directly or via <linux/kvm_host.h>) unconditionally 
>>> then
>>> in general I think <asm/kvm_host.h> or <linux/kvm_host.h> should
>>> have something like:
>>>
>>>     #ifdef CONFIG_KVM
>>>
>>>     void func(void);
>>>     ...
>>>
>>>     #else
>>>
>>>     static inline void func(void) {}
>>>
>>>     #endif
>>>
>>> But it seems neither <asm/kvm_host.h> nor <linux/kvm_host.h> has this
>>> pattern.
>>>
>>> I tried to build with !CONFIG_KVM with patch 2 in this series, and I got
>>> below error:
>>
>> Well, yeah.
>>
>>> In file included from ./include/linux/kvm_host.h:45,
>>>                   from arch/x86/events/intel/core.c:17:
>>> ./arch/x86/include/asm/kvm_host.h:1617:9: error: unknown type name
>>> ‘cpu_emergency_virt_cb’
>>>   1617 |         cpu_emergency_virt_cb *emergency_disable;
>>>        |         ^~~~~~~~~~~~~~~~~~~~~
>>>
>>>
>>> Looking at the code, it seems it is because intel_guest_get_msrs() needs
>>> 'struct kvm_pmu' (e.g., it accesses the members of 'struct 
>>> kvm_pmu').  But
>>> it doesn't look the relevant code should be compiled when !CONFIG_KVM.
>>>
>>> So looks a better way is to explicitly use #ifdef CONFIG_KVM around the
>>> relevant code in the arch/x86/events/intel/core.c?
>>
>> Eh, there's no right or wrong way to handle code that is conditionally 
>> compiled.
>> There are always tradeoffs and pros/cons, e.g. the number of #ifdefs, 
>> the amount
>> of effective code validation for all configs, readability, etc.
>>
>> E.g. if there is only one user of a function that conditionally 
>> exists, then
>> having the caller handle the situation might be cleaner.  But if there 
>> are
>> multiple callers, then providing a stub is usually preferable.
> 
> Yeah.
> 
>>
>> IMO, the real problem is that perf pokes into KVM _at all_.  Same for 
>> VFIO.
>> The perf usage is especially egregious, as there is zero reason perf 
>> should need
>> KVM internals[1].  VFIO requires a bit more effort, but I'm fairly 
>> confident that
>> Jason's file-based approach[2] will yield clean, robust code that 
>> minimizes the
>> number of #ifdefs required.
>>
>> I'm planning/hoping to get back to that series in the next few weeks.  
>> As for
>> this small series, I prefer to unconditionally define the typedef, as 
>> it requires
>> no additional #ifdefs, and there are no meaningful downsides to 
>> letting the
>> typedef exist for all kernel builds.
> 
> Seems the final target is to remove those <linux/kvm_host.h> users, or I 
> think a safe-once-for-all solution is to provide the stubs in 
> <linux/kvm_host.h> with:
> 
>      #ifdef CONFIG_KVM
>      ...
>      #else
>      #endif
> 
> In either way, my concerns is it seems modifying the <asm/reboot.h> is a 
> temporary workaround.  And when we reach the final solution I suppose we 
> will need to revert it back to the current way?
> 
> If so, how about manually add a temporary typedef in <asm/kvm_host.h> 
> for now?
> 
>      #ifndef CONFIG_KVM
>      typedef void (cpu_emergency_virt_cb)(void);
>      #endif
> 
> Yes it's ugly, but it's KVM self-contained, and can be removed when ready.
> 
> Anyway, just my 2 cents.
> 

A second thought:

How about we just make all emergency virtualization disable code 
unconditional but not guided by CONFIG_KVM_INTEL || CONFIG_KVM_AMD, 
i.e., revert commit

    261cd5ed934e ("x86/reboot: Expose VMCS crash hooks if and only if 
KVM_{INTEL,AMD} is enabled")

It makes sense anyway from the perspective that it allows the 
out-of-tree kernel module hypervisor to use this mechanism w/o needing 
to have the kernel built with KVM enabled in Kconfig.  Otherwise, 
strictly speaking, IIUC, the kernel won't be able to support out-of-tree 
module hypervisor as there's no other way the module can intercept 
emergency reboot.

This approach avoids the weirdness of the unconditional define for only 
cpu_emergency_virt_cb.



