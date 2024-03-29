Return-Path: <kvm+bounces-13052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B767A891330
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 06:32:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9C0C1C22D87
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 05:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0221D3C466;
	Fri, 29 Mar 2024 05:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nhg5bV60"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF1F3C060
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 05:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711690320; cv=fail; b=TzjbN27gyrto+sCVEPCiirrVGRLL7haAabCr4UFd9Df1phvGLqNxqRfDJAO4r8LPKSYpBTlI978Q28TAZiVg84MOfVgOhfOZqnkTeRCtbMdCgWT0sf9L4N29zoF2D7nvV+vB6wnTJoZy0ZPBuvYWst0j/7mPEGbbSXw/veMz1cU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711690320; c=relaxed/simple;
	bh=1z5sf0KLk0strTewOxOQ7MQ6yY0PISWUg8Ms3Udw5Hw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YLilYuHwq8s6q6qgFQR/dzZnFLzDOqQQjV7y7KThPUdADL3mE4Efp6VH2Fsg3IsKJiLHPu1vvwDn1rVJnPqGmEsS4ejrffYtz0/LnWs71YeaSSYZbdQlzX946rh0aMTkjaIg4HPk/eGSmnJEOCs6ENy/1+hFXp5Kb8F57UexOMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nhg5bV60; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711690319; x=1743226319;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1z5sf0KLk0strTewOxOQ7MQ6yY0PISWUg8Ms3Udw5Hw=;
  b=nhg5bV60xZ16LxqJuJ0U2Ni1H4aBXbOd+yeckkr4uxnvq2+HeKBRmEwU
   bLmnvxeD3rGktpAsVFzPN9Fn7vLdC2rZkKzPgd1ZiU3V8m3dggux53ZZf
   3qWb2SNa6WPdq7v8k30sHYC516kDSlQoBEfsyUoUVK/Dem9BOI6WXuqfZ
   YWwpu5tMFGsZhf34VexPpHW92CBC+xca897+IcWJ/uPXQeJDGoJCcUJtt
   Kw/nomnKGoOBtgmxH+9ET78X2I8KL+owhmtTKecxUHASTYaTc1qq3QJR4
   bnW5qbqvdigFgwK3QK5r2DJE4Fzw0dm9Cj+0rrPxjw6c9PYL6DkRNhfFq
   A==;
X-CSE-ConnectionGUID: flanHpTuSGmTVpoqncE1jQ==
X-CSE-MsgGUID: RoNub6pASfSd+DNkCz7POA==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="6738174"
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="6738174"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 22:31:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="16928617"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 22:31:59 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 22:31:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 22:31:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 22:31:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8zTAOCk48HzRaZLOZyM4Rz2wl7iczV2gfQZS7oyal8hAaimtuGT+Ad+fR12f+Q8Xah5qR2papBz/10XVpTXGexjLjEbmWchuBjG43l/AnlErZurDThbmOWngAQbZENFghj8wBwuIiFBCP4k+Z1AUzwfSzeQcccp7CAFIhqHrVTxRYofkpZIUVzJp1UfyYtzbN88ThLzUKF3nUHitSBTKzRymSXQ58JwYl39dzZMdYKENnTGg6r2jT7HS6MlAXpHD5QTYR757afTDq4ETQtqBG2S6o5tHGPuq3gz93JEcgeh7ZsOs67ynY08Sk5s7ZLym9NDaQ/jpem3yzJGShf1Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1z5sf0KLk0strTewOxOQ7MQ6yY0PISWUg8Ms3Udw5Hw=;
 b=ab8vzs8yuDCjbpmA7zA8euXH75D3+IiHErRf10P5nZ64yLMy+ypUYfFskQY29Lruz4SsI7KumLQfBi+YPnsdGmN70xm76eDsovqsKTucYF0elZbZzBaFISy8vM6yr1kA24zKlPOV+UcHw9wC2+OEegbM0ocyINu9rEAt9m1ktn49miE+Idb+N8YAlhZwG972p3KcZsAI+HPN1jtSMqsssRnvOqJytiX68OJgG22kJTJVqYU/ph+LcBJ7iVEY6aXE7Rk1GhvIeQH6cLY206Y6nP3Aomj8/iyTIgLc/ID+FsZU32lIS7Wwr3HiE4s2jhHACpXBXHjq0PMyoSq0zrbMRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10)
 by CYYPR11MB8331.namprd11.prod.outlook.com (2603:10b6:930:bd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Fri, 29 Mar
 2024 05:31:55 +0000
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::e4a3:76ce:879:9129]) by SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::e4a3:76ce:879:9129%7]) with mapi id 15.20.7409.031; Fri, 29 Mar 2024
 05:31:55 +0000
From: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 0/2] Two enhancements to
 iommu_at[de]tach_device_pasid()
Thread-Topic: [PATCH v2 0/2] Two enhancements to
 iommu_at[de]tach_device_pasid()
Thread-Index: AQHagQuswU7tTG/G0USa/UYOZse2O7FN+kcAgAAYqwCAAB9EIA==
Date: Fri, 29 Mar 2024 05:31:55 +0000
Message-ID: <SJ0PR11MB67446359C5577F6EBEE00B0D923A2@SJ0PR11MB6744.namprd11.prod.outlook.com>
References: <20240328122958.83332-1-yi.l.liu@intel.com>
 <SJ0PR11MB674441C2652047C02276FC25923A2@SJ0PR11MB6744.namprd11.prod.outlook.com>
 <902e9ca4-51d4-4705-9d60-e03f8d914ef9@intel.com>
In-Reply-To: <902e9ca4-51d4-4705-9d60-e03f8d914ef9@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB6744:EE_|CYYPR11MB8331:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IZByCJqhUwJiBO+al/BMu9k/27O+eZ5ZUfoxW/QZqSFG5wbxRsM5ler1mUrjxvLrN1G1V9qvnpwPxurTo+ImUjF7alIbiPXhyB5FG52OktAoY8O4UCeuB12n5h5LyyBQwmu+rbKc0kIbn8nSwUpm+T1bMJdA8nFQ7F7MtjNPzLWbgC8LSlTcHfaM4dnwcam2Ykj09JCqvfGgplpX/CE+T51CrXcuZWQ5PZkOr4ZsE9f2gYkqT1l/+i0T0TY1rqI7GLcZ75THOj64tgWPYW8mm6NMYwcCY7OR6kmEimGniw4ABEti8mtGkjLuh3WlW4k7PJur9xD++dYvGM8207tJ+8VkBziOElnioQClFxmdXQcGoRUr3PhoGF9Gm0VIcABbZo+pZGZfgsH+VhR6aQynvWh0osQXeEcPA1ID6t3n1nexxBCnJBUHxMU+SFcwT10728jpJ69htzqMvtdzTaD9EAvSQ51LEWaCTcJHmkj+gMgeBVgcEQcPR6ZwIIEhlMZOXAy3MCt6+xIAImsNcJsfKe6WyV9uJ++TyCbjK4e81JOmvGWBooDtIVQeMXKAr55T4sjbGIN/c0GZPtL8ivdzRL0XAOupk+SATFdrFnLzN7DFu7DCd46p3NvuaFtBJoPxs9ODtQX/Zq4DYH7EvdwR38AvKeWpPMjUer9ftL1ZMJo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enh6V2NSQ281Wlp3ZnFnWWtMaGJPLzUvblZiMjNVdGE0R2paWUVERDFJcnJx?=
 =?utf-8?B?bk03OTNsbkpiN1dSdUNoV0hXcW9PdEk2RFJ0SWdEeEE1N0NKNjJwWjUxZVJC?=
 =?utf-8?B?SjIvd3UrOERKV2I5bUhDTzFFeWt6MnJ2T1VqZm9FK203UzIwLzNBVzhyaU94?=
 =?utf-8?B?K3BwVzB4ZzVjWVVyL0hxLzVhbnp4bW1GcG56YURhWFJiVTExaG1HZmRreThK?=
 =?utf-8?B?Tkh2enlkcm8vT3JCOER3c0ZKQkRoYS9WaDM0bmpmNHBvR0VwcVQ3QVUyTjRH?=
 =?utf-8?B?ZCtjUmdCWXJSK3FxTHI5akcxaEZZcEJpS0duMEdDMWx0K1BqR2UwM0FKTS9s?=
 =?utf-8?B?cFp4TnBYdGZudUROYTAwNS8rYWoxU3dNbzVLVXA0dFhORXVZTkVsVWxRMXFs?=
 =?utf-8?B?Ynd4b3NDUk1NUmRhYjRWUWowRkpoalFZdnlGYmNLQlFvcnZPS2ZTZ2hKSjgx?=
 =?utf-8?B?R25LL3dyMGVYanpxMWhHN2ZPT3JydktrV3l4WHRVVmV1VTA1OUxndXdOR2Jk?=
 =?utf-8?B?cHZiS3A3b29OWTBPWWFXUU40SHJOK3ArQkR5c2Fkbyt4dGZvZERJWTRUa2lW?=
 =?utf-8?B?UlFtL21DZVFsRGZnT201L3pDdno1a2FxMG9sMWV4NEg0Y0N6aTVuaXRtMG5u?=
 =?utf-8?B?OFZWZW9adForYm9lblQ5NjFVY2dFSk9QMVdCK2xlczZheGg0VzY5U2toY1Y4?=
 =?utf-8?B?b3hDK29hTTlOVmttVVNVanhtcWZ0bFYxNjRGSDRBVVhuUlZEa3l4YWhnWGF4?=
 =?utf-8?B?d2JCczBtc0ZsT1Y3RmltUUx5V0pvWHpmUzBMSUZlYS9kanI0azdSMjQ0anFF?=
 =?utf-8?B?eVlTeFRvNEt4MnFnc3lPWjVTUFVuNG1JRVBhQ3hsNkRWWU1JQjFaV3FHMGk1?=
 =?utf-8?B?ZEg5UGNpSDRyTDlSdzBDV0VjdzZWRGVZWk5ucjR2T3lJazNMR0NaUml5MEVa?=
 =?utf-8?B?Q05JNFVmU0YreGx1RFljODhoNWVmckRZT2lWc3NVWmR1blU3eUU3N2NtUHpL?=
 =?utf-8?B?dTNya0U4VlFSeHEvZ0VWRm42L01LUFZPYjEwZDd1U1JJT1JheGxPZjY5TUI5?=
 =?utf-8?B?VzVNQXZBUmlRTHExNmdWRjFhVjRZZ2w5cUNhUHp6NlpsUE5zbGZXRXQwNmtG?=
 =?utf-8?B?SGJ2d3dxSU9tZ0RuR3NHZnlwcEFEZHh1RTA3K2RJSXl0azVCby9VSGJObDBO?=
 =?utf-8?B?S1NYVEpDMHRkS0ViK3l4UFErMHBZUkh6b0ZHOWtuazljTUN6S3Bjb0VwSmJT?=
 =?utf-8?B?YjBEWGdxVmlKbFFSS0pUTTdkYkR0M2FkZ2RmV3haN0Y1QVVzMSt0cExrb2hS?=
 =?utf-8?B?L0ZlVkdYQ1B3aHR5bXRpZ3gvc0xCU0ZJWitVcnA4ZEZXZGVEcGIybzFYMnhq?=
 =?utf-8?B?WCtuazA0dmd4OVNNZW9jWlZaUWwzQWJtb01qYTlkWlBTMGs4c3pwbW02L3ZJ?=
 =?utf-8?B?Y2t0TUtLOFhxSlpwaEEzYWpRUzBXUHVwR1NrSVV3MXUwN3FnbkZVQnRHbFJj?=
 =?utf-8?B?blRBMmY0Ukh5TjI3S3p1UFVMS0cvZTRhSUdrVzk1ZWlyTWNrZm5hc1dWRFl3?=
 =?utf-8?B?by83a2lMN1RpaWZYVkZ4SlZ1KzRjaTV2VEF0N1Nld29ERm8rR2RSRlhsWTEr?=
 =?utf-8?B?S0lPUk1IQUVvdFBMclk2QWwwOVlyOE45Y1V2bjZhS1FDVHlsdER4dm9lYmhl?=
 =?utf-8?B?K1NBOTI5UW1QeW9BN3YvQThJRnV0QUZZdGx4eGtyamQyTEtWM1FGYS9DTFEx?=
 =?utf-8?B?d2I3TFoyTFNYOFBHWDd0MVAxQ2dSRE9QSTRkemxOeHdnRnU4amNaS1llN0NE?=
 =?utf-8?B?UWZrcDFUVXNOc0R0U1pQSGdEelcvR3hHd0drcStNcFd0b0syS1JObTdUOFVl?=
 =?utf-8?B?RUNScjRaQm5PSDU1elBEMVdVZDgxaU5oUXlXcVFnaXdFVTRoNXprZFVNT25C?=
 =?utf-8?B?NlpyYlk5LzhoQ3BFamY0QktZY05JQXIvWjQ5azJsSG0xb3ZGa2ZBYjg0VkJL?=
 =?utf-8?B?dE5RczR2MUpYeUM3VGpNcHdkaDFNcFhUZjdkSW9RZnNXM0I3Y2hrRHRVM05s?=
 =?utf-8?B?V3BPKzJXR0NPTVNld3NOQWx3eVN2S1AvT09wQ0RReDdNb0ZMdWVsUTd2cUgr?=
 =?utf-8?Q?MQ2i5QiCnZSzjxsDG9ikQWSaj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB6744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a915ac5-9ad7-452a-3653-08dc4fb18bcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2024 05:31:55.2536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wVvrc4mK5jBVSLS6mrcErVDgrEXGlxc3PqoccRGM3ugIqQbH/nrLoZ6SE8BzEul2sSFE4cJmkYY1fOsJECEGzbO+SFPc8yOplXN+p0S+q8s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8331
X-OriginatorOrg: intel.com

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IExpdSwgWWkgTCA8eWkubC5s
aXVAaW50ZWwuY29tPg0KPlN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIgMC8yXSBUd28gZW5oYW5jZW1l
bnRzIHRvDQo+aW9tbXVfYXRbZGVddGFjaF9kZXZpY2VfcGFzaWQoKQ0KPg0KPk9uIDIwMjQvMy8y
OSAxMDoxMiwgRHVhbiwgWmhlbnpob25nIHdyb3RlOg0KPj4NCj4+DQo+Pj4gLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCj4+PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4N
Cj4+PiBTdWJqZWN0OiBbUEFUQ0ggdjIgMC8yXSBUd28gZW5oYW5jZW1lbnRzIHRvDQo+Pj4gaW9t
bXVfYXRbZGVddGFjaF9kZXZpY2VfcGFzaWQoKQ0KPj4+DQo+Pj4gVGhlcmUgYXJlIG1pbm9yIG1p
c3Rha2VzIGluIHRoZSBpb21tdSBzZXRfZGV2X3Bhc2lkKCkgYW5kDQo+Pj4gcmVtb3ZlX2Rldl9w
YXNpZCgpDQo+Pj4gcGF0aHMuIFRoZSBzZXRfZGV2X3Bhc2lkKCkgcGF0aCB1cGRhdGVzIHRoZSBn
cm91cC0+cGFzaWRfYXJyYXkgZmlyc3QsDQo+YW5kDQo+Pj4gdGhlbiBjYWxsIGludG8gcmVtb3Zl
X2Rldl9wYXNpZCgpIGluIGVycm9yIGhhbmRsaW5nIHdoZW4gdGhlcmUgYXJlDQo+ZGV2aWNlcw0K
Pj4+IHdpdGhpbiB0aGUgZ3JvdXAgdGhhdCBmYWlsZWQgdG8gc2V0X2Rldl9wYXNpZC4NCj4+DQo+
PiBOb3QgcmVsYXRlZCB0byB0aGlzIHBhdGNoLCBqdXN0IGN1cmlvdXMgaW4gd2hpY2ggY2FzZXMg
c29tZSBvZiB0aGUgZGV2aWNlcw0KPj4gSW4gc2FtZSBncm91cCBmYWlsZWQgdG8gc2V0X2Rldl9w
YXNpZCB3aGlsZSBvdGhlcnMgc3VjY2VlZD8NCj5UaGVyZSBhcmUgbXVsdGlwbGUgZmFpbHVyZSBy
ZWFzb25zLiBHaXZlbiB0byB0aGUgZmFjdCBvZiBzb21lIGRldmljZXMgaGF2ZQ0KPmFscmVhZHkg
c3VjY2VlZGVkLCB0aGUgbW9zdCB0eXBpY2FsIGVycm9yIG1heSBiZSBubyBtZW1vcnkuIE5vdCBz
dXJlDQo+YWJvdXQNCj5vdGhlciByZWFzb25zLg0KDQpPaCwgdGhlIG5vIG1lbW9yeSBjYXNlLCBj
bGVhciwgdGhhbmtzIFlpLg0KDQpCUnMuDQpaaGVuemhvbmcNCg0K

