Return-Path: <kvm+bounces-28120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FCF7994355
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 11:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FB9E1F24FB2
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 09:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9D171C1728;
	Tue,  8 Oct 2024 09:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TDtm/3+p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F6A198836
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 09:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728378005; cv=fail; b=JDMZtCS0rZtdEtEqfYS89yUaOmeONWllOUee6FRSbYiFUzcZfmw7v+DsIxcxmJN9GZE+BieNumULfJVY/cMesbEgM4hP+NMjo2JJn9xlfRa5bokTUofWgxMnoTgxrzqWAo6xdEgB+waSsMCEY+M6hJkY4Q4lPMNO+DIuUGOHD4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728378005; c=relaxed/simple;
	bh=/sMKzqMvFho5wgrWSFn7EF7qsL/Krs3bK2z7hvgCnfw=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ghBYCyPtvcAA/cFB74PwGcz/PoR5jEIkYJJfeDZcnzJ3M1aUWdmBpn0zZ8esytu/Ln9jVZVLFQ4tQQ/Rqhin9Npl+awmvZF9bI6WtOXfxnzskAguuzADj69ynnITlbVBuak/MHidz+MLHubi6BZknIgkG03gr/vNsq+8Htcko64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TDtm/3+p; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728378002; x=1759914002;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/sMKzqMvFho5wgrWSFn7EF7qsL/Krs3bK2z7hvgCnfw=;
  b=TDtm/3+pNeHeI4lHHeOq/NZA2RM/kMw3fmhQQD2qdElSoALK4RU33roD
   g0Tdy/aFMe5OXrHMCc+GKuizbeM71gY+TJe929VirgvXZwL7SDSRqGjWk
   MTZszji/EKU1+lx8bNChhcTqsNz0BQ4Va2eNzm67r1Azqhlfy9H9SDYex
   Lx9HrI6UmqSVXs5uKH8IAZ2PPQ8L55/4z0o4ijw1wrV1vqMIEDC2cwEIn
   C0gKWRKBymFTfY7uouSdRS2ztgbHPrfC4HXPG6Io2EA9CR2rqCaEts6Vm
   1Sii5QgIYUp0pkWzB1AHlEdb8yMt9yHRF5M+IaDYVYipaXQXWLr6Q5SYX
   g==;
X-CSE-ConnectionGUID: 463qA6bsTqSx0kaGSklsKw==
X-CSE-MsgGUID: nRnrF5ADQOKJfE3nz31EGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="50083200"
X-IronPort-AV: E=Sophos;i="6.11,186,1725346800"; 
   d="scan'208";a="50083200"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 02:00:02 -0700
X-CSE-ConnectionGUID: vknWo7lhQXyXYoPpWZVUDA==
X-CSE-MsgGUID: 2OaHO0jISL6i+vSRcFVSCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,186,1725346800"; 
   d="scan'208";a="106519788"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Oct 2024 02:00:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 8 Oct 2024 02:00:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 8 Oct 2024 02:00:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 8 Oct 2024 02:00:00 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 8 Oct 2024 01:59:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RwCvXOXIkeKEgKcc/SWSSUamN0w/H5maa3/B68eJlWepnEzuA7IFHB3IpTsjxa008KjSpjJGCJXxDbLlPUc7EyRKcK6/s3Jj+7ySBa45SClgP6Wq/ZfWuYfOtbI7iiKNI7U8aSQw7k/CZB9/RE6fR7weTYRe50yoRjK16p6YLYXa74Wng67Ncv9EDBo335PsKfRCbBKZKo5ZiyDrvfXsAbTnZajHWmQAImAh/aumxt5HUN7F00PDcNTCa+J2rG30cbjXZy9Mf37bg8ZuzpzBjfhalvHa7bcd295WWmyqgEp8M2BWlcz4oaw2aYgSNolIFcBiQvK8aFlpN0k1iZtphA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tL8TD5kQ/xdbDQsyHdemaInTp+bTGTrK4rY10ZJz5pE=;
 b=iQPYMK9TMDe3p5XFyN6mYBvj5eKYBdt7wKUpu5EpZZv0LlvIYamyUbnqlxuPd5DH91k90VfJn9rhUgZtlqh3xEY8nTuutSfwzzsAKghXI3GCazUnT5YjJ81Q0syZqf+tt8tyg0rL1n2pgYZF8MiSykFO3ZgoopRsKcHeJ5HnuEJpjVtrbldOQiGUk1eleOyPBjggEBnJ8ymYoc2x3qp10pntxBIzt9ZAu0S18NYOm4EVRo/PDmFOGNQGiO1d/uDsaMOJz/MWweu3AWcX9AiKX2KAKCQgF56yF5Kv9WjXpDq8GOhgicevmhGUe32mKnscZpXfouvXyXUZqJEvM6CtMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SJ0PR11MB8294.namprd11.prod.outlook.com (2603:10b6:a03:478::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Tue, 8 Oct
 2024 08:59:56 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%2]) with mapi id 15.20.8026.020; Tue, 8 Oct 2024
 08:59:56 +0000
Message-ID: <84ef5f82-6224-4489-91be-8c1163d5b287@intel.com>
Date: Tue, 8 Oct 2024 16:59:45 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] Enable shared device assignment
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Edgecombe Rick P <rick.p.edgecombe@intel.com>,
	Wang Wei W <wei.w.wang@intel.com>, Peng Chao P <chao.p.peng@intel.com>, "Gao
 Chao" <chao.gao@intel.com>, Wu Hao <hao.wu@intel.com>, Xu Yilun
	<yilun.xu@intel.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
 <b7197241-7826-49b7-8dfc-04ffecb8a54b@intel.com>
Content-Language: en-US
In-Reply-To: <b7197241-7826-49b7-8dfc-04ffecb8a54b@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0152.apcprd01.prod.exchangelabs.com
 (2603:1096:820:149::20) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SJ0PR11MB8294:EE_
X-MS-Office365-Filtering-Correlation-Id: 602304fc-feaf-473a-d387-08dce7779494
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NzRRdDFjcjRSRE5NeWJaT3ovSDM1ZE8wa0pGK2JZMnlXN29Yd3dLaGxSdVl0?=
 =?utf-8?B?eUwzbHgrWC9mcmtsYUpUSVdCUXk5TlFJYnY5eDRMOHZUVlRxY0pHeVUyUElB?=
 =?utf-8?B?MEFEVkorVGk0VytkQmlvS1ZDa1RJUS9iVHJXcGZBNGNoVFI4T2t6bFE0alkz?=
 =?utf-8?B?SEIySEk0N2xNUVVIN1FSc3RDUExjY0VlS0l0UWxkNFl0TG9UNC84aTBGUkhV?=
 =?utf-8?B?ZXBZdUpJTlBlTHpjWU8rMi8yNnRnREk0S1p3QklxQ0JZR01pbGU3ODFGZDVY?=
 =?utf-8?B?VHpzWmlwZmd1SklMTW9Bd01Ld3JEZ1d1NFJDQTIrbG5HWlhqcUx4VUU3K3NQ?=
 =?utf-8?B?TmI4ZmhSMFJ0OXFDcmFYcFdYMjc0dEx2cUt2bHVNeVBsbmZ5QlUrdG9DM1pm?=
 =?utf-8?B?NWVUWWR1YXZPSTArUFpvZGFTZG9qaXlrZHdHUU9sUU1RT3FuZnJjbm04Rnc2?=
 =?utf-8?B?RGZ1cGFVOTlyeWhDNTc3L2tDNW9RQ3l1c2JUQ0t5MUpjU2JONy96U2RiMXBH?=
 =?utf-8?B?WllaUmg0anBEeCtac0JFN3VrSnZKR2tVSDhIc3hkWnFFT1lYb2ZxeTFCVEhr?=
 =?utf-8?B?dks0MWsyQlJkd1hlR3BNOFNKdStYMGEvMUNKWnRzRWxwNVZIczkvWmE0b3hF?=
 =?utf-8?B?emo1V3ZqSVQ4MUpUWXFuaFVvVDFtU2UvUDB3KzgxTTVBWGI4WnRGRm80bll1?=
 =?utf-8?B?TFRyWWlJMVpDbmxPTGJjS2lmZmdER0JycE54RDdGN2ZnQ3NGdnpMMkgwRzgv?=
 =?utf-8?B?QW1Eb0lsQXU0bG5pdkg5OFh3Q1Y0MjlEZUxpSXcwaW91eWRYUUw5dVFVd2l3?=
 =?utf-8?B?anJ5VldCRFM3cW0wRWhBYjZiNHdYWWpDTlBISkFTR0JLYm9MT3FqeXBIUG5w?=
 =?utf-8?B?QlZDM3Ayd2pCTHNkN0Q3VlhxN2pDK05OUm5yaTV1SjhDSWZIbUQ1aG5ScGN5?=
 =?utf-8?B?K0pKZDVGeXUwL2I1Z2lkRzRzRW5RWVRBakZoL1BDRVNCUVdmSS9MbTMrTGpi?=
 =?utf-8?B?Sk1wRUg3R05jNEdCNThEVGxYR3lIUUZwdnMyMmUwSWdFbDMyMXlueUhSVEJn?=
 =?utf-8?B?Nzhoc0hYbGVqeGoyRHo4YmVoMG42WDg0ZStlaFE3RDBkR3VpTGxjWmErRXht?=
 =?utf-8?B?cDVnTU44SGhyQjhBVFYzWlRkWXhmTGdoQTV2eHRCaGJtekJZK1BNUmxCNldL?=
 =?utf-8?B?VGxDT2lXYUlyTzgxdmQvcEo3UWZ4SWo5UzhvSXRaV3lIK09ub1h2aGVSZ2NY?=
 =?utf-8?B?cnBPa0ZlbUU5bmVkSlh6UU1wblFJeHUvQTNSR0VNTUdvcVF5TWJVNCtQM01i?=
 =?utf-8?B?NldhOERrYjkrV01ya2NwcFFaVnJFcHY5WDZYUUMxVWMvVUJLOW1hUFZxMElv?=
 =?utf-8?B?b2pzMjZ3cDN6M29XK3JCaHFGOWtlU0JYbk1zd1IyUVlEUWg5bHBMQWFSbHZ0?=
 =?utf-8?B?WWdUMWtMTDd2QjI5Ymc5Vk9idk9EQnFBOFYwNXNPTDZNMy9CQXgraFlRcllz?=
 =?utf-8?B?dEQwbzFyRXhXMVYrTk40ZWFrd1ZhVE5vdEUrTFdsU1ZQaEtDbHFMOUp1dVNx?=
 =?utf-8?B?Z3pLeWRYZlVNSHVoZzVmTDFmb2I2NlRSYnlFcFlBT1FvdTJUOHcvUHF6OGV6?=
 =?utf-8?B?K1ltNSt2b3Nja2I5SnoyRkZCZkR4UWk1TXlJUXo1NjFDaFRBWm9KcGxVL0My?=
 =?utf-8?B?ZWV5N2hHN2xmRlYwM0FOOTF2Uk8xVUZ4TFMyYTJaMGdVWnlSajNkMmN6b1VR?=
 =?utf-8?Q?olw31qkc8ATqBYuTDU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjR4d3ZnTGYzN3prNDhxQ2VGODd2Z1B5UGhweGgva3hCYmJyeXNHUTJSUm03?=
 =?utf-8?B?L1BhYytmQXZTbHNtM05Na3JEWmhLeWQ2TlhoZzY1Q0lMSXNtTTBYTlVYZUFx?=
 =?utf-8?B?VHc2cHBGOEdjcXlRRzJPNC9RY1ZpUkNQZ0UwaUxjS0JTWWs3NmRicmlZcTRM?=
 =?utf-8?B?WU8vRmFUTDJub1dUVkRzb1RQTWptb283ZENjaE1LeHZpQ0JiNDNkRUw2Y3l5?=
 =?utf-8?B?VXRONThYUE5IRTd6RUJnMmZQZmc0K3BsSnJXNHdFVGFrcHhvTVBiNWdpd1Jp?=
 =?utf-8?B?aE9jNnZuVENPUERzSEJ0eGxLYjJndzVhaW02aU5pVG43OTdzRmdEVUlGcHQ0?=
 =?utf-8?B?dURtenV5VUUvNktiQUNNcnZQdDlnKzU1ZkJJaldEc1NTaGV6R1VYN3NCOWll?=
 =?utf-8?B?WmFiaXRsWWtOaHoyYks1UzRTcGQrMCt2bVMxRkdnUGhSd1J2eEpjcWRwUldJ?=
 =?utf-8?B?T1BOM1JsNndFUkJhNFB3d1dMNXJPV0hpK2ZBN2wxZTE5bjF6ZFk0cGhqZlJv?=
 =?utf-8?B?L2Z5ek56UkpCZCtRMTVabGpMKzVHMkJrNURwVUtLQzNpU3NKakRSY2tEaGRt?=
 =?utf-8?B?eTBGYlNkRHZjUGwyMDEvVkdpek83SGowY2NSbjlFNHlrMDZCV2U2WVlJSVM5?=
 =?utf-8?B?Y0Z1QTcvNEtvRFRlYlN1QXR5ZW5EdC8zd29lNU1QQmtzOCt4N3plbU1KQWdD?=
 =?utf-8?B?eVhpV2JES0ttK2gvN3ZPODZFYlplVFdaWlFxQnVrektQUEkxV1dMR1JnRlVH?=
 =?utf-8?B?TXEyblhENG1qUmd0ODN2V1c4dTcwbTRRY3RtcHdyNCt5bW1sb1JRUzZZWHFs?=
 =?utf-8?B?SmlLa1hoeUprRFhMOW11TWlkRGU2OGZGWnN1dTc0YWhZQ3RxM0d3VlNGTzNh?=
 =?utf-8?B?a2tCSElxbGFQcm1TNkpRUkVsYkwyMTd3N2V4S09GbTJoRktFK0dDcWx0RVlH?=
 =?utf-8?B?Q1UrN08welVCMTF6clVUM0VYQ2ZMR083VEtKdVVQaGNtNmwwaXlSZHk2REY1?=
 =?utf-8?B?YVJadXJBYU85ZE5QVDRPV3E0Sm9ZZUlnQ1NRU0hET2Fsa05mRXNLOTl4ZitP?=
 =?utf-8?B?NzJEdTVqRkp4cS8zMjVLd1BSSW1nekpHSWFUWXVZbFpaTkN6d2VmQ01BQzc5?=
 =?utf-8?B?SEprcEE2aWk3YkFCUFo3WE40L3JNS3ZURDNUU2lEWkg1dXNGTUVUYTJldEJ5?=
 =?utf-8?B?Z1hXVjJUTktMYmt5dW1mSU1NNXJhekt1V0M2K0FjaG84L0NhZHE1RHMxMkdV?=
 =?utf-8?B?VGZoeE1PSlJQUXlzVC9Fby9kMEpudE5YN0N5YzdsQ1dFbjAvemRvZDV1L2tF?=
 =?utf-8?B?bHpXeVNNNHdCQVloUWJ5WXdiTVcvbmttdkVvSGU0QmNGbXl3WCtzUDVrVHUx?=
 =?utf-8?B?WTZVeHNvTU5QT2xuT1pyWVFxRnprNm4vd25FRzU2aU0wMnBZQTV2NW1mOTJ2?=
 =?utf-8?B?RUQvQVFIZGpXSFlnWXZCdGphVm0vS2Q3MUUrOWtCdHJ3TnBSb3NyWUFJTzA0?=
 =?utf-8?B?bElkMHorQ3VETHRHV0lzZDZNczJ6VGlpSjh6aVpsc3Rkd3A5alMvcGJwaC92?=
 =?utf-8?B?WkRkbXJjWHdDWHVCNXhqbmI3S1luOHF1bWxDYXA1OGM3dU1jZ1RJWUhuNUlK?=
 =?utf-8?B?ZUVBeFEwajBSb2U5VFBGcndFSWJyM0YzSndyWHdRMVR1bmxjUTdNYWd4SEZs?=
 =?utf-8?B?bmhiZ3FyaWFVTkpPbXNlcG5tMzMwUnlqd3NmbFV1WkIwakwrL3dTc3lHM0ZY?=
 =?utf-8?B?Qnl6T0VmWlZYallyazNJNjA2a0k0dCtjcUVFUDZLVmp3cGwvbVh2aTZSSG0r?=
 =?utf-8?B?N1IvNFJuV2NqSXU2VDd4Q2VRdWJkczF6OGpUYXFhdThxKzh1R1Bsb1VRdE1l?=
 =?utf-8?B?eCt6Z0NqZzZtdVlZL1RYbmtmcURLSmZiSGduN202Zm5WRTFvWldLS09BMDFX?=
 =?utf-8?B?c3h3ZXV2RUp0QlBuNUFNeWpQYU10U2krYUdpV3V0RHBTVlAweFB4M0hzdERQ?=
 =?utf-8?B?TmFGTUZuU1FJYjRDMXA2TG0zeXVBbHM2S05XU3VzQmFmd0tKdXBhcG1naGhu?=
 =?utf-8?B?S2lJSHlkc2txc2JUelYvcTV6cEdWczhlVy9FZ3N2YkJZVEhFeG56MXdqejNh?=
 =?utf-8?B?dFhIZ0U1eWRsU2RjclRQNXZMcUtML0NYTGNsbDFEbVpXZVRBbXN4VDJrSDdT?=
 =?utf-8?B?WUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 602304fc-feaf-473a-d387-08dce7779494
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2024 08:59:56.0954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y18biDG6dQNjOl0O9HJkaSm31BwOz9JlWoLLLFlDVm6ZHH2Uk2ma1lYqpcUPR4fXZhXwHtRQzoXjPWY/RF/UnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB8294
X-OriginatorOrg: intel.com

Hi Paolo,

Kindly ping for this thread. The in-place page conversion is discussed
at Linux Plumbers. Does it give some direction for shared device
assignment enabling work?

Thanks
Chenyi

On 8/16/2024 11:02 AM, Chenyi Qiang wrote:
> Hi Paolo,
> 
> Hope to draw your attention. As TEE I/O would depend on shared device
> assignment and we introduce this RDM solution in QEMU. Now, Observe the
> in-place private/shared conversion option mentioned by David, do you
> think we should continue to add pass-thru support for this in-qemu page
> conversion method? Or wait for the option discussion to see if it will
> change to in-kernel conversion.
> 
> Thanks
> Chenyi
> 
> On 7/25/2024 3:21 PM, Chenyi Qiang wrote:
>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>> discard") effectively disables device assignment with guest_memfd.
>> guest_memfd is required for confidential guests, so device assignment to
>> confidential guests is disabled. A supporting assumption for disabling
>> device-assignment was that TEE I/O (SEV-TIO, TDX Connect, COVE-IO
>> etc...) solves the confidential-guest device-assignment problem [1].
>> That turns out not to be the case because TEE I/O depends on being able
>> to operate devices against "shared"/untrusted memory for device
>> initialization and error recovery scenarios.
>>
>> This series utilizes an existing framework named RamDiscardManager to
>> notify VFIO of page conversions. However, there's still one concern
>> related to the semantics of RamDiscardManager which is used to manage
>> the memory plug/unplug state. This is a little different from the memory
>> shared/private in our requirement. See the "Open" section below for more
>> details.
>>
>> Background
>> ==========
>> Confidential VMs have two classes of memory: shared and private memory.
>> Shared memory is accessible from the host/VMM while private memory is
>> not. Confidential VMs can decide which memory is shared/private and
>> convert memory between shared/private at runtime.
>>
>> "guest_memfd" is a new kind of fd whose primary goal is to serve guest
>> private memory. The key differences between guest_memfd and normal memfd
>> are that guest_memfd is spawned by a KVM ioctl, bound to its owner VM and
>> cannot be mapped, read or written by userspace.
>>
>> In QEMU's implementation, shared memory is allocated with normal methods
>> (e.g. mmap or fallocate) while private memory is allocated from
>> guest_memfd. When a VM performs memory conversions, QEMU frees pages via
>> madvise() or via PUNCH_HOLE on memfd or guest_memfd from one side and
>> allocates new pages from the other side.
>>
>> Problem
>> =======
>> Device assignment in QEMU is implemented via VFIO system. In the normal
>> VM, VM memory is pinned at the beginning of time by VFIO. In the
>> confidential VM, the VM can convert memory and when that happens
>> nothing currently tells VFIO that its mappings are stale. This means
>> that page conversion leaks memory and leaves stale IOMMU mappings. For
>> example, sequence like the following can result in stale IOMMU mappings:
>>
>> 1. allocate shared page
>> 2. convert page shared->private
>> 3. discard shared page
>> 4. convert page private->shared
>> 5. allocate shared page
>> 6. issue DMA operations against that shared page
>>
>> After step 3, VFIO is still pinning the page. However, DMA operations in
>> step 6 will hit the old mapping that was allocated in step 1, which
>> causes the device to access the invalid data.
>>
>> Currently, the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>> uncoordinated discard") has blocked the device assignment with
>> guest_memfd to avoid this problem.
>>
>> Solution
>> ========
>> The key to enable shared device assignment is to solve the stale IOMMU
>> mappings problem.
>>
>> Given the constraints and assumptions here is a solution that satisfied
>> the use cases. RamDiscardManager, an existing interface currently
>> utilized by virtio-mem, offers a means to modify IOMMU mappings in
>> accordance with VM page assignment. Page conversion is similar to
>> hot-removing a page in one mode and adding it back in the other.
>>
>> This series implements a RamDiscardManager for confidential VMs and
>> utilizes its infrastructure to notify VFIO of page conversions.
>>
>> Another possible attempt [2] was to not discard shared pages in step 3
>> above. This was an incomplete band-aid because guests would consume
>> twice the memory since shared pages wouldn't be freed even after they
>> were converted to private.
>>
>> Open
>> ====
>> Implementing a RamDiscardManager to notify VFIO of page conversions
>> causes changes in semantics: private memory is treated as discarded (or
>> hot-removed) memory. This isn't aligned with the expectation of current
>> RamDiscardManager users (e.g. VFIO or live migration) who really
>> expect that discarded memory is hot-removed and thus can be skipped when
>> the users are processing guest memory. Treating private memory as
>> discarded won't work in future if VFIO or live migration needs to handle
>> private memory. e.g. VFIO may need to map private memory to support
>> Trusted IO and live migration for confidential VMs need to migrate
>> private memory.
>>
>> There are two possible ways to mitigate the semantics changes.
>> 1. Develop a new mechanism to notify the page conversions between
>> private and shared. For example, utilize the notifier_list in QEMU. VFIO
>> registers its own handler and gets notified upon page conversions. This
>> is a clean approach which only touches the notifier workflow. A
>> challenge is that for device hotplug, existing shared memory should be
>> mapped in IOMMU. This will need additional changes.
>>
>> 2. Extend the existing RamDiscardManager interface to manage not only
>> the discarded/populated status of guest memory but also the
>> shared/private status. RamDiscardManager users like VFIO will be
>> notified with one more argument indicating what change is happening and
>> can take action accordingly. It also has challenges e.g. QEMU allows
>> only one RamDiscardManager, how to support virtio-mem for confidential
>> VMs would be a problem. And some APIs like .is_populated() exposed by
>> RamDiscardManager are meaningless to shared/private memory. So they may
>> need some adjustments.
>>
>> Testing
>> =======
>> This patch series is tested based on the internal TDX KVM/QEMU tree.
>>
>> To facilitate shared device assignment with the NIC, employ the legacy
>> type1 VFIO with the QEMU command:
>>
>> qemu-system-x86_64 [...]
>>     -device vfio-pci,host=XX:XX.X
>>
>> The parameter of dma_entry_limit needs to be adjusted. For example, a
>> 16GB guest needs to adjust the parameter like
>> vfio_iommu_type1.dma_entry_limit=4194304.
>>
>> If use the iommufd-backed VFIO with the qemu command:
>>
>> qemu-system-x86_64 [...]
>>     -object iommufd,id=iommufd0 \
>>     -device vfio-pci,host=XX:XX.X,iommufd=iommufd0
>>
>> No additional adjustment required.
>>
>> Following the bootup of the TD guest, the guest's IP address becomes
>> visible, and iperf is able to successfully send and receive data.
>>
>> Related link
>> ============
>> [1] https://lore.kernel.org/all/d6acfbef-96a1-42bc-8866-c12a4de8c57c@redhat.com/
>> [2] https://lore.kernel.org/all/20240320083945.991426-20-michael.roth@amd.com/
>>
>> Chenyi Qiang (6):
>>   guest_memfd: Introduce an object to manage the guest-memfd with
>>     RamDiscardManager
>>   guest_memfd: Introduce a helper to notify the shared/private state
>>     change
>>   KVM: Notify the state change via RamDiscardManager helper during
>>     shared/private conversion
>>   memory: Register the RamDiscardManager instance upon guest_memfd
>>     creation
>>   guest-memfd: Default to discarded (private) in guest_memfd_manager
>>   RAMBlock: make guest_memfd require coordinate discard
>>
>>  accel/kvm/kvm-all.c                  |   7 +
>>  include/sysemu/guest-memfd-manager.h |  49 +++
>>  system/guest-memfd-manager.c         | 425 +++++++++++++++++++++++++++
>>  system/meson.build                   |   1 +
>>  system/physmem.c                     |  11 +-
>>  5 files changed, 492 insertions(+), 1 deletion(-)
>>  create mode 100644 include/sysemu/guest-memfd-manager.h
>>  create mode 100644 system/guest-memfd-manager.c
>>
>>
>> base-commit: 900536d3e97aed7fdd9cb4dadd3bf7023360e819


