Return-Path: <kvm+bounces-37294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 505AFA2832A
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 04:57:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11CD83A6764
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 03:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C1A214219;
	Wed,  5 Feb 2025 03:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="v38Ee4PN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3BE213E61;
	Wed,  5 Feb 2025 03:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738727831; cv=fail; b=gtcJuyGpneDgF1iAJKY0NA4gJI7MTOvzmkmb/1lE35RMYQE5XHirrbe0kTO63XRyURiA0eWEtsDebAd6OKzZucIne9+Z9COyCTNw4fI8ojK/KVo/8Bzl0U39tClU7WrtvRtGx0HXEndT3k4uyh0u6F7+nUKh7vGnjzvJ+vXUSzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738727831; c=relaxed/simple;
	bh=MlUyThqqJTfZZ0IvZk7TYam0DdJ+vs4mj+bEoyiZvpg=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Z4eK+FO7biUPXosJIEmDpjM8B/9r0CRNwXR+muC9DBYPAiirwm8Nyp4GsWtfzGA4KFduwm/u9qAvgIu8zrNMsPR034oMgX2ZbeZl0gRH+6ZTF7RNhVlnksnunuOMV2Dd4aU3fTn1AQENdD0ZT6aQNSu2W41geUmkw8qdPwbb9vM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=v38Ee4PN; arc=fail smtp.client-ip=40.107.92.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pTJBtTusVK0nD8PYsY0uAUMlg2MR6QkI1qPn3rgEz70xJeBgCX2u3wimoKj4VS75AR2SWfJjwB0swXforR+s7wUv4HgoqdAkWo+5VNBqOr7L6W1jT9L1Tu6GJmcW9lQaZOkIYu5YPs5BM9WX6OmQihz5yd3lg3/edZ5IcxmPrbt7KVoOrwI2XJscddsYELyfkTI1qgcA+GhSezHLHBnWRHQHnRsxz5TyN7GAvejp24XeCdkHW+ZdiyoTRGE8c2n/0wVJ6k4LuZ9ZiGCr5SN7jZM+JBZv0cA+WQRLE0UveIIQu3/tMSU4XfWFcN8ilc/RPL+tWmdbeA0k/9csfe8cdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i6+sk7t4bAM/BX7tynfS1C6vfLCb4K2baMjAlthRoPI=;
 b=q5CDl/qfZ8MV1k3JF0gPeTzCg7ITZqnNqfnzXyfeQiBIcVCugaWLgUzWv3SQFU0e/LF02Sfe86RNdzG0d1QDgTh2uBL4Zzv25DeoD1AiicA9rQmQ+Wyxjk/uW0UX2096Bu9ch81UtGobzxP9caMrTeHDon1WQpBueOTpNACAuE9vZxOGvMO5Kqt3gMKpPkhrvh9LEURF5XZv9xM2s0wvo5Go2ec/TsDq+Iz2xDuF4T8DWJOp2EKJ4KD8SsTmihKzO0horQbbed+HjczVbk5MOeTnmDmgk9qg12usAH0Oj3mSxbvM52LRkuf8i0rm8NwDO4lUphqR5gn5oCfDyOJfJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.xenproject.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6+sk7t4bAM/BX7tynfS1C6vfLCb4K2baMjAlthRoPI=;
 b=v38Ee4PNxWyHqB6QDnj9iAiQq2V2xeeXAvRkQWbnjgJBGekFQ8C8ugRFzdnweqJDeZWYlRzstmOfcYmNFSQfJcgVZwXa66isRePv+iECKIASe8H3ORL/VU9omSfflsP5of09Jbi1yjZrzwYp6tiGDYFvwjjv3zOciSL6hqVizFs=
Received: from SJ0PR05CA0035.namprd05.prod.outlook.com (2603:10b6:a03:33f::10)
 by DM4PR12MB6302.namprd12.prod.outlook.com (2603:10b6:8:a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Wed, 5 Feb
 2025 03:57:06 +0000
Received: from SJ5PEPF000001E9.namprd05.prod.outlook.com
 (2603:10b6:a03:33f:cafe::f7) by SJ0PR05CA0035.outlook.office365.com
 (2603:10b6:a03:33f::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.26 via Frontend Transport; Wed,
 5 Feb 2025 03:57:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001E9.mail.protection.outlook.com (10.167.242.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Wed, 5 Feb 2025 03:57:04 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 4 Feb
 2025 21:56:56 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Juergen Gross <jgross@suse.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, "Dexuan
 Cui" <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, "Alexey
 Makhalov" <alexey.amakhalov@broadcom.com>, Jan Kiszka
	<jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>, "Andy
 Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<virtualization@lists.linux.dev>, <linux-hyperv@vger.kernel.org>,
	<jailhouse-dev@googlegroups.com>, <kvm@vger.kernel.org>,
	<xen-devel@lists.xenproject.org>, Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 06/16] x86/tdx: Override PV calibration routines with
 CPUID-based calibration
In-Reply-To: <Z6JqopU5LkDIZPq6@google.com>
References: <20250201021718.699411-1-seanjc@google.com>
 <20250201021718.699411-7-seanjc@google.com> <85r04e5821.fsf@amd.com>
 <Z6JqopU5LkDIZPq6@google.com>
Date: Wed, 5 Feb 2025 03:56:48 +0000
Message-ID: <854j19niwv.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001E9:EE_|DM4PR12MB6302:EE_
X-MS-Office365-Filtering-Correlation-Id: e7d08b4f-5c64-4378-3f2e-08dd4599276c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MTZxYnpidVd4cnJ0NVQ2K0RJdVhMU2NZL2pEdGRmZk9FdmplUHM4bjh4K0dp?=
 =?utf-8?B?aFpnWFdHUmtmSGdrN2F0TWYwci9WUVpUbXdPNy9qSGxTNnlGWXdWZGNUUyt4?=
 =?utf-8?B?czBJU3JoVjRIMitvWVZrTDBtTnlqKzVlVWExQzZwbVlOMmNCN1RKRmFsbXo0?=
 =?utf-8?B?ZFc0b0VUYWZ1Z05BaDA4aERGL0V3dGJISzZjeFg5Z0ErdDJyV1diREkxQ1d6?=
 =?utf-8?B?MVZyRGU3TlY1YWdBVEVNb2N3WEs3WWdIUmdQemZPMUJtQVIxZEFNTEUwVVBH?=
 =?utf-8?B?V0tCTWNUTGg1MFJaOEYwYUQrNDIzUVFleWpHeURoRUlrVWRKL1Q0dDIzZmwy?=
 =?utf-8?B?d1pxTURoZzFROEFib1ZUTCtiUTBLUjBwbHVGTUZJNmJqQUxGU2RGVkJ1eUJQ?=
 =?utf-8?B?Smd2MStrNDZtUDR4WDhpNFhsb1Vsa2NENDNrT2lXOVR3Ykw0YzkrYXFsajlV?=
 =?utf-8?B?ZWFuY0hvbXgyTXRxSWFjbGdzMUxhZWVXNnlIell2c2s3M2k4azR6dU80SDF2?=
 =?utf-8?B?bFdORU8ybStLZlE4RmJESFpOdTBMREJaSFIwdkNSY0kzbk5GUlRCbUtPdnJG?=
 =?utf-8?B?YkRuMDJYbDZMWlpuVUptelltRTNETEw5bTRhZUhwcTJPSG1WaG5oc3lYL3FK?=
 =?utf-8?B?bTRUaHdIUVlnWlJjNnQ4MDI4Q2N1REozOEVOVUNJUGw1cHJROGM5K1F0QjB4?=
 =?utf-8?B?TWgvc0hTRGN1SGVJakp0VjZxZzN6QzRkaFRJdFJtSTRoSEVKODZIZldzTmVt?=
 =?utf-8?B?Qjd1aVV4U3NvTTdKcCtnaEdzdWZLYWFTQlFtcVBWYmdSQi9aSUgzOXFqZTZi?=
 =?utf-8?B?eHR6NDM5V2xyRzNTRGliYVZyQllkaVN5SFAxUzhDZ013VkdRYmM2aDUyYnh5?=
 =?utf-8?B?TEloclJkZzFtSFVkVTd2UWwzR2xWQ2FvNTlPb2dPV2QxK1pOR0FIblNYcDVQ?=
 =?utf-8?B?RkFSS0dkRlZsNGVCQy9MWlJPS0JNUEJ1NjQxOHhXcFVDY1pyY0dNS0J0WnVq?=
 =?utf-8?B?dEszU3lXdEtGb24zWW9UNkVQMHFVKzA2QXBTYlFybjZrSkxVUlh0cGl1MUd3?=
 =?utf-8?B?TzJyeG1HT2djMXJST00vRlJBa0g0Y3IyRlpCaGlmSElMY2hkQjB0U0ZGMlJG?=
 =?utf-8?B?RUpGVHpUMUdPeldFVU42SnQ4bTBhZ0FvemlTRElGYmh1VzRBTCs3TVpyc1hG?=
 =?utf-8?B?eHVIS205cCsxSXlQWUUxZXVtN0ZrTGE3VUtCQUt3Z041MlFpZnQ0cHFFTzBz?=
 =?utf-8?B?RVhCWXZ0ZWp4WThEUjhKenhqN0IzckNaL1BWUEVJT0JaWk4wbU5teGhWQmVN?=
 =?utf-8?B?RlA3akxKUW5yQkRQY1crVXZJYXR2RUUxMTJNUEZRdVh4VmJnUGM4QmhCRVpT?=
 =?utf-8?B?RVBXY1pNb252ZVZkcCtEY0xQNDB2ME15cnVGbmZMWTE2c3NSL3N4Wlp4cTJZ?=
 =?utf-8?B?SXRhU081WllPSExLTXFjSEcvelEybkRaejY2Wm9IMG0zeGkxYTRXL3Q0NmZZ?=
 =?utf-8?B?VXpBMTJjbll5UXlGQmNvdjFibisvenp0dGFuUVcxVGFsSnFEYzFOb1U5VW0z?=
 =?utf-8?B?eGtLVmpnWVZvT0ZaVTN2QmhkdCtYeDVrMG40NUJGUkRmeExGZVpqRnVoczky?=
 =?utf-8?B?Sldlc1dwNWtRdjFFNW9PSzR0VkVHd2dGYzVaMmZRMjNXaEFDbGVOYWJqRzZV?=
 =?utf-8?B?SzRkWHROOC9Hckl4V1IzTW5KN1RFTmlNbFo5c3pyeHQxejJWYmJMWlVxb000?=
 =?utf-8?B?dE40d2NoT1ZHK0dCWUVCRUJoYnl3Z2lKSmQ0ems3NGtGU0ROWGVOaXJXNnN0?=
 =?utf-8?B?Y3dYWmtYRFMzTTZVR05tMGpkTHZzcDk5eXlxVndidGhPNTVrcG5TdW5SK1JF?=
 =?utf-8?B?TS90ZnNyNnY5dW5paEVITlJ5RHorS1V2NEg0UndtQkZYNmIwaXd0QytLTGpW?=
 =?utf-8?B?QXJvZTZpYlBQalpTRVpObml5bmpkcTJXeGdsS1AwdWJScW5FMi9wR01RYVdC?=
 =?utf-8?Q?ovbTXq5m08ro17r3jQf/qEb7yK4jUE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:57:04.8634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d08b4f-5c64-4378-3f2e-08dd4599276c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6302

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Feb 04, 2025, Nikunj A Dadhania wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>=20
>> > When running as a TDX guest, explicitly override the TSC frequency
>> > calibration routine with CPUID-based calibration instead of potentially
>> > relying on a hypervisor-controlled PV routine.  For TDX guests, CPUID.=
0x15
>> > is always emulated by the TDX-Module, i.e. the information from CPUID =
is
>> > more trustworthy than the information provided by the hypervisor.
>> >
>> > To maintain backwards compatibility with TDX guest kernels that use na=
tive
>> > calibration, and because it's the least awful option, retain
>> > native_calibrate_tsc()'s stuffing of the local APIC bus period using t=
he
>> > core crystal frequency.  While it's entirely possible for the hypervis=
or
>> > to emulate the APIC timer at a different frequency than the core cryst=
al
>> > frequency, the commonly accepted interpretation of Intel's SDM is that=
 APIC
>> > timer runs at the core crystal frequency when that latter is enumerate=
d via
>> > CPUID:
>> >
>> >   The APIC timer frequency will be the processor=E2=80=99s bus clock o=
r core
>> >   crystal clock frequency (when TSC/core crystal clock ratio is enumer=
ated
>> >   in CPUID leaf 0x15).
>> >
>> > If the hypervisor is malicious and deliberately runs the APIC timer at=
 the
>> > wrong frequency, nothing would stop the hypervisor from modifying the
>> > frequency at any time, i.e. attempting to manually calibrate the frequ=
ency
>> > out of paranoia would be futile.
>> >
>> > Deliberately leave the CPU frequency calibration routine as is, since =
the
>> > TDX-Module doesn't provide any guarantees with respect to CPUID.0x16.
>>=20
>> Does TDX use kvmclock?
>
> A TDX guest can.  That's up to the host (expose kvmclock) and the guest (=
enable
> kvmclock).
>
>> If yes, kvmclock would have registered the CPU frequency calibration rou=
tine:
>>=20
>> 	tsc_register_calibration_routines(kvm_get_tsc_khz, kvm_get_cpu_khz,
>>  					  tsc_properties);
>>=20
>> so TDX will use kvm_get_cpu_khz(), which will either use CPUID.0x16 or
>> PV clock, is this on the expected line ?
>
> What do you mean by "is this on the expected line"?  If you are asking "i=
s this
> intended",

Yes, that is what I meant.

> then the answer is "yes, working as intended".  As above, the TDX-Module
> doesn't emulate CPUID.0x16, so no matter what, the guest is relying on th=
e untrusted
> hypervisor to get the CPU frequency.  If someone thinks that TDX guests s=
hould
> assume the CPU runs as the same frequency as the TSC, a la SNP's Secure T=
SC, then
> they are welcome to propose such a change.

Ok, that makes sense.

Regards
Nikunj


