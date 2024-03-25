Return-Path: <kvm+bounces-12628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C88088B42C
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 23:33:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8B0F1F3FEB2
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 22:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F16E27640A;
	Mon, 25 Mar 2024 22:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nLeaG+EP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D076841232;
	Mon, 25 Mar 2024 22:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711405916; cv=fail; b=LgKZCvvH70lmFIH0qOYIs88M80x+6huSjT5DoE+5oQA6yr58+jpYDiIuDQVJbIII7hKD7IDc2gQnRfudnLtFR+HNOm/nHYVre37oK29yvuaQJOt1GcPJfu4DANY3b4ZjmLScKbTUVTGllkL63skVwioHH7ndEduBG8m18rgnFdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711405916; c=relaxed/simple;
	bh=NNI7AjnukEHzXN0eZQ9kro+NcQ0Dr1X0yX2cFq/2le0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aQRtO8l62NElQcNNEzAdtBySSCurSc5/0Gt3ZQVb0gCCIDiGiaVWSpMYdwzWsCHllJBjHMkYJzZnRR3KIGJio8iyxqD2hJM97BRGpiUTWYQSUifG3cN+eDD8lMu7BTDN0mvEo7lLFhCu25ZBlBCY1jU+8ucTUt8Drh5OmuUMBM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nLeaG+EP; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711405914; x=1742941914;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NNI7AjnukEHzXN0eZQ9kro+NcQ0Dr1X0yX2cFq/2le0=;
  b=nLeaG+EP/XSnNeoJQrUgvBFvcVN9pYO8GqXCgj+aJ/IBoTfPqX4j/1MX
   4MV3QtEIfpUGu60pv9qWO5Lmb7bBCf/Oto3L8cDZsSXcNHAiUrUQ25Jy1
   qMx4rVLt+3u7p6mDdQurD1kUb9+qd/KOuGXqPnWSMligWUuY+lYtqbnJ4
   MVSq4IdS5szO1G+cR4mcxnE7NmmfYMP69dj1xGyl5L1KmYqiVSrhVi3XY
   4OTkBX+OaNdpnrPvKi17AkMxEB11A9vR8MlLxCharT7q8cn4yzGSJBXx3
   xTz0Z6I+CFhPqsf9AJc2bhAYA6FRtd3ZOmKoKGqx+cTuOCsrIkUvbFuVn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="9401206"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="9401206"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 15:31:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="20432895"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 15:31:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 15:31:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 15:31:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 15:31:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwVg95vZSoBRmL7SLa+UceIUuMWsWXpvrSHhpuwgGQh+1IBL8FgI7s+oqPKJ18f7pMN0zCf9WZ9oQqiGqFhYfl6+yex010zp5OyZH+lD5YQVqEifvaQyCsnQjCVCdF6PWmjUehygwIJRM83sxvmhIB3tiKHXVqvSkyRLZ6uVS3nEXuGTMYQg7g67C5/Ji38GwD2MVn04PeO+R/Qtv/rCiCJOFyXCfh+nREGtYLFhPUfvyrVNIh+EQND+54yDCJAyZAtCb3TL0RJgnvYWHqG9Mx/+vzVOM9yadU+ICw2tkqRonG4qsVFv1g/Us972Xv/6P0PQLTD1zKM+gou1WryOGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NNI7AjnukEHzXN0eZQ9kro+NcQ0Dr1X0yX2cFq/2le0=;
 b=oP2ui1PaemQ+An7kzvNlnfh9Hy+QG69yKD5JbeqdKAwKf2D/eOdEYGDb+KLqSGSTTns0z5HiI9gMFS4m8CDPLs5BI0j+jmkdHBi5CTPhrSr6p2DtpJ14F1xnqwY0ragkca7ENkyPp2vjORuSLVQz1EJrCyzFaaqJCPPOigL5tTQlFJ/nTi3zzx6JWKfELsQcVec5WmgmNZyoyiJMJWfBTwBXqOKpvaoKyMTrZNoFbRbiyaYPBkdgWc/OGOdeHQRPkGA++9Q1ADwg1/MJ8aqlcr5IaTdU/JNKh4lDGGnHKLVZm735fsJX8I7s2f0cPJj9AvuOTAw6Kdenl68mXEHiOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA0PR11MB4752.namprd11.prod.outlook.com (2603:10b6:806:99::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Mon, 25 Mar
 2024 22:31:49 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 22:31:49 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yuan, Hang" <hang.yuan@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 062/130] KVM: x86/tdp_mmu: Support TDX private mapping
 for TDP MMU
Thread-Topic: [PATCH v19 062/130] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Thread-Index: AQHadnqsibQeLxqb/U2XJgNL61wQ37FGCaEAgALn1ACAACoJgA==
Date: Mon, 25 Mar 2024 22:31:49 +0000
Message-ID: <ad203761cf0f93e9feb4ea7037c9b9c1f39714ae.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <fc97847d04f2b469d8f4cfceee84c7ef055ab1ac.1708933498.git.isaku.yamahata@intel.com>
	 <7b76900a42b4044cbbcb0c42922c935562993d1e.camel@intel.com>
	 <20240325200122.GH2357401@ls.amr.corp.intel.com>
In-Reply-To: <20240325200122.GH2357401@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA0PR11MB4752:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BXnn4HmeZ7JcApPslkoIyfvoVo1mSm4EBLyxI7Ue8gaSyDqA5qKBw3xAOekGctRPq7es90anWZbiOoSwEB/yc6TT3ZsD1PkVyybjmrs2Hdlt+3qA0osSD1WMi8+Qkek4dqfCc8ZO8Yeq0ldFTB55Mp62cAzEyXOJA+cxFR9I+XkiHwLs4OgG6yTTUIuss9CYVjfC7u1UYY3IXjyIoFZ9zNuOe7bxORm74B159pX3f05MX1u7ukTpmGBwyuCYZxfDuTiIG0HF5ox3n7b216/Jzlt1j8R3W+RZtcAymBsEOvPkWSRsmmJTmwDTurLoBT7K2iIMj6eU5wTWV1LgQc57K4i2IsbGi/NvWLXMB1URSaj7rjWXMqL9BtK6f6qQVBSWqseGgBmJh1+IwW7DvirHdgXhbFcE4W2JzDmsNmtvMHQB3US1WvMqBxHE0Rhngi7bqu58Upf6CJ2utUfnthWLO4f/LnHpFpbjlQfLCcFvY55C1Gw9oAkwAQplNME0zSGyXpqO5lPr7ImQNp+594927Ct+Rl4fEGB2KMFMvnrR7NXnB6mEo0LjKr/iXtyk9fZdSOna6BDdMNu6Y/1G6VBaFT9W+ctrk1F7mTUUOdedx/kjOmaSbC725PgwwKam5dejNv/Wx0h4ye+exZqXtULu48DlGyIgs96WC+/XBzUqQLQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0RJeG1hQTd2SmpEZmJwUEpvcEJaSmdZSVZwSU9IWkw3a28rQ256VGNIYW5x?=
 =?utf-8?B?NDM3bzVwYXhOc3BIcGpSenpjL280ZmJZT2JaNVgvT2ZYVmMwUUYrdThTSE1U?=
 =?utf-8?B?d3I0blU4SHMxK2doU3dMUjNPV1grcWFSUTZuRS8zakdVU05QdnJzK0VjRzJR?=
 =?utf-8?B?SDVPaU95eG1DbnoyQlVNUUUwbVVuZ1FoQ2ZDdTd2QXRpMlpYb2FrYW9Obzc1?=
 =?utf-8?B?SzRpUnU3QWVEc0RCU3hXQWI2NXJuS1RXbGxwQUJMYjdTRVVtNldPQm0yWjZO?=
 =?utf-8?B?dkp0djNyWTR3RllZTEZhWXlFN00xYVBjaUt0QlYwQkVSN1RqaUdDenU2cnJv?=
 =?utf-8?B?SUV5QjBpOFExejd2bmVscGtZOGRmQllXNHFHOE5HUm9wbUw4SzNTSXQ2WjRM?=
 =?utf-8?B?Nlp4NzZpVXBTODF3VmtqY1BoT21DNlpnTCtGZUE5KzJRQVJFRzMrdGN5bG5U?=
 =?utf-8?B?NDRTZFg3bEhmWkk3a2lCNlZaSFI5V2ozcTVDRFVuaW9KcWh3Z2xNRm80V1l3?=
 =?utf-8?B?bERuc1lMSHQxTTl6RzRZdzUrRWFqYmw5Uzc3eG1WU3gyVjd1eWp1YUZSTUdV?=
 =?utf-8?B?aHdUcFV1YldoVno0cUhWRW9tM3FvN1F1clZmekhiSVVFbGp3QnphdU5mNjdG?=
 =?utf-8?B?V1duMVVkOEJnZWViYi9qUlZ6TXo2Qi9MZkttZjcyd3VZVnU0QnVkNEh4bUNk?=
 =?utf-8?B?VmNHODQ0QmFBZmI5S0VkZWRDeVAyczBrZWNhc3hCSWhaWmNFN3lVdUN4Vnky?=
 =?utf-8?B?NTU5RlFha2VCMVExVGdFK3hFVU4ySXV5anFVemkzZGczMXp3anJEaFI0cjhP?=
 =?utf-8?B?bGtyb0UxeXB1OE42eUNjU0hhYnZxWHBnR2pneDlmWGZVcXhySEVsU0Vvekll?=
 =?utf-8?B?YWFQcjk3N1p1YmMyektVbGo0bjB1SHBVa1RQVUFFc1B6TzVYMDR0Z0xJdmVs?=
 =?utf-8?B?WktHZzBmZWZybk1JcllxeUU0YnExZE1wWTljQmowWGprQjZrZTdleEtaUmhT?=
 =?utf-8?B?L0QxcWRSVVFyVFJaYWovVWppWTVKOGNjNTUxOVZvRHVybG5jQ245d1RKbWQ3?=
 =?utf-8?B?TDQrZWFVQnZPSjVqamRjc0J5L1d2cW1UdkVUV1piMXl1YmRrc25ETW5taG94?=
 =?utf-8?B?ZDlwcHNFeWtFTGxhS3JWUkloTFhtRmpTMkVCZnJPQjVLYUtYbnNjSWVDVFhx?=
 =?utf-8?B?bnpCUG5qMmIveEoxUndBVTZuZWQweGtTZG5mUnQwellJVDBCZ2pWd0sydERJ?=
 =?utf-8?B?SXhmUzBrZjlqK0hpdHY3Ri9tZVFZRDg2VTlrRnc0cHRxS053cUlkdmpDdHh2?=
 =?utf-8?B?M1M5aDRNb2x5dkZNTzMvamk2UDZzb0xTdm1kRkEwekxqN3k5c3lkZXZUOFB3?=
 =?utf-8?B?eFFUSmltTitnTEg4RHhid3pxdHVOeHk4ek53elo0c0xQSTd6VjQrVjNIRm5u?=
 =?utf-8?B?OFgrb2pzamhYeUdRa0kzRVVBalNLd29iTWdMejE3Vy8yaUk2NWhXWEJCTXpr?=
 =?utf-8?B?NVE4TW1Mc1l4eXg1QjFEY2NzekQzUWZKQWM0QWdkcXJCcUFid2dnRTBXTEdW?=
 =?utf-8?B?ZVhyeTAybklVWkV5dy9FY3hPeUVING9LU3FldVZOYlF4bVJTYjZiSVdwd2xn?=
 =?utf-8?B?T1lBMDhVSXBudVlZTEp3QXd2YVYweHR6T0JGMXZ4YjVCeFJVdysvNk84N1hx?=
 =?utf-8?B?NE05OUFiY1VmRWtkUmRlTkpmREE2Vkw4ak5hTE56RWFQcHFUbDVHNnh4WlEx?=
 =?utf-8?B?dmhiZ0JVeHVCYnBRdEhrOVpuRm8vaUM4RzAwNkJsVnZLeUFLc2lYc3NsUUtD?=
 =?utf-8?B?Q0NvV2JGTjdrVERNOTE3N3AvQkZKMFMvZVVzOUw0YTNLLzMyUUVJaytlSllG?=
 =?utf-8?B?aG1GbzJRbUZqRjlCNVR1UzE1UnViODJ0SGhFb2ZyVUVKZmxFZGdmK3djWjV0?=
 =?utf-8?B?REI2RnprWXZQSzN2S3lpREpUUmlrc0hsRHFuSUc3MmtRY2dYQUQ1UHNQaWhj?=
 =?utf-8?B?V0hZRGxvU0R5M0JpYUo0NXY5RWRHV2EzeWNWVVB0U3dQNHAyQTFKQVNzL0Fs?=
 =?utf-8?B?NVBraE40WnpwM0lyODJPR0h6SDlSaTVaV2hFckFuc2FoQ0RFdzlic3hnM2hB?=
 =?utf-8?B?STdtcHVIWWFZZWJUTDRTVSt5cTgzYS9lMk83b0psMERIYVJidEs3UmhtYnpN?=
 =?utf-8?Q?FlmENZwL1DPe38tScGYSKr0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <16A72C90094D0C40941D72CFAEC6217E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a71e2ed-5379-4744-8ce3-08dc4d1b5ce2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 22:31:49.7191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dQDMfaVgpOonlW9fsqvfvbjJPAen2JaXWHN6Lp0lr4zqeCKx4fL5VpmfA8mtPlixtTQDR6B7BL/Tw/iE1HVe9S4CiUNqdtgCTARytExNXtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4752
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAzLTI1IGF0IDEzOjAxIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gwqBBbHNvLCBrdm1fdGRwX21tdV9hbGxvY19yb290KCkgbmV2ZXIgcmV0dXJucyBub24temVy
bywgZXZlbiB0aG91Z2ggbW11X2FsbG9jX2RpcmVjdF9yb290cygpIGRvZXMuDQo+ID4gUHJvYmFi
bHkgdG9kYXkgd2hlbiB0aGVyZSBpcyBvbmUgY2FsbGVyIGl0IG1ha2VzIG1tdV9hbGxvY19kaXJl
Y3Rfcm9vdHMoKSBjbGVhbmVyIHRvIGp1c3QgaGF2ZQ0KPiA+IGl0DQo+ID4gcmV0dXJuIHRoZSBh
bHdheXMgemVybyB2YWx1ZSBmcm9tIGt2bV90ZHBfbW11X2FsbG9jX3Jvb3QoKS4gTm93IHRoYXQg
dGhlcmUgYXJlIHR3byBjYWxscywgSQ0KPiA+IHRoaW5rIHdlDQo+ID4gc2hvdWxkIHJlZmFjdG9y
IGt2bV90ZHBfbW11X2FsbG9jX3Jvb3QoKSB0byByZXR1cm4gdm9pZCwgYW5kIGhhdmUga3ZtX3Rk
cF9tbXVfYWxsb2Nfcm9vdCgpDQo+ID4gcmV0dXJuIDANCj4gPiBtYW51YWxseSBpbiB0aGlzIGNh
c2UuDQo+ID4gDQo+ID4gT3IgbWF5YmUgaW5zdGVhZCBjaGFuZ2UgaXQgYmFjayB0byByZXR1cm5p
bmcgYW4gaHBhX3QgYW5kIHRoZW4ga3ZtX3RkcF9tbXVfYWxsb2Nfcm9vdCgpIGNhbiBsb3NlDQo+
ID4gdGhlDQo+ID4gImlmIChwcml2YXRlKSIgbG9naWMgYXQgdGhlIGVuZCB0b28uDQo+IA0KPiBQ
cm9iYWJseSB3ZSBjYW4gbWFrZSB2b2lkIGt2bV90ZHBfbW11X2FsbG9jX3Jvb3QoKSBpbnN0ZWFk
IG9mIHJldHVybmluZyBhbHdheXMNCj4gemVybyBhcyBjbGVhbiB1cC4NCg0KV2h5IGlzIGl0IGJl
dHRlciB0aGFuIHJldHVybmluZyBhbiBocGFfdCBvbmNlIHdlIGFyZSBjYWxsaW5nIGl0IHR3aWNl
IGZvciBtaXJyb3IgYW5kIHNoYXJlZCByb290cy4NCg0KPiANCj4gDQo+ID4gPiDCoMKgwqDCoMKg
wqDCoMKgfSBlbHNlIGlmIChzaGFkb3dfcm9vdF9sZXZlbCA+PSBQVDY0X1JPT1RfNExFVkVMKSB7
DQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJvb3QgPSBtbXVfYWxsb2Nf
cm9vdCh2Y3B1LCAwLCAwLCBzaGFkb3dfcm9vdF9sZXZlbCk7DQo+ID4gPiBAQCAtNDYyNyw3ICs0
NjMyLDcgQEAgaW50IGt2bV90ZHBfcGFnZV9mYXVsdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0
cnVjdCBrdm1fcGFnZV9mYXVsdA0KPiA+ID4gKmZhdWx0KQ0KPiA+ID4gwqDCoMKgwqDCoMKgwqDC
oGlmIChrdm1fbW11X2hvbm9yc19ndWVzdF9tdHJycyh2Y3B1LT5rdm0pKSB7DQo+ID4gPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZvciAoIDsgZmF1bHQtPm1heF9sZXZlbCA+IFBH
X0xFVkVMXzRLOyAtLWZhdWx0LT5tYXhfbGV2ZWwpIHsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGludCBwYWdlX251bSA9IEtWTV9QQUdFU19Q
RVJfSFBBR0UoZmF1bHQtPm1heF9sZXZlbCk7DQo+ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdmbl90IGJhc2UgPSBnZm5fcm91bmRfZm9yX2xldmVs
KGZhdWx0LT5nZm4sDQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoGdmbl90IGJhc2UgPSBnZm5fcm91bmRfZm9yX2xldmVsKGdwYV90b19nZm4oZmF1
bHQtPmFkZHIpLA0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBmYXVsdC0+bWF4X2xldmVsKTsNCj4gPiA+IMKgDQo+ID4gPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoa3ZtX210cnJf
Y2hlY2tfZ2ZuX3JhbmdlX2NvbnNpc3RlbmN5KHZjcHUsIGJhc2UsIHBhZ2VfbnVtKSkNCj4gPiA+
IEBAIC00NjYyLDYgKzQ2NjcsNyBAQCBpbnQga3ZtX21tdV9tYXBfdGRwX3BhZ2Uoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCBncGFfdCBncGEsIHU2NA0KPiA+ID4gZXJyb3JfY29kZSwNCj4gPiA+IMKg
wqDCoMKgwqDCoMKgwqB9Ow0KPiA+ID4gwqANCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqBXQVJOX09O
X09OQ0UoIXZjcHUtPmFyY2gubW11LT5yb290X3JvbGUuZGlyZWN0KTsNCj4gPiA+ICvCoMKgwqDC
oMKgwqDCoGZhdWx0LmdmbiA9IGdwYV90b19nZm4oZmF1bHQuYWRkcikgJiB+a3ZtX2dmbl9zaGFy
ZWRfbWFzayh2Y3B1LT5rdm0pOw0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoGZhdWx0LnNsb3QgPSBr
dm1fdmNwdV9nZm5fdG9fbWVtc2xvdCh2Y3B1LCBmYXVsdC5nZm4pOw0KPiA+ID4gwqANCj4gPiA+
IMKgwqDCoMKgwqDCoMKgwqByID0gbW11X3RvcHVwX21lbW9yeV9jYWNoZXModmNwdSwgZmFsc2Up
Ow0KPiA+ID4gQEAgLTYxNjYsNiArNjE3Miw3IEBAIHN0YXRpYyBpbnQgX19rdm1fbW11X2NyZWF0
ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fbW11ICptbXUpDQo+ID4gPiDCoA0K
PiA+ID4gwqDCoMKgwqDCoMKgwqDCoG1tdS0+cm9vdC5ocGEgPSBJTlZBTElEX1BBR0U7DQo+ID4g
PiDCoMKgwqDCoMKgwqDCoMKgbW11LT5yb290LnBnZCA9IDA7DQo+ID4gPiArwqDCoMKgwqDCoMKg
wqBtbXUtPnByaXZhdGVfcm9vdF9ocGEgPSBJTlZBTElEX1BBR0U7DQo+ID4gPiDCoMKgwqDCoMKg
wqDCoMKgZm9yIChpID0gMDsgaSA8IEtWTV9NTVVfTlVNX1BSRVZfUk9PVFM7IGkrKykNCj4gPiA+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbW11LT5wcmV2X3Jvb3RzW2ldID0gS1ZN
X01NVV9ST09UX0lORk9fSU5WQUxJRDsNCj4gPiA+IMKgDQo+ID4gPiBAQCAtNzIxMSw2ICs3MjE4
LDEyIEBAIGludCBrdm1fbW11X3ZlbmRvcl9tb2R1bGVfaW5pdCh2b2lkKQ0KPiA+ID4gwqB2b2lk
IGt2bV9tbXVfZGVzdHJveShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gPiDCoHsNCj4gPiA+
IMKgwqDCoMKgwqDCoMKgwqBrdm1fbW11X3VubG9hZCh2Y3B1KTsNCj4gPiA+ICvCoMKgwqDCoMKg
wqDCoGlmICh0ZHBfbW11X2VuYWJsZWQpIHsNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqB3cml0ZV9sb2NrKCZ2Y3B1LT5rdm0tPm1tdV9sb2NrKTsNCj4gPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBtbXVfZnJlZV9yb290X3BhZ2UodmNwdS0+a3ZtLCAmdmNw
dS0+YXJjaC5tbXUtPnByaXZhdGVfcm9vdF9ocGEsDQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBOVUxMKTsNCj4gPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB3cml0ZV91bmxvY2soJnZjcHUtPmt2bS0+
bW11X2xvY2spOw0KPiA+IA0KPiA+IFdoYXQgaXMgdGhlIHJlYXNvbiBmb3IgdGhlIHNwZWNpYWwg
dHJlYXRtZW50IG9mIHByaXZhdGVfcm9vdF9ocGEgaGVyZT8gVGhlIHJlc3Qgb2YgdGhlIHJvb3Rz
IGFyZQ0KPiA+IGZyZWVkIGluIGt2bV9tbXVfdW5sb2FkKCkuIEkgdGhpbmsgaXQgaXMgYmVjYXVz
ZSB3ZSBkb24ndCB3YW50IHRoZSBtaXJyb3IgdG8gZ2V0IGZyZWVkIGR1cmluZw0KPiA+IGt2bV9t
bXVfcmVzZXRfY29udGV4dCgpPw0KPiANCj4gSXQgcmVmbGVjdHMgdGhhdCB3ZSBkb24ndCBmcmVl
IFNlY3VyZS1FUFQgcGFnZXMgZHVyaW5nIHJ1bnRpbWUsIGFuZCBmcmVlIHRoZW0NCj4gd2hlbiBk
ZXN0cm95aW5nIHRoZSBndWVzdC4NCg0KUmlnaHQuIElmIHdvdWxkIGJlIGdyZWF0IGlmIHdlIGNv
dWxkIGRvIHNvbWV0aGluZyBsaWtlIHdhcm4gb24gZnJlZWluZyByb2xlLnByaXZhdGUgPSAxIHNw
J3MgZHVyaW5nDQpydW50aW1lLiBJdCBjb3VsZCBjb3ZlciBzZXZlcmFsIGNhc2VzIHRoYXQgZ2V0
IHdvcnJpZWQgYWJvdXQgaW4gb3RoZXIgcGF0Y2hlcy4NCg0KV2hpbGUgbG9va2luZyBhdCBob3cg
d2UgY291bGQgZG8gdGhpcywgSSBub3RpY2VkIHRoYXQga3ZtX2FyY2hfdmNwdV9jcmVhdGUoKSBj
YWxscyBrdm1fbW11X2Rlc3Ryb3koKQ0KaW4gYW4gZXJyb3IgcGF0aC4gU28gdGhpcyBjb3VsZCBl
bmQgdXAgemFwcGluZy9mcmVlaW5nIGEgcHJpdmF0ZSByb290LiBJdCBzaG91bGQgYmUgYmFkIHVz
ZXJzcGFjZQ0KYmVoYXZpb3IgdG9vIEkgZ3Vlc3MuIEJ1dCB0aGUgbnVtYmVyIG9mIGVkZ2UgY2Fz
ZXMgbWFrZXMgbWUgdGhpbmsgdGhlIGNhc2Ugb2YgemFwcGluZyBwcml2YXRlIHNwDQp3aGlsZSBh
IGd1ZXN0IGlzIHJ1bm5pbmcgaXMgc29tZXRoaW5nIHRoYXQgZGVzZXJ2ZXMgYSBWTV9CVUdfT04o
KS4NCg0KPiANCj4gDQo+ID4gDQo+ID4gT29mLiBGb3IgdGhlIHNha2Ugb2YgdHJ5aW5nIHRvIGp1
c3RpZnkgdGhlIGNvZGUsIEknbSB0cnlpbmcgdG8ga2VlcCB0cmFjayBvZiB0aGUgcHJvcyBhbmQg
Y29ucw0KPiA+IG9mDQo+ID4gdHJlYXRpbmcgdGhlIG1pcnJvci9wcml2YXRlIHJvb3QgbGlrZSBh
IG5vcm1hbCBvbmUgd2l0aCBqdXN0IGEgZGlmZmVyZW50IHJvbGUgYml0Lg0KPiA+IA0KPiA+IFRo
ZSB3aG9sZSDigJxsaXN0IG9mIHJvb3Rz4oCdIHRoaW5nIHNlZW1zIHRvIGRhdGUgZnJvbSB0aGUg
c2hhZG93IHBhZ2luZywgd2hlcmUgdGhlcmUgaXMgaXMgY3JpdGljYWwNCj4gPiB0bw0KPiA+IGtl
ZXAgbXVsdGlwbGUgY2FjaGVkIHNoYXJlZCByb290cyBvZiBkaWZmZXJlbnQgQ1BVIG1vZGVzIG9m
IHRoZSBzYW1lIHNoYWRvd2VkIHBhZ2UgdGFibGVzLiBUb2RheQ0KPiA+IHdpdGggbm9uLW5lc3Rl
ZCBURFAsIEFGQUlDVCwgdGhlIG9ubHkgZGlmZmVyZW50IHJvb3QgaXMgZm9yIFNNTS4gSSBndWVz
cyBzaW5jZSB0aGUgbWFjaGluZXJ5IGZvcg0KPiA+IG1hbmFnaW5nIG11bHRpcGxlIHJvb3RzIGlu
IGEgbGlzdCBhbHJlYWR5IGV4aXN0cyBpdCBtYWtlcyBzZW5zZSB0byB1c2UgaXQgZm9yIGJvdGgu
DQo+ID4gDQo+ID4gRm9yIFREWCB0aGVyZSBhcmUgYWxzbyBvbmx5IHR3bywgYnV0IHRoZSBkaWZm
ZXJlbmNlIGlzLCB0aGluZ3MgbmVlZCB0byBiZSBkb25lIGluIHNwZWNpYWwgd2F5cw0KPiA+IGZv
cg0KPiA+IHRoZSB0d28gcm9vdHMuIFlvdSBlbmQgdXAgd2l0aCBhIGJ1bmNoIG9mIGxvb3BzIChm
b3JfZWFjaF8qdGRwX21tdV9yb290KCksIGV0YykgdGhhdCBlc3NlbnRpYWxseQ0KPiA+IHByb2Nl
c3MgYSBsaXN0IG9mIHR3byBkaWZmZXJlbnQgcm9vdHMsIGJ1dCB3aXRoIGlubmVyIGxvZ2ljIHRv
cnR1cmVkIHRvIHdvcmsgZm9yIHRoZQ0KPiA+IHBlY3VsaWFyaXRpZXMNCj4gPiBvZiBib3RoIHBy
aXZhdGUgYW5kIHNoYXJlZC4gQW4gZWFzaWVyIHRvIHJlYWQgYWx0ZXJuYXRpdmUgY291bGQgYmUg
dG8gb3BlbiBjb2RlIGJvdGggY2FzZXMuDQo+ID4gDQo+ID4gSSBndWVzcyB0aGUgbWFqb3IgYmVu
ZWZpdCBpcyB0byBrZWVwIG9uZSBzZXQgb2YgbG9naWMgZm9yIHNoYWRvdyBwYWdpbmcsIG5vcm1h
bCBURFAgYW5kIFREWCwgYnV0DQo+ID4gaXQNCj4gPiBtYWtlcyB0aGUgbG9naWMgYSBiaXQgZGlm
ZmljdWx0IHRvIGZvbGxvdyBmb3IgVERYIGNvbXBhcmVkIHRvIGxvb2tpbmcgYXQgaXQgZnJvbSB0
aGUgbm9ybWFsDQo+ID4gZ3Vlc3QNCj4gPiBwZXJzcGVjdGl2ZS4gU28gSSB3b25kZXIgaWYgbWFr
aW5nIHNwZWNpYWwgdmVyc2lvbnMgb2YgdGhlIFREWCByb290IHRyYXZlcnNpbmcgb3BlcmF0aW9u
cyBtaWdodA0KPiA+IG1ha2UNCj4gPiB0aGUgY29kZSBhIGxpdHRsZSBlYXNpZXIgdG8gZm9sbG93
LiBJ4oCZbSBub3QgYWR2b2NhdGluZyBmb3IgaXQgYXQgdGhpcyBwb2ludCwganVzdCBzdGlsbCB3
b3JraW5nDQo+ID4gb24NCj4gPiBhbiBvcGluaW9uLiBJcyB0aGVyZSBhbnkgaGlzdG9yeSBhcm91
bmQgdGhpcyBkZXNpZ24gcG9pbnQ/DQo+IA0KPiBUaGUgb3JpZ2luYWwgZGVzaXJlIHRvIGtlZXAg
dGhlIG1vZGlmaWNhdGlvbiBjb250YWluZWQsIGFuZCBub3QgaW50cm9kdWNlIGENCj4gZnVuY3Rp
b24gZm9yIHBvcHVsYXRpb24gYW5kIHphcC7CoCBXaXRoIHRoZSBvcGVuIGNvZGluZywgZG8geW91
IHdhbnQgc29tZXRoaW5nDQo+IGxpa2UgdGhlIGZvbGxvd2luZ3M/wqAgV2UgY2FuIHRyeSBpdCBh
bmQgY29tcGFyZSB0aGUgb3V0Y29tZS4NCj4gDQo+IEZvciB6YXBwaW5nDQo+IMKgIGlmIChwcml2
YXRlKSB7DQo+IMKgwqDCoMKgIF9fZm9yX2VhY2hfdGRwX21tdV9yb290X3lpZWxkX3NhZmVfcHJp
dmF0ZSgpDQo+IMKgwqDCoMKgwqDCoCBwcml2YXRlIGNhc2UNCj4gwqAgfSBlbHNlIHsNCj4gwqDC
oMKgwqAgX19mb3JfZWFjaF90ZHBfbW11X3Jvb3RfeWllbGRfc2FmZSgpDQo+IMKgwqDCoMKgwqDC
oMKgIHNoYXJlZCBjYXNlDQo+IMKgIH0NCj4gDQo+IEZvciBmYXVsdCwNCj4ga3ZtX3RkcF9tbXVf
bWFwKCkNCj4gwqAgaWYgKHByaXZhdGUpIHsNCj4gwqDCoMKgIHRkcF9tbXVfZm9yX2VhY2hfcHRl
X3ByaXZhdGUoaXRlciwgbW11LCByYXdfZ2ZuLCByYXdfZ2ZuICsgMSkNCj4gwqDCoMKgwqDCoCBw
cml2YXRlIGNhc2UNCj4gwqAgfSBlbHNlIHsNCj4gwqDCoMKgIHRkcF9tbXVfZm9yX2VhY2hfcHRl
X3ByaXZhdGUoaXRlciwgbW11LCByYXdfZ2ZuLCByYXdfZ2ZuICsgMSkNCj4gwqDCoMKgwqDCoCBz
aGFyZWQgY2FzZQ0KPiDCoCB9DQoNCkkgd2FzIHdvbmRlcmluZyBhYm91dCBzb21ldGhpbmcgbGlt
aXRlZCB0byB0aGUgb3BlcmF0aW9ucyB0aGF0IGl0ZXJhdGUgb3ZlciB0aGUgcm9vdHMuIFNvIG5v
dA0Ka2VlcGluZyBwcml2YXRlX3Jvb3RfaHBhIGluIHRoZSBsaXN0IG9mIHJvb3RzIHdoZXJlIGl0
IGhhcyB0byBiZSBjYXJlZnVsbHkgcHJvdGVjdGVkIGZyb20gZ2V0dGluZw0KemFwcGVkIG9yIGdl
dCBpdHMgZ2ZuIGFkanVzdGVkLCBhbmQgaW5zdGVhZCBvcGVuIGNvZGluZyB0aGUgcHJpdmF0ZSBj
YXNlIGluIHRoZSBoaWdoZXIgbGV2ZWwgemFwcGluZw0Kb3BlcmF0aW9ucy4gRm9yIG5vcm1hbCBW
TSdzIHRoZSBwcml2YXRlIGNhc2Ugd291bGQgYmUgYSBOT1AuDQoNClNpbmNlIGt2bV90ZHBfbW11
X21hcCgpIGFscmVhZHkgZ3JhYnMgcHJpdmF0ZV9yb290X2hwYSBtYW51YWxseSwgaXQgd291bGRu
J3QgY2hhbmdlIGluIHRoaXMgaWRlYS4gSQ0KZG9uJ3Qga25vdyBob3cgbXVjaCBiZXR0ZXIgaXQg
d291bGQgYmUgdGhvdWdoLiBJIHRoaW5rIHlvdSBhcmUgcmlnaHQgd2Ugd291bGQgaGF2ZSB0byBj
cmVhdGUgdGhlbQ0KYW5kIGNvbXBhcmUuIA0K

