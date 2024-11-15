Return-Path: <kvm+bounces-31935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 120E39CDE07
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 13:06:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9698E1F22C97
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 12:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 342051B6CE0;
	Fri, 15 Nov 2024 12:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NaLxg3xL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B92618FDB1
	for <kvm@vger.kernel.org>; Fri, 15 Nov 2024 12:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731672370; cv=fail; b=Og9E8xDa5GE/D3ecvwyfYY/cJLMrHSzqSWPyD1BrRolDr9/RtzcjsTWekO9rGghQkAeS+gwSCi5vODxuqH2Z39Bh0fX0yNCKy2Ytvxqy0SJk3aj665WvI8xDGJJuquBvjkYUFElWA7xoCLu61VzZmYiOrWYGo2HAMlzPLTN0EJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731672370; c=relaxed/simple;
	bh=Sac3EysSFS3imFalKl/8UiIqXcNGlQubQm2lEYDYXdY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c5uBODNo+8u1moqmiDQ9HuodolemQUxfNB22LKlkVoeT2ylF1tmcpZQ5SbHUgfrBa1Fvlq1OooHmzvZP93CPCMB3OXw2mpKdGAhrHaHNFzGgv5iRrVItOp4tFkKc9FwPM0oW04S3Skt655obHG7EmMMFm5h224maCrxEhJQ0T78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NaLxg3xL; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731672369; x=1763208369;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sac3EysSFS3imFalKl/8UiIqXcNGlQubQm2lEYDYXdY=;
  b=NaLxg3xL4ewLLkjMo3JLAVuTGCnII5IYpnWrfXb+iGmFabbxka7LuU+w
   HGhFbCYfjT9FvTMkHPg6CeHRk7k742h2m0KN+vsbPYr+aGyHHxqVa71Cm
   PAVoxe7HzgCRD9lqnOZSQE8p8SV9JlRC/nAHIXDKntkdQBC0jL5+YHKlX
   qZhp6dxKyKD5ALwy/z4qEhlV/aVlPzpDuskL6gfH9yLs8XUt+LRtSc9Oh
   04IIrykNhuBQFqzZcgQrCvXzAuhNGTUb4OWdXet3vN7AF07nc1axU7wxI
   Q1r78JYN3zi2KGH5v7ErrYT1Xi2/G5B+meZ1HReisUuah6nOAmsoe/kQM
   g==;
X-CSE-ConnectionGUID: 8Xy0cEvvTo2/w1pVgGvz8Q==
X-CSE-MsgGUID: hejQpEWyRJmzt46LRdLXfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11256"; a="31517480"
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="31517480"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 04:06:08 -0800
X-CSE-ConnectionGUID: X/S0QU0hTq+A9vTeDTiSuw==
X-CSE-MsgGUID: W6e5FJJCSZqQy+BFm4BIKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="93559168"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2024 04:06:08 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 15 Nov 2024 04:06:07 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 15 Nov 2024 04:06:07 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 15 Nov 2024 04:06:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DnAuj/8WbhM6uulwUap0z6uc9MnYFanr7MQn1bVslX23r0YcHW+Qv64OD71QyOpTNEndkEPfQhj3TK7x9/WyojaR9AZlhV2VdKZjbO4NaoR9GS7dD7KopzuoC9t/cH83X93DiBP1WSbRyYmlmnTPTn4dOt7C7orBIqG/K4IoPyxRiBHPQuX5/NwNfSvdnJ+TyBTec8UEqdhUNwLVbFKHBFmSJVhgZgZMOPmdZLBLOlTwOQeJNh7k3nj7MSPuAebB4kyvfX7yaxE4I+Z0J/x8gO2+QY7rGaBv6iNazIn62MOUHVl8XUoIih+mwbCYzWM9ONPRM4MjKv/QHXQigdMfSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dTchB/KmalQwRtJYa6jKEWj3HIRh57COIcTNPzUjQkc=;
 b=MX1n6tKRgS2sNcG0ErpiVa6QCcyrKTSMhLizTFK43cu9waniZjcYFxUMretFguOrbxPHHylzx8bm3Tv8Xz+wx3XACHRc4b4cltvNczE0VozMv+L6JXRkLpf8gHbrWKbWUT1MmV8hCcHa8M7VxPqo2HihhMInWZkINRnIkV2LtQSFkUhlnXFdA/JyqxVd5VI7BBrm4DpDLqzmNm9QEUBqOvkNIOjOFSUXeyTrp1EsMlRUny7p+71IJVTXUh24qizbhr5tYPNpR+m0YyKtt+3xjN8J/NQQguPJzuuxEaWU79WTCjNsVf5zo41yybYCFnmiKxC5ctR+HIkYc3xgd1crRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7558.namprd11.prod.outlook.com (2603:10b6:8:148::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.19; Fri, 15 Nov
 2024 12:06:04 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 12:06:04 +0000
Message-ID: <43439d7b-22a0-4bc5-8311-3a8e87c7fca4@intel.com>
Date: Fri, 15 Nov 2024 20:10:37 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] vfio: Add vfio_copy_user_data()
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<joro@8bytes.org>, <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
	<kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>,
	<will@kernel.org>
References: <20241108121742.18889-1-yi.l.liu@intel.com>
 <20241108121742.18889-5-yi.l.liu@intel.com>
 <20241111170308.0a14160f.alex.williamson@redhat.com>
 <9d88a9b9-eeb5-49e5-9c59-e3b82336f3a6@intel.com>
 <20241112065253.6c9a38ac.alex.williamson@redhat.com>
 <7808f8da-8932-486d-8d47-10a95bc5002d@intel.com>
 <20241114111958.7f6c64a8.alex.williamson@redhat.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241114111958.7f6c64a8.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0020.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::6) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB7558:EE_
X-MS-Office365-Filtering-Correlation-Id: bdd82556-0064-4c96-04d9-08dd056de0f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K0NYUWZpNWd2Sm5sOVV5U29PbDlqYnZWZytMT25zMHA5Q2hseWZLVDRvbElS?=
 =?utf-8?B?QUFiblhuTDZ2dlY3TUJ6MXZnT29HY2cwdEFsYVZ4T2tFbkJOY2Y1WHhGR1ZL?=
 =?utf-8?B?N2ZlWS9vcFU5TmNlR3VVMmpZcUtSQW9XZW5URU1xY3hrbFNuREFLZXV0dU1m?=
 =?utf-8?B?cVF4TnhPL2tjVXJaKy8vSjZ0Y0NNeTR1RVQrQzhqSjZqNkJZMTNLemJKOG0x?=
 =?utf-8?B?bW5IU3RWaGhCMU0zZGtxR0JhYTY0V3FFUWhGTXcwdFZrVHZ4Y3dDbVMrdFpt?=
 =?utf-8?B?NHdudE1FeUVPWk1xK3B1VEpyNE55MlFMZ0xRYkFuUXg0Rk0vbzBtUUhLOEdS?=
 =?utf-8?B?TEQ3TFY1YzBkdEsxZGhyVmxPVjZkbDYrblNqUGtIMnRYVTVoOHYyQjNtZWFt?=
 =?utf-8?B?aG50eDdrYjN0S084d2h1RDFqcVNyaXg2UHFSY05PTjNLdnhzM28zbFJZcTBZ?=
 =?utf-8?B?ajRFRUFkaGJOUGlOb1dLeElIYU5uZDJyWWdycDZ5NWR2U0VwWGpxdHdoNFla?=
 =?utf-8?B?LzM0djMrRUk5TjVPemJmYS91RHJRMTUzdWQ2UXJvNXpQcmNZY2NLSVhKLzRZ?=
 =?utf-8?B?ZGN2S2M3T2t2QW1CUUo2RnhSWXBleEh0TENKR2NWVTFyRjJXZ2YzWXpOSEl6?=
 =?utf-8?B?UEU1VFBDTFp3R0FrLzZGYkxmYlo2VVRKQXdJTjV0OHV2cXA4VVVkaWRJRnZs?=
 =?utf-8?B?b3lselY1REdPS3FibExZWVhaTlJMZHVLMHdIc2hobHJKT0ZjeHlOdktxbVo3?=
 =?utf-8?B?MWRUUktHeDhVYkZINnJBVWxsdTJIbmEwRENLVW40OThyZlRuMHJLWE5ZZjVq?=
 =?utf-8?B?UHNYcUx6NkdMaG5YTDZSODRRcUNFRU1nR1ZpVVlqZ2tMTjJzL2lBWkZsekNu?=
 =?utf-8?B?YWwrMWpCa2RyRklxcGRWK00yM2g5VHVuM0Q2WTRwS3FkQkJYV1BtVm91V3dr?=
 =?utf-8?B?aE15ZDBnRWVOeWprM2N6QURBTWtTckNEejlwQnNEU1ZnWXVYejBrWklYazd6?=
 =?utf-8?B?aEowTE5xYWFEK0VFVzl5VzYyUER3WFFFM3dIMzRHMTdvWVpkM2UrTDBhYk9X?=
 =?utf-8?B?T0JYaWdTR01JUEtod2pkVmRQbm9WTXVpWHI4cldVQU1BK0NHVWNyM040NGY4?=
 =?utf-8?B?UEpOcHBMK0RLVkZUeEVKd1dCcElxMSs2ZU1QODZOeGlpeFBDUThIWE91VzJ3?=
 =?utf-8?B?cDd0WFFKZlhGUmtZWTljU0dXZGk0akppemFpcThqcU4wTVQ3WmdPQXFTakdq?=
 =?utf-8?B?WWN3V0twS2xoQzVkQ29OWDVnUm9GZzljSzVkQURkbDgvT0pVWkF1ZlBlS3NW?=
 =?utf-8?B?Z3BqV0t4d1BKcDcwTHhRaUJCclZROFVkV1E0OXNrbmNKSmtSdWUrczh3MnZR?=
 =?utf-8?B?VkY2TmM3OVBQbk1PQTRDbkZnbXlTK3R1eUxtTGo5WlhWeFRuelp6Z0MxVnpI?=
 =?utf-8?B?SXJVZVArRDFzZnA3dUh0VENGQWhnTDNlbVp1Z2VnVXI3bGhJWnZuaWdGdG5K?=
 =?utf-8?B?QURKQWE4OExVMHVjZSs5K2lRVG1yVFROL2d3K1BkRXc1TUpjWFVOTUpRNllZ?=
 =?utf-8?B?NVBOcklRTDFBTFhiRkcwc0l4d2hyR2lzTG9Ic3p1ZGNyTHJSdUR2OHdRSkJW?=
 =?utf-8?B?N1VZcGI3NEpDTkl6M0kwaUZ6NjhGVklvRElDb0pEWVUxNzFKTUh1dENMcVJN?=
 =?utf-8?B?bDl5eHphdHV3WWtYeklSUW9RWG4yQ2VOMmFLemd3dTVnV3g0bXRsZi81KytI?=
 =?utf-8?Q?2fzED341vK/RUxHVjTtqOySzzu7xcl52PdvFV/o?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFlUYy8wZUlhR1FmSFZMMEF5cmZubnRQdkp5NHhzNlRqdUd2U1hFSlZGMjRz?=
 =?utf-8?B?NXJzMEdQM0lBQk15blhTSTBEL1g0MVE0b3FMd3FJQ2c5Q0lFUUx2QVE1QmJR?=
 =?utf-8?B?QTZWVVczTmorQnBFVGxzZTZsMi85V3NyNzNDbUJ5KytZUExuTStyOXNud2tN?=
 =?utf-8?B?cjNabVk0RDBFWWFWRzVFYVAyejhvaFRNc20rY2VXMnVtK1Z2MTBacG9XTnB3?=
 =?utf-8?B?SndOOU5Sdkc1b0o5cDRhZjZ1akVrZnI5VGQxdnhVQlJrRjZIcHpaSWcwRjFh?=
 =?utf-8?B?U0dsL0xoVDR2Yll0YktWYms3QU9BU1NMSFV1N25mMW42ZmNvaHhReWp5S1p1?=
 =?utf-8?B?MHl3ci94c0k5U2xLb25adUlPNFloUjl5Q241N0Rhd0VDWm5QYTJCbjVxa0Fq?=
 =?utf-8?B?NjR4WkMwM1VieUttZGllNy8rQlhZcWwraklmODB4M2pFckdtOGNjR1h0cEp2?=
 =?utf-8?B?Y0pVSlUwQVJSaUxMR1A5MjdFWldkb1NHVldTbXFTQXJzZnIvZkFmUE5wWUdV?=
 =?utf-8?B?aUptamU4MDVVWU1XRTFSQ1ZSb09kMDMyQ3J4TUZWVTRnRURYeEhMTDZHOGtn?=
 =?utf-8?B?SHdJbUtDdmprN05xVy9NYzg5am1TUHlVREpZWk01blhyd254blR3Z1JDRXNr?=
 =?utf-8?B?WS9FWEpqUjhYa3pzL3BTY1ZZY0FGTVRmMHo0V1ZRY0NQNjVxL0MxS09QOERE?=
 =?utf-8?B?aWdzbldZVTJwQXhmaS8xR1JVTCsvUXV5RmFWZHgvWVlEbVRoWDRSTFVXQUMw?=
 =?utf-8?B?UTJybEhPN1VhMEhpRW1ZYis2VGVGSFpQUUxoNDZRNnlJNEVla2s0Zkw5RHNY?=
 =?utf-8?B?b0pUYko5S0xBL0M5TzlSR25uNmxGOExTMFVJM3U4NS9taXVpUmFnRk5BZHNI?=
 =?utf-8?B?K0J0MlJFRWYwMjMyWWV6UC9SQ1hhcUhQUVdvTHgrR3hUWDUzL2ovWGhoN2gy?=
 =?utf-8?B?cUdmb0t1b2FxQ0tBNld2SkdwaFpHbDdOeTlQTnE3VDdES2liN3hpQjdUaHJB?=
 =?utf-8?B?YVZjVzZ1SVlIWjhpbTlqZ3Q4Q1dMWUtNNERSWnRZdG5kdUF1Wm5QcTQrZUZC?=
 =?utf-8?B?QVBNemFDdUUwbXRSREJycEdORnJFQUNiS1pkYVh2QkVQT1htTklxa2phVWxs?=
 =?utf-8?B?RjdyOEVCRWFMS3hUUXpGTmFsYXVzcy8zdzM0ek8yRUJwUVJpbkJNZlRCQ2Vm?=
 =?utf-8?B?bWc3d09tUzYrTlpYaE4xNURXMnBhVGdjN3VnM1R2SGU3d2xYa0V5dk8wWHpi?=
 =?utf-8?B?c2M0eklpWThlOVorRTBqdmZGTXpUUGZHMWwvajBiR28yQXlmRURUNTlLd21E?=
 =?utf-8?B?RXBvWml1cUJHNDEzSUJJNy9iTlIzT2pUWm9mQmFGRDhZN3lxU2tGSDQxWHdG?=
 =?utf-8?B?dmRZZE44RG9aWUFnM0NBYzdpUmxiTVA4QTlTc0lDampwaXRNWUZ5VGw1ZUl3?=
 =?utf-8?B?ZG5zMTVsMFo2OWg1LzBTS2MzSDVxcWhLUjRjZ0tPWExTT3c4UTZLc2x5ZVZ3?=
 =?utf-8?B?a3dFVk5IdTVFdlEvbjUxNlEvNk1seGJmNWhnU29wU0VzTyt5THRYUXluZHhZ?=
 =?utf-8?B?VHkwK2MvUjdjVWhDUVhkWlhIQ2hEWjJxWmdoak9ZQmp1dnNvdVgzM05FSk9x?=
 =?utf-8?B?UCtJNWY4ZXpIUmpMbUR2bXBxdCszZnZaeGQyTktWNVU0ckg2MEphbFR6MWRP?=
 =?utf-8?B?TkRUdDRoM1lWS29kRkR4aGRzYWljTUdlTTFFOWlTT2lOOW83Syt0c3hnTW9I?=
 =?utf-8?B?QlFsUGxmd2hUSmJmZ1hRZTJKTlVlRWJKYjltSzlDbzZ4UzRvWmlZVDYyT00r?=
 =?utf-8?B?UzlOcWVZcG5oRDZCSEE2N3UzQzBBOFdzUDBLdGhZd2NUejhVbWF0c2NRUGw4?=
 =?utf-8?B?ai83V2RuZ1RjT1I1VmgwQnhYaG93SjI5YWRFdmFySmV2WkNsRGhnd0VHbnJq?=
 =?utf-8?B?SGFVL2J5MG9OR29LVjIyRStydDVacU1CN3JqT1A2TVZSZmxPOFVHbzdIN1J4?=
 =?utf-8?B?RXdrbDFadzhUMmRNT2lzR2lodVFGUUEzUGxRRHVXdWpwbHowSWx1ckE4TTVs?=
 =?utf-8?B?UlF4VGFYMld1VGxYSTkzME5ydmlZWlN6TS9MdEpmVVVaRzZtS2FkODhvcWU5?=
 =?utf-8?Q?NqNuluw/84a3yT36lSXCIb913?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bdd82556-0064-4c96-04d9-08dd056de0f2
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 12:06:04.4397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7C/i4a5pec/5FeojQtDTqrN+xAX5A0RHH37vbit1ZSnEbl5/yoDp9+Kk/PJbKdf8bt+5lBe5+vBFTHa55AfZBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7558
X-OriginatorOrg: intel.com

On 2024/11/15 02:19, Alex Williamson wrote:
> On Wed, 13 Nov 2024 15:22:02 +0800
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
>> On 2024/11/12 21:52, Alex Williamson wrote:
>>
>>>>>> +{
>>>>>> +	unsigned long xend = minsz;
>>>>>> +	struct user_header {
>>>>>> +		u32 argsz;
>>>>>> +		u32 flags;
>>>>>> +	} *header;
>>>>>> +	unsigned long flags;
>>>>>> +	u32 flag;
>>>>>> +
>>>>>> +	if (copy_from_user(buffer, arg, minsz))
>>>>>> +		return -EFAULT;
>>>>>> +
>>>>>> +	header = (struct user_header *)buffer;
>>>>>> +	if (header->argsz < minsz)
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>>> +	if (header->flags & ~flags_mask)
>>>>>> +		return -EINVAL;
>>>>>
>>>>> I'm already wrestling with whether this is an over engineered solution
>>>>> to remove a couple dozen lines of mostly duplicate logic between attach
>>>>> and detach, but a couple points that could make it more versatile:
>>>>>
>>>>> (1) Test xend_array here:
>>>>>
>>>>> 	if (!xend_array)
>>>>> 		return 0;
>>>>
>>>> Perhaps we should return error if the header->flags has any bit set. Such
>>>> cases require a valid xend_array.
>>>
>>> I don't think that's true.  For example if we want to drop this into
>>> existing cases where the structure size has not expanded and flags are
>>> used for other things, I don't think we want the overhead of declaring
>>> an xend_array.
>>
>> I see. My thought was sticking with using it in the cases that have
>> extended fields. Given that would it be better to return minsz as you
>> suggested to return ssize_t to caller.
> 
> If the xend_array is NULL, then yes it would do the copy, validate
> argsz and flags, and return minsz.

yes.

>>>>> (2) Return ssize_t/-errno for the caller to know the resulting copy
>>>>> size.
>>>>>       
>>>>>> +
>>>>>> +	/* Loop each set flag to decide the xend */
>>>>>> +	flags = header->flags;
>>>>>> +	for_each_set_bit(flag, &flags, BITS_PER_TYPE(u32)) {
>>>>>> +		if (xend_array[flag] > xend)
>>>>>> +			xend = xend_array[flag];
>>>>>
>>>>> Can we craft a BUILD_BUG in the wrapper to test that xend_array is at
>>>>> least long enough to match the highest bit in flags?  Thanks,
>>>>
>>>> yes. I would add a BUILD_BUG like the below.
>>>>
>>>> BUILD_BUG_ON(ARRAY_SIZE(_xend_array) < ilog2(_flags_mask));
>>>
>>> So this would need to account that _xend_array can be NULL regardless
>>> of _flags_mask.  Thanks,
>> yes, but I encounter a problem to account it. The below failed as when
>> the _xend_array is a null pointer. It's due to the usage of ARRAY_SIZE
>> macro. If it's not doable, perhaps we can have two wrappers, one for
>> copying user data with array, this should enforce the array num check
>> with flags. While, the another one is for copying user data without
>> array, no array num check. How about your opinion?
>>
>> BUILD_BUG_ON((_xend_array != NULL) && (ARRAY_SIZE(_xend_array) <
>> ilog2(_flags_mask)));
>>
>> Compiling fail snippet:
>>
>> In file included from <command-line>:
>> ./include/linux/array_size.h:11:38: warning: division ‘sizeof (long
>> unsigned int *) / sizeof (long unsigned int)’ does not compute the number
>> of array elements [-Wsizeof-pointer-div]
>>      11 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
>> __must_be_array(arr))
>>         |                                      ^
>> ././include/linux/compiler_types.h:497:23: note: in definition of macro
>> ‘__compiletime_assert’
>>     497 |                 if (!(condition))
>>        \
>>         |                       ^~~~~~~~~
>> ././include/linux/compiler_types.h:517:9: note: in expansion of macro
>> ‘_compiletime_assert’
>>     517 |         _compiletime_assert(condition, msg, __compiletime_assert_,
>> __COUNTER__)
>>         |         ^~~~~~~~~~~~~~~~~~~
>> ./include/linux/build_bug.h:39:37: note: in expansion of macro
>> ‘compiletime_assert’
>>      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
> 
> TBH, I think this whole generalization is stalling the series.  We're
> de-duplicating 20-ish lines of code implemented by adjacent functions
> with something more complicated, I think mostly to formalize the
> methodology of using flags to expand the ioctl data structure, which
> has been our plan all along.  If it only addresses the duplication in
> these two functions, the added complexity isn't that compelling, but
> expanding it to be used more broadly is introducing scope creep.
> 
> Given the momentum on the iommufd side, if this series is intended to
> be v6.13 material, we should probably defer this generalization to a
> follow-on series where we can evaluate a more broadly used helper.

sure. I'm open about it. I may drop it in next series, and make this
generalization as a follow-up patch. :)

-- 
Regards,
Yi Liu

