Return-Path: <kvm+bounces-52308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD48B03CDC
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 13:06:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9521117E271
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23178246799;
	Mon, 14 Jul 2025 11:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Qzu6IB05"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2067.outbound.protection.outlook.com [40.107.95.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C99244668;
	Mon, 14 Jul 2025 11:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752491182; cv=fail; b=Kd79BWifv/bF/zzIv+DrsNUYN53LMleA/unSwhgnL5AAoblTKrxLXTrZbL3H0v38MpPj4m1M5mlxrTHgeG1mFNNrFMZiKuIfCko/Na3kH0cutHJLnXuo1nCH/X0Ym3FuvVbxuAT/dBTZhiVcR8UCCcYmpTMRsUINawJdCdJiXyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752491182; c=relaxed/simple;
	bh=G2zMyJjg8w5Bpa+qnwj1k3jmU+a9hXO23Rn2wGzV/aQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SvskV1QpTfJSolmF8rC/tOqz1sfwMY7kqNYU8oaVvlRiCIpYQ77TOsyaJOmnB56ycgPZbX7z4E54FOq1QNpoBUkNydtx6cCHa2NPzItbGIsFpm0PBk68xnvvx6ErcNofouqlxVVHI2b6aGcaccmqq/bz4ln3EOs5TuqadOf+Hwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Qzu6IB05; arc=fail smtp.client-ip=40.107.95.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jvs9i+Ig4cBQZHd+ypMO/QzzbMnHFCxnzPzUdmNETGBmbj70oxFVeMUvu4MicfeWuYmx8gDyy6LB3cF4RokoYlvHUrC0F2+K4OaJPgHqzCVKcB11j/Dajj7TVVx6JigFM0Zc2kt5ftI72B5thKGs1G3kVgrqSGbGl3uZv0QB5AjtNepWF2slhsG/RK75ShreLCaxI6wgrV4jkd7oracrgNT85LjMQnMAycBW1sF0ABq8lF+pgJDCc2bk2l7TuEuU1bEue0LM34r+F1LDncAVIZKMF8+3nmP2VZTB+/h0Uoy6S3qQGLQ0MeM8C6ZxyjO9S2jwsB0cK68H3Pgksk6OyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qJPT5qRo8506dhGNtArrSbUpMezgdW7VExwDTs8Vto=;
 b=dt0dEtVuKU09chlplCQEMI71vEnf9td8ynqcTeDzLIU1fNgF//wg8dLJEBCRmv7Z0e8kMABrxzgiaR4TZYyHNIFnYHp6ODibSfXyBVMfvbjB7CUCCbwCGNE8DbLW0dN5LmyUunvbqhHZVnxioMKu0q9SxdlfvRqmrfna4kJYGTAjiLNbz8YLTB6cuNcI+xZzMicsrR3FpuaBt4JsRfBJx5Ww9VI/O+KB4oIHtrGSEcyIhQW8/aMNjrW6Rb3ZrDDk16Jp1GNuVA0swaunw8ayAlEPZ6pLF/jfLZBH8Ygrvrr8m/fRAxAdJyKdud9oFu+peolWW/3CgqyapRlxmJD8gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qJPT5qRo8506dhGNtArrSbUpMezgdW7VExwDTs8Vto=;
 b=Qzu6IB05/hiHvMHuWreo3HHMvHNBJPahqH6G0oZVoTjydJRTHr53I58xsZ1j8oUvCEXpzezTVvxB5VJH6Ig9/CIPua1epAyoQWT+piPR/G/iCgv5ye0i2seMeWn8kc0V+3zuWcqF5pt455YSkjFIPaMsEwSVmgwmbBYoSqwHYkk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CYYPR12MB8940.namprd12.prod.outlook.com (2603:10b6:930:bd::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.24; Mon, 14 Jul 2025 11:06:15 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%7]) with mapi id 15.20.8901.024; Mon, 14 Jul 2025
 11:06:15 +0000
Message-ID: <eb688e2e-7b0d-447c-9985-a3b409f3b684@amd.com>
Date: Mon, 14 Jul 2025 16:36:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v8 16/35] x86/apic: Simplify bitwise operations on
 APIC bitmap
To: Borislav Petkov <bp@alien8.de>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, kai.huang@intel.com
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
 <20250709033242.267892-17-Neeraj.Upadhyay@amd.com>
 <aG5-PV7U2KaZDNGX@google.com>
 <20250714105248.GFaHThgLB9QnrW2xLW@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250714105248.GFaHThgLB9QnrW2xLW@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0016.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::21) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CYYPR12MB8940:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b24da5b-795a-4928-7006-08ddc2c6733d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejIxN0piK2xPU1UvQnNlbElPR0Z5WE9kQTJVMk5XN1JEOWY0VVB2YXh2VlV1?=
 =?utf-8?B?RG42Znc2NU5HYlBKK0xyWVBsaEtEVjZ5R3g5V3lVWFVzMzQ4c0pDcTFaNHho?=
 =?utf-8?B?TmFoaEtCODNoR21BT2ZYYXdNRk9NNlpyUkh0TDd4R2wyZVZ2akozQ1R2dDVU?=
 =?utf-8?B?cXh5Mlo4a1pPMWJLUDFoejkvdFN3Zi9KSDB0ZXVhOTdZeFpDZTR1cWo3cVZK?=
 =?utf-8?B?Zk1qT2t4SmZSQWxPajNBYUV2VTNHTktuczJlVFFYMHVvWTRNNjBad1hYR2lD?=
 =?utf-8?B?UkZlU3BJdHc4czRLWDBqc24rcFZtNnhGVVVEcHZkT014U2RtTW1UbTVPdHFN?=
 =?utf-8?B?cFhPN1c2N3BINkxGaVlUc2VLYTFFNlZwT2dkVW9FUU1NalhsZ01YMHBNejBV?=
 =?utf-8?B?a05BMU1kMXU5VVpwMHZyaHRkRlZCVG81bmtoVEpJQzdkTHlPNEdHRnFNQ3Iw?=
 =?utf-8?B?UkhJMmpvOE15dzZVc2JSbWtaZldseXF1czA3aXBuc28rSkl0bDdXU2NIelJF?=
 =?utf-8?B?TWJZSk52ZWpseGt5UFVJZ08vUWQ3aGlxTUVVdGZlOGNiZlYrem5oOU9CVklt?=
 =?utf-8?B?Q1NURXpPaVR4Z0RoZFgvcW9uaEs4cHlZR3hPYlRTMXdZbDVnTlU1L2tlN2Vz?=
 =?utf-8?B?amV0SVR0dVJuVW8zbTF1RXN5NDRibXpNcTI5Z2tKcmpjMWdsN2JBbHdSWGor?=
 =?utf-8?B?TmF1SHBRWjk4QUwvbVNvZEVkZHV2R3h1aUg4YzVGbHlZQ0VrR1ZrdThka0NY?=
 =?utf-8?B?U3BiU05VK2J0OHk3bmRzL2hzQ1E2N2FlVkRFTUN2Sk45dkkwaWdWc0NETmRM?=
 =?utf-8?B?U1haZEdTWlpxWWtFc0w5UndnencveGFUb1dJNGFBeUxySUpwVEFhT2dqS3pB?=
 =?utf-8?B?RlpxOVZMWnRFRjd0SW9MRStONDViTHZlNFdYcGRUU0E2REJtbmRUNk1GR0ZK?=
 =?utf-8?B?MFVRTGxFZWFiYTY5TUZqV1gzcFl3cStQRVhYQ2h4aEJkSkUrK3NCbldIU09j?=
 =?utf-8?B?YWhSU2xzWW1EZUUxSDN4cHpENk8vVFhXYXVNVnJRVm9VcDdjV3JHNXVyYW40?=
 =?utf-8?B?ajQvSzBDUE1VcU43bjMydmdlMDFqOVB1TEY4bWo3ZmN6b0tFTjVrbGhtRThF?=
 =?utf-8?B?cjVKcTMrZjUrbHNycUJ1UThHMldZZTBtSUMxUFJuUUY4S1JiTG1WOXpEazdW?=
 =?utf-8?B?T0FkR0dlOEh0b1BPQVBUeUEzM0VPUjFUS1MxcWxoalF1N0Y5VEZ1VWlwZDRS?=
 =?utf-8?B?MTRSSEZwTXdMRVlGSGRtbVQ1TGJhS0EzTnlnNWMwWXVlVlVKRHRxSmpMN2hz?=
 =?utf-8?B?QityNXRzS1NmUkY0OGZFNVIrL1BvQzAwcjVkMjhlZVdHeEpQOENsN0JYY25p?=
 =?utf-8?B?YlhXQkthQm1UU3hpdTdHR1N1b2tPWEltTjJEYWswZnM3TDhYbktjNXpzM2Mv?=
 =?utf-8?B?aGs2bENHUjhUM3pLWjRweGpwSlFhUm9rV3JPVVBLT3BUZnl3RkQzRzlOQ2U3?=
 =?utf-8?B?UVJrMFR2K2JBL3VHT3dSa0Y0TDlndWxZZCtRc2pZTXNRY3MzbXFSYUl1bG50?=
 =?utf-8?B?b0lyTEkxckpaS1M4ZmRLazR1OHdlVisraGNSMVFDUjVJT0dQaGFvZndoSTd4?=
 =?utf-8?B?K1ljcjR3N0lNek5WOGlRR2htZFZHdzREVE1jcVR5RzgrSWFJa2RHckVxc0x2?=
 =?utf-8?B?aElXSEJqWnBMb0dtL09GZSthaU1ObDVMaXV4UzBta0MzZjc4R1VoczlWZ201?=
 =?utf-8?B?TFpLQyt3dFR4TlNmeVBGSlI4K2Z0OFRyeHFkb243MVBLZmhpemV0d2VsUTRN?=
 =?utf-8?B?dVNia3RrYWxuekUvNGY5eU50aVhFZmFrdmlqd1JQbm5mTEFLakpadWZ0M0VC?=
 =?utf-8?B?Uzl5c1BvbHBmbXhhcTlPTjA3ZWE0ckhVdWlsWTE0LzJ2d2xzaXdWbEoxZXZX?=
 =?utf-8?Q?H6mGkjHfup8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OVNuY051VjE0QXJwd1YzYTlZWkVSc0lWZ0JlRFlUajlTVkNad2swb3BjcXhY?=
 =?utf-8?B?dk1Ka2lSWFFVdGV6cWVIUGRSQVRYZUFFYit6NmIxa3NpV1ZVYWx2Nld0dkp4?=
 =?utf-8?B?R2wyODJLSlZ2czR2eU5OMFhwN3A0a3B1TkNHTHNudEg5MmIrdndkL3RvcUVF?=
 =?utf-8?B?Y1FqRTB3dkgyYVNTbnRxRUFqUW5hejljaDlWNEF4ZXZTQlRIRHBuZVR1M3Nm?=
 =?utf-8?B?SVNmQlhSdFQ1a1BNaDByL1lxZ2g1cDhYQzNhZzVyQVpJSVZjQXhCeDdDdk56?=
 =?utf-8?B?ei9KOVJmVFdkUTcwbGJiMTJGQTRRSEk1d1A2ak5YR1EzWFQzcjlXbnJPa3Ev?=
 =?utf-8?B?U29XODVHa0VyYlR3anNKNjFEeWo2RGdKeTBxNHZmbEtSaU5JeGpNd3BQK2lJ?=
 =?utf-8?B?WWt2dGZIeWRzSm8vRnNYU29MRWZSUVpwVEFrMytPZjBCd0ZLamhtWDZQMFpN?=
 =?utf-8?B?ejR5bk11eEFxM1JqN3d4WUZLdENLeGVNK2Z2N09QM0ZZdHgva1RyOG5TaEJO?=
 =?utf-8?B?N0xaRnFGNUhTekErTmZnR2txdXo0bGdSK25wbnVMVk1Td0hwMFN6YThkanZt?=
 =?utf-8?B?TkRkaE1qQ2cvek01N1QrVE1RbTlxejF0ZWpMQWpzS0pFdHR1WXZqeSt6Wjla?=
 =?utf-8?B?WVdudCtmVW54T1JlREVGN0FibjVWZVRVdFdrQXVpYVVaK1dTZVg5UlhFcEd4?=
 =?utf-8?B?YitBZEJSQUFpOXNKZTdpeHBuYW91NGVYbll2MDJnV0x3VTA4MzhVTG55bVcx?=
 =?utf-8?B?RExJbnMzNC85QjZBZzA2T2ZUMXhkWkJNVTZBYzNIa0ZzSjhaZUsyb0VNRUp6?=
 =?utf-8?B?c1NSREswaVM0T3hJMTZFKytGa3IxcmVZRWRRejJ5bTFwZEFWOEFVMHhZM1Rm?=
 =?utf-8?B?eWVDQkhLREVDbWcxbmM0MnVPTFc0cFBoM1VyeC9QWTRCT2ozM3hyZkRaZDdR?=
 =?utf-8?B?dXlzUmI4Q2FzbzNqVERId1liZVBzS1lrSjFOZEJZWG0ydjdaakM0TjhUUlo5?=
 =?utf-8?B?bWdvcmtESGkzQTJVcUdmTHpaWFplN21NbE9JaTc5V3IyQjhCN2JxU3pXclU0?=
 =?utf-8?B?bUZnbDZkeDFrclY5UDRxTHRUL0RuL3BSQkxZd3labWpyendzTjFHRDMzU1VH?=
 =?utf-8?B?QlhQbmIyaU9kM1Juc0g2RHh6ZWZsSHAxSThBTXBXTVdRZWlOdGhrRU5CUFJX?=
 =?utf-8?B?dndEWFhMSUx5NzhKTHlJeWRja0ZCR0YvNTA3dUlzRWlHQlM2ZThGZmJHV2N4?=
 =?utf-8?B?V1NMdkgwUWZ4VVA0K2hCaklNVndYZmFlYTdoUHFHYVNjVTFDRGRwcnJWNkhY?=
 =?utf-8?B?dHUvcFdobVJSdis2bXRNaG9hRUplMWxOOEUzU0MwbGpGNHAweWh1cEJNZThY?=
 =?utf-8?B?amY5TW9ub1E0U2txYW1pUWU3ZCt2ZTMzVDhqRzZUMkZTV3pLenIyTDFGU3Ry?=
 =?utf-8?B?ZWVPRW5yWkkxc29sZ05KK0lWbkNwZSsySUU3V0NQV3BJanlwMjVWaUNYOEtW?=
 =?utf-8?B?SjdpL3RVSXFXMDEwTGNDUW1wai81ODlYODhxV1FCWDI3OHlCS0g5UFdXVVJI?=
 =?utf-8?B?WW8wVnJ1d0VrVG9wVTR6NlhwbThMZnF5QXFsRWxJREI1bWxoTnlWay9uaGwv?=
 =?utf-8?B?M2pGc0l3VGNYZGdmbW82WEJaZ0Z2dll3QWFORHNnNkpQT25McXJLQTkrVDVG?=
 =?utf-8?B?QXBCUnM3RTl2V2xwODJtMVQzYWpEOXhMNVZRT3JEUENlYVpHaW5rT1FRd1Za?=
 =?utf-8?B?cVRpSTUyVzVmVFkwa2lhM1FJMlJQZXpjN1RjeVlnT3Mvdlh0NkFvYzZQNVJT?=
 =?utf-8?B?N20zOXMwaU5VQjVrYmplTG5hbzJueWsvMmV3OVp0aGlId2J1ejV3aUIwZ1Er?=
 =?utf-8?B?TERQZm5SdktKS3FXdjVkOG1oMXZpWjJEaUV5U0tvYUhGNzY2YlpHT3V0eDl6?=
 =?utf-8?B?VDRsS0NNdWhZL1FiZGh1eTY3SkNrbGZMV2JJZ1UxTFlob2dSc0hMYWxkUnBW?=
 =?utf-8?B?MDFYQURSa1UwNnBWMjZidU5qcHVOMms0RldMTThxZy91U2pGQ0lTZ3ZNdUhs?=
 =?utf-8?B?L1EwMWxhVHVWbnlNRDZkYmNsbWhaYVpHNkU0TlpMRi9vbjk3YkdRRkUrZnha?=
 =?utf-8?Q?3cLoqxMSTyfnonaDNb274MScZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b24da5b-795a-4928-7006-08ddc2c6733d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 11:06:15.1755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lv/w9SuUBfDvURzD1h21DZKNj8Lrf8XORb6zNna9065TUVILJxV500VznLMGDZHL6PYsQAJTgIgRmxoO1bFkkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8940



On 7/14/2025 4:22 PM, Borislav Petkov wrote:
> On Wed, Jul 09, 2025 at 07:35:41AM -0700, Sean Christopherson wrote:
>> On Wed, Jul 09, 2025, Neeraj Upadhyay wrote:
>>> Use 'regs' as a contiguous linear bitmap for bitwise operations in
>>> apic_{set|clear|test}_vector(). This makes the code simpler by eliminating
>>
>> That's very debatable.  I don't find this code to be any simpler.  Quite the
>> opposite; it adds yet another open coded math exercise, which is so "simple"
>> that it warrants its own comment to explain what it's doing.
>>
>> I'm not dead set against this, but I'd strongly prefer to drop this patch.
> 
>>> +static inline unsigned int get_vec_bit(unsigned int vec)
>>> +{
>>> +	/*
>>> +	 * The registers are 32-bit wide and 16-byte aligned.
>>> +	 * Compensate for the resulting bit number spacing.
>>> +	 */
>>> +	return vec + 96 * (vec / 32);
> 
> I kinda agree. The naked 96 doesn't tell me anything. If we do this, the
> explaination of what this thing does should be crystal clear, perhaps even
> with an example. And the naked numbers need to be defines with proper names.
> 

Ok. I have removed this change from the current series.

https://github.com/AMDESE/linux-kvm/commits/savic-guest-latest/

> Also:
> 
>>     This change results in slight increase in generated code size for
>>     gcc-14.2.
>>     
>>     - Without change
> 
> What is the asm supposed to tell me?
> 

Intent was to show that the functional impact (perf/code-size) is not
noticeable.

> The new change gets a LEA which is noticeable or so?
> 

No, not noticeable.

> The generated code size increase is, what, a couple of bytes? Who cares?
> 
> We add asm to commit messages when it is really important. Doesn't seem so to
> me here but maybe I'm missing an angle...
> 

Ok. This commit was aimed at simplifying (which folks find debatable) the usage
of bitmap ops and to match how bitmap operations are typically used in other code.
The intent of adding asm was to show that functional impact is low (while
providing "simplicity").


- Neeraj

> Thx.
> 


