Return-Path: <kvm+bounces-58171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BF72B8AC2D
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:29:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55D1B7B5C02
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 17:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23BFC32255A;
	Fri, 19 Sep 2025 17:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eLMkBMiR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE69B31FEFC;
	Fri, 19 Sep 2025 17:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758302973; cv=fail; b=rJibLJv0eeR1eZyNNak2VXL1FZJPV34ziTYrflrK3VkM3RBSAeCH4HqAR8RIawolMgcS6Wzue46PjW5N2WjaVUN2cD0VCkFiZC+rRhJRuoMRUsp5jUZoEgmclEH03ZRs2HK3FekyCmrwMpdmyacOcGjxE71fdCF4LJO/wC8cApk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758302973; c=relaxed/simple;
	bh=VIhqAH+VUGTIVTPHEuIpLZHgz1keHldPIPhor9Mw4+c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bQvxBy++S9AApt5mvCic456cFPrvsistBH0Eoxz/Eaw/44I39YcycIByWg3pCPJAJncsqdkdy39CIEGstWlFk725Iph5yZ9fU0SbP5O5+hTLVdHtBorYHoD6HpY8cVWtWvltDdOGge2FPekUT/f90Iupr7YZrH7M21BGOLOh74I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eLMkBMiR; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758302971; x=1789838971;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VIhqAH+VUGTIVTPHEuIpLZHgz1keHldPIPhor9Mw4+c=;
  b=eLMkBMiROlG2UphOeyf1hf0dO546vrPdFwcIGwzuNhvVqT8Ve/m1XspX
   h3kHcXA+mOfYBs6tea6Gkf1dYwfMmtSdlYnIsS3C1oV4zMCkKnkUqs89O
   A7PYXPFZhmHbuiiI+45VhNsKPxf25ZUqsztDTWlYLjdgyFERXnt0cbtCk
   wUFr9AzTJ/fu4Icc7iDKO5k7tiuOUY+NRYGRYma4BWvmJha02lYFSuzqM
   x0/O+oAJ2KYFPR++q1IuQG5IE5gq0xdWc9rLHvNtyyD2RqBCcLjpY3ie6
   0QnQH4HH6CEFoMSUijLNm9gZQ7UeLG8NE1fJhw9LEDgvWzAllf9MqhD50
   g==;
X-CSE-ConnectionGUID: 3JzX4+w+T9WfIpAMAUJ0JQ==
X-CSE-MsgGUID: D3hPzBOES/S7NXTILQNLhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="48230918"
X-IronPort-AV: E=Sophos;i="6.18,278,1751266800"; 
   d="scan'208";a="48230918"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:29:30 -0700
X-CSE-ConnectionGUID: JHv+6ZadTdKl5eN/P9fN9g==
X-CSE-MsgGUID: eybe0ztMTUmHdU01rlbxaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,278,1751266800"; 
   d="scan'208";a="176323623"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:29:30 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 10:29:29 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 19 Sep 2025 10:29:29 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.58)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 10:29:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lKDiipvhOzF8cLjDyY5KFf3y2MWV3YTHWIv+mkHHjo4uz3iCBpC1UdmtjDzBZPrZ40eiicyR5XWCAyNZCCEvOrPkox4amTE48ulXTbBE5BTVuq08fXE/7Z8dQJOaKfDRm3PujveI084CYHTGTBYH7RH97v8iJ/s73US28CGD/2PrpGs9nNflOrW4ewuCiZgVhZgCe+EdY53g0iweEkRACstYNmDrZuskE+GXN8lOoVj6z/DtxAxq6PuQGXE3ijF76ly53+urHNU7xqJAykJoUUP0RblwQtyi6XYfk+LshyjIMw4QCRrntPJ+NW5DYk+e9N2bF+rNXe2iM2TnisSfig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIhqAH+VUGTIVTPHEuIpLZHgz1keHldPIPhor9Mw4+c=;
 b=Pl+KLWLWMufenQIKXF9/2TT6EW8HnIuBStQ43Y2bLb0W26ywYVkbkmSmbYbYQD0W3g7G60oApXy/jJYd4I6wIBR+LfG2e/TyNOBwmdz7VA3ahXwgXFdu6hP4X78WjqfHeulVCW+iQb1ZWR2uLg6tApZfwokfArIFTSaaaJphg5khZRncI016gW0bNmG4+fkHn8IPpj8njkKlGgx2tuofnsHAqnWlIQOsP0Jqtf3xNG3drCgohwLCpt8n06KOaeXECn/j+6mNdVcV4G5q9Kpgo4g4FpehAjLOJ7qVJjQpbNB3/uYHD+BbPeDwgU/OYR9RROQ+pyGl+wG7XsQin5IaSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM6PR11MB4547.namprd11.prod.outlook.com (2603:10b6:5:2a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Fri, 19 Sep
 2025 17:29:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 17:29:27 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "john.allen@amd.com"
	<john.allen@amd.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "minipli@grsecurity.net"
	<minipli@grsecurity.net>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
Thread-Topic: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
Thread-Index: AQHcJDxrz3xGOm0mWkiTyxf0AvaeS7SWLnQAgAAQWgCAAArpgIAAEmYAgAAVbYCAAvB+gIAADMgAgAACsoCAAAr2gIAABUiAgAAKAACAAQGjgIAAQAgA
Date: Fri, 19 Sep 2025 17:29:27 +0000
Message-ID: <bb3256d7c5ee2e84e26d71570db25b05ada8a59f.camel@intel.com>
References: <aMmynhOnU/VkcXwI@AUSJOHALLEN.amd.com>
	 <aMnAVtWhxQipw9Er@google.com> <aMnJYWKf63Ay+pIA@AUSJOHALLEN.amd.com>
	 <aMnY7NqhhnMYqu7m@google.com> <aMnq5ceM3l340UPH@AUSJOHALLEN.amd.com>
	 <aMxiIRrDzIqNj2Do@AUSJOHALLEN.amd.com> <aMxs2taghfiOQkTU@google.com>
	 <aMxvHbhsRn40x-4g@google.com> <aMx4TwOLS62ccHTQ@AUSJOHALLEN.amd.com>
	 <c64a667d9bcb35a7ffee07391b04334f16892305.camel@intel.com>
	 <aMyFIDwbHV3UQUrx@AUSJOHALLEN.amd.com>
	 <2661794f-748d-422a-b381-6577ee2729ee@amd.com>
In-Reply-To: <2661794f-748d-422a-b381-6577ee2729ee@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM6PR11MB4547:EE_
x-ms-office365-filtering-correlation-id: 7584a384-a2fb-4b3d-3859-08ddf7a21584
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SFdMNVg0M05wMnRNVis0WHM3Slh0WGFZb2RvWHRMWmx1aXl3Q0I0VE02M01x?=
 =?utf-8?B?MUt4UnY4Z0NUbGkxY2dGL2MrK3BBa0t1Y0M4SzVPU2o2aGdrN29SN1FmVHk2?=
 =?utf-8?B?SzdlRjNHbHp2ZGh1M3BSK2xPWkxRWTU2dTA3emlyYjIveGNlM21aNFcyaFhu?=
 =?utf-8?B?YlAwY0FtdmZjZ3BnNlVFc2pNV0J0WEV1TS9jQ1E4c2dMaFlURklYU0x1Zkwy?=
 =?utf-8?B?aXlyV3lPMW4wZUlwbUR0akE2QjVTTCs5VXBhK1VNUm9JYXJUKzlyUG1YQjVw?=
 =?utf-8?B?emF0T2ZaaDNtWmkvNzlrbWRaS1hvbG0yRlRSVDhlQ2hJSHNXczU0dDdTUmtm?=
 =?utf-8?B?bW9PeFFwUzlyYkhWbjZxZnJ2Z2NXcmtZYnRJTDBKTXUyUkpVNXFxL2JseXR6?=
 =?utf-8?B?d0JsUHRwQkpSSGo5QjBwcmxkSTRwTDVCMEx1ZnBQNkFDQjhlT0ZBTW5EaXh4?=
 =?utf-8?B?dVJiL1VuMForbEpmVlF1VHRkbU9LYVpTQVZ6NXloUFdYSFBSVjl2TDk3eEYr?=
 =?utf-8?B?SE90UUdjRi9waHFxQXp4dURNRWtZci9sK0pMRWpzK2dZUW4wL2xsaW4zNnhx?=
 =?utf-8?B?cEE0K1RQaW0wU3NreDVieG1aUTk5Z1dmcFZ0TGNoWVdncy8raFFpMHJ3alZm?=
 =?utf-8?B?NGJDZnJQYklhbU9ZQ2hkRks5cDhnOGh4NlpaclM5cTVIano0YW1nZitFU29a?=
 =?utf-8?B?TTJiYS9sNEsrOXluNXJTcHkzVXlRNmNPZm1VZlBKMHdEL3c1VERNbmFhb0JU?=
 =?utf-8?B?YlZaUzN6TnkzNUIxdTNSVldCcDNFVFg5ZGZmKzRtV1lXSXM4VTkzZlZoY0Vr?=
 =?utf-8?B?cW5UTkorbjhDRTZFY3J0WldvOTd0YUV5QVlrcUhkMWZNOVREZ2tOcHF2SllS?=
 =?utf-8?B?cWhKMWMyVEY4SmNVVU5Sd1dIWkdXZjNINm9SVEJKbjhDWnpwSnJsS2RwS0Ro?=
 =?utf-8?B?ZTJLSDZFanpRbFdkeDh1cVlpUDRLbUI5M0VlQ1ljTnQvaUZoQjNWNldEMFRJ?=
 =?utf-8?B?TWpTUUViYzhkVmRsaVZRa2k4alIvd2JidVRtUU5EbThzQ2xBdTFSWXJmSjVF?=
 =?utf-8?B?OGxQNCs4OFg1bkpRdGgxczBCZWJlMDFwZ0RLUWpjUDF6dDlnbmZpUHZpQWo3?=
 =?utf-8?B?L28wQWhLSWJwOWpZdXVFYXYxVm9DU05zWEU4OFA5bFNlTm5oYUk5Yis4aEpm?=
 =?utf-8?B?NEE5QVlwYnNydS9HTXVPZ0Y5a3hlZ2JpYTFHQWpPa2hOWVpEYzBuY0luZjF6?=
 =?utf-8?B?eWZqWGZZZHNQLzhDM2ZMaHZ4aDVvbHFCdUNYSEI2VURWSThrN0M1aWMvazVn?=
 =?utf-8?B?Q2pZZ2RmNVpiaWdNQjFFRlZBd3N4VFlMaVdTQk5oejNwdXpjTVN4Q25UZG84?=
 =?utf-8?B?TC80KzU0QTFoT2I1VEFrMkNteS91Rk9KYlA5aFBleDd3QVBEVGhHUEkwbTRn?=
 =?utf-8?B?UE1Hc1duaUNtcnNNRWZDUXczb0NheFB2cHVReFdSTGw5dDF4VEFETyttMDZU?=
 =?utf-8?B?YkkzUGlSUU5HNTEybklYcDdRdFNwT21tbTZlN043a2VqQUhYTkNmd0VTSnJk?=
 =?utf-8?B?RjdpMklRZUs2cnArYTJ2aWs4elk0K0E3amxWVzdmL2lXcHAyNkJrT0VBdGRN?=
 =?utf-8?B?V1RPd3hoSk1pbDl4VjdHQ1RtNXNEV0hzTjlHTHo0emNyeDgzOXJwaUJxZlE2?=
 =?utf-8?B?c1lMZmJ0aXpaV0FxNU84MWF6QUVvdCtQOS9NdTU1bEpMLzZrWlNKdFFIMDIv?=
 =?utf-8?B?cjBtUzVYeGdNSEEyWkh0dDRaTHBRY0VhZ1lyTGZkNzVHaFo2WktJRkVONDVq?=
 =?utf-8?B?S2pPMjF3eS9aRDBMS2ZPWG9nNk9MdjYzVjNIdmRzSjRkbUR5dm1JU3lqZnFX?=
 =?utf-8?B?YTF3WG0vbXBqUmdwZ3FTbXJGVnFFejNvaUtpTmpxVXdYdkVscUg2RHdHMmZR?=
 =?utf-8?B?Q2ttUmF3aUxEdEFObjYwa2E2ekF0QUY2OE1TWHB0Sm1IeDNBYkQ4cGp1MTN1?=
 =?utf-8?B?eFY4Rk5NZU1nPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDVzOXc2ODhvRXlMTzV2cmJtcWRHWWJDN3JFSkczSjRKOFBLK25YVnlHZGFo?=
 =?utf-8?B?VGVha0pTZEFXbUozZHpUUEZBZlQvWkhBc0Y2aGZiL2s3bitDNkU4ZlQySjBW?=
 =?utf-8?B?RTl1ZWxuZG96MitxUE5xZk55cm1qWTBmY0hKQzRpSUdkOUdwUngvdUdtVTRM?=
 =?utf-8?B?SldoYkRLQ1Z2TEpLclM0MnNVbmRkWlhtS1R3SnVsRUNOTUtXZ3FRTWJtS05Y?=
 =?utf-8?B?dmNWQStoVnZvYUp3bWJtendtM3BjY3NId2xwMk9aVDlGZitpamdwVjd3cEk4?=
 =?utf-8?B?dzNOWTRIbnRUeVJKMThCcHhSV21ncnRRSXNPWVFKaGIzeDFHWUVKSmZ1bWJR?=
 =?utf-8?B?eDkzNzdzakRaUE96OXpGUzZORHFhTkd6ajQrTkhWbHRDTUJrYWxxSTlkSzhp?=
 =?utf-8?B?QWZoN2tvRGNKYzFRaTdxNVpNei9kZkxEY0QwMlpoOWZRamVPUFpJZjREUVFE?=
 =?utf-8?B?RmNHcTFoOW5ndy9HMzdDWEVGN09MK2lnTEUzMkI0VTNWZkRoNkZkdUI4R3Q3?=
 =?utf-8?B?YWZWRE91MXpOU2kybkhwK3BLZDVteTFVbGF5akovM3FJOHZmQi9leHZLY3l5?=
 =?utf-8?B?U3JzV3pLSmlHOXE5S2lNQmE4S0JOOVg5VEwwR2Z2QzcyOHdTU215RXJrY3dE?=
 =?utf-8?B?N09yRmVRODFGOS9meDZIV21uSUU0aENOZEtlZmUybzBYQmZMVm5qT3ZtTWs2?=
 =?utf-8?B?S1F6TWViUnlVU2UxNlU1azltK0lxUWR4eCs2a1BudllDVnpKekx4ZmpmdGd1?=
 =?utf-8?B?WXdzU1hjdzhudG9QRkVFQ0I3OUNqV3M2TkxScEFMV0FSOWF0dEdhc1JyZCto?=
 =?utf-8?B?azBJWFFVSEtqSnZ3M2lrdGRPTTRuWGxLS0xLeUVVei84MlRjNUd3WlVzU2xv?=
 =?utf-8?B?Z3JlbzlrdG5qWUE2M1I2NmJ6cXBBdkVjV1NzWVp4RFA1ZmpuSlhuRjFZTWFr?=
 =?utf-8?B?Rno0bVhzeDZOakVSSFA1NUJESDlrTktQSFl4VmVtQ05VRXBzaWhqQVJJbE1F?=
 =?utf-8?B?cVVNMXRoNkJ3bTBNQ1d4UksrKzZZaVhGeXJLR3NZa3Q2TU5KeTBJQmo5Mlgy?=
 =?utf-8?B?dHl4dTZlY1h3UU8wVXZiU0lTRmYrZjZFM2NscDBJVW95NXg3VEJmdEdlcjdZ?=
 =?utf-8?B?RVBYd2c0Y0JqWG92eGI2YUZkSmoxLy9rUi9rNXF4T0VQd3NpWVE2MFpMaE9i?=
 =?utf-8?B?ZmZ2RXNOaXhiWHphMXk5OHcrQkxOcDdyZUxxK3JLaUQrM05GL0VwbU9rdzVZ?=
 =?utf-8?B?bVQySXNPWHBhZUp0Y0hTMjQxeXJ4MjRZODVjZExIRmF6NGI4TkZxL3lNTUVz?=
 =?utf-8?B?Z1VUMUFleVlnM0xRMk44RFpBZ0wvUXoxdWVyNlVsV25PTG0xSTFQalFiYmlo?=
 =?utf-8?B?L2k4cUdaTVptSVRPUHlRZHI3N09NVjNhWTRveTBFUXNSRitkNWxBb1czSjlv?=
 =?utf-8?B?R0xRelRoRUVUS05sMEV1TlBaZHdpY0c0cEtuMzMrSXVQSE45L3FWSG9jeENv?=
 =?utf-8?B?VmZEMWtwOXlxSENBZ1RaWUNUZGJrZjBFNmw4amhtN2pENzl3cHRYam9oSVpm?=
 =?utf-8?B?anZhTWp3c0pSa0g4RFRFRTRlSnRyZVZVZXJNc3VaRi91SjBqSVJmcVVXaSs2?=
 =?utf-8?B?Rng4TFQ5M0hPOXB0c2xkbnlMU0o5cElWUURsb1VoZjZ6U2tpbC92RUlOQ3pr?=
 =?utf-8?B?dkJnc2drZ3ZhTlh2RURTVHNwUVAwU1FrQ3BDV1BuK0sweVhGWGc1Q2FrUE96?=
 =?utf-8?B?K21aM2pidDluV0VMMmFBNkd3MlJBNzVOOEc0RlZzUjFlNzhuc1JzUWZacUh4?=
 =?utf-8?B?aEFuUDV3c2ZWelBaNVViS1ZNOFFKZUF1QW00b09Qb1l2eGFQR2NrVTBXczlU?=
 =?utf-8?B?OTJzem80U0tPK0FrUFdrZXNIUlF5bHRYUnVLRDZYQnNFbE0wcXhnaTlSb1hU?=
 =?utf-8?B?RE80UXAwdlhHN2dWUEI3TlFac2JRTklUeTNkMW5rOXU4WkhJS2lsQVFBdXNi?=
 =?utf-8?B?SFVmZlI3VzBjbmpGUmJGWWwwb281czgyTXdwK1FMSmtncEREa01HcSt1Tm9F?=
 =?utf-8?B?WENwRVA2VVZ3azJJNHdBSUk1RHg1eVFFQ3ladGEzbUVFNWwrbnZnclE0Z3hr?=
 =?utf-8?B?YTdDR1JMcGx2VXQzUXlpU1Z6N0RXSkZoWUdwUlJVdUhPUXF6emkwNlJCb3Vh?=
 =?utf-8?B?dXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B0B843E5E53DB4B9C92936F378ED0BC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7584a384-a2fb-4b3d-3859-08ddf7a21584
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 17:29:27.3607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /OVXcs74rb9i0nlmC86Q62Dg+ft31OPohTja1mex1kl6rkcMivzkGpu06L/gzgV5QHAJJQI61/Fg9PFUR/bEd6Bj/2FShYwIDTJv3H5h2Xo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4547
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTE5IGF0IDA4OjQwIC0wNTAwLCBUb20gTGVuZGFja3kgd3JvdGU6DQo+
IExpa2VseSBzb21ldGhpbmcgdG8gZG8gd2l0aCB0aGUgZW5jcnlwdGlvbiBiaXQgc2luY2UsIGlm
IHNldCwgd2lsbA0KPiBnZW5lcmF0ZSBhbiBpbnZhbGlkIGFkZHJlc3MgaW4gMzItYml0LCByaWdo
dD8NCg0KQnV0IHRoZSBTU1AgaXMgYSB2aXJ0dWFsIGFkZHJlc3MgYW5kIGMtYml0IGlzIGEgcGh5
c2ljYWwgdGhpbmcuIA0KDQo+IA0KPiBGb3IgU0VWLUVTLCB3ZSB0cmFuc2l0aW9uIHRvIDY0LWJp
dCB2ZXJ5IHF1aWNrbHkgYmVjYXVzZSBvZiB0aGUgdXNlIG9mIHRoZQ0KPiBlbmNyeXB0aW9uIGJp
dCwgd2hpY2ggaXMgd2h5LCBmb3IgZXhhbXBsZSwgd2UgZG9uJ3Qgc3VwcG9ydCBTRVYtRVMgLw0K
PiBTRVYtU05QIGluIHRoZSBPdm1mSWEzMlg2NC5kc2MgcGFja2FnZS4NCg0KVGhpcyBzb3VuZHMg
bGlrZSBpdCdzIGFib3V0IHRoZSBsYWNrIG9mIGFiaWxpdHkgdG8gc2V0IHRoZSBjLWJpdCBpbiB0
aGUgcGFnZQ0KdGFibGUsIHJhdGhlciB0aGFuIGhhdmluZyB0aGUgQy1iaXQgc2V0IGluIGEgdmly
dHVhbCBhZGRyZXNzLiBJbiBjb21wYXRpYmlsaXR5DQptb2RlIHlvdSBhcmUgbm90IHVzaW5nIDMy
IGJpdCBwYWdlIHRhYmxlcywgc28gdGhlIEMtYml0IHNob3VsZCBiZSBhdmFpbGFibGUgbGlrZQ0K
bm9ybWFsIEkgdGhpbmsuIE5vdCBhbiBleHBlcnQgaW4gMzIgYml0L2NvbXBhdGliaWxpdHkgbW9k
ZSB0aG91Z2guDQoNCg0KDQpNb3JlIGJhY2tncm91bmQgb24gdGhpcyB0ZXN0L2JlaGF2aW9yOiBE
dXJpbmcgdGhlIHRhaWwgZW5kIG9mIHRoZSBzaGFkb3cgc3RhY2sNCmVuYWJsaW5nLCB0aGVyZSB3
YXMgYSBjb25jZXJuIHJhaXNlZCB0aGF0IHdlIGRpZG4ndCB1bi1zdXBwb3J0IDMyIGJpdCBzaGFk
b3cNCnN0YWNrIGNsZWFubHkgZW5vdWdoLiBXZSBibG9ja2VkIGl0IGZyb20gYmVpbmcgYWxsb3dl
ZCBpbiAzMiBiaXQgYXBwcywgYnV0DQpub3RoaW5nIHN0b3BwZWQgYW4gYXBwIGZyb20gZW5hYmxp
bmcgaXQgaW4gNjQgYml0IGFuIHRoZW4gc3dpdGNoaW5nIHRvIDMyIGJpdA0KbW9kZSB3aXRob3V0
IHRoZSBrZXJuZWwgZ2V0dGluZyBhIGNoYW5jZSB0byBibG9jayBpdC4gVGhlIHNpbXBsZXN0LCBn
ZXQtaXQtZG9uZQ0KdHlwZSBzb2x1dGlvbiB3YXMgdG8ganVzdCBub3QgYWxsb2NhdGUgc2hhZG93
IHN0YWNrcyBpbiB0aGUgc3BhY2Ugd2hlcmUgdGhleQ0KY291bGQgYmUgdXNhYmxlIGluIDMyIGJp
dCBtb2RlIGFuZCBsZXQgdGhlIEhXIGNhdGNoIGl0Lg0KDQpCdXQgdGhlIHdob2xlIHBvaW50IGlz
IGp1c3QgdG8gbm90IGFsbG93IDMyIGJpdCBtb2RlIENFVC4gU291bmRzIGxpa2UgU0VWLUVTDQpj
b3ZlcnMgdGhpcyBhbm90aGVyIHdheSAtIGRvbid0IHN1cHBvcnQgMzIgYml0IGF0IGFsbC4gSSB3
b25kZXIgaWYgd2Ugc2hvdWxkDQpqdXN0IHBhdGNoIHRoZSB0ZXN0IHRvIHNraXAgdGhlIDMyIGJp
dCB0ZXN0IG9uIGNvY28gVk1zPw0KDQpQUywgd2UgZG9uJ3Qgc3VwcG9ydCBDRVQgb24gVERYIGN1
cnJlbnRseSBldmVuIHRob3VnaCBpdCBkb2Vzbid0IHJlcXVpcmUNCmV2ZXJ5dGhpbmcgaW4gdGhp
cyBzZXJpZXMsIGJ1dCBJIGp1c3QgcmVtZW1iZXJlZCAoZm9yZWhlYWQgc2xhcCkgdGhhdCBvbiB0
aGUgd2F5DQp1cHN0cmVhbSB0aGUgZXh0cmEgQ0VULVREWCBleGNsdXNpb24gZ290IHB1bGxlZCBv
dXQuIEFmdGVyIHRoaXMgc2VyaWVzLCBpdCB3b3VsZA0KYmUgYWxsb3dlZCBpbiBURFggZ3Vlc3Rz
IGFzIHdlbGwuIFNvIHdlIG5lZWQgdG8gZG8gdGhlIHNhbWUgdGVzdGluZyBpbiBURFguIExldA0K
bWUgc2VlIGhvdyB0aGUgdGVzdCBnb2VzIGluIFREWCBhbmQgZ2V0IGJhY2sgdG8geW91Lg0K

