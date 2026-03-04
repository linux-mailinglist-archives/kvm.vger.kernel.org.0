Return-Path: <kvm+bounces-72760-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kL74K/O9qGmXwwAAu9opvQ
	(envelope-from <kvm+bounces-72760-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:19:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 30042208EC5
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:19:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 796DB303EBB7
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 23:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D313F364E91;
	Wed,  4 Mar 2026 23:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MsKA8/pC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E938481B1;
	Wed,  4 Mar 2026 23:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772666345; cv=fail; b=ezuZgUDlD6K3KJdsPtFmIqmcTiGdZ0LfhrxHIekbB2EOW8ukJB3my5WEbeNC7EcAQCumCNY/5CUcwh1kDESZkHMSPXzLCI37dEZsP0/0lUY3Tmlk7tNfLH1Fu0zwPWglRchGtIqft0BwiQnMpQgZPeYsqzMUVRqV/bQfsF/JAV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772666345; c=relaxed/simple;
	bh=TiBI7r0T7qR0sZLOum0cEDLk4KYvWwOURA9SjpFxG3Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cptlKyrob4IfK1QIUx3f0u/7lGwF3nL0u7b+XBeoMfchERJQAdgoSbqlsT+ERIQMen+aGmTKCsd94ajWeKeGu/AFN9LURcd73JePy6qCI8qL126OtleVCBGjIbA08jXw/QzirG/7/kFCu7KphpEhF58uZOfh8C0vsCC8IVS7kDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MsKA8/pC; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772666342; x=1804202342;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TiBI7r0T7qR0sZLOum0cEDLk4KYvWwOURA9SjpFxG3Y=;
  b=MsKA8/pCDu1s7fbBa7iepFNJ4pHVd56Ofwt4uVHe4CcFFhtADrcEz5ZQ
   SPG0Xs+sxAUUnLXKexsEEOEl/WdnfSlWGHHlOilTqaR1y47CZmY70cOqJ
   KI8s/SmpFcI8JzT4J8z6wdUhjOLN7LlRXN2uxpSrwm4QmTwtR8ae/l6af
   8I4FFMdQAcWvaUJBLQanQpq+ZgovbmT7LpBUuybGf7qr4/LngC4lzs3Ny
   2Pg/OXXx+bRktYTWPviLaAmy+Y/1TK713S01FzI5IUtqF0HEa4rGIDZ4R
   nvWXxlw9BeG9l2j129JdEXSm/O6wrml6YHU3v6LZwFeTEdulKNmR/SNvc
   g==;
X-CSE-ConnectionGUID: pVc18+cwRqeLD45/49383A==
X-CSE-MsgGUID: 6HhPuuOTQLO1xq+3Yb+6Lw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73649189"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73649189"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:19:02 -0800
X-CSE-ConnectionGUID: pK4UO1cISKarsccVHGQaTg==
X-CSE-MsgGUID: 7tHfvCVMSEqgiQV6UfFaNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="222634792"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:19:02 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 15:19:01 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 15:19:01 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.39) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 15:19:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ujmI0qNU7O+PHA1VAxD9yXwczH/dgOM7FPIo7A5ZmvphGDkDUegqlVS3iOdj8mQB+tV6T+jmXl5PdKdLvwBl/m8EOcobkLisCglzd04XzkpE59X+78HUzYOWY6kZ97PkabAFigi2D3D/zwKpOyNgBgplBzt2/fyMwaHc/NBX+zl1rC/M88cuIXPFCM+mLJbCwnNElt/c/j5tDA14f0Yad/5+TkLozQkEFcix/VOyG9GYSBANI8cXrYzDER1RvHwFf5tq5xqQrhZKn68xoYV5TTKWDlkQXZc/Kn4s7aLfzRrRKcNBFY0hMTPDpBND8+f24FkwZAETISsuULDV9+UiHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TiBI7r0T7qR0sZLOum0cEDLk4KYvWwOURA9SjpFxG3Y=;
 b=ZUxMAYCt9aj8rXG9vQSfVqNazg3fwA2Rqb8dg11HBBFBP+g+6F3Y3+IRLzydNldJEf7eSU08z+F+9A8lKvEL1imwce/qN0QNCY/zfrTEGtAlUU3lj3tNmhOXd5B1BJArI2nne/n37GOn03LTEEQxmEpykFJPfqzDfGqDp00zvQRHtDOcofzkWPrKqVQs6/rZqr07K8pwiBvZ8xMExU1MRv3yWIXBLxapb8aC4gsGckkQ1CkSrp3h4ibTXFlwbdJ8TGBdqseuEQbrmf5bjXBEE/X2o/JCQgWdvsbGTljNNTIiT1N8Q1ONkG76qlixbzAcQguH1OTZAykPWZp/HY90JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 DM6PR11MB4546.namprd11.prod.outlook.com (2603:10b6:5:2a7::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.17; Wed, 4 Mar 2026 23:18:56 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 23:18:56 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 17/24] x86/virt/seamldr: Do TDX per-CPU initialization
 after updates
Thread-Topic: [PATCH v4 17/24] x86/virt/seamldr: Do TDX per-CPU initialization
 after updates
Thread-Index: AQHcnCz+ttZiTKBNQUayZYONONXJdLWfIiSA
Date: Wed, 4 Mar 2026 23:18:56 +0000
Message-ID: <721643a90031feef6e8a313002e9b5f82452a3a8.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-18-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-18-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|DM6PR11MB4546:EE_
x-ms-office365-filtering-correlation-id: 74a09bd6-bed7-480b-ca7c-08de7a4468ba
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: /LLF3dTH2Rt+fxWdU3VcdAZCGYzxMtmHcTEP3u8rIk6+Agnw8vGMT49MS4cwEG1zMIWDjSPxzlu9zmrgEIqskenArOuCd2mqxtDDgMeEF5pUFUO4dPjAhi7LGEGiyjqeYiKKCdvT6+PK9aGYaEpNCH+eLF8CnyOfGq3XVtrn5AIs2OTKOiUDCwXFvyZHR22I3Z8cHqIgoYdn82n7cA7+e3+HEtH9/wd4b7h6o0JGNStxToRdAploAtb2jh3dZ4xlj5GR4R9lebuAfBjP18lNtpmRLOvVlPmBvhRQnpph/zeUcmVa1EbjlANZXjILXTtuHvOlT6VO8mWZaDcrew3h6wm4dtgsHGcKiTHRVqryPaNtiP4V5Z7LWwlCPHOj0L/e64nyS3KwCsxmeY0KHKPCfmBYPJ2R3Y48Mm5/K5pQ8hOTPyv8m7FeX3gFxBoQnAG/3CehbS4V+rZpMquF4h78j3sn0ZEV7Q7cl1cLvVcuass/V0WI4qpVqGzJl2O6/dbCJ2y54EtKFNAqhpQbUcMD34Zj8HhJavzEI56wG6tGAdpUnUlC4srjEJC/c351YnDSvb5rVE9y7xGEczSsbYGRc8AdY94dijJdLCpAUaRZiWmoNGXONI3sI48W3fSrUZaiuV35WatCacEuLKIWDYPMLiD71UFbQn32CuXjH50qNxaqc2FxX2OlYIGL/rISv6UfibZUoFPylFWLtVVlryjtka6G5Gt8naerSC5NtprmE/LDrPOi4LMjCXuYS7rKxda1xerh3qmM2dtUbRhspPm/ae+6DWitLeC1In0OqSuUGvo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUlYYzVKWm5ldTh5bG1PUkM1Kzd0bis0aGdiYnJhbHAwb2E2Z0dzOFZQc0Ix?=
 =?utf-8?B?bDRHU3hnWllBbUVzUk5WN3BEaHBvSUpNa2xSZkE2ZUtPUlRrdElDQnpWTlhU?=
 =?utf-8?B?eFJVRHVNRHg4aStRaWdweEFPbEI5b2Z1eXQvdFJYUkk3Qm05ditrZ0Z0VFNO?=
 =?utf-8?B?UzdRRHk3ZWVJZll0S1lyL0lEYVkxMSt2UTBzSEk2SkhPUjh1R3VZMk5idVZK?=
 =?utf-8?B?ZUhvUUlOZkpmcTdCc0FDTE4wbUp3RE1YSjRwY2lUMXQyWjVqV0xmclVOR0w0?=
 =?utf-8?B?cmY5ZnBvakF6MFl0bmxnZHlReDMwYVhEa1N3S05rNjU5bXl1V0NhL0tvaWNJ?=
 =?utf-8?B?MDYyenFwSHo4ajg2TEJ2aUlpdmdiLzVnWTltMnFLS1FqU2JZNmxTQ3hLY3pM?=
 =?utf-8?B?SGVXMU00OHVMV0Rib083Mlh0TTA4cEhQMDY0cVJ1K3FFN21aQnZhN3VkYUFW?=
 =?utf-8?B?YUJOL05BanMwZGN1UGljV3lFN1ErSnBSTWRiUU55YS8xMTFzMXdMa3R3cElO?=
 =?utf-8?B?QmY2Qmhsc0hid0wraHlUMHl5Nld2akl3TFNjTWZHRE55ZmdNUGZrM1ZBSjd3?=
 =?utf-8?B?WU10bE1PQXhhOTRHV0dJb25vVkoxQlFiSjk2RXpYeS9Gc2tVaWpQRDg4ODA2?=
 =?utf-8?B?VGJ1NlhlVExLRWdOMFh0a256dUdKa01acnFLQWRqVU5xQXpyTXFvZ0FMTWxl?=
 =?utf-8?B?TDMxZlVhM1k0Ym1iVno3L09IbWhRR1FsTWxZRGdDeEJHYkZaY2ZJYVBUNU9M?=
 =?utf-8?B?NXFoNVZsWjV1YmFKR25oeEt5QTF6ajRidFdLYnNyN2pZN2ZKd2Jjd0s3QnRo?=
 =?utf-8?B?ZWNNS1dNamVQdUVBbkNTRHZlaUNzUW5oa00zNWY1d2QwVnU4dmx2T2Y0K0Vx?=
 =?utf-8?B?Y3ZLZTVrcExvc01WbHVwVDBYbWN2TzJHQlMxMUVXVmJ2TWVtZlJ6ejRaZjFD?=
 =?utf-8?B?cXU1YldYMzFjN0FBQTRaZVBxL0hWdG9pTldTcUd6T0xnYzlvS2hVVHhMbWY2?=
 =?utf-8?B?OFhhV2pEQ3FENExEdkMvTU9rRzUxUmpVVHZDR3FoaGpkb0thMFFZL053MnpN?=
 =?utf-8?B?MG85Qml4VWRYVTBOTWphSURVYjVTWWx2UWhIRjFmTEJHMzFjNDFNb0ZrNTcr?=
 =?utf-8?B?Ynl6OW1HOXNEd3MrZlpMd09RVmNQWm5RRUJuOGcvSlJKaXF1TUo2S09kdlpR?=
 =?utf-8?B?OUl1SGs0UUgzSlRaVFhieGlPbERRd2VFNDcvOXRmTnRvR2xJRjlyYWVGVnZV?=
 =?utf-8?B?V3h2WVU1blNZU0pQVGRVUndIYVdjYnlCWFE5KzEyd2R2eXMvVTdveDY1KzU1?=
 =?utf-8?B?cDBTOGx1M1dxNTUyWjNpdlJxN2U3Y2lNN3VvU0NiQjVITWJjZzF2b3JLZmc1?=
 =?utf-8?B?NlFuV0ZlYk1WSmxNKysrWnUvcE03NXdMbDFud1NCT3oySlhuWkhONjkzTVZ2?=
 =?utf-8?B?NHZNU2J6QmVOZnpOKzFnRTIwTzBOZXB1bzgxNlNXWkRacUJNcDBLcXo0YjdJ?=
 =?utf-8?B?Syt3VG91OHNPQ2h3TkVabVNERWNvamZZdVZVZmlUeTBQQ2ZRSC9halhXaG1x?=
 =?utf-8?B?U2gwT0VSNVJwTG9rV2lFazNkbjkva21TWWtPR0s2ZXRlQ29WSDZHQ095Y2ox?=
 =?utf-8?B?TFgweFFqU2FCNmFpNnJ0TURET1FQSHhvWi9IcW91RFEyYlRtK2pPN1dHcmt3?=
 =?utf-8?B?dllpLzJJRThJN012NTNaY3B1Q2Jyc3kwM2IybXpYRXg2YjRCNzkyYUhpNTRh?=
 =?utf-8?B?UjZkemNRY3ZjbndqdVkzN0NyaFpaSmREaGdFYzgzbkY4b0QyNDZKbno0bTJ1?=
 =?utf-8?B?bGFRbFpMeHRQbUtXVURWVkt1Zkk5Z2pZd1k5YVV6L2V6YTNlaE9UQ3VkaWpC?=
 =?utf-8?B?anpjV0N3aUtLQm90aUd6SlVrZEhkancxaUZJWStLbDEyNDNLNUkvRkxxQnpG?=
 =?utf-8?B?RGFoQlZna3BMeDdIdGZVUEZORC94a1g3QnpFMHBTSllOb1dFczc5TzgrUWkz?=
 =?utf-8?B?U3BFZ3NLckorVGZhenNUT2RrMHhzbWlmM09MamJWUU1VNmN6TkJLZ0ZjVUh3?=
 =?utf-8?B?UzhyNjIwZXoxTlNOdWZ2ejdkZDBEMm95YjltQzh4VGxCbzhnRVhoV2NuUER5?=
 =?utf-8?B?cVJUdnRTdGJpOTg2Y01wa2VCSTd3RUtGUW5ZUTdpNTQvbisxMkdYT284WGd6?=
 =?utf-8?B?Mml6ZUtNVFRjbWk5Y2RxaVJTNzcwOVRMTjhzRUFFQWFOTEdMbGRYa1dkME1z?=
 =?utf-8?B?bWNyempweGVPRkpvQno3bWswMG9ITG00RTdKSkF2TU5CQ2hMeG12eFlpY3hY?=
 =?utf-8?B?RDA1a0s5ajVIOFhLVG1EK0haK3czN0FGbllCTGNNMmVRcjFJanczZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <37B7572E41BDBA44A09D6395757A4D8C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: V4vQDSNNVe6VvOgAMbiQSvNJW6Ws+9lY/o3ZEeXNzhsudCSe0KLy+iJL7gUxGyYFPkIgKj+Cz2+6Ty0C7XLDAyYPGKBLYT6TInhh8jSnRhJ4u3mKVKKxEN1eFeMkjXvr3fAInyrNm84OD6PrXgom6PRxF3ZQc6Z8EhDzPzg+gpDR+evPgGKjD+L6GnXIt92cdoShNqYAxvJPvs0Z1AeulgjFPMyBOytz5ZwwnttHQ91Bp47jZuoTT5mK4NAXLdQfFG+Eisf8J8YAv9g5X9NxyTIcpKq6XV0T3rFAjvc3y6ubiLrctoYwGPUzwN2eFE2julB/6ZJWUuHChKtGTBanFQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74a09bd6-bed7-480b-ca7c-08de7a4468ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2026 23:18:56.6067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6+8QstXk5m5kVOIEQQzO5ypzfvzDO/Og9JkKN1+vQSUOUxvu9gRLgl+K4nNl7iCVHHC/ayn1cCFojvZXYKlkXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4546
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 30042208EC5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72760-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDA2OjM1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gQWZ0
ZXIgaW5zdGFsbGluZyB0aGUgbmV3IFREWCBtb2R1bGUsIGVhY2ggQ1BVIHNob3VsZCBiZSBpbml0
aWFsaXplZA0KDQpOaXQ6DQoNCiJzaG91bGQgYmUiIC0+ICJuZWVkcyB0byBiZSIgPw0KDQo+IGFn
YWluIHRvIG1ha2UgdGhlIENQVSByZWFkeSB0byBydW4gYW55IG90aGVyIFNFQU1DQUxMcy4gU28s
IGNhbGwNCj4gdGR4X2NwdV9lbmFibGUoKSBvbiBhbGwgQ1BVcy4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+IFJldmlld2VkLWJ5OiBYdSBZaWx1
biA8eWlsdW4ueHVAbGludXguaW50ZWwuY29tPg0KPiBSZXZpZXdlZC1ieTogVG9ueSBMaW5kZ3Jl
biA8dG9ueS5saW5kZ3JlbkBsaW51eC5pbnRlbC5jb20+DQoNClJldmlld2VkLWJ5OiBLYWkgSHVh
bmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=

