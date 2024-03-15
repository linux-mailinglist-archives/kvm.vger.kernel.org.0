Return-Path: <kvm+bounces-11870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C288A87C6AA
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 01:06:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38DA4B2155E
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8AF07499;
	Fri, 15 Mar 2024 00:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g5vk295T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C02F6FB1;
	Fri, 15 Mar 2024 00:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710461203; cv=fail; b=GQFEbjOP+zLQg6bM1T1OXCVF9g2d3c+fcmhc9GqN/hrbrWFCmTIzTIxvgJ9Zz0ruN8Q6sGrAFVP3BocxbqlVfvN4Ap1zjdV52fEOm/pYAPfCs/5SEI0sl35lj2UYUbI3HH0hIuN5Y08HMvXKX3yojKA7iw/u/QzqZjuVB0a2/pQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710461203; c=relaxed/simple;
	bh=5XhHFBKwUhOoq2aDyFjL7hGnTuDhuM+aJt8605OpXAQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OmKi0nRAEHhmLlpsgcJI5nQV4GmbCsVOjh9jc0xUOCBEM8044XT4EDJEqX7cCe1l04dyiiF+yJyimaWoveIcPfeCIWLs6lwW877S+YpeegiDc2U532J45zBFA7EYqTG7aX4P0DZv5fR5janBuBAXTeYb4RYa+waVy0xi1744fYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g5vk295T; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710461201; x=1741997201;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5XhHFBKwUhOoq2aDyFjL7hGnTuDhuM+aJt8605OpXAQ=;
  b=g5vk295TBOBRmYoCGI+iAD17rCtpzn1aI+38qSTfMS2y0v76nYXFOfxU
   NBo+9vUp8Zz+XWisdQamor80dQgG/JFvwWvGcFx9q04HDqdR6S4TpBRuO
   oBX1MQo0jKCkQFHqp3fykw3Yn+UGwtZs3lRrBL4MTYqlSk0n3ZsixQS51
   Xz8L3CxqU6od73TmBVZ5WTFrm0mYGzIeabGSK/CUhTokPMVaUu2I2b5iF
   GpZU9x2vK2BvpWpFlQDGVWiqhEZOeMWtvYW9UOB22n+VMao8wTgj5cSfy
   IOlIwwQmIs5GDarAmVGeDOSqeMuJ1g0ikgpS+zU1IzgzNdBo/qPoT6zLv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5518280"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="5518280"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 17:06:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="12562132"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 17:06:40 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 17:06:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 17:06:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 17:06:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MAwahonAHDceowJEKbHvz3vZQk0CvJAmQ8pgj7r54CtROwiHIM4CRi5n26J/B78oM1jmcwHQTWtdKMCbx1ZJqJHtbKxLfwkQlSY66g7EVy49N5bLskxuXByoW4emUwHz7mU4M5DRNqft094AfIsFXAJwXhb8a5K4QIfMrp7DZJ0oIX6kxKolFa7VomFQogaUn1cx7WbJwudm1dlJKNzf8sIGy4In1hgbtr2R+8lS5ACmEtSLxi3jen4TMoWpYX7qLsrHg00buuX/cCegGQ8dVE5JC7jutsgAA3SOpD687mf31auUjuhX/ax+bP8CDNy28mRxfssxCk9YE73a7NfWQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5XhHFBKwUhOoq2aDyFjL7hGnTuDhuM+aJt8605OpXAQ=;
 b=I4yIJcufOWiCKVA/xcbjiI9ZKDqT40h7/sp25YHOnuXe1DNTVMuU6SAHhcS4gd/H1Vg1QVEMQXoSxfvg5SpfEot9jaPTWEgV5M1Vgr1jbh4uhlgLT17SMmSd5zlBj4QZ65faJkoCVLe5+U7FmEbtP59hFXcdX8D3UenTuxryssM76NStSHa5xDhunS3cJFprd11AzRWvOo1k+tVfsnxxcGWWdIfv7NzJ5YZg2L1JMBwUuR6xxsIKpvTkOKgdfcerFWhPOlCb+NDMcTjxURNDgqvn1fyp/UrZ6RKyNXDsf+P2IYOLpGbP7/iUV+KdZQI9GGm0e2SFEm//lK12mE9uAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by SA1PR11MB8317.namprd11.prod.outlook.com (2603:10b6:806:38d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Fri, 15 Mar
 2024 00:06:31 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::4f6f:538b:6c36:92f6]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::4f6f:538b:6c36:92f6%7]) with mapi id 15.20.7386.017; Fri, 15 Mar 2024
 00:06:31 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 120/130] KVM: TDX: Add a method to ignore dirty
 logging
Thread-Topic: [PATCH v19 120/130] KVM: TDX: Add a method to ignore dirty
 logging
Thread-Index: AQHadmyiHbz3BdiqjUa/DQsd0Q/1DQ==
Date: Fri, 15 Mar 2024 00:06:31 +0000
Message-ID: <b4cde44a884f2f048987826d59e2054cd1fa532b.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <1491dd247829bf1a29df1904aeed5ed6b464d29c.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <1491dd247829bf1a29df1904aeed5ed6b464d29c.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|SA1PR11MB8317:EE_
x-ms-office365-filtering-correlation-id: 82fe9d62-48e3-4bde-f202-08dc4483c4d4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ijBazQTuDz/6sXPBjzU6ZmRRnTWUYG8VST90KFMCyoo0bL1zVBsQZv0t3u0pqtCcFWDhCe16Ey31iiFBcjIZoWQHeG5yVqVlti6o4sxiUqp8aDZMbwPr65xFINgrCo5HhAS/In5agmztJHFYqAmyYL65cW6i9L4Vo/0JA9pbdEeyJ+WUa9kLAoFI80Y++lvBOxK9/W0cCPl5FLNAerOSnDcw/tr/CCHKC3JsptBl1OZmSHFyno8sZoHnLq2ZHqqdTkobzXsrDgZj8fPhzdkuqgAbD7DYvs3xkL0cz6nUeSE6f/jCopSIazF8uv2BIiHURWwXz3c8VScxTWM8FL57+ceA8i8AFohzsL5hSNxH4EU/q6Tn9mUptu/34ddSK3OboPE5LPlAKDKteIb9CPTONiJtgfGsDwwu2tzA20oXnlCApjRErIOcsILJyiYfZetzi3o3H6q8JfsY+3fvCliMIs2RTn8UgTNSlzJeJ8HFwuFd+FwtHr2jLWpg1ZHivlyeVnqS+EJHK7lfUmLuZXJCx+gR9AmLREbk3incf+7mAC25Lbr9v3CZjLMGHLM4iqktUhbyRScSlpQ0qfFktLUeGUvLw76Or5c8Jd+BK3HgGZghD/okSCJowV1QdSNwCwiDzYlf27EH/yvGMS91SnQylP+XY4UpAL5iC8GiI4vTkVgT7kt609e2hqBoEwCB9Lsaoy7uyqrTMak77rM7+Z/hg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NnQwdlN0RCtwekZWbm1TUU8vN0lPcXlqVGpBWFZOWXN2YWZHUjBvNFNDQVRV?=
 =?utf-8?B?YWpLcE1ja2xHTVBmTFc2L1F5cUIrQktidnBmSXZhRnFMOVBjcEFpNnFkMk0z?=
 =?utf-8?B?dS9TS285ZjduOHVMYXFNM1RFbXNrMStZRTFGOXVaaXV2SVBJcUVFay8zRE5G?=
 =?utf-8?B?aGpFN3hNOGZCN3llRGczOWEyM21INHRFQ3RmbDhlK2ZiNTM4Mlpac0JlU0pJ?=
 =?utf-8?B?TUFtaGIvVUIwNEJPcWk5elgzREs3Y3dBckR5NlI4bzdtVE9qSEMxc0FXODNK?=
 =?utf-8?B?WDZDMjVxMFlMUTZReU5zODQ5S2tuNGlGVU1jOUovcXU4QjZ0ei83RkRsZEQ4?=
 =?utf-8?B?WFJvMGpGNDhUMkM2M2VjYm91bHlNQ0ZaT2tkR1pWdzVNVFZZRURvR2MwcFU0?=
 =?utf-8?B?cHBId2NaZVRHaTh2cm4vTGlIOHdsckIxRlhaZGpDUWhYZndSR0dTN05MUUh5?=
 =?utf-8?B?eEVWdkpOSXJMdVphZ3FDZHNCN3pPTmI0VjBoN1pySm85UXNkTWhnYm1GM1lO?=
 =?utf-8?B?cmQ5TmVaNTNsajBlc0lkcXNSUVVlQ3pnamQ4c25uN2dKdklLVzNlaG96aVdr?=
 =?utf-8?B?SVhaZDdIUERIc3ZGZUhZaWRqbzJWVXpBL0hpSnhSSUJ2ODhUbXN3UlZWZ05S?=
 =?utf-8?B?eWNDRllkTDJPUndVRDBHT2VZWjRnNVVSZlJWNVhmTlFJSUMxNzFod3hiUGpp?=
 =?utf-8?B?NVgvamczRnowM2ZzNmFLWkZNTGtwN0QxeXh3NDB1VlRFL1FiWGRwdDR5cWhD?=
 =?utf-8?B?RW9JclpxUWJEZXFJbklRaWt5aGM5Ti9hTGE3czI5d1htS0l3eVA4R3M0b1g0?=
 =?utf-8?B?VjZiaS9mZkhGY0Mxd2c2N0NzT0RMQ1hoQ09ZdW9hemFxYjlGZlJmZU5Gb3Bw?=
 =?utf-8?B?azUrYUdMZGFYVHg2WUhLam02RUpnM0hhcnJaUlNsTWRnRWg1dDJYWkJrODND?=
 =?utf-8?B?L2tuK05NMTRvck1NSy9HaE9JU29qd0dsZFRxWTZ4Y3lGZnVBQW9ONDVjc29U?=
 =?utf-8?B?S1RLRU9jdnpLTnZoU0ZOY0FRSTdjVHkxVVU5V2ZFdmVnekNyODJHYURmKzlO?=
 =?utf-8?B?T1NTVkJDWmY0SzZWOXo3cWU1R0lpZGpaSEZHRXFuRlo1aGxPUFFYQVNhVW9x?=
 =?utf-8?B?TkxRaFZjZnBBNTZuNi9iRmVXeWtMUlZObUxrd0lOQnFqTE5wRVRhQ0lQMkNx?=
 =?utf-8?B?Mll0N0svS3czQlR6NkwvOVh1UnVvMlFPbkk0SjFPZVoxSzB4MTNCYXRyNHNV?=
 =?utf-8?B?VGRrRXg1dENlNldZa0o1bG5DRnp5VTh4ZHIyaXN6d2lmWUJueE1LZVk0TTB5?=
 =?utf-8?B?UzdZR1poSWhiWmNIckZLM1AxM1AzMlpRRXpLTitWWjRnMStLN2FlQlRlbndL?=
 =?utf-8?B?VzNGeXpWR2FzTVVoRjR6WGlqT2JkaWdXM0tHdFdhNWhuU24wNDF2bkNHNG1K?=
 =?utf-8?B?ZVIwV0FlS1V5MUVUOGVEZHpPV2k2b1RrWDBJTkxxbUJmTk1ITVdRTWNSeTRw?=
 =?utf-8?B?dUUwdkF5UnpFNHViRVJESmVQSXgxVGhZaHpiY0UwZ3hMQ1Bvc2pwcTNRYUov?=
 =?utf-8?B?Skt0Tnp3QjhTRUZaOE41enBrOVR5U05qZzRmTGlPbjNFZzJXOHFyRFk3YnVk?=
 =?utf-8?B?UnZEdlNnNEVrYys2ZHFoc0trdmwwZlo5OXFiSjFIWXdUSUk1T1Z5N1l0clJH?=
 =?utf-8?B?V0Y4NDl3WjJ6N3JxNG8rWVNIdFJpRWh0VlF3Qit4RVUycnM3eE0rK3NnSit4?=
 =?utf-8?B?Si9Qc1JtZnVZbGtsQkVuMURCSVNXVUlWcFhkSmhaTHNuRHN6Vy95MXpJcHJq?=
 =?utf-8?B?YmJRMVJmckxZSlBOMG9nMkpvQzNZUzA3R3dReHp3eXlZaSszQW9UbmkwdUhP?=
 =?utf-8?B?WWFsNGJJaWtQb0ovQnZITHpPWFBjQTR6MUlJRDBQem54VURCK0RvVm1UK01U?=
 =?utf-8?B?ZjNOSnRZLysvQndveVVVcndKQjJZdFFmS3BhMk5pZWZrYUltOUVJTGdKSU1t?=
 =?utf-8?B?S3VuOTAwU1F1U0JqbGloeCtHY1R0aGZCUWtxOHMxWUc4VzA0cHEvM1NMejda?=
 =?utf-8?B?ZTF0SldLRUxtZ1MxaWJCb1VFOHBwcGdWWW95cS9QUElrVVNBdlRQSnR5OVds?=
 =?utf-8?B?N245Nnc0dWVqMkxkTnAzZjkvbmdIRGFxUWhGL0R5Yk01THdVRzIzNU5wbnFn?=
 =?utf-8?Q?QTfnaIusq8GFSr+SwwtIMcM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A87FF07F3DA2CF409DAA3D80DA413166@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82fe9d62-48e3-4bde-f202-08dc4483c4d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 00:06:31.3060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wAkm3GaFS6pIddumfQpuVjS7vleB+v2a3eeKsfy/rA7Is91LF/Q9PN++osmQOwGhdRe5PFeEbquYGpaBi72xhU+0/pxvmwm+3GXf4qnvGYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8317
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI3IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IMKgDQo+ICtzdGF0aWMgdm9pZCB2dF91cGRhdGVfY3B1X2RpcnR5X2xvZ2dp
bmcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiArew0KPiArwqDCoMKgwqDCoMKgwqBpZiAoS1ZN
X0JVR19PTihpc190ZF92Y3B1KHZjcHUpLCB2Y3B1LT5rdm0pKQ0KPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcmV0dXJuOw0KPiArDQo+ICvCoMKgwqDCoMKgwqDCoHZteF91cGRhdGVf
Y3B1X2RpcnR5X2xvZ2dpbmcodmNwdSk7DQo+ICt9DQoNCkRpc2N1c3NlZCB0aGlzIGZpcnN0IHBh
cnQgb2ZmbGluZSwgYnV0IGxvZ2dpbmcgaXQgaGVyZS4gU2luY2UNCmd1ZXN0X21lbWZkIGNhbm5v
dCBoYXZlIGRpcnR5IGxvZ2dpbmcsIHRoaXMgaXMgZXNzZW50aWFsbHkgYnVnZ2luZyB0aGUNClZN
IGlmIHNvbWVob3cgdGhleSBtYW5hZ2UgYW55d2F5LiBCdXQgaXQgc2hvdWxkIGJlIGJsb2NrZWQg
dmlhIHRoZSBjb2RlDQppbiBjaGVja19tZW1vcnlfcmVnaW9uX2ZsYWdzKCkuDQoNCk9uIHRoZSBz
dWJqZWN0IG9mIHdhcm5pbmdzIGFuZCBLVk1fQlVHX09OKCksIG15IGZlZWxpbmcgc28gZmFyIGlz
IHRoYXQNCnRoaXMgc2VyaWVzIGlzIHF1aXRlIGFnZ3Jlc3NpdmUgYWJvdXQgdGhlc2UuIElzIGl0
IGR1ZSB0aGUgY29tcGxleGl0eQ0Kb2YgdGhlIHNlcmllcz8gSSB0aGluayBtYXliZSB3ZSBjYW4g
cmVtb3ZlIHNvbWUgb2YgdGhlIHNpbXBsZSBvbmVzLCBidXQNCm5vdCBzdXJlIGlmIHRoZXJlIHdh
cyBhbHJlYWR5IHNvbWUgZGlzY3Vzc2lvbiBvbiB3aGF0IGxldmVsIGlzDQphcHByb3ByaWF0ZS4N
Cg==

