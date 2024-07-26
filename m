Return-Path: <kvm+bounces-22284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 982C893CE17
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 08:21:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B9151F21AE9
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 06:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D190C174EFC;
	Fri, 26 Jul 2024 06:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gfv8U+yH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493442557F
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 06:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721974868; cv=fail; b=Cja9Vdju4rOOKRF2qVZVIsTju41ZJ+gcv5VjXtQJEagQGSYaExh+qBrsviUTntnAcJF5OxpDWB9NmmAl7y9BDUWKIs8uUlzSFlGxryfKOGkN1k+lBZm3HdY9qKjjXODTslr+ZNh7J/CqmMMQidA6u8O4hP+0NjMm3Wm8qF4KYuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721974868; c=relaxed/simple;
	bh=sZCSQXYK3qt0R7HqaYqpuIS4SVnMnGDhf8qWZ6UCYng=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Wm4luKbubEG3a58CYVy6qJk/6j09jcAG2osud8yWLvlFKmt6KQZophxWXPM4eikTCCl6Qy1PZot86PbXjhQgfvUWBUZPnujHZSQJf1ObHXs2Pn2dPfcBlJC4DA1MZbUfwcepl3A6OtGr0DsoSGMkYGU5FSATNswLA+BZNep1hwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gfv8U+yH; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721974864; x=1753510864;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sZCSQXYK3qt0R7HqaYqpuIS4SVnMnGDhf8qWZ6UCYng=;
  b=Gfv8U+yHn61DBabhP1QbQRrfjmg/M/Akq/FHEkbxw9kD3PLJKcn2agal
   UV97VDtWlYAJ+NNGK0vF62HtFpgzGQuJhAdP7F9XmGdG0bzICXblWPSmb
   XkHr4ydNQKFw3czpFxATAQSsrzQjLf2EiqfoNebFjuEyi1dJKiA1zM8fo
   dTx8IYW+JPKiMYBOqOze2tjcm5FPHpYJsG1en1oYoy8EyO9hZrVy6rxCn
   PQu3/WV12XmwGHAt0UckUUNU7GWuwbltl7jB1uNmf7Sh1nDJyxFCc6iWD
   KAvqKccJV1rU3WYceDE9rGRpp+RujmN0nowehuczAoy+0BjX+CeaFG4ZT
   g==;
X-CSE-ConnectionGUID: QlvRtAe9RW2h6Zxj40Anig==
X-CSE-MsgGUID: rV9Yuw/vQpStAbu+LXqa9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11144"; a="19361201"
X-IronPort-AV: E=Sophos;i="6.09,238,1716274800"; 
   d="scan'208";a="19361201"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 23:21:03 -0700
X-CSE-ConnectionGUID: 0Y885v47QpCIzWwbJd7D4w==
X-CSE-MsgGUID: Na0mOy4QRb+SpL9OJDVBZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,238,1716274800"; 
   d="scan'208";a="84130789"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jul 2024 23:21:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 25 Jul 2024 23:21:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 25 Jul 2024 23:21:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 25 Jul 2024 23:21:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 25 Jul 2024 23:21:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FjDppETGOGgi6HdKJ8ORH2gQa5xOT3aNhGGAmn020BhrUSxS3Rh1LuiwgzupPeOeo7I2anFEmNRnBnmg2SaU6RvN2yypO+9DOOSU4gNGrb97ebrr4kmNPJ+Wqr26PRmufoT3eQxLZPqmA+ftXuGzrXcvluBLWt58pgxZvvO8y9lM3MQbpv2aVV0VHUxPmOaNW988cwGEDsJQNjN41UjmaSbbjGsX2TcKLLcK4IOxO+V+Xu2q39tG7clLpXtVoIXMfc9orNBLEO375rSwbhV4/EFvwgVPVaM8mKi/97XoIQ7Dcmr5Fk+DtrM6NyUMVHRssp9ccVmA/szsDyqs5RMByg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQwm0mb1bl6X1M75jzBiVffK9xW4TkLnptLhNCxgyUQ=;
 b=Z0iFAGkyU9l4Siat1xArp0+XDYBdcwdi5C2NnMNFlMaM9Yy4ULpVqJQcMf3Ddfj/0RcxvThFF0DMT+Ru35wepLJM6DAeOqeqnZplaiiosw8XE1eI5ZnXDe9xhUaeiePyzLcg6ugPhHCt4JheJ2jL5xKtcx5tYqxjVDasNZ1eWqEMt+GCIQp0Y4idx7WXNnpW1XHrQnnyqQ7Fi/FRVrL1kTX5V99D/GtNBtXCLoA5LaYj1VYw4ZgYJqBGEZJ9bTnwA+8KnYSpD8kt6D1XVDqNNUyz9TxLrehar0xDhKBmF+1VI24fXLF6IzCVvOY9X2kSQvFRNpqZN1PKkE3eY+nksw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CH0PR11MB8144.namprd11.prod.outlook.com (2603:10b6:610:18d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Fri, 26 Jul
 2024 06:20:54 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%3]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 06:20:54 +0000
Message-ID: <69091ee4-f1c9-43ce-8a2a-9bb370e8115f@intel.com>
Date: Fri, 26 Jul 2024 14:20:42 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] Enable shared device assignment
To: David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Edgecombe Rick P <rick.p.edgecombe@intel.com>,
	Wang Wei W <wei.w.wang@intel.com>, Peng Chao P <chao.p.peng@intel.com>, "Gao
 Chao" <chao.gao@intel.com>, Wu Hao <hao.wu@intel.com>, Xu Yilun
	<yilun.xu@intel.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
 <ace9bb98-1415-460f-b8f5-e50607fbce20@redhat.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <ace9bb98-1415-460f-b8f5-e50607fbce20@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::16) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CH0PR11MB8144:EE_
X-MS-Office365-Filtering-Correlation-Id: f3cec07f-65d0-402a-9a05-08dcad3b1a91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bWxHdlM0MytPN2szRTZpMk5kMHVkN29Xd2lPbHpwRGc4NU9KelZoMXRGWncz?=
 =?utf-8?B?Vk1ZcVIyUGNvcGpwOWk2VVBNcSs3RE0rRVBRRUYyejB0dTAvU0pEekMrUFpK?=
 =?utf-8?B?Rnc3dk1Mais5NEdIZVd0Q3ExOXgvWENtNytUeFY1ME9XVXRlMFdicm9VQ2F5?=
 =?utf-8?B?SDlWOGdBTVY3V2RQelRqcTFJdERJbXNSaGdZR3JhQnoySFdGMXM2a0hPMnBT?=
 =?utf-8?B?T2ZGeEJRKzBMQVZ0RWs1UVd6ZUJNZWpuR1BuSlZIdXMyZEVUL2FuWC9DeUto?=
 =?utf-8?B?SUFDN0x4NktnRmJTU2NXUVJUV2M0bXhoTUViN2tSOVJJMW1mRkJIYkJoUS9y?=
 =?utf-8?B?dUMyai9RQi9GNWxWZElySzRGdFE2NFVodm4vR0VZME5NMEVhU09lUTdnSWNB?=
 =?utf-8?B?WDBBSUFwVVYzOUZxbmhRRi9VWTBwYStkRVJVMFFiSGNjRndpL00zKzlXcW0v?=
 =?utf-8?B?UDJFeVY5U3g0WXdZVW05RFM2VTVLM2daejUvaEpVLzhrSERIM2I0cmJrR1pP?=
 =?utf-8?B?YUVnRXZFQTBzNFR2dURXSUNhbk5SeW04N2NxY0xDTFZHd29SRHFnOVJvOTNq?=
 =?utf-8?B?WmRlYmwzaHFjVzBNWXl4Umw1UUUrR0FhcTNKczl5Sk1OcVB2ZFR2SEp6VGov?=
 =?utf-8?B?VUhjQllOVytHc0pEYnJGK2JLYTc4aHZITlk2MSs2UzUwaysybjU1QlMyTzVE?=
 =?utf-8?B?YVpaK1o2UEk5eWJ1UWlRSkRDV0FRRVIwMUlsSElwWXFOdUtXdHIzWGFrbUlr?=
 =?utf-8?B?MHBHbGR2OUJuRzYxM3NHeUlscEZLZmwzc3dkZkVHSE1jbUlhMmhmaVJUcjJi?=
 =?utf-8?B?aFNGRi8reUZlQXk4Z09QcHBzOHlEY2NLVDlxK2l0NHF2NEJES2k1blVTaWlo?=
 =?utf-8?B?Mis2MWk1OE1xSUY1TXhEVTdaVHlhbS9MU1RuTGFEdjRka0tKRXhXaisyWDRx?=
 =?utf-8?B?Zk93Sk5sbEJGKzA5YkNKQmVzSS9JYmJJcVllVmE0MXZJOGxqTkZDa1QrbWJQ?=
 =?utf-8?B?YXozV3lQNzMzRHQrdmYvSjNqdncyb2Z4OEpJbDBZekc5a245WWhvWkNUd3Fy?=
 =?utf-8?B?ei9wK2k3QWRsQXFUdXdVc2JuUmRsN3NQQmRrOVJ5MUNsWTQyL2ZXd0xveEMz?=
 =?utf-8?B?clZGMXpCV3JUQWdZeGNxVVNtbUV2OUxuR0JEVzFRLzF4Ykh3eVJiZU1ZOFdC?=
 =?utf-8?B?dzFsS2JrWGlIYmRhVjk0N1JWbGlrN0FtcVBKckViS2lobkpzVzVMMzJQOFQ2?=
 =?utf-8?B?NzJEZ2UwaEVGWEdBclhaZHU3OWNPWXZIczJGMktvc1RRajRCa29YNWVCaDFJ?=
 =?utf-8?B?SVBLZjRtN0RPcHFiZENPVHBNLzIyYkVrdTdxUXA2Mlk0MXc0bGt1T2EyNG91?=
 =?utf-8?B?Z3RodTdzd3RVdUFvbVZTd0hSRjM1ZTNUTUIrSWVCUG5WamdpK3d5OFZ6RUlC?=
 =?utf-8?B?bDVac0xJQis0TWxGUUhPVFRFZXZqa0VRS25jR3VQclY3aC91Zkl4cGlDdFpk?=
 =?utf-8?B?cWZuS1FKZTFZTDZGT0xKL3FXcWtObzRyaDhBRnJYWjYwMnJHeXJZNDQzdlR3?=
 =?utf-8?B?NlEvd01NSnpPT3A5V24wYnF0VTc4L3gwaDZKODN4YjQ4UWNxMUJGNERzUFVr?=
 =?utf-8?B?aGRvaklMRjF4K0JHdFhOWG5vSGR4NExnN1BaSnFWN0Ntcm5vZlZwaGo5bzEr?=
 =?utf-8?B?VzNWOWlRMkE0QkR3SkJjRXp5VDZIUkdBeDBqZ0lYcG0ySE1IOEhDczF0N1BS?=
 =?utf-8?B?WFZRK3IrQ0xzNy9jZlR4ZzdUWXc0OVNEazl1cmw1WWN3aENVVTZUalBGcmJV?=
 =?utf-8?B?NGlaYXMrVkhteWprclRkUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2g1MGJZem5DOCtCcE5PR2FxRVVzc3FvVEdjVm5yTjlqVHQ3RUZSazRhejcv?=
 =?utf-8?B?K21QbFVNdXE4LzVLb1BNRW5nS2RqYWNreHN1UGVQUC9UOGNySGZlcmRaZDdv?=
 =?utf-8?B?dUlhRzJxU2JuaEpzWTl4T2N1UlVmNlBpOGQ2MFhhUzU2ek4wM1Y2WE01Z3RL?=
 =?utf-8?B?NkUyR2UydU5ISTloR0ZlRlRQK1AxWEh4LzlrcDE3eDhaRDRtcWtWa0x3SjNN?=
 =?utf-8?B?L1Bjd3RaZVRDWllQbmV6YklqK1FSeDI5UEJmWTVkcGc5ZVdXODc0VThBckFu?=
 =?utf-8?B?aEVNbzNEajc0QUFEZUIvSndJaXNtWnN1Z1l0ZUZ2enF3SHlkQ09RRVo5cVov?=
 =?utf-8?B?TVpZcjlIcE9mUWYzMSs1dm1ETW5QVm52Nmx3MnFoK3NORm1LbEcvNDVCNmhv?=
 =?utf-8?B?aDRxVGZSQmNWajRnVE1taTkxUTBzbHVqWHN1T0ZyOVlNZnllYkFtMW1hR1lz?=
 =?utf-8?B?RlpYTGczYjRvenQxa0ZzV3VrYVF5ckxYOERCbkpJTTN5TDBKUWRIWmV0WDYw?=
 =?utf-8?B?T2Q3NHVLS0dnTlpmN3k3MmdOUm1SOSs3MUFkZkVBdXRoOHNYbG5SVzlHRXZO?=
 =?utf-8?B?eGVhUG14ODhIcTBDeXBoQkhnMWN1ZzY0NFRERXRaVUczVW9PeTBTY3dUQXZ3?=
 =?utf-8?B?Y1NZZ3VsVWQ3L043RExFNGNmWUJlRzZzdTd0akZDVWYxbGp3RUM3OG80TFlG?=
 =?utf-8?B?aEIybWZJVEluVHRPM0xqQkVKZzlRUVNHUWxaajkxYkx4NEZYWStqR0tUdk8v?=
 =?utf-8?B?QzIweGgvVmFSTnRmQXFucmczWUQwVStTZDBjSlRScXRnNE9WNWRITk9TY3lX?=
 =?utf-8?B?ekFyTVJuWWtxWUcva2FtQlI2SVlrc1NkYXBOazdYNFhHb3lML0cxaVBhTG5p?=
 =?utf-8?B?alJvNUtBOExrVzk1QzQ1b0pYR1VHbXF4c3BQMUU4T3JWSDg4TXdIR3dZRTVP?=
 =?utf-8?B?R3VwUk5TRkhFSmo4ZGw1T0RQVlFzb2NvZWxHYWpzRk5ZTkhtTXorQjNGbUN6?=
 =?utf-8?B?TWRBT05LbXBScTcvQjZxVlVEVWhwYkQ2VGJzOXNLQ3pieG5XMHQ5Y0xSLzRP?=
 =?utf-8?B?TU4vb2ZpR3BFWS80NDZIdVp2NmR1VlFoWjU3MmU1WlIzVitrbVRrS2w1TEFr?=
 =?utf-8?B?c1EyQ2NHMXYvLzRpc3JYRytFK000NmNlQ2E4cmR3MmRLOWoybk85YW8rNVMw?=
 =?utf-8?B?ME40ZmhZM3RpTnIyUVdkbGRlVVZQdTU1WjQ4VUJrYjZSOGtrbkNYODF1WHhz?=
 =?utf-8?B?ZU02YThaM210L2VQSUNNU3R6QlM0RkNXQm8wai9QZkFXbDBpWW5GaGJLQ0Vo?=
 =?utf-8?B?dTFNVy9ONURNdzNyMGJHZDZDR2Vib1dwdWJYTVNKSk1OTTUvRlJPY1JGOWt1?=
 =?utf-8?B?NEZ0ckxqWlRoWjR2cXUzd1BJaGxnRHh6SFhEN3BmN21TQ3VObExKdWU4YW10?=
 =?utf-8?B?d2VsS0xOL2tsdC83MUhqNCtFWWVUMFBCWmV5SjRYQmNVUDJWendGZTN3MVJq?=
 =?utf-8?B?SjFUVnhxczROeW1ZLzZBUCtpbXN0bVVmTi8vM3I0OW15NHZMVFh1bUszWTFK?=
 =?utf-8?B?MFowT1NuL29JRkdjS0FhQTNoUjhoOEp1MlZubnVqeUVJMGd0V29adWh3WUZU?=
 =?utf-8?B?Z1M5VFdEdmpWWlp4U2FTOHhETndHRmQvTHdBbHpKSXR2VzhDdms4aksvN0tT?=
 =?utf-8?B?VHZpVFdycldHcGZqK3RQWkxpaklZeCsrZUxyam5oTnBwalFTZWdxai93UC9N?=
 =?utf-8?B?YktrK29kMk0vYnRRZzJzalNhdUxSbjlxOGN6ZURHN2FRamRjMWwyalFsR3lT?=
 =?utf-8?B?cmVBNXR2a084NjE3MDFCQ1FxVDF5bHExKzV2L21SRzNWT0VVR09FYllUTHhY?=
 =?utf-8?B?Tk5hTkhVdXpITXFKK3BjaUJndmF4TGR2SXIyZHp1amhUVHg1UGMrbzdud1lG?=
 =?utf-8?B?K1FySmZxQXF3Slg3cDZvaDdzMlNJU1ZnWjdIR28xWkFUWXBBc0c5UnNWNzhi?=
 =?utf-8?B?THpRT0hHbnFJRDFWT1FaL3lKdnpXWkp1NU1MQnVLSWJPbkVuUm5qWGVNbkNY?=
 =?utf-8?B?YjUvcHN1ZDRGYjRRVEF3RHI2Q2QyaGpxZGRrcGxrZWdLbmtvd0YrQmQwTHJH?=
 =?utf-8?Q?corLTNlHxd0nBTq1POKhWlZC1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3cec07f-65d0-402a-9a05-08dcad3b1a91
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 06:20:54.3341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GtEE0IQ6VOL/3xu3Af3ZfuTo+tr0vEixW+2/YOFQBkS895GCoZ0GJji8MeZ4YTcch+swohiWqf+nEbNom+kHTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8144
X-OriginatorOrg: intel.com



On 7/25/2024 10:04 PM, David Hildenbrand wrote:
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
> 
> "VFIO may need to map private memory to support Trusted IO"
> 
> I've been told that the way we handle shared memory won't be the way
> this is going to work with guest_memfd. KVM will coordinate directly
> with VFIO or $whatever and update the IOMMU tables itself right in the
> kernel; the pages are pinned/owned by guest_memfd, so that will just
> work. So I don't consider that currently a concern. guest_memfd private
> memory is not mapped into user page tables and as it currently seems it
> never will be.

That's correct. AFAIK, some TEE IO solution like TDX Connect would let
kernel coordinate and update private mapping in IOMMU tables. Here, It
mentions that VFIO "may" need map private memory. I want to make this
more generic to account for potential future TEE IO solutions that may
require such functionality. :)

> 
> Similarly: live migration. We cannot simply migrate that memory the
> traditional way. We even have to track the dirty state differently.
> 
> So IMHO, treating both memory as discarded == don't touch it the usual
> way might actually be a feature not a bug ;)

Do you mean treating the private memory in both VFIO and live migration
as discarded? That is what this patch series does. And as you mentioned,
these RDM users cannot follow the traditional RDM way. Because of this,
we also considered whether we should use RDM or a more generic mechanism
like notifier_list below.

> 
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
> 
> Think of all of that in terms of "shared memory is populated, private
> memory is some inaccessible stuff that needs very special way and other
> means for device assignment, live migration, etc.". Then it actually
> quite makes sense to use of RamDiscardManager (AFAIKS :) ).

Yes, such notification mechanism is what we want. But for the users of
RDM, it would require additional change accordingly. Current users just
skip inaccessible stuff, but in private memory case, it can't be simply
skipped. Maybe renaming RamDiscardManager to RamStateManager is more
accurate then. :)

> 
>>
>> Testing
>> =======
>> This patch series is tested based on the internal TDX KVM/QEMU tree.
>>
>> To facilitate shared device assignment with the NIC, employ the legacy
>> type1 VFIO with the QEMU command:
>>
>> qemu-system-x86_64 [...]
>>      -device vfio-pci,host=XX:XX.X
>>
>> The parameter of dma_entry_limit needs to be adjusted. For example, a
>> 16GB guest needs to adjust the parameter like
>> vfio_iommu_type1.dma_entry_limit=4194304.
> 
> But here you note the biggest real issue I see (not related to
> RAMDiscardManager, but that we have to prepare for conversion of each
> possible private page to shared and back): we need a single IOMMU
> mapping for each 4 KiB page.
> 
> Doesn't that mean that we limit shared memory to 4194304*4096 == 16 GiB.
> Does it even scale then?

The entry limitation needs to be increased as the guest memory size
increases. For this issue, are you concerned that having too many
entries might bring some performance issue? Maybe we could introduce
some PV mechanism to coordinate with guest to convert memory only in 2M
granularity. This may help mitigate the problem.

> 
> 
> There is the alternative of having in-place private/shared conversion
> when we also let guest_memfd manage some shared memory. It has plenty of
> downsides, but for the problem at hand it would mean that we don't
> discard on shared/private conversion.>
> But whenever we want to convert memory shared->private we would
> similarly have to from IOMMU page tables via VFIO. (the in-place
> conversion will only be allowed if any additional references on a page
> are gone -- when it is inaccessible by userspace/kernel).

I'm not clear about this in-place private/shared conversion. Can you
elaborate a little bit? It seems this alternative changes private and
shared management in current guest_memfd?

> 
> Again, if IOMMU page tables would be managed by KVM in the kernel
> without user space intervention/vfio this would work with device
> assignment just fine. But I guess it will take a while until we actually
> have that option.
> 

