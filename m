Return-Path: <kvm+bounces-11927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C2DE87D313
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 18:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3E4928537F
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 17:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E404E4CB38;
	Fri, 15 Mar 2024 17:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ONwe+nWA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68504487AE;
	Fri, 15 Mar 2024 17:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710525072; cv=fail; b=g1ZE15OlPR8b9DSYkbh6O9QDKpUQ+LPn3syXfcxvKfWLAmVktKfjW5bfYnm3E5x1Khu2A1JQ91gqfND37mJA0XXXWhLmA+yQIMsATnteYWhdFlMuGdfrsGbL/4YUo+BNNWXNfIS6nQdOLmSsedB6MxPU+i+3j/WOviJPEc43xEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710525072; c=relaxed/simple;
	bh=9iVDpm4NwcLNJBDIFmPqKNvPXp7HgDe0sduHo0G7o0w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B8qkUHmmO66H0wOXNa0cxz0UqHJd883OaHB8tktX2t0zZWMMnLJ2xpxQI4dD0bNjplMeuU7PiKT7W/JOcFHAPjxJlaGIe3TwCN79clGiGqPfzXAviDUJ5hAyhuSA5W5k/mIdaj/CxTdzPdjXWMLnXOATLv8jegGrlivWFanAxRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ONwe+nWA; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710525070; x=1742061070;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9iVDpm4NwcLNJBDIFmPqKNvPXp7HgDe0sduHo0G7o0w=;
  b=ONwe+nWABvQJ4+A8N7mPzJJBhPytYxR2IKmi5DVy5bSKKD4q4aJTu4SM
   SSzHS2ZLxKrFJhtF9T8XhJOTeC2qmEiSbVlfVb7IIOWbzttXa5C8Jr6dI
   jDAkDaUWYYDLKy8wclfXpcr6m6p8e3KDkmhNUoU5AF2CFSwMY5ZZW3ZY3
   6vfTMcYlkAtVnKx83PEozOrLQ79VcCU5R5yEVAtTjNCm/zacQnuQ9WU1g
   ty4Wo1GNPVjz/hmUkUuEPR9rt2DQNzHQkA5cB/rqDBftObPgZRGCuBCwR
   6i9+X3/yMDtGA+FqsmcI19EWmGpc8xz8r0HGdo24ObIQ7sODIGrZI7Kj0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="9186998"
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="9186998"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 10:51:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="43797878"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Mar 2024 10:51:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 15 Mar 2024 10:51:08 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 15 Mar 2024 10:51:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 15 Mar 2024 10:51:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 15 Mar 2024 10:51:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQCSO1FP6iPtj7Vafu1MDeX5UgN24TxZJvR8zP4ipCabMU5FjIqSgrkKF8e2Acei3RLKu9r64R9xOQaSoD9wN9NrXJzljT9rcNAotCyrPuHF1POQ1hsYEWkeBbHdPDBDvYDEeVqB7pvW9fg2ZBPWZUOV/O3clhy7c7LAGSo20gJLDcG1D5GmZ2LL3oGFR92Lw0Oq1xlB2S3ExQxBlIDO1OQiIwbtJJ9RPW7enA+NRgqy+Ghc8TJ8dRcy65PCQbg4d6ICQmANAGmbefJcLbhWhPgxYG6goKu+tFaw2e1uh3xFY/5uCKZFNsUuTm1vdP0+ZO0OBNcn91AXXDg0sb/pbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9iVDpm4NwcLNJBDIFmPqKNvPXp7HgDe0sduHo0G7o0w=;
 b=oM9TNzav1YDXP5z8bG4eW12g28GW1U9F69S7YdS0C0B9kQqt/ZAVSxnEZJf9gvQJ/0G6rx3li/y3pnUmVE5ShaVyJsS4fxHF9KjQq/EBG2eF44m/o4gMfmmHFmHbjA9Y0Qf9dkoysIw1ap3Opriavk4ycnYzs69Da2iYbdTe/F7Daj+vte/CAH18Ou8FZGeLCAbFigyxg81xcISBNMpHKZhbIkxq4XoHSTWxNI685I52p40wGMAVCFHRL8jCGi2Tn2oPC9hNo37HgeUY3YBgQhMeubrfIiNLiYuyH21lJ4z8jK9PMeGggTPyGPFO7WzDRsGmzEKvDoQ2oGVFbKwRAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB7606.namprd11.prod.outlook.com (2603:10b6:510:271::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.20; Fri, 15 Mar
 2024 17:51:01 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.008; Fri, 15 Mar 2024
 17:51:01 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Chen,
 Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Topic: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Index: AQHadnZ/Qf0yAsUauU2/h9YYap6ribE4BK4AgAD7XwCAABSUgIAAASAA
Date: Fri, 15 Mar 2024 17:51:01 +0000
Message-ID: <07b75e0f18a5082a91f80fb234d29c97489e2f75.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
	 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
	 <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
	 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
	 <ZfR4UHsW_Y1xWFF-@google.com> <ZfSJkwnC4LRCqQS9@google.com>
In-Reply-To: <ZfSJkwnC4LRCqQS9@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB7606:EE_
x-ms-office365-filtering-correlation-id: 947435c4-d3c9-4339-d601-08dc45187a45
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NSA9Yifd7SxKpkmO0Qkm8yG2DIJ9sFI1slZ+WousnH+IdHCT/QsBCL5dKw9IgXZ+wrOP+BcX3I28AXR5JdHeombHkc9HHv3+wl1j44eic/fs8bcPnDuy5J9i6X1nhZItegwpo3wsZcNCNpJ5342cNZcjEgalmtago5I4XNcFcnr03nCFeFDlF01Ds4di9JOiYD6JhaqcfBeGYG+RQdhOdPqbNsgSFmQWVvErRSSk6kn2rBEM4+VlnUS6lhMC3WsJXn/fT87WzS1qey6Fion1IaYwJ4KZtQF/lL1BFSq9OGXoqqbyzA+kKuVC1Px+Wkj8OS8hF9qg98nNmS1duUu+34zgnC7YfOVvq/FcrU70O4PXuHUI0r3PdGRnWLMMq4tLv/AcZgMCh3sKdli3sDkkLv/o7TpwjziGDySnzveQpag/HWA/Fn+81kixljMj++vlrtdwCYIm4ixy1FUD2zpbTmNuBVgUsIMPXjXvX1D0fVD6L+6GzlCfjK3LC1uz166JNpjHrhd1kKFhiciclPRiX129HK8JtmTavatgn2fRTvd+YEVmnaN3sySihApxqtX5F3y44FBwV/RsK7KNC+IXN5qLryj7ar6woLUbSix52GjZ8CKY0fH0bIQYAN1x6khXuPjHoSZdiUmGzh/FJ3h2FPFiSmDrmF74VzXy0uDcQi8jIr1hpL+PrCiNcN8W1Ly15dNixs9uxg4pRXNNRnoiC8huaxlX6ux0mmdbsR0RDbM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zi9XQ245TlFacTB6YVdJWTJlb01RamdabjI5SDhFTHVPZGtuV3pVWWordktU?=
 =?utf-8?B?TUQwWTZ5L1EyZHBYUythMHNLOTlKTWFmMXNHemRaYlJMd1lRai9CU0gwNGJQ?=
 =?utf-8?B?UDF2TnpOazRRTmMwUUpRTEl6MG9aQ2NWT1krek5JK05jWmUxQWU5ZHBua2U0?=
 =?utf-8?B?NFg2RHcxZzduM1FaU2FTRFFYVEY1bDdFOURkUTQ2anNHN3o2UVMxK2d2OVhk?=
 =?utf-8?B?MDBLT2Nhb0psWCtwNEVnT3U0akkwdVppbWhJUUF3MWpGaG9GM3czMkJpZEdz?=
 =?utf-8?B?eUVlYlVzTmI5S3RDMTJuTkVBNGJDYjIxVVBaYmFlWFlFS0tsaWdpaUlGODV0?=
 =?utf-8?B?bUZkVEI5d0I0UlNRUjNHekhXMkN2LzRMdXhUNzBvSWUwOEs4QjZlVkZUTWpT?=
 =?utf-8?B?VTcyZHUrc3VuTTUvOXZhU3BjQnFMWWhqUDBRdU5lSEE4eno2bXpveUlJTDl0?=
 =?utf-8?B?aTFWTitrbFBuL2hxbjA4MThGZFJ5SnRzaTZYZ2E4Z0JzMnVTMld3T2ZnMzhC?=
 =?utf-8?B?R2l0Uy9mT2c4dUVMamV0bEc0UTJFZ1RPRGpSN0g2cjBoUmJZYnk4M2VKU21w?=
 =?utf-8?B?elREbWNzSjcyN1FWNmYyU3JhTFo2YlBxUitrZmxmTnlmUnRSSzljSE5NSlAr?=
 =?utf-8?B?ZlpsNm9EUnY3M1VqU0YvQnA5TGFSWkNmV3N3eHRCRk5aUjJKV2RidHg1bTU2?=
 =?utf-8?B?b1JKeVNvUmNvSzhqNUMyT1ljZnp1dm9jQkpWejFDV2t4RUZMU29SVkFZT0Zx?=
 =?utf-8?B?cEl4anNNUTQ5Z2FvMCsxQzNoRHQ3cmhEbjN4ZmZMOGxCbTVCRUk4cWlaMEVN?=
 =?utf-8?B?Qzd4WGpUZUIrQnRQUEhWdkQ2bXg4bU9WSVlMMGRJRWR0OG1hQzAxcWlpSGVY?=
 =?utf-8?B?a3hSS3loQS9kaUkxYVpVMmc4QzJHcWt4N3FjZnY4aTM4YUdwSzhsU2RscFVa?=
 =?utf-8?B?RzBIVHlwakRYVlFwb0hmaVBLMjQza1JOd2RhYms3VmNXOFlYemUvWjhUNmpO?=
 =?utf-8?B?RjNhMmJQOHlwK1AwalV6L0Q2ZHFZU2pWeUYrR2ZSbE1IVll3Nm50akdnczBy?=
 =?utf-8?B?OTVmcUo3WHE5cExpUXdYVlNIZ3FVTUZuK2VCejU1cnJhWXIvckd5eWN4U1JU?=
 =?utf-8?B?T3Y5VFhEWk1EZURlU3Z4Q29wVkE5L3FqdUtuNUJYVUh1RUZ6aC9wUDhLZzUv?=
 =?utf-8?B?b29RNDRNUXJiM3p3QUhmSEVCS2NmcENJRjVabFZyU3I4NmlvN3lERFRLWkNU?=
 =?utf-8?B?UkR4aDZySHdkNzViSUFhR0wvTkYvekNoYmZaUEhzT2EyUmlCSm1MakVqdlZC?=
 =?utf-8?B?NFBDNlhjR003cEY1ZDBOei9ZOVdtN1NUL1NoKzNyYnRqeHBXK1hQSURRV0FG?=
 =?utf-8?B?dGRlMVljeit3RkFPZC9QZEFESXpTQ25kTDBkYU9xb2w4cG8rdm5pa0EyaXor?=
 =?utf-8?B?LzFtUVhRVVZ4MFZsdmlSNmZ2bHlKQ2U4TzBVUHMyVTkxQTN3dUpYRzFBVG1P?=
 =?utf-8?B?SG1aSzEwMHRJTk5BVTJBOFNXSkNPTkx0WTdISjVickQxbWYzQmlQU1VBOHNH?=
 =?utf-8?B?a09XMFNVVlN2dDhHdmUvWEs4ekl1S1lGdkhWbXlxVUhLQmwyVVk0NDhmQmJr?=
 =?utf-8?B?Y0JnWTJJNk1zazlLcjF0TnlRaEFPR1RYZnFWUUFsWGlTclRvMy95N25RL0M1?=
 =?utf-8?B?K2NwbTZFNEJiYTZpM0VSTEJNOFluYi9MUnZuQWw0QnYwcUMvdHhtcVhtWktH?=
 =?utf-8?B?anBJai8xMnBPd1oreDg2Zkl6WDZSbkM4TE5abmZJK2kreWpESWhCc0FkaGpK?=
 =?utf-8?B?MFkrY3hybDdGTytPdEMyZ0tnWmwxaTZaRFUwTnRyQkV6TXdPT3M2MGFaSWhD?=
 =?utf-8?B?enNKWnRhYnVBeU9VSTJ2c25rS2pEYXFoQUorNlVrMnRhMHBlamphSnluYnk3?=
 =?utf-8?B?NFlmWTR5TlZJQzNhSU96Y2lzUGxLTDVacnJJZUlaeVVGTDJzeFB4ajJDMFpt?=
 =?utf-8?B?MWgyT25rcUVaR1l2S3FSeXNnUHEyOE9nYTc1VzBwUjhEZlMrTDhZcGlCNFVm?=
 =?utf-8?B?ejN4VGVMWDh4S1pqd1RhUStRUklkQXhhVkgvaEduSGxObjBtZU00a2pySGU5?=
 =?utf-8?B?V0VRZG10eVFtODJ3a21IVUpWdWV2USszNDhaSXc0MVl5NXBpQTNBbGx5NCtI?=
 =?utf-8?Q?qJ06eavFK5ZJHvBUo2ExPDI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF4D31CB091D51428AAE170463315615@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 947435c4-d3c9-4339-d601-08dc45187a45
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 17:51:01.2145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TjIAFXl6+GzN0bkJNE0ioaMeTryLpJYfSHHDYN89fMlH1WZBhXKs9bP21bCN1Lm848DOajAChJQwWaqN+7dqtuOnbwqEsPnM844ykEoyfhM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7606
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTE1IGF0IDEwOjQ2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIE1hciAxNSwgMjAyNCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiBTbyBteSBmZWVkYmFjayBpcyB0byBub3Qgd29ycnkgYWJvdXQgdGhlIGV4cG9ydHMsIGFu
ZCBpbnN0ZWFkIGZvY3VzDQo+ID4gb24gZmlndXJpbmcNCj4gPiBvdXQgYSB3YXkgdG8gbWFrZSB0
aGUgZ2VuZXJhdGVkIGNvZGUgbGVzcyBibG9hdGVkIGFuZCBlYXNpZXIgdG8NCj4gPiByZWFkL2Rl
YnVnLg0KPiANCj4gT2gsIGFuZCBwbGVhc2UgbWFrZSBpdCBhIGNvbGxhYm9yYXRpdmUsIHB1Ymxp
YyBlZmZvcnQuwqAgSSBkb24ndCB3YW50DQo+IHRvIGhlYXINCj4gY3JpY2tldHMgYW5kIHRoZW4g
c2VlIHYyMCBkcm9wcGVkIHdpdGggYSBjb21wbGV0ZWx5IG5ldyBTRUFNQ0FMTA0KPiBzY2hlbWUu
DQoNCkFuZCBoZXJlIHdlIHdlJ3JlIHdvcnJ5aW5nIHRoYXQgcGVvcGxlIG1pZ2h0IGV2ZW50dWFs
bHkgZ3JvdyB0aXJlZCBvZg0KdXMgYWRkaW5nIG1haWxzIHRvIHYxOSBhbmQgd2UgZGViYXRlIGV2
ZXJ5IGRldGFpbCBpbiBwdWJsaWMuIFdpbGwgZG8uDQo=

