Return-Path: <kvm+bounces-71400-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eBbgGJErmGlqBwMAu9opvQ
	(envelope-from <kvm+bounces-71400-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 10:38:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B491B1664F4
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 10:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8834D3039896
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 09:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13BC831D375;
	Fri, 20 Feb 2026 09:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ux+jChaj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F10E311957;
	Fri, 20 Feb 2026 09:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771580205; cv=fail; b=MuP3omar6wjMu6t58UOEaouxz7QBToz+AnaqTj8o84nE/RduJwJBBlGJ1sNyywobrAPZaOREsAEyl8cCfX5qpP2BsU0qEUPfgM1Yw+8ItRwqb64Di8uOy/uRUedXcx5Oe53vcFZvZ+60+EscE8DGjX7FnryvozpVeQba9sHd0uE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771580205; c=relaxed/simple;
	bh=VUkaZEYBS/q8OnilG6As3qyPGxAbnbZQiZhisrKaElg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Skc0Ckf83ihH+3e03vRjaAw34NwGr3q+mBl5A1FEBBHHdEG0XnV4ByswD77URajpkXa+Jz2ZHaE9QSQkbrQxZ4ZGZrHyADlwtFgsDnmb+DDYan1Y8y9DzKRhO3xXImuymcGnDXB29uHS6YTekPz4tKPqp3TJC1Ix5SNNL1ko+es=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ux+jChaj; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771580204; x=1803116204;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VUkaZEYBS/q8OnilG6As3qyPGxAbnbZQiZhisrKaElg=;
  b=Ux+jChajUFxmoVBYP8xM723Ascet8NPbRMbdBxLYpsmVfxP2yYxYYSY8
   hwLaErp+HOaCn2zfYDeZX8S7UYnKjlWzK2Pz69Y1rKMEUd8YXE/dqJfAA
   OBvZadoSxQhVqDZ0p4yFV9OmFKN7YDBc/S5us16uZHsOxH4S3NDY31z/U
   w73tkjoIHOv40A5cHDJuoSSv1wYoBgNsRdhT9n+8TDswA0eIv0cqG2wgS
   H62px3Xh/T0H7Z87OwHWKcueh25dwEAeFctcLk3spaAGgNDAIYDRpDOym
   cPVZN16BBXRkHOHWiJ1AztcmxIesXXO8m+Lo0MXgdYV3lpHaRVc8+muqK
   w==;
X-CSE-ConnectionGUID: OCMGO57xQTCQtRyRJHvuqw==
X-CSE-MsgGUID: fFsaMLHKRlSerhSD4Uk+Fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="72552505"
X-IronPort-AV: E=Sophos;i="6.21,301,1763452800"; 
   d="scan'208";a="72552505"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2026 01:36:43 -0800
X-CSE-ConnectionGUID: VO2Ng41MQQe6vHVztuLBSw==
X-CSE-MsgGUID: 8B04ZIFkRsSzXgBFDbjvgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,301,1763452800"; 
   d="scan'208";a="219813238"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2026 01:36:43 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 20 Feb 2026 01:36:42 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 20 Feb 2026 01:36:42 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.14) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 20 Feb 2026 01:36:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L4SjmZ720slL56s++lPIlq21vmSeG1IEFiaIi8DvFKRBguZ98GV5xgjGMHf+nMRxpl5uplYui+M8sh45F3b075hIZATRxKqOlZ0KOBxq3VhytouUJR7hZAfYEiOfhLbM9HOrSKpGrP6NQqhXRKIxwA500CZDU3LMrxrTrhbe+UfJLx0vGrOQ+hXW27mxdjUSpD7xvO2M7Xz9cgbWqLXSMsn6pV70Vn8B6KFynTgeWBdIzh+dPJjB1cWu7Ga6jP7F2qHdAv+Wi+++lYyOVNfMWAJIRBGN1QUlgBaIbN8yLIvzHYsj9ctKNHq78Vs1SAiC/PqfqirSHaxsIfn4y4bceA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VUkaZEYBS/q8OnilG6As3qyPGxAbnbZQiZhisrKaElg=;
 b=ZwlftbKkuUWvEU6AQjfPdwJUsxyltxsz9BCwog/l1SI2rigxwx9VVqH2oLyUVFmVfJ5YHtwnOBaMCvJH5US5OJq7lfTO14S9YAIB0RS0cAqkP+DU6Vz4epkz4ao9SqZp3O+PDGTPwZVgD+NGGM1bQGH41sSov1D1edpUywDPNyGJ0ltrbTyCPm4g/d+snWK8PijUEJ+49PFxzwxdJX4UGPZw9svk1QtBOa4ZL3wSO7CxNC4wDYpUB9LW3vkUp4rptIxpSPoqbbMYCce5W0AYe84DFAGV27J1QEHPyb8UaKIwQ9PtmHCLVexizuO95sqkJiSAp7/Xyn4W/5aVdPc/xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 SN7PR11MB6559.namprd11.prod.outlook.com (2603:10b6:806:26d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.16; Fri, 20 Feb 2026 09:36:33 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 09:36:33 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "Chen, Farrah" <farrah.chen@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 05/24] x86/virt/seamldr: Retrieve P-SEAMLDR information
Thread-Topic: [PATCH v4 05/24] x86/virt/seamldr: Retrieve P-SEAMLDR
 information
Thread-Index: AQHcnCz6PvNsJWZlNE+ecjfXXW9C0bWLYG4A
Date: Fri, 20 Feb 2026 09:36:33 +0000
Message-ID: <88141072be073896990f87b2b4c33bdd99f38b29.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-6-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-6-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|SN7PR11MB6559:EE_
x-ms-office365-filtering-correlation-id: 7b850f24-e497-47d5-2bb9-08de706388db
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?WGNJRVRDcDVsZTQ5WE8vZzhpbERSZ1oyMWJIbS9GZ3E0SFBKOHhhUnlQdlhS?=
 =?utf-8?B?WklrbXVWTjcyTDhhdHA1aWVUQ1VUVU5aRHR1NTZlTnpIbWJodThWQ3o2RXZ5?=
 =?utf-8?B?SXNxWDlqTzh4cjc3K0J4RWJuZm8xM29scitCY2lkQ01vQlMrSXFkWWJ2aDQw?=
 =?utf-8?B?QTNBOXl0UlBwaklWRHo5bExLYWY2TG1FQUFIeXN3bkw2anp1UUM3RVd1QllK?=
 =?utf-8?B?YTZ2V0JtaFZGUkJRVjluQnI4cERhUEQwMlF0WFNSUkJlMC9OVVYrOHdLUVBR?=
 =?utf-8?B?OTJobVcvLzNpWkNVdGtadENWWXM0UjZYK1FIQjJudEpiZ0RtSk4rM1lTMnpa?=
 =?utf-8?B?YXRVSXlXeUdpODBkUHdGaURSZmNHQjdhUys4bkU2OXN6TEFnRGFma01Mcjcy?=
 =?utf-8?B?eWNtQXh4QTdTZGFJc2k4ZFlsL0t3MDJDbVZxRXhCaWZPNzZTMTE4VWtvM05u?=
 =?utf-8?B?ZUZzNXVoeEhwdEgzaGMwMHo5RnFsNjNDc216N2ZFL1lERHJQS3gzV1grbG5W?=
 =?utf-8?B?TWJITHpzNDdvSzlnaFZMTE9wRW9UQmpsS0lMRFB3YUQwUGM5d2hQUWlOSzlo?=
 =?utf-8?B?bk90em85bmN0WTNFQ3FuWnBucDZybVF2YVhwdlQ1a24ySmlJdVczNWRDK1RC?=
 =?utf-8?B?b3U2QWwxNG5XOTNCUUVkWTIyczB5aVV0WHQ5VlhTbTZGbHgwWDE4Q2dvNEs5?=
 =?utf-8?B?R08rTy9pTzV2OXhjTisyYnF0amtMSlVsWWxIckN2NXdaVng0d2R1emRZNGRs?=
 =?utf-8?B?dDM2RUt4R1d2a1ZOeHFvNnpaWGZYTmVzS2llODlLZHlQcTRYZTZCM0pDbG90?=
 =?utf-8?B?ckRkTWNEMjZBRUZnSHdFWVdDd2FZSVpqU3dGd0xYYldBazIrS3pSSkhrRkgz?=
 =?utf-8?B?Y1Q0T2QrMFhaTWF1cTQwZW9hNHpwVkY4cEt4eWxxZTlwS0xXek5WMDROTlNW?=
 =?utf-8?B?QTdmZ3NmTVFISWJXc003TWh6c0VKRmphR1F1d25JR2MxMTYvQUZsMG84SFhB?=
 =?utf-8?B?RVR2ZlB6eFdmVVJhNmpCbEhiRGJLNzRYU0dLNzJSeGtWNm1DRXJ0K1htOFhS?=
 =?utf-8?B?b0RvQllia0VOSVQ4eGpUMkI3QnlmSGtMdDR6Y3dPZFNxL0NMSlREU0dMTk41?=
 =?utf-8?B?VEVwd1c5cnRwVU8zTnFQM3IwaEdtRDV1L0FKYzhLRnFiZjJSRnV2SG1TWkUy?=
 =?utf-8?B?eDlBbU9INXg2Zk9BZEQ2c0xQRXI1NlN2d04yejNMT0lwNTdlc3E1b3hMSytU?=
 =?utf-8?B?cW9nb0NhM3hyd0FKSGVuaUZTYUIrbC9JdTR5dk9pUzBWVzdpdzdXWkJ4R0tV?=
 =?utf-8?B?YVgrSnZMTFZsdnJSS3oweWp5eXVPQStLY3JVV3FkQ00wMmRQL3pGbW5Bb0NG?=
 =?utf-8?B?amZvL0NPbW9JbXhxTHg2K0JRT0ZxOFFvOVV1TDR5Nk1aRis0bzhHcVNreEgx?=
 =?utf-8?B?VGpMYVhIMmtjWFg3WmlDTHVpdi9hSnl2M2N2dEcxaytZQmRiZVEyYVgzaEZ2?=
 =?utf-8?B?VE5OQmxTMmpvOUpic2FjdW1ZS0dyb05zb1B2eWp0clI4NitFa0tCTDFUS1Vm?=
 =?utf-8?B?Q3UxbGN1dlcrcmtEQWtHanFnUU1xVGorbCttTjdwWVh4b2xxYyt2YzFWTU4x?=
 =?utf-8?B?Mnc5TkNQSWtGT1llTHNSazdCejNqeFZjRUNjRUFHTVV1cFUvZ25BcWQ2REJZ?=
 =?utf-8?B?NVVSZTU2SjVkbmZnSE9rNVJ2c0xCSDVtYTM3WTNkbjd1VDcxbXdUTlcrQXp0?=
 =?utf-8?B?YkxuaHhUdDY5UHBPb0Z1YUx5dUtWSE5QY09HUnFvYW10TjlOK2xkOU5nd2Jj?=
 =?utf-8?B?VHdXZlhxWFpsTDJtRUlrRzRLUndVVGpCQjN0emdJS0RHaW9HMCt6bmh0Wm13?=
 =?utf-8?B?aTk3T2ZvcThKWmI5YndLUWo5U0Rrd2ZoTW15WUowOVl6RWFISFMvd1pvQm1v?=
 =?utf-8?B?a2o0WjNEU2FBU2Y2elFLcFptaWI3OVh6bXNNZ2ZaNXNaK0V5Y1d5MWZZS3c0?=
 =?utf-8?B?MStXOVBUM3FxM3FIdUtaOW80TXRaNVZlVFpPSnpqKzNBc09BenBpSnBSRzFD?=
 =?utf-8?B?MVhaUHpCTHdYQVdiS0dkZE9Da1pkZzU0TGc3YVdjVjcxU0N4ZGZVdnJ5N2cy?=
 =?utf-8?B?RnJEWG02RWRDeU9OcUI0UCtZZUNnSjdkcDltcDlWWDJOSVFVK2pSZXFCWHFX?=
 =?utf-8?Q?8BfT3sTXIT8POiIP7Yf5JWs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2NpSTMra1RkNWJ1a0VwZTdiMGl3UjhmUEZjRmw5Tko4S1hJZGN3WmJTV2k3?=
 =?utf-8?B?UVVWUldvR3luaUdMU3NMZFB4TU9IUXFHakVPSHdHQ2xHUVZmNDVNUjl5eXR4?=
 =?utf-8?B?NDB6TS93ZmV6SmZscDhIZDd5VVJHQmcrcE5FZ3RSeXF0Qkc2NXphQ3dSOW5K?=
 =?utf-8?B?ZnpBWkp3cUl5a05pRWJ5SC9rR1F2SEFBQ0hWQ0xhdmdzRzRPdG9YMGwxUmJH?=
 =?utf-8?B?OXJNM0x3cUgzaDRUbVU2Y1grbTVidjNsc2QvM1BoS1FJSXl1cHFyMlNwTmtG?=
 =?utf-8?B?bzlzaGZjNXlrb0xJYXhEcnV0WFJxOHRoVEwxL1hZb1UyVm1veThoWkdwVGYv?=
 =?utf-8?B?dnIvempIdEd6SDZob0k4ZFh0R2NPbDdubXgzckFNY2YvQk1LblcvQmVzbGlk?=
 =?utf-8?B?UlcxNVBxSGhHaW5qejB4bTdWQnczQVVFdUNmSkhDTDJtWjY5OEx4TFBLMkxO?=
 =?utf-8?B?am0ybDBicURkVzZPMVNtNWw2alJ1Ujh1clJOYU1iYVJuY1RBdUE0RDQxRnhw?=
 =?utf-8?B?emRKMDZHYVdhL3BnNXdibTBOb21qMEdhNW4wT2VNV09Gc2pMVGZrelJVSWZx?=
 =?utf-8?B?RU5ZMC9ZWm1yUTFGclU5KzFkUndnUlAzRHJWMFl1Y0cwMlRjZEFNak1iV2lL?=
 =?utf-8?B?VGVwUHhPUnRRYzhWMy96N3g4MUxNYWFvNGd4MFBKYTFjRVNVZDhjeHVwWmY0?=
 =?utf-8?B?TDR3K2UxV1pkSTZma3JLa096WllKc0dpdm45SDBPWVpJVHhLVU1nWDl6c2g2?=
 =?utf-8?B?VWJnSDQ1cGRkQ3RYSXRicnIxWjRxeWx0OG9JdVo4aFdXazZIN0pRYnFaam1l?=
 =?utf-8?B?RlNiYnBoQXhXbXhhVGJLdktFOWZHL0ZrOHV2UXpYR3VVYmh1NmxhSHFqMUsw?=
 =?utf-8?B?NDc3VHh2TmFoa3kxSE9LOWVER1QxVmUzZlRsWkVBTkFwcTl6L0diU0FDU0o5?=
 =?utf-8?B?TDNKdVZ2eFVpQ2VrOWUvaDE3M3ZpUndBUjc3aStqL25hNXoyREhDUmRaNnJB?=
 =?utf-8?B?eGdPQTJNbkNGd3Q0aXkyZ3BMWkFOMmQxTXQyWWM2LzFBaHNGVW8xd2Y0VCtL?=
 =?utf-8?B?bUhhMzhqZ1lMUFRWOUxCREkrVHdUSDJML0kyYWkrdGcxTFRRSVZTQ2cxVGNS?=
 =?utf-8?B?blpXcS9pZnJFMnFxRDNxb2ViMnFrVlVXdnVjSVBXTGtWWkJhYUttcDl3K2xV?=
 =?utf-8?B?MGQwdzhUWklndmJzd1gvd1phL3BGSUVScUNoMmdrbVBOQVFMaFpwSmEvT3ZI?=
 =?utf-8?B?Q2FLMGUwdFBOMEludmdpMmtPK0NFSUhyQzZQRk5DMjBLWHByaTJRcnhoNVFK?=
 =?utf-8?B?R05WRUsxK2FDakU3VWdpOXgyVWE2bklFdXhLNU9uRGpXU1lvZ2dVVVA2Z1J1?=
 =?utf-8?B?NDhJQWlaMzV4NUFXcWFsaDBGbkFhQmlNNVF3ZTAza1N4QmswRE9xeFJwdzJE?=
 =?utf-8?B?NkFLR0JXVnduME0vNFJ6NDh3Q2EwazhNbFp3WXpQaElTT1R0ZjZtZmdHSUJS?=
 =?utf-8?B?VUViUko3SnA0enlNdjJjeU56QjF5RVJodC93MFFNTXBkdGcxOWFwVjZpdnNK?=
 =?utf-8?B?RjJRbFdpOUpsYkhWallidWk1SDZEUDZ1QWhEOTcvSGhFUzhJVmJIeEdGWnNp?=
 =?utf-8?B?S1VMeDRRZU1GT3VaT2cvZXJRVEUzOVgyTDZCNmRSOStGN3R3Skw5WVNjVXhT?=
 =?utf-8?B?T08wdk5JU0RkZHpNbkJYbWJZNDlVVHBFUXpNNDlsTFFMTk84RCs0L05EVjF5?=
 =?utf-8?B?VGg3M3o4dG5zUWNabXZVMHlJUVY4TnZ6MEp3MVI4azVGM3BhbFFaYmpKb0hR?=
 =?utf-8?B?S1Y0SXhyNUcyUitDWmZSK0VlTlBUNFlrSS93M3FKWnRVNEQ5RVVXNnQxZDZw?=
 =?utf-8?B?dHRPLzlGc2JqMGYvQkNmd3N4UGRwMVhzUm9taXJpRGRjWWNVRmI1UG9sWElM?=
 =?utf-8?B?aTVmc082bGdVTXk0TnBSdHRMcERoUTc1WlVtK0NYQ3YxMmMvUVpkWXVlejQ3?=
 =?utf-8?B?aktBTDViT3hoaWhxN3NLWU9FdVZOZjVVMHRjLzdnZkpzRnNXTS9jMDRWWGNr?=
 =?utf-8?B?dGtDRmNmN1hCUGxZdkNMRzA5RmRYYTNEZVVxajJGemVHZXZac3QxQkN1Qlds?=
 =?utf-8?B?RjFxT1FZOUNxQUwwUFV1a3hsWklMWU1OMFpIWGRTVVUwejhlQ3E1SkdmN2R4?=
 =?utf-8?B?WjQvejlFNGlqZmpUb0NKd1RwckJhcWRnZkEyVjY4R0VMMS9KekZMUEhnbytL?=
 =?utf-8?B?NGxOOUN4YXcrcUtEWDlaeFFhR29DYWlLb1pXMkV4Z25Lem55aFYxTjRLeEhB?=
 =?utf-8?B?Y0k0OC9XNVFxV2M3bUZQa1BZRHBaN25pTTRscS9OQlU4bTE1cGE4Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B7293331488B246A47DDE1C75F3C19C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b850f24-e497-47d5-2bb9-08de706388db
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2026 09:36:33.2872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Q8xcr2sWZOcPwUnHTO2+QZbKqBJjMHJGNKEzC2Loj2bj6GZ6VBXMZosp+/kgcGu9GfIAsMFLGFzcjhNpY/Mog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6559
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71400-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: B491B1664F4
X-Rspamd-Action: no action

DQo+ICtpbnQgc2VhbWxkcl9nZXRfaW5mbyhzdHJ1Y3Qgc2VhbWxkcl9pbmZvICpzZWFtbGRyX2lu
Zm8pDQo+ICt7DQo+ICsJc3RydWN0IHRkeF9tb2R1bGVfYXJncyBhcmdzID0geyAucmN4ID0gc2xv
d192aXJ0X3RvX3BoeXMoc2VhbWxkcl9pbmZvKSB9Ow0KDQpTaG91bGQgd2UgaGF2ZSBhIGNvbW1l
bnQgZm9yIHNsb3dfdmlydF90b19waHlzKCk/ICBUaGlzIHBhdGNoIGFsb25lIGRvZXNuJ3QNCnJl
YWxseSB0ZWxsIHdoZXJlIGlzIHRoZSBtZW1vcnkgZnJvbS4NCg0KQnR3LCBpdCBpdCB3ZXJlIG1l
LCBJIHdvdWxkIGp1c3QgbWVyZ2UgdGhpcyBwYXRjaCB3aXRoIHRoZSBuZXh0IG9uZS4gIFRoZW4N
Cml0J3MgY2xlYXIgdGhlIG1lbW9yeSBjb21lcyBmcm9tIHRkeC1ob3N0IG1vZHVsZSdzIHN0YWNr
LiAgVGhlIG1lcmdlZCBwYXRjaA0Kd29uJ3QgYmUgdG9vIGJpZyB0byByZXZpZXcgZWl0aGVyIChJ
TUhPKS4gIFlvdSBjYW4gdGhlbiBoYXZlIHRoaXMNCnNlYW1sZHJfZ2V0X2luZm8oKSBhbmQgaXRz
IHVzZXIgdG9nZXRoZXIgaW4gb25lIHBhdGNoLCB3aXRoIG9uZSBjaGFuZ2Vsb2cgdG8NCnRlbGwg
dGhlIGZ1bGwgc3RvcnkuDQoNCkJ1dCBqdXN0IG15IDJjZW50cywgZmVlbCBmcmVlIHRvIGlnbm9y
ZS4gDQoNCj4gKw0KPiArCXJldHVybiBzZWFtbGRyX2NhbGwoUF9TRUFNTERSX0lORk8sICZhcmdz
KTsNCj4gK30NCj4gK0VYUE9SVF9TWU1CT0xfRk9SX01PRFVMRVMoc2VhbWxkcl9nZXRfaW5mbywg
InRkeC1ob3N0Iik7DQo+IC0tIA0KPiAyLjQ3LjMNCg==

