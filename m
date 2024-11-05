Return-Path: <kvm+bounces-30739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E109BCFCD
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 15:55:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C1C31F2104D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 14:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CA31DD0CB;
	Tue,  5 Nov 2024 14:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Dp9XhdFn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2071.outbound.protection.outlook.com [40.107.102.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9DB1DC185;
	Tue,  5 Nov 2024 14:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730818478; cv=fail; b=H2kfPpKIyDxT6ReIyAYVPKXNkmX52f3noMOfALIMIXoCTevJ/I4syTO013JG69I/ZlQVagLRPpZL0eDCgHZyCfU3M9v9cio0+BgyfbEzHTG+bE3UhXau+LHSuM+rnNSYakC9Q9ZnrU1yAe8P913UwLon/9io+S9qt0L4Y6pgjR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730818478; c=relaxed/simple;
	bh=+P9eEhYjJu0MO6GcTKeYxlSwUQtrTzkX2+vMAr+HkfQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=srED5cwJYBpCsKDi9zRgbnO1D/Px6g/E0OT0o7180UFbFTPSTwY/QCE2tMHCPW4RpIuWFPi6khFu9NsBrxUZqBM0Pf1PHT0TEd1oPeM5AhhKAx//aXzAboAi4akTAYCiYWlv5nXPQY0Pz5OxrU8Vs0aZfWsAVQGRy7HQikFQL4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Dp9XhdFn; arc=fail smtp.client-ip=40.107.102.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LKJ04RH49hZDKdHn3k40ysNEQ2XH4JDKNtlgSuUS3Tk2MsX8QRkYjiy2f9TaKx+QIsWTwLN/QNQf0BGpeZ2/dfpfWYP71OP9F84aQomCMMd4p2I0qwkzrBQjhVq5AaCF0cnLEJ2IkhmqzlMOEqrcffmIk/+0mm6zsx7QT7b4e5oe+UkluNq52pBrfy6wdQ+T6FW2YGAUvDy+gKU0DYR5oqHDv3ZWV1C7vam6bdBKHb400Aj+a/0EWNX2iKe6p2JuB5urxxBedEj02RqqS1mbHu2taHW6uCp0db2/+TmGCT7dsMpsv6BKM33lihhKDHuzYpKYD/kUH9TMo66Phc0aZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+P9eEhYjJu0MO6GcTKeYxlSwUQtrTzkX2+vMAr+HkfQ=;
 b=YriugaMHh2Ib9Tv3GsaZYk4/aHE56x4wxMH0itQX+B9S+GfHd6o3ytkLq/DVhz3teqsvTpTVZYA+kLW6qP59ob4wYdK35k4ipjTaM1NUpPqKYv7oqWAAtkXt0t6hkAFxHjzbWvb6HpXocz2/oUYb2613+GyoFDBAx5+vORqMDbD4Jdag4SXQxjwnoIsG9uT8nCRHnXGaAl5wPmR6gnWCwmInrOdrRMgVrnwmYYirHzlEXGBtj4J/Ut/RF5IkuabBWe+DNYDSPuMFnWL919Ea0cwdFmBQCjN79zlVbhM6wMoapw4Glzu7NvDXaEMD8QD81Z9/Hb2FNkxz1P9c8AZ6fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+P9eEhYjJu0MO6GcTKeYxlSwUQtrTzkX2+vMAr+HkfQ=;
 b=Dp9XhdFnq/fKsZdOwUw0R3luxkmxOg6LKFkTx+8UO378WhEAQkmexWYSfCfqtcD8scIZS33h5KQ1G8CghfYvbTxcWG2c60lw7QQSEIcU3GspecbKpg/icGLBHXxJOVSVwE/Q23fQgPqKzj9CYpxXQfO7pWhNavyaTN4GjF3Hu24=
Received: from LV3PR12MB9265.namprd12.prod.outlook.com (2603:10b6:408:215::14)
 by IA1PR12MB6211.namprd12.prod.outlook.com (2603:10b6:208:3e5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 14:54:32 +0000
Received: from LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427]) by LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427%5]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 14:54:31 +0000
From: "Kaplan, David" <David.Kaplan@amd.com>
To: "Shah, Amit" <Amit.Shah@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dave.hansen@intel.com" <dave.hansen@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "x86@kernel.org"
	<x86@kernel.org>
CC: "corbet@lwn.net" <corbet@lwn.net>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "kai.huang@intel.com" <kai.huang@intel.com>,
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
	"jpoimboe@kernel.org" <jpoimboe@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "daniel.sneddon@linux.intel.com"
	<daniel.sneddon@linux.intel.com>, "Lendacky, Thomas"
	<Thomas.Lendacky@amd.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>, Andrew Cooper
	<andrew.cooper3@citrix.com>
Subject: RE: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
Thread-Topic: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
Thread-Index:
 AQHbK6w5jGIx4DKfg0GVPws0TMnSdbKhfTCAgAVa9ICAAHjTAIAAAJsAgAADwQCAAA+AAIAABmMAgAEbe4CAAEXTEA==
Date: Tue, 5 Nov 2024 14:54:31 +0000
Message-ID:
 <LV3PR12MB9265F0B446D1F6070431830494522@LV3PR12MB9265.namprd12.prod.outlook.com>
References: <20241031153925.36216-1-amit@kernel.org>
	 <20241031153925.36216-2-amit@kernel.org>
	 <05c12dec-3f39-4811-8e15-82cfd229b66a@intel.com>
	 <4b23d73d450d284bbefc4f23d8a7f0798517e24e.camel@amd.com>
	 <bb90dce4-8963-476a-900b-40c3c00d8aac@intel.com>
	 <b79c02aab50080cc8bee132eb5a0b12c42c4be06.camel@amd.com>
	 <53c918b4-2e03-4f68-b3f3-d18f62d5805c@intel.com>
	 <3ac6da4a8586014925057a413ce46407b9699fa9.camel@amd.com>
	 <62063466-69bc-4eca-9f22-492c70b02250@intel.com>
 <975a74f19f9c8788e5abe99d37ca2b7697b55a23.camel@amd.com>
In-Reply-To: <975a74f19f9c8788e5abe99d37ca2b7697b55a23.camel@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ActionId=52650560-bcfb-4be0-93f7-c9ea5ecaa81e;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=0;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=true;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2024-11-05T14:49:35Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9265:EE_|IA1PR12MB6211:EE_
x-ms-office365-filtering-correlation-id: 3d16d5a0-e5f1-419c-1c77-08dcfda9c19b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VUpuSXVDYy9wU2U4eFBvRDY0cGg1K3FLV2NKY3V1dlpUamk4VU5GaFIvOXRr?=
 =?utf-8?B?WGo5aGxqQlBvNFFjYXhacGNsOUh0MnhYdjRVMFgwZEJ2aHJBZzVQaDNFOGFI?=
 =?utf-8?B?VlgwV3YzMGpXQmJuUElwNHVTVlVyMXEraFpIc2pvaUN1VitJb1hhRENHWmV5?=
 =?utf-8?B?K3ZPVDFzaW56c0VpQmVlQzFJME9vdFV4U0VNM2VrVGVvNVlmVmwwMFlubDFT?=
 =?utf-8?B?bG01bGxMYnZaYzJXdXRFYXFhV0VxNXJYYXUwbmtXWmN6TVV6V0Q3amQ5V0NE?=
 =?utf-8?B?SUhaV21UM3FNZTlZR1N6OFVmMjJiTGd4TUtudHdsTmdvZTZiQUNGWEF2c1pV?=
 =?utf-8?B?NHpYYVc5SXFBTFZ1UFM3ZTZIL0gvSDFlK1k3L2E5eGk5c2FXemFBa3NTd0k3?=
 =?utf-8?B?aEllbmszRWdqQVpZUEZESmViSkM1STY5Yzd6SE9WT3Y3eHQzS0xJOHJLczdp?=
 =?utf-8?B?bG4rOFppZSsxd2RoMW0yaHFGbTdyMlFNbktLOXdQM1R1TFlsV21IYnpyUERM?=
 =?utf-8?B?SnhDelNhRGFCRFpOaExQY2NsYnA3R3R1SjhFMUJBUFF6MDd4ditPakQySGY1?=
 =?utf-8?B?NG9sWVBXa2d6b0dZalJlaWhieGc3RlkwREFhZitGaS93enp1cUNmbGV5d2kr?=
 =?utf-8?B?UFhZUDFPK0JXTHFpcExTUGlRKzJxVDMyQ3R5U2tzMXhwcWVzVTRxTWx3TXN5?=
 =?utf-8?B?SHVZYUhiUVBQeE8xd05wY0FhVHZ4UWZzbE1DQStDMElIRDRUaTJjRk1WQWlL?=
 =?utf-8?B?MU9lQXBGaEE3NXcvZU1hTHRFRWdXMW9OK0RUYWJOQUp6VnVWR0hsVWR0R3Ji?=
 =?utf-8?B?KzdOcEVZSnpPL0dzNUZJeWtDQWFQMGFaNUpqOFJVbm8rd2VrTUxPaytnYnhM?=
 =?utf-8?B?amtncGRLTFBoYVlYQmV4SmFhSWFPRklqeTRNYVJNU1dSeElXcVVkSjR3Q3oy?=
 =?utf-8?B?SmgzaGNMRC9pVW5sekJ5UVczNHhKNERaTmczcTZOb0FMcmtFeC9YYXZRNFBm?=
 =?utf-8?B?Z3h2U3FsSG5lRk83SWZTTGNmMHBPdTN1WXByT2pJSlhyeTVwaTVxS204eWY0?=
 =?utf-8?B?RmVxNWVoTEVXdlVkMSs0RUIzY0pIbFJ5aU5UcnRpR0ppcGVESDI2ZW5OZXB0?=
 =?utf-8?B?MGVGeGNyY1pWWXBxZmVBUmFkQVNzV3IyWW40bC92SDhpVzZBU3ZmOUs3TTA2?=
 =?utf-8?B?aHRzUFF5Yi82Y3BURWoyM0NISG9kYUhObzVmbXRiL3l4azBpajVDRzZ4Z1Jo?=
 =?utf-8?B?UDQ2NUZ2MTJQU3FzUWhYS3NaSVRJUmtuTHIxaTNuZG9RQlVTS0J4WE12MTNa?=
 =?utf-8?B?Qi9MaUlaRVMyMXdpb0J4cTBxV2tyMGVFZkVOUG1RcVN4SzlIUlZpRU1QL3Fy?=
 =?utf-8?B?SGdrek9QYmlmOXU1bjVyS1FVYXFMUlZxTE9RSEZycUdacXBRQVJhWFYvdkVT?=
 =?utf-8?B?aE9ZL1BRbmh0cHdxdXdSTTVLb1g2WUwwakoxUzh5cDROa2V0MG16SVNqWVVs?=
 =?utf-8?B?NVZEb2p2K2RYbjd6VUZCeFpTM0ZYc3pGUXNVSkh1VXlRNllvMzYvWFFGUDZr?=
 =?utf-8?B?ak9iT0FlWDRjTWhGWlVmN0pqUHcvUFpSWFFaakZiTjlIOHgwdCtsYm1IWmlq?=
 =?utf-8?B?bjZESkF6QVFQNFE2d01veFlnanNGcVY3bXU3VC9VdHB5VVFNYXpaTjJhYVpy?=
 =?utf-8?B?M2tUaERQc21OYW1JaDF3d2dCc1R0RWtpanM0eVFvTXFQaXJ6RDlBcU83Qm4x?=
 =?utf-8?Q?vftr/vvCWlCdkXOPCsmB7sj+/Y1BNSe102KbjQ/?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9265.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SjdMaDl6cmI3ZXkxWU1lV25JZ0FqWUR5VmdIOGh2enUzbjBnMG15MlZ0c0FS?=
 =?utf-8?B?UmJoeHlvd1BKSGZhTGp0ZlB4UkhacEg0SEY4cFljYm4vdUZHcncxdGdjR2Fw?=
 =?utf-8?B?YkdmSHNMa3pkZjZYNmtwVmFUMFdjNWh2R2tHbjUvbW1ubmMvTG81V2JrZmFH?=
 =?utf-8?B?U2lHdncwdTFtSVFXUzd5NTRxTDEybkpMTHp4VlNBUTBvajladHBTQmJmTWdR?=
 =?utf-8?B?dGJyS1FjRnQ1VGF3RElPVCtjYjYzWjNlRERjOFM3M3locmJvd2N4azI2NWJo?=
 =?utf-8?B?TXZMSm9MbUxwRTZBeXh1eUJSTTVrMThUc3NxWnRWbzRaSUI5SlR5OHpNTkE1?=
 =?utf-8?B?WnMrdG0weCtpcWFzQnlmU1dxUFBTV1ZTWHprVDNyL2VLR3gwa1h3VGJVUmd1?=
 =?utf-8?B?L2d3Nm0zRXQ3Q3FUUzgxV2xIWFZXUXg2cUFWK3YvazN2bFpOWUtReTdsZkFq?=
 =?utf-8?B?NGpYemNNVjJOSlR6aDFNbDBXS1FHa2kraU8wdnhNVWhyOWVLb1JRTWpEZEdV?=
 =?utf-8?B?MlRGam8zUVNPdE9JUlhlUnpIcjA4OVpyQVlQS2FRMGZHQTBjSkxHR0wyTU5T?=
 =?utf-8?B?amhLbzNRTG96dDdwbmpJUzYrTzdSdnYrOXJVdjhMRFB3ZStTSzAyMVljTDlG?=
 =?utf-8?B?M1VJTy9YZ1BBNFdtVUZqYkI0RytqbFkyYUkvcGZTTW9DcGs1UUJmeVhSdW1V?=
 =?utf-8?B?Rmh4cVo2aHNLMWRMbDZjRnlWQjh5RFJRQ0lZVUNIUWhmcjVOY3pZZ0g1cVEw?=
 =?utf-8?B?NU5Ub0k5ck9EMCtBUmU3RlJrWjNWZm4yVE1TUUFVRFVlRFRMdTZENzI2bzVN?=
 =?utf-8?B?dEp2OURnSDhXazM4Qjl5NW5HRllONG5oK2tNZjUzQ3lmRFI2anFtZ0dZdXR2?=
 =?utf-8?B?ZXJuS2VieXZtY1Awd0ZLOVJHS1NsY2x6UjY2Z09TdXI4M3FNUEZYTUtHekVQ?=
 =?utf-8?B?R0J4VUpCUUhkS0hTQlBlTDZFNVBncWdvejkyMUJGZWljeGEvU3oxS1FTRmRC?=
 =?utf-8?B?OFdMZkY4cTc0RlBvS2FwVWpiYXBobkVWaGdTVjdhVG56TjRDVVB2cDZhVnd5?=
 =?utf-8?B?cUM1RXFLMi9Fd0xuTGI0dUJsT2FkbllXc3A5enhhQkZYbURKRUNCRTNETTFC?=
 =?utf-8?B?VGRBclRwdWp6RE1oVHo5ZzVpcU5aeEd1cnhvNHo4VWYxKzlIK0ppalJYeWd6?=
 =?utf-8?B?ckhaYStLdmFnK0RGa0kxOWY4Tng5alpCVXJIeDhxRjVuRElhaXIvUHBUZkN0?=
 =?utf-8?B?cC8xS3dLQXZrTjJRWTM5b1lzRFVGbm1kMURJa3paVnY5VVFWQjlJa0pLSDRv?=
 =?utf-8?B?UkVvd09JOWJkS2tFSk90Z0hsc3k2VGJhckh5dHNGekxJY2tSeERkNjBBNTBy?=
 =?utf-8?B?TWpJYkZPMjNRSVI5ejR1cTBFZUdXWVo3RGtHdXJxT1lWWUV1OTUzTEh4R0Ry?=
 =?utf-8?B?RmJmYjJCS1Ryb1pqd3lIVHdKVXNsWFAzRlBRRzJIeUNZL1VGdFduTDFua3Zy?=
 =?utf-8?B?eFFUTGF6UllkNk9zUDVPMXBjZFU4R1B5emhSc29KUWhUQ3lNK280bGV3QkMv?=
 =?utf-8?B?MmIzSTRtcFRxdnp0aGFCWjBUTFBMMFY1UDFVZUtodFNoVTJhMDFHeVM5cndm?=
 =?utf-8?B?azJ3eUUyakhwQkkvRGFVb1pxbWpsSC8wZitkdWZKRHNSdktEWWR6dzI4YVBu?=
 =?utf-8?B?MC9haXlhV2NXaFlncFNJaWYwTDIrZmlkR3lEV3BmSmVScGl3M1dSajdaRlh4?=
 =?utf-8?B?NGdWcWIwOC9KT2tYUUFnSkVjaXdETlVpeHgxSThOMDU4UVhIcjl2MUxGZGYv?=
 =?utf-8?B?V3kxZzAxV09adXEvbFRaQW15VFBadzBuTFBYZmJkY0JHa01mMHdmTlRaV1pq?=
 =?utf-8?B?QkhodjVnRGdRR3J0SiszYXozVWt5c0NiMWFhM0pjVVpzdUZRQnJZbm9nYU1S?=
 =?utf-8?B?WVZDTzk4K0t2TWdNTUtKZk9iemVRSlFlVk8rU3lmQ1dDNm1PS3JVUWpHWXor?=
 =?utf-8?B?RldEOW82ajBaek11Z2t1dVl3TEhKT2xyaTJtZGN3K09xdWhCSXVYdkZCTXRm?=
 =?utf-8?B?YzVaOHhCVGFuUGVSQ0VIZUJFTzlWTUNlWFdkNUpyWmFNMlk2Qm95ejh3TFl2?=
 =?utf-8?Q?WYfI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9265.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d16d5a0-e5f1-419c-1c77-08dcfda9c19b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2024 14:54:31.8682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2/uNmP0IytkZYpPp5tA1/g9QqPxneG9Pa6bblNbx+/kh7qGk5FRlRlM2CK2VR6Yv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6211

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEFNRCBJbnRlcm5hbCBEaXN0cmlidXRpb24gT25seV0N
Cg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTaGFoLCBBbWl0IDxBbWl0
LlNoYWhAYW1kLmNvbT4NCj4gU2VudDogVHVlc2RheSwgTm92ZW1iZXIgNSwgMjAyNCA0OjQwIEFN
DQo+IFRvOiBrdm1Admdlci5rZXJuZWwub3JnOyBkYXZlLmhhbnNlbkBpbnRlbC5jb207IGxpbnV4
LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWRvY0B2Z2VyLmtlcm5lbC5vcmc7IHg4
NkBrZXJuZWwub3JnDQo+IENjOiBjb3JiZXRAbHduLm5ldDsgYm9yaXMub3N0cm92c2t5QG9yYWNs
ZS5jb207IGthaS5odWFuZ0BpbnRlbC5jb207DQo+IHBhd2FuLmt1bWFyLmd1cHRhQGxpbnV4Lmlu
dGVsLmNvbTsganBvaW1ib2VAa2VybmVsLm9yZzsNCj4gZGF2ZS5oYW5zZW5AbGludXguaW50ZWwu
Y29tOyBkYW5pZWwuc25lZGRvbkBsaW51eC5pbnRlbC5jb207IExlbmRhY2t5LCBUaG9tYXMNCj4g
PFRob21hcy5MZW5kYWNreUBhbWQuY29tPjsgc2VhbmpjQGdvb2dsZS5jb207IG1pbmdvQHJlZGhh
dC5jb207DQo+IHBib256aW5pQHJlZGhhdC5jb207IHRnbHhAbGludXRyb25peC5kZTsgTW9nZXIs
IEJhYnUgPEJhYnUuTW9nZXJAYW1kLmNvbT47DQo+IERhczEsIFNhbmRpcGFuIDxTYW5kaXBhbi5E
YXNAYW1kLmNvbT47IGhwYUB6eXRvci5jb207DQo+IHBldGVyekBpbmZyYWRlYWQub3JnOyBicEBh
bGllbjguZGU7IEthcGxhbiwgRGF2aWQgPERhdmlkLkthcGxhbkBhbWQuY29tPg0KPiBTdWJqZWN0
OiBSZTogW1BBVENIIDEvMl0geDg2OiBjcHUvYnVnczogYWRkIHN1cHBvcnQgZm9yIEFNRCBFUkFQ
UyBmZWF0dXJlDQo+DQo+IE9uIE1vbiwgMjAyNC0xMS0wNCBhdCAwOTo0NSAtMDgwMCwgRGF2ZSBI
YW5zZW4gd3JvdGU6DQo+ID4gT24gMTEvNC8yNCAwOToyMiwgU2hhaCwgQW1pdCB3cm90ZToNCj4g
PiA+ID4gSSB0aGluayB5b3UncmUgd3JvbmcuICBXZSBjYW4ndCBkZXBlbmQgb24gRVJBUFMgZm9y
IHRoaXMuICBMaW51eA0KPiA+ID4gPiBkb2Vzbid0IGZsdXNoIHRoZSBUTEIgb24gY29udGV4dCBz
d2l0Y2hlcyB3aGVuIFBDSURzIGFyZSBpbiBwbGF5Lg0KPiA+ID4gPiBUaHVzLCBFUkFQUyB3b24n
dCBmbHVzaCB0aGUgUlNCIGFuZCB3aWxsIGxlYXZlIGJhZCBzdGF0ZSBpbiB0aGVyZQ0KPiA+ID4g
PiBhbmQgd2lsbCBsZWF2ZSB0aGUgc3lzdGVtIHZ1bG5lcmFibGUuDQo+ID4gPiA+DQo+ID4gPiA+
IE9yIHdoYXQgYW0gSSBtaXNzaW5nPw0KPiA+ID4gSSBqdXN0IHJlY2VpdmVkIGNvbmZpcm1hdGlv
biBmcm9tIG91ciBoYXJkd2FyZSBlbmdpbmVlcnMgb24gdGhpcw0KPiA+ID4gdG9vOg0KPiA+ID4N
Cj4gPiA+IDEuIHRoZSBSU0IgaXMgZmx1c2hlZCB3aGVuIENSMyBpcyB1cGRhdGVkIDIuIHRoZSBS
U0IgaXMgZmx1c2hlZCB3aGVuDQo+ID4gPiBJTlZQQ0lEIGlzIGlzc3VlZCAoZXhjZXB0IHR5cGUg
MCAtIHNpbmdsZSBhZGRyZXNzKS4NCj4gPiA+DQo+ID4gPiBJIGRpZG4ndCBtZW50aW9uIDEuIHNv
IGZhciwgd2hpY2ggbGVkIHRvIHlvdXIgcXVlc3Rpb24sIHJpZ2h0Pw0KPiA+DQo+ID4gTm90IG9u
bHkgZGlkIHlvdSBub3QgbWVudGlvbiBpdCwgeW91IHNhaWQgc29tZXRoaW5nIF9jb21wbGV0ZWx5
Xw0KPiA+IGRpZmZlcmVudC4gIFNvLCB3aGVyZSB0aGUgZG9jdW1lbnRhdGlvbiBmb3IgdGhpcyB0
aGluZz8gIEkgZHVnIHRocm91Z2gNCj4gPiB0aGUgNTcyMzAgLnppcCBmaWxlIGFuZCBJIHNlZSB0
aGUgQ1BVSUQgYml0Og0KPiA+DQo+ID4gICAgIDI0IEVSQVBTLiBSZWFkLW9ubHkuIFJlc2V0OiAx
LiBJbmRpY2F0ZXMgc3VwcG9ydCBmb3IgZW5oYW5jZWQNCj4gPiAgICAgICAgICAgICAgIHJldHVy
biBhZGRyZXNzIHByZWRpY3RvciBzZWN1cml0eS4NCj4gPg0KPiA+IGJ1dCBub3RoaW5nIHRlbGxp
bmcgdXMgaG93IGl0IHdvcmtzLg0KPg0KPiBJJ20gZXhwZWN0aW5nIHRoZSBBUE0gdXBkYXRlIGNv
bWUgb3V0IHNvb24sIGJ1dCBJIGhhdmUgcHV0IHRvZ2V0aGVyDQo+DQo+IGh0dHBzOi8vYW1pdHNo
YWgubmV0LzIwMjQvMTEvZXJhcHMtcmVkdWNlcy1zb2Z0d2FyZS10YXgtZm9yLWhhcmR3YXJlLWJ1
Z3MvDQo+DQo+IGJhc2VkIG9uIGluZm9ybWF0aW9uIEkgaGF2ZS4gIEkgdGhpbmsgaXQncyBtb3N0
bHkgY29uc2lzdGVudCB3aXRoIHdoYXQgSSd2ZSBzYWlkIHNvIGZhciAtDQo+IHdpdGggdGhlIGV4
Y2VwdGlvbiBvZiB0aGUgbW92LUNSMyBmbHVzaCBvbmx5IGNvbmZpcm1lZCB5ZXN0ZXJkYXkuDQo+
DQo+ID4gPiBEb2VzIHRoaXMgbm93IGNvdmVyIGFsbCB0aGUgY2FzZXM/DQo+ID4NCj4gPiBOb3Bl
LCBpdCdzIHdvcnNlIHRoYW4gSSB0aG91Z2h0LiAgTG9vayBhdDoNCj4gPg0KPiA+ID4gU1lNX0ZV
TkNfU1RBUlQoX19zd2l0Y2hfdG9fYXNtKQ0KPiA+IC4uLg0KPiA+ID4gICAgICAgICBGSUxMX1JF
VFVSTl9CVUZGRVIgJXIxMiwgUlNCX0NMRUFSX0xPT1BTLA0KPiA+ID4gWDg2X0ZFQVRVUkVfUlNC
X0NUWFNXDQo+ID4NCj4gPiB3aGljaCBkb2VzIHRoZSBSU0IgZmlsbCBhdCB0aGUgc2FtZSB0aW1l
IGl0IHN3aXRjaGVzIFJTUC4NCj4gPg0KPiA+IFNvIHdlIGZlZWwgdGhlIG5lZWQgdG8gZmx1c2gg
dGhlIFJTQiBvbiAqQUxMKiB0YXNrIHN3aXRjaGVzLiAgVGhhdA0KPiA+IGluY2x1ZGVzIHN3aXRj
aGVzIGJldHdlZW4gdGhyZWFkcyBpbiBhIHByb2Nlc3MgKkFORCogc3dpdGNoZXMgb3ZlciB0bw0K
PiA+IGtlcm5lbCB0aHJlYWRzIGZyb20gdXNlciBvbmVzLg0KPg0KPiAoc2luY2UgdGhlc2UgY2Fz
ZXMgYXJlIHRoZSBzYW1lIGFzIHRob3NlIGxpc3RlZCBiZWxvdywgSSdsbCBvbmx5IHJlcGx5IGlu
IG9uZSBwbGFjZSkNCj4NCj4gPiBTbywgSSdsbCBmbGlwIHRoaXMgYmFjayBhcm91bmQuICBUb2Rh
eSwgWDg2X0ZFQVRVUkVfUlNCX0NUWFNXIHphcHMgdGhlDQo+ID4gUlNCIHdoZW5ldmVyIFJTUCBp
cyB1cGRhdGVkIHRvIGEgbmV3IHRhc2sgc3RhY2suICBQbGVhc2UgY29udmluY2UgbWUNCj4gPiB0
aGF0IEVSQVBTIHByb3ZpZGVzIHN1cGVyaW9yIGNvdmVyYWdlIG9yIGlzIHVubmVjZXNzYXJ5IGlu
IGFsbCB0aGUNCj4gPiBwb3NzaWJsZSBjb21iaW5hdGlvbnMgc3dpdGNoaW5nIGJldHdlZW46DQo+
ID4NCj4gPiAgICAgZGlmZmVyZW50IHRocmVhZCwgc2FtZSBtbQ0KPg0KPiBUaGlzIGNhc2UgaXMg
dGhlIHNhbWUgdXNlcnNwYWNlIHByb2Nlc3Mgd2l0aCB2YWxpZCBhZGRyZXNzZXMgaW4gdGhlIFJT
QiBmb3IgdGhhdA0KPiBwcm9jZXNzLiAgQW4gaW52YWxpZCBzcGVjdWxhdGlvbiBpc24ndCBzZWN1
cml0eSBzZW5zaXRpdmUsIGp1c3QgYSBtaXNwcmVkaWN0aW9uIHRoYXQNCj4gd29uJ3QgYmUgcmV0
aXJlZC4gIFNvIHdlIGFyZSBnb29kIGhlcmUuDQoNCkkgdGhpbmsgaXQncyBtb3JlIGFjY3VyYXRl
IHRvIHNheSB0aGF0IHRoZSBhZGRyZXNzZXMgaW4gdGhlIFJTQiBtYXkgYmUgaW5jb3JyZWN0IGZv
ciB0aGUgbmV3IHRocmVhZCwgYnV0IHRoZXkncmUgc3RpbGwgdmFsaWQgcmV0dXJuIHNpdGVzIHNp
bmNlIGl0J3MgdGhlIHNhbWUgbW0uICBUaGVyZSBhcmUgb3RoZXIgZXhpc3RpbmcgY2FzZXMgKHN1
Y2ggYXMgZGVlcCBjYWxsIHRyZWVzKSB3aGVyZSBSU0IgcHJlZGljdGlvbnMgZm9yIGEgdGhyZWFk
IG1heSBiZSBpbmNvcnJlY3QgYnV0IGFyZSBzdGlsbCB0byB2YWxpZCByZXR1cm4gc2l0ZXMuDQoN
CldlIGNvdWxkIHN0aWxsIHRyaWdnZXIgYSBSU0IgZmx1c2ggaGVyZSBJIHN1cHBvc2UsIGJ1dCBJ
IHRoaW5rIHRoZXJlJ3MgYW4gYXJndW1lbnQgaXQgaXMgdW5uZWNlc3NhcnkuDQoNCi0tRGF2aWQg
S2FwbGFuDQo=

