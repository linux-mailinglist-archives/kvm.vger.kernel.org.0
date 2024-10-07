Return-Path: <kvm+bounces-28047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A3299251F
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 08:53:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6393B281844
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 06:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E4FC15D5CF;
	Mon,  7 Oct 2024 06:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c6Lv8f8V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD69158861;
	Mon,  7 Oct 2024 06:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728284015; cv=fail; b=h5Mhl93UkQWTmqRt9x0m2suBVRvKrQCCrthn2w3tnIcJw7AjR2kuBXWz4hS9AMcl6WRZgXAhwuRnKyPR6gKVy7T9fw6jO805AcwtsvDJ1qPaBMtw9F3jm2FKlqkIBPvraAD7dLXQq/MrMxscrKx//MD0LHo4suiUVTSM0VhexXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728284015; c=relaxed/simple;
	bh=jsL7/297jf44DMbeK6NeJSJuQnNLkxqPJpcnCK8KQhg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=clLtl4m/Mb0M6gUFO9LFBpjtC5Imk1SWInyuTKI0ssAhut7bSv6z6q7mGSy/qRN1TvP9WmtR7OZqbVGg5kNkUbAQl78vGJSrPVghBwaL9dZWZrD74vdQ7w/iWchyCg/UCLbNCg39Bh9gMk/4Wan4UTW58tNkOhhG/7osyChiEOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c6Lv8f8V; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728284014; x=1759820014;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jsL7/297jf44DMbeK6NeJSJuQnNLkxqPJpcnCK8KQhg=;
  b=c6Lv8f8VhmWEySKqFWV1vBil0BavPWPLqnVgFRqJPikc8Ze9G7qj+s3/
   CUoH8snfBFKJOiuQ5ioGDl6S8UoIIAe9AhEBfEIr9Skyw2Tn2nbNAStDO
   vIsf9gajArPZzIdSA+Mgic9/SBp+rVJDk56X/S7q8B9LHVTfL2/T/FURF
   LvOlPADlAWXzBYpyNVbf7qEBZ5reUN/ihBvtT6DbXGmQ5a0uP1roNH3Pw
   kqOkm2pF8JC/r2Cq5asECliX3PlZYxL7STvvO2c69EsOonkI+5gH1T6ot
   VAV5x4+vDdQSK/o0cvJ40OkEaTEi0b0mhK2f1qOeFG21x9XPaYfgJxDSI
   g==;
X-CSE-ConnectionGUID: UU5lEVgjQdW6/36CDo34AQ==
X-CSE-MsgGUID: cPGR9n9pRc6o4ias41FczA==
X-IronPort-AV: E=McAfee;i="6700,10204,11217"; a="30303283"
X-IronPort-AV: E=Sophos;i="6.11,183,1725346800"; 
   d="scan'208";a="30303283"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2024 23:53:32 -0700
X-CSE-ConnectionGUID: 4EDR3k9EQA+q/dTDYceCgQ==
X-CSE-MsgGUID: 4m3SddNmT9aAwoXC5KArIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,183,1725346800"; 
   d="scan'208";a="106207291"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Oct 2024 23:53:32 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 6 Oct 2024 23:53:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 6 Oct 2024 23:53:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 6 Oct 2024 23:53:31 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 6 Oct 2024 23:53:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OR3/KAaCfDGppNNJM8tqMvDHr+M9+6VGenqlKrMK3YSBMYxRsWWpl4zY2NX9DPjvwWFcw6cgLbMSr2CDbdqjMZZmj6X8ufAQj9rt4ieaW//wDKlExxQCTuyw33s6FeUd5a/GGyf5uFkGoI2m0XydJ0SzhuZ3vqhVl+qNJBjMvMp41NgiPcnyzW7FOb05kgwd+40IgyuC6WAzFQfdG4oZeGamq586gQrjQUY0hThku8xRqDjaojikCpi/ApV3B6wRozBE95f4kLZRIU/Jr5CTpwYDiIhsjPNZA56H8Dkg9zOjp0D6d/uwfi9zcXsKnfTuy7qf6zITN3XdJYO2yi29qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jsL7/297jf44DMbeK6NeJSJuQnNLkxqPJpcnCK8KQhg=;
 b=mHghKfGwb1d3d7zvDJJt82aayAyCFfelKW/8vfHdnFRYyMxSkcNohHV4O0ZdeWLW0xk7chkRtkw62Pv6STnERcwyq9gzhxBt5pwdATrC7DyIFCNzyMPKMX77bVc5lNTAyDPqGj3McfeNv4sYlNuEbMQYmBupZOSNBhQjdUbAwO8eJmgYo1Q3RaPABeUDpgfW3jt0AMTYj/V+fZuwBiDsa0FUZ9aIrb7wUgEDqSijbX+UqMdG8WXu8JG+ZUo0Nr73x2ZmYpjTUfJ1JfO/SlK1IFr34OVAc93zKIhCi5e8tcwn2Gv/RtnXrRWNvAA0iD7txfHclV0FxaY7qF8Lwyfd9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4517.namprd11.prod.outlook.com (2603:10b6:208:24e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.22; Mon, 7 Oct
 2024 06:53:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8026.020; Mon, 7 Oct 2024
 06:53:28 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>
CC: "x86@kernel.org" <x86@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Topic: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Index: AQHbDnRp8EihSraYXkOZ/V8hjcAzkrJqOf0AgABuTACAAAERgIAACvwAgAbdloCAAC7wAIAATPiAgABqcYCACDbNAIAAClYAgAA04QA=
Date: Mon, 7 Oct 2024 06:53:28 +0000
Message-ID: <c00d6fd92455640430ccb5c7750cc91ddfecc3b4.camel@intel.com>
References: <cover.1727173372.git.kai.huang@intel.com>
	 <101f6f252db860ad7a7433596006da0d210dd5cb.1727173372.git.kai.huang@intel.com>
	 <408dee3f-a466-4746-92d3-adf54d35ec7c@intel.com>
	 <62ca1338-2d10-4299-ab7e-361a811bd667@intel.com>
	 <a03f740b-6b0c-4a64-9ff1-7eba3ac7a583@intel.com>
	 <1b14e28b-972e-4277-898f-8e2dcb77e144@intel.com>
	 <66fbab2b73591_964fe29434@dwillia2-xfh.jf.intel.com.notmuch>
	 <d3fa4260c50c8d4101f8476c1cc4d6474b5800ce.camel@intel.com>
	 <9514d5b8-73ba-47c8-93a9-baee56471503@intel.com>
	 <74a88c3df6e51ab8dd92fdd147e4282bfa73615b.camel@intel.com>
	 <271368d1cf0d3b3167038a01ba9e9d1e940cb507.camel@intel.com>
	 <71403e4f-f7a6-4d7b-8301-0c4f16208179@intel.com>
In-Reply-To: <71403e4f-f7a6-4d7b-8301-0c4f16208179@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4517:EE_
x-ms-office365-filtering-correlation-id: 4432537b-ee31-46ec-4c70-08dce69cbf9b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RmxITkUxekd3V3VOdm9TV2t6OVNiV0RiTXJuTDJwdlNtOWE0QitlTXVnZHd0?=
 =?utf-8?B?NzBuWVowRkF5V1YzNnpJR1BDL0htZ2lpVDk4eFlCZklMQ1JmbXZ4aENpaTlE?=
 =?utf-8?B?a0VCTEFQeEdxazFpdGZnTk9Xc0JZdU5JbVo3Mm9od0MwK3NjcXY3QXZPWnJ6?=
 =?utf-8?B?Qm5MMXhzYXJrT3d4ZGFoaFh2Z2RCTTRYS2FXSGVYdXFlNVNFc2k5dGJLZE9v?=
 =?utf-8?B?VjdsSDVFaTVmbVF5bmRuSVN3Z0dURHA0Q3hucDh5QkxVSWhQRnZpdVp6Qk5F?=
 =?utf-8?B?NFNvcDlhSStXUVdQdHBCQ3oxYWc5TWd1NG0rSGNOaDcyVFBxaFo4YkpYMXhI?=
 =?utf-8?B?bmdyb2VjNlFJSjVNc08rQ2NtV3pwUzU2YS95TndKWEwybHZncW16WWVvM2dW?=
 =?utf-8?B?eWpRVUcvdnl0YkY3RTdBOGsvSXM1SnZoQ0pkZGhaVXAxYjdEbWZpSmMyeEEx?=
 =?utf-8?B?TlN1QWJQMzExV0RoMndoU082ZFBxTHJlNHJibDBkWTVRZjg0bjk5eCs4cFBT?=
 =?utf-8?B?L0V3eFQ5U2xWcUFjTlNsaFJacFFHN2N6NW5rYlhXT3RadHY2c1dNOWIwUVcv?=
 =?utf-8?B?cjRjWmxNc1dwRTVzbVVGdFc2d2dYK05scDYxSGhDYmtPcHl5Q3F0cEhmYVh0?=
 =?utf-8?B?QTZZNEZEMmZ1V3M1Nmg2NUF4ZDRmbGtoY2R2OHIvak85dWJoejZxV29kWmZH?=
 =?utf-8?B?Sk9JRThDZ1UzYTJORTJ3YjJndkZKT1NvOTNBRlY0L1g3dmdNWHY3OVpBYWdv?=
 =?utf-8?B?ZDZCbGowcGlCUFBNYU9JSWpaazk2MXV6NlpQMWpwd2xWOXZoQ29qa1diQ0d4?=
 =?utf-8?B?UGNQdS9IanloSXhuRmVyV3pIVlh5L0lJb1BCV29YWDYwZjBpU1RteS9meVoz?=
 =?utf-8?B?SGRJV1VxY0ZMd1RUSXd0R3ZnOWt0ZWFnRWtNdktLZHJvV0VYcUVmTFVnTW1Y?=
 =?utf-8?B?SHdoeWMrU3NpRmRtWFVtU3plbEFuL0R3T0VGc2tsZlpiQVJZbDBLVXY1UkxE?=
 =?utf-8?B?QTBGQnVqV1VvcnNwbzVoRWJaWllCVGlIc1QvYUhTaUlDazNqWWpoa1B0ZUFv?=
 =?utf-8?B?SURNYmxHNUF0M1ZhdS9LQkRQM2RzQ1FrZ2lWdHIzelFKMm01bFdBVTM3Yzd1?=
 =?utf-8?B?MVNDQlJONXdQWkFjWUhUTHpYVDR4NXJscVRLZmJ3NlpMendzMmhCa0hlYXdD?=
 =?utf-8?B?VUFESjh1U0RWNmpMVHlYeHc0WVpEZSs5R1VRcTJmdTFTREg5MG1uQUNTc3Jl?=
 =?utf-8?B?WThoM2VZRW5HcThkV0tOUjhicnpqbEk1aXRQYktUSk9WUm9Na1p4UGZkOHRB?=
 =?utf-8?B?aDd5b0FNb0YwTlowN2pWKzRYUlRTV21EUGFFZkN4MXVLT042TDZuUlVKcm1p?=
 =?utf-8?B?YUtQd0IrczZrbjNqNGlFeFFnNTdDWnQ0dG9SUnBRbW84R2NscE9JQkVhUDNC?=
 =?utf-8?B?MGRZaUVIbmZPLzJjMy83bWVlZTU3Sk0zSTJQc3g5Q2FUQXN0YlJZU2pDanQ4?=
 =?utf-8?B?Sll0cDg3dkRqWkgxTjM3TDI2TkJBZCsrTmpzWkhzcThYb0xFYjlwUHVZZXpL?=
 =?utf-8?B?VXVWbTBkWXJvTmdkNDg0anJ6emdBQkJkY2xSbVJGTlh2R3FBL05qZUVwYWNm?=
 =?utf-8?B?TGxWL24vNS9qei8rYjF4YlJ0STlpMGYvdjJxZGFWd1dXL0tjR1Q5cUgxWlpl?=
 =?utf-8?B?ZXFwZGQ0aDhpeTdicGxuZXFKQmR1VjQ3enBLRTB3QWhHTlJNVkwzUFI0Mi9T?=
 =?utf-8?B?VFZOanE2NXNoNEZvazVtbk4xZnlNc0t2bDFaalFmTXZCazR1SkRkT0JISHBo?=
 =?utf-8?Q?uSr7OTQytvR/PxYuG2FCrQbi0tog5DKeIPb6w=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MVc1SWE1MUVScXNhek1CNnh0M0xvUWd2QXlzdTdBR1RTdHBmc3NLVkVXOGlI?=
 =?utf-8?B?Q3VpSXRESmJ1YXBUTlpIWTRHNEpFcmZhQVZtdDNucUdhdUI4ejA0eGthTUJC?=
 =?utf-8?B?QjJRNE5JOVEyTjVYYkZ6SVZMQVdaT2NjS1loOVdmTmpydjBSMXpEWVVXeEdD?=
 =?utf-8?B?NDR0Q1pTbS9sdDVaWVpjWkFaSHQyRjY3b1NBMjA4a09JWXY3QUtlVUVzcW1V?=
 =?utf-8?B?S09DY3g1MVF5V0FhazZlTkNhOVFydmgraE4rcDNXYlg0RjRKTG9EcGtIVkNH?=
 =?utf-8?B?bEJjZ0VTK3ltWUh0K2RYZVN6dU1FbWgwcW80RDdXWDFEaGNZb0xzMFJIZUdh?=
 =?utf-8?B?alBPOFhtckJMd3V2NVlJZDkzUDVjQTd4d1FnTEk2ZEp4NzVlQkN1cmNyYzlI?=
 =?utf-8?B?bVArOXk4R05FazN1RTArbG8ycDYvU1lDTkc0SWN4MU1TWjBqdE9RdVJsNG50?=
 =?utf-8?B?MWFOdFRPWGs3M01MTDBSclFKcUZPcnEyRmJoVm0rTDAwdk8va3QrK2dicG1O?=
 =?utf-8?B?TTlONEViNjNpVW40cmJVMjV6T3Yzc1cxb29JalExNTZQQ05Ccm5ubUswZWVh?=
 =?utf-8?B?eGJXMDluNWErVUxVeDVLQzJxckFNTHA4L0RFcWlmam4zckpDc3o3WXA3aXhL?=
 =?utf-8?B?WDg2SGpISFY1eDNwSXdkRmhJai9INEFHOU1NL0k5TUFwYURQYkJuTUdYZ01j?=
 =?utf-8?B?S2FIaXhBZGU2bURZcnV2UzV3VGNSSUE2cDc1NUllSk9VbzlobFQrU09adlJC?=
 =?utf-8?B?WlJrb29RbXpGR0tTL1JCTU1CWTFaMmVGMDIxbEJCTDFhRnJlRTRQVnBKWEor?=
 =?utf-8?B?V0dEZjFtaGRtS3NQS0gvWXlmbU5HUjFCR1JxTzNtUk52S3FFSjRwNFM4eEpt?=
 =?utf-8?B?ejVWRU5CYW9BMXlCdUNHeEdpWjE5RElPeHNCT0hyR0VvTjlJazFBTWhXZ2lR?=
 =?utf-8?B?dnVGbVdqN2hPbWlwTHNTT05ld0JLN2FDL29xMU1ZbVM4b0V0eVc4SWZHNHhw?=
 =?utf-8?B?OGNhRHlDandvQVMrUEd1WGtpaUpSdWM1V1pEaGxGQzNxTmozOWJWU3VzMUNl?=
 =?utf-8?B?VTVIQ3o1Y1pEWVhmWC9LUUk1MnlPMjdqMDUvaFQ2WDlXOUVGcy9lT01sOEZR?=
 =?utf-8?B?clB1KzBUbi9mTlBzYkh6TmZ0aExnYXE2WWFuQ1UveU03WGMwK3AvNy85aVFk?=
 =?utf-8?B?Q01wczE2eFk2VXFzdml6R2tHdWhaMkpJQUd5OVNTaFZzT2RQRXhUaGRvRmNk?=
 =?utf-8?B?b092bjYyVHoxN01oKzBIZk83aXVLbmQwU2tHeHRuVUUrZVdtZmp1ZmR0SDEy?=
 =?utf-8?B?dVVoZGpzNTZLaTVnKzJSTHdBQTVNMi9ET0d1cEhNYkdlOHcyUERGVDN0Z0Jx?=
 =?utf-8?B?KzJYNnRwOWxmTTlwQ002RmI1cjVTNWc2OXNEN1B4SjBQSUtheGxBdHllM2k0?=
 =?utf-8?B?Y09OaWVRUVg3bVY3a2NMNzFzdUJlY1VyNUNYcFo1eUhlSmY5U0ZlYnYwd0Rt?=
 =?utf-8?B?bG11Vmg2MkhvRityZDVsbWVNOHdzQ2J6QUgwejN1WlBBM2EvNmNKYnJHQW1B?=
 =?utf-8?B?VDNJK28xeWIwZnBkYjJXMVV6OVdmaFUwQUlmalNRdXE3RW83b0ptOXBPYmRK?=
 =?utf-8?B?bjllbWt6UGV4YklEVG96bzBIMVp5UUVGTnZMcmxGdFVrY1VkZ2U0elRoclBZ?=
 =?utf-8?B?NDRKSlZhckxkcFkyVGR3NnFKVldod2l5SlJoNDhPcTBhZ2w4ZUNxdVp2N2Jn?=
 =?utf-8?B?M3lndlpIMDk3Ly9kZDFTdDh3UWZqN1ByN0FiZnpFRmVHUEZsK2w1a1ZMaXJG?=
 =?utf-8?B?VWJTbk1renFsMHVtc2FaU0haWTZ6eERRMlJOUXdXLzBSdk5DS3cyd2lFUW12?=
 =?utf-8?B?WnVCbFloR21IT3RTYTNmbDhZVVZ0SUd5VklLekRlOG5EUWhZL2tNK0RYd3I3?=
 =?utf-8?B?aDFhYUo5YjFhZ0wyUmc5MFh0Y05xUzZEVTBOOUdrNW9aMVdDZU5LTFZhSFZu?=
 =?utf-8?B?NGU5OGpyeVlQL3BIU3I0aHV0VytWemNSR2xuc29hc1Y4N3JzRUdaR2pYMTJu?=
 =?utf-8?B?U1pOMjdhL1V4eXNvRTBQNGluVTVPOEYyVkcxbVY2L2FORGF4ZmFlS0tqMEZQ?=
 =?utf-8?Q?1djYiA9WlGg/ik9stp7GUNkY6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D11DF1925470284AB062CBFCB2FB9C8F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4432537b-ee31-46ec-4c70-08dce69cbf9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2024 06:53:28.3469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rTmTVx0YPgg9PxV2qNvK12asczh3+oN03FCw7jRfdFaALxBUEkZ7kwFWl/cewCARWInBSlzqOxdAOJ4SyUyd7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4517
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDI0LTEwLTA2IGF0IDIwOjQ0IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTAvNi8yNCAyMDowNywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBXb3VsZCB5b3UgbGV0IG1l
IGtub3cgYXJlIHlvdSBPSyB3aXRoIHRoaXM/DQo+IA0KPiBJdCBzdGlsbCBsb29rcyB1bndpZWxk
eS4gSXMgdGhlcmUgbm8gb3RoZXIgY2hvaWNlPw0KDQpTb3JyeSBJIGNhbm5vdCBmaWd1cmUgb3V0
IGEgYmV0dGVyIHdheS4gIEkgd291bGQgbG92ZSB0byBoZWFyIGlmIHlvdSBoYXZlDQphbnl0aGlu
ZyBpbiBtaW5kPw0K

