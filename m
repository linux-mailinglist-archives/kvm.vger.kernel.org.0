Return-Path: <kvm+bounces-27285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D14E597E5F1
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 08:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FBA72813CF
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 06:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 298B317BA2;
	Mon, 23 Sep 2024 06:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MtjbcgHo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3970D10A3E
	for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 06:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727072560; cv=fail; b=ETQH0XtTZ/y1NHtGUB3HEXSbj4bpcvW5SkDo+5/d02hgKe9nx6uOjeplUPoCvXMAohluI3bfVDd42b5J9ACcxOPfsFkxe+w058sUTD+rRD3i7uEyb0+yxZ9iFqTDvwwc2aeRKR97c9S9AAE3RcEP1NB+UM42lPTSV2T6/Cn2arg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727072560; c=relaxed/simple;
	bh=Bn0bw4Kj7cgcYcY8hNs8cXUmb865J1y8c53gEFWRtO0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fa3sywVbqw5bhNzGxZEqGvbEc5uuRsjPDuvUE9NDISmlPx7JZun64hcyg+qn3KY5HDtL8Q/K60QEdCfH9S4NiG6nn+rTupv3EyhqTExr3kOvP93i1YmpNDCN//TtvH6xbTznhxY5HVuRdpL3YslLUcI/e/kX7+XOGjA+JdxCpXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MtjbcgHo; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727072559; x=1758608559;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bn0bw4Kj7cgcYcY8hNs8cXUmb865J1y8c53gEFWRtO0=;
  b=MtjbcgHoJbz86abdJMHQmeHiigQ0++kHYmq0iUnI0BLd2qvR6d4uTf+H
   KlrRzpeRDQ5/xCE4CpB1yemWZ80vYfFebu53ywKgSjLCV3B1/188e5jFm
   x6Fba9H2OTmVC13OBxaYSddwVSBBqP6L92+0fuJphl2SABgbh8El80Dgb
   aEva0XR3LtjDeHtrhL7nuo66icpS9im3gLtmnDz5Zn63vVnrpIq6DxRCy
   lZEWicNg9X/r8JlrKbbE8PamhjFSHW2DIpfzBCWzMGm9/KxAEoEcfm8Xn
   A1MPbWHDAO3w1ktyidYbUHP+YyTXtgO4uhucFtMqmdzjNSu+iBgcC4jwz
   w==;
X-CSE-ConnectionGUID: LFHVfZnZTpmJX8jkDw7RaQ==
X-CSE-MsgGUID: VgllYMbtSLezQOSjdcG8QQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11202"; a="43473254"
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="43473254"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2024 23:22:38 -0700
X-CSE-ConnectionGUID: fbloyjesS4qSxLmZSr1QOA==
X-CSE-MsgGUID: RBskWDs0QPqPMa/ymZPM9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="70562006"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Sep 2024 23:22:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 22 Sep 2024 23:22:36 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 22 Sep 2024 23:22:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 22 Sep 2024 23:22:36 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 22 Sep 2024 23:22:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N5D7O7HW4E4+I3gDDuCdu2c4FDvnaFjPMLXB5I057LGbmWZ9UEO9p6WKsfQklbQMbspjCQlGFx6v7N3GW7lOgWKD51NUPlC9blecOp4xy8+ENNRFXrMjK5mYKLzj8RKM+g80zNGz/IvTCvMOd87I2vwFhKvCzwQzQbWGlJ+juRFez5rlc2xdIq/EhahKgwgTD/Cvgpqka6mLdAHzzKiUO0yml5GJH4uoTffbbQTfUVxhBcDkdCBYxxGOzUFT169FerjaG+zh2ZyD89/wvP6rviZd5IJN2+WFg/8xBVoslE2EB/HkmPosIlvsQCzIgO/+0JJ61IQMoqyKalD1HkFlpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bn0bw4Kj7cgcYcY8hNs8cXUmb865J1y8c53gEFWRtO0=;
 b=T3K5iqhNW9aRTOOKSH6nIs2WcXgzYqmehUFkZaZ5GC5p6WJkIpWqmQXcDJWc46cp3jlH+eBRPC535rsXHEaHv1t+mjRDU2VdPG6tZ6AH52ximviNx+73Wn0ktrKyhRXElZMWicMI2RqmD9F+lptnPH3lC2Q9d6R2SaPFUwtdr7QMhsAKZm/LV3hvdIuoVwwkkebVrf9BjyjlKgRjRIA8C8R/quiWU2Y0r5B467qPt7qyME6g5IKb5ATGzqHmy3/txLxO4mZ9Z3gTgMDOfzTOcborQmjZfxuXOTGXAI8DxCEmDo0yw6IAuGWstDEDKbAzg5ppeqkRESY8hzngZTp0Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7173.namprd11.prod.outlook.com (2603:10b6:208:41b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Mon, 23 Sep
 2024 06:22:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.7982.022; Mon, 23 Sep 2024
 06:22:33 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "airlied@gmail.com" <airlied@gmail.com>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>, "Currid, Andy" <acurrid@nvidia.com>,
	"cjia@nvidia.com" <cjia@nvidia.com>, "smitra@nvidia.com" <smitra@nvidia.com>,
	"ankita@nvidia.com" <ankita@nvidia.com>, "aniketa@nvidia.com"
	<aniketa@nvidia.com>, "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
	"targupta@nvidia.com" <targupta@nvidia.com>, "zhiwang@kernel.org"
	<zhiwang@kernel.org>
Subject: RE: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Thread-Topic: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Thread-Index: AQHbDO4JkHnxGOPNCU2lsdYB8MwR7bJk5jyQ
Date: Mon, 23 Sep 2024 06:22:33 +0000
Message-ID: <BN9PR11MB5276CAEC8170719F5BF4EE228C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
In-Reply-To: <20240922124951.1946072-1-zhiw@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7173:EE_
x-ms-office365-filtering-correlation-id: 999bf004-2f46-43e7-2b9e-08dcdb981c11
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?L1ZMQjd2bzZQK3FGV2xmMkZyQ0JSYVRPdC9NUEk1YURSd1hMTHp3ek5mbk9n?=
 =?utf-8?B?K2RrYUpMTVk4WnVlRXNwL01PSlNnNGlRajNaZC9zeE5mQVBETVdJR3JuZ2FI?=
 =?utf-8?B?azlwSTBGUE56T2FmckFtVmJCYUo0NFFXVDNxK3N6bEpyQVpPWTVqZ1ljUFBU?=
 =?utf-8?B?bUNvT0dKamhUcGpmMGNpN2RuWk5KYVIzSHF6YjEyeU5SWlIzNWVFQ2dPbm1Y?=
 =?utf-8?B?Qk1sdDFla0pyWUt0MHBGekJhQlBjalRQWnVCQVhOUkhwTFpKVXNqa0RvbFlU?=
 =?utf-8?B?REVMWmhBTmNYcXVxaDVUUGYwT3FWVUM3UEs3WFVpbmxUTlFQc2dIMW43dVJC?=
 =?utf-8?B?Sm10Mm41akc4NEJqV1ROMFBFSmczMjVkK0wyWUFOeEp1QVNpMUJQSTA5MFI2?=
 =?utf-8?B?bkNpM3RuUTErOEQrd0VRaCtJeUlJMUVEaFJGVkNza25qZzIyYTUyTkhlUEsx?=
 =?utf-8?B?M0ZPY1QvK3BnMCtOVURvdG5UTlI1QUNVblVMNTVvR0pqdWNUS1JwS3lVaHIw?=
 =?utf-8?B?T0x2MnY3dWxrQjI2UlBrdGFaQkRUdHFVM1c4SjgrZ2xxdHkvREpCcjFqVm9J?=
 =?utf-8?B?ZEgySmFDR1Jjd3h1T3p0ckxqblp3QjdYSlhmTjByQzlGQWMwcGdkTVRIaWdI?=
 =?utf-8?B?dWxqRGlzUmhoS1BiVE1lUFlrQU4xTkZjM2R3b0ZYeUZjQmNXZFdPV3lhcjhR?=
 =?utf-8?B?VGFwMGRJQ0lhNmxBTGZlWmk5RVFVcndQYzdxL0JJVktDQ0xMTkFpZGpmS0dJ?=
 =?utf-8?B?cVM1RFFDWTRDQ25sTTFKcm84WFJSNDJxdGVNQlBQVXhlcFN5K0VXalh5Nm94?=
 =?utf-8?B?b1hXOWp4VStwWXNEald4VGFwSVFydC9ibThoZ1FMVXFwblNjYzdVK2lHL3hW?=
 =?utf-8?B?MEIxRkUyTEx1YWJWNUQ5bUM4MWhrQlpQcExRMnkvUTlsVDByYUcxS2ppdk9B?=
 =?utf-8?B?R3crT3ZOQjIxRWxSSTZ6UVVvTmJ1NG1YWmQ2NnhpOHNZWkVqYUx1cGt6b3Z1?=
 =?utf-8?B?VVJXcU1teWtqdmRQODVhS1lJaHVMQ1ZNZlZPUTN2MVNONzkwYy93N0JZTU5P?=
 =?utf-8?B?M3ZFWWZVU2ROYW16Y04zVkN4bTFiWE45dS9TWExIbFdNRFppRzd1YVVLSEdJ?=
 =?utf-8?B?ZFNGOEZHcm5UUnplcVZxaExIUFZoTjhndmZBODNMM2Rqa2t1VWlQbFcwRFI1?=
 =?utf-8?B?bWhxWlFrZExhTTdpVnRBNWhXWCt0OWs0K1lKTmx2SS9kdW90Y0s1YmFHc2dJ?=
 =?utf-8?B?OTV6MlhWd1FmOUY3QkZUazJpbWtYUERMYXcra1VZOE9xK2VEMjNyWDhib1Z0?=
 =?utf-8?B?dnh4RUsrOG8wY1FGYnFUbkhtbWNzcGMxU1dKbFFJL0RLem4xRFR6c2NOcEp4?=
 =?utf-8?B?bExYQi9YYTg0b09rYXBTN2Z3WVVxMDFzMUxldFVnbEJuK2plL1g4RW9CNFBt?=
 =?utf-8?B?eXJNWlNZSWdiclJkWlVMaXRCTmd3bDBjRWRveUp2bGo4NDU4bkl2cHNzZDF6?=
 =?utf-8?B?dTludmxUanlwN0F0VzZkWGNJdmJUZkdHQ1MwUElOT1RjUVJFWENPcm9hejFW?=
 =?utf-8?B?emZ0bXVteVZWN1RkaHM1M2pjbTU2bU1DSTJadzUrbzBlSTFHRmhnL281SjNn?=
 =?utf-8?B?Z3Q2YS8zb2Vqb2p6aFlzUTFPQ2hUcWZ5dDk1MXZjd1ZueCtIckxqMVZEU2hE?=
 =?utf-8?B?RXRiQ2FoUlVkcytiaXBTWGljeXM5Qm93ZGFvQnFiWjJyUnBoR0NsTUNvN2lZ?=
 =?utf-8?B?WHRlcVZVVklzc2N0V3dIWmI0aWtQckVZcGY0SnJLU050eDl3Um5NdUFRRXZq?=
 =?utf-8?B?MFpmbGcrcWRONmM1NXVBL0IzVkp2anJiaHdSNXhWaW5BVHhyUlIxMW5mVFNC?=
 =?utf-8?B?N243ZXNVM0ZqcVlnd1NmZVkzMThLclIwOWREemVVcXhwUUE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Njkrd2hnT0lPQVhaMTNMRGhQc2VyWTUzbjNwbHl0ZUNwV3ZJU29rdmJmUnQ5?=
 =?utf-8?B?dWlUZEwyaDlKR2MvRk5QRFc2SkpQZXM2dS9OSDhHTXlpTGdwWmYvcnpWdDhp?=
 =?utf-8?B?ekE5LytaRGdsSEt0dkpXSVFPVlBVc0NqSFNCM0ZDTmFvUE9ZTTBWM1VOOFlT?=
 =?utf-8?B?VkE3U3RWbkNLb3c1WGRXZjlPTGlQUFlreW9VMkVubzZISmhQdU5LbmphcC82?=
 =?utf-8?B?SkkwMlF2UThsWUxxREo5QW1qelpoS3BFeGZScWRXN3hQcmliYjMwaklZWkNv?=
 =?utf-8?B?V1U2cy9UVzQrb3E4eEJkdHFTSWQ4cFJKeXBWSlRsL2x6VlBlbXpQSENZRFVZ?=
 =?utf-8?B?UmJmWENaRHNXVjd0MGVaNDJxYlNpUHpjNVR2SnBmMFR4aHczVkhPSVg4UDJC?=
 =?utf-8?B?UHN2M1ZPVHpmWlpGUnhvamRORldaUmRJMi9tbHB6OTVvYXRDN3dVQlFvYzNB?=
 =?utf-8?B?MVFVaUE1aUpDZmR0OFlhRHJXaXU1bThycThXYTZuWHR4cXIwdFZIRDVzS3l2?=
 =?utf-8?B?OFM1TE56b0g2ZGc1N3FaRjZuVXNtWjFhNTQyMzR2Mm14NXlkQlRtck56ZTVS?=
 =?utf-8?B?UHU1VXEvUHp3WTNEMHQyTElINFpDdW16NnhkVmJVeDROeUZtek5KYm5ZdFJl?=
 =?utf-8?B?dlJ6V0VKUjgxQ0NBak16dXA0MTJnbUJwa3BnTExzdTBFQkh5MjU1dndvWkw4?=
 =?utf-8?B?bHE0b3VoUEVqSGNMMHZOVHVHMkgwRThXOW50VEZmTXVHLzNUNzNDMGQ5Uita?=
 =?utf-8?B?NnZ1TGtoQVh4NXRXU0oxaEF1NDQ3ZWJLRmNPbmJuZ2pRbDJUZllvWHZKeGhV?=
 =?utf-8?B?TGFkVWF3YVFDZ285Rkp0aXFWU2JRU0VHODBLVGlubmY3ZExDSm5QcWR5bXpN?=
 =?utf-8?B?WmVGdVVIL1k1MGQ2SjRrak9WaXUxQmthTDQ3WUZROVBDZGVtbyttVUY5ZFdT?=
 =?utf-8?B?eVN3TDUwcFNmSHppL2V6bWVRaEJwQkxVZjBEZnN2eE9rc09IeEp4dndOQlU3?=
 =?utf-8?B?VmJidER1a01sT2xOV0RCZlVSbjd5TmU2di9XV3Vxdm51bzFUQzIxWUkva01O?=
 =?utf-8?B?ajRwWmZyaC8wWnJyaFlJUitIZGpZbG5kYjcrYzV4K2Z2T3VaS0FtYllnYkxD?=
 =?utf-8?B?SDkvWEQvcExmc0NoeCtMSGl5aytlWGt1WXVYbHJZbUJQdU5wdEs5b1NRMFhJ?=
 =?utf-8?B?ZDg1UndoTUx5cFVmS0NGYTR6KzV2RGY0cWR2a3JXbFVHNjlUVXk3a00yMzdP?=
 =?utf-8?B?UlJDbHhPZkxsYmFpVytCTzBZNURPRTREVGpEK3YvQUZyZmpIOWx6MGtJaERx?=
 =?utf-8?B?dFZWUURzRFV0MUZpY0F2M1BkZFQvUzhZT1ZCV0Fsakw3eVd2TzZsdEZuU2pL?=
 =?utf-8?B?YlFXL1MvK0NQVzNGTEZzVlFuelRqcDJMeit2dDdYaHk0Zzh0cEdCTkxtczk5?=
 =?utf-8?B?VFZDcTdjSitNMGdiRXdjUFVzL2dKSloyR0twTGxjMitDb1BTdkZxY0ZqUDI3?=
 =?utf-8?B?eTVHcVNnck1CNDVpWnB5OThJWGJZSjI5TTlwenVEZ3A2SHRqaXRQc290SmRw?=
 =?utf-8?B?cHk5eWV5T1VYdm9BMjV0WmtiTS85MjRESUozR2U3eHpURHZHSHd4TzZ2WE9u?=
 =?utf-8?B?aHd5UkRYcjVBK2pTU21wY29RdXFqZWRTcjV6TDVpNnl2bzJ6V1hkNGxGSGZy?=
 =?utf-8?B?VjI3Ui9xRzQ3cWJhZDFnd29QYWF0aXQ4aE1YU3ZaRnhnQ2g4NklNUnRydGNJ?=
 =?utf-8?B?YlhCMFhJeHpXNklLOEt6Z3ZGejNTWXJpb095WUVrSVpCcmt3MlNNWWNEUHYv?=
 =?utf-8?B?bVM4dDdIMXpkcmducUFjSHRMaVV2a2Y3bDNraENsWFh4eXZ0cUhQNkY4bWpj?=
 =?utf-8?B?ZWI4UU02QmlHNHJrOVdlVmR1QVByV2M3YTR3MHcxdTFrK2R4b01FclhmcGxS?=
 =?utf-8?B?MGxRaENCeGVUSmsyNlNES1pOSVhkVEd1M1Y2YWFndnA1MWVFemFZTjlaRVVT?=
 =?utf-8?B?SExhSUVXZk1OK0NBTWxaWERFLzMyM0NuZzkzdXJNZ0RZa2NZU0hiYVRIdkxm?=
 =?utf-8?B?REhlMHI3bXRySHMxenFQemhEUmJZT0lEVVFVbkJDYUlMbTl6Y1JtdVluSGcz?=
 =?utf-8?Q?Qq9O3e5NbcmQy2BHmS1132QhU?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 999bf004-2f46-43e7-2b9e-08dcdb981c11
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2024 06:22:33.2121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JzeOIYkawOZmJGZnZacQyMD1DfMwU0XL/pSCeTOtpeljAv7NRbWSIJl9w6Jv/+AcPw9fjXukuyz7x7ejRpvFag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7173
X-OriginatorOrg: intel.com

PiBGcm9tOiBaaGkgV2FuZyA8emhpd0BudmlkaWEuY29tPg0KPiBTZW50OiBTdW5kYXksIFNlcHRl
bWJlciAyMiwgMjAyNCA4OjQ5IFBNDQo+IA0KWy4uLl0NCj4gDQo+IFRoZSBOVklESUEgdkdQVSBW
RklPIG1vZHVsZSB0b2dldGhlciB3aXRoIFZGSU8gc2l0cyBvbiBWRnMsIHByb3ZpZGVzDQo+IGV4
dGVuZGVkIG1hbmFnZW1lbnQgYW5kIGZlYXR1cmVzLCBlLmcuIHNlbGVjdGluZyB0aGUgdkdQVSB0
eXBlcywgc3VwcG9ydA0KPiBsaXZlIG1pZ3JhdGlvbiBhbmQgZHJpdmVyIHdhcm0gdXBkYXRlLg0K
PiANCj4gTGlrZSBvdGhlciBkZXZpY2VzIHRoYXQgVkZJTyBzdXBwb3J0cywgVkZJTyBwcm92aWRl
cyB0aGUgc3RhbmRhcmQNCj4gdXNlcnNwYWNlIEFQSXMgZm9yIGRldmljZSBsaWZlY3ljbGUgbWFu
YWdlbWVudCBhbmQgYWR2YW5jZSBmZWF0dXJlDQo+IHN1cHBvcnQuDQo+IA0KPiBUaGUgTlZJRElB
IHZHUFUgbWFuYWdlciBwcm92aWRlcyBuZWNlc3Nhcnkgc3VwcG9ydCB0byB0aGUgTlZJRElBIHZH
UFUgVkZJTw0KPiB2YXJpYW50IGRyaXZlciB0byBjcmVhdGUvZGVzdHJveSB2R1BVcywgcXVlcnkg
YXZhaWxhYmxlIHZHUFUgdHlwZXMsIHNlbGVjdA0KPiB0aGUgdkdQVSB0eXBlLCBldGMuDQo+IA0K
PiBPbiB0aGUgb3RoZXIgc2lkZSwgTlZJRElBIHZHUFUgbWFuYWdlciB0YWxrcyB0byB0aGUgTlZJ
RElBIEdQVSBjb3JlIGRyaXZlciwNCj4gd2hpY2ggcHJvdmlkZSBuZWNlc3Nhcnkgc3VwcG9ydCB0
byByZWFjaCB0aGUgSFcgZnVuY3Rpb25zLg0KPiANCg0KSSdtIG5vdCBzdXJlIFZGSU8gaXMgdGhl
IHJpZ2h0IHBsYWNlIHRvIGhvc3QgdGhlIE5WSURJQSB2R1BVIG1hbmFnZXIuIA0KSXQncyB2ZXJ5
IE5WSURJQSBzcGVjaWZpYyBhbmQgbmF0dXJhbGx5IGZpdCBpbiB0aGUgUEYgZHJpdmVyLg0KDQpU
aGUgVkZJTyBzaWRlIHNob3VsZCBmb2N1cyBvbiB3aGF0J3MgbmVjZXNzYXJ5IGZvciBtYW5hZ2lu
ZyB1c2Vyc3BhY2UNCmFjY2VzcyB0byB0aGUgVkYgaHcsIGkuZS4gcGF0Y2gyOS4NCg==

