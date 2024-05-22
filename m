Return-Path: <kvm+bounces-17927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 351E08CBB24
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:24:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A622A1F22DA2
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 06:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A60979952;
	Wed, 22 May 2024 06:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bQCbNoB2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE80A78C90;
	Wed, 22 May 2024 06:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716359061; cv=fail; b=D8/A2nMnDiPa1rTf9BI6oQXLpHU9AsSJJs3MjPw3obmbUFhaRMGh/C++Sy54KYhqKD5OgR6Zh5pbt7jvHTyrXM/k4X/fObAehp8b8GXWwPL9lzAYy2FCmbfSDi6fZkzAI8cTz2Zm6FvauDgVHABPWyJCSux8bGd7Yp2T0NWpuTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716359061; c=relaxed/simple;
	bh=lNDSri2VGrfcQauMj370TCr2mEIy6iZVTb1QAEZhpPY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PdGTNexoH9SPdId7TE/bDbdAj1OkzHROs/Exi2iJGlnHKFwshQq6BktlRYtw/jihFHOUdHsYWsQCvEs1czdnbuIDEHH6931ImONPyjj+zY1VUPhHPfRq68wP0Sr1jjtOMnDngI7nY85vJVCXtheo3Xabmuh5Npq+X3UdPDmrDt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bQCbNoB2; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716359060; x=1747895060;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lNDSri2VGrfcQauMj370TCr2mEIy6iZVTb1QAEZhpPY=;
  b=bQCbNoB23Txf1087APdcF8a1CloJb85pZJsKXDnLLsPgQ+0sbpkvn3lP
   6HH57ZN3dc1loIekKltKZX1UsZYQ9Qr/sdt8DJAoI2Wc8UOviKDHhH9Cr
   BvyHNlkD5P/uLF1xGjz0B3bq1eGfccklL3s5Uso73zbX0upos1/DAP2/h
   nFZ+0kD5QH+In7KjP5pVVmCvC9bi4W4OfyCwGTUIFzkzyuNQ4u5stTHT7
   9udvZ4kDEy3Gq7y7P2cuMZGY9QEP3P0tSYGSfGaLySbdwm8985D7S6Qzq
   +D/v2u/QYqPX36a37L7rTzEDGYfTjcrJh2BdQlUYA6fthQrJbMtD0wYIe
   A==;
X-CSE-ConnectionGUID: HkQaaWroT/KG1r6/eZElOw==
X-CSE-MsgGUID: 5zJp+CbXSpGnKo0Plb+6Tg==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="12459983"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="12459983"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 23:24:19 -0700
X-CSE-ConnectionGUID: 2IbjhZAuS2+iBabosEl5JQ==
X-CSE-MsgGUID: hQ+LKDBPRE2tgV+SBI8J+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="63997091"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 May 2024 23:24:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 23:24:18 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 23:24:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 21 May 2024 23:24:17 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 21 May 2024 23:24:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LO0ZSTcCnGcOHbbuoU9050ljnW9ss/vc9hX25r3DdwYn6IAO2f/Yat78PHbd5u0Ar05nohfa2rxJNBAh1OA6oS5iXBDOwFLgiPoYOFXma50ndf0uv9GGdtxYPP5sSlHoSaFzDvxAqFzu3If9UFmYaVAVDlR5VMStrGeMcCH2JEOc/kKhZYokk5r7m1Hjsuz3N6itZIy0ed+qd4CwNmq1m/84VGsDD/K9AOrlGts2JXp1cDBtDbc42wyStqkaqq++SM5Ig2wxnA4hiZluagzKD30yy488bNigbg8TnIXx4fM/NRqAPVg2sAuBRubpIIs+Nxhmc93LU1qsAaz4kr9MeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lNDSri2VGrfcQauMj370TCr2mEIy6iZVTb1QAEZhpPY=;
 b=ScLXQrDbfV/m+Kg2ccYLTro2aJxUjaAgzx+ea4Lvi0nPZ0CvftB//ghyQkr+7BBv6jXj83kubtVIEoVJTz3nBjLd5EL0nQFHFs/54QjG+t7IiOwGBp9e5Onetn5RcivdTqud0JqCTsSySbnC6P3zpsVQJM6gyIowF0u0owZ4OEwZ/Pjabu+rnFzy5ZY88gWWqsX4XNbJgUrSbvd7G7DjmnxKOb1Mu5YwlDJqYEWBMeizSZg2IXG7tQxLsdwQEWEvfwbf8wAU0CYrbUuh/8MaiDcMAVKFsKAj0eNgH6jDPecYjkjgzWa3ho24gyvMXse4A/GjZyq9wgYWMK2kVSfo7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB8059.namprd11.prod.outlook.com (2603:10b6:510:24e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Wed, 22 May
 2024 06:24:15 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 06:24:15 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "Vetter, Daniel" <daniel.vetter@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org"
	<will@kernel.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>
Subject: RE: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Thread-Topic: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Thread-Index: AQHaoEb1yTw+2+R5T02uRFeJZuQMNbGPN+OAgAER64CAAGvrAIAEE0QAgATCszCAANP1gIABWkKAgAPDRsCAAnQoAIAAA/SAgAADhwCAAB2LgIAABQiAgAC9HuA=
Date: Wed, 22 May 2024 06:24:14 +0000
Message-ID: <BN9PR11MB52769E209C5B978C7094A5C08CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240510105728.76d97bbb.alex.williamson@redhat.com>
 <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
 <BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240516143159.0416d6c7.alex.williamson@redhat.com>
 <20240517171117.GB20229@nvidia.com>
 <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240521160714.GJ20229@nvidia.com>
 <20240521102123.7baaf85a.alex.williamson@redhat.com>
 <20240521163400.GK20229@nvidia.com>
 <20240521121945.7f144230.alex.williamson@redhat.com>
 <20240521183745.GP20229@nvidia.com>
In-Reply-To: <20240521183745.GP20229@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB8059:EE_
x-ms-office365-filtering-correlation-id: 393f114b-540d-43df-f7b7-08dc7a27cd87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?bnkzWmlUcGVOdWx4V29mRFdXQzJPY2o1cG8zd1dPQjVoc0RYZGVJMVlIblVX?=
 =?utf-8?B?ZlZ4ZVF0R01HT1dmTjFKcUhGN0lRRXFnZUhrRkR0Z3NQajFTd1AyYm5DNDF2?=
 =?utf-8?B?ZVY1THJtQTBEZklodmRBcndnV3Z4MGRqYTJZbmhLTkxNMGR4bkxCd2pPY3lr?=
 =?utf-8?B?SkZpaFIvZkFrdVpSanpPY0dUcDQ1dkp3WjROaUE4cUtJTlpRbTJqNzFpaDNq?=
 =?utf-8?B?NEEwYnNGS1RIMHFOZTZFbDMrYzNHZFNQeWptRUkwNTNWSi9ocHpRNll0OEJT?=
 =?utf-8?B?dC9zeHV6Z1pMdWw4Vk1rQUtqcDVqdCs5bVRGdkxiTThra2N4Qy9NcitoNGlD?=
 =?utf-8?B?SzNSTFRqOEJnc0ZlTTI4Mm5TcFFIbWZJTnd2SHFtVUhnczc2Um5EM3JPMWZO?=
 =?utf-8?B?a3BNYkQ2akFEYTlNYjZIdU9ySGVacnoySzRXQ3J0NzJkVHRnTEZsVkVqRExq?=
 =?utf-8?B?OEFIeW1abFp1K0dyWnBwVTNJSjVOMERaMVhUTklOOGNFUlVnUnFJdHRsWjVE?=
 =?utf-8?B?eVdNb09hZGMrUHRRQ1orVlVld0ZlSDBUUWRGaUp4STNBTEpXNVNneTI0c3U5?=
 =?utf-8?B?YzJtL091OFo2dHJDMGxDUkNRUEpYSkZPY1FWbGtkREVrSmJOMTI4ZDRPKzlF?=
 =?utf-8?B?c1JHUjhoMWIweE9IdTlFZ2t4dEJ6UU9XWUEwT2w2a0dGaDVMYjFQeURXVzcr?=
 =?utf-8?B?STk4cGNPYWtnUzR5UGxBdkJIME84Q0d3eWxDZkpaNDZzRlB3ZHoyM0I0MDRu?=
 =?utf-8?B?MTRqanFENDU1R2VCV2MyV0I3eWpuSlBidDBxcW1jNkVoUmh4YUR1V0ptNkFU?=
 =?utf-8?B?aXFqa2JxclV4Q2JzOWs5d1ozWjQ5QVhGMy9BbmF5M0grang4MUFRMlYybnlx?=
 =?utf-8?B?R0hNd1dNaVE1NUtVdXBLWi9LYUVYcWcwSmFzc3VNR0Vncm02MmQ1dFJ4S1hV?=
 =?utf-8?B?T29YTGJYZzdQWDN1c0prTDN3SzVoWXhWR2t0UitFVjNCQnlVTzFPdkpiQVRP?=
 =?utf-8?B?Nk81REdPOWlaR2ozZmwzK3BGSGIxTDBRMjRpY1h3Q0tSdWRLcnlNY3pRenpZ?=
 =?utf-8?B?UmRGdW04MFJvRTFtZUJsSlkyYjI0blFGenpDRnVLdWNVeW9YTUJzRzltWjBG?=
 =?utf-8?B?am0vM0JxSWpYdE9wNDVwbUcyRWI3MUo5RmNVTmx6OXJ6a3VPK2txNjRRRTZR?=
 =?utf-8?B?QWxzZHErTm5rVzdoTTJPczQzZXBpYm52V0RHUkc1SU1GQzE3NEtKVUphd1cr?=
 =?utf-8?B?N0hoNHRIZnJnZkNrSFI3bHdndGE1S1JXNkd2SlJFU2h5L0YyQ0k1Z2Z5Ui9C?=
 =?utf-8?B?WG9iZmFCdmNxN3ZmckEyRlQ5dWlONVgwTnVEakJMNUdkOTdBcXdIQ2xpNm5R?=
 =?utf-8?B?dU5aUGxIanZ2N2RsTEd4UjVtdm1xdXBTc2VzRTJpbHRMUkE0UzJCVDR5eWdU?=
 =?utf-8?B?a3g2cHFEQXZhM005ZnJoMXlHS0NwY1MwUnZoSVF5Ym53R3FHRkZzL0lEKyt3?=
 =?utf-8?B?WW5sTHlDUG1uL1diRklSRkhvODd1eThncGp2SmZpOTBvY09nWXdNT2VoUnZS?=
 =?utf-8?B?SkxVcnNqd0J4azJNclduMENaVlBsZHY0TitpOW9VWGxIVGsySTluMDgyY080?=
 =?utf-8?B?WHMyQm9jMW01Wm90VnJHVThPdkZtYXozVDYwYVBQUzlBS3hGT1hhY3duYUNa?=
 =?utf-8?B?cHYzcVF5US9PdFRWRWcrcXc1UjhLS1RCT25DcGY1djBRRDljTzJLU1dQazRt?=
 =?utf-8?B?d2I5aDEyUnFFaU1nMXh6T3YxM3hWSzdWMmxYcnc0Vlo1UDBDQ2wyT0owSzJT?=
 =?utf-8?B?cVJ3ZlhQN2VRS0hKRDRMZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVB1MEN2UjVxUjB6UVRmaE1nakJ0YTZFeEVYbElmVldnTUo0VGtoUHJkdm4z?=
 =?utf-8?B?citLOGd2NWxxbmtPM0thWG5SU3NXVzV6QVplMnRxVWc5aGJreDRxZEVRek9L?=
 =?utf-8?B?ekwydW1LU29vS2QwUlRSU2hTSXlOL0dVRFlwY2hna0RsdEsvK3kvQ0JLK1ho?=
 =?utf-8?B?RzVubElaWlViakRKWURTWWV4MTVzV3p4UGlPTmdNZjYyMTBGanIxMUVkdm4y?=
 =?utf-8?B?UXNTTkc2a3QzdDExdWorT1krMUMzVmoxUHJ4MTloK1VXbWxoejBzaGhSSzB2?=
 =?utf-8?B?Qm8rM3ZFNWE1S1RsU2VCQ1Y3R2wyaktlMUtuMHZ2bG9CQkJsdzlEWDg1aTVY?=
 =?utf-8?B?dk5zYnhWN2Y5NEZHZURUaWtxRDJFd2tmdmF4eVlIdXlGajE1RFRIcXNhc2Yv?=
 =?utf-8?B?dXo2Rkc3WXJjbVRTNU10emVwalViaXBlRTlRTEdUVWNkM2lUUUQ2bjhvNFV2?=
 =?utf-8?B?YUZKRHdDc2luSUVzbW1YUFpXeUwwbHpCNFlSeGJTVERtU3kxSkJGNDhCSWYz?=
 =?utf-8?B?eFFEeWFqWUM3OUtIaW54bjZZWkNFODJKMit2OGgybzR1cWpmWGZ3SmJkaVBZ?=
 =?utf-8?B?NUUwQkF3YkxmMjJEMzl6YjdjbGprNDRnSE9hcnlybTBrUnY5aUZOOTVxem4z?=
 =?utf-8?B?ZlFmUDdCUjBhSDFJTjdSUldzQndMaGdzU3RJL3poWFF5QlI2YlFldDlQaFow?=
 =?utf-8?B?eU9hOWluVkFNZ0NXVUhaUTF2TGwxbURrWm9KSWx0QWVhaEhmNTdLcmJqZ1BU?=
 =?utf-8?B?K3E2alZ0SFlUekwwclhOeTdxRkdwb09ncFZPRTNkRThqa0kxYjM2d2loU2FT?=
 =?utf-8?B?UGhtT0JJRElnSG5NWUkyeFA3VUlmZEx3d2MwSTVMZUc1eGxUaGVyMHlRZHRB?=
 =?utf-8?B?cU5oQXhjUkhlUHBlTFNESWxJdFRNalZQTW93dmprb0RFeXBKc2ZsanRsSXdH?=
 =?utf-8?B?c0wzVjhsdHpjb01rSjV5dW9VQmdEMHBpbkE2M2FzZldaWTFiTFhmUHFqbGgr?=
 =?utf-8?B?SGlDRHp3ekhhNzBKc1dRbmlyeHkydVl6dU5KWGVMeVd2RUYwZXErS3FkN1Zw?=
 =?utf-8?B?TW9NVkhYbWphalBGamVKNVZIV2d0Mit0V0hRcmxWZS9PUmo3WDFUWXNhT2Vn?=
 =?utf-8?B?WmtkaXVyaWxKZ0dSbjhaa0NxczFDRkRoaVhyRWcxUGZycXNMY2g5RTBueUxF?=
 =?utf-8?B?WUdMUFRxRDQySlc5NFFROEtYTk9YM0FySXlJY3lnSUtYc2JEa2x4cWpSY3R1?=
 =?utf-8?B?WHg1ZnloM1A2SlJtejFMa3ExclNtdGRGOFpNaGVNZS9Eem5uZUVNWXdORlhB?=
 =?utf-8?B?bSs1cTFwbVJYL29NcTg2ellMd3NzSG5VUlRBS0IxdTBqQXNueEhzUklMdUph?=
 =?utf-8?B?SkJwRUZUTzlsbE9pMldvSjJwOVdOeHZMWXlmQS94WFQzV2pseWg1Z1dwUlk0?=
 =?utf-8?B?T05SbVhMNmkxc3N4MytubThzWUlQSm9lNUFyam9HaU1xTTF4OGsxbGNxYzRx?=
 =?utf-8?B?YnZVWmIrN0k3K2tkc2Y5MlB3YmRJQTZ0SnY3aUlFTE10NVJoT0dDNDNlTEEr?=
 =?utf-8?B?dUtoSFFBNWlEYmdtNm1MM3dYMWN6bFhzZFFoUk1TVmVET0ZXUmQzeHorL1Vy?=
 =?utf-8?B?TmZ3Q2V6Q0tMWFQweGtiT2xUbkh6aFJCekNxNDB4ZlF1MUdVRmlMTk14MTZM?=
 =?utf-8?B?NVlCN3FNdzZOYW53VE1BYnY0SkZNS0pCZFVVQmpIUFlqYU5OS20ycjcrNnF5?=
 =?utf-8?B?ZnB3S2NISk9Jd2ZpNGNiSHVDaTZuMXIxUWcyb1JLa0JDaWxHMlJVSkQ1dGQw?=
 =?utf-8?B?KzRzS0p0V0hRMUZ4aXk1ZndLVndBRzlua0hFTHcxeENCWVg2R2NkTmp5QkU5?=
 =?utf-8?B?N2JBL3FoZ1JCdFI3NFNzcnVSTElBMFR3Z3ZTNHdOcnRkUHk5Q2V3ek1kbUtl?=
 =?utf-8?B?WW5zM3RES014bGY1ZW13RHNab1kvTGV0akFhVHVYTXg5eFh3c2ttT2V4Um1a?=
 =?utf-8?B?WCtRd2xjUUQ2d2xTQUljMlFlWFl4UmQ3dVRlcWxyTkdtM0ZwZjgzODFUUlpV?=
 =?utf-8?B?ZEMzblEyZ29JVXQ0VXdSZnkwcE9Cb2xlSzAycWJ1RTdUTzcvdWFrVTFrT0o2?=
 =?utf-8?Q?EDpF1DxL4sDzwfEwRMUrXtKDA?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 393f114b-540d-43df-f7b7-08dc7a27cd87
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2024 06:24:15.0218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FaWsFuMZd1O/yyb/nozaZMpDpPLLKVg/s+Y3NqkuaWrm2ypbVRHcGaBrHm5fA9Q7XRsWNRGlYLk/mMAD3FCUCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8059
X-OriginatorOrg: intel.com

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIE1heSAyMiwgMjAyNCAyOjM4IEFNDQo+IA0KPiBPbiBUdWUsIE1heSAyMSwgMjAyNCBhdCAx
MjoxOTo0NVBNIC0wNjAwLCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6DQo+ID4gPiBJJ20gT0sgd2l0
aCB0aGlzLiBJZiBkZXZpY2VzIGFyZSBpbnNlY3VyZSB0aGVuIHRoZXkgbmVlZCBxdWlya3MgaW4N
Cj4gPiA+IHZmaW8gdG8gZGlzY2xvc2UgdGhlaXIgcHJvYmxlbXMsIHdlIHNob3VsZG4ndCBwdW5p
c2ggZXZlcnlvbmUgd2hvDQo+ID4gPiBmb2xsb3dlZCB0aGUgc3BlYyBiZWNhdXNlIG9mIHNvbWUg
YmFkIGFjdG9ycy4NCj4gPiA+DQo+ID4gPiBCdXQgbW9yZSBicm9hZGx5IGluIGEgc2VjdXJpdHkg
ZW5naW5lZXJlZCBlbnZpcm9ubWVudCB3ZSBjYW4gdHJ1c3QgdGhlDQo+ID4gPiBuby1zbm9vcCBi
aXQgdG8gd29yayBwcm9wZXJseS4NCj4gPg0KPiA+ICBUaGUgc3BlYyBoYXMgYW4gaW50ZXJlc3Rp
bmcgcmVxdWlyZW1lbnQgb24gZGV2aWNlcyBzZW5kaW5nIG5vLXNub29wDQo+ID4gIHRyYW5zYWN0
aW9ucyBhbnl3YXkgKHJlZ2FyZGluZyBQQ0lfRVhQX0RFVkNUTF9OT1NOT09QX0VOKToNCj4gPg0K
PiA+ICAiRXZlbiB3aGVuIHRoaXMgYml0IGlzIFNldCwgYSBGdW5jdGlvbiBpcyBvbmx5IHBlcm1p
dHRlZCB0byBTZXQgdGhlIE5vDQo+ID4gICBTbm9vcCBhdHRyaWJ1dGUgb24gYSB0cmFuc2FjdGlv
biB3aGVuIGl0IGNhbiBndWFyYW50ZWUgdGhhdCB0aGUNCj4gPiAgIGFkZHJlc3Mgb2YgdGhlIHRy
YW5zYWN0aW9uIGlzIG5vdCBzdG9yZWQgaW4gYW55IGNhY2hlIGluIHRoZSBzeXN0ZW0uIg0KPiA+
DQo+ID4gSSB3b3VsZG4ndCB0aGluayB0aGUgZnVuY3Rpb24gaXRzZWxmIGhhcyBzdWNoIHZpc2li
aWxpdHkgYW5kIGl0IHdvdWxkDQo+ID4gbGVhdmUgdGhlIHByb2JsZW0gb2YgcmVlc3RhYmxpc2hp
bmcgY29oZXJlbmN5IHRvIHRoZSBkcml2ZXIsIGJ1dCBhbSBJDQo+ID4gb3Zlcmxvb2tpbmcgc29t
ZXRoaW5nIHRoYXQgaW1wbGljaXRseSBtYWtlcyB0aGlzIHNhZmU/DQo+IA0KPiBJIHRoaW5rIGl0
IGlzIGp1c3QgYmFkIHNwZWMgbGFuZ3VhZ2UhIFBlb3BsZSBhcmUgY2xlYXJseSB1c2luZw0KPiBu
by1zbm9vcCBvbiBjYWNoYWJsZSBtZW1vcnkgdG9kYXkuIFRoZSBhdXRob3JzIG11c3QgaGF2ZSBo
YWQgc29tZQ0KPiBvdGhlciB1c2FnZSBpbiBtaW5kIHRoYW4gd2hhdCB0aGUgaW5kdXN0cnkgYWN0
dWFsbHkgZGlkLg0KDQpzdXJlIG5vLXNub29wIGNhbiBiZSB1c2VkIG9uIGNhY2hlYWJsZSBtZW1v
cnkgYnV0IHRoZW4gdGhlIGRyaXZlcg0KbmVlZHMgdG8gZmx1c2ggdGhlIGNhY2hlIGJlZm9yZSB0
cmlnZ2VyaW5nIHRoZSBuby1zbm9vcCBETUEgc28gaXQNCnN0aWxsIG1lZXRzIHRoZSBzcGVjICJ0
aGUgYWRkcmVzcyBvZiB0aGUgdHJhbnNhY3Rpb24gaXMgbm90IHN0b3JlZA0KaW4gYW55IGNhY2hl
IGluIHRoZSBzeXN0ZW0iLg0KDQpidXQgYXMgQWxleCBzYWlkIHRoZSBmdW5jdGlvbiBpdHNlbGYg
aGFzIG5vIHN1Y2ggdmlzaWJpbGl0eSBzbyBpdCdzIHJlYWxseQ0KYSBndWFyYW50ZWUgbWFkZSBi
eSB0aGUgZHJpdmVyLg0KDQo+ID4gPiBUaGF0IGlzIHdoZXJlIHRoaXMgc2VyaWVzIGlzLCBpdCBh
c3N1bWVzIGEgbm8tc25vb3AgdHJhbnNhY3Rpb24gdG9vaw0KPiA+ID4gcGxhY2UgZXZlbiBpZiB0
aGF0IGlzIGltcG9zc2libGUsIGJlY2F1c2Ugb2YgY29uZmlnIHNwYWNlLCBhbmQgdGhlbg0KPiA+
ID4gZG9lcyBwZXNzaW1pc3RpYyBmbHVzaGVzLg0KPiA+DQo+ID4gU28gYXJlIHlvdSBwcm9wb3Np
bmcgdGhhdCB3ZSBjYW4gdHJ1c3QgZGV2aWNlcyB0byBob25vciB0aGUNCj4gPiBQQ0lfRVhQX0RF
VkNUTF9OT1NOT09QX0VOIGJpdCBhbmQgdmlydHVhbGl6ZSBpdCB0byBiZSBoYXJkd2lyZWQgdG8N
Cj4gemVybw0KPiA+IG9uIElPTU1VcyB0aGF0IGRvIG5vdCBlbmZvcmNlIGNvaGVyZW5jeSBhcyB0
aGUgZW50aXJlIHNvbHV0aW9uPw0KPiANCj4gTWF5YmUgbm90IGVudGlyZSwgYnV0IGFzIGFuIGFk
ZGl0aW9uYWwgc3RlcCB0byByZWR1Y2UgdGhlIGNvc3Qgb2YNCj4gdGhpcy4gQVJNIHdvdWxkIGxp
a2UgdGhpcyBmb3IgaW5zdGFuY2UuDQoNCkkgc2VhcmNoZWQgUENJX0VYUF9ERVZDVExfTk9TTk9P
UF9FTiBidXQgc3VycHJpc2luZ2x5IGl0J3Mgbm90DQp0b3VjaGVkIGJ5IGk5MTUgZHJpdmVyLiBz
b3J0IG9mIHN1Z2dlc3RpbmcgdGhhdCBJbnRlbCBHUFUgZG9lc24ndCBmb2xsb3cNCnRoZSBzcGVj
IHRvIGhvbm9yIHRoYXQgYml0Li4uDQoNCj4gDQo+ID4gT3IgbWF5YmUgd2UgdHJhcCBvbiBzZXR0
aW5nIHRoZSBiaXQgdG8gbWFrZSB0aGUgZmx1c2hpbmcgbGVzcw0KPiA+IHBlc3NpbWlzdGljPw0K
PiANCj4gQWxzbyBhIGdvb2QgaWRlYS4gVGhlIFZNTSBjb3VsZCB0aGVuIGRlY2lkZSBvbiBwb2xp
Y3kuDQo+IA0KDQpPbiBJbnRlbCBwbGF0Zm9ybSB0aGVyZSBpcyBubyBwZXNzaW1pc3RpYyBmbHVz
aC4gT25seSBJbnRlbCBHUFVzIGFyZQ0KZXhlbXB0ZWQgZnJvbSBJT01NVSBmb3JjZSBzbm9vcCAo
ZWl0aGVyIGJlaW5nIGxhY2tpbmcgb2YgdGhlDQpjYXBhYmlsaXR5IG9uIHRoZSBJT01NVSBkZWRp
Y2F0ZWQgdG8gdGhlIEdQVSBvciBoYXZpbmcgYSBzcGVjaWFsDQpmbGFnIGJpdCA8IFJFUV9XT19Q
QVNJRF9QR1NOUF9OT1RBTExPV0VEPiBpbiB0aGUgQUNQSQ0Kc3RydWN0dXJlIGZvciB0aGUgSU9N
TVUgaG9zdGluZyBtYW55IGRldmljZXMpIHRvIHJlcXVpcmUgdGhlDQphZGRpdGlvbmFsIGZsdXNo
ZXMgaW4gdGhpcyBzZXJpZXMuDQoNCldlIGp1c3QgbmVlZCB0byBhdm9pZCBzdWNoIGZsdXNoZXMg
b24gb3RoZXIgcGxhdGZvcm1zIGUuZy4gQVJNLg0KDQpJJ20gZmluZSB0byBkbyBhIHNwZWNpYWwg
Y2hlY2sgaW4gdGhlIGF0dGFjaCBwYXRoIHRvIGVuYWJsZSB0aGUgZmx1c2gNCm9ubHkgZm9yIElu
dGVsIEdQVS4NCg0Kb3IgYWx0ZXJuYXRpdmVseSBjb3VsZCBBUk0gU01NVSBkcml2ZXIgaW1wbGVt
ZW50DQpAZW5mb3JjZV9jYWNoZV9jb2hlcmVuY3kgYnkgZGlzYWJsaW5nIFBDSSBub3Nub29wIGNh
cCB3aGVuDQp0aGUgU01NVSBpdHNlbGYgY2Fubm90IGZvcmNlIHNub29wPyBUaGVuIFZGSU8vSU9N
TVVGRCBjb3VsZA0Kc3RpbGwgY2hlY2sgZW5mb3JjZV9jYWNoZV9jb2hlcmVuY3kgZ2VuZXJhbGx5
IHRvIGFwcGx5IHRoZSBjYWNoZQ0KZmx1c2ggdHJpY2suLi4g8J+YiiANCg0KDQo=

