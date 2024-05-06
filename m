Return-Path: <kvm+bounces-16719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DDFA8BCCE5
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 13:34:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEB881F225C4
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 11:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E87F143861;
	Mon,  6 May 2024 11:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WjDk54IX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6608D1420C6;
	Mon,  6 May 2024 11:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714995267; cv=fail; b=P/is1Kaql32tpM1zBx1JXXsj2xfuzh5P+MwXC6aaUyQnM5SYFe+Xxa3YeJCHlj1mnU1EZ4NDkqeccp2qoXsNrx2vRER0B6plgS8y5BzzLcdZA/irK2thq1C09sjIMzp/u1QdJVm7jBmUBMxuPBB6Mv+tXUeUnyg7QHbQAVVBisM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714995267; c=relaxed/simple;
	bh=o8jIRTh1BcI1Fzporej5aEgTA3yp/Mj/d+R5xQJcjv4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qoeUfKOXcM0U1LhnvrivrXINn84wxIsGlWlpa1T1iBGQzvOQiJzJplT0eZOtKslSBGK6MHzkH3gD4jGIJ12ZmYSaqXSEAsRHNaBTSOQoJK2JEb93drIo3VNw6KKPQ3DnPi51V6FLfN+wbfpQDHvAAnNwA8lN+C4GI/QkFbeMGAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WjDk54IX; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714995265; x=1746531265;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=o8jIRTh1BcI1Fzporej5aEgTA3yp/Mj/d+R5xQJcjv4=;
  b=WjDk54IXrzXko0jxgH0zLHi/a6deaZcuXz5qVscAKarNXgSlmZM5Erg6
   nQe/W9ECE+IgejymnatMO2Tiu3UtMzgyR5NznzYbD137eiU78vLEyK1sP
   aJbEd3pGtJp1vwLWI3ZsjgbKia62CJ5hN93OJNGfjpt22mPrahWIuHGzq
   fuVALHCN+TKkgJnOl6mBi7OJ4503cIg3ACYDsMrUeMpavrL16vHO+I9cO
   HKhQpKQ6AqeE4Z4g9KKDklitflIGn6OF/V+jDKzwuSzvGPILZ/dCEa80O
   nQifGlrlCO0ysUTDtP4sfLpmaLWXDi77ZybfBkQ0f5fxlnGldWL7YOWFy
   g==;
X-CSE-ConnectionGUID: Hd/NE186SSuqDiG9SLbHkg==
X-CSE-MsgGUID: 2TuEV9cUSS22yNOaHnbz3Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="33243639"
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="33243639"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 04:34:24 -0700
X-CSE-ConnectionGUID: fmMj9uoHQUC0naNbypnB1w==
X-CSE-MsgGUID: imfI7FmZQUSQcAFdNB+XnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="65589164"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 04:34:24 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 04:34:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 04:34:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 04:34:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 04:34:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VuY7YaaxBbxUjK/86V3kzKj/PlzALW8ICiTzXSHn7hkL5Mb3+4g1983GphAvsbLUWC+kn6DQ0v4xWuiz2lmk5QK+Zd1Aqyp91ySy0gucSJkdnHRNck7za9e6iTfVt//wMmz+rp3hTZo8/PpYXVuy1W4jKn7TnCb79OXPXBbQQYd27riB3VA4MVUSnVagFbrdynP4KKNfl0V3zzzD4R++gKUVQiDfD1FRKwzHZTjaE34r5kc+oDWkddLyxmZwzjCn/5NUypzdX1oi5i7YnQt0fqM8ZiihCho1cNk0aBr2+re4r+v+c4pu/qT6B0AqZE+zF4PTkQntQkEbjTI4V1MGXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o8jIRTh1BcI1Fzporej5aEgTA3yp/Mj/d+R5xQJcjv4=;
 b=C5kgDJ1RB8dl57FYdDak2OAcbVDtd11p74k2Va62V+g7TV0qPvRBF8tN4Jjon3ojJzNxpJp2kCIM67z8miz2sho5R0RELTjg4GWFE5EhErhP54ejniELjvszzklOR8C+NsPZF6gtBIVmXxdz1EE9Hz36ed9rNw+118Vv7LerGNT5hgwI7+v6cgJkPFNO3/qs52FtM6ooYIA6v9EIzgrZKrqNdBHa0pVbBYng6zM1o4c7sfMhv3ie3SO7e3W6YxNR7QCbBkVjhQHpFahedI2SpnereCYaARwwmC9ssS/E9mPJ6ZbrE2SvvUB2B5FVA9wPHs9xCmlN4Hz/g5T76KeCxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4822.namprd11.prod.outlook.com (2603:10b6:510:39::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Mon, 6 May
 2024 11:34:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 11:34:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/5] x86/virt/tdx: Rename _offset to _member for
 TD_SYSINFO_MAP() macro
Thread-Topic: [PATCH 1/5] x86/virt/tdx: Rename _offset to _member for
 TD_SYSINFO_MAP() macro
Thread-Index: AQHaa8I/aBTTis4lx0isSiFU2GupIrGFBFgAgAV2zAA=
Date: Mon, 6 May 2024 11:34:21 +0000
Message-ID: <9aac71bcec5956177c288e4d0d0e6427c0986877.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <a55e86430c81274af86d2d1c23cdce2f53fef7d6.1709288433.git.kai.huang@intel.com>
	 <ba0e8645c0a6878efbb6224bfdd8ab2cdc813542.camel@intel.com>
In-Reply-To: <ba0e8645c0a6878efbb6224bfdd8ab2cdc813542.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4822:EE_
x-ms-office365-filtering-correlation-id: 60f915d8-b5b6-46e7-4eee-08dc6dc07963
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?TnhpSjdZY0l0VWE5VERrK29LU3FLS1AyQVZmNm51MGV6K0JOYnpnNlhiVy9k?=
 =?utf-8?B?Y0dxYXBLNDZFaE1LQjNkcW1ZUzA1WGpPdmxJRnMvQzNadE4wTFNjYkpBLzd6?=
 =?utf-8?B?RXJOZDVVRHlpbjB5NEQxZStjMng3ZWRoZ0N3RlprdVVRWWhrdW1rL0NNUnNt?=
 =?utf-8?B?K0p1ZjZqcnlWRnE1SHlRaW5Dd2pjUFM3aERIZWtPQjZsVVV1SFNFelYyNVJN?=
 =?utf-8?B?VTJZaThuaVJtV0crR216SUR6N09aYUdkZTBHNTM3SnpuUHpFL2tmT2dHTzRJ?=
 =?utf-8?B?TUpOTXEvNU9IbTE1Yk4xSE9pa0FrTTIyUUVyTjU1anFINUg2TWRVZUdQYzdM?=
 =?utf-8?B?WitTV1M5U0dQU0E3N1FoZS91K0ZFNkpneVpKcWR5bHZZUlgwREM5cHltSXF3?=
 =?utf-8?B?NGx3K1lPdjV1T0ZqdWExb3dtc2REalJjaFkydUJOU0RrZXR6U05Wdk15M1JC?=
 =?utf-8?B?M3VTdEQ1WmhaWGJnQk9MTEl5R0Z1Tjc4Tmg4L1plaEJoaUVVa01RS1VtVWpi?=
 =?utf-8?B?bHh2eDZielBVRGxoc3FhZDFENGU0OG9yTEVRcFJ6ZE1IRk9HQ2ZVUUJXVjMw?=
 =?utf-8?B?VUpxNWNJLzdjdXNEZGNoS1NKQmVOZUx1MnJ0dlVscjlrK2E3clhxNGI3UGlC?=
 =?utf-8?B?aEs3cTcvd2JRMzFkeGx2Z2k5WXU5b09jTytTUzgzZmhFOVNJWXF2MVZBQmwv?=
 =?utf-8?B?VVlhVk1GVEttSFdXNUNxRE0xVTJKVm9sbWJteXBGNFk2Mm8zejNocDBzM0xo?=
 =?utf-8?B?cFZKQTF5cG1LRUNDZmlyYjUzd00wb3FvYXkzeXhUU2VnSjVHOXNVRzNtSlg2?=
 =?utf-8?B?WGdHcXZlZy9ScTFyTHRYdHJSWm5tSGMrNWk5QTdCL29FSTlmZ2trek5xdnBS?=
 =?utf-8?B?VWg4MThvdTU0M0lOQTlLUmN0cGhrNmNxS2pVRGFFZlRMVytEa2RITmpTUXp6?=
 =?utf-8?B?UG5BV2VqaXpBbVVIWU9iKzlkSTRpc3F2OEw4TGhmc2NEN3REdUFTL0dRczVu?=
 =?utf-8?B?TzQzU1hYcDBQSTFkSWh3S0lGNEorejBCL3BRS3EwM2tGQ3g1UVJSZ1VrazZT?=
 =?utf-8?B?RFJ2cGFMTWpNZ1ljNjNvWDdxZENKODUyM3VSY1hINlVjWk1YUFYxclZLeDI1?=
 =?utf-8?B?end3OHV4UkVQbGVSTEV1VHl2c3FQUllma0RoTlQwdWhiSUtrbVNCMTRROVpK?=
 =?utf-8?B?N0w5RGU5dWVRMTlIM2dpUUVjU1A3Q0Z3REFnVUVGaEVyOHBoTC9Xd3RRRUNI?=
 =?utf-8?B?MFJIQmdWa3R1a3M4NC9sZUZhUlNXY0xJZWg1bDRlanp0MGE0UXZ3ajZlNXV5?=
 =?utf-8?B?QXJ3bk5yTWtzZmhNVHpTY0Q1SXBsYlEzT1h3Q3dFOTYxaDdGTzNXRWx5SHhC?=
 =?utf-8?B?NTkwM2QyeDRmZ01ZejhVTGJVTzdMdjA1UTNnNS9PZHAwVDVFc1hSMjRBYUVw?=
 =?utf-8?B?bHR5QnNYTExreElCV2JKRnZNVWVrcWhleVpnaG51NmJuSjN0L0YxOHJuK1M1?=
 =?utf-8?B?M3FDZlBheDFjTGliQ1UraXhyUTdpYW1RelNNTm5KajZoWU9RMGlFWi8xL2NN?=
 =?utf-8?B?dm9jOVdSWW1WZWR6SE9UWG9NNXJjaW9ydXpoTnlIa2wyN2hZSmdPYUNCUGhW?=
 =?utf-8?B?R3Bta2pTZGdMVVdoRDZGd0FWWnIvcGdaOEQ1RmZzNks4Qmt3WEM1N0xwWFdO?=
 =?utf-8?B?QkRqMy8wY1F1ZEJoU0NyTWJpZnI4VThwK2xqTThBS1Q2K2w3WUtsOWJqZnFX?=
 =?utf-8?Q?3bK8fpTfEhpHje2Q0pGNFLnAMb/Ae5lkGVZBFV4?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2QxVDRNTVdzL1F5SUwxV2dZNkJOMmpHa3oxNHVnRG5OdktIRUtMODd2YjF5?=
 =?utf-8?B?bHdOOVRwY04rSUovTnp6TWFIcll0K3NmVmp3UC9lTFNreCtuNUdiU1NnSFVI?=
 =?utf-8?B?ampCTVhkdUF6RFpWQ1R1UnpYQXBBV1VBVXgyZ1QydC9pMFdLNFpMcEdaLzB6?=
 =?utf-8?B?TEhBMWJUNHM2Y09nUmdDM0FWUWVBM3U3Qjd4NGdpaU1rcHpWd2E2L2wya014?=
 =?utf-8?B?SW5MNUVhUlRxeG8zRldqSUNuZk5LVi9MOHNXbUZUSnp5SVU1SmFDMGlFM3ZV?=
 =?utf-8?B?cEhQcmxXMjJOOU5kNHJzMXdrOXkrSHBEQ052TW9HQytsOHY0alRPUnFtZUZ1?=
 =?utf-8?B?RnJsK0h0cU13RFFkNTlvUERIdkZIY0gwV2dJV3h5Tks3aURnTHd1eXBsQzVY?=
 =?utf-8?B?cEpGZm9Bd3c2QndLQnJLR1VxR1hzc21sVGIxSXViQVVvQ25mR0RiRWhRR2JX?=
 =?utf-8?B?OHFESmxBallmbkVrUmhKRDZBVWpRa2ZsSi9QSWg1SEtwLzgyTXM0TUMybmhH?=
 =?utf-8?B?YWtMellsbDRCaVJPWlA0bWVFRlFuQ3FGT2h2d1JMNDZHNHZmeTNHbkxTUmg5?=
 =?utf-8?B?MFBlV3R6eEJyeDl6aTAxR0FkK1JnenIzSzlQQS9iWUpvcE9lQVpxSDB2aTRI?=
 =?utf-8?B?dWFESnY0QU5zQWRsWTZOVkxEVEFlL2k3NEJycjMrVGEzREVSa2M2WWREeHNG?=
 =?utf-8?B?bXJOTnJWcE9WWk00TEh1aVZ6MEN6a2tvZGhmNmJhWnJYYkI4VTdleVdMZGZi?=
 =?utf-8?B?YkFWNkhkTm9QU05WY0EyVDZIM3pVQTZVRTdQVHFtaTZaM3JjNWhuUlZBYzBv?=
 =?utf-8?B?RGZiaS9LeEpPaUtTNmN3UFVIY21kMEFHUE84bEgzb1NjNFpZUlEyYkJ4NDNN?=
 =?utf-8?B?YVlweTh2dXhJQzRtRjZTZ0VFMTdkajloNldyVzFha1BRSDB2OW1XejhXcTEv?=
 =?utf-8?B?RFR0aERBcXhud0VZL0Y4Qi9MenNQOElxY1NUOVExQWdKZGw2dzFaUXZYYm9l?=
 =?utf-8?B?WmQ1dEkyVEhuMlVUMkFuWldzbkFQWUVFZ01mcW5xYW5wcmYxN3hYUTJYUCtK?=
 =?utf-8?B?WFdLa0huM0p1UXUzbXBjL1NuNTBocVN3dUc3TlZmbHMwT05Fd05WdXdWbTNM?=
 =?utf-8?B?blhaaEN1WG5uMmMwSVBwMkdGNVA2b0xrUnlUclV4NytDYmdmTjBkeWJvN3Qy?=
 =?utf-8?B?Tm5FSGdIQVRtOThubmdkOE9OM1p6T2Fxc2ttUTZHTUd0UVhXWXJndjBZVDZJ?=
 =?utf-8?B?Uzh3Y2dVUVFzQVc3cDFUa3gwWnJDRkk5V0gxd3BMS05HcGFNS3hZN0t4eDlM?=
 =?utf-8?B?WDRmQW5FZHNKY1p0cm54UnBlNjBBOGFkTGQ3QlFnUFkvOEtocGV1clVoaytO?=
 =?utf-8?B?UDhhTDVVYUVzZDFvK2Q3YWhTQnFOREZmOG5URVRXaFU0bENkU2pGZXNVaFV3?=
 =?utf-8?B?VG5nTERVN1RJa2lzMmtzT3cwc2d0OSs3TmdlY1dxSGxEZ3ZnOERDMnFOczRm?=
 =?utf-8?B?YzI1djVoU1BQYy94V08zZndrQUx1NjNXTVRSRUdHM1BORkZleTFDTGNMcTVo?=
 =?utf-8?B?M2JHdzBHMVlWcjRpd29KUW40cEFmeXdlT2NyZlVZL1ZVZ0pmblQ0aStoZHly?=
 =?utf-8?B?bEk5Zkw0UXNGYzhVQ3lsSnloSkttaUxteEtYa0ZvK1gvaWNxc3hhWDEydXVN?=
 =?utf-8?B?N0RMVjltbVNSWG1mU1pNaU9mVW5ZRHkxWHdvL050L2s4MmNyVWFiK05YSHZP?=
 =?utf-8?B?VWRFSkRqMTdrNUllNVdsTSs3TVRQaTlybFpZaU4vUXowQzZFM3RBbU1OQmhn?=
 =?utf-8?B?a2puMEtVRWkvMVJJVGJzaWVsN2ErYmNCR2c3elhocnJzVFBtMWRuQmVZK2pG?=
 =?utf-8?B?VlF5THgycWdkOU9IdTl2dlBtVzdTSU5kREdHb1MweWdsQytTOGNIcEVJTUdz?=
 =?utf-8?B?QVNpcXRUaGgxMVUybFNzdWlJTVY3ZW9wQ3pPZVFGK2toREpFcmhwOURiSStv?=
 =?utf-8?B?VDhIUlZOcEZGUG5yMlowbEkwRkNwRnI5M3FJVy92d2ZkdjRPUlFDWjRsbEk0?=
 =?utf-8?B?ejhrN3JoRkQ3RUYvVXBncWIrcnJReG9MakZRaGMyRzkzaGFrQ1hwUnFxQkpH?=
 =?utf-8?Q?eqwhYe8xMf/LLVohPSz6Pzl7A?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D2FD4CB741DB4D4A9F9AFD8F8E62F076@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f915d8-b5b6-46e7-4eee-08dc6dc07963
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2024 11:34:21.7392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m53IZMbFkgOfoSj0TKRi29HvlWQCdkFJIe8C3QZ5eeXc1VHcS2um/w7SK5eXmXKsc5IAhAZPvCvlyf+eEvKwtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4822
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTAzIGF0IDAwOjA3ICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gU2F0LCAyMDI0LTAzLTAyIGF0IDAwOjIwICsxMzAwLCBLYWkgSHVhbmcgd3JvdGU6
DQo+ID4gVERfU1lTSU5GT19NQVAoKSBtYWNybyBhY3R1YWxseSB0YWtlcyB0aGUgbWVtYmVyIG9m
IHRoZSAnc3RydWN0DQo+ID4gdGR4X3RkbXJfc3lzaW5mbycgYXMgdGhlIHNlY29uZCBhcmd1bWVu
dCBhbmQgdXNlcyB0aGUgb2Zmc2V0b2YoKSB0bw0KPiA+IGNhbGN1bGF0ZSB0aGUgb2Zmc2V0IGZv
ciB0aGF0IG1lbWJlci4NCj4gPiANCj4gPiBSZW5hbWUgdGhlIG1hY3JvIGFyZ3VtZW50IF9vZmZz
ZXQgdG8gX21lbWJlciB0byByZWZsZWN0IHRoaXMuDQo+IA0KPiBUaGUgS1ZNIHBhdGNoZXMgd2ls
bCB3YW50IHRvIHVzZSB0aGlzIG1hY3JvLiBUaGUgZmFjdCB0aGF0IGl0IGlzIG1pc25hbWVkIHdp
bGwNCj4gcGVyY29sYXRlIGludG8gdGhlIEtWTSBjb2RlIGlmIGl0IGlzIG5vdCB1cGRhdGVkIGJl
Zm9yZSBpdCBnZXRzIHdpZGVyIGNhbGxlcnMuDQo+IChUaGlzIGlzIGEgcmVhc29uIHdoeSB0aGlz
IGlzIGdvb2QgY2hhbmdlIGZyb20gS1ZNJ3MgcGVyc3BlY3RpdmUpLg0KPiANCj4gU2VlIHRoZSBL
Vk0gY29kZSBiZWxvdzoNCj4gDQo+ICNkZWZpbmUgVERYX0lORk9fTUFQKF9maWVsZF9pZCwgX21l
bWJlcikJCVwNCj4gCVREX1NZU0lORk9fTUFQKF9maWVsZF9pZCwgc3RydWN0IHN0LCBfbWVtYmVy
KQ0KPiANCj4gCXN0cnVjdCB0ZHhfbWV0YWRhdGFfZmllbGRfbWFwcGluZyBzdF9maWVsZHNbXSA9
IHsNCj4gCQlURFhfSU5GT19NQVAoTlVNX0NQVUlEX0NPTkZJRywgbnVtX2NwdWlkX2NvbmZpZyks
DQo+IAkJVERYX0lORk9fTUFQKFREQ1NfQkFTRV9TSVpFLCB0ZGNzX2Jhc2Vfc2l6ZSksDQo+IAkJ
VERYX0lORk9fTUFQKFREVlBTX0JBU0VfU0laRSwgdGR2cHNfYmFzZV9zaXplKSwNCj4gCX07DQo+
ICN1bmRlZiBURFhfSU5GT19NQVANCj4gDQo+ICNkZWZpbmUgVERYX0lORk9fTUFQKF9maWVsZF9p
ZCwgX21lbWJlcikJCQlcDQo+IAlURF9TWVNJTkZPX01BUChfZmllbGRfaWQsIHN0cnVjdCB0ZHhf
aW5mbywgX21lbWJlcikNCj4gDQo+IAlzdHJ1Y3QgdGR4X21ldGFkYXRhX2ZpZWxkX21hcHBpbmcg
ZmllbGRzW10gPSB7DQo+IAkJVERYX0lORk9fTUFQKEZFQVRVUkVTMCwgZmVhdHVyZXMwKSwNCj4g
CQlURFhfSU5GT19NQVAoQVRUUlNfRklYRUQwLCBhdHRyaWJ1dGVzX2ZpeGVkMCksDQo+IAkJVERY
X0lORk9fTUFQKEFUVFJTX0ZJWEVEMSwgYXR0cmlidXRlc19maXhlZDEpLA0KPiAJCVREWF9JTkZP
X01BUChYRkFNX0ZJWEVEMCwgeGZhbV9maXhlZDApLA0KPiAJCVREWF9JTkZPX01BUChYRkFNX0ZJ
WEVEMSwgeGZhbV9maXhlZDEpLA0KPiAJfTsNCj4gI3VuZGVmIFREWF9JTkZPX01BUA0KDQpJIHdh
cyB0aGlua2luZyBob3cgdG8gcmVzcG9uZC4gIEkgZ3Vlc3MgeW91ciBwb2ludCBpcyB3ZSBjYW4g
YWxzbyBtZW50aW9uDQpLVk0gd2lsbCBuZWVkIHRvIHVzZSB0aGlzIHRvbyBzbyBpdCdzIGJldHRl
ciB0byBjaGFuZ2UgaXQgYmVmb3JlIGl0IGdldHMNCndpZGVyIGNhbGxlcnMuICBCdXQgSSBkb24n
dCB0aGluayBpdCBpcyBuZWVkZWQgYmVjYXVzZSBpZiBpdCBpcyBtaXNuYW1lZA0Kbm93IHRoZW4g
d2UgYWxyZWFkeSBoYXZlIGEganVzdGlmaWNhdGlvbiB0byBkbyBpdC4NCg0KQW5kIHRlY2huaWNh
bGx5LCBJIGRvbid0IHRoaW5rIHRoZSBhcmd1bWVudCBuYW1lIHVzZWQgaW4gS1ZNIGFjdHVhbGx5
IGhhcw0KYW55dGhpbmcgdG8gZG8gd2l0aCB0aGUgYXJndW1lbnQgbmFtZSB1c2VkIGluIHRoZSBU
RF9TWVNJTkZPX01BUCgpIG1hY3JvDQpkZWZpbml0aW9uIGhlcmUuICBXaGF0IHJlYWxseSBtYXR0
ZXJzIGlzIHdoZW4gdGhleSBnZXQgdXNlZCwgd2UgbmVlZCB0bw0KcGFzcyB0aGUgInJlYWwgc3Ry
dWN0IG1lbWJlciI6IA0KDQoJc3RydWN0IHdoYXRldmVyIHsNCgkJdTY0IGE7DQoJCXUxNiBiOw0K
CX07DQoNCgkjZGVmaW5lIFREWF9JTkZPX01BUF9XSEFURVZFUihfZmllbGRfaWQsIF94eXopCVwN
CgkJVERfU1lTSU5GT19NQVAoX2ZpZWxkX2lkLCBzdHJ1Y3Qgd2hhdGV2ZXIsIF94eXopDQoNCglj
b25zdCBzdHJ1Y3QgdGR4X21ldGFkYXRhX2ZpZWxkX21hcHBpbmcgZmllbGRzW10gPSB7DQoJCVRE
WF9JTkZPX01BUF9XSEFURVZFUihfRklFTERfQSwgYSksDQoJCVREWF9JTkZPX01BUF9XSEFURVZF
UihfRklFTERfQiwgYiksDQoJfTsNCg0KTm8/DQo=

