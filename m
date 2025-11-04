Return-Path: <kvm+bounces-62030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E0317C33118
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 22:29:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3E6DC4EE91B
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 21:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB8982FD66E;
	Tue,  4 Nov 2025 21:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hmuhSmvo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732F630594E;
	Tue,  4 Nov 2025 21:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762291642; cv=fail; b=bzioynERBiFT7HJ6Diy+mzKE4YkzqW8U4yJ1WUVKuGmFUa3gPhzxgM2jdg9dCzvgLWqHNnwklQ16cqojWmD6pX5qNN4mTDTeYLR7nacQM/UXATg9owFTAZ8vK7Ex0GkfFBSek36oO3W4NMBgdCLPQlJ9jrVsVF4RIicRDqhqp44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762291642; c=relaxed/simple;
	bh=VtqiX4Q377ONRGq3CMUyMd/yuTXjDVCKktb1fmYS1pA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C0Nws6sB4zq0nVwkQA3pbHZAc4G4hd6GQ3mmWdWOoC5TDQKG5UNmNjVN0o/QyD46wtKVdCmvCvbrNy0sO0Yjyw66xRjQUByqOBmQNjKikIRR+DOTv6PZeKtskACfOIGCJZeiJi9fCFchpDQ7LgnORMJJ1kKVThy0H2YqyocRZEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hmuhSmvo; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762291640; x=1793827640;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VtqiX4Q377ONRGq3CMUyMd/yuTXjDVCKktb1fmYS1pA=;
  b=hmuhSmvoZahnsyfR1JOX0uWFXmcywkEYKdrv1/KNd1f3D8m0fvvx5NpQ
   A/Rmxo9PV7YTvK2jRfloC/RTS1Fi3k/gi+03ahSc8+pfWpmdHGV7ufJfw
   gMttCHKtJOUJ2/0u8yPajIFr8b4qIusPD86n4bQlM50QHS9REX/iFcsjx
   XKBA1mDEU/4mjkjIklEE8N8CUjokITTSraZfxwajKPqQcB9/Wca4G127d
   0KKArCHuZpephhCVvVZMB+57xi137lOreubluYM/uOfK8vfZSUo8isG8b
   6BQYfeSAfnNLXVzyJ9JvMVWrv/gJbCvmWRAgc/+NsiDvjalFBgbxZdHXt
   w==;
X-CSE-ConnectionGUID: euX/Hk6gSx6ZwwyD8gGpkw==
X-CSE-MsgGUID: p+3lA88jQCWBi9DEtSSHFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="68258140"
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="68258140"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 13:27:20 -0800
X-CSE-ConnectionGUID: mNwdJCJ/RDasnriw5Tl25Q==
X-CSE-MsgGUID: J4aOEx7eSx2F0k0ioPhn0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="192434054"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 13:27:19 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 13:27:19 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 4 Nov 2025 13:27:19 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.70) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 13:27:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SBVD8aYEQbdVQC5eDGfC2QNv8nl4xjHlEom/atE7QcBbACaXgz2PuC4n80vByga5aJf2am/Dd0ercq4Ae+eWpqtf2Fb5PNSmB9NKrwkR3aCPAcEGxw6kmQ/83oPpZkFgt1AifAlNQESLlZXVFexXRUghMoiQsPteHoZLKaKSi6XSvc1VNw2qc+yRiGFpEzOpdiJ4hH0MV4mo8HhGsuYOPqFBh6QfR9jDgKo0bisFDZMaqrCZWtnz0nS+tBNdX7r0B3hatPsztO2z4iHA3Q718m5edpc3/4/EYBYmlBv0XKiucZOw/upns+jetqXEde+0IC+mRKbJYZmip5ZJzN2+qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtqiX4Q377ONRGq3CMUyMd/yuTXjDVCKktb1fmYS1pA=;
 b=oImvCExIJGpH6WjdHkJi+yQg8ZLMLd+0eZh1WQCAGD2MKW0QqjvbCAhE8YvcPHzzxnQD2AcM/kBAHgCyVoBrTjWLq1mO1SamweZwgSU7537g1QYV/B8ue3J9eV9pLdNpUlJ8964SJs23Sftzlss4fTgoFcj4ItBcf7mzSBeskSai1hMrHKJDpS2rPLcgYVRsri+tZ2v18aveq3ycQbSdBr2BwP8CgQLtdEDcU/5U8otml8DGH3XPyFLUR/xl1+jlwGBLij3MfAqoRWWCKBPfJop45JjHe7TE7c4Z41xU5F6WLbhlrT9UhCI2FifVP57oG7nE9FaF6bKw/su5TfDbgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY8PR11MB7292.namprd11.prod.outlook.com (2603:10b6:930:9c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 21:27:17 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9298.006; Tue, 4 Nov 2025
 21:27:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: Sasha Levin <sashal@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"alexandre.f.demers@gmail.com" <alexandre.f.demers@gmail.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "mingo@kernel.org" <mingo@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "coxu@redhat.com"
	<coxu@redhat.com>, "Chen, Farrah" <farrah.chen@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"x86@kernel.org" <x86@kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "peterz@infradead.org" <peterz@infradead.org>
Subject: RE: [PATCH AUTOSEL 6.17] x86/kexec: Disable kexec/kdump on platforms
 with TDX partial write erratum
Thread-Topic: [PATCH AUTOSEL 6.17] x86/kexec: Disable kexec/kdump on platforms
 with TDX partial write erratum
Thread-Index: AQHcRcumqtsA743H90KS4YZNwnQICrTVAvYAgAu5WICAAevQgIAAb8Jw
Date: Tue, 4 Nov 2025 21:27:16 +0000
Message-ID: <BL1PR11MB55251B7F0D18FB0D0A0906D1F7C4A@BL1PR11MB5525.namprd11.prod.outlook.com>
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-288-sashal@kernel.org>
 <834a33d34c5c3bf659c94cefc374b0b7a52ee1a6.camel@intel.com>
 <e15710b10ff4a5ddb62b4c2124700b1ab1c6763d.camel@intel.com>
 <aQoR27GYadapWwhy@laps>
In-Reply-To: <aQoR27GYadapWwhy@laps>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY8PR11MB7292:EE_
x-ms-office365-filtering-correlation-id: 07c66d46-3534-4e23-a612-08de1be8edd8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?TzJ4NHdpUWM2WUh6TFh6cnRaYUtTQ1BJT3JVOEVuUWhXNjdXQXpDRlNxL2NM?=
 =?utf-8?B?d2E4bFZDaDN3VkdOc0VPcWFWODRDbXg4WVNJYTdtd0JxZFY5NUVsRTB3aTVT?=
 =?utf-8?B?aUdvTU5kdTlmRlEybWNtcURpaUdPMlc4SFZhVmZHRFFGY1N6OWxidnh3eUdH?=
 =?utf-8?B?T3U4Zkc0ODFHcXV6U0dsc0RaRS96d3M5clBXRnB6NmorOEFTNjd5eUdSOUZV?=
 =?utf-8?B?Q2NRc1cyaFhVQjNOeFZYZVdHYzhoVm8xRjJ4WnI3eGVGcWN3bWEydzBrcUxV?=
 =?utf-8?B?ZHN0emxrdFdLN1lzRjRsbzJwZVlnVGw2d0ltMnZiM0pVWjNPaTV3ODd4Nmwv?=
 =?utf-8?B?MVYxd05Jd0x3Sk9qZnh0VFZLU3Y3cEFYdjJDR0ZLUUZjMUJRbm5aMXYwL01z?=
 =?utf-8?B?S3dLMXZHZnYyMFRsaytrZlR6TWtHQ1Y1RUJWd2Fla1RDQXNyVFd6cFU5eEts?=
 =?utf-8?B?L1ZCRFFzMlRpeDcwb2NEckphNjNiWXZ6T3prQjV4OUE5K3dkM0xDbU1GRWZN?=
 =?utf-8?B?UlNOd1ZrR3ltc2dubG5KY1hBWW0zaXh1LzJPS01WVmtCbTRuajhlVjZmMGNj?=
 =?utf-8?B?cmtoSDhjTm52VlArUGxaR1RiT3NLQ3NtTXg5b2pHZTFJMUM5OER2YU51Zi9N?=
 =?utf-8?B?VU5WUGJsWmxibmxZZzBBdFNyTmtMeHdiV0NVdlVnNG12T3dES0owVHlUNW9r?=
 =?utf-8?B?TFd5SlBqdG91TndtNy9kZ1BLY0pVWisrTUN2MCtmSEFVcjdvaFV3RDR1RW9P?=
 =?utf-8?B?c1NrbzF6MTg0V2wzZ1g4ZmM0bGo4VVZ0SFFneVAzbkdtNjJ1d2JOM1ZUclpM?=
 =?utf-8?B?RVJkbXJiNFBBR2o2NkE5RmF2amo1OWRHdFFLVURsY1B1bTl1K0YxSmxHUUll?=
 =?utf-8?B?bWROQXN5cUpqWnJMeEY5b1BlRjhxSm5ZQktnQXF0czlkb3FKOW9RODA3MEZw?=
 =?utf-8?B?TTNzMWZGdXpjRWRBRENZOEFpRW45UkhCd1ZmN0VobEtxUzduU01JU2ZDTGc2?=
 =?utf-8?B?Z1Y1M1A2WmFWT0lWcHlnam12SWk3dVVYamgzNmVvTitUSWpQbzk5dGNDaitE?=
 =?utf-8?B?NGNLTFNoOW45R2VrMHd6ejFOcU5hZXhWQ2MwaGZiNlJ6dUlGU0NLSnJwZFlz?=
 =?utf-8?B?cm1QQ2p0QkpPR1R5c09mV2ZBVDhKM2FvMXFnemxHUFVmMFlYM3M2TlpqbDZ1?=
 =?utf-8?B?aEJ3WWQ5dDBOQ3piTHpkZU5JcnlObWJvSW9DZm9mTGtOcU4ycGRSaVU5ZWxy?=
 =?utf-8?B?Ti9BS3ArTTB3eDZnMi9abStQb3BGMnJFVThkamhIVTQwRlhQenJvM0tmRUs5?=
 =?utf-8?B?aXh5Q2lmbU5hSFFEVEFFZ2hWd2NpaFIyQSsvSjBSZ1VveFJMcCtUZmszMEhC?=
 =?utf-8?B?QTV6U2p0anBMeGVGVGVrelZ5WEU1WU1tYW5qNStwS1k1Z0VROVVLUkVZL3U3?=
 =?utf-8?B?cGE4bHB6ekg5RldJNzFDVUlmbVpmOFh6NVFxYjh4dmFoUC9LYlp3ZVBVSlZ0?=
 =?utf-8?B?MjZ4dnZpT05udkFMUlVsZHRYd1VHMjN6OHZsUzFVRDJySmIwc29HTTFWemk2?=
 =?utf-8?B?V3gzaTJIelZsUzFBZllzcStnbDZGR2pBNWhNTG9hQlluMStZZjRqODVmRU55?=
 =?utf-8?B?cUFJbVFQb0ZHRGV1bSswc1gvTmVhd2RNQWdWbFlzSHNOSUtEemw1aWtMaGZT?=
 =?utf-8?B?ajhwdnpoWUVScWl3ZUE0ZUV2SW1Dd0RlOHJSRVE5c2N1ZUFXQ29jb3VMZUVZ?=
 =?utf-8?B?ckF5VjdUalVPaE1pUU1wTFl0R2d6eVdYZEIwV2d2L1hQNUc1b1ZjeWQ5aWhr?=
 =?utf-8?B?R0czS3NZLys2VDVsWGNUYUNyNjhid3BHUUVZVlZpa0FYMGMyK3E0YWNlc0pq?=
 =?utf-8?B?cERHbkVIQXBlNUtiTXFZQ3ExWFRrWjVxM0JNVXVORGlIb25XZ3c0T3ZoNVJi?=
 =?utf-8?B?SUZWWHRCVlJVSGpWMEpUcnRNZzdUT2x4M0hJUVhHcURKSzd0dWpEVG5SbjBz?=
 =?utf-8?B?akhnSHBSWjc3ZzMvYjBqTXgvV3BqOHVDc1JXcG9iKzlJWEdlUWFWU2FEZkNj?=
 =?utf-8?Q?fsvhhA?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZklkcWcxTXlVd1h2ekFzVFRtdnlabys2NTdROU0rd0U4ZTRFN2hCVjg3c3hO?=
 =?utf-8?B?Ynh2djVOb2x6YU4rbmFqZnRsWnpwQWNYYVRaSFVHWnhlbkZwUXBYR2JkWGZD?=
 =?utf-8?B?ZlpVelVmZjVxNE5MN3Q0SEMzRUpqTGlrOFpHRkIvNEhnRm9NTm92OStlNTVC?=
 =?utf-8?B?bDRSM0Z6c1h6YmlyL3NoYVVISFlpRzAzTzZKS29CUEdLN0xST1VzaTRvL1dv?=
 =?utf-8?B?K0MvUzlYUkRoTTdsWngxTlJPTnZUMlhaZERwUVNJRGpTdTErRFNiZG50emFj?=
 =?utf-8?B?YjVPczQ5NjhFQlovQ0ZyRWRtS2wvNkdEcWJQdVdDZHBCM2h4VmVWWnI1TVF1?=
 =?utf-8?B?RFpUcVc4WGZOQjhFdk5VZ1hPL1c2TUM3TmdsZEFOOXJKQWJTUzV2ZnpOTVJ3?=
 =?utf-8?B?TVl4VnVmRW9EdTVRdlRUYW5ER1hKelZJd1dlL1l5bHhJMUowdVBYVmNlV1pm?=
 =?utf-8?B?RW9NU09JMlZPVU8wZFg1MytXNE9sSHU4Z2VUNk80TmxSOWNsQmNxSmoxV1NH?=
 =?utf-8?B?WGFMUFdMK0NONlBXSy9vZVRlZk15WGNEYVJpNWdScnpVaTFyUHBUT050NlN5?=
 =?utf-8?B?Z3kwSDU3MjhKYkVicnNRS0VQWTRwZmRudVpENWdRVE9kWER2RkRoaXdRRVlY?=
 =?utf-8?B?Z0tMK2NYa0h3ZUJaT2NNYUV5eXphaGRaakI2YnpsQ1lHdmZwT2dJQkJ6Qjlh?=
 =?utf-8?B?L05VOSt3OXVPS0sxRVhOeVdSK2tUcDREUjVIVUhETERCdmFKYmNneW55STg4?=
 =?utf-8?B?WlM1WUo4TFpycTlYS0RnZGRzdWFvZm8zNHBwcW9qdTJKTDc1Lzl2T2djekRo?=
 =?utf-8?B?aU02d3l2T2hLYUZaOTZIM3c3aEpqQyttV0R6NGRZY3cvbUliS3hBbTUwUnox?=
 =?utf-8?B?QXlZMmZxSXR6QW13bHZ1UWE3Tm5QdDV5SWl6VmFCbWlpYkdKZ25zc2RQRHc2?=
 =?utf-8?B?aUdaciswblNuMmhLcXNUKzZhNzA3dnNiUHlEZVIrNXRNc3Y1NEFWazhpTzRT?=
 =?utf-8?B?SHp5cnI0TS9ZaHcxd2ZOS2t4eVpnd0I3aFJnZk4wTHNaR3VkSHd3ZHJRb1gw?=
 =?utf-8?B?N3Z3L2liZERvQ0FvdUM1ejdOTmhKNzh5Uk5scVFaOEJmdGFBQ0hmSGN0Qkly?=
 =?utf-8?B?Q3RnS1pOYmVGT3REbDJBTG9CTnJOdnVHSGI2VXR3bFNsNm9IR2RyUmZTMGJl?=
 =?utf-8?B?NElMV0NaR2YyVnM5Rnd3R1hoRVNWeVRTSWJOY3E2bTdCbUwvKzRZOTk5TFZ3?=
 =?utf-8?B?Vm93N25Jem80NGlCTXVSdUZtWTNhM3hMa3R2SitkekNPdGt5V2VvRER3dWN1?=
 =?utf-8?B?bXZQanNRNHV3dGE5K2crWjVWSjRESW03YTFnVnRxalFIeHBTQUFqTnBTZHo5?=
 =?utf-8?B?N1dYTmlld0ZoU1hhSmVYckRVQ2FpY2NTQ200KzIrZVVubFNHMHRRYTc4ZUR0?=
 =?utf-8?B?ZG5pY20zczRacHJMQk01U05FV3lKZEJYSXE5cGY4QzJQd1RqS2VwV2xRYUw5?=
 =?utf-8?B?YWpqK2tpVGE0Y2FJbDFtU0YxaUE5cTdCZmllVG1zbVFoV2o4YnprSlI1bFov?=
 =?utf-8?B?RU5ydndtLzkvbnZnVUdNRU5UemRDalNOQStDakFQK0V4QS9IMEF5YnlTOUQv?=
 =?utf-8?B?WGVrYTZHK1VQV3dQd0lXMGlYd3Rmd1ErWW1la283clhDZXE2bk9DMnk4ZnFo?=
 =?utf-8?B?TXZDZ1RvOUk1Z0VyMzViWDFjbjlZd054ZXIvRjllQWVVSVU4SjJVcjhpVk8y?=
 =?utf-8?B?TTNBK09lYmpnbzhDTlZvQUJ1Y3BMcENYcDJmRjBHd3dDRnpaekNCVTBNd3Jn?=
 =?utf-8?B?Y2d5Vk16bkQyTHNtOVFOOTZqNldNQWk2SHFDZVFPdDRheEdmTVoyNTNOV2pI?=
 =?utf-8?B?YXR2RVRnOHk1VGxJMjFlSmdEOE1PWGJqUTQrdE5WK2FaT3kvdlF5RmhLYlVt?=
 =?utf-8?B?bzc5TUFmRlM1V3pPRmhjc3Z3aGE5ZTYyNkNvdDRGNWozV0RiS0VNQUVrYXRD?=
 =?utf-8?B?Ukt1TTgrdWxncUVQK3NEcHU2TTRRV0NnYnZ3bFhPUnlQeFBkUVR2aGltL2I1?=
 =?utf-8?B?eCtubVdVN1g1cHVUMEp2N2JORlRlR21yWEhPZjNNb1VEWW1qa0dwaUF4TTJK?=
 =?utf-8?Q?/QAkeNAzVH28xHbVZfZeLAZ1G?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c66d46-3534-4e23-a612-08de1be8edd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 21:27:16.9930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +gYWvX/tK0w0i5T+9CnnYyDdFDoHukiFFb5EIG9uN7fGU0bG05nYzXtpLzEAUw9f6R43toWnK//F6sEoB/qyPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7292
X-OriginatorOrg: intel.com

PiA+SGkgU2FzaGEsDQo+ID4NCj4gPkp1c3QgYSByZW1pbmRlciB0aGF0IHRoaXMgcGF0Y2ggc2hv
dWxkIGJlIGRyb3BwZWQgZnJvbSBzdGFibGUga2VybmVsDQo+ID50b28gKGp1c3QgaW4gY2FzZSB5
b3UgbWlzc2VkLCBzaW5jZSBJIGRpZG4ndCBnZXQgYW55IGZ1cnRoZXIgbm90aWNlKS4NCj4gDQo+
IE5vdyBkcm9wcGVkLCB0aGFua3MhDQoNClRoYW5rcyENCg0K

