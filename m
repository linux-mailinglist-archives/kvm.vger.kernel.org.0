Return-Path: <kvm+bounces-72673-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oBu6NLkBqGkRnQAAu9opvQ
	(envelope-from <kvm+bounces-72673-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 10:56:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B1ED1FDF4D
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 10:56:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B6D1301E6DF
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 09:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4954339EF2E;
	Wed,  4 Mar 2026 09:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="louJSz7w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5043988FB
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 09:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772617918; cv=fail; b=qObnEkCaLi5MV+3Bk2idhx+s+NnhJlI6sb7GKEOBSI14bnmKhAQix1L+QpMntaCOlS2xNvoE5K/F1MRdv8yEf+F5zeqUNZjA6hMzqm+kL5zzmKDcBHGnPg/fhYSWn/2QWf1VD8QzPOC7pktJWPimf37U/eUyb4Os+2rd/0/fh3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772617918; c=relaxed/simple;
	bh=QlhW3IR2QmslmcYVHT+BLB+fpGuwVFoHfy/jcEH2+cg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fKRd/mew+IO87sodSfM3elvGvZcF1URX9NObdLZY9vkfy3Ibhfdbb0MYJIf/ZlTVYqXDSXwc4nwOTwgv/clNXV0Gd9aPRvz5O2Nl/I/GjCfGJ7G+kaVDIxSt6e9gSqr0Uqbhznx0dE/Ln8xfukeB7mZiYzwheCCcdBII8pxuDSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=louJSz7w; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772617917; x=1804153917;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QlhW3IR2QmslmcYVHT+BLB+fpGuwVFoHfy/jcEH2+cg=;
  b=louJSz7wxBA8N2qGW9Qgjo/Xfp4InKsmGLg6kx4HPDjaI7pFUBPBYoNN
   TdqwQ+1BFUvcB/VkRqEjEXLOJlvYCw6CyeXU7uhpXG9kgIAvq7mRTZ9SK
   XrsFSucGnJMxNpbSOFjOkPN3vRsEW1Pyj3ZSynuBUVatM9/PvR2J8Xvhu
   zhjYI4nKUiw5AbgMAqE/zTq6NrZk0K5wp5P1RHeXLwHlhWKijNA0+PQOE
   8ZxSupnBbdjvSJKPiF69M20Mnv1k6rrh7oAImL/kbZh+6o0BrfsYoT2cj
   2jQWeJ3+GIHUCiCu4m8d4PyZ00TcS4OzP2W6mG8WCqM/fgSMu8QjQhC4R
   g==;
X-CSE-ConnectionGUID: wUnzze7nTT+8y8ap2CsweQ==
X-CSE-MsgGUID: ogKLojpEQSWTcTf3zgEfyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73640923"
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="73640923"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 01:51:57 -0800
X-CSE-ConnectionGUID: nREJ6x0GQ1612+u65qRC/A==
X-CSE-MsgGUID: S8m+aqKISNm6J+Ygdo49Gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="223285900"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 01:51:57 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 01:51:56 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 01:51:56 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.42) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 01:51:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BCnrdZ9HhR0f48P73jUQXA68Prrf36pB3CSudss+WtIIfRiWm1ZOBMAX88e1UR37uESZDdvWvr5cMUAXL6V7qmugEH2NPAzgMzWp/RAxhwi+ZOBiI7vcSejpHWmEk1dF2Pm2eemhI41s2BXGfk4Q+T/EyycXcx43RiUhUQQzQNqYc8OvmTzs1Fs2V7JZ7O8P7lBQbWQ44Vhd8EQMGDYQhNbh6VnoCHLiEM7a/oM1Y3EruxmTNbDYdXXEexpI+fUIeHynzJTPOcnmL9hmsrJChpO3VluLGooRSr4ARLvTaFuUlYiA/jAvqKZGMyEIMRprL+HSgjgtItShYhdo534KYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TDVzC1yhGWlSJz4ULlrl3aqYI23d/qPsjkRwqG9Bdgc=;
 b=mnYCYtHx4iIlQpukVAJEU1I+bHMdQbQSthF9IOXXCtNsJW9D5khBmTsgShDwSjEVLIy18I0PWTiTKp/enNbCGdEezd8asLwDib2QgAJVlFXyjsLPAJjolfmbEaVHVBlY+5ReGzxQTg7yIAWDR2SdVDseY83j0ugWNn4IW0NUrhhVp6MYuw/LTdk13JPQmFayi++1SuLVvlq7jd+wj5ihOCjk7tEJqapgNgBAdJZL1lexKiG/1CREZYEm4YyrUAW3P8qRHuP5AxPsmz9p8KNf1SvqbcfAyVG+Hb1MC7SeiqXx2q//VQWS/n58h1gjsK9ZEjMEFmKdRKrFz06yGg306g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH8PR11MB7022.namprd11.prod.outlook.com (2603:10b6:510:222::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 09:51:53 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::8f1e:49f4:122c:c675]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::8f1e:49f4:122c:c675%4]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 09:51:52 +0000
Message-ID: <02381fd6-dd40-45e7-bd7c-f97de5618df1@intel.com>
Date: Wed, 4 Mar 2026 17:51:43 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/15] system/memory: split RamDiscardManager into
 source and manager
To: <marcandre.lureau@redhat.com>, <qemu-devel@nongnu.org>
CC: Ben Chaney <bchaney@akamai.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Alex Williamson <alex@shazbot.org>, Fabiano Rosas
	<farosas@suse.de>, David Hildenbrand <david@kernel.org>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Peter Xu
	<peterx@redhat.com>, <kvm@vger.kernel.org>, Mark Kanda
	<mark.kanda@oracle.com>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-7-marcandre.lureau@redhat.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <20260226140001.3622334-7-marcandre.lureau@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0026.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::18) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH8PR11MB7022:EE_
X-MS-Office365-Filtering-Correlation-Id: e37dbe17-e971-455f-a333-08de79d3a9ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: 7hYsvEeEK5LsT7NgkxA3WBJpJbECAt63Hf7pZl1LHMtt0ig3coCPb0ruqCU9U1YG1oS9dKQCEOgg8BMqJirkkYq/lBj6pOh78xHVjifKOylljo+5nHwQh31gIw2ttnnStYHo6n3aDNcJO0uL1I2u+WJKQHYR89Ka1pnFZHo7LwBbcmiQu8Wt8q2uV3R2lsWPrRLJeRbiU7N/Qyx+EIRVG1mjnyf+pB95ULITNpHWnE0P1uyt9nybYkTuva6TdOJSj2ys+DvDqSjw4ccCgiuoJOMmg/Pfi+1B46HYxscJn98O1aYoMMqMjIfNHJHV/Vf8HuDm1Vd49jVP5dTBJtCHIwsZAju79X4pQLWd8amDMqExIE81LpsevbqbKjn7xomLswvh1mTfyIEpqXqEEnlOSj0u+Z8kqhy5hm7ZxdPGARzbz7KNjVauOzNOJr9dxMuUxSZSEyhHcTMV1CGRs2CDkwpa3qb/dgNAYESPAUkxROHDxwCPh3M4y3TKZf99NFNcY3JZN1QLWla74HvSsGIZzOijhAZf0Xml1j7ZNcmJcE+HzB+FO2tuiNXBtjmLGqTGBDea/8Qqao/YBrfyqfW6Rq4/YnItJd6CqsPGl38ke/xtGz/exH6C4qCo8bJWDht5n0tYgj3fr7491XIj7y8vrDRuc7tEzqAv1D3aOWHgkNoe4DCBxBNsAOpLJmNyQrLO2e2vqO1u8WU3duV1fsO8boVeIHd72Me5BKMGU+QCT9U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlMyc1lyMFIxSzZ6UWRJeXRZbzRVZzRUOTV2RHRxcFZwUklRakcrSWV3aWZI?=
 =?utf-8?B?MWdEdlJsQmFmOG4rMWI1cHhjczhZSFhGNnRuYW1MbkpEZU4xbjVVMkZYN2dO?=
 =?utf-8?B?Rk9qWjJlbytZWEMwc3ZYeWlPZmtZWHRHZThvWEJVLzVJNU1ZTzNOOFZqbU82?=
 =?utf-8?B?VVNjSUJXYVMrODhaT1VxV2RJb2J6VGpncVQ3Q2FjaFpnZHZnYkNTQytxbHpy?=
 =?utf-8?B?bjdRUjVkZXhWbWV3VStRWnFBTzlHTDluYXlYcVBLcmRXZy90MnE4WkFuYStI?=
 =?utf-8?B?N3Z1N3d4cUNsWDUxWHlKWVBXUy94VVAxME53Q3FZWkQ1ekc3NWNIZW1sK0J0?=
 =?utf-8?B?ZEs4dk1iaVV1cktiTUUySXJZeDJtQjJGZXI3RDJVWjdJaHJuREJmNmJ4bW5L?=
 =?utf-8?B?ZHczOE1lVnRDOFlUTzBXWkhKQXNoL2pBQk1PaVc4ZS95SEFNQUlWNmRZVy9O?=
 =?utf-8?B?NG9GZXNPSWg1enJvS3NkUGM2enN1NXRjTFhoa2ZQTUJPU09zT2tEZ2pUSlh5?=
 =?utf-8?B?cTc4Q2EyU3lqQ2l0Vi93L2ZOVWdBZk4wRUxrZW9mTFRzcnpva1JLbTRYOFNI?=
 =?utf-8?B?U0tPTTJXVjFIL1gya0xMeG5FVDJLbXgvY25ybE9kZmNnZUxmK2kyTkpWcE82?=
 =?utf-8?B?QUdScU9rU2dxKzFNMHRqSmJ0NnZ5cGJJNUo0bGl1VWtrSkZYZ0dndGxJZW45?=
 =?utf-8?B?Qyt4eHJob1ByMnJTdUFESDdzUDAwNHpONG1ONVY0K29UeUNHZHZEWjk4SDl3?=
 =?utf-8?B?S1BXcU8zTVhyMlhRSXFWd0FUUW1HWG5LSTdQSS83VW9hUklmSHo3V2VBZnBm?=
 =?utf-8?B?bUg1ejhOVFZYZndWUHl2WnBDOWc2MGNzd25hei9OcnBnMHRRUXl4QUxxdXZO?=
 =?utf-8?B?Q0xzZk9WSGtPY1l1UVZGdGg5T2t0NW5Gb2IwbFRJNDZTZnE0eUNKaVVxZXcw?=
 =?utf-8?B?QWR3c3FPZUJEa3hxb253M0tQNWE0QU5oNVd1UGhnVGp4WGkyUlVlL1B5T0oy?=
 =?utf-8?B?cnBYVVFFdlBkSFlPemprcWR5MkhaT3NCdkFlTERRelVCZkVGS1F0T1RFVVFw?=
 =?utf-8?B?eExJTTdzcVJqYU53TEsxb204bTJ0QmV0cFJsVUxMRlA5SzRaTTRBUmdjTjJB?=
 =?utf-8?B?a2JIeVVieTJJRVBmc29nNzB6R3hvazh4c1hkZGtIMHcwOEx0ZnZFeVJERU11?=
 =?utf-8?B?L1FuSDNRdTdRT3lJRUNaOFNIN3RTSnNDb3FvQW1qLzFCV25PbHViYTViTUl2?=
 =?utf-8?B?TGVCeEJCeFBoNTlURng0eGZ4a0szam1NQmhhc2hCQlZiWEpRbFZ2QVppV3FG?=
 =?utf-8?B?NVpqbFZ1N2ZIWkZYczl6UEx5ZkRDMWtQT3VqN2ZSYVBLQUZRbStjdm5CQlBP?=
 =?utf-8?B?eEhXL1ozZHNiTnozTWd1VGVaUXF6U25FaFY1MVJXSWxxNzRZRWlQOEo2WlQ5?=
 =?utf-8?B?ZDZjV01SQ0dTSUxuNDdZWWxEeGtWUy9mU1I2MDJJNHVJUldKa2JYT01zZFA4?=
 =?utf-8?B?aDFKK1NSSVVlMjZUTkQrb1JSTk9obm1uMHBJUEY1S2F2aVZuTUYwanRLb2tt?=
 =?utf-8?B?eVpnL3FtQlJGYmpMcEhuY2xEbHM4THRlNUxJVzlabkViWTJ0dDV6c1BGRkxi?=
 =?utf-8?B?SlJCUU9UYUVsUnBZZHk3WHRleENCRzV1UnhpR3hJSktvOXhQZ3F5TUsvQTh2?=
 =?utf-8?B?M1pOYjZKM1J6V1FrRUVsc0Mxc1p6WlNHTXcwV2tsVDY1dkh2allkaWdPRGpB?=
 =?utf-8?B?Q0NjVHBteGlWRkE3SGlNKzBiN0J6ZXJXK0F6czRkU256Vy8zalJCY2w3TlJn?=
 =?utf-8?B?Nm1XQ0dxZ3Yza3lVK0V5L2NxeUZxa2lyOWJ5S0hiYUdhR2VRSVkyWTJpaVpD?=
 =?utf-8?B?dldvVUpoaVpDUjRpVG1aL00rQmV3UW1HakNCWW9ycStLV28xTm1SQjYwVSt6?=
 =?utf-8?B?M3lUU25XVTFXN1pHbkxMdDNlR3F3dHc5ZDZad3FONlRLNk1mYjZPb2dXVVgz?=
 =?utf-8?B?eDI4dEVzM3NmMSsvK3V4UTdBY1pHZUQyN05VUDRlNlhXSzJuWnJNVzBXcWxJ?=
 =?utf-8?B?L1JqdTFpWEljV2p1MVJNMTJscXpWS09qbmt3ZUd0MERZWFpHWVM2Y1N6c2oz?=
 =?utf-8?B?U1JvWEF5SFBrSHlFNWFQajF3emV3N3g4bWNwMm9FWmJGbFljakdta2F5MUdO?=
 =?utf-8?B?Y3lsZTZ3aXpCQmQ4NExQUzdoa2t4azdJU3d6d2hzVUZLQVdVZzhSUHZVaW1a?=
 =?utf-8?B?R2hNcU1IdlpvbTkyRHRmcTdjUjdGRUtZZ0h1cmZwNmw4THJ4TzV4bm9rdTdR?=
 =?utf-8?B?UlJKTlJKYnpBNXFudnNTTDUra3RDaXd0R0FtNjdRMDhxcHM2MndvUT09?=
X-Exchange-RoutingPolicyChecked: USzFtFnEYTxRdUpytlB1zIlyf9vRHtJjaml8ORSXgyA/cB60BCF4n1+uRtXtneDFv/4w5FcvHQ2Ks37dbCCsK0nrcJJkwbM5PTZsO4YfqooXJuDxMUmS0fATAoppMMyX1aQHBSOSiXIv/jKACtAhZGEql3CMEFPH6riyrb9aTB/7T6DomBKib7vgT9KzmsfEosXOWUlNWzicpa/T9WhjWoXexWLgRxpke5aQU5RXAc3UYUfNjCShTx8IUEVQs06U0Vwc/c3f81Alb3LhhHZYSXlNtu3g9dg06HGVTWOD8ijEpYyiMHx14OxjooFEk9ZQyszZPYat+uRp1PhS+r5g3Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: e37dbe17-e971-455f-a333-08de79d3a9ad
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 09:51:52.8526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vmnhD3uKueSweRa+Sdg24vK4neMyFz8oT5+QeOIFKIEBRl4HL/J6ww5MZC3ADiLZG1pMYLaUwl+kKrI+WrXg4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7022
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 4B1ED1FDF4D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72673-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenyi.qiang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action



On 2/26/2026 9:59 PM, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> Refactor the RamDiscardManager interface into two distinct components:
> - RamDiscardSource: An interface that state providers (virtio-mem,
>   RamBlockAttributes) implement to provide discard state information
>   (granularity, populated/discarded ranges, replay callbacks).
> - RamDiscardManager: A concrete QOM object that wraps a source, owns
>   the listener list, and handles listener registration/unregistration
>   and notifications.
> 
> This separation moves the listener management logic from individual
> source implementations into the central RamDiscardManager, reducing
> code duplication between virtio-mem and RamBlockAttributes.
> 
> The change prepares for future work where a RamDiscardManager could
> aggregate multiple sources.
> 
> Note, the original virtio-mem code had conditions before discard:
>   if (vmem->size) {
>       rdl->notify_discard(rdl, rdl->section);
>   }
> however, the new code calls discard unconditionally. This is considered
> safe, since the populate/discard of sections are already asymmetrical
> (unplug & unregister all listener section unconditionally).
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> ---
>  include/hw/virtio/virtio-mem.h |   3 -
>  include/system/memory.h        | 197 ++++++++++++++++-------------
>  include/system/ramblock.h      |   3 +-
>  hw/virtio/virtio-mem.c         | 163 +++++-------------------
>  system/memory.c                | 218 +++++++++++++++++++++++++++++----
>  system/ram-block-attributes.c  | 171 ++++++++------------------
>  6 files changed, 386 insertions(+), 369 deletions(-)
> 

[...]

> diff --git a/system/memory.c b/system/memory.c
> index c51d0798a84..3e7fd759692 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -2105,34 +2105,88 @@ RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
>      return mr->rdm;
>  }
>  
> -int memory_region_set_ram_discard_manager(MemoryRegion *mr,
> -                                          RamDiscardManager *rdm)
> +static RamDiscardManager *ram_discard_manager_new(MemoryRegion *mr,
> +                                                  RamDiscardSource *rds)
> +{
> +    RamDiscardManager *rdm = RAM_DISCARD_MANAGER(object_new(TYPE_RAM_DISCARD_MANAGER));
> +
> +    rdm->rds = rds;
> +    rdm->mr = mr;
> +    QLIST_INIT(&rdm->rdl_list);

Is this QLIST_INIT() redundant since it is already called in ram_discard_manager_initfn()?

> +    return rdm;
> +}
> +

[...]

> +}
> +
> +static void ram_discard_manager_initfn(Object *obj)
> +{
> +    RamDiscardManager *rdm = RAM_DISCARD_MANAGER(obj);
> +
> +    QLIST_INIT(&rdm->rdl_list);
> +}
> +
> +static void ram_discard_manager_finalize(Object *obj)
> +{
> +    RamDiscardManager *rdm = RAM_DISCARD_MANAGER(obj);
>  
> -    g_assert(rdmc->replay_discarded);
> -    return rdmc->replay_discarded(rdm, section, replay_fn, opaque);
> +    g_assert(QLIST_EMPTY(&rdm->rdl_list));
> +}
> +
> +int ram_discard_manager_notify_populate(RamDiscardManager *rdm,
> +                                        uint64_t offset, uint64_t size)
> +{
> +    RamDiscardListener *rdl, *rdl2;
> +    int ret = 0;
> +
> +    QLIST_FOREACH(rdl, &rdm->rdl_list, next) {
> +        MemoryRegionSection tmp = *rdl->section;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            continue;
> +        }
> +        ret = rdl->notify_populate(rdl, &tmp);
> +        if (ret) {
> +            break;
> +        }
> +    }
> +
> +    if (ret) {
> +        /* Notify all already-notified listeners about discard. */
> +        QLIST_FOREACH(rdl2, &rdm->rdl_list, next) {
> +            MemoryRegionSection tmp = *rdl2->section;
> +
> +            if (rdl2 == rdl) {
> +                break;
> +            }
> +            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +                continue;
> +            }
> +            rdl2->notify_discard(rdl2, &tmp);
> +        }
> +    }
> +    return ret;
> +}
> +

[...]

>  
>  static int
>  ram_block_attributes_notify_populate(RamBlockAttributes *attr,
>                                       uint64_t offset, uint64_t size)
>  {
> -    RamDiscardListener *rdl;
> -    int ret = 0;
> -
> -    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
> -        MemoryRegionSection tmp = *rdl->section;
> -
> -        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> -            continue;
> -        }
> -        ret = rdl->notify_populate(rdl, &tmp);
> -        if (ret) {
> -            break;
> -        }
> -    }
> +    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(attr->ram_block->mr);
>  
> -    return ret;
> +    return ram_discard_manager_notify_populate(rdm, offset, size);
>  }

This change introduces a slight difference, as it will perform a rollback if ->notify_populate() fails.
I believe this is acceptable since, currently, memory conversion failures result in QEMU terminating
rather than resuming the guest or retrying the operation. And this rollback is necessary if we plan to support
retry operations in the future. Therefore, we can retain this modification.


