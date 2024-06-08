Return-Path: <kvm+bounces-19120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9DDA901239
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 17:12:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C55A81C20E51
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 15:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634541791ED;
	Sat,  8 Jun 2024 15:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MAG9vALW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BFA56446;
	Sat,  8 Jun 2024 15:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717859565; cv=fail; b=u4FbHhp+TEYO4uwQEKweWkg12bvivGyFXXQn6F50i6hQjWfh+NfUvrJQNC7Zx+WBQPMas/PdJOdgv6kKedKEq392ozu5lh4ovFqpLMn5IMYmjQJeAKGNjuY8PFeJIlNi1+cu1V4KcuJPL8TR26JD2Y/XuKcXkrIUN/SK+AP2pLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717859565; c=relaxed/simple;
	bh=zMgAVw/ha/azcpj/WwpKlb7F+cQaicVpsa/rgBYnZZ8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ceWxe67jD7CqwWXdi0zbcTik/8eM0wacJV6WuQhyrSoTbHDeAmLKt8iFq61EsANIIOJggIbYReZVTqMoDp/l0EWLjbrdONX3xlt1B8jOsgh4mcBL/OmBIxeftM9ZHyrLIGyRChuDGt88xvZegQ7dlmHGkmw8KCzL9agWTE6pJBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MAG9vALW; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717859563; x=1749395563;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zMgAVw/ha/azcpj/WwpKlb7F+cQaicVpsa/rgBYnZZ8=;
  b=MAG9vALWWPV7GHjwzpjdrIq530QSrphBJ1SSP/DDQ2rYYyZjzW2/8W+i
   kB9l9ix6PCaMJgzLCWlK71X7CbGPYqVGG1PQLjDTqJNiAn4MxA822bUds
   FsAb6aYgTCMOPzYyum3uu9+SQljhBr5wveBWbUUCvNvRG0iiISkGw/P78
   8Q9wE0/OxDIaq2HaRv9wtIGWuea0COO5+xldGIVaesXD5xvQJXnm/4zru
   XFoiSwoad5GXMdqNkGP7a4CcZWz0ofss+pSUMWczgV5Sl41EznhpP1juc
   leU4dy+GBBveKuXXfeILu/S8ukJ536vdBE1Ygv5EdcQHLsYaIYmCh6A10
   A==;
X-CSE-ConnectionGUID: O4L+nt08T7Kk+aPTEDoS9A==
X-CSE-MsgGUID: LjNdeoNVTYuElHblHpoNnQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11097"; a="11976486"
X-IronPort-AV: E=Sophos;i="6.08,223,1712646000"; 
   d="scan'208";a="11976486"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2024 08:12:42 -0700
X-CSE-ConnectionGUID: W7s5sV9ARJCnhyp3kvT5sg==
X-CSE-MsgGUID: Z6XNXCxoSP2+JxFGVJtsJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,223,1712646000"; 
   d="scan'208";a="43739910"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Jun 2024 08:12:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 8 Jun 2024 08:12:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sat, 8 Jun 2024 08:12:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 8 Jun 2024 08:12:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtrl228a2iGKfnRkqV1kfUln/zTJD4Zs26tBq/6yLQpb/9chgqzSCq9TH0264kBgd1389NWAP1GnpdzFHGZdI3m/xJsNl9iXDVahxz1d07aDzDV3ij3s4tDh+6oJkgEtMJNb+ZtIwdQsnyjsmfY8+ScNDUAFkIzfvoOAm0KUBOUb4nxt2euEzm14xmDuY8Yh+mG1oJvl6P47zf2RZ5a3nGuYnCYI5X1RBCbq74iEU4QkIeQW2iD7LWIZW+XFarO3+gfxBbkkfVCx2KCp7JT2bdFpj/98wCEtE4pkU7t+n3OeKQfeQMlFB2S+osNIAX/bN25Ep+gHGnronvJcfYIE/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUjNxJpK9vbNhnOCAyHL3oHmBLJr9ypMVoo31GSyrK0=;
 b=JFEaw4Eeo6wBFfYW3HQEBG+9eByyBqnoQuVX9rqzlLZ+CVpDzQq+eDdZY0nmSi/Rkl4Mw1hZXOx6wmE2kwDy1bopszghz1oj0phWdLuVOlaSJ/Zo8+jM6xB0+y+evRnybrlLcZQWU46hZkwBpbGIFVttu7m3f0EWpCvLvH0N7qi/EQe908qQvEjmo27r8+6ZEhnlVlTA92WN+3C7n+cKXKiCBxDTmtXDAr5Eh9z7Qmq5dJY/zuVjFEEv3lOQ0Z8FQdUTMbr7klYPvwaMU8TLOVsoKjhB1VflAqkEC/jv/Ay1qzdDnyZozxWQMWfBMg3MZ3VxlLakAlFtR8DOG4TAmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7052.namprd11.prod.outlook.com (2603:10b6:510:20f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Sat, 8 Jun
 2024 15:12:39 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Sat, 8 Jun 2024
 15:12:39 +0000
Message-ID: <87f4123a-d640-4283-ac3b-f3410aefa8f4@intel.com>
Date: Sat, 8 Jun 2024 08:12:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V7 1/2] KVM: selftests: Add x86_64 guest udelay() utility
To: <isaku.yamahata@intel.com>, <pbonzini@redhat.com>,
	<erdemaktas@google.com>, <vkuznets@redhat.com>, <seanjc@google.com>,
	<vannapurve@google.com>, <jmattson@google.com>, <mlevitsk@redhat.com>,
	<xiaoyao.li@intel.com>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<yuan.yao@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1717695426.git.reinette.chatre@intel.com>
 <6cd5b8bba5905813dacf71249865b316146dd1d2.1717695426.git.reinette.chatre@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <6cd5b8bba5905813dacf71249865b316146dd1d2.1717695426.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0350.namprd03.prod.outlook.com
 (2603:10b6:303:dc::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7052:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a0a67d5-a277-48fa-aef2-08dc87cd6fe8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007|921011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Ny9xbVVRZGpBaTBEREhGaG10anI3SUY5K2N2MjhFOTFEWnJxTlV0bC8wWm9I?=
 =?utf-8?B?UHZKbWQ5KytDQ0d1OUluSFBPYVdDLzR3RXMyNURCSHA5ZWhMUkl3ZzUycDdj?=
 =?utf-8?B?S091TmlTRW1pdytVT2FHd0sycUUzV0FOWWM2WFpIVmZQSUkzNk1KTTdzVUR3?=
 =?utf-8?B?cHliSVZUQWhKTXNZUTRzWTlUYm9BWjJRQmlLRngvNnFHdmRQSDhIM055ZGhh?=
 =?utf-8?B?NElPeXJBclVBc2lTVWZxYmRNVkZTQVByc0ppT1FaMllWUmQ5M3RaZGw5YWxo?=
 =?utf-8?B?ZWlpNnNXc2s3RXBLa0hvRjVwMnFKV0xJSlhvS3V6UEl5RThzemZ2OXNDMUNC?=
 =?utf-8?B?N1RDdW1PUDh1emJyMC9kZEhzWlBNc1ZvL1NyZG9KQnMwelpvTDYxbjVudXVV?=
 =?utf-8?B?cXpIWEwyd3JRYXFFbkZ0Qy9oOWw0amRUd0podzN5L1dUd3RtS1dKbTQ0dW4x?=
 =?utf-8?B?WFNLNzZPL1A4Q1NzVzlUUXI5VHRadFcxZ3g4bWl5dUswWWY0Q01wcVFkMGhM?=
 =?utf-8?B?WkhvZnF4Vy9vQ3crRTlVZ1NtQzhZdDJCZ1BYM0hnMm91T3krUm1oZHc3Z215?=
 =?utf-8?B?emJ6ODZ2ZVhLQXlLZnFxRjhxMHdtU1hhTmFXRWNWTlhSVytCZmhHempRaGRz?=
 =?utf-8?B?QWFJTmVHRDd2cGYrUjEyWTdVYVRmV21idktlcGtPWjdyTkVNRnl4aHd4YU90?=
 =?utf-8?B?bUdkMnlLanlhV3F3L1I0eXJmZFFzNjhtaEZ3SGtsMnZjNXpTUS85aytXcUJO?=
 =?utf-8?B?MHA0S0NxdFdkOUFMRnRPekNzcUlxMi8vN3pBRWExMkNJZ2d2MFZrVnFkVmky?=
 =?utf-8?B?Y0ZDMG5zY21yVkhWYU5mYnhOYk91ZHprUEpmc3Y2TW9SUG5kL1RCUVowYXhU?=
 =?utf-8?B?VFZkYTMyblEvV1JzN1hxWFJNazJ3SktpclRwUEJSbDl6dGVJa3l0eHpUTDJi?=
 =?utf-8?B?UHRMUm1TNm9iK24ySDBhREwyelovOC9sTmFnY1B1SHdDU3dEZ2QyZ0s2MFVK?=
 =?utf-8?B?MlMwTnNrektJbWhmZTBWN2U5VkZxY2R4WWt1RUFwY1JwS2JPR054Zzlycmsr?=
 =?utf-8?B?MWdrR0N0aTVMRXVNd1VhblJ1cytqbzZ2RUFqY0lFc29ReEhvWmFoKzQ0OGhC?=
 =?utf-8?B?OW0rSzdLUE5pRDc5dS9Fc2FNS0IxWmxtV0EzNS94bDJsVVdFNU5qSzA3REdv?=
 =?utf-8?B?N09xcnNYNm5qQUU2MTFmT1JLNW5vREZDd05nN2JKYWc2NnhGN0FFTHBqbDB5?=
 =?utf-8?B?dlF2WnJqc2o2VHVuR1p5UktKU3BoMWpyUGxMcVhuTTAxZEVmYm9weitGTUg3?=
 =?utf-8?B?NHU1Zzd6YWFHd1k3NVVjRVJTYlJmaXhoaXREdmEzNCtJVUZsRDdDWTAwQUlP?=
 =?utf-8?B?U3hDaGM0U2dpQnlRZElIUllmYnRJTXgyRnZSakxEaUNCNzE3ZFlTVmlGdmg4?=
 =?utf-8?B?VEZMN0RmUnBRRXBSRFlrTlNPU2h2NjNOc2h1bUpIVDdkdnhUTXVYSWxDNUtJ?=
 =?utf-8?B?SDkzbzBxMWRVTnFEaXROUjFQcVhHWSt0UVYxRyt6Y2V2OXBhSjc1V2Z3c1By?=
 =?utf-8?B?VFJsVHlRMHNGSGpUT2VlRkZnNE11Vy9Ha1hid2MrbnNhSjBSNm42dHk4WUZ4?=
 =?utf-8?B?dEQ5d3BrSERoRFNVSlh4NkxhcTBDQ3haQ25abHoyWkw2am9wcHBldFFNTW1z?=
 =?utf-8?B?T2YvUUcxOUJyU0c5UUR2Q1Y5bDk0Nkl5TGNabHB5WHdvaXU4dlpPOGw1UjAv?=
 =?utf-8?B?ZlFPbCtYaklWRUlsNUNmemRiTnE3T3dRZFlENUJYNTN4eHZSTlBjWVN0VDky?=
 =?utf-8?Q?q0in/+1sZKBtBmWetGQU/AONpvWkTDg9rEQ1o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTczUlB3VURaZzVYWWMzZGN4UCs3ZW5hdlo1blc1L3NNRnpLZnVoSTV0cUJS?=
 =?utf-8?B?Rmc4em92TjFTYjBJZjFudWxZeWhJTk1YQVZpVUFrVUtOeWRUeG5NNXdValBs?=
 =?utf-8?B?NWY4SFowMGlmeGVzc2s2YlZUVmI2L2toaWFzS1pwZDZNcXh0Nnd0d3BYZzNr?=
 =?utf-8?B?bmxXMkJUSGFNaVUvZDhtZXhBOHl5bGNuNlQrSWZ5ditFajhLVjVmWEM5U0pB?=
 =?utf-8?B?em9XbWcySDFlZEd0QjJUaDd6dmZnMTdKMWhtNXJzamthTU9obGl6ckpvT2dr?=
 =?utf-8?B?aUVpWVFqM2MrSDV1SE1TM01Sa281V0lwV3hPQnBrM3pUUWJOQXczNlZadVls?=
 =?utf-8?B?R3o2UVFkVXBhQmhuQTdNQmk1Y0RYc0dENWhxTmZZVDVEcUNqa0NlVUNUSzRY?=
 =?utf-8?B?RWNjOWRhenFQTjNSMkFmb2J2bSttN2gyUjdyZmZTMm90cjNMc0R6bUk4RU5t?=
 =?utf-8?B?MW9XalJmaHJNbk5tckprbER1SmY3VmlzNGtOU2pGUHM3NGV6dktLeHdkVEY4?=
 =?utf-8?B?UmVMbTA4RStoUzhwSzBYZGpNT21UWGZnVDc1RzU3Sm5naHlISWc2TGNxY3h6?=
 =?utf-8?B?Qk9ObFRYNUp0Y051RWVFaiszTm1nS0U4SytEUkMzOXdYaXZmWEp6MlQ3L2Zs?=
 =?utf-8?B?M1JuU2hWTUtXNlhFRlhIeEp2Y2lQZXZDVmJITXN6aVVoRzRMRDFjdnlsL08y?=
 =?utf-8?B?YTRvM2VVNndtemNxaXZUTVZSUGlrNWRLeGJFNHV0WlBWYXlTLy8wenROWG9M?=
 =?utf-8?B?WjIrME1CbTFjZWtKMEErcmpDY2x1M1BqK2lHQThpRGR5RVJYWE5xbis5aTE4?=
 =?utf-8?B?a2xDOVRpTDBjTFl1MlgxWGIwSmRva1l1bFk3Y3B5cFlYaU81TVE5bTFtVmRp?=
 =?utf-8?B?MTFrdDg4L1phMEFlQmgzZkl4TU93ZERYUGpLWlFRL0tCVmhMMi81Rmp1NVU4?=
 =?utf-8?B?eC9DKy9tOTV0ekVBZWFtL0tnVjQ5U045bFZqZ2ZhcFI2TXhQZDAzUkg3SXJQ?=
 =?utf-8?B?WEFNelBWSmdpTDNmcjVyUHB2ZzZ1d1ppVGdMdGdJUkZQNWZjbzFGOEtTZFVw?=
 =?utf-8?B?bmdyVGk3eDR2UEduYWJqMG1NZSs1Ni8ycGE1ZXhOUERSQUtTWXllT1BZUjdR?=
 =?utf-8?B?eStmYkFMVjZKRXVpdG54dnd1bzUwVFIxQ1hKNU04RlZTSVBCTng3OVp3YVlW?=
 =?utf-8?B?RE5OQ0lQNExvUXVSYzE2UC8zdHFaTjRleXlZVDJuT0NpcUlxUnhuaStuRFRL?=
 =?utf-8?B?YUY4UXJRbGV2NWNtQlZYOEdRekZoZEVydlZDYlpnUHdBeUJWd0RaWHVzSTJK?=
 =?utf-8?B?UzUzV2lsVmRzVWV3ZHg5K2tpMnhpSGE3eDJvVWpjdmNBV09rY2NnbXhMWTFI?=
 =?utf-8?B?RnJCUFp5MytML0ZMWGphUW5UaThoMmFRb0F1WEJ5b2JrVkU5OTZDczROdUNv?=
 =?utf-8?B?QlBhUzFuakJKR01UcVcxQldMRjZZVWZXdlFHMzlSVnM0cy8rdk1CNCtraWt1?=
 =?utf-8?B?NTRSQlBOOTBCSUxjK0ZmZjlYMk1zMDFqbmppQ0l6MktXZEN5SmhWeXdXdXNm?=
 =?utf-8?B?SWNTN2FNM1QwNlJVYUF1a21PWVQxZUZmRHZMLzR5WmwwM0lSZ1cwTjVCTzFa?=
 =?utf-8?B?cnNrNTl1ZkU3M295TEpoT0J5MnlEcWlMa0w5akdGRW0rSVpIREtLMnlqLy9D?=
 =?utf-8?B?M3p5NS9Reml5R1luQllWdGxoSzY3NFpZVUo5WWYxY3ArZ21KUkkxcEJGYVB2?=
 =?utf-8?B?RFFGeFpFcmpJZ3ptSlVsSm5aRTgybjJZS0tKZk0zM1N0ajlrenI4aFM4UTJl?=
 =?utf-8?B?VU1YN1UwZkRyUlRlMFpadjZ1TUpuckcyOFdibjRjVVBlQTJWVmIrVDI2SjFP?=
 =?utf-8?B?UVZnVm9pNVVnVHU5eCtxaE5XbVU1M1YxbkdCZEtNUTZYdi95TmFTZmRQZ0oy?=
 =?utf-8?B?SjR0V050UUlJQTVPWGpCUmNZYUhkb1hQWjI4ekV3OEVjSUYrcVdhT3c4K1Uy?=
 =?utf-8?B?eFAybisvUCtCaGNrM0h4ZlFpbEZ6NGNrLzdhUmVSOVB5eTd6SnNNK3ZFbVpE?=
 =?utf-8?B?QUgyR05Za2cvK2VyYW9hQXo1cXBKVVlZVndqWG9nbjJ4S0Y1Wlc4SjRHTmh6?=
 =?utf-8?B?UXVCSkRPUTN1TklZcUZyTTNtcy84cmZwclhKZWpEZitHOERlMjJDenRIZTY1?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a0a67d5-a277-48fa-aef2-08dc87cd6fe8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2024 15:12:39.7010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hApcvT9SxxNv1+ezxvh65+r/bundsMF4QM4qhh4/YhHO0deibSjeAR82dptsyUev5DGLRC0NKgcgr2tI/lP4R+hRxngVpZ7KC1JEDsMxKy8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7052
X-OriginatorOrg: intel.com



On 6/6/24 10:42 AM, Reinette Chatre wrote:
> Create udelay() utility for x86_64 tests to match
> udelay() available to ARM and RISC-V tests.
> 
> Calibrate guest frequency using the KVM_GET_TSC_KHZ ioctl()
> and share it between host and guest with the new
> tsc_khz global variable.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>   .../selftests/kvm/include/x86_64/processor.h      | 15 +++++++++++++++
>   .../testing/selftests/kvm/lib/x86_64/processor.c  |  8 ++++++++
>   2 files changed, 23 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 8eb57de0b587..f3a5881dd821 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -23,6 +23,7 @@
>   
>   extern bool host_cpu_is_intel;
>   extern bool host_cpu_is_amd;
> +extern unsigned long tsc_khz;
>   
>   /* Forced emulation prefix, used to invoke the emulator unconditionally. */
>   #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
> @@ -815,6 +816,20 @@ static inline void cpu_relax(void)
>   	asm volatile("rep; nop" ::: "memory");
>   }
>   
> +static inline void udelay(unsigned long usec)
> +{
> +	unsigned long cycles = tsc_khz / 1000 * usec;
> +	uint64_t start, now;
> +
> +	start = rdtsc();
> +	for (;;) {
> +		now = rdtsc();
> +		if (now - start >= cycles)
> +			break;
> +		cpu_relax();
> +	}
> +}
> +
>   #define ud2()			\
>   	__asm__ __volatile__(	\
>   		"ud2\n"	\
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index c664e446136b..6558fece8a36 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -25,6 +25,7 @@ vm_vaddr_t exception_handlers;
>   bool host_cpu_is_amd;
>   bool host_cpu_is_intel;
>   bool is_forced_emulation_enabled;
> +unsigned long tsc_khz;
>   
>   static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
>   {
> @@ -628,6 +629,13 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
>   
>   		vm_sev_ioctl(vm, KVM_SEV_INIT2, &init);
>   	}
> +
> +	if (kvm_has_cap(KVM_CAP_GET_TSC_KHZ)) {
> +		tsc_khz = __vm_ioctl(vm, KVM_GET_TSC_KHZ, NULL);
> +		if (tsc_khz < 0)

This incorrect type usage will be fixed in next version that I plan
to send on Monday.

> +			tsc_khz = 0;
> +		sync_global_to_guest(vm, tsc_khz);
> +	}
>   }
>   
>   void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)

Reinette

