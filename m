Return-Path: <kvm+bounces-49239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8165CAD6AA6
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BBC197A784C
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01BDB223DD1;
	Thu, 12 Jun 2025 08:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nOubB/4p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8747F217730;
	Thu, 12 Jun 2025 08:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716854; cv=fail; b=ii1jDZ9YKqYMcMFVaRmjbI6uDOnDkmf2YhQ5aOQtuh6iKJLq4QsW2wsUtlaK5bJtHTrKccHBO7fPpeOjRh1t97NG34rJOssbTvU1Jz2XD+JbmQm6IrM1mW3l3iIUD+8+RiRdGR1BSbKiCu0/LBXUb57hjFQ/PS7zUBTKrXqDz78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716854; c=relaxed/simple;
	bh=BQJTjh3ZZEbO0kfA97Ji/9xj0U+3QqjKF4F41zwrIVI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UYI8rXsw/W4vGeD3jlk44yGW9mSkaTFaTIrDG94SLHx5RaVe/bOvoQxSxzrSDdBnVM248Gd2Lw5e2+VDUhMKqE5veHUnjEPePVQQKKt7qdO/O7Vsi+jshf2VFl5Ju5nlcVNQx6ekcX3PmBqSuftXBWqCpyoByZkmlQp2oGCG76I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nOubB/4p; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749716852; x=1781252852;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BQJTjh3ZZEbO0kfA97Ji/9xj0U+3QqjKF4F41zwrIVI=;
  b=nOubB/4pRYb8J9XFZ+CeynLf+yuku1Rk+2ohGNTAoMtoGY1ZIIVYxcUK
   xInyjQeNyOI37PM4TLrgJ3zvbQhPgsVnxJGti4YtU63s84zhO/Q9ZTwMd
   XHO9sHd/e//ZxBxEDpFUhG5UDBuJsRPhYnBZwChz13c+sGZsvhLZAIBT2
   ld5nHus8E+QE9lsNuB+lNdekpAorXUJGmLbkDtbpTnj/FxKlnv27ZzpRD
   BLcnqqAp3nibuFLZs2iKXbaq0GmS7KwBrAmBRSHB8nMMbfbsAriTr+aD+
   kZFWlxqRHYGiXTSPlRHKmZqLDMfh58GLsS6aVXs9IpqZUQHNAeD6m7QXO
   g==;
X-CSE-ConnectionGUID: CO9ZXsnyRJSbndNhr1BOUg==
X-CSE-MsgGUID: yydgNu2WQBOfbpsc5TwvSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="62536097"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="62536097"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:27:32 -0700
X-CSE-ConnectionGUID: uYCBDB8RQDmCWNIxQpkaJA==
X-CSE-MsgGUID: WMSQ9fbPSsOingcleGdddA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="178417053"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:27:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:27:30 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 01:27:30 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.82)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:27:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JfTzc3WXFs/tjcFtkKJrE8W24E1tRHTFFMacTl9PVtoZt/crPYqaTBCHLTSrCeOPBwVD0ki1a+Cx+klJWcLqLowMhINY4fnSnxvpxIbnYC3irRgkmAtQaYA3pEFGTbPIS9LYp3JNr7hEayGCshH2tE/JfT9FL/kNaGYOwXMDkstn8Ng/UtPS1ZakpAKJ5JUOfP9Xk2nGaoPAmGur1KQ+ULXsoSVrgmsHpN/V3PeVuSib2OTPTiGJWc3IFzs5AO7HYphINLcYUop7HjgHB9gH+p/9hLyADgvGCob1x6MlTQ3uVVn5oTK3CIOgVqtKF9P+QXe1RvU3Pwq+ezlWePfJgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQJTjh3ZZEbO0kfA97Ji/9xj0U+3QqjKF4F41zwrIVI=;
 b=chsswxCUCDSeDFQDHsnOXX77MwezqmQ3bwgvyph0W4YAnyfBxsHEVbkMk7fy6iZj8gydf91rEbRg4Q/hfJH9bkUK56KzemD8oXXCvbdECxoW4Wscmn8LTMSs/FEErZpAAVHgwucJRCuabPH6U/hOBTyp6g27enDFhptZR11q53+4IYrkq1dSZ2blrJXxEg31tdJbx6Qm36Zn3Cd38kwsopDVH4p2NrtAEvWTf9AonTH5ay7idprpLC9bVm8CKOOA36Afm8wMqFDvaUQBGVGT8EcRittDxDIlhxn43wUhUguqhg6EXrvHYQVSQ+Cgn+PgsDNH5FxuSGv1v/dQoywmHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA2PR11MB4937.namprd11.prod.outlook.com (2603:10b6:806:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 08:27:22 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 08:27:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Lindgren, Tony"
	<tony.lindgren@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Topic: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Index: AQHb2a1T4nqpoq9P7US0P7r9HmA6d7P8HXSAgAESDYCAAAs3gIAA02cAgAABIICAABiCAIAAB46AgAAWhACAAO5xgA==
Date: Thu, 12 Jun 2025 08:27:22 +0000
Message-ID: <88c3cd16a24c7318f671223bd65eef63fe276a08.camel@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
	 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
	 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
	 <671f2439-1101-4729-b206-4f328dc2d319@linux.intel.com>
	 <7f17ca58-5522-45de-9dae-6a11b1041317@intel.com>
	 <aEmYqH_2MLSwloBX@google.com>
	 <effb33d4277c47ffcc6d69b71348e3b7ea8a2740.camel@intel.com>
	 <aEmuKII8FGU4eQZz@google.com>
	 <089eeacb231f3afa04f81b9d5ddbb98b6d901565.camel@intel.com>
	 <aEnHYjTGofgGiDTH@google.com>
In-Reply-To: <aEnHYjTGofgGiDTH@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA2PR11MB4937:EE_
x-ms-office365-filtering-correlation-id: 41684b5b-100a-4b62-ecdd-08dda98af464
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Z1MwdkoxRWdVOFNVc3FmdCtLZWx2NDN5Z05DSFNQUldWWWk1d25McW1uY2M2?=
 =?utf-8?B?Wm84RklKSVMyVGFPR0FoMzdKRGVJWDFmOWJyeVM0NktCelZtYjI0NTFZaE9u?=
 =?utf-8?B?bmRBQXE1QjduMDcxYzh1NW40TzREL0ZXWXduYmlmVDRHTEd6ZGJYY1cxYkQ2?=
 =?utf-8?B?b1ZzUEtWYXJFL1VmYno3a3dEZ1lwYTVsR0VOa3JaZ0RXV2o1Z0xWbjVHYWxQ?=
 =?utf-8?B?RTZLRjJBZnQvN04rUGNNaTdVbUtIUTR1MXcwalArcW9YUkFKc3hsRTZ5cGdt?=
 =?utf-8?B?WFFOcUhWYzVtMGVaM0RJOEd4dVRTM2R4VmNoQ2FCVURaR25pYXhuUEljSHlr?=
 =?utf-8?B?N0Q3SE9ubFJjN0xTb2ljTFExRWhZemV5SzFHT3N6ZVhmQUVYZzN3RFdJQ3ZU?=
 =?utf-8?B?S2Z2S0FHNWI4cmJ3T1hxdFhHRU4zekQxbjlhbVlKQkYxaFpDUUZuejA5bWxG?=
 =?utf-8?B?YmhTbU9aRVppS3Z3ZjErb1MxLyt5cUdIcTc0QUdTQ3FsdUhWSi8rWkZyVmJE?=
 =?utf-8?B?LzdwdklZTWxBdk1vT1E3V09EVjZvUVVTa3dXRFZ0ang0M3Y1dHJuRitoZ0RF?=
 =?utf-8?B?TlBXRHlCRGVnWTdvMlZIaXBOVndCbnBKZGtqYXp6RTZhTks5amRoQVdVWkFZ?=
 =?utf-8?B?MTFGMmR5VWlraWEyTGwzSGhJRWdyVk9TaXNLRHlrQmJycnBMSkpaQk9OemRk?=
 =?utf-8?B?Z3BlZVViU2ZsMzhwWFlIVnlldERvSmFwWkx2bmI5cENpckJmK1U0YmttQjV6?=
 =?utf-8?B?bXVOOGcrNGQxQzZqV0lBUnVDa09pVXFFKy9qb1JzQmVJVlNEMnEzWFpWRFhz?=
 =?utf-8?B?TTc1NzhWa3UrWlA5Qko4ZjNXakN2T3BHcDlYKzJjUjRRMnNzN3Bzamx0Snk5?=
 =?utf-8?B?aTRFbGxDWVFlSzZ6RzJ2S1d4bm51Ujc3RU1sQ3JSRGFqbE5ZUmpuVk1oTXhh?=
 =?utf-8?B?VDUrTC9DbER3Y2lHRzFzWTZKS1MwVXg0eTlyQzFqd3ZFRy9HdnB5YkNRL0hL?=
 =?utf-8?B?N29YL3BncldpZUdkM2J5eXo0bWNDZXpYdGRQSmxTc2c4WnZ6QjY3bTJlbWxJ?=
 =?utf-8?B?STNYKzN4em0ySXdZcjRSS2NCR2VMM3JQSnlKTjgxTWIzaTFXdnZYRWYzZ0x6?=
 =?utf-8?B?anpIclRiRm4yZTFQby9lWlhpQkJPN3M3WHo4OW1OaWVETnY1aDBCSmI0QU1N?=
 =?utf-8?B?ZzlVZ0lvT3dkYUlCL0IrZ202S3R0UTMrMW9HbVkxczZoMWNNTGx2a3pmYWRL?=
 =?utf-8?B?dlNseWd5YldBa1NYaGszM3YwU2FiNG1wTSswWGdkdVJidkpXNERaaHJiZHhO?=
 =?utf-8?B?ampGOUxtZ0pNdUZERFJiWXVIb3Y5YmJMUktJN2FveU5PSjZ5QzhveCtLNWNK?=
 =?utf-8?B?dmVHblAzZkZqc3BpSUZUKzFmc0MzdkxqQ1kwc1FMOE8relNTcUtjdHpiNXkx?=
 =?utf-8?B?ckQ3Nm1TcFplazZkVDdEL1prZExCZnVGRy9kRlh4U1p3N2cyUTdCWVpyNUE5?=
 =?utf-8?B?VkhxRnNxUjNoTUgvNFJJd2VyVWtNRjRGYVVyM1BIeDQ2b3EvNHhEK1JhUGRY?=
 =?utf-8?B?S1V0MEh3MFU5U2ZlNkc1bDhQcW81QjFXTGN1NlQ1aFMvUGhkWXVGRHVMME9J?=
 =?utf-8?B?SmRuWWpIaXBPQUpqcGxQbzRLZnprRFUrSFIzU3JlQmR2VmFncjBEN3JGbnlC?=
 =?utf-8?B?TWtFay9iS2hkZEFXK0JGaW5lQ2plakNVWTcrdFlKZWllcWZOajBZQ1dCN3Ry?=
 =?utf-8?B?QXZPMVd0UDEvclRGVWJwT0lYMlg3ckx1eVViM3JiNlVHb3RqbGwxalg4RXlh?=
 =?utf-8?B?TW4rWm45RXphOE1pV2h5ekZjdXlzbWdCRG9CRVRnN1lCWVZOUGd0NHN4SmlI?=
 =?utf-8?B?ajI0YzNLdEtHUGdGbWUxQkp2c3NDNDFKYlN2YkZkM0ZGRFVrVk1BZ3JlWVR1?=
 =?utf-8?B?NE10Smk5a0ovc1Z5Ri9pV0ltejdpYlhPV2h5TXJFVFYxanVwVlNlbHIwSXdE?=
 =?utf-8?Q?oPNOIXu32BgvUWoQu4s3oB9qVpfWtk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnZKYnA2a1dWaGpYaFE4TW1lT1hxR3k5a3YzWWU4ZnhVcE9hOEhEckt3dkI4?=
 =?utf-8?B?VzZEb1JZUUtqSEFGS3pndkIyWTVwUHpmaWpLdVdSNjhWTWoxTS96YVlsdE96?=
 =?utf-8?B?Tm5qdG9EK1JBSXZlL2dDekVIUlc2MUFwT1IvWVNvd2FzZWtTa2hRNlJPbVlG?=
 =?utf-8?B?bk1hR1BxczVEeW1zRVpMc21sK1RyU1VlcGlpV0c4ZC9iVjRuaUthWkZteHpC?=
 =?utf-8?B?NkhSTzNjS2pNaldhcFM2cWQzVmRSZ0lTVUJvMnFGcXloNUFHNk1hUEQ4dklp?=
 =?utf-8?B?d2NnZEp6emxXbUdTSjFwVTFUbW5wL21KM0Q0dENmZkR0UkFFdFFSWFBhdW80?=
 =?utf-8?B?SGZtMlU0K0tUV21YRGpmRDdoRjBFV3IwdTFxQlcrenBrbWVBQzZXQ0xxVEVi?=
 =?utf-8?B?WFhuc0tsM2t4S08zOFJuSkdMSXhvaW1VM3J1QUZJTWxmOERqVVhRN096TjQz?=
 =?utf-8?B?MWJIWGhIdFNuR3NnN1ZMRnF3dHAvTVYyQnR5ZXlDY0xKSUU3R1QzM2RFZlZK?=
 =?utf-8?B?NUQ4VnBWYmp0K1d2alEwWW1GeThHNkNyNmh4bVJBS2lGU3hGTjUvb01zaTgz?=
 =?utf-8?B?bDhxLzg5M0lJQWdVVSsxdjFic0VlWlN0WDJJQ3AwRjIxNFJhZVVHSUtNaVU5?=
 =?utf-8?B?MEdldzlhS3kzRks4ZU5zVWNzMlRBMFhCV1Z1Qlh0eFRhQ2ZxR1E4eTJBcDBF?=
 =?utf-8?B?SmpZZTRDdDlqd0Raa1p2VFpCamJRNmRPR0NaWnR4b2JYKzlENmlua0ZuOFRH?=
 =?utf-8?B?cVFkdWFQNis5eVN1MGlXY0FDaEpmNEVlRXl5YW9wL1lvZm1reVM5WUZ3dTkz?=
 =?utf-8?B?SUpPV1M3LzFackNwc204Wm1jekNiaFRrNWNLM0tyNDRLZGl5eVNRZWZYcXdk?=
 =?utf-8?B?K3A0MTY1c2gxQlZOVEtoOXAvWlg5bjZvS2w2MVd0SFkyTGxocFp4bTFVYW0y?=
 =?utf-8?B?RUpYTzlzcUFtczhZTkhtVDJlYmRQcDRxQ0FHelluZDFzV0U3YmJTYkdHVHp6?=
 =?utf-8?B?Y2pzbkxwbHFjamVSRnFtWEMzR2lvSFY3V3NXUmxtYjZvR0tlV3RlY3F1QVhh?=
 =?utf-8?B?dFAvb3BlU0Z0NG5HSnVHdmRBL3VmMHg3ZWhqS3NYcHprVVNMNEFrcDBJRkZ6?=
 =?utf-8?B?YlpNQ29Bc0lJWkFHNzJMdWVxTXRlTUVobnZ2L3owbFhJQ3Q2VFQvY2RpUGhK?=
 =?utf-8?B?bE1tQTVkM3p1OEptMkZidVJBUStWWlRVQzNLb094cWdQSW1xT3RwVW5FNDE4?=
 =?utf-8?B?Zjg5OTRtSlpNbDVsaDNKbVJBYzJScGZ3WnlIUXlxUHcvL3dpeTlZUm83STU2?=
 =?utf-8?B?WE9sOVE1dW9OS2xEYXhiL0x4VGhYVE41TmhmY0Q0NnVzTGpDMHpmSHFDZkZI?=
 =?utf-8?B?Vk1NOW12TlZQLzdkWkwySk5UTmxmSFVQcXdERHo4OEJENXkyQzFvQzRsd0xG?=
 =?utf-8?B?SHVOMDRia2YwazZuaHIzWVYyUW1lZzVuakYrZVIrWktraFdDNm9zV3ZoTCtw?=
 =?utf-8?B?MWRBbXpieldMMEhIbGlHVDR3c1lncElhT3BOZFVFS1FjQVdOZjI3UUs1cmQ0?=
 =?utf-8?B?Z3hIN3A3MjhQR242RWNmS1hxc2J3d2lSTzV5ZWZUdFN4dCs3cjV5YS94cG5o?=
 =?utf-8?B?VnJMUmhyODhScFpJcmJyWVRMVkNreTh4MGZuM20rNTVPdXNnUmZvTVdlV3Jz?=
 =?utf-8?B?MHN2UHB6TUZ0WE1lQko5OHM5aDIzeWwzMkxoSHZzcnVvWTA5NVVmQlhLY0FV?=
 =?utf-8?B?cDh1S1lDNllBYU00dUZmeldHNTZGWVFLUzBrTzRGOGhXcXY1ZzYwOVpjV08r?=
 =?utf-8?B?QTNYbEh4NXNkYS9odC9pcFlwcUJzREZpclRLUGdBUEp5VkJRNFQvS3dxbEkr?=
 =?utf-8?B?czllOVNNazRGVDlad1ZTdHZCby9RV1VJbXVwaVpMWUk0c0Y3djFXRW13K0xF?=
 =?utf-8?B?cHVubnBjbUlxL0tkTjFDV3ViRUtnVlA1MjBxbG1XdStSZC90bGY1WTZKUEMx?=
 =?utf-8?B?enBnWFY5aE93RzZ0SjFUdHdZY1EzV0hZWEJrMm5LNERDVDZSY0NOYnp5TWFF?=
 =?utf-8?B?WW1OazY1MkhDRkFZcTlpSWVsYUs4YkRyL3ZmN0xDWlo5Y2VzM1ErOW9iOTcz?=
 =?utf-8?Q?l0hAp7qN1inY6ClK9itlpBbbO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B45F26F59B9364B9750957F0F912237@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41684b5b-100a-4b62-ecdd-08dda98af464
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 08:27:22.6898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QbmeZ3EODMjc0K/UxsUhaSSHRJyp6zmvEsNYlHFtF+wqUjLsxKwPI2er26GTMztlRv+EpJxqazTvb7NYwm19Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4937
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDExOjEzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEp1biAxMSwgMjAyNSwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBPbiBXZWQsIDIwMjUtMDYtMTEgYXQgMDk6MjYgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gPiA+IEdldFF1b3RlIGlzIG5vdCBwYXJ0IG9mIHRoZSAiQmFzZSIgVERWTUNB
TExzIGFuZCBzbyBoYXMgYSBiaXQgaW4NCj4gPiA+ID4gR2V0VGRWbUNhbGxJbmZvLiBXZSBjb3Vs
ZCBtb3ZlIGl0IHRvIGJhc2U/DQo+ID4gPiANCj4gPiA+IElzIEdldFF1b3RlIGFjdHVhbGx5IG9w
dGlvbmFsP8KgIFREWCB3aXRob3V0IGF0dGVzdGF0aW9uIHNlZW1zIHJhdGhlcg0KPiA+ID4gcG9p
bnRsZXNzLg0KPiA+IA0KPiA+IEkgZG9uJ3Qga25vdyBpZiB0aGF0IHdhcyBhIGNvbnNpZGVyYXRp
b24gZm9yIHdoeSBpdCBnb3QgYWRkZWQgdG8gdGhlIG9wdGlvbmFsDQo+ID4gY2F0ZWdvcnkuIFRo
ZSBpbnB1dHMgd2VyZSBnYXRoZXJlZCBmcm9tIG1vcmUgdGhhbiBqdXN0IExpbnV4Lg0KPiANCj4g
SWYgdGhlcmUncyBhbiBhY3R1YWwgdXNlIGNhc2UgZm9yIFREWCB3aXRob3V0IGF0dGVzdGF0aW9u
LCB0aGVuIGJ5IGFsbCBtZWFucywNCj4gbWFrZSBpdCBvcHRpb25hbC4gIEknbSBnZW51aW5lbHkg
Y3VyaW91cyBpZiB0aGVyZSdzIGEgaHlwZXJ2aXNvciB0aGF0IHBsYW5zIG9uDQo+IHByb2R1Y3Rp
emluZyBURFggd2l0aG91dCBzdXBwb3J0aW5nIGF0dGVzdGF0aW9uLiAgSXQncyBlbnRpcmVseSBw
b3NzaWJsZSAobGlrZWx5PykNCj4gSSdtIG1pc3Npbmcgb3IgZm9yZ2V0dGluZyBzb21ldGhpbmcu
DQoNCldpdGggbm8gaW50ZW50aW9uIHRvIGRpc3J1cHQgdGhpcyBkaXNjdXNzaW9uLCBidXQgZXZl
biB3L28gR2V0UXVvdGUgVERYIGNhbg0KYWxzbyBzdXBwb3J0IGF0dGVzdGF0aW9uLCBiZWNhdXNl
IFREIGNhbiBqdXN0IGdldCB0aGUgVERSRVBPUlQgYW5kIHNlbmQgdG8NCnJlbW90ZSBRdW90aW5n
IEVuY2xhdmUgdG8gZ2V0IGl0IHNpZ25lZCwgdmlhIHdoYXRldmVyIGNvbW11bmljYXRpb24gY2hh
bm5lbA0KYXZhaWxhYmxlICh2c29jaywgVENQL0lQIGV0YykuIDotKQ0KDQpJdCdzIGp1c3Qgbm90
IGFsbCBURFggZ3Vlc3RzIGhhdmUgdGhvc2UgY29tbXVuaWNhdGlvbiBjaGFubmVscyBhdmFpbGFi
bGUgaW4NCkNTUCdzIGRlcGxveW1lbnQsIGFuZCBHZXRRdW90ZSBjYW4gZmlsbCB1cCB0aGUgaG9s
ZSBhcyBhIGxhc3QgcmVzb3J0Lg0KDQpPZiBjb3Vyc2Ugbm93IFREIHVzZXJzcGFjZSBtYXkgY2hv
b3NlIHRvIG9ubHkgc3VwcG9ydCBHZXRRdW90ZSBzaW1wbHkNCmJlY2F1c2Uga2VybmVsIHN1cHBv
cnRzICJ1bmlmaWVkIEFCSSIgdG8gcmV0dXJuIHJlbW90ZWx5IHZlcmlmaWFibGUgYmxvYg0KYWNy
b3NzIHZlbmRvcnMsIGJ1dCBzdGlsbCAuLi4NCg==

