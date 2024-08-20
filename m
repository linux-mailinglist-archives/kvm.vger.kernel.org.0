Return-Path: <kvm+bounces-24648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 542C4958B39
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 17:28:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC12F1F21B5F
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FD2194081;
	Tue, 20 Aug 2024 15:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="atkYxwVh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1A6192B8C;
	Tue, 20 Aug 2024 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724167623; cv=fail; b=urnWsILXS5qBF/AZmlwtI6IGwB6Ad/jkb3Oub3MR11bIQ9H0BgWOy1WNj7/y+qVUSaE+ug5HxrjCf08FD+dMrd049+OSR0r0Lq+1GPJDE5wM0oRqwTFoW6mbac1wRno2daFSR12zrGvY/Y6BbGuR/XEgxUknp7nVEwDKTaJmfcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724167623; c=relaxed/simple;
	bh=OlaoomBzn21POEyKs2ljX72FC7KjtdzNQF6aatblbCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=H9AxypQ29GbmZYVnj1WMjK/Ch2RIB4pJcNNmtaqrzQj+2sluJZ3dU7D/pivGPPO66xOKc6mnLBGy+UcKAEWelyFFbXFXjtpR1Uz81eUxlb7FiomVOPY2qs1o972DkIcdW+0LGYMhbCJ6jtcXKODQ0OunWPXlanb4boDFoJrV4kA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=atkYxwVh; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ilQMJJLpIMspl4i7rLJNsyuMayxi1xKMo6g7zQSV0kwUZye6LbCEHLguVJHUmm+iOqid5d5EEdH9kiN7xQ7wXgTlqz2dunVrrzHnVoqNVnfCEVgO9lDLqHlEmwmkB/tb6ds2vkvrnqbkCI6D8dFP0VcV+HOwrWnJGSqLUe15OCmdqMM2/qNz1IuWjI2S+BakxTVOOsPkbu7oLizilel41rMjx6OgSJabESqzy8s6S1zDMiu6B4qjYeSK/gqhicrQTRPMp2ImBfmqeEJAygY/bf2GbXhWeIJXRFcDt/turs63kUphGzkMzucj4GjczIeeg7ZviFyEf5tTO4dnBxWl9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLC7dNYrt1CwmyJI2goZvU/Dze+nSnwf3eosJV92cEw=;
 b=eDPIrLFwQ0VYuA9tefXbNSFGfu07EFooV8lf9eXKl7Ktzt+Gg9ntvM+CIJaLyw8khtL6T6WHWDSKtA1rKfnOgrj7VZQ4QvdUBK3K6yTkkicW+ffz2PSnNEq/N29PU+o/7I0vkH6B4eaV9cHIuj4MKAAXB4ST0bJJwHp8fUMFMPGWPts0zrbRZgjPPumCjubCkKjQ52NdZcNONUkiF6MQfSJCDpVBSHcv7AhMyisG6zUEfUlZVYNBPXXvgzndkOcFEuf7jGuYA7Wfg34tGm00d9e70OglN5D2zMsRyAQdndpDOYdOyxKuA1WZXO08Y9WVrWCTsfl2erTihVHZz6jxTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLC7dNYrt1CwmyJI2goZvU/Dze+nSnwf3eosJV92cEw=;
 b=atkYxwVh+to5haCsy2Fmnizfde0yCMYj6wlZqExAqzdYEvN+0iyKtRZSBLkDooeuMyZhN6RT0RzOKSFesjLrduL7SrWqqS1jxMgcKipvmtJec8QjmHfWHcrPb2vF+ST8cf1GCcL7Mz8hwh58m54hoSn9gC/nQ/jN1yZ9CsQcgrQ=
Received: from SJ0PR03CA0051.namprd03.prod.outlook.com (2603:10b6:a03:33e::26)
 by SJ2PR12MB8942.namprd12.prod.outlook.com (2603:10b6:a03:53b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Tue, 20 Aug
 2024 15:26:53 +0000
Received: from SJ1PEPF000023CB.namprd02.prod.outlook.com
 (2603:10b6:a03:33e:cafe::9b) by SJ0PR03CA0051.outlook.office365.com
 (2603:10b6:a03:33e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21 via Frontend
 Transport; Tue, 20 Aug 2024 15:26:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023CB.mail.protection.outlook.com (10.167.244.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Tue, 20 Aug 2024 15:26:53 +0000
Received: from [10.236.30.70] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 20 Aug
 2024 10:26:52 -0500
Message-ID: <c603c0c3-36cb-4429-9799-ed50bba4a59e@amd.com>
Date: Tue, 20 Aug 2024 10:26:51 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "Kishon
 Vijay Abraham I" <kvijayab@amd.com>
References: <20240802015732.3192877-1-kim.phillips@amd.com>
 <20240802015732.3192877-3-kim.phillips@amd.com> <Zr_ZwLsqqOTlxGl2@google.com>
 <7208a5ac-282c-4ff5-9df2-87af6bcbcc8a@amd.com> <ZsPF7FYl3xYwpJiZ@google.com>
Content-Language: en-US
From: Kim Phillips <kim.phillips@amd.com>
Autocrypt: addr=kim.phillips@amd.com; keydata=
 xsBNBFh3uA4BCACmMh2JZ9f6vavU7XWTg45pl64x61cugDKZ34jiRLohU280rECk+kyXrKGB
 GdtV5+8tZWhMCyn151/C/OEYIi3CP5DY6wyrjbFkhI8ohqR4VqyC9gWAqD25coTQpOHyt7pd
 8EvSBDAuL031gqw5w6JNeqEbMplZeToy5Rgdr1i35MZOzyIaO01H+F2/sOL7qk6pY21y5Flj
 ojjFT/uWg7eodnOu/BJ1Uem6FaO6ovYSAMOaCs/GpguznsS76ORsH6Jnyp6+e3KlZe/F2M7H
 5HWCVsS5np2rf1luDsfHKV7HCd2+4iFRhxjbbulSBRMn7zx16PEGh8ccNwJm9/nwof6jABEB
 AAHNI0tpbSBQaGlsbGlwcyA8a2ltLnBoaWxsaXBzQGFtZC5jb20+wsCOBBMBCgA4FiEEaBZs
 4ROWXWKVJWj8Z9viHdU8iO8FAmHm/zMCGwMFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQ
 Z9viHdU8iO8aXQgAnByD4TUD+xGXXDAkIopwqip2Vfy3qzNhmfzdvLxKxsb6I6Tf1l2pMPGP
 EHxDPfuQhheyh+iRWrba6flwBGaNriJTFuVpQUGoRcjV11F2cpEbToqv2LGPaXIpc7IxEoRt
 lg9VKr70XcRePKq4iH5e7wrmzACP9UlvaKlRJl97FTckZIguQQMZe9kqLga1yRDqcQVN5Kj6
 IP6V8WzRz0qGpVE1GE/vjYH13o2qHrvp9d/zlPBTZFwhNpLBn4JHohyxQ63t7eZ1L4U66Caq
 jZ0lhdN/psHJWab0SeIIRAG5+WLMcRbx3+LPjzIyrXJSonsm4t5lU3RmGmWwJSunxGDu1s7A
 TQRYd7gOAQgAp2VJv7J5eaWVdHvazWijdobOXSa13GnV8DXENQLQSSQlxGkLkYa3nDHr6Xjk
 z2NPFn4cf8GgMd7Bd4p3MR6DbwA4qKE+8ZW2x4XdH///HGDDEI69sDZEzLPXgl/9dv49dxym
 Q/nuco2KtF4xaMS/mjRsv7Eu5oGH+2+vPKe7L8ykXUh7SJmr0tI2/y9A6MVOPckdenywmKQ+
 6R0gw6aL2OeUyWZLS/e/3+0zFmQxeTyHpoJb8cNk/XqUGsBXsTO6y+7fdykpXNCfeJL/bSGE
 SXgwRROHCnQeKwVbbvEU/e5GZlNnKXoD7u2jyJxt4NTG2c0Jze+W3MPwh1wxzNg6BQARAQAB
 wsBfBBgBCAAJBQJYd7gOAhsMAAoJEGfb4h3VPIjv33EIAIRVHWqFbAYPZZtYKdwugwzL0FKa
 X0VbkUvKNG8SQAcdvkKmnSITWrIbecHPQaSqrtl/W8qKD6YFNOC9JNCHEfyLPTxo33WonQpo
 utm5nbRS1p45Mk65Uu76qhuHMjPnOgbMqmRHgWjIRiNfKm1QD5/3bml08HnJ1PuucuxI4HkK
 SWR00RE4Jyhxi1ISB3UEQ98iZtobAkTYa3aZ6xCZzd+v+o4CkLDKtS8vrBXpppi/HAeRlL7m
 waGKsjcegLX8cEHSblIct+9KKjUrE8uZyokt67sTYDlPapVCkhTtKn5O88jXkqA2PgAU6XqP
 KeUe7zYeAD22yc9K+Ovi7bZ9I5o=
In-Reply-To: <ZsPF7FYl3xYwpJiZ@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CB:EE_|SJ2PR12MB8942:EE_
X-MS-Office365-Filtering-Correlation-Id: fc744972-01a8-4392-0838-08dcc12c8519
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUpCZmhsaFQ3NzdOUHlqSmltL3Y2UWpkVGlZQXE2QlpPTDQzeTB0cDVTemw1?=
 =?utf-8?B?c01TUVAzNlZlc2hFamk5a3RHK3diSFo3T2VCR251d2lNakdYSWN4dGlRQ3Nt?=
 =?utf-8?B?Mlp0WTAvTUJESFJjTXNIZWRoRllRTVNrSjh1TkwydlVTMzVnUlFMOEpOV0dT?=
 =?utf-8?B?Rjh0UXpKaVlZNFZxWUkzZXlTZCtmREl5THVrWmFaVkFsai81MnF2WTBxRGJy?=
 =?utf-8?B?aWNZMWNuSkFZbTdFV1FrTmRRL2drODdzSXg3Vm91dGtLTUlSOXZ6eTNvTkg4?=
 =?utf-8?B?MUg3V1FZc1MrK3d3b0tIM20wUWs2bHdxK3ltbnhrVEFsQWJBTXJUd1BrRlA1?=
 =?utf-8?B?T1JnTVFGOTVKWFloa2FOVTFlaTVCZ0c2RnZwWk9xYkxwYUZHSUlZRTZLUlBa?=
 =?utf-8?B?TFhHTms2V3AxcklGd0I5ckdQVmRZZ1lsNHhjdER2NGFPbFNGTGNLNmZYT3M2?=
 =?utf-8?B?SFdNMHVrRW5md3o1NURCQnpjYm1uNjZybnJybEhLVXhDZXRHd3VuK25JbVFU?=
 =?utf-8?B?Y3RHS0s3SHhPeFh6c2xqRE53cnpYaGdqZVduZEIrUTNpUDM0THZWbkM3Tkpi?=
 =?utf-8?B?TWg2MFBzdEVFb0lheVBPK29CQmNPekFVUnY1bEpIRVpLQ1ByelBrWlV1NzRW?=
 =?utf-8?B?NVRBcGR3ckdQVDBiekVwSUxXcEJ4WjhWNDhYTGpJekVNcWJoYkYrVkJDdzZi?=
 =?utf-8?B?TXZQTmQ4OS81K0xwc1FYanVpamc2UHU0d2k3VVZpaEVLQUl4VmlEN0gvaEl1?=
 =?utf-8?B?a1Y0NGpoNWRVb1R0MXdZdzc3NWw4c0lUOFlGOThVTlJaQkpZa1AvVzg0bTlM?=
 =?utf-8?B?V00xTEIrYnd0M2FPMTFYUXMxNEFuc0FjS1RjWXFPRndicHdralNwS3lOamk0?=
 =?utf-8?B?NW9qeit1SDl1cWdQeGtOV2xHdHR0bXl2bWRxVlB6dE5zTzFlY05aVjkwSGxz?=
 =?utf-8?B?Y0gxSW9URWlIZWRqM1BzZFdGd1Z0SWFEckxYZ01oUFFrbHdzbC9LSXBCdk5s?=
 =?utf-8?B?VXRlSXQ5VVJBbWdpbjljbDVDWGpNb1hUbWJySFpFLzJsTXRIc081STVtODBF?=
 =?utf-8?B?NVNjNDQreGJLa3VmMHlaS1hwcm1SalhyQUhkY0czaXdQektUQWRFeFFJWURI?=
 =?utf-8?B?empjVzhsblI4VGRrUW1Lb01VRGMyaWlMVi94eTdUQ3RnSUdWdmk0VlJMODBi?=
 =?utf-8?B?bEI0bGdqcFozSXVieGxOZTY2dFhmMzlQbll1S0YzNHB1bkJjaERXQlZtYXRm?=
 =?utf-8?B?cXhGNlVZbS80VEhCT2phV09nZGd6TEdHTnZrSHRyL3ZmTzBVS0laVFJtTnNi?=
 =?utf-8?B?NWhVZzB4Q3E3MlBPdVNxRXZUVlNLdlJQcFFSaDliYjI5VlFtWWpXMHkrVHgz?=
 =?utf-8?B?aUdJMWZUR1dMY04vUFkxZ0JaS2F3a3R3Qm45Z0owSS83OWxza1ZwMlRMRlRH?=
 =?utf-8?B?VERHOHExcW9Id2RHWFV0UDVmemgxSGZlaVhDRFpNS2RRdDV5eWtjbVZ6NWVt?=
 =?utf-8?B?ZEZIRURWK0lnUWpUS1BTUWtHS2pTTnFjRVE0ZVRsMTA1OFFDYUQxUW1WT3Nz?=
 =?utf-8?B?K0pJSWdZREorSzFqYk1mb3I2cC9pSnpQUm1zK0JPOVE0YmEzN3pNdnNyM0xw?=
 =?utf-8?B?SGdpRTdKbkNUdHhxOHc1UjhpNk1CcksxYmpZMkR4TlVaYS81US9YU3BKUnF2?=
 =?utf-8?B?U2xOTno1b2FoeFdWWWNRWGYxN01wdXQyU0tqZkJLemtuUmpMRFJvTEtieFYy?=
 =?utf-8?B?RFZFMDVBQ1Jvbm9jTEs5Z3E1aldJL25LcjA2WEJRTHJDM3VQdjZRUGRrc1dD?=
 =?utf-8?B?R3VrUlNRRk5CWXVKeUpsMXlpc2ppTkN1VGhqMDFscVVJdkY0dWkzUCtLclps?=
 =?utf-8?B?RUtQTi8rYUc3bFMxK1orQlhuUXB2dFhHRDhiV09QSFQyOWs1dE9ySTFBdkhh?=
 =?utf-8?Q?NH+Nz8K4Ij37LSfUGCZKLcIVTmeo3/zW?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 15:26:53.3937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc744972-01a8-4392-0838-08dcc12c8519
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8942

On 8/19/24 5:23 PM, Sean Christopherson wrote:
> On Mon, Aug 19, 2024, Kim Phillips wrote:
>> On 8/16/24 5:59 PM, Sean Christopherson wrote:
>>> On Thu, Aug 01, 2024, Kim Phillips wrote:
>>>> From: Kishon Vijay Abraham I <kvijayab@amd.com>
>>>>
>>>> AMD EPYC 5th generation processors have introduced a feature that allows
>>>> the hypervisor to control the SEV_FEATURES that are set for or by a
>>>> guest [1]. The ALLOWED_SEV_FEATURES feature can be used by the hypervisor
>>>> to enforce that SEV-ES and SEV-SNP guests cannot enable features that the
>>>> hypervisor does not want to be enabled.
>>>
>>> How does the host communicate to the guest which features are allowed?
>>
>> I'm not familiar with any future plans to negotiate with the guest directly,
> 
> I feel like I'm missing something.  What happens if the guest wants to enable
> PmcVirtualization and it's unexpectedly disallowed?  Does the guest simply panic?

In SNP, VMRUN will return with an exit code of VMEXIT_INVALID (0xffffffff)
if the guest tries to set it.

In SEV-ES, the hypervisor can set it, and the same thing will happen to VMRUN.

In both cases, SEV_FEATURES is saved to VMCB field GUEST_SEV_FEATURES at
offset 140h on the VMEXIT, indicating to the host which feature was
attempted but caught as not allowed.

>> but since commit ac5c48027bac ("KVM: SEV: publish supported VMSA features"),
>> userspace can retrieve sev_supported_vmsa_features via an ioctl.
>>
>>> And based on this blurb:
>>>
>>>     Some SEV features can only be used if the Allowed SEV Features Mask is enabled,
>>>     and the mask is configured to permit the corresponding feature. If the Allowed
>>>     SEV Features Mask is not enabled, these features are not available (see SEV_FEATURES
>>>     in Appendix B, Table B-4).
>>>
>>> and the appendix, this only applies to PmcVirtualization and SecureAvic.  Adding
>>> that info in the changelog would be *very* helpful.
>>
>> Ok, how about adding:
>>
>> "The PmcVirtualization and SecureAvic features explicitly require
>> ALLOWED_SEV_FEATURES to enable them before they can be used."
>>
>>> And I see that SVM_SEV_FEAT_DEBUG_SWAP, a.k.a. DebugVirtualization, is a guest
>>> controlled feature and doesn't honor ALLOWED_SEV_FEATURES.  Doesn't that mean
>>> sev_vcpu_has_debug_swap() is broken, i.e. that KVM must assume the guest can
>>> DebugVirtualization on and off at will?  Or am I missing something?
>>
>> My understanding is that users control KVM's DEBUG_SWAP setting
>> with a module parameter since commit 4dd5ecacb9a4 ("KVM: SEV: allow
>> SEV-ES DebugSwap again").  If the module parameter is not set, with
>> this patch, VMRUN will fail since the host doesn't allow DEBUG_SWAP.
> 
> But that's just KVM's view of vmsa_features.  With SNP's wonderful
> SVM_VMGEXIT_AP_CREATE, can't the guest create a VMSA with whatever sev_features
> it wants, so long as they aren't host-controllable, i.e. aren't PmcVirtualization
> or SecureAvic?

No, as above, if the guest tries any silly business the host will
get a VMEXIT_INVALID, no matter if using the feature *requires*
ALLOWED_SEV_FEATURES to be enabled and explicitly allow it (currently
PmcVirtualization or SecureAvic).

Kim

