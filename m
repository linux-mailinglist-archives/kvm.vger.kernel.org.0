Return-Path: <kvm+bounces-30495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECB419BB116
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 11:29:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E9611F22957
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B20B1B0F39;
	Mon,  4 Nov 2024 10:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I+M6/OFB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E391AF0D7;
	Mon,  4 Nov 2024 10:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730716143; cv=fail; b=WDnJR+bDYET27CBGIRNYxow3W6yXCzUlvS22m/YqC46P5oq6hexSvCgeohRxrhQiX9QTcGJhw3+vygCujbPZSoNGEB+q1zEsD+7uzKgeQc9bYXPG2vpQX1GMsRjaKzf6zdYGvrlfmAxcCY0WXvHZlcPovEqO/Rmmjr4tL2AuWE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730716143; c=relaxed/simple;
	bh=WaDCCEtyEktSVk6jiTNsCspDVOA55QkYC5/iM/MuA4U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fFn8pPZ+Eke6JANJ/Vv/EZz5kVoT1IsQTV1yuWnsdUQarsJ0mA8x2RZNHewuK3H8SGUZCQsMMVjGlmcBn17SPY8HybePyKliVSWCekXhK+xoQ5VeUyaCSp0q2ICCoVaCXsnu0Ymz1lwlNpJgZi3qDd62L+iusTH4rioDtO5LCmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I+M6/OFB; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730716142; x=1762252142;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WaDCCEtyEktSVk6jiTNsCspDVOA55QkYC5/iM/MuA4U=;
  b=I+M6/OFB3vcKjyQAo/jh0ObLfw8z/dL4njFxPI+9LlfRVoXmIKpSrDjB
   9g9/Sa7WU1TPq0zy8yCtr5Z3mrDvgkQ2A5MoGp6KCNqanrZuvaXje3WCk
   BgO2hmLv/WjqfiV+6+c27qSlFCRTzfjUbT5ts/OeuvddFaV1AnFkV+maz
   Nay1ldV7FD5exbudxH812BRRRc7CPA8KJvg2f9Hoy1Cr7kYxRTrWMZXci
   FfvfaxnCyl7xIoiTYYnxgx0lwuFZtcYu/Yexsn9f1PenMudu6mhgI+U7X
   3WfocVOREl4SGglLAibuj/PFlzFTlWFINjugLfG0KJ4FeJRyhKSQJe5rq
   g==;
X-CSE-ConnectionGUID: beINrHXdRCqYSa0CKB6W0A==
X-CSE-MsgGUID: CFTNmziTS1yf6gO59fAEKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="29834367"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="29834367"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 02:29:00 -0800
X-CSE-ConnectionGUID: KVKJ2qs2RlWO0lBG8gWk+w==
X-CSE-MsgGUID: +A6RjPNVTKaEnkeFV0+0PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="88741754"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 02:29:00 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 02:28:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 02:28:59 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 02:28:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A7EF95MlMplDYJ81rIqZ8QtpoM2g22Txg4YLgO5okJBEIRgnFzUqFXwFRLSUrcH+LgBZGRqCQTSQfZgtiUVil7PgtYC3Jfa+C35Kdpb4sQPKlMp8NK2nCjSlO4nPH+LMSocejkRZb0ZsMTCifFbViwDFK7XP0YjCSdp946L6vbM+yZV+wB08k38tyf1oMA0vNa0io/0l+kc9aY5PX+rdDWMVEbgeRUx+hvMjzegpHVUrZwrNVSXtzcON9Pn8Ke1auc3YLiXrS2mw/taS5Dg63mJiDsu1dL7y2rhiLJjxNSvM4hgtuzjQwEFBuSLe64n2Eftzl+13X/OzmxVVFDHUKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WaDCCEtyEktSVk6jiTNsCspDVOA55QkYC5/iM/MuA4U=;
 b=uf3AZOqD1T1MqZReqp0mAWBRnvtDiXrxD1vCI4NMJxfjR05khXMNFaQwcUiwCabdj+yNUR0bK7hddD1RriOb7itcKwAxs9Eu/+n1lzJbA7KtZ72LDjZS/fapNA6XUFnXjA+tsxMwoSb5lOx2k1ym1C42pNukqnHeuN8ZGkitY0iInZTuhnbOz0Izbk2ogv5hQSZ69p7e1jtAu7cDzy889cMHlPTE4a8Nl0RcdOIvpOviQLbq7vvNVDpia/9n2qsx/UlYTWogu9NAUrfXSbPsHQOtjBLokTPY1zSmnqOuO6ojRTT8rBK8ZImr+bvNtzmwEs3b+4Ln+duoF7OTaLmdtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 10:28:57 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 10:28:56 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 8/9] KVM: x86: Unpack msr_data structure prior to
 calling kvm_apic_set_base()
Thread-Topic: [PATCH v2 8/9] KVM: x86: Unpack msr_data structure prior to
 calling kvm_apic_set_base()
Thread-Index: AQHbLIz3QDzvp3NRoE6Is+Zx49JPtrKm75gA
Date: Mon, 4 Nov 2024 10:28:56 +0000
Message-ID: <3213afd28974933d7597238f4434c4589f89b2a3.camel@intel.com>
References: <20241101183555.1794700-1-seanjc@google.com>
	 <20241101183555.1794700-9-seanjc@google.com>
In-Reply-To: <20241101183555.1794700-9-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB5819:EE_
x-ms-office365-filtering-correlation-id: e58ed745-3acf-4bda-1cde-08dcfcbb7d1d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?akVoVEVtY0dCSUJERXluYWhKOWx6VDA4Yy96Q1NneDRYbVFTbFNjK2pNNERv?=
 =?utf-8?B?djYyanMvcWdqWW5pZXFZY1kxbFJxeHpXc1JPQmtzWE5xdVY0Y0JYS2ptdkIv?=
 =?utf-8?B?N2dnS2VQOTY4Y0EzYUowSDE5bDFRUjhINUpBa2xZeWRHdWtGaFd6TUpRZ0t3?=
 =?utf-8?B?bit3RzV2emtvUFJVemMwMEJRYzNaYXdnWlByYm9HSUxCSkdjdVQ1VlBUNmth?=
 =?utf-8?B?TldhNDJSUXd0VElVSnhrRnU2UlIySUEyb2lYTVplanhMSkxia1NoZDBkckhw?=
 =?utf-8?B?RHQ2VWprbXd2MXdUSC9FYmpKaE81Q0hoeTJOUFU5RGhFWW5aK1YranNOOE1v?=
 =?utf-8?B?S0Q4eS9IRGZwNkNzZ0FOVFZvZFU4STJ1c1RIcXFhU3gxbVBlL0NFd2tvOVgv?=
 =?utf-8?B?WnE1alJrdUJKM0NyK1VQVUdiV2tXTGxOMURQc1VkS2diOWEza0xmVTNVOUs0?=
 =?utf-8?B?MmxMbUFySjUrcWx1aFg2amJzbjdEeEZ4bUZ6RDNZQmdkSTlQWWVTOGZycXNF?=
 =?utf-8?B?ckd5bndlMFM3VzMyb0JaNmRkeXV2cXFpVXVHQ2NBbUpNbTBNWDl2UFJIOHM0?=
 =?utf-8?B?dm9xMFk3ZXR5ZDhrRTkzMkZFN3ptY0xpS2xSWHdHalloazB6R2RXWFJLYktt?=
 =?utf-8?B?Vnh3c0wzTXlnQ253ckVYeXdaUDJoVDIzM2s4TlovemJkdkMwTzhwR1h4TUJR?=
 =?utf-8?B?b2xXVzUrRkpncU0vMENEekxPYVBmbFlRTUc2cXJ4UUQ2ZmxSVjExOTltaVdB?=
 =?utf-8?B?ODZVQk9YVjE1emd1b1NVSFdBL09mNVpyY3BKaHBsRHNuVERaVU5QNVd0WHhC?=
 =?utf-8?B?N25lNlh0dm9HSW1jWldxOGlJci9reVRzQmc4eVJPSG1vOTF6bjlRbTlENTZH?=
 =?utf-8?B?cW5WSHFnTGN2UGJPRDR1Vm1PejNWSDBUVXZjRldMVURJVTVBTHBkcnBjUGV4?=
 =?utf-8?B?b2VhWXBGN0RndU42WW5UcmZLWWlKcW5uWFExNkFHYTRkUHlFSHNXQTFXYllv?=
 =?utf-8?B?bVk4U1hRdzVqVndKeldkOEZhWC9YTjJFZWFoczVsOHVSVWx4ZTh2OTdFMmVJ?=
 =?utf-8?B?SFlEenRXUURnN0U5YjZTMWJVQThVUTVCeGJzNGJHS0s0YVFJSHYzYXhsSUZY?=
 =?utf-8?B?eFNQRm1yUExFTnZvc3ptU1hxR1ErcFdTbVozdTJlRExzdjRvWnFIRmIyL1VQ?=
 =?utf-8?B?Q21abjNQWlliOS9EZ2M0Q1hzL09JUXQ2S2NTZ3dZcEpNMHgyb3NidS9vbW5U?=
 =?utf-8?B?TWlCQnhLeWg5YWpqY1h6b3BCd2g5U3hlYVB2Uzg5Wm1ob1daMTdDSlNqc1pC?=
 =?utf-8?B?eU5DZkMwQm03bXk5TURhNktmUlAyZUNhcDdjMFE5aEUvQXJWaXBraWJxU0NC?=
 =?utf-8?B?ZmdQQkl4N0l5ZS9uclFjSSt0Q0dSMTlYa0hoMjhzYnZ1T2hFQmxlcDlOczBS?=
 =?utf-8?B?aWtWdmo3Z1lEYmhHNDkxeWhOY0oyLzFMeitnTTJwTk55SENuZzBGRWhJREZw?=
 =?utf-8?B?ZElNZkhQUEs4K1RNV3JNOHFhSWw3bGUzUEk0OW95MG5oenVBTnRmeUZGYitq?=
 =?utf-8?B?YmluemJSajFMWXlScm10L2haMFNuMGcrK3hUSkpUMkkzNGl6Y1kzVGRtdXd0?=
 =?utf-8?B?ZldBZlI1QkxiTitHai9sZUFnR0JJQzRyQWNjZWZNd3owVUd5dnh2MUZZR1J2?=
 =?utf-8?B?aElVWGFVNzJDeWJIcnRXSE51SmZ5WU41MWFKMkFHZWJWVHEzQUVaWHlWdi8v?=
 =?utf-8?B?T1N6RllzdXBGb2ZNWlFkU2dIcUNRQUxyRUc2c2lGd2tENERLNUkrVVVMaUpQ?=
 =?utf-8?Q?u53i3K88T3xQwvFAhA2hnJMMEM4bDqaGlMN0A=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDFoKytiS3lna2pINTZ6NXJqRzRDL1lrbU5iYVoyMXhnWTNlNGwvdGpqZmFE?=
 =?utf-8?B?Z0ZwWldGMWxXaDM5NGVBakk2Q09QZnJyZFpUaTBXb3ZuQzlmL2lGN1FJQzM0?=
 =?utf-8?B?Mk96MFlLQnVHdFVXM3NmUEc4QTB0ZTlCM2plSEpFbkFQcHVYTkQwSUNBRllG?=
 =?utf-8?B?QzBTUUtsM0d6NW1PMFUrSHV3VFlad0txVEYrbDJEK1dsMGZmWU8veWdMRFZI?=
 =?utf-8?B?OW56TUhEdXBwcXRORDk1MDdGNkZQMmhMMkl5WmR0NzFQK2s2NVdrRGdNWFQw?=
 =?utf-8?B?TmFUQ0Y4Wkd4SWF1cHhkRnBHaVZJNklsRzN2dk5jaXBJbEdyRGFvKzRoYkkx?=
 =?utf-8?B?Nys5R0txZmMxUEFneXgzUDIrSUNkZGliUVR5U1Y4NWl0ZEJmQWN0c3JKVjA0?=
 =?utf-8?B?MHRtY0lTS21Bb0MxSHJUdEFrLytRT0dmYnJPL3Y1S1h6Ylk5NDRGYXpmSTNx?=
 =?utf-8?B?d1BoN2ZNaytKQ0RjcFFxenVCd25IeGo4bzNJUStxNm1UM3BMVHdJTlVnaTlR?=
 =?utf-8?B?WnJmT3I5QXJlOWVrNUU0MUV5ZWFFNWdWVGVpbzY3bWtaT3Fad25XQVE1TkdD?=
 =?utf-8?B?Z2FKcmExRDRDWGdZVzNBeHQzTDRobGc5eDQ1NnkreVFWTDF3R2J5RE5NQ3Fk?=
 =?utf-8?B?ejJhelh6T1JQcitka3RpUTkwVTNxYmlVUkJBZWl6NktXSUZZbTJiNE80OEVh?=
 =?utf-8?B?NzZvamp0ZjJXM1g3RWQ2R21qSEhjYlpUMS9tREpFQzhOSEJHVG1rS09HSWsz?=
 =?utf-8?B?NklhV1RLNTJqWG9Kbjk3bGF3U3oxbXdsbDM1TDlHNDRnTHhuWE9QbGttRVVI?=
 =?utf-8?B?YndPYkFNSVdxTnU5a3lxZFpZMXFWcVJLZDdGTExtV0w3WGxlSnd6TndINE9i?=
 =?utf-8?B?WFpJTXRZdVl1ZlRsNGIzUldhcTJnSFMvV2FSRE95dm4rS0w0Vm8waDhLaHVC?=
 =?utf-8?B?dmxsVk5LeVZDUXo2Q0RRaWhKWW85dk5pYWJ0akJyQStnbjVxb1BWN0NaMlpF?=
 =?utf-8?B?eUlUbXJ2MDBjYzg3cTgvYlZOTEowMHJjS1VOWUphMUxmU0hSanQ5Q2JXUzMw?=
 =?utf-8?B?cW1SZFVyZGF5dHIvNWNnR2lkalBOTThZcVMwa3pSUmM1c3d0cVZ6Uk0yeHNJ?=
 =?utf-8?B?Ty90QlZyRU9weWFIZmJkUFhNLzhhSkU3c1ZXcVh2SFJqcWs2bFRZbzQ0dGRD?=
 =?utf-8?B?dS8zZUI3RHY1ZTFXK1dzbm9MSEVrREhyN0RMdkZhOTVRKytLY3lVS3BPdGw5?=
 =?utf-8?B?Syt3cDNnMXVvQ1ZEZjAzbjFTNnhWamc5QUdxTlk5cWRNZCtUWTVrdXhDNUc5?=
 =?utf-8?B?SVFqZVllTUtGaWdack1nT0ZINHkzdStONndoZysycWRvczhGMlJjdFprOFlz?=
 =?utf-8?B?RHVmSjczQ3NQSWpibjM5TVJ4WURqZjRGRG9oSGRuZkNkVU85SFZXQjNwWm5R?=
 =?utf-8?B?ZDFJTW9iKzRwamcyNjBRZ2F4TjlGODVDOVlxWTVYVWljK29ia3R3Z095SVJS?=
 =?utf-8?B?WDB1RHovSEl6MjE2QTdoRWFIOGNhR2pNRm5LMFdKbk9Vb012VDJBQk1Vb0E3?=
 =?utf-8?B?WDNOQU1QS3NsN243MWxLOXVicW1NTmhyQ3BWT0M3c2lLVzVCMWtOL2YvWHcv?=
 =?utf-8?B?bEx2bHQwYWpjWTRQaW92OHFTb0RLa1RPZ0M3ZWpCaGh5Y1BtV0F6bTN3WDZU?=
 =?utf-8?B?Um53U3g4a1pGWmN2V0VEcUxPaG5mcTRnU013bUhnUDhma0MzMEgwM05zR1BO?=
 =?utf-8?B?YllRV0ZQTi82SnVJTk5iaXVINnJwV1VaYXQ0TEcyN3BTbXB5NmdYY3NmU29p?=
 =?utf-8?B?NitJcHp4dnhqREU2ZVJWSVNWbkUrcTFRS1c1SWdSZkgxMXV3aEFxdSt6YWlj?=
 =?utf-8?B?akUvU0lRNDB6ZzdGQnlzd2plZmZldE1ubzNBaUliTE5wTkdwSm11bnlUOFAx?=
 =?utf-8?B?VHJwSENHRXlwTlp4TEVhWVFYM3FueEJuYnEzSS91Wit1dWxuU09vZDZxUk1Q?=
 =?utf-8?B?OGpwRkI2akdlRmFoMENCTHkwcTlFQTdGeUwrWUtlVkxXaFp6TUoyUTZKVjRO?=
 =?utf-8?B?UkJHYndZdzFUUHRaNGFBcEJ0Z2tYWVNKVVJtOHE3VDVkcm1tMjNTNyt4S2E5?=
 =?utf-8?Q?RVGpzVb0fTCIC4tSngVRMOUes?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71018256F6786C4888C87BFEEE323407@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e58ed745-3acf-4bda-1cde-08dcfcbb7d1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2024 10:28:56.7656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pCumAOyPAX6889gE3noRSeQxMedfi7GRC8F7ApAXI0j9R4PMVvDJ+JaQClQzq2pHN+QBMfeg3p7FYdXs1pjx7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5819
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTExLTAxIGF0IDExOjM1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBQYXNzIGluIHRoZSBuZXcgdmFsdWUgYW5kICJob3N0IGluaXRpYXRlZCIgYXMgc2Vw
YXJhdGUgcGFyYW1ldGVycyB0bw0KPiBrdm1fYXBpY19zZXRfYmFzZSgpLCBhcyBmb3JjaW5nIHRo
ZSBLVk1fU0VUX1NSRUdTIHBhdGggdG8gZGVjbGFyZSBhbmQgZmlsbA0KPiBhbiBtc3JfZGF0YSBz
dHJ1Y3R1cmUgaXMgYXdrd2FyZCBhbmQga2x1ZGd5LCBlLmcuIF9fc2V0X3NyZWdzX2NvbW1vbigp
DQo+IGRvZXNuJ3QgZXZlbiBib3RoZXIgdG8gc2V0IHRoZSBwcm9wZXIgTVNSIGluZGV4Lg0KPiAN
Cj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQuDQo+IA0KPiBTdWdnZXN0ZWQtYnk6IEth
aSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJp
c3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IA0KDQoNClJldmlld2VkLWJ5OiBLYWkg
SHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=

