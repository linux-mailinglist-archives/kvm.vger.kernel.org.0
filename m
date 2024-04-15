Return-Path: <kvm+bounces-14705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E79A8A5E43
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 01:27:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E6941C21257
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 23:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C94CD1591FF;
	Mon, 15 Apr 2024 23:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ii/mUW1H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123B4156F35;
	Mon, 15 Apr 2024 23:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713223647; cv=fail; b=VERQOMZPV6/MgIYbQLG+OjrYnk9S7RnVyvXPoY8PoNd2zrvEOhTGKlGOv99x7tC1S6zic4R1ru+gLecC66V+95A+/6T8hgSlwmj7c+u7+xTg6TXjV958ImycYHruP8H7I1N2Z/j7gx0+JmQPH9V5qOsBwsAewiEjwJs/90e+hGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713223647; c=relaxed/simple;
	bh=xEVqpwYFgiXa/Wm3nZUkNBbMzA4zK8mu3ZfxhlPJljw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EKAsQobqHCQVXezC4rgJl6uZQVpj+T6gno0olGoH3dzAt83XZGmJb7PZrmmjH3+yaRF4pOKQYozcgHdaxDMfOxksyTIRGR+lWH8EhadfWu07+K6fZpn3QE2+XaHbdxTI3aBiA0gQ38ULilt9zWGYNMEIjO+FtE6U3k7AwlrL0bI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ii/mUW1H; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713223645; x=1744759645;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xEVqpwYFgiXa/Wm3nZUkNBbMzA4zK8mu3ZfxhlPJljw=;
  b=Ii/mUW1HFLL9KahLZUjwe71kR8ZoE8ay+V+F+enXEy6G8Gh8kNkV+NFW
   2xqkXp8gT6nerT0b0r/kQrYVehF219wCF6fhimlm74iyFxlA7d173zMpC
   CgeFgeiPdBeTpZskDJctq1eTZYdoTBzsupNCuedAWfXMJtV9V9Str7Pua
   OtGHC8uMmjX7qVbq0ZuUwKAnlqS4vpnJ3DzlyJM9m4lsAjUuerKj9G6mB
   fkDUcVSmKF3D7qa5IbLOBm9E1f7b7miVoLmN68EMANYLfUiI2X0N7BPD8
   uZIkoAkbMHQSgeivNQAS37Z57GkZAJA6NzHWnS8I/NT0IJI38R9MxC9ec
   Q==;
X-CSE-ConnectionGUID: 9uOnjIylT1yn+/nH3AiWtw==
X-CSE-MsgGUID: H3oDA2qTSQmr/IV+eYLQOQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="34026451"
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="34026451"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 16:27:24 -0700
X-CSE-ConnectionGUID: hQ6MrNG2QxybDasmlN+Ofw==
X-CSE-MsgGUID: lnx4/5n9RlCIlF4wlaKZWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="22065023"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Apr 2024 16:27:23 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 16:27:23 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 16:27:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Apr 2024 16:27:22 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Apr 2024 16:27:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bBWS/Tv39vRBJBsp4NmJNQMtQJFoy2xKPbI8epEyoAdupX29LkTVdp8tbT523ajK9qPqH1ixKonXPcv+hrn/wEJ+O5V8rMUHZz18FWEJe3kEhvF4X7rmOF1/H7TAQnJJC1Fp8cGYDCepnn/BFCI/+2Joup6S7Be1n2Vo4fRuf3hGMYtHZCFeNJLz5v3nGIwUxF3BoiL/xqbuopXuBFk2dhJO5ob1UdItiPbrYU7Z8fmfBhwdbhydvnLvNZ+fRY3mxB1aFvxVPGiOm5qBZaUwbU+Fyk385w8b/Sb45OoMHCUCROOBo9pMCD4NJV2hWtSLdpUDMcYayo8HLwi8g5ZuUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEVqpwYFgiXa/Wm3nZUkNBbMzA4zK8mu3ZfxhlPJljw=;
 b=JOhUpBdsLCQg5d/q3Kl2bMPUKW3kNpwjVWprmpRN0MEkYuJNECPuZpOwDC/yYTdtUBsUlBDZvdke91NVO8xpffk3Pjq2mphnSKwPDcr/1kqzDMvygbtHRfO3f98+dj6q5JZQWIDUAolYiVNOGuTU/vDLEs6ZDIzRKSkIJbffPkanlsXYFqwlk4d04ITtSxXwfsytAKW24QAL5uP18LbdQ2iX8RyQZbXq6iocGmp+9X2TXw45KTxe+SAZYgFKwdPuGU8L4n75canL1UroYvXheQuZ9FO1ZvS2jxACnngnhRfnu7bHQPv4Gw0NI2+jw/pgcshzPCG2scnEn7C6vxywxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB6711.namprd11.prod.outlook.com (2603:10b6:806:25b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.49; Mon, 15 Apr
 2024 23:27:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Mon, 15 Apr 2024
 23:27:20 +0000
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
Subject: Re: [PATCH v2 01/10] KVM: Document KVM_MAP_MEMORY ioctl
Thread-Topic: [PATCH v2 01/10] KVM: Document KVM_MAP_MEMORY ioctl
Thread-Index: AQHaj4x2Dd85ng8bEkalBg1DfFjrhA==
Date: Mon, 15 Apr 2024 23:27:20 +0000
Message-ID: <28923ef142d588836201a1533b73fe4d89ce4696.camel@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
	 <9a060293c9ad9a78f1d8994cfe1311e818e99257.1712785629.git.isaku.yamahata@intel.com>
In-Reply-To: <9a060293c9ad9a78f1d8994cfe1311e818e99257.1712785629.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB6711:EE_
x-ms-office365-filtering-correlation-id: 5a708b47-b25c-4fb7-c038-08dc5da39896
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rl96RFJtm4oxNBoTRCKEoXX+x3IAzAEf2ncFDt8ff61GaFRL3sSvCRDRWrOhrAGbmO+Fwh8wxMPkmeSwxSwwM1HzZatVktl+7C7ZyX2S+hdljqjNgTXQF1AStKEgefEsAh9ZBftZzB0ygkTP2MssrO1Y5gDNjoJRiBmkBXVM9WTxy1IIZrWIBFw1fARwZeEl7mIWry8ZyppvY80qFYVdcvOHFhtK2TwqhVXuZeg7BMuPEvzntTGuQYRoyZZMAqpPHVeyNFpifAn0GE/+kQ8qEf1MGZVrceT0mDUKH0xIuloKIfLtt9XbCpgJsGC/T6iiZCN/uQ4bBZa7T1vlZOsWnGIfQW53zR9ThDcSagFnbikie2XiNxzfF2PBfJrCQE779707ynKOXJEcq35qI6W48kNnNb6jrn/E6QEzvYogNbv/G4NUmMXy+IrVbRhqR3TJWVcTetHxFBFGuAl5IclNhaq1jKoZgvHLmz3831aw1PwYl11cHTG4DEpejyGzQTidu+Ammq/vgBdEMhl+W2eayQ2nZ9qm1QwQxRACqdthWueFWCithRL6lbvhLJd/85kIca7CSgRInPZVZyc8i37qxfgnctDZ335idrgGOPL+/JfqrrUF6w3+ZoOEFTd57qzQdXA2bzKUQ+8p/Q3wQSEUU+G8KxHnrV/a6fzI6JkBOqswNStJtnzCa4hQU6WdX6J/d+m+MePVpj7AvLa0vXszdDlf2vPT6AOQmpJhF3bHXn4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFYyc1IyNnZHRGo1a3ZtNnF4RExPQVQ3ak1jd1lhV0ZqdVBUMW5mUlcxalRF?=
 =?utf-8?B?RWpTZE1NQ3JHR2M5eEJLcHNjVUtmbjlxL1JrSTB6VkdkazQyem1NVlJRdEky?=
 =?utf-8?B?MURzZjhaNGtYWVFwZHQvYkRXNWdwUFQ0U2syQkxFU2xvdGhDRE9uM29kU3NB?=
 =?utf-8?B?OWdueVBQTVNyM1g0dkxOUG45ZlVWT0U1ZjVnbVhCeDR0NStVV1J3TnNHenRD?=
 =?utf-8?B?akdkSEN3Y2h4UDFVNmFCT2pLb0w1bkNyTlpaVUpZWER5WThVMnY0U2dlNE9T?=
 =?utf-8?B?Si9GK1M2SnBqeHBWS0JwQ3ZmSk1IK29pVUNBYWtwUzBmYng1aHJtRHBwUWl4?=
 =?utf-8?B?OFdFVnc1emcxZDA5dTJYV1pwQ0E4aGRCZ09CRzU5Z1dyMlpTSHF2UTVoZHZW?=
 =?utf-8?B?SmJDRENCSXl5QlAyWXlETHQ1RUhnajV4YS96SmxCT2hJVG5DRkhFRVFuZE5M?=
 =?utf-8?B?WWFrdVZPZXFxKy9NeUMwNStIcTZMcGF3M1dCYmhVS3Y0YW5lNXUrM3RJVTBy?=
 =?utf-8?B?WmVqeEwrUVV4L3dTdG5qWHFHUGNSTk5sWEtSeWV3ZEFyM1Y2OThTMzhGaVhU?=
 =?utf-8?B?WTdpNVpqdEpYeEU4SDUyYmVLdzQ2K2o2SGUzd1krMGpDMUVaYTJoK2pnU3Ny?=
 =?utf-8?B?K2dtY0x3WXV4ayswMTJhb2JJcUJUSnpLS01DZG9WeFM3SldtK0E3dXZRc1Vu?=
 =?utf-8?B?TXdLVlNHWUF0N00rL0NtajVwN0xISWZ3MFQ4RWtDbjIwNTFCdjV6OFFxbUNE?=
 =?utf-8?B?TGV3RTRzUFRJQkpCOWhha1BmKzdPcVdUNkFuZ0hVdXZzZUoxbXQxdE1TY3dn?=
 =?utf-8?B?Z0ZjZmlUOHIrSkxYRnhkK1VKbmlENy9HcVpRYTNRRU9qUzlLYVNyVWk4MnhR?=
 =?utf-8?B?RGxvaHdscTA5WXlTSnk2V2ZFdDV2eEFBSnBQQjA4S0tMcmVYZURXc0IwK3Zh?=
 =?utf-8?B?bnR6dVd2L2Jna0lyeVQzV29uTEwzc2MreGZnUVg1YUFNR2I5bHRqZ0xkUnYz?=
 =?utf-8?B?WlJKNHpnWUZKN2RxQ3haekxuU0MyTU9wSUdBNTZlQTFlcTB4eWx0ZG9BdVFI?=
 =?utf-8?B?bHhjemJPZkNXSkpTSDBZSitsUm5vMEZZTXFTUE1ZMWdwWVNoRzdOR01FNHZG?=
 =?utf-8?B?R0hLdzFOOW8rTC9tVE9PQjJqQVVJWnBObmlsaTRIVDBUM3ZDdW5CUUxjYXpY?=
 =?utf-8?B?N3VxcUpYKzZZZGhCZnhzYi9sUmFEdW5WaGFHU1ZwTVhSVFVaTVhWamk3ZjFa?=
 =?utf-8?B?SjErMFJCNkxDT2NDZEdUeTFwS29aZ3pkS0FGZ1Z5VFZ2M1pPYnhMM2ppclZP?=
 =?utf-8?B?OHEwZ1lpL2pkMUVGb1ZDM3p5dk5QU2E1ZEVybjNxZmZpN2pkSDQvZUUwc3lL?=
 =?utf-8?B?WWluZytoK09Cd2d6U2ZMTWRIRkZZdERsbDIwVXhXdWpacU5PdjYrNGNzczll?=
 =?utf-8?B?ZFBjN1pLcVc2anlOUGM2TDlOcmFlbkMwQk1sN01JL1gxalJvbG5wOG94UkF6?=
 =?utf-8?B?SStDcXVKN1VFcGJLZlZ6ZHRhbWpKSW0rbjJuMnU0Rno4S0ZMU3VrcmNjVmdu?=
 =?utf-8?B?UEhRQXYxNWFVSDRkNXlrbGpRd092RFZBaDA5YmI1Wm5ONjdkZExpYWJhSFo2?=
 =?utf-8?B?dUhIRUkwK0haTFM2Z241K2xGQ0tyRUQwRlRYbWUzNmNxaUY1VmhNbGhmQTFZ?=
 =?utf-8?B?SlZVSk80c2NGZVZXa2tZVnJ6WU5VRW0rRmlIbFFvSExpV1dFTmlkcm9xNDRY?=
 =?utf-8?B?REhub2d1Yk9nSVJVOHNYekpldU9teTdCZEt1YmdaTjk2UXV5M29mYWk1ZkJn?=
 =?utf-8?B?TnZnZTNSZWxMU2JGT3ZHU3NxdWVBUkdsRkJDOFRha1JKU29raDRZTGNBR29N?=
 =?utf-8?B?YktPTUthODAyQWNrQTlaNzlsRVhrRVFLUHFIeVl0Y0M3ZzBBd2RFaEd3dEpO?=
 =?utf-8?B?OG81QytDQ2dUR0g4QXhoV3dUbjgrU2ltcWdNUGdFZC9FL08zRXRGRFM1dGJ1?=
 =?utf-8?B?SUdWYlk4eFVsWHZsTWg5UVhzY2VSc3FObWxvZmxVOVlKT3I1VXRJOFA1aWQv?=
 =?utf-8?B?REtTbXhPb2VrcEdad3FBRkprY2JDUVdOK3puOFc4VEg3OFF6WFV6dDZKUHRt?=
 =?utf-8?B?Vi94Vk5iSG1ac00wWlVQTHpBZjlwUWN0T2srdlBTOUJISTI3cEFRMVByb1Ru?=
 =?utf-8?B?VVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95B328761A6FBB4BBEC7619CA10A8C36@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a708b47-b25c-4fb7-c038-08dc5da39896
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2024 23:27:20.0434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M6cQa0P9DADpBvdbye9/XKFF25+k7fb/cP7A4oPIhxfneosuKhoj+gMpbPJeHppPs3516bDxzL+9iE8bujZlwvgTVjYU4Ur16e+BRf/iQO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6711
X-OriginatorOrg: intel.com

Tml0cyBvbmx5Li4uDQoNCk9uIFdlZCwgMjAyNC0wNC0xMCBhdCAxNTowNyAtMDcwMCwgaXNha3Uu
eWFtYWhhdGFAaW50ZWwuY29tIHdyb3RlOg0KPiBGcm9tOiBJc2FrdSBZYW1haGF0YSA8aXNha3Uu
eWFtYWhhdGFAaW50ZWwuY29tPg0KPiANCj4gQWRkcyBkb2N1bWVudGF0aW9uIG9mIEtWTV9NQVBf
TUVNT1JZIGlvY3RsLiBbMV0NCj4gDQo+IEl0IHBvcHVsYXRlcyBndWVzdCBtZW1vcnkuwqAgSXQg
ZG9lc24ndCBkbyBleHRyYSBvcGVyYXRpb25zIG9uIHRoZQ0KPiB1bmRlcmx5aW5nIHRlY2hub2xv
Z3ktc3BlY2lmaWMgaW5pdGlhbGl6YXRpb24gWzJdLsKgIEZvciBleGFtcGxlLA0KPiBDb0NvLXJl
bGF0ZWQgb3BlcmF0aW9ucyB3b24ndCBiZSBwZXJmb3JtZWQuwqAgQ29uY3JldGVseSBmb3IgVERY
LCB0aGlzIEFQSQ0KPiB3b24ndCBpbnZva2UgVERILk1FTS5QQUdFLkFERCgpIG9yIFRESC5NUi5F
WFRFTkQoKS7CoCBWZW5kb3Itc3BlY2lmaWMgQVBJcw0KPiBhcmUgcmVxdWlyZWQgZm9yIHN1Y2gg
b3BlcmF0aW9ucy4NCj4gDQo+IFRoZSBrZXkgcG9pbnQgaXMgdG8gYWRhcHQgb2YgdmNwdSBpb2N0
bCBpbnN0ZWFkIG9mIFZNIGlvY3RsLg0KDQpOb3Qgc3VyZSB3aGF0IHlvdSBhcmUgdHJ5aW5nIHRv
IHNheSBoZXJlLg0KDQo+IMKgIEZpcnN0LA0KPiBwb3B1bGF0aW5nIGd1ZXN0IG1lbW9yeSByZXF1
aXJlcyB2Y3B1LsKgIElmIGl0IGlzIFZNIGlvY3RsLCB3ZSBuZWVkIHRvIHBpY2sNCj4gb25lIHZj
cHUgc29tZWhvdy7CoCBTZWNvbmRseSwgdmNwdSBpb2N0bCBhbGxvd3MgZWFjaCB2Y3B1IHRvIGlu
dm9rZSB0aGlzDQo+IGlvY3RsIGluIHBhcmFsbGVsLsKgIEl0IGhlbHBzIHRvIHNjYWxlIHJlZ2Fy
ZGluZyBndWVzdCBtZW1vcnkgc2l6ZSwgZS5nLiwNCj4gaHVuZHJlZHMgb2YgR0IuDQoNCkkgZ3Vl
c3MgeW91IGFyZSBleHBsYWluaW5nIHdoeSB0aGlzIGlzIGEgdkNQVSBpb2N0bCBpbnN0ZWFkIG9m
IGEgS1ZNIGlvY3RsLiBJcw0KdGhpcyBjbGVhcmVyOg0KDQpBbHRob3VnaCB0aGUgb3BlcmF0aW9u
IGlzIHNvcnQgb2YgYSBWTSBvcGVyYXRpb24sIG1ha2UgdGhlIGlvY3RsIGEgdkNQVSBpb2N0bA0K
aW5zdGVhZCBvZiBLVk0gaW9jdGwuIERvIHRoaXMgYmVjYXVzZSBhIHZDUFUgaXMgbmVlZGVkIGlu
dGVybmFsbHkgZm9yIHRoZSBmYXVsdA0KcGF0aCBhbnl3YXksIGFuZCBiZWNhdXNlLi4uIChJIGRv
bid0IGZvbGxvdyB0aGUgc2Vjb25kIHBvaW50KS4NCg0KPiANCj4gWzFdIGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2t2bS9aYnJqNVdLVmdNc1VGRHRiQGdvb2dsZS5jb20vDQo+IFsyXSBodHRwczov
L2xvcmUua2VybmVsLm9yZy9rdm0vWmUtVEpoMEJCT1dtOXNwVEBnb29nbGUuY29tLw0KPiANCj4g
U3VnZ2VzdGVkLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogSXNha3UgWWFtYWhhdGEgPGlzYWt1LnlhbWFoYXRhQGludGVsLmNvbT4N
Cj4gLS0tDQo+IHYyOg0KPiAtIE1ha2UgZmxhZ3MgcmVzZXJ2ZWQgZm9yIGZ1dHVyZSB1c2UuIChT
ZWFuLCBNaWNoYWVsKQ0KPiAtIENsYXJpZmllZCB0aGUgc3VwcG9zZWQgdXNlIGNhc2UuIChLYWkp
DQo+IC0gRHJvcHBlZCBzb3VyY2UgbWVtYmVyIG9mIHN0cnVjdCBrdm1fbWVtb3J5X21hcHBpbmcu
IChNaWNoYWVsKQ0KPiAtIENoYW5nZSB0aGUgdW5pdCBmcm9tIHBhZ2VzIHRvIGJ5dGVzLiAoTWlj
aGFlbCkNCj4gLS0tDQo+IMKgRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9hcGkucnN0IHwgNTIgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiDCoDEgZmlsZSBjaGFuZ2VkLCA1MiBp
bnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9h
cGkucnN0IGIvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9hcGkucnN0DQo+IGluZGV4IGYwYjc2ZmY1
MDMwZC4uNmVlM2QyYjUxYTJiIDEwMDY0NA0KPiAtLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3Zt
L2FwaS5yc3QNCj4gKysrIGIvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9hcGkucnN0DQo+IEBAIC02
MzUyLDYgKzYzNTIsNTggQEAgYSBzaW5nbGUgZ3Vlc3RfbWVtZmQgZmlsZSwgYnV0IHRoZSBib3Vu
ZCByYW5nZXMgbXVzdA0KPiBub3Qgb3ZlcmxhcCkuDQo+IMKgDQo+IMKgU2VlIEtWTV9TRVRfVVNF
Ul9NRU1PUllfUkVHSU9OMiBmb3IgYWRkaXRpb25hbCBkZXRhaWxzLg0KPiDCoA0KPiArNC4xNDMg
S1ZNX01BUF9NRU1PUlkNCj4gKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiArDQo+ICs6Q2Fw
YWJpbGl0eTogS1ZNX0NBUF9NQVBfTUVNT1JZDQo+ICs6QXJjaGl0ZWN0dXJlczogbm9uZQ0KPiAr
OlR5cGU6IHZjcHUgaW9jdGwNCj4gKzpQYXJhbWV0ZXJzOiBzdHJ1Y3Qga3ZtX21lbW9yeV9tYXBw
aW5nIChpbi9vdXQpDQo+ICs6UmV0dXJuczogMCBvbiBzdWNjZXNzLCA8IDAgb24gZXJyb3INCj4g
Kw0KPiArRXJyb3JzOg0KPiArDQo+ICvCoCA9PT09PT09PT09ID09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gK8KgIEVJTlZBTMKg
wqDCoMKgIGludmFsaWQgcGFyYW1ldGVycw0KPiArwqAgRUFHQUlOwqDCoMKgwqAgVGhlIHJlZ2lv
biBpcyBvbmx5IHByb2Nlc3NlZCBwYXJ0aWFsbHkuwqAgVGhlIGNhbGxlciBzaG91bGQNCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpc3N1ZSB0aGUgaW9jdGwgd2l0aCB0aGUgdXBkYXRlZCBw
YXJhbWV0ZXJzIHdoZW4gYHNpemVgID4gMC4NCj4gK8KgIEVJTlRSwqDCoMKgwqDCoCBBbiB1bm1h
c2tlZCBzaWduYWwgaXMgcGVuZGluZy7CoCBUaGUgcmVnaW9uIG1heSBiZSBwcm9jZXNzZWQNCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwYXJ0aWFsbHkuDQo+ICvCoCBFRkFVTFTCoMKgwqDC
oCBUaGUgcGFyYW1ldGVyIGFkZHJlc3Mgd2FzIGludmFsaWQuwqAgVGhlIHNwZWNpZmllZCByZWdp
b24NCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBgYmFzZV9hZGRyZXNzYCBhbmQgYHNpemVg
IHdhcyBpbnZhbGlkLsKgIFRoZSByZWdpb24gaXNuJ3QNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBjb3ZlcmVkIGJ5IEtWTSBtZW1vcnkgc2xvdC4NCj4gK8KgIEVPUE5PVFNVUFAgVGhlIGFy
Y2hpdGVjdHVyZSBkb2Vzbid0IHN1cHBvcnQgdGhpcyBvcGVyYXRpb24uIFRoZSB4ODYgdHdvDQo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZGltZW5zaW9uYWwgcGFnaW5nIHN1cHBvcnRzIHRo
aXMgQVBJLsKgIHRoZSB4ODYga3ZtIHNoYWRvdyBtbXUNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBkb2Vzbid0IHN1cHBvcnQgaXQuwqAgVGhlIG90aGVyIGFyY2ggS1ZNIGRvZXNuJ3Qgc3Vw
cG9ydCBpdC4NCj4gK8KgID09PT09PT09PT0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiArDQo+ICs6Og0KPiArDQo+ICvCoCBz
dHJ1Y3Qga3ZtX21lbW9yeV9tYXBwaW5nIHsNCj4gK8KgwqDCoMKgwqDCoMKgX191NjQgYmFzZV9h
ZGRyZXNzOw0KPiArwqDCoMKgwqDCoMKgwqBfX3U2NCBzaXplOw0KPiArwqDCoMKgwqDCoMKgwqBf
X3U2NCBmbGFnczsNCj4gK8KgIH07DQo+ICsNCj4gK0tWTV9NQVBfTUVNT1JZIHBvcHVsYXRlcyBn
dWVzdCBtZW1vcnkgd2l0aCB0aGUgcmFuZ2UsIGBiYXNlX2FkZHJlc3NgIGluIChMMSkNCj4gK2d1
ZXN0IHBoeXNpY2FsIGFkZHJlc3MoR1BBKSBhbmQgYHNpemVgIGluIGJ5dGVzLsKgIGBmbGFnc2Ag
bXVzdCBiZSB6ZXJvLsKgIEl0J3MNCj4gK3Jlc2VydmVkIGZvciBmdXR1cmUgdXNlLsKgIFdoZW4g
dGhlIGlvY3RsIHJldHVybnMsIHRoZSBpbnB1dCB2YWx1ZXMgYXJlDQo+IHVwZGF0ZWQNCj4gK3Rv
IHBvaW50IHRvIHRoZSByZW1haW5pbmcgcmFuZ2UuwqAgSWYgYHNpemVgID4gMCBvbiByZXR1cm4s
IHRoZSBjYWxsZXIgc2hvdWxkDQo+ICtpc3N1ZSB0aGUgaW9jdGwgd2l0aCB0aGUgdXBkYXRlZCBw
YXJhbWV0ZXJzLg0KPiArDQo+ICtNdWx0aXBsZSB2Y3B1cyBhcmUgYWxsb3dlZCB0byBjYWxsIHRo
aXMgaW9jdGwgc2ltdWx0YW5lb3VzbHkuwqAgSXQncyBub3QNCj4gK21hbmRhdG9yeSBmb3IgYWxs
IHZjcHVzIHRvIGlzc3VlIHRoaXMgaW9jdGwuwqAgQSBzaW5nbGUgdmNwdSBjYW4gc3VmZmljZS4N
Cj4gK011bHRpcGxlIHZjcHVzIGludm9jYXRpb25zIGFyZSB1dGlsaXplZCBmb3Igc2NhbGFiaWxp
dHkgdG8gcHJvY2VzcyB0aGUNCj4gK3BvcHVsYXRpb24gaW4gcGFyYWxsZWwuwqAgSWYgbXVsdGlw
bGUgdmNwdXMgY2FsbCB0aGlzIGlvY3RsIGluIHBhcmFsbGVsLCBpdA0KPiBtYXkNCj4gK3Jlc3Vs
dCBpbiB0aGUgZXJyb3Igb2YgRUFHQUlOIGR1ZSB0byByYWNlIGNvbmRpdGlvbnMuDQo+ICsNCj4g
K1RoaXMgcG9wdWxhdGlvbiBpcyByZXN0cmljdGVkIHRvIHRoZSAicHVyZSIgcG9wdWxhdGlvbiB3
aXRob3V0IHRyaWdnZXJpbmcNCj4gK3VuZGVybHlpbmcgdGVjaG5vbG9neS1zcGVjaWZpYyBpbml0
aWFsaXphdGlvbi7CoCBGb3IgZXhhbXBsZSwgQ29Dby1yZWxhdGVkDQo+ICtvcGVyYXRpb25zIHdv
bid0IHBlcmZvcm0uwqAgSW4gdGhlIGNhc2Ugb2YgVERYLCB0aGlzIEFQSSB3b24ndCBpbnZva2UN
Cj4gK1RESC5NRU0uUEFHRS5BREQoKSBvciBUREguTVIuRVhURU5EKCkuwqAgVmVuZG9yLXNwZWNp
ZmljIHVBUElzIGFyZSByZXF1aXJlZA0KPiBmb3INCj4gK3N1Y2ggb3BlcmF0aW9ucy4NCg0KUHJv
YmFibHkgZG9uJ3Qgd2FudCB0byBoYXZlIFREWCBiaXRzIGluIGhlcmUgeWV0LiBTaW5jZSBpdCdz
IHRhbGtpbmcgYWJvdXQgd2hhdA0KS1ZNX01BUF9NRU1PUlkgaXMgKm5vdCogZG9pbmcsIGl0IGNh
biBqdXN0IGJlIGRyb3BwZWQuDQoNCj4gKw0KPiArDQo+IMKgNS4gVGhlIGt2bV9ydW4gc3RydWN0
dXJlDQo+IMKgPT09PT09PT09PT09PT09PT09PT09PT09DQo+IMKgDQoNCg==

