Return-Path: <kvm+bounces-31665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC209C650F
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 00:22:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC854B3858F
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 20:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37051219C96;
	Tue, 12 Nov 2024 20:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d4GKN3ta"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BD5212D05;
	Tue, 12 Nov 2024 20:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731441801; cv=fail; b=D9vW8s5n7EebzUEA6HGgiA1urNEmo95l/63bKMlUq6U0VkTqeAUq87Bgb6834TmSv9Ypbdkv7QJbZGai7pqqcC1ck3dUWA/jx1OyfoxR+GF1doy/dwr6tkVjOMYBFaYHzbXqObVsG0Z6x4fE3kjxY9evwkpfeo8h5YVyMAo9ONQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731441801; c=relaxed/simple;
	bh=5+JyotTvAkVzDX7WD0rrKJpTC3mU/U052GorV4FWb0w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dlfoUd4SJQC+uHhqhVLfU8yK0r//6tWA4UCS5fXRP9Ny0BRQj1z3Auaygb+9wK/E3s4LbDKCAlknILevsT7bLi8XNZzZhHWIe2+W7NQcHkAn/d69on1Ekg9mCdbQWKW2vglMxPVofCjHWG1dySiuLk+ue0qBdC1Toj2PfqpnB9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d4GKN3ta; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731441800; x=1762977800;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5+JyotTvAkVzDX7WD0rrKJpTC3mU/U052GorV4FWb0w=;
  b=d4GKN3taYcgIjZ2A4ouGQIPQ39GS0pPirlLUdPEOx2bxqcLOtxWjlfJm
   ZIym4nYSeXdSOfepP+WrOoG9jKg5m0xo8SHXWpC4EYfFQyRt3oXNZJmTZ
   +15RrYJEDPL2m7SfQ+DrY8NscEngPR3RBs4EJ5OF59r4QUlHTAetkX7ox
   1qadhTp78Pkmy0ISbs3cGQ9sdKnZHSSQFyErxcWR5qirIBwoXvHEADLkt
   MyvfapKlb18YfuDFPVArQ2hnTHfbX7UiwJK8qIFqX16U4Cq11DRtgoeBz
   68P5Tjm/zTeKhiIx3G0tO8WN6Cy2rQz0sjK2xd6y5OjOUUBFq16U6qBrZ
   Q==;
X-CSE-ConnectionGUID: 7IirhmLrS6iDLk5CTVl7Uw==
X-CSE-MsgGUID: dR2m89JgQJK9yKFU8ucQyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31265560"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31265560"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 12:03:18 -0800
X-CSE-ConnectionGUID: Rflz2g7sSC2Poh08B1bIcg==
X-CSE-MsgGUID: zTtC9WRpTtWw2dq/YyDEoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="87204554"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 12:03:15 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 12:03:14 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 12:03:14 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 12:03:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QICxx8n7uf2/CM2VREqrMqDrFd4QwI0MER3f+L2KDY9YTgsBL7yuHjG5arljbtoQfFQJaeVHL+78uakjN4s+Lxg8veT07AOFWe19u0qq8WZ20j4ivBhJZTPpHIiBxkIb4u2AsaaTnSNyBs8MQc43W0xYvcfu9zges9NL6I/HPgX1N1gnpvE2ODrimGwHXsDuT+PSFOp6oLVO1gq7KXr1bhQoirYF+OMVeeqbCQ2avxz984nYyB1/lah+1Uuw/puLpMr/FTCMHNuqEOh6YeGm+vgCN/c4N7cZlN/5tB2RtsFjtdlFjuKwUOMCOmGYfoVPGm2dx7wjPVTah4xo7K8cQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+JyotTvAkVzDX7WD0rrKJpTC3mU/U052GorV4FWb0w=;
 b=shuuUSOhkWBf2KH6ClB+mjqr9PpsXaYoHONMERL3EUuaejatMJKS/rck9+5jr3D4mA8FLGh9hVJrKmv5cluqJBb1SnTbYp5UaCGMLwbJuuJUH1yIu52dfVUhKJojNwuU9P5TFRjMmwhsKkx3YBRtjvz54AAvJGadDAYWj+6CDspeOeDl65w23Nh1yHYHWsreWIe37zNrlmD5JAiPgDvJLtdM+9vVMx6Os+zavgQcpS1K53DGTdfk+9sELZRBo9E1Xv0ihnQblO5xBwVgIm49B/0eWpzpjjgQGBoK5M48Oj+XK12OKaHTcjo7YosK4ib1iWZE/TM4vEURqjIF/oUiPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH0PR11MB5283.namprd11.prod.outlook.com (2603:10b6:610:be::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.30; Tue, 12 Nov
 2024 20:03:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 20:03:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "john.allen@amd.com"
	<john.allen@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v10 00/27] Enable CET Virtualization
Thread-Topic: [PATCH v10 00/27] Enable CET Virtualization
Thread-Index: AQHaYwfwUq77Vfr47kSTqCeNyaqv3bGDeEgAgAbx4wCBIC/lgIAAeyGAgAAahQCAAN0fgIAIYiwAgAFGugA=
Date: Tue, 12 Nov 2024 20:03:11 +0000
Message-ID: <e1ab320cbf08258176b246906feba1f2ba4e1cfc.camel@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
	 <ZjLP8jLWGOWnNnau@google.com>
	 <0d8141b7-804c-40e4-b9f8-ac0ebc0a84cb@intel.com>
	 <838cbb8b21fddf14665376360df4b858ec0e6eaf.camel@intel.com>
	 <8e9f8613-7d3a-4628-9b77-b6ad226b0872@intel.com>
	 <00a94b5e31fba738b0ad7f35859d8e7b8dceada7.camel@intel.com>
	 <ZyuaE9ye3J56foBf@google.com> <ZzKiapQZgn0RscrC@intel.com>
In-Reply-To: <ZzKiapQZgn0RscrC@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH0PR11MB5283:EE_
x-ms-office365-filtering-correlation-id: f4fd0827-c682-4d64-e0f4-08dd035508da
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SHFQUFZZeFdUa2N3QVQ4OXBQdExnSXhwQmprTnNiOU5ER1FQeDk1M3B5MU91?=
 =?utf-8?B?cmRNYW9ZNTM2UkhwQm94NGpuQnhCbkJ0eGtkY1JmKzU4V0I2dU9ubFVkTk0v?=
 =?utf-8?B?N1ZTVnFKb0JnUU4yUmxDbFJjRldNYUpMdmRkM0FjZXRBamwxZ0pyK0lOazVX?=
 =?utf-8?B?cnpsalJKUW5lWkdwQU9CVmZKUmlEK01wcy9oYlNhOUhTdG5ST3Y3NGI1UmtO?=
 =?utf-8?B?ZXVkUTVkbXNXRmNhNlprM0pKZkZsMlE3MU51WWZzb0RzRXhqT3NMWGxHRzUr?=
 =?utf-8?B?M3ZmS1dsRFIwRVRFa1pjZk9JYTJtUWdNelRsNmxkZ2ZGSUFPUWNObmk4clNC?=
 =?utf-8?B?K2lLQVN4U1l2WEt4b3ZnZW44V1lKZ3I5U3dWNm5HR3AxdHg4UmEzMEdadkV2?=
 =?utf-8?B?MTJJUjdWMnU4V3A0NmpqVmZlekJ2ekVjOVdtMVYzLzJJb2hsY0JPbXl3OXc5?=
 =?utf-8?B?OFNKc2NOeTZKR1I4enJJTjZnbDk3OGx3TnBuYU9zaHVrYURxRlBNbk5VbVNh?=
 =?utf-8?B?cE5NaEYwblZ1bXZtbW54aWhybTdzZ1RmR3dMNXlNeVpRcHJ2V3M0WEpGOEM0?=
 =?utf-8?B?ZEJTN3FvYTVWaHphVEpvbnFlMklubWNnbWhUa0dOSEY5Tkw4ekdjbXc1L2VJ?=
 =?utf-8?B?S2hxcEM0ZVFiMTRScnE2Q0pPV1ZkcEplMEpTSSttTkQ1RTEweUdqNldLckR5?=
 =?utf-8?B?eWRxSnl6YXdzWldRd3lTaWZLdGtNWVR2WnA1YzczOWowbzk1N1ZwSlh5NGNU?=
 =?utf-8?B?YnUrcmpuSkdPNXNJRk5TZzRIUXAvNSt3eVZ2aHF1dWp0WUtVMnRoa2h3bW42?=
 =?utf-8?B?QnBSUnlFMDZzVzVrSUNycTd6ZkxkcFVKa2VUalU3bVlQVFdlNjd4NTZmdXRo?=
 =?utf-8?B?ZHY3R3hJS21XalFzRWZvemEyZ0hmSitoOHRaY0Q1S1ExcFVpZk0rZk51Q1pR?=
 =?utf-8?B?MGZGWUxVbytzdGt4eXZQZDkxYXgvTDJlR205Y2xYZzNNWElrT1VYVkFFTzMw?=
 =?utf-8?B?M3VsT2NSelRSNWNMRkxKZmhicWhST3BXYzFoL2lWSC8vS0xaOUV2N1FETjls?=
 =?utf-8?B?NlZZMWRoQVJvek9sNHJmL0tCWmV5TjVsTSsxR0pWSkV5MHIrTHFuSEp6bHRr?=
 =?utf-8?B?ajRIZXFCVUZNK3MzZ0FtR3BCM0FHR3hFR3ExRDljTy9MWkozVEVqaFlKR2N1?=
 =?utf-8?B?cXA1KzR0VjJnUGhLc0N4K3Jzbjdvb3JaenZWM29sU1RIdkQ5cHkrU24xOFM3?=
 =?utf-8?B?ODlzckN6MzdqYXZnR3Jla2ZtK09RczZkUWkzNjhZSzExaGs5TlFWcEwwRlpM?=
 =?utf-8?B?OTBiZUZ6bzhvVTY3RUZrYmM1SkZjdUM1bkxCeHJJbUxCZG9TVlcwM0h3V0Yr?=
 =?utf-8?B?U1psMHBaZWZPNmVKOThVTmVSd3dTczQ3YXBQdEZLT3VXdC9SenFsR2N5R0Zk?=
 =?utf-8?B?LzJCT09sb1RIZlgxRWthN2I3bmluakdTZ0RRN0MzZ2tVaHhWc09TbHErMW15?=
 =?utf-8?B?TEJPbzJhazNFalBOVWk3VnlFRHZQNFc2dWRtbmpPY0pKOVZaRHRHbjd2U09W?=
 =?utf-8?B?T2ovRWErMFIxOEhGM210d2tPR1ZWMCsrbFl2OEVQTWdqcEkzMy9mMmMrTk5j?=
 =?utf-8?B?eTJDQVA1eW11eDJCNjIrWm82NHVCWTM4Z2NaZTh4N3dwSkk2YUZiT1NFZGQ0?=
 =?utf-8?B?cDJpZVd6bFRmelNLdnRCc1p0cXRheUNmRzR5WnNwQTFldllDL0tJZVU2K1lL?=
 =?utf-8?B?b0lTSzVGMWlKK1Iwa1ZuaUtUdjFuRExXN0l2V2pJVUxwZ21UUzlVWlg5UmZa?=
 =?utf-8?B?b1VzVFE3Tk5KbzVhQUJtZklIT01pdmRRRDRsR1doWk5EVnhrczkxQ1VYeW02?=
 =?utf-8?Q?88+PDAlaLgWvP?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWVIWEFzMDd2N0dGTFQwQlNlamN1bkNLTWQ2VTFKSUVySTI3am9IOGR0ejFl?=
 =?utf-8?B?Z0huK2h0T3hydzNXYWt3ZHRjQi9SWk9TVk4rT3JMTS9PWlg4ekQwQk9Nbm1Q?=
 =?utf-8?B?Z3BDajBtM3dNTnFjUzFvRHRERXpuRVZNTWJHM2hoVkxEaHFTN3Zqc0YyRXlv?=
 =?utf-8?B?ZmRSSWFrSWtjUWtQRjVoOUpuem1iRVhQdUhwRTVuc3luVk0zb1VYenhvWEtU?=
 =?utf-8?B?TmhlRVFvYUM1Z2Flc1dZSXNualljZW83ZmR2UktPaGZBVGh0RGdic2wwNUxH?=
 =?utf-8?B?MmFmWHV5R3hINC9jVGpqa1lmU2JyVHJ5UlNXYm10S0RzU3JjcDA3V0RZUllL?=
 =?utf-8?B?N25wVy81Y2hEb1lqRVNmTi9RVnhRVnZIcERybmRDcnFpSUc3SUp0WVkvdkRX?=
 =?utf-8?B?TTI5TjVCZFRJVW9SZjVBNStucjhSaHVQRnZpUkcwKzcyU0U5Sm5mN2xEakxw?=
 =?utf-8?B?R3hQOExxc0lTNXNQMG9lR1F6VDRRek9xcVlNL2dCUmMzTHNJdEV1Wm04dnJ4?=
 =?utf-8?B?L0pvUHkrcEJVNWI0Q09UclRuQlZGOWFHdkZwR1VmMXR1TGd4NlZ5K0NOd1lH?=
 =?utf-8?B?dis5dE1EVlFEN2dTMkFWc1FjZ2xBMXRjTXZmTTd0Wno2T21YalFQM2JsV1gr?=
 =?utf-8?B?SmJQRXlzWnp1bnZWZzVUcEI4QURTSGVFQXg1VGxNeURBbzJhZXFtVlY1bG0x?=
 =?utf-8?B?R21DR01mNjl1MjB2NXp5RUF3ZmlLMnJFdzhIVkd1RW1wTEVCWlhxVm5FYVpv?=
 =?utf-8?B?SWhRajh6a2VtdWpCc1JScEx6OVFjenF0bXZCbkxFS2hHUER4cVdFTmFTSmky?=
 =?utf-8?B?bGdlUnVHaHlrbkd0T3cvNEgyMlJ6OFlVeWFnbjJGMFV0WWJjdmVRK05lSDgy?=
 =?utf-8?B?Z3JGMkhaWXhhRU56dVlKbFRxUnZTWHBmN1NFYThTbmM0eXJBVHNGMWIvNldj?=
 =?utf-8?B?dmZGalJNNFY3VDdFVWZLV1FrZW51NnZnVXZ1TDdjZnFLYWgxTmxCS1V2bVNW?=
 =?utf-8?B?MlhJaXZ6aUEyRjl1clBwWTNjZFNiWEF4Y1hzSThqaDZVbnBDakhqamdMQmth?=
 =?utf-8?B?T3d1eDkyNEVxQ09XWmdkU0l4MEk2U2tHZzZiS3ZRU1N2dlN0c3VBdXdsS3da?=
 =?utf-8?B?Vmx3eVBVQlFOWmtidkNDU1MyY2dCWHJKWUpUeTNNcVpSWmJiOVIyOUhaSkR2?=
 =?utf-8?B?ckRZOUZPeHU3NTRLbmd6aGZuUjRkeGhBdW1GZXROYzNXdWthUTJqcXJ6NFJL?=
 =?utf-8?B?TEg5UG50ZHFnaTdhWm9nNTZ0ckxvWTlaV2FlWVQraUI5YVZQeW9pU2FPcXlR?=
 =?utf-8?B?dnhNbm5BNFVpV2U3VFFmT1BJZUk3OXYwZUIrUGJNcVJjSzV0TG5vT0NtUnBv?=
 =?utf-8?B?ejdwYTZQdWtSemtzRFZNN1Q0cHhZODU0bkZWeTR4Z2FJd1pHV2FJZXFHRW9G?=
 =?utf-8?B?Zjl0MytjV2NId2ZJZFIxTUp6K29reUhYSDFRbG92SlQzYytMWnNKRGRiMkZE?=
 =?utf-8?B?N2FEZjNJb3ZYTFFMamVoM0wvMFRscTRWcUJpZkFsZVpLcnZLcjd3SE1TRmx5?=
 =?utf-8?B?TThmV0ZGNVl5ekY4NWptM1VTcFBlS0EyY0w5RUcvaUhlOG4xcDUrdHNVc2NJ?=
 =?utf-8?B?RjdtZjF2YXN3Wit3bzdnak8xRGpvbGg2R0YvLzlKUlpTbHd0NE5LNzhWN2VU?=
 =?utf-8?B?NUZMN3BXU0MvbWl2OFY4Q0ZzYWtqMFd3Y0F0OUYrOGVncXRYdnFzMElvSnV1?=
 =?utf-8?B?dk43emVYd2JtSGdaVFgyWDdzZHljTzlNYXNyVVdyMkFCQVc5M2N0ZEZwZFJr?=
 =?utf-8?B?SWJnUEk0eTZkMzhlVEdkWEZ5WEdHVE93ZFBNbHNpTXByNnYyRGdCdHUxMkdO?=
 =?utf-8?B?aGdjUXBTMG9oSEFGVFVmS1JHMXVKS05vZDJoMHRrckhSbi9lcVdZcHZCY2ts?=
 =?utf-8?B?ZXNMTDFIMzArOSt4OVdxdEdjcHRhRG9VQURWbHVwc3pKdDJLZlBtbmR0Z01E?=
 =?utf-8?B?R1c2R1diRExvYS92UDhEK0pHcHdsNGZ2eFE5SVB1UmRYcDUxZVVBRS9mWVlC?=
 =?utf-8?B?WDZlc1pzU0l2WXdvNVFNMkFETThhVUxra1pjODN6QnJva25VaXAwR0ZzSVVH?=
 =?utf-8?B?dFFWQmYvTUVjWFJ3WEVIYWs5R01jY2tVUmtVOUpHWlBzaFF5R2VwMHRtRytU?=
 =?utf-8?B?N3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73D8D92E2AEBB04B9688007279F63786@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4fd0827-c682-4d64-e0f4-08dd035508da
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2024 20:03:11.1796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5dpsOlpfXYBOhbzlY3lw7l+23HaurTRtT49amuGvK2BPfz+Nm1iJPJm7ZLk0kh3oqmZPiww2d/FUIArR2AYL3ZpxU9aBO2vLePUAnnjiqW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5283
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTExLTEyIGF0IDA4OjMzICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPiAN
Cj4gPiBPciBtZSwgaWYgSW50ZWwgY2FuJ3QgY29uanVyZSB1cCB0aGUgcmVzb3VyY2UuwqAgSSBo
YXZlIHNwZW50IHdheSwgd2F5IHRvbw0KPiA+IG11Y2gNCj4gPiB0aW1lIGFuZCBlZmZvcnQgb24g
Q0VUIHZpcnR1YWxpemF0aW9uIHRvIGxldCBpdCBkaWUgb24gdGhlIHZpbmUgOi0pDQo+IA0KPiBK
dXN0IEZZSSwgSSB3aWxsIHRha2UgaXQgb3ZlcjsgSSBwbGFuIHRvIHN1Ym1pdCB2MTEgYWZ0ZXIg
eDg2IGZwdSBjaGFuZ2VzIFsqXQ0KPiBhcmUgc2V0dGxlZC4NCj4gDQo+IFsqXToNCj4gaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzY3YzVhMzU4LTBlNDAtNGIyZi1iNjc5LTMzZGQwZGZlNzNm
YkBpbnRlbC5jb20vDQoNClRoaXMgc2VyaWVzIGhhcyBzb21lIENFVCBpbnRlcnNlY3Rpb246DQpo
dHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vMjAyNDEwMDEwNTAxMTAuMzY0Mzc2NC0xMy14aW5A
enl0b3IuY29tLw0KDQpIYXZlIHlvdSBjaGVja2VkIGlmIHRoZXJlIG5lZWRzIHRvIGJlIGFueSBj
aGFuZ2VzIHRvIGVpdGhlcj8NCg==

