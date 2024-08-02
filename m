Return-Path: <kvm+bounces-23033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D493B945DA1
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 14:06:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61FB61F232F6
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 12:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CADBA1E287F;
	Fri,  2 Aug 2024 12:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S5R2EjDB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1831314A4C8;
	Fri,  2 Aug 2024 12:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722600396; cv=fail; b=nC1i9c7+nTHWYi3vckKaHd/BfOBKSWPzw8aptu5frPMDj/C/j/OfBARAfYvQC09Awo9tLVzy+RtAMWM8b3JDtFo5AGYqNrzcE58k2c/jFI/QCaMxrzQ/W7/84S0im3l6mJ9TJTbDifxxVv5KYDGpwP/uQkVY97vlC4avnvIjEPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722600396; c=relaxed/simple;
	bh=6uXAMDpQktC0IBN2YVuJDz4KoABUVVuIvdQHCaC0CHA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WOlNjFKs6FEJxr9JnN0Xm8/UMrZ+4hXqHwV0chyHuASM/+MUwkmgSm4ETqjTnRLWwWnHiCAhkLOsI/al4uiI9HdzOqt0Y3XPPzMp1GdN3W60LMWD2h6Jm9RXLykG66ktQjA0u21Rg607uidkxafU4Dk9aM2E1cG4XcPiLp+dGyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S5R2EjDB; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722600394; x=1754136394;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6uXAMDpQktC0IBN2YVuJDz4KoABUVVuIvdQHCaC0CHA=;
  b=S5R2EjDB+TEol9MZzTYkxT9NfxAlVUmxcSak9OIgGf4YIs3nDrWuP9xL
   xMbOTbecc1GNdYM3kGPp4B+8ruFFgzTp+Ee5uVVHo3yYOykIZPkpHnOje
   DU9dobPFcGlpn3pa8I0/q9lGV5KGRYEVzGxlW9Ze+PEDG2SZqNXoTSMKu
   cJZqxpdoFnzLCbdmyqEGONUy6kMTOqBxtCGsB2iP9rEinwq5YI9R6UBou
   PYP/I/h3N2v6ru+ESW5NXYJxvIih5TDr1RRtZm2rLI0uAW/pBTpUgwnwk
   1DM7z10/0ZoAncv/0UGZhBnyApEspSa8oUAFM7Wl9g9bTheVp3KX5d6q0
   A==;
X-CSE-ConnectionGUID: 5x7vQXrZSfWCN62/EQ0Gzw==
X-CSE-MsgGUID: X2d3/jDPRamH0CP86HmcOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11151"; a="20750013"
X-IronPort-AV: E=Sophos;i="6.09,257,1716274800"; 
   d="scan'208";a="20750013"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2024 05:06:33 -0700
X-CSE-ConnectionGUID: +3aEjy3BSaGCLPZRzBuDcw==
X-CSE-MsgGUID: AgzBMNGrSoqkGJM+nCb5/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,257,1716274800"; 
   d="scan'208";a="55305292"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Aug 2024 05:06:33 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 2 Aug 2024 05:06:32 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 2 Aug 2024 05:06:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 2 Aug 2024 05:06:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 2 Aug 2024 05:06:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=voFXIXTybGFvlkcEPKNSXRcNpiK/VU6sFsQuP4TWcYMgYEUjlJTaPGuGoqtOqXmj6alKL7SegSjCk5qzsLBYLdh9Y4NQfeUvsAmBUir1mUyziMSRe9asfX6HtvdIQQrOe3sjw7RmwMhilwmcL6uhu261seZ3J9KECIc8GeOzKHWw50IVWD7lc4tcNVrcMzaecMjav9dYGLS21K+tdn20qAfbvo4syITVhGjtv8j5vO9v6OE0g9YSZX1AInM73AVa5nqWrCgrjdkqOORL1EHKhpMsbJnOA8w0TbTmUiHR/3Gx4FL80vxOHjnkJOsVJUbP9gx88Ou50O+QVmGvr62h4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6uXAMDpQktC0IBN2YVuJDz4KoABUVVuIvdQHCaC0CHA=;
 b=ZWB/KrOi8CvQVweuIb0NzqTHFMCgzPXoVd853gP8qOYTd4XKLrp/Y9i3IxModtMcVujUMc70JIBUZSaKGGvJSsJb6d60+SS9NxgmxoiZ/iAA9J6GPcQAgC+RuYhWKRLiwqvNGqX5VGNLvu1zolxXyYHtb8BG+a8smEPkrpMjs/zfkMWCp7GApoLYyHTtRnA+6NkwoyLvFA4R1zSvTWxnDNPaflST1dO7UeaK52wCT9fmYlld4HRuWODACHOx1giCGwRWyH+UO6mlUenLN/BQPhNlfSh56PRGzfK8M40luCK1T9bzizOnx0LmwKMo7/1PrGX6jSYHmTamlPwkd548Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by LV8PR11MB8485.namprd11.prod.outlook.com (2603:10b6:408:1e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Fri, 2 Aug
 2024 12:06:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.024; Fri, 2 Aug 2024
 12:06:30 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>
Subject: Re: [PATCH v3 4/8] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
Thread-Topic: [PATCH v3 4/8] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
Thread-Index: AQHauTfPMFWPSBOIHEiZJ+sXeeXGULIUNR6AgAABQIA=
Date: Fri, 2 Aug 2024 12:06:30 +0000
Message-ID: <df1f371e6faeed88afefd0103d759c02b4acdc12.camel@intel.com>
References: <20240608000639.3295768-1-seanjc@google.com>
	 <20240608000639.3295768-5-seanjc@google.com>
	 <7e12a22947bdaf7fb4693000c5dbcf24a20e6326.camel@intel.com>
In-Reply-To: <7e12a22947bdaf7fb4693000c5dbcf24a20e6326.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|LV8PR11MB8485:EE_
x-ms-office365-filtering-correlation-id: b7463ece-ad1b-4f44-1382-08dcb2eb8b2b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QjZ4aVRDaDlIVGc3NFFKWkFqeXpFS2ptUUk4S1ZHcXlrSnRBSG5uWExWWktz?=
 =?utf-8?B?WlpxYld4dlhVOGc4ek5yOHNHeTJxWjlLQzIrSkpuR1l2UDlHd0NzQWxNeFJq?=
 =?utf-8?B?NUszLzZLNVQ5Z0pyR0pjdUJFeWE1ZzI1R2NpeXBnOS93bnRCSktsNnlyb1pH?=
 =?utf-8?B?cUxNeWdGam5ZV0F2TjUvNW5mc0I1d2tpb25WVjJVc3VKMUVONTg0eXR5VE1U?=
 =?utf-8?B?dlM0VVNyWHhKeFFFTmR1eVJYUDQyMWd6ZVFkL3prRmJ4VEFrSHBjQVlxSXY3?=
 =?utf-8?B?UEdiTmJ6R1ZwOVdxZmxnSm9TZ2lqR3FKOWZkNVVBcnoyVVdVRDVpcS9jellX?=
 =?utf-8?B?VmFvZlRmbDRjK0pIYU1oUFhJNlBaQmN3RS93S2dzTENCUFZNMXZ5Q3VSajJl?=
 =?utf-8?B?YmJEMyttbkExY0NqVHZ4TWZyVFBHSzNsczBXZ0ozY0pNSDhiZDc5M2ZDQXc1?=
 =?utf-8?B?cDg0cXYzaDEySFFQTE5NcTVvOHc4bjBHbG9kelhJdmZseTJvdnFTMGQ4OVJq?=
 =?utf-8?B?aG81VWc4c09LcE0rMlpzdkUzK2dWamxmQVFtc1RnRFQ1ZGtSTzNkUU5kZmR4?=
 =?utf-8?B?YUVUdkpUeVIyd3lTbVYxVitUTmZLdzdPOWFaVXNVSEVzaHYvMGtvOGpXTnl5?=
 =?utf-8?B?ZDBPQlN2em9iZkl5ZmpMM3QySlp5U1l5cjN5NHVGSkROZHhnZk9kQUpFN0Mr?=
 =?utf-8?B?U1RNOTJWZDdobHN1Qi9MMG1DWTBBeGM1NVI4eURQazFKWjAxUnNpZ20ycGxJ?=
 =?utf-8?B?SzdQc2NXL05YSmx1dmFUY0U4TVZqNVdBeCtSNFRCSW04QXhaZjk4TVJCVmVa?=
 =?utf-8?B?OUJKQWZTakc0S3VaL0V3eVVTclpMWks1RVc5UDlKd2lYenY2eDR4MW9IYVJY?=
 =?utf-8?B?SERZbWtTNEtWU0ErMUVDRzY2TEVxVjg5Nks2YmVLTERuVXBCYmxYM1hlSkRD?=
 =?utf-8?B?c1U5RFVnemVQcmIxOG01bm4vNXlNL2hLM01JUlRIRE51elBvOUJwd2dDcWJ5?=
 =?utf-8?B?TjcyZGlGV2VyOEYzTEVIM09Bam81MVFVMS83MmF5c25WbGF0MkF5bWJ0MlJy?=
 =?utf-8?B?YUQyWXdYd1hSVjZrUGNJVDBMa0lwdVd0OUdKaXhYdEZDcVVYSU1yNGR1bWtN?=
 =?utf-8?B?cnVBeDE4b3lnd0dQeGlGRFV5TWlCeUd1aWc3YUVsT0pSdnV3Ym1DSWo4VmRI?=
 =?utf-8?B?Q3l5SW4rTEZUaWxZZXV2c3EveC9HZGNzWS9PR3RDYW1vaXpTY0N4YmpVdEQy?=
 =?utf-8?B?NGFtOGtiQ2pFUG9BUk1MWU9TcXBoUFV1NDNuNFlxbGtFWW1SQmoxTllaTGxN?=
 =?utf-8?B?NWJydlJNUmQxRmZkeW8xTVN5YmJlaDNEY0RQSzFodEtlMzBzdTM3VW4zS1Ry?=
 =?utf-8?B?UGhiWXBoVitIOVEvUVdnRUt1QlVrWERlMFFQbkgxZXJEZ3V6U2U5aUI0ZTZK?=
 =?utf-8?B?bzdpR24wNHFUcm9YRmQrUFYwUUoyQVJ1ZHRWN3JUTGZiTGdraVBYUVFydnhw?=
 =?utf-8?B?NzI2dVlpZzNmMjFDQWtBWDNuUTZKc2s1TXY2ZEQ4Slh1c0FybGxEdUhDVDJD?=
 =?utf-8?B?NnorWGo2OTdJUDZTdkJyZjNKWDhQK0hLNHNyU2ppblNtUno4OGg1SjVZQ0JY?=
 =?utf-8?B?SE1wYWpLWWN3SGtsRDBsNFVNTWxNcm5MRVVUanhyZTN2NE03eTdJSFFWMi9v?=
 =?utf-8?B?M1RCV0V6RXBwNGVucGhSZytjbjU1cmhDNWxJWkhzeHBZM29xKzk1VU1OSVIy?=
 =?utf-8?B?bXJFMVdCYWdlKzFhVi9ucVlmV0ZJSDBKc0F1YW1tYzl5cUJickRTdmFaaWVH?=
 =?utf-8?B?SEtlc2JVVGhjeVpZR1hrdUJKcDZxRVgzUjMxa3pFeitBUklQQmlwclRBQ1Qx?=
 =?utf-8?B?TG5ueWJZZkFta2FEOFUvbTk1VTQ3NmV0dDJMcHV3T0JwQ3c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clI0Ti8yM0NWZ2ViaWRWVEEwclo4aHVuM2xHeGovTXIxNDBvYWIyTkZMRTVV?=
 =?utf-8?B?OEE0Y3g3VTFqVkpTOGMzbVB0UUxiMGt2M1JDdXZ6dytLdGw1aFlncnROb2VZ?=
 =?utf-8?B?Vm5tSGw3VW1LQjZPQmlTM2xnZTQrcHY2cDV5alhEMTFWREx4UUtTSU1lR2U1?=
 =?utf-8?B?Um1qMHJ6QThvbDJkV1ZmellWN3htM3VOTFpGR2xNMENna3Y2bUZta21OMlI3?=
 =?utf-8?B?MzJVMXkxVTd3cFJERytBc1graVlRL256eFQxVVl1eFNobUQzc2hqZFFFc0Yy?=
 =?utf-8?B?TFpkSTgxajg4VWFpbmRyMVNORDI4SlhkY1pqK01PY0t0VE1hUVY0Uy8vOVNw?=
 =?utf-8?B?OUcxTlRzbWpjUm1XS2VFbndOKzhNek85aFJQNWVtZDhMR2VCa0J2RmJEUjl0?=
 =?utf-8?B?UnBPS2kwYks0SnFpbE56cm1zcEc4eUp5YnlHbVFLVCtXUUdDSnF0aE1VKzRM?=
 =?utf-8?B?K3A1ZU9LNGlLU1VPR0JkWkl0U1NHd3h5d2lvbnZjRE81ZlVMK0J0N09WSG5x?=
 =?utf-8?B?Q3NFQzh6OExSaDVZR1lEb1FLRFlCZkd5YXFtVENLMmlVYndhZjM3c3owRi9H?=
 =?utf-8?B?Q1FPNm9ldnFlUTNtSmdzYU8vYlRuTks1a3FkYVFUVzkyNTZvSXV1VGx2M2Fy?=
 =?utf-8?B?aDB6UlVrMW83U3FwbDhZMjN1QUI5WWdGYjdMc29iNkR2Y3FvNDlnNU1Fa3JU?=
 =?utf-8?B?SVRHbHRURWF4ZUdMK0FUMVpKMXpkVnpVb1o3Yy9vTEhEK1QvZU9nOGttUlFD?=
 =?utf-8?B?L1FUOFNMek50dUgxVWtVVElVOHZWTFpjaEk2ZHIxNUt0eW1BMFVQdlNNT1FC?=
 =?utf-8?B?SlAxNVI4OWl6U0dyeHRHc2k3aWNheEJPOWJYUUVxM0xPL0RNbm14MGEvQjRo?=
 =?utf-8?B?Q29Mb2xCTVlvMUJnb2UwTkVYbnBGOHdhUkYyNUlHUmRYemUyNzRia25jVktw?=
 =?utf-8?B?dWtjZGxUYThobzB0b2ttaXpBbkpkcWJZbnppY1RzZ0RoR1BnNU1KL05YM3Va?=
 =?utf-8?B?TERReVhyQTlLR1VYTmdvK1hWVW5BWTdpTTFEWThuVUtZUnl3Ri9Ea1JwK1Zu?=
 =?utf-8?B?azE3QXoybmZDdmM2MVNJdThYVTFUQmplVVJhWElCT1hEREhuMkQxS0c5MW9X?=
 =?utf-8?B?alYzS2ZvM3NVSmFnUDN0NzA4NllBQWNhRGdjRDZ2eDRSSXFWRktqakFaTFlH?=
 =?utf-8?B?b055bFhhR0dyaWw2cGN0WnFvWklsUlZMTCtyTXZ4ZDRhVk84OEhNdGxmc05D?=
 =?utf-8?B?TnpjTG9PRFFpa2ZRTmVWTGh2NXVGVlo3TFRTWGhQbnc4Z2ZtYXFQTXFSWm9k?=
 =?utf-8?B?UFJRd0Q4dUhicnY3Y2ZSUy9na2tBOGF1aEFpMTBRbzFWTlJNVlZqU3AxVTM1?=
 =?utf-8?B?U3dSYVArRDd5SjBSbFhCWnhIL1VybFpyVm82cFBaaThrVFN4UDBRMnZCc2RU?=
 =?utf-8?B?T0ZyR09EMVd4bENOUVM2YzNIZEpxN2lXQ3l4TTJKNDRYeDF5Y21LdjF6OEdF?=
 =?utf-8?B?enpJUmd6aVdRZ1JIYlZRdEVTWkdHZEV1emd2TW84VDVnb284cC9BbzlsZk5O?=
 =?utf-8?B?aUFndlFhaTFWWnpUY0hJNndsMENWNzdoR3BUclFuWEY4cGZoQWU0SWh2WjVD?=
 =?utf-8?B?SDJKWGFqRFQvZEw4VVZoR1J0U0FkL00vaEtXN0U5dmFEMFZYTWxIaUhmNE93?=
 =?utf-8?B?Z1IrajRsWTRSSXFlOUlLM2FENDhmalhmVWROS1BMZEd1Q3Bibi94TGQwcXF1?=
 =?utf-8?B?SG9uRGJVRWtaK0cyVkpGNXNLdWxycm9maENQT0NkdmZzd3dUZk43cS9aSTdG?=
 =?utf-8?B?UnArYjNBQlFidjdVRGJRK1RFZ25lUktLdjNFb25ybTZtd2tWWVJvT0FBdDhL?=
 =?utf-8?B?Z3VSUDVnSmRMamxyWHFrbE5RdXNORXNXaUtnN1F2am1YNEU5N3Z4dzRXVStM?=
 =?utf-8?B?WTBibFNlK0hLTkwwQXdCa1BFbkNrU095VzZtQUMybXFEZlgrTEVDUzgrYlJD?=
 =?utf-8?B?aVpnNWVyS0lrSUt2dDNCQ0kweWlMRjJISnZZZGY1eThENFFpaDgwcTBqeWZi?=
 =?utf-8?B?all4ZkZjOU1CMU1od1VGMXBhaEZ5RDBNNWRLa2VKU3ZmM0xoU3I3aE5zekdn?=
 =?utf-8?Q?Jaq3Zs3LTxnN63wO7+oW05hrO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91A6BCEDE1116840803F0AB118C4C299@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7463ece-ad1b-4f44-1382-08dcb2eb8b2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2024 12:06:30.1470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yt274fBqelKDy8OhQoTK8FJRyJYVL8feFm+/HrenjE4VGZFAwk6AFMdliEjQaaaZOiRLlZtQYShRaf53gkhfuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8485
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA4LTAyIGF0IDEyOjAyICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBU
aGlzIHdpbGwgdHJpZ2dlciB0aGUgYWJvdmUgIldBUk5fT04oa3ZtX3VzYWdlX2NvdW50KTsiIHdo
ZW4NCj4gZW5hYmxlX3ZpcnRfYXRfbG9hZCBpcyB0cnVlLCBiZWNhdXNlIGt2bV91bmluaXRfdmly
dHVhbGl6YXRpb24oKSBpc24ndA0KPiB0aGUgbGFzdCBjYWxsIG9mIGt2bV9kaXNhYmxlX3ZpcnR1
YWxpemF0aW9uKCkuDQoNCkNvcnJlY3Q6IHRoZSBXQVJOX09OKCkgd2lsbCBiZSB0cmlnZ2VyZWQg
cmVnYXJkbGVzcyBvZiANCmVuYWJsZV92aXJ0X2F0X2xvYWQgaXMgdHJ1ZSBvciBmYWxzZSwgaWYg
a3ZtX3VuaW5pdF92aXJ0dWFsaXphdGlvbigpDQppc24ndCB0aGUgbGFzdCBjYWxsIG9mIGt2bV9k
aXNhYmxlX3ZpcnR1YWxpemF0aW9uKCkuDQo=

