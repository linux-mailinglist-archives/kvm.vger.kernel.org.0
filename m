Return-Path: <kvm+bounces-40564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4141A58BA2
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:21:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8233B3AC02F
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2471C5F18;
	Mon, 10 Mar 2025 05:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LtQv6XQz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E53E1C4609;
	Mon, 10 Mar 2025 05:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741584087; cv=fail; b=JhDWKccbS0lKbZTyi149bANXqdppaMI4HF32CtTF7+Z0BAHEOqj5iX010BJ/AtKROJWy7dMJickaBtRPqlMKqYKoAZ8QhY/+GE6FQrgc5Udslv/rH9giG4hLExKtJ1NIgEnkX/pG1Vz3c3aKMRUg0Y3Tmu/Ut2jThjUHlCd9zDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741584087; c=relaxed/simple;
	bh=wHwW8DQRh51ClyEipqeHVfz2Nxrsxfkb5kc5KDdRjIw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F2G+ZAILXqwV9Q7r2boTKFl9suio9c0Vb+UPz9Ga/IVaUCNg/4KrYZ4qp9HfAdBYb9dL0vBy75oA7rU+Jy1oTHN/YlLsPx+b1jjOrP4Sq25OTQEinybt4p7JSAzUCM/fRQpG+LZx25r8/IMTvlTzlDGl9WoH7HlZGkhtgTjujtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LtQv6XQz; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741584085; x=1773120085;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wHwW8DQRh51ClyEipqeHVfz2Nxrsxfkb5kc5KDdRjIw=;
  b=LtQv6XQzr8YlQuiqupkUyWXFY0rs64RnpS9aQThzPjp0B1tYd1G0Ka9n
   EEv5Y28xkI2pq/9vX4zcChsVT9d9B12KTfDzD580xUnjXI7VWFXyXiC6P
   1OHFyJ7W3bv2AYkk4kPOPjdqusuVVILXUHXYjQLPtGpIrVnONxnQvlt9o
   gk7/gJFD1nheAJ9N+vATUm5tplouum/mDXxT4WpBrM8T9+KbZEK1AVnld
   OzNrLVqN16awK/p5WYqlrOkT3Oux2BelX8ocbElvMRk7gA+hUyNTsbr9j
   PmTp9/JxI+7ww9tFA39GjKe1XlR4fNZDkzQMbJ05xGkCdoDJk+h6AnQWh
   Q==;
X-CSE-ConnectionGUID: TIJbzJ6tShyerLK4X++ixw==
X-CSE-MsgGUID: bQI7TtjKQcuEdIeG00DeqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="42438736"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="42438736"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 22:21:24 -0700
X-CSE-ConnectionGUID: n6JSGI0hQs250xnYoGI+sQ==
X-CSE-MsgGUID: RxR1Td1LT2KqrW2DmSj6dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="124489047"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 22:21:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 9 Mar 2025 22:21:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 9 Mar 2025 22:21:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 9 Mar 2025 22:21:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sja8oQRrgGGpGJ8COpjXCiHXGtMrIVOAASW6uiUQwhkXiRvQSPQI0n8o7f/mNA1RzAkQW7C8eJQmzdTzIjZKWGTmuPwYbWbr5dUSc4ED94pj4Sj+AhWvyeIV3mWs+sN3Iif7aglMnxmS1/kp4zM11cN6ndqvKXWC5Ngzy30SmzwFRYF2CH6gh/+1Vwk0gQ1vNCMiOfE5rB4PzXWchQCLUwftaG7uC4D/Yl9Uk2P2IbFMyh13rjdosxV1zxf091T5dYnDGCkowfvjhNwnqm1qCszMmjz0KSDV+HDuj+SkuuJVIYp8TLoVgMZpVQ1LgOCrrPYZeNSdX1IbQqAKVKUduQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zmFjXD/Y+GAeS6YxTyXHexX62QusE1pS8egtZPq7bmc=;
 b=bOx5TEqXP/KqgXnZLmdm8sESjIA7w3pUpSRIjEyIOygmIIN7lF4RmSPAxfpHpZd9ldthaXjx3dELy6pAMZJN0O6bkk7HS3DSP5sFsPdiysMQWxBNhQJEk20Y6HS8HJTMp3leX1LW1S4Z+9+Kg8FwDBnEtlOKyf5a95yth11uDvcy8WclFFI/1jKVUyL0K/vu1joEmGkPGRGsGizFEKNZcfaoaLZ1Q7zPJkV++cse3Hky9lKhJ3xj/WzHv0DaOfgzIjju8SGl/Q9SymlGkBUBtY9TON5N0w+m7X3OVQguW8zj7hkwTh/igJpYniwcVKWEqC9FljSZU4kfW2N0f2OPZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 IA1PR11MB6220.namprd11.prod.outlook.com (2603:10b6:208:3e8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 05:21:15 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8511.025; Mon, 10 Mar 2025
 05:21:15 +0000
Message-ID: <24b5d917-9dd0-4d5b-bca8-d9683756baff@intel.com>
Date: Sun, 9 Mar 2025 22:21:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] x86/fpu/xstate: Correct guest fpstate size
 calculation
To: Chao Gao <chao.gao@intel.com>
CC: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-5-chao.gao@intel.com>
 <b34c842a-142f-4ef7-97d4-2144f50f74cf@intel.com> <Z8uwIVACkXBlMWPt@intel.com>
 <481b6a20-2ccb-4eae-801b-ff95c7ccd09c@intel.com> <Z85BdZC/tlMRxhwr@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <Z85BdZC/tlMRxhwr@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0293.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::28) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|IA1PR11MB6220:EE_
X-MS-Office365-Filtering-Correlation-Id: d5c17b8b-06ce-4bf9-0632-08dd5f9360f3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SnVEZGxQbUZOOW1QNzhxbFQ5V0NjdkxybENsNFJBbjFvSDFqZXJ0Y0x0T0Nj?=
 =?utf-8?B?UXpOWkxlM2JJamZCOVRERXZoUG5aWVBkdkQ3Y2tiTDBkZkJsTS8zNFB0YjFI?=
 =?utf-8?B?WG1YVHV5NUlsZzZVNWtVTlhOTHI1ZC9Ma0xuV0orakh6eENVejJzbUU3TzEx?=
 =?utf-8?B?aWh3NlI5ekdEVTNSZzNPZXFtZldlK3ZBcndpa1VnOFJFR2hYbStqSm5PVDFx?=
 =?utf-8?B?NkZLRGpiclhaZ2k0K2JNRUpJVEpFUlRBRkdoMlhpb1h6RFVvRlp1ZEtnQ1Nn?=
 =?utf-8?B?eW5XVWF6SHhwR2FxTE02UkE0L2ZtSW5SWWFLdi9qQkRtR2lRVWczM2VnaTdO?=
 =?utf-8?B?Vndnb284Y0xnMzZCZ1NXL1dXRlZUalR5anptbnArcWJoTWh2Q1dKN0lkV0NS?=
 =?utf-8?B?NTlJVUtuZVZmUy9KTTYwN3lkUVVPYWl1OXliWThQRCsrbGVmTVlmWGQ0TGxG?=
 =?utf-8?B?VmdVYzFvaFQzZ3RXVEhZakxlbFR4d1Avdytia2xYNGpack81YkdiamI0dlM5?=
 =?utf-8?B?Z3l0WGVob3ZuZ1h0dnZTRm9uL2xJYmhJTGRwdDdGTUJUWGhSNlNDNld0eFdj?=
 =?utf-8?B?OWtiUG9VS1VyOGNMTko5cTJ5eVBoSVloek5aUnhkSEJBZHFlQW1SYzBZenJi?=
 =?utf-8?B?dHNEUU5RRjhWSjNGM21NTXpGSnhBaXdReVRrNmRLLy8rSllSdTlaT0hpbktD?=
 =?utf-8?B?dDlFTWJydEhacVJIRnIxVWhrSk9mWGVPb2s5T3F3RFhRVVJHSC93c2hLbHpJ?=
 =?utf-8?B?T3pOaEFjKzlJWWtuejZRMllLOUdUZ2ZNWGF6blpxdjFMTm1RMUo2ZCs1K2lE?=
 =?utf-8?B?d0tCZkVBK1RJSmI3RStidTFST1ZLOGJjVHJYWnVGUCtuY0hucFdXRWt5cEtV?=
 =?utf-8?B?WXNVVjdlbnNmWjBoSThNLzRiUUtkdVk2MVJ2UEtkS2RYbldGaUJWWnFCVnhW?=
 =?utf-8?B?NEVNL1RtRk5WZ1ZEMTltV2VBMlI0Vm9VSU5PK3J5OEE2U0ZRYndCcjhXMUxz?=
 =?utf-8?B?Qzh4RHA1NjBUV1V4eVdLWWRYYnRveUl5blJFUGZGdVNDVWZEb0QyMTMvZ3Iz?=
 =?utf-8?B?YW0wbWJLZEthazRqYnMwOTZMUWVHa0lNVnZONnQ2Tko5c1hZcmpCYjNnQTFP?=
 =?utf-8?B?UzVvaU5MYXA1UERrS21aU3c1TWNVNE8vblgxd0NDcVpqTlhzOSt6bmFKQ2do?=
 =?utf-8?B?N25lUlRnclhlSjF5TE83cVZjK29pcmNVQjhzZm5Fb0tvQWRDcFdteHp0ZGZ1?=
 =?utf-8?B?UGZYQlNma3ZmUlZZS2JGWkZIdWMraHVyMjQ3OU50ZXJLaGhEcFhMZW0rOVhy?=
 =?utf-8?B?cXgvTEV3TSs1Qkprc0tkeGdYWmVZcitxbHljY2xxTENWUGowcmtHV0tTaC9z?=
 =?utf-8?B?enIycGtDTTdqTm1xNW02OFdIeWlydUwzeXpaT2dWTnpFQ29CTmlMRWlSaG5t?=
 =?utf-8?B?UUxYT3JpcmxOUkFkSkczSzFOQU5kWWpGSFg5bnpQOUU3RWgwSWx4VHBrcnRv?=
 =?utf-8?B?WkRzM1pFOEorTXRkU3dXb0xPOHlWREVtKytnTGQydEh1ckZIUVBjbHhNOGNt?=
 =?utf-8?B?b3lxTzBvbTBSY2lDSEgrZjV0ODZzSFNZMk8rZWpxUUNSVnMwL0tRaXNmcjRj?=
 =?utf-8?B?RUIzWTNYMHNRZ0NaTFRzUXZKNGRZYlkxUmNTN0hqOG43TnlxWXBXb0JDRUNW?=
 =?utf-8?B?RnMrbi81ejlJQzllYUwvVkxyS29Qb1ZEdjRlS2tYVGJPb080d0dtcXQ2SUV4?=
 =?utf-8?B?Ym5TMDhxTmV1NDJjc2U3WHZScGtXWmpuM1kweklBTFpFMkdabkw2VjZiYmtH?=
 =?utf-8?B?bHdUTWdnWExIa0Y3UXl0YkV6b3VrRFlMWjlxbUR2Q2h2Y3NrNHVReGlUQ2U5?=
 =?utf-8?Q?N73JLvjPwSIDZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bG9FamphdjZrNG5aSUNJaTNwaW9xVnBiZjBRdGlRZDB3UysvdFptT045U0RS?=
 =?utf-8?B?UGdTd1JNMWN4dmN3OUFSbjZRN3hJZ21nODNGNmgyV3BUYnBEemg0MzByTTZB?=
 =?utf-8?B?b2U1OVhBc2ZzbFJ2ejNmTklTMGRMQXU1ZEJISnFPRnREU2M2WTZ0T21PVDE2?=
 =?utf-8?B?ZllTSEtZL0s2U2IzYVozM0ZqQ0J0RG1nRFdLamRqQTQ0MkswOU5Hb05ydXg2?=
 =?utf-8?B?WnFqSjNSY2xKbkZSM0RSVnltYXYxTzFzVjFjaHk0dGs1Y0F4ZXdrUndJNGFh?=
 =?utf-8?B?TWh4M2tMaS9HTUZkeVFId3U5RmlpbWY5VnJrcDY4YmhhNklobVUzSXB1S1Q2?=
 =?utf-8?B?Sm0vNG5idnZCbFpUdDMxRVQvZHJrcG5UbS9HTmlFZEtDcjIrbUh0YWt4TDRh?=
 =?utf-8?B?V1VZeGp0Y3hidUVycWM4SmhXbWd2cjdIbUNzVXNUdXV6VGxEUlA0c2hkNlNs?=
 =?utf-8?B?b3AwUEpFYXpqcElkc2o5eXVkV2VDaXM5RkxYTk9hbjhuTXBac1dZaXRZa1pD?=
 =?utf-8?B?WmIyTUV0WGNxdGVTNHJvRCtWZGQyWjBreThmMldZKzZ6WkpXQ3lsemcySXZx?=
 =?utf-8?B?S2hWV3p0UXlTVmU5Q250bVdpMm51aHVjUTJBQzFCd1hmb0JqeUx2VVN4aWlr?=
 =?utf-8?B?eGZ6U3p6ZzBIZW1SMzNvNlNiMjVpN1V4QXdtUFAyRGRLT1UvUTZXUmNOUk1I?=
 =?utf-8?B?WDgrQUVteTZGQnAzb2VEUGMzcHZUOWJFRFZrVnYvR1VQTmFXQzJqT1hneWQ5?=
 =?utf-8?B?ZG15R3RncnpnckN4OXdGWEowZFFtb0h2TUZQelE1RWJQVTdlU2JNa1I3d1By?=
 =?utf-8?B?eWhrVk4xTTliL2Qzd05nbm1neGhwMWFCYlV2b1BDZHdDcXB4bFphN3o5NnNQ?=
 =?utf-8?B?eG9rdDVXcGtIYllOV2RRUG92TGM2d1pKeW9OMXc1SW1uaFM5NStKL29wZ0Nt?=
 =?utf-8?B?Y2NtRldtOXl5cmxWZ2NlMDhZUFdaWk9abnRYNXE4dGRmYTdGbDhaSVF3Skk2?=
 =?utf-8?B?WmxyZzZmM2UvUEpONVdRNlFTUlVBamUrK21OaUlMbU1yQWZtNTcwUmE5ZTJV?=
 =?utf-8?B?dXRtaGE4UjFidVcwYzBialVWUjd4azFHcTBRYkg2VElPNmZHWENZcWtHZTA2?=
 =?utf-8?B?dlZyR1ljQXdNQ0ZmZlZtZVJHTjg3cmJ3SFVUeFoydzcvRmc5dzFtb3lRYm55?=
 =?utf-8?B?L3loQkw0b0JLL3N6UzF2c0ZseXpPek4wSUJJVmZHRkVZVGU5TGg5eXlDM0M1?=
 =?utf-8?B?ODdkMEhXeEZmZjM0dWZNeHJqbHVEekR2ZEZuanZnMGtubmUwZTRyalI2Rmsz?=
 =?utf-8?B?MlZhM0tCQTNyVWxTRTcwRnBIQnpIOFVTWElheUMxRDd4MWtzeXJHWTVEaDRG?=
 =?utf-8?B?emxCS25wdWdyMXhUeEg1L2xrRGlXcGo5VHNPaDg3c0dMVUErTE9Wb0k3a3U1?=
 =?utf-8?B?Qmx6UlZkNmVuaGpmQmJzR1JPZ1Q5RnFvN0puajQ1TGVaR3lZTmpMSDFHTElj?=
 =?utf-8?B?dVVud3BRUkN1azN6QUxaRGVSQ3FhRjR6Z2V3ekk4ODdSclFEMERzUzF5Qmxy?=
 =?utf-8?B?cngwWTcvYVI3akJXK3l1OElHYzdNanJieWJBczlNZUJBYzRiWERHUTM4T2lZ?=
 =?utf-8?B?RmZtcXUrR2Q2bUF5KzI5ckJtVHJWMUc4K0Q5ZTU5SS84UXRtYzZyaTJmYU5a?=
 =?utf-8?B?RjN5QzhOVlJoZmM0RHhubmF1T0JjYTJaUDF2NVk4TkZBMU5EWGsvbDB0V3dV?=
 =?utf-8?B?TkU3RUpzVUJXT1E0U0xJOFprKzUwNTRuVEFFS0lGOEh5UENGTk1rdDgvSzA3?=
 =?utf-8?B?cGRtR004WUxrcU5VdTNZQUlhcG1reG5nRmV1emtFSGl0WTFzVzFGRGd3TFgx?=
 =?utf-8?B?dXJCbDNsTzV0L3QweW5TcGE3NGxrdVVnN3dmbGdpWE1zWnVzUFBiMVZVa1lj?=
 =?utf-8?B?NUsrRG52VElWTWtLWnpUb25rb2JQa2FaMGZKMHJ6UmtGWHdveXYzWDlTRm9U?=
 =?utf-8?B?QWsrQU5VeExQcnB0Q0w0K3RjRjVGd0dudThNWmtOSXZPemFYWUlNd1JvczUz?=
 =?utf-8?B?TlJYQndhdDBwUXFoVFBQVlJIeWt4eDlPbUpueWcxcFZkOTg3a01obCtMalRn?=
 =?utf-8?B?WFpLWmR6UVkyRlpjSjh4NmRjUzEvQUhrUStKYXp4bVFVb2g4ZHhJUVhYeEVI?=
 =?utf-8?B?YWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c17b8b-06ce-4bf9-0632-08dd5f9360f3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 05:21:14.9810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9lIpMBlkN7+gWZbHROD+XFt3vI02LS43+BZGC4JC0xeEkp5uBGeQTyC7TSbSYRidDpGHodRwgb9+xjaq1rPCDSmgg/9rUVbQTG87EeyAI9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6220
X-OriginatorOrg: intel.com

On 3/9/2025 6:33 PM, Chao Gao wrote:
> 
> This is fixed by the patch 3.

Well, take a look at your changelog — the context is quite different. I 
don't think it'S mergeable without a rewrite. Also, this should be a 
standalone fix to complement the recent tip-tree changes.

Thanks,
Chang

