Return-Path: <kvm+bounces-14875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 616998A7512
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 168042855AD
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4224F13957B;
	Tue, 16 Apr 2024 19:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ngQYuuwX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F5DE555;
	Tue, 16 Apr 2024 19:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713296727; cv=fail; b=eBag5tSF5e6nBzxplFc/ugkfbkEsoKWfd6TQLgcVgsp7dhj6ajuuT2gsi/K1s786RcTrS0QlN/92X2mwIlz72EDSem0i7Yq9b8IOjaaoQ4xe97gJfOe/Gz0vZ3T1PLnnPvDOAztC81XWH+F1CkDFTNrHfMASYEhaGKVT84xDI/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713296727; c=relaxed/simple;
	bh=5WPNsPT5DU26UJyx9ezb6fQr6a2hvaz6VEiSsP+UMR4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tgMsERRxauZVeUSt1zYHDT1aG0xqY6IOhjVGvXVKm+SJv8ExH2GYMchNIMKiN27VetXjTHuu4T8LJYKZI14KWX5xr+2fG1/+pvxG107INKy9SjtS3HvciiGoyuKYVpM/UEZ3ujxKQRex4GZCZIMV/CJtclFo1Lcjm38lQKia858=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ngQYuuwX; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713296726; x=1744832726;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5WPNsPT5DU26UJyx9ezb6fQr6a2hvaz6VEiSsP+UMR4=;
  b=ngQYuuwXvFhpxEl7vk7s0j+dRF/gaxQBCX/wapLQseIrF4C5sj8FW1Zp
   Hmy/qau0JSj5SDcSwMEjBsyMpDteOu5BOTw/qyVnUsbsCRpWnEwvu8j5h
   WsSnVfVHxwYNH5bJIklt4esWP3jeqL9BIksmRntoyCZ7QhP8PxzNeSIAw
   doZVlC/ELZMnVYeob0MZZFi+MXR7JDxmbBsHcrYsEIzU14FtEcK2Lzmkc
   cOYlYxER0tokyu+NR0/V3ifv/skxZFUzv1az4J8X0uYYt+UMq9znAkI4S
   wK93hgOv/oNOzCzyZIzdmKoM90S5OoROnH5RvwZgiaHC0Yg+ne4bwjnaI
   A==;
X-CSE-ConnectionGUID: GGqzuQh/RDiBWIDZOqqPCw==
X-CSE-MsgGUID: +zXSx/NQQPS1CLCn9wTVRQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="20180359"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="20180359"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 12:45:24 -0700
X-CSE-ConnectionGUID: KXg3szwqQKWkB588RYkbrA==
X-CSE-MsgGUID: 2c1PkNBWTx6u17KfjyYYqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="53346530"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 12:45:24 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 12:45:22 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 12:45:22 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 12:45:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CSapVo5DunfRDF+BeIrF7zycsSQ8i2cksxMAZLi96LdCaPP7Ir4ibhWmGGaBvS96E9XfWfKgq5DPE4yFl94YJzsWloAZ+DHK6c8EIIj2wOfRWfsSnNt2BK+ozXEckDPR3gj6aHy5Yl0O6Qwk9zFCENLJK7Zxx3nva/hNnfq4WtrXm+vw+wS5MWdc8H6ItSHzjmP7oZpdMWoW3mXHRciRgnoVAgUFM/BeUz5z711RnRA5QNbVR+3kiIyRZsfnwTT0aH9fL9OOsstcsnpjNZDUNSm7z2vbUmcnb+q/U9FlbYdEBGhME4xSuxMZWZ9L4x7S9eq70hqvVkf1iCztUbgvCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5WPNsPT5DU26UJyx9ezb6fQr6a2hvaz6VEiSsP+UMR4=;
 b=Jtc/v4WQMR0c5kyadV7wPDiDR3+/q5qdQ6yO8FWM/j/Ye+S6jkIrJdoydpxZhkRM3ZrusiX7jCQIWdfxXAdvfa3W2xNl0prVZeHx+8luZUkb1YDWuZ9iYA+FPPnDq/ZM67cNtTumdYyFjxvTKQaMYIcZnxb1X3pKADQTgU5SUhaxveZfM8CcevS6rUHbXPVJcuqPdeid+72g0bcGssI99squ44msizObjRZ6VUcN4rQPNyh1VQ84TM4Ty2fKY92hyw21j95eMOKrHDDxCj4qrdkoY+HoUlPkhYNB4xysrvh1ZdhHlJ3TzdlRmI1AROA/2wgI8v9RamSMZsX0satecw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB4782.namprd11.prod.outlook.com (2603:10b6:a03:2df::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Tue, 16 Apr
 2024 19:45:18 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 19:45:18 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Topic: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Index: AQHadnZ/Qf0yAsUauU2/h9YYap6ribE4BK4AgAD7XwCAKJ4bAIAJ4iGA
Date: Tue, 16 Apr 2024 19:45:18 +0000
Message-ID: <39e9c5606b525f1b2e915be08cc95ac3aecc658b.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
	 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
	 <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
	 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
	 <ZfR4UHsW_Y1xWFF-@google.com>
	 <ay724yrnkvsuqjffsedi663iharreuu574nzc4v7fc5mqbwdyx@6ffxkqo3x5rv>
In-Reply-To: <ay724yrnkvsuqjffsedi663iharreuu574nzc4v7fc5mqbwdyx@6ffxkqo3x5rv>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB4782:EE_
x-ms-office365-filtering-correlation-id: a74a6096-b7a0-4af0-219e-08dc5e4dbec7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k5l7pH0Vd9RFeDbb8Gqis4umi8ZhKidjblLXxYnUkk8kMxltXvBrtvKGyyaBeycVrdsYIMKgSi3dmjM0FJRMRcDdXzOW6d6ze0YZUxZxMNA4tNwK6FSKGnewcTsQE54PfzDvd/819W2rM6XLPT8M1w0oNzJ7+HGWFOEkBOe/2dKo3NfBtlZ9AnaXqEJJ7+eG2gkzWCh3W558ovI4BNcOOsTjlfJDon8lDCikWIKoEzwI9QdOXZ15987wHGmVgTJMoenil2SftMtsa2wI9hwghIMMhCZF4p7QlCtNb9CxP2TfU1VhtZaxFYZL+L4oPlqZXtUUofLe/AqIWU9y+rzJzT1VtVUX7uhSxb91KL6UWbZ9QvaQTKWXL7uyy7j/OsaXG2N1Q5h3nvd3O3cbAGdgtDHmu03OVcW2Yskjf3Ls/UasgdKtIr3+kfmgHDyxpMfhRnBxQm//goV/orEqtXm1cOulpQ+c0M9z3ca7yr4REqjzFmpC6+1Amby0Rmmld3apOyMT1IV/ELXl2nqzRIROJJCyUAV79yKNCFVaRhSHM4bnPpA1AMaZocXTp3rIARo7wbuu//E/k5tHlZsvgTK4i/6hAehs/6MA2hzmF9fOrrs38o6mBqaY+AmFy8o2ntFgl6n3BPfBuXAHQq1KFWvaiUENHYK/PlPz2GxNzY0U60bc3dM+i3g3v2pOvlbRx/VGxS8I3nPN6R3q1/vKn+lYiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUFIUVI1SzRhSHprUUpzUllONFdtdEZIWXVhS2ZRSDFWSjNvTlQzVlRGNDdl?=
 =?utf-8?B?VjFNd2g0cmc2a2p6T3pkRzZzUDN5UmpGRDZJU0c0YTFUaW1wTDBBZjdmcXVk?=
 =?utf-8?B?QzkzVUF4eFI1bjFNalFvTGhvYVI5Yy9RQ0RvTVpMeHgvZ1lUWG1mQUdkMUVV?=
 =?utf-8?B?eXNPVFQreStsWUViamlMV3k3MXdrSXN4N2x5cFFtOVM0bDlQdWNZWHVTM2gx?=
 =?utf-8?B?SHkwTUNTcktwUGJ1Q3ZEN0FjUnNqSzMvdWxlZHpTR0FqV20vN3JRWW0xVkpX?=
 =?utf-8?B?bEFvMDE5eUdxR0pBdjJWdkY0M0pvYWtLRGZETkVzcENrL04zQlVJZ0hIeGVJ?=
 =?utf-8?B?M2o3MG5FZW1sU0paU2ppN0x5eHlMWmxscXkvV0hlMmxtZ1FDQm94cHVKcXpX?=
 =?utf-8?B?cTljUFdVQjN1SkRVbWc2d3EvSXhOV094MEJReEJYNWFmcHdGSE1GNWtYNUtk?=
 =?utf-8?B?Zm5wZHZtRVFNcXdGdDYxbEhDTmNJK3o5QzlUSXhxaVZQY0RSNDZ4U09GZDdH?=
 =?utf-8?B?VzloWDI2cFJsbXJXSmNDdjV4OEVMMEk5YU9EbWRwbStjSSs5Zzh3MkhYNXho?=
 =?utf-8?B?aC8yTmppVENVL2s0Y2psSDBadG5KcHpJbWFmS01GQytNWUNETlRVRGl5VE5s?=
 =?utf-8?B?QUhqZkhrR1kyRWlrREdEaFhMTkRFOEI5cEZRWlZvajRiZmpidXYxdXo1a3RY?=
 =?utf-8?B?YTRlZ2h2dUZObWJhVmFtQWZJQXZXSkN6SnFHa1BsTndpKzRPU0JtaUpYWVZr?=
 =?utf-8?B?amt4MDFVWTJhZzIxdU5lb2Y1UTBHbnVsenZLK2NZVzFXaTA4QmxoS0h1VTRl?=
 =?utf-8?B?eDZrT0s3RHVBUXhuVkxDdk52T3o4OSt4MGFIaTBqT1M1WjhnZmQ1MStycmRV?=
 =?utf-8?B?L1AzSmtZd2cyWXIyalJZZHYxUWtWbFl5UFRWWG0xcWd6NXNyUURqNlNMY29D?=
 =?utf-8?B?aTg0eGV3QzFIeTdUYlUva0Z6THQyMWUyZGhjcWY1eER3cDRyUE1ZeFRKSHpQ?=
 =?utf-8?B?d3NnRVQwR1M2dUZTcmdqTlBWZGVRa0hORi9DVEh4d3dUUEJPMlUwUmxJanVL?=
 =?utf-8?B?N1VHakFwWkIvdFRYYTBickErbEttVzJOU0VRUVhlbXNKckk5OVk1aERuZ284?=
 =?utf-8?B?TjVsdEFsRkc3djY0LzIzUDh1V1lLRUR5WFQ5MnN1em9selFwSDU3dHM1YTRx?=
 =?utf-8?B?L0lkYitaVnA3VVE2K3hoTkRYR3RtMG0wU0dzOHBBSFNacURySWd6eUxPS0Na?=
 =?utf-8?B?Y1lEQUVwWlVoakhRV3dMb2lZQUJ6TDBqS0FUcmVSL0c2ZzN2S2hselZoTnJ1?=
 =?utf-8?B?Mno2ZW43V3dXSnlxNE5JSjRJSFZsRU5QYW5NSnNjaFFJZkdlaGt0RkhTSUhu?=
 =?utf-8?B?RGR0WFlZbzhMSjh2bXZ4TDZRdmtQSHdsZUt4ZTQ4V1lINjZTYjdVVHByWFh6?=
 =?utf-8?B?K1RBODhnYW5XMldTa3NwVE53aDhKdHY5UmcxK0tzUmJMZjlKN3NMM2thS0ZU?=
 =?utf-8?B?VTJzR1ZqWXRLR2h1V1RjaVAzdjRpYlo1R0lZMmp6R3N0NVBqVEJYQzYxZ1c0?=
 =?utf-8?B?dE9aQm80TGpyQ2dYWnozM0tmVEppWWZlYVIxN3A0NGNwU2R0VGlINjRQYUZt?=
 =?utf-8?B?b0JVcWc4cDM5Q0pXT3p6QlhMYVJiQTBRNURyM3BjT0IyUzFXODJxTHN1bHZt?=
 =?utf-8?B?aDhBRjd1MVJDb203RHI2ck5Gb0hTUE5Pcm02d00zMUZyaW95Q2NhMG9SUlBX?=
 =?utf-8?B?MFBWbzNLdll5Qm9yKytmV1VFdjdFRmdzSWkrTkphbG1wdG84V2E2Qkp1MUNj?=
 =?utf-8?B?TmpYMGRpNUdyZkJON3lJWUVMVHJyMUdaclQrMExrL3orTGFZeDlLM25nNGw4?=
 =?utf-8?B?UWVMYUwxc253a28zOGpYM1FmZzU5MGNQMWxHY3p4bEdwSW14cEhheHNYVjda?=
 =?utf-8?B?Nm81MnpsUkhFZjlQNi9jRnNnZnNidE5kTzlsNWtuNy9lazV1VkY2ZFNlcmV5?=
 =?utf-8?B?VDFsOWNFVXdJUG01WWZUc09ydTZvRno5WVZOb1dPRnpzYjZvdkR5Y2hGdlFW?=
 =?utf-8?B?dEU2Zml1Q2twTzhESTRkd0ZheFJvVGw2MW5FNmtMZTFqVUJmV2JjZXBoUGRq?=
 =?utf-8?B?YWlGT2V3WURUQzhiOUV6M3BnSFlGOVhwdDRGajBUVTBvUVIrR2FkMnVxNERZ?=
 =?utf-8?Q?UUMCortZwlebAd9HJIxrDxA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4B6541C5E91BC4CBC35AA7715FFBFE4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a74a6096-b7a0-4af0-219e-08dc5e4dbec7
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 19:45:18.5605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CMp4iCzBwCNn0tYBMRNh0kOjgGen0Y3jcF0KvTGLyCh96js0fBr9xpHQCKcBDwcpXKGdQdo1/jgW0pFZTAWcxer0Qgg4Nq3ipyGK6H6pbKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4782
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTEwIGF0IDE1OjQ5ICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IE9uIEZyaSwgTWFyIDE1LCAyMDI0IGF0IDA5OjMzOjIwQU0gLTA3MDAsIFNlYW4gQ2hy
aXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gU28gbXkgZmVlZGJhY2sgaXMgdG8gbm90IHdvcnJ5IGFi
b3V0IHRoZSBleHBvcnRzLCBhbmQgaW5zdGVhZCBmb2N1cyBvbg0KPiA+IGZpZ3VyaW5nDQo+ID4g
b3V0IGEgd2F5IHRvIG1ha2UgdGhlIGdlbmVyYXRlZCBjb2RlIGxlc3MgYmxvYXRlZCBhbmQgZWFz
aWVyIHRvIHJlYWQvZGVidWcuDQo+IA0KPiBJIHRoaW5rIGl0IHdhcyBtaXN0YWtlIHRyeWluZyB0
byBjZW50cmFsaXplIFREQ0FMTC9TRUFNQ0FMTCBjYWxscyBpbnRvDQo+IGZldyBtZWdhd3JhcHBl
cnMuIEkgdGhpbmsgd2UgY2FuIGdldCBiZXR0ZXIgcmVzdWx0cyBieSBzaGlmdGluZyBsZWFmDQo+
IGZ1bmN0aW9uIHdyYXBwZXJzIGludG8gYXNzZW1ibHkuDQo+IA0KPiBXZSBhcmUgZ29pbmcgdG8g
aGF2ZSBtb3JlIGFzc2VtYmx5LCBidXQgaXQgc2hvdWxkIHByb2R1Y2UgYmV0dGVyIHJlc3VsdC4N
Cj4gQWRkaW5nIG1hY3JvcyBjYW4gaGVscCB0byB3cml0ZSBzdWNoIHdyYXBwZXIgYW5kIG1pbmlt
aXplciBib2lsZXJwbGF0ZS4NCj4gDQo+IEJlbG93IGlzIGFuIGV4YW1wbGUgb2YgaG93IGl0IGNh
biBsb29rIGxpa2UuIEl0J3Mgbm90IGNvbXBsZXRlLiBJIG9ubHkNCj4gY29udmVydGVkIFREQ0FM
THMsIGJ1dCBURFZNQ0FMTHMgb3IgU0VBTUNBTExzLiBURFZNQ0FMTHMgYXJlIGdvaW5nIHRvIGJl
DQo+IG1vcmUgY29tcGxleC4NCj4gDQo+IEFueSBvcGluaW9ucz8gSXMgaXQgc29tZXRoaW5nIHdv
cnRoIGludmVzdGluZyBtb3JlIHRpbWU/DQoNCldlIGRpc2N1c3NlZCBvZmZsaW5lIGhvdyBpbXBs
ZW1lbnRpbmcgdGhlc2UgZm9yIGVhY2ggVERWTS9TRUFNQ0FMTCBpbmNyZWFzZXMgdGhlDQpjaGFu
Y2VzIG9mIGEgYnVnIGluIGp1c3Qgb25lIFREVk0vU0VBTUNBTEwuIFdoaWNoIGNvdWxkIG1ha2lu
ZyBkZWJ1Z2dpbmcNCnByb2JsZW1zIG1vcmUgY2hhbGxlbmdpbmcuIEtpcmlsbCByYWlzZWQgdGhl
IHBvc3NpYmlsaXR5IG9mIHNvbWUgY29kZSBnZW5lcmF0aW5nDQpzb2x1dGlvbiBsaWtlIGNwdWZl
YXR1cmVzLmgsIHRoYXQgY291bGQgdGFrZSBhIHNwZWMgYW5kIGdlbmVyYXRlIGNvcnJlY3QgY2Fs
bHMuDQoNClNvIGZhciBubyBiaWcgd2lucyBoYXZlIHByZXNlbnRlZCB0aGVtc2VsdmVzLiBLaXJp
bGwsIGRvIHdlIHRoaW5rIHRoZSBwYXRoIHRvDQptb3ZlIHRoZSBtZXNzeSBwYXJ0IG91dC1vZi1s
aW5lIHdpbGwgbm90IHdvcms/DQo=

