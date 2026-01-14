Return-Path: <kvm+bounces-68017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A4C7D1E7C3
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 12:43:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 85EC430223FC
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 11:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F73396B6A;
	Wed, 14 Jan 2026 11:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hSPKae96"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F88A393DC0
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 11:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768390621; cv=fail; b=Wj+PQEH5laA4behK7TN4r7TRAPTuP+WJ2+dGHQQuncnmk8mA/HXXGsf+harc3XCHNNydsOuO2f2fIPqbEL9hcPP10JWBct+LLNdMJhRJa/TVzlCPNKMPO+rANngBahK1H3IF6YYFLAQ7APfxpEzPGhJcCCuFT5dlsevGhE8wwfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768390621; c=relaxed/simple;
	bh=aSIwsSDUVQXPCpbZyiWxKm3uoywffo4U2tNQ8Su23bc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J5K7/fyFDLzLvH4lICzTcaljTZ7bboME2+N7pHNdGoRmnc+2htNpCteLKhIm/8xRB9J0xSQbimqpV1ajB4UYeMN49ez11vsGEfekPh4IoI3foN9zGgNVHLrvxaIogAMjqUGOpkmPTTQ+ZLi4dRe2M5KeGrFlI9Edj3XH5uqQlNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hSPKae96; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768390620; x=1799926620;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aSIwsSDUVQXPCpbZyiWxKm3uoywffo4U2tNQ8Su23bc=;
  b=hSPKae9659EIWYSY7M8wmkY2h+txEtwCiUk+TDv/2Jztndvyn3cFDuUZ
   5ynhIA+qriGkgQatNbG1168bdx4aiOFsdVafyxakFFrFT4vOoAJuGdGbY
   ep5NXNw7znuyE1VkJi0IJiVwPuUjryRUtomf7su3ez+anNbB8yxr+AAui
   EKx8esu+Q1fQKF4GGZFvrGx1LwGOpiz9T5dfj2dwPZIhVMWbTQaCKLcOd
   ZqVo2/jrzDl9kt7dWU95atX5sttRlcwds+5cEdSyt9fRYcRWfAsm/0kD9
   JjSIH/LLPBwzkp1y767BcvdH7VSt+lgguZCrp/X6od/NoFXZJTPHfUvHs
   A==;
X-CSE-ConnectionGUID: yFScZjdoQmu+PMeps2LXNg==
X-CSE-MsgGUID: Fw5pCK2FSMetQPbvqmTfOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="73527128"
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="73527128"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 03:37:00 -0800
X-CSE-ConnectionGUID: 5eU+Y695Q+KKvdWu1jBVAg==
X-CSE-MsgGUID: RdlTq3XhSbOFzeayUjKOdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="203794302"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 03:37:00 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 03:36:58 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 03:36:58 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.22) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 03:36:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NksuJ7GIkQSk3BPfRUvSIUFkw0dfVmmqyYxL8dMY0LHgtr/djMCnMcJBmMNZjWez87W7Cz6JX2w3SiQhvQ5Fn2j0DeLsBjJDnUJn/Ev9jRX+R+ILRY4JSeCRdZ4Q8AEcYe/a2f/GW7H6+p058pkCGWuXPoVgtYqJZw7dfRn/rRLG44SEaSe/D+a1mkhL7QrZCzmzj8qSUMSQ7cXK9kujvBhryug+IN5DGrYh+0yEoRkhYgr9dJaT3e7ml9QX7OfKGf/vAhnaWEsop33rMZDQGr4qaXbmMkI/gm23HWq5VxPomjLSdFHCtYYPKmnESTYebIMvKuHLS9LZmeNY5LGbSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aSIwsSDUVQXPCpbZyiWxKm3uoywffo4U2tNQ8Su23bc=;
 b=fbpJjxUxhZPfe8Zhqlg9a5c7vlyfuTzgLtxT1XVs3vpJFf7mITcztEKjxkEXEhoBhHQhV8u5q+SOpMuVs3jto1JZef1bIXf5pMQoYKQQbIC1VJZUXj4sQC0m2Ip2tOruJPqqdUKsO+Fu/aTwTB+7JiuuCZyLen+Z95yvMWrietcoT3lSqSDne40ce8+rTgJM057SyU82/QK37v7FL8581cAHfcyClKr65O6FldQZkCBcpEr4ymTiOdpr7oB9Pzc3mFTOShRGGLXPuKqJDlBtdrhThsvTYNeo/b5ocjuzev8CbpbWEZSLDln2CdBIQrrulsUW8OzQC3Y+WzsPlWbVBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS7PR11MB6222.namprd11.prod.outlook.com (2603:10b6:8:99::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 11:36:56 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 11:36:56 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v5 8/8] selftests: KVM: x86: Add SEV PML dirty logging
 test
Thread-Topic: [PATCH v5 8/8] selftests: KVM: x86: Add SEV PML dirty logging
 test
Thread-Index: AQHcfg3Ksg3b7MbuXEKHnzTmKR2E4rVRmA2A
Date: Wed, 14 Jan 2026 11:36:56 +0000
Message-ID: <d035cbc079a777d25863b78e9583c238fff03f9e.camel@intel.com>
References: <20260105063622.894410-1-nikunj@amd.com>
	 <20260105063622.894410-9-nikunj@amd.com>
In-Reply-To: <20260105063622.894410-9-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS7PR11MB6222:EE_
x-ms-office365-filtering-correlation-id: bd4300d8-1c9c-4dc8-7f97-08de536138c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?M2ZITVJFcWY4S01BZW5RZDMyTGVTQ284R1NPQmcvdUFSbjE5NzFaMFJJaXhZ?=
 =?utf-8?B?NERRYVpLTFhGSHVVRDJiZ2IxeFlQN3N3UkhqYzZPTEFJV3FhSXNQZkVhWkpE?=
 =?utf-8?B?RlpKdGZ2QkFneDB1QW9wTXdpS3k3STFSTlpPMFN2VTlNRFNLSXFGYndQejMw?=
 =?utf-8?B?ZGxpdVlldjFJdE8zSDJKNWpqdzJmRituWFJweDZ0N2hnYUIxKyt1WXlNVkRM?=
 =?utf-8?B?RmE4M1ZtRG1WUFRESWFVajVjZ1V6WGJQRUNhaGxQdUZtZzluUnYyTlVYT1pX?=
 =?utf-8?B?Vk0rSHkrZUxUc2QxMHUrd01qK21ZbTEzams2NC93d0htRlF0Sjk0elFlSnMx?=
 =?utf-8?B?clFvc0piaXhyUjVmaWZUUzhySER5YWMvRXBoajI1VTY1R01KejMvbExISFFY?=
 =?utf-8?B?cWNUSHpJbTVpMG5RREJJM2N1VTFzVmpBYWxEUWQyemZuSzQrVDQvQWNiOCsx?=
 =?utf-8?B?eEZ1bmhzTlkzS09jR21MbW9WV292VmJVc2l6eHUxM25JSUFNSmlkbkRGWElX?=
 =?utf-8?B?enh2dkxETEVUOFNPZHVxUHpEUksrVHR4eVV6VkdxdWY5dFEzT083ZjdGbzg5?=
 =?utf-8?B?MU4zN0VSKzAxa3VIQngzV1A0cnVqVC9DT204U0d0SmY0ZlJndXFhaHdTTFRQ?=
 =?utf-8?B?SU42UWtOcVBYZ005TTh0SWVjRUxFeUxqVHhiZGNRTUxlYUFscFVjaXdNR1Q5?=
 =?utf-8?B?dXYvNEU5SE9XNTgycjBhaWVTY253TGhodytJdC9POGdCamZKK2N4OFJNUHN2?=
 =?utf-8?B?ZE8rRHllSnFXdU0vcEtWMGNhNFovMTgzY0pDR2V4L2hFc2FIZU1XSXJMN3lS?=
 =?utf-8?B?YW9sZW5LVFRCZEpvc0VaZzI0c3FWLzYxL0RFMTA5VnE1VS9UcUJma1hvdXNo?=
 =?utf-8?B?Z0tFenNKdWhvSm93emdmYkpFVUE5QjNrNERBNFJnUnVSL1hmbWpBQkZSQnF6?=
 =?utf-8?B?NmhGOWMrN2RKTVF4VUQ3VjY3cGZlNkxlY3ZUMG4wN09uZGd4OHRSY0dBdzEy?=
 =?utf-8?B?YTc1L3ZBR2srT1dTUlBPODdpVWJGdStPUmQzWTEwWlZTR29jdEtkUXhsbkNQ?=
 =?utf-8?B?NGJjL2M4dmFwM1BMWXVEc1F4Z3VaL1ZrUzh5RU9aN0NYZ2FCalE3eDVaOEpO?=
 =?utf-8?B?SHNtVTROWDZ5NnhqTEg4OHA3cUpTdWpHd1psSzIzd0dZWUc1cmF0Q2N4L01O?=
 =?utf-8?B?S1dPSVZMZ2lEdjFaTzRlcFpkaWNBeklFWk9qdE5LNjNXWGkxS2pYVVN6dVRH?=
 =?utf-8?B?SzRLYk9pazZHekdJZzhoSmw1N0Yrb09HSzhiZGl4TGlZWkVCQVR2U09BZXhj?=
 =?utf-8?B?L3hPSHYvQ05qVllwYnhadXpCZDc2V1V3cGJKRmZhMGFqTkN3cVlDV2E3dWdy?=
 =?utf-8?B?OXBnbjJGYmlxTG9QMnowWXExVyt4aVVNQzgvblJCRVpjVitrRkEydExRWC9x?=
 =?utf-8?B?eWlqWjVFZmtjekVhUTFXbytCL2twbWliWnF3Zyt1dlBrdVlYSGc1bDI4S3Ey?=
 =?utf-8?B?S1JTRkxHcjFibjRNV256ZS95VEp3d2Z1RzdKRWxYQUtWbmxmRzhIT1liQmRu?=
 =?utf-8?B?azVFSWRuTWROV05PdCtGbGFaa3l3YitQTTI5YTNyRCs1dXZyckVFcnZoaHFy?=
 =?utf-8?B?SGRidFZWN0thNG4zb0pWRlcrbS90VFNtbThFbFJJUEpnS2ZyVTVKNWxicE9Z?=
 =?utf-8?B?d3dZRXdteGJmUFVBL0tDRFZSSG03M3NjZkg1cDZnTlhjb0Y1YXR1QTNTL3RZ?=
 =?utf-8?B?SnJBdkJMeG5EdDdMS0pjZnJJOTR2aS82eHB3TGxEWTRYSnlNa2NTdmx2UC9s?=
 =?utf-8?B?MHdFVStKYldQS1RaWk9RQld6YmNqZE1BcTUzQzdQL1NTTXlkMkgvblRrQ3B4?=
 =?utf-8?B?WFd0U0FsTEFiQWZsNHJXYXNCQUx4M2hDM1ppa21hUDhjdU1US0RpcGJ4WHBi?=
 =?utf-8?B?TzgwR0pNZTlOa1A4RUcva1ByTWVMRnptOWNLelVjMmw0OGlMNUE2VjhZRTRZ?=
 =?utf-8?B?UDBMUG9NWUxVVHdZOW1vREdncCtUend0bGpkRzRLeDNWYUtvOEJBWnpkUXdK?=
 =?utf-8?B?VDQwODBRQjF2eEc4YVdNc3ZoSUtldGVWdUpsTTY3UVRzRzdzUHJ0Vm9MSHFy?=
 =?utf-8?B?U1ZiSWh3eUxqM0tjMDB5cFlQbGVOMXZTMFdFaFA2dTVoaE5YdGIwTGY1Wi9Q?=
 =?utf-8?Q?qGLLaKqpyoKERmaW2GfuLUU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXhicU9tYXlESHZwRXhnMXZXTnZ1UXlJSTVVYm9YdWw5anB2UzYxSWpzU1hC?=
 =?utf-8?B?RC9BNVRoU1dZNEVsejczVWd2MDZrZDEvY29HM01kVEU0SmorTGIyZnV4enpw?=
 =?utf-8?B?K3JYM2Zkam45VUFINU04Sk5ZREx6T285R29KekRyNTFCNHVId0pPbGxHc2dH?=
 =?utf-8?B?TlVGTFFWZmRmVDF1a0JQdHk0TnpIUk5WUEcrMEg3TWphblpqa0N0Qi92ZUhV?=
 =?utf-8?B?OGNPSmhPUE9iNzZWeGx6UXRiSmxDTWdHb3ljT2FDNzVIVGZtMjFpaFNOcGtQ?=
 =?utf-8?B?M0w1cUFEUHlEazcvQk9uU29mRldoWnZNSWpjS1d0emd2UkVVamdSVTU4ekM0?=
 =?utf-8?B?dHh1c2NkUzFVb0FZS01uYzRIVGV2VG5mY1ZRLy9hQktuTnFsc3c5NHgxWnBk?=
 =?utf-8?B?bFVIZjk2am9wbGhZbWp3UWxvWXFFSjNKSkZjMnJ5QXBrYjN2cXltMEQrL09S?=
 =?utf-8?B?c3NURTFYQzh2SXovd1pIc1NDTzdmcVRMS1RUejBEaG5JMUZseUIzZ0I0SEJl?=
 =?utf-8?B?U1NTMkNjRzhSL000dWN3blIyaEtCZXNyUnN4enZaMitUY3o3aEZxbGwwNnJ1?=
 =?utf-8?B?emVyeHlVRkF5VDdrREpRWUZpajJFVTNseXF6eE1PR3h4Z085emNoNTdUQnBn?=
 =?utf-8?B?V2RPYXNBc2pDcWJWMFo4NjVoNS84bFUrdFFWbjRaQytSSEtFZys5Z3NGNDg0?=
 =?utf-8?B?dkR3amM3VE9BbUtIVnhuMUNCcnI1WUJlZ01HMmI1TXdQSDdiWGZ6MHJORmdh?=
 =?utf-8?B?ZDFnZjlrTGEyblpSQnVXL2RmaXQ4d3dvUG5OVU1tdExFcXFzR3FYVy9KSnM0?=
 =?utf-8?B?bS9mTlN3dDNCWGluYm1CbUNVUDI1bFQzK0pPTzRIa1FGVGtSRmdlbTlhbWNU?=
 =?utf-8?B?VDRFN3JXMEpLQnlwYWtOeUNIRzNVNFpDVWVyUmdveGNTdUJRY3oyRDJUUUxC?=
 =?utf-8?B?UmhsZmFXd1lGZVlxdjJlSmNzZU9rbUFxcFBha0VjUmJ3Mjg2WC9lRHY4eUVk?=
 =?utf-8?B?UVd3Z0MxbW1hQzNwbTRrbjJhaDlGOGJmNE9EeUhsdVNoMG5ISkF1eDNDZjFu?=
 =?utf-8?B?M2dPaDl3dlZKNVNMdkFyRjI3dFVDeDNaYXR4VnExQ3ZDeFJ6ZEI4VmNjYlBw?=
 =?utf-8?B?SmdONWx1MkFqNjg3Zng1bHBNakhXZmlpMys4dUpxQjZ0WXlKeG5KWmpNRlor?=
 =?utf-8?B?L1dESHBGQWJhZEVUSkR4WHlPYjN2c3N5UDhmZEsrdHFVWWtxY055TW9SbHhB?=
 =?utf-8?B?Y0tsZzdEemFCNnEzdzRtY0NjRHZwN01URWIyWnRyNHJmYjhKVzZadjlEbFRi?=
 =?utf-8?B?N3VKS1JKV0gvNTJjaWZoREJFR25IbWZEQkhLeTArSGdZeGI1cXRzWHFHZ0pp?=
 =?utf-8?B?bEZ5QUNtQm1aUFdQc2lOeDNsdFdqV3dZU1JkREkwaVZxemRKdy93blB1UEFh?=
 =?utf-8?B?SzRMRm9kMG1WcE1Lc3hzaHJDNWRLa3lremFmTktxd1FTd0FQSDIwTjFjWnFO?=
 =?utf-8?B?VVVhczVETSs0ZXhva1pRQVB2bGljUzJKREtiTzNXbU1BVDl4ZUd3TVRIbjJP?=
 =?utf-8?B?VzBwYXhSRGtJUFNHMEVZY0NBdk1RZlpPTWJlakpPUWZYVFVxVVB6OUNpTlMv?=
 =?utf-8?B?NHdEcWxOcHRSaXArTWhQSFZSb3NpZGduVEpBTkl5WHlnRklNN0svUDBBVTh5?=
 =?utf-8?B?UnlQR0QwUUpmQWkrbmdlZExzYStCeVBYU21TTUhYK2NDdm5ySEFKSk5DWi9a?=
 =?utf-8?B?M2xRWEdia0dFeWF3OXhCK0w3QWdIRXgvVVpHLytSeTBNUk44NlFNaDljajVz?=
 =?utf-8?B?TkFIT1ZOVitPMzBhNWIvY3VHZy92b3BhVFJCcTFkdThJRW1FaGZmQVBVSWNm?=
 =?utf-8?B?aXlJTlRuKy9Bam1wbDMyRkV2ZkJGYkJlWlg3anpQTy82bUFEL3N2VVhjV2Jm?=
 =?utf-8?B?TDh0ZWg5ZTZ5OHhWdk1tbEFRUWsrTFRQWm9DK1RFZDYyMVpsNjJHSWRIZ3M1?=
 =?utf-8?B?TXhtWnlCalNrcG9DTWlmTzlJUjRucmROUk1MbjNEMDRmL3hyeXJ3M2YwZ3dL?=
 =?utf-8?B?OXpnZnBPZExiLzY4QndaOUVoeU94dTZkL0NjYk91TzF0RFJ1NlFSV2xpT3Z5?=
 =?utf-8?B?RzFXN2hNejZLSHhTV1dWQWxudUUrUFNOdS9kbXNuSmdCK1dzVTVodmpqVkx0?=
 =?utf-8?B?N0tFa2p6S0VlSUF1aXA1NVFGU1FxRHZnV1pzZVRaS3k4ZnNqZFFiM2UxWkQx?=
 =?utf-8?B?RGZqaG1aMDVsb292bVhJK285dnZuY2VmYlBFVVk3T2poSkJhRUFyMzBYbGFW?=
 =?utf-8?B?Tk9JN0pCQlB2OExMbXFoK25iOTA0ckJCQ2hhMjI3LzBjbi96QTdLZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B85F9371EA9B74286F7FBF97ACC8BAF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd4300d8-1c9c-4dc8-7f97-08de536138c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2026 11:36:56.2522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T7DUFe4cHGMmGSBUw17UiBm3Rn9Arjuligz3zWhJRX2z/I9CFEZuNtAJOTRcoIzAPn7WDKwtf4E30J3/UYW3Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6222
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI2LTAxLTA1IGF0IDA2OjM2ICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gQWRkIGEgS1ZNIHNlbGZ0ZXN0IHRvIHZlcmlmeSBQYWdlIE1vZGlmaWNhdGlvbiBMb2dn
aW5nIChQTUwpIGZ1bmN0aW9uYWxpdHkNCj4gd2l0aCBBTUQgU0VWL1NFVi1FUy9TRVYtU05QIGd1
ZXN0cy4gVGhlIHRlc3QgdmFsaWRhdGVzIHRoYXQNCj4gaGFyZHdhcmUtYXNzaXN0ZWQgZGlydHkg
cGFnZSB0cmFja2luZyB3b3JrcyBjb3JyZWN0bHkgYWNyb3NzIGRpZmZlcmVudCBTRVYNCj4gZ3Vl
c3QgdHlwZXMuDQoNCkhpIE5pa3VuaiwNCg0KUGVyaGFwcyBhIGR1bWIgcXVlc3Rpb24gLS0gV2h5
IGRvIHdlIG5lZWQgc3BlY2lmaWMgc2VsZnRlc3QgY2FzZSBmb3IgU0VWKg0KZ3Vlc3RzPw0KDQpJ
biB0ZXJtcyBvZiBHUEEgbG9nZ2luZywgbXkgdW5kZXJzdGFuZGluZyBpcyB0aGVyZSdzIG5vIGRp
ZmZlcmVuY2UgYmV0d2Vlbg0Kbm9ybWFsIEFNRCBTVk0gZ3Vlc3RzIGFuZCBTRVYqIGd1ZXN0cyBm
cm9tIGhhcmR3YXJlJ3MgcG9pbnQgb2Ygdmlldy4gIFNvDQppZiBQTUwgd29ya3MgZm9yIG5vcm1h
bCBBTUQgU1ZNIGd1ZXN0cywgaXQgc2hvdWxkIHdvcmsgZm9yIFNFViogZ3Vlc3RzLA0Kbm8/DQoN
CkZXSVcsIGEgbW9yZSByZWFzb25hYmxlIHNlbGZ0ZXN0IGNhc2UgaXMgd2UgcHJvYmFibHkgbmVl
ZCBhIEFNRCB2ZXJzaW9uIG9mDQp2bXhfZGlydHlfbG9nX3Rlc3QuY1sqXSwgd2hpY2ggdmVyaWZp
ZXMgUE1MIGlzIGluZGVlZCBub3QgZW5hYmxlZCB3aGVuIEwyDQpydW5zLg0KDQpbKl06IHNlZSBj
b21taXQgMDk0NDQ0MjA0NTcwICgic2VsZnRlc3RzOiBrdm06IGFkZCB0ZXN0IGZvciBkaXJ0eSBs
b2dnaW5nDQppbnNpZGUgbmVzdGVkIGd1ZXN0cyIpLg0K

