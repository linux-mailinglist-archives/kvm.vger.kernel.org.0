Return-Path: <kvm+bounces-25700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 208D396919C
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 04:58:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97CCA1F238A4
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 02:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DC961CDFA0;
	Tue,  3 Sep 2024 02:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S8aYINzH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8576D1CB523;
	Tue,  3 Sep 2024 02:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725332308; cv=fail; b=rutOx0JDffB7w79A6/5LFHfk33veGCjDyIQFFM2PWeu+73AIXjG2g7MZ/dwaLWfQu7XgM0sr4WLqxqBepyK3vnTq5L+E+4vveKiY9oki5oOIFAkBQSgr954I0I9N3FEirX/HGa3hLo4AamklaLs0+T3RqBGJWktITexrODsWJ/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725332308; c=relaxed/simple;
	bh=LE5Rkc/TMWSYBIMz3fgeUJzx5Uoz9PfKkF8to4ltuxM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mf0uv7nBMduwewbvaZqc0+wEZ5JhrUqEgJGi+NlhWGYFhD5nuJKG0r4wz88ea7zNAsVSaP+CUPzX5g1gwv5aVGQqDGfGWDj2JPUacFpR5o2aoYuZNAE9LqFZJn9MXmYcBKXoVeDqyrouuzKmwnAXcHwCpv/v8uG0bDGr/BErgnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S8aYINzH; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725332307; x=1756868307;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LE5Rkc/TMWSYBIMz3fgeUJzx5Uoz9PfKkF8to4ltuxM=;
  b=S8aYINzH8zCRJrqidgzvPaIE5C6/PVuD6ywI2XawgjdaEeG8KA6fydwU
   7Od6B6TaQwq/hbqY5q5Sy/jtZFSuleZGEEOLQN5WddN2ero4ERL2hLCuR
   SW5LIoAGGXaU8+3opUKw5zOuws4/c/pXoYMgDSQR1WppB3QA3O0A9UPzB
   jm4mXCwgpZTcvzBQ+uRmh/Mej8HzunKYlDIQ4L4r1UlrMnBGVcoAD+ols
   1V6FydfcwbQK8Endvdf/oDo/ZYQ6Cqr0M2XJRzOEJxrOsg8tPvdVzKUi/
   YnK7OIRAjnmePF5gazY2vTxrAVKulXDdw+PMzfrd+V4gXQ6OsLeEQkoz2
   A==;
X-CSE-ConnectionGUID: 5g62u1PFTw6K9THb+hpaTg==
X-CSE-MsgGUID: CA6qrgQHSv2YwKebeSaljw==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="23425004"
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="23425004"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 19:58:26 -0700
X-CSE-ConnectionGUID: W2rsSK5wQsOfTwipNxDv9A==
X-CSE-MsgGUID: +OtREI11Sdq5THj4IFKCNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="95482353"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Sep 2024 19:58:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 2 Sep 2024 19:58:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 2 Sep 2024 19:58:25 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 2 Sep 2024 19:58:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iM5flQowVvBTTkNWLELL7ZCHxdYkXGTL4V45WgmFYu8jVsdmokTRgiTYccNk6+TYfQblUC9laLhAGgMMTLJqX8hzz5dKPElw1vNikCdqojgugQfIrszc48eJzWFwA7hEaWXX0RmctreBJOG7WejsEnJv7YjLThMrx6Ca0Fzzi37ry6zAn8BCzvQ8i/X6v5NuNn/XuezF89mo0NTbqUdprmfeNpp13vhmTNo73UHa/ODIDMtbY9ecwX9wViTY8aK5CmGi/CC38Rd46ajRcoLanWqHAAeZ33uS+ZavMeKSF2uiUUkRKOikipV8N6Ex+NRhxFPDpUDGq3q3PSWmeyFuVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oGOcWXDfFxqqDd0AEn19aqGp37LH0CUff0gYsOoSXVQ=;
 b=Hit+RufQTe6d9ihVLoe6FmkMsp+xKskN9Ook0YYjfyhA0n3zE18wUeuGHfuFkFU8pMHKLctKfahaVkkVFWBEspivzgTFl6X1L+cToL8jvmBqPaafi+f47LchQg8twn+MjgOmVg2c5ervGqA/w/ue/uvhh2vFkigZuyZu5zX3/8VtdqGbZ+kKk8GdvsNXIm6T+CyED1RKzOqR6mX3C8kBHkc16UNxY64Tvt5eiZ2mDt8tUqrQN2uL/FRzQZXGoHyhu5aALP9oBvM3FkKwRDadgXAqFrwYOPmLlaj9sPI6xlXwHGWDMH8wy4e3QuQhycf4J5ofJQbi6VxJPhs0ufwpTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CH0PR11MB5300.namprd11.prod.outlook.com (2603:10b6:610:bf::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.25; Tue, 3 Sep 2024 02:58:21 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%3]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 02:58:21 +0000
Message-ID: <43a12ed3-90a7-4d44-aef9-e1ca61008bab@intel.com>
Date: Tue, 3 Sep 2024 10:58:11 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <isaku.yamahata@gmail.com>,
	<tony.lindgren@linux.intel.com>, <xiaoyao.li@intel.com>,
	<linux-kernel@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <20240812224820.34826-15-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0016.APCP153.PROD.OUTLOOK.COM (2603:1096::26) To
 DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CH0PR11MB5300:EE_
X-MS-Office365-Filtering-Correlation-Id: a730e336-e4da-4c20-f50d-08dccbc4450f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d2FNZnQxUmRxWSs1UUdLY2JCT2lSVzNaK3lZczlKRDNjb3o5NzAyTWo0S0I5?=
 =?utf-8?B?SDNabi9RaVlnWlRzbVdiSEhVVlV2Q2RKQUo4dzlWcXF3VHkybDE5UGVJRWJz?=
 =?utf-8?B?YnRxMEhVc01LMStNaHFJYkphOVJNblRPUWJvOTV5OEV2U0hwNHFOMjB5WFNn?=
 =?utf-8?B?WGhYenJJYVZqYUFtSXhNeWZyWFc4SXhxRUhvcUpIVXNYalBEV1paWEk4eWti?=
 =?utf-8?B?L211cCt4Q0xseWRKV2VRbU9pd1ZURnJBZm1JbWErazZEYURuWUlXL2pBMnRr?=
 =?utf-8?B?WHhXeGowN21kU0wwU2E2VXNlMVphOFdHZjUwc3dweW5maVdXekVMTk44STZW?=
 =?utf-8?B?QnBpZm10Q3BYU0RsbEtrMlJLd0JCbk5XZHdpME9VODROKzJpU0d6YmRUcXp1?=
 =?utf-8?B?VlpCY1BxaWV3TXVTUm4xUDlWMVdRaElNRVNicDdOaHVmcm1HcC9QMlUwMW9Q?=
 =?utf-8?B?TWZ3Mm50SU5xY1lNUkJxWjIrQmJsVTFFbkxDc2ovOG53K3U2TktaWlNmcTRy?=
 =?utf-8?B?MTVvS3pxbHYrTnRpQW1IZEdNTFZGQ1ZNUmwvOEdkcHFQWEhwbi94RVRFWExT?=
 =?utf-8?B?ZzhLMUhNdlI3YzdlbjFRd3FPK2FiSTJTdHZTdDNodFBGcVpJQUtlbnlqZGZV?=
 =?utf-8?B?aXYxc2RLNk93ZGlwNEJwNGxkYWlucEcwOWZZdWZ5M1V4Q3NDN1VpWWJsaWg3?=
 =?utf-8?B?Z0RINUhsZVZhaHBldS9qVnJUSG1kQzJ2K3NGdlhtMkQ2QU82bFFHOThJQVI0?=
 =?utf-8?B?cVdCNDVCWFUrT0hEOExSU2ozSkFFbDNza2ZZL3FyQkI3TS9kelYxTHpkb2pC?=
 =?utf-8?B?ZzBKNGM5VnV4aHNIWVhvd0pERzN5RTZVZ0tPYWlocXNvOE5vMmRFNEg3RlFi?=
 =?utf-8?B?YXczZWl5QjR3WHBxTlREN1dqcmRqSStid01OWmpsajg5bWFhTERnL0VDRE5h?=
 =?utf-8?B?YnBaYXY3bFNSWDZST2pvdy9OMVgzdTROeE1XQ0p1RjBnVTBnZXhNU2UvR3dq?=
 =?utf-8?B?aDhpRDBkSEozOGdGSmUveHFCb1F0V2JQczkvTGQ0eTVieWRSZmdKcFRtWjZG?=
 =?utf-8?B?UEdzeklESWJNL0k1MXl0VG5VdlVVdzBqMmxuc2JjelNBMlE3U0JSV3dmY1dF?=
 =?utf-8?B?RWUzcHczd3VlLzBTbnFYZ0ZaK2lzSlAxR2xUZVdNM2gxU1pxS1hwcGJNWDZR?=
 =?utf-8?B?TlFEdjRQVFVHOVlhS1locVlJQldvckpvM2tGcytFOUZPbnFlWVlUbDV0NHE3?=
 =?utf-8?B?cVVHMzc4TTZhY2VSMXczREsxMWZxai9DMllzZnJkSm5MR1hBRE1xL3dReml2?=
 =?utf-8?B?bnhOZTE5ZFYyMDdZYUNXcHBWaG1qMnpJME1VMTRhdzFkQUw3UXZFajBtQ0lG?=
 =?utf-8?B?SWxhVDduRC83TEs5bFE1cDlJbWtyYjlZY2RXRWViWjBtSWY1TS9EVnloVHhN?=
 =?utf-8?B?ckhnTW02b3dDK0NsVzZZWDI1QTNWNkU0QVZiUXNKZ21kMGpzdmRsWDlKTndY?=
 =?utf-8?B?a1FjR0JOYXR3N1J1aHBoUGVYeU9SLzB1NFhHMVp0azRUTWV3bkNCbzNqMG1w?=
 =?utf-8?B?S2dlNlRkZ3VLV0xyS0ZLc0dXNnM2eHRyZ29QemE5VTJrVnlVT1VGa01ZbjhC?=
 =?utf-8?B?azFaWjFLc3pKanlYaFJOS1Zvd3hxbGZ3QVJhaXFXRS9sZ2FndG5sR1JGMDdX?=
 =?utf-8?B?aDN0TjE4bXZMYXNOdGJHeVYvZVVKV2tSRFIzQ3JlY2hiRkZ1TTFVK3JNK1JX?=
 =?utf-8?B?cHcrSVMvWkd3TlloaFZ6Yk5VSkhDTkxoVHV5WHJHemF4L0hxL21PR2xuM1Zu?=
 =?utf-8?B?RXlHZC9pQnFCUlJHUVIzdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDVoeTkwUXptVXlKY08yNkNvOUE2OTJoa25YajZiSzFZY3lzYS9rblJaQ0tE?=
 =?utf-8?B?WG9mTnJ3MmZqOU1UZHFxaDZTY0IyTExxZTBvU0tPdHpRazZYQ0JObnVYTWdr?=
 =?utf-8?B?THI3SWxwUDA0SWpNVjJITHdTSU9OcWhwRWFyS1FFYXd4N2ZiZ1JOMUprOVF1?=
 =?utf-8?B?OS9reXdEMXpPbkJzNUs5eURjc2JvNVpmK2k2NDAxS0tzaFNWNVZkbi9rVlkz?=
 =?utf-8?B?S3pBR3oxbjNVNDdqUEM4L0MvVzJCaElTVFRxT0t6L1kveC9Xd2dGdzdlTkJB?=
 =?utf-8?B?NWhoOFdDdHkvK1QxbUU5N1JqbThEOXZEVzlIbndleUZzSTRGaXRqMkwrTHZ0?=
 =?utf-8?B?NzlXRDcwRWlQQTMrMjV2dFVRQ29mRTR4RS9VS0xKRXh3WEVHOWFoL0dpNGZ2?=
 =?utf-8?B?Q2NabW1rcXVzYVIwMlRNbjJkZXJIa04xM3RlZ3NMMDZCbS9Pa2t3VXlMRWJL?=
 =?utf-8?B?dkdSVml1MERsV2NIZy9RVUVLUXpFZVY1TWp5V055L1NnbWVhQW03SmlidUF6?=
 =?utf-8?B?OG0xVXRVZzB2MjZVdGh1dnJpNEkvMDVLNlpjTS9obmIyWEVETzZTdC9UeFlD?=
 =?utf-8?B?S241cmtXd3RCcmUvRTAzUDdjS0xDWnVZYTUxcTJMSjNKOXJmWWJnakcwamZr?=
 =?utf-8?B?U3lsbmFWMFl6UGd1YnhyUEhkU1Z1dlI3cVRsdVlia1BMeXhjYm5MQ3VXTmhy?=
 =?utf-8?B?bUxMVC9sR080UDFSNk42NXZ4TUFYRFdBNlNWMUpCbkpsR2lqSHgrSk92Z0Q1?=
 =?utf-8?B?WGtYNExyTnV1cGNHRmprMk5OWWNZSXdlSlV4YnhhNThUMldUY1lVNDlzUkpy?=
 =?utf-8?B?K2pHZXNxR2RURytMVGlsTTBsdzJqckQyTnBaMUo4cUlXR0ErRGJiQUwzM043?=
 =?utf-8?B?d0h2V1NKbUt0T2c0TVFpS1REeXpST1RCSXA2V0UzYzNicDJqbGw0ZU1QSVBv?=
 =?utf-8?B?Z0VaMXBsM1ZpV1NPbHFqOXFDRnVtc3dvS2lIQzRwbkpVQUlPQ1JBZHdUYnFk?=
 =?utf-8?B?YVFhQ2Y2ZkRPT3Bta0p6OTY1akVzNllHRGJuS2RZY0NRblNJWXRCM2N4SjZp?=
 =?utf-8?B?ODIyMFlvRVZ5enBLNFJ1S0RFMlFKTWI2L3NLVzc1UTIwc0JwU1JZRzZtUytB?=
 =?utf-8?B?M1FmMjd4dWdaR3pNT3Y4OTd6Qkw1T3pkbGYrZHlsMnJEcWFZaHhuSGw1ckdI?=
 =?utf-8?B?dUc2MkZnSnFiUm5USkgyVVU0VXNqOUYwZC9TN1g1cFBHRytJdnJrNFprWER3?=
 =?utf-8?B?ZVRFTVFPV3pwbXczQWRFWVg1UkpaV1IvK1A3ZlZqdHVJTGdCeHRDL1o4MGsz?=
 =?utf-8?B?ZEl2eE1Nakw4RzI2VzMreFE3YXJzT29zanI1Q0NkdEhXL05Kc1pFSUJBUFlD?=
 =?utf-8?B?Y05TM2NrWkRqQTA2MUZHeFVXMFhtcEMxZFVreTB3SDJadVJqRTZJTkRlbSsw?=
 =?utf-8?B?ZUx2akk5cUpxV0MyUkNOUHNSWWphSHk3WXE5NVozdTdZYm1RZ0lGcVJWektw?=
 =?utf-8?B?WGVMaC9YN2VSSGp4UXJmU2JvbWUydDlkNlZteWlpMzluWXJuL1h0SGtpOG1F?=
 =?utf-8?B?TnNTazVpaFEvcnhVbUNyb1JIZU9ZenJxbzdsZ1dsOHppVTNYbStySlM0RFRO?=
 =?utf-8?B?WnVOTWZoRVh6UHlTR1ZmMjA1KzVsT0R6KzZ2Q3hiN2s4TE1nemxwNE4yWUlG?=
 =?utf-8?B?bTExQzdLeE5pMDY1V1ZwL2Y3WkxUbWREbzNVVGJnNjdQdm91L0xJSkloVnc5?=
 =?utf-8?B?a09vaDFieXlvQUtEenY2eDJGZHkvY3RMQmtaVnBPdlBWNDFXNEl1Y05BSjE0?=
 =?utf-8?B?THBFeWFHYURkVXNSeS9JcXdpWHE4ckZ3WDQrWEtmK0VwV2x0UUIzYVhYU0Ew?=
 =?utf-8?B?Q1ZzbkRJZHdEWmR3Uk1WRk1KTiszcjlkRXpqbDE0Zk95OHEwOXhNRklPSDVB?=
 =?utf-8?B?WkxQTjBHVjJtREh4SzBNczFia2IxbE11bmNOZXNTMXUveXpLeDV3bXZkalpn?=
 =?utf-8?B?dWI1cG1lZzVmTS9FQzBXd2RLa3djbkNiV1hUQkRKTTdCb2FJSGY2QkRja2NG?=
 =?utf-8?B?UExnbzMySGxWWVdsNkJnQmlqTjR5UmJ1NEdtL3N5QVYyVXlPcUgraVpjMFVI?=
 =?utf-8?B?RHZ4TW9OdVRiUzVBd1dJRjVHYkQzR0JlU1czbkdtbWdEZHo4WTJScW9lU1Nh?=
 =?utf-8?B?QXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a730e336-e4da-4c20-f50d-08dccbc4450f
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 02:58:21.5382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yC6qUCCHofrkKpECDPPl6VOYO1uqOEiaygykNNH7YWxHvl6QIhm7Rg0PWRk/mw1JFfjy8LhFEetDE1Hk2M+dkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5300
X-OriginatorOrg: intel.com



On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> After the crypto-protection key has been configured, TDX requires a
> VM-scope initialization as a step of creating the TDX guest.  This
> "per-VM" TDX initialization does the global configurations/features that
> the TDX guest can support, such as guest's CPUIDs (emulated by the TDX
> module), the maximum number of vcpus etc.
> 
> This "per-VM" TDX initialization must be done before any "vcpu-scope" TDX
> initialization.  To match this better, require the KVM_TDX_INIT_VM IOCTL()
> to be done before KVM creates any vcpus.
> 
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v1:
>  - Drop TDX_TD_XFAM_CET and use XFEATURE_MASK_CET_{USER, KERNEL}.
>  - Update for the wrapper functions for SEAMCALLs. (Sean)
>  - Move gfn_shared_mask settings into this patch due to MMU section move
>  - Fix bisectability issues in headers (Kai)
>  - Updates from seamcall overhaul (Kai)
>  - Allow userspace configure xfam directly
>  - Check if user sets non-configurable bits in CPUIDs
>  - Rename error->hw_error
>  - Move code change to tdx_module_setup() to __tdx_bringup() due to
>    initializing is done in post hardware_setup() now and
>    tdx_module_setup() is removed.  Remove the code to use API to read
>    global metadata but use exported 'struct tdx_sysinfo' pointer.
>  - Replace 'tdx_info->nr_tdcs_pages' with a wrapper
>    tdx_sysinfo_nr_tdcs_pages() because the 'struct tdx_sysinfo' doesn't
>    have nr_tdcs_pages directly.
>  - Replace tdx_info->max_vcpus_per_td with the new exported pointer in
>    tdx_vm_init().
>  - Decrease the reserved space for struct kvm_tdx_init_vm (Kai)
>  - Use sizeof_field() for struct kvm_tdx_init_vm cpuids (Tony)
>  - No need to init init_vm, it gets copied over in tdx_td_init() (Chao)
>  - Use kmalloc() instead of () kzalloc for init_vm in tdx_td_init() (Chao)
>  - Add more line breaks to tdx_td_init() to make code easier to read (Tony)
>  - Clarify patch description (Kai)
> 
> v19:
>  - Check NO_RBP_MOD of feature0 and set it
>  - Update the comment for PT and CET
> 
> v18:
>  - remove the change of tools/arch/x86/include/uapi/asm/kvm.h
>  - typo in comment. sha348 => sha384
>  - updated comment in setup_tdparams_xfam()
>  - fix setup_tdparams_xfam() to use init_vm instead of td_params
> 
> v16:
>  - Removed AMX check as the KVM upstream supports AMX.
>  - Added CET flag to guest supported xss
> ---
>  arch/x86/include/uapi/asm/kvm.h |  24 ++++
>  arch/x86/kvm/cpuid.c            |   7 +
>  arch/x86/kvm/cpuid.h            |   2 +
>  arch/x86/kvm/vmx/tdx.c          | 237 ++++++++++++++++++++++++++++++--
>  arch/x86/kvm/vmx/tdx.h          |   4 +
>  arch/x86/kvm/vmx/tdx_ops.h      |  12 ++
>  6 files changed, 276 insertions(+), 10 deletions(-)
> 

...

> +static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
> +			 u64 *seamcall_err)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>  	cpumask_var_t packages;
> @@ -427,8 +547,9 @@ static int __tdx_td_init(struct kvm *kvm)
>  	unsigned long tdr_pa = 0;
>  	unsigned long va;
>  	int ret, i;
> -	u64 err;
> +	u64 err, rcx;
>  
> +	*seamcall_err = 0;
>  	ret = tdx_guest_keyid_alloc();
>  	if (ret < 0)
>  		return ret;
> @@ -543,10 +664,23 @@ static int __tdx_td_init(struct kvm *kvm)
>  		}
>  	}
>  
> -	/*
> -	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> -	 * ioctl() to define the configure CPUID values for the TD.
> -	 */
> +	err = tdh_mng_init(kvm_tdx, __pa(td_params), &rcx);
> +	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_INVALID) {
> +		/*
> +		 * Because a user gives operands, don't warn.
> +		 * Return a hint to the user because it's sometimes hard for the
> +		 * user to figure out which operand is invalid.  SEAMCALL status
> +		 * code includes which operand caused invalid operand error.
> +		 */
> +		*seamcall_err = err;

I'm wondering if we could return or output more hint (i.e. the value of
rcx) in the case of invalid operand. For example, if seamcall returns
with INVALID_OPERAND_CPUID_CONFIG, rcx will contain the CPUID
leaf/sub-leaf info.

> +		ret = -EINVAL;
> +		goto teardown;
> +	} else if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error_1(TDH_MNG_INIT, err, rcx);
> +		ret = -EIO;
> +		goto teardown;
> +	}
> +
>  	return 0;
>  
>  	/*
> @@ -592,6 +726,86 @@ static int __tdx_td_init(struct kvm *kvm)
>  	return ret;
>  }
>  
> +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct kvm_tdx_init_vm *init_vm;
> +	struct td_params *td_params = NULL;
> +	int ret;
> +
> +	BUILD_BUG_ON(sizeof(*init_vm) != 256 + sizeof_field(struct kvm_tdx_init_vm, cpuid));
> +	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
> +
> +	if (is_hkid_assigned(kvm_tdx))
> +		return -EINVAL;
> +
> +	if (cmd->flags)
> +		return -EINVAL;
> +
> +	init_vm = kmalloc(sizeof(*init_vm) +
> +			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
> +			  GFP_KERNEL);
> +	if (!init_vm)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(init_vm, u64_to_user_ptr(cmd->data), sizeof(*init_vm))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (init_vm->cpuid.nent > KVM_MAX_CPUID_ENTRIES) {
> +		ret = -E2BIG;
> +		goto out;
> +	}
> +
> +	if (copy_from_user(init_vm->cpuid.entries,
> +			   u64_to_user_ptr(cmd->data) + sizeof(*init_vm),
> +			   flex_array_size(init_vm, cpuid.entries, init_vm->cpuid.nent))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (memchr_inv(init_vm->reserved, 0, sizeof(init_vm->reserved))) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (init_vm->cpuid.padding) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	td_params = kzalloc(sizeof(struct td_params), GFP_KERNEL);
> +	if (!td_params) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret = setup_tdparams(kvm, td_params, init_vm);
> +	if (ret)
> +		goto out;
> +
> +	ret = __tdx_td_init(kvm, td_params, &cmd->hw_error);
> +	if (ret)
> +		goto out;
> +
> +	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
> +	kvm_tdx->attributes = td_params->attributes;
> +	kvm_tdx->xfam = td_params->xfam;
> +
> +	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
> +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(51));
> +	else
> +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(47));
> +
> +out:
> +	/* kfree() accepts NULL. */
> +	kfree(init_vm);
> +	kfree(td_params);
> +
> +	return ret;
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_tdx_cmd tdx_cmd;
> @@ -613,6 +827,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_TDX_CAPABILITIES:
>  		r = tdx_get_capabilities(&tdx_cmd);
>  		break;
> +	case KVM_TDX_INIT_VM:
> +		r = tdx_td_init(kvm, &tdx_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 268959d0f74f..8912cb6d5bc2 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -16,7 +16,11 @@ struct kvm_tdx {
>  	unsigned long tdr_pa;
>  	unsigned long *tdcs_pa;
>  
> +	u64 attributes;
> +	u64 xfam;
>  	int hkid;
> +
> +	u64 tsc_offset;
>  };
>  
>  struct vcpu_tdx {
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> index 3f64c871a3f2..0363d8544f42 100644
> --- a/arch/x86/kvm/vmx/tdx_ops.h
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -399,4 +399,16 @@ static inline u64 tdh_vp_wr(struct vcpu_tdx *tdx, u64 field, u64 val, u64 mask)
>  	return seamcall(TDH_VP_WR, &in);
>  }
>  
> +static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
> +{
> +	u64 err, data;
> +
> +	err = tdh_mng_rd(kvm_tdx, TDCS_EXEC(field), &data);
> +	if (unlikely(err)) {
> +		pr_err("TDH_MNG_RD[EXEC.0x%x] failed: 0x%llx\n", field, err);
> +		return 0;
> +	}
> +	return data;
> +}
> +
>  #endif /* __KVM_X86_TDX_OPS_H */

