Return-Path: <kvm+bounces-71466-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uAAJJT02nGmiBQQAu9opvQ
	(envelope-from <kvm+bounces-71466-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 12:13:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3081417553B
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 12:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A4C4E3037C12
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 11:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B58A3612E0;
	Mon, 23 Feb 2026 11:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hx8cVaF/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560CE35CB7C;
	Mon, 23 Feb 2026 11:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771845171; cv=fail; b=TI0zzsYIOE2BMytFFqk10nFQuPmv4Ru+WiEx7FyE1uUpnQdCttOvyotROhY5D2vyKzuEL48tXOn9q8PyN1paMlpeEbxm3o3viCBxr5TIeq2E8JJ0kT4tN3dfExhXHdFhwlxAA8f2Eak4+6UlLJHfrMM7mBK9KQs43TnD5ntM2KE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771845171; c=relaxed/simple;
	bh=bYYBh4KGbef/uMT8EY5gp5ggJIlcKi4S7VJzjpEPR3Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TGwPDesnSGVZDisOWfMeN3DQ0A+3Z+FHM9bm2xWSoV23WYu3e4dqzxaFL5rzFsUcUl2zaJBU8wxSOzWlV8nMDDeaeZgLDTtVRSjkaN9Wdk1vRduKD6gehofC2cwNi4cR7q7EKGiDjQk1QlFJMZilvOap1xpEPv6zM/IWLY6ioN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hx8cVaF/; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771845169; x=1803381169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bYYBh4KGbef/uMT8EY5gp5ggJIlcKi4S7VJzjpEPR3Q=;
  b=hx8cVaF/1L2qtQi/8Y+XDeBcwtVlWDC8jSJGt5OSCgeGHwslTocXFX2n
   MDSkzTNxE54EBK0XBSr8r+Z/X++p2BqVHrz8KjL9n9aIGVkR0Fgq4s5or
   eVk080EOklsWgR1uYxezp0apZbNsbLjGGsXw5dnF07+8/oZB0OYeaLeb5
   DFJd/qSzvAGG8Tv8zjANtgWbaLxxdSm7qxik/tlT0zLU9PeX/yTmJwv0K
   +d4DpgiYAwoo/zsWw7b5NuakUw0ZqdabMaCj7YyIgF6R5FI0iP7IgijYY
   WDpBJ/wJKjr6bnz9TPHUrJtzWgKLVbe10ULH/OktMkqijoHN7xYcscF8J
   A==;
X-CSE-ConnectionGUID: omhcMxovTambgwm9VlCy8A==
X-CSE-MsgGUID: 60eoAC3GS1eSxunKCIquIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11709"; a="60411389"
X-IronPort-AV: E=Sophos;i="6.21,306,1763452800"; 
   d="scan'208";a="60411389"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 03:12:47 -0800
X-CSE-ConnectionGUID: oN5sl+JdS6eYDVoOSXGRtQ==
X-CSE-MsgGUID: v/ug//dHSzK0TX8C738VIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,306,1763452800"; 
   d="scan'208";a="219645567"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 03:12:47 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 03:12:46 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 03:12:46 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.33) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 03:12:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=araLIz6EG5EmpYkrn2/ZsX5DOBlIJQ0BtLx43C4poFONRZeTtmkipkNqyAPVMFlWLYSFyzCY4+Z6pxqPM4ssGXGXWZ07Fa1dIXeH4lvcuAXWXrC7tnfIcTPD8w1MVAqkU4RNtnryBjF3S/LKo1Hc1/b88zqiwXJW1p+DsKzY7/D/rmltWO+ACIeuGfNuu9pRYtT5bYpJcRmpuo+MKl+CryC8Zqa4tH+TzDtC8jZdrL2fD345dz+xbAfNYvm55eOR824CTorJVP0cfxIUr9rKXUyE2ercN5FLC6dl8ziZBxYo9DTvF78RDEV7OoLSPCso76qLME4vq0lJIrQr6BDBlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYYBh4KGbef/uMT8EY5gp5ggJIlcKi4S7VJzjpEPR3Q=;
 b=Wra8+8qGMwheRh34rRrnKkynmHw96QgxMDyO7shtleBIhJdn4L3la3DSPLqz8YrNa7+GP2sELNt7ZCYP74NlSIpSWelyvrtFTYXLJllEpWeNxGmx+TFfY2O8x3hmHIBrRD0IyWu1EAdTnngt8h+U3GzKPZ7+DRk6LvER3RlNTzKv/cnuP4QSInf2AtXnMyyIAUCsD3OLCWm0bJazAj85KoJe4Hg9MI7bOPheyJRe4Q1kdL63VqUOhtllc+8hswsDRTzipAjvuJVcHrUUOVELHnjkLauexrClROn8MHdcdItx4K2s7ZMI0fLx2fznWCRrZqy0DLcL3w/xc+oRqus+Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 DM3PR11MB8684.namprd11.prod.outlook.com (2603:10b6:0:4a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.21; Mon, 23 Feb 2026 11:12:35 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 11:12:34 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
Thread-Topic: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
Thread-Index: AQHcoTXmp0GPnRCoRk2Vv+i+XQkxSrWQKC+A
Date: Mon, 23 Feb 2026 11:12:34 +0000
Message-ID: <5a826ae2c3549303c205817520623fe3fc4699ec.camel@intel.com>
References: <20260219002241.2908563-1-seanjc@google.com>
In-Reply-To: <20260219002241.2908563-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|DM3PR11MB8684:EE_
x-ms-office365-filtering-correlation-id: f849ca93-9cff-4d8b-80bf-08de72cc7239
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?U3k2aHJFa2lmZ0hwQmNEK3h5YWs5aERtSkNQTjFQNG0ya3pQanJZUkwvWUto?=
 =?utf-8?B?VjBpL1pwRlpQakdHelg4UC9kMFdQbENNbTRXWGxDclB4QXc2alNKNWR5OUJQ?=
 =?utf-8?B?aWlTVTFRY0F3blpkdW5JSVpsU1o0dE9jYWJubTMzK2pwNjRhWFRqRWhKT3o5?=
 =?utf-8?B?NFBHUC8wRWtUVzNWdVBKMXowTU5YdkczSm1ZN1ZhZHdBYkdSbWVKUGo3Z3dL?=
 =?utf-8?B?bS9hRC9OUUpmbEJCeXNYaWZZb1c4VEdaTlFIa2FUWTJzTWtZK3dEcjNnZ3RS?=
 =?utf-8?B?OG9vR3J1NyszMnVGWVNwWUFoVkJKUGk1eHlINE5CZXpZMHJWcFB3dXpiNysw?=
 =?utf-8?B?aTk1RDcxckw1NG85WnFVeERSNGpxdENZd0EzK09ERjNqWVcxTHNyc1FNZXQ0?=
 =?utf-8?B?bVJpSXRJUjNoelU1b3ZzRFEzcUtmSFkwdkd0b0pSSHdlTFMwT0V2WFU2TGN1?=
 =?utf-8?B?QTZpRE9XSUplczdiYkVhM2JYNVoyQ2I2a3J6d3JEbUNKZUhQTXdRWDM3UHpI?=
 =?utf-8?B?VVJWOHVwSTBScUUzVzBJaWpCTTUyWGxhNGlSWVpBRzJGeWlsMTBObWtFNEpk?=
 =?utf-8?B?QitZSjhIZVVON1NlSXo1aUtTejhsbU9kcVovaTJ2SHR6SDBQVWdkTzhxbnp2?=
 =?utf-8?B?VkF4ZTZJREdmc01KbmhvOWIzTStmcWZmQmM3NnRXRXhiU2k1bVMxRGtOTDNk?=
 =?utf-8?B?b2tlSXZTUllaZHJKaDJ3YUVPOWNnTVJYYTBucXZrVFg3MXhyakJKM1p4MVNV?=
 =?utf-8?B?R2piaVNXMHdTblIxREhOaUg3WEFCcmsrK3lTczR3c1dmbHI4U1UyNitXaWp3?=
 =?utf-8?B?YXY2UG9qdk9ITDVxN3BpT281VGpWeEVUUWNhSjVSNmFsR01NZnJsYlI0S3ZO?=
 =?utf-8?B?dXY3Tkgvay9iRjJIOVBNMVo3MDByNXpzTW9ROUVQN1Q3L1Y5bUN1MDRDZkRn?=
 =?utf-8?B?UmV5T1hZS2R4emFleW14UFBRVUxIUm03bWlvK2hIWmFxOTYvN2ZaR0RUL3h4?=
 =?utf-8?B?WDV0TEhBYUFWdmF0NWpIcnNUWWdkQmJrOFhZd2NrLyt0cGh5K2cyNUlsVVRX?=
 =?utf-8?B?L3RiNjBTaFp2cUFTZ2FUU202eUtQcFowQllSTnUzT3A3TFFqVm43V2ZuS20y?=
 =?utf-8?B?MW9VeXU2ZkR0WVowZEV4MDVESUV4U2NVbEs2c1Y3VEFmUXowQktQOVVwKzJC?=
 =?utf-8?B?cmppTU5LRWNMYmZiSUJBOTFBQ1F2d3dHRGh6T1YvcjVTWFhaMmh4Vmp0MWJn?=
 =?utf-8?B?UXhmclNBY04ycWF3N0FQYW4yZDBOQnVVRUVHUFlNRTVaRXNteFgxQmFYRUZD?=
 =?utf-8?B?anlrS2kxZytlUXJ1M2k1WjczWmNBaDFuK04yeDdFQUlDNEZ6WWYxdVZKY05x?=
 =?utf-8?B?UnhTbGpvM1BRdXZuc3UxZXUxcjNzaUxFMGQvSHZTQ0NmbUI1eFhUMDRhaGRD?=
 =?utf-8?B?dTBNTWlzMVJlTUltbE83cGdzSmNLaXFjOEpGSkRlQmJGSlRaNFZlelAzMjNN?=
 =?utf-8?B?dnB4NnRNYkhOUnlGalNVa3dNZTI4WXlYZTh4TVkrR01GczhHajg4L050Y3hM?=
 =?utf-8?B?U2xCSlp1TVlFZ084TngvM1BoQUw3SVd5Wm94TTIyWUgyeXZ2dUhWa25IYlg3?=
 =?utf-8?B?WkRkNWJQYnVMZjM5dlp6dFRPZnpaK2MzZEF3SDJFd25SK1drME9Vb3daNGZz?=
 =?utf-8?B?Ny8vZGxacDRiMzVzN3AyWnBWQmIyaVZLTDN4TEQ4cXpYM0hwZlpmRm9QblJl?=
 =?utf-8?B?Rjc3RUg1cEpNRFl6VlVoYzBGT05KR2RoZ2psSDdTRUJXVUk5cnFUVlpIUWFT?=
 =?utf-8?B?N1RXck9BZDlHd3dEeVdmU2tJLzZwSUlaZ3RQb0pEM24wczBEQk83QWdnQjVU?=
 =?utf-8?B?OVBnNzdrcERJdEYwa3E0LzBKam95Z2NRVHY4bUhpSEZ1UTQyVGRSb2RYQzNR?=
 =?utf-8?B?S1ZRNWZYREV4WmxOK3dMZWpmeEtBMVdLempUR1ZiOU9vNmRQaXk0Z01lbVFV?=
 =?utf-8?B?MjVoS2QyYzI3RHpIN01weEtQcUdQdzNGRGJsdXFIWi9TdlQvSlJ1UzNteGdZ?=
 =?utf-8?B?ZU9PRWJPMmxtcnlBVmdaWEZHNFVPQ2ZOL3V5aFZzTkZpaTJZTDYvR0lMcWNs?=
 =?utf-8?B?elArTC9tajF1RUFMTkZiUXpOdmw3aXJ5WWpuQ3hIalFjV2ZnQnQweHVuZ2RD?=
 =?utf-8?Q?OQysS9tAOjRcWwP5vMum/+k=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHBEemNpZkM2ZlB3ZzhReG1XZSs3d1dWL3h4MzIxTEY4aEpORCs0UnVoczEz?=
 =?utf-8?B?TUVRdXNORER0SUNmdWkzQ2Y2UE8wTHpMQllvSEVnNUl3RVRmWXhDVm1EajFX?=
 =?utf-8?B?MGNiMnRaNng0WTdjb002S0tFM2NGb1R5RVovbDA0ZUxnb3YwbURWZlh6c2Zs?=
 =?utf-8?B?bzNZUlA1S3I0R0hIY2ZUSW9zYlM2UkNMbFJPU2l6T3JrSndtbjJXU0tiM0Vk?=
 =?utf-8?B?RHkrV01xZXZ5VUFXTExFcGhVSndjM1NjVEdodWtyMDRYYWhORm9BV1pDV2Vu?=
 =?utf-8?B?YnNPMy94OTVQTCtQakc1QnpIRVNzTENkb3FLNUplbFUwZDVSWUFDaEF5anBt?=
 =?utf-8?B?ZlNxVEc4UWgybTJKSVk3endwME9ubmtJaFdSZVlwYmNrZG5OU0NrYStmNzlY?=
 =?utf-8?B?cEN3Z3FWdER0SGcrN29ONy96bW1pVXVuVW9lWVpwK3FWSm9IL3VxZXVVRzd4?=
 =?utf-8?B?MlRVZHhBLy90L2xobW1teFphb0Q4bGpKdVFvNXZvWEZpamVPeC9scTdDUmhJ?=
 =?utf-8?B?VmtvNU01M2cvTlVxQno0RGx0Q0thVHRRalNnMkg0WjlPdnNVMmpjZUlUYUZh?=
 =?utf-8?B?QWRHaHlvbDJxNUxuUlJWZHhzb2RJQzNkR1ZvTDBxSUhzV3ZTT2QwK2tJVjcw?=
 =?utf-8?B?bW0zNTVTT212STVybmovaFlDTnZpQWZZYTdCYTJmN2JrY2Q4Q1ZzV2FOMW1P?=
 =?utf-8?B?cjZpSVlGVi9ZV0t6am5vSFBXc2NtUnI5S1BiV0QrTDJWeFd4eFhwQ0IxZjFV?=
 =?utf-8?B?SVlhS01QcytIckFOc3VYRkpQR2hCRmIrQythL2FVMUNMdmhsY0lYOVVrTzky?=
 =?utf-8?B?RmNEcWxKL1UwUjlqZGZXZDFyZUpSRkU3bzZ0RThocjRLWEx6aGJuZmh3TlRZ?=
 =?utf-8?B?VVdCWUNlZUh0WmIwaXF6eEVqcHZqNitYTXQwb3k2TTdwMlZ1VDFmQTI4VmlM?=
 =?utf-8?B?WlNocVRNeGJ4dmc2alJNZy9vdnVKejlxVlk5UDZxSzg5SHhmQnN5ekhWS0pU?=
 =?utf-8?B?Y0pnQ2t3WW5oSzJHSjRFRXdiWnREYktzbWt1QkVqdDVFUnBNR1h1cVhRSGor?=
 =?utf-8?B?NnJydFgwSWF0K3dRcWg4WGxzUTIrK09vRllHRE5PVTZOYzRpWG04d1p5UUtl?=
 =?utf-8?B?N2R4Zm40MWtUZXVNWlNJb0xIVU1kYUJ5emk5RktFa1phZy9CTHdSZDdqYlVF?=
 =?utf-8?B?Y0xHS09yZXBtR0wrcjMyQ0h3ZmJ0cXAvamp5QzFJTUQvUVZkK3dZMGNVc3Vo?=
 =?utf-8?B?SlY4N3NockNSblh3VEg5ZzlOS0F0K0g1UDdialVRSk9Fa3NBaGtSZDk4d0FE?=
 =?utf-8?B?b2pmZFAzeXlTOUtzZy9XN2FlZnhXb01VUzJ5NkdraGtXOWl1L256MzZhSVZ5?=
 =?utf-8?B?K0Z0LzZNQ3pJM3RHQ2h2YjV3S1k5bEtEdU05QndZakJPWDBLMFFLSnNNd2tT?=
 =?utf-8?B?MVVPUSsyZ1k1eHJPemFHZERpUkhTNHJ5UjhTQ2ZNYnBIdlZKL1FJcnBPczgv?=
 =?utf-8?B?MjVHMGpmbGtlaHR1N1pmY0ZmSTJLT2hraGRldEw2UHJkOU0wejY1cGdmSjF0?=
 =?utf-8?B?blZkc2hOT09LMG1mTGYzYjcxTnZVWFo2VS9xVXVTZjgrY1FzNXdlZWFoZW9P?=
 =?utf-8?B?T0VjZnU4amovREhzSnR2U2lpL3ZESWZsSjNWZHFSZERMaFJmL1lSUXlrcTVa?=
 =?utf-8?B?Y01sV2FhT0FaZW96SGY2Z2UvamlsaHJOMjZjcU4xMlNMSDJabCtNaUJ0alJT?=
 =?utf-8?B?OXNPM2wwWFdxeGtKU0VpRFFqTHVDeTR2UFUvZEFFeVlzaW1TS21uM01PamJP?=
 =?utf-8?B?Sy90TTl2dlNHZFZ5UmlXZ0JSMVJKWFBqd1BYQWQycmFTdzREeDdrRVk4c0Zj?=
 =?utf-8?B?OVBFb2QyU3ZxeFc1b1JnUER0M1c2Znh3aS9GUnVxRll5YXk0bUMwKzE5NjRt?=
 =?utf-8?B?eDhqSTEyam5KNXRrcmMvRHB2ZEtiQUtZS2hFK09hOFhycjRNQjJYdllaWE90?=
 =?utf-8?B?SGJxTTBKUjJDbnp0ckVWTDhqeVp2YitHTzA1NWlDaFNmRnNEYmRFUWtBeVRt?=
 =?utf-8?B?UFFJeXQ1MTAyYnAyNFlLdzBPSFNSL1JMYWZUbDlIZmtna3lhckdNVzFrU0VL?=
 =?utf-8?B?QmJuQ2dnVzBsQzJBb1BydXFMWmV1S0xKVFRIdW9rUnhibjRXeFhiUG1Xc004?=
 =?utf-8?B?ZkQ3SDFRby9WNmVWaTQ2eTVTejR6SmVSa0FYak9HRFhOUFFMZXo5ZU9wN3Rh?=
 =?utf-8?B?K2wzQklqTzNuWWFpUGg5bENnNlI1RFFHcHJscm4rZlBJUldQQmxram1lUlE2?=
 =?utf-8?B?V1pRMWF4cHNob1piUTAwL1FUV3NkU1VPUjhoUFdJaUxqZUxldnc2dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3166133A025DFE4A8313C45F043C2225@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f849ca93-9cff-4d8b-80bf-08de72cc7239
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2026 11:12:34.7265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qu5lT0xv5u7hdKtYKnUm2SaH0lulj79+HwYGWUzgRpjV/VaOiT433JPe+ineZCqQ1XHBXMamiftMMqZIi+5Ftg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8684
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71466-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 3081417553B
X-Rspamd-Action: no action

DQo+IEBAIC0zNTQwLDYgKzM1NDAsMTQgQEAgc3RhdGljIGludCBrdm1faGFuZGxlX25vc2xvdF9m
YXVsdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ICAJaWYgKHVubGlrZWx5KGZhdWx0LT5nZm4g
PiBrdm1fbW11X21heF9nZm4oKSkpDQo+ICAJCXJldHVybiBSRVRfUEZfRU1VTEFURTsNCj4gIA0K
PiArCS8qDQo+ICsJICogU2ltaWxhcmx5LCBpZiBLVk0gY2FuJ3QgbWFwIHRoZSBmYXVsdGluZyBh
ZGRyZXNzLCBkb24ndCBhdHRlbXB0IHRvDQo+ICsJICogaW5zdGFsbCBhIFNQVEUgYmVjYXVzZSBL
Vk0gd2lsbCBlZmZlY3RpdmVseSB0cnVuY2F0ZSB0aGUgYWRkcmVzcw0KPiArCSAqIHdoZW4gd2Fs
a2luZyBLVk0ncyBwYWdlIHRhYmxlcy4NCj4gKwkgKi8NCj4gKwlpZiAodW5saWtlbHkoZmF1bHQt
PmFkZHIgJiB2Y3B1LT5hcmNoLm1tdS0+dW5tYXBwYWJsZV9tYXNrKSkNCj4gKwkJcmV0dXJuIFJF
VF9QRl9FTVVMQVRFOw0KPiArDQo+ICAJcmV0dXJuIFJFVF9QRl9DT05USU5VRTsNCj4gIH0NCj4g
IA0KPiBAQCAtNDY4MSw2ICs0Njg5LDExIEBAIHN0YXRpYyBpbnQga3ZtX21tdV9mYXVsdGluX3Bm
bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ICAJCXJldHVybiBSRVRfUEZfUkVUUlk7DQo+ICAJ
fQ0KPiAgDQo+ICsJaWYgKGZhdWx0LT5hZGRyICYgdmNwdS0+YXJjaC5tbXUtPnVubWFwcGFibGVf
bWFzaykgew0KPiArCQlrdm1fbW11X3ByZXBhcmVfbWVtb3J5X2ZhdWx0X2V4aXQodmNwdSwgZmF1
bHQpOw0KPiArCQlyZXR1cm4gLUVGQVVMVDsNCj4gKwl9DQo+ICsNCg0KSWYgd2UgZm9yZ2V0IHRo
ZSBjYXNlIG9mIHNoYWRvdyBwYWdpbmcsIGRvIHlvdSB0aGluayB3ZSBzaG91bGQgZXhwbGljaXRs
eQ0Kc3RyaXAgdGhlIHNoYXJlZCBiaXQ/DQoNCkkgdGhpbmsgdGhlIE1NVSBjb2RlIGN1cnJlbnRs
eSBhbHdheXMgdHJlYXRzIHRoZSBzaGFyZWQgYml0IGFzICJtYXBwYWJsZSINCihhcyBsb25nIGFz
IHRoZSByZWFsIEdQQSBpcyBtYXBwYWJsZSksIHNvIGxvZ2ljYWxseSBpdCdzIGJldHRlciB0byBz
dHJpcCB0aGUNCnNoYXJlZCBiaXQgZmlyc3QgYmVmb3JlIGNoZWNraW5nIHRoZSBHUEEuICBCdXQg
aW4gcHJhY3RpY2UgdGhlcmUncyBubw0KcHJvYmxlbSBiZWNhdXNlIG9ubHkgVERYIHVzZXMgc2hh
cmVkIGJpdCBhbmQgaXQgaXMgd2l0aGluIHRoZSAnbWFwcGFibGUnDQpiaXRzLg0KDQpCdXQgdGhl
IG9kZCBpcyBpZiB0aGUgZmF1bHQtPmFkZHIgaXMgTDIgR1BBIG9yIEwyIEdWQSwgdGhlbiB0aGUg
c2hhcmVkIGJpdA0KKHdoaWNoIGlzIGNvbmNlcHQgb2YgTDEgZ3Vlc3QpIGRvZXNuJ3QgYXBwbHkg
dG8gaXQuDQoNCkJ0dywgZnJvbSBoYXJkd2FyZSdzIHBvaW50IG9mIHZpZXcsIGRvZXMgRVBUL05Q
VCBzaWxlbnRseSBkcm9wcyBoaWdoDQp1bm1hcHBhYmxlIGJpdHMgb2YgR1BBIG9yIGl0IGdlbmVy
YXRlcyBzb21lIGtpbmRhIEVQVCB2aW9sYXRpb24vbWlzY29uZmlnPyANCkkgdHJpZWQgdG8gY29u
ZmlybSBmcm9tIHRoZSBzcGVjIGJ1dCBzZWVtcyBub3Qgc3VyZS4NCg==

