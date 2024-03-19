Return-Path: <kvm+bounces-12069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 375B287F5E1
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 03:55:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57B081C21905
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 02:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62DC07C6DB;
	Tue, 19 Mar 2024 02:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d4qMVKyl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDDD7BAE1;
	Tue, 19 Mar 2024 02:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710816660; cv=fail; b=bpV0qbEFwhJUoQFgnm4DoweslVewC0/PWdrid118fM15by3AWVqp94tA1mEHKPSKC6G7+W8Z0fU9bmTx5mIgAJXZHGDJ6n2Xk4ZXHOUdDzWfeHSIXXrhb4x2h+i9hc9sNl6hJs8rmrAsnbT/Af6r/9PQm0cCi3um6XB1gls+Ozw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710816660; c=relaxed/simple;
	bh=0REbNbYV/eSneK3jxkzuuPUyCk7KylEMTpzpQ66qoYI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KJZJCcHGNcEKywdI8hRxsf9Jg8jb7toAubjbnXjnuK/OO5cCmaHgHvmsq+qHiTaD1JAvTXnCf2dgGAlq8Ho4ARpaMMjt3yn3j09IXEO0cEKIw0Zp/iXVRbFknpMzaGjZrJ5MFR3+MmVgdtdXeCk4QdkdIpEYYFwNwkFt+7W0PfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d4qMVKyl; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710816659; x=1742352659;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0REbNbYV/eSneK3jxkzuuPUyCk7KylEMTpzpQ66qoYI=;
  b=d4qMVKylIzb0oytvtAQgeDFBL8KfG4aMc3K/pjZWGF0BF0MqAeW5T7fS
   rOzXXY1/29YvnoIvZ+x3nWExyn3tmkBB5fdVX1o+R6ltShd6wTDkyfCfC
   xw3y11cG6i5nsmjxIH7G0zjtyOnbQogD2ovjQnvtMIYE9OVedrsr02CxV
   DoIvZgAQDrCBhXQaoeQW25y/LKRsVTYEodlQac0VyUR+I3KvLqrrV/20c
   zGGTKfzDBgYK0Biq09Mzy9ZdstpkRCxXe+FA+4nQMl2s3z+tr67ljEI4T
   2nREAUchMBxseHqem0clUdBipy1PoXruSneV/mBk112Oe80D7UnGcsjCx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="8606195"
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="8606195"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 19:50:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="13754556"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Mar 2024 19:50:57 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 18 Mar 2024 19:50:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 18 Mar 2024 19:50:57 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 18 Mar 2024 19:50:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpNn6s+j66aN2Ed293Ogyj6mbaeePny853Zf2ACUoz+dN2IGUge88i+q8GyWDUFXRFKKNo7mqSIH5CCGoEGSR6uSYcXt6Mlls/FhLGr8e5WWEf9iGeLPrqy6GN4MiWvLx6NJZa+aJRmYXHK869YqtfHyQD+A/IRQpmqW+DtZZa0idFp4h6LvAla43JaYgejHl83JenJKPnk7GwICxl2HY4vxWl0hJTbW+x4yrc78XdraIvAJNIUEjRU3U7/kd+8OUacundz2Z/7ehAOV6aPPO4jFX9ecjYHouM1TjO4jZEy2z0LR334drWI7qNX7GP9i0G/ygANmKRgFOA6PfAj9aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0REbNbYV/eSneK3jxkzuuPUyCk7KylEMTpzpQ66qoYI=;
 b=eTg3DG8XKxrcN1y+bgK0StY+aa1AwDxmKrqOhSOyZajpvnv5EnuIg7x14WgKVCnieFlhGE8E0ZaOE2m4EDA2Ao8oZQ3fceFzADy/CDgt+3YfTNiSG/G+AcMgpsNN1nCVZT6Aj37kHh8FOPyig5K2TKJCVKKRKZ44ehIILvpW6FvnNe+HBsGrZ1Cy91ELpHqddtIsi86ljT1+IPsQw/Or4Do3KBfgYr+3IYt9uT2A1HAXQavcQJiDbcheD4/DAFosX3ZzjlFWNcdCGLJjDqNpopPNUm735S5YxHc2iR1PDA4ZG3y4zSynse6RjzKweqsMSEMsTEznXJg9f9Qb8hh0FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB8012.namprd11.prod.outlook.com (2603:10b6:510:24b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12; Tue, 19 Mar
 2024 02:50:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.008; Tue, 19 Mar 2024
 02:50:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
Thread-Topic: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
Thread-Index: AQHadnqYyiwEEDddI0GwsG68yoNoPA==
Date: Tue, 19 Mar 2024 02:50:48 +0000
Message-ID: <52bc2c174c06f94a44e3b8b455c0830be9965cdf.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <e324ff5e47e07505648c0092a5370ac9ddd72f0b.1708933498.git.isaku.yamahata@intel.com>
	 <2daf03ae-6b5a-44ae-806e-76d09fb5273b@linux.intel.com>
	 <20240313171428.GK935089@ls.amr.corp.intel.com>
In-Reply-To: <20240313171428.GK935089@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB8012:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H7WN0L5kK2SMoucyl8dYkAOdmJFqvzbJ14XUWeb9DXjyn2IBAm2XkWj/0FJvi18nLS8zzI+mYS6bqk4g4Zzkr3CZ2qsenTDkDr61QHwzmTXpfCaaAA6VDHYojQyROZ6l3p3B6Jd009VnzNm9dngwGb85ovMhiHh1wk2GnWeZDiCM0tw4bN+eZOG4FH7ZOrbFe/dcaDRY2Ku12VDQ6AN4AN02f5+Y8rhoHTRF08sqDGNZ5rkf/l7rUFAuUAdZ83Cs1slJQFz8Vqpx7ugnXCPVuC4NpyZ+kI2xjqhzsXjGSi8ktYkgnHQ59yZJ93AEgpeCE43YeeLCP5IKtS3IwQlB3J7xznnyNxaq5fvdMCxBV5eAfBnOyWn0Oigmk8KOploDWde11Lf/TZJZ1irPcB+KG5ff0gryry/ps0ZuWC9LaHTZ1Di5BGdJvpXZetBnKtm4LbGN2FB2+ycfEtdQDncLE2UIV0VEQBNBVkzWcGEgStUo2OOZakwe9T+uSJkx9JD3aT73PVFFF0NtBFP+ApYZCVt+51ObTRtdcXgMqzA45nUDe1E2ffmpqjnA7ZX/FRXLrTp+0xvcQRlFEtPwitIk0iMrecsTWSKlzZwQq/tMueQcrkErFvvjeLo+Ms3IlRkb49f7My0yn98yAKa/qagvOl23kn9ImK/0a5fu2Qlai/k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZzlPR1Y3eHkyclYya2tneEFZQUFlVEFucjFlR1ozZzgzZDNZNlI3aFIwVEM2?=
 =?utf-8?B?VUg3bGhUR0FFUFlLaHRwTHpRNERtQU5MVWZOUXpsZFlwNVVLcDVlYjdMTGxF?=
 =?utf-8?B?blZmUTdhNUZIVkcrUXcyVThwVGU5L3UyQUJhTlpHblRiWG5oeitrT0w2aW0w?=
 =?utf-8?B?YzFFSXdUM0JTbjMwcU9XaXMwcTlEc3JTUGxnQWhWdlgzWlNhcHVodHBrRm5t?=
 =?utf-8?B?MTVrMW5hZngzb0R4MFRRTm5sYk0xMTJIK1RsbFhXY2w0RU53Tk9UMVZnYTlR?=
 =?utf-8?B?NXZCNkkway8wd1l3b2pkV2MxUkd2Y2Y0M1pnQmpBYXdXZFFjQytGYWZuRU5q?=
 =?utf-8?B?OUROc08rbUxHTGVKTFZldFpHdDM0VWo1eEFja3J4N09kdmhpeXRhdlRHY0th?=
 =?utf-8?B?RVZsNlg2cVJUSFpzSi8rZXJTUTlBc0hROGttSnRIcGlZTmg4OWZ0cGVKb0g5?=
 =?utf-8?B?RU5YcUNMRVExMCsybzVKdkMyUjlyd0hVRi9TVlJ5am0wUUlodWhZaE5HVEtq?=
 =?utf-8?B?b2lLZnNxb3Y1c3BYYVlncXNOU0RqQkJoL0tuek0vM1NvT21qNG5tNDBsZnpu?=
 =?utf-8?B?blNTL09EaGZ1TlMwTEt6Mmg3ZXRWK1o2cGN4UURNUVFPOTNVL2xabmYxSW8z?=
 =?utf-8?B?alhXQzlhdGpTM0tVOEdpVzBydzZaMGNxSytxS090ZjJZVzVOWnphQXpJR3Fp?=
 =?utf-8?B?S2laYWVvZzEyUGFPTmxXQ01ib0dnWGNTdGNWbXFpUWZ6YXFueXoxNTZ5d1Jr?=
 =?utf-8?B?MVVaVXIwUElpbDdFZnV1SW0wRlU4Z0pXV1pQWFFMRkQxQ3hjSy8xZ2U5bUx2?=
 =?utf-8?B?Vk9aN1lrOVJNckhLU1RBVkFwTExyVzl0cFVjOXFaNGc4SVl4blhnVFQvekNh?=
 =?utf-8?B?REtCZFljSFM1cGFjdGVwYXJlVmkwenZ5RmFZcVZRR3Bha3I3aFhtQXYyUDJo?=
 =?utf-8?B?UGdSUXc3MmVTQ3gvN1BzRFV5UVgzTi9GSmJCZjdpK1plNFhRbU1DK05aV1lH?=
 =?utf-8?B?YTZlc1N3SGNwTC9na211ZkRKOGlERC9rSE1yVWFlN0taV2Q4OTk5NmxENTl4?=
 =?utf-8?B?ak00VnNnVVYvTWlVRkQxUThUMUdxUVk3MnN2eDFxSk1qR1M5SnRRaXJMdFpM?=
 =?utf-8?B?bldRWG43b01ndDNLMGh2N3V1dWxad0daRVZsQVZtZmt4akdWaCtaMllQc3J5?=
 =?utf-8?B?eU5ZMHg4b3hDZGh5K3BsNThWRE1yQjNkL1JNMmFiUU8veitNbE8vZ3h6bndz?=
 =?utf-8?B?eFFkZGJnSU4xVkZpa2lJb0YyaGhWWlUweTZMMkc1UkV5d1pHenhSUkdhN2N4?=
 =?utf-8?B?TG01VHVjcGF6bjVwK3k0WFNMU3lWbGp3RTRNZVcralNxb1J0eDhodjliZlFq?=
 =?utf-8?B?Vk1MVW1Wand4SVlhbVBiU05TR2EzUXcvY3ErQnUyNzRpY0hpVlZ0MTJlZnY1?=
 =?utf-8?B?cC80dGJqTUdBN2FXRjZGMmdKSHpxWC9xN1B2ZXg2L0NvL1l4Z05Ed1p5SzdJ?=
 =?utf-8?B?dXRnd0drNzdudXlITFVpdG0yZ3NPZmhsbGJQZkxNTDZNbHIvcWZUeGRjbXRk?=
 =?utf-8?B?WlJpcHk3UXpPQTAzUXZpWjJMQzZWQTMxaWZTTnYwZWx2SDROaFZNUVovQkw5?=
 =?utf-8?B?RmpwSjZiZVlqdCtxZ0tnV1d2SFh6R3JFTldiK1JjR3dMTGJJbmFJaDNBUE1s?=
 =?utf-8?B?NnhZdnRjWU1rMVhHMkd3YVEwbTIvTHp5QVBmUkt0UndSU0lSUk5ZYVhFbDZz?=
 =?utf-8?B?SVBDaENIWklxKytQd3dqc01HMHpEVGhDZm81dUVFNkhzT0lvNUhTT3laMGJr?=
 =?utf-8?B?OUhMSGNLTVZ5WkVzS2VTbmJ0d1FEWVFCZ0RIU3RHOGVpVjM4cS91OWdlcWRp?=
 =?utf-8?B?Q1BoZnhiWE5MSnBKNW9ZNGExYkFORUY4M25wRWlub1dYcmM0a0FCaE03TzNz?=
 =?utf-8?B?MEY2OGp2allUL3FQNHZuMWZ0S3FVajVOS3FBK2haOVd6TnpIeVR0M3dZS2ZT?=
 =?utf-8?B?OG9RYjJlYnYxQks4L1RTUjJwZmtoRjlHaFV2SkZGbVl6c1pjZC84QjRkZFRW?=
 =?utf-8?B?bDZhZ0tWWE9nbnJ5L1JVS0tiakNZL29lVFYzS1VienNHRzR0Yk9DL29HQTRJ?=
 =?utf-8?B?VmVvTTNmeDhLamppakw5czdWK09RNXRsc0h3NlFzYm45Wkp2RWJ4MWVySERG?=
 =?utf-8?Q?GEDJdqrDHi1zBDHAAsoE7pI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9616639DD262164E836DCA23B61DA9F2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f0f9ff-430b-4608-e75a-08dc47bf61cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2024 02:50:48.4966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M3nExcdQnNpwI+thHcz1nwbWnH0jKfzDeAXMvYQd9f9l7C2LU0xCbGtRt/fX5KJq9HW8JEt/iySZG2rGYgOscEM9SYXXx6zc7hqLMmov6x4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8012
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAzLTEzIGF0IDEwOjE0IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBJTU8sIGFuIGVudW0gd2lsbCBiZSBjbGVhcmVyIHRoYW4gdGhlIHR3byBmbGFncy4NCj4g
PiANCj4gPiDCoMKgwqAgZW51bSB7DQo+ID4gwqDCoCDCoMKgwqDCoCBQUk9DRVNTX1BSSVZBVEVf
QU5EX1NIQVJFRCwNCj4gPiDCoMKgIMKgwqDCoMKgIFBST0NFU1NfT05MWV9QUklWQVRFLA0KPiA+
IMKgwqAgwqDCoMKgwqAgUFJPQ0VTU19PTkxZX1NIQVJFRCwNCj4gPiDCoMKgIMKgfTsNCj4gDQo+
IFRoZSBjb2RlIHdpbGwgYmUgdWdseSBsaWtlDQo+ICJpZiAoPT0gUFJJVkFURSB8fCA9PSBQUklW
QVRFX0FORF9TSEFSRUQpIiBvcg0KPiAiaWYgKD09IFNIQVJFRCB8fCA9PSBQUklWQVRFX0FORF9T
SEFSRUQpIg0KPiANCj4gdHdvIGJvb2xlYW4gKG9yIHR3byBmbGFncykgaXMgbGVzcyBlcnJvci1w
cm9uZS4NCg0KWWVzIHRoZSBlbnVtIHdvdWxkIGJlIGF3a3dhcmQgdG8gaGFuZGxlLiBCdXQgSSBh
bHNvIHRob3VnaHQgdGhlIHdheQ0KdGhpcyBpcyBzcGVjaWZpZWQgaW4gc3RydWN0IGt2bV9nZm5f
cmFuZ2UgaXMgYSBsaXR0bGUgc3RyYW5nZS4NCg0KSXQgaXMgYW1iaWd1b3VzIHdoYXQgaXQgc2hv
dWxkIG1lYW4gaWYgeW91IHNldDoNCiAub25seV9wcml2YXRlPXRydWU7DQogLm9ubHlfc2hhcmVk
PXRydWU7DQouLi5hcyBoYXBwZW5zIGxhdGVyIGluIHRoZSBzZXJpZXMgKGFsdGhvdWdoIGl0IG1h
eSBiZSBhIG1pc3Rha2UpLg0KDQpSZWFkaW5nIHRoZSBvcmlnaW5hbCBjb252ZXJzYXRpb24sIGl0
IHNlZW1zIFNlYW4gc3VnZ2VzdGVkIHRoaXMNCnNwZWNpZmljYWxseS4gQnV0IGl0IHdhc24ndCBj
bGVhciB0byBtZSBmcm9tIHRoZSBkaXNjdXNzaW9uIHdoYXQgdGhlDQppbnRlbnRpb24gb2YgdGhl
ICJvbmx5IiBzZW1hbnRpY3Mgd2FzLiBMaWtlIHdoeSBub3Q/DQogYm9vbCBwcml2YXRlOw0KIGJv
b2wgc2hhcmVkOw0KDQo=

