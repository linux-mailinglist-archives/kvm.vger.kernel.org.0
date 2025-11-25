Return-Path: <kvm+bounces-64568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B737C87326
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 22:17:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66EFD3B2761
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430002F83AB;
	Tue, 25 Nov 2025 21:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eQ6lHgkY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A83C21ABA2;
	Tue, 25 Nov 2025 21:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764105446; cv=fail; b=g6K8vmSFSzARSmjecwVyYjaeZHBjBBd2sycgQ/riMWG/idUIFG0MqftJUVHXcsAaGGG+ELX7WQ7U3DBaWU/jihKNw95Jq+2Ao4XPApF05Udnemd1iSDM83DiV2HcrzKtpfKbSsMLGFqfbLv2+7woZhRFtu1HHeTykbUaN9wyVe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764105446; c=relaxed/simple;
	bh=ywnrQpqjJaT3f0w+3vlXVInO9wYW69wuY9X2AWbS/Uw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EL4rgAmWDzgET2bpZd0bNSeLZNl0sbFAcWJSgvPlOvxBXU9LmWG/Ov1htgOUStAGfoMfydNRsRPDqp6vxv4Xf9Hu1sICOpYcK6xrBP2Wwscv5hbA6SITul5jfMeW7uH73ccoHvKItt2IE/v8DL2D+IzoD0cuujmVfOdeLVz1fUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eQ6lHgkY; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764105445; x=1795641445;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ywnrQpqjJaT3f0w+3vlXVInO9wYW69wuY9X2AWbS/Uw=;
  b=eQ6lHgkYXRCmlZ8ASijAlQNoSTIv1RkKFGDwQo4F858HTIzBhOjRQL/u
   g6VUijFrCNA4O7oxsOiIgHggdVXD5vMcNoawzprV1OTavMGRcUWlUMFRg
   r8BXKe7va7CqYSL2ESFaPN1mU39jB9zBd1ycuBMAZzELbawStfuWXeuFM
   dl0amqqjlQQi4ZMU87fC4ojJHE3nQqeras/3IuVVUAz5CLD1P2vjqKA2C
   oLDKhAeNAYwpcknJFdQKCELLG4/fnM7yIeX5JSe1rE+rpRb/BoMpBdG/c
   a44I0in1crr4A7uW/907OUT6fF/WmlDb5umnwJzvuXZStdCjvapqqN1nJ
   g==;
X-CSE-ConnectionGUID: ecC9IniHSYex5yzEINeu9A==
X-CSE-MsgGUID: OHNUmOqERj2SpzEJpOv7tA==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="77245854"
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="77245854"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 13:17:13 -0800
X-CSE-ConnectionGUID: vE0jX8CZR3OgE6pg9ZiGOA==
X-CSE-MsgGUID: 4ZhsCuckRluzkTM2u/A3RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="223449823"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 13:17:06 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 13:17:03 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 25 Nov 2025 13:17:03 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.19) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 13:17:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hjd7jpMgvQsejFQK2Xx3fBSi7qHhpXh+etZ6rOzx8lk2iFIJJIPgPQkBg51ojuHUCZbNIxyPNvXoTNRoq3aPxUvJP99M+TeH65jTW6lJ/Z1lFGaNUDfRI1DTFe2gNJBU43qOpy4iMP0Mah8J5x44uuQNjt1haR0zLJ3MDKxvR4mSCk0sic5r00AogY8Wui8BM8m7+SbY2tEAeX/yhUcD0Qmp+0rHvFkYyaZ+13PJ14sA0vUTTUuaai+VSNxZfC7FPxRpPZKMLEi9U9sqeE/veSylaL/IvtmR7+nCifRxPn43EmWrqAB2r9O4BcQdG/Ug663nPevVgTfA4BbS6qS6oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywnrQpqjJaT3f0w+3vlXVInO9wYW69wuY9X2AWbS/Uw=;
 b=lLMN8QcZWY6jHsetrBzYmNVLe+2jsEmOM8MtZDMR8fS64YK6thEH/ct2GfvW+c8A584q0YCxoSG8FA9zqYITx9cv2lnXO4whybZkcv5HKjCNxMu2r28lJz0gpWP0ehGL0SrjrYU/3bhlVw2HBUHqU+AxJPkmF5Ds6sN57K7zpOtCxpnVy2De9TBxRWtS+WyFH80xni9tYgZXdS/f/CMsDtxwWgi7ttUS8Qpn4OG0xVVpuCKRypubs8WkRVub0rrt8/T0qwYjEYaQDNiaZ67Uxnf02msYZiQNquEfIejpA0JzlkbTFepKZZ7mhLNsKh+rtw6MAF3TS7q3BbruqwKx1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA2PR11MB4939.namprd11.prod.outlook.com (2603:10b6:806:115::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.16; Tue, 25 Nov
 2025 21:16:55 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 21:16:54 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "khushit.shah@nutanix.com"
	<khushit.shah@nutanix.com>, "seanjc@google.com" <seanjc@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"shaju.abraham@nutanix.com" <shaju.abraham@nutanix.com>, "Kohler, Jon"
	<jon@nutanix.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: Re: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index: AQHcXjY65nOVz4wgDEaWpdjNjSzcGbUD5TWA
Date: Tue, 25 Nov 2025 21:16:54 +0000
Message-ID: <30d15b0b01a72f592c218bdc6fec6f3aad5212f0.camel@intel.com>
References: <20251125180557.2022311-1-khushit.shah@nutanix.com>
In-Reply-To: <20251125180557.2022311-1-khushit.shah@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA2PR11MB4939:EE_
x-ms-office365-filtering-correlation-id: 1552cbeb-b22b-42ae-cd1c-08de2c67f5ba
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VmEzKzZzZi9neGdjL1lwNm5jSTRGeHRRRmxLTTduSVA3UWJBTnJyNDNXYkUz?=
 =?utf-8?B?NHR2M2dSYzJMYkhYQVFDYTAxWmtSNVZxYkVNclM4OUc3T2NnMVZham42MG4r?=
 =?utf-8?B?d28rNmEwZ2VTUlZpUGw1VkZpbXBBMHBJV0ZMdlQ4Ty9vWkhNS0FaMlQwMitY?=
 =?utf-8?B?a20vUHVzUEtxVmVCaDBCbGVVYVB6WGQ2S0VBRUVlNTVhODA0M2xqOWN5SXNw?=
 =?utf-8?B?dGwzQlluUzZEUWVHOXVhQ1ViTkg3VDAvS09hcWtEenRFdW1KYUp0VDN0SGwv?=
 =?utf-8?B?cUZ2eWtUS05GYlhQMEdMMHdTaHU4RXJ5RUhBNzk0ZERkZy9RNjVTOWhOcGxz?=
 =?utf-8?B?Q1ZDTmkveFY0eEE0Vmc0MjZNamlNRCtGSHJLMTJwM01sbWlZd2tmNy91bi9o?=
 =?utf-8?B?MWFHbTNESXRQYmtWQm9FNnZmd1pTV3hZSVFXUDNtRTJQaTZDLzR1OWRKY2Fi?=
 =?utf-8?B?d2lHOUpRRDc5eTl5R2N5Q1hzSTQyVDVhYTBtdmZWVU5qMUNzaDFqeEw3YVUy?=
 =?utf-8?B?Z1lSdXJQWDhZbG1oYy81N1RPRml3ZTNDaUE3Z2pkbno2eTBqQjZDdnN6cEpx?=
 =?utf-8?B?Rk9BRmE0ZVRLUlArYjRHM0NSMnJybkY0OCtVMlRRZlVJdHNVWEk1SmdyL3NQ?=
 =?utf-8?B?REdvaVB5eUcwY0lEc0pwNDlramZ2UU5FWitwTWZ4Rm9iZ1hTc1BWWFMzblo0?=
 =?utf-8?B?OVRCd01STlRMc09JSzcvUTd2UHpOYzN3TmlBWnhieXBxaU0zemVnK0l3TUNh?=
 =?utf-8?B?VXZsd1RpakVTTWJ1OC9OZ3BxNk8yMkVaMnc4dzJtMWpycnozTnBBcmZERXUr?=
 =?utf-8?B?ZnlzeVRZTDFZb21JRVczQ2RmMUtsemdIOTYzNWRKZm9jYlh6dWZKYWlXb1dM?=
 =?utf-8?B?M3BGYVNtY2dqTnJINmNBajUwV0V2WmFOZ0ZKT0d1TThqWkNtVDJPOUFKTHJT?=
 =?utf-8?B?UFNtN1FtVUdibmxzd3VQVDJhemMvMDZhZUdGclVvNGxYRkJDbHhJZStjbWdo?=
 =?utf-8?B?SE1kKytrZlI0UjQ0NFc5dWZBdXk5bUR2RjBwaktSUzVtTW4vMHFEWk5ZYUlq?=
 =?utf-8?B?ODJ1aGFJTFpCMjVtZzAwN1VEWmYvd1RxS3h2dndxMFhHMW5hWkhiNzIvdmFv?=
 =?utf-8?B?anBOYkloYXJOaFltM3JJLzd1b1N0RU0vbWJWYkM0TDdXUG9NZk9ZVzVXQWNX?=
 =?utf-8?B?RERaeFBvUkZvcDQ2c01XWGY5dFF6WnBUUTJvSlk0d1AxZUtVRmttSDVDSUVE?=
 =?utf-8?B?T21ieVFHSzVuRmF4STBmQmVkTktKZFZURkpxVkZEWEc5c1ZWNHBIZHg4Zkxz?=
 =?utf-8?B?TnJpcDVCdlhmbVRJcmd4c0xoSTJ1Sys1VDFjeXcrcTBMSUFyT05td1c1bWVk?=
 =?utf-8?B?VzlrVHFHNDByZDA5YWlYZS9TUTRqQzJvNERoTkp3KzVWem8vUmVkczVnak9C?=
 =?utf-8?B?aWZHK1dNZXF1RG9jYy9oZGovWGZtR3E2Y0dDRmhNaDZaVkhCRjFtWTExUWhw?=
 =?utf-8?B?WWNUeWRRYjRVMEgxSks5OUd1T2ZyRytianpoRTBQekIzVktTOVN2MzdCRy9U?=
 =?utf-8?B?MnB0TWhVbVpiK1ZpdXcrdW9PMFNHcnNCeWdtRm9iNTVLL2RJNnFEd3pXYmcy?=
 =?utf-8?B?OUszR3ZYekxVa1Fvb1dPWmdZakdpRFBERldSeXZRaFIrZW5McG1DTXFQbXUw?=
 =?utf-8?B?cTBDUGVIb3Bjb3k2bGFFM3MwZm1UWTFlL3hWTTUwcnBiYXFvZGxaSjRBYUpo?=
 =?utf-8?B?aWxOKy9VK05qekNsWkNnOU5MTUw5LzFySkQzdkpuQ0lPWlljaDRESExTYnpG?=
 =?utf-8?B?OUFHdDVXeXpNODRYdExqdVQyNE1yQTQvdDhxMnlVYkN0K3VMK0xBMGpSanUy?=
 =?utf-8?B?d1paMXhLZ2VPQWxsM0IrdHRraDl6ZXZlbmFKT0wrWWNlMFZoYUJ1OUN1Q2lX?=
 =?utf-8?B?SjNSNnB4K1dKZmFIMXExVzlwTFZERzJ1eGE0eVNHdVg0WkhmWm9GS1paN1R6?=
 =?utf-8?B?VnNyaGVEZzRMZjJaZ29maDlsK3Fub1NwQmNpczlmK0F1NHYyZ3MyNklmcUJY?=
 =?utf-8?Q?YD2rvq?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cmd4S2xtZGM1QVN0SUlwcUkySkU1Rjd1L2ErRlY4UXVzSnEwQVo4KzUxYnRu?=
 =?utf-8?B?eHVWSVUxa0thZzR3a09ha2luR3JEY3o5TGhzY216RG5CNkdIQ3daRHIyR2Rp?=
 =?utf-8?B?YTV4WFlQMk9oc1l4dENRcHJzRS9ieE9yTWxnekgvSEZzeTZGZ0ZVMTJPeWZP?=
 =?utf-8?B?YkZKT0FlcnlIalVKZXFWR3hJS2FrWDdwcFR1TGFzcndjUzFLcE4vNXRZallU?=
 =?utf-8?B?Y3dzWWNHeFVCMkVJNFFkVUMrY0dLL3h6eUYxQ3o2NWpFLzJHK1hKc3ZDUU1y?=
 =?utf-8?B?Z3BDbUxXdzZPa3dXRmZ5VDVUOEU4UnN5V25FZGx1U2NObGhkcFRFc3BTcHRT?=
 =?utf-8?B?TXFiZlNjTXV6ZDRsbEROR2lZdTJORzA2SVZ0M3lnL1dHanlKYlQzOW5DeXZS?=
 =?utf-8?B?dEhtbEErRjczbS9WZktWRk5xTU13ZktVL0xTRVFudzlhUHZoOWRwMVllVUVh?=
 =?utf-8?B?VW81am9DaE0rSlo0VlR0Y1c3dzExZm04NytDYWhURFhNNktWMTZ5MUtMeGYv?=
 =?utf-8?B?bi9henhqeDFpUFVFVDVKNzZsUmdvTVJ1NmRZL0VWZG1MRkJxc2gzaXByNUhQ?=
 =?utf-8?B?djU2aTFoNHc1bDlBWXZPTFFYZ21WaEZMQklMbW4zdmdwS2dIUWRPNFUvc1ND?=
 =?utf-8?B?SS9qWG1NT3d1UDJOOUZPb2d4cGRXSDU2TDN3T2lmQ2ZocC9PaDloMDVsWXNG?=
 =?utf-8?B?akd3amxSVEJxUCtBSEVzZURDaC9RTGZtNnRjVlBhMk9HNlVxTGdvTXlUSVAz?=
 =?utf-8?B?VFpsZnZhVUJLTlFrdnpTVFRJRmdDNjZucTZnRG9qek5FdnpXZEVTdW1KMUEx?=
 =?utf-8?B?Um90c3hCUmhCWUlXamxVSVlabkJpcCtUYURZbWs4cHR6QmtsRWpEcHMvWmRE?=
 =?utf-8?B?bDVRVVlSZDJ6WlNyT1ZwOC9Lb2s4c0JSMzc1NzRORDk1QVVsdndNN2djMy9J?=
 =?utf-8?B?RXVXSzRieWk4ZjFWSUhtUWdjT2U3QThVZ250MVhJMldHaTJ5bUVDbmlGYzdU?=
 =?utf-8?B?NzU2TVZpUW5FV2JoVmZSeldLU0d1RTZwbGxkUDIvN0VwVWZ4OTlDNkZpRGN5?=
 =?utf-8?B?OEJmdHYwMXRNWk94QjhzanNhWWxLWUpOMTB5cXBUN0V0c1YzNldBRlMxM0ZF?=
 =?utf-8?B?SDZQcE9LMW9pMGMwS2RaZmRETWovbG5HMHNKSHI4VnB0Z05VcEVIc3B4RXRR?=
 =?utf-8?B?K1YwUE5CNnV1ZGUzcDlqOVNMamg2OVN5QW91dTNEVDBodXAwTmx5UGdCZFBz?=
 =?utf-8?B?NjBvZFFUcmsvclhRYktMczNhc3dXc05yZlVDNXdaN3d4eEJMcDBXQ0NTZGlv?=
 =?utf-8?B?ZGJlOFhuNjhOWnJ6eXpsYk1SaUJ3VzFuNTJSaEpDdVZ4bkRpZlFBVUpQWTFI?=
 =?utf-8?B?T2d2aDZEZGZORHliNXBjRTl0allYSEFBYmFTd2JNemk3VlA4bkkyZXo0MmFK?=
 =?utf-8?B?dUNRSEMvZ1g1RWkrVGVjVWhkUSt3d3AxUmdhNThKcldwc01uTWlpWnpEYlo2?=
 =?utf-8?B?OFQ5WVdwcm5HWC9UaXdTVGhYb0N1MjBqSVFaSGZ5dlBickQ1bDl1VUF5ZzFH?=
 =?utf-8?B?S2hCZmlDVDZub2F3MGlKZ0I0NHczMGJFbHJLbVhMSk0xSVJXUFFHbnlRRE5q?=
 =?utf-8?B?WmVXYlJleTdCT0lkRkhYdW1MMHNuYWJMUmh3L2lRdHphSGtBMno2SFBRa2Fz?=
 =?utf-8?B?OTFsNTZVRzNFYW9DdTlkbHFsZURORjc1clBoY3ptZVZQalBpbWJZOVhON25E?=
 =?utf-8?B?QzZ6b0tybFg2RWtqWDhFM0xlZ0xVYWRxZjhYbGZkL05PUDBFZ1QwdzBPYXBr?=
 =?utf-8?B?bExDZkxBSkZNZ3NrRXB2NnhaUmIxcDZuQ0dxU01TcFB2cTBQajJkenN2NlhL?=
 =?utf-8?B?bHdOL3BwckNUODJzWU9mbVBJZUlEcGhxaXp5YzNML1BuUEN2bnJqMU13VW8y?=
 =?utf-8?B?NGs5c2xHUnoxVk56cFNkcklJNU10UGxkL2RtNnpIMHIydlhIOHNidGx0TEJN?=
 =?utf-8?B?Rm1SMHE0YlhtSFhwK2dzUy9zZzNjMVRGSTZoTlA1WDZDdFZKNUkyMUl5ZDZF?=
 =?utf-8?B?emoyeVJ6NTBnTkRZdXMrUXdVdEp6eWZ6TTRsdnV0OVBZMVp2UTcvU2lzMXls?=
 =?utf-8?Q?bVxjo4FdExDhYx2dCHZxyvjZf?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <479AD55719E22D46ABA11761EF50F72E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1552cbeb-b22b-42ae-cd1c-08de2c67f5ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2025 21:16:54.8812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K3jeKzKp/iecdFLviWdBUD6F4rGnLsXluZytIMwFCaBIyBVmN8nJLsq2FKiSiZtIJtOkdbKcPjnwSI8OqsRAtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4939
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTExLTI1IGF0IDE4OjA1ICswMDAwLCBLaHVzaGl0IFNoYWggd3JvdGU6DQo+
IEFkZCB0d28gZmxhZ3MgZm9yIEtWTV9DQVBfWDJBUElDX0FQSSB0byBhbGxvdyB1c2Vyc3BhY2Ug
dG8gY29udHJvbCBzdXBwb3J0DQo+IGZvciBTdXBwcmVzcyBFT0kgQnJvYWRjYXN0cywgd2hpY2gg
S1ZNIGNvbXBsZXRlbHkgbWlzaGFuZGxlcy4gIFdoZW4geDJBUElDDQo+IHN1cHBvcnQgd2FzIGZp
cnN0IGFkZGVkLCBLVk0gaW5jb3JyZWN0bHkgYWR2ZXJ0aXNlZCBhbmQgImVuYWJsZWQiIFN1cHBy
ZXNzDQo+IEVPSSBCcm9hZGNhc3QsIHdpdGhvdXQgZnVsbHkgc3VwcG9ydGluZyB0aGUgSS9PIEFQ
SUMgc2lkZSBvZiB0aGUgZXF1YXRpb24sDQo+IGkuZS4gd2l0aG91dCBhZGRpbmcgZGlyZWN0ZWQg
RU9JIHRvIEtWTSdzIGluLWtlcm5lbCBJL08gQVBJQy4NCj4gDQo+IFRoYXQgZmxhdyB3YXMgY2Fy
cmllZCBvdmVyIHRvIHNwbGl0IElSUUNISVAgc3VwcG9ydCwgaS5lLiBLVk0gYWR2ZXJ0aXNlZA0K
PiBzdXBwb3J0IGZvciBTdXBwcmVzcyBFT0kgQnJvYWRjYXN0cyBpcnJlc3BlY3RpdmUgb2Ygd2hl
dGhlciBvciBub3QgdGhlDQo+IHVzZXJzcGFjZSBJL08gQVBJQyBpbXBsZW1lbnRhdGlvbiBzdXBw
b3J0ZWQgZGlyZWN0ZWQgRU9Jcy4gIEV2ZW4gd29yc2UsDQo+IEtWTSBkaWRuJ3QgYWN0dWFsbHkg
c3VwcHJlc3MgRU9JIGJyb2FkY2FzdHMsIGkuZS4gdXNlcnNwYWNlIFZNTXMgd2l0aG91dA0KPiBz
dXBwb3J0IGZvciBkaXJlY3RlZCBFT0kgY2FtZSB0byByZWx5IG9uIHRoZSAic3B1cmlvdXMiIGJy
b2FkY2FzdHMuDQo+IA0KPiBLVk0gImZpeGVkIiB0aGUgaW4ta2VybmVsIEkvTyBBUElDIGltcGxl
bWVudGF0aW9uIGJ5IGNvbXBsZXRlbHkgZGlzYWJsaW5nDQo+IHN1cHBvcnQgZm9yIFN1cHByZXNz
IEVPSSBCcm9hZGNhc3RzIGluIGNvbW1pdCAwYmNjM2ZiOTViOTcgKCJLVk06IGxhcGljOg0KPiBz
dG9wIGFkdmVydGlzaW5nIERJUkVDVEVEX0VPSSB3aGVuIGluLWtlcm5lbCBJT0FQSUMgaXMgaW4g
dXNlIiksIGJ1dA0KPiBkaWRuJ3QgZG8gYW55dGhpbmcgdG8gcmVtZWR5IHVzZXJzcGFjZSBJL08g
QVBJQyBpbXBsZW1lbnRhdGlvbnMuDQo+IA0KPiBLVk0ncyBib2d1cyBoYW5kbGluZyBvZiBTdXBw
cmVzcyBFT0kgQnJvYWRjYXN0IGlzIHByb2JsZW1hdGljIHdoZW4gdGhlIGd1ZXN0DQo+IHJlbGll
cyBvbiBpbnRlcnJ1cHRzIGJlaW5nIG1hc2tlZCBpbiB0aGUgSS9PIEFQSUMgdW50aWwgd2VsbCBh
ZnRlciB0aGUNCj4gaW5pdGlhbCBsb2NhbCBBUElDIEVPSS4gIEUuZy4gV2luZG93cyB3aXRoIENy
ZWRlbnRpYWwgR3VhcmQgZW5hYmxlZA0KPiBoYW5kbGVzIGludGVycnVwdHMgaW4gdGhlIGZvbGxv
d2luZyBvcmRlcjoNCj4gICAxLiBJbnRlcnJ1cHQgZm9yIEwyIGFycml2ZXMuDQo+ICAgMi4gTDEg
QVBJQyBFT0lzIHRoZSBpbnRlcnJ1cHQuDQo+ICAgMy4gTDEgcmVzdW1lcyBMMiBhbmQgaW5qZWN0
cyB0aGUgaW50ZXJydXB0Lg0KPiAgIDQuIEwyIEVPSXMgYWZ0ZXIgc2VydmljaW5nLg0KPiAgIDUu
IEwxIHBlcmZvcm1zIHRoZSBJL08gQVBJQyBFT0kuDQo+IA0KPiBCZWNhdXNlIEtWTSBFT0lzIHRo
ZSBJL08gQVBJQyBhdCBzdGVwICMyLCB0aGUgZ3Vlc3QgY2FuIGdldCBhbiBpbnRlcnJ1cHQNCj4g
c3Rvcm0sIGUuZy4gaWYgdGhlIElSUSBsaW5lIGlzIHN0aWxsIGFzc2VydGVkIGFuZCB1c2Vyc3Bh
Y2UgcmVhY3RzIHRvIHRoZQ0KPiBFT0kgYnkgcmUtaW5qZWN0aW5nIHRoZSBJUlEsIGJlY2F1c2Ug
dGhlIGd1ZXN0IGRvZXNuJ3QgZGUtYXNzZXJ0IHRoZSBsaW5lDQo+IHVudGlsIHN0ZXAgIzQsIGFu
ZCBkb2Vzbid0IGV4cGVjdCB0aGUgaW50ZXJydXB0IHRvIGJlIHJlLWVuYWJsZWQgdW50aWwNCj4g
c3RlcCAjNS4NCj4gDQo+IFVuZm9ydHVuYXRlbHksIHNpbXBseSAiZml4aW5nIiB0aGUgYnVnIGlz
bid0IGFuIG9wdGlvbiwgYXMgS1ZNIGhhcyBubyB3YXkNCj4gb2Yga25vd2luZyBpZiB0aGUgdXNl
cnNwYWNlIEkvTyBBUElDIHN1cHBvcnRzIGRpcmVjdGVkIEVPSXMsIGkuZS4NCj4gc3VwcHJlc3Np
bmcgRU9JIGJyb2FkY2FzdHMgd291bGQgcmVzdWx0IGluIGludGVycnVwdHMgYmVpbmcgc3R1Y2sg
bWFza2VkDQo+IGluIHRoZSB1c2Vyc3BhY2UgSS9PIEFQSUMgZHVlIHRvIHN0ZXAgIzUgYmVpbmcg
aWdub3JlZCBieSB1c2Vyc3BhY2UuICBBbmQNCj4gZnVsbHkgZGlzYWJsaW5nIHN1cHBvcnQgZm9y
IFN1cHByZXNzIEVPSSBCcm9hZGNhc3QgaXMgYWxzbyB1bmRlc2lyYWJsZSwgYXMNCj4gcGlja2lu
ZyB1cCB0aGUgZml4IHdvdWxkIHJlcXVpcmUgYSBndWVzdCByZWJvb3QsICphbmQqIG1vcmUgaW1w
b3J0YW50bHkNCj4gd291bGQgY2hhbmdlIHRoZSB2aXJ0dWFsIENQVSBtb2RlbCBleHBvc2VkIHRv
IHRoZSBndWVzdCB3aXRob3V0IGFueSBidXktaW4NCj4gZnJvbSB1c2Vyc3BhY2UuDQo+IA0KPiBB
ZGQgdHdvIGZsYWdzIHRvIGFsbG93IHVzZXJzcGFjZSB0byBjaG9vc2UgZXhhY3RseSBob3cgdG8g
c29sdmUgdGhlDQo+IGltbWVkaWF0ZSBpc3N1ZSwgYW5kIGluIHRoZSBsb25nIHRlcm0gdG8gYWxs
b3cgdXNlcnNwYWNlIHRvIGNvbnRyb2wgdGhlDQo+IHZpcnR1YWwgQ1BVIG1vZGVsIHRoYXQgaXMg
ZXhwb3NlZCB0byB0aGUgZ3Vlc3QgKEtWTSBzaG91bGQgbmV2ZXIgaGF2ZQ0KPiBlbmFibGVkIHN1
cHBvcnQgZm9yIFN1cHByZXNzIEVPSSBCcm9hZGNhc3Qgd2l0aG91dCBhIHVzZXJzcGFjZSBvcHQt
aW4pLg0KPiANCj4gTm90ZSwgU3VwcHJlc3MgRU9JIEJyb2FkY2FzdHMgaXMgZGVmaW5lZCBvbmx5
IGluIEludGVsJ3MgU0RNLCBub3QgaW4gQU1EJ3MNCj4gQVBNLiAgQnV0IHRoZSBiaXQgaXMgd3Jp
dGFibGUgb24gc29tZSBBTUQgQ1BVcywgZS5nLiBUdXJpbiwgYW5kIEtWTSdzIEFCSQ0KPiBpcyB0
byBzdXBwb3J0IERpcmVjdGVkIEVPSSAoS1ZNJ3MgbmFtZSkgaXJyZXNwZWN0aXZlIG9mIGd1ZXN0
IENQVSB2ZW5kb3IuDQo+IA0KPiBGaXhlczogNzU0M2E2MzVhYTA5ICgiS1ZNOiB4ODY6IEFkZCBL
Vk0gZXhpdCBmb3IgSU9BUElDIEVPSXMiKQ0KPiBDbG9zZXM6IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2t2bS83RDQ5N0VGMS02MDdELTREMzctOThFNy1EQUY5NUYwOTkzNDJAbnV0YW5peC5jb20N
Cj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gQ28tZGV2ZWxvcGVkLWJ5OiBTZWFuIENo
cmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBD
aHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEtodXNo
aXQgU2hhaCA8a2h1c2hpdC5zaGFoQG51dGFuaXguY29tPg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1
YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

