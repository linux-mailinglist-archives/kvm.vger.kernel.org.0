Return-Path: <kvm+bounces-54541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 57A7AB234CB
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 20:43:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6746F18818EA
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 18:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 570502FFDD7;
	Tue, 12 Aug 2025 18:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="flCg8cXx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEAB2FF17D;
	Tue, 12 Aug 2025 18:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023951; cv=fail; b=KA7ACznn/CLgl7mtVkSWaChcuPiD52egPfTPwB4ZUhgY4+GEo+n/AHR6inlRR0rdP1IxKbWQwioaEf/oFeus+UGlFoa6ewxoYlDf7496RokVVuIiDFKXb92Ausf1eNTosSsVhJoW4pSX7da6cTbO6fA658w/r84cR7sklohVoB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023951; c=relaxed/simple;
	bh=CwAgN5aEwYkmuVFI42TX503fVU6L0PH4kKjPcbRGnjU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FIO3bO+IdHalQrEmpW9bz9iWMwSwbyvN06OiiHSPeV/u2/R8GLPOg1MIhvwOQvI9LHaIHI0K01UJygNVzxHB9uOmzX/ISxIo4vU5EBe4mNd9jpxMlrkPSrhPKbKq3Fd+ct71Q5VwY/T/+5WNVHkNIXB1vuAy05ByFoiDlPqBTBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=flCg8cXx; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755023950; x=1786559950;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CwAgN5aEwYkmuVFI42TX503fVU6L0PH4kKjPcbRGnjU=;
  b=flCg8cXxJjscO0E92NuFWLv1YnMcXXPDpX3/dhm8yNOcuznf+qJf3njB
   WdsbmXCU1UHpohbtyyneCVEcH7MBsI1dGSKrbQfqE69gpYLK6czhMhQbb
   vcKqvEjTGiKgLAQN5a+tdtT7S8G1jL+MbcmlJvO6iAGLY6Dlv3ShDObTy
   jRJ8XYgkFm0B3RGHeKbfufO+9TBJKd2CPO3iWoHVnC59ixaaibwWkYz7I
   Fk+jGg9dBxhGtqhQQHJqMGe2JU/5wLwkj/+dl373tbIx2E8eJZOZ2hJup
   GAIe5xdPnwLwx1a519JK0+LwQYpIX2tBuBnwHZos9uWJgfBcuNPCfbZhj
   Q==;
X-CSE-ConnectionGUID: gIbhlY++QGGkPHwawfPwZg==
X-CSE-MsgGUID: 08aE5CfJR8OIjq6lUZ0ncA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="61152209"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="61152209"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 11:39:09 -0700
X-CSE-ConnectionGUID: 9oidd68OSGS9N5o28X2Dmg==
X-CSE-MsgGUID: /7V9MzfpTa2VYnMmbEVFAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="189969423"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 11:39:09 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 12 Aug 2025 11:39:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 12 Aug 2025 11:39:08 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.42)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 12 Aug 2025 11:39:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dIpJnHkUwkH64z9sEcRqCtK2Fbnvb6jIMmUP/pRrKDmLFyrQxltOMiaaqC4IantAi0CiMEz0C2l2DFiecoehpRTr0EpU6CbuB/u2d7PfoNRmorovhJNYMFrrZOudSxRubF1Gd6B8lkp3bnh5V/3gQZwPDq8ZyKfZxn+I0OBQ7vXvjBtTbIh4WXakQH7qznj7TYVRKt5zE+H0I65cZR94csMaCyTFkObU9kYFVcUfDR8HCrZAEHoLVnzuT7yCjLmSI2uT/i/a/08/Oiz03fIHE8K6VH3fJPC5hpw7ygqS9uWvm4OEhgjWSXmluwP5nptPvASUlHFmYOc9y/3S76uLEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CwAgN5aEwYkmuVFI42TX503fVU6L0PH4kKjPcbRGnjU=;
 b=MrpD79F5rZKGZWWUpGzNFK8L5XYJ+fOcLKS7JQujhSrTl86AT+U2V28BQtv9E0Nn7eyiveIYLYghmMlZIjz/L5a13N3ruru9ZaBGxHSiRKGATbdH7DnVokpfNX9B8sSThryu5KZJ9SwFDizN7l3sRpu5LEEvmZyGw/mT6Y/sqHh8L2OV8iCaPZyUYO+5KnxcIjr+L6/EvXieICI7M/qqvhANmHhwDBhIKG/UCZhHKcTfYN2CWxJPqZ+9OHl5ssH323m8q43Uz0TXubZSqwEDA6Jssz5gm7TVTE8+OR/X2t58eDN/MTueiF8949oxEmj3XnIqaNyrDDpGSb11RRAVXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4824.namprd11.prod.outlook.com (2603:10b6:510:38::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Tue, 12 Aug
 2025 18:39:05 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 18:39:04 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Index: AQHb2XKrCJQDYmgN9EmkL7mVJaZZf7RZwqaAgAOdgICAAQwrgIAAOwMAgAAILQCAAF0hgIAAd5yAgAARcACAACgtgA==
Date: Tue, 12 Aug 2025 18:39:04 +0000
Message-ID: <6b7f14617ff20e9cbb304cc4014280b8ba385c2a.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
	 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
	 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
	 <aJqgosNUjrCfH_WN@google.com>
	 <CAGtprH9TX4s6jQTq0YbiohXs9jyHGOFvQTZD9ph8nELhxb3tgA@mail.gmail.com>
	 <itbtox4nck665paycb5kpu3k54bfzxavtvgrxwj26xlhqfarsu@tjlm2ddtuzp3>
	 <57755acf553c79d0b337736eb4d6295e61be722f.camel@intel.com>
	 <aJtolM_59M5xVxcY@google.com>
In-Reply-To: <aJtolM_59M5xVxcY@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4824:EE_
x-ms-office365-filtering-correlation-id: e3fbdcd9-6f3e-43df-2d96-08ddd9cf83c5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dUthNi9rZFFUeUVIcUd1ejhIZEtMOWdKaXp1N2ppczkwMW1KQVBMUkF6eUF0?=
 =?utf-8?B?MWhYak93MzVRaVVZRkwrY0E0VzhzblFicHVob2x3ZnhRYStpMlg3TWhFaEFV?=
 =?utf-8?B?d2EyTmkzd3hpSU9NWHBmdm9tRkthZVh3ZGpmUml2azFuTGJjRDJEd25qNnAr?=
 =?utf-8?B?MXRBL3JzczBRdElpa0dQMmZydDFrYXJLdjROcTFoY2pha0tqdEJGS2tjejdj?=
 =?utf-8?B?QXZuaGFFWlpVRkgwUUQ0Wk1WSXA0aXFTQ0dXMmZSNVZnUHVWVFVvK1NpdW1Q?=
 =?utf-8?B?NmV1MVMrQktwMGdzYzhZOHNzYitjUW9KaGc2a3B2cklFcWlITHNDd1BRdEVr?=
 =?utf-8?B?bDBhS29HVlZRSHE0cmZQbEFVNXRWR25RVzE3MVd0NTgrL2ZoVWdMaVc4RmRS?=
 =?utf-8?B?TXpVc3R2ZzlsaVZhZ0Jwek5VcWNvWVExTlQ0SlA5cjkwQVBUOTJrUW4wOTNK?=
 =?utf-8?B?M0hHWXNtY0g4aFVNR1JEOVphSjlPeXBSOEJLK0htenY0YllCeU44S210RHJk?=
 =?utf-8?B?K210ZDhNYkVzQ2psUVZPUGpJNW16UEZ0ME84b1JndUxMUDYyWXlWYTgxUkNN?=
 =?utf-8?B?c1hKL2pyS0UxUlpKRXlLUmloVDJZdEVWUUY5bVlBMjFVbnA1N1ZqUGRoVHJS?=
 =?utf-8?B?SkhqejhFM2NvclVZQnBCK0t6THpzZ2o4MHM0YTdEbTdkM1l5NThPRVNHUnQw?=
 =?utf-8?B?U21PcCsxYUhqMzZOa1ZaN2JoNmxjczk1L3BJSUE5UmdhVFY5NlA1a0tMeUFR?=
 =?utf-8?B?Z3Rud0R5c3lBN3hJNkRlc2NpQUtlT25HTXNMaGFXb2gxUFV3Nm9KSnNGN1BR?=
 =?utf-8?B?YjdBay9DSVRpL2NURWNiaTRkUWQwUlEvdHEzYnNUQ3RQeG9JT3NIRllLd0xU?=
 =?utf-8?B?QTVDWExGT295cU04VkJDaTJFU0d5QndrRHJERnlzRERTSko3RmRpaVJuVkNV?=
 =?utf-8?B?RWMvQnprRzEyNk1IOXJObXdSNC9FUWxyeHZsc0tLMXVwQ1RRZW03TW55NGdY?=
 =?utf-8?B?Ull5UXZYajNHUEpMNGNiTXVKYTJybGlnUVJQbVlSZkptNmNBc1hucGl5dlNG?=
 =?utf-8?B?NjVoS0JrYkpDMWIxZXRxZkZrMG9VcGQ4VzhzaGlYSTZ2OTY4ZVZYdGczOFpG?=
 =?utf-8?B?WmZHam1wRzloSDJPYnNlK0VrZm82VEp5c1ovVkR1enRBelVIMGx1NjJOV2J3?=
 =?utf-8?B?eWJrL3BnVnV1dmJ5NnQ3MmlSa3lVU1hyM0R2NlhEbWFJMys2WldEdmhrVi9w?=
 =?utf-8?B?SGxhK25LVFgrWGhUSnZZMTNVMGlaQnRtVGZRTWlEaDVFZFZGazlKeFh4V2ly?=
 =?utf-8?B?aXZ3RFVkVjBnakNHcDlhRkVvMDgraDJvOEcyaGNSblFsajZDSU9PYm5zaGw1?=
 =?utf-8?B?bzRobVh2TEU1cUNSeUx3cnhIc2MyZEd2aDdRMzdMODVxMmtlQ0w3S1p4M28x?=
 =?utf-8?B?SE9rWXE3Y09QYUJKNFpDb1dTdDM2UzFzWnV6WFpWRnhVZndxMFNFMmRDOG80?=
 =?utf-8?B?TFp6VFVITnNQeHozcWl6dHVWQjl0WlM5WDhHYUVXN1RPY2VRVUZnbjMwT3NI?=
 =?utf-8?B?NVIvUGZKL2RvZng2NGVCVWh2RkJOTVZxTmRWQlM0ZkFpNUp5NWhaeC92dEoz?=
 =?utf-8?B?K20ydm8yajR5RDZLS2NWM3laWHRyTmoweDJSV21tK1QzL3ROUGhEc2theHNL?=
 =?utf-8?B?eXlQeC8rS09yenRNVUJkS0I4Mmc0ODRvZ2YvUFZoN3VlOWdKMGlvNXpCNk92?=
 =?utf-8?B?aU9pV2ZUdjBNekFnazBBOHQzMnZPVHlQWnVFcGhRQk94ejRhc3U0QllCL0NZ?=
 =?utf-8?B?RDRYblJlR0lobi93Z3hOVkM3R1diMDc1TnIzVUlhVGMvMzB4eS9zTkpmVFps?=
 =?utf-8?B?dWFuWlJlVkR0MWxsTGIwQWFEQm4vMWF4V1ZmUzZ2YkJqN1h5eVFwMHUvb0c2?=
 =?utf-8?B?ODArMVg3MS9qTEkyNkl5QmZGTU90bTVtU2JuL3d6Mm9lZERNMGlVNlRVL0Nn?=
 =?utf-8?Q?bVAVxirmZ2iMuqomrnP76WewTqHV64=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0xzV1FuZWdQWEVVZVltejFLRjgvOHEveFFqWC9lWmFDUFhPNjIvMnFXRUx0?=
 =?utf-8?B?VG1JYTkwT3JuZFYwMExnWmJJUTJqZnNVcEI0NEV1SFg3V0tqbzhOeG9BWDhT?=
 =?utf-8?B?S3N2VytpWUhuVHRWbzFCTlduUWVKMjE1ZmliWmFNRkNndHdRdDhDVlN1aDBK?=
 =?utf-8?B?WmVtL3QyaTJVUlh1b0VMOU5KZm5GYkJGNFoxRnNpSkd3MVJKVWtPVnZmaXN1?=
 =?utf-8?B?U05yK0xoaVhmRUVtVi8vSElJSzRPL1ZxNEJqbTJRR2I3TVhZWlpkY2tmWlJp?=
 =?utf-8?B?dzBjWnYyMkJBdURwU2dFQ0dKVEhHTWlDQ0FHazVQampGY1JadHcyL3pzbk1M?=
 =?utf-8?B?VXVRQS8wcDNOZDR3cmxvZUc1UmtBRkpoOTVlUW4rZXBLYUkyOHpOQlgzN0RX?=
 =?utf-8?B?TTBaTFNnRVFiL2ZjeU9jMDdCWEFuWHNGd1dMUG9oZ1QvUmdRakFvaVVDWkl0?=
 =?utf-8?B?c0t3ZlJRQVNXdjdwQlhHWnBVY3VhQlNUaUVUU2JMTU04MWE0SnFJMExlbVpU?=
 =?utf-8?B?cXJKUWFjUm5EREp1S2hJelA0MVNseTZCMUlKVXNwVys5dHpvb09hQmdtUVpq?=
 =?utf-8?B?QXkzbWRzL2VYaGE0cWNUeTZRNld2cGJrc3NNejdlVHBOWmFuZmMvczhtZlF4?=
 =?utf-8?B?amh5ZlpsUmF0Z2ZneEVVa25EYUdORzlabTUxZHZTYVNkOHRsMDBrUHlzVVlj?=
 =?utf-8?B?aHBwTDVhamV5N2tMd21CVDNVWSsrMlJicW1MaWw5dy9EZzVUVzFjNzJwYjZE?=
 =?utf-8?B?bU4yZDMvSTFScmFzZWtyZTArczAycW9HV1NTVlltUUZJNjlVb29idkZQNU5a?=
 =?utf-8?B?dlRTdXBFMVpEbjhNVG5acDR1dHhNZ2MzR1dIa0J5K1dMb0dJc0liS3dGbnhy?=
 =?utf-8?B?NkZva1Y4NDlTekIrV00wK3BrUUZ6bXdDY1lmNmlvVE1SSk9UY0VRRk44dHlM?=
 =?utf-8?B?SEpzc2ViRjRURlBDdzZtRUV1VHBaZWpFeGVjV1JselpuQ1BKSVdBSGZ4Y2Rm?=
 =?utf-8?B?Z1BrK1RqMFVZZVpnTnpGN3RlUmY0bUM5KzFJNjdzTUZ4clA3TnQydFVnVjlN?=
 =?utf-8?B?TGE3RkQ1MkJCZml5cmhvS3RnQWNzTVFQUHEvWFVJaWFHQUo4azdhbXRCc0hw?=
 =?utf-8?B?WE9PcE9xdk1waHd5V0M3b3dyQnQ1cVQ0TTQwTDhHVThMQmRmTTlKaUNyWFph?=
 =?utf-8?B?N2ZjYzZZRmdvS0FMSzlvNkt4TUxXY2VaWFBwNnFrendYbGVCaHNRZzB2MzFZ?=
 =?utf-8?B?V3N0VG16WjFZbkFNTWNRMGtVWVordXUyOUJ5RENYREJBKy9QL0cvVzJ1aGtz?=
 =?utf-8?B?KzlMNmVXQkxvNEVBTUIyYUltOEI0U053Z2dwTlF4Zk9xdUtoVDMzS3lRbmFz?=
 =?utf-8?B?bERMb084QXV0M0lGUmp2Zmlaa1pVQVBINTNod0llMVR3RlNCK0hKUjBGM05h?=
 =?utf-8?B?RmpBU3dBMmo0T0tacEhrdVRuRThIeHo2QWZRRTQ1SE5OdElGWDlZMFM1WmxR?=
 =?utf-8?B?R0JrUHphUE8rbk50VU54b0RiZXFTSERabXJGMHJXdGlUN1FobHg3eDhLbTB4?=
 =?utf-8?B?YWdhU2dGaE1XaTUycmxDSFJQVndlUmlZelJQOXlwR2o0Qm1QNzlmVExVamEw?=
 =?utf-8?B?RnNPZVJPbDMzYTBET0Z4SVhXdVd3QnB0S0FLQ1k0Z0RHNmhkTXZhenZpWmxU?=
 =?utf-8?B?Rmo4aW1mRVVQb0FaNUtUN1ZxVTBidmF5QVRuS1BHa3JlTTVOWGFGUnBZb1lQ?=
 =?utf-8?B?R1RYa2Q1L1IwNFljdmlkZklBVmFoZnA2aUxqQnloVGVIeGtySktiWllCYkdI?=
 =?utf-8?B?elY2S0xZM1VDd0wyNjZtdW92VTFiWW05TkNYcVpKLyt5TXNFWGNwV0QrcWUr?=
 =?utf-8?B?a2FvVWNHejFYZGlIYzhhUmQ5VHF0ZjlsTWV1YUdYRXFkbTFZNEJNTm9adm0y?=
 =?utf-8?B?WmFOYnZuOUZ2dGFUREpXSlBCblJKRDlyVUkzTTNHQmsyYTlzdVgrQXhHRnhT?=
 =?utf-8?B?UzhIbktYS0M0cnlMK0RkOVBEUHhYendUSjZleW9XYXZFVWZneTBEWk1BTVVJ?=
 =?utf-8?B?L2RXYVVxa2Q5cjd0ZXlyZ3Zvd1BYV0JmeFVBdWpGR3ZORzFJTTAyNWFuWUJo?=
 =?utf-8?B?T3ZFZEpnWkZmNFlJNXYvelJzK0lkbmpMb1JLTmxNRC9iTVNiN21La3JUWkNo?=
 =?utf-8?B?Z0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF495FDB6EC19049A9458C56ADEE6C0A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3fbdcd9-6f3e-43df-2d96-08ddd9cf83c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2025 18:39:04.8303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UHnjh27HdnYBbi/reQGINvO0xjayN021XT6i9Zq7yshehRXmN0+w4MsmPEujylWddy9Vhh20SdVuD6IFwEmiBgTPL7SvTfhTUihZ4uGQw4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4824
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTEyIGF0IDA5OjE1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEkgYWN0dWFsbHkgd2VudCBkb3duIHRoaXMgcGF0aCB0b28sIGJ1dCB0aGUgcHJv
YmxlbSBJIGhpdCB3YXMgdGhhdCBURFgNCj4gPiBtb2R1bGUgd2FudHMgdGhlIFBBTVQgcGFnZSBz
aXplIHRvIG1hdGNoIHRoZSBTLUVQVCBwYWdlIHNpemUuIA0KPiANCj4gUmlnaHQsIGJ1dCBvdmVy
LXBvcHVsYXRpbmcgdGhlIFBBTVQgd291bGQganVzdCByZXN1bHQgaW4gIndhc3RlZCIgbWVtb3J5
LA0KPiBjb3JyZWN0PyBJLmUuIEtWTSBjYW4gYWx3YXlzIHByb3ZpZGUgbW9yZSBQQU1UIGVudHJp
ZXMgdGhhbiBhcmUgbmVlZGVkLsKgIE9yIGFtDQo+IEkgbWlzdW5kZXJzdGFuZGluZyBob3cgZHlu
YW1pYyBQQU1UIHdvcmtzPw0KDQpEZW1vdGUgbmVlZHMgRFBBTVQgcGFnZXMgaW4gb3JkZXIgdG8g
c3BsaXQgdGhlIERQQU1ULiBCdXQgIm5lZWRzIiBpcyB3aGF0IEkgd2FzDQpob3BpbmcgdG8gdW5k
ZXJzdGFuZCBiZXR0ZXIuDQoNCkkgZG8gdGhpbmsgdGhvdWdoLCB0aGF0IHdlIHNob3VsZCBjb25z
aWRlciBwcmVtYXR1cmUgb3B0aW1pemF0aW9uIHZzIHJlLQ0KYXJjaGl0ZWN0aW5nIERQQU1UIG9u
bHkgZm9yIHRoZSBzYWtlIG9mIGEgc2hvcnQgdGVybSBLVk0gZGVzaWduLiBBcyBpbiwgaWYgZmF1
bHQNCnBhdGggbWFuYWdlZCBEUEFNVCBpcyBiZXR0ZXIgZm9yIHRoZSB3aG9sZSBsYXp5IGFjY2Vw
dCB3YXkgb2YgdGhpbmdzLCBpdA0KcHJvYmFibHkgbWFrZXMgbW9yZSBzZW5zZSB0byBqdXN0IGRv
IGl0IHVwZnJvbnQgd2l0aCB0aGUgZXhpc3RpbmcgYXJjaGl0ZWN0dXJlLg0KDQpCVFcsIEkgdGhp
bmsgSSB1bnRhbmdsZWQgdGhlIGZhdWx0IHBhdGggRFBBTVQgcGFnZSBhbGxvY2F0aW9uIGNvZGUg
aW4gdGhpcw0Kc2VyaWVzLiBJIGJhc2ljYWxseSBtb3ZlZCB0aGUgZXhpc3RpbmcgZXh0ZXJuYWwg
cGFnZSBjYWNoZSBhbGxvY2F0aW9uIHRvDQprdm0vdm14L3RkeC5jLiBTbyB0aGUgZGV0YWlscyBv
ZiB0aGUgdG9wIHVwIGFuZCBleHRlcm5hbCBwYWdlIHRhYmxlIGNhY2hlDQpoYXBwZW5zIG91dHNp
ZGUgb2YgeDg2IG1tdSBjb2RlLiBUaGUgdG9wIHVwIHN0cnVjdHVyZSBjb21lcyBmcm9tIGFyY2gv
eDg2IHNpZGUNCm9mIHRkeCBjb2RlLCBzbyB0aGUgY2FjaGUgY2FuIGp1c3QgYmUgcGFzc2VkIGlu
dG8gdGR4X3BhbXRfZ2V0KCkuIEFuZCBmcm9tIHRoZQ0KTU1VIGNvZGUncyBwZXJzcGVjdGl2ZSB0
aGVyZSBpcyBqdXN0IG9uZSB0eXBlICJleHRlcm5hbCBwYWdlIHRhYmxlcyIuIEl0IGRvZXNuJ3QN
Cmtub3cgYWJvdXQgRFBBTVQgYXQgYWxsLg0KDQpTbyBpZiB0aGF0IGVuZHMgdXAgYWNjZXB0YWJs
ZSwgSSB0aGluayB0aGUgbWFpbiBwcm9ibGVtIGxlZnQgaXMganVzdCB0aGlzIGdsb2JhbA0KbG9j
ay4gQW5kIGl0IHNlZW1zIHdlIGhhdmUgYSBzaW1wbGUgc29sdXRpb24gZm9yIGl0IGlmIG5lZWRl
ZC4NCg0KPiANCj4gSW4gb3RoZXIgd29yZHMsIElNTywgcmVjbGFpbWluZyBQQU1UIHBhZ2VzIG9u
LWRlbWFuZCBpcyBhbHNvIGEgcHJlbWF0dXJlDQo+IG9wdGltaXphdGlvbiBvZiBzb3J0cywgYXMg
aXQncyBub3Qgb2J2aW91cyB0byBtZSB0aGF0IHRoZSBob3N0IHdvdWxkIGFjdHVhbGx5DQo+IGJl
IGFibGUgdG8gdGFrZSBhZHZhbnRhZ2Ugb2YgdGhlIHVudXNlZCBtZW1vcnkuDQoNCkkgd2FzIGlt
YWdpbmluZyBzb21lIGd1ZXN0bWVtZmQgY2FsbGJhY2sgdG8gc2V0dXAgRFBBTVQgYmFja2luZyBm
b3IgYWxsIHRoZQ0KcHJpdmF0ZSBtZW1vcnkuIEp1c3QgbGVhdmUgaXQgd2hlbiBpdCdzIHNoYXJl
ZCBmb3Igc2ltcGxpY2l0eS4gVGhlbiBjbGVhbnVwDQpEUEFNVCB3aGVuIHRoZSBwYWdlcyBhcmUg
ZnJlZWQgZnJvbSBndWVzdG1lbWZkLiBUaGUgY29udHJvbCBwYWdlcyBjb3VsZCBoYXZlDQp0aGVp
ciBvd24gcGF0aCBsaWtlIGl0IGRvZXMgaW4gdGhpcyBzZXJpZXMuIEJ1dCBpdCBkb2Vzbid0IHNl
ZW0gc3VwcG9ydGVkLg0K

