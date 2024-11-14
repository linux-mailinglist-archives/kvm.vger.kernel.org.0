Return-Path: <kvm+bounces-31824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26B399C7F18
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 01:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68965B228DF
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 00:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E27C847C;
	Thu, 14 Nov 2024 00:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BIE8YFOe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC05195;
	Thu, 14 Nov 2024 00:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731542523; cv=fail; b=rT2AOlW7gSSRuOicbgF9pAvxt+RKWJ60WtFZ8gNp7uUGFZwnb+HmoTeDqdcP7oE8pAi3zLZPfc96mPElgXnkqIMSYtMX6L8HeAztVIXbHuvF1026DnlvrzIBtMQ4asjeHpD0py2gmGfzoOZW61jSegikpkZMZcxKhrqQ9e71dyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731542523; c=relaxed/simple;
	bh=CL5dp4iXGWrYU4Ie+qgPm32W7f3N3lqQoNWYrnn2W5Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cEMrPL42feLhtSZWl8p0ubCZk4e+BuKTu77Nsxr039hjCmb8+5CPEiQJj04DaLSx6fz6WVcpkRcTMw8LBpDXe2bOMiH9pFVkEk9ZXZCy9IVhtxTCOsNYTJkSCbjGbULzKjCg1yjPcKNyC7JwQZJTPbNx7ZyeYdjWOwYl0u1knPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BIE8YFOe; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731542522; x=1763078522;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CL5dp4iXGWrYU4Ie+qgPm32W7f3N3lqQoNWYrnn2W5Q=;
  b=BIE8YFOeeEtYlXi2sK2iFkMEaVKN0lwwhbl3N89xwU49OoVbPucJFhB+
   hO20VoVXFofxzoBVIQnQMf2EJEYh6itkcfu+Xe3i8Ju29fYjWROwJ+6RX
   0bp6haXU7VloqGXJr4ZGEwSqfqTnXuK4mF1i9WvCSxWixSzoLpqTrwLQF
   S7D7LvN/yim+NjhD0r09r8+fE9e1TNkKBH0tqjwUHuP7eCkodvhQlf4nE
   uq/VDtkZW2rRMoakv1pyYm1KFJ4kPIUTe6XBFpplYvZFNL6MRdQTlqelb
   z5dnYOxi1VZO4eWE7+F8oeF+ApjeTPhS2vLzLSh2t3upd5y6zoa1GtOHu
   Q==;
X-CSE-ConnectionGUID: Vnr4/2t+RTqLV4mxIw9Vrw==
X-CSE-MsgGUID: jO90oBv0R7+AvgNE9HLq8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11255"; a="56851949"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="56851949"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:01:50 -0800
X-CSE-ConnectionGUID: SXyJLYNTT/+rOdz3oDzUjA==
X-CSE-MsgGUID: Z7ft5eFYT/CfJ7ASdACoAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="88133137"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 16:01:37 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 16:01:37 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 16:01:37 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 16:01:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wfKijS/78WV7ypNec4c+FGBhhGG0EtOB53M4VM6HztjIY1X8SuWJv0N+92VpuhD+5mT8DPBOA3iJ/r2DZtAuCzC0YpHn2MVLkjSYjaqbpUkx2sTLdkDq4kc88tfDEn196qVOqFzdnD3QN6j08oqIb4Of/osUFasjbZ6gLh9vpS2brYeLZZtNQANjJCV6sCrGNUJbogkTYNaI0p4T71tG2UWV8XYVtbOgOop6HOdW3bh+ZBL0KR+vUFwbrOZBgyQY3PbKQLyoxC+6MeoqktwEwRd3SNsL0etHy6kN7U4qaCa/7vn/TvHfokUNaa3LxhAwNgMeUtwztUn92WAUgKyIng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CL5dp4iXGWrYU4Ie+qgPm32W7f3N3lqQoNWYrnn2W5Q=;
 b=siE1M9HW8ObHPgEzgUDlOoN2z7LYzuyJIcLVSVDvpKZSnj7buolKfyHNIRTxo1ww4ZyLoBJqBL0mNk964TehhvwOOzKrZ6oeZd29WgFZI4twMCdZ1siYDCOA1O6S7OPoVK+fSA0cn5kChHxMRdvDYF7GBPfx+CFUI5lZ6jWG03bVWgjlBA0rphpyIV+6Yfwh89ezilQ2lcS01ca1RXpNComCzjfWRYULvZw5o8i+Q8TLgmWetHDzDjUyPH0Zs+ADQfdDf7rq9iN1lh07BE1npmu2Onk1zy+oeiV51HakjJAHoX0ltPNsy+u1LEXU264xIWIDbvqoxGI39oIxKu+0TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BN9PR11MB5243.namprd11.prod.outlook.com (2603:10b6:408:134::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Thu, 14 Nov
 2024 00:01:28 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8158.017; Thu, 14 Nov 2024
 00:01:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Yao,
 Yuan" <yuan.yao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 05/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 KeyID management
Thread-Topic: [PATCH v2 05/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 KeyID management
Thread-Index: AQHbKv4/ilVCjIzJEEmMjntbwQylDrK0J6QAgAHTEIA=
Date: Thu, 14 Nov 2024 00:01:26 +0000
Message-ID: <38b23d1dd98d1530acda545e341352a371af2635.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-6-rick.p.edgecombe@intel.com>
	 <235f3512-9949-4d69-ae43-1280548fd983@intel.com>
In-Reply-To: <235f3512-9949-4d69-ae43-1280548fd983@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BN9PR11MB5243:EE_
x-ms-office365-filtering-correlation-id: 099a3371-b744-48e0-a690-08dd043f7bc4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VzBta2NUZ29UeXZQZE1wSU54Si94TkN0b2VvendIaGo3YnNwbFY5RGV6dEsr?=
 =?utf-8?B?YjNVOUdmYnlCWmFNUlBEWjNVWnFGTGkvUUdPZjZFTy9RbnVpZWxkV2tMTTdB?=
 =?utf-8?B?SzkxVzV4ODBMdGI5OEVqalFtVUd2Q0dYeDBBUjJFYWdFS3ZwSHlpT2xyU3Q4?=
 =?utf-8?B?VFh0bEJNeWh0ZS9Cc2hnWmE5Yi8vdE5IU0NiQjNFS1NGdWNGdFVXOFVUVS81?=
 =?utf-8?B?NUd5eXJRMWZ5dnBqcklsWTFraVJoK2hFdUdwWm44Y0djYy9rQWJCck1PdTlS?=
 =?utf-8?B?VFlCT0pWVGFwOG5DWDZGQ3dLKzhXd3hQTks2RFRaVUh2S3EvN0tjdFFSNFB0?=
 =?utf-8?B?QzhITzczdThBWVliMENYZC9YSXBva0xGZTdYTVNJa0hMMXlKL3BzNE8xeDI0?=
 =?utf-8?B?cTJwbzRVb0hMTjRraGFTa3hhQlFWdkhoM09oUDFOV0doZjJway9EUStiVS9P?=
 =?utf-8?B?TkFSeUdJT3BnaGc4SUJydy8zWG1aZHN6T3E4WFBFa3V0MHFjTW9WOHhGckRk?=
 =?utf-8?B?djVVN09DSWU3SjZUbnlMQ2NFaFFjOXIyWHN6TStZdE9QMEhycEEvZ3MxUUFW?=
 =?utf-8?B?d25YZk1COFlwQS9ndENJdUxJRUNGQ1JlS0wvb2x0aytsTEkyTS81dGZ5OFQy?=
 =?utf-8?B?TnhHd2RVQzhHV0xHcXZHRmdoWFV1U3JNUEFXWmxySHp2aHBZbUhxSURHa01E?=
 =?utf-8?B?T0crbjBubllvekJNNzlvUDEzclVrQnc5L2RnczhZYzQ0V1FnR2ZXRVZMU29t?=
 =?utf-8?B?cUE2QWQ5ZVhvL25xV1BnNm1hallSa3Q0d256SWVEYzJrRldhTE5QUUdMWGxp?=
 =?utf-8?B?VE93Tzd6SDlGaUhTanRtQllPYWdHSDRWRHlidFdrSWNlV0Zmc3F1a3ZFSzhQ?=
 =?utf-8?B?Y2RqKyt2eTJuNGx3NFZtNkppS082WkRhOVBXVzVHUjVJLzJ3SktVc0p4UlFZ?=
 =?utf-8?B?VWpIQzdKTnJhbEFOWUUyVEE3QnMwYmg1V1djWUtUZFNsVmF4V0ZOT25MYlc2?=
 =?utf-8?B?czM1VmJVOWd6Q0l2dkR1NjZPUFQ1K01lOWFSTnpjakxzV0FrVTNRSzdkL2d0?=
 =?utf-8?B?YnpFSUJzcTkxanNTakM0WkdNVW9WbUNrd2hEcGtodHovNW5Va3JKTGF5NURC?=
 =?utf-8?B?K2xjcDMwUWNDWElUaTF0dFo4dGNXakVpaENuZDMvMnYwWTJ4UzdwN2k2MkN5?=
 =?utf-8?B?ZXJlRHJHU2gxNDJFZGMwNi8zT0Uwcy9CWWVZQ243dFA0YmlEWStBSEQxMkd6?=
 =?utf-8?B?aTRUV1Q0UUs2bXVLSVMrelJWM0hmZUczVllEWWJuK0NSMDRDREN6bjlGcnlG?=
 =?utf-8?B?a2JlRGtkOXh2YVRiRHBIcG5TYU1ld1krM2hiaDVLNEZqM2VmL3BnUXNZS01q?=
 =?utf-8?B?Mm55cnlZZGFBU25uRmV5NVJsMGNHUzV2QTRkQ0k2Z1VKd3EyWm9qY0xqTVNK?=
 =?utf-8?B?dDQzRWswYTdRdlpla2dvNmEwajM4UFpjMnc3a1o1YTJGUmx3YkpZemtiSkdR?=
 =?utf-8?B?M1I0OWExYWFEcjlqTDN0NEJhWE00bm90WjJXU2hKNWp5blZWWU45S1Q5OUNH?=
 =?utf-8?B?V2EwcTd1eFFZb1dEcmcrS2RDTzFGbndnS3l0cjVyOUVOQ3ZWdVpyeStENmgx?=
 =?utf-8?B?TWhpbVl0SkhNY2VNWkRrK0g5VVcvMXVGcW5qV2pNV0RrS0FoNitoQk4wS2da?=
 =?utf-8?B?RVJBRWhiVUJPb2ZEaU8xVHh4NXJJQjZzSXliYmJWQTZVL0RqcHBtWDA4bWVF?=
 =?utf-8?B?ZDZWd1E4RXRNVWJjYUdVUk16NE12NHBZU0UvU1Znbmg4ZnFqck53VlZQY3hW?=
 =?utf-8?Q?9wpfD28wYkT4iKCO+IUXLcbkExJWIo7xCdqcw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dG1ORWZtamRHbHh6QXpXbGdTcmRPWUxzdXZmb3BhSmE0QUtuMUozdi9iYXZZ?=
 =?utf-8?B?eE56NGgvdXBha2UxVHNza0lRekdjNVM2NEJpVENpU210UnVnVjdrU0VEaG1R?=
 =?utf-8?B?K3JETDdyc1BUeHpGWHJnTjZXRWt5dDhUYkg3VU1saFR2UTd0dU0yWjZuajhi?=
 =?utf-8?B?K3BXM0FndmRRWUkrMmEzTGVpMHA3SDVRYjdVRjR0OWRIQXl3TUViZ0p5N1Fz?=
 =?utf-8?B?bWFDemF4TGlKZGxEeXZHdFhXd2pESDdUemgvclkvZnVsOTJkOVo2dkFTYzFM?=
 =?utf-8?B?VG5XRU94NUFhRWQzckxiYzh1UDN2QmlsdWZnNjBXVzFBRmM3cUNYcDluU2Ri?=
 =?utf-8?B?OE5qa3l0WjE4NGZvQWdvTGM3R2I1b3dqNTN6eHpKMWVUa1ZMS2FudkVCZ2tQ?=
 =?utf-8?B?RzN6TmhjTzlnekYrMFgwU0g4OHhsMG5VT2szYmVBaWUrVzZwV0pMR3NBbEFx?=
 =?utf-8?B?YnFEWWY3bVByUlROeENvdURuTHI0ZDFsanc4TUhmTllDaFUwaVZ6SGVvWEhM?=
 =?utf-8?B?d1dSVytySktGakhEcTJoQWdmK3FHWWtZc3JyVnlNeFBXbUFPQ2xoT0d3VWRp?=
 =?utf-8?B?Q0RURzk3UlFhcFNDdlBxeEV3ckdjM1BiWDJNdDFmWUs3ZlNOb1V1dXYxVDM3?=
 =?utf-8?B?aWxvMlpEeWM3aitkL21icFplTzVYNlNreXFkcC82dUFGZVgySmNlclFWVFAw?=
 =?utf-8?B?ZTZMUW1MRXdRMUJCOTR1YXR5bWIvWS9HYStwRDB3bVdZamdPUTg5Y2VoSkx3?=
 =?utf-8?B?TWpySU93WlFlT1FIZDF3cWNhR3ZhTEhrVWpEdXZldHVxUTUxN04xanFrZkFq?=
 =?utf-8?B?REczYU5YYmlJSUlFd0hHOG9TbGxTOGllUzFFZTZzWGtFak51MWppc051Um9D?=
 =?utf-8?B?aDA5S2FRNFZhTEt5VjY5WDVUVG5CQ29nNUU5M2tkOWZqMytjNDFsb1BnMmtX?=
 =?utf-8?B?U09GVFl1WFBLSUdCZkZtcGdScjJkZ2tQWDJ1TGVpUVJvOVRMYU1leU1kSWF4?=
 =?utf-8?B?S09ZclNYS2tpUVdSNFI4MFhsa29VOUNPTkdyUS9hK3M3TG9veUFlV21ubTFt?=
 =?utf-8?B?OC9laW92elh4TUNvZ1hEMnVUWXNhWWU2RXlwdmZ4bXRGZzJCU3B0VzQzU3l3?=
 =?utf-8?B?V0tjbFMwRXdIN3c1M0dJcHF6NTBQZytMN2hJdFRlcGhJZncycXJSb0p5T3FT?=
 =?utf-8?B?emJMMVV6VmlWVlNTZHJOaGN0eHg0WnFXdHV5Vjk3WmdtL3NFM3VLRW9LLzlw?=
 =?utf-8?B?Ni9VNzNrVXVoZml0SWpWVnFOZ0piMFplWmhuSjBVOURtNUljQTVLd0ZScUxT?=
 =?utf-8?B?VUpmL2Q4Wno0YTYvOUpXZDlhMnAwQkVkOVVFcDBQU1VVVy9MZ1Q4bXk5WkF2?=
 =?utf-8?B?R3RIcjRSNXJ6SmVMNnZoSHRKR0szSm9jU2dVMTNVZGxUR2IvMkpEdzd6a2NE?=
 =?utf-8?B?V2FYQUpkZmNmVjBWRUxPUFNucHJzNnJyRU9RZ3pScFlCZFU1WmZYTjFkWHZI?=
 =?utf-8?B?NVJsb0R4akNqMG5zMlcwK0xvMWJYWjlwWk5kYVRQT09yYkkrQXd3ZUwvY1Jr?=
 =?utf-8?B?NDVYRld4NlVIbHIrYzFUenNITm56WVg3VkFCUmlPczUvNUdhMUVYR1N2MnU2?=
 =?utf-8?B?Qk9zTzBwbDZhaGVGK01RVFFVOWxVM2xGTElxNC9rUXpYb3V4Mmk3UGhmcUd1?=
 =?utf-8?B?bmRtRnlLd3h5ejhKOGtJKzI2WmExYkNtUGtuTjdBMDJDb0pUeXJ1aVVXTEM2?=
 =?utf-8?B?WHVDK2MvSGNNT052VnZ4Y0RPNE4vTDV0U1R4VmxubDg1NkhWeGVJVFQ5NGV1?=
 =?utf-8?B?bHNBdWFKS3ZoZ0ltQjBZTXVUL09SbHl4aE15Vzlsb3lXa3JtM3c1Z2FwaTJG?=
 =?utf-8?B?bENjM2Y1elJreVpkb1N6RlZpRzdGaGlYMnFMdEt4aEY2aWRkVTBmdFdwbnlm?=
 =?utf-8?B?UDFXcC9KQmpzL0VBdjZmZi82OTl5STZ1dVVpSUdDQktvUnpCdkhKWE5RMFhZ?=
 =?utf-8?B?WndRQzJjMHhML0dXN3ltSEY4aTFEd2tLK1Z5bTRKdlI4MUVoaElJbmRSRUMv?=
 =?utf-8?B?NDhCb2xMRVVSQktSdmNIWEJuVFY3NWVZVHREMEpPYzJYNHJ1cFJKV2ZHYSt6?=
 =?utf-8?B?Z2FzRHJtTHZMVEtnbXl3eG5LQnU3aDBMc3hCdVY2MFE1YWUvSW1QeFBFazhG?=
 =?utf-8?B?MWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <381793AE384053498CAFE700C76611A0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 099a3371-b744-48e0-a690-08dd043f7bc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2024 00:01:26.2354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bfvgxQiAMXDw9vTI88g/j79gEbMBx9Ks1pPTtpLKacfzivsLLHYD4045xmmlC8tHmyckv5U4zzH0U7KjYp9MXUnaJSFcOVqy9/t3WD1iC9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5243
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTExLTEyIGF0IDEyOjA5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTAvMzAvMjQgMTI6MDAsIFJpY2sgRWRnZWNvbWJlIHdyb3RlOg0KPiA+IEZyb206IElzYWt1
IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+ID4gDQo+ID4gSW50ZWwgVERY
IHByb3RlY3RzIGd1ZXN0IFZNcyBmcm9tIG1hbGljaW91cyBob3N0IGFuZCBjZXJ0YWluIHBoeXNp
Y2FsDQo+ID4gYXR0YWNrcy4gUHJlLVREWCBJbnRlbCBoYXJkd2FyZSBoYXMgc3VwcG9ydCBmb3Ig
YSBtZW1vcnkgZW5jcnlwdGlvbg0KPiA+IGFyY2hpdGVjdHVyZSBjYWxsZWQgTUstVE1FLCB3aGlj
aCByZXB1cnBvc2VzIHNldmVyYWwgaGlnaCBiaXRzIG9mDQo+ID4gcGh5c2ljYWwgYWRkcmVzcyBh
cyAiS2V5SUQiLiBURFggZW5kcyB1cCB3aXRoIHJlc2VydmluZyBhIHN1Yi1yYW5nZSBvZg0KPiA+
IE1LLVRNRSBLZXlJRHMgYXMgIlREWCBwcml2YXRlIEtleUlEcyIuDQo+IA0KPiBUaGUgY2hhbmdl
bG9nIHRoZXJlIHdhcyBncmVhdC7CoCBJdCByZWFkIG15IG1pbmQgYmVjYXVzZSBJIHdhcyB3b25k
ZXJpbmcNCj4gd2h5IHNvbWUgb2YgdGhlIG9wZXJhdGlvbnMgZGlkbid0IGdldCBjb21iaW5lZCBp
biBoZWxwZXIgZnVuY3Rpb25zIHdoaWNoDQo+IGNvdWxkIGJlIGV4cG9ydGVkLg0KPiANCj4gQWNr
ZWQtYnk6IERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBsaW51eC5pbnRlbC5jb20+DQoNClRoYW5r
cywgSSdsbCBtYWtlIHRoZSB1NjQgcmVtb3ZhbCBjaGFuZ2VzIHRvIHRoaXMgb25lIGFuZCBsZWF2
ZSB0aGUgYWNrLg0K

