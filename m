Return-Path: <kvm+bounces-32978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF2929E30FD
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 02:58:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A029F283F88
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 01:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69DA3175AB;
	Wed,  4 Dec 2024 01:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zyft8jg+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C7312EBEA;
	Wed,  4 Dec 2024 01:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733277522; cv=fail; b=V/IbJhXc6KzwtT2uZgNgRPd83it1Byo2+jHwQ1ATAEYeAKBQRvHQzhoMayPUs7Ub4aZarU5WTZSzxrNJ8hpdwp6BhHv7bTPgMD4E73Od6d4bnTQcC1b55BwUyVg0juqkG5fJgCQmsUSIG7xVUvW0/HI+yi4xSFIEqAxgnFIqXRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733277522; c=relaxed/simple;
	bh=FCxbvUO2k/n+jmKt3g+vnbzEgV+3tJqcbnvyBZUxcNQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AaepZOzTaVibY+eZD/0XmgmIkWG9lWx92xNjIcTVTmaNQD9wv7AaI7uxyRN0Tr8kMbNpPeVhvTa5Fxu8GPuIWrZDriuvPEmCaRpmPJwDRNhLJzbKsmm99KexuQNR4LWdAVly5zX+yVdLfjRRzeKzzadhV66W5Q+9aliWFmfba7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zyft8jg+; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733277521; x=1764813521;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FCxbvUO2k/n+jmKt3g+vnbzEgV+3tJqcbnvyBZUxcNQ=;
  b=Zyft8jg+3OTc9uL5ibr1cBYGY3bvmXae2I8Iuxs4ZRQ+a7vQCnTmxume
   /ip2pPFFLNcYd+5ShdpWMVsmikHr6jSlC4A04L9khzFeGjj2yKiV4Q5Qi
   LViiYyCOUJoJ1S3uRqAZZOKG5gDXQXogn2k6Z+gM2Jwr96Cai5xp+f6fk
   5oqM/JQGAe9bnpK6FzyUWLt5wb/rb9w/eHol+RsQqjEFg6FA2xogeNB+l
   EutvHeF0q23pDQroAGT5qPRpYsqys5h3uEta8iDEUjcT5VmUZuczt0EV2
   60/Y1wC546VIK218RYr+9TQE2HP2NSLPv27Vx1JCPSKfSBuJxQ60BQID+
   w==;
X-CSE-ConnectionGUID: fhF1H5DXTQKaQtOn7MOHTA==
X-CSE-MsgGUID: W9kmZ9jgRwGbzqPPkXZQlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="37462550"
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="37462550"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 17:58:40 -0800
X-CSE-ConnectionGUID: c+Oi98XCT2SceJxtNvdLzw==
X-CSE-MsgGUID: Loh5GXaRQLmSy8taFpsEqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="93279805"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Dec 2024 17:58:40 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Dec 2024 17:58:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Dec 2024 17:58:40 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Dec 2024 17:58:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hDt15UqJxo3SyTehlXYXlN1bkfbTYKsbOLDRMbSz9sEh7RcKrv91NMymHKAc4FfehpHfFgLTYUUwjxOgSJd/gtDgxa/cvBZT3PSyKVH8Gp4N6dMKrpE7iLkEGI7DpU+UPclnE06CxVsVmgPDJgRS1OSBtDAI0FQtBBBmprXyGMMu/p9AnL1M2xvkk5fp7TC8yYRPMJoqz/S7dU2wbGjBf1BnZpbIoU9pmFQo2R8N5sq4g+lEFU4G46YJB1jXmR9U06LgbpcYJkK2VAyzNerQVBpZoShghdR9NzalAAs04lRS83xin/RJIBUsLs/BjIsmD/JoekqRnylPwKZg5tWAog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FCxbvUO2k/n+jmKt3g+vnbzEgV+3tJqcbnvyBZUxcNQ=;
 b=lRg5QFhY6rFQ9L0gr5GovYLgR4H/roa4g5w687zmn+oUWK8u3qbSrtgFhuAA/UFNV3UrNoffAwsjbTDbSjpMhzawdXxffF0hcD/kkacutyrdwNF7VmJkUpsNO+gTqyHMykos98iG64bYmnR8MaIWIl9/4fYC4IfPIvKTLRbkBj98uzs+ByxSdEsxGgLS+5zMnrobgKvj3oc8IxWDjIhbcOc0BY+Vf6M6yZSmLKV916iMypr7SNNyHGeEhTjQLTBRKyGxX2ofTWMsK+MwO21PGhIhmI0xhQaq0ud2eI4fF1h6TjhQXRqEZdHIJOGSoLNcLUZNps4taoczIwjZCSQrUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB8130.namprd11.prod.outlook.com (2603:10b6:8:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Wed, 4 Dec
 2024 01:58:37 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8207.017; Wed, 4 Dec 2024
 01:58:37 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "yuan.yao@intel.com" <yuan.yao@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [RFC PATCH v2 4/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 page cache management
Thread-Topic: [RFC PATCH v2 4/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 page cache management
Thread-Index: AQHbRR8+17oG8mcgq0iuEnd+G9S1WbLTzTOAgAGInoA=
Date: Wed, 4 Dec 2024 01:58:37 +0000
Message-ID: <e320c703ba04f79a77181dd2cb62e1d2a3974ebe.camel@intel.com>
References: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
	 <20241203010317.827803-5-rick.p.edgecombe@intel.com>
	 <a2b2bf58-0d6b-4f27-999b-d9b40ae34ce8@linux.intel.com>
In-Reply-To: <a2b2bf58-0d6b-4f27-999b-d9b40ae34ce8@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB8130:EE_
x-ms-office365-filtering-correlation-id: 8a7c2711-83cd-407f-ebed-08dd14072b32
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ckd5RzR6ZEI5elhKNW9VUE1CSk9kQjZSVUpRMk96K0ZHZkdYY0h0dWlsdm5i?=
 =?utf-8?B?c1VLSmU2MnFnYXpiQmpDRUpCNCtnMXJGOGM4YlBBdlc1UThXN21NSTJOY0R3?=
 =?utf-8?B?ZGVYanl6OGxPZ243eldMdUtuak9iZjJsbzNidVZzYUQzS3JBdlN5SEpRUmF3?=
 =?utf-8?B?VWMxRWJGcDh4Mk0zN3VXQ2NueitvazVlYmNxTitiWCtMZmJoeUdoM2hXUEJz?=
 =?utf-8?B?eTdhbXNGU0VyM2ZYOXhEdEszRldPM2lmWjBJWnRqc243K01CVGo4b0VaczhY?=
 =?utf-8?B?S1VLVzd4Wmo0TUJNQlp3eWwxVmFCWTVzeFdmU2h5V1lkZDJUbkV6MVpjaGM0?=
 =?utf-8?B?SVEzVm9sYXlMdU1pQTlrVG9sSnVHMnA5dWMwOVJ3WHp5dDVPQlZESjloaGla?=
 =?utf-8?B?WklHNkxVN1N4dm54dXZxanJMTk1CZ1gzUGt4bkZhdU5xT0NsbmxJZXp5V1Z5?=
 =?utf-8?B?WjFva3ZpelZPcnN2YnJSakVBN09LM3BXT1VxdzR0Y2VLK21xc0hCQ0J2SjNT?=
 =?utf-8?B?eGNxN3gyZUJnenNpWEFJRUdzR3JHK2tTU1F0RStxN3psektWQXZ0bW9Ea3li?=
 =?utf-8?B?dmgvclA3Q1RrM203QjFyTWdUeWxQK21MRmJDOGFmVC91bzRoL3FxUFBDM1E4?=
 =?utf-8?B?aDBkSWY3OFZYTjhPN3A5L0phWHhJb1VqUXp0SWg5VUdKS05BbmVqeW43bUxq?=
 =?utf-8?B?TFFnZm9BK2cwUS9TSG1hMDkvMWhMZUtHMWdJYUZOL3FaNHhuNjJhMGdWT09m?=
 =?utf-8?B?aThUY1hwalJFN0Y5N0tnWlI5dzUyU2tsWFMweDJHSXdBM25mWnBNaVZuQk1i?=
 =?utf-8?B?N2lsZmY3QklpTXhHekhSM29xQXJ1eDV1NUFvdWZmWXQ0TWZSNXZtd1NSY01S?=
 =?utf-8?B?ZzJUYjVtWk5FTGpGS2VOcTZkWVJyTjdwL1AxbExFQ2Fvbms1K2s1MDJ4SmVp?=
 =?utf-8?B?VVBxN254T1Ztb1A1SS9qd1F3dVdkRVB5Q1RsOUVsNFZyOWJlcmlwUWE2TlpC?=
 =?utf-8?B?Z0RIWEtaVmprMXFNV1dkYzRndThZLzJRcWV4MGFzQWNqenF0ZVBuRS9Wa2VC?=
 =?utf-8?B?bThPNE9HcXVvTDdMWXFlRUM1QzUrTUJNMG8yRnIrUng4cmtMUm9paHRrUGJQ?=
 =?utf-8?B?YWwzemZTOTEvZVQreWwva3VKeGZvcWZSR0pEUEdVNzJHaG9lSkdBbUc0K2E5?=
 =?utf-8?B?VTJFaE52YksvWTlJL2owTTRWNWppRWp6RXNSL3ZjSEhFbkRuZjZKdU1hTEFH?=
 =?utf-8?B?cTRxR2NWRzcrZElWRGtUV3d3ekZ6YThiSTQ3YkhrZnJ0T3B2NkVoTUJ4aWNk?=
 =?utf-8?B?VzUzYWVIYWV3MWFZUmd6NUVPVVJ4US9jbnNMUmVoa2pqU2toWEVjcDgzNm5x?=
 =?utf-8?B?TmRmSlkzM3lvYUJLTXRHcUxiQzlWNVlMUzJvVllCWEZkSTM3cU5qNUhhdjRI?=
 =?utf-8?B?OGVra2VDd09lMGVZbHBkd1hlNnVKM2Q4OUp4akpEbU1tcjM0TWcwRitjN0ts?=
 =?utf-8?B?a0pLeGtwWTQ2a3VqRlYrak16K1hSRUVURExVSnRRUUZGUUVGeXFUTUpHU3VF?=
 =?utf-8?B?TjZBci9lYUVtdHFmZy9DdGRMRWt0NlVBUlhyUEp5NUFuYmJ5SVRXMlh4Z2py?=
 =?utf-8?B?UDl6NWNDbU9IWDd6Q1Q5NlhVV2pDZm93VTdjSkJFZkxDVnlIMzlrZllOU2pj?=
 =?utf-8?B?TndYbmFIWHQ2RTRUYzBVQWlCbGQxWUFxT0FZUlA1alhnYXpPOGdTYVcvQWhB?=
 =?utf-8?B?YXlWOGRmb2lGbi9Jb3VxRnFvS2xXVzVaV25heDdrOTZqNDdnWFk5VjBwNlhT?=
 =?utf-8?B?UjZuaHdndWs3RTltMStrU1ZQRit4VzFtcUNGdWQ2OGJURUJkKzdIaUVnM2Fp?=
 =?utf-8?B?U2g3bndkd1lDTkUyYmluelhXWTBZUmZVa1kxL1RZRjArNUE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVFkMjZTOVlabzJqWU0yOHZxTHEvMjh3NDFRUDBwUHRkSmJVRjR1bjRPQjEr?=
 =?utf-8?B?QklMSFBKc1QyWTR5QWRxeDdlMmh3VEdCZHZpV2VQNXljZjZtSm5Pc1I0UUkx?=
 =?utf-8?B?dmNqRlFHeDlIUFdFV0loVVJJVldvNWFRSkRvK2Vna0wzOTVqM3lRVUxhaU9w?=
 =?utf-8?B?aEhlVzBNeEluaEl4WTZOS05hYkU5Qm02SW52WmhVbm5UeXNjRXlXOFJFdy9v?=
 =?utf-8?B?cmtHL0QwUEdyVmM4Z3MweU5qVUlZNGk1OHl4cnhxcDQ2d1pBNzkxNEpjQy9h?=
 =?utf-8?B?SGpCYnVwbFppWkdpZ2U0WURMeE1IOEd6UlMya3ZubGY2V2t0T0xoK2VBRTU0?=
 =?utf-8?B?SjlvZ0F4SktsR2l3L29wazREV1BaUURFWkNTbzZMRVliamdrS0ExNVNzcWxZ?=
 =?utf-8?B?N3QzaWU0U1U1MkRuVGNEbi9ia0dmaFlZRFF5UnpPMHJ3Y1ArdTZuRGFSNHdm?=
 =?utf-8?B?aUYra0xuZkJ1R214eU9RYy9Mc3RjSXlKV2tVa3hWVHNENk9KSFI0bE1sVWpD?=
 =?utf-8?B?ZG9GNXdKRmp5OTNZT3I1RGdCNW9VOHVoakp4RzBiUTlyVS83ZjZLa0hNUm1N?=
 =?utf-8?B?Mnc4R2kzcG11a2IrYWhHdXQ0T3hJeUE3dkxUMFlvV29ZaUlZR2djOTRmRUto?=
 =?utf-8?B?clNqMjBUajhTYVJHQUloREVuZXA1bW56TjZxbUZucUp2cEE1YzRkRXcvcEx2?=
 =?utf-8?B?QXdlZkRoZnNrRVlmME5HM080bE5RNEtYdkFYdE5pRzVtR3ZrUkFYRHRkWEly?=
 =?utf-8?B?ZVk2bXNma1NucnZLMUI2ZUhtcm85OS94ci9IdHJDNmRORzlDazE0UGUxNUtR?=
 =?utf-8?B?b0ttQW9haEdXSThkSURsdDQwQnBnZ2h1T1I4b2dXczk3YTBneHd6TXNLYkJI?=
 =?utf-8?B?MDlraVl5NmZMVXA5MjZZem9Eeld6d1Jwb3dXVHBxYWI5MHlqWm1SbGVqRzY5?=
 =?utf-8?B?SHVCWFpwd0YvUjVtajdCbXFBeGxKejRtbVM0T1ByN2V6VkhkNmd2Y2MxVHMx?=
 =?utf-8?B?TUQ0RkpBT2VEMG9adWt5VVZhb1JkaHNVdldDTTZnOW9LaG9pNTF3VStWZFps?=
 =?utf-8?B?cHo0b285VDB5bmpoYkhSamNNOEZmWEdzT3BBQ1Y5b3E3Vmp2MFpoVERLSjZY?=
 =?utf-8?B?cHdtc0lqdURVMXllTHFNYVVYaXQxbWNkRnYvWjI0Y1VHbFpSSll2QlJuRGkr?=
 =?utf-8?B?M2oySGtxREN5TlYvL2NiYjdqbmNmT2JXNGI4cWNSVTBFd2RVU2VoK2hnaHd3?=
 =?utf-8?B?ei95WUJKYTcyZWhJL3JHNUFqWEg3RnpQTHpxTy9VV1BDNjFnRlkzVEY1Wnl5?=
 =?utf-8?B?Snc1MDB1bm9tc3FzL0ZjblVnanZxUUhNeVB1ZVZ2RnQwaVlpVnp0L1kxclBT?=
 =?utf-8?B?VDFJK1lKNWd2ZUo4Qy9JbjErN1ZRWk9mQ25OblJ6SUZrdmRsVGVZL21RV0VH?=
 =?utf-8?B?ckZXZ2FUUGZYM24yYTZPZkRUaHdlb29ES1d4YmtzKzJwQXJFTFdweC9oc1dh?=
 =?utf-8?B?QzI4T0J3MzJBL2RJNVhSbnl1TWpUUlY0T2d1UEd0Y2g3NUNaaU02K2RRTFZP?=
 =?utf-8?B?Rld1MGZCUHhOeHFzLzBMWG9KRzVmVFk2VkRxVzlLVmpkSUlDVVZsdW9xUmN2?=
 =?utf-8?B?L29yZGJrZnYvVFpyb2k5V2RhbnN5aWQwTzJuQjNUYUZOZXJsbmpscjUxdGFJ?=
 =?utf-8?B?UlFaL0ZITCtzNFR6Y3M4Wkg2aStOaDNDaVljbGsyWXhMdlhocUpjZDJlTGdj?=
 =?utf-8?B?NnE3dG0wWXg0eG4xMjJrekFDd2tKT0xuRUtJSDNwaUQ0YUh4VVFrbFNvRy8r?=
 =?utf-8?B?bUdyQ2M2a2FMUmY2ZGFvZkJEcEdpME1rdnVsZFh2U0E0UFg2SjhlSGQ2Ykhv?=
 =?utf-8?B?Qy90eGVwTlFFY25iSkUrMVQrWGIwTWpFdE9xYVBnOWJlM1QyQUNGK3VvOGlX?=
 =?utf-8?B?KzArSDJMT0VsazVZNkZDbG96Vk9ILzg2NEFHaitpMExGbmlZYjN6ZWNwM252?=
 =?utf-8?B?dlRZU2EwUEpTMWhKbjU5UmpRVzhVMlp5WHVKWWVtMllkeTEvMG9ldi9BVTNZ?=
 =?utf-8?B?aVZueUpvMWxtV3kwRTVCZndxYUtydENjYnltek0xYWRIajE4NUs5ellCc2pR?=
 =?utf-8?B?OVJZTUdlWFQ5M2FIcHM3NXdaZ0RQbFluOU8xYTIzNlBrTnhrR0xvZ1oyRExh?=
 =?utf-8?B?S0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A26453AB7D842A4A9208E6FF1108E7F9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a7c2711-83cd-407f-ebed-08dd14072b32
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2024 01:58:37.8115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pQqtZlxZawgGEiG5N4JNho3cO15WDi+JsVCOCV9UNkI9ING04vYkhOzWD8SGZplv7SQ5kVVvXpgfB28kRPvBrrVlteNIQ4tuOFaQIrW4PRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8130
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTEyLTAzIGF0IDEwOjMzICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
KyAqIFREWCBBQkkgZGVmaW5lcyBvdXRwdXQgb3BlcmFuZHMgYXMgUFQsIE9XTkVSIGFuZCBTSVpF
LiBUaGVzZSBhcmUgVERYDQo+ID4gZGVmaW5lZCBmb21hdHMuDQo+IGZvbWF0cyAtPiBmb3JtYXRz
DQo+IA0KPiA+ICsgKiBTbyBkZXNwaXRlIHRoZSBuYW1lcywgdGhleSBtdXN0IGJlIGludGVycHRl
ZCBzcGVjaWFsbHkgYXMgZGVzY3JpYmVkIGJ5DQo+ID4gdGhlIHNwZWMuIFJldHVybg0KPiBpbnRl
cnB0ZWQgLT4gaW50ZXJwcmV0ZWQNCg0KT29mLCB0aGFua3MuDQo=

