Return-Path: <kvm+bounces-23350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA7A948EF0
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46584B22C1C
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 12:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DD921C4622;
	Tue,  6 Aug 2024 12:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BNsjv/M+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599D31BE240;
	Tue,  6 Aug 2024 12:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722946664; cv=fail; b=uaXxb1LTiv/DtOnJZUaFuLCm1sFaSvOWlbTOwnRv8kn4jwMiJEvdyYkeKiNAblTeADHDA3kR6pprCOttoADjTCP3u+e5t8XnSwnKuJnTbnhNWM/IW5PcEVgmxLHfE37LAd67sL49kbthMV2fssnskvh/6TuPzJH6rRVOqvrdpzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722946664; c=relaxed/simple;
	bh=u7meaOTerwr6tR7j2sdnhBwpmJ0AiUxgVm05uLUFFfw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=azSdfzHvUH4hi1EFXMtbBQtk01iFTDj/Ok+pQU6DNZ3Gm7CgxtZbm9JD0li9NFmbY5InkVF4XEBlDJBzLnMhXq8qERY+qniz14zNvo5iXgaIgNaljfzADmRQ8ipVtzpa+jD7tDKNyjzf8MoOxFwTy+pZBJpWlvOzD0740M/zZ50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BNsjv/M+; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722946662; x=1754482662;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=u7meaOTerwr6tR7j2sdnhBwpmJ0AiUxgVm05uLUFFfw=;
  b=BNsjv/M+7RyACFv4Y1TkTuFc9ttNvI5Rkp0ehZLt+jQRErCxFKvxqj26
   /4Z0Y8tmU6V36DmzDUp7hh8XXFemtRTnPHqftnON0gr0FnaM8D2UvMq1Q
   8eInTNIi159azRvUOl3FaZWVehs8kwL7mgd3L4hLrqYhxTeFTjGB1F53J
   nnI3xaxiOJxtfoIFLt2RdSX224hRMb2wV2X0j9fS8xMZFOM25T0FU58R1
   I0ui+Z24cv/4JSYUxoYQg9rzjDgZs1x4GWBy/UVNeyyVpD1wQSi6XEbo8
   8pU+h1uR0wJX7K/GGeO4Uzu0lBguEBO6Y1GuPsv8NjxXH1Y16brzXCgMe
   g==;
X-CSE-ConnectionGUID: Hj8KfxEJRc6EidwGcnSycA==
X-CSE-MsgGUID: l4R8eaStSlSIuVX+r0/r6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11156"; a="20628287"
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="20628287"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 05:17:41 -0700
X-CSE-ConnectionGUID: r3vxfQwYSFq1xJdopWJ16g==
X-CSE-MsgGUID: i+DhfrgTTw+vr3v6jQhUAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="56196118"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Aug 2024 05:17:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 05:17:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 05:17:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 6 Aug 2024 05:17:36 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 05:17:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v6KGfrY9tk7E02GZ5fNBMoKWxm5fJ/rknxMLfhY0xzVo9xz5yqWh7zs+RVYF65n93YYaoP3xI3t6wVH24haIAb2Fqz62Vgl+jZvViV+avHnL3Czuf5MtlJ6iUPOj2SZ+eAf8rUmygQmqQoNex/G9w8f0rpz8zEVpaQMepCo7vpojlBhBNSUrH0dkkQ2ffQunYhDizFvYj6qBusv5CMa65wDediHiVn/ArN7UzV8pVnboQtMJ0NkA+R9tiIv7dHydsw2kRi6xMPpNAOrUBJAFDHUKiW7ScSdKEidmPDFsRCgxOlvbGRf4ZfCzd6WnASVN6LQx30EeiUZnV5v3x6sSmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7meaOTerwr6tR7j2sdnhBwpmJ0AiUxgVm05uLUFFfw=;
 b=pc+iflbOUmnx52WqnUbVqDtxCPxljS7iZMO3VhAeAvkM4V+8roPbJ3XSt/bXcgBIYCGOyVUNZKriVL3Rbn0TUr6mGdZuGYA8B1516DMLFlc7YdzBDTWlbvUO3DKGnX/mxbbYlIN6spnaUoKUL5l3VcNl1aXCdWAgNDkMP4l2ROmL8K1cn2zL4SOVRV/lYt46vgzrv1GDYmBciGRw0VSCOJSPBV81r4GtFy2BqzBl/4N2XgZ7O1cyddaBU1jQFeEqrBpItD/0akeqlZnNTm2MRI8JCuusn1isxOJcFEGV9+3u2bdAy3ww/vaCwaszPkHu41cxj+sVnR58tPgRs25icQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4832.namprd11.prod.outlook.com (2603:10b6:a03:2dd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Tue, 6 Aug
 2024 12:17:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 12:17:33 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 09/10] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
Thread-Topic: [PATCH v2 09/10] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
Thread-Index: AQHa1/rKhBfuuYvWD0iV0IdGCEl+mLIZx5UAgAB9q4A=
Date: Tue, 6 Aug 2024 12:17:33 +0000
Message-ID: <fa2552828633a0e08bfeb2c104c74358092b05ac.camel@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
	 <39c7ffb3a6d5d4075017a1c0931f85486d64e9f7.1721186590.git.kai.huang@intel.com>
	 <66b1aaee6e7d9_4fc72941e@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66b1aaee6e7d9_4fc72941e@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4832:EE_
x-ms-office365-filtering-correlation-id: 03ffa225-6fcf-4b8a-6f5d-08dcb611c040
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?T0FTWmVpZER0c1VEOGx1Y043cWdoNG1KdlYxcnUycTNJVGZ2YW5RVUtZcUJi?=
 =?utf-8?B?dmRqbmZWcmwyL2RXbHdJdmZCbUhGVnlDdXN6T1N2S2NpSlFYNnNQZmlIVnZu?=
 =?utf-8?B?aFpzRHRpbXo5dEdQWUVDYVJaNG44SjdPZFFWS2lMejJJMWdabUhDWjRDYVp0?=
 =?utf-8?B?dmpIMHh1RTZsb1VXb29wdUR1ZnpDRHhxaHozOWhHNURzMU53NXdocnJBSWZ4?=
 =?utf-8?B?QlNxTkhzUlZ4Vi8rUmUxcTlabXJnSStDLzBaMTdqMUY2bllNdjZwL3FXY1FJ?=
 =?utf-8?B?K1l1Uk5jRDJkaUVqajdLOVgzTE5seFNDQVZHb1RaaWNHRjNWWURIZ3BMMDE0?=
 =?utf-8?B?TndYazM2dVk4UklXbUxQdXFTaktYUy9kd1BwMXBKRnE5N0x3eU9lQTVYSW50?=
 =?utf-8?B?VlpJS0FwQm5QVGdEd2VQejFRRm95YXgrWXVzaFYxaFh0WlNTMGF2dnBCK2hG?=
 =?utf-8?B?b0tGUTQ1cjJuLzhsbWE0T1ZzMStkTWsvVWpPODByS0FsUUF0TGliQUlCdTZm?=
 =?utf-8?B?amdrUUUzenRUYlNMUDVsVi9ldTMyaFpCdnVSZGxVTHh0RWhoRnl4SXVFRWt6?=
 =?utf-8?B?Z0RPL2dnUkJNdHdCRWt2ZGJnVHd6WCtVZDNVQVFTU2NYRU9YM2NqTk9HS2NE?=
 =?utf-8?B?Q2hsRlRBK0NUUjE4NzBxVUFRZG1xanRHc3lYYWFya1BCYTh4QUdHYXlKRUtO?=
 =?utf-8?B?Z1hrR3JSUHZPT0tyREw1ODhpdnFnQ05KQ1NzWHdPUzZ3NXhPNE95UUpSV2tW?=
 =?utf-8?B?N25NcjZXeklhZFMvb1lOZFYvMXJBNHlEY3VsSXRzUW8xcVQxYUQrMUFpcFNK?=
 =?utf-8?B?QStSODBnbkJUNS9zS2FqWmUwcTNjcVFad3RtM3p4Wjk0dVdFSEMwbS9USHkz?=
 =?utf-8?B?UWVxQlJES3Y2bVd2c0RIZGRKb0tIZUxKSHB1SEJQN1FBQVBWeTFaVkFDMkl1?=
 =?utf-8?B?VnhMamxVQWRWTVRZbWExSlErdCsrSWxjQWsxYzFONE4wY29GbTJRWXJuUzdu?=
 =?utf-8?B?amN6WVUraEFWWi95YW1KRC9HNS80Nmo3ODJWTStBeVM2K1pZVHlJQTlKeUZt?=
 =?utf-8?B?c25mQnNIMWpzSE1zRlFtZCt6LytrNXhLWDhGTE56QzcxbVFndy8wMFhvbm1k?=
 =?utf-8?B?Z2xWZG1aQUk1Y01RdDJ3TXBFVk9FS1BIL0dKL0VLdGlweGR3QlJod3lIeENr?=
 =?utf-8?B?cXJsRHRpMjA3b3lISU94amV2R0VxWjhERXVVdi9CYTBWUU81WFpvY1B6Qzg3?=
 =?utf-8?B?b1hTNVF3UklYaVBpb3pGQW5aaGt4N0xxbUI2ZzJsVStpK3kza0k2eTB1eVAz?=
 =?utf-8?B?aWg0QW1jODIvSzdzb2tmUFRhL0tvZzF4L0xBU0pPVXJkcmVPeVZKWmpSNFJ5?=
 =?utf-8?B?QVV3N3NadXh0YUg1aTJSbUwwMmZFL3ltbE5pR3FvRHlqZ0pjR1EzaytoS3F4?=
 =?utf-8?B?Tk1BNXhISzkrZ1JyOW1yYy81dXg0cUMrZ3NGaEVmL2JCWEF4NW03dlpET05l?=
 =?utf-8?B?QmVuNG9remMrRS9VMW5YanNnUHRxa1BlRFo5TjFhQkw5dHZUekxaTkp0SHVv?=
 =?utf-8?B?Z2tOdHRzMytsRXN5ajNYK0ZmYXBzZUU4MCtVMWcvdlZVK0JNaGRlTUN3OXJB?=
 =?utf-8?B?eUJWTnNPVDZPWHMvZVlvRTA3QVBWVlR6aUZHSVVoNkRrVlJrdU1vQlo5U01G?=
 =?utf-8?B?czhDbzlJMGxQdUViVTZEWFZJTm9BRHRyMXEzbGQvUEM0aVF4MmJCeXRGYXhp?=
 =?utf-8?B?Z095VnAvZko3VjhjbDRRQitYaTNEWkY2d1RiaVhmR291NlhhWTJhK01kZzFN?=
 =?utf-8?B?MmRodmVZOU1VSkp4TVdHNDRGUTVPaFlpTmlBZC9hTUJWU1dEVFE2Vmg1dWgy?=
 =?utf-8?B?WEN5MW95YlZILzJjc09yZ29JZEdJTGtvYlNOMUR4aG5qMG9NZHAyYWJWalRZ?=
 =?utf-8?Q?y8S7WdhhNfQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnR0QnZJNE0vSDI1SVJaTWttODJSb1Q3N014MjRmMVlhVUh6SmtlcXFIU1Va?=
 =?utf-8?B?ZGh0Sm05MzdBS084NzAxS1EySnJaR294OGhoeWJiU05raXJSeDNhby81RlJm?=
 =?utf-8?B?U0JXY1dlbmFCRDV5K3oxYXova0lvUVJsTWY5T0dleTZiajhnR3M4VEhxQWFx?=
 =?utf-8?B?N1J3bkNETUN0T0lSRkZ2RHplQ0FIWko0VUc4eDBMbUh0dysxY3pyaGxXa09W?=
 =?utf-8?B?dmU0NWsySUdvMWRPNS9GZzRVRjk2Q1ZBY1dZNmpTYVZzV1h1UUhmem5oMmYx?=
 =?utf-8?B?eFJEa3U1b2NHMFBLcmpXNmRtWlhlL1VJOHdGdkw3Zmw5ODhxQ1BxeG9hdFlv?=
 =?utf-8?B?cTBNdExuRE4xM0ptbXppNlpyTUFCcWlQby9kL2pnVDg1SUVIVnkwZk13dkUr?=
 =?utf-8?B?U003M2I5aGhRSkVPcUh2OGNUVHgyL2lsQWtoZlZzSGFuKytKRWh0di9mVFpY?=
 =?utf-8?B?ZlJQWk91Q3FUcjNwVG0vRkJvYUVURHh4YmxMbWFNWGFvMVZYbmtsNm5FZWJx?=
 =?utf-8?B?NFJFZ3NNZGJPSHJzdjBmNjFEbXBRakdLTVVVeStidVR2cTdwWndBYW5KNVpi?=
 =?utf-8?B?MFFLa3R6RU9NQ1lyYW9SMmR1aGQ4bU5rc0IrcFFqUnAzUHB1bC8vZDNzVm9X?=
 =?utf-8?B?bFhPU0lKME5SV3ZEV2pnL2Uzd2dBR2ZxbFp4bUc0QkNhK3FNa3FsNUM4dTI2?=
 =?utf-8?B?bkNXU2k2VXRkbzNoeXNqdXl3MlBpQ1hyaU5wbE13M2x4RitGcnNmaGFhNlZi?=
 =?utf-8?B?cTNha2Z0VGFyMU11am9YcEdoRUg5ck1WYWVOZEplT0ZWeUh4bm1mbURaK2NC?=
 =?utf-8?B?T2FTbFd0WGxDMzIxM2p2bTkyZ0JEbnFaUml3dCtmdlhLdGJ2VXl3WlZXeE5r?=
 =?utf-8?B?M01XWFNVSTFCU2huY3IvLzdrN3BCOWNKL0RLZHZ3aGo2TWp6QUR3bDE0QVB4?=
 =?utf-8?B?TEdIMDI1cGorMEdEZjFHbmFNaGZlV21KTjNqbmFTOTM2UEdPRzcveEVuTTNu?=
 =?utf-8?B?RFJVRks1Y20zRVJZeU9xSEFKREdrTDlXRFBPbnpNc2I1aG0vSndvaG5qMFNa?=
 =?utf-8?B?dmh5TUN3aWw3eG9GdWRqQVlFaEdrc2luWVNNRzFUTmpLQll6WHgrNmdreTNM?=
 =?utf-8?B?Rjc5S1lqVGRhdllyODcwOUtFUjNvb1JoU3RzVEt5bnFmck0vOE1XQnoweGlu?=
 =?utf-8?B?akZDMnFScmtDOGNXTEs3VVB2eHRIMmp1NGNuc2c1bFRwbjNDQUFGNDFtbHZm?=
 =?utf-8?B?RXRscElNdDF4NlluRFFpY3FmK0xxQlpEQXZFWERpbkpaRDZQdkVmNjIyaG8y?=
 =?utf-8?B?dG8zTkNlRE1UWXQ1aVFUb3NXMjlKZzBlQXRFakcvYXkydDE4dHdiZS9QdVBJ?=
 =?utf-8?B?NkhQaGRIV3NxK2hTMlNwL1ZKd1NzZG0xYm5STEgzSmlFL0sxd1NmaGFnS045?=
 =?utf-8?B?OTlERjlGTjlia2tORG5BN0JxOGlFbVo4c0txZjYrQ1JUL0Q1U00rVFIzQzhW?=
 =?utf-8?B?Y2k4Q2pxRlN4bCtFdExZNVhubjBzSHN4V0FXOGh2RXB4TjNUaUdTUlh3N3BF?=
 =?utf-8?B?cXdTaFl0ME8ybmdNRlB5azZZb0VKWEFwUDZrUFUxREZ4RVBxTzRIRWhycDFi?=
 =?utf-8?B?NU15bWdaaXBmUG9xK2p5eEVRbWgwcHZIa3BEN04zVlRQRDkyN29OeUZQc1Vs?=
 =?utf-8?B?YVVlTUpIMGFSMHlLbHlLMFkxUHhlV3doWGdaUHdkZm1hSlp6ZkkxWG41REoy?=
 =?utf-8?B?K1ZRaXpkYVRTK1hWempaMjBqM1paSTVKWWRNZlRUWWhtcGVZNjlybThjdDNz?=
 =?utf-8?B?dytoeGJPYXprYytCWXVqMXZUUzBUVW5hT1MyZkMxaFRkZ253WjAwaXhzOFM4?=
 =?utf-8?B?cXRGN1VQU0NNMWZnZHV0c2dsNlVvOWFtczQzSVJxQU1ibmlNRldlNGp5ZEk2?=
 =?utf-8?B?SEJvcGp0QkRjQk9YOExHU2hOQS9xZnpLSFgzT3dRMVg3S2VPVGRXZWhxTkxF?=
 =?utf-8?B?ZFdjS0ZFZWpncFNkSGxIWlpLZTZoYXNlcXBNTGMvMmI1UHZBaGlvaVc4bEFE?=
 =?utf-8?B?YWRZc3dGcnNISXNZR1F5eWVqcTlsOVl6OHBkRHdvdnNqNzYzTitWbXVJdjVy?=
 =?utf-8?Q?jxfOwHRAvz8S2jp2292bFC0SQ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C32C6ECB1C1A1B47AE9DE4652D3ACE6A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03ffa225-6fcf-4b8a-6f5d-08dcb611c040
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2024 12:17:33.5460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 39sCwI/9lePBV9Wo47bH11w0hQLUJZx4nmlR0MNcIBMx+Vt27YtdTER/HPa2qFTkxITWjUsucnwb3kMe9g3qfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4832
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTA1IGF0IDIxOjQ3IC0wNzAwLCBXaWxsaWFtcywgRGFuIEogd3JvdGU6
DQo+IEthaSBIdWFuZyB3cm90ZToNCj4gPiBBIFREWCBtb2R1bGUgaW5pdGlhbGl6YXRpb24gZmFp
bHVyZSB3YXMgcmVwb3J0ZWQgb24gYSBFbWVyYWxkIFJhcGlkcw0KPiA+IHBsYXRmb3JtOg0KPiA+
IA0KPiA+ICAgdmlydC90ZHg6IGluaXRpYWxpemF0aW9uIGZhaWxlZDogVERNUiBbMHgwLCAweDgw
MDAwMDAwKTogcmVzZXJ2ZWQgYXJlYXMgZXhoYXVzdGVkLg0KPiA+ICAgdmlydC90ZHg6IG1vZHVs
ZSBpbml0aWFsaXphdGlvbiBmYWlsZWQgKC0yOCkNCj4gPiANCj4gPiBBcyBwYXJ0IG9mIGluaXRp
YWxpemluZyB0aGUgVERYIG1vZHVsZSwgdGhlIGtlcm5lbCBpbmZvcm1zIHRoZSBURFgNCj4gPiBt
b2R1bGUgb2YgYWxsICJURFgtdXNhYmxlIG1lbW9yeSByZWdpb25zIiB1c2luZyBhbiBhcnJheSBv
ZiBURFggZGVmaW5lZA0KPiA+IHN0cnVjdHVyZSAiVEQgTWVtb3J5IFJlZ2lvbiIgKFRETVIpLiAg
RWFjaCBURE1SIG11c3QgYmUgaW4gMUdCIGFsaWduZWQNCj4gPiBhbmQgaW4gMUdCIGdyYW51bGFy
aXR5LCBhbmQgYWxsICJub24tVERYLXVzYWJsZSBtZW1vcnkgaG9sZXMiIHdpdGhpbiBhDQo+ID4g
Z2l2ZW4gVERNUiBtdXN0IGJlIG1hcmtlZCBhcyAicmVzZXJ2ZWQgYXJlYXMiLiAgVGhlIFREWCBt
b2R1bGUgcmVwb3J0cyBhDQo+ID4gbWF4aW11bSBudW1iZXIgb2YgcmVzZXJ2ZWQgYXJlYXMgdGhh
dCBjYW4gYmUgc3VwcG9ydGVkIHBlciBURE1SLg0KPiA+IA0KPiA+IEN1cnJlbnRseSwgdGhlIGtl
cm5lbCBmaW5kcyB0aG9zZSAibm9uLVREWC11c2FibGUgbWVtb3J5IGhvbGVzIiB3aXRoaW4gYQ0K
PiA+IGdpdmVuIFRETVIgYnkgd2Fsa2luZyBvdmVyIGEgbGlzdCBvZiAiVERYLXVzYWJsZSBtZW1v
cnkgcmVnaW9ucyIsIHdoaWNoDQo+ID4gZXNzZW50aWFsbHkgcmVmbGVjdHMgdGhlICJ1c2FibGUi
IHJlZ2lvbnMgaW4gdGhlIGU4MjAgdGFibGUgKHcvbyBtZW1vcnkNCj4gPiBob3RwbHVnIG9wZXJh
dGlvbnMgcHJlY2lzZWx5LCBidXQgdGhpcyBpcyBub3QgcmVsZXZhbnQgaGVyZSkuDQo+ID4gDQo+
ID4gQXMgc2hvd24gYWJvdmUsIHRoZSByb290IGNhdXNlIG9mIHRoaXMgZmFpbHVyZSBpcyB3aGVu
IHRoZSBrZXJuZWwgdHJpZXMNCj4gPiB0byBjb25zdHJ1Y3QgYSBURE1SIHRvIGNvdmVyIGFkZHJl
c3MgcmFuZ2UgWzB4MCwgMHg4MDAwMDAwMCksIHRoZXJlDQo+ID4gYXJlIHRvbyBtYW55IG1lbW9y
eSBob2xlcyB3aXRoaW4gdGhhdCByYW5nZSBhbmQgdGhlIG51bWJlciBvZiBtZW1vcnkNCj4gPiBo
b2xlcyBleGNlZWRzIHRoZSBtYXhpbXVtIG51bWJlciBvZiByZXNlcnZlZCBhcmVhcy4NCj4gPiAN
Cj4gPiBUaGUgRTgyMCB0YWJsZSBvZiB0aGF0IHBsYXRmb3JtIChzZWUgWzFdIGJlbG93KSByZWZs
ZWN0cyB0aGlzOiB0aGUNCj4gPiBudW1iZXIgb2YgbWVtb3J5IGhvbGVzIGFtb25nIGU4MjAgInVz
YWJsZSIgZW50cmllcyBleGNlZWRzIDE2LCB3aGljaCBpcw0KPiA+IHRoZSBtYXhpbXVtIG51bWJl
ciBvZiByZXNlcnZlZCBhcmVhcyBURFggbW9kdWxlIHN1cHBvcnRzIGluIHByYWN0aWNlLg0KPiA+
IA0KPiA+ID09PSBGaXggPT09DQo+ID4gDQo+ID4gVGhlcmUgYXJlIHR3byBvcHRpb25zIHRvIGZp
eCB0aGlzOiAxKSByZWR1Y2UgdGhlIG51bWJlciBvZiBtZW1vcnkgaG9sZXMNCj4gPiB3aGVuIGNv
bnN0cnVjdGluZyBhIFRETVIgdG8gc2F2ZSAicmVzZXJ2ZWQgYXJlYXMiOyAyKSByZWR1Y2UgdGhl
IFRETVIncw0KPiA+IHNpemUgdG8gY292ZXIgZmV3ZXIgbWVtb3J5IHJlZ2lvbnMsIHRodXMgZmV3
ZXIgbWVtb3J5IGhvbGVzLg0KPiANCj4gV2hhdCBhYm91dCBvcHRpb24zPyBGaXggdGhlIEJJT1Mu
IElmIHRoZSBCSU9TIHNjYXR0ZXJzaG90cyBsb3cgbWVtb3J5DQo+IGhvbGVzIHdoeSBkb2VzIHRo
ZSBrZXJuZWwgbmVlZCB0byBzdWZmZXIgdGhlIGJ1cmRlbiBvZiBwdXR0aW5nIGl0IGJhY2sNCj4g
dG9nZXRoZXI/DQoNCkkgZG9uJ3QgZmVlbCB3ZSBoYXZlIHN0cm9uZyBqdXN0aWZpY2F0aW9uIHRv
IGFzayBCSU9TIHRvIGZpeCB0aGlzLiAgSQ0KdGhpbmsgaXQncyBhcmd1YWJsZSB3aGV0aGVyIHRo
aXMgaXMgYSB0cnVlIGlzc3VlIGZyb20gQklPUydzIHBlcnNwZWN0aXZlLA0KYmVjYXVzZSBwdXR0
aW5nIGJ1bmNoIG9mICJBQ1BJIGRhdGEiIGluIHRoZSBmaXJzdCAyRyBhcmVhIGRvZXNuJ3Qgc2Vl
bQ0KaWxsZWdpdGltYXRlPw0KDQo+IA0KPiBXaGF0IGFib3V0IG9wdGlvbjQ/IERvbid0IHVzZSBm
b3JfZWFjaF9tZW1fcGZuX3JhbmdlKCkgdG8gcG9wdWxhdGUgVERNUnMNCj4gYW5kIGluc3RlYWQg
d2FsayB0aGUgcmVzb3VyY2UgdHJlZSBhc2tpbmcgaWYgZWFjaCByZXNvdXJjZSBpcyBjb3ZlcmVk
IGJ5DQo+IGEgQ01SIHRoZW4gYWRkIGl0IHRvIHRoZSBURE1SIGxpc3QuwqBJbiBvdGhlciB3b3Jk
cyBzdGFydGluZyBmcm9tDQo+IHBhZ2UtYWxsb2NhdGFibGUgbWVtb3J5IHRvIHBvcHVsYXRlIHRo
ZSBsaXN0IHNlZW1zIGxpa2UgdGhlIHdyb25nDQo+IHN0YXJ0aW5nIHBvaW50Lg0KDQpBICJURFgt
dXNhYmxlIiBtZW1vcnkgcmVnaW9uIGFkZGVkIHRvIFRETVIgbGlzdCBtdXN0IGJlIGNvdmVyZWQg
YnkgQ01SLA0Kc28gdGhpcyBpcyBhbHJlYWR5IHRoZSBsb2dpYyBpbiB0aGUgY3VycmVudCB1cHN0
cmVhbSBjb2RlLg0KDQpJSVVDIHRoZSBtZW1ibG9jayBhbmQgcmVzb3VyY2UgdHJlZSBzaG91bGQg
Ym90aCByZWZsZWN0IHN5c3RlbSBSQU0NCnJlZ2lvbnMgdGhhdCBhcmUgbWFuYWdlZCBieSB0aGUg
a2VybmVsIE1NLCBzbyB0aGVyZSBzaG91bGRuJ3QgaGF2ZSBiaWcNCmRpZmZlcmVuY2UgYmV0d2Vl
biB1c2luZyB0aGVtLg0KDQpUaGUgcHJvYmxlbSBpcyBub3QgaG93IHdlIGFkZCBURFgtdXNhYmxl
IG1lbW9yeSByZWdpb25zIChiYXNlZCBvbg0KbWVtYmxvY2sgb3IgcmVzb3VyY2UgdHJlZSksIGJ1
dCBob3cgd2UgZmluZCB0aGUgbWVtb3J5IGhvbGVzLg0KDQo+IA0KPiA+IE9wdGlvbiAxKSBpcyBw
b3NzaWJsZSwgYW5kIGluIGZhY3QgaXMgZWFzaWVyIGFuZCBwcmVmZXJhYmxlOg0KPiA+IA0KPiA+
IFREWCBhY3R1YWxseSBoYXMgYSBjb25jZXB0IG9mICJDb252ZXJ0aWJsZSBNZW1vcnkgUmVnaW9u
cyIgKENNUnMpLiAgVERYDQo+ID4gcmVwb3J0cyBhIGxpc3Qgb2YgQ01ScyB0aGF0IG1lZXQgVERY
J3Mgc2VjdXJpdHkgcmVxdWlyZW1lbnRzIG9uIG1lbW9yeS4NCj4gPiBURFggcmVxdWlyZXMgYWxs
IHRoZSAiVERYLXVzYWJsZSBtZW1vcnkgcmVnaW9ucyIgdGhhdCB0aGUga2VybmVsIHBhc3Nlcw0K
PiA+IHRvIHRoZSBtb2R1bGUgdmlhIFRETVJzLCBhLmsuYSwgYWxsIHRoZSAibm9uLXJlc2VydmVk
IHJlZ2lvbnMgaW4gVERNUnMiLA0KPiA+IG11c3QgYmUgY29udmVydGlibGUgbWVtb3J5Lg0KPiA+
IA0KPiA+IEluIG90aGVyIHdvcmRzLCBpZiBhIG1lbW9yeSBob2xlIGlzIGluZGVlZCBDTVIsIHRo
ZW4gaXQncyBub3QgbWFuZGF0b3J5DQo+ID4gZm9yIHRoZSBrZXJuZWwgdG8gYWRkIGl0IHRvIHRo
ZSByZXNlcnZlZCBhcmVhcy4gIEJ5IGRvaW5nIHNvLCB0aGUgbnVtYmVyDQo+ID4gb2YgY29uc3Vt
ZWQgcmVzZXJ2ZWQgYXJlYXMgY2FuIGJlIHJlZHVjZWQgdy9vIGhhdmluZyBhbnkgZnVuY3Rpb25h
bA0KPiA+IGltcGFjdC4gIFRoZSBrZXJuZWwgc3RpbGwgYWxsb2NhdGVzIFREWCBtZW1vcnkgZnJv
bSB0aGUgcGFnZSBhbGxvY2F0b3IuDQo+ID4gVGhlcmUncyBubyBoYXJtIGlmIHRoZSBrZXJuZWwg
dGVsbHMgdGhlIFREWCBtb2R1bGUgc29tZSBtZW1vcnkgcmVnaW9ucw0KPiA+IGFyZSAiVERYLXVz
YWJsZSIgYnV0IHRoZXkgd2lsbCBuZXZlciBiZSBhbGxvY2F0ZWQgYnkgdGhlIGtlcm5lbCBhcyBU
RFgNCj4gPiBtZW1vcnkuDQo+ID4gDQo+ID4gTm90ZSB0aGlzIGRvZXNuJ3QgaGF2ZSBhbnkgc2Vj
dXJpdHkgaW1wYWN0IGVpdGhlciBiZWNhdXNlIHRoZSBrZXJuZWwgaXMNCj4gPiBvdXQgb2YgVERY
J3MgVENCIGFueXdheS4NCj4gPiANCj4gPiBUaGlzIGlzIGZlYXNpYmxlIGJlY2F1c2UgaW4gcHJh
Y3RpY2UgdGhlIENNUnMganVzdCByZWZsZWN0IHRoZSBuYXR1cmUgb2YNCj4gPiB3aGV0aGVyIHRo
ZSBSQU0gY2FuIGluZGVlZCBiZSB1c2VkIGJ5IFREWCwgdGh1cyBlYWNoIENNUiB0ZW5kcyB0byBi
ZSBhDQo+ID4gbGFyZ2UsIHVuaW50ZXJydXB0ZWQgcmFuZ2Ugb2YgbWVtb3J5LCBpLmUuLCB1bmxp
a2UgdGhlIGU4MjAgdGFibGUgd2hpY2gNCj4gPiBjb250YWlucyBudW1lcm91cyAiQUNQSSAqIiBl
bnRyaWVzIGluIHRoZSBmaXJzdCAyRyByYW5nZS4gIFJlZmVyIHRvIFsyXQ0KPiA+IGZvciBDTVJz
IHJlcG9ydGVkIG9uIHRoZSBwcm9ibGVtYXRpYyBwbGF0Zm9ybSB1c2luZyBvZmYtdHJlZSBURFgg
Y29kZS4NCj4gPiANCj4gPiBTbyBmb3IgdGhpcyBwYXJ0aWN1bGFyIG1vZHVsZSBpbml0aWFsaXph
dGlvbiBmYWlsdXJlLCB0aGUgbWVtb3J5IGhvbGVzDQo+ID4gdGhhdCBhcmUgd2l0aGluIFsweDAs
IDB4ODAwMDAwMDApIGFyZSBtb3N0bHkgaW5kZWVkIENNUi4gIEJ5IG5vdCBhZGRpbmcNCj4gPiB0
aGVtIHRvIHRoZSByZXNlcnZlZCBhcmVhcywgdGhlIG51bWJlciBvZiBjb25zdW1lZCByZXNlcnZl
ZCBhcmVhcyBmb3INCj4gPiB0aGUgVERNUiBbMHgwLCAweDgwMDAwMDAwKSBjYW4gYmUgZHJhbWF0
aWNhbGx5IHJlZHVjZWQuDQo+ID4gDQo+ID4gT3B0aW9uIDIpIGlzIGFsc28gdGhlb3JldGljYWxs
eSBmZWFzaWJsZSwgYnV0IGl0IGlzIG5vdCBkZXNpcmVkOg0KPiA+IA0KPiA+IEl0IHJlcXVpcmVz
IG1vcmUgY29tcGxpY2F0ZWQgbG9naWMgdG8gaGFuZGxlIHNwbGl0dGluZyBURE1SIGludG8gc21h
bGxlcg0KPiA+IG9uZXMsIHdoaWNoIGlzbid0IHRyaXZpYWwuICBUaGVyZSBhcmUgbGltaXRhdGlv
bnMgdG8gc3BsaXR0aW5nIFRETVIgdG9vLA0KPiA+IHRodXMgaXQgbWF5IG5vdCBhbHdheXMgd29y
azogMSkgVGhlIHNtYWxsZXN0IFRETVIgaXMgMUdCLCBhbmQgaXQgY2Fubm90DQo+ID4gYmUgc3Bs
aXQgYW55IGZ1cnRoZXI7IDIpIFRoaXMgYWxzbyBpbmNyZWFzZXMgdGhlIHRvdGFsIG51bWJlciBv
ZiBURE1ScywNCj4gPiB3aGljaCBhbHNvIGhhcyBhIG1heGltdW0gdmFsdWUgbGltaXRlZCBieSB0
aGUgVERYIG1vZHVsZS4NCj4gPiANCj4gPiBTbywgZml4IHRoaXMgaXNzdWUgYnkgdXNpbmcgb3B0
aW9uIDEpOg0KPiA+IA0KPiA+IDEpIHJlYWRpbmcgb3V0IHRoZSBDTVJzIGZyb20gdGhlIFREWCBt
b2R1bGUgZ2xvYmFsIG1ldGFkYXRhLCBhbmQNCj4gPiAyKSBjaGFuZ2luZyB0byBmaW5kIG1lbW9y
eSBob2xlcyBmb3IgYSBnaXZlbiBURE1SIGJhc2VkIG9uIENNUnMsIGJ1dCBub3QNCj4gPiAgICBi
YXNlZCBvbiB0aGUgbGlzdCBvZiAiVERYLXVzYWJsZSBtZW1vcnkgcmVnaW9ucyIuDQo+ID4gDQo+
ID4gQWxzbyBkdW1wIHRoZSBDTVJzIGluIGRtZXNnLiAgVGhleSBhcmUgaGVscGZ1bCB3aGVuIHNv
bWV0aGluZyBnb2VzIHdyb25nDQo+ID4gYXJvdW5kICJjb25zdHJ1Y3RpbmcgdGhlIFRETVJzIGFu
ZCBjb25maWd1cmluZyB0aGUgVERYIG1vZHVsZSB3aXRoDQo+ID4gdGhlbSIuICBOb3RlIHRoZXJl
IGFyZSBubyBleGlzdGluZyB1c2Vyc3BhY2UgdG9vbHMgdGhhdCB0aGUgdXNlciBjYW4gZ2V0DQo+
ID4gQ01ScyBzaW5jZSB0aGV5IGNhbiBvbmx5IGJlIHJlYWQgdmlhIFNFQU1DQUxMIChubyBDUFVJ
RCwgTVNSIGV0YykuDQo+ID4gDQo+ID4gWzFdIEJJT1MtRTgyMCB0YWJsZSBvZiB0aGUgcHJvYmxl
bWF0aWMgcGxhdGZvcm06DQo+ID4gDQo+ID4gICBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDAw
MDAwMDAwLTB4MDAwMDAwMDAwMDA5ZWZmZl0gdXNhYmxlDQo+ID4gICBCSU9TLWU4MjA6IFttZW0g
MHgwMDAwMDAwMDAwMDlmMDAwLTB4MDAwMDAwMDAwMDBmZmZmZl0gcmVzZXJ2ZWQNCj4gPiAgIEJJ
T1MtZTgyMDogW21lbSAweDAwMDAwMDAwMDAxMDAwMDAtMHgwMDAwMDAwMDVkMTY4ZmZmXSB1c2Fi
bGUNCj4gPiAgIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwNWQxNjkwMDAtMHgwMDAwMDAwMDVk
MjJhZmZmXSBBQ1BJIGRhdGENCj4gPiAgIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwNWQyMmIw
MDAtMHgwMDAwMDAwMDVkM2NlZmZmXSB1c2FibGUNCj4gPiAgIEJJT1MtZTgyMDogW21lbSAweDAw
MDAwMDAwNWQzY2YwMDAtMHgwMDAwMDAwMDVkNDY5ZmZmXSByZXNlcnZlZA0KPiA+ICAgQklPUy1l
ODIwOiBbbWVtIDB4MDAwMDAwMDA1ZDQ2YTAwMC0weDAwMDAwMDAwNWU1YjJmZmZdIHVzYWJsZQ0K
PiA+ICAgQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDA1ZTViMzAwMC0weDAwMDAwMDAwNWU1YzJm
ZmZdIHJlc2VydmVkDQo+ID4gICBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDVlNWMzMDAwLTB4
MDAwMDAwMDA1ZTVkMmZmZl0gdXNhYmxlDQo+ID4gICBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAw
MDVlNWQzMDAwLTB4MDAwMDAwMDA1ZTVlNGZmZl0gcmVzZXJ2ZWQNCj4gPiAgIEJJT1MtZTgyMDog
W21lbSAweDAwMDAwMDAwNWU1ZTUwMDAtMHgwMDAwMDAwMDVlYjU3ZmZmXSB1c2FibGUNCj4gPiAg
IEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwNWViNTgwMDAtMHgwMDAwMDAwMDYxMzU3ZmZmXSBB
Q1BJIE5WUw0KPiA+ICAgQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDA2MTM1ODAwMC0weDAwMDAw
MDAwNjE3MmFmZmZdIHVzYWJsZQ0KPiA+ICAgQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDA2MTcy
YjAwMC0weDAwMDAwMDAwNjE3OTRmZmZdIEFDUEkgZGF0YQ0KPiA+ICAgQklPUy1lODIwOiBbbWVt
IDB4MDAwMDAwMDA2MTc5NTAwMC0weDAwMDAwMDAwNjE3ZmVmZmZdIHVzYWJsZQ0KPiA+ICAgQklP
Uy1lODIwOiBbbWVtIDB4MDAwMDAwMDA2MTdmZjAwMC0weDAwMDAwMDAwNjE5MTJmZmZdIEFDUEkg
ZGF0YQ0KPiA+ICAgQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDA2MTkxMzAwMC0weDAwMDAwMDAw
NjE5OThmZmZdIHVzYWJsZQ0KPiA+ICAgQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDA2MTk5OTAw
MC0weDAwMDAwMDAwNjE5ZGZmZmZdIEFDUEkgZGF0YQ0KPiA+ICAgQklPUy1lODIwOiBbbWVtIDB4
MDAwMDAwMDA2MTllMDAwMC0weDAwMDAwMDAwNjE5ZTFmZmZdIHVzYWJsZQ0KPiA+ICAgQklPUy1l
ODIwOiBbbWVtIDB4MDAwMDAwMDA2MTllMjAwMC0weDAwMDAwMDAwNjE5ZTlmZmZdIHJlc2VydmVk
DQo+ID4gICBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDYxOWVhMDAwLTB4MDAwMDAwMDA2MWEy
NmZmZl0gdXNhYmxlDQo+ID4gICBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDYxYTI3MDAwLTB4
MDAwMDAwMDA2MWJhZWZmZl0gQUNQSSBkYXRhDQo+ID4gICBCSU9TLWU4MjA6IFttZW0gMHgwMDAw
MDAwMDYxYmFmMDAwLTB4MDAwMDAwMDA2MjNjMmZmZl0gdXNhYmxlDQo+ID4gICBCSU9TLWU4MjA6
IFttZW0gMHgwMDAwMDAwMDYyM2MzMDAwLTB4MDAwMDAwMDA2MjQ3MWZmZl0gcmVzZXJ2ZWQNCj4g
PiAgIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwNjI0NzIwMDAtMHgwMDAwMDAwMDYyODIzZmZm
XSB1c2FibGUNCj4gPiAgIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwNjI4MjQwMDAtMHgwMDAw
MDAwMDYzYTI0ZmZmXSByZXNlcnZlZA0KPiA+ICAgQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDA2
M2EyNTAwMC0weDAwMDAwMDAwNjNkNTdmZmZdIHVzYWJsZQ0KPiA+ICAgQklPUy1lODIwOiBbbWVt
IDB4MDAwMDAwMDA2M2Q1ODAwMC0weDAwMDAwMDAwNjQxNTdmZmZdIHJlc2VydmVkDQo+ID4gICBC
SU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDY0MTU4MDAwLTB4MDAwMDAwMDA2NDE1OGZmZl0gdXNh
YmxlDQo+ID4gICBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDY0MTU5MDAwLTB4MDAwMDAwMDA2
NDE5NGZmZl0gcmVzZXJ2ZWQNCj4gPiAgIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwNjQxOTUw
MDAtMHgwMDAwMDAwMDZlOWNlZmZmXSB1c2FibGUNCj4gPiAgIEJJT1MtZTgyMDogW21lbSAweDAw
MDAwMDAwNmU5Y2YwMDAtMHgwMDAwMDAwMDZlY2NlZmZmXSByZXNlcnZlZA0KPiA+ICAgQklPUy1l
ODIwOiBbbWVtIDB4MDAwMDAwMDA2ZWNjZjAwMC0weDAwMDAwMDAwNmY2ZmVmZmZdIEFDUEkgTlZT
DQo+ID4gICBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDZmNmZmMDAwLTB4MDAwMDAwMDA2Zjdm
ZWZmZl0gQUNQSSBkYXRhDQo+ID4gICBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDZmN2ZmMDAw
LTB4MDAwMDAwMDA2ZjdmZmZmZl0gdXNhYmxlDQo+ID4gICBCSU9TLWU4MjA6IFttZW0gMHgwMDAw
MDAwMDZmODAwMDAwLTB4MDAwMDAwMDA4ZmZmZmZmZl0gcmVzZXJ2ZWQNCj4gPiAgIC4uLi4uLg0K
PiA+IA0KPiA+IFsyXSBDb252ZXJ0aWJsZSBNZW1vcnkgUmVnaW9ucyBvZiB0aGUgcHJvYmxlbWF0
aWMgcGxhdGZvcm06DQo+ID4gDQo+ID4gICB2aXJ0L3RkeDogQ01SOiBbMHgxMDAwMDAsIDB4NmY4
MDAwMDApDQo+ID4gICB2aXJ0L3RkeDogQ01SOiBbMHgxMDAwMDAwMDAsIDB4MTA3YTAwMDAwMCkN
Cj4gPiAgIHZpcnQvdGR4OiBDTVI6IFsweDEwODAwMDAwMDAsIDB4MjA3YzAwMDAwMCkNCj4gPiAg
IHZpcnQvdGR4OiBDTVI6IFsweDIwODAwMDAwMDAsIDB4MzA3YzAwMDAwMCkNCj4gPiAgIHZpcnQv
dGR4OiBDTVI6IFsweDMwODAwMDAwMDAsIDB4NDA3YzAwMDAwMCkNCj4gPiANCj4gPiBTaWduZWQt
b2ZmLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo+IA0KPiBJdCBib3RoZXJz
IG1lIHRoYXQgdGhpcyBmaXggYnVyaWVkIGJlaGluZCBhIGJ1bmNoIG9mIG90aGVyIGNsZWFudXAs
IGJ1dA0KPiBJIGd1ZXNzIHRoYXQgaXMgb2sgaWYgdGhpcyBpc3N1ZSBpcyBub3QgdXJnZW50LiBJ
ZiBpdCAqaXMqIHVyZ2VudCB0aGVuDQo+IG1heWJlIGEgZml4IHdpdGhvdXQgc28gbWFueSBkZXBl
bmRlbmNpZXMgd291bGQgYmUgbW9yZSBhcHByb3ByaWF0ZS4NCg0KVGhpcyBpcyBub3QgdXJnZW50
IGZyb20gdXBzdHJlYW0ga2VybmVsJ3MgcGVycGVjdGl2ZSwgYmVjYXVzZSBjdXJyZW50bHkNCnRo
ZXJlJ3Mgbm8gaW4ta2VybmVsIFREWCBjb2RlIHVzZXIgZGVzcGl0ZSB3ZSBoYXZlIFREWCBtb2R1
bGUNCmluaXRpYWxpemF0aW9uIGNvZGUgaW4gdGhlIHRyZWUuDQoNClRoaXMgaXNzdWUgY2FuIG9u
bHkgYmUgdHJpZ2dlcmVkIHdpdGggdGhlIG9mZiB0cmVlLCB1cHN0cmVhbWluZy1vbmdvaW5nDQpL
Vk0gVERYIHBhdGNoc2V0LiAgSG93ZXZlciB0aGVyZSBhcmUgY3VzdG9tZXJzIHVzaW5nIHRoZSB3
aG9sZSBvZmYgdHJlZQ0KVERYIGNvZGUgc28gdGhlb3JldGljYWxseSB0aGV5IGNvdWxkIG1lZXQg
dGhpcyBpc3N1ZSAoaW4gZmFjdCwgdGhpcyBpc3N1ZQ0Kd2FzIHJlY2VudGx5IHJlcG9ydGVkIGZy
b20gb25lIG9mIHRoZSBjdXN0b21lcnMpLg0KDQo=

