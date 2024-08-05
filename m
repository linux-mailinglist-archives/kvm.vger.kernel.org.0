Return-Path: <kvm+bounces-23223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07AE8947ACC
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 14:04:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A8361C21202
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 12:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BFC5155C83;
	Mon,  5 Aug 2024 12:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mcmEJ8zN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03A749650;
	Mon,  5 Aug 2024 12:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722859452; cv=fail; b=pSzbwety2hCFjaanxwW5zxx/Qkp87ku2xXZ3oBw9/ZMViekmIGFkGW73h5adpT4vdTm0w9E/J8G0Zzt9IjZrt+Ps5wmIh5pgSXLYYp5aSnmex34bRIpwAnG+MP5XySg3g2beZPNcyuK36QgTCQDjeWoAv/PzxUVGi8ajFRG2TOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722859452; c=relaxed/simple;
	bh=qIYDuYGG4/RknX1CnfnG/IduQmuoKOLOgAndzFHk+m0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nXRvJaBmT0lwgaIf4a/JiO8Y/tKbn7ubsKLd7XUqDaILeScDMpoQQL9ATPFzONEAYtSv7603AqepK1LlJF0CKghoZWSqJLD2dnL9impwazBkVynxMNVF40pMdhNeNY6nRUXsJ1DSPYfQbRcyVO0e2xa4Z94ZE0H3a9oEOmyaV7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mcmEJ8zN; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722859451; x=1754395451;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qIYDuYGG4/RknX1CnfnG/IduQmuoKOLOgAndzFHk+m0=;
  b=mcmEJ8zNMunQo3GUxUs5I58NEaoMUfPVfczD6edMV3x5fUwFdpbBcupw
   E39D6Wta+iHwBbatwIAUQQ7jtM+MTHzjqGaVb3IdskYJuVpWqePz1jiJB
   PAHnDIylitykHQFwJHkMkTyfx1reqj+chG60gLUAnzoG6sdFkwcqJ4Xdg
   +FCp2JtVjEDAdl7tZPbDjsYSd/pWVU7ApQ/irvdGNsWNGowYKtmmorNlv
   L7+Gv/6qKLgAIv+jvY9iPjs9sDkM2KQY9bBFcVPLqJfeRRr1eG7ejP43a
   2cjWd/75hJwAva7ktDaclLJDaHOXffu/Kw70UMQd/cSjWtH3S9Lkg49mh
   A==;
X-CSE-ConnectionGUID: jnLD1vglRCyu2li/u9asrQ==
X-CSE-MsgGUID: j8XloohuTWGkX195nZdA3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="20943798"
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="20943798"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 05:03:57 -0700
X-CSE-ConnectionGUID: eDFPEq5dRg68e6WOdywyNQ==
X-CSE-MsgGUID: XFfVB9OwSrqGybAhMLrx1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="56366950"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Aug 2024 05:03:56 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 05:03:56 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 05:03:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 5 Aug 2024 05:03:55 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 05:03:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aLlo05VMDxJHs90pO26YHsgwBTXtZNdpTBnABrjU5Np04aHo+JdC/6ReZW+HXbxnkrcaIE23PpnN6Fp8fokKISwijxvOjQQ+kcpwMuXe1VwwyO6FnAldyV/MXKSFr/NjHPqBY3ecEGXBFrd2t3LCyL9OaTC7fCyDnrPXUEG/e0ZEi+zSD6oEIZcPAYDpiv+XBgM3W1QrNzZ1TPNlGIKCPWGDX6fkw54DQzbWbWApXH4d3cTqtQtYsqtJHXyeVILZ+EX3pSHu9BV0RBWHF01rNkDEeg7jeBDG1XLJN0jM4/98s4o64v/HwuOPRAmNFloMqgJ4RdTf3WV8LxfN4KJDWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIYDuYGG4/RknX1CnfnG/IduQmuoKOLOgAndzFHk+m0=;
 b=VG6XTWhOIimjrnyD/awjYzxKmvtG6iFlQGoG+WMJ94FzLPrr3fu+tmvn6AD4DIu4Xg4rGKsneeiK4utGeGIzLrP+cXGpXk1svvIavVriwvaH2LY1r+EVRGAv9XQUQFu92K/1x3nsD1rr1cBEke8SlY9TMCFbtacDF/UyLupZ16SbIjrM2z2XTXx6I5uQOCcXEdKVPx609Al1QHeYIHgLR7JPeFO46eOOrEL8ZRkzGO4QwLRytlg4tw5moGJiu+0qHqaAbv5gf2tgN79jGTLxoMT2xj/dmOuPsPFcW7VV1AQjwT6nmwB43HL1r9dZNCmX71Fz5taWA+TOOXgAId6jhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6920.namprd11.prod.outlook.com (2603:10b6:806:2bb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Mon, 5 Aug
 2024 12:03:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.023; Mon, 5 Aug 2024
 12:03:52 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
Thread-Topic: [PATCH v2 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
Thread-Index: AQHa1/q/RqaV1BHdY0ScicyWx0mmjrIYrxsA
Date: Mon, 5 Aug 2024 12:03:52 +0000
Message-ID: <bf9dcafe3c2eed3f0f2f87161336115bb4535011.camel@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
In-Reply-To: <cover.1721186590.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6920:EE_
x-ms-office365-filtering-correlation-id: 4597f8fe-c1b0-4cd1-e500-08dcb546ac82
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dEdVK2NSQmNwY3M0eThiWWVybklDaGZpaGttZjBOL1psSVVTMXRUbHVtVTU2?=
 =?utf-8?B?RGtPOE5jTjFxRGNoSG9DNzdIMWpCYk5IdXdVSm5DNkI4Ny80VVNoTDhiVzNp?=
 =?utf-8?B?N3JHc1VaRlkxSGZaTlhaaEF2MG9lSGx1RGZaN3o2aWFIZlBTbG00RG93Mm1i?=
 =?utf-8?B?TnAxb3AvOHV6cFZMTDJMZE1UZmdUcGNFdmJKSVZZZVhULy9KWWEvUm1VQ1BV?=
 =?utf-8?B?by96RzJpYnZQK0IrRGdoQTZ0MlpMcjBOYUM4YTVOeDc2dUZIM2R5MEpGeGta?=
 =?utf-8?B?b21WUXl2cWNBVm9tN2JpUnJIVlorQVpIRlNnOFlmbHRFZ3l6WUFVQXlxbzU5?=
 =?utf-8?B?UWp6U2h5UDA2b2l3NGNVdmw5eWROeCtPNGpDWllEcldpV1Nac296N2ZqTjhS?=
 =?utf-8?B?WUU3UkM1MGhJa0YwNmRBTHpxVTIrdzhDaEdETHR6RkZ4c24zOXl2ZkJVNGJS?=
 =?utf-8?B?LzU0Tlk0R3ZVTVdzRjh0bHp5NjBoT3d4ZUhwcU9IZEduQnU1OHBtZ2R6V0Na?=
 =?utf-8?B?Q3VSblZuNlNQY2ZVcHgxdUs0eDB0Nms1ejZ3TW0xR0dHVlJRYmhMMDRLbldJ?=
 =?utf-8?B?Q1lVbDdXd1RQQzVmclc0WTE2M2dCTVprcUlEQy8zS0lrQldicmRDTm9uY2lR?=
 =?utf-8?B?VUpnUzNTMlhINE9MWnI2QzM2eGlNZ0puc0lRZFVUSm5GOUR2TDY1aUpicVZY?=
 =?utf-8?B?SjRhTWJ1QW9EMCtMdW1ETHRrY21Sc3VSNm84R0RBWk16ZHhIN2N1NWZrWnVq?=
 =?utf-8?B?WURxdjU1aTBMK2NjNTlNcnYwajU3eUtYK1k1YVNDL0x5UlhhQ0phWHpxbTFs?=
 =?utf-8?B?SjFXQ05VeDFrZlNweDNqUStVemdwWEhRQUlQbFpWK05DT2dGNGpzQXJwS01k?=
 =?utf-8?B?T3pzMm5nRlg3dlR5RGJycDZHRlo1ZTlvOFl1SitEekdqcjRuM2d5UFlzT2tG?=
 =?utf-8?B?NUNiek9Ra1M5ZG9uTFZjUThzZWlNN2swT3FwU0t3TnF1bXA2ZzZyVTBJUDZn?=
 =?utf-8?B?d1pZOC9scURMdnNNNFhQbmtwV0xQUXhxMTBlNHRSUU0vY0tkdmkxR1U0RjZK?=
 =?utf-8?B?WGhWdTk2VFcwVXEySjBMblJWVjBNOU9HMnNZSElpTWI5WHUrZXFsNUZhREhE?=
 =?utf-8?B?QXN1QXJHUVI4REUxYUVORktreG1zaklHcSsxdXlVOWVqaU92RFFmMWlXcEJx?=
 =?utf-8?B?V1V6QkdITitQMzhud1pXRDdrd0xqMmNLUndDMWh4NGo1OFRsMXBwOThPdWZo?=
 =?utf-8?B?dkl5Qll4S2dCc2pWSHVvTnZzcCtJbDRGcXpLR0FYS3pCaUxNVXVlVHBlQndC?=
 =?utf-8?B?eDlmMm5FZ3Y2TDcvVWk0SlNuSjlnMnZ5aWRDakc1VTFLTmxUT0RGL1B3enV1?=
 =?utf-8?B?ZnVidHEzVnB1aW1rUzkyZUJLc0tmczBFZFlBaVlSUFAzMVhPT2xxcGhOS05r?=
 =?utf-8?B?elFvVXkvYlBiNWZSSkQ4R3pyZVk3andGazJmQ2t4VXhlSTYzQ1ZPTnc0Mi9B?=
 =?utf-8?B?QkZDM1lYZjNSMEJBaUN3UU1RdThBT05ocGhPdzNWZmFaU0xKZ1p3cVdLWFNn?=
 =?utf-8?B?dElYcXRqb1pIRk9KMXY3ak5pL2U5SjdEbkM1b3dBb3dzMHNjT0VTSTlGQU5C?=
 =?utf-8?B?OEg3Ri9pMTNVTnduVUtuRHNHYnU0UkZ3cHVLb3dSMTk4c2NhQTdEOFlkR1M4?=
 =?utf-8?B?QVlPb3llZ1RIYzViQjM5ZDMyY3BGcDcrZUdRSkNuTkROeFRQOWtiL3ErTHht?=
 =?utf-8?B?NXdub1JYVDBJZVJQZ1Mvcnp5UXg0L3F0RE5mSW85K2hHaFo2VXlhdU1SMDZQ?=
 =?utf-8?B?UFBpYjNoSzRCMU1WdkNGdkNESm9OS08vanBvQm11R2M4Y2xWYXZHbGtQR1Fl?=
 =?utf-8?Q?zm1930ycvIMTX?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VEhaMHNhdEYxMXoyaWZ0SGVsQ25xWFBTdmlxalVSVUszTmNMcmo1V3pXVkN3?=
 =?utf-8?B?S1BqL3NwY3E3d0k5bmkwR2UwVVJzMFBEc2VLRXl2R3FQREFKYitOVGtvN2hT?=
 =?utf-8?B?cWFTQ0tFSVd3ai96SlhCQWoxallsMTBOUmdoSThhdHhwSERCZXBKdjhGMzRx?=
 =?utf-8?B?QVhKUXZFLytrTnZUQ3Z6WmFRZHM1ZHFIeWJzKzFkbmltdVE0a2dxTi90Z1J2?=
 =?utf-8?B?Y0dSRXdWazFsdjJMU3luNFphOWx5MWZMUXk2R21GZENGSlNtamJPZkNZY0xw?=
 =?utf-8?B?ZUhqNzQ1ckVaaVVaRDRiU0xUY2JKZGt6UllEUlNsLzlRWDdvNmpKTzlUQTgr?=
 =?utf-8?B?bXNyTjllMzd6WmxCS3QvRUdiVVFiQkRwbUlRa2trRzUwYlBPZDVJc0wrRitG?=
 =?utf-8?B?NGNzL3JjeGkyb0lLR29hdVlibVhPN0dSTnZrL3J6andRUFVuVW9tY29hbnRj?=
 =?utf-8?B?QllXWmxiS3F3UmMva0duZDY2U2pkdFpsY2oxZkxVREFSa2gwUnJOUEJLdnlZ?=
 =?utf-8?B?U3UwUjlCN0pVaTJsdHBiNXI4VDB6cEJYS21Hc3dPV1RrVXFiNElGclYxOUcr?=
 =?utf-8?B?UlhnbEV0QXhMaTVzOWRUNmcwMjJRN0dKMTRlM0Jzc2h6cDQ4TDRrdk14NEhN?=
 =?utf-8?B?Zy9lTUZWYnIzck5MWHl2bUJGVmZCYlpkb3NNQWdubVZBcldqVVdTSzhrUkpJ?=
 =?utf-8?B?bEl3ZmtRdEFOOVZ4Y0dReG5EVktiU1hmZVpqaEpPcE9UQUpOdHpSRUwrQU5o?=
 =?utf-8?B?VHZBYngvTkgreUcxQjh4Q082VHcyZmdzTElBeVpOdTd3cGtkZ0Q0dkcrMHlK?=
 =?utf-8?B?RW9pQXJMbUJ2eVdWT1pTQXM5SVRaY2J0emlrK2ZyK0lBWWcxMUNnZEhvRnNL?=
 =?utf-8?B?eGR6Wkk4UTUxTENhSVRPVjVBM0pEbmRKaHd6KzIxR3d4U0UyTjN0QmdTRDNM?=
 =?utf-8?B?QUk4OG5wMExqUWJjekgrYVJSVWRWbGZjR3dJc21QaHBwTmFRVitaR3pYQTls?=
 =?utf-8?B?TkRreEtwQStoVGhwTDdKM2hXNzFUYUk0RWlpQU53WWF2emNxdkk1alNVTEdn?=
 =?utf-8?B?eWhCRWZSWFp4N3BUaHlrL2hSTzBoZ0pxb1lyWHBWZ291N2dVLzFySXIzRlJI?=
 =?utf-8?B?SUtyKzhFZ3hURDFZNXBXZlVmdy9BVERlRDhiM09idzNhbHhLNnhDckdHQVRH?=
 =?utf-8?B?VEwzWEVuTTVUQXNZTzhqMFROTnkyTTBZTFIvdzhEamxwbE4vRnBHYVlGcVJK?=
 =?utf-8?B?bklMSnR2Y2ZFZVN5TFZBdm82UFFJdnpXcnlHMXY1TXZJbTl4djhMSTZ5dVgv?=
 =?utf-8?B?SE9QeU5pL1lwakhWQ2JkV1lOZWxJOGFYYlorNFFBRWwrUWtNLzEreFFyVUpX?=
 =?utf-8?B?VFhobmg4UnBYdjUycW4rQk1MSTV2ZExzT2VrbnJTN2VXRm55ZWs0dGM4OGY3?=
 =?utf-8?B?MGFIMnhMbGJUQkJNSzdRLy9pdjkyTll0dnFmd2dZWEpsL0tXaVh2RC91WDlR?=
 =?utf-8?B?UFZYNXBsTGZSV1Z4VG54WEpWL29NQXJ3SkV0TmtaK3BBWlJSTWxwRFA3MFl4?=
 =?utf-8?B?K1B2U29sVmE3Q3JVc21CY3A0OHJMcEtETWQwYmhKVUJ1THMrcEFyQWtCYlB1?=
 =?utf-8?B?aExjcW55clYxNE02U0NlZG1LZHNUWkE0ZXAxRWQ3SmVvSEJBb3U4WkFxNjVh?=
 =?utf-8?B?elNBM3RYeUpuZmp3QUY5M0dVMEQvUlA4dlpNSXprN2JsNlFiREY2QnpmZzdX?=
 =?utf-8?B?bDRZeGdMeHFNS2ZKeEhtZnBFNjNEanQwc2dNaGRJNjNxOXM5Vi9HajI2Qm1u?=
 =?utf-8?B?cnhDeCtRUWhraHlpQkNiOE9ZblBOL2VEN3ZXdWRlMUhJd1owOHN4cGVYN2I4?=
 =?utf-8?B?SEVaSGFiVkZFSGlId3ZNT3AzSlZiS1MwZldZQUlzR2RuMDdTZklrWFV3UUtQ?=
 =?utf-8?B?cnVtKy9BS05rOCtjN1BTbjM3WjV5dHJpNkJxUDIxSHEvQUJYZ3VpOG5QRG5a?=
 =?utf-8?B?Ym9QK0JETW5Wb25qb0RIY0RiMDU4MkxNM2pMTGFvYTl5MmQzYkpPUlpZWDZX?=
 =?utf-8?B?Z1FCTEwzYjVlL0pTVTlBT1VHWmdjNXBGMlFkV3NzZVpqN2psZHJQZ0RWVVlE?=
 =?utf-8?Q?LT2CSaeGWupKOko6wykv02lUX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B124F9C2A5109F43B002F0920AE5805F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4597f8fe-c1b0-4cd1-e500-08dcb546ac82
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2024 12:03:52.5840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dpX5WdKKyRhKXNPKDoU6n5uOORp08Rk0Jxsm840KjRlEfqEaIaTJntVoBNb9t2aQDGDN605s1X6UoQ+xS+SrOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6920
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA3LTE3IGF0IDE1OjQwICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IFRM
O0RSOg0KPiANCj4gVGhpcyBzZXJpZXMgZG9lcyBuZWNlc3NhcnkgdHdlYWtzIHRvIFREWCBob3N0
ICJnbG9iYWwgbWV0YWRhdGEiIHJlYWRpbmcNCj4gY29kZSB0byBmaXggc29tZSBpbW1lZGlhdGUg
aXNzdWVzIGluIHRoZSBURFggbW9kdWxlIGluaXRpYWxpemF0aW9uIGNvZGUsDQo+IHdpdGggaW50
ZW50aW9uIHRvIGFsc28gcHJvdmlkZSBhIGZsZXhpYmxlIGNvZGUgYmFzZSB0byBzdXBwb3J0IHNo
YXJpbmcNCj4gZ2xvYmFsIG1ldGFkYXRhIHRvIEtWTSAoYW5kIG90aGVyIGtlcm5lbCBjb21wb25l
bnRzKSBmb3IgZnV0dXJlIG5lZWRzLg0KPiANCj4gVGhpcyBzZXJpZXMsIGFuZCBhZGRpdGlvbmFs
IHBhdGNoZXMgdG8gaW5pdGlhbGl6ZSBURFggd2hlbiBsb2FkaW5nIEtWTQ0KPiBtb2R1bGUgYW5k
IHJlYWQgZXNzZW50aWFsIG1ldGFkYXRhIGZpZWxkcyBmb3IgS1ZNIFREWCBjYW4gYmUgZm91bmQg
YXQ6DQo+IA0KPiBodHRwczovL2dpdGh1Yi5jb20vaW50ZWwvdGR4L2NvbW1pdHMva3ZtLXRkeGlu
aXQvDQo+IA0KPiBEZWFyIG1haW50YWluZXJzLA0KPiANCj4gVGhpcyBzZXJpZXMgdGFyZ2V0cyB4
ODYgdGlwLiAgSSBhbHNvIGFkZGVkIERhbiwgS1ZNIG1haW50YWluZXJzIGFuZCBLVk0NCj4gbGlz
dCBzbyBwZW9wbGUgY2FuIHJldmlldyBhbmQgY29tbWVudC4gIFRoYW5rcyBmb3IgeW91ciB0aW1l
Lg0KPiANCg0KS2luZGx5IHBpbmcuDQo=

