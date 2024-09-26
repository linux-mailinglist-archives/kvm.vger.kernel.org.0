Return-Path: <kvm+bounces-27559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6EA398735B
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 14:13:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95803286385
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 12:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ABF217557E;
	Thu, 26 Sep 2024 12:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y3ng8c/W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03CA171088;
	Thu, 26 Sep 2024 12:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727352820; cv=fail; b=WvN5+ASrcbb0cstO7AbDtiNcu0km1b8wH7N9JcrnONd8vwPM8tjKaN7rA9rXSNPwqFL2/lA52IpQ99mPk4JHFNZ7FvvVxHnT3bKHHulRhpZUqlU285En4kMgJcqMlAfL5DWRN+fL7s29BXeQ+0uMEmbI4x5f/Dlp/GJ+TzO2Ph0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727352820; c=relaxed/simple;
	bh=3U/DL4Pq4/51zs8JnaDOmoMx90wQRlAFTYWi49NOz1w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sxIZHBZXZlUwK6GeLba0y+ljRAu/2STbJC7Pd/PrRTa5JPq7nGhf0BB5b4xD+MzonIXys8FRqayKS9le8oMYr0298FLAxKpMdJn0CKvY1JFRXOmQeG+2qJn9uxRws6EVKKWJ1zYVYubL1S4W9QqMH0fXWqNMCeAhrjBrcgY49Wk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y3ng8c/W; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727352818; x=1758888818;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3U/DL4Pq4/51zs8JnaDOmoMx90wQRlAFTYWi49NOz1w=;
  b=Y3ng8c/Wo9jeG5SUct8zprMBR/EIzBUZY9GKwTT4GDsGMc4xU0GGWkSu
   jTzoe15oEwdsZidaOndFNrT9AzNY12hveGNe4L9n4DboIeEMM8Jytk1aL
   7EMqklQpT+Gg8vCxrnkGcuOuHZCmsr/nDtZcCc6p4vPj9s9BQZuHlvsfw
   YSCfR9Gztj9Gdfv+uVBMdN4qWU93rKTTtsSTOqekiCy0cwMmejMhDwF05
   pVe1cy3igRYn8YUNlwGVy9NLnJzYJxybH0OsDg4BgYDe2sERpWToeWzut
   qfjBZa6gtywWViGb4XEdcSayxAYa0rn31hJMfPkUIVv3ilV+nr6ORZa/x
   Q==;
X-CSE-ConnectionGUID: juk/g8GgTWOyTs4LWcNW/Q==
X-CSE-MsgGUID: 3A6FeHIPTjeg4DZkFajOAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11206"; a="37025162"
X-IronPort-AV: E=Sophos;i="6.11,155,1725346800"; 
   d="scan'208";a="37025162"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2024 05:13:38 -0700
X-CSE-ConnectionGUID: a/0MVN+VQ5i7DGDpUbBCbQ==
X-CSE-MsgGUID: ooGFwpRrRQ2FubC6Yn8/yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,155,1725346800"; 
   d="scan'208";a="76496225"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Sep 2024 05:13:38 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 26 Sep 2024 05:13:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 26 Sep 2024 05:13:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 26 Sep 2024 05:13:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z43X8WkMEHEJJRJb8/oBeHUUxo1dzUM7jnXDwGTzK5iu23somT/FkW78jRVU0X1U+D4ahv71z4siHNiYOch23rVQPo4o8BTDT1X/sYkgj1ALFF3cZEYf9jNuOknuGDr3MOAITMMHjOhUvpYX38rATZ7T/jNfJv1/lHwfC/Ij7t40uFP6DktnyzEbBdtWE17EmRq0Iye3qwyxTjWKAvyidiDUxMdsyNATjPY0FPe11VhiNEiUnpyR1emfhhyntzEQD81qcM5AgvsgJN/qF/X7JSs1A9kGG+//vSmkPLVHrQQzOpqqAHeAXQtiogdr3Sx67QOIS9pAjC9mhsFamyQ8XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3U/DL4Pq4/51zs8JnaDOmoMx90wQRlAFTYWi49NOz1w=;
 b=ZdMczRNswdWWu1FnM4yaRjAE4tP2B0p0k17bEXA7/+s6GOOmOB31LeyvJ74iDaxC9sS/LiOpNr6eA8QDWWXLAIEL1JNY7QNstoIBs3KydOeN3snl2noMgXb14br6R4QU6XvriMXT9sU7YJhkDnYM++biFfqw0aeJfSz0PJKVpi4aNRtkNX4ISxPdZS67N02+srHog1uqxLS7MSxFox8/lCiX+Q9Optuxg4/F3bYrzfkkck2DSAGXv1DvzN2cd38qv+w0b5QYC/tTt8AwTAv106YTfabC7puoFb1rsPxOXzYmL1odjh7Ltq6IWtUnQ4TMmnTjEAEHTyRz8CVR1r5Ugw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6709.namprd11.prod.outlook.com (2603:10b6:806:259::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.22; Thu, 26 Sep
 2024 12:13:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 12:13:33 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Topic: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Index: AQHbDnRp8EihSraYXkOZ/V8hjcAzkrJpnUYAgABg0gA=
Date: Thu, 26 Sep 2024 12:13:33 +0000
Message-ID: <1e9270cabe2217e4299ea52adf2a87874459490e.camel@intel.com>
References: <cover.1727173372.git.kai.huang@intel.com>
	 <101f6f252db860ad7a7433596006da0d210dd5cb.1727173372.git.kai.huang@intel.com>
	 <fce898e6-0296-4c5e-9e6a-6b5e3fc87b95@suse.com>
In-Reply-To: <fce898e6-0296-4c5e-9e6a-6b5e3fc87b95@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6709:EE_
x-ms-office365-filtering-correlation-id: 90abb19a-2f5f-4d1a-9580-08dcde24a464
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OW0rNDh0QWRGZWE5L25vd2NzcUlXN2QwK3NkNlFiazlGNXdmQll0Ym5ZV2Zm?=
 =?utf-8?B?a3NqbzIvd1pvMHhTV25KaFdGL3YrczVzR1NWdTNJVnZhdDdTLzhtcE1LUFFk?=
 =?utf-8?B?N0pyaE5uYWZjTE04VDVZTnpDbDF6WGh2RysvbTNuQU5pb0FFcUJmcE9vQU1p?=
 =?utf-8?B?Nk5LbC8vb1B5VllhYUxXRldlSUNzWHZYcFpRcFY4L0diVkNUQjBvQU5McUdj?=
 =?utf-8?B?dkt2NDI2TStQWHUzcXQ2YmpFUSt6QTVrYlZPcTNhVmFTRHc0U2UvTmlIREgx?=
 =?utf-8?B?Um1ObU1GcWxERThmMkpIRmpZZSsyUmptcnpMTHVrMEY1a2diaGRieTVMTFpw?=
 =?utf-8?B?dHBpK3NJNmZUVTBjL09jRW5DVHVLMGdHUHF2cWJRVm5ha2FxK2JIcmw1TS96?=
 =?utf-8?B?YWw5ek9MQlN1MjY2S0N6ZnF4TkRvbGJqNG5IbWN5WlEwcFNhME5ZTGx4OEdT?=
 =?utf-8?B?aTk5Y2F4T2k3emdkbnREQTN5ejZtcmFqZFVyNExHOXdZbFV1QzQwRlhsOG1S?=
 =?utf-8?B?MVl2QmpNWGI1Q0hTWnBYVUtJR2Q5enBpeEJ6OFRBWEZVSS96dXRYREZxYXM3?=
 =?utf-8?B?TXc5bEo1eW5HSXN0ckF0MXdpd0c1cm54S1ArNGp0a1JpeGFVSXVmQ0o1SlRQ?=
 =?utf-8?B?anRiM3BQNGI0VzNza21yaU4zOGF0R0hPbGQyYnFHNDRpU0llLzhYTlVHVHh6?=
 =?utf-8?B?ZnhEelp3b1dZbGkwM2pFTFFHS2hvVC8yK0dydHhScnJ0dWVxR1dvNjR0RWVS?=
 =?utf-8?B?UWFFeWhaZTUwa2t3TFhrWXduK2lOOVE1SnNUeWlBdkE5cHV4OVFPaldkVFRU?=
 =?utf-8?B?OEtBdDNoQWNyK1hjVTBZUTdoWU5Mc0lPVlRvOWJhSU5PWU0vOXRjZWRYQW1o?=
 =?utf-8?B?eEphN0pKd1ZUUVhpY0F0cEt5QVlvUVVEMFgwYW5OYkhFQ3h0a0dCc005VW9C?=
 =?utf-8?B?L2hScENuUVBWWnRVUnFQWE9lTmN6OGFPMmZITEQyejdDbjZyMEV1azBWZ3pT?=
 =?utf-8?B?VHl5L2RwcXlUb3oyTTE1TzNXY0UwMFlUZmV5MGJsSDdZeStYOTJ1REJJd1F1?=
 =?utf-8?B?ZzNvR2hXRU9JZ3JSeklEbVdHOEZNaitaTXBMQS9PdkdueEZnTmNGN2lGaUFN?=
 =?utf-8?B?MnRSa0d5OVl1L0JpTmlaL3Q2YlVpSU05UzUzRjU4RzBXdlIzbXFCOGFCamV0?=
 =?utf-8?B?ZGVQTG1ubUVDdTA2ZkRoempWUHpQdGVLSllaOGF2cHdsOGc0UXdhNlFLejc2?=
 =?utf-8?B?LzNLd3hVSVJvdlRxUm8vQ3Bwa2lTTDB1eUlJcU1rRHorUkkya0c2UVhLcnlC?=
 =?utf-8?B?cTc2aHJTRkcwNHMxUzZhNkhJdC84cjdKZW94S3JFM2dWTXF4bC9jWE80RnUy?=
 =?utf-8?B?V0R6by9HMzdnWHh2eVRLdXRxVTVidUZoV3QvVzFGOEJ2dGtYNlVQUDZYeHlk?=
 =?utf-8?B?SnFrak95bE5ITjl3bDRnU3RFWWJPZmxGMGpOTXFMR1k4WmhjOVgzWmhjeERh?=
 =?utf-8?B?TUJQU251bmc5SFZGWXYwV25XSnBPRkt3NkJPN2tKVzM2V0QvcXY3dzg1UU5V?=
 =?utf-8?B?dHdGNE14K2xpQmZER0pkOURiRkZHZVlWeHR0bE16Vm9KVlFMVTdacjVsb1NG?=
 =?utf-8?B?NHJleVEzTlB4ZU12djlML0lBY2YyVGFDVGpRVkdFR3FXd090d2w3MFRNOURY?=
 =?utf-8?B?cGNtaUFENW9OcllZR2NiUnI1a3dCV3lVN2RxcFJiMVVGblpyUFNQQkhybFN2?=
 =?utf-8?B?ZmpJMlFmcDg4Y2lEdHk4WCtHUEc2MkFqUk43Z3I3RS9WS29qYWVJbnh0aHNN?=
 =?utf-8?B?Vmk5c3BsTnFkVjhQU1Q0L29aTVZKaXRENG1KSWMyTW9YVDI4OEtXUGFMOU9J?=
 =?utf-8?B?eVgyOEJuandjME1CTFJRK2lLWFdMejZUcjAwT0VTTGk2SU9hVEFVM1QvdlVn?=
 =?utf-8?Q?L5G/PjYIMTw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXJwQm1qMFhZSzBnS3FKNk5LZ2lVT0wycm1HYWZQTE9rM3FzTlBUa2Q5bE1p?=
 =?utf-8?B?V2l5QWJuUitNekZUVnM5RG8vcHpsT0t1eHVzaFJzejZxVXdhUjQwa2k1UEVr?=
 =?utf-8?B?NWxGZ2FURk9jaDhEVHUxQzlwT1FHcHpVc1VNeUMxeld1U0lHSE4vZjVNWlZj?=
 =?utf-8?B?VXU3T1hvM3hTTWIybXFFOWhjZ1Z2Q3NKMng2dGovaXdCMFdodFFSSmwzZ2Za?=
 =?utf-8?B?eklhUGRwV3lIVkIxQ3R1bkVBUGhGV3IyaUtaZDI4OEoyOFRDT0wzdGt3WldS?=
 =?utf-8?B?NjdrMmxxbHdIMUNvbmZ1QzNRZGE3NDVvVWpBRlhVem1XWkJSODBtUGhQWXVN?=
 =?utf-8?B?K0NFRVFvM3NQR1pVZjdDOW1qOHhUZnRHU2FjcktmcWxPL3dMeU13Y1lPNlJJ?=
 =?utf-8?B?MXc5N0lxMjhTcFVRWlRnNk82WUs3dHZEMzV3bzhJMXdaM2RaUUJkcm81STU4?=
 =?utf-8?B?eGlBYWY0UmluY1JoWFRFeXloUjJmREEybHBKd0xCT2VpazZjRzFLSEpHVWtl?=
 =?utf-8?B?OUNKd0g5Nk9iQjlMMUtQUnJjZFA2WGxmU3YyU1lNYzFqU0FEU2E5RGl4NjBl?=
 =?utf-8?B?LzdaSTZ2dFA4N2NNbno3a1YzcjNveGJoOEszRmswRllPNUkxM05rbHYxM3Vh?=
 =?utf-8?B?dXRCZlp0NkYxd210elU1aEptVmpVMk1sNXZLZWN0YjFnV3Z6VFhpdmFBNFZI?=
 =?utf-8?B?c0ZzV1NMdmk0QTEzQ29iM1J2RkpqbjVkMVZPWndzRytQSS9QcEQ2Q0drUVl5?=
 =?utf-8?B?eC96YzdSdTZwUEtYTzlTd3h1YW00bk4rNTdIK3ZEYzZCVEUzMDBJWjd0bkcv?=
 =?utf-8?B?c0dpbWYyRDFGSWIvWVpDcGZNcDlIMnNycUhlTU9XQ1diekhJQUlRckRGYXNW?=
 =?utf-8?B?dHhwSWhxQVcyNDEwOEs0Z1kwZ1RQU2JreTVjdDZZV2pUdVVNNjZESTBoZGhp?=
 =?utf-8?B?WGxxb2kxZFRldy9JNys5VFd3TWhObklUYzVOQ3hZa0YxT3ZoVzZvbTdkd1FJ?=
 =?utf-8?B?YTJFYWQ2M203Qks5bnlDb09jcTJOL0dzT1JUWWozTHBRdGdmVmV0ME02T2lM?=
 =?utf-8?B?WXBRN2hhb3luSUhkSlR2RmlHL1loUkd4c09ST3NZbHZnY3lKUDNMVmIyVnRQ?=
 =?utf-8?B?SVJSYmlVYUpkYkZtVVJMVnZnbzlqSVZ2L2FRWW1FcHozc05NSk5Cbm5nY2tX?=
 =?utf-8?B?OElSRm8vL3J3N1dhS0VhUkhiNzJOckdVMjNST0tIM0pHTERiUHNWN2d1MCtM?=
 =?utf-8?B?LzIyU2VmVjRoWU5WbHhvblkvYmNrejd3bzdOaUJ2cm15blk0bENRWmNkeENq?=
 =?utf-8?B?aVpPMDBadXpOdUQ0eHNyTEoxWjhkdUZvZG92a0hCRHBZUTVTQjFKUmd5Lzgw?=
 =?utf-8?B?Rll2blluOW1RMWRneVdCOHgzUWtwV2FuNmpIc1ZYSFBHYWxDY0NFY1kvUUE2?=
 =?utf-8?B?dVZDNjRwYlRhcDNrc1JuRjlxdlJSckx2ZVpEajVOK2VleUlBanVtRTk2dEI3?=
 =?utf-8?B?VGpOSW41NHRlZGpqcTdUanBCanA2YSt2K0o1V25HR3ZvRHQrUVMrK2F2dHdz?=
 =?utf-8?B?UEhBOXRXMVhlcFFWSHRZbnZwbHRhY0pOT1plQit0cDNWQnlWYWFCa1lhaWpN?=
 =?utf-8?B?bWJUT2lZNWdGMkZ0S2NsOFNuVm56WU4vUFpqRjhyZGVsTjhDeG5tOXZtVi9T?=
 =?utf-8?B?WUdiMU9qZDNMRkM1ZldVV01Wajludi9CbkZjTmpIa21Da0xlQktzYXFSRkRC?=
 =?utf-8?B?TEw3M1RmQzhsS2dNWW15Ymk2Szd1Wm1zZlBpK1dhcDZWREJobitDZHhrbGJz?=
 =?utf-8?B?dTMxaC9RSWNubTZ3OHlHSDFzMmxMZnpTcm1ZYWVCSkltS2hxdFZjdGloSzZy?=
 =?utf-8?B?bzlZYVQrOFQ5bHBzNnpvU3ZheVNZR2o5VFdpT1EyV01YNlZET2UzT0dNa29Q?=
 =?utf-8?B?VEpKKzlFV2pVcXRJN1dldmoreTUzNHEycXJVTFB3MWIrRE9sMW9HRXI2WVg0?=
 =?utf-8?B?S0dGZVlnaWZFMmtZSUhGS0V5NjBXcE03aU1DaFE4WGd1WWZ6NjJ2WlFDZWx1?=
 =?utf-8?B?MFB1SmduLy8xOXpMMVlEZkhkaGRyRzRsMVVSV1F6VTVVcU11WjNiMnAxVFdR?=
 =?utf-8?Q?8IQ8kfUlaOziAckxVw0ki8U0x?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <891E9D507519834789C33A462E0D3BCB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90abb19a-2f5f-4d1a-9580-08dcde24a464
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2024 12:13:33.7560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XYM8kCO6nJKqReYM3VKIPW5dYZkMJ0jSrimnl+ZxP3q0eocSW2fD17tDOYGBGuUqFKfFP1re60rSvtiedLrVRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6709
X-OriginatorOrg: intel.com

PiANCj4gPiArI2RlZmluZSBidWlsZF9zeXNtZF9yZWFkKF9zaXplKQkJCQkJCQlcDQo+ID4gK3N0
YXRpYyBpbnQgX19yZWFkX3N5c19tZXRhZGF0YV9maWVsZCMjX3NpemUodTY0IGZpZWxkX2lkLCB1
IyNfc2l6ZSAqdmFsKQlcDQo+ID4gK3sJCQkJCQkJCQkJXA0KPiA+ICsJdTY0IHRtcDsJCQkJCQkJ
CVwNCj4gPiArCWludCByZXQ7CQkJCQkJCQlcDQo+ID4gKwkJCQkJCQkJCQlcDQo+ID4gKwlyZXQg
PSB0ZGhfc3lzX3JkKGZpZWxkX2lkLCAmdG1wKTsJCQkJCVwNCj4gPiArCWlmIChyZXQpCQkJCQkJ
CQlcDQo+ID4gKwkJcmV0dXJuIHJldDsJCQkJCQkJXA0KPiA+ICsJCQkJCQkJCQkJXA0KPiA+ICsJ
KnZhbCA9IHRtcDsJCQkJCQkJCVwNCj4gPiArCQkJCQkJCQkJCVwNCj4gPiArCXJldHVybiAwOwkJ
CQkJCQkJXA0KPiA+ICAgfQ0KPiA+ICAgDQo+ID4gLSNkZWZpbmUgcmVhZF9zeXNfbWV0YWRhdGFf
ZmllbGQxNihfZmllbGRfaWQsIF92YWwpCQlcDQo+ID4gK2J1aWxkX3N5c21kX3JlYWQoMTYpDQo+
IA0KPiBuaXQ6IEdlbmVyYWxseSB0aGUgdW53cml0dGVuIGNvbnZlbnRpb24gZm9yIHRoaXMga2lu
ZCBvZiBtYWNybyANCj4gZGVmaW5pdGlvbiBpcyB0byBjYXBpdGFsaXplIHRoZW0gYW5kIGJlIG9m
IHRoZSBmcm9tOg0KPiANCj4gREVGSU5FX3h4eHh4IC0gc2ltaWxhciB0byBob3cgZXZlbnQgY2xh
c3NlcyBhcmUgZGVmaW5lZC4NCj4gDQo+IHBlcmhhcHMgbmFtaW5nIHRoaXMgbWFjcm86DQo+IA0K
PiBERUZJTkVfVERYX01FVEFEQVRBX1JFQURFUigpIG91Z2h0IHRvIGJlIG1vcmUgZGVzY3JpcHRp
dmUsIGFsc28gdGhlDQo+ICJtZCIgY29udHJhY3Rpb24gb2YgbWV0YWRhdGEgYWxzbyBzZWVtcyBh
IGJpdCBxdWlya3kgKGF0IGxlYXN0IHRvIG1lKS4NCj4gDQo+IEl0J3Mgbm90IGEgZGVhbCBicmVh
a2VyIGJ1dCBpZiB0aGVyZSBpcyBnb2luZyB0byBiZSBhbm90aGVyIHBvc3RpbmcgdGhpcyANCj4g
bWlnaHQgYmUgc29tZXRoaW5nIHRvIGNvbnNpZGVyLg0KPiANCg0KVGhhbmtzIGZvciB0aGUgY29t
bWVudHMuDQoNCkkgZG9uJ3QgaGF2ZSBvcGluaW9uIG9uIHRoaXMuICBEYW4gc2FpZCB3ZSBjYW4g
ZG8gc29tZXRoaW5nIGxpa2UNCmJ1aWxkX21taW9fcmVhZCgpIG1hY3JvIGFuZCB0aGlzIGlzIHdo
ZXJlIGJ1aWxkX3N5c21kX3JlYWQoKSBjYW1lIGZyb20uICBEYW4NCnVzZWQgYnVpbGRfdGRnX3N5
c19yZCgpIGluIGhpcyBwYXRjaCB0b286DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8x
NzI2MTg3MTc2NzUuNTE2MzIyLjYwODc4MTc0MTgxNjIyODg5MTcuc3RnaXRAZHdpbGxpYTIteGZo
LmpmLmludGVsLmNvbS8NCg0KQnR3IEkgYWN0dWFsbHkgYWdyZWUgdGhhdCB5b3VyIERFRklORV94
eCgpIGlzIG1vcmUgZm9ybWFsIHRodXMgaXMgYmV0dGVyIHdoZW4NCnRoZSBtYWNybyBpcyB1c2Vk
IGJ5IG11bHRpcGxlIEMgZmlsZXMuICBCdXQgaGVyZSBvbmx5IHRkeC5jIHVzZXMgaXQsIGFuZCBJ
TUhPDQppdCdzIGFsc28gZmluZSB0byBoYXZlIGEgaW5mb3JtYWwgYnV0IHNob3J0ZXIgbmFtZSBo
ZXJlLg0KDQpBbnl3YXkgbGV0J3Mgc2VlIHdoZXRoZXIgb3RoZXIgcGVvcGxlIGhhdmUgYW55dGhp
bmcgdG8gc2F5Lg0K

