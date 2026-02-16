Return-Path: <kvm+bounces-71137-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2JFtDzeck2n56wEAu9opvQ
	(envelope-from <kvm+bounces-71137-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 23:37:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 950E0147F23
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 23:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2031A3028826
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 22:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E602D46D9;
	Mon, 16 Feb 2026 22:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qE3w9bVA"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011066.outbound.protection.outlook.com [52.101.62.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77031D5CDE;
	Mon, 16 Feb 2026 22:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771281401; cv=fail; b=ogQTq+vG17T+BsE6Ko34J2z43XOhE71wx2V/+X9ZetcZQ9SI8UakDYSYgA0llczNqwZA5/XKVUqAYr4nzU/v4wyEobuL6yT4/ijSlVszr6hJpbdO/ZuZIQeQQoOE/qxZFsNHvXLOHNKYI6QgVVuw4EdTWYQizHipDVlplJoWpKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771281401; c=relaxed/simple;
	bh=C4odJeBCWJvr2Vu/IN9lJ3gKEUuYzwa9GOsUdGZNwN4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Up1KO5UKxUDQtJJDn/re449AvyhtXUBZr7uJSKAEJM5wBecpSu20kd7ZYzRn1f1RJGLe4P9n6Df9rAFnY38zqetboFZd4fl1TPG8boF4lCZVtEoKM2adahKmZmLoBMNfYrfH6pB8FOPV9o5Co0j0i3dpYk8zma/qNKEfRv+xdGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qE3w9bVA; arc=fail smtp.client-ip=52.101.62.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hM9xb4R0OOf8yG7LI6Hr3XrkHylP+LTz8kIkobq1n/RDnAIX2Pl+ZbWQpJOFVq5OPWVE79B5brJP0G91PpJZqp2vYRYPfjHkcgh/57hjbkTPIQo2tE3xkBQXSL23FK8REkE77r/Vzxsag5v0u5RBik6l/wiWpjl7r3Jkv6yz5WOBfbwxVeOPr2srXd23v6b+siOAWlwNRZCANR+dSthLIKw+GYZ5CPCXx37ZQxq3bcIh2DqQNZOgaHR9ZyXFrpefg38eL5D5jlhBA9Grttj+g6hfGUaTZRNXfTwbogmlK0ahGJxxkXMw8MLjtDFjQ1hVhtjMA17oPEgAcqyGnLLI8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WVnOmbGI+yUWNPI6BMjQU+Kf7rOetRFFBGWr8zvxQBg=;
 b=b2I0u+WqMb9CyCSUVSeyS0EcgLnaThlxINvtBMY+X3RA5ffa4deO+4fzwCdjNIxT6ygl2SX0iydf4pM49VV/kltmK2rA8ZyDbtTqKLuqbjLeKrHH4QKbOKxAkDcDy2YCageAkz3g6EhxCmR5kkTvKW7qOGfw+FfztwlEM7w5gH2WdE7Mzr5UvFJVA7IXiOw+BCLTp8nk5q6QSilhBZaDzwyYWIj78gPZVcQdB1DlV08AXUiH8EK1YxH67MB5Rfb11KRDk/IAPybmLbaaHWsuFz4JN8lZbJbABQ9m5w4Jmi6Y86pT6Vqb+jJKpsYoLAWd3casypNW7eA4I+u7RzY7BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVnOmbGI+yUWNPI6BMjQU+Kf7rOetRFFBGWr8zvxQBg=;
 b=qE3w9bVARaDw2CpK++/5PY7uv2xbJQ7m3XGcVbri25Vyrx05zntH3+XJovT/Vxe0UzgqoSrZVQ793KcQOmxyZ3/JGw0tQKAlScnGa3ByCNaQHnxB4Crl/w1Q8l2Krf5WzvW3JusgyJxXAEqYxHHjkSoPpm3u9jmGdCMiazwOywc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by DS0PR12MB7803.namprd12.prod.outlook.com
 (2603:10b6:8:144::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 22:36:35 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Mon, 16 Feb 2026
 22:36:34 +0000
Message-ID: <fa45088b-1aea-468e-8253-3238e91f76c7@amd.com>
Date: Mon, 16 Feb 2026 16:36:29 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Reinette Chatre <reinette.chatre@intel.com>,
 "Moger, Babu" <Babu.Moger@amd.com>, "Luck, Tony" <tony.luck@intel.com>
Cc: "corbet@lwn.net" <corbet@lwn.net>,
 "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
 "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
 "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
 "rostedt@goodmis.org" <rostedt@goodmis.org>,
 "bsegall@google.com" <bsegall@google.com>, "mgorman@suse.de"
 <mgorman@suse.de>, "vschneid@redhat.com" <vschneid@redhat.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
 "pmladek@suse.com" <pmladek@suse.com>,
 "feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
 "kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
 "fvdl@google.com" <fvdl@google.com>,
 "lirongqing@baidu.com" <lirongqing@baidu.com>,
 "bhelgaas@google.com" <bhelgaas@google.com>,
 "seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
 "Shukla, Manali" <Manali.Shukla@amd.com>,
 "dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
 "chang.seok.bae@intel.com" <chang.seok.bae@intel.com>,
 "Limonciello, Mario" <Mario.Limonciello@amd.com>,
 "naveen@kernel.org" <naveen@kernel.org>,
 "elena.reshetova@intel.com" <elena.reshetova@intel.com>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "peternewman@google.com" <peternewman@google.com>,
 "eranian@google.com" <eranian@google.com>,
 "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <abb049fa-3a3d-4601-9ae3-61eeb7fd8fcf@amd.com>
 <1a0a7306-f833-45a8-8f2b-c6d2e8b98ff5@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <1a0a7306-f833-45a8-8f2b-c6d2e8b98ff5@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0P223CA0024.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::12) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|DS0PR12MB7803:EE_
X-MS-Office365-Filtering-Correlation-Id: a1cb9631-7b96-485b-c214-08de6dabd6b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|19052099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Nk9tR2dKOWtnWWpKQzhWbjlXSkpwRnQ1OWtabFNpbTMzcTBqc1FhdlZndGNM?=
 =?utf-8?B?VDNleXBTeWhCWml1TnNlVlczays5MUg2VTV3UmxOajlZQ3VpRVB1STVQUXRX?=
 =?utf-8?B?VGNKWFJWKzRqaWpiN0pRVk8wcjh6ZTlOZmNERTBnd0xCcktpTVJBZGRWRTg0?=
 =?utf-8?B?bzZCVThzNXExSjFMOFI1RTNrbjRrR2dJUFZiUXJTV21JU0NVM3YzUkw5Sm9o?=
 =?utf-8?B?OEFzSzZaUUdLd29ON3l4UVBPQk5ncmwzRmFjM1pHNHRIOUtDNmQ2ZVdaQzdX?=
 =?utf-8?B?ZzdVMFZobnQwZTYycTF6OXM2T2UySDRtNTg3UzE4aGxaNkZ0UFdPbnJlQnNl?=
 =?utf-8?B?bTlhQVBLOWVmVXFISjJpS0FwaTg2bDZqSVhabW5aeDliY3FTK005ZUVxM0Uv?=
 =?utf-8?B?cjdKN1k3MTFFTmloNEcwNVZ4T0RTcS9tZ29yYXhhQ0pTNTI4cTdIa0cxMXlZ?=
 =?utf-8?B?bGJUYy9PZHZUeG1CZzhsT0diZzdndXRaUXBhSSt3Rkk3dUtYYmtBa0FmZzhq?=
 =?utf-8?B?d2RwL3N3VXVvaTRDZkhQSnJJRzVnTE1lOWJPTjg4MGJzWDRkc01PTGtxTlU2?=
 =?utf-8?B?R2UzbDdXK2FEeklpMXQ5YU9oaUt0RlFQeFdTa3NjOC9aL2JRR1h5TUFRdWJy?=
 =?utf-8?B?RUI4dEVpb09lV3JEcXBZemtIVk00MUtjRktkSDVFbnlqR1FDd2xaaWZVZU5i?=
 =?utf-8?B?UXR3ZldUS1k0YkxCY1hsUXdxWmQ0WUxCc0hXTmZVK2NORTkwSi84ZVl2R25Z?=
 =?utf-8?B?a0ptbm9ENUhyOHUvenhCMnRNZlp2Slc2RGI5WkV2YkRtcHRpZDY3VitmdmI4?=
 =?utf-8?B?UDlBc1hWOE9CSmxyWDVDSWR6R3RRZkU0QjBGVGF0MVUwUG1MYlZoMVd0aVdQ?=
 =?utf-8?B?L0VTczg5bUlZMnhwbXdySzR5UGRXS3ZMa2dQRmFzdmNhL1FIdVNFOE5RT0I2?=
 =?utf-8?B?WlVjbFQ4VTdmQ1ZZZ2piN0RTTjk3aThxa3p3NFFGTVFaU1BFRUg5RmxXS2JL?=
 =?utf-8?B?bGcwcmlUWm9IQVowWEp0SmdsWDhTTm03RXI5bU92MEw1cStlNlB5UWc1M0t6?=
 =?utf-8?B?S3hSd2lBeHhGaTdoUDNrOUVvQnJpRmt6OTh2ZjVVbVB4TVNvUUtNSXFHYk13?=
 =?utf-8?B?dlFUT1A0NHJHTy93UFpkYmNKNTR5NmNWQWliUXdTQmgwUzNqKzBOSXZPMU92?=
 =?utf-8?B?eUZiN21Wbm1IVVR3emJLNG0xSXhYU0hUZkZDQlZFT2RJVWNtdnVydnhoRlJi?=
 =?utf-8?B?QnNoRzQwSkpKRDBLOU01Z2JER3h6OTlLTjkzcExuVUhNWWhaU05VdU9lUzkv?=
 =?utf-8?B?aklQL0NQMWlWSk9zM21oS3pLWHJZT0JlVVZSYUxzTjhFd3VZMGtqajJXdWpt?=
 =?utf-8?B?Qmt4bkpWNWRKWnpJOGViQ0xYOW51MVF1QmN1OEVYQUllSXE3eEhWMHpMWmpJ?=
 =?utf-8?B?NFNsTyt6MXNURHNkSlBLZTBCWE1UYzZxQzVZTERJeXl5alRFamYxd0FsVUMz?=
 =?utf-8?B?YjcrYzlqekhnRFZ4OThaMjNVYit4by9Fb09maThnWXdzYktaWS9JZ1o0NlRR?=
 =?utf-8?B?cEFkVkRsU2VaVDgyVnFGK1I1OW42MXpEb3dBWUhpeTEvUmFHOEE5Yi90WFRz?=
 =?utf-8?B?QlFabnJtM3NlVWJ3aml1cVU3U3NsNXVOckpaU1JyN01OUWZqUitCcVE4OUcx?=
 =?utf-8?B?TWRDTmxhK1oyS2dkUEZES0VQYzExeWtVTHNnZFNrU0lwc2VUbjdHUWM3WTJ4?=
 =?utf-8?B?QkRMVEpLVEhrZHNKaDIyZzdkUW9XWlF3NFI1S2loUDhvTklPMVkzRktuUmNn?=
 =?utf-8?B?cDF0SkFObGI4QnB1bEcvL2hjNzMrR3hqMDdQdjhXalRoK0JPVG5EdnRhaTNF?=
 =?utf-8?B?bXNDOWVMZk1yQ0dFZzAxcm5mc2wyZlZ3M1kvdnBDVEtWbk5rMVM2SXJEOGFL?=
 =?utf-8?B?Z29IU2Y4cFd2TU1iRnh6Y3R2TjZrd3VlUEpYNXM0UEI1K0dkdFhicmNOQjU1?=
 =?utf-8?B?eDlPWUR5NnJvSnFqUmJPYWN3cFVOUEVEMFF5Y1VJZ3Vlb0M4aVM5NDNyT1FE?=
 =?utf-8?B?VzVnLzQxN2FhQXhiWEMwNWRuRUJpQXo0ZWhLNTgrSGRqSUVKL0VyYjMxd3Zr?=
 =?utf-8?Q?MwaM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(19052099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEkrU3V5NjMzb1dIVUp0R1BlZFFhYkJlb0M0SnBMOHFLMExFenFYdzJuZndT?=
 =?utf-8?B?SFZtUDFKVjViUU4vYmhLL0cwMzk0ZVl0a2cvaitxYk9pdnVxZjh0T3J2elRl?=
 =?utf-8?B?L0ZER0tQUXVGVE01SThmWkk1Tm9JSmE1VXdGUnQ5Rmw3RTJLaGU3dnpSUlZK?=
 =?utf-8?B?cVY2cDluMG94REJNQS9JQUNwVUxEYXdUeXJhT1lxSm0vUkRvOEhjNHUrYjlL?=
 =?utf-8?B?OWVaYVplZVg0NGcrK0pTMzdPZXJXNVpXOFJKVmgyaCtxSHdtTWpqSTkrSmtM?=
 =?utf-8?B?QWhrYUFDQzJDY28yUHlyOERrWFNyZUpXb2puSTcvbEM0T0ZJQXVqL0NxUkM5?=
 =?utf-8?B?UXJUVzdZT1NQaXQvNkNTYjlrbUFndzJNam5IWUVBTUQ2RWJXSVpaV0xRU3Zu?=
 =?utf-8?B?SmRCeGNqbkd1emwwOWduSnd3RlBwSnExL3BHTTdpUHhrbGFCUnlMZ1RWUjRY?=
 =?utf-8?B?QkZENjg0ZU5CVmhVL2E1RWJDTFFvRlpmNy9abCtodzlidDVnVG5mYmpSZTNt?=
 =?utf-8?B?QXNmK0R5bEJ3Yk9CSjRmRnpTNks5NTdQQUhYb05jR1VHNS80Um9QUWxVenND?=
 =?utf-8?B?NGlhU0ZoQ1dRRnYzcmZ5QTlTMzZSMkhEakNJbjRIK3NTaTc3bE1ob2VjVHUx?=
 =?utf-8?B?cGNqdkVXQjdyWTJrT3cwclh2THBQaVlIeC8zclpTTCtrT3lCUVBIWU41OC9u?=
 =?utf-8?B?OXpNbUY1Yy9ad09JcWZVWWUwVkFObEJzajhaMGljendKOFlzbGwwNXNINjFi?=
 =?utf-8?B?dVl2NktjZmJXUlZ0eTdVV2NkMURvT2lLQStoMmNUZ3ZsYjJiQ3B6dlJXZEhh?=
 =?utf-8?B?R0tYd3RoWGFpazhiclplZnlneWdpTzFyK0NUVGNlWTBGS1dwSFMzYTg4V1JJ?=
 =?utf-8?B?ZHc4RmV6d1d1Z01jbFkyTmtJRUlaYVRnMnFQWHNvWGhaU3MzbktvTmsybnli?=
 =?utf-8?B?VmU1OVE3dUdJNml2ZXl5MTFGK3ZlSHROeFNCYVJiaUtUUnh1dDA0N1N4VjAv?=
 =?utf-8?B?eEdCTzJLZDNWbElxaWNINzE5QTBLMHRROUY3VkZ1MlpVL2g2MW9qSGFlblg1?=
 =?utf-8?B?Und2QlFrTktUTll5WVNmT1MvYTNUMmhkd2VYRTNWVlhRYnVhUUE2b05FQXNn?=
 =?utf-8?B?amJoNEVmRVFSMzAvaHJsbXV4K1hSQjhOTTA0SEJ4VjdKamZZdHN6aFRBS3Nh?=
 =?utf-8?B?b3FtTUk4RXZuRVdiZyt0Zzh5Q2g5aDNqTEp4cHlpL05lSVUxTEVmdFZPc2xT?=
 =?utf-8?B?S2ZSOEx2Y1J5VmEzK2hvVDhtWDNRakk4aldENEpmVm5jSGgyMSsyd1N5a3FR?=
 =?utf-8?B?WjlDTTZ4Q2g2ZnlCczFMZ3g4VzZpMFE2SnFkdkFhRlRnWmNqWEl1eHI5dHJB?=
 =?utf-8?B?d1JKNHA4enF0bW84RUlKSEs3OFEraEN5RENyUjBGSWNvVW0wK3BWTnV2cncw?=
 =?utf-8?B?QWN1d3U3bTBkUzBSM3Q3NUNXY1dIenF6V3NQWTFiempNdzdBK051NHY3YzFq?=
 =?utf-8?B?eWxNbVFuWlN1UFROSmpFYmhiN285VnlIejd2RzJGMkpQTlNpWGZYYnBoWmJN?=
 =?utf-8?B?Y3BKYmdJME9XY3FsV1ZzckRKR1lKUVhrTWd5dUxXOVJKVmZleWRCZWdSNHN2?=
 =?utf-8?B?aGFabGJjcGxLdTM5Vi82eTNJdXBSRVdzVUdRY1JtRDZ0djA1YjBHVEVEbk1j?=
 =?utf-8?B?T0xKYnQzRGtQeHBuMnhKaHZoMWZZSExXM0F3SytHbUJoSllpekVGWG1xWWdZ?=
 =?utf-8?B?SzlrdDJpaU1MT0RtZTF2ZFRUZldTeEFhek93S0svVFVPRTBuaFY1aXJ0VW8v?=
 =?utf-8?B?VkRUS051amlwb2ZuS0gvTnRrZEhzbmlNR1NvNloyaGlXYWRabXdkYzlQQW1k?=
 =?utf-8?B?bFZXVjluR1JUSFJRRmVENHgzeXRzU2JzQlk1T2R0UjIwVFU5b1RsbUZ6L29S?=
 =?utf-8?B?WkVBNUkrTXJQTlQ5V2YyTWZOVHhySklSeElFcWVJLzZOYy93YTMvdTh6VEJL?=
 =?utf-8?B?YjRkaTJDWk1VMnBsUTlHTDBFV25kVFk2QW11VW1hMlpyU0tZWmVhdG9uL1Zi?=
 =?utf-8?B?MDlmUlhLUkJpaHVHVEhJcXVwaUVWeGIxT3VYUC8xcGlsZzNKUFNQWmJKVzdo?=
 =?utf-8?B?clRmT2pNaWtqVG93enZ3S1F5RnRIY2lXbVJGY1YyRVFBMlJzWUFMendvUlhy?=
 =?utf-8?B?TFFzamlzeWZ3YUdUMkpQYytySGxXYW5UcitOb3ppVVltcVpJMFlGRmh3c255?=
 =?utf-8?B?L0VCRm5uWU5tWWdyZXN1eEhpL1ZIejhHTFl2Y3p4K0VKQmZUQ1J5SWYyWnll?=
 =?utf-8?Q?m/x2hBuBUATz49IsnD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1cb9631-7b96-485b-c214-08de6dabd6b9
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 22:36:34.5666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: En+A1uWGxKhyyuaYfDfRFz3BHZo7UuiXrWOfm2VtFBqhXuapmcOI/N6zQXrvc6g3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7803
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71137-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: 950E0147F23
X-Rspamd-Action: no action

Hi Reinette,

On 2/13/2026 6:10 PM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 2/13/26 8:37 AM, Moger, Babu wrote:
>> Hi Reinette,
>>
>> On 2/10/2026 10:17 AM, Reinette Chatre wrote:
>>> Hi Babu,
>>>
>>> On 1/28/26 9:44 AM, Moger, Babu wrote:
>>>>
>>>>
>>>> On 1/28/2026 11:41 AM, Moger, Babu wrote:
>>>>>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
>>>>>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
>>>>>> Babu,
>>>>>>
>>>>>> I've read a bit more of the code now and I think I understand more.
>>>>>>
>>>>>> Some useful additions to your explanation.
>>>>>>
>>>>>> 1) Only one CTRL group can be marked as PLZA
>>>>>
>>>>> Yes. Correct.
>>>
>>> Why limit it to one CTRL_MON group and why not support it for MON groups?
>>
>> There can be only one PLZA configuration in a system. The values in the MSR_IA32_PQR_PLZA_ASSOC register (RMID, RMID_EN, CLOSID, CLOSID_EN) must be identical across all logical processors. The only field that may differ is PLZA_EN.
> 
> ah - this is a significant part that I missed. Since this is a per-CPU register it seems
> to have the ability for expanded use in the future where different CLOSID and RMID may be
> written to it? Is PLZA leaving room for such future enhancement or does the spec contain
> the text that state "The values in the MSR_IA32_PQR_PLZA_ASSOC register (RMID, RMID_EN,
> CLOSID, CLOSID_EN) must be identical across all logical processors."? That is, "forever
> and always"?
> 

It should be identical across all the logical processors.  Don't know 
about the future generations. Its better to keep that option open.

> If I understand correctly MPAM could have different PARTID and PMG for kernel use so we
> need to consider these different architectural behaviors.
> 

oh ok.


>> I was initially unsure which RMID should be used when PLZA is enabled on MON groups.
>>
>> After re-evaluating, enabling PLZA on MON groups is still feasible:
>>
>> 1. Only one group in the system can have PLZA enabled.
>> 2. If PLZA is enabled on CTRL_MON group then we cannot enable PLZA on MON group.
>> 3. If PLZA is enabled on the CTRL_MON group, then the CLOSID and RMID of the CTRL_MON group can be written.
>> 4. If PLZA is enabled on a MON group, then the CLOSID of the CTRL_MON group can be used, while the RMID of the MON group can be written.
>>
>> I am thinking this approach should work.
>>
>>>
>>> Limiting it to a single CTRL group seems restrictive in a few ways:
>>> 1) It requires that the "PLZA" group has a dedicated CLOSID. This reduces the
>>>      number of use cases that can be supported. Consider, for example, an existing
>>>      "high priority" resource group and a "low priority" resource group. The user may
>>>      just want to let the tasks in the "low priority" resource group run as "high priority"
>>>      when in CPL0. This of course may depend on what resources are allocated, for example
>>>      cache may need more care, but if, for example, user is only interested in memory
>>>      bandwidth allocation this seems a reasonable use case?
>>> 2) Similar to what Tony [1] mentioned this does not enable what the hardware is
>>>      capable of in terms of number of different control groups/CLOSID that can be
>>>      assigned to MSR_IA32_PQR_PLZA_ASSOC. Why limit PLZA to one CLOSID?
>>> 3) The feature seems to support RMID in MSR_IA32_PQR_PLZA_ASSOC similar to
>>>      MSR_IA32_PQR_ASSOC. With this, it should be possible for user space to, for
>>>      example, create a resource group that contains tasks of interest and create
>>>      a monitor group within it that monitors all tasks' bandwidth usage when in CPL0.
>>>      This will give user space better insight into system behavior and from what I can
>>>      tell is supported by the feature but not enabled?
>>
>>
>> Yes, as long as PLZA is enabled on only one group in the entire system
>>
>>>
>>>>>
>>>>>> 2) It can't be the root/default group
>>>>>
>>>>> This is something I added to keep the default group in a un-disturbed,
>>>
>>> Why was this needed?
>>>
>>
>> With the new approach mentioned about we can enable in default group also.
>>
>>>>>
>>>>>> 3) It can't have sub monitor groups
>>>
>>> Why not?
>>
>> Ditto. With the new approach mentioned about we can enable in default group also.
>>
>>>
>>>>>> 4) It can't be pseudo-locked
>>>>>
>>>>> Yes.
>>>>>
>>>>>>
>>>>>> Would a potential use case involve putting *all* tasks into the PLZA group? That
>>>>>> would avoid any additional context switch overhead as the PLZA MSR would never
>>>>>> need to change.
>>>>>
>>>>> Yes. That can be one use case.
>>>>>
>>>>>>
>>>>>> If that is the case, maybe for the PLZA group we should allow user to
>>>>>> do:
>>>>>>
>>>>>> # echo '*' > tasks
>>>
>>> Dedicating a resource group to "PLZA" seems restrictive while also adding many
>>> complications since this designation makes resource group behave differently and
>>> thus the files need to get extra "treatments" to handle this "PLZA" designation.
>>>
>>> I am wondering if it will not be simpler to introduce just one new file, for example
>>> "tasks_cpl0" in both CTRL_MON and MON groups. When user space writes a task ID to the
>>> file it "enables" PLZA for this task and that group's CLOSID and RMID is the associated
>>> task's "PLZA" CLOSID and RMID. This gives user space the flexibility to use the same
>>> resource group to manage user space and kernel space allocations while also supporting
>>> various monitoring use cases. This still supports the "dedicate a resource group to PLZA"
>>> use case where user space can create a new resource group with certain allocations but the
>>> "tasks" file will be empty and "tasks_cpl0" contains the tasks needing to run with
>>> the resource group's allocations when in CPL0.
>>
>> Yes. We should be able do that. We need both tasks_cpl0 and cpus_cpl0.
>>
>> We need make sure only one group can configured in the system and not allow in other groups when it is already enabled.
> 
> As I understand this means that only one group can have content in its
> tasks_cpl0/tasks_kernel file. There should not be any special handling for
> the remaining files of the resource group since the resource group is not
> dedicated to kernel work and can be used as a user space resource group also.
> If user space wants to create a dedicated kernel resource group there can be
> a new resource group with an empty tasks file.

Correct.

> 
> hmmm ... but if user space writes a task ID to a tasks_cpl0/tasks_kernel file then
> resctrl would need to create new syntax to remove that task ID.


I'm not sure I fully understand this, so let me restate the sequence:

Example 1: Regular group

# mkdir /sys/fs/resctrl/test1

This creates a normal resctrl group.


# echo 1 > /sys/fs/resctrl/test1/tasks

The group is still a normal group at this point.


# echo 1 > /sys/fs/resctrl/tasks_cpl0

This converts the group into a PLZA group (task’s tsk->plza field 
becomes 1). This works as a regular group because both user and kernel 
CLOSIDs are same.


Now create another group:

# mkdir /sys/fs/resctrl/test2

# echo 2 > /sys/fs/resctrl/tasks_cpl0

On AMD systems, this should fail with an error like: “Group test1 is 
already configured as a PLZA group”, because only one PLZA group is allowed.

Now remove task 1 from the test1 group:

# echo "" > /sys/fs/resctrl/tasks_cpl0

This resets the group back to a regular group.


Now try again to make test2 a PLZA group:
# echo 2 > /sys/fs/resctrl/tasks_cpl0

This should now succeed.

It makes more sense to have a dedicated group for plza in case of AMD. 
This option also allows to have a mix of both in one group.

Thanks
Babu

