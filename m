Return-Path: <kvm+bounces-42520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60A53A79807
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 00:01:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E2823B1F43
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 22:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5292F1EA7F0;
	Wed,  2 Apr 2025 22:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cgqDF3RU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87ED61E8326;
	Wed,  2 Apr 2025 22:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743631251; cv=fail; b=RYn53xx6gfR0TMWzWiBvGHPXFLiCEXShQe5PYDYEDaYjUPLgdPpt6cISWXTeRTRcnW6asSaVc6gQRJ0XhTIae4uqYYhWUKs7FCPf4n1SDxCdjo8hY8MAHPcGmjyxt03K82SiME0nq9/Lr17ZFtMjGfivqpA172Rnbl+ynhU4OQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743631251; c=relaxed/simple;
	bh=ICArPgojkwKyFTr9j3v3ZG2gtLCtEtPv4xoHAGFHfKs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r1r+qxsBkBSyTFbtdjr6TlHQIt5sC7w8ik6omHU2p6hb093FE7YhOWb2m4CcWVMzo7II3pKoTSl2QXiOXnBaKwovfhvUrhgPrPnIoJlgLEoovgzjkXjVnjQIl3zC9BLy+4Ok6XeYcJscoQEaba7hM62nFOQ7dSYwGpzkQmlCHaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cgqDF3RU; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743631250; x=1775167250;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ICArPgojkwKyFTr9j3v3ZG2gtLCtEtPv4xoHAGFHfKs=;
  b=cgqDF3RUY+I0CIDW5HTdf2IdxD/CV9maOiN5sPkTazoTrNmj4mEgI28J
   B2SuthhhWPtmzxfrGZMhk2YynwWm/hafxHQ46nVn6xi6Dnw3ZSP+dy5Nr
   oRKJoxJRhC+G2EiYjARD+qL2x1Z4qtCn2yXRGHKmdSfXjBj6MiL75QtOY
   /CyNFMP+ZcQZeMsCGruOAYdpBtsI5h5Og30bSJC947Alrd+QOa53JdEpV
   7XTFHWvWUlO7/ndBBt/9p8lIkINznhtEBWxTYKwFUkmGZl2CyiQ2uLhx1
   yWEfUCGPgP2MvaXtL80jk2gk5ciZ9O9AZ8+pfOwQaGoW9TQtoCox2rVpL
   A==;
X-CSE-ConnectionGUID: S2Xx0sHlSb6JdZsPHwG+TQ==
X-CSE-MsgGUID: FAhFpkENS4qfD9hsYIrThg==
X-IronPort-AV: E=McAfee;i="6700,10204,11392"; a="32626470"
X-IronPort-AV: E=Sophos;i="6.15,183,1739865600"; 
   d="scan'208";a="32626470"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 15:00:49 -0700
X-CSE-ConnectionGUID: kkvAyYWpR8WBE3L+lhTG4A==
X-CSE-MsgGUID: 3veNZIGsSrq4qW+A5BgQNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,183,1739865600"; 
   d="scan'208";a="127339292"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 15:00:49 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 2 Apr 2025 15:00:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 2 Apr 2025 15:00:48 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 2 Apr 2025 15:00:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XuY5ygpWZlBuKUYCtRIt+xZBzDqaTn2gHB3QHzj8DQdikO34KZXSczGVTGoZD6B4fOrTVjRk2iZFTh+B3bZlVIecFOaSaGc4IDmjaaUJVWdhEXTbn18a273tYo+w5QhxtP3HOB0im/zVAJXSVajUG0VzHvQnvP7/nYjz/1IuTJ0xiItkXCGnFyPB2KkRsWIyslzg2cFDVj2rc8enVRoOXYxKlVBf4365EP34OqfNrzJJVtn+eAPaqT3O4qF/sEdjII7JaHpDmAR2/a3A9W+agt8bVHYmkdXtxmrXGxHwxAeVyGki4Bx25QqPXy+h5oeiAQ7bvqqVDYEdzE/XqU67yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ICArPgojkwKyFTr9j3v3ZG2gtLCtEtPv4xoHAGFHfKs=;
 b=SyeQHv5719Z4i21TG61SZk4xEypPzbiFN0gOmKCDvSsbh2SqRzqCMiQoWdL2XQc+xfJ3i+aTTBsMGIHAUPVPPme7oXHMpCalOXtLbziMPp4fOud2PknGjKOhMR49oGs6AObhkrGd/lrhOY+5g4ZaR0wGoilgP9a3rXexZ+VS9sEcRnAb/kr3jEsqrYhYJkWG5b9WCQgmWcu6PaVfhUMrMfLkGoybyuoaui+CYbgTfnKLXgxXu1r3XgwGayzm+oaw5MW3hX+vd9JFeHMnl1ou/3vwt0ka5V5vovZgSDpf+6lwI/0JeFdMywClv38t7HTRDN1nypMCKcw/NzVCIdjydg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6013.namprd11.prod.outlook.com (2603:10b6:8:70::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 2 Apr
 2025 22:00:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8534.045; Wed, 2 Apr 2025
 22:00:15 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "Gao, Chao" <chao.gao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Lindgren, Tony" <tony.lindgren@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Topic: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Index: AQHbo2Q+reE/k3eiXkm8HRe31hfG0LOPjGSAgADJMACAAJjZgA==
Date: Wed, 2 Apr 2025 22:00:15 +0000
Message-ID: <45674f2bb8c7bb09f0f3a29d7c4fb9bdc14b22d7.camel@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
	 <20250402001557.173586-2-binbin.wu@linux.intel.com>
	 <40f3dcc964bfb5d922cf09ddf080d53c97d82273.camel@intel.com>
	 <112c4cdb-4757-4625-ad18-9402340cd47e@linux.intel.com>
In-Reply-To: <112c4cdb-4757-4625-ad18-9402340cd47e@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6013:EE_
x-ms-office365-filtering-correlation-id: 16f889bd-55d9-4864-ff3d-08dd7231bfab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?T2NYNTdncmxBVGZiRjVsc0FpNjZ4eUVPcitaOFVPYmgxZDhiVXJxaXpuS0c4?=
 =?utf-8?B?KzFXSXdDNmsrb0UvdzN3MEY1anFVOVZOZFZtQkl0bk0ySUU0cFh0K2JpRW9T?=
 =?utf-8?B?TDRiSGNtSlJGMStZREVFUXl5RmFNZ2Rna25BblFRL0F6SGcwdk16bXNKbGhS?=
 =?utf-8?B?eFFQVHA5OUl0MFNBWnhaME44V3lnUWdIUnEvZlZ5MUs3WHkvV2dMRmtFNEs2?=
 =?utf-8?B?OVJuWUF1NjU4ZGhWaE54ejBCVnhGQUtwMmF6TnBUb1lKZGtqbHFOelZybzI1?=
 =?utf-8?B?eWJOYnkyZVk4OVRrTUVZRm5UZDk3bnMzTVBuSE8rclIzNlZKczlvRlFIejBa?=
 =?utf-8?B?YWNVVW9JT1RuTnRPUG9EMmEwRVNJZHlySDhpdXIyZ0gyWGlSN21vTTdrUGV5?=
 =?utf-8?B?eWhjTnZmcndYQWIzLzhBKzVVbFhQd2czL2g0bEtHYmJwakpsM2hKNlV6aDE0?=
 =?utf-8?B?MnJWbmkrSUdpNlBudUtZb3hZUkpFU2RjL0tFZVRSR2RLWE5QVXd6WnMvTExQ?=
 =?utf-8?B?dVRNSVhvak83NFdqZ3FYcDAySXdwNnVmaEpzcjJLTGtIcHZqcDRiWitDMkFH?=
 =?utf-8?B?OVhva2c5ODd6cUlGb3gyY0pHbG1acmZlUXdoR0J2TG5wemYxZEp4aGRHZm1E?=
 =?utf-8?B?NFI3RTg0cWY5V2tjNTQvL3NTY1N0YXM2TjFVdTJhY3kxQXUxS0dsYkl6Ymc0?=
 =?utf-8?B?N1ZwUks4VHpaK05aRU54czV3bk5aNTJGR2daZlFqcjdZMWVWQ0RKUmdCOG1E?=
 =?utf-8?B?YmNMK21SajZIcDN0NDNzWUZHNDJZZHY1ZGRSLzVSUUhGQ3YxdVZsWldwNzZh?=
 =?utf-8?B?REpoY2psK0sxQXQwQlBVY2hMQitLQzl2R3FUUUxDL3YvSWk2SXUvSWcwcUJJ?=
 =?utf-8?B?TktTOG8rcVAycUlxZVh4cCtUdWlmMjZNN2xWazdkWDJJSWdwZUFNemtueUJX?=
 =?utf-8?B?bTJiZjdtc0VIbTl3QzlCcEZHOHplZytheVZIRm02OU90cjgwNkczYm9mVmda?=
 =?utf-8?B?cFFPSnc5azhmUFk5SEZMb1hTcis1MEdGRmJPUTlEZ08ybk9CN0tWS2dqRmtU?=
 =?utf-8?B?ME9qYUFBL0ZaaHV0Tm5GVEFMRFYyM01wdlppLy9tRlRvVnVTRzFCci82RU1k?=
 =?utf-8?B?SlpSSkhodEY3ZDVsOEVNMzFlUXNyQ0dKbENLOTBlM3VoR2Q5R2VzakM4N3JI?=
 =?utf-8?B?YnBVSC95LzVYTDZtdWpzOUQ2NEIrbU1ZZTNkNmNpVlZoMnJzU2ErcnFiaWEx?=
 =?utf-8?B?enVSREtHQ3BybzJwRTNUbWloNUNvcndsVGwwWmxwL0JwdGFwY0kyT3dudGF3?=
 =?utf-8?B?VS9BelZkRDIzV0lCbit1Y2NhdmtUQjBuL0ZoRmRmRmhqWkhGZHhubHVjSlJ4?=
 =?utf-8?B?aW05YWtYSWxFcHppUVF5YVNHMEVDVlU3bEt2ZHNFdE5WQW1EVzZSUGlLVFhJ?=
 =?utf-8?B?UXdpWkdDb1U3RFk5ODI1S0xEM3ZockdGaS9wN3Y5VWJmcEQ3dXlwSUVnQmRN?=
 =?utf-8?B?cUJINW9ueXI4ZUlBeE53akdFQUs2d2Q3cTU0S0t6RysvNTlhY0dXY2RIbXNi?=
 =?utf-8?B?VkRCN0JJZHNmSStGZCtxajNnMjdYWDl0UWczOSt6dW5tT1ZzalRvRE9jQ3Fm?=
 =?utf-8?B?V3NkcHgvRnoyanJ0YndjNmJnRmVydWRvTnF1K21iQXd3Nk03dENWeDRXK2k2?=
 =?utf-8?B?Y2hncTJYNTZNOUVKd0NiUUFlKy9MYXpaelJQc2htcTB0b1IwYlZ0RzA3SXVY?=
 =?utf-8?B?b28zU2RITlE5WXQ5dEJxNHd4aGlGS0Q1MWUvY1o2MlEzQndDbkx3d1IxcE5N?=
 =?utf-8?B?empUa2tTUll6ekZMa1Y5U1J2cHJ6Wkdnc3Q3U1pURnFGUDI4RThnYmpGRDdo?=
 =?utf-8?B?SFNoUmVXSiszRnp0OGM3RldGcHN2bHJhcTNvOG95ZmsyVzBGNzhweTFiampy?=
 =?utf-8?B?Tk9wY3AvOWJUL0dEWmFaSXYyWFFySmcyL2VGNU1uUm1sRmlLbFRaV2EwOGYr?=
 =?utf-8?B?eGlsQjRpd3ZBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFFYMjdSNEFWODNGbkJrOWhNTVdRSFpyL2ovWmc3UFNhZ2FhdVdFTWtSTWF5?=
 =?utf-8?B?M3crMHVNZk1mUUZXTkJCcDdRVUdVT2lCVGFqQjF0M0hCMUFpeHdFU3VBM1V5?=
 =?utf-8?B?OWlzcHZBcm1vTmE4andCWTZHTkR6VTBzQW52RERWRTZsSEt5SHhxbHN1WWYx?=
 =?utf-8?B?b3IwQTdTbVJUc2hSdTgvYnEyQmFZeHIyNkFFRTRnUWtlcWwwd0xtS0dEQ1lS?=
 =?utf-8?B?MlNvUGhGa0VpNnJIVFQzVVVZMmpkekVGUE9KQVRoT2gwT1VoZVduWjd0c3Rw?=
 =?utf-8?B?TWlqRXZWYTRHeDFnWE94QXNaNlEyTW5BaXpkaHZDN3U3aFpvRktBQWpFVTNH?=
 =?utf-8?B?U01nZElWUW9ZM1d2VytXWUlMWCtMR3ZSVHJPYXVZeHNCbDRoUitzbXFweGk3?=
 =?utf-8?B?aTVJTmhrVWpCMW1sMHdUU2kxTjB6blhPRnJOUmhLa3Y4M3FPQVhjNCtPYjU3?=
 =?utf-8?B?cGF4bTRZMXFTQWw5RlRIc0dWZkFNa24zczdRV0FyQkZhZ2h3aGF4aDBEVk9F?=
 =?utf-8?B?UXBOS1orZ1lRNVF4ZW9xTnNGbVh2YmRFZWJvSm5MRTl4T0I3dzI5WWMrNk9h?=
 =?utf-8?B?N2R5UGorNElkL1pkKzNRczdpeE1NQ2ZhU2VUc1lnVXBDNWphR2YvTUxPWG1n?=
 =?utf-8?B?UlpIRTA3THVheTdDc2NMTGVWa0ZhTkl2dHA2bGQ2eFl1RWltRFM0NlRFdERj?=
 =?utf-8?B?eEhzdDBteGxzVzlGREVGMEV2ejZmRnRkQmNNck8raEdUa0lTTGNhald0S0Qy?=
 =?utf-8?B?ZElJU01EZkdjaE0zM0FlMm9tc3hxLzlrWkRFM0hEMVNDNDZVc1ZjSTFtOVBI?=
 =?utf-8?B?MkRickZWNjRPYXVEN3pGVEFPS1pNOUF3bFE4UElNNUFOOXBPVUhlVkZ3SnFL?=
 =?utf-8?B?RzRYaDBmd0NPcU9Kenljd3hxMDdZOXFGR0lFMW9kZ1VRN1FQbzJVOHFJdE5w?=
 =?utf-8?B?L1JISngwbVNnRUVBMzVxazdVclVUaExuTndqQ2tmZzNvMTh0ZU8xZythSnhY?=
 =?utf-8?B?dDlaNHpmZy9UMXFjaWs2M1VLVU1iYmZhQWhpcXFzR2FocE9uSWN0ZFFpQTFJ?=
 =?utf-8?B?OW9mSzJoOGV1RFN4YWI4dktITHM3YTR5WUMyZmRiVXhRTVl5R2JUZWYrZVJm?=
 =?utf-8?B?Z0VrOVg2dkJ3d1hERjBQbzJOSCtVODdndEp6Rm1jNFVMQVZVSDF5RXpqOFNK?=
 =?utf-8?B?UjVGeHpQaEVXblhRZWJlaHNOVGlZU1VCbVA2M25TSUw2bVBPV09ia3Vhb0pM?=
 =?utf-8?B?akRGSHVLRWplUThHK2R0Y2dDOUpNVXhvWUR0QzhwVjZjbGVaa0dWem5ROERz?=
 =?utf-8?B?T3EwbHFraEUyeHRpRjgxTFYvcDRwUGZ6Q0lXWE8xbDVJR3p6ZzdaVXFFVzVS?=
 =?utf-8?B?amJDbHIyTDg3cW5OZzZzN0NJOGxIcVY0eWkxYy9CVFJjQU1OZzgraFZ1RGR4?=
 =?utf-8?B?bkUrNFE2UVJwYjcxSmJ4Nkg4WUNyNVJERWgrMUFFY1NmVU1Ec1lCdmJZMHZj?=
 =?utf-8?B?K3ZkNWR4YVBkejFzQTZ2ZlprWEYraE5rQTlRd2swNTFrb1RWbEVqZkdCeXNR?=
 =?utf-8?B?U2REQ1IwRDBzazM1RU1ybkhpUTRrMDFOdy9QeEw4UWFmMlV2c0N0M2IvTW5J?=
 =?utf-8?B?Ymp0dFFJdkZYWHQ5dS91ZmZHSWtBbkFIdGtMM1ZkWkU1dmRzdStKS3BkRlZO?=
 =?utf-8?B?UnF0QXMyNDBVdDNLdnJuVkJ3UUkxRUJjY0N6czdFcFRrMXg2R1A3OWh3SlZI?=
 =?utf-8?B?MVZ5N2FpQ2FFZEREMXR1Rk1aZ1p6bXB2T2kyTGRETEI4U2Zpclp6NGoxWFZm?=
 =?utf-8?B?WXRzbEphN0N6WW9HRTdUUTAwRHY5R0xmK0U2dmhia2tHd21qaExyaXYzcXhB?=
 =?utf-8?B?aFlEQnFQUnYzekdZdDZ0TWpKR21ud3RrVVB4RWxBdHdrZTgvd3hnN2J3b0xW?=
 =?utf-8?B?QWhDM25VNjhOazc3TlVORU43WkxFWlpZSGdORWpvci9KY1NnTnFaSzRwdHhk?=
 =?utf-8?B?TEJFREU2eHozMWJFYmZrOUVGYS91MXcwN0VkV3hMdUVNWE5TRkJndWZaZEZ5?=
 =?utf-8?B?WTJnS1o1bEFwdUZhMzRhLysveXdJRzk2a0RCUUtLV0lHckZVWk1FMHlhUVdF?=
 =?utf-8?Q?M6YO8xILUpcs7IZTKo8wD9Lxb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D917FA9C3641D34D8D7605088ECEF58E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16f889bd-55d9-4864-ff3d-08dd7231bfab
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2025 22:00:15.0966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9fDxdu/G8S3dXSkcz5vmalX0ZTkkZTPja0LQwNQpktvdhmKhEBhSPmuLHfYSGnKhta47YGsOhSObZ5/JtreZKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6013
X-OriginatorOrg: intel.com

DQo+ID4gDQo+ID4gPiArdmlhIHRoZSBzYW1lIGJ1ZmZlci4gVGhlICdyZXQnIGZpZWxkIHJlcHJl
c2VudHMgdGhlIHJldHVybiB2YWx1ZS4NCj4gPiA+IA0KPiA+IHJldHVybiB2YWx1ZSBvZiB0aGUg
R2V0UXVvdGUgVERWTUNBTEw/DQo+IFllcywgdGhlcmV0dXJuIGNvZGUgb2YgdGhlIEdldFF1b3Rl
IFREVk1DQUxMLg0KPiA+IA0KPiA+ID4gVGhlIHVzZXJzcGFjZQ0KPiA+ID4gK3Nob3VsZCB1cGRh
dGUgdGhlIHJldHVybiB2YWx1ZSBiZWZvcmUgcmVzdW1pbmcgdGhlIHZDUFUgYWNjb3JkaW5nIHRv
IFREWCBHSENJDQo+ID4gPiArc3BlYy4NCj4gPiA+IA0KPiA+IEkgZG9uJ3QgcXVpdGUgZm9sbG93
LiAgV2h5IHVzZXJzcGFjZSBzaG91bGQgInVwZGF0ZSIgdGhlIHJldHVybiB2YWx1ZT8NCj4gQmVj
YXVzZSBvbmx5IHVzZXJzcGFjZSBrbm93cyB3aGV0aGVyIHRoZSByZXF1ZXN0IGhhcyBiZWVuIHF1
ZXVlZCBzdWNjZXNzZnVsbHkuDQo+IA0KPiBBY2NvcmRpbmcgdG8gR0hDSSwgVERHLlZQLlZNQ0FM
TDxHZXRRdW90ZT4gQVBJIGFsbG93cyBvbmUgVEQgdG8gaXNzdWUgbXVsdGlwbGUNCj4gcmVxdWVz
dHMuIFRoaXMgaXMgaW1wbGVtZW50YXRpb24gc3BlY2lmaWMgYXMgdG8gaG93IG1hbnkgY29uY3Vy
cmVudCByZXF1ZXN0cw0KPiBhcmUgYWxsb3dlZC7CoCBUaGUgVEQgc2hvdWxkIGJlIGFibGUgdG8g
aGFuZGxlIFRERy5WUC5WTUNBTExfUkVUUlkgaWYgaXQgY2hvb3Nlcw0KPiB0byBpc3N1ZSBtdWx0
aXBsZSByZXF1ZXN0cyBzaW11bHRhbmVvdXNseS4NCj4gU28gdGhlIHVzZXJzcGFjZSBtYXkgc2V0
IHRoZSByZXR1cm4gY29kZSBhcyBUREcuVlAuVk1DQUxMX1JFVFJZLg0KDQpPSy4gIEhvdyBhYm91
dCBqdXN0IHNheToNCg0KVGhlICdyZXQnIGZpZWxkIHJlcHJlc2VudHMgdGhlIHJldHVybiB2YWx1
ZSBvZiB0aGUgR2V0UXVvdGUgcmVxdWVzdC4gIEtWTSBvbmx5DQpicmlkZ2VzIHRoZSByZXF1ZXN0
IHRvIHVzZXJzcGFjZSBWTU0gYWZ0ZXIgc2FuaXR5IGNoZWNrcywgYW5kIHRoZSB1c2Vyc3BhY2Ug
Vk1NDQppcyByZXNwb25zaWJsZSBmb3Igc2V0dGluZyB1cCB0aGUgcmV0dXJuIHZhbHVlIHNpbmNl
IG9ubHkgdXNlcnNwYWNlIGtub3dzDQp3aGV0aGVyIHRoZSByZXF1ZXN0IGhhcyBiZWVuIHF1ZXVl
ZCBzdWNjZXNzZnVsbHkgb3Igbm90Lg0KDQo=

