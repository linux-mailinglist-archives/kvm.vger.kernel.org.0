Return-Path: <kvm+bounces-29016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE379A10DB
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 19:42:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAA791C2251B
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 17:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF95212F1E;
	Wed, 16 Oct 2024 17:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bMJEl/vb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AF1212651;
	Wed, 16 Oct 2024 17:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729100532; cv=fail; b=ahH2zNl6dneHJ4pf51O//OZZ5x2DDuXoQ7XhLxVHJUUt8oB4q8FOe65yTs+z9YhKytCiEsapyP5a8nFY+7RIHHn3zo+wGjSj8bNMqim1JdvPbtFG2OFZZe02flA0ioYNFDddxqn6s48mNyj8h4Cxp0NZ9yW2PJpntLt/mclsxaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729100532; c=relaxed/simple;
	bh=quPpLeofJ5jiAsPCV/C0hhWFm29qCT23xEJj0CCQnEI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KljCIgDGxK2fVnQl2Qm4p4RjLNMeUXLUyXveJoDYdguVzCRTnjmzgXmx58i3nPidwMVouhJUMQtMJkkp2G+7m00tUjI/YWspcKx8FabMTOoyPmpsVVmErCK6SJQguV9OA2rnTlx6GNlXNwuMBKBBWsKK1mE81QcQbodDGA5QKRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bMJEl/vb; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729100530; x=1760636530;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=quPpLeofJ5jiAsPCV/C0hhWFm29qCT23xEJj0CCQnEI=;
  b=bMJEl/vbQN9Ahu09asjp2b6jGmxskODFBDW4CbY621XMBTuo7JQrNwi+
   NEFIr0YIAoOQWNzLj71tPgCzTZJFjU1kkmEUuQxaX1BASlMyQ7Ak53bhG
   +E7DYhFVK5NBvhXDOJAT2I0XYyEKDSrti4JWXtHu21rTvLAsZBTpHhH9I
   kEd6t1ovlgfR1irX3hddE+k6pdJd1sOkUr6Cu+aYrqMUeqvsjPnG8/ENL
   I+tFWVISEhIhpBVAoT9H8+qE54TqmV+QnwkbGb69yCPWdjRtajAnZx3JS
   jFKBRbNLspbUKe8/0LGN4pvD5/3FRRVbga3nwTI1Tk9G0eezbHSlteAxC
   Q==;
X-CSE-ConnectionGUID: 8tXrwa0DQI2e4PxT2Zh8uQ==
X-CSE-MsgGUID: KwsR6PqQQ0Si03tHnzq3VQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11226"; a="53978126"
X-IronPort-AV: E=Sophos;i="6.11,208,1725346800"; 
   d="scan'208";a="53978126"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 10:42:10 -0700
X-CSE-ConnectionGUID: LI+K4Ct8SrGYWfit9LjNVg==
X-CSE-MsgGUID: Vefb7toSReiMgpbvnJYG+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,208,1725346800"; 
   d="scan'208";a="83373379"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Oct 2024 10:42:10 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 16 Oct 2024 10:42:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 16 Oct 2024 10:42:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 16 Oct 2024 10:42:08 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 16 Oct 2024 10:42:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gjq3fjzFIY1ze7JSahIZGN08LD0psfrYMZ7T2KAPOH6Ja58zw+P55sLmk4xXoIcIdw3C4wsxiAb/0QGedegezC8TOCPlhH9Cd3NikvXcXtMPzFQVZoAoThh6v73mWd20CH2L0CD5QfDiT5HdbNmgzXSwow/CWRaAtwGYymBmoMFpUale9EtdKL2WrACMFsIKCdMkz5rgfQhMvpR7oEvSZ2ER+V+if29GgNT39l4E+swoB1OUOQOBeuRaIUmU49VPZAWQleUWIGY1Bo2FiV5AVvl0BYcd0bguK8fhx93gMXjiABHIZqGdNAd+ACC4IJzeNB9SKd+0IYUqZCcHRHTVlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=quPpLeofJ5jiAsPCV/C0hhWFm29qCT23xEJj0CCQnEI=;
 b=MkD7L4ISQSMnInZYrVc3oyjKtbtVhj69C3AvOWbkBoSfbPVMxfgMN5Z8TZEXjoLWgmszeHBCX1NcGPzyY7l0bfhmh8U68718CAx8mQWpw8QBN+sPWCGsZUFUZPg6vYxl5fQNqOdtfTH+k6sxV7g87+SWkjFyPwwZnlAiKGAlP9/u1sWj4u9HsYozYM/K58WvKEzpZceoHGfh7LlttMK+q6zFXaGgAf9gN0rJQESoQiZ8be6vVaYPUe0YAg4PCcFSxeoewaQnWYS1KiPvHsCM802P47o+FSL7RGCSU8g1FZLjN+RwUVjZL20yt4p4R31vt9gM+1golJqglEg91Euutg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB5178.namprd11.prod.outlook.com (2603:10b6:806:fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Wed, 16 Oct
 2024 17:42:06 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 17:42:06 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hunter, Adrian" <adrian.hunter@intel.com>, "yuan.yao@linux.intel.com"
	<yuan.yao@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
Thread-Topic: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
Thread-Index: AQHa7QnTM8YJSmcK70mWBvdOl91Ku7Ik046AgFoKj4CACy09gA==
Date: Wed, 16 Oct 2024 17:42:05 +0000
Message-ID: <1be47d7f9d4b812c110572d8b413ecdbb537ceb7.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-19-rick.p.edgecombe@intel.com>
	 <20240813080009.zowu3woyffwlyazu@yy-desk-7060>
	 <1a200cd3-ad73-4a53-bc48-661f7d022ac0@intel.com>
In-Reply-To: <1a200cd3-ad73-4a53-bc48-661f7d022ac0@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB5178:EE_
x-ms-office365-filtering-correlation-id: 5fc682a5-814a-4f8a-f5d9-08dcee09da09
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YmNoNlh5M210V3dOeGV1ZWZuNE82OFo0Y3BKM3h1amtXTUlyMkhhRFg2MXRU?=
 =?utf-8?B?cUtReUUxRUNpREpYQ0phclgvR3BGMXNRVFlnb3dTenc5YW1xTEdua1hUd1Nt?=
 =?utf-8?B?MHF3bTRZWVlVS2R5cjM1L21oVDRLKy9TVmYrK2ZRSHlJdUxMWVh4aGdtQ1gx?=
 =?utf-8?B?U0cyRSswcjZRdFhyN3lUTDVHbHpHZkVpZGg4YzdNS2ZNNjBWYmg5WFNiaGJ6?=
 =?utf-8?B?cHZIR1JmOERlWC9pb0w1OXNBdDRMdmhQbFZxSEhzUUMxODMrdGlOMTJ1azFu?=
 =?utf-8?B?bzlXVU5tdG1LRmpNSTE4dVpZTXRleHE1M0F0b2dpOVVOTFdXRHZGZ1hocXR0?=
 =?utf-8?B?aGVvM2dQS3k2aUhJallIN0xUbStrM2hTOUpJVzBWanp5YnVpVmhHQ3N2MWlx?=
 =?utf-8?B?ZFprYUd6aEVscVZhRnJlRWExZUF5SXN4My9MMVIyUnBBbWUyQkdUa0NwUFZP?=
 =?utf-8?B?NlU0VXM1NVpVcVBnL3hGc0Q3S3JlR3FJSEtyOEI2WnNGbFkyOGh2d2c1dzky?=
 =?utf-8?B?RHRVV2o3ZlNXUElROURmMlpsMi92S0RaamdkdVc1M255d01UQ2dvWDlhaEth?=
 =?utf-8?B?QVdhbmIyUHVWQ1N4Smd1YzJGZlp0ZUVvSU1KMS9JanFFWmROMmhROWFya250?=
 =?utf-8?B?M0V0a1VRM3dySGo2QmgweFI1OTBROHZRSGVTcVpscUczYTgrU0Q1Mm5OaFdX?=
 =?utf-8?B?K2NmSlNuYUcxTE9zL1pFNDhOMTFkdkszbzBEOE9hRW53ejV4NXJSbzR2b3Nq?=
 =?utf-8?B?eS8vdk9jOVh6SHVONnNhQ01ydGdWS2ZBN1lWZUVPYzdPYksxWGp2TlhqMkY3?=
 =?utf-8?B?RjluMTVRTm5VMnNOOTNrUXBRVU1SQXJnL2d3RDROVFZYR1pENVdoSGVVWWo2?=
 =?utf-8?B?WTMra0hMN1U4VEhIaHlZWnFrbUoxbG9ycTk0ZmZEOU0rbVhuak9GS1VRWmQ5?=
 =?utf-8?B?cUkzSXdiNElKRFU4U05VUy9sRDVqU2VUcjJtSWxNVDY5Z0VZRWtYbnFsa3Zl?=
 =?utf-8?B?WXZyb0NJWGUzdmtyVGRaY0VyVHlvRVZVdmozc1lCQnZweG80cUMrTUNGU2xY?=
 =?utf-8?B?V3ljU2NMaG15Qi9oMmpJd0xpNWFsQVA1UTFocWFzYjJ3dVA5NXRSeHhkVlZr?=
 =?utf-8?B?YU9CMVppMFk3V0tkb0RIa2FuWGc3bDVTbS85S2Y0Ylo2Y0xnN0FRMWM2bk5L?=
 =?utf-8?B?ZXZ6WXN3eVd0U0ZaYlpTVE4wY2ZzOTFlVXR3VGFkZTVaMmlzbGJId3FUUGtn?=
 =?utf-8?B?SU5qVTJiR01DR1Jza2t4Q25EYS9WSEI3U09TdGppQVM3R1ZhYVF4VGtOLzhG?=
 =?utf-8?B?WjJUNmxnUm5VdEYxbHJpblFXbGJ3K0I3MUJra0RSY1A5ckgrend4QWdLcmQv?=
 =?utf-8?B?TjhsR0RzUGlsTEpTNzQxa25JZnpNY1FlUUJIQnIvZTJ4Y2tsdGh1L1NvZnFo?=
 =?utf-8?B?UzFwK2JoeFZIUkRJcVlIclRRRmhvVUg0bElwalNGd2dqcXR1VVArTU5yUWQv?=
 =?utf-8?B?VmNWWWJVR3pvRm5TdUNLU0xrZjlxdStJdUx1SGhjQ1A2ZkNwOWo1TG5zZ1Ni?=
 =?utf-8?B?Nyt4WVZDeFcrNXBZSisrSlQwTjlCeHNWd1dmOXc0S0p3WWlJcXRyNGxEbXJH?=
 =?utf-8?B?SnZGVkJzdFgrZkh2N0M5MEJ1NWxWSldkOXdMTmo5U0dka3AyYjlZUUpCMnEx?=
 =?utf-8?B?eDdJcjJGTUZUemg0ZWNCTzR6NUdZN2hOR2RLblh0MEhpWHFPWGNkUWFVbytR?=
 =?utf-8?B?cGhCb1FNRkpDb2dvY3gyc2hITDJlZkJvUGE1bXdNQkVLSnFqOXBhcVc3RWVI?=
 =?utf-8?B?c3RSWW9qVVVzV29FWWVrQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZFFEb21IcjNsNkZkaStMc3BjTUtIM1BqMVhXL1lBUmpiSm5XNVVhRXNMeVl2?=
 =?utf-8?B?aTZrRXgyUk1XYlJicC9QRWx2ekZjbGtYTTJvQjczMGkreEw2NVcxNWJhalNq?=
 =?utf-8?B?TFRIT29KTjhwZStwYUI2QWlsRTUzRGtXZzR1aGFlaEtOazJCU2xocVErTmgw?=
 =?utf-8?B?ZWllMVp0YkY3UGF0YmdDdEZaQXNnMnBKNlFOYWhTWnNBMmRsNzFOU1NJN3E0?=
 =?utf-8?B?Ti92UFY1eEJoZFNnU3dnY2x6NFJuVW1EK0x0b0JPU0cwZzdPUG5KSS9vYVZM?=
 =?utf-8?B?VXoxOWhicjBpYjRFbk9kV094clNXWkJGZjczWnFCRG5kdXRaaXpkcEg4Zkdq?=
 =?utf-8?B?cmFvM3RSKzhrbUtsTzNpbCtCdmdDcEhYSVJyQXphTGZwNFo0R1N2Nzhoa3E1?=
 =?utf-8?B?clloZ3VSWlpXalFjc1pidjdXeEhQbG9WMjB5S1I4dTVDV1NWb2JMR05UckFV?=
 =?utf-8?B?NDNnMzEvWS85dFhpRjR0MXAyY1MvOVN0dzRxVnBmUmZpUndPdGNrbTZZK3Zl?=
 =?utf-8?B?WGxsVXpkbFU3YmhWelp4Q3NCMU5KTEtrUGtDYnJOaGFadTIyNnZDUGhKSzVI?=
 =?utf-8?B?b0gvM1RTZ0RtQTNsQzQwT3lreG4rQnF4Z1FrcXBsQ2hkMCtpOWpURWZWaXJn?=
 =?utf-8?B?dFk4U2NJZzF0SVRTQnBWQi83aXVBNVkwL1pSZXhGKzFLL1pxQzkxS0tzR0lV?=
 =?utf-8?B?Q3I4bTgwUzBnSFhDUm9kcFNyMU02UDFMQkx0dTdDSk9MTUZpRVQ3WThoaW92?=
 =?utf-8?B?RktrMGV6VmU3WTBSdjdyeVFOWDdZcEpwYlZHTWJuM1QrUTM5bXAwbW1aN3ha?=
 =?utf-8?B?bVhlMERMMTZWUVRvYTVXb1JGVitIQzROMUJPdTRBeHgzYjZ5ci9YcXAwVkFq?=
 =?utf-8?B?TmpmaTdjYlJSNVFaVWFxY2dFV1VZTVNoZW02ZWRGM1pYdm1pbVhtQTR0TDFw?=
 =?utf-8?B?L3R4c1VyZkxONDk2QWlNakNrZTBNa25ybkdvSCt6cThCRkhJK0hIbEdJZkda?=
 =?utf-8?B?ZTlRYnBZQVRmcGVzYnVmM056S3Bta2VWQTBjaWxjNEJ4MXJoNlBtR2xLUUR3?=
 =?utf-8?B?S3pEdkFUQlpKOHhLaTlFZklhNkNKWS9samlRcGhBVFd6b2tqYXlpZHIraFhh?=
 =?utf-8?B?WWNLL0VnSWh3RDZ0S1VDSXVaZWNpL05TM29XYWZGMFR6b3A4elJxQi9yMWc2?=
 =?utf-8?B?S3RnWmNxTmFpek1pbkhKcFZuejJGVXNBN2hVTEZ1bHJ3TGsvWklpRit1dUlH?=
 =?utf-8?B?dW5LTytMeU42VXJTWXQzMFJvbEhZeTVQYnptWUtPd0h6VTYycmFXZ1I3cVVu?=
 =?utf-8?B?TEJYeWZPWXhlSzRXTHptd01DTnpRU0I0Rkh5dXIwYlprc3ZEMjBHTFJRQlk2?=
 =?utf-8?B?ekU5djlmOFVsd2JoWllORXpBeTZpMkEvazhEK0dYcXBWMFZxSjZYNVgxOGJO?=
 =?utf-8?B?Qy9McDdoemV5bGNGYnVDd09NNk5KOXRvWWlPRmMwdHVtcEJCMHVsa3RJWjln?=
 =?utf-8?B?Mk1LZzRZdzBKcEh3MlNqSEJBYXhOT1JZenVWdVB3bHRFeXFZMll5Zys2NkZY?=
 =?utf-8?B?ODUwMy9EcllweE1MdS9yeDNzTktzc3N5ODFPZkx5RzBzazhhNS9wRU00aHJG?=
 =?utf-8?B?OHZjK3dmSnl0MkhoaEJ5cTFUUTFFcGdSZmgvSk44a1FINk02MUErbFgvZjE0?=
 =?utf-8?B?RE5wc0hyd0l4VVd5d3JZMno0dUxFZTFKN2xmeW9ZemZOc3c2MFZzbnFLOHJM?=
 =?utf-8?B?VDVQME1ia3pPUGlER2I5d1Q1QVc3SW9iNHFiNzcyUW8vSlFkSmpla0g2d0Zi?=
 =?utf-8?B?N2N6RkkxK2txYnVRb01nNVdaS1hIZ0dGSmdibnV2Y05xOTBsK29INGFtUTlF?=
 =?utf-8?B?RHNLeHVIV2d3dUFoRUJqck16OGt2aXJmZGdiRW9PaXhsUklUTWtZYVhndFcx?=
 =?utf-8?B?NDFpT2NZVGdtNW5mMGJNVmVKd05FSjVYcnAwbDQ1YVpINWoxTmx6eGllN0JC?=
 =?utf-8?B?U3BGczdla1BnWEYwM2kwTTJaMVR1Wk16ZUt2NlVIa3lGWFBmV1pNQ29LZlpw?=
 =?utf-8?B?MzdHenlZRlNyWmZxRHBHSzlHSFVvOTZkYWtac3I3aGh1ZVdTUWtnbUhJOVBz?=
 =?utf-8?B?d3NXUGRLMm8wOEdtdG8vRVpXOVdpOXB0SmNBU1oxeHV5Nk00TytHbWZiRE1G?=
 =?utf-8?B?VUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F605C90A97E59B49B5C61DE965DFC2D3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fc682a5-814a-4f8a-f5d9-08dcee09da09
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2024 17:42:05.9725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2isYJ/jwxlGG4i8Hff6hz7LpCOsFhe/Cg+PptIHTSq3dy5ZyOda9SDXEsQmFnuNw+FblyQbGc3JimdiyoNHebw9WuH5YV4KVWH9qOGNwdwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5178
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEwLTA5IGF0IDE4OjAxICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiB0ZGhfdnBfaW5pdF9hcGljaWQoKSBwYXNzZXMgeDJBUElDIElEIHRvIFRESC5WUC5JTklUIHdo
aWNoDQo+IGlzIG9uZSBvZiB0aGUgc3RlcHMgZm9yIHRoZSBURFggTW9kdWxlIHRvIHN1cHBvcnQg
dG9wb2xvZ3kNCj4gaW5mb3JtYXRpb24gZm9yIHRoZSBndWVzdCBpLmUuIENQVUlEIGxlYWYgMHhC
IGFuZCBDUFVJRCBsZWFmIDB4MUYuDQo+IA0KPiBJZiB0aGUgaG9zdCBWTU0gZG9lcyBub3QgcHJv
dmlkZSBDUFVJRCBsZWFmIDB4MUYgdmFsdWVzDQo+IChpLmUuIHRoZSB2YWx1ZXMgYXJlIDApLCB0
aGVuIHRoZSBURFggTW9kdWxlIHdpbGwgdXNlIG5hdGl2ZQ0KPiB2YWx1ZXMgZm9yIGJvdGggQ1BV
SUQgbGVhZiAweDFGIGFuZCBDUFVJRCBsZWFmIDB4Qi4NCj4gDQo+IFRvIGdldCAweDFGLzB4QiB0
aGUgZ3Vlc3QgbXVzdCBhbHNvIG9wdC1pbiBieSBzZXR0aW5nDQo+IFREQ1MuVERfQ1RMUy5FTlVN
X1RPUE9MT0dZIHRvIDEuwqAgQUZBSUNUIGN1cnJlbnRseSBMaW51eA0KPiBkb2VzIG5vdCBkbyB0
aGF0Lg0KPiANCj4gSW4gdGhlIHRkaF92cF9pbml0KCkgY2FzZSwgdG9wb2xvZ3kgaW5mb3JtYXRp
b24gd2lsbCBub3QgYmUNCj4gc3VwcG9ydGVkLg0KPiANCj4gSWYgdG9wb2xvZ3kgaW5mb3JtYXRp
b24gaXMgbm90IHN1cHBvcnRlZCBDUFVJRCBsZWFmIDB4QiBhbmQNCj4gQ1BVSUQgbGVhZiAweDFG
IHdpbGwgI1ZFLCBhbmQgYSBMaW51eCBndWVzdCB3aWxsIHJldHVybiB6ZXJvcy4NCj4gDQo+IFNv
LCB5ZXMsIGl0IHNlZW1zIGxpa2UgdGRoX3ZwX2luaXRfYXBpY2lkKCkgc2hvdWxkIG9ubHkNCj4g
YmUgY2FsbGVkIGlmIHRoZXJlIGlzIG5vbi16ZXJvIENQVUlEIGxlYWYgMHgxRiB2YWx1ZXMgcHJv
dmlkZWQNCj4gYnkgaG9zdCBWTU0uIGUuZy4gYWRkIGEgaGVscGVyIGZ1bmN0aW9uDQo+IA0KPiBi
b29sIHRkeF90ZF9lbnVtX3RvcG9sb2d5KHN0cnVjdCBrdm1fY3B1aWQyICpjcHVpZCkNCj4gew0K
PiAJY29uc3Qgc3RydWN0IHRkeF9zeXNfaW5mb19mZWF0dXJlcyAqbW9kaW5mbyA9ICZ0ZHhfc3lz
aW5mby0+ZmVhdHVyZXM7DQo+IAljb25zdCBzdHJ1Y3Qga3ZtX2NwdWlkX2VudHJ5MiAqZW50cnk7
DQo+IA0KPiAJaWYgKCEobW9kaW5mby0+dGR4X2ZlYXR1cmVzMCAmIE1EX0ZJRUxEX0lEX0ZFQVRV
UkVTMF9UT1BPTE9HWV9FTlVNKSkNCj4gCQlyZXR1cm4gZmFsc2U7DQo+IA0KPiAJZW50cnkgPSBr
dm1fZmluZF9jcHVpZF9lbnRyeTIoY3B1aWQtPmVudHJpZXMsIGNwdWlkLT5uZW50LCAweDFmLCAw
KTsNCj4gCWlmICghZW50cnkpDQo+IAkJcmV0dXJuIGZhbHNlOw0KPiANCj4gCXJldHVybiBlbnRy
eS0+ZWF4IHx8IGVudHJ5LT5lYnggfHwgZW50cnktPmVjeCB8fCBlbnRyeS0+ZWR4Ow0KPiB9DQoN
CktWTSB1c3VhbGx5IGxlYXZlcyBpdCB1cCB0byB1c2Vyc3BhY2UgdG8gbm90IGNyZWF0ZSBub25z
ZW5zaWNhbCBWTXMuIFNvIEkgdGhpbmsNCndlIGNhbiBza2lwIHRoZSBjaGVjayBpbiBLVk0uDQoN
CkluIHRoYXQgY2FzZSwgZG8geW91IHNlZSBhIG5lZWQgZm9yIHRoZSB2YW5pbGxhIHRkaF92cF9p
bml0KCkgU0VBTUNBTEwgd3JhcHBlcj8NCg0KVGhlIFREWCBtb2R1bGUgdmVyc2lvbiB3ZSBuZWVk
IGFscmVhZHkgc3VwcG9ydHMgZW51bV90b3BvbG9neSwgc28gdGhlIGNvZGU6DQoJaWYgKG1vZGlu
Zm8tPnRkeF9mZWF0dXJlczAgJiBNRF9GSUVMRF9JRF9GRUFUVVJFUzBfVE9QT0xPR1lfRU5VTSkN
CgkJZXJyID0gdGRoX3ZwX2luaXRfYXBpY2lkKHRkeCwgdmNwdV9yY3gsIHZjcHUtPnZjcHVfaWQp
Ow0KCWVsc2UNCgkJZXJyID0gdGRoX3ZwX2luaXQodGR4LCB2Y3B1X3JjeCk7DQoNClRoZSB0ZGhf
dnBfaW5pdCgpIGJyYW5jaCBzaG91bGRuJ3QgYmUgaGl0Lg0K

