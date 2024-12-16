Return-Path: <kvm+bounces-33859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 143B19F30A3
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 13:36:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 459A5165BD7
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 12:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296CF204C3C;
	Mon, 16 Dec 2024 12:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="InEMgMj0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71FD1B2194;
	Mon, 16 Dec 2024 12:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734352556; cv=fail; b=ZUz1TEMPS8Sh7TH3e2a3CI9sTZnkHQSuUOmWKM0XuHO0mLwDTWi4IhRvQfrizx7HVhsVr3WvFbjvSKYndN7h8YwXK6jXRerL+4DfxvTOkLgNcEJrhajG/6Ctq5Zs6036gwMf7rRN7Re02DCIfqFBChRa1G1e5BM/nc8WsxuweyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734352556; c=relaxed/simple;
	bh=+AfR+GFeckYVPX4KibGv3PgzZdaD0N/Npe/4PSmZwRU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EbQL43bUHFsXGiCKcOyINrVSsh4207Ycp9ti4ScilMimPhsuSilODveTxsYWJBuOR61us+JmyfSz9vpELoh/LGDryxClYxjmDPGuBjJnh3Bgpiu5v4bx1UzFdOWNd5dWIo+P9pzRJlhWOKct/KVSeQiRsgy8+5muoyW46My8X24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=InEMgMj0; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734352555; x=1765888555;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+AfR+GFeckYVPX4KibGv3PgzZdaD0N/Npe/4PSmZwRU=;
  b=InEMgMj0HcZJAsGqTR4qhIxMOnpxjbzFmPNPyuRz1bgrg1GapeHkpivh
   xk+WnxP7vsaH9+rzZ3LE4mi0ry2712dNhhjlEtLlFwgMlxDy7ukuk/zFh
   56quYVp1bX9BZnMId47a6HDtpEBgWdmqck1jkm2l/tmgm+kLtm1miz4JJ
   J31DgHjVqabKeiP+uKRjxvIiDJySE/aszaZS5urApR+XxOc0AZiwGLbq2
   fgAXIuT2vWBY1ngcBAuqME1EEvDZs+0VVk3qAogPRhXounh+mi9alU8lW
   GGX0YTsPc6PUGH/DDQWtt0TaQ1LaktM5odIzQtOJEqoHzLzTlRIHkQMh3
   w==;
X-CSE-ConnectionGUID: vUUDp6PrRzCuY8nRWTK2lw==
X-CSE-MsgGUID: Y5pjQutRQoOsYzk76Kidbg==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="46143142"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="46143142"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2024 04:35:54 -0800
X-CSE-ConnectionGUID: dAxSDVTAQq2gkRYFIn0VQQ==
X-CSE-MsgGUID: MC2ZPy8zQ/mCicwDTgK86A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="97622664"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Dec 2024 04:35:54 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 16 Dec 2024 04:35:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 16 Dec 2024 04:35:53 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 16 Dec 2024 04:35:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t2rqdOr9qZQB3iMJbtKZXalghFj4fWbzD9rdOpLbUSUCsC4m7hsSxsCfqZc0B2UeTwH1QHgci+NkND8sEw6UyhF7icLCL8aT35QsNQoy8TT0Snv6m6xZGhFhzcjIN1VxTokpkGQILSr/TpZ/u3uKKHjl8patu006tV1bo1e0sAvj5swIBVhcX1Keea8zPm75jSbtC8bBvGB0UL00oQIF7MK4323b6+4iFt4R7RTrpQGvHkahX1UUcR11OuqhxEoy8N+sVqZdVC4N/0jnyjhTufsJN/LewKT+a+YpwEdlUS3BWjdQkb2Y4K21nsMwb3HanEddas/AZuYqF04nVIStYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/5osGSZqMN7a5twSGQtoLpsjVHPDJHzEM5jOTTs6JkA=;
 b=LWI7sXWSENq31aW8vaUHdbyZIV8biok/y8we7dGf9lBd65z2VlRlQRlIKn5jGJ5byVgroUcWXExTjQIDHJMClJjZVlE/+vm7q1L4LpVhf/n1ox6r9bsOc7K/komChiZDW6VY0rhAKgxDGYy0AzEZ17ep9n8qCOWYHh02f3dPDVkJg5VylZIInMeeJ9/vyEdfdKCaRcNSPbyUecXi+QX7avwecyf1VvrEVcaOhLUzGrgkjVAik2PnVr2sLYHWjIS8g729R882abztxJzJ2+enPc31r0F6LRtsIgQiB6S4QZJYYH7y0dzUITjmsTdt5TF9nHizHhvVOxw+RVxcyMJ1Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB8374.namprd11.prod.outlook.com (2603:10b6:806:385::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.20; Mon, 16 Dec
 2024 12:35:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8251.015; Mon, 16 Dec 2024
 12:35:23 +0000
Message-ID: <9c726906-10d3-47c6-acec-18604eb83e0d@intel.com>
Date: Mon, 16 Dec 2024 20:35:16 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/18] KVM: x86/tdp_mmu: Extract root invalid check from
 tdx_mmu_next_root()
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <yan.y.zhao@intel.com>, <isaku.yamahata@intel.com>,
	<binbin.wu@linux.intel.com>, <rick.p.edgecombe@intel.com>
References: <20241213195711.316050-1-pbonzini@redhat.com>
 <20241213195711.316050-10-pbonzini@redhat.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20241213195711.316050-10-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA1PR11MB8374:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c3b2f16-1546-4585-13e3-08dd1dce1c28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L2Rnd3c1eWJ3bVU4UTh2VlZFb25IYU5pR0JSdktxbHJ3QmJqN0VRcDZVSWJE?=
 =?utf-8?B?Zk4zcjhva3lVZVJKL0NBR3dSd3pIdkV4T2kwSVhuV3daQlBwdzg2MEtRUTFC?=
 =?utf-8?B?MlpvZ2NiVnVpS0ZYSGQ0VFVUYmVOdWlGL3ozUnNmaVk5R2FMK1JQQTcrQncv?=
 =?utf-8?B?SllRKzhXbk1aQlN0azRjcno5VmZOUkNtelZIajhQQThadDhqeElGUDhPSmdy?=
 =?utf-8?B?em9tbk5TSzY4akphQWZrQU5VeUw4ME5HVFpuKzhFSFEvazhaZ0YrV29QNzhI?=
 =?utf-8?B?ODZmVVNvR1JHdDhuZDFuZy81dDhYYlkwL1EweUdvVUxXTFBkci9qKzFDZ056?=
 =?utf-8?B?Y0FrTUZrQ2NGaXFsekxoMjUrbXl1SzBmNHlHVThmQzAwbTFnb3ZsYVBlZVNy?=
 =?utf-8?B?QXVMODg1Mk1jdTIyNWRPZTlrY3FGM3ZRRmZuOGQ4ZXBKM1BCSFBMN3I0Q2xs?=
 =?utf-8?B?Z3J6enRqUENBdHoyUUxoSk9UR2tMSlYxbmxRZ0prSXAza0ZSRDZqdW12U0d2?=
 =?utf-8?B?Mkd0TTltSFJIM2ZoZUlGclhBbHFkZ2RWWjcvMmFPcHBuY095NS81THZYdVpv?=
 =?utf-8?B?cFRHYTlHOW5pdThTTk5Xd0FpakNMTWtENWNvaXlrSnNwYnlhZXV2VHpEM1lX?=
 =?utf-8?B?a2cyL0NJcWFHYlJNb1F0SHNVTE1PQTVLWXZnVDVPNTVZUFdlWDlKMm1Ealo4?=
 =?utf-8?B?ZG5ZZm1jenduaGVoT0d3aGM2T2RTVVFBeEJualk0bUE3cHl1UFM2NjhYMzhY?=
 =?utf-8?B?Zk5aK0NScHJ3dFRxSldkckl6bHg1UklscVljRUQrSHgrMW9RTHErdmh2d09x?=
 =?utf-8?B?a0hsWVdVaGROK1grMHNMdkFHTWo0L0VyRVdYYWZtN1YvZVk2TVV0NXJ4V0hD?=
 =?utf-8?B?ajRRb0hKRThFMEczdHA5QmZlR3F1dUFpUDI3MzBoUzg4TmhvMHJpUHNkVXVP?=
 =?utf-8?B?YUU0a1U3QTlVaUdKeWNOdWtMTEgrb1FjM1hXbWQwdThJWjJLRUdxVEdFU29J?=
 =?utf-8?B?bklySFdEbmVzQXV5VWF3RUtQNE9zMTB1QWMrL3JlQzNFQ1BrNXNMc2p4VXZX?=
 =?utf-8?B?SE1DZTcwZjRUTzNGdW1lc21LVWZjZ2Q0NnB5T1dSRWJqOC9CN2RXUU9pcjBX?=
 =?utf-8?B?aTVqMTlmMWtxVldtS0tEeTNPOFErM0xrY2V3b3BXakgyRGN4akIyVzdPT0xj?=
 =?utf-8?B?ZjZaV2JacVE4OXN1NDEweWQ4Mzl0S0hOak1odVV0cS9oWkhWMHdFTzZNZ3M4?=
 =?utf-8?B?eXVLR3lRL3VPRmFUQ0FvZ1Faa1ZwWndRWXNHMGgzZDloSVRKUUZHZGVEaGdC?=
 =?utf-8?B?UVFpTzZhOWN5V29Qckc2QkxLdTYvMERaM0JxaEpHNVRPNzNOa1dHNHQvRUdi?=
 =?utf-8?B?Wm1UVVprV1ROaENMcENpc01MY1pqaDRGOVg3Yi9ZTHU4Y0RIQzRCdFk1UURE?=
 =?utf-8?B?cy9WZTBOWnhMa3FrZk02cWRlSE5hMTF5M1prZ2E2Z3pGSW1RZTM0M3ZiSzhC?=
 =?utf-8?B?STNIakx5aXk1a2FhQzFUWkgxZ3dTWXBwaWo5VHExTTVIL0hPdUtKanprKzdS?=
 =?utf-8?B?dkIxVG9mZ0FwZ1krMnJWaWdxNEptSHNyaERYZzExVGRvaEp0cmFTZDVmT3BQ?=
 =?utf-8?B?L0liUFFtUXU4TXJYUDlPeHBsTlpoOHZFRVZyaGJpUDIxYU5MdVd6Yng2dFN3?=
 =?utf-8?B?MDduQXpLK1Zzb2FDK2pXc2p6ZlhZanJpNGtRUXZOMVFZUThqOXZjaktRZ1ll?=
 =?utf-8?B?QW8vWlZFdEcwOFYvV0dheEFxd2k5T0o4VUVWMnVPMVlmRjZuSU85dHRGQ1Q5?=
 =?utf-8?B?WTh2M2U0Mk91MlFGYm9jUWllNWUvcmJac2RDQlYyZThhUzlHM2hreVBNZkV0?=
 =?utf-8?Q?gx1pCg4EVGkTT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGR3cHR2VnJqQmtPa0RiVEllWEgrd3N4cEU4eTJHYlB0RCs0T0ZWejhJb0hY?=
 =?utf-8?B?UEhCTms4UGF3M3pYd1ZhZkdQVXBLUVQrcFRBYXdaLzhzSTl2R2VIT3pickJ5?=
 =?utf-8?B?dVFPeTB4U0dsS1Y2K2lTeC8wcjQxOE5tQ2drVXh6ME9xSXVWWUpzZ1U2alhz?=
 =?utf-8?B?WGovVytDTFRTTmpRU2dkZVd2bVdJSER6TU5KcWJpR2I2aVdSWlIwVmM1QTRo?=
 =?utf-8?B?TVhPdm13TzAvQUxRYXd1Z3dnRFBEOHowSld3cnhaamRpU0xjcWNPV1NlU1VF?=
 =?utf-8?B?WlFlSjY2OW1nT21GSUpES3VQUkpWbDYrUzhvUVVWanVvOXhRWHJ6N1VRdjQ4?=
 =?utf-8?B?OEZhaVRjc0hBQkdnbUQ3SlNHM2lqNW9vU0gyTUEzbkxlRER0Sm5nRm41NVd1?=
 =?utf-8?B?YTRiejNTZjg0cmlkM01iZ2F2VXg1R2tGTTNqSjdRK3VVcG8yWHBReTNzb2Mw?=
 =?utf-8?B?aUxhWGlmeXpnL2RGak5rTzFnTERjaVI0T0d4bUs3bE5SY2NiYWo2cTl0N1py?=
 =?utf-8?B?dGdJdmFBbHBlcW15UjVLWWJRajhpRDF4WExCaWplWmE2WVNpN3Z3Snl3OHpi?=
 =?utf-8?B?U3llSGRUQkd2a3F3M3cyaTZMdHVwUGZrS2JGb1k3TFEwQXI2aUdIRy95blA5?=
 =?utf-8?B?UG13LzdyamhYK2dRUU9CUWZ4ZnBJZ3VncFNhbVc0Z0x4M1k4K3pBc0Q2L1pX?=
 =?utf-8?B?eGIrT0F6TnpLZnFrMFBjb3BzRE5SZWtTVS8vb1RiMUZReFI4UFI2c084R0Yr?=
 =?utf-8?B?d0tPTXdoVFNCUjV4bGdXSHhvQ0p4dWMvVWhDOW1td1BHYThlcjVIdlJ6WTUz?=
 =?utf-8?B?c1RORFNtR3lDdDZ0MUt5bWZ6UHV6VUVoR0FUQVM4b01uUEpJQVRVM241eDFr?=
 =?utf-8?B?MGRZWHd0WE50UHJkTCtHSjlsa2VyUnk0SWZMTkxvZnhPZ2MzLzlYTnREaWVj?=
 =?utf-8?B?bHVBL0Q1VlArRmVneGUvc28zOHo2UHFXaDNFeFBBS09iNGVhSWlWRmZDN05B?=
 =?utf-8?B?Y3d1aFdXT3FVVzRpM3NlL05yNHRZR2lCdWdGZjZKZ09aV2JSajhDbUh0ZlY5?=
 =?utf-8?B?R1oxaWxNNVRkYmZXVkZvL3RCWUtOQUdEa3dHR1d6dEtzSExrZHB3eUNPU0Rv?=
 =?utf-8?B?bm8rUWYzODVrc09palA4Vkh3dktWVFBycHVPRDJSU3NONGVpUDBLbG9YT0hm?=
 =?utf-8?B?OTI3T2JFZUkrczdwaWF2VHcxbXArWDNYbGcwTHdLWEwvcGxzWjlpT2ZNc3pP?=
 =?utf-8?B?RDZXMUxLMWpsQWhPN1dIcWFaQ1lHcThIdmFCV3M0T0loRUxJS3V6NXFQVHo3?=
 =?utf-8?B?UDhkNVNDRk5DNnFzTG55SFk0aTFmTFVyS0pJemFYRjROUlZnUi9EcHVQN3Yw?=
 =?utf-8?B?THJramRoZkdMU1FMSHNYdTgxNC9TUzl1WkFrdDJtaWp6ckdTUzhrdTVYcmIr?=
 =?utf-8?B?QWtSWjdLcTRlb3EwYTZyRWMvekxxWHJrMXhrWXYySG0wc0wwS3l1WjQxK0VR?=
 =?utf-8?B?TzRyQlpINU5qZDNLSGJUejM5cEtxVy9VVWxML2ZxaTJKaDNrRnMvKy83WUhP?=
 =?utf-8?B?WVRKMHk3b282cmtRM0FuVFFLV3UzNXRBNURwWGU0WmdKUGZ3c2IvbEdVM01v?=
 =?utf-8?B?ak5mcVZXWS80ajVwd3hRVHZrdzJrWTQxOGt5cENPZmhIZU9EaE5sZGpvOGFF?=
 =?utf-8?B?QjNBbjF2aVhWUEhUVERCdWtHMm93K2ZyME9VTGtsMVo1a2Q4S2NlZ1R6c0pR?=
 =?utf-8?B?S3NGM0psdWFEKzZmTDR6UWpOK21DZ0x0Z1pxeWo5bVd2dnRiSDdmQkc4d1E3?=
 =?utf-8?B?ZjJrTFZlTC9scVJBaVhsZjFXQ3N5SVFmTmFKUzNrSmp2ZVFtOEtkU3lTZ3dI?=
 =?utf-8?B?NTJBcjdKeUxKdFNDam9JQVhtTm5sanlNQWtjVmI4dGoyRFVpRE9xc3dlVFpM?=
 =?utf-8?B?T1lrWUNNbldTRStYL3lETXpKbWFrdkg2TEdOTXBhY01ObG9ranJMck5kVWpl?=
 =?utf-8?B?NFlvZlhLaTF0M3RzSWRBRExmNDkvQTlCOVdmTEwvc3RBVUJFRGR0c2l4MHc4?=
 =?utf-8?B?TG9rWCtsdmgvZUtoYkZtTW4zRVJRcFVwbnFxN2Exclh1VTYwRkxka3dTYzJ2?=
 =?utf-8?Q?YKL33/RR+PqCViJqgqlbuyTfN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c3b2f16-1546-4585-13e3-08dd1dce1c28
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 12:35:23.0975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zfil0Vsjn5QkkRBHuklWo1ZaPXGJxOj5zPlbxGRPxIk9+ENd5TWhjnTT2Ia/BcHQPm/hK0fHA+xciJcJNFwQHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8374
X-OriginatorOrg: intel.com



On 14/12/2024 3:57 am, Paolo Bonzini wrote:
> From: Isaku Yamahata<isaku.yamahata@intel.com>
> 
> Extract tdp_mmu_root_match() to check if the root has given types and use
> it for the root page table iterator.  It checks only_invalid now.
> 
> TDX KVM operates on a shared page table only (Shared-EPT), a mirrored page
> table only (Secure-EPT), or both based on the operation.  KVM MMU notifier
> operations only on shared page table.  KVM guest_memfd invalidation
> operations only on mirrored page table, and so on.  Introduce a centralized
> matching function instead of open coding matching logic in the iterator.
> The next step is to extend the function to check whether the page is shared
> or private

Missing a period at the end of the sentence.

