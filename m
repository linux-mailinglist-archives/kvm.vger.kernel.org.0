Return-Path: <kvm+bounces-28791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 814BE99D5A6
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 19:37:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1D8F1F24845
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 17:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 310341C3029;
	Mon, 14 Oct 2024 17:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b3iVIcGP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9831429A0;
	Mon, 14 Oct 2024 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728927414; cv=fail; b=hQksN2Uv2IzyO8llAdcxtlnsZpX2C1vJSuOV6/AstMf+Bz2300VupNR1T4gZDMvz7FXIFd06hplJAIbaI8OPcC+mIq6ZqRCbznE1pDpci5/Eql/hDRyFp8GDjXgTMUgumcuG6+iaKWxsSrchINioLNCEPi/ZYx5Txg1DFdFUqcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728927414; c=relaxed/simple;
	bh=Hg4xD1X/KFzmE1PBG7XmtAxaKlHsZgEWbM8MXNUCzwk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GuIqvZ18rWEpafJQVb2Z0xKlghqU8g8cJH/AvZUeoP3Hoj8qlSa3I+O3zeRqTWbpMkax+0cNK2DkFX2nAsrAGh16jOOdeue/VzT4ioi+Vghu8WCSvicAYkLh73UiQHAJVUTsp0Nl2ilgVvLfbHd4jbLGqd21dFrPREsvAdi9JwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b3iVIcGP; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728927413; x=1760463413;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Hg4xD1X/KFzmE1PBG7XmtAxaKlHsZgEWbM8MXNUCzwk=;
  b=b3iVIcGPJYowf4hpCIPyU8wZs/Mumz0LOom5rCAwv+AUCk6gSJwmKYUo
   HhZZFeYjMb0OhHtsIdWMlwHjyPnlz8LKULgLv7XfMq4N4dUJdmGdWXFld
   6Sx4iUd6Kj2uLc4jwuBy1QazuxZh/DTBm5P+p4+0897qZk+b0XUmPIISY
   ESMTxTdHjggs1yPKoSbgd52S2ihUnupdIhJD7lcDuU3KmDj8wq4RIXkKs
   XhMRtPB++nMCTwDQhlvU8OHiP6X8kVn4wWEwq7s2nfC6WkItVAGBJPGh7
   kNn4kBmX0VRJz/cnJC2lcLH6Vo1w+zJ9HxxZMmrTR+RAuudGmXTmyT2NQ
   w==;
X-CSE-ConnectionGUID: QG/WW2YuTgaS+6+7jqi+SA==
X-CSE-MsgGUID: 87pTDdKBTwC7XCwMY9as0w==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="38868229"
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="38868229"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 10:36:52 -0700
X-CSE-ConnectionGUID: 60RfCAYnSrqctgEEFnhApg==
X-CSE-MsgGUID: tBngpf9TSxmUaFmSSGLJpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="82403695"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Oct 2024 10:36:51 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 10:36:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 10:36:50 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 14 Oct 2024 10:36:50 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 14 Oct 2024 10:36:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f2q9XFVXg6sGcOZ4hsJytH5js6Xir3wlDuX2RGnG4+OozI4FlKMOVkrznRlmgCqtx0sM4rGXz8cbmgZEvNhpo61PYG2HX4hpE3iO7SGZuJVtlIZ6lsfspvukle0d6UP/vsU0NlyuwBSnHg7JSUFKt+RLLu0LPPgxupCF8fBYndn/QyEG3M6v8iiOB43gpblpoRGxE94YnwiCTDs0q05Sz4tpv0piXS9xXPccZXUeYTNyWX/i7VceIdD5GjhtgVLp7WOD+N4HDuRci2foj7zi/GPfTfeJbfEBR4rl+hGHvSkFdmnJv2+TZ5yCm98wXGRCOQoN7Oz3dOpOxYf3dYsSoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hg4xD1X/KFzmE1PBG7XmtAxaKlHsZgEWbM8MXNUCzwk=;
 b=QFEwRdD8duXBnypmmTGS6GqItJfWxxiVbCzo1q55kRc5x2dCsPO3NIsHI2n6vCkC9Z/w4uw2LFWOtGy9fgLuBDVvlPPLh5kmsMBbgfLHfxITDZE4DVMeAxWJE+EVIfKzjndDZvCK2eFSSv1xrj6d1Q1ATG1qcKpBA7QJgmnucwEPgm3vte08tgfcS7xPA/nlDkdvJLDFDIPhN1sAdngE8IL0ZJsY0ce+2nrQGvZcFwd4g1gG0uSB5d41S58XsPhpAz1GvJ/RBkhHesmxVWwULiNsdJIb6vulJqOYI9Qr+zcvOcVaD433obzlorNiY6q/ALFaWAEsVnDEb2cF00lslA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6171.namprd11.prod.outlook.com (2603:10b6:208:3e9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Mon, 14 Oct
 2024 17:36:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 17:36:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yao, Yuan"
	<yuan.yao@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
Thread-Topic: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Thread-Index: AQHa/newpsWgW6BkgUyDF9VgqodFjrJPnCEAgABS34CAAA3agIABDTgAgAAL3ACAABXhgIAAC2gAgAAItQCAABS2AIAEHmMAgACTNQCAAQ19AIARYacAgBSwvICAAoX8gIAAzAUAgABIogCABZFGgIAAcFaA
Date: Mon, 14 Oct 2024 17:36:48 +0000
Message-ID: <ed6ccd719241ef6df1558b69ec81073a3b3cf77c.camel@intel.com>
References: <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
	 <ZuBsTlbrlD6NHyv1@google.com>
	 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
	 <ZuCE_KtmXNi0qePb@google.com> <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
	 <ZuR09EqzU1WbQYGd@google.com> <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
	 <ZvPrqMj1BWrkkwqN@yzhao56-desk.sh.intel.com> <ZwVG4bQ4g5Tm2jrt@google.com>
	 <ZwdkxaqFRByTtDpw@yzhao56-desk.sh.intel.com> <ZwgP6nJ-MdDjKEiZ@google.com>
	 <45e912216381759585aed851d67d1d61cdfa1267.camel@intel.com>
	 <08533ab54cb482472176a057b8a10444ca32d10f.camel@intel.com>
In-Reply-To: <08533ab54cb482472176a057b8a10444ca32d10f.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6171:EE_
x-ms-office365-filtering-correlation-id: f2a2a8e7-7dcb-4a91-d6da-08dcec76c7eb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UHplNk1YNmVrcVAxWVdjenN5dnNMeU02T2xtZGljWlhLb21hUWNvN1dWYlRC?=
 =?utf-8?B?ODh5QjFaWXNWd0QzSmtodTRLcnJxbGViMG1NVysyVzBIVmQ0R05DUWd4bzhX?=
 =?utf-8?B?ZG9RRXpnTElFUGE2UTd5V0pVY0F5NERuUFgwN09PSWhDZ3JoWHNKbW52QUxP?=
 =?utf-8?B?Z2tzekFsQTh5Q2VTZXRUa1I0RkVCUVdwWTlZWThWbDYwdDlsSnFIQ2thSHRP?=
 =?utf-8?B?UzdzcHBrcnBGMHFSYkRGczJhYzZ1SUFhTnl1SzNSMlpCVURJdUVFaTA5ZlR1?=
 =?utf-8?B?blZEclNhSXFheVkyZEcvSmtwNFVVei9COGFBRllqSHQybGFHLzh0ODNJTE9l?=
 =?utf-8?B?b3A0cFcxSWozcEFHajZEdUxLWjQyNWNRdkdNQlZuYWdNRnRNaXpSTVB1aXNo?=
 =?utf-8?B?OWhZZkpDSWdxVGJhd0U5eDFRekMrZFIvRk1WV2ZualJ4a2UxczJFV0wrM3NE?=
 =?utf-8?B?LzkxZ0wyNXVmSW9tWldNM3djMkFQRFU2TEtHN01SeXZGVmgvSW93NDJubk5o?=
 =?utf-8?B?T0kzNW85ZGJ0MGh6bVl0aGRQTEQvQTBkZHQzQzY1dUhIbERWL1RpYU9oRWkx?=
 =?utf-8?B?bUFzelpjTjZzc0srL2VFT3IxSFo4S0FoTWI2QWxraGp3WEdnU1FYa0JGUXln?=
 =?utf-8?B?M2UyN0xtMUQ2YTYxTUk2YURyekR2SFZ3c0R0cmtOdGNvRkJKZXZqcHVSay9U?=
 =?utf-8?B?aXVsemxGazJDWlBWZHRyeXozV0lhTENjWGVVUjBuKzZaUDY0VE8zOWxvUjZE?=
 =?utf-8?B?Q3AyU2dtRFdiTE1XU2R2dmoySVVhNHV6UmsrYTdadXBTQ29rd01xVWxZaVNv?=
 =?utf-8?B?NDVXWm04Q0dYcXFVaEUyNUlHVmJrL0l2Ti8zSVREMkUrZkxlY1UvWUpKakc4?=
 =?utf-8?B?cS9GMzhPZEdzTC9HYks4WnUxRHZyakV3ZEV5V2RQb2ZCd0tnNjJDQ3pKL21p?=
 =?utf-8?B?NGRzcWF6d1VUMUNvMjNQV0hyRDFWOG1zOTViaE1lcW5PM0l6ZXNnSkVFTnRz?=
 =?utf-8?B?cS80V0RHMzFWMVJsM1Mra1QyMzZYcDZMcE1ORUhIUlp4MFRJeGZ3d2hmUGJD?=
 =?utf-8?B?RlNqM2orRUtYSlVmTFVvd0h2b2tNem93ZVBWTnR0K3ZTTjRYVUUwMDlMUFBl?=
 =?utf-8?B?d1ZaNHVac3ZHSDI5NFJuQzBxV0l3N0R5SU56MTJXUzRUYnR4U0c5dlZJbjY2?=
 =?utf-8?B?WEl3SmlmckVsWXM2YWJna2NPZTlCemVaKzI2aGNmK2dUUEtVdUR5WG84c0lT?=
 =?utf-8?B?TnU1bU9xdHZENzV5cWdGTEZ2TmlwYS9uc3VnRDVnMzZEQ0FLTlpvQjVqcys0?=
 =?utf-8?B?WVJZTTJsYXNuSUUxSDRGTnk0Wk9RUk92SVhWRGliWmFFSHV2NnNnUmxDSWlY?=
 =?utf-8?B?YVN1b1ZhY2JrSzAwU1FKS0RIVm9VMkUwbGtJV0F5dCtuZ25UWHYwOWcvSHpR?=
 =?utf-8?B?SmcwNk9MblVzNFA0WU5QbXRZUzdpakNsTUR3c0hXZHFkditENEZSMk9NVVZ5?=
 =?utf-8?B?WVNTdW0raEV4MGdTZHI2dTdvdHVLUzkrQ2ZPa1lRWGRsUWNNQ0FHOUYyRm9i?=
 =?utf-8?B?UEZoV09JL21jRXAwRzF1YkF0MjR0MXppU3dKQTFRUlJza0RxL2RXTHRJcUZh?=
 =?utf-8?B?Wk9oUUFSc0dFKzNzVm9iVHhWWkxTZ1JkUTJiTlp3cnJRY3VoTUdUMUVTakwz?=
 =?utf-8?B?cmJ1emRkVnJtNjRoY041d21sVWV0Ny9PMnM4cDdib3ZhRjJ4cEhXR2FrWDRG?=
 =?utf-8?B?V3RtQy8xMUJNOTB0eWRFK2RxMGJkcktxRnJVYVlWVk9oa3ArNGJhQUV3eHdh?=
 =?utf-8?B?ZE93dFV4MGY0Y3ljNG1JZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WnE3MFlKRnVjaGYrdlQrc0YyVFltVkZEcm52WHBvTE4zMGF0eXBNOURQSlJl?=
 =?utf-8?B?SEM3djR3TG4wMmxzVEVWUGVxRGlCSy9yVnlLOUd2Z2tiVWRtWjNiQkJUM29l?=
 =?utf-8?B?Rm5uTUdhZHlzcEVwUG5hUXBrU1dYZkFaejI4MXRpVFl0bTJFVHNNNzFsZDg5?=
 =?utf-8?B?NE56ZVp1MGRKb2wzRGFoK0EvcCtJckluV2srWXdaOW5YeTAyWHUwUzBoT3Zo?=
 =?utf-8?B?cnRkV05BRXB4dFdKUWw2NG85NmRrMlRPYkVibklHaGxTZzgxVG5ZNEwxVHoz?=
 =?utf-8?B?b2c0bXBmMktwRXYxVkpHRTFYWXZERjc2ZjNJOCtnalU2azFTbmlFNEIzaVJk?=
 =?utf-8?B?akwrWUpmSDFYak9iQVRXbklJVG9wVmloWHF5MHRKR21hZWRaZUhYNDI1L1Na?=
 =?utf-8?B?cXBHY2VBQ05tU1pZenVqL3B0Z1pTVk1ESWY4K3d0Um4vV3h6WUdVL1ZObmVv?=
 =?utf-8?B?Mlg0Z3BiYUhKaG1xWnFoTE1sem9Hb0VRUTNWNWxySkZTUkRiR0RLaDVaZ1Nn?=
 =?utf-8?B?eGs3K3VJTEo4K2x3V1pNVGU3b0t1MitvNTNUbk9mVXF3UytodzNjMEdCcndl?=
 =?utf-8?B?ZE9pQnhyKzNndHkrYjBYaUJDdmFnK0FKUkExSlNHNlVSRXFrWXpKbXRqLyt2?=
 =?utf-8?B?cWozbnlSWS9UMTl1bFhZRm5uNGZXYlh6dTZFQzJGa1FObVBvNlpWbmpPaW1w?=
 =?utf-8?B?TVFKdWgySVNPQ096VmUrclJ0VHExKyt5ellUUXBWNDBDNUUrc1JuamtJcTRq?=
 =?utf-8?B?aloyb1hJV2pNRWFYMThCYStyU2JNbnVUSjZtV3l0bFhIcEZtZHBtM2xSVFMw?=
 =?utf-8?B?RUxENTRqTk9XT0JVcG1WOVczVTNZZktIV1IrQjdTMVNOREhTQjB4Y3ZtYUtU?=
 =?utf-8?B?RGFvaDZyU29HakVzZHJETU9MVGRoU29ZaDZBVWExMjErZzBDWlptWUNuVkgv?=
 =?utf-8?B?SEJZdHpYdFgrZTIxNHF2ZG5rQmZhVG9QWGdFYXRaTmxtcERvTWY2akZCd1hD?=
 =?utf-8?B?aXdiVk9jNERZRFpaN1B3ME5PZjBIUXU0MWM0QWJ4a1B5bHFxUzZQQiszYjdC?=
 =?utf-8?B?elYveUVkMFVpaGpOVUJ4ZStzWVZ4N3Y2dWFpODZJYTZCNWpiT0VPVE95Y2Rj?=
 =?utf-8?B?a21PcVgzdzBiZ1FkcEsvYWJQb0M1MzJYZlVDQlh1RWFCalRlRjkrblVUQ3Fr?=
 =?utf-8?B?bDZVUWJsNTFMNWdmSGhHRVU0clR2L2F3U3dBRU9ZaExnSExTN2llem90cHpQ?=
 =?utf-8?B?VkRUTXZSbGR6amRLQmhoZ1hKNUZwaWVJamtSK2J1Wk5OU0VpQVRaQVJ1WmF1?=
 =?utf-8?B?QmMrZkdhNW1KcmRDS0RuT0pOZ2ZNZGhZQVFoN3ZUSkpHT2tpVlVyL0M1V3lG?=
 =?utf-8?B?WDBadDdLMTVtUWo0b0ZSWVdTYTYyNzQvVHRGWXJpQTNnNkJJV0x0dktRTXF0?=
 =?utf-8?B?dVFtdTVBSXJVbkZLNkNlSm96QXMxbFhoeFl2Tit5ZHRGUTgvUWRCN2FWQURz?=
 =?utf-8?B?eGpaTHJYZEFWOWJUMnY2Tnd2THpEZVg5NmpPL0JEcFBmdDd3WDlQamZyNEZu?=
 =?utf-8?B?Mk1VQnN1Yk4vblRlT09LOVlmdGJkWUhUQzdQU25iSGFCeGlYRjdoYWRhQXU3?=
 =?utf-8?B?dHg3R01aZmx2TkpSbDFUL2ZDOTViem94UHJvNXFEUG9ieFlhWjZDZU9ja3Uv?=
 =?utf-8?B?Z1QwREdOSGZYSzZuSnFkckxyWFVTb2lkVzR5SDFsSVNRY2JRYldhZVI4QStm?=
 =?utf-8?B?RnVkOVdPelVGZ0F6RmRYN1AzU0h6K1l0bHg0SkhyendrNEw3ck5laHVkZ3M5?=
 =?utf-8?B?T2RSbnhmTzZieFY2N1h3QUNqQnYzODlQblBuQ0VSbkJZbjBCSi9Bd1Bza0lR?=
 =?utf-8?B?N3ArUUw3NmNkek9RQkpZaDZxd1VndzFCQnluY0tzTmorRzNvWEt2eEVnRmJI?=
 =?utf-8?B?T2dvYlBBV2dhWStTblppbTJmVzZ1QUh2elBjSnlGZWRzM0ZNL21QZ09qQmxv?=
 =?utf-8?B?czJCOUtOdGUvdmVpSDRUK0VDbXYram9oZmRzMUdvemlxWE5JamNmSUVHYXh1?=
 =?utf-8?B?cHM5Y1FWQ0ZFaVBYVE5WWjRRd0pxWStueEJ3TGtMRm9lUUZyZ010QWRITnE5?=
 =?utf-8?B?ZFFRT2NtWUlXNG12cVVHbnZGWjZPQ05EL09XUkZPMmwxSVhmckxhUTZvUE5K?=
 =?utf-8?B?cGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <45E48BBD68499549AB9352B79B2FA7FD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a2a8e7-7dcb-4a91-d6da-08dcec76c7eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2024 17:36:48.3855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H6diMqZ87l7w/OQ07uBN0JeJe7DifaW5i9CHwOfGTBfLydJ1kjxk7xUIRMTug6Jw04IYPn0No9hd9GftYkPoo3Tr2OOOSiIq3FJ/Xkj7bFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6171
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTEwLTE0IGF0IDEwOjU0ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUaHUsIDIwMjQtMTAtMTAgYXQgMjE6NTMgKzAwMDAsIEVkZ2Vjb21iZSwgUmljayBQIHdyb3Rl
Og0KPiA+IE9uIFRodSwgMjAyNC0xMC0xMCBhdCAxMDozMyAtMDcwMCwgU2VhbiBDaHJpc3RvcGhl
cnNvbiB3cm90ZToNCj4gPiA+ID4gDQo+ID4gPiA+IDFzdDogImZhdWx0LT5pc19wcml2YXRlICE9
IGt2bV9tZW1faXNfcHJpdmF0ZShrdm0sIGZhdWx0LT5nZm4pIiBpcyBmb3VuZC4NCj4gPiA+ID4g
Mm5kLTZ0aDogdHJ5X2NtcHhjaGc2NCgpIGZhaWxzIG9uIGVhY2ggbGV2ZWwgU1BURXMgKDUgbGV2
ZWxzIGluIHRvdGFsKQ0KPiA+IA0KPiA+IElzbid0IHRoZXJlIGEgbW9yZSBnZW5lcmFsIHNjZW5h
cmlvOg0KPiA+IA0KPiA+IHZjcHUwwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2Y3B1MQ0KPiA+IDEuIEZyZWV6ZXMgUFRFDQo+ID4gMi4g
RXh0ZXJuYWwgb3AgdG8gZG8gdGhlIFNFQU1DQUxMDQo+ID4gMy7CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEZhdWx0cyBzYW1l
IFBURSwgaGl0cyBmcm96ZW4gUFRFDQo+ID4gNC7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFJldHJpZXMgTiB0aW1lcywgdHJp
Z2dlcnMgemVyby1zdGVwDQo+ID4gNS4gRmluYWxseSBmaW5pc2hlcyBleHRlcm5hbCBvcA0KPiA+
IA0KPiA+IEFtIEkgbWlzc2luZyBzb21ldGhpbmc/DQo+IA0KPiBJIG11c3QgYmUgbWlzc2luZyBz
b21ldGhpbmcuwqAgSSB0aG91Z2h0IEtWTSBpcyBnb2luZyB0b8KgDQo+IA0KDQoiSXMgZ29pbmcg
dG8iLCBhcyBpbiAid2lsbCBiZSBjaGFuZ2VkIHRvIj8gT3IgImRvZXMgdG9kYXkiPw0KDQo+IHJl
dHJ5IGludGVybmFsbHkgZm9yDQo+IHN0ZXAgNCAocmV0cmllcyBOIHRpbWVzKSBiZWNhdXNlIGl0
IHNlZXMgdGhlIGZyb3plbiBQVEUsIGJ1dCB3aWxsIG5ldmVyIGdvIGJhY2sNCj4gdG8gZ3Vlc3Qg
YWZ0ZXIgdGhlIGZhdWx0IGlzIHJlc29sdmVkP8KgIEhvdyBjYW4gc3RlcCA0IHRyaWdnZXJzIHpl
cm8tc3RlcD8NCg0KU3RlcCAzLTQgaXMgc2F5aW5nIGl0IHdpbGwgZ28gYmFjayB0byB0aGUgZ3Vl
c3QgYW5kIGZhdWx0IGFnYWluLg0KDQoNCkFzIGZhciBhcyB3aGF0IEtWTSB3aWxsIGRvIGluIHRo
ZSBmdXR1cmUsIEkgdGhpbmsgaXQgaXMgc3RpbGwgb3Blbi4gSSd2ZSBub3QgaGFkDQp0aGUgY2hh
bmNlIHRvIHRoaW5rIGFib3V0IHRoaXMgZm9yIG1vcmUgdGhhbiAzMCBtaW4gYXQgYSB0aW1lLCBi
dXQgdGhlIHBsYW4gdG8NCmhhbmRsZSBPUEVSQU5EX0JVU1kgYnkgdGFraW5nIGFuIGV4cGVuc2l2
ZSBwYXRoIHRvIGJyZWFrIGFueSBjb250ZW50aW9uIChpLmUuDQpraWNrK2xvY2sgKyB3aGF0ZXZl
ciBURFggbW9kdWxlIGNoYW5nZXMgd2UgY29tZSB1cCB3aXRoKSBzZWVtcyB0byB0aGUgbGVhZGlu
Zw0KaWRlYS4NCg0KUmV0cnkgTiB0aW1lcyBpcyB0b28gaGFja3kuIFJldHJ5IGludGVybmFsbHkg
Zm9yZXZlciBtaWdodCBiZSBhd2t3YXJkIHRvDQppbXBsZW1lbnQuIEJlY2F1c2Ugb2YgdGhlIHNp
Z25hbF9wZW5kaW5nKCkgY2hlY2ssIHlvdSB3b3VsZCBoYXZlIHRvIGhhbmRsZQ0KZXhpdGluZyB0
byB1c2Vyc3BhY2UgYW5kIGdvaW5nIGJhY2sgdG8gYW4gRVBUIHZpb2xhdGlvbiBuZXh0IHRpbWUg
dGhlIHZjcHUgdHJpZXMNCnRvIGVudGVyLg0K

