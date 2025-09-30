Return-Path: <kvm+bounces-59211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED551BAE3E0
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:47:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7F4D3AD31D
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A0624EAB1;
	Tue, 30 Sep 2025 17:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AykR4UM+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F081D5CD4;
	Tue, 30 Sep 2025 17:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759254446; cv=fail; b=VL//z1sod1QcREd7Jz2R2yNjwr74pX5fKP4GVsZy97mdKhBzhUmvBSEqfNgRpFNzTgBYNDFP2JsBPW3bty2qGxLcpA/ad/a02qdiAOxb/JzTHupuxiTKbmXfZYTZckwPONEKRPzmcxnr/vinbFtRXRf5ZPvkfdEEcY2qf5f8cW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759254446; c=relaxed/simple;
	bh=dut1hf4Je1vIuZ0urpCZEIjdknIqkWSEBvjlt80FdeM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pB/CDD6+neoJa9tDiCbu3s9OCvi1p4Id+CiuwQmiuniMrBdmk7SCpcWMsK9YLDiam9KRTz/4dNeGdeqs22e4pl7fCYo4R4WjCYyRcgV8Y54FeOfyqArtberdGzhwvogPZfxHEsi3a+syaP+5+QxZ2W44M92H49/A+iVGC2BEDp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AykR4UM+; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759254445; x=1790790445;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dut1hf4Je1vIuZ0urpCZEIjdknIqkWSEBvjlt80FdeM=;
  b=AykR4UM+UzkoMa5ZctPqrGFMJxflPGnoXPFQpO+XOcwcXeh54jaV5tnV
   7Zc5FvXWjtGPv1kCS0cZF2Qg18EhzHPKM/QlumImpgSIRqkeYWOEDfP14
   Xj4f3/AtvDixPwFBiTMC4ySj2mZxQiijeH1cGzOIVL6ousoKm+qdPNqS2
   wT8nGhfWQI/pEX6Ha6ZWeoTYv2uADWjhUdUPEZzvukIPMxHzL3s6jW+Sd
   HZBSrB8xhDxtyq0CyweYtVh199+85fmmwm4XgFXq6nlW/15L6t41EhxJM
   2leWEXEEL7LzLDMwDAyVdiwdd3cstDXVnpm1NI9RDne7i51EZAppky1GC
   A==;
X-CSE-ConnectionGUID: dOnGfkhYQRqcjeESsSYFWQ==
X-CSE-MsgGUID: Ew4BjMzEQ02cnfhhFLSXqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="78941370"
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="78941370"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 10:47:24 -0700
X-CSE-ConnectionGUID: uLaUgIMPS/utaEKblEOEGA==
X-CSE-MsgGUID: egOTHkEnRp2Yv8E+4Xr2Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="182995099"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 10:47:23 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 10:47:23 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 30 Sep 2025 10:47:23 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.3) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 10:47:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QenzzbfaRPxG7kHZoDYzlqBjZQgpzjrHXQFAKDCIyGbwp+9uh4LPwJ/lHtvUDpTcPc+90KMgYzhpcmDXrNEuc70Uo7Si2NwJmOk9pDLEKT+sc8UGhHAsdxcFFmZkfk+O4DiZFj3lPxLSda8sWvprlxDzYZNciSzydxGpFgyNcElM/k8qX/WwCCe4YG0hLhX5HfwbVnTNzGtDU+MwRqpRj2Ia5AUNcBqS2ccX9mHbeA3pDpK8gg9uihNDxglxz722sy8vmpkB0YfY3pudTV1yE8Q2nIquhe0BWdlMkiq1k0KUTUESZ0WgJy6QnHaGARo3a9IkIC1HE2wG561zdyvXgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dut1hf4Je1vIuZ0urpCZEIjdknIqkWSEBvjlt80FdeM=;
 b=j3b4WayRcTIIVzTmiP/CcB01ZfIgsV04X4YOnSGhw88mBFFjlmOxeoq5nBm1ENqMT/TIhWBc0vnHPiQrcX8+ZoY2FsjjxRrE3kw/8hqk0GN/PX29yMuEIKhB63dTXf09uJk1RrEqs7aYuNqxl+q0bPCbJjMpIDnhtdJ2UDgFrSiZSox2lg6ioUISmy1IcR4bApQjMQs61vBMSCOkwXMNJIpGvGGeY0r0YC4iqVWqR11ieKTCEmdXR0vNBzHifn4ZibBf46D1LvaRBZ5/rS2cs50hWhtRwKNO4/GwHrjFYsb7QDEmxudxlagrFDcrQv724zrsA52ziDpUM//12WyjvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH3PPFD114713BA.namprd11.prod.outlook.com (2603:10b6:518:1::d50) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 30 Sep
 2025 17:47:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 17:47:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v3 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcKPM1NzNrnMrGfkmDv8ppN4f8QLSr1DSAgAA+bQA=
Date: Tue, 30 Sep 2025 17:47:19 +0000
Message-ID: <6953f24da03b8ae61ba56b7cf6839d9c8ee44729.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-8-rick.p.edgecombe@intel.com>
	 <1f25ef49-fb7f-449c-be1d-71c19465219f@intel.com>
In-Reply-To: <1f25ef49-fb7f-449c-be1d-71c19465219f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH3PPFD114713BA:EE_
x-ms-office365-filtering-correlation-id: 593f31f0-52af-4c91-b119-08de00496706
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Z2QzaEg2ajFVWlFYT3ZkZ0RmcDBUbWlsOE5hQ0M4OHlielh4Tit1ZkY2bkdt?=
 =?utf-8?B?TmdSUTVVODBVeHEvMGhrSlNWbnJobkNSL1k5QWQ3UmVVNzZnbG43K2RkZkRV?=
 =?utf-8?B?ZExKeVJ4bzZsY211M0hPYzZmM3dwSDlXeFAxS2tWYUxoRDZWWjFDZ3pYWUs2?=
 =?utf-8?B?a3FhdVhMZy9COTZDM1l3Q0lKdHluWXZMY1p4dnlEQzlsY3owOVpDem9sU2VT?=
 =?utf-8?B?WUxmVENXYnpPNzF5Y1hobDIxVTdvMDhVYVRvMHRnM3RZMUxzNjJmTU05Szlr?=
 =?utf-8?B?YjdqOXRINHV5VG5ONkZodnVtS1NFa0pMMjRJeHdZQzMybWp1aCsyMUJsdEdy?=
 =?utf-8?B?U2FyV2MyK0VIZC93S0FrM0FUWlFRTStuRm85b1YrQWVnL2xURVdNWUllMGxw?=
 =?utf-8?B?VFEvTFAwYWNUUlNlWC84VE9XdWNENmt1ZzNUbkV2bm5KaUlVTy9wWFE3UXF4?=
 =?utf-8?B?YkExckJxRFFMYkRTc1F3QVJ4Ri9zTVV1Rm1tQ0hrK0FsZHpUbktSMm80dWd6?=
 =?utf-8?B?NGhwbWpMZU9GMk00Ym5ieGpJMDhVc3ovd1BwckJPK0xEd3JtaWhNY1RNUW1m?=
 =?utf-8?B?RFVNM2xxOFZ4Q1h4dHMyU3dNN2JOcVBCRzFPT0IyNjk3QVlZcTFlQlNlOU51?=
 =?utf-8?B?TjBycjBBMFRaZUp2RHBoT0lvTzRXd1ZzSkxwSExiNlBEemp0cGttSDQ2WTgr?=
 =?utf-8?B?cmZmNEdlUWZUbDZ5NldybmRYbHJwNG9COXdYQ0FxT0llUjA5bThoalUyZXUz?=
 =?utf-8?B?RzdleG0wa3p2Y3pvVVY1cWRWUHIxUnd1Z0JEcEJJK3BYRzBhMTRYRGxLeWxo?=
 =?utf-8?B?am9NRHNBcDUrSnFPRmZUL20vYWFNbU40cm9ZV2lCTTRZa2tFZlc0QXB3cVRV?=
 =?utf-8?B?T24xWXUwR3ZxU2UrL3NmZlNoUi9SUVllLzVTMWd6U2M5WG0xa3dybjBpcU05?=
 =?utf-8?B?ZHNrdENzb2NPem5ENnhnUHpZcHhuWFlibVdhTGw2clhBelRMQ3J2b0VIdVFp?=
 =?utf-8?B?bm9KZHRzclZzMXlMMDAwekVGL2RKcEt2d1llcEpXZXVUK3IrMmlrUkU2N01N?=
 =?utf-8?B?ZmpHbHo3ZGh3UzZUd0JkM01NRThFTnFCZmkvK2NobnI2cE5ydGpIakQ0d1V4?=
 =?utf-8?B?RzRpYnp5VWtqRy91cm9NQU80bnFXQ09aTmRya2ZuSmhvRFoxWkliL0Y0MW9H?=
 =?utf-8?B?ZGp3a3F1VmV6TkM0a2hWVTB0RnM1OVdkTmZ1YjFCTkI0c0Rxc090YmpsZlRO?=
 =?utf-8?B?QzA5VVk2L3d1aW5MZk9TQ2FtMCtON0R5ZVFtUGRDYnRGOFNzUWpvZjBtRml4?=
 =?utf-8?B?eEp6NE8xaEQ3c3BtZFdxQUhBQU12eTJTbXRxMDJwMmRBbURSUkFjS1NVOU4x?=
 =?utf-8?B?TkZ5UHVRSFdEd2s1ZEVaVHplZG56M2R4dzBGSXJRbnpweElIcU44R3dyRTM5?=
 =?utf-8?B?M0hMZEJnMTZXYXhQN1FDYzFlSHdRdnZUN011SFlabVBETG13dWphbjM1WGI2?=
 =?utf-8?B?UnNDWTlnZ2NuY0RNMkU2dncrRzlUbXpQSXJQd2xCTmZLVE5mdDJnRXFvRHNJ?=
 =?utf-8?B?T3FqREVIcnhpVDZYY0djRXIyMDNOdDM5ZkorRWlEeEJxYnQ4U0RrTTgyNit2?=
 =?utf-8?B?a2Rnd2lhSFN1MkErQ0JJeTZlZGZSYWlyM3dDalE0UlN6MVE0ZFBjWGpXVmNX?=
 =?utf-8?B?cjd2Ky9VNm5rQUpmKzI1amc5TEt6Z1FVUUZ3NWFlS0VwTytiQkFZRDFnVmND?=
 =?utf-8?B?TGtsbVdPbjBRQ0NVUTdWVllaTG85MlFDYURBb2dnYVV4enBkdE9mdElEVVhL?=
 =?utf-8?B?QnlaQlR3VFcyYzdaSFZrck04TUdtQjl3MDZSSmpKNVhBWFNabDd4RnVISEVu?=
 =?utf-8?B?NDAyRnFESmhkNGdiZllSTVplb3JaNnoxenBMYUw5YXhMVVVwMjNRbEhwM2Fs?=
 =?utf-8?B?MU94NWlPQmk5cU0ybXp5bGs3R2N5Zyt4UUJVVCtsSEo5WTBCTTRqK3lQVWFL?=
 =?utf-8?B?ZVBRYVUrRVJxUFNOVThBbjBxbmIzd0hQYzU4UmNnRW5TN1NnbjFHekdrbzZw?=
 =?utf-8?B?cHY3Uk5uWk9JSnRyREhBSjJVTDV6NlgyaWwwdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ek13cGdGN3BSSGY0Q2VDVllBc3FaYVkyY3RVZU1KLzdxRU5IUmZIQmI1K3BC?=
 =?utf-8?B?cjBYM3BSMmp3VHRkSkhsanZHZTVxU1hWclV2MWtkaGRLQ004cy9WY2pJcHhj?=
 =?utf-8?B?Mi9JSVlPZFBUQnYzZk1HR3dWWG44Q2ZrN09zMEErWEltbjFNNXRTQ3RrVGcz?=
 =?utf-8?B?VUR2L0UwZkRGc0RORDFtN2N3MXl5MUFkRTdqOGxGK2RpSjVmcmxqa1ROM1RL?=
 =?utf-8?B?Yy9KK24vbHRxKzhsRy9WMWl3Zlp4VEZWb04vYWRGR0VsLzFWMWJHb01zb0RD?=
 =?utf-8?B?UG43Wm5RMEU2YUVvY3h3L1Z2QWZvc1U0clM2T1RIY3dURXMybXdnaTJ6L1c5?=
 =?utf-8?B?dTdvWW9SOUpWQkpzYVhtM0lmSzcvbXZLV3ByQmU2cWR2aTkvQjIyaGprRGpK?=
 =?utf-8?B?YWo3MjFyUGtISGFhRXV0STQ3Z21rd25WWUZzMW5BaU5Sakt4NFk3TVVsdjMv?=
 =?utf-8?B?ekxYaXJWUUg0RkdYTXdKN2g1ZHZ4N3JCbVBhU2IxTW1PSDBnNjhXc2cvakxS?=
 =?utf-8?B?ZTFlekJyWDZzSmM5Vy9ZTU81L0RlTFk5M3pHSUlRdEtUMjkvTXpIOGdhaU11?=
 =?utf-8?B?eG1lbCtkSkY3UDl3Q2F2QytjZkQwUzd5MHl1ZW9zZElCbCs5ZHdlTXZRdmgr?=
 =?utf-8?B?NElHWEtCUGNpS3RrNThMY2o2Snh4QkN1WGVhV2E2aG1PdFVoNUtTVlVvWFNp?=
 =?utf-8?B?T3N1YmRvOUFLVFRoL0paUkR2SXp0S1VWWllsT2RsR1pobk9RblRON2gxVjVG?=
 =?utf-8?B?TlU0MFBseEgxS1N4NEVlVlF2TXUxNlJGdnhzV0Roc05hQUZDc3V0Nzl2dHd0?=
 =?utf-8?B?QnUweGpZamVRamlwWXpOa0lybUJkcHhBM0JMN2hma0J4SUNmZ1hiaGlnYkcy?=
 =?utf-8?B?aCtOYlM3VDhTUGhyK0FPU0x5bW5JUjE1c095ZjNNTGZGQ3g4dTlvZHJjMm5z?=
 =?utf-8?B?cUJvVDZXR0RFdk81OW1MaENGVk55eTh5ZENUak9mZ01HdVhPb0t4SmxKUnN0?=
 =?utf-8?B?SDhxRE1TM3dGQjliMXk0UitOa2J1QVUvdTdPYitmU2xjRFpXZmZ5OXQ2YmtQ?=
 =?utf-8?B?Q3k5OW1Ha0YvejRBemRHYnR5Rk5OZnh1ZlhHWTB2TE43cGNqYjJBTUdrTHJm?=
 =?utf-8?B?WW5CcnkxM3I3ZGEzVFlyNjA5aTAwNUMxWVJ6czl0TGx4ZTZmMExyckwrNkdL?=
 =?utf-8?B?VmhUeUNjRnROYU40dnF2RGsrVWJiVTJvbTRWRHJSdGdQaGQyR3FpTkRaNC8y?=
 =?utf-8?B?MXNENFBVbFU0R3ErOG5IY3pOTkZBZkxjdGVzaGpoSkFaUDhnbkluck96THlQ?=
 =?utf-8?B?b29LbU0rL2FZbDRXdC9kVVNRT0U0aldhdzJPY2RhaUFTSGtQMjI0d1ZtcVdY?=
 =?utf-8?B?c0tZenpGUjB5M1JFakROYjlpaGwvQS9KTUJyMlhiOXhKaXRmZEtaQklxd2ZZ?=
 =?utf-8?B?SktpWEdOOXZUY3I4dUtzM3VtWi8zK0VOY28zaGFZb1E2QXRwd2l6U3N3MDM1?=
 =?utf-8?B?aDhWNVlucjZLbmpjZk0yU3NURmhjRzVLZXNzODE0YW82dnRxQkZHbDhMcXcr?=
 =?utf-8?B?ZitPem5XQ2w3SGlsWlcvaUtTWkp3bVBqWkNJaDUvSERFYWUrVkkzZzlVY3VK?=
 =?utf-8?B?MG43ek40UjRqaEdVdktrdTlUMEhCWTR4dDV2ejVRamJaa1hjUTY2K0E4ZE1z?=
 =?utf-8?B?YVhvRURpSGVWSVNDeWhDZzhwcHFRTUlvbjYyN2xsRFhWMjVTT1BIYkVEV2JZ?=
 =?utf-8?B?ZmNtd2haWW5DZFE4Z0hUR3pjbDI0eGF4M3pZV2kwOGV4eVgrYzdiMkdaaEMw?=
 =?utf-8?B?V0VWZWhidnh1QUl4UG5oNE51cEYyUWlhaUxOYWl2VlJFYkdEcUd1SlNzSzZi?=
 =?utf-8?B?ajNWbXpVUVlodEZLTzJyYzJ2cUlTeUVrV05BRmhLTzZNZkNSUnpSN21WT04z?=
 =?utf-8?B?UElsdEhTT3VqdzZJRjNyUlE3ZFhSM1EwWkZOc2JQMUR5Q2dkL1V2WGNITGF5?=
 =?utf-8?B?WHlIaFFrOFhFc2xLYTlMQnVnSndOTVREaU83S1lIY2JCa05FRzlhWDBFL1lT?=
 =?utf-8?B?R2dRd0FQMEI4WjU4VkxjQXZ1ZmNHaHBQd01VTm0za1p1dlZ4ekZZQnBwa2tJ?=
 =?utf-8?B?ZDUwWDByekhOU2taS0dDKytRaVlKMDJHbWVXQ0dUNTFhRHV0VkQ4WnZjdFFX?=
 =?utf-8?B?OUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2E594853E82544A9289F9E63BD5BC5B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 593f31f0-52af-4c91-b119-08de00496706
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2025 17:47:19.4103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2KsBlUHAMQCLOM2oSTr6Cfml5rvvYBpEF+NHtgzpXukr57SZMn0nrOExYcjaMIx4HSTO49OuELpknimaayQqnQL4GXKLMY1T+jsMeobuyJc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFD114713BA
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTMwIGF0IDIyOjAzICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
ICsvKiBCdW1wIFBBTVQgcmVmY291bnQgZm9yIHRoZSBnaXZlbiBwYWdlIGFuZCBhbGxvY2F0ZSBQ
QU1UIG1lbW9yeSBpZiBuZWVkZWQNCj4gPiAqLw0KPiA+ICtpbnQgdGR4X3BhbXRfZ2V0KHN0cnVj
dCBwYWdlICpwYWdlKQ0KPiA+ICt7DQo+ID4gKwl1bnNpZ25lZCBsb25nIGhwYSA9IEFMSUdOX0RP
V04ocGFnZV90b19waHlzKHBhZ2UpLCBQTURfU0laRSk7DQo+ID4gKwl1NjQgcGFtdF9wYV9hcnJh
eVtNQVhfRFBBTVRfQVJHX1NJWkVdOw0KPiA+ICsJYXRvbWljX3QgKnBhbXRfcmVmY291bnQ7DQo+
ID4gKwl1NjQgdGR4X3N0YXR1czsNCj4gPiArCWludCByZXQ7DQo+ID4gKw0KPiA+ICsJaWYgKCF0
ZHhfc3VwcG9ydHNfZHluYW1pY19wYW10KCZ0ZHhfc3lzaW5mbykpDQo+ID4gKwkJcmV0dXJuIDA7
DQo+ID4gKw0KPiA+ICsJcmV0ID0gYWxsb2NfcGFtdF9hcnJheShwYW10X3BhX2FycmF5KTsNCj4g
PiArCWlmIChyZXQpDQo+ID4gKwkJcmV0dXJuIHJldDsNCj4gPiArDQo+ID4gKwlwYW10X3JlZmNv
dW50ID0gdGR4X2ZpbmRfcGFtdF9yZWZjb3VudChocGEpOw0KPiA+ICsNCj4gPiArCXNjb3BlZF9n
dWFyZChzcGlubG9jaywgJnBhbXRfbG9jaykgew0KPiA+ICsJCWlmIChhdG9taWNfcmVhZChwYW10
X3JlZmNvdW50KSkNCj4gDQo+IEl0J3Mgbm90IHdoYXQgSSBleHBlY3QgdGhlIHJlZmNvdW50IHRv
IHdvcmsgKG1heWJlIEkgbWlzcyBzb21ldGhpbmcgDQo+IHNlcmlvdXNseT8pDQo+IA0KPiBNeSB1
bmRlcnN0YW5kaW5nL2V4cGVjdGF0aW9uIGlzIHRoYXQsIHdoZW4gcmVmY291bnQgaXMgbm90IHpl
cm8gaXQgbmVlZHMgDQo+IHRvIGluY3JlbWVudCB0aGUgcmVmY291bnQgaW5zdGVhZCBvZiBzaW1w
bHkgcmV0dXJuLiBBbmQgLi4uDQoNCkFyZ2gsIHllcy4gVGhlIGZvbGxvd2luZyBvcHRpbWl6YXRp
b24gcGF0Y2ggc2hvdWxkIGNoYW5nZSB0aGlzIHRvIGJlaGF2ZQ0Kbm9ybWFsbHkgd2l0aCByZXNw
ZWN0IHRoZSByZWZjb3VudC4gSSBzaG91bGQgaGF2ZSB0ZXN0ZWQgaXQgd2l0aCB0aGUNCm9wdGlt
aXphdGlvbiBwYXRjaGVzIHJlbW92ZWQsIEknbGwgZG8gdGhhdCBuZXh0IHRpbWUuDQoNCj4gDQo+
ID4gKwkJCWdvdG8gb3V0X2ZyZWU7DQo+ID4gKw0KPiA+ICsJCXRkeF9zdGF0dXMgPSB0ZGhfcGh5
bWVtX3BhbXRfYWRkKGhwYSB8IFREWF9QU18yTSwNCj4gPiBwYW10X3BhX2FycmF5KTsNCj4gPiAr
DQo+ID4gKwkJaWYgKElTX1REWF9TVUNDRVNTKHRkeF9zdGF0dXMpKSB7DQo+ID4gKwkJCWF0b21p
Y19pbmMocGFtdF9yZWZjb3VudCk7DQo+ID4gKwkJfSBlbHNlIHsNCj4gPiArCQkJcHJfZXJyKCJU
REhfUEhZTUVNX1BBTVRfQUREIGZhaWxlZDogJSNsbHhcbiIsDQo+ID4gdGR4X3N0YXR1cyk7DQo+
ID4gKwkJCWdvdG8gb3V0X2ZyZWU7DQo+ID4gKwkJfQ0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCXJl
dHVybiByZXQ7DQo+ID4gK291dF9mcmVlOg0KPiA+ICsJZnJlZV9wYW10X2FycmF5KHBhbXRfcGFf
YXJyYXkpOw0KPiA+ICsJcmV0dXJuIHJldDsNCj4gPiArfQ0KPiA+ICtFWFBPUlRfU1lNQk9MX0dQ
TCh0ZHhfcGFtdF9nZXQpOw0KPiA+ICsNCj4gPiArLyoNCj4gPiArICogRHJvcCBQQU1UIHJlZmNv
dW50IGZvciB0aGUgZ2l2ZW4gcGFnZSBhbmQgZnJlZSBQQU1UIG1lbW9yeSBpZiBpdCBpcyBubw0K
PiA+ICsgKiBsb25nZXIgbmVlZGVkLg0KPiA+ICsgKi8NCj4gPiArdm9pZCB0ZHhfcGFtdF9wdXQo
c3RydWN0IHBhZ2UgKnBhZ2UpDQo+ID4gK3sNCj4gPiArCXVuc2lnbmVkIGxvbmcgaHBhID0gQUxJ
R05fRE9XTihwYWdlX3RvX3BoeXMocGFnZSksIFBNRF9TSVpFKTsNCj4gPiArCXU2NCBwYW10X3Bh
X2FycmF5W01BWF9EUEFNVF9BUkdfU0laRV07DQo+ID4gKwlhdG9taWNfdCAqcGFtdF9yZWZjb3Vu
dDsNCj4gPiArCXU2NCB0ZHhfc3RhdHVzOw0KPiA+ICsNCj4gPiArCWlmICghdGR4X3N1cHBvcnRz
X2R5bmFtaWNfcGFtdCgmdGR4X3N5c2luZm8pKQ0KPiA+ICsJCXJldHVybjsNCj4gPiArDQo+ID4g
KwlocGEgPSBBTElHTl9ET1dOKGhwYSwgUE1EX1NJWkUpOw0KPiA+ICsNCj4gPiArCXBhbXRfcmVm
Y291bnQgPSB0ZHhfZmluZF9wYW10X3JlZmNvdW50KGhwYSk7DQo+ID4gKw0KPiA+ICsJc2NvcGVk
X2d1YXJkKHNwaW5sb2NrLCAmcGFtdF9sb2NrKSB7DQo+ID4gKwkJaWYgKCFhdG9taWNfcmVhZChw
YW10X3JlZmNvdW50KSkNCj4gDQo+IC4uLg0KPiANCj4gd2hlbiByZWZjb3VudCA+IDEsIGRlY3Jl
YXNlIGl0Lg0KPiB3aGVuIHJlZmNvdW50IGlzIDEsIGRlY3JlYXNlIGl0IGFuZCByZW1vdmUgdGhl
IFBBTVQgcGFnZSBwYWlyLg0KDQo=

