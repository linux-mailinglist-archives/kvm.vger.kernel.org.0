Return-Path: <kvm+bounces-51024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6543EAEBD66
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 18:31:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE7CC6A4F82
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:29:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06742EAB78;
	Fri, 27 Jun 2025 16:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WNvktq7g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B711C6FFD;
	Fri, 27 Jun 2025 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041744; cv=fail; b=Q3cEFP0f7RySoctB2bB9q1/2IdktyVECBElygeCoNlaoFcA2EbHiC7N9aancchBpAjivefmI/ArZ3I++8FpG3+Tw/ah1OK6CaMWeDpZFJ/W3BY9CtudJqg8i+MhseLlEAwQsutyYa/FTtbEbd44IKQLnNu9NB3bxt0nBIqKeu/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041744; c=relaxed/simple;
	bh=XQiP5/3utCsk1/6me6Hjv+PC93A+53300ILBT5zXaas=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hCszUUM7VKar7mKMGL0vh1WqWMrEVprMx+IVUnioWUamR1ZISuXwxIydfgM1GtA9ASiHboTv4++0hhMlWlsp8hLPEta4drHt/7700sT+kbxM46iftsrqB20klk4iZDV5lLuMPAdHNOFmwNYPcvcpgBmSB0u9rCsvhnLc5niRNqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WNvktq7g; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751041743; x=1782577743;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XQiP5/3utCsk1/6me6Hjv+PC93A+53300ILBT5zXaas=;
  b=WNvktq7gOMfI7NAKL0l6LrOECcY7MekB1mmsTJbhrerbXLAN44lYWCpr
   DC5ga/AcWB7NCqQ4L2KwaGzlEWwzbGl3nJS8TpOlw+P2siq+0tiymsRt3
   7baaVKyuIejwF09aRm9QMa5zalRWT5C3asOmMspzskj8U91vMfvDB3HYN
   zGSqK6L35BJHYx22m6e4tz6uSxNA+StETSpWcZugZQUsRoCfBwYB4Y195
   psJn3FbYw0ww7gfzR2c4w6/cZIRxTL3bebOSV3MDHZEjMbERIkZrwL+th
   DRwuPKkbtfoFQ39oVO2q0CPp5wVMaNWlQK++TlbQ4ILctBE21IWTaoUJK
   g==;
X-CSE-ConnectionGUID: DNcv4OD5QxSehXWTQ2i/og==
X-CSE-MsgGUID: PljZILihTRuJJ6vYFDWO6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11477"; a="57037027"
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="57037027"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 09:29:02 -0700
X-CSE-ConnectionGUID: V6PmzpGiRT+T3+af4qhnMg==
X-CSE-MsgGUID: IplEDbs6T3Kj50WQe22sOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="152370165"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 09:29:02 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 27 Jun 2025 09:29:01 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 27 Jun 2025 09:29:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.72)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 27 Jun 2025 09:29:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ccK1O/CMAKdk9zCHOztQoIVdnQC/VKxTKYgDOTv/tfkryGoaThex091DWzM8V5kg7CnrHoveWJlX7AB6W733mmdW3HpoMFcxZOdueBkSAGOV/3ehhlY1y6nDC0ABweTFOep+jTr/V3oFgaghyd5OKx2spwQTaGnxN3DBFhItWF4RSAHWRhiM+szwiXYxi5yrfGU8FW3uAHPXADB9uWE48R6UCYZ7YH7VLj0VEQ/WEps/jQUfbNAFp/d14/Gs22iQrIfAkGQ7P0TOotbHFqNQYwiO6vdlrNTAWyqNbZZqQL5wWIMDVnkykQxO+33hC0ez99c2GQpuBFoZP1dLHBaA2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQiP5/3utCsk1/6me6Hjv+PC93A+53300ILBT5zXaas=;
 b=L2cY4A5tbWeirY81L1pqKFb74IEjKT+mHRr2ac1KvwDh6QJ5of7gSIjF+JBt8P1z44ixE+PKQdSwmlKWzEXkTb4+JlpQx3nwfiWGzb/Pwe/WWY+ePDWhj5mgeEx/GFy0jLVA8RQSMCytvECCGSIEKQr9S+3zDX2lYCeOGFGnrHbkCXrc5/lDw1x4/otIddqvhhAkK81kzW4mIFWGaRdavleEiagw4wA/SxRdTdMvmxTLgHXHLOlAdg0O7u/6MUr8SRBd38XqI+FpJb30WUvyEqnp1dnWLiI9lT5r3ip8EwXYqhnvgXMV2n9dAEQE2HbDKmiRQ3mRaNcdObzVmB3dug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CH3PR11MB7940.namprd11.prod.outlook.com (2603:10b6:610:130::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Fri, 27 Jun
 2025 16:28:42 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.8880.021; Fri, 27 Jun 2025
 16:28:42 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Hunter, Adrian" <adrian.hunter@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "Annapurve, Vishal" <vannapurve@google.com>, Borislav Petkov
	<bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
Subject: RE: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Topic: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Index: AQHb4Em/xH1txe69zU+wjMA9RpcOPrQJAXsAgAFgjQCADMwmgIAAEbfg
Date: Fri, 27 Jun 2025 16:28:42 +0000
Message-ID: <SJ1PR11MB6083B94467DD85C8C2DF33D9FC45A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
 <20250618120806.113884-2-adrian.hunter@intel.com>
 <487c5e63-07d3-41ad-bfc0-bda14b3c435e@intel.com>
 <ccee2a0f-18fa-4037-bf97-f359e0791bf6@intel.com>
 <d443db90-ced5-43d0-9f85-ad436e445c3a@intel.com>
In-Reply-To: <d443db90-ced5-43d0-9f85-ad436e445c3a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|CH3PR11MB7940:EE_
x-ms-office365-filtering-correlation-id: f12b7c99-8529-4474-68b7-08ddb597ae18
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?M0JCSkhKeENlUkJmYlkrTTJaWk03d25OeVp1d09TVHM1alYrSm9jVnZTYkZN?=
 =?utf-8?B?WHB5QjQyNUM0eW5DbDhjVkc3KzJwLytZalRuWUtIang1ODlPa1FnRzgwL0Ns?=
 =?utf-8?B?bWlPWFU5TFh1Z1dIdWxVaVVacURCRE5RNXM1Tm5iVHdWOTVxWUtXV0RCN2M5?=
 =?utf-8?B?WEtMSmVBTTZOa0NleFhpUzU4YWRyQTNmM3dHMTRBbDJObkpTcHpsVTl6YzZR?=
 =?utf-8?B?eHJFSVd3bWk2MXpXQ1Q0YnBRWDF1QW9NMG40KzduQlZ3U1laVzJWRFFVQ1U0?=
 =?utf-8?B?OTBqdmZYMWJxRUF1a0RYeVVOeDZmUmE0L1NqWWpDRzFPNVJiR3VDdTMxbTdI?=
 =?utf-8?B?ek1aVW1KanVDU1BaeURvTmdtQlU5NUVJOUVSQXRac0xRcGhFOVc4MS9CQ0pF?=
 =?utf-8?B?allRb2YyWWEyb1AzaDRJT3c0bVNCRXFWVTF0U3NiYTNvWm9jWUJqNGtjWjlh?=
 =?utf-8?B?MlFIRHVDRDdsZTVDOUhuR1YxNElOanlnd0VWY29iK3QvQWxFN1ptNDB3Y1Zt?=
 =?utf-8?B?Y2IvU3MzV3FRblkweTlyNG83VW1uSTcwbmZaQmRZaWgyS0N3QThKc2ZlUndM?=
 =?utf-8?B?VTQyNHFsZ0JNTFdZY2lzWmlXNkxLeDNSRjFzRXpLSDFxZ1NwVitFSFRlbDkw?=
 =?utf-8?B?T25kdytkTWpwWXBqVCtoQjBuNnUxQW9LM3FHS2dubGsySWhzcXVFbDYxdEhS?=
 =?utf-8?B?NHorRG9wdUJDNTFHTUVjWWxtMDV2SExtQ0xRVGd6Z0pKVVFiNTFPbnpBWHB0?=
 =?utf-8?B?ZW5NNW5NS1ZhSHdvR0cvWVBZdE9UaE5ha08xUTNNWXNSbEZJOEJlUHNrek1j?=
 =?utf-8?B?SHN1NW4zTDlobWlzSC9zR0RsRlZMdEYrenVKVTlOTjVQdWY5b2FhMDUzS3pp?=
 =?utf-8?B?OFFUTTRzWDBQc0R2WjVTSjBSSkFabmhwOERKNnFNdktOOWl5ZVBtNnJ0YnlW?=
 =?utf-8?B?UlNWUyswQ2N6U0Y3citSdDRQRmxRRDZIaXhsVmlLZ29IaEluTmJleXMrT3Ro?=
 =?utf-8?B?V3FTU3Bsb3NST0FaYmtJMzVjcDJIcGVqSW4rc2VCR0NFY2wxeGlhTGk2ZWI5?=
 =?utf-8?B?N0VHTXdKR1F0aS9mdVFISlVkbnNTTE9wU1NQWGtoalNFVk0xUDR5aWgzclNZ?=
 =?utf-8?B?UzlqN2dyc3NaZVE5WUdQNVk1Uno3MTZoUS90WHlwTGdnUi9VOHRtZnMrNkJO?=
 =?utf-8?B?WGdUN2ZZRGcyQnp0bGVvTlYvQW1jdEdhNTZoTy9VT0doQTF4L3BjcGRXTzU2?=
 =?utf-8?B?bk9mbEhEUzZDdFFwNGxGRmJjQU9WdFV0MTNFenhRNVdaT1N3QXc4QTBHeTRj?=
 =?utf-8?B?TXYwNFA4VFJJRWczR3ZBSXByaVp5KzRwVXlObkhjTzN2cmRuazJ2elRyeG9M?=
 =?utf-8?B?UU1aMmZsd09sb3VQVC9EamIyS05taC9zdERHQUxwUUI0RE85Vm5SUzFRV3RN?=
 =?utf-8?B?MFBjdjFaN2cxVmhUelhmUXRvbXFyK2JBRUVDclFMQ29kbEVXSW80N1lSK1oz?=
 =?utf-8?B?NHVXOTVuSFV3UEJRVmtKdTY1ZnExNlpYdHY2R2pWVWtEeWJIendsR3YwM0FL?=
 =?utf-8?B?cHluVWg3RzdGR20xemdDSHpWZE5VRHlSUDZyekVDOFNOYlc1UjVrT0NlTzBT?=
 =?utf-8?B?WmdDSEkyLzg1WTIyVWROSzF6Q1ZmenIvTXhBVXZ2YW5pM0pwbkdSSEY1dGxD?=
 =?utf-8?B?RUJIRmVzVCtEMzBPYitMeWNuYWFwYWJ3bVNtWVZGR2tjcFlkZDdIenNaUGwv?=
 =?utf-8?B?YkxjaW1WODdvbTQ3VnczcVI0U3U3Sms3TC81RG15TmcvdXRXRWpSQXFFZGNz?=
 =?utf-8?B?WUo4aXB1amY3WGsyVFNpL0FpUXJQckRpakRPT0RmQjQzOGhNN21LcitpTmY5?=
 =?utf-8?B?aldKS2lYclpIWS9HT0ptOTZJa0IyVEtEUE1tT2Y4ZXowYnMyeTZtVXQwZzI4?=
 =?utf-8?B?UURFeThzZUIvQVlWWnd4Yy9vZUpPaW53VWJJemVEVE1jNEVIVjJTN1ZxbFNy?=
 =?utf-8?B?LzJNWmM2NENBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NjdkMm9nazdLUWZYcE5IbHBPRTBNS2I5U0hydVZac2pHYXFUbWNaYmYxZk53?=
 =?utf-8?B?ZnkybUIyR1ZZaC91VVRJUkZNeDM3UU9EWU9KU2VraWdMMmxENlF4TCszS29a?=
 =?utf-8?B?WXRVc0o5NHU2SFo3R2liaEJmaC9YaWJwQVZibkNCZkNPdytXRVZKU3ZnSUU5?=
 =?utf-8?B?VG9vM0EwMFc2L1F4cVJROFlwMGRtT1ZRTmdlWlJZb1RwUGdsWEN3eFNZYkkv?=
 =?utf-8?B?Ris5TzdaanZrQjk5NG5hc1FqQy9LR201WG45L3NUclFoWkEwM05nOHVTdGJF?=
 =?utf-8?B?Z0xQMEg4MkVNV0VqT0MzUmFhbDI1VDhlMUhHTCtmWkxQSTNjcnVaYXN1bUEx?=
 =?utf-8?B?N0ZMelVtbURxV00rdXphZncrQ1h0SU5ZNEx6UUxOUFpicW9rbEkyWElwazUx?=
 =?utf-8?B?d2E0QTNHa2VsZU56N0daSjROZUNWSXFGMHdFR2NYZjJTN0NTc2oveTlyeHBU?=
 =?utf-8?B?N3ZjMkVZK3VLT3l5M3lkeGhTWlVQNjhaKys5VUtLbDZhTWwySGprNzBPZWNP?=
 =?utf-8?B?QWdrcURMbTh4NThTRTNDbmJubGpiMDZKMnJiQzhjbG1EWmdJNVVPcGVHaTF5?=
 =?utf-8?B?VFUvUnBaV3ZHbVNhZ2sxWHhtK2hWdTQ5M0lGaUVnc1ZjK1czVkJ0VFl5YU5n?=
 =?utf-8?B?aGNOZW12UUlOMjluVnV5WEJ4ZTBmK3FCQmpQVDVXcmxBb1hnNXg2Y3NPZC9W?=
 =?utf-8?B?RnBEY0w2MU5sQVJtUXVBZ3ErWjlXQkJlOFg1ZVZ5Rmp0TnFlK3d6U1pMeWkw?=
 =?utf-8?B?NDFXcTF1TTVNVTNNOWNlVlNMUU8xeXY1aE8xeGd0Z3p3dnNjeEVVRTlpWU80?=
 =?utf-8?B?dUljUVZ3ZDhtaW1sMUFrK0JDZTR0WG4zY0FaK2IrVC82VW9mbkt5ZUFMQ0ww?=
 =?utf-8?B?SDJEQU01QWNKb0NPTUhLc0NpQ1JvQjZaT0RTdUZSVnFJVzhzbm9xOU5OTElx?=
 =?utf-8?B?clFxWHIzMy85STZSNW9ZL3NRa2MwT004NDhFdmFETk41cEFTeStjb284a0Vi?=
 =?utf-8?B?ek95b0c0Vi84ZnFTY2lVcmJQamN0NmtINXhCdGc3aDY3TkllUGpaUGwyekxi?=
 =?utf-8?B?MnBjdHRnQXBvdFRrMnhFaGVJRkpwMHBLSnNMYkd1VFV5aG5ldjY2NmpUaGJy?=
 =?utf-8?B?Z3BRR3dkeHhNTW9oR2FmZXhpZmZkTzExMzJHZHhXaGVQTm9ueTFzL0hwWERD?=
 =?utf-8?B?Rjhtd1dnaDBwdWtRQWJmWE1velpuM2l4enRyK1dzZGpnVDU2UzNZNXM1S1NC?=
 =?utf-8?B?MEhBd3R5bWlRMUJMenNiV1FsSW1PS1dtTURsbFE4ZFl1UVlQeGtuMCtqTGxD?=
 =?utf-8?B?VEJpaHNuaXR0a3VLK3FocERLR05TOVlSRnpGNWE3S1E2SDZ0Qm9aamlJbG56?=
 =?utf-8?B?ZzY1OXBSaUtRdUNRSnBwV0RlL3Z6V3NSeWJqL2UxWUZxQjBERzhiK1dkMmZU?=
 =?utf-8?B?U1Y3blFBQ2hMbjRIQ3RsbW8wVE5jV2QrUHczREdaUmJDNEJtWmk2NW5UMzRp?=
 =?utf-8?B?c0FadlBsZTQvTXVxbE1PSEhqcTdUMXUwNWVoS1o0Y0dTa09kUG5mTnFZVDFn?=
 =?utf-8?B?V1E5c1lkbDRhT3RyWXpQc21GMUVEQXdhZDZubW9qSExHNTk3dTdnUldEL1dL?=
 =?utf-8?B?NG9qeTJFd0lBd3VtOWVFdDg2b1lXYlpLbGRuRUVWTnZjY3FtcytFaXJ3ZVZ3?=
 =?utf-8?B?N3ZXeFV4N3JWSEg5TlQ0cjBBN1AwZVp3c1BQNHB1a0RYRVVtelluVmk4anRu?=
 =?utf-8?B?L3BIZFI2c01PNWNNVU5GeUdsWmEvcVhuZ2luSDdwMWdLa0dUY2NaOGRjNHJm?=
 =?utf-8?B?ME9hMkhUN0xrR3pBdkN2REIvSmFYWkRVTXBpSFpDSC9VMUtiRXN1N0pNYlJj?=
 =?utf-8?B?L0tMRnZKNXJ1dFFZTjZCMmdBcmZsck9mR3Y3cVlOcmdSbTNsb24rY0R0V1k1?=
 =?utf-8?B?THZGZkVGTStvMi9nQXppa0Z6dmJsR1MyN0I4K3hEQkF3VlhoY3AxN2JEME1V?=
 =?utf-8?B?QWVvSk9hT0o3czlwNkVsNk1mU3g0UXpCbUdIN3c2WU1qNWw3UUhuV2pKRlJt?=
 =?utf-8?B?cU5qZkxFRXJIWER1dHlRaTZvYnREYk5lM2xvZWhZL2diYk5Dd0pKSW1YK2tX?=
 =?utf-8?Q?tn+QAZCvlIfWRC8v4L532+zpd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f12b7c99-8529-4474-68b7-08ddb597ae18
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2025 16:28:42.1474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tUbXbOaU9fzBhSd+hJDAIn+6VeIWQGzWnCLGjLVhtZnRZKecAYucTC3XZkNSZbaUBFpY1vZ490UmyBz2iejtwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7940
X-OriginatorOrg: intel.com

PiA+PiBJZiAtPmFkZHIgaXNuJ3QgcmVhbGx5IGFuIGFkZHJlc3MgdGhhdCBzb2Z0d2FyZSBjYW4g
ZG8gbXVjaCB3aXRoLA0KPiA+PiBzaG91bGRuJ3Qgd2UgbWFzayBNQ0lfQUREUl9QSFlTQUREUiBv
ZmYgdXAgZnJvbnQsIGxpa2UgaW4gbWNlX3JlYWRfYXV4KCk/DQo+ID4NCj4gPiBXb3VsZCB0aGF0
IG1lYW4gbm8gb25lIHdvdWxkIGtub3cgaWYgdGhlIG1jZSBhZGRyIGhhZCBLZXlJRCBiaXRzIG9y
IG5vdD8NCj4NCj4gQ3VycmVudCBkZXNpZ24sIHRvIGtlZXAgdGhlIGJpdHMgaW4gbWNlIGFkZHIs
IGlzIGZyb20gVG9ueSdzIHBhdGNoOg0KPg0KPiAgICAgICB4ODYvbWNlOiBNYXNrIG91dCBub24t
YWRkcmVzcyBiaXRzIGZyb20gbWFjaGluZSBjaGVjayBiYW5rDQo+ICAgICAgIGh0dHBzOi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9j
b21taXQvP2lkPThhMDFlYzk3ZGMwNjYwMDlkZDg5ZTQzYmZjZjU1NjQ0ZjJkZDZkMTkNCj4NCj4g
QXNzdW1pbmcgdGhhdCBpcyBub3QgYWx0ZXJlZCwgYSB0aWR5LXVwIGlzIHN0aWxsIHBvc3NpYmxl
IGxpa2U6DQo+DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tY2UuaCBiL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL21jZS5oDQo+IGluZGV4IDZjNzdjMDMxMzlmNy4uYjQ2OWI3YTdl
Y2ZhIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tY2UuaA0KPiArKysgYi9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS9tY2UuaA0KPiBAQCAtMzg2LDQgKzM4NiwxNCBAQCBzdGF0aWMg
aW5saW5lIHZvaWQgbWNlX2FtZF9mZWF0dXJlX2luaXQoc3RydWN0IGNwdWluZm9feDg2ICpjKSAg
ICAgICAgICAgeyB9DQo+DQo+ICB1bnNpZ25lZCBsb25nIGNvcHlfbWNfZnJhZ2lsZV9oYW5kbGVf
dGFpbChjaGFyICp0bywgY2hhciAqZnJvbSwgdW5zaWduZWQgbGVuKTsNCj4NCj4gK3N0YXRpYyBp
bmxpbmUgdW5zaWduZWQgbG9uZyBtY2VfYWRkcl90b19waHlzKHU2NCBtY2VfYWRkcikNCj4gK3sN
Cj4gKyAgICAgcmV0dXJuIG1jZV9hZGRyICYgTUNJX0FERFJfUEhZU0FERFI7DQo+ICt9DQo+ICsN
Cj4gK3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyBtY2VfYWRkcl90b19wZm4odTY0IG1jZV9h
ZGRyKQ0KPiArew0KPiArICAgICByZXR1cm4gbWNlX2FkZHJfdG9fcGh5cyhtY2VfYWRkcikgPj4g
UEFHRV9TSElGVDsNCj4gK30NCj4gKw0KPiAgI2VuZGlmIC8qIF9BU01fWDg2X01DRV9IICovDQoN
CkkgbGlrZSB0aGlzLiBDYW4geW91IHdyaXRlIHVwIGEgcGF0Y2ggd2l0aCBhIGNvbW1pdCBtZXNz
YWdlIHBsZWFzZT8NCg0KLVRvbnkNCg==

