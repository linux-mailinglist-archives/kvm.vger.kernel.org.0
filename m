Return-Path: <kvm+bounces-56998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9695FB49844
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:26:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B51B7B185D
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 18:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CFA331B13E;
	Mon,  8 Sep 2025 18:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rbRpr8Tg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D723331AF18;
	Mon,  8 Sep 2025 18:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757355995; cv=fail; b=SsyFDyArqVg2omg9e3DX335uX4+NYb/o+1BxaaWzQTfrOgnIMlVDU2FvxTlrF+eOZeoTxUoYDhdIqZ8n28QzD5dkJb0MjYO/b2/o3FTCEBii5musZ79DwWwUWUDO4KUGLvQfcPzbeNBlUTfjVkqypuaiB3PcgVuOYBs1jYkyOCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757355995; c=relaxed/simple;
	bh=xn8b89PT8bLWOj1CwgXThBz4yrgU6vwOPYOwMdLCfzo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rN8Pqsqu9JOcPC2VSAAYYlIr1GCTYS7pmJOqg/bKxY4fTHfuUIHvKcidKiqt+d2KuzysaCRGBlodtfAPU8RPAJxxO3ZBEnaxzkNg/mpU5uNee48VECKeT3oZb8t1FhuMOIKN8UR7XTb7ZTaO7dCBoH81K/hMMXJUDOEejqt54Xo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rbRpr8Tg; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jn/WLRxOU7Hyk26RmfOkK4swplMTYtk7uWKm/WdaCtCsv7LSmp9ynhry+OdcFDjwk/cHSnY6IGbU3KIdmqbOZ7iHwcSSQmefIG5OOKOlLrs2wK4rNpJ32s/q+kNxzlNSMjxvf7xIQtItUd9dJlQtLgyTuAF/+8/lMhdlkxKkjPKJO2C6DhC/5lC/0g4DRH5gqmr/4kasT0JFeChttg0wh52H8NssLmMtm6l5cme+DgA7m5Afz3+z7dgm63xWpFFMm4IodAGTbvDEBS71ri0Zm3XlTg721EfJTl6N79PlyNikg0+/gL7DPBUs1K0+JyWI7rYEygSDsdkLBWY0UghUeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qGFtcHDxn54RXxFApk67Irt0yFD5H9BISOHIGBg0H94=;
 b=ZkHlafQ7kq16ifSRZGtPK8Y2rkvqUGPHewSOGEmCTsRFqn7/7lE9ELsfurF6mumMKfznrHsGYDvt2wl++lWGzzWMGp0ZGZ2bnoDRE0fPaZR7276d7B5ehKK0VNggvPA2guiBlqIyq1pvqifdD80og2RmlZJv/znI5nblGU3xihZVqUCzHb065ML7sSHaI2La1r8C0ssVSPmX2G0yYJU0xtFTFTUkN2ov3CnTbiIle2YM3NkcMDloT0lw76/Vg3R/SepwKJNqKXxDsn/7krMpc2BSGXpro0eI/GCClrcOtVoimu1l3VekRcdoUm9Dyfcy4tdwPb1zMDL6ybejcrq5cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGFtcHDxn54RXxFApk67Irt0yFD5H9BISOHIGBg0H94=;
 b=rbRpr8TgVc62nHTuuwMG7cQ7YsT5tgXVHCQivfvfFWvYwIFzD4bZ/IvFQid4lOVQdMxKDWz9NaI6CIC8OvD1QOGEzRp6NtBq44rpfh0dwDXdsPLC8/rIweBj1fFUBp0XwrncGCsbtWGoFyHWWKABjz4Fqu4ry26aSZxzeDUZSh0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by LV8PR12MB9205.namprd12.prod.outlook.com
 (2603:10b6:408:191::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 18:26:27 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::bed0:97a3:545d:af16]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::bed0:97a3:545d:af16%7]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 18:26:26 +0000
Message-ID: <6db614ec-2b4d-4700-9ce8-1bb958008fec@amd.com>
Date: Mon, 8 Sep 2025 13:26:22 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v18 05/33] x86/cpufeatures: Add support for Assignable
 Bandwidth Monitoring Counters (ABMC)
To: Borislav Petkov <bp@alien8.de>,
 Reinette Chatre <reinette.chatre@intel.com>
Cc: corbet@lwn.net, tony.luck@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, akpm@linux-foundation.org, paulmck@kernel.org,
 frederic@kernel.org, pmladek@suse.com, rostedt@goodmis.org, kees@kernel.org,
 arnd@arndb.de, fvdl@google.com, seanjc@google.com, thomas.lendacky@amd.com,
 pawan.kumar.gupta@linux.intel.com, perry.yuan@amd.com,
 manali.shukla@amd.com, sohil.mehta@intel.com, xin@zytor.com,
 Neeraj.Upadhyay@amd.com, peterz@infradead.org, tiala@microsoft.com,
 mario.limonciello@amd.com, dapeng1.mi@linux.intel.com, michael.roth@amd.com,
 chang.seok.bae@intel.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
 gautham.shenoy@amd.com
References: <cover.1757108044.git.babu.moger@amd.com>
 <08c0ad5eb21ab2b9a4378f43e59a095572e468d0.1757108044.git.babu.moger@amd.com>
 <fb2d5df6-543f-43da-a86a-05ecf75be46d@intel.com>
 <d3e4ddd7-2ca2-4601-8191-53e00632bf93@amd.com>
 <20250908150301.GFaL7wJUiowzdhWUbu@fat_crate.local>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20250908150301.GFaL7wJUiowzdhWUbu@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0101.namprd12.prod.outlook.com
 (2603:10b6:802:21::36) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|LV8PR12MB9205:EE_
X-MS-Office365-Filtering-Correlation-Id: 56842f06-90aa-4833-ab7d-08ddef0538cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTZGVU0zWmhDSG1qZ0hmVzE2NHVPYitJcUQ0V1Z4Q2ZaeGcvb2swYmFKQklB?=
 =?utf-8?B?TEFjRWlUSE9LbE4ySGxhb2dMQSsyZHRQeHkveU1Ld2czZW1lZ1BJck5CT0JM?=
 =?utf-8?B?bWlpQ2h5REUvTUpFOVhxZWpzY09vMmM0L0tjbWdzanA5bE5KTlBQNlU4VXQz?=
 =?utf-8?B?ajlyTmhiWUNtYy80MGlBNldZZ0xQcXd3TlgxUGFWd2s1Vno1Y0x4MXorbmwr?=
 =?utf-8?B?K3dEa3Q0SGNtUkFXL3cvOHBiaGgzRzJTQURnZ01XTWFPdHFqSmJIN2YwUUhI?=
 =?utf-8?B?L08xZGJDanBSTG1mbEJDYlMwZ0dPVDhnamlpaDd2ZFZDSkpPZDRwQlFra1M4?=
 =?utf-8?B?SnlLVU1nTlFzN1MwbFUwaTJYQXpRVHZJMXJUUHlRNVdRWG5Od2t4ditkU2Ux?=
 =?utf-8?B?OE1wL0k5Y2JmblBLamJOQUVnbDJnMFRPNHhFV1NUVGUxZ3FBbHNMQ0wvMlBL?=
 =?utf-8?B?cUtuQ1czbERoWVVuY2I0aXdkalJyaWprU3lPd3RYQmRlR2pPVXh0YkRCNGlB?=
 =?utf-8?B?TVR4VWJkZ2F0d3Nmdi9ONWRvQmZUWkVwbEc2WFkwKzJiaGNvRzJBMUFLUXVX?=
 =?utf-8?B?VC82UU9wRVYzNlNJRnNOWGRXaEdjdTdVaXdGSS9EUytKT1ZLSkNWZExvRHA2?=
 =?utf-8?B?UXhEN1BhTjdWUDBVQ1ZKeHB0eG92OW1lUjhQbjFBbEZSVGZPc2ZELzZoMFZK?=
 =?utf-8?B?T1BKVmRIdHJCYndUbGVNdkUrcCtWUFBNUlBhNVJ5UmlpdDZiSnJKVjlyMWdV?=
 =?utf-8?B?WkhwaFYxSWhRRDhsNVYvdC9ESnZoTUYzQ1ppdWl4RnFMdDZTTWZsY0VVZmN0?=
 =?utf-8?B?QlE5NkZkVnQ3UlVwWElCdlF4T2Z2TFlpNXpEUmZQa3dNVTVUSGFkNllYdkNL?=
 =?utf-8?B?OE12T0VwenhlQ0JGazR0RlAycUxxMDM1RHFORzNIVDNyVDRnZisxeHdRbyt1?=
 =?utf-8?B?T1paQnExdFQ0Q1paUTBSWGorOFJ1Vitrem50c0l2NUd4c1FLRTVvMXRTbFo2?=
 =?utf-8?B?ZFVjaVhIa2JqOWtweEZtODlNYURDRE1YUEJMRHh1QlFMZkpzemFvN0lITUJm?=
 =?utf-8?B?b1MraENDN2hKR2djcExrNlZlQWF3Mkh3ajhBN2g3bXI1c3NoK1ZwRGtVTzd5?=
 =?utf-8?B?V3hPUXYydVBMSVZNSTEwOGs1aTkrSDF6bm0ydkpMUW82c3ExUTI5bng0UmJL?=
 =?utf-8?B?YmpMaWVMUURSOFBjSnN1UERjdWNGYnR0Zmo2cjZqSVJQMlk4WXp0L0dodTcr?=
 =?utf-8?B?bUduTGhVMmYwT245cTJ4K01QQjRIUzZkbTNRNmdtYTN0MTJ6K0ZTbDRtMENm?=
 =?utf-8?B?VDFFNm9EOGpxZ0NaaXl2aUszeUZZSDVKdTIxRmhXTGkyM2xISlE1bE5nbWF1?=
 =?utf-8?B?am5YMHY3WW42ODErRkZjZVJsNkVITkhmWTF5WkZEc3dKQ2l3OURHOENxREJE?=
 =?utf-8?B?VGJKeXlBYkM3ejJ3Yk5HTkJaTTlJS3ExbVV2TzBQRm9rVUFvakxXa0FUMmRO?=
 =?utf-8?B?QUJhc2JYUHo4d1pML29LOUZnTW9iMWloRitudy9jcmVpZ3JKZGQwZC9RekRY?=
 =?utf-8?B?R21FQ3ZSTkk3S3lMQllMR20xZGJWUHNUWmJmYmYvdkQ0V0hPZ2RNVEdXWDBs?=
 =?utf-8?B?MEk1WFh2Mm5qdmdlaXV1TnJyQ3k1My9rdDJvYVhHTzBtcHduMFNzNE9nNktX?=
 =?utf-8?B?djVYN3psdFMxM3pSb3FPZkFreW9LUUNVTzg2TFNjTzE5RGpvZEY2OTdjUVBE?=
 =?utf-8?B?TG1reVlOTWgwRnZnZWY1QW9Qb3BsSnJxcm0wT1lMYm1SaCtDNEZrTUdlWVo0?=
 =?utf-8?B?M0Nna0tyWmlVU1VxdFlPQU9GaHFFVU1Za1lSMldrVVNYWHp0Nm1wVGh3UFNy?=
 =?utf-8?B?K0ozbEpCeWs0ZHNBZ1BRb2UvUkZFRXpiaWh3RmMvSHJRZVNpenhyRkVramFz?=
 =?utf-8?Q?BAWT/Q/1RZA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXZkRnM3OWZCSyttbnA1cUpBakNodFhyVWxDUmtYWUhpVU1MYk8zd0lBVmpj?=
 =?utf-8?B?MFVJNGV1THVlYmFXdE43b1M0RUsxZ0VZRnNETkI2dHB2bmZZVVk1RnNrdTds?=
 =?utf-8?B?ZnlJRXp3YWZoa3ErTjQ0dERXc1Y4RDJHRnJ6cFcveDV0aGM1UUhIZkFmVDcz?=
 =?utf-8?B?ZVd2dzZyckVORXJBbDVoWHVSZEVFQkJvV0FjT3pnVGZyQmZFV3p4czJSOHJm?=
 =?utf-8?B?RkF2UHpNRVlxNmQwN3Y2VmlxL2NKa2J2bW9NTm0ydlh3ZTZNMUJPc1VndkNG?=
 =?utf-8?B?bi9HWDhpWERNcnMzcDNxQzdzWmsxYmFGL2lEbVlUMzB4cWJNYnFFZmpleDhv?=
 =?utf-8?B?N0dvVFp1WEpLVmJXc3BKVWhIc3hlL1F5ZzFKQ2VyYUlZQWovL1VCelFST0hY?=
 =?utf-8?B?dEpUVWJzNmYyUUxEUFFBRFdBTHBWNmM5VXpRMnNERTAzVkwvRUtQSXcwQWpB?=
 =?utf-8?B?QzAvWmNRSStCRjhYdkRaamNWUkJDcjdQKzNPMmRISEErV3AxWEZQVjhJT3Vt?=
 =?utf-8?B?RUsvSTc1T01yRjJEVHZ3VWo2N01vTW51WU5YbSt3aTNYdWllYUxFL2pxTWIr?=
 =?utf-8?B?ZEF4cjRhS2tja3FydEpSM2hvMkJvdFdnbjA5MDFOMmgwU1psM1dVM3ZOT0pS?=
 =?utf-8?B?QkhrclQzN3lhYmhmbzgrdXJUeDhCSFF6WlJ2bTlma2lST2ZnbjVHaGE5VEZm?=
 =?utf-8?B?VmVucFIxNU14U1JwSmVrVzI5aVI2bjVnWUpLNmcxanMxSWtRN0NibDhoN00v?=
 =?utf-8?B?eC96QkU4cE9mbEg1TDdCVEsycGEwTXRMQjkrc0xybndjU1FaRnJVamowM25t?=
 =?utf-8?B?U2c5bEhnakVkMEh1eVhEbkJDdE9IelZrZFJsVHU5MVNJaUpKMG1NSGdtaEl5?=
 =?utf-8?B?ZmM3dzRXOHdwVUNLdDIwY3Y4WVA2eGFZaUszdFpDeTFXdUhQdUZBYjM4SUVT?=
 =?utf-8?B?QUJYSmE0dDE5OWxsaW9PazBLejA0TjZoYmdJWTR0cGFsYkxERU1xK29heHZH?=
 =?utf-8?B?bXJNS3lBb1NjRyt6L2pFdUZnNXhZUSthSnQ0clRFdWQvOEFOREcxRS9IOW1q?=
 =?utf-8?B?bWxTcmd5cGxmai9MbWpObTZBMXBYSFNHalA4bTdTRmo2UFFEcnhGYy9KY2lO?=
 =?utf-8?B?WEVaaEdVaG9SS3ZlcDQzRFZFV0x6SlZYYWxDTmt1bGM5THFpci9yNjJnRmIw?=
 =?utf-8?B?dGdmdjkxV2M4N3NtTjhHK1R1UThaYUEwTkFOZU9EQlZQOERjbjJLczFrempx?=
 =?utf-8?B?VmFJa3g2THpWbU82b2M1QXg4TGxNaTQveDZYeDd2THBub0MzYjFvbUkxWVU3?=
 =?utf-8?B?YVEyY2U0Y2RtdHJjd1JaZ0s4cDg1a1U1dVpPN2FzYVNHL0pjNFE0aDBTQjZr?=
 =?utf-8?B?QjFKUHBHOVhaakZJVzU5RnZoOXVkeGFKcnBwNDNTdktrQ091Z2Zmd1V0ZU8x?=
 =?utf-8?B?Y3gwNndoMEJCSVpFMHd3QUpmd01Wdks0emtrVnBaWHpqazcxVnhBMzhPbkVL?=
 =?utf-8?B?WXNBVXVDNmhZcGFpYVAyZS9iMUlDL2dYRmNxRTBKUVg3Yks3M0FoMUt0WEZH?=
 =?utf-8?B?YWMyUGtkR2x1QkR2a3BrRENvVnNvSGR4OElqMGdSb1hXUW1aTUJUZ1gzN1ZK?=
 =?utf-8?B?cm1HcTBmcmUyUWRtWUNhVlhtUHF0YStNS2VWM2hHem14aDdnS3FVc2h1cCtT?=
 =?utf-8?B?bDdaL2xmRTZKU055OEpra3FXSVgzL0g4R3hBZjF2ajcwT0hQMGI4bS90NFU5?=
 =?utf-8?B?Nk40aDRRUXpEbmJuVzNyMnUxb09DZlZtNHo3NlVYOHVXMGlxamZGc0JwUk0r?=
 =?utf-8?B?WGxNL0t3RTVJZlhhWjZlQmt4N0VjQzFUaWh6U3ZTSVM4c29pWTVBS0N3U2Zn?=
 =?utf-8?B?VEQwWldiaFZscVNhbEVtN3RuODlQOFkzbS96OG43WlY2QXg2Q3Vjd3NZNFhB?=
 =?utf-8?B?QTJxdGNlTkhzYW5GQ2pGWFVPRXdJTTZHcWIwQzN2aktZeG51VGpJR3BBakFm?=
 =?utf-8?B?aFJUZ25id2RQVVBLc0lQOEVzb2JKUU1KMno3Y2NiOHo1MnlEcmJQckRBQmRX?=
 =?utf-8?B?R1NnRHVucmlrVCtpVit2VzFIVDg1VjNJUnN6Ykxxb0RPemxsamtLdFFsZkJ0?=
 =?utf-8?Q?+1bI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56842f06-90aa-4833-ab7d-08ddef0538cd
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 18:26:26.5821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ig+2ublJQLz9cMsuLJzAnath1zhsYa7ifAPZK0vk3C+QM8uy5J6wrqwW1COeu7/F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9205

Hi Boris,

On 9/8/25 10:03, Borislav Petkov wrote:
> On Mon, Sep 08, 2025 at 09:41:22AM -0500, Moger, Babu wrote:
>>> Apologies for not catching this earlier. I double checked to make sure
>>> we get this right and I interpret Documentation/process/maintainer-tip.rst
>>> to say that "Link:" should be the final tag.
>>>
>>
>> That’s fine. It wasn’t very clear to me in maintainer-tip.rst.
> 
> You don't need to worry about minor things like that - our scripts fix them up
> while applying.

Ok, sure. I don’t need to re-spin unless there are other comments.

> 
> As to Link tags, see this here:
> 
> https://lore.kernel.org/r/CAHk-=wh5AyuvEhNY9a57v-vwyr7EkPVRUKMPwj92yF_K0dJHVg@mail.gmail.com
> 

-- 
Thanks
Babu Moger


