Return-Path: <kvm+bounces-16778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C3398BD962
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 04:25:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FFE61C2105C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 02:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00C8523D;
	Tue,  7 May 2024 02:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="molmBF1v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03488259C
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 02:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715048710; cv=fail; b=COZp9hIzXmB/mC8+YXP+GS+EKOmtbtIwf6FpWsX1X6kmxOWPN6dG7NBMCFQdKltjFy9bzxCO8G+rIdlG2k/1cCYUb3UstyLZD6xE+PkyVDXbMEx8Xqv3V7M6jitaVSupGx25rz80mJARtB7HNuRIlu2/kYJ3/Bb/GX5A7M88AVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715048710; c=relaxed/simple;
	bh=PWSdALdgsDynjrPwrFFAmzYnnrVWrU4cQY29+z3VlQ8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PRVLW6xW9+FVILHr77UvvTIZAzCfHt+bDsbQ4dFkSiTCetTvCP/43a5hIGSSwwOeZLkAC1In7mBEJfkKqsbNvBygvr4sOn1stI3xWeKGovRCiVTRprb73z4OHwwijeGss1hA/FIAX02FcuIbLuTQ58YtV1RZAVxqKehOVvOy/c4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=molmBF1v; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715048708; x=1746584708;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PWSdALdgsDynjrPwrFFAmzYnnrVWrU4cQY29+z3VlQ8=;
  b=molmBF1vlfec9ARDk2src97pD+bIX2LcpGJBv0zcAkMvnUixacP7brmx
   b980DUYz60oD9RLQtkvvUA1X6DDlHiKKDmMy2P6qAMYWtEGArq7yUkx2a
   QOYu1bTrUdlELt46JWNPXN05H1y9m1ybKGYVYNqLo0TijZe5ECUFQL0In
   gZp7ZdJEykEy1L1SGfvtg6rVOo03VBqZBsU1LI+eUwNMw5AJ3QFXHnT8M
   KAcdualLQt7ONi8UFtQKbxGanaGvr1KIS3bml757xVu+I28MPKXZqXhPo
   e7ZP0We3pR4Yyk8Lw0c9qkoyYkv86YSj3CJHYIOByE6f5T9sL6SAUsHSt
   g==;
X-CSE-ConnectionGUID: WozORFnpSLOdlYlaBI3Bww==
X-CSE-MsgGUID: MeRPWGiDS72KlN+TLUQxYw==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="21495301"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="21495301"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 19:25:05 -0700
X-CSE-ConnectionGUID: qWK3T10DQ9WwRSIQJGwCSA==
X-CSE-MsgGUID: uXAKe+szQqSN4DEiLJbMxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="28757103"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 19:25:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 19:25:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 19:25:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 19:25:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 19:25:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGgfF1xUdJgEQkZ7lU9wNWRncTLRpWuQcYqwOBqK3vU0O6+9ReoKJE6tzUcQ3L/wuP5AXQTaXAHGkhgxvrFDiBQlEmoOFa+N+niuhNIxzRgJsIBsS1NPh0WeUKchoBuweQLHcHVOx3p/XR1Pllj/rm+nGuPxReQVYa7aLDl50TUCTq8GFPdTuMwVQrjxLIV2iClOCv/XOXqFY6ZuhM1s61HvzyZGB3farLM6+tg+049p+eOyh2O/Or1wRk1Zvij4ElY9k9G+bbU1VyPMMdM8V1NBbpngkY1RVvMbn1p1vN6bXup3rYkdnkyCCL7CpVpxm9U3MDM4gUU1/X3lnyi7BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COneGA1zLmeDB4HOiyg9sgib2bgNXKAa5GzNwqzNaRk=;
 b=BcYKC5W3mCf0RZWLlr+hpy216mSTHLuYoNvobcXo9u8nYtnEq49Am7iHo0+tgBmUfn1/pmWRvCRr0TGJm3JAIl1FYl/ICwq4sj+8L62TWEfaYbdzTu5JIXXH2LlDsiOgBt56rGiGDoAnI5I1DGBe3XLr+y1Qmyawk+DzTQzXrSyiL72Nl45OjWX62V0+NE8X+ioCPw5B7zrV2iQEeUtbFVppjIOdApJtygqehBcYfQ6plcYaQCWuiELeu2nwsJxM8//JqU7ITyLfdqAyfS7Jnjs7TtWJJl2mUZV+DFO1HCAeU+QG5u1+YFej/Gw7oaF8VlIYnoWiGwADdtJz21vuBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB6558.namprd11.prod.outlook.com (2603:10b6:806:26e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Tue, 7 May
 2024 02:25:01 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 02:25:00 +0000
Message-ID: <14a7b83e-0e5b-4518-a5d5-5f4d48aa6f2b@intel.com>
Date: Tue, 7 May 2024 10:28:34 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Baolu Lu <baolu.lu@linux.intel.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Pan,
 Jacob jun" <jacob.jun.pan@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-13-yi.l.liu@intel.com>
 <BN9PR11MB5276E97AECE1A58D9714B0C38C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d466eb97-8c2b-4262-8213-b6a9987f59ea@intel.com>
 <b4fe7b7c-d988-4c71-a34c-6e3806327b27@linux.intel.com>
 <20240506133635.GJ3341011@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240506133635.GJ3341011@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR06CA0007.apcprd06.prod.outlook.com
 (2603:1096:4:186::9) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SN7PR11MB6558:EE_
X-MS-Office365-Filtering-Correlation-Id: 59efecbb-159b-4857-b51c-08dc6e3ce565
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NCtKZkYwMXN0STFBMTV4YlcxZWpxS2taeDR0TmdrMDhJMWlZUS9QZWR3ZXZv?=
 =?utf-8?B?SmRDbWxTOHJ2TUVpTml2SkJ0dDZsQXRhV1RqZHVSSytBekNJRjdPendKT1Jm?=
 =?utf-8?B?ZkllNHNXeldlUHNrMmc1aHFhZ1Q3eXVsN2RFZnVodlZ6NE5xRkFGK2dPNlNP?=
 =?utf-8?B?UTFjZVE2QytuNlJkNWtrbldHWDFQU3RHZDFIcnRZM0pRSmgyMVp2dDZBN1h6?=
 =?utf-8?B?S01xTDY1dmd3L3BMbkdaZmgrVUIxMnZtNUVrWEV1WlhzVlRyVDlIdDdDODIz?=
 =?utf-8?B?eHhLNG15VnN3TW5lUjBJWDQ1ajJHcVV0UkhyNEYzTHIxTEpwOVhzL3d5RXYw?=
 =?utf-8?B?UnlydVBVRnhxODdqRGJCc0tUcU5kQnZlTGt6RmYwUXhoSjROamxwVEJxMUhH?=
 =?utf-8?B?OVczVlBGTSthZjZLSmVlWjhqazZ0M0w5QmFWVlNFbTNLaS9iNVZWeXJGeEpI?=
 =?utf-8?B?S3YySTFjZFpCQWd2TUdqOTJUNVUvaEs5a3c1Z3hxRUJkdlBqQlVKWTQ5ZzUy?=
 =?utf-8?B?Wkd6Q3VxYlV4N0JldTBqTFV1aXBUZDBsbDNyZGp3dUszakVSMU50YmZEc2xl?=
 =?utf-8?B?V1JvM0hmQ0hvdmpKcmxoSE5LZnZxMTZBaEQ5cVhKOUJ5c0t4a0RpYnJsNEIw?=
 =?utf-8?B?aldobnVBUkg0M3FoWkErbDEvWHFCaVc2aEhtYmFXWlhYVjY4ZlJyVmtGUmZV?=
 =?utf-8?B?K0d2a2lzMm9Rb2p0ekNyUmpZZU5oekhZLzdhOTd6TkFKYjhVVzhERVgvNjBH?=
 =?utf-8?B?V0N2UU1xUE5qN2VhTFBUY3N3WnRkMkk5ZHczeVdWRzdWTnFKdmtvZ1pnTkpr?=
 =?utf-8?B?b0t0d2gwY01GbXFaTDVPTDFkR0ZvWUlHd0tOVlkzZStXdzAvdjBjd0Fza094?=
 =?utf-8?B?QlZvNGloZytjNElGbVdKUFBZWCsvYkx2SUJaU0xtSWFjRDBpc2lvWGhRM2ta?=
 =?utf-8?B?SGRIcVBIKzB6TnBPOTR0YmFrWFNJVzhaL1Y2WDdXWkV3MnR6SG1VbXNraHlI?=
 =?utf-8?B?OHdrZVNRWkR3OGZrZGdCK1NzWUZWMnljYWJySFRXejFYTGNLaVRSY2ZvN1lk?=
 =?utf-8?B?Y2VaZUsyanB4UTZ1VWdSS1JuRkZJLzB0T1lXRy9JOWVBallqMmZ3YUVCdjRp?=
 =?utf-8?B?dEFnNmdGZWxxWUNhUVlyTHhXMGtLSDIramVxMWx6MHpTNGtNZEhEZ0QwY3lz?=
 =?utf-8?B?aHBjQmt0T0lNYXJXYWlQVUp0ejVrWjNQbnpLZXlNcEpRY0liZzlzN3NTVlZy?=
 =?utf-8?B?MFpRQWZHM2MzdDZJdkRTdTJSRzN1QkdSY09hYUZyZTRaZk1aRFVmeXBod3cv?=
 =?utf-8?B?eWxpemsrd0h0ejBiRUk3Nno5NU5CdVpQRW1MbXRrTUM4RFhlUTJLdkdwS2Zz?=
 =?utf-8?B?UnNmK3hLWEdVTmlqemVlblgzRlhWRjAyZHFkYkZWRWppQzZDdWIxUlM0VWJ1?=
 =?utf-8?B?bGlza1FJUzI2RkZkcTV3ZDdZb2lUWElRQVZtUTNYdHVXa3RRVVJab3ZTUUow?=
 =?utf-8?B?bjhyeFVWWGZ4QXJObE9UYUprUUJyQ0Q3bzFDY25BdE5NUzB5WFF1VkxldllI?=
 =?utf-8?B?UXFtQ29VTm0rODVOSUx0N3hjc3VnUTJqRGQ2NkZkUjhBd1FUS3g5dDFwZU1M?=
 =?utf-8?B?OXhYeFcwL1dvVFNxblhCM2ppYXJ1WjVKK05iU25KRDI2V2V4bG5PTll4SW5Y?=
 =?utf-8?B?WTZWTE9ySDdyaHJETkY3eERZdyt4MkUzTWdEYUlVdmVrRUQzQkE5ejdnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1k1ZHBUR2lMTFR4cmJqWkQxMnBIRlV0dlVlc0ZkSnY3V282cWFnWnNIUXQy?=
 =?utf-8?B?WVQwMFN2TjFuM1dIR0VjV2hVbFRTcCs0YjJqeXB5eUR4Sk5BdnNFNU12YWgz?=
 =?utf-8?B?aUZjRVVWQXRGUXQ3OElvbHRYVmNuVlVTT2JOTGhYM1k0TDhYK0plOWJvemhp?=
 =?utf-8?B?SytGbHl6dXl4V2dDeHlVRFpDV2xvZGVXdDNmNmFvcGY4ejZYYjVLeXduMUVq?=
 =?utf-8?B?cTdxbzFKY3NTN3dYLzNFOUhhMDN4ZjNWeThqVXQyVUNuRWc2dDdQMnFXMG5l?=
 =?utf-8?B?Y05yQU5OOGRjY0d0ejVSTmtLazRtVjJuaVNrNno2TEFMOHBWTWowam1VMHVM?=
 =?utf-8?B?bENhalVPRlFkMWdUY043S1dGNXJJcU9JdnpoMWdEYTJlaWpUemwvWXB5dUZV?=
 =?utf-8?B?K0haU05UYzZoaWcwM2p6N3NLNmJjVUwzSTZvbHQ2aFZTa1FvZXhkL0ZGbmVk?=
 =?utf-8?B?TFRjdWZoQ0JXUlI0Zk5jc1IxSGowbEdTSExYWmZKSUlzbVovUFZJb0t2UGhw?=
 =?utf-8?B?ZmJiS01Tb3lLYmJKSkNSM1BZeHRXSkpEelF5aHNRSGplc2c3R3BrVVBNT1lJ?=
 =?utf-8?B?QVdRSFllNnNOS3FXdE1pS0VOMVp1cmZXemhod0Y0UERoZCs4NXhSM09XOUdW?=
 =?utf-8?B?aFdWNkRzcUVOT3pSUFFTeXlNR0N1SXI0ZTNwblAxTXZtUTRjL2RrTWpxN0xo?=
 =?utf-8?B?NlpSU0pHaW9HTUNsZ2FOKzYyR3F2QS8rT3FHay9Gd25SK1RJTE52ZE9aWE9B?=
 =?utf-8?B?QnIxT3ZHdllVVHhTVDh5WTJTYjBZTkRLeFlBTWhJdWtucUZHT0sxS1lxUVJK?=
 =?utf-8?B?RlRjZCtKRzh5OWE0QmloWVlJMlhDTTlnZjU1Qm9YbG9rcTJvZHVKK1pGNEVv?=
 =?utf-8?B?cXZ2T3ZpZjA1UDZSei9MdmFZcHJiRVc0dWtLa0VOdU1UT2xmOHZXeHFZQWo3?=
 =?utf-8?B?TjllL0oydzZ1WCtia3JMRFpNVGJWNHZucEVDeHpMaVpxR1JpTzFZQW9nQ05M?=
 =?utf-8?B?b1dYRzFvdHd2MFBnQ2JIOE5WWHFzelhxQWE1NERHY2d4UUlOZlVkMU1oM2E0?=
 =?utf-8?B?NFVNMCtJRnRrNkRIQ0VsamxkUnZESkhGcDM4SnYxd1AvM2UvYWxNemZSOGp4?=
 =?utf-8?B?SzVwUzg5bVhubmVhY3phaHdEckUyaXpGS1hQaXRRMTN1bGlIb3A2UWRkUytq?=
 =?utf-8?B?T1k1Z0t0YVcvMFFKaUtPUEFHSlJ5eU9UT1ZFSFlpUWdJemxVL1VhcjNPUnQz?=
 =?utf-8?B?bHlHM3E4VE04OGFXTGV1SithZmthZ2RaYzllcjlMYkFnbm8wSFBrZVpENVRt?=
 =?utf-8?B?VXRSMy9qMmpGdlNWQzhDcExDS29lQ1hNRCs1T3I3VXhvUU5jNytWakNyKzUv?=
 =?utf-8?B?Tk1vcXRSL0YvdHVLdXlsclhBMzZxckZYTDRmVzV2SW1pWTlWOE5tNEV0WmFH?=
 =?utf-8?B?cnRyNkl5b0I4b0VZTy85SGl0ZDJnakdOVEYxYklKUng1WnBWMFVHZEhNdVZl?=
 =?utf-8?B?ZHdwcDNVSkM2QWFQQ3pRZ3FDKzg2Ym52ZUxMd1VFSmdXakF3eW1VRGpwck5o?=
 =?utf-8?B?WkpuNVRKTHpEMVh3YXhPSjhPejlQblllRXJvNVdSekFLVGhCZkNlVmlMV04y?=
 =?utf-8?B?aHAwUHc5eXdwcUM4NmYyRTlqbTh6SWdodzdnZGxKRVNZRW5vNUs0ZGlJY012?=
 =?utf-8?B?ZUNjd1VTYTRNanA1ZW92ZEMzRTBVazRKTWVlWVczdnVLcTRkNnNqY1NCVzcv?=
 =?utf-8?B?Z0RKcXdXeUxNYk42aDJDdmtHUlhNRm0rcDNpdEZ3U3UrbnlpZHljNHFUNVRY?=
 =?utf-8?B?ZmNIRmljTW04a0VEQXZNTWxjazlPL3E5SWlNRDcwSWU5TG80dllEc0tWaHRX?=
 =?utf-8?B?R0xLaG5vV2tQYmxKTHRvY3NEZzRRNjNkM2hGeUQ3NjlHRUw0Y05jRW1KcEo1?=
 =?utf-8?B?UXFtL1BISnFES3UyZnBlTmc0UTNWQlRxaEZEQ3g4SmhpQjgrK1hmTGlhV0Z5?=
 =?utf-8?B?M1Zrc25LSWlHQXRyQnEzUDNHYmxJVFQ4Q0p2MmF3MEVPUERnaGl4RTErR0JL?=
 =?utf-8?B?clppY1NYbklnd2JXOGFQWUJvWVRGWjRmdmxEMi96WndOOEJkNHFkazFObjU0?=
 =?utf-8?Q?hxGz5qCpXjkIad+SrVM5Oajvq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 59efecbb-159b-4857-b51c-08dc6e3ce565
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 02:25:00.8877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/0vYimqKlzFmUesUlRUChv/z895iOAnxq2KUjAxF4oOs9RKsbmR7m5RvF2muA3r2+nX/CxH3agbmSDoTn4kgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6558
X-OriginatorOrg: intel.com

On 2024/5/6 21:36, Jason Gunthorpe wrote:
> On Mon, May 06, 2024 at 03:42:21PM +0800, Baolu Lu wrote:
>> On 2024/4/30 17:19, Yi Liu wrote:
>>> On 2024/4/17 17:25, Tian, Kevin wrote:
>>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>>> Sent: Friday, April 12, 2024 4:15 PM
>>>>>
>>>>> From: Lu Baolu <baolu.lu@linux.intel.com>
>>>>>
>>>>> This allows the upper layers to set a nested type domain to a PASID of a
>>>>> device if the PASID feature is supported by the IOMMU hardware.
>>>>>
>>>>> The set_dev_pasid callback for non-nested domain has already be
>>>>> there, so
>>>>> this only needs to add it for nested domains. Note that the S2
>>>>> domain with
>>>>> dirty tracking capability is not supported yet as no user for now.
>>>>
>>>> S2 domain does support dirty tracking. Do you mean the specific
>>>> check in intel_iommu_set_dev_pasid() i.e. pasid-granular dirty
>>>> tracking is not supported yet?
>>>
>>> yes. We may remove this check when real usage comes. e.g. SIOV.
>>>
>>>>> +static int intel_nested_set_dev_pasid(struct iommu_domain *domain,
>>>>> +                      struct device *dev, ioasid_t pasid,
>>>>> +                      struct iommu_domain *old)
>>>>> +{
>>>>> +    struct device_domain_info *info = dev_iommu_priv_get(dev);
>>>>> +    struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>>>>> +    struct intel_iommu *iommu = info->iommu;
>>>>> +
>>>>> +    if (iommu->agaw < dmar_domain->s2_domain->agaw)
>>>>> +        return -EINVAL;
>>>>> +
>>>>
>>>> this check is covered by prepare_domain_attach_device() already.
>>>
>>> This was added to avoid modifying the s2_domain's agaw. I'm fine to remove
>>> it personally as the existing attach path also needs to update domain's
>>> agaw per device attachment. @Baolu, how about your opinion?
>>
>> We still need something to do before we can safely remove this check.
>> All the domain allocation interfaces should eventually have the device
>> pointer as the input, and all domain attributions could be initialized
>> during domain allocation. In the attach paths, it should return -EINVAL
>> directly if the domain is not compatible with the iommu for the device.
> 
> Yes, and this is already true for PASID.

I'm not quite get why it is already true for PASID. I think Baolu's remark
is general to domains attached to either RID or PASID.

> I feel we could reasonably insist that domanis used with PASID are
> allocated with a non-NULL dev.

Any special reason for this disclaim?

> 
> If so it means we need to fixup the domain allocation in iommufd as
> part of the pasid series, and Intel will have to implement
> alloc_domain_paging().

I agree implementing alloc_domain_paging() is the final solution to avoid
such dynamic modifications to domain's caps. If it's really needed for
PASID series now, I can add it in next version. :)

-- 
Regards,
Yi Liu

