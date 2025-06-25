Return-Path: <kvm+bounces-50728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7C15AE88CC
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:52:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 131483B7E0F
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C982729B771;
	Wed, 25 Jun 2025 15:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NLcU6Pq1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C0F1C6FEC;
	Wed, 25 Jun 2025 15:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750866701; cv=fail; b=RG+7Bz62wcUCUe4bgiJVZ7TRauzEEtaJwUqAqYRITj3ybJei0YYdOu7YVBR5IMSSEp1GLroYkOJpdzQbNpSHgnEdZZaFMmYBULscB5yQji+C34Qpf2hYXgAPyX6c9xYzGxGMioo5eVzj5pQYkfj81sSgdGzcIQblM8Al9T1pEGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750866701; c=relaxed/simple;
	bh=xzbmqaP6nv2htlWtq5L19M5fFDM7MpLzwfUV8kui8BU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ve+xwc1xKETg9yBOrhQ31hpHJdQLztyqsSnnl6WWBN/rOyRP18YPXhuP2v7ehCnUcRl9ovkm3rUOkP/Pr2HOrBpKQlohm/8ECh/w0BaWLJmUdvDkmXQq4BGzutmDe7E+Tv1lnEnZqWcUrZywVEA2L+gqJdmAlAr2D7oH38gG9q4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NLcU6Pq1; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750866699; x=1782402699;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xzbmqaP6nv2htlWtq5L19M5fFDM7MpLzwfUV8kui8BU=;
  b=NLcU6Pq1liu5xWQWXxQutAnl2lmoii6GLT9eTTNyAL0Vy4Rv3Yh/JsdF
   lN5LwZyAj+/phxuvd9Ger3yVs1hGq7+sOjniiUpJXiXsJeT17uSrQvgfN
   G1mRxH+WxkK2R0ZDShYJL+keoIGQuPqxasJz3lTWPeNl/tFsBRtIRjYRS
   8PiOLZ8QrVZPQbhfrtrv1/4y1GqOYeruHYPtS/QdWc8mhiYTI3mdJqmeZ
   mttEVqcIULqK/DRpxuhJ0WvAkcP1WtWGFbk6BscQmbaHjK8YqUqeIDMN1
   5F4B1E4TximiWTalmD6HBDYVTGLheX2+DrTPByZNM2/H3yGjSoCnanbqF
   A==;
X-CSE-ConnectionGUID: /L4HPZuDQLadCH1fi30Zyw==
X-CSE-MsgGUID: bNvQryvMTWy0dniRs+hEjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="53014872"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="53014872"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 08:51:38 -0700
X-CSE-ConnectionGUID: qN19t0prTkGDS+vZytR4wQ==
X-CSE-MsgGUID: RtPRMyYyTZyM5TudNSsQtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="151683211"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 08:51:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 08:51:38 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 08:51:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.88)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 08:51:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t0XUQpodq6MWKks5yVNGkyYG8vy3LH3BnVCQIYjSWroaAZhOgij5KcSJ75iyJDV9dSNWkPqwFjDtdg04r2QzQZBUdFtMg4WmaWsfUHy3ghFuTfOdqNzxmeI0bqPLid9k1ezfB7w4v1B7HuMTmzkSrlJM2clODmEiCMb8TGR+1HebNaMsYPYweZ/aNbe/9xtczoGnwwVkXxhmrlRXR+rzELKi5FsiA0Jasbx9nMn4y7Nozha1xhQSXms3mCU54xrZC1pyNVXAcwYnNHkKY9KEbSpFaQz/ER7SPnP+NMqTGWMLxdsEA57JGJkCpK8WAK+eOkl/QrTLqrXG7aJDvbP2lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xzbmqaP6nv2htlWtq5L19M5fFDM7MpLzwfUV8kui8BU=;
 b=kNekG7J1Ov2Iabcq+GGLiRk3vunsTnRe8etLqbVmiXEH8n/IsbZJlWYkms72T9mfZxUATKcr2yI1iazw9Uh5+CWj8JS8c+vmqTQlH+YfaIFacj/zmyeNiyrp5eVakl0a+udLI9W+xOLY655NwlGo3cxcgBrFX+E/ioyRYAszYUGOxoeIwsVDGatMoWwfTwmmLnCOMq0dfvCG+AoAueZxBEdiJK1oCXvcH07KmFPZopxu46NFiwSgKFl1It6p5gaP4Nxx80KE/Zf5x9jRgROlssJvk1/zL7KNWG7SvXG4dzWbCIEzb7ZOqi2LtU7qY+s7M6Sy0w1CPh1XpIjVHXR6Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7089.namprd11.prod.outlook.com (2603:10b6:806:298::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 25 Jun
 2025 15:51:08 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 15:51:08 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "tabba@google.com"
	<tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESAgAALWQCAAAHGgIAABSeAgAAA3ACAAAyHAIABVQyAgAAHeoCAABSygIADYjmAgAFIQYCAACKZgIABjCaAgAQxHwCABQ5egIAAzNwAgACQ3gCAAUHIAIAAInwA
Date: Wed, 25 Jun 2025 15:51:07 +0000
Message-ID: <d92b841268888d2e41cd567678a412b2bd829a0b.camel@intel.com>
References: <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
	 <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
	 <aEyj_5WoC-01SPsV@google.com>
	 <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
	 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
	 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
	 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
	 <aFIIsSwv5Si+rG3Z@yzhao56-desk.sh.intel.com> <aFWM5P03NtP1FWsD@google.com>
	 <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
	 <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
	 <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
	 <CAGtprH_1nMC_z+ut3H6Hjjjb9J=sg=h-H10L9PVK+x=Vw2SM0w@mail.gmail.com>
In-Reply-To: <CAGtprH_1nMC_z+ut3H6Hjjjb9J=sg=h-H10L9PVK+x=Vw2SM0w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7089:EE_
x-ms-office365-filtering-correlation-id: 1b9135fd-ba8c-423e-6a00-08ddb40019ac
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?S2FkRlZadnk5TnBiam1JSUtiOTdLelVYcERKKzNGcVNNLy9EeG5tWGJxNGhE?=
 =?utf-8?B?OHc2UEovd1pHWlhGZURSd1JZczR0SWZhSWk4SFJYMmMyeTMzeGhWL1FubTh4?=
 =?utf-8?B?ZHpWRkQ2UW5sQVhMbGRiRERKUk1PS0p2TmE0ZStPL09McHQ5aUJ1QVZwR0dw?=
 =?utf-8?B?Zlpwd0JTaGZyU3ZESEJkeEJJbURRdE9hOENnQXlxVWlyRng5RVBIUG53VHdl?=
 =?utf-8?B?cW5lbklVSGZRdVVGZjdvdEltdTA1MVVzNk1lSFBIa3FINHkvSkhab2lQbi9J?=
 =?utf-8?B?Mm8zR0xHajZRc095WUZTajdvYVVOOUlrWDNVRytUeDQ3ei9ZNkdBNC85UkxQ?=
 =?utf-8?B?dTRFdCtXU3FPTDlVa0IwYWFvRlJCc20yOVF5YVd4c2hYSVdMaGlNTkNWK2p4?=
 =?utf-8?B?ZWQ0anJ1YWdsVExlenBSMVdJSDY1dlcyWlVudktkT2czNThTRHhqUVNFM3px?=
 =?utf-8?B?emhTVjg2anZTalhUMkxKcGRheTNRUXpJUkR3a3k3MXpsTVFZeUhnMjJxeDJG?=
 =?utf-8?B?SVZGNkRwR1FpL3hpU1B1NXFLZHVqSmZ5RW5uOTY2VVJxQjNzRU84MmlNR2pK?=
 =?utf-8?B?Z0Y1WGRqUG5vWmdpTkhxTlg4dDRSOTBBRDcxMWxJR3JwSFd0VU9oS3hRZ29B?=
 =?utf-8?B?aGwvL0pHaWZPems2QnBaODhFeVhPY1B0NENTWlNoc3QrbGtTMFYvSnRaZ01O?=
 =?utf-8?B?TzY1dWVEQVZHZkV5QTY5b0krOFYxY2VhcWtiSHBqeVlTenFPZVB0aFNtYWRy?=
 =?utf-8?B?RDFsM0pvU0dHeWtUQm9SN3owZ1ZEMzM1K0U3VnNJUmdoYkMyUHpLUmJwRW1Q?=
 =?utf-8?B?WVZOcGtSVGo5TC96eVZ2NHA1SHVQdXV6K0tPR1dzL0U1WmZ3U0hDRHRBV0dG?=
 =?utf-8?B?RW4yM0taV2d6bUNBbm5Jc3dKczhyUVM5RERkbHVuUWFmeEdydnhlWEtmeEpB?=
 =?utf-8?B?cFpGekhsL3FWRURqTGtVUDNjK1l0bEh0ZlNhWFFLUDlLYUdLSEVZUTlnSi9L?=
 =?utf-8?B?akk4bmhVR3VpUDg3eWNXWWN3dU9OajR3RUxZNFgwSDBIVXBoT1NIdy9vdzJY?=
 =?utf-8?B?T0hrYzJMS1hUb1NubFhsczM5eUxYTVE5SDBHU0l5K284aUtUZVNpSXQ4Z09N?=
 =?utf-8?B?UTV1L09ZUHplUUU5blFmRUovejdKRElpNDF6c09NVXgwYjNjQ0JvUDdCUWp0?=
 =?utf-8?B?dHlpSE9vTk9VVHdUSXIwZUZXNWd0djlOdU9ERUpzcGZSaXhidlR1QmJDajNx?=
 =?utf-8?B?TkJpa2hRTlJ2cGQ2OTArMGVMbUlpblpQZW1EdmtWUzZxbW5NN0tMTTkxekJh?=
 =?utf-8?B?NmhUZnFTOWJJNCtMQzNoUW0wQWxMOXJHSkpzM2FwL2tGYUhoY1V1TitHZ3lR?=
 =?utf-8?B?Mk5GUld0TkM3U2xpYWpleHZSeXpmRjEwT3A5T1BXYTlMZlQrbk82dWt4SEl3?=
 =?utf-8?B?T2NJOTJXdzN1MFpGQ0M0NUQybTFVRmFtenlwWGVHZTJIR2x3bWRYTjU2bjZO?=
 =?utf-8?B?cnpOYkJhODY0Z0NlRjNkNFdka29NQzFHdDBkWmRCL1NHMGFWWFdub0ZYSEl5?=
 =?utf-8?B?OE8zazVtWCthMm9oYWZ6alJNWWVxWjZNUEd6aDhLcWh1OWFLQjBrZXFIdCtp?=
 =?utf-8?B?cWNpSTdxUmlSR3ZtcUoyVFBYcTRjRGhWUU01bnNhY1hmeEI0WS9NeGxQZ0k3?=
 =?utf-8?B?OHJyMzVCbWNRWmtTa0pCUnMvOTlLbDZmVW9ROHNNYzFjcGQ0Nzh2Z0JUQ0pX?=
 =?utf-8?B?QUNjOFhuZHZGYnVWUGpRNFN1bVE3aHU5UFNKeVN0T2tmeHMySFJtMXJ4cWdT?=
 =?utf-8?B?WWhjdjNaNDRWYWlrZDBFUmllSWtHTXp6OHZkSkVGRldxMEMvU1pBU0k1T24v?=
 =?utf-8?B?R2cvSjJzUzVvQmYzNm1BUkRWM3VaOHhsTzluUy9VWG9uaUtnL0JVdlRPSzMr?=
 =?utf-8?B?cFlpVSs0M3FHQWJ5VlhkRWMrNWJybXduMDNTQzJhbExnc1RIVWhXSUdsZUFj?=
 =?utf-8?B?ZzZ6d296aUJRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2dlUkJiOHJKZ3pBODVEdDFyeWZkL29zY21RYWtkZVNCYVBwalFtR3hmZjJD?=
 =?utf-8?B?SGNQRGFTa3lONUF0YUwydWd5TnNKdk9JWFNaTHMxNVgwdHkxUFlFeXlkMjhS?=
 =?utf-8?B?WnhRNlNLZFJtM0wrMEo3cDJ3b0EvK1lPV3dkQ1YzeGp3RktoSUwzYTJlNXRK?=
 =?utf-8?B?SVRNL2s1RXFxRTZwSURocFJtYVdJM3grQ1k3b0ZubEI4eEltYUVtN3kyalNV?=
 =?utf-8?B?b0FWUFE3aDh1V3pYYVBGcHpQRm44UlRLY3FFdlFJWTJORUVRU20vSTgrTjB0?=
 =?utf-8?B?NXo3TkUvNUhyYmlYcGpxRnZNVm4yQmFBZzByRi96WStvZWRPNGEwT2hxMXdy?=
 =?utf-8?B?UzBiZEZoWFFsd216NE9qb05PN25hRExGS3R2SUI0WW0xdDBrUE05THBCUEdY?=
 =?utf-8?B?aU1wcXFiVWtPblFhWjBKMzk2a3dsMDY2WThQU1k3TTFQZFYya3M1SGhaNGky?=
 =?utf-8?B?bnAzUkFwampJOGJVaWZGVkdzVjh6RTNrdXVQeWNZRDZZMUpKTGJUTFJMb1FK?=
 =?utf-8?B?SlpjMjI2Z0dRTWFwUmE1U0ovSFpGc2ZjVC9jOWtUNFFPdzRZMW1oSEoxVjFW?=
 =?utf-8?B?RTFISFp5SXRpb1Y5dmgzNEJZRnFpVTZxT3hNWU9wYy9oTjJjdXNYc3VaSUk1?=
 =?utf-8?B?S2JpZ3k3MnVSN25CL0VSakRzZnNJaXV1NTlrc1JBMktyWm1CL1BsT05UMGZE?=
 =?utf-8?B?ZWFvcS9IU3NjY2t6TGFqeUVJS0xrZjQ2M0hRVHlhUmJSa1pFZHZDdXRGOG81?=
 =?utf-8?B?NEJ2R0tOZnQ4UVE3SmtJWVhXVEQ0eTN0S0FJRTJNcVZJMkFndWVsdnBESkdx?=
 =?utf-8?B?N3lTVDkzSzBCdElQaWFIR1JDaUhlNFA2Nlo4ZlFkR1F4K2xFKzE3NWw5YzB0?=
 =?utf-8?B?Z3JsYmh6VTZ2Y2lyRE14RHVkL2NVazJ5cjczbzJvVkZaMUJYRFBqTUdPTi9o?=
 =?utf-8?B?T0ZNM2NUSHB6cjMzWDFoclVmay9odzhwSGtnNlBrWlMzVVJ4YW1IbzRPSmli?=
 =?utf-8?B?WWQ1R0lFM0M4cEVqczhBMk5HTkpvSy9wYnZJMFhYdEVybVN0MVVtK1VZcS9o?=
 =?utf-8?B?dS9QL25lR3hWakVLVC9LelJLeEUrZ1FBYlRpRUxjYitRNHdMZDMzZHB3L1ps?=
 =?utf-8?B?aEZYVEhCcy96TEJGS2FLWjlqQUh2OUQ5SUJzZ3VrTStzVkxQYmFlcXNHOWxC?=
 =?utf-8?B?MlFYMWM4NXl0VGt1TmtlSENCNFRxdnE0eEZIOWJIRVluTjBtMlFtbWdZSEUv?=
 =?utf-8?B?QndkYU1TSUQxeXRjMmp0RHZKVDk3MURLOUVxU0RGNlVxejQ2akVtcWV0VTQy?=
 =?utf-8?B?Vm9YYWlNQW85R1ZvYUVSODNuWWZCZkNGS1dpeEd6TmhuUkEyeXFmcy9sdTFw?=
 =?utf-8?B?VHRYOU9tNmdydjZMY244WGlLc00rb2hxY2NrOVZtSnBzZGdQRVRSU1AzejQ4?=
 =?utf-8?B?QW1OWFJDUTJCZUUwRzhpbjF0SVJPZ05JNGFRcGxOK3pUdFI5ZHFQSkx1SlM0?=
 =?utf-8?B?ME0vVGhLWlFseUVjVXZLRTJLeGR1TUJ4cEd0VGRZNlVHaElVNmxaQnNFclMw?=
 =?utf-8?B?VTZjamU1Vm5NRTByQk9iYjNhZUdOS0doQnlOVFE3d0VBQVBTdkFRRUdxLy80?=
 =?utf-8?B?S3pGNjA3WU02cVZFRDh3K3cyN2RhMDlTMHM5UlMzMkpjOHN2QkdGUjJhT2tB?=
 =?utf-8?B?Q29VYkJ0UHZiRG9xQUFqUjk4bGVSTUw3ZWp1d2JVZ0pDRkFKQ3BCV1pxYkFX?=
 =?utf-8?B?TE1zbFk5Y09xaTBJZHVHM242OVBxV0p1eUpGZGpUUG1wTDZYVlpmdk1MYXQ5?=
 =?utf-8?B?bXBCcnR2MzQwY05kYThqRFZYSVhwSDdybFlPNTR0VnlXVjArV3BBUzhRWTZi?=
 =?utf-8?B?UmJlQTlIQjh4YnF4MExrejZvSmVkYkFxZmd2dnQ3d2x2cUtxY1NPWjBlK2FK?=
 =?utf-8?B?WDZuUGhQVGhWSzZzRkpZVW9pSDkxaXB0U1ZRaG9mUnlCMHZ6cE5QcVorSGEw?=
 =?utf-8?B?cEdqSmo2ZzI2bWNDOS9Oa3ZUN1ROM052WGNNN1pTWFQ1ZFFUZW9sOFgzTE5G?=
 =?utf-8?B?eGVqWGFvOElMY08xSEdpQnJCL1ZRb0x2bnROOXdwaTlLTG9MMklmbFJEZkNM?=
 =?utf-8?B?M1BLbWFtUDhTaVBRTXRQMmU0ZmluenhBdjRxSnhWS29iRC9nelpnWWY2RENG?=
 =?utf-8?Q?Nm5/iB7IvxKsf/Sj9liCcZQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B39FAA617218BF499348B68ECDA3EBF9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b9135fd-ba8c-423e-6a00-08ddb40019ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 15:51:07.9890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GxY40YYCfBIJOhtX4Vjxo8R/2ZYhd5OrKlST2RpiXRoCxZa/28MDDneNdYilM9kI7hneKOaG0N9BUQ240ps/SF7gtjfF1D0xAxPvLS2lkLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7089
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTI1IGF0IDA2OjQ3IC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiBPbiBUdWUsIEp1biAyNCwgMjAyNSBhdCAxMTozNuKAr0FNIEVkZ2Vjb21iZSwgUmljayBQ
DQo+IDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gLi4uDQo+ID4gRm9y
IGxlYXZpbmcgdGhlIG9wdGlvbiBvcGVuIHRvIHByb21vdGUgdGhlIEdGTnMgaW4gdGhlIGZ1dHVy
ZSwgYSBHSENJIGludGVyZmFjZQ0KPiA+IG9yIHNpbWlsYXIgY291bGQgYmUgZGVmaW5lZCBmb3Ig
dGhlIGd1ZXN0IHRvIHNheSAiSSBkb24ndCBjYXJlIGFib3V0IHBhZ2Ugc2l6ZQ0KPiA+IGFueW1v
cmUgZm9yIHRoaXMgZ2ZuIi4gU28gaXQgd29uJ3QgY2xvc2UgaXQgb2ZmIGZvcmV2ZXIuDQo+ID4g
DQo+IA0KPiBJIHRoaW5rIGl0J3MgaW4gdGhlIGhvc3QncyBpbnRlcmVzdCB0byBnZXQgdGhlIHBh
Z2VzIG1hcHBlZCBhdCBsYXJnZQ0KPiBwYWdlIGdyYW51bGFyaXR5IHdoZW5ldmVyIHBvc3NpYmxl
LiBFdmVuIGlmIGd1ZXN0IGRvZXNuJ3QgYnV5LWluIGludG8NCj4gdGhlICJmdXR1cmUiIEdIQ0kg
aW50ZXJmYWNlLCB0aGVyZSBzaG91bGQgYmUgc29tZSBBQkkgYmV0d2VlbiBURFgNCj4gbW9kdWxl
IGFuZCBob3N0IFZNTSB0byBhbGxvdyBwcm9tb3Rpb24gcHJvYmFibHkgYXMgc29vbiBhcyBhbGwg
dGhlDQo+IHJhbmdlcyB3aXRoaW4gYSBodWdlcGFnZSBnZXQgYWNjZXB0ZWQgYnV0IGFyZSBzdGls
bCBtYXBwZWQgYXQgNEsNCj4gZ3JhbnVsYXJpdHkuDQoNCkluIHRoZSA0ayBhY2NlcHQgc2l6ZSwg
dGhlIGd1ZXN0IGlzIGtpbmQgb2YgcmVxdWVzdGluZyBhIHNwZWNpZmljIGhvc3QgcGFnZQ0Kc2l6
ZS4gSSBhZ3JlZSBpdCdzIG5vdCBnb29kIHRvIGxldCB0aGUgZ3Vlc3QgaW5mbHVlbmNlIHRoZSBo
b3N0J3MgcmVzb3VyY2UNCnVzYWdlLiBCdXQgdGhpcyBhbHJlYWR5IGhhcHBlbnMgd2l0aCBwcml2
YXRlL3NoYXJlZCBjb252ZXJzaW9ucy4NCg0KQXMgZm9yIGZ1dHVyZSBwcm9tb3Rpb24gb3Bwb3J0
dW5pdGllcywgSSB0aGluayB0aGF0IHBhcnQgbmVlZHMgYSByZS10aGluay4gSQ0KZG9uJ3QgdGhp
bmsgY29zdC9iZW5lZml0IGlzIHJlYWxseSB0aGVyZSB0b2RheS4gSWYgd2UgaGFkIGEgc2ltcGxl
ciBzb2x1dGlvbiAod2UNCmRpc2N1c3NlZCBzb21lIFREWCBtb2R1bGUgY2hhbmdlcyBvZmZsaW5l
KSwgdGhlbiBpdCBjaGFuZ2VzIHRoZSBjYWxjdWx1cy4gQnV0IHdlDQpzaG91bGRuJ3QgZm9jdXMg
dG9vIG11Y2ggb24gdGhlIGlkZWFsIFREWCBpbXBsZW1lbnRhdGlvbi4gR2V0dGluZyB0aGUgaWRl
YWwgY2FzZQ0KdXBzdHJlYW0gaXMgZmFyLCBmYXIgYXdheS4gSW4gdGhlIG1lYW50aW1lIHdlIHNo
b3VsZCBmb2N1cyBvbiB0aGUgc2ltcGxlc3QNCnRoaW5ncyB3aXRoIHRoZSBtb3N0IGJlbmVmaXQu
IEluIHRoZSBlbmQgSSdkIGV4cGVjdCBhbiBpdGVyYXRpdmUsIGV2b2x2aW5nDQppbXBsZW1lbnRh
dGlvbiB0byBiZSBmYXN0ZXIgdG8gdXBzdHJlYW0gdGhlbiB0aGlua2luZyB0aHJvdWdoIGhvdyBp
dCB3b3JrcyB3aXRoDQpldmVyeSBpZGVhLiBUaGUgZXhjZXB0aW9uIGlzIHRoaW5raW5nIHRocm91
Z2ggYSBzYW5lIEFCSSBhaGVhZCBvZiB0aW1lLg0KDQpJIGRvbid0IHRoaW5rIHdlIG5lY2Vzc2Fy
aWx5IG5lZWQgYSBHSENJIGludGVyZmFjZSB0byBleHBvc2UgY29udHJvbCBvZiBob3N0DQpwYWdl
IHNpemVzIHRvIHRoZSBndWVzdCwgYnV0IEkgdGhpbmsgaXQgbWlnaHQgaGVscCB3aXRoIGRldGVy
bWluaXNtLiBJIG1lYW50IGl0DQpzb3J0IG9mIGFzIGFuIGVzY2FwZSBoYXRjaC4gTGlrZSBpZiB3
ZSBmaW5kIHNvbWUgbmFzdHkgcmFjZXMgdGhhdCBwcmV2ZW50DQpvcHRpbWl6YXRpb25zIGZvciBw
cm9tb3Rpb24sIHdlIGNvdWxkIGhhdmUgYW4gb3B0aW9uIHRvIGhhdmUgdGhlIGd1ZXN0IGhlbHAg
YnkNCm1ha2luZyB0aGUgQUJJIGFyb3VuZCBwYWdlIHNpemVzIG1vcmUgZm9ybWFsLg0KDQpTaWRl
IHRvcGljIG9uIHBhZ2UgcHJvbW90aW9uLCBJJ20gd29uZGVyaW5nIGlmIHRoZSBiaWdnZXN0IGJh
bmctZm9yLXRoZS1idWNrDQpwcm9tb3Rpb24gb3Bwb3J0dW5pdHkgd2lsbCBiZSB0aGUgbWVtb3J5
IHRoYXQgZ2V0cyBhZGRlZCB2aWEgUEFHRS5BREQgYXQgVEQNCnN0YXJ0dXAgdGltZS4gV2hpY2gg
aXMgYSBuYXJyb3cgc3BlY2lmaWMgY2FzZSB0aGF0IG1heSBiZSBlYXNpZXIgdG8gYXR0YWNrLg0K

