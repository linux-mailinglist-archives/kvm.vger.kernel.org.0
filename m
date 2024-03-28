Return-Path: <kvm+bounces-13028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B9E489066E
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 17:58:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 855DFB2222C
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 16:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 243783BBF4;
	Thu, 28 Mar 2024 16:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kpZVyPIi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489013B78D;
	Thu, 28 Mar 2024 16:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711645088; cv=fail; b=ITaiRD0nUBu8zsaWIIhYf/dNdcHDnDihl1zOxcfraNzvW3wRbHrq03zeWjb0YEoYiR/Q0NmHjoLeJPfolv6AKwOz7DYC663U9QQDRntErwgFIKrE9RmPtfYyo33J8yy8z3ghe6fq/yqf1F/3Rv8fJPv8voX7CuZxNWSOxqVb77A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711645088; c=relaxed/simple;
	bh=75eLMFBQRj3rfTCqTiaKRaUAHsDKBbnBpw3MaxHTIfs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UraiDikW3F1iZkb1qMvTmu2nuytc6nnODg1PhsA8B4HeueCuhcF7gQ9BCZzFseV5XphW6l1h65kJ75QqoAEE0GigJM02nyr6LsWpcMOsLWyCLTIjInuYEMFsa4lBZnTQUHFkFqhQ07z34eB03tVu2rTIu2yMRxJiFkF1kGzPQD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kpZVyPIi; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711645087; x=1743181087;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=75eLMFBQRj3rfTCqTiaKRaUAHsDKBbnBpw3MaxHTIfs=;
  b=kpZVyPIifXVi4sZD/imxlggubHcpQr8wz405jYHxcN3vfl3UMGacIJJb
   V88lNOUn9P3t5DKYHwk3wYyLmkAHoNonmx0UvJjNJqamWEFDu25I8vmAY
   MGYNULJc7/4nLAmFk4KC8PIDrBD7infOai00FE27qg8z96dHtcoYOYGSr
   l6SyvkmUmDSc6TjMPo5hvh264kIPgi6028S4T6ne1wgo3wcTu6/e5rAoY
   zDDeQYs66BB6q4zfBO7htCh/1oKKiPr9iDRV+v1lu0wtdszP+hzUMIj+z
   VWo1+o1VCNa2OQZ0zplL6B+hlC5ZVzJWTVnUfSFx9bLtW+LhiBizQBwoy
   w==;
X-CSE-ConnectionGUID: sV79XlpqR9+W665STQbuuA==
X-CSE-MsgGUID: GE1bce1vS0iZFSJW2vYPpw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="7415522"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="7415522"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:58:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="39859788"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 09:58:04 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 09:58:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 09:58:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 09:58:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 09:58:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jADA8DgIQmeeTgL5pSJEC6xG+e+CSrAxop3Pxy7oFVDPOvLc3DrZmMMnu6qkpuREA3gEIeFd/sIJ4qRAFeaAPq7VgXW5E+UUJRQa2B/sLv1sBuug6wNYW4Z3vhoVkIt6dBlyXiTR9aP5Ub6LCFNQ+6zD8bm+PWmPJ4CGLvBXc/bkJSvt9jNlvSeH/ZEYkN+fKGV95xdml/6WL4mwq7o95FVqSnjQpco5wbrEcHZSpUFkR9N50B8aRY/6XifUsWaEqEFiJbHXMkQCUZaDEyiacPQzbf3WFJ6uUPO8TVbvBSls4qQqqEXMcLUOOTtHt9jDloPa8+lQYHtn8tQqiU+ZUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75eLMFBQRj3rfTCqTiaKRaUAHsDKBbnBpw3MaxHTIfs=;
 b=Aznd+03QkSqT/z4GrCD86J4qVCkzwpjEyepIQdUNCsSmEXxhopuZ66fSqJkQ8BvBST6R0q5fvE7aEe0YFZnOS5x2pGob0XR2xGjkznQ8EAcqVLyb6nqQh7OOok/eJFNoGZpGfebKoq0ED8SV+Un7r4LiDwN+zoIQDoGqTmwh9QdgcdUPewJdsTJkMt5C+aOsJ9GuC52ZxuutO3HLZIkLvU6pN5Xgah+YycxGxwr+X6ilofjPlRaNKQYdPeNt2anUtC9Fo/9+cB5RhfMJMgh1bavF87FLz1ABeu7qImbAFFzOUu01bA7aBXby2pTCt+KIHyRgbAutv6ce6fhxviGXhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB7520.namprd11.prod.outlook.com (2603:10b6:a03:4c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Thu, 28 Mar
 2024 16:57:51 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Thu, 28 Mar 2024
 16:57:51 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHadnqpCkdQcpy1UEaf8e2/el3pBrE+L/IAgAGVVQCAABCvgIABmDGAgAFrqACAABw5gIAF68uAgAAN3oCAACgcAIAADqEAgAAC4oCAAAP3AIAAMXQAgAAC04CAAI7TAIAAbmyAgACYeICAAPZDAIAAbS+AgAAKzwCAAAOVgIAAAigAgAAGu4CAABpigIAACgOAgABu8gCAADNugIAABJ+AgAAS8gCAACTYAA==
Date: Thu, 28 Mar 2024 16:57:51 +0000
Message-ID: <9039a5f33b150de3daab2af9976bfe09b7bed592.camel@intel.com>
References: <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
	 <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
	 <e0ac83c57da3c853ffc752636a4a50fe7b490884.camel@intel.com>
	 <5f07dd6c-b06a-49ed-ab16-24797c9f1bf7@intel.com>
	 <d7a0ed833909551c24bf1c2c52b8955d75359249.camel@intel.com>
	 <20ef977a-75e5-4bbc-9acf-fa1250132138@intel.com>
	 <783d85acd13fedafc6032a82f202eb74dc2bd214.camel@intel.com>
	 <f499ee87-0ce3-403e-bad6-24f82933903a@intel.com>
	 <ZgVDvCePGwKWv0wd@chao-email>
	 <234c9998-c314-44bb-ad96-6af2cece7465@intel.com>
	 <ZgVywaHkKVNNfuQ8@chao-email>
	 <79adf996-48d6-41b0-8327-f3258d74bb7b@intel.com>
In-Reply-To: <79adf996-48d6-41b0-8327-f3258d74bb7b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB7520:EE_
x-ms-office365-filtering-correlation-id: ae42a69f-5845-412d-4d88-08dc4f48348f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ymzW7lOfhtCvFfvt73T//UG30ZIK/286uFDskhsGmMsG5nZ/S/BLPXf4gEglObNdrWzonDE1zg2i7g5xsemQrm3+fKsdjtCpdAO4RluP+L97sLfD5E3OmGyG0Mnmm7lvAQsa1QtL5/HMASIt+7szWZePkI7guC6OPRlv0sCP9GCb1hy7X4yYUQ1Xf0esDtxDTtI/jK3wKeDG8hsTChNPfBts+DXRl16GMvIh0Kyd+ZjKNU+FzvW4ddqukxJsYoy3Dbu3ytYhEM82qqPYjdS3fvlnHDFd04aIhyKzpAVDW5hydSZWOaGC20HXlqZ/2E6Dq+JXPfCneHZB6IchtjdCOf44MMnEa2M3AS3AXvfRkXmQP1GAv4yde+0hojpxq5UvvoMSG/n1LoILFgdjDfVp+9h1q3R5phFY5KCIU96bGIoTM/PO1wGEWKE5fLb4KyaJI5PwtfO8l/4rE2K+xwWCgOGMD7jf9hdjDhyN7lkzwTsreABwgSc4BREdnSkZ0bjteYq7Kxby4TwiMHD35Gd6y4PgzHQXOUSlT5chK0LtG4t/OYdXuMSDgLb+FFmkvP0PF6mPeVXQEId6rUVsbw8dFfVmsRiNXCO053P69spTmKEXdAZ36awFja6sieaJLTgjq2tLZjyo4DJ7Wvu7QU3P+HO01jkl5YNOz9ut3v1kUYGo0aG70lcMPjcXP/9SHlTzIxwZ/EqZlx9+m+Djgz023tXZ3pv79+eCni7/PtHhQTM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXZkM2RDa0x4ZHRlTWZtUmw2Tjc3RFJ5TnUzME1NTGludGxCMFhrb1NMdmxl?=
 =?utf-8?B?a2tFSjg4UDRNZURTazdIY0JlbTlGZXNkUlQ2OEh1R0gxV1FaZEpROXJxYmxq?=
 =?utf-8?B?RTBjakdqNk5iRG5uNFdoRVRLeGRuS0h3SXZFSTRJUEh0WHZnVEJZeHVGblps?=
 =?utf-8?B?NmEvZU9Xc1JuVE1oR0ErbEFJSmd5a2VXMEFNcGZ0TWlTT090ZS9JVUdpdkJF?=
 =?utf-8?B?MWJqUXNWdE4xbTlRMDZBSW50d1ROV3l6a244d2dOVEprSHFBRUxWd1p4Q2Fz?=
 =?utf-8?B?UDBiUVFGby92ZVpyc0pDRFhZaHFYQVdZZlNETmUzdy96QXZ3eXI1UjhvWSty?=
 =?utf-8?B?UDlpaEhCUTZSWlNJeUJzNjh2N2N3Um9WTUpIZU9wRVdkd29PRFJ2enpWOVBW?=
 =?utf-8?B?M3ZFT0FiK0RPU3Q5VEtCbTdOd1pkMnoyMy9qWGZxVVFGME1MckhDODFCTE52?=
 =?utf-8?B?b0hlUExwZEI1NXQrY1paMlBhV2VMMDJTeXNIT3FadkMvSU5IZXQ5aGEvNmJW?=
 =?utf-8?B?NkJZbUQ1aTBRRjhnSEV2UlhuS2NvQVFqcmNVYUl1SkRJN3FqOEM0Z3NKQ3Vr?=
 =?utf-8?B?SVR5b21pbjh2NjF5cGppNUttSDdBM0VNYVZUdzBKZjlheXRSSEk3Mk41Zmxi?=
 =?utf-8?B?YXBtUVVHTFo3UmN4U3dzcExCRVpjL2RmNjNsdUZEYW5INEhwc01ZN2xWd2ph?=
 =?utf-8?B?L3NYWERYNDBoMzJ5MEduczkxZW1aM1JhdDVzaURsMVZDcVRnSWduY0d6SmV4?=
 =?utf-8?B?NFozWFlGbUNDNTNlWm55dzdPWXA1cjFLNU05LzZ2dU5QY2Y2UWdhTzlnYlhK?=
 =?utf-8?B?Nlk5QjhWOTBnRVNyTXBidmpIWEVJaEswL1pWUG1obXNaRDFTajExZTdHZnJE?=
 =?utf-8?B?cG4wZkJXeFhQMVZCM3ZyUHA2UXQrVjBtVGdNL25zSzFJYytoRFk4MU43b3Fn?=
 =?utf-8?B?djhZS2EwMXNJV1FaN00rMXZ0ZW01dG9uOWM0UWxNYmdPeFIwb2JDdGJQTWIr?=
 =?utf-8?B?ODhTdUViVG9VamNYRC81T09EbjhxR0lQV0c0MGJMSjdFV1BmNVhpbnJ5Q1Ir?=
 =?utf-8?B?cWFWRldOMDNWcFMvaThVTmdDU3o3ZGNIM3NSWGFJd2pJWGRzNU5tRE9zc2NN?=
 =?utf-8?B?TThpMHhyNjJWOHowWFd3bjFsbU10dFZ3elY2Z2s0cThRVDlIMjlWdVlNM0dL?=
 =?utf-8?B?dlhuNCthdEU0Rjk3MnBaMXhFM0VSMTNrMWVSVkMxMWI3RVpES1RiMFpXU0pE?=
 =?utf-8?B?Nng4clJHWm1zODdBOXBpQnp1R09NcHRhMXRRTEYzbmhYWG5uQmVrSGY5cS85?=
 =?utf-8?B?MUF6V1lNQW51bm1aanBrbCs5RWhudzlRK3JKbloyT2ZnRjFzYTd5ejVSWXZo?=
 =?utf-8?B?OFg0UmM0OFNKdSsvQXhNVEpRcGhheTNrbVRsM2RNb2VQdFBkYjVkWnBTa0Y3?=
 =?utf-8?B?cFF5c2d0OUkvbmJUZjJWRVJ3bVhTTW04OFhQd0hKeFdicFVSdVV6R3pBVXNh?=
 =?utf-8?B?azR1N1UrS01BclRQL0h2bXA1YyttaFRIV3BzbzBQS1FTS0RRYXhSbzZwNnZH?=
 =?utf-8?B?RnBXdkVVZTdYRjlRZ2ZtR0pqMmJWV2FCSWg2SDVBZGVXZVlja0lPM1A5K1Va?=
 =?utf-8?B?UENCdDQzTnFLWklnZ1hxckZIb3ZYTjhicm5CQjFrMXUyY09BYUJ6YXZZaFdh?=
 =?utf-8?B?dDA5bVhXTGVhNi9Td3MxVmxoR0tpb2cvd2dvd1A3KzZ6ZEVRYlJwTTd6b2VV?=
 =?utf-8?B?VUZwNVVEQys0UW81S2ErOWlGOWY1Q0NEODBXQkRmd0xFMlJNSDllaVFIQUMy?=
 =?utf-8?B?elJDLzNyTXI2TTAwaWxvSU1HMFF3Y3IwYTFMTThBVGtmdWpCMGNkUGVsSFFQ?=
 =?utf-8?B?N1JNQWxHS2lGbzNtdW9uWHMvallxbTlpbm5yaWE0N1drNWx4ZGhjSGRSN1lu?=
 =?utf-8?B?ODhxMlU0S2lZWmdoZ2ZjTUFkd0FXMCsyUUIwVGVSMjQ2WWV4OHNLWDFvZnZz?=
 =?utf-8?B?TXJPL0FjSHh6L3N2NXB6OFhGdjE2S2xPOUducE1KUm10WjZUODYweklBQU1u?=
 =?utf-8?B?VytjK1pHVWorTkR2Nkg4dzI5RjBlT01HY01DTE4xa0lraFlYZkVXUjU2K3Vl?=
 =?utf-8?B?cXZsaGhYcUNQQUNySEpsdU9idU1JcytBWjE2NTNqOTdwYVUrUndzdFVLbUJz?=
 =?utf-8?Q?EZSXbsoqgvDQpUKoaqItLL8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7507372C316F0649AE391B17603AC750@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae42a69f-5845-412d-4d88-08dc4f48348f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2024 16:57:51.7239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 64zkWmtO8BqNQ459/jtk/BJ2SMl7J1j0UtqMW2wfh0Yf6D+G1R+eH8hOMx9DGegvHkaa8nSORsiqvNa2+cf7EhqPs9+s+Pou9D6YxrR+RYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7520
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTI4IGF0IDIyOjQ1ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBJ
IGRvbid0IGFyZ3VlIGl0IG1ha2VzIGFueSBkaWZmZXJlbmNlIHRvIGd1ZXN0LiBJIGFyZ3VlIHRo
YXQgaXQgaXMgYSBiYWQgDQo+IGRlc2lnbiBvZiBURFggdG8gbWFrZSBNVFJSIGZpeGVkMSwgd2hp
Y2ggbGVhdmVzIHRoZSB0b3VnaCBwcm9ibGVtIHRvIA0KPiBWTU0uIFREWCBhcmNoaXRlY3R1cmUg
aXMgb25lIHNob3VsZCBiZSBibGFtZWQuDQoNCkkgZGlkbid0IHNlZSBhbnlvbmUgYXJndWluZyBh
Z2FpbnN0IHRoaXMgcG9pbnQuIEl0IGRvZXMgc2VlbXMgc3RyYW5nZSB0byBmb3JjZSBzb21ldGhp
bmcgdG8gYmUNCmV4cG9zZWQgdGhhdCBjYW4ndCBiZSBmdWxseSBoYW5kbGVkLiBJIHdvbmRlciB3
aGF0IHRoZSBoaXN0b3J5IGlzLiANCg0KPiANCj4gVGhvdWdoIFREWCBpcyBnb2luZyB0byBjaGFu
Z2UgaXQsIHdlIGhhdmUgdG8gY29tZSB1cCBzb21ldGhpbmcgdG8gaGFuZGxlIA0KPiB3aXRoIGN1
cnJlbnQgZXhpc3RpbmcgVERYIGlmIHdlIHdhbnQgdG8gc3VwcG9ydCB0aGVtLg0KDQpSaWdodC4g
VGhlIHRoaW5ncyBiZWluZyBkaXNjdXNzZWQgYXJlIHVudGVuYWJsZSBhcyBsb25nIHRlcm0gc29s
dXRpb25zLiBUaGUgcXVlc3Rpb24gaXMsIGlzIHRoZXJlDQphbnl0aGluZyBhY2NlcHRhYmxlIGlu
IHRoZSBtZWFudGltZS4gVGhhdCBpcyB0aGUgZ29hbCBvZiB0aGlzIHRocmVhZC4NCg0KV2UgZG8g
aGF2ZSB0aGUgb3RoZXIgb3B0aW9uIG9mIHdhaXRpbmcgZm9yIGEgbmV3IFREWCBtb2R1bGUgdGhh
dCBjb3VsZCBmaXggaXQgYmV0dGVyLCBidXQgSSB0aG91Z2h0DQpleGl0aW5nIHRvIHVzZXJzcGFj
ZSBmb3IgdGhlIHRpbWUgYmVpbmcgd291bGQgYmUgd2F5IHRvIG1vdmUgZm9yd2FyZC4NCg0KV291
bGQgYmUgZ3JlYXQgdG8gaGF2ZSBhIG1haW50YWluZXIgY2hpbWUgaW4gb24gdGhpcyBwb2ludC4N
Cg0KPiANCj4gSSBoYXZlIG5vIG9iamVjdGlvbiBvZiBsZWF2aW5nIGl0IHRvIHVzZXJzcGFjZSwg
dmlhIEtWTV9FWElUX1REWF9WTUNBTEwuIA0KPiBJZiB3ZSBnbyB0aGlzIHBhdGgsIEkgd291bGQg
c3VnZ2VzdCByZXR1cm4gZXJyb3IgdG8gVEQgZ3Vlc3Qgb24gUUVNVSANCj4gc2lkZSAod2hlbiBJ
IHByZXBhcmUgdGhlIFFFTVUgcGF0Y2ggZm9yIGl0KSBiZWNhdXNlIFFFTVUgY2Fubm90IGVtdWxh
dGUgDQo+IGl0IG5laXRoZXIuDQoNCkl0IHdvdWxkIGJlIG5pY2UgdG8gZ2l2ZSB0aGUgdXNlciAo
dXNlciBvZiBxZW11KSBzb21lIHNvcnQgb2Ygbm90aWNlIG9mIHdoYXQgd2FzIGdvaW5nIG9uLiBG
b3IgTGludXgNCnRoZSB3b3JrYXJvdW5kIGlzIGNsZWFyY3B1aWQ9bXRyci4gSWYgcWVtdSBjYW4g
cHJpbnQgc29tZXRoaW5nIGxpa2UgIk1UUlJzIG5vdCBzdXBwb3J0ZWQiLCBvciBJDQpkb24ndCBr
bm93IHdoYXQgbWVzc2FnZSBmaXRzLiBUaGVuIHRoZSB1c2VyIGNhbiBzZWUgd2hhdCB0aGUgcHJv
YmxlbSBpcyBhbmQgYWRkIHRoYXQgdG8gdGhlIGtlcm5lbA0KY29tbWFuZCBsaW5lLiBJZiB0aGV5
IGp1c3Qgc2VlIGEgZ3Vlc3QgY3Jhc2ggYmVjYXVzZSBpdCBjYW4ndCBoYW5kbGUgdGhlIGVycm9y
LCB0aGV5IHdpbGwgaGF2ZSB0bw0KZGVidWcuDQo=

