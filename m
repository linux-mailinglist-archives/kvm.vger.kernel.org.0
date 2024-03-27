Return-Path: <kvm+bounces-12795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EEFC88DB94
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 11:53:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D18D61F27C38
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 10:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A3724317C;
	Wed, 27 Mar 2024 10:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="de9bMXN1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D0C6125;
	Wed, 27 Mar 2024 10:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711536820; cv=fail; b=JRzmvnL8AkmF4+H8LBJt4pKUSd1er3vJpdnys104W9QnIyos3fPI6hOM5GCZwROpT/1yjdoqgu+ShBkRgX6fys7aTwPxUVlQudIPUCAmZEHujAn2eNxuaPZQMhAl6TLrwPQSNRgIHfgX2c/Tch4WXHCveahfxUmaDcO5P56Q73A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711536820; c=relaxed/simple;
	bh=mcvD8ToXAH50ipJqGMXdy7/sSxzqU/Ky7Khco9cO5/0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LYBdquPuFcVb9nOWFuoHDk6Lw/Qs+FAlxzaZbbRdFHqJ6vUKpTgkamTO1G0zIy7PeAU302kSEj3sp11SplQBHHVbld0cUc1ch3GU/cQ4K3CvT4Asc2Rz4QCQ7I8rRuRSGotABC5e+JntJs02+gX4e5HISIhF5XqMO5tA53k6UGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=de9bMXN1; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711536819; x=1743072819;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mcvD8ToXAH50ipJqGMXdy7/sSxzqU/Ky7Khco9cO5/0=;
  b=de9bMXN1GMg6dapcYhtdxt9959aeqAC1yCVEnpF5SYBsbtWWEoy5bM4P
   NUcmLC/KPi8/ODnmYUuQQu4TKhnqxtdfV5MO04ery1WOevhZlEBr7MAHl
   9Lnm9n57pt/QY6DHikLROxCOb+RLTXIBicVB7am02oLYNFktZwMiVazF9
   C+MPXxddPsha1unkVPJzjhEmeE63L1pPXSUVTSL1UWt7EFocLfTo3GOWe
   JCDuV1RbO74p3ZtZebVGp0ZBvlmHjGpuK2zsIgy7NZ70Pm/bmuVGYGBVq
   P74VrizPe/MN2LHhpLZ3LZZWbCsqm1DFs5EAC5hUHtEA4udSbIgecu5ef
   Q==;
X-CSE-ConnectionGUID: 5XWs9rMITPy3hWDnvznHuQ==
X-CSE-MsgGUID: rxbllL/XR/2s3zgDXPqSXQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="10430382"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="10430382"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 03:53:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="16101862"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 03:53:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 03:53:37 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 03:53:36 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 03:53:36 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 03:53:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QROfvwZPGcjUwWah22YANx9SS3vzmpjl7mt812rMTK5urajKXRD1jpyZ18U0cmPbcxopTO8NsoptZ/6PghdTM1QpFMxJxAr59kGpnhI6gdTbk3EQlBezaQl5wZO+B2rYWsWVJZQpI/gqn07/RoWSsSlPMAK8WWZSsUCkc/hbpkIQgt9yOBCT0V8+/3qE6dPbhjXqMeE/+tqmySsYpWJDxSemYAgDEF2Tw1pVr+QeTVOwO1DL7pYHpbe39Wau6dKnxEzEsujn4s2yv1qXfLEBLvTWFEGombtO7UaAJAm4XKWhlw9jOBCna3sn3v9w+/Cmdfz5NA/kmVZu8SyPhvX03A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mcvD8ToXAH50ipJqGMXdy7/sSxzqU/Ky7Khco9cO5/0=;
 b=Yo1XaIgCv2yzTOXdC+uGfyaPVxxMTtcILZ/LYjrtzpwE34zRVDfxgpYlKatmxmdYy/wtpFRFTvl4hSMjpjCx5LKFJVw4/oQXlZq24u8fV6k7XbqVJE4tgRIEBjwi12k7VSHNYxID1Azkf67kiKZnZzzCo0GvEIK8T3NuJ5e1Sz7sXu9yrvHqmELIoXU4izWQTqSSJqwh9XYJVnfhlvdoJxuHu8Wn6wxxyL1F4sXk5T9x3Tu2wQmp97vZzrm32+YtaWyycu4q3UBC5UIfCkJ/zKrKAX3oo0/wC/Gwfgnag4I8kZl8d7JnPeO6pDGedDyqfDkyfBRyYaUYxb5xW3zMuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB7935.namprd11.prod.outlook.com (2603:10b6:208:40e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 10:53:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 10:53:34 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "luto@kernel.org" <luto@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Li, Xin3" <xin3.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Kang, Shan" <shan.kang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 6/9] KVM: nVMX: Use macros and #defines in
 vmx_restore_vmx_basic()
Thread-Topic: [PATCH v6 6/9] KVM: nVMX: Use macros and #defines in
 vmx_restore_vmx_basic()
Thread-Index: AQHaccD/dkG5359gmkifwLSpBfBYJbFLhoIA
Date: Wed, 27 Mar 2024 10:53:34 +0000
Message-ID: <0caf23e4a0dc79b65c89022330495b10bffcf831.camel@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
	 <20240309012725.1409949-7-seanjc@google.com>
In-Reply-To: <20240309012725.1409949-7-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA0PR11MB7935:EE_
x-ms-office365-filtering-correlation-id: dd72d447-a4ef-4a28-2e8a-08dc4e4c264a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O9EaIvY4Ql7nyFqk7AZq0oU5TO+CgDrgeYobfWuM8vXGWjqIEHtp7QvDr5d92WSdsIqZN4u3CK7pZsfKabooYUClBi8yYlOfQczeX9rg2QZLfdAHUZ04foDpdnWkhwKftA6Rc/a1XW/AGIqjHt3ZRj7MHaj8grUfgY7KMvbI9CMF69L78ia0url6aaK/rw2JOGKrnNIbfFArlV6p7vJpCNFFNW5tQ8fHOJOv7XnWc9WYU+QBxRi8cupfbVeINd4YKDALCnpWHzjTopMlY6OgGRCFTf+SbH6DAHJIF3dQPq/QhIJ0a934dlxbTRh1+hN8uLaERMENmeA6wRmEc0nCpycV3+hm/uqicyFQNVxBFEDMJolqgpiqNv8CoUM/TdKYGy8qXyTqw4WVZM0gLNMn16cULXF8NU57NPvk0HJ+6rzm4xf4YEuj4nzPjzG1GYxh4/Vo2zGPKxtgdT5sT1Z9Y8zUSBILa8DjhH0XFK5tLgfYTwk8k9t648zd9uT8T1qCCaZcUcMPON7mBENHRdnMhmfPfBWSLdETUf911PUqeu3/LpKkfkXDfWEjlvLaStHQhOM9PAJdKCUdP9bYSGGFVCNbJgzuAVj732zt2ezjSsU2+aYJZEknGT5YJFj/B+O5dvKs724rDHzPMZ4zk2LbEDImvPAJGDwdZZdXw+z5GK1hPuHevl1dFFLuXeQno3o/Frj/ssSiEX8IrXjfNVfYEfhcJ1qeDkgmRQnebrTC0zs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bG5RYnNNSUFGUWNwMVZGcUNQUTRWZC9SZWNrUzNKWUg4MTdTL0ZZdk03aU5Y?=
 =?utf-8?B?Qkx1SUY2RkozTlVnRlJHRTlBeGhlRlFoMjExL1c1ZXcxWCtaR29xNHk0c2k5?=
 =?utf-8?B?WWtvSUhjaExDRXh3Z24xZHB6SCtrTzByMG9sWk5iT01uYjNDMGhsaHVSZnlx?=
 =?utf-8?B?UkVLZTkzb1JSSTBGcHlvbWNxRFhLN2l5cmZjMUI1SEc5U3VBMDg5bER6ajFI?=
 =?utf-8?B?bk1HODcvUk5RcUIzVk02QVN0NFlLckt0SnVuMmU0TWsrMjFrd1lTa1h6SlFk?=
 =?utf-8?B?ZFB5VTRXZ3prSEZjTUJCVTUxaFJBLzlRMit0eFZwZS9tZHlGK056Z21lb3NT?=
 =?utf-8?B?NE9PeUh2SFM1QnlaOTRKTCtyZ2ZVcnRFc1ovSGRoM3YvOUZWZk1BQXMrRUFv?=
 =?utf-8?B?WDFzT2VUcHVsaW82V2VqZHgvZ0RLRGJrcXZLWVJSQ1dMQTFhT0VId1l0ckh0?=
 =?utf-8?B?VlVnSGJGL2hDcGgrL0M5QWJ0OW5kV2Y2YnBLbHE2ekFyK01KTThhNjMxRGti?=
 =?utf-8?B?QVRjSFBkM2Q3R0JoSlpSdnFidDBVYUNFMlJ3NHZGYUwrWVpSdkRHVEpKdm5y?=
 =?utf-8?B?QzlvQ0dDN001T1lPeFphNUx1U0QwaTVSWTRnUE9kZDFET1lWRThURmZ5QlRF?=
 =?utf-8?B?clQ5MmxwQVVOd0h5ZEFaemVWUmxsRjU3U0hGQU1nMC9TenhEUTg2eWYxQWZY?=
 =?utf-8?B?d1M4ZU83UFlIazRRR3dFUmxlYlVsdkF0U2RsS1NpOFNiTEFpTitySWE3RGxL?=
 =?utf-8?B?dll3R3ZSN1UxaVFlU3FNa3FKalc2Q2dhTVlDdCtDY0tQN3dkNGZUaGw5cGFu?=
 =?utf-8?B?SHFrQnF6bjhWSEZQTUp5R3gzbjA4WjZ5MWZYNnBzM2hwZVdCMXlkUFFuQy95?=
 =?utf-8?B?WkpWYWdGR1hVTU53SXU3UW9UUWtFd0k5YnhtbEhnQ21uZmZabjk4MnF1RmNU?=
 =?utf-8?B?QmdUTld0K3F1RHlnSVpGQ3BubC8wb1ZIZEtIZG4waHlFdkVWN2VjUm14Zkxr?=
 =?utf-8?B?TVh5RFVLWVFLdlFVQW5IekFhWWYwb3hBaElLckwzckRGVit2K1NJMjlaek5i?=
 =?utf-8?B?VGF2VU9pTEZ2U0ltUGM3amI1Z1pzRGd6RlJFd3RhejNHejhCNGIzSzFKU2w0?=
 =?utf-8?B?SGQ4TThNUG90Q0t3c1p6ZFlXZTd1RkpSMDliUUNKQ1BFcWo1dFhNU0dySVpm?=
 =?utf-8?B?R25vM253NXdtaUFDa3ZvWVdyVW5kMERHaE13dm5kcXhOZEdJU2tNbXkrQmN5?=
 =?utf-8?B?WXkzUTJpTXdLUHcydnFKN3B2ME1RejRCc3I1cnJpbyszVXNFYVVUR2JiR2Nv?=
 =?utf-8?B?RGNTaEI3bGU5ampwNjZ4d3hsN3BWaUtZWnhGdVU4YS9BYjBwVXk2M1BXd2ph?=
 =?utf-8?B?eWVRbkpQeVFUaUlFc0V6ZllKZURvdERub2ljR2QyQXNFOEowbzRqRERCL05U?=
 =?utf-8?B?bXFMMzh1NzBUVmk1ZW9RTWQ0Nm5OR2praEhaOWVqVk43aXV6VjZQaTVmaUo3?=
 =?utf-8?B?NWNFcTgrdUVmZXordWVRTDNReE1zMVJZc3N0Q3hOb0sxdElQdDRWemQwa2hr?=
 =?utf-8?B?M0lMQmhmck9leklDa0JBSUVsck03ZitjQU1xUi9JYXYxR0xmNTdKenBtMkJH?=
 =?utf-8?B?NjR4Z3lHYWJyNkhvZmVtZ3dXSW4zZzd0VW1maFpFNEQ5WUZscWthT3VmUFg3?=
 =?utf-8?B?V2VxS25CSG9LSUd2WXRIT3dndWF5dWxCQ3pua1o1ZVFpbTBRTVdQT01RcDRl?=
 =?utf-8?B?cE5FUENIeU83M2ZFeEtyRmRLaEc0S2xiMU4ydUl5dWt3TWJ6VjQ2OUxVMktt?=
 =?utf-8?B?cGNOeS9yMDZVcUx2MHczcTV3M1pTaHNEZUF4ZytuMlBhR2lUV2V3VXZmaHNF?=
 =?utf-8?B?SW5jQWJEcFB2dWMwaXdqbjN3YzdhelVjQ1h5aUY2MnJEcHhUK3F6VVJpSkpP?=
 =?utf-8?B?VDBDUkNpRXdiT2NZY05jaUVhNzFOelBlNTlnREE0VWN1T0p0WTA4VDJoTGhM?=
 =?utf-8?B?MGZEQ3cyUjFnYnZaM3lKeU92alBWZDY4WFlqeHprVk5TR25qVGxLa2lIOUtN?=
 =?utf-8?B?YnFqaXhLL2gzbVc2UElxdE1ZL1ZOT3NJaytYSnYzQUp5Sldxby9OZXg1cjZ0?=
 =?utf-8?B?NExNRXdobGlpVzBSRm1nYzNRUlBYVDFrak5DNlNXRzJZaFRFdElSQlVwVnlD?=
 =?utf-8?B?Ymc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BC820AD6D0EEA49B1CF52A7F451D539@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd72d447-a4ef-4a28-2e8a-08dc4e4c264a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2024 10:53:34.6306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TdlkFJ4iYnw8ylPm93nX8iyR2MwYN9vIaTkPrikK5I7ueEoBoalgzA7Q5y2JnsyjfIq1dqifjilzp4bcp0tSug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7935
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE3OjI3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGcm9tOiBYaW4gTGkgPHhpbjMubGlAaW50ZWwuY29tPg0KPiANCj4gVXNlIG1hY3Jv
cyBpbiB2bXhfcmVzdG9yZV92bXhfYmFzaWMoKSBpbnN0ZWFkIG9mIG9wZW4gY29kaW5nIGV2ZXJ5
dGhpbmcNCj4gdXNpbmcgQklUX1VMTCgpIGFuZCBHRU5NQVNLX1VMTCgpLiAgT3Bwb3J0dW5pc3Rp
Y2FsbHkgc3BsaXQgZmVhdHVyZSBiaXRzDQo+IGFuZCByZXNlcnZlZCBiaXRzIGludG8gc2VwYXJh
dGUgdmFyaWFibGVzLCBhbmQgYWRkIGEgY29tbWVudCBleHBsYWluaW5nDQo+IHRoZSBzdWJzZXQg
bG9naWMgKGl0J3Mgbm90IGltbWVkaWF0ZWx5IG9idmlvdXMgdGhhdCB0aGUgc2V0IG9mIGZlYXR1
cmUNCj4gYml0cyBpcyBOT1QgdGhlIHNldCBvZiBfc3VwcG9ydGVkXyBmZWF0dXJlIGJpdHMpLg0K
PiANCj4gQ2M6IFNoYW4gS2FuZyA8c2hhbi5rYW5nQGludGVsLmNvbT4NCj4gQ2M6IEthaSBIdWFu
ZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWGluIExpIDx4aW4zLmxp
QGludGVsLmNvbT4NCj4gW3NlYW46IHNwbGl0IHRvIHNlcGFyYXRlIHBhdGNoLCB3cml0ZSBjaGFu
Z2Vsb2csIGRyb3AgI2RlZmluZXNdDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJz
b24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiANCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCg==

