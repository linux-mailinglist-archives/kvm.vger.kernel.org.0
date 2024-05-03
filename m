Return-Path: <kvm+bounces-16463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40B118BA476
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 02:19:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAD8A284D5B
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 00:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A1F123CB;
	Fri,  3 May 2024 00:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tze/ziuL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D992360;
	Fri,  3 May 2024 00:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714695541; cv=fail; b=T854x2dCPL9CR+NYfpflZ731cWroSonEqQHFt8YtiU/oj7bMHZcM+TeMrAlyywBnQ687o0LfnHoCIveR9khKAM7ubBJkzZGuHBhpKKFA0lXzwXq5r3mscl+6r3AgQsILZ3K+8qrSlRosNdQlnoyFRx+feZtYfUxT5Ee6T+YLDFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714695541; c=relaxed/simple;
	bh=RMyf7y1g74BwqCajKCqz77zR0M8ZuFBSudoOx5+GG5k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uHPVPoLbfFmL52i5V9IdxPBK9jGoELDTgrFjPNqspjt23SR3saZ5ziLa6GwHCBNBUr1qShkhRsEEJy3c5rcaNdLrVs70eugbN5s38yWvXnoY/yUdvERynp5p8X2hbWX7vB6z9DwLUVNj04p8iQz15Jqg+NS9koETor5s6Pw2ujs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tze/ziuL; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714695539; x=1746231539;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RMyf7y1g74BwqCajKCqz77zR0M8ZuFBSudoOx5+GG5k=;
  b=Tze/ziuLuPm4NZMVxYEOT47At9Z4KWr1MRriteukT75BcdhkbPWvIq36
   eqf16hKtmsXE+Ld0ucaqRHKyu9HeYsGv8BbliymU2R1Til++mfKHjMnQm
   qLYDkl5ZH+Yky5g4eID42uIt/C8AHVaDkz1iiB0Hb1jxNjKDk+QGx1NNb
   iO1vI7J1i9E6jAQExnyP2zzjRJnHQvgVbJMcEqjJdI0AkrtvwBIlbstC5
   WYI33Cy8REM8dHfnm6jcDBk4NLd54PS5ifAs7NYpku35zuFKBzNddOKfH
   MJvIGrigka7ZBcGNaIH3DLc28PjOUUd/HTns4eM+onKieIrD1Gky7Gq9P
   A==;
X-CSE-ConnectionGUID: txfgHtHQRNerAV3HapdTeQ==
X-CSE-MsgGUID: 56aclcdsSICo8Yt1QVKnlg==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="10345058"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="10345058"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 17:18:59 -0700
X-CSE-ConnectionGUID: W6VHfCCgSBuyrDc4EwN8Gg==
X-CSE-MsgGUID: 2HPOcCPnRyusyUNyvl5x7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="27308742"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 May 2024 17:18:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:18:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 2 May 2024 17:18:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 2 May 2024 17:18:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAg1tn6ko7FfwC8HR4K2d3FiWHTlcz59cJfu+9SK4GIaQjMb2gpkdaLxicTEtf61sZ6dvZVPw7eH4F0FLJ770b8hOjXZwUuGxbMLfEOtobqoSd65sAKCNkPwmqf5nTtLvQloiSrtO2iuFIq1d9o79RARgDFhkgaRmPpXYoW8bAAn+V6nYNBAd2ZPferrD9lzPMbaqlA3mcwEeU7csOjxU2Mo0yAY7stjNRpfdBQBq680cyy3ntOnWX8/dzyLK0UpnNs882f66mgZxJgxtYNsQ22XKmeGMbKJ70bHKb/lRKPvOMW6sY/IdhSh++xRl5PJme7ot5FK8xcouJT2edE/mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ilcpIPrFbZ30gvNCsK9gSuX6UP9y8scbD75GJyHwESg=;
 b=XlAN2DgYJJnR41mfz/i+HFnY0ZdwIK69bNnU3f3KxlalV3dZ217yMB6zdqzoHxXKX/4rHrHz+DcAzBvYBDn5cNWUL7oVfqPHs7Y8S35RKTlqZ1yNPgeosBI0SP9n9NHR7trMCxPxl6858KOddKzTKA/ojlDj5va0H0ahQ8PANtcIW3+TgwTJaGDMXk8mO8/z+PoQpNBapjJofYccXMlGcJzWaL90VVCxnrxV+kji1Y0tvLAEkhQT22R3jMFpCeqPK0PlsFjqZ9b9BGE9ZGjPmomtjkJ3AjxN4210CIDGAPKj5dep2H0bRgeGU/d5XSSnOa0k5KHLt/+tstJ3OhDvgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6389.namprd11.prod.outlook.com (2603:10b6:930:3a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.36; Fri, 3 May
 2024 00:18:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.029; Fri, 3 May 2024
 00:18:43 +0000
Message-ID: <6d173173-97de-42a9-85f7-20c5b6a2e6fe@intel.com>
Date: Fri, 3 May 2024 12:18:32 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] x86/virt/tdx: Move TDMR metadata fields map table to
 local variable
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
 <41cd371d8a9caadf183e3ab464c57f9f715184d3.1709288433.git.kai.huang@intel.com>
 <21310a611d652f14b39da4a88a75ded1d155672e.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <21310a611d652f14b39da4a88a75ded1d155672e.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0058.namprd03.prod.outlook.com
 (2603:10b6:303:8e::33) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CY5PR11MB6389:EE_
X-MS-Office365-Filtering-Correlation-Id: d1c26141-c04e-4a27-0f99-08dc6b069768
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007|7416005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZG42MWxZUDZZWVBWWDR4QTNVQTRmMHJndHRsSVhQcWVCT3Rnck1TeTVmaExL?=
 =?utf-8?B?WFZIRzJPd1k5TTIvTXltWE5sL0tnajA2bkNiMGMrUlQyV3JuZGVpdWJoNnFx?=
 =?utf-8?B?alVjSGFEaXFJMjloL25OREc2SDRqS2UxYUV4REhubldjdTVMOEQ2ajFxdWN0?=
 =?utf-8?B?WktBbXY3dm9EUjNEV1V5WFJNOElSRm0yV2t2dVp3eW96YkpqZnpWbWdmTFVn?=
 =?utf-8?B?ay9yYVpHREJhQTlNWUpuQnJxVVhDejVNbWVYZXB0SUsxVFBtNDJDalB6K00w?=
 =?utf-8?B?V0hzWEwzUW42aVk4cjZ4b3ZNVlFwaDhYWGNQbG9YZ2N5YVg5d0cvdlBUeHZR?=
 =?utf-8?B?TUxLM3N2L21lc3hOb29Hd2NsZXFBS1FpaGNsSXI2ZDNvcnhMSkFLa3RTNWU5?=
 =?utf-8?B?MlFXaG13SkFZUzl1bldKeGNVWVlPYjNITis2ZDkrN2toT0VhRVoyOHhjcDdH?=
 =?utf-8?B?dE1jM1FqakJqMkdGc0FiT3k2bFBGanFQVlp3c3FYUDcvNG1SMlRKMzRSWEt3?=
 =?utf-8?B?L2NXUVhHUEJ6ZEhwZWVBWHMwa0dBaFVndnpCcmY2bmFKT2VCNnJvcllBTisv?=
 =?utf-8?B?SDlyOVhLblFJSlJva2l3d2YwdHdtWktYNFVFTWUvUThKanhWQTRBanRGOWwr?=
 =?utf-8?B?NmpiTVRlQllNNkl3VExxSGhPZ3ZjWkhrK1kyR3pOS25UUFhOWDh3cVRrRjRR?=
 =?utf-8?B?ekgvU3NOQVNlR09peU5VbUo5NjJ3R21BN0xHL0tCSEVubmNQdmUwZmtQNG5j?=
 =?utf-8?B?cjNZWVJTRE9xcHlxSEhXZDFjdWQyd0tiNWxkenFheElUTTJubWFxUXlOdXp1?=
 =?utf-8?B?YTlzT2pYNXBSejZwNEZoN0FHdjBrWWZJcndDdTVBZWF6N3pSNVpPbmlmakdk?=
 =?utf-8?B?Q1lzcUZIVDErT3NKSDVNNE50OWptVlRTOGZtQ1RHSDREQk1CNHBIL09PSXZ6?=
 =?utf-8?B?T2F3TTZJcktHZ0thempjUjF0Y2dNekp0ZStRNXgwV01acmFLbzh1RmVmT0xP?=
 =?utf-8?B?ODZMNyttQTdrZ1RYRDh4OTNhZzFwUTk1YkpOdHoxTFRkcVlQbW0rRWxXdUFp?=
 =?utf-8?B?eWhNbnVsSkN1Q2NWNTlYWDAvQkZSZEdsM2xzU2pzMExxVWNZSHBoUmpQSi9l?=
 =?utf-8?B?WGdSUkhzRHF3aUdqR0hzOEYvZnRQRTVPSWlSVGl6VW9ELzVXbEt2azV4bVkv?=
 =?utf-8?B?WVVMNW0wT3lvSGNURWhCOXVna3FBRS9RcGdNVk8vYm1VS1JmakwzS1lLSXli?=
 =?utf-8?B?R2laTmhvM25DbDBlcVM4bldIMmFZcGw2LzV1bmFKc2xnSk1vMmFOTHROSHda?=
 =?utf-8?B?bU1TY2ZFTUxVeUZCY0FsWC9KMXFRQkVUZ3oybHJjV0VmZFN5VXpMUHhBSWE4?=
 =?utf-8?B?cU1oODZwYi9xNTNxd3FoL0ExLzZRSFBhK0dDRGdrVFZrcE1ZMUg3R3U2dnV5?=
 =?utf-8?B?dGdTaDBvbFJxank0d2RFVGRQWm43SlF5RWV3bDA4T0NjbFdWUGlGVGN0VjZi?=
 =?utf-8?B?TnRlWjJWK2RydXNzWFZObTVxalZUYjZBdGxyMGJSVUJleVRYSDA5SHZQRk4z?=
 =?utf-8?B?YTNyalZMZi84aGt6Wi9HamczR1h2dkVkVTJNak5xaDJyUzBCaWF0d2Q5UUdu?=
 =?utf-8?B?KytkUTk1ZXNWUjVQUXdQZlhOaDBBNVlUMDVjZHlSNGtPbWJLdmVTRjRmNWVs?=
 =?utf-8?B?QlJoRUh5ZEdVZ0ZEU1EwS2NYOE5CYkhTZmF1VE9UdXJRTWRzTTRweVVnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWlCR291L0FOejVnNjhVZjlzblRqYVdSMStYOFFOc29DdUkzQ1hnYzNFay85?=
 =?utf-8?B?SGtnb3A0dDhyV0s5YWZDeXd5YmNuaXc3VFQ1VVJYR01xb1B6dUh2TUduT3VB?=
 =?utf-8?B?YURUWUZXL2s5YUFUWjRZZW5xZHhjQWRiVVl4OWF4OGVMK3hMRUFUc0QzSUlX?=
 =?utf-8?B?WUJ2ZnVBeDJ0M1JNTzl4TFBZZWxqUFZrd1JFUEpMQzY2Q3dXWmNqak5rZkpm?=
 =?utf-8?B?c2diUURzYStJSllSb0pSaGkrOXlVMWZiSC9zUjdFYVU4eUs1S1VDTy9VZEV2?=
 =?utf-8?B?dDcrTW1rekJXRXNSSVBKRWFUZDRmY3dxUk1ZN1phNDJDMlNVVEExdWp5UGlK?=
 =?utf-8?B?ckp4bnlSc2hJSENoa2grdEJINlUwamNFaGpnV0dKNDg0UkpxMWU0TE5KNWRM?=
 =?utf-8?B?V2FJVGdydHRLdFdHaWVKRjI4NWtta3dHRHVJK2krcGcvbkxIaTVXcFdpUVF0?=
 =?utf-8?B?SGtoOUFlNTJGWUxpODFPRnJkdXBVYnJiRUJPbnE4bjVYamIxdThVZXJMUmlo?=
 =?utf-8?B?bmFEdkZ0czBDNExUSllOYUNzZXNmb0xGZFE0VFRYWlJyOUUzVkM5b1pKbmlS?=
 =?utf-8?B?Sm5xZWN3WG1Uc0JoK3hBMzdOZGlaSm5pcThIY0VXYURvRWIzSEQvT0RnTkhw?=
 =?utf-8?B?NzUvRy9sdUF6eU50eC9XT3BpZStnN215Q0ozRktURDBXd041UWVOMFdlamw4?=
 =?utf-8?B?WTFQVVpQZHFvZU1zZ2QrTWt2dzlScER1WklZbC9oamlzSDBSSlZSYTl3V3Vr?=
 =?utf-8?B?VlRjUmFNN0ttclZGWVltVU8wSGpja3RGbDhRNG1XaXJVck94R1gxbDd3QVU0?=
 =?utf-8?B?YXRPUy8zeUNuS0pXa2M5MUpjV1ovY2xuVDFXY2xkWHFpK043dC9sZWZERmZE?=
 =?utf-8?B?dmU2K25aNjJuTUNMcitZQmE4d1ZEWWpTMC80d2ZKMWVKbGJoK1pQKzdwMzYw?=
 =?utf-8?B?eFYrbmxHakhBcTVicmJLOG5SUjVwNGV6akhRM05RT2NHTUZocytlVGFIdENq?=
 =?utf-8?B?ZWNIVzJqOGFaRC93RzdGd3dsQmZoOVhUM0pOamNwZEpuWTBTbW5YS1VIWlNS?=
 =?utf-8?B?TmF0RjA2WFFsKzdBS2dVdmRDMmZZTEFWSzAxT2VBa3VUNHRkMlA1VUhjcldJ?=
 =?utf-8?B?WDkwek1Pb3ZWSG94QXNURmg4WExGZWZOcFMrdTJ1MXVWUTFjaTBuL1AvM1VF?=
 =?utf-8?B?TFNsWHdzMVVoUm1JVXhMcU1tQlUyanI0T3d6dEZSTzdYSE90Ty94d0dSTmpR?=
 =?utf-8?B?akRDNFJONlZLV1NkKzJIalZPMG03aWNXSDB4U0pTZ2dKQlgvZEtiaVJ4QjVx?=
 =?utf-8?B?WUNmTExtOGhlM1VkNXRrN09oVTBIMURyV2VVQkdCLzA5eFF3OGFOaFZMWTNu?=
 =?utf-8?B?STI4OWR4SDJqZDZoTjBXc21oSVo2czQ1QWVsTzVQSFJIVktlNFBsakJ0YkxP?=
 =?utf-8?B?czYvSUV6b2Nicm1IeTNrcENNRldMbWJFNTFyUWRnMGVDR1AwSFRkOWROa1g3?=
 =?utf-8?B?a3Q5cWc4Y00vTDRIZ1FIMEFtSG9sVjU1OU5jWm1zbWVxbFRDQXlXaTF5UzRo?=
 =?utf-8?B?dkUvQ1lzNlVaaEFsbVlPWVk4emtmOG03emRRTUVLcVUra0Q4RXl6ZTZuUjln?=
 =?utf-8?B?TXpNc3VTTUVIK3luSFpzb3VrNnFldTNTU3FvZGFZR1JIREJsWE9GTmlYWE4z?=
 =?utf-8?B?ampQQzBVMlFJQ01KQzA1emxIbWxyL3J2RndRN0tNTzFPY0VRd0xGZHdjQkpy?=
 =?utf-8?B?dEhmYXlUUy9lQ2Rsdk5oU0sxMTNYMUJiRlV2aHVQaVNkTUc4Ung0U3llSExF?=
 =?utf-8?B?NXBIamU0ZE9rdStETkFZQVF1bHVaa3FLYVh5SkIvN2tMMngwdDRmSUlUcm8z?=
 =?utf-8?B?ZkloaldEeFk2Vy9RZmZkY0ZjZ3hhZVYweEtBdXVCTFBsU0NqMVBEVU5tWVQ0?=
 =?utf-8?B?eVE2VnQ3NVU5Zm5EcVZGM21wTHNWbUh6K2FkWVRncndxeGlQUnBUZUlkcHl1?=
 =?utf-8?B?S1l1emI0TUpiUGl6YXo1alNIQndBZVBOQkNOeTBHZWtNemlUZk9yMnFzY1Zt?=
 =?utf-8?B?clF1R3BvN0F0OUZVazRpam9EQ1R6akgxcU1nOXA0ekhtZVMvdnJocXkvZUQ4?=
 =?utf-8?Q?GaZQCcfGsoqh/g0EUMHZ5/NDL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d1c26141-c04e-4a27-0f99-08dc6b069768
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2024 00:18:43.5595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8lxS3dDQWQhMxVHuPoZUuf+3D2rX/KrzZSXaUEU0e7JdPax5ssiEOoV4xytJwyB5KTtKfZfdwjqxkWX7F3mlVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6389
X-OriginatorOrg: intel.com



On 3/05/2024 12:09 pm, Edgecombe, Rick P wrote:
> On Sat, 2024-03-02 at 00:20 +1300, Kai Huang wrote:
>> The kernel reads all TDMR related global metadata fields based on a
>> table which maps the metadata fields to the corresponding members of
>> 'struct tdx_tdmr_sysinfo'.
>>
>> Currently this table is a static variable.  But this table is only used
>> by the function which reads these metadata fields and becomes useless
>> after reading is done.
>>
>> Change the table to function local variable.  This also saves the
>> storage of the table from the kernel image.
> 
> It seems like a reasonable change, but I don't see how it helps the purpose of
> this series. It seems more like generic cleanup. Can you explain?

It doesn't help KVM from exporting API's perspective.

I just uses this series for some small improvement (that I believe) of 
the current code too.

I can certainly drop this if you don't want it, but it's just a small 
change and I don't see the benefit of sending it out separately.

