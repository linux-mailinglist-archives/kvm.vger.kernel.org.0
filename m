Return-Path: <kvm+bounces-26996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 138A997A075
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:41:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AE53B22F02
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0BC15534E;
	Mon, 16 Sep 2024 11:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oxSUzGVQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61B3145B0C;
	Mon, 16 Sep 2024 11:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486862; cv=fail; b=hkp0LV5SAlKx8wldC9B6lGI4nhr1djYxjHvDmRFkhE/+oe9QT0MbOyak9yiASc9NWvv24GPFQx+N5PcxFnA12XnDb+sarfV+UFJ1z/2PGEs8mOLlwaG0yM5+2mf59tWIgVGToLjXTfxBYH+BDMa97392waG4bD2O8gGka6bE6VU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486862; c=relaxed/simple;
	bh=K+do64utLZuPW1BLJvVFZ2wbP5EYLrJDsCGs03f7DAY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NnRLAFYYt2wPgIm98BUDiMa/uymPQqgMUjWHUguJdAf+GWifbSyGBPBCdV13PCxxsfqIYXB6XQvH5dE8jyryd5c67wtbIYo72E/ag9MwJWHEMugjYHxLQPFr/1pNgckDsl88lOMV2Ra9nAvEf0weu9YoeJmUDG78htHrTj1fRU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oxSUzGVQ; arc=fail smtp.client-ip=40.107.243.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VWmae4TxGfh5NJWwARJ7ERvfU14UPo31gum8z0CdflDCc5UvlCUXhU/A6GpbtDG2IsaHQO4uW7eIbh9AlNg0V+jsHB03DwF876ZbftIscN5ZAfvI2kxiKvDEVBvtoICeeI+/1Zc2H6o5lfUDHX+H8eDFzwlphVglL/3mbQJfUgX9UyTsxZYogPPwUnUaCQ9ktR7UH6afAQPSJO9WUuaYSf7zs5bE2hjQRrPfpV/oeip0ibgLizQRKXbaTxxmDzs8SAvHuMZ1rJ3wea0jPA+RyDzlewG9fhScOuy5W0CPDvp0d6Re2vSKev+W/BYSyWxg4RHQr4YhTax2WfnH02W8Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WJz7p13+zJ5cYJ9RdkR5aztKlYNs3YlzHPoHaz0SAw=;
 b=WuhpSqS2UIttxFK0AZXyuB+Oneh4S5UqH6r0yzCy3U6TID3GcLaUKgCYE/kI8Yp06ge7CzeDBB3lXzTCdRNB4gY7ot9Gxy1vqIC31AHubdjhDcidkDt79ozyeiRXYbsZSv7Un61S33/raV3xx+XT3XqsaCHXvM3xp8gEOtxQJ3+MemeerCQwUvNgab1k3FD4d48iqfya3/aNVfYeYOPZrrS5w3WPM1y7U9vOIUHN8gL9rbipdLPd4ZxKxgI8HlYuFoxl3MQ+maXHwalZkj/goekKsnqt3ms2eFYtiDuZLatbTGtXuvrR0Nqypmn5VPBOj2ETAtdKrwuycZPVgaCg0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WJz7p13+zJ5cYJ9RdkR5aztKlYNs3YlzHPoHaz0SAw=;
 b=oxSUzGVQ7UE9eEWjqK6+sYAGVbQSzCG5kvlItyYhs6lGNN4lFChu4gqan/9DXD8RvR1i/MxDI7jkeq0EimU297d8EYkdUagMCDHOKrQ81QyB2IXuRsRx8AbyvlH5IAtepcWAUAdYudqhjpACtqgrNsC9zWfYjqBOIpQr9eP8V+Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CY5PR12MB6324.namprd12.prod.outlook.com (2603:10b6:930:f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7962.24; Mon, 16 Sep 2024 11:40:58 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%5]) with mapi id 15.20.7962.022; Mon, 16 Sep 2024
 11:40:58 +0000
Message-ID: <7fe54097-20d8-fb9c-e79d-b62910b50154@amd.com>
Date: Mon, 16 Sep 2024 17:10:48 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 20/20] x86/cpu/amd: Do not print FW_BUG for Secure TSC
To: Jim Mattson <jmattson@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-21-nikunj@amd.com>
 <CALMp9eRZtg126iSZ4zzH_SjEz2V+-FRJfkw7=fLxSoVL1NTp_g@mail.gmail.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <CALMp9eRZtg126iSZ4zzH_SjEz2V+-FRJfkw7=fLxSoVL1NTp_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0233.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::12) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CY5PR12MB6324:EE_
X-MS-Office365-Filtering-Correlation-Id: 83c8d10a-5e5d-4b57-5e81-08dcd6446e73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3hSTHZ4dFBITnJhcFlNWWFDSmpKOWo1OUJ1WE1lT0tZUCt6WmpzWEtqbk5P?=
 =?utf-8?B?U2RDdnM4aUtkV01GVEppOU9vRHpuck1hMVJQVXdXek5BaHZ4Ris2ajI0WFZU?=
 =?utf-8?B?RndHeFYwQ0F2eUcrcjh4eGlQNWd4c1NKK0xGbU5QbUJyUlNTeUlxR01VamVj?=
 =?utf-8?B?bXBINmJORGNBNjhDYWtPeGF4VTBYZitwaG1QcURhKytlN0VwVDZ1SDBGU3V4?=
 =?utf-8?B?V3dQdUVhWDZYaGpWM0VGRThzTi9HamlvbWF0a2xPK0syeFlPOFFWVEN2RW5m?=
 =?utf-8?B?eWxGRzhlcSs3UDFVclpsYUlDeWdRQVJlaVRhaS9KclUwN0lrY3VkUFBSN1dV?=
 =?utf-8?B?WEFqVWVkZE5Sb0xYbXhaZWk3ZFRvbng3d2ZHT1ZzQTVHZ21UYnBielhOTm54?=
 =?utf-8?B?bTc5WEtTajdPVWRBbnhiNnFPUzJuMDFqblRIeS9lQTFSVm0rZEkwZE90aVdK?=
 =?utf-8?B?Vmp6NUZmMnljQkJ2cm45SmdYU0x6KzBCcFdVOHcwZ2J3MFhOUWJ2ckJ3M08x?=
 =?utf-8?B?ZFBUejNJU2tvWktqbnZIb3EvMmdWVGlqQjI2dE1PY2lHL3ZFaFNDNHFmVFlF?=
 =?utf-8?B?TjJrL2FyejZybHZMZmh0S0R0ZmpPbUp4NW1CU1lsWmlscGFhYys4bzNZYmF6?=
 =?utf-8?B?Wi9zeTVrNGlibDZDajZrbmJ1WmZwbmFzOWZZVXhWaHAxaDZ3UUp5WTU4MnRO?=
 =?utf-8?B?c1k5SUkySTJUTCtIdHhCRUplY2U0NHo5RXdsSTNUSE9zQ0laSDUwRXpNdHhn?=
 =?utf-8?B?L1RHUThkRmpnUTJkYjFaZnhFQnQ3QTMvSUtlbmpheWtzbDk5NFUzcG0yeElQ?=
 =?utf-8?B?ZjdYeHpWSExOK1hUeTZiRVFmclBRdFh2T2dCZDNISkRGcW5hUlhoQWVOWmFM?=
 =?utf-8?B?MnlwZnRhdDg5cU54REtMQnplb0s3Y1Q4ZzVVMDlOcEQwWjNrcVdVY295a2xO?=
 =?utf-8?B?NmEyaGxCRHdvakUyTE5pdzhZM3ordjhVUTBMZXYwYzZhUWppbTNkUnMwOGJK?=
 =?utf-8?B?YytYY2NQV2tqUTc4aGt4WS9kdkRqT0dIWXZ2VVdYMFhKMFdpYVlLNjN2ZEJN?=
 =?utf-8?B?VTRTR3RZQ2x4S2pMcmU0V2FjTTMzQzNSaWcrNzloaUoyMytsRVh0ZG5SczVJ?=
 =?utf-8?B?dXoyUFA5Q2YzY3l5NzNsRWpNdXF5Uk4zbWxiNGdhRW0xaUNrNWVjTERESUNF?=
 =?utf-8?B?Zm9URjNkMUNOZWJPR0JZRHlubXVWL2dZOHR2MVZaL05DUVBISkVnQ01MZFpQ?=
 =?utf-8?B?bVZuOWZXSFlWc1NoeUJiRmk2aGNyeXJGYnlZSUhTL0w1cVhCU2o0a3I2L08w?=
 =?utf-8?B?NGZZQVFMYzgzZHhhSjJZbWtvRDRCTWErc2RVblRBMVVRSnpJcElmSEFMV2VX?=
 =?utf-8?B?bEEvYk1VQzZBRVB0NCtjcURjYUFKdFJuWDgraDl1ZTBWcFU2Ly9KbjFxOEdy?=
 =?utf-8?B?U3NvSEpVZ2FPKzUwSzVlMC9LL3pLWjR3R2dYdTFzVzlGMVNJRTJBMmMvaWFn?=
 =?utf-8?B?TzAxVi9nMXFDUlpDNXZveGRpNS9FZlpPczV4b0xDYWp2ODNBT3RlQnRZT3hF?=
 =?utf-8?B?RU1UUjVWUjI2TmN0ZVU5Q0cwT0ttNHRic3h6ckY5L1FIQkl3TmVxTkM5Y3lv?=
 =?utf-8?B?TWVFWDFJWXF3aTVLR2hmekN2YmtxWVY3eTJidlM3bWQ1ekRucHdhREd2STJE?=
 =?utf-8?B?NWZ4ZEMwZTR1U1hZRFBLNlhxOHdYRkpxK043bGtYczd3VFl2RnBaRStXL1p5?=
 =?utf-8?B?aGpRVVgyaXRIdktPMkh6cHJBdHFJcjVlWU1TcG5IUGVZc2lvSUhTdnUyZUJC?=
 =?utf-8?Q?fWv5QSwmov2QO+1ajFpC6ZyOzkTZlaXl3wyDU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NjJFUmpZbnlJSXorUndEWWRIMmV2QitwdEd1UmVDOU1XanFvR0J0TWJxSHUx?=
 =?utf-8?B?cWhVTHFwQ2FSYU5XYnZJSkFxb0loM3N5aXhOQ2trdFBWQjFjSzBlWUlqMUdy?=
 =?utf-8?B?NVNrdnBjd3I4akptSVp3TTJhcU9VRWVLOE1LZ0xjNVQyVWZDV09DZ0RKTXNG?=
 =?utf-8?B?MXVaMlF1NEhmNlF4UU82NTA5Mi9Zc0R1YlpXbXBTTURFSnVDblVYRUx1aUtT?=
 =?utf-8?B?Ym0zYy82RkJhVEo2bm1xZFVZcy9LMWtLTmlqL25wdmUwYUliVkhLa2Y5R0lp?=
 =?utf-8?B?c3daQVdlbGkxcjlmWE9OYzh3dThBMXAxQUo3Y3JTQm1SRmlDR3FIcWpQMWti?=
 =?utf-8?B?QU5pbzNES0FkSE01WmJtb0JPa0UraHIwbncvNWh0MDlZTk1KQUVEUktpK0U3?=
 =?utf-8?B?Vkg4aXFqNHJ3TXc4cEU4WkIzeUdXd3lIbUFsRTNpRDVxdmsvOVhFQk5sa29i?=
 =?utf-8?B?djliNHdBaDBIN1RjaUtxcnhqck5WVUNEbnJGa3pBUUhCcWwzVVFGVmlQWHhS?=
 =?utf-8?B?cnNkejBRWjh5d0lxd1hDaEY1RG1wRnVXL2RFWjQ4bUJ6c2M2K211TGQ0Mlhk?=
 =?utf-8?B?M1RRMUtWSCtSUWI5Yk9uWWFyL0lwUUx1aTROOWgrMkhrcGFHcWxnUDFRb2hG?=
 =?utf-8?B?OEJvWmQyUEthQy9veE8xUFE1MmV5Yi9zT0poNlpuM3ArajRONFc3SzBaTnZC?=
 =?utf-8?B?eG1teDNWcEZWQ2dMclBDN2dBWWJnMmd4L09kSUFCUWw2YUNrR2dOSjcxblpK?=
 =?utf-8?B?bEdDbzNBeFdLZDdYVnZpSWErWVhLUmZQcENWaWVmcGxvSklnS3NUNUFmVVVI?=
 =?utf-8?B?RGVaajVDVjlRRlFnSzNPcFZTeE5ZTm16dFBiMlBUdE1jc043Z2lPMHJFd3NC?=
 =?utf-8?B?UU1XWnRwYXpJZ0RjYXNzbzBtMEd4Y2U4MUF3M1FsYjNOT0tPMmllTFhNd3Zx?=
 =?utf-8?B?TUl6clpWb1VzU3BhZ2VWdUgwVy9JZWNYbGJsbnpmMjJ1MkduTGNkUE0wc3c1?=
 =?utf-8?B?aDlFbzNJeXI5cWdRTEN2S1h6bmdZRlFBc01iR0ViV01BMFJNSVVYcmk2QldS?=
 =?utf-8?B?dklnT1l1cGJtMzAxWVZjdERWSGIyR0RkR2RBNGZ4d0dsbGFtaTRWYTBtMUlw?=
 =?utf-8?B?dWxpNUIxdXFJMDliR1RWbndhUTRBajgrS2luNUFlK1JWN3NmYUo1cnB6NXF2?=
 =?utf-8?B?cHpteVlYOFNuZEVTMlY1WWZJR0g5UjBlL1JLcjlQSDdNMUd5Z3FUb2lZMWg1?=
 =?utf-8?B?bVR6SGFBclNUS0xxQWJBaEtyVm5Jazh2bzVXTTc4SFhCL0p2VnlMTkJDcmxs?=
 =?utf-8?B?ZzhjVmJLOFJzZ2NjU0xPZU9kVjczcUJ5aEFzWmNjMi8wK2QrWmZVWm9qYzU2?=
 =?utf-8?B?RkVUaFdJNGxUYU0wbFY4VTl3UHVUVWFiTmZURWRuREZNU09DMU9QTHJnRjIw?=
 =?utf-8?B?K29FSkZPbVFlREg2a08vRTdObml1SmREQnI3dFo0TG1ydkhzVHF6SzZZYWRx?=
 =?utf-8?B?N2F0MWhsYkJvb0wvckxlN0gwTlpQSHAwYzg4THdFeVFXMGVIU0hGc1V5ZHJC?=
 =?utf-8?B?MGhYaXUxU00vMWhZaEpqWXZQTjhkNlBaY3JsQ0dtOGdTZGllWVFNbjJJanNQ?=
 =?utf-8?B?UDQzMHQ2dGZFUksyMnFwMURSbFFSYldDaDZ6RGRkVWRsK0lBL3cya0xjdlFt?=
 =?utf-8?B?L0xGdGd0NlNXMzNUU3lNSzJXSXhOdVppcWtNblppUHZXcStkTmlJbnRLQzll?=
 =?utf-8?B?cmt0SDBGNm1SSU93Y3l3alFSMzJyTFFFOU9sc25TWnRCVEtwN2Y0YnZBNW41?=
 =?utf-8?B?SEV3aWhDMExha0tWKzcvakhscTdnSFlJMnBGVmZNYm4zNE9SdVJvTjFBSzh1?=
 =?utf-8?B?a3FNc0w1anRidmo0K09zSGxzSXBLbGZRNFdid3A0eVk2cVh0dXY1N3FSV0k2?=
 =?utf-8?B?NzBCVzdNb05CSWptcXJxUzR1cEVVSkE5Q284NHQ5TWEwMUx3YzR0L1BqWElK?=
 =?utf-8?B?aU1IQ1dYcm12S2JvdkRuZ1FmbFhiL0V3aGhpbXdaYmlLaFI2dkJ1SGdLWWhW?=
 =?utf-8?B?d3VxQnVMSXlqUUJmTVkyS1Ywek9lVXNxbXRXQUVySmZRSmk4SjBobnU3R0xN?=
 =?utf-8?Q?7XV4Ny4VzV5zuSZpzn7ujs6cj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83c8d10a-5e5d-4b57-5e81-08dcd6446e73
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 11:40:58.2731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T3uyMleQmQiAtuWVQjlhjUPc6J3egR8pV89u2Irz0HmUUw4U7yechLGy/p3aF86VyD1yss3H93kwp1sMDlsq9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6324



On 9/13/2024 11:12 PM, Jim Mattson wrote:
> On Wed, Jul 31, 2024 at 8:16 AM Nikunj A Dadhania <nikunj@amd.com> wrote:
>>
>> When Secure TSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007_edx
>> is set, the kernel complains with the below firmware bug:
>>
>> [Firmware Bug]: TSC doesn't count with P0 frequency!
>>
>> Secure TSC does not need to run at P0 frequency; the TSC frequency is set
>> by the VMM as part of the SNP_LAUNCH_START command. Skip this check when
>> Secure TSC is enabled
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Tested-by: Peter Gonda <pgonda@google.com>
>> ---
>>  arch/x86/kernel/cpu/amd.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index be5889bded49..87b55d2183a0 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -370,7 +370,8 @@ static void bsp_determine_snp(struct cpuinfo_x86 *c)
>>
>>  static void bsp_init_amd(struct cpuinfo_x86 *c)
>>  {
>> -       if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
>> +       if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
>> +           !cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {
> 
> Could we extend this to never complain in a virtual machine? i.e.

Let me get more clarity on the below and your commit[1]

> ...
> -       if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
> +       if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
> +           !cpu_has(c, X86_FEATURE_HYPERVISOR)) {
> ...

Or do this for Family 15h and above ?

Regards
Nikunj

1. https://github.com/torvalds/linux/commit/8b0e00fba934

