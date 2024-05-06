Return-Path: <kvm+bounces-16701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A0FA8BCA68
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 11:19:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 112062839B6
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 772981422D8;
	Mon,  6 May 2024 09:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZqweZK1t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5301422C1;
	Mon,  6 May 2024 09:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714987173; cv=fail; b=PW/Yfe11Cvb1BvLaP/kg4Po8U07viG7oQmjPHOg+Bfr+fooL/0GFPtEYgI5DiEOYO76dWGqb3ghPtqWNv5dOrIwWU4UY8Ua2eQWQZH+0isELFnPfSgMaYDxU9qlPWxPtE5+wk1ZpMIbpcihcTWKiO/cN4Ez0aM03EWeOeKxip1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714987173; c=relaxed/simple;
	bh=aHoFCsiH5bMVnl3DDko48WioaVDN8ynJZvc8LdMtIFg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qXq2OLh9OZO2HbiXfqCpePaZdo2RAPtaeJ7M/rDlFJ2+S8POaM8EbQH05iAjM/m0sLErQxgjmeo5d5fMtIhh0IIpLoN69lgGeXnQDD3rNlwvMYTgK42SBHtqtPsLdMoKHuP2cwC2Qu8LNwNkpoVJlhvJ4Zd7HYVVJ3b67F4qvW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZqweZK1t; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714987173; x=1746523173;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aHoFCsiH5bMVnl3DDko48WioaVDN8ynJZvc8LdMtIFg=;
  b=ZqweZK1tKNfoTMyYd1PnsYOdbEqbgylhvf44FQ6CZHPpZZcOF/EmDaKF
   WdldCwnAHL/DWs/CHlCmoRez9QOriOL9lt7DiBEuJjqWama29Ov+ZSDHT
   8EC9tAkHUvqcLnCfFRGQSS3sN6iMWLopygePeHhwZt3IWL/TMhtn1mzyN
   cLh6PQ5HLcRIlEkEBmZfe2Q2BGja8j9okF4iTatSfPa0QDedLUNwV65cr
   4jtxhd9eNrbjO/DFOuBK74N4bDd9HdUmTWza7NpltYud2ULgzhe8kwIBW
   ZfmBeGoFtb0bXK/sqHkrB2AO+q1Gf/7ZwLo7tiVf5xF5UqMqPq4XOrxf1
   Q==;
X-CSE-ConnectionGUID: 84mvdNNXQYmf23UVLAozcA==
X-CSE-MsgGUID: UXwZfqnwQmChzBn0XWohOA==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="10880657"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="10880657"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 02:19:32 -0700
X-CSE-ConnectionGUID: pwNk+Fh4TAeZjdn8ukqp6g==
X-CSE-MsgGUID: nPhvIWMYTkiGStYMOHrnPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="65540933"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 02:19:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 02:19:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 02:19:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 02:19:30 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 02:19:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LEfwW5HBl6epze79lzbNP2LWOj17DtC6kwxGY7VsYz4QqwraKOsm3uksfkApKTtlWvxkYFQpCvSxuG00ez4OVFIkQPfpDaP4oHREt3SJg4Czl01sBivXHseMgo/hI5C4SodHDHVwj0Q0+OHNODWwQBc1vQaL4IrMs6yMhKeEbrr6dizAN5v5h0AqquCwwNOzvSZk11X3+FmyRwLcuOyN4WRbM0e1kYDOeII1UWGCFqrgGqMzPq2MD35v9Sbngew/HsIO/kHAbX+MnPYVvb/N+yO8u02m++T5Du/mBYD3F2wWplIWj7QeVz4MYUGB99sJYXFyXIrixvCWTIJ5Odx62g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YfOwh0aNrPsL3iv0Qllf4cu7nBe6G2a5MFgZX4LMPHo=;
 b=an2s2ANEfhiftj2B3v402avii6Ykvwnlt3JPBwYbCxvvkARPQfuJYmVzwYG8iNv1a7wKXbBqyASbIe/k/qwjchSXvoLhpyULxzjXjU7Zj7FjhraqzvFASvxeV1Yd+3biZ2vngsB9lEF6E9PYYSXbhUQ7IqsOUI8kkwnOpaIkbUitLyMR+RNX4WzA7xmNukVEEoWis6/PizTijo9Hlxr3NTGj7PQGhXaQAV5jjQs0hnZkxd2DEQKbFv2RXnh9HV1QnAr/8SnfSe7g0BBZubKwbgRS+ydnRXEL4WRhVH9hSYVyfr5ngYucWN51Nt6oEmKGcleTwqksVjZZU/0s3pdG3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA1PR11MB7110.namprd11.prod.outlook.com (2603:10b6:806:2b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 09:19:28 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Mon, 6 May 2024
 09:19:28 +0000
Message-ID: <e39f609f-314b-43c7-b297-5c01e90c023a@intel.com>
Date: Mon, 6 May 2024 17:19:18 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com>
 <ZjLNEPwXwPFJ5HJ3@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZjLNEPwXwPFJ5HJ3@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0007.apcprd06.prod.outlook.com
 (2603:1096:4:186::9) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA1PR11MB7110:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bc99361-ec2f-439a-b078-08dc6dada10d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cVE3Mk44d0V6ZWQxUDFaYnJHQkwycmVmbDIzQmN6d3E5RkI1bWpYQnFqSjQ5?=
 =?utf-8?B?b0oybEFjcVFSYjhzdGxlWXRiR3FFdjlNUTFxejVYQlVPbHRrRGZ5Y1U2bjQ2?=
 =?utf-8?B?bFk1aFJ6YmN2WUdiWXoySkdFbTJqYmdYVytETzlmL0NFOW9IT2ZRQ21icVVw?=
 =?utf-8?B?a0VCbkp5TDhDaXpGZURhMFVwS3luWlJPanVYNURzSjNDN0NncmJHY3NtTjBS?=
 =?utf-8?B?VXd1eVRDSUI1SFcwUTg4Q1Y5eG9RclRtQ3BGRGxYak9RY0ErcHltMzVxMVdo?=
 =?utf-8?B?cUNxeU1Td2wzUkl6cGk5THhnbHlKWUFFQUMzc082b1pQTlM4MnMxVmQwQ2JO?=
 =?utf-8?B?NXhPdVhEOFpsSStFOUxzMDJ5RjNOU3RrUFVoNU9aR2ZkS2Z3OXNmcDJITUQ5?=
 =?utf-8?B?M1RBSzBRMS9hV2oyYlhhYTNFa2RVaE01NCs3S1FpcmhNVGhCeXMyMkNMVG1T?=
 =?utf-8?B?bDRjb0xkdXc4YkVHOEJObUhHaVJCbXlNYzZEZzFnSzFOVzRSQXRDeis1eVpR?=
 =?utf-8?B?YjQxc016ODFaQXFJYldvbFRtR1F1djgrQzA5T3VUMGVTWjhZU2hQYkhQQzVw?=
 =?utf-8?B?QkxNU1Y5a2VXb212cUFibnZhQ2Z6bnRCbDdJbmk2MENDKzA0VG5LQ01oV3Rl?=
 =?utf-8?B?VjJ1NlB5MzhWbFVBKzZtU1d3TGF0eTVPV1lvb2ZKT1ZJaEVmdmxDdlBBNXAv?=
 =?utf-8?B?bnZ2U2l5N3BVbkcwNjViYzBMdVBMZ2VLS2xaOVNNeG5jMUpRcGsybWVKeVVk?=
 =?utf-8?B?MWZvck5Vd2NOOWdOeHNYcUtWT1NrM2R0RlJ1K0FHVEJmaTB6emRWRk8wd245?=
 =?utf-8?B?WFNEdlRvQU9QcmxWY0FjQUFlbklNRFNDdGw0K2t6c2dYRTNoQjExQVhLZzRq?=
 =?utf-8?B?YmNUNFFaL1B2Sm5mSkU4QXR5VHE0REMvdjE0RExBQVBSZXROMmoxU1l2eUN6?=
 =?utf-8?B?Mm0rT0Z2VnhnZWxEZUx5OXlSaWdWOWw3RmJzazFBb2w0dVFKMGt5Y2Mwa0hC?=
 =?utf-8?B?dlRwSXBGU2QxZ3VqR3FFVENRbExtNTErK0R2OXovSm1rb2p3aFpIS2FiWG4r?=
 =?utf-8?B?UXc1NHFSbjIyeFQyRUlEVVFURk5ZM0o4SnZHQzNCNXZCc1ZtME9GeHQwS1lF?=
 =?utf-8?B?WXBENDY0eE13TVBweXp5ZHYxWkdUMkwyR2hBdlNvYXFReDBvdVNqMEszTFpt?=
 =?utf-8?B?WlJuTXRuU2RJY3FYN0lGNDBDNkVkTFRzMGVnK0RZbFFJYVZQVDd5S1hMOEV3?=
 =?utf-8?B?S2hsSmx3MGJHQU9OZzBRVDRlU2ZsYm5yZlJsUFJCTlNsTFAyL2ZLbmYvamF1?=
 =?utf-8?B?cXRvc1l4aE5GeEhBZ2NVUFV1RjAwQkdSL3dKWkl2eHh5SHVRa0xYVXhLbEtI?=
 =?utf-8?B?eXFGVjZVM0pTWVlHOTBTSDFqcXphbFJ0REpIZTFlZ25XNllFcU5vMW9aR0lE?=
 =?utf-8?B?SWxlWThpVDllOVk0bGlLbXF0Um9CR1Raa3ZLVjBnMHJZOFdqRFpYL0dRcS9M?=
 =?utf-8?B?LzF5dWFJNG5VTVg4ODQ1Mm9aMWZXdkk5TS9vNUZ1UzdYMnBVQklXNTZOMVpQ?=
 =?utf-8?B?bzJod01zczF6L0JIUGs2ZFFVSXRXWEQzdkxDZkkzNlJSOUF0M2NDQ0w2S3pr?=
 =?utf-8?B?TWtNdHdhcEhrWlZQZ1dnTk1KUDJaSVJwKzRTMDFxVkRGczljU1JhOXplTXBi?=
 =?utf-8?B?V2ZNTEd3QjhKZHE5WDN0U1Q3RjVJaldydmdSaDV1V1hsOXRXRFNYL1lRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjZXWFViekMvY1ZvSkZyNldFQ1RiMEt5azZRYTdmNjZPWFMzbHQweDJJZEo1?=
 =?utf-8?B?aWlaY1IwQkdKUDBZby9pck14ZXRBSUd1Y1Y2ZkdvYk83NmlrUm92SVN0OG54?=
 =?utf-8?B?NjVlQ2dqS2wyckdMTUFYOUpyNFlvMXlvWnltbEhGZ0lsVk1YZk9lU1Z1am9z?=
 =?utf-8?B?SitRTnNMd2NkQWNhd3puc1pWQjNqWG9zYjFESjQyeHJYcXA2TjhQajd1eUZ5?=
 =?utf-8?B?ZE1GRkVHdmNqUVhtYXhxbHMxUEU3KzhQbFFtdms2ckZpTGtlbitybG42Kytq?=
 =?utf-8?B?N1N1UlF5cUNqbzNBUjJmQXpGSW5ndlZyOVFtMVNYR29mbldOenpSTy9mU1U4?=
 =?utf-8?B?S2RpUDNsRXd6MWpmNWNMejFQaWpLa3NmMzU3clJscFBRWjRoWlcybGNGSXhn?=
 =?utf-8?B?dEpIaFY4UXh5VUQ1NUI0WU8weHFQNE9rRmQ4ZndxQ2tsaVEwYk5kTUdFdm9u?=
 =?utf-8?B?d2VESUVIdjJiNEgreUQ3NXJHU2M0VDh2MmVNdm9wbDRQb05paDhoZFdGQnJW?=
 =?utf-8?B?Z2FOOW9lTGNOOGZ0SWlLWmFoMEgxL0lGOVJWTUxDb1NWMGphblIxMHErR0lF?=
 =?utf-8?B?Q09TM3F2QjFwMGp5U0VBNkRubkJ4ZWJmT3ZkbW5NNklNeUlLTGhkKytFS084?=
 =?utf-8?B?R1dZeXNSL3RIckZzdEVXaDhIL2RhNi9OZjlCVFdGeVFDZnFXWDdnOGlsbGZk?=
 =?utf-8?B?OSs3RGV4VjBHUnZxNjBrYldOeGhENTlrVGxvN2dzSFl2UlUzY3dTK1ZORHA2?=
 =?utf-8?B?cFJ2K2c5Zkh1K0pGTGxmcm8wUkh6WDlsM2k3S2p0RFVRNEx6RjRJSExITENa?=
 =?utf-8?B?NVlmb1BmdWZSK1EzSzNsWFVJakFGTmlHZzh3V2lQVXRSVC9nbXNZRE90Tzds?=
 =?utf-8?B?Mi82Um9LalBzbnpjVDVKTUM0QW1JUFRrZ0h1cTFwekNBUXdHTHNibXl6SmUx?=
 =?utf-8?B?UzdRc1UzT09QV2NtMDNlT1N4VmpqUlVlUFVHR3p5eTY3TUdnUzVUZ3g0Z3pS?=
 =?utf-8?B?VlltMEZQdUVPc2V0TUsyZ3daME1MT290bDZzQlFGZXNOemxMWGl0dEYxY3Jj?=
 =?utf-8?B?UXlwQ1poQWJ2dkdsaENXMC9CS2h1QnVsTzA4NzdmZ0t0aHN3bDB6SHVjNHg3?=
 =?utf-8?B?ZC9aYVhoZHdVWk4zM09vNEowcDZXQ0ZkcVg3Y0dINTd3dzlFMmR0KzhScEdK?=
 =?utf-8?B?ZGZCV2lSMFZuM3BZTEU1bmdPd0FDRDNYNmRRdEltdWg5V3FCM2hqSXg2WDNk?=
 =?utf-8?B?aVNHY1RMRTh4YXRocEJpVkdneU4yU1BhbUs3Q0NQWUdUWXRQbnBlTjZkTGph?=
 =?utf-8?B?Q04wL0x2U2RJdWYvUFk5S3NmRDVOZXp3ZGxjQTRjVldYUHB2ajFaWEg1TWln?=
 =?utf-8?B?VFJ1SmcvcVNsMUhUa0NMYXp4TWpCN3ZhNnl1ZFRVcXJxRXE4ZzAyeVpoYXFP?=
 =?utf-8?B?UXJCYUlRRVJibHprY2t0b21LZ0ZIa2lTUFNDd2ZrZ3VVTVJKV01PVnBXQld2?=
 =?utf-8?B?dzh4aVFncjJhLzZxcGhPTFRTUmt0OS81WVpvcXkyOXNTRUdybEN2T2lBSXVM?=
 =?utf-8?B?T3RMQlpKWmhjaXRscjZWNk9KZUx1bitQMzQwSGZTNUhQb1Y3YmhiSnhwYy9v?=
 =?utf-8?B?QWFxcDEzcWdwa3FXY1B3eEl6RFRVNDM3eFlhMGkyUURNeW5rZk9ac2lpMkVF?=
 =?utf-8?B?aDdyVm5KeHUyYWZPQ3BuTGN1eVB6L1NuQXYxam5uU05QWWhqalFUWDZPdERo?=
 =?utf-8?B?ZVRaWUF2UDhHNVlIMCtsRFBVT2ljL2g5Ny9KdFg3MTlTVmdYb0wrZ2xrcWxV?=
 =?utf-8?B?NC9HU1JPUVZFYlBRNEZ5bFJjTHFJamxaMmxMdUxFWW5QZDV3R2NCd29CdGpn?=
 =?utf-8?B?L1hocUlCUGJBTk5Ia2lhMnJvZkdNQ1NsLzlIajMybCtjdmZ2UFA4citpdEJX?=
 =?utf-8?B?eTM1R2Nob0syQnVVb3Q1OGZLZUdpbHRtMDVMWjF5SEl2Y01SRlY5UGM0V2c4?=
 =?utf-8?B?cEdtOERzMWlnV05FdHp4WnpCY1d4R2t3VFc0UEVGelJoU3VkbzVsYWJTZEds?=
 =?utf-8?B?NFZOM2h6eEZtQnlSU1JOdFI1b29LKzkrbXI3R3VPKzZFSHpYSnpCMVdXYUpN?=
 =?utf-8?B?WjN5Y2xIVm5QM2UyUGV0R1IwVTVNcmErNW84L2hjQ1pWQzBDYUJWbmdjWVVa?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bc99361-ec2f-439a-b078-08dc6dada10d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 09:19:28.2164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7m0UlwBWFO3+zi6SbTKoYt15yLbsgCPnqyI244gYsFWYikuerb3cIPz2u9lbHZOwoEC9qESRxRuxKlh4EWH5ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7110
X-OriginatorOrg: intel.com

On 5/2/2024 7:15 AM, Sean Christopherson wrote:
> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>> @@ -696,6 +697,20 @@ void kvm_set_cpu_caps(void)
>>   		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
>>   	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
>>   		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
>> +	/*
>> +	 * Don't use boot_cpu_has() to check availability of IBT because the
>> +	 * feature bit is cleared in boot_cpu_data when ibt=off is applied
>> +	 * in host cmdline.
> I'm not convinced this is a good reason to diverge from the host kernel.  E.g.
> PCID and many other features honor the host setup, I don't see what makes IBT
> special.

This is mostly based on our user experience and the hypothesis for cloud computing:
When we evolve host kernels, we constantly encounter issues when kernel IBT is on,
so we have to disable kernel IBT by adding ibt=off. But we need to test the CET features
in VM, if we just simply refer to host boot cpuid data, then IBT cannot be enabled in
VM which makes CET features incomplete in guest.

I guess in cloud computing, it could run into similar dilemma. In this case, the tenant
cannot benefit the feature just because of host SW problem. I know currently KVM
except LA57 always honors host feature configurations, but in CET case, there could be
divergence wrt honoring host configuration as long as there's no quirk for the feature.

But I think the issue is still open for discussion...

>
> LA57 is special because it's entirely reasonable, likely even, for a host to
> only want to use 48-bit virtual addresses, but still want to let the guest enable
> LA57.
>
>> @@ -4934,6 +4935,14 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   
>>   	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
>>   
>> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
>> +		vmcs_writel(GUEST_SSP, 0);
>> +		vmcs_writel(GUEST_S_CET, 0);
>> +		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
>> +	} else if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
>> +		vmcs_writel(GUEST_S_CET, 0);
>> +	}
> Similar to my comments about MSR interception, I think it would be better to
> explicitly handle the "common" field.  At first glance, code like the above makes
> it look like IBT is mutually exclusive with SHSTK, e.g. a reader that isn't
> looking closely could easily miss that both paths write GUEST_S_CET.

Sure,thanks!

>
> 	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> 		vmcs_writel(GUEST_SSP, 0);
> 		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
> 	}
> 	if (kvm_cpu_cap_has(X86_FEATURE_IBT) ||
> 	    kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> 		vmcs_writel(GUEST_S_CET, 0);


