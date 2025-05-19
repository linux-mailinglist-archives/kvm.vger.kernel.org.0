Return-Path: <kvm+bounces-46989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A69C9ABC1A7
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 17:07:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF5C9188B2BE
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 15:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AAFD284B48;
	Mon, 19 May 2025 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VxBPVslv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D62128466A;
	Mon, 19 May 2025 15:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747667202; cv=fail; b=O4uSmVEaRxjNkhYkQezVSrzOU0GGRPWE9cllVKNOCTqba6UPNFGzDwjaAQLvJ+rYj+8mWRjfmhpuRJvdkL6lVAb8gBH0bNQ6L9GV8C5Xt+YJYpg27EvJHYnbBt9xYjtKxoCEspKMbEKLQAd6Oh0vK5jpuMAcsAsRrM1mFunFYzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747667202; c=relaxed/simple;
	bh=RMLnJnHQpbSwfq43BGOonOPaJajL9NiRLW6vm+M4Qbo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YmIsjDEnOah4ynvi2utHjj+I+EEVj8VJ/lCreALvfsSSX1MONHSqSjDnlE//CKEbOCdk59Xw+1kVoVg6EzrI9nj6YLLfYy+exnaKDNdJqh1F0tEH6RcjKsQHG4mY/8Mxm6NHyzAClTjJkoLxlKkAqtiMY7K3p2lgHvh58Xy/Sok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VxBPVslv; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747667201; x=1779203201;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RMLnJnHQpbSwfq43BGOonOPaJajL9NiRLW6vm+M4Qbo=;
  b=VxBPVslvgfDdRIt+bqlFFhzyiwW4KzWwNugwtBhYSULmo8Mm+mEbiNBD
   369tL234K4pLJLA4OIrOmEFhO4QL3/louc3nFCkynCC8XPfgn3Pd+W01y
   eL/c73MgxGBQRvjAVxQvG+Ji3ak+nrPgknnaIRvkFOF+Wzp46yyLTl17S
   qy3PBOCCSetq1F7BqyPwBTtOucA14/pOcAItk55K17gvFRPTVQOCn2HxW
   Ce9QScUMvg5Cy/KqOIeGbOWDlAPht1PS4zyC9ypY9tHoKCU/N3OPpTFoz
   vG+3UzaTjJ4sAeXzHV4aVfR9KjDLOWmfDaRuNx0W5fRInEN6O++Td+KFW
   Q==;
X-CSE-ConnectionGUID: 7VQ8UGKHTPKkKAUvNF+zmQ==
X-CSE-MsgGUID: aF9WHFgqSv6Pp25zmnymag==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="60205494"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="60205494"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 08:06:38 -0700
X-CSE-ConnectionGUID: lfJJGr5eSfGotJgoWWP0qQ==
X-CSE-MsgGUID: x9kNJ174R0C3ry+pxjDRsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="140288396"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 08:06:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 08:06:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 08:06:37 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 08:06:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b+jMUOfyEnnzKkkB/Toah5Md/FbpRdTvRVlMZycfaJMIu10rwOvU7iUSfGB+94/2RPEFHv1Ont0y/w08wk7rsJg9DGA2sCwebKrG7jN4b0hp8ggAU0hRFIkqy09l8TYET8wXIroUd2M4hyV6SQ8BDdHbDFf9sd1USpgMiu7L6cUBVDBmvmQj0/iqUcmFMM3QDIV5O2URsgfk0YzZsBxQChXKxYl3AlegOHKossMx66UBr2H6ZBxRhOH9hykdaE4+VZ0+lYceRt07bZ7/xBJPSipf3QYgXSfMfMysWK2lNUjvfjJk1sYtl9NksE758Wtr9OhLdGT3l2J4PX5w3jKXug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j0rpRvxOw6LEhBWR4m51u8rkDbWivAV6iPcrFMPUb48=;
 b=kCTzFyk8uwSzvyH6LymYKURxFpEF0qS3VceVoLSRJ+8gv3HGhOjajWjMKyr9soO90ZtdokPd8y+SMIHXHNPXUT+HKKZOxnFmjQvKZR/uHDP1x/OOMtgJldEhtVt6PKqaR03PNlKgKEggC8lcPaauawXliSiFexEJ3D4OcoSv8x5j2Kj2z3pjXR59JXK0xpAkefQ7oH3dgGP9/+iP0h9Ed/U9iZp/9x32CniprS9HDk7eR6U1bDaM2pSPy+1CLDJz3+XT03QyV67fKnWdBRCahJ+SmnKTaantLpyOeLFWJqYcY+gGRUpgxXXrNFknkomWI7t59QOXMxERivoF0y2oUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by PH0PR11MB4791.namprd11.prod.outlook.com (2603:10b6:510:43::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Mon, 19 May
 2025 15:05:52 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15%7]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 15:05:52 +0000
Message-ID: <8f9df54a-ada6-4887-9537-de2a51eff841@intel.com>
Date: Mon, 19 May 2025 08:05:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for fault
 retry on invalid slot
To: Sean Christopherson <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>
CC: <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
References: <20250519023613.30329-1-yan.y.zhao@intel.com>
 <20250519023737.30360-1-yan.y.zhao@intel.com> <aCsy-m_esVjy8Pey@google.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aCsy-m_esVjy8Pey@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0064.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::9) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|PH0PR11MB4791:EE_
X-MS-Office365-Filtering-Correlation-Id: d2c59d20-f891-492a-8d58-08dd96e6a5c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aC9mM1NxcFhNWlZJak5NNmNwRjJuUEJGODNiYTJHQVVwcjZyY3BOSmdGdWxD?=
 =?utf-8?B?djZCeWFtSXZveTg1b0F4VEpwL0RIMU1CRDZIN29zQkJDeHZDb0VTanJyMkZQ?=
 =?utf-8?B?S3hKcmg1Z0xIMGNSZE9GbjhRNWx6NWczRGtySEpJM3poMVdGdVpGN213ems5?=
 =?utf-8?B?OVRtdElJWG5BNVB5RzJ5TmZnNW9FR01wT0UvOHFZQTV5Y25icFlqVnhrZmdL?=
 =?utf-8?B?V2h4M205Lyt3cGlBZmlkejRacXNVMUwrTkVtK0QzREtwR2d1dEpxalludzhl?=
 =?utf-8?B?VVZQTE5WQnhVbEJWMmZKUngwZy90U3dOdVJmTmRxM2pCbXBXOSs3Z1ZTYVZ5?=
 =?utf-8?B?R2VSNHZlYUdTQ2FBTG41QUZzb3BlRndHbWQ0SlRheXlqVDBZS2Njd2hoSHdh?=
 =?utf-8?B?ZXc1b1JOcC9WSytEcElEVVRZRVhuK0dRRWd4UzB4aUVWLzhHNnBuNnhCNHZY?=
 =?utf-8?B?RndFZ3JXSlN3WFNJcElRSWVkaFRvN1BDYVZSc1VvNFVvRXRhTnZ6eEViNlBl?=
 =?utf-8?B?TFp1S3pKRkYwTWNDb3lCTnpqaTg4VWtGWHNrSlpFTm1tLzlSUmhwT2pLdTMv?=
 =?utf-8?B?Sy9aMk1NYWQzVTh5L1lCQVlxZXZNVDdaYU5RNnB3OTMwTmh4Rnh5OHZOL2R1?=
 =?utf-8?B?MlMySE1Qbk1tQ2tvWTArV1k5YnZ0bFFpcEtLUHVqQzJzZ0haNXA4TldSdXpW?=
 =?utf-8?B?MkhIRllNVlBjL2xDNjl0Z0NFcGhZY2R6WkxYODlMMmdHOHI3Nm8yOXM0M0Q4?=
 =?utf-8?B?eVlhdGxaZHNOT2dBQmt5WjN6ZUl0NU5UbVlxUWZGVVpreFZDUWdocXV4MzhH?=
 =?utf-8?B?YmJ4ZVFleFdBMVpFOUorQ1hac2lvMWFualNQZ2lnRmJyVXFuUHhPNXNiczlL?=
 =?utf-8?B?M0xBWEh3WGNWQ3dKNkNib3phWVNjNGY5TlE0TitmT2NOOFp5eTVyQVpZWVBt?=
 =?utf-8?B?SmFyd1RPV2xvc3E5RXVSVW5MaXRLRXhwSWV1OXdYMmtVa3lucjNOcnEwSW9G?=
 =?utf-8?B?UGVteWx0VlZpZ0hBSGxkWjF3d2JRMnRzeGlXS0s0Y3NtY1V1M0NmUGRjSnhZ?=
 =?utf-8?B?YWRHei9sS2s3TnNvcWtaRlBpazJ6L2dPUkVYamV4eFBYQjErVUp0YmZwZmdt?=
 =?utf-8?B?SGxKL1NyT2w1M0QvSEtRYmpNaGZMZkUyTWdiRDlXYTZvYTJCdTdSY1Y4eGpv?=
 =?utf-8?B?U0hjb0pscmoyVDBjaVFyenlRNGdHVWVvYlkvSG5pVnNSa0xpSnRUUk1xMUNB?=
 =?utf-8?B?YUVIajN4SkdqTXZvSmVzT1dPK3Q2RWh2VWlaRDl4RWRHOFcxUERKOTlxR2Uy?=
 =?utf-8?B?NkIwM0daRFczOHFDam5ZUUpMd2JXSEJxZlFlRWNkTEhMZUNWQzY2VmNZcGM3?=
 =?utf-8?B?bFBwbFF3Z0RNZkdtaHFQY2NucTVPbHNHR01oTmVwYzlVSFFOYXM2dUsxQjR4?=
 =?utf-8?B?a3IzWlNyV3dzNEx0Rit3M2FBdm91MnRjOG1MV08xM0VmbXQ5K1lHVEoxVVVu?=
 =?utf-8?B?dXpaMmhhQmN2dVh3Uk5aZ29JcUV3M0ZFK0lCMCtiYnlUQnV3eGwwZStqU01X?=
 =?utf-8?B?WldsMEl4SC9MNXBlZWhwQUdPdUlQZHZzRHUxVlBLSjEvKy93emU1SFhWbS9Q?=
 =?utf-8?B?bTFlWVAvQ1lIY0crSmt4M3MwM2d4ZFBGN042ZExmMkhTNjd1bmtxT0ZONjlV?=
 =?utf-8?B?QjJZRTlDQm1tckw2WHVWR2pKWlEzVFg1S1Jhc1V1ZGcyZWFtd1hSMHh6SXVx?=
 =?utf-8?B?d29CR0pNNFpEbWJ0TEsxRmtjTUhxNFViOFdmLzBpS01kdnhJbVNvSUo3d01l?=
 =?utf-8?B?RzgxcUJKRjl5MXRLTE52SlhFT3E4bEtTVmNTYjRjbHkweUhMN1F6OTFkVURu?=
 =?utf-8?Q?D7bj7pmVci9GZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1BTVEtuK1htMWRyMnVwTWYrTmtFTzJBYjV0ZWp3bDFUQVNyTWUyYU9zQkRK?=
 =?utf-8?B?S1M0cFg0eDFkemsxdTdiUzFZOEUxeFdORVh0SjA0bEhhSkVvR3g4QzRYZTM5?=
 =?utf-8?B?c1V3ODh0dGN1dllYdnJ6N3hObzdmYjVEMzJNeEZ2WlIxNXFVeW9xemorRzN6?=
 =?utf-8?B?RmlCMytubFJVNzBKL281YXNJOFdzeW5NbGZ2QTlvdVY0T3YxWmhtbXRLbzFS?=
 =?utf-8?B?K1BqeThBNG9DaGlHUEh5RFZhWDBGSERNUzhNUHc3NjhpM29CTGhBWWZiRGhN?=
 =?utf-8?B?Sjg0N0JMWk9OVFFtSUNnR21kRzUveFdsYm1jZWNTWE9RMnc4VCtucS9WdDY0?=
 =?utf-8?B?dkZFem9sSElKWmxSbE5keXVSRmE0b0IwWHliMUt0TUlQWHZJYzBhYmltcXAx?=
 =?utf-8?B?SG1RWDFzR0hJaVVUaTF6aDlaSWFwSlM5Nnk5cVhoZEFmS1NJc2hoYWV2WEZv?=
 =?utf-8?B?Rmc0dmNOdXFrbEpsK1NnSTBQQUFDK3BJaUF1K2FlbXQrREhURXg2Y1h0QXI1?=
 =?utf-8?B?K3BkVFAzVC8vYVowNlZXZXYwMGJQczZSRDYwV0NYaUNVbm1Nb0hZbHJzRUJr?=
 =?utf-8?B?aldvckN1dzJkSTU3d05obC91MU9jVmFZS2svOFYrYmNDdVpIM0xyekVtMWVk?=
 =?utf-8?B?YjFLbHI2Q29ja3pXZVhFZ1Q3TzlCTTZPNjZxb3YwQ0hSRzBCdEFHYVUzRTNC?=
 =?utf-8?B?dWVXTUhMYXZKWTNuYzY4ZHFSb1RoMmRCZm5jTVNLMlp4c3NUaGxnZXlESEZJ?=
 =?utf-8?B?Zitqc0Flc3R4dXBhMkV3emM1VVB0cGF1eHBvOFJSK0lkY1g0RitTdWM0bjNP?=
 =?utf-8?B?TE9oVWg5OGEvOUtFdUJzWlJMYzk0Nis5QXlFMHhzbWRXeTdIeUNBUTk1bHJ0?=
 =?utf-8?B?QXpCZHlZWmxtVHZDbGV3RjlNUGlXa3Rsdzd3Zmt2bEI2aUJWcjlaWjEyQ3FY?=
 =?utf-8?B?czZMYXpVb21DR1ZaMGNpcnM1bmQvR2ZjVEFrTjkvZEZCMW50MCtUTHl1c1o0?=
 =?utf-8?B?VTh5am9XNnJINVhiWGFSMkYrYVNZcmpTQ25yc0RUcktFT1hOM0VpK0RBMTAx?=
 =?utf-8?B?MnhtNjU4N0UvOFRXaCtyRUZrTzh3K2FPSnBseTdXSTlFdk9JbG9ETEpDNUZv?=
 =?utf-8?B?Y1lqT3M4WTF5RStuL1R3dUFlZEZBODBmQXg3cis2cm1BTmNLWkdFZEVrSGZ1?=
 =?utf-8?B?WXZad3JodytPdXB6Z0NRcGRKcVhhU2lYWjluUGlaeWROY3NHQklMeWEvcGJi?=
 =?utf-8?B?N25WcXBvMUt0L1laaWlaclgxL29zbWhsdnk4VURvQUkybGxqKzZJcXRINWh0?=
 =?utf-8?B?ejNSWGFSK1o0VG9TbG1OWENBUEptUG5BMUg5RjRCaW1nbUtvbzF2U1ZmTVVu?=
 =?utf-8?B?bTlmYmk1ZUVjekl0cFZDRzNWTmZZek5obmZUNTV4dUc0UzM4ZkpqRVQ5d3dt?=
 =?utf-8?B?aFdaM1diUE1HbkFWcnJzc1BuWHptTjZlNmhORjYxMHZaNHAxTU5PQkY1NWVE?=
 =?utf-8?B?d1h3ejNQMHdVNHRmckVreklGeERETmgyU3d1NmRQYmFQVSsvdjNUMStOcTJj?=
 =?utf-8?B?VVJZYmU2MUxiWTVOM2ZaeHBUNVhXZitRTnYyZ3VLejVWZys4NENFMXFxeGpt?=
 =?utf-8?B?a1dBQjdCWng3SXpxaEl2SFZjdUVnQXltd3FNM09qVFJtaTAyU3FWaituQTd3?=
 =?utf-8?B?c2MwN2Z0RE81MUorZ3FFYXlHRkJHd3lSc3BoSWYzTGt2MVRwaGpsZG1Vb1Jr?=
 =?utf-8?B?K1NxdU84bGJMMjAyMkQrNDRadVBtTm04MXVUbVVBU2d5YmdsMG9veFIyNThk?=
 =?utf-8?B?anhiMUdtQS9Kenl0WDU2cGpsd2FtMWsvMkFwTmdpUEtndE9ET2RWMFVNUjF6?=
 =?utf-8?B?R28zWlFMdlVSRE4yS1AyaWRBOUFVRjBXa1hUZEkySVVJdnhiVkl3K0J5K0Vo?=
 =?utf-8?B?UEM0OVVXK0oyeWV1ZmdvRlZqZWZLVGNPVzFDeTlta0ZYQk1uOGNSTEUwSVMx?=
 =?utf-8?B?Q0w2aEF5NEpxalJWMkVnSzh5YWM4aU9Gek8wMkY2K3QxT0F6V2FTa2VCelZh?=
 =?utf-8?B?V3NiQi9NaTFhSTlwMjFNWm0ycWJHcS82Z0drM0RRTmwxbkNpZXBpTG1sbnZM?=
 =?utf-8?B?VFYvcG5yYytnckpjUThjeXBkbEU2bTU5K083Nzh5bWZFaFJrSmh2T3ZrMDVJ?=
 =?utf-8?B?Rnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c59d20-f891-492a-8d58-08dd96e6a5c6
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 15:05:52.5952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vreqIQNl2Obxv6oe5028lJwe4PvDFdNQnxl0ES89KASRYPAsbPc7YV0j/7TvwJsik7yh1V09bf0EpKzZutCia9zvhLFvFsrQCKPtduehvHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4791
X-OriginatorOrg: intel.com

Hi Sean,

On 5/19/25 6:33 AM, Sean Christopherson wrote:
> On Mon, May 19, 2025, Yan Zhao wrote:
>> Introduce a new return value RET_PF_RETRY_INVALID_SLOT to inform callers of
>> kvm_mmu_do_page_fault() that a fault retry is due to an invalid memslot.
>> This helps prevent deadlocks when a memslot is removed during pre-faulting
>> GPAs in the memslot or local retry of faulting private pages in TDX.
>>
>> Take pre-faulting as an example.
>>
>> During ioctl KVM_PRE_FAULT_MEMORY, kvm->srcu is acquired around the
>> pre-faulting of the entire range. For x86, kvm_arch_vcpu_pre_fault_memory()
>> further invokes kvm_tdp_map_page(), which retries kvm_mmu_do_page_fault()
>> if the return value is RET_PF_RETRY.
>>
>> If a memslot is deleted during the ioctl KVM_PRE_FAULT_MEMORY, after
>> kvm_invalidate_memslot() marks a slot as invalid and makes it visible via
>> rcu_assign_pointer() in kvm_swap_active_memslots(), kvm_mmu_do_page_fault()
>> may encounter an invalid slot and return RET_PF_RETRY. Consequently,
>> kvm_tdp_map_page() will then retry without releasing the srcu lock.
>> Meanwhile, synchronize_srcu_expedited() in kvm_swap_active_memslots() is
>> blocked, waiting for kvm_vcpu_pre_fault_memory() to release the srcu lock,
>> leading to a deadlock.
> 
> Probably worth calling out that KVM will respond to signals, i.e. there's no risk
> to the host kernel.
> 
>> "slot deleting" thread                   "prefault" thread
>> -----------------------------            ----------------------
>>                                          srcu_read_lock();
>> (A)
>> invalid_slot->flags |= KVM_MEMSLOT_INVALID;
>> rcu_assign_pointer();
>>
>>                                          kvm_tdp_map_page();
>>                                          (B)
>>                                             do {
>>                                                r = kvm_mmu_do_page_fault();
>>
>> (C) synchronize_srcu_expedited();
>>
>>                                             } while (r == RET_PF_RETRY);
>>
>>                                          (D) srcu_read_unlock();
>>
>> As shown in diagram, (C) is waiting for (D). However, (B) continuously
>> finds an invalid slot before (C) completes, causing (B) to retry and
>> preventing (D) from being invoked.
>>
>> The local retry code in TDX's EPT violation handler faces a similar issue,
>> where a deadlock can occur when faulting a private GFN in a slot that is
>> concurrently being removed.
>>
>> To resolve the deadlock, introduce a new return value
>> RET_PF_RETRY_INVALID_SLOT and modify kvm_mmu_do_page_fault() to return
>> RET_PF_RETRY_INVALID_SLOT instead of RET_PF_RETRY when encountering an
>> invalid memslot. This prevents endless retries in kvm_tdp_map_page() or
>> tdx_handle_ept_violation(), allowing the srcu to be released and enabling
>> slot removal to proceed.
>>
>> As all callers of kvm_tdp_map_page(), i.e.,
>> kvm_arch_vcpu_pre_fault_memory() or tdx_gmem_post_populate(), are in
>> pre-fault path, treat RET_PF_RETRY_INVALID_SLOT the same as RET_PF_EMULATE
>> to return -ENOENT in kvm_tdp_map_page() to enable userspace to be aware of
>> the slot removal.
> 
> Userspace should already be "aware" of the slot removal.
> 
>> Returning RET_PF_RETRY_INVALID_SLOT in kvm_mmu_do_page_fault() does not
>> affect kvm_mmu_page_fault() and kvm_arch_async_page_ready(), as their
>> callers either only check if the return value > 0 to re-enter vCPU for
>> retry or do not check return value.
>>
>> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> Was this hit by a real VMM?  If so, why is a TDX VMM removing a memslot without
> kicking vCPUs out of KVM?

No, this was not hit by a real VMM. This was hit by a TDX MMU stress test (built
on top of [1]) that is still under development.

Reinette

[1] https://lore.kernel.org/lkml/20250414214801.2693294-1-sagis@google.com/


