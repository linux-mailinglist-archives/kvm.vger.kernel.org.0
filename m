Return-Path: <kvm+bounces-16753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B2238BD39A
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 19:06:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8955B2816B2
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 17:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2EC515746E;
	Mon,  6 May 2024 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C9waOijG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856FC1553BC;
	Mon,  6 May 2024 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715015162; cv=fail; b=Bss0OX8Ml8xSVbOqT9d/AF4OJvnJ9kQ+2BSCHR0fpYDGZNqA8OOf0eRGrD/tonVdVIa2XapWyhqdvs98/8sEtATiwZ2gVpVFRype1aaXwVwOHfIE8WjPbdv/y2LKAdjNeaL2nOI5zfds0eBSVVKDym+cyfVJ5K4SMeCgUUZlUso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715015162; c=relaxed/simple;
	bh=zIp25tiQPRGFWdHD02tLwv04S7rgr5ldweIWCHXKT+g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KJ3HhT1eKpvaXDmsSq7ZsvApA9EyOsASRGAcuUAIgL+hscU3DXLsrBxANkzM8v7xLuPMEdcUdvSQI9tXW3JVJNMIP0Q8g+YAQ+NIjtYsQoQecSfuK0M9bLaMoSq+W5kKzsSvXBdNTjpx3rZt7mqKqMHLNgmdrn0uQ0AS8bjeqpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C9waOijG; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715015161; x=1746551161;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zIp25tiQPRGFWdHD02tLwv04S7rgr5ldweIWCHXKT+g=;
  b=C9waOijGVY1a/h04aKO6adQ4FXWyIA8VJfCf7t59EW3zmBZxlkAmbeFi
   Tx5uL3EjM4jlxaveEoDSt9jBFeAlT+2SNsDfIvAXpaNRV2ZmDlj82jAV2
   m9WHqx/iDk7t7BlOidKpsDSfuVFQ5JipDxg72bE5uLzElXYXGjINet0b4
   YqQQutNMoZnu6mcsybvDTZZghy4X3Zpn8tVi8QHF92S2ERrgLW6r5yyGY
   3UiWWAdRN9Uikh7bM4v2hX58dYL66ezumwiTkBPHvSr2/2i1fUtQ1d8Kd
   f61yNcJt9Nyoiz+mhbEO7PjiNyeQYJXxgBfhjDeGtIpcY/qv+XFv4PKo0
   Q==;
X-CSE-ConnectionGUID: kCCqhH07RQWyQcyw+3l1Bg==
X-CSE-MsgGUID: n8cIM74LSCKybLR4EtngoQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="28248076"
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="28248076"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 10:06:00 -0700
X-CSE-ConnectionGUID: FypT0XIOQfOwWoHIrcohwA==
X-CSE-MsgGUID: lAHRS2r+TzKwleOyCWSaXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="65690212"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 10:06:00 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 10:05:59 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 10:05:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 10:05:59 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 10:05:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2NZ17Z+qiQ6JmURzZTXUdH8zQRMSYd3mKyXf2TuJQmarhe1BpKBpnNRdRu7bRSQcIn3ik+vM8i3XTuzAjF5/b0wcs7YFn39U8Jbh2T7W7iE+msth8PR3ikrVCsoQ/APfK3f6R0SO+EUJUexbkXChb5N8qzYLCAKFP96OM3gtpijQ49V0iGv8MKj55PmsJ0qHTXsGw8APZOXtMmNojHBZ+57oO3wK36laVR/TOdHBMUe4J+Z7thikP2vQWkex/WZ9laLRae4IoUknAq2Grf1VXae3h2U8hfK7yL6GbnjuNJ2Q0C6NWG+CLyp6qlm2pb/QeKZIQHdMyDmON5YBZkbzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zIp25tiQPRGFWdHD02tLwv04S7rgr5ldweIWCHXKT+g=;
 b=GwMOXJ32yK0GuGZflsEb4vKW/5vyg0w8ziEd9rNYt9MGEuDvii0j+/v+EdUi47ZHI2vR1/3ej6Dpf/ew7WXmpqKRWqiZ7adVWjcqIo2urhc187DkS8FliJszun9CZYJJQjnJeiC/hBkPv9t/pLWFVVuRIBi7k9z9LhXXnoFlHpjqSeGe/9YA/Lpapv2dkTkf6IAlGH85gkr/AybtEMOZrNr7+x3sUiJJHVjJ68qGu0fX2/cueamEj4P37wXtlFOEiT5wMxL+B4x9K26HC+oAROyOwSptnlh66HwcqhGDhhgctppX8TgGwPyHfPPr1wCRpMQT/xY//e/4V0QcHN/2Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB7376.namprd11.prod.outlook.com (2603:10b6:8:100::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.30; Mon, 6 May
 2024 17:05:56 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7544.036; Mon, 6 May 2024
 17:05:56 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
Thread-Topic: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX
 and advertise to userspace
Thread-Index: AQHaYwfynhk8CrwGC0ayixDi2U+bW7GDdNgAgAbyCQCAAIJfgA==
Date: Mon, 6 May 2024 17:05:56 +0000
Message-ID: <038379acaf26dd942a744290bde0fc772084dbe9.camel@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
	 <20240219074733.122080-25-weijiang.yang@intel.com>
	 <ZjLNEPwXwPFJ5HJ3@google.com>
	 <e39f609f-314b-43c7-b297-5c01e90c023a@intel.com>
In-Reply-To: <e39f609f-314b-43c7-b297-5c01e90c023a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB7376:EE_
x-ms-office365-filtering-correlation-id: f2dbbefa-5e81-459b-340a-08dc6deecbbb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?cUxySUFtbHBPWHRxKzVQeEVLTTl2Qkp3ajlMdE9Rd2xrVmZoZG43RCtQZFJy?=
 =?utf-8?B?c2dNQXA0K2t4OVFpRExLMGZhcW5XZHlwbWU2aUE0R1hmOEROYy9ibUFNb1o2?=
 =?utf-8?B?NGNkeHNPYVErTGo2Q0lKNXRFQ2VQNkdLeDhIaFBCUWVmekUyTUkrRzJneUdn?=
 =?utf-8?B?RVpzeHh4NXZJUVpXdWxBR3p5Q05aQ2o3cUhxdXBmL0pmQjc3R0VxSGFsdUpt?=
 =?utf-8?B?aVNCNmZzdGZYcDBOK3dDb1JhV3VLRm5vLy8yUU15Njh3eVF2ellmOXhYMjBY?=
 =?utf-8?B?UWpYaGdybUV2QnJNZ292dDhva3FabTZHb0VnclBXVFdFMVM4YTVVTVlIeGx4?=
 =?utf-8?B?Zm9aVkFab1ZkSG9lL0I1ek8vVjQ5ZjlEU1dCcTNaRmlGU0xGTHg2SjRCamt2?=
 =?utf-8?B?Ky9EVE96M2YrUjZWRlJFV3pzbXc2RUhNNFJXdjZEQ3k3dVpCenRSMDgyL1k5?=
 =?utf-8?B?N2RTV3ZLa1JvVmI3ZG9FU3RUVXh1SXdTa09BWklKVjFqdVlETUE2alZQWHhZ?=
 =?utf-8?B?ODFybWhFQlkxUFIzZkNCWTdNRW50VHd2MjdpR0tPV1lCb1orYnkxdkpxUHJw?=
 =?utf-8?B?b0ZublIyNldQcTdhZWZvWHdEUW82em1UVkFwQkRhSkpjNFV3K0VtdjJ1UjFn?=
 =?utf-8?B?WUwvU21xd1ZqSDRjU1dXT090OXpJSXluSkx6eDE5VEU5Q0Q3SVNrNFBPdkJp?=
 =?utf-8?B?K2VqVXR0ZEs0UkFYbnZIVFlkYkQ1UUV6aXBLeHZkMVZqeUhTQkVtNG40TkIw?=
 =?utf-8?B?VktGTWczek5BdkZoOWhsZ3ZGbjRwaGhPZi9PRFdHOGI4d3lkMEtUenY4cWNS?=
 =?utf-8?B?RndUaFJUZnRwR3JwQXNTbWNpbHNXYXZlNURaZlF3cUJYNUtmdkxvbmVaQVpm?=
 =?utf-8?B?anJQdy9mNFpMdGtjTjVxbjZnZ1RqUHo3aCtKR201YXV2VHlEdkFWMGJqMUVN?=
 =?utf-8?B?MjlrNkpITGpjcmFTRzcwVFJPa0NLc2x6clFiV0VWTEh4Vi9DRngrRXMvT1lr?=
 =?utf-8?B?L2sxRGhtLzBPckhSTzNLaGhCaFoyNjc3NE1NUmM2Ykl5cFJYamRUejRzaTF5?=
 =?utf-8?B?dEFSeGllQUpXTi9uQStVTno1WEJYWStKMjhoUmNWa09lVEl0clNjZ09QbW1X?=
 =?utf-8?B?VCtpVmNiam1oL1krMHRjb0o1Q0w5U3VDVktvUGtEQ2NDbGI5SWMvQjFZNXE0?=
 =?utf-8?B?WjJNc2NYSEs4VnA5TGZlZFQ5MmpIZTEzaXZrU3A3cVVSVnBNQnlpYXhXMTJv?=
 =?utf-8?B?Q0NQb1lmeXdSU1V4ZmJvaWx6QzFwWWxWSjFPZFN2YzJ3dUJ3c3E3b0g3YXZF?=
 =?utf-8?B?K0h4Tmlyb2JzZjhkZm5nQUUrY1pRZlpQMmNsYkFBS0I4aU1XRmIvbitvc1dr?=
 =?utf-8?B?UlFJdUZFYWFablJNb3I1YW9PbnFsaWlxajkvTytVNUxLREdBWC9aOThHUkNu?=
 =?utf-8?B?V0pKc2xwbm80MWZqdmMrSnI5NUdyS29VbWdTcW5Da3VmQy9kaDJYNUpOcTVC?=
 =?utf-8?B?OW5WN0tLTUh6dnR6SVR6S1h6NEhMK3A4WnRpSUVkaFk2a2czdTYvRklrZmd0?=
 =?utf-8?B?cDVZMWd0R04zNWErM2tXNHo1eXVZeUIrak9kVlZTeW1SektvUHZKbThONzRq?=
 =?utf-8?B?RVRrRHFpaUdPb0pTWHBJRzBKR0Zzakt5M0tSbVJONXNVNEZKZm5PaFEyZUdM?=
 =?utf-8?B?YWpPamJrbDN1RFE2c0dvV0prNU9IUk95SitiMGh0N1l5azhBT0x5bzB3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cCt5MFB5dnpnekh2Y3VIakNDb3FJOFR5RFhLWDFlREV4dlJkTzN2a3NLMlM4?=
 =?utf-8?B?TG82YmpmUVd5MUJqTWo4UEM3MzJNYmF1dmxRNE9qQ1hxUnZhNGE0SHRMaTNu?=
 =?utf-8?B?VGNlZktTdDhHNDNJSS8ydHkybmZkUTFOTERkb3VIOGpET09hVll1RTdlWjAz?=
 =?utf-8?B?eUNkUEg0SkdoZGl2M3BnNjg0WXltOTZlUCtUalkxR0dqeUhNUXhCUHZBMSt1?=
 =?utf-8?B?T1JSS3d3TEd2MXcvc05aa2dqUEJBeVcyT3c0WjIyOHRZZFVXWDFjZ2Zna0NL?=
 =?utf-8?B?RWkvaEtmcU1ndVM1cFJZRExGbGVMRkdOaWZaMSsySklvc1EzN3d0MFNTNkJQ?=
 =?utf-8?B?dTFmOEtOdUdVL1JTUnJ2WHVkSzh2TlFSWFRWUGhEdUU2VzNuK3dBc2FpKzJ3?=
 =?utf-8?B?R1p6RDN1aVdpVllBTHdzay94OVU4UDZ2eSt5TGFNWTBoNWN2WTZvTFVKT05Z?=
 =?utf-8?B?WHByRDFhZmU5L2pKMXo3WmJjZ0J6MEpJRzNXZExYUEZ0MHc4NmtXQnRFUkFE?=
 =?utf-8?B?dmhxb0lkUTFkTUNDV1ZWbDdHUmE3VXgrZHNNL3l5Z1ovWmV2NUFka01zdC9m?=
 =?utf-8?B?cFBOeHFiUGp1Tjk1RndNMTl3VWFTZ0J4MDBDbmNxUlhOdmtiVmc2N2l5dTE2?=
 =?utf-8?B?SkZWSks1SXFZTEM0dmNRa0FlQm42MjlFNlNhSVRuS1ppUC9GMnhhY1RZZFlx?=
 =?utf-8?B?bktEVGN2TGsrbW5kRVkzUmlkWjNpS2dtQ1ZzS2lrKzU4c2RWK2w5RWN2RVlY?=
 =?utf-8?B?TDR2WXZ6UHd5bENwbUNtTDNlNmFXQ3gxY0I0YXhrZEkvaTI3dldwOW05ZmMy?=
 =?utf-8?B?dytOa3I3SHVSRTRhcms5NE1wVWdNakZUMUVyMmlzR3RDbkNScHRaK0ttMFlU?=
 =?utf-8?B?dG5zQjVrVDBXdHRQZjJrekZQSHR0THRscmFiQjBSbE90SExGMmJ4OENyTVFH?=
 =?utf-8?B?dnRkVFZzRUcyOS9nY3dQODd5d2kvbkI4TkdYZkVpTlpMdW50eXpkRnFNaThQ?=
 =?utf-8?B?TmZNSTRZQnlIMmYwQWo4VDNWbUg3ZVhybGMyTHBmRU5hQWZrdnZXMEltcHlt?=
 =?utf-8?B?bThhV0xjYm1waUhKL2ZWQzU1SVVUaEc5cm5Db3NoQVhtMlZOaGI4VGUxaW8w?=
 =?utf-8?B?VEZwaEU5WUE3b29Rc000WmJHaTNva0loQXlncVgvcVFuS3RQOGNlLzZsMlRT?=
 =?utf-8?B?dTRPSHNmTHArSkJyZUk3Tkdnckw1QVRXVmNmT2RXUERDRHA2a1VmVEN6RjBS?=
 =?utf-8?B?SkNVSitPYWlJVEtQVVZoSFZhN2V4QlZkSjZWZ2FFZTc4dVFDVDhFWEc0aFdL?=
 =?utf-8?B?WXRMcjZ3RXRiSUhUaEUwSmwzcllybUlXaDZYbXVzZUpMYlJRRnU4Zi90cUxG?=
 =?utf-8?B?eUNKcXZ1Y25XaVFPUk9DTGtidEhxREFGZUpMQWhRL0tkZldEK1VZZ1E1QUNs?=
 =?utf-8?B?RHB5MU9aTnk1eHBpcGxVek4zR2pFc0RsajI2dGFWNi9vUmFKNGExMkZXOGVw?=
 =?utf-8?B?ZHBpSDJ1eVdtek83OFZ2U082eG5raVdxL1V3ZlVDVUtvVkluMExnUXZaSlR5?=
 =?utf-8?B?MHR6TXpwcEs1dHFDZFZaWHlGbWEvUThnaFJmSFNNeHFuUGtuZzNEYVMyZFBk?=
 =?utf-8?B?RTE4ckhPSi96YkVydHdBbUpUcVhlUkJOY3R3Zmo5b3VlNU5vYjVkTFh4UGZE?=
 =?utf-8?B?SGFpdWUvNDRpUVIxcGxsUkwyNEFncTZkV2lYSDQyTDJ0d0MrbmVCQlJCOUVY?=
 =?utf-8?B?M0dGZmZuNHJLK3l3bC9vOEtpdTBoWmp4b2FoK1JJeVdLY2dEbHlQbW15RjlD?=
 =?utf-8?B?clovZDRnRFJtMU9RZGR6bWJ5SlU5VURVWkhNc1ludEFEQWZ1R0pacWFvTm01?=
 =?utf-8?B?YUVMVkt4QjN5MWk2OVF1Q29hd21lYmpMVzJBSjlOYjlULzdRaGJ1cjVtcGFT?=
 =?utf-8?B?RDYzeVJlOFlQSlI0RDRkY1h5TStUQWd6YnplSzVka29ma1FYc0xBbFNKM1g4?=
 =?utf-8?B?K3QzUHJROWhCcTBESVA3dTlnWUM2OG4rUVdZRGJJSHJTamljdkVWakhWUnpu?=
 =?utf-8?B?MUp1TmI0enRvRW01QldWKzcyYWk2dFJvb3lXRUlabmFFK0hFZE9JVTJtS2Z5?=
 =?utf-8?B?SjRxREtubEU0SEtFTkVSSFB0TURYS05kTTZjQkp4WXgxVlcrZlVDZzVTYmtt?=
 =?utf-8?B?cXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B389007C3CA7240B035B8A00AA4F11B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2dbbefa-5e81-459b-340a-08dc6deecbbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2024 17:05:56.7194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tcUCJFHbkbrDuKeL3MkjtW3iy/COvy+CeJnplKNSx1APi9BVU16AZ7VEF7mPllWh9tQWSgBnRvrJtcDWbeSFhOrATFgqMy67jQ7U9aMGxyU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7376
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA1LTA2IGF0IDE3OjE5ICswODAwLCBZYW5nLCBXZWlqaWFuZyB3cm90ZToN
Cj4gT24gNS8yLzIwMjQgNzoxNSBBTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiBP
biBTdW4sIEZlYiAxOCwgMjAyNCwgWWFuZyBXZWlqaWFuZyB3cm90ZToNCj4gPiA+IEBAIC02OTYs
NiArNjk3LDIwIEBAIHZvaWQga3ZtX3NldF9jcHVfY2Fwcyh2b2lkKQ0KPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBrdm1fY3B1X2NhcF9zZXQoWDg2X0ZFQVRVUkVfSU5URUxf
U1RJQlApOw0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIChib290X2NwdV9oYXMoWDg2X0ZFQVRV
UkVfQU1EX1NTQkQpKQ0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBrdm1f
Y3B1X2NhcF9zZXQoWDg2X0ZFQVRVUkVfU1BFQ19DVFJMX1NTQkQpOw0KPiA+ID4gK8KgwqDCoMKg
wqDCoMKgLyoNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoCAqIERvbid0IHVzZSBib290X2NwdV9oYXMo
KSB0byBjaGVjayBhdmFpbGFiaWxpdHkgb2YgSUJUIGJlY2F1c2UNCj4gPiA+IHRoZQ0KPiA+ID4g
K8KgwqDCoMKgwqDCoMKgICogZmVhdHVyZSBiaXQgaXMgY2xlYXJlZCBpbiBib290X2NwdV9kYXRh
IHdoZW4gaWJ0PW9mZiBpcyBhcHBsaWVkDQo+ID4gPiArwqDCoMKgwqDCoMKgwqAgKiBpbiBob3N0
IGNtZGxpbmUuDQo+ID4gSSdtIG5vdCBjb252aW5jZWQgdGhpcyBpcyBhIGdvb2QgcmVhc29uIHRv
IGRpdmVyZ2UgZnJvbSB0aGUgaG9zdCBrZXJuZWwuwqANCj4gPiBFLmcuDQo+ID4gUENJRCBhbmQg
bWFueSBvdGhlciBmZWF0dXJlcyBob25vciB0aGUgaG9zdCBzZXR1cCwgSSBkb24ndCBzZWUgd2hh
dCBtYWtlcw0KPiA+IElCVA0KPiA+IHNwZWNpYWwuDQo+IA0KPiBUaGlzIGlzIG1vc3RseSBiYXNl
ZCBvbiBvdXIgdXNlciBleHBlcmllbmNlIGFuZCB0aGUgaHlwb3RoZXNpcyBmb3IgY2xvdWQNCj4g
Y29tcHV0aW5nOg0KPiBXaGVuIHdlIGV2b2x2ZSBob3N0IGtlcm5lbHMsIHdlIGNvbnN0YW50bHkg
ZW5jb3VudGVyIGlzc3VlcyB3aGVuIGtlcm5lbCBJQlQgaXMNCj4gb24sDQo+IHNvIHdlIGhhdmUg
dG8gZGlzYWJsZSBrZXJuZWwgSUJUIGJ5IGFkZGluZyBpYnQ9b2ZmLiBCdXQgd2UgbmVlZCB0byB0
ZXN0IHRoZQ0KPiBDRVQgZmVhdHVyZXMNCj4gaW4gVk0sIGlmIHdlIGp1c3Qgc2ltcGx5IHJlZmVy
IHRvIGhvc3QgYm9vdCBjcHVpZCBkYXRhLCB0aGVuIElCVCBjYW5ub3QgYmUNCj4gZW5hYmxlZCBp
bg0KPiBWTSB3aGljaCBtYWtlcyBDRVQgZmVhdHVyZXMgaW5jb21wbGV0ZSBpbiBndWVzdC4NCj4g
DQo+IEkgZ3Vlc3MgaW4gY2xvdWQgY29tcHV0aW5nLCBpdCBjb3VsZCBydW4gaW50byBzaW1pbGFy
IGRpbGVtbWEuIEluIHRoaXMgY2FzZSwNCj4gdGhlIHRlbmFudA0KPiBjYW5ub3QgYmVuZWZpdCB0
aGUgZmVhdHVyZSBqdXN0IGJlY2F1c2Ugb2YgaG9zdCBTVyBwcm9ibGVtLiBJIGtub3cgY3VycmVu
dGx5DQo+IEtWTQ0KPiBleGNlcHQgTEE1NyBhbHdheXMgaG9ub3JzIGhvc3QgZmVhdHVyZSBjb25m
aWd1cmF0aW9ucywgYnV0IGluIENFVCBjYXNlLCB0aGVyZQ0KPiBjb3VsZCBiZQ0KPiBkaXZlcmdl
bmNlIHdydCBob25vcmluZyBob3N0IGNvbmZpZ3VyYXRpb24gYXMgbG9uZyBhcyB0aGVyZSdzIG5v
IHF1aXJrIGZvciB0aGUNCj4gZmVhdHVyZS4NCj4gDQo+IEJ1dCBJIHRoaW5rIHRoZSBpc3N1ZSBp
cyBzdGlsbCBvcGVuIGZvciBkaXNjdXNzaW9uLi4uDQoNCkkgdGhpbmsgdGhlIGJhY2sgYW5kIGZv
cnRoIEkgcmVtZW1iZXJlZCB3YXMgYWN0dWFsbHkgYXJvdW5kIFNHWCBJQlQsIGJ1dCBJIGRpZA0K
ZmluZCB0aGlzIHRocmVhZDoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMzExMjgw
ODUwMjUuR0EzODE4QG5vaXN5LnByb2dyYW1taW5nLmtpY2tzLWFzcy5uZXQvDQoNCkRpc2FibGlu
ZyBrZXJuZWwgSUJUIGVuZm9yY2VtZW50IHdpdGhvdXQgZGlzYWJsaW5nIEtWTSBJQlQgc2VlbXMg
d29ydGh3aGlsZS4gQnV0DQp0aGUgc29sdXRpb24gaXMgdG8gbm90IHRvIG5vdCBob25vciBob3N0
IHN1cHBvcnQuIEl0IGlzIHRvIGhhdmUga2VybmVsIElCVCBub3QNCmNsZWFyIHRoZSBmZWF0dXJl
IGZsYWcgYW5kIGluc3RlYWQgY2xlYXIgc29tZXRoaW5nIGVsc2UuIFRoaXMgY2FuIGJlIGRvbmUN
CmluZGVwZW5kZW50bHkgb2YgdGhlIEtWTSBzZXJpZXMuDQo=

