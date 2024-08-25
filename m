Return-Path: <kvm+bounces-24995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CD8C95E0CC
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 05:15:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A00A1C20EE0
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 03:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 789BE4A3E;
	Sun, 25 Aug 2024 03:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hVxo5nPm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6082209B
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 03:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724555733; cv=fail; b=gub9BU3wdl8IKBfwDsOAu/ze8SSXDcmfrsk2URQkUtUpYn3rQnLh2Fu0pdsXza/wHN0fTCBKjBMOF/Jf9heU1TV0YUzR0Mhn84vXAlJwRvVl8599icKJvvG6CP/Hu7feD3t6I0n7RHQfr5K0AgI98gun149nQGxeO41FUfD0PVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724555733; c=relaxed/simple;
	bh=6PcS6yUnOjaLljLPeDgUYLxGe/HjQDvnCeNHMbscOwg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YqFE5X5G86LRaQLYKXGdvKWCQRq+FfgX5xXtSGEvApG3mbd/jQrMi07U1S5q6XLLpSfT8M2Ansth0c7P08TE0m1a/uOn+LChPaXW29VEVs0fDdNVcZMvJWAeuBrCE73jRY+hkXbXocRxWJkTHH0gNw5mU7vxJwsNdD39oOMaxmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hVxo5nPm; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724555731; x=1756091731;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6PcS6yUnOjaLljLPeDgUYLxGe/HjQDvnCeNHMbscOwg=;
  b=hVxo5nPmV4qjr1D625UEvIT+yd//esnjW603Ro2SDdgN754soIS5hvUp
   qd6GfeXZjyCr299cHzoPQsFxsVl+SIdq+4UzK0sSSKZr40q26KM4PMZnG
   36SSFnjohe8har2CeginHEADQb6qth6pCh22eaZlesuRJJ9NjBav96pvA
   pwsDQep0Vx3hpFtg32HCW3yAh4mvB9C1nZJ2SuoCcMQ1uFaXlTJSDYs9c
   im9qinB5CfmxyH5PymD7e6GDVxTC4qb06BsWhnvRhXuz1T5QNb9gu8/V/
   Wf5kdzYD8d3nRvHJtMrBuNK2VG4pce0lOhH99o51f9tHIU+CKKiTB0DDZ
   w==;
X-CSE-ConnectionGUID: AbH34J3YSj2oHuP/3c25qA==
X-CSE-MsgGUID: +mSxFngcQI2TtY9KKiCzHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11173"; a="26872833"
X-IronPort-AV: E=Sophos;i="6.10,174,1719903600"; 
   d="scan'208";a="26872833"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2024 20:15:31 -0700
X-CSE-ConnectionGUID: 5l5IiQn1QymEwEtqJfP1EQ==
X-CSE-MsgGUID: B2b67yT7QkS4nUbB1oOM5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,174,1719903600"; 
   d="scan'208";a="66975943"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Aug 2024 20:15:31 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 24 Aug 2024 20:15:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 24 Aug 2024 20:15:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sat, 24 Aug 2024 20:15:30 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 24 Aug 2024 20:15:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jxt3FVv/lABjjoA6VatUzvxLZTvb3qEAC89TkPnjDWn7MY46Gr5P4FPdaSi1hdlOgswKYk7GIaeItix8N9dy7Q6hOMfGb8KByEZFzLor4oOWUlPcylMivpISTR619AMRscNCRPsIpcp38QgYU8BuWksI2lWstrCHVR4nxSJy2R1ykef2YA0ERdMqFG4+kToUMuvWCsjScp7vA1B690yFClAaYswZ1LYNVwpNVBPq9muVO63pI+uTgXMsXl23aSiiBYTA7vExvftvk6o26K8o+7OgIapo1r9I3HzrlQ5Gth1czCl2vBtFU5hWIvtlLbN15jT9xqBOrvA7b8WMjpeAsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6PcS6yUnOjaLljLPeDgUYLxGe/HjQDvnCeNHMbscOwg=;
 b=oebIZO5zSvaI2JGLFye2da+9p2tK+BzJhIbJHgUAgDSny0kl5ZkbKHhqwTQIcNsQUb3imI3pp945/HacscDa6V9eFxCJB3BScZSt4oz5hY8yk50PnvUjL9CDU1tSKiA1OGy9ghSx8ejiBuvmvaCehjZdWvXh9q/Yr+8fcs5HJJdwDWRLnCEC1tIe2D/CVtB93/ozqiJ3tsu44TG8tk4HOZMqzAY79fugFjLMVCERIDpsEONeyhbJ2oXuSjBeL2BdUd+9gSvszf89Ts1hcagtqe+9gD+YLb1Q43Nfr/KXTskR1zPPLFG2w2OeulpG3C8Z2N/2x976IREpisKEQcl9kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8436.namprd11.prod.outlook.com (2603:10b6:610:173::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.23; Sun, 25 Aug
 2024 03:15:23 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.7897.021; Sun, 25 Aug 2024
 03:15:23 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH] fixup! KVM: x86/tdp_mmu: Rename REMOVED_SPTE to
 FROZEN_SPTE
Thread-Topic: [PATCH] fixup! KVM: x86/tdp_mmu: Rename REMOVED_SPTE to
 FROZEN_SPTE
Thread-Index: AQHa1LQsz3A5pP4HqUyV8fUiTsdy3bI1xEGAgAHMYQA=
Date: Sun, 25 Aug 2024 03:15:23 +0000
Message-ID: <c5b569c9b1ac417c359468689cc7af5499385e73.camel@intel.com>
References: <20240712233438.518591-1-rick.p.edgecombe@intel.com>
	 <172442171206.3955037.12407652634764433628.b4-ty@google.com>
In-Reply-To: <172442171206.3955037.12407652634764433628.b4-ty@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8436:EE_
x-ms-office365-filtering-correlation-id: b2f5e4fd-d557-4e69-ec3a-08dcc4b42878
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a0JXdkN5OTVhU3FHNWhTMzZUejJWM2diMFNhV3JMbGc5eE43RGZaRFYwRzlN?=
 =?utf-8?B?dTg2YkpMUUVwZlhkT1dUem9HczJ5eW1Xd1lDUFdqOE5EVzZ5cW1odnhoZ2pj?=
 =?utf-8?B?czZ6SFJXY05vZk04RXJMbmpDaWNvS2hzUDgreS8ySzlFQ0JXRDJsSGpxcFFP?=
 =?utf-8?B?aC9QWW1WVlZmUVJiNi8wS1FaRUpwWmErb3FyK0hhM1lEZVBNNTlzMXFkVTZq?=
 =?utf-8?B?b1VrUnpjc0cxSTdlUW9reEhBMEpCUHVROFkzcHZFaGNqY3JKZUxSK0o4Rmp3?=
 =?utf-8?B?R05HdEZRMnJpRmRDZy9zQXlSMXR2cVRkWDExYVhZNXFnUTVxRXVNT1Ftcmgz?=
 =?utf-8?B?NnJZK3o4V3Vjaml2NG1ab0xSZHZXaHoxbkE1ak9nNThjKytVNnpYYUxkdUp6?=
 =?utf-8?B?WmVYTGQ0Qlo1end0RXAwVmxvVlBpM1JhTlVlak9XRHYrTEdSTlFVeUNUSG5l?=
 =?utf-8?B?UGV4b05PdmxxOW5LTVY4bFpsb0tzTlFuQTZvKzRmNDM5M3BERGN1L0JWVU82?=
 =?utf-8?B?YTFRUElSSEJkaEgwQWpHSFNjV1RKeUQrZTd5cHprMmNSNStYZkV3REFpVnZi?=
 =?utf-8?B?ZjluTEtWVTBiNjhCQ1llYno4bzNualRtVjZBamk2NjlPN1h6WTRQWG5XTk9F?=
 =?utf-8?B?VXlxWXZhbWlmN0VvQWtlOU1IZldmMzcrcVg1dzRxL1NBWGdqajhheERxMkM5?=
 =?utf-8?B?M0pTbmc3cEJTQjYrK3hFWjFMTFpDZ3Vsb2RVejFJWHdJVVM5UmVJUTh1Vzlm?=
 =?utf-8?B?QkJFVDlGaC9QY3NWVGFjeGJoeUYzdkhpQUxEallYRzJrdE80NzFCNG81emJm?=
 =?utf-8?B?Z1ZRVDlETHNSMTE5bXM0eE1QUFB1VUYwTElRUUlJYURYaG1yM05Za2EvTEVL?=
 =?utf-8?B?b1JLWGVmRnpwTEpxQk82ZTl2dHZWczJ2UGdRSGpaaVFRVm9pZ2Z3bG8yR3FJ?=
 =?utf-8?B?Yk5JQklWUTZsWDRwdytXeHY2anpETGlhOTlNUDhKUCtkSkhPaHM3a1lCcE5U?=
 =?utf-8?B?aHk4OXB1eDZHWWJZYmpISVpRZi9hL1hnSU9leVVTcWVMNFo1dm5tS3RkazJH?=
 =?utf-8?B?cEJqWEJxYWZXbnY3Ry9tV1dHdWhyUGVnQ2pxL0tmOTZqelhvOVc0SGE5WjVo?=
 =?utf-8?B?elJlNDY3OGNFdnEwNDRrME96YW56citVeFJVR21FVXpZTlZJOWtlOVQ5cTFk?=
 =?utf-8?B?cFc5T2FLS0NMT3c5Q2IyVzBzZXpjbmI2MlZjMHVFRVZTTG5YRGU2NnlPUzZ5?=
 =?utf-8?B?RUZCclI0bHMvbkl2NlNqLzd5czVXSlhvRDRhSVY5Zm9ka2xVVFJIVnB5TG9O?=
 =?utf-8?B?VjFEUU9oYUZncjRKQ3NkeDkxK1N1NzIwWnFjOGJkWnZzMVJCM1YxWFZTNUlM?=
 =?utf-8?B?N3h3TWsvZkRNdXdTcVNYaXBNWnprNHJKME5ybUJRV002cEhtUCtzMm5MU29m?=
 =?utf-8?B?YWh4RSs0L1BpNndHVWVHRjc3dVZTMzlQL0txQUUrcFE5VmpYenlFcnhhcUlH?=
 =?utf-8?B?ZkExM1FLc2JpNHloc0VjYnNnQTJQeDZGb3dFK3YybXlQdWZpQ0UwRENCUzNY?=
 =?utf-8?B?SlMwUUs1ZFc0Y1VWYlQxODRwTzVPYjdPeUxHNFJyWnlvL1JlQ1FEU2dRZEhZ?=
 =?utf-8?B?Zy8zNDZRQ1RCN2hCbDc3VGF1ZVM0cFp4RERYZG9OUUoyRTd4SEJnSlV4MmFY?=
 =?utf-8?B?RVBIL3E4WXNoZEFYZ2NmM1hCL0N0cno4eWtVZXUrVEtFLy9qelJ0MWl2K0d0?=
 =?utf-8?B?b0R0VjF0VElDK1Z4dlBCV29WUEU5Smd3QTNEYjFaTkx5S0xxRmJSbzlyRndx?=
 =?utf-8?B?ZU9YSXc1RVVZc0trSk5ISVVRYzFkM0hmRzExb1pGZ3hUdmo3dlZ6SEQxU01Z?=
 =?utf-8?B?WVVUTDJQd1dzaEd3R3NaczVCNWV5NHlEOHpoR1ZrRC9hMnc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXk2ZTFZU2JwZkdWYkhMdGFINk1pUi9hSWplOHlPV3BZbGNFL3VkWGJlRS9U?=
 =?utf-8?B?L1RXRnp3VWg5Ym9JdTJRcnhTSkhZTUNDYk50NnJzQ1Z4OG9QUGR3c3Z5ZThN?=
 =?utf-8?B?dnJqdFlTMTh0TGJIb3QzcnAwdXFaT2FzYkgwZ2Fldi90MWF4TnJ5SnRwYlpP?=
 =?utf-8?B?ZnMyd0VITlp2TXNVZ2dxSnZTRzNHcExTOERqT2Z3MWVOaWJqc2xjVUlVY2ZM?=
 =?utf-8?B?KzRPZnRlQzF2U2h5K2pVRzdadFV4cEpIZnJ6SHJSbXJzQmwxU213ZGZ4cmo1?=
 =?utf-8?B?blJPUGd3RnRFcUhOdmEySHhDRWthYU1tb0VWclBPQWFFVUg0cU5BN3cxNktz?=
 =?utf-8?B?OHRUaVlTeS9MS2ZtOEFYRk5PN1cxNUxuaHcwY1hzanE3R3N3Z3FESWpxT09p?=
 =?utf-8?B?K0t3TEJvQXk0VTFMYURoVlJ0MHFXR1hzenJpYVpVN1Z0WDUzN2x4L25WQ0JJ?=
 =?utf-8?B?V2VyVEFrUFl2U0RsUE11dnVlcE1jOWd1UWljQ2t6VVJIL1ZseHVFaHA4QkxW?=
 =?utf-8?B?U1NnbXNqRHlZRXMyaXFYTFlGUkdEREYyZGplQjREcFVDSEFKMHA2SkxMVnRV?=
 =?utf-8?B?clA5RXJYczhzeisrZ016a011aVhZa0JNbU5Vbmw1ZTFINGxHenR5djJST1Rt?=
 =?utf-8?B?ZkpyNnFhdFBFdHIwaFNMZWdQT2F6dXFmOFZUVjJNNVR6K0R4cjRLNkhyVEcv?=
 =?utf-8?B?UDA3TFBkbENKc0ZHTHNhaGtsT2VaNzRacG9EajFWcTI1T1V0OTQxNWNOTlpv?=
 =?utf-8?B?NHB1czN4R0pyVHlhaVhtT3QraERXcWd4YU5Gam1GQmptUVRkb1FCQW5ONDhQ?=
 =?utf-8?B?cGFrdGxPTXBqODdnQURTa3BIVmJLczVWanZtTVFRRXVLVE01MTNnY3R5aWlB?=
 =?utf-8?B?c0RGa2RPalUvYXNCWXp4ZmRESThrRk5NTyszNkJZK3VxUm1kZWNnS3A0UWZP?=
 =?utf-8?B?VytLTkNwbE91ZEl6UysxU2RFWk5uVjFtTm1UaVVUSnN3elZ0NHoreldPZ014?=
 =?utf-8?B?Wk1EWlZFdmVlK2ZULzNveWhVUTYzbXFaVE9QNTV1bDhzS3VZY012ZVExeG9w?=
 =?utf-8?B?Vk5EK0xmd3czd2Z0cEZKTkhERGxzTG1KVnl4ZFZoNTVsa2pRQldVdWtwNUhT?=
 =?utf-8?B?T2ZmOE9LNXhBdU92YlQxMW9hT2pCT3pxNlBuWEI3cHZKdVlsdnVHK0VPeHox?=
 =?utf-8?B?N2VVQzNhcTFhdDRlN1ltLzdjRDcyajRNY1BPTDFud0orRnM3YnJ5TlVLWDcz?=
 =?utf-8?B?SjJKWHFONzdUakFXM1BHTnZNb1dUTmtmM2FVeENNRmxXdnNkM0JvbHJvcVVF?=
 =?utf-8?B?aGI0L1VBOHUrS2E2bjNnS0N2eExYSEpSTTlDK0cwMnhnVTVlTXpsYU1ER1ZC?=
 =?utf-8?B?cnJCWk40b21TQ3d0UFhTU2lkQWExRXVxdTV1OXdGZ3crck1rSFhuUEVnTzIx?=
 =?utf-8?B?UXlNTE9DNEY5Z3RRdHNzSC9vb1FSSi85V1B6MURUUlAzNmphdnlreTY3bE9W?=
 =?utf-8?B?eFhJa0JYcVVnZlo1b0l0K2I4NnplSUdxK1R5VDQ1MWMzcmhuTTJGNVg0b3Uv?=
 =?utf-8?B?LzFUUTREbVVKdno5VzByTUx3bzNrcWpDV0I1TndiY0JsWThmQytXN0NRdlIy?=
 =?utf-8?B?OGtraEVsS0pTV3I4b0NOb2pOVk1oS0poWmxydnIyaEt5UjhuWmE3VWE2YTNa?=
 =?utf-8?B?cmRTKzdEUG9mazF6OGEwM0dhZktNOXpMRXdjTXdxd1lGN2Z0UjVrUSthNXFT?=
 =?utf-8?B?VXpPd0FxTVpWSzJjakttYTNtUEZaZGRBc0loeG9mU2hDWG93NnVsMytwNTEx?=
 =?utf-8?B?bHJBOE9sdjlWSzZET3dmMC9aNEVHOFcrbWlUQnFZNG56d3VzQmpIanpMeG1u?=
 =?utf-8?B?U2dzVlNsMWxmSmZNL2VCNUI4VUJJWkVKbk5kTXN1SllkaVprdU5ISFF3WHph?=
 =?utf-8?B?MjFDeDgyUHVsYWI3YXlYM3ZZU2orQlpKNmloM2hRS0w1cWFMOWRLZjFacm9T?=
 =?utf-8?B?VFVjb2xrWGdsaVUzaFhwc0FuWWJpMUt6aFlySVZqOWVhS2o2ZW9ZMHlDYnNv?=
 =?utf-8?B?Zy9vYlBtWXpFZFkvbFVueVRZRFdPZFFHSEMxRDR0ZEVrSC9XWGRDa294cnBw?=
 =?utf-8?B?ZmZRcHk3RU9FUkxiWDNXeHFYeURvVGUzQWNSK2lVNFF1N2Y2U0l6VDFqeFRR?=
 =?utf-8?B?dXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <478BC8D0E6AB48488705C8A465FE8D3D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2f5e4fd-d557-4e69-ec3a-08dcc4b42878
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2024 03:15:23.1676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RJ3Z4ToLYknTpNkx7/528FD/krd4FN+QLi8voKkHsUayh5ItPaK9xigjzpXQgzLFobf7hGU8G1q/faMVjspS2oeR3iaARVEf8dX7Ti/wuYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8436
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA4LTIzIGF0IDE2OjQ3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiDCoHdpdGggYW4gYXBwcm9wcmlhdGUgc2hvcnRsb2csIGNoYW5nZWxvZywNCg0KVGhh
bmtzIQ0K

