Return-Path: <kvm+bounces-69988-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8EL5GZHQgWl1JwMAu9opvQ
	(envelope-from <kvm+bounces-69988-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 11:40:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D89AFD7DA5
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 11:40:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 71FCD31C56D9
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 10:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DA6132937E;
	Tue,  3 Feb 2026 10:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Of7AgWHp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A80531D725;
	Tue,  3 Feb 2026 10:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770114660; cv=fail; b=ZpoUFYoxjYum2Gc+b7DNRLayXWcyEjzsG9/giM0zEvTf95DND2B46rNwUJGjJlY2DwQ2fA67wMYrar8a9KUcc9h7ku7ly6qN62NLmOuDqB1ebOwOuK7XNJzjGatVLfTOAaTpsUlYcQLdWCBMdpVZKOdVTjVbxMI9Hf0bhfs2LH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770114660; c=relaxed/simple;
	bh=WTWRfao0EKOvH/1+3I/qLineiptMnRDBDE9chnBGQco=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SRFI2x+QeNpvlEcMYC1a+YzNo5vc5eq8YBc7d4ORs/dWHHoPAYwGpDrISAujPu+X+HA+9XE9CnquozhfPLgFP9MuRH0pSdJ/N0LeZhx6G+gnaxubikXqz0OiHpjlH0whQ7m7vNIr4hRk5PyWetYMr+jYtfPlNxL0XpjQ9J9cnAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Of7AgWHp; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770114658; x=1801650658;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WTWRfao0EKOvH/1+3I/qLineiptMnRDBDE9chnBGQco=;
  b=Of7AgWHpUtegrhggGxODwbSS1oVKEpiRMEWHX8Ngcvl+ZlH6a/Q6QPYj
   3Ip8SqH/k5QK1jHiCb8TKRp3bMrOu/Uw/KGr48dWF7zQ+VE6QoWfjHxhz
   nfLw2jJx1ijBA6rS9pK+f8o2YT017LksPRBHIgtGm3Lh1yQrhk7LStzwL
   9khrsJsZ6PFgizgr3ajhuKX30DAG1qyIVC8gEBOQgDEJ9YuIFFyrnvx+d
   QV1SttM+rexC9DaONp6X1Bna7AhKdbHVH0GlnYfUKenMyH4aIS7jXgFmh
   UwVjm3GLWfIgD8ZRVN0ty8C2ctA66qsPf26rzu0ZotqA70cpnnU8fYzbM
   g==;
X-CSE-ConnectionGUID: oIQiCtFxT5abbj2yxtD0Tw==
X-CSE-MsgGUID: jfJ8GkP2RaWcyGzSV6zzOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="71363431"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="71363431"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 02:30:57 -0800
X-CSE-ConnectionGUID: K3mHODW9R/2VmxXkoklPrg==
X-CSE-MsgGUID: /2CiFpQ5RliZvADGBwjbJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="214769309"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 02:30:57 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 02:30:56 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 02:30:56 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.69) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 02:30:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VwpT0xMKQ4iV6o5L2E4WGL1lMhYXtQHFtwQOxk9mJSRZnOUTm2ReU9IBOrdB5rP7cxWi7tdqd3LUD/iJNezP8Npsm8NbgxQSy/fXRfltJkdd/8zEgsAEMvuafkU/0Tr/lIwSw3IxRSQK1S8X/Ayk8FI11goINcJne+Dv9WKXRsJLab8BUNhymX9+8tU94YARLWGMTfw6erBsCU1r659E8IGhtrV5WJEJ5UZuVwnDncpEv2ulrWdgHg0c/eeUFDauJN1Nm7SziALCgXjeAwBFRJYSbQxlSP18DzlJVCsNPxnlYvya7oJsAkMO98nuERmdmSjErhh/iGpuMGgaMUoCPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTWRfao0EKOvH/1+3I/qLineiptMnRDBDE9chnBGQco=;
 b=nwcPS2CHrSgzJCiRoduf/dlYD219d5wQJhNIo8Q1Ka9ZObEBjmXEpvqonvzhwtQt3Q3uVbIn8RISTXtRAojj/tlRJMW9KvTK2i7JP5c09ZPJW1dGV7sO8DP3lzIGWyUHIXmZt9KRDCMqs4I+FN5M+0GbpcItCQdX/xbnozYbXsS0RlIbVlfEj4Yw6ScZ/zin75maxQfrVSdjXgqKh8V6K8Ozn68wBL2dObp4TGn4HFVcJAHCWD3qSlHJwfPRjj76mWWwqAOcoGREWATBq90RJD4vERwQvVyb7HoSFsoUnx6NmpTHcgPlzlmuqYB+Qu2AzhS81hbKPi5NF7yFUZz+mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by SA3PR11MB7609.namprd11.prod.outlook.com (2603:10b6:806:319::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 10:30:47 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.010; Tue, 3 Feb 2026
 10:30:47 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org"
	<tglx@kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "sagis@google.com" <sagis@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [RFC PATCH v5 02/45] KVM: x86/mmu: Update iter->old_spte if
 cmpxchg64 on mirror SPTE "fails"
Thread-Topic: [RFC PATCH v5 02/45] KVM: x86/mmu: Update iter->old_spte if
 cmpxchg64 on mirror SPTE "fails"
Thread-Index: AQHckLzLjnMvtKJ+j0SX9/QNnZOZkbVwztQA
Date: Tue, 3 Feb 2026 10:30:47 +0000
Message-ID: <1c4bdb3613ebaf65b5dcf9a2268b06fa0c5a6ef3.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-3-seanjc@google.com>
In-Reply-To: <20260129011517.3545883-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|SA3PR11MB7609:EE_
x-ms-office365-filtering-correlation-id: 9980f2f9-3d59-4f5e-01e1-08de630f4b8a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bEhnNWNpeFhWVTNtRmZIVW01M3V6UU9waUhlclZlSG5USnB1SEhWNW5XMjgr?=
 =?utf-8?B?MTRpZS9zWW9sRHlDOFpYU0t6M1VWVDJDNVRneUpJcDEvUWlEdTFoM1BCcUFh?=
 =?utf-8?B?WGtTd2FEdm9PSmdKRXhnd0Y0SWhvdCtYYUhuU1JSbjlpWXZvVGdIZGtHUHRR?=
 =?utf-8?B?c3hqNk9DQ1dhZmhlcGN2Z0RpOVF4L3JSTXhRVkdxeGVFRmdsNEtJQ3dnOXl3?=
 =?utf-8?B?OTdlZEVCajlTQnhuaU9Td1dTVmo3NVFzSE9pNlZkMVBSNWNOV1RxNFZka0Mx?=
 =?utf-8?B?Q2FsZkEyQ3pLb1ZRVEtweURWQzVZOGlrSW9YQ0JnR0svQVFndTU2ZGxsZHkz?=
 =?utf-8?B?cHRyL1JWTHU1aVpFMjNyRGo0Y0JXa3RnMkRidi90TWQra2crWE9kNHRvNXBG?=
 =?utf-8?B?dkZiQk5nVTY4TlgyZVhsbW1iODFzM09VTkMxeXpUblV5bXZFK0VZcHA3VVFS?=
 =?utf-8?B?VUxpZ0VRaDlvRURsMy8xK0NTZ05SbjQveFo1ZUZCamw0YkRZd0hXNmlJckYr?=
 =?utf-8?B?c1RxTGE3eGZJeXhuaUVGN3kxM3lRRzJsd2F5S21YWnVFSU1maXJOWlQwTEti?=
 =?utf-8?B?VXRRaFBwNW9xVUp4TzJNMVZKeG9ZUGRMMkVXNU1SUWM2UlVaZno5eE9pQVFE?=
 =?utf-8?B?ZUFSd0oxL20yN0VuK2VVTUYzYnhTVFpib2J0SmNqeFMwTkZxNmFqVndCK2l1?=
 =?utf-8?B?NXJ0NDV5bGdmZnlMa0xQR1FTTUZqbTBTeVpIem1qaFM1VmVyeFhGVmplV2M0?=
 =?utf-8?B?S0ZjR09YQVVBZUpPT2Z3OFkwNWxDaHpIdjZJcEtRSVFZYnlONDhHbTdxYW9h?=
 =?utf-8?B?QTVVNmY5U0JQeTFrWk9UamRqb2hYRTlyV096NUJ5YkdkQzR6cWt4Y0pJMW1a?=
 =?utf-8?B?TWw0UEdEU2JHTEVjN293dzIvWXRaazArN1hNZzBTbmNsVFAwQ3pJWWVSOHZo?=
 =?utf-8?B?blVRTVkvWjk4a2docUVqNkQ0Yk1PTnBFSmIyUW0rY01xLzBGUHorRVdoUWl1?=
 =?utf-8?B?N1BKd1l1b2ZSQThGTmMzS1NBVmJBcnBITzJ0bDFjSUJIYnZLRlRxWnRUblBS?=
 =?utf-8?B?L1c5Sm5KQ1JlMk5EWmZCejc4MWFFNWJNemtHd2ZPbklMOTVOTjF2MUhMZ04r?=
 =?utf-8?B?SE1qSCtyOEo4aUtzNWdpRG5XdXNHVHoySHFNNEd3dkJqQUNmNk5jNDNNemNw?=
 =?utf-8?B?ZTlzODNLc09BbzJnVTVJMUVMUVFOREpDQXAwU2pHL2x2L1pWWERpUVlCMU0v?=
 =?utf-8?B?b2M3akh0L2FiYWNiaE83UkllOEZ6U2tzOEs1N2hlcEtGY3RObVQ2czdoZHht?=
 =?utf-8?B?Y1FuNmNBaXF5Y1c5NzViVnhiRERHVHZJUUw1K3FLMWcwVGpDeU5INzE5TERV?=
 =?utf-8?B?YnNPVkk5THcybEc1S0hOVjZJZE1sM0FkUXBBMURjbHZiams1WmprNXMyZnZM?=
 =?utf-8?B?VDM4MDJzWVRvNGFueU1XRkhDMFRwdDE3dlhsVEpVTDBYdzk3VjA5SUtyOWxs?=
 =?utf-8?B?VSt0Y0tWa0prZHpXcWpzMjZqL2VnVGpBR0ZubVpjUDBIZjFMYW41TGpFQ3E3?=
 =?utf-8?B?MzBDUE1HZkorVi9KZW1tN3E5aE04L05WWDk1Z295ZUU2UkMxaWRwNXRSZjdp?=
 =?utf-8?B?clM0MFUxdG9jeGZESlZqZmVYYmpXbEZYTmVrNjdmVlphTGJrOXB5eXFPTDJq?=
 =?utf-8?B?RGVDcEFiQWY3TzVaT3RjcUIzTER1RjBMTTlCQXljSk9Xa2tIQWNVdDhMUTVM?=
 =?utf-8?B?em5NL2xXNnFTZ3UzeEhnY3k4aXJETGQ2ZzFWaU5jOXlFei8yUkFvSC9TMjJz?=
 =?utf-8?B?K0xyUk9MWmJZTkFsOG1sbiswNllaVnIyNVluUWd1RVVzSm1GSTB1Zll1cmFz?=
 =?utf-8?B?d01pdmhPaWRhK1BwNUtTeVRiWmp6TjZJdW5neUhtWnN1aG0wZEtZd2NWZm41?=
 =?utf-8?B?RGlXYjN5bG92TE0xQVBaOE9qUVZTeUlpNnk0ZlQzMGdMZEk2ai9waW9FZW9P?=
 =?utf-8?B?MExoQVBXdmxyQUprNUZBbWNBSW9WU290WmM2S2VmbE9ZKzhZajcrRGNSQjR1?=
 =?utf-8?B?d0tneTFtcEk1L2s2WEhpcmV2REdqYWdXYUpvcWs2VW13RkpNcnhzc0xlazgw?=
 =?utf-8?B?d0RmVTBQUmpJallRWnk4eGhDZ2loaEhvSzNzTXlsc2I3aXQxOXdDRXkxelVR?=
 =?utf-8?Q?mQArolXinqcMVxo7/J1A/g4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVlBN2RQamV4UzZmVkZpTzZkbWJlR0lKQytoT1lNOHVLUmhnSlp1R1gxNGhI?=
 =?utf-8?B?YVFwZ0lCQzExUTRZVnovNTdGMjluMzZBQUc2MGR0bUJWVDNjZWE3ZkFONUlw?=
 =?utf-8?B?eFhGUHVvcU1maEtXL2NUTXF2TmpZZVVKb0FuWWdKMGJDTXBKVzN0ZWZJM2Zr?=
 =?utf-8?B?bjVkQVNrSDcyR2xIYnNSUGtsUHhZbGlDNmcyVG5TblppOW1pRFFJdDFudlZ0?=
 =?utf-8?B?ajZGb2ZsNkdRNDNjZHcxc0VSZXZtVy8vUm15VDdJblhmaFc0SHFueTI3eisx?=
 =?utf-8?B?SFlNSzJ1Q1JVeVkxWXFpcVpGQ1pXK0FQNW9DNkRtNTZaZTdSdlFIR0lyVlZH?=
 =?utf-8?B?di9PY0JQbXVVN0JwRFRMRlhwdndEY0tVM2xLYVZpd0xFdWVNNzA1dWttd3pi?=
 =?utf-8?B?dHFyMFh1VmNneHNFNFh0UVRTUE4xUHVjR2VBR0FWVnZJMnBnS2V5RTAwZ2Jw?=
 =?utf-8?B?K3RCZTV4N2xhSzRNeUJlaGlNblY0akgraUY2U05nZVEyZVJEU3IwNGxKRWlD?=
 =?utf-8?B?bW44YnlNeTg4ZnJJUWFMRHRVMXB2Y0NFZGpyZENBcnJIWmhxMjZjbTh4WUMv?=
 =?utf-8?B?c3lUOUpPMzFhaGQrOFkxcXpBby85MFptenZ4bHl2aU9ZbVFia2M5TW1ZSXhy?=
 =?utf-8?B?NENxVk8zSGF1dWx6YStrZXN3aHNhdHcrMUxuZ0wwaWdvMmFTQUc0cTgwbDlP?=
 =?utf-8?B?bWtScE56anM4VGZPUytsbHBhdU9aVVF2dmk2bzQvQWVUTTIzUHFpaTFTM3lT?=
 =?utf-8?B?Q081aUFHYTNZalpITStvTGxHcExuekFGOEVsUytkWm9pSUM0MHJOd0tNeFVr?=
 =?utf-8?B?SmJiYmVHYS9sR0Q5MjA1L25wbWxmUkxxRmVnR1RweldsWk1MUTFuM1AxdnRu?=
 =?utf-8?B?Z2FYdHB5WGQxWjh5TDcrak1YdWlWakZsVmxpajF1QTM4b2U5WDdXY1A4RFQ2?=
 =?utf-8?B?S1Q2ZDRPblRqaENhaWs1bGQ4SWJES1QvQXZGcjR2dkV3eUo4Y0JVbnYzSEN4?=
 =?utf-8?B?NjJvcXIzcTcrUmJSZXhKb243ZmhoUmo3ZTU5ZTltblhMOXc1dEJsbTRGY2tH?=
 =?utf-8?B?aGVCMXpaczhtSE1hRTR4dlhjVVJhamFXR0RhSmJ2bUwyU01pTGk3djBSUHVD?=
 =?utf-8?B?V1lZOU90cWY2a2t4S3R1TXBYZVBwSmE2Z1JSWXdZTmcxWTJGTEVpTDFwQS9k?=
 =?utf-8?B?ZkFLb1huWG9sdlVjZ2FGa1ByN1lMMUhIMTdZc1hybXdBVG9mRXRldnRXNEhJ?=
 =?utf-8?B?b0o4T2JMRHY1WkpOYUhwNWQ0ZDNGS1A0UWhKaUJaR1h3UTRKb1NkaWlVbXpi?=
 =?utf-8?B?MTNNdkwrTnNidlZvQzYxRHM1Q0JzdUsxeDhNaGIyNXFFaTZ5YUUrdWVLZGNH?=
 =?utf-8?B?ZytKcmU1Q3hiMGp3Q3doWkU5ekNaZmdiVGhBWjlEaldSUlVXaElvQlNsSWJv?=
 =?utf-8?B?YUJKbTZhbmpPeXFMeVlPb1lKT1ZvK3UyY0dERlM3SGRpczhYOUplWnkrUGh0?=
 =?utf-8?B?RlV3Wm5NSFVzQ3RkcE1BSUJoRlBsc2tVeWZtWFhMVE5iaXNRT0hlc29CblJD?=
 =?utf-8?B?ajMwZ0NGdFRucHR1Q0ZUR1ovNHRCYjduNTloYUgzMUVEU0xDbXdMZUNwR2tP?=
 =?utf-8?B?QTViOTJwTFVkWE5SbEFaM2dVY0FKZzR1dEwvUkFWSEhVUHVoRzVSL2loY1cw?=
 =?utf-8?B?bjAwb0h4czFkcXhweElVaFFQNW9YVnozcnpkeW5RNEtkaEQybTVQckxZZXNY?=
 =?utf-8?B?a21uckxzVTV6cGZSM3d2UW1DdUwxcUxwS0ZDclBxOUJQakZTTmJUMGRzd0dv?=
 =?utf-8?B?K1BmTWRQSW1zY0hEOEdVL3A4WGJQL2JWeWNnOFlDWk5UdTFIcXNETDlKTWF1?=
 =?utf-8?B?M0hObnozbWdFNEtnUGF1bkxPNCtUTnNyNWdGZGNUU1JtcW5GYnh1UHM0clNJ?=
 =?utf-8?B?dmphdW55Vm43QjU2d3pTb1NiY1hhbllBT1lOMDB6dVNqaHRqV0p2aWFJeFBD?=
 =?utf-8?B?bmZHZDkwWDJjZUlsbWVTMXdzYjRIdG9Sd0tGOHBHNGFCWkxBeFpFV1o3TmJl?=
 =?utf-8?B?Sk1FYUZIUmVEV3hoekJueUZiQUt5eXdSUFFsTkpXTW15N3l0b1BZcnk2NHFw?=
 =?utf-8?B?Z0hkSUU0NVpuV2gyZFFIbXNCTU5qVDJqeWUraUZiN3FWOEprZXpGdFdZNm9O?=
 =?utf-8?B?QkJCM1FBVXpFSkdwNmMrWlMrREhKZkU0V2g4UnNmOWZwaklaU1JPRjc3SzNF?=
 =?utf-8?B?cGFpSjk0c25sUEZ0RVgzNVNMMVJ3b0M2Ky9XSGdIcUFwbFIxYVFnSVJjS3FC?=
 =?utf-8?B?U2REdi9Eb1BvaTkybC9nbG5EUzZkWTVlbUx5b0o5b25JWHJaZW0zUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1EDD714976913F499EEB540DDA5AF3EA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9980f2f9-3d59-4f5e-01e1-08de630f4b8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2026 10:30:47.5437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TV1e4UWYllkKTZmPF5jU+7MFr9LpTseZ57RWFrnDkAVx6CE6/Se5pD5M8Kta+56yH+T1V5USw0TIeXzUuZ26Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7609
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
	TAGGED_FROM(0.00)[bounces-69988-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: D89AFD7DA5
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAxLTI4IGF0IDE3OjE0IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBQYXNzIGEgcG9pbnRlciB0byBpdGVyLT5vbGRfc3B0ZSwgbm90IHNpbXBseSBpdHMg
dmFsdWUsIHdoZW4gc2V0dGluZyBhbg0KPiBleHRlcm5hbCBTUFRFIGluIF9fdGRwX21tdV9zZXRf
c3B0ZV9hdG9taWMoKSwgc28gdGhhdCB0aGUgaXRlcmF0b3IncyB2YWx1ZQ0KPiB3aWxsIGJlIHVw
ZGF0ZWQgaWYgdGhlIGNtcHhjaGc2NCB0byBmcmVlemUgdGhlIG1pcnJvciBTUFRFIGZhaWxzLiAg
VGhlIGJ1Zw0KPiBpcyBjdXJyZW50bHkgYmVuaWduIGFzIFREWCBpcyBtdXR1YWx5IGV4Y2x1c2l2
ZSB3aXRoIGFsbCBwYXRocyB0aGF0IGRvDQo+ICJsb2NhbCIgcmV0cnkiLCBlLmcuIGNsZWFyX2Rp
cnR5X2dmbl9yYW5nZSgpIGFuZCB3cnByb3RfZ2ZuX3JhbmdlKCkuDQo+IA0KPiBGaXhlczogNzdh
YzcwNzllNjZkICgiS1ZNOiB4ODYvdGRwX21tdTogUHJvcGFnYXRlIGJ1aWxkaW5nIG1pcnJvciBw
YWdlIHRhYmxlcyIpDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5q
Y0Bnb29nbGUuY29tPg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwu
Y29tPg0KDQpCdHcsIGRvIHdlIG5lZWQgdG8gY2Mgc3RhYmxlPw0K

