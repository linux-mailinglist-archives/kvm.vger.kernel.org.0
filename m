Return-Path: <kvm+bounces-54467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8DE7B21A31
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 03:34:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71BD96203DA
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 01:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 414742D8783;
	Tue, 12 Aug 2025 01:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K00yzQEW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A6D2CA8;
	Tue, 12 Aug 2025 01:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754962487; cv=fail; b=Z4z4wlCeoxL/FHE7t+6nJ/jomqCtjIUts/JEQxLi0bWyZhjwcOVxgu8aradB4WzPzwLCAR0piKvswwprMRSJmApCKcGfn5R48DZrly7TDAHU/iCWkmqlMXHbNQ3OJQo4agV3stbWQ6mOOFgm4u9NZlFhWs8w0GncxOHxQbkBBTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754962487; c=relaxed/simple;
	bh=44/DzSUYvIavcoOYgi0cAC4jW6ZKmeZZqkJvczorTzo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pxjlY+yRXynSO1EC7PPgjKF8yBJeil8P4w5Wa3K5xwZ9DTD9WwO8wW6tZ3v4/8zIqiqF99NbeMfvO63bHcDh3RRhUVUcpUNgewV6e/npkHoUGVIaFSLqlm15Hf98PUJp/A03yyyoU8EDbn6Smm6SIPZ5Mw9G/mD4YMoIuSF58Pc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K00yzQEW; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754962486; x=1786498486;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=44/DzSUYvIavcoOYgi0cAC4jW6ZKmeZZqkJvczorTzo=;
  b=K00yzQEWn1bNqlvA+xMAA5KB2gIgqUQm6A8iuuNfL3jWrdLQMPR7TVxl
   edkIjhczR41qpmhicQm+F+Fsm58VkiBPJhTKSQriBNt4w8757O/ZUX/Re
   orgLzcjSeK9Q2Lr5W1Hop83jVrzl0c8C00w9KEf8yDQGxim9O4H5qHZCy
   9tVEZuNtAnsUXp8nxrUUqzcl7oExb+spFLfPPYJk0ek3CGgrArshGUuTl
   D8v/L/CSt66RzdOqMFiI6kQCBDLD4n5HOA2wTcCsIPdOy6yVRNxIVKzdj
   vBZN1TrVYOE+YLQXHJKLhkqM2o4JRTb4ZNx1onOxWAICSNq788zhsNV4n
   g==;
X-CSE-ConnectionGUID: JBqafDWSRNS9oKGJbUNwjA==
X-CSE-MsgGUID: +VdYTyu/TqKEeJJkEKEXGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="56943818"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="56943818"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 18:34:46 -0700
X-CSE-ConnectionGUID: 5YgmVSjXRFWTHbUJ/6SISg==
X-CSE-MsgGUID: plzFPgJ9Spm3wD4PumqiGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171302563"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 18:34:45 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 18:34:44 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 18:34:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.69)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 18:34:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v/yUGi+rD53MS6G97wgMQVHOGacZDCn8LPF1ydZFLwnQiJT2ujga+6DNhnqGDuVDW43QLCsJmvvuWUpLFMH81anuiePNSeS9MZEGih+NzXe9ffQ4q5XMngYJez0Y34lQ++NHHttaEPKjTIoiQutYEfX+nMBpqAQX08wenFdior2mqfoVFtGg1lLwMQz6O+mLdKRYO0JbtBRv+Xp+1J1/lzvVd3SSAbZE4Xs6yGSHTQ7M0G4cpGcciD4FZ1feHVbMoPvzwVh5bkJCELQsHfxRQRsivEAf43QNBauMtJ1cw2IZIgDyKG8Uu9VQr+xb7SfbswQJcsawBEWCjfNx7E2JHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=44/DzSUYvIavcoOYgi0cAC4jW6ZKmeZZqkJvczorTzo=;
 b=K1Fvrs0kz7pE0FZVvsi/kBNvfb/AA/q7PgRvmtqb8JXtTwhh2+g961LtfsjEH/AydZfDdb0zdsombNwM7OGSu7GdJHmJPkcbSMzruMBpuqqf9FHQ5O3WvzNgG7T9WSIOX4dp9hXrOTZKSsdWY9H7tAMBNrZIe8vXedj9apvMtpTit+Z4oqdiBLWuAj3+gaAqae9FVqxxXDbjLSUEGMvI0JVIFQSiEfdCAknn1Qpm7rjXYT4aAjVWGT4hDXUrPLGf8T3aLWZlMsJDmzMQPeNY0xoT8/Adut973e6ncqUaWPG8GrTQC+CKhWh94LZbOU9N/mVyaS5Z9mJvnvFy+udkNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB6494.namprd11.prod.outlook.com (2603:10b6:8:c2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Tue, 12 Aug
 2025 01:34:35 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 01:34:35 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"Huang, Kai" <kai.huang@intel.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"Chen, Farrah" <farrah.chen@intel.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v5 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Topic: [PATCH v5 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Index: AQHb/7s/GFUyxCBlEUe07NNlQFqqxrReRw2AgAALX4CAAAChAA==
Date: Tue, 12 Aug 2025 01:34:35 +0000
Message-ID: <e11de78443cea475030635b4d440803db3e0cf8c.camel@intel.com>
References: <cover.1753679792.git.kai.huang@intel.com>
	 <03d3eecaca3f7680aacc55549bb2bacdd85a048f.1753679792.git.kai.huang@intel.com>
	 <3bd5e7ff5756b80766553b5dfc28476aff1d0583.camel@intel.com>
	 <05ed4105f5cf11a9dd0fa09f7f1ff647cc513bd5.camel@intel.com>
In-Reply-To: <05ed4105f5cf11a9dd0fa09f7f1ff647cc513bd5.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB6494:EE_
x-ms-office365-filtering-correlation-id: e453f7e9-bf18-48b7-a8a3-08ddd9406500
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?NFgwbWlKd3RmUWhJMTk2TEVDem13V1hoazIzbFM2ZWJCblZEdjIxRXpBQXRq?=
 =?utf-8?B?WWZDb00xa0xab240aUc1Uk16MERrSmpLem1ScCt1MWR1eDd3cGl6bU1NdXJW?=
 =?utf-8?B?aFdiVEhSeEVEM2JOUW5LNU0zNzFHRVNWNVl0ckF1UTJTQ3ppdUFmZVB5bllz?=
 =?utf-8?B?Syt6UTg3N0Z3NS9MMDdsUld4YlptUnN1bG9ZYUhGVE1lYjBYeUtpdEdRbUE5?=
 =?utf-8?B?alRCL010MzEzSHUzeXllb2xTSHM3bkF1TXdmTzdQek5qUXhFSmNBWVFBNDRq?=
 =?utf-8?B?cUQySjl4S21XLzlsSFBDTWRYTHZFR0FPQ1NTdmdmUXBRV09aRkU3YjlveHdI?=
 =?utf-8?B?UXZpcld4UmJiRno3Q0FPSnN2cWRRSVF5ZlhHSm5UeThXamxURE4rUUs0OC9O?=
 =?utf-8?B?YmVMTTN2alk3R2ZBdDJYV3V5eW1saDVWMk9WRzVFOG9iN0kwS2JxUFZVWGVt?=
 =?utf-8?B?RUpBc3ZFRzFkeUcxSzVBUnEvV0tPY0FPYVdvQnFGVXIveVNab0FXSURYV3pV?=
 =?utf-8?B?U3ZoUFlnRG12VVdWeCtNb1IvNmhKeUhuaE5pakhGZFRCcUt2T1drczlteW9N?=
 =?utf-8?B?NUhRR0REQUgxZC9EblhGQlc3WnBldnZEcHZnVzlBS0EzYk8xZHlVQkVRMStV?=
 =?utf-8?B?c0xtQ0hGWkhvRzhjTk5kZ1pKV1NnU3lObW4yK0o3YWlsZ0ZWbTdFOUdhVVd6?=
 =?utf-8?B?WmR5YmVwMzREUGlEeHlMR2h2WlRDSGM0dTIyRWlQNzllQWFlMDlBQzNtcE1u?=
 =?utf-8?B?dmhVUDNNRE0xMURGc3ZiWE9Hb29zOW1zRXV6d0VHeVB5Zy83MnluUzVZbENU?=
 =?utf-8?B?cEY1M3FCU2ozcm91emJIYk9pK21tcUNvdW8reUJFbVZ1UXpyZFdma1c3UGVW?=
 =?utf-8?B?aUIyY3hXZlNjVE4wM1RDcGhoeTJBSC91ZU0zTWNvWVZJbUk5MTlGVVYvM1Fq?=
 =?utf-8?B?NjZSTEVqUUljSTBxS3N1Z2s0Z2VXQTJtVWswdlluQWVUU2l6RlNsZjdqSStI?=
 =?utf-8?B?SFlQeXlTZFVhUTBXc2UrU3VzU1c3YWZsaG9mR25IUmdTWUlLWTZ4Rk9iZ3J2?=
 =?utf-8?B?djZlZXZHcEdUSnlCa3h3VDRrbC9URkNnQ0YxNWQ3T2l6dlVFNHdmdDFVeUk4?=
 =?utf-8?B?RGtZRFgxNmhXYzZRd0RydUpiZXlKZVc1UVNLR1BsTzJaQmlkNFk0K0ZhUTFG?=
 =?utf-8?B?b1lTWDR6enAzb2hrc0hrV0cxcHFScWRoWkUvdW1VWmM2Yk9aRm9HTm9DcnZJ?=
 =?utf-8?B?azdzRDRPd0Z0VjFzMStRMVEvN1lIVE4rUi9LOXlCVnJOTHh2a3lkYkxYRFE3?=
 =?utf-8?B?WDAzNmE4ZHExbmFGY1RLcTJEVUNnOWJHYk1Dak9YbmtKTHl3ZTBONEptcEdh?=
 =?utf-8?B?T25mRm9CUEwrdmtyNXMvNWdUOEdUYWdDWEMvaUVPb2JFa0g3REYrd2VHUU0r?=
 =?utf-8?B?SW9BZ2JFTGNSbjcwRTd3UExlQk9HWnRxd2ZFYlA5NGhSVVMybnNsRFdtQnpN?=
 =?utf-8?B?RTFwbFFvVWVwQVFyT1lYSWNRMy9DTDUzYWFXTjJoK2VrNUJnd2NsZUEyTHhq?=
 =?utf-8?B?TUFSemdwY3VsMExpRlcwQzYvOUc5azFienFOd05qMmRydXVOcnlOR2s5a0xs?=
 =?utf-8?B?c2RlajhwVE9hOW5BdmxVMnVYdld5M1pkS1o0bzdnWVpmeDZhSkxUQnNzYWRW?=
 =?utf-8?B?VXlhaFp2MyttV1orWG9MRDNwVm5WVmxsendINVNiN2hnaWR4eU5XWmtrTEZk?=
 =?utf-8?B?TmQ0RmJDQ3FNSDBzYzA1Q1ZiZzNVamN4Q0ZaQVc4WHpzQ2ZqNzdLdHBCdG5I?=
 =?utf-8?B?a1VDQ3FHNVNuYWJ2QnFZbVZuYXVkRnVsc3VoNGdDZlRDZWlsejVZREp2TDZZ?=
 =?utf-8?B?cHJCVFNPQXpKSzl4eWlMQ3VmT2piZ1ArcEw4eVVyYllNeW1hRVVFUlhGbVZO?=
 =?utf-8?B?SHMyQTF1aFlPaXVVUmpEZTYyb2k5YldQSzBpd2N3UFJ6T0NvWmRRMWI5Nklh?=
 =?utf-8?Q?6huD5sgy6t0QP67PuKzxQmPdxV8QxM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXE5MWJJZnhRaHFhUU1UY3M4dm5DYVV5VnRaVGlMUUpWL1JJRWdaRFZqKzZs?=
 =?utf-8?B?WVhlQTV1azF1ZzlHUWU0VHc1WVpoRTFBYVhjU0dmOHZLaWxoT1V5aUdyaUFh?=
 =?utf-8?B?RnhYQWU5c0h1SzNldC9CeUhGaDlBY2FwcDk3d1pwN3p3Zks0Ui9CODZJSHVN?=
 =?utf-8?B?bTBULzJEZEc5dXQwb3V2NnhpSHBrUnNWK1J2Mk9sRjlub0M3eVRzRS9YckpH?=
 =?utf-8?B?NFRUNWlZQk9qUHNIbUtVbzl4aGtTeDA3NHZDS2lOV2JnWG9PcHI4N3VTaUM5?=
 =?utf-8?B?UjhGSDJDMGVZclNtckIyNnNvRU9Ucm80UGQyRnBkdTM1cnJwRCtOWUQ3N3ov?=
 =?utf-8?B?UzBUUFBjOE9XamU2dldVODFnWm1PNkJWVnRRR2U1dDYxYldXU3ZPMFZ5Z3Z3?=
 =?utf-8?B?clVTOWs1NFFUa1hrZEpZNVcybkRhenNoSjBuWG9ONmJXdWozcHIyejRZSWxo?=
 =?utf-8?B?citWd0NuVGxyNFIxTEwrMTE2WmYwMms0T0ZpWXR1eHVkaU5WRmdFWjl5Uk9n?=
 =?utf-8?B?WTRoLy9SeFpCNHhjRlRTNG05c091czh4V1VXMWpBYzBlOG56Tk5vSzcvckhB?=
 =?utf-8?B?alRNU0U3RG1NbERoMUNyaWY1S25iY2o1aEw0ZGI1eVgycDdrelVmQVNjYm5B?=
 =?utf-8?B?d0xVTG5ZcnY0QWpSMkZTcDZsZXcvaG9jTmJ1L0IrbXpUNldmSGg0a09PbWVz?=
 =?utf-8?B?U01saS8xOXJ2MFhNQU1SZzlod1ozWHpPZUZjTnhiT2tQazlYdmFDUEVGblFH?=
 =?utf-8?B?STV4WnRRam5rLzhoSFBNSGVkSkExUEo5ZDZqcDVFN2lrUlRWZXZlS3pYZ3lW?=
 =?utf-8?B?RXdMNm5lNFFuK0J2OGpseGJpcys0eG0wNUVJRE5PM251TTNkaGdoNlhQa2Vv?=
 =?utf-8?B?TVZuUFJvREk3enNJVWhGbzdnRVRDcE9tQzc2c1JmTExkaXlEWGlsVUV0eDRt?=
 =?utf-8?B?cUMzRlQ0WmtmbjRsTDZQQnU4RzVGbVYyVktycm5oNFhlSjBud0k0cFpBdTVk?=
 =?utf-8?B?NDBhYXo4NG5FV2hOS29sdTZnd1U1L3M5TDlnVmRuMWlmTXI1NTF2b1dhMlB4?=
 =?utf-8?B?VFN3ZWZwdVMxYktBTjdYRUg0eDlRcGVSbitVYXJyZGN3alNaK1JBSEp3cXpC?=
 =?utf-8?B?bSs5QTNSQjdUdEg5Y3lNZXVIVDNxaXRJa0Qwd2MyQWN5N0VoOTIzUE5sYlY0?=
 =?utf-8?B?ZVRCRDFHMUFNMTlSZzhhRW9PeCtqWUZTYm5rblBRWldiZkZMamhTbmdFMkow?=
 =?utf-8?B?WE00ZGxWNitrRGJPZ3JCTHMzUU9oRldCZGhDdm05M014Vm8reVFIcUhuUm5H?=
 =?utf-8?B?UVlrenM1anFqVWZRNlFvSi9wMjVXaENzZ2dRRkMrbnpiQVFrcDdadHJjOERI?=
 =?utf-8?B?dDIyL1ZIVjFIdTY3c05hb0JST0ZsUDBXMEpwd29uMFJDZ21WNCtRbVQ5RTY2?=
 =?utf-8?B?M3pXT1EweVlHMGV0UUFjQ25yNmZ4cVZsQnVzVWp6cGc4OEJ3bWFuZ0FCWnlY?=
 =?utf-8?B?M0pGUW0xZEVxQkRoVXV4NGNSSGFYNGgySjg2RkQ5WlQwWE1wSUd4NWZzWFJh?=
 =?utf-8?B?M1lLanZ4WGpRVVFWd3VQR0FlL1E4T0FyTzZkNmVYejcrTWgzQW1QTGIwNU9v?=
 =?utf-8?B?Y0xFMGs5alorc2tpY21aSlo5ZjlNZlNacUVmNk8vYmtlMkpFc3JvWTR6ZURp?=
 =?utf-8?B?YjJVSVVQRVZKTnZ6dUkySXhBeEFaclNUMFJmMzJtRWV2OEJhSzNxeTNYR1A2?=
 =?utf-8?B?Zy9YUXZHZFE2RG1vVWgwcHNFTFMwcDVyNURwOVZac2pNSWt3RE83YW1ERzRS?=
 =?utf-8?B?RnlmTnFWMlFMRHZtcmtobWlzSVdBRnMvRWxpeE9GTGRqSHo2aFFaUkN2SDdX?=
 =?utf-8?B?SlZ6NnA1VzJ2YUczbGthZmhHU2NuelR1YUp6R3hPUU5GQTMvbDhkNzVncHZk?=
 =?utf-8?B?L0RHVWs2QjZQcTBWUlZlNE8wWDR6Ky9aTzJnZ3RoK0lCREszeFBaTHJoTjZF?=
 =?utf-8?B?TE02UFdEeS90VVRpcktrcVl5Z1JjUHkvREZqN3c3UGljeGVIZ1RzTzF0anlm?=
 =?utf-8?B?Rk9zWWJpQkNrdVJZTytRU3hJY0hSN0pzNG9UemRPcjgxck1FbDhaVFJVSjFF?=
 =?utf-8?B?MkFrYTZpWEZEWDFUQ01pNnN2ZFgvUjVBOFlRcHM2R0F5WFRoSkhBenpzWW1Y?=
 =?utf-8?B?Zmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2EBC63981000B340B3A71C7FE6A1C7D3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e453f7e9-bf18-48b7-a8a3-08ddd9406500
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2025 01:34:35.1662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zv6JkDaoMqJCDredd8cwDGaQV+R1U5i7/Z3o4P9jWW2Jjk/gq5STgnUM6zuxcTrWp9k2zVlXaZcIpyG7IjqNT5wJaXF5eIHK8i6xXNzSrKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6494
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTEyIGF0IDAxOjMyICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IHNjX3JldHJ5KCkgaXMgdGhlIG9ubHkgb25lIHdpdGggYSBoaW50IG9mIHdoYXQgaXMgZGlmZmVy
ZW50IGFib3V0IGl0LCBidXQgaXQNCj4gPiByYW5kb21seSB1c2VzIHNjIGFiYnJldmlhdGlvbiBp
bnN0ZWFkIG9mIHNlYW1jYWxsLiBUaGF0IGlzIGFuIGV4aXN0aW5nDQo+ID4gdGhpbmcuDQo+ID4g
QnV0IHRoZSBhZGRpdGlvbmFsIG9uZSBzaG91bGQgYmUgbmFtZWQgd2l0aCBzb21ldGhpbmcgYWJv
dXQgdGhlIGNhY2hlIHBhcnQNCj4gPiB0aGF0DQo+ID4gaXQgZG9lcywgbGlrZSBzZWFtY2FsbF9k
aXJ0eV9jYWNoZSgpIG9yIHNvbWV0aGluZy4gImRvX3NlYW1jYWxsKCkiIHRlbGxzIHRoZQ0KPiA+
IHJlYWRlciBub3RoaW5nLg0KPiANCj4gT0suIEknbGwgY2hhbmdlIGRvX3NlYW1jYWxsKCkgdG8g
c2VhbWNhbGxfZGlydHlfY2FjaGUoKS4NCj4gDQo+IElzIHRoZXJlIGFueXRoaW5nIGVsc2UgSSBj
YW4gaW1wcm92ZT/CoCBPdGhlcndpc2UgSSBwbGFuIHRvIHNlbmQgb3V0IHY2DQo+IHNvb24uDQoN
CkkgZG8gdGhpbmsgd2Ugc2hvdWxkIGxvb2sgYXQgaW1wcm92aW5nIHRoZSBzdGFjayBvZiBzZWFt
Y2FsbCBoZWxwZXJzLiBCdXQNCm90aGVyd2lzZSwgcGxlYXNlIGFkZDoNCg0KUmV2aWV3ZWQtYnk6
IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4gd2l0aCB0aGUgbmFt
ZSBjaGFuZ2UuDQo=

