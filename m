Return-Path: <kvm+bounces-12289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C83A88117B
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:10:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E66A91F24365
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18BA53FB97;
	Wed, 20 Mar 2024 12:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NEWYXUZa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665533FBBB;
	Wed, 20 Mar 2024 12:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710936596; cv=fail; b=HeMVMnluMj7OZwSvSkTDReNH1WebKZ20jUO1snbNbeQDGaVyLzkFdLLBj6GrvWNb3FxPBtlDId9eS4rPv4HSNNK/70JPvQ3olTDRvXdoE33uVLdEtkRsq02Qfa+00iOW3zBwoXteKUF5rUnBVEe3zQ/i8Lpv4XXhhy/a1zCaAWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710936596; c=relaxed/simple;
	bh=UC3UZK+wxDVBParVUgcx05qpmB2Bo/s6US8bOXX2AcM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ifkoN+KJf+ulRPdHnQ69Z9TNcmpn1r321TRHR4yueaSjaaVFrrUb7TK+G7gAbdrL3FEr9+lib5/sIoWz6S4orgGHuefPAdQSzA5dFl6kTJZgytNzGO3NdlETEDZHddeGDVaWhRNWGUoAwFu6yOFIwLaYHz0ycjd7w16SzM7xERk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NEWYXUZa; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710936594; x=1742472594;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UC3UZK+wxDVBParVUgcx05qpmB2Bo/s6US8bOXX2AcM=;
  b=NEWYXUZa2vUN7hTdZ831hfs5GM77qLRIrUfr6oagkxKrWaecEWGU9uyK
   RtMlFiWcS4ZPCAUI1r80Ncn4XWvJk6cgmOmJInrBTnAZlkvat+yqh37+x
   gXRQMpkQoYo2Th5ByOqwaxEG9kaZru7wILPCkFThXrr+/q8OYtg+0EcmT
   O+sbGaDQWPfr5+Tjf8tnH6yupG1tyoMdrVwHjUSiblodKoa0qCoXUe6hB
   gYVblZlnm/I0iPURJRD3Psl+KcpOLa6pEvVUmVEYbWgs/GRLmNtxyi+0s
   YiXCnzgjVOU6ZEEDSSeblQySiTC4Ra9X3LpoxqTNaMa2RH78VmW65bvUv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="17309988"
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="17309988"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 05:09:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="14020010"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2024 05:09:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 05:09:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 20 Mar 2024 05:09:51 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 20 Mar 2024 05:09:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKg4+TrsvJdjNwDOK5uugOse4JMpM8p+/nDbCGhEqoyBRegUwU/g2OqUqBWi7odyAQxZDAjnQY+tWpVz93QfMTN7xyClSIgIB+4THhH4bedKDV283byNrHeACbBmnU6/pu8r+sGzvblzzorVIZY7T2qFgBLnTa4bCZGSKtjtGF30a+ADt2F84X4jyG/vGT4YLrGsD0dGbEBXWpdSjsk9RofuuNXOvTuCjPKNdKOdwe2E0HBd1EvKqwA0M8fPwl3LfuDO8pPvAft6rzTCtjX5rRVtXTdwqHSAV+OkB7XpwryKWSUYDbMPgsoVcjsJou52gTYDIll/EKKB+VHa8kDgow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UC3UZK+wxDVBParVUgcx05qpmB2Bo/s6US8bOXX2AcM=;
 b=LtlBApwAHYAq4dFNgXbCuB68NjT9nbew5nYO7N0w1OBbIMcAWdfMXd7HV3As5Ux25WONpjq1obVnlLRNLMoHzggHk/ErwKuKFjeEesQ2og40GhQVPOSbQFTxdD/Fi2os09rEutO3769LJKie87O3+zhHRZGEhorkMHrjDrMc4MkvNE1YqEYiYTgqhmJcmCi1Un3auUFXaccK+4ieEE/Echl1gt6bpXmtwTny/FsLZfxRiqqE3e0RnRepBOLekBJezmfBMiiPLlNKfdhr6QBl0Q5hY0mfEcdFJman7YWrZhrfM71OB/8kJ+sRYHEIiN24YtXx8YaOj8dwVl7evyMq6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB7085.namprd11.prod.outlook.com (2603:10b6:806:2ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.10; Wed, 20 Mar
 2024 12:09:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Wed, 20 Mar 2024
 12:09:47 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Topic: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Index: AQHaaI2wTkj5owjSpkGpHZWdVA22/bE4BueAgAAU+4CAAASeAIAA+18AgAAgSACAABN/gIAHXjsA
Date: Wed, 20 Mar 2024 12:09:47 +0000
Message-ID: <8d79db2af4e0629ad5dea6d8276fc5cda86a890a.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
	 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
	 <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
	 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
	 <ZfR4UHsW_Y1xWFF-@google.com>
	 <ea85f773-b5ef-4cf6-b2bd-2c0e7973a090@intel.com>
	 <ZfSjvwdJqFJhxjth@google.com>
In-Reply-To: <ZfSjvwdJqFJhxjth@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB7085:EE_
x-ms-office365-filtering-correlation-id: bc203797-00a6-4f6b-16e2-08dc48d6a304
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YXkVzYxBC1EgiY/QOABZdGiyKYTBS4kOBOxQOsaUNU8LQioV5vqxwgJtMft5iJpCB2FkpkiucZRSU+nd38/PnyQn5bxPLu2Cj2NTAIgIYq7auJVSnRoXTVDjo5hsuw4XE/owCwNB4ZGiUf0wR8dnLAo4lmol10vubAFDoYDQWx6stm3+9+AdRyVr1oqHsByarBk4YcWiMje5RTo00HNYtBX4WBsqGDY6+hTFmDtINh/+VQow4sTP6xdcqhjR/Mp8eBSilqLcC1sOiFcOQ4k59WCjJkUvgOzUMyHKQHY5Asz2NmxvcC8Ghz3G37V27emS5IYsTWHFa9IIZJBbyKkWQYOJlwEJKg84rkSH9wPywQQ5LGb9HJPbTfIXMcca5ZL3L7Fk7gACEdoHkLFJcyH8uBPPS/dXBN3l+osDXCFlGMiXiCV9Hq9k5l5tQ5yOwkwJfXjRCbUctL2EsCSomKBctMrWJHLgz1R6Lyc5VcBlM3WNEDUVFRm1V0QQQ25PcAYxSg4J5gH+YbzMS2u8XGiNj0b0PmSZ8iTWgtKGIXyCzyMTLofJjq3eO+zl8VrnLzDztYC+8v4DQ2x6gHtuMNcOaNGNdPFf4V+Fjc0bn5K3DBvW/FQJ/6UeZIz4YHjlDVhWD5tbsa2h/nn9BRaFOwm72AaAn7lVuLEUcY7XoHWm1vtoVWTMKGZ/uOi6wKU70ZJ61U/d3ufynKz4BThX7bMhlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0kyckZiYURjOFN3M1VDZkhQUUQwbmY0S3hvbDBTMktPaHlLRXVyR1ZFQTU0?=
 =?utf-8?B?dEdUalhpWUt6SDQvK1RSZ0ZwTUUvbzlseUl0QTNvdzlEWEE1eWE1MTVqbG12?=
 =?utf-8?B?cWtUWmd0NExVNUl0ajBFU1ZhNWFUbjNjWkQrVVZhY1l5Vk1LUUljSW9DUklr?=
 =?utf-8?B?VmJBVEQ3K2Z1MEpCcGF0alo5OFVEYmx5ODdRVEo4NnVhUWpoNnRiR2JHeXhm?=
 =?utf-8?B?cDhUVEljaHpqeTRMdFFLaUw1RTBQU0xHR3NTcU9SOTF3YWhLNDcvZkd0NlY5?=
 =?utf-8?B?Q2I5cTJpTXlHaWl0RSthbHA2WEdGQlllbC9acHY5VWdwQXhFbDNWVUNhMzN3?=
 =?utf-8?B?NFNKV0pYV1J4b1loMHBORDdTZ05wNXAyZjRPeUh1cjlKOFRtcGlIMGFOejN1?=
 =?utf-8?B?RVk4NDByN2VsSlhCQk04dDUrUDVUd0ZpejNFeUYwTThiQVJMZ2pBTHN0SE9m?=
 =?utf-8?B?dGlyY1ljd2hzeUhwUnhmdWJXVXA3R0VxZGluOUthUFM1bnIxZExPWjZCWGg4?=
 =?utf-8?B?RitiWWtDalpoT05OVVdna1FvMmNoa3BGbU44eVhPSnFaa0wyNitpS2ZEaVZU?=
 =?utf-8?B?dlJKTFpwSnN2M2hEN0k5d0xnamZ1WWlpSW5NQ3RYQmNWVjd1UytXVnFlKzJt?=
 =?utf-8?B?dVJqdXhKL3RLYmRNYW9LL2tFNW1Ga2FxU2lIU1cyTkZzbDNhOE8zYWptZ3Iy?=
 =?utf-8?B?U3c2WjZmbkRYaXZjekMvMDVMWTAwV29Jc25oVTM2Z3lWT0FlQWg2dmszSjRp?=
 =?utf-8?B?QUY2cmFSNDNHczh0RGxpZTZuKzlHUG81TWtGQUdHRGd6ZDJTQmZxd3RtYnl5?=
 =?utf-8?B?akxKT2M1S2tENHlTcWpEemg3b1hkWUpLS1lQZ0dISW5uNVNENXZpSnNNeGtC?=
 =?utf-8?B?cnVGWXhITzRkbklIWkNhbVk5clZ0SFFWc1Y2ZTdWTmswOU1NbHNKTGlINVZ1?=
 =?utf-8?B?WlJSM29rNzBPb2toVy9NNUdFM1RUVGJlcUVkVzJoS09pSWJFSlZKbTNnWGU5?=
 =?utf-8?B?L0VwNGZmLzRkeXNHZE1oTGd2NXJOaGpIL2pYQ2xXcjAvT3EzNkloS2lBYVNx?=
 =?utf-8?B?S1dVRWdhWTBBRGNJS2IzVHhiUzBrNXJuQ0F5M25yUUg5WG03TjZYbFFZL2d3?=
 =?utf-8?B?Qy9sa1p5OEhaU3ArR0xjS0VJRnZwVDhWc0JJUXhZR2g0eDA1aU0zMWNiZ05K?=
 =?utf-8?B?cVgrZ1JKQ05CV0lpRVJnazVrdWg5UHBFSnlhY3RjcUxuUEpVQldJUUtZZyt6?=
 =?utf-8?B?ZWovRlJRcUtWYkV5TG9IT0M3SExwVUIyY256bllJQjY2TGtwSGdCcG84YmNK?=
 =?utf-8?B?SG03bjlvRGhmR3hBRGJadTE5MVJBbG01ZUpiY085dmZGZWpDcUIrdElNdVVJ?=
 =?utf-8?B?dUJXcitXNElDdzh6NThSTkdFcDRpREs2OWdmdVVDQ2RLdGtkUnkwMkordno4?=
 =?utf-8?B?UlA4bklrR3FoQ0ZrSzZYdmJWeTEySWZrQnFtQmlsdzFFN2RFNGxsWXM5NzZo?=
 =?utf-8?B?MHdUZGQ3QXZ0Y0JVSC9GRCs3aVBza1Rtd3RxRmlZYUg3UUIwTjczbDArZEtk?=
 =?utf-8?B?cldmQjRBU0RsQTEwVHVoTlQ1a2Q5dGdsMDlqRS9PV1RGQzlJWG5qYzh2OWZZ?=
 =?utf-8?B?R2tISU14K1JLVnFQWmRtMlIxaGpVdFRZSDZqeU12aFdRRjZRT0lwaXdsWFJR?=
 =?utf-8?B?SElqUFFheW9QeWRaZTlHT3ZmY2ExaGZLUzZjQ002SlVqVndVVTZERnoxUU4w?=
 =?utf-8?B?Q0kwT0pEVjBwZWRlaEY0K2NzdWVwd1JpRk1CZ2tWTTRjdk1WNGZvYUplOVQy?=
 =?utf-8?B?ZXgrSGo0UEhaTzZISDgwblFGV1lwUUFUK2lWMkhod2lIZTZXVmMvYnRZN3ZF?=
 =?utf-8?B?aElQTXhPUTRQWWNnZlMxeDFKRnQ2UnRzaWZsSDJFRFZKUTdyZ08wdEhpQlpJ?=
 =?utf-8?B?bnhuL2pVVm0vVERZNjU1akJFc3RRSkhLYzkvby8vayt4K0VoV2FyRUw2aVRa?=
 =?utf-8?B?a0k1NU53WWtvd0RDNS85dDNmZjYvK2J4Lzk5d1pCbjRKZUsrWU5QNVV0R0xm?=
 =?utf-8?B?UmVUNmxMbkRRRnF4Sk92WnVMWnlFaG9WMkFLZWtld3pIbUZZdWljbkI5T2M3?=
 =?utf-8?B?YVNwTTJvMWlmSGRQM3dzVjZqMG04ZGZIWm82TkxZd2Rrb2pSZjFBblIvc1FO?=
 =?utf-8?B?aFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C9B15AF7DEBA64D810C360EB0EC7901@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc203797-00a6-4f6b-16e2-08dc48d6a304
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2024 12:09:47.4676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZhMvF3kPZsNp/jEXxNBpAKOhoZHtojo39VYIa3tELZeeYC+r71mMAbEpa6uvb1qwbuwoJ7R8TNCWdwDCG2HdxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7085
X-OriginatorOrg: intel.com

DQo+IA0KPiB0aGVuIGxvYWRzIGFuZCB6ZXJvcyBhIHRvbiBvZiBtZW1vcnkgKHRkeF9rdm1faHlw
ZXJjYWxsKCkpOg0KPiANCj4gDQpbLi4uXQ0KDQo+IA0KPiBhbmQgdGhlbiB1bnBhY2tzIGFsbCBv
ZiB0aGF0IG1lbW9yeSBiYWNrIGludG8gcmVnaXN0ZXJzLCBhbmQgcmV2ZXJzZXMgdGhhdCBsYXN0
DQo+IHBhcnQgb24gdGhlIHdheSBiYWNrLCAoX190ZGNhbGxfc2F2ZWRfcmV0KCkpOg0KPiANCj4g
DQpbLi4uXQ0KDQo+IA0KPiBJdCdzIGhvbmVzdGx5IHF1aXRlIGFtdXNpbmcsIGJlY2F1c2UgeSdh
bGwgdG9vayBvbmUgd2hhdCBJIHNlZSBhcyBvbmUgb2YgdGhlIGJpZw0KPiBhZHZhbnRhZ2VzIG9m
IFREWCBvdmVyIFNFViAodXNpbmcgcmVnaXN0ZXJzIGluc3RlYWQgb2Ygc2hhcmVkIG1lbW9yeSks
IGFuZCBtYW5hZ2VkDQo+IHRvIGVmZmVjdGl2ZWx5IHR1cm4gaXQgaW50byBhIGRpc2FkdmFudGFn
ZS4NCj4gDQo+IEFnYWluLCBJIGNvbXBsZXRlbHkgdW5kZXJzdGFuZCB0aGUgbWFpbnRlbmFuY2Ug
YW5kIHJvYnVzdG5lc3MgYmVuZWZpdHMsIGJ1dCBJTU8NCj4gdGhlIHBlbmR1bHVtIHN3dW5nIGEg
Yml0IHRvbyBmYXIgaW4gdGhhdCBkaXJlY3Rpb24uDQoNCkhhdmluZyB0byB6ZXJvLWFuZC1pbml0
IHRoZSBzdHJ1Y3R1cmUgYW5kIHN0b3JlIG91dHB1dCByZWdzIHRvIHRoZSBzdHJ1Y3R1cmUgaXMN
CmFuIHVuZm9ydHVuYXRlbHkgYnVyZGVuIGlmIHdlIHdhbnQgdG8gaGF2ZSBhIHNpbmdsZSBBUEkg
X19zZWFtY2FsbCgpIGZvciBhbGwNClNFQU1DQUxMIGxlYWZzLg0KDQpUbyAocHJlY2lzZWx5KSBh
dm9pZCB3cml0aW5nIHRvIHRoZSB1bm5lY2Vzc2FyeSBzdHJ1Y3R1cmUgbWVtYmVycyBiZWZvcmUg
YW5kDQphZnRlciB0aGUgU0VBTUNBTEwgaW5zdHJ1Y3Rpb24sIHdlIG5lZWQgdG8gdXNlIHlvdXIg
b2xkIHdheSB0byBoYXZlIGJ1bmNoIG9mDQptYWNyb3MuICBCdXQgd2UgbWF5IGVuZCB1cCB3aXRo
ICphIGxvdCogbWFjcm9zIGR1ZSB0byBuZWVkaW5nIHRvIGNvdmVyIG5ldw0KKGUuZy4sIGxpdmUg
bWlncmF0aW9uKSBTRUFNQ0FMTHMuDQoNCkJlY2F1c2UgZXNzZW50aWFsbHkgaXQncyBhIGdhbWUg
dG8gaW1wbGVtZW50IHdyYXBwZXJzIGZvciBidW5jaCBvZiBjb21iaW5hdGlvbnMNCm9mIGVhY2gg
aW5kaXZpZHVhbCBpbnB1dC9vdXRwdXQgcmVncy4NCg0KSSBkb24ndCB3YW50IHRvIGp1ZGdlIHdo
aWNoIHdheSBpcyBiZXR0ZXIsIGJ1dCB0byBiZSBob25lc3QgSSB0aGluayBjb21wbGV0ZWx5DQpz
d2l0Y2hpbmcgdG8gdGhlIG9sZCB3YXkgKHVzaW5nIGJ1bmNoIG9mIG1hY3JvcykgaXNuJ3QgYSBy
ZWFsaXN0aWMgb3B0aW9uIGF0DQp0aGlzIHN0YWdlLg0KDQpIb3dldmVyLCBJIHRoaW5rIHdlIG1p
Z2h0IGJlIGFibGUgdG8gY2hhbmdlIC4uLg0KDQogICAgdTY0IF9fc2VhbWNhbGwodTY0IGZuLCBz
dHJ1Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKTsNCg0KLi4uIHRvDQoNCiAgICB1NjQgX19zZWFt
Y2FsbCh1NjQgZm4sIHN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgKmluLA0KCQkJc3RydWN0IHRkeF9t
b2R1bGVfYXJncyAqb3V0KTsNCg0KLi4gc28gdGhhdCB0aGUgYXNzZW1ibHkgY2FuIGFjdHVhbGx5
IHNraXAgInN0b3Jpbmcgb3V0cHV0IHJlZ3MgdG8gdGhlIHN0cnVjdHVyZSINCmlmIHRoZSBTRUFN
Q0FMTCBkb2Vzbid0IHJlYWxseSBoYXZlIGFueSBvdXRwdXQgcmVncyBleGNlcHQgUkFYLg0KDQpJ
IGNhbiB0cnkgdG8gZG8gaWYgeW91IGd1eXMgYmVsaWV2ZSB0aGlzIHNob3VsZCBiZSBkb25lLCBh
bmQgc2hvdWxkIGJlIGRvbmUNCmVhcmxpZXIgdGhhbiBsYXRlciwgYnV0IEkgYW0gbm90IHN1cmUg
X0FOWV8gb3B0aW1pemF0aW9uIGFyb3VuZCBTRUFNQ0FMTCB3aWxsDQpoYXZlIG1lYW5pbmdmdWwg
cGVyZm9ybWFuY2UgaW1wcm92ZW1lbnQuDQo=

