Return-Path: <kvm+bounces-52545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 20DBCB06876
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 23:21:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 258971AA1B41
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 21:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A8F2C08DC;
	Tue, 15 Jul 2025 21:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bXY4m1Vv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC9725A2AE;
	Tue, 15 Jul 2025 21:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752614481; cv=fail; b=dOUzxqPr9AokzsHiHQj04bjL3YL9aFZ5qcRnLHcP5GmCAW/N6Jb9TwL+Qx+dUVPSYJxPyh3A0J97eLTg7OPJYpFoq8WmOEYeqndpWsTKpEkHYF/l2oYt8gRZNco7OBv7KC8Id8Q+d+dMLVmNbksnsv1FHb7P93yNg0TyVnYOO58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752614481; c=relaxed/simple;
	bh=zl5mWknKszHt438U5bVMmTYkkxzwK1oZM8Gzpxg3Zg4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Aqe8YxcSRo7hL5rEKhc3lzU8LRnfPpJNaxVR2JnYqoVTu56rv00Q0zMTsgT4m/MUyrC/2am/vPVk3N+srVyR0oQqObyxP/tfY4qWN2PZEp4HCqztzkXOOWCuV9bnqCfuygDF/0skhbPMnWWwwLugXAAdeBCRHpOWOTiFS6k5ZwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bXY4m1Vv; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752614480; x=1784150480;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zl5mWknKszHt438U5bVMmTYkkxzwK1oZM8Gzpxg3Zg4=;
  b=bXY4m1VvGbuo63kQZNAN0Kf6s70vldUQz1xmgdsnjMBGdo1JoHBwxqht
   v3k7ezd+E8BJoJxLTUqdaY2BnCI5dW0DAW92IMVwM8+NtzqvcdzWqIbE7
   8ukRAwn8yCHidw8LtHh2MU0GeenT1kvQ9+vQrpAqp5fynnbNcmFILQvJA
   Z+jAYTYZvB26aumdBNSi09Z5vgLJn+baI8QmVid+U6T88zUDlFX5HttlF
   4z+ME3H88hBt07k/yaw5tkqPycjMVfih9ITvnTZ/Ai44Wocd+EDGlwHN4
   OabixGjNB2gP9hVJWHAapg8hdyct3fN6uR+tyeQwc4vWjoPvUCDlyJM75
   Q==;
X-CSE-ConnectionGUID: 0OMxmBWdRdirP4Vmz//B8Q==
X-CSE-MsgGUID: OeskyRueTByusjPTpApQOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="72423343"
X-IronPort-AV: E=Sophos;i="6.16,314,1744095600"; 
   d="scan'208";a="72423343"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 14:21:19 -0700
X-CSE-ConnectionGUID: l/hjcYZWQ0W/u3NGLzkWBA==
X-CSE-MsgGUID: pWuumcl1RE6nfMPiziGmdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,314,1744095600"; 
   d="scan'208";a="181011818"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 14:21:19 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 15 Jul 2025 14:21:18 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 15 Jul 2025 14:21:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.82) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 15 Jul 2025 14:21:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k7MsjOqRymrueL7gfbH7Ky5t4Noih1YcFOP2fxJ3udr4vqBRkpR3Fk7Rg5yOl+s6HmLpIPwvYC7vmpbRU9YHsoITeD98JGeXft+O4mwbxv9BMDnB3Le4QKmlkIOYXdCNfCcBDtZey+XrVrOgeT5ANvjjGrfuJ5ah8zgAj1vhWTcM79nejrgz8TU9flL7Of9yshzEX4zOoGqrP4PLtfWLkpg7SVx6ipO54TqzsIxX/MfSaU/eHui5v8tejwok5hsFzAztSJ1nsjPFU2MtkRCtOEzRSPQb2Hfb4oBeyprWsrW5dcJ6qRajisO00FznxcdW+uvt40m/gzL3EAHyLt4piw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zl5mWknKszHt438U5bVMmTYkkxzwK1oZM8Gzpxg3Zg4=;
 b=vAor/qsT44/k31okyUsM1UawU0QU9sJe6XZ6QbHGZxkqPw8UgDTXJ9QKP/mULDYSmhY9u73buHvUOHGTgmQwOxtUlzAgtbWv5UewmqxrcfHE3+5ozLZ5Glmcb9XB6gTBfcBgX5Uvi9jKKwB6yMNqLRzx4yTPE3xCj1C6KuvSsg7DnGSPz7fDYrYHm5SJdiDsAztED7G2uE32lcU86PorNLU226cgKwLaxZky7kFOvZSwM4LvC/0TObFpA3JCiIjZphHb8zTnpebYYqDpQZAeKsgq4qwMNy4AFI6jXZWIcPWNQ2e5ZXIpi7/dhTXjHp9uqd7Byqsb14bgnDnD03wE9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6898.namprd11.prod.outlook.com (2603:10b6:806:2a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Tue, 15 Jul
 2025 21:21:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.033; Tue, 15 Jul 2025
 21:21:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kas@kernel.org" <kas@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Lindgren, Tony" <tony.lindgren@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Huang, Kai"
	<kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v3 2/4] KVM: TDX: Remove redundant definitions of
 TDX_TD_ATTR_*
Thread-Topic: [PATCH v3 2/4] KVM: TDX: Remove redundant definitions of
 TDX_TD_ATTR_*
Thread-Index: AQHb9WnhDqhzUqaJkUq06OBAHU3V77QzsfSA
Date: Tue, 15 Jul 2025 21:21:14 +0000
Message-ID: <b0236fde5d041e07a0ee4804812bc87a95c8dd37.camel@intel.com>
References: <20250715091312.563773-1-xiaoyao.li@intel.com>
	 <20250715091312.563773-3-xiaoyao.li@intel.com>
In-Reply-To: <20250715091312.563773-3-xiaoyao.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6898:EE_
x-ms-office365-filtering-correlation-id: b74ba86a-84cc-4aef-4eb1-08ddc3e5876b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TWEwMG9GWmtlZitPVDV1OUp2bWpHQ2I5NHdyeTBVK3d6b0tUMEd2Q09zaUVD?=
 =?utf-8?B?dHdManczRkcrUDAva2wxbjBMeVJEZWhXN1Jmek80eW9EVTdrWUQwMlA5bXJD?=
 =?utf-8?B?a2F1cXo4UTRUQ3hwdXJDUDQzYTU1UytBQ0s3WGVHaS9obmxDQSt5dVB3WDRw?=
 =?utf-8?B?WVY5MS82Mm1oYm5GWit0aXcvdHZBdnRMbmIwMkZwMnVPcEdJWlFWWWhvVWJw?=
 =?utf-8?B?a2NJMTRPV3ppckFTcUR0TGdqSUx0aWIzU1dTMWhpOWZMSnZUV1pGdTM3ZEpU?=
 =?utf-8?B?Y09JNkJFSUhsZ1UwemkwUkNteW1qZ05EZWt3UmF6Ry9WS2pOT3dMUTY1UEJL?=
 =?utf-8?B?aXEydm1iQ1ZGN1MwOWc4TVN5R2dXVUtrd0JNRnRsRWZ2WFVnQkxGZHdjQ294?=
 =?utf-8?B?NGRRSXlZbzFRTGJEcGpGQ2pRVWNmMXc2akF3MSt1bUVFeitCV0lpWW5EeWNY?=
 =?utf-8?B?Q2hVYkplenJzWlZwUlJHUkNtekNmejBZRENObExXZTNoN0Q2Wmx5S0xSWjlO?=
 =?utf-8?B?Z1U4WlIrUk0wVkQrU2pSSGx1Q1VpK2dpWmovUzJTL3Nqc1hxRVowSnhWY1Zs?=
 =?utf-8?B?QVNrSG9jemdscDR1MkpwV0I0RDFZU0dNTWlpaVQrR3VQdlI1cnAwVEJyT1E3?=
 =?utf-8?B?SFlrbllXaDFyc1d5MzI5ci90UTdnOHBnZ3dBUEVWTDhBTU9kdlRtZVZDeUgw?=
 =?utf-8?B?MnZMZjF2a3FOTEJNN0xWRlc0Vk00YWFZZDNmSFdKZHMxUmxVTUFnU1B2Wkdm?=
 =?utf-8?B?dHNhV3ZLWTRBc21LVHh2NjVoRWhjbmRDQ3dwR3ZGSkZVZUMxemM5K1B1YVAw?=
 =?utf-8?B?akJrREF1MC9jc3UxT2k1TjhNVG8xajhXV2dYTHJxQnBrMHU3VEdCVnJpTjdz?=
 =?utf-8?B?YmtNNTU0QTBQVTJLVFhhMGhMNlNRcW96UHYrNUF4UzNXREVDNkJCWGI4NWtL?=
 =?utf-8?B?YWErRUhBVHMwK3JGNUlqM0JzZDhjd0p6N1l5Z0hUbEg5V2F0dW4yb0N4c09v?=
 =?utf-8?B?dlNOVEtXVGdjTEhQOWY5MDRBZHV4eHNoQmRzQzBITEhYZTRYMzhab0NsMkFM?=
 =?utf-8?B?dTc1M0IrYVAwWDV6MkE1cjdCRDMvQlg4ckxJcHRJVXdLVTVxUjNLWGVGSHRU?=
 =?utf-8?B?Q204Wmx6anZnMHNOc3MyUGI0TWViUDlBdlE3K1JrSE4vejBmdFVUTFdZODMx?=
 =?utf-8?B?ejNoaTF5UlljLzdIM0tSMlkvaHVpOXFnY0MxS2FhdUNNSWt3M2gzdU9WNTVl?=
 =?utf-8?B?NnFwb1RFTm9PekpEeU9UTGpKMXY0WHR5VVdkMi80eFVoSEpCa1BSSE1iYWVm?=
 =?utf-8?B?b1dXV3drMG1BTFloRFBaL0RKdk1mbEhlOWsvN0FmVXNqd3cwYndQUXExdmcw?=
 =?utf-8?B?eEQrM1VVMWdvMGlBdlo2bEw1S1Y2OU5lSUFqZS9NanVBTWN4SGdtVFhia3Fr?=
 =?utf-8?B?NFJXMW5LRkgvdm14amxWeVh4SzhZVFoxN1Q2WVROaDFWRjlwbDN2M2pkY1k4?=
 =?utf-8?B?cHZhSUZZQzRpQUdnbm80dTMxNFBmekVSakxweUlkbEUxd1JRRkE4cEpLd2JX?=
 =?utf-8?B?REhNTTJxNWhjZDRGcUQ4VGZUcmFSeHFqM1dPKzVMWFFkYTJFV2JpWEJBN0cw?=
 =?utf-8?B?WnVORWZ4SnZlM3pEYk0rNlpTZjl5MEZncXNYcXdubEk2SWw4OGFKcFlITzMr?=
 =?utf-8?B?ZXdkOHRhNGlTWUVzMTlFRXQ0VXc4d3VIWVVuRlpKL0R4NUNLMWhTcVYvK3NN?=
 =?utf-8?B?b2pzdWMrTktqalliSENYUUZlcC9Xc1k3YXk3d1Y4dG1GZXBaWUhnWC91RXp5?=
 =?utf-8?B?cVFKdm9yTDkwbk5aZEJkUCtwVk1yYjF2RG9pNWtGSEJjMXBxMXJIUGFkZi95?=
 =?utf-8?B?SjhmUDFadjNSVnJZVjhvbkZJQXJTL01IaFVnbC93RU82VWgvd2h4YlB6S0dr?=
 =?utf-8?B?R010d1NSbTdyeDFrNnRITHIrdXYzUEd3L1JRYnN4bXY4OFBzZFp5bzBUUnBT?=
 =?utf-8?B?ZzczWWJOK1Z3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmNydlNXdnNGVnRuUUsrNmhHL0JtZjcrdE5WK1cvTFE2cWFMWGdnMERZd2pC?=
 =?utf-8?B?aGx0N051Mm1WbnQvZFlsYjJzS1JvQTFYYy9RQ0ZFd3J2c2M0V2ljYzkyVUNo?=
 =?utf-8?B?Sk44OU5hR0dTcjdXOFVrZkh5LzNPVjk2cFpiT0x6TkFtU2FlN3pUN1J5L0Vn?=
 =?utf-8?B?WUMzaFZJSG1MTWZ4Sk1MYmJLNTZaQnRIYVZGZzdJU0Q0VUxXU0JFWFowQlN1?=
 =?utf-8?B?Z0ZJWWtHY2RjTFRsZ1RhWnFSek5MQzN3em9UeFZmbWRKUlI0TUNyRzNBUFQz?=
 =?utf-8?B?SzZKYVRSMm1TZU1EOGljU3d1SjZaNGdLV083OEFvaXJjdVFuVDFKbkpLZCtu?=
 =?utf-8?B?UmwzT2lQd0o4a2xnS3pDM2dETkZRNUY0UUNERVluakZQdzVJNG5TWGozcWZZ?=
 =?utf-8?B?cnB5cS8xMGd6QkVueXA3OHZKbXF5NEdHUzBwYyt2QXJ6Y05sMW1HR1czL3Vt?=
 =?utf-8?B?dzFDRVJobkNEbkxPWGxEaklzbzVjTEdGOUxlaVNHN0YzQkVEUWdNZ0puc1dw?=
 =?utf-8?B?UHZDS0oydko2SFNtWklwNHE3bUFQTHdqdE12YTcvNytITzMxcVVEeEVLWmNy?=
 =?utf-8?B?ZnRNS2IzdEZiQWNKT1pjYU5jUVJzaXR0N3V3cWcxd0NjOTlzYkQvd1JvVWdD?=
 =?utf-8?B?SEdJeHVDNG5wY0ExcEV4L1dMVXl3QVhWejFibEh5K0p3aDF0SGhyUmJDcXZG?=
 =?utf-8?B?amQ3VTZIb0tBc0l5VllhU0V0ZmN0UnZONjlYa21nT2hsd1V3dXM0WE9HOERC?=
 =?utf-8?B?WFVVaitSWThxakJ5N2IzUk4rSW5hWnFRMG0yTXJHVGV5ejU5ZEpPUjY3TDB1?=
 =?utf-8?B?cVZ1dS9QWkthY0g3d2lwZUdpQThpbFVOU3pIREZGWTMzdU5DeHM5YmNEQVQ4?=
 =?utf-8?B?ZVVIaWpzeWZHeUh6S3N4aXVhdzl3QVRlbG04L0lTWGVBTXMrRmtvc2EyWHhh?=
 =?utf-8?B?TTJONSttK0tzd3M4eitUd1Y3SW1ad2NidlpyTGNxaUl2QVZadzUyOXlDY3Fz?=
 =?utf-8?B?WVZTQmdjSU9lLzdKTVluNkpUNUN5MHZkUWxqYjU3SXR4V3Y0WnNPZ2NqQjdi?=
 =?utf-8?B?RFh4TjYzMDlDU2dRbnFVVGtYY1ZFMmRxb3paS0p4eXROVXppeWlWR3hLTzlR?=
 =?utf-8?B?bUVLc1BQRVk3QUVzYzZNMlg5QUFtZkxJM0tZeWJJVkg2MUJrTEF3aUZQb3JN?=
 =?utf-8?B?Q0phbm1tMTcxUFRzTURzWkRSRTJhTXM1TTRKdituSmpJUk94ai9kRUI1OE1m?=
 =?utf-8?B?eFlVbVdPMGxnSU9YUHV5bERNUW5VQy9NSXlFeXdHMmZBK0dNa3F5OEFJYi9m?=
 =?utf-8?B?ZjJHWU1EZ2JuRDZzMTMyVTl3QWNNOWtaaXNyNWl5S0JEaHVwSUZQdWFmZVRk?=
 =?utf-8?B?NG5VSXFOZC9uWnVYaWlRbzhCQmFZR21VVXhoQ28zVklRRmt6WlUxNEk5Qmlu?=
 =?utf-8?B?RDB5eFlvdnUwWVUvWTlCbWhncFRmYzd0UERyd0IyRWY1TE4vSnUrcW9wWmxQ?=
 =?utf-8?B?a1JBRE8xNUV4N0lkZStmYWZhdXUvdFl0NWhUekpic3N1RDRlV0Z0OTdGUHZ2?=
 =?utf-8?B?Sy9YWTNQNDVSUk1wZUtSQTBWcEplTkhRbXk0NHNLRCtPRkVFdHQ2SlRNazNz?=
 =?utf-8?B?dFNXMVlRYTI0QkVPYTVRQlJpU1ZodUwxRGIwYkR3UDc0ZlI3MnU2TjZrMWdi?=
 =?utf-8?B?eFI0VHVHeHlIdjREVWxjUEtsZUl1dmdwQUVJNCtvWWwyUld3dkZHZ3RnQ0d5?=
 =?utf-8?B?aytSQXBVME16UHBlWlgzMmMwY1IvdFJEbW8vNTFNU2FscEZXbC9YWWlkSDNC?=
 =?utf-8?B?dFFTWjRuUzhpWnZVUEpXcUdJa0pBU0I0VzNXRmYyTlNUVUJFbG5XVUpGZ1pz?=
 =?utf-8?B?cHJmTU84aEJBOUdmcEJSOUJzbzhOU0o3VGtieWZQZjVzazBPMmxXanVJUDBE?=
 =?utf-8?B?Q29mQmN3UkZJZFBLa1p3amNkM3dnOUtxWjA4eWlKMDlySUc0b0I4ZTdMRk5a?=
 =?utf-8?B?R21JRGkzQkFwWEN4a3RrMlZGbm1TVEh4MlFOdndBOFNnOWdhRFhPUEZzRkhz?=
 =?utf-8?B?WU1qdWU2QlZFSDl3Z1gzVHpVbWNiWlQzazdXV2hvWjN3b3c3aHNWWm14aVJN?=
 =?utf-8?B?dk1aVUxsbnlBY3VhTVFnM0ZESnhEaWFDN3ppWUtmeU1vMnphWFB4NVhoQi9y?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F405C7D3B91A514A87C6E732D81E4306@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74ba86a-84cc-4aef-4eb1-08ddc3e5876b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2025 21:21:14.2773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yX3cm7p2e/1pXAkgVnC9H4wxu0XZUuZ0C8MAW8YyzVEZ4mDTmgQc7Un8yD9jjpBwVeGaXiLc+VFjvwRSC6PIukxFD/SznVMSvebVagCJ9gg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6898
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTE1IGF0IDE3OjEzICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBU
aGVyZSBhcmUgZGVmaW5pdGlvbnMgb2YgVEQgYXR0cmlidXRlcyBiaXRzIGluc2lkZSBhc20vc2hh
cmVkL3RkeC5oIGFzDQo+IFREWF9BVFRSXyouDQo+IA0KPiBSZW1vdmUgS1ZNJ3MgZGVmaW5pdGlv
bnMgYW5kIHVzZSB0aGUgb25lcyBpbiBhc20vc2hhcmVkL3RkeC5oDQo+IA0KPiBSZXZpZXdlZC1i
eTogS2lyaWxsIEEuIFNodXRlbW92IDxraXJpbGwuc2h1dGVtb3ZAbGludXguaW50ZWwuY29tPg0K
PiBSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBTaWduZWQt
b2ZmLWJ5OiBYaWFveWFvIExpIDx4aWFveWFvLmxpQGludGVsLmNvbT4NCg0KUmV2aWV3ZWQtYnk6
IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCg==

