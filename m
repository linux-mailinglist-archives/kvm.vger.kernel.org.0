Return-Path: <kvm+bounces-64773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AB00C8C447
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:58:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7B6C3AA04E
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D319C3002BB;
	Wed, 26 Nov 2025 22:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WguvaZI5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879142DE71A;
	Wed, 26 Nov 2025 22:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764197888; cv=fail; b=Y0OhAZBCtupfO7F9odSaOa8eswMijNeTmqPV0DAQoHMQ13cSAd+R3f3F0Nati4xFPyty6caidbC3ptGDmJdT5mjbcivmGmunpsgA8lmSfdFAErwtM2JMRee8sE2DS7AD00/nD/ZceVMpdZPTH5ily9GtsWHnpBuePWT1+Hyo7Z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764197888; c=relaxed/simple;
	bh=RnVFiiDwaWidZanM06AyClrXjC/0jh+Qw46j76NIvvU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H4fyyf9SIajmHU6wefMwFr4Z9kpKG5diXO7jR0LfsreVvFR67SlxUnT0J9dRV6436+urEUSZ6OXDvThl76Y7amW9AksF7R3/fUAMR1ONWnabnWZdWanclUwwhQrMjhwyP5xnu4b7aYqtnSCVWl+9IKaC8t+M3MBor8L7tfLTDjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WguvaZI5; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764197886; x=1795733886;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RnVFiiDwaWidZanM06AyClrXjC/0jh+Qw46j76NIvvU=;
  b=WguvaZI5UVRrWHN6R7tMPsChvOxURH/EVzMP4CA7SA2ErHMFBZCee5pj
   n8TPBll5iMLvfzJx0iKgzf2A7JB5tc1kNCrgn6s3aVKkc4HCZkTPiCPHY
   K2mFYMS2HR63TEu2Nzi+Y0AqFVL1JvU8q+OeKaD0iKC/LPkv9kC39qkIh
   kmlGFmdMoN7EMgbGHDOwKzjH4uirNh+NG5csLsQz0k04RRpy6034JLPVv
   xJKdyzmhCBYcQpYrY2Tqj25WQXodaDJUp/KSwiZ91Fbr4yAClcLDrPv1c
   3qEvN6E8uFuJrG/GHNSDfsaFCvxlduROLw+KRpxPIfMWHFDPQJWSeG9ed
   A==;
X-CSE-ConnectionGUID: pUXRjRA5QA6+I+9LKQcy8g==
X-CSE-MsgGUID: xmLf9a3hRkK9KtjDwN3rnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="76932508"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="76932508"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:58:05 -0800
X-CSE-ConnectionGUID: k+meJQBmS1W5zzxTqrF38A==
X-CSE-MsgGUID: K+3qrxWBQheuYZ6k+qmzeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="198019684"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:58:06 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 14:58:05 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 14:58:05 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.42) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 14:58:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MxfgVmQNwqIIjmNO4ESBi0jJhOhXt5nWLIElawmZd6qNEjJaGOcaQv9Ev7qGYIvHotV4qHvgabSk9kBSqvs2xEkXG7wIfC5nVzlWWk3FoYsqYYvjcQgy+UfrrfKB7KhpelgS2o8CyQcZ5jMqrWGgWYuUM9chWwZjZeB9oflA/mqpN0mRXt5fDPVU3A08fQ2xQvB+1o9Jsp+gGV4OFSYcGxOdDfXnHkdXtcfxaeFNCwbsQ5nR6OM2550VSe+g/HG/HYR/2A74FfEmG9Wh+2rVZiSavMGOllCJmRgsKqnZ6l3ZcaPIwqji7W4cDZIAWElo3wyDCp2D/KwTyrpvJ4m2vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RnVFiiDwaWidZanM06AyClrXjC/0jh+Qw46j76NIvvU=;
 b=nmwEcgBDTsCsp82RU1ADR8MJudMqStKfd1eNOVPWF4cThbaJ92AwV20hN1I/JBv7Neh4u39ck8JEh7L2XjaIvdRp54MWEvrNDVEVXFQ9g2KoHEPP0MS7y53+gen5sqJtjIX1jr32RDkmg2zRhv2PwOQH0L7/P4OgfdhmgGt4vMG2os6H7xdU/MABqjfRwhGLEBSW+MqKp/CeQkn3C30fbbCq9A8ZvI4KtK1wt/krntDUfyhNK+xspBZOCuL+RQfeI93yCXSbjhwic2DRWqc0XubXI6DHPaAQDUZoqpDEmpbjeOShVYPIWncVGo+TGRjshbBj6uThgP5LUcpPMSySEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7081.namprd11.prod.outlook.com (2603:10b6:930:53::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 22:58:01 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 22:58:01 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v4 14/16] KVM: TDX: Reclaim PAMT memory
Thread-Topic: [PATCH v4 14/16] KVM: TDX: Reclaim PAMT memory
Thread-Index: AQHcWoEKupwu+Bpx30mmnwbPdEBbKLUEr1iAgADr3wA=
Date: Wed, 26 Nov 2025 22:58:01 +0000
Message-ID: <41d1f349377c9d390d667ae92ef573a9760405f0.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-15-rick.p.edgecombe@intel.com>
	 <7fd9ebae-58f9-4908-87db-4317f30deae6@linux.intel.com>
In-Reply-To: <7fd9ebae-58f9-4908-87db-4317f30deae6@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7081:EE_
x-ms-office365-filtering-correlation-id: 7ac02507-8128-4ef4-e6f1-08de2d3f402b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?OURQd0JIejhTUzVBMmRrNER0NVhUNjZESDdWZERHUVJndFlUaktmNnFFejBy?=
 =?utf-8?B?bE9JZ3U1QzdEV0c5NWRkZDVmR2NjR0tzZHFyZXU4SWtOSHU5QkFYNVdpcFNi?=
 =?utf-8?B?Y3N3RFhXaVIxb2d1TFdCU2RjSVVvRVQxOTR6RTFvYVhhM2xmanVBWHFGTm9B?=
 =?utf-8?B?Z3ZpM0ZtcmFWZWNLSkUvcDlhWDBoNnFVVXNaTG1UcTFqL1BTY1BQbmlJMEtt?=
 =?utf-8?B?eml0UzVHWG41ckhCM2FWOHNkQmRIZGJVVHRROU16N1FXRGZ5SGgrNGUxOXor?=
 =?utf-8?B?eElTRittRSs5RU8yWXJHTEJKemdJOWRaSlVac0VDNjRiWXZvY1VJYXVjRHdo?=
 =?utf-8?B?UXpCaXNFNmR4a2lXTDNWT2lTUi9mK2xGWTFaQ3RQNFMzVmQ1SUxxUjREVitU?=
 =?utf-8?B?QlpyNUpSbTdVRS9rVTNZMHlDZEc2SGtnWXIrSGRCTHZab2NNSlQ4UUNMOElR?=
 =?utf-8?B?d0FCWkNNd1FjVWtSZlA2bmUvaXRKMWRYRmxwYjUvZnlGZm12eHRNY0RTcDhN?=
 =?utf-8?B?NnI3aDJRWjY3WVRnMlUxRjVYTlplNnc4MWRsR1hLVStvSVpqYUl2RTg2Y2l2?=
 =?utf-8?B?WDlLZ3huRVdFL0hvMTMrSzdGcmdzZ3UxR1dYYXUzVDJZWFJUZk11dXliV25K?=
 =?utf-8?B?MllxRDVXdVpZRUxsaHVNcVArOWZFQ1E0RXlNSEhFbHNhU2ZxcGFzNGJaTmRC?=
 =?utf-8?B?MjNaU1VBQWZiKzBJUGhGT3ZydzlGOWRHcUN6ZkFncFVyQmhYeXBwZ3VOWDlL?=
 =?utf-8?B?U3dZWUxKWFAvYjM5ZlZNUS9zK1lna2FUbUtIUll5NWVRWVVQV2VMOUpVNVlj?=
 =?utf-8?B?NmVtSHpOaEYzbzZYdnRSWjNyMlFLeVAxeFlxbVFoRlMyUmVPZkk1V1IxY3B2?=
 =?utf-8?B?VmdJU3RkeU1rdThjL3ByZVB3VWhKYi9zUVJUTmxkVEw3R2pvK1ZXeXJDclF6?=
 =?utf-8?B?TXJYY3dYM2g4NU5wN0NBRU1rNjE3V2RWOWpheDVHS2FSM1drbFZpbGhUU3d3?=
 =?utf-8?B?Z0Iwd2RZeVRLbjlkbDIwdjRpalV5ZzZHWVVjV0lLUDJMRGNlQmc5YkdESE9n?=
 =?utf-8?B?U0lheWlRUTlBeVAwSVN2azZsaC9yVzRZUmFOSDBaeUMwTm5mdEo1c010LzVE?=
 =?utf-8?B?ck92U0JRUWFvTFNJamNKa3A4R3RlMnVXZXFXcWdpQ3ZOYmdOak5RMDgzWW0x?=
 =?utf-8?B?blM4cGd6M3pIL0ZxWHpXOGNmWkRQaUw5S0tEWjRGSmFac2RLY2pBRWIxSVZo?=
 =?utf-8?B?SGZsZ2s0Q3JQWXFxMGx6amZWaEtNT3VHZ2NCWUxYaitiRGxjWmpJaDdEY3RM?=
 =?utf-8?B?OWEzYTQyQzc5YkRFOEdpWmdWYmlieTdnaHdMVDZCbll1Yk9yUW5ZUEhuZHNX?=
 =?utf-8?B?eW5EdUNzbFh5bUE2WU1DTjRXQkNhZ3BnOTlOOWlKUytIb0t5V1ljeEIrMTFk?=
 =?utf-8?B?MVFnTmo2KzB4OEcyNmZxRkVPM2lwY3dmRXlBdlZGcUhMRzhvSVpTbXJJVjhu?=
 =?utf-8?B?ZDg1U0lvc0U4MlRDWUZOR0FOT1NNZlVmVWQ3aURQQkkxUXc5UTRXUHRJb3J5?=
 =?utf-8?B?MU5mcThvaG5NdWxWdWJBeHkxR1NKWnkzK2FEMHNReWdhRmp5VkN1a0VwRlBr?=
 =?utf-8?B?NVVMbUxRVlR1cy9yTzgrQ2FFZ1RTY3I5clkrdTVDSUR1M0JYSXdncUMrODlt?=
 =?utf-8?B?WmJpdG5peXV4VU5JVk9ld2poN2kvaUFwWk9RM0VZT29WU3k1VGdJVDkvVzc1?=
 =?utf-8?B?dm0vdDVmTVRYVWhscTVBMXlDN0g3UEtxY3RHbTROVE01akpOcUd3SUxzRzl1?=
 =?utf-8?B?RmxCOFk4akQxb2J3MHZHM0drQjN1cjFGeDRXQVROeWJ4NWNVRG1GcitpVTlP?=
 =?utf-8?B?M0NER0FPYkp6ZjNISWhMdnh5N2lBK3UwZmxnVVJOMmNsRVFSdFc2V0JzTnQ5?=
 =?utf-8?B?NllFNlRhSDFtdnZKVTNET0NLaXVlSHhTTW4wcDFwOUJTZjBtbzdQU0xOTTR5?=
 =?utf-8?B?RWlncFlEeHVrYUcyS1orV1lhdEVNU1E4Q3o4ZXdoQ2dITTBkVUhkZWM4TlRE?=
 =?utf-8?Q?IpvG50?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFREdE90bU1qa1dGVTZSak1RWVZpTGF5bGxRdlVrL0tKckdNcUxNRG9jQWds?=
 =?utf-8?B?SWwyMTN6SElrbC93LzJTZHVNaXJ3cnp0RGVqbUpMUFlUaTkvbUs4dG5hbldw?=
 =?utf-8?B?YVdtWkMzWjVYdlljUmg4ZitSUjZWYWNOWWYvN2QvNnQ5THlxdVU1cHFQbGNB?=
 =?utf-8?B?clNoUU1iKzNtandXbzB4b3Iza3BhTm9aSUhYa1pUU2lGVEF2bzYyKzN2aDdn?=
 =?utf-8?B?RTB3RDlrSWVQN0lEZG9TNjhwU2h5RU1xMTkybXNZZnBZOEdRL1d6MmVRWDBV?=
 =?utf-8?B?V0NkdysyeDlPcDIvTDdtVExzcVM2VG9xaWVyL3lDS3F0d0JLWjRKYXk5OXFO?=
 =?utf-8?B?c3ZVN2M1cUtubHB2TlRSeDdhY2tiSWRBSlJVd0M2UVpJcWltVXZYWHpOVVlN?=
 =?utf-8?B?aFhtemFGeDBWYUd1SFVrUE9RQmlKQXh4UmJDTE1CbnUxaVN4d1poN2dvZ0JD?=
 =?utf-8?B?aURacHdER3FqM0UzYm1QZVhDZ1dvbVNRaGN0YVBVcTg5N2o2VWt3VUtkcmFD?=
 =?utf-8?B?bGhYVjk3MnI3azZCNnBqUlRGdlViVEJtM005aCt2Tml2VDEzM0JaQk5ZOENo?=
 =?utf-8?B?SzN1ay9DRFhvMklOeGdNZHNsN1NINkJNK0pXdjZMOGE2UlIvR2llbE5nbDJ2?=
 =?utf-8?B?OTdtYi95L3loOXhTdlBKNW96dk1hWkxQWHd4VnVsWlMxVUVWcTJUcGlsOUZW?=
 =?utf-8?B?cFp4eXFBVTY4Z3RvRFB6MWZDdkpmSEc2VmQzWTBHSTBhY2NWOGxYZkhoVzE0?=
 =?utf-8?B?QkdodTlWYkdFdEpObWs4VjFPWFEvMXBYc3cxcjBsVzVkSU83aDJib0dSdyt1?=
 =?utf-8?B?Uzc4WGpaOVowa3cvazFRdEhESlJCdXRkMVMvRU53dmV3Y3NOR0dXZHc0TDMw?=
 =?utf-8?B?eGpmWDZSVGMvay9qQ2xEd0JJY2ozU0JlQTJJN3NmTmxrdUZxMk5XVHdOMTJY?=
 =?utf-8?B?aUxJMXFCTDV4VzUzSzBGeU9iZldoTm5nb1RrVUlwMFU2MzUwWVZsRmRSTS9F?=
 =?utf-8?B?S1VZQjBlOTM3cFBWWGNydkdPMlJJb2FjclZ6LzNSdFNacDNaUGNzWnNwMis1?=
 =?utf-8?B?VFBOMXBBSmRhcTMzZUxIMHk5YjFIak9HUC81c3lMNFRmWmhxRHRCWmlNT3kz?=
 =?utf-8?B?c2RXWjBncTN2S28vYmFVMmlSSGs5ZzlPU0krK1I3QnpFckFPVHFDcU1ybW41?=
 =?utf-8?B?VDZ5L0V4LzcxQlJYaVFIUkFSWStCQkJKK3FyRG0rdnNhcHpOTVlsZXNUbW1B?=
 =?utf-8?B?b1NoRm5qbVBzMXgzNjBGZll6b2RtM1dLa3p1NVlNUThsY3M4eEFlMnBIdm1R?=
 =?utf-8?B?U2c0ZVMxcnVNWE9pWEp5VEVIL2hBQ1VQK1oybXVMY1RsbXJiTVRDTWFDam16?=
 =?utf-8?B?RGVYWVFUejBXK2dzT0JEbDQ5cHR3ZDh4V2VmeSs1UnEzZk9IdTlPY2ljYms5?=
 =?utf-8?B?TUxmVStKWlVTSnFmRVh1YVhwVk9yUTA2WlR1cUwySFQ5NDkyVDI2NkNFdTQ0?=
 =?utf-8?B?Z2NCYVpLbnhxaVRVZUM2aVVLOHpub25Hc1dZQjk3cWpwd3BHU3RCMWFUN1li?=
 =?utf-8?B?R1k4aVFaR0hDNGJsOXNOLzlvaUYwV01SK3pJUnI3Tk45eDEzRzdvZkcvSnU0?=
 =?utf-8?B?OWs5VkZWNkpUaGM2a1FJd3cwT2ljRENURkEva0g5UENDL3NES1ROeTJkK29r?=
 =?utf-8?B?NEI5NFVwNFVZeEcwbkM0d0xTTm1vSmY3dllwNzc1T1J1TklTd3c3RU81c0xR?=
 =?utf-8?B?RlFtNk0rRVl4dUVSOWN5TjlmOUNaMG5IeGw1SjBhVm5uMnErV2FJVUpuUUlj?=
 =?utf-8?B?UzhJcnVSbUJGOEJKeTRRQW4rVkVWL3NCWkkrVnJZMW80T2c2SkJxUlk3SUFt?=
 =?utf-8?B?Qk1HbC9Oekt5cDFKTEcwVHU5WnBmZGpsOTlqR1VEeHpoWk1HcncvYjI5QmM4?=
 =?utf-8?B?dm9YUVp5NnN5dTJPMUhoaTlYeVdNT2RYcDU0TDNuU1JVRHdhbWh1VWNxVVpH?=
 =?utf-8?B?ejZseDg5ck9qNEt3bGQxMlVlbW9Dd3daSjlsTEF1U2pzRkVsT25EUWRlWnhK?=
 =?utf-8?B?anZLbzl3a2xjeVpndUd3cjVMa3g1K1gzWUo2ZWg4bXVhbWlPL1FKV2VJdTcr?=
 =?utf-8?B?WFhvU0xIYThmOXJsRlp6QzYwOElOR2J6dnY1NmhrYXZpbjY5VXJ0cS95Nk9P?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <60B96C2B6BAAEC4DBB0C1EA4EAA8DB31@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ac02507-8128-4ef4-e6f1-08de2d3f402b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 22:58:01.5834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7znxNicyX9w3Leaw1y5Xu3B/zhwLJF3yLgSloisruoq37mzus+byBQ8rKNFeyh5K0EJY2lEvQrUeIZqcVyMIiwiJoNQNjeWydpDpJxDZvV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7081
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTExLTI2IGF0IDE2OjUzICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
QWRkIHRkeF9wYW10X3B1dCgpIGZvciBtZW1vcnkgdGhhdCBjb21lcyBmcm9tIGd1ZXN0X21lbWZk
IGFuZCB1c2UNCj4gPiB0ZHhfZnJlZV9wYWdlKCkgZm9yIHRoZSByZXN0Lg0KPiANCj4gRXh0ZXJu
YWwgcGFnZSB0YWJsZSBwYWdlcyBhcmUgbm90IGZyb20gZ3Vlc3RfbWVtZmQswqAgYnV0IHRkeF9w
YW10X3B1dCgpIGlzDQo+IHVzZWQgaW4gdGR4X3NlcHRfZnJlZV9wcml2YXRlX3NwdCgpIGZvciB0
aGVtLg0KDQpSaWdodCwgdGhpcyBjb3VsZCBiZSAiLi4uZm9yIHBhZ2VzIHRoYXQgYXJlIHBhc3Nl
ZCBmcm9tIG91dHNpZGUgb2YgVERYIGNvZGUuLi4NCg0K

