Return-Path: <kvm+bounces-28781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 17AC899D416
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 17:58:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1BADB2E1F5
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 15:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8970E1B4F25;
	Mon, 14 Oct 2024 15:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ARCrLnWV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2084.outbound.protection.outlook.com [40.107.212.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CFC1ADFE4;
	Mon, 14 Oct 2024 15:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920939; cv=fail; b=YlB9A6rLCnSK7PMZzi6atMrzfhnjodMr7DIUqPRLEkRHbwJWXM2AljFF5FwTgbGl0faZcatWwTpYO8YPkqZAroIIWGbOUm9IV15ad6WlrTx8RfvrfGj3+4Qzf8y9janBW/Sa1YfqWYIDZlxvvbMdTuk2OX1ulgOtlsaZ+ejaeZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920939; c=relaxed/simple;
	bh=Y+2JFoTCeIvqnaHBkhO6YzCpQDmbD/3C5u3rKP17RL4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EmILoJvq5LJWfdBNpAq4BZOnlOTny3bwtUTC3VEQdgheWYsOte/kLmXtFoA/ZKIkT8mBpwMIHTtXwL8cK2c1+NiiUGmfT0tossbeq3kMkkapTGhkItLVCj5kuA2Lq5yp25OKwKU9hpCa5oJhsAhyTI0En+kUWVWyyurb0dVxgx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ARCrLnWV; arc=fail smtp.client-ip=40.107.212.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FlrixE846u5fBJtmRBQh3YfhrpKv92MjEgzjZyzN64LMjBm+bSKe6pDAIwyIIwudlgLJZtcG0w5M6mYvepN1xJlw5VMzl7/+OwcvwC2C+TQ3KvsCcQS8pre9bygSSRfHRWVp6lsHeUUgbXyEH2m7T9//3AubxI2RKs0PRYDPlLiXQqgL2jn8idFrerh9RauVnHZp+sRhTdhiBUUy+BfwkS9SkpJI/sy0GysDs11OuvNgw+zd0c35Eg7CI+L+7R57jdruUfhf3cIRQs3K6k7pf66vN/3YAT1fPrWyDWhs1tvUieGi0bWmhq34IVD2h58bXGLaMsFCunrHVXgw1YgFYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6HRg14O+L1pzgSe69K07w9hDPdmymPRPhXdtdp7c+XY=;
 b=DZAMnKGMGh4d0+n0NGhdhfPDq0v5u0KnKNsRmUVPi9eWp7nhp5WAAbHiYVadgGfvFdWwtBclMQQjaMedbGMRy9ZfF26BwitsNIyJouPDyVTl89cG+Wynv1/x8D+MWO8bLxJtMgwJpgwiC7fClBgBLRUJeFKEsAsO1DONSTEgPJR2AhwEhzMI/0PsSfgNn4OjJ0Nc+ct13zw6ai7T0XQ4VIu/qUR0/tFfvE9wELgsjw6ZU4N63RBUJ7F92k+sz4Zciw8RY76Z53nZL0zDoX+4vkH921YSx/4QFkylMkq9wqBDOBSgigL5vxcKaZNWiaI4O+ukCXvPiMp9ZoowfGg1Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6HRg14O+L1pzgSe69K07w9hDPdmymPRPhXdtdp7c+XY=;
 b=ARCrLnWV2cLU4h1XycP/QC3GsiDlj3G5x9k69cOQxrw7HqHsfVW0/CU40WcLmO5i9NERYpx1HjL8XKkG8aIvqtenTvrUldCndaBqmV2MiOJiMqiFZiyHcxgBA168H9E2XRsw2ZgZ/mxtLGkeuZ8p60Fp2KUUbE+p+rTTLffFnH8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB8879.namprd12.prod.outlook.com (2603:10b6:610:171::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Mon, 14 Oct
 2024 15:48:53 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 15:48:52 +0000
Message-ID: <5feb7cea-9651-4525-a617-72080762fc3a@amd.com>
Date: Mon, 14 Oct 2024 10:48:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 4/4] KVM: x86: AMD's IBPB is not equivalent to Intel's
 IBPB
Content-Language: en-US
To: Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 jpoimboe@kernel.org, kai.huang@intel.com, linux-kernel@vger.kernel.org,
 mingo@redhat.com, pawan.kumar.gupta@linux.intel.com, pbonzini@redhat.com,
 sandipan.das@amd.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org,
 Venkatesh Srinivas <venkateshs@chromium.org>
References: <20241011214353.1625057-1-jmattson@google.com>
 <20241011214353.1625057-5-jmattson@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241011214353.1625057-5-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0108.namprd05.prod.outlook.com
 (2603:10b6:803:42::25) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB8879:EE_
X-MS-Office365-Filtering-Correlation-Id: 585ee0f9-396d-491f-219b-08dcec67b41c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHRVbmg5TlZQTVppQWpDd2xnOTgvTGRNTlQ0NExFS1VIbGpLcFluWDdQNTlH?=
 =?utf-8?B?TzZnbDg4NngralFJcUlNMTR3alVWeWMvYVV1amF2Ymp6STlYVEM3U2VXS1Ix?=
 =?utf-8?B?SDNFV0JnTkdpbG54QmFOblFFMjY2Sm1jTGkzOU5MU0tad212Y1B6SHVzUlln?=
 =?utf-8?B?SG9YM294SGhWZVc5Z3VlS1RRdXBzb3laV2Rqb2R6R0dpNGNxTVo1MW1MbjN1?=
 =?utf-8?B?KzNXNjhObVNwTUhhNXArNzVLL0Y2RkZSYXk5aitnTXVSanNMZzFDYzh1VUpV?=
 =?utf-8?B?REJoNzRPNnpjVUMyVEtWNnRRVW5wYk9xNkgvc095Q3JhZU1qTHV5TjRhcHpV?=
 =?utf-8?B?NkFkaHJGUVYyY1ovM2Rhb3UxNmJMalV3VVR3aS9KMkVKWFlJY1pFY2RvYk5D?=
 =?utf-8?B?VUxUT2xZampzMTBMOHlDNlFjNHIvVU1xcUMvdVNsQjJvaFB5K25XN3N1VWoy?=
 =?utf-8?B?aDBJR0FWVCtKMkxZbXZyeWpmSzkxTGpXekdJOU9FR1dGcGRwN1FUbVF5VitD?=
 =?utf-8?B?aDg0ZDRzMFlONXg3V1I4MTBXc2w0b3pyTzg4dlhZQTVKNitocTVldWJVNHRI?=
 =?utf-8?B?dTE3UHRSUlBENWlPQVY2YVNWQ1ZiazNkS05OZXlMbHZzRkl6dWhkUmpIYXV0?=
 =?utf-8?B?d2RrZ3V2ektNdmxGUTBVUndFdVQwbFpQcmVYNVcvRm9oVzFTcWFtUEJnWkFH?=
 =?utf-8?B?WjRFOGpWSVVaSjRxUTczZys3clpQTlB1QkJsVU8zU0RPRHpiV1hBT1owQng4?=
 =?utf-8?B?SWtXbmNMQVY0elRMdEZXOFpGT3NGZTFHTCs2SkNVeEorbEkyMnZEVW1vck8x?=
 =?utf-8?B?amRsemRqcVRGM1V6ZG13ZEJjOWY4VVhJN01yVTRETGVtZlFwYWRNa1lBYWRu?=
 =?utf-8?B?ZVNJUlgxZTVhTnFkN2JaYUo2Vmd0ZmNkcUxNTzhDK0l1SWQ3MFByWWFNYXh4?=
 =?utf-8?B?VlpQcDNNeFNYY1gxSWNXdDJQdFVyWldtMWxSUVJzTnhualdJM0Zkc1J4MGhS?=
 =?utf-8?B?TEhValBacXdpKzE5elJkTjZIRkFwbXhtdjdUc1M3NUFYRWpDUm0xbFVROWcv?=
 =?utf-8?B?cFFvMGt2S1dMNkNuUWpvMlJFSklVUTRIdG1KT3JpMmZpUzY0OEtya1IzTVZt?=
 =?utf-8?B?b0JRdWZFREp5MVYvQVdreXR6aHZyTXVZclBrTjM4L1RtUlRHNmQ2V1Q3SGVB?=
 =?utf-8?B?N2t1S2hLZWM2VWpkZ0NZQktyYTc1YkpWVVhVZWpad2NhalZyYU5MOENYNC9T?=
 =?utf-8?B?VGl3dVdVSGwwbGg1NmVaYVBnMjY2RWhjWm81WG9IY2Z1Q3kxeitOQ21Qc05y?=
 =?utf-8?B?YWdKTzhkSmwrcWd6dHNlV082NFY4UjRieUo4bGszM21PRERKYko4YkpOdjVF?=
 =?utf-8?B?bXkvUjhEVmFUelVBVnh6Tlh1UjdCMllUN1d0TlF0TjNubldUTTBKazVQSnJN?=
 =?utf-8?B?NUdrclNLQVc1ZHZUSkpQMUJnTm9xV1pyUUZhdCt0MzJBMlZzNVJlVzFRK1No?=
 =?utf-8?B?bFVuN2dWeUNJV1QwWGVoYnlrNHliWXBNOS9HVURWM28wazQyWFJTTkdRZVVh?=
 =?utf-8?B?UzVReXJyZFNiZ2FtMGtUZXNLd2pLS2RjelJpREdCVWRndGUzNW9STHdteUQy?=
 =?utf-8?Q?dYoR58pW7BWxGAtlcPYhtYxJkxGTQK3q9RC3hO9NLgYI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXl4TStSV2RMYXFIbWQ4OFRRb2tDZ2xXSFV5SHZlVDFiVWdaQ2Jrdk9pQ2NB?=
 =?utf-8?B?cUxRQjR6dnZvWFhNQ3R2eFVuakpaejFLSytzejI2TThqR01pOGFhckVMcTVE?=
 =?utf-8?B?d1dLUDcyWTJONjJwc3VSUE1vV3JvRE5qd1phVkY2WkNJZ0U5SE5od3JFVnNa?=
 =?utf-8?B?cVFtQnRVZkROb1FKdmZ4OFJ6ODc0dVR1SVhhQ2YzU2hOc0NxcVo4VVdFY2xa?=
 =?utf-8?B?cVNXakVyQmxwUHN1dmx1YnhOWWtNRC8yRmpuQksyVTFzcmhEWHpwS096Z0hO?=
 =?utf-8?B?VjlBRTlUTVA2cUdhazFiL2FLV1pVTTR5WFRpaHozekV6aTVrVU95MGJGaWlM?=
 =?utf-8?B?d3UwZGhvQjg4dHdBcVNIeXZoTVdsSmF4QjhGQloyUEJHWXpzVHFjZmNzK29s?=
 =?utf-8?B?eTlmYWJ2Uzk1RElxMDdqUWNGWm1mVFF4bnB2MndjSTdqWVlrYmZRRGhaS203?=
 =?utf-8?B?VTlBTGlzUjNWdVJick5oLzhjZDZYZ2pNRG5sSlFyNkpmREh3UlBBdXVvaVFH?=
 =?utf-8?B?WUFnRXdYQmtHZEZVOEhUcEtheXdFYXJHVXErRnFuNWZPcjFCV0o2OE1PYWRH?=
 =?utf-8?B?V0E3RnE1K0hwOTcycHJFUWoxRHFhRktMdkcySWZaeHdKeGZIbGtTRDJuSEEw?=
 =?utf-8?B?TFRNM25yV0pkaWVOYk5nRmNsckxUa1dVb1lDZldQd1dpNXdTSkxjL3QxN2sy?=
 =?utf-8?B?Sjdxa0VRTlo3bnVma3BqbW1rSzRjZjdKV1RmL0VRM2FiY3plbjF3RFNlQWJ1?=
 =?utf-8?B?Z2k0cC8zaFNSUnF3M2I1emZoT0w3TGVZRThLR0lpa0VyeGN2Uy9QakppaFdl?=
 =?utf-8?B?N1JqRDhzOVNIM1lrRDFMM3ptcTQ3S2VWYkJlaVFiZnE2SXgrRUlvT0VpdXEz?=
 =?utf-8?B?ZnhPcnZHcTEwQWhEMVh1S3p3aFlMWmZ4UDJvMkxWODRNRVV2Q2ZuUWFKaTFw?=
 =?utf-8?B?UFdVV0pFM3pnbjB5ZlAyQ0VkY1dZdXkwS0I1NVBJb2R2QTBiNjF2bklJTUZC?=
 =?utf-8?B?cWdsQmYreC9iYTM3bW1laE1BMUo2TTIxYUxkZzBSSk1YSUFuN0x4U2tmVDRW?=
 =?utf-8?B?RTdJdzdHcXFhZ0JLMWtoZk82VWVOUFljNTdnMHo2b1dQSXpGak5NYW1vK2Zj?=
 =?utf-8?B?YWlxNFgwNnEvdlg5RlpKakdwMmtVQUtIbHpXZWlqNTNKV1p1R1FOOGk3MEpz?=
 =?utf-8?B?S2hpSFpBMFdKVDErVmk2RXRZeVZnLzU4bW0xRzNoQ0Y0ZTUrMDlsVDBTWmtJ?=
 =?utf-8?B?Y1h2YmZVclo4MlZVNkJFRjk3STNTVkpaZUpXQVNBdDF3cHdjeE4wN1R0cHJv?=
 =?utf-8?B?YU5yTUxrK3p1cG5SNkJveTI3N2ZsWUYySGhUUWp5cUNyRzhhWlZWMFBmaFRL?=
 =?utf-8?B?NFN4Q2VQY2FiMFQ0a3RYL2t2R0pIeGFNMzBWamZZZ0cwWlRNYlE2blNlZUN2?=
 =?utf-8?B?RXEvdUtlZUUwMTZ4MUVsVlQ1WEJLdWMxNEVTejE5WGtXSGNkWmVvaS9YWEkv?=
 =?utf-8?B?eXJxWDJNUDc4RGxIZWtXd3IwWThMeWRkZ216NXZSbXNIbkxlNTFKMURVR2dn?=
 =?utf-8?B?YURVR1ludHMwMitzcVM3RU56aWM1OHdNSzFsVTZLN1gwek01UXNKY0orTFcx?=
 =?utf-8?B?QzBNWVovS2sxQ1pTMzBFbkZNeldibjFjL0l4NlNRaXhrRDMxN240Wk9jZmVF?=
 =?utf-8?B?eDRWdDNYODJBbS9BNkJtVHA4d2VtVUpmakRoUVdHZFdFelFWKzZxVTlhaVVm?=
 =?utf-8?B?RDlSWjJXdlhNdmlOUlBCNFJqakdNN1drVjVrY1d5bEluMWZRN0dWbEVidm9z?=
 =?utf-8?B?aVQ0d3FzZ0QvREJrbjNRTGxWREF6Yld1bTh5UEdYbUxrVFQrNW1TQmRQcUFS?=
 =?utf-8?B?WGpyVnNDQTJPVEV2aTRuTXRkQ2FsejBHT3ZTdkR4Qno4ejcwMU5IWlpYa1Fi?=
 =?utf-8?B?M0x4NGU3K0IycmQxWnhMbEFJU2xUTWRMcGt1VG9ETDZuUFh4T2hUdWUzQVM2?=
 =?utf-8?B?K3RrMG1uSFBzY1ZXR3lKTnJleHArWmRQWktidDQxMEM4eXRkSExMejRRUjIr?=
 =?utf-8?B?c2JHa1RxWEpWbVp3WlRHTEs0Z3NYeHl2WVFuQjFuaXlNdkFRTHhnQjZKWVNq?=
 =?utf-8?Q?2r1DlgqtHqgFg584cfFPiyWFA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 585ee0f9-396d-491f-219b-08dcec67b41c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 15:48:52.9057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4aRiOXFML8N9J7Awt2CRTx3ydF+2hTT8T5U89RR1TDygBcZ8abR1C2JvpG4nlycsZ3ZW6hl4CeORwLIHhqnaFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8879

On 10/11/24 16:43, Jim Mattson wrote:
> From Intel's documention [1], "CPUID.(EAX=07H,ECX=0):EDX[26]
> enumerates support for indirect branch restricted speculation (IBRS)
> and the indirect branch predictor barrier (IBPB)." Further, from [2],
> "Software that executed before the IBPB command cannot control the
> predicted targets of indirect branches (4) executed after the command
> on the same logical processor," where footnote 4 reads, "Note that
> indirect branches include near call indirect, near jump indirect and
> near return instructions. Because it includes near returns, it follows
> that **RSB entries created before an IBPB command cannot control the
> predicted targets of returns executed after the command on the same
> logical processor.**" [emphasis mine]
> 
> On the other hand, AMD's IBPB "may not prevent return branch
> predictions from being specified by pre-IBPB branch targets" [3].
> 
> However, some AMD processors have an "enhanced IBPB" [terminology
> mine] which does clear the return address predictor. This feature is
> enumerated by CPUID.80000008:EDX.IBPB_RET[bit 30] [4].
> 
> Adjust the cross-vendor features enumerated by KVM_GET_SUPPORTED_CPUID
> accordingly.
> 
> [1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/cpuid-enumeration-and-architectural-msrs.html
> [2] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/speculative-execution-side-channel-mitigations.html#Footnotes
> [3] https://www.amd.com/en/resources/product-security/bulletin/amd-sb-1040.html
> [4] https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/24594.pdf
> 
> Fixes: 0c54914d0c52 ("KVM: x86: use Intel speculation bugs and features as derived in generic x86 code")
> Suggested-by: Venkatesh Srinivas <venkateshs@chromium.org>
> Signed-off-by: Jim Mattson <jmattson@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/cpuid.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 53112669be00..d695e7bc41ed 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -690,7 +690,9 @@ void kvm_set_cpu_caps(void)
>  	kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
>  	kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
>  
> -	if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
> +	if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
> +	    boot_cpu_has(X86_FEATURE_AMD_IBPB) &&
> +	    boot_cpu_has(X86_FEATURE_AMD_IBRS))
>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
>  	if (boot_cpu_has(X86_FEATURE_STIBP))
>  		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
> @@ -763,8 +765,12 @@ void kvm_set_cpu_caps(void)
>  	 * arch/x86/kernel/cpu/bugs.c is kind enough to
>  	 * record that in cpufeatures so use them.
>  	 */
> -	if (boot_cpu_has(X86_FEATURE_IBPB))
> +	if (boot_cpu_has(X86_FEATURE_IBPB)) {
>  		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
> +		if (boot_cpu_has(X86_FEATURE_SPEC_CTRL) &&
> +		    !boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB))
> +			kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
> +	}
>  	if (boot_cpu_has(X86_FEATURE_IBRS))
>  		kvm_cpu_cap_set(X86_FEATURE_AMD_IBRS);
>  	if (boot_cpu_has(X86_FEATURE_STIBP))

