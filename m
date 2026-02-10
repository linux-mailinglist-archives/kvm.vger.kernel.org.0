Return-Path: <kvm+bounces-70722-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aEUBH1UPi2l/PQAAu9opvQ
	(envelope-from <kvm+bounces-70722-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 11:58:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F122C119E73
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 11:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8883230A96AE
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 10:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63262360757;
	Tue, 10 Feb 2026 10:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ckxmJaex"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CBC360754;
	Tue, 10 Feb 2026 10:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770720906; cv=fail; b=joZpX6X9q4bDKR3Hx2fhRItb7y4WcdglrDdC3D4X2chICGWyyH6WunSz5bz/1yduCT2sU8UcHKQJWkRQVQfW7Ms6NxusJOyH8f1wMwB36KjzsK5VY/UTsw8XGRUHDdTNDpRM74QZtH6jMk9OigX+pTHI2d+x53SQ5ZdLaw2AaMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770720906; c=relaxed/simple;
	bh=fiopvuwERKeMVjwPXNoRe3RO3oMu/X5BSBoSHx77rrM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bd0yf8zr0FfVydBsuEACx/jhFmhalWzvu3jenGKcjSaZCgKOBgVh0WseKRWxe6CzI+g6J6Fb8hYmMoCgahM04wWtNZM4vZXlf8/8bguhTfpCtVOEBTRNjDilSYIZZiuDuOlVG5Yq1awim1Gb67bf0fRTgZhkdm3I+nuWLoOMVac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ckxmJaex; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770720905; x=1802256905;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fiopvuwERKeMVjwPXNoRe3RO3oMu/X5BSBoSHx77rrM=;
  b=ckxmJaexdjLePPWv0+u9MwvxPnh5SYHC5AHko8dgZdjxG+76PfvBUgFB
   2+BBNdo3frMrTX+TkWqVrqKKQ8/1tpBnHWntylLwVlffg0M5snTnCijkn
   sQGgn/OJ3voiC0mTObxLUkhEzgddYm3poKeo5W1wFmpgIbvBir4vzUnyX
   CLzCezjqBFLTYAsnHzBQA2JW8ZdD67aHC+L0XMErkLeUqJgOYB3lJ91UV
   rC/k3kP9cal2jogqLB+obUPgsHQMEq4LShvIW+zRnWZklnnubGg5dn2x2
   QlTiySms/HqHgfpvCnWWj07Y3ySu5PRQwRlT9EnR7yhvhSqRFf8DQoD9v
   A==;
X-CSE-ConnectionGUID: e7uwsMDfRFCtxoFPeiLKaQ==
X-CSE-MsgGUID: 6aSJwMMyQSGdTCSdQeChcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="59412962"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="59412962"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 02:55:05 -0800
X-CSE-ConnectionGUID: u3x0XxDOSrylFWkwbcy1yQ==
X-CSE-MsgGUID: SKwmoVnxQg+qOGuiUjbynw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211537072"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 02:55:04 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 02:55:03 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 02:55:03 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.53) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 02:55:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sov87FUgdzQuZRVDoKKJCc8tIQVeCcUjpalH9fcJXtZIfFdh9F2BBWEwFISBUz0U0BqMPVRSZ+gVI8pDnc+OTKHio3+5OCDcH9TCrS2T9VDC4HCeDHPoP868srTG+74PtYtysnfWZLct+e5qe1u2+b+y8N1SWPZz/mxrpDZOM00iX8qwx3DHd4RHxI4fzrdtASHBZA9q84f2G/bq1WWYRjdzxHlzPKXYQxhPIrtK9HRyPLFzdSzrngi9GLNluboBkpTYpNI8HR0gnm8r85rKGojHFHESDXZEFsmPTIqT1sVPaqtyogSzti5kWzXU6XPdxvyOzj596n5s9D7RkKu+qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fiopvuwERKeMVjwPXNoRe3RO3oMu/X5BSBoSHx77rrM=;
 b=VpaEUK5l5xXZL2UP/H8saKC1Wh0G/Z5ly3uCNL0bxE1C5k62hSJvdEoxvkWZLBRy/P6pAAN89DyLM+sBNs4yWlV6QHq3GBuvWXxNjX+0n2VOIEYjJ5dUOEyBICdMJRW67Xkyv8QM/a3Q4XCC02YPALvqscq1wdNm/plo+2yTi5bn0ObylAWluB1vUn870k7z+SxIQnW0SNnJVNgQDpCV2Ct1sc+G10KW/C8EHOxBRCcSiWrtfBsDXFJCSWYuAx6ZjnbRvMPsUn+G26OVf40s43E8M5BuHUwt6hjp4Nis3aiGLw2zuwRX8U2/RbIiJwPQAxEMNP81ZL3e9mptK3sZHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by DM4PR11MB6141.namprd11.prod.outlook.com (2603:10b6:8:b3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 10:55:01 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 10:54:59 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "tglx@kernel.org"
	<tglx@kernel.org>, "sagis@google.com" <sagis@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Annapurve,
 Vishal" <vannapurve@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
Thread-Topic: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
Thread-Index: AQHckLzhSspC1sJAD0G07NT4Ge5PXLV1eiWAgABXQQCABG6CAIAAyc8AgADMMQA=
Date: Tue, 10 Feb 2026 10:54:59 +0000
Message-ID: <e35c61ca34f985fa866b8781bc22c590337c330d.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-21-seanjc@google.com>
	 <aYW5CbUvZrLogsWF@yzhao56-desk.sh.intel.com> <aYYCOiMvWfSJR1AL@google.com>
	 <c753636171f82c3b6d64e7734be3a70c60775546.camel@intel.com>
	 <aYpjNrtGmogNzqwT@google.com>
In-Reply-To: <aYpjNrtGmogNzqwT@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|DM4PR11MB6141:EE_
x-ms-office365-filtering-correlation-id: 9aeeb6be-ff6f-47ca-7280-08de6892d5fc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?d1FNb0U2ajlCL0ZFODB5djhqd1Z4VHVPQ3VHdkNZdHo0ZzIrYmt4Z3FtQ3J6?=
 =?utf-8?B?TWx2dGcxdjdiRFhyV0FIRGZLRGVEb3dsTzg3TEdCcFI0bjJLZksvOTl3cmVn?=
 =?utf-8?B?SU9jT1AzVnQ0Mkx4WDFtY040VkYrMmhpZ1lERnN6TGtKaWRQU2tYa3NhWG9B?=
 =?utf-8?B?SmZXSWZvRjdxankyNVFhUk1xZkkxRUFKSlBqR2NwY1EwVUVGZTZLYlJDVXl2?=
 =?utf-8?B?S3RuUnBtSE9lSVI2K0MwYWhwVXNJQ3V1NnZwVG1Kcm9ncnZ3WGdxOXMzOVhH?=
 =?utf-8?B?VHdid3FpWUdwYlI1c3pkcEJTOTl2WkcyQlhyTEkxNmlPTE52ZGJNaC9YTzhy?=
 =?utf-8?B?WmM5c2cyMXJtWWV2QU02NzFQZnREWjNqbElGMFJGOEFXVmUxVUJwdFpaMnFW?=
 =?utf-8?B?elhvWlR2MWtmM3dScDcrc3RRd0h4UmxSdzJ3TC92TEtwSit3U1hRTVFYRENM?=
 =?utf-8?B?bUVQbGN6ZDN6Y0ozdTF1bFdVOFpKZWRjb0hONDQrcEIzNUExTWhqb2FVSE1u?=
 =?utf-8?B?VjF4N0R2Vk1CbnBZMXpoWTFHUXJXUnp4QTdYc3YvOUh1emNid1ZnTEN5SFhW?=
 =?utf-8?B?RGRDSE9SRlVLaEs1VjNPRzQ1L1Y0Vk56UDExbERTUndsUEFVeEJqbzlObTZS?=
 =?utf-8?B?V1paVFZDZDBSanMvWHlTOXVObHBUTFBDZUNTSCtkUXFzQlFFNFhSRVVvRy9H?=
 =?utf-8?B?R29WMjUwM0VjOFZ2T1VyalZjQzRxUDVtQU1xMHBNMUhRUkRNSTNMeFJVcWFL?=
 =?utf-8?B?cXZvYUFFN3RJOFBFVDh4NEZub2lXYnRadXE2RURVeGlXa2NwYVFzNVlycmo2?=
 =?utf-8?B?UWZkWHNnNC9mYlVQQ0hHdTVyMXZSN0pIYkFTYkJSeE5wN1luRFpJVStKZU1I?=
 =?utf-8?B?ZzJRZllnVTVsR244dnFITkh6NkhhOUswQXJ0eldFblVtWkUxaCtCamYzMVB2?=
 =?utf-8?B?QXJ3QzVUYVhuODhkNXlvbVJFVkRkcnRLQ0tXbnhoYUY2N0xodG5PTTE2amtF?=
 =?utf-8?B?SWZJc1JtcDIvZnBNSTZpRnBacWdrVzYyQjBrQjMrV002dWdsQzVYSU53QW5D?=
 =?utf-8?B?QXVHaVJQMU4rb1habm1vdWNieit3Nkx3ZlRITWxxaXA2WVEwMFJsVTI2WXVC?=
 =?utf-8?B?UDNQSC9kOGpQMlBJMmR5cGdBUXMvc1JrMzZ6dVcyRldId0FLVmxyWkJZZXRl?=
 =?utf-8?B?Q0dtT3hoZEdFMHYwc2RLRHVyRFd2azhROGtWaVU2QmJmTXFnZ2dqQmIzTmpF?=
 =?utf-8?B?Yzh0QlZ1M3lEODdGR1BwWjV1KzBsMHVjWGt5OVhmUDYwYzMrVnZVK09BaERW?=
 =?utf-8?B?RGVOR2Q1WVdEWjVmNHh4Tlo1dFRDbnFWMkRmdm9EdXR6SXNuaCtTYlFEbkpQ?=
 =?utf-8?B?R0tZL3Q4L1hyamZQZk56WndkRjkrL1BDaXZlNHBpYjZ2eWN4Q0VuOFFmOC9J?=
 =?utf-8?B?N0hKam1IVmkxZzhQbldRN08yQnZXV2FmdGx4SmhYd2ZmL0U0cmE1Q01zUUNC?=
 =?utf-8?B?Q2ZtYUhZRXVnZXNJN0tWUjlRTGZ6VTJWWERJbDBRWmZSZVRxL3MwMk41Zlg3?=
 =?utf-8?B?MUs2cS9ERENCMy9IOWJwaHZOamdacnRmZnZqZDI3NkNCc2JZRVBvR3lFNUVL?=
 =?utf-8?B?NVpVZEtaVUxEUHFsQVhGUEkxMVJmQVc5a0I5MlIwMHBOUFJDUGx6d2hUZ1pU?=
 =?utf-8?B?Y3FsVkVBOU9HZTlMczhCcDlIT05DS3lDMGF4Wk15Y0Y5MmF0TlNTSGZubTd0?=
 =?utf-8?B?RUxON2dLaW9tVnI3QlFSb2VMaUVWSnNUV0Z2RVpoQUZlbmFIak5ITFBBc2xw?=
 =?utf-8?B?VG5rdEtCV2tQdHJobFd1RFlXOEdHVlZLaDYwUXhaTnVuUGlFUCsvN1k4N3RD?=
 =?utf-8?B?a3kwSXdoM1FhY1Fsd09hbkZQalVlMjVYV1Jybk1OMzlYSDE2amdKM01PM0JB?=
 =?utf-8?B?VnBaUm1zeE5nUjg4THZFOUFubkxKalE4ajNoclhoQ3BzSENLbXI5VExJM0Mv?=
 =?utf-8?B?dlkyNFlzTDlvQSttek8rbkRwcmhoeUxMSkljczVsdlU1b1o0L2g0cEhXajlz?=
 =?utf-8?B?WEhWU0V4bHNLWTNYa2lMYlNHRFo5d0QxMVFHaDRPV2x1cGJOcVVKQ1ByQVpj?=
 =?utf-8?B?NWV6WDN1V0VKS0FsRFJPQXZMRFhra3huRVM4S1FOK0M0VWdaalZxVjVrV0RP?=
 =?utf-8?Q?k8CqseGf00q7PCdVhK4F7FQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnFHbHpDNHlUejcyc2RQRkp6UnRRalNScVpWbDdxRjJxR3lzQzJCbWZLVzNu?=
 =?utf-8?B?dlNEYTZkWmpkejRBZjkwdXJuMVV2OVZPdkFETTk0ZU0wSXUvSG96ODkvb2tR?=
 =?utf-8?B?amRiZUhmS2swams0WE1HSWdBM3ZoMHA1aDhWVCtheUZ1UmRJQVNLcTFjU2du?=
 =?utf-8?B?cjhaRWpMWlFsZzliSFR3enFuczlRUStoc2VwOURpbldxYzZZbldyL3JkQ1JC?=
 =?utf-8?B?Qkd1eUZRRk5hTDQ0aTdwYWZBTGJhanVlcTE5MnVpd0FpYndsU1FKSjQwRE16?=
 =?utf-8?B?eVl6T1ZKV0RvWEFGbDdPeWxBdDBZbE9IdHN5WG1FZm8zeFVTTm9GNWszRFFu?=
 =?utf-8?B?MFBLQi9PcGpITjdoNmtJTUNDdS82S2k5eWlhaG9iQWxaWU1DV3h6YWNCUVVP?=
 =?utf-8?B?OXh6OGFWQ0hTOXJTQzN6RWlGekJHNlB5YTRuSHFkaHBYblRFYkpBUUttRVhy?=
 =?utf-8?B?U3Y0enNsSjk0eXZvOVJsQTN2bWoydUhSejhoK0h4aVhjNXMwUC9iS0ttWmFN?=
 =?utf-8?B?OWFCRHJnR09NUGxWTFVLeStmRzNCUFN5SFFqQ3A1VUw3Yit6dEJaNUNyK1Jp?=
 =?utf-8?B?N0RxUlFyU2I2R3FsdkVydXV1dE03T2E0WUpIbElrR205ck50ZmNORFJCY0JQ?=
 =?utf-8?B?dFVuM0tGNnlMUm9tdUVYb25HZEFKU1B3T29hS1EyamkycExpdno3cHJxTHpP?=
 =?utf-8?B?bUYxendHRGl3TVJCR2QxYktVQzZsNng3RWdiVDJVajAvRFIzOW4weW5KSFVZ?=
 =?utf-8?B?bFh1TllaY0JEVlFod1UxLzZXampWZFpiMkJwUUFnNXl2TEhzcUNERjZCNHhr?=
 =?utf-8?B?VzN3Z1RmaGxKcUQ0TTd1TDlHUjJSdW1nWXdaRnk1VjUxbHV4bldBWUYyQWI5?=
 =?utf-8?B?SFdvNFhmVXRzR3JzWERwVUc3c2k2ZzJZWU94Q25TZFhPd0Exd3UwTU1Qemps?=
 =?utf-8?B?TWdYR28rWmQ4MmdjM1UrU2taMDZBc3RmRzZ6VVpneUJkTTVjUmlSSGhtM2hI?=
 =?utf-8?B?OTF1T2tiT0E3c1A5dHNhT1hGWm5haUgxQk9pbE9uVEFBeGpZZGxNbHFnZjVK?=
 =?utf-8?B?SFk1V2x6eHJrU20yNWpsS1JSV1JKTUJYY282VllqbDdNZjAvNFBCL0lwR0VT?=
 =?utf-8?B?NEVsWDBtdGV4aVN6SHVkNWVKVWR6bzhabVhBOW5iMFJoY0ltUFJpOGt0aERy?=
 =?utf-8?B?S1JOalJ1ZTMwUk5lRFdIY1pJeFc3VCtCcWFXZVhnTVQvalJ5Q1FITlF4Vno1?=
 =?utf-8?B?K2J3MW95d3o4VXRYTlR1Nm1NSUFocHhvdnBYeHJ6bGxha0t0dVl5OVhxbys3?=
 =?utf-8?B?K0JlRk45c1RlQW5BOHNVWFRVaUpXK0FoSm9QOHFoWjgzalNpNjBPb2dKVUw5?=
 =?utf-8?B?L2dFS3JCc1cxZWpnMk80YmZVaSsyOWYyUURvaitlM2c5RDRnRXl1eE1kZnhR?=
 =?utf-8?B?a0hMYkt2WEFFYStkV3JSRlFadlFZUHU4Y2FkSGZib0p2ZTh1YUdqQnBnT0Rt?=
 =?utf-8?B?Z0UrdWhKREtXU3hNbDFaZGxVZnF4blUyVGErc3ErK081RDI1UTc3WEYwTGVS?=
 =?utf-8?B?K1NNRDBGeWVwSm9QOVhmTVhQRlNEeXdDV3BrT21mZXkxaHhxcHFZa1ZidXJo?=
 =?utf-8?B?by90M0hvdFByenpEd3dWdHA2VlJ4T2VuTDR2N3hqRnRJUnFvZjBOUHFXSUxU?=
 =?utf-8?B?bnBIbkhUcFpjb3JmMGZUa3hCcTZaSk9QZVlXUDZ4RVpsSnRmb0gvMUtCTDM5?=
 =?utf-8?B?MWlDUk90aTAxMXNaSkJBN3BmKzZIelI2UnRLcCtmd1NDdWk3ZlE2N0dRT0Nn?=
 =?utf-8?B?VTJRbFNBUXgzejhRUmduMGIvbUdmeStnU29xckN4U1RZNHlGT0RoTXRoSWdo?=
 =?utf-8?B?RWNWRFB6RnNYdElGRXpIU2JJajdZYmZ2SktGRXpBVERyTVBxN05xVU9kc3NU?=
 =?utf-8?B?T3JqYTRBUHBxK1VHQng5OE9KNmxDMVkrb2F6TEwyYkNZdmw5VXkrSnlFRCtm?=
 =?utf-8?B?SllHdnNHNC8vTlpiZXk4NVdhaTVRR3V0dzUxbDlGUXVsR29XbngybVNidFZ5?=
 =?utf-8?B?ZnhnZVBlS1JnYXpDSEQ3MkFqeVd2alFJMng2eEZqWXk0eGNvWUR4KzF1VXZk?=
 =?utf-8?B?YTBXWGUvVWhHL1Yxam16aHlxWXNlWUt1MURRM0U4ejJrU1oxaUZEbnp1VGFM?=
 =?utf-8?B?Q3lzSkdYVFl6K2pZUFRoSmxCNzBvU1p1SGdkOXlEZnFuMzJIMG4rcVdtUHNB?=
 =?utf-8?B?RnJKWkd0RU94M01vTFhGVkIxRHp0SGRsWFliR0FUVTR6L1J0UGpJOWduNlBU?=
 =?utf-8?B?c1hOQXFBRjYyVmh5WGdrNzBhdTNoSkJ1UFdHcWNqcXc2ZU5Db3ZCUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6CE1209A007764F836F2F1224C1D9CB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aeeb6be-ff6f-47ca-7280-08de6892d5fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2026 10:54:59.7550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4A4Zf2wuKdQMLhdz/TrCKQNJfY/R5kos83ahWVkqCTB5ch7SZoujUSnmknbMttkGVac4/0xAO67CID6juXPEnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6141
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70722-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: F122C119E73
X-Rspamd-Action: no action

PiANCj4gRG9lc24ndCB3b3JrLCBiZWNhdXNlIHNwLT5leHRlcm5hbF9zcHQgd2lsbCBiZSBub24t
TlVMTCB3aGVuIEtWTSBpcyBmcmVlaW5nDQo+IHVudXNlZCBwYWdlcyBpbiB0ZHBfbW11X3NwbGl0
X2h1Z2VfcGFnZXNfcm9vdCgpIGFuZCBrdm1fdGRwX21tdV9tYXAoKS4gIFRoYXQncw0KPiBzb2x2
YWJsZSwgYnV0IGl0J3MgcGFydCBvZiB0aGUgYXN5bW1ldHJ5IEkgZG9uJ3QgbG92ZS4gIEFGQUlD
VCwgdW5sZXNzIHdlIGRvDQo+IHNvbWV0aGluZyB0cnVseSBhd2Z1bCwgdGhlcmUncyBubyB3YXkg
dG8gYXZvaWQgaGF2aW5nIGNvbW1vbiBLVk0gZnJlZSB1bnVzZWQNCj4gUy1FUFQgcGFnZXMuDQo+
IA0KPiBUaGF0IHNhaWQsIHdoaWxlIEkgZG9uJ3QgbG92ZSB0aGUgYXN5bW1ldHJ5LCBpdCdzIG5v
dCBhIGRlYWwgYnJlYWtlciwgZXNwZWNpYWxseQ0KPiBpZiB3ZSBtYWtlIHRoZSBhc3ltbWV0cnkg
c3VwZXIgb2J2aW91cyBhbmQgY2xlYW5seSBkZWxpbmVhdGVkLiAgU3BlY2lmaWNhbGx5LCBpZg0K
PiB3ZSBkaWZmZXJlbnRpYXRlIGJldHdlZW4gZnJlZWluZyB1bnVzZWQgcGFnZSB0YWJsZXMgYW5k
IGZyZWVpbmcgdXNlZCAobGlua2VkIGF0DQo+IGFueSBwb2ludCkgcGFnZSB0YWJsZXMuDQo+IA0K
PiBUaGlzIHdvdWxkIGFsc28gYWxsb3cgdXMgdG8gYWRkcmVzcyB0aGUgbmFtaW5nIHRoYW4gWWFu
IGRvZXNuJ3QgbGlrZSBhcm91bmQNCj4gcmVjbGFpbV9leHRlcm5hbF9zcCgpLCBiZWNhdXNlIHdl
IGNvdWxkIGhhdmUgYm90aCBmcmVlX2V4dGVybmFsX3NwKCkgYW5kDQo+IGZyZWVfdW51c2VkX2V4
dGVybmFsX3NwdCgpLCB3aGVyZSB0aGUgbGFjayBvZiAidW51c2VkIiBnaXZlcyB0aGUgcmVhZGVy
IGEgaGludA0KPiB0aGF0IHRoZXJlJ3MgaW50ZXJlc3Rpbmcgd29yayB0byBiZSBkb25lIGZvciBp
bi11c2UgZXh0ZXJuYWwgcGFnZSB0YWJsZXMuDQo+IA0KPiBUaGlzIHdvbid0IGFwcGx5IGNsZWFu
bHkgZHVlIHRvIG90aGVyIGZpeHVwcy4gIEl0J3MgYWxzbyBhdDoNCg0KVGhhdCdzIGEgYml0IHVu
Zm9ydHVuYXRlLg0KDQpJIGhhdGUgdG8gc2F5LCBidXQgc2hvdWxkIHdlIGp1c3QgdXNlIG9wdGlv
biAxPyAgOi0pDQoNCkFzIERhdmUgbWVudGlvbmVkLCB3ZSBjYW4gYWx3YXlzIGltcHJvdmUgdGhl
IGxvY2tpbmcgd2hlbiB0aGVyZSdzIHJlYWwNCnBlcmZvcm1hbmNlIGlzc3VlLg0K

