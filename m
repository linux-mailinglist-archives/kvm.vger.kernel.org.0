Return-Path: <kvm+bounces-23686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB96C94CD6C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 11:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FD481F218DE
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 09:34:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC921917DD;
	Fri,  9 Aug 2024 09:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OXNyOHWP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2077.outbound.protection.outlook.com [40.107.95.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E70116C698;
	Fri,  9 Aug 2024 09:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723196089; cv=fail; b=XSDSItunQl+c0YoHPMW+vBqQS6O0+uCFOpWn5SpWNV+1otyiE0Ct09cl4UfD2vAcdPDMp+9PCvfKHdlZuPgaWEwRGcTpKgEeugIcpXaXqk1YZ4IawluLItphwpFlqN73Axc5zjZEdJa82LMhKBvL5Dg6I0Dp5HQWpAkGUHsbv80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723196089; c=relaxed/simple;
	bh=+UUF7EStl0bKrizdavAejteeK+yPct8bWQ7fS8HaJGQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EANxVRce0tFzypmdJVLf9YZgnvzbGBvKmwx7SRVSI0E0VG7bPcYI3L/wmXw+a5EuRHZhzErZ/Wz+VQA3kJL04suMvEwkhzXpeZQq7LO1R3BCCj0AFhhQjOkZPNVillb4yfs84jFRA14jeliUaGsdy3VbfyCYIkDDaFx8uXF0ePs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OXNyOHWP; arc=fail smtp.client-ip=40.107.95.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JwiLnRICoFxRabQcMKlBfAUh6Q89wTn7WC22i9fuPZmPUzJ2sddjhGVM75OPGEGr9odLaqTkLVGNhTf5/Vl4+KFEMAwDMj0ZV27gVbR13s+DmKfdNnH/cbU+JXzytmC0pC+n5PpEM57x2Aw2cu2gq0thnvzttwnqUHKkwara7SLXA3KF4equ6mnIIO/TYws6ZIaOQO+OVwLy7sG41Gf9VeOU077a4safiyXDM5LsmBzcYY3YhPjN8oKzjIUQQec2Wij/hTXTvfkK1rrbFFeMhOXAjBx+6rExWZAojXyJk/GMU92v5M8mgOEvbGAJGHhwBlKFLWYND0gSFs/YEup0bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U2LUsbbmgZ1nNuz9PXCT15uFITluWPtFBaqrtYOB82o=;
 b=uJLfgnvomQbjYO0HjB5hOr506UJxH/GmyqlmbPbUuaekRUEmawwODdzmlIX3vFVqdRjXLT77x4ScpkkQu7PcaduDcQT4/m8SmPw8c58so3c62YSkFscmLwmnr9m13y9xjHcr1u5Ik/F6eA6GvkqcAeAxtTwRMEX1pN99MrbVmu5ftxgW3C9UwklUv8qAasgsttZ+SRwgENn31nt71fUhv/61hExatlsJcZLgze4SPsOoxzRcdIBD+OvJhar4TfD6Poaeo6E2zbuvKi+HyFNkAayFkowN7sQSn8+QSYR8z9GDAH77z6glRgJcI1dkdnrc7Py52FAsh8/zyYkCffrcZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2LUsbbmgZ1nNuz9PXCT15uFITluWPtFBaqrtYOB82o=;
 b=OXNyOHWPZ1G1dB3SGYetkp4MZFAP1A8hQUaBr5HsPVFcLvOp5HudOZhStP0/j0jYm5tpLkz5JhPSis5yKS1NVltmQqjBAApXwBiKZDw+AaGW/ivbR5RssqKwTSpASRHo9I9hLpvPHhDqCleQxfJpuxntBEQIy4a2JKR6g8C+Ot8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by DS7PR12MB8417.namprd12.prod.outlook.com (2603:10b6:8:eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.14; Fri, 9 Aug
 2024 09:34:44 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%5]) with mapi id 15.20.7828.030; Fri, 9 Aug 2024
 09:34:44 +0000
Message-ID: <22b5182a-24f1-3bf0-78bb-762f9d8fc26b@amd.com>
Date: Fri, 9 Aug 2024 15:04:34 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
To: Kim Phillips <kim.phillips@amd.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
 Kishon Vijay Abraham I <kvijayab@amd.com>
References: <20240802015732.3192877-1-kim.phillips@amd.com>
 <20240802015732.3192877-3-kim.phillips@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240802015732.3192877-3-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0120.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::15) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|DS7PR12MB8417:EE_
X-MS-Office365-Filtering-Correlation-Id: 449920b5-0585-463d-52d2-08dcb8568020
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YTA0cDJ1QXp3Z3RmaEE0SVI3bWtDR2lIL3RYSTc2UjRKUHFlb0twTHplNEpG?=
 =?utf-8?B?cGthcFZBdFVyUGdXeHQ0dUJRaHdheEdHZGVJODUwOUZJZW13REo1N3hQUlJo?=
 =?utf-8?B?bUxXK3VBNCtzSmt6WnBMWXU2QlRTTzlaZ0ZtTEEzNUtOTFhtUi9xRGRXeWlp?=
 =?utf-8?B?YW1ycmxSbmY4Z01xT0Nhd3ptRUs3b1hVLzMyRXdXQmFROUJ6ZkpXblc0cGhx?=
 =?utf-8?B?dmIxWnd6ckpZNHU5Vm9WSkpnZnU0TUFoNzYvd2hyVG5kVDVzcFZha25zS1Mx?=
 =?utf-8?B?NzlyQ3JTL0Z3WWhFNVN4T2dxMktsRkdaUEhGc2NWV0JUQVI3ZW1HRTk3QWpU?=
 =?utf-8?B?bEorU0Y3YXV5ZGxTOWUyVGZmaTB2QXNacFpYNS9sL1JRRzU0SDVLMUNBQndn?=
 =?utf-8?B?b0dpM216Y0piSkg5eXFiM21nRE9NSmt1ZTNkaHViSFRiS0RpSFc3RjFsZEl5?=
 =?utf-8?B?TEl3dG51WWtKN3RPRlZlOUJrREZUYzJSTEdmU0lMSUdNcEtvdlU2M3p2TjA1?=
 =?utf-8?B?dkdqdmpFd0pkdHdzQkdZVGt0OXlaU3pUdnFNaDEydE5yUzMzTW4wQ25XNjFT?=
 =?utf-8?B?aE5ZNi82aUYvbVFvcG9wb1I2RjhSM3UrVHBzQzdRRStDSnRMYU04V1pHS1Fr?=
 =?utf-8?B?V0gxazI2VzJnS1MxOXI0ZkVqYW1udy9KRjhXQ2RkWEhRQkRUK0J3aTIyb000?=
 =?utf-8?B?RjlKQzBkL0FTdjA4aUU2ejJtdVQzMkQwUytFR3dTVit3VndhZ21WNXgvOW1j?=
 =?utf-8?B?S1VwUVRtdDFOK2JyZ0VjZG56OXFaNzhTY1dxMDhEclNINklHUjh0emIwWVg3?=
 =?utf-8?B?bEI3STRmMnNuQ2RhbWIxMkV5S1krTitkVmQ5dEs1UmM0YkhzWHU1dUNaVzZH?=
 =?utf-8?B?dnpFOFpoZ2prRlI4ZmxFT3pRM0M1dE1DRkZoTGhyaS9wSkNwWVFDMVdINEhP?=
 =?utf-8?B?NUZxa0ZQckpVVzZXQVg0Zi9HN1VqYUZsajcwMEZWZ1NjR0E0U3dYQVZLeVhH?=
 =?utf-8?B?b01uaXJFZHNGZ1hvNVgxRlpkcjdCbXAzMmpMalc5VzlVZk9JVGNKejRNUmxB?=
 =?utf-8?B?bEdYYmpiQjNaSHFQbUdwNXV6azUrTmdvUXJRWHZ5Zkdtc25ZY3g2dzhKSU8v?=
 =?utf-8?B?dEhadHI0QkFNT1MwWkVaYkVNc081R0cwNmRlR2RVRjRCa3ZHaVFrYnVIZFg2?=
 =?utf-8?B?Z0JQL3lNcjVNdks1NVlKOEVPNUpzUDRQTmpuaXJ6OUI4VlRTS2gweXpna2VR?=
 =?utf-8?B?SkRVYk93RjJMbVFFTjhxYkF1U3NYbkhwTGo3UDhyUHBoYUNXdTU2L0V6T2Iy?=
 =?utf-8?B?T04vUTRDOXZqS2dhK2JLUml0bk5GSFBwT3ZWbERIZklxMlZzOEY1Uit0QlVS?=
 =?utf-8?B?K1JyN0kxUmtSZjdmRmYraExhbEEwTmE2aFJEQnJiU29qNlE2aUFmZ3U4LzMz?=
 =?utf-8?B?UUtnZkhJT2xUeEJPa09sMjZhVEZpc1poMWVGWjFXNDMwWktIYlBIYVRSQXRL?=
 =?utf-8?B?aGpzdVhiNDk5NGNVWTkxbzFhOHpxaFBVRVFwN2diWDNlVXRaVEgvWEZRa0p6?=
 =?utf-8?B?NFp1UjdlaTN0UnRxVE5JQ0YyRmxBTmxra3NoL3NGWXR0TjczTHBVSGJXMkR4?=
 =?utf-8?B?eStOR0phcXBrT09jK24rRjVZbE1sdG9vSlY3N3RpWGkwSm5vZXFWZnZIUzlw?=
 =?utf-8?B?L2FBekNJWFcwZmVzVkpKUnRPMXo4eVR0Z05XUHROaWdxNHFyWTNRMjVvYVlX?=
 =?utf-8?Q?hBMIodqxU+C+xA3Kvo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTEram9ibjhmZEZ0ejYvaUdnVVFoZDEyWFFaT2VNODhmNlJWZzBISE5XdGRU?=
 =?utf-8?B?T2VOYnMrbkhxTXFSWXJ2UjJPVm1GaXhqbW5oeHpRNndjMmhjU24ybThKRkpZ?=
 =?utf-8?B?b0JqQ0t0dkVTQkYraUFXM25GSEU4a2w4bG80N2NCRENKR3RvbDkxU0toN1J1?=
 =?utf-8?B?Q2Fha21Pb1JXQ0w1c2hCMmFIaDNaa0kzOTMvc2RSKzlFVUhVUHhZb2FWajhk?=
 =?utf-8?B?aE9CTVhRMkJvZmsybkpKd1ZWU0lSdk9wZlkrdUlqeTMzUDI3UDhrK0k1SW9Y?=
 =?utf-8?B?UnhZK0MrOSs3bWtpeWNYVG5kRFpEVVo2TUJSYSsyZEp1aW0xRERvb1llZy9o?=
 =?utf-8?B?cmEyTnhzelB3RDZnbVhVN0ZnVmNHZy93cE1IanB5RGwzLzd5ZmVDbXVyWFgw?=
 =?utf-8?B?WEI3aU02Qy93TTNZRTFaSGlCMlVnUk1BcTg0bkdrT2Fva2duL3lCcEY4d1Vo?=
 =?utf-8?B?UVFzWmlkZnlwbnUyU0QyVWc1RkFBaDVEVFk5a1l2WU1vWU9QWUg1VFdIblFx?=
 =?utf-8?B?MG52TTZTV3NRU1Y5RHJWek1pcnd6aEwwSWZmeWNkQnJCaUhtVlRSUGhjc2RO?=
 =?utf-8?B?Qjh0SUF0aGQyQVhrREFEOTRWMFluS1BtNktUU2tsWXl0T0FvaitWRzhYZW9B?=
 =?utf-8?B?MmhOL3VLcEVjSms1ejdybUlkeGNXY2ZCYjVxRTVUeHZTVXlzazBuMjN2TVhq?=
 =?utf-8?B?ZzN1YW1BSEZRZjgvTFVOTVRndXpJd3lVR01neVhwcnZxUmlNSzF1SzlKL25w?=
 =?utf-8?B?ZGVBMG4yV3ptMXdGOWp3cE9wcS9NSVZmYTR4ejN0ZlY4NXNaZHB1RCt6SEk5?=
 =?utf-8?B?M0h1OGhHZnVtcmJ0ZTNOb2pMWGFvM3RuV0sweXZ3NFZibHo2elVzbXdPcHFh?=
 =?utf-8?B?RWl3OFNMSHBvNmNlUUhIeEE4NVNaZDg1NnpTUkVhQ0x6QUJDZGh0S1Y4OVRF?=
 =?utf-8?B?NzZ6VmVSWC95M01PN05zNXU4RnpFRHhnSSttcGtHUUdrS2sySlM0b01uam5M?=
 =?utf-8?B?YXhXYzF3c3dSbWVGKy9saDVndWN0YkV0aTRWL3UrNVdvZGV1Wi9vNUw1N1BI?=
 =?utf-8?B?Sm45MTFJNXF2djY3VitrY1BpdXFNaHFyM3A0KzAxWU4rMEtCSWJrbjlkNDdP?=
 =?utf-8?B?a3RPMW0vRlhncVp3c093WS9aZ1FYUjVsZDFsdTJ6NEI0djNuNEdBN1kvRnhn?=
 =?utf-8?B?WXJ2bHByaVpCbWZOMkEvcDMzQnFORFltOFhCaWh4STFBdlJvSTBIZXdlYzh3?=
 =?utf-8?B?OW5RUFk1RTJhNHdRcDBXOFI3UGxvUndBblFHb2ZKN0NxWC85Wmc1akl1VmFO?=
 =?utf-8?B?Q1U2MmY0MjYrOUM5YVhIdlJqSHk4eUw4RlY5MjZsTzd3azAvRm5ENmVleVN4?=
 =?utf-8?B?dk45cDVKQlppQlhsbnJtVnN6MjUvRXR2ZmVkb0dvOGhVQkZuUE5ETTJzTEdt?=
 =?utf-8?B?ekFwZmJRVG1xRjByQ25KMHl1Um9URHpEa3hneUdqL3p4NHlqV3ExMlJmVnd5?=
 =?utf-8?B?TjlMQjNJa3ZPTUFZY0Y1TGFjaDMyN25oZ0ZaVHVSL2ZFSmhtMVhqbEFDWkFa?=
 =?utf-8?B?dVp1VzJzbUI1SEhlR2Z6aU1Gci9xWU02Zll0WGQvb3cvenRSYnNIWThzT0RL?=
 =?utf-8?B?aXlhMXNhRGxGYW1UZTlHK1VoSnh4MzZ5bk5icXF6Z2tVUE1hZGphL2RpMGVS?=
 =?utf-8?B?bW1WVnRTZHBYQ1JvUlNmOUdnTExCME9EMnRVZDQ1SmMybmI2Q1lMQ3F0MDZO?=
 =?utf-8?B?aVgrQzg2SUJvU0wxOVZqdSt1WUU1a3ZnN0UwR3ZCN3ZQMzRoUzhiZGdXcnRZ?=
 =?utf-8?B?WHVFL2hwZzlKKzBTQ015bS9FVTA3SDNHVjdzMUp2VHVWUHdZWHExMk4zZkZr?=
 =?utf-8?B?eGkrdW1kZVhYWVdpZkdTekplcldOME9LMUhDanpzWXpHMlEvU2RXTmVIakE3?=
 =?utf-8?B?VHREK0tldSszdXNIazlJVitlemg0WDdXVzRMek5nNk8wdEtlaW51VktCemdO?=
 =?utf-8?B?ZGV2YnZmNVR6MFNqUGFucG91cEp2MktkVk9pWXJocEVNZ1ZxdzNNcklBNENj?=
 =?utf-8?B?TzRDM3NwdnZzc3J1S254d3FYdHVxaSs3U0djenRFN3hZbVp2OEhQWllycGt1?=
 =?utf-8?Q?WpKGyIGLg7zDeUnEIcIbLLMPC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 449920b5-0585-463d-52d2-08dcb8568020
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 09:34:43.9167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fCuGP9RlHtOfXceERIs30ynoxPr/rC89H7HaPYqaVve85n+SPtuht43o24yhNJ9ZXOZJYPU6gPP/FypK6veYmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8417



On 8/2/2024 7:27 AM, Kim Phillips wrote:
> From: Kishon Vijay Abraham I <kvijayab@amd.com>
> 
> AMD EPYC 5th generation processors have introduced a feature that allows
> the hypervisor to control the SEV_FEATURES that are set for or by a
> guest [1]. The ALLOWED_SEV_FEATURES feature can be used by the hypervisor
> to enforce that SEV-ES and SEV-SNP guests cannot enable features that the
> hypervisor does not want to be enabled.
> 
> When ALLOWED_SEV_FEATURES is enabled, a VMRUN will fail if any
> non-reserved bits are 1 in SEV_FEATURES but are 0 in
> ALLOWED_SEV_FEATURES.
> 
> [1] Section 15.36.20 "Allowed SEV Features", AMD64 Architecture
>     Programmer's Manual, Pub. 24593 Rev. 3.42 - March 2024:
>     https://bugzilla.kernel.org/attachment.cgi?id=306250
> 
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

Looks good to me.

Reviewed-by: Nikunj A. Dadhania <nikunj@amd.com>

> ---
>  arch/x86/include/asm/svm.h | 6 +++++-
>  arch/x86/kvm/svm/sev.c     | 5 +++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index f0dea3750ca9..59516ad2028b 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -158,7 +158,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  	u64 avic_physical_id;	/* Offset 0xf8 */
>  	u8 reserved_7[8];
>  	u64 vmsa_pa;		/* Used for an SEV-ES guest */
> -	u8 reserved_8[720];
> +	u8 reserved_8[40];
> +	u64 allowed_sev_features;	/* Offset 0x138 */
> +	u8 reserved_9[672];
>  	/*
>  	 * Offset 0x3e0, 32 bytes reserved
>  	 * for use by hypervisor/software.
> @@ -294,6 +296,8 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
>  	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
>  	 SVM_SEV_FEAT_ALTERNATE_INJECTION)
>  
> +#define VMCB_ALLOWED_SEV_FEATURES_VALID		BIT_ULL(63)
> +
>  struct vmcb_seg {
>  	u16 selector;
>  	u16 attrib;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a16c873b3232..d12b4d615b32 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -899,6 +899,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  				    int *error)
>  {
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_launch_update_vmsa vmsa;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	int ret;
> @@ -908,6 +909,10 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>  	}
>  
> +	if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES))
> +		svm->vmcb->control.allowed_sev_features = VMCB_ALLOWED_SEV_FEATURES_VALID |
> +							  sev->vmsa_features;
> +
>  	/* Perform some pre-encryption checks against the VMSA */
>  	ret = sev_es_sync_vmsa(svm);
>  	if (ret)

