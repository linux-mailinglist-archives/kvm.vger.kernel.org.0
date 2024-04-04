Return-Path: <kvm+bounces-13623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D56E89921A
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 01:28:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5BDD282127
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 23:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D02F413C676;
	Thu,  4 Apr 2024 23:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GedHSnlL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A45134418;
	Thu,  4 Apr 2024 23:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712273296; cv=fail; b=R7PhQAVqLXPJcBTCmKIa8W6X4WnipuiTnC6PWt1ccsCCSLSDngisGiTZLYiesHW3GMdanmSda1e+U9jDj2FtTRBLoooM/yVbjyO5tUO2AmBA+ZN+Y34qo5krexBMEpPRox20f82K4JkGxuDXCx7oPuMv2lZXcLi8MpJUOg1Hb2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712273296; c=relaxed/simple;
	bh=0ZGKv/IfqDhy2XyTbAaL2hJ1MHYl98j12SciMXfwtSo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BAJgsrQx4BCYNPcwNkMpsClzMx8OGev59/oDVN+pTj4PMjXTyMAkqFIcEqkW7JKrByWUBraRuYBpZnC+iysLp7ezdXz8uAT0gd4/VrQab49Gz2Ww8BoU1rWiFHMmcvw22H7AGOwXpfcaYEEt+a433PrJzXGBda1Tm+zyEdOgFEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GedHSnlL; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712273294; x=1743809294;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0ZGKv/IfqDhy2XyTbAaL2hJ1MHYl98j12SciMXfwtSo=;
  b=GedHSnlLeQwYbNLTlwoArBwcxJ6sIuXWIA9D/zA8R19YsR21mCpWd0c0
   bYOF1fYj9Cmu4fR7odaxQjFXw+WiNiQBec3bJRye6La+ln2pSBiqsGjKv
   we9GCaGMFHIi3fwel3ST+SfZ/c0b7bdE22zPkMo4NiEQnupbxhXYTX+aR
   hDt3+BZIMEZmR8lOP6qcylmekUi0ldMmXllLZXIAKqmz6yD4JnZqAZ/ki
   0rmvShBLMvGvTEqhHbU+JvMMtHgocuKsNmuHNKl/F13UqLxmY3qJOTqXW
   VhDsptwKGDf1USVhWPsUG0DhK65oQt7DL52xa9wqw3OXjBaDWWy6tpgC9
   g==;
X-CSE-ConnectionGUID: qrsWmrXtSmq3GAzd0WXYPw==
X-CSE-MsgGUID: 7Fv7v+/OR8OXW/gUbE7zuw==
X-IronPort-AV: E=McAfee;i="6600,9927,11034"; a="7454641"
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="7454641"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 16:28:13 -0700
X-CSE-ConnectionGUID: wGoheT5VQL+ZJwKioVJcEA==
X-CSE-MsgGUID: cvwP5qVVQ52ucsYWpvofXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="19007356"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Apr 2024 16:28:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Apr 2024 16:28:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Apr 2024 16:28:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 4 Apr 2024 16:28:12 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 4 Apr 2024 16:28:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXKK+CsR02my7sRD3ZU1+E8aMTn+GI5e1zJGYn7wR/FKtp6jWgrqZfyf1tLe1smO0d5QNTvJHy4FetbrtCQ8qh91NuLLJSaUOW4SL+2GRBJnv+E0vSI0dhYkJUnExtRVTmwBTRM9T8lMHaI2+u4k0CIEFBLQzFOCK3+3P0jUpsn7JjfvlZt1ikm0sBQ7imsLQpZrOxVwg1cR5BOybuxuqROvVBZ3Ix0/rVHCtQVDrKAnQzPPysbeaD5aUKLvCQqS5cI4ZiD4waImN15MKZ9+nn/C+XHqPbvLRoLIVCWFEpc4m1KBnwRzIxbPEEgyabNMHAOrzxqoiHIFDQHY1i0ehQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZGKv/IfqDhy2XyTbAaL2hJ1MHYl98j12SciMXfwtSo=;
 b=TL9Fu51Cb+YN9p4Q/Jpqc1hLBIarFhR5H1vqT93sjIlqxLFjwSrJsnE8r9ISY8MNkPXp0UArqbicw2wqLm4ItuZGnpMxx6ODQALs3cIU+hAdmAUTJ5pWcvUdYkqEWA/heoOerUZxIfF3THcrTs+DBbKg5CXIrrXA4VpsR2RZmqvWmIsaT31h7YhGv+E2Bw5Uyf1IaQQ4+i1nRP6eQ1rvju5kfS++GuUpuQYmKxS2dO18L+6bRBwHWLd7g/poyU5sQxEn/hXBc13RpUbncN3H118aopt4XSmMXsHOw+vIWO55eNuc+QHd/Vs6yYtlqkgfbarWKbBfOO62iXq0onyMyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4816.namprd11.prod.outlook.com (2603:10b6:a03:2ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Thu, 4 Apr
 2024 23:28:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Thu, 4 Apr 2024
 23:28:09 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 078/130] KVM: TDX: Implement TDX vcpu enter/exit path
Thread-Topic: [PATCH v19 078/130] KVM: TDX: Implement TDX vcpu enter/exit path
Thread-Index: AQHaaI3RGrkueXmr5EGUc0XwC3RdvrFYVSkAgACOOQCAAA8fgIAAC+EA
Date: Thu, 4 Apr 2024 23:28:08 +0000
Message-ID: <f90812596ff9b976b97aa3fb5cff38fbabbba9c3.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <dbaa6b1a6c4ebb1400be5f7099b4b9e3b54431bb.1708933498.git.isaku.yamahata@intel.com>
	 <gnu6i2mz65ie2fmaz6yvmgsod6p67m7inxypujuxq7so6mtg2k@ed7pozauccka>
	 <1f30ab0f7a4dc09e65613f6dc1642fb821c64037.camel@intel.com>
	 <Zg8tJspL9uBmMZFO@google.com>
In-Reply-To: <Zg8tJspL9uBmMZFO@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4816:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zp7p9MInh1/BMN89Cdp4O+S9o/09FvIMxfBdnDUolQ4Ly36HnhH7Mb1jrA+SnPjKywKFC8q8y9FV6AYQ3rkIk5SK4FEEZAHoHpVCd61NNAfIL9ycSK12SaqGzyooiSVi36ygMVmIvK6c1jWuhhHtyAW0wxL4+lsSHbC4qrS2pupcsLv9dMxyiLmrjytgfVgy3hyC3tXSGnufcbKboWxP0iwcnqp1qV1FwvOYrORbZLvE7hMT/rNSwSIS2uv0l3rlU6iCk5uR/wcYiRiHL0wa1YIt/pfarbh/MU90poi4SjG6PTDcbPQUZsuvtTxhlLqc4BxENQnqlb1WsoAsIUyvo53loijtD03YTGdluS7X5Anc2CNrQfP7UftZiikY9mndFy4Cbvyz4CoZBmrbRKp8J3/c1eCYBO6ixGi9wqTU1NvhRl3d70hByRwECon8Srbx1Nyc3KD8HTfeUcezgEgxF1xlPOfOB0w2N3UCCkxiN8zUG7cZ2XxsmnkVd9Nfd/7bRRgByC6VaN1gqngxs7eRQN8tGLCX8nTSo1u4e4GdzNcONOB8uxS4B2c20rpPsmv60wuD9JgEc5As1q4dHLjz4YpDEFfrjnqMTPx8BE1UsevhdgW7fRKo8AanqLRz43AfECQrOKPTUCsYmLy5iwqEd3UdLbBy1mqnw5zvoWElG6U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXFEM2tzaEZxSFk1VWZJbjQ5dWlqZmEwK3hUNmUxU25RS1libGkxYkRHSzk3?=
 =?utf-8?B?RHByR3FGQ3Uwc21FcjdpSEJQbVJ0OHdNbC9DVWtQbURLdzNrK2JzQm1VTHZP?=
 =?utf-8?B?WHJWdmFyWVE0eGhVcnBNUTZ0aUVkQXZaNzUyZ0pBRnNZRC9IaEN2TEJ2TEll?=
 =?utf-8?B?aWpxRzgxSXpLbUVtbHU0Rzg5RmxiNy9DcTdMWGlWS3Z0Tk42SWUyWGZUd1pE?=
 =?utf-8?B?MHVtV01iOG5sQThqZHl0cEJ5ZmdvdVArMVZyeHlCbjhOMGZKVmhnVEgwWmhE?=
 =?utf-8?B?Syt0bDBKNVRMTmZCSHlTdS9LUzhQazNOS24rd3pUS3lMckZvQ0U2ZUc1Zzdk?=
 =?utf-8?B?ZEswU2tTeG95OU9OcGV6MHliY3pJUEx4c3JYbURyS0cyMmgzL1BMWHhKV0ZI?=
 =?utf-8?B?aEttRXkwa3RLbGoxaUJMQTU5VGhhTFNUNFM4VFBUQlBzL1FkM1ZobXN2amRa?=
 =?utf-8?B?U2xJYnBnVjBnUmJCdzZJbFBvSGk0clJYRm5nbk52NUNVeXFRcUhLdVZLU0RR?=
 =?utf-8?B?ekJoWkY2OC9qMWMvdktLTXdXdVZac090c3FhRnVVcG80UzYwd2cxdTd0QzRv?=
 =?utf-8?B?UDB1SU1PN2NXNlhCSllndCsrTE1uQm92UXVwZHNRSE9vdEhCaEU0NUtBNnVt?=
 =?utf-8?B?NEFoeU5KemFuTkNzQWlMaU5yL2N0ZWZKYkk4RGFXTTFvbTNEOWdjM2xsbGVt?=
 =?utf-8?B?cTY3SThtY05wMk9KNGt3NFdiOEF2S2JmTTVrV2dEMDBUUmNOaTFKLzRUekdU?=
 =?utf-8?B?aE9ReXZ4eHJ6MXFJSERvcFV1SDBhSE1RSlNHSFFPdkJCOGNXam1leUtPd2xR?=
 =?utf-8?B?WHZTRUxlbkh0UFBEa2RoTVJKRjhYY1lBMkp3YUd4aFRZN3VPYTREbGRrOWt3?=
 =?utf-8?B?ZEVYcDRTQzYwUVZNWVdXNWpoMDZsMm5iUzB1ZG5kWnN3WDdOYjF2NzN2UFc1?=
 =?utf-8?B?c2lFNWlTeG45YUluQXZyVVhpc2MxQThRNXduYnN2Ti9RVXlqa05FdnpwdVc4?=
 =?utf-8?B?azBaNE5zODh5dVJ4eGpYcS8xMVJCSHZldlJPUGV1aTBWdXVUSUhyT29wOEc3?=
 =?utf-8?B?VEd1NkM4b1BLTWdzaTFWd1ZWOXc2YjFNOEtFZ1d5cWowR2swSnNQYm1vVVNC?=
 =?utf-8?B?L21PV2hNUmpJYnAvSzZSZzhNUTBOYnBFcTVQMVozdC9KeUtWakQ3L0FPaXFk?=
 =?utf-8?B?NENDT3Q4bE44dGo5VnQxenh1bUo5WXU5Mkh4UUdMU3FkZXlCNWdmWW1hTDg4?=
 =?utf-8?B?S0ZPR2hXempQR0liSnlsWUVOY3RHVmt5S3NBcXRrOHFodUV2MGhkR1EvTVhL?=
 =?utf-8?B?MFBwQVpyL0ZVTmcxazFjc29TWnRjd2dXZmVSUFFBdjZsUmFpZ2FOUEpGK0RI?=
 =?utf-8?B?dWcrVDIxd1JLbHlxaFp0eTVzWGw4YlRwQWdNTWxxeU9pTzU0SEJuMStVOStH?=
 =?utf-8?B?eks5REhzMGVodXgrSnFraGZvQ1B2ZHJlcDI0aTBDNWxWRE0wS2p5a2RtVml0?=
 =?utf-8?B?VHVady9xMWhkY2JyOUc0eVVvM0h0RHZpTkN4a2s5VDAxeW1mSW00OER5ODhQ?=
 =?utf-8?B?M0p5UkwrbnlvUmptUHROQ0pvYTF3dko3ZExtRFM0aXRuMTlpK0Uyb1lNU0V5?=
 =?utf-8?B?MEdJUnBURlNJcVZ4OUhoR05EQ0RyYVE1cGRqMTNyM0pZQS9zN0pUQXlhNnFl?=
 =?utf-8?B?TjBMOWltam1tM3F1Qk1uR29FaDBHekpZZnZiTmdrS1VYMFh6N01OSG9rSDQ1?=
 =?utf-8?B?czhCRFlsZTI0elVsUkdVRzVWNTRXNHVDbWZ1NjBvaFJaOGM1WW9GenZPU1Fs?=
 =?utf-8?B?TmFnQkFOTzNXQnRMNEdpVmxUSUFSWExZZFpYYkxNNm0rRXdHOVRaTGdqMzNo?=
 =?utf-8?B?cGloemZkaURsb01pSkVDUnpLeGFtb2JmWGt4ZVJRVWdnTWVXUXE4MjJ6RkQz?=
 =?utf-8?B?aFNGMzJCMDlXWm45TFNvbnRlaHJkaEVkT1UvV0hCR2lxUEgwVHhOQzNhaW1T?=
 =?utf-8?B?ZVB4VmlYcHQ5dWVzREpiZTI3T1owQWtWOTBxbnR0bTFZNTd5S3FMWmhvSC9u?=
 =?utf-8?B?Y24rb1dVQ1hlRjgvaWQ4emNGbTQzZEdRbUo5TEhlUy85L2RCZlcwQnFNNHIr?=
 =?utf-8?B?RlB1TjFrM0ExLzBsU1ZPQnlQRnNUQllSSFRwQjJvSDBNaXBjaW15OHZram84?=
 =?utf-8?B?dUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4FE1054F6535B408D1FF961102E0208@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bfd4a53-41e8-4fd6-9c48-08dc54fee32f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2024 23:28:08.9207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N45oK8M4w1E4LpyI3r+sP+K/1aOQrD1kjCkgp7zYXkiNpYyqwjrBd7oHGTygwbeKSfUpQrcI9f/PorclDGSqzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4816
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTA0IGF0IDE1OjQ1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEFwciAwNCwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyNC0wNC0wNCBhdCAxNjoyMiArMDMwMCwgS2lyaWxsIEEuIFNodXRlbW92IHdyb3RlOg0K
PiA+ID4gT24gTW9uLCBGZWIgMjYsIDIwMjQgYXQgMTI6MjY6MjBBTSAtMDgwMCwgaXNha3UueWFt
YWhhdGFAaW50ZWwuY29tIHdyb3RlOg0KPiA+ID4gPiBAQCAtNDkxLDYgKzQ5NCw4NyBAQCB2b2lk
IHRkeF92Y3B1X3Jlc2V0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9vbCBpbml0X2V2ZW50KQ0K
PiA+ID4gPiAgCSAqLw0KPiA+ID4gPiAgfQ0KPiA+ID4gPiAgDQo+ID4gPiA+ICtzdGF0aWMgbm9p
bnN0ciB2b2lkIHRkeF92Y3B1X2VudGVyX2V4aXQoc3RydWN0IHZjcHVfdGR4ICp0ZHgpDQo+ID4g
PiA+ICt7DQo+ID4gPiANCj4gPiA+IC4uLg0KPiA+ID4gDQo+ID4gPiA+ICsJdGR4LT5leGl0X3Jl
YXNvbi5mdWxsID0gX19zZWFtY2FsbF9zYXZlZF9yZXQoVERIX1ZQX0VOVEVSLCAmYXJncyk7DQo+
ID4gPiANCj4gPiA+IENhbGwgdG8gX19zZWFtY2FsbF9zYXZlZF9yZXQoKSBsZWF2ZXMgbm9pbnN0
ciBzZWN0aW9uLg0KPiA+ID4gDQo+ID4gPiBfX3NlYW1jYWxsX3NhdmVkX3JldCgpIGhhcyB0byBi
ZSBtb3ZlZDoNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3Rk
eC9zZWFtY2FsbC5TIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3NlYW1jYWxsLlMNCj4gPiA+IGlu
ZGV4IGUzMmNmODJlZDQ3ZS4uNmI0MzRhYjEyZGI2IDEwMDY0NA0KPiA+ID4gLS0tIGEvYXJjaC94
ODYvdmlydC92bXgvdGR4L3NlYW1jYWxsLlMNCj4gPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC9zZWFtY2FsbC5TDQo+ID4gPiBAQCAtNDQsNiArNDQsOCBAQCBTWU1fRlVOQ19TVEFSVChf
X3NlYW1jYWxsX3JldCkNCj4gPiA+ICBTWU1fRlVOQ19FTkQoX19zZWFtY2FsbF9yZXQpDQo+ID4g
PiAgRVhQT1JUX1NZTUJPTF9HUEwoX19zZWFtY2FsbF9yZXQpOw0KPiA+ID4gIA0KPiA+ID4gKy5z
ZWN0aW9uIC5ub2luc3RyLnRleHQsICJheCINCj4gPiA+ICsNCj4gPiA+ICAvKg0KPiA+ID4gICAq
IF9fc2VhbWNhbGxfc2F2ZWRfcmV0KCkgLSBIb3N0LXNpZGUgaW50ZXJmYWNlIGZ1bmN0aW9ucyB0
byBTRUFNIHNvZnR3YXJlDQo+ID4gPiAgICogKHRoZSBQLVNFQU1MRFIgb3IgdGhlIFREWCBtb2R1
bGUpLCB3aXRoIHNhdmluZyBvdXRwdXQgcmVnaXN0ZXJzIHRvIHRoZQ0KPiA+IA0KPiA+IEFsdGVy
bmF0aXZlbHksIEkgdGhpbmsgd2UgY2FuIGV4cGxpY2l0bHkgdXNlIGluc3RydW1lbnRhdGlvbl9i
ZWdpbigpL2VuZCgpDQo+ID4gYXJvdW5kIF9fc2VhbWNhbGxfc2F2ZWRfcmV0KCkgaGVyZS4NCj4g
DQo+IE5vLCB0aGF0IHdpbGwganVzdCBwYXBlciBvdmVyIHRoZSBjb21wbGFpbnQuICBEYW5nIGl0
LCBJIHdhcyBnb2luZyB0byBzYXkgdGhhdA0KPiBJIGNhbGxlZCBvdXQgZWFybGllciB0aGF0IHRk
eF92Y3B1X2VudGVyX2V4aXQoKSBkb2Vzbid0IG5lZWQgdG8gYmUgbm9pbnN0ciwgYnV0DQo+IGl0
IGxvb2tzIGxpa2UgbXkgYnJhaW4gYW5kIGZpbmdlcnMgZGlkbid0IGNvbm5lY3QuDQo+IA0KPiBT
byBJJ2xsIHNheSBpdCBub3cgOi0pDQo+IA0KPiBJIGRvbid0IHRoaW5rIHRkeF92Y3B1X2VudGVy
X2V4aXQoKSBuZWVkcyB0byBiZSBub2luc3RyLCBiZWNhdXNlIHRoZSBTRUFNQ0FMTCBpcw0KPiBm
dW5jdGlvbmFsbHkgYSBWTS1FeGl0LCBhbmQgc28gYWxsIGhvc3Qgc3RhdGUgaXMgc2F2ZWQvcmVz
dG9yZWQgImF0b21pY2FsbHkiDQo+IGFjcm9zcyB0aGUgU0VBTUNBTEwgKHNvbWUgYnkgaGFyZHdh
cmUsIHNvbWUgYnkgc29mdHdhcmUgKFREWC1tb2R1bGUpKS4NCj4gDQo+IFRoZSByZWFzb24gdGhl
IFZNLUVudGVyIGZsb3dzIGZvciBWTVggYW5kIFNWTSBuZWVkIHRvIGJlIG5vaW5zdHIgaXMgdGhl
eSBkbyB0aGluZ3MNCj4gbGlrZSBsb2FkIHRoZSBndWVzdCdzIENSMiwgYW5kIGhhbmRsZSBOTUkg
Vk0tRXhpdHMgd2l0aCBOTUlzIGJsb2Nrcy4gIE5vbmUgb2YNCj4gdGhhdCBhcHBsaWVzIHRvIFRE
WC4gIEVpdGhlciB0aGF0LCBvciB0aGVyZSBhcmUgc29tZSBtYXNzaXZlIGJ1Z3MgbHVya2luZyBk
dWUgdG8NCj4gbWlzc2luZyBjb2RlLg0KDQpBaCByaWdodC4gIFRoYXQncyBldmVuIGJldHRlciA6
LSkNCg0KVGhhbmtzIGZvciBqdW1waW5nIGluIGFuZCBwb2ludGluZyBvdXQhDQo=

