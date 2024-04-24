Return-Path: <kvm+bounces-15799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FAE48B07FE
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 534621C20918
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27CB15991A;
	Wed, 24 Apr 2024 11:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DeUNtxMI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C52E142900;
	Wed, 24 Apr 2024 11:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956792; cv=fail; b=gmxqWvgjVR3116pajKj8OHNjP5oiNrAtU71uCyekHLbOoLppOS6o91qZh0zixEpTs/VKhlwF4b381t95CxCEgHaxuRJUxw57DD+F5/ZhnXj13SDYwNrDPAg5vIYdK3XOIlIPdLOubjJZfGV+A14Dy2yUZcNqTDGmFE8EUY7/4RU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956792; c=relaxed/simple;
	bh=R11ROWpjEARt7h7Te3noIfg2H8d40nzJP9ixf9mS4ZM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SxRTSHouaByLX3D8wdC5N9Gp3iS0ObwyJjzF0wuQC0S9T7L3UYoztX1IAWYvemT3sTq+cLQLnASOKK3yyAEIHGJ7lPfLwtTNrtc5CVM2WSLDBuWtC8vPofoeWHdG/mB0A1U3tpoZORgSa+i9uR4Su10ENm74nAz8jiA+SFz9lmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DeUNtxMI; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713956791; x=1745492791;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=R11ROWpjEARt7h7Te3noIfg2H8d40nzJP9ixf9mS4ZM=;
  b=DeUNtxMI2OvMu8rgOL1y+mvdtyzqFWJ/ZLK3WA4ZOzHW1ub3SL8x5FHc
   u5HKIiU3VkugieiFhtiBGdL9I69oyo2zKOOmAS/trxxeykhTxxKbw9fM9
   L/rSojIa0rlYjal/kBkmfmU0meiyPISpFe2fbNYP0AYyIPHWAVhinZOSI
   sMxFJ7meykh01ng6N/YECL0TfqJfbYQ++8QZXU76hZz+wZ1UnVLGpFvhi
   V424lsN3McWSrIF6M5wFu1JBQXsONgxk6MKFOc7zlbT026Y47cITlXU5B
   Z7C4QBH8qpizePtDfd69KlFdAYqRSfxvajXJ5aDp2dJTpKP1s9W3RvcjH
   g==;
X-CSE-ConnectionGUID: PPExnu2qRbegghnSbrNmRA==
X-CSE-MsgGUID: 4XWSnyyCRtmBfH4V53IlXQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="21003762"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="21003762"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 04:06:30 -0700
X-CSE-ConnectionGUID: k682Bq/+QTyFVAiQqSLTww==
X-CSE-MsgGUID: 57kHiROBTN2+JBHaQDJSOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="25283443"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Apr 2024 04:06:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Apr 2024 04:06:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 24 Apr 2024 04:06:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 24 Apr 2024 04:06:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTO8LXR+2eChn7llPmnfBKtW95slVKdtisLxgOQjogU73WzLmESDW1CH6cgdF8DWEE+vzpaeKcV61FrdKzG3ObhbYHCrb8Zhg06A9N1QySdsxaDS0cK9ZlWs6xyrqmJsAXWZp9xOeL1RyEqD8+A/259a6fG8ET3OYmHgbs6itjaMwuXrEPiqYnvZFB7GdGxOSh+sxbmVjL80y3JwTmED5zGCAjkG5+3ZQgi9fzYJKn6MRsieIkwXWpFDLfaWpbrSPZ02Kpm6uOhm0+Ly+noWi6BaZ50JXSj/vd3ZYWnlZg1zuY3ok07cgyYtJ12QXQsG4KD1lfATMwP09DRL0bsAww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R11ROWpjEARt7h7Te3noIfg2H8d40nzJP9ixf9mS4ZM=;
 b=LxfbT+pXqhGLfsuqNobFAi0sZZ7ZsOes2EtxFepe96sx7Y3a3xPrxw4qC+KiTy5gms29SCX9WUsdFd8RkoATXSfO+k6eW5WTplAenY5NWib9n+7Ppwf73CGicuBHymKagAL48jPfyQuDgM/y2qJI57bcMLeS0EfP3+Fwh5LVoaH4kRqi2SncBAbnS5k5pPZyL9cJ1DpN6bTVdfHfmInHTcnd4ln3XXe3xmv17mAgkkKdyvo5yhwRqBh+r4uptCjJg1ptFL95VbubDwau1FoPOWMcQBhGgEdPMwjTzq1avtRGaIcrLYPErb6bzV/BJPTllNqOjrI43ukNHLOYTPxf8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7922.namprd11.prod.outlook.com (2603:10b6:930:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Wed, 24 Apr
 2024 11:06:26 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 11:06:26 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Yao,
 Yuan" <yuan.yao@intel.com>
Subject: Re: [PATCH v19 030/130] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Thread-Topic: [PATCH v19 030/130] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Thread-Index: AQHaaI26FrHcdX+u0kqmKjY/lD3kJ7F3nceA
Date: Wed, 24 Apr 2024 11:06:26 +0000
Message-ID: <75a560c37da0bceff49c5915f035125a26278c58.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <1259755bde3a07ec4dc2c78626fa348cf7323b33.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <1259755bde3a07ec4dc2c78626fa348cf7323b33.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7922:EE_
x-ms-office365-filtering-correlation-id: 4137b1f5-48e5-433d-661d-08dc644e95dc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?MTZSMHRpNUVVL1ZyRzdOSGRvZlR2NmVQYjNFTmRoNmtXZnFxaVZZVHhkY1Vp?=
 =?utf-8?B?R0pObTIwVUJlVXBCUjRxZ3VtOERENlViR01kZzBHdVg0WnEyOVgyM000MU8x?=
 =?utf-8?B?dFRhUzFITFMrREkzRVplV1NpbmNiZ2lXcVl1WXc1eTZIYTgyQUsxMWlsSUlK?=
 =?utf-8?B?NE5wMTJOZWtNVWZ4bVBKd1k1cUllb1RVeTRmRVoxYmRJOEpRazJHdFRZbCty?=
 =?utf-8?B?MG92RFZJSmZ1NmVPbTVGWmxUSm5OTlNJU2d3ayswQmU5cWtYZWJZb1VGR3VP?=
 =?utf-8?B?V3E1T2gvTXE5bWRwK0VmREtMdzRoaSsyaGZ4UkRUNUZ5cnlIcFQxQ3dSRXlm?=
 =?utf-8?B?QU1NM2Yrbkx5dGhlNnpLRlVzZ2V2Vko2VkRCdWpXVjA3TG0rdjNPYWhtZGdw?=
 =?utf-8?B?MUpNZjZ1SFFwRUNld0s3bGZySTBZQmlxb0FxU1ExcmVUL3lCQ1pkNnRvakhR?=
 =?utf-8?B?MUJvcUt4VGZrTmNaRFAzdEk1UGUrUXV0TEl4RXpHV2U2SDJRd0FTZzYzZVFX?=
 =?utf-8?B?U3dwUFpFblc0T0RxL0Z0SXJFcUJUMGpIN1hDcGlyRlBHbVFjVUFqSTBDRW16?=
 =?utf-8?B?aC9UTWl5MEtqVkowazgrWEdCUmZEeFU3anFWK3ZKdHI2dzdIOXlKb1ZhVjVE?=
 =?utf-8?B?QTBreEduSFYwYjhMcktzZ296QTEzdVBTZXBSNXkvMjNOYWJwejF6bFlzYm5P?=
 =?utf-8?B?Ry9zV0E0Y2RIVkcxK3RUVUticmlMY0dic0lXVHV2WjRqWDZ4L3h0YVFYR04z?=
 =?utf-8?B?NDF3RzZ5Mjd5M0tjdDBRWTFpLzJxTEY2eWhmK2tKaEhlOU1sUllDRGhITGsw?=
 =?utf-8?B?UE1oK2laTW5lcnhBcm5wYlRwd3U0WXRobVRmL2tqNmxFVnRpL0lNZi9FRzNF?=
 =?utf-8?B?VTBuMzRJdzkveDI1QXB1MVFPTmlkQmEzV05qZjhxZVA4bzBjQi9FU1k0MExB?=
 =?utf-8?B?WHY5KzlOdzNaai9IT2h1REpqRE1wditIZnZuRTZXTXU4dWhrZUUzbnJ6Y2Fy?=
 =?utf-8?B?TEdRNkZFalNWR2RPTHJrVUhhSGp5UmhhNWRsb2hJMGpIVDVpNEk1ZldGMjFp?=
 =?utf-8?B?ejEvZWsrcWprOG1XN0F2ZjBlVG8xOEZXMXlxZUltcktkMzFzV1lnQzNvb0Uw?=
 =?utf-8?B?TEwwNDZiL2dTVEVlTk9wcmVhNmVUZlE3Z2dXd25DTUEzMzFFSUd2cTdaaHdH?=
 =?utf-8?B?Q3B0bUVDVXJmeEFtb1R0amJ1MENHVnREd0N6UWF4Tlh0QUx4d3Z6clZkNE9T?=
 =?utf-8?B?a1o0eXR1bGxmR2QzWGs0bFQ3eU5Xc0RaUll6NkduWk5JSWE2T1pDY05OaHZm?=
 =?utf-8?B?aDQxUHNRaGFZS0htTGQzY0YyMEVPMDI3bmRTRDEvcmxtU1RUOG1rRGFBb1kr?=
 =?utf-8?B?RTRhVk5UVDBPU1VxQzhTK3FqS1NJVFpnTHpwTjVIUFdua203Wm50WVQrbGhT?=
 =?utf-8?B?NVF3bmdSNjNhYVJPcFY3bVoreG1lZ1QyZS8yNUJRTURibWsxREFQRk44Qit4?=
 =?utf-8?B?SHJZZ09SSWd5TlRjd2ttcXFwWm1FRVRSTE1oN2x3eGc0Y0VpQ1ArQlJ0T0I5?=
 =?utf-8?B?UmNnSW5BWlROcngyV0pPZmNKUUV1NHEyRTF6bGdYQ1pTZEJNcmpTNFFRdFJT?=
 =?utf-8?B?cHBsR3RaQlpUb2k0eWVZWUx1aVMrOG5NSXp1a1dZTUdNV2J5WHNGY05uaEx1?=
 =?utf-8?B?SXNrTUFBdFpDWUFyWGpaMG9xLzRrNGRiZmlnR0poTWM2MFg2N0loa1FHdlRR?=
 =?utf-8?B?TWd4RnZJSG5ldmJIMVZMd2xWdDBoUUhaMXI5MXBQaVh2Tm8vOGI4TDZ0T1kx?=
 =?utf-8?B?T083eWFaRmxNRnIyZkJKQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWVtdUZVVE9MSFhVWnhPQXRZOGN1STdoRUdqREhYVlFwSW95bHlSanVrYTJq?=
 =?utf-8?B?QVdjKzN0K1FJTEV4NlpWVmRCcUh1SU9uRlV0SG9jbStPWVVmSk5YQkRpc21O?=
 =?utf-8?B?eGFBcWVycG5hQk5taWN0WWwyWU5qcCtJbnQvbVl0ZVJkY0JVNkxVUzJJU2hl?=
 =?utf-8?B?eERqTy9OR25WbmxheE1Fb3Evb0JOYmFNclNRUFpGWEQxRDV0NjV5VkJwNCs3?=
 =?utf-8?B?NXFEeEE2ZEF3Y1VKYVUrN3FoUUliZGdsdWlDQkZzYTl3VHJjbGlDd2dyTVV0?=
 =?utf-8?B?ZXJZUGttRnRLN3FyNy91TW9CSVJTeUFCS0JEUjJwSEwwT1RlMGJDeVJaZ1dp?=
 =?utf-8?B?ZlNCeU5tWTJJL1VVeVU0UnlKWDhyMlBOT1pjTHNNajhpc0dhbkt5V05UVnJU?=
 =?utf-8?B?bk5uVFQrN3lIU0ZGZ2xwRDlqb0EzREFBZjFtUG54L2wrYXpHSy82aDdPOSsv?=
 =?utf-8?B?NjhoaEpQOEU4bUdWckExeDNCNzlZZ05MT0xzOGRKUmRWeW5FeUYxYzVoNUw3?=
 =?utf-8?B?UG5WS01YNmFFLzV2a1N3alI0T0YxUS9rZUEyZEZxRmMwU3k3VEMzVHROekpz?=
 =?utf-8?B?UUxPMHpEZUI0WG1wdi9mRnM0WXlqK1ptdi8zOXkwTG4wTDBTOWtQeHBOMXVx?=
 =?utf-8?B?QjVlendNRjZvUk92ZHVJSk1FR2I2aEY2aS9TNjZEb1VmMDhDUitIeXM2R25Q?=
 =?utf-8?B?aGk2TjlvVHJLSGVIOGY5VUk0RFVmbjJZNzhVNFA4SDZnRUUyRUgwdGduOHRx?=
 =?utf-8?B?SlVObVZRczhEV2RkZEN5R2ZjYWxDMjFhU0xnZ2FzemRBNWJxd0hrZ2ZHMk9q?=
 =?utf-8?B?QURyNjk3emxzM2FGenNKVHZTWmJuU1FCRmkySWVPMjRrcFM4SkYvdW9ySzFK?=
 =?utf-8?B?SzJ1ZWFNMGwza01ud2xDcEljZC9Ubm8zWlcyNncwZ2t4dEcydWxXekZ1Um1P?=
 =?utf-8?B?M3dxVDk2SENORU1YV2daNjBkNnF2aC9aKzBvVS9MK3Q0aXQ3ck0vN1pwNlR4?=
 =?utf-8?B?aXhoTHY4c29Jai9aZHpiTUJ1NFlnSzJlSlBZQk4zVk12Q25vKzVKYzYvK204?=
 =?utf-8?B?d0xxRm1Hd200dlJydy9iRTZ2VFpqRlVlUk1SR1JiWTgyc2R5TUxZWHJPTTZN?=
 =?utf-8?B?cEZBTVdYWXFQekVrM3RyeDRKNFcvTWsyeWl3OFgzWXhleVRYT0hOelFhcDI4?=
 =?utf-8?B?b3hObCtZZE16dXNPTUNEWXVTcHBPUlM2cDFuaWRxRlcxbUlTODhOSk1TM1pT?=
 =?utf-8?B?b0pPMWROWTRPeExNUkFzV0FGaUNlUTZJMm5XVXdTejlzNFlSOTdRVG1vYm8r?=
 =?utf-8?B?WThST1V0Q0RnakFVa2RFQXJacE9SaEY0eE80ejhVSUVVd2had2sxRUs4alFH?=
 =?utf-8?B?b3B0REp5N0RqcnhvUzZ0ci9iTzA3dEJvK1VzSmF2U2wreVhydmE1c1Z6V1Vk?=
 =?utf-8?B?V0lYR09uVzFuSjY4dWJrUFc4SzBZeW1kTERaeUR6S2o5MDR4ZnhBa1lVL1g5?=
 =?utf-8?B?eGlpZThyRGVXTUorWU5yZm9FSjJ1RmloNWEralhPL01KMVpSU2FZNWdZTE4x?=
 =?utf-8?B?ZTlKUkxaZzVpRWdoRWVyRGlKUHk3cUFveUNxS2hWOUs0VE41dmVrb2FKWFA5?=
 =?utf-8?B?ZVJ1dC9lSldHK2lGQ3dDQTZGL1FzTzFWUDdKREFPQWM1Wk9DS1diaTkvc3RB?=
 =?utf-8?B?RHBBazAvV1EzbEFhNzd5ZmpuZXF2M2NPa2p0ejIzTU00WVNtZ2VDY3hkUUdi?=
 =?utf-8?B?MTlRckZ1YXN0cGVoWWxXV0Nqck1veGtaWUNFZFpSS0YzNXRrbWFnSVYzYkVt?=
 =?utf-8?B?Q0VqcUZxUTlpb3V5Ullxanl6Zm5BRFUrVFErMzBPUm9sdVVoSGZvdGVJc0xh?=
 =?utf-8?B?VlVaOUE5clJ5eVJreVdyd3RlcExqa0k1VStHejhNNi8rdE1mTjZ0Y2IvOFZI?=
 =?utf-8?B?QTI1L0tRYmYrTVZpMTlJZXIwci9jMm5vaFNFUGZ0K2l4NFBEcXlPN2lEblpD?=
 =?utf-8?B?b0tzUkVNL1NEenV0Z01CSVBtME1ORGU2N1dMOFN4ZlhEK25XRkdZMTlNRGh4?=
 =?utf-8?B?N1pZWktnUnJiRXZQWGRpVy84MGwwTEhUZWk4YS9rL25MUitzazh6dndvbEJw?=
 =?utf-8?B?Z2tiOFlaTkFPODBtUytSUThZVEc4aWtjaWh2cURKSmg4ZzJCR2h6MUdxUENQ?=
 =?utf-8?B?d3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE5CC11B2CFABD4CACB929C9DC0DDF2C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4137b1f5-48e5-433d-661d-08dc644e95dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 11:06:26.3868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JsHsHLGjcRGQxuGk+Jwq/kxuVFTcDSOWUyabi9JW0+05CkgTIxd+amhyg50nuDz1aChc6lywY49CQy2XSAIcdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7922
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHhf
ZXJyb3IuYw0KPiBAQCAtMCwwICsxLDIxIEBADQo+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmll
cjogR1BMLTIuMA0KPiArLyogZnVuY3Rpb25zIHRvIHJlY29yZCBURFggU0VBTUNBTEwgZXJyb3Ig
Ki8NCj4gKw0KPiArI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPg0KPiArI2luY2x1ZGUgPGxpbnV4
L2J1Zy5oPg0KPiArDQoNCkkgZG9uJ3Qgc2VlIHdoeSB0aGUgYWJvdmUgdHdvIGFyZSBuZWVkZWQs
IGVzcGVjaWFsbHkgdGhlIGdpYW50DQo8bGludXgva2VybmVsLmg+Lg0KDQo8bGludXgvcHJpbnRr
Lmg+IHNob3VsZCBiZSBzdWZmaWNpZW50IGZvciB0aGUgY3VycmVudCBwYXRjaC4NCg==

