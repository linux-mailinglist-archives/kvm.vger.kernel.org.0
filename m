Return-Path: <kvm+bounces-52749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8533DB09082
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:25:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1019E4A49E0
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 15:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AEF62F85F7;
	Thu, 17 Jul 2025 15:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mwl1B/fr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250421E520A;
	Thu, 17 Jul 2025 15:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752765903; cv=fail; b=BATbMXdHQ7IMV1n8llnDXC3TfdpbER4JWxJPnT/7MtrSa/nVbzvSnPCXxG2XBKfOY0DJaiG4IwMLoHUtxO9ez0eU8E+2Z8WWgmZy2lJYRrRP3kEn6aL7Cgv5Bb7eKnCmLlT0v14Mfg3gyGzlit6UBi3TAdv+ghc/xIGMrqM7pKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752765903; c=relaxed/simple;
	bh=4J5iwOcqngs96xRXa0eXu5wyOVrr5ZeZZqDKOf2oc7U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jEZEGBlP6M0SHG93Y8vJnDl0yh5Su3CW3MN3yQ/FkgnQiN77odFQpBAsC4g6uAja43T1Lp411OORavANRZO8/qcg4vL72wR4UgVzdli8eTDhl/bD1hMsTjWwFhIoo1dn0BtkBFRbJU2SMqw1xEoN+fu9Eo6CrNUGRfH2uxEQWxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mwl1B/fr; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752765900; x=1784301900;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4J5iwOcqngs96xRXa0eXu5wyOVrr5ZeZZqDKOf2oc7U=;
  b=Mwl1B/frBWe/r3YYoMDi8VkrNf3hf57r0kiye5VfAHi/Ci0x87r8WqIL
   7FRVsXIrrc0qiglCh77Uz/AYqeyYBpfHGEDjsv1217xr717gx+ptUXoqf
   N9paNChkp7hQEV1stVf1cHM9bPsorHQy705QFuMNbkdvFcL/+Zpkq6s1q
   uU4b+SKVD2foudiW8UIaj4Hu6qV9kNMsQ3+QaiLMhrfLe02p22dPxQPus
   PqR0voyPbPHe9ppJjv6DaIq7IXY6VS8F/k5+9SB3AVu2VxkM5ZPsV1uka
   /Fk5u84XLJ465G+3mfprWt8eH7So0TSb4KKCX0vRi6feA+WUSY0qMF54G
   g==;
X-CSE-ConnectionGUID: hmlQizPWRVOaw3Js5OPk4g==
X-CSE-MsgGUID: MVqm/AwwSeu74z7ReW40zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="66396158"
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="66396158"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 08:24:59 -0700
X-CSE-ConnectionGUID: tK10dwkTRXuYvH+tfwvHIw==
X-CSE-MsgGUID: U2p82HQWROeUmyXxQZQ2tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="163456968"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 08:24:59 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 17 Jul 2025 08:24:58 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 17 Jul 2025 08:24:58 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.77)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 17 Jul 2025 08:24:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h93jzv74IDDm9IG14voxLFVHUdT58/3pSU9jvSS7AyA+yX4RR4wrZdYiFEfNyAHhn2ef8OtPB7N1VQzTG9DuNrlOZfTWTBpMZ7a2SXLIhe2xPHUl6GlU0idepNBt2Ggd2IOQPwPj9foTsU5B7sMuCnILraWFM5T0yeu8L0Ktxiqzd2NuxuoROYV2uyqbJJttJTQjbMh2HEwGd/jxDNBiz7cGOL9Fj0OBFbyH3oRBGA8U3VCfVDPyWWiHmz7fJ7S9kyUS8mU367EHiVCciEmGcFZclPa5Au2itcP6xM8SKrVtDkHV7iXY0Mo0cSdQdzY7xeQV67idz+qcfYdn6L34gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4J5iwOcqngs96xRXa0eXu5wyOVrr5ZeZZqDKOf2oc7U=;
 b=oIPFkgY133cIiFxSn8HQjRWX7ZFBxL4qIQbQAbHppcCdlDvjN+/A25/KsjRfvgAE9oLYGtp0KZUSEjc7Xwq1rMcWzDMZthyyiayoEtbUoR9LWSUnlE8iGayG/VvXM0QTDT5nrjWkRfKP4gzLEBXSylEMaykaVKGUpkDhUmEy8gJyoDLgMWqYIsB0uCpusfEzSVtTXp0IJufE9xKnDQSFmnhbwVzNp619rUcxHfKcPIndkXOGjT15UkZ8U8Q7l0FAczBBL0U1qd0afKut89qChr+nUDSln+q3O6XmruYYtrvi8K1pSyVbwP6C5mqAH/D/iQHAU7zKsIt4FGXpZDPpag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL4PR11MB8847.namprd11.prod.outlook.com (2603:10b6:208:5a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Thu, 17 Jul
 2025 15:24:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.033; Thu, 17 Jul 2025
 15:24:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: TDX: Don't report base TDVMCALLs
Thread-Topic: [PATCH] KVM: TDX: Don't report base TDVMCALLs
Thread-Index: AQHb9sKByqqjDtj+ZE+LGBnYk1ljH7Q2Pk0AgAAx5oA=
Date: Thu, 17 Jul 2025 15:24:18 +0000
Message-ID: <3d62aeb993d9a81a64985a8354b87ffedd35514e.camel@intel.com>
References: <20250717022010.677645-1-xiaoyao.li@intel.com>
	 <CAGtprH_fNofCjJH1hWKoPwd-wT7QmyXvS7d9xpRNYxBznNUY+w@mail.gmail.com>
In-Reply-To: <CAGtprH_fNofCjJH1hWKoPwd-wT7QmyXvS7d9xpRNYxBznNUY+w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL4PR11MB8847:EE_
x-ms-office365-filtering-correlation-id: d51b0fe3-7348-4ff5-c35d-08ddc545ffde
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RG9uZ3lxV1lNeXloTCs3S1VTcHM4VWNyK1dwRGZ2OUp6RExNWTBmVDhLQThO?=
 =?utf-8?B?bFJZdmY3bHRYdXlFNUpvQjV1ekhCUGg5dnZUQ2kyNUJRdHM5VHNSV0FIbmJo?=
 =?utf-8?B?elJyWllIY2dLaVZ4bFgrSG8wbkQ1SFdvcm92RnNIWUVkek9Yb2FFUkhqTThz?=
 =?utf-8?B?Q2dxMko0YXkrNGE0ckxpQkxxNlJ0bmJScnJBRWY0U1BDL1IzbWRJTnZzMVFx?=
 =?utf-8?B?MzdzRVJKYXZnZmxCbFZBSGNESUpoSy9sYTM5aTJ6RjV3WVN6RUlpTUQwaTFn?=
 =?utf-8?B?OGJaSUdCUDF0SmJzU1plQSt1b2p6M3o0dndPT2tFRmY4NnE4aERFclJndlkr?=
 =?utf-8?B?VFNZVXp3eW9xTk5lS3l0MTErZ0RiWDdVZ2tGUTFXRGJTYTZRVEp3eGo5cWVQ?=
 =?utf-8?B?aXZmL1F0THRXZUtGV200WWhQNWh1aVNuMWRBMTdlZy8vSnl4dVBsRDhocjcz?=
 =?utf-8?B?UGF1UFh1TEtoOXVxRVRDb1ljSVZmTlJYTk5UWTdxMDcxZXhCSHFPazJvOXBS?=
 =?utf-8?B?NXc2Q0k0dVR3SStuRDloL3lTbk5ub2pjRGpGYWVoNE5kZ1M4WldEdjgvQjEr?=
 =?utf-8?B?QUhKRW9YemxEdngxVFZDeEs2V3lTQ2FPalBNelM5Q2lueUhldnNMdkNSNmZJ?=
 =?utf-8?B?aUd0YTN1NTlKRVlwRjN3TXVxTTRlRUoxYjg2OGNaQW1NTEg4K0k4KzJMWkMv?=
 =?utf-8?B?R3AveGJXdW1VM294bTJEQ1lrL2lxQzlJbnNXak1YYkhtSkJsRWJRUGhRL1ZI?=
 =?utf-8?B?MmpmdlFVRG5UUXB6MGk2Ync0MFA2NTdSbXBUOXRDWjZId0ZEL2puK2VVU1RH?=
 =?utf-8?B?enBuK1VPUTlRVmVwRXN0ejlVOFNnVzdwUzhCNWt2NHBtU0dwZTN5b0haelE0?=
 =?utf-8?B?TTJCTk1CdkZnTGJrOVZkVEtnRWx2d1FKR2ZIc29NU1Z1a3ZhWTBpa2RzZThx?=
 =?utf-8?B?TUtGNHBad2MvNjBoeVp6TkVPS1IzQ0htOUlpaVhDVC95MGZVZ1RFQkYxQWJo?=
 =?utf-8?B?TkFvOU9KT3JIZzJCVnd1WTBZKzFkWTNncWpDd1pUVUhaU1FLTmtoeHV4UHpR?=
 =?utf-8?B?Q0Q1MGtqV1ZuQlRXb2FuWGhVekJQNUJBSWdPSzFvMWdoZXVHQjUzQXNjYVJ1?=
 =?utf-8?B?V3ZuM2t3RFVvSlBFbDJ6NVg3aVh0bnM2dVJlVGpGUy9Iem5aMjcyZlNBUWcr?=
 =?utf-8?B?STlnVk9RTXRadHpESW9JTiswZDB5d3pGdzYrc1lveE9XZXFUaEc3K2R3ZW1P?=
 =?utf-8?B?YXhLR012ODJpQmd3ZTRFZGV0N1hMK1FuSkN0SE5EQ0h0c3VMM2E4Q0tKTnlp?=
 =?utf-8?B?UC8xM2tuQXlHaW5LTEpSTGFFaS93WjJNZmRVeGdFdDdKb28ySEE3QWQ3bXZ0?=
 =?utf-8?B?YmZ2T2t4bFBYb1RicjJmVkRtdXBaUE1QSUhpTUZTdDREWFVUWk5jVmVxaHBi?=
 =?utf-8?B?eU44TFI5NVBPS1RaU25ONXdRTDNMRTZ1U2NzclJxUkZWNFZpMWdMRmFRelY0?=
 =?utf-8?B?ZzlsZU83N1poSndwQnlnTUxlT3JVNi9GbXBpYXN6a2hnYlZKVWFKTjhRTHZQ?=
 =?utf-8?B?WTJ6azRsWDNmOGFCVzJwT1BENmZTWFcraFBNdXh2U2dGUUFTVnJzU3NKWXRF?=
 =?utf-8?B?M2dkdE5zMStROWs0Szd1T1dmeG1abjBJMVdrbkgzNDdpTG8rckFsNnhET3pH?=
 =?utf-8?B?N1FxLzRMNFoyTExhTnN5KzVoRHpTZWNuNzRmNmljZWZKUXFUeWcxbVliMjY5?=
 =?utf-8?B?Z3RIUlVvdFE4ZjdOZlFvbnlja29oT0RJaFZjVmFSMGR5VmZLSEV5ZDdyZjNr?=
 =?utf-8?B?OWIvWlJlSkRWZU1ma0JBbkZDem96T1VFdVJOWGJPenpTVkd5WFJvVjZ0Y1lh?=
 =?utf-8?B?OGhEZ1RkQVVtakhVVURRQzJQMVZsdUhNWEE3WG15WW1wS3l5bkJsNDRVNC8w?=
 =?utf-8?B?UHhzTjBGaW8rSm45QVdpZjFuM3hsSURSWUFvc0V5R2diSnQrTktFaDREWTlM?=
 =?utf-8?Q?mRQJ03AxoWNb9Asg0AKx1biy3SAnWs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ci93YUZnMnZTNXFQY21QbklyejZyaHdoUktOeGdoTk4xMmtybWRCUkhEMDJE?=
 =?utf-8?B?em1QcDFZYlNEeFFYd2xhL1RVbUh1c0VIT1JmMWNqWFBiSTlESWxhNmVyMUZ6?=
 =?utf-8?B?RlNZdmlIK0NPSFU4cnhad3JCL04xcDZ4U0xtVkgrZFZhcllFWVIybWFVNGZm?=
 =?utf-8?B?QU5oSXJ4a21HM0VjVGU3Z2RZYUJrRDJ6aHRVeXdVWTk1eW5NVmxNN25UMnhV?=
 =?utf-8?B?dUFaZzJ4WjlNUDFHM2cwSTBpSGFVWTV5R2NSRDkrSjRLeUdnejVEeUo3MWp3?=
 =?utf-8?B?bmFBN2RGeG5BdjRQVVd5bkFUR1lMSUJuSm0zV2ZuRzl2UmhEVk9nTThiTW0w?=
 =?utf-8?B?dFNzK3NXcWU0REpGdUFjbjM3ekJVM3NiUzNIQ1lMM1hRK001NDNoWEg0Tnl3?=
 =?utf-8?B?MUs0ZHowZUZaZklOTFRNalY3RUh6dW5sV0xFUTR5b2dQNHp0M1NGaUNudWxY?=
 =?utf-8?B?NG1wbEZsQ0EzSEY0SnErSTRMWnBQb3dQcEhxaG8rNXpPRlZuVjR4S2Vvak1M?=
 =?utf-8?B?bjZjK0xoLytiL3c1YkdGVEZySFkvdlkzd0NZMEZzNjhmQktoZUVjTnZpdy91?=
 =?utf-8?B?YW0yYnpnUGtTU3o4MGIzZjE5SGdPL2wrT0Jnb09oYk9GUSs5ZU9WWnZTSWZy?=
 =?utf-8?B?cGxOaGluNVlONC9WRTk3TDBOOWVQZ1VORkdubHhhSWVWMkJlQ1B6c0pWcTlG?=
 =?utf-8?B?OVZ4aXFYNTIzcWNMcTQ4YndaeGNtcUtyanVYenBZRWVsVUliN2pHcjBCZy90?=
 =?utf-8?B?bmplM2FYLzZ1SGFaTEJJVXpMQXBXNnYrTEh2QXdjb1BCYVBPTEp6SjkrWTF2?=
 =?utf-8?B?WVlEU2lNR2Q1R3R3WktGRDZCazFiSGFXRmFIQzJjbEswRkxsamhWQkFJcVh2?=
 =?utf-8?B?S0hmaTh0T3pMZlBYdHUzV2pSSElOc3E0SjFodmYxQk54NTNyV0Fpc21xbFZO?=
 =?utf-8?B?d1F5T0dLdTJ0WU94RmJPQ3F4VStpaHVTM3pGNHA3R0J0NnBUVTRWTldKNzhQ?=
 =?utf-8?B?NWEzWVZ2NkU4clhodW1pUDJLVGFEdUZibi9pSnRFUlg2S3VMTnkxUTltV0lP?=
 =?utf-8?B?bGpyYlNqMnVOaFlMcTBrSVo5eFpSamJpekJxcStXRldOd3VpajcwSlAxWjZ2?=
 =?utf-8?B?aUlhU21laDk0Q2ZuZ04yeUUwY2hFVURwRkViM0licGYrUklCdXQyMHp2SWtq?=
 =?utf-8?B?Wi9LUkkzZVdYL1o1VlRQSjNxWGxMQmdUVWpNV1hwMzFieHRUSFpQMFl2SlJz?=
 =?utf-8?B?UzZveXl6YlBEVEttYzQ5VTVla1FuUUs0RE1wV3MzUERlOEpEQ2ZDWkZLMWpN?=
 =?utf-8?B?dmQ3WlJHRlFEV09hNUY5Q3M2czJaL3FzY0h6bGxrN0Q3L0xBcXN5WnQvRmkr?=
 =?utf-8?B?dXA1ekF2MUtiQ09mb1RjYVpnNlpRMXI5UVFpdk9xNlB6UThwalBOSTBJSnRH?=
 =?utf-8?B?bHF0YmNLaFZ6VGlxRE9pSytvVXhPMjR4SVh0NXZ3eURabCtDSzNCV1cwUm5H?=
 =?utf-8?B?YXdnNGZldUl6TTJ6ZktOeGd2STliUCs4Q2pXcUkrbkNnRThnTDNCOG1lbGhu?=
 =?utf-8?B?V3I4T2lTaXByTEpma1lkcEJOZDJYMEtwZTRzUmtQNTVpN3lLUHlpTVJoM2Vx?=
 =?utf-8?B?UFhWU1JpYUxtNXZOYzcyZlFUZFlmYlhwSXZnQy9ESFd6K3NCbXhlbmtXVklw?=
 =?utf-8?B?RnB6bTFLclNlN3dncWFndWVyWDMyU3JQY2R0ZjNSUk04RWdHa0V0ekNTVzZD?=
 =?utf-8?B?N1cyZmVURlV3T0dZVmY2aUlBRS9xMGxUVVNMU1h2bTkxbCt1KzZBam51WUhE?=
 =?utf-8?B?UWhSeEgvSnNjNFVETEFtZ3FHK3A1L2FURlprQWZBUjhTRHpSellXVmt6Zi9u?=
 =?utf-8?B?eXh4Q3E5WjAxMStIdWxCbFg3elJ1b1VTMGJHOGNzUlZMWUx3RTRhbjVNVjlN?=
 =?utf-8?B?R1loTUVsUVhRZEhOODhHb09MMTdRVHRIVnRVRU83NHFMa1ZRRHAxTlNWNEFp?=
 =?utf-8?B?L2xqdmZ1aGlVdXJBU1VnWGUyaWZ4eEZIVHd3cE9teDF1aEpucWovaXJtTlpO?=
 =?utf-8?B?cjFVd3hXU29sbFo5djN0cUR6NlJ3b2RDbVY1VERobzVhN04xb1kwRmtUMUhU?=
 =?utf-8?B?TmhJM2loMUJOK3lJNExMZmVkMnBmdmVhZ1RjaDJiOTVJUWFnaEVMMW9nb0hy?=
 =?utf-8?B?TGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F78CF0DC7E0EE04BBF6E21C2E27DD8B1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d51b0fe3-7348-4ff5-c35d-08ddc545ffde
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2025 15:24:19.1867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g5ZdiKLMG9L4SWRNRAvMbP9xbtMOycaqiLNqyN84LvKe5UBVdsHGg0YxCMndWvCMeenKJJzSAtADPwVp7pRS+HCdfd5IxcqsYWjcy6VeoI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8847
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA3LTE3IGF0IDA1OjI1IC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiBPbiBXZWQsIEp1bCAxNiwgMjAyNSBhdCA3OjI44oCvUE0gWGlhb3lhbyBMaSA8eGlhb3lh
by5saUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14
L3RkeC5jIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiA+IGluZGV4IGYzMWNjZGViOTA1Yi4u
ZWExMjYxY2E4MDVmIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4g
PiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ID4gQEAgLTE3Myw3ICsxNzMsNiBAQCBz
dGF0aWMgdm9pZCB0ZF9pbml0X2NwdWlkX2VudHJ5MihzdHJ1Y3Qga3ZtX2NwdWlkX2VudHJ5MiAq
ZW50cnksIHVuc2lnbmVkIGNoYXIgaQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqAgdGR4X2NsZWFyX3Vu
c3VwcG9ydGVkX2NwdWlkKGVudHJ5KTsNCj4gPiDCoCB9DQo+ID4gDQo+ID4gLSNkZWZpbmUgVERW
TUNBTExJTkZPX0dFVF9RVU9URcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBCSVQoMCkNCj4gPiDCoCAjZGVmaW5lIFREVk1DQUxMSU5GT19TRVRVUF9FVkVO
VF9OT1RJRllfSU5URVJSVVBUwqDCoMKgwqDCoCBCSVQoMSkNCj4gDQo+IEkgYW0gc3RydWdnbGlu
ZyB0byBmaW5kIHRoZSBwYXRjaCB0aGF0IGFkZHMgc3VwcG9ydCBmb3INCj4gVERWTUNBTExJTkZP
X1NFVFVQX0VWRU5UX05PVElGWV9JTlRFUlJVUFQuIENhbiB5b3UgaGVscCBwb2ludCBvdXQgdGhl
DQo+IHNlcmllcyB0aGF0IGFkZHMgdGhpcyBzdXBwb3J0Pw0KDQpUaGlzIHdhcyB0aGUgbGFzdCB2
ZXJzaW9uIG9mIHRoZSBzZXJpZXMgcG9zdGVkOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3Zt
LzIwMjUwNjE5MTgwMTU5LjE4NzM1OC0xLXBib256aW5pQHJlZGhhdC5jb20vI3QNCg0KQnV0IGl0
IGRpZG4ndCBoYXZlIHRob3NlIGNoYW5nZXMuIFRoZXkgZ290IGFkZGVkIGJlZm9yZSBpdCB3YXMg
c2VudCB1cHN0cmVhbS4NClBvc3NpYmx5IGluIHJlc3BvbnNlIHRvIHRoaXMgZGlzY3Vzc2lvbiwg
YnV0IEknbSBub3Qgc3VyZToNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS9lNmZlZGY0MTE4
MGE5ODA2OGMwYjQxMGI2MjhmMTRjYjg1Y2FkOTNmLmNhbWVsQGludGVsLmNvbS8NCg==

