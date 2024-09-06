Return-Path: <kvm+bounces-26019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 492D896F94E
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 18:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA4BDB22024
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 16:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA88D1D4161;
	Fri,  6 Sep 2024 16:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WhCPTkDH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF751D3623;
	Fri,  6 Sep 2024 16:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725640207; cv=fail; b=DaEtoDBIWe4UE5QqioB0GofhbpUZPZkL10fbjcd/Pf3D+1Ub7eWr7LwItoWmFSb7hPK3wzTs9xWcuimT3u6BElEcdSpkcjRWR5SmnY12Ieu1bJ61fG8v+UeoqJArtcTYTdZWqzU67JRAEEgg2h/WjXU/an/a9z3eIzrzXaeOBfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725640207; c=relaxed/simple;
	bh=3P2VhrS+YfkCCjC4Urzqdfol7MGqNAbbTcHp6TXuDa4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aYCoiYMYiEwTL3aMwPtwxdOuDpfYLYqMAKvL9Cst5aE9e5MTw9QvsvRqB20J6fKqh0J9VqG7od4QyMLeoryZmvR9xOyh1VJBchpIf2HbVupHwr2zrlOUvWf0dveJ6wqBhJpFBbg//Exrm4/3QOAyYtHtpZaTGGOeYHFVrM/dN/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WhCPTkDH; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725640205; x=1757176205;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3P2VhrS+YfkCCjC4Urzqdfol7MGqNAbbTcHp6TXuDa4=;
  b=WhCPTkDHnzb/NNBRRWLQz8NDTRCnq6zVoV8kXg3WSnmFtuw2+mkdwmBo
   BvoSL7Qvp0LoIWIPMmQWusbx/2mLOn5eyyaFG4TqfpttqzRDHaH1tUPaa
   ZzMFMWtpIWasXAiXaBK3xgcYYNJUQAZgQT8FX9/oCwB3TUstBv1jX0ODm
   RsH2i2aP9JCYk2B6wQMsT42XsPbQ1++Oyr+E+4Jp71OVil1FBQMHzpf5s
   RndYTx+Hc2iqOvLt2IU6Xi6cl4IWX9KE9YkRFW3zJ6YSk6CDakC0oExEm
   zJjFdKsfjroXOGraUTFYvLPILw/6/HHT50hggynluQkXQds2L2mtUNJ0z
   w==;
X-CSE-ConnectionGUID: 9tjLLv5fQuePftUGKTUK/A==
X-CSE-MsgGUID: tVz4DpQnRCm+UCtN7SF4og==
X-IronPort-AV: E=McAfee;i="6700,10204,11187"; a="23911596"
X-IronPort-AV: E=Sophos;i="6.10,208,1719903600"; 
   d="scan'208";a="23911596"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 09:30:04 -0700
X-CSE-ConnectionGUID: ofjyBZSRTa+m9t6NNKIFQQ==
X-CSE-MsgGUID: ESTPqUGfRKm1y4yKLafFlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,208,1719903600"; 
   d="scan'208";a="103471337"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Sep 2024 09:30:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Sep 2024 09:30:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 6 Sep 2024 09:30:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Sep 2024 09:30:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vct74iQ33KXIbI0wTqwODerSgco+aLyeYFrPDvtH7D+29qDOtIlXRydIHdFSsNwBhcyocjzLwXvsIgchr7BkScBH4UGiVSfWae4vZ68gB1H5GBE37gJT9Es3jBfCGL0bfOW0+KHrv8koecXqIkyikCqtWJSJwDTPCQwXsRR+7wA5GhgLcgehf+grrhmBezvrqfI+lvzcKq731IbhW5VC/nydfVEVbH1sJ9DzHgCdQVP+QAoG95jDFmXyWO897ro8CXtMpLK3H33BZY21C+rYPCfUnWv69Q1lnJpWSog8pq+TRJZVKPe+cSIaXdElJ2sSYVy64p2LxXFCJefJgPKjbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3P2VhrS+YfkCCjC4Urzqdfol7MGqNAbbTcHp6TXuDa4=;
 b=M/eUgr5Ac6X6JU64JkKwXCDRRdWOLXrfsiTesCAgmhyLFNsFxbhnceY+bP1AiFtKKugj2PnQntOPYQEgejiZRAbR7S4QZI/Z30d/j8PY9vASRhZk9LUg3FCFyRduHfiEWIb/KGaAHM+tImtj6cfSMGM9on8OlAXbtvjxV1FagONcu+rd4eLFezlqLjsj/srNxQZ11+tqr+3OD4Nt2ZS4IX58Nq/Z+BWMol1KjvJeQaFmWqx6lx4C4PGjQ9qV/NkJhpZitDCF5SItnOeHqEXJDBe4TAWe3P7nOLnUdazXPm9cZnNC+dMkGzYpzAoHMjEwGlhn4UnfaCFR7/Bhd5ioxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7443.namprd11.prod.outlook.com (2603:10b6:8:148::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.31; Fri, 6 Sep
 2024 16:30:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 16:30:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest
 memory
Thread-Topic: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest
 memory
Thread-Index: AQHa/ne7pTzhAEMIUUeBkR4uOlaw8bJHD/cAgACZDgCAA04TgA==
Date: Fri, 6 Sep 2024 16:30:00 +0000
Message-ID: <9983d4229ad0f6c75605da8846253d1ffca84ae8.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-20-rick.p.edgecombe@intel.com>
	 <Ztfn5gh5888PmEIe@yzhao56-desk.sh.intel.com>
	 <925ef12f51fe22cd9154196a68137b6d106f9227.camel@intel.com>
In-Reply-To: <925ef12f51fe22cd9154196a68137b6d106f9227.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7443:EE_
x-ms-office365-filtering-correlation-id: ce906291-1e74-439a-018d-08dcce91271e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NXZVcmJBZGo2dW1JbmMvTWsrUUNMLzkzTCsreG5qN3FoWUdXcXZOMm5UZy9k?=
 =?utf-8?B?VTF1L0dHYmlYNzFkYlRHQWJZTWd6TUE4WVplTWcxZ2RrS01yVUpDMWd3UkRB?=
 =?utf-8?B?YkJmSzA0blVrYWRBQTlxTEFEaytHdTZ1cis0ek5KSC9QaUNLQzV1TkF6Vi90?=
 =?utf-8?B?aGZkbUdkT1Q4Zno4OS84NkduYzRkd0w3RnExbXFUUjhGQTR3L3B1Ym5EUHlQ?=
 =?utf-8?B?czVNQ3hOeURQTFlCU2ZjaTBWdUpvNStkYURZaVgxSVpNL1ZHUU5yekZ1UzJT?=
 =?utf-8?B?QitQTytnbkE3aWJDdFZqV1dtbnM5Kys3WUZDUFFaMERCMG01Y1hvaHh2Nm91?=
 =?utf-8?B?aTdnekxZNW03L0lxOHk4dThnZjVDRTlBVnpZMittR3pEU2RndllnKy9WUHJa?=
 =?utf-8?B?bmV4bkVBYUplc3hQYUNOc2doL2RTMkREQWx4em9pMHg1Q0tQV0xFY0Jtb1Zl?=
 =?utf-8?B?czl2MGVVbUw2djdDZGRpN2xhSTRpSDBteFZ0Sy9iWCtYcUdXZlFEVUxLa25m?=
 =?utf-8?B?RTRkR3NBR2V4OU5qUWdpdDU1ZXFlSTFTM0FLM0hpUEpybW8zQ3VIdVBiK3hQ?=
 =?utf-8?B?bTFoSU84VG41dnM5WVNUVVdXZVVXNFVrWUJwZXVXQ0duNTluVjU5VHJTN1hL?=
 =?utf-8?B?b0hWNDNWY095V1BzQTJybjQ3K3R6U2hPMFdpdmRLMHVaVm43UmRmZWg2SHJH?=
 =?utf-8?B?VEtBRC91MS9lZ1lYL0x0bVZPckZpeTFPRlR1V1JjalJkVi9GQnBhK2ZoeHYz?=
 =?utf-8?B?Vld5ODNIQmQzb041WTlyM2hGNHNRaDNQRm14SGl2cjB2VjlSK0d2T3RKSkVo?=
 =?utf-8?B?RGI1amxxQVJ4WEJoRGsvY3VuSEg5LzJUTEowblFrUXQ2UWhHa3l0WmlHeHJt?=
 =?utf-8?B?ck9pQUV3ZktUd0czRVVreFZoYkpESjRHNjJUQ2dqTUxORk50cCtzSEduTUkw?=
 =?utf-8?B?bkJuUlgyVy83NlA5QmxUYmVXZXloZEs2WDlDUUg1QWZVcmVQMHR3dW1tVlJN?=
 =?utf-8?B?cHZIbGFFQ3BveFdHYTQ0NDJtN3FQWkFqMnkzUyt1b0FqRldQLzgxOWJpaDhK?=
 =?utf-8?B?MnZBREFlc0sreXB2Umc5YXM1Wnk0N2Zac1cxdDFFTkFibjFTMFgvdXV4ZFJ2?=
 =?utf-8?B?MU1ZZGZRVm1BMFdmTndFNTNkYUZtSTZ4ZzVvczFmUGxVWVpVTVhwZVJBTnlR?=
 =?utf-8?B?T0xMRjNrenVLYjlMZDVXRFkzTytvTkJOaGhQaHhlKzRlZm03U1NGOFNkcE1o?=
 =?utf-8?B?ZjlXUGpqNEVCS0ZOQ3E0U25qckhJMDU4OVhDQnpiZWZURExrcitPNDJQcVNG?=
 =?utf-8?B?YXdsTFVza1RXUUdqUUYyY1hXUTNYcHlyYzZGSWJHakIyR1kzZVpkYUFEbm8z?=
 =?utf-8?B?UmZyazd4NTlvL0lBR0Nkc3VTaWsvUWJmMlJsUG9ZUVo1V2NyU0ZvOW9ueGNw?=
 =?utf-8?B?VE1Rd1RMbFROYTQ4VTRFRDh3ZGtkeU1ORnRPRE94TkQ1amlMa2tEQUVEamN5?=
 =?utf-8?B?ZmQ4eGRTZUVwbzZKZGVpSjZ3aTN3Y29WbDBQTGxSNzJWUk1DMVlQa1YvU21q?=
 =?utf-8?B?aG42bExCenZyRFdmY2FyVTM0OXcvWG1HcURqMFFNMVVXWnFablJ1L05ESVpU?=
 =?utf-8?B?RXo5Z2pITkliS1NaRjV3NEdBeHBuMFNCMDgzWldQejVudzU0OFhTN3NhRzRH?=
 =?utf-8?B?ZEI2dlkybGJhL3lOdW9ncVpvRFpWREcxa2RFbHBiVy8vUW1za1duYTgxVjZV?=
 =?utf-8?B?Y1JRS1lGVVN6cjIxYmE2amFObTRYaWF5em5zdGNKU01WdTBmcFhWSDUxcWNq?=
 =?utf-8?B?Tm0xSUhqcWhlQklzWUNqTkVHenlwdWtQSk9jcWZRSGF0bVFZVCs4WVpYbGhh?=
 =?utf-8?B?T0t5ZDNhQ3ZRdnBrMGxUb1AwQWIxYzd1RDlPaSt5S2tZeHc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWh5T3lzakxsV2VXNWRQR3dSekl5WWU4YjdlenlJM1I5ZFZNSVkzaGdkWG1J?=
 =?utf-8?B?NzlBNTlsMWxSbVlndGc1N3hsQmtiRWpTVE91UU5jVFpFODVRTjh1RzVhWGto?=
 =?utf-8?B?R2xSSlF2cWFnUEpISXFZYlJFRFg2SWlySjR5RkxtRTF1aVF1alNNSXdiQ1ZD?=
 =?utf-8?B?aVNhcm5qRkxPWWRSTFRORTlmZjBpZ2p1UFdtdzIwcVcyVzljQUk2bW0raVNT?=
 =?utf-8?B?U01ScEpVZXVrSlp2a2Yrb0dDUWpBY2NjSGxPWnEwM21jNXAwNTBYbFZxb1Vt?=
 =?utf-8?B?MlRYb0Q3a1ZTNVFDYngrRGdtRUZTTDFRVE5INkRIOUltdHFxUVpHVVVQMVFt?=
 =?utf-8?B?ODh6NXpnekpXUk5YTmljYVdpZUk4bDBhYUdodE5YdFNmTUxFSmFyV0NyTWs3?=
 =?utf-8?B?Qm95TTk4WFZDYUJsNmJwdi9ZbjhkLzcyNnhNTDdIZ0todHBaOVUvZ1FHSVMr?=
 =?utf-8?B?YkhNVEhCUHc5S2NGWWgwR09JSXFDVmh6QmliMUpwc1ArQnlrZ2pNb1dBWVQ3?=
 =?utf-8?B?SXppOU5zekxveGVVTXloWlpkM0dQakhaL3FHbXc3Ty9Ma2NWMmpoNnNNdENp?=
 =?utf-8?B?OHFzYVFDVHNUcENIWWxMZVdhay96anBFc3JpRkNac3lJbHh6K0lSNEJ0Qm1h?=
 =?utf-8?B?VCswVnlkOVBlaVB1c29VZHRzM2hBSHNNSGhVYy9URkdORnBCanRkd1p3YUNm?=
 =?utf-8?B?YVZYekdSbjI3WGtnYkJjOFlzaSt0dDRYVGpjR1RlUEpVOHJPTlZXYWJ1dGlw?=
 =?utf-8?B?YU5CVzdCTzFaMmd6NTNkMjUvbktGVkcwQkFLTGJQaWlROXJXSUdZMTRCSVFt?=
 =?utf-8?B?QUc1Yzh2aHJEY3pqTW9MdW9VK3A0RTQ0MmpXb2QrMndCS2JiUnlTSHY3ZGlq?=
 =?utf-8?B?U01aR0ZYRnAyS3B6TnVRdjhPK1EwMXRXSTBKTkxJajJVeU14c2FNdXpGOXRT?=
 =?utf-8?B?bXhQZmsvVUowV0tmdlp1QVBSWlp0VC9ZV2o0dlBNT2ZxV29FWGMxT3FLbVRr?=
 =?utf-8?B?YlNrL0NvZUkzZk5Tb0xrYnIvWjlYSkN3WHIrMUJkektQU2J6U1YyZVU5ZjhD?=
 =?utf-8?B?VlF6bFBPak5zeFMzSGlkcVV4aTVSMXhVTEdhclMyYXJvbXNOdHdSVmdITUtV?=
 =?utf-8?B?ZEtWMFNzdHp3VHNldDVzMUZhM01oa0xhOWZDeGFaN0E0MzRyN3Z5NTN4T1dN?=
 =?utf-8?B?KzNCQ0ZFRXNpSG8yK0ZGZlFqeStkKzFhamZtamVqcVpWTHM5RDFaQnIzOEtH?=
 =?utf-8?B?NW5pdFByYTlvOEhYLzZsYk5TME1pZXRyc3VXUnRJVEd4VWxNZXMvTlh2dWg4?=
 =?utf-8?B?MFF0dm5BREhyd0xpM2QvWURybVArRVZ1RjlSWlVPVTM1dmIxUi9mbENiSys2?=
 =?utf-8?B?WVI5Smg3Szg4TXNVYnlRU2xoWU1BQmlScGVwTmMyTGJCSDBqbURkdUswaG13?=
 =?utf-8?B?cGJkZWsyeHdXMElRNVZJVGEvN0dYR1RKRy9BN0Z2bC9JbmwrbDhBWDduUGNj?=
 =?utf-8?B?NDRYZHVNamd6T2Q4eUNvR2tlL2VYRjZDbzl2RzVvTGl2VWlXQ01tdlBtMjF5?=
 =?utf-8?B?M2UzYlAzMEh0K1l4YW5GRnJsWjJMeTdGVDZ5OFZqMXpTeE9kZXlrUnJzUnVx?=
 =?utf-8?B?RzAxbTR5bjcveXA4dHptNUduUXM1Wmt4dzFoNXJOS0gvM2I0SmsvZnYvR3dE?=
 =?utf-8?B?SllJY2ZhSGR2WFJmRUNKVzVoLzhjTXk5aW9zUXBSVktKOXhUY2IxNnVxc1c0?=
 =?utf-8?B?bEFEeHlINURTZlFHQmthSEFCcm43NmtVUEJVY0JsNkMvbk50N2tJdjAxTVFE?=
 =?utf-8?B?YmtHWld4MXhOUXIxeExnK2hGWEMxcWZQeWF2SnpJMHVGdGt4NzlWWEtWTE9m?=
 =?utf-8?B?SXhxaHZzZDBuMXdHUWkzOE5OMzFsa1ROQnQxMC85aURKQUFodnJsRHEvVkxE?=
 =?utf-8?B?T25NNnc4MXFzM25iVFZRRlNPL3JycnAzTExZelg1VlYxTG84a256RDVRZk9v?=
 =?utf-8?B?eGpVLzdZb21Rck5pdm1EcUZORG50UndmdWczT21EK1N3dHNkZmxOZHlxQnZE?=
 =?utf-8?B?VCtUMWRTZVdPU1dhaEoxRWgxOG53alIvMFR3VzRXRTNLOGIxUXY3OUdzaWZK?=
 =?utf-8?B?RS9rcHQ5QkRUTm5QK2dPVUcwQytQSDRmUEg3NTNpUThCZzZyU01KOFIyNHhx?=
 =?utf-8?B?YlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <447EB2E70FE41349AF57CA3FB0E8D33D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce906291-1e74-439a-018d-08dcce91271e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2024 16:30:00.1340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 26g+BZFbIBDfLsgqI53c/24UOk2/NpLacNtnaxbpH8R73dZhEzOMVobCYUPqHYC2tQN6KjOz2v9cnJsogVVE8im6/Rf6TaralDr1UfgBQCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7443
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA5LTA0IGF0IDA3OjAxIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gT24gV2VkLCAyMDI0LTA5LTA0IGF0IDEyOjUzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4g
PiA+ICvCoMKgwqDCoMKgwqDCoGlmICgha3ZtX21lbV9pc19wcml2YXRlKGt2bSwgZ2ZuKSkgew0K
PiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldCA9IC1FRkFVTFQ7DQo+ID4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBvdXRfcHV0X3BhZ2U7DQo+ID4g
PiArwqDCoMKgwqDCoMKgwqB9DQo+ID4gPiArDQo+ID4gPiArwqDCoMKgwqDCoMKgwqByZXQgPSBr
dm1fdGRwX21hcF9wYWdlKHZjcHUsIGdwYSwgZXJyb3JfY29kZSwgJmxldmVsKTsNCj4gPiA+ICvC
oMKgwqDCoMKgwqDCoGlmIChyZXQgPCAwKQ0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGdvdG8gb3V0X3B1dF9wYWdlOw0KPiA+ID4gKw0KPiA+ID4gK8KgwqDCoMKgwqDCoMKg
cmVhZF9sb2NrKCZrdm0tPm1tdV9sb2NrKTsNCj4gPiBBbHRob3VnaCBtaXJyb3JlZCByb290IGNh
bid0IGJlIHphcHBlZCB3aXRoIHNoYXJlZCBsb2NrIGN1cnJlbnRseSwgaXMgaXQNCj4gPiBiZXR0
ZXIgdG8gaG9sZCB3cml0ZV9sb2NrKCkgaGVyZT8NCj4gPiANCj4gPiBJdCBzaG91bGQgYnJpbmcg
bm8gZXh0cmEgb3ZlcmhlYWQgaW4gYSBub3JtYWwgY29uZGl0aW9uIHdoZW4gdGhlDQo+ID4gdGR4
X2dtZW1fcG9zdF9wb3B1bGF0ZSgpIGlzIGNhbGxlZC4NCj4gDQo+IEkgdGhpbmsgd2Ugc2hvdWxk
IGhvbGQgdGhlIHdlYWtlc3QgbG9jayB3ZSBjYW4uIE90aGVyd2lzZSBzb21lZGF5IHNvbWVvbmUN
Cj4gY291bGQNCj4gcnVuIGludG8gaXQgYW5kIHRoaW5rIHRoZSB3cml0ZV9sb2NrKCkgaXMgcmVx
dWlyZWQuIEl0IHdpbGwgYWRkIGNvbmZ1c2lvbi4NCj4gDQo+IFdoYXQgd2FzIHRoZSBiZW5lZml0
IG9mIGEgd3JpdGUgbG9jaz8gSnVzdCBpbiBjYXNlIHdlIGdvdCBpdCB3cm9uZz8NCg0KSSBqdXN0
IHRyaWVkIHRvIGRyYWZ0IGEgY29tbWVudCB0byBtYWtlIGl0IGxvb2sgbGVzcyB3ZWlyZCwgYnV0
IEkgdGhpbmsgYWN0dWFsbHkNCmV2ZW4gdGhlIG1tdV9yZWFkIGxvY2sgaXMgdGVjaG5pY2FsbHkg
dW5uZWNlc3NhcnkgYmVjYXVzZSB3ZSBob2xkIGJvdGgNCmZpbGVtYXBfaW52YWxpZGF0ZV9sb2Nr
KCkgYW5kIHNsb3RzX2xvY2suIFRoZSBjYXNlcyB3ZSBjYXJlIGFib3V0Og0KIG1lbXNsb3QgZGVs
ZXRpb24gLSBzbG90c19sb2NrIHByb3RlY3RzDQogZ21lbSBob2xlIHB1bmNoIC0gZmlsZW1hcF9p
bnZhbGlkYXRlX2xvY2soKSBwcm90ZWN0cw0KIHNldCBhdHRyaWJ1dGVzIC0gc2xvdHNfbG9jayBw
cm90ZWN0cw0KIG90aGVycz8NCg0KU28gSSBndWVzcyBhbGwgdGhlIG1pcnJvciB6YXBwaW5nIGNh
c2VzIHRoYXQgY291bGQgZXhlY3V0ZSBjb25jdXJyZW50bHkgYXJlDQphbHJlYWR5IGNvdmVyZWQg
Ynkgb3RoZXIgbG9ja3MuIElmIHdlIHNraXBwZWQgZ3JhYmJpbmcgdGhlIG1tdSBsb2NrIGNvbXBs
ZXRlbHkNCml0IHdvdWxkIHRyaWdnZXIgdGhlIGFzc2VydGlvbiBpbiBrdm1fdGRwX21tdV9ncGFf
aXNfbWFwcGVkKCkuIFJlbW92aW5nIHRoZQ0KYXNzZXJ0IHdvdWxkIHByb2JhYmx5IG1ha2Uga3Zt
X3RkcF9tbXVfZ3BhX2lzX21hcHBlZCgpIGEgYml0IGRhbmdlcm91cy4gSG1tLiANCg0KTWF5YmUg
YSBjb21tZW50IGxpa2UgdGhpczoNCi8qDQogKiBUaGUgY2FzZSB0byBjYXJlIGFib3V0IGhlcmUg
aXMgYSBQVEUgZ2V0dGluZyB6YXBwZWQgY29uY3VycmVudGx5IGFuZCANCiAqIHRoaXMgZnVuY3Rp
b24gZXJyb25lb3VzbHkgdGhpbmtpbmcgYSBwYWdlIGlzIG1hcHBlZCBpbiB0aGUgbWlycm9yIEVQ
VC4NCiAqIFRoZSBwcml2YXRlIG1lbSB6YXBwaW5nwqBwYXRocyBhcmUgYWxyZWFkeSBjb3ZlcmVk
IGJ5IG90aGVyIGxvY2tzIGhlbGQNCiAqIGhlcmUswqBidXQgZ3JhYiBhbiBtbXUgcmVhZF9sb2Nr
IHRvIG5vdCB0cmlnZ2VyIHRoZSBhc3NlcnQgaW4NCiAqIGt2bV90ZHBfbW11X2dwYV9pc19tYXBw
ZWQoKS4NCiAqLw0KDQpZYW4sIGRvIHlvdSB0aGluayBpdCBpcyBzdWZmaWNpZW50Pw0K

