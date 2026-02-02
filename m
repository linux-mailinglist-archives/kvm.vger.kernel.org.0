Return-Path: <kvm+bounces-69839-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aKBmHT2RgGkj/gIAu9opvQ
	(envelope-from <kvm+bounces-69839-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 12:57:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AD54CBF58
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 12:57:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8D482300A30F
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 11:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D21E7364054;
	Mon,  2 Feb 2026 11:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b1luu+zJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EE13587D5;
	Mon,  2 Feb 2026 11:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770033467; cv=fail; b=MqoX9WZ0qQywDlE76yi5+aPavgUBWo+U0UC0OTtgBDgs/nfPoHrtBCG164RCESQMi7KBM2+EbNP9dGLtOeP3L9Vy2SZdjPljYy4phqjlVdSectaJdD2Zm0wX7JMRU768IxdKnzTFQCRfsO0AC52TnJvYekQx3548Lf6bks2VHio=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770033467; c=relaxed/simple;
	bh=6CX34vcrfY56sZzzbRTnv2lDnZjmVR/Zab95744rn8U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=te5tQfifHtsgHRjzCulYAT7awCZa1BYiGT77gJzlUh+d7tbXyia68UzAmnqnWkUiAwqD2UuRyb85CmIsLBZySmdOuT7y7+1CQDSiMY1kl9prShDcdCDvBByYXcV2H470FSmOPLhV8iLUFRYbxhJ+mdOegsUR9mCmbR/KJRyEWW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b1luu+zJ; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770033466; x=1801569466;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6CX34vcrfY56sZzzbRTnv2lDnZjmVR/Zab95744rn8U=;
  b=b1luu+zJT6NmIfNeRBSD2yGZ9XLpGDjX46ZY5dRx1JcldUvlr9LnHGqr
   RMqKmwEACMAAWqjlR73LW3QaRSNgHDpjcD4+JJMtx7BZLg4frolYi7BTB
   kUytocKW1REcqNk7ef7xnqPvdQnJfKfSIMoZR0/7sLl/CxTZr46lEazI1
   BRBNtQhA/eaFhOxKxbONzbOjwLLIntIT6x4pwpUbtMZzr/04yyU3iZ1Cv
   I9fv5WkY3GWgU7Bn9LJ07+e+22oyVoAqLu82OqEppJambVbdXIyVwcFfu
   cY2SYVsZe+jaOVffRJUdPVtaWYmsZThi8OROfIxuoN3NM4fawvInKpDoV
   w==;
X-CSE-ConnectionGUID: xB0py8y4Q+e27Q1iApfhHQ==
X-CSE-MsgGUID: ZkZPkukvTzGy7ZPktXmNDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="82296976"
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="82296976"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 03:57:45 -0800
X-CSE-ConnectionGUID: 724cD56nR1KyQopRX1vvwg==
X-CSE-MsgGUID: dQ9ojlE9TL6s3Qdnirv/fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="214437962"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 03:57:45 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 2 Feb 2026 03:57:44 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 2 Feb 2026 03:57:44 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.40) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 2 Feb 2026 03:57:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F9Wv9PVQuN6xV5xHSX3l6M/3TuzI5RunI6qhOVsrtj4SLQg7D6/dGeaYz5wc2mTx/PXBghTnpBrwd6RCIVTObosiioryNlWTiWVFNlWFQZn8JneoDpVYg6WUMPocwAoR9Ofg3Otz3LqfBsbry9qKjFDwX6gxL49GP5TkghUS+upqL8buhPxVGeV4iY1rYiag9aMtQpJ5g+MuyiWDj4bR4nOL2zHHSFbPZelLygwm4FFcb+u9PlL3xjtLDDFJpS3H1RfiBn+8B/PK7jNlk7YEWuqT0i0KwXYwNTj8adVP57ilKNc4JtsduBeOpRNjETZnu5GFbuwiB5X37jXHFt6SRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6CX34vcrfY56sZzzbRTnv2lDnZjmVR/Zab95744rn8U=;
 b=NySQ/RjcYEgncZ//KnlYKYCzuRrymHmQc73QxTiwwhvwbb5qzEGsDrBth2PbBTnq8XSCOZ+XkivPotJ7ULdIcYdKbmtqDAQ4uwY8eph2MHwESKNKIj80Cj7P+bE/8vai0bTGZBOMEKTtUeOqsusky+pBnIbzhvfLIMmyYeDkNOcTOSCJtlIl+q0TQdVf4Axhe1II1U4H/aFl63EX1a/t58FErygBvIJpmaGTgvlTGzractt0OiG8b7qE3Bel9WWsTN1ES+myKGPjF735uJcS1TEubzyV3JbYVsMn2/bnUKHMIA0Ceu5UrVAl9VyB366WiwKIzuR00Dy87+gAEOL0Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by DM4PR11MB5326.namprd11.prod.outlook.com (2603:10b6:5:391::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.14; Mon, 2 Feb
 2026 11:57:36 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 11:57:35 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Verma, Vishal L" <vishal.l.verma@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "mingo@redhat.com" <mingo@redhat.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "sagis@google.com" <sagis@google.com>, "Duan,
 Zhenzhong" <zhenzhong.duan@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "paulmck@kernel.org" <paulmck@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 24/26] x86/virt/seamldr: Extend sigstruct to 16KB
Thread-Topic: [PATCH v3 24/26] x86/virt/seamldr: Extend sigstruct to 16KB
Thread-Index: AQHcjHkW6CQuWkGBfEmIiCBzsHzvk7VoOv+AgAKUj4CABI26gA==
Date: Mon, 2 Feb 2026 11:57:35 +0000
Message-ID: <d051f016e48c233449e0575064002f20454bfc2e.camel@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
	 <20260123145645.90444-25-chao.gao@intel.com>
	 <c9c648536ed4cd242ce5d7de87cafe352503839f.camel@intel.com>
	 <aXy/S47ryxy0PwpM@intel.com>
In-Reply-To: <aXy/S47ryxy0PwpM@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|DM4PR11MB5326:EE_
x-ms-office365-filtering-correlation-id: 54860dc1-98ed-44aa-3b75-08de62524172
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VU5aTlg0YnNtV2JZYnZYbmF1eVJadzdJb1UrM0N0bXl4U2R6czlLSm80aVMr?=
 =?utf-8?B?allvS2RNLys0ZEZ6NmJBbzZ6Q1Q5VFFxdUhJcHJFZTBBazEyeG52QUxEcVlL?=
 =?utf-8?B?NkxqVm16MmxwSDJPZTFrOU51SGdCa1ZQUWFFZU9Udlc3MGE2R3c5MGNJWWwx?=
 =?utf-8?B?eWFuM0hyQmtXUzkxbTlvV3hOdDdDc2VtTmttMWhXYnJaODdzbFlhSVZWK0xZ?=
 =?utf-8?B?bWhJTFZocFpxaGUxQUptdnlPck5hRi9NblFrZDZDaFpwMklJeWlWZjY4ekpk?=
 =?utf-8?B?Y0VhSVcyVDFsbE10WnVWOFVJRXllbWRibG9pNllaYVBVNVA4Zkg4U3U2WGVs?=
 =?utf-8?B?bkZBckJ1RjQ1dktXbExJU0tPL1BHRHZRaGl2bGd2WmxFNmlNU2dnS2NUS2JL?=
 =?utf-8?B?d0R1RU5xdnI1TEUzOXB1T2QxQ1lVVHZ1L0J3U0ZScnl3ZGtSY29vZHdxMGZn?=
 =?utf-8?B?ZjdZdjhsUEJmaG5aRTZlKzdrSGF3T1YvTjRnNjhHZHV1UnBzdEsvVmd3TE1G?=
 =?utf-8?B?QTdvOFRKMm1FZ1lYdmVZajU3bnY0a0RsYlRtNnFDd1dkdXhHRjNWcTVNbTJv?=
 =?utf-8?B?cXc4NHl6QzZOdTVDbzlWU2hrUUFvRndGcitWWlJSMjFBa3ZjaUpzdWVZMjUz?=
 =?utf-8?B?UFY3c3JWMjhjZC9MMXZrQjlBY1N6cXl1VzR0cFdld3VFa2F2NVJBSXJyby9V?=
 =?utf-8?B?QWh1SzRKSlVyWVBQcStwaXY3K0xHUmFvTGcvbXl5SGgvRHlndXA2S012bXRt?=
 =?utf-8?B?UkRvaVVXWHo1bjNBeHJCODFCSmFrL1llSUVMVFNxOG5UK3c3L1dBa1BEMnRY?=
 =?utf-8?B?TGNGQmJod3VqTWU2cWZwV3dUUlByY042Y0F5bVlZZ0k3N2dOdU5qM0R0RHM1?=
 =?utf-8?B?aHNFelorSERLSnBFa1JYTDE3RlQ4cjNTcHZpemVwSGt4dGdpb015Y0VSdVpX?=
 =?utf-8?B?RnE5NWNEemF4M0R2ZldvSnlQdGJZT1BnbHc3WFlaUkc1UHhqbHZlY2JIazM0?=
 =?utf-8?B?cVBYMkNOL3BzKzF2TlZxK0lMWVBrWVdvcE11enlNdUF0cHdSd3JjWjhUZDBG?=
 =?utf-8?B?VTBycWNwdG45Wmg3ZFBlRVR5S1pRdlFPbWRmWU1NRy82K0Q5ci9xQVRhTzA3?=
 =?utf-8?B?UE5zWmxMelI3eWlvTUxiK3FuWTB4OHpLc09raCt3QjhCQ1Y5V202aHhuSk1s?=
 =?utf-8?B?Y1VEdFB1eENBQUtkTHBsVnJobUpSTFlzcU9uaEx5QzQ1eVpGM1FBQVJnVDJB?=
 =?utf-8?B?Yy9FYWRRUElqQ3NvU1Q4TVpHWGZKV2FrT04xTC94VGdBbUs5emZTYmRDWFVr?=
 =?utf-8?B?aUhIaWcycWtZZEtBZmRUOElVSlNrNkhQcGVWYUlyeTRMZSthRW91dXVvOU9z?=
 =?utf-8?B?c0g2TFAycU9ENWZ4OS9UbVNJd21MZElOMnh2Mi9rWEJhQkxtOUFGNEhlV05Q?=
 =?utf-8?B?YmpUbFdLdEhlcHpTcGdiTmxtbmFvTVROdGViUjY0bzFEanVSWGNqQVVZNjI5?=
 =?utf-8?B?Uk9iWldlcjF2M2xtZktCd0xaUmdKK3MyOFZLRk56WXdTS3Y2TEkwdHJSVDNy?=
 =?utf-8?B?Y0pieEFMa0V5cERCWlRPMG4vV2dmaDZSR1p5Qm80S3ZmSU1HbFJjSkFsVlhr?=
 =?utf-8?B?OHJIRXExMTRQUkZNVW1CZE1jNUR4QlIrZjd6clMzK0M0QVFMRXRPZFM1d3p3?=
 =?utf-8?B?ZVdhVndZUHdpNk1PMDdYYkFkT3FmUEMwU3BQdGpJL25kMDBDTXFwT2JRTEhi?=
 =?utf-8?B?QWVqRCtyTkwzdUNTTnlzaktNUUpCMFl4c0pueGdVOHNnbm5ITzZybTN6bGlx?=
 =?utf-8?B?YXoyUldXdWhtWW1Td3JMU0VNbHVNT2M3ejBmcm9zWmNlcG9IWS8yb08wZkdB?=
 =?utf-8?B?MlkwVjFsM1JIR1NQLzJxWGRFTXVES01xVU5MZGordzRacmlUWHg2eHNDODEr?=
 =?utf-8?B?aG1rdEZDUkgwQW5kMVNmSTgwNU10MUh1K2RYTjh2clg2UXhVczdTMDF6OXIr?=
 =?utf-8?B?dllJbXdZY2pQa215dHdZQnJhSWVxZXZ5OEpXSWcvZjZ3UDZoWGt3d25oOU5K?=
 =?utf-8?B?a25RQXhFMndvZFN1RThVbEt5Vmxvb3ROWkpnWEoveEVwNU50L0l2YjRKY2hh?=
 =?utf-8?Q?b5COw9zfqwVBxJSnyX5FG/kRV?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkpXQm9KL3RiTng4YTVIazdxMDg4QkJDZ3AxbEYvbTJLVm1KYXR1cmtMUDB5?=
 =?utf-8?B?L0I5RDhXN3dveWpWK1AzUEJaaGEwTFFIcVVybVVSRGh5SVRnTlFRV0FNQzhD?=
 =?utf-8?B?WmdoYjdiQllscTc5aFVteDZaNWZZcXV4ZDBoSW1uRS85U3FSZzlVL1ovSjM4?=
 =?utf-8?B?dFJDUnF1UXF2YWdZMXNNWEhIdmRTWGxXcjd3VUR6ZkpOYVRlNlVRMWl6WVNL?=
 =?utf-8?B?RnFrTXlTaXBJSzRXVkRiYkhFYVdya2U0SWI3QkRYK0UrQnp5MmIzNW5URDdn?=
 =?utf-8?B?d3BSb1NDVjFEa2JTZ0RhcUVtR0haMjF6cFZHWHQ0ZnFpY0htSmlRTlBudzNP?=
 =?utf-8?B?blZWRzVKSzZ6S251UlNEdWEvOVZNTjdlM3NIYnd6OUlHdzRyUzRKNGRNdnNx?=
 =?utf-8?B?Q21PekhxVUQ0MWh0QzFtYmpqb2dmOVM4TEJmL3hSbDYrQ1NpR3Vjek1UQk8w?=
 =?utf-8?B?SFJwT2Z4NzZ1T2QwT3RhVEJFVUY0S1BzdU02c1A0ZDZmV3Zja1N6UnZtNXVW?=
 =?utf-8?B?NzFubzVkQ21tRlEwUnFaM2wxTTArZU5VL2JlVDlYNlN4U1doKytXOFdFaERo?=
 =?utf-8?B?YUpWVFFhcTlka2Izd3hSSWZ3VUhKME1mR0VPcWNoZjk0cXZ6dzNlc0pkS3dt?=
 =?utf-8?B?bHhSN3JvQ2JEblVNbW1WRlByTThlQ2pHV0oxaXU1Q21pMmJlaXkvblN6VGdM?=
 =?utf-8?B?V3YxNk5YeENWU0xGcC9hb3d1bXFyaDlJa1BmWmN5TXIrajFiUytmNDlVcEhs?=
 =?utf-8?B?UUFXYTR4MDBmUFJyRXZ4ck02OFovN09xdVErUndDcWt0U2VpTVlpdGxmWUU2?=
 =?utf-8?B?VG5XcXdaVCthWkxoVHh6RXQ4MkxRSGttVGg0cXpYUmNJWDJkZVpTUFJEd1VQ?=
 =?utf-8?B?cjVRbnNoU2lPeWM1RWpSVHFSSHM2Y09FUHA1TFlsOWlET3RlbXZDNlJDSElN?=
 =?utf-8?B?c1RNQ2V1elZ1ZmdtaEVXUzArWXJjSUxDMkk1VFVzREFoNGJST0Z1MzkrVE9i?=
 =?utf-8?B?U1BSalU5am5rZlozYUZ4S0pwZXI0a3ZxZzI1VjhDcGtGZ2VOZEQ2c2d3eXpJ?=
 =?utf-8?B?RWd0ZkE2REhBa2xmeVQ0L043ekdBWlZ5S2ZWT0kwNXdBRzNsKy9kL2NLa2NG?=
 =?utf-8?B?bnN4ckpLb2kzbVpkc0lPYnVYSWJyNUZ3QlNxdGR0Q2s1R3VpMEdDSWJrQzF5?=
 =?utf-8?B?RXRjT0Z3TDdaN1RtSjMyM2pKdTI1T3ROcXFDMURWaWtZTE9aeS90TmVQWWJi?=
 =?utf-8?B?Q2tHL2oxaVp6NUlYZlpQbWQzbGU2MnhsVzg3Um5yeFEvbXRybFl3Wk9LUDZ2?=
 =?utf-8?B?UktaemhHcUpudTNDelRiOTRpN0tNcGN5cDErbDZhUmJTSEpOUU43TGEybnJN?=
 =?utf-8?B?Q1lJRlFPVHVKaE9ZMjErbnFCUTF1ZHV6SUgrNFpMSzdxeFdxamxiTHlQZ1ZH?=
 =?utf-8?B?TDRWcjVVTTAwS3RmOEpubzNHQXEyQlltdllaQ0VWWnJZTTZDZnBwT0ZGQW1m?=
 =?utf-8?B?MEt1M0p2cWVGRlpxbE5HN2xOcm54UU9CcEovZW0wMmVUdkg3bEM0YU9vUGhI?=
 =?utf-8?B?WTlvYXhBWkdMSTU5WWpNaitLdU9BSUpVQm5mdkZ2c1psRUNhZlI2Y1Q4UFJI?=
 =?utf-8?B?Rk9MbUpTMEdxdHpFYkxLZCt5dUg0bTkrNDlPSWlpL2NJVXc3Z2Jtbmhab3dW?=
 =?utf-8?B?VVl3K21HS0tvZjVONDcyQXg5cm9TL0wyMVYxK2pTaGRZT1hxdFVORVZkS2NT?=
 =?utf-8?B?Umw5YURUdTVtNHU1Qi95M3pTZ2Q1OHBub3EvY2E1bUVJdGlna2JSdFhPRUpV?=
 =?utf-8?B?WE1EaVJDYmExMmlEcjNObXNtUXVDWWdyMERBUWF4aU1jK2I2MXQxdjd3NVJW?=
 =?utf-8?B?VmJ4U1lqWmpkbCtDTUNWdGJTN2JTdWQ0VXhRL1FnT1F0amtuN0NQY0tKVWxH?=
 =?utf-8?B?MDg3NWFZWFgxaFE5cnI1WEJuZ3NXNk5nYkFmcU5MclhLMmdELzR2VGd4c1My?=
 =?utf-8?B?M0prenF1ZVJsSXpQTEg5NTBtRkF2QjFEVXRTNWNRV0dPeXJiWnE0UjZHNk03?=
 =?utf-8?B?cldHcUI5NndFYlNrUEo3UVdtay9TOEo5OWpLbG8zV1lhT3hpd2c1Zk5lQTky?=
 =?utf-8?B?UlVBNUdiNjJGUFJLSGpvcVcxd0oycng2RTh3VlYyV3hFWFVQVWhXdXRPdHdK?=
 =?utf-8?B?aVh0R3NlVWh3OEQ0SGdaNGZ6Q01qS1MxN2VmVmlhVVZkSkZhU3NPZFJkK1hU?=
 =?utf-8?B?ZU1zdXlVWmJZbHVrenkxK0lLdEUrSkZCa0w2TDhHQUEwRkE3M0FBSHVBZkVT?=
 =?utf-8?B?dzA1YU5YNmd2RHJ2M3RkL0VSaUs0N1FYVXNFTFJjcGxJbnRqalZmZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3884E3B33B320341B94CB816E5FFBD3C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54860dc1-98ed-44aa-3b75-08de62524172
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2026 11:57:35.8012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lg9Ksv8SKPcGEJ2g9rOvA/1XhWOE6gDAEisEIzVOpuoPFDbreLhXH+oUoNF6e3Zjbhoy+pd67z231upYz2WHBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5326
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69839-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 1AD54CBF58
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAxLTMwIGF0IDIyOjI1ICswODAwLCBHYW8sIENoYW8gd3JvdGU6DQo+ID4g
TGV0J3MgbW92ZSB0aGUgZGlzY3Vzc2lvbiBoZXJlIChmcm9tIHBhdGNoIDEzIC0tIHNvcnJ5IGFi
b3V0IHRoYXQpOg0KPiA+IA0KPiA+IElJUkMgdGhpcyBwYXRjaCBqdXN0IHNpbXBseSByZS1wdXJw
b3NlcyBjb3VwbGUgb2YgcmVzZXJ2ZWQgc3BhY2UgaW4NCj4gPiBTRUFNTERSX1BBUkFNUyAod2hp
Y2ggaXMgcGFydCBvZiBQLVNFQU1MRFIgQUJJKSB3L28gZW51bWVyYXRpb24sIGV4cGxpY2l0DQo+
ID4gb3B0LWluIHdoYXRldmVyLiAgVGhlIGNvZGUgY2hhbmdlIGhlcmUgZG9lc24ndCBldmVuIGJ1
bXAgdXAgaXRzIHZlcnNpb24uDQo+ID4gDQo+ID4gSUlVQywgaWYgdGhpcyBjb2RlIHJ1biBvbiBh
biBvbGQgcGxhdGZvcm0gd2hlcmUgU0VBTUxEUi5JTlNUQUxMIHN0aWxsIG9ubHkNCj4gPiB3b3Jr
cyB3aXRoIDRLIFNJR1NUUlVDVCwgdGhlIFNFQU1MRFIuSU5TVEFMTCB3aWxsIG9ubHkgc2VlIHBh
cnQgb2YgdGhlDQo+ID4gU0lHU1RSVUNUIHRodXMgd2lsbCBsaWtlbHkgZmFpbC4NCj4gPiANCj4g
PiBIb3cgY2FuIHdlIGtub3cgd2hldGhlciBhIGdpdmVuICdzdHJ1Y3QgdGR4X2Jsb2InIGNhbiB3
b3JrIG9uIGFuIHBsYXRmb3JtIG9yDQo+ID4gbm90PyAgT3IgYW0gSSBtaXNzaW5nIGFueXRoaW5n
Pw0KPiANCj4gR29vZCBxdWVzdGlvbi4NCj4gDQo+IFRoaXMgaXMgYWN0dWFsbHkgdXNlcnNwYWNl
J3MgcmVzcG9uc2liaWxpdHkuIFRoZSBrZXJuZWwgZXhwb3NlcyBQLVNFQU1MRFINCj4gdmVyc2lv
biB0byB1c2Vyc3BhY2UsIGFuZCBmb3IgZWFjaCBtb2R1bGUsIHRoZSBtYXBwaW5nIGZpbGUgWypd
IGxpc3RzIHRoZQ0KPiBtb2R1bGUncyBtaW5pbXVtIFAtU0VBTUxEUiB2ZXJzaW9uIHJlcXVpcmVt
ZW50cy4gVGhpcyBhbGxvd3MgdXNlcnNwYWNlIHRvDQo+IGRldGVybWluZSB3aGV0aGVyIHRoZSBl
eGlzdGluZyBQLVNFQU1MRFIgY2FuIGxvYWQgYSBzcGVjaWZpYyBURFggYmxvYi4NCj4gDQo+IElm
IHRoZSBrZXJuZWwgY2Fubm90IGxvYWQgYSBtb2R1bGUgdXNpbmcgdGhlIGN1cnJlbnQgUC1TRUFN
TERSLCB0aGF0J3MNCj4gdXNlcnNwYWNlJ3MgZmF1bHQuDQo+IA0KPiAqOiBodHRwczovL2dpdGh1
Yi5jb20vaW50ZWwvY29uZmlkZW50aWFsLWNvbXB1dGluZy50ZHgudGR4LW1vZHVsZS5iaW5hcmll
cy9ibG9iL21haW4vbWFwcGluZ19maWxlLmpzb24NCg0KVGhhbmtzIGZvciB0aGUgaW5mby4NCg0K
SW4gdGhpcyBjYXNlLCBJIGFtIG5vdCBzdXJlIHdoeSBkbyB5b3UgbmVlZCB0byBpbXBsZW1lbnQg
Y29kZSAocGF0Y2ggMTMpIHRvDQpmaXJzdGx5IHN1cHBvcnQgNEsgbGVzcyBTSUdTVFJVQ1QgKHdp
dGggYSBjb25mdXNpbmcgZG9jIG9mICd0ZHhfYmxvYicgbGF5b3V0DQpkZWZpbml0aW9uKSwgYnV0
IGhlcmUgZXh0ZW5kIGl0IHRvIDE2SyBpbiBhIHNlY29uZCBwYXRjaD8NCg0KSG93IGFib3V0IGp1
c3QgbWVyZ2UgdGhpcyBvbmUgdG8gcGF0Y2ggMTMgYW5kIHBvaW50IG91dCB0aGlzIGZhY3QgaW4N
CmNoYW5nZWxvZyBpZiBuZWVkZWQ/DQoNCkUuZy4sOg0KDQogIEZvciBhIGdpdmVuIFREWCBibG9i
LCBub3QgYWxsIFNFQU1MRFIgYW5kIFREWCBtb2R1bGUgdmVyc2lvbnMgc3VwcG9ydMKgDQogIHJ1
bnRpbWUgdXBkYXRlIGZvciBpdC4gIEludGVsIHB1Ymxpc2hlcyB0aGUgcmVxdWlyZW1lbnQgb2Yg
dGhlIG1pbmltYWwNCiAgU0VBTUxEUiBhbmQgVERYIG1vZHVsZSB2ZXJzaW9ucyBmb3IgaXQuDQoN
CiAgVGhlcmUncyBubyBoYXJkd2FyZS9maXJtd2FyZSBpbnRlcmZhY2UgdGhhdCB0aGUga2VybmVs
IGNvdWxkIHVzZSB0bw0KICBkZXRlY3QgYW5kIGJhaWwgb3V0IGVhcmx5IGlmIHN1Y2ggcmVxdWly
ZW1lbnQgaXMgbm90IG1ldC4gIEl0J3MNCiAgdXNlcnNwYWNlJ3MgcmVzcG9uc2liaWxpdHkgdG8g
bWFrZSBzdXJlIHN1Y2ggcmVxdWlyZW1lbnQgaXMgbWV0IGJlZm9yZQ0KCSAJDQogIHBlcmZvcm1p
bmcgcnVudGltZSB1cGRhdGUuDQoNCkFjdHVhbGx5LCBhc3N1bWluZyB0aGUgbmV3IHNwZWMgd2hp
Y2ggcmVmbGVjdHMgMTZLQiBTSUdTVFJVQ1QgaW4NClNFQU1MRFJfUEFSQU1TIHdpbGwgYmUgcHVi
bGlzaGVkLCBJIF90aGlua18gdGhlIGZhY3QgdGhhdCAic29tZSBvbGQgU0VNQUxEUg0KdmVyc2lv
bnMgb25seSBzdXBwb3J0IHVwdG8gNEsgU0lHU1RSVUNUIiBwcm9iYWJseSBkb2Vzbid0IG1hdHRl
ciBhbnltb3JlLA0KZXNwZWNpYWxseSBpZiB3ZSBhZGQgdGhlIGFib3ZlIHRvIHRoZSBjaGFuZ2Vs
b2cuDQoNClNvIEkgZG9uJ3QgcXVpdGUgc2VlIHdoeSB3ZSBuZWVkIHRvIGtlZXAgdGhpcyAiZXh0
ZW5kIFNJR1NUUlVDVCB0byAxNktCIiBhcw0KYSBzZXBhcmF0ZSBwYXRjaD8NCg0KQnR3LCB3ZSBh
bHNvIG5lZWQgdGhlIHVwZGF0ZWQgZG9jIG9mIFREWCBibG9iIGxheW91dCB0b28sIHRvIHJlZmxl
Y3Qgd2hhdA0KeW91ciBjb2RlIGlzIGRvaW5nIChyZWdhcmRpbmcgdG8gaG93IHRvIGNhbGN1bGF0
ZSBTSUdTVFJVQ1QgYmFzZS9zaXplKS4NCg0KQW5kIHdlIG5lZWQgdG8gbWFrZSBzdXJlIHRoZSBU
RFggYmxvYiBsYXlvdXQgaXMgYXJjaGl0ZWN0dXJhbC4NCg==

