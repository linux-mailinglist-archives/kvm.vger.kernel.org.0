Return-Path: <kvm+bounces-60047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 640C8BDBF14
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 02:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DCFA73536CA
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 00:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C8C81EC01B;
	Wed, 15 Oct 2025 00:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bddJ7rgI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3D51E5215;
	Wed, 15 Oct 2025 00:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760489807; cv=fail; b=OKUvgDPnnEjOyGCrzofog1gL36lF6BCdQJidSihqVb46A8YCynBVCl7Bsvet2S8ZBCJGXkin25aruci5AhlBcakCpLhxTnQvhhlGHl07DJ8CZ8wQMOgzJmA0ZD2X+tzqt5cHjQUX/NTLfWmHMXB0tjwpxJfsedhVcljd/x1WnjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760489807; c=relaxed/simple;
	bh=2x7sHHqylC7fVgJaniZYisVTZUAg70P9afnLv5Jikk4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OmJQRk7KUvMHLbomBNO0FLJJ1GZT5Y8nx6n++qh0sqVuoUhvZ872ykjix+8fRf8MMKi+g+wsAVFbvJ1dhig9a1XG2oLf8oUImIhWyDn9OWBW68WKUledVOftdQiG0YDYNHVRZSpfy/EmQtzstKTJQ6vrwgwJ4Y6JWtX/AdoMIQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bddJ7rgI; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760489806; x=1792025806;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2x7sHHqylC7fVgJaniZYisVTZUAg70P9afnLv5Jikk4=;
  b=bddJ7rgI7YvQbWniyDejx+tnRbkFPM8HIhaiTzGX8ae0rtIrQ8bUnVja
   qS9oBlOwyS3q3g+GbDVXSHC1rmVMBzl1oloB5LJxNI3t0WqzsA63c7Ovm
   ecTVY6k9KDgx/1ugeOFf4YpaTCVAFgO1g/DKtMM5A4Gi3AzcanxGMEy/0
   5MXJv87kB8GleZESBThPAlF7ybdLO4WPe1828zxl9atVMDbW2m5DP/sc6
   /LY2sq0a34Zzi42HDP4Td2FMGFKu42lSP4/3eI4s340g8F8grWen/hjP8
   aD5XCaAE/C4jjxAPaV3N0zg9jBNQhEuOBsWmv/aVaZpoEU28+xlmYQdAw
   Q==;
X-CSE-ConnectionGUID: IWUxNi7pRWCNU11p0/ziMQ==
X-CSE-MsgGUID: nJ1sDyUFTqegzStf06xG9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62567996"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62567996"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 17:56:45 -0700
X-CSE-ConnectionGUID: /BFzz4s+Qi6yDXRaYSXh3w==
X-CSE-MsgGUID: /Dje1IpHSmeLVrXgKZUY9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="182463107"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 17:56:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 17:56:44 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 17:56:44 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.56) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 17:56:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZQr45L/jvbAOXxxX/+Ygha20JuZUIWmzEVVxR51c45tg9T65h9S78jbaDKDGCqLuOrrB1Ds3kGP5Q0SiR8j5q9OAKfnGYDc0tOnz/N9mFZlPslMoy3u/iRyBV3Nf62dL0HWJViEKuUOCqe+3ymf66/laIdi4sOKpcOe7PDVpNt7RhMB1yhiXIE/cvEwLKlgSW12hy9IGlFT2avmBxsfNg6zFJfaIjqxzpC2Q+BHWPmBr2O12a4q9ax5RyggFnuka/IrSduE66Rw0WjFFeLCgYt54Y0N6DGfmyBH4Ej9qyOW1siQ0re4kOn1xKwVbN68FNRjkCzV2VMDEg4i+7ZmbgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0vP6oWBiltcN/j8kLOUebvp4P0vN+bwS6aPJ6GuXMs=;
 b=hWSDNJ7o2kXpeepBnd+Bu7XDBkdwFg3uICsm3ZI4NsnauGjeCbiE9Kh1Rw4JhzXZWcuhxx9ddU9e3VysCbRYXFagj5jBZFC9luxnst7+BbZbRZ4dWVVMYPg5Sa1EMcpWa2u3z7IJ9Awc3mM3XNDb1xqpJqMZZq9Am/KfKM6Q4Ztr5R6EX8PAK5ydEUsEibRwPlzSpkU62YkmfZg82G475sPFQ/rQw7dgWAi/8gwo3L/BN58Wf76vFOgT0bmV/rUdAJDKA4wTwe5K62DRy0Ov7UfrlY81CYwshfbGcdtqWe0p75MNttQDDYAUmebHTl/hyoD3I9apSGpgq7EZ78SU8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by CO1PR11MB4772.namprd11.prod.outlook.com (2603:10b6:303:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Wed, 15 Oct
 2025 00:56:40 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%3]) with mapi id 15.20.9203.009; Wed, 15 Oct 2025
 00:56:40 +0000
Date: Wed, 15 Oct 2025 08:55:20 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that
 skips WRMSR
Message-ID: <aO7w+GwftVK5yLfy@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250919214259.1584273-1-seanjc@google.com>
 <aNvLkRZCZ1ckPhFa@yzhao56-desk.sh.intel.com>
 <aNvT8s01Q5Cr3wAq@yzhao56-desk.sh.intel.com>
 <aNwFTLM3yt6AGAzd@google.com>
 <aNwGjIoNRGZL3_Qr@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aNwGjIoNRGZL3_Qr@google.com>
X-ClientProxiedBy: SI1PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::7) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|CO1PR11MB4772:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e008e34-13f6-41f0-ec01-08de0b85b30c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ZalK2hCDxILRddOgVVUYsXtBhsQPKjXlZl/ptMY7jeQ7cWthf7tu9FVCg5be?=
 =?us-ascii?Q?FqmUYnNBmOZD33ijQKBjGY0D0ncmWBcWbt8RGEV84hbbFLvxEiu7GoszQv+G?=
 =?us-ascii?Q?aSVm4yTlM2IqByLe0M6VXuu3XVVNRhwgx6W1WJ//zHFKYH5jZTRoc+pLYFcT?=
 =?us-ascii?Q?pWvFTaT8Rw9JaxgeTY57M2DP75yr7O1gvD34WbJ4pwskAU3Kjm1i5BNLKHi4?=
 =?us-ascii?Q?c51GmU8J3Cq5cHAewWhD03hSDf4h6/uqBBrK1giqNLhO1OL1xsUtV75Hmb9k?=
 =?us-ascii?Q?/FFbae5XZzzpPfxct/rtQcMbTThErvbOXhGz92IdUYVbAY8gkys1BwMg9DO9?=
 =?us-ascii?Q?27tySGdhd+rdTijxI2yjC3BwfJO4PiazlsdWv56KCslUQFCsBF0CtqmwOhhu?=
 =?us-ascii?Q?VFdorxNyYC/2IxQB70KTQnXR2dXZ+vFGCRz/+D1UhQJsOdJhFtJtRPpC5t+g?=
 =?us-ascii?Q?Mcx3ZvNUfGNAvyddnSzzQIVG3rD4HDghN2UjRMveEh3XWbgoEKEXbNDqj0xl?=
 =?us-ascii?Q?998+bXvSTPZrV8e8fl7zvJrKjIfggHIRqsMJRC7gvdh/oS7Yxb7xyy4wv3is?=
 =?us-ascii?Q?xyQ2DaqHQvLDwo5s++TNBG+F1EBHAcYtkR3Xx7OtVApY4SsKT5BJHjEDDplw?=
 =?us-ascii?Q?TnCg/cf9AechOK9oYDcxH3NOhEl5HmWFDTXezxFRzwyFfFH+kk5AahCRUqUY?=
 =?us-ascii?Q?joRNyy+q07MsB9TocJZ8o6i1kVu0wrWEG/Ak/pKpEyObgDEYpPT8vAHfALdf?=
 =?us-ascii?Q?AoHVNycZTLGp5cJxDxZa2jElNclpylGu0fxXfx15vlgTAWspu8RmqPJgnxP0?=
 =?us-ascii?Q?jyX7RRV0oxHYFqqI5KUiz2wTeBgEEFk2BBcUy5HYmcKCfMg60PQxavLTQSyZ?=
 =?us-ascii?Q?gKMBHvq/PtO77bUyWPFH+1q2V2xbBrinPQ7r1VSdQlG9cgIejlpfdpR5s0vY?=
 =?us-ascii?Q?Ol6dxUcNjWXKkub/ytcMyqTmuZW8zgJ77LoGq3Mvb7PX9C3/t0I0/sQN9B2F?=
 =?us-ascii?Q?qXTDF41my3o+YaYZZZw0GzbwzSa/rJoSGuEs5sIz9+IUGarzuxsEC3Rjsmdh?=
 =?us-ascii?Q?EEx8Cg5NIh/zliMYemaEaIeaKLhfXA5clRX5VsgnmQC6Pz/C2URN6TjWHmke?=
 =?us-ascii?Q?aIVFhjpDUUa40WwEspoTwA+y+aP/MJqlNBi31PSjIdOl8T7Mrj+r2U7ZxDQl?=
 =?us-ascii?Q?pAbvqdRD25bi8sC4Iwj8ai8MpWq6mBzzCBgll7ykaLTS2sXmCvJMlI1sxlxN?=
 =?us-ascii?Q?N3yHpM8OZDp5XzwmxRxg5sxHY6dINZ2XQOqg8ReeEHlMoiXXTdXv83pZiD1Z?=
 =?us-ascii?Q?wYC4dKVYwit3e5+UxO/C7k5MmMLFor5qQXqy7/hGfpoCgAlcAeDYuqP1MLu7?=
 =?us-ascii?Q?uzw0xOlwVbjZ0X5g+geqUwC3DbA7NYrLyO6idR/mofMgHMS23vacRYhaCzc5?=
 =?us-ascii?Q?uyD6IKhUf0KRi6zti2MpooHz54PzFr3T?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CJHdHnJkyNNlN3nU+W1BX1JnGNu6URUZ66tWqhodYsgwK5Gjh0cnKFjvsUnq?=
 =?us-ascii?Q?cWB3zqxMFvQOYN8d3s1AeqBrDyu4k+s1Uq0dheTtA45smtkngYJ03D73FhjG?=
 =?us-ascii?Q?YI2Kldy6FS9SxCpq1PnlisRmpUPmLchCHxk1KEDxC6ZZnq55b3QLww91gR92?=
 =?us-ascii?Q?a5vocDgdg7aQ/6jrVEBeVxEVFn+90SmN+8wYdBkvwrkmai35hhWlwMwsUh03?=
 =?us-ascii?Q?PSrfoGRJ3sQ0naUswBNIJrCuLFOCU/0dijyA0K0ii9WnwzVZBxDxGgQVHgpE?=
 =?us-ascii?Q?AcpYFIq4lgln2OaOySD4Vg1Egx59a3oDGeoGiDOYnXeLk4lfPlPBdEKk6Bz7?=
 =?us-ascii?Q?tas3ANNL1vxVUaSYvwKCDKx/Oic3wa1g6HqZazMyIPpiR81pCHZCEw2ul4oM?=
 =?us-ascii?Q?DS2aYNmNdC4mYYdqgXZs28/EoFEWRKwY0VGjpDYTiMUfrBctu+DkbY+ApvJn?=
 =?us-ascii?Q?AWIv0Zsp0XzQv1w9FIh/vxdQGvn5Z+tyAlHIb4XjTvmbqX9bKRmRDYx54dMq?=
 =?us-ascii?Q?2o8FEx+o7Ghvn+dMf4YH5ZPCOTeRinhTus3HpMkeVtlL5QcmGjhCx08ednSb?=
 =?us-ascii?Q?GJFjEBUyV2kiMGnGgA9OWH0tGVWYJdz/gHN3DBbwDIBI9thEbc/QX6PDcGUc?=
 =?us-ascii?Q?lI1ovblGiVtTx1ut3QndQQwkZ9QJsfc9d+uMx3ritvd6MTfqMGvL+ehjKkqw?=
 =?us-ascii?Q?sOYgTgDsCFOFCXkxTZIoSi5E8r5b6ZEzvCqvY46ChXRJJ6Kl3Tm+XtXnx+lM?=
 =?us-ascii?Q?yJm6zB+Y5vSRXX/tcQTQ+sNcxpJJuLNEfU3cdGn+PXIaju2YSSSJsHWxAaen?=
 =?us-ascii?Q?LOVP26RsP/2gOpekGs6nDjEp8I0u2+q1BbDzctueig0mgU7D6q8TaeIfsWMx?=
 =?us-ascii?Q?fzs13KAfxwHAntGsNJvW3JumiGQro4qyC7JKjUsxBcSrJmIVV36cWwxfWb3b?=
 =?us-ascii?Q?FSNmpExvAa9F39C+ZJmqvDzILy67ZB/+YbWx+udXfKxpIErlTYZXjkZ7sTKU?=
 =?us-ascii?Q?+JMeMCfGOnI2JHorMG98j4lp27z+2bWaHzB/VLKIPPcOifrwaOJzmN+BT4ns?=
 =?us-ascii?Q?XjnlyBVBzdYZnIigrmTiwcxps5qENKcPXGr+WBu4LcU2+5JMHuLRSJowOB5t?=
 =?us-ascii?Q?WKqBYC7snBc6yBkD8jZnPL0Pg///jqlPCv9SrR+JOLEhM4tAoxVjiHveD5KU?=
 =?us-ascii?Q?bIiGAgUpuxtRPYMm6IRTpBWWlv1k0jzDrhU81JCD7cLvGuAel7BjzylmaHZe?=
 =?us-ascii?Q?W0K08k/VEVKiOctmoiMboyyBBM0cz6Xu4c+uu2/ZwtTkroU141jRIM5Gbbhs?=
 =?us-ascii?Q?0wIYt33wjjiLHimPNyBqSsbw/HIM8zzwzAoZ42ArQJMhjxAQWxBXNU82TlzK?=
 =?us-ascii?Q?GIBbWRzPjDDZGejWJXVqx7dlRMiAUce/75w3rIqY/GGE6Sm9/ytFC7QxlGVg?=
 =?us-ascii?Q?yqm3eg95oq6CUxgueVEX1HjXtvCgK99bTNIjsnY57W+EZVR/XAmXDixVQ8mi?=
 =?us-ascii?Q?XBEN6Z5YaHpPuUertJ1r2qTRtCu+2zVi6rBD7pnE+7WeWL3Ev31YjTuEgIPf?=
 =?us-ascii?Q?eLa1ARgRAIPsarm5+A/RVHz/ZsS2pbjtIJv/1IdM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e008e34-13f6-41f0-ec01-08de0b85b30c
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 00:56:39.9538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtZ4MFhuAIgMtY/1y+mEGvrtchb07oKyC2LnQqCszkUiJ/L8OErqEfs0p5fGxPgWHj0WDESZ766B8fBKCup5+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4772
X-OriginatorOrg: intel.com

On Tue, Sep 30, 2025 at 09:34:20AM -0700, Sean Christopherson wrote:
> On Tue, Sep 30, 2025, Sean Christopherson wrote:
> > On Tue, Sep 30, 2025, Yan Zhao wrote:
> > > On Tue, Sep 30, 2025 at 08:22:41PM +0800, Yan Zhao wrote:
> > > > On Fri, Sep 19, 2025 at 02:42:59PM -0700, Sean Christopherson wrote:
> > > > > Rename kvm_user_return_msr_update_cache() to __kvm_set_user_return_msr()
> > > > > and use the helper kvm_set_user_return_msr() to make it obvious that the
> > > > > double-underscores version is doing a subset of the work of the "full"
> > > > > setter.
> > > > > 
> > > > > While the function does indeed update a cache, the nomenclature becomes
> > > > > slightly misleading when adding a getter[1], as the current value isn't
> > > > > _just_ the cached value, it's also the value that's currently loaded in
> > > > > hardware.
> > > > Nit:
> > > > 
> > > > For TDX, "it's also the value that's currently loaded in hardware" is not true.
> > > since tdx module invokes wrmsr()s before each exit to VMM, while KVM only
> > > invokes __kvm_set_user_return_msr() in tdx_vcpu_put().
> > 
> > No?  kvm_user_return_msr_update_cache() is passed the value that's currently
> > loaded in hardware, by way of the TDX-Module zeroing some MSRs on TD-Exit.
> > 
> > Ah, I suspect you're calling out that the cache can be stale.  Maybe this?
> > 
> >   While the function does indeed update a cache, the nomenclature becomes
> >   slightly misleading when adding a getter[1], as the current value isn't
> >   _just_ the cached value, it's also the value that's currently loaded in
> >   hardware (ignoring that the cache holds stale data until the vCPU is put,
> >   i.e. until KVM prepares to switch back to the host).
> > 
> > Actually, that's a bug waiting to happen when the getter comes along.  Rather
> > than document the potential pitfall, what about adding a prep patch to mimize
> > the window?  Then _this_ patch shouldn't need the caveat about the cache being
> > stale.
> 
> Ha!  It's technically a bug fix.  Because a forced shutdown will invoke
> kvm_shutdown() without waiting for tasks to exit, and so the on_each_cpu() calls
> to kvm_disable_virtualization_cpu() can call kvm_on_user_return() and thus
> consume a stale values->curr.
Looks consuming stale values->curr could also happen for normal VMs.

vmx_prepare_switch_to_guest
  |->kvm_set_user_return_msr //for all slots that load_into_hardware is true
       |->1) wrmsrq_safe(kvm_uret_msrs_list[slot], value);
       |  2) __kvm_set_user_return_msr(slot, value);
               |->msrs->values[slot].curr = value;
               |  kvm_user_return_register_notifier

As vmx_prepare_switch_to_guest() invokes kvm_set_user_return_msr() with local
irq enabled, there's a window where kvm_shutdown() may call
kvm_disable_virtualization_cpu() between steps 1) and 2). During this window,
the hardware contains the shadow guest value while values[slot].curr still holds
the host value.

In this scenario, if msrs->registered is true at step 1) (due to updating of a
previous slot), kvm_disable_virtualization_cpu() could call kvm_on_user_return()
and find "values->host == values->curr", which would leave the hardware value
set to the shadow guest value instead of restoring the host value.

Do you think it's a bug?
And do we need to fix it by disabling irq in kvm_set_user_return_msr() ? e.g.,

 int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 {
        struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
+       unsigned long flags;
        int err;

        value = (value & mask) | (msrs->values[slot].host & ~mask);
        if (value == msrs->values[slot].curr)
                return 0;
+
+       local_irq_save(flags);
        err = wrmsrq_safe(kvm_uret_msrs_list[slot], value);
-       if (err)
+       if (err) {
+               local_irq_restore(flags);
                return 1;
+       }

        __kvm_set_user_return_msr(slot, value);
+       local_irq_restore(flags);
        return 0;
 }


