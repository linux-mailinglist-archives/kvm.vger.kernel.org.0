Return-Path: <kvm+bounces-65538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CED6CAED98
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 05:17:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 168D73027DBB
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 04:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F4212D97AF;
	Tue,  9 Dec 2025 04:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JKo/EjM1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D483727467E;
	Tue,  9 Dec 2025 04:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765253860; cv=fail; b=nytlTaqEyFJlWzILBm/V4MsSJ8pmnw9d6t6x3ho0QCPPDwYzIp178snuTVCeuRypnaK3ppae9ThHSk8bkP16j8tSSR4MoeeWTtZVaJwXkoqr/tVhdMDflzOYB/XC4IN3hAJtlSd7TNbuYE5Mo0f3tHIdDXbfDWX1GESC/M2pX/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765253860; c=relaxed/simple;
	bh=zcLucZTcfQv55VeIlQhtb9gaAEOqNBiDHsQjRgWaHJg=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=khKLp/x0ocHrtiqoaX2nG9fRs5s7cKHdQDs/ZAfZsm9HAeEtivCjkzDZUjWTzKjcIHPIxX5PAasx+BVI6imHA84F53ASRvpxsbbWIs2Mssu5jZEG5SxGtIbjMDAfQ7wM58Sh1lG9pFMMcuZUz8250pttDND8+MuKvLbBOIZtP0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JKo/EjM1; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765253860; x=1796789860;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=zcLucZTcfQv55VeIlQhtb9gaAEOqNBiDHsQjRgWaHJg=;
  b=JKo/EjM1H8xRRhktUlzNfXuuAbziSEO/DZJOFKHvvY3Guta3qBqXKpWO
   VtUI84wpVVI5+xBuXdWB8UoPECEqOZhwMP/YUjMc9LMBmcw3X0Z/c6IVm
   alu3sW6OInrjJc5++o+xhVZ7HeZniMaH1KZbr79JY1N4gCAk59LOQrATf
   VTAjCVMsWTfaBudkx+OY7IAK2MRRjEh+6stRNVPVcfIhBTWqw3ONKnRCP
   vzrAUftVdDYh3RJ8jak+c3t6Kyh/LSOvuclGNDCeyinmseZ2580oQ2OMt
   Ks9fNq0FraSQmv2be8k/X1Y6rNddxUIvhbm1n02WKxEm5wOX+a81moTRA
   Q==;
X-CSE-ConnectionGUID: vPUeWy1/T3uPmS5rOrtCYw==
X-CSE-MsgGUID: iOfrkinfTaOAdh1yu1od5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="78670601"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="78670601"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 20:17:39 -0800
X-CSE-ConnectionGUID: IsnSaAEFQsmOC0ohg0uRSg==
X-CSE-MsgGUID: J/VtiGj7Q76iPqxaBglyiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="196020113"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 20:17:38 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 20:17:37 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 20:17:37 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.49) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 20:17:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nhkgefdmRkua98rJxEnQRNisKiqW6WpwOuqlzDGWP9GJkRA99YqpokVjWhNIKaKXpFeqkGACd4PLKW6k92JwPgC3rEMbiM2qwrTPwC477bJRP3ksDLTo1Oqfu53+R/ciQ1RPUKtGSknIBq98cvFzB7ku7iJ0AHoNxfQI5ixOYleOe+f54a3GCn1izLs7hHeJueHwrUcbiWDUV2Mcnfjs5SzXtVn8Wk8nHeXwu9GryplkdgaWsd0xFhdHMnAXzMYTUYDqyrzqcQB6tMRu9WgbyQyNXAZ6YEjqT+mfFKAxSnh5cjPPKPpI0uTTt2E7XdF23Q+AbIMzzUwoZ+iMPbmAXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e8M8PDExU0pZS279tLCf/l1UQuRhe8aT0gtelqubMmE=;
 b=GPnJo8ZspAMc8SQfpRa/7RBkq1hq37/Aj24IrA8e0qe3fsAYuXnQKNq2/z1uBDq7d6b7Og1o0Yo4nGpB0noShoeBvSrygt5QNJkXQ7P+RGi+tfM8Hg6Tw3iCGEiBhfC55yj7esHK/cXP5zCjya/sJBezzmbc0wWB/zHHn7wnIVArhwhtEP5ZLgBzb1Cx902oWB75VmxK1hwvmLAsaEsaWMboLTOhTteTQX9oGAIWlU8ldy5UcfMEk/sqLfScNoJ7NEBct+lLWRY2GmYna0q7nr1CbtQo8zabRkM6NdM3j93YPPoNFPZGDiW4QJJxH8n3g+XbKaiRX9MM/LhyF3q9Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH0PR11MB5315.namprd11.prod.outlook.com (2603:10b6:610:be::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 04:17:34 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 04:17:34 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 9 Dec 2025 13:17:30 +0900
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, Chao Gao <chao.gao@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
Message-ID: <6937a2dad5d76_1b2e10054@dwillia2-mobl4.notmuch>
In-Reply-To: <20251206011054.494190-5-seanjc@google.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-5-seanjc@google.com>
Subject: Re: [PATCH v2 4/7] x86/virt/tdx: Tag a pile of functions as __init,
 and globals as __ro_after_init
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::18) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH0PR11MB5315:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f02d90c-9b26-40bf-a9e7-08de36d9e100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?elgrSmh0bFpXSHZsUnpIdUo3NnExYzg0MTBacmI0bHB2ZUUzeFp6SE1nSi9J?=
 =?utf-8?B?UDM4d09kWk5xaWY5eXpLR0xmM3V3RlFqRWtld25zellHczRGREdScFMvTWRn?=
 =?utf-8?B?S2hhY1Bib0MvT1VUUGd1Mmp0aVNhQUI5ZjhOTndkM0pmVVF6bG15T3plV2xQ?=
 =?utf-8?B?YlZ6eUcrWCtQbWl0YnRBSHNVQUdrSkVMNUhOOTBqaE9OYk5sUm5lUisydlJs?=
 =?utf-8?B?aTNHZEdHMHlpVVVtMmhIeEVHamk4a1Q2M1F3aTU1cGdMT25EVFRUdUJHUGE2?=
 =?utf-8?B?cFlDZ051Zk1WQXptNDgxQURFQVMzUmFrZ2NiWDhKWXlhVkpDOEl0WlZlSDRi?=
 =?utf-8?B?aElTOGxKSDdNemh2elBId2o0Mm12cU9PQXc1Q0JJV2VmZ3lPSTAvSndqcndL?=
 =?utf-8?B?M1AybFZjdEpRY0RWVDhXUzVmd1QzSXVUZlVIYmMvMmJmVGpvTnFoMkwya3Jy?=
 =?utf-8?B?dm0rYzJma2tuZ0xUQnFNelV2R1lxaUFueFB4aVpLZ0xVaVh5VmdjLzNxUjAv?=
 =?utf-8?B?L2RETXo5WXR3bFgwSmI4R1BEcVBjcjZHUXdrZFZjbzVFOXJHWTZBZEI4WUlJ?=
 =?utf-8?B?K0xtUkFHaDZ5RVR1VnFyOVBGckkxWlRWNkZIcll6d2tXVit5dWZJZ2dHTzlP?=
 =?utf-8?B?K1RTWjZoN0kxWlM4T3hsdk1DdS9aSlpxOWJsaDBRMTYranQ5bmlzOFZBcngv?=
 =?utf-8?B?dmZmVDhnZ0pLdnBSV3lGT2RGcS9TVk9SaU40ZVoyY2dIUFBCWnF6UHJ1YzZl?=
 =?utf-8?B?REtLVUVLbkFFMmI3eVJ2ZzZNQ3BSTkQ5Q256dEFKTmFITVRDOFFKME5GaEE5?=
 =?utf-8?B?dnNrWDUzVjNjS2M3NE1YMmkrYnBjSklCZE1JTEIvQ280K0lvK0lvU2R5clFW?=
 =?utf-8?B?aklSaWdMUnIrRnhjcXJnSGJZWGw3SkxaS1YxdkZBT2hvb0NYL1pzMnNDWE5S?=
 =?utf-8?B?dCtkV0NTWVh1NjRTMXVpVitQcHhyOHJ5Uk9aZTlQdmpjQWp1cTIwc3pJejBw?=
 =?utf-8?B?UmNEcVd0cEJrcXU1MHFncVlCMTh2NlltYVVsdnJDeFpmVmtrQWxCTWlJNzZ1?=
 =?utf-8?B?YWZtREJHVjhVdXorTTVXVXhVQ2dtQlRreEc5d0FISkRXYU9SMHIva0xFMTJP?=
 =?utf-8?B?bnVoYis2ODJVWC9EOXFmSytSVUg4OUhNdmIwOXM0eVdjWGlZLzl2TzBYbEY4?=
 =?utf-8?B?d0ZOZVhJaG9zY1JYNExnUkhTSUZWR1BzZ3orYmZlOFlRVjMrcE4vTGo4Z0RV?=
 =?utf-8?B?ZWtrMUJHWjJFaFBSZ1c2V2xSdmNLbTBFTWxNbXR6S1Vjd3JvZk81L3U5V2xw?=
 =?utf-8?B?bEc3NU9pcWlRb1E1c0dDNldEbk5kVDVpR1RaRVc5TTd3VEpEanZLeGFzVFRB?=
 =?utf-8?B?SDdsVzZsUW41M21TTEdicUp1em85RmpOMWI4d2JtLysxMEtxVXZjVGNZaTJO?=
 =?utf-8?B?OFlCZmhCa3lJTnJqQmpWaWVpRmcwQ2JWbUsyakgzVEhmbXV0RVdhTXl1aUdY?=
 =?utf-8?B?MFhzZTBEbVJKcXh3Q0toSjRQYjdzS0I3L1BwVkg4ckVmOXM5NHpDdlZFb0dY?=
 =?utf-8?B?TkRxRHhPczdUWHp3YXRVYnZ1N0VGdDZmZ1BTTzVMMVYvWk54a2tMNktFMS9G?=
 =?utf-8?B?UmxLbndNQXgrOWJ0VFJIbzZBRXY4NUYxL3NyVFJML1d1RmQ3c2J6MTU3WlFa?=
 =?utf-8?B?eFQ4QU80SGhlNFZSZWt4VlNxTWE0Q1RKN1ZTUXpRenBQMUJLM0M0ZTRkYnAw?=
 =?utf-8?B?Z29uOGN1RDRhUlBKU2UweG5jME9GZjlCWTBZL01kYVJ0ZGpkVzR2ZkRRZy82?=
 =?utf-8?B?YjZQemdacVc2VzRiQ0ZacEI0UmYxeTd5dldBMEgxWDlTMnd1dkg4Z29CVmQ0?=
 =?utf-8?B?RDJDd0kyMVBwdnBCdzdRMDBQZnkvL3V1RVM4WEtLWUt0dFo3cVZVSFhxd0hr?=
 =?utf-8?Q?nYnI6XquzLXGt9wKY6GJLot29hM+EiF5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVFwVERUNDFuTWpCMEhsdmcrcGpubTdKSk9KK2pPU0hQN3RxeWJQVEFPSkhk?=
 =?utf-8?B?NWdScWtaZkQwTlE4WWVodmhTZ0tsRWN5SGFWUDVXTG5VcEdERzAzMkhld3VI?=
 =?utf-8?B?WkZOaUxRWUNZb1dZOVZDQUdrOFZEUmRJc3NtdlBjUnRtSkl5Y0U2YnIzdlgr?=
 =?utf-8?B?bkM1ZDIxcUxoNk00WmRlbVVOdmJ1a0l6VjJmYUZZOGVHbEZuUEU0MDJaejJU?=
 =?utf-8?B?a1pnUDViOUtUcjlOOW55SW45aG15S2xFQVhxdWFxaHlIT2l1QVN4Y0dsRTB6?=
 =?utf-8?B?OVQvdWxOcjZtMHFQTXMyYVNXaDREVjRZRWNoZHZZcG11TTVmNTR1RDdQUFU1?=
 =?utf-8?B?Z3BFM1hRTDllVGZET3ZrWitDaTFLdSt4U2ZUc1Y1N2E4SVVWRHY1a1NXejkw?=
 =?utf-8?B?QVRTNUY4M0dmZEl4ejlRUWhhR2VmRGlXREV0R2NzcWErVXl2MDZuTll0MTB1?=
 =?utf-8?B?c1E4REVWUVl5NDB4NTg0UGxaS3dRT3laMWFXbSsvUENYOXBINTNEZXR4Ty9o?=
 =?utf-8?B?VDJCbkxuVmJ2QzhsUVVqWjdzUEx3Zk5aSXBTN1JML2tjWXNTMEhpMlg5Ky9p?=
 =?utf-8?B?MWxyK0RycWQvRkhmT1JTSVhOaWhXK3lLNVNLSkdlT2xYVG1zcmxySFd4WTE4?=
 =?utf-8?B?NERicEJXVmVQNlVScU4wS3czMzFMTnRhays1RnA5c29rQVdXV0trZUJ2ZUxk?=
 =?utf-8?B?eUFqWEN3NDlVQ1BLWloyRm5HRHl3RUxMQTVvL3hhL3NINDgydm12L1RwUWky?=
 =?utf-8?B?bFB4S1lQY0RQV3llV0VXZCtsNFNmUWNXTzRDdFRKUXFZTjY3TFlzZEpUaFRI?=
 =?utf-8?B?Q093NXRGZ1p2T3hjSUlvNHc5S3RGNXJ1bXM4M1g0Y2MzbzBwdHJCQndjbmdl?=
 =?utf-8?B?Nk5kSUdHMzRxRUtIQmxOK09HSnNlMDdFMDB5ZDJVeDJJd1pIcGF5OElsaS9G?=
 =?utf-8?B?Y2FZc2ZxWEZoaE9ma1I5TDN3S2lFUUVDeGpiWmMyaEJabW4zWmtMcy9UeWRo?=
 =?utf-8?B?NUcwU2I2Q0w4NDJ5T0lTS3luOUJLenIvVlQzeXdaZ2tTeWdpOS9hUUozUjF5?=
 =?utf-8?B?S1NSSFRoc2lKSFYyWVNNR05mMzNrbE5EQWh2RGFsV01NTDJtcmk3QzVTSkVz?=
 =?utf-8?B?ZmhBR1ZzSno3dHNIL0R2d3ltTzJKNzAveEsrU1BrYlltaEFJWkFjWGRwcE1N?=
 =?utf-8?B?Ump2RlI5bVd5MjM5TlJlQURHYmhCbHpWbkpGVGxURzJwaEZVTWRHT1dDK2py?=
 =?utf-8?B?RFdYaDlLOUxkRjhDVGVQNk9aRW9MbVhiRmowU0N2TEpWKy9kNUVpODlJNHMz?=
 =?utf-8?B?TTY0VUdHNTVCaW8zT0IzZk1QSEs0VWcyVTVZNGtoNENRUFB6RUVISlJWN0Va?=
 =?utf-8?B?Q2lRVFJaSlN6bkxCTDhaelNOUWxqTExaNTgvZk50NXRPdmlRdjA2cWFhTStF?=
 =?utf-8?B?UkpDeUYyMlFkMkdrRjhlekpMMFhtTk03SHVnYjhmR1cyQk8vU0R1S04vbDlj?=
 =?utf-8?B?bjFNRHZGcGlvMkdEdS9ndFVZYVhxTHBpdjRlUkp1YnpkSGlHK0k3R0NWbWZj?=
 =?utf-8?B?TUlqRkFJdkNzQzFvN2VYazVla1RTQ1ZLWG9jaUtBcVkwV3NiaDhSM2x0d3Zt?=
 =?utf-8?B?aloxMTdsOWMvS1pmTjh2U3JlbHQzY2ZiZ3pTdFBBbXYrWmVlWU1NWGZPdFE5?=
 =?utf-8?B?REYxNCtScEJVZGwvejlUNyt4cmtUdkJhWFBVU2FqWklCYmpWdHJEc1JKSnZQ?=
 =?utf-8?B?NHUxYWVNdEJUODlJSnM5SnNkODRJaVFsMm8wUllTdlFFNnFtbG9pUkhKN0lJ?=
 =?utf-8?B?Q252SGpSRHJpWUJxR0dwbndLMVA3cVpqajBJcjJrenRhd2lGUjJBRTRLRWRO?=
 =?utf-8?B?SUtDNGMvUWxoN3VVa3UwdHZ2L0ZJc2ZtNlV0RWpTZlVSQVg3OVlVc0xrYUI0?=
 =?utf-8?B?bHFUSmpWMHk0V3gycjdBdzJIbldCVytGY2lHbkJZSkNQVDBqOHBOR2lFbFpv?=
 =?utf-8?B?cm9JUENXUHRFbVhGSTV6b2piODVMQXExamxIQjVWakhSTDE0WTFxckJwKzhF?=
 =?utf-8?B?MGpmYmFxUEJOVm56UzYyT2IyUFlyU1J3UGZVY2RSTUZmTEg4NWpVcjMzdVV1?=
 =?utf-8?B?OFQvczlNWDNEa3hMZUZJMm50Wk9Jc244TUViQzdhazVCZGN6dElLVFk4MmxX?=
 =?utf-8?B?Wnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f02d90c-9b26-40bf-a9e7-08de36d9e100
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 04:17:34.5335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KWL5QZ3oAimyfXb3Tmh8GjGgtnHZbkchQt29K8Zg+vOXrs9mYBs+5W0Wd6eeI7SQPZYi26N9nY13LO7STLX/5jjcRsixy9bfF8BaB+DZRZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5315
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> Now that TDX-Module initialization is done during subsys init, tag all
> related functions as __init, and relevant data as __ro_after_init.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

