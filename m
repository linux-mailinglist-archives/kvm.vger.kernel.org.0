Return-Path: <kvm+bounces-50846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1920AEA2B9
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 17:35:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFE2A188D12F
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 15:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4975B2EBDED;
	Thu, 26 Jun 2025 15:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NdgKm5Pe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34CA16DEB3;
	Thu, 26 Jun 2025 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750951869; cv=fail; b=dD+paNDqcK9j/KDcdlN5DuSf5IHvNX3CYvBcHgremCCOF07ZjlVHomgevZnVWFg4ZOKFuQpvtEr61e6d/56HUldXKvceKGuE55tlWsX84zj8ej0/TS514rFhTS8OrV5bhoPUALW9EUonCoX3wQRJKIqPbzHnUsAuoVoUUOigDgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750951869; c=relaxed/simple;
	bh=KomapU7Q4HBt0cWMuXQCdUIKnNDbFglL3t5T//aQInM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SM2dIGa/EC6rk+gj0vd2y7BdtR9GKtF/NI3qWkB2c4rE6jVW8u4n0xU5tiHW7goqljFnK94nIyknhuQL4r5JcviQuhhz3c2PRLjpjeyLRonNpc62y87N57WYSLNkkgo//jc4xfTLOqoahMRN3Ex8qpBDqJ7EV4+2UW2urPP7Jl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NdgKm5Pe; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750951868; x=1782487868;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KomapU7Q4HBt0cWMuXQCdUIKnNDbFglL3t5T//aQInM=;
  b=NdgKm5PefabEsseZH34tBgVRGk4E1UBo51uQPj6EwIjT3JpB4/PUOmYN
   t2BCxXSYUqPFLgS1XcfDHkhDFhA5mhUCssXa7M7flQXAUO57pzsBsPQ9N
   9Q+WEsEsSH5nr/JFE//WFhyJ45+F7HiMciT7EfAXN4CzffKO2c9mXYHYA
   3qlppwg81PajBkPoot9/D3Lq4w1u5BcdBZsyI4KFHcSzuQCLOUX7O8Ras
   Ko/iBVsNallOO3yF/FHOt7GU3wnxseoEkZjmVQ+Ebx3iO9OeG/VLz9YSN
   knQZthzVCZW5t8bW0S1TuzXWsje+V5yO5g5mHynBDIB+DB5wtNO1UhKJn
   A==;
X-CSE-ConnectionGUID: oFC7/R/KSiaU4gELSJ904A==
X-CSE-MsgGUID: bZYnKHKnR76oaHZyj0kWjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="57062497"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="57062497"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 08:31:06 -0700
X-CSE-ConnectionGUID: uW8Tb7OHTyCDJqkYvMsjDA==
X-CSE-MsgGUID: JlzwajD3T1i4I3PszqBGwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="158046630"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 08:31:06 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 08:31:05 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 08:31:05 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.40)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 08:31:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X6dHmjLx2VUYGABM7cxnawqaIn8IOaCbryMTlNDTnW2p1Y8+Iwgqx17Dbf9DYhIv2Qr33lBzHXgT9EWRc0+qj/vYr2DAKWNnzVU6hmGz0f2SZYtTUtvKJNGpHl7ma1VPPfOOQbeShHy8cbdBYGP6rZmNvyze6/RV3vdVWjMMOp57FB9Fuh0QxZ7xnk+wZtLDInecvuWsx4lkOkBPdUlC/msdrZSwHZ4Wlo83+J/1NCBbnD8Gp2o+/Y6/Mv9GGHhr1VbBGi0JgN2ml8YYK6BgStA8+VFM8PiPMCjDqtibJyzBfhlosOYvbQvxacBYPfUnGQq5vtwgG3RioyEQ5stS7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KomapU7Q4HBt0cWMuXQCdUIKnNDbFglL3t5T//aQInM=;
 b=H9JNxDHtr/6oaTuRLfF0Yr0Ua0brD4WpwW7yGL2xWnVttrFn8F7E4JDU3UIM1v/0Hm94kP+3fTiudy1dz5eN2dhAplJ1ZSt6OJ/gQJ302xFw91IarfbRPBktaf4H9kDc93fEopl0BHj52drcK9wVgS5L5uSxRfu/hCR1vRtMscEJFc85tInj9h8L1k8H6y/yK5XBRTl5sPwRIfzio4PC9+aAoC5dZ9nn4dIZhP+mo80g8hzusfCompfANLi8YahFH0Vib6+gtcoFq0J9jsha1JoktKeuaTiplnY5WNYuAZUWX1dyWwrjo6N5FmQL9LZhPKgR/picxhRgb0Y8sA77+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) by
 SA0PR11MB7159.namprd11.prod.outlook.com (2603:10b6:806:24b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.30; Thu, 26 Jun 2025 15:31:02 +0000
Received: from DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::509c:f906:cc6:2bec]) by DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::509c:f906:cc6:2bec%5]) with mapi id 15.20.8880.015; Thu, 26 Jun 2025
 15:31:02 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Thread-Topic: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Thread-Index: AQHb4EnENkGm89IqtkyIKxy9rDGLrbQJAkSAgAr5c4CAAB9IgIAAZpSAgAABi4CAAC0mAIAA6kew
Date: Thu, 26 Jun 2025 15:31:02 +0000
Message-ID: <DS7PR11MB6077ED08B85A000014BDAE00FC7AA@DS7PR11MB6077.namprd11.prod.outlook.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
	 <20250618120806.113884-3-adrian.hunter@intel.com>
	 <68938275-3f6a-46fc-9b38-2c916fdec3d6@intel.com>
	 <CAGtprH_cVwWhfXFkM-=rVzQZ0CpY_zcnkF=q5x1n_9Bzm1xKfw@mail.gmail.com>
	 <bc492cb2-1d30-4a30-9eb9-d48b09cd29a9@intel.com>
	 <c315604761ad760fc29bebdb007fac239a1b45f9.camel@intel.com>
	 <91df7051-2405-4609-9e86-2bbc02829644@intel.com>
 <8c24d9b9c888eed972e8ee75fa9d31cc7fd72a73.camel@intel.com>
In-Reply-To: <8c24d9b9c888eed972e8ee75fa9d31cc7fd72a73.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR11MB6077:EE_|SA0PR11MB7159:EE_
x-ms-office365-filtering-correlation-id: 1dbb0343-3f3a-4ca7-c7ee-08ddb4c67573
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OGQ0RThMWWlwQmNocE1GcHFIamVoUGJEaFJob053Ui9lY296bkxrUmNWaU9Q?=
 =?utf-8?B?NEliZDRCVHZXYlo3SFV4NHF2NW92RVJsKzdOSjNzNDBzSWRtL2lMcHkwUjlG?=
 =?utf-8?B?OVFJUTE1R2NwZTkvL2RYaFI1Y0xQSThyRi9NZU5KSzdIcU42cmxoT0YrK3RQ?=
 =?utf-8?B?UTlNNGFDOVhxb0pZN0ZaMWlVbFNsc29LcUREeVgvNEN4WFRicnhOMThMOFVU?=
 =?utf-8?B?OVhZeUpTVWw4NWRmbEc0MEQxU3YvSHN6WEVzNmpQcTlLWEpUWTRPRFZnOUFi?=
 =?utf-8?B?KzhxdmhtazRCZkRRdUEzcjMxalRoa2FSaSs3YmJ5RVViQjhpNUpzMlAyODUx?=
 =?utf-8?B?aEp6U1NsTmV1ZVlPYUpCakZtMCtLS21nZWVIN0JZT2FIL3NqOEZiRnRzOTdi?=
 =?utf-8?B?YnRiaW13Qkk2MHIrMERvMWgrOEQwUkMwTGc2eU5sK3B0V2pFT2VvTXRoMjJo?=
 =?utf-8?B?cVFVYmFqMUovRnVjQmErU1lDSXV5OGREa3BoK2FtakRFV3J5eWE3MW5JQk5L?=
 =?utf-8?B?NmR6bDFOWnBPWUZXM2ZRSVJEMXZFMlpRNlFIam4rZHRkRThrSGpKc1RiUDRC?=
 =?utf-8?B?aWFBWVp0YnBYN0VYL3Y2djZ5UGNaOUZmcE1DRFJIbTJEVkd6ZDhjdmR5QTBh?=
 =?utf-8?B?THNpTWxpM1NqOFpJNlpobDN2R1prbDZIb2FKTFNxM1RacHcrZ0xFWjVvSEgr?=
 =?utf-8?B?WFRSSTBsUXd6VW83K0NzOEg2azNyMWNGc3dyWEVwSFlLSlcxTjR0Q0Vhc1Iw?=
 =?utf-8?B?MytXdW5RUEh5RWp4YUVqUlF4QXBORTZWRXE5V1NDMkd1WkEyVVJFcCtPWlJi?=
 =?utf-8?B?U012cEFZY3g5eFM1L045K0V2Qm9QWWhKY1Z4Z2EzbzZIWFNnM0lsbEZuSWcr?=
 =?utf-8?B?YVRMK2Q1YnNmMG5zS1BtWkFEbnRzU3pyWUJMeElmWFZpeEZPSm9qOFpYN3k2?=
 =?utf-8?B?RDE3Z1Vkb2hEK25SWlljcG1ua0d6ZWFmb3ZnVzI1N0krK0x4OWNnek5iOXhZ?=
 =?utf-8?B?THRMZ2FqUUp1QlU2aWY3bk5CWHZzWG1kMHFBSlZxd1R3RUwzekpWZXdzWndD?=
 =?utf-8?B?ZUt3MysrQ2dVSFlZQ3JHbzVtaEc3eUcwRW81ZWxIZFJXSkJEeFYrclU3Z3Iz?=
 =?utf-8?B?ZVRWVERVNkw3dzBJYXl2M05GbFhDUjBjWHpWUmtrRHNteElKYm53MkxGT2po?=
 =?utf-8?B?L2c5SDBKSWZBZ0FPUkNPOXgzUmZzRWZTVFJibmVqNk1mMXlURTgrMjYxVVlw?=
 =?utf-8?B?YUI3NkdBWXpaZi83ODdlL3VzeThBS0lyRWJBYnl3TEtJVm51WGFpNjgyTk1S?=
 =?utf-8?B?Nm0wbm02NTJNaWZwdmhETlh6aHNxZ2xad1dPVDBhSSs0dVloWW5wT2tIUGJB?=
 =?utf-8?B?dDhsVzFuS1hDelB2cnozU3R2djI2TEJHZm9iTEJ6ZTQwemF3b1puelkyaEtP?=
 =?utf-8?B?OFpqdVUvdWN6ZlE0MWpzSzJLRlc3NGNnV0FTTXFFUzhGMFgySEVDd1VJVWJt?=
 =?utf-8?B?K0VuRkVtTDNEbUI3YmdBYlRvdDFkWXA0azZrL0owZ1FyOXdDckgrY1V3UVFY?=
 =?utf-8?B?aXdsa0VsTWtvV1hqR3lLMmxwU29seHIxQWZPK3hDRkhxRSthRzNrN1lSb25o?=
 =?utf-8?B?QUMrNmc3eVBpM1JBbnZmdkM5SGFnbjlOVnVQZGZOQUdFNjFwVXRjSTFhcFE1?=
 =?utf-8?B?eDdLeW1zTklCWEp1UzRCNVhwSlNqcytHQ3JmcWpJUzdETXZtci8ySjQ1eC9E?=
 =?utf-8?B?OE9pb2NSV1ZVRTM3cmZESjJSK0YwRnAzYUduNmYyalZnVDV5aXd6dXJLOGRx?=
 =?utf-8?B?bHNjTHF2bElsZHh3M2UrWDJacUwzUE1FTi9nMzYycUp2UWh2QktocWk5Q3Bx?=
 =?utf-8?B?eTN2RnNMS3ZNZmhmU0Y5MEFselprc3EzVFBUK0hsdklZbE5qWWF2SW13RUpr?=
 =?utf-8?B?ZTJqY29qdU1xaHlkREh3L0hYaVlPNEdKRnNCL1lvdHJiZnkzVVVDYlMvMjZJ?=
 =?utf-8?Q?4cAK6IcCVgjayKUXGpCk8GjPh8A9Ps=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6077.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnpvUjliS0FrSDA5UXNjZVROWURSWkdmYWF2azlXMHJnYkhaeWV5RlpwUDQ5?=
 =?utf-8?B?WmJLY1JKSjBPRWdDeW8yMldZcTlDT2k4VjFWejNXb0xGZkNPS0QxZ2FsRTQ2?=
 =?utf-8?B?eFVBOFF3V0I2VFNUSHZabGQwQm5qOVY4aHdpdjV2SWN1RnN0djZ1K2UyYXZW?=
 =?utf-8?B?Z24vOUNma2RLN3ZYNC9CQkNzV2VlV1VFZGZvVVpSd1FrMjNvcC9hYy9EdGl2?=
 =?utf-8?B?WGhMbDlETzkwb3JXcjM2NUNSR0p2dk5MSTJGR1AwcU1VU0dDNCtXbG5ieWlK?=
 =?utf-8?B?WThkZEF1MzFpc01iWXpITUp6YUhZUDFxUFVaWjZNT2R5VTJmcWJRcGVsdmIv?=
 =?utf-8?B?TTlzeFZiZzRNWUtpbDNhV1dCQ1NpZGc3UElHTHFGQ3VycnE3Y1l2dWx1NnZh?=
 =?utf-8?B?YUlqb3QybTBmSno5azVSVHBDVGpkSXg2TjV3ZFJ3QVRrNXdtblBBOG51QVhI?=
 =?utf-8?B?MUNQaGp1V2ZkZ2dxWEtnK09oL2FMSjZHbWFPNDU3RnhGaEp1VWVxSjJPeEMv?=
 =?utf-8?B?dzZZR3BKZHFhTGtrOHgrQUoyejFPK3VUWTJIcjJVcExBQjlPdkFPWU5RMHlU?=
 =?utf-8?B?L2Nvd04yRU95QlhSdnBEbW1IbjZZTXgxL0gwNzA1VElVRm5wKzJpYmlqcWpJ?=
 =?utf-8?B?Y0NaS2pqcmNKZDZDUDd2a0tJblBxREdlUTNCMUl3QWYvNnZJZXdML2lDbXNj?=
 =?utf-8?B?V2RtM1V1VytrcnpaUzd1RUNjWTZLVzgvUjdrVkdvS0xQOTZuM1V4M3p1RnJF?=
 =?utf-8?B?SFZFRVZwL0p5eXZQWVBSZlV0MjRiL3FXbEpDbnRtcTh4UWh3Tk01UlRnU1dU?=
 =?utf-8?B?bjNvQktkRzhhR0V0cU9CY1Qzb2VEdzdlVmtpTklxQTU0QjBnRTNIQjhzb21t?=
 =?utf-8?B?MVhjOUY2MElHMzZlZTNvUXQ4QkMzUGNITEd5NGhkcXd3ZWpFSmdTdVhEeVB2?=
 =?utf-8?B?OVYyYlViNlZleVB2WHcxM1FxMW1Kemw3MVJmZWpJbHNVbUpsV01vL2hZaE5D?=
 =?utf-8?B?UFhWdjhTamh0NHZGMDFRZUd4c3ZlbHpQMTJCZGdRQTVqOTdtZUVRS1ZWeUNK?=
 =?utf-8?B?OHl4QzN3V0M4czhJbCsvQjZWZzZpUkw4eE1LUkNpTm5ndW92aHVzd3BmbUhX?=
 =?utf-8?B?dmZzMVMzRVhZWlU3U2JIZEJHeEx6ZWc3UTJ5bEsrODlXaUIydERHaUFDeXVU?=
 =?utf-8?B?Q2VVQ3ZqQ3hWek4yVlc1OXVnYkRNT0R3WW9ObStDL3BVVDRPU3ZDMUdoVlYw?=
 =?utf-8?B?L01VQkZqejM2S0RXR1BIeXJZUnB0STlVTTlqUzBBYThqWGd3UHZtNDExK3lC?=
 =?utf-8?B?WVpHR0xNSWZwemEzNGo3NEViMzNUbWlCdE4vRUNvSDlpLzh6WjNQNjdpVzZk?=
 =?utf-8?B?YXNNS09zRVRteStTSmF3bVF1L3NhYS8zNi9hSnprUWdLZDNzTmpXWDV3VENO?=
 =?utf-8?B?ZEhWVTdrcytrTzNNRGhITjBrcmJ6em91YTg4d1NxYVB0TDFKdTV0MUxJeThl?=
 =?utf-8?B?OEtYMnJWcUZqK1ovdjd3WkhWZnExbVhjejV1dGg2WmZBS3E5YmI4QWU2QXFH?=
 =?utf-8?B?SytVNUhGUWpFYmVaZ292dStkL0RvUTdrczhmNnk1ZXRxSG4yRkVHbjRnWGpi?=
 =?utf-8?B?TkhjU0wxb2dleWVhNmNDVjgvYXdRZ0tXQ1hNUzg1S1BYUVJUcGZ5TXJZUlVG?=
 =?utf-8?B?R2xjd3NyZ3NHdjc0SlFzRDBUMk5oTDZyT2trVytJUW03NkFPQy9wYmxZbTV6?=
 =?utf-8?B?MEJVeDZib2JnYXdYYnhkQTYxWGNqOTQyaTRGNXk4ZzBOdW1aWWFkR3MyY3FG?=
 =?utf-8?B?bmpjM3hqdFVnUjE3VWRGdWs4Ujg4d3JxV1dSL0N5d1hUMXhXKzR2QWZndTNw?=
 =?utf-8?B?YWVPSENzazVsZXhnZit6cnFWN0hzaGpMUGx0eENYTHEvay93VG0vYm9PUVZi?=
 =?utf-8?B?eTQ5Z2lXM3BFU3A3WGRmV0ZQZzY5dUZOYVBZcDdYTFU0R01SNmE1WWZlVDBK?=
 =?utf-8?B?U2ZqNjRaNjhLc2JqdUVmRlJqcUFXSitseTd5NjlFM3daN25wVkppQm1iVVBT?=
 =?utf-8?B?QURJeTF3MGVIUkhjTVVWRzFaNnFHc0UzT1c0ek9aOXIzVDQ2UnhZZFBtbmVl?=
 =?utf-8?Q?/B26nHmbF9EyWoPKiB8fOY8A6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6077.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dbb0343-3f3a-4ca7-c7ee-08ddb4c67573
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 15:31:02.3133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wl1qB4/5XuJYT+8+RMG8XkkcYAcwRS3gMgJyDrVkaohvnHcCQIlU74z2oxnvKEDI68OWjWTwvAP4IbJHk3gRRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB7159
X-OriginatorOrg: intel.com

PiBIb3dldmVyIGlmIHRoZSBrZXJuZWwgdG91Y2ggdGhlIHBhZ2UgYWdhaW4gdXNpbmcgTU9WRElS
NjRCLCB0aGUgZnVydGhlciAjTUMNCj4gd29uJ3QgaGF2ZSBNQ0dfU1RBVFVTX1NFQU1fTlIgYml0
IHNldCAoYmVjYXVzZSBpdCBkb2Vzbid0IGhhcHBlbiBpbiBTRUFNDQo+IG5vbi1yb290KSwgdGhl
cmVmb3JlIGl0IHdpbGwgYmUgdHJlYXRlZCBhcyBhIG5vcm1hbCBrZXJuZWwgI01DIHdoaWNoIHdp
bGwNCj4gcmVzdWx0IGluIGtlcm5lbCBwYW5pYy4NCg0KSW50ZWwgQ1BVcyBzaWduYWwgI01DIHdo
ZW4gYW4gaW5zdHJ1Y3Rpb24gdGhhdCBpcyB0cnlpbmcgdG8gY29uc3VtZSBwb2lzb24gZGF0YQ0K
aXMgYWJvdXQgdG8gcmV0aXJlLg0KDQpTdG9yZXMgdG8gbWVtb3J5IGRvIG5vdCBjb25zdW1lIHBv
aXNvbiwgc28gd2lsbCBub3Qgc2lnbmFsIGEgI01DLg0KDQpJbiB0aGUgTU9WRElSNjRCIGNhc2Ug
YW4gZW50aXJlIGNhY2hlIGxpbmUgaXMgc3RvcmVkIGluIGEgc2luZ2xlIGF0b21pYw0Kd3JpdGUu
IFRoaXMgd2lsbCBjbGVhciB0aGUgcG9pc29uIHN0YXRlIG9mIHRoZSBjYWNoZWxpbmUgKGFzc3Vt
aW5nIHRoYXQgdGhlDQpwb2lzb24gd2FzIGR1ZSB0byBhbiBpbnRlZ3JpdHkgZXJyb3IsIG1lbW9y
eSBlcnJvciBpbmplY3Rpb24sIEkvTyBlcnJvciBldGMuDQpJZiB0aGUgRElNTSBpcyBiYWQgYW5k
IGhhcyBzdHVjayBiaXRzLCB0aGVuIHRoZSBtZW1vcnkgbWF5IHN0aWxsIGZhaWwgRUNDDQpjaGVj
ayBvbiB0aGUgbmV4dCByZWFkLikNCg0KVXNpbmcgc21hbGxlciBzdG9yZXMgdG8gb3ZlcndyaXRl
IHRoZSBjYWNoZSBsaW5lIHdpbGwgbm90IGNsZWFyIHBvaXNvbi4gVGhlDQpjYWNoZWxpbmUgaXMg
cmVhZCBmcm9tIG1lbW9yeSB0byBzb21lIGNhY2hlIGxldmVsLCB0aGUgc21hbGwgc3RvcmUgdXBk
YXRlcw0Kc29tZSBieXRlcyBpbiB0aGUgbGluZSwgYnV0IHRoZSBwb2lzb24gZmxhZyByZW1haW5z
LiBOb3RlIHRoYXQgdGhpcyBkb2Vzbid0DQp0cmlnZ2VyICNNQyBiZWNhdXNlIHRoZSBwb2lzb24g
ZGF0YSBpcyBub3QgYmVpbmcgY29uc3VtZWQsIGl0IHN0aWxsIGlzbid0DQphcmNoaXRlY3R1cmFs
bHkgdmlzaWJsZSBpbiBzb21lIHJlZ2lzdGVyLCBtZW1vcnksIG9yIEkvTyBkZXZpY2UuDQoNCllv
dSBtYXkgc3RpbGwgc2VlIGEgVUNOQSBzaWduYXR1cmUgc2lnbmFsZWQgd2l0aCBDTUNJIGZyb20g
dGhlIG1lbW9yeQ0KY29udHJvbGxlciBpZiBlaXRoZXIgY2FzZSByZXN1bHRlZCBpbiBhIHNwZWN1
bGF0aXZlIHByZWZldGNoIG9mIHRoZSBwb2lzb25lZA0KY2FjaGUgbGluZS4NCg0KLVRvbnkNCg==

