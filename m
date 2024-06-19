Return-Path: <kvm+bounces-19913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E31190E138
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 03:24:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FCBDB21CB4
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 01:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F18A5AD31;
	Wed, 19 Jun 2024 01:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mW4NpzF6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBAD8F6D;
	Wed, 19 Jun 2024 01:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718760235; cv=fail; b=lgmD1Et1+XILGOatrxdWMkRssfscrvR9/GkBLsNwm9BiPsN2By89v4DAIu8xvysbwGY7c5q0TKq5sPNIeCLResjFVFSdW6C0aTLkAdqoUx18xpk1HnLisbiQG3MXDvQl+RDpu0odXEAAo7OR8GPdVYwu6gGO3k6HiZUdk/kqqYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718760235; c=relaxed/simple;
	bh=86qbL5WhjDgqjt3Ol00QLeYF8bQgvg/9MfmFe4A+5Hk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F2VEONs6BewovrwOfmNN1COdft90SKLCjH2mehaIKJGYJLoI76DU47E1iu0t8/r/CzcDOmn3APLZws/9nc+rEjcjJIMku5EEAszk/o8ETw0WXlz4dqP5uWByrJDnlkc+PZaYIokI1r4nvqe+57nYIAA4cBWNMAkC7R254cZArJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mW4NpzF6; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718760233; x=1750296233;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=86qbL5WhjDgqjt3Ol00QLeYF8bQgvg/9MfmFe4A+5Hk=;
  b=mW4NpzF6w7z5z8DC2zoqOkglo3n0zrDESdVQgfjV6Z5mPJ3SWMzQzbjz
   TpLwvfy10VsZ0RWCM/BaUkNNUjlPLMs+kzhtO3E362SKiCXoJkodnRTpR
   YX/7T4i4iwsEDGgK8DYCVUjRpTAjPT7GxIm543SN9ZCm5YBP/JSFvQa5y
   nznUKH48WsFTzAZG5+RVqfyaYkRR2ydis7/1FxFbJf0w8moEK2kRY7bIE
   Kq0EU9Bz8hFNQoV54/CuPa+JiPfGKFp2A1wtxtbkVtFT4a/mpp6g6yKCo
   11CEm/mZBEGW8mhURV37E7/kohjHon+fp001PHbY0Ig8LmpR3VHsqb3V7
   w==;
X-CSE-ConnectionGUID: xd57NK7BR8+ajfi1s/ds1Q==
X-CSE-MsgGUID: pM0kBpixQQu8pUDz22hAvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="27092420"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="27092420"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 18:23:52 -0700
X-CSE-ConnectionGUID: TJsYK4heQBivWenAD46WTQ==
X-CSE-MsgGUID: dPjAtIIHS+GhTEZpJA9x+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="46177487"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jun 2024 18:23:52 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 18:23:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 18:23:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 18 Jun 2024 18:23:50 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Jun 2024 18:23:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TrP+ZUxqvG7OOs+3bbmChhwEkKBbtDCyI7ru6MZ7GqGPgTMitbHlUdo4xSFF3iaoJO1JC+R4Q5X4gLfVrN2Hj1nNgiAr5mHDR3MakNFwHvnIGAx6uOAGU3R3TOPR/+buCBjeoX6UETeJ/nxxTwHZEwM2Z9wDjy5v2lrGWkja/IhV0WzMzDW6hchyEf1mgcmdvaIx88VQuk5c3NL3iBf2499Gkk6sd4pFmeJlvm6ImZu65gKpRKBAptWthKYEp3BU0C9QOGBpXpIzV2PxpMJyQiwAY5Sa2B6hlS7KO5ECV7PWP8X8+e7uDZltaAtamVFeCTnvr6BUoUYAqvge7DLdCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86qbL5WhjDgqjt3Ol00QLeYF8bQgvg/9MfmFe4A+5Hk=;
 b=Y2xsA57nso7yNyFRrd2iHEIwJwU611pUz/TzA7r19bL4GDiwZ3JNVVNLW2joeoLKWItMtE9LUJANCO5v0qgrlvg6cawymR/rv/pGhjZGy1DpmfSYTpza+j8X51EcTf5OfzWDVbTDrgJkhFr1U4jTWvmLSE4C+xKsCmwL0mh2wPzD1+WhPk6sTrOLS/qWPx9RSjdJdiNbhq/j0eXOZqgAlwDrtv6YRrfOqtYqfCwyllNvQPX5Uxn8t3RjyZVnsqVKmtTgS0li9f/Xc3HSWKvYG6b4qrmEwCFxGjqNaXXmy5IyzGH/1h03eGwiEFgUg8Q26uB9SxyM3Xs4CrdlHDAa+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7745.namprd11.prod.outlook.com (2603:10b6:930:90::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Wed, 19 Jun
 2024 01:23:48 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7677.030; Wed, 19 Jun 2024
 01:23:48 +0000
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
Subject: Re: [PATCH 8/9] x86/virt/tdx: Exclude memory region hole within CMR
 as TDMR's reserved area
Thread-Topic: [PATCH 8/9] x86/virt/tdx: Exclude memory region hole within CMR
 as TDMR's reserved area
Thread-Index: AQHav+UTEitueRT63E611vGc3hxz1LHNo3oAgACrYgA=
Date: Wed, 19 Jun 2024 01:23:48 +0000
Message-ID: <717ba4c65ba9f1243facfcced207404c910f2410.camel@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
	 <cfbed1139887416b6fe0d130883dbe210e97d598.1718538552.git.kai.huang@intel.com>
	 <7809a177-e170-46f5-b463-3713b79acf22@suse.com>
In-Reply-To: <7809a177-e170-46f5-b463-3713b79acf22@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7745:EE_
x-ms-office365-filtering-correlation-id: a55180a9-24f2-4e56-8f17-08dc8ffe7874
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|376011|7416011|1800799021|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?ck5RcFBpWjhEaFptWWRPK1BxQUlkZ0NQSWp1Mmo1T0tDZ0tLWXZaclBYRFoz?=
 =?utf-8?B?Y0g2K0g2QllzbDVoY2w3ZDRHdHN6V1Vna0NDa01LeUJUZW1HSTVBN2dCZzJ3?=
 =?utf-8?B?RmJxZDFnN1lzTTVySHk3NTIzRDRqYWI4ZHp1bTVJaFh6NEMzcUV6OGRkY0to?=
 =?utf-8?B?TlhqOEtKZ1Q2a3RwbWtOTHVyTjM2WncvWWZod1Bsc015bkRpRnFoa2dWV1NN?=
 =?utf-8?B?c2h4K2YrUTRVMFNDdGRhU1FhOTY4VnRoQUQrVmprSk9VdUk0L21EUHAwWjBW?=
 =?utf-8?B?bTBaQ2hyWUxNN210dzVYY2h0Vkw4SzJXbVdYbWx0NDJoQ0dxSnVjcnBHWjFo?=
 =?utf-8?B?QlU0UTVmZG1VMk9yenZORURnRjRLcW5BcDhMMVZHRVI3TGt0NjY0T04rUHhC?=
 =?utf-8?B?Vnd1NzlVL2hRQ0lhQmczTTFPd1lENWZudEVxZm1CbkQzZVRCZEtTVUNmbisv?=
 =?utf-8?B?ZXpUWVJiRVlSdGV4aFM4VlZiVEdLVVhoNDJSSVA5NUlLa0xVelFocVlGTXZZ?=
 =?utf-8?B?bVg5V1AvdEthTThOODRpSElYWEhHTm5ROE4xWUNPT2JPeE5rb056RHFBTVhK?=
 =?utf-8?B?WkZSVitQTnRKcGVXZC9iU3U2c0J0UU5KWWE4eDB3Z3kyTFNNUWIrZkZmTlZM?=
 =?utf-8?B?dmJ3WWFCWURFN0JRUzNzbmh2T0RjWEFUczgxbWk3NmlBcmtZcWIwRThZdGF3?=
 =?utf-8?B?U0pWbE1XcjV3Qm5yTTJCVXFRRDVlN0daSDJuVEN4VFkzRHVIWEFhMGRBQUsw?=
 =?utf-8?B?M0lhT2QySjlxTmR5bnNVVk5iVHNHU3BHTUN3RllMVDhTVVZDdUVXZGlId1V3?=
 =?utf-8?B?VmV4YnNuRWRaUERtaE0yUnBJbndCZVBhS3I4ZHdMY2JYN1ZXSXIrU1czaUZM?=
 =?utf-8?B?ZFBwVkFzSmxqeDVvazBBR2FkUVZyVVN6ZU5LelRYNWtOTjhINnMxUnh4VHAw?=
 =?utf-8?B?OCtDazdGZy9SOTVxV3pDQUdaVnNtMmVyekFWZTFxOHVBTnk1WFgrQTE1eTZi?=
 =?utf-8?B?VUVDTnNmN3NhNU5OL3R6Zi93dnlXR002cU11TDIyUEZBYzVmaElHOVNNblFa?=
 =?utf-8?B?SGtyWkhzTTZXbEp1cHJ3MFIxR1B5bnRUVm0wb2dyZTl4TTRJWmtqa2lubTNO?=
 =?utf-8?B?cjRBcWkzbWxLRDFqUkNMaFlXeGlwc0RpQ1EvbE5YUHdMQWk4TlFNenZ0Z0ZY?=
 =?utf-8?B?Ym9rVVJ4TGNqeU9wVnp0S2lyelExd0pKMW5VdXBYWXI0WnNjNnhzT1FVLytH?=
 =?utf-8?B?ZjdERTVveDdEdm9palNwcWtLK0FsU3cwMnRXalVOc0xwcWNMYVpTditWdE5r?=
 =?utf-8?B?Z0htbC9rVTF6TnVXM21QQ0RUZ09idmk0YnYxT2RpZkF1YWlWZ3ZZL3dnRVJ1?=
 =?utf-8?B?L0VJQVZuUDBRSk56QXI2N29CcTZpazBtQjNzRGN5dVdNOXcrMmt0aUxjeU5S?=
 =?utf-8?B?bHdiTVM2NUhVeGxBZ0xoWVlwZytrV0FxaElkM0k4cmN5THBsdGdCRCtySXd3?=
 =?utf-8?B?TFRvLzRRL2VGREFCMW16ZGx5Rm5zZWxHdFRyQUk0aFB4ZmhvSVIzd2FOK2FC?=
 =?utf-8?B?V0NSZ1hnUjNsaE5oZlRtMWFDMGwwZ2Y1VytVKzJkTGtBVFR3K256czJ6TWgz?=
 =?utf-8?B?azBBelo3K2JENTVITVB2UDl5aHBFampIWGcvdXZ2bTU2RUEwQ2ZSVlFxUTRY?=
 =?utf-8?B?Qk5wRGVSZlFWWkRqV2p4NHlJVkFqZG1mNzBwZUdXNHdCdE5TaWU5ekEzWVlw?=
 =?utf-8?B?MldXYlN4R0M3ajZ3MVZiZEhtSWJWUXR2WnRRUElXczNDU0J1a2ZxWjcxS3RE?=
 =?utf-8?Q?qSyle+6U7Rx9D1fSH2ZL+4okQuOXgbQChDmnU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(7416011)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDhzYXJoWnRPM29seUtseTVGYTIycW8zQy9TR3h2NVJ0aVBnTDFIRnFkOW5D?=
 =?utf-8?B?T05JLzg3blp5SG1Ec0hvWFFXQ3dzbDZmMGszS2xoMkltTU96T0VtZEg3Vml5?=
 =?utf-8?B?S29oaUMwTDFpNGwyVUp0TXpQQy91QmpraFNUQm5zS3lwU0dMb1F6WHZQdTc1?=
 =?utf-8?B?U1FITWdtMm40d3kwYzNDcWRjN2RFNTdITDdIWk03UE93dVFUdjB4NFRtbktl?=
 =?utf-8?B?QlhIN3pFQmczSjMwSklSMjREUjdDSE9qRUdWSE1DR3ZvOHNYTDlLaEZMMjJ3?=
 =?utf-8?B?UTFGT2Q4SHM5Nkh0Zmh6OGgzcXBnbmlNUzRjYUprOVluV0YwT2QwOEw1UVRl?=
 =?utf-8?B?M0RtRUlBc0ptbEFuL1lrTDArbzdDSmozZ0dQK2NRSFJBbTNhbTdTb0UvSlg3?=
 =?utf-8?B?bkhtZjRPY3lhaU0yOHpQMDNBajhRc0xjUzJCNTZUWG5BOVpQQWZ5UTlkZGRw?=
 =?utf-8?B?YzUyamphaXZQZWVuYUk4TGkyNTA0TUJkNnRLNFI4L2d6Tk56OXBreS8yd3pY?=
 =?utf-8?B?OHR0Z3IrYXcwQ0Y4bGd4ZE9DYjdvV2ptb1V3eWFERENEQjJUanMreVM4RFJO?=
 =?utf-8?B?UStSMFRxVnpWNlIyVTRJNkpHemlGR3A0ZnEwMGJYbXZxL3FpenRibklCSCsw?=
 =?utf-8?B?bVB5cHVkSjNMTzRZczE2WmkveFVqVlI4dnowWUI1eVJ6TTJVRXlsSyszV1Z6?=
 =?utf-8?B?U0VKL0xwcjZWSlFkOUpjNk91Wng3VlhvQndHMmNuZHZNOHhaRDBqVW5yNFVp?=
 =?utf-8?B?K25TVVBKSVYxaUFmR2prRGY5N1ErZWxVZDdkS2ZCZlcvV0J0OVdHbEMvWWpK?=
 =?utf-8?B?RzdGQ1pzY1hVSkhuVjMvcHQ5S1Z5Zko3TUcySzl6ajdtS1RsQ1FRWDdzMXN4?=
 =?utf-8?B?b0pKWHAwOG9WVXZCRWlzTmRjdVdsTk5RZlR6Z1NmMTZBZ21ZT0Z2cjZqUGdS?=
 =?utf-8?B?SHpyQ0t5ZVgrNHBnWTV4eGxlc1d4Q1JlaGw3WDhRdUxLK0FnQkRINkhvQ0xP?=
 =?utf-8?B?eUlqL3FxUU00MGhkZXhmRFRteno1a1UzL2o5VTJxZVl1QWw1dFNtbDV1S0pC?=
 =?utf-8?B?VkZVNDN5RUIzbDFSQVcycFpVQzFoZ3RBT2E0d3ZrYTBkcnRwSEFXSHRrd3Zw?=
 =?utf-8?B?QkdCdER4YmNXK3pXQllxR3F5b2Y5NWFLVWVkVHJXcnRyUlBIc1pycTBEajY4?=
 =?utf-8?B?R3UzZnpRVzRXUDF3NnBKenVBMVdkekw0RWFjYzlQNm1WRW4wYWpVMXJ3bFY1?=
 =?utf-8?B?cEIwekwrVDJRc3pDVzlLLytES1JhTjdmelNlNHAvVTB2NlJyR3VxejNTV3Jm?=
 =?utf-8?B?SzBrTXNlMktXc0dIcWtBbWZWSlhueHAvc3FVZUVCTnJkYkVab2psMjVUMGRt?=
 =?utf-8?B?MU9tK1NrRmJXRUpvcjVXTVphYlBVVC9tdk1VNTVXc3ZoZ3Z3eXVMZW5Ka2Vz?=
 =?utf-8?B?U3RDRktRVGdzeGNIV1poKzNrOHEwZTNTRk9IV01GVjBQWTlldE8wTGNXV3Zx?=
 =?utf-8?B?NElKZlVPWkVTMkpUU0hqS0ZCSDcrWkl5eUtMTkFzOFE4Z3o4MW5Zd3RPaEd2?=
 =?utf-8?B?M0Rzdk1FbENiSk1xNFdRcExJaFJGSk11b25rWHpTUzFJcFBWMzV6bnBCTVpG?=
 =?utf-8?B?dlV6Y2RMc0lvdlgwNzNoRXkzTEJvRmpET2JxeFU0cHF1bGtaVW1uZTZPeGgz?=
 =?utf-8?B?cXNBUkNNVWRMbU0rZnpseVJSUlNTYVUwSHZacXFmQk1oSXRXeUhhakhzRm5J?=
 =?utf-8?B?Z1ZkdWpkdytTWTFrbDQ3MVJxZy9iNUEreEZNSWg5Y2ZqQmNIdmVYTG1SYmwz?=
 =?utf-8?B?ZnRKUDUvdG9zdUk2cElMZjdFL1BuRXNDc1h4N0RMZXNUT1JUMVNRSWZ4TWhh?=
 =?utf-8?B?VWU1QlpGb0RYbkdVb2pQaGgrVk5MNVpsRG5ERmcrU3UxdjVxOWorWUJrOG9r?=
 =?utf-8?B?eU5UV283MU00cy9oK0MyVjBJTTc1NTkxemVNd0dIUlFnVk8zSm03VktYem5o?=
 =?utf-8?B?NXNLTnVLRElOZjlQamJkWVVKdFhpSjFkbUdzK2c5RHA2Q1NlODZvVkcrUkxt?=
 =?utf-8?B?ZTAyNkRQL3JxOFFaUUhxVEJZSDRUazFXNUZjcEtsNmNrZGRWd2lQdFlTMkE4?=
 =?utf-8?Q?jfoPT8bo9zW2O5dC5w2T8wkNi?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA69FA4FAE94BA43992D0E96585CD5D3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a55180a9-24f2-4e56-8f17-08dc8ffe7874
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2024 01:23:48.4809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WCFSXE5N3VJtAM3OdKaGQkn8SIiGOAsow4GmV8k2JYWEZXhAI+hJPVuPuiNGp/xJ/28LYRH1CL/oiktlaQUetg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7745
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA2LTE4IGF0IDE4OjEwICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiAxNi4wNi4yNCDQsy4gMTU6MDEg0YcuLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4g
QSBURFggbW9kdWxlIGluaXRpYWxpemF0aW9uIGZhaWx1cmUgd2FzIHJlcG9ydGVkIG9uIGEgRW1l
cmFsZCBSYXBpZHMNCj4gPiBwbGF0Zm9ybToNCj4gPiANCj4gPiAgICB2aXJ0L3RkeDogaW5pdGlh
bGl6YXRpb24gZmFpbGVkOiBURE1SIFsweDAsIDB4ODAwMDAwMDApOiByZXNlcnZlZCBhcmVhcyBl
eGhhdXN0ZWQuDQo+ID4gICAgdmlydC90ZHg6IG1vZHVsZSBpbml0aWFsaXphdGlvbiBmYWlsZWQg
KC0yOCkNCj4gPiANCj4gPiBBcyBhIHN0ZXAgb2YgaW5pdGlhbGl6aW5nIHRoZSBURFggbW9kdWxl
LCB0aGUga2VybmVsIHRlbGxzIHRoZSBURFgNCj4gPiBtb2R1bGUgYWxsIHRoZSAiVERYLXVzYWJs
ZSBtZW1vcnkgcmVnaW9ucyIgdmlhIGEgc2V0IG9mIFREWCBhcmNoaXRlY3R1cmUNCj4gPiBkZWZp
bmVkIHN0cnVjdHVyZSAiVEQgTWVtb3J5IFJlZ2lvbiIgKFRETVIpLiAgRWFjaCBURE1SIG11c3Qg
YmUgaW4gMUdCDQo+ID4gYWxpZ25lZCBhbmQgaW4gMUdCIGdyYW51bGFyaXR5LCBhbmQgYWxsICJu
b24tVERYLXVzYWJsZSBtZW1vcnkgaG9sZXMiIGluDQo+ID4gYSBnaXZlbiBURE1SIG11c3QgYmUg
bWFya2VkIGFzIGEgInJlc2VydmVkIGFyZWEiLiAgRWFjaCBURE1SIG9ubHkNCj4gPiBzdXBwb3J0
cyBhIG1heGltdW0gbnVtYmVyIG9mIHJlc2VydmVkIGFyZWFzIHJlcG9ydGVkIGJ5IHRoZSBURFgg
bW9kdWxlLg0KPiA+IA0KPiA+IEFzIHNob3duIGFib3ZlLCB0aGUgcm9vdCBjYXVzZSBvZiB0aGlz
IGZhaWx1cmUgaXMgd2hlbiB0aGUga2VybmVsIHRyaWVzDQo+ID4gdG8gY29uc3RydWN0IGEgVERN
UiB0byBjb3ZlciBhZGRyZXNzIHJhbmdlIFsweDAsIDB4ODAwMDAwMDApLCB0aGVyZQ0KPiA+IGFy
ZSB0b28gbWFueSBtZW1vcnkgaG9sZXMgd2l0aGluIHRoYXQgcmFuZ2UgYW5kIHRoZSBudW1iZXIg
b2YgbWVtb3J5DQo+ID4gaG9sZXMgZXhjZWVkcyB0aGUgbWF4aW11bSBudW1iZXIgb2YgcmVzZXJ2
ZWQgYXJlYXMuDQo+ID4gDQo+ID4gVGhlIEU4MjAgdGFibGUgb2YgdGhhdCBwbGF0Zm9ybSAoc2Vl
IFsxXSBiZWxvdykgcmVmbGVjdHMgdGhpczogdGhlDQo+ID4gbnVtYmVyIG9mIG1lbW9yeSBob2xl
cyBhbW9uZyBlODIwICJ1c2FibGUiIGVudHJpZXMgZXhjZWVkcyAxNiwgd2hpY2ggaXMNCj4gPiB0
aGUgbWF4aW11bSBudW1iZXIgb2YgcmVzZXJ2ZWQgYXJlYXMgVERYIG1vZHVsZSBzdXBwb3J0cyBp
biBwcmFjdGljZS4NCj4gPiANCj4gPiA9PT0gRml4ID09PQ0KPiA+IA0KPiA+IFRoZXJlIGFyZSB0
d28gb3B0aW9ucyB0byBmaXggdGhpczogMSkgcHV0IGxlc3MgbWVtb3J5IGhvbGVzIGFzICJyZXNl
cnZlZA0KPiA+IGFyZWEiIHdoZW4gY29uc3RydWN0aW5nIGEgVERNUjsgMikgcmVkdWNlIHRoZSBU
RE1SJ3Mgc2l6ZSB0byBjb3ZlciBsZXNzDQo+ID4gbWVtb3J5IHJlZ2lvbnMsIHRodXMgbGVzcyBt
ZW1vcnkgaG9sZXMuDQo+ID4gDQo+ID4gT3B0aW9uIDEpIGlzIHBvc3NpYmxlLCBhbmQgaW4gZmFj
dCBpcyBlYXNpZXIgYW5kIHByZWZlcmFibGU6DQo+ID4gDQo+ID4gVERYIGFjdHVhbGx5IGhhcyBh
IGNvbmNlcHQgb2YgIkNvbnZlcnRpYmxlIE1lbW9yeSBSZWdpb25zIiAoQ01ScykuICBURFgNCj4g
PiByZXBvcnRzIGEgbGlzdCBvZiBDTVJzIHRoYXQgbWVldCBURFgncyBzZWN1cml0eSByZXF1aXJl
bWVudHMgb24gbWVtb3J5Lg0KPiA+IFREWCByZXF1aXJlcyBhbGwgdGhlICJURFgtdXNhYmxlIG1l
bW9yeSByZWdpb25zIiB0aGF0IHRoZSBrZXJuZWwgcGFzc2VzDQo+ID4gdG8gdGhlIG1vZHVsZSB2
aWEgVERNUnMsIGEuay5hLCBhbGwgdGhlICJub24tcmVzZXJ2ZWQgcmVnaW9ucyBpbiBURE1ScyIs
DQo+ID4gbXVzdCBiZSBjb252ZXJ0aWJsZSBtZW1vcnkuDQo+ID4gDQo+ID4gSW4gb3RoZXIgd29y
ZHMsIGlmIGEgbWVtb3J5IGhvbGUgaXMgaW5kZWVkIENNUiwgdGhlbiBpdCdzIG5vdCBtYW5kYXRv
cnkNCj4gDQo+IFNvIFREWCByZXF1aXJlcyBhbGwgVERNUiB0byBiZSBDTVIsIGFuZCBDTVIgcmVn
aW9ucyBhcmUgcmVwb3J0ZWQgYnkgdGhlIA0KPiBCSU9TLCBob3cgZGlkIHlvdSBhcnJpdmUgYXQg
dGhlIGNvbmNsdXNpb24gdGhhdCBpZiBhIGhvbGUgaXMgQ01SIHRoZXJlIA0KPiBpcyBubyBwb2lu
dCBpbiBjcmVhdGluZyBhIFRETVIgZm9yIGl0Pw0KDQpURFggcmVxdWlyZXMgYWxsICJub24tcmVz
ZXJ2ZWQgYXJlYXMiIGluIG9uZSBURE1SIHRvIGJlIENNUi4gIFRETVIgaXMgMUdCDQphbGlnbmVk
LCBhbmQgQ01SIGlzIDRLQiBhbGlnbmVkLiAgRnJvbSBURFgncyBwZXJzcGVjdGl2ZSwgdGhlIGtl
cm5lbCBtdXN0DQphdCBsZWFzdCBhZGQgdGhvc2Ugbm9uLUNNUiBob2xlcyBhcyAicmVzZXJ2ZWQg
YXJlYSIuICBIb3dldmVyIHRoZSBrZXJuZWwNCl9jYW5fIGFkZHMgbW9yZSBob2xlcyAoaW4gZTgy
MCkgYXMgInJlc2VydmVkIGFyZWEiLCBkZXNwaXRlIHRob3NlIGhvbGVzDQphcmUgQ01SIHBoeXNp
Y2FsbHkuDQoNCj4gDQo+ID4gZm9yIHRoZSBrZXJuZWwgdG8gYWRkIGl0IHRvIHRoZSByZXNlcnZl
ZCBhcmVhcy4gIFRoZSBudW1iZXIgb2YgY29uc3VtZWQNCj4gPiByZXNlcnZlZCBhcmVhcyBjYW4g
YmUgcmVkdWNlZCBpZiB0aGUga2VybmVsIGRvZXNuJ3QgYWRkIHRob3NlIG1lbW9yeQ0KPiA+IGhv
bGVzIGFzIHJlc2VydmVkIGFyZWEuICBOb3RlIHRoaXMgZG9lc24ndCBoYXZlIHNlY3VyaXR5IGlt
cGFjdCBiZWNhdXNlDQo+ID4gdGhlIGtlcm5lbCBpcyBvdXQgb2YgVERYJ3MgVENCIGFueXdheS4N
Cj4gPiANCj4gPiBUaGlzIGlzIGZlYXNpYmxlIGJlY2F1c2UgaW4gcHJhY3RpY2UgdGhlIENNUnMg
anVzdCByZWZsZWN0IHRoZSBuYXR1cmUgb2YNCj4gPiB3aGV0aGVyIHRoZSBSQU0gY2FuIGluZGVl
ZCBiZSB1c2VkIGJ5IFREWCwgdGh1cyBlYWNoIENNUiB0ZW5kcyB0byBiZSBhDQo+ID4gbGFyZ2Ug
cmFuZ2Ugdy9vIGJlaW5nIHNwbGl0IGludG8gc21hbGwgYXJlYXMsIGUuZy4sIGluIHRoZSB3YXkg
dGhlIGU4MjANCj4gPiB0YWJsZSBkb2VzIHRvIGNvbnRhaW4gYSBsb3QgIkFDUEkgKiIgZW50cmll
cy4gIFsyXSBiZWxvdyBzaG93cyB0aGUgQ01Scw0KPiA+IHJlcG9ydGVkIG9uIHRoZSBwcm9ibGVt
YXRpYyBwbGF0Zm9ybSAodXNpbmcgdGhlIG9mZi10cmVlIFREWCBjb2RlKS4NCj4gPiANCj4gPiBT
byBmb3IgdGhpcyBwYXJ0aWN1bGFyIG1vZHVsZSBpbml0aWFsaXphdGlvbiBmYWlsdXJlLCB0aGUg
bWVtb3J5IGhvbGVzDQo+ID4gdGhhdCBhcmUgd2l0aGluIFsweDAsIDB4ODAwMDAwMDApIGFyZSBt
b3N0bHkgaW5kZWVkIENNUi4gIEJ5IG5vdCBhZGRpbmcNCj4gPiB0aGVtIHRvIHRoZSByZXNlcnZl
ZCBhcmVhcywgdGhlIG51bWJlciBvZiBjb25zdW1lZCByZXNlcnZlZCBhcmVhcyBmb3INCj4gPiB0
aGUgVERNUiBbMHgwLCAweDgwMDAwMDAwKSBjYW4gYmUgZHJhbWF0aWNhbGx5IHJlZHVjZWQuDQo+
ID4gDQo+ID4gT24gdGhlIG90aGVyIGhhbmQsIGFsdGhvdWdoIG9wdGlvbiAyKSBpcyBhbHNvIHRo
ZW9yZXRpY2FsbHkgZmVhc2libGUsIGl0DQo+ID4gcmVxdWlyZXMgbW9yZSBjb21wbGljYXRlZCBs
b2dpYyB0byBoYW5kbGUgYXJvdW5kIHNwbGl0dGluZyBURE1SIGludG8NCj4gPiBzbWFsbGVyIG9u
ZXMuICBFLmcuLCB0b2RheSBvbmUgbWVtb3J5IHJlZ2lvbiBtdXN0IGJlIGZ1bGx5IGluIG9uZSBU
RE1SLA0KPiA+IHdoaWxlIHNwbGl0dGluZyBURE1SIHdpbGwgcmVzdWx0IGluIGVhY2ggVERNUiBv
bmx5IGNvdmVyaW5nIHBhcnQgb2Ygc29tZQ0KPiA+IG1lbW9yeSByZWdpb24uICBBbmQgdGhpcyBh
bHNvIGluY3JlYXNlcyB0aGUgdG90YWwgbnVtYmVyIG9mIFRETVJzLCB3aGljaA0KPiA+IGFsc28g
Y2Fubm90IGV4Y2VlZCBhIG1heGltdW0gdmFsdWUgdGhhdCBURFggbW9kdWxlIHN1cHBvcnRzLg0K
PiA+IA0KPiANCj4gPHNuaXA+DQo+IA0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFu
ZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGFyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYyB8IDE0OSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0NCj4g
PiAgIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaCB8ICAxMyArKysrDQo+ID4gICAyIGZpbGVz
IGNoYW5nZWQsIDE0NiBpbnNlcnRpb25zKCspLCAxNiBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBk
aWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYvdmlydC92
bXgvdGR4L3RkeC5jDQo+ID4gaW5kZXggY2VkNDBlM2I1MTZlLi44OGEwYzhiNzg4YjcgMTAwNjQ0
DQo+ID4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gKysrIGIvYXJjaC94
ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gQEAgLTI5Myw2ICsyOTMsMTAgQEAgc3RhdGljIGlu
dCBzdGJ1Zl9yZWFkX3N5c21kX2ZpZWxkKHU2NCBmaWVsZF9pZCwgdm9pZCAqc3RidWYsIGludCBv
ZmZzZXQsDQo+ID4gICAJcmV0dXJuIDA7DQo+ID4gICB9DQo+ID4gICANCj4gPiArLyogV3JhcHBl
ciB0byByZWFkIG9uZSBtZXRhZGF0YSBmaWVsZCB0byB1OC91MTYvdTMyL3U2NCAqLw0KPiA+ICsj
ZGVmaW5lIHN0YnVmX3JlYWRfc3lzbWRfc2luZ2xlKF9maWVsZF9pZCwgX3BkYXRhKQlcDQo+ID4g
KwlzdGJ1Zl9yZWFkX3N5c21kX2ZpZWxkKF9maWVsZF9pZCwgX3BkYXRhLCAwLCBzaXplb2YodHlw
ZW9mKCooX3BkYXRhKSkpKQ0KPiANCj4gV2hhdCB2YWx1ZSBkb2VzIGFkZGluZyB5ZXQgYW5vdGhl
ciBsZXZlbCBvZiBpbmRpcmVjdGlvbiBicmluZyBoZXJlPw0KDQpXZSBjb3VsZCB1c2UgdGhlIHJh
dyB2ZXJzaW9uIGluc3RlYWQ6IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkKCkuDQoNClRoaXMgd3Jh
cHBlciBhZGRpdGlvbmFsbHkgY2hlY2tzIHRoZSAnZWxlbWVudCBzaXplJyBlbmNvZGVkIGluIHRo
ZSBmaWVsZA0KSUQgbWF0Y2hlcyB0aGUgc2l6ZSB0aGF0IHBhc3NlZCBpbiwgc28gaXQgY2FuIGNh
dGNoIHBvdGVudGlhbCBrZXJuZWwgYnVnLg0KDQpCdXQgSSBjYW4gcmVtb3ZlIHRoaXMgdG8gc2lt
cGxpZnkgdGhlIGNvZGUuDQoNCj4gDQo+ID4gKw0KPiA+ICAgc3RydWN0IGZpZWxkX21hcHBpbmcg
ew0KPiA+ICAgCXU2NCBmaWVsZF9pZDsNCj4gPiAgIAlpbnQgb2Zmc2V0Ow0KPiA+IEBAIC0zNDks
NiArMzUzLDc2IEBAIHN0YXRpYyBpbnQgZ2V0X3RkeF9tb2R1bGVfdmVyc2lvbihzdHJ1Y3QgdGR4
X3N5c2luZm9fbW9kdWxlX3ZlcnNpb24gKm1vZHZlcikNCj4gPiAgIAlyZXR1cm4gc3RidWZfcmVh
ZF9zeXNtZF9tdWx0aShmaWVsZHMsIEFSUkFZX1NJWkUoZmllbGRzKSwgbW9kdmVyKTsNCj4gPiAg
IH0NCj4gPiAgIA0KPiA+ICsvKiBVcGRhdGUgdGhlIEBjbXJfaW5mby0+bnVtX2NtcnMgdG8gdHJp
bSB0YWlsIGVtcHR5IENNUnMgKi8NCj4gPiArc3RhdGljIHZvaWQgdHJpbV9lbXB0eV90YWlsX2Nt
cnMoc3RydWN0IHRkeF9zeXNpbmZvX2Ntcl9pbmZvICpjbXJfaW5mbykNCj4gPiArew0KPiA+ICsJ
aW50IGk7DQo+ID4gKw0KPiA+ICsJZm9yIChpID0gMDsgaSA8IGNtcl9pbmZvLT5udW1fY21yczsg
aSsrKSB7DQo+ID4gKwkJdTY0IGNtcl9iYXNlID0gY21yX2luZm8tPmNtcl9iYXNlW2ldOw0KPiA+
ICsJCXU2NCBjbXJfc2l6ZSA9IGNtcl9pbmZvLT5jbXJfc2l6ZVtpXTsNCj4gPiArDQo+ID4gKwkJ
aWYgKCFjbXJfc2l6ZSkgew0KPiA+ICsJCQlXQVJOX09OX09OQ0UoY21yX2Jhc2UpOw0KPiA+ICsJ
CQlicmVhazsNCj4gPiArCQl9DQo+ID4gKw0KPiA+ICsJCS8qIFREWCBhcmNoaXRlY3R1cmU6IENN
UiBtdXN0IGJlIDRLQiBhbGlnbmVkICovDQo+ID4gKwkJV0FSTl9PTl9PTkNFKCFQQUdFX0FMSUdO
RUQoY21yX2Jhc2UpIHx8DQo+ID4gKwkJCQkhUEFHRV9BTElHTkVEKGNtcl9zaXplKSk7DQo+ID4g
Kwl9DQo+ID4gKw0KPiA+ICsJY21yX2luZm8tPm51bV9jbXJzID0gaTsNCj4gPiArfQ0KPiANCj4g
VGhhdCBmdW5jdGlvbiBpcyBzb21ld2hhdCB3ZWlyZCwgb24gdGhlIG9uZSBoYW5kIGl0cyBuYW1l
IHN1Z2dlc3RzIGl0J3MgDQo+IGRvaW5nIHNvbWUgIm9wdGltaXNhdGlvbiIgaS5lIHJlbW92aW5n
IGVtcHR5IGNtcnMsIGF0IHRoZSBzYW1lIHRpbWUgaXQgDQo+IHdpbGwgc2ltcGx5IGNhcCB0aGUg
bnVtYmVyIG9mIENNUnMgdW50aWwgaXQgbWVldHMgdGhlIGZpcnN0IGVtcHR5IENNUiwgDQoNCihz
b3JyeSBJIGZvdW5kIGl0J3MgaGFyZCB0byByZWFkIHRoZSB0ZXh0IGFib3ZlLCBidXQgSSBhbSB0
cnlpbmcgdG8gcmVwbHkpDQoNCkkgd291bGRuJ3Qgc2F5IGl0IGlzICJvcHRpbWl6YXRpb24iLiAg
V2UganVzdCB3YW50IHRvIGV4Y2x1ZGUgdGhlIGVtcHR5DQpDTVJzIHNvIHRoYXQgd2UgZG9uJ3Qg
bmVlZCB0byB3b3JyeSBhYm91dCB0aGlzIGNhc2Ugd2hlbiB3ZSBuZWVkIHRvIGxvb3ANCm92ZXIg
YWxsIENNUnMuDQoNCj4gd2hhdCBhaWYgd2UgaGF2ZSBhbmQgd2lsbCBhbHNvIFdBUk4uIEluIGZh
Y3QgaXQgY291bGQgZXZlbiBjcmFzaCB0aGUgDQo+IG1hY2hpbmUgaWYgcGFuaWNfb25fd2FybiBp
cyBlbmFibGVkLMKgDQo+IA0KDQpJIGRvbid0IGZvbGxvdyB3aHkgd2UgIndpbGwiIFdBUk4oKT8g
IElmIHRoZSBCSU9TIGlzIHNhbmUsIHRoZW4gdGhpcyBjb2RlDQp3aWxsIG5ldmVyIFdBUk4oKS4g
wqANCg0KSW4gZmFjdCwgaWYgdGhlcmUgYXJlIHNvbWUgZXJyb3IgaW4gdGhlIHJlcG9ydGVkIENN
UnMsIHRoZSBURFggaXMgbGlrZWx5DQp0byBiZSBicm9rZW4gY29tcGxldGVseSwgYW5kIHdlIGNh
bm5vdCB0cnVzdCB0aGUgbWFjaGluZSB0byBiZSBpbiB3b3JraW5nDQpzdGF0ZS4gIFNvIGlmIGFu
eSBXQVJOKCkgYWN0dWFsbHkgaGFwcGVucywgdG8gbWUgaXQncyBPSyB0byBwYW5pYyB0aGUNCmtl
cm5lbC4NCg0KDQo+IGZ1cnRoZXJtb3JlIHRoZSBhbGlnbmVtZW50IGNoZWNrcyANCj4gc3VnZ2Vz
dCBpdCdzIGFjdHVhbGx5IHNvbWUgc2FuaXR5IGNoZWNraW5nIGZ1bmN0aW9uLiBGdXJ0aGVybW9y
ZSBpZiB3ZSANCj4gaGF2ZToiDQo+IA0KPiBPUkRJTkFSWV9DTVIsRU1QVFlfQ01SLE9SRElOQVJZ
X0NNUg0KPiANCj4gKElzIHN1Y2ggYSBzY2VuYXJpbyBldmVuIHBvc3NpYmxlKSwgaW4gdGhpcyBj
YXNlIHdlJ2xsIG9tbWl0IGFsc28gdGhlIA0KPiBsYXN0IG9yZGluYXJ5IGNtciByZWdpb24/DQoN
Ckl0IGNhbm5vdCBoYXBwZW4uDQoNClRoZSBmYWN0IGlzOg0KDQoxKSBDTVIgYmFzZS9zaXplIGFy
ZSA0S0IgYWxpZ25lZC4gIFRoaXMgaXMgYXJjaGl0ZWN0dXJhbCBiZWhhdmlvdXIuDQoyKSBURFgg
YXJjaGl0ZWN0dXJhbGx5IHN1cHBvcnRzIDMyIENNUnMgbWF4aW11bWx5Ow0KMykgSW4gcHJhY3Rp
Y2UsIFREWCBjYW4ganVzdCByZXBvcnQgdGhlICdOVU1fQ01SUycgbWV0YWRhdGEgZmllbGQgYXMg
MzIsDQpidXQgdGhlcmUgY2FuIGJlIGVtcHR5L251bGwgQ01ScyBmb2xsb3dpbmcgdmFsaWQgQ01S
cy4NCjQpIEEgZW1wdHkvbnVsbCBDTVIgYmV0d2VlbiB2YWxpZCBDTVJzIGNhbm5vdCBoYXBwZW4u
DQoNClNvIHRoZSBrZXJuZWwgYXQgbGVhc3QgbmVlZHMgdG8gc2tpcC90cmltIHRob3NlIGVtcHR5
L251bGwgdGFpbCBDTVJzLiANClRoaXMgY2FuIGJlIGRvbmUgaW4gYSBmdW5jdGlvbiBsaWtlIGFi
b3ZlLCBvciB3ZSBtYW51YWxseSBjaGVjayBjbXIncw0KYmFzZS9zaXplIGJlaW5nIDAgd2hlbiB3
ZSBsb29wIG92ZXIgQ01Scy4NCg0KSGF2aW5nIGEgZnVuY3Rpb24gdG8gdHJpbSB0aGUgdGFpbCBl
bXB0eSBDTVJzIGlzIHdheSBtb3JlIHN0cmFpZ2h0Zm9yd2FyZC4NCg0KSW4gdGVybXMgb2Ygc2Fu
aXR5IGNoZWNrLCB0aGUgcXVlc3Rpb24gaXMgd2hhdCBraW5kIGxldmVsIG9mIHNhbml0eSBjaGVj
aw0Kd2Ugd2FudCB0aGUga2VybmVsIHRvIGRvLiAgVG8gY29uZmVzcywgdGhlIFdBUk4oKXMgdGhh
dCB3ZXJlIGFkZGVkIGluIHRoaXMNCnBhdGNoIGlzIGJhc2ljYWxseSBiZWNhdXNlIEkgZm91bmQg
dGhlbSBhcmUgc3RyYWlnaHRmb3J3YXJkIHRvIGFkZCwNCmJlY2F1c2UgSSBkb24ndCB3YW50IHRv
IGFkZCBhIGxvdCBvZiBzYW5pdHkgY2hlY2sganVzdCB0byBndWFyZCBzb21ldGhpbmcNCmNhbm5v
dCBoYXBwZW4gaW4gcHJhY3RpY2UuDQoNCkhvdyBhYm91dCB3ZSBqdXN0IHJlbW92ZSB0aG9zZSBX
QVJOKClzPw0KDQo+IA0KPiA+ICsNCj4gPiArI2RlZmluZSBURF9TWVNJTkZPX01BUF9DTVJfSU5G
TyhfZmllbGRfaWQsIF9tZW1iZXIpCVwNCj4gPiArCVREX1NZU0lORk9fTUFQKF9maWVsZF9pZCwg
c3RydWN0IHRkeF9zeXNpbmZvX2Ntcl9pbmZvLCBfbWVtYmVyKQ0KPiANCj4gbml0OiBBZ2Fpbiwg
bm8gcmVhbCB2YWx1ZSBpbiBpbnRyb2R1Y2luZyB5ZXQgYW5vdGhlciBsZXZlbCBvZiANCj4gaW5k
aXJlY3Rpb24gaW4gdGhpcyBjYXNlLg0KDQpTZWUgYWJvdmUuDQoNCj4gDQo+ID4gKw0KPiA+ICtz
dGF0aWMgaW50IGdldF90ZHhfY21yX2luZm8oc3RydWN0IHRkeF9zeXNpbmZvX2Ntcl9pbmZvICpj
bXJfaW5mbykNCj4gPiArew0KPiA+ICsJaW50IGksIHJldDsNCj4gPiArDQo+ID4gKwlyZXQgPSBz
dGJ1Zl9yZWFkX3N5c21kX3NpbmdsZShNRF9GSUVMRF9JRF9OVU1fQ01SUywNCj4gPiArCQkJJmNt
cl9pbmZvLT5udW1fY21ycyk7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCXJldHVybiByZXQ7DQo+
ID4gKw0KPiA+ICsJZm9yIChpID0gMDsgaSA8IGNtcl9pbmZvLT5udW1fY21yczsgaSsrKSB7DQo+
ID4gKwkJY29uc3Qgc3RydWN0IGZpZWxkX21hcHBpbmcgZmllbGRzW10gPSB7DQo+ID4gKwkJCVRE
X1NZU0lORk9fTUFQX0NNUl9JTkZPKENNUl9CQVNFMCArIGksIGNtcl9iYXNlW2ldKSwNCj4gPiAr
CQkJVERfU1lTSU5GT19NQVBfQ01SX0lORk8oQ01SX1NJWkUwICsgaSwgY21yX3NpemVbaV0pLA0K
PiA+ICsJCX07DQo+ID4gKw0KPiA+ICsJCXJldCA9IHN0YnVmX3JlYWRfc3lzbWRfbXVsdGkoZmll
bGRzLCBBUlJBWV9TSVpFKGZpZWxkcyksDQo+ID4gKwkJCQljbXJfaW5mbyk7DQo+ID4gKwkJaWYg
KHJldCkNCj4gPiArCQkJcmV0dXJuIHJldDsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwkvKg0KPiA+
ICsJICogVGhlIFREWCBtb2R1bGUgbWF5IGp1c3QgcmVwb3J0IHRoZSBtYXhpbXVtIG51bWJlciBv
ZiBDTVJzIHRoYXQNCj4gPiArCSAqIFREWCBhcmNoaXRlY3R1cmFsbHkgc3VwcG9ydHMgYXMgdGhl
IGFjdHVhbCBudW1iZXIgb2YgQ01ScywNCj4gPiArCSAqIGRlc3BpdGUgdGhlIGxhdHRlciBpcyBz
bWFsbGVyLiAgSW4gdGhpcyBjYXNlIGFsbCB0aGUgdGFpbA0KPiA+ICsJICogQ01ScyB3aWxsIGJl
IGVtcHR5LiAgVHJpbSB0aGVtIGF3YXkuDQo+ID4gKwkgKi8NCj4gPiArCXRyaW1fZW1wdHlfdGFp
bF9jbXJzKGNtcl9pbmZvKTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsN
Cj4gPiArc3RhdGljIHZvaWQgcHJpbnRfY21yX2luZm8oc3RydWN0IHRkeF9zeXNpbmZvX2Ntcl9p
bmZvICpjbXJfaW5mbykNCj4gPiArew0KPiA+ICsJaW50IGk7DQo+ID4gKw0KPiA+ICsJZm9yIChp
ID0gMDsgaSA8IGNtcl9pbmZvLT5udW1fY21yczsgaSsrKSB7DQo+ID4gKwkJdTY0IGNtcl9iYXNl
ID0gY21yX2luZm8tPmNtcl9iYXNlW2ldOw0KPiA+ICsJCXU2NCBjbXJfc2l6ZSA9IGNtcl9pbmZv
LT5jbXJfc2l6ZVtpXTsNCj4gPiArDQo+ID4gKwkJcHJfaW5mbygiQ01SWyVkXTogWzB4JWxseCwg
MHglbGx4KVxuIiwgaSwgY21yX2Jhc2UsDQo+ID4gKwkJCQljbXJfYmFzZSArIGNtcl9zaXplKTsN
Cj4gPiArCX0NCj4gPiArfQ0KPiANCj4gRG8gd2UgcmVhbGx5IHdhbnQgdG8gYWx3YXlzIHByaW50
IGFsbCBDTVIgcmVnaW9ucywgd29uJ3QgdGhhdCBiZWNvbWUgd2F5IA0KPiB0b28gc3BhbW15IGFu
ZCBpc24ndCB0aGlzIHJlYWxseSB1c2VmdWwgaW4gZGVidWcgc2NlbmFyaW9zPyBQZXJoYXBzIGdh
dGUgDQo+IHRoaXMgcGFydGljdWxhciBpbmZvcm1hdGlvbiBiZWhpbmQgYSBkZWJ1ZyBmbGFnPw0K
DQpJdCBpcyBoZWxwZnVsIHdoZW4gc29tZXRoaW5nIGdvZXMgd3JvbmcsIGFuZCB0aGF0IGNvdWxk
IGhhcHBlbiBmb3Igbm9uLQ0KZGVidWcga2VybmVscy4gIEkgdGhpbmsgd2Ugc2hvdWxkIGp1c3Qg
cHJpbnQgaXQgbGlrZSBlODIwIHRhYmxlLCBmb3Igd2hpY2gNCnRoZSBrZXJuZWwgdXNlcyBwcl9p
bmZvKCkuDQoNCg0K

