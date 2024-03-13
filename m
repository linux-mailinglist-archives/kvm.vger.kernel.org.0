Return-Path: <kvm+bounces-11769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C307987B368
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 22:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CFF728924D
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 21:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ADFA53E11;
	Wed, 13 Mar 2024 21:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ibwNw9Nq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73425337E;
	Wed, 13 Mar 2024 21:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710364989; cv=fail; b=JWRAvlaSdmJ3FWk+PJ0r0MENAJA/H1WvoxY9/l+QXS2Kjk4EI/qfYAN5rGQr2Gf0+dCNVg9lY2xgDoAg6/15+mmZP8iAiaqLG1YUHcVu/P1I5oaZU8PlD4OqY6f7rjifR/LEsuIsoTmCuAXvOCsXyb0w++z6grFGxtrCMHlwI20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710364989; c=relaxed/simple;
	bh=vvfoK6zooKsHFa2SW6z5z68vOij0a05dwDb/x/UDfAk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hv9E+bP4oXArYXAQRHnCISDV892nuxU+vQtrqYgypTGhifUMNXN8ImfDQcmpZpJHAeIxkVIPOxyZ7Qye4mSJZLAKyKS2DL2nbD6Kyl/zEv+DYF+lcH0L5tjTVjglrtTq4R2yEoeusfeZrsPWc1jU8vikmoGIg61+a0HJ2lXazow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ibwNw9Nq; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710364987; x=1741900987;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vvfoK6zooKsHFa2SW6z5z68vOij0a05dwDb/x/UDfAk=;
  b=ibwNw9NqljXUQRRsbdtbQ9aVnW9gQsaBsWM3LhQkHjd12hbz1+tUOZYr
   Te3oVDSxpg+g49Bdh4dI9+cLEpMdtegy3P8zG2ry81hVlVZ8cZSm5USYs
   Y0X82ho+IjJnHWPXInOrH3OBTDKGLxkbUi4l+PFix1nee5kaFBoKOeg5H
   M5LUZQBTK3MgW+znlm+ZUDpsQG0MTWbdyudFOIH9l3cdkwN5NVxTv8hed
   Wd0E9t4CDvbTCgY9hNo37ahRhWafzRbFeDd0z2PwNpJayYvceDEgCy98T
   YK7M/X67O5qz/Nb9wzI/xlG5KFskYtNME1473BdMgJKCrY4yWVKm2zN/m
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="8981741"
X-IronPort-AV: E=Sophos;i="6.07,123,1708416000"; 
   d="scan'208";a="8981741"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 14:23:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,123,1708416000"; 
   d="scan'208";a="43100408"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Mar 2024 14:23:06 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Mar 2024 14:23:05 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Mar 2024 14:23:05 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Mar 2024 14:23:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQOkKSc6FTqWeTjKnEC/6sIorcmRKvcS2vA4skDF15QCdwEYHYxofkx1T3Y9dnd/5iKl1DK8N3tAYI/NNuHVD/vou695SaJKluoTuWf9EijWEFExfaCcJKlZAmrnAHghEdcX8Vz1LwlFrFsVzzKUM9Gx2pjybWsZe1r31gvzpTm5j+0UZHN99tgHkFgLh4F6tcf7ddTyuZ+dznBlyXFzIdRV3fzrl7opqba3rZ4UdIyAHadLb8438MN/FI1Fbi08YywRw5pW2nBybGDjHGNMTnWr/fRLbJeX+WwX50S/n0f50LD2ERPoeB34MOKNvF0XXnZIXjGZV/JZow0ZR8/tFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvfoK6zooKsHFa2SW6z5z68vOij0a05dwDb/x/UDfAk=;
 b=nSj15YNMU8TNzMyBSq385sBxaUbzJaiiNOetpC39tIsrukBQvLkP89qIKiO8ypgJJKE2C8MVcE1vmKgUzfDshpl2M2PrbYSkKUmlNfqYb4m6tkAmWbuQXYwMVr5VZrTQQnGO3kzIxo0d7UvzzshBgsSNGfU02ZU5QyjDc/k3n8yGF9mXhPJ/0aRuVSgKQ+3gSWMXCHt+VrCHbaQWJGrdyGAmKayfthv0Ez1y393qcYVOFtWRFy7erOTL3B78zPfb3FmzO1PB3KyvSPwYpxTS7O1HJVXSkX5JxoYkWuDx9wTvvSwA80dXTO1KhpVx63OFzmU9hDYngqoox3By9Q6MKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW3PR11MB4762.namprd11.prod.outlook.com (2603:10b6:303:5d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.20; Wed, 13 Mar
 2024 21:23:02 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::fc9e:b72f:eeb5:6c7b]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::fc9e:b72f:eeb5:6c7b%5]) with mapi id 15.20.7386.016; Wed, 13 Mar 2024
 21:23:02 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "hao.p.peng@linux.intel.com"
	<hao.p.peng@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: x86: Don't overflow lpage_info when
 checking attributes
Thread-Topic: [PATCH] KVM: x86/mmu: x86: Don't overflow lpage_info when
 checking attributes
Thread-Index: AQHadKN4OH6SmKEpJ02B1g4zIHBBnrE2F2IAgAAGOoCAAA9IgIAAAxaA
Date: Wed, 13 Mar 2024 21:23:02 +0000
Message-ID: <367025810d9a12af90ed3a5c6f49b0dfe9997adc.camel@intel.com>
References: <20240312173334.2484335-1-rick.p.edgecombe@intel.com>
	 <ZfIElEiqYxfq2Gz4@google.com>
	 <a5fd2f03c453962bd54db81ae18d3c2b8b7cf7b1.camel@intel.com>
	 <ZfIWnykN1XG-8TlC@google.com>
In-Reply-To: <ZfIWnykN1XG-8TlC@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW3PR11MB4762:EE_
x-ms-office365-filtering-correlation-id: 2ce7565a-3b7f-4bfa-be07-08dc43a3c3e5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pPR1svtpksuHWu8UiFqNBUXMZiZTjRKx6HklE4mb8bi2ntc1oNJ5uFboQiNTuy3PothI9NNyEMJw0FsTen2rLyJxlBpGpkXURQ6j2R1pU4+wiypLH6Nqdjp8YavOfEQXjMXEdTQW5enJAbdvJcK4/mu6xM7UvifNs9Jn1cNuBbJvzF+ne2LCWR898+4aZlqQA+3zSLR/fhBuuiT+pv/tOw2WyGlUdBXr8EXt9Ubf4xcUWbvcuAQpawvmQvc7Bt6Q61RUtt8v7mcYTrw/Jk+DmCzuhz+RX5e5G3TfXr9ay6SdvMK6Gf8B8n48H/xlxO26W3zCkr6MSGaTQ7wAHqUiodw+Ig6Pc4PeZfm6JWNj3QsY9W21UJ2BK+TCusIo7kf0f7GDFh2cukgieKBHR8I3NDs6Ag5U55K8wNgK4Zrsvv3JwD4Jd/o0r8hkPu21sslvujUyGkAvD9TR2htOL6Lu5EpJT/Tz9IvSFpHTpvEAnhIkmKtx7s4cq97VUGd5PyV4bOY9rfrtcOUHouwV+08bgsz22h3Y064MW814xCysU62EFSxTZkjXCLLHa8h6M7rZq23l1xixxrUr5iCITchEw7LgarigyxC7s2MqwmwBth6Ac2OjMSNAH1LDSx4ypSEcw8wALDZBIGqF4jjxDe2gITOIrvIuFLqCBdVq12Y4EbBbxQN3lRP74BLFNbjetHAKByNz+AWYbkUqPv/I8u41P7IKzk8wZPcgPG+RbSXhw2M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UTAzbFhQYmhzTkdvNWkrcDlVdEN0QXV4SFRrZzF6ZG5ZUDJQaU9ReC9rdG9r?=
 =?utf-8?B?L3NRU1JqVk1ucjJjTG53M3B6UGNBUVV2VER4ekNRNXdqdFlGWmlZRFB2K1Yy?=
 =?utf-8?B?THdXY3VrUEFLYndHNHhIbGJPRHRVeTdub3Nydi9zbnRxUXpYNk43djB0RldX?=
 =?utf-8?B?TmRCbUZZUjJyVXdFV2JFY2tselZrZFFmS29XNnBZUGRaYVJybHZEalFLY0xO?=
 =?utf-8?B?L0lUdHVWNEZlL002NkpYWEJ3YjNSYm54SGY0MktsVXFlYVJRWVBhNU0vZ1Vi?=
 =?utf-8?B?eTU4WHlheUpQWkJWM09XK1pCcU9rZGJSNCtxbFJ1UUkxYnJCRG1KTVFaMktM?=
 =?utf-8?B?NkxZb2wvUkZXMEJrR0ltNFJFM1RidTcxVzdyMjE3MjVQQW8xWk9MMGc2bWhC?=
 =?utf-8?B?OUxWN3VUQXFXZUdDYUVTTWlDclk0M25VVUoxcW9mSkY3RlhHVFRuTzdLYlJV?=
 =?utf-8?B?NkNSRXU5cXpJQXl1U3dTUE9aQ0hQSHQ3SUFmYVZWaEhmSzlCWFdwbHJDTk91?=
 =?utf-8?B?ZDJaNlM3ckc4VXRaRG41bG5wbDJLV1k0WmoxME1td2NQa1MrUUdhM0JHdkl1?=
 =?utf-8?B?eXgxSjU4azVXd1E2Qi9QOVBNQ1NyaSsvTjZ6Z29lOGs2YnRsTEx3QmJoR1JS?=
 =?utf-8?B?UHJQbUlyUGxRdU5MdW94V0MrdWhBRC9xMnBQdmdzNEgydWFTQkdVRXFiS1BV?=
 =?utf-8?B?NmtGSXNvTnBnR010RTd5U050RktvYVhOWjZRUWw3WHliWmw2bTdqUEhPTVlY?=
 =?utf-8?B?RUJzRjJuQk9VcWgrdTJESlZwR0MzR013YW9wRW1qM2N5K3JOczJCN0hOVkUv?=
 =?utf-8?B?NkhhRVRTWElaWEVrRW5UREtCazB6M1BLb3JYczFGOENJUVpLbHQwYnFka0NV?=
 =?utf-8?B?Qlh0cnlrbUNSaS9GNHRkQUxzTzNKQlMyWXJ4NXdSMWxCRjdTNFY4ZlgzVHJw?=
 =?utf-8?B?MHVuN1dZOStHYnp1ZktRcXFaRzFDbkJGZE9FNm5EM2laWlBVanNWZ1dpUUJt?=
 =?utf-8?B?T0FBdFV1eEpDVHN2cmIyYytlQjBwVDNqbmo5NUx6YzBBSklNQWhNZnJqeUxB?=
 =?utf-8?B?dForZ2NwWVp0bnJsOFZjTzVUV1V4Z2VNWnBuUXZpVjUxVjFzRjNzb2dkWlBJ?=
 =?utf-8?B?cXVTSDZFb3lXL24yVEdnbmF3UWhIMGpLVm41MWVubk1NWXhuMkVZM0FUcmVC?=
 =?utf-8?B?cGxaWElDRldZN05UVFZYaThaL0F6TC8xSXpuZzdvblhjNHZhUXdmV0VVUWFU?=
 =?utf-8?B?cWJnUGZmVUlLNHRwTGs4Nk9XcGhZNUc4RUhad1N4aFZpWFBYNkkrRU55RFY5?=
 =?utf-8?B?bFo4b3hzTklmSElBSlhJYnlRcTJORzVDR3pUbEVqLzk3UzZzYTgrcldrN09D?=
 =?utf-8?B?NnliQnQ1YWxBanBSMUhuVktmM3I2VmJteFdvbUp1ejBWakRSdUcxZTR4a1ox?=
 =?utf-8?B?WmF6S21hRGNhdHZRVlIxdWF2QWk5ZDZRdloraGh0L1JNOUpYQ3VDalJaQnRq?=
 =?utf-8?B?ZTVRaEhQRHdDaWxrWWVRU3orUVhDRlkwbklMSFo5S3ZYM2tVckdvY1AwTHBE?=
 =?utf-8?B?NVJVbEtjdlpFcXVmSmJOcFdkQ3lPaE9VZXlMWXZpQUVkRzZyRVVDODFncExV?=
 =?utf-8?B?MHdTaWg1QUtjV1ROM2x1eUUrU2dscXEwRndkODVsWkhEMFlsQlpScUJYdS9E?=
 =?utf-8?B?M0lrR3pNMEF6ZUM5VWVvR1lZdFFhNk5ySUdyN2lka0dFdEk0dFNiMmFDSHln?=
 =?utf-8?B?RWpTR1l4Mk10TnBsZ2ZJWGkzK0EvbGpKZEt3NW1wcW1LYjFZS2VlaEZ2TUtY?=
 =?utf-8?B?N1hYN0M4YkFOY1dVTXdHRUt3bW4zbmhoM2xjZkRHNHR0RjFkZXVWTm9Zc3pQ?=
 =?utf-8?B?S2tvY1JJb3ErM2hpbnVaWmhKcTAvakI0ZzM3S3FpVDBKL3hGbnU3QXhaR2RV?=
 =?utf-8?B?Z0tiWjlRbC9kL1hxRU8wMS9FVURuaHA4RnpNZ0phVGFTZnozeXEwdjY5S2tD?=
 =?utf-8?B?YnYzcFZDTWlUdWVFK0dzVHNxREZCbFJHTS9vbnZIckIrVnVDbTMwQWI2Z25n?=
 =?utf-8?B?dXJCbmtXUW8xbTVuMlAwVm8zNTdyZU5TQTdwR0dBVDZ3UWVlNVJIU3Z5a2gx?=
 =?utf-8?B?SDh3SVUwWXJUd1hPd0hKVG5zbUNHejdyb0pVS09WYm5kWXRWWWw5VWQvcllZ?=
 =?utf-8?Q?AAYI7exg3ZCrdfug+Qte+VE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A0EF6D2B881B0C4CBC6A85D8B0FDF54C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ce7565a-3b7f-4bfa-be07-08dc43a3c3e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2024 21:23:02.4758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pQbitA6wViG7+aIMMOr5Yv1vL3tj7VtVTfAdDINQ+UBcZlJt+DOOPz8SXAiF8kSrThXeQDKmYaZmUCzB0MYjZmo7TO2TyMiRdsm1W8rNXc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4762
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAzLTEzIGF0IDE0OjExIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBJIHdvdWxkbid0IHByaW9yaXRpemUgc3BlZWQsIEkgd291bGQgcHJpb3JpdGl6ZSBv
dmVyYWxsIGNvbXBsZXhpdHkuwqANCj4gQW5kIG15IGd1dA0KPiByZWFjdGlvbiBpcyB0aGF0IHRo
ZSBvdmVyYWxsIGNvbXBsZXhpdHkgd291bGQgZ28gdXAgYmVjYXVzZSB3ZSdkIG5lZWQNCj4gdG8g
bWFrZQ0KPiBtdWx0aXBsZSBwYXRocyBhd2FyZSB0aGF0IGxwYWdlX2luZm8gY291bGQgYmUgTlVM
TC7CoCBUaGVyZSBhcmUgb3RoZXINCj4gc2lkZSBlZmZlY3RzDQo+IHRvIG1ha2luZyBzb21ldGhp
bmcgY29uZGl0aW9uYWxseSB2YWxpZCB0b28sIGUuZy4gaW4gdGhlIHVubGlrZWx5DQo+IHNjZW5h
cmlvIHdoZXJlDQo+IHdlIG11Y2tlZCB1cCB0aGUgYWxsb2NhdGlvbiwgS1ZNIHdvdWxkIHNpbGVu
dGx5IGZhbGwgYmFjayB0byA0S2lCDQo+IG1hcHBpbmdzLCB2ZXJzdXMNCj4gdG9kYXkgS1ZNIHdv
dWxkIGV4cGxvZGUgKGJhZCBmb3IgcHJvZHVjdGlvbiwgYnV0IGdvb2QgZm9yDQo+IGRldmVsb3Bt
ZW50KS4NCg0KRmFpciBlbm91Z2gsIEkgd29uJ3QgaHVycnkgdXAgYW5kIHRyeS4gSSdtIG5vdCBz
dXJlIHRoZXJlIHdvdWxkIGJlIHRvbw0KbWFueSBwbGFjZXMgdGhhdCB3b3VsZCBoYXZlIHRvIGhh
bmRsZSB0aGUgb3V0LW9mLWJvdW5kcyBjYXNlIG9uY2UNCmV2ZXJ5dGhpbmcgd2FzIHN1aXRhYmxl
IHdyYXBwZWQgdXAsIHRob3VnaC4NCg==

