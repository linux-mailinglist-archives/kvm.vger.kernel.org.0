Return-Path: <kvm+bounces-19912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F352890E0CC
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 02:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83CE81F22875
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 00:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 584F31C3E;
	Wed, 19 Jun 2024 00:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vq/FGAoE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C4F6AAD;
	Wed, 19 Jun 2024 00:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718756565; cv=fail; b=kjGGu8vBjuLshYC9Ich0RKoW/JFyLieuqUHLAQZ8X/VbA1dHfTasduOx8DU0GRANa47+7zxGsKzWmCuj9Sd92vPdUiGE9tIbeGO0u8FuE3pxrMnKEbvCZ9eAOvnAdUb0Y/UVT0YZn4hCwW22/cw/aFbpKP7bzh86WmV8NqNCF1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718756565; c=relaxed/simple;
	bh=GpRrcWlBHModgXZ3gUbwqqueBF5ygk6CxMB/d4xFYbI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U+neTrpFq0W17AZIhbT2ImLHMWxgW4eBTAvA3u9F2iNcuVjWbAA00nUIaAeAI4Ym2GzzOi+PRVVJARiFaO69MAgDA1LSopuoDtji0Gg+NcBvrtXX04UAaT6hyHC+DMaU4CpVw1/d2I/b0nVBrn0lWANb4QkcatzoqkwhiHUUE/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vq/FGAoE; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718756563; x=1750292563;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GpRrcWlBHModgXZ3gUbwqqueBF5ygk6CxMB/d4xFYbI=;
  b=Vq/FGAoEzIi3qj8906VXCDuncdYfw/86qHhS2Ysog9ML8nsdje0imguL
   CrW8T3WaDmsf11GX5igPtm+0Jb+SNg4rmRSN5FBK7vaNuLhd+VQ6q0tKm
   B8A34M8i0pF0tRMPZYDScr5cCp79tTMk44oBzszQhrRqzGCHddWxJQ3Dp
   u+G1Y5/ZRJFuijS6/wRs3ufZbh4owSelF6oCeqYvAV1DHI17MnGB71HcI
   LmH0wojJPlD5+PmgI7Js2syscAK+DUpq5HGtYq30doQ47PjxHwFGiz1wR
   9WAP+8XHOZvXJ79JwKXCXwvYfr6UA430cSvlmGHUBAKiv8y626/KzjUY4
   g==;
X-CSE-ConnectionGUID: GUz58Vf4TlixzSS+UMLCbw==
X-CSE-MsgGUID: 6/v5fjiySjCSFwyehOdPpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="15508431"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="15508431"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 17:22:42 -0700
X-CSE-ConnectionGUID: SCtkA4dMT/CVTSeAqyMlzA==
X-CSE-MsgGUID: S+QeZpjZSsGpX6SaLS4XXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="72938277"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jun 2024 17:22:42 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 17:22:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 18 Jun 2024 17:22:41 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Jun 2024 17:22:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCYd3ADlQ1RjGGld7WAQf9wwfd/tcFSaz81eyO1BKMJuXCuyHXTF3kOpMVlj5J/nki5fUxdWyF2PzEg80ZumGlJPbFRHICQsKM7W5CXxcY5NYKSQ21oUOzohg2icmkzsvataghT5jj+szMch9iYLkSXcDRZoSnkp7ZsR3td39jdC3ZpXgYBR3ri9TDmh4tuTJReRk54dHW2JLX/JEiH3E4gyvhzYQAarYI3get76zZh9DmbJGBgU5ZPzv3po87flITrhUD/tAB2NW4y9KSu80IEh8zDBYqoLC7zMH1mywYuLSq0f/NXIfnEF3iJrUVj5fCPG7fm8I0qoLbrnvct7Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GpRrcWlBHModgXZ3gUbwqqueBF5ygk6CxMB/d4xFYbI=;
 b=VSP4JmXcOoEqVmkjRKqUYfe3CN/UXi28P4Cn0gXnbXJiHFhZ1PmlULZ/vKvJaF433ZonBRz0oC3p0KSPOrHtZ2icFYpd2ufnooNhyKSXL4ce2YHn72niCoYdv0e42AW6KZS1C76rFyg0Ebt4gC5eyubylQiWXi4EgsLEpmDPt6Wz1u928rG/QjBnplApOOe4NXNGv7N/fmsNbHIkKD6wpTQFPfEjbr5loGNLhl+A9CaudKX069TBKMvYw1Xs2ytvOH9S8F47KL53PhF93+CQBggzrYgGQ7l9C9PMP6oSvkBhps+2a7p7ALvvCHCSyoHl/XQ1Ua0+0O/jhVGo5GYzGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7756.namprd11.prod.outlook.com (2603:10b6:208:420::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Wed, 19 Jun
 2024 00:22:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7677.030; Wed, 19 Jun 2024
 00:22:34 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "seanjc@google.com" <seanjc@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 7/9] x86/virt/tdx: Print TDX module basic information
Thread-Topic: [PATCH 7/9] x86/virt/tdx: Print TDX module basic information
Thread-Index: AQHav+UN+5f7ufMUykm4ncHMs4sn3bHNjayAgACwFAA=
Date: Wed, 19 Jun 2024 00:22:34 +0000
Message-ID: <775bb92d9e201f5efc2a939def1ecaafdc9c6bc0.camel@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
	 <f81ed362dcb88bdb60859b998d5b9a4ee258a5f3.1718538552.git.kai.huang@intel.com>
	 <d8b657a4-ab2d-417e-be24-cbbd7ce99380@suse.com>
In-Reply-To: <d8b657a4-ab2d-417e-be24-cbbd7ce99380@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7756:EE_
x-ms-office365-filtering-correlation-id: 467a91df-6a58-4f6b-5d7a-08dc8ff5ea59
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|376011|1800799021|7416011|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?NUNXZjZtMXptdVJ1RXZsZlRJYjZadk9kZGlpL1lTczZNZTRjTzNvdXIrQ1Q2?=
 =?utf-8?B?eHRnTm9WVjNMc1ZHWk0xZmlVUjhqTG8wWnNzRlkzeEF1dENuTllpVmdZaTNR?=
 =?utf-8?B?aWZ3MThKanRqTjg5aVBCSEs5Q1ZGSmVXV2ZWOE9iVEloVFI2M0tMN0FJN3I2?=
 =?utf-8?B?K3grRGY0Yk1KKy80bmgycWhuWU5NMytSbEVDMjI5ZVFDMlg4WnZ1eHNEZC9I?=
 =?utf-8?B?TEhSL1VYMG1pSFhMTlQ5RHV0YzE3VndqbnZFZWdsQVJXbFoycGd3bU5IazJZ?=
 =?utf-8?B?TUFacUFmV21lbkFlQzhwU0praURhQ1dvOEQzL0Q4STNpbFdHSHdYRjMyTDR5?=
 =?utf-8?B?NUxxRTYwYW1ydzBhSmFlQ3FOWFViOEkxeUhOYWZvYjVRUXpaUmtrQWJSSnNW?=
 =?utf-8?B?YUdnTUpOcEw2OTE3SjhrNGRaL3JEb1VwV2luWUdzZ2VBMFBFNTkyN283UHhk?=
 =?utf-8?B?U2RQY3h5S21hc1hncGN0UzA2WElobktoL21yVU4wVmxUT2dwb2p2bXdGMDNV?=
 =?utf-8?B?bXJ5bHk1SklSRDNXNWh3L3BVL3pIWDlrY05ibGJxcll3cTB4Q3NTYjRvckFw?=
 =?utf-8?B?ckpaeENYUENYRTV6bDF1NEttN0RQMWZUSm1jenZSSnhQREV2MnZCVng2YlZZ?=
 =?utf-8?B?a0hBbkxEMUhRMVZiQzRYeXZ5QnVsdWkyS1V6bnh4SUN3VStDOFM2bGp6YUtr?=
 =?utf-8?B?clExUi81eG9HUStiTjUvUW1aWFZXSTMwc1EyNE9IRUtwWlVoZktxZWI1ZnM4?=
 =?utf-8?B?S1lKcHlJTkF5SjVFaTJzUW1IWHlVZXNyNmF1SjVHTWRNaGJzUW9EemhNZ2xk?=
 =?utf-8?B?Z01NaXhDU2lvYWNIRng1ZTQ0MjhnMEtuSW8yYk9nRXpyTjJPektnSmlnRnZM?=
 =?utf-8?B?bnpXY3dCWnJkOElVR3BNcmFDSFF1enJqREZIcC90K2VQUHEzNE4wMWhCMWNr?=
 =?utf-8?B?VzJ3SDBndUZsZkdJS3ZwTzR4VjQwNG04RE52VUtJUWFieHNEcmRDVFNjK01G?=
 =?utf-8?B?VU1ydzc4VnVSY083S0R2dU95R0tVWjgzaEF3MUxnL2p1b21CQmlJcUJrd2tn?=
 =?utf-8?B?MHpVL28yenpKNVRTR0YxY2dnL0NIK1E5S25HbVJKalNzT3JuZ3VMN3F3bHpu?=
 =?utf-8?B?TnRWM1RZcXNZSE5YcjZyL3QxVE5BVzhoeFJuUjdqbzhBa3JLeDdVUTNSazdW?=
 =?utf-8?B?MnQxV0tzRWFWL1BwaWdlWlhTdVF5akI0SDBhM2ZCRjdMTEd6SHZWczlwWENB?=
 =?utf-8?B?b21ZSGZkbjk5ckhJaVYzZ0hvcFU1Q29CRy9TZW4xZUM5VXk0TGkxZmFiRTBJ?=
 =?utf-8?B?OElhMFRRd21rTkptMVM3TnQ1SXpXMndwVDRZMlcvRVpadENZTU1HSll5aWlT?=
 =?utf-8?B?UUswNU5QcXpySElkOUU0Q1ZJUXY1U2JjelJoZmI3bnZXVmpUZnZSb3FYMFdV?=
 =?utf-8?B?QU4yTVlvNDMydm5wcGs4TVpCN0I4aEhjN2NqcVdtekF5UVlqY3ZhY3k3U1BR?=
 =?utf-8?B?ODIrQkVyMXBzVkQ0MFZxVTZxc2k1aFhOT2RQZU5Ja3RESlpTWFFjK3A2N05X?=
 =?utf-8?B?dTBRUTF4Q09Vakd1dk9wdGtKRHgrMkJLME9CWG0vQ2t2b3ByYXlIUGwvQjc5?=
 =?utf-8?B?UzRtdFRTS1Q1SmJzS3NFRmRCV0pRcForUFNsamc2TmJsQThlMUNSSGpEZldQ?=
 =?utf-8?B?bjhDTDIyRjR2dHRiQkVHYm5lelBrN2ozeHJveWFwejJqMldmT0RLbURqeGkw?=
 =?utf-8?B?NEthcXQ0WWdFVGM5QUI1bndMUG1SYUpxRFhVZDRaZmlGUWpUeG9aRkNURCtn?=
 =?utf-8?Q?LK2LzdhU7A6gpeqHDzi+MEBzmMittlmUjIgDs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(7416011)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UmFUS08xTDN4dThIRFhwWmZwNUlIQ0V5QkU0cnhkTVFQMCtNRHBDZnRyb2lY?=
 =?utf-8?B?VDZKVU5zWUF5VXgrQ0ZSbFkycVFaaXZ2cHcwWWNDS2RvU3pvYjN0d2JNZ3lo?=
 =?utf-8?B?dk9UNWltSzIwZnY4bGJoS2NSalR2NjdzS2lveHJXaUtNZjNnakVyY3FwczRj?=
 =?utf-8?B?ajVTdXZrMkdCVDV1Q21HVmJaQmpSMjQwVHN5bGdJNUdLS0E3TVN6Q0JxcG9h?=
 =?utf-8?B?THlPMXZ3bFFTWCtZa0NBRHJ0NWZkekxCVFhUNzg3ZEozQ3VJRmVZSmlHTTJD?=
 =?utf-8?B?TjExbGpNVjl1MWRZajBKc2tHRE5FMGIxVXFwdmNVSi9GUnQvMmRJK284T0Vw?=
 =?utf-8?B?RmlBd09ISU5DQkFVV05iQysyWG9sZEhXNS84SnVqWG1yOUdyU2txWXQxQXVq?=
 =?utf-8?B?UENyVGd0bmRxb28wZFk3aTR6cWIvNDdYOEljeDI5YURLRVU5a2lCbkpYWjFN?=
 =?utf-8?B?UTd3RkdRQXhDQkxzU2ZJYkZRNE1Ha2xXcGo0eXBpVENQMnZPZWM4NDROZWJO?=
 =?utf-8?B?KzFSZXhFWWljMC95Y29heXpVam9EdTRqUU9pOTVuM3JuclRIVStIeDU2OVBz?=
 =?utf-8?B?cWNvcFZUdTZvaTFYcEhuREkrSTFTSW41YVBpTUNrZFJkUGczRCtDQ1BudUhO?=
 =?utf-8?B?NGZoSSt1N1NYcS9HaDJPYzJaSkk4Qmx6dE9Hckl5V1h4SHBpYk96QWRxSVJE?=
 =?utf-8?B?N2RvSGF3bG9oVmJrVHdHV2RCVXU4TUtzVi94L3JNYlJxYVh6dEJBRC9rWCt2?=
 =?utf-8?B?bTR0a0FjWEhDOWdPeG1pOCtHY240eEhScUJ3VjB2RGFnNllWZFNzT2VxaXgx?=
 =?utf-8?B?STVzdGs2bHJscmtjOTgrTU9PSUhrUytSbCtiUHlvczd5aGdmdlozM0svRURC?=
 =?utf-8?B?Qkl6cXdkeXB0NmlRcWFKNnFqUnR2Vk5nUjRJOEZkV05hOGhrTzVwVnA0aFlX?=
 =?utf-8?B?TThEME9QamhtaTlSRzBwaWFVc3F1NWlJOU8rTHQweVRmRVp4cTNaQVhtN3JW?=
 =?utf-8?B?M29DaWFZL3A1SHY2b2taRUhyL3VHeERrblUxcHY2ck5NSHVRKysyTDVxMXp3?=
 =?utf-8?B?YWZOb3kzYjNUYUJhckk0WWdxT0xoa0xzU25ReTllU0tSWEdzZmo1UE1neUNQ?=
 =?utf-8?B?dkNyaFU1bnBFM1lvR1pCL0kxSHl2T1pETGlZU01Ma0RmdHBvTTg4Qmltenpp?=
 =?utf-8?B?L0hLQnp1b013elVoNDNJMnppQ1BzdTZjeHduTHZ3S3RldlZZOVMzM25Ya2py?=
 =?utf-8?B?WkRmK3NHRm13U2FRT0oyZWMyQTdWRk95ZFhtVG92ck9KMkthbTlHZ2FKQzVr?=
 =?utf-8?B?cW5JbC94QlpDeGxpQ2tBeU93aU1MOG9ObnMzYlFWWTlTcnJkcFJjSlhCMWFR?=
 =?utf-8?B?c2x1MlhhN2RLYlQ5aWUvVTRwRU9YUXYxblBUVFlMRTl5R3BhaVJtMXRMRFI0?=
 =?utf-8?B?OXFUVVpBdEc1am0rWm9wQVRzeTlSUDFkZDRURTlaTDdyWmdRSVd4ekpHNDFl?=
 =?utf-8?B?RkVuMlE4cHJvOWNZWWxTa2tzZkJpay9ZVlFUL0gxRjNPQVg4UVlWcGZ2WVpZ?=
 =?utf-8?B?djY4UTJVNThtQUw2TUZydWdYTlJiV0thUDBpWGdMak53VlNOeXd4ek40emN4?=
 =?utf-8?B?Q2orTjdHUGd6cVRWdzMveEZlejVTTG5hcTA3NTFLejBnSy9CRTJPUGZCNnFI?=
 =?utf-8?B?VEpuZ0N3Kzc3dVhCSWRxTW5wTUEwbDJsa28veFVPeUJRdlA2VTNweXdNTk14?=
 =?utf-8?B?TCtxd0RqcExJQVhNK2grV0ZtQmJ1VnFya1VBSTdnQ1c5dFF6TkRyeFl2ZGdk?=
 =?utf-8?B?eWVSMFRnc2RjTHgrRHBEOUY1a0NkU21zaHJYZ1VZckhiTXdjbjJ0RS9Eck9z?=
 =?utf-8?B?RFM5UTlnRkhyTVZkWjR3b1NBNU9VR0pBZmN4Nm8vaVFvWFVYT1BiVHBFcjV1?=
 =?utf-8?B?YWRvZjRtWGM2RHpjdTB4MkxlcVFzYzZucEFFbVVVMWdQQWVFbzczVVd2Q0pC?=
 =?utf-8?B?NFREQjduQmlPUVduN280UGFyZmhuMHdNSjF3UmUwMUpTdTREZm5iZnhrOVgv?=
 =?utf-8?B?ZTdKOWN6SklRbElMbERGWUVyZ2pMeXYxWjZhcFhsTmg2aTlTbXhROS9yQlUv?=
 =?utf-8?Q?nawgTn8KQskYql/TsN7E0TC+Q?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCE5F48702DB974FA53A100F1C4079AE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 467a91df-6a58-4f6b-5d7a-08dc8ff5ea59
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2024 00:22:34.0899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9dzw96KFB6Tqgw0X7HZBdcW1W35/zBkqiFlgbYbJKcvuula0IrKXt3T3N8RSZYD9OoK3xBXl36H0HMaCOYXANA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7756
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA2LTE4IGF0IDE2OjUyICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiAxNi4wNi4yNCDQsy4gMTU6MDEg0YcuLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4g
Q3VycmVudGx5IHRoZSBrZXJuZWwgZG9lc24ndCBwcmludCBhbnkgaW5mb3JtYXRpb24gcmVnYXJk
aW5nIHRoZSBURFgNCj4gPiBtb2R1bGUgaXRzZWxmLCBlLmcuIG1vZHVsZSB2ZXJzaW9uLiAgUHJp
bnRpbmcgc3VjaCBpbmZvcm1hdGlvbiBpcyBub3QNCj4gPiBtYW5kYXRvcnkgZm9yIGluaXRpYWxp
emluZyB0aGUgVERYIG1vZHVsZSwgYnV0IGluIHByYWN0aWNlIHN1Y2gNCj4gPiBpbmZvcm1hdGlv
biBpcyB1c2VmdWwsIGVzcGVjaWFsbHkgdG8gdGhlIGRldmVsb3BlcnMuDQo+IA0KPiBJdCdzIHVu
ZGVyc3Rvb2QgdGhhdCBpdCdzIG5vdCBtYW5kYXRvcnkgdG8gcHJpbnQgYW55IGluZm9ybWF0aW9u
LCBqdXN0IA0KPiByZW1vdmUgdGhpcyBzZW50ZW5jZSBhbmQgbGVhdmUgdGhlICJJbiBwcmFjdGlj
ZSBzdWNoLi4uLiINCg0KV2lsbCBkby4NCg0KPiANCj4gPiANCj4gPiBGb3IgaW5zdGFuY2UsIHRo
ZXJlIGFyZSBjb3VwbGUgb2YgdXNlIGNhc2VzIGZvciBkdW1waW5nIG1vZHVsZSBiYXNpYw0KPiA+
IGluZm9ybWF0aW9uOg0KPiA+IA0KPiA+IDEpIFdoZW4gc29tZXRoaW5nIGdvZXMgd3JvbmcgYXJv
dW5kIHVzaW5nIFREWCwgdGhlIGluZm9ybWF0aW9uIGxpa2UgVERYDQo+ID4gICAgIG1vZHVsZSB2
ZXJzaW9uLCBzdXBwb3J0ZWQgZmVhdHVyZXMgZXRjIGNvdWxkIGJlIGhlbHBmdWwgWzFdWzJdLg0K
PiA+IA0KPiA+IDIpIEZvciBMaW51eCwgd2hlbiB0aGUgdXNlciB3YW50cyB0byB1cGRhdGUgdGhl
IFREWCBtb2R1bGUsIG9uZSBuZWVkcyB0bw0KPiA+ICAgICByZXBsYWNlIHRoZSBvbGQgbW9kdWxl
IGluIGEgc3BlY2lmaWMgbG9jYXRpb24gaW4gdGhlIEVGSSBwYXJ0aXRpb24NCj4gPiAgICAgd2l0
aCB0aGUgbmV3IG9uZSBzbyB0aGF0IGFmdGVyIHJlYm9vdCB0aGUgQklPUyBjYW4gbG9hZCBpdC4g
IEhvd2V2ZXIsDQo+ID4gICAgIGFmdGVyIGtlcm5lbCBib290cywgY3VycmVudGx5IHRoZSB1c2Vy
IGhhcyBubyB3YXkgdG8gdmVyaWZ5IGl0IGlzDQo+ID4gICAgIGluZGVlZCB0aGUgbmV3IG1vZHVs
ZSB0aGF0IGdldHMgbG9hZGVkIGFuZCBpbml0aWFsaXplZCAoZS5nLiwgZXJyb3INCj4gPiAgICAg
Y291bGQgaGFwcGVuIHdoZW4gcmVwbGFjaW5nIHRoZSBvbGQgbW9kdWxlKS4gIFdpdGggdGhlIG1v
ZHVsZSB2ZXJzaW9uDQo+ID4gICAgIGR1bXBlZCB0aGUgdXNlciBjYW4gdmVyaWZ5IHRoaXMgZWFz
aWx5Lg0KPiA+IA0KPiA+IFNvIGR1bXAgdGhlIGJhc2ljIFREWCBtb2R1bGUgaW5mb3JtYXRpb246
DQo+ID4gDQo+ID4gICAtIFREWCBtb2R1bGUgdHlwZTogRGVidWcgb3IgUHJvZHVjdGlvbi4NCj4g
PiAgIC0gVERYX0ZFQVRVUkVTMDogU3VwcG9ydGVkIFREWCBmZWF0dXJlcy4NCj4gPiAgIC0gVERY
IG1vZHVsZSB2ZXJzaW9uLCBhbmQgdGhlIGJ1aWxkIGRhdGUuDQo+ID4gDQo+ID4gQW5kIGR1bXAg
dGhlIGluZm9ybWF0aW9uIHJpZ2h0IGFmdGVyIHJlYWRpbmcgZ2xvYmFsIG1ldGFkYXRhLCBzbyB0
aGF0DQo+ID4gdGhpcyBpbmZvcm1hdGlvbiBpcyBwcmludGVkIG5vIG1hdHRlciB3aGV0aGVyIG1v
ZHVsZSBpbml0aWFsaXphdGlvbg0KPiA+IGZhaWxzIG9yIG5vdC4NCj4gDQo+IEluc3RlYWQgb2Yg
cHJpbnRpbmcgdGhpcyBvbiAzIHNlcGFyYXRlIHJvd3Mgd2h5IG5vdCBwcmludCBzb21ldGhpbmcg
bGlrZToNCj4gDQo+ICJJbml0aWFsaXNpbmcgVERYIE1vZHVsZSAkTlVNRVJJQ19WRVJTSU9OICgk
QlVJTERfREFURSANCj4gJFBST0RVQ1RJT05fU1RBVEUpLCAkVERYX0ZFQVRVUkVTIg0KPiANCj4g
VGhhdCB3YXk6DQo+IGEpIFlvdSBjb252ZXkgdGhlIHZlcnNpb24gaW5mb3JtYXRpb24NCj4gYikg
WW91IGV4cGxpY2l0bHkgc3RhdGUgdGhhdCBpbml0aWFsaXNhdGlvbiBoYXMgYmVndW4gYW5kIG1h
a2Ugbm8gDQo+IGd1YXJhbnRlZXMgdGhhdCBiZWNhdXNlIHRoaXMgaGFzIGJlZW4gcHJpbnRlZCB0
aGUgbW9kdWxlIGlzIGluZGVlZCANCj4gcHJvcGVybHkgaW5pdGlhbGlzZWQuIEknbSB0aGlua2lu
ZyBpZiBzb21lb25lIGNvdWxkIGJlIG1pc3Rha2VuIHRoYXQgaWYgDQo+IHRoaXMgaW5mb3JtYXRp
b24gaXMgcHJpbnRlZCB0aGlzIHN1cmVseSBtZWFucyB0aGF0IHRoZSBtb2R1bGUgaXMgDQo+IHBy
b3Blcmx5IHdvcmtpbmcsIHdoaWNoIGlzIG5vdCB0aGUgY2FzZS4NCg0KSWYgdGhlIG1vZHVsZSBm
YWlscyB0byBpbml0LCB0aGVyZSB3aWxsIGJlIG1lc3NhZ2UgZXhwbGljaXRseSBzYXlpbmcgdGhh
dA0KX2FmdGVyXyB0aGUgYWJvdmUgbWVzc2FnZS4NCg0KQnV0IGZpbmUgSSBjYW4gY2hhbmdlIHRv
IHByaW50IGluIG9uZSBsaW5lIGxpa2UgYmVsb3c6DQoNCnZpcnQvdGR4OiBJbml0aWFsaXppbmcg
bW9kdWxlOiBQcm9kdWN0aW9uIG1vZHVsZSwgdmVyc2lvbiAxLjUuMDAuMDAuMDQ4MSwNCmJ1aWxk
X2RhdGUgMjAyMzAzMjMsIFREWF9GRUFUVVJFUzAgMHhmYmYNCg0KSWYgaXQgcmVhZHMgbW9yZSBj
bGVhci4NCg0KWy4uLl0NCg0KPiA+ICAgDQo+ID4gKyNkZWZpbmUgVERfU1lTSU5GT19NQVBfTU9E
X0lORk8oX2ZpZWxkX2lkLCBfbWVtYmVyKQlcDQo+ID4gKwlURF9TWVNJTkZPX01BUChfZmllbGRf
aWQsIHN0cnVjdCB0ZHhfc3lzaW5mb19tb2R1bGVfaW5mbywgX21lbWJlcikNCj4gDQo+IFdoYXQn
cyB0aGUgcG9pbnQgb2YgdGhpcyBkZWZpbmUsIHNpbXBseSB1c2UgdGhlIHJhdyBURF9TWVNJTkZP
X01BUCANCj4gaW5zaWRlIHRoZSByZXNwZWN0aXZlIGZ1bmN0aW9uLiBJdCBkb2Vzbid0IHJlYWxs
eSBhZGQgYW55IHZhbHVlIA0KPiBlc3BlY2lhbGx5IGV2ZXJ5dGhpbmcgaXMgZW5jYXBzdWxhdGVk
IGluIG9uZSBmdW5jdGlvbi4gTGl0ZXJhbGx5IHlvdSBhZGQgDQo+IGl0IHNvIHRoYXQgeW91IGRv
bid0IGhhdmUgdG8gdHlwZSAic3RydWN0IHRkeF9zeXNpbmZvX21vZHVsZV9pbmZvIiBvbiANCj4g
ZWFjaCBvZiB0aGUgMiBsaW5lcyB0aGlzIGRlZmluZSBpcyB1c2VkLi4uDQoNCkl0IG1ha2VzIHRo
ZSBjb2RlIHNob3J0ZXIsIHcvbyBuZWVkaW5nIHRvIHR5cGUgJ3N0cnVjdA0KdGR4X3N5c2luZm9f
bW9kdWxlX2luZm8nIGZvciBlYWNoIG1lbWJlci4gIFRoaXMgd2F5IGlzIGFsc28gY29uc2lzdGVu
dA0Kd2l0aCBvdGhlciBzdHJ1Y3R1cmVzIChlLmcuLCAnc3RydWN0IHRkeF9zeXNpbmZvX3RkbXJf
aW5mbycpIHdoaWNoIGhhdmUNCm1vcmUgbWVtYmVycy4NCg0KPiANCj4gPiArDQo+ID4gK3N0YXRp
YyBpbnQgZ2V0X3RkeF9tb2R1bGVfaW5mbyhzdHJ1Y3QgdGR4X3N5c2luZm9fbW9kdWxlX2luZm8g
Km1vZGluZm8pDQo+ID4gK3sNCj4gPiArCXN0YXRpYyBjb25zdCBzdHJ1Y3QgZmllbGRfbWFwcGlu
ZyBmaWVsZHNbXSA9IHsNCj4gPiArCQlURF9TWVNJTkZPX01BUF9NT0RfSU5GTyhTWVNfQVRUUklC
VVRFUywgc3lzX2F0dHJpYnV0ZXMpLA0KPiA+ICsJCVREX1NZU0lORk9fTUFQX01PRF9JTkZPKFRE
WF9GRUFUVVJFUzAsICB0ZHhfZmVhdHVyZXMwKSwNCj4gPiArCX07DQo+ID4gKw0KPiA+ICsJcmV0
dXJuIHN0YnVmX3JlYWRfc3lzbWRfbXVsdGkoZmllbGRzLCBBUlJBWV9TSVpFKGZpZWxkcyksIG1v
ZGluZm8pOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICsjZGVmaW5lIFREX1NZU0lORk9fTUFQX01PRF9W
RVJTSU9OKF9maWVsZF9pZCwgX21lbWJlcikJXA0KPiA+ICsJVERfU1lTSU5GT19NQVAoX2ZpZWxk
X2lkLCBzdHJ1Y3QgdGR4X3N5c2luZm9fbW9kdWxlX3ZlcnNpb24sIF9tZW1iZXIpDQo+IA0KPiBE
SVRUTw0KDQpJIHJlYWxseSB3YW50IHRvIGF2b2lkIHR5cGluZyAnc3RydWN0IHRkeF9zeXNpbmZv
X21vZHVsZV92ZXJzaW9uJyBmb3IgZWFjaA0Kc3RydWN0IG1lbWJlci4gIEkgZG9uJ3QgdGhpbmsg
dXNpbmcgVERfU1lTSU5GT19NQVAoKSBkaXJlY3RseSBpcyBhbnkNCmJldHRlci4NCg0KPiANCj4g
PiArDQo+ID4gK3N0YXRpYyBpbnQgZ2V0X3RkeF9tb2R1bGVfdmVyc2lvbihzdHJ1Y3QgdGR4X3N5
c2luZm9fbW9kdWxlX3ZlcnNpb24gKm1vZHZlcikNCj4gPiArew0KPiA+ICsJc3RhdGljIGNvbnN0
IHN0cnVjdCBmaWVsZF9tYXBwaW5nIGZpZWxkc1tdID0gew0KPiA+ICsJCVREX1NZU0lORk9fTUFQ
X01PRF9WRVJTSU9OKE1BSk9SX1ZFUlNJT04sICAgIG1ham9yKSwNCj4gPiArCQlURF9TWVNJTkZP
X01BUF9NT0RfVkVSU0lPTihNSU5PUl9WRVJTSU9OLCAgICBtaW5vciksDQo+ID4gKwkJVERfU1lT
SU5GT19NQVBfTU9EX1ZFUlNJT04oVVBEQVRFX1ZFUlNJT04sICAgdXBkYXRlKSwNCj4gPiArCQlU
RF9TWVNJTkZPX01BUF9NT0RfVkVSU0lPTihJTlRFUk5BTF9WRVJTSU9OLCBpbnRlcm5hbCksDQo+
ID4gKwkJVERfU1lTSU5GT19NQVBfTU9EX1ZFUlNJT04oQlVJTERfTlVNLAkgICAgIGJ1aWxkX251
bSksDQo+ID4gKwkJVERfU1lTSU5GT19NQVBfTU9EX1ZFUlNJT04oQlVJTERfREFURSwJICAgICBi
dWlsZF9kYXRlKSwNCj4gPiArCX07DQo+ID4gKw0KPiA+ICsJcmV0dXJuIHN0YnVmX3JlYWRfc3lz
bWRfbXVsdGkoZmllbGRzLCBBUlJBWV9TSVpFKGZpZWxkcyksIG1vZHZlcik7DQo+ID4gK30NCj4g
PiANCg0KWy4uLl0NCg0KPiA+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaA0KPiA+
ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaA0KPiA+IEBAIC0zMSw2ICszMSwxNSBA
QA0KPiA+ICAgICoNCj4gPiAgICAqIFNlZSBUYWJsZSAiR2xvYmFsIFNjb3BlIE1ldGFkYXRhIiwg
VERYIG1vZHVsZSAxLjUgQUJJIHNwZWMuDQo+ID4gICAgKi8NCj4gDQo+IG5pdDoNCj4gDQo+IFtO
b3QgcmVsYXRlZCB0byB0aGlzIHBhdGNoIGJ1dCBzdGlsbCBhIHByb2JsZW0gaW4gaXRzIG93bl0N
Cj4gDQo+IFRob3NlIGZpZWxkcyBhcmUgZGVmaW5lZCBpbiB0aGUgZ2xvYmFsX21ldGFkYXRhLmpz
b24gd2hpY2ggaXMgcGFydCBvZiANCj4gdGhlICAiSW50ZWwgVERYIE1vZHVsZSB2MS41IEFCSSBE
ZWZpbml0aW9ucyIgYW5kIG5vdCB0aGUgMS41IEFCSSBzcGVjLCANCj4gYXMgdGhlIEFCSSBzcGVj
IGlzIHRoZSBwZGYuDQoNCkkgd2lsbCB1cGRhdGUgdGhpcy4gIFRoYW5rcy4NCg==

