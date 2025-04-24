Return-Path: <kvm+bounces-44228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D026A9BB05
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 00:59:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C86C7A9636
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 22:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90D228B4F2;
	Thu, 24 Apr 2025 22:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dPGc1+Or"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D509019DF7D;
	Thu, 24 Apr 2025 22:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745535555; cv=fail; b=qyjK62wncmxz44MjGKuOa4kboWcFjcPIaelUZ5Cl2hSMaSAKjZVCs0Zh5ueJTi37zWnUszrPAlxZj4zsKNQME3wRvTvFVoTjXNyHBgqnFtaEbPwtD9o9uE4LYBHY5dqEFHAPCPyUsyzjUWR3feTiwp4uygVPcoCkAyQW/ev0eM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745535555; c=relaxed/simple;
	bh=k/cfBOb0aqCMvxevBMObmw2h4gS2J9hLTJSyz2qYNS4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=botpnIN/6Wx+L9hx8WnQGh0bOw9BeW9xvgKQ0/WJ3hME20eINrFq5F9mYbfvpEI/eofn57vj8oxRr60ONiH8sUKjqtZPUTWU05x2zrXWeGM85AODX/wf3KnGb/HSt+I6uxdbC+AjOzO6V5wMES8FSQDj4jmp8Ay1zVYx+ifL8XQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dPGc1+Or; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745535553; x=1777071553;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=k/cfBOb0aqCMvxevBMObmw2h4gS2J9hLTJSyz2qYNS4=;
  b=dPGc1+OrMOHzYPgLGPAtLUAZLYu1IGX9xP5i4ygAEYeukbTg+hIXAx3y
   1sz0Tx06EZOZoDUHDtfUfviB0Z9iNZ39jWZ8mcJm2kF2n7udeXWywRxb+
   XFIITZAT/ZWZhdiCoT+uzLC5jzUYdA2FKqJc/0zAA5aHBCMwWg0BCYeYd
   lAvvKpxxM9opmZoUrdU7UQ3jgpzGLP80A5v2wAvL1APBPBGOgo8a3X8u7
   EU63f3+2JX3iAGJ+3o0mU4A0j2ni6AphLd+hthdUaHtriGuO/vJDOLCnW
   hM8gkJdtlaWfeo1KDZqzPD/52shy39ntGcjRbTrXhpYIg0dRGWBsw2DUI
   w==;
X-CSE-ConnectionGUID: OKKFsdk6T8KfcrrXOLC2Og==
X-CSE-MsgGUID: xbThQ1fbTK6mOZ3zVBgUWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="57830895"
X-IronPort-AV: E=Sophos;i="6.15,237,1739865600"; 
   d="scan'208";a="57830895"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 15:59:12 -0700
X-CSE-ConnectionGUID: yhssZv+KT1meyYB0yBxp9g==
X-CSE-MsgGUID: Xyh2hVxjTOeY09kV1kEQNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,237,1739865600"; 
   d="scan'208";a="133669481"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 15:59:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 24 Apr 2025 15:59:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 24 Apr 2025 15:59:10 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 24 Apr 2025 15:59:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YMVVBS718/dc/0QzwhyinuhvCGlzURU9G8gbsVs4q6v4IDCeFKtobqt70S22yNYcJfPs3o/87LxIalN5pTpt+92RhBdkdDtUZ8lN3gUG4lChsHB9EOWo0GAcGhSleENkgnRuI/ySI745y6yv++JbqRvw5sG5glxhxV+7QjKfCPTvm2KXkFbrxXyiOjR0kQ1rdUdkjwaFRUXu7scbElLxCBANKUWHVM6QpCuS5ah0K96tbXAUMy/SgFkwoX0yATBTf45X3brkpj7FLBhlBj/06O5gq92ZZySoONyzotnrPLO2MDrrxqQk6sx3JSQhQ5YlUZ9eJbeaB54tabp46zvSFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k/cfBOb0aqCMvxevBMObmw2h4gS2J9hLTJSyz2qYNS4=;
 b=QsRw1AVUIrpMjZg2j2XPywHbwtpDY8IUqpAB5li85msTJTn90flLqzU12Yf1jIX3NR9f10KWMonHWAIi4dUICgZu+G7A33SC5A51KzRMVfVvBbdcBqvP1jPN+lQT+ebTj98qNa6rJRLGUAsALyaVBFE8ITgJJSguXZ0sXbvMf06xfR9g/lQDAM/6xEZUEcIAwXJNs1GgByghwnPopoK766sUsfgxamZp3eSbJ5LHTZtUa0FyJUoBqsxRQT1qsppFCQmTrGx0V9XLpEAVNJ/U++nEsS6UL8o6GxoyFpWvrlkWY5Cny/5yO5xUM3upEr93mEgZ9L62a1S5BoK4Lpalcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8773.namprd11.prod.outlook.com (2603:10b6:610:1cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Thu, 24 Apr
 2025 22:59:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8678.025; Thu, 24 Apr 2025
 22:59:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Bae, Chang
 Seok" <chang.seok.bae@intel.com>, "levymitchell0@gmail.com"
	<levymitchell0@gmail.com>, "samuel.holland@sifive.com"
	<samuel.holland@sifive.com>, "Li, Xin3" <xin3.li@intel.com>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "john.allen@amd.com"
	<john.allen@amd.com>, "vigbalas@amd.com" <vigbalas@amd.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"aruna.ramakrishna@oracle.com" <aruna.ramakrishna@oracle.com>, "bp@alien8.de"
	<bp@alien8.de>, "Liu, Zhao1" <zhao1.liu@intel.com>, "ubizjak@gmail.com"
	<ubizjak@gmail.com>
Subject: Re: [PATCH v5 6/7] x86/fpu/xstate: Introduce "guest-only" supervisor
 xfeature set
Thread-Topic: [PATCH v5 6/7] x86/fpu/xstate: Introduce "guest-only" supervisor
 xfeature set
Thread-Index: AQHbqeltJw24GvQSFUu4UUSmojSyHLOzhRqA
Date: Thu, 24 Apr 2025 22:58:59 +0000
Message-ID: <79e087f7e8e52fbe82ede9169bab587bac42ceb0.camel@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
	 <20250410072605.2358393-7-chao.gao@intel.com>
In-Reply-To: <20250410072605.2358393-7-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8773:EE_
x-ms-office365-filtering-correlation-id: d80e619e-3699-4bfb-ae06-08dd838399bb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?SU8zanV0SmZLTS85aDR5WU56SFpvdVZoZFVBTkZGR1IyYUtqeEd0dHArcHAx?=
 =?utf-8?B?R3RBWHlzVzBHeGFmR2VHb0t1NzNBR2laWDZUT3hJRy9UVWMrUWdPQTJCUk9N?=
 =?utf-8?B?S1ozWkFXZ1R1QXlGWFNENmROTEpaWWg5KzlYNHM0Y05LTFJ4S2NLLzVlZERO?=
 =?utf-8?B?YjdrWXNPZ2UyZ3VYb3gvaEwwbDRHaE1DWkl1RUVNc3hBb3R0RDJJVmN3dnpp?=
 =?utf-8?B?bVdyNlJxTVVIbzgzOEpWMDJtVnhsc3g1cEoxbFF4a1ovUnJtN01MU2NSWGh1?=
 =?utf-8?B?VU1CWjNwOGhuUTZ3ekNBc2Z4NFg4T2ZxTXZIRS9abW0ybzI3VDExZ1lxVjIx?=
 =?utf-8?B?NGRpUWNwMk1rMEJxd1F2ZnVqOVIrOGc0UHRweTJXWlhRZWpqQ0VnTCtkVm85?=
 =?utf-8?B?bDNWR2lSVjNvdittV2xLeUhHeTFHQXFMOFU3RVV1Mkp2cEkvV01MczVrV3VZ?=
 =?utf-8?B?WVY4SU51c2Zycm5SUEJZSm52V0pPbGJVN05lU0lFRUNsbjdrWm1SZUVUczlw?=
 =?utf-8?B?Q3V5L203OG1ldk53R1VKUXVMa3J3eS9oREFIK21UMEprTHFld1p0VENLUXQx?=
 =?utf-8?B?S2M0SVJkeUducDBqR1FQdm9MbHprRzRzUDVqN2s3VDRoUGRTajl6bFU2Unlx?=
 =?utf-8?B?Z1lvdVhyM3hwZmZwaVlPMWx4Qm1wZjV3TXBGOE5IcVo2U0x6WGZwaURFbGV3?=
 =?utf-8?B?bVliT1pSNllxa0o4MzdZS0kxWGFudmFzUUZBOFJyZFYzVTFDemFqRnFGRFNk?=
 =?utf-8?B?bFFIQzlkUk9xMFY2M1h4VGY2M2MzNHhDTThZbThsRGo0a1BpaHlkc0ZyTSs4?=
 =?utf-8?B?WU4wUmJtQUkrc2JYbVgySGxGY092YUR2T3QxZmFpczZUa3BLN0VRdWdzVkha?=
 =?utf-8?B?THdoeGtqT1l5TzdlM2YwcnR5bDRONlRhRm56elJFVUIvVHMveFRiWFhEK2hW?=
 =?utf-8?B?K0kzdVcyUUp5SVhXRHRIRS91M0JlcGtzc2VBYWtncHNFcWpoT05nYU8zWFl5?=
 =?utf-8?B?M0IxODFWR2tiUHBZSTdNZmNKYTB0eC9NWlBwbG42ZkwweGs4ek1wN1IwQi9k?=
 =?utf-8?B?ck5HWmJrUFkraXROVzZiNU01OGUweVAydkhzVzdtZ2ZsNGVpMXdSdmdtdEha?=
 =?utf-8?B?cmRYMVlnSjd4N21qSWtjdEZuTXphWEJ0L2ZrSGg1VStwZ2J6bHdqdFFZVlkv?=
 =?utf-8?B?VFNTbmt2K0p5ekg5MUJFVlE1OWNtWmNDSzg1bW9qZkEwSG5USVNhR3ZoM2gx?=
 =?utf-8?B?KzJJcTVtTTdDaC9JbVh5VEtkdi9RblkvR3ZNRmFtUWNJYWJVV2FBWXJ6ZGpu?=
 =?utf-8?B?anB3NUxvSzZ5ZjN4U3pZb2JHWXN4NU10L0szSnlLNFlQQ3NDVGphM2ZJUjJh?=
 =?utf-8?B?cGRFbnBmZ1pGdENJY2lVTmdjdUFTWktDeFJpLzU3cHpkY29zQlR2RVBKSVg4?=
 =?utf-8?B?SklxTHo3U3F6UXZWMzMxeU81V1MwR3VpNWZRUHVGazREYkZhVkVLNWNyQTlT?=
 =?utf-8?B?OHN2ejRVOU5aUEkvcVp6ZXpCdVFYZFBXMkpHKy9TTWhLRnAzTDIvalFoMk5K?=
 =?utf-8?B?WXlPZEtYTndHQWtMNy8wOEp4Vk5GRzRzcFpsOTZqZnMwZEh5VG5laG04QkVt?=
 =?utf-8?B?dXpzVDRjdDVqQjNnbm12aTZ5ekRzUzZ2WVdaUkRIVlYrRWRnVTBoM3B1dVQx?=
 =?utf-8?B?ZWpjSzY2OW1TSFZEb0pWNkZFTWVEbXZvcHBGRzFBcEw2V0liMnNpRXBtSEw2?=
 =?utf-8?B?c0M1b0czbjYwa1lKYlkxSEsrNnI3Y1VPalZhN3FlY3Z4TGpTenhOQWFQWmRw?=
 =?utf-8?B?QmhGS0d5anVhZVVnSVUwMG90UGlIQmppS0h1UXlYYStkVlEvVmxHRWMwK3B6?=
 =?utf-8?B?b0t6V1kyMnNWdWVBSW0rM3o2MVBwYVlzSk5OdHIyN3ZpTWdrK2gyZWV0aTZV?=
 =?utf-8?B?bnNLVjhIZjBFRUFyVmZ1MzMycWNkbFEyTjkwV0JMcDdYQ05mTy8vdFpSRVJk?=
 =?utf-8?Q?+g2WgNO22v7s0OTodJo1ZP+YDVSd+U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VDFFSnBNbHJWNTRpaW03TUhxM3Q5WnZCQVlmbXVJbFhXRzNkV0JsTzhkR3V2?=
 =?utf-8?B?WncyUExyY2hxY1kvRExKWTNTTUhBcEg3cm14ckhpelZnbjJlbnpMZ0ZsSTNH?=
 =?utf-8?B?VnBLYTlpTWFsbmVPTFBJUjM5alJTMk1XNGhWODdLOS9hZnJlbzJTSGx0bkU3?=
 =?utf-8?B?Q2RaTi9naFQ1S3o1RHpidUJUcUlSa2ZIeXZXNXVtSWZhTUhFekNrYjVWcE92?=
 =?utf-8?B?NXFjakp2QUF0eGdLMlhzeDFFaWFPZFl6Und0Y0pIQm82OVNIUFZMZHpiV1BX?=
 =?utf-8?B?bXVIWUtqQlNtcDkzV1RuV3l0L21FNm1YOWcxYSsvZklDWDMxZjVnZVBKVWJJ?=
 =?utf-8?B?dUNnTDBuSkh5bDdtSzhTblRqN2huYk83RnhQMml0UHcrb3NlaUZHS05veGVj?=
 =?utf-8?B?MTRRZTFpUnBLa2dUeHM3U2lLc25RTlk3eGwrdTR5ZjYrRzdHUmtlWE1BR09y?=
 =?utf-8?B?Rjg0RkJSK2FBVnIzbmtGcWNFbG5XU1E0V3kzd2UwSC9zK1BXTUttcUNzMmVG?=
 =?utf-8?B?QjdFQWdhdGUyeEVYdXdpdHVzTXdaMXJxNnU4R2JNc1FMOTZTbW03Vzd4WXZz?=
 =?utf-8?B?MVlMSlhiWGZTb0VVRFFCMmd5L1FZZjQ2WW1Jc0ZnUUNTOUgzaXE3U0hPbUpj?=
 =?utf-8?B?SThzVUtnNUkrMDZJYzhjQjEvU245b3Y1RW9zUDJVYXBmRys3b1J5VVZHSGlB?=
 =?utf-8?B?T05lcjd5N3dZV1ozWEhjbENUcmdTNUxDcWNrSi8vLzVodEFNOU5ocGJ6dllH?=
 =?utf-8?B?L2tUeEZUTms0NUlncEZJckIyenpjTzJtS1NNVjJGQnVoUVpmSFBHaGdCSmNO?=
 =?utf-8?B?OWpCbzlvaGxtVUoxcWlSZG1IekFWZzZrNjIrUHBrdkV5U3EzTEdncTF0czFh?=
 =?utf-8?B?WGVkVEhBQTlJNkhiR1VBaWgrYlkxSVRhTnhuWGQvd3N5Y2ZQSDRTaS85OWhG?=
 =?utf-8?B?cThzb1VaRnczU3Zxdm81ZVE2NE5yOE5tK0I1YzdrdEVkc05ReUVKc05ibDNH?=
 =?utf-8?B?UURadDVhMTdDb3FHLytjRlo4ZzFCU1B3SitlemQva3BVRVBxbUtQUjJhNkZD?=
 =?utf-8?B?eWlTN3VaU0I2VjBaZHlRTTlPUnNiZU1Tby9iNFBiSmoxMjJCVExBalBOYU4r?=
 =?utf-8?B?UUlVSDJPbkh3Sm5UOVJOS2tudkZXcmdOd3NQeUxRWHZzZFE4eGpOb1h3RWMx?=
 =?utf-8?B?VzVxUEF4dS9lajZ3bFNXbGJ5Q2FZd2lSR0ZQeUFsYnM5akdUSlhTdjlMUlgz?=
 =?utf-8?B?SWZLMEdpYzJYRDJUZjBWMGNXY2JGTUdYWlNOQW1ycXpxYVRmVzhRL1B2RWJU?=
 =?utf-8?B?Z045UnRqYW83OWZSSUMrYytmTjN2dlFnQ2dtQnd0RWM3dTlFYnhuUWY5ejRs?=
 =?utf-8?B?aVJub2NEamxoaVRsR3NhUTErbGkrUFAvcE0ySVRuZmhtV2cyeGRwa0paLzNG?=
 =?utf-8?B?eWlvR3VUM1NHOFkwRWFHZmpFNWN5MDl5eGJxVjdGRWhucE9qamZhdzlXaGdJ?=
 =?utf-8?B?K1J3SGZKSis5VnFxckVjVGFVN0tSdTVQNm1BaUcwcEtmMjlpYkdOeUpXK1Mr?=
 =?utf-8?B?OTQrRzJtRzcxcDRXcEpFeTRXbzRFZG8yMC9EL2NNSW1LQ3VuSUJWb2NML0Ji?=
 =?utf-8?B?ejRZZTl0dllhVjI4UllyWHpPU3ZtenNwSktXUTd5THNWU0hCQXpTV1g3UHVB?=
 =?utf-8?B?VnBwTmUyYllWK2JXdWdqZmhSc1cwSHN6Wjh3b0JCdHdxeDRhSE5xWjhNaGNl?=
 =?utf-8?B?VzRseTlHckxXN080K1NkQkJXK2pCaFJmT0pHN3VqdFAxWW1maUtkV0RQYUFq?=
 =?utf-8?B?UlZNZkhsdkc5d1ZVVUtKTnpoWU94OFNwZnFDYUpwMGtzdHhiaWRzbFVieVBQ?=
 =?utf-8?B?N0FaV216dElCbzN0b2ZyQmlhVE9pa2xvWWRLaWlPNEZmM3pwNlZZdVNiaDN4?=
 =?utf-8?B?SmFzcm5MeXR5U0lNNE04a1hnRDc1cnQ4UWJGb1N5NXp3MUtqTXBxM2w3UWN1?=
 =?utf-8?B?RXVwNk1pWVBwUHdSbHowK29pN3hTNUs1QjlOSTVXbURGSWV4blBYRWFhbXY4?=
 =?utf-8?B?dDRXSkJjTGRDcGtMMW5qczl0S1g3T25raURreFlNTG9iaHBSRWdXUjJuZ1BP?=
 =?utf-8?B?NitxWTRaK1NlWHZtNlZWQmJjL1g1R1pWc2ltRy9aUTZoNlVEKzY0VmhuRi9V?=
 =?utf-8?B?SEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EAE91952DE4FB84D92CBF3FB53F5B82F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d80e619e-3699-4bfb-ae06-08dd838399bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2025 22:58:59.9443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lqc/pA4Ehhx0sESbJzFLSTVbB5k9yLOV9puwAxCdIFmH0UOvtVN6EkyAMdl8XZ9WPhZ1aMxR+rZ3Y70xjvzAo2ajIb9iHF53amV/U8UJ7BM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8773
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTEwIGF0IDE1OjI0ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gRnJv
bTogWWFuZyBXZWlqaWFuZyA8d2VpamlhbmcueWFuZ0BpbnRlbC5jb20+DQo+IA0KPiBJbiBwcmVw
YXJhdGlvbiBmb3IgdXBjb21pbmcgQ0VUIHZpcnR1YWxpemF0aW9uIHN1cHBvcnQsIHRoZSBDRVQg
c3VwZXJ2aXNvcg0KPiBzdGF0ZSB3aWxsIGJlIGFkZGVkIGFzIGEgImd1ZXN0LW9ubHkiIGZlYXR1
cmUsIHNpbmNlIGl0IGlzIHJlcXVpcmVkIG9ubHkgYnkNCj4gS1ZNIChpLmUuLCBndWVzdCBGUFVz
KS4gRXN0YWJsaXNoIHRoZSBpbmZyYXN0cnVjdHVyZSBmb3IgImd1ZXN0LW9ubHkiDQo+IGZlYXR1
cmVzLg0KPiANCj4gRGVmaW5lIGEgbmV3IFhGRUFUVVJFX01BU0tfR1VFU1RfU1VQRVJWSVNPUiBt
YXNrIHRvIHNwZWNpZnkgZmVhdHVyZXMgdGhhdA0KPiBhcmUgZW5hYmxlZCBieSBkZWZhdWx0IGlu
IGd1ZXN0IEZQVXMgYnV0IG5vdCBpbiBob3N0IEZQVXMuIFNwZWNpZmljYWxseSwNCj4gZm9yIGFu
eSBiaXQgaW4gdGhpcyBzZXQsIHBlcm1pc3Npb24gaXMgZ3JhbnRlZCBhbmQgWFNBVkUgc3BhY2Ug
aXMgYWxsb2NhdGVkDQo+IGR1cmluZyB2Q1BVIGNyZWF0aW9uLiBOb24tZ3Vlc3QgRlBVcyBjYW5u
b3QgZW5hYmxlIGd1ZXN0LW9ubHkgZmVhdHVyZXMsDQo+IGV2ZW4gZHluYW1pY2FsbHksIGFuZCBu
byBYU0FWRSBzcGFjZSB3aWxsIGJlIGFsbG9jYXRlZCBmb3IgdGhlbS4NCj4gDQo+IFRoZSBtYXNr
IGlzIGN1cnJlbnRseSBlbXB0eSwgYnV0IHRoaXMgd2lsbCBiZSBjaGFuZ2VkIGJ5IGEgc3Vic2Vx
dWVudA0KPiBwYXRjaC4NCj4gDQo+IE5vdGUgdGhhdCB0aGVyZSBpcyBubyBwbGFuIHRvIGFkZCAi
Z3Vlc3Qtb25seSIgdXNlciB4ZmVhdHVyZXMsIHNvIHRoZSB1c2VyDQo+IGRlZmF1bHQgZmVhdHVy
ZXMgcmVtYWluIHVuY2hhbmdlZC4NCj4gDQo+IENvLWRldmVsb3BlZC1ieTogQ2hhbyBHYW8gPGNo
YW8uZ2FvQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQ2hhbyBHYW8gPGNoYW8uZ2FvQGlu
dGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWWFuZyBXZWlqaWFuZyA8d2VpamlhbmcueWFuZ0Bp
bnRlbC5jb20+DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5l
ZGdlY29tYmVAaW50ZWwuY29tPg0K

