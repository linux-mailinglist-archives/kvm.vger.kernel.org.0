Return-Path: <kvm+bounces-46379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 701BEAB5CFB
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 21:12:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E460C4A51B4
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 19:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CAEE2BFC6D;
	Tue, 13 May 2025 19:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="idLuFnbA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2576F2BF3CC;
	Tue, 13 May 2025 19:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747163538; cv=fail; b=IzVcGwSTtVecAt8yKJx706CpxMSXlvl2EPVdQxh6vE3GQZNk/gfIwJ37wzaQuWdGhAP7gUe8Y77MCRp3RON8HnkAzjklrdX4i3cZzfl6a7n6kpoXwkfx7hWaAdfgBlHlAmrQ4aUxLHa1tS6JtauN/gFGABFBM5Y4et/KTbsf84U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747163538; c=relaxed/simple;
	bh=aYxvL5LN7pkpACc4QR1g485Ou8JBLDTLl+X4zP5OKBs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P0E32X1bqXWRRC3i+xU+Buvv2fk10qzheTIkyFPh1594QaTLUVjq5lTYTK2x/cLaWMHjDwKK+WckZ3hzNnj9c+TK2n84I+READZ0XIH/YidIHJxN2fc7CWRapaMBhQFwx1/w8dwWttmZ4tWwuvg9MjIsbqLe+4E4b6DuLIuddY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=idLuFnbA; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747163536; x=1778699536;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aYxvL5LN7pkpACc4QR1g485Ou8JBLDTLl+X4zP5OKBs=;
  b=idLuFnbAiQ7WtJSARqhIOt1ZujEdaDc1n9RhNmr/ALWNInRGslVM3ptv
   KQ4+gPK/ynbackvbLBJs8SL9Nc96E9BcL8Ag+X8h5L18gX8ROSCXws0ke
   EqZ+0Uz2orWbSiFkf+MYHAuhXxJu5J6MDHxDQNI24/2inNwBKKlsiuYFT
   MzoX10ur03rqmpF/teMgqtmMu1vZ9eaFKfs60x3eVQTFGSFPUTYVZtWtb
   ueMoDQgVjC7dqXHf/9a5uIP9lfy/mqyt8lxcH40q44a3gJvUIdp2rt/FX
   R76N5ifAoTXoeFAipKdjo8Tq4Os0tMto0eptV4VWvIk6dXPrkJ960aUjI
   Q==;
X-CSE-ConnectionGUID: uguc9AZGS6y9fyrJQ18ihA==
X-CSE-MsgGUID: R32qIqLUS9+YvE/NGz1ZyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="60044702"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="60044702"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 12:12:14 -0700
X-CSE-ConnectionGUID: t8XrkmKuQaW0OH4tf/G/Dw==
X-CSE-MsgGUID: ooWNfxQ8Tc2X+6Pv7mKZSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="138318286"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 12:12:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 12:12:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 12:12:14 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 12:12:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XMCT8TctIhheBOTFTQHNMyQ9EXKUiVvOE5wFkS8KSNgeljqyTBPRbsbmuhhFuLvcTtYXyxQ1jDHKtoGqUkLXbNgwVICx+7FCPctReJZPdtOWoqf4/YYBd8ph0Sr9TXIAT3eJIm46VU/5o44v1jf2rc4F7AX3xzJseEtlDVaTGhZGPBX/jh8Yl66D35cchvtY0h02XLnj2RgLPqecL1Ff4dwwB5vIFwiGWJLLnHYMPqepX4HaSvT5Rmsi/tBJCEeo11Q1++R6/zVf3+3kZzhcf992XFM2C581NHrOM+SA7cZz7Zak4vY8oX5KbOKoZN8xTGUChMINMaRelg6OcvyqGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aYxvL5LN7pkpACc4QR1g485Ou8JBLDTLl+X4zP5OKBs=;
 b=CYbNYniUgF6pHTadS/gcG8yTpTJ3Ueb3BwKQrhPNMvn27cT2yb0vYaI/3MKC6VCEsq6P8D4V2vMW0OMSUslxZ273GH4XoQIqTHKl/1GV6RDczSk0tKJc47Fx/cs8Roj0F+GVW6+kadtDq3jIOMV8LAssPvBIMTMoWYXd9ifqyb4z4qdsS40VPWC01bHtheWrlK+BSvGE8G7LHilfFCwW3VePOKBvavGf1zK9tfbPqwMXOxTwrWg4xysN4WJjABYKLcGNRsnCXNTSmSWk9F1FweBnIMNC5UrhoJKYOJ3kTdsbTBGE5Z/raVbHVaFgagYXRDQf/pzXZj9LTpVzt8kFMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB8826.namprd11.prod.outlook.com (2603:10b6:8:256::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Tue, 13 May
 2025 19:12:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Tue, 13 May 2025
 19:12:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 04/21] KVM: TDX: Enforce 4KB mapping level during TD
 build Time
Thread-Topic: [RFC PATCH 04/21] KVM: TDX: Enforce 4KB mapping level during TD
 build Time
Thread-Index: AQHbtMX0QkZFfhf9pEmrzVEY6ZmWz7PRDEyA
Date: Tue, 13 May 2025 19:12:10 +0000
Message-ID: <45ae219d565a7d2275c57a77cd00d629673ec625.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030500.32720-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030500.32720-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB8826:EE_
x-ms-office365-filtering-correlation-id: 5ae3b849-e694-4009-5827-08dd92520ffa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eDB6bjhTb2RWL3NPMDhFajMwd0dSMlhXUkJrLzBYSDJ0U1RkdkY5MWZOTFJE?=
 =?utf-8?B?MndUQU5xNTJXRGcrRW1kSFdBMm9JeEx4QThqN1BOdW8waUFvaFR4M1ozUzll?=
 =?utf-8?B?bUVPb0lTeklXdnBGVk1qVUNkLyt0dWlCKzQ1MnhQbG9lRlY4VEpkYWliQ1JN?=
 =?utf-8?B?eEFKc0RRbXJTbHFVRTFta25ydjV1djBORXBDSU5Wbzc5TGVzRXhTcjI0aS92?=
 =?utf-8?B?ODZzZXF6UEVDSlRoa2FWZTNTdVpvL0xkWC80djJZclJsMDdGcHV0YXJ0ZmpK?=
 =?utf-8?B?S1ErUGFYMktMSzRBTEJia1FJcDhvT1J5Yzl3c3NEY3BmUGZ0WlBKZUNZYStQ?=
 =?utf-8?B?dkhzVEoyMVFEYyt4OUFodWt3MzlUWXJJTERvb2JYVU1xaitsN2plNmNhTU44?=
 =?utf-8?B?Ni9WamJCZkttMlZwWG03Z2pjZ3M0N3JXOFFaamJoTUNNTUNjWWZ4QitxU2xx?=
 =?utf-8?B?ajFxSkJRNWtqY2N2SDdueERKVmVDNDlsYWxoOStsOVJGM01ESGxtaHNaeXBD?=
 =?utf-8?B?N0Rob0NjSVNQUk1PYlpNZVBTQ1ZmeUJMWTRsSUQ0aDVaYVoyQTAzRmhDN3ht?=
 =?utf-8?B?bW9aa250L1U2cFVTc1U0aE1IZHNaVG1Ka1dWRlQ2MFhhbWhrQWVNYzQzaW5z?=
 =?utf-8?B?ZElSTnQvMmVQR01Wa3NyaUVSck04TnhTc0RNUVdtWXR3R1B1dndweTAybk5D?=
 =?utf-8?B?bVlNSWhGYzEzUzhndjF4NGxrSTlaa0Z6MWt5VFk4blI5MXNXNmxNeTRseXpR?=
 =?utf-8?B?YzFvSmlYR2RKV2V1aU5SdGlpSkdQNksvenBmcXRzT2ZIUzB1MnliNzhHZjBi?=
 =?utf-8?B?SjFtUnozeFZtVy9sQ0E5YmErbndFbk52RjdnT1hHdngyZ05QOXFFUkR2ZS9z?=
 =?utf-8?B?QTF2SjhCdm9hUllReXhMVjlvalRaSTF3NDFnL1o0eHE0NmU3am41U1Q1MHFa?=
 =?utf-8?B?Y1FIamRUanl4ZnNoQXVTZUJvMXlBSHdrZUIrZWhNQms5aURkNnNyOERqMVdR?=
 =?utf-8?B?d1VyazhDN1NXYXlVdUh2b0M5UTRJNUw3dmhPWFFKZExWWitvbkZzTjdraU4w?=
 =?utf-8?B?YVBYcFh3RDdSakxJK1dpMFdjQTRBZUZkU1NFTnM2T20vN2sxY3psV1EvMi94?=
 =?utf-8?B?bW96MDhVYWtiUEhmN0Z6MXhhTEZMcUduck1hUStVU3hVS1BlUjdSTWprV0Zh?=
 =?utf-8?B?SUo5c3hKRjhBVTRKejc0Q3lnTWgxRDJ4OXhOMEQ4VVZGbUhZcFphczdMUVll?=
 =?utf-8?B?MHZJTXhqNHlreVJTQVArcWlTNzlmeG9xSHJobHQ2T1Rub2huS284cFhER1Zw?=
 =?utf-8?B?SU9FY3BvUWdxWkxqcnJqMWY3QllpMCtmdzk4YnNObjZOUDVUQjZ0cXF5L04z?=
 =?utf-8?B?RmY1WWUxM0lIV2FwNXVPMk1UQWdwVThZQk1PUE9lcld0UnlwcS9lZkFFY3E3?=
 =?utf-8?B?R0grdjdSbEFKSjc3RE5KRkhaR3hYcWROUUdxVE9RTkNuVEU2ZVV0eGJMMXlH?=
 =?utf-8?B?OWtBVXcyZ2tQaU9uQ1ZjYWpndWNuRmk4R2hvRjVaUmVMYTdTM2tRODNIaTNW?=
 =?utf-8?B?QXVtbVpwQUlnVzJrNEdDUUhHM1I4aTlxVlcrZXpDYnA3WkRTT2hVeklGSHht?=
 =?utf-8?B?VllKN2hkTkRKcGpEVVZUQkZqaHRvOXlkN0pHSVdkWWhja2FGNy9TdjR5cHNU?=
 =?utf-8?B?Ui9WZ0wyMXVQaDlUbFN2a2t3SkxNYWREd3ZiV0VEVzVFMENQNHRTWFAreWtM?=
 =?utf-8?B?bllMc1VJT3FEL3pYQ1dFOVNEa0EzNUExRWJmMmxCTmdsZHh6V1Fneis3TVM2?=
 =?utf-8?B?THRtWER4QnZWcHdEeG5XWTc1YnZEM2lYNnpJZTFsemxPN0tUZEpsanhoM2k1?=
 =?utf-8?B?SzlvcTREOUYzdSs2dU44U01aNzVsSU9ib21jTDBFUWNJd0RBRDRBR3lvZEQw?=
 =?utf-8?B?QjB1R1lwbU03UnRQOXhuT0NPY094RGhtN1JjWnhrVnR2THVUS28vb3VXTUph?=
 =?utf-8?Q?Elw5pNo7PkgsWG2KXjb7P3jHbe9Twc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXpacjJJblZ6OXV6by9sWCtocTJrak5IZTV0a3pVSnNBWGxaREhYWFFNVE51?=
 =?utf-8?B?N0VRTHlacStFK2R3YkZweFNwZ3hNV0FYWms2M0hKaVR3TGxhb1ZvTFBxRjRF?=
 =?utf-8?B?ZUxuaWNKYUE2Ri9zSnVzUEtoYnlYSFNQYUlDMndjd21mdHc3ZWo1N1p0SHBw?=
 =?utf-8?B?QjFCZmtFR2QzZE05ZCtmUHMvZHMwNjVoVzF2WTYvdHhiaXgrOUkxRFlxV1Ju?=
 =?utf-8?B?ODVwODUrRDBMZUhIN0VPRXQyM24vS3VBaWN1d2dqYkVKUTA2MTlFNjZMSS9Z?=
 =?utf-8?B?VHo1SXRSUGFYT2dmQ3ltdE40bVVUV1d1enBNV0dBMFRHRmdCNWJPd2hmb0Nt?=
 =?utf-8?B?Z2ZHYlZJVVcrMU1Rd2hEZzl4eDM1V0xoMWJkNTdtRkVNS0RIYWhVOXNpc2RU?=
 =?utf-8?B?UzJCUStYOTVML3kxdWVyaG5jaEQyL3dFU3laU0doeTlXbDVzU3Z6UjZGN2lR?=
 =?utf-8?B?Q1JnWFBsYm1qV2p1WDJZWnpwcm9YeDRiVDF3L2VoSDFUSEZ6N1FwK0Nzanl6?=
 =?utf-8?B?bTNJSkJ1TmpBTW5xTmtwYm9sRDNHZE93ZnRhM2Mxd3d3UXNYWjY5U0U4L1gv?=
 =?utf-8?B?K1ZTdHFrQ1VRaEp2UEE4Z0x1QUo5NXIvSGxxR1Ntc3RiOGpTYXdtRHBVb0RO?=
 =?utf-8?B?eWhiYkM3MFBTNGVpTTZobVFIL0c4alQ0V2xvSEVsRjdBS0ErMjVpNnpsejU3?=
 =?utf-8?B?Wm1BZkthTjFPS0hWNEFINk5pYmNzRzlaYVRWa05iWUtVSlRkT1ZKOUZuS1VH?=
 =?utf-8?B?dGhZZ0xlSjJoWlE5UFN6K3kxZjQraTNQYWhQZm41SmZwWkNjM2lpNE9FQmox?=
 =?utf-8?B?aGRqbGhkYkNRR0NDUjgyQWhuK0J1SVcvL1JnaWNvaEtaMHBtVmNqS29BSTZF?=
 =?utf-8?B?NHFXeE9jMmhpQmxjaXAxczRLV3NoanlFcTVtQlo1V2JNd3FLZERRTHdlTFJj?=
 =?utf-8?B?N0pXcmtIRVlZZUZzQnJmRDRoTnJFLzhIQU8rKzk5MjdGN0M2MWN4RnU4RFpJ?=
 =?utf-8?B?NXdLbUcyMDlJaWVSdTJySEpaU0VpL3RadjZhKzBHOVBSbzVyTW8vemZjNTRq?=
 =?utf-8?B?eEZvUXIvOHVETzI0RENHS2VuQnBBYTV2TzYyalp1QXpwWXhlRXVOR0M3MFdm?=
 =?utf-8?B?VlRDMnRCOVFPeGo5SWxuWTJHbWV4SDNCeWZNQUl1dGZSUTlBaDUxK3FZYndx?=
 =?utf-8?B?aEp0RlNMUmd3QU11alFwaHdnV3ZRY05oYUVHQUduZFBVamJ6Rjg4QVpuc2xp?=
 =?utf-8?B?a0oxRjI0a0J3WkpMSVA3Zzc1VFF4eWp4c2lHa3JEbXc0Q25XTStBK0VSVVd0?=
 =?utf-8?B?bW1nNlh0T2NyTnBIbi9xbHFLYnN6TXVIYWxDT1lVUVkzaGkxZEQrRUhsa200?=
 =?utf-8?B?VFZWZ25sNXExaFhnaHoxNXhLZU5zZ1dBN25XUk5KRWNYRUNOTGhGaU91UFNr?=
 =?utf-8?B?Sm1qeDhFUjJ3TkxibmxSOGx6TDdOZjdzalNubWVxZ1ZuS1VSL2VjZVlXVHFv?=
 =?utf-8?B?OW9IQldwbldpdUFLdnllWDhNYlYzMWV0dmRRenZmTS9iOGdKRHRyVDROcDRh?=
 =?utf-8?B?WDZiZStnYk9QakkyMTY0cGFGM0U4TUNReEFTWXVsQUhuSVNvRFNST1lyQTY3?=
 =?utf-8?B?R1IvR0oxVGNaaFFFOXZydEFxRVQ0L0p5S0ZQbFM0UDdhVXkxRGZqMWt1SitO?=
 =?utf-8?B?b3YrU0JsemluUVR5WmE0K2cweFpVQTNVME9FV25GSDROYlNOSGgwdWptSTAx?=
 =?utf-8?B?cUI3SzNzejZMWi9DaWRkUWpBcGxRTWhpOFhZKzVDY0p3NTZLcVkyL3czMUE3?=
 =?utf-8?B?SjVGZEFWZWdxM3U5OUhRVWlHTWZmaXpsRWx3L0Z1VnMxK1hjRFZHeFJKYVpH?=
 =?utf-8?B?YTBzU0wvTVkzS3J0QjRJVEVpdVp4QUc3SmlqUy9xTm9wWTdZRUloMTZzTnFO?=
 =?utf-8?B?THZOSnEvcCtHd3BjZzhYUENuVmFubzEzdEdPa20yamhUK1E0TitiT2h2SDZ4?=
 =?utf-8?B?bzdBTkJNR0VsWnphU3QvSzEwZkg3T0JFbk03b0VEV3VuOHd5RUR5QTZiRjNr?=
 =?utf-8?B?Nm02R0VvVjhEdGE3cldFaWIzdUVmWG43TkRldFZNNjMvdnYrZHkvbHhsejBN?=
 =?utf-8?B?K2ZrenlSMm1vd0hIb0RmOEFOTHVCU3V5UDV4RHFTM0RpeERLRlVLWTBFSWVz?=
 =?utf-8?Q?Q3cD6tTRwyqgD9KSZXP9XzM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D4BF1F60CF81E4AA2E6231F96A203B8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae3b849-e694-4009-5827-08dd92520ffa
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 19:12:10.9018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ThECO1zE8CAU6sLrxH7ZO9xpbpAyMBtE7OBlYfGayN8eQ4b6WMgJln7y5jRvk6LfGEh1rCKg/1kpeI4yxOIxeT6hIvmqqeUhgbQAeor7e9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8826
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA1ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gRHVy
aW5nIHRoZSBURCBidWlsZCBwaGFzZSAoaS5lLiwgYmVmb3JlIHRoZSBURCBiZWNvbWVzIFJVTk5B
QkxFKSwgZW5mb3JjZSBhDQo+IDRLQiBtYXBwaW5nIGxldmVsIGJvdGggaW4gdGhlIFMtRVBUIG1h
bmFnZWQgYnkgdGhlIFREWCBtb2R1bGUgYW5kIHRoZQ0KPiBtaXJyb3IgcGFnZSB0YWJsZSBtYW5h
Z2VkIGJ5IEtWTS4NCj4gDQo+IER1cmluZyB0aGlzIHBoYXNlLCBURCdzIG1lbW9yeSBpcyBhZGRl
ZCB2aWEgdGRoX21lbV9wYWdlX2FkZCgpLCB3aGljaCBvbmx5DQo+IGFjY2VwdHMgNEtCIGdyYW51
bGFyaXR5LiBUaGVyZWZvcmUsIHJldHVybiBQR19MRVZFTF80SyBpbiBURFgncw0KPiAucHJpdmF0
ZV9tYXhfbWFwcGluZ19sZXZlbCBob29rIHRvIGVuc3VyZSBLVk0gbWFwcyBhdCB0aGUgNEtCIGxl
dmVsIGluIHRoZQ0KPiBtaXJyb3IgcGFnZSB0YWJsZS4gTWVhbndoaWxlLCBpdGVyYXRlIG92ZXIg
ZWFjaCA0S0IgcGFnZSBvZiBhIGxhcmdlIGdtZW0NCj4gYmFja2VuZCBwYWdlIGluIHRkeF9nbWVt
X3Bvc3RfcG9wdWxhdGUoKSBhbmQgaW52b2tlIHRkaF9tZW1fcGFnZV9hZGQoKSB0bw0KPiBtYXAg
YXQgdGhlIDRLQiBsZXZlbCBpbiB0aGUgUy1FUFQuDQo+IA0KPiBTdGlsbCBhbGxvdyBodWdlIHBh
Z2VzIGluIGdtZW0gYmFja2VuZCBkdXJpbmcgVEQgYnVpbGQgdGltZS4gQmFzZWQgb24gWzFdLA0K
PiB3aGljaCBnbWVtIHNlcmllcyBhbGxvd3MgMk1CIFRQSCBhbmQgbm9uLWluLXBsYWNlIGNvbnZl
cnNpb24sIHBhc3MgaW4NCj4gcmVnaW9uLm5yX3BhZ2VzIHRvIGt2bV9nbWVtX3BvcHVsYXRlKCkg
aW4gdGR4X3ZjcHVfaW5pdF9tZW1fcmVnaW9uKCkuDQo+IA0KDQpUaGlzIGNvbW1pdCBsb2cgd2ls
bCBuZWVkIHRvIGJlIHdyaXR0ZW4gd2l0aCB1cHN0cmVhbSBpbiBtaW5kIHdoZW4gaXQgaXMgb3V0
IG9mDQpSRkMuDQoNCj4gIFRoaXMNCj4gZW5hYmxlcyBrdm1fZ21lbV9wb3B1bGF0ZSgpIHRvIGFs
bG9jYXRlIGh1Z2UgcGFnZXMgZnJvbSB0aGUgZ21lbSBiYWNrZW5kDQo+IHdoZW4gdGhlIHJlbWFp
bmluZyBucl9wYWdlcywgR0ZOIGFsaWdubWVudCwgYW5kIHBhZ2UgcHJpdmF0ZS9zaGFyZWQNCj4g
YXR0cmlidXRlIHBlcm1pdC4gIEtWTSBpcyB0aGVuIGFibGUgdG8gcHJvbW90ZSB0aGUgaW5pdGlh
bCA0SyBtYXBwaW5nIHRvDQo+IGh1Z2UgYWZ0ZXIgVEQgaXMgUlVOTkFCTEUuDQo+IA0KPiBEaXNh
bGxvdyBhbnkgcHJpdmF0ZSBodWdlIHBhZ2VzIGR1cmluZyBURCBidWlsZCB0aW1lLiBVc2UgQlVH
X09OKCkgaW4NCj4gdGR4X21lbV9wYWdlX3JlY29yZF9wcmVtYXBfY250KCkgYW5kIHRkeF9pc19z
ZXB0X3phcF9lcnJfZHVlX3RvX3ByZW1hcCgpIHRvDQo+IGFzc2VydCB0aGUgbWFwcGluZyBsZXZl
bCBpcyA0S0IuDQo+IA0KPiBPcHBvcnR1bmlzdGljYWxseSwgcmVtb3ZlIHVudXNlZCBwYXJhbWV0
ZXJzIGluDQo+IHRkeF9tZW1fcGFnZV9yZWNvcmRfcHJlbWFwX2NudCgpLg0KPiANCj4gTGluazog
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjQxMjEyMDYzNjM1LjcxMjg3Ny0xLW1pY2hh
ZWwucm90aEBhbWQuY29tIFsxXQ0KPiBTaWduZWQtb2ZmLWJ5OiBZYW4gWmhhbyA8eWFuLnkuemhh
b0BpbnRlbC5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL3ZteC90ZHguYyB8IDQ1ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQs
IDMwIGluc2VydGlvbnMoKyksIDE1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L2t2bS92bXgvdGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+IGluZGV4IDk4
Y2RlMjBmMTRkYS4uMDM4ODVjYjI4NjliIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14
L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gQEAgLTE1MzAsMTQgKzE1
MzAsMTYgQEAgc3RhdGljIGludCB0ZHhfbWVtX3BhZ2VfYXVnKHN0cnVjdCBrdm0gKmt2bSwgZ2Zu
X3QgZ2ZuLA0KPiAgICogVGhlIGNvdW50ZXIgaGFzIHRvIGJlIHplcm8gb24gS1ZNX1REWF9GSU5B
TElaRV9WTSwgdG8gZW5zdXJlIHRoYXQgdGhlcmUNCj4gICAqIGFyZSBubyBoYWxmLWluaXRpYWxp
emVkIHNoYXJlZCBFUFQgcGFnZXMuDQo+ICAgKi8NCj4gLXN0YXRpYyBpbnQgdGR4X21lbV9wYWdl
X3JlY29yZF9wcmVtYXBfY250KHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0KPiAtCQkJCQkg
IGVudW0gcGdfbGV2ZWwgbGV2ZWwsIGt2bV9wZm5fdCBwZm4pDQo+ICtzdGF0aWMgaW50IHRkeF9t
ZW1fcGFnZV9yZWNvcmRfcHJlbWFwX2NudChzdHJ1Y3Qga3ZtICprdm0sIGVudW0gcGdfbGV2ZWwg
bGV2ZWwpDQo+ICB7DQo+ICAJc3RydWN0IGt2bV90ZHggKmt2bV90ZHggPSB0b19rdm1fdGR4KGt2
bSk7DQo+ICANCj4gIAlpZiAoS1ZNX0JVR19PTihrdm0tPmFyY2gucHJlX2ZhdWx0X2FsbG93ZWQs
IGt2bSkpDQo+ICAJCXJldHVybiAtRUlOVkFMOw0KPiAgDQo+ICsJaWYgKEtWTV9CVUdfT04obGV2
ZWwgIT0gUEdfTEVWRUxfNEssIGt2bSkpDQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiArDQo+ICAJ
LyogbnJfcHJlbWFwcGVkIHdpbGwgYmUgZGVjcmVhc2VkIHdoZW4gdGRoX21lbV9wYWdlX2FkZCgp
IGlzIGNhbGxlZC4gKi8NCj4gIAlhdG9taWM2NF9pbmMoJmt2bV90ZHgtPm5yX3ByZW1hcHBlZCk7
DQo+ICAJcmV0dXJuIDA7DQo+IEBAIC0xNTcxLDcgKzE1NzMsNyBAQCBpbnQgdGR4X3NlcHRfc2V0
X3ByaXZhdGVfc3B0ZShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwNCj4gIAlpZiAobGlrZWx5
KGt2bV90ZHgtPnN0YXRlID09IFREX1NUQVRFX1JVTk5BQkxFKSkNCj4gIAkJcmV0dXJuIHRkeF9t
ZW1fcGFnZV9hdWcoa3ZtLCBnZm4sIGxldmVsLCBwYWdlKTsNCj4gIA0KPiAtCXJldHVybiB0ZHhf
bWVtX3BhZ2VfcmVjb3JkX3ByZW1hcF9jbnQoa3ZtLCBnZm4sIGxldmVsLCBwZm4pOw0KPiArCXJl
dHVybiB0ZHhfbWVtX3BhZ2VfcmVjb3JkX3ByZW1hcF9jbnQoa3ZtLCBsZXZlbCk7DQo+ICB9DQo+
ICANCj4gIHN0YXRpYyBpbnQgdGR4X3NlcHRfZHJvcF9wcml2YXRlX3NwdGUoc3RydWN0IGt2bSAq
a3ZtLCBnZm5fdCBnZm4sDQo+IEBAIC0xNjY2LDcgKzE2NjgsNyBAQCBpbnQgdGR4X3NlcHRfbGlu
a19wcml2YXRlX3NwdChzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwNCj4gIHN0YXRpYyBpbnQg
dGR4X2lzX3NlcHRfemFwX2Vycl9kdWVfdG9fcHJlbWFwKHN0cnVjdCBrdm1fdGR4ICprdm1fdGR4
LCB1NjQgZXJyLA0KPiAgCQkJCQkgICAgIHU2NCBlbnRyeSwgaW50IGxldmVsKQ0KPiAgew0KPiAt
CWlmICghZXJyIHx8IGt2bV90ZHgtPnN0YXRlID09IFREX1NUQVRFX1JVTk5BQkxFKQ0KPiArCWlm
ICghZXJyIHx8IGt2bV90ZHgtPnN0YXRlID09IFREX1NUQVRFX1JVTk5BQkxFIHx8IGxldmVsID4g
UEdfTEVWRUxfNEspDQo+ICAJCXJldHVybiBmYWxzZTsNCg0KVGhpcyBpcyBjYXRjaGluZyB6YXBw
aW5nIGh1Z2UgcGFnZXMgYmVmb3JlIHRoZSBURCBpcyBydW5uYWJsZT8gSXMgaXQgbmVjZXNzYXJ5
DQppZiB3ZSBhcmUgYWxyZWFkeSB3YXJuaW5nIGFib3V0IG1hcHBpbmcgaHVnZSBwYWdlcyBiZWZv
cmUgdGhlIFREIGlzIHJ1bm5hYmxlIGluDQp0ZHhfbWVtX3BhZ2VfcmVjb3JkX3ByZW1hcF9jbnQo
KT8NCg0KPiAgDQo+ICAJaWYgKGVyciAhPSAoVERYX0VQVF9FTlRSWV9TVEFURV9JTkNPUlJFQ1Qg
fCBURFhfT1BFUkFORF9JRF9SQ1gpKQ0KPiBAQCAtMzA1Miw4ICszMDU0LDggQEAgc3RydWN0IHRk
eF9nbWVtX3Bvc3RfcG9wdWxhdGVfYXJnIHsNCj4gIAlfX3UzMiBmbGFnczsNCj4gIH07DQo+ICAN
Cj4gLXN0YXRpYyBpbnQgdGR4X2dtZW1fcG9zdF9wb3B1bGF0ZShzdHJ1Y3Qga3ZtICprdm0sIGdm
bl90IGdmbiwga3ZtX3Bmbl90IHBmbiwNCj4gLQkJCQkgIHZvaWQgX191c2VyICpzcmMsIGludCBv
cmRlciwgdm9pZCAqX2FyZykNCj4gK3N0YXRpYyBpbnQgdGR4X2dtZW1fcG9zdF9wb3B1bGF0ZV80
ayhzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwga3ZtX3Bmbl90IHBmbiwNCj4gKwkJCQkgICAg
IHZvaWQgX191c2VyICpzcmMsIHZvaWQgKl9hcmcpDQo+ICB7DQo+ICAJdTY0IGVycm9yX2NvZGUg
PSBQRkVSUl9HVUVTVF9GSU5BTF9NQVNLIHwgUEZFUlJfUFJJVkFURV9BQ0NFU1M7DQo+ICAJc3Ry
dWN0IGt2bV90ZHggKmt2bV90ZHggPSB0b19rdm1fdGR4KGt2bSk7DQo+IEBAIC0zMTIwLDYgKzMx
MjIsMjEgQEAgc3RhdGljIGludCB0ZHhfZ21lbV9wb3N0X3BvcHVsYXRlKHN0cnVjdCBrdm0gKmt2
bSwgZ2ZuX3QgZ2ZuLCBrdm1fcGZuX3QgcGZuLA0KPiAgCXJldHVybiByZXQ7DQo+ICB9DQo+ICAN
Cj4gK3N0YXRpYyBpbnQgdGR4X2dtZW1fcG9zdF9wb3B1bGF0ZShzdHJ1Y3Qga3ZtICprdm0sIGdm
bl90IGdmbiwga3ZtX3Bmbl90IHBmbiwNCj4gKwkJCQkgIHZvaWQgX191c2VyICpzcmMsIGludCBv
cmRlciwgdm9pZCAqX2FyZykNCj4gK3sNCj4gKwl1bnNpZ25lZCBsb25nIGksIG5wYWdlcyA9IDEg
PDwgb3JkZXI7DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCWZvciAoaSA9IDA7IGkgPCBucGFnZXM7
IGkrKykgew0KPiArCQlyZXQgPSB0ZHhfZ21lbV9wb3N0X3BvcHVsYXRlXzRrKGt2bSwgZ2ZuICsg
aSwgcGZuICsgaSwNCj4gKwkJCQkJCXNyYyArIGkgKiBQQUdFX1NJWkUsIF9hcmcpOw0KPiArCQlp
ZiAocmV0KQ0KPiArCQkJcmV0dXJuIHJldDsNCj4gKwl9DQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+
ICsNCj4gIHN0YXRpYyBpbnQgdGR4X3ZjcHVfaW5pdF9tZW1fcmVnaW9uKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSwgc3RydWN0IGt2bV90ZHhfY21kICpjbWQpDQo+ICB7DQo+ICAJc3RydWN0IHZjcHVf
dGR4ICp0ZHggPSB0b190ZHgodmNwdSk7DQo+IEBAIC0zMTY2LDIwICszMTgzLDE1IEBAIHN0YXRp
YyBpbnQgdGR4X3ZjcHVfaW5pdF9tZW1fcmVnaW9uKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3Ry
dWN0IGt2bV90ZHhfY21kICpjDQo+ICAJCX07DQo+ICAJCWdtZW1fcmV0ID0ga3ZtX2dtZW1fcG9w
dWxhdGUoa3ZtLCBncGFfdG9fZ2ZuKHJlZ2lvbi5ncGEpLA0KPiAgCQkJCQkgICAgIHU2NF90b191
c2VyX3B0cihyZWdpb24uc291cmNlX2FkZHIpLA0KPiAtCQkJCQkgICAgIDEsIHRkeF9nbWVtX3Bv
c3RfcG9wdWxhdGUsICZhcmcpOw0KPiArCQkJCQkgICAgIHJlZ2lvbi5ucl9wYWdlcywgdGR4X2dt
ZW1fcG9zdF9wb3B1bGF0ZSwgJmFyZyk7DQo+ICAJCWlmIChnbWVtX3JldCA8IDApIHsNCj4gIAkJ
CXJldCA9IGdtZW1fcmV0Ow0KPiAgCQkJYnJlYWs7DQo+ICAJCX0NCj4gIA0KPiAtCQlpZiAoZ21l
bV9yZXQgIT0gMSkgew0KPiAtCQkJcmV0ID0gLUVJTzsNCj4gLQkJCWJyZWFrOw0KPiAtCQl9DQo+
IC0NCj4gLQkJcmVnaW9uLnNvdXJjZV9hZGRyICs9IFBBR0VfU0laRTsNCj4gLQkJcmVnaW9uLmdw
YSArPSBQQUdFX1NJWkU7DQo+IC0JCXJlZ2lvbi5ucl9wYWdlcy0tOw0KPiArCQlyZWdpb24uc291
cmNlX2FkZHIgKz0gUEFHRV9TSVpFICogZ21lbV9yZXQ7DQoNCmdtZW1fcmV0IGhhcyB0byBiZSAx
LCBwZXIgdGhlIGFib3ZlIGNvbmRpdGlvbmFsLg0KDQo+ICsJCXJlZ2lvbi5ncGEgKz0gUEFHRV9T
SVpFICogZ21lbV9yZXQ7DQo+ICsJCXJlZ2lvbi5ucl9wYWdlcyAtPSBnbWVtX3JldDsNCj4gIA0K
PiAgCQljb25kX3Jlc2NoZWQoKTsNCj4gIAl9DQo+IEBAIC0zMjI0LDYgKzMyMzYsOSBAQCBpbnQg
dGR4X3ZjcHVfaW9jdGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB2b2lkIF9fdXNlciAqYXJncCkN
Cj4gIA0KPiAgaW50IHRkeF9nbWVtX3ByaXZhdGVfbWF4X21hcHBpbmdfbGV2ZWwoc3RydWN0IGt2
bSAqa3ZtLCBrdm1fcGZuX3QgcGZuKQ0KPiAgew0KPiArCWlmICh1bmxpa2VseSh0b19rdm1fdGR4
KGt2bSktPnN0YXRlICE9IFREX1NUQVRFX1JVTk5BQkxFKSkNCj4gKwkJcmV0dXJuIFBHX0xFVkVM
XzRLOw0KPiArDQo+ICAJcmV0dXJuIFBHX0xFVkVMXzRLOw0KDQpeIENoYW5nZSBkb2VzIG5vdGhp
bmcuLi4NCg0KPiAgfQ0KPiAgDQoNCg==

