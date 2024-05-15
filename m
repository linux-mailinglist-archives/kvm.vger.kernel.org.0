Return-Path: <kvm+bounces-17485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 034578C6F59
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DB171F232AA
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442265337A;
	Wed, 15 May 2024 23:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IWqRe/et"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3DD4F8BC;
	Wed, 15 May 2024 23:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715817392; cv=fail; b=tfvYWOz66YiOVqnVm6KIbZQp43x+yTWHgqIQ3mSRceAJ20cRP0Kq69BYa5e7Q8vo7kz68EAl7azjvz9clWSCU1u0xBOFBYEaT5C6Wxz/tOvfc9Ze41JNUAOSgMFyOLr/m0/WZbedLjWw8jjBYsrkWpVt4fRCiw39paXeeoT0UUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715817392; c=relaxed/simple;
	bh=dHuckR3LQEb/+/lze+v2Hvcgygy9GvFBCIrEGB/JyUI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kuS70Ie2ZByWPJV/d1128j+eiXOZeXKSdJ2nqNdP/nciils0/Qm9x3El7m2o5VKwdyckxIviWkra2pzeItiW8l/C+qHqQf/EZj9qKkg1WwQCYS3fucWVPHtlwyXUj0W6iCd+zYdCfDskkw4g8zl2bWnCZGhJNpWyUg8XZJi1noM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IWqRe/et; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715817390; x=1747353390;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dHuckR3LQEb/+/lze+v2Hvcgygy9GvFBCIrEGB/JyUI=;
  b=IWqRe/etuhQk3fBsqA7JLor7Vdk1FS6n+jhtTraD6VmOPatS7XQzaOXS
   M8QTs8x1kf3RudlN2kgMr2NyXHiQzXJx4l+O1vpT8aJXNtiUgKoFB6OlT
   WZ7RsYgChIEroFhr+tj9s1qGGjEvm5w8Nh3GIUmoxCN5ez1p+kywrZOAT
   CTO+of8hxXrmAv5AtJRyV3zwfY/7hq9ioEZEl6PTxiDY6+oXKyviuUi0Y
   cyr0Te15/UHEpa+9VnBsx2UL9GQNCR9hwMPcVUZF1oHc6yDkJd6t9rGaZ
   0tufA7DxX9lmzwa9sVmv9/JtMR+fyzLgYiaZudz4ANgF6Fk0ulnTUI3hM
   w==;
X-CSE-ConnectionGUID: iOhrQBspR0+z4ggaBlXq6g==
X-CSE-MsgGUID: rzu+dzvxQ9iG/gnEEpBusg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15724444"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="15724444"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 16:56:29 -0700
X-CSE-ConnectionGUID: j7hMvIKiTieh4FZziwX0Lw==
X-CSE-MsgGUID: R/vd80xZSASfYrYsSBfXwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="68687372"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 16:56:30 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 16:56:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 16:56:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 16:56:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgmQvC9ihJ0kSSOIiB9mT4h68cYGVXnIi0YFbcJ2vlion6sruoGddGDscEiBCyfWxkZUVWuMAIY6Nwg/t9fLVWOeGGBmGLXdNDm1fu6JGNFMwJmeGIrorGXRiZkO+ScryLh4WBT2eQcdVK06B37XZxPCl107nWvzoh42xd4o0sS9Tf91z9L+Zv2dKL9UGHfRm7ursn+MFc3eU0+gpQ3te35oEwX0D7XB7Nrc+sS2UoAfhP72h2uAxQWqDu0920mztEt6aDC9Sx2OPlz6PLXREwPJ6aHOx8Ih7yeN6VvrX7uoXk3AH0KvsPGiAFw6y5MR2Ny0EeGRcGzjgJXk/gq7pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHuckR3LQEb/+/lze+v2Hvcgygy9GvFBCIrEGB/JyUI=;
 b=Wuzj5su8BPbKXGsTWpOSjmgZjn6qfuK4o1kMrCQoeXPso1OmW06bUElSA5XUfxf4S4jmZQxloqCOezBW39Op42TFK4AojtZJ1SAoqpkJ6L4zKp4vDcHIiKu+tJqPcAkLimk30o+2Bx2LuY/rk497M1fdf2RibraAD5so+mG2FdlWYd+F8ODqNGu3SabjVWNgl7gmlWIS7MnDRU5jLLX3clcgwoq8bO0zkJAIPrIPcgocXB0/j3tHBTlU8JkCvLpEE2qm/tRd1avZILyDOQtRwYRGfcLiyorISaEFAGF65r8z3ahGlzxes+cTzjtxGwoD+qlwW6NP5rDDNcQP9bHIHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB7127.namprd11.prod.outlook.com (2603:10b6:303:221::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.25; Wed, 15 May
 2024 23:56:18 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 23:56:18 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Thread-Topic: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Thread-Index: AQHapmM+V0hpZvOG4Euj+PM9FPWPubGYSbqAgABgPoCAAAP6gIAAC9oAgAANSYCAAB/SAIAAE0QA
Date: Wed, 15 May 2024 23:56:18 +0000
Message-ID: <ec40aed73b79f0099ec14293f2d87d0f72e7d67b.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-3-rick.p.edgecombe@intel.com>
	 <b89385e5c7f4c3e5bc97045ec909455c33652fb1.camel@intel.com>
	 <ZkUIMKxhhYbrvS8I@google.com>
	 <1257b7b43472fad6287b648ec96fc27a89766eb9.camel@intel.com>
	 <ZkUVcjYhgVpVcGAV@google.com>
	 <ac5cab4a25d3a1e022a6a1892e59e670e5fff560.camel@intel.com>
	 <ZkU7dl3BDXpwYwza@google.com>
In-Reply-To: <ZkU7dl3BDXpwYwza@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB7127:EE_
x-ms-office365-filtering-correlation-id: adf26bdd-c503-4263-140b-08dc753a9d08
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?UEtoOGFYV2hjZzZmK1hCWDFscW0wS3BHRkI5ZjJXQ2RHMFNqejR5Y1lqUVpI?=
 =?utf-8?B?Q1MxeFpqcEt4cGo4T0Uyd3pGTjR6eUdaVkNEdVh1T3o2bnB3RjBWczZFY2pD?=
 =?utf-8?B?cXdMVDNRbmh0cUlEY0tPRURaUUVqNTN0TWFmWm1URnA2Qi9YNThrY2R2RkJV?=
 =?utf-8?B?RFdCdkpvVkwveFUrVE5lOXBOd0wwcXIrb0o5L29CUkhTRjVLZ2hVbDhlbWJU?=
 =?utf-8?B?RzVnQXRUR0RVV0dPZ0ZWUGVkUk5FaWZHMzVjRXZVRTY1a2FKakZKR2plb3I5?=
 =?utf-8?B?UDN0aE1mclg3N0x0ckxjdU9MRDdvOFdHQ083dU1ZVXliNlNjZFFxRmp6SGpP?=
 =?utf-8?B?NnBGLzZ1QlgxQ3JGcWJJN3Y2VU92ZCt6NHQzOVEvNXppYTg3WXZHSW05ZFY0?=
 =?utf-8?B?dW5RckEzU0N6aldSSExVak1UTzh2ckVnTXFCTzRleW1CdkZIUzU5L1hsb0Ny?=
 =?utf-8?B?Q1ZFek92emRqZ1gwREJxeGNuN0RrNnpMMGpMcmJRK1EzclhuRG85M0hYUmli?=
 =?utf-8?B?OGJkd1VDeENpc3BIZmlyS3BFbGplMkNBWm82MDJNcmVJdFZjZERkWW1pQkZq?=
 =?utf-8?B?RVdKS1ZUS0F4WUVUb09RWWJTTG5nL2VVNUFsbk9ZUWdLd0piVFhNdEJRTVE3?=
 =?utf-8?B?bEtyR1dZbTRhQzZKZlVOejRlQXFpa0J6V2x0dFRhbkRsZVRPbHZ1SktOL1dX?=
 =?utf-8?B?eVFCMmE5WmkvY0pMVExmR2tWb2o0d2F3RGlQTEVTWVlZRENaSFJ0U25VMjBY?=
 =?utf-8?B?cUx1STd5Q2N3REJtb1I2MEhIRTV1VWVCSFNZOEpyaEVsRDRISDhXYnVHY3Fn?=
 =?utf-8?B?MFVpZlpNUDZ1alVVNkd3WnJxV1dOaEFLd0hrYmpmMDlSOUY5VWI0NDBVUFdo?=
 =?utf-8?B?eXB6cnd6anVYZWMyS1VxTm93OHc0TWovRFRRdUhvbENkcFpHSTdmYmNKY1lH?=
 =?utf-8?B?U0tpSkJaTCtpbThBbk9POHhCcXpRalUwTjhyUmUwYTFVc05tZ05taXlKZjNm?=
 =?utf-8?B?b29rbGl4MENsVzhwTUdZeXZTNkxNakRBK1VwQy9TL1JRdjBHNEVzcmNVNC9X?=
 =?utf-8?B?N2E2SFpuTmU5b05qYXJGYks0cFgvUTVVVWRHa2drMnlBQlAzOThFY2ZvYjdz?=
 =?utf-8?B?SUs0R09kRDZDSFU5cERtNEd6RVBUQTY1SEwzTEk0THdGYmJYTVo4eTNhbXNy?=
 =?utf-8?B?cDZhdmk0NUNwWU56bERKUkw2SnBZQmIyeGtaOEFjaEs1Q2NVc0h4cm9od1FB?=
 =?utf-8?B?L0ZWdmlHUHBub2pTMkIwekNlM3dGOUd1NlZlRkxOd3Nmd1RwVEtUSlQxTW5I?=
 =?utf-8?B?OHZLZktSN3BTYXB0WUVsMmE1SXR2T2hlNk9pSjhSN0hOdTdJSitkVjNPbU0v?=
 =?utf-8?B?SU9oWEh3cUkyQ2g4MXZDdmhRS0lTSG1BdlVTZUJXejM3UjRKRFV4OFBsbmc5?=
 =?utf-8?B?ZkFsZ0VtSFF3Vm1YUDBoNXFYcnJyaEh5NTFoSUwxaDZSSmRuZTh4SjRQR1U0?=
 =?utf-8?B?WWRPaDdocDcyUFlkb1p5eXZpK28vR09DaGgyU3hZUzNvd2dzTHk5UG9tZTQ2?=
 =?utf-8?B?OUdPOHJBOU94UHZZbnJGNjlLR1dyczkwTjZDaTdDd2hQMThObXpDVTVNaUcz?=
 =?utf-8?B?SHlaZ2xzcCtTcFpuS1ZLcTF6R296U0k3M24rb1NiWmhTOEV2bUZ0QURxNUtB?=
 =?utf-8?B?Rm9YK2MzeE9CWnFndi9BQzd2OExkNXhwWTFHaXgyRmtVa09xQVZ2Ly9NNjN4?=
 =?utf-8?B?RTJPcEpSMTFZbUUvcmk3emNjazlUTTc0MitNV09jWmFnUzFtWlNhUVh1eXZn?=
 =?utf-8?B?dVQ2ZUZrUTVoQmpYWC9YQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkNuemdOYTEweEFYZHJhVk9EZGRDbmRNTE4rUENvNHAyNEhBbktpVytVRGJS?=
 =?utf-8?B?cDVnLytZZUVkek5QN0h6TEdZeDJvOUFmbC9EVnpqTEtkbmtlSFFiTVRkUldL?=
 =?utf-8?B?UlVsTit0b2dUSXNrMDIyS0JNL3BaOHJJaTNuZDFBekZQOTlPVTVHazJkd1R5?=
 =?utf-8?B?Zm1sTncxVEZIWE8ydXlYeDd3bnEzTkFocC9ZM3Irc3Z5WDV3OFp0a2t0SnVp?=
 =?utf-8?B?dlhib0xUbnM3dUptaS9MYXN6eDNHNjNVU3hvQStHZ0oxbTBEVENGUmYwcXRh?=
 =?utf-8?B?T0l6bWNlZm1BOGNSbHNTNHBvVExNL0c2K2hqUVptK2ZUWGhLNDVyQ2h5VUNH?=
 =?utf-8?B?U0tWS0ZSLzRYem1qaVNha3VXNzFOYVRIRkFNUnl2SXhleElrR25IbEwybi94?=
 =?utf-8?B?V1pGOEd6R2ZTNnRjUzY4ZDNPWTRYYWRsRVkvSkN0c3kyUUgvSE5QSDEycjNj?=
 =?utf-8?B?SGw5dkVnRG8rWXZ5NHZVZEIrVU9LRDhoREtBaC9wVERFUDExSW8wUExraTQr?=
 =?utf-8?B?ZVFOOVkyUjBuSEtvSlh3MktRYkdkVkdoUU45RDNweW8vZVo1T1gxQmRGcmYw?=
 =?utf-8?B?Ni8zNlBTVEJTK3pheW80ZDdKZEJlajNBdi9uTXcvZmhKZUZSclJGc3hXYXRz?=
 =?utf-8?B?TFdjcDBGdnEzYzgrQzh4M2lUelNXMEVGTEo2T2g0SE9TZnZybGRCWE5KRWdo?=
 =?utf-8?B?RFl2bWVuR1FOUFdSRGJUZzJXNTJMbDVCcUx3cnZic1hEVHQ2eG11ZDhwTFFZ?=
 =?utf-8?B?NFZWUHRpVkFhZGJvZ084SGpTS3ZoMFg5QmFXK0EraERYSEFLcDdKc09IR1ha?=
 =?utf-8?B?MlBoVDhGZE5NVzhkYzZaYmNuVFEwVnd5NFE0L29kOWQ5dE1rcGxGS1NvUUlv?=
 =?utf-8?B?N0M4VStEQ1pOaUtBMlFSREM4Z01hbUEwVkZTMWhlSUZKbXlTUTY5QnhhVkIz?=
 =?utf-8?B?Q0U4eTRLWHkyQjVYSXFycmJ3YUI3aXZCZjM2eWJYOVVnU2ZDMkZnMEZ1Yktt?=
 =?utf-8?B?RXNZZ0Y2RTBhSTBPdkRuVVd4UXBqTGxiZDI1QncxOFROQ01EYXlOd1R5aTBq?=
 =?utf-8?B?RzJManBFektrcUhQRmZYelhCYVZhaEt6aGNzM2loRWxLK0YwR0lTenQybWhF?=
 =?utf-8?B?S29RTmxkcUt2cmplQ3I2Qy9Ha0wwQWpLSVV5bVVER1IrSjFYRi83MTRSTkhk?=
 =?utf-8?B?czVxeVd4ZHdMVEhRb3pta0tVV0ZjczRVN3BjQTFkdTRkZkdpY0xCVHdvQnJS?=
 =?utf-8?B?Um10S1gydmwrcVNlVkwxNjRhbkxOVW45SlplU2c2bFB4bnNXbjg0RWQ1bXFy?=
 =?utf-8?B?NTV4VXdtRnUrV3J6THFQWFYzOFR3TzNuaXdOKzQ1T3d3ckZwT1c0dUlCNElB?=
 =?utf-8?B?WnYxdTdjWjhFSncrMERCNzJEZGlMSXlWZVp6ZWs2Q0V3Wm9yTTBkOWs3WFgw?=
 =?utf-8?B?WHVvL2tuQ2xoemVtNlRsYldaZk1ibTg0OXFvN0YwanBwT3gyc2Y3QnF2WG5m?=
 =?utf-8?B?UmtYV09Vc2NxMGZoQ3JZd0FnSExPcmdLR2MvUVJNY0QvcG8wbUUrbnVOV2ox?=
 =?utf-8?B?bkg3UlNFZ2ZkVEtESlZpdlpyMVBZa0RKczR5MENJSW5DUDJ1bVRjNGtpZlJp?=
 =?utf-8?B?bEo4Yy9nblcwdTh6Znl1NGIwWnNPY1Bac3hRa0pxeVFkSXNqcW1KYzlNelkv?=
 =?utf-8?B?MWN2KzhqZnJ1V2R0ckU0TkJZWjJRM2trRGZtVWllS3hZUnUzSFNqcnE3YStS?=
 =?utf-8?B?cmdKNUhvc1E5Yy9rOUw4eURDMlNENU1ITUliS3ptK0JBN0dwQ1VYRE1teFZK?=
 =?utf-8?B?NHkycjFRaGZIZll2WXhUTmRqVFhrNEJ1YnZ0TDZQRHNZcVV1ellYRnZQYzRl?=
 =?utf-8?B?TVlDeXd3RTgxdWFDaGk1S0crK3FNcVFCOGVXWUN0V2F5YlNPaytQMU1HOFhD?=
 =?utf-8?B?STgwMzN2Q3dNUDJ0T213YnpKSlAvYkUvaGJLNjFybm1XL0NKOFV6R2NwOGI2?=
 =?utf-8?B?eUw4YTQvdTZycERqSzdPbHFNVjYzWnVCbG5LRUNWL1lQcEN2N2RJNG1YQ1NS?=
 =?utf-8?B?UTRTUk9OWjBIZjhSSVdKNlVpUkpqWFNra2puajdSUk5VeDhLM0I5NGNIME93?=
 =?utf-8?B?VTNybGN1SHQ5a0VYdGIxbU9CVWZaQjg1a0VPbVhyc1BTbUhSbnI0dEFlSjVF?=
 =?utf-8?Q?bgKcBxeYg/OgZfnXVXe5uoE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C96B15D441C18B41AC450B477EF9DE79@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adf26bdd-c503-4263-140b-08dc753a9d08
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 23:56:18.2552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tsmJ3VNADB0n8TsvPrf/5c26ACqA2c8Celi63817xrAjSnqhPJIZHLow515VhA1hXEYKz2s1dzMEgN9r6iTeDts8TugrUXVusIzrAAedEeE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7127
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTE1IGF0IDE1OjQ3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEkgZGlkbid0IGdhdGhlciB0aGVyZSB3YXMgYW55IHByb29mIG9mIHRoaXMuIERp
ZCB5b3UgaGF2ZSBhbnkgaHVuY2ggZWl0aGVyDQo+ID4gd2F5Pw0KPiANCj4gSSBkb3VidCB0aGUg
Z3Vlc3Qgd2FzIGFibGUgdG8gYWNjZXNzIG1lbW9yeSBpdCBzaG91bGRuJ3QgaGF2ZSBiZWVuIGFi
bGUgdG8NCj4gYWNjZXNzLg0KPiBCdXQgdGhhdCdzIGEgbW9vdCBwb2ludCwgYXMgdGhlIGJpZ2dl
ciBwcm9ibGVtIGlzIHRoYXQsIGJlY2F1c2Ugd2UgaGF2ZSBubw0KPiBpZGVhDQo+IHdoYXQncyBh
dCBmYXVsdCwgS1ZNIGNhbid0IG1ha2UgYW55IGd1YXJhbnRlZXMgYWJvdXQgdGhlIHNhZmV0eSBv
ZiBzdWNoIGENCj4gZmxhZy4NCj4gDQo+IFREWCBpcyBhIHNwZWNpYWwgY2FzZSB3aGVyZSB3ZSBk
b24ndCBoYXZlIGEgYmV0dGVyIG9wdGlvbiAod2UgZG8gaGF2ZSBvdGhlcg0KPiBvcHRpb25zLA0K
PiB0aGV5J3JlIGp1c3QgaG9ycmlibGUpLsKgIEluIG90aGVyIHdvcmRzLCB0aGUgY2hvaWNlIGlz
IGVzc2VudGlhbGx5IHRvIGVpdGhlcjoNCj4gDQo+IMKgKGEpIGNyb3NzIG91ciBmaW5nZXJzIGFu
ZCBob3BlIHRoYXQgdGhlIHByb2JsZW0gaXMgbGltaXRlZCB0byBzaGFyZWQgbWVtb3J5DQo+IMKg
wqDCoMKgIHdpdGggUUVNVStWRklPLCBpLmUuIGFuZCBkb2Vzbid0IGFmZmVjdCBURFggcHJpdmF0
ZSBtZW1vcnkuDQo+IA0KPiBvciANCj4gDQo+IMKgKGIpIGRvbid0IG1lcmdlIFREWCB1bnRpbCB0
aGUgb3JpZ2luYWwgcmVncmVzc2lvbiBpcyBmdWxseSByZXNvbHZlZC4NCj4gDQo+IEZXSVcsIEkg
d291bGQgbG92ZSB0byByb290IGNhdXNlIGFuZCBmaXggdGhlIGZhaWx1cmUsIGJ1dCBJIGRvbid0
IGtub3cgaG93DQo+IGZlYXNpYmxlDQo+IHRoYXQgaXMgYXQgdGhpcyBwb2ludC4NCg0KSWYgd2Ug
dGhpbmsgaXQgaXMgbm90IGEgc2VjdXJpdHkgaXNzdWUsIGFuZCB3ZSBkb24ndCBldmVuIGtub3cg
aWYgaXQgY2FuIGJlIGhpdA0KZm9yIFREWCwgdGhlbiBJJ2QgYmUgaW5jbHVkZWQgdG8gZ28gd2l0
aCAoYSkuIEVzcGVjaWFsbHkgc2luY2Ugd2UgYXJlIGp1c3QNCmFpbWluZyBmb3IgdGhlIG1vc3Qg
YmFzaWMgc3VwcG9ydCwgYW5kIGRvbid0IGhhdmUgdG8gd29ycnkgYWJvdXQgcmVncmVzc2lvbnMg
aW4NCnRoZSBjbGFzc2ljYWwgc2Vuc2UuDQoNCkknbSBub3Qgc3VyZSBob3cgZWFzeSBpdCB3aWxs
IGJlIHRvIHJvb3QgY2F1c2UgaXQgYXQgdGhpcyBwb2ludC4gSG9wZWZ1bGx5IFlhbg0Kd2lsbCBi
ZSBjb21pbmcgb25saW5lIHNvb24uIFNoZSBtZW50aW9uZWQgc29tZSBwcmV2aW91cyBJbnRlbCBl
ZmZvcnQgdG8NCmludmVzdGlnYXRlIGl0LiBQcmVzdW1hYmx5IHdlIHdvdWxkIGhhdmUgdG8gc3Rh
cnQgd2l0aCB0aGUgb2xkIGtlcm5lbCB0aGF0DQpleGhpYml0ZWQgdGhlIGlzc3VlLiBJZiBpdCBj
YW4gc3RpbGwgYmUgZm91bmQuLi4NCg0KDQo=

