Return-Path: <kvm+bounces-71372-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aKYqEqunl2l34QIAu9opvQ
	(envelope-from <kvm+bounces-71372-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:15:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D427163CE7
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:15:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A5CAA3009F3B
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 00:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF63E19E839;
	Fri, 20 Feb 2026 00:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c8Iya3fs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937DF78F4F;
	Fri, 20 Feb 2026 00:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771546527; cv=fail; b=n3/l3fDyGsUuCfk6k7tSGWOjNmZuwXPp85/fFNBM76BHTauKojsI3QJCBWdbLjryrhf740KMvARhxL2qnB1kLnF2fs6hXY3YPFY2v+cl3vZ32hE5v5CJGCMp5bybhyAV/vLpoHhV8wvRm8pgOSTwaYOi+Mfx7+gw7yT1kWOkXgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771546527; c=relaxed/simple;
	bh=zWUHVMpXTqogonN59j7yw2inYIz2qIsblXIoHphwSxk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rIy2AzPx5jDXWy+HFhtJ5sVKRtDlbcxfdQNezJBHtuqEyCIDHuMJeHdk6rr8F4c/gyLZuFp89pgyCD5tkEjNW7g8TDjgw62eeUkevXS2O1q2BAYo18sAK9qLL3QtjGZD92pmTDI4qoQC31UCIXzRMPCf1bH6G8Z56Uj+T47Vx2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c8Iya3fs; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771546525; x=1803082525;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zWUHVMpXTqogonN59j7yw2inYIz2qIsblXIoHphwSxk=;
  b=c8Iya3fsIW4I4+UMO9fdMR8K5KTXY5AuBC13v6JXJ1JojGfXLgXgxHzP
   cuM+ZFCkuWH2qI0vo61zX8cDHVjsCJZBTKZqEKoOuQfxnjHJjStqJVycQ
   kl/kzXwtFaWvcw5Oy7e3VxpmGg3HZZkiwpxXasHHUKYcm5FN+BDCckgwL
   3S/BvOIk/FxDeGRIjj2TNYtnKyIawH1mRVQQWlP5HvLG88VvYVd95TkVu
   ifdE5egFLlOfrwhH1kXNMnvFESd4hvScM5wh5mgH4TRhjvsMmdpshN9Fc
   +8pj5R/pUJF9h/NE1+JYVq2eJC1C7TQkHdB5KD+rv9dN6c8qRQ18ev+su
   Q==;
X-CSE-ConnectionGUID: vrewQqf0QrmRugEPS6dNeg==
X-CSE-MsgGUID: vXDlvNDgSX++H9o1J+vQwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="72348057"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="72348057"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 16:15:25 -0800
X-CSE-ConnectionGUID: Qh8UyKexSv2/E2i8xw73ew==
X-CSE-MsgGUID: iNtcik+cTTa4gzJSmdpr7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="252389775"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 16:15:25 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 16:15:24 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 19 Feb 2026 16:15:24 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.12)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 16:15:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oFMMm+2Wcjpo69jgX7cDrUR45kIgMzu18RfPd8n27TwElmuDtNmI+xUAU4mIve+HpvpRxzdVGiFPZw/fU3NLbPpDesONFsHicJLnZU96Kru6zl7muAIOS0Yo/PSjOSH2+K9k+3+MQW4beyga2xLM7yypX3moc3XtkTluUZ8fdV3tmEXlV1M1NyoF60Fi/TgDLaVYPccdcjRz9NkAPHxX6hrEWZ/VuOqFqxLE7w5o/NW1PptwVRZXjxjxuzk7ZcLx1XBm5E86eZHgEUQQXdBvlDl4EgozEMbOGZm0NaQ4dbiuvbWPQ4bzOaUoRy8+hhBw/LV0z5peHFjJ94fkA62K0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWUHVMpXTqogonN59j7yw2inYIz2qIsblXIoHphwSxk=;
 b=lP6OU/kG9XVaC8pqDUTP4NgnDExZ05Ef81X2iIQt2oq+iMPhk554LY1LC/gABXjmFG7zQydeYwgCSoUiHEduDQmtLHDce8Mop0nsx114GnwIMO1ke5R4qDAM8+P+KTMg7HxClDIRX8hgNYHW8XkNhkePDBeMYEUqpOSROaWMNyOqn6RFNqGTnm/D5fdcHT1tQ8c69PSdgrCEMuN0eu/LIR/airGqe0FOoLTmSJJqCPOGw4fQD5TfmHgx5ZaFx2OxAWl+v8PYmQkepqNtNxMoaTyRYnYLyoWV5il9X8e2im9r8u4XXUMGiy8+yzuU4ITGFgt3YjatXxP8v1TkeVH1fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 MW3PR11MB4602.namprd11.prod.outlook.com (2603:10b6:303:52::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.16; Fri, 20 Feb 2026 00:15:20 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.010; Fri, 20 Feb 2026
 00:15:20 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "sagis@google.com" <sagis@google.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "paulmck@kernel.org" <paulmck@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 02/24] coco/tdx-host: Introduce a "tdx_host" device
Thread-Topic: [PATCH v4 02/24] coco/tdx-host: Introduce a "tdx_host" device
Thread-Index: AQHcnCz2aP4guLqXzU6uCs9je0xYHLWKw6AA
Date: Fri, 20 Feb 2026 00:15:20 +0000
Message-ID: <3881637de6fc6dc5561e0dcf42c536ae57f6eef9.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-3-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-3-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|MW3PR11MB4602:EE_
x-ms-office365-filtering-correlation-id: dc1c0358-be3d-41dc-a506-08de7015227a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?K01UajE3Z09SSy9nMWZEMEZzblZkSDI1cjFTTVg1TDR5endFUHNXZzJzMHZo?=
 =?utf-8?B?WEdLaHQzWEFEOGI2NXliZkR1V2VncnQvN3RITWErc010V1htWUpDb0F0TkhV?=
 =?utf-8?B?UFVzRXdoTEpwNmNKbytYdlVUU3ZSdWFnYjd4QVJnQ05VbXJiUWZtOVUrR25i?=
 =?utf-8?B?QVJ0RXFPbHpjS3hqK0tCaW9XZEkzR0EyVWV3VWwwQnhZZkg3U0VnNERkOWJZ?=
 =?utf-8?B?WDJWS0ZwMlBiZytHVXNuTmh5QXNWMmYxcnVvYkRZTm5INHdhU25IZmlBSVZR?=
 =?utf-8?B?S2UzWFdreCtONVgxVVlibE82K3JtaVc5THZHdDVkQ0F3N1V6MUZMWUI5THdS?=
 =?utf-8?B?R1NlYTdic0UrRGNVUWU4YkxzL0FZazBKZWQxbFkyM0Rydkpya2ZaVE1rZ0lR?=
 =?utf-8?B?WWhBak9sMkhHalczY2JsMlgyZjFZYmJHTDNZbzAvWVAyVWNnYityWWdhbzhQ?=
 =?utf-8?B?S0xjT05iVmdSNSs3SlU5bjl6bWJ0MVhCVjdDbGYycGVtaUxSUmZxR0xJSkVp?=
 =?utf-8?B?bURKajRIanROU2M1ZXFPUVBSbHFYWUsydmRxMlptQ3RuSEFncW5SbW83M1Zm?=
 =?utf-8?B?SUVIOEs0czR2WGhqZFMxY1NwNGwvNTY4bUdVZ2h6MVNwYUNCR2VoclkwODdV?=
 =?utf-8?B?VlgxY0d4ampKaStjMHlEbVNSQ041SlQzVnpuVmJmd21IdVdJZnZPcm9tbmN0?=
 =?utf-8?B?bk4rN2xuY21XZy9ydUZha0FxYlM1UmJPbXQ0NmYvYzJkd3BqSmdhdW4rbW1R?=
 =?utf-8?B?QXZZQTRFZmNzQ0ViY2Nvb1VlSVR1Sm16OXkxbzdFUEtXT1lwenZJcVJ3QUxO?=
 =?utf-8?B?M3QwVmgrRTdiS0tLcmRqbUZPY1R4YUdWT3pEcFNuY2s5Z2RrTjBFL2lQRk5p?=
 =?utf-8?B?Snh4M3Q3ZDVoNEF2dEZiL2QrMzVpUUJnWTFnVXg2dEI5R1M2Nm1nK040VWhq?=
 =?utf-8?B?TmN1VHpRZVRYL3MzSldLL0pLbWcvMG1iQi92QjVJTXVUZTFXcElxS2p5eVlD?=
 =?utf-8?B?Y2VhUUZCaXUzZG1lNHBxaWV1REVVbUcrS1k4T05mcGJ6ZklLdE80ek9SamxW?=
 =?utf-8?B?TWl4RnpwYW03aHVSVWNVcm1QV1M5MUFJOHR3bXRhTERUNXdsYnVQN01uZXVt?=
 =?utf-8?B?eDBkL0ZhaFpHN0ExaEZjb0UxSWJHMUhvWU5XVHpNTkwyRzZiclVER1ZzNXd4?=
 =?utf-8?B?Q3RzNXk1TlE3SkM3SEtIVDU5Rm5DS0puVUpWcXVURVEyRTl5WnBqV2FWTUFX?=
 =?utf-8?B?UVFMelRiMnJ2b2wyYWFLZGtkeHpRdmd6TVRwZks1cStEOTNJQXl5VkVRTFBV?=
 =?utf-8?B?WlZwWWVOcDhwWHA5WE01SUNxWU5EUkZ2eE5lRm0yZ0t5YUVHdlVlc0dKUzV3?=
 =?utf-8?B?QVV0MGY1RHpISUczdkhaZ3ByKzIveW93NmRFMitsY2t3Ri9iUWtZMHB2YmUv?=
 =?utf-8?B?dXFaMkZvRE5UNytQaFVvREYzWHFCdkZmS1N2R2dNUHNuOXBwb0l6ZXk0LzJy?=
 =?utf-8?B?TW54QzhPUWhBUWlham5hdEo1OFBEeDVtV1REbmRjUHpxekh3Ykp3UDNGR05N?=
 =?utf-8?B?YVhUa1ZqeGZzNllzRUFtZVBvZlRQTnlENVNUVWowVW91UFp0b1FyRXNRMUNm?=
 =?utf-8?B?YVZmK2pRZmVBQ2xBU0NtR0loa0hWYURrMEU3cGQ0ZnJhM0Z1bUcxUXhweHJ5?=
 =?utf-8?B?UzVBR0t4L1h0UE9adVBhRzJVb0tTdWREaWhZOWVkNW9ieFZ6R24xTkF6UUNI?=
 =?utf-8?B?VmpZSzVEaVJTZUNIQlFlWDc2ODRYVlpPTnBkUGFYSXVjT1QxaDdDUFd1cjZ0?=
 =?utf-8?B?UlN0cXIrbVFnY0VYQXRYSUpOcFJkS0hqaDdmYkwxRmR4bWlNZTcwN0xwNENn?=
 =?utf-8?B?Rnc0U0drSzFoTG9RalBldys2aXpOa0Z6QTRhZldDalJCVFVtZGNydjBiLzQ5?=
 =?utf-8?B?clVFQklIN0FCSitPYUUyK1p2b1NpQk10ZDcvNGFieXV3bGcyR1ZPUERldGpE?=
 =?utf-8?B?VjQwVWRLN1Q4d3FhZ2hpUW0vRGp1S3Fldkx5S1l4Sjc4UEhiZUtNNGV4Y2JR?=
 =?utf-8?B?UjljRTIyV1J4MURKTHVrMTg3aXZPOTRKaXExcmpNSWVZK2xRRFdLcG11TkQy?=
 =?utf-8?B?VGkvR0R1d2V3ZDR4RS9sUmpCNFZGZkhvTjJnYll0d29iQjR4RDJyK0lpajZ6?=
 =?utf-8?Q?cIAynezGA5smIANJU642168=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHhIWkNSUFp0UTlVVm1KbmRNWmx1UWRiK3AvMFNVTkV3aFJQRmtBTHhjRHNw?=
 =?utf-8?B?c2trUXlYVW9DbUQ0MGxMVlQ4RjFZVGtyd0hQZGZvdEhvY25FNXFEM1dDOG0w?=
 =?utf-8?B?c3VvSk8wZ2lsemhVSzliNjBtbmNDVzNyTmJXV2c2WndqYmc0WGgyV0tsaUZz?=
 =?utf-8?B?NCswMDhJNzdFdFdnank1MDU0YkJIU0w1eGwwZ2hXdWpGOHMvdG5ZNVpabWsy?=
 =?utf-8?B?OHhLNld3T3doZ1NoNnl3QjJTckRrN0puSjA2RTI4U3MzTk1qM1h2Z2JEWklG?=
 =?utf-8?B?MVpjUzkwb1VxVVdsZ1NJMzZQTTZodCtBeG9kdWhFM1ZkR2NXemlsVFpWYTFV?=
 =?utf-8?B?MXhESGNIaDd5US9obUc2dDJ3TVVYQ2JDc0EyYW9hNk5oaDA3MTkxcGlIY2NU?=
 =?utf-8?B?N2hwV2hBOVRpbTFidjBlbkZpQURiVi96MlVJRWFla1VxNzl6c2VmdFlid3hy?=
 =?utf-8?B?bFB2MzlmVzI4K0V3OXRQUmEybGhqNzkwaFAzUzJ6Uk5wZldzNkd1Skllc3li?=
 =?utf-8?B?MS9iUGM0NFFXaERBc0ZSN045ZzRTM1dLNGxIeTJ0SENkOGZ5WCtzYjZKa3Nu?=
 =?utf-8?B?eW5YcHdKWGVaNDRhK3M1UjNoNjV3VjkwdW5nb2NLU2FXZWdFM2F5SDg2ZERk?=
 =?utf-8?B?L3RSdmhLM0poZXZxZGZibVBWQnFMcmJ0SmNQL2NDcUFralhqY0E2SG1USGxM?=
 =?utf-8?B?bk5zRFZGSnVwTE14RHJVM2VYQm9LS2s4SllKRDJEWW9QTUVycFhaRmgvK3N4?=
 =?utf-8?B?UzMxVUNvR1g0Q21UZG5laVZwcUxTUm1VWlZ4ZGFQR3ErMTlkc2pRempjNk1W?=
 =?utf-8?B?OFZmYmlFU1VxOGNaMm91YlZjU0dwT09oK29FS1R3R1JmbEtnYWpSbkpNOUhI?=
 =?utf-8?B?cGZ0YnlEcGFOTUpyWk9iZEtMbU83YWVaR0RoOXczSDhrcVNObzZwZDVHTjZB?=
 =?utf-8?B?cHRNL2g2di9lSU9sbmlQdzRnV0FoY3NGNVZEQUM0TS9Fais4WXBCVmNFMnZ0?=
 =?utf-8?B?MkhWTFBkcDJ6R3hBdm9BSGp2dk82ZWF2U05WKzhVbndod3FncmpidFdoTWFq?=
 =?utf-8?B?ZXBzUytnQXJDa0s4cDF4cXRGZDZEYm1mRVZvenJscGhmYWJ4V0NORU8vMWE0?=
 =?utf-8?B?Y2grcGlZY3AzbG1jMTc5bkpLZFAwbnBWZzVqOUM3RnFVYVVsU2N2MTJ4OWEz?=
 =?utf-8?B?ekdiWXEwNVhZSktiVEZWdmRoVEVWV2hISFFWeFNjRW5jV21GUjI4ZC9RdXZj?=
 =?utf-8?B?MkQ3YjIzWUkzVllGelF2R2ROdXlDV25aQ29uQVo2UWN1Rnh4aUc5UDhrbXRH?=
 =?utf-8?B?eFJvQ0pKWFJmdUtIQitLZThEL243TnRKa2RXVlJCS1hHNTMxWE5zaGZWVDdT?=
 =?utf-8?B?NWQycW5vV0lBMHQxL0VRUCtJbmd1aC9rdUZaV2JPeHA1MUlQT1d2N252UGJk?=
 =?utf-8?B?b2ZuT0JGWHRzeHRFMTVGNi9Db0tIcG1WTWI0cTY5YjlSVFk3SmtON1JHOE1k?=
 =?utf-8?B?TlBRVlJpc1Zkc0djbnBJTGY0YUJveXJnSWR2K3BicitRWC9JTHdGc2pPeDhS?=
 =?utf-8?B?bUp6RSsyRkoyNldMd2JnOC9MRlpBbnRHSjR2UjdTU1ZURHZtRmNzN2J5dlVE?=
 =?utf-8?B?ZkwveWJZYWNKZkR3NTVIaG1nTkkyblNXMGdCeEFJUkFHL3Mzczlsb0lXeW5V?=
 =?utf-8?B?NzMxc2FBOXYzc3l6YkJvQktvaXVkblk2RW1GK2hQcENPQkNTS3daREluQVRx?=
 =?utf-8?B?NEFaYUJYVFZja3IzalNJRHhHTVFmSXZhLzd1bWVVVlpmNm13ZkhSZG1KTk1k?=
 =?utf-8?B?d05IekhLd1VlUVgybExJdHAyeHJVZ1N6NUczRDl0c2YxRmVQeDFWSFo1WjdQ?=
 =?utf-8?B?amk0R0RBRkh3eTdQTGlqN3pLbFNFNUdVYnRWSFpjRTFJaVphWkFyUFdVUnZs?=
 =?utf-8?B?SVBySlZabkZhMjcyQ3BiWGFIVXBUbUlMVzlRUTVLR3ZtK3l6L2xrbTgrazdq?=
 =?utf-8?B?bkxtVGRCY25BL0Nkc0p2OFltbXBnTnI0ODltV1Qva0R6TStEMTdHcHlLLzFP?=
 =?utf-8?B?VFFLL1FhRi9zWFlaczlTMUNTa0srQjc1eXVFVVlkQWxNUFhrWU9NUis5WWxh?=
 =?utf-8?B?VGdDRFVpU3FsYVlBY3pIdmxFUC9lREkwbHZPaU5UN2tISmdBbXBmRjZyNDMy?=
 =?utf-8?B?QTZRckp6blNlRWtDdWhBSjJlc0YyMlZPOHhYRVRnS1FhUjVvVEw4ZCtuK0kx?=
 =?utf-8?B?RE5IU1F0czVuZmxlT29NZ1dCVjFvY3h5QWNDdkpmRW8rS05VaXVlTTBrVUFI?=
 =?utf-8?B?MDFGbUszVE15TWhETG1WTEw2QmVOUHJQaVMvM0srY3J1R3BhNXUvQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D2072BAB9158384592EFA18D5CFDAD13@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc1c0358-be3d-41dc-a506-08de7015227a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2026 00:15:20.8068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xyrDMT2dqdJ2NiFJ/L0RdoF3+ddDiBDC6ZKytTAVPHUBoPMxlyk/v5F2Q2Ner6/5jTqJ4QsamWbjxSL5Rrlibg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4602
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71372-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[26];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,intel.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 5D427163CE7
X-Rspamd-Action: no action

PiANCj4gQSBmYXV4IGRldmljZSBpcyB1c2VkIGFzIGZvciBURFggYmVjYXVzZSB0aGUgVERYIG1v
ZHVsZSBpcyBzaW5ndWxhciB3aXRoaW4NCgkJCV4NCiJhcyIgc2hvdWxkIGJlIHJlbW92ZWQuDQoN
Cj4gdGhlIHN5c3RlbSBhbmQgbGFja3MgYXNzb2NpYXRlZCBwbGF0Zm9ybSByZXNvdXJjZXMuIFVz
aW5nIGEgZmF1eCBkZXZpY2UNCj4gZWxpbWluYXRlcyB0aGUgbmVlZCB0byBjcmVhdGUgYSBzdHVi
IGJ1cy4NCj4gDQo+IFRoZSBjYWxsIHRvIHRkeF9nZXRfc3lzaW5mbygpIGVuc3VyZXMgdGhhdCB0
aGUgVERYIE1vZHVsZSBpcyByZWFkeSB0bw0KPiBwcm92aWRlIHNlcnZpY2VzLg0KPiANCj4gTm90
ZSB0aGF0IEFNRCBoYXMgYSBQQ0kgZGV2aWNlIGZvciB0aGUgUFNQIGZvciBTRVYgYW5kIEFSTSBD
Q0Egd2lsbA0KPiBsaWtlbHkgaGF2ZSBhIGZhdXggZGV2aWNlIFsxXS4NCj4gDQo+IENvLWRldmVs
b3BlZC1ieTogWHUgWWlsdW4gPHlpbHVuLnh1QGxpbnV4LmludGVsLmNvbT4NCj4gU2lnbmVkLW9m
Zi1ieTogWHUgWWlsdW4gPHlpbHVuLnh1QGxpbnV4LmludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1i
eTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYt
Ynk6IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+IFJldmlld2VkLWJ5OiBKb25hdGhh
biBDYW1lcm9uIDxqb25hdGhhbi5jYW1lcm9uQGh1YXdlaS5jb20+DQo+IFJldmlld2VkLWJ5OiBU
b255IExpbmRncmVuIDx0b255LmxpbmRncmVuQGxpbnV4LmludGVsLmNvbT4NCj4gUmV2aWV3ZWQt
Ynk6IFh1IFlpbHVuIDx5aWx1bi54dUBsaW51eC5pbnRlbC5jb20+DQo+IExpbms6IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2FsbC8yMDI1MDczMDM1LWJ1bGdpbmVzcy1yZW1hdGNoLWI5MmVAZ3Jl
Z2toLyAjIFsxXQ0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29t
Pg0KDQpBIG5pdCBiZWxvdyAuLg0KDQoNClsuLi5dDQoNCj4gK2NvbmZpZyBURFhfSE9TVF9TRVJW
SUNFUw0KPiArCXRyaXN0YXRlICJURFggSG9zdCBTZXJ2aWNlcyBEcml2ZXIiDQo+ICsJZGVwZW5k
cyBvbiBJTlRFTF9URFhfSE9TVA0KPiArCWRlZmF1bHQgbQ0KPiArCWhlbHANCj4gKwkgIEVuYWJs
ZSBhY2Nlc3MgdG8gVERYIGhvc3Qgc2VydmljZXMgbGlrZSBtb2R1bGUgdXBkYXRlIGFuZA0KPiAr
CSAgZXh0ZW5zaW9ucyAoZS5nLiBURFggQ29ubmVjdCkuDQo+ICsNCj4gKwkgIFNheSB5IG9yIG0g
aWYgZW5hYmxpbmcgc3VwcG9ydCBmb3IgY29uZmlkZW50aWFsIHZpcnR1YWwgbWFjaGluZQ0KPiAr
CSAgc3VwcG9ydCAoQ09ORklHX0lOVEVMX1REWF9IT1NUKS4gVGhlIG1vZHVsZSBpcyBjYWxsZWQg
dGR4X2hvc3Qua28NCg0KLi4gTWlzc2luZyBwZXJpb2QgYXQgdGhlIGVuZCBvZiB0aGUgbGFzdCBz
ZW50ZW5jZS4NCg==

