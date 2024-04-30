Return-Path: <kvm+bounces-16277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A91178B81A7
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 22:49:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57509284C85
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51AB91A0B09;
	Tue, 30 Apr 2024 20:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j2NrYATk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B5850287;
	Tue, 30 Apr 2024 20:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714510146; cv=fail; b=rVPPo0Ev+MZMdAqzduY+O/zUwA6SygDFgXdCkvocuSP8DvP3T+X1FlP500hGg0KJ8bbPaEmt5+/nKkYfJhnlBb19+l86HzU4gT+omPGz6bJK5v5c2qZa0pR1uIybc0Oy4BkCbI9hP8ybXJefMk09XCqVZMA/aV/g5H6nesmASNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714510146; c=relaxed/simple;
	bh=wjNkbLQQkjqMHPinGkLRBdYY+mdMtgD74+GJlpzpYaI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g8wdrVyGEvrv54FNJhWVVWEMXExXQDSmo2LpBA1uxWBAlLfrDXjCeLd19V+00ToKmCdHI5X+D7v2PNp2lXNoqzFL+07dTyzRSHpu3S1ivlymkkcoPvFmSI7KuHzXIGdsh7hL7khTCK8DQdhUP0BxDVVVDOLyt6Gp5fwXInf0uCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j2NrYATk; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714510145; x=1746046145;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wjNkbLQQkjqMHPinGkLRBdYY+mdMtgD74+GJlpzpYaI=;
  b=j2NrYATkYKCYKv1tV0JSZgXLKKa00XxxWxZwiJ0xxeMcNc6WuH8Xvmbv
   Uv9/BrG4DIhhD7MLj8Dm7Q0DqEtSYm0fQcvLcTLdpGVbszw2VTxgQnR9l
   3Bg2HeaOGBNNq5V89Q1w7FmIV821XFugZHt/qzCBMVn9FFFpKDPYwQUeD
   h9BawZpk23//Q6i07DuJqVtwOugflN8isyT1kwHiEBcFFbIs844fJrNnT
   7uXnHQMLrEnBaIbbnfpE/pyD8ZvVG3EjblnnVTwYDud7xWv2rNfytaWFn
   lm77/xHAuC9NM3lNxX6Y4Qg6WslpopIeM3dcvvG2LzibW4BQAzo1ujwkI
   g==;
X-CSE-ConnectionGUID: rEmA9tHvRgC9eFPozxtqvQ==
X-CSE-MsgGUID: KT+Gd5v3THaUijAcFzRCQQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10778535"
X-IronPort-AV: E=Sophos;i="6.07,243,1708416000"; 
   d="scan'208";a="10778535"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 13:47:27 -0700
X-CSE-ConnectionGUID: UFFHitwbT/OZF9kP3Bh8IA==
X-CSE-MsgGUID: 2l+RiVdSRKWgbNnKsFkmYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,243,1708416000"; 
   d="scan'208";a="31195172"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Apr 2024 13:47:27 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Apr 2024 13:47:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Apr 2024 13:47:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 30 Apr 2024 13:47:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 30 Apr 2024 13:47:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzaH3vP0tax51KGYEMnObiRYDsQYvJqjY4f214mD/V4MJhjpvf1AYyOQEEUweASKfadXGpfXrOInNNS6qbAbUgakHeXvQDq/rHHp/xDMe0LDUvoMmEqmPtLZDi5jL7B55OP/hnNdDqYsu84DKF0OjJVKXEuxlHuA7fqx2MbPsDOcYxrG/4RWjPL1G4oyPrBE6eR122QN4jlVsxldDnYHbEP6jU5tCa42SraZ8cPRyQhCmKmyhz1BUARPyyOMuMcNQOSnsB6RBIBl0rv0us2sGfMYTaOVAYKnWf9i1DAA9ojsWHYVQabEonrGhsdy+zN8ZkoIFaRSntOsaTrBPzgYfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DoaZsgNXd0HDA+SXDeaDlV1OYhUCQxN0PS9DEM8uLAY=;
 b=XoSvVgwofAF21k3WjO9/b6Ips6SaYfTdAcPT5qFqtNk+YjFQTtH0tBWH4tjTutjGe8bWgJKoSh68xeVvY17mVhlOTE59J5tRnBQcouVU+1IPIFro9uDONQnKPhDo3k6kswc2+qdAT0NOPYOURDKegUEIuwLeZx+bo1OKbK+0KRNnRq94RFWoR7xldpoRz0cqrU3GwkyGL4gv0n0QkQ6TcOk7SC4+gMKxKOJIIFXgXYUCpDon/5j+r60esMtZbRiGptJZQ9nPCRqRB1OV9/esKKhsSSrbp8H5OknMMe3KToN/0qoY8FmaCHF5+/HGYfHE9w9PQ1Yt8SmR7w84wlyXVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by DS7PR11MB6296.namprd11.prod.outlook.com (2603:10b6:8:94::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Tue, 30 Apr
 2024 20:47:11 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::3dec:f493:d0a5:753c]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::3dec:f493:d0a5:753c%3]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 20:47:11 +0000
Message-ID: <43cbaf90-7af3-4742-97b7-2ea587b16174@intel.com>
Date: Tue, 30 Apr 2024 13:47:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 101/130] KVM: TDX: handle ept violation/misconfig exit
To: Isaku Yamahata <isaku.yamahata@intel.com>, Chao Gao <chao.gao@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>,
	<isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f05b978021522d70a259472337e0b53658d47636.1708933498.git.isaku.yamahata@intel.com>
 <Zgoz0sizgEZhnQ98@chao-email>
 <20240403184216.GJ2444378@ls.amr.corp.intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240403184216.GJ2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0275.namprd04.prod.outlook.com
 (2603:10b6:303:89::10) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|DS7PR11MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: f0ff1ac8-eb90-43ff-24b8-08dc6956b52c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z215eHZVYnJ4UENQTG1IblRuL2VrQ3dZZXJQb1kzVjRtYWIvaGJZcEpHcWU3?=
 =?utf-8?B?d0h2SjZzZllIcDBSc2UvaWpVanlmZUNxZG5aeDh3QWhyRmZzcXpwRVh2OVlO?=
 =?utf-8?B?aE9HNnM5ZFlVMFpIazVOZy92UWIveDhibzV1ek1NM3FNenU1bXFYR0NUVVBh?=
 =?utf-8?B?RzZvMGNlMGVIN01nRHVIWGVyc09nU1psWFV0bnRwSFRRUkcvVE5tajFBbGFV?=
 =?utf-8?B?MkN3cHlLRnQ3N1FGRnlDRW5uL3lOSFd3ZWMyNXFrcEo5ODhMTW1DcjN1TGxr?=
 =?utf-8?B?bTZUMHNwOVFLb3Nob25yS3lkKzdqSERXUEZhbVEwQVpZU1JXL3M3MVcxUlZI?=
 =?utf-8?B?VjZKMHNpT0xRaHpJVkFOajQ3QmJWaUVpR25uWmM0NXdnay9jYkdMRHd1YnRM?=
 =?utf-8?B?NFpUT2pNcEIvWFk4Um5aZ2c5eGtoTVlqOVo2Tk9KWTVmUHhsZkV6VDkySnh2?=
 =?utf-8?B?RWU4eS85SkpyMThZVU51cDFzQ09LMDFTQjZCTGk4WTQ5MXg4ZWFlM3RVR2h4?=
 =?utf-8?B?Sm4wa1YxazNRU3U1VkQ0QStnT2NqT1BzMXNRRFIwU0lPem8xQUw4ZDVvRXNW?=
 =?utf-8?B?VmFZNllrelExcG9Vb1Y0Sk8zWm9XKzJvSXlrUi93VU1BUVdPTlVHVWhHNjBK?=
 =?utf-8?B?L1Z0UmJjTzI5VjU1aC9DQlRDblEwL0xzbmxCRXRrRUp5L1NDc1Exc3AyRDZ2?=
 =?utf-8?B?d0Jydmt5aGNuQU5sZWdaa0dOMXZISE50ZnBrejQ0RDlqWVdtajd4WGtYRjZq?=
 =?utf-8?B?YTBab1kzNmJxVUFaMjVIRDlvVFByY1dWcWZCNVErWEU1Z1Ryd0dyVjBYbmVL?=
 =?utf-8?B?enk5R2FtYU9DZGxKVXZIWFNKc2pCYTlUVnBwS1dNVUlVZDh1UDJkMDUweTFz?=
 =?utf-8?B?Vkw2bXV0VzhHNnp4ZWo1cFBqZmN4Ui9aeHlCakdsQit6RkNFejRyT3poY0hu?=
 =?utf-8?B?RGFadU8zUm5HOEpBOFN5aDN3Rnc4eTN4VFNHRjdFZEVEcEtoM2tqSytPM3RT?=
 =?utf-8?B?M3pqSXBjMTl3em5WdUQzUFMxU1BKVnVMaUxONXljWmFJaGF2ZnpELzJwMXB3?=
 =?utf-8?B?bnpnYUFjenVWOVBxV0ZvalRiUXgycnpBWFEzNTBpemozdGJlM1QvUFBlR3Y5?=
 =?utf-8?B?S2l1dWdUZDJ2a0pXWExuV2UvaEI0Rm9nZzhJUzY4MnBDUkJlbTkxVTRpNjNW?=
 =?utf-8?B?YlZVL09rTFowcDFZR0ZSeGNCeHlzV0NZbWVybklwYWMvWUZCSkxhY00va3oy?=
 =?utf-8?B?K0o0dVQwUUUwaGtuUG85RUswd3BvYzVKTytHczhveFZEMGxMVGxuSzJkK1h5?=
 =?utf-8?B?amZ5M1N4Q1JVYW80T1l2cTM2MEpmUGZXQVJBdmRPUXBQek40ZUFSUkJ4VnRp?=
 =?utf-8?B?RmwwREo3SUFPY05COUtNamYyWjlHMkRVaUF3ZlFpUkNSN2RPSDNFV0FDWWNM?=
 =?utf-8?B?OG5sTkpZOGdmNHYxSHpTNnJjMm9HZ2hhOTZvNHVVSHAycjZLaUtmZVBOVy90?=
 =?utf-8?B?UTBWUmpJSzN4OXFvQnY4UHJvbTZZZ2ttNEVYZE00Ly80ZE5LM2tlbGFvQWQx?=
 =?utf-8?B?WHBoR1BkK0F3bTJDZVVzWk95Ykh0eTFsT2xtNlc2bzZDNWxXOFhFK3daZVV2?=
 =?utf-8?B?YjExc2FrNlJkMVFCTEtZRTQ1QkRZZGFHYWtDSGVEUm4vZTRldkMya3N4c1No?=
 =?utf-8?B?NzlDaWZCN1Fmd1YxV0ZTMy9YWjREcDlrRWxvUnhQa2M2NVNaV0o3LzNBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTU2amJGK05zWFlYRzc5Zi9zMG15dERQTTdYTWRMa2piRGNFNWlDSHEwNlVB?=
 =?utf-8?B?bWZxUUF3TThrQXRORFV5T21Uc01wcnJXUUNJY1cyM2JEcm9Cd2hVaC9iS1Rq?=
 =?utf-8?B?dGpiMW5WTU11RmZuVkJobWxMTUZ1NDVWeE13VnlwSndhbUc0bUdseERlSlFT?=
 =?utf-8?B?bzVXcHFJam1SVXliUGJ3dkVSRHdTblkzUmVIcXQ0Rm1MRTVDM3E2VVRIelJa?=
 =?utf-8?B?b05BOUZ2cXRVcFFYcjdIQmhFNHhCVk1QUmNCUXhtRkNISnRBSUhPeVJrZ0d6?=
 =?utf-8?B?Q2NUU0VTbnZYKzlER0treGJITXc1Ui9EK1Mza3gzbVdEUkU3VlgyWW1oL3Qz?=
 =?utf-8?B?Qkc4RU0zMzBMakZaNG1lOG9INTJ6SzA3RHdnMjZ3TGZLOGdXbjFvOHlleWVa?=
 =?utf-8?B?ZEtHazJMMmJKTTloUzE0cnJOdE5WSE1uUXd5SkVJZk52azhYRndoVmxOclBF?=
 =?utf-8?B?YS9pQ0lqa3VINEphY1lBQ2RMRW1aR0lOT1N5alB0SmNTYUVBM3ROTmV5K01G?=
 =?utf-8?B?UVRXb1k1Mi80cFdyYUd3ZnIwVWIyeDZnakQzb1orVGUxeEN5a2JIeGN2Z2Nu?=
 =?utf-8?B?dllPSUs1VEwzQVhlYklJNks2L3lVTGFnNElyRVlyemdWU0c2T1NxSHBxcktm?=
 =?utf-8?B?V250b20xWGx2NlkzME1hRHhVc3NUUzNqVHhTam1PNVhmSU1pb0ZrWktGNTZ4?=
 =?utf-8?B?SmhmMldzU2pyNGM3QmZpZXN5TVNhb1lOcXJsVStZYUdvTDdudFVIWUs1b3li?=
 =?utf-8?B?Rk95K2E5NnlaV0RteDh0QVdVKzkwaU1BNmw1S0MzS2ZPbFppZU03SEtaR29K?=
 =?utf-8?B?ZjRxNEV3d3VTRGtQakU2MHVXNlI0bkhma2lNRVdkWTJ2ZEdRZXFUNG1qdzRu?=
 =?utf-8?B?QlZ4SjNManBQQnhlcVQ1RnVhUEE3TlBwTmVQSXlIV3R3VSs2NFJBNU80c3FC?=
 =?utf-8?B?N0ZIVDZFQWFkSk9KVWE2dG5Ka3hOUWJ6bnh2Ky85dmdoc2FabkZDK3pVZnRi?=
 =?utf-8?B?MFZwVVFBUzFrclQxV09ibUF0WDMrYWh3OEpQakVoV3plNXJkRWlHcmZSY2JY?=
 =?utf-8?B?WmRaNmxaU1RzN2tHOXZ0OXp4Y1g3ZDJJRktjUkwwbytPcU5zU1BFUDFhMGp4?=
 =?utf-8?B?ZXBlMkQ2am9oMnE3QllROVoxZ2FCUE95blB5dERlZHB2UUh4WHVlNmRmeW9x?=
 =?utf-8?B?czFocFFQR0s3RzRoR01BOURMbkoreG42NUUzS251MjJrT0J1d3gxME4xb0NQ?=
 =?utf-8?B?WE1Bd0E3L2UxeEY5d1hTclVNRGE0dndmeTVzMGFpZEpxUnFRNXVUTnNEWVlW?=
 =?utf-8?B?WTNTMmZtMW04dHAxeVZ4emIzb081M3FJY3RYMEU0SnFHOVJmckp6bkRsQkNM?=
 =?utf-8?B?TTdaNi9wMm1jRFpZMXpaVDdMdkdKTzZrYU5XT3BjRVFKOXlUU1RIZ3hIZHli?=
 =?utf-8?B?Tkg2WFV0UDF2N1d1SHhWVDIwMlAyQ2t1YnR0WWNIY3kyZytWWENNTHNCdjlS?=
 =?utf-8?B?R1Z6S0RGV1dnU0lwbjZkalJPRURvdjlkd2F3TWlzMWJWbUpsMnJFVm5GT2E4?=
 =?utf-8?B?a2I3TjFjRXhZcTc1WEhpNThuWlhiTmJrYXlZekR1c2QxdGc1UEhRZ21zYU9S?=
 =?utf-8?B?UkhPNVZGblBvMEV2M1RiNi9teVExbjh6VHk4QXJnTHhJdXBtc3hobm5CNVla?=
 =?utf-8?B?eW81Y0lSZWk1VTFJeGYxY0ZFL2lzaTJLbHFURkNXeGFqaGg1c3NKclY0ZVZr?=
 =?utf-8?B?OThPUFJBaVhTb0FIcThLZVFQNHpnYlo3c3NwWENNdXE4R3BPUzRqcGtxU0VL?=
 =?utf-8?B?bzJoQWsvc1ZXdlpvYzQ3U0JvZTZIYzdjcm9LcnUyY29qVkZRd3dwRFQxYlhW?=
 =?utf-8?B?ZzlybnhtWkF0b25qOVFWbDZhaTNhblByWFpOSWhBY2ZsMmd5Vk9vakg1c2Fm?=
 =?utf-8?B?dWMwUy9FRDJtOTBhNGlzWTN6UDN5dk8rZ1dZWDZIU2pjbWVxZ1JMZThjenJ0?=
 =?utf-8?B?OEU2VnZOeTF6SVRjeEpVT3Ztc1pWT28vOE1GYXI2QkFZZjRadWtxanIvQm1a?=
 =?utf-8?B?WHA1ZWtGS0JFRm5TbThzZGZQWG52ZGZTaWdkK2VDQ3VmNHJNQ1FvdUhLUm9P?=
 =?utf-8?B?cmVFVkkyZ0xZRkVJZGp4R2JwdjNFYUJIa2hjUnhFOGtiTFR5Q293N2lkZVFK?=
 =?utf-8?B?VUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ff1ac8-eb90-43ff-24b8-08dc6956b52c
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 20:47:11.0729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bno/BnvyuaATE4PLCg1jcj4JoHYK76yvyDgNl94faPrmUK4nYYkrMDaFY2cDhIJY6JI7riPnqs0CQr/GeUppzb5S0nhyqGhEHoSdFWhW8B8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6296
X-OriginatorOrg: intel.com

Hi Isaku,

On 4/3/2024 11:42 AM, Isaku Yamahata wrote:
> On Mon, Apr 01, 2024 at 12:10:58PM +0800,
> Chao Gao <chao.gao@intel.com> wrote:
> 
>>> +static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>>> +{
>>> +	unsigned long exit_qual;
>>> +
>>> +	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
>>> +		/*
>>> +		 * Always treat SEPT violations as write faults.  Ignore the
>>> +		 * EXIT_QUALIFICATION reported by TDX-SEAM for SEPT violations.
>>> +		 * TD private pages are always RWX in the SEPT tables,
>>> +		 * i.e. they're always mapped writable.  Just as importantly,
>>> +		 * treating SEPT violations as write faults is necessary to
>>> +		 * avoid COW allocations, which will cause TDAUGPAGE failures
>>> +		 * due to aliasing a single HPA to multiple GPAs.
>>> +		 */
>>> +#define TDX_SEPT_VIOLATION_EXIT_QUAL	EPT_VIOLATION_ACC_WRITE
>>> +		exit_qual = TDX_SEPT_VIOLATION_EXIT_QUAL;
>>> +	} else {
>>> +		exit_qual = tdexit_exit_qual(vcpu);
>>> +		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
>>
>> Unless the CPU has a bug, instruction fetch in TD from shared memory causes a
>> #PF. I think you can add a comment for this.
> 
> Yes.
> 
> 
>> Maybe KVM_BUG_ON() is more appropriate as it signifies a potential bug.
> 
> Bug of what component? CPU. If so, I think KVM_EXIT_INTERNAL_ERROR +
> KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON is more appropriate.
> 

Is below what you have in mind?

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 499c6cd9633f..bd30b4c4d710 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1305,11 +1305,18 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 	} else {
 		exit_qual = tdexit_exit_qual(vcpu);
 		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
+			/*
+			 * Instruction fetch in TD from shared memory
+			 * causes a #PF.
+			 */
 			pr_warn("kvm: TDX instr fetch to shared GPA = 0x%lx @ RIP = 0x%lx\n",
 				tdexit_gpa(vcpu), kvm_rip_read(vcpu));
-			vcpu->run->exit_reason = KVM_EXIT_EXCEPTION;
-			vcpu->run->ex.exception = PF_VECTOR;
-			vcpu->run->ex.error_code = exit_qual;
+			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+			vcpu->run->internal.suberror =
+				KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+			vcpu->run->internal.ndata = 2;
+			vcpu->run->internal.data[0] = EXIT_REASON_EPT_VIOLATION;
+			vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
 			return 0;
 		}
 	}

Thank you

Reinette



