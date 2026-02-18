Return-Path: <kvm+bounces-71281-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ODOaIp49lmkycwIAu9opvQ
	(envelope-from <kvm+bounces-71281-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:30:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0486C15AA59
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:30:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 92FD6301E7DA
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3A6E33711D;
	Wed, 18 Feb 2026 22:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ey9NwnxW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADF32E2EF2;
	Wed, 18 Feb 2026 22:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771453845; cv=fail; b=KU7/+mjmuJrBDhRukX68zmGYc4yI7pjPh3fio1HFl6D9IN3KiJAY28X4MZqky3ae2+o6xsqzbf661nAud0szhzsoncgytz2DtBaz7CQS4iOS4zON03Eq1NsCWIA+f7wGwJNSyeH9Uqf7408XeUP+7/0vtBv3fJHGLzzmjMXqM9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771453845; c=relaxed/simple;
	bh=Mg796X8EwS1qqHtsnS+yWaGkBPeSEeM5Pcnu2X679Wo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j5YcEpBFeenlHD35EoDaQc0pX/XvMiQ1f2KWWDVJzieXx40paGRWDFEZtc/i1p222FNAn4A6RwA/eC3u7BcKcFIGF2IkoBa93iVJpUs03QEg196jLumxs6QMqSNncuYlFtedee02HAzhNXhi2SKysNRJ8vJUFijYhFOTrcBOXcg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ey9NwnxW; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771453842; x=1802989842;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Mg796X8EwS1qqHtsnS+yWaGkBPeSEeM5Pcnu2X679Wo=;
  b=ey9NwnxWcgh/ggtVb9XCpA0AOAaR6aq/bMKRQ0qSCcSvYbFYVbq0MRJo
   oQtF/qYUD6d/fxDQJR9Me/65QiEfBMvpaUdK8shkLuoOvXoSe6bkJsGCi
   kHgrAAOjs5BP8W6JuYeQvfKMBebEOWqderaQU52L8JnMnOZbyQ9Um+oaA
   P2BUqszETjbD+gzIwfRN0h/N9oNMXiJkiv8dCCvZNTE0dcXQHDqO1Nqlx
   W7CXY2+pIXHht9MBkZEOJ3pVcMFfSYKCV1vLKXM0f7FN0z2Gnbz4DuBu1
   0TYXKsuqvUHNU+m+tOq/spIwBPKokAUCy9pME1dN97H540xypNXRx2xns
   w==;
X-CSE-ConnectionGUID: 77mslxF3SKCqLvTC8PXhXA==
X-CSE-MsgGUID: lW+wWTn6SOyc8Gqy/rgd7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="83257014"
X-IronPort-AV: E=Sophos;i="6.21,299,1763452800"; 
   d="scan'208";a="83257014"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 14:30:41 -0800
X-CSE-ConnectionGUID: jDy3TN1BRnqtKzUTAiOc3g==
X-CSE-MsgGUID: 4cBi2yJXQ4OObbQgN0ZXvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,299,1763452800"; 
   d="scan'208";a="218858375"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 14:30:41 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 18 Feb 2026 14:30:41 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 18 Feb 2026 14:30:41 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.54) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 18 Feb 2026 14:30:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GDBMomVzVAifomes4l6Ie25wwdLg7XFtTOKpRZuLaW0jWx0qL9nEksq1GwXWzIvvWxsh5Fhub3dlIUrwp0SLKd/Hn4SYu8jZL9ehYtN5SY8/kTL0obePFgGwJcBIRzdwqhvIcUI6rdVu/zfJlCiReHhxp6H4PHimxIyXK/KlxAjsyUJd5biBJal6VE6eRp/58D2+VH7ZOsYKeG4MhbAAY7JgbvMD3ldjuFagWB9Qh7vEmnA27Wm26JkLkLvmDHW66uqJin73WTq2Vr4eMEjI2cF+nHgNwmLJcBKUKFlH3oCXj67d7ou1AiVKEgAT4J3yvA5Hx1RRKBtX98x4LfCTvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mg796X8EwS1qqHtsnS+yWaGkBPeSEeM5Pcnu2X679Wo=;
 b=g4i80336XwFRDQJ2f+y8WcCsbQR9bgcx74ycUaDsx27ou3CjTZVfi54Jl3Rn6XnFey4h3tztIJcOAUjNTRH6hUkGe28Oz9UDGwujv7WCi2X2UJ3wKamr62DzkD523ULgNMcDtBXYv0nPPx3qHyrZYZo2D3S0uOD0uD1h+mDRfCjGQzjB6LTulIpcVyro8JCoex5ziicfId5+I8sKlSC2dXuOZO+EXssxlcY4q8QqTQd8bTEjHxTnC2HPVBUWk9rUXWCmDCpPvvDbfCJqI5y4LmSW1Ryuy2UtjZ6MqCJjVrbsysQZann8Mw4fIf0YSQfU3N/TwN/ZnTSOMsMj6t4EMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB7055.namprd11.prod.outlook.com (2603:10b6:303:22b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Wed, 18 Feb
 2026 22:30:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 22:30:38 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't zero-allocate page table used for
 splitting a hugepage
Thread-Topic: [PATCH] KVM: x86/mmu: Don't zero-allocate page table used for
 splitting a hugepage
Thread-Index: AQHcoRq/R9vliD+X8k+t9YdkeYwNtLWJCjMA
Date: Wed, 18 Feb 2026 22:30:38 +0000
Message-ID: <633b59f746aff4b0f40c00c5f8859851ecb4a0c3.camel@intel.com>
References: <20260218210820.2828896-1-seanjc@google.com>
In-Reply-To: <20260218210820.2828896-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB7055:EE_
x-ms-office365-filtering-correlation-id: 10a7933a-28a8-4529-c825-08de6f3d57b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SWIrWGcySU9kS2JNMTQxUkpwZkd0eGZaejVKZTFya2gxdHh3T3FXSDBKb2c4?=
 =?utf-8?B?ck1lQVpHYTB1YkFHSUM0OUJTdFEvekN6VTczQk02Q3pyREZDNmZQVThaci9D?=
 =?utf-8?B?MjBEc0tseSsrTmxOTmdxNjFzR1B6RjhaL1EyTWg0dzZGZFlocGRUUERqZEkv?=
 =?utf-8?B?QTBCUUdOZkg1VTBlMzNBSDV5bEFJc0pqaExTaDMrRWhYdEhmOUVScWVFVlRk?=
 =?utf-8?B?d1VTSTBOMUJOdXU1dElLd25zMWlSSjR2V2FoRTNKUXNSNFBxQ1UzMmpqVExu?=
 =?utf-8?B?bTQ2NC9valRSTW54OEpjMENHNVQvK2s3amMxM2ttVVNsTTdtVVkxdzlRWkk4?=
 =?utf-8?B?ZDhaTnRVckxNa0ZVRGxQYVhyUEZYZjE5Sm8xRlZYblJ6SWhjT0ZITU5SOURi?=
 =?utf-8?B?bVcvMGxkSG5hQnBuaUdrWE1kaGtNeGtxV1V5OWR5T0FuT1U4bVNIcDRIa3oz?=
 =?utf-8?B?NVFHMGkyeEdhMzBHNVNaOVdTRnUrVXNPc1c0NHQ4RS9hUkp2UklNb3BwcnVx?=
 =?utf-8?B?TTV6MlJEVHlnaEhsa09hN2NuZGNVTTV0Qy9QSS9nTXlJN1NBcEN3Si9XL2wx?=
 =?utf-8?B?NUVWM0kxS0hyT0Rwb1NDTXlEVzhIYjNnRnZnNGJDdjUwZ2NMQWo4aW91bi81?=
 =?utf-8?B?b04xUktUQWpPZFdTazBYWk1CdlEzMUpkVURySVJmTloyVlp6V3YyWUJvMUlP?=
 =?utf-8?B?bjd2MnZUSWFxSm8zcnM0WGcvZ0hFRmlMc2ZYNU45MjJaVFovRm9BckR4OXJs?=
 =?utf-8?B?ek02Ykt2UUdRMnVtVGtQcXVDSXpsa1B0bW1OeE1PU0VIbDZCVWdreUNaVi8v?=
 =?utf-8?B?cWxZVWdWK29DazI3c3FkMXZYeVNzWDExVkxxcUNhcmdYb3UrSnJZbWR1WVZT?=
 =?utf-8?B?aEg0M0tUUmkwVXJCM0NVempscmxVZlptNEVnTUhJTWk5M0pjcXd0OWF6RHh0?=
 =?utf-8?B?Lzkxc25OenZSN3NLWGF5SURFZ0FtU0Y2eVhoaVJuSFRWS1RkR25NbTNxYk9w?=
 =?utf-8?B?ekZTb0Iyek1YcUk4WHZQWFE2S211ekFvVnFsbzU0ZUJrR2VMTUlNeTNpOURV?=
 =?utf-8?B?NitOakhkSkxTNzV6NFhWV05SaGpzS1k3VlpoT2dzT0l3UlZOcUZzTkJQTnM5?=
 =?utf-8?B?eFdjOHFlWHpjeVNPSngrVkx1VUZvNVp6b2ptbndqTVY1QTZ6dU9KSDl4N09J?=
 =?utf-8?B?SVpjbEhRSXNoamE4N2NrQ3llc0NnUFFIQUpFOGUvUHl5UmpXNzV4Y1pwczNW?=
 =?utf-8?B?NS9aS2xGZEROVmhyQ0M2SHNvYWpqNHdGREJRUDI0U2VXZmNMc1c5dlh3d1hU?=
 =?utf-8?B?UXlZTEtUSytxZS82Tk56ekI4YzEyTHFmSkNPL0h4TjA3ODRGdUo2ZWRCQS9q?=
 =?utf-8?B?WmRnWGJKSjNXMEI3NjBraXl3NXpROURoYUVjUFZ1RzlVSEJ6YW1kaWkyejBY?=
 =?utf-8?B?dzV5UzEyQTdUS3kveVRHYW5pb1pQb0V5UzRuRzF0UkM3akUwQzFZVnhuTUph?=
 =?utf-8?B?QVhMeGJNcXR0Y09qU012Z0J6ampteHBEUWFZQUg2Z0xXQlN0QW1BNUNIU3My?=
 =?utf-8?B?MmE1dE1TSnM0MGs3dldaeStCRmdPWmlkTVk4bHlNZjEraHF4d2FvQ1hyYlMv?=
 =?utf-8?B?eDZGL0VleEpuNTZrVGhFU1J0TzZwM2pQdThlSm9odjZLL3p5elJockFBb3Mz?=
 =?utf-8?B?WWhUOXkzTHJERC9od2ZZUHFzczlRV0djNkRScVk5ZjE3S2dxTFJ5SSt0cllK?=
 =?utf-8?B?WDlQZXlxQldxNCtqUE5rSU51MDNGaXpycFo5SGdkY0ltNHJ3ZWVSWmk0Lzk1?=
 =?utf-8?B?Nlpqb2xtWUhhR0lKWDBOV1JzWk5WZmxpTk93LzRET0RrdzhjVmE5ci9OUE9U?=
 =?utf-8?B?aXhSTlFEbDJJV0d5V2tjQkl2aHBxb1l1R0kwaFl6R0hxdzlKS3FXT1BNU3Mr?=
 =?utf-8?B?WStmeTVENWdMOHN2cTZSR05Jak5ZbmhFZ01pOVM1Y1RwcVZ0Q2xueURGdEli?=
 =?utf-8?B?R1Y3VVdwNGp0WGs5MVlybFBqLzhLb1RzenpsMnJBL3BlZlRMVVF1UmdSV1NU?=
 =?utf-8?B?QVhEdWJ1aXY4RHJrc2V6MzlDcVBvMkxXN2RONk9jNk5pamdtUEVEK0p5cit3?=
 =?utf-8?B?bTFCKzhVeWlOeXdBTk5QZE02UU9NSUpab1crMFJ3akYwMkRNNFR3azQydzdS?=
 =?utf-8?Q?H/CRIH3AY4KZQaW38BfPZGE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXpPK0RoeFY1eEpMajNDK2x5SE1VR0xDUWZxc2V3WGV3SW9HMXhwQUlocFhJ?=
 =?utf-8?B?dzhDTStGcS9vMktNV3ZuUmNQdXpQcUd4YWFCVXFSMnZOUkZCcmxIaEw2Y0lx?=
 =?utf-8?B?Ynd3WGlqdklkNi9YcG50MWdNVGFERFFVMHRtY0taZC9ZQktRbU5IQlFsbVZZ?=
 =?utf-8?B?TGZnSDdKZTN5TDZVTXFyV1NNWVBtSktheGlrdEZrNFg1V3Zta3hkM0FlUWRN?=
 =?utf-8?B?eEZIRExvR0wwUE1lWWcxeW1QN0xodjFPUW1PWXNiSmYzbkFRMHl2UUNCbGNW?=
 =?utf-8?B?M2QwaVhHZ2FrRWkxVUorNGY4TjVkaXlQT29OaHIzY25DQXhTRFdlYmFZYWpn?=
 =?utf-8?B?ZFJpREpSdjBVTlQvYWNDME9JWlZlaFg1YWFpbGo4OUp5WE9vK2hPVnhOeUNZ?=
 =?utf-8?B?SWdzdGFValJBY3VYUUFHN3BrcnFzZXYyYmpqRTcwZHdQMnRFSUZ6MWloVU82?=
 =?utf-8?B?eXIzZHN2U3hUZG9MWEMzV3o0R0k5b1pHbGpoTXd4R2dHNjBKbG9sbUNDRTY0?=
 =?utf-8?B?MFk3b29LeGxlZkdDTUpaeFFnbGJuWGtqNHg2ckVlWVR3NXlRaXV3d3N2dTJR?=
 =?utf-8?B?SGN2Q0ZXc093akJPNFBVanhhTnZEMmhraGVORFNJSmcyWlgyUnN0UklyYktO?=
 =?utf-8?B?anhHL1dFL2ZSWnRzVmcrM1F2MzY4a1FvZTU4YWp0cGhDMGsvc0VMRlZSZXFx?=
 =?utf-8?B?QlEyRUhQZm9rWlp6aGZHeGt3M2NZWnptQWxvNnRzT3hwU2RHR3BMZVJ5Q2xE?=
 =?utf-8?B?eDh5dzBqYnhUaElheDJZbnhMM1ZYaU9KdTJnZERaUnN2bklyZ3J1OXBhQWxm?=
 =?utf-8?B?NWwxdEliOVZraU50Y2tCQXVyc3V1bUVKUnh5QzZvamUySFlwK2t3a3E2M1hn?=
 =?utf-8?B?M2duL3FZdjJnN3Vzd0YzdUNWN2hOM2tnTmtuT2ljMEFlT3pyaWNTbVQ4bWYx?=
 =?utf-8?B?MisvdFBDQlNXL3ZoNVZ3eFJpTG5mMW1qYXoySWNqM1B2MExVdEZxMXhrS2hj?=
 =?utf-8?B?U3lWTGdYN1ZCZU9GMjZ2cHNHSkIyNG12SHlnUktzZzl1dWpBM1ArK2xUK0xa?=
 =?utf-8?B?MHlub0lOUWZ4RHVyaDFNdmorbG16aTJzQ0FnQjBEa09uVVpWTUNkV0ZLLzhw?=
 =?utf-8?B?NGNXYTIrUDBudU91TmpYa0dWd2xEdEx4M0tCSHE3dHdyRGFKOWdiUXhqWThT?=
 =?utf-8?B?VlJmQm5UZ2lOTTlPTlB4eFVxRGdaeXhkdWtPYjlqMzU1K3FaVWR1dW0xYmY0?=
 =?utf-8?B?UVYrZ1krOHpXNmNvNnY0R05oWDBsWjV5NHRQTDU3b1ZFM3JUMW56SjgwejI4?=
 =?utf-8?B?anBWVnVoajd4V1Z2NFBKVjFLYkk4Nktqc2M4SEFHTUhQMTFsajZMWXQ0RTZ6?=
 =?utf-8?B?MVplbWhTWjlPdzNTNHJxSS83anJDbzJPcUhsRVhIdjRYbTgvdDBtMFo0OHh1?=
 =?utf-8?B?a25YUG9raTJKT3FYcGY3UzFPdklUV1NFdjJqc2hCN2FOSCs0SUExUDhBS2t2?=
 =?utf-8?B?RVQ1L0h1RERWWi9wNWpGUHptc3k1cXdqZ0NyUmZ1R2JUVk5VMWtyVlZDN2Np?=
 =?utf-8?B?ZmpVZXhRZXBQTDhEbmVXMWtZSnp1dUpNUDNjUTZBdXVVaGJMa0ZITGhGdVc3?=
 =?utf-8?B?ZEg2U2tHQysrRWNqbGt1U0l2ODlrdHJrU3BFbkQ5anJZd2t1VkpBSkMyNi8z?=
 =?utf-8?B?R0E4Y3A0VjYvNzMvR0tTUEpHODFIeTh4K1NqZ2k0blBEMlFDVXlYVWxnOEJE?=
 =?utf-8?B?a0hIcVJsOFJWYUtTYVRaZ0xmRjZSNkRxREIyWjBvdTVKTk0yblVNa05PQW9X?=
 =?utf-8?B?NytFWHZ2blIzTTloUUxtVkZwOVN5N29PbjBidWRoSXpoRTBLV3hGOVd3R01j?=
 =?utf-8?B?ZW1qdjU5VU1UclJhLy8vQ0djd291VjdRZTV6aWVnWFNQbDZ1S2dPZDVuNDFI?=
 =?utf-8?B?bUgyRGl3dkYydnBqOUZRMG5hL3ZDQmRmQXAxbkIxdWU4UXBWK1BkRnlNVnI1?=
 =?utf-8?B?dnlDR0hZT2h0VkMwQ2N3R3NRMUJQeGtKeE44Y21idC9QakZRRWNvaTlibVdC?=
 =?utf-8?B?R1o0bWxDOFpMMGtEcUlJZkEwdFNPOVE3bDYvZEJIQmxWTGliRVRZWFY5Ym4y?=
 =?utf-8?B?eHBNL2pocWVtTHpaUk14MjdQYjVBcHVvVjBVRmtKaFJ4bHlZandKYWVyVzZz?=
 =?utf-8?B?RzNPa0Q3Vk9MbE12bXNHbGJFUWRUUElsV0U3QjlpOG5aYWJEZ1JVeEFoa2s0?=
 =?utf-8?B?dFhJcTI5SUNsTXZhWXQxUzViMDVWV1dVdkQxK25BRTJYUjI2RExnS3JBRHB2?=
 =?utf-8?B?aTEvdFdnSmVNRGo1ZmduN0RzQVhVRHpvdmhmTWowc2MxblRUMllZQm40dC9p?=
 =?utf-8?Q?VQMp86Jtwq4LLn6I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2117039CDB2454EBEF0505F7A26CB63@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a7933a-28a8-4529-c825-08de6f3d57b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2026 22:30:38.7154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cKKLcGNw/n1vfKzRMEzBd6qTrLXNUB4WaiXGEpBZap5l7fin7ehthjmI+yvIRxqDJW2FvvFaAR6CCUwyxznAWYelqDGmVTIQxCj/ye1QKfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7055
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71281-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 0486C15AA59
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAyLTE4IGF0IDEzOjA4IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBXaGVuIHNwbGl0dGluZyBodWdlcGFnZXMgaW4gdGhlIFREUCBNTVUsIGRvbid0IHpl
cm8gdGhlIG5ldyBwYWdlIHRhYmxlIG9uDQo+IGFsbG9jYXRpb24gc2luY2UgdGRwX21tdV9zcGxp
dF9odWdlX3BhZ2UoKSBpcyBndWFyYW50ZWVkIHRvIHdyaXRlIGV2ZXJ5DQo+IGVudHJ5IGFuZCB0
aHVzIGV2ZXJ5IGJ5dGUuDQo+IA0KPiBVbmxlc3Mgc29tZW9uZSBwZWVrcyBhdCB0aGUgbWVtb3J5
IGJldHdlZW4gYWxsb2NhdGluZyB0aGUgcGFnZSB0YWJsZSBhbmQNCj4gd3JpdGluZyB0aGUgY2hp
bGQgU1BURXMNCj4gDQoNCkRpZG4ndCBzZWUgYW55IHdheSBmb3IgdGhpcyB0byBoYXBwZW4uDQoN
Cj4gLCBubyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4gDQo+IENjOiBSaWNrIEVkZ2Vj
b21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo+IENjOiBLYWkgSHVhbmcgPGthaS5o
dWFuZ0BpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNl
YW5qY0Bnb29nbGUuY29tPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxy
aWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCg==

