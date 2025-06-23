Return-Path: <kvm+bounces-50425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD66AE5788
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 00:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D8CD7B33FB
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 22:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66139228CA3;
	Mon, 23 Jun 2025 22:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nBYgHsrU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89B7226D1B;
	Mon, 23 Jun 2025 22:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750718595; cv=fail; b=ItjuobxrHlAJXzc0mMqBy9mq9hyP2aX6aQFzLg+i8gyjReR4SewYxHN4MtCCy9hezSPgLWMNNk8qvQL9viSvDE3A2LCAmPJ1PzYbSsoUXZ/QbNeVwb+eibeTaW0dwrzoOlVV5rQEvi1zrSBy/U6pz3/+v71q35k9K3iwod8Qfck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750718595; c=relaxed/simple;
	bh=p/fj0TEM4IFYjGKjPo1G0Jl0F1YHDS8OjDewEpzGxbc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V/yOSYCauwfa5ETOzxlu14FcZo/ON7+m1cWVXp0RjjeFSDNs/qEGGlrgckNPhYgLqnRy/vMM3+uft9gzBqFw1j2wPu9jzaU50EE2WjSsOees8Zfb6HUIz1u4Koq4asNR09n9H4jatIaCwuhmJT7wYgA/ayTBpcpYwIC/UwDwOO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nBYgHsrU; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750718594; x=1782254594;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=p/fj0TEM4IFYjGKjPo1G0Jl0F1YHDS8OjDewEpzGxbc=;
  b=nBYgHsrUzAUoS0AAFIlRZfFRLFAQXjcYNU4jpa6znKHCzdxdJvDWqTcM
   fFDtvpTcVuIWghxV3TOz5Y4Y2c79CfOd9qSavCkfwP+8hSvMwhGCvz1Wf
   5/mj9D6FzxOqm686kPVhIF40znhZnLW6fadzzFjqfTXf2rgxJ8Y3FkOi2
   yBK6zHz5BGOkKYyI/VR3Q0xqQmyff2wpBF+7hJiq8WgxTYN2xVE/r+WMm
   G95nNt1C/9SsORhXj+VTR1LgTBND/eRsIrE9fxLQUKUk0DZFinAq4aszB
   9wpd6VKzqLKe7Igg9PggJEqKKtBYFfotNl5givxFK32kyoU8JlprkLJw4
   g==;
X-CSE-ConnectionGUID: HvsYH5P7TcuWZgTXay9aMg==
X-CSE-MsgGUID: fIct1uhVTUON6eH3Hh9sNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11473"; a="53033717"
X-IronPort-AV: E=Sophos;i="6.16,260,1744095600"; 
   d="scan'208";a="53033717"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 15:42:56 -0700
X-CSE-ConnectionGUID: XoD79qTkSNyIGYbxF0tQfw==
X-CSE-MsgGUID: 5MPZvAy2QNmgwp5ISTLRPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,260,1744095600"; 
   d="scan'208";a="156096150"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 15:42:57 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Jun 2025 15:42:56 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 23 Jun 2025 15:42:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.62) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Jun 2025 15:42:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hl2ZEmdd7zOL7rpdjmxNwKj0rc/A8jZOuO09m3KGNWEWji0HBXI/32++GHINOBhcedBRQP+C8k4YNe5Y8e5L6WAwA5foU0pYAaa5xc8A4Mr9MQviAg3NGuub4XCUUYlBcaVI69eilU9nq73UfXcJB8rSeu1OpV6FfsBhQr8mW3aLzKUrQwyVf1kVheYsEtBHJkm8u2VMqLm7yL/8QXuYiEx1rwPJibzSGOo2ySs0qc+G9bkk4VXVcoeoIXPLc07Ux/CfcZbcJxoUDghKM1xSn3Hf+ed3gsQunYuTF3/EkhbHNo65+P3GN62I8O7sZ46Qg8CDoe44cw3kjB1f5QnfSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/fj0TEM4IFYjGKjPo1G0Jl0F1YHDS8OjDewEpzGxbc=;
 b=hmBPsEhtC7n3zEIKwtGrYDvpx9yRYlZN8M1ZCzodlbj/qVD8Pr1eSgcIdd2jBfl3R0eGSYSRCQnSk4HQ7Km/bTIj6A9oFZ+jdNu2LtCOotjTrUJSQJPSDDVcSkpeAAomGRZkZInvRSqRUoFhm0COI0V0GGI+O7mZdheqQw0dfkCmDmVNGUC2Pke2E6AS/pPW8GxmD/+L9gPOl65jWoVBSU54lzF9kAS+p7+vp3FYPxIT1XNcaPg9iG9HiGBwnH47j/RlD+pbhRWEVyk6IeS68BVM/FOqe2F1ymWCzZDyk/UMSJxgY6I0LEZWXOWXT0SdKqTVJF6gQcV1bo+uxOfBCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB7118.namprd11.prod.outlook.com (2603:10b6:510:216::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Mon, 23 Jun
 2025 22:42:53 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Mon, 23 Jun 2025
 22:42:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/3] KVM: TDX: Add new TDVMCALL status code for
 unsupported subfuncs
Thread-Topic: [PATCH 1/3] KVM: TDX: Add new TDVMCALL status code for
 unsupported subfuncs
Thread-Index: AQHb4URQu8GYvm2eEkCIkEZX0z4RzLQRXb+A
Date: Mon, 23 Jun 2025 22:42:52 +0000
Message-ID: <88712018236af1a5e9a1ecff2db0a5dec06e363c.camel@intel.com>
References: <20250619180159.187358-1-pbonzini@redhat.com>
	 <20250619180159.187358-2-pbonzini@redhat.com>
In-Reply-To: <20250619180159.187358-2-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB7118:EE_
x-ms-office365-filtering-correlation-id: bac09005-0afa-4e3d-7059-08ddb2a74a26
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Ui9EdFBLUlpyWjNlWGZibEM4WS9kL3VkMzBtZUdTZlpVa3drYlBkZXBDczcw?=
 =?utf-8?B?M0luUUJtRFdqL2krNXRoN2tvYVpDOTZyeUxkQy9NbVpnNnhlV1I5ckZsdEcv?=
 =?utf-8?B?WjZPTTFPTXlVdWN4SFc2b1A2UTNReWluNnY4d0ptaW1LUjZ0Myt2MWpsekJl?=
 =?utf-8?B?Y1NxaWZ2VjNaOSsrTFV3MU1XTmg4bW44M0liRHA4OXRCYkRqbFhsR09xU3JK?=
 =?utf-8?B?L2Exa0FJNmI5cWxuMWVpQXEyd3FHaFhHNS9ZSG5Zd0FuQ1VNMklXVVkxWGlr?=
 =?utf-8?B?WVRoY1lsbVFYYUE1aTdPMFd1VnNHaFVQSGtGdnlHNE94dStneDRBMW14alBv?=
 =?utf-8?B?cHhtVEJjMTYyenlrdXFCNWJNK1Y1cWVDMVJjODdnM0MzRSsybVhDbVZLcG5P?=
 =?utf-8?B?d1NzS1MrMkZzdXdwcGwwWWNHejZTbVdyMS9lWUN0VS9OVXpqUURSRWRMcSt0?=
 =?utf-8?B?RE5ReTRTVzE4S2JXZGM0WHRqSVA2OWhjQVhMUnFrUnhsVUFWd3lDNDhwbktr?=
 =?utf-8?B?N0JkV1FDbHBwbEg0ZGIwZm43S0l6UTZKZnM4cE1kdE1WZkJVYzk2Vlk3WitY?=
 =?utf-8?B?Y09wZ0ZDVEk5blI1S3NWbmJxY3pHNVNlNG9ZOGREM2xPc3hpa0VIeVdCc3Rs?=
 =?utf-8?B?cTl4WjFFMHlEY0NROWNTbG9vYkZuQ3ZsakJraEoyZXBESHhBaTJxR3hSbzFo?=
 =?utf-8?B?TTAycnlvTWI1R2VCSkp3bUhLTi8yQndPakFIbG5HM1RzUXhNVmFFcEV0Y3N0?=
 =?utf-8?B?ZVRySXp3Sk81WmMvclEwSVM3SmRZdkNmMHl6dWxWM2U1VUtzbUVwTVFmWXhz?=
 =?utf-8?B?WHk4MWFLdVBWU1M4MXdOY3E5ZWFtNnhOc2NtY3JSZ01DUlorVDNzYzYvZUtx?=
 =?utf-8?B?RkdKY0orSXNreWFha25Fak9KaTl5dzRtZ2JodmJuL2ZFT1V3MXg3djB5bzIr?=
 =?utf-8?B?MkJyUi9FWGlNT3FobDlzNnVYcThHa2JUa2gvMzJhNjVPWGwxRXVwSmlMR0ZT?=
 =?utf-8?B?R0U3TnlSTEUzQUpjWlcxZi9UdGdJOWh3NDRXbTFxckxhenhoYWlWRGgrN3hR?=
 =?utf-8?B?bU5oaVh4alBoQjA3WmhsNGhPYmlqdU9lNDJ0RG5UMkhzV2U5aTVDdXZueHkr?=
 =?utf-8?B?Uzdka01MR2xERytLQ3E2bEIrWVQ1cmpGUjM1bE0xSG9qL0hDcDFwSHZCVEto?=
 =?utf-8?B?MTc0NUx3Zlc0b0ROVTgxQ041NEE3eFJkaXN3N1FhVWZYV3pJdTZsRCttZ0xB?=
 =?utf-8?B?WWg2RzAzM0txS3NwdUdRL01TOGRMSHVYVUZ1V2VOSnM0V0ZxNkNGNG9xUHY2?=
 =?utf-8?B?L01pUUpUMzV2SWdLc1pZRFd2T2RuUFVMYk5jWnRVTmFvTEZ3ejZYYmg1dmEx?=
 =?utf-8?B?T1dXdDd1WnRETFNaZHFkT1ROWVFtWWNJbVpxWXBZTjRsUjdKTWx1akxUY3JJ?=
 =?utf-8?B?UEZhZ2dPOVc5Zm9MSG95M0hIWEt3U1RqeUVuWU1MRnl1aWRsOXJJbFVwejhY?=
 =?utf-8?B?c3pHZ3dJQWF4RGRoR292NVJWSHZEbjNza1ZBZElEaXEwZnMyVTIyQ0xEUTBr?=
 =?utf-8?B?S0l1T1RUVzZ1WUlVc3FmVG1JTmw3UDlKMDF3dUJNd1hpdEFIZE56dElCMjFR?=
 =?utf-8?B?K1JVazFhakJuTDhJMmZFb0wwMXFteTRraGZscmpPTTdGM2FJVFpSVnRjTEo5?=
 =?utf-8?B?bVNzUDdRUFpCQWYzaklsZzZLcWFrRFc2Q0F1N1ltcTlUMzNUYjJVeVlTc0No?=
 =?utf-8?B?cUZXSlRGSWRET3dtSUM4NFpQZTI3LzlBbERtV2ZSTzBOM0haUW5aalVEaGY0?=
 =?utf-8?B?TlRvMzBDdGhNUWtJWnkvMHdlUXVMRk80YmpxZTkwYnJUK0RVR1hyRGFRWmpZ?=
 =?utf-8?B?d3lGaldhQTBuek9CWVhDbzZadU1ncGR5bFhNbDQ0azRsMm5zZHNUNmxmdkM0?=
 =?utf-8?B?WmxyZ1F0c0FSM1l6enlFWmVyVENDR3AwTjJYUU5sek1pWmFvdFI5bXNnNUR2?=
 =?utf-8?Q?QySu4b1bBCvnpDeavyhKu2HXiDyUmk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2RrNW83ZU1GTW5vd2Q3b0t0dUF0WXRaM0tOcVZHOTRiSVRGYmNkMlk3cDRH?=
 =?utf-8?B?M2IvTHRLVkszbWRYQ2VTOE9LZS9xckdLUmUwOVZZcEl2dndQMWNteFp6QzlE?=
 =?utf-8?B?TEpqTW8vZSt6S2xhYjVVRzVBZlFiZm0xRTFYYUVHS2RKb29FRXdrSHRSVUp1?=
 =?utf-8?B?TzRUZzRKaG5SUWR3NDBnTzczRzM1d0E1NXpBMVM2bTRaazRydzRmaXVVNDNJ?=
 =?utf-8?B?OGxxN2prdnNhL0ZpdlkxWjZEOEx3ek5ubVF6VXNuWHcxRjdTSUFWa1lKMkF6?=
 =?utf-8?B?Z2UwcnVER2loYnZEWW9QK3ZrK1BnTUN0WlA0K0RWYUFua3NtYk8zaDFUbjB0?=
 =?utf-8?B?ZmxaSndTd0FLV1ZOU29EWk1vTzM3SUtiQXJWbkc5V21BcytPRWJkUGErbEpZ?=
 =?utf-8?B?QkRqdDNJRmRCc2pmaGgzRXJ5d2dyVnFYKzNDZnozSGJsTXpnMGtVZDRtYXFy?=
 =?utf-8?B?T1JsZThKSXhkM2pPL3pXV2sxd1dFTVZrUTBZNHo2ekhpaWtVRjZUQUVuUmJQ?=
 =?utf-8?B?K2YrNXNxYXpISVF1UE0wLzR5NnYxTlhxOFY4ZFBReS9LUUROdnBEMVptN0Qv?=
 =?utf-8?B?dmpSWlZ2QktZUS9WdXNqU2Q0NG1ZcFE2MlVMMDZKOFRHN0M2V01xbXNvcWUz?=
 =?utf-8?B?d2dLLy9YN3NtZFFqMG1rNEoyWkphZXgvbjllUkJCWTVHRFQwN0xNWS9URXpT?=
 =?utf-8?B?RzBpcFNRTkhRU3NqVEk1WmhRMUt0L2ZEQStZbTRaaXpVV2REKzFxd2d3R1ly?=
 =?utf-8?B?VjZQMzFWTWY5WVVuSnk1UUFrWEEyNEtxWmlBSnNXdlU3V2twQlFULy9CWnJv?=
 =?utf-8?B?UjhqK3ZWR3hPTzBxbEc4RTJsYlU3dGRyN2xIOTdGdEViVTREOHk4VDBhdGVh?=
 =?utf-8?B?cndDUEt5ZHBrS3lieE5ZY1NFclI1MXZmK1ArSURrd3Nsa1R6Y24yYzUwZnBI?=
 =?utf-8?B?NkVtVmV6RWhEcnd6REpuNmFWZ1V0SXY5VHlQWlpXRU5nbzhGTFRPV1BTSTJs?=
 =?utf-8?B?b3NSZjgxdWp3Mjc5Q3RQK1JQa3Q1dFoxM2cvZlNhV0VyRmdYSE1kT2I2RDFo?=
 =?utf-8?B?WUp5NkdPbER2TUNVN0tZdmlHKzN1eUg2Ulp4eEIwL0p3OHR2MkRuSjNGL2E5?=
 =?utf-8?B?QUhmYlpweG8yd0VpUGxxV2N4c0lSQmlGRm9vV2NxQzh4TGh4SFhyRWpSOVdJ?=
 =?utf-8?B?RmM0Rlk3SEdxUGZJTU5CaXptNDViU2p5WVZYbGF6WjZFb1IyZUtMTkJhSmZF?=
 =?utf-8?B?bDhicURsUW8rclc1WklBL2trRlBZM2pVd1RiR1RXNFNHSk83M09PMTczTHRK?=
 =?utf-8?B?RVFJejZ4b05WQjdCQUV0R2dUcUhyaktybWU1QStUV28wMDhEUXkzOUZzV0pn?=
 =?utf-8?B?RXJjZUJwRU9wdjk1SDAzRE5XellaQlN3UlhhTXFES2xUYVRzWVdFQUZOWEdX?=
 =?utf-8?B?UTZydDVNU2RFNk1KdWxOcEZmeThRbEFQOHhJc09JVXZ5bTZnc3U4R1Bwcm15?=
 =?utf-8?B?VVNzMkliWkFNeE5SNjdNdXZ1cVF3dUdIVVoyYzdHdjBteDZXd2M0U2RUSGpa?=
 =?utf-8?B?QU82V25rblFnemROZkFKcnR1Y3FuVnVubm15amp0cGpzZnFJNzNRVTltbXMx?=
 =?utf-8?B?eEtvNy95a2lFVUo2WGpWSThJTjVnb0tLMWhRNmJHRy8zRUladEdUSzFYeitO?=
 =?utf-8?B?SHBpejNsSWp5YitiejFoNjh4UklMdUh6NFY1WE5Ka1VJY0tSbkEzVFUzWVlF?=
 =?utf-8?B?cWhUVkN4b2VSalFIcVlORTMvQnE0czI1RE11dXE5NUZBc0VhQ25QZlRzN1kx?=
 =?utf-8?B?QzB3SWhaVmFvd29XNE45UkxnZW1kdWtRTjlEaVdrbnVRblM5Vi95MHBkQmc5?=
 =?utf-8?B?RWg1MkcxWHhBTk9Nc3JveTcvY0ZhZjE0cjNpV3lGK09JMUJ6OC90WVJZN0hz?=
 =?utf-8?B?Q1RoVTB5aFhGL2hZSVM1UjhjTExyZFo5ekp3c0lUSzUvRnUyOXU5NG1OM0I5?=
 =?utf-8?B?SzhVYkFNUXZHVG9yVHdLbGJabFFUd1NvVG0wOVUxSjU5TXh6K1JVOUJDeHYv?=
 =?utf-8?B?VWZ1TGxhZzl6L2N2SUcrQmFBUHdQSVhUb3R4a2NkTW9IVmlYZU5Wb1NjZDln?=
 =?utf-8?Q?8RZf0PLy76OoeqAGEWba2h0DC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <166D201DF46E3544978B68C639715F3B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bac09005-0afa-4e3d-7059-08ddb2a74a26
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2025 22:42:52.9193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tmg3KbI3mtlsKF41yQGNneShVVgWLxTPQV5yZb9m/ldZlQHK3Q+B25xAsi0cqsDZG1lIPxlcp55XmgwZ61WvcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7118
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTE5IGF0IDE0OjAxIC0wNDAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBXaXRoIHRoaXMgY2hhbmdlLCBURFZNQ0FMTF9TVEFUVVNfU1VCRlVOQ19VTlNVUFBPUlRFRCBj
b3VsZCBiZSBzZW50IHRvDQo+IG9sZCBURFggZ3Vlc3QgdGhhdCBkbyBub3Qga25vdyBhYm91dCBp
dCwNCg0KTml0Og0KDQouLi4gb2xkIFREWCBndWVzdHMgdGhhdCBkbyBub3QgLi4uDQo=

