Return-Path: <kvm+bounces-17994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 597B68CC967
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 01:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08AA92814BA
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B24701494B6;
	Wed, 22 May 2024 23:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RMQThRFt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A716119470;
	Wed, 22 May 2024 23:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716419401; cv=fail; b=TbC3pS0PVRD8YR0G8nLzkEV+D7bOnMmyhCF508Nx+3UmT6B6xMfDslO9sxjBkBHHzxKbksjplGNZgKz1uqszOlZfAUHCas3VE+8Fx+sDH7e/c/b6ovZuwAryuTB5wNQU6HCkAblj7YuXswaIc7MzpQgxal2jE/I4dkBlUeZ+GDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716419401; c=relaxed/simple;
	bh=ixfRj0G5VH49prdcAnrzKUKedZHILTpl9o68gUQGWuc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EmhONIMqi3HijW9wzTrZU0Jv4VKZ3Wx9bW7s6qdzvr9nBVTCKPy2z0zI6eqvjlwxbYIP1DWEmsPp0Dg3XGBWErXEVryOucSqDRZfszJbWyWTo8gKE11eCzbyeWCtqM0rOzjMTMmXHEqSU/btSyga3vR3DDiQ5fNAok288snUttY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RMQThRFt; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716419399; x=1747955399;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ixfRj0G5VH49prdcAnrzKUKedZHILTpl9o68gUQGWuc=;
  b=RMQThRFtdoBnKzYX0csrfXFCRyDKcC5tB94k777FAUaXCLCKP74pjwNA
   u06OIdcYSHbuF1sX0MfkPhSgoTj0XNay6yYLEv76x1UpmQwZvNsKcu+a6
   nIDhj6kC345c24CdGeZe0IX69MEmT6iBFQVYKX5lxDm3mJRFjGfBF/7Qy
   YaHGEo2f0yttINvAf4s/B/qRhN0fZaIJSP4Guuf3RKSDcrK9f5jCoHCDK
   r3JRF0Y0lfpQ2eDaPLDEyTGQVFph4/aCJjSWuBrvMyIDqzaIbQ+/Y/wTt
   jEXJL7MOoh9rXA/kyfvwiFxSRi61Y4cTB+SyazF9RUo4DJyh7fs1ULIbt
   g==;
X-CSE-ConnectionGUID: fKMd8PHdRjmmCrpCW42l/g==
X-CSE-MsgGUID: jjIQaYnvTDWiHrkIAzTsww==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="16533779"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="16533779"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 16:09:58 -0700
X-CSE-ConnectionGUID: RERf78TyQ/mcYz6waMMEyg==
X-CSE-MsgGUID: +M1OUN0ZSuu7PouJ9bzwjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33562829"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 16:09:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 16:09:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 16:09:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 16:09:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkyHvuikRldJqjDyhNmp8oB4MSJxcXfP2cIUV1pkJOZjW3nfyq5wLKNw5kX9hRdH8ZTw68x18+ZgVLu1GTIeHVoTy456YSNJUqp4rHEApHhOxlFk2MphDaJj5ahArILGnTErb/GrWkUyfZWhtABVd0aWn/e3bbq1i/9axtzAzqfOoKkGLEZEGRJhpJ0QctFid4semSbueIOpGUTseYc8ZCeuj3bIYM26TO0I4I/XUWi9A+esOERg+Ra0dvchEgX7xYmZA3K/SNALOutvOVmf4e0xxGchCfL72yh+sFw/PmD5nN4J8RM/e2TDMvPXXYu1HBir5tDsR0M22SMIm9cbFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixfRj0G5VH49prdcAnrzKUKedZHILTpl9o68gUQGWuc=;
 b=F3PN74d9x33H5Emt3XULuzv9+CGPzfZsH9X66AjvzuVomCs8ouaFBjhDyCS4DBVDo/pPnrMFh7+PvMuTk7ou2S3vFV0ZrcyQaihK8d4IRtL3xIviePOFmcJlih8BT4bV6YgaPMJxyyn9VpaR+rEJm1hJmAC3gAOJsBu/OHCDoHbcbS9K3Kn2BWB43L//HMwL/3hiwY788huKusR0leqCY1m/pSTt7g34ds/ZYNfCO/R3cSWlvnRxHQA4/6xejKMa4JSMjvON726fRY9ji4AHsuqEST0XvRDeoqdJ4ckqH5hjhXadqXiHApJp9ComUHoj5uAovXdS1Ia7v5Ueg4AEHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5190.namprd11.prod.outlook.com (2603:10b6:510:3c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.20; Wed, 22 May
 2024 23:09:55 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 23:09:54 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "seanjc@google.com" <seanjc@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GZCeQAgAAJxQCAAAs0AIAADfKAgACpkgCAADtVgIAAM8qAgABzkACAAGxrAIAAmmaAgAAQyQCABP6CgIABBVgAgAAS3ACAAfwwgIAACfeA
Date: Wed, 22 May 2024 23:09:54 +0000
Message-ID: <9bc661643e3ce11f32f0bac78a2dbfd62d9cd283.camel@intel.com>
References: <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
	 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
	 <20240516194209.GL168153@ls.amr.corp.intel.com>
	 <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>
	 <20240517090348.GN168153@ls.amr.corp.intel.com>
	 <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
	 <20240517191630.GC412700@ls.amr.corp.intel.com>
	 <20240520233227.GA29916@ls.amr.corp.intel.com>
	 <a071748328e5c0a85d91ea89bb57c4d23cd79025.camel@intel.com>
	 <20240521161520.GB212599@ls.amr.corp.intel.com>
	 <20240522223413.GC212599@ls.amr.corp.intel.com>
In-Reply-To: <20240522223413.GC212599@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5190:EE_
x-ms-office365-filtering-correlation-id: d1ba6d8c-8ae0-40d8-e644-08dc7ab44adf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?eU9NM1hhVjJhZ2NBSVF3MVN1bWEvQmZNaG1uWi9VVlVESCtpak1jL05UaGtS?=
 =?utf-8?B?UUxtRFAwSzRxK2d0dXBURzZYbGtQTUtZRHEvNE9QaEFTLzFOemFIM1ozaUZZ?=
 =?utf-8?B?cDVZYWxiMWt3REMwTi9PUHdFSGtYMjV4K2pVZmMxblh0K0JMMk5UTkg4SG44?=
 =?utf-8?B?TmE1VHp4TU8ra09CNmtVVHlJK2Z1WXpBdC95NGxtaEtCYzlSZFR5Q1U1NW95?=
 =?utf-8?B?SGw4YTMrT1AzNTVMVVNEdkh3c0xHempPSHhIaDhQYml4T1VCSkhsaW5ZUTI3?=
 =?utf-8?B?M1E0RTJsd3BaMjdrY2xJNDJjamwzc2R5aTdweEdRQWpSVTRuendObi9iUTh6?=
 =?utf-8?B?S29sRUZ2TWtISzFubHNWR01rL0V2b1FKdmxTM1NwcGJPenlmb0taWVBnMjR4?=
 =?utf-8?B?YVRiVDNIZitLc3c1SFd4OHJjVHBNT3pjU0JmbUEzV3F2MTliVkNjbCtQNnZ2?=
 =?utf-8?B?NlFFK0NvYWJ1Ynd0cFJsYm02K3ZTaEdvVUtXelgxV3lhSXQ3TTFiREJxRW15?=
 =?utf-8?B?Vm05a3ZMNS96MEhzU2tlOVFvSUVBdUVWcUtnRCtjRWk4WnBrZmhTdjJjZlJY?=
 =?utf-8?B?NTR5ekN3MHdsKysxRzVXWVV1Q0ZvUmk5S04vczJ0T21lS3RMQXdEZWxrTThD?=
 =?utf-8?B?ZENMMytKS2d5dEkwYlRweFJlMWxDRWswTEl1OUFZUEZuZjRHTlk4OWhyNEVT?=
 =?utf-8?B?MFJPdGRwOUdiMEovSEtVTW5LY3hmOVpFZFFiUC9nbHlTaUdmZnJ1UVpvbzZq?=
 =?utf-8?B?N1piMmdwN0FybzJzL05jcGRhazZhcXZsSmw3N2p0ZFBSY2VGK0FRbVZjQmJu?=
 =?utf-8?B?elM1MVdGMlEvTmd5N2o1amRvZkliOUJJVExkRkp2V2RyU0FWbGpGVGlxK3E1?=
 =?utf-8?B?dklaT2ExZlRJQ1pNVnhwemxPbUZNQk8rNE9aVmdsOEhCaGRYTDBuOWRFOWFX?=
 =?utf-8?B?V1pOUFJJVmZhQzh1SDFBTDhrSDNKRmcvNjVoYzdlZUNBUitzUzJEbVkrcWxO?=
 =?utf-8?B?UWlPQ3RrdHlaSUk0eVdjSkRKSUhwNkpQcVh1KzRRVHRiaGk4cjk0bDNUR1dm?=
 =?utf-8?B?Zjg1TUU1eGFRc3RUejRiRTRKTUZzMFphUEgrTkh2aWNMbHBJdXZYczdZZVQy?=
 =?utf-8?B?N3VHYnNvd3VwRUtqSk0xZndLNXAwd09vWCtia3FkczJKamo4eE5KcGM1SkVw?=
 =?utf-8?B?R2JCd21vbTR0L0laRzQyUUNsUUNKN2owMW5HRWgvZ0dVTWRrS09ESG5XUDhC?=
 =?utf-8?B?RWl0RDZWWTNuZWpxWGFuZnlCcFl2U25HZ0xZQWkwdWQ5TEpKOVB1b2hONFVF?=
 =?utf-8?B?QmlJYzFxckMvQmdXNCtNQzhmREtmdWp2RnYzUk9aZlFMUU5NcFlXdVRKd0xJ?=
 =?utf-8?B?UlMvTGhVMHhQSEtIV0pOK0dTRURwN2s5MXRaVkFLWXQxQ25LalVkeVBvdGRw?=
 =?utf-8?B?S0kxQmdZaTVMemhiN3BncEd5bmN5MjZNVUhUUkJyT1hXN3ZEVlVPSld4SzdE?=
 =?utf-8?B?ZkpvZWI1dWRtQVVWckxrRHlZVDZycEUrdzc5NkFzYStVbmFvaWhIbmlCVCtT?=
 =?utf-8?B?c2sxRFpBYThkY2RzamN5cVoyNUp6NnZWbHIvbU1XMnhFOFdwU2lCREVmMkh6?=
 =?utf-8?B?b25RSlUrRmJqN3YxZ0VFaFFiVEJIYmZzdTZ3ODhUSU1wY1ZERVU3anYwQTd4?=
 =?utf-8?B?Y3l1WEF5OGRkZzRJYWUvdmx1NHA5K0ZFUTUzbStuL2h0elVpUWpIc1VsemtJ?=
 =?utf-8?B?Q2hHbE5HKzB2dVQzWi9ObU9RaFo2R204WXFHTlQ4cFFRVG5XQ2pWMmlQTFhW?=
 =?utf-8?B?eG1WZlpXVGZxOVJNVFJDQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T21CN25oSWVxTll5WVM5Y3ZDMVlYQWNnb0hTZk9xcGU4dUNTNkgvd04yMExx?=
 =?utf-8?B?c1d5aHpHZGlDY0ZlU1JaWkF3ZjFIcGtlemFZV0hKWURxNWZsWnBveTRCMG94?=
 =?utf-8?B?YXZOSkZIZGh0MkdweFVLTEpwZUZsVEZxK0pib3pVK0ZYVDNXMWFyNklLZm0w?=
 =?utf-8?B?MFVVU29lRzJHNzBEM1p0ZWhFZWIwSXRHc2VENXJCQis4NVdNVUpkeFJjY0xu?=
 =?utf-8?B?cW5wc0c4MG91K2Y2eFc2K0tUUUg0Y1BGbS9Sbng2RjQrZDBxcjdPczNEOFRk?=
 =?utf-8?B?UTNuMHNWSlRibGl0OE5YQVBWa29yRUpzWmtIY0NCc2lNUmVwMW9KSGZwU1U3?=
 =?utf-8?B?YmFRTUU2RHRhWmxUOVNPOVgxY3dmQmMxaytvaXo1S3d2Z0JRcUFzL0hMeWUz?=
 =?utf-8?B?UE5BeHJVZTNrWXhVcVZ2OUtPWWt3OS9MdThhdDhlK21DMzVKOU1Xb1ZqTk9n?=
 =?utf-8?B?T3QwMzRnU25Yb0xPa1RRTWowKzhCR2FGVnZ0cXVZemI0c2VKbU9abWVqc0xJ?=
 =?utf-8?B?RUtGQk1FSzdpNG1VTTIvUStnQ0tOUEpzejI3MG1NODEvYzJiYmpHalVsYTEx?=
 =?utf-8?B?c2ZPcXhjYUI5NFJDRElwcUdZZDNiZFMwRU5Jd2RneVRLeGRiMFdHblgrdy91?=
 =?utf-8?B?SnhhMlZhTlRseGN6OWNRZGFvNklUYkRUTEpUTDVZOUx2QUQwMzdpWWZKNUVt?=
 =?utf-8?B?SFRzMC9wMC85cFkrTUluQUkxQ1BqWXR3TGtwOUpENXd5S0M3ODI0QTNFYm1v?=
 =?utf-8?B?cDlKejI2K204UElSNFBJbkd5a1hWNU8zVlZRNVhtdklwaGRybnhEcjhIL3d6?=
 =?utf-8?B?dEozTU5iUXAzZjVoczVYTzY5aGQ5Zm0vV2I0Vnk2Uk9HZGd2RGVEMTRTSWt4?=
 =?utf-8?B?ck42SHZLcSthWmRrRklRakV5anU0MVpOeDhoWHhhazYxYnlDcHVkVzQwY1RF?=
 =?utf-8?B?VCtwSUNMNDJqajc1akxJWGx1cXpSdk1WSUJaMHJWRGdCbW4ydDMrcnpMRnlY?=
 =?utf-8?B?dGF5SFFieGt6SmErSWNmL29wcmMyUzRHd0RIVFI2MHVnSW1EVk1QbUNldmZo?=
 =?utf-8?B?ZkFSbFA4K3VDbWZNUnVTOEZDSzNuaU8zRXdlaXROS0k5eU5xR0dFT3B0OHV6?=
 =?utf-8?B?T0Y0RjBJVnJIeFd6dzRoSktWK0NlUDBubkRERUVweGtUdlJLbFV6MERyQjB6?=
 =?utf-8?B?Q09tSWpBcHFkV2hTU0dxYkJUUGtYTWFzbzM2NWVZK3dDSmFnenJ3T1RwZHdS?=
 =?utf-8?B?ckZMVjMybnZJUFBZODRsS2ZCeUI0Rnh4M2dZMFU3VkQ2N1h0QVlJRjhUcXho?=
 =?utf-8?B?Vy91RWpsV2VuR3RZVk1HaXh0bG1RU21vMzZQbFI1UHh3Sjlvcm9GRUcxZDdv?=
 =?utf-8?B?M2JPQkpUS2RCUnhBZEc1b3ZQZGdFKzNTTTN4V05KMDA3cVdkN2hMNnRNVk1p?=
 =?utf-8?B?cGQrNmpMaWRoa2VOSlRvZnE5cTZudnBxYnZscTk3Q1hiN3MveGExbXdnZjgr?=
 =?utf-8?B?SExuTFV2TmlyQjMyRENSVDN1NHRMa2daNmpQSCs1WTM0azg4aFF5VmZtUnNL?=
 =?utf-8?B?UlNrbldteFAyM2lEMm1xQW01TUZ4aEdNL2p5MlRzb2FHRFRrUHFOc2dRNnpH?=
 =?utf-8?B?MmVQdFNNaTlPK2oxaHBNazk5aGRFcFpqNGJSRm9mOWw5WGRwbHBSczVmb1hW?=
 =?utf-8?B?UjROUDUvRHdGcEtFeTNXWmJpZ3M4a1c4VVkyNjhzY2l1RG1QN0tISVNWTTEv?=
 =?utf-8?B?UjVBQndCQmMzNUtHbE9TMU45dUw3OXdWWHdYMWl2NFlqVlZyQ0tkTWM5VUdv?=
 =?utf-8?B?UUZlbjFxZlh0V0w0NGhTcXQrendaT08zbCtUTk5SOGZGVVYxVzVKTEJQdXhq?=
 =?utf-8?B?RUFKQ0xMWjR1VTUzcnppN3FBb3JUSUZVcDFFQzl1ZmZPSWcvOWIzYmJadGZG?=
 =?utf-8?B?VGE0eGNFT1BjRk44NFJqSHBPL2oxQ09wY1VtMTF0UVVEa3N2KzUvUHdxeUxa?=
 =?utf-8?B?cjVkejlSZlVqY3Z6UFhHTlZmUkYxaWhqRkppVVE2NDhyNlZtaGlHWkJBU1Bz?=
 =?utf-8?B?bzFNa01rV1U4YlJ5LzBPVXFOU3BZSGovTVJzTmcvOWx5Mi9XOVJxQVVvVVpV?=
 =?utf-8?B?WHd4YmxhSjRpMWsySFVSMTgvSGdPVjNLc3dyN1hFM2pYTTBidW1JNllWUEl0?=
 =?utf-8?B?Rmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B15F999C26FFF84EB77F59BBAA7366DF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1ba6d8c-8ae0-40d8-e644-08dc7ab44adf
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2024 23:09:54.8187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lE9RafV+ztNUBhzHbxzQtLQ8AVC/pUXuI9iA+yE5TE+PgnaHnPQPwcUUguuBYLP/bxfFKU+2CyZK9G0gS3hmVFK2W92YvbmEP1U0BECkpsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5190
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTIyIGF0IDE1OjM0IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gb3B0aW9uIDEuIEFsbG93IHBlci1WTSBrdm1fbW11X21heF9nZm4oKQ0KPiBQcm86IENvbmNl
cHR1YWxseSBlYXN5IHRvIHVuZGVyc3RhbmQgYW5kIGl0J3Mgc3RyYWlnaHRmb3J3YXJkIHRvIGRp
c2FsbG93DQo+IMKgwqDCoMKgIG1lbXNsb3QgY3JlYXRpb24gPiB2aXJ0dWFsIG1heHBoeWFkZHIN
Cj4gQ29uOiBvdmVya2lsbCBmb3IgdGhlIGNvcm5lciBjYXNlPyBUaGUgZGlmZiBpcyBhdHRhY2hl
ZC7CoCBUaGlzIGlzIG9ubHkgd2hlbg0KPiB1c2VyDQo+IMKgwqDCoMKgIHNwYWNlIGNyZWF0ZXMg
bWVtbG9zdCA+IHZpcnR1YWwgbWF4cGh5YWRkciBhbmQgdGhlIGd1ZXN0IGFjY2Vzc2VzIEdQQSA+
DQo+IMKgwqDCoMKgIHZpcnR1YWwgbWF4cGh5YWRkcikNCg0KSXQgYnJlYWtzIHRoZSBwcm9taXNl
IHRoYXQgZ2ZuJ3MgZG9uJ3QgaGF2ZSB0aGUgc2hhcmUgYml0IHdoaWNoIGlzIHRoZSBwcm8gZm9y
DQpoaWRpbmcgdGhlIHNoYXJlZCBiaXQgaW4gdGhlIHRkcCBtbXUgaXRlcmF0b3IuDQoNCj4gDQo+
IG9wdGlvbiAyLiBLZWVwIGt2bV9tbXVfbWF4X2dmbigpIGFuZCBhZGQgYWQgaG9jayBhZGRyZXNz
IGNoZWNrLg0KPiBQcm86IE1pbmltYWwgY2hhbmdlPw0KPiDCoMKgwqDCoCBNb2RpZnkga3ZtX2hh
bmRlbF9ub3Nsb3RfZmF1bHQoKSBvciBrdm1fZmF1bHRpbl9wZm4oKSB0byByZWplY3QgR1BBID4N
Cj4gwqDCoMKgwqAgdmlydHVhbCBtYXhwaHlhZGRyLg0KPiBDb246IENvbmNlcHR1YWxseSBjb25m
dXNpbmcgd2l0aCBhbGxvd2luZyBvcGVyYXRpb24gb24gR0ZOID4gdmlydHVhbA0KPiBtYXhwaHlh
ZGRyLg0KPiDCoMKgwqDCoCBUaGUgY2hhbmdlIG1pZ2h0IGJlIHVubmF0dXJhbCBvciBhZC1ob2Mg
YmVjYXVzZSBpdCBhbGxvdyB0byBjcmVhdGUNCj4gbWVtc2xvdA0KPiDCoMKgwqDCoCB3aXRoIEdQ
QSA+IHZpcnR1YWwgbWF4cGh5YWRkci4NCg0KSSBjYW4ndCBmaW5kIGFueSBhY3R1YWwgZnVuY3Rp
b25hbCBwcm9ibGVtIHRvIGp1c3QgaWdub3JpbmcgaXQuIEp1c3TCoHNvbWUgZXh0cmENCndvcmsg
dG8gZ28gb3ZlciByYW5nZXMgdGhhdCBhcmVuJ3QgY292ZXJlZCBieSB0aGUgcm9vdC4NCg0KSG93
IGFib3V0IHdlIGxlYXZlIG9wdGlvbiAxIGFzIGEgc2VwYXJhdGUgcGF0Y2ggYW5kIG5vdGUgaXQg
aXMgbm90IGZ1bmN0aW9uYWxseQ0KcmVxdWlyZWQ/IFRoZW4gd2UgY2FuIHNoZWQgaXQgaWYgbmVl
ZGVkLiBBdCB0aGUgbGVhc3QgaXQgY2FuIHNlcnZlIGFzIGENCmNvbnZlcnNhdGlvbiBwaWVjZSBp
biB0aGUgbWVhbnRpbWUuDQo=

