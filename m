Return-Path: <kvm+bounces-46381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30A09AB5D1F
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 21:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B9963A8964
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 19:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B639F2BFC72;
	Tue, 13 May 2025 19:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="brGxxAIY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2781EB5CB;
	Tue, 13 May 2025 19:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747164350; cv=fail; b=hA8cZqKV44gWNHLD5UMr5S6iwnZBaMhrwrsRf/Hhp4oQKxdI+MRaj+Flf9kkY7qeyFVLLB7ck+AU7o8O14oaKyJo3CxwzNDYL4d/4J508eABYlE+v4XRnykcmqilij++mjdzffhb9ulOzLCy7isk2sd8xalB27zckwukMsvdMI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747164350; c=relaxed/simple;
	bh=2MmYH6a360rSYijswIvnRiV9ucfwItTVFoKTGIRBNHI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pdxVXzJnY+9HqKJ8ed4MYftnAYPjBD7LjgcFn3A+bHaJN2MsmrNl4maxLUfOHbeO/9S+1Sut9oCMJykooEv/DFFsV+kGFYlat+FTzVuF9Ca2az0kyiSGV3CbSb0gcLfBFWS2LUUMexVILFiDt/npGG3+VQzCn6fz1d0G33VY+MQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=brGxxAIY; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747164349; x=1778700349;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2MmYH6a360rSYijswIvnRiV9ucfwItTVFoKTGIRBNHI=;
  b=brGxxAIYSgo5ZJdSBEWWEkcXCIX9k+0Vd3L23J0Qi4OeVf0+2XtBFK7E
   RamaOXfgliJ7cWG7kCX6p/XDHenCz/Uct6sxTLuTs5jDotay/h0CBg4Ya
   CQyewtwGa5oI6taWrmUiWIuPVWsjjXgw3u5t8qWJnZFfJi7YiiWq398ec
   H8YkzvBIJMoU5hnuP/YmM7t7JzhTcDaEqtQM6f3xObjas+DXFdr++3InV
   ABlKh5lawtkCuzobW0HIqDhzwIcUeLsSwp1+zT4OCA65OfMhd7yYoAx7v
   YAZe9NodafxtOv91CyffoxPGb9tiiPFbxAUQHY/DzeACDPaaERYLHB8Zt
   w==;
X-CSE-ConnectionGUID: N7ljR67BQLa4UY7O9Y8FDw==
X-CSE-MsgGUID: bzkKIxpqQb21OZnagVWyfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="59694176"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="59694176"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 12:25:48 -0700
X-CSE-ConnectionGUID: LoAFwtrSStaW6HS0A6syyQ==
X-CSE-MsgGUID: 84R2nqyITlKeSe85CCjWRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="137673350"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 12:25:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 12:25:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 12:25:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 12:25:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ldF+oiaHTQYSYM1407QhZtXCnO53zOtLcURjaKV4nsKfXRs7egc3eMhsVHAFFLVmXLrjTJkWn7lyp1k/cf5Y8/EJHxOOSr6dZFIkbPSJt1dlavFcUlOCQK8FBWEAM0bu43wgSWQOO69DZlTtiCsNYKAVB1KU6omi5YdIyMeq7e/SGa8sdKQV5NbjksbJQybtx2tlSyA3Rn5UsBe/DOEFhEdU/ARbCGnsuQ7tqAJPdGRGeEjq7rG+R0HevZTWPaiM4EvA7aqcADgxBC882ft0BjfoJNjHbztpntjtK+MvH8io32JEh/ohi9p/aF3Q1QsxmD6aPm2MuH+XN67wk66pVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2MmYH6a360rSYijswIvnRiV9ucfwItTVFoKTGIRBNHI=;
 b=RD1ypIwQSEIkOUfW87sTNHwNga5NnLcbujj4oF9wpykH2C6YnZBaRuLomlQZ//5UJF01LeUKANdZfUoQcuDhqxMb7miOqHxami+pKlnNNJzu1VPeaJTURoowFYvPlyn6p2pS8cMBkOy4J2CGsTo7627SRRdtwHwX73YQBcMCdQuqSVCZjmT6mFyHlTk/6glY60dPOMqOnftuiDJb5vTQTUn9CcRNJxv3DC8SDYTcAiB55Z3sWNRLTdrHs6+CqGXv0n9V2L5CJ5fIPMUnssYwjVWg0iAUfbnOcAbisOJkxWNRWDEj6CGup0YYdozlLT3kp5qdUhhIZj1rH9ZZXiP7EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB7885.namprd11.prod.outlook.com (2603:10b6:8:d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.27; Tue, 13 May
 2025 19:25:29 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Tue, 13 May 2025
 19:25:29 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 06/21] KVM: TDX: Assert the reclaimed pages were
 mapped as expected
Thread-Topic: [RFC PATCH 06/21] KVM: TDX: Assert the reclaimed pages were
 mapped as expected
Thread-Index: AQHbtMYHct23az52zU++ddPeLvRl9LPREAUA
Date: Tue, 13 May 2025 19:25:29 +0000
Message-ID: <846bfd9ba7a3a2c6feb2d74b07c8cb1b42dcd323.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030532.32756-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030532.32756-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB7885:EE_
x-ms-office365-filtering-correlation-id: 1d4b8374-f222-4fb6-4a65-08dd9253ebd1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WHRZc3dqMnJvVStoUUo1TVo0djVQNHVWa2MrRzhSNkJRSlRETVpmR2NYcmR0?=
 =?utf-8?B?cFIvSGI2RG52QUxuWWU1MjVLem94TXJnbjhKNFZtR0tZQnpTc2FqeWFNK2dH?=
 =?utf-8?B?Qzd5aWx0UVhnYlNUY2FDb1dYZ0tpWjJRWWN1NlUyK0tZZFMrOFJWQW5haUNO?=
 =?utf-8?B?SDd0WFhmTFdyNlZENnZoQ1NxRjVQWnQyR3h4aVZiMFFmNm1sc0VkMGVNK1dm?=
 =?utf-8?B?ZW9iZ3FQRVUxMWFCWHcrKzRBdkZvQnkxZ3JtNGJZRDBEdTNRL1dVdTF1eWVZ?=
 =?utf-8?B?b3FYaTM1SnVoM1BBdm9WVnBURVc2eWRZV0hiQUNxNHU5ZkVXQ2h5RVFvekx0?=
 =?utf-8?B?RnFrZ2hRbUt1d2t6VVJSV0NqeXF0KzYxRmZFSWs5NFpiU0tBSVU4UWhFZlF0?=
 =?utf-8?B?aHhvamJYZjNzais2bS9rNDB0eHN6bDJPdFkwMHB2b2E5Ykt1UEQ1YUsvcVN1?=
 =?utf-8?B?ekRUTFNCTXg5cGp3dGkxVmdxZGJhSWFQc2RpNENTN0QrK21Sa1hiQUF1dHR2?=
 =?utf-8?B?Uy95cS83SW14QmhOeUVWQ28zZ1h3emFGRXVOWWpaYzltOUI3ajhUVkt6MWpJ?=
 =?utf-8?B?NFlIbHBtWFhsZFBrTm9nNEM4cTAvT0MvaUxvQkg4VDNmNEVnUmxCWlMwTllE?=
 =?utf-8?B?Uyt2RmQ2N2VpbjV1SUl4amlXZVh2U0h6djViSEpjSmVtSy91NEpBV05nUWY5?=
 =?utf-8?B?T3RLTnhybUpuOFpsOTdqWTE2bEY2VzRHVzNPT3ZyK1J6VHRueWlRK1l4ZWlj?=
 =?utf-8?B?c3FlSjNxS3NRZURtdThUK3VQWDRsN0hKT1lGMFVaVm1sRGl0SUphU0MwY3ZJ?=
 =?utf-8?B?aFF0Ynd6aXhBTFRhdFlycTFwMmwxUlVOYnJFWnQ5VldmZzNuWkcyUDJvK2tU?=
 =?utf-8?B?OVgzaGJtUXhoZHBHOTJJVkJwcXZJc3NFdEFhQzUrL1JQOEJSZWZscys4TU40?=
 =?utf-8?B?VUJYTzRDUU92b2o2Rmp6NENMbE93VUp0bnZvYXEzSXJsdnVRUjNZMkMxakJz?=
 =?utf-8?B?aGNzN0JwOTVmZ1dWUGZHY3UycGU0cmVHUm1FMEh3bGRvSnB5TUU4d25qSW8x?=
 =?utf-8?B?cmRPTWVPK3g4eW9XTyszNHU2NGVTWUhTYlhoSjJScHdmckpCTFZrUW1Hajc1?=
 =?utf-8?B?QU1FeDZWc1c2NGFUUmRRVlo5RGNOeUtXWlNyZ0YrS1lIVlJJaldETTJqTzEz?=
 =?utf-8?B?TjRhWGVxVU1tUXpIeVJjWmt0SVVNUCswNkNnQjZLWHloRERMdmcyZEhBYjF6?=
 =?utf-8?B?ZTY5Qm1WcnJ5M3VGVDZjSHlqYWdkUnAwWk9PTk9wRmRnYUgzS0VrSU1KbWgy?=
 =?utf-8?B?Skhya2tIV241Q0FnR296c2FlRWo0d2xBZkJuTjRmREdSdXhzS3JiNXZBTHll?=
 =?utf-8?B?QmRhUmV5Sm5YQ05vR1U1Z2JLanZyMlVKYXJVYm52dUdqcWlDcFVmQ044cUoz?=
 =?utf-8?B?ZE4xZll5TG5zWk9XQ0hjL1Z5RzhPTmlKQkZnZExROWZuTEtla09TMmEwZEFr?=
 =?utf-8?B?SlpNMjNWSm40NjBMZzJiM3ZRbFltRUpLaEx5OFNCUnprZWFtR0VHMUZoMGVZ?=
 =?utf-8?B?NDc1N2xudHVzM2hIcU5WK0NzeWFSN2UwOC9lYVVRRWs2Y0ZyRFc3ZEFEcDI5?=
 =?utf-8?B?T1NydlRlQVI1clJ6bkV2TGsxaVM3cVNFSHZ2aDZ2TTYrcTgrYUV1dkJqQ2o1?=
 =?utf-8?B?NFl4Y1dJUWg0clpWUlRIVDNNMzk1NHhEeDdDdWpLSGVrdU4xbEZMSFkzN29p?=
 =?utf-8?B?ZUFQK2hjamVBNkllTUpJMThhOGJIakt4UThFUGltRzVBQnB0VGRMT1d2V3NU?=
 =?utf-8?B?a3FjTm5rd2NpWVl0SmtUcGpmZUR3cjdhTUxJSW5xbkxZWFJybTFFVzE0eE0r?=
 =?utf-8?B?YkVZbVM0ZHhhQmFBNXdqZEdxR25xcWdjTXVhUzVIWmlxNGlSb2xUYmRoazZn?=
 =?utf-8?B?TXRXcDh5MVAvUU9wZW5QQWl4RzRLVXdiUUE1bmhlMmFHSzNnRURUMTYydU1R?=
 =?utf-8?Q?fPH7Rnx8OGAA830a0Zsu5GWahdnWDg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGYzRTQrSmw3QnJReVVBTnY5MjB6REVVZmlXUi9iZkk4a1E0Z2ZhVDQ0c1h5?=
 =?utf-8?B?RHZTZEpiYlZTYTk1ZmhtckZzRkw4TGNvL3VzWUlQSVJ5ZnI4UEVuZWdPdW1i?=
 =?utf-8?B?aVNRcVVUc0RNUTZ6TFA1bjhFZjIwUnIzRXJ5UzV3ZnJubGNyQU13M0FzdjZN?=
 =?utf-8?B?NXA5Y1ByR1cyWGZ3S0JpNEx4TTE5RzBCbWI0LzlEL2YwM1pack5BYTNidWRZ?=
 =?utf-8?B?OVNRNEg1N1pXdlcvdW1za0NTVlJBdDIzTHJPV2RBdUNjcG1iTnhzYVVoZ0M0?=
 =?utf-8?B?SUJxKzVzNjQ0aU03RWJmbU1pdDJwdHY3ZmRMK2tiVXlPTDFwT0M0YjhKaFpx?=
 =?utf-8?B?blh1czlYWDBJak9xZWljcXFlMU91UVhUK3hkWEdzUkFzNnVuYkgvTnJuLzZB?=
 =?utf-8?B?ZlhldE1xUFVpY0NxcE91UGxOTGhrazVFbkZOK0dNOFlnSnJpWTNoRmM4Z3R0?=
 =?utf-8?B?TkZONk0rbGlDZVF0ODEvQVJRUjh2SW9DK0NlbFNrTlZJNy81dkp2VTJXclhC?=
 =?utf-8?B?b2FZeUNua01SREZVejhDR2V1QTE5Y2RqL2R1YlVHWU9zMEZRQW1ycXZreldz?=
 =?utf-8?B?REt5UC9weWEyNmhSSmIyRFFvSERkZmNucHc2ZlRtbUhueXk2cDZ4Q013QkJE?=
 =?utf-8?B?c1NTOEZFS0U2a0h2amRmb0lkSk4wb3RkVDhXMFg3TzhnYStyQTdoRG9tZTVn?=
 =?utf-8?B?MVJ4V2ZQOGQvLzZ5eHhWbVZLYWh2RXNZRjY5SFZNWUZ1SkJ6TXdTM3U4OGFx?=
 =?utf-8?B?ZlVwcG5vbkJTTnJVSnl2RG02VkQzZmJhU1oydk9oMW5wTm5McldscHozVFBP?=
 =?utf-8?B?YUlMNDFrcFJPRXN3MWRmMlVNRkhaSGpEbjN6QmFyMTR6dndGZ3RPMGVTLzZu?=
 =?utf-8?B?cjdmYzFqRzBSSGdGazZvYkJzOHFZR2FreDR0WWRJNHVWZmQ0ZEVzby9UbnBm?=
 =?utf-8?B?cmxEaW5jOWd3cS9HNFNHOW9Samx0UEZ5Y1NmVTB1ajQvN2tla01KQVF4Z0hI?=
 =?utf-8?B?RUZkYmM2aGdPMDI3RFVMOXY3RTFWRTAwaTNEcVJBSGQzMlcwV2R0bVhRUWh2?=
 =?utf-8?B?a0pYeGdNWFhxSjluLzFoVzMzaFJobU5TQ243bTBIc21ObU41UUEwZ0lLdGxJ?=
 =?utf-8?B?TDUvN1M4SnNPemZYZHBzazR4VkZoSkNwOE9kREVwWURXSENRWjIvQzg3UFk4?=
 =?utf-8?B?Y0VWSVBQN0RhV3R5NW14RzBMRzNVdlR6VnNjVE84RS9uSnF2NFdBY3ZMME5P?=
 =?utf-8?B?Wi80TFJ1RTE1OFNmKzQvNXR2ankrKzRYUHIvbWE1ZzYzc3FqN0kvVThiem1m?=
 =?utf-8?B?Z2Z3UFN4dFB3Z3NUblJOT1ZwbUtsOUFaQWFYYmRxZ2loSythM2dMOU4vOXQ4?=
 =?utf-8?B?OGtkMkdXdGJ5VGF4RXJmVDBiNUh6RWxDMDBYK283dVhWWmxBVzVsTEZhcWMz?=
 =?utf-8?B?V2RpdVo0NEtmcVFTeUw0U1VHb3ZwYkNzRHo2VVRFRkJmN1NydlpLRFo1dnhE?=
 =?utf-8?B?Ukp2ZnRpK29GalZvUnYxcXVRZEQ0K3MrSjhESyt3bUtrRHh3ZHBmV2QydkpW?=
 =?utf-8?B?UDdiQ3EyS3orWEhPMTROcU96Q2Q2NDRUSVl0QzlDQ09FVW94RTJ6YzlIbXd6?=
 =?utf-8?B?Wmt3YTdJd3ZnQ2RnK2VNZktFY3J1TlFBLzNzQ1IxVnhPaW1qSVA2WlpZekpQ?=
 =?utf-8?B?bXB3VVhBU0FsUjVDK2FMcFlXdExxbVNyMTRxV09PRE9NdEpEbTR3OEN6OU1l?=
 =?utf-8?B?R2luWm40Wnc0QUpaMUlqYkZMcmlZS1lINndCSGI3VGR4TlBhYWVXM0JLei9U?=
 =?utf-8?B?NnI2ZmR3QTZ0ck5BTjBWQ0NkRGY3SGZkUkpra3VNSGV4TUFVN0lWZmxOOWpZ?=
 =?utf-8?B?V1NEeHZvN3c5NHQ3OHJxM0JEd2ZrUEVYMXkwazVVeVJMbzVhQzk4RHNIK1Nu?=
 =?utf-8?B?cGNMb1ltRlJlVHlXQ0xaZ1BUemdnV2tWNUhPejdZT1JMQlNnMVVaekdHb2pC?=
 =?utf-8?B?b1VtRWRKWlhtWDlBZll2UHNqVm10QWJnbjRoODY3cTRIbVZ2N3Q5dVZQTDJh?=
 =?utf-8?B?NzRidE04U09wQ1R1emhOWnRiUGx4UkR2djBmNkF2R0NyUjBKVlIwV0dncTA1?=
 =?utf-8?B?ZzhCaVNzMEJYdUJ0cTdzdHJlM1dlc2VjZGNnejNsd0haZ0xjQ3NENWVoNEtU?=
 =?utf-8?Q?Zv3Be9u2UOOZqJlyNWHvk+4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DBC78AFCBA2D0408A101DCA63EFFD48@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4b8374-f222-4fb6-4a65-08dd9253ebd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 19:25:29.2369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4PsLR9/H1nodxTcsMmOMJVwz6O77CyZaGz2OLl27dS1rteJ8bBfubLqRKAuaZnvH8gDM6CuXffT99I/e/+zA8hYIiJgR7l2lEfv755rGqZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7885
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA1ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gwqAv
KiBUREguUEhZTUVNLlBBR0UuUkVDTEFJTSBpcyBhbGxvd2VkIG9ubHkgd2hlbiBkZXN0cm95aW5n
IHRoZSBURC4gKi8NCj4gLXN0YXRpYyBpbnQgX190ZHhfcmVjbGFpbV9wYWdlKHN0cnVjdCBwYWdl
ICpwYWdlKQ0KPiArc3RhdGljIGludCBfX3RkeF9yZWNsYWltX3BhZ2Uoc3RydWN0IHBhZ2UgKnBh
Z2UsIGludCBsZXZlbCkNCj4gwqB7DQo+IMKgCXU2NCBlcnIsIHRkeF9wdCwgdGR4X293bmVyLCB0
ZHhfc2l6ZTsNCj4gwqANCj4gQEAgLTM0MCwxNiArMzQwLDE4IEBAIHN0YXRpYyBpbnQgX190ZHhf
cmVjbGFpbV9wYWdlKHN0cnVjdCBwYWdlICpwYWdlKQ0KPiDCoAkJcHJfdGR4X2Vycm9yXzMoVERI
X1BIWU1FTV9QQUdFX1JFQ0xBSU0sIGVyciwgdGR4X3B0LCB0ZHhfb3duZXIsIHRkeF9zaXplKTsN
Cj4gwqAJCXJldHVybiAtRUlPOw0KPiDCoAl9DQo+ICsNCj4gKwlXQVJOX09OX09OQ0UodGR4X3Np
emUgIT0gcGdfbGV2ZWxfdG9fdGR4X3NlcHRfbGV2ZWwobGV2ZWwpKTsNCg0KV2h5IG5vdCByZXR1
cm4gYW4gZXJyb3IgaW4gdGhpcyBjYXNlPw0KDQo+IMKgCXJldHVybiAwOw0KPiDCoH0NCj4gwqAN
Cg0KTm8gY2FsbGVycyBpbiB0aGUgc2VyaWVzIHBhc3MgYW55dGhpbmcgb3RoZXIgdGhhbiBQR19M
RVZFTF80Sywgc28gZG8gd2UgbmVlZA0KdGhpcyBwYXRjaD8NCg==

