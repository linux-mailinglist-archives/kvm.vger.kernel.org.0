Return-Path: <kvm+bounces-66286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 76369CCDE25
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 23:53:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D40543026292
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 22:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC00E322B68;
	Thu, 18 Dec 2025 22:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EgiYJVHU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6112F8BEE;
	Thu, 18 Dec 2025 22:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766098402; cv=fail; b=eMhYAba9zeP2QInY1QBHhEBvsIO6yJIc5gDlOXANMViV/1Y+Obx7MnQmVVrqy6OR1FKkOg/ugnP1POPNCaP4d6HYzcoTC/iX0U5UG/TrXGE9mX0YVksBmDilzqIXZzLlrmDQNr3/3aZMqlwBb+qbKPl8I0i1Xg0MdsvhQhY2hvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766098402; c=relaxed/simple;
	bh=Suw5TNqfLZvNLZ0UfFVbk8Cz+sbVCaRX5aDfooIx+o0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qQDWEfoBmZBYRVMbpBc9uUtqQFrhLOpnxQbEsEhvdwB3HquBgaLIT00FQk5QQUDYfhn03Xrt0RSWBa+K/oZyRSdVpfrPdoJ9G2RD8zyASWUb11Vh1iUh+21AJMbwUrvYuSniY5NlPVIc9F+HqoF2Zu9v2LwHZ0EwS3IMdoFHJd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EgiYJVHU; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766098400; x=1797634400;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Suw5TNqfLZvNLZ0UfFVbk8Cz+sbVCaRX5aDfooIx+o0=;
  b=EgiYJVHUvQGM43Dwf4TAB8SeG+fD5pooybtRqewh/fVR6r3CFX11IdRI
   pHx834lxMDrJ6zLy0EC2uW0HLFpCK1GAumqfIuaNcPOvVtd8xXN751GE3
   sFrhirDWGJ2Xj1P2Hao5fkIAhPSJ4uNvCqYsrkIKNmSn4ALWtFMmqsipL
   Sr1W4B3dxP+FZ+Ssr9lgHL6jLyq39/U3MW92ifeG/4FD2/jH49m/TAIYT
   XVHFEV5AkFbWu5npAWxXN0FaqX69QGkszsAuG2Sn1irrnROUnt/pXOcn/
   iu/2TUy0jWw0Jj1BORgvql+jYlS/UscL+ZTpWwxnpO2Jg4xOPizKIzQnP
   w==;
X-CSE-ConnectionGUID: viZscjClSCKFMgzNLp1JMQ==
X-CSE-MsgGUID: aKW1WEX8RJirZJyQeNMXkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="68100434"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="68100434"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 14:53:20 -0800
X-CSE-ConnectionGUID: cV9rPfuaRq2AiDDjwATvbg==
X-CSE-MsgGUID: 0Xha0xKzTt6GttZ3XF9JzA==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 14:53:18 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 14:53:18 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 18 Dec 2025 14:53:18 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.16) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 14:53:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yggTJTVOeF2R6e/q2Ri7c07JPMo3K/AU+NwSRfAC59x1S5wWbw0+uWhZMjPf7c13U/y4dSfTbG3+Jxzx4mcLkaOPZZi9w0sQSqv18qukxY7QVmbzqAffrXgavkMeliPbPGMrl+hPjEpsmd2e393gXUOmqeUFNO+XEp//aE97/wpykNDj/RlwNVHw55+PPAxKDncCtoS30J9/fpYbWhLuRX+Vh6A4XDxR5Xb82LBq5G5TLoDBnum6/Kv5THL4SEjODc8+K0E9rxacSl3Uv2L9XFHtIM/493LNZzkLZXwJTkRPUJpuy+OHNFXjP7r6JKBPVTN8d5LDFWVzxId61mPzMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Suw5TNqfLZvNLZ0UfFVbk8Cz+sbVCaRX5aDfooIx+o0=;
 b=o+ZL5zeeU0JHANPfCECD9rL2jqSIGF1WbI/KgSuubQ10o6D9ezoXya6I7SIBzrqpxpnns/D0TPBxeaDfIl9cVqM+WC5jXZuT+NXqo5t9gAZ4guy2BOaTofWvrmS1EEi0ENK2mpCEcppew2LsjM6PmDubKVUhsV9J0Q9DjWMVK8RI89+bxJH9ZGSqf2NwzhjSScnvA53eFMpGwYC0coo2Ewd/XGXGEBeXInyDH5KHsSFX4N/Eao4iJBcrSMvggr7tJd1qzLevGnPdA0ZJy0070X9Ll9yCaE6AQBuW4eb5E3nj0fONKPuli/813/lq8HnXUp5SmHynxI4WpJrVA9TJzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH0PR11MB5207.namprd11.prod.outlook.com (2603:10b6:510:32::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 22:53:14 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 22:53:14 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
CC: "david@redhat.com" <david@redhat.com>, "liam.merwick@oracle.com"
	<liam.merwick@oracle.com>, "seanjc@google.com" <seanjc@google.com>,
	"aik@amd.com" <aik@amd.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 2/5] KVM: guest_memfd: Remove preparation tracking
Thread-Topic: [PATCH v2 2/5] KVM: guest_memfd: Remove preparation tracking
Thread-Index: AQHcbdh++wKr7VO430mO4VqfJNIP/LUoBnsA
Date: Thu, 18 Dec 2025 22:53:14 +0000
Message-ID: <35e79cadf079622588ddb9fac0ccc985751dd81b.camel@intel.com>
References: <20251215153411.3613928-1-michael.roth@amd.com>
	 <20251215153411.3613928-3-michael.roth@amd.com>
In-Reply-To: <20251215153411.3613928-3-michael.roth@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH0PR11MB5207:EE_
x-ms-office365-filtering-correlation-id: 7454387d-2f34-477d-d499-08de3e883a49
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ZzBjZjl3ZHhJaVJpVmduaGZEbThSbjdLeFpVMGQ4ZFZhOFRPS2xic0g4a3kr?=
 =?utf-8?B?a25VYW55Qm9sNlVqdXF4Zm92Q1BZVGJGVU5mbm1GRERVSWdXRjFhalVBV2tJ?=
 =?utf-8?B?MjFKaWpUbHFXbEJMVXJaSnMyaVdEZUk4NjhLUDVKYkNlRVEwdUdta2xzTjh0?=
 =?utf-8?B?bTh5dGtqdkw2aEtQUlBoZDZFR3lKOTY3YUt1cXg2VWNZNVRRTEJ6TitDS1RW?=
 =?utf-8?B?eUh2Q3BzNGdZWStKYW5IWUdXTDMybGY4Z3dJTUp3anJlU2lueTgxRFZZUVoz?=
 =?utf-8?B?UkZQalFxOXVKSnRwNFBHZGZCR043b0N1ZTd2d2RhQ3pMWXZNMHczbkhGcUxh?=
 =?utf-8?B?YVRGOG1yY0IwU1ZYOTZ5UG5GZ0UrYklMUmRxQ1JMZ0FyaWZ6WVhpYkJjUk5I?=
 =?utf-8?B?UWo2Z09WeG5DUEFyNU1zK0diMHNWQTZBOEdWYjN2NDhpNTE0Y05WM3BiR0ZK?=
 =?utf-8?B?QkxSUy9uOTVkdmFFQnRBOVBZYVdyMlNtaVJmOUdLVmlZUnJ5ckNkS1NtU09V?=
 =?utf-8?B?TldxQU0rNGhzeTdrRkkxUEltMER1azR4anh1dWtVOEFDUU5SaEFHSmRRTGZI?=
 =?utf-8?B?QWszdU9DdmRKK05pMFRyL3pwWVNCdWNYYzcwRDlWZktBWFl5MUtEbjBPallv?=
 =?utf-8?B?MTErZ0JOeTViK25DUE5TeTk5MGdVU29UYUxaNUJ6OEcwc1Q2V3Z2UkVqeVBh?=
 =?utf-8?B?cmNEZGIxeU11K2Yvdmg1WjdPcFkwSGh2NGNObjQ4QlI1RlRMWUI2Nm1XT0pC?=
 =?utf-8?B?NjRQb1hkczJ5REdCSWxLbDZZYmF1YTY3SXI5a0Jxa2twQTgxdmJzR1ptbnAr?=
 =?utf-8?B?OU5UOGduNDZqM21HNnBsUFMvTkUzNFdDTTVuVTZaSkZ1a0JmVlExUkZCdnp4?=
 =?utf-8?B?NytwZ21pc0VqT2tNeTJScHBEQ0oxZHA3M3hZZVZPTDM5eVJKYVRVMkRxR3hl?=
 =?utf-8?B?R1JFUzZxNThJNEpoVTZyRkZkUC9mcyt6TlErMitaSE9aWHVTNHpPMENPWHdi?=
 =?utf-8?B?WFFwL3d1OXJCendTRHBRZUJrK2pESHNPbGhSbmo0Mk0yN2c2V2VCWTVsWjlJ?=
 =?utf-8?B?MnBMbUV6aUJlMEZFcG90dW85akxmNEFhVC9xVHZkb21wa1RLTUI5N05tWERl?=
 =?utf-8?B?a3NDcjFOT2hVR3NKV1NDa2djVXJaNFdVMmxGS0dZSzV6TGpMYWxUSXNhWnNG?=
 =?utf-8?B?RVlwTmVTMkFxcm1iTi8zSWRQQjBEMmk5a1BSUk5aenRiSjAvaXlSbjJqSWpW?=
 =?utf-8?B?bDBTUTFVZ0R6aXFNUTBJM0lMald0TlYrNmdROXRVb1VhUHQwazMyVTh2VVZK?=
 =?utf-8?B?OUczK3p4bWI3ZG1qVTM5RW5XTm9tUXdjb04rb3J5M1pHZkRLVlhRU3pnSGVs?=
 =?utf-8?B?clZpY0ZFQUZBYTkxVjJZdjB1ZlBOVHk4b2RuanFlM0E0TGR3ekZLUGQvcWZE?=
 =?utf-8?B?YytFNDgrUW5HRXBvS3NuZUhrd290cXZzSEFFRzZFRzdHSEZQdTRrcUZONzJJ?=
 =?utf-8?B?NTY2WnFIaWZRVXRyOW9neTg5VDNtbHVhYXlSOE5mcGdOd2l2elQ2S29lWDcr?=
 =?utf-8?B?TW1WUk4renFmazZDOWo2SmNMeC9HWFhJM3d1VTRpeTBxMGFiRDM3VVVNSzB6?=
 =?utf-8?B?WDdzTXdIYjlnV2VPR3ZpRlFkOG41dzJBUk51ZU56RCs5QkU1OHl3MU9RQjly?=
 =?utf-8?B?MkJVWDBxWWhzQ2FGRjNncGJkeVlGSXBuT0VBNS9FdXFHREFGYmU0ZHBwQXhS?=
 =?utf-8?B?b1phVjlybXFIZ3BPUmhGQTRzekVlK0dTTGcyY0lFTG1GZk95cGw1Q2RsN2M4?=
 =?utf-8?B?bG9HOFdqcWxyS2MzVXNYS2hTQlVOeWhtc2lHZHRlWDhmVms5Y0dacW9iQmVS?=
 =?utf-8?B?QWthVnBwTjNPWVlnNndOYXFaamgwNDRSR0N4ZUc4OHlPREFWY25tcUtYcDJB?=
 =?utf-8?B?ZFJiY0h2MjkrNWJEZzBTNW13ZkswRkNld0JvWUdzQ2RHeHlZaGtJYk1qa09m?=
 =?utf-8?B?eUNRSkg1b05KU2ZsZVMzWjVXbjdmZzJrYmJsSjliTXZTb0pENDYvVk9IVUhY?=
 =?utf-8?Q?fcni5J?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXZTQlYvUE1hb203UHFQY3RoODJxdzJHcUw4b1JVVENUaTVrQWRkdHdqSXha?=
 =?utf-8?B?YlZRSTRyaUYzUTVLcEdtYnNWaFBhQVNocmhBVWRjSGJLSmNPU0JVZ1IyQXRa?=
 =?utf-8?B?ZS8vZ1Z6Z29QbWtXcCt2dFdwWHNVK25VRGl4UUx6a0FrM2gwb1ZDdlRxRzdh?=
 =?utf-8?B?MlZtMVplSTdjZ2VsQmxEWHNkY01rUUZ2WG0rSXBqTlUyeE1hbEV1bG5FcnZZ?=
 =?utf-8?B?Mm80S3lnSm91TVkwaE9XaGFmZ3NEQitLM1RHTWFLejBoZnk4aHBSb2lCanNq?=
 =?utf-8?B?U0IvR0FzWkcwRGxzYWZqdUlpZDFDang0WnFrZ0Rnelc0MTc3YnZQY1hCRzJX?=
 =?utf-8?B?RnVTbldEZjB3OW1qMEVKZGYyaHdyeGlvczdlWWdVMUQ1WThMMVBjdit3eVYx?=
 =?utf-8?B?MHd6RHlwaVpBVHdyOUVCRUM1ODZZeTJlSEJMTDJvZmNsaHd3UG9xRDkzQjJq?=
 =?utf-8?B?QUNrQXhYSHN5ZHZ1QWl6VGZDNzlBL054RVFOUFc4K0lSUzF0OFFIclhhMFgw?=
 =?utf-8?B?K1ZrLzA5K3hGZkVRaE1aN1JvV0s1Z3lpWmpYZ09yVVl2eElXU1JwOEJnblR0?=
 =?utf-8?B?NnRIVXZPRmp1SDRhdjJSRWFCdVFpS0wrZHdLcllaMVdickxFMWFtN2xtL0FM?=
 =?utf-8?B?alhKalVUMHcyWWZoZVI3WWdlR2pNY2JMK3lzS2xFbllVT3BidFlPUkFBMkVu?=
 =?utf-8?B?M0NWR2JRa2I0ZEt3R3JqcE9EMWtSbjlsN3ZwT2dIZXViVW8waVE5ck52dE9I?=
 =?utf-8?B?a3k0UjdXaHdDYXBEbi9hMDkzM2NxK2JsVTA0eGZWOGRERTMycDV1eWM4NnVB?=
 =?utf-8?B?K3VYbVhOQ2VGY2lRNzhXbE5FQmZaNWo4U1UrY0dKa0JWU0VRUkI5ZFJMVzZv?=
 =?utf-8?B?bnVDVHNIeTU3SHl5Tm1JWjZITklnWWVjTlk2cHdrVEhGYmN1UFNmdTdMZGhD?=
 =?utf-8?B?dlhmR2JNY1lxUE02ek5WRVVKVHpCNUJQQlI3aTZWOG9vT1AxVHpGTEJ5K3Np?=
 =?utf-8?B?UjE1aTVXVmNreUFuNElLUktsVTR1bkc5dzVLZzQyaFFJcjRkcFJia21WS1Jz?=
 =?utf-8?B?cHJaaW1LR0lBeEQ5VUgvS3I0MTh1WE5kam1OaWs0a2tDdmRLaXlpK1dSR3Nm?=
 =?utf-8?B?b1MwM0NpdURvVVpqWU9TZGlwK3NGZFVFUEZxcDBCcTR4M1lWNWZkYWM4RDJZ?=
 =?utf-8?B?VmZ2ZFdEaVJodzg0VThPdXBWRFpXa3lsbEF3TjRwYzZtMlBJRENDVmpWajlx?=
 =?utf-8?B?QmZvdFowRlgxOVdCeHRIRjRmWXg1WGZ6RGFuMHhudHdXcS9vV2s4WFFUVkZL?=
 =?utf-8?B?ODhQVlpzR1FNVFpMcG5vZlRtaHpsVlNjMUFObUpzZlhvMjFLcDB5bHJqOEVR?=
 =?utf-8?B?c1dudVUrRHlIMjRnbHgxcXZsOGpkSEExMGFpY2dqY0xMS3E4VDYyNUp5cThP?=
 =?utf-8?B?ZzJLMXJxOEkzUFljWXlsWDJZOEV4RlJIQWJXOTVhRHZaVmxTR2QwRHh2cW9K?=
 =?utf-8?B?VDJIVFExc3F4MGp6bFFSOXlBaExJdTZESWJpOUNveTFHdnoyUHA0N1pBU3Bk?=
 =?utf-8?B?V05sYkZUMlJhYUh6RXFjaG0yL2FUNW1abFZDbm9rNHR2L2V5dEk3ZVJqbjRK?=
 =?utf-8?B?NWRVQXRyZ2kvZWVEV2dXVm9reGdjN1ZNdlhub0RuOEZuVUlNOEFTZHE4YW5F?=
 =?utf-8?B?YTh3K2tGZFpnSE1jVXprclllYkttMmY0MGFyUUNjTDd0QWNLckhJWTJycHpK?=
 =?utf-8?B?MC94Y0Z3aUhHaFlrem1tQ0pCVnExbnFVZldTOGR1NzRUT2J4RmtjUHFsWmVx?=
 =?utf-8?B?K2xqSkNwRUhLMGtRdWNoOGVWdEZLb3NFcFJZTVJpelFPR3Q1T0NxNHQrUExy?=
 =?utf-8?B?RjJLc0U4aTdKQUhVUG9rK1lxblF1Uk1xM1oreDFsaHFrb1VKeGZROWh3ZUxF?=
 =?utf-8?B?OGZ1OVFsUDRIcnVlWWZ1c00zczd1ZmFQbWJ0SW1RUExlck91TnRGNGpvdkNu?=
 =?utf-8?B?Nk0wQmRWU2lVL2czaU12R0NyZGFKRFEyTnp5QXNLOEdDZGhqY0dhLzdJcDMx?=
 =?utf-8?B?VXczUHB2a1pKYVJZYm9XeTFkMTZYY1psM1U4c05tSXFJRzByZWtxUmJpc1E4?=
 =?utf-8?Q?HvIts8+lGPw3JnTDHVtW9F8IW?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9B8BD70BC38D443A6D605576E410FB6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7454387d-2f34-477d-d499-08de3e883a49
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2025 22:53:14.7283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paPFJ6m4vm/T/gvzZKo1o70fgdaQCHteXYsLYmupUvJlPpCPCSNHTYGProe4vYY3ZLIWm7QrQsyJ91kjliTAYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5207
X-OriginatorOrg: intel.com

DQo+ICAvKg0KPiAgICogUHJvY2VzcyBAZm9saW8sIHdoaWNoIGNvbnRhaW5zIEBnZm4sIHNvIHRo
YXQgdGhlIGd1ZXN0IGNhbiB1c2UgaXQuDQo+ICAgKiBUaGUgZm9saW8gbXVzdCBiZSBsb2NrZWQg
YW5kIHRoZSBnZm4gbXVzdCBiZSBjb250YWluZWQgaW4gQHNsb3QuDQo+IEBAIC05MCwxMyArODUs
NyBAQCBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX2dtZW1fbWFya19wcmVwYXJlZChzdHJ1Y3QgZm9s
aW8gKmZvbGlvKQ0KPiAgc3RhdGljIGludCBrdm1fZ21lbV9wcmVwYXJlX2ZvbGlvKHN0cnVjdCBr
dm0gKmt2bSwgc3RydWN0IGt2bV9tZW1vcnlfc2xvdCAqc2xvdCwNCj4gIAkJCQkgIGdmbl90IGdm
biwgc3RydWN0IGZvbGlvICpmb2xpbykNCj4gIHsNCj4gLQl1bnNpZ25lZCBsb25nIG5yX3BhZ2Vz
LCBpOw0KPiAgCXBnb2ZmX3QgaW5kZXg7DQo+IC0JaW50IHI7DQo+IC0NCj4gLQlucl9wYWdlcyA9
IGZvbGlvX25yX3BhZ2VzKGZvbGlvKTsNCj4gLQlmb3IgKGkgPSAwOyBpIDwgbnJfcGFnZXM7IGkr
KykNCj4gLQkJY2xlYXJfaGlnaHBhZ2UoZm9saW9fcGFnZShmb2xpbywgaSkpOw0KPiANCg0KSGVy
ZSB0aGUgZW50aXJlIGZvbGlvIGlzIGNsZWFyZWQsIGJ1dCAuLi4NCg0KWy4uLl0NCg0KPiAtCWZv
bGlvID0gX19rdm1fZ21lbV9nZXRfcGZuKGZpbGUsIHNsb3QsIGluZGV4LCBwZm4sICZpc19wcmVw
YXJlZCwgbWF4X29yZGVyKTsNCj4gKwlmb2xpbyA9IF9fa3ZtX2dtZW1fZ2V0X3BmbihmaWxlLCBz
bG90LCBpbmRleCwgcGZuLCBtYXhfb3JkZXIpOw0KPiAgCWlmIChJU19FUlIoZm9saW8pKQ0KPiAg
CQlyZXR1cm4gUFRSX0VSUihmb2xpbyk7DQo+ICANCj4gLQlpZiAoIWlzX3ByZXBhcmVkKQ0KPiAt
CQlyID0ga3ZtX2dtZW1fcHJlcGFyZV9mb2xpbyhrdm0sIHNsb3QsIGdmbiwgZm9saW8pOw0KPiAr
CWlmICghZm9saW9fdGVzdF91cHRvZGF0ZShmb2xpbykpIHsNCj4gKwkJY2xlYXJfaGlnaHBhZ2Uo
Zm9saW9fcGFnZShmb2xpbywgMCkpOw0KPiArCQlmb2xpb19tYXJrX3VwdG9kYXRlKGZvbGlvKTsN
Cj4gKwl9DQoNCi4uLiBoZXJlIG9ubHkgdGhlIGZpcnN0IHBhZ2UgaXMgY2xlYXJlZC4NCg0KSSB1
bmRlcnN0YW5kIGN1cnJlbnRseSB0aGVyZSdzIG5vIGh1Z2UgZm9saW8gY29taW5nIG91dCBvZiBn
bWVtIG5vdywgYnV0DQpzaW5jZSBib3RoIF9fa3ZtX2dtZW1fZ2V0X3BmbigpIGFuZCBrdm1fZ21l
bV9nZXRfcGZuKCkgc3RpbGwgaGF2ZQ0KQG1heF9sZXZlbCBhcyBvdXRwdXQsIGl0J3Mga2luZGEg
aW5jb25zaXN0ZW50IGhlcmUuDQoNCkkgYWxzbyBzZWUga3ZtX2dtZW1fZmF1bHRfdXNlcl9tYXBw
aW5nKCkgb25seSBjbGVhcnMgdGhlIGZpcnN0IHBhZ2UgdG9vLA0KYnV0IEkgdGhpbmsgdGhhdCBh
bHJlYWR5IGhhcyBhc3N1bXB0aW9uIHRoYXQgZm9saW8gY2FuIG5ldmVyIGJlIGh1Z2UNCmN1cnJl
bnRseT8NCg0KR2l2ZW4gdGhpcywgYW5kIHRoZSBmYWN0IHRoYXQgdGhlIGZpcnN0IHBhdGNoIG9m
IHRoaXMgc2VyaWVzIGhhcw0KaW50cm9kdWNlZCANCg0KCVdBUk5fT05fT05DRShmb2xpb19vcmRl
cihmb2xpbykpOw0KDQppbiBrdm1fZ21lbV9nZXRfZm9saW8oKSwgSSB0aGluayBpdCdzIGZpbmUg
dG8gb25seSBjbGVhciB0aGUgZmlyc3QgcGFnZSwNCmJ1dCBmb3IgdGhlIHNha2Ugb2YgY29uc2lz
dGVuY3ksIHBlcmhhcHMgd2Ugc2hvdWxkIGp1c3QgcmVtb3ZlIEBtYXhfb3JkZXINCmZyb20gX19r
dm1fZ21lbV9nZXRfcGZuKCkgYW5kIGt2bV9nbWVtX2dldF9wZm4oKT8NCg0KVGhlbiB3ZSBjYW4g
aGFuZGxlIGh1Z2UgZm9saW8gbG9naWMgd2hlbiB0aGF0IGNvbWVzIHRvIHBsYXkuDQoNCkJ0dzoN
Cg0KSSBhY3R1YWxseSBsb29rZWQgaW50byB0aGUgUkZDIHYxIGRpc2N1c3Npb24gYnV0IHRoZSBj
b2RlIHRoZXJlIGFjdHVhbGx5DQpkb2VzIGEgbG9vcCB0byBjbGVhciBhbGwgcGFnZXMgaW4gdGhl
IGZvbGlvLiAgVGhlcmUgd2VyZSBzb21lIG90aGVyDQpkaXNjdXNzaW9ucyBhYm91dCBBRkFJQ1Qg
dGhleSB3ZXJlIG1vcmUgcmVsYXRlZCB0byBpc3N1ZXMgcmVnYXJkaW5nIHRvIA0KIm1hcmsgZW50
aXJlIGZvbGlvIGFzIHVwdG9kYXRlIHdoaWxlIG9ubHkgb25lIHBhZ2UgaXMgcHJvY2Vzc2VkIGlu
DQpwb3N0X3BvcHVsYXRlKCkiLg0KDQpCdHcyOg0KDQpUaGVyZSB3YXMgYWxzbyBkaXNjdXNzaW9u
IHRoYXQgY2xlYXJpbmcgcGFnZSBpc24ndCByZXF1aXJlZCBmb3IgVERYLiAgVG8NCnRoYXQgZW5k
LCBtYXliZSB3ZSBjYW4gcmVtb3ZlIGNsZWFyaW5nIHBhZ2UgZnJvbSBnbWVtIGNvbW1vbiBjb2Rl
IGJ1dCB0bw0KU0VWIGNvZGUsIGUuZy4sIGFzIHBhcnQgb2YgImZvbGlvIHByZXBhcmF0aW9uIj8N
Cg==

