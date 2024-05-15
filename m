Return-Path: <kvm+bounces-17457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A5D48C6C1C
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 20:22:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91E1FB228F0
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 18:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A165158DD0;
	Wed, 15 May 2024 18:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HRWpoO1Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EFC158845;
	Wed, 15 May 2024 18:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715797359; cv=fail; b=EtJ1xWpWTGQqwQCBlYNkthzgO9qO5lJ1T9enCr9CEe0IrSYqVWCo4P/WOH35PC9t82XRvGGBvRn9WWgCUuBJXuDesrS8NA92/qlBMPqfaHyCRmaqw6ojZv67+l303BRWMoAijTpZriiyx+92O4Dv2yefv/+u1ZYno33eVN6ublE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715797359; c=relaxed/simple;
	bh=JFq2h9QUJZI7FKM1GsiI+OOJTgTXaGMgHpNkCi3t8w0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OsNHGzDJ/HgoBhrh6N8n9G02pHDuL+wMaYC3ah8//pTF8KLSUgGfplMHBrqx3AysY4k+7A+mxYcJEbhJSjbk4sFzlWixivQYXhgvsQu2c5VMBnBFBe+XFdpZYvBffLnBFVIenhDWxDivpzeod0DwbYoPcs5Ff1WgGmT8bPENXc0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HRWpoO1Q; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715797358; x=1747333358;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JFq2h9QUJZI7FKM1GsiI+OOJTgTXaGMgHpNkCi3t8w0=;
  b=HRWpoO1QO+0lgHo5yT53QCQsei3Nya/XQ2EsJ7uPnam7CWCm6PhU4BRf
   BAsva5xgT30fSZhGUs4ZIulypAfrlT0I40GNMkz7WyK9x1ug2HzpqxItY
   xYmF7aSuuAO7ipFlISoY8HcP5JVenkyjKXOFD4fO0P4/PfuFLL1Sq8ovk
   j4fULdd8j/xVfoqLo5EE7a0tG/QM7jCII/j7i8uiybwh15ixleFqbUYDI
   lwcAyjGRbh21nAg5bzdsen3uL0LTrk6yJjdxh5BZu/qBXfpy8MuJRuzAi
   WVQh5uoQDlydba7hL9cinstRNBkBkhcBLt5dfD77RECh1bZ3RoV72x2Eo
   w==;
X-CSE-ConnectionGUID: y+ZRT5dGSu+Ih4Hn0DlR1g==
X-CSE-MsgGUID: +hb7XUJ+R8aAsE2hTsIRMg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="37250409"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="37250409"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 11:22:37 -0700
X-CSE-ConnectionGUID: 0bVmMT96TESnWXR5B9Qvzw==
X-CSE-MsgGUID: wtS2ullmQ6yokglIxo/lRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31570973"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 11:22:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 11:22:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 15 May 2024 11:22:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 11:22:36 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 11:22:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0fQ+qzVKzadqog/EI2eWi1WRphPBxXDUmYg1EOF+4wBKVORSyQUHNHmzUHt5R4f1qzO3qB34l6O0Dswv27G+YqvAaCgyzCtjLipnVxB73FdUFzJfewNehgk0WoudkPCyuNJcwkk8nTaXwJBSxF27kvIoqWazvpRh4/QSWiYTfK1KhZ16up6zzGhBFnhfkItGynmbNH6i3HxUofmUrJMWgvPx/EAUSNyEdedKhVY8ZdBsQiIScf0qiBGY1fL/+WQ9PCMQ3Gv/jdLNA6EN2Xk6W0MjnX+d8PunjMW+7fKcTzGwicmYlRMUvrBEUgJm9pCrbfr7/WqGdOlOQGivv0iSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JFq2h9QUJZI7FKM1GsiI+OOJTgTXaGMgHpNkCi3t8w0=;
 b=R1K/ILH9TohPYTpMBuNMTs3bIBAbEdayBQmxZ1VS2pvd7SYzQoztumoszepUi/+OAB9LTIjzgpZj9YlHOtOghK7VQ6k2vKLMLAlgZrTj92QCfoRQkP+nARfIpySU2wdZ0GhOy2adT8sXJuowdqN/sW9v2NAusx/vqtq6/0Wt1MCGFSAKqP30FeaHKJeL1fmaV4Xfv6K0p4Rp3q1uFw9GIUl8Vw0rNxXZhfNFdt2RJDjM5MXI1QV3kl9CIwN8ISegOedUby362hWcCSQFkq9xbDZW2g2+xrsFHlmyfRhK3GLiXVD31FIQYaqRVK3Hb3L6CFsME13jfIOr+9/0SvmxNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB8397.namprd11.prod.outlook.com (2603:10b6:208:48b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Wed, 15 May
 2024 18:22:33 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 18:22:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Topic: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Index: AQHapmNQnVfe1bKBZ0u4IdlZLB/mxbGYbgKAgAAELYCAAAHkgIAAAZ0AgAAC8ICAACCQgIAAA76A
Date: Wed, 15 May 2024 18:22:33 +0000
Message-ID: <77ae4629139784e7239ce7c03db2c2db730ab4e9.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
	 <ZkTWDfuYD-ThdYe6@google.com>
	 <f64c7da52a849cd9697b944769c200dfa3ee7db7.camel@intel.com>
	 <747192d5fe769ae5d28bbb6c701ee9be4ad09415.camel@intel.com>
	 <ZkTcbPowDSLVgGft@google.com>
	 <de3cb02ae9e639f423ae47ef2fad1e89aa9dd3d8.camel@intel.com>
	 <ZkT4RC_l_F_9Rk-M@google.com>
In-Reply-To: <ZkT4RC_l_F_9Rk-M@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB8397:EE_
x-ms-office365-filtering-correlation-id: cd741d6f-b7a2-4faf-683f-08dc750bfd8b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?QUs2cWcwbkNyV3Y3TXVPN3Zxa3BWUzhsclR6U3UvWmxPQ242SS9ETjN1WGpJ?=
 =?utf-8?B?Mmk4SVBqMmE4NHZEZmFWemI4eDVmYkl1QWVKSjR2NVNPS0VuK3dXM1p0MkZr?=
 =?utf-8?B?TVBhMnhLWXBNME9leHI2QWNvYTVud2M2TFQrVUJjcmZyYlVGNUxZelRyREFW?=
 =?utf-8?B?ZWZIYVY4bnY5Mi9BSEVoNXl3ajVUMWtzRFdBTTRmTkRXOVZWUWNHWkF6em5j?=
 =?utf-8?B?RnFpdHBsODhGek5jbUhYWTgxTlZINGtXakhaVXdkTEQ3QWJkRmRzcXQzUzlO?=
 =?utf-8?B?WUI4a2tnU2pnL0o1NXZoNlNpNDdwZmRseThja1FqaG5jTFBUaUx3OHdaamNB?=
 =?utf-8?B?YyswNFhPdnkycnM4OXBxdkxWbVpLZWRLYkJpWjgvMmdzakxRYktvM3V4c0Zn?=
 =?utf-8?B?czlGNllXaWlEa3pLZWJZSmR0cFdBTVM1WGNKNXdoZjVhdjVGZ3VWNzIrMzFz?=
 =?utf-8?B?UVRSbC9UWnBPYmZtTktRQld4QlpVK2MxOFR6OXBRb0pmZGo0NGM4UWpGWHFH?=
 =?utf-8?B?ZDRrc21rT0JpSDQrQTRPdXplbmRaWGkreHU3aFIyVUc5SnpJeGFVODlGOXlD?=
 =?utf-8?B?MVR5ZURuRjRJYXp4cWRyOEZ3RUxkekFDNlU4NUkyMGowLzhHaUk5WENGMWlm?=
 =?utf-8?B?R1FlQmpFeHVZVExoeWZtd25NcS8wOStyaEM3VlpTZ250am1rK1EwTEFzdzMz?=
 =?utf-8?B?emR5Z2NpV01zd3VyeWpMczZiZjQ5NW1BOCtSSXJmQllieTMwNUJCN3NPSVM2?=
 =?utf-8?B?KzIzM3VmcGp5VG91eXNpVkRNTnlNV1hmYjlaRmpuZG5MdXRJVE1qZEpiblFi?=
 =?utf-8?B?MkIzNGpRSExkKytESkZVOGRVcmFTOS9Nc2FCUkt4UEllMndMMTl3anpZOXp1?=
 =?utf-8?B?Z1lxZE9uSVBBanc0TTBBbWl0akk4SmhjWmc3SWtMcjBVRnUva25jZnN6S2pT?=
 =?utf-8?B?NmdXcDAyaUpFUnZDNktiMG1Ta1EzRTljdEs2c25HM2NIUnRKaVRPOUdBWm5q?=
 =?utf-8?B?c3FsbmtsOFNvdzNYNmVNejI5V0ZqVGFUZnZFTUwvdWlCRTJPQjN4RE9seXg0?=
 =?utf-8?B?NkpuTDd1L0c4eHF2MXY2U2c2a01JSzFLZUpSMDNjQVJ0UlUwdFRzZzlEVDRq?=
 =?utf-8?B?Z2F2Nm13U2dSS3VwV2ZNcWlseVp5SDZ2eitkZXJIcXZxR1BTMzdhdEJZeERM?=
 =?utf-8?B?YWcrQVQwdGJMN2pmdkpVVHNEdDgxK2ZOMkxtM2xPa1pRdVBmYVNSaTNEVXVh?=
 =?utf-8?B?WGVPTmtkVVYzSzFEdG52QUR0V01Ca2Y2cm95QTc0K1Z2U1AyK1ZkYm9RN212?=
 =?utf-8?B?REJZWkhnVldCemlUcDR1RTg4TE45TzVDMEdMdzBZQVNDdW9tZlUvYmRXTENN?=
 =?utf-8?B?bjFsNUN0azBvMjZTNmRKMEdGT2RRN0pIMzFvMWxlUXNsalJ2alpmbDZWYmx6?=
 =?utf-8?B?VmIwZUJUSzR0THhXODg2TFo4RU45RjJ6eklsdVkyZFczb3oyc3BVeG8wTnNX?=
 =?utf-8?B?a2xTU0Jsa0U4VnFRUHEwM095VjBmK0dKakVUVDRzZmozTE5QNXIwdDVCVWtq?=
 =?utf-8?B?Sy9sa0tBazNlcC9BaFhrUWZMdlMvZHNidkpWUzZueXVrVTJDYys0d2EwYTdo?=
 =?utf-8?B?UmdlbWQrUmNFb2pIdG5hZFdpRS9hOTUxMUllQXBITXB2UHh4d3gxVDF4QkZk?=
 =?utf-8?B?VDg0RGMvS1RVeFB2aUdQOGNwUmQ3YS9abHBrcTRtYTNmZVkrblZHNVVXRTZv?=
 =?utf-8?B?bUdGbGZXZ3VuRUdLSld3ZnhycnZyR2tZRWh2S1BGdFhOOURmaHNPeUhuYm9I?=
 =?utf-8?B?bkJxczFpczUzN2hXZnNmQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bDhOTGQ4NlVYc2lGeEJCWEJDMlNJVytSbnF3TSszcWlDeHliY20wVXZKN0I1?=
 =?utf-8?B?WkJVS2NpeStMbVNsUjdBQTJtM0xWK280bjBmbENpTSswc2c3M3NBK1RhSkRW?=
 =?utf-8?B?ZEYxNkpBdGhwREY0M2JXZFMwQlRORU15NlRNVUJDamFtZm9WMGk0ZCtnWW9a?=
 =?utf-8?B?UFhKaXlFdmRiUnNmRzRQQ0U2bWN1NXdLRDUwSVdUWlNIWnVRN1p2RTJRVlQz?=
 =?utf-8?B?R1pNNGlJNXJRbVp3U1Jaa2pEUlhkMCtFZWRRWDFyRUZuK2V5YTNyaWpvYXJm?=
 =?utf-8?B?bUlNTitNMTR0T29lT3BJZkZtK0xJR2JzNElhRVozbmdvd05Fazl2MWtNclRa?=
 =?utf-8?B?MlcvRjVMSjl2MHVXV3VLeTljNGUwS3ZZTUo3YnNJWlV2Q2d0ekl5K21DbnpW?=
 =?utf-8?B?alUrcytmSGhxS3pQVzRveUgvdjNLdUY3MktaNkRHRmF5WHVUSHlWN3hTRmtC?=
 =?utf-8?B?VGNWbW9hcDBvcDdjWWNhNnN0ODZHc3FSekJlMUJDQ2t5SlVVZXo5MEtuSGhH?=
 =?utf-8?B?bmExR0FMZmJZakVremtLZDVRNWhJS05mdXZVSUVrSVVJR2VCZHlIVWwraTVC?=
 =?utf-8?B?emRRcnhqMG9aSUQwWUQ2eEkwcHdPcTZFUE9MdEpGYUM3dU1SK2hJOWtIZ1dl?=
 =?utf-8?B?emxPTjFEREtQbldJWVpzc2o1VUNTWFI1bm9FOXdwUVF5cFozRkF2QWVoNW5q?=
 =?utf-8?B?UFBmOUpoOXlVUjNRK0orUnBHbUNDSWlCL2ZxL3lMbmYzdk5xMnJrK1hmWlA5?=
 =?utf-8?B?NXphNDJKNEM0Vmp2NitROTZpd1pockhkM2F4N3Zva2ZBajR3YkcrVFFCY1dJ?=
 =?utf-8?B?MjROYzZwblFUQ1NvMThXZlNkbHB6Y0ZWQXZWVXVaVTJEdVVwVEFsM1o0NDBF?=
 =?utf-8?B?Y2J1Yy9pWlhUOVFodHZpOUVyQ0JtWGdBVVNVSmpVai9WT21xZUo1Q0J1OEZZ?=
 =?utf-8?B?ZzA4VVNsQUdQS0JDbzU3ekhoZExYaEJSMmcycmljVmlteWs0L3VGbVJnSWFD?=
 =?utf-8?B?dk9hWlBvckwyZ2FyVWpESGhCbjkvU2J4T21ZV0cvS053T0xScjUwM3o3UEJG?=
 =?utf-8?B?ZkpuR1VvMDAzWHZuSHZPM3o3dnU3Vkx2SVFzZk1xM0VmNnFHazNoSGVOdHhH?=
 =?utf-8?B?RFVUVkNDNFhNSjhraGxvVXZtUlZjU1NxL1FJSE40RkJXamVia1NjUGNEZko5?=
 =?utf-8?B?QUFoN1hyYllVUnNNN3Y0NEZwTzlkNWVEYmwrT2l1TnZ0ckZUZjRFVzFuT09p?=
 =?utf-8?B?bmRWdmI2M3RBcDhnUGNFVHdNMHRBSmZJWDRWMHFGT25HL01aT0VQeW1QYURu?=
 =?utf-8?B?RGpsMUdmRVlKbDlxWjFpdXNnMTZoNi9RYTBHemxVYjRaWXZ4NVNRNWcxa2h5?=
 =?utf-8?B?Wlordm1YaFh0NHFwM0J5bGRzZ1JMS25UNUF5Y1ZvL1FWQysvaUpCUkpNa3Ni?=
 =?utf-8?B?dVF5Q1pPN2dXNHF4eWNiTWRLWExJRFJGbGZIczZma2Z1d3pVYmpHaVZpZW1x?=
 =?utf-8?B?MWgzRWx5Rm9kRWhSYXlHMWFSTjA3YVpYMG9zMTBnQzFmRXQ5L3FRNUtqNEpU?=
 =?utf-8?B?VGJuc0NQQWVvZTQ5RUhYY2Z2OFJ2S1o0dHdMOWg1RlMvakN5YWpGUGRtVGV1?=
 =?utf-8?B?NkxGeXpHWGw5bGNyV0Zvc3ByZFVLVDZnUHhsWE1DQXN1UTg2ek9QR09MQlcr?=
 =?utf-8?B?eVh3SUFLUmlOTGxrYkJTNGtBWldKeFdwSU5mNGt4MStLYXBqMmVkL3hnK1h1?=
 =?utf-8?B?bWxyZGZDendxVHViWHNWVktwRitMMGlhREJpdC9YQmtucThzSnhmWFVPQXhD?=
 =?utf-8?B?ZWVBZ0c5RzFSKzJoM2tBMzFzUmZnWWQzdG9iYUZ2ZzVSMmlPMnl5TUxNUzVY?=
 =?utf-8?B?aW9hbnV6Y1hHTzlQdU5YVDZUWWZPdG1QZ29LSExYcnZEdVJkTmtqajhVWGRm?=
 =?utf-8?B?YWU1YmNocmdMK0NqcmRZWExJUWFUNnBhNGFMNUZ6M3Y2MXBneDU0eVVzYXkv?=
 =?utf-8?B?VWhIVHlKZFdwaEh0SFNOazZ4RlZDSlhrOGJ0VStVd1RYQWtpdmEyRXBKdGRR?=
 =?utf-8?B?QzVYdDhuRnNsOGxnS29nejZuTThVaUZ3QVIrUjZ4c3lQSUg1UHpNdXBydE5S?=
 =?utf-8?B?WnlyUXpFaDhCR0Z3YVJDaFNEbC9Jb3ZsallhTDdrNnVtWDNwdFZSdEU1SzRP?=
 =?utf-8?Q?EGubQhYR0mSVeETbKJ1Q6vU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3808FB5FB521F346AD8626297BA5A8AD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd741d6f-b7a2-4faf-683f-08dc750bfd8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 18:22:33.8055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kkTkWzBVUPUJJznUy6sNgPdbMOY1R7V0pxm39dh33BsqBYhnnQK2eVgSI4nfa+o4XFsDoRDP0zMVMxItBZ5I7ehHNAeww2EvjDzZfx9o9UA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8397
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTE1IGF0IDExOjA5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE1heSAxNSwgMjAyNCwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBPbiBXZWQsIDIwMjQtMDUtMTUgYXQgMDk6MDIgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gPiA+IE9yIG1vc3Qgc3BlY2lmaWNhbGx5LCB3ZSBvbmx5IG5lZWQgdGhpcyB6
YXBwaW5nIGlmIHdlICp0cnkqIHRvIGhhdmUNCj4gPiA+ID4gY29uc2lzdGVudCBjYWNoZSBhdHRy
aWJ1dGVzIGJldHdlZW4gcHJpdmF0ZSBhbmQgc2hhcmVkLiBJbiB0aGUNCj4gPiA+ID4gbm9uLWNv
aGVyZW50IERNQSBjYXNlIHdlIGNhbid0IGhhdmUgdGhlbSBiZSBjb25zaXN0ZW50IGJlY2F1c2Ug
VERYDQo+ID4gPiA+IGRvZXNuJ3Qgc3VwcG9ydCBjaGFuZ2luZyB0aGUgcHJpdmF0ZSBtZW1vcnkg
aW4gdGhpcyB3YXkuDQo+ID4gPiANCj4gPiA+IEh1aD/CoCBUaGF0IG1ha2VzIG5vIHNlbnNlLsKg
IEEgcGh5c2ljYWwgcGFnZSBjYW4ndCBiZSBzaW11bHRhbmVvdXNseSBtYXBwZWQNCj4gPiA+IFNI
QVJFRCBhbmQgUFJJVkFURSwgc28gdGhlcmUgY2FuJ3QgYmUgbWVhbmluZ2Z1bCBjYWNoZSBhdHRy
aWJ1dGUgYWxpYXNpbmcNCj4gPiA+IGJldHdlZW4gcHJpdmF0ZSBhbmQgc2hhcmVkIEVQVCBlbnRy
aWVzLg0KPiA+ID4gDQo+ID4gPiBUcnlpbmcgdG8gcHJvdmlkZSBjb25zaXN0ZW5jeSBmb3IgdGhl
IEdQQSBpcyBsaWtlIHdvcnJ5aW5nIGFib3V0IGhhdmluZw0KPiA+ID4gbWF0Y2hpbmcgUEFUIGVu
dGlyZXMgZm9yIHRoZSB2aXJ0dWFsIGFkZHJlc3MgaW4gdHdvIGRpZmZlcmVudCBwcm9jZXNzZXMu
DQo+ID4gDQo+ID4gTm8sIG5vdCBtYXRjaGluZyBiZXR3ZWVuIHRoZSBwcml2YXRlIGFuZCBzaGFy
ZWQgbWFwcGluZ3Mgb2YgdGhlIHNhbWUgcGFnZS4NCj4gPiBUaGUNCj4gPiB3aG9sZSBwcml2YXRl
IG1lbW9yeSB3aWxsIGJlIFdCLCBhbmQgdGhlIHdob2xlIHNoYXJlZCBoYWxmIHdpbGwgaG9ub3Ig
UEFULg0KPiANCj4gSSdtIHN0aWxsIGZhaWxpbmcgdG8gc2VlIHdoeSB0aGF0J3MgYXQgYWxsIGlu
dGVyZXN0aW5nLsKgIFRoZSBub24tY29oZXJlbnQgRE1BDQo+IHRyYWlud3JlY2sgaXMgYWxsIGFi
b3V0IEtWTSB3b3JyeWluZyBhYm91dCB0aGUgZ3Vlc3QgYW5kIGhvc3QgaGF2aW5nIGRpZmZlcmVu
dA0KPiBtZW10eXBlcyBmb3IgdGhlIHNhbWUgcGh5c2ljYWwgcGFnZS4NCg0KT2suIFRoZSBzcGxp
dCBzZWVtZWQgYSBsaXR0bGUgb2RkIGFuZCBzcGVjaWFsLiBJJ20gbm90IHN1cmUgaXQncyB0aGUg
bW9zdA0KaW50ZXJlc3RpbmcgdGhpbmcgaW4gdGhlIHdvcmxkLCBidXQgdGhlcmUgd2FzIHNvbWUg
ZGViYXRlIGludGVybmFsbHkgYWJvdXQgaXQuDQoNCj4gDQo+IElmIHRoZSBob3N0IGlzIGFjY2Vz
c2luZyBURFggcHJpdmF0ZSBtZW1vcnksIHdlIGhhdmUgZmFyLCBmYXIgYmlnZ2VyIHByb2JsZW1z
DQo+IHRoYW4gYWxpYXNlZCBtZW10eXBlcy4NCg0KVGhpcyB3YXNuJ3QgdGhlIGNvbmNlcm4uDQoN
Cj4gwqAgQW5kIHNvIHRoZSBmYWN0IHRoYXQgVERYIHByaXZhdGUgbWVtb3J5IGlzIGZvcmNlZCBX
QiBpcw0KPiBpbnRlcmVzdGluZyBvbmx5IHRvIHRoZSBndWVzdCwgbm90IEtWTS4NCg0KSXQncyBq
dXN0IGFub3RoZXIgbGl0dGxlIHF1aXJrIGluIGFuIGFscmVhZHkgY29tcGxpY2F0ZWQgc29sdXRp
b24uIFRoZXkgdGhpcmQNCnRoaW5nIHdlIGRpc2N1c3NlZCB3YXMgc29tZWhvdyByZWplY3Rpbmcg
b3Igbm90IHN1cHBvcnRpbmcgbm9uLWNvaGVyZW50IERNQS4NClRoaXMgc2VlbWVkIHNpbXBsZXIg
dGhhbiB0aGF0Lg0K

