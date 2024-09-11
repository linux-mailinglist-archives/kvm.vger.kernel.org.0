Return-Path: <kvm+bounces-26570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9BB9975960
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 19:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84EF9286871
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 17:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476221B2EED;
	Wed, 11 Sep 2024 17:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JnDajBGS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86C04D8B9;
	Wed, 11 Sep 2024 17:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726075704; cv=fail; b=c8sRg7gME8MXgeYqk5vLGjO4n8OG8P00MqXmbJLaqap9RiHpUTMpt5SLRYHBKZW47q7CfmFYgpjd1oRMs2rxqWQv+ikOB+eTUE/GMdWRl97C8QRUvvDwSGLR5508lakuCu87e9DOh7pVcPu2432NIB8qwF7mdWegkNV2ybJAVo4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726075704; c=relaxed/simple;
	bh=IRqdBEpKMeDh9Y84f0wkchBpJRj14WcmCPpcOEZWCp4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cKQQfYpspw/RE7e0dtQG0W3UVpYXY54R3kZ+H1kT5OS26qqa8/S5fFuno4SiB/kyhrOKGsHSKEtbkJYGTWh+gPXHIAQYl4ZTa60uoVZyfNrRUmMBWEUV0Xl1nCgFaVepkgowhJxJPqzuHdEi15l5aTdd0uF1qYzTkxR4LzCFX5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JnDajBGS; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726075703; x=1757611703;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IRqdBEpKMeDh9Y84f0wkchBpJRj14WcmCPpcOEZWCp4=;
  b=JnDajBGSXIv4Eg7Jfo0fO9w8tESBh4b9Z7aw8FGXZe+yJ8RhuheEKjDK
   AikD49B3GabUUyIzk1XRoWujFe7YoYeNWpAHyt1wX1YcWy6oEypK1fNj1
   ihMYCfV4BOtjIqhL9qqKSd0M0qFJRA+jQj2MbZMfrIfWSJtZv/UX4cAru
   3gYSgGNfc51ICqAZK+ehcu6vex85a+qW47YKdI1860tD2aeJ1ev0kQNq3
   LuooDKpMhvF4cYA6NWi8ZxxqE5jZCThBjZAYUHvowY00NX0z+UHqUn4sL
   1wlPb/iaMz6mtXwVC4MVa0+CDbqMnG7gvwYv3+/V9JRHRJdHK/Zkt31ky
   Q==;
X-CSE-ConnectionGUID: svsCbCUcRHC3O+zSoMVQ8A==
X-CSE-MsgGUID: bMZGBgwxSNKqUi4lvojcNA==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="36029003"
X-IronPort-AV: E=Sophos;i="6.10,220,1719903600"; 
   d="scan'208";a="36029003"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 10:28:22 -0700
X-CSE-ConnectionGUID: MBhhn/DgRGKuVc4fNeXrCA==
X-CSE-MsgGUID: PIY5NQLtSjGb8vBgBByJcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,220,1719903600"; 
   d="scan'208";a="67446664"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2024 10:28:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 10:28:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 10:28:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Sep 2024 10:28:21 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Sep 2024 10:28:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YEfixMS4hNU9Gap/tsS6bHEecNGvyzcP541WB/n6wLMiGNncvZB9YCBzfjXNAp3rpxQjKwpOV4kSCj7sv03Two8jJJHqXFhRzgAMTjVOdd5HMHJXM4zcoBqjYANXPKMkp4KNC4DMALJMsBaEbmMRNeOiGE4AoACFOGPR2GAKOYLMAno9Bbmw3xbjdTxf54WnJK2LAYPqYfYKNAK/NZDfV9+otvfVPp6dtqA+x7LI2MBfMxlhgXmfM2eNQzU1sLj7e9AGEOxhMJnJ6DAdx+GcF6dqS4U0H5JJw4qn6/ik+Yvt52ts5zYI4g7PjpsE4vgKXp3/trTGv/0bnoWRo7bSpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IRqdBEpKMeDh9Y84f0wkchBpJRj14WcmCPpcOEZWCp4=;
 b=QftoDNL1R/Pg/ddoZQG5T9ucbCF07VUcLftEOOqvo1sAm0yY4Bs8ifHYpAEuOgfUWVxw9tm8OyZJVZgnPk/wT3wY51HOx86xmPTYOXJCOl3YdniCnc2O98j7BPdP+kWTcl9xVMzAA/7kdQQ/f6Xpb75w5EeYhaCQjH6t9/3QxKbPDjTBEW+xYnALc5mC17QfLTPdLzyrA7pEVtsoMGQOoC5zDAglC5E4CEeJghWOcs50A58hAvaDawIdDq90a2yxkvPXY5quTDO+hnwoXEeuGgXkqfpTD0znjz/WUkis65SfD96SOTjv8azlhraoxo8tsx4VesXntfyJ5n8IFaYZpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7010.namprd11.prod.outlook.com (2603:10b6:930:56::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Wed, 11 Sep
 2024 17:28:18 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Wed, 11 Sep 2024
 17:28:18 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 13/21] KVM: TDX: Handle TLB tracking for TDX
Thread-Topic: [PATCH 13/21] KVM: TDX: Handle TLB tracking for TDX
Thread-Index: AQHa/neyFCUwVv/2uUaPte14j/ISrrJSKfkAgAC5EYA=
Date: Wed, 11 Sep 2024 17:28:18 +0000
Message-ID: <6b9671bfdc7f1e8dab0ede65fa7c7e76f0358a06.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-14-rick.p.edgecombe@intel.com>
	 <ZuE38n/yhI24vS20@yilunxu-OptiPlex-7050>
In-Reply-To: <ZuE38n/yhI24vS20@yilunxu-OptiPlex-7050>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7010:EE_
x-ms-office365-filtering-correlation-id: 53eb828d-d1c6-47e5-3862-08dcd2872021
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cndpY1prbTYwQnJiQldvTVlMMU9aWDBodmtOTlF3OTRqV1RJdmFyYVZ4MVAv?=
 =?utf-8?B?WE5IQUxEK1AvRjAxN0FBMEd6czNYSnVuRUk1OURFLzh6RHZLRUlLU2s0eENS?=
 =?utf-8?B?VUJSOXdlanVtcDZueHZTUWUzRXpTdm5NVG90b09PWjRoQ0FqOHVyRTNRM3pC?=
 =?utf-8?B?TWhEMWdOY2RYT1AzSVViSGhCSmJ6OFVlRm10UWFqZnlFUllkT2ZUekFWdUF5?=
 =?utf-8?B?THhxLys4dU50THB5SCttait4dS94bEQzQnRsWGVKRGNnWCtSU2JmZ0dwcjdI?=
 =?utf-8?B?SDEyNW5DbmRxanhlckFZS3dmUzFvWnU0N0kvUjVJL05OK3JZL044TFVCL3pD?=
 =?utf-8?B?QWlOS2FsY1dYVHN4K1VPTE55Z0V5dDRaQmNKTnQya1BIdkd5UHBxY2t5aEFX?=
 =?utf-8?B?RkRZYjlXYlR3RHhRZHZoNklwVGtBN29RdnlNWk1WRTJERVZPbnVsOXoxRnNU?=
 =?utf-8?B?Z1R0TFpFK2tZdEl3NHAwdytUUmxRRjlDMkYrUy91Z2p6aDV0bUszUXJtRGhn?=
 =?utf-8?B?M29vdmRMdjhhcHV5VHB2MWFKVkh2blVEVW5Oa3E5bmhzYTlNZmdZQ3BIS2J3?=
 =?utf-8?B?dVc4WEpZNkxDRzV4RWQyUERvcFV0U0tJcldmMmhrRjZnUlQ4b3c3KzNOVHV1?=
 =?utf-8?B?Z0RwVm15Q0FmOVFoMUJ2cnBKZ2RqZmtMakdSS3djcFlzTnhiSmxUSW9WZWcy?=
 =?utf-8?B?U0xERmJMcENJWWFoWWoxQXFXMlBYQkJ1dGcyZkl6b1l5NWJ0cHJPTEdlU3Fw?=
 =?utf-8?B?Q1BLM1N4UVpEL0I1UFE4RTE5dzdKVmJDb3B3bUpSdkhSZG1IVmNZRUlpYjB2?=
 =?utf-8?B?QTFSaVVEdmJxQWJTTmdEOFVJMURSdUNzWDF6WEc5KzhFczNqNUduc0VQNVlK?=
 =?utf-8?B?dGJVRVIxVGNmZXQ3TWsvRjBTZ2YzN0kvUWZZTFFwdXBsUlhUNnBhemNwSGVZ?=
 =?utf-8?B?aU1kdmFVSFplSTJPNVJQS2p0TVZzZ0JVckw1YmE5M0J1SzJoQkc5d29jbU1Y?=
 =?utf-8?B?UTFQb21VOU44MkhIRGhzb1orWFlndndhd2RoQVJTcUJUOFdLV0pUaklGa0N0?=
 =?utf-8?B?ZnMvV0ZmeUhBU3JBcndrTzI3aXRIWmF5aDVjLzhidE93bDlUaUNmM29zUlVZ?=
 =?utf-8?B?ZElGTGpDckl5TW15UkdoeGVnM0xjcmt1KzZqbjA3YmY1UnpmVEgxYlJSYlo5?=
 =?utf-8?B?TVZCbFR4V2MxYi9VZWZJbEZGanlROGdyZ3ZWcmdEck5jZ1ZqRGtoeU9vWG05?=
 =?utf-8?B?TGllWk52SzVueUR2SlFZTkVLV0srSnZ6UEY4ODJwZVVMMDhwbFB0RVJ1RWRN?=
 =?utf-8?B?TmFrYWl0L1FaclVyRW9zUDhRaXpkSjdBYjRzUWc4MVNYUExPdjFsdXZ4VTJr?=
 =?utf-8?B?K2NRQlF3WU9jNmRNTjNYRFhIS1hiY3dMM0FDSUg0bDMrZ08ydzczS29RelNP?=
 =?utf-8?B?eXVFNU5Cc0c4VWN4Z1Q5d2lkWUh2T2Rtb0dlZ0NTR0tHVzRrREg3RXFNQW5j?=
 =?utf-8?B?MDR1M3c3Z1NGY2JsRlgyTk4wTjgydE4yS28wZmhxMFdJRjRteXZ1M3NCNko5?=
 =?utf-8?B?U0txWjBqclZSWklTNFZTZmZtUGc5bG1jZkd1NWdpelI2SVJGbmtsamRYbktz?=
 =?utf-8?B?NHR5RS9WVVNOVWZ4TzgvZ25HcTBtU3lXcnA1ODNSczYraEVqa0JOVXZuK29z?=
 =?utf-8?B?L1d1QnNmK0dZYVllL0hDMVhrcU1WVktnemFvR0VZTGliRER2cXArS09ydVJF?=
 =?utf-8?B?N3Z4MnY5elNYQjlPVkdoL01yc1dUaDFFM3BVeUl1M3JLQVdzZFlzODcwVzlW?=
 =?utf-8?B?SXR3d2hZck9CL1VDTkNycENONmhvcnMrWnBpeDFkSzFrUkFwYy9ISEFaSHRy?=
 =?utf-8?B?cnd0b1lOVW9yaWxEQzE3U2JhMjVHVEFOaWtaVzVlWHlaWEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emtHMU0zRk50MGorRjVpSDJYUTRRTEhWb0dyY3pHSFRMZHpkMmowSHpyNk5M?=
 =?utf-8?B?OW9UNmM0aVJXczBPeWV0cnF4Q0hTdXcrUXZleDJwbkJFcUZSOHZjVk1zOG1C?=
 =?utf-8?B?VG56VnZnYjltQW9nS0llWWJJSGV2cGVjZTlUOXJTSXoyQ0t1b0tBTWhrTlFa?=
 =?utf-8?B?aDdHRlpoc2VNVVRiUWZ2SzFMQWNuTHRuODh3UElqcVBXVHdkT29qSGZoam5a?=
 =?utf-8?B?d0s3QmcwN2lqVDJlcGpQMDJMbGlIaTBXdW1BTEpiOTFEUkhWeXkvOEFPZDUr?=
 =?utf-8?B?LzJpaUNiM0NsdWlmRFJHaFozMVVNbE1PRDhSYUsrRHVhbjlVSFY5OXA1SGZ0?=
 =?utf-8?B?RUUwK09yb25mM0ZLWEFqVGRybjNja2JHa2l0QkQvcG1welpCOTQzTFJrbkhX?=
 =?utf-8?B?VW84bEgzdzl4WDgrcVQxbzdNSWFvdGVDeWVmNDlCY01PWXp2dEt1a25YVURG?=
 =?utf-8?B?Q1VmclN1ZnRZRVRmb0dCR3hOZTIvaU1BL3M2WFZnR3JHdzAyOEpNenRoRmdn?=
 =?utf-8?B?amhxMFVIYjF5RG9ENUdVTlE0K2h4Z2ExZU9wRFRvd2lDeDNXTGR4bVE3S1VK?=
 =?utf-8?B?TGJWTEZaZGhtMzJXM08vcno4N1dpaFFIbVFIb3l1STZvZitLTFV3YTAwMXVH?=
 =?utf-8?B?V3FDeDZXSlBoWmgvc0NMMlVJUEVxQjhka0VQY0VzVTNCM0F1REJvbTRETmM2?=
 =?utf-8?B?Y0ZjSlVjZ0lIZ295aUw2NE9ZMkNRekx0NlExVXZtOTBiZ0xuZlZiVXFpK0Ro?=
 =?utf-8?B?WHZLcjg1MjIvb0I1U3BWbVNXRHBId1A2QmZZdDRBd3lJK3p2WldROWV3R0FH?=
 =?utf-8?B?UDJ3QVg0MEFkZHVaTkhySlVFMTdTcmVYR2FzNHZpV2hrdysvOWM4dlptRy9C?=
 =?utf-8?B?ZDl3VFA3aEI3MnFwM1hockxndkZrc040R0VBM0ZGajFxMyt5VUt1NVZyTmJO?=
 =?utf-8?B?T2RuL3lwc05FMUoyVlBkQmFNVGNLMDVUOWJybkdETDRTOHJMak5CWGkwaDZu?=
 =?utf-8?B?NFlOTnU1eDhwM0ZPUm5KdCsyZlZZTk1UZzlRVUd5eUI3bldGeFZjKzlDSG1x?=
 =?utf-8?B?L0JDUlAvT0xkUHUzNDRKdGRDOW80SVFtVXdXbkdxWC9yRm5zbHZhckliRDht?=
 =?utf-8?B?NXNpWjRWWStZZGdFampnWGdka3FrdWtMVjZLei8waE9HT0NDU0JBZVNCQ1Yw?=
 =?utf-8?B?L21jem1QYnJmR3lRSmg5NFZ5MHppTGFHWlpYVHdDbHlOb2w5L2NUR3lXWnc2?=
 =?utf-8?B?elJoUGljdmNXL1c5bU81QTVqUU9mbVRCT3FUT2s2emRDWEd5VTRjd0NpNi9p?=
 =?utf-8?B?S3hxTG83VGNFTE93dituQkhZQVJHMWJaT3kreTUvNW11aktKQ0tjdklKQStt?=
 =?utf-8?B?YlVKdVQrYnVIQTJRS0dPTm1BWEwrMVZJRnhYT08zaUJoazloVDdoM2lSTTBY?=
 =?utf-8?B?SDdyNGlsRWJOYjdIYXl3cmtxWmhMbS9lTVRWaU9XNlB6SjFRVUptaDIxRDlI?=
 =?utf-8?B?bzJRNFhqTlY5TnkxS25BM2VzMUFYOC9PMXlaSlZwejF0NUxlZHh2MUQrVXhs?=
 =?utf-8?B?ZEY4MlFYclVsNm1kMWl3QlpRaTY4U1NPeXc2eDdRRHRjQzBlWi9vdUpxVGUy?=
 =?utf-8?B?dFN1a2hzelVTM0ZsdE9JaGtBK1pncDRvanNJdUpjWjBGeFo2RHNLYzkvdFE1?=
 =?utf-8?B?dFFTTEt3U0J6ME0vNmp0SndGSEVDQWlDaHZONXppWkZGajJvOFFLaHo0bSt0?=
 =?utf-8?B?TEtlRStoZU1MbUxwdHJTR3F3RnlqR0cyL1RlUEdsWFNiajg1Qm9PNHVXMzYw?=
 =?utf-8?B?RUR3RHVlOTVocTBmcElHdkExTGxISGUwa0ZPQWM2Tzd4a0pVRExzalkxWXVy?=
 =?utf-8?B?cHI2ZmdyREJ2MTFIVFYwNDJublhWa0NwaU41cHZBYVhsb1M1ZGZLcU9JRk10?=
 =?utf-8?B?aFJaQ2ZoTTdIejcwRFZpdGQrTFhpSkZmbjJUNUZIenZRZ01NU0VOeFVLb1pq?=
 =?utf-8?B?S3BqY2pZUnpVTmdxaHEyQVM5bTljV0JRSEdlV2d3S0k5bWI4eCtpd0c1OWZ6?=
 =?utf-8?B?MXY2MFNBYi96eGpoM0h5TnpUN29LU1FRNlo0QXU3YzI5M3NEV0ZmczBXVDJM?=
 =?utf-8?B?Zkd5N3FUREVFZnA0U3ZwUlZsak1JektQNXh0MjBtRG1RajVUT0N2anluS1RB?=
 =?utf-8?B?cWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E25B86641EE4DF4783340D7D7803E0FB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53eb828d-d1c6-47e5-3862-08dcd2872021
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 17:28:18.0920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Im6+7cGt5Xg/DLJtTlLsVRD8HglzABWWpKiMezBPTgobUy1uAzUB2TXB7KT20Q1Jz/1dp28fO4Zaf2h7cHbc7vX3hvQn6/WxQiiHdPLTLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7010
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA5LTExIGF0IDE0OjI1ICswODAwLCBYdSBZaWx1biB3cm90ZToNCj4gPiAr
c3RhdGljIHZvaWQgdnRfZmx1c2hfdGxiX2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4g
K3sNCj4gPiArwqDCoMKgwqDCoMKgwqAvKg0KPiA+ICvCoMKgwqDCoMKgwqDCoCAqIFREWCBjYWxs
cyB0ZHhfdHJhY2soKSBpbiB0ZHhfc2VwdF9yZW1vdmVfcHJpdmF0ZV9zcHRlKCkgdG8gZW5zdXJl
DQo+ID4gK8KgwqDCoMKgwqDCoMKgICogcHJpdmF0ZSBFUFQgd2lsbCBiZSBmbHVzaGVkIG9uIHRo
ZSBuZXh0IFREIGVudGVyLg0KPiA+ICvCoMKgwqDCoMKgwqDCoCAqIE5vIG5lZWQgdG8gY2FsbCB0
ZHhfdHJhY2soKSBoZXJlIGFnYWluIGV2ZW4gd2hlbiB0aGlzIGNhbGxiYWNrIGlzDQo+ID4gYXMN
Cj4gPiArwqDCoMKgwqDCoMKgwqAgKiBhIHJlc3VsdCBvZiB6YXBwaW5nIHByaXZhdGUgRVBULg0K
PiA+ICvCoMKgwqDCoMKgwqDCoCAqIEp1c3QgaW52b2tlIGludmVwdCgpIGRpcmVjdGx5IGhlcmUg
dG8gd29yayBmb3IgYm90aCBzaGFyZWQgRVBUDQo+ID4gYW5kDQo+ID4gK8KgwqDCoMKgwqDCoMKg
ICogcHJpdmF0ZSBFUFQuDQo+IA0KPiBJSVVDLCBwcml2YXRlIEVQVCBpcyBhbHJlYWR5IGZsdXNo
ZWQgaW4gLnJlbW92ZV9wcml2YXRlX3NwdGUoKSwgc28gaW4NCj4gdGhlb3J5IHdlIGRvbid0IGhh
dmUgdG8gaW52ZXB0KCkgZm9yIHByaXZhdGUgRVBUPw0KDQpJIHRoaW5rIHlvdSBhcmUgdGFsa2lu
ZyBhYm91dCB0aGUgY29tbWVudCwgYW5kIG5vdCBhbiBvcHRpbWl6YXRpb24uIFNvIGNoYW5naW5n
Og0KIkp1c3QgaW52b2tlIGludmVwdCgpIGRpcmVjdGx5IGhlcmUgdG8gd29yayBmb3IgYm90aCBz
aGFyZWQgRVBUIGFuZCBwcml2YXRlIEVQVCINCnRvIGp1c3QgIkp1c3QgaW52b2tlIGludmVwdCgp
IGRpcmVjdGx5IGhlcmUgdG8gd29yayBmb3Igc2hhcmVkIEVQVCIuDQoNClNlZW1zIGdvb2QgdG8g
bWUuDQo=

