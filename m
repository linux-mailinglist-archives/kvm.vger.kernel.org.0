Return-Path: <kvm+bounces-11076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C051872ACB
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 00:06:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13169283B67
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 23:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463E412D216;
	Tue,  5 Mar 2024 23:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cdvwjT9+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F5F2563;
	Tue,  5 Mar 2024 23:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709679996; cv=fail; b=iWnp0D5k6/Ma4VMiK7O+1HVYjn2w5g8JRh60iKB+tMEBOXPGsSmvMXoOIrGdb+X3ZOzp3GnLn4VyhvtT/6lUKGSGxIkuZ+9aC9Vvn78RFyhKZKk7y4evAWJD0Ag4aPT+8C/GxqLB6ZsISodpu8UVtWqrfZKAAJ0L+6JKBH+/AHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709679996; c=relaxed/simple;
	bh=mOSvpcR9FTgBstJCL0qMawTYFdAoAu+3qra+HFEKEYs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RgwWt11MThJbSWtnVR/jzi+MA2w47PML6HnpPG6DltukM8dOQogJa22zpfA+6naPsFMYejYWd6NqPDt19aV27/GF2xWA4OcCrVz7HRSh4c1Hc1QZiqB//ebW5hu5LxJMUaRc3hQNInTfgc4KMi9V6+XFxIxFSuLCwiEX8GapKzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cdvwjT9+; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709679995; x=1741215995;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mOSvpcR9FTgBstJCL0qMawTYFdAoAu+3qra+HFEKEYs=;
  b=cdvwjT9+XFY5IlKHdctz2KQxKPIe9RTHJGGpbeTFKNFtNTjUoUAa2WoP
   cofp9O2Szcntii5oiUNu6u8F3cKWancFMeiSEYqrjr/RKwKE/f6TfabV7
   6rkfrhxcEHZZnHLNN9lkLOtllxm7uDFfk/GhX9nSdDDXsK/0fcJ593qrO
   gKnDZHv+jV2pnNDme9aZr/1PPsGgt0PO4joY0sGMgrjj445N3ysdIM7KE
   dcerwX1nQRqXpgLNZYGdY7PJ5PHJTOjZfk+K8dvKEvtDNYO2UKGAz9c9O
   mOo6FsaS/ppbqgfgcT5K7SBnPelQeJErG7cO/xoBRlPcxUUOyGCHfu6Ta
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="8069881"
X-IronPort-AV: E=Sophos;i="6.06,206,1705392000"; 
   d="scan'208";a="8069881"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 15:06:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,206,1705392000"; 
   d="scan'208";a="32697320"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Mar 2024 15:06:33 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Mar 2024 15:06:33 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Mar 2024 15:06:32 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Mar 2024 15:06:32 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 5 Mar 2024 15:06:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QiBCODqcVPXjHOQqZKcjfR5ZF7j8xsg6mpzaGi/Pw6IuU6bc8EayD30ysIGrZJyZu0q4f7FUfFqE4pOwyz5BU5+87jynH5cIpk9qYCIPP3qRu4pIgEu9xu1BnLOvlQ+t3IsxduLlGvY5D2+4b9ECj7pafywhfP+cUB+XWxg6llAm1Wuin4VSmaetvfG1DjL/Wi5pF8BKN5B4Y/8XelPeO18RUFPiVPX+G5AgdEAdldA4mBW9SyNLrUke2EWIHJl7gtER5hXiJQQLImyZ5Dy/iNFkBQsxeZXz7h0jXsd1o8uK6IE9cESN6ObEC40oxlYOU2zR2OaUhosciadclivrvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQXOC3vX3AMT5gtsKOdUL8y2ttKjnu0a3ei7U4WS4i4=;
 b=lRgsSJs8PboBeplnjQM7MvgPv8PX2TMG1A6RodciB+6bd8Url9g0hJajGeU9H03GZG4h5aof8vXDY212dR3D4OAkwN6FezsqB8WW01SjW/CCx0Ted+bonurwQ3zGOK3OSSf+Ob49y4bWX7zfVz6+3OrM/SwfXbP2gUQna7DQU+c9+buxxILJkg/XuGR405S/MLKxB8hGwZT5CerEj4KnqgeBVWlEQJ1e1d7lUbWuO/KszWiL0nW9YF4GNhX4vA1mgRiwH2cLo2gJjI+Tbnc/wnx7QDzZbfEMKnpzEqBNTmGwzgEKtow3IokwMwsaxWDlTFWSZTNxtMu61Q0ybZwwMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by PH7PR11MB6355.namprd11.prod.outlook.com (2603:10b6:510:1fd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Tue, 5 Mar
 2024 23:06:24 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::dd06:e9e7:d35a:77b0]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::dd06:e9e7:d35a:77b0%5]) with mapi id 15.20.7362.019; Tue, 5 Mar 2024
 23:06:24 +0000
Message-ID: <adbcdeaa-a780-49cb-823c-3980a4dfea12@intel.com>
Date: Wed, 6 Mar 2024 12:06:14 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/16] KVM: x86/mmu: Move private vs. shared check above
 slot validity checks
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Michael
 Roth" <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, "Chao
 Peng" <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, "David
 Matlack" <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-10-seanjc@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240228024147.41573-10-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0195.namprd03.prod.outlook.com
 (2603:10b6:303:b8::20) To PH7PR11MB5983.namprd11.prod.outlook.com
 (2603:10b6:510:1e2::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5983:EE_|PH7PR11MB6355:EE_
X-MS-Office365-Filtering-Correlation-Id: 76b6e376-1a37-4bf4-e239-08dc3d68e0f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k3vKIP/qkXPPhNqEVC2+mjt20tvbE6+HQJHf0f1EKPF1smwaAXkcLZnO1+hiQtrcDGpRH/JtIT2XqB4hwjouSL/Uff3hmPK7k4VO1HFN8VbTlaSRMHmLS+E4n79kCWi0frr95bodf8mqLksBNCwBLNBWg0q6zfH+O+xsGKbPoAsFsHtQx9NdsbY9UNdBrdN2X0S6vd8VmJtRgoYygYhLMMV+P0zTfFgxQ4Ku5BYuGjqa5GnISjmh9RTikHUJNT3itA5zNZP8IGkUEwPdMZd3bft3ozVO/OOjwqjHEHrUqX9Mgi7rsyLU2+DEKWkewV6N8vHqxz70rcQf19n8HhbUlQ+EtCqUqWM7lTKHqUIV//klirXgHu4EWLrTiqvUJKNJ5e8Mu85h1naVQ9E5D5wyl+UidxLo10XbqytlZyQRu8L4UNZsq50jdynN+V3SOlJb8LsfFyE9xn7MmR+H4ko1n4eWNYgll9aqwCRcA0bqpn6kw/i7l/3PrIUFIWhYJLWw+7yDE3o6Eugn4DBLTXioeWmR5B6uUzGR6Xhe8IzdvooauUe0idAv1uPMfq2wbNPSQfTn2D/Nq66l4cINznWUboOyEAepIJuHTrkXD7o0qhLzbrlUYAWKa7vvN46ZCzGMEA8hYfuYbKHkG1oDR/Ze7mZd1+WhaY2haDsDAXVrWQc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bW1odDF2ajlKOTlIajBmL2k4blZLb2J3RXQyM0NkeGtQV21SWHlVSjlLS0dh?=
 =?utf-8?B?YXNhYWlqNDU2djFWT1JtTHRKMWdvcTNqTk00NU9QSG1nd0VTa0ZDR2oyMkFr?=
 =?utf-8?B?RXl1blNwQ3l0YXBVOHA1QmRrLzNDbzExVmlxRFM1aWZpUjV6STZlZ09sMXdm?=
 =?utf-8?B?S1c5TmpUTHlkeDI3aE5lYlRXMUFnL1BQU2tTZkZPenJPNFRCT3FqTCtncFNI?=
 =?utf-8?B?TXlhSW44azdzcklTOWV0SVZoT2M0bmtpRUxzemNIbk5nUStBd2paL0VmQXJI?=
 =?utf-8?B?dnRDRjlqclgyelBiMlJZaWtzZElyeEl5OUhEcUt5K0FSekxYci9TcFkvWXBa?=
 =?utf-8?B?RXdwSjVFODZ4UnhrRDVkTVN3VXRzREx6YlZEdkRQa0NKK1BmV2Z4ZEtRdkN2?=
 =?utf-8?B?dFAvai9TalZ4Q2dxbll0U0VQSjNwMDlVTDlGdWxCUjNXSFUrZUx5TnJxVko5?=
 =?utf-8?B?bWpxM2R0T2IvODNZcER4d2JLaWU4N1NvRUhrN0RSQWtmbTRxbjE3ZWkwTzJn?=
 =?utf-8?B?bHAxbkFCd2xYNFpLdmZlUmlxOVJkNmsrOXgyQ1VoSVEyL0Z2YzY1Qm5VRlpC?=
 =?utf-8?B?VlIzZGZZcXQxZjVuWUZvUWNjeURoNk1HYUlNQzNUM1FJQitJUGFHRTNFVmFs?=
 =?utf-8?B?RHEwU01TYzJqeDBtT2M2QmJFQTRoVS9DYlZHSGh3L2dkcGdXZ0p3cExzNjI3?=
 =?utf-8?B?VU40cFhyU2RhUkhBWnNmWGtvSlhwSG96UzllV3ZvdjlJTXRxSUJSeUVvWWdP?=
 =?utf-8?B?MjNDaXgvUWNBeVVMbkRsZDlHUndML2ZpVzBnMzFQYTJKSy9ZZ1U3VEtYYUEx?=
 =?utf-8?B?VG4zZ2IydVBQdUMvWEFDa1RGOUpaelFkUnNkNVJ1ZHVzenBrZHhTdDdyZi93?=
 =?utf-8?B?OFlQbzFGRjVKOEkwR1J1blU3WFZWajIwVUQwWmVXdEc3d0JkRGFqRzRubHkx?=
 =?utf-8?B?bzBrZjJaZFpqUUFxQ25MeWc1bEJWa3c3Q0NscC9CbnRYdU1nSzNXSTFiKzNa?=
 =?utf-8?B?TnhqcUlSOEtMM0xVbzlYRWlmNlVEWUlHbkZQY1MxZG84dlF6aDJnSUlWbGRu?=
 =?utf-8?B?U2JKWEpZUTBPWFUrTDAxV0JKRnhxVnVQWCtIY1JrV0ttR3BPSmNUdjRSdE1Z?=
 =?utf-8?B?eFZ2VkVRM2VvWXlHa3AxaENRZ3lSY3YyMSs2MmlXMEdQNUg0a0tyWGt5b1hK?=
 =?utf-8?B?cW0wSlRUOXY5blMzd1BjZjhLZ1oyZFNUU3BYYUtxcE5JcEtZQjFkMGJzVG5U?=
 =?utf-8?B?T1Y5Y2lxZ2tHRnVSTGFXRGg5dGg4MGM0bjR2VTVtbjRhaXV4UjJYUHZUcDlZ?=
 =?utf-8?B?VTYxbG9NUVNNTEJCOUNKaHpkaC9GNWI1UEFhbkRNKzNYTFhMR0txblhvL24v?=
 =?utf-8?B?UldOUGdVQmxTMnhodmV0VlZLT1RLeVZNZUV3b1hNWkY4SUhhMWhFSTl4WHJI?=
 =?utf-8?B?Um5QdUdES2xDOEhnNWczWnF6NXdPRk43MTlZbno0OHVpclRaMXVXdndHbXBz?=
 =?utf-8?B?a2JkVnMrYjBERXc4TUFremhTSitJdFNOaWdMaXE5bEx1WE1hQlRJSHV1aFg5?=
 =?utf-8?B?RnNpaDk4eVpiK1hqTTZCcVNNSVNtcGIxdzBXTFBSYmlLU3ppN29lS2tTNUc2?=
 =?utf-8?B?aFV4YXJXRndHcStFOWtIL1c4ZS82Zit1SEt4dGNtZGFBdVBHVnQ0eS9uZmFk?=
 =?utf-8?B?Y2tDdzN2aXcxRDhVV0E5OUhIYUVTQzJBVXZOazRkdG9WWjlPLzBTT2ltMllN?=
 =?utf-8?B?VkxFSFJDQXRPY0IvUEg3Tko0M3kwYW50eFAyNm1iSCtaSGhmaGtZWnBYc0JH?=
 =?utf-8?B?b1h4MTJwWFM1UEhqa21TZWdGbWd6ZkFXRy9OVHdGNi9qU2tRNnlpWmJlZ1Ur?=
 =?utf-8?B?SzE4a1RWeFFHbHNnTnROaWQzNWNJd3R4SGNJYVlYL1ZZMlI1aFhleHhZOHky?=
 =?utf-8?B?ZGlSbmpsaEhTdXhpQWk1VExTNXJMQ3VJRi9yRUJ2VHBKamEyMTcxd1RubWg4?=
 =?utf-8?B?dGhUL0FYaXhJTWpoejlpQjNwTC8xcnhrNCtqQ0pLaGRSeVI4NkxkZ24xZHV6?=
 =?utf-8?B?cHY4c2VvclpzdTkxcE9jcW1VN01IeVU4d3hZS3VjWUM4c3VHZE9pa3hjUTE1?=
 =?utf-8?Q?WO+FALqtS0UdAzn3oHFVBRTjf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 76b6e376-1a37-4bf4-e239-08dc3d68e0f2
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 23:06:24.2012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RewLnkA9Ri1c+HTpiPmvDugOUS5Z1yXuwZIgJViWWZGgNoQfMEv8oHVtCyWmQXULNRDgb0baqFOUYL+493eQNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6355
X-OriginatorOrg: intel.com



On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> Prioritize private vs. shared gfn attribute checks above slot validity
> checks to ensure a consistent userspace ABI.  E.g. as is, KVM will exit to
> userspace if there is no memslot, but emulate accesses to the APIC access
> page even if the attributes mismatch.

IMHO, it would be helpful to explicitly say that, in the later case 
(emulate APIC access page) we still want to report MEMORY_FAULT error 
first (so that userspace can have chance to fixup, IIUC) instead of 
emulating directly, which will unlikely work.

Reviewed-by: Kai Huang <kai.huang@intel.com>

> 
> Fixes: 8dd2eee9d526 ("KVM: x86/mmu: Handle page fault for private memory")
> Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
> Cc: Chao Peng <chao.p.peng@linux.intel.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Cc: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 9206cfa58feb..58c5ae8be66c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4365,11 +4365,6 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>   			return RET_PF_EMULATE;
>   	}
>   
> -	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> -		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> -		return -EFAULT;
> -	}
> -
>   	if (fault->is_private)
>   		return kvm_faultin_pfn_private(vcpu, fault);
>   
> @@ -4410,6 +4405,16 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>   	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
>   	smp_rmb();
>   
> +	/*
> +	 * Check for a private vs. shared mismatch *after* taking a snapshot of
> +	 * mmu_invalidate_seq, as changes to gfn attributes are guarded by the
> +	 * invalidation notifier.
> +	 */
> +	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> +		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> +		return -EFAULT;
> +	}
> +
>   	/*
>   	 * Check for a relevant mmu_notifier invalidation event before getting
>   	 * the pfn from the primary MMU, and before acquiring mmu_lock.

