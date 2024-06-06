Return-Path: <kvm+bounces-19022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E0B48FF21D
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 18:17:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2CD7B2D327
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 16:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B368C198A20;
	Thu,  6 Jun 2024 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fYYmEsvf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F86C199E95;
	Thu,  6 Jun 2024 16:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717690070; cv=fail; b=illganwCxLSGU4UaDlAQq31jz1DSqmXKIhb5ALq+zk7yXgVXGuLr3OSQUwZKzjt0vjgqhzL7jrwUNiBRwWTPGPXwrw/4XlDAIYQEALX8T76tOXLcsBSGf9A904cB95gIAdn3TS+swtaRuPg2dEgUAjhxlTfWkShdAYjRggwM8aI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717690070; c=relaxed/simple;
	bh=7cjOL3fjWgU85T0bQG+wZCF5Kti9V4hLk35LXTbCZQM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GCl17/fWj7LHK/voro5Ykdf4YS1uFphMf8fCsaBCqYe4vpd5FS9PRSsWxDX4HoEmji6F/+NWApMbQTIru4r7td6kF1tsAuc9yZEa5/+btpmRK5LH7QpyTscNJCnP9X00I7GZWSKUAjE9tQdcccTHYwrX5ppf0JHNyHkKcksKDi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fYYmEsvf; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717690069; x=1749226069;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7cjOL3fjWgU85T0bQG+wZCF5Kti9V4hLk35LXTbCZQM=;
  b=fYYmEsvfnPEozP2PD8I3MxcHdSMx7QcPoDC/NfDFaDGsq1efe78U5BzH
   CDvN+pXxoznzN/HZEgFrGqUrg+4DTT/ZDu1VexgrggeDL2sBP1eqNmOIs
   IKEGxmFT2pc1O/dBuU/0UOjgM0kcWEOtHU6i/ctYKEwdkgKBPIRwJY7Cj
   cnlbqbnMFl1pND5xeNFfL++jnGu1sKD8LtSDrXXWVlCi1hBwyCn/4vidm
   zhBYK7Ud/KUwramCfG83D6w0vEGzVT/OC6dFmNuXLQ4S6qZaYTvnLLg3I
   zK2GmAfCCLaKwOyRXHIR6qQ8TEB/GTBJeul+Zr1YFkKB9mErrq5G8EDUB
   A==;
X-CSE-ConnectionGUID: o/9HLDE2Qwu3fdipym7vEg==
X-CSE-MsgGUID: 8/6Mz7KMStutx2sJCEl47w==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="14180018"
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="14180018"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 09:06:27 -0700
X-CSE-ConnectionGUID: TRCs+kZoSUa3JajXuiZqGg==
X-CSE-MsgGUID: RNRWoZIsSGOFbciNpiqJJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="68807158"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jun 2024 09:06:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 09:06:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 09:06:25 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 6 Jun 2024 09:06:25 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 6 Jun 2024 09:06:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WYMOnTbi9TAO+yEv/O9XVRFhQyEClGGgIa6avF8MYWdaB4NOyZTLF3xwW+q3Cov09IIHWkNwOepDUUEcuX9X4cruCemb1vIfE4L5sZuj+4NhkCJE1PCXI2/+vegAY3GnRTcDwsE7h/eK9Ce0fhRIqY3S48Ug2wCVpU9/ZXkOKEZqz8cJvXCUz02Cz2a+hXK/oXjIiwrUGwBhJoop8yJg4sCTsmSAi4kP/G4N/MaJrkhod1fvGbSKJluYnyyGvcFF7v4XGtfICmElQvHIR4RHPNu6vceIPJkXeN7hgMjtFVnIw6MqrJFk43zsr33b/z+Rnd7SI1js8YXCDQT1J7Twsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7cjOL3fjWgU85T0bQG+wZCF5Kti9V4hLk35LXTbCZQM=;
 b=Wp0NDqO42GGRh30qDeMyMAAyZ8WELc3ECv27cLfG4h9dGSkij2RyatdWQOq2W+XzJWzCKSKPgsngFnaP2c0UBCkackANonWUiIQzmwCUnkHYDYwyzKIuiOYVSox1GQYQo8evIrG8xtXADyymvur5kjJyLXBeHrt3E/FLLqaMgrTMe5JVUXfzBE3Dijd8UIWOq5p/n8mtcoKu8oI2Rc18RTxaFVCPz/SQN63xVzNPGBps6ldRsncP573Kr+bI0NPZ74N020WiYrdhuV8XM7xYTQy0/0sTmLZGoTUSvIiDY64lAQiV4koe2BPzj+7PHm60zCXOgpWM7H3GtVAu9O0oKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8520.namprd11.prod.outlook.com (2603:10b6:610:1af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Thu, 6 Jun
 2024 16:06:17 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 16:06:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 01/15] KVM: Add member to struct kvm_gfn_range for
 target alias
Thread-Topic: [PATCH v2 01/15] KVM: Add member to struct kvm_gfn_range for
 target alias
Thread-Index: AQHastVo0dmY3Q5zs0eA9TFxB4dt/LG67jOAgAADDQA=
Date: Thu, 6 Jun 2024 16:06:17 +0000
Message-ID: <fc681baa75455d4ca8b78f62d51ebbbf3c38f053.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-2-rick.p.edgecombe@intel.com>
	 <CABgObfZ8qOJtui9ozU4sd-hnjNM_33qwA-jcJEeDc=RY5EoqfA@mail.gmail.com>
In-Reply-To: <CABgObfZ8qOJtui9ozU4sd-hnjNM_33qwA-jcJEeDc=RY5EoqfA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8520:EE_
x-ms-office365-filtering-correlation-id: b0c05099-365a-4f34-e513-08dc86429913
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?RGNna3crOGt1RzJzdmNtNHUxQVZxdVR6TEpVb3hSSkRYa0MreVVtVlJ5ZDZ5?=
 =?utf-8?B?UDJsWDNGNFJ5RzQwNisxZWZpWkZQSGo1N2ZJbWNFbVRLb3QwQzRZdW1VWFg2?=
 =?utf-8?B?Ui9qTGwvaTd0YkJLdWp1eVNtYW1uREQ5NzBLOWtZSTR4RTIyMURlaGxuVGJ5?=
 =?utf-8?B?aDFGVkQxUkVXYkdIcTJ5WVZLb09LRzJheGxzYmYrUzFmNmZJZnhWSkRyUk5I?=
 =?utf-8?B?dUE5eEtRU0Vua1doYmRzU1ZlWnozTVlEZ29pSlFBQmE2dWhFbmRmRG00cUtD?=
 =?utf-8?B?VFJ4L2ltRys5ZnZhNVF5WXJ3OU1XaUM0L1BTZVBZckRsTHVqM1hGRjR3MStq?=
 =?utf-8?B?cG1IeHZEd0ZqRnZJWTRHbGpkelJhZlpLUEwxUjVJVG4xbEFhWURVeFlFMUV2?=
 =?utf-8?B?MWg5YUVnWDJaZzZBOXVQS0t2dkpuME5jdVcrcWhFcWR6eTk2S0FkRFhITVNR?=
 =?utf-8?B?bjZLL1NEbkVGYm9oVmEvVWUyWjQ0RzZpS1MvemZLNkVia29lWUx6a1JGajNy?=
 =?utf-8?B?T3N0eUdRc2FGWWZRSGtTd1NocXpuN0hPckZaS1hCbk5pTUhodGFkYUhVS2Nk?=
 =?utf-8?B?NkdtZERUL3B1OHdpU0hSd2h3SHdDNTVsamhLcm5ZYS9GTlFrbTh0eExrNVBl?=
 =?utf-8?B?M0ZUcC9FZGlRUmZaVTJwNWhSTUhsRlgwZGVXaklXdE5IL0xlVFdyWTZ3Z2sr?=
 =?utf-8?B?a2xwU1VyZDlYYXVZTmpKdVUwREdqT0hhaGVnMFVyd0h1ZzVvVHN5amxOSXVF?=
 =?utf-8?B?N1ljdW5id0lCbWJndHhIWnNhYi82elcvUTBoMnhTalJyc1lVMXNYdUVFMW84?=
 =?utf-8?B?ZUVQdXkwU1phdWcwOGkzVTgwY3BCbUE3cWVtYjMvL2svRGJ6Ukx2VGlhU1Bt?=
 =?utf-8?B?Ri9EUUNsbnl2aVJZb1ZzZVpWK3dYbHgvb1NGUFhYWXZjaXlaUEx6YlRad2p0?=
 =?utf-8?B?bnJUYm9rY1RpRlZPZUp1RXBvSUJCTUtybk16WUZTNGlOQkNRUDBVZ0M3TldS?=
 =?utf-8?B?V2pxSUlwbVJRaGhhUGdIMTM5SmVlai9rRFRrMzNtOHN0Z1NQMG12a05QVXNq?=
 =?utf-8?B?RFJVdTExK2lKZ0o2aGF4aHpqU1RYQXdsYzA5S0ZUTEM5dDQwSjZxVXdQZjcw?=
 =?utf-8?B?K2tZbDNGSVN6Z3d5cUN6Y3lTN0Q5SVREUEVxUytPM2dJRFVaNnE3VHZrR3R2?=
 =?utf-8?B?eHJPRTMrdEo1UUhMbk5lMlNKZjNXT1pOWGFnd3dBbjNYL1RLRWtHQ09jZXF4?=
 =?utf-8?B?blFBb0pHWWpQNG92dGQ0Rmg3bDY3SGxHdWJQQ2U5UmRqMmVXdWRMMjhNYTcz?=
 =?utf-8?B?L1d4VDNpckV4NDQ3cmJoL2FIVHhCVTlzTlB4Z3MrS05udVV2MG04Vm5JN3Nq?=
 =?utf-8?B?TVhua0tKVzI3Z25aMUk5angvK0RGaG5DSGRQYVJHZ1JCOEVUcmxLM3VQaGtj?=
 =?utf-8?B?Tm1HTU1rcWZXL2t0Nml2R0w5N0hMOEpWY20yWkJMODdORzFnUGV4WjRvWkYx?=
 =?utf-8?B?emNObnFISk90Rnc0NXRnWldZT0hjMFNCVFdBSmJLTDVSclBRaUIySTZsR2s0?=
 =?utf-8?B?OGI3T2FhTHFPSmh3cVNhRHI1L09zQzlQNk5GWnhIRHBsc3ZvVW4velR4cTBz?=
 =?utf-8?B?d3ZUTDN6bHcvZWVLeU9LRjlRelhoR2dIY2JYTWl1VmZ6YUNGVXk4dkNkNlor?=
 =?utf-8?B?SW84QUVVQjNxVkt1VUtNYnNiQkdWaCs4V3hzWUpIQi9xOU5VOVlHTVRwY2hE?=
 =?utf-8?B?YTgybEFmcncvaWRER3kxaXZFblpWakxNdzVyQ2VvVWZ1eUoyUGJjZmRsT3hG?=
 =?utf-8?Q?L8P7kM7ms6+QbuTD6tUhJ2iUamN/m3HtGF3zQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGFJb01lR1R4SVZCQVlBcU81OEpkMzJLOFVBS1hySVRaVXdHQjdqNjUwVWND?=
 =?utf-8?B?aVlvSDVKWDdZK1FhRmVCNDhkUXNEQ2pRcEwvLzNTUDhrb3loTWs2N1VFQXlP?=
 =?utf-8?B?Rnh4RHhpbWdST1p2enBGUW82WGFiRmxPM0VvWDRiTTNCY2VUSmVPempqbDlF?=
 =?utf-8?B?dFVNa051NDJqVUlZT0ZjNTFvZXlLM1NiTXQ1UlBmVStVQkprR1BEcmZ4cHZx?=
 =?utf-8?B?dys1TGFmNjd2VXZlWkw1UElsNWw4UlNZNldqMXRJMzNoMThtNW5MWVNaTTZY?=
 =?utf-8?B?V0hkR3huSHdEK1k5SUtodGl6ZXViU2pkd2lLalpVbzZCTlAxL1BSUXNaNkdZ?=
 =?utf-8?B?a3BuMVdrWFdaRFZTaUYzazVQcWlxUzJiMFhOSjFqTEJneWZaMUNidlBTOEV0?=
 =?utf-8?B?SnEyZFkyZXJoa1pkVHppQ2o3TVJxelVUVkl3bkNwc1F2OXhoaS82ZWNZcjFx?=
 =?utf-8?B?S1A1MU9WRHVidjBHajUzek9Cb3M2Nk8zbUxBYUxvaGZ1cEh2L3FYTXl0NkFB?=
 =?utf-8?B?bHozQ3lIQmd0TVBkTk92RFY1R0VLbGNXLy9KeUtPcGJmZnBDN2tVNERvYXN0?=
 =?utf-8?B?bUNtd1ZDNjRHYnA3STRNcmtJUm4waEcwZTZKckJUM01KMWFuaUduUElmdUxk?=
 =?utf-8?B?ck05cGhGdTZ1SWVBaFFxQW5VSEVzMkx4akZUZnVhcFBBeC9MYUNhMldJSTlo?=
 =?utf-8?B?cGlZaUtmakViSEQ0Rk5FNytGT0VXdjc0VzlxYmdYVWtwc3A4WVovOW16dWor?=
 =?utf-8?B?amJiN1hvNllMaDBKc2pMVXJvclNjYVNwY0JacWtNRVNKck5nZFlZTWF4bS9x?=
 =?utf-8?B?bit5Rk92QldXUUR2NDU1L2hUc0RRVXNBbnI4cS83MU9ybmpMWXYrdVFDaU52?=
 =?utf-8?B?YVdHVXQxcHJFbFMySTFsdFJRTzBhUXBkR2VTcnVUaUJCQWNmTE1OR0Z1OEQ5?=
 =?utf-8?B?blBkMkkvVVZianhCYlJLbG5QQi93MytXUlRUeXdHdTJialp3NGxUZFFlbUlQ?=
 =?utf-8?B?eWcxZ0srTk5EQXA0L2VNYkJ4Wi9aT0hiL3lUWGc5M1ZMZGNKN2ZFUEdSVldC?=
 =?utf-8?B?WkRQNisra0tjSnRjQ2J3U3ZiYjhZODJBM0pxblhVZTJWZll0SXFFWnJzVkV0?=
 =?utf-8?B?UDVud2xHNGZHY2VTcUhEN0dZMVY4YktrWW02V0JwZGF3Z3ViUk9oTHJwbGls?=
 =?utf-8?B?RTNOSGpQb1NYVFRNT1NEbjE0NVV5L2x1YTU5L3k5TTNkNDBvTnZneEp1bkdZ?=
 =?utf-8?B?Vjh3UGRSbFRuN0wxUzN5V3ZuWDUvSXI3R2NTR3I2VkV4U3JuclN5U0tJWnlo?=
 =?utf-8?B?N3pmcWJiNDJXTmxidVBzN0N6b01rTTdxeERDQ0I3VDZVMFBtcWdWWS85RE5L?=
 =?utf-8?B?Ry84c2NrTHJ1V1IwZ29ZOFRoMm1uT2dIK3BScStiaW9LOVdpTXZXV0xlRWM3?=
 =?utf-8?B?aE9ucWhEcmhPNmdOUGdpUkNvbXF0azR5bkhkQzlaRlV2UzVXaWVrdXdWNm5J?=
 =?utf-8?B?V3Yxd0hWY1dIZDBnVVRZVm9tNkdKQ0FKdmtXenFhQXcyd0FTSE1udno3WTMv?=
 =?utf-8?B?OWxBL3JxNkd2V0xxSjFzY1h2bSsraUM3eDNUWHZ0WU9hYW5GQVRUb01rN3JS?=
 =?utf-8?B?UnFHbE5UcU9WNkRpOCswYzJYVEVCUmE2SmVJOElTVm5zMjBjU2dha283aUZM?=
 =?utf-8?B?SDRyNEFMQVJBcnFjbk43SFkyZDZQWk9XMEM0VWF6b0FKeTJ3cHJCWDlMM0wv?=
 =?utf-8?B?VExjYUJZSFJxM3BDckNGOStTaEVkOGI3VlAxbUlMR1lKVjBRRjZXS2dJanJN?=
 =?utf-8?B?dTJnQTZYQVA5ZXBBL2RxR2d5VHcxdHdGUzJsRWFMMFRpcXpEOE15eDVrOXl1?=
 =?utf-8?B?a3Y1dy9BMGoxTXdxRHRkSkwwaFRoVk1BVDdTYytjYWQ1VGhIQTc1NWVUT2NM?=
 =?utf-8?B?eGhFTVA3R3F1WFhwQk45R0dWT0NJdnAyY2RMeTlIdFF3Z2hKa2ZFbFRNQ2NP?=
 =?utf-8?B?NmNmOXFpOUhqNFB4QXRyTytnKzdOMXVxcjdsd3ByeUowMktwT1NBK0dobVJj?=
 =?utf-8?B?dXRUYmI2TUkyb2E2cmZaUmY4TnlnSTRhb29acno3eW1kZDFNdHNaZnFrTHlE?=
 =?utf-8?B?MHB3clBiT1Z5YXNWczhkSmRoa1pCZWJTSnIwY0NmMmR1Z3hmUjZoa05mNm5S?=
 =?utf-8?Q?VwkDEt4wzMkeJDhEADqE25g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBE60EFF27BBF44ABF9F39E490895F5F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c05099-365a-4f34-e513-08dc86429913
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2024 16:06:17.3657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p1r+TFDWR7aQje8jL7kOpBAqugAo8+EQSa5BE06w53GIXli9fZGaLd70NJVuQGO/gieReZcuvg6zkUfwrK53k1S4F0NPg6YQy8OgaqDUfOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8520
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA2LTA2IGF0IDE3OjU1ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+
IE9uIFRodSwgTWF5IDMwLCAyMDI0IGF0IDExOjA34oCvUE0gUmljayBFZGdlY29tYmUKPiA8cmlj
ay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+IHdyb3RlOgo+ID4gK8KgwqDCoMKgwqDCoCAvKiBVbm1t
YXAgdGhlIG9sZCBhdHRyaWJ1dGUgcGFnZS4gKi8KPiAKPiBVbm1hcAoKT29wcywgdGhhbmtzLgoK
PiAKPiA+ICvCoMKgwqDCoMKgwqAgaWYgKHJhbmdlLT5hcmcuYXR0cmlidXRlcyAmIEtWTV9NRU1P
UllfQVRUUklCVVRFX1BSSVZBVEUpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBy
YW5nZS0+cHJvY2VzcyA9IEtWTV9QUk9DRVNTX1NIQVJFRDsKPiA+ICvCoMKgwqDCoMKgwqAgZWxz
ZQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmFuZ2UtPnByb2Nlc3MgPSBLVk1f
UFJPQ0VTU19QUklWQVRFOwo+ID4gKwo+ID4gwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4ga3ZtX3Vu
bWFwX2dmbl9yYW5nZShrdm0sIHJhbmdlKTsKPiA+IMKgIH0KPiA+IAo+ID4gZGlmZiAtLWdpdCBh
L2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaCBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaAo+ID4g
aW5kZXggYzNjOTIyYmYwNzdmLi5mOTJjOGI2MDViMDMgMTAwNjQ0Cj4gPiAtLS0gYS9pbmNsdWRl
L2xpbnV4L2t2bV9ob3N0LmgKPiA+ICsrKyBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaAo+ID4g
QEAgLTI2MCwxMSArMjYwLDE5IEBAIHVuaW9uIGt2bV9tbXVfbm90aWZpZXJfYXJnIHsKPiA+IMKg
wqDCoMKgwqDCoMKgwqAgdW5zaWduZWQgbG9uZyBhdHRyaWJ1dGVzOwo+ID4gwqAgfTsKPiA+IAo+
ID4gK2VudW0ga3ZtX3Byb2Nlc3Mgewo+ID4gK8KgwqDCoMKgwqDCoCBCVUdHWV9LVk1fSU5WQUxJ
REFUSU9OwqDCoMKgwqDCoMKgwqDCoMKgID0gMCwKPiA+ICvCoMKgwqDCoMKgwqAgS1ZNX1BST0NF
U1NfU0hBUkVEwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgPSBCSVQoMCksCj4gPiArwqDCoMKg
wqDCoMKgIEtWTV9QUk9DRVNTX1BSSVZBVEXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgPSBCSVQo
MSksCj4gPiArwqDCoMKgwqDCoMKgIEtWTV9QUk9DRVNTX1BSSVZBVEVfQU5EX1NIQVJFRMKgID0g
S1ZNX1BST0NFU1NfU0hBUkVEIHwKPiA+IEtWTV9QUk9DRVNTX1BSSVZBVEUsCj4gPiArfTsKPiAK
PiBPbmx5IEtWTV9QUk9DRVNTX1NIQVJFRCBhbmQgS1ZNX1BST0NFU1NfUFJJVkFURSBhcmUgbmVl
ZGVkLgoKSSBndWVzcyB5b3UgbWVhbiB3ZSBjYW4ganVzdCB1c2UgKEtWTV9QUk9DRVNTX1NIQVJF
RCB8CktWTV9QUk9DRVNTX1BSSVZBVEUpLiBTdXJlLgoKPiAKPiA+ICvCoMKgwqDCoMKgwqAgLyoK
PiA+ICvCoMKgwqDCoMKgwqDCoCAqIElmL3doZW4gS1ZNIHN1cHBvcnRzIG1vcmUgYXR0cmlidXRl
cyBiZXlvbmQgcHJpdmF0ZSAudnMgc2hhcmVkLAo+ID4gdGhpcwo+ID4gK8KgwqDCoMKgwqDCoMKg
ICogX2NvdWxkXyBzZXQgZXhjbHVkZV97cHJpdmF0ZSxzaGFyZWR9IGFwcHJvcHJpYXRlbHkgaWYg
dGhlIGVudGlyZQo+ID4gdGFyZ2V0Cj4gCj4gdGhpcyBjb3VsZCBtYXNrIGF3YXkgS1ZNX1BST0NF
U1Nfe1NIQVJFRCxQUklWQVRFfSBpZiB0aGUgZW50aXJlIHRhcmdldC4uLgoKT29wcywgdGhhbmtz
Lgo=

