Return-Path: <kvm+bounces-20786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E54E91DC6E
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 12:27:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B0F6B25656
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 10:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8E713D53D;
	Mon,  1 Jul 2024 10:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XxA9NMmD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9923812C52E;
	Mon,  1 Jul 2024 10:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719829577; cv=fail; b=fJ3hD9U9AQO9XyPABzubC9cvlvzmWUTlEO4q0a/ir+WUwfXk8Vmx7VR4Ni5UZuElIJUQpgI0+yeydavU9fqzBi98wyFuDGYJiztqQ83V9ZTj7Yz9pANPhBFQ5PJW75DTFK24M8nf9iN+BDSmNChRElN6CAn2woU7ccth9YbM2Qw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719829577; c=relaxed/simple;
	bh=smvzUWDIXkhqw9JbKfUzkdGo1sajgbqeQ2a6s3Wbz7s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=frLqst69ZXsPhfeQQCvsp6U6O0rF9SWRSkQqqPHXxBjIHWVvZfQOOWsL2haEXUyoVIxe2vmygrgepw0+tGku/rIwFcwYUZVT69A5SjjI4TjewLghR2F6JSyAos7mfGLHvkdIR2sqshhOqc5tcmz8/07sSJeVGs/1+Pg6fHj5hXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XxA9NMmD; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719829576; x=1751365576;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=smvzUWDIXkhqw9JbKfUzkdGo1sajgbqeQ2a6s3Wbz7s=;
  b=XxA9NMmDlhcPldt4xFdnK9HrX/cMW4/1TzfWI6wbk5XOqMCGOTL0quoP
   HcPyY+QG7dhDe6XmXGcq3lKJzoJuvwWxoL48n2wqWQA3NbGvRYZszVsfe
   FcXWIy7QoXw2uHKFZ1eSi6XauuF273A7xD2W0YXnIEfI2DT03uYdrqDTw
   J+DT4tU727cXK4QiW3pk3i+18yx3ytCW5/R1wxAvnYR6OySSm6A2qWt4E
   S0qms/xwRakBJQ2ozaHmmG6aUuFHafueXXtl+rT0xqm6o8JvkUj79lvkw
   pN1HDc6ggbUYNmF1Luuo7aFXuLtqvVQJeabe3aAFzEUzgEowkTkCf2l3q
   g==;
X-CSE-ConnectionGUID: wLH1GDQuSAuRg69YKQiUgQ==
X-CSE-MsgGUID: KHKkTNA9SEKX1ZfbZCvhiw==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="17164930"
X-IronPort-AV: E=Sophos;i="6.09,176,1716274800"; 
   d="scan'208";a="17164930"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 03:26:15 -0700
X-CSE-ConnectionGUID: mzROi1dtQPuzeM6taKcafQ==
X-CSE-MsgGUID: lBZvLfeWTVSA3vAM49gVsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,176,1716274800"; 
   d="scan'208";a="50428202"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Jul 2024 03:26:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 03:26:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 03:26:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 1 Jul 2024 03:26:14 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 1 Jul 2024 03:26:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8hIMLb6Kr8MVeDpRhW8/U4EFm4OAb1qd1qWvV1i1nhlnBfEwvR389va3tWvesleAxKEsHWxKZer8AQjwvDy3wF2prz0JfKD19UHz/IEwxRvAO/i4CplU2RmLLVCwq2O229p5PHGzoyV5Mlv7HGDTpjwr/IsldqGjUbt0XzdvcV6gGFkHJEnIpCjlDXG/576+tgxn7LWX7ooePpGr5giLwAwhWBuJLTrWNaOAZm7KUUQpHaPKhEF7wxs9WRRbUUlGhH71/76Zj9WKPS+YCI/jJPHjBG+PjJATJAYCyKJBK/YfTMg0+H3mK24Iwsq0N08FSI/VuCwxyv49UpY6id/GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+4yKtzLAJdi2I/0BaPL+mvcN9zyeNPFjrb1dI3CIwI=;
 b=Eq8FD1/nPFQDzKCX3mToCZKasDsR4Ub/p/nv/IxvWUJNOmwcf23nxz4iqOgAwjQjjz3LAdb3Y73lTEDJUzG/ZepNnMk01nJChEcanX/nDLM0N57k83cAOTxJb9X/nqhQZRbKqqHOypFpaz19MDeJUrsMdCLbUUmz/wto+1MQ3ScdI9OAo1hgJV+iElf+bTLxaf7mNVv0OyERozFSefKUbGf+5Hox8pDDbXAM9S/kzFsfRh9C8HQD3z/V1N22Kxp/QPfIvlQW1OHqsg/JnmTwPXKFKWXI/8rowy4FjAZJgtdTnEwyKM/LnM6xkxCXakUOKXHAGYf946s7Ygdz5SsfsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO1PR11MB4916.namprd11.prod.outlook.com (2603:10b6:303:9c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.32; Mon, 1 Jul
 2024 10:26:09 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7719.022; Mon, 1 Jul 2024
 10:26:09 +0000
Message-ID: <fddd5230-28ac-463b-8536-ee953072d973@intel.com>
Date: Mon, 1 Jul 2024 18:30:05 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: Get/put KVM only for the first/last
 vfio_df_open/close in cdev path
To: "Tian, Kevin" <kevin.tian@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"jgg@nvidia.com" <jgg@nvidia.com>
References: <20240628151845.22166-1-yan.y.zhao@intel.com>
 <BN9PR11MB5276059EAED001D833949DF88CD32@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276059EAED001D833949DF88CD32@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0208.apcprd06.prod.outlook.com
 (2603:1096:4:68::16) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CO1PR11MB4916:EE_
X-MS-Office365-Filtering-Correlation-Id: c6dc60df-22b1-4831-fd4f-08dc99b83920
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UFV2QWtRNHgzNUFiQ2xKYWMrQ08zSTJTT2RLLzJHai9iV3BjWnFCU0FMV2Yv?=
 =?utf-8?B?ZW1CUEVheGJHV2RPQ3B6TERUZmtCUHpRL0krenJ3VUdQY04zbTlacWV2cnB3?=
 =?utf-8?B?VWYwdFBRMGtvOVF1WEViL2hYZ3dMeEptcFpCRUtiUE1qWnorZXRrS2s3YlVQ?=
 =?utf-8?B?T011WndnNXB2YmI4bkNqWW1DcDkxVU9pUFVoNFI2NCtXQis5TGV3MVdoK0Zy?=
 =?utf-8?B?N0NyMVlGOGpWSlNRV3A3R2NEVmwrdDVsQ2xzZHRpSGNpM1FYWDRaSUdXRnBz?=
 =?utf-8?B?WWRaL0I1cE4wZVpzQUNuZjFZZVZJaGNIMXNjUzkwa1BVOThJL1lRakY4Tnoz?=
 =?utf-8?B?bjJjd3R5RThyaGtaZnJrOU55MWNDb2wyZEFFWDl4V05sa3VoeXRMQmdkQ1Er?=
 =?utf-8?B?bldzNG90YWRjelIxQTJFTytjMEl4ajA0bWpFdktUNzBESVRCbDJXYktFcHdq?=
 =?utf-8?B?NGVXbmRmSUh6Nm1GUDNPay9YVGdyU3RxVjlCUGZkZ0Fjdyt5SHpHeFRoRndB?=
 =?utf-8?B?TmJvcm5rYmQ1WHRKTVA3c1V2Z1M4ZmwrUDQ5SnZKRmlEU1FpNmU5cFBGUWtm?=
 =?utf-8?B?bmcveStNTDF1L3hjRWVNa2V6MmcrdUNKdCs3OW9uTFZHaENCbW54Qys4MXda?=
 =?utf-8?B?bjlwblVCV3Q5aXduRmtlSmJGTkJ5dXMvNUJzSGtJTGRWZmxuVG1aYSt2ZEdS?=
 =?utf-8?B?a1l4ejhKakR0aUNmTkl5QjdFOWZhQnhwSmczWmNiVy9temFYcml6NStzVjVD?=
 =?utf-8?B?K2NiUWZJeTRxN3RzRzlVUTlZWnRUTGExTytIditYUjhEWnFjdkhQMVJCc0tk?=
 =?utf-8?B?dWJzQXhuT2NDNEE1OFR2SXVtM3oxRzNuQzNDS0ZIK2NBalVzYnBNeXJFQ1dP?=
 =?utf-8?B?UlVNbFBYaDlwK09vQ2hLcUs2SEZXV2Z0TW95QkZ2VG5RVkZOQzkyZTAxR1Ba?=
 =?utf-8?B?eTdOQ1J6UmtFckdmZjNoTy9DVFN2ZnBFTCsrZE5qMmE3anMvYTdLczVxTTB3?=
 =?utf-8?B?ZkVTeTlYK1c2T0Fmdkptb0lIZDRoaHorVElRcEd5VDlMajcxbnZ3bkVXMlI3?=
 =?utf-8?B?WkxVdDRMWHdaWmt6cjl3QzVua3cySEhvMWU0VUZUTWJYUlZNV1hSZHMxbUhW?=
 =?utf-8?B?RW9EaVFMT1FxWFVSL0dOWnRBTzNOS05JVWNmUW1ZTmpsZ21ZUWJHRDErSjhi?=
 =?utf-8?B?QjNGZmk4b0g4TlpKdEFBWlJuRDB2ckFKUEdXenhoN3JOcE5ONGFCOExYdGEx?=
 =?utf-8?B?d3lRVTQvcGlIMjRHcE1FV0NzN213Y1FpSzJQTzhQbDMxNjREelVCRG4rQXpP?=
 =?utf-8?B?MUdkQXJ3ZktXUWFsTktYZ29SUFU1bnBMdXRPZnV4UXJMNzduQ0dmRkRVc0RW?=
 =?utf-8?B?TXdydHJkcS9IU3ZXMnpDQi9uMmp1WDJMYXNNNkdGbmUybCtTZElIMmhwWFJN?=
 =?utf-8?B?VFRVdWlMUUN5RUpvbTQwRHF4dXBCNkRSdXozS2UyR2VQL1VsdWVobmJhVXFl?=
 =?utf-8?B?Wk1ESUFrQXUyb3R0bEZuZVRxeTd4VEZoZ3JWWVJmNHljUHhDN3VMZlJubXJk?=
 =?utf-8?B?K09hOC9DUFJUbzZjM3RoUjlJeUdpbVBCOWpOOVZ0Zm9xNE1kS3JoUzBpYTlB?=
 =?utf-8?B?dUZOM29YUzgrSlY1MzZMT2t1MWVIVnI0S0FaUFZFUVBxNmJrRDdzRzl4ZkNh?=
 =?utf-8?B?ZXh2RmJNQklpbUNmcHpKTDFNOEdrWTk3UGU5UzNWanJMc2lXOCtxN213OVZK?=
 =?utf-8?B?eTFOWGUwaW1ubjBTZzZoamg5K3daaTdmZHBHWVJsdWhFZzlxdVdQdVVBZkRK?=
 =?utf-8?B?T0NLcGw3cXRvbDlSTlQ3QT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlVTaFBMaGlKaG1nRTJYTnZEZVUvRXZ5WC9lYkNpODNrNWc2NS9ONE5xM2Ni?=
 =?utf-8?B?R0p3TWJMRkRlWldIcmRSK1BJSWRXNTFnU0pDTkdmYVpkKzRWLy9kelk2M0dD?=
 =?utf-8?B?MldxTTI3bFk0THJ1ZFZtaFJORlp2S1FMeUJzT2F4Q2tVVWhEYkNjK0JrdHZG?=
 =?utf-8?B?VElRb2s2OUdCdEJHTkU1VGZUbXNMNUlGVTVUYnQ1U0l1SFNhWDRXTU5vQXRE?=
 =?utf-8?B?dlUxRUlobFVUNThHdklSS0xpTW92YWVTcUlWOXZBeEVGYmNWRm94QkRndDdl?=
 =?utf-8?B?SmFyUU0vK2tnbXgzK2h2b0ZFNkY2SWZzTTdhdmdkSXhaNitjRVNoOEU1Ykpy?=
 =?utf-8?B?cG1Ca3dicE1aUE5laGtkVHVNMTVWSE5jc0RzMzA0cGxHZWc1eTBPRlhKSVNX?=
 =?utf-8?B?TXhWaHloTVM0VTRyZzlNMUsydHFQbExWcEJjUlhNb2c3TDMvellmY01xVEFi?=
 =?utf-8?B?c1JlM1QvZ1p4SHZsRWc0SDdrZTkvaW1ySlFDR25DbFJBN0x3VEluaTkyMkdu?=
 =?utf-8?B?VWJHc2JoYm1kSUdCbE9wR0w0YTYwUjZUVEJOQW9zOHRrSElQUERIYWlub2lO?=
 =?utf-8?B?cWZYdVhnVzZGdlpqV3hVOXRtdFNqVmxaZVdSVzJsMWZpK0JHejdtQURiRjhs?=
 =?utf-8?B?MzVncFJWSlIrNWRQWTlnNmtZUlR2UVVPTGFYY0tObmFqOVZUYjk1dUlSSGdU?=
 =?utf-8?B?VjVkb2FaenNmQzB5WnlaTVR3ZGIvaEkvS2tRYnYwV1pBV01pYmJaeE5lZzNS?=
 =?utf-8?B?V3laRWNZOEdsM1p4ZDFwMXBDdFlFODNoRkJ0S1dieUtES0RGU1o2eEpNSmdH?=
 =?utf-8?B?dUM3aEpCd2ROdkxXbDZVZ2tlMFlWMFc5aEU4cTNiUll0T1huTW1CVkVXaGl5?=
 =?utf-8?B?K0hyMTBibTdjcndFT0JhZ1R5TFdKak41UjRuWmtHNnl0SDJlKzFGeWgvNG4w?=
 =?utf-8?B?b0xXY0Vla01sV3dMc093emJra3hTY1ZOQ004aW5Lb094ZVZjbVJuOXFLMDhM?=
 =?utf-8?B?ZjhMb3I3SjE2SVJSajcyOXhTZG1oVFpJMW83T2N5ZUJZL3hyV05ha0tHcjgr?=
 =?utf-8?B?ME5aMmlWdWlwYndCazFtUVpaMjcrcnZ6cGNYTnh0VWVxeGd5SHl3MURUTzQ3?=
 =?utf-8?B?TzJpdC9pdVpVUmw4TEV6ek5yQmZXd0hvc3hLQkU4SnZHdXliUklrSDZZQ3VY?=
 =?utf-8?B?Ukp2Y2oydHIxSlIzcHhpNXBOVEJGemNaY0xoNHU0aFNldjV3NEZOMFdoMVBF?=
 =?utf-8?B?bFVleEhNdlE3TXNGVHI5UEhHNUpsa003VTVGYU1MK0htY3lGazFtMTUwZ0cz?=
 =?utf-8?B?SXJUL0RldzJEcEZqcG16ZHJPeFZaNW5NaFV4M0JSajgyOUVwMmp4VXNZbzli?=
 =?utf-8?B?MFNOczdQMkhDTmhLdCtCQUIyRHMyVkZ3a05CcVAwc2JmbFVna3dxR0tScUZj?=
 =?utf-8?B?ZDk5bnFMbXZId3o5NFVFQ1hkeVA3eEpvc1hiOWdsUkdqdGVtL2loQUs0Lzha?=
 =?utf-8?B?REFsbW16QlJlY1FOQkZLK2NkamU2K3NNRDNyVHdsNDJjM2FPdnZrZXhRN2Qy?=
 =?utf-8?B?SHp3Unc2MEtESkZ2eEJjWlRNWDVaaThPS1RBakorTFoveERhSEtPUGpweE9B?=
 =?utf-8?B?cWljMjR2RVF0MzZQRDVjQlowOEdjSDZtcUt3Skc2ejBkL0llZVl0elZzYW9l?=
 =?utf-8?B?TzZIRk9wdjUyWWprbVZhVkYyVW9zMXdQb2RrUDV0MnpDblZacytBVGVFN1A1?=
 =?utf-8?B?bndTbit0WC9pYzd3MkhUT0s2WklWSStINU4xbThUUGV6dnczdXZmNllaYm5G?=
 =?utf-8?B?R0NGdVJGaGl0SkoyRDk0RkNsY1VLRTV3K2svR1hYY1cycktFVk9IdUNaVnpV?=
 =?utf-8?B?T2hJeUJZeENOYU1ndHlYbVRkWnpCZlc2TUFFS1JGTm5MMzlFR2V2bGE2YUhU?=
 =?utf-8?B?cHE4SkYvdEgrbENybGdOOFZ5clh3cnJQQ0VqVkUyWjdaTURmdW04cjFhcGJV?=
 =?utf-8?B?VmdKUlVUQ2c3WjhvWWszSHJKaWZrUVZRZkx4b1V3cUx4MW51b3JQM0ljRVcv?=
 =?utf-8?B?UVE4NVRRS01kTW1xVFZ3VVRNbXN3NzdodXpqM0RHV0dVRkVuZXRsRC96OHpi?=
 =?utf-8?Q?VdJ47MjTu2jDep3OzIl3KPD0z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6dc60df-22b1-4831-fd4f-08dc99b83920
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 10:26:09.4199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GQF5cNNIlBM3upWvZnIRmHvzRTLb2QZD3OdtrETWJpryzgEodQGM92R7DngPDQoHvxsILktt0dJ6KRf2N2UfPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4916
X-OriginatorOrg: intel.com

On 2024/7/1 16:43, Tian, Kevin wrote:
>> From: Zhao, Yan Y <yan.y.zhao@intel.com>
>> Sent: Friday, June 28, 2024 11:19 PM
>>
>> In the device cdev path, adjust the handling of the KVM reference count to
>> only increment with the first vfio_df_open() and decrement after the final
>> vfio_df_close(). This change addresses a KVM reference leak that occurs
>> when a device cdev file is opened multiple times and attempts to bind to
>> iommufd repeatedly.
>>
>> Currently, vfio_df_get_kvm_safe() is invoked prior to each vfio_df_open()
>> in the cdev path during iommufd binding. The corresponding
>> vfio_device_put_kvm() is executed either when iommufd is unbound or if an
>> error occurs during the binding process.
>>
>> However, issues arise when a device binds to iommufd more than once. The
>> second vfio_df_open() will fail during iommufd binding, and
>> vfio_device_put_kvm() will be triggered, setting device->kvm to NULL.
>> Consequently, when iommufd is unbound from the first successfully bound
>> device, vfio_device_put_kvm() becomes ineffective, leading to a leak in the
>> KVM reference count.
> 
> To be accurate this happens only when two binds are issued via different
> fds otherwise below check will happen earlier when two binds are in a
> same fd:
> 
> 	/* one device cannot be bound twice */
> 	if (df->access_granted) {
> 		ret = -EINVAL;
> 		goto out_unlock;
> 	}

yes

>>
>> Below is the calltrace that will be produced in this scenario when the KVM
>> module is unloaded afterwards, reporting "BUG kvm_vcpu (Tainted: G S):
>> Objects remaining in kvm_vcpu on __kmem_cache_shutdown()".
>>
>> Call Trace:
>>   <TASK>
>>   dump_stack_lvl+0x80/0xc0
>>   slab_err+0xb0/0xf0
>>   ? __kmem_cache_shutdown+0xc1/0x4e0
>>   ? rcu_is_watching+0x11/0x50
>>   ? lock_acquired+0x144/0x3c0
>>   __kmem_cache_shutdown+0x1b7/0x4e0
>>   kmem_cache_destroy+0xa6/0x260
>>   kvm_exit+0x80/0xc0 [kvm]
>>   vmx_exit+0xe/0x20 [kvm_intel]
>>   __x64_sys_delete_module+0x143/0x250
>>   ? ktime_get_coarse_real_ts64+0xd3/0xe0
>>   ? syscall_trace_enter+0x143/0x210
>>   do_syscall_64+0x6f/0x140
>>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>
>> Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
>> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>> ---
>>   drivers/vfio/device_cdev.c | 13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
>> index bb1817bd4ff3..3b85d01d1b27 100644
>> --- a/drivers/vfio/device_cdev.c
>> +++ b/drivers/vfio/device_cdev.c
>> @@ -65,6 +65,7 @@ long vfio_df_ioctl_bind_iommufd(struct
>> vfio_device_file *df,
>>   {
>>   	struct vfio_device *device = df->device;
>>   	struct vfio_device_bind_iommufd bind;
>> +	bool put_kvm = false;
>>   	unsigned long minsz;
>>   	int ret;
>>
>> @@ -101,12 +102,15 @@ long vfio_df_ioctl_bind_iommufd(struct
>> vfio_device_file *df,
>>   	}
>>
>>   	/*
>> -	 * Before the device open, get the KVM pointer currently
>> +	 * Before the device's first open, get the KVM pointer currently
>>   	 * associated with the device file (if there is) and obtain
>> -	 * a reference.  This reference is held until device closed.
>> +	 * a reference.  This reference is held until device's last closed.
>>   	 * Save the pointer in the device for use by drivers.
>>   	 */
>> -	vfio_df_get_kvm_safe(df);
>> +	if (device->open_count == 0) {
>> +		vfio_df_get_kvm_safe(df);
>> +		put_kvm = true;
>> +	}
>>
>>   	ret = vfio_df_open(df);
>>   	if (ret)
>> @@ -129,7 +133,8 @@ long vfio_df_ioctl_bind_iommufd(struct
>> vfio_device_file *df,
>>   out_close_device:
>>   	vfio_df_close(df);
>>   out_put_kvm:
>> -	vfio_device_put_kvm(device);
>> +	if (put_kvm)
>> +		vfio_device_put_kvm(device);
>>   	iommufd_ctx_put(df->iommufd);
>>   	df->iommufd = NULL;
>>   out_unlock:
>>
> 
> what about extending vfio_df_open() to unify the get/put_kvm()
> and open_count trick in one place?
> 
> int vfio_df_open(struct vfio_device_file *df, struct kvm *kvm,
> 	spinlock_t *kvm_ref_lock)
> {

this should work. But need a comment to note why need pass in both kvm
and kvm_ref_lock given df has both of them. :)

> 	struct vfio_device *device = df->device;
> 	int ret = 0;
> 	
> 	lockdep_assert_held(&device->dev_set->lock);
> 
> 	if (device->open_count == 0) {
> 		spin_lock(kvm_ref_lock);
> 		vfio_device_get_kvm_safe(device, kvm);
> 		spin_unlock(kvm_ref_lock);
> 	}

perhaps it can be put in the "if (device->open_count == 1)" branch, just
before invoking vfio_df_device_first_open().

> 
> 	/*
> 	 * Only the group path allows the device to be opened multiple
> 	 * times.  The device cdev path doesn't have a secure way for it.
> 	 */
> 	if (device->open_count != 0 && !df->group)
> 		return -EINVAL;
> 
> 	device->open_count++;
> 	if (device->open_count == 1) {
> 		ret = vfio_df_device_first_open(df);
> 		if (ret)
> 			device->open_count--;
> 	}
> 
> 	if (ret)
> 		vfio_device_put_kvm(device);
> 	return ret;
> }
> 
> void vfio_df_close(struct vfio_device_file *df)
> {
>   	struct vfio_device *device = df->device;
> 
> 	lockdep_assert_held(&device->dev_set->lock);
> 
> 	vfio_assert_device_open(device);
> 	if (device->open_count == 1) {
> 		vfio_df_device_last_close(df);
> 		vfio_device_put_kvm(device);
> 	}
> 	device->open_count--;
> }

-- 
Regards,
Yi Liu

