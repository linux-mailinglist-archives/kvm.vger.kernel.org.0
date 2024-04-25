Return-Path: <kvm+bounces-15901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 340B48B1ECC
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 12:08:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FF1A1F25AFD
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 10:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C3E584E0D;
	Thu, 25 Apr 2024 10:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CcCAFepX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF91584FA9;
	Thu, 25 Apr 2024 10:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714039669; cv=fail; b=G85Eq4068OfBE+ifziNlh2oRitVKN+uT7gkXt64JWR48owPslGc3Kg+ZFGa6hY3opdpseA2vw6zx0lcwhCrWrOJyDtvBEg5dgqVGk4njFoBwSPuE3k05FK4FA60OrzKBDY4ltz/NkMc/s4YjyVNTjtsDobK2E6O51uR1wS5Lkg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714039669; c=relaxed/simple;
	bh=IV0H7XXoG8W0RRtz+gy/bAzLyXcGL9ISdX+nX41/6As=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BAw3sAANR6CvAcDbU5RYzf18qQBXB+OnDMBO6tV4fy2Thg6hDb++XUV3CJscCTycRlSt8ont4Be1gPIE7j5EvaLHGZke3OPdGvLPBrzAk9HPH2bysRhlTurijHzWQWH4s3ztoQtLDCHmMC7FVO6yMKZfWzmpWpsJ+JvHGiwyF4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CcCAFepX; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714039667; x=1745575667;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IV0H7XXoG8W0RRtz+gy/bAzLyXcGL9ISdX+nX41/6As=;
  b=CcCAFepXAEBmm4gO4KGCoGu6wGe9tXZ3+vhu26BYmyt4E3pxk5IUQ64S
   yI/j/aWFFdcQ2+6PfS1EtxjkOumE9F1pxxeQF1lrb77bhfZ/H5EwNT936
   ZLUidDl7mqL/aCQhGVEsBrpnyw2Be6aDUf7M9G2Ev8I9g42aNGzJNi7Oo
   YY2o2800tayujRcm5Sh7asmkoFozQFuNZN9TSDBH/+vLiguJZHi7ONkGZ
   8Bl0ccF/21h5AsjMPW6CMTMJE1Wwy/+VrZv2nvFihu2WXUt8A3K2KDVZh
   X7KTnpYtF4DqyClrDEXUwga2/FfWSnG/mhekMDWmEyyZGwYGbomHtHP+m
   A==;
X-CSE-ConnectionGUID: rygyMM0sS2WhaT6lhtQNlQ==
X-CSE-MsgGUID: HNENX95MRjOEV1hz5b4Prw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9564663"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="9564663"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 03:07:47 -0700
X-CSE-ConnectionGUID: C8giTD4wSdOg5IPlCOa0HA==
X-CSE-MsgGUID: 2zB7fb9YR9qVaeq2VuQIaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="48286002"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 03:07:47 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 03:07:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 03:07:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 03:07:46 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 03:07:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DETHdqa5v39DOUPEEEwjwsph/Vpq4/sWmDTKjguuzU4MZdVMAAx5COIE9P7o/dIpi8bR2qlfle7BKU2WyIIUGGHjqt9ADKqohhv8HIHW89I0ASWvd/Rqjs2rQ+l5ALwzJlTmIVxJaJZm03FZA/fYM8LQfAwR7dXN3QytvMSg4/vKv9DhpSqCpXD54RrJbs6DLU9wrz5wK75O0AInk/92x9oBv9KCh+s7oIGjSYmD2YlwUGiz3+RB+zJ4rhLFMiAWfjZNLUyBA6JO+/DmxzOKXMhlk8eeeGAYDE79HND2ZR7mSCPnBMf6WqPSVqpzeZftgpmszhwOezPyx0TOMODaqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IV0H7XXoG8W0RRtz+gy/bAzLyXcGL9ISdX+nX41/6As=;
 b=TXfgbTM0D/Sp9+Ha4btEbjiE3mOnQ+AZilp2nk6qNlC/0MjOvXcyLlkeO59mB0KfxmKOqsbpVVUszw6Y9FixNycGwYX+DHOmpRrBrw9108O7gASbJX7fxcn6JM1/hRxBdVAP10R5TggVZ8kwS7bzAOSsGg8lXsYBf50QBcq92E7OSVajb7Xg14yOSbYJY+DiYRCRU0nCZT4Cxhs9gnWn3QSvrOC5bTAdPtlAY+MpHYpyXC/hD08r5JjeXgO/I3/GrEoXqJywcp7kW/r669xE+v3fRhk4LTftuSqS3IZaJPApP913uF/W6I9T7qK2zmRBcIR+s+pv95qKg20oeJwkWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB7306.namprd11.prod.outlook.com (2603:10b6:208:438::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.23; Thu, 25 Apr
 2024 10:07:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 10:07:43 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: x86: Explicitly zero kvm_caps during vendor
 module load
Thread-Topic: [PATCH 3/3] KVM: x86: Explicitly zero kvm_caps during vendor
 module load
Thread-Index: AQHalZ7v1+lFvpoeBUe2ws/CuIZWqrF2wu+AgADLZ4CAATc7AA==
Date: Thu, 25 Apr 2024 10:07:43 +0000
Message-ID: <c588e1a7bfeab64e15c093f276bc006a70a023a3.camel@intel.com>
References: <20240423165328.2853870-1-seanjc@google.com>
	 <20240423165328.2853870-4-seanjc@google.com>
	 <8e3ad8fa55a26d8726ef0b68e40f59cbcdac1f6c.camel@intel.com>
	 <ZikmVzsvV-tt_pSs@google.com>
In-Reply-To: <ZikmVzsvV-tt_pSs@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA0PR11MB7306:EE_
x-ms-office365-filtering-correlation-id: fb71c298-5a67-43e3-4658-08dc650f8c73
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?ZkUyaTBMNkQrQXJEWG9vcEFJTWtVakJqeTlFV0dYcWtDN3NmM2RvbWJGQVlv?=
 =?utf-8?B?ZEluaHVoWHZEanpyRHh0dHI5VFl1ZUU1cWFFV29QWStYSUl3cHk2OW4xWldu?=
 =?utf-8?B?OGcvTG9tL1BOZklYU3pHNXI3NWtvQmpvUFBuY3c5REl2N29WMFg0b3VJSnVu?=
 =?utf-8?B?NUthVlhJU29pY1ZxcTN0R2NnVXhla3R1WFVkSFN2U3VtYmN5UkNqcWtwQ0NU?=
 =?utf-8?B?T1phekRremt3d01TK3Jib2RpVFd6bm1zSzJXK1hVNlk3amh4WjVVRjY1eVFW?=
 =?utf-8?B?ZUJBK2c2UVFMdE1sR3NzV0p6K24wTjR1RkpjTDUyRENSd3Z3V0NoZHVNTzBt?=
 =?utf-8?B?UFNLYjRZSGpYRk14UWJIRmV3Y0oyby9TTWhGWHdSRmpVeXltOS93blF0QS9l?=
 =?utf-8?B?blFDcE4vN3F1Rzk2b3BBNTRBUjJaY3E0VWlWQ2pmZUt1d0ZFU1VpSkRkcXRh?=
 =?utf-8?B?L2toT3BwTkVZWUtMQ0RCOGZVT1pDRFNIZmVjMHpoRVFnR0RPWkFacTl6bU5D?=
 =?utf-8?B?Wi92M3N5Mno1bUlZRVcwNVJyeUF2cUZVeFg1RGd5b3dIWEF5aE1tV3JLdGw5?=
 =?utf-8?B?dTV6aURGUGROQzBMSHRsVHFGaGwzMkRhR0RHRmxibUgxU2lnNDR5eS92TkJS?=
 =?utf-8?B?WEh1aXNlbWVVeE9JYzFTY2RHY0pXRmNuTnJkQ0FuRTBsbFI1S0lIQjAxR2dE?=
 =?utf-8?B?OUxWQWEydUo1Tnp6Y2s2THladXFWbjlLZ0JEeEVWT2FTaDFyUWFOK1lWUm1p?=
 =?utf-8?B?YWsxcTFqRXc5V0tJMGUzL0p4U2haV3NZV0RDNGpEZHlkSmFJRmh6UFZRY3Vo?=
 =?utf-8?B?Y3Rpc0lSVWhBSzRZa2I4SmxMSU1WeGUvMEZrTlZFMUR4MWViRHJ0NEdwMHZ4?=
 =?utf-8?B?bU5Scnl1RlBLaWprcXc0S0RkQUhQWnAxanh6MGd6M1dkUXNlWnZnMnhabjY1?=
 =?utf-8?B?VXRvTnBEOFp4VnhpY3lhV0taS3dxZWI0akx5SjcyaWtmSmtTRUt2bDZ0ektN?=
 =?utf-8?B?c2VNODF1NTVmZkNkZkRlNWl0N0ZSSnBGcEtVWVpGdllFZUJIekQ4UHJXcnJW?=
 =?utf-8?B?TU9wdlVxN2FJd3pXbXdWL01INStLbWVFZlNmSnh0UTVUYU9HYThBVzhCZUFk?=
 =?utf-8?B?WS9mZkpzL0ZBQThYaEl0cEFWbE14VzRJcDF4SDVVRzQzWFNQS2ZHNXdOdzIr?=
 =?utf-8?B?L3pUOFFyZnFqdzVobGpwbEcxMCt1Y2lGV0tYZTJxTHJGVkFuUi8vVFE5NmV1?=
 =?utf-8?B?ZUlTT3Bzd1RTTDMrcnh5ckpweXVlSkJ6cm5jMDFtcFBEWnppanhxcUVCdldy?=
 =?utf-8?B?TFN2eVlCUG9LUVV6MG4xWWZLRUJIdHpCdjlmQWhxRDBUdThuY21GR2ozb3Av?=
 =?utf-8?B?bFhvV3B6MTVXU1ZVMDcwNFNxOFR2ZkkvdXpqZ2hDT0Qvck9XSzBpM3A1UXRT?=
 =?utf-8?B?TlVrd3Bwc2oxeGhHTnM0S3lGTXEvRW9LaDVJWkFNdHVSTXV4RGZHRUsxRVlG?=
 =?utf-8?B?d3Y5YmpObHM5dGdrT0hXNUdjalR2aHI2YnhBSU1EQ2Zod2F1bHQ4L2NxR3Br?=
 =?utf-8?B?eUlQWXFOZ1dOdEFkZytmaS9lME1mSmlaNEF2bVlsL0E1QWNuS05ZZmdXOE1t?=
 =?utf-8?B?UzlRVXY3ZGFMYnFqTmpySzcweWhLN0VEWWw4UCtldHQySy9ocDFIR0p2RjZ1?=
 =?utf-8?B?TjBia2N4dlRyL0s2NzM4LzBaR240dE0xWnhBM0pCbUE0N2VGRnoxY3pkZjc5?=
 =?utf-8?B?TVZQTWg5dEpDUmFscFhRM2FqMmlWVDAyVWZ6MVJUeXk4NVZGUTFJWExDV25o?=
 =?utf-8?B?THZKZ3lNQ0dwNnF3MzlDQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXFZRGdSa2FKRVZ2TlNIbUttcjVzMkhhZU5WaXFQWVdEd09qY0ZSdWQ4a214?=
 =?utf-8?B?L3Nqb2JtOUhtVmtZRnJNTnNTZDU1ZXNuSjEvNnU4MzB0Q2piN043THVkOE1P?=
 =?utf-8?B?M2Jxc1VvOGdGMXJ0U2ZTdzRKbVQ2M1YvOE85RklRR1ZFSTBYYmlzS0dVVmly?=
 =?utf-8?B?VnNsUGpXdi9zWlJTSzROazJzUDBkcnJhVEdBdS93QmIvaU1SZ0hENzFXOUlY?=
 =?utf-8?B?bmo0MFlRT1J2YXVBaXFDbjBVTjB4MzdzcTQ2UUM0MXJrTEtVZHFNUGtSc3Rm?=
 =?utf-8?B?cUpxNk1SNWtVTXdvQm5sYy9yT3RCOGNqaUpxSVQxS3Rldnh4Z2tVKzViSFll?=
 =?utf-8?B?SDVwUU9Oa3VFSzZjWUF4NGZFbmhtTloxWlp6LzNQUmZqai80OExLVmY3ekQ4?=
 =?utf-8?B?RkU4d0ZXZnVEQXk5ZzJ6NXBia3hmWUg2eUdMOWtnNTJSTVFYWmkyckNZMU5w?=
 =?utf-8?B?TE54UUFCYVpyMWxRcDM0c2RlNVVML0tIdUNCZk53WmtXalFUUGVISjF2aDFa?=
 =?utf-8?B?QmFzR1R5ci9VV0pFWG8rT1dJYzdJWHhyQjBmeUFCRWlENDhpK0dJMU0rNDBB?=
 =?utf-8?B?T0FRUnp1bE5RT3JOK2NmZ2dFbjVHeWp1SjBTUmlpOHozVmFqWHZ2bGtrblNK?=
 =?utf-8?B?RkZINmJLZjM2anlCOEVDeWlyVWpRUHVnQ0o1MjFKSUFDRjZ3cnNkaGxQNStt?=
 =?utf-8?B?VHkyaEZBbHRNRm9CWmJHM2xjSDNEMitmaFAwUFkwdURrV3V3N01oVXBQYWZI?=
 =?utf-8?B?V094bzI3c0Ricm5ZeUw0VStzWWFYUGNDRGQ5aTZZK0t2a1FpSFBQTHU4VDFD?=
 =?utf-8?B?RzgvK1RxK3hOR3VMaE8zU0UveExHcXp1OGsyK2U4bHV4MXRxZjE3a3Jvc1k4?=
 =?utf-8?B?aVFYajhuN3BiL3gxdEZQR0w1a2RHTHJ6UTNDaTAxQ2xTZjd2RlRZdU1mMThi?=
 =?utf-8?B?enVQdUNsMmh0a0FKWi9SVXR4MnB1eVlJNDFXOFdEVFl3RnhZalpCQ0o1OFBw?=
 =?utf-8?B?YytKTjFVUzFUa2tCTjY3aFpRWFVkS0g4YkJZd3k3b2dNbWdxb201UUZFSG9m?=
 =?utf-8?B?bnpmdElMYk9QTTlxZlRwYmlvM1hCUGsvV3MrYmJHdUlXbjRhc1hrdVgwaFM2?=
 =?utf-8?B?Y0ZrdUVkaFdDVFBDUU5WQjJ1cVVnVHpjTHNGMmpOUHlBNGNtQ21nd2dRWlQ5?=
 =?utf-8?B?WFE4N003VmNVdDlibFRmOU4yZ1JGVFFaSUpLTkozdHovMWFPSFBpNi9jbnQ4?=
 =?utf-8?B?MVFnbVNHaDZhbE1Ma2JGRkRaNjBSS2RhOFBjUEdvQjVlQVBjSEhZSjYzMFRj?=
 =?utf-8?B?ZUVQZVBUS3dhWmZ5Tk1uV1djSXlJV2FyZ1ZJMTg1WEowMVBIYW4wSjFjMlY1?=
 =?utf-8?B?TnI1MzhDQnZTSU5lM0hqQXRrN29LenhSQmJjRktOUXVkNFdabXVBS3hXYnZa?=
 =?utf-8?B?dzVOdWdjZkxOSHZ2RWcyNlYrVU9tcTR4NUc5M3NwV2VYNXBnNEtHeEpNSGFV?=
 =?utf-8?B?dFRVb3pFNE80a2lib1pqREdYdWF1NUJTL2VzU291RUxTam4rdEovY3V4ejdE?=
 =?utf-8?B?UkVrT01rUzQ5S1lxMzlQWXNtSDFUd3FsUWU0L1pFRHI2Y0FSM0pNL0g3TXVY?=
 =?utf-8?B?MnFBRGwvUjFGT2JaNGxVaGgyNXJpbXZzMEplRUsrb3FFT0tXUEJndGpyQjJi?=
 =?utf-8?B?bENPZUZBWi9wcmh4dmlEbFRjWURBMVpHQTRBMlpmcHB0d3JHWlAwUk5pSytX?=
 =?utf-8?B?T0JyYnBPVk9DekJLcnE0TVBmT2VTVTJTTCtSZnFpcmYrREVFd2paRUlPdTJX?=
 =?utf-8?B?Z1Z0cG43NTl6M3ZHSnB3M2EzYWR6TGw4a29iYUFvazZuK25hVFdKaThPdXRK?=
 =?utf-8?B?MnQxMkw1aGN6b2hGSnpBY2ppRlVFNnNnckZLVXZOQmxQOUp4N3AycWRKS1ZN?=
 =?utf-8?B?Q0ZPWEhqT2VKMUZlVnA3SXMzNVJza2IyRWRYWDkydEJ3dmNHK0ZBY1FLZ29Q?=
 =?utf-8?B?YTJ2aDVTb0lBNTcxYXI4dWlia25DdGJjNHYzQ0l3QXhiRXRSZ2ZmbWw0RHVP?=
 =?utf-8?B?YWtHeGxnM1RiWjBvU2ZWVzhaVUYzUlhPamFNRFJYN0MyZjAzb2p2RUhoaE1v?=
 =?utf-8?Q?/UJLT6XAkMwHD/n+un83soyET?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B70CCA266BB05B49A73C4FD0202D4949@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb71c298-5a67-43e3-4658-08dc650f8c73
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 10:07:43.4811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0vjYzSZ2FaH3z32cAtwwLJ3KzCMMeDcvLQk8x9Que9ouf90xIqW3XJLPfYk1HD3M7G5zxAWSWpwW5Zk4A87S6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7306
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTI0IGF0IDA4OjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEFwciAyNCwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFR1
ZSwgMjAyNC0wNC0yMyBhdCAwOTo1MyAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IFplcm8gb3V0IGFsbCBvZiBrdm1fY2FwcyB3aGVuIGxvYWRpbmcgYSBuZXcgdmVuZG9y
IG1vZHVsZSB0byBlbnN1cmUgdGhhdA0KPiA+ID4gS1ZNIGNhbid0IGluYWR2ZXJ0ZW50bHkgcmVs
eSBvbiBnbG9iYWwgaW5pdGlhbGl6YXRpb24gb2YgYSBmaWVsZCwgYW5kIGFkZA0KPiA+ID4gYSBj
b21tZW50IGFib3ZlIHRoZSBkZWZpbml0aW9uIG9mIGt2bV9jYXBzIHRvIGNhbGwgb3V0IHRoYXQg
YWxsIGZpZWxkcw0KPiA+ID4gbmVlZHMgdG8gYmUgZXhwbGljaXRseSBjb21wdXRlZCBkdXJpbmcg
dmVuZG9yIG1vZHVsZSBsb2FkLg0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENo
cmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGFyY2gv
eDg2L2t2bS94ODYuYyB8IDcgKysrKysrKw0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2Vy
dGlvbnMoKykNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94ODYuYyBi
L2FyY2gveDg2L2t2bS94ODYuYw0KPiA+ID4gaW5kZXggNDRjZTE4N2JhZDg5Li44ZjM5NzlkNWZj
ODAgMTAwNjQ0DQo+ID4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiA+ICsrKyBiL2Fy
Y2gveDg2L2t2bS94ODYuYw0KPiA+ID4gQEAgLTkyLDYgKzkyLDExIEBADQo+ID4gPiAgI2RlZmlu
ZSBNQVhfSU9fTVNSUyAyNTYNCj4gPiA+ICAjZGVmaW5lIEtWTV9NQVhfTUNFX0JBTktTIDMyDQo+
ID4gPiAgDQo+ID4gPiArLyoNCj4gPiA+ICsgKiBOb3RlLCBrdm1fY2FwcyBmaWVsZHMgc2hvdWxk
ICpuZXZlciogaGF2ZSBkZWZhdWx0IHZhbHVlcywgYWxsIGZpZWxkcyBtdXN0IGJlDQo+ID4gPiAr
ICogcmVjb21wdXRlZCBmcm9tIHNjcmF0Y2ggZHVyaW5nIHZlbmRvciBtb2R1bGUgbG9hZCwgZS5n
LiB0byBhY2NvdW50IGZvciBhDQo+ID4gPiArICogdmVuZG9yIG1vZHVsZSBiZWluZyByZWxvYWRl
ZCB3aXRoIGRpZmZlcmVudCBtb2R1bGUgcGFyYW1ldGVycy4NCj4gPiA+ICsgKi8NCj4gPiA+ICBz
dHJ1Y3Qga3ZtX2NhcHMga3ZtX2NhcHMgX19yZWFkX21vc3RseTsNCj4gPiA+ICBFWFBPUlRfU1lN
Qk9MX0dQTChrdm1fY2Fwcyk7DQo+ID4gPiAgDQo+ID4gPiBAQCAtOTc1NSw2ICs5NzYwLDggQEAg
aW50IGt2bV94ODZfdmVuZG9yX2luaXQoc3RydWN0IGt2bV94ODZfaW5pdF9vcHMgKm9wcykNCj4g
PiA+ICAJCXJldHVybiAtRUlPOw0KPiA+ID4gIAl9DQo+ID4gPiAgDQo+ID4gPiArCW1lbXNldCgm
a3ZtX2NhcHMsIDAsIHNpemVvZihrdm1fY2FwcykpOw0KPiA+ID4gKw0KPiA+ID4gIAl4ODZfZW11
bGF0b3JfY2FjaGUgPSBrdm1fYWxsb2NfZW11bGF0b3JfY2FjaGUoKTsNCj4gPiA+ICAJaWYgKCF4
ODZfZW11bGF0b3JfY2FjaGUpIHsNCj4gPiA+ICAJCXByX2VycigiZmFpbGVkIHRvIGFsbG9jYXRl
IGNhY2hlIGZvciB4ODYgZW11bGF0b3JcbiIpOw0KPiA+IA0KPiA+IFdoeSBkbyB0aGUgbWVtc2V0
KCkgaGVyZSBwYXJ0aWN1bGFybHk/DQo+IA0KPiBTbyB0aGF0IGl0IGhhcHBlbnMgYXMgZWFybHkg
YXMgcG9zc2libGUsIGUuZy4gaW4gY2FzZSBrdm1fbW11X3ZlbmRvcl9tb2R1bGVfaW5pdCgpDQo+
IG9yIHNvbWUgb3RoZXIgZnVuY3Rpb24gY29tZXMgYWxvbmcgYW5kIG1vZGlmaWVzIGt2bV9jYXBz
Lg0KPiANCj4gPiBJc24ndCBpdCBiZXR0ZXIgdG8gcHV0IC4uLg0KPiA+IA0KPiA+IAltZW1zZXQo
Jmt2bV9jYXBzLCAwLCBzaXplb2Yoa3ZtX2NhcHMpKTsNCj4gPiAJa3ZtX2NhcHMuc3VwcG9ydGVk
X3ZtX3R5cGVzID0gQklUKEtWTV9YODZfREVGQVVMVF9WTSk7DQo+ID4gCWt2bV9jYXBzLnN1cHBv
cnRlZF9tY2VfY2FwID0gTUNHX0NUTF9QIHwgTUNHX1NFUl9QOw0KPiA+IA0KPiA+IC4uLiB0b2dl
dGhlciBzbyBpdCBjYW4gYmUgZWFzaWx5IHNlZW4/DQo+ID4gDQo+ID4gV2UgY2FuIGV2ZW4gaGF2
ZSBhIGhlbHBlciB0byBkbyBhYm92ZSB0byAicmVzZXQga3ZtX2NhcHMgdG8gZGVmYXVsdA0KPiA+
IHZhbHVlcyIgSSB0aGluay4NCj4gDQo+IEhtbSwgSSBkb24ndCB0aGluayBhIGhlbHBlciBpcyBu
ZWNlc3NhcnksIGJ1dCBJIGRvIGFncmVlIHRoYXQgaGF2aW5nIGFsbCBvZiB0aGUNCj4gZXhwbGlj
aXQgaW5pdGlhbGl6YXRpb24gaW4gb25lIHBsYWNlIHdvdWxkIGJlIGJldHRlci4gIFRoZSBhbHRl
cm5hdGl2ZSB3b3VsZCBiZQ0KPiB0byB1c2UgfD0gZm9yIEJJVChLVk1fWDg2X0RFRkFVTFRfVk0p
LCBhbmQgTUNHX0NUTF9QIHwgTUNHX1NFUl9QLCBidXQgSSBkb24ndA0KPiB0aGluayB0aGF0IHdv
dWxkIGJlIGFuIGltcHJvdmVtZW50LiAgSSdsbCB0d2VhayB0aGUgZmlyc3QgdHdvIHBhdGNoZXMg
dG8gc2V0IHRoZQ0KPiBoYXJkY29kZWQgY2FwcyBlYXJsaWVyLg0KPiANCj4gVGhlIG1haW4gcmVh
c29uIEkgZG9uJ3Qgd2FudCB0byBhZGQgYSBoZWxwZXIgaXMgdGhhdCBjb21pbmcgdXAgd2l0aCBh
IG5hbWUgd291bGQNCj4gYmUgdHJpY2t5LiAgRS5nLiAia3ZtX3Jlc2V0X2NhcHMoKSIgaXNuJ3Qg
YSBncmVhdCBmaXQgYmVjYXVzZSB0aGUgY2FwcyBhcmUgInJlc2V0Ig0KPiB0aHJvdWdob3V0IG1v
ZHVsZSBsb2FkaW5nLiAgImt2bV9zZXRfZGVmYXVsdF9jYXBzKCkiIGtpbmRhIGZpdHMsIGJ1dCB0
aGV5IGFyZW4ndA0KPiBzbyBtdWNoIHRoYXQgdGhleSBhcmUgS1ZNJ3MgZGVmYXVsdHMsIHJhdGhl
ciB0aGV5IGFyZSB0aGUgY2FwcyB0aGF0IEtWTSBjYW4gYWx3YXlzDQo+IHN1cHBvcnQgcmVnYXJk
bGVzcyBvZiBoYXJkd2FyZSBzdXBwb3J0LCBlLmcuIHN1cHBvcnRlZF94Y3IwIGlzbid0IG9wdGlv
bmFsLCBpdA0KPiBqdXN0IGRlcGVuZHMgb24gaGFyZHdhcmUuDQoNClBlcnNvbmFsbHkgSSBhbSBm
aW5lIHdpdGgga3ZtX3NldF9kZWZhdWx0X2NhcHMoKSwgYnV0IG9idmlvdXNseSBubyBzdHJvbmcN
Cm9waW5pb24gaGVyZS4gOi0pDQoNCg==

