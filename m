Return-Path: <kvm+bounces-62742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DDE9C4CD42
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 10:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9A62D4FAA6A
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 09:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C232FF66C;
	Tue, 11 Nov 2025 09:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nLKmIRK6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE472FB0AE;
	Tue, 11 Nov 2025 09:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762854786; cv=fail; b=g2jqdGOl3x5oWhBJ3WFNIHNOn6yg41PW+IaGs/Gxjq6QqJLGSzR/9Ayndwcc+kE6LO+K1GBt4MiKixz/gkLo9J6ik0h0iey8zRrzc3fRkEhRiYFG0oUOHLipni5HA2b+3O2Udk8YUXe7gIziVpBaIG97JrWlSqVnOGbX1nGUJoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762854786; c=relaxed/simple;
	bh=qBmD6GIku4ZPqSLA4GtA61cI+t8Bo+u7M9dy4PX+U5k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hVuz4ZUHWBtKKLwiGxakWMlrQwE8JVMF19ZtUbGcWp2wAjDgL+Qwy6YS1dyN63CYv5W1PlMK5qpBXnW2E/KOHzP8koI4E0p/8ZCRdm1x1TiojkeBrXKNjgpFEVVJK1MOpc3pAPLZ9Kmto6qTGqWfDPfCuvScAkPMp0Lpk5HZvSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nLKmIRK6; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762854784; x=1794390784;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qBmD6GIku4ZPqSLA4GtA61cI+t8Bo+u7M9dy4PX+U5k=;
  b=nLKmIRK6A4CWZ4LvLh+png3vTU0rAAh2vekuTS1eh0P+y5XROUI63wzT
   155lpjwTx6QrTVknElqDVITUmTChspy997ciR/DOb9MMTx3mVH+J2kuvZ
   MSLOVGr/X0bQ73j3v3xRJ1e6G9rfkyuttVAbA7yfj4Flmgg3xiJhDVia9
   lj1XNX+feef7nEtVkN5jU634eLQkX8PEYuoT9hgqtDKqAaoUMu7UK7/af
   VJ0UXVRUmaECmXFj19RNr3C/+YNfImw1pzSXq3n4tKiZeaC1zKr8zJt1e
   XeIxFNHtQ+QhBEJc1B1/hmqLBZg4X3lp9EXhvCM0ctRlKPLvkOUh8je72
   A==;
X-CSE-ConnectionGUID: JolLTg4rQDCyYQboms7V5w==
X-CSE-MsgGUID: HgurX2MaSKWNExXzPNdY2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="65005341"
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="65005341"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 01:53:03 -0800
X-CSE-ConnectionGUID: bi6Zq3nmRnKOY8TCM93xHg==
X-CSE-MsgGUID: QtBSM7MfR++NYnr8kgpiGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="188179388"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 01:53:03 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 01:53:02 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 01:53:02 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.57) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 01:53:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MF4JfDsejF93AUud9s6QOB+ltGEhd+K+4egfENeOvxdQ/Zr8SlmQ4G04v/nc9YVtNpYbGv9ma1+iEkWiv5ERPQkoRbQg2WleZAx7r3tYScxbFNwfdD9DNh+jTU2Ma16SLdivQZf7xD7baS3eJyGy2hkM3W5OEAnwFJBcH5lI+BTs0uOqhHNGzlra8AGsvm3vgsdAeEl4jCck+1QXywGJ1CZpMVqzlg68d3+N+qebdyJuwnN5+fP7Sv8gsAYLF5eA3akNU709aOhlJbpXjAQQT69dc5QHLm72nOPvXOEiK6OoFflwL3NEgXMUZ0I4FB6VWLoFBJ1p4SS3jgh0kE7RQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBmD6GIku4ZPqSLA4GtA61cI+t8Bo+u7M9dy4PX+U5k=;
 b=ahKZ7KrlA70Ym3M7BoAqBPiu5DJxE/2BmgeXJ/TJeq9PkkHxJt3MRFKHsDHTdtU4D44X8cQTMWns8Jzua+PM1ujFJn9jxS3Bot8LPv6PnhzYOmoO2iXaCEQjUdeOdc0aKIf+yPy9vnaHcZGA4CGjnvCxEiZFxCFtDLzV1F5V2DfrwRkkvTxLvQYIpzXk6E2TAaBWIOGFWW/neCXtWn+R/Y7zbakvusUEIRismnntYTNoT1K0IajytDFSXNcnlhcCKSS9y9P5qr4nj9biJ5j+gdNmDY2aSOIjdvekT7q7eUeTd5dMJIaV/l5rqE959zu56lMoQL9MW85P55l+o+nNzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BY1PR11MB8053.namprd11.prod.outlook.com (2603:10b6:a03:525::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 09:52:54 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Tue, 11 Nov 2025
 09:52:54 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "pgonda@google.com"
	<pgonda@google.com>
Subject: Re: [RFC PATCH v2 08/23] KVM: x86/tdp_mmu: Alloc external_spt page
 for mirror page table splitting
Thread-Topic: [RFC PATCH v2 08/23] KVM: x86/tdp_mmu: Alloc external_spt page
 for mirror page table splitting
Thread-Index: AQHcB3/ZiG/UW8CYfEyrm1+D4EYkRbTt0uOA
Date: Tue, 11 Nov 2025 09:52:54 +0000
Message-ID: <5559b6a10b9345b350a595a8d5c52c19062cd8dd.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094308.4551-1-yan.y.zhao@intel.com>
In-Reply-To: <20250807094308.4551-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BY1PR11MB8053:EE_
x-ms-office365-filtering-correlation-id: 4f4ed314-8bbe-4f36-9092-08de21081620
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MkQ1akdqSmRyWHdWRHhkZzFKQW4zeU9uZjBlOGl4cDk2OGNFOUQ0TDloaEMy?=
 =?utf-8?B?V3pRTm5kTTRJRnFURE9jdldMSWFqYlhmL1U5anlJTjJGVldlendMTlgvb0lV?=
 =?utf-8?B?TnBZQVl0blZ4M3UzYlUvdDNrbnQ3OGFKekY4N0hTcVBhalJnUzFIRnBJU3Nm?=
 =?utf-8?B?eFNmL0xaMlk3aWxTWVRYZE94dmY0UEtsY2lpYm5Eb1hSclJFWVlZbFIzSzVo?=
 =?utf-8?B?VWVGQ3laVWE5ejE3S1ZaQ29XWG9RZGZVOUdqcUUzcGdUb2hwbm9JUEJZUTJv?=
 =?utf-8?B?aDZ4VjB2d1dFQW1qYmtpSmloY3lsSmdLVDJzSWc1L2tqc0JMM3Q1aDBuOWFV?=
 =?utf-8?B?STM3OUJKZ2tKL3FYR09zc3ZOSnBlWHo1cUZCN1BtRnF4K1VCS0dpbkRVeXdB?=
 =?utf-8?B?NEtIYmpwVlNGcnpnMHNjTGZVR0k5U0Z4WU1CT2s2OFpvOVlrQVpaN1RXbElJ?=
 =?utf-8?B?RjdzUkJKMFFreTVPTTNRWUJ2RDlYeHdkQllKUGhVQy9IVm0vWWpuT0JBTUZk?=
 =?utf-8?B?bHFzQ0FRRHlMWjNZYUhoZkN2U08xejVkVlpjOHNkdW5oT3dRVUR0ck1JaXVL?=
 =?utf-8?B?VTNWNUpkWEJSMUF3eE5DS1pmMEw5aFpRUkRTNjZhUWplTUtNU3pqK1JKNk8x?=
 =?utf-8?B?MFFFcUhFM3hUanB4VkVZUmRqSlFrZWVweFk5bDR0OHh3NWU4enc3ZHhRWHBu?=
 =?utf-8?B?bmtxMmVUMVR5NzVmaHF3VkpLcnNxbkJ2c3JZTzhxdExXMFhLOUhlQ1NKYTZP?=
 =?utf-8?B?ZzZ0RTI0Q25oYUpQZkRvT3hVaUo3a0NtaDg2WmFIQVVic2R1NXQ5WC9URHlv?=
 =?utf-8?B?d203bU1FeVNKd1hFU0t3SVNKaCtiNGhMTGwrOW8xcVNZY0thSnZTbWhZVnhX?=
 =?utf-8?B?eU1oeitBQkErUkNrQVIybE9oM2RWSEFEdjFnM2cyQnhoMXBQbWlVL2lyOHMz?=
 =?utf-8?B?OUV1d1RReWlDRjduajFnbitQdDlrN3NWcU1rU1hySEQ0NTY2dUp1T3hIeUJV?=
 =?utf-8?B?U1V5aEpCclV4bUtwZ280MGdGVWIxM2wvRktQWlhFMmFMS3R4cE9VZTlyTU8v?=
 =?utf-8?B?b1pSRTN2K1dxV0ZjTkM3dlp2dzQzK1R0bVlBTWd4QnZNUlZYNXpCQTV2aWp4?=
 =?utf-8?B?dWllUlc1WEN3NHRLSDQxM1ZseFJIMDAyc2o0VnoxR1lNemtxTjJUeW5zMzdO?=
 =?utf-8?B?VEo1aHAwWnJ6OWFiY1o2b01UZTJVbHBJUlg0TEk5Q0I1NzlLQ3dhOE50bnNE?=
 =?utf-8?B?OXdQMXFPeDlSanIvWHMySFpzL1RjYWovaVQzd01SUG9MU0ljVHo2N2Z2bG1F?=
 =?utf-8?B?cUY4YURhRDhLZHc0aGxxeTFEODJPTjM0cnB6SEFvUUpadU5VYUIveXgvaFB0?=
 =?utf-8?B?T1EvbDNIZnVWMUcwaTlLU1FpQ2xLTFRacUcrOTc3SHJESml6Z00vaDJqZHl4?=
 =?utf-8?B?eSs1TzF4NWJtS3NBUHJNSDgveTU5U3RGd1BJaHJuUE9RbkZPcWluSXluTndZ?=
 =?utf-8?B?K3YrUTlVUXZSNHJNeEhhVUUvT1dhZUNmR3ljQmpzenNZYU5pRXJCV2RkdVpS?=
 =?utf-8?B?UG1SdjFpcFVzVjUrODZYMmZVMkk4UnBldnNlYyttUWNUdndjWXNadStWbEp2?=
 =?utf-8?B?d2NSVFRSVytrKzFtK3R6bEgwakY4NjFJSEpSTCtOUmE3ZmVRMnVXRnllMUZk?=
 =?utf-8?B?WDY4c29ibkpURXR5dHFHYjBwVUtPUFl1SXY5TGV4bm9rcDFmTVdDK21la2JH?=
 =?utf-8?B?Z2Z1WllLNy9tZjEvYlhZZ0xXTDlhdUJCczhXamZHNFB2emtKNFRIT3lrY2ZU?=
 =?utf-8?B?ck1VQVYreGxseWZJd2lPN2FPd2xHQkg4WWVvWjJHV0FIZG9yb3ZIcVJqMHNZ?=
 =?utf-8?B?NzRIMG5zT2cvdDhZbU1vYWtPMllYek1xRG9naDdJeDdBTWpXMWZrZlM3L3Ay?=
 =?utf-8?B?YVZDMzZSbldzMEd2QTZhMDNrWjU0MEo2UDhMZGtaU29xU2hyTWNqS2lDTWVK?=
 =?utf-8?B?L1VWNmg4elVGMTgzYytwREtWb3h2VDQ1Q2pWcytSQzNtUHV5OTk2b1dNVkR4?=
 =?utf-8?Q?/JSnoV?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkkvWGRIbkpGdkRDNlhmUXp4c2VlSk1heCtzSFJBOUtoVUJneldnWERwd0JI?=
 =?utf-8?B?K21hOGVUbTZRUDNnZDR0TFZOdG5VVmoxRWQxTWYwdE8wUk1GZ3dzR2psVzFU?=
 =?utf-8?B?L0xQVTZqcmZmK21Ic085a2Naakg3L3lrWitmK3VFcDJWcFFEVDhSYTI3dW9T?=
 =?utf-8?B?c2pVa3BuYTdvRUd4ZXBpdFhaazMvODNvQ1RGUGc3Zkwyd3FCT01YTGtVaTRW?=
 =?utf-8?B?R25YZytmdThhcmNhZ00vN1c2cmFIaWJiMWhRanpwTTVJYnBramZ4TktjNTRE?=
 =?utf-8?B?eW4vcHovMCs3b0l0Z1RvTkJOV2NtU3pZZGxZT0VMYUNadEU4SVZUV3NxSGxx?=
 =?utf-8?B?T2xNUURrSnVpcGxoWlZmbXRPU3VFTGxvSGRZUlhWeSszdGgzblo2L0ZtOXUv?=
 =?utf-8?B?RmgvVDZjZnVrVEZFVzI1Sm0wQlRNVkJMTkNCNHM2bTZrSUJXd2gySzNzZW96?=
 =?utf-8?B?cHltNU9VYWx0SHVoQzdSakpzNDJxOThuZTFEdHg1NEROUzAxS2hQVHBabUxQ?=
 =?utf-8?B?bGVncDRjdm1VTHFPQWhTVEI0VE9xci9WODY1SG9QRVV0MVdUcUw1TlVoM2Yr?=
 =?utf-8?B?S3B4UVlRM2FDN1ZBdWxrVUIrNTl6YWFIb0NZWDI2ZEpUOW5QV3Jac3d3VzNW?=
 =?utf-8?B?L0VlZ294UUJUZWVtUnMrc0gycDVtdVhXeHVOcGl2QnZNOGpPSmVObmpxY0g5?=
 =?utf-8?B?RUpDRHArMEsrSHlrdTBkbmc5YWVLcllQWWd6RFI1bWptd3FGTVlmUnlRaERK?=
 =?utf-8?B?RElnb2N5dSs4bnZnYXlPSXZzL2JmSUVUb2ZscElML3A4VXZpR1B5aVNxcmFZ?=
 =?utf-8?B?VElQeElTb2JFN2NqbzlLbCswRkxyQXdCZ1N4cUkyZUNxUWFkRjJGTGVxS2V0?=
 =?utf-8?B?MTJ1WGxlMjJ4ZUttbmVkWHM2OVkwRFVVL0tueWxkVXlNbm8xQm81MkF6ZHI0?=
 =?utf-8?B?SUthNjFIV0tkTVFIVlRWczd1U0NkbWM4YnRzUmxhbEdBa1ZrSkkzZzVUblhy?=
 =?utf-8?B?OHppS2xPYWVwT2p6cXBhYkU3QmlXUW5QbmN6UjhlRWZPcEhCb0lEeGwwLzlX?=
 =?utf-8?B?YTJmZmxhUnQ5V2huV3l3U3FxbVJxYWl2UXh1T2x3OU03WGNzZDFPalJRQVVB?=
 =?utf-8?B?bEsyM0UwQzY0Nll6RlE2RTE0R0piY08vUCtDOUF2czhxbmtXVGpzU3lOUUlZ?=
 =?utf-8?B?cTJHQ0w1TFJKRXJYblRZVm9rR3ZzQWVGc0NCNWk0cUxSdzhGYnY2elZhdnBL?=
 =?utf-8?B?eGU4WVVicWNxSHlWNWdtaEhHVmh4d1ZvU29GNWFEK1V5Y2VKRW1KOWZVZk9Y?=
 =?utf-8?B?a0lRZndhMWxNeGt6MFQ5M2tMdTRIZEhXNkNkNENnb09BTnVKWTI5SUZiNzRw?=
 =?utf-8?B?YmR6WmRucmozM3l0d1ZEL0lDeVI5dE14cG5uRmNJTE0vS1htWjVKR0NaQzhn?=
 =?utf-8?B?VzJ3cC93V1VXNnF3cDdnQnlkdkxyaHFjbWt0U1dYMUVCZ3U5K05Yd1h5Tkpx?=
 =?utf-8?B?RXFXWlRFZktScWZCenJ1d0tVeFJ3SzR1RU9Xd3FHdG9DeUJEL2I2NTR1cVY4?=
 =?utf-8?B?ejJCb2Z4REtENHpNUzd1Tjd5TVYydFpLLytTeWJNSXliaFZtc1FxSDVBL3dl?=
 =?utf-8?B?VU16ck9wc3hneEtwell4V1FwTjJ3c0hiMmVCcHRUbDVlRlJ3bkdkT3RFMGRW?=
 =?utf-8?B?TmV1S01Ody9LMUQ5Y2NQUldiV0JZTmdFV3BVNTdpYkROMG9OVGtYMEZsbkZB?=
 =?utf-8?B?elpISEtnN0pQT2NXaUJsZFlFZWpNTEVJS3FXWENGWjNpeklmUStmZFlUVjcv?=
 =?utf-8?B?d3l0eGkycWRGeTE3eXJBQ1dPQ0U5dDRoYmIyNkp0V1llMm1mTmJJQ0xHaVJQ?=
 =?utf-8?B?ajAzczZ5NEFKRjQ0ejBYYkdqVitZT2FPYmxISHNDbHhzOWEyNS9QbHJRNk9B?=
 =?utf-8?B?ajg3RkJ6R04ybDIrU3Rhb2FuY3BkTklTdVlOMFR6Zy85SjNZbXdhcC9MNkdk?=
 =?utf-8?B?RWZCVjkvN083TkpHSGNpZm1zRmp0NXVKa0tEZVJqaVdYQy9ZQzRCc2hiaG1m?=
 =?utf-8?B?czM0eVdUS2dITU1DeDJvQmJCdVpTTENmT3ZoVTlMQU5vZnJsZzFuUmtidGtp?=
 =?utf-8?Q?QHb8SCpsfZUidCss9I4i5skVL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66E8118E2ACC34498A999F7E217AD973@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f4ed314-8bbe-4f36-9092-08de21081620
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2025 09:52:54.7674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u66lNRQxTnL5m0Q2/qH+++ApW8klahDWI4d2yrSOSYbkKn+LLWXRkVA/cVRcMgaz3mR1l5oBwzEYtmjZb+XxCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8053
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTA3IGF0IDE3OjQzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gRnJv
bTogSXNha3UgWWFtYWhhdGEgPGlzYWt1LnlhbWFoYXRhQGludGVsLmNvbT4NCj4gDQo+IEVuaGFu
Y2UgdGRwX21tdV9hbGxvY19zcF9zcGxpdCgpIHRvIGFsbG9jYXRlIGEgcGFnZSBmb3Igc3AtPmV4
dGVybmFsX3NwdCwNCgkgIF4NCgkgIHRkcF9tbXVfYWxsb2Nfc3BfZm9yX3NwbGl0KCkNCg0KDQpb
Li4uXQ0KDQo+ICtzdGF0aWMgc3RydWN0IGt2bV9tbXVfcGFnZSAqdGRwX21tdV9hbGxvY19zcF9m
b3Jfc3BsaXQoYm9vbCBtaXJyb3IpOw0KPiArDQoNCkl0IGRvZXNuJ3Qgc2VlbSB5b3UgbmVlZCBz
dWNoIGRlY2xhcmF0aW9uIGluIF90aGlzXyBwYXRjaC4gIElmIGFueSBsYXRlcg0KcGF0Y2ggbmVl
ZHMgaXQsIHRoZW4gcGVyaGFwcyBpdCdzIGJldHRlciB0byBkbyBpbiB0aGF0IHBhdGNoLg0KDQo+
ICBzdGF0aWMgdm9pZCB0ZHBfYWNjb3VudF9tbXVfcGFnZShzdHJ1Y3Qga3ZtICprdm0sIHN0cnVj
dCBrdm1fbW11X3BhZ2UgKnNwKQ0KPiAgew0KPiAgCWt2bV9hY2NvdW50X3BndGFibGVfcGFnZXMo
KHZvaWQgKilzcC0+c3B0LCArMSk7DQo+IEBAIC0xNDc1LDcgKzE0NzcsNyBAQCBib29sIGt2bV90
ZHBfbW11X3dycHJvdF9zbG90KHN0cnVjdCBrdm0gKmt2bSwNCj4gIAlyZXR1cm4gc3B0ZV9zZXQ7
DQo+ICB9DQo+ICANCj4gLXN0YXRpYyBzdHJ1Y3Qga3ZtX21tdV9wYWdlICp0ZHBfbW11X2FsbG9j
X3NwX2Zvcl9zcGxpdCh2b2lkKQ0KPiArc3RhdGljIHN0cnVjdCBrdm1fbW11X3BhZ2UgKnRkcF9t
bXVfYWxsb2Nfc3BfZm9yX3NwbGl0KGJvb2wgbWlycm9yKQ0KPiAgew0KPiAgCXN0cnVjdCBrdm1f
bW11X3BhZ2UgKnNwOw0KPiAgDQo+IEBAIC0xNDg5LDYgKzE0OTEsMTUgQEAgc3RhdGljIHN0cnVj
dCBrdm1fbW11X3BhZ2UgKnRkcF9tbXVfYWxsb2Nfc3BfZm9yX3NwbGl0KHZvaWQpDQo+ICAJCXJl
dHVybiBOVUxMOw0KPiAgCX0NCj4gIA0KPiArCWlmIChtaXJyb3IpIHsNCj4gKwkJc3AtPmV4dGVy
bmFsX3NwdCA9ICh2b2lkICopZ2V0X3plcm9lZF9wYWdlKEdGUF9LRVJORUxfQUNDT1VOVCk7DQo+
ICsJCWlmICghc3AtPmV4dGVybmFsX3NwdCkgew0KPiArCQkJZnJlZV9wYWdlKCh1bnNpZ25lZCBs
b25nKXNwLT5zcHQpOw0KPiArCQkJa21lbV9jYWNoZV9mcmVlKG1tdV9wYWdlX2hlYWRlcl9jYWNo
ZSwgc3ApOw0KPiArCQkJcmV0dXJuIE5VTEw7DQo+ICsJCX0NCj4gKwl9DQo+ICsNCj4gIAlyZXR1
cm4gc3A7DQo+ICB9DQo+ICANCj4gQEAgLTE1NjgsNyArMTU3OSw3IEBAIHN0YXRpYyBpbnQgdGRw
X21tdV9zcGxpdF9odWdlX3BhZ2VzX3Jvb3Qoc3RydWN0IGt2bSAqa3ZtLA0KPiAgCQkJZWxzZQ0K
PiAgCQkJCXdyaXRlX3VubG9jaygma3ZtLT5tbXVfbG9jayk7DQo+ICANCj4gLQkJCXNwID0gdGRw
X21tdV9hbGxvY19zcF9mb3Jfc3BsaXQoKTsNCj4gKwkJCXNwID0gdGRwX21tdV9hbGxvY19zcF9m
b3Jfc3BsaXQoaXNfbWlycm9yX3NwKHJvb3QpKTsNCj4gIA0KPiAgCQkJaWYgKHNoYXJlZCkNCj4g
IAkJCQlyZWFkX2xvY2soJmt2bS0+bW11X2xvY2spOw0K

