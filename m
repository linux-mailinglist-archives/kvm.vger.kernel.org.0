Return-Path: <kvm+bounces-30707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D3C09BC8F5
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:20:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 754D0B2368B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 09:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B6241D041D;
	Tue,  5 Nov 2024 09:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dC0OISYM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31ED218132A;
	Tue,  5 Nov 2024 09:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730798437; cv=fail; b=qVJVa4EuWa6pYR4FUBoIyLeOW23DL2QI+bSp6z30z7DKuLce6J2TMmL/AxcdG9u5ltD1qf/4u6pK7l0vaxQNIWqGYyN8b+f6Smp0DxP/m0WFpi0XThkdGo/8V3NGn2W80yTKMUwSXXlnZDCQFEWl5059YieiVtlc1mI8rNOY83g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730798437; c=relaxed/simple;
	bh=FRhqq0KVfcJEkAcrYK8kA2VbUA1Lnd/ValQGJQ5d1+w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZC0CQE/p6YB98SE58oDJjCQM6DNc6sflOLVS651AtRliZMJcDZJuKGowxJRbJ3CoSwlqLyxpX63vf2UJGu4wX42i0deU8wo6fXTqgGvL1Kx6Md9C2fv22IJHU/0V0ekVqyZVpxmqy+wEq2PBfxlPsjDyvZLc/DVScWab6wTk4gA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dC0OISYM; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730798435; x=1762334435;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FRhqq0KVfcJEkAcrYK8kA2VbUA1Lnd/ValQGJQ5d1+w=;
  b=dC0OISYMMFvReXVb7F1KXF0uhHcK+b4wOGug3EQOgFoBCgIN9ruxUFV5
   qCefbEMxNuEafvawkbUEPP4PIzCj5/ZVIt+dsv8FMparRrbbAQZCkcZxF
   OLtNu8K7w4D8na6xRz2/8BwW4DCEQZo0OX2J5SRqCGN3PtOrS7u4SBOih
   yEjURmHGTQjBvO7p6qZPz5zzZlaf5YBq08tXiEtpF+6xF7i4ceMOV5WP3
   aulGVq3vi8QQStpfzRgMd1QLbgwkinSxely3oq0qRIkx2GkTdOziYz7ei
   71WX7+NAUiaiXoNztbdbOKnDsdRWeRHh7AhllPKBwQ2KM1nk8FaudZkoK
   Q==;
X-CSE-ConnectionGUID: fOd4/cwsSU+8zuvT4v8BIg==
X-CSE-MsgGUID: 1cI7GjJqRdaK8ExztbavMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="34221350"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="34221350"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 01:20:35 -0800
X-CSE-ConnectionGUID: 6g4EZFJDRjyXK7OngAawtg==
X-CSE-MsgGUID: GjF1vRI6TU+JcXBNlp8KBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83601969"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 01:20:34 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 01:20:34 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 01:20:34 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 01:20:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZBaykGw7NMWCS+bVCDzpMVw5kIYyVuMkvbOwwX63Y46568+ZH82MprsHMT2G62Dw7kzoW+wycs1wZmKVduHiEFaUPoeZ6xO71lhfPI4VNTocBFOpaOqWClJbPoF45ywhvdTgLztWBkzs/hCOWC4YGhU0N5Ix5fB6xystUko73vhEaewzRe2IGBPZrqktYYarJi+up6QRfBMFhBfnTydEwbb7CAft4pS2rGGOxdT7HEivLS+h3Y2CXTwKFrRJkj5jgDmAwUI1M9uScofQ9uNjjBHh5S5ah45g2r3RHQSloxwAREEd2pFZr/rL7CMVu2xmqCo69Rr1jnfc0Ro0YkrCxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRhqq0KVfcJEkAcrYK8kA2VbUA1Lnd/ValQGJQ5d1+w=;
 b=LMZPjSP4sRKlc4CDRRQK2cwoxF1jJEZCXSe5rOEPDlUrdMYxNmkv07x0V7pZoejCfBCocv/cO0YJ4P8dYlgiQllhLJ8W99tpQ7Cujs7c/RjjJjvpSwIaCOt2KSxuF+rYPF2MuRMdDoExrMN9+dKEIVre89YMIGwuCM/gRQMa6o5qRyEHHAlgAZp49Xd3XC8wKGr9ds1m/N0sbzNKUttRiavDHgZcj9+s480EPXQ7Ek+nfkZr+4mNYP5wEYEqjTFugbUtsgvukkSoVzML69MB5ftPCCmEcSYmltDA0gUahDxTemZNxUaUmzda14z8zThkrtkMxSKisFAHmgDiT9wROA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB7473.namprd11.prod.outlook.com (2603:10b6:a03:4d2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 09:20:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 09:20:31 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "yuan.yao@linux.intel.com"
	<yuan.yao@linux.intel.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Thread-Topic: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Thread-Index: AQHa916mLjHQn3A27kaE3wVAzihpyrKgK5iAgABDH4CAAOwxgIABUlWAgABdLwCABDPdAIAAEjwAgAEWjQCAAHIYAA==
Date: Tue, 5 Nov 2024 09:20:31 +0000
Message-ID: <662b4aa037bfd5e8f3653a833b460f18636e2bc1.camel@intel.com>
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
	 <20240826022255.361406-2-binbin.wu@linux.intel.com>
	 <ZyKbxTWBZUdqRvca@google.com>
	 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
	 <ZyLWMGcgj76YizSw@google.com>
	 <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
	 <ZyUEMLoy6U3L4E8v@google.com>
	 <f95cd8c6-af5c-4d8f-99a8-16d0ec56d9a4@linux.intel.com>
	 <95c92ff265cfa48f5459009d48a161e5cbe7ab3d.camel@intel.com>
	 <ZymDgtd3VquVwsn_@google.com>
In-Reply-To: <ZymDgtd3VquVwsn_@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ2PR11MB7473:EE_
x-ms-office365-filtering-correlation-id: 14d716b6-5052-4c49-fd2c-08dcfd7b186b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?R2s4RkFlRnVEbXFVempPa01aMkhadFlhR01BSkVwekVtU3dIVnkxc1liOC9r?=
 =?utf-8?B?a21ETFlxaXMyNVZ6dEEvellWMEQ3Qnc5T0JPRlZFZFNidUVKMjdPMXY5NWpR?=
 =?utf-8?B?NElxS2RuSUxHbzNZMzZnN0srV2JZRjhTZnlpN0hzNHg0UHBod01WcEJWREZE?=
 =?utf-8?B?SzBOeXNFT0ZxSkR3aEYvaWwrZzE3TGtpeGZqMTN0dkxBeDhrUlF0Znl1Zk9X?=
 =?utf-8?B?Zml6SWt0M0NpbkxHbmNyVC9rOGhLRFhwamdINk9vKy9ub0hhRlhvaE1NNW9P?=
 =?utf-8?B?VWh6aTMzQjdmS094WVZ3OFBsNmNYWVJhajlBcmJ2Wm51VVBWZG8wd3dncWFy?=
 =?utf-8?B?WnppalUraTdjN1gvelBycDdzdWh2RGlHa0tFTmF2VXhDRTJyRzJZV3cxd3di?=
 =?utf-8?B?d2szaUk2anBreGh1ZWhkc3hEQnhDcUlQNHRXL242L0Z5QnFsOXg2T3RzcGFZ?=
 =?utf-8?B?SjZRaWhCdjZkOElvcmxNSkFXOTZ2ZnBZWW5aSzRaL3hOdmZQTmJtcWNBQWdG?=
 =?utf-8?B?YmN3MGJHMHpVamdZNW16UEVSQ2hZendsRWs0TG1EcU9IWXR3Mm1OZUVoS0E1?=
 =?utf-8?B?TzFhb3ZtM1JxS0lwcmR2UmRsQjVpU0lIM2Y5M04zRGpFKzVaSHFSckNPajhB?=
 =?utf-8?B?TUVwVWs5dUt3RytzSEFPeTVoanNuRTRZcjllT1JVa2VzRHNKWWFrWS9WTVRl?=
 =?utf-8?B?NHRBa0RtWmFaQW8vSFhpQkdXQ2VHMHQyb1laTDFFRzFSSTlrdVBoTFNIS0RZ?=
 =?utf-8?B?c0p6K1hhNW90RTlYSDBpYVNJcnJnSlQ2RmtyeWhabHZGVHRrYm5vbnlTV3Br?=
 =?utf-8?B?dTdDZE1UcitsemcvZzhLVjh5R09FeHFLTmd6c0hGN2JJejA0ZU9YYjhuYmdq?=
 =?utf-8?B?S3RWSzU0ckY2ZmduK3plK29OeCs4SDdZWWtlVklOWm82U0JRdHhuK0VLbTBy?=
 =?utf-8?B?NGFOYWlGWHpodjZpNXlhMEFUaXZLNTkyYUE0Z05vRmkzeHBnckRRdE5jVCs3?=
 =?utf-8?B?U0NubXNYWk12dWtNV0ZsWUt1VjlQbE5qZFkwckx5bkFZQ2p4dkF0a0tWSDRJ?=
 =?utf-8?B?dGpkUVBmd1Q1SmdSWENWRkNGL1ptL0lMT0lQMXhSK2pjYkJRWWlSMS9RVFR3?=
 =?utf-8?B?amY1UFFibzZPYUE5eDFKeXBqTGdWc1RlTzIzZGxjMmtTVEdDNTVQeUk4d3hI?=
 =?utf-8?B?TEQ1b1dQb3RmcU9ydlM0dmZtRDIvZ2xYVmhuejZUM09iSU03U1BubFgzbXQx?=
 =?utf-8?B?am1BZWxuZG1aVHRRRk0wV1B2M1oxQjluTUcrVnoyY3d2YjJRaUp3NUVyeDJ4?=
 =?utf-8?B?c000QTM0SDFXNC9lWklnRXBnaWhtMTdWdU1DamJKVFNZV25Hc052TjlJeGVI?=
 =?utf-8?B?NHRvR0FGMDBjMittTnVEUUZIMUg3TEhWemJ5N3FMR05EdXdJOHFqbnhSdC9D?=
 =?utf-8?B?eTU3OGhWOGhQayt5UkluMmhXV21oR2FUVmhpVUN6K2JqSzB3aFJrMDVuSllW?=
 =?utf-8?B?NWtaVG10WkJFaWJiVGhnbC9HTUJUSUVpVUt3WC9SNUY5cTZxeDgzWHB5QUU5?=
 =?utf-8?B?RHoreXpKV2M4NlFHSGphVVVSWm1nU0VQT3o4eEhIZDNFQ3ZWcENENGNBTzBZ?=
 =?utf-8?B?K2dYa3N3ZDYyZVgzL2xyMlVKUmhwSWtZaHJ5SmpKU1RHL3BoV2dneFRrazR3?=
 =?utf-8?B?WlRqWklIVVE0YjFXYXlzeTNNbWkyL08rd0NqZm1Lb2RJYlpwRUo1TWhzY3hY?=
 =?utf-8?B?a1pudHFyTGFVS1liVzQycjZpZzRPS0VUODZSYlVQZHYyVDVDM2tOU2JlZ1N2?=
 =?utf-8?Q?cuhnp7E3TG0XT5n2ZYpjyzKK5aX8ujanvEJqc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFFGcTRFQzdMUzhxS3NBOThKUmRreUF0T2NvSHQ4OXBXSDU5UXRsR1R4L1M1?=
 =?utf-8?B?UmsyRWtMOStCb0dCcmVBQVE4VXhhSUs1UHRIYlA0bDhlL3UydGJ3NlNjN1FL?=
 =?utf-8?B?QlZiY0x4S3FmL0tRc3BsaFdQWTByKzVuRnpEUDJHdlVOODlOQkt1MEtOSVFu?=
 =?utf-8?B?cGpZQXdRSk5zR21HLzREeCtIZHpib0Q2SEFJa3l1cndvQXlEL0FDbHVNcDZs?=
 =?utf-8?B?ZTd3dmlVcVRlRGhsWm83ZHk4bnRQQmptWkFta1ZwcDhwRW1TRTdqR2xuT2dC?=
 =?utf-8?B?RE5jNFpMb1JtS3hFRU1WaDU4T0NPRzVFYTB1Wm05UHpkRWJVUTJILzRRcXZY?=
 =?utf-8?B?eUxuL2VtSDBPN2NGUmVwZ3U1YStxeVhtU3ZHWllNSU5rcnBRZmdFK3VTSmNY?=
 =?utf-8?B?N0lJeWRqWWN2OVFDMWFLQ3Nhc29kcG5DeDR3MjZMaEU0NWNOQXZBY1c0NW1r?=
 =?utf-8?B?NjdGMDFCMzVyRllwWm9pVGR3dzlYaGJxRlBNQSt1eWZmTnJtS3QrdzVsNkJB?=
 =?utf-8?B?UVBvZVZtVGRucU9nVzNudnZlRm1zNnpsSHZCMmJsQ3d2ZXZSdUlnRC9YN2ph?=
 =?utf-8?B?dXJhbTUwYzlyeTAwSXRrc29tRmNWd3g5eEZWQkk2MUpMaE02Y09rdGxVRThP?=
 =?utf-8?B?QjlsYmd6MkZlZkszNVhVSkpkQUFZWXU0czdFdk1KbTNiMWhRTjV2QjRjcHJO?=
 =?utf-8?B?VzZtdVdjMnlnaXgzeVBGY3pqL2VCMXh4c3Y4bCtuODh1QkUzWjZFa2kwVXhG?=
 =?utf-8?B?ZkcxTkwwQkxMZmMySWRZaTRvbkpwM1dUbWRLT3BMUnpmdGJxSTUydnZqdHFi?=
 =?utf-8?B?OGwwMjJNZ3UxenB4VzM4bmJ2NWRjRjJhcjhmblR4cDZqNHhoZVpucWFEeHJC?=
 =?utf-8?B?MG4vYXhRYWlRMndhYkl2WHJuZ0NDOURrMTRPbStvUTJFVU9ELytQRjQ0TXhF?=
 =?utf-8?B?c3ZGNWVUZGhnaWVaWG5CeDRtMXVLTkwrZXhYdVMrbkRYSmF1eHdOSTMwTVcz?=
 =?utf-8?B?UUNwejFkWE9jeUlIcGdZTUd2NlEyN3R5MFBmOE41dFJEUDJIdDU4VUI5aHpy?=
 =?utf-8?B?UHdzOFRudFJnblNhTElNZ25YQjRtY1Y1SHJnbjNFTjQ4M1RNUG5GNGhTYTVh?=
 =?utf-8?B?enRJOWkzRWtBaXlNQUNJZkZjQ2laVGdxRHNMbWZndzl4RkJwRi9URG9LTWFy?=
 =?utf-8?B?SjE2bEZMWVd3eHNvRTBheGFFUVRGdWVzUXkyUE1wY2tDR0F1RU55UGQ4T2VW?=
 =?utf-8?B?aFF0VjRoNWpXQ3VqcGlUUmNmL3RVYnhHNE0yb2FMcVhobEk3aE1uSUtxc2cy?=
 =?utf-8?B?YXI2a01jSHlSRE16S3RmOVo1UGpjZU5ydHcyUENEWWp3bGl6alo2ajZUVlJR?=
 =?utf-8?B?dHFtNEx4VnY4ODBSUDZxNUpEbWZYOHZaaFhUbE5RWlkrSjA4ZytzVHpWRnNP?=
 =?utf-8?B?cXFQWlVDcXlkRzMyM1F2UEY2emNERS9xWnVzRWZuRklaVGlXQTlPMWFnaVNR?=
 =?utf-8?B?ejhDeE82Vlp6b3Zpa3Y2SUQ4TGxpMFpPcUxWWklQMkJkQ29Jc2JaaWg1blpq?=
 =?utf-8?B?clFzK3hEMHR1U3dVS2cyTktyN3pFS2Y4V25LWE1hVkFjWGk2V2xHbEVKSGRm?=
 =?utf-8?B?VGRxWC90REx5S25nc2E4dFJTVkg5UDBRSEJvVExNQk1JR2txS1l3QzE5T2kx?=
 =?utf-8?B?MjNYUmZTTm1QZXkwOEdvamxzbk9QbmpTczFROExaQmZqakIwY2xsTGlFZzZo?=
 =?utf-8?B?SHZZV00rcHdJdmpEanpldHd5Y1ZiMkcwWFBzZjVyUlVtNUNPdEZRdnE1Yllu?=
 =?utf-8?B?eWk1UTd0U2ppSFRGRlYrdnJUS1VMQUgwK2EwNVVrRXdld3J4a3VxblR0a0dT?=
 =?utf-8?B?ZzAxT1lKUHZ6OW5aYlF3K1dmNGhRRFNodnVMb1NaRE0zOUl6WGhpazdPREsv?=
 =?utf-8?B?YWNaYVk4WlpDNzRxWjFWMGhIY25GWUlxVTA0Z2hHckY2ZGovQ2NHSEE1NjVZ?=
 =?utf-8?B?M29MNm00Q2NhTUpDcEY2SHBuSUlXb1dBNHNsdGNPYkN3ODF1bXRtN0drZU85?=
 =?utf-8?B?WmE2K3BuV0tPTjdIWlQrRDBsVjNVVzVrb2tnVyt6VmZ1YjVtQjFVelV0NC9l?=
 =?utf-8?Q?gvT2jr3/61qkz464R3MsuAQ6S?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B10B20AB633D124BB57B18F7E909BC0E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d716b6-5052-4c49-fd2c-08dcfd7b186b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2024 09:20:31.1858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SAMMxUxW9e83MjnaUafBmJgCji7F2CyxzhievnEMBNresJVvJhfUXIykQMAQ9SigZJfDUWnZYnlfnwgsVrxRYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7473
X-OriginatorOrg: intel.com

PiA+IA0KPiANCj4gSSB0aGluayBJIHByZWZlciBCaW5iaW4ncyB2ZXJzaW9uLCBhcyBpdCBmb3Jj
ZXMgdGhlIGNhbGxlciB0byBwcm92aWRlIGN1aSgpLCBpLmUuDQo+IG1ha2VzIGl0IGhhcmRlciBL
Vk0gdG8gZmFpbCB0byBoYW5kbGUgdGhlIGJhY2tlbmQgb2YgdGhlIGh5cGVyY2FsbC4NCg0KRmlu
ZSB0byBtZS4NCg0KWy4uLl0NCg0KPiANCj4gVGhlIG9uZSB0aGluZyBJIGRvbid0IGxvdmUgYWJv
dXQgcHJvdmlkaW5nIGEgc2VwYXJhdGUgY3VpKCkgaXMgdGhhdCBpdCBtZWFucw0KPiBkdXBsaWNh
dGluZyB0aGUgZ3V0cyBvZiB0aGUgY29tcGxldGlvbiBoZWxwZXIuICBIYSEgIEJ1dCB3ZSBjYW4g
YXZvaWQgdGhhdCBieQ0KPiBhZGRpbmcgYW5vdGhlciBtYWNybyAodW50ZXN0ZWQpLg0KPiANCj4g
TW9yZSBtYWNyb3MvaGVscGVycyBpcyBhIGJpdCB1Z2x5IHRvbywgYnV0IEkgbGlrZSB0aGUgc3lt
bWV0cnksIGFuZCBpdCB3aWxsDQo+IGRlZmluaXRlbHkgYmUgZWFzaWVyIHRvIG1haW50YWluLiAg
RS5nLiBpZiB0aGUgY29tcGxldGlvbiBwaGFzZSBuZWVkcyB0byBwaXZvdA0KPiBvbiB0aGUgZXhh
Y3QgaHlwZXJjYWxsLCB0aGVuIHdlIGNhbiB1cGRhdGUgY29tbW9uIGNvZGUgYW5kIGRvbid0IG5l
ZWQgdG8gcmVtZW1iZXINCj4gdG8gZ28gdXBkYXRlIFREWCB0b28uDQo+IA0KPiBJZiBubyBvbmUg
b2JqZWN0cyBhbmQvb3IgaGFzIGEgYmV0dGVyIGlkZWEsIEknbGwgc3BsaWNlIHRvZ2V0aGVyIEJp
bmJpbidzIHBhdGNoDQo+IHdpdGggdGhpcyBibG9iLCBhbmQgcG9zdCBhIHNlcmllcyB0b21vcnJv
dy4NCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIGIv
YXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiBpbmRleCA4ZThjYTZkYWIyYjIuLjBi
MGZhOTE3NDAwMCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3Qu
aA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+IEBAIC0yMTc5LDYg
KzIxNzksMTYgQEAgc3RhdGljIGlubGluZSB2b2lkIGt2bV9jbGVhcl9hcGljdl9pbmhpYml0KHN0
cnVjdCBrdm0gKmt2bSwNCj4gICAgICAgICBrdm1fc2V0X29yX2NsZWFyX2FwaWN2X2luaGliaXQo
a3ZtLCByZWFzb24sIGZhbHNlKTsNCj4gIH0NCj4gIA0KPiArI2RlZmluZSBrdm1fY29tcGxldGVf
aHlwZXJjYWxsX2V4aXQodmNwdSwgcmV0X3JlZykgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IFwNCj4gK2RvIHsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ICsgICAgICAgdTY0IHJldCA9ICh2Y3B1
KS0+cnVuLT5oeXBlcmNhbGwucmV0OyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
XA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gKyAgICAgICBpZiAoIWlzXzY0X2JpdF9t
b2RlKHZjcHUpKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBc
DQo+ICsgICAgICAgICAgICAgICByZXQgPSAodTMyKXJldDsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiArICAgICAgIGt2bV8jI3JldF9yZWcjI193
cml0ZSh2Y3B1LCByZXQpOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwN
Cj4gKyAgICAgICArKyh2Y3B1KS0+c3RhdC5oeXBlcmNhbGxzOyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ICt9IHdoaWxlICgwKQ0KPiArDQo+ICBpbnQg
X19fX2t2bV9lbXVsYXRlX2h5cGVyY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHVuc2lnbmVk
IGxvbmcgbnIsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcg
YTAsIHVuc2lnbmVkIGxvbmcgYTEsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVu
c2lnbmVkIGxvbmcgYTIsIHVuc2lnbmVkIGxvbmcgYTMsDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gaW5kZXggNDI1YTMwMTkxMWE2Li5h
ZWM3OWUxMzJkM2IgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0KPiArKysgYi9h
cmNoL3g4Ni9rdm0veDg2LmMNCj4gQEAgLTk5ODksMTIgKzk5ODksOCBAQCBzdGF0aWMgdm9pZCBr
dm1fc2NoZWRfeWllbGQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1bnNpZ25lZCBsb25nIGRlc3Rf
aWQpDQo+ICANCj4gIHN0YXRpYyBpbnQgY29tcGxldGVfaHlwZXJjYWxsX2V4aXQoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1KQ0KPiAgew0KPiAtICAgICAgIHU2NCByZXQgPSB2Y3B1LT5ydW4tPmh5cGVy
Y2FsbC5yZXQ7DQo+ICsgICAgICAga3ZtX2NvbXBsZXRlX2h5cGVyY2FsbF9leGl0KHZjcHUsIHJh
eCk7DQo+ICANCj4gLSAgICAgICBpZiAoIWlzXzY0X2JpdF9tb2RlKHZjcHUpKQ0KPiAtICAgICAg
ICAgICAgICAgcmV0ID0gKHUzMilyZXQ7DQo+IC0gICAgICAga3ZtX3JheF93cml0ZSh2Y3B1LCBy
ZXQpOw0KPiAtICAgICAgICsrdmNwdS0+c3RhdC5oeXBlcmNhbGxzOw0KPiAgICAgICAgIHJldHVy
biBrdm1fc2tpcF9lbXVsYXRlZF9pbnN0cnVjdGlvbih2Y3B1KTsNCj4gIH0NCj4gIA0KDQpJIHRo
aW5rIHRoZXJlJ3Mgb25lIGlzc3VlIGhlcmU6DQoNCkkgYXNzdW1lIG1hY3JvIGt2bV9jb21wbGV0
ZV9oeXBlcmNhbGxfZXhpdCh2Y3B1LCByZXRfcmVnKSB3aWxsIGFsc28gYmUgdXNlZCBieQ0KVERY
LiAgVGhlIGlzc3VlIGlzIGl0IGNhbGxzICFpc182NF9iaXRfbW9kZSh2Y3B1KSwgd2hpY2ggaGFz
IGJlbG93IFdBUk4oKToNCg0KICAgICAgICBXQVJOX09OX09OQ0UodmNwdS0+YXJjaC5ndWVzdF9z
dGF0ZV9wcm90ZWN0ZWQpOyAgICAgDQoNClNvIElJVUMgVERYIHdpbGwgaGl0IHRoaXMuDQoNCkJ0
dywgd2UgaGF2ZSBiZWxvdyAoa2luZGEpIGR1cGxpY2F0ZWQgY29kZSBpbiBfX19fa3ZtX2VtdWxh
dGVfaHlwZXJjYWxsKCkgdG9vOg0KDQoJKyt2Y3B1LT5zdGF0Lmh5cGVyY2FsbHM7ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgaWYgKCFvcF82NF9i
aXQpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICANCiAgICAgICAgICAgICAgICByZXQgPSAodTMyKXJldDsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIA0KICAgICAgICBrdm1fcmVnaXN0ZXJfd3JpdGVfcmF3KHZjcHUsIHJl
dF9yZWcsIHJldCk7ICAgICDCoA0KDQpJZiB3ZSBhZGQgYSBoZWxwZXIgdG8gZG8gYWJvdmUsIGUu
Zy4sDQoNCnN0YXRpYyB2b2lkIGt2bV9jb21wbGV0ZV9oeXBlcmNhbGxfZXhpdChzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsIGludCByZXRfcmVnLMKgDQoJCQkJICAgICAgICB1bnNpZ25lZCBsb25nIHJl
dCwgYm9vbCBvcF82NF9iaXQpDQp7DQoJaWYgKCFvcF82NF9iaXQpDQoJCXJldCA9ICh1MzIpcmV0
Ow0KCWt2bV9yZWdpc3Rlcl93cml0ZV9yYXcodmNwdSwgcmV0X3JlZywgcmV0KTsNCgkrK3ZjcHUt
PnN0YXQuaHlwZXJjYWxsczsNCn0NCg0KVGhlbiB3ZSBjYW4gaGF2ZQ0KDQpzdGF0aWMgaW50IGNv
bXBsZXRlX2h5cGVyY2FsbF9leGl0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCnsNCglrdm1fY29t
cGxldGVfaHlwZXJjYWxsX2V4aXQodmNwdSwgVkNQVV9SRUdTX1JBWCwNCgkJdmNwdS0+cnVuLT5o
eXBlcmNhbGwucmV0LCBpc182NF9iaXRfbW9kZSh2Y3B1KSk7DQoNCglyZXR1cm4ga3ZtX3NraXBf
ZW11bGF0ZWRfaW5zdHJ1Y3Rpb24odmNwdSk7DQp9DQoNClREWCB2ZXJzaW9uIGNhbiB1c2U6DQoN
Cglrdm1fY29tcGxldGVfaHlwZXJjYWxsX2V4aXQodmNwdSwgVkNQVV9SRUdTX1IxMCwNCgkJdmNw
dS0+cnVuLT5oeXBlcmNhbGwucmV0LCB0cnVlKTsNCg0KQW5kIF9fX19rdm1fZW11bGF0ZV9oeXBl
cmNhbGwoKSBjYW4gYmU6DQoNCnN0YXRpYyBpbnQgX19fX2t2bV9lbXVsYXRlX2h5cGVyY2FsbCh2
Y3B1LCAuLi4pDQp7DQoJLi4uDQpvdXQ6DQoJa3ZtX2NvbXBsZXRlX2h5cGVyY2FsbF9leGl0KHZj
cHUsIHJldF9yZWcsIHJldCwgb3BfNjRfYml0KTsNCglyZXR1cm4gMTsNCn0NCg0K

