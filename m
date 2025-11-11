Return-Path: <kvm+bounces-62764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 926B8C4D69D
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 12:33:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A889A4FECD8
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 11:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 182072F657E;
	Tue, 11 Nov 2025 11:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NW8L/JFu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DBC17D6;
	Tue, 11 Nov 2025 11:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762860335; cv=fail; b=CDQtjW94KpoXDAILyiTy2lBCJet89p6PDkHNj7CrSmj9Ecr7bRyrVHjV3XYcdj/a0yhUyaipJ1I/+3f692ebV6p9H+adNGgLSP8NOHdOOJTPEJGYT6sAcM5U+V5sf2qPjEsJsyBvBjVOSTQWpclBix74sRNPHWvKtyErqLa0380=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762860335; c=relaxed/simple;
	bh=LinHEQ+FeYJvzkxNe2h/3Jix0+C45M9ZGDCkOg7oyrY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uW5BaFB/Y0aUWLJaPUgi1kgzXDbl2SEnlT/URhUH18cePHWC17qKcDI7Sef8BGgPi2h8uHXyMsiW5LNxqqGMdKybizISDDGbVmPoqv7zR4ly7Rm7BFHc77RlZYWKanky7ORlr8nJWLhhK2T9J2LhmGN6MaduWN5TFDR5+5KtIQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NW8L/JFu; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762860333; x=1794396333;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LinHEQ+FeYJvzkxNe2h/3Jix0+C45M9ZGDCkOg7oyrY=;
  b=NW8L/JFuLO8QYX+Zb+lRAei1Y9xANH1OdbcIqnWhFM+KlXrM6j8OeyS3
   735yZ9gtPCSPH49LF+ZpZz1ZyT1814x97d+BQhwebgXc124ERdB9IT5V+
   /hCoYZVNN1rgu2Y14ajYAgSH+i4iqLh9UoJ58Pb7C+fKOr1fXBC9/mudL
   aaN7oq9ENcs6X1QcK0cbztVpclBZXNTmFsa/Ncvz3K3GQZ/8wCidoVtGo
   iGU6Kj1y1dY8KUuZE6PqAXdq2nDRRGNUALg0xf52pvb7aSMjOXilFBHt9
   UccNhNCJ/zHrG6EvxFbjF1K41p/l3GsA1zFmnlBMUtM9nZna8FGJweALA
   A==;
X-CSE-ConnectionGUID: Weg033XuT7qybmsCojHiHw==
X-CSE-MsgGUID: 3TGabX04RAWIHsElqqb0Hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="82317888"
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="82317888"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 03:25:33 -0800
X-CSE-ConnectionGUID: WT5buRfbRDuQ4H1CHZfw7A==
X-CSE-MsgGUID: PkPsKmH0Sw2CI9IWMYLPOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="212336154"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 03:25:33 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 03:25:32 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 03:25:32 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.35) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 03:25:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WNfhFIvtPBhYQXBkNkQofDeknilScTw8+wsORJ/9XfZ0o8+b7c5cLR2y9Zt0Qg0uObjOEiL0StWSGupzO1DEpWTjBa3liaTMg/RT3iMdjVooYQtIgXvxvypl7cYVz9xJ7OjxZpf7ACyuQQogYW9xl3YawAmHj05z61uTKdl4yPS08RXnHQq89Yj9IrnbyAiBSLhwb/iVvbes+UuA8RGd4AftI8fXdrxnBviSowJE+M+UvFKAhV8hSDtMqHn0F3QbCjdWFba63cu9Ux0fh5Bh7P6ZkoY3w+3JurrIht4DRsdMsiC1YOA1PqZ2rAvJwXH79bBcmXZzCv7V1JG9Rhbgzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LinHEQ+FeYJvzkxNe2h/3Jix0+C45M9ZGDCkOg7oyrY=;
 b=x2kZiNF5FpcB30trAcl1zMldC9lAUQxBpr3DCrHk49Fgzj95t4l03W7pgmoPXIjvh6aFZtyw/Irzg2NF82rq20Io5+IJzb4jKZyKhJLA2PP/zNHO4ng1lNLiy5NWoEoAG+rjmMG/0hsv0RhgOO2C/UB7KS1LSXgo66pBwuWo6/bUBstKZ1Hson7KAhPdnZZ0g/0cTNR+y/+pmHKjDe82rlep1NYvHimwbn/6ly92wzPc8meK7MIAUwmxsKrXQtluAPuuzEHc51i2oScxqH4zYjg9Nf0KBUlZj188vQBR4wwfqsAeYT1Enlg5DPINNeb4K6M2loVEW5FY7WQ+n1uQXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY8PR11MB7010.namprd11.prod.outlook.com (2603:10b6:930:56::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 11:25:30 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Tue, 11 Nov 2025
 11:25:30 +0000
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
Subject: Re: [RFC PATCH v2 23/23] KVM: TDX: Turn on PG_LEVEL_2M after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH v2 23/23] KVM: TDX: Turn on PG_LEVEL_2M after TD is
 RUNNABLE
Thread-Index: AQHcB4B6levBPmVcPUWayckSVIaIxrTt7JcA
Date: Tue, 11 Nov 2025 11:25:30 +0000
Message-ID: <05bc67e2f6d7ec69d5428dadd1e175abcb9d0633.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094628.4790-1-yan.y.zhao@intel.com>
In-Reply-To: <20250807094628.4790-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY8PR11MB7010:EE_
x-ms-office365-filtering-correlation-id: dd593625-5857-40c4-fd3b-08de21150580
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?V2w1bENYMlJydk1jczBhSzFGUmE1czZyL01Ram91aUxweisrcFgzRDF2ZnVz?=
 =?utf-8?B?NVV1a2k3L05Va1FFb0kyZ3Z0Tm8vdktmZ1pZUWt0WEVzSnNuV002T2pLTkQw?=
 =?utf-8?B?QTQ1KzA0VkhxOWpWTXdUZGVOTktlWlpzY1VwakdvWnVjSTNxN3UvYTlSdzdD?=
 =?utf-8?B?VEcyeG5SRmNZYURJWXZCRXpsVUl6S0ljdXNrUkhUNWl5S1l5YkVGQ2Y4RStv?=
 =?utf-8?B?MmtTaHdrSzRhb3JDMm1tczFaQ2sycWJxSGR2M1lIaXBEeTFEWExWRjdwLzA4?=
 =?utf-8?B?UEUycURZRGJaY2ZMSmk5alcvSzk2Zjh6cyt6WjZ3QThBMVA5eHVPWFR4cFc5?=
 =?utf-8?B?L1F3WDZ0MVR0Y1Y4N1ROczk2Z3QvNi9JTlNTd2poUUxQck93M2ZtaXdTMEZh?=
 =?utf-8?B?M1Q0dWtuMU5TemlvVFlIQmhnWFAvN2NWYW1UYTdLMjVSUVp6bkVGbW9NV3pM?=
 =?utf-8?B?dCt3Wnd6ZkwxLzM3eFhqV05HN2FvZkFjZCt1SVkrTlVlZldLSFNLMmJGVzJ4?=
 =?utf-8?B?UFErZ25Zc1ZnUGVVOVE5WTlhS3NFeURQTUVJYit0Ym9zWXF5STBrYkh1MmFp?=
 =?utf-8?B?QldPRG1ILzNGOFhBeFhKREs0VTlVeWZrMlhCaXBycXVzUWJPM0dIRjEyY2x3?=
 =?utf-8?B?MldqcHJBQVlZeDZtbENkVWhkZTB6RWl4VDJJZGNBVDUrc2pXRXFvVDZsekpE?=
 =?utf-8?B?czZJUkFCVnphckxKVzh6ejRZTGFHMzFIeWJxekNFV3R0NlB0K2tqVlZiWUdM?=
 =?utf-8?B?enNmTkRXaVlZRTczamMwT3ROeHY0eTFkZGVYdmx2N1krMm5IbnQvamFnWU1I?=
 =?utf-8?B?bnpSVmk1c2plRUh1cXUzcWdPOTduOVp2d3hqamdsQ0hhbXR4dThQeUgwTjN0?=
 =?utf-8?B?SnhucURZNVV4SURZdEY4eWcyZW1CT0gxS1BMbGMveTRGVUFZWjBwa2hzSFdV?=
 =?utf-8?B?OCtuYWdTUVBNY3J5ZVdkd2poRnpDYllJdEg1VkwrMmZJcmxkalFEczdOWnVp?=
 =?utf-8?B?Ymx1S0g4QVdvOW1lWW5vd3B6SWNhbFdWc3h0WWJ6M3V0b1JoSDRjUFUvU0dj?=
 =?utf-8?B?UXFMWkhOT0wzOW5NTGVjTmMrSE9CWmtoMlZIRE5oVkVGMVpBRkNrL1RnSnl3?=
 =?utf-8?B?ZVdyRW9xZmJqYm43RHgwMXNuSm9hWmJPYk40SWgvd1dCN21oSmJwb0xWY3V1?=
 =?utf-8?B?V0ZzY0lhcjd1a1VIRFpWSlE4TTl5NjNla1VsOGZiWFJIMU5kZGNGbE9EMC94?=
 =?utf-8?B?bmlBU0dLZENiNEpDaXM4dHl5N1NaNUs1SkdMbm5YZXA1YU16bFJ1ejc4M1BH?=
 =?utf-8?B?cnROOVZRbmpGU0V0QVZseVIxV3BvVXIrYTM3cTR5M0ZhamQ0MnVSSmlHUkRo?=
 =?utf-8?B?WUgzekNtbXY0TTNrQkdZN0QrSkJXemlNYWRPTmxBZXlSQ3VCM1ByQVhBYkl3?=
 =?utf-8?B?WHA2NVBKbGt2Q1MvK0REQk5FUmFIRVJwaFVncHF0bGUzMmxHMklxRlNJVGVq?=
 =?utf-8?B?OTk4TEcveDhXZ0pMb1puRVFqb1o2L2xDb2luYkl2UWFMa1crWmpmSllYUXFW?=
 =?utf-8?B?REh1YjZKOHRLbE00bzhxcHBOYVlBb0N3SU5LdVQ2a1dSSkgzODArbUxRRjRR?=
 =?utf-8?B?eFVKV1ZJeFZ0N3RKaUR4MFIzQ1pqS1lITGg0bkNTMHhCWjV4TmJTazhtejVW?=
 =?utf-8?B?WlFPS3gwT1hiYU9DeTB1a3IxNzdsaTVjLzBEUldWQjJCRThIRDlvWlBXVnlr?=
 =?utf-8?B?RGFDREhGVit4a1Y5c3lFTzFCM2xCSWl5ZStBR2lZUmtITGRRNzhQbHo4eWlP?=
 =?utf-8?B?ME5JYmxuNE5LWmM5MzVnZWZPVjgwM1dSS3dVQUUvS1JxWXo2b2MvQW1DWXZ5?=
 =?utf-8?B?WGtRV095UG5id3VFcldaeUtYOWFnbnR2U2hQZndpNXZ4UHVDdm5TSTc3a0FY?=
 =?utf-8?B?QXgrbElVNDJKb2psUHdmYlUxTkNtODQyMnVJcGFZMkVpK1N1Q3pLbFJUY2dB?=
 =?utf-8?B?WEdUNnBxUUVZZHpKWFVWdDYyL0xxUzlZem9neDd1Y1o2RVNaUFpNM0phdlpF?=
 =?utf-8?Q?J1beYZ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3NxV3BzTXJoS2lMcjRjU1drRm0vTlEvS3BJUVI1RDQ3Wlo3UmtmMEdGdm41?=
 =?utf-8?B?b1BubmkyWHN1NVBmNzFpYUMxNTU4RDl1dFpDaEsrWkpuVkdOMHBtSmJaOW5p?=
 =?utf-8?B?YUJ3SjY0WURPdk5lWnc2TUIyTEZ5QWU5dEpGOG1JSHI0NzRRRU0zdEZqekFQ?=
 =?utf-8?B?TE9rTzhwSHUvU3VIcjIwd3lkRE1jK3dKRFdJamZNNldrVGQ3anMvWWwyYVBi?=
 =?utf-8?B?SWZXeW5UUXIwbjducUhtcHI1RTBLMjB2aCtuMHVIYVFNTk1PMitDbTNSbmJz?=
 =?utf-8?B?SThkOWZFM0xMekVtbFRRUzVjeFpzTkNVUkhVUUd6c1JHRk5nMVQ0Z1E5UXE1?=
 =?utf-8?B?QWVYY2hWbkRZdnNLT2dvT0thVEtSbFlTOFJna1J2NHgrRk9iUmNTaml5aTl5?=
 =?utf-8?B?MStmL2w5QlJNQXVZVGZMcGJMK1JlTmhUVVlvMXI2U1J2SFR1VVF3S1YzZ2tQ?=
 =?utf-8?B?S29udlpVLzdJL1hubjhwdDFXWXhGdCttMmUwZzROb1l3VmU4L29XN0o4NExU?=
 =?utf-8?B?cXltUTExVnFyMitXZWMvbHhFdGtMUlVhaERSWGRJaGRzOUtuVTFEVFNMczhp?=
 =?utf-8?B?VGExL2ZHNmJwdk5wQ1AzdHVSYjlGQ3hmZGhRZzNXamk4MzFNdm8xSzFNQlh6?=
 =?utf-8?B?UnlBaTBRM3B6VEg2ajVvMEtGcG96TndQY0h5UVVrK04vQ2c0VjhjTkZPeDh2?=
 =?utf-8?B?Y2NxV0JOQXFmMHNOb3VLMW10anZURktMa2RpRFR1cU1sMWxiNFJJc2thL3g2?=
 =?utf-8?B?M0E3Nm5CU2x1bkZnaFVFT2VFclFZbEdRVjJORmdZd2JNTFVOZ3hxeXlHMGM0?=
 =?utf-8?B?cFBBalB4UHVnOUE2R3E1L0tWdUR3RTAvb3JTbEkxOHZlbEl6dXdzUGFpdjBV?=
 =?utf-8?B?TUN4UEwvU0U2UG5BNmRuWmhvZElFdFY0VnRyVXA1eHBGTFVMUllrVFNxOW5W?=
 =?utf-8?B?VytzUnFmemc3aFZXNHJRRzNWaEdEYWppTFNnV3V6Zms4NHRmZnF4RXcrOFlx?=
 =?utf-8?B?WTV2ME9uSTNKWmF6Y2hRNndoQWlEaHVVb3pQc2VrNEpoUDJTeXRTeEFuSmRu?=
 =?utf-8?B?bmRlK20reGd1Y3J4bGM0M25nK1RCTW45NGdpMnd0VER3R0l5aXVUVW94aDFr?=
 =?utf-8?B?NWRmdWJyZjZtV0dlZUE1WTVKbFo4WDFyK2xtbFEyN1g1ZzhLVHc3WkhWenV0?=
 =?utf-8?B?TS90eVBtOWZHbWRQaXIyd2J6R3ZMcW5IZ3VBY0dGNlB4QlJsT2JWZjZSVjhy?=
 =?utf-8?B?NjZEaDBucnJpdGwvUGQvdW1NMnk4aDNSNEprU3hjMnJFVEVaMUpQSmVyNlY3?=
 =?utf-8?B?QmpVbktXR1pObTZQdklVQVo3VEh2bWxXNTRPNEh3VmdFY1UzMWFBbitocyty?=
 =?utf-8?B?a0d0Z3BhZWphdm95cGt6VEh5RU9GY29lTTNaT2F4YzE2NjNWUi9JU28vRVJn?=
 =?utf-8?B?UmtxWEcvSmJBU3RJU3ozZExGeU9zczRWWnFUQVdOQVRqMkhWSFNFeEsrc29m?=
 =?utf-8?B?T0RHVzZIQm5EaUgxcStEYmhNSXJJMmc3SmNQbGhrc1ZKaDR2aUF1U1dNT2di?=
 =?utf-8?B?TjJwZ3lhd0g2aC9VcFdDblB2K2ZReHVjWUVNVjJyUjNlU1pSLzF2a1pSeER0?=
 =?utf-8?B?djh5cXZ4SXBLZkg5ekQ0RFlxNVo0R2ZmU0dVeXlzclpPRUNCWHhjUFozdS9a?=
 =?utf-8?B?QUk4QytUc2VZWm9QMUJWd2NwUzg4aWRQYkNkaFZuYlg3TGxZY1pYMFRzS0ZI?=
 =?utf-8?B?aUdld2V3TEhsamR3S2ZSUFdSbDdsRUVPUndXMFZHeWRPL2FuRGZHSUZuU0NP?=
 =?utf-8?B?V3h1TGVkd3E4c3AyMEh4OVZzRUczMWZyOXBLbno3TVdDL0R2WkxOaFA2ZFJM?=
 =?utf-8?B?cWJUVTYya1Y4SDJIM2NLZG9YNlBaY0dFS2dTVElIYlR2bFlldkR5TjJkUnIv?=
 =?utf-8?B?NjJudmZjcjhLdEZycXBFbVlqSDBqK2N4Nm92ZlZMUW42YW11TktiOUhNS3ZY?=
 =?utf-8?B?b2dVK1pzL0JZRjlVUUhsKzFTVDBaWTRBdkhSOTlLUzZYb3JuMmZJRVY2QzNP?=
 =?utf-8?B?emJoMkVwNCtOelhnUVQ1UDU4bmNiK1dyUzhVcU03ZFFaTllSWDZnZ1JBOU9l?=
 =?utf-8?Q?0wyAcY0x3j8cy5k648W8pvnKB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0C0322BCBE51E419E0992DEFADEB988@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd593625-5857-40c4-fd3b-08de21150580
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2025 11:25:30.2987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SliPQbnxoMIBN/ueirL3QSLpmxSLKzmC7tZTQATyy9+mwCA3hVWdzRLzTLfilJPMal+ZYIZXpv5B7V2ALSR0lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7010
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTA3IGF0IDE3OjQ2ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gKwkv
KiBMYXJnZSBwYWdlIGlzIG5vdCBzdXBwb3J0ZWQgYmVmb3JlIFREIHJ1bm5hYmxlLCovDQo+ICsJ
aWYgKEtWTV9CVUdfT04oa3ZtX3RkeC0+c3RhdGUgIT0gVERfU1RBVEVfUlVOTkFCTEUgJiYgbGV2
ZWwgIT0gUEdfTEVWRUxfNEssIGt2bSkpDQo+IMKgCQlyZXR1cm4gLUVJTlZBTDsNCg0KTm90IGEg
cGFydGljdWxhciBjb21tZW50IHRvIHRoaXMgcGF0Y2gsIGJ1dCBjb3VsZCB5b3UgZWxhYm9yYXRl
IGEgbGl0dGxlIGJpdA0Kd2h5IFBST01PVEUgaXNuJ3Qgc3VwcG9ydGVkIGluIHRoaXMgc2VyaWVz
PyAgVGhpcyBkb2Vzbid0IHNlZW0gdG8gYmUNCm1lbnRpb25lZCBhbnl3aGVyZSBpbiB0aGlzIHNl
cmllcyAobm90IGluIHRoZSBjb3ZlcmxldHRlciBlaXRoZXIpLg0KDQpFLmcuLCB0aGVvcmV0aWNh
bGx5LCBJIHRoaW5rIHdlIGNhbiBoYXZlIGEgd2F5IHRvIFBST01PVEUgbWFwcGluZ3MgZm9yDQpp
bml0aWFsIG1lbW9yeSBwYWdlcyAodmlhIFRESC5NRU0uUEFHRS5BREQpLCBlLmcuLCByaWdodCBi
ZWZvcmUgdGhlIFREIGlzDQpiZWNvbWluZyBydW5uYWJsZT8NCg==

