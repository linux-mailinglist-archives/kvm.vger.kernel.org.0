Return-Path: <kvm+bounces-26106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADE51971495
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 11:59:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64F90282E95
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 09:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EBD81B3B15;
	Mon,  9 Sep 2024 09:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AZThxNyz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0082B175D21;
	Mon,  9 Sep 2024 09:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725875969; cv=fail; b=N0t7ULCdkC0CpNwPAq29Cx7IEM4jPJA4r/nXX+Zn5hFegkM2BJnmLgM806J7av6srmS9fJQWgWPRiExYE1WcN+DaWPTmAzls7IMkoyJAlKHZBkUBmGJOlvxO4PdLpECa+GuRVXiA+oggfWlY/YAFHCVpOHvVPu4OxscGpfgAPBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725875969; c=relaxed/simple;
	bh=OrjEySjyVub/7DBmvisJfzkbA6c4Sa3RRMprP6Y0SN4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K8f6bzZbz5x77zyOPpMsS6nomg0DWrUP0+9IJ5D2kAXsIX0YTIBO75VNiYyuV9o0a9xroTzM2wnwFZhEhcDPoEtO9Iy39jI05aQ/KyTgSlZQNkARUt6sBHIYGJ/itefCVo9K2gPS3pQg73EhOgeb9JcmRM5xUS9AeavaxIItNH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AZThxNyz; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725875968; x=1757411968;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OrjEySjyVub/7DBmvisJfzkbA6c4Sa3RRMprP6Y0SN4=;
  b=AZThxNyzzPkGKOg6AQsHZCuLghXNGD0gCRnOdke/q02SqjlxI7xXQrkI
   p/1zS+lG3xm0i6WuzdIFsM9M7jXsos2s9xQG7NO/u9EjIGYsFB++lkPAZ
   uLPIO4tjW5hwRIZ3xL9UxTqAq5CSrQF26QbrNEq4vQXzSDo66IVoKcGjq
   GzqBpJEv0gasSMVTIVBG9mbX8ynnTSJWfgl/kPJ8r3MXRkxpiS6rbHxSn
   KQ8kgPWzZKcKBYNwyjGnVgYEWvcT7G72iwSG3LkJ7enRiZJFRmgKg7zWx
   yK7XW05brLjTziH1ezjy8+3dKtCyTUL1w8T3MWfFFOEBECJGWYYVt43Dr
   A==;
X-CSE-ConnectionGUID: SsOCtK/nQTGzGj5aZWN+5g==
X-CSE-MsgGUID: 6bw/XwtcTHizzH+YH1WygQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="13436740"
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="13436740"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 02:59:27 -0700
X-CSE-ConnectionGUID: sv9orps0QDKOMQMqyQgpWw==
X-CSE-MsgGUID: thO5K0H5SUSAmXa/dyBMmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="66925951"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 02:59:26 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 02:59:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 02:59:26 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 02:59:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=txnAS0+lsN+agbHsIclocKYASFnidMIlNdwC5MCu196JPTIprkwG3DfK5hNjpAw2jtBlbev5uTNXOW7tylby3dIwyPQnXWrKYYy/PEexvJnc7uaa3kqDSrXbe8LCm28wHNb1caLm6ITsFY8Li6GFCreXwWiRZpWJ5C3FS4QfUYNPox8bFkTtXfzVMMzIzUbFINO/Gg7nomeMsjkbWO3MyY3DQn7Hc2lSxE5RCLQHH4RGaeO8umLu40JM05SkdB2+FDuUjU0A0OBNb0iXT225jGV3e/S4J5heAVDml3/L3qRnnX5VkBs3xiVgV/mrdLvmsUdlwvlHSQbNz1qoIahfbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OrjEySjyVub/7DBmvisJfzkbA6c4Sa3RRMprP6Y0SN4=;
 b=N4xnAttZKNiDErqJ1HrCedklS9eFcRQXKyFd53JMFamdOBAH+IX6Y9m7JMEbWP/Gkhb6/XeuGEfRXW1YVhoV9euZrNjDb/b8StMlUrahjF/zk138nETPXnFWM86yeknKKJB+Z/03uu9jyEDzbMoPHBPVeqIC/4BjaVy5VqbUBtGFaaQhbc3OOuCHYwukBpagbRz+bw6Z6kHGcNI5pfqxrhkyhrCJ93W/R/Uz8rENJG8UlwoVo1Sq7u+kB/bWnVUhUf/j3LM7WTU2FJic+3Wqap5DzbEYhZlSlgSNqdR4RneT+FTk7VyxkxNxqE07KXJUs8iLeFW6khf23m9Oqq8Tng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN0PR11MB6205.namprd11.prod.outlook.com (2603:10b6:208:3c7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Mon, 9 Sep
 2024 09:59:16 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 09:59:16 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 2/8] x86/virt/tdx: Remove 'struct field_mapping' and
 implement TD_SYSINFO_MAP() macro
Thread-Topic: [PATCH v3 2/8] x86/virt/tdx: Remove 'struct field_mapping' and
 implement TD_SYSINFO_MAP() macro
Thread-Index: AQHa+E/0m/jBQj198EGqOMKWFia1grJLRDeAgAQJAYA=
Date: Mon, 9 Sep 2024 09:59:16 +0000
Message-ID: <2921b03e0e0f3d0e03b8cc705f0953a67da37526.camel@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
	 <9eb6b2e3577be66ea2f711e37141ca021bf0159b.1724741926.git.kai.huang@intel.com>
	 <66db6465cd956_22a22943d@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66db6465cd956_22a22943d@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN0PR11MB6205:EE_
x-ms-office365-filtering-correlation-id: 3080d6d2-7c8a-4bf5-86b9-08dcd0b610be
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eGVWZzFsQmVyNUtESjd3cjNsbzBhNkg2UU05cWtBZGR3RldRK0x0RUUzTThV?=
 =?utf-8?B?SGRlZk15T0ozUDVvcHFCL210Mlh1QWJvU0F1L1U0UWZCY3VMVXZ2VFk3c3VZ?=
 =?utf-8?B?TkltdzZja28xYW1OSDc1eFRLWkVrQXFIWXFIS2hnc0tRNGkyd2c5VWVuTnFa?=
 =?utf-8?B?Q0NSRVRENVBZQSt6ZXd2TUJrMVlMeE5RVVo3Y3BBRHFWNWxHdFNrSUhCYVhi?=
 =?utf-8?B?RzRuSCs3Z1dneE1UTFNjNDFCeXo1RnRiVUdIT2pvMVQ3NmUvbjNRVkM3c2FJ?=
 =?utf-8?B?akkzbUZZYXVCN1Z2MWpHZjB4bWxOMWdNRUozaGZjRFhua0NaN2U1Y2JuL0k1?=
 =?utf-8?B?cmhzaEhQSjRwWE9qSTZwbXlta3BMZkJGRE5CZXdWblJ1Y3pwd0hMK0J3L3dv?=
 =?utf-8?B?d2N0WlViRThoMUdWOVpmVFIzQys2bVJScGtFZk82anBoUm9BUnVrNUhaYmE0?=
 =?utf-8?B?cFNSVXREOS9McUk5QzF4UXd5SWxHWnZmY1FVUkZWMFNOZndUNlZjVWxkMnBS?=
 =?utf-8?B?SWlHWlByWFpHVjN0SjczZUU2L2JONEJjcCs0VTZNaUFrVllHMEhMNUpVSk1u?=
 =?utf-8?B?THcvM1lBRDdYd2NaS0pPWFlWMnA5Y0RuR3ZtL1Q3dGF1WHhzR3gyVllLdlll?=
 =?utf-8?B?RmdRRk1NcXJNeWE5QzVlVzZJYWFGT1lURmE0cCtKWFY5bkRtZ2NUbmxac0tZ?=
 =?utf-8?B?WjhyWDBLOCtGU3RKUk01N2owQTMrS0o2L212RHBqaWg3OFkycHRSd3RxVlR2?=
 =?utf-8?B?aDZES0ZuVGU5VjdhcVlRK1orYU8vbGZSa2luOVRLaHMwNlR4L2FRb0lhRTYz?=
 =?utf-8?B?aTdHNE4rT1RoY282NG1EcFY1aHVENnFjRCtJa1hobEVmMTlwNTNYakN3Wnd5?=
 =?utf-8?B?dnk3MDNWT0ovZlJXSzZUYzdxT2ZickV3V1hkYnVJQjFUNHVmeUV5Q1VhQ3U5?=
 =?utf-8?B?RWdiWHZTZG83RERkUmVHdjk1UDYyci80aUV3cTFKeWdyV3l1QUk3dHk3VGZM?=
 =?utf-8?B?MmZ0SHhTajREdU9vTjNzS1lod3dkNS9IOFFaUHVwTTdHZzRpVXd2SEI0UWdR?=
 =?utf-8?B?eEdIelJ6R1h4cUhKbkM5WHR2bE52TC9xZFdDUURINTc4YkowVUZ6NFRsenp5?=
 =?utf-8?B?NDRxQXMyTnlERm1IOU5mVWRnc1hQTFU0MkR1MG1BclJMSno2NHB6aFNiREp5?=
 =?utf-8?B?OXZwckNWY2JXdHNiYXhsd3FzMUJWeXI4UGFzWTJCNHF6bW1FU2dOcm5QUVRm?=
 =?utf-8?B?Smxid2tVRGo4QjN4OTFndjQveU5TVEhkS3V6NW5jeWhwdEhVMFNNS2ZLS3JH?=
 =?utf-8?B?ZEJzRjY4L3ZIZGRiUFFIYU9tT2t6MlB1a3Jyc0I3blh5a2dyQlJiQ0JmenM3?=
 =?utf-8?B?V0c1bW1xd3dlOEd3Y1NFYnJqa014ZVpxbDlPWmVzZ2xOa2xoR2xTbmtjbWJv?=
 =?utf-8?B?cFhhRWNEODBLQ1BkaGx5UEJ6YTNndFhTWjFWWDMzcHNPYUJodytHMHBRa1ZZ?=
 =?utf-8?B?clFJVVJDdVJnVXFmS2dmTkxIQ3cveWVndldKOTlyVkhBcFBtLzUxUE1pK2Rm?=
 =?utf-8?B?RlZmblV4d1plelJ1NzlRRTVyV0tzMUpXM1ovQzI2c1UrT0FyaEliUktLdXlX?=
 =?utf-8?B?R1pQQjFJNFlJTkE2OHdmL1MrL0owc0pDaUpMZWZsd29JdlpsMEVHUWlDY0VF?=
 =?utf-8?B?SkNCbVg2WVpzcll1NG5lb1pnT0dEelUvdWhheVpaQVI3UHdoMVhyaVljQVZv?=
 =?utf-8?B?ME1td1VaR2x5azhmQXQ3ZDhYUGpMeEZBbzYxdVhnaHlaVVF4eW1UQmxrdm9i?=
 =?utf-8?B?TDZKWFJBM0VHNlFkdzluQnN0cTZqcCs0c1gzRE9vVGppWDZPL2NsVUg5SW53?=
 =?utf-8?B?VmM5N2VsemU3Nm1OMUwzTUtFNVNNVFJ3WTZoeG5KY2ZLelVuS2twNFJkdlhy?=
 =?utf-8?Q?mxJ7e9u3oCExvH6+s9fYnZfpnhB8+Guo?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXA1VFpkWWZSOStRaCtUVGxxTDgybHczVkNhekNzTmhLdFI2Y2Q1dlFESER5?=
 =?utf-8?B?bXNxd0VCOXI1WVY0N0dySnJ0MjVKT2ZuTE84RU93OS96Tm5ZNVA5U3RMZXNl?=
 =?utf-8?B?M2djY2xjR2JXUHZkSU1GeENZc0dYZ1RqaGs1TCtNeE81QW9KR2cyc0Z6Sk55?=
 =?utf-8?B?N3JITWtXc2tJSWJYOG01bXNQRGk3L0tESG1hajF4RXJVRHJPOVppVkljdnhP?=
 =?utf-8?B?Kzg3cEs0Zmw1RUV6cDU4RTlTbDZnZmhnQ0RUWHRFRlRYYzcrK3dSTTNhbDU1?=
 =?utf-8?B?OG8zdVN6ZTNtZXZUdHFiUm5Mc2tXdEFISjJsTTJsS29rT05yY1NZMzFqVlA3?=
 =?utf-8?B?ZjFJbWNnaHJTbmJJTWRVTzU2dVVjVFNZSE91TU9UQnBxcUR0TEZvdzNpY1lH?=
 =?utf-8?B?eG91Z3NMYzJ6YmRJamlKTUFUOTZwcytlcmtrNWtDSzVaUDlEUkhGZDNLcGda?=
 =?utf-8?B?YmlWaURueE1jeHBVdXJRdTJpK3lNWHdMUXFlTExTWEQyVXQ0bHhXVXRqdnMx?=
 =?utf-8?B?VTAyRDJ1Q3F2TWhJRUhmZU5xVUt2aTdvbjA2dFhWbGhVVGZqMFY5K2ZacjdD?=
 =?utf-8?B?NWlWOWdLRUk2MlhaRXBFQTJLWTZzODNHUStERW8rVlUxczluTnlBNEFEN1lV?=
 =?utf-8?B?VFltNjBDVzMxQVhRVVpiQWhlMEszZFFwR0xqUXN0TnpkSE8wblc4eEM1YVd2?=
 =?utf-8?B?dmIwQytpSTNUOS9qRmpJay95a0FseGFCUDJPQXY0cjAvMHBreEg1SENCVThh?=
 =?utf-8?B?Q0lMTE9JUjN3Vys2SHVsZElGd1BJQktvK0Q5YXhDRFMyZm5zSDNueTZHaFkw?=
 =?utf-8?B?Mm9iNmFKVmJSNzZwOENEenlXNTNaTWQ4LzV0TEJmTGJ6N1NtVng2QlhQQ2lW?=
 =?utf-8?B?ZVIxeDUwY010RmtJbEZTVm8zdUxoQXQvQm5EaWZkeThTYXdDUC93RzVSS3lQ?=
 =?utf-8?B?eC8rblZjUVVrd0RaajhqOG9IVW1kOXFNcWppeWEzRnhiQUc1N2ZsWHN5MHMx?=
 =?utf-8?B?TldwTFczQW53YUVyeXVBd2taNlp4SWVhNkZtMjBTbWVvTlVLS2d4TGw3VERv?=
 =?utf-8?B?cU1rZ3pVRkZrUEFzRE1VQkswQmVvM01GRmhpdU9hRlRWU2c0dmNvRFdCa1E1?=
 =?utf-8?B?TEJyTzNpbFNwUFRlMCtrSUNnQWVBNVRHc3I0QWhnMlR3YkU2c0g4eUVlYUJu?=
 =?utf-8?B?dmhKNFZ5N3RpT1FBTThSVlNDeW5wQUUyL2hKVjJOVWhIVitFeDlKN3RXV2U5?=
 =?utf-8?B?Mmt1TTNsdnJiUlJTNnBJMkErbU9rUlJVZnRRYlNTSHh3RTN6emxvQmJJN2J4?=
 =?utf-8?B?blIya2crM2VyM2VPTDFScXNZWFE1N1JXUk4xWDhyM2ppc2ZqVVFVZHBSejRV?=
 =?utf-8?B?eVhqRzVpNTNRZXQyWUluanVaS2cvYWdCYzBLMmtTT3BFM1R5cEtKT1NweFlN?=
 =?utf-8?B?Y2F5S0Z6VFRYN3V4VTFuUUtlNDRvOVB3TGltZ2tGRDB3eDFkVWN6eXgrMStl?=
 =?utf-8?B?cHRJYnVndmpOOG5ENTMweU9NMkFURXQyWGZaOFlLWnkwYWpVUnh5TXc2dy9r?=
 =?utf-8?B?dERYUThLa0hZSHIxb0NES29TQzQxRHE0dlF1aG1xTjdoU09DdERqQXk1L2Y1?=
 =?utf-8?B?LzRvazBZaFc5S2RWb2NxK3RsVHZqSlMwWCttTnIzUURjVm1SbW1ZWkpZK2U2?=
 =?utf-8?B?WlBLUUo0NThFbE1ncXY2WjgvbWpNNW9YR1ZscVBNcFFOc0Q4NGxRajZxMjJO?=
 =?utf-8?B?YW9hQzZNb0tCR29TNDdWOU0rL0VxWnNYeXdMY1JWQVZWMlJ0VWY4WjNTRndo?=
 =?utf-8?B?T1VYRzdqWDlCYjFheGZaVXBBcURLMUVCVGUyWldFUCtjTmxHUVBjY0FpN3U3?=
 =?utf-8?B?UE03SW1qSHdCUHBCS2pRRVExeEtHZkV2dFowM001MUdpWloyWllPRk1zMVgr?=
 =?utf-8?B?dnZmcEdVZFAwU3lBbjA3cHZiZGpEb2p6Y0ZNQk5qc3RaMVd6dDZMQUR2MzZ3?=
 =?utf-8?B?UnF4aHpHYlF3NGlEMktrSkplWFk0TlFwOUdLa0xhVzZZRWR0bVJmQVpJMDJQ?=
 =?utf-8?B?QmdwalFuRGxGdXdmMDVkbGlZOS84ZncrbW8zUURqZU15MnQyNU1xenBWcjB3?=
 =?utf-8?Q?07svhT0jffFbO5luhC52DO5XL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A1F57FCE12F06469C18BCF97D899175@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3080d6d2-7c8a-4bf5-86b9-08dcd0b610be
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 09:59:16.3250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z1jJtAFknbwM0pVRfPXe3dBZ7N2RdHrHpFZ1mQGWLbf2oxN7YgL+b7tH8fALsfIKTmyYcOYhv30XJvK4B8hYLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6205
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA5LTA2IGF0IDEzOjIxIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEkgdGhpbmsgdGhlIHN1YmplY3QgYnVyaWVzIHRoZSBsZWFkIG9uIHdoYXQgdGhpcyBwYXRjaCBk
b2VzIHdoaWNoIGlzDQo+IG1vcmUgbGlrZToNCj4gDQo+IHg4Ni92aXJ0L3RkeDogUmV3b3JrIFRE
X1NZU0lORk9fTUFQIHRvIHN1cHBvcnQgYnVpbGQtdGltZSB2ZXJpZmljYXRpb24NCg0KWWVzIHRo
aXMgbG9va3MgYmV0dGVyLiAgVGhhbmtzLg0KDQo+IA0KPiBLYWkgSHVhbmcgd3JvdGU6DQo+ID4g
VEw7RFI6IFJlbW92ZSB0aGUgJ3N0cnVjdCBmaWVsZF9tYXBwaW5nJyBzdHJ1Y3R1cmUgYW5kIHVz
ZSBhbm90aGVyIHdheQ0KPiANCj4gSSB3b3VsZCBkcm9wIHRoZSBUTDtEUjogYW5kIGp1c3QgbWFr
ZSB0aGUgY2hhbmdlbG9nIG1vcmUgY29uY2lzZSwNCj4gYmVjYXVzZSBhcyBpdCBzdGFuZHMgbm93
IGl0IHJlcXVpcmVzIHRoZSByZWFkZXIgdG8gZnVsbHkgYXBwcmVjaWF0ZSB0aGUNCj4gZGlyZWN0
aW9uIG9mIHRoZSB2MSBhcHByb2FjaCB3aGljaCB0aGlzIG5ldyBwcm9wb3NhbCBhYmFuZG9uczoN
Cj4gDQo+IFNvbWV0aGluZyBsaWtlOg0KPiANCj4gICAgIERhbiBub3RpY2VkIFsxXSB0aGF0IHJl
YWRfc3lzX21ldGFkYXRhX2ZpZWxkMTYoKSBoYXMgYSBydW50aW1lIHdhcm5pbmcNCj4gICAgIHRv
IHZhbGlkYXRlIHRoYXQgdGhlIG1ldGFkYXRhIGZpZWxkIHNpemUgbWF0Y2hlcyB0aGUgcGFzc2Vk
IGluIGJ1ZmZlcg0KPiAgICAgc2l6ZS4gSW4gdHVybnMgb3V0IHRoYXQgYWxsIHRoZSBpbmZvcm1h
dGlvbiB0byBwZXJmb3JtIHRoYXQgdmFsaWRhdGlvbg0KPiAgICAgaXMgYXZhaWxhYmxlIGF0IGJ1
aWxkIHRpbWUuIFJld29yayBURF9TWVNJTkZPX01BUCgpIHRvIHN0b3AgcHJvdmlkaW5nDQo+ICAg
ICBydW50aW1lIGRhdGEgdG8gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQxNigpIGFuZCBpbnN0ZWFk
IGp1c3QgcGFzcyB0eXBlZA0KPiAgICAgZmllbGRzIHRvIHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxk
MTYoKSBhbmQgbGV0IHRoZSBjb21waWxlciBjYXRjaCBhbnkNCj4gICAgIG1pc21hdGNoZXMuDQo+
ICAgICANCj4gICAgIFRoZSBuZXcgVERfU1lTSU5GT19NQVAoKSBoYXMgYSBjb3VwbGUgcXVpcmtz
IGZvciByZWFkYWJpbGl0eS4gIEl0DQo+ICAgICByZXF1aXJlcyB0aGUgZnVuY3Rpb24gdGhhdCB1
c2VzIGl0IHRvIGRlZmluZSBhIGxvY2FsIHZhcmlhYmxlIEByZXQgdG8NCj4gICAgIGNhcnJ5IHRo
ZSBlcnJvciBjb2RlIGFuZCBzZXQgdGhlIGluaXRpYWwgdmFsdWUgdG8gMC4gIEl0IGFsc28gaGFy
ZC1jb2Rlcw0KPiAgICAgdGhlIHZhcmlhYmxlIG5hbWUgb2YgdGhlIHN0cnVjdHVyZSBwb2ludGVy
IHVzZWQgaW4gdGhlIGZ1bmN0aW9uLCBidXQgaXQNCj4gICAgIGlzIGxlc3MgY29kZSwgYnVpbGQt
dGltZSB2ZXJmaWFibGUsIGFuZCB0aGUgc2FtZSByZWFkYWJpbGl0eSBhcyB0aGUNCj4gICAgIGZv
cm1lciAnc3RydWN0IGZpZWxkX21hcHBpbmcnIGFwcHJvYWNoLg0KPiAgICAgDQo+ICAgICBMaW5r
OiBodHRwOi8vbG9yZS5rZXJuZWwub3JnLzY2YjE2MTIxYzQ4ZjRfNGZjNzI5NDI0QGR3aWxsaWEy
LXhmaC5qZi5pbnRlbC5jb20ubm90bXVjaCBbMV0NCg0KVGhhbmtzLiAgV2lsbCBkby4NCg0KQnR3
LCBBZHJpYW4gc3VnZ2VzdGVkIHRvIHJlbmFtZSBURF9TWVNJTkZPX01BUCgpIHRvIFJFQURfU1lT
X0lORk8oKSwgd2hpY2ggaXMNCnJlYXNvbmFibGUgdG8gbWUsIHNvIEkgd2lsbCBhbHNvIGFkZCAi
cmVuYW1lIFREX1NZU0lORk9fTUFQKCkgdG8NClJFQURfU1lTX0lORk8oKSIgdG8geW91ciBhYm92
ZSB0ZXh0LiAgUGxlYXNlIGxldCBrbm93IGlmIHlvdSBoYXZlIGFueSBjb21tZW50cy4NCg0KPiAN
Cj4gWy4uXQ0KPiA+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS9hMTA3YjA2Ny04
NjFkLTQzZjQtODZiNS0yOTI3MWNiOTNkYWRAaW50ZWwuY29tL1QvI203Y2ZiM2MxNDYyMTRkOTRi
MjRlOTc4ZWViODcwOGQ5MmMwYjE0YWM2IFsxXQ0KPiANCj4gVGhlIGV4cGVjdGF0aW9uIGZvciBs
b3JlIGxpbmtzIGlzIHRvIGNhcHR1cmUgdGhlIG1lc3NhZ2UtaWQuIE5vdGUgdGhlDQo+IGRpZmZl
cmVuY2VzIHdpdGggdGhlICJMaW5rOiIgZm9ybWF0IGFib3ZlLg0KDQpPaCBJIGRpZCBub3Qga25v
dyB0aGlzLiAgV2hhdCdzIHRoZSBkaWZmZXJlbmNlIGJldHdlZW4gbWVzc2FnZS1pZCBhbmQgYSBu
b3JtYWwNCmxpbmsgdGhhdCBJIGdvdCBieSAiZ29vZ2xlIDxwYXRjaCBuYW1lPiArIG9wZW4gdGhh
dCBsb3JlIGxpbmsiPw0KDQo+IA0KPiA+IHYyIC0+IHYzOg0KPiA+ICAtIFJlbW92ZSAnc3RydWN0
IGZpZWxkX21hcHBpbmcnIGFuZCByZWltcGxlbWVudCBURF9TWVNJTkZPX01BUCgpLg0KPiA+IA0K
PiA+IC0tLQ0KPiA+ICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgfCA1NyArKysrKysrKysr
KysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyMSBpbnNl
cnRpb25zKCspLCAzNiBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYvdmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4g
aW5kZXggZTk3OWJmNDQyOTI5Li43ZTc1YzFiMTA4MzggMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94
ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gKysrIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3Rk
eC5jDQo+ID4gQEAgLTI3MCw2MCArMjcwLDQ1IEBAIHN0YXRpYyBpbnQgcmVhZF9zeXNfbWV0YWRh
dGFfZmllbGQodTY0IGZpZWxkX2lkLCB1NjQgKmRhdGEpDQo+ID4gIAlyZXR1cm4gMDsNCj4gPiAg
fQ0KPiA+ICANCj4gPiAtc3RhdGljIGludCByZWFkX3N5c19tZXRhZGF0YV9maWVsZDE2KHU2NCBm
aWVsZF9pZCwNCj4gPiAtCQkJCSAgICAgaW50IG9mZnNldCwNCj4gPiAtCQkJCSAgICAgc3RydWN0
IHRkeF9zeXNfaW5mb190ZG1yICp0cykNCj4gPiArc3RhdGljIGludCByZWFkX3N5c19tZXRhZGF0
YV9maWVsZDE2KHU2NCBmaWVsZF9pZCwgdTE2ICp2YWwpDQo+ID4gIHsNCj4gPiAtCXUxNiAqdHNf
bWVtYmVyID0gKCh2b2lkICopdHMpICsgb2Zmc2V0Ow0KPiA+ICAJdTY0IHRtcDsNCj4gPiAgCWlu
dCByZXQ7DQo+ID4gIA0KPiA+IC0JaWYgKFdBUk5fT05fT05DRShNRF9GSUVMRF9JRF9FTEVfU0la
RV9DT0RFKGZpZWxkX2lkKSAhPQ0KPiA+IC0JCQlNRF9GSUVMRF9JRF9FTEVfU0laRV8xNkJJVCkp
DQo+ID4gLQkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gKwlCVUlMRF9CVUdfT04oTURfRklFTERfSURf
RUxFX1NJWkVfQ09ERShmaWVsZF9pZCkgIT0NCj4gPiArCQkJTURfRklFTERfSURfRUxFX1NJWkVf
MTZCSVQpOw0KPiANCj4gUGVyaGFwcyBqdXN0IG1vdmUgdGhpcyB0byBURF9TWVNJTkZPX01BUCgp
IGRpcmVjdGx5Pw0KDQpTdXJlIHdpbGwgZG8uICBJdCBnZXRzIG1vdmVkIHRvIFREX1NZU0lORk9f
TUFQKCkgaW4gdGhlIG5leHQgcGF0Y2ggYW55d2F5Lg0KDQo+IA0KPiBTb21ldGhpbmcgbGlrZToN
Cj4gDQo+ICNkZWZpbmUgVERfU1lTSU5GT19NQVAoX2ZpZWxkX2lkLCBfbWVtYmVyLCBfc2l6ZSkJ
CQkJCVwNCj4gCSh7CQkJCQkJCQkJCVwNCj4gCQlCVUlMRF9CVUdfT04oTURfRklFTERfSURfRUxF
X1NJWkVfQ09ERShmaWVsZF9pZCkgIT0JCQlcDQo+IAkJCQlNRF9GSUVMRF9JRF9FTEVfU0laRV8j
I19zaXplIyNCSVQpOwkJCVwNCj4gCQlpZiAoIXJldCkJCQkJCQkJCVwNCj4gCQkJcmV0ID0gcmVh
ZF9zeXNfbWV0YWRhdGFfZmllbGQjI19zaXplKE1EX0ZJRUxEX0lEXyMjX2ZpZWxkX2lkLAlcDQo+
IAkJCQkJJnN5c2luZm9fdGRtci0+X21lbWJlcik7CQkJXA0KPiAJfSkNCg0KV2lsbCBkby4NCg0K
QnR3IHRoaXMgcGF0Y2ggZG9lc24ndCBleHRlbmQgdG8gc3VwcG9ydCBvdGhlciBzaXplcyBidXQg
b25seSAxNi1iaXRzLCBzbyBJJ2xsDQpkZWZlciB0aGUgc3VwcG9ydCBvZiAiX3NpemUiIHRvIHRo
ZSBuZXh0IHBhdGNoLg0K

