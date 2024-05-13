Return-Path: <kvm+bounces-17311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ED3C18C4125
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 14:56:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 603B9B222EE
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 12:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD6F31514E5;
	Mon, 13 May 2024 12:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oKGs8hVK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97F11514C4;
	Mon, 13 May 2024 12:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715604913; cv=fail; b=qPc9Uz3FfN9fKVwqb4Q7bnwmcwdjC5bCDmEfRfpG+PGjgBVwTo4hbX55liITNFo7QHxcZFf0IAyvbHvty2nyf6Rd+HNyNOrL/v9ZUCNfCtrmNDeCXZ42eXQw5Yf3rnTCPvbAzbUWZWf+LxwcqQp90D1en2WrDngYyyS8QeIb6CM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715604913; c=relaxed/simple;
	bh=58gPwEU7exCkQQJWxtW1Z8R9WJbKYqVMuIAX3b0XzqU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GdPPSYdgUxVyQ3scQd+qPS+MxtFO+Eup/8mCDSXePk9WhWlSVvwXG0x9nKteYRprNiwFwHW5ymUW2/YmJkr/ETt+64Gy/gFrbbMKxxumziVJyGzK9KKFXcNavzp1nW5jopihxRV7a9PYrdB6PgBc4Lmm+gopuDaKk9of/fb+mE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oKGs8hVK; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715604912; x=1747140912;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=58gPwEU7exCkQQJWxtW1Z8R9WJbKYqVMuIAX3b0XzqU=;
  b=oKGs8hVKXNQXveAeyw1f0GFfv9b7g6CDS7Zxx6dg+kEEEE8rrDZhWNad
   6HhtcuEVMm7N8ZpERAC5EQh6yV+ojqDI4VIz2zsNrY2IVC2jlVlfj386q
   NVnmfoVfeIU93SNtTtrzG5zSxzueJlFFgx2PTWtdwCmpnegiZbPZrlbNH
   TA85Y6Bk/jnb5nPR8cSPAqZn+AW49fTOv7NsFmHn8937ymqmYUEnQ7JFq
   A66JXcXbU2EUXMmr93aXcfu9uO+ULg/3rnBQ4BAKn+1aJdZiOa2rAi6L1
   yfccnn9lIBeUQcQ2XomceGPEUkR2KOtVc/QS0JYdPk2nHfJ+L4G3+IK7I
   g==;
X-CSE-ConnectionGUID: LMNonpLeSuuB+0IGu+iftA==
X-CSE-MsgGUID: oT2OUcQZRImc/a7Hkj0kXQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="22135885"
X-IronPort-AV: E=Sophos;i="6.08,158,1712646000"; 
   d="scan'208";a="22135885"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 05:55:11 -0700
X-CSE-ConnectionGUID: 4AjJZ52NRAWXYIIn4td6WA==
X-CSE-MsgGUID: wRPKLCjvT7qXTf5hmbZjBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,158,1712646000"; 
   d="scan'208";a="35081977"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 May 2024 05:55:10 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 05:55:10 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 13 May 2024 05:55:10 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 13 May 2024 05:55:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8CXPLDAm9KFKmhykyTPF8UPQJPnAh22S4lkrTTAUmccrM6N0YUYKUM05eUK4fblQB+U95aGPatwq9r5EP2r2GfwQI+fJcE6QzXFMUWbtcHYBqUz46nJE9s7QTDnG0dZcm2HH8+7PEMjwXTiDjPnETbBwJT3hF+IRD9asLvGLLVOlXioMU335IBigCfnPlEmd1KcbfwCdo7Pe7jHfcaga0FsijZkpNKXRggkosyAzc0qTPL0Mo9F8t1q6undbi2gTMnGNC/ijUg5e6RNlfJ9uOVYzl2u8r7cI9Pzn61sPTs2H/+1lvMzOva+icPnh2QRxs+G/Jo1vxe7K0P8Jfmf8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=58gPwEU7exCkQQJWxtW1Z8R9WJbKYqVMuIAX3b0XzqU=;
 b=da0XXMBpDRf8RjPUV7lNUd6o5xVg2HG3mKbZGu4L/geij6S0QsB52/HJ7aBL+m452St7triYseLKFFM4K6mtlCjO0mC1ZgeUQKAIJBGVus0ihq77ixIoffUYvOesxUj77O3vZnK4Z0o2mv474osDOTIxPhMRov9SqOn5CFuEZsPdxPQp61AvvT4XLUUQYB6G0uS28BcIp/GOBsm2tytQWeTdMQT4O/Wgm3ZNSGdgFlMbY4igMDVepMs1wYakSmadFNPzC3Lc/YliaxY+1ipvfUUjH6V8Qg0Lmc6jGuy6BkXXE3IxCqdMIxPKpZY6KAusyHmAx6BIhQBCcm25iqFHug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB8246.namprd11.prod.outlook.com (2603:10b6:208:445::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 12:55:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 12:55:03 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] KVM: x86: Register emergency virt callback in common
 code, via kvm_x86_ops
Thread-Topic: [PATCH 2/4] KVM: x86: Register emergency virt callback in common
 code, via kvm_x86_ops
Thread-Index: AQHal2n9eJ06+9aTNE2JbMx3/rSQuLF6PywAgACK2YCAGnCuAA==
Date: Mon, 13 May 2024 12:55:02 +0000
Message-ID: <cb59d42e0ce59c6e6f3e9af019654687b04c4f5d.camel@intel.com>
References: <20240425233951.3344485-1-seanjc@google.com>
	 <20240425233951.3344485-3-seanjc@google.com> <ZitrMAplXSCKrypD@chao-email>
	 <ZivfqQysu2hXHHFG@google.com>
In-Reply-To: <ZivfqQysu2hXHHFG@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB8246:EE_
x-ms-office365-filtering-correlation-id: 37b05cf4-9ca3-4ca7-9013-08dc734be7e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?ZGplVWpjSlRORWVEVE5XWUpYQWpYSFAxU1JnczNwcnNXdmFTeXZjck5GbGxp?=
 =?utf-8?B?YXRzY25wVmFoeC9aUUd4SjN2c1YwdkZJaEJOaUpQQ3VnbmFucURYZlFkY0Vu?=
 =?utf-8?B?SGRmNEZtbCtIY3JOVFJla1Y0VVBQOTlLZllUTXZkVU91ODVnMmhUVTBkSG5J?=
 =?utf-8?B?QW1HK3RyRW50blErd1JTekJPSEMyeXowc0ZtNzZ1ejdNOW43VEV1WDBJUFpH?=
 =?utf-8?B?REliVG9DdC9IaUxLK0dxNHVmWHN4LzVTcTRYWmVKVWFpRHdXUWVFbUE5VzBh?=
 =?utf-8?B?VFo0Mm9qTkRvSFBJWmYwVFdWVVVLR2NHWURjc3pQRGw1Tlh3bzVaeFc5N1Fu?=
 =?utf-8?B?NDJxSHJCTEl0U2lNVU9HZkplcVJkdWN6dUxTdkN3SEpBMWp6VW5yQ3Vua2xw?=
 =?utf-8?B?K2syV2ZBUGFkc3JDMHNMSm9ZUGlHZm1INkVwL3ZiR25SSzlSTXlLVmVqVVZr?=
 =?utf-8?B?cjg0aU8rdkM1L2xGbW83U3h3QTZvRjBpbmE1RWY1OWlpM2NBWWIrOGU3QWNX?=
 =?utf-8?B?UTZobXFTaVRTTDlDWExmbGpCWm5YUFVPVXRmU0I5dEJ3dWx0dk5UMjVUVTJQ?=
 =?utf-8?B?UUtJZER4RGJ1V1lCN0FRaXlISGEreDZ3dFhaa0ZjeWpuYTNJaXNzd3ZoL2s5?=
 =?utf-8?B?WFduallsaWRZWUx6NVZydjRMU3BNZVMxL245WU1nVjFuRUxvVHZNZEdBa1dH?=
 =?utf-8?B?U1ZmblRWb1dsdDlORjVEcXhzZUVpQWtFUVN1Q2d6aS9qRkxORUxtVTRsK1A1?=
 =?utf-8?B?T0ltOGxQc2VadTNFWFIrczZ0WmQ5a1ZBaDBRWmNrSkpjOUI1blZKS2dOYTFw?=
 =?utf-8?B?Uzhkem8reW5mRlg1aEsrZ0Q4bDJybGZrWjF4VmFYSmZTTXY2N3BiYWZDYjNx?=
 =?utf-8?B?WUszSEFibkdnbTNxc3diRmZFb2tKb1RjYWJNdkFwRWhobWd6SVUvSmtmY3Y1?=
 =?utf-8?B?MTVTYmdUeloxaWtFUGJ0ODJhRWZ2a3JQRU8xa2I5SGIwazdhYkFVUFVxd2Y1?=
 =?utf-8?B?NEEzeHJ6Z2lJZVZ0TEM0K2EzQkVRTGpWMEFmT0tvV2pnQ3ZuN3F3THVJeHlv?=
 =?utf-8?B?MXo3ZTZHdUpGSmEwSkU4cGVvQ3dyaVpuaHFIc0U1T295eDdFQnV2UjdsdGc5?=
 =?utf-8?B?KzZodFZNZWlNUXFtZGZpOVM5K1NlTmNjNHJkazlIcE9qNlNrdEpheTROTFhl?=
 =?utf-8?B?TnFSZk4xcEtXaGFCOEdtbS9XOXhzYml1b283QkZtbFRxSHJPSVVESExBTnFZ?=
 =?utf-8?B?akdhd0llalAzMWd0dWIyVWdEY1VyQkgyZDZNL3dIWngzR0tUTmVYK0VjTVFV?=
 =?utf-8?B?SVNNcFZmTXVsOWMyMXFudkcrYStqRkFER0tna0RIWHdpckxXWjFFZytuUm5N?=
 =?utf-8?B?SGRqQWVWR1dyMlF3d1RzelYybjRqYjFPb0lEcEtpRGNQOVpOM0kwRXNBN2Nx?=
 =?utf-8?B?Z2tObnlJcEhRbHFTZDFBdloybzAvUVl2SGJ3T1RJUHdweDk0NEZzT3QzSktw?=
 =?utf-8?B?Ny8yalQyZlpTeE9QeHpLSUUyZGl1b01UMmFPMS9Deis1Q25sQkF4UlBWcVMx?=
 =?utf-8?B?UVgzQ0hkSmh3RS9QcE9aT2pCS2draWdhUG5wcmdZZ09GTmRCcVVhMk15NE4x?=
 =?utf-8?B?UmZCMmRQYmwvcWpsWmxmTFoyTkRXMGNyZTd5Z0hkK3dVWDNPcWtQMDVySkY1?=
 =?utf-8?B?YUJ3UVB1cHpWbVNxTjl2RzZnN1Q2bEdvL2ZWRDRpQ0NleUttV1czVkpBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Wmt2R3pJVVErL2ZEZ2E2Uk16ZDZjb2N5WG1BcVhqeXl0aUMyb2dzUVg4bTEv?=
 =?utf-8?B?MFR4RVVqTXJrOHFCYm8xTXFTTXJuLzhCZEVjeWltZmd4NDF2VVVVaE0yME9J?=
 =?utf-8?B?RVhNTjB3eFdTSnV1YlB6Slc0ZFRhR3RSMjlVMlgrZTV0cXV5b2VTM0xPVFVQ?=
 =?utf-8?B?VFB4NnducjBXdDN1bUg2N0hsUnNwV3poeEl2dENjdE5HZlZxTWdLa2ZWRXpW?=
 =?utf-8?B?bUV3bHJDbzBvYk5ldTBZVnR3bityNVBnS3lnZUwzdTg2ckhzNk1BeUVkYzlu?=
 =?utf-8?B?UHNtZTFWTU1YWWwybVRib3Z3c0JLNk4xdURSSDVJZW9QYi9zRkMvTnBJblpk?=
 =?utf-8?B?WEgzajJocUdFUXA3OEhBSDk2LzRjSk1aWW9PRXAyZUpXNUFXbDVCbHQ3OVBM?=
 =?utf-8?B?OWFZYXoxWUw1dEZUS1Q4UTdOTWI4MHF5bGpmU3lYVXRLR0s3SG85Z1QrS0M2?=
 =?utf-8?B?Nk04eTBjcXZmTS9CYmVWRFFEZFAvWE5PMDhtQkt3ais5YkVYUENhZHR2Ymk2?=
 =?utf-8?B?bU5ZWmg0TE1aM3dpaU5nZ0VHU1ZWVFd3cXAwVmpMdW9sTnAzK2JBeTE4ajI1?=
 =?utf-8?B?Wkw4Unh2Qm9HZElNRktkYW5wNytSUUFqelpCOFh2WGtiOHJkaUNiTVNZYVFQ?=
 =?utf-8?B?M1RRazBaNGROdUwvWTJkYkZxN1lxaXJHUDNsRmJiN2NvL3puSGxzNHZVQlNo?=
 =?utf-8?B?SWdlMzl5cjZ4cUo1VWxIa2dyMVFodlZMZGZBZmlqQ0xxbGNiZitUaXhXOHEx?=
 =?utf-8?B?cDZyRms3M2Z2UTVxaDVUMFlMSFJZY3QyWUd3QzlES01ycGJCb3hPVWRjQ3pQ?=
 =?utf-8?B?aVR4OXJHRlN3em5JNXlES2ZFN3JuV05WemNWRkdjWlRjczB6cSsvRGlBUWFh?=
 =?utf-8?B?RUJDRjdSRlBiNjNOTmtlUE9VZEV4a3p6RVJ5M2pNdlVlZHRKNEhJaloweG4v?=
 =?utf-8?B?cmMwdzdrdUJnODg3ZnNvVVN0NG4wUjluRVM2Q1lGZGhVdmpsTnYzSE5IYk1a?=
 =?utf-8?B?RktnTDN0NmNtbjBaZ3JmR3NmeFkrZURsSEVjdHh2em5yNCtxNGNJZ0tOYkRM?=
 =?utf-8?B?bGozVlM2Q2lVSTdVMHB0SExzQnRxOWozcCtzVEFZWVo2eExnZkg4cXdZRDYx?=
 =?utf-8?B?YWYvUWtNdVFEdTA3azA1bDdkWTljU1F6QWVEUFNtb0tROGZvekZGb0R3MHRG?=
 =?utf-8?B?Z0tvTEZlWGV1cURXOXBiRHNmQUxpSEdubXlFaVFnZVRMd2xidS84Ymc0V1NF?=
 =?utf-8?B?TVFBc1gvTmVLaFRhZmxmQzR0MHBBQjFpb1FqbmZaKzZzd0NSVzZ3bVphTjZw?=
 =?utf-8?B?a0M1YlpYYWhQM0JBZFFPaEpNRW5aNkk4WHFRcEJyYVdiTHlodkl0aElTY0tJ?=
 =?utf-8?B?U3FKNm13RDV2dVViWklBVXFad3dEZDN3SWd6ZzRCM29WZlJtbUViYWJhOHJL?=
 =?utf-8?B?UnorOGhycWVjcno4NkFMbmhaVy9LTjFpYzFwZDc4b3Y4bEUyZGtZZ1dlNTY4?=
 =?utf-8?B?UFQ3cC9OUXhLQy9NZWtUTXZHU3pMYlNJNXBkRHBqSExydGlpa2IzcS9UMlVz?=
 =?utf-8?B?MWdlOFN0UG5wRWxiQy9ZWFd2dTJBZTVDb0d0Z0I1ZHU5b05QT3U2Smdpc1J1?=
 =?utf-8?B?ak5mRHNMNE1uOE9iVlJhY096S0Rwc3ZPVko5L0NsMzdZMWgrV085VjRlYzAx?=
 =?utf-8?B?QlJ1bld3TVA1UHg3d21kUW9zdkJDQVpJTmFOSGNXQ3NhdVBIVWZkOXhtQTZK?=
 =?utf-8?B?dGxDUlNxMm5WSDhiMXZQOEJ0Q28rMm5lK3BYVWtyUWxGY0t5MG9uMnFweVli?=
 =?utf-8?B?VWhFQVlucWcvSUNOREhscis2TCs3UkxlL2dUc0pOS1VLUXJFbWRLQXpHNXVr?=
 =?utf-8?B?UUtqc0pWNStwQy9Wb2pKRXhCQnByeXRLd212VWMwWWpzS3pQQVg1UEk3ZWZm?=
 =?utf-8?B?RHVTOE91T3pZRzlmZ2E4TDg1aWQ0bk5zSUlROFE1WmpRTFQzakN0elA2a2VU?=
 =?utf-8?B?eExhTHFDbGVlelpjRm1QN01vTjI3S2Q0b0dGcmxwa1R1Sk5RUkNjdHRVY1Yz?=
 =?utf-8?B?TDlrSTIyenllOWEvbW9VcWx0VXgyMmdLWlFpRFlLRGRBcG52UElPb1U3WFB5?=
 =?utf-8?Q?eJ9yEIaIBk+/QlSFbFr3wi+Zi?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <39640D0B96A97948A870F3D3AC231B47@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b05cf4-9ca3-4ca7-9013-08dc734be7e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2024 12:55:02.9705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Krs0xQeqsZj8X1NqZEnU4A0yU4EcDaOhBY/Y+gcOwO3noQ9/Oj0kXlq1U9fULxULrZ0N4o1Vy84LsZDqPNKLWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8246
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA0LTI2IGF0IDEwOjA4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIEFwciAyNiwgMjAyNCwgQ2hhbyBHYW8gd3JvdGU6DQo+ID4gPiBkaWZm
IC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC94ODZfb3BzLmggYi9hcmNoL3g4Ni9rdm0vdm14L3g4
Nl9vcHMuaA0KPiA+ID4gaW5kZXggNTAyNzA0NTk2YzgzLi5hZmRkZmUzNzQ3ZGQgMTAwNjQ0DQo+
ID4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3g4Nl9vcHMuaA0KPiA+ID4gKysrIGIvYXJjaC94
ODYva3ZtL3ZteC94ODZfb3BzLmgNCj4gPiA+IEBAIC0xNSw2ICsxNSw3IEBAIHZvaWQgdm14X2hh
cmR3YXJlX3Vuc2V0dXAodm9pZCk7DQo+ID4gPiBpbnQgdm14X2NoZWNrX3Byb2Nlc3Nvcl9jb21w
YXQodm9pZCk7DQo+ID4gPiBpbnQgdm14X2hhcmR3YXJlX2VuYWJsZSh2b2lkKTsNCj4gPiA+IHZv
aWQgdm14X2hhcmR3YXJlX2Rpc2FibGUodm9pZCk7DQo+ID4gPiArdm9pZCB2bXhfZW1lcmdlbmN5
X2Rpc2FibGUodm9pZCk7DQo+ID4gPiBpbnQgdm14X3ZtX2luaXQoc3RydWN0IGt2bSAqa3ZtKTsN
Cj4gPiA+IHZvaWQgdm14X3ZtX2Rlc3Ryb3koc3RydWN0IGt2bSAqa3ZtKTsNCj4gPiA+IGludCB2
bXhfdmNwdV9wcmVjcmVhdGUoc3RydWN0IGt2bSAqa3ZtKTsNCj4gPiA+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiA+IGluZGV4IGU5ZWYx
ZmE0YjkwYi4uMTJlODhhYTJjY2EyIDEwMDY0NA0KPiA+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3g4
Ni5jDQo+ID4gPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiA+IEBAIC05Nzk3LDYgKzk3
OTcsOCBAQCBpbnQga3ZtX3g4Nl92ZW5kb3JfaW5pdChzdHJ1Y3Qga3ZtX3g4Nl9pbml0X29wcyAq
b3BzKQ0KPiA+ID4gDQo+ID4gPiAJa3ZtX29wc191cGRhdGUob3BzKTsNCj4gPiA+IA0KPiA+ID4g
KwljcHVfZW1lcmdlbmN5X3JlZ2lzdGVyX3ZpcnRfY2FsbGJhY2soa3ZtX3g4Nl9vcHMuZW1lcmdl
bmN5X2Rpc2FibGUpOw0KPiA+ID4gKw0KPiA+IA0KPiA+IHZteF9lbWVyZ2VuY3lfZGlzYWJsZSgp
IGFjY2Vzc2VzIGxvYWRlZF92bWNzc19vbl9jcHUgYnV0IG5vdyBpdCBtYXkgYmUgY2FsbGVkDQo+
ID4gYmVmb3JlIGxvYWRlZF92bWNzc19vbl9jcHUgaXMgaW5pdGlhbGl6ZWQuIFRoaXMgbWF5IGJl
IG5vdCBhIHByb2JsZW0gZm9yIG5vdw0KPiA+IGdpdmVuIHRoZSBjaGVjayBmb3IgWDg2X0NSNF9W
TVhFICBpbiB2bXhfZW1lcmdlbmN5X2Rpc2FibGUoKS4gQnV0IHJlbHlpbmcgb24NCj4gPiB0aGF0
IGNoZWNrIGlzIGZyYWdpbGUuIEkgdGhpbmsgaXQgaXMgYmV0dGVyIHRvIGFwcGx5IHRoZSBwYXRj
aCBiZWxvdyBmcm9tIElzYWt1DQo+ID4gYmVmb3JlIHRoaXMgcGF0Y2guDQo+ID4gDQo+ID4gaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL2MxYjdmMGU1YzI0NzZmOWY1NjVhY2RhNWMxZTc0NmI4
ZDE4MTQ5OWIuMTcwODkzMzQ5OC5naXQuaXNha3UueWFtYWhhdGFAaW50ZWwuY29tLw0KPiANCj4g
QWdyZWVkLCBnb29kIGV5ZWJhbGxzLCBhbmQgdGhhbmtzIGZvciB0aGUgcmV2aWV3cyENCj4gDQoN
CkkgdGhpbmsgd2UgY2FuIGV2ZW4gbW92ZSByZWdpc3RlcmluZyB0aGlzIGVtZXJnZW5jeSBkaXNh
YmxlIHRvDQpoYXJkd2FyZV9lbmFibGVfYWxsKCk/ICBJdCBzZWVtcyB0aGVyZSdzIG5vIHJlYXNv
biB0byByZWdpc3RlciB0aGUNCmNhbGxiYWNrIGlmIGhhcmR3YXJlX2VuYWJsZV9hbGwoKSBoYXNu
J3QgYmVlbiBhdHRlbXB0ZWQuDQo=

