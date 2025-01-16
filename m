Return-Path: <kvm+bounces-35658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3720A13987
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:55:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CECA11889E97
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC3E21DE4E5;
	Thu, 16 Jan 2025 11:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C3/2XZkC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0671D6DAA;
	Thu, 16 Jan 2025 11:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737028530; cv=fail; b=JOvXo9IrfqTWrIzJB/X8JqvFPS0xgngbeAOVz3l4tYpdy/SuAYceEhMOylIefzzl5nHawsY5/nIzItTl44JX+xEQeaMIeeIEtubp/QTJ1ZvlQLT9r1umPCDSMHMDQETVi68PBAw4RgL+xIRqdr5sjOmODoc6N23EIi1hfvXBEH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737028530; c=relaxed/simple;
	bh=ux0R0ZSWNenqq0bZmviW7mCcUmb5Tm/TmFMWCuo0jTs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=thVHLB6fBhKDcjzeYIp7WZEPWdDs9QVriopZx4etZMrIz44rYR1jCL7l4A7REY9sxwyDVjMuG2OJeNFWmaOLqzvGjkuTWRNTRntLbZgn7RtXwIZQzQfeaaSZuf2KQxWtKsr54ySSjfo8OlAGDTeuNbcjBJue4ourzOYoElanKsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C3/2XZkC; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737028528; x=1768564528;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ux0R0ZSWNenqq0bZmviW7mCcUmb5Tm/TmFMWCuo0jTs=;
  b=C3/2XZkCUfXmPrcg+jXXTy6C87sN8ZUW7LpeiXKgBLxS+wN6dNeK+Iho
   yHxrqJxXPnRte4HqLXRalOnwQg5vnVJAR2v7+J3qNfeCnlERyojGt6uwR
   BS4mAf+IeuPD1z6x0rFU070oJW1Ox1KvzyRWZs1ltqv0fhFH9CWbO1Add
   djrjjGeDJIewz5HaqRMpkMPiDpzEcvb7NZy29GZTEKr0vjL7XeKiW4M8A
   Q0Y7vVS1fDwufMgCXI4ei/AJg3W+CA9p2IH45sIAMOuzrlQfZHzR2c3o+
   dI4KOFHFLnPS0+3pxj2rpORr2bhk9CjgI2ih3V1fdiZWoS0zYaDAb69tb
   Q==;
X-CSE-ConnectionGUID: vhqsxU4QQB+EN4R40xcJkw==
X-CSE-MsgGUID: SOSAU/bVQoy+6p6eTdAFUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="47900029"
X-IronPort-AV: E=Sophos;i="6.13,209,1732608000"; 
   d="scan'208";a="47900029"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 03:55:27 -0800
X-CSE-ConnectionGUID: P36yufNGQYaqVUKRuAhvOQ==
X-CSE-MsgGUID: jAfZmyehRbehJ6q9pdsdzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="110446972"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2025 03:55:27 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 16 Jan 2025 03:55:26 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 16 Jan 2025 03:55:26 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 16 Jan 2025 03:55:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZErOwnwAF6x13htO5ra5eIUyidBBHnU4tGAFT84njqAXlv3yw9z1wtENUyjJxk493lsWbLr3058fffGnJMbj0WEnBb1ePsBtl+7JI9wDuBEAky7SVjJMIn0cj/WWMwcRBRxFmjW3hbCOxkv5rCmjWbi4TOXcVk//M1xnK3DL/YXbHQ5wYvpiIUqy+dMsMptvcpjOmsNjsYDimseM8WPb8umZDtnkHCYgrul2sHYe2m/+H/rmsPCXw03IqxL+M3VUqiwuL27Ah34iK8BPJNbrLNkMyEtJKQjFGrV9VLcp4Yemg7aKy0HB+IX7uQ7QhVuXbxZvyZ8HYpmrcRQaoeWFUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ux0R0ZSWNenqq0bZmviW7mCcUmb5Tm/TmFMWCuo0jTs=;
 b=Sf8lgvikeIeCOTaeYQQpvbS28BCR7xrmsdh+Bu2rBBjdOOk5BoPAnLWlGABD62/IufkehnFUdkZDjonYrSt/GR0grHFlCO3bygZr7aOcjnL6xlzBR9KY5XozmTac4cdZoniTLDChEcE12Lpfz3pap+PaH4RQk1DTDmQseB2+hprDO3gWtHKJD2yA/OkMiHB1pUqFkcktSx/JqgKo//LAFQyRCkRvnxNvJkLa/pcX7fo/km5vkHpvvZud76Pz7UCyNcutrAWE2a5+akarp3OBQowDvIroNZzk5sngr0mr7DEE7w4ZdDgYNuMdG0jmRd62CULM1IYa9wFaNf9iV+plxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB8236.namprd11.prod.outlook.com (2603:10b6:610:184::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.14; Thu, 16 Jan
 2025 11:55:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 11:55:23 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
Thread-Topic: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
Thread-Index: AQHbSdaRKaJIAc3W+kqkHDGtm3kSR7MUKuIAgAABzACABVqtAA==
Date: Thu, 16 Jan 2025 11:55:23 +0000
Message-ID: <61e66ef579a86deb453bb25febd30f5aec7472fc.camel@intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
	 <20241209010734.3543481-13-binbin.wu@linux.intel.com>
	 <8a9b761b-3ffc-4e67-8254-cf4150a997ae@linux.intel.com>
	 <e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com>
In-Reply-To: <e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB8236:EE_
x-ms-office365-filtering-correlation-id: e231095a-6b4d-41b4-5506-08dd3624a8f9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RW90amFIS1g0OTN0N3RPR1E1ZGZiQUFpVjMvbXZvMDhmYVJIKzIwbFRBaXFz?=
 =?utf-8?B?WFJYSVUrVTY2K0h4U2xoWWxOcXN3WVpvZWIwUjVybFJhQU9HWGNHYzVoU1c2?=
 =?utf-8?B?SDJSbW5aTHpod1lwaVFCdWxadVdONHRRNjV4aU9KVnNYSkFvM0dvN0cyU3U1?=
 =?utf-8?B?UWU2N2hoUnpLdVJuWW52YXhyRm9JVWtrUWl1V3ZFaVN4NWRXUEdKZlRYSGtO?=
 =?utf-8?B?dW9Ka0dJSU1DM0phQUpEenVScmR3ek94MVhRUHVTS0x0d2haaXd6U3dFMUpS?=
 =?utf-8?B?S0V0QnhyKy9RT1FHUHFpYk95ellCUGdDK3QrQjF3YVZWNkJ0MWdxbTlLY09L?=
 =?utf-8?B?WlBObEtmL01XTUFISjlmVUwweHhSNlVsWlQwVmpBNnFIOXRqZjNseE10dk5z?=
 =?utf-8?B?RFhhNm42dlpIRTVmS0hXWmtDWTY3RVA3NUV1bW9FQ0ZSLzNkb0ZIMjQ0aWF5?=
 =?utf-8?B?STFjdkN6bHFKOGVpWFVzU2laL1JndU94T2FEaDliaS9YYnhWRU9uVWdrR2U3?=
 =?utf-8?B?R2pjdlJFV1d1UjJRN2dqS3lmMnRERkt0QWJCczR5bE1PbUIyQXZ0cWpmUGZk?=
 =?utf-8?B?MFAvckFxREt2d1RBalJMUlZkZ3Q3Q0RjalE0WlA4RTVFY1U2RUpuMjNvdE16?=
 =?utf-8?B?bGpXd0xYY0U4bHdLYURSbmlUL3hCSnQ0OWdCaGVlTEJiY0ZLdTJGSFVRU3c4?=
 =?utf-8?B?ZFBBUzBuUm1VeFZlOWNEVTJiNmErT29UVm5NUzlGdzJVQzFqbDlJOVhaWkpV?=
 =?utf-8?B?UElKV2tDem5aT2s2RzVCa3NQNUwvR0lUVkFPa29ENjNLdng4NmRRYnl4QzBu?=
 =?utf-8?B?bEd6UWhDVzdLeEVmZTAvaFFhMXNVOFQ5alV3NGNBMnV0NjVsMyttZ1YzSGpT?=
 =?utf-8?B?Z3IvUGhScklsbVJZQTh0STBGWkFINFBLOEVCbFhpYm83RTVoc3dBVG9oODls?=
 =?utf-8?B?MUhxNWtWU2piS2J1YVMxZDZULzNGZTR2V0lHZTZYSEFjMGQ4ek1XN2lQZUNE?=
 =?utf-8?B?SDVrbmg1UVJTcCtVQ3dhR1dpT3Z2L2RhU2s4akhRMnFyN0JHem83NGxEbWpZ?=
 =?utf-8?B?amh1OG9qdWVMbkdJUElrUmRjU0ZHSERRS2RuTXhjRXhsME1xRCtiV1RoMXlw?=
 =?utf-8?B?bXV0UlpJTzVpd1hjSDdWbnJuOHpmL3RnOWREVG9PZ2srZjRGbitDdzdGVzRz?=
 =?utf-8?B?QWhCTmQzR2wwb1RyN2h2anZPN2lhWWUyWDJQUUxERk1GakFsS3QxWEtFUDFo?=
 =?utf-8?B?Z1d4MElvWjlURGJlMkVON1JJWEp6VXpheGhDRUNxVzdxOHBvVnZiRlJtWkNo?=
 =?utf-8?B?akx5RkpnYkZJQXRYa1g0MXBaK1RoMUdXbHQvRzZ4OEo4QUdBYTd0dW14aTE4?=
 =?utf-8?B?QlNESTREN3ovbWVpKzcvRFNhU3FaOEQyRjBCNFVFeFQzNU1lalMxL0Y5M245?=
 =?utf-8?B?UjRIRVFTaVZFcGM0R3ZZS1NkeWxZUGRJNkxKYUthT0VFbWJUZll1cTdhMHk0?=
 =?utf-8?B?M05wUEpJYXZQczNTc2ZRWEVWN1Q5ekcyME8rZDlqRS80WXFWQnpqS1gya2dJ?=
 =?utf-8?B?cDZCeHVQQXIycTkyaGZ2UC9BL0RiNzZRV0I4QmdsRmFWMzF3alQ1elNIdkk3?=
 =?utf-8?B?UnJaUkhOenhmVDR3cGZzQXloMU1lb2picytrMjlBaEdpR0ZWNkMzdXNoa0dt?=
 =?utf-8?B?RmQ2V05JY1c1N01zWHlvdm5OWVlla0tzN0U3YWowOXF6MW43Y3lTVFF1Y2wv?=
 =?utf-8?B?THl6UnlDcFJHa3RIcU8wY2M1OUM1TEpaWHhVcWtiSHFScVNxM0dmZTczc3dt?=
 =?utf-8?B?ZlczeGdFN0hrM3daMGIxMjQ3ZTNYWUhUWi9kRkMrdXp3ZjJ2M2RTNHhVaW0z?=
 =?utf-8?B?YTQ0MVRWbXdYRDl4UFFKY2k5UnRUM244U0p3K0ZVVDFIQkVTcFpicmJXVmFR?=
 =?utf-8?Q?rzgqb/SfFqHSHoVdl6eZqPQMk230DiCd?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEdMM01BR1krQTgzRCtoTWN0T3FTV3M3cE5tdVJQZHZEeVgrdGY2c3lHVHVa?=
 =?utf-8?B?Z01pVHR3M1RMMlQ2azViNXlIVUtnNGsrNGxWeHFlWEtqSW1HUU1YZkZ4dG5E?=
 =?utf-8?B?Ym5BTGVYSTNpejE1bjA3NEdsZ3c2V1ptWkt5eVBidVFBV084VytIWFlHR0dO?=
 =?utf-8?B?NldmdE1ZckVWVS9Td04wRmNXNitnWVZlQjBCUkdyY081bVY1bjZ3U2hGOXZ3?=
 =?utf-8?B?RHhlZ1Vjd1hDL3pIUk04amFTQ0RvcytlYUc4ZXNXOGUydTIyMEVReDY4bm95?=
 =?utf-8?B?WDB0K1NHUVNqNURuQnptNnM2M1RjZG82dmY5dGRFU0kyd2ptTXBub0szcFhE?=
 =?utf-8?B?OTUvdjVJaFp5MUlZSTlGcGMrZ1hWOU1ZZFpBRXI0M0h4RStiMXcxaC9NMWxM?=
 =?utf-8?B?RkdrbnJmbEdUaUMzd0d4UVltanExRTJRTmVLTkRlS2o4RnVyOXZhOTBPeTQz?=
 =?utf-8?B?OTJRQnI1S0ZpWk9ubVVZc3lIbTVhd2t5eStISGlTcVYwVEo0MG45K1ZMUGdY?=
 =?utf-8?B?elF5SGhWOWpCUVkzbFVVM28xN1hMSWhXSlFCOTNqRTFpRlVnb3ErUG9SMS9l?=
 =?utf-8?B?ZlQySUJFRExMaXl3YjRpRlpQUTl2UjJobm5PZk1EUDVDeDVkd1dwMDZMZzBS?=
 =?utf-8?B?bVlaNmZLZUxrUkRRSnJvUkp0RVF4YXhHQ2RvcVZZUzk3SVBNVTkzTXRQZVM0?=
 =?utf-8?B?bjVMenlqZlhvMEZHMGhSblU5elVNaDFldEJxOHpEYkpnTFFIVGV2RGQyNUpi?=
 =?utf-8?B?Uy9JeUtuM3FWaDJJZ3VWNUNwa1B2ZW9sN0I2cDNKV20xWUdJSEZITm5TWEpj?=
 =?utf-8?B?eithWHJMcEJ6Ymt4S0ZEV1NrYXNlOEU2dWJPaWxSZXUzUGFHZVJ6NnYwRitP?=
 =?utf-8?B?V21OM2w3NU02RmhWcUJpWXBGdElvUUZ5dHhlTHVCb3pTbXRzMVkwb0FwT000?=
 =?utf-8?B?U3VoNnR5RHQ3Sm5uaDdkTmV3KzA1N1V2NEU3VCs2ZUVaVFEvaVQra1JaaEgw?=
 =?utf-8?B?bTkrcGZwWTFqWHRHNllKOEpORFRTcFBTTXlxcUNLVGJYNi9YQ2drUk1GMFJh?=
 =?utf-8?B?K3Y3YnB5M2JyVWZ3YlgyWUhTNkxKd1VsMHlUNUxPVHNqam9sbW5sM3NOUnZB?=
 =?utf-8?B?clgxanVhQ3ZoMUoxS0tSOXlVRHdhL3UzQUFva3gwSW9sUHVGS2VzNVNVRXV4?=
 =?utf-8?B?YzhHb0VaZ2lvUmFHSm8rTjlvaDVXN1dvUkplcmhVaGs4NDdOTjFCN3VocnRE?=
 =?utf-8?B?QVk4dHBLOVhQWmo1bkdzMXc3WGxkV3EwQ2ZTVVFoNEhTSjlLdVUvWHUzUFJr?=
 =?utf-8?B?OG8ybEFPYU1ham94aENEWnpDODFTeFA2N2lQY2pvUnRyemd4TXU0NnJUS1Ni?=
 =?utf-8?B?K25FekkvRlZTd3QwRk1rYVZFU2VFZjZ5dCswUFM4SWRjN3ZsMTZOQk9Sd2kv?=
 =?utf-8?B?UE1Yb2ZSTm5LQlpqNTZZZXZWaEtFVDlaaEpSSTZ5QTgwRXdiR1FQYWtObDBT?=
 =?utf-8?B?Wkg4QzJkcXNOMnhYaUJHQk5sdDJMejFCNHFzZ1ZhMWxhSWxrd0IyYjN4aTla?=
 =?utf-8?B?ZU5aMnVPbTRQNk1kR3ZMWHpFbjMrSm45TUt2T0FvUDNOUTkwY0dzVEFaOFFL?=
 =?utf-8?B?ZVRNais2K1l4TnFBdzRrOFkvbTVVbDdacEFrUC9sdmRkWmY0cElMdG03REZr?=
 =?utf-8?B?OGJpdnlkZXZ5SUVOTzdGSUpiL1hsMUxNYTd3ckpCTXY4UGFmK0dtYlNjZ2xr?=
 =?utf-8?B?Zko1cUZucXhIT050ekNJUXBhTGsxeEpJQi9wOFMzK1VwOVBhdzZRR2N5TWV1?=
 =?utf-8?B?UWRSSlYwTm8yMlBlM1drN2RNV1FxbVZEZ0pvY3h3dVA2RndhYndVaGlnOTRB?=
 =?utf-8?B?K0VzTHVSMVdoUEQ0YlpubEt1bTBzVlBlK3haWkVoVmw5aXFERDBFOVJkc1N1?=
 =?utf-8?B?Q1F2anIzYkRHZTZRckxibGoxMlh0ZUc1Tm8xNjdRdk9CYWMrM1l4N21UdGEv?=
 =?utf-8?B?WisyeW5SWjVuc084Q3c3YkhwUUtHWjI1Sk1EcGlMbEFpYkFRODVJdXBHT1Vx?=
 =?utf-8?B?ZkVJZ0g4RTFhbzd3eXViREE1U1pnVEI0SXJ3OW9NVjZBZ2lCR3ZPQWxIVDN3?=
 =?utf-8?Q?nGFs34YV5WvnisHNc55thPyzx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0BAEA704C7DAE249A32FA3340C5DDE9B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e231095a-6b4d-41b4-5506-08dd3624a8f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2025 11:55:23.7642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 01PGEdR9IfH+wfb+kWrBiuiFb4sgzzCw2y63Z4wt68KNW2Nh2kQG04sbAvIsrDKzGK6Z3XJO1H39n1hEswEiqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8236
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTAxLTEzIGF0IDEwOjA5ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IExh
enkgY2hlY2sgZm9yIHBlbmRpbmcgQVBJQyBFT0kgd2hlbiBJbi1rZXJuZWwgSU9BUElDDQo+IC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IElu
LWtlcm5lbCBJT0FQSUMgZG9lcyBub3QgcmVjZWl2ZSBFT0kgd2l0aCBBTUQgU1ZNIEFWSUMgc2lu
Y2UgdGhlIHByb2Nlc3Nvcg0KPiBhY2NlbGVyYXRlcyB3cml0ZSB0byBBUElDIEVPSSByZWdpc3Rl
ciBhbmQgZG9lcyBub3QgdHJhcCBpZiB0aGUgaW50ZXJydXB0DQo+IGlzIGVkZ2UtdHJpZ2dlcmVk
LiBTbyB0aGVyZSBpcyBhIHdvcmthcm91bmQgYnkgbGF6eSBjaGVjayBmb3IgcGVuZGluZyBBUElD
DQo+IEVPSSBhdCB0aGUgdGltZSB3aGVuIHNldHRpbmcgbmV3IElPQVBJQyBpcnEsIGFuZCB1cGRh
dGUgSU9BUElDIEVPSSBpZiBubw0KPiBwZW5kaW5nIEFQSUMgRU9JLg0KPiBLVk0gaXMgYWxzbyBu
b3QgYmUgYWJsZSB0byBpbnRlcmNlcHQgRU9JIGZvciBURFggZ3Vlc3RzLg0KPiAtIFdoZW4gQVBJ
Q3YgaXMgZW5hYmxlZA0KPiDCoMKgIFRoZSBjb2RlIG9mIGxhenkgY2hlY2sgZm9yIHBlbmRpbmcg
QVBJQyBFT0kgZG9lc24ndCB3b3JrIGZvciBURFggYmVjYXVzZQ0KPiDCoMKgIEtWTSBjYW4ndCBn
ZXQgdGhlIHN0YXR1cyBvZiByZWFsIElSUiBhbmQgSVNSLCBhbmQgdGhlIHZhbHVlcyBhcmUgMHMg
aW4NCj4gwqDCoCB2SVJSIGFuZCB2SVNSIGluIGFwaWMtPnJlZ3NbXSwga3ZtX2FwaWNfcGVuZGlu
Z19lb2koKSB3aWxsIGFsd2F5cyByZXR1cm4NCj4gwqDCoCBmYWxzZS4gU28gdGhlIFJUQyBwZW5k
aW5nIEVPSSB3aWxsIGFsd2F5cyBiZSBjbGVhcmVkIHdoZW4gaW9hcGljX3NldF9pcnEoKQ0KPiDC
oMKgIGlzIGNhbGxlZCBmb3IgUlRDLiBUaGVuIHVzZXJzcGFjZSBtYXkgbWlzcyB0aGUgY29hbGVz
Y2VkIFJUQyBpbnRlcnJ1cHRzLg0KPiAtIFdoZW4gV2hlbiBBUElDdiBpcyBkaXNhYmxlZA0KPiDC
oMKgIGlvYXBpY19sYXp5X3VwZGF0ZV9lb2koKSB3aWxsIG5vdCBiZSBjYWxsZWTvvIx0aGVuIHBl
bmRpbmcgRU9JIHN0YXR1cyBmb3INCj4gwqDCoCBSVEMgd2lsbCBub3QgYmUgY2xlYXJlZCBhZnRl
ciBzZXR0aW5nIGFuZCB0aGlzIHdpbGwgbWlzbGVhZCB1c2Vyc3BhY2UgdG8NCj4gwqDCoCBzZWUg
Y29hbGVzY2VkIFJUQyBpbnRlcnJ1cHRzLg0KPiBPcHRpb25zOg0KPiAtIEZvcmNlIGlycWNoaXAg
c3BsaXQgZm9yIFREWCBndWVzdHMgdG8gZWxpbWluYXRlIHRoZSB1c2Ugb2YgaW4ta2VybmVsIElP
QVBJQy4NCj4gLSBMZWF2ZSBpdCBhcyBpdCBpcywgYnV0IHRoZSB1c2Ugb2YgUlRDIG1heSBub3Qg
YmUgYWNjdXJhdGUuDQoNCkxvb2tpbmcgYXQgdGhlIGNvZGUsIGl0IHNlZW1zIEtWTSBvbmx5IHRy
YXBzIEVPSSBmb3IgbGV2ZWwtdHJpZ2dlcmVkIGludGVycnVwdA0KZm9yIGluLWtlcm5lbCBJT0FQ
SUMgY2hpcCwgYnV0IElJVUMgSU9BUElDIGluIHVzZXJzcGFjZSBhbHNvIG5lZWRzIHRvIGJlIHRv
bGQNCnVwb24gRU9JIGZvciBsZXZlbC10cmlnZ2VyZWQgaW50ZXJydXB0LiAgSSBkb24ndCBrbm93
IGhvdyBkb2VzIEtWTSB3b3JrcyB3aXRoDQp1c2Vyc3BhY2UgSU9BUElDIHcvbyB0cmFwcGluZyBF
T0kgZm9yIGxldmVsLXRyaWdnZXJlZCBpbnRlcnJ1cHQsIGJ1dCAiZm9yY2UNCmlycWNoaXAgc3Bs
aXQgZm9yIFREWCBndWVzdCIgc2VlbXMgbm90IHJpZ2h0Lg0KDQpJIHRoaW5rIHRoZSBwcm9ibGVt
IGlzIGxldmVsLXRyaWdnZXJlZCBpbnRlcnJ1cHQsIHNvIEkgdGhpbmsgYW5vdGhlciBvcHRpb24g
aXMNCnRvIHJlamVjdCBsZXZlbC10cmlnZ2VyZWQgaW50ZXJydXB0IGZvciBURFggZ3Vlc3QuDQo=

