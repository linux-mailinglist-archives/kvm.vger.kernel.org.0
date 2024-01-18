Return-Path: <kvm+bounces-6415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5B4183124B
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 06:15:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F4D51F23237
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 05:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EAB78483;
	Thu, 18 Jan 2024 05:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kbW6fakf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F0A4699;
	Thu, 18 Jan 2024 05:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705554924; cv=fail; b=hy0NmvRvjYP9zOYHg7Ag6xgRO/wFeCzBADrBSk8tY+HW3teiEZfIQYljyYfzJ3uGL0eJJrK6OMa0ZXneJwCmuwAbsNu0fu5B2poE3+8/OR46IGTb5c1I/RmoePfBOKHI+yRKUuRC3XJv6MBFL6/6QzPlfVf/T25r9H9eNW3Bf9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705554924; c=relaxed/simple;
	bh=xobUZg7pF8+/pq0/RkoMuSzpLf6nkrU3klETztz36bk=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:Received:Received:Received:Received:Received:
	 ARC-Message-Signature:ARC-Authentication-Results:Received:Received:
	 From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	b=mA3y5sFNgrbwFMWRkqXsT1FJjitNT807eblYZSVEPhynpl2bssYWqcA488ikLa5bkL7ZemKegf6D39AEt20fdna2qv66VLxXJURwHZzL+ZqFEBAgcyb9CHJMWZVprMl0KxgoQ2Hq0Lv5Apzv09U0N1opTNBUI2CC4NSLADJvjx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kbW6fakf; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705554923; x=1737090923;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xobUZg7pF8+/pq0/RkoMuSzpLf6nkrU3klETztz36bk=;
  b=kbW6fakf4mOaQY3xHLYYIiDZopIowzo+vTCrVEzdYAmG8GPmTQunuuiK
   rBxRlP9G0lnwmcmxoBKYoMqXMj1xFxtnxIwCORDEVdVm62uVYgM8DKwuc
   75f5Mt6NTnWLFI/nsdtTf7VlZEmFQ9vpxI5sThO+Crpo9EWr4IhbG8H/5
   sZ8H/3pDGGMRlAByjxtnAzek0Mu7MDav+vermBUNcnnkzGwYk6/L6GXqx
   /wg8qTRZJKqhxfquEaEZhQXY0attDCYIZwOIQEb1lnYz8FvdVHz1MgtoU
   HAKxAvn14a1rsUQ8hf7UfvRY3ipSup3pU8T7r3VexU7vh52uygf7JEyM1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="18947242"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="18947242"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 21:15:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="235436"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jan 2024 21:15:18 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Jan 2024 21:15:13 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Jan 2024 21:15:13 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Jan 2024 21:15:13 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Jan 2024 21:15:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bf0yLHkheNbu7lzPE8xd5U7H0fXBbUcvSzv+RB8NJmqOLywhuNjbhGGSSKwZ/67pnTeXrfoDrkKokdPXFwh1w0COTPcmaKe3cBWIcJqw5G0hK82K18n3syVKOurQQ9sY7E5f7hqCAtQu4eYlL9wKYj3AKA2qI60JRNxtGl4kpjR4f6+EXqbfh5t7shhJs6VvFdMpDG8jZMc8ymPaqn/4gYpO+mcuNP6S5JLFB+XloCxWqohL/LFg0NZ+A3+7iovuqKExYjY2tPbYA2OgQbuyS7rewMJMfH1Xn9QeQEho9vNF60JLWidZ6405l6KcHe7Qj+4iYzlGpghxwhymeaiVyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xobUZg7pF8+/pq0/RkoMuSzpLf6nkrU3klETztz36bk=;
 b=HDR8ZHgeIzENYOhf9U+jsFmx3JkFLN2/vcCRiPa7AGui5WmPyD/xBwNAPJ8eeIjJKVLZ0X+iUNDsJzCvcG3ko+KVP3KC4x9zqMMod3mdmV1nb1hPCIdKE2PqoZ6z0a1mL7qQqD4hqzD9nLanthHPLbc0K4ORaOsvk9fMBFpKuxgLzbAiqlAO2iQB2DJmKCtl0HHhv+FThJX6NhQ4kL9yB3lizt89Qlv8kzEfUzGe/Y3Re5tnE/bO28oFsJN2p2wmXdbmTSVrrLqxenxdH3Yum8v2L8e2iMoFlepbv9mvWizk4P8qF3FVy+bQeF1vmPfDW6KGMNeEGTG23liFv1+sng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CYXPR11MB8662.namprd11.prod.outlook.com (2603:10b6:930:de::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.23; Thu, 18 Jan
 2024 05:15:11 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277%4]) with mapi id 15.20.7202.020; Thu, 18 Jan 2024
 05:15:11 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Topic: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Index: AQHaRT8NfyvFkqdAjk6/fSX6qVKXsrDcFbiAgAIkzVCAALI0AIAAIlmA
Date: Thu, 18 Jan 2024 05:15:11 +0000
Message-ID: <SA1PR11MB6734D202AAD1F99628466A45A8712@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20240112093449.88583-1-xin3.li@intel.com>
	 <ZaY0UbFjwCYh4u/r@chao-email>
	 <SA1PR11MB67340002B67910588EE335B1A8722@SA1PR11MB6734.namprd11.prod.outlook.com>
 <6d8d04899f00a05ef2512f24f81e58fcb4dad098.camel@intel.com>
In-Reply-To: <6d8d04899f00a05ef2512f24f81e58fcb4dad098.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CYXPR11MB8662:EE_
x-ms-office365-filtering-correlation-id: 6e502292-599c-478d-7295-08dc17e47238
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yvUyCQV+Y/ZDQRO4Pf1tWLCCb/NIPv8EZGjJzk7ymTuHJ/UF6qMCdOZEKi5fzNbEwCfz0ck/ZApxWj6KK3W+0WrGEFxq4Q8tkRoM5vqBUPWEfJPFtoowRMbIKg19wjYG0esgJLowYLrjETMKpY+VbxnI52WDLDTGHI6MZlyCTsDBGLOJslqeMcTC9e8DwuDXQ/43GI76XGdO+nCHa50lcHfKN/bdH8tYwXofNffDwOLjZKiqzYXcDBX5t0sl5fMNr+Z5pFdRbRXV/yrs28+CwHPQbrpIDyGiqcTjNX3aWBdnU2PXTkp0G1SQw41VSPqOOq8rvQh/0uFEEsg5KJGjeDhnf1j7rpEGECnRZFJQJ01kyRp5ZS7R+i1FP8nsLH9sgya8pOjyuEwrSjFDgaX1KtcpVUdZD8e6WI7s1Ya+YOCE3CeD3koR2E81bphsO5n070vYYOhOTlT0rb0TvDxNXbRBKgsVqHKdzi4Dl92lihodX4aG/2kVeEMZDTER/Z/tT0r5Xjn+m/XA7oCpypamv2Z68pWEddnCNjFnsXAEW3Q3V2BJpoF105FycmSAQb0e/fkVuLh4sabRBJD+BsGPc19qJ2EMJW4dHsk0JVsi2nVCxLNStlRwtXMjHl3sPmKT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(136003)(366004)(376002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(26005)(9686003)(66556008)(38100700002)(122000001)(66446008)(4326008)(52536014)(8676002)(6636002)(7416002)(4744005)(2906002)(8936002)(5660300002)(41300700001)(478600001)(76116006)(316002)(54906003)(110136005)(66946007)(66476007)(64756008)(71200400001)(7696005)(33656002)(86362001)(6506007)(82960400001)(38070700009)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVJndFVqMFRJK05zSE5sT3UvYXJ0V0RBY28vY3dDbndkdHFZOVBtcHZrcmFR?=
 =?utf-8?B?N2ZxaHhxMjVmbjVzbFpncXRkN1JIWHFQY3B6bzk3UDdXeEJtQmdkR3dpY0lG?=
 =?utf-8?B?OGxLZEZ3dk1ZTGJuRVErTXNKTlN3QytveUdQdlNjQ1p2MkR3RnZyalZZK0pO?=
 =?utf-8?B?RUg5NVp3N1dMcWxoUkhYR0ZlY3hFcjR3NHJpZ3hNeFpVL25vRzIwUEtPRyta?=
 =?utf-8?B?dzdhVmUrd2luUkVFNWlkUDBkS0tMWlJFeFFWL2llMXBTTVBjaytrRVZjazVN?=
 =?utf-8?B?WlNrM3BBVVBSQ1ZhWmpaWWhGQ1dwWFN2NE5Uem5vV3hnYUVaUis3Qjg5Ylpz?=
 =?utf-8?B?WENSUWYza2xyNy9Nc1NMcFhhYXBINjZDei93QkFUZXJGQVVuVkxDd2FjSHIz?=
 =?utf-8?B?RlBSNU5JSWVacmw4MHhHQ21OeDI4WUhGc0wyVWF2VlE3VDc4Y3BlTXJLdURV?=
 =?utf-8?B?ejJiZTc4Mi9ZdDNtT1FKVDA2b0dsY05yQ2ZCdVZxbGpSUmJYOEVwaExkRklT?=
 =?utf-8?B?cWpjUDRjSUNtQmo0UnBGdkd3UGJwN0NaUFhhY2dFQ1RPTUgxR3RLV0pITUJ3?=
 =?utf-8?B?SjVaeXlYdDkrWHUvbG5IcDBKY3U2eU10N0JaZ3FzUjhlY1pXT2RiWTVtaGw2?=
 =?utf-8?B?c0p6dVJEVzNXRktKYkNGWDlFQVM2ZFdJZU4wdW5CVWxyYVNTdEpwUEVkNEd1?=
 =?utf-8?B?ZUVQN2ZJRTgxZGFoQ2hWNTh4dkJqSGlDTkxObFNXSXpKbytISTdjZnVDc2d6?=
 =?utf-8?B?cjJXZGpKTklsTktvTnFob0lFdnEzVkJWekJzdGZ1YXRmWWdaM29QTlZOMzZP?=
 =?utf-8?B?Y2VVZ0JiUk1rY01YUURTMGpXajBVbVVmYmw0OUlReUhyN3diRHVUUHJ4aWJM?=
 =?utf-8?B?K1dGZXQva1pBcUp4c3VSYi9aYkJuMi9mTUluUmJTaW5mU0Fxd3BzL0tway93?=
 =?utf-8?B?c2VWRndZQnZ4WkZCczI3V3NaTTNKSTBCVGZ0WEZnZHNlM3dneDNTQVptSzZE?=
 =?utf-8?B?Q0Q2a0dzaWxIVFdHZjNJbG13elhtbi8yUEUxUzFzdjM4Y0pGQ0hqOHlLZitP?=
 =?utf-8?B?ekdSVk5tQ0c3ZUp2Y3grSFFVVGNudkZVNlIzVndwS2g2bFlkRFpEQVNsTXV6?=
 =?utf-8?B?eUt3Uk9vZGY5V3V6UGE3VkdIU3ZBeE9pc0U1TDE3OXova0sxTjY2Q3llSVh2?=
 =?utf-8?B?V2NXam9KRDlCUW8xb0dNYjNya0VuVWtUL3NjdG1EbHVtN2JMU2ZxVTlSa1Fs?=
 =?utf-8?B?TnZGc2VPeFJMMFJNVXZxRlc0NjN4NFh3YVZhMUxaMGtsS0pKSjlSL3cyM2FE?=
 =?utf-8?B?bXMwZ0JQUjJPemNrL1ZxZnhDRUN1QXBkTTlPcDZiWVM3ajliRGh2RVZmNkQr?=
 =?utf-8?B?MGpyWjdHcmxNY1M4UGtNSlpxZTRPNXRnMlhqYi9rK3daeE9taHRCYlYzQ09X?=
 =?utf-8?B?dmhsOUtyb2lxUWtIUjI5Y25nQXFCK2Y5ZWxaYXg1TWNyeVROWUhZK1VteW1S?=
 =?utf-8?B?RWJUZCtBZjFWZWMzOHhUSlRQcWtrVnk5ejYrU0VCZHozcnIwdWpwTkJILzJH?=
 =?utf-8?B?SHpKa0lsZnkySkNzMEhvYnZHWHhWdFdNZTdraWh4c0FSdzdmRHdCUXUrVmxF?=
 =?utf-8?B?dkQzd1BIODF6UC82eEhuUVM3WSswQU1zWWkxd1E3Szd2cEtXc3EwenFvWFVV?=
 =?utf-8?B?elZkRVg4SWxIcTFsK21aV2lBNXhYMUtmdDZWWUhucmZ1b0JhWUJMaEk3cDdk?=
 =?utf-8?B?RFU3N2Y1OGlHd1hPNkJjbWdBaW5TUWppVHdrdSt1K1RQWTQ5N09USjVrWDdM?=
 =?utf-8?B?c29YemJzbnZCNlR3UnRpdnEzRjd1V3h6Z1ZjR0xyazlIWGJIL2xuUDVaYlRM?=
 =?utf-8?B?KzNEWmtaakxYd25aOC9xZmVpOUQvMHMreHduQnpjby8zVUFrQ0FuTlFKdmRC?=
 =?utf-8?B?NndmYU54bjFqV3A2ZnFoY2VIWGMvekhXdEZMRzA1a3RwUGRqcnYrSlExYUls?=
 =?utf-8?B?Tk1XNkdNdXQxR05LRy9YbkhrS24zNENPbHlnTVBvT1JWaHRtZGxDbFNBMHdX?=
 =?utf-8?B?THRyMng3U3BrMVdzelhXTC9BemxOYU5icGNna0gvaWdkdkhqME5aVkk1a0Rx?=
 =?utf-8?Q?uvLI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e502292-599c-478d-7295-08dc17e47238
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2024 05:15:11.5869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: USAm/72CYRToRDUTPuYS4KukLbQZlhcdpSeH4shfbSrymW99gAq8k3zl6atFYuyCw6uP3wf+qFrWudTYryDujQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8662
X-OriginatorOrg: intel.com

PiA+ID4gPiAJICogS1ZNIGRvZXMgbm90IGVtdWxhdGUgYSB2ZXJzaW9uIG9mIFZNWCB0aGF0IGNv
bnN0cmFpbnMgcGh5c2ljYWwNCj4gPiA+ID4gCSAqIGFkZHJlc3NlcyBvZiBWTVggc3RydWN0dXJl
cyAoZS5nLiBWTUNTKSB0byAzMi1iaXRzLg0KPiA+ID4gPiAJICovDQo+ID4gPiA+IC0JaWYgKGRh
dGEgJiBCSVRfVUxMKDQ4KSkNCj4gPiA+ID4gKwlpZiAoZGF0YSAmIFZNWF9CQVNJQ18zMkJJVF9Q
SFlTX0FERFJfT05MWSkNCj4gPiA+ID4gCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiA+DQo+ID4gPiBT
aWRlIHRvcGljOg0KPiA+ID4NCj4gPiA+IEFjdHVhbGx5LCB0aGVyZSBpcyBubyBuZWVkIHRvIGhh
bmRsZSBiaXQgNDggYXMgYSBzcGVjaWFsIGNhc2UuIElmIHdlDQo+ID4gPiBhZGQgYml0IDQ4IHRv
IFZNWF9CQVNJQ19GRUFUVVJFU19NQVNLLCB0aGUgYml0d2lzZSBjaGVjayB3aWxsIGZhaWwgaWYg
Yml0IDQ4DQo+IG9mIEBkYXRhIGlzIDEuDQo+ID4NCj4gPiBHb29kIHBvaW50ISAgVGhpcyBpcyBh
bHNvIHdoYXQgeW91IHN1Z2dlc3RlZCBhYm92ZS4NCj4gPg0KPiANCj4gUGxlYXNlIHRyeSB0byBh
dm9pZCBtaXhpbmcgdGhpbmdzIHRvZ2V0aGVyIGluIG9uZSBwYXRjaC4gIElmIHlvdSB3YW50IHRv
IGRvIGFib3ZlLA0KPiBjb3VsZCB5b3UgcGxlYXNlIGRvIGl0IGluIGEgc2VwYXJhdGUgcGF0Y2gg
c28gdGhhdCBjYW4gYmUgcmV2aWV3ZWQgc2VwYXJhdGVseT8NCj4gDQo+IEUuZy4sIHBlb3BsZSB3
aG8gaGF2ZSByZXZpZXdlZCBvciBhY2tlZCB0aGlzIHBhdGNoIG1heSBub3QgYmUgaW50ZXJlc3Rl
ZCBpbiB0aGUNCj4gbmV3IChsb2dpY2FsbHkgc2VwYXJhdGUpIHRoaW5ncy4NCg0KSSBnb3QgdG8g
ZWNobyB3aGF0IENoYW8gaGFzIHN1Z2dlc3RlZC4NCg0KWWVhaCwgaWYgd2UgYXJlIGdvaW5nIHRv
IG1ha2UgdGhpcyBjaGFuZ2UgaW4gdGhpcyBwYXRjaCBzZXQsIGl0IGhhcyB0bw0KYmUgYSBuZXcg
cGF0Y2guICBJdCBjYW4gYWxzbyBiZSBhIHNlcGFyYXRlIHBhdGNoLg0KDQo=

