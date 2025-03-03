Return-Path: <kvm+bounces-39886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C4E0A4C3D9
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 15:51:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC91016DFA0
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 14:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A64C2213E72;
	Mon,  3 Mar 2025 14:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="glAD4uGc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6ADE126BF9;
	Mon,  3 Mar 2025 14:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741013463; cv=fail; b=T9aiYEGMxO+TicPZV15s7YcjwNmuwXwq1EOxzFGk9lHv0zi9whAczMMYkqo45MyidLsHXkHCGXH+sVchIDE/ylMd0MPlCVTv+p8sXIhLtUBfhD6E9J4SkiqI8El0IgE/1Tlw3Cj4zbpTn8RqxVKBlge6NRua339FWYRjWoKb+w4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741013463; c=relaxed/simple;
	bh=kqw9kuB3/pk5RqxR5clF4XmFB24noQPAlcNE6Q1xB/Q=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=mFeBxmefW13DUPMrHYbuCXf0OkgyWqCQUIchg4riM4SlwJK7dbYP1OYWoF/Cb/qiW1Ggxmqx8Rb8tDF+Cz6MhPQiolBEBu2ZBGE7iska9sklbdxa9YkZYaOie3YNgQzT/PumtSw6VbpQ0UDTFtfDLAuSnhKqsTIzJqqog5GE6Ek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=glAD4uGc; arc=fail smtp.client-ip=40.107.236.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sH5IKa6lfagsAcbnRhLSKYl8pe8yJv+h4HYJTStt2W7WKwsZO8rTzIWPZjuHSI96/UOM/nLtn8UUOBwOMEKILCYCx0/2MReljKWc1YAfD/OOaUl8cEEEd0bh0Wsst2GGDCMWVictVs3bJtJFLX8ikQneEfQ6tqeT757xwAy7/+0IBqDtOl/FScuY8GrFDysj3/HvrOK2/WmWbP29LJXUO7YciGedHcl3L9rtTeX38CGMoKu252WVP8wwHccZWjtMT7FeG5KdCuXwZl8o5ynRBRxlMsGg4yAQyaB7a7nXmzBptwVKmEBJhr3k9adGOl8Li3TvvFnNrErOegpDoCeP+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXPqAUe2OT7RWETZzvukxmLmIs+zCWFCHbyo317fep0=;
 b=Skp+0Av/8d9t6T0fL8BCmo1GtAMRV1Q1uFOU2QR6kAIvHXRWIWyyaL/dLB3zi8a9rd4NFZYxfLgrEQn2HFJwJKp9EEVqoP4VM6lB69lKKY6mJMFpOOuquT0vugFB+fusf8eX0/1KiS9ccthv9JABnz+cUiyYhuOStvYQbGf82I+X5wQ+8ZH6YyUQsTEDweHQ7UlZ2gKODN4x1Y/suejwCEsg9LwCne6K3OPM+awOZmbYQ2r+VqeM8l3Z3a+KqqbPgzgCWFt2SKQObtKhj30Ha9zC3YzE8jtRM6JBp2YMdMYHjTiYdVpdrCZR/A/AIc6eNk/7FqoVhBw9o1GwvR43Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXPqAUe2OT7RWETZzvukxmLmIs+zCWFCHbyo317fep0=;
 b=glAD4uGcnFeYkxgyzoJlx6a3mk9RHbJtWXmvI901u7sZh6GrN0zOTDA+6Xq5b7MMTSWx3AbMaPcArfWRWOCC80cX1ROyZYFsD1kx0jLYzxH6pOA1W44S+megCbbxoUVnfY0/muhZkeZj6HcseVdJOT6/k/d2xlFCziNWOP5Ui8I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB9217.namprd12.prod.outlook.com (2603:10b6:610:195::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Mon, 3 Mar
 2025 14:50:59 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 14:50:59 +0000
Message-ID: <ba92cd1e-a68f-9d49-ac3d-16368bb1f9df@amd.com>
Date: Mon, 3 Mar 2025 08:50:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1740512583.git.ashish.kalra@amd.com>
 <1d7b31af0eb36d860907c1e89e553e642f3882e0.1740512583.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 2/7] crypto: ccp: Ensure implicit SEV/SNP init and
 shutdown in ioctls
In-Reply-To: <1d7b31af0eb36d860907c1e89e553e642f3882e0.1740512583.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0126.namprd05.prod.outlook.com
 (2603:10b6:803:42::43) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB9217:EE_
X-MS-Office365-Filtering-Correlation-Id: afe09c28-9b55-4c7b-f89e-08dd5a62cf5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UTFwZWI4MXd5MGFMbEEvT3I0MC9OQjM5akFVYm14L1NiSWl6ckxGdHdHK0M4?=
 =?utf-8?B?QitkTkUybmdkWkJMVzE2WkxXdDRQS2I0NGJWeXQ2UmZvcHNjUE1raW8zdXdT?=
 =?utf-8?B?OHl5NmxidnhXRkRMU0RlbFViTW1DekRXUHJLVWFGb3U2WHUxN3diNkdsM2VU?=
 =?utf-8?B?VlNRNGVBbzdRcVp5bXU0czZXeXErZTFzOG0vMzlRNFl3a01Mb2piMnljUXJG?=
 =?utf-8?B?YkNsUkUybmVqS3g3UGZpWUxhb1RWZEZ0bFdwVzBZSnc3UmRmSWtNY0k5N0V2?=
 =?utf-8?B?SHVqbmVNdTVJQUhTUGdqcmxxL1BENkx0dEdDWTlaT1Nwa3lCc3R2dVYrRkRq?=
 =?utf-8?B?NEJvVGJNY0NSbThCdTFBRzl0dU4zUWdHOHNKSUorNitDUUVKektxakowZ205?=
 =?utf-8?B?T2RyU2k1T1I3WEtUWStlUzBOYXZ6Mm11ZEpYYUg4cGdGU0xGaHp4SGV4Y3gy?=
 =?utf-8?B?S1lHNkVwdUhzdE1WM3FuZENKTEZ6RDdiRDVjVlN0ZE5GQmgxQnZwVmpRUFMy?=
 =?utf-8?B?dVg2bDJzWjk1UkZ0ZjVVVEpFbEFBS0laZVFNdjBZb0IxR0xZcG1ieDRIUk44?=
 =?utf-8?B?SDR3MVJBVWdmQmJYYldQOHlkTERjcU0wcWF4VzJlZGJzQVlKOGRScjFCSTh2?=
 =?utf-8?B?UHVkc1grV0JkM1JucWVURHV2enhXSmFhZE14K3ROR01EdEZjUFJ6ekZuTER5?=
 =?utf-8?B?ZFJmdVp2NGE0dFRwN3V4VmN3QkZaSHBuSnFlOG1KNldwNjZlWGNndlhKeVha?=
 =?utf-8?B?c2szNVZLQUQ5SkJ2bnhGUld6SUFva1Nhajg2ZllsZGx5OWgvT1NnL29Gdkpo?=
 =?utf-8?B?VUNpS1Y5OVViTGNRcUxReDl5WWZkckFLdTNwVjFwQ2JQS0s3ZGRZN1ZTVGxl?=
 =?utf-8?B?Vm1PeVd6Z0ZTOVBoY2wzdFl2Y0czYUNmVXQxSHlYRDBJVzZxbng1dEYrN0RZ?=
 =?utf-8?B?T09VN1dhNHN6NllndjY3SWwvVERZb0I1VjFyT3doOXFKRXQ4c1F5N2JjYml4?=
 =?utf-8?B?eEVqZGU4OWpIczloK2U3VzVqb2FlRTBZeVdUdVVKVFdXdnhma2lFMU54S2VT?=
 =?utf-8?B?NHYxellqaDBNZmFXQm9jMXgzb2V2OUhjWnFHZGkrZWhRZEdhNmhEMmtUOG93?=
 =?utf-8?B?TEJKb0dGb0tGc2JmdFlyb3lqNllaTXNzdkNwYVd1cG8vWFdJdElEelZmT255?=
 =?utf-8?B?bVoyVklWYTZNWkJMS2dVaEFKVzdaaEZTQUtJT0ZHV0VnU1BEemI5OVYzZW10?=
 =?utf-8?B?dkFMU2RneGZnVXZBUnB4alFMb294TDVzTSsvY0dhS2ljUmNyMkk2WHdEREMx?=
 =?utf-8?B?Z2M0ZVdtUDhvTUFpUXZrRXhib0NEc2xFQmZHWHNMdGsxTk8rVG9BdllhZVlO?=
 =?utf-8?B?NFA2THNoQU1xZTVjY054TVdWMnZCbnlPdnltOGt3WWpOQzMxZDFHdlh5cmI2?=
 =?utf-8?B?Ykp4QkkvVkEvU2xDTzFMTSt3TEhLazhaKzYzYmhMR2xHZXRzUVBlb0U2b2Q1?=
 =?utf-8?B?dEJhejFPNVhGclZpaFluUVI2d0FtdmhkVWZ2OXdvbUR0NTZIc3FhU0NhcDdi?=
 =?utf-8?B?dVVDd0tOMWdSdzJzaS9RUnV1SG9SVXdoZE5UYTVIUlRnVkVGWGZkTUZmWE5S?=
 =?utf-8?B?TS94d1BrY05YNkl0bS9iOXFMRG55NEdub0FtUVhpNWlHc1hkK2VmK0REbTJz?=
 =?utf-8?B?eUV0ZVduVGFadUt4UXNhWDRNaTE3MFJkQzVvTHB2OGNnRVByRUlZbmRPcldT?=
 =?utf-8?B?dmloTndGUWlNM3lUK0ttUlY3SXFscDhRQUhObytMZHl0dm9iYklOellJTzJr?=
 =?utf-8?B?cGthbzF6clhpNFJBbUw3ekF1QmVDaCtTR0dGRFV3SlI0Y2JEcVRXZTNwSE9R?=
 =?utf-8?B?NGhYNk11R01XeVpib08vNjgwYTNMbU53NVBuSFB1SlVWSnl5ZHVwMWR3UUJ5?=
 =?utf-8?Q?d33l2hlnnqA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWo4aEdZeHNCYzRKTGV3N1lxaFZKbWpNTURCWFZCWHlUSHFaMGpIVU9lZ0o3?=
 =?utf-8?B?RlhrN1VlVytaRnVCYVhwVk1Ubkd3WHBnQTJaT0tXMzlHZmo0ekNIZHBBQmFM?=
 =?utf-8?B?QUxaVTBpVlczUkh4QWluVis3dkR4YWZPMEVQbXk0elRJVml5OWhncVNkQVM4?=
 =?utf-8?B?TWpmY2Z2WFdEQWovQkVhQlRSTkdrN25qMkovcnJPOHFKNE9nU29aTm1IRWFL?=
 =?utf-8?B?NlhCZlV0T1M1NHkyQzVDMVJQMzVPYysrUjN4M3dkdGl4amJoRVFLKzVoN2oz?=
 =?utf-8?B?SnNOOFp1d05oUXhaRmkzVTVpb2dXQ01iNis0NUJxa3lsWU1XRGJnaGltS011?=
 =?utf-8?B?RkpndkNoNVcwaEpSeFlOWlBodXdZQlF6TEhtOEcyeGVwYkdmNDA3UTJrejht?=
 =?utf-8?B?d2V2TEwyZ0pJbm5yY2x2ZjFNeC9vOSthT1JCZm1NMG1oRGFpZy9ybjhlTWRJ?=
 =?utf-8?B?bnZZUDg4d1ZIOE9hZjRqbG5lZGdsUFRLMUxZeVBjaTlJazFZeGRmNHlObW5u?=
 =?utf-8?B?K3pXbktrelIrdzcxVXF3MzBWMkxXbitOVHN2ckk3cjdhK2Q5QjZlMG12MVI1?=
 =?utf-8?B?T1d3eGxWcXg0WXU1U0dvaE5UTWI0eWlkS3dzb2ptcVp3MHk2L2RiZXhlUVQ3?=
 =?utf-8?B?cG0vQjFVWmQzYWtGak5xZnhxcUF1Znd5a1d0dHdxeWpmL0FtK0tZelJuYm1V?=
 =?utf-8?B?OW1nc0FrWGl2UFpUSjc0YTF5dW9TTi9sVExLK2tUVlUxZU9jeHIwNWx1dGRP?=
 =?utf-8?B?emI4Z3B6cTlBRU51bWlWelJ5NSt1TWJiVTNpenh5K2xDSkNBOVhJMVp4L3ND?=
 =?utf-8?B?U011ZGlESnZSK3Bma0FTYzlRQ1NZakNxbHlNZUloL3E5NEliRnBvT09BK3g0?=
 =?utf-8?B?azFRTXBPbkhuVXNwN0xnRG9hM3RJLzA1cnRIZWRDeXdvbVJoNzZ3aE1sa2I4?=
 =?utf-8?B?RDFnOE9rcGhOTU1aWEdDandVdVAxNjJ1a0NDOU12OU5vdmxrTFk0bjZtN1RF?=
 =?utf-8?B?VUZwTzRpS1BvZndFYldzRGtHbDErUmVaUXR4TkpSTnFCcDVRaFJTdEEzT1k1?=
 =?utf-8?B?empBNzlqVklHWGhQSXAvekpvUDUweGJPVGx6cDBSMjhmZFI5SzNKZ3JuY2tL?=
 =?utf-8?B?Nk4yM1lOS29uWE5wUUl4K0M1YWora044ak5vcSt6T3NJOGFma1BOMXcvRzd4?=
 =?utf-8?B?N2lMMmdPUkhReGhXUUkxenhSbTFpK0pUQW5DM21HYnBGUW80MzEvdW1uRjM0?=
 =?utf-8?B?U04zdGlCT1NRd3plSnRlWTlNWSt4L1FXSE5pdVVVK0N6ZXplcUFJNFc5NUJ6?=
 =?utf-8?B?ZWVlRTJ2ZVJUVW9HMTVWcDYxTTFjc3ltRVkvVzhuYm5FckE1bkNSajByVlN1?=
 =?utf-8?B?R1FwdGdkNHBCTmtibC92ODU4SzB2NTVNaUszSUhSZHVENFpaY1UxZnBPc1ZE?=
 =?utf-8?B?T2ladVhZNnorZXV3eGp6NXQ0cVVTM0EwWFcwbTY2ZFNVdXo1RVBRNEpWN01o?=
 =?utf-8?B?L1d3ZTV4WXZQRXB4VHhkRXFNRGV0ZzJwVmpIaFQrN1VNem9FdlExQ21lUFg0?=
 =?utf-8?B?YTVCendiWUFZNlJOQ1pHbWlUNTRQNDhxNDhWTXVURHdsNWFOcWtPcmFEcEJz?=
 =?utf-8?B?SEhUWnBDNWplV2hNRGQ3djlqY0o5cktjb09sZFRYYjJIRmErUGhPQzF0bFFR?=
 =?utf-8?B?VVpBODRvWHJVWXc5YnVVU2kvK09CcGFvVUZncW1IVEdSVTZXWWJjWXMyR2Zz?=
 =?utf-8?B?SlpHd205RzBPcHhMcjNmS2JXd0Z1eEpBaFJDUmRHYzNIYjZFUm9HaGZHUmtl?=
 =?utf-8?B?QVhuWldKaUlZU0FxTVJqS3BreHgwY2MwSTZMcmR6azdsYmRrMStaLzVkUnNM?=
 =?utf-8?B?SEQ3WjdSZXpqaFlmR0ZzRytqa3JXRFByUVhFc2Y3TDRlUDNlc05sQU1aTE5o?=
 =?utf-8?B?NTZZWTNhRlE0U1dlSGpsNmlQbndJbHV2bDlEdVVCK2xaWGtZTVNqUVpVUlpj?=
 =?utf-8?B?ZHk2SE5BSnFSQ0x1Ny93MkF0MFlYUFN5enR4UmJ3dmtHWXlHK0FiajhMMGJy?=
 =?utf-8?B?dlhsUmhiWFNUcEpsRStOS29VT0V5OXBPOUlzUTd2SGp5c2pnbzlqNnpSMDBh?=
 =?utf-8?Q?+QJNY/lYiWg9QbBsVX9vivCus?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afe09c28-9b55-4c7b-f89e-08dd5a62cf5a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 14:50:59.0263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NdnkkCYM5OpIKVkhCefImpRrOG06mmHa/AIj4ZY+lhJn+cLXTux/hHG9urzh47PvyFQ9UgT28ALJtkH+g7QLDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9217

On 2/25/25 15:00, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Modify the behavior of implicit SEV initialization in some of the
> SEV ioctls to do both SEV initialization and shutdown and add
> implicit SNP initialization and shutdown to some of the SNP ioctls
> so that the change of SEV/SNP platform initialization not being
> done during PSP driver probe time does not break userspace tools
> such as sevtool, etc.
> 
> Prior to this patch, SEV has always been initialized before these
> ioctls as SEV initialization is done as part of PSP module probe,
> but now with SEV initialization being moved to KVM module load instead
> of PSP driver probe, the implied SEV INIT actually makes sense and gets
> used and additionally to maintain SEV platform state consistency
> before and after the ioctl SEV shutdown needs to be done after the
> firmware call.
> 
> It is important to do SEV Shutdown here with the SEV/SNP initialization
> moving to KVM, an implicit SEV INIT here as part of the SEV ioctls not
> followed with SEV Shutdown will cause SEV to remain in INIT state and
> then a future SNP INIT in KVM module load will fail.
> 
> Similarly, prior to this patch, SNP has always been initialized before
> these ioctls as SNP initialization is done as part of PSP module probe,
> therefore, to keep a consistent behavior, SNP init needs to be done
> here implicitly as part of these ioctls followed with SNP shutdown
> before returning from the ioctl to maintain the consistent platform
> state before and after the ioctl.
> 
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 145 +++++++++++++++++++++++++++--------
>  1 file changed, 115 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 8962a0dbc66f..14847f1c05fc 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1459,28 +1459,38 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>  static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> -	int rc;
> +	bool shutdown_required = false;
> +	int rc, error;
>  
>  	if (!writable)
>  		return -EPERM;
>  
>  	if (sev->state == SEV_STATE_UNINIT) {
> -		rc = __sev_platform_init_locked(&argp->error);
> -		if (rc)
> +		rc = __sev_platform_init_locked(&error);
> +		if (rc) {
> +			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
>  			return rc;
> +		}
> +		shutdown_required = true;
>  	}

I see this block of code multiple times throughout this patch, both for
SEV and SNP. Can this be consolidated into one or two functions that get
called? Maybe something like:

	rc = sev_move_to_cmd_state(argp, &shutdown_required);

Thanks,
Tom

>  
> -	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
> +	rc = __sev_do_cmd_locked(cmd, NULL, &argp->error);
> +
> +	if (shutdown_required)
> +		__sev_platform_shutdown_locked(&error);
> +
> +	return rc;
>  }
>  
>  static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_pek_csr input;
> +	bool shutdown_required = false;
>  	struct sev_data_pek_csr data;
>  	void __user *input_address;
>  	void *blob = NULL;
> -	int ret;
> +	int ret, error;
>  
>  	if (!writable)
>  		return -EPERM;
> @@ -1508,9 +1518,12 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  
>  cmd:
>  	if (sev->state == SEV_STATE_UNINIT) {
> -		ret = __sev_platform_init_locked(&argp->error);
> -		if (ret)
> +		ret = __sev_platform_init_locked(&error);
> +		if (ret) {
> +			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
>  			goto e_free_blob;
> +		}
> +		shutdown_required = true;
>  	}
>  
>  	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
> @@ -1529,6 +1542,9 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	}
>  
>  e_free_blob:
> +	if (shutdown_required)
> +		__sev_platform_shutdown_locked(&error);
> +
>  	kfree(blob);
>  	return ret;
>  }
> @@ -1746,8 +1762,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_pek_cert_import input;
>  	struct sev_data_pek_cert_import data;
> +	bool shutdown_required = false;
>  	void *pek_blob, *oca_blob;
> -	int ret;
> +	int ret, error;
>  
>  	if (!writable)
>  		return -EPERM;
> @@ -1776,14 +1793,20 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>  
>  	/* If platform is not in INIT state then transition it to INIT */
>  	if (sev->state != SEV_STATE_INIT) {
> -		ret = __sev_platform_init_locked(&argp->error);
> -		if (ret)
> +		ret = __sev_platform_init_locked(&error);
> +		if (ret) {
> +			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
>  			goto e_free_oca;
> +		}
> +		shutdown_required = true;
>  	}
>  
>  	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
>  
>  e_free_oca:
> +	if (shutdown_required)
> +		__sev_platform_shutdown_locked(&error);
> +
>  	kfree(oca_blob);
>  e_free_pek:
>  	kfree(pek_blob);
> @@ -1900,17 +1923,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	struct sev_data_pdh_cert_export data;
>  	void __user *input_cert_chain_address;
>  	void __user *input_pdh_cert_address;
> -	int ret;
> -
> -	/* If platform is not in INIT state then transition it to INIT. */
> -	if (sev->state != SEV_STATE_INIT) {
> -		if (!writable)
> -			return -EPERM;
> -
> -		ret = __sev_platform_init_locked(&argp->error);
> -		if (ret)
> -			return ret;
> -	}
> +	bool shutdown_required = false;
> +	int ret, error;
>  
>  	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>  		return -EFAULT;
> @@ -1951,6 +1965,18 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	data.cert_chain_len = input.cert_chain_len;
>  
>  cmd:
> +	/* If platform is not in INIT state then transition it to INIT. */
> +	if (sev->state != SEV_STATE_INIT) {
> +		if (!writable)
> +			goto e_free_cert;
> +		ret = __sev_platform_init_locked(&error);
> +		if (ret) {
> +			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
> +			goto e_free_cert;
> +		}
> +		shutdown_required = true;
> +	}
> +
>  	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
>  
>  	/* If we query the length, FW responded with expected data. */
> @@ -1977,6 +2003,9 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	}
>  
>  e_free_cert:
> +	if (shutdown_required)
> +		__sev_platform_shutdown_locked(&error);
> +
>  	kfree(cert_blob);
>  e_free_pdh:
>  	kfree(pdh_blob);
> @@ -1986,12 +2015,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> +	bool shutdown_required = false;
>  	struct sev_data_snp_addr buf;
>  	struct page *status_page;
> +	int ret, error;
>  	void *data;
> -	int ret;
>  
> -	if (!sev->snp_initialized || !argp->data)
> +	if (!argp->data)
>  		return -EINVAL;
>  
>  	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
> @@ -2000,6 +2030,15 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  
>  	data = page_address(status_page);
>  
> +	if (!sev->snp_initialized) {
> +		ret = __sev_snp_init_locked(&error);
> +		if (ret) {
> +			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
> +			goto cleanup;
> +		}
> +		shutdown_required = true;
> +	}
> +
>  	/*
>  	 * Firmware expects status page to be in firmware-owned state, otherwise
>  	 * it will report firmware error code INVALID_PAGE_STATE (0x1A).
> @@ -2028,6 +2067,9 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  		ret = -EFAULT;
>  
>  cleanup:
> +	if (shutdown_required)
> +		__sev_snp_shutdown_locked(&error, false);
> +
>  	__free_pages(status_page, 0);
>  	return ret;
>  }
> @@ -2036,21 +2078,36 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_data_snp_commit buf;
> +	bool shutdown_required = false;
> +	int ret, error;
>  
> -	if (!sev->snp_initialized)
> -		return -EINVAL;
> +	if (!sev->snp_initialized) {
> +		ret = __sev_snp_init_locked(&error);
> +		if (ret) {
> +			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
> +			return ret;
> +		}
> +		shutdown_required = true;
> +	}
>  
>  	buf.len = sizeof(buf);
>  
> -	return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
> +
> +	if (shutdown_required)
> +		__sev_snp_shutdown_locked(&error, false);
> +
> +	return ret;
>  }
>  
>  static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_snp_config config;
> +	bool shutdown_required = false;
> +	int ret, error;
>  
> -	if (!sev->snp_initialized || !argp->data)
> +	if (!argp->data)
>  		return -EINVAL;
>  
>  	if (!writable)
> @@ -2059,17 +2116,32 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
>  	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
>  		return -EFAULT;
>  
> -	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> +	if (!sev->snp_initialized) {
> +		ret = __sev_snp_init_locked(&error);
> +		if (ret) {
> +			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
> +			return ret;
> +		}
> +		shutdown_required = true;
> +	}
> +
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> +
> +	if (shutdown_required)
> +		__sev_snp_shutdown_locked(&error, false);
> +
> +	return ret;
>  }
>  
>  static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_snp_vlek_load input;
> +	bool shutdown_required = false;
> +	int ret, error;
>  	void *blob;
> -	int ret;
>  
> -	if (!sev->snp_initialized || !argp->data)
> +	if (!argp->data)
>  		return -EINVAL;
>  
>  	if (!writable)
> @@ -2088,8 +2160,21 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>  
>  	input.vlek_wrapped_address = __psp_pa(blob);
>  
> +	if (!sev->snp_initialized) {
> +		ret = __sev_snp_init_locked(&error);
> +		if (ret) {
> +			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
> +			goto cleanup;
> +		}
> +		shutdown_required = true;
> +	}
> +
>  	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
>  
> +	if (shutdown_required)
> +		__sev_snp_shutdown_locked(&error, false);
> +
> +cleanup:
>  	kfree(blob);
>  
>  	return ret;

