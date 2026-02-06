Return-Path: <kvm+bounces-70524-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UHkdGSB3hmn/NQQAu9opvQ
	(envelope-from <kvm+bounces-70524-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 00:20:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AB9E01041FD
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 00:19:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AE2EC30135C7
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 23:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B5B13112D2;
	Fri,  6 Feb 2026 23:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dkt35HDw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030473090E5;
	Fri,  6 Feb 2026 23:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770419992; cv=fail; b=Fcuup+1OBwy4jjWCNSAKj4Brmu5/kurvVH2DE4lV6/W4TZwC2qQUTC7YyJanNtz2JnUcONNsPcWvnOIoUSoiw53cw+HfzMPZhtZIGcvv+P/wqEdvKNbwkLUQnzOXKYbwgEwky8wxdFOB7KAmI4XncQX4v0bARbe9VG3m1PRGzdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770419992; c=relaxed/simple;
	bh=hCjNcNZIdmOFZhYQCT9qohgI+8dnqGXVGWAJRK8WLhU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pUfmp25/5AIHJTm7f5TnHVqsdapZNPqIEP16J/Ugx9muUEOxc4qe6dLcgDEFeLtknzmy8wyYH/U8Z6wU0X1vXWc71If9nfMIvHykzgNPyyxZTJMpcq/pmCxsnkrgfcyKikxcnkPT0vx1V1p1noTnAO64tGelLTsvtOdn6pp2uRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dkt35HDw; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770419992; x=1801955992;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hCjNcNZIdmOFZhYQCT9qohgI+8dnqGXVGWAJRK8WLhU=;
  b=Dkt35HDwKSCE/AaNsHYPm78T2ewXpycA+5YG+/RBI30Duk4LjrrLCY7W
   +OM+6Ty5la43Wx/YXNiNxsGDsIwm7XRUqly8BCnT54hNKfJ9i78YbSmV4
   BLx2Xx2unRAFxeeN9fBqUCLNMb8V4+yJYFw4QQoxpg/whA5KOfDd1hODs
   hz+fhchsNVIvBWsp1dP8SBVE0yVpffvvP2aytF0MiHZyAFOYJKM7d0qbZ
   k0CKqzRGcDuWFhBg+5vTXGryNswb/srCI1zV2AdEjq/OZZ6l53DBA2G25
   JWRjSUTXvWoKgkgAtmHCssCLsoyusXgqK/OZTbnjrb2bH+3kxkQYp7cKE
   Q==;
X-CSE-ConnectionGUID: x0+RR88+RBSrfzCbpysqyA==
X-CSE-MsgGUID: vK0rZhjbQOi4anjYX0EnzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="82267527"
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="82267527"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 15:19:51 -0800
X-CSE-ConnectionGUID: 510zvekPQG+5dnKNbjn2LA==
X-CSE-MsgGUID: zicvj0RrRIurVgKdtdoqqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="210295553"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 15:19:51 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 15:19:50 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 6 Feb 2026 15:19:50 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.45) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 15:19:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QEYc0Y6r+IkfyifjCWJ39rkijMWod0VgMNRB2MNDbPDpzjxIsoDXCn477sO6CBOq1Mn34Tx59G2Y2OUGWmV3BJmgmQUccrNhQJU8IWOe3v1AYoBZ95a7uSte5xWnwKkquU4rV7oRTiLaxRidcxxr2GpXFBdixUMaHWv1xxVowfw8ScF//oiF3YMTUHrPQp9r9Mj5d3Jdd6tSR2GTg+r8iui/KrUv1muelbKvMRSckEY7ktq1bHSIDpr8lBQ9viSOMvE3sN2blupJu5zEndr25mmZOC34ag2oOBRXmDT9BxztnHYFJLzr/rmnmi2+45zsLeSi69A0Q05rrCULCDJfGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hCjNcNZIdmOFZhYQCT9qohgI+8dnqGXVGWAJRK8WLhU=;
 b=V57Hk7gcsypr58eItHtX8D09bqQ1B4IRo9iNgnseC1lLVfcFaTRHG8+ojCPlVumANRK/l9lkFFBalk4hZWssPL5gFc54EIQ/2HVGjjUPxns5ES1gxiYU+yTdpOytlVTAdmPYlq7BTqUzfdsyjEFyXpTfm2JciE6Nb3W3j1TZrwP+uA3nUlNr505WLZE6EruS81WKQznOd3A8Ao8hOxYRMv87PhDdNkfWroR1xmc25QqDGFRii3aE6Tyv5VKizVQ+wYogmj8gTfXmZTi9m1PtbieFKPbQktgiPXnhe5SGvleCe51CjxAYDQET1ionWVCUm6de2lrYBxuC85WhIk6EZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB9500.namprd11.prod.outlook.com (2603:10b6:8:258::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Fri, 6 Feb
 2026 23:19:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 23:19:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"sagis@google.com" <sagis@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"Annapurve, Vishal" <vannapurve@google.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [RFC PATCH v5 22/45] KVM: TDX: Get/put PAMT pages when
 (un)mapping private memory
Thread-Topic: [RFC PATCH v5 22/45] KVM: TDX: Get/put PAMT pages when
 (un)mapping private memory
Thread-Index: AQHckLzwCgvmuzjovk6gFrXf+s6dG7V1gv0AgABf7oCAADjnAIAAQGCAgAAAf4A=
Date: Fri, 6 Feb 2026 23:19:47 +0000
Message-ID: <b1a26b58eb01fc2d3c166cae91e23ea7631bda1e.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-23-seanjc@google.com>
	 <aYXAdJV8rvWn4EQf@yzhao56-desk.sh.intel.com> <aYYQ7Vx95ZrsqwCv@google.com>
	 <b3ad6d9cce83681f548b35881ebad0c5bb4fed23.camel@intel.com>
	 <aYZ2qft-akOYwkOk@google.com>
In-Reply-To: <aYZ2qft-akOYwkOk@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB9500:EE_
x-ms-office365-filtering-correlation-id: 2f530ec7-604a-4286-8ee7-08de65d63874
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?d1lINUxmMmJoWmtKYXExeXJWbFkwYnVISWx4TGxCK05WcHNHMXFqZjRZanlk?=
 =?utf-8?B?S1lBaGFGaFl6dlhWZ241b1RkUXI0alJ6NnAya2pqTHRDajEvaW0xTWc0a2kv?=
 =?utf-8?B?Y1dyMndFQmFNTHFnd0ROUTVQaUVHWDU3bGQ4SmoyQVlRaGZPZWo4dG1CeThu?=
 =?utf-8?B?SklOS3RkWDBRYWhXQ1JzaXNURFQxSDRLU1huVURTdDI3VU9NVnVRL1ZuNnhs?=
 =?utf-8?B?cTRPNENoSmZqUzErck1GWWVCS0Z3RGtSTThOcWNIZ3h6bDFVTmxuY3oxdytp?=
 =?utf-8?B?RTlGL2JxbFV4NWp5cjJNalB3eldtaERQdUNCNDR6T0lwZ0tvZndDNHRVdFdU?=
 =?utf-8?B?bnVVU3FCSkpkSnJHYnBoRkFzYTNPMFBoYmptYmd6RFczY0dPb0FYNWlpYlNL?=
 =?utf-8?B?Um4wY3krSU9CSXozUVR5NXFyeHhhTGhZczVJYWV1R2VEamtFalN1bzFETWVO?=
 =?utf-8?B?c1YrektHK2s2bFE5eWpReGFSQTFjRnhDak5yZnN6T3lUZ0hiZFZ3YTNvNUNu?=
 =?utf-8?B?NUpmKy8xNERoZ0Z2VnUwTkFpTnRDTTB3RDdleWRNOUVNbkRndjI3ZGYrL3Fm?=
 =?utf-8?B?ZTV1bnphOTVPeWtGRVVqN0tVcTdWS3hqYXdUTnFYREh0bTQxT1NXZWpkdldx?=
 =?utf-8?B?RnlzNXhVUmJuUVpKMGhRaExlSzJSQUpMa3R5M2c5UjhlQU5teHJZaGNCeFlx?=
 =?utf-8?B?MzNBNWNSd01nd3J4ajMzT3RDcWZHOFR4bDhXT1o3Nm9RQ29qMTFCSFZJUUU5?=
 =?utf-8?B?Y2FpeHJJOFRrNER6VEQ3UzJoZFhuWnVWNW1lZ3lhckViQmRqakk5dzNhb05F?=
 =?utf-8?B?aW02UnRqTGZKMndzRUZIQ2krUjlSdFNHN1ZOYlF2d1VjVlJBcFJkajNvMU1o?=
 =?utf-8?B?aytteWNPWFdzeGdsdURUdmdmekFkVlpNL0daazYxRjJnSVhiNzVlTXN5ZEFl?=
 =?utf-8?B?ZU5PUTc1azZZK3FDN3phaFdUUlRUWU9kbmE3N0Z6cEdDMTMzNkdRQ1Z6TEE5?=
 =?utf-8?B?dGdnR2ovdDQ3cmR6QmNRbUJ6RE5nNTlYN3MrUE1xSmJ1MXY2OTRsZG1Md3pl?=
 =?utf-8?B?Z3dGSm56WkJFWjdzTW55VUs4TWR3R0FxeGw4eWNOZkMvNi9wa1drcksvdStH?=
 =?utf-8?B?elI1NHJOdndlemFMOW8yRHlReXdBQTgzZjZmVlRKRng2dDV0MVRRdG9OeWda?=
 =?utf-8?B?QmZ6RC9IbGFya29qRm9rSC8xZWdoRlJ3ME9KUXNDejZaR2ordWVhZUZZZE5y?=
 =?utf-8?B?bDNiWVkwRGkxQjlaWFRJR2pXTS81M1NKZHduS3JvK1hKbTgxR3JxWGxTOCtz?=
 =?utf-8?B?clZ4QjMxVS9UdFJNQTdlS2xRQzl2REQvZ1pCOVNaRTh1RzM2eFdpQTZDaHNo?=
 =?utf-8?B?Ty82ajdnOFFDM1ozZ1lyUkdnVjZCeVZEWFhCYnoxSlV1eFFPRTJaeTAwME1p?=
 =?utf-8?B?TDB5VmE5b20yQndKOVc5ZGNLNGRPYnRmZGV2TWkrMEE4V2dFRTRud3h0TitK?=
 =?utf-8?B?V24xWEhaQWhScmIydFpUdDkzeDdVSzlFWHQ4Ty9xalNsaVhLZE9mYThxMnFQ?=
 =?utf-8?B?TlVlK0lvUjNRWnhnWk03YXBxNUVBOXNmOFVIUklORWQrMzZtT201bUNxK1ho?=
 =?utf-8?B?bGo5eFo2aVlSM09md3dKUmFRR3AzbUlDZFF5dkxSZGcvRGxHVkxWTE5zL2Ru?=
 =?utf-8?B?akFQTCtMYzRRR3RnTGxDRklsaTdpVVBiaVVWSXh2eGJlUFJPZFFpa3ZNSXRz?=
 =?utf-8?B?eGlNTHFqRFU0aU50VVk1T2RFYkpoWjdVdXNKQll4UTh2Z2dxaTNkM1JQVG5B?=
 =?utf-8?B?SmduQ0wvRlJ3QkJKaStHbVhrUzB2VTZSUmVFQTk0ZDV6aHU1VXpKUzlPRzNm?=
 =?utf-8?B?NzREVStlWUwzM1pONkxyczgrQWc5QTVlQnRDd2RXMlFkV3I5YSt4Qkk3RDhH?=
 =?utf-8?B?YUY1aS90d09NOElkcUNLN21wOHZaU3BYeUZxR0NvZDMwVXZwalQrbkZrT2ht?=
 =?utf-8?B?LzErQ0U3R3g0b013L21yM1lNNEhFSFRKQXRsRGdtZFVmQ3pYUUFXZ0REU1pJ?=
 =?utf-8?B?NDM5QmdubWlTVmQxdEVia1N2b1NWc1ZBWkhydk8zRFVPYUdqZEFBNURPS0cy?=
 =?utf-8?B?S3Y3TUFaMXdHS1V6bmpBcU9JYlVuc09FRTFjekV6RGNkOUIrbFhXT0pHdTc2?=
 =?utf-8?Q?iIjweX/F5ZXzWCxcwTLrTbg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWQ4bU8wS0Jja2F5VTMvU2pwNXRrWGVsNWQvK21oOGM3UzM2eVFsRHFzcVAr?=
 =?utf-8?B?b08wRGJnNWpJZkVJbk95UkdCb0cwZ050cHE0TFRQQUNRcDNqWERUSkdKeHB2?=
 =?utf-8?B?Qk9tTDRQcXlUN1ZuRFoxYjZBV0JpRHg2UmxBT2sxVUltcW1zSmwra1NHNFJS?=
 =?utf-8?B?bHBQekM2bGd5Q21HeUo1VVByTU4zenBYaVZqeFV0dnNYcjRLS2p6YlVrTzN0?=
 =?utf-8?B?Qm55RjdmRjZvTDZjVW9mSG00L29oS2hGeWVPekU2cXh3MVpKU3VWb21DTStt?=
 =?utf-8?B?RFR5bStQNXRwSDRpK1VQbkhSRDNkcFJjUnJGSWNJRUk5d281OEQ5ekFNbmNx?=
 =?utf-8?B?MGtPbDFJaEM0WjRWaVBBOERBK0l0TDYxS1A4T05RVml5cWhmTko5ak5qUEZx?=
 =?utf-8?B?TDcyaU5KSjFQYkhnVkpKWHF4TGk5amVtSWR1ZytLbTRCNEYxK0pSZVNUQ0Vz?=
 =?utf-8?B?ZkxqQUZDMC9VWnNtU1hybURoN21vQ3prbGEwalB1RTdXbWcyc2hVY1p6b2Zx?=
 =?utf-8?B?OGtaYytYWS9vblZKeE1pRFhUYXN0V0YxdkpsRUxFbURubzdZZFpLZE1FVEFL?=
 =?utf-8?B?Rno3ZkpxM3ptUmgrYkFqeGJvUWVOdmtqaUI3QWs2OHl2WjBXUkxEVlpVcWpu?=
 =?utf-8?B?NXpyVVBNWkFTbFlJSU9udnNQY0JqT2Nic0ZXd3FQL2JtYy95S0d6bWdMS0tu?=
 =?utf-8?B?QnlheVZLNkVHU1Y3STAwaHBzNVJJbVVza1d5Ly9zRmhHYllTQWh1NEs5aTNj?=
 =?utf-8?B?bER0U2hZT2hkT0cvZkN0ajdYZGJDeW5WNytpZ1lsSjRESFZobUphZ1RJaXht?=
 =?utf-8?B?NStudjJUQ3BVVDB5KzVXd1k2NHBSbXRJSFpwbUVvK1FId0ljRjFYZ1NTVWwy?=
 =?utf-8?B?UVNqQ3ZkenUyeElJck5nOTUweEk5bm12VGlTOGRLWUx3S0Z1aUdOTDdLR1Z6?=
 =?utf-8?B?cTNzSUQ4dWxDUVcrQ3BqcC9BYjVmZUo5VkFtMm1wc0lEYUZBUXcxdFAzV3M0?=
 =?utf-8?B?NkF6MzZocXRhWmhVZVRDeHdpaTJNcnRlSVZKTW83dzlHOVhIbEVPNURja1ZW?=
 =?utf-8?B?a0RQeXJkSUhxTFZUdGJTN3hwRDUyd0NiUVhDdVZKdS9Mc2pycWUwUHVtNk4y?=
 =?utf-8?B?dHRKeTFIbENvRzVUQldHbEkvcG5CeVVsY1p4ZTIwSHMxYlBqdjZMVm1EZHhT?=
 =?utf-8?B?cy9ma0dQWisxQ1NiSVBEL3lEUFlVY1U4M3k4NEh3dDBqUmFTUm82N01nNElp?=
 =?utf-8?B?RUFMWkhWYzZRUkpsNFBaZTBmWkxSRlBQWVB3ZlFCVkhPR3J4QnF0TU1zNEVY?=
 =?utf-8?B?QUxHVWZaL2ZCWkhKQ2xtOGdEUzhEbXBQUUtOZ1Q3aFBhcXFlQWRPYjZ6eXpj?=
 =?utf-8?B?dytLQVRuLzR1SjBzdmhJS2NPVFJtSlV6b3BRcFcrU2dacWpiUjNCZGtkWXkz?=
 =?utf-8?B?M1pYeWdWaWpmNkZ4T0JTTVd1a0xjNjJzME1MTFkxN2wydnQ5enVlbGhZeXFO?=
 =?utf-8?B?SnZPZm1OSm9rNGdLdmhBaG9IMEJLYWdYdmxSc09qbjJXMlI3TVI4SzFQMUNi?=
 =?utf-8?B?czVvbkVIdGpWWFlyeTJDclQwRGtsRzVKL0lkWmkzczNQQTVIME9GNjA0dHJR?=
 =?utf-8?B?bGwwTzFUbkRKaEdxbmhic05Ybk90VUVIckUxUXhrU2lEa0loS0QwQ1Q1TVZh?=
 =?utf-8?B?bUpKVEFuN0ZGdE94WFdSeVBQcDg5NGJXZFhra05RUTcrVnpHQmpjUTI4cS9D?=
 =?utf-8?B?QktFSkdBUkppTVlabzZmSHJrbWlONW45blBKRlNsays4MHFPelNRd1g5M1pE?=
 =?utf-8?B?SkdNaVNGVmo0RlVKYXdpdHU1SldVN2JIU204d0tWaW05M1pzelhkWTBZZ0xM?=
 =?utf-8?B?WG9XRE8yZVYyT1BiZlhwejBGZGVmNnZxNGtlR0hma21VOGlHK0pCZ2FONUlu?=
 =?utf-8?B?Rm10YVF1T1d5ZWhaVDNUR2UvM2paTjZMZkVzY0hYT1pnRy92SmNhRjJqV0Jj?=
 =?utf-8?B?MEdiOFBGcW1FTGluZkxQazVNVXRvV2VJdEZ1RDNyNGN6TU9uRWxTNVMvb3FH?=
 =?utf-8?B?b0hRWCtVNWIyQVB2bzFPUGEvdWJxZ2p3MUptVFpPQjdDVGRpL0t6cmxkbFUz?=
 =?utf-8?B?OXI5YVVYNEl0ejdRd1psYkhtM3h4UENlZ01YVTZqbU00WHQ2ZTRqM1dNS0d5?=
 =?utf-8?B?UE9vczBWam8wS0VMSGpPdG5ucjJ6SHJMQ1M3L3ArbHg4ZWdFVGJpTTVLUDE4?=
 =?utf-8?B?cXRGb3F2anZwRHN6WFhrcGErT2dxNUg2Rll5amIrU01LNURZUW9Dc1JOWEF0?=
 =?utf-8?B?eU53RW1KVkx3NTFNMVFhS2ZKbm5qYUc4MGtLSW4vb2NlR2xjUUUzam5lS3p5?=
 =?utf-8?Q?FDHW5KSAb8FjdFN0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB197041D52A9D40B54A5A091ACD1AE6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f530ec7-604a-4286-8ee7-08de65d63874
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2026 23:19:47.7399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M2rxn1qpTp4Ty/9H8IhJKuGGdkj75x0v3FcIRMn3aT1HDx7OuWnHfuN2kvHSL8pXc67q/uxEbaRecYE06SkfUq2RFHcl4wwagaXvyNzlfwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB9500
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70524-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: AB9E01041FD
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAyLTA2IGF0IDE1OjE4IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBIb3cgYWJvdXQ/DQo+IA0KPiDCoCAoKnRvcHVwX3ByaXZhdGVfbWFwcGluZ19jYWNo
ZSkNCj4gDQo+IEJlY2F1c2UgaXQncyBub3QganVzdCAicHJpdmF0ZSBtZW1vcnkiIGl0J3Mgc3Bl
Y2lmaWNhbGx5IHRoZSBtYXBwaW5nLsKgIEUuZy4gZm9yDQo+IHRoZSBodWdlcGFnZSBzcGxpdCBj
YXNlLCB0aGUgcHJpbWFyeSBtZW1vcnkgaXMgYWxyZWFkeSBhc3NpZ25lZCBhbmQgbWFwcGVkIGlu
dG8NCj4gdGhlIGd1ZXN0LCBidXQgYSB0b3B1cCBpcyBzdGlsbCBuZWVkZWQgYmVjYXVzZSBLVk0g
aXMgY3JlYXRpbmcgYSBuZXcvZGlmZmVyZW50DQo+IG1hcHBpbmcuDQoNClN1cmUuDQo=

