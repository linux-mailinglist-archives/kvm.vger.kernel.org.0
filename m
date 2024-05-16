Return-Path: <kvm+bounces-17504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CDE58C7010
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 03:41:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B502C282FEF
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 801B715A4;
	Thu, 16 May 2024 01:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y8ejZS3U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097B410E3;
	Thu, 16 May 2024 01:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715823655; cv=fail; b=vEchNKMQMcGcaf3cSX78Z8mwUvqXJq3zhM0XIv8jj2Rgsc2rufuioKIBMWy1A5O22rBRl5d8yA/+GPkMI6+3eKCYhLQinbWFU3daNxE0ldv4iymPZkTyRi9uxfP9r5pPwC9RxCfyuapWUKHUMQxZ8xdn3DCM1lA3esKuWM1cdGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715823655; c=relaxed/simple;
	bh=hKVClrM/R9Fbb6hTbpRno7Z+QkrndhslVIGYNvRIUsQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WaSszoDzdaQFBm8marpct2ohEzGcclr2zilwHZ8RdlRgYSKCtepoGejoLadbS9GioHDZtaN1DO8d/ztm+kxyELcP6Grez4jB8nWX2VFA9yFoUYzDYJRpfDfaSfpoSqMJBCSZhHKE0Izh7pBhRsYHIQjHYtECp2v4X06qQewSxlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y8ejZS3U; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715823654; x=1747359654;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hKVClrM/R9Fbb6hTbpRno7Z+QkrndhslVIGYNvRIUsQ=;
  b=Y8ejZS3UgztiCWpZjgVVzlaC5g1nJ7aVtfKqOPh1qxBi1lPYnI8/r8ws
   KmsPnbgfBQwFZT5esAdjgp1nMLf/qGif320wllf+KNSK9j7Dv3gC1z6dg
   xEKNrxtq9JG14uEq1N83i4TE5/vQ7zEtdxO9iKf7zFNbI3ID5oF8N+w9Z
   9H/pqnur6nbIly7OYjoTaLTu06XDCm/FhB97FEKdwzW9AOViV6qU8Mh5X
   FyLeDHgYcjRlxOxVWVIhCPC4kxaBNzdqVO8gdsRt4TAXMYpBAnusegXRX
   O9ja5/vZOjdG4C9edjnlkaOncAOQbeSrcYSL/Q1qmHnrLQVy4xS1Ir3ii
   w==;
X-CSE-ConnectionGUID: kr5Q4IVnQnK/gL/fXEar+A==
X-CSE-MsgGUID: gQVJeF8OQEK9s9iIGv4Vgg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11718048"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="11718048"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 18:40:53 -0700
X-CSE-ConnectionGUID: 3CybGjnYQlyWXVhbNb8lMg==
X-CSE-MsgGUID: AQiKR9qhRtm7RX0BooMyEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="35781925"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 18:40:53 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 18:40:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 18:40:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 18:40:52 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 18:40:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVPmuRf9+35iGGXDepe0DSs57PlNYEwmfk8XIrywYD3JQ/MNqiN6sv85Gji0iiDVski3pNcMZc+4yZWlJ4ALzuHv7wPOpx1XR4BjjHkg1l55TrHTb5o4TI5VevJW7VkfwETMb/Enk1OJfj+0KRLRF2Q5a0EMlfR2j3wjNDs+/yLru6C85kfnRk/vvQiEZ2ew2lNxl+9QfGJ8hDS3+iTBZBvqkMhI3309LVm0T6alVicJbr/L75mPzuuGOIH4t9ifdTor8kcXsZHM0K3d46IXs8Hv+IVnTEJH/ECuCaSFAPdQI8OiBH1zf9tJ4DvN3XUAZNiHg8hRIiTPEWwYDkNPCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vMS6b/eB2krevsNdCFFmczPNPPwuB2AakyGNeo7R8I0=;
 b=D1vguZac1jXY80u7p0zKpU7PW/okjQlrcJxnP0yOv2PeO2dub4HDBb2m4Vp8UkIEGp9unwcn1fLIvtgXL0r+MUAFIYR8PvKxQ2A+JAPryBzzxFYTYY9g1luQz8xLHmj+1vgRL3AxkMfH/NnHg8V8QPC+1xuMN4jHXbsgwlEcHY9ZdbXdZ/28w17lwb689RsBJEK2xxmp0iDyoARKVxfTxnMutjbHo/5nXVZjuNLNOirlIbd9sAGrQqN/+frbT8Wdx3kIHvGHGEIUu1W9S+vcxgK+r6Ggn36AeiUSBRrbFR0qydg4UxLtQDpWMJeFcev/ERE22iZo1fMcPE/IASaMJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7787.namprd11.prod.outlook.com (2603:10b6:8:de::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 01:40:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Thu, 16 May 2024
 01:40:50 +0000
Message-ID: <d8ff5e19-85a7-46bf-9dad-7221b54d8502@intel.com>
Date: Thu, 16 May 2024 13:40:41 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sagis@google.com"
	<sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "dmatlack@google.com"
	<dmatlack@google.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
 <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
 <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
 <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
 <0a168cbcd8e500452f3b6603cc53d088b5073535.camel@intel.com>
 <6df62046-aa3b-42bd-b5d6-e44349332c73@intel.com>
 <1270d9237ba8891098fb52f7abe61b0f5d02c8ad.camel@intel.com>
 <d5c37fcc-e457-43b0-8905-c6e230cf7dda@intel.com>
 <0a1afee57c955775bef99d6cf34fd70a18edb869.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <0a1afee57c955775bef99d6cf34fd70a18edb869.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0343.namprd04.prod.outlook.com
 (2603:10b6:303:8a::18) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS0PR11MB7787:EE_
X-MS-Office365-Filtering-Correlation-Id: c3fa703c-c60d-4909-c5c0-08dc75493777
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y2N2bEwvQ0pBQlhpazhVaVkvTGt0SWFBRUp2Z3hUMVFac21WeDhJdkVxQlpv?=
 =?utf-8?B?YmxkeG42YXJxOU01Wk5QWDU4ZUtFMldwMkZQUUVwd0xDVy9QYlVWcFNsNGVy?=
 =?utf-8?B?cC9BM1NXQW13K1pheHRzNWc1eWJuTHlOV3k1V1VvUGRtV0NKTHAvY2ZQUHBZ?=
 =?utf-8?B?eTJocWpiVDRXYVoxOVIwQzQ5WUE2U0p6Z0VHTWZzWUtWWWl5d01aMFhyNWRh?=
 =?utf-8?B?U3NDMXQ5aW9kUG45YjNOWURURGtGTTlJTks5Y0JmbnlSK2VpWUd6ZGJ0Nlgr?=
 =?utf-8?B?VzhwWWc3eTdIMmNNbzA1UzBTV1MvS253ZHgwS093RURHdDhGNDVxWFpLVzJv?=
 =?utf-8?B?L3FyUFpWZmNicmE5dkVKd1dIdnB6VG9KRHovMTV6dkFCeklVallyMjQydHJK?=
 =?utf-8?B?V1M2VXhTT1ozcThnU21SaG53VU5aUWpvLzRGNVJNUExDeUJvNi83Q3h3RHps?=
 =?utf-8?B?NGw2K3FYai9RMU1ET1paZDBKNkNPQTlEV2xDcUgrWGUvaEdNMU1zaVQ5ZVE5?=
 =?utf-8?B?S3JHQ2tQK2x0QytZTnU0alZMditSQ05wbHpuaFZUWHdsZlQvQkRxczZBeFhu?=
 =?utf-8?B?TEY4cTRtTCtEQnV2bmZVRHNCVmozTTM4d2FXVGt1emRUZEdNcTBCdUdCemxR?=
 =?utf-8?B?NENadXFxUmlqREQ2QnAzR0dldFpJbkFOZ2MvTHU4SzNQTlhWZjExaUhnbUJF?=
 =?utf-8?B?bzRUMjdaSjZlRkpoZ3lpUU9mcmlzaEpXTVFDdy9nZWxONkxCQ1BYZ1RnUFJV?=
 =?utf-8?B?RStrT095bEtxb2VTTjlBazF2end5dXlvbGlKS3FDUVp3ditYZXFYdFg3OU9y?=
 =?utf-8?B?MWlQSlJIdW5rSW1OM01JeUUxWWQ1UXVLdkxYdVM5N2wwdTFrT2Q5b0Z0bm10?=
 =?utf-8?B?c0FkMzF2ekMvNUFJSWFHeDAwaW9mV3VvZEpFTEVxMTFPMDlzWE5GbVdxVW5z?=
 =?utf-8?B?QzkxZ0l6Y3VRZ3VUcmg5YW8vdzQ1MkRpTUNoMEtGRUdqYU10cW93RTJ0ZFpY?=
 =?utf-8?B?VklKbW9sYlphR1ZaR0JGT2NlaWhJc1FESDQ0TWR4T2N3anFlbVY5OEd0RFR5?=
 =?utf-8?B?UXZtVVU1YURSSGlScDY5Z295aFRnN3pKejNsUVUrTEhVeVdlWUJVMFQ1cEU3?=
 =?utf-8?B?UlQvbU5wTTFzaFJjNDA1RXFTTHBwWjkrOERFUzI3d0t1UkhwbGdsWnNjV2lY?=
 =?utf-8?B?YWhGUUFnSFdCMDZTVWUreU9kb25UNWZDK1grOWJuWjRuMkQ0QlJYOVdpQkJp?=
 =?utf-8?B?MVdhbm8razJvSEdtSlFhdGJQMTRrUFhXdmVvbnp3WFF0V1Y3a3UwYnpUNHN3?=
 =?utf-8?B?bkVPSEM2WlNYYlp3UWQrZVkzdGR4dWlQZ1B0ZnkzMFU2aGZ2djNRZ21pRkQr?=
 =?utf-8?B?eUZ0TE8yamkvZVkrTXJhdWpJeFhFSGdDUWZBaksyV0hLRmJUYWxDdnFzT1BZ?=
 =?utf-8?B?aG5LRmovNWcwY3lhZXpxam5zYWl2UzhvbGZveWEwcms5enE1eEp0eTB4eTNt?=
 =?utf-8?B?U0dMekNFOGNTaU5XOXVmSXd4OVRHcjJTMFo5NWZtVHFhdmFIUytaQTZLSUlj?=
 =?utf-8?B?NVFTSXovS0dYbURSMWFKZTVKendrNDB6c3k0cUdlcHZWQURLNGhFd0NGK2N6?=
 =?utf-8?B?dVlhTWZ3V3lndWNrelBrREk5QjVQTGE3NWlkSWFGa1hKclRLZmphQXRod01h?=
 =?utf-8?B?UUJPTkMwVFA2cHB3enBtY1V1MWtxT2R6SWd6eHUycVQ3b0pOdmtYcXBBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VW05Q1YrMHBZb2FUaTZVN1dCNzI3S1lGWE5EVnpCdlp3TGNaNThLekd1OEFV?=
 =?utf-8?B?OVRqcnIrdGhPS2ZSWm8zbXo2TXNTRXFmMjR0aHRYZjFCODY0Q2J1V1NyL1p3?=
 =?utf-8?B?RENNbWxMdGdYVVFPTU4xSExXNVpmVVN5Z096VXBEK053TTJhdFloMi9vYWF2?=
 =?utf-8?B?VXhVZnVmNkJoLzlwb2hMZHkrMjExNWZzYVczNVVra1VCUXpSOUFaUWNoek5v?=
 =?utf-8?B?YUQ2aXhPNVlBMUZBdVQ3Nzh4RHgyTk5VRHBORDRrUW5CL0t4M3FXamIyQm1x?=
 =?utf-8?B?WEhNdXdQb3Jzck5Tc2U3Vm1hUXlTbHdwVFE2SmFGclFGcjIvTllYUTI4T2U3?=
 =?utf-8?B?blZOa1F1Nm9jSjY0L0RRT1VGTmMwTWdCRHZNaXpsL3I2aEtaaHRyOW1xUGY5?=
 =?utf-8?B?WFl0U1VQeUpUNkJUeUo1NDUwVnBsSFVrakR6UW5yTllLNlBqZVg1UXVibzNU?=
 =?utf-8?B?OXZuVHQ0NFg2V1E2L0syQTc2b2g2WWFLaXYzT3ltM25aTjhoTDVMNmZ5eVgx?=
 =?utf-8?B?ejlFaG54S3JEQWU3cHpwdFFWcjloZ2w0VEJuYkMvVlprUmprS3dVTkpvYjF5?=
 =?utf-8?B?aXUxaXNqYjNVS3dydVJLRU1sanBTSTBDdTZ0eU5YcjZmblFLNzJQSEp2QzBS?=
 =?utf-8?B?elBNaTUzSDM2Y2hOK0ZtbkZmaWFyQlZPZEZPQzZTTm41cDY4KzlDMm5lU1ZV?=
 =?utf-8?B?QU04Ny9GbUh0MjRCN3E5ZnVoYU5LN2p4N2JsOXFCRUJrYmFPUnp6Z0xpTFZR?=
 =?utf-8?B?VDF1ZUFnNENFVW96MzhXZXNYclZ4cjlGY3BqUUtLTm5nWjE5OXhrTzMrUVlI?=
 =?utf-8?B?YmhCZitTSVhiRUFPdWtJWmdxdlo4Wi9tSENzcHNIWVpxb0s4SjdvYlZybzdK?=
 =?utf-8?B?L2JTR3YvZy9MaUc4YXlZTzFYb0RhcnNnSnBrUEZVM2FkV3ZoUHdZZitiY29h?=
 =?utf-8?B?VU5vNjZkRlliWGxPRlV5V21POHRWMitTdlhoSythT0hnR1Awc3V0Q045K0J3?=
 =?utf-8?B?OG12SEk4ME9rekZOcjFlVWdhQlE0dUIwRWNXU2dCcExURUVUTnpTeWtjeDky?=
 =?utf-8?B?SHR4YVRWc1dKUXBjTkVxRW5wcWlCVGx5RXI3QiswTWtkSUtHdkVFUkdJRU9N?=
 =?utf-8?B?cTladU5wOFBoL0tYSHJ0aVJqdzA0d04wZEVDRG5YVERFWml5T04yaGR3V2VC?=
 =?utf-8?B?Vk9GWms4aTEwdHJKK2h0VGNjVUdkTWZaUG9SZmY4dzFCbVZmYXVzNDBSVjRM?=
 =?utf-8?B?bWk2YXhib3NpR2w1RXlWNnFBclE2V3ZwUDkwam5xelBiRHRRV0k1WTZNOFlu?=
 =?utf-8?B?WEd0ckFDd0F0bEkvdHh5VDhBN0xYVGZVcXFVWjJJcUs1TkQ1YkZETE1PYnFR?=
 =?utf-8?B?NE5JZzAyVHBqbk9TNHJXUUFQZTNIQklTS3Z0dWIvcmxBZGdsSmhnUmUrOTRG?=
 =?utf-8?B?OHE2bWpUOGswRlFkNkh1RHY1ZU1MSndDUEVsSGhLT09PK1dMMGZyZUM5YWxo?=
 =?utf-8?B?RzQ5aHZkdEtZV3BHS1BrdFhBZEwvc1MrZWVDUS9la3pSNjBHaHlCa2ZRdmZ4?=
 =?utf-8?B?Wko1ZmZ1TXBCdUdCV2QrZnJFRmphRS9BSUlrVDdiSHBrWktTbGpMbFlrNnl4?=
 =?utf-8?B?V2JIcC9lQmpseTdRNXVtNElMZWg2cWo0S3pmam9UQjdhYU5nR0orU016WU5o?=
 =?utf-8?B?bkIvUThMOXlsSStxTTFBNjZVRDZ2RzlZL0hUMFVjYTM3cUxuT0l3TERQbE5l?=
 =?utf-8?B?bitDamVRckJ2MGJLbzRTRUpzSjRqd3A4SitSMnZYY1g5eWhpbmtWSXQrTXFY?=
 =?utf-8?B?VmxIc25PSW02NlkvYWo2eStEaU5yVG1SL1M2bzFSNm1RWUxVa0xkNTlpYU91?=
 =?utf-8?B?blBtZm95aHppbHJwc05FT3FIdmVxeXlNREY0Z3JGVnVSRWx5c0sxaDJ1bFdR?=
 =?utf-8?B?MENoSXB5UUQ0cUE5K1NxdWRXd1BkZ3hOdnVibG5rN0pDb3o5a2wvR01uUVBG?=
 =?utf-8?B?UzRnNVVrcUdLK1VUWkRvUXJKbzRYL0xQd0tYSFI1WkNpWHliMFN6U1Q2UUVq?=
 =?utf-8?B?andybFlzNEdXd3pHZGxZNEt2QWdIV3dqRzZDS3FYY25mY1VTY3dxeCthL25n?=
 =?utf-8?Q?DM1cIzPbBZZdqIl49TwDZUdrC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c3fa703c-c60d-4909-c5c0-08dc75493777
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 01:40:50.4910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3MVtY8pAjZD5i1uPb5POaomM0KeUntjBcmq9M9eXL/yY0Hq14IE4NaeGm/7AquEamq8unKfU5eF/sS8OIx7ERQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7787
X-OriginatorOrg: intel.com



On 16/05/2024 1:20 pm, Edgecombe, Rick P wrote:
> On Thu, 2024-05-16 at 13:04 +1200, Huang, Kai wrote:
>>
>> I really don't see difference between ...
>>
>>          is_private_mem(gpa)
>>
>> ... and
>>
>>          is_private_gpa(gpa)
>>
>> If it confuses me, it can confuses other people.
> 
> Again, point taken. I'll try to think of a better name. Please share if you do.
> 
>>
>> The point is there's really no need to distinguish the two.  The GPA is
>> only meaningful when it refers to the memory that it points to.
>>
>> So far I am not convinced we need this helper, because such info we can
>> already get from:
>>
>>     1) fault->is_private;
>>     2) Xarray which records memtype for given GFN.
>>
>> So we should just get rid of it.
> 
> Kai, can you got look through the dev branch a bit more before making the same
> point on every patch?
> 
> kvm_is_private_gpa() is used to set PFERR_PRIVATE_ACCESS, which in turn sets
> fault->is_private. So you are saying we can use these other things that are
> dependent on it. Look at the other callers too.

Well, I think I didn't make myself clear.

I don't object to have this helper.  If it helps, then we can have it.

My objection is the current implementation of it, because it is 
*conceptually* wrong for SEV-SNP.

Btw, I just look at the dev branch.

For the common code, it is used in kvm_tdp_mmu_map() and 
kvm_tdp_mmu_fast_pf_get_last_sptep() to get whether a GPA is private.

As said above, I don't see why we need a helper with the "current 
implementation" (which consults kvm_shared_gfn_mask()) for them.  We can 
just use fault->gfn + fault->is_private for such purpose.

It is also used in the TDX code like TDX variant handle_ept_violation() 
and tdx_vcpu_init_mem_region().  For them to be honest I don't quite 
care whether a helper is used.  We can have a helper if we have multiple 
callers, but this helper should be in TDX code, but not common MMU code.


