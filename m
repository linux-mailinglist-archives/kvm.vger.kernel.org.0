Return-Path: <kvm+bounces-30298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31F239B8FEE
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 12:06:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EAF91C2158B
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 11:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E9D18453E;
	Fri,  1 Nov 2024 11:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QHfDHzs4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA48E14EC62;
	Fri,  1 Nov 2024 11:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730459152; cv=fail; b=uR7BBOjOGzsUv4z6PorFR1ibViug97z8zh+3rJ4PvtbO8R9ymRagjgei/4IvtUTml+YJ2IEpIp/jnGC7/wfpW5Ti/hsYVFpnJ7Xi+lHntkxAJ37laIdXw41orwi3E8aQ6T6vEPk2DnFJ6iEF7z06+39sbjvFbvNdZ0MFxnrCirA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730459152; c=relaxed/simple;
	bh=cwT+cLWQQFNNLGLYBwT2dCBOBJnGH33D0XD+50ipeBk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d6t0MeLpD+C3KC8604MRZBt+ppGdHPHewuSpA1KlLYhwXEYue816wv9DAjurMFYP+V3E7vTaLIfdyV9By21Tvx4z4En9dI/022ndmFUhg1+/RK/r1IdcBU6zDFQrhCNjq3BncStTkdnUoS9bdZTaW3IoShsUttZ5Gdl8hQIdHZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QHfDHzs4; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730459150; x=1761995150;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cwT+cLWQQFNNLGLYBwT2dCBOBJnGH33D0XD+50ipeBk=;
  b=QHfDHzs4k2yykfSh8PHrjdLRfUSsayqGdUGBfwURXVcNN8l3ulKt+prn
   yBGIvdxAZ0mqnASNixpJfAhyDplHmNwzrAd++mcm25akq6Pz2XB+PGFmX
   GUXtrzu00LsrwrdhFoGu9Xn4/2xSxzMpNjnH+ilGxP/jLFSONS+EVKWUw
   ZzB8f4yBRxNN5mR352c0RdBoZwIjhZYvgHj1jdf/UCKDCqpd+oHfacNrV
   vXKj1U+71gR+Q2ox3/c8COgwrTNDPrC2BDTGSG19BPDeEeuEKPll7OBHn
   mUDGvZL67aoAoQdtLiEO/i4tbYl1qnXIYrBKYoKlSTdNoNR5pbz69QYgi
   g==;
X-CSE-ConnectionGUID: NNTI6MiBR0O2K/xdoi66bw==
X-CSE-MsgGUID: RYmwvfw1SE+2cYeE7sK5hA==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="30333672"
X-IronPort-AV: E=Sophos;i="6.11,249,1725346800"; 
   d="scan'208";a="30333672"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 04:05:50 -0700
X-CSE-ConnectionGUID: pcTloYkDTJmNYxQzj9uNSw==
X-CSE-MsgGUID: shJXwX6bQp2tv+Kal12Yiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,249,1725346800"; 
   d="scan'208";a="82613263"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Nov 2024 04:05:49 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 1 Nov 2024 04:05:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 1 Nov 2024 04:05:48 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 1 Nov 2024 04:05:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W7zKBYfJUs4A3k3dTS+H5r/USIMfhCS2pEn4K6KKXShjBI8oOFgX3UgKzKS3SIjU/au1GW5qi7APi3HOIM+u5DqgmQuFTMolQTggKa/UeqXT2mfr/UywBJ5JQyszDNqxkwTih7CXmRT3vcR1suTidjfhVe0rCliTWzMSUgapPrSr+aqMZJJRMmeSVG6HuF8NmxvNACusOpa9sv60vKmfAFeIMQvqDwzB+yE3xrph2zn0DSIfMz/0V0hYfdkdfviEUNHRctKx/nnnlpraicPlSnBLyMfOdEKYH9B4GEwz4pypdLGo0rYGHkIO95AfKc3JZcoKa3P4DsuUSQdcwF1R2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwT+cLWQQFNNLGLYBwT2dCBOBJnGH33D0XD+50ipeBk=;
 b=vEULZ+Q97RAOIvcsVRhsh3EfbNE17FH2Luj6VWBetZhB5g1XuSUNkgKkAV2K00lZCNGDmt+20txw1lPIixudATRiq+jaRXaSQgk56vCbyPseqOPiEbsmMb3z9GUvrUM96SxzceKtZLXEgaBNwDCYKPVdXKXyZgCgSYHnnjvL81ZaP0vDODew1aYUBQG59ngEZ7tmk2Ql/oBg9Q7xRXCB2RK+zn/FBu0uR3pcjUHDfJzv/sJJadDluGL91fPCEutZFB9S1RcMD4WNrycXDKvl4Ke0ybSJ82ztyUep4/7W56b99VoL4DqCAhDWKO3nLKd+WFPaTJKuRERJ8+/J9Cp3hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6311.namprd11.prod.outlook.com (2603:10b6:8:a6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Fri, 1 Nov
 2024 11:05:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8093.027; Fri, 1 Nov 2024
 11:05:45 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "yuan.yao@linux.intel.com"
	<yuan.yao@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Thread-Topic: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Thread-Index: AQHa916mLjHQn3A27kaE3wVAzihpyrKgK5iAgABDH4CAAOwxgIABUlWA
Date: Fri, 1 Nov 2024 11:05:45 +0000
Message-ID: <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
	 <20240826022255.361406-2-binbin.wu@linux.intel.com>
	 <ZyKbxTWBZUdqRvca@google.com>
	 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
	 <ZyLWMGcgj76YizSw@google.com>
In-Reply-To: <ZyLWMGcgj76YizSw@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6311:EE_
x-ms-office365-filtering-correlation-id: 93f28a06-406f-4130-1974-08dcfa65225a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WDdPZVFsU0tlMXNRdFhMVTRIVWNxYkpJNU82NEVsdGtSU0hMNVBhSk9lZldi?=
 =?utf-8?B?Ump5ZG5MWW9hOEJKR1lNejI5TFZPSVp3Y3YzNDFIVzBhejJpQzBWVWRkdDFm?=
 =?utf-8?B?ejhHV0dCcEw4ei9WZVhNelZIMVpFWVQyaGU0T2laMllxMEs1OSt2MFYvR3Fu?=
 =?utf-8?B?SUpQVlVWN3FldkwwVVd2amtuZFJsTWJDejhBdXRZdkp4aVRLMFdOTzB4ZmYw?=
 =?utf-8?B?VFgvSGJSa3NmaVd0dm5CaXU1bm1GWWk5S1MxSitud1c3cDd3Ulp6cy8vb0Na?=
 =?utf-8?B?TUJoNmVuZ0xCN3dyRm9YT3JsejZmVFBuMys4clRpYmlzZEZoRjdIOE9XTVph?=
 =?utf-8?B?dWJoeVJBUWNmSEZaejMxQjR4dHNkMVp4NXN5K2lMaDRUWGhNcTB5MzlqNXU4?=
 =?utf-8?B?NmlIdGZ1Yms5QXJkak9Mb1prK1dDWGJEdWdwNUszMW9xNFBETkRXMWlUa3lC?=
 =?utf-8?B?QXJ1WkkycGdtTCtteDVsVmxsVjZlYnBJSUd3aE5rL0wzT2czclc2VERJQUNF?=
 =?utf-8?B?L1R0T3pibkRrbGRUTklSMHBIVVJTaC95YW5ZeW0zSWM3LzM4b05ldTBaMVlU?=
 =?utf-8?B?T1dkQUE1WXNWRGpuUml2Q09QNzZJbDBkWm13N20rSWcxZzl5VWN4SDhnbHVl?=
 =?utf-8?B?U29kWWFlU05YTVZBWEtET1dmSHI3cXk5dDJXR0hrMmtmaTdGVTdHNmVBVTBw?=
 =?utf-8?B?T0tVUTZUT0FzdklQV1R4a3RZZ3E0TFJtM0E0R2E1aUtHZ3JEVlRDR3F5VHJj?=
 =?utf-8?B?cHgvL3ozWlV2YVcxY0Ewb1NQc0R5RnN5b08zZmYwU0JEZEx6dWx4LytheU1t?=
 =?utf-8?B?SEpEb0dSak1TbWpLai9Ua3IwMmxoSDFRbm9SaDhOQVpMU2czMDNzejFHemVz?=
 =?utf-8?B?SU9laE1DazNOakdlaHFWUmNDUU8wQWNBYll5UjdvTGt3SUdaRW9qVTlNNXpw?=
 =?utf-8?B?ck1MdEt4azN4TldvS0Iza2pvcmRMdTZjdEY4OVljV1NUeHJiaEk3UUk5UlpM?=
 =?utf-8?B?OVliS2dBTm00VnFvazQxQmlYVTFkM0h0SnFWRlNOKyt2eXBCOU93emdlL0l3?=
 =?utf-8?B?b2RIbE8yZTlzUUIxTlE0ckgraGxLVHRNS2RoRk1QYW9vV3BVMEozc1pGVFU1?=
 =?utf-8?B?aHI3VUNmQXJxOGRzZHJSOUpsdUVRdklYV1Z0MXptczVnN0dYQWROZ2tySUhh?=
 =?utf-8?B?NElvQzN4WkcxQWpKaDVWQjIrc0h5T1lnTDdqWUlKVEdtMEhCVi8xN0pINHB3?=
 =?utf-8?B?cld3ejVLVHZSdXB4Y2VvM3BOenMwU1F2WkVEYll4R0cyWkpIajRSdlhObFE1?=
 =?utf-8?B?OHQ3Y2Jzcm5JM000Rlp2SHpVNXQ5QU44YU5DN3RQdTZwMGV3bXZCSmtadVF5?=
 =?utf-8?B?RGJtbkRpNncwazVJOTk3dmhMdy8zNlNmeTBWeFFhUGxPN0p3T0dsUnlXTE43?=
 =?utf-8?B?WXNHZThFbnFwL0RVTWJJQzFQZlJCNnhUbUd4MXBIRjlGR0s0bjlDS09BRGY2?=
 =?utf-8?B?cDhJZ1g1ajVTVVo5RFkvSmJJVVFZbGErVjRIQk9Yem5oNTRrYVo5cGxrYkR6?=
 =?utf-8?B?cTdTeEVoUEh2MXNzR3NGS3dvT09YQ1VxcnY1QXZyK2ZpcTQrd045SmlwckRo?=
 =?utf-8?B?WDlWZ3oybkNsZHo2cHI1dDZRYnJlY0RLOFRKL0JHSXNBalhQQThtS0F1dE1U?=
 =?utf-8?B?RzEyV2FwWk01MmJ3SVc1NURVUkZpSDdOL3Yrck5JTmtwQU51azFxZVlxa2Jx?=
 =?utf-8?B?VE5UdDJaakF6K3Bhb0JnWnpZOTFmOE5VV3g0S3VCWmh1Y256YjhCb21za2Jm?=
 =?utf-8?Q?KgSwIf6kHM6kp5NctK7NBQpMMUETy2NJXiXhM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OW1zWEw4UU9GTkNucy83RVdIME9adXdBK1dRRjcvQjhsSU5aSG9vVEcyWnVr?=
 =?utf-8?B?MDZnMUszaHR0Y1k0NXEyc3NxR3lCcnMrUFZTRk9WOEE0THd6aTlSZjF4MlBT?=
 =?utf-8?B?ZGozbW1SeVpiazhmT3JnQ3lGT0pmWC80TVRlVDVnVGMxaVpZMERKVEg4b1NX?=
 =?utf-8?B?ZGc3cnRRdFFLMTN1QkpwbkZBRXZNRTJpUDZ1d2JPMjVLRUxrK2NJM3pxWGJR?=
 =?utf-8?B?MGRJT1FYOUdobHE3YVg4TkJzZ3ExdVpmdjRxL1FNV2JRbDlQY25sRkE5TGc5?=
 =?utf-8?B?aTFzQTNUMzVGMGl6ZDhZNTJsZUw0c2VEeG9YYWg1cWczRUgrQ3NHeTNLTVlL?=
 =?utf-8?B?aE9FRGtlaFJYaEpLOXlkaTJHYlBtOHVzREZ0WFpyTnVlcm9aZ1Z5UGlmSnFo?=
 =?utf-8?B?bFp3ZWNHaWJ2UFAveGZyRnlUdEhVTUNVUHBGOHN2Z3V1bENMT3FoRzJPbFFC?=
 =?utf-8?B?bHVrL25qVDJOaUVHamNzUlhIb3ZzeDVYTXBUUGtQWWN4eHc1SGpmMmx3QnhY?=
 =?utf-8?B?OXd2OHFxZjZNTlFLZE4rbUh0RWkxUWtIOUpXOEM0b2FGWitIcUVMRkxZeG5Q?=
 =?utf-8?B?ZDQ1NmdvRWVndGlJZ0pwRUdSSk8wRS80eEY1Mlg5SUNST05Cb0F4MzFWK2pO?=
 =?utf-8?B?SlV6Q2lHbkRnUHMxeVl0bnRVaHBMVlJYZ0kxTHM5Q2xDNTFaNXUvdFhScFQw?=
 =?utf-8?B?eGxOMWNFTk5OdzRRZTdvR3FtUWw0OG5TSVNuZUFqWFFYemlrRzZlR3JTNlVO?=
 =?utf-8?B?WWdnTW0rL2gvTmdVVERqY2xJZmpjTktsR0orVS9RL3lURlN3Q00wTUF5MFB1?=
 =?utf-8?B?cWNiaHdsUnhLK2svWk9zUWhHamdDazI0cDdBWXVENGRkWjJ0dE9KemtrazdE?=
 =?utf-8?B?c25zSGNCWHFDTklnc3dYTTJ0M3BYZDhOWFRoTVFLdzBUR1M1Mk0rZjZ3SHR1?=
 =?utf-8?B?MEN4WWxzRUFnSVBWWWVyY09YNHhqQmdHL0xSRFd0cDRIYzloajdMT1ZRbVk5?=
 =?utf-8?B?RlByd2FsZE12MlpLTmM0UVQ0R3pQVExVOTQzWmhEN2V4N3VVU1B3WWtYZ3Bm?=
 =?utf-8?B?K2JyOGRZaVhVYlloK3FIWWl5bkptWkYvcURiMUtTeXprb3E4MDNSanFnY2p4?=
 =?utf-8?B?UGRIS2trQ0JpUUFnS2NnR3E0NG9nN2Jua3FGb0xwYU81SHYwazZhZWtkQjJT?=
 =?utf-8?B?cnJSM1lsZnFoZzlJVG5IcVl5b2g1azg4VVRqdiszQm1KdmZZc3BWbXpCalJt?=
 =?utf-8?B?Q2REWG9yZEhRSWlSemRLTVpqMTZIRnZJbkxKYTRpVTUzYzRuV0U4b1FPR3p2?=
 =?utf-8?B?VWVnYXdmZVMwT1htN1VMc0hpcElibm1MbnNvV0k1eXJwbEExbFhKVHA1Q0t2?=
 =?utf-8?B?Zk5tVTNGUlBQMXNzWjRpVFcrMzVaQjMvbWplaGYxbVJIdEdtcUFDYmM4VWFY?=
 =?utf-8?B?eThkSUFQd2w4S0FML2V3N0pwTldGaU9yV1g2K2h2cElhYXpwTWgxUkhZdXRB?=
 =?utf-8?B?Q1QrUTNqYWtOTVVNM1FIdUVscjZqSUZtSmw1MEprOHZkbjdON3ZWMFJiQmNE?=
 =?utf-8?B?SWVwYVRuK1ZRbVJ4QUNNbDlWei9ETXZiYUhKUlRFSnZJQjFDd3BrTmVZakJL?=
 =?utf-8?B?ckJLeDV5eVptdjNYbXY3bURKSDhKZFJGVFJZakVIMHdJam1FSm1BNERnNElM?=
 =?utf-8?B?Z1dGVW15NWVrN2tmVlR1YVQxcUVwZmpMaGw5YnNkcTk0cFNwbHNoQUhIcVhz?=
 =?utf-8?B?VmUrR0M0NjBQVWtXTU9RdmVMRHM1ZXpEMk85N2VIRWUxR0F2elE4SXAwTmNp?=
 =?utf-8?B?aHE0NWgzNjRaL0gvdEtzK040Nk1PUTV3eExiUmpzdlI1N3hkeDRHd1hja1Nz?=
 =?utf-8?B?L0ppWHFDV3VlaDFlQ0Z1SWFUQkhsVldBeWtCVEEyeE8vRlRNaTdsamFWL0x6?=
 =?utf-8?B?OGdsRXYvQituK3MzSjVFTFEvOWd0Vi8xUG9nMnQxTXl1LysxSG5ZczJCa1NK?=
 =?utf-8?B?aW10WEVYZ2VyLzZVWTFMTXNQSmE1RWtqOXdnVzlLK3J3V2RsbElydFdoUW4w?=
 =?utf-8?B?Q1k2cjBUWTZvczZJM1dmRXV2dlZXdElqWXVKdTJrWDEwWm5kT0pPcDdEelVu?=
 =?utf-8?Q?ifVr3nnaX+ETUJSvSoWGXImcL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D2150C528C032440BFCC6EBF8C1B2CC8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93f28a06-406f-4130-1974-08dcfa65225a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2024 11:05:45.4183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C7IgG0WUmLu2EUiEoAVgrg1zi6s9Cd3aD4V4cWW2goMLfC3AhSygSmwSVzyypcE1WLncxi82kHyh/eDN3M+uxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6311
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTEwLTMxIGF0IDA3OjU0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE9jdCAzMSwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gQEAg
LTEwMTExLDEyICsxMDExMSwyMSBAQCBpbnQga3ZtX2VtdWxhdGVfaHlwZXJjYWxsKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSkNCj4gPiA+ICAJY3BsID0ga3ZtX3g4Nl9jYWxsKGdldF9jcGwpKHZjcHUp
Ow0KPiA+ID4gIA0KPiA+ID4gIAlyZXQgPSBfX2t2bV9lbXVsYXRlX2h5cGVyY2FsbCh2Y3B1LCBu
ciwgYTAsIGExLCBhMiwgYTMsIG9wXzY0X2JpdCwgY3BsKTsNCj4gPiA+IC0JaWYgKG5yID09IEtW
TV9IQ19NQVBfR1BBX1JBTkdFICYmICFyZXQpDQo+ID4gPiAtCQkvKiBNQVBfR1BBIHRvc3NlcyB0
aGUgcmVxdWVzdCB0byB0aGUgdXNlciBzcGFjZS4gKi8NCj4gPiA+ICsJaWYgKCFyZXQpDQo+ID4g
PiAgCQlyZXR1cm4gMDsNCj4gPiA+ICANCj4gPiA+IC0JaWYgKCFvcF82NF9iaXQpDQo+ID4gPiAr
CS8qDQo+ID4gPiArCSAqIEtWTSdzIEFCSSB3aXRoIHRoZSBndWVzdCBpcyB0aGF0ICcwJyBpcyBz
dWNjZXNzLCBhbmQgYW55IG90aGVyIHZhbHVlDQo+ID4gPiArCSAqIGlzIGFuIGVycm9yIGNvZGUu
ICBJbnRlcm5hbGx5LCAnMCcgPT0gZXhpdCB0byB1c2Vyc3BhY2UgKHNlZSBhYm92ZSkNCj4gPiA+
ICsJICogYW5kICcxJyA9PSBzdWNjZXNzLCBhcyBLVk0ncyBkZSBmYWN0byBzdGFuZGFyZCByZXR1
cm4gY29kZXMgYXJlIHRoYXQNCj4gPiA+ICsJICogcGx1cyAtZXJybm8gPT0gZmFpbHVyZS4gIEV4
cGxpY2l0bHkgY2hlY2sgZm9yICcxJyBhcyBzb21lIFBWIGVycm9yDQo+ID4gPiArCSAqIGNvZGVz
IGFyZSBwb3NpdGl2ZSB2YWx1ZXMuDQo+ID4gPiArCSAqLw0KPiA+ID4gKwlpZiAocmV0ID09IDEp
DQo+ID4gPiArCQlyZXQgPSAwOw0KPiA+ID4gKwllbHNlIGlmICghb3BfNjRfYml0KQ0KPiA+ID4g
IAkJcmV0ID0gKHUzMilyZXQ7DQo+ID4gPiArDQo+ID4gPiAgCWt2bV9yYXhfd3JpdGUodmNwdSwg
cmV0KTsNCj4gPiA+ICANCj4gPiA+ICAJcmV0dXJuIGt2bV9za2lwX2VtdWxhdGVkX2luc3RydWN0
aW9uKHZjcHUpOw0KPiA+ID4gDQo+ID4gDQo+ID4gSXQgYXBwZWFycyBiZWxvdyB0d28gY2FzZXMg
YXJlIG5vdCBjb3ZlcmVkIGNvcnJlY3RseT8NCj4gPiANCj4gPiAjaWZkZWYgQ09ORklHX1g4Nl82
NCAgICANCj4gPiAgICAgICAgIGNhc2UgS1ZNX0hDX0NMT0NLX1BBSVJJTkc6DQo+ID4gICAgICAg
ICAgICAgICAgIHJldCA9IGt2bV9wdl9jbG9ja19wYWlyaW5nKHZjcHUsIGEwLCBhMSk7DQo+ID4g
ICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICNlbmRpZg0KPiA+ICAgICAgICAgY2FzZSBLVk1f
SENfU0VORF9JUEk6DQo+ID4gICAgICAgICAgICAgICAgIGlmICghZ3Vlc3RfcHZfaGFzKHZjcHUs
IEtWTV9GRUFUVVJFX1BWX1NFTkRfSVBJKSkNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBi
cmVhazsNCj4gPiANCj4gPiAgICAgICAgICAgICAgICAgcmV0ID0ga3ZtX3B2X3NlbmRfaXBpKHZj
cHUtPmt2bSwgYTAsIGExLCBhMiwgYTMsIG9wXzY0X2JpdCk7DQo+ID4gICAgICAgICAgICAgICAg
IGJyZWFrOyANCj4gPiANCj4gPiBMb29raW5nIGF0IHRoZSBjb2RlLCBzZWVtcyBhdCBsZWFzdCBm
b3IgS1ZNX0hDX0NMT0NLX1BBSVJJTkcsDQo+ID4ga3ZtX3B2X2Nsb2NrX3BhaXJpbmcoKSByZXR1
cm5zIDAgb24gc3VjY2VzcywgYW5kIHRoZSB1cHN0cmVhbSBiZWhhdmlvdXIgaXMgbm90DQo+ID4g
cm91dGluZyB0byB1c2Vyc3BhY2UgYnV0IHdyaXRpbmcgMCB0byB2Y3B1J3MgUkFYIGFuZCByZXR1
cm5pbmcgdG8gZ3Vlc3QuICBXaXRoDQo+ID4gdGhlIGNoYW5nZSBhYm92ZSwgaXQgaW1tZWRpYXRl
bHkgcmV0dXJucyB0byB1c2Vyc3BhY2Ugdy9vIHdyaXRpbmcgMCB0byBSQVguDQo+ID4gDQo+ID4g
Rm9yIEtWTV9IQ19TRU5EX0lQSSwgc2VlbXMgdGhlIHVwc3RyZWFtIGJlaGF2aW91ciBpcyB0aGUg
cmV0dXJuIHZhbHVlIG9mDQo+ID4ga3ZtX3B2X3NlbmRfaXBpKCkgaXMgYWx3YXlzIHdyaXR0ZW4g
dG8gdmNwdSdzIFJBWCByZWcsIGFuZCB3ZSBhbHdheXMganVzdCBnbw0KPiA+IGJhY2sgdG8gZ3Vl
c3QuICBXaXRoIHlvdXIgY2hhbmdlLCB0aGUgYmVoYXZpb3VyIHdpbGwgYmUgY2hhbmdlZCB0bzoN
Cj4gPiANCj4gPiAgIDEpIHdoZW4gcmV0ID09IDAsIGV4aXQgdG8gdXNlcnNwYWNlIHcvbyB3cml0
aW5nICAwIHRvIHZjcHUncyBSQVgsDQo+ID4gICAyKSB3aGVuIHJldCA9PSAxLCBpdCBpcyBjb252
ZXJ0ZWQgdG8gMCBhbmQgdGhlbiB3cml0dGVuIHRvIFJBWC4NCj4gPiANCj4gPiBUaGlzIGRvZXNu
J3QgbG9vayBsaWtlIHNhZmUuDQo+IA0KPiBEcmF0LCBJIG1hbmFnZWQgdG8gc3BhY2Ugb24gdGhl
IGNhc2VzIHRoYXQgZGlkbid0IGV4cGxpY2l0IHNldCAnMCcuICBIcm0uDQo+IA0KPiBNeSBvdGhl
ciBpZGVhIHdhcyBoYXZlIGFuIG91dC1wYXJhbSB0byBzZXBhcmF0ZSB0aGUgcmV0dXJuIGNvZGUg
aW50ZW5kZWQgZm9yIEtWTQ0KPiBmcm9tIHRoZSByZXR1cm4gY29kZSBpbnRlbmRlZCBmb3IgdGhl
IGd1ZXN0LiAgSSBnZW5lcmFsbHkgZGlzbGlrZSBvdXQtcGFyYW1zLCBidXQNCj4gdHJ5aW5nIHRv
IGp1Z2dsZSBhIHJldHVybiB2YWx1ZSB0aGF0IG11bHRpcGxleGVzIGd1ZXN0IGFuZCBob3N0IHZh
bHVlcyBzZWVtcyBsaWtlDQo+IGFuIGV2ZW4gd29yc2UgaWRlYS4NCg0KWWVhaCB0aGlzIGxvb2tz
IGZpbmUgdG8gbWUsIG9uZSBjb21tZW50IGJlbG93IC4uLg0KDQoNClsuLi5dDQoNCj4gLQlyZXQg
PSBfX2t2bV9lbXVsYXRlX2h5cGVyY2FsbCh2Y3B1LCBuciwgYTAsIGExLCBhMiwgYTMsIG9wXzY0
X2JpdCwgY3BsKTsNCj4gLQlpZiAobnIgPT0gS1ZNX0hDX01BUF9HUEFfUkFOR0UgJiYgIXJldCkN
Cj4gLQkJLyogTUFQX0dQQSB0b3NzZXMgdGhlIHJlcXVlc3QgdG8gdGhlIHVzZXIgc3BhY2UuICov
DQo+IC0JCXJldHVybiAwOw0KPiArCXIgPSBfX2t2bV9lbXVsYXRlX2h5cGVyY2FsbCh2Y3B1LCBu
ciwgYTAsIGExLCBhMiwgYTMsIG9wXzY0X2JpdCwgY3BsLCAmcmV0KTsNCj4gKwlpZiAociA8PSBy
KQ0KPiArCQlyZXR1cm4gcjsNCg0KLi4uIHNob3VsZCBiZToNCg0KCWlmIChyIDw9IDApDQoJCXJl
dHVybiByOw0KDQo/DQoNCkFub3RoZXIgb3B0aW9uIG1pZ2h0IGJlIHdlIG1vdmUgInNldCBoeXBl
cmNhbGwgcmV0dXJuIHZhbHVlIiBjb2RlIGluc2lkZQ0KX19rdm1fZW11bGF0ZV9oeXBlcmNhbGwo
KS4gIFNvIElJVUMgdGhlIHJlYXNvbiB0byBzcGxpdA0KX19rdm1fZW11bGF0ZV9oeXBlcmNhbGwo
KSBvdXQgaXMgZm9yIFREWCwgYW5kIHdoaWxlIG5vbi1URFggdXNlcyBSQVggdG8gY2FycnkNCnRo
ZSBoeXBlcmNhbGwgcmV0dXJuIHZhbHVlLCBURFggdXNlcyBSMTAuDQoNCldlIGNhbiBhZGRpdGlv
bmFsbHkgcGFzcyBhICJrdm1faHlwZXJjYWxsX3NldF9yZXRfZnVuYyIgZnVuY3Rpb24gcG9pbnRl
ciB0bw0KX19rdm1fZW11bGF0ZV9oeXBlcmNhbGwoKSwgYW5kIGludm9rZSBpdCBpbnNpZGUuICBU
aGVuIHdlIGNhbiBjaGFuZ2UNCl9fa3ZtX2VtdWxhdGVfaHlwZXJjYWxsKCkgdG8gcmV0dXJuOiAN
CiAgICA8IDAgZXJyb3IsIA0KICAgID09MCByZXR1cm4gdG8gdXNlcnNwYWNlLCANCiAgICA+IDAg
Z28gYmFjayB0byBndWVzdC4NCg0KSSBtYWRlIHNvbWUgYXR0ZW1wdCBiZWxvdywgYnVpbGQgdGVz
dCBvbmx5Og0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCBi
L2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCmluZGV4IDZkOWY3NjNhN2JiOS4uYzQ4
ZmViNjJhNWQ3IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0K
KysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KQEAgLTIxNzksMTAgKzIxNzks
MTQgQEAgc3RhdGljIGlubGluZSB2b2lkIGt2bV9jbGVhcl9hcGljdl9pbmhpYml0KHN0cnVjdCBr
dm0NCiprdm0sDQogICAgICAgIGt2bV9zZXRfb3JfY2xlYXJfYXBpY3ZfaW5oaWJpdChrdm0sIHJl
YXNvbiwgZmFsc2UpOw0KIH0NCiANCi11bnNpZ25lZCBsb25nIF9fa3ZtX2VtdWxhdGVfaHlwZXJj
YWxsKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdW5zaWduZWQgbG9uZyBuciwNCi0gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBhMCwgdW5zaWduZWQgbG9u
ZyBhMSwNCi0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9u
ZyBhMiwgdW5zaWduZWQgbG9uZyBhMywNCi0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgaW50IG9wXzY0X2JpdCwgaW50IGNwbCk7DQordHlwZWRlZiB2b2lkICgqa3ZtX2h5cGVy
Y2FsbF9zZXRfcmV0X2Z1bmNfdCkoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KKyAgICAgICAgICAg
ICAgIHVuc2lnbmVkIGxvbmcgdmFsKTsNCisNCitpbnQgX19rdm1fZW11bGF0ZV9oeXBlcmNhbGwo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1bnNpZ25lZCBsb25nIG5yLA0KKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgYTAsIHVuc2lnbmVkIGxvbmcgYTEsDQorICAgICAg
ICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBhMiwgdW5zaWduZWQgbG9uZyBhMywN
CisgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnQgb3BfNjRfYml0LCBpbnQgY3BsLA0KKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGt2bV9oeXBlcmNhbGxfc2V0X3JldF9mdW5jX3Qgc2V0
X3JldF9mdW5jKTsNCiBpbnQga3ZtX2VtdWxhdGVfaHlwZXJjYWxsKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSk7DQogDQogaW50IGt2bV9tbXVfcGFnZV9mYXVsdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUs
IGdwYV90IGNyMl9vcl9ncGEsIHU2NCBlcnJvcl9jb2RlLA0KZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYw0KaW5kZXggODNmZTBhNzgxNDZmLi4wMWJk
ZjAxY2ZjNzkgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCisrKyBiL2FyY2gveDg2
L2t2bS94ODYuYw0KQEAgLTk5OTgsMTAgKzk5OTgsMTEgQEAgc3RhdGljIGludCBjb21wbGV0ZV9o
eXBlcmNhbGxfZXhpdChzdHJ1Y3Qga3ZtX3ZjcHUNCip2Y3B1KQ0KICAgICAgICByZXR1cm4ga3Zt
X3NraXBfZW11bGF0ZWRfaW5zdHJ1Y3Rpb24odmNwdSk7DQogfQ0KIA0KLXVuc2lnbmVkIGxvbmcg
X19rdm1fZW11bGF0ZV9oeXBlcmNhbGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1bnNpZ25lZCBs
b25nIG5yLA0KLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBs
b25nIGEwLCB1bnNpZ25lZCBsb25nIGExLA0KLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB1bnNpZ25lZCBsb25nIGEyLCB1bnNpZ25lZCBsb25nIGEzLA0KLSAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBpbnQgb3BfNjRfYml0LCBpbnQgY3BsKQ0KK2ludCBf
X2t2bV9lbXVsYXRlX2h5cGVyY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHVuc2lnbmVkIGxv
bmcgbnIsDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBhMCwgdW5z
aWduZWQgbG9uZyBhMSwNCisgICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBsb25n
IGEyLCB1bnNpZ25lZCBsb25nIGEzLA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCBv
cF82NF9iaXQsIGludCBjcGwsDQorICAgICAgICAgICAgICAgICAgICAgICAgICAga3ZtX2h5cGVy
Y2FsbF9zZXRfcmV0X2Z1bmNfdCBzZXRfcmV0X2Z1bmMpDQogew0KICAgICAgICB1bnNpZ25lZCBs
b25nIHJldDsNCiANCkBAIC0xMDA3Niw2ICsxMDA3Nyw3IEBAIHVuc2lnbmVkIGxvbmcgX19rdm1f
ZW11bGF0ZV9oeXBlcmNhbGwoc3RydWN0IGt2bV92Y3B1DQoqdmNwdSwgdW5zaWduZWQgbG9uZyBu
ciwNCiANCiAgICAgICAgICAgICAgICBXQVJOX09OX09OQ0UodmNwdS0+cnVuLT5oeXBlcmNhbGwu
ZmxhZ3MgJg0KS1ZNX0VYSVRfSFlQRVJDQUxMX01CWik7DQogICAgICAgICAgICAgICAgdmNwdS0+
YXJjaC5jb21wbGV0ZV91c2Vyc3BhY2VfaW8gPSBjb21wbGV0ZV9oeXBlcmNhbGxfZXhpdDsNCisg
ICAgICAgICAgICAgICAvKiBNQVBfR1BBIHRvc3NlcyB0aGUgcmVxdWVzdCB0byB0aGUgdXNlciBz
cGFjZS4gKi8NCiAgICAgICAgICAgICAgICAvKiBzdGF0IGlzIGluY3JlbWVudGVkIG9uIGNvbXBs
ZXRpb24uICovDQogICAgICAgICAgICAgICAgcmV0dXJuIDA7DQogICAgICAgIH0NCkBAIC0xMDA4
NSwxNiArMTAwODcsMjYgQEAgdW5zaWduZWQgbG9uZyBfX2t2bV9lbXVsYXRlX2h5cGVyY2FsbChz
dHJ1Y3Qga3ZtX3ZjcHUNCip2Y3B1LCB1bnNpZ25lZCBsb25nIG5yLA0KICAgICAgICB9DQogDQog
b3V0Og0KKyAgICAgICBpZiAoIW9wXzY0X2JpdCkNCisgICAgICAgICAgICAgICByZXQgPSAodTMy
KXJldDsNCisgICAgICAgKCpzZXRfcmV0X2Z1bmMpKHZjcHUsIHJldCk7DQorDQogICAgICAgICsr
dmNwdS0+c3RhdC5oeXBlcmNhbGxzOw0KLSAgICAgICByZXR1cm4gcmV0Ow0KKyAgICAgICByZXR1
cm4gMTsNCiB9DQogRVhQT1JUX1NZTUJPTF9HUEwoX19rdm1fZW11bGF0ZV9oeXBlcmNhbGwpOw0K
IA0KK3N0YXRpYyB2b2lkIGt2bV9oeXBlcmNhbGxfc2V0X3JldF9kZWZhdWx0KHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSwNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVu
c2lnbmVkIGxvbmcgdmFsKQ0KK3sNCisgICAgICAga3ZtX3JheF93cml0ZSh2Y3B1LCB2YWwpOw0K
K30NCisNCiBpbnQga3ZtX2VtdWxhdGVfaHlwZXJjYWxsKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkN
CiB7DQotICAgICAgIHVuc2lnbmVkIGxvbmcgbnIsIGEwLCBhMSwgYTIsIGEzLCByZXQ7DQorICAg
ICAgIHVuc2lnbmVkIGxvbmcgbnIsIGEwLCBhMSwgYTIsIGEzOw0KICAgICAgICBpbnQgb3BfNjRf
Yml0Ow0KLSAgICAgICBpbnQgY3BsOw0KKyAgICAgICBpbnQgY3BsLCByZXQ7DQogDQogICAgICAg
IGlmIChrdm1feGVuX2h5cGVyY2FsbF9lbmFibGVkKHZjcHUtPmt2bSkpDQogICAgICAgICAgICAg
ICAgcmV0dXJuIGt2bV94ZW5faHlwZXJjYWxsKHZjcHUpOw0KQEAgLTEwMTEwLDE0ICsxMDEyMiwx
MCBAQCBpbnQga3ZtX2VtdWxhdGVfaHlwZXJjYWxsKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCiAg
ICAgICAgb3BfNjRfYml0ID0gaXNfNjRfYml0X2h5cGVyY2FsbCh2Y3B1KTsNCiAgICAgICAgY3Bs
ID0ga3ZtX3g4Nl9jYWxsKGdldF9jcGwpKHZjcHUpOw0KIA0KLSAgICAgICByZXQgPSBfX2t2bV9l
bXVsYXRlX2h5cGVyY2FsbCh2Y3B1LCBuciwgYTAsIGExLCBhMiwgYTMsIG9wXzY0X2JpdCwgY3Bs
KTsNCi0gICAgICAgaWYgKG5yID09IEtWTV9IQ19NQVBfR1BBX1JBTkdFICYmICFyZXQpDQotICAg
ICAgICAgICAgICAgLyogTUFQX0dQQSB0b3NzZXMgdGhlIHJlcXVlc3QgdG8gdGhlIHVzZXIgc3Bh
Y2UuICovDQotICAgICAgICAgICAgICAgcmV0dXJuIDA7DQotDQotICAgICAgIGlmICghb3BfNjRf
Yml0KQ0KLSAgICAgICAgICAgICAgIHJldCA9ICh1MzIpcmV0Ow0KLSAgICAgICBrdm1fcmF4X3dy
aXRlKHZjcHUsIHJldCk7DQorICAgICAgIHJldCA9IF9fa3ZtX2VtdWxhdGVfaHlwZXJjYWxsKHZj
cHUsIG5yLCBhMCwgYTEsIGEyLCBhMywgb3BfNjRfYml0LCBjcGwsDQorICAgICAgICAgICAgICAg
ICAgICAgICBrdm1faHlwZXJjYWxsX3NldF9yZXRfZGVmYXVsdCk7DQorICAgICAgIGlmIChyZXQg
PD0gMCkNCisgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KIA0KICAgICAgICByZXR1cm4ga3Zt
X3NraXBfZW11bGF0ZWRfaW5zdHJ1Y3Rpb24odmNwdSk7DQogfQ0KDQoNCg0K

