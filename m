Return-Path: <kvm+bounces-15731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A6CF8AFC5A
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 00:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 227FD285335
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 22:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9A331758;
	Tue, 23 Apr 2024 22:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X0iOvtgT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39B91C6BE;
	Tue, 23 Apr 2024 22:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713913190; cv=fail; b=YpqlwNZ6X0ux9zNB0Wr7EYnv59bcHnShqnmW5nIWjMTn4n9AnjmIKPz/woyRNLaQ9RoBv5DdWVjIIwmZrXbCUVgo1fKntZbUs3mqflz70gkkjVKA1Jpor+KDY+89rGgOtFpIp3Z3CA0Jm3iJPQ4cP41bwDzXwFXf3OoeU16CG0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713913190; c=relaxed/simple;
	bh=WRdqCqsMuHw7C8rkZj8X4KWq2EMZnL6m6IRROGNAmr8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G0lqi+jNYREVFU9VQ00qN77/iDDY2sm6UN8qTJ4NLPlo/P1S31tfL35HLIDKe1TGDQhJBqwGBySO8CxbTU+Fzq3Rj3PsX+bMuGcBxrZsXHssqLF3Z3ofgY5P2s0g89liN58PHoyXGfRhAnH0yQEYWbYj/5FUrFuy1p6qI+h1xtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X0iOvtgT; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713913189; x=1745449189;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WRdqCqsMuHw7C8rkZj8X4KWq2EMZnL6m6IRROGNAmr8=;
  b=X0iOvtgT5Zw1O8TukCakMbEwWsLtKAahex+9UphNueqQs3DJLzzwXfjm
   GsE6pgE0yVZsj7t7GFkf/Prz9a9ARxxwe2PAN3ik1rcYKcuDNoWgTnzcw
   KIMxOA3IUYpqpKlH9t/iAapaNFYhbYlqRtf66vnAxgfWZDIDjeBpWB4pG
   jV6gOpel7Fxw1zcMjFEjpEBY4YyZKHcGuRnaHeJq1Z7CIscvjnXf9tEoy
   2nFwOo5rN8n0VqdeackCO2gkl61indhNAM0Iuy9vIC6/akw7kU+ewyRf3
   xugb0P3wBXOvPrVA7vc959gbDyP+i7bQcn0JPIs/nS+dN5YddY4hERaHC
   A==;
X-CSE-ConnectionGUID: eaNW8VIwQdS3SUlhVCCDig==
X-CSE-MsgGUID: rhdhuAknQNi1lmztvzAu7Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="20943651"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="20943651"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 15:59:48 -0700
X-CSE-ConnectionGUID: yIwTA6JkTIaZwWoYveP3OA==
X-CSE-MsgGUID: ou5aDJeVRHC9EojCUswqNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="61967009"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 15:59:49 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 15:59:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 15:59:47 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 15:59:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4KDxrHSiiKUShOMyLyR1tZ+tq3/0WhHoAQ09bqR2qwXevPblKieCONriiHOaPZNsuuhqNmlDkDg/U/6/VqPRJCb1xM6m5lPUAxzTG3Wp9DVenUk0cwFgYQyL6FNIV07aRr16+D1mFazZ1C6hqL1cdSGk71kIlkNe2bTxZqqYnozSoKbWSxiVFb0mi95Go8jUefanl7vrINy50vofsxZNRSaQ1BDQIpVddB0qpPtXa1JOrvAxNWfrFnsnpnmrx5rTTDrc0/Qis3wOgyqQKjsWY/A7JP3X8AcZAYTKiwMQtVFXOK2cUrrckmkiixWLx0umCPZuPNphpAqSE8skqpZQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRdqCqsMuHw7C8rkZj8X4KWq2EMZnL6m6IRROGNAmr8=;
 b=JaCGyEhZModbNGQXyybVrepEaDugbjPzlaP3ZNeGCRU/35OZkgdJN2/0vjdgXHZzDAUM6+ikO71uYzyiSuu9pmQh/znANFD5Q/gjYtpQWPWUzBLVjiq27W1LtXB4oTZ1EaXQ8WRhj3CNuS786EcXxT3vnDI1w/A7GwtAKXAxQvDpPA7LTkD2IfOotN0KY+JMYci3xCUFSzWFFatsv6SMsytJOz6iGrGgwH7XufqfFph8eRVjfXSTWAO86EYZVKri0Wr/HIbiChkfupYqlqeoHbO8/LrHYU2VWFW3DXlfq3s+NWt4adTsUwZgYHZE3+c/5mih/rncV4ecjx6NUv6zdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6610.namprd11.prod.outlook.com (2603:10b6:510:1cd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Tue, 23 Apr
 2024 22:59:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 22:59:43 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLFCUFIAgAIc5oCAHVMCAIAAJnsAgACCNICAAPghAIAAlYYAgAe6DYCAARI+AIAAFk4AgACOYoCAAAdQgIAAE+EAgADmKACAAJDvAIABMcMAgARpbwCAAEVEAIAAYpQAgAAWqwCAABgFAIAAAz+AgADiNACAAIG7gA==
Date: Tue, 23 Apr 2024 22:59:43 +0000
Message-ID: <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
References: <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
	 <ZiEulnEr4TiYQxsB@google.com>
	 <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
	 <ZiKoqMk-wZKdiar9@google.com>
	 <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
	 <ZiaWMpNm30DD1A-0@google.com>
	 <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
	 <Zib76LqLfWg3QkwB@google.com>
	 <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
	 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
	 <ZifQiCBPVeld-p8Y@google.com>
In-Reply-To: <ZifQiCBPVeld-p8Y@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6610:EE_
x-ms-office365-filtering-correlation-id: 74fa8d40-f044-4207-2897-08dc63e91045
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?V1BmS3E1c2RUL1dPVmFxT1ZmZkxDMXFNcEs0eU5SdG9ZZ2M3eDlQNkdtNHM0?=
 =?utf-8?B?SHZoalhQTFJDOVVqbnMweDJneklKTlVDWmMwa3gzWXU0akxHbHV6ZTlRNEJn?=
 =?utf-8?B?TlFocEFDT0padkRtZ0ZGSHBFMWFBaGpOR1NaZU1uM3ByaHBpWk1IQkRKbU1C?=
 =?utf-8?B?c0RVNHlVQmxJVzY1ejhQTEtWWlFIMTNVYVppN2xYYmdSWjJmVWwwaGlRSVlu?=
 =?utf-8?B?ZmNHTnI1QU9Yc1FvYll6MWoxa2xmQ0ZTK2JabWRoY1I1YUszZE9za0MrQXJt?=
 =?utf-8?B?TmJKTlozT2lSVzRHNURvWklOM3VHSXlSb0JNb0JGaU1ZN21Dc0ZOUFZ0NWsx?=
 =?utf-8?B?VlZGWS8wTTZ0eng0ZFJnaUpTbzR1MlpFd3lRKzZodFM4SHo5Y0U4Zi9rN3Bj?=
 =?utf-8?B?VzlMZ3NwVXp2ek9KTWNINGlFaGNETmxPLytPekhabTNVVHVHaGhFSW1JQWxi?=
 =?utf-8?B?VndTTFNQRXdNc0N3R1pkY2FMRWZ1clhjT0ROMStMWGhJY2gxWHc0a0IzZDFn?=
 =?utf-8?B?OXNZcmY1MW5FSnh2cDE1NnVTUXVlU2xncEhmNk5xcjdPbWJ6QnFpR2R1Wm5R?=
 =?utf-8?B?Rm5pdW42VU9YZ3BxTzlkd25JNytDNC85NDAwaXFTandwUWdCUTdaempGekd0?=
 =?utf-8?B?ZEZEcW5XZElYM2E3b3FCUlp2U1M4eDZuRXRHc0hkRVB5cFdXelBLc2c0Yi94?=
 =?utf-8?B?aFZxOFRkaDBjb1g3cW4rN1A0UjVTVjZLVUp3dUJDN3VlVFRhejVwN2FrN2J3?=
 =?utf-8?B?eWVBZ1NzZW5CNktRbWRQWHhyN2NVbG5TVHV1TlZlcjhvcVViOTN2YXhaUHQy?=
 =?utf-8?B?VjFSRHl5Rlg3MDRhR3dPL1FQTjd0K1pJclYzMkVidVRHenJNc1I1MmlPbmU0?=
 =?utf-8?B?Zy9DVnQrVFZqYkM2dnJHL1E4c2VnQkhtMjRzSjMvZkVRSTNOc292a0VoNEpL?=
 =?utf-8?B?NnFzTWJJTmNBYnAvL2JoUnY4Y2F4WlYyOHdaZGdITmg2SzAraXM3eXIzbFlh?=
 =?utf-8?B?WUZrV3pkWFBielIrcnprMExQcnpEYXdRKzZIWkN2TjR2MmxmakRQMTM5YnQw?=
 =?utf-8?B?blpZRllIMmdOd09CRjNPRlowNllRenVsOTZLT1lKWmF4aDhrNHUxT1hoWlpQ?=
 =?utf-8?B?R1dIcVlvY0pLTnBIekE1MWFCL0VwcFZSR09HWFNGbURGRUxiSXBNTmJSZnhB?=
 =?utf-8?B?WVpFTFo4dDFUcEJCWlRXSUpXS0JSMzF3bXlSUzBKQlE2SEFHSkw0VHZ0TW05?=
 =?utf-8?B?UW1nTVc3eUxhY0ppYy9XeEJMd0hZOTQ1QWpmOWNFM01hRFZ5Qm4xRWJnbWVZ?=
 =?utf-8?B?VitMVks0R2ptcCt1a1ZtYlZkbVRXV3RyZi95VmVaZmpaRWtOL2F5NFNYL2Rx?=
 =?utf-8?B?ZEltdk91SlNYSW5jbEpKSjJiL2tkSW9sekFWYkRrWXVmb1g5U2I2RGg1aGRI?=
 =?utf-8?B?aVJTME10UVI0cHFGZFYvY3BIbkMrdkJHZU1sbnQyYThqN0pmbDAzUlMzd1RP?=
 =?utf-8?B?bjAwTS9wQ3VXeDl3eFNZb3lCd3l4WjFTTjlKM25MR3FJN0RWRTZIa1JxSTJW?=
 =?utf-8?B?ODM5c2xBMTdhNG43akpqSkNROHZOdy9WaWo4QlQwaEhxcUpxV3hDTkRDMDJJ?=
 =?utf-8?B?UmZvSlNNSVpIYWFoTDdsYk9sRmxvcTJiNzNadkVCNjFhM2YrUTg1RjVRWGMw?=
 =?utf-8?B?aFNYMFU3TmVxTDZxMERjQVR5Tzd5UW0zV2dORHFxRVlGeUgvTVhtYXI3NXRi?=
 =?utf-8?Q?dUJEI0QhRYvMIJ9kLE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1RwWHlkVElSelcxWGoyYkZITXBKb1Nua1VIcDNvTlZsYldNTVNNcHFPdEZK?=
 =?utf-8?B?RW0rR3hmVmdCbXB1NTNJZjhKQXhCb21mdU5KVmkrUEltYStmbFIvY3dFRDh4?=
 =?utf-8?B?dEJlMEtGbnU1VGphQStRK2NFWE9RbkZKSWVsM0hXTkJIYTgyRW0wR1d2eHdF?=
 =?utf-8?B?bEdiczhvbHdHYmowVDE1b1FycDlmRzdMQWtPbkFMTzhXOFY1N0JpbGdPRG5T?=
 =?utf-8?B?Rjl1ZTZFak5mKzdsT3MyYWZaQ1JCSk40WUpTYnkrVGhNR09PODZhSG14Witx?=
 =?utf-8?B?a2VVdDUvbXlDWElVK2dnRWl6K0JzR1ZaMGRkWVBSQlp0Q3RuVjZzUTh3eGFs?=
 =?utf-8?B?YytXQlBTcXlLby9iVmEvUmZBbnA5NVp6WkExdzBGSDFWZmNzcHJwN0hlRWhl?=
 =?utf-8?B?blc3cUtuSTZZTnpjU2VvL1RUajhZamRaVXVPUFFGTEJuL1N0aFpPR0NWZm1O?=
 =?utf-8?B?c3MrbnBRU1NCcnVxbXJBRzFXaG14QkFHZ3U0MFJwNXVDS1dTZVlFYUdqalY4?=
 =?utf-8?B?UDZjL05TRU83ZXRTYU1DeXhGZ3NuTXpSSkkwUWhaelV1OUtqaENBbTFCSzUr?=
 =?utf-8?B?d0x6SmorcXNPMWVlK3VuMWxOV2pIK09yNWlqdFhwN3FXd1R2dEl2aUlrblo0?=
 =?utf-8?B?N1M5ZmZBdW0zSEh0RGNVdFN6YUh0VkNjdVlEdkZESUY4akRTY2RBSGVLMFp1?=
 =?utf-8?B?NkZGL1pnK1V3UGpHb1RicE5ZMy93bURMNlhLRm4rajRIb0VPb0xZN1VvRHBL?=
 =?utf-8?B?QW4vQWVwZnErM3lobldHblJZTnYyZ3g4RDgybVEvT1lNejcwNXRXMDMvWWhp?=
 =?utf-8?B?OVNRbnZrV1c5ZEdFVGIzS3FZbjZjZGF6K3FLYzdEWk45U3NlcFFXVjhDdCtN?=
 =?utf-8?B?amZwWEJJU3B4V2hWOWc2TW1yRUNadU10NEtkNmhTLzlKQTA5SzRZa1Fmc2RB?=
 =?utf-8?B?YmllbThRQ2tsdmhRT2JXcmV5aU1MckdOSXFIN3hUR0h4alE2bzJYaSszU0l6?=
 =?utf-8?B?UHZaZmcrcm9ONjZnZGhMSmE1cHRTRSszTXBWTUx1aTI0ZlFqU0dPVHBzL1hi?=
 =?utf-8?B?V1pGREVBck1aTmYxbDhLbVZOLzZldTYrc1hNZ0x0QlJ3VFRtekFWN2hLbXJC?=
 =?utf-8?B?WEtpWGNOT2wzczUzTmFlYjRNYlhwekZGdW9vUGp4QThmd2lJVm5acHpNeU1x?=
 =?utf-8?B?MkxzZlhiZ1p6ZDZHeHkvMEVqYW1KTjA0NnFNUTZyZHdybmtTamozTE5aUDZ3?=
 =?utf-8?B?NmtVR29wN0psL3JvRXNVK2c3NHBIM3dvS3pHb2l4RUcrNDVFOUNYWEwxN1pD?=
 =?utf-8?B?bjZ2dU5MMm5vQ0ZZTGVXczBzdG1uNWFOTTg5WHFtVndaQ3VmTWF0NVVtZjRH?=
 =?utf-8?B?em9wMFNzVjZ5TG02VzRjSk5mb1ZuRHNvZDBvaEwrWTZVZXN1b2tDKzB6Rmxt?=
 =?utf-8?B?MDBGaHg3bHM1SndRUmh0L1BoRGtmSWZyNGgraWRXN1NqOVBJRjdaR3dLTUpv?=
 =?utf-8?B?blc1TmJNVVd6OFF3TVBMOXN6RjY2TTc1MWt0TTdLN2FZNlo1RWdSbVFCU3BS?=
 =?utf-8?B?dHp5THhRbERMTHlYU3FZSWJXQjFyaCtJRWl2QW9nZ2trcjF3NGQydHcxVGFJ?=
 =?utf-8?B?OUpSeWRSaVRRaWtvcGpkMTh0dzZ3MDVQUjM5cGZxd01rV3RqZ2k2MndlKys0?=
 =?utf-8?B?a3BESUpIdXY1QUkvVzh1WXFCZUlZWjJmdko4cWUvdGc5eGZnV2sxODl2UnQ0?=
 =?utf-8?B?NGFEbG14WlNyMFJEQVVJUGxkRVdEMzhrQ1ZDbjVvYlIyMUhTdFQxb0hUUE5x?=
 =?utf-8?B?a21EY1NUbEFLelY0MFNQYXRPK3FBSzJPOTBkQmVONHdwcGlmUVMxa2xyUzhx?=
 =?utf-8?B?V05OQ3dOTEwxM2k4Wk1wVTNVVG5kUUh6VnBNT3ZGOHNCTDZERjd2Sjh4T2pO?=
 =?utf-8?B?Q21lSUtFamVReHZoYVNmNnBvNTR3aG9hMm5RMXRsenI4Q1lPS1I4QUpQaU5U?=
 =?utf-8?B?VjJuZk5IeWhoNjlRMm5JMXNQVzBsbDBLSTM3TjFIRXJsRStvVVUrODV6cXk0?=
 =?utf-8?B?QW56Y0Rkam05UE5Ic3FhN1VUQncybDBiekRNajhkaUJUTkxVQ1RTTkIwOG11?=
 =?utf-8?B?bFlKTjRldy9JNnJsN2l6S0lMaDFFMUtwcHphOFlONE03MVplakl4SkY0ckJ5?=
 =?utf-8?B?Z2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B7E42D8BA08507419C76CA1926B690D8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74fa8d40-f044-4207-2897-08dc63e91045
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2024 22:59:43.0665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9dKTobQyS73YxSK47TI6SKa3axgPfJObhYrIjYo1WBRDfkNGh4w+uMKOpiRwd8AC9j4T42eAsMBe6JPPUQzZhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6610
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA0LTIzIGF0IDA4OjE1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEFwciAyMywgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFR1
ZSwgMjAyNC0wNC0yMyBhdCAxMzozNCArMTIwMCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gPiAN
Cj4gPiA+ID4gPiA+IEFuZCB0aGUgaW50ZW50IGlzbid0IHRvIGNhdGNoIGV2ZXJ5IHBvc3NpYmxl
IHByb2JsZW0uICBBcyB3aXRoIG1hbnkgc2FuaXR5IGNoZWNrcywNCj4gPiA+ID4gPiA+IHRoZSBp
bnRlbnQgaXMgdG8gZGV0ZWN0IHRoZSBtb3N0IGxpa2VseSBmYWlsdXJlIG1vZGUgdG8gbWFrZSB0
cmlhZ2luZyBhbmQgZGVidWdnaW5nDQo+ID4gPiA+ID4gPiBpc3N1ZXMgYSBiaXQgZWFzaWVyLg0K
PiA+ID4gPiA+IA0KPiA+ID4gPiA+IFRoZSBTRUFNQ0FMTCB3aWxsIGxpdGVyYWxseSByZXR1cm4g
YSB1bmlxdWUgZXJyb3IgY29kZSB0byBpbmRpY2F0ZSBDUFUNCj4gPiA+ID4gPiBpc24ndCBpbiBw
b3N0LVZNWE9OLCBvciB0ZHhfY3B1X2VuYWJsZSgpIGhhc24ndCBiZWVuIGRvbmUuICBJIHRoaW5r
IHRoZQ0KPiA+ID4gPiA+IGVycm9yIGNvZGUgaXMgYWxyZWFkeSBjbGVhciB0byBwaW5wb2ludCB0
aGUgcHJvYmxlbSAoZHVlIHRvIHRoZXNlIHByZS0NCj4gPiA+ID4gPiBTRUFNQ0FMTC1jb25kaXRp
b24gbm90IGJlaW5nIG1ldCkuDQo+ID4gPiA+IA0KPiA+ID4gPiBObywgU0VBTUNBTEwgI1VEcyBp
ZiB0aGUgQ1BVIGlzbid0IHBvc3QtVk1YT04uICBJLmUuIHRoZSBDUFUgZG9lc24ndCBtYWtlIGl0
IHRvDQo+ID4gPiA+IHRoZSBURFggTW9kdWxlIHRvIHByb3ZpZGUgYSB1bmlxdWUgZXJyb3IgY29k
ZSwgYWxsIEtWTSB3aWxsIHNlZSBpcyBhICNVRC4NCj4gPiA+IA0KPiA+ID4gI1VEIGlzIGhhbmRs
ZWQgYnkgdGhlIFNFQU1DQUxMIGFzc2VtYmx5IGNvZGUuICBQbGVhc2Ugc2VlIFREWF9NT0RVTEVf
Q0FMTA0KPiA+ID4gYXNzZW1ibHkgbWFjcm86DQo+IA0KPiBSaWdodCwgYnV0IHRoYXQgZG9lc24n
dCBzYXkgd2h5IHRoZSAjVUQgb2NjdXJyZWQuICBUaGUgbWFjcm8gZHJlc3NlcyBpdCB1cCBpbg0K
PiBURFhfU1dfRVJST1Igc28gdGhhdCBLVk0gb25seSBuZWVkcyBhIHNpbmdsZSBwYXJzZXIsIGJ1
dCBhdCB0aGUgZW5kIG9mIHRoZSBkYXkNCj4gS1ZNIGlzIHN0aWxsIG9ubHkgZ29pbmcgdG8gc2Vl
IHRoYXQgU0VBTUNBTEwgaGl0IGEgI1VELg0KDQpSaWdodC4gIEJ1dCBpcyB0aGVyZSBhbnkgcHJv
YmxlbSBoZXJlPyAgSSB0aG91Z2h0IHRoZSBwb2ludCB3YXMgd2UgY2FuDQpqdXN0IHVzZSB0aGUg
ZXJyb3IgY29kZSB0byB0ZWxsIHdoYXQgd2VudCB3cm9uZy4NCg0KPiANCj4gPiA+ID4gVGhlcmUg
aXMgbm8gcmVhc29uIHRvIHJlbHkgb24gdGhlIGNhbGxlciB0byB0YWtlIGNwdV9ob3RwbHVnX2xv
Y2ssIGFuZCBkZWZpbml0ZWx5DQo+ID4gPiA+IG5vIHJlYXNvbiB0byByZWx5IG9uIHRoZSBjYWxs
ZXIgdG8gaW52b2tlIHRkeF9jcHVfZW5hYmxlKCkgc2VwYXJhdGVseSBmcm9tIGludm9raW5nDQo+
ID4gPiA+IHRkeF9lbmFibGUoKS4gIEkgc3VzcGVjdCB0aGV5IGdvdCB0aGF0IHdheSBiZWNhdXNl
IG9mIEtWTSdzIHVubmVjZXNzYXJpbHkgY29tcGxleA0KPiA+ID4gPiBjb2RlLCBlLmcuIGlmIEtW
TSBpcyBhbHJlYWR5IGRvaW5nIG9uX2VhY2hfY3B1KCkgdG8gZG8gVk1YT04sIHRoZW4gaXQncyBl
YXN5IGVub3VnaA0KPiA+ID4gPiB0byBhbHNvIGRvIFRESF9TWVNfTFBfSU5JVCwgc28gd2h5IGRv
IHR3byBJUElzPw0KPiA+ID4gDQo+ID4gPiBUaGUgbWFpbiByZWFzb24gaXMgd2UgcmVsYXhlZCB0
aGUgVERILlNZUy5MUC5JTklUIHRvIGJlIGNhbGxlZCBfYWZ0ZXJfIFREWA0KPiA+ID4gbW9kdWxl
IGluaXRpYWxpemF0aW9uLiDCoA0KPiA+ID4gDQo+ID4gPiBQcmV2aW91c2x5LCB0aGUgVERILlNZ
Uy5MUC5JTklUIG11c3QgYmUgZG9uZSBvbiAqQUxMKiBDUFVzIHRoYXQgdGhlDQo+ID4gPiBwbGF0
Zm9ybSBoYXMgKGkuZS4sIGNwdV9wcmVzZW50X21hc2spIHJpZ2h0IGFmdGVyIFRESC5TWVMuSU5J
VCBhbmQgYmVmb3JlDQo+ID4gPiBhbnkgb3RoZXIgU0VBTUNBTExzLiAgVGhpcyBkaWRuJ3QgcXVp
dGUgd29yayB3aXRoIChrZXJuZWwgc29mdHdhcmUpIENQVQ0KPiA+ID4gaG90cGx1ZywgYW5kIGl0
IGhhZCBwcm9ibGVtIGRlYWxpbmcgd2l0aCB0aGluZ3MgbGlrZSBTTVQgZGlzYWJsZQ0KPiA+ID4g
bWl0aWdhdGlvbjoNCj4gPiA+IA0KPiA+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC81
MjlhMjJkMDVlMjFiOTIxOGRjM2YyOWMxN2FjNWExNzYzMzRjYWMxLmNhbWVsQGludGVsLmNvbS9U
LyNtZjQyZmEyZDY4ZDZiOThlZGNjMmFhZTExZGJhM2MyNDg3Y2FmM2I4Zg0KPiA+ID4gDQo+ID4g
PiBTbyB0aGUgeDg2IG1haW50YWluZXJzIHJlcXVlc3RlZCB0byBjaGFuZ2UgdGhpcy4gIFRoZSBv
cmlnaW5hbCBwcm9wb3NhbA0KPiA+ID4gd2FzIHRvIGVsaW1pbmF0ZSB0aGUgZW50aXJlIFRESC5T
WVMuSU5JVCBhbmQgVERILlNZUy5MUC5JTklUOg0KPiA+ID4gDQo+ID4gPiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9sa21sLzUyOWEyMmQwNWUyMWI5MjE4ZGMzZjI5YzE3YWM1YTE3NjMzNGNhYzEu
Y2FtZWxAaW50ZWwuY29tL1QvI203OGMwYzQ4MDc4ZjIzMWU5MmVhMWI4N2E2OWJhYzM4NTY0ZDQ2
NDY5DQo+ID4gPiANCj4gPiA+IEJ1dCBzb21laG93IGl0IHdhc24ndCBmZWFzaWJsZSwgYW5kIHRo
ZSByZXN1bHQgd2FzIHdlIHJlbGF4ZWQgdG8gYWxsb3cNCj4gPiA+IFRESC5TWVMuTFAuSU5JVCB0
byBiZSBjYWxsZWQgYWZ0ZXIgbW9kdWxlIGluaXRpYWxpemF0aW9uLg0KPiA+ID4gDQo+ID4gPiBT
byB3ZSBuZWVkIGEgc2VwYXJhdGUgdGR4X2NwdV9lbmFibGUoKSBmb3IgdGhhdC4NCj4gDQo+IE5v
LCB5b3UgZG9uJ3QsIGF0IGxlYXN0IG5vdCBnaXZlbiB0aGUgVERYIHBhdGNoZXMgSSdtIGxvb2tp
bmcgYXQuICBBbGxvd2luZw0KPiBUREguU1lTLkxQLklOSVQgYWZ0ZXIgbW9kdWxlIGluaXRpYWxp
emF0aW9uIG1ha2VzIHNlbnNlIGJlY2F1c2Ugb3RoZXJ3aXNlIHRoZQ0KPiBrZXJuZWwgd291bGQg
bmVlZCB0byBvbmxpbmUgYWxsIHBvc3NpYmxlIENQVXMgYmVmb3JlIGluaXRpYWxpemluZyBURFgu
ICBCdXQgdGhhdA0KPiBkb2Vzbid0IG1lYW4gdGhhdCB0aGUga2VybmVsIG5lZWRzIHRvLCBvciBz
aG91bGQsIHB1bnQgVERILlNZUy5MUC5JTklUIHRvIEtWTS4NCj4gDQo+IEFGQUlDVCwgS1ZNIGlz
IE5PVCBkb2luZyBUREguU1lTLkxQLklOSVQgd2hlbiBhIENQVSBpcyBvbmxpbmVkLCBvbmx5IHdo
ZW4gS1ZNDQo+IGlzIGxvYWRlZCwgd2hpY2ggbWVhbnMgdGhhdCB0ZHhfZW5hYmxlKCkgY2FuIHBy
b2Nlc3MgYWxsIG9ubGluZSBDUFVzIGp1c3QgYXMNCj4gZWFzaWx5IGFzIEtWTS4NCg0KSG1tLi4g
SSBhc3N1bWVkIGt2bV9vbmxpbmVfY3B1KCkgd2lsbCBkbyBWTVhPTiArIHRkeF9jcHVfZW5hYmxl
KCkuDQoNCj4gDQo+IFByZXN1bWFibHkgdGhhdCBhcHByb2FjaCByZWxpZXMgb24gc29tZXRoaW5n
IGJsb2NraW5nIG9ubGluaW5nIENQVXMgd2hlbiBURFggaXMNCj4gYWN0aXZlLiAgQW5kIGlmIHRo
YXQncyBub3QgdGhlIGNhc2UsIHRoZSBwcm9wb3NlZCBwYXRjaGVzIGFyZSBidWdneS4NCg0KVGhl
IGN1cnJlbnQgcGF0Y2ggKFtQQVRDSCAwMjMvMTMwXSBLVk06IFREWDogSW5pdGlhbGl6ZSB0aGUg
VERYIG1vZHVsZQ0Kd2hlbiBsb2FkaW5nIHRoZSBLVk0gaW50ZWwga2VybmVsIG1vZHVsZSkgaW5k
ZWVkIGlzIGJ1Z2d5LCBidXQgSSBkb24ndA0KcXVpdGUgZm9sbG93IHdoeSB3ZSBuZWVkIHRvIGJs
b2NrIG9ubGluaW5nIENQVSAgd2hlbiBURFggaXMgYWN0aXZlPw0KDQpUaGVyZSdzIG5vIGhhcmQg
dGhpbmdzIHRoYXQgcHJldmVudCB1cyB0byBkbyBzby4gIEtWTSBqdXN0IG5lZWQgdG8gZG8NClZN
WE9OICsgdGR4X2NwdV9lbmFibGUoKSBpbnNpZGUga3ZtX29ubGluZV9jcHUoKS4NCg0KPiANCj4g
PiBCdHcsIHRoZSBpZGVhbCAob3IgcHJvYmFibHkgdGhlIGZpbmFsKSBwbGFuIGlzIHRvIGhhbmRs
ZSB0ZHhfY3B1X2VuYWJsZSgpDQo+ID4gaW4gVERYJ3Mgb3duIENQVSBob3RwbHVnIGNhbGxiYWNr
IGluIHRoZSBjb3JlLWtlcm5lbCBhbmQgaGlkZSBpdCBmcm9tIGFsbA0KPiA+IG90aGVyIGluLWtl
cm5lbCBURFggdXNlcnMuIMKgDQo+ID4gDQo+ID4gU3BlY2lmaWNhbGx5Og0KPiA+IA0KPiA+IDEp
IHRoYXQgY2FsbGJhY2ssIGUuZy4sIHRkeF9vbmxpbmVfY3B1KCkgd2lsbCBiZSBwbGFjZWQgX2Jl
Zm9yZV8gYW55IGluLQ0KPiA+IGtlcm5lbCBURFggdXNlcnMgbGlrZSBLVk0ncyBjYWxsYmFjay4N
Cj4gPiAyKSBJbiB0ZHhfb25saW5lX2NwdSgpLCB3ZSBkbyBWTVhPTiArIHRkeF9jcHVfZW5hYmxl
KCkgKyBWTVhPRkYsIGFuZA0KPiA+IHJldHVybiBlcnJvciBpbiBjYXNlIG9mIGFueSBlcnJvciB0
byBwcmV2ZW50IHRoYXQgY3B1IGZyb20gZ29pbmcgb25saW5lLg0KPiA+IA0KPiA+IFRoYXQgbWFr
ZXMgc3VyZSB0aGF0LCBpZiBURFggaXMgc3VwcG9ydGVkIGJ5IHRoZSBwbGF0Zm9ybSwgd2UgYmFz
aWNhbGx5DQo+ID4gZ3VhcmFudGVlcyBhbGwgb25saW5lIENQVXMgYXJlIHJlYWR5IHRvIGlzc3Vl
IFNFQU1DQUxMIChvZiBjb3Vyc2UsIHRoZSBpbi0NCj4gPiBrZXJuZWwgVERYIHVzZXIgc3RpbGwg
bmVlZHMgdG8gZG8gVk1YT04gZm9yIGl0LCBidXQgdGhhdCdzIFREWCB1c2VyJ3MNCj4gPiByZXNw
b25zaWJpbGl0eSkuDQo+ID4gDQo+ID4gQnV0IHRoYXQgb2J2aW91c2x5IG5lZWRzIHRvIG1vdmUg
Vk1YT04gdG8gdGhlIGNvcmUta2VybmVsLg0KPiANCj4gSXQgZG9lc24ndCBzdHJpY3RseSBoYXZl
IHRvIGJlIGNvcmUga2VybmVsIHBlciBzZSwganVzdCBpbiBjb2RlIHRoYXQgc2l0cyBiZWxvdw0K
PiBLVk0sIGUuZy4gaW4gYSBzZXBlcmF0ZSBtb2R1bGUgY2FsbGVkIFZBQ1sqXSA7LSkNCj4gDQo+
IFsqXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvWlc2RlJCbk93WVYtVUNrWUBnb29nbGUu
Y29tDQoNCkNvdWxkIHlvdSBlbGFib3JhdGUgd2h5IHZhYy5rbyBpcyBuZWNlc3Nhcnk/DQoNCkJl
aW5nIGEgbW9kdWxlIG5hdHVhbGx5IHdlIHdpbGwgbmVlZCB0byBoYW5kbGUgbW9kdWxlIGluaXQg
YW5kIGV4aXQuICBCdXQNClREWCBjYW5ub3QgYmUgZGlzYWJsZWQgYW5kIHJlLWVuYWJsZWQgYWZ0
ZXIgaW5pdGlhbGl6YXRpb24sIHNvIGluIGdlbmVyYWwNCnRoZSB2YWMua28gZG9lc24ndCBxdWl0
ZSBmaXQgZm9yIFREWC4NCg0KQW5kIEkgYW0gbm90IHN1cmUgd2hhdCdzIHRoZSBmdW5kYW1lbnRh
bCBkaWZmZXJlbmNlIGJldHdlZW4gbWFuYWdpbmcgVERYDQptb2R1bGUgaW4gYSBtb2R1bGUgdnMg
aW4gdGhlIGNvcmUta2VybmVsIGZyb20gS1ZNJ3MgcGVyc3BlY3RpdmUuDQoNCj4gDQo+ID4gQ3Vy
cmVudGx5LCBleHBvcnQgdGR4X2NwdV9lbmFibGUoKSBhcyBhIHNlcGFyYXRlIEFQSSBhbmQgcmVx
dWlyZSBLVk0gdG8NCj4gPiBjYWxsIGl0IGV4cGxpY2l0bHkgaXMgYSB0ZW1wb3Jhcnkgc29sdXRp
b24uDQo+ID4gDQo+ID4gVGhhdCBiZWluZyBzYWlkLCB3ZSBjb3VsZCBkbyB0ZHhfY3B1X2VuYWJs
ZSgpIGluc2lkZSB0ZHhfZW5hYmxlKCksIGJ1dCBJDQo+ID4gZG9uJ3Qgc2VlIGl0J3MgYSBiZXR0
ZXIgaWRlYS4NCj4gDQo+IEl0IHNpbXBsaWZpZXMgdGhlIEFQSSBzdXJmYWNlIGZvciBlbmFibGlu
ZyBURFggYW5kIGVsaW1pbmF0ZXMgYW4gZXhwb3J0Lg0KDQpJIHdhcyBzdXJwcmlzZWQgdG8gc2Vl
IHdlIHdhbnQgdG8gcHJldmVudCBvbmxpbmluZyBDUFUgd2hlbiBURFggaXMgYWN0aXZlLg0KDQo=

