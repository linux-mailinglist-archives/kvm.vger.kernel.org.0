Return-Path: <kvm+bounces-12453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 239708863E1
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 00:12:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43E711C22441
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 23:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF5D6134C0;
	Thu, 21 Mar 2024 23:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dmY/gsQu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5070279CB;
	Thu, 21 Mar 2024 23:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711062764; cv=fail; b=GRruwSvXhYxySuSZW+vfD3cuLAu+haxdBv9Tz/AhqOB8JDAGlLhWQMG77I7dWwBos7dHaKWaz2nzyKNU//IBz7x3RVjaZRHpEyyH4igCKMv2Qp0/aDsmpNuB1uUUZCrrBnnvk2N967eNm6eu00ulAIqPd9IN1lYFQQX+64ncWm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711062764; c=relaxed/simple;
	bh=+47F1NXJ/mSVuETkb7qqHj3gQi/XrSX0TnCO5OfBuao=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CpWLvEgZLsEbwG7uPPLKBd46wB8kzBEFoYnLSAxmkUi0n3j0JFZ50YQ3p8v4ORpuFDukR7Kbfp7YSktDaxKlS6JVXGQiNpPzQVTr0h1ifV7PiJKqAspDCqpPVKlakoTxeWVBX8a1dEM29OsCy3aPEpO6QXXtQkj8gmw1AQ4UIyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dmY/gsQu; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711062763; x=1742598763;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+47F1NXJ/mSVuETkb7qqHj3gQi/XrSX0TnCO5OfBuao=;
  b=dmY/gsQuBNfRZfLUhDFjkZOLIK/7v5C3BABnwN7Z1FQQQ16Oria/onGJ
   JhiNDMuUhX9G6i0sS+O4PcVy8Dgif0T6UnnK4ZmKZ48QPLe61c4ZB7Gf+
   rHjKMTPR6PDQURMgWgT1r33wvY60sLM7eNquNyNCmdvG6MK7EFaXuj+PY
   ckbGYO3oZ0IRdCqo2r0Gk7TFXAvZJm5oe4FzdqNx0kPFCcvJnqnYMc9XV
   rijPlbOsHwB09aay4Jx2TxvPoMlBl3A5as6mSkavQhL728Q1jFfaZIEvA
   3ul6tsZ6h4ILOdYY2VrAl2mOpEUosKZVIX2FdRW4xhE7VCrgscoqWRb2I
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="23545250"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="23545250"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 16:12:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="15098913"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Mar 2024 16:12:41 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 16:12:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Mar 2024 16:12:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 16:12:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFD2I28IB3xFTBLm7WlMWQERvkaiDo8njgeP0huuNgG4zL06HcoTw8th3ATDJn35hdWpu0kmJjOIZY0jbuJ7NqdBurMMGmzWojKQdwNfj48wHQ1UFRfOcGC2n5y6+cmGlDV2CjHM+yTWWlT8z65/aUcBlKzVf0F53f6vmwNrXu/qM6APN5MockxNZ0c99n3EmwKc9TqsRcUIreTJhRXRJBvpMHP1gnHGDDasUO/yEDIjh0aoW6ijUtUSjniLhOn4KTvqZxPr8uhn9BTBgqo3ZPQJdDUUaANizE+25H8jBUz2kPYOFS8QnscLisqf/D7r7VXnMjqzK9L2QL93njy+8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+47F1NXJ/mSVuETkb7qqHj3gQi/XrSX0TnCO5OfBuao=;
 b=OnmQOJn+boIkiRxARt6qP7EyhaQh9pp57OU9e/Z5W2zcPf3gbj5A+GAZdqmz+p3vZ7KJ3Mg4M4zDBkex/EHUS7jdxt4aw7VH+wm+qH6Dqw3DAvF+zgAM9dAxwEZ4vKI2eKUz0lDGrAcE/RQROAQpG3LoUeU8Olm7HxV5NhWtRwI/rzJtuQ30IsPk+btSMF0E0YDDfSGa1DPJORX/eiGCKkbw/nTPaKH+HXJnzym2pU9v7zmd1/H+Xz21pawGra2f13UiPX5SBuAQyPsKa05LEDaxnK2xyxf2lfDCBDEZ4ehZySj5xv4WZlkLGwz4gZ3euY0vXQe0pdE97AHNJDiYug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8435.namprd11.prod.outlook.com (2603:10b6:610:169::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12; Thu, 21 Mar
 2024 23:12:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.023; Thu, 21 Mar 2024
 23:12:02 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Thread-Topic: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Thread-Index: AQHadnriF1ZBxh+AQEWxyxeO2jbjmbFC3WOA
Date: Thu, 21 Mar 2024 23:12:02 +0000
Message-ID: <e1eb51e258138cd145ec9a461677304cb404cc43.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <d394938197044b40bbe6d9ce2402f72a66a99e80.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <d394938197044b40bbe6d9ce2402f72a66a99e80.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8435:EE_
x-ms-office365-filtering-correlation-id: afa76212-605f-4fe5-f5a8-08dc49fc5169
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bL5DXaGIBuM/Yyggyp10UQiZwW81mYgKblqMdssQ/6fvgRfOVYltdAMx6jpDaif2qhecZPwgsjFMDYcvF1cKzJ0P5B/KzAkGUkdDAotfBij9bYwQktmFvaA/ZFMzCLBrePSwvWIJmYM+UR69Z4r3hwC5Z405VuIbhK2DRkWFgskxiGhEOmenoogwW0GCfanKqsQq4iFan+4KAIzvUfY0gxgoCyBNWnhOSnxw88S/nI2joSUw1ct4+MDROqe7wSzwwLPkrXAainX59bbnzHcBCrG0JzgLVBFW1sQNSYzNYk5rrvkXZuyZnMSKNUY2e+7Wzi3TPuZgixbUVWSio0faQMJcaISfjQLxr0mfRAWYWWBLCDWIderB0kp3WmnNx3PW8m8yvXXJCdNKSopWlTcoruSltm30vODMhOZpg7h5A8Uw9v+gBjlaFxg1mRVla6L6PubqCRxqG5EyaU7uslghhHWVkkxaStME6xJ7OgCeumG/K3IVnszrn4gEUFS17tmFqi2p2FXcluYbtxjQl3z4roGCAdunV2JnuXa2Wsm7f4N6DJMOCzKqDlzd5WhAuzBvKWjrhQiFg34SCa4UtuLjVUXb0aVRNl8ZCYFLHqoxErgR1w/eRi6a8/s8V2Bs6i1ltqq7B7yvJuAbSaEMuEp1T//NF4/jbNsfgZ2N1sf6D2N5oziQuXGh9yXz1VtQCG/cKccRihYI83UQucsroSL+L+/l0l71ZZBXuTAXDeHdsyI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2dSZ1ZvcVMyL3lkRi9YSE8wQkx2TjBMbmxMNzFMcHVxeWxuMVFoOE1xWXFp?=
 =?utf-8?B?MEU2RVY1WHp1cUIyQkRHWmx1c0sxUUZLUlVteGI2cllXb3N2WlU5TnZNYlF3?=
 =?utf-8?B?MlRiVks2blVSRno3anQ0bFFzMXNoTlRaNTJJbDJSYmhXZ0xwdERkSGl4VzZZ?=
 =?utf-8?B?a0FCYysxYXVMYm9sN1V6Q3ZvSFo0bUhjRkZ0RHRwbTV4YnplRVVSRTRnaDBk?=
 =?utf-8?B?VjFpbGRmcU80dFE4UkI3amRXa0JwQzJVQ09pS00yK2ZTNEYzS2taWFFPN0oz?=
 =?utf-8?B?UTZNeWd6Z1JQM0E5c3gzUTJ1QmJDcVFtZENPb3ltWUE1Ym1JcjZRb0llRmZw?=
 =?utf-8?B?YjB2TjR6NTNuVmF6VWUyMUNQZHFnZ1NLNmdkN2taeFIrazg3ZFZRZlE5WkdN?=
 =?utf-8?B?VWRIYzNndTlUTTd0aSt4NGsyMkhsL24rdzBnOGhGOWxjVi9mQndCaTZvZmJ6?=
 =?utf-8?B?alI1TVRldVo0U082NVRJSFRSSjNPVkRweUpLRUZOT1VycC9Da1VnUjhLMnpv?=
 =?utf-8?B?WlNwbDR5clhRcHF6bDg1VDlQZnlreFF3MUhDeVUxTmJYQm1xbjZNK1g0QWQ3?=
 =?utf-8?B?UkJseldhVEVrbGE5Szc0WUVxRUtHa0hEbmdtSUhEeHNzWC85QlFERm0zWUxm?=
 =?utf-8?B?RXBmdlEvaDRaYmV4MVV2blpnMlAxY3FmK1UyZW1yV3M0dVptMzlHNkI3N0Fs?=
 =?utf-8?B?dlA1ckhBYzZHWndYYXRKaUJHcVVFa1R2TFZMSGlaZHFWcHJhWmc5TnQ3QUR6?=
 =?utf-8?B?N1FWWmxzdWlGM0VUaXA3cVhESCtKWEh1M2hxS2lwcUxVemt0dGxsQkN6M3pY?=
 =?utf-8?B?cC9oT0NiczE3ZmcrWjROSnZEVXk5bERVditYMEtrZklIdDVZMEZnZUdBWmMz?=
 =?utf-8?B?MEI1YWZGNFNYblAvNDBtL3VURlo4dFB5U0FRb1o4azJVVXphN29iUkF2T3VV?=
 =?utf-8?B?QjNKNGxVL0dQVkJrckR0aGxaeW1ldU9razZGYTBQeXZtaWNJRjBoRFFPZDYz?=
 =?utf-8?B?ZkJ0aytKYm5OOHhIMFp5U2pTVTlHNDlHMzVyRUw4ZVE3NUk4dGJBMGpvc2I0?=
 =?utf-8?B?clhMWjZWa3dnRmJlVDJ3R21SWHRrSDNSYzBpazBIZ3VPaVVMMjNSWjhLVHFi?=
 =?utf-8?B?anhvL09sRTZhK3h3MDNmNDFxYkx2d29DaGk0dVBoUndONEg4MWtLOE5OSjdz?=
 =?utf-8?B?cUFVOU1iWllleVF0dVJ6TmFJSGtHVHFYYm1UMlc0R2FGeTdERmhROGV6SE5z?=
 =?utf-8?B?N29uQlpVdEtUeUdiR1FWYTljTDRJbGlKTEpITVVGTU1DR3pzeFdVVWNGbnd4?=
 =?utf-8?B?YVhpaGFGc21TUHZZU3FFeWNiL3A3T2dDbG9EN1IwandsR1k4Um4vdnVDRFR2?=
 =?utf-8?B?dWxrKy9VR3lVNHN2ZGZHWnJpRUZqNzFxWkZjTXYzY1pHVUVTR3V1NWR4WGI1?=
 =?utf-8?B?d1hhQkE2cVE1YkpTZkdyN2xQOFBXSENpSmxBU2RNNnBPb0ZIWUNteDMzSXlh?=
 =?utf-8?B?SGd0V3BYZmJGTkVZQURUN0pDd1BuUmh1ejlpa3pqbjhNSUpyR3k4NXdkcHVY?=
 =?utf-8?B?ZmRyK1lXYkNwSm4ydGh3ZzUxK2U2YnZRZ2NUa3RpNVlwQ2RRbEhLUmRWd0ti?=
 =?utf-8?B?NHRjR0cwNHp3d0VBMEVSc05IYXlMb2RCQlI3RnFvZzhpUGV0MGQrNU5DMjNm?=
 =?utf-8?B?eTFtcHkram1JanBNV21xdWJnalZhaGJISjRCam1qdDBOak1Zdk1Ub0puYnM4?=
 =?utf-8?B?WXpGVC91bkxjbldHdU9XRVl4Ui9aMnRnbUFxdlorZSt2QVFiRFl0Yzd0VjVT?=
 =?utf-8?B?ZkFMeWFkczkrSktodkZKODhlakFkTzZvVUNiVVBBUXRVTDdvLzRkUVIvZTZs?=
 =?utf-8?B?ZHZpaW02RDZvWmJtMllpeUVybHdXVzFDRFJUbjdmNTZFMERSR3NFM0F2QkRm?=
 =?utf-8?B?YTlFVFNzd1k0NTE3OHdvM2Y5RG5ReVlHTm1FV1pGUHROcUlRTGxrbWFjNDNS?=
 =?utf-8?B?TmR6dHdHY3VpbWZwRVFMaEdObjN6TlBiYUFIUlpsLzQ4V0FaMS82T3VSd2JX?=
 =?utf-8?B?aVBrd3ozVW9JR2c4Mi80eDBaT0lQVU1STW4veS9raE5MOUJMSmg4dDVaSW9o?=
 =?utf-8?B?QWF2OE5HU2tVYytVSUhmMHA3bXBVbDRrUjcwUUJDNDN0Q0FwczBjOGZJZGlh?=
 =?utf-8?B?YlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2263C105CE0BD24C9031A3A5D73110DB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afa76212-605f-4fe5-f5a8-08dc49fc5169
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2024 23:12:02.6002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VsIil3T95cCUKnYZ4fTOimIZ/3WWqbhjVT/tMvop0P5eb5H8jU0RvDAks/FFlyKofYmHr3lKOJCt0a/xf8r6QFs0iLjV74E6oCHz/brvjJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8435
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI3IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEltcGxlbWVudCBhIGhvb2sgb2YgS1ZNX1NFVF9DUFVJRDIgZm9yIGFkZGl0
aW9uYWwgY29uc2lzdGVuY3kgY2hlY2suDQo+IA0KPiBJbnRlbCBURFggb3IgQU1EIFNFViBoYXMg
YSByZXN0cmljdGlvbiBvbiB0aGUgdmFsdWUgb2YgY3B1aWQuwqAgRm9yDQo+IGV4YW1wbGUsDQo+
IHNvbWUgdmFsdWVzIG11c3QgYmUgdGhlIHNhbWUgYmV0d2VlbiBhbGwgdmNwdXMuwqAgQ2hlY2sg
aWYgdGhlIG5ldw0KPiB2YWx1ZXMNCj4gYXJlIGNvbnNpc3RlbnQgd2l0aCB0aGUgb2xkIHZhbHVl
cy7CoCBUaGUgY2hlY2sgaXMgbGlnaHQgYmVjYXVzZSB0aGUNCj4gY3B1aWQNCj4gY29uc2lzdGVu
Y3kgaXMgdmVyeSBtb2RlbCBzcGVjaWZpYyBhbmQgY29tcGxpY2F0ZWQuwqAgVGhlIHVzZXIgc3Bh
Y2UNCj4gVk1NDQo+IHNob3VsZCBzZXQgY3B1aWQgYW5kIE1TUnMgY29uc2lzdGVudGx5Lg0KDQpJ
IHNlZSB0aGF0IHRoaXMgd2FzIHN1Z2dlc3RlZCBieSBTZWFuLCBidXQgY2FuIHlvdSBleHBsYWlu
IHRoZSBwcm9ibGVtDQp0aGF0IHRoaXMgaXMgd29ya2luZyBhcm91bmQ/IEZyb20gdGhlIGxpbmtl
ZCB0aHJlYWQsIGl0IHNlZW1zIGxpa2UgdGhlDQpwcm9ibGVtIGlzIHdoYXQgdG8gZG8gd2hlbiB1
c2Vyc3BhY2UgYWxzbyBjYWxscyBTRVRfQ1BVSUQgYWZ0ZXIgYWxyZWFkeQ0KY29uZmlndXJpbmcg
Q1BVSUQgdG8gdGhlIFREWCBtb2R1bGUgaW4gdGhlIHNwZWNpYWwgd2F5LiBUaGUgY2hvaWNlcw0K
ZGlzY3Vzc2VkIGluY2x1ZGVkOg0KMS4gUmVqZWN0IHRoZSBjYWxsDQoyLiBDaGVjayB0aGUgY29u
c2lzdGVuY3kgYmV0d2VlbiB0aGUgZmlyc3QgQ1BVSUQgY29uZmlndXJhdGlvbiBhbmQgdGhlDQpz
ZWNvbmQgb25lLg0KDQoxIGlzIGEgbG90IHNpbXBsZXIsIGJ1dCB0aGUgcmVhc29uaW5nIGZvciAy
IGlzIGJlY2F1c2UgInNvbWUgS1ZNIGNvZGUNCnBhdGhzIHJlbHkgb24gZ3Vlc3QgQ1BVSUQgY29u
ZmlndXJhdGlvbiIgaXQgc2VlbXMuIElzIHRoaXMgYQ0KaHlwb3RoZXRpY2FsIG9yIHJlYWwgaXNz
dWU/IFdoaWNoIGNvZGUgcGF0aHMgYXJlIHByb2JsZW1hdGljIGZvcg0KVERYL1NOUD8NCg0KSnVz
dCB0cnlpbmcgdG8gYXNzZXNzIHdoYXQgd2Ugc2hvdWxkIGRvIHdpdGggdGhlc2UgdHdvIHBhdGNo
ZXMuDQo=

