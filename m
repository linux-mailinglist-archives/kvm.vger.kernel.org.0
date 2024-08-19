Return-Path: <kvm+bounces-24552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CE8D19576B5
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 23:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BD481F22F67
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 21:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 160DE15C12F;
	Mon, 19 Aug 2024 21:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XhYx2TtC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F10C61FD7;
	Mon, 19 Aug 2024 21:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724103526; cv=fail; b=EWGlTV/R/vCjdfthFNSblZOwmZgAHTtxpuRTquXwfulqyG7CNlx8zH3gS+nSCC5PhwkPyhiymyLPEkd4NpsxDChPIbj3gRtnypHezBh4Y7kCNJHJDUUmXrWuvHRv4ehol2SyV0sxHSghtwJHcUhWJCQO8VLLc+cuN/QxK8AHcLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724103526; c=relaxed/simple;
	bh=7w3dJnPe50MsL/1Vti144UrSkWiot4leCOGiKcABMQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=XLhOsod8+bvP4VR3xsccXSWpUywSBu9E9QhBHk2TFNHhqWRBzL0JnNN7hyL48NC9kx4Jpr9hyENdYJlhzes1Tf4DmHyseKUFdjcn55r4DzCDK19TnTQoTJW5huk5A+jhm667uxfHJ/dcOojbcoh/XT0QSeppfO+g0B0fDWHUGGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XhYx2TtC; arc=fail smtp.client-ip=40.107.93.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fpb3mBlhMZdvaN8QFX+gnHn3LScseO8BFjlHE38J8kvna+cyEJSclP+nv5IZuNyNXNu/UO5E+yS5vt74qlJ26Yud7BxgzD7G+vYZK89xJNqP5XxuKlMI665uPmRGTtKi0QNMQDFpIdNmKi8UJa88MqzBPtqQOunJsn2O6IUUmI6PzT6bUIZLZ1NLSJndr6FI7ero6DILcw8c3iHrz87NsV4GvOBW73aFZSu5RuYG8ozs72U+TixgcVr1sDVXAMC0pG9eKcGkn8XN6kNUTKYkHi9Unq4Ga0J7tX7Qro7tWUQ6NAg0BCLA50OUTJ1oWOFw3472rNTmTJtYArG/1uhdyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwPEYAq/m9eYsMXyANhhd4IB35Xtp3F16WTBEgJzq5E=;
 b=nHuf2LH1ca2PXv/48zr5XpwshWoFmirjlweEBOPdnLz7NNwjrrhIeJLQZThzkAX9NsydS5kkjjdDLVN6cvHD9IVfkAqqQgNayFNZJW6up01hpVpjAPh5jX+Sbexnc2EajAqURjuUmk4PjyV+YjkhU4zKim1xEEXQU/MhxqTaEoD+SIdvPWWtt7LB2QPqo3wI0nKyNpxDytasYE2fVarj0Om5u4oK9mVZaydyyy7swApPZOytJ76+mwxZwTsokiocze3os4jXlhO9hBluDDhoM1SHO14xkvlv/2s6/KGlYJBaNPfaL0smDeBsZzYM5mqSQ1tVk7Egv8puicDh1qRj1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwPEYAq/m9eYsMXyANhhd4IB35Xtp3F16WTBEgJzq5E=;
 b=XhYx2TtC3FIxwBpyJpSCkeI+tbpJr5bB7HJJ1YlFKdDWNK73FzErm2Bc1J/Ct928gOmn+y6aTI1kkoIRqsCn7aOG2iDfrvFweIxkmSeVnn1nW9A8yDlpBZ/YQQT/KxMATBsQfUVCwLcvjv37vPQrySLCJZkUnVpH+/mVBAuv1O4=
Received: from BN9PR03CA0985.namprd03.prod.outlook.com (2603:10b6:408:109::30)
 by DM4PR12MB5890.namprd12.prod.outlook.com (2603:10b6:8:66::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Mon, 19 Aug
 2024 21:38:22 +0000
Received: from BN2PEPF000044A0.namprd02.prod.outlook.com
 (2603:10b6:408:109:cafe::ba) by BN9PR03CA0985.outlook.office365.com
 (2603:10b6:408:109::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21 via Frontend
 Transport; Mon, 19 Aug 2024 21:38:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A0.mail.protection.outlook.com (10.167.243.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Mon, 19 Aug 2024 21:38:21 +0000
Received: from [10.236.30.70] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 19 Aug
 2024 16:38:20 -0500
Message-ID: <7208a5ac-282c-4ff5-9df2-87af6bcbcc8a@amd.com>
Date: Mon, 19 Aug 2024 16:38:20 -0500
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
In-Reply-To: <Zr_ZwLsqqOTlxGl2@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A0:EE_|DM4PR12MB5890:EE_
X-MS-Office365-Filtering-Correlation-Id: 704131eb-9ecd-4b40-3f90-08dcc0973f9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aDVscHFWRGRoQ0k2d0NyaWNXWFgyZUZlaXJtU2gxZWhKcGNxK09FRWRxZ2tG?=
 =?utf-8?B?ZVpqR0txd2s4Y0ZlR0dkRUp5Nm5XQU41Q3UxbDZ2VTB3ajVPa2tBSmhyWFEz?=
 =?utf-8?B?VmlJTG5tQnU0U08xZVkxUXBhdFFtR1RDMVk5YTczSFBzNkxBem10K1hKbThl?=
 =?utf-8?B?L2FCVTJBcnY0dWhnS1d3YTlJcXcxRDBRZENqUXVMaktKTEpmYkNRL3psRXdJ?=
 =?utf-8?B?aUo5SHBHQlVyeEdpMG5Vd3ZKYk9KTng4T1NCdDJBTzF1RjlnVmFnRXg5cStD?=
 =?utf-8?B?TWloWmlJd1hMelpKZFowWmgzU2tDZXlYVlI4QUlZUzFrQVBLMkNKVThRcEZZ?=
 =?utf-8?B?QzkwNG5yeDhvTUNJWktIcEVoKzFkVGZ3SmFuMmUzcURlTVhDNk00anErUzhO?=
 =?utf-8?B?UU55SFhINkZvSnBhU1FWdkFGZ1hSVDI2ZTJNa2hSYm13aFZQUHdUN0U4eXF3?=
 =?utf-8?B?d1JNeE5LWmJqSlJqbU1JVDdwN2o1U2lVd0xmWGZRTDFYTGsvSkpmR0xCOTlM?=
 =?utf-8?B?anFmd1gvVjNEbHhCNXF4Rjk1cjBxOGh4aFBjSXRuUXhtamJvL050dkoyYWpk?=
 =?utf-8?B?Qnp3bnJWYVpNVkFZbG9qZkFoUzdkQ3RZMC9FOExZMkpkUVp4N3RQdlZqL0RX?=
 =?utf-8?B?bldTWVpjekpiYXZjVTlGRzJENDlzTzA0UHVFMEtTSmpRWUdSZ0RYRHUwZUh0?=
 =?utf-8?B?WTlRbGdQUjlueVZlNGpsOTA5b0NLZ2liNTNudE9TMEg1UUZBejVSSkhMQnU5?=
 =?utf-8?B?R3BicGwxSW13cHdjMVpQS24vNDJJVUQxNTg2ZkFvNWw1STJuQlVvYi9LSUxl?=
 =?utf-8?B?Y21DMXZHUlNQODVYdHVzSjFNenphdlY4cSs0aThpSUFLODdkK29sSFBqTUZr?=
 =?utf-8?B?RkVsc1hTQzdwK3NzMlV6cW1sOTZTV2dlazdPcWZDQUN5VG4xR0U2NDlwOHhT?=
 =?utf-8?B?Umc2TGxFc3NLeXpqQ1JEWmI1SWdyODBRM2FlWkVKb1BET0YrQk94REdkcVM2?=
 =?utf-8?B?T2hETzJPcm1qZ1cwSk5FVUVyK1E4dVVkZy9pVjNKalNHQ3gzSnBjRVZaVm9w?=
 =?utf-8?B?eFNkaU9QR3YySWEvNnE1WGdrV2J4Tys1Ni84YVZ2ZVFNMlpXVVVrdGhQUWkx?=
 =?utf-8?B?WFhBamk1RGxSK1RmejNmdFMxT3hWTjBjWFpKZGFXTkVuZ0V6ejk3NDBQeE44?=
 =?utf-8?B?VzVod0VKckNmVTNUeVA3NVo4VnlEcUl6VFllc3BhZWduVDZERmcybWJVODhN?=
 =?utf-8?B?NCt2N0N4b0ZEZ2FxclJsRlZsTTVmMzRERXRiSGN5VDc0aVRYbEtlelp3NkxL?=
 =?utf-8?B?aXArZWVWdEdWVVp2QVBtSS93OHVEQ29DRURXSVpKQmExY0l6V2x2cGZaWEZS?=
 =?utf-8?B?VFpNYXZYdmtaQWtXd3JVc1I2SXE4VlByQlV5THZ0TmphenFaWGJVeEZOSUhW?=
 =?utf-8?B?OXBkekh3eEN3RHNtQWhIeDFmZjZkZkNpb3ViNnQxbXNRa2JLSU4zUk4zelFx?=
 =?utf-8?B?dTU5YzVMaDd1L2NaV0RWVTRCT2J5cjl3eDBDM2poc01DMmlQREhRWSt1ZU43?=
 =?utf-8?B?bVN0elpTTE51SjNmNTJ5SGQrZHZVTVlXcFZ3N20wWks3Um0yV3pSZ0FVUUJ4?=
 =?utf-8?B?RU0yOXkrL01Kb09rVmZIaTd0eFpTYnlrRGgvWmtXMUh4YlltbkxaTHB6bjlB?=
 =?utf-8?B?ZXFlbW5JVjdvblA1MTNmY0U1NHV0TitmSElvQ2FQSW1jS0hiOEVwMTZTU1px?=
 =?utf-8?B?Qk9TT0FCUGdqSDNEdUJhSEhHTEp6ZURKaFFzNTlleEg5VUNoLzNOamozZENX?=
 =?utf-8?B?UFBxZ1gyQjcvUHl4OVZPaE5YSE9iQ3NtNU9GOGE4RWY3Yy9TWHg2eHN2UnZ3?=
 =?utf-8?B?V1RDRm9LaTVRN2JDbDVvMWkyK1FCZkxSRzJTVjEvMjRrQVRyU1FnTVFTUElU?=
 =?utf-8?Q?9KYYyTXksFrx7OXWrN0XkVMpuEsHENDB?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2024 21:38:21.8785
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 704131eb-9ecd-4b40-3f90-08dcc0973f9c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5890

On 8/16/24 5:59 PM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Kim Phillips wrote:
>> From: Kishon Vijay Abraham I <kvijayab@amd.com>
>>
>> AMD EPYC 5th generation processors have introduced a feature that allows
>> the hypervisor to control the SEV_FEATURES that are set for or by a
>> guest [1]. The ALLOWED_SEV_FEATURES feature can be used by the hypervisor
>> to enforce that SEV-ES and SEV-SNP guests cannot enable features that the
>> hypervisor does not want to be enabled.
> 
> How does the host communicate to the guest which features are allowed?

I'm not familiar with any future plans to negotiate with the guest directly,
but since commit ac5c48027bac ("KVM: SEV: publish supported VMSA features"),
userspace can retrieve sev_supported_vmsa_features via an ioctl.

> And based on this blurb:
> 
>    Some SEV features can only be used if the Allowed SEV Features Mask is enabled,
>    and the mask is configured to permit the corresponding feature. If the Allowed
>    SEV Features Mask is not enabled, these features are not available (see SEV_FEATURES
>    in Appendix B, Table B-4).
> 
> and the appendix, this only applies to PmcVirtualization and SecureAvic.  Adding
> that info in the changelog would be *very* helpful.

Ok, how about adding:

"The PmcVirtualization and SecureAvic features explicitly require
ALLOWED_SEV_FEATURES to enable them before they can be used."

> And I see that SVM_SEV_FEAT_DEBUG_SWAP, a.k.a. DebugVirtualization, is a guest
> controlled feature and doesn't honor ALLOWED_SEV_FEATURES.  Doesn't that mean
> sev_vcpu_has_debug_swap() is broken, i.e. that KVM must assume the guest can
> DebugVirtualization on and off at will?  Or am I missing something?

My understanding is that users control KVM's DEBUG_SWAP setting
with a module parameter since commit 4dd5ecacb9a4 ("KVM: SEV: allow
SEV-ES DebugSwap again").  If the module parameter is not set, with
this patch, VMRUN will fail since the host doesn't allow DEBUG_SWAP.

Thanks for your review!

Kim

