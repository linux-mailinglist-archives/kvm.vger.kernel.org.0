Return-Path: <kvm+bounces-18750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F31C68FB059
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:49:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 680401F21E27
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 10:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4694F144D2D;
	Tue,  4 Jun 2024 10:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hlYkFf0K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D5B144D25;
	Tue,  4 Jun 2024 10:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717498146; cv=fail; b=LjYfzlFK7oHpNgbeX7Tt8XZbb7TMTBF4Ok8HHC7PN2xF71ABTlNcmGYlgzZtoNEgyo8a5buyL/HCUnqiadI8X3TN0ImKczpzeDWnzvS9qgMlrdZ7ryKC99igWqE3DnASM4u1JIapYePaBJR7yHO3TPldqmys5iJX9DqzQNNaAq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717498146; c=relaxed/simple;
	bh=m3+4PH1NC8WyqyPyZeIEdHVQEg+GzdW4uaCNNnu5CNw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Mazvl11SpxxFPhmvEbUkDqfcHVvdLbzyV7OQMJKOFyr8nNcH1wMkRx+1x6fd/rFK7NPpjEKTm/gtZdpUjldip+JVuSraN5Pt1ShwkIWJznM7ntgmxQeeUHvKIqFFC7mjepr0ZhkzywnXCY4QaN39XLETRS2ZXTfGHfETQk1K8WI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hlYkFf0K; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717498145; x=1749034145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=m3+4PH1NC8WyqyPyZeIEdHVQEg+GzdW4uaCNNnu5CNw=;
  b=hlYkFf0K/wViwZ8xMUAl/6Xk30gnKCRuE9UgUEK5HY0NpYJ5I5vfp6m8
   QzY5mJ7tDJGUVDcN9eoZxV/edjzmjj5DCkXJOwuHsEq7x++mdhTc2+4k5
   t7nMS0Jmvi60hPFB+qT2nqZmSPDFQBdQ7EKEPzKo17JCXA2GglH0GUCcz
   ofw6c+O0vuHAaJY/vXQ5jc8YrhLMOtE4JWp90EZDWebaUUwHMHmSXmohq
   hgQSLysN+wyg5Meo7/DJjQJJtROmwiJS+tmbOQiW2BFmirtd/6v5u1e4x
   mpMK6GCnqZOsNkNWhud2ArKYlJFo/1AWyq2xWb5KbsGAHfk4jgyyjdhXN
   g==;
X-CSE-ConnectionGUID: OFzt+OKHTlivBRP616pgIQ==
X-CSE-MsgGUID: OYXiDz6gSVyP0vxrl/V9aQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="14192370"
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="14192370"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2024 03:49:04 -0700
X-CSE-ConnectionGUID: Iepc57nRQ8e/pAnlujjRFA==
X-CSE-MsgGUID: pGHXAWlLR8SnAvmg12Gzrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="41743359"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jun 2024 03:49:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 4 Jun 2024 03:49:02 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 4 Jun 2024 03:49:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 4 Jun 2024 03:49:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 4 Jun 2024 03:49:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epV/RD2eRfwQZho6LRfXRDDFAme4IjWZGtZ1qfFNRnz21ya9Fvj8fAQqZoB+fzRCEljdOoLsQC6mRvOB4QHS/wLJt1cVnpy2Fggv7AAHBjKPsqG/qgQTqz1T2pAasqD9DI8DUJv60vPQh7R/Sbq0Ktc74CmsrYaThC9yOCXAjODrSK7UW/Fb4b9obxZM48Geh85qvu2ixXNJaolHmuefSvAzD7YL5IZ8qvPnkw2O0bN7wMVpAIEupFXx6C9kGJurEb+PfO7CAkXf5d7pq8ybW4N9ZyatSNMQ0YE780vXlEFp8+nZePZITl25G8NZHxVxbEHRkBftCt6EfuGYTusYXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3+4PH1NC8WyqyPyZeIEdHVQEg+GzdW4uaCNNnu5CNw=;
 b=fhmnqCZb0aofNziHm30VgXF1u+ldUdZtOpNWKmmLU5PFmuoLiue7WJ57cqbz/k3DA+SA9YPb7dmQI26F9bbaGZ67CvF3k64suygc8zDCmcy4zQ1qsZ1Y4Vjra0/KkvguYfVqXa2WCFDho+KSYTyzqBiixhClFJ89z8x6IexH6dFl2hxP79u5Anq6TquBARzvJOA7HR8bFmpoRAAk3oZgSF1iWZN47ai8ri+nBp8efHaCbcKN7JSEyB8oQhdCnZTs4YwjpaHv//dZzD3KUfW1wxmToggU7iIm4H7e83fHstX1gAlCu+nL6Op0KZ3Fqmnbp8lMlwoxcI6jY3129rSw9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4872.namprd11.prod.outlook.com (2603:10b6:510:32::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Tue, 4 Jun
 2024 10:48:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 10:48:59 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Thread-Topic: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Thread-Index: AQHaaI2/dJkfmwuOl0Kzt5Q4G20a/rGPjNSAgABl+QCAAANegIAAB3kAgAAJ9QCAAO1bAIAFfyEAgBj234CAANvZgIAAtdgAgAcL1wA=
Date: Tue, 4 Jun 2024 10:48:59 +0000
Message-ID: <38210be0e7cc267a459d97d70f3aff07855b7efd.camel@intel.com>
References: <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
	 <Zjz7bRcIpe8nL0Gs@google.com>
	 <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
	 <Zj1Ty6bqbwst4u_N@google.com>
	 <49b7402c-8895-4d53-ad00-07ce7863894d@intel.com>
	 <20240509235522.GA480079@ls.amr.corp.intel.com>
	 <Zj4phpnqYNoNTVeP@google.com>
	 <50e09676-4dfc-473f-8b34-7f7a98ab5228@intel.com>
	 <Zle29YsDN5Hff7Lo@google.com>
	 <f2952ae37a2bdaf3eb53858e54e6cc4986c62528.camel@intel.com>
	 <ZliUecH-I1EhN7Ke@google.com>
In-Reply-To: <ZliUecH-I1EhN7Ke@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4872:EE_
x-ms-office365-filtering-correlation-id: 86b9a56b-309d-423e-7f29-08dc8483f0e5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?cGR4Rm41NDRaTzViRk15TWpHTDJUM2RoRHBNZEpucHFid2ZxWTBtR3BXYVJ0?=
 =?utf-8?B?Y3BUdVlJbkFZZ0pGVmdaYlRUdWNpL3pzbVB2L0tmTHJZNGlMRk50Q25QNzlS?=
 =?utf-8?B?MmNBcmtsUUdLZ3ZWTWZUSVVVVlRHRzdXUDlYRXZwbVdaRVlER2FURWJMSkNx?=
 =?utf-8?B?Rlcvb3lLYjJjODVVZ25PeHNwSUJVcHdiaS9tby9BUnB3WThhMTRsdUE2M0hN?=
 =?utf-8?B?Njhla3BXc0tVSTNqdDJTVnUxLzl3M2dqS0ZBcmJUTG5QMzdWVzltUmlBRktL?=
 =?utf-8?B?bGIrd1JkQ0dIcjlYM1hybVo2Z0JIdDB1REZFUHRTZnJVRWRaZTE0ZGlkUTlv?=
 =?utf-8?B?SGtMekVhZGJpRStJdmRjK0l2Ym5yaDNZLzRDK216YTI1QUZ1N3U0U21Ec2Mz?=
 =?utf-8?B?S0lscnBvS1pMSVQwVFA2ZjVMd29sOFZCYXVnODNVYUtWVmMyUk5UbW5kalcr?=
 =?utf-8?B?VzBHZ2p4U0V1dTN2S2J4NzVHYVFQN3E0bEpFL0hKMzhtQ1dkNzdsZFlKamdR?=
 =?utf-8?B?bnBzVTQ2ZXJjSUR4d1Jxb0RZTGp0QWFYMVdOMERLSCs4SkZDeGIwdElVTm9S?=
 =?utf-8?B?QStPcnJWZ2NNYXNrM0VDUDRmYmNjTE8xSmt2UHZMM2NuY3J3TkxWUHdwVDZN?=
 =?utf-8?B?Zm1PcDZKWlpvTzZvclQvd1hMejY3Y3FVRGVBT3NVUG1UYVpTRzhVaFp1L3Fu?=
 =?utf-8?B?dnczN2h2L0NUZ1NVNThaWE9xU1lhckVvOER4MEtoVjEzb1hIazBPSTROSHdW?=
 =?utf-8?B?UURCTmNWUUVSenc5WTlqREQrZUVDTFBzTm9wWjFxSjFGZFR5UGRoc0RQb21s?=
 =?utf-8?B?NFFES0Y5L2swczR5QW5wdjl3aENmdnh2TWJXSmg2Tjk5Z01BaVk2ZWppMCs5?=
 =?utf-8?B?cEsreVRoajZ6R2w3dFJRTlBFc3RRbEJtTlFtZ2FQNUlER2IrRFVNV2FJMm9I?=
 =?utf-8?B?LzE0WmMrTlhyblh5QS9IMHBOYzdVZXg0Zkw0ZVhoZUdLM0JkOWxXTzVJTjVB?=
 =?utf-8?B?YXNRblF1QldDMy9uV1VIdk1KY1RxR0VqK1pBbDRYYUIrWlppbGZiNE5rMGlU?=
 =?utf-8?B?QVdRaEhhQlM0YVZEdERhZlVLWG40RWtPSHo0YzNHN255RmhxSHFoVytBNVgw?=
 =?utf-8?B?YlJ1Qk1nVGJXcENHWU9oOTkzbHJndVBCZkhwdGtlZGtRaGgvU2l0M0R1YVRq?=
 =?utf-8?B?ZFppaWhxTlh2a2EveGtiQnlxbGhnS1krVjdNYUZSZ3UzL0VUb0FZMWNOcEZS?=
 =?utf-8?B?Y2F2RHV3ZVpCako1OFlFS0FPVDlXWkFDbW96SFVLcG8zVkhaSnZVSUhDMHdU?=
 =?utf-8?B?TVZ0SExscElyME55WnZxRGdoYm5hakhDQUFlZ3BqcWZmNzUwc1FBSlV0eTRF?=
 =?utf-8?B?dVRIZmtzV2R0ZG9yT3B4R1FyaHdiOSs2ZG9lNjMra2RFd2RYYklKM0NhQ2Zr?=
 =?utf-8?B?d2kyZ2FOU09JRmVFUXNqQ0FGekoyZUtYeXM4MG9QMWt5Wit5anJzcHRDS2VU?=
 =?utf-8?B?SVVQSUVTam9aZkZ3Ri9qZ1JoMFdISkhmTXEzeUtrQlpLcFJycC9HUmg2WlJV?=
 =?utf-8?B?Tk5zbjd5SDliZkVCNVR6ck84MVFIYU1pRDgzRGQrc0didlVTUGlaUDlnMkdE?=
 =?utf-8?B?WEQwOTBiUVhQOEV5dWxUVEZuK0FvKzZveVdoYTZ4UmJaYlBVQ2FCbmRsbEtm?=
 =?utf-8?B?ZVIzWkZGTldlUDFRZG81SHVpMGZobktYNXhCUkFHczZNaFlVZk9RZDlXaG1q?=
 =?utf-8?B?K1ZDeENBMnVzNXpmTDZia2d2NTZrRjFweDJrV3JvdmxISWpFalB1emdIN1dX?=
 =?utf-8?B?WHZxZE03ODk5QThsbThHQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WktNY0dzTy9vTnltY3o4SHg0NDhxU0IzWjZrTnF2akIrZXhrNmlCazhYbzcz?=
 =?utf-8?B?bklhdS9LVk9QclIwTlI1Z2tidlRmMGZUTWNmMHJwK3hLUEJrMU1ydmZ1bm9V?=
 =?utf-8?B?ZklNbDFIdk9XY3FEOXJ3OXlBR2JaclJKam1Jb3UrRUpGSGVwV2lWbVJvNEJ2?=
 =?utf-8?B?M1VXa2MzNWdnUFd1cDBpSkFYNkNLcEdlcFVaRXgyNFRWcURmak5tQy9qSU5E?=
 =?utf-8?B?M1p5N0RwUE4wSnV4TVByUEVVaVp5OTkrLzdIN0p3UVJZR3NEWG5mTGpuZVQ0?=
 =?utf-8?B?cVBGdndadUkrMTk2SXpranlVc2xrSFJNMHNaRkNOdExRc05iVm9QWC9DelBt?=
 =?utf-8?B?bjMyYXJTSzkyQ29jYllMYisvQmhPUkpTWXJPZ28wYUVlSno3N1dUcGxocTlL?=
 =?utf-8?B?U0tob01MclRLMmo0Q3Z5dzYyMS94M0NxMkpaT2NrcVA5bGRtN2ZiZUIyTkxB?=
 =?utf-8?B?OVh1VnRlWnhhQkhGc1grb3g0K2xoN04yUkNUclA3VEp5SUowZjBEb0NSZ3VY?=
 =?utf-8?B?N05RYU9td0ZqNi9CMXI1bzlnbHdkc1ZVcWRZQW91dWhoNkNLMVVEVHc4NnRj?=
 =?utf-8?B?ZGlaZUswdWVWSmdESVJ3RUhpNWthT0hpbGlRSHdzQnRnaklUTndISnBTZWxh?=
 =?utf-8?B?djF6emNlcllmZllMbE56SVlZd2JiRm5qUFNRSFkzVm91aDFvU0FDeGljUmY4?=
 =?utf-8?B?T0ZMSjk4NVIyeDFWQTM2UCt3dWdiU1NsYkNRM2ZReEplU3ZZenR0ZnNBYklr?=
 =?utf-8?B?L2YyOVJTM2EycWlaL1RRMW53Z1FlbkJiYUo4WVhmU2xtL3FaODRxOEVLZGZa?=
 =?utf-8?B?LzRsWWVLVTdUSThMQ1lVamlPVU5VbGhjSVhLdDA4WEhTbWlwSllFZ2NDVHhY?=
 =?utf-8?B?eWpZdGt6SjZXR2wyNnJNSEhlL3VtU0JsNUhjalFWd3pmY2ZpM1l2WkFNbzJl?=
 =?utf-8?B?V2MzakNUeWdmTTg4WDlBenc2VW5SVXVjM0xpaURrTzdCNDlOU1dnVEZLS2I3?=
 =?utf-8?B?QkVJSjV5ZkZlSDM2RXp5REF2Z0pkOVo3V1FhUGt3Mm9FWWNYaVlVYitOR2g1?=
 =?utf-8?B?YWFVTURPU2d4VzFYL0tFMEpYY0pQUk5WWU8xTHM3UTQrOTZ3Wkg4UytxcXR0?=
 =?utf-8?B?VmNtY1gxVzBDQTFybDBCN0tlZWVQTnFKRzRwNXBmN1lhdks4bTdsTU9TZVBC?=
 =?utf-8?B?eEpwVnhKMU1hYS9rcUpaUTlYMis0ZEhKVnlSK0xobm9nUVhhVjFOY1ozNlND?=
 =?utf-8?B?dkN1TXRic0J1clpRSzRyWCt4RmdzbHVhZy9IRkFZV21TNExzSzVXQ0xlNHpD?=
 =?utf-8?B?THJVdDk3Vk1PS0tOUDQvVnVMRFdmSnJTdzZlM1Q0K3R2QnZwKzBZekRwRXN1?=
 =?utf-8?B?NW5HN1NrMnp3WUNHZjZkRmZyc2xGSGNDdGRLUU1kS3J3WkxIZzNTMHJLaU50?=
 =?utf-8?B?enRmZHBpVEFVU203SnlnYXl2K0tlSWtON1lhR2lacExnbXdiSnErOCtPSno3?=
 =?utf-8?B?dGtVZ1hLSU8rYjNqYkRXdXFOeVM5SjV1bG5nZm1qY1JPdFpUWk9oVWdDMXRO?=
 =?utf-8?B?OGZHQ21kcGx2UlhsZmJSejY5Zm1sU0R3Mis5YlJDZlVkL0hOWGRuNk14MnQ0?=
 =?utf-8?B?NERLK1ZSV1BOUDJ1RzZ4a2JpV3l6UjhpcWJudzVieEIvMm5KZDl3dGxCQXVi?=
 =?utf-8?B?RFRNaWVPUnpFNTJhM1FSNDdMaGp0NkxhTVRqOU9ua1laUkhUdUdwTXVDWkdm?=
 =?utf-8?B?eTBlSm5lMndZQ3FWQ1JhaisvZWFvL3E2cm5ROTdKQlk0TFRGYndFN0J5QW5r?=
 =?utf-8?B?dGdKcFBUdWR0aFFqYmQrY01vdldMWEZNeHRSM05hOVNOSlB1TTNhNVV0WnJ2?=
 =?utf-8?B?eDFEcDI1bUozMEgwM3pORFlMRGdFVzA5Q3lZZmgvM2YvK2NQWEpMaW1xYWts?=
 =?utf-8?B?ZWdOMnRMaVp1T1RDSk9XNk1pTGdVYzlnc3Y5a2dmRzF0N0ZmK2d6aVVMN0l6?=
 =?utf-8?B?TVd0NFZMTlp3MXZEdWlRWldhVXZ6NS9xTkpnQi8ySURyVnVVejdHUnVCQVRh?=
 =?utf-8?B?bXRsMGlYNTE2a2tHcE9GQXQyL01LcmIrSFBMZ2h2ZWN4Wkp5ZFpBaXZmc0ZW?=
 =?utf-8?Q?Tow9uqPeJUj2VEQNI2rcnLsrM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <365D1C08B739764C9B51DF48B67BF181@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86b9a56b-309d-423e-7f29-08dc8483f0e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2024 10:48:59.6876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fmdGnUXUtDyy+P5bemTDQpsY7gSYpActHSkHhF1+VudFURJVWZiMJrUmsRwIfMYls91NAXyaOrCxAH8pMiKZ9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4872
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTMwIGF0IDE2OjEyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE1heSAzMCwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFdl
ZCwgMjAyNC0wNS0yOSBhdCAxNjoxNSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IEluIHRoZSB1bmxpa2VseSBldmVudCB0aGVyZSBpcyBhIGxlZ2l0aW1hdGUgcmVhc29u
IGZvciBtYXhfdmNwdXNfcGVyX3RkIGJlaW5nDQo+ID4gPiBsZXNzIHRoYW4gS1ZNJ3MgbWluaW11
bSwgdGhlbiB3ZSBjYW4gdXBkYXRlIEtWTSdzIG1pbmltdW0gYXMgbmVlZGVkLiAgQnV0IEFGQUlD
VCwNCj4gPiA+IHRoYXQncyBwdXJlbHkgdGhlb3JldGljYWwgYXQgdGhpcyBwb2ludCwgaS5lLiB0
aGlzIGlzIGFsbCBtdWNoIGFkbyBhYm91dCBub3RoaW5nLg0KPiA+IA0KPiA+IEkgYW0gYWZyYWlk
IHdlIGFscmVhZHkgaGF2ZSBhIGxlZ2l0aW1hdGUgY2FzZTogVEQgcGFydGl0aW9uaW5nLiAgSXNh
a3UNCj4gPiB0b2xkIG1lIHRoZSAnbWF4X3ZjcHVzX3Blcl90ZCcgaXMgbG93ZWQgdG8gNTEyIGZv
ciB0aGUgbW9kdWxlcyB3aXRoIFREDQo+ID4gcGFydGl0aW9uaW5nIHN1cHBvcnRlZC4gIEFuZCBh
Z2FpbiB0aGlzIGlzIHN0YXRpYywgaS5lLiwgZG9lc24ndCByZXF1aXJlDQo+ID4gVEQgcGFydGl0
aW9uaW5nIHRvIGJlIG9wdC1pbiB0byBsb3cgdG8gNTEyLg0KPiANCj4gU28gd2hhdCdzIEludGVs
J3MgcGxhbiBmb3IgdXNlIGNhc2VzIHRoYXQgY3JlYXRlcyBURHMgd2l0aCA+NTEyIHZDUFVzPw0K
DQpJIGNoZWNrZWQgd2l0aCBURFggbW9kdWxlIGd1eXMuICBUdXJucyBvdXQgdGhlICdtYXhfdmNw
dXNfcGVyX3RkJyB3YXNuJ3QNCmludHJvZHVjZWQgYmVjYXVzZSBvZiBURCBwYXJ0aXRpb25pbmcs
IGFuZCB0aGV5IGFyZSBub3QgYWN0dWFsbHkgcmVsYXRlZC4NCg0KVGhleSBpbnRyb2R1Y2VkIHRo
aXMgdG8gc3VwcG9ydCAidG9wb2xvZ3kgdmlydHVhbGl6YXRpb24iLCB3aGljaCByZXF1aXJlcw0K
YSB0YWJsZSB0byByZWNvcmQgdGhlIFgyQVBJQyBJRHMgZm9yIGFsbCB2Y3B1cyBmb3IgZWFjaCBU
RC4gIEluIHByYWN0aWNlLA0KZ2l2ZW4gYSBURFggbW9kdWxlLCB0aGUgJ21heF92Y3B1c19wZXJf
dGQnLCBhLmsuYSwgdGhlIFgyQVBJQyBJRCB0YWJsZQ0Kc2l6ZSByZWZsZWN0cyB0aGUgcGh5c2lj
YWwgbG9naWNhbCBjcHVzIHRoYXQgKkFMTCogcGxhdGZvcm1zIHRoYXQgdGhlDQptb2R1bGUgc3Vw
cG9ydHMgY2FuIHBvc3NpYmx5IGhhdmUuDQoNClRoZSByZWFzb24gb2YgdGhpcyBkZXNpZ24gaXMg
VERYIGd1eXMgZG9uJ3QgYmVsaWV2ZSB0aGVyZSdzIHNlbnNlIGluDQpzdXBwb3J0aW5nIHRoZSBj
YXNlIHdoZXJlIHRoZSAnbWF4X3ZjcHVzJyBmb3Igb25lIHNpbmdsZSBURCBuZWVkcyB0bw0KZXhj
ZWVkIHRoZSBwaHlzaWNhbCBsb2dpY2FsIGNwdXMuDQoNClNvIGluIHNob3J0Og0KDQotIFRoZSAi
bWF4X3ZjcHVzX3Blcl90ZCIgY2FuIGJlIGRpZmZlcmVudCBkZXBlbmRpbmcgb24gbW9kdWxlIHZl
cnNpb25zLiBJbg0KcHJhY3RpY2UgaXQgcmVmbGVjdHMgdGhlIG1heGltdW0gcGh5c2ljYWwgbG9n
aWNhbCBjcHVzIHRoYXQgYWxsIHRoZQ0KcGxhdGZvcm1zICh0aGF0IHRoZSBtb2R1bGUgc3VwcG9y
dHMpIGNhbiBwb3NzaWJseSBoYXZlLg0KDQotIEJlZm9yZSBDU1BzIGRlcGxveS9taWdyYXRlIFRE
IG9uIGEgVERYIG1hY2hpbmUsIHRoZXkgbXVzdCBiZSBhd2FyZSBvZg0KdGhlICJtYXhfdmNwdXNf
cGVyX3RkIiB0aGUgbW9kdWxlIHN1cHBvcnRzLCBhbmQgb25seSBkZXBsb3kvbWlncmF0ZSBURCB0
bw0KaXQgd2hlbiBpdCBjYW4gc3VwcG9ydC4NCg0KLSBGb3IgVERYIDEuNS54eCBtb2R1bGVzLCB0
aGUgdmFsdWUgaXMgNTc2ICh0aGUgcHJldmlvdXMgbnVtYmVyIDUxMiBpc24ndA0KY29ycmVjdCk7
IEZvciBURFggMi4wLnh4IG1vZHVsZXMsIHRoZSB2YWx1ZSBpcyBsYXJnZXIgKD4xMDAwKS4gIEZv
ciBmdXR1cmUNCm1vZHVsZSB2ZXJzaW9ucywgaXQgY291bGQgaGF2ZSBhIHNtYWxsZXIgbnVtYmVy
LCBkZXBlbmRpbmcgb24gd2hhdA0KcGxhdGZvcm1zIHRoYXQgbW9kdWxlIG5lZWRzIHRvIHN1cHBv
cnQuICBBbHNvLCBpZiBURFggZXZlciBnZXRzIHN1cHBvcnRlZA0Kb24gY2xpZW50IHBsYXRmb3Jt
cywgd2UgY2FuIGltYWdlIHRoZSBudW1iZXIgY291bGQgYmUgbXVjaCBzbWFsbGVyIGR1ZSB0bw0K
dGhlICJ2Y3B1cyBwZXIgdGQgbm8gbmVlZCB0byBleGNlZWQgcGh5c2ljYWwgbG9naWNhbCBjcHVz
Ii4NCg0KV2UgbWF5IGFzayB0aGVtIHRvIHN1cHBvcnQgdGhlIGNhc2Ugd2hlcmUgJ21heF92Y3B1
cycgZm9yIHNpbmdsZSBURA0KZXhjZWVkcyB0aGUgcGh5c2ljYWwgbG9naWNhbCBjcHVzLCBvciBh
dCBsZWFzdCBub3QgdG8gbG93IGRvd24gdGhlIHZhbHVlDQphbnkgZnVydGhlciBmb3IgZnV0dXJl
IG1vZHVsZXMgKD4gMi4wLnh4IG1vZHVsZXMpLiAgV2UgbWF5IGFsc28gYXNrIHRoZW0NCnRvIGdp
dmUgcHJvbWlzZSB0byBub3QgbG93IHRoZSBudW1iZXIgdG8gYmVsb3cgc29tZSBjZXJ0YWluIHZh
bHVlIGZvciBhbnkNCmZ1dHVyZSBtb2R1bGVzLiAgQnV0IEkgYW0gbm90IHN1cmUgdGhlcmUncyBh
bnkgY29uY3JldGUgcmVhc29uIHRvIGRvIHNvPw0KDQpXaGF0J3MgeW91ciB0aGlua2luZz8NCg0K

