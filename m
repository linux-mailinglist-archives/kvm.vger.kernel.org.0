Return-Path: <kvm+bounces-14688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB908A5A68
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 21:13:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DC76281D5C
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 19:13:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 814A8156225;
	Mon, 15 Apr 2024 19:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O+WX8zuL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454F5155A37;
	Mon, 15 Apr 2024 19:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713208407; cv=fail; b=iaFf1hEgZWp893zbBJgfQvEhXHzZbuxX8O/jmT7dG8Z6kcppa87nvgubWbLt0lk/PpTl/kjwS1FVYlIo1OiEiSXSL2J9nJ/sTWSkKCKR6OnSsF6Re58Giljcwj0uc3pPln3VZoPQHdIir4bGbtevpvAHk67cM/5gNwwEEWamWYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713208407; c=relaxed/simple;
	bh=S3fZGTzka02HpjvNtvAEBwr1Gy4cjUvrkV8MzGF0/wA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Pzkj1lNyqchoKS8jOkMDIRADz6aeexBANYCKEH8PsIhqPFet++wqgpGo+9acq4fUkZ3KFKC6c1cVNPuZizLf9NfLaGsM7Cn1q5cCYJn6iHgyAQTTLaFtRcDshy8muZ5XTGqLgX9VFMI+gs8/AbhXaDFqV40ozvX4Mge+2hHkEv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O+WX8zuL; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713208406; x=1744744406;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=S3fZGTzka02HpjvNtvAEBwr1Gy4cjUvrkV8MzGF0/wA=;
  b=O+WX8zuLfXDJrxwEHM3XISzFZ0c+wga+NqaTaLniRSFUd1O2fF0phWzH
   xDj6OcqF0vegjUXIuqd8IrfjLkXEBJc0HU+uEZgGYyNAwNewlel9U8hxB
   W6ToiwahKpqnBNjTKCtI78W2SiJjdf4UDN8V4YZIuXAn+rjl6c0/VGVQD
   xVAu+eipBpSOJnmSSAsmVY4Q8YVbIyz3U/5CF2gmJklsPAHiEwDT/vk2v
   awXKaFXI/+hoZg53lOIOGvqx3mJbdTzvY7WWyZKe5MiloEilWiZ25OukO
   YPf/tVBMqgWUUyQQ4Zge8UekqiipLc2ch0UuEwlN2zdFDDG39GAgPM3N6
   g==;
X-CSE-ConnectionGUID: aU5iOF+JSmOm7t2/m1i9zg==
X-CSE-MsgGUID: OK/9O/bgQni+apjaM7DItA==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="34002307"
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="34002307"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 12:13:25 -0700
X-CSE-ConnectionGUID: nfW6z77bTq6yRZVd44O6pA==
X-CSE-MsgGUID: DProV2yERtqHKZRp8r8WXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="22055356"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Apr 2024 12:13:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 12:12:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Apr 2024 12:12:22 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Apr 2024 12:12:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H++GleWVGSXSlo1HBnKlN8hemXfILNLYsrtQP+yhazUlARV1JomIYutgQ9tY8RTRhYuwt+bdqQ05JvmL2V5Vae5fwUulwHD5IbtwNPCy2T88aRgKPysTD8t/uHqe0zKFu0VhlMK9G6gfD4Ph+qrZoyDV+9LisrF40v6kT97ASjqR7PyJlL+MSC3sHyk1M1wLYvEHCaGlm2CxYhNlsvHZ0OMR1N4FNuFJA4USnBLMa/N8NAs9R5D3pBbv2ycOdXOzz6B+wVxKH+524J8FQoBiWVMWCHbbsE9Rhto00mIaHpQxa0QQPA8XZMKLi3vr0NKRFZLK49uYXXY0frs5iZmwRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3fZGTzka02HpjvNtvAEBwr1Gy4cjUvrkV8MzGF0/wA=;
 b=b+vThml+fiXQa9L8fryTLvdqwoohJmysMUVMxuZ7pFgC/hBxuNu79Ej2qFGqJT6GaLucikvFpHx3RPopeQHrT4xilXUuIk5dvmxFEdd36dOhV6Rl/N2/UiSfmznyTJk9bBRe+yN+EPZNQ8fAY6i3NMhACv7IHdcMCurmVHsmqDpkDyKaZUphn8ybMwu64eSDx2p2X0AYM37r0QOnL6BCbz1h2PlrgZVgN8kK8TWWq2t7GcMImnAyeO766P7zWf6Wlz8WAh9UydfblkelYsMq/RY/1lu3SbFVopeZU74RJJ8FSyue18EmA5evHVIVSYFkfgVyunm87tYL4ZKpC9ISxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL3PR11MB6435.namprd11.prod.outlook.com (2603:10b6:208:3bb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Mon, 15 Apr
 2024 19:12:07 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Mon, 15 Apr 2024
 19:12:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "federico.parola@polito.it"
	<federico.parola@polito.it>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for
 KVM_MAP_MEMORY
Thread-Topic: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for
 KVM_MAP_MEMORY
Thread-Index: AQHaj2jO+VEgNlPf0Eipl86WfDYsqA==
Date: Mon, 15 Apr 2024 19:12:07 +0000
Message-ID: <116179545fafbf39ed01e1f0f5ac76e0467fc09a.camel@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
	 <2f1de1b7b6512280fae4ac05e77ced80a585971b.1712785629.git.isaku.yamahata@intel.com>
In-Reply-To: <2f1de1b7b6512280fae4ac05e77ced80a585971b.1712785629.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL3PR11MB6435:EE_
x-ms-office365-filtering-correlation-id: 16de5460-21a5-4bf5-2583-08dc5d7ff15a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xcWW2FBiXgq2s9yqa2vubKKmy53UYk6lUAsDHRlk5ICfexTP3iac+8uhsYx7B4IWQXP3vmSs6z8KotqqUKk7FQ8rEUD7JcAYBxfMopc/eE4fT1yAg2zaqCfduHjuo9msgoYKKLAvowZk4Sbxp+Hc60re+NcovoPZ7OEKJJNkWhMyZhZ5ls01kv1n0kq6YUBeeU9fY6Q4Z1H2scOEWlLXeRtEQaxJe+af/oa3qzlfIMD2XdaHNUG+c05nR4+q3SNVlc0f6KY3HHWGOaeV0GfiD4bFxc+r4ROo43kB9rqGIUgFl8j92vM/O4Z6CyPL3Wfn7ELPLBkpjesL/faYSfxS8YoYUFkNtNMRQcLAGJUFQPbozNEmnWPdSLQMtjZ8dQPax1jlmLuv+FRdsVJqc/qhKgBiAQ/h9I5s0UTznG/fKpdwYo1eXGHi52jHJvDw2p4mY2kEJBuLQt5jnOmv5PYyMp/rCrnX9O4A0rp68A5qpK7mEGEN/TxDmdG4qu6/5hzeVH6uwGoYNiUAT1R/iGHMhVvhz41mo12XDUCK5Iz08UHhnLLcNE794w1L6wAngKtNnNBsSdNB0rbfyN/MH0nnH2jriTTWstqii9+6JivV+T4rrDpMabkBleAXAVtVoxAGxoRfGQNKGjQ+fkPNQqge4ZkLnFOVJEbPAzlLQOhbER6IxWTvudGgtybSXGTcDV/vqpdYS0jsOYdUClZ8r+9lI+1IM1Rfd6k3I63MtKGarqA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VU1oTVg2WEJJWWF6Z2ZtblgzMmovczg2bnl1eWkrczdEQ0g3b1I1T2RjWEQ5?=
 =?utf-8?B?dkh6UTc0OFZmMW9meVhhOTVLKzNnaE5SMm0rUDd2S1ZpSkI0eVBNUjFUcmVi?=
 =?utf-8?B?bjd3VXhIRzdIaXFmSHFKcEplM1hRczVnY2laK2d4RTI2R251cldBUjRQWVdn?=
 =?utf-8?B?YVRIVXVoRkwxQ1JRSWxXTkp2TjhyZDFuT3FsVFI5ZUtJU1FQbmJHSWo4WW91?=
 =?utf-8?B?bVJYWDAzN2lOd1dJK2xucEQyVVFZN3BQYVN0N1dNNmdxdnZxOTdSaGtZR2Jq?=
 =?utf-8?B?RVo1UitFeHNuOG5qdlYzQjRSb1NVanoxM1VtTUNWRkgzbzhEbFJFd29WZnFp?=
 =?utf-8?B?Z3BnZmZkeGFrakxkdUtHdDlsWVpOdnprQmlvd2Fzcjl4QVJzeWxNa05yKzlS?=
 =?utf-8?B?TWQ0d2l6N1hiWkpxTTk2ejFQaVRsZkZDSVNOZXYxU1p1TlVsMnZLT2NIdVox?=
 =?utf-8?B?dUZpWUY5UFRXMUVKOUlPTXh0NnBobWxnR3NpUG9aOXpKa1RXaDM3QkIrUlk5?=
 =?utf-8?B?dFdGUDUvZUhlU0I0Nlp0UDZ0UkdhdUpjSWhETVZCZmdJOEtVQ2lLQTNrN28y?=
 =?utf-8?B?c0UzT1ZuTTc5OEYxb1Nic0VNQXdsakQyWHFnNHhMRkJ5cGx5ZXJMV0l5azk5?=
 =?utf-8?B?ZTc5MzFkaFk3S3Q3c1N2SXhlb0huZkdqVHZFMlFacGsvUUEwNW43UU83VVpV?=
 =?utf-8?B?WjFhNUNiaXB4UXBmYTdESXdEaGNNcVpiZmtHVEQwZjhpaTlGKzAyaGNpYnB4?=
 =?utf-8?B?a2c0NldRKzMvSU92RFRyanorU2drdkRhZ3JGTXlFLzJ6eDNsWHBPckNFQ0Fm?=
 =?utf-8?B?UGFHa2V0UnYxejlhTDVMS2JFekc1MzdMQXRjVnY5aE9DRTNaNTJjSVBWTUh5?=
 =?utf-8?B?YytDa3g3Q1dZT0wyVjRZcjVYZFFMaytZTTlxMERpcm1TK24vL2hnM2l3QUJL?=
 =?utf-8?B?SDVVck1hYlFvNkFvNVRvQmlhOGNYSGtnaG1BUTVyQ0t5Tkg5Yk54OGxiOXRi?=
 =?utf-8?B?bGg3M1ZrdmJCR2YrSjhyYzAvbzFRMllGZ3JpaXZpckJDZUNHMTczS3NKZWNH?=
 =?utf-8?B?R3lGM3VkUkNjQzA5WVJ4TmtyZmNlUkR3S2YrN2lmclh0a1FBVFU0dGR1MzZ3?=
 =?utf-8?B?MFJVWWVGa1BwSzZMNUIwZkVHWkM3OUdIUGVLQUZPd2xhNnZNZFZzQzJzKzlP?=
 =?utf-8?B?alVMOWtheG5GMzVBYllzNFRqMDhyWnAydlZ3VGxRcVBjYUpoK0RFbGFvUko4?=
 =?utf-8?B?eVlIdGNnVUpFeGVNM2UwVTZFWXdFQTNKQWdKejFQcThBUDEybXVJcVg3SWs1?=
 =?utf-8?B?N3E3eWtjMHZrczY0L1RYTXRwMlhlSTlabzBueWY2L2JNeXZsT3cvQUpJRUdB?=
 =?utf-8?B?dXI4QnI1RERseFU3N1NXKys4MGtES3lIRWJEVkZuM0IxOGQramJOdkFsN2Zo?=
 =?utf-8?B?cEdzTXAwOUhtRnpRU0doOUNLM1ZjWTdIaWFuVFBVVVJlZkdMamRDU0thcGlV?=
 =?utf-8?B?OGg3ak9rMVhHdHJ5L1crTTdYVS9wdDQvRzcrNDRQNG8rZzZIZDB5azlyYjQ3?=
 =?utf-8?B?QTFrUkJzZEp2bFFubVJwenRKSVptSWZYMk9lT1lkRlp0dVlmMzZBZEtnQlp0?=
 =?utf-8?B?cERtQ29HdDR0a0FrdzNPNVkwVWplQ25JR0E4YWJQbkhTcHYzaC9EdWdzOGV6?=
 =?utf-8?B?eFFvajhCL1Y1ZktkWk9DZXZSMkd6aU9oUHBZRTFQVGF5ZktYbXN3ZDQ1UE1X?=
 =?utf-8?B?ZlJGTnFvODI4MmU0elRmdllaYktmenVCME9IUzdGbXFRSWRXZE42TUZ1N0RD?=
 =?utf-8?B?Nks2YUszYUlNekU4c0h1WFRGU3JjMVQzZnViTWk5MFYxMzVwcXZjZXEwem9L?=
 =?utf-8?B?OG9aUWJiRzVaV0hOT0JGaC9pQUpvVi9JcGJtMnBIb1BISTdieHh2ZmZJMzZp?=
 =?utf-8?B?ODVGNndrdllpMmRERkF0RlpiOEJQNU9aTDZvS2xrLzV2YVo0QmJWUFFuajhD?=
 =?utf-8?B?dm5qZkVCUlZNSEJROVNYaGcydWpiQXJwaFluN1VoYWN2UXQ2ZnF5WVdUbWdC?=
 =?utf-8?B?SlBQNjFVVkp2NjhQNk4yMHJCcDlwM09tQUlvdlhPV1NxYThBTGxDbXIrWU1a?=
 =?utf-8?B?Y3dGcVo4Z1FmV285TytROEpFL2Z2ZjNnemJuU01aeXZUb2ZiR0QyT0VpdEh3?=
 =?utf-8?B?OWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <70EC9056FC93A641A5C5C63C183C04DA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16de5460-21a5-4bf5-2583-08dc5d7ff15a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2024 19:12:07.0975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ws45mORf0Fgg5VV4tKOAoNBv2zEM2lsiLm7VYzd8S2RuMeYYWYVuRr6C29Y6/tI3/i4WX9mBnzBl666siHgEdoydPXyNdTQW8SYFkvIpEAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6435
X-OriginatorOrg: intel.com

SSB3b3VsZG4ndCBjYWxsIG15c2VsZiBtdWNoIG9mIGFuIGV4cGVydCBvbiBuZXN0ZWQsIGJ1dC4u
Lg0KDQpPbiBXZWQsIDIwMjQtMDQtMTAgYXQgMTU6MDcgLTA3MDAsIGlzYWt1LnlhbWFoYXRhQGlu
dGVsLmNvbSB3cm90ZToNCj4gVGhlcmUgYXJlIHNldmVyYWwgb3B0aW9ucyB0byBwb3B1bGF0ZSBM
MSBHUEEgaXJyZWxldmFudCB0byB2Q1BVIG1vZGUuDQo+IC0gU3dpdGNoIHZDUFUgTU1VIG9ubHk6
IFRoaXMgcGF0Y2guDQo+IMKgIFByb3M6IENvbmNpc2UgaW1wbGVtZW50YXRpb24uDQo+IMKgIENv
bnM6IEhlYXZpbHkgZGVwZW5kZW50IG9uIHRoZSBLVk0gTU1VIGltcGxlbWVudGF0aW9uLg0KDQpJ
cyBzd2l0Y2hpbmcganVzdCB0aGUgTU1VIGVub3VnaCBoZXJlPyBXb24ndCB0aGUgTVRSUnMgYW5k
IG90aGVyIHZjcHUgYml0cyBiZQ0Kd3Jvbmc/DQoNCj4gLSBVc2Uga3ZtX3g4Nl9uZXN0ZWRfb3Bz
LmdldC9zZXRfc3RhdGUoKSB0byBzd2l0Y2ggdG8vZnJvbSBndWVzdCBtb2RlLg0KPiDCoCBVc2Ug
X19nZXQvc2V0X3NyZWdzMigpIHRvIHN3aXRjaCB0by9mcm9tIFNNTSBtb2RlLg0KPiDCoCBQcm9z
OiBzdHJhaWdodGZvcndhcmQuDQo+IMKgIENvbnM6IFRoaXMgbWF5IGNhdXNlIHVuaW50ZW5kZWQg
c2lkZSBlZmZlY3RzLg0KDQpDb25zIG1ha2Ugc2Vuc2UuDQoNCj4gLSBSZWZhY3RvciBLVk0gcGFn
ZSBmYXVsdCBoYW5kbGVyIG5vdCB0byBwYXNzIHZDUFUuIFBhc3MgYXJvdW5kIG5lY2Vzc2FyeQ0K
PiDCoCBwYXJhbWV0ZXJzIGFuZCBzdHJ1Y3Qga3ZtLg0KPiDCoCBQcm9zOiBUaGUgZW5kIHJlc3Vs
dCB3aWxsIGhhdmUgY2xlYXJseSBubyBzaWRlIGVmZmVjdHMuDQo+IMKgIENvbnM6IFRoaXMgd2ls
bCByZXF1aXJlIGJpZyByZWZhY3RvcmluZy4NCg0KQnV0IGRvZXNuJ3QgdGhlIGZhdWx0IGhhbmRs
ZXIgbmVlZCB0aGUgdkNQVSBzdGF0ZT8NCg0KPiAtIFJldHVybiBlcnJvciBvbiBndWVzdCBtb2Rl
IG9yIFNNTSBtb2RlOsKgIFdpdGhvdXQgdGhpcyBwYXRjaC4NCj4gwqAgUHJvczogTm8gYWRkaXRp
b25hbCBwYXRjaC4NCj4gwqAgQ29uczogRGlmZmljdWx0IHRvIHVzZS4NCg0KSG1tLi4uIEZvciB0
aGUgbm9uLVREWCB1c2UgY2FzZXMgdGhpcyBpcyBqdXN0IGFuIG9wdGltaXphdGlvbiwgcmlnaHQ/
IEZvciBURFgNCnRoZXJlIHNob3VsZG4ndCBiZSBhbiBpc3N1ZS4gSWYgc28sIG1heWJlIHRoaXMg
bGFzdCBvbmUgaXMgbm90IHNvIGhvcnJpYmxlLg0K

