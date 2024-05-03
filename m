Return-Path: <kvm+bounces-16502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28A8D8BAC7E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 14:26:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BF0F1C227D8
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 12:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38853153560;
	Fri,  3 May 2024 12:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zy/wL5M0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861871AACA;
	Fri,  3 May 2024 12:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714739194; cv=fail; b=SJbsZjaXdcbavN0IQt3iS8Lp5cWqyHzM++5Ec4j1AMGN8J2vwr+4d7Z4GVXnaGfHVpnW9VWWrNM6dhYvrgGjXbBBrP21aup6GrES0MeNo8FqwotcvMz+1Ppn8WK/QA80bptcmjrkQrSa0EGmageW2/ATOvR6HniwKwvMXmsm/oI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714739194; c=relaxed/simple;
	bh=hwy+lNmTALpAYKIE/qdcsPFqtpd14EikBdVf7AdArlA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EuA4wyc4QHtvbx0wOygh0XLKfguPs5/3FL8kvgcoIWyae3vlklhvESY2TgUoIdveoQqt57s9ESX20ldCkbB2/51PQ9N0baS/gf0AyObDxo6dvig62rbg0vhYvH6cObW4YzgptwB4rLhDWQ7TU1qq1NtwuROUYdZns7uGfE6MXzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zy/wL5M0; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714739192; x=1746275192;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hwy+lNmTALpAYKIE/qdcsPFqtpd14EikBdVf7AdArlA=;
  b=Zy/wL5M03d9cVwAXmLPgovIgrEvTIDI7Ag8Nmnq9cMmdkoh55UWkpp+H
   OcLpw+7s00XOWYrUpEa6JautAK9ePFMSL/FPeWdxgtjQ/8/BwYdt46jGH
   3zujqKvfakcFrKoq/xS/Ccu8/1XlTR+XPODhoFwsq6sySy0aQKDg5A7Kf
   /I1mXgyRKG6RGCHEwkxQ8GJCs+1neH1jmlZwy1FelgQSf0g2gGA3mGVG3
   RsoqjTMD2WMgvoIqmaNZPIDCtEQoE+U5PdFMQyyiRdD389/h9i9mowhC2
   zrj8i9VpclatAUkzkI9xv4RmonLH5PQcRm8chFOzFeat2FlLMATcO69Hg
   w==;
X-CSE-ConnectionGUID: jiFxnF2iTqmTSaDFa6CLMw==
X-CSE-MsgGUID: 2EyO+ocRRtGmgVw2UtTZnA==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="21956992"
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="21956992"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2024 05:26:31 -0700
X-CSE-ConnectionGUID: MEtut0caTjCnH95F1/IdrA==
X-CSE-MsgGUID: k//XfoDeRf+PmINMpogifA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="58638389"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 May 2024 05:26:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 3 May 2024 05:26:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 3 May 2024 05:26:29 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 3 May 2024 05:26:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 3 May 2024 05:26:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mz0abOYexuAJ9T920HJA/wML9LKnrzOzTPuZj5xxkfeiGT1yVI2JAY5w1ShPp/9rZH9+YiKQcIv0zJMRFE+izlneDN7uNRNXf5eUZHJ3215XTI1p7pQYloLvpVTMU7fF34+oah1h3mwSwA16cVbLYdbD0k9nUCveLAvT+2sGtxSvkpUU8FCduWCI2EelVtQB1V/PbX+kxHXXX477mTAlNAnLiasUdDTHA1+yzxKHwl/6d1lVwrUAsBKhuUctXXlCs2iqNjEhAxIEPNe9IDQH2Z6zuRzTTvUTZgewBTzan/x7zYCkpIZhJR95UW4eI+1p8YhYeoqizL3e/Nhu5YOKQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hwy+lNmTALpAYKIE/qdcsPFqtpd14EikBdVf7AdArlA=;
 b=lTtFZ+sl8/AHDqXKzVxlCQ/hCer3mhXqvE5uhS55/d8XgkM9N5X3jQi8a2FYrYeVe7lvTmDBcv4bwqVQn/7FBZpGBfRL3vwIh4zPmeRnwiRW15QdSC2BZutEKBWk46mYxYbHYBxA6OtMo9s0F2ieOQrPbHCP+Jyp8rYVGUcRBBbqri98NSnEio+wJwVIH4F4oHc60EmpRGYDUZ/HXEjDSyNApp8GIXfTzoel9Fj0JkdLYXnzJTAxXYIgdoySpoX6R3RlzTFfvfSgAqSiHaHQ0WSl32J9xby3RDPtLMHybxEPwQB26cxfCC75p9xvxOs3nfDldm9vIpqrqll2ZxbbJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB7055.namprd11.prod.outlook.com (2603:10b6:303:22b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Fri, 3 May
 2024 12:26:26 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.029; Fri, 3 May 2024
 12:26:26 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Topic: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Index: AQHaa8JL7v9VUJLZkEWqE5TMIeieHbGFB4kAgAAPaACAALc+gIAABIUA
Date: Fri, 3 May 2024 12:26:26 +0000
Message-ID: <fb829c94a45f246eac0dd869478e0dcfc965232b.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <17f1c66ae6360b14f175c45aa486f4bdcf6e0a20.1709288433.git.kai.huang@intel.com>
	 <c4f63ccb75dea5f8d62ec0fef928c08e5d4d632e.camel@intel.com>
	 <45eb11ba-8868-4a92-9d02-a33f4279d705@intel.com>
	 <16a8d8dc15b9afd6948a4f3913be568caeff074b.camel@intel.com>
In-Reply-To: <16a8d8dc15b9afd6948a4f3913be568caeff074b.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB7055:EE_
x-ms-office365-filtering-correlation-id: 08cd6a6d-f070-4cd7-0dac-08dc6b6c40d6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?L3ZPdjdXeWRJNUdubWVOV2FkR1VodWlMdDcwUitlTUYrTnNreDhkY3dGaks4?=
 =?utf-8?B?T0Y2MFZZM1FKZTY1dEFpbzd4NW1VUlBpWVFNdERnd25uSW1SVE4xWDNocVo0?=
 =?utf-8?B?OGpTR2w1YlhUNzdPREFneXExOXFuM1lpbDIxQmtJNGhYNll0MldMNE5ZN1VM?=
 =?utf-8?B?a2FrellVMWl0WG9BV3ZWRkhIbVYyeW8wMktEcnJmRHFkM01mN2lrT3hCLzRQ?=
 =?utf-8?B?dDlnZHByNEhUbllOQkJRb3pNZ0gzQjRyQnNRaGJ2RjFRcDMwbGdjVDAzWEFY?=
 =?utf-8?B?b3lyWmw3VGFlYlhOZDcxQVh2c3dObkduaXY0SkkvWnlzWG9JWDQ0Vm11azI2?=
 =?utf-8?B?Y2UxMFFkdHFsd3lYaHd6dWRLd1lZUEFsVGFIbnhGK1A0bWtYMkIzckZzaVBs?=
 =?utf-8?B?VkNPQTlHZWdNdU83dVNETm1wWjd1T2NBT1AxdzBRVWNjRDlNQ0pLY2tVanZh?=
 =?utf-8?B?RXUyaVBKUXRlcW9vVjRXQ1dvb0ZPODE1ZFZEb0txMk5qdElZaUNuR2Z3SE9E?=
 =?utf-8?B?VENYY1paUktCcHVWanpKd0wxcUQzOGFFRHBVeFZYNkxLdnEvbXNnTGJveXZH?=
 =?utf-8?B?Zi9ZYU1HV2orUGw1ZzNRblhWbDN4UUllMzljRm5mY3FtbXFpK2lSRkdLMjFH?=
 =?utf-8?B?Q0llRlozbnc5bEd2M3ZlNWtjeDd4VmxnUHFDaEFhdkZjeGxOODRsVFVCUDUr?=
 =?utf-8?B?ajRDWGl4TGRwdEo0dTVuZnpkVFowY2xrS0VWd250a2lmSTFnNkloZ3gydTU1?=
 =?utf-8?B?UHNZV0h0NFRnanZZQ3ZzZGdqYTE5dVdaSlBvclQ5VWNDK21XUUpTeFZoTUFX?=
 =?utf-8?B?aTY2TkpqTlg5Q0dSSUlueWg0L0V1bW9hMHEvUWlWWEY2bzBQSk5HekNtZS9k?=
 =?utf-8?B?R1NmMTVtOTIvckRWTGx4Z1d5MzlidEV2MjZGWUdTMDlyQ29RMWdvWkVxcmlq?=
 =?utf-8?B?UlA0cStRVFFZV1c4V2Z0VkpPaFhCdTI3ZmpKM3JCVUhySkVBdzl3UTAzVTZj?=
 =?utf-8?B?b0FNY1hwZjEyTHMzNmQ5YXU0WVh2cXNZT3FsRktFb1lnWno2VWlEMFJVUkpT?=
 =?utf-8?B?eXJ2RUwxYWlsMWR4QS9yQjdHT0ZZK0lSUkdLSkxHdnA4ODVMT1BFS1dDNHFK?=
 =?utf-8?B?ZWFUTXdpdXdIQVJOY1ZmbTdaaWpBanRtcUxlUkxkakkxdlB4cFUzWGlpNW5k?=
 =?utf-8?B?ME9idkp1SlcyWGhnMlVQODI3RGNuRVExMEpjY1BvZExtUVN5YWV2Z2ZaVmQr?=
 =?utf-8?B?V0NuZUV5UVZkeFFXTXZOaXFFS2dhb3dHU0NQUHkweUNEbjF5R05KT0RUMnh5?=
 =?utf-8?B?YjAxVUp5V1lqdTZCU2J5S2w4UlM0T1BaSStiOWUxdWEzUXBtck51QWJjVnh6?=
 =?utf-8?B?RHpRT21LVXN5VlJiVmJUaFZ6WEpIU2phRHBLYkV2eXRRYk84RmV4MHQwdmdy?=
 =?utf-8?B?VlRsYTJ4bUhRN2FJTUdhdFlOeC9XT2xpVVlzMW1tMHFCRU9oajFhTG1GaHFY?=
 =?utf-8?B?ZzliRTVJYjNULzZEdUNKSmxsTjJ4U0Rqdmtnek1HenBHeU5aTlNnejllSC9T?=
 =?utf-8?B?eWJTYTE5U0ZLRDNrWlFkdG9SVFppalhXbjlraGZDZWFSeDMzczEwM2cveVdV?=
 =?utf-8?B?VGJVbGNiK0tMWjdrM1FnNEU4d2dqUW5EQi93ME1RditSZ2F3MVM4Z25Ncmdr?=
 =?utf-8?B?NURxZ2VFbitjRk1aSlltMkx6dFpKbjlaa0d4cGE4OG50K3RYeWpRc25nPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEUrTmtFQm5zRlFtZkxaRWFMY0hCNEhMT0Z4dExhUzNQejVpMVU2bjFQRHIx?=
 =?utf-8?B?VUdvc1ZEL1NnTUJhMkdQWVdzMG1XQW1DeU9MR1h3OTZndnJSVFRsRDFrVisz?=
 =?utf-8?B?WTA1OTF3Z0VodUl3MGFlQVFuN2tDOTlob3hQNWh6VFF0K2s2UFJtVktPQ0d0?=
 =?utf-8?B?NDZtaVBMbFphd2tvaHkraEpiMHJaUExkaFdyVE11ajB5d1NBd083SzlFdUNh?=
 =?utf-8?B?MStRTmNFQm9UY2hDa294UFA5bFJodm9DUjFqUEN3Vmh0cW9vNHhMMmtPanE4?=
 =?utf-8?B?cjVMVXZKbmRvUVJaaTBYTml2eGlmTFd3b0l3OXhKN1F0NlhnNkVuN0tEVnAx?=
 =?utf-8?B?Y3ZZbXlZcWNkOUZVNUthZ2tKZFFKdGVCaTJ1YnhsUldTcDZFV2p2Z2QzNVMr?=
 =?utf-8?B?bkVhTXlWd3ErVGJ6elJLQjJGTVdSRHV4YktNejZvdlkxQmxhQTJsWFk1b0lN?=
 =?utf-8?B?bVlqelJnbFRlSURqSmN1RlVMK3FDdGFIekhMZ2FUUXpGbExCR0pYVGZ1TS9w?=
 =?utf-8?B?RmVPcFNudnI3ZHcweGlnRVBiODhjVGcyZFVJanRPR1VvUWg0Uk5VY0pscDQ0?=
 =?utf-8?B?Y09tUnpJOG56OXBqTklEbTlwbnhacWhCcE9wSWgvSjJXdWtGcXd5dENQUm9z?=
 =?utf-8?B?Qk4yOVlMcGdqbm03SkpYb013RU1nV00rQXlMcTNTNWtJdXkya2dibG5lM3E2?=
 =?utf-8?B?Q1c1UkRGcUpNeGgzRy84OElOdGllbGxwWkorbGRFbUtUL1VoNlZkNUxNWFZB?=
 =?utf-8?B?eEJlUDhNMWZNdG5aQVNRKzc0UjdOUEFjN09OanZrdzVUc1RUNWtmamMzQTJK?=
 =?utf-8?B?a2JLVjNlVGpGOXAyRThtZlhmbFE5TU45a2hVQThzdjBFREEwQUcwYzczaStK?=
 =?utf-8?B?RWJvS1FHSUoza0NOMURJbE1nT2tMQUxVcHdGcnpGMzF3MjdiSWh5NUZxbXJH?=
 =?utf-8?B?VHNMMm1HZ1JSUlhnd05SczZha2tOcmVKSUZKaHdlaXBsWDcyczk2MER0b25h?=
 =?utf-8?B?N0N3WlFhaHNodW92RXZ6dkYvTTE1UkhsMFRCeDZzTWk1SFV1N1VHSHdURGpZ?=
 =?utf-8?B?cERWbys2aFl1VGQ1SWVGWU56cVM3T3BGb1hROE8wczJ5bTdEMm1SZG42SHAz?=
 =?utf-8?B?ZmpPYURVY2IyalluZXdvcmlwWDJ6Qk1FTWcrZENhdUhLSmU4MkxpR1lXTmxq?=
 =?utf-8?B?ckZRcE5US3dEUlpCTkQ2TWlJSnpndkJlcFVVYWlMN2FvQ0dLMHVJZytJQi9i?=
 =?utf-8?B?cGlaaXpJQnZHTHlGT1RKWXdmWC9lZVBYZmdlQ3gvSk1uQkc2ZEw1dzhCUWlm?=
 =?utf-8?B?djcxL3FERTVrR0dPNUZYVVZPeHdTZElPRkdCWWduUFJRM2l3NHZoZXp5c1BL?=
 =?utf-8?B?c0xUT21vQUdSaW5pbnd6VFNTYjNwdnlpMFZvajdxTlhqbTl1M09wTUUzK0lB?=
 =?utf-8?B?YkRRMXRkb3lVeklBeElnRFRWMmZZZHJLazBIRnJza0RpZHN0OWJSRGhuQktD?=
 =?utf-8?B?VWJFbWxIL0Y2b0NBZ0tLUEFLcFN5UlRjbUpCdzN5YnVDRTdtcTAzOWplVTFN?=
 =?utf-8?B?aVFTVnQzdFVpM0RhSVAvZGt5SjhMU01TZ2lyVkhTTGZQczgwM0JaOEI0Z2U5?=
 =?utf-8?B?cWtZZHFDUmNiUnhKck1mclNWQUhCQXdUZzNyKzAyb3JnNmo3WUR5bXFrR2hN?=
 =?utf-8?B?ZTBWU2s4MDhVcG1DdzJWRkhEaUcyUDBQWWtrSGtMVnRiSzVidUN6SW9pTGdN?=
 =?utf-8?B?ZlZLQlJDRDk4cFVvdzY0a3RSUzIzVTFNRWFHb3NaVEZjYnJyOFZFeDhMYXZN?=
 =?utf-8?B?T0pxV0x0VkpHT3RMTzhPOVJUTTBzQkYyTVAwRHRlMm9EK2NpWnJaZGdQQ0N1?=
 =?utf-8?B?QXVsV2djbnJERmFmbG5TSkhCdzNqT1paT2RDOGJuVHFSazd5d0JUOU91ZStp?=
 =?utf-8?B?MUEyVzlzQjlpQTBtUzIrUy9qakdRZGY0YmVhelIycWN6UGZUVUIwS2NXRkZG?=
 =?utf-8?B?c3RFMFJ3Sm5OQzZlV3lYSitNb09FenQzNUJ5RzM4VGxucmUzUG9kTW5QV0lJ?=
 =?utf-8?B?OEo4eFI2TFVFMFhlTTMvLy8vVHFIdm1jR05vdmhCYVQ0NGphaDBuZnJmTVM2?=
 =?utf-8?B?RWp0U2t1eU9jNStwQlZMMENTVTdqbm5ZUTdzUUdvdTdQN1p5d0ZkNU9xMWRG?=
 =?utf-8?B?OVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5417C1526778C4CB372D35ADCF912DF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08cd6a6d-f070-4cd7-0dac-08dc6b6c40d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2024 12:26:26.8003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6VwA1h0D7HEiQ6afk8HP1uIbNn1PwTQbGCJchV61hJx+9Bme61F+o1Jk8CDnx/gqmj99Bb3x8oRG88PKLNeStg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7055
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTAzIGF0IDEyOjEwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBGcmksIDIwMjQtMDUtMDMgYXQgMTM6MTQgKzEyMDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4g
DQo+ID4gT24gMy8wNS8yMDI0IDEyOjE5IHBtLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90ZToNCj4g
PiA+IE9uIFNhdCwgMjAyNC0wMy0wMiBhdCAwMDoyMCArMTMwMCwgS2FpIEh1YW5nIHdyb3RlOg0K
PiA+ID4gPiBGb3Igbm93IHRoZSBrZXJuZWwgb25seSByZWFkcyBURE1SIHJlbGF0ZWQgZ2xvYmFs
IG1ldGFkYXRhIGZpZWxkcyBmb3INCj4gPiA+ID4gbW9kdWxlIGluaXRpYWxpemF0aW9uLsKgIEFs
bCB0aGVzZSBmaWVsZHMgYXJlIDE2LWJpdHMsIGFuZCB0aGUga2VybmVsDQo+ID4gPiA+IG9ubHkg
c3VwcG9ydHMgcmVhZGluZyAxNi1iaXRzIGZpZWxkcy4NCj4gPiA+ID4gDQo+ID4gPiA+IEtWTSB3
aWxsIG5lZWQgdG8gcmVhZCBhIGJ1bmNoIG9mIG5vbi1URE1SIHJlbGF0ZWQgbWV0YWRhdGEgdG8g
Y3JlYXRlIGFuZA0KPiA+ID4gPiBydW4gVERYIGd1ZXN0cy7CoCBJdCdzIGVzc2VudGlhbCB0byBw
cm92aWRlIGEgZ2VuZXJpYyBtZXRhZGF0YSByZWFkDQo+ID4gPiA+IGluZnJhc3RydWN0dXJlIHdo
aWNoIHN1cHBvcnRzIHJlYWRpbmcgYWxsIDgvMTYvMzIvNjQgYml0cyBlbGVtZW50IHNpemVzLg0K
PiA+ID4gPiANCj4gPiA+ID4gRXh0ZW5kIHRoZSBtZXRhZGF0YSByZWFkIHRvIHN1cHBvcnQgcmVh
ZGluZyBhbGwgdGhlc2UgZWxlbWVudCBzaXplcy4NCj4gPiA+IA0KPiA+ID4gSXQgbWFrZXMgaXQg
c291bmQgbGlrZSBLVk0gbmVlZHMgOCBiaXQgZmllbGRzLiBJIHRoaW5rIGl0IG9ubHkgbmVlZHMg
MTYgYW5kIDY0Lg0KPiA+ID4gKG5lZWQgdG8gdmVyaWZ5IGZ1bGx5KSBCdXQgdGhlIGNvZGUgdG8g
c3VwcG9ydCB0aG9zZSBjYW4gYmUgc21hbGxlciBpZiBpdCdzDQo+ID4gPiBnZW5lcmljIHRvIGFs
bCBzaXplcy4NCj4gPiA+IA0KPiA+ID4gSXQgbWlnaHQgYmUgd29ydGggbWVudGlvbmluZyB3aGlj
aCBmaWVsZHMgYW5kIHdoeSB0byBtYWtlIGl0IGdlbmVyaWMuIFRvIG1ha2UNCj4gPiA+IHN1cmUg
aXQgZG9lc24ndCBjb21lIG9mZiBhcyBhIHByZW1hdHVyZSBpbXBsZW1lbnRhdGlvbi4NCj4gPiAN
Cj4gPiBIb3cgYWJvdXQ6DQo+ID4gDQo+ID4gRm9yIG5vdyB0aGUga2VybmVsIG9ubHkgcmVhZHMg
VERNUiByZWxhdGVkIGdsb2JhbCBtZXRhZGF0YSBmaWVsZHMgZm9yDQo+ID4gbW9kdWxlIGluaXRp
YWxpemF0aW9uLiAgQWxsIHRoZXNlIGZpZWxkcyBhcmUgMTYtYml0cywgYW5kIHRoZSBrZXJuZWwN
Cj4gPiBvbmx5IHN1cHBvcnRzIHJlYWRpbmcgMTYtYml0cyBmaWVsZHMuDQo+ID4gDQo+ID4gS1ZN
IHdpbGwgbmVlZCB0byByZWFkIGEgYnVuY2ggb2Ygbm9uLVRETVIgcmVsYXRlZCBtZXRhZGF0YSB0
byBjcmVhdGUgYW5kDQo+ID4gcnVuIFREWCBndWVzdHMsIGFuZCBLVk0gd2lsbCBhdCBsZWFzdCBu
ZWVkIHRvIGFkZGl0aW9uYWxseSBiZSBhYmxlIHRvIA0KPiA+IHJlYWQgNjQtYml0IG1ldGFkYXRh
IGZpZWxkcy4NCj4gPiANCj4gPiBGb3IgZXhhbXBsZSwgdGhlIEtWTSB3aWxsIG5lZWQgdG8gcmVh
ZCB0aGUgNjQtYml0IEFUVFJJQlVURVNfRklYRUR7MHwxfSANCj4gPiBmaWVsZHMgdG8gZGV0ZXJt
aW5lIHdoZXRoZXIgYSBwYXJ0aWN1bGFyIGF0dHJpYnV0ZSBpcyBsZWdhbCB3aGVuIA0KPiA+IGNy
ZWF0aW5nIGEgVERYIGd1ZXN0LiAgUGxlYXNlIHNlZSAnZ2xvYmFsX21ldGFkYXRhLmpzb24gaW4g
WzFdIGZvciBtb3JlIA0KPiA+IGluZm9ybWF0aW9uLg0KPiA+IA0KPiA+IFRvIHJlc29sdmUgdGhp
cyBvbmNlIGZvciBhbGwsIGV4dGVuZCB0aGUgZXhpc3RpbmcgbWV0YWRhdGEgcmVhZGluZyBjb2Rl
IA0KPiA+IHRvIHByb3ZpZGUgYSBnZW5lcmljIG1ldGFkYXRhIHJlYWQgaW5mcmFzdHJ1Y3R1cmUg
d2hpY2ggc3VwcG9ydHMgcmVhZGluZyANCj4gPiBhbGwgOC8xNi8zMi82NCBiaXRzIGVsZW1lbnQg
c2l6ZXMuDQo+ID4gDQo+ID4gWzFdIGh0dHBzOi8vY2RyZHYyLmludGVsLmNvbS92MS9kbC9nZXRD
b250ZW50Lzc5NTM4MQ0KPiA+IA0KPiANCj4gQXMgcmVwbGllZCB0byB0aGUgcGF0Y2ggNSwgaWYg
d2Ugd2FudCB0byBvbmx5IGV4cG9ydCBvbmUgQVBJIGJ1dCBtYWtlIHRoZQ0KPiBvdGhlciBhcyBz
dGF0aWMgaW5saW5lLCB3ZSBuZWVkIHRvIGV4cG9ydCB0aGUgb25lIHdoaWNoIHJlYWRzIGEgc2lu
Z2xlDQo+IG1ldGFkYXRhIGZpZWxkLCBhbmQgIG1ha2UgdGhlIG9uZSB3aGljaCByZWFkcyBtdWx0
aXBsZSBhcyBzdGF0aWMgaW5saW5lLg0KPiANCj4gQWZ0ZXIgaW1wbGVtZW50aW5nIGl0LCBpdCB0
dXJucyBvdXQgdGhpcyB3YXkgaXMgcHJvYmFibHkgc2xpZ2h0bHkgYmV0dGVyOg0KPiANCj4gVGhl
IG5ldyBmdW5jdGlvbiB0byByZWFkIHNpbmdsZSBmaWVsZCBjYW4gbm93IGFjdHVhbGx5IHdvcmsg
d2l0aA0KPiAndTgvdTE2L3UzMi91NjQnIGRpcmVjdGx5Og0KPiANCj4gICB1MTYgZmllbGRfaWQx
X3ZhbHVlOw0KPiAgIHU2NCBmaWVsZF9pZDJfdmFsdWU7DQo+ICAgDQo+ICAgcmVhZF9zeXNfbWVk
YXRhX3NpbmdsZShmaWVsZF9pZDEsICZmaWVsZF9pZDFfdmFsdWUpOw0KPiAgIHJlYWRfc3lzX21l
dGFkYV9zaW5nbGUoZmllbGRfaWQyLCAmZmllbGRfaWQyX3ZhbHVlKTsNCj4gDQo+IFBsZWFzZSBo
ZWxwIHRvIHJldmlldyBiZWxvdyB1cGRhdGVkIHBhdGNoPw0KPiANCj4gV2l0aCBpdCwgdGhlIHBh
dGNoIDUgd2lsbCBvbmx5IG5lZWQgdG8gZXhwb3J0IG9uZSBhbmQgdGhlIG90aGVyIGNhbiBiZQ0K
PiBzdGF0aWMgaW5saW5lLg0KPiANCg0KSG1tLi4gU29ycnkgdGhlIHByZXZpb3VzIHJlcGx5IGRp
ZG4ndCBpbmNsdWRlIHRoZSBmdWxsIHBhdGNoIGR1ZSB0byBzb21lDQpjb3B5L3Bhc3RlIGVycm9y
LiAgQmVsb3cgaXMgdGhlIGZ1bGwgcGF0Y2g6DQoNCi0tLS0tLQ0KDQpGb3Igbm93IHRoZSBrZXJu
ZWwgb25seSByZWFkcyBURE1SIHJlbGF0ZWQgZ2xvYmFsIG1ldGFkYXRhIGZpZWxkcyBmb3INCm1v
ZHVsZSBpbml0aWFsaXphdGlvbi4gIEFsbCB0aGVzZSBmaWVsZHMgYXJlIDE2LWJpdHMsIGFuZCB0
aGUga2VybmVsDQpvbmx5IHN1cHBvcnRzIHJlYWRpbmcgMTYtYml0cyBmaWVsZHMuDQoNCktWTSB3
aWxsIG5lZWQgdG8gcmVhZCBhIGJ1bmNoIG9mIG5vbi1URE1SIHJlbGF0ZWQgbWV0YWRhdGEgdG8g
Y3JlYXRlIGFuZA0KcnVuIFREWCBndWVzdHMsIGFuZCBLVk0gd2lsbCBhdCBsZWFzdCBuZWVkIHRv
IGFkZGl0aW9uYWxseSByZWFkIDY0LWJpdA0KbWV0YWRhdGEgZmllbGRzLg0KDQpGb3IgZXhhbXBs
ZSwgdGhlIEtWTSB3aWxsIG5lZWQgdG8gcmVhZCB0aGUgNjQtYml0IEFUVFJJQlVURVNfRklYRUR7
MHwxfQ0KZmllbGRzIHRvIGRldGVybWluZSB3aGV0aGVyIGEgcGFydGljdWxhciBhdHRyaWJ1dGUg
aXMgbGVnYWwgd2hlbg0KY3JlYXRpbmcgYSBURFggZ3Vlc3QuICBQbGVhc2Ugc2VlICdnbG9iYWxf
bWV0YWRhdGEuanNvbiBpbiBbMV0gZm9yIG1vcmUNCmluZm9ybWF0aW9uLg0KDQpUbyByZXNvbHZl
IHRoaXMgb25jZSBmb3IgYWxsLCBleHRlbmQgdGhlIGV4aXN0aW5nIG1ldGFkYXRhIHJlYWRpbmcg
Y29kZQ0KdG8gcHJvdmlkZSBhIGdlbmVyaWMgbWV0YWRhdGEgcmVhZCBpbmZyYXN0cnVjdHVyZSB3
aGljaCBzdXBwb3J0cyByZWFkaW5nDQphbGwgOC8xNi8zMi82NCBiaXRzIGVsZW1lbnQgc2l6ZXMu
DQoNClsxXSBodHRwczovL2NkcmR2Mi5pbnRlbC5jb20vdjEvZGwvZ2V0Q29udGVudC83OTUzODEN
Cg0KU2lnbmVkLW9mZi1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KUmV2aWV3
ZWQtYnk6IEtpcmlsbCBBLiBTaHV0ZW1vdiA8a2lyaWxsLnNodXRlbW92QGxpbnV4LmludGVsLmNv
bT4NCi0tLQ0KIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyB8IDUxICsrKysrKysrKysrKysr
KysrKysrKystLS0tLS0tLS0tLS0tLS0NCiBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmggfCAg
MyArKy0NCiAyIGZpbGVzIGNoYW5nZWQsIDMzIGluc2VydGlvbnMoKyksIDIxIGRlbGV0aW9ucygt
KQ0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYv
dmlydC92bXgvdGR4L3RkeC5jDQppbmRleCBlYjIwOGRhNGZmNjMuLmU4YjhmNmNhNzAyNiAxMDA2
NDQNCi0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KKysrIGIvYXJjaC94ODYvdmly
dC92bXgvdGR4L3RkeC5jDQpAQCAtMjcxLDIzICsyNzEsMjIgQEAgc3RhdGljIGludCByZWFkX3N5
c19tZXRhZGF0YV9maWVsZCh1NjQgZmllbGRfaWQsIHU2NA0KKmRhdGEpDQogICAgICAgIHJldHVy
biAwOw0KIH0NCg0KLXN0YXRpYyBpbnQgcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQxNih1NjQgZmll
bGRfaWQsDQotICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW50IG9mZnNldCwN
Ci0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2b2lkICpzdGJ1ZikNCisvKg0K
KyAqIFJlYWQgYSBzaW5nbGUgZ2xvYmFsIG1ldGFkYXRhIGZpZWxkIGJ5IHRoZSBnaXZlbiBmaWVs
ZCBJRCwgYW5kIGNvcHkNCisgKiB0aGUgZGF0YSBpbnRvIHRoZSBidWYgcHJvdmlkZWQgYnkgdGhl
IGNhbGxlci4gIFRoZSBzaXplIG9mIHRoZSBjb3BpZWQNCisgKiBkYXRhIGlzIGRlY29kZWQgZnJv
bSB0aGUgbWV0YWRhdGEgZmllbGQgSUQuICBUaGUgY2FsbGVyIG11c3QgcHJvdmlkZQ0KKyAqIGVu
b3VnaCBzcGFjZSBmb3IgdGhlIGJ1ZiBhY2NvcmRpbmcgdG8gdGhlIG1ldGFkYXRhIGZpZWxkIElE
Lg0KKyAqLw0KK3N0YXRpYyBpbnQgcmVhZF9zeXNfbWV0YWRhdGFfc2luZ2xlKHU2NCBmaWVsZF9p
ZCwgdm9pZCAqYnVmKQ0KIHsNCi0gICAgICAgdTE2ICpzdF9tZW1iZXIgPSBzdGJ1ZiArIG9mZnNl
dDsNCiAgICAgICAgdTY0IHRtcDsNCiAgICAgICAgaW50IHJldDsNCg0KLSAgICAgICBpZiAoV0FS
Tl9PTl9PTkNFKE1EX0ZJRUxEX0lEX0VMRV9TSVpFX0NPREUoZmllbGRfaWQpICE9DQotICAgICAg
ICAgICAgICAgICAgICAgICBNRF9GSUVMRF9JRF9FTEVfU0laRV8xNkJJVCkpDQotICAgICAgICAg
ICAgICAgcmV0dXJuIC1FSU5WQUw7DQotDQogICAgICAgIHJldCA9IHJlYWRfc3lzX21ldGFkYXRh
X2ZpZWxkKGZpZWxkX2lkLCAmdG1wKTsNCiAgICAgICAgaWYgKHJldCkNCiAgICAgICAgICAgICAg
ICByZXR1cm4gcmV0Ow0KDQotICAgICAgICpzdF9tZW1iZXIgPSB0bXA7DQorICAgICAgIG1lbWNw
eShidWYsICZ0bXAsIE1EX0ZJRUxEX0JZVEVTKGZpZWxkX2lkKSk7DQoNCiAgICAgICAgcmV0dXJu
IDA7DQogfQ0KQEAgLTMwMSw2ICszMDAsMjcgQEAgc3RydWN0IGZpZWxkX21hcHBpbmcgew0KICAg
ICAgICB7IC5maWVsZF9pZCA9IE1EX0ZJRUxEX0lEXyMjX2ZpZWxkX2lkLCAgICAgICAgICBcDQog
ICAgICAgICAgLm9mZnNldCAgID0gb2Zmc2V0b2YoX3N0cnVjdCwgX21lbWJlcikgfQ0KDQorLyoN
CisgKiBSZWFkIG11bHRpcGxlIGdsb2JhbCBtZXRhZGF0YSBmaWVsZHMgaW50byBhIHN0cnVjdHVy
ZSBhY2NvcmRpbmcgdG8gYQ0KKyAqIG1hcHBpbmcgdGFibGUgb2YgbWV0YWRhdGEgZmllbGQgSURz
IHRvIHRoZSBzdHJ1Y3R1cmUgbWVtYmVycy4gIFdoZW4NCisgKiBidWlsZGluZyB0aGUgdGFibGUs
IHRoZSBjYWxsZXIgbXVzdCBtYWtlIHN1cmUgdGhlIHNpemUgb2YgZWFjaA0KKyAqIHN0cnVjdHVy
ZSBtZW1iZXIgbWF0Y2hlcyB0aGUgc2l6ZSBvZiBjb3JyZXNwb25kaW5nIG1ldGFkYXRhIGZpZWxk
Lg0KKyAqLw0KK3N0YXRpYyBpbnQgcmVhZF9zeXNfbWV0YWRhdGFfbXVsdGkoY29uc3Qgc3RydWN0
IGZpZWxkX21hcHBpbmcgKmZpZWxkcywNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgaW50IG5yX2ZpZWxkcywgdm9pZCAqc3RidWYpDQorew0KKyAgICAgICBpbnQgaSwgcmV0Ow0K
Kw0KKyAgICAgICBmb3IgKGkgPSAwOyBpIDwgbnJfZmllbGRzOyBpKyspIHsNCisgICAgICAgICAg
ICAgICByZXQgPSByZWFkX3N5c19tZXRhZGF0YV9zaW5nbGUoZmllbGRzW2ldLmZpZWxkX2lkLA0K
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmaWVsZHNbaV0ub2Zmc2V0ICsg
c3RidWYpOw0KKyAgICAgICAgICAgICAgIGlmIChyZXQpDQorICAgICAgICAgICAgICAgICAgICAg
ICByZXR1cm4gcmV0Ow0KKyAgICAgICB9DQorDQorICAgICAgIHJldHVybiAwOw0KK30NCisNCiAj
ZGVmaW5lIFREX1NZU0lORk9fTUFQX1RETVJfSU5GTyhfZmllbGRfaWQsIF9tZW1iZXIpICAgXA0K
ICAgICAgICBURF9TWVNJTkZPX01BUChfZmllbGRfaWQsIHN0cnVjdCB0ZHhfdGRtcl9zeXNpbmZv
LCBfbWVtYmVyKQ0KDQpAQCAtMzE0LDE5ICszMzQsMTAgQEAgc3RhdGljIGludCBnZXRfdGR4X3Rk
bXJfc3lzaW5mbyhzdHJ1Y3QNCnRkeF90ZG1yX3N5c2luZm8gKnRkbXJfc3lzaW5mbykNCiAgICAg
ICAgICAgICAgICBURF9TWVNJTkZPX01BUF9URE1SX0lORk8oUEFNVF8yTV9FTlRSWV9TSVpFLCAg
IA0KcGFtdF9lbnRyeV9zaXplW1REWF9QU18yTV0pLA0KICAgICAgICAgICAgICAgIFREX1NZU0lO
Rk9fTUFQX1RETVJfSU5GTyhQQU1UXzFHX0VOVFJZX1NJWkUsICAgDQpwYW10X2VudHJ5X3NpemVb
VERYX1BTXzFHXSksDQogICAgICAgIH07DQotICAgICAgIGludCByZXQ7DQotICAgICAgIGludCBp
Ow0KDQogICAgICAgIC8qIFBvcHVsYXRlICd0ZG1yX3N5c2luZm8nIGZpZWxkcyB1c2luZyB0aGUg
bWFwcGluZyBzdHJ1Y3R1cmUNCmFib3ZlOiAqLw0KLSAgICAgICBmb3IgKGkgPSAwOyBpIDwgQVJS
QVlfU0laRShmaWVsZHMpOyBpKyspIHsNCi0gICAgICAgICAgICAgICByZXQgPSByZWFkX3N5c19t
ZXRhZGF0YV9maWVsZDE2KGZpZWxkc1tpXS5maWVsZF9pZCwNCi0gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGZpZWxkc1tpXS5vZmZzZXQsDQotICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB0ZG1yX3N5c2luZm8pOw0KLSAg
ICAgICAgICAgICAgIGlmIChyZXQpDQotICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gcmV0
Ow0KLSAgICAgICB9DQotDQotICAgICAgIHJldHVybiAwOw0KKyAgICAgICByZXR1cm4gcmVhZF9z
eXNfbWV0YWRhdGFfbXVsdGkoZmllbGRzLCBBUlJBWV9TSVpFKGZpZWxkcyksDQorICAgICAgICAg
ICAgICAgICAgICAgICB0ZG1yX3N5c2luZm8pOw0KIH0NCg0KIC8qIENhbGN1bGF0ZSB0aGUgYWN0
dWFsIFRETVIgc2l6ZSAqLw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHgu
aCBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaA0KaW5kZXggYjcwMWY2OTQ4NWQzLi44MTI5
NDM1MTY5NDYgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmgNCisrKyBi
L2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaA0KQEAgLTUzLDcgKzUzLDggQEANCiAjZGVmaW5l
IE1EX0ZJRUxEX0lEX0VMRV9TSVpFX0NPREUoX2ZpZWxkX2lkKSAgIFwNCiAgICAgICAgICAgICAg
ICAoKChfZmllbGRfaWQpICYgR0VOTUFTS19VTEwoMzMsIDMyKSkgPj4gMzIpDQoNCi0jZGVmaW5l
IE1EX0ZJRUxEX0lEX0VMRV9TSVpFXzE2QklUICAgICAxDQorI2RlZmluZSBNRF9GSUVMRF9CWVRF
UyhfZmllbGRfaWQpICAgICAgXA0KKyAgICAgICAgICAgICAgICgxIDw8IE1EX0ZJRUxEX0lEX0VM
RV9TSVpFX0NPREUoX2ZpZWxkX2lkKSkNCg0KIHN0cnVjdCB0ZG1yX3Jlc2VydmVkX2FyZWEgew0K
ICAgICAgICB1NjQgb2Zmc2V0Ow0KLS0gDQoyLjQzLjINCg0KDQo=

