Return-Path: <kvm+bounces-19952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A21E90E753
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:52:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D4DD1C21384
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 09:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D826F81205;
	Wed, 19 Jun 2024 09:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MQSETKMY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D392A54784;
	Wed, 19 Jun 2024 09:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718790722; cv=fail; b=sADYlhi2tdEY1JdAiNtiFAc9ukjyudwd9dSlg9YmiGHgRyUtVxa6yKzfsFYb670fqy/dn6rVbTOTxp6QZywOCgRVMq6OxxUfjMC0hkvRg1P8hfsQ2QE6O5fQ3Q6O9TnOqXdIbCIHvAMyBJOeJh1qhVo9jAO+l/bwbX2R4/EoAVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718790722; c=relaxed/simple;
	bh=kAL4YQ7baZZsWj2C1px2EuS3a5OymyWpr5uW6fk4Ufs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LyxIRMJIgSFJa6EJrePG2YH+xNF3D4sTssEy5zPRHkANEFjt5Agzc5zgaGeGNz+WilSP9cnfqSeRE9XvrfSuURd1hI6sMaKojc+UJNY5cEu9SoRSwSVJyzTnyU3ZK550mRpOGlRsROAK56dG4mYaAz6dySHCT2WJBsbHzaLGwzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MQSETKMY; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718790720; x=1750326720;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kAL4YQ7baZZsWj2C1px2EuS3a5OymyWpr5uW6fk4Ufs=;
  b=MQSETKMYudVqW3wzYQ4hXBNQSpzcn7qUBqZQUrGrIM7eV6Ji2Rnl07wc
   oMRl2fFnOpOBtiRr4pfcgdpFqv25wrgTHU5vSgXHbAK4uyR3IUTuGQLSu
   6FntVUoDdLVh2TzGyjpwyrZK16aHELWVXyJTgXVCSng/QBzK4tNqEhuLj
   2MgmvW34hZuowaElx8Y/PLJIEYTLYtxoZSvOs86dA7wiV9jegAu/jFnqu
   GYTFUQIF+ogWr12rurQazALz8eX2cDa55AWLF0GVrK5CNhJslcoEDqRBp
   3CT/AtAFSFJcw/73/sOmaDG04trgvlyWUuesyk2OubCgV1Jy0UD7lYuxv
   g==;
X-CSE-ConnectionGUID: XBYng4dSR2Sj8G67f2g0yQ==
X-CSE-MsgGUID: l8bDGxyzQke8sSrp6Xyk0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="26347198"
X-IronPort-AV: E=Sophos;i="6.08,250,1712646000"; 
   d="scan'208";a="26347198"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 02:51:59 -0700
X-CSE-ConnectionGUID: 8g9FhkuySkeFnwyfSa++6Q==
X-CSE-MsgGUID: imhYWSbAS/2bQE5R60qMYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,250,1712646000"; 
   d="scan'208";a="46774104"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jun 2024 02:51:59 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 19 Jun 2024 02:51:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 19 Jun 2024 02:51:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 19 Jun 2024 02:51:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NHEJO4r5wpmTeb/K8GF5XjNG+hSc3IZLYlJ61ncsERefKEDZD+8fzodNFL+CmMd8dCE6nEquqeeYxe6Ipwf2pMrg0oWl/xHGLh54em+ck82diWAZzGH2EaVyS9NY2OSSGZ37rISdNaOEpVRHKXx/ZSuIYELS0rExjRIR/81usslacdRHBMl53salrhp22HAaUFpmDkl5byFkRKo7953lh6qjrPBd5yq+u3EWdaPCMMYdfhZ9rvjv1HiRt2spDAiJ/mtGp5/+BbzZqvq2d1S+cPk1fGzwbsOUgb5bftmiN6/y4bXwsCZ4sjBacKF9JZz6TjMV+iprbIhiw+zLYr9+3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kAL4YQ7baZZsWj2C1px2EuS3a5OymyWpr5uW6fk4Ufs=;
 b=a6Ve2yv5JHpZLQ19YMKMcCFUUvwkDSy3IOJiL++/a0dQc3lyzCTTmkpdMpNbFr9eK11sbiKx53sKAQSXEbagp8bZkmc8eLoTuv4cTtI0H5nYPffcbFulB5TyEEz87SBw6ARMDv9VLbwivV7eENOHfZDheznHMnN3uC9vZ1AOT8yDoyIdX83u9tMr6Tzxwhlbz7vYsit5IZ5/k93D4lMIQO18KChW9oFFu2v9Vk64D6kjqfiyG70KfhecwXVADdZfn1EFv86OZMHVfN5BLKx4zK8DmQ/p/ACOLpHcaLZGOFegTHuqd7sKAaPRMmXNeE/FXQANgMAkhXzBP0APyNsYdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7034.namprd11.prod.outlook.com (2603:10b6:930:52::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.33; Wed, 19 Jun
 2024 09:51:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7677.030; Wed, 19 Jun 2024
 09:51:50 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "seanjc@google.com" <seanjc@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 3/9] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Topic: [PATCH 3/9] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Index: AQHav+T8hZXUtwqQLUeTYP/hMhfNE7HOvxCAgAAdwAA=
Date: Wed, 19 Jun 2024 09:51:50 +0000
Message-ID: <3bf4682d487878c1a3701c64c7e2f1d04d7d1331.camel@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
	 <210f7747058e01c4d2ed683660a4cb18c5d88440.1718538552.git.kai.huang@intel.com>
	 <dea78e58-a4b5-48ee-8c99-213dd5ec9b8f@suse.com>
In-Reply-To: <dea78e58-a4b5-48ee-8c99-213dd5ec9b8f@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7034:EE_
x-ms-office365-filtering-correlation-id: 1e9b8354-1711-4d1f-bc16-08dc90457108
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|1800799021|366013|7416011|376011|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?TTJyNXY5TlZqbDU0NXZPVHM4TU02cFJKOS9QVi9pTlQ4OUxlTTJNTi9TUWVz?=
 =?utf-8?B?ajJhdGhpQU9tQitFNlVPZ3RPTjROVExlRG12OSt1aDN3RHhxTW0zbWVvWVM5?=
 =?utf-8?B?Ly9OaFBsSmx2YmZKNU05ZGpKaVQzR2xGRENtMTlzWHVRcDlyNDNyeERpMkZl?=
 =?utf-8?B?VUNlMmE3d2l4NjhNKy9ocHFrWE9PZkhQSW9QVXlJS2hUTTRkL1RRd1c5K0lq?=
 =?utf-8?B?dVNSemszcWhQdzZWMFIzQ2JsejJKSjVYNk4zZXJEamJKNTc1cnZzdk10SkFZ?=
 =?utf-8?B?SEVFOUR4N0VJZlpkdmxmSWc3YkFncFhlR1VJOTh4Und2dldXOGlsckVwenFU?=
 =?utf-8?B?Wk5JZG9ycE5KQUVtcTlMc2pNM0RBSTVqM0hMUkZFTHdxSUdDTGpBQytRMzJn?=
 =?utf-8?B?bGp4V2JuYkJrQjRrVUxobGtReG9ROFdacVR4K3V6UzRLUEFFWFJxdHRBUXMy?=
 =?utf-8?B?MTV6Q0xuVUpSSXdXb1ZoRFl2V2o5QTdGcWVtS1U3YXl0VElDam1DVFhFNnJw?=
 =?utf-8?B?azdZeG03NS9vYXdZS2xDMXJBNDNaeVdlck8vcStEMnI0WWRUNm4wSURIaG5Z?=
 =?utf-8?B?bC9DMUx3cDM3Ui9hNHpsN3dEMWQrV0J4VVdDQnhqTVdvb0dFOVBhbFU3N1Mw?=
 =?utf-8?B?VlROVkliOGpYeTBvUjdLYWxVT3VmRjVLc0tkOUZ3RnlzQ3pROHkyeHZESTRv?=
 =?utf-8?B?V1kvMkgvWXBobm9XOVAwb0RuZm9sVXdHd2ltL2s0UmwxL0FNS3FvNVRRTW9C?=
 =?utf-8?B?SW1HM3FsYW9Vc3BhL2RSSFVGSkxWY0UzS2VnZnBrQXNZNGhIWnF2S1VYdzBU?=
 =?utf-8?B?VHJ4T2Yrd0F1NEdTU3dITDlwbVo0UytDZDlSdmhGMUxyQ25qSURoVUpvZWVz?=
 =?utf-8?B?c0lIQ2FFeXNvY1l6UUoweDF4MUZCa3JKNzhwY0NvaGg0amVnT2dPVzJVamlE?=
 =?utf-8?B?M3dBaWpnZUVRNEFzREJYTStVOVJVMHU2TXN6bWd5WDZRekdpRG54OGFUeUV4?=
 =?utf-8?B?dnJDWDJIbExuRTZXNGRuWTE1b1FIbDh4akVQSmVJQ2ZVdlJwdnAycHJOY3BJ?=
 =?utf-8?B?RHdnbnh0d0dObDh1K3c2QmV0SlVoWU55WittQkRiczVxNFZ4K1BWemZaNjJu?=
 =?utf-8?B?RlRtOVdKOGcwcUdackpFdmhMOXlnSDEveDloZnBJMmIxNm5BamN5anNhSkRu?=
 =?utf-8?B?NXQ2aFRvak9NWUs5bmU0UENULzJpQzlkOUozT2hhd2JyaUpVSWNEU00yd2Vl?=
 =?utf-8?B?K1ZEbU9qUGFRSURKSElsWDZVS1pVaHg1S3pTN3VhZWxLbXFQc0dQaG9TbHJa?=
 =?utf-8?B?NTRpUGdJcWt0TWgzTU0vbDIySkVtanFzOHl6RGdXTUplMmNxbDlhQ3MycXlF?=
 =?utf-8?B?Y3JSSjJRR0w4UkZjTm05UjFFbHVzcGpFQmthRU44cFJRdWJ2VGgzanZCV0Vq?=
 =?utf-8?B?T2l4Rk1DclZhOWVNZTljUWdpVzlUWFd4K3dsejZMMVp6ZGt1UUZuNG5JOStN?=
 =?utf-8?B?VStsU0Fvb00vZ3pUd0lpV1lLTnZzSWZCZzNIdnkwQXZxbHYvM2lldHpMS3dp?=
 =?utf-8?B?ejdET29GRVc1Tm5rYkNJcUNJQUJDWVJWOUNxTitNVFpONUFSNFRFcCtTQjVM?=
 =?utf-8?B?Q1RuWGwvUUFLQWkwb3VJUFc0K3FnajRYNVFlemVpWXpqS3ZyT2o3a0dva1Zy?=
 =?utf-8?B?YVBjZ2tzMmltNVV0cHM2TWlmOUdrL2FLTVFWc0VDWTB5Mm9XcktMOU5xbjRO?=
 =?utf-8?B?N3kycFk4Tk9IblNRZk9HWGMreU1Wa21YTnl5WDBJNWF1Y0lTWkVvMkcveG55?=
 =?utf-8?Q?hcDZp50wzZwOZE+BeJgwtydElT+t3jk57xhLw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(7416011)(376011)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3k4Mml3Z0cwQUhIWDJ2SG1yOS9mczk0Zm1GVE13WDNKTmdTMVYxLzVvZzdS?=
 =?utf-8?B?UnBZQ21ZVHpFZXhqOGZ1K1VGbXpxVVpLMUs0M0FMc24rUHVNU3JXSXlNTTIy?=
 =?utf-8?B?TS96SWNsNndWZHk0aCt2TjV4ZkhNNi9UZHJxV1UvNVJYT2d4STM1RHlrNzVI?=
 =?utf-8?B?OWZ2TUIzOFlCejlFUU1oL3hsWUxQQnhBRlppNzljc1BkdFFxT1NaVHoxT1N1?=
 =?utf-8?B?RkxTaDdPV1UrdHdoSFhYVzFpMmRDK0o0ekZKM3lEaDZwYXJnbXhkcm1hSndy?=
 =?utf-8?B?SzZpd0VWKzFXOVVMTFRCV2QwVG02TDI4eVBDYjQxQ0dhZUdweEdGbVBqNll1?=
 =?utf-8?B?bmplSW5RK2hadzE1OGdvZm5yWGlWNERxY01GWXZ2c1FtK3c1a1BnQVQ0Tkhm?=
 =?utf-8?B?bDljSGw3cVVOaE44ZnZKOVB6WllKK3ZvTWNQUHZVMDB3bEtrd0RuSE1va0dP?=
 =?utf-8?B?dDluRDRuVlBxVEU0TkVNblVrMWpnTS8rM2EvSlhYU3FHYTRsKzI2d1BZUmU0?=
 =?utf-8?B?UlVsRVNsTHVITHZoQ2RMOFhLeWhCQkRuSzBZTHBJeUVKVzRtdDdPK0tqUFFW?=
 =?utf-8?B?UVVSZ0FVT1diVVJ5bmErNmcyVlN6d2tSNExVeG9FQmlmQTZmUldtSlpQL04y?=
 =?utf-8?B?RWZNTXdBT05BQk8zRHBudFlXVEgwaEVxMjRLRnBnTW9rYUNESE9XNFpqUmJK?=
 =?utf-8?B?dEExNXBGQzZtR29qRG9ZS1RubTgxYVluNkhWaDZmNkFXcEQrMXZvUlFseTUx?=
 =?utf-8?B?OENXSEtFR3dqOUxHQ2RNblprb0YwbFRTWHpiNE9hT254aW1iRlhFVlpuRWxm?=
 =?utf-8?B?RmxjSWlQZlpOZXJ5aHFWTE9QYTBCbW1zRjJzbkR2Ukl6ZEZTckpJcUdEZzNP?=
 =?utf-8?B?NzVtN1h2TDRTZllpamcwVWVsdFhEdEp6T2NpTUVXUy80Y2ZYNGY3djR4MGpu?=
 =?utf-8?B?TnptWWtPanI1eVNBK0s1V0NFa1lLNHRWY1ZZWFRlVnRNbE9Ja3NWOFRFVTB2?=
 =?utf-8?B?V0x1ZUpsZVFCRjVhQUZobGlUMTY1SkN3aWpPczZQYXA4T20zMnhuSzdzaDhK?=
 =?utf-8?B?QWRBSjBPOWRXV0pmcjJoMmFNVDlkcnNyTExzRTMrR3g3b09COHBEU3NncThu?=
 =?utf-8?B?Y0ZCd3VqdjllTy9XdEFBY2d2ZVppaW9wdGFrWHA0YmlIeGFPZityQkRKWUJn?=
 =?utf-8?B?ZUlrMUxYZWpQY1lFT1FxRHhWdldFV3hZZGMvK1VoaXYrNHdaZWZWMVo5SHk0?=
 =?utf-8?B?eEIwaGI5aWlHYnc4M3FJbWhaSDhXZDVyeDloNmprWDhFZFQ4LzVnOWM5MWlM?=
 =?utf-8?B?MkpYek5JeWZhVysyTkpvUHVlbDgrRHZzbE12aFd4dVhuTmpwWFJIekd6ZUww?=
 =?utf-8?B?OGQ0a21OQ3oyaTdhSm05MEZuYm0rbk9xaUMrZEZGbzVvejRsK2luNUlaMVo0?=
 =?utf-8?B?QTNCSjJXa0t1RmJZY3Rsc3FhTWM5UElFamVtaVBvRmxjbkZld0ZXdE84R2FG?=
 =?utf-8?B?SUNNTzBEWjZ0RWVydGsyNHB1T2dVdURERW5yOTZ3OVJ1RDBvd1h6OERaNktT?=
 =?utf-8?B?dXE2VUZvcVc1MklLY0hHc3MxQzdPWnNKMFFYZmZMOTFhNEpmNkhDYkxCLy9G?=
 =?utf-8?B?ZTFzckRhWlNzN2xMeC9zNzZHdDJndVlTblUxL3U5MVM2d0MrK1RRb0VpZHpY?=
 =?utf-8?B?cmFnQnFkTFdSMlRrR1ArRFRlSXpoU05JOS9OVzJpUVBqWDFEa2FIWURzV1Rn?=
 =?utf-8?B?WGRsL3lrcnJ1L1pVS1hZSWptQlBVWWFpS3dod29oWUJYRGRPdnBUWkFPOEpx?=
 =?utf-8?B?cFRIVG4wbjRNN2hiMm1xNkoxOXJPOW9CN2dYK0tGdGFSMU51L1l6bi9wZDVM?=
 =?utf-8?B?Z2V5QVkwOGNLem9tN2FKRTJpNFVpZFFpOEJUcSsxbmxCUnhEOXRSVGh1TERz?=
 =?utf-8?B?VW5kME9JN2pWcnN4OXVXc3BtbDVRQVlzOEpPV3R4Z09zTGJWTDFFYWRtaUZl?=
 =?utf-8?B?dERNM1Z4enIxZUh0a21sZ0VLU1RKSUs0TE9veVNtZXJIc1ZhY1IvZ2swbldX?=
 =?utf-8?B?ckxITFBZT3RTOUMybE9WWVRpeFRDeG9ENnBZbjNsd21nOEI5bGpQR01mWkc0?=
 =?utf-8?B?em9kUE1aWldKaHNlRURjWlc3dlByeEE1bXlOb0c2L2Q3dTRjUTA4Zk5PSzZr?=
 =?utf-8?B?SkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC6EB963F7484941AB07AF905DB60B75@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9b8354-1711-4d1f-bc16-08dc90457108
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2024 09:51:50.3121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AcPkpwkkyqZbdnV3QsLS8eQi6EoSMqSb76BRGJTxXQirMubnIGsqDgjnnBtH5S3AnoZXKrjLvjap21//8AMkdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7034
X-OriginatorOrg: intel.com

DQo+ID4gICANCj4gPiAtc3RhdGljIGludCByZWFkX3N5c19tZXRhZGF0YV9maWVsZDE2KHU2NCBm
aWVsZF9pZCwNCj4gPiAtCQkJCSAgICAgaW50IG9mZnNldCwNCj4gPiAtCQkJCSAgICAgdm9pZCAq
c3RidWYpDQo+ID4gKy8qDQo+ID4gKyAqIFJlYWQgb25lIGdsb2JhbCBtZXRhZGF0YSBmaWVsZCBh
bmQgc3RvcmUgdGhlIGRhdGEgdG8gYSBsb2NhdGlvbiBvZiBhDQo+ID4gKyAqIGdpdmVuIGJ1ZmZl
ciBzcGVjaWZpZWQgYnkgdGhlIG9mZnNldCBhbmQgc2l6ZSAoaW4gYnl0ZXMpLg0KPiA+ICsgKi8N
Cj4gPiArc3RhdGljIGludCBzdGJ1Zl9yZWFkX3N5c21kX2ZpZWxkKHU2NCBmaWVsZF9pZCwgdm9p
ZCAqc3RidWYsIGludCBvZmZzZXQsDQo+ID4gKwkJCQkgIGludCBieXRlcykNCj4gDQo+IEFjdHVh
bGx5IEkgdGhpbmsgb3BlbmNvZGluZyByZWFkX3N5c19tZXRhZGF0YV9maWVsZCBpbiANCj4gc3Ri
dWZfcmVhZF9zeXNtZF9maWVsZCBhbmQgbGVhdmluZyB0aGUgZnVuY3Rpb24gbmFtZWQgYXMNCj4g
cmVhZF9zeXNfbWV0YWRhdGFfZmllbGQgd291bGQgYmUgYmVzdC4gVGhlIG5ldyBmdW5jdGlvbiBp
cyBzdGlsbCB2ZXJ5IA0KPiBzaG9ydCBhbmQgbGluZWFyLg0KDQpJIGFtIG5vdCBzdXJlIHdoeSBp
dCBpcyBiZXR0ZXIuICBJTUhPIGhhdmluZyBhIHdyYXBwZXIgZnVuY3Rpb24gb2YgYQ0KU0VBTUNB
TEwgbGVhZiwgcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoKSBmb3IgVERILlNZUy5SRCBpbiB0aGlz
IGNhc2UsDQppc24ndCBhIGJhZCBpZGVhLiAgVG8gbWUgaXQgaXMgZXZlbiBiZXR0ZXIgYXMgaXQg
aXMgY2xlYXJlciB0byBtZS4NCg0KSSBjYW4gc2VlIHlvdSBkb24ndCBsaWtlIHRoZSAic3RidWYi
IHByZWZpeCwgc28gd2UgY2FuIGNvbnNpZGVyIHRvIHJlbW92ZQ0KaXQsIGJ1dCBmb3Igbm93IEkn
ZCB3YWl0IGZvciBzb21lIG1vcmUgdGltZSB0byBzZWUgd2hldGhlciBvdGhlciBwZW9wbGUNCmFs
c28gaGF2ZSBjb21tZW50cy4NCg0KPiANCj4gQW5vdGhlciBwb2ludCAtIHdoeSBkbyBwcm9saWZl
cmF0ZSB0aGUgb2Zmc2V0IGNhbGN1bGF0aW9ucyBpbiB0aGUgbG93ZXIgDQo+IGxheWVycyBvZiBU
RFguIFNpbXBseSBwYXNzIGluIGEgYnVmZmVyIGFuZCBhIHNpemUsIGNhbGN1bGF0ZSB0aGUgZXhh
Y3QgDQo+IGxvY2F0aW9uIGluIHRoZSBjYWxsZXJzIG9mIHRoZSByZWFkIGZ1bmN0aW9ucy4NCg0K
VGhlIGN1cnJlbnQgdXBzdHJlYW0gY29kZSB0YWtlcyB0aGUgJ29mZnNldCcgYXMgYXJndW1lbnQu
ICBIZXJlIEkganVzdA0KZXh0ZW5kIGl0IHRvIHRha2UgdGhlIHNpemUuICBJIGRvbid0IGZlZWwg
SSBoYXZlIHN0cm9uZyBqdXN0aWZpY2F0aW9uIHRvDQpkbyBhZGRpdGlvbmFsIGNoYW5nZS4gIEFs
c28gdG8gbWUgYmV0d2VlbiB0aGUgdHdvIGl0J3MgaGFyZCB0byBzYXkgd2hpY2gNCmlzIGRlZmlu
aXRlbHkgYmV0dGVyIHRoYW4gdGhlIG90aGVyLg0K

