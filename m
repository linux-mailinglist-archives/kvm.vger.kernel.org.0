Return-Path: <kvm+bounces-19146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED6829018D8
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 02:09:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71C601F2113D
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 00:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6DCEC5;
	Mon, 10 Jun 2024 00:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QpqL6f3z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F06181;
	Mon, 10 Jun 2024 00:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717978144; cv=fail; b=UaElblnqXtjf5FaY41EUgLps3Kc1Gs2YoBCwK0D4RMPGGO6TAMthj12EnE6c1fDmS2KxxgHHnmusa8VdWNuf7FV8jeH55rktG2QCivK4UCHd34FgSN44PW4rzROZMLiHmWtAKh2aelTipg/kPKD0lpr0tjWu25NcTIY7kXc0x84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717978144; c=relaxed/simple;
	bh=yUZeiBdG5Ap4hAGuVWs0ihGV2+dzMoiO9vwuT6T8TE8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G1/4jd+kvKAyoi1lkPCvnyKmMNskCf6BYMmJyBO+/IcIpKBJrhhAngk6Xuh0nk+El2tK3bH58vFPu6u/1RkmStb1P0FQ/M0q09Rff8y7yy55bnWRETV2KdQA0OfCitmTpQdyG7wi2nv2cCrBYYXf9RLrAuPRldHZ6gJHJk7wPmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QpqL6f3z; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717978142; x=1749514142;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yUZeiBdG5Ap4hAGuVWs0ihGV2+dzMoiO9vwuT6T8TE8=;
  b=QpqL6f3znQSLFxRxtQWkKcSJ4jlGYJqcs4dUHrPZyjv2sJ1T2d2qxz6e
   /vhONqEJlUUsY1b3mPAsPTMdvUjnIuftsH7o365+3cvROU3GkQmZSAOHU
   ZUFFRyb7nRWWyYsoXBq/jajYlyxYSqC6+1NLZ3O8R3GDTtn6GbyAaEidf
   HmE79/qyLi9xfknk7GYn226VJvVQ1I1nTjS1Y5J79zsPmK7+xwNQt/iLm
   Eb5O55bfcGF3yExgsFci4Rdwqxh+3CJ3ixKRdockpOzS5CiMdQQ2ar+q+
   T9mgtPTiEaPA0I90FMgG/3B4wDncYq8CcRbt7JMrSOKtcFxw2j7bdNwXA
   g==;
X-CSE-ConnectionGUID: N4jNhDggRR+1AXYTs2Z6CQ==
X-CSE-MsgGUID: gcpRxFmoS+mTqjmyVK9Sgg==
X-IronPort-AV: E=McAfee;i="6600,9927,11098"; a="14805773"
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="14805773"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2024 17:09:01 -0700
X-CSE-ConnectionGUID: L3yDW5kdSBmu5amvSChJBg==
X-CSE-MsgGUID: sStT8aPFTRqp8vwX7OHc9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="76364497"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jun 2024 17:09:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 9 Jun 2024 17:09:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 9 Jun 2024 17:09:00 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 9 Jun 2024 17:09:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 9 Jun 2024 17:09:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obCNgakEsuW99U1fCYPbmdGMlUJJWrOBj3uiy777Jlb/Yysf5mDkyU3tvOIGPY5R5xASUqFRF81m7lpExFY2e/j8W7wM4iLFolDLM513p4xw2AD045celyOQSA4YlNyG+R0sQ4i2cVlRp6RHYTEuFibgoCgY4KIBMryDuGsH7yArb9NSwNXgCOZtg+0Zp7/DKbJHZJNmNqpzeXSmPsnfZqFUpdRozRdPnPanPXvMzicAVMNi+wXO0KumXjcdpEVIaKoLgq0s6LLDACIYT4WYvweCo25Kq0U5i6WQHYCAdEAtLZUEKvV/E20laYAsi2Zlu6K8zLWPkKAcoqRs7VncJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yUZeiBdG5Ap4hAGuVWs0ihGV2+dzMoiO9vwuT6T8TE8=;
 b=jHbbhv4BGN880eXikcFbLEopbyTLIhbjz67VTRIkEiClameUaU2hbE0l3bPn2fNu+g5jvvl5eFzq4t5SoNhQlWH4DBn53jK5095VTOZh3rtV/20ni0rbItWLGMRe6WWG3YQwcMfeZFEp2XFkwnTENmBH2lrczyqHfUEHrz1gQb+Etqgd4U0KqIUgsAgIfxpDIHrYJUxO2S3g+/pr/oNI8Z9w02tHbAUn/8G/Z7+ZG4FfaUBQKBPO0ycw0AsdTnp8/gJKYcIX+DBGDHYXiAo2KddCeJjpgWv9ha3trEgN6l+RTYhH3xo+cTI1bG7ULzziVggg6f9Jy6tdJmZVfIhMGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7681.namprd11.prod.outlook.com (2603:10b6:8:f0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 00:08:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Mon, 10 Jun 2024
 00:08:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 09/15] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Topic: [PATCH v2 09/15] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Index: AQHastVuA3gf0B2hd0WXTTAj0WB0+7G8CKWAgADD1oCAANY3gIACjGeA
Date: Mon, 10 Jun 2024 00:08:56 +0000
Message-ID: <9c5f7aae312325c0e880baf411f956d4cce3c6d1.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-10-rick.p.edgecombe@intel.com>
	 <CABgObfbzjLtzFX9wC_FU2GKGF_Wq8og+O=pSnG_yD8j1Dn3jAg@mail.gmail.com>
	 <b1306914ee4ca844f9963fcd77b8bf9a30d05249.camel@intel.com>
	 <CABgObfb1L4SLGLOPwUKTBusN9bVKACJp7cyvgL8LPhGz0QTNAA@mail.gmail.com>
In-Reply-To: <CABgObfb1L4SLGLOPwUKTBusN9bVKACJp7cyvgL8LPhGz0QTNAA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7681:EE_
x-ms-office365-filtering-correlation-id: 7b898373-71b4-4fb0-0090-08dc88e18592
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?NWdmLzFYREd1bjd1bVVhUHJVNWNZU3Y2R2xQS0RHQXhGYXNoVGRpTEg0eERE?=
 =?utf-8?B?cWdQNDQ0R1BzZ1NPMGNOUVhuckNYaHpvNjRlM1NQUENTVW1BMkFnaEFLZ3ZB?=
 =?utf-8?B?cHJwVHJuQjgxUUZpUU1pUGcwQ2llZzgxNTJqOTZtV0loU3F4Z094TnMwVWFU?=
 =?utf-8?B?NGYzbGZzemF6K2xVWENYQnUwWmxaZjY5cDN2ZjRRUTR0UEV5UmhBYXB3SWJm?=
 =?utf-8?B?cXJ6THBpYnRyVnRNa3dkLzJsSW9sVkRYYlZxS0ZibklaREI2dGFsRWduandu?=
 =?utf-8?B?YmMycEdWbEo3OHNvTFdTWXVyYXBRWVRyUlZhVmNkL0dpNUFLREE2ZTdGcDcw?=
 =?utf-8?B?MjhUdzQxSER1ZStBWjBHTk9JMU54OHJtd0V3SVBzSzlra0xIZ3lHbUVlQnVz?=
 =?utf-8?B?Tk1VeGxnZ0hwby9QOHQ2Q2JaK29mclduMmJXTHlPdjh4K2hOeXdHRWJUbUJy?=
 =?utf-8?B?QWFoMU9XZ3pBOU1NSExtZ3JyQ0xqaEtKRVMvSDRLSFpFZkoxWklvMVJOZFZw?=
 =?utf-8?B?c1lmb3BXMFR3eU1LVnRtSklQRDBZZ2JObjVCY3dmSlVrTDQ3M2IxekZwMW1I?=
 =?utf-8?B?MTRoRDJ3bUdtQWZscWg1THhTU0hlRHlzVnFqR1hsNjNQRFptMlc4SC9aMkxn?=
 =?utf-8?B?eDBMRmc5Tk5DYkVNVy9YdDIyZWg3MHYxUGpFZDZ0YjhvZkM4R2pkQWRhRGFi?=
 =?utf-8?B?OTF6WnlPU1NhUW9yV1dxcmg4cEdYUDlPdFZMbFZMU0NwMXpORStNdm1qUVgw?=
 =?utf-8?B?VnN1ZE8yU0loTEdWWms4MkdqM3VGVDMyZERWTnBhRDY0MHhxeGxST2FTVlg2?=
 =?utf-8?B?VEdTTGxEVHcyY0t4Skl6VXV3bHpjUmZxVTl1eGt4OWRtb1FjWVlMbTVvc0xI?=
 =?utf-8?B?Zy9xVUsyZUpHdnJNV1dXYzBvZmZ5c1ZteU05eTVSTnNweW9jYklYMW9pUG4r?=
 =?utf-8?B?eG9rZnRWY3BabHM1K0ZQbFlTRTlqQjRsTk10TElDU3pOU2t0UU95NmRYWG9D?=
 =?utf-8?B?SG1xM0NCOEpYRGVGYmtWdzJlKy9oRXdWcjRKeDFBUjJqQlNNbTljSUQxTkFX?=
 =?utf-8?B?dnVzdFVGTnlXNDFXRThDNUpVMmRHZVAxRFdGcEdRdnJKcUZjdk9yMThqZmFo?=
 =?utf-8?B?cWRBZTZqTDNzdDVOUm0wUnhMVUsvenhQNzExUFdjNDNzU3ZJT2N6eTRnaVVs?=
 =?utf-8?B?NFRYcGJHM1kwTzBlQ3pUWlJIdjVLY3BTV3FvT29nN0VaNEVLSlhKcnNXSWNC?=
 =?utf-8?B?V205VHVaVmxoK3ZMUkxNVytGT1gwUXB4TVdwemtDa1ZuRnlPQnArWS85NDNx?=
 =?utf-8?B?aWNkZGZIOU90SllTdjV0aDZpRGJqN1RVRVNKUUNVTVBRQmZNLzRoQzdoMzZC?=
 =?utf-8?B?T2gxelFoRStVN1o0T2JJK2xoaVczRjhjTXN3ZTFjSUF2dVExU3BGTUdhbnVh?=
 =?utf-8?B?emZDTk9VOHJFeDlINmtlbW95M0NoUGgvUmZoTENjcVpHVEhSSU5tS2Rrckpm?=
 =?utf-8?B?dnVUZWtQWXIyd0hkNXRIbTFGeEpTK0R6K2ZFNnE3SWwxV1BIRGRvK0ZKQ0Q1?=
 =?utf-8?B?R2xoYmJqWi90SCt2S3k5RllnQzI1U25MOXVrL1JmOXZhTEo0V0NjQ0YweEFT?=
 =?utf-8?B?d1dhYWN1c3RscFcxUDhKb3dEV2gyQkY5NTZXVDl2UkxqKzBnbE5OdUNPYnVh?=
 =?utf-8?B?VnhQMHloMWlKS3lPbjFIeHllaTVxaFlRMFgrUCtPS3hsMGxhZHp0WGE2TFpl?=
 =?utf-8?B?bHV1MTEyVnpsQnRMSXh2TWFsbkRXNG4zeDJVLzR2RGlTNTl6RytjTjdFaHBR?=
 =?utf-8?Q?582OmDnotO22FCOYm1FV+gLN5zW4NyPrQHAQY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tk1NaG03MXRoTHdjaHdybEh1alZqV2tKNXNTa2ExOU5VTnFHMXJxVzRPY0tJ?=
 =?utf-8?B?RlZPWE9mRHFMV1RQQVYxdkNMeUxkcUl2RWduRnFrWngxVWF0aklBVjNMNUdx?=
 =?utf-8?B?RVo5T2pzQStMRTYzK1VWWEo3b28zcWN4TWJJVFlvdnh4Z3l5bEh1cVFlNmVq?=
 =?utf-8?B?elNoaTZxdzJjNm1CbEFZTWl0aGNqejB2amphMUorMHBRdVYzQnhLenVJV2hu?=
 =?utf-8?B?eitMMHB6RDZ1MDNaM3AzOWNJRDdVMkRmejFGY1JpeVc0TG51R0hRUTRzakFw?=
 =?utf-8?B?SWhmekUwMEkvampCbi9JZFpET1ZxWExFc01lTWZKVzloOEE1SDhpZXkxY2pU?=
 =?utf-8?B?cGVkZ2xIVDByeTM3OHpmaWZ1eEQ0eXZKcVZXOHlnNTJFMzAwS2tjQTRkK2tT?=
 =?utf-8?B?SkppME1mYnRlRlhUc0c1NGpXcGpXV3p3UHZRUmhocUoxNkljUjJudGFaY1dF?=
 =?utf-8?B?TUhINkJiaVlOZE5FUGtxb0lER1JSZ3gxeXliTXVJc3BkQVdicTZMSnRtcVhL?=
 =?utf-8?B?NjhJQ3h1ZzZhSFVwREhIMFFXOU82cnNlaDZmMzJsZXdiVlNIaTdReXJCY1lH?=
 =?utf-8?B?c25JTllDMnBrRjExcUQyTFV2VE13QmdZa2Z2cFFWZGRFMXlzeVpXNllVeFJQ?=
 =?utf-8?B?dXhGc3YwRlREY2h1Z3c2aDdneVJFRGxpcTJ1SzNBL1Z3aDM4VVpVWE1wS3g5?=
 =?utf-8?B?U3phT1NReVJ3NXUyNitsVXBzeXozbWR0U2U4cDUxSzJkM2xibFNUTDBzR29q?=
 =?utf-8?B?allIeTVpYzQwcEw1Z1YrcG1GNmtrVW9xL3lWTk5DQTB0aURVdjYwdWxXbXpR?=
 =?utf-8?B?aDhLdXZQQm9ZSENBV2hlemcrRDdDSVZzNW1IeFBjYzQ4QzkvRm11MVpyRUhh?=
 =?utf-8?B?NjNycC83TzRUMmJUZGhKNi9JbzFqOTNGbzdKV0Y4YWdLR2lXbnlwT3o3Ujc4?=
 =?utf-8?B?YmNEclFSS01GekpvaXIyTm9PRGpCQkgxRUJ5amxJQ0NQU0JvM3NtWHJXTVFz?=
 =?utf-8?B?aGFiaHpBSjhlWWFkSk15UVdWalNPMjFJQTFLbXAvWWRSd29PTERaNTRuTjE5?=
 =?utf-8?B?RWpQNDdtR1RPV3FnQTRMRXQvcXdvSGszSkowNDB4ZldnS3lpeWVDRGpvVmov?=
 =?utf-8?B?cCtrb0JFZzhkcnFuMk9xL1BodnRrUEV1TGVua0g4UGpNWEJ0WHBJcTZ5QktZ?=
 =?utf-8?B?YXh1c2VZUVhsbHgvSTI2WDFPbWZ6NXRBVTJaWVAyR1o2b1FhdGNLOXlpT0NQ?=
 =?utf-8?B?aWQ3TVRWSFYrTjg5d1ZreVhuMEVBNzYvNDdXWTd6L2JOSmR2UTBXMFVhanJn?=
 =?utf-8?B?VS94K3lQRjFEQXE0L2MwZ3c5MjMvRmxEU2F6R3dUVnZ2ZGgrUmpjRDU0d1Nv?=
 =?utf-8?B?WGljQy9YWkF1YkJTWW55SEc3eWMra2MrK2wrWGF4OVRVNVpXbU04bDI5cWs0?=
 =?utf-8?B?LzNwbzNvUU5EblBLK1JHODA4cERSZnlzR1d1OFlFMUpDRFlWUkxkNUN1Ky8r?=
 =?utf-8?B?N3dNcVV2OVM0M2xrbDRodlVDUzZBSFhVMXpwWURKcTYwMXNHTWJNNllxangv?=
 =?utf-8?B?V0l5NFEyNEtwME16dlRiSGY2QUZ0NXl4U0hOM2IyWW80UFdzSkUrZkc3TUJV?=
 =?utf-8?B?OEN3REtSWkVUL1UxbkplQnIweHB0bFVCMFVSSkZqa3MzdGtXWndob2JUck1H?=
 =?utf-8?B?T0FGVzcwTmI2YWg2bFZybzI3dnprZkRJMFU4OTlhU2pCVjJNUGs0MWtsZlNW?=
 =?utf-8?B?bTdKQ2RDVldBYUlIVFJPanJ2cDRyQ2QxWVg3ZDlGV093U1QrbXRuVlVBbldE?=
 =?utf-8?B?QkJJTUhGekhNTzAzRnVVVTl6d1pZaG1VbThFc2w5b0xwRjdxWWxxNE9naVVG?=
 =?utf-8?B?b0R2akZyUEQyN25uaXpONjllamNUZ3NlbU9VKzRZcm0vQmpqS1AvWXhjazZV?=
 =?utf-8?B?Mm9aTlRhK21QNjYxUmZEbjA4OTFhV2FyTTNRZ05XVGRTZnJjNkhGTUVhWkd3?=
 =?utf-8?B?bUdHSkltRVF1WnN0OXRCN3pXTi9LRG1mKzhCRll2SHR1a21xNnIvd2xDTTEv?=
 =?utf-8?B?ZVFxTkM2aXY2RElWUFIxQkFZeWFFOCtHSHlMb2tUOGpPU1U4OUREbjZFejha?=
 =?utf-8?B?c3J6dFpHUXRCRjJuTnRxSmM5ZEpBS3NBdjVjZVVleEJBRlA5UENpdGZMM0Q2?=
 =?utf-8?B?RUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F340BE27C5E41E43A097A68148B0F38B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b898373-71b4-4fb0-0090-08dc88e18592
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2024 00:08:56.9555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j3gtDIEYQtltp/1WuNK4L46lIyHvFyzE2VuRYKsjb0S/a4oWkqnBIYdYWcd4zTiiao4RCnkuEWeLQ6ANpa+xWodoDrVxqHoqALqL194Ygng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7681
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTA2LTA4IGF0IDExOjEzICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiA+IEkgd2FzIG5vdCBsb3ZpbmcgdGhlIGFtb3VudCBvZiBpbmRpcmVjdGlvbiBoZXJlIGluIHRo
ZSBwYXRjaCwgYnV0IHRob3VnaHQgaXQNCj4gPiBjZW50cmFsaXplZCB0aGUgbG9naWMgYSBiaXQg
YmV0dGVyLiBUaGlzIHdheSBzZWVtcyBnb29kLCBnaXZlbiB0aGF0IHRoZQ0KPiA+IGFjdHVhbA0K
PiA+IGxvZ2ljIGlzIG5vdCB0aGF0IGNvbXBsZXguDQo+IA0KPiBNeSBwcm9wb3NlZCBpbXBsZW1l
bnRhdGlvbiBpcyBhIGJpdCBURFgtc3BlY2lmaWMgdGhvdWdoLi4uIFNvbWV0aGluZw0KPiBsaWtl
IHRoaXMgaXMgbW9yZSBhZ25vc3RpYywgYW5kIGl0IGV4cGxvaXRzIG5pY2VseSB0aGUgZGlmZmVy
ZW5jZQ0KPiBiZXR3ZWVuIGZhdWx0LT5hZGRyIGFuZCBmYXVsdC0+Z2ZuOg0KPiANCj4gaWYgKCFr
dm1fZ2ZuX2RpcmVjdF9tYXNrKGt2bSkgfHwNCj4gwqDCoMKgIChncGFfdG9fZ2ZuKGZhdWx0LT5h
ZGRyKSAmIGt2bV9nZm5fZGlyZWN0X21hc2soa3ZtKSkNCj4gwqAgcm9vdF9ocGEgPSB2Y3B1LT5h
cmNoLm1tdS0+cm9vdC5ocGE7DQo+IGVsc2UNCj4gwqAgcm9vdF9ocGEgPSB2Y3B1LT5hcmNoLm1t
dS0+bWlycm9yX3Jvb3RfaHBhOw0KPiByZXR1cm4gcm9vdF90b19zcChyb290X2hwYSk7DQoNCkFn
cmVlZCB0aGF0IHRoaXMgaXMgbGVzcyBURFggc3BlY2lmaWMgYW5kIGl0IG1lYW5zIHRoYXQgdGhp
cyBwYXJ0IG9mIHRoZSBnZW5lcmljDQpNTVUgY29kZSBkb2Vzbid0IG5lZWQgdG8ga25vdyB0aGF0
IHRoZSBtaXJyb3IvZGlyZWN0IG1hdGNoZXMgdG8gcHJpdmF0ZSB2cw0Kc2hhcmVkLiBJIGRvbid0
IGxvdmUgdGhhdCBpdCBoYXMgc3VjaCBhIGNvbXBsaWNhdGVkIGNvbmRpdGlvbmFsIGZvciB0aGUg
bm9ybWFsDQpWTSBjYXNlLCB0aG91Z2guIEp1c3QgZm9yIHJlYWRhYmlsaXR5Lg0KDQpUaGUgcHJl
dmlvdXMgdmVyc2lvbnMgY2hlY2tlZCBrdm1fZ2ZuX3NoYXJlZF9tYXNrKCkgbW9yZSByZWFkaWx5
IGluIHZhcmlvdXMgb3Blbg0KY29kZWQgc3BvdHMuIEluIHRoaXMgdjIgd2UgdHJpZWQgdG8gcmVk
dWNlIHRoaXMgYW5kIGluc3RlYWQgYWx3YXlzIHJlbHkgb24NCnRoZSAicHJpdmF0ZSIgY29uY2Vw
dCB0byBzd2l0Y2ggYmV0d2VlbiB0aGUgcm9vdHMgaW4gdGhlIGdlbmVyaWMgY29kZS4gSSB0aGlu
aw0KaXQncyBhcmd1YWJseSBhIGxpdHRsZSBlYXNpZXIgdG8gdW5kZXJzdGFuZCBpZiB3ZSBzdGlj
ayB0byBhIHNpbmdsZSB3YXkgb2YNCmRlY2lkaW5nIHdoaWNoIHJvb3QgdG8gdXNlLg0KDQpCdXQg
SSBkb24ndCBmZWVsIGxpa2UgYW55IG9mIHRoZXNlIHNvbHV0aW9ucyBkaXNjdXNzZWQgaXMgcGVy
ZmVjdGx5IGNsZWFuLiBTbw0KSSdtIG9rIHRha2luZyB0aGUgYmVuZWZpdHMgeW91IHByZWZlci4g
SSBndWVzcyBkb2luZyBiaXR3aXNlIG9wZXJhdGlvbnMgd2hlbg0KcG9zc2libGUgaXMga2luZCBv
ZiB0aGUgS1ZNIHdheSwgaGFoYS4gOikNCg0KDQo=

