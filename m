Return-Path: <kvm+bounces-29856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C3709B3368
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 15:24:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A56511F24A1D
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 14:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4412A1DE88F;
	Mon, 28 Oct 2024 14:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="r2WuM9ll"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2085.outbound.protection.outlook.com [40.107.95.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8AC1DE88D
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 14:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730125405; cv=fail; b=DgX1588n+w/ksnX63kiks184tgn/UYElRZuLhbpNO85fVo3KFfIwMuMkkxHSO2y2YrJGR3vL6atVvtrJ8Gw/9DIsuru+z52whyQF8NJ2AFbLQeo/tiSBSGARj8RSwvqknrgkdlyk/GKM4/Bo3VoQsE6HDJedzpPxHpnha6d4wZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730125405; c=relaxed/simple;
	bh=Mn3JNXdzoiJxtNIZWXmIdhIIzVhvm11INv0Oney9bSY=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hZeZtnMinkAtYnOkGPBWxI4FlhouxPTElIJCJL5tT0K/YACjjTry5yszq8v3TANJvpUT86y6pV1rsssUi/HEuJmaGfoSNWmSkas8JJqV7oFPqHG+6e+7EYTUe5N0cktMjZMJA2vmrqiRnhJYmZ9wl573zvs532Wp4nn/NfpLX2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=r2WuM9ll; arc=fail smtp.client-ip=40.107.95.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RSTC6sl1ZfOM1f65EoXQ5IYPxyVoQtRRidon/krvOb34yAiX0nCAJW1ekjJwky17bh5NwhqiyuCC/hNX+jCjHN4PM/5VMdUsX9Ljxaqk5Ro0FRZXd24CKrDq9BLfThCU4QDXeQBM4o6M6O8f6Jojp+THHK5wKocY/f/qnxB780UydLaHuCQHHAJuyA5pKtWXq1uf6Wgj53L28qYJiFC5+Yw6MPeDcqrGRwXEQI5sXoGh96DHHwssiw1dyBKaKDeBg6tNYs84XeE7+p0XZ5rsiCHeSveTS/rryrIb1f1+bqryfvLkwfQhTbKTe57fcN9Jn2tzknxtilFgwOvMkk9l3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ngOYfgK3YXABmkTycnflPThmzFVqqUyg9/NtVQeZbuA=;
 b=Y79ASWmrZuah7moMzjMVUEVrid/zlYEk/SV3UeUxeYGobzewUPntGDFkYHzhKLpzWX2tw6yK2AQyxCgCH8w5f0oiVXHwXSUJG5AxHMR7hRZ4tQ/C5RZZtuh/mIarzjwKB7di7a8QwwCLEwvECasVL3RGaojMWFMlmBTDAXGisP9/fuUyxSM8/4TEojvhmHq0CyoveebUHdcacMtdFFcZcn20oQoNqj0fxlkHovJm67IewBHSCOD9M01pwjM8Y7Sus0B1wQTBehEvLWubxb260VQ/MsgduaehOmHDBjHkGC7MWxwwfbM6mf/Y+fQ2mc2IbGEcCgurTeczhZYaErbVOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngOYfgK3YXABmkTycnflPThmzFVqqUyg9/NtVQeZbuA=;
 b=r2WuM9llSK5ET8gDSgNNC3EpX6e2+gqfi20O7wQj+a7rFZGX6X6McFPVbRbAdlKLsCe7GOd6AwkBNOzl9eEZv3H19tFex49S+NCfC0Rjb8xmpAfUfLyvc0voxrfzNTYYZnftzhoDDM3j+5Gz6gol/v937+wMIKBu3Dwbd/BobTI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by SJ0PR12MB5661.namprd12.prod.outlook.com (2603:10b6:a03:422::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 14:23:19 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%5]) with mapi id 15.20.8093.023; Mon, 28 Oct 2024
 14:23:19 +0000
Message-ID: <24ea79dc-1a15-4e54-a741-e88332476646@amd.com>
Date: Mon, 28 Oct 2024 09:23:16 -0500
User-Agent: Mozilla Thunderbird
From: "Moger, Babu" <babu.moger@amd.com>
Subject: Re: [PATCH v3 0/7] target/i386: Add support for perfmon-v2, RAS bits
 and EPYC-Turin CPU model
Reply-To: babu.moger@amd.com
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <cover.1729807947.git.babu.moger@amd.com>
 <b4b7abae-669a-4a86-81d3-d1f677a82929@redhat.com>
Content-Language: en-US
In-Reply-To: <b4b7abae-669a-4a86-81d3-d1f677a82929@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:805:de::46) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|SJ0PR12MB5661:EE_
X-MS-Office365-Filtering-Correlation-Id: 25591403-eef6-4d11-63c1-08dcf75c11dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UENFRDk3TGsxeWY0aUIzOUp2NXpONWVXbk5DdHkzMXBqeHRHc3dBNDlGZUFv?=
 =?utf-8?B?MEF0QmpQTllobjFTbUlkQmdNOWZtb2srb0JyK1R6b2dFdllhcUI5ZStMSEVX?=
 =?utf-8?B?TlJJU2hqa0k0cUFzOEREaDNGUExYQUgyZlBtcmRsenhTY1BPc0VURkFNV1NC?=
 =?utf-8?B?b0VQVzRRMTlkTHBuVGZCZU94QnhtYkhhdHE3bCtLdWdQOFVrYnpsYU5uT28w?=
 =?utf-8?B?M2JmcnAvcDczeEhCZFRpZC9kOURtLzMzVnloc0d3RnNUM3NFMVRCK09HSFkw?=
 =?utf-8?B?Y1VUQWxOY1REd0toenFra2RsaWNPQlQwQkVUS2ZDMlVTNGJpUUxScFd2NU9q?=
 =?utf-8?B?YzlxUVlRQ2x5ejJXTWRmUzVTTzdESSt6dndhUURnemF2OXNDY1U3T0RPRDZk?=
 =?utf-8?B?aUV0VmNOVHIySEduUmFramNERlEzRWk3bjdNcXZYSzlxN3hQRGJxNTdQdXJW?=
 =?utf-8?B?TmluUFdlY0ZZSTJ5U2pTZXFiSjlyTWdXOG4vc3piWC8vQUlJeWJHMjFCVk9P?=
 =?utf-8?B?L3crWjRyckVpQUtScWQxMDdKTHZiUFFaM29NMGFNMDNsTGZ2aXkrZnhna0li?=
 =?utf-8?B?YmZRQkVTdlVJMWhCU2FaWThPYVNRd1lDWlNGUFdjNnozMFhlaXRoa1RhWld0?=
 =?utf-8?B?aWc4czR3U3l3bkZyTjJDMGpQWHNSVUplcGdUOWMraDd2N0VoTUFHOWtoVWJH?=
 =?utf-8?B?T0dFQ1ZWeEo4Tzc4RnZ3RGhZN3NNTk4xWTE5ZkptaS9MWk16WW1Vb2R6Mk5v?=
 =?utf-8?B?WU91d1lzM3hQcG1aSmFXRmR3dDFqb1haWWlKQ2RkY3M1OEhENk8wYVAwbG9u?=
 =?utf-8?B?M2UwZFRVSE1VZFhYbW54OTBPbGR0WW9tMVJDblQweHhPSHkvYk9aTUkyUXFs?=
 =?utf-8?B?dzl2Q3MxeE92NnVDZTRuK2UyM0ZvaVZlOEpXQ2k2cHBCeWJwUnZnNEtxQlBO?=
 =?utf-8?B?NkhwczJGYStNZk9TTWdWSy9NY2c3cXU3aXFEVVVTcUF0UW1mZlZVMjlLUFNu?=
 =?utf-8?B?UzBQd3hhRS9XUElCSExGN053THJhckkzK1Roejc0alEraXRoejZ2bjJyVkxE?=
 =?utf-8?B?dDdCSnFJZGEvWmdrUlMxWEtsQUJWcXBZcndyTERYL2VncTNoSytoM2g0UW92?=
 =?utf-8?B?RW1PeEZ6Z3pySlR0anRWaFN1anRTZmY4cW1LNzlMNDVoSzhJKzV4YzNPZ3V3?=
 =?utf-8?B?N0hWaVpYVWFtS1FoRWpnR3JXZWFITzFqdGdtSi9vblQzV2x6TjBvY21OcTNS?=
 =?utf-8?B?RmxPMG9weTNIOXMySGlxODd2a3lIczVZeUFOZk8vdWZ3YXpRckhuL1djMXlB?=
 =?utf-8?B?YUhDTGpRRjRYbTdWd2o1YUFucFJFc0JSOFVrRG1Yb21iT21HOUZXREUzaHQ1?=
 =?utf-8?B?ZS95d241OGFoVzJnbXM3Z3RWWkdCdnF5bUZPcXRFcThIQm1DTytsWWlZWHF0?=
 =?utf-8?B?bUgvVmErRko4ajJ2d3ZCVU5ML3VXcElMSnBiWS9LaVpWbUR2N1NnbU9iSjFv?=
 =?utf-8?B?VGdJaTRGZTFBYU1CcGpTWXlJVU9CYmZUQm0vUzNZVGNRbWRTSDM0UzJZRFJZ?=
 =?utf-8?B?QWVsZUxaSlhnZ2pQM0JDK21ZdERGRTEwRmZUaEgxTnA5emdvdklDNHNkT3ZR?=
 =?utf-8?B?VXFyWi8xMUZXcWtvOTQxZ3UwS2FuelQ3R3pTZ2crbzFJcnJXU2ZBMS9SdFlP?=
 =?utf-8?B?U3Brd1c4ekk2VHlpQkVRU3BZZDJyOHVOSjFGaVFaalh6QlZKUXlnTzh5bTNL?=
 =?utf-8?Q?L3pv8jFR8zC+0wsriAd0nrKDArQICjs9rhL+ur5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWhjK1FMa0srN3lmT1BWM2g2MUJiTXdjc3JRN0NJRXJMVTJ1U0Zoa0hSM3lz?=
 =?utf-8?B?N1BQN1huYjkvM05qT012OGtBYm5LMEZvK1R5eUlUN050cmY4cnI3bnVmTlZH?=
 =?utf-8?B?MFNvOE90NTlhK29aeC9NbFFQOTc3SHFlZWtzTVUvQmQ1MlBKYXpzVkxYQ3Jr?=
 =?utf-8?B?R3pQM2hpbTNna0E1UVJ6WDYrclc4YUczSzRzakRnL0Mwa1dYNjlNUExWb0JF?=
 =?utf-8?B?Yk84ZXJQbEIyN2tnUFAyN0o1NE1FODNqMXFKZThDUkJuNEpUNVArd1BINFE1?=
 =?utf-8?B?STRxN2Nxck4yaGVxb2pkV0VkWnRXaEx6RTd4SXNnUjZ6MWh2QTlnaWgvTDJE?=
 =?utf-8?B?WXh1Y2RWRU1kU3BkcXlybFVyR2lodUx1MEVQaFlvYXh4VDUzcEdTaVpLNHIx?=
 =?utf-8?B?VU5LbnpxU1oxM3JhZnlSMFdJSXp2OHlOT3c2NEhGYlpLRnZ6N1B3cktHQVRY?=
 =?utf-8?B?eG4yTnlXdEllY0xOdlRVejE2b2t2Qjh5QXR3bUl2a1FpS2VNT3BqcGlTVDBS?=
 =?utf-8?B?QU1yWjROQ1gyZHRzdXpIWGZ3bmEwTVdwMlNyT1B2TkYzRFJHUmtJY3FSRTRt?=
 =?utf-8?B?dGh4K3lERkNJMmZOcklSdHZZTVE2YlFBVkZ5NkoyUmN3b28yWU1kYVhCdnQ1?=
 =?utf-8?B?WVdBbDNJQUlXRGF1cmU2dVA0dEx2ZURiajlwYk45c1ZMWFRVN2hhdm9pUVpn?=
 =?utf-8?B?d2FzWk1TQzRPTGRlUUtZcVlpMzVOc3lWdzMwdDJicEFFWXBSYmEvWUFMeWhk?=
 =?utf-8?B?Qk8xT1U5TVhORndsK1M3NFBWaVhIOExnUHBudnBwcFNDU1FsVXZLeVFjOUVl?=
 =?utf-8?B?K2FlVDdjUzRBMFZPRDFETjVwWFE2WGlwRUtkMjZwaHlSckhwdkRHWmVzdDh1?=
 =?utf-8?B?dm5BdXZmVTM0dnhGTVM1NkJLb2FCVGJ1dlhCTWgvTi9YUnBoajdGN2pIUE5F?=
 =?utf-8?B?ajlZQWVwOEVxdnhPOTVwNVFvM3JZeU9Zc2MyVklVQ05obnEzMDIvckhxRTB2?=
 =?utf-8?B?QXdVWmxEZHByZTNoRU1PL2tpRWJJQ3JSTGlyanhaMExBOU81eTlQQytxZ0R0?=
 =?utf-8?B?UHBwRFlaSiszQWJzUXZscU44eU9OV1NTR2hkNFAzWGsrMWtDRUUwRmtDUGRL?=
 =?utf-8?B?T1FQb202OWNoZmlHcTgrTGZFRWJORXEyYjdSN0pQMGhqZzZpL1h5K0lWSy9K?=
 =?utf-8?B?SDRlRFZXV3p4UkNYbHpnWVVWVmdIN0NwM3ljTk5zeVN3WjZnem9xTytzSnFO?=
 =?utf-8?B?NkFpZUwzSk11RzB0OW11L3VCeHBOYmJaR3pLWVJ1K1NuQVdEMTNuSjAyMkt3?=
 =?utf-8?B?dVY5MGpBWGZ1UFRsRy8xOCtLZE0vTmR5eGhMTHRJQ0JyUjFNUUtkYnluZVRC?=
 =?utf-8?B?cFo1ZVpaYWVVWVJDZFYxeGRuUW00MDRXRUprY1RycFlRRWVtR3pPbmRsYVY3?=
 =?utf-8?B?b3ovQ0hyV0EvdnJGaGJkWXNOUHpFNGxyTUt0NWVQNDlnWU5uYkNVZXlwTVI1?=
 =?utf-8?B?aUFMdHdCU05QbmUrYlJwbmZacWpOa1V4SmZzam50cmE5RXRBRzZBanRrajd6?=
 =?utf-8?B?WUZ0RW1aWFR2MWFlTGNjQUhtMmphOXhEVDN4SmdDaGRIV1RoWTZnd2RlZGgz?=
 =?utf-8?B?TUJtdThVUExrRTRtRFZIZTNaMUlPRlBBbXR5Q1hRdHB3TnN1WWZDNldMbUJT?=
 =?utf-8?B?Z2tZT1JxL29tUlA2SU82amc2L3U5SDg0cnJZRkd1Nm9QMDErcjBpeEY4ZWg5?=
 =?utf-8?B?YXN0aWxqSnoxQmk3dDBINmE3RTBsU1MvWFBLVzNHMitXeDRXQk1WNlJtY01h?=
 =?utf-8?B?Mnp5TnVtV0NGVFh3UFV2eUpkanhwMjZJTGRqb3RRU2ZsRWRiaFBCNGNFemta?=
 =?utf-8?B?V3A5K2M0OXd6SlNnVEtKVE9icGdWa1p1MTg2UStCc2pOelNrY2c3ODhZL1J0?=
 =?utf-8?B?dzE2VGxBcGhIOTlwWHBtWGcwWFE5cFB1Y0FhbWZNZXh3UFY2dHdJYWx3SU95?=
 =?utf-8?B?eHZ5eG52UGNSWmRoR0kvY3R2a1hTZDZtYzViRkQydEdlN1podFBsQkNRUFhu?=
 =?utf-8?B?clV4VFJLVWx5bnh1TE9QTDNBMG00U2l2TkRBVlZZODlRZ1NqMWFXd0dFV0JR?=
 =?utf-8?Q?3LJ4=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25591403-eef6-4d11-63c1-08dcf75c11dd
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 14:23:18.9979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gscni9YTFERFxifzRqCJs6UGHVQlMRtgoYCSFeXeYrqkaJgwAbeAyyBZzfixFZ7d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5661

Hi Paolo,

On 10/28/24 03:37, Paolo Bonzini wrote:
> On 10/25/24 00:18, Babu Moger wrote:
>>
>> This series adds the support for following features in qemu.
>> 1. RAS feature bits (SUCCOR, McaOverflowRecov)
>> 2. perfmon-v2
>> 3. Update EPYC-Genoa to support perfmon-v2 and RAS bits
>> 4. Support for bits related to SRSO (sbpb, ibpb-brtype,
>> srso-user-kernel-no)
>> 5. Added support for feature bits CPUID_Fn80000021_EAX/CPUID_Fn80000021_EBX
>>     to address CPUID enforcement requirement in Turin platforms.
>> 6. Add support for EPYC-Turin.
> 
> Queued, thanks.  I looked at

Thanks.

> https://gitlab.com/qemu-project/qemu/-/issues/2571 and I think it's caused
> by the ignore_msrs=1 parameter on the KVM kernel module.

Thanks again.

> 
> However, can you look into adding new CPUID_SVM_* bits?

I normally pickup bits when it is added in kernel/kvm. Are you thinking of
any specific bits here?
Thanks
Babu

