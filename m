Return-Path: <kvm+bounces-61289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E2575C13D94
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 10:36:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 451794EE6BE
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 09:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89333301484;
	Tue, 28 Oct 2025 09:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iJt+gfdc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CBF27FD74;
	Tue, 28 Oct 2025 09:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761643905; cv=fail; b=VN9hGpb8cfiqU7ek2FEUQXpe9JTq4WLnaveVVVIlPpkm4UUxy+ba49r0a26/ytlfsHPFBg9+Qk58x/lqCC0hod7Xw/eEoii1lqY00BW0ZUhkXaZiaqM5oZnBkPt8PYQ0hbk7165Bc5aoCHtW58IUatJgZvGXbRLr25jvD0QAgSg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761643905; c=relaxed/simple;
	bh=FaE/3AokNefbG1IEyVleQ7lvs0fQqkLJxbkOvIRvIN4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZmGM/Z+3zlpJEOSzjEFwQulxmhUeIKump/JPQ3IwO1x5XfVTdl4OTqK1BZ8vSLFB26oxfgRW/1Bo+UI/QYriXrf6kk1JRWMPMvgoOcszUWrlaNrMe04cLD9uoZdvjQncokNLdfuH5iYR4cIwurqEwNnilXZvzryhzcJ3smtu0IY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iJt+gfdc; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761643904; x=1793179904;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FaE/3AokNefbG1IEyVleQ7lvs0fQqkLJxbkOvIRvIN4=;
  b=iJt+gfdckF266pZuQXWBf74aqCMPsooP4X+wi+AzqD4BV9u5r5qa7j6M
   +3FQvd9hUWHrNtdYJbmhhYalQAPYjucrsDhFaEplKQUYUXqaedoaJn9sR
   TE3AmRjFlRiJVeU+CF8F/Uyud4PA7ea6AqahFxgAJal59Q+dg6kQjU1vZ
   jNQQ59kFTa5qQCOPLfTGayj4SNLc3+WmMOmuQWwEmGINW1MKaZrcGw875
   MqoMT2a0GHsA7ZRb5kJ87rciqMZsHr8FwRRBqOxvbVN909egw89WMzIva
   pDU1nNdUfsZvAh0m560ZtqV0JBZ7wHOiujYNgkCgrbHLWhsl4aoPTWoV4
   A==;
X-CSE-ConnectionGUID: cOgPgosITyGikNfphbw3KA==
X-CSE-MsgGUID: s1qEfiFFQC6nB8MIVXMb8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="66355294"
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="66355294"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 02:31:43 -0700
X-CSE-ConnectionGUID: hUkNHHjuSXSH0N2PIPKyYw==
X-CSE-MsgGUID: bkFTaJKbQ4ugby6q2CXYAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="184472414"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 02:31:43 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 02:31:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 28 Oct 2025 02:31:42 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.42) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 02:31:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wUiq/YhxwhtX7gqpc4CMb4LZxMqZ1+0jIvEyixhPDMN8Q0+R84/ut6WZ4n0ZwkS+Ck6dTEgnDl41bkEr6HkbhUMGzMM8XB2vDZQJm6DM0cYHbtslX6FbJKB9trtBhb48f75ebE+wcdlX/V4MU8gUySJrZmJIPi2K18lH3NWAISitHBeVbBSFUnc5C+vW+bX4lklKMVY3drMX2EpK/WaSRnb2UsYFsCNsUJZtwBQkCDGwG2kQkmi8Czz4tYLscBzwpFNcc/OsDHHOkiU6UgkCPyGI4L+CsENxAXh/4kBoBkNAn690OhXY2c/QKNwIMMGOk05hw4RO0oXFw5Fji8GL8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FaE/3AokNefbG1IEyVleQ7lvs0fQqkLJxbkOvIRvIN4=;
 b=DN7C3P3zTTJp7ZokbxT+a7xq8Lv4+IslWOB5R7cdviIme0lg9ImKrCHKSWhlyUYHKDBe/iPL5UUHdpWfWtqRgmafd7+vBnQyuy0YNZho6IsROOU8TvDEdW9Q95EbIsFuYRj4k4NufPkh3dwu4FPdZ5ac5LcihvFMVaR1Z1BdFcRiJzXrW2sFW1IolCe5DyfYNEqJZnZ0e52TcKcDB05/rHmgi/aTJlsFYUQPGNLlg56ZIt88eASARacOqJEeNFftnqCZ0w2BHiN1YrcfdQcUKWl2sjIMOqFeaa6N2NkwRRyyDWqJSq06gCtY08iteIwBduELBdZfFksZ5h4XOzbQag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by IA0PR11MB7258.namprd11.prod.outlook.com (2603:10b6:208:43d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 09:31:34 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%4]) with mapi id 15.20.9275.011; Tue, 28 Oct 2025
 09:31:34 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "x86@kernel.org"
	<x86@kernel.org>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "Gao, Chao"
	<chao.gao@intel.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Topic: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Index: AQHcG1rj8xzFenegOUSY8voF4LzMlLTVayCAgAAVl4CAAQSgAIAAVSGAgAAscgCAAJ2pgA==
Date: Tue, 28 Oct 2025 09:31:34 +0000
Message-ID: <3cc285fc5f376763b7a0b02700ac4520e95cf4d6.camel@intel.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
	 <20250901160930.1785244-5-pbonzini@redhat.com>
	 <CAGtprH-63eMtsU6TMeYrR8bi=-83sve=ObgdVzSv0htGf-kX+A@mail.gmail.com>
	 <811dc6c51bb4dfdc19d434f535f8b75d43fde213.camel@intel.com>
	 <ec07b62e266aa95d998c725336e773b8bc78225d.camel@intel.com>
	 <114b9d1593f1168072c145a0041c3bfe62f67a37.camel@intel.com>
	 <CAGtprH9uhdwppnQxNUBKmA4DwXn3qwTShBMoDALxox4qmvF6_g@mail.gmail.com>
In-Reply-To: <CAGtprH9uhdwppnQxNUBKmA4DwXn3qwTShBMoDALxox4qmvF6_g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|IA0PR11MB7258:EE_
x-ms-office365-filtering-correlation-id: 0b553184-e97a-4783-dc67-08de1604c953
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NHlWaWpGK3JpQThuUzVSbVRicVpmclpRMFo1cG1mSmt6WFUyaS84dnlMMnhZ?=
 =?utf-8?B?MVV4NVFwcEVHa1R0UEhlTWJ3a0FYbHRWdHFTallWN3A2WUdpcUlaUmRFSHRD?=
 =?utf-8?B?VGt0cTBId0kwUnpxWjNXdCs4Mk5Pa01YWVRNeUFoYzVoUWVZUWp0alRON3J3?=
 =?utf-8?B?Wjgrc0pwaUZKaDdLVDdnWUlTdlNzTG1vUlhIaUZGVGRveXU1bk5zdUJrcDM1?=
 =?utf-8?B?TmkyK1kvQTArS1Q0cGNObENWTldlZ2tSQjlvcDV1b25WZHB6cGZ6NTdadkxn?=
 =?utf-8?B?S05IeS9jQ24xSzlNQWRBZEpuU2kycjhTUFhMaGk5Q2UzTXdSSWVlVTdLOXc5?=
 =?utf-8?B?TXF6WGd2R2R4VVc3dTJkdlBnQXdvcElFQjh1R1p1Q3RhVkFtYk5Bak5rdXZp?=
 =?utf-8?B?VkVWR2xtU1I4aU9FSUJHaDIyMGE2MmgzckF4dEZVb01xS0pwOXhYbjEvT0RZ?=
 =?utf-8?B?MjlHS3dacktNV21CVkxNWG9xamJVQ2pWczVubmFGSHRWY1RLUUJkODhIeEc5?=
 =?utf-8?B?RU5vZy8vbG1XWk01TC8xdmRXdjliMDNWVkhoK1pIOGdVZmlyajg4SG1FYXRW?=
 =?utf-8?B?RG90QmM3UDBIOGU3UFdWTlhlRnVVYUx1dUZjSlFBV3BxVG9kaldEQ2pvdFEx?=
 =?utf-8?B?bzV3ZWlBR25MeTRiblhtWDRJRm1CQ1orQlZ3bEROclBtQ0wzWkg3dGcwOXBX?=
 =?utf-8?B?SG9iTDdyZFJlSGxCKy94MGl4bGdxd0VINExnM0hzMXlZY2N0bU1CYksxbmFN?=
 =?utf-8?B?dElvdTRWMlJsek0rNEMyTlk3a1hUVGFmUlhoMS9iUEFNZklMT2dZcVJkZ1RU?=
 =?utf-8?B?N1c2T2wvbEpLNW1heTV3MEhmOFZqZTdmRExOYXByWVJQdW5TRkxnZnZBQjRV?=
 =?utf-8?B?K0o5Rk1FY0NFK3NOd202TDYyV3BYcVphdC9KUG1LbWQ1MHBMY1RIUzJvcXVv?=
 =?utf-8?B?QzJjVmE0WHJEczFKeHZTTkxWTzlpUnFHclZzQkZKV2F6azJvUERQVitTdDFs?=
 =?utf-8?B?TWhaZGR4WEdJNGpKcEt3U2RkT0RnWFBpSHUxV3FzZXBEY3lqWmJXenJxWlBC?=
 =?utf-8?B?NXIybTFwdVgxcDZxZU9tdUhmSFo5ZGlNR2wyTytJaG1hZERpM2hFUVFnb1VQ?=
 =?utf-8?B?dnpESDFPdVpxbDIzdGR0RDNQZzdxNGpPUHR1cEdXSjdwMk5qRGM1eW5nY1lU?=
 =?utf-8?B?SlUxRFRRdEdGUGJzZmt6QnE2bTQ0cWJkeGRoWkozSVYzMkcvUjJkakFuVkFE?=
 =?utf-8?B?TkZmRGtUcDB3RDF6NGVJaXUxSTFhbzE2Z2l5MFdEcU9UdVk5eU9Ha01QTmJx?=
 =?utf-8?B?RTVaWmo3OVhHcDhsaHVvcGRIR3pQSU8vUFgwR2NXeFlkaUZJWlJqbFpIS2wz?=
 =?utf-8?B?SlhjLzBraFF2VGVDdVRVbE4xcHNsNXhFTVhON3FydGlsYVR3cVkrMUIwcHhT?=
 =?utf-8?B?NWVocE9xd24vQXE3bTFMMEt2K3JTMjErUDJUanE5ZUJLSWlwZ3c3eG9sdGJx?=
 =?utf-8?B?OWh5QzZvVXNtc0NBUDYxdWk0SzVlMjYwYXB5ejBZcUltNktoV0dyRk4zOS9o?=
 =?utf-8?B?SmlzYkNhZnoyYVFiQzN2eFZGbXgyNlc4cXJkNDFtNG93aUtGSFJIVm85TzJT?=
 =?utf-8?B?VlFaWTRBWGhjM3k2QU1hMGVEVkVXVExibDJtcmZKMmNTMSt0ek55Zlh4Tk9Y?=
 =?utf-8?B?Y1hOcEFxT21rMTJZWjVDYW8rNGlYc3VrWnZWU3p0VE0vMGttbHYxbFlKSHNE?=
 =?utf-8?B?cUo0d3NsaWM4VytDQlVZZU1lbGplM1VZNVBsblNjcWR1ZTVBQWx5cURkaFFs?=
 =?utf-8?B?Y1VRRHRWOVNyRWtPcVNBdnk2dVg5QlBLL1NVN0ROZ3QvdW5aZlZLbzBKNjFB?=
 =?utf-8?B?enZWcnpLMmR2WkVSSEpaanpmb0dieDJDWXR1R1NzN0d2QlQ2WGRjckIwSnJL?=
 =?utf-8?B?MjdnMEtYTVNqS0ErVFo1RWJCNVF3ZU5tYVFtTWJyNzlxbm5OT0VvcGpROWZn?=
 =?utf-8?B?S0NWNEM5YlpCMVI1SURNMkVXUWlUb0xBd3kyVkxpOU1lS2swSHRPeVpmUmd4?=
 =?utf-8?Q?tpBW6r?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0EzRkU3MUdaRFdxVXlwNitWa214Ym9UUVNualJNNW5oVDczTEppV043ZVBD?=
 =?utf-8?B?cjVLRXY3SENaT1Uvb0pBZnBvdU1IVTdzcnR4clBvNzhpc3lwS3ZZSzB1cEJN?=
 =?utf-8?B?d1NjWG9mQ1JuUmx4SExiekxUbDRBQTNmdkEwdHJ1dzVOZno0clJ2eElPSTVX?=
 =?utf-8?B?bGFYMlYzM0QvQ2dBWXhvNm5BRFZYd3RxeVIrb0Z2L04vQkVZUFI1OEZtQkt6?=
 =?utf-8?B?eWVuMmc4ZGtvTjFDVkhxMjZLMjdrdVdydnVrOGpIVUlJM29leXFwS296enMr?=
 =?utf-8?B?ZEFJbHNjM3RtemIyRmZJZHhQMXdQcnk3ODJaL2FST0JWTTFUNWM4R0lQNHFX?=
 =?utf-8?B?WWFlRGphZDVZd2c4NnZTdXplTUdMUTI5ZzRqaVZoTE11U2xxa2NMcUE5UGpy?=
 =?utf-8?B?dUFpY3UzSXhRbnhzK3ZJR3F3SEhybExXTm9zMS9lOHlCVCtCbTdIbHRVRnBQ?=
 =?utf-8?B?bmJBUGxCRklKcGRSOEwrRFp4VFpsd0x2VzdLUUNlYncyRUprcVVKRzFvRUl3?=
 =?utf-8?B?ajNTZ0Q1bnFvdk5xVUdxb2NheTF2MitiNVVHRDRWOUI1aUxtRXJOblZ4VUV6?=
 =?utf-8?B?S0FXRWFvSXpROWNlelVxay92WktjTEo1OENyTG13akVpdEprNXZwWE5Ia2Zl?=
 =?utf-8?B?VklUVloxOFRRdDFja1cxdjh1RnlQSVhJMUJ5V2Y2QTdmSi9WeW9lZCt1WGpt?=
 =?utf-8?B?Ly9xR1BJazNmZ0lOMjloaW1VVERCNi9zeDd6d0JKdGFFUS85eFRhMW90ODZm?=
 =?utf-8?B?MzBwL1JBWmNxUkpyMWxHMzg0djhmZGhNcjRiNXdScmlhUndKUURDUkk3dlU1?=
 =?utf-8?B?bHRnQ1FkanJjYXNUbzB2RmxtTU52R0ZWR2dNcSs5eEFLaDZWTGlmZEticHZw?=
 =?utf-8?B?enp5YVU2MlJuZ0xWVnlLQ2hqQ2RSaEduR0t0NDBkK0V2M2tLbFdTc3FESU5G?=
 =?utf-8?B?UDdjYzhuT1BzSVN0R0lXbmE3cVYwempFVWgvTCtTUE5tbzBkeVdYWVhxQWJT?=
 =?utf-8?B?c1ppU2JPUUZRaGFCRmVnZEdRSWNHTW9JbXBxRW54Qm9jUUNxTmh0VjlJYit6?=
 =?utf-8?B?bEdZbmpDQ2tySk9sN2JLOEUvdVVMemk5aTh3c2tzRThmZHZSMVd1WEdNZmZS?=
 =?utf-8?B?TzB1c29YSllrb0IwaFJhckFZaVFkaG9sV1U0RkllKzhSTkg4b3QvVEQ0bDRk?=
 =?utf-8?B?alRPMDE5UWxMa0NtMkl2TERjVElNT2N0Q3puQk0rUHNGNHJyZnIyZmlPRGc2?=
 =?utf-8?B?UXBLb0xKQk1JSjhHUDMyblVCZ3Q1Umg1Y1U2MXpUT3ZXUkdacS93MzBldVFI?=
 =?utf-8?B?cys3dTE2OVJkd1Z4bEJrU0hNUDZNcEl5SGRVZUNaOXZUc1JlTUtUdlE3VWxr?=
 =?utf-8?B?YThCTUxHUVNmRmdzNWd2M1NJclBSUTlYYUd6OGRuZVpXUGVLRmgxbGRvcldE?=
 =?utf-8?B?c3N0MmhYM042RjZmMXVsY0prejhTeWE0OGdTZ21YcXRkeXFsL3hZbXdCa2FY?=
 =?utf-8?B?N2RNZWpxaXVQR0FBNkQybjc5bURYWkMyV0xOZjk1UXpxb0hnN2djbTRhZHkr?=
 =?utf-8?B?WE5FaEJGMk9CaFZ2RkZUTXMyYmR3M0twZCszZ0VZajhvN2p1VG40cGZhY1F3?=
 =?utf-8?B?S09yT1lEb3lDUHRnRStpSmhOT0psT2ZxNU53OGhRYXAyUHFYQXFwVjB3SzR5?=
 =?utf-8?B?aE0wWEVnakd6bTZ1ODBlQ3ZWV1gvSTZtdy9JSUl2SFYyMS9pZmZ4bTBYNFNi?=
 =?utf-8?B?QkwwbU1TNlNwcnlKNFlzQ2NDL2FUZ3hWalhFYzhTYWpnWEkrN0hnSk9NNm5V?=
 =?utf-8?B?L05mM20zVG8yNEpBMDRWc3gzY2lIaEk5R21halczb3dZbHpuMFdTQnpaaElk?=
 =?utf-8?B?K1hNQ0FxMkJ1bnpmQWNjTFNJZytBYUoyRS8zZ05jQ1FleFhLSGdyVENNRld6?=
 =?utf-8?B?eE9vMDhyLzd0ZUExM3p1OStmSHpDTS94aW1Eb2ViSVpPd256ZzdhcUhNRTNW?=
 =?utf-8?B?a2pnMkJ2dkxjc0hQL1l6MTJzb3g3YXRPZVBwcmlhY0N0YVJNbXlmV3JCNUlw?=
 =?utf-8?B?eTFobnc1MFdBTmhQeTUrSHYrdVRkaHNPMkxMZ0dKd2tmNmdDd2JKRk9yYlUw?=
 =?utf-8?Q?7BKJt5vx2NEDzFgd39Eg16Vy6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <07E399F183A8674BAE79BD5F92CE950D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b553184-e97a-4783-dc67-08de1604c953
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2025 09:31:34.6539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k30weKTslG4SbM7gblW0IJaFR/CDrDgHZVcfjm5a8LQYmE+Hmi+k3/tf1IuseaRdFF5DV2uqtJxkMqlWWBLvlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7258
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTEwLTI3IGF0IDE3OjA3IC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiBPbiBNb24sIE9jdCAyNywgMjAyNSBhdCAyOjI44oCvUE0gSHVhbmcsIEthaSA8a2FpLmh1
YW5nQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gTW9uLCAyMDI1LTEwLTI3IGF0IDE2
OjIzICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90ZToNCj4gPiA+IE9uIE1vbiwgMjAyNS0x
MC0yNyBhdCAwMDo1MCArMDAwMCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4gPiANCj4gPiA+
ID4gPiBJSVVDLCBrZXJuZWwgZG9lc24ndCBkb25hdGUgYW55IG9mIGl0J3MgYXZhaWxhYmxlIG1l
bW9yeSB0byBURFggbW9kdWxlDQo+ID4gPiA+ID4gaWYgVERYIGlzIG5vdCBhY3R1YWxseSBlbmFi
bGVkIChpLmUuIGlmICJrdm0uaW50ZWwudGR4PXkiIGtlcm5lbA0KPiA+ID4gPiA+IGNvbW1hbmQg
bGluZSBwYXJhbWV0ZXIgaXMgbWlzc2luZykuDQo+ID4gPiA+IA0KPiA+ID4gPiBSaWdodCAoZm9y
IG5vdyBLVk0gaXMgdGhlIG9ubHkgaW4ta2VybmVsIFREWCB1c2VyKS4NCj4gPiA+ID4gDQo+ID4g
PiA+ID4gDQo+ID4gPiA+ID4gV2h5IGlzIGl0IHVuc2FmZSB0byBhbGxvdyBrZXhlYy9rZHVtcCBp
ZiAia3ZtLmludGVsLnRkeD15IiBpcyBub3QNCj4gPiA+ID4gPiBzdXBwbGllZCB0byB0aGUga2Vy
bmVsPw0KPiA+ID4gPiANCj4gPiA+ID4gSXQgY2FuIGJlIHJlbGF4ZWQuICBQbGVhc2Ugc2VlIHRo
ZSBhYm92ZSBxdW90ZWQgdGV4dCBmcm9tIHRoZSBjaGFuZ2Vsb2c6DQo+ID4gPiA+IA0KPiA+ID4g
PiAgPiBJdCdzIGZlYXNpYmxlIHRvIGZ1cnRoZXIgcmVsYXggdGhpcyBsaW1pdGF0aW9uLCBpLmUu
LCBvbmx5IGZhaWwga2V4ZWMNCj4gPiA+ID4gID4gd2hlbiBURFggaXMgYWN0dWFsbHkgZW5hYmxl
ZCBieSB0aGUga2VybmVsLiAgQnV0IHRoaXMgaXMgc3RpbGwgYSBoYWxmDQo+ID4gPiA+ICA+IG1l
YXN1cmUgY29tcGFyZWQgdG8gcmVzZXR0aW5nIFREWCBwcml2YXRlIG1lbW9yeSBzbyBqdXN0IGRv
IHRoZSBzaW1wbGVzdA0KPiA+ID4gPiAgPiB0aGluZyBmb3Igbm93Lg0KPiA+ID4gDQo+ID4gPiBJ
IHRoaW5rIEtWTSBjb3VsZCBiZSByZS1pbnNlcnRlZCB3aXRoIGRpZmZlcmVudCBtb2R1bGUgcGFy
YW1zPyBBcyBpbiwgdGhlIHR3bw0KPiA+ID4gaW4tdHJlZSB1c2VycyBjb3VsZCBiZSB0d28gc2Vw
YXJhdGUgaW5zZXJ0aW9ucyBvZiB0aGUgS1ZNIG1vZHVsZS4gVGhhdCBzZWVtcw0KPiA+ID4gbGlr
ZSBzb21ldGhpbmcgdGhhdCBjb3VsZCBlYXNpbHkgY29tZSB1cCBpbiB0aGUgcmVhbCB3b3JsZCwg
aWYgYSB1c2VyIHJlLWluc2VydHMNCj4gPiA+IGZvciB0aGUgcHVycG9zZSBvZiBlbmFibGluZyBU
RFguIEkgdGhpbmsgdGhlIGFib3ZlIHF1b3RlIHdhcyB0YWxraW5nIGFib3V0DQo+ID4gPiBhbm90
aGVyIHdheSBvZiBjaGVja2luZyBpZiBpdCdzIGVuYWJsZWQuDQo+ID4gDQo+ID4gWWVzIGV4YWN0
bHkuICBXZSBuZWVkIHRvIGxvb2sgYXQgbW9kdWxlIHN0YXR1cyBmb3IgdGhhdC4NCj4gDQo+IFNv
LCB0aGUgcmlnaHQgdGhpbmcgdG8gZG8gaXMgdG8gZGVjbGFyZSB0aGUgaG9zdCBwbGF0Zm9ybSBh
cyBhZmZlY3RlZA0KPiBieSBQV19NQ0VfQlVHIG9ubHkgaWYgVERYIG1vZHVsZSBpcyBpbml0aWFs
aXplZCwgZG9lcyB0aGF0IHNvdW5kDQo+IGNvcnJlY3Q/DQoNCkkgd2FzIHRoaW5raW5nIHNvbWV0
aGluZyBsaWtlIHRoaXM6DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyNTA0MTYy
MzAyNTkuOTc5ODktMS1rYWkuaHVhbmdAaW50ZWwuY29tLw0K

