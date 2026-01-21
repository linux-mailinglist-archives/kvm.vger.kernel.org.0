Return-Path: <kvm+bounces-68671-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SHAyENkkcGlRVwAAu9opvQ
	(envelope-from <kvm+bounces-68671-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:59:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DA99D4EC5C
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:59:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 083D85EA287
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 00:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 342632DF131;
	Wed, 21 Jan 2026 00:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H4VqKrNy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2212DEA64;
	Wed, 21 Jan 2026 00:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768957128; cv=fail; b=FoeQqWW9OjSnmlzXc4HmGbZXX8Ga6Uoo00VuInv/moGPztZjmn+q71HsLofzOwT6CBbSGeL+rjVRQbO1Pp9KIdmWx9F7bBCGc1i/fquNAV5UwN4qOOGqb86JAwjxaHPXZk9HhljnbFmPBZbtb7/PPvjKeEwZ4vG5y1DrZkUl+Ho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768957128; c=relaxed/simple;
	bh=6Lp14HV8b05JLCLSdzpQ9motfq5j4JtIE8j5THcnTMI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tYzPhXE2kNyvlv6eyXthmdARidgb0v62Jvn4lu4puy7Iep5vMNwGAYVVd1M+gVLlBJQA4enWg1+wuJ5aEaUm+LEAiahFynDeEE0D8/yzLKSzfQd96I9Q/E6if94vCJ9mREcoGp8nnbOLqCgCK60eYxato9NjW++F/jBSAiz0RFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H4VqKrNy; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768957127; x=1800493127;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6Lp14HV8b05JLCLSdzpQ9motfq5j4JtIE8j5THcnTMI=;
  b=H4VqKrNy0feNHpZAwiljVS6ZamLZvycU0IJTGT4a0+VA7hyZsy63MIu9
   zTjpxLxYoP+ATmCkp1Y7igMYfSYpadksVymm4ZKuLNGhd3Vo7HptRbx6h
   L6qpIp2/AAyfZDbCmAeDTtA6SclscxvS0LfHI4f7892kCJDG++fjLtjMw
   t6Lss0nbjQ2M/FNB+ADqS8MoLjS54+z6fzO11Xtt2NdBcqfsa3VISC62G
   yHCFjAN040mTkUafwvfgF6vVqc43ESkrcj4i6cMASvEZa5xsWGwuDB4rb
   MNoj5m94gSElaNZJSTWo0PWgvLxzXTFPvsrg3C3ekhL1bVZ4+HQ774evB
   w==;
X-CSE-ConnectionGUID: B8yZgzwpTjCHA5Eoh0inNA==
X-CSE-MsgGUID: gnVYvDtdSquwztEUqsb4ag==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="81622983"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="81622983"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:58:47 -0800
X-CSE-ConnectionGUID: 8CPb+6NiQaGoGFMDLGfozQ==
X-CSE-MsgGUID: LCnxCIsZQtOTf8YTfBgTOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="210430102"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:58:46 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:58:44 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 16:58:44 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.32) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:58:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xIIfWAQk1Xd8vN6nCmb0nVE80f/oDB6r6wNcXdtvkq2te9XqnJoiO1hnz0a7OmG0y9IV15bc0CsqxpkFC4c66WF0wIgC9bl2X3oUM0lKfoR7FQUgpQjCOJUcUtPMMGxV5YtNBmjK7Aw+AHeVLMof7Jy8irUl6p6CHfiIGOW11HVQznNNdJSgChxRR0G2yOOE6Q3XjVYjlmqjKeuRGhLEpcTa+pP62cy9tA330U1ryTrpvjTgPGjnO/d0+aon7u1AhvTjixYgGysv0fqUSiLHxHmUJr6TYCQv3nqnlOGzudmJ2kyr5PziuYBF+AEu2nNVe/4LKV6LC/ang6G1KT1vPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Lp14HV8b05JLCLSdzpQ9motfq5j4JtIE8j5THcnTMI=;
 b=CeVbXQmshMFkOP/DNORRCbrMeVT6W9gTytUmQ668uBJr5jvEhI5U05aOipBEIusObnoLQ1VbOsHhIuK+Wx2LYp2VZISe3XdOhxbHpsk+nnRVtFmbJvbYQyelRJlLC10Y6kG2VBA2ZcxV+CNWZfpxEuAoDqx2YNO6+hIIDLRQI8OBYaMGhXspLMlS32WMN9ztmhZM/5J0XfJUypVzuVD+1shQu2sOTgss86u2npGtwgQ85vzmf1QgOhIwcWoisUFLFkuQIupEKbUTzyHNoXodPrQzCvYJnqvCT5BrEbIkagGciFZ17SA6QMcVS/FUBE6rm1I52+md3XRtEfP2ckRW1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN0PR11MB6134.namprd11.prod.outlook.com (2603:10b6:208:3ca::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 00:58:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9520.011; Wed, 21 Jan 2026
 00:58:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v4 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Topic: [PATCH v4 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Index: AQHcWoELLxf19qpVqUu0bWQO50RjlbVcK06AgAAB2QA=
Date: Wed, 21 Jan 2026 00:58:41 +0000
Message-ID: <6dca5e5e87971622d8c8dcbe7fad9c506b62af68.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-13-rick.p.edgecombe@intel.com>
	 <aXAjMxbeMO0pioNF@google.com>
In-Reply-To: <aXAjMxbeMO0pioNF@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN0PR11MB6134:EE_
x-ms-office365-filtering-correlation-id: 63fc12cb-778a-4bf5-8c64-08de5888384b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Qkphc2k3MnV6SURPbG1WbldSdTNqNXFSMUY2eE56c3p4MVpZSmVOWVBuV1lv?=
 =?utf-8?B?TUVZc3BPSXpGbTlvVXk2VE1yNlBYN2d2dmFQazU4OVNiSG9UMVVlcXl2cHlO?=
 =?utf-8?B?WFNVbFJxdE11U3UrcTF1bWsyeTJ4YXJYOW1aYnVaWFpSUG1pcVZKTXg3aC9P?=
 =?utf-8?B?YUpUbHZVcHZGNTA1cExEVXh4S1U4ZjZmclBZbERMMnFwbDVNdXFrbURWWC9x?=
 =?utf-8?B?Q0tZcUFMZkg4WUt1bldXa2w2UlVvbXR1MmFtZnV2bWxRY2ZkUVRzL0ZFa0hn?=
 =?utf-8?B?WExMdDQ5VVhEN28wSjM3R3M0T2RWQ0s0OHVOK3JXY1JtWFU4d0ZjMDF0eDYw?=
 =?utf-8?B?Q2d3U1hQcVlCc0hxZ0NuVFJJSW5SbG1tRVVSRDRDbTh0ZUtnLzJGK2xxaXMx?=
 =?utf-8?B?YzFwQkpBVDdaWVR2NVBpWktESWt2RUg5a2tCSVc4STlCcldXQ3lpczdSdC9m?=
 =?utf-8?B?cXQ0dE85Qm9XREk4Q0ZlSnNvRklyRURMamdIUXFOc0FLK3l2NEN2M2g3T1FT?=
 =?utf-8?B?a1hpQWtpMmpRYWthemNFZC9HNkhMUkNSMWprSE1wYkpueHNvd2FmQjVjaEtl?=
 =?utf-8?B?ejZFckJCUzhRczRYa2ZZTFhRTWRtajJGSllZeFRCeVZ6bTR6VFpiMmRYOWha?=
 =?utf-8?B?MHl0cTZYMUZRQkN2dExnSC9WajJjVU5wWnAzdkZmdkVoTTl6Mi8zWHJXbEky?=
 =?utf-8?B?RkV6ODZVVHlCa29pMFhZM2NUYzljUk4xUjB6VXdySXlEMGpQWERqbmdQZlFj?=
 =?utf-8?B?VDZub1N5VjFpMWRTajVRd2pHMDJMRUFENVo1TWt1WGVRdisrbDkrckZ5RllW?=
 =?utf-8?B?SDhkMlZpMzR2V2lndDZ5OHdtRGZMY1lUK3hqNmdDamcrK0h3WjhMRjN5TjB2?=
 =?utf-8?B?eVJRNmdDeVNIa0hvbVRSN25HVXB2UzB0M1FPY0tKbHV0MkQ3d0dYa0F0enNT?=
 =?utf-8?B?cFpMYmVLWStGb3ExWXdFM29ZSXNIeUZjVXozN1djSFIzVGl2MXV3YktzajBm?=
 =?utf-8?B?bFBsQmY1MmNBb1ZqVjczTFVlWTVYRW5mWVRBN3pMdFJ5SjRXd3B3c1MvR1FQ?=
 =?utf-8?B?SVU3MFBieW1hM2N3QUN6Y1JnbEJReDNKbTlRaFB1T01ua2JLLzVNTUU0QjR6?=
 =?utf-8?B?QVpqMjZ3K2ZwUGl6WllYdTYwMVZWNndlN29SV1R5ekh3dUNWd2dMUndSLzhO?=
 =?utf-8?B?NEg4bXhYWmlVLzdSdFZzbFQ0T3hhNlRtZFlUM2k2TnVISUpHWGF1ODhjdXlG?=
 =?utf-8?B?ODcyOTdHMjQ3WDdsVEY0T3RaNHYyV1JjTTFJTXpsdUUycDNMMGk0Yncrc2VK?=
 =?utf-8?B?TldCVTN5UmZsMG1sdGl6YTZpU1NwaGk2QmI4L0pXb2ZCK2xXODdrYnZJSFhm?=
 =?utf-8?B?VmNQaDJnQVB3eEZoT2Z6azJOQnNWZWhxTGx0Y1VoaEpiakpaZ1dOL1AraVBW?=
 =?utf-8?B?bzR2K2ZFRElHREN5QXZldmdFL3F3MDJ4L0JwQ0J0eFlPUWw1MCsvZCs1U2RU?=
 =?utf-8?B?NURxNVoxcU9RbFJ6SDFlNVdMaWRaOUJDSU1RV1JVUDVMdzM4bEpEUitBdWtL?=
 =?utf-8?B?eklWSERhSnBxaWxVcjM0NXVKZ0VMR0tDV0tFaTFCcTlpRVdFYStxS3dUQlBP?=
 =?utf-8?B?N2VqQUdCZjRqcXZVQTRpdkRiRko1NjhUR1VjNWJkclpIbXdac1ZoQlRldHd1?=
 =?utf-8?B?Nm85dW9yT2k4YzlFdEI4Y1I1bGFxanV5MWpJVEpSTE1MWkhLZWhvK2VwOXM2?=
 =?utf-8?B?TzFTN011NCt6TmM2SWhTdGt4UkZhQ1QrN2dDNnhMdzBxY3dmRG5RaTU2TWVu?=
 =?utf-8?B?RGp1Q3BxUURZcWt2b3FDQTFEc2NwZ0tSWDRiUjBPdTRoNHJyVzZJOWhnemZ0?=
 =?utf-8?B?NWo1c0s0S2tyeUh1ZDh6UTZUcm9rcUlJZUtyVTF6cExVN1F1SDEycHlWWmkv?=
 =?utf-8?B?d25RZkJEUTVpek50THh5VFJPamErUEFZMmVOUk5GNzZUUGZYQ2NkUGRhcDZG?=
 =?utf-8?B?OFhxWUhnamFxMUFCZGNxS1NXOFhTZkJYL0grbFU3QS9lVlNPMlhQbVp2RnFp?=
 =?utf-8?B?bjFJQXZXK0sxRUtpaFplSVMzeStwdTRnOU5SNm54V3JVRE1GSkJBYm4zMkhz?=
 =?utf-8?B?RHYxcThJT1M5RnVYdS9vLzdrK3YrQzRMSk54K083Vi9BQWtCeHpkRTV3UDY5?=
 =?utf-8?Q?Tx7efzi8mqWZCLiz6bfJnVI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0E4Wmp5M08vTjZPRHlFdEQvT2VLUDR3VjEzcWNSNjVpT0prbldSUHRWeW5q?=
 =?utf-8?B?TTZHbjdvV1ZkazMxUW5jQThWeGxXUEswaER6c3BiTHpBSjVlNFVzaHFLK1Jy?=
 =?utf-8?B?K0V4SmtPemh4ZWVMZDNjcE9QZU03ZXBkaWl4QlVrUUh4WVkwdmpDQjAxNFBO?=
 =?utf-8?B?ZmszUWh4c0xra0ZUc2NGU2s5OUx5R0tEQjBQZm81clpVRkxRVjR4RERtZk8r?=
 =?utf-8?B?WTQyU2d6QjFDSWpKOWNTUmpLZzRZZmRQNnFNTVNYbzJEWDRXeXBQOTFIa0tt?=
 =?utf-8?B?M3VHUnMzZXV6WDIwdXhiRkFOQTMzYzhjSE1yNmR3TW00aUI4YzcyZ1NlaGtW?=
 =?utf-8?B?M0pVcUtKZXNVY3laWXdNQVdIWmVGVUd3SHhXK1ZHM2tiMDY4M2c2OWZYbHlR?=
 =?utf-8?B?T3BBV2RVSXVqSDJSelZCUVdjR3pud0Y0L0xJRGFOWktuVHkxUHZ3SDNQSHRt?=
 =?utf-8?B?UGVuSDJ5M0EvUDZUM0ZhRkprZDB5aExXMm9BOFNBc1pENlYyQWhvTkpzQW42?=
 =?utf-8?B?cUxLREM1eUNwT29SbWY5M0NHN3gwZFhjYkNYQ29BZ0N0T3BQZkV5b3huT1Vn?=
 =?utf-8?B?WEYrQ0xJdWF3WEZZVlhtTVBkbzFlOXkyNFhwdTN0SVVock1wNGxqbTdPWncz?=
 =?utf-8?B?L0pmZTAvUFRwWWdDZGNaTCtMeDRYalJDWm5MVDNJaTcwRUpoVGNvZ2grUXpQ?=
 =?utf-8?B?eGk1MHdSdXB5aGlKbjhnOWZ4a2Vta1B3dFYyQ0FMOUxmQjc5RFhRSlpTUmcx?=
 =?utf-8?B?Q1k0NWJ4VkcySXU3c0cweE8vcVlEQklQTXRabngrQ2ZlWHpDOGtGRWkyN1FW?=
 =?utf-8?B?QWxEbC95VGkwYTJVaUp3czNrUTN3UE1UK3hYelkwLzlNall3VHhNc29RWGdl?=
 =?utf-8?B?R3RPbkxNeHdaaGgvOHBhYVVNWXMvcVRSbTRTSU9ZWnp1TkViNEZIdEVQbEtz?=
 =?utf-8?B?RllqKzlDb0g0bW5ERE4wUEg3M25oUUd4akRzaDhRSHJ6Q0RUMVdCWHhaa0Nq?=
 =?utf-8?B?ZlVzZyt2akpHVFlMN0VyMGlsS3dtR3FxOHVHUW5HYmR5cU1QakYzRlo5ZDQw?=
 =?utf-8?B?RkJCbEVrNW5JaWZQdm9ZOXJXN3BoZ1BmQ3loM3ZJc2xXUTJDTGRvdzl4cERX?=
 =?utf-8?B?VElGdXdXbWh3TDI3eWRBR3d0RURhL0ZBcDlYS2p6T0FzS2V1TVBTTXExL2xV?=
 =?utf-8?B?bXgzTS9nUmFyTHE5Zm9HaVZLR1JYM1JRVW5tOFRHY1dwclhLVHNtMmRGemYy?=
 =?utf-8?B?SlZDZkFXV0V6dWxQWGQyLytCaUlYNXZybXBWVEVmTVVOdGhiUmNtbFZ5cVk2?=
 =?utf-8?B?Z3IzQ1hLQnppZ3cyNWZEWnlUc0xTcS9mVVBUMkJiYzNLVXBBdXZYSXNDNFVW?=
 =?utf-8?B?cnAwYWxoK1lzdHpibHJZMjFaK0lZMENNakRzT1YxanZINmlSQXd0b1BVeHUy?=
 =?utf-8?B?STlHR0ZHWU1qMmpGVXJzU1NobEl1bnpSVGNDQU5xU2NlSU1pZXBGcTh1SXlS?=
 =?utf-8?B?R0dPaVhOdHRBWm5EaHFESVRCcjBkWHdHNmRPTm9nSi96MWU1UjVYZmxsaEFN?=
 =?utf-8?B?aWpFUGk1REc4MnhoSGtwYXR2T1NpMVFTUEZSWTlxQzBLVVRham1kSHFxRnNS?=
 =?utf-8?B?SXN3akhVVWhPUzlIZHB1V2xmL1RpU25oeS9NSnU0REtDbUFYVmhLTHpGZit2?=
 =?utf-8?B?SHM4QjV1ZFIxaUtRMHVvc3pCN1ozenovQ2t0QVdZOXZzclkzdnpsUHI5ckVF?=
 =?utf-8?B?Q0QyU1Z0SGpraVFvcUg1OTFGZk1aZ3QxQUJhWlJyT2FKT3cyVVlDT3A3Y2tq?=
 =?utf-8?B?T1FVUi9iR1daQkFXR2M5d0RkWDJLZDRNU2RYcS9FOTVoTDVtb1BCS25xSm43?=
 =?utf-8?B?VENPcm1memtMRTZIeC95eFUxeFZKQmVpRzd1WnVFbENwbVpJTDRSOUtXZ202?=
 =?utf-8?B?T25hUTlBOThrUlp2THI5OFpRMmxvZkJmRVZPSXRGY3FWYXNEdDRVVGtIZ2Nl?=
 =?utf-8?B?SXJJMEZGZ0dKNG9KQ2I2R2k1aE1kV2h0YVdpR2hkWm1GTTlvUDRSWDJNeEta?=
 =?utf-8?B?aDdQTDVEV3pZSWNQSktLZ1QvYzdHRHA1VVMzd0hFckFxQ1ZUVXB4K21sZjhB?=
 =?utf-8?B?Lytnd2t4blE2QklFMlFYZTI1QXZaVUo4aGRHTnJnT0lDbHJjNGpWN1JMWEk0?=
 =?utf-8?B?N2NRZGhNSEpTSUd2WjJTaUgydUd6UXFzWm85QzVjRFFpMFlpM1NORVBRdWV0?=
 =?utf-8?B?RHhJazNSUEViVVp1OFpIYUhqakRWSXIvZGc2RkdpMFFNT2RncEhPbDhVUzhr?=
 =?utf-8?B?WnVtT3pMNi92elV4VUhPUHNsNXpYVS9yNFl3UzNpTzNGZndDaVB1NGhIQmdx?=
 =?utf-8?Q?nk6HN5uPXaP4QvnE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CA475B1F815E44BB5467290D51FD7DE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63fc12cb-778a-4bf5-8c64-08de5888384b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2026 00:58:41.5305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P3M6w/hsXH5i588td+yoXBy9uZPpjgmYh+pdrIvVjhP4//umvDZcr9f2PmgDJPYQUzop+szt52M/5T31xq5TS+sDAY7JicTfb3hO6U8KvI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6134
X-OriginatorOrg: intel.com
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	TAGGED_FROM(0.00)[bounces-68671-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: DA99D4EC5C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

T24gVHVlLCAyMDI2LTAxLTIwIGF0IDE2OjUyIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBUaGUgY2FsbGVyIHBhc3NlZCBpbiBudW1iZXIgb2YgcGFnZXMgdG8gYmUgYWRkZWQg
YXMgQGNudCwgZG9uJ3QgaGFyZGNvZGUgd2hhdA0KPiBjb3VsZCBiZSBjb25mbGljdGluZyBpbmZv
cm1hdGlvbi7CoCBJZiB0aGUgY2FsbGVyIHdhbnRzIHRvIGFkZCA1MCBwYWdlcywgdGhlbiB0aGlz
DQo+IGNvZGUgZGFtbiB3ZWxsIG5lZWRzIHRvIHByZXBhcmUgZm9yIGFkZGluZyA1MCBwYWdlcywg
bm90IDUuDQoNCkRvaCwgeWVzIHRvdGFsbHkuDQo=

