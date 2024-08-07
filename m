Return-Path: <kvm+bounces-23482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2EEE94A1A7
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 09:27:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80DD51F23A75
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 07:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31C11C7B92;
	Wed,  7 Aug 2024 07:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="esJcbvyy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2051.outbound.protection.outlook.com [40.107.100.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F092868D;
	Wed,  7 Aug 2024 07:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723015662; cv=fail; b=XvVVKMoKNcggds6VddlPei8IRHKLX0ZlibCjBvMfe38KhAgcdxyaxRaLtyhtAmqeoMBIuNgiAvXY09NjFRGFeJnsX53wTQ1BIBoZdnRSNNn7m1dN1n3xYMXg49ZOQonHxwU3zUcy0ZYOoE73z7ntRAmI2DQJJlCA6+4peu2U+Fw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723015662; c=relaxed/simple;
	bh=dcaan5J+O4d/iEhHfvPJmPUuuOgPfxDmoYxv7dMDb04=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=krUaO8bSUUIZ2is+6+egF20j2XIZ/LIV8fY9rWY2Lb09KX62qspnK+HWFHLGSlrfrEO3WRZRKvNuBDBoBeW38BDDqdKYffjdF83Hnaxssc0cf3874Ma+Y7SHgoY8nPa1chvK1QbHhRpjPK5EK4lRHnf/IJ28Hgl9nkvlcc7W0BI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=esJcbvyy; arc=fail smtp.client-ip=40.107.100.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fviozwe5L00fHqY2pQQQXgA5/ybzSaTCwn/AI3Z98GC1OkeT/+nxlpCzBnDqsKLf0vsWcpXdTo4b7CJ+pzIA9l0PwlhsPjCOIx2ae2SgNIIAnF7AbqwFkEQN58pBl97s2TFd/Dm6bqC7XCKSJDxMbRW1+h5gDxgM7iibpz3wqDmZcsVuq6MvnK+eoqPq8MSyQ68zcEqy+m4QIkLSXCUU3qVlgn7n9PNN8RmtuxHRXCPh2ON5huvCfGOJsguHnqBOkGaQL1rA6PeQKcpLoOEMplbBqHCfXin5p8DY9Ok+kVekCG4q/FpMDKHD9EoZKANfKOMgDM/DH5ZVTgoNXGhzwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=luY5H8TpV3wFgRNOjUvUuvr2JBHItScTYTylWSbexgI=;
 b=pGI3HsnWVUwd6PHNBR2CkSc9SgqioklT/EYTKIHcdHfoHhe0YpV7z3ZPjVGC8n8KDsn/jj4otLt+CGhNE51ij+8qbxKojMYU1qkvG+6ZUKYDP4VmjUfUR8El2G3Q1Huk7BMufaR59YdG8LDxhqGvrxkcMe/Mlla6pOs2QeXP/9QyVPiujCibGv82vNTpX4mRhZnv2745RF0WDqDw5mRkwgiS9JdhJJeTmNAYKGVhNWz4rqY3VpFtc/tZqUiPEzgF5q3fh3B9RuYaXQEkaR9WhwLEcEV2BTR02CzQPluLPODwJmZI8YaXRKPABCqcJd8G819O8dTaeKW4Kf8PWQgHbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luY5H8TpV3wFgRNOjUvUuvr2JBHItScTYTylWSbexgI=;
 b=esJcbvyyNsjWQj0jiCYL42ZaECuDBsyYxXLRlpTUWG93JLHyVV9dwCIR8KiMkrz52bm1YthpOfu2j3mR4bW/2LjZY7oIPqRVbMLhxDJ+u5bZVFWLZCLi+1OeYjS/X8K9OjpuvN7vGHzzT4lFpRHKdn2OgCdVNxnDszEOau+R3DI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by MW3PR12MB4363.namprd12.prod.outlook.com (2603:10b6:303:56::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21; Wed, 7 Aug
 2024 07:27:37 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%6]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 07:27:35 +0000
Message-ID: <f72d8d77-80f5-e21c-39d2-48789c232c51@amd.com>
Date: Wed, 7 Aug 2024 09:27:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: x86: Use this_cpu_ptr() instead of
 per_cpu_ptr(smp_processor_id())
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Isaku Yamahata <isaku.yamahata@intel.com>, Chao Gao <chao.gao@intel.com>,
 Yuan Yao <yuan.yao@intel.com>
References: <20240802201630.339306-1-seanjc@google.com>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20240802201630.339306-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0193.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::6) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|MW3PR12MB4363:EE_
X-MS-Office365-Filtering-Correlation-Id: 307fbdd9-2839-4d3e-04ac-08dcb6b2689d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TWoyTyt2bHpPK2dZcE5CNjhhaXQ3QzROODNySDlVUHVCMjRpZlJkVXdHY0FO?=
 =?utf-8?B?bHExS1ZZdTV4K3hCL0tOREhXZS9NNk5LWWpaaEdrMHBMTGNNODBDc3NXaUVW?=
 =?utf-8?B?L0ZwaTB3YnZSVkJBc0M2eFhFRDloeWIyQWgvcDQ0d2pTRzE4cllkci8vVksr?=
 =?utf-8?B?Skh6dnRGUC9mUUJHZ3VBL3BCYU5LVUd2clFmWkdoMzF0NVBNMFg2TG1sa2d1?=
 =?utf-8?B?eWRveXQ5NGUrVjRIcEcyRHk0eUVDN0ZTWDIrTWRVUSsyc1lnQVZncGNhR25z?=
 =?utf-8?B?dm5lTnV1bHcwTnJybWRUZENJeHZyU2IrajV0VnJyckJJTDZ6OVBSSEJJZHBm?=
 =?utf-8?B?R04zMmdYQTlEYmxWTEJjQWlPWllVdVc3dWZIVHQzRTFHSHp6RGhURG4raktK?=
 =?utf-8?B?b2t1RngzWmViZ2ZhYTIrN3QvckhEbDRHMmJVNFl1VDV3SzRYQmFIVmV1RVc2?=
 =?utf-8?B?ZVhZUHc5bkp1Tmt6Y2o3QU4yRldFN05JSFk4czBKb2V1MUVaSXIrUzFyVGtD?=
 =?utf-8?B?UnY0UnpyWkxNaHhFYnBNZ3BKcDFQdnNOVUFpcTV2MWxrdksvSW9QMVNwWThi?=
 =?utf-8?B?WElVWG5TQmhaR1dSWVhMOXFjNXhyVitjUDZiN2lxUkVtOEtlUTZLeS9WMHhW?=
 =?utf-8?B?d2wzTGJIeVpDemQxM3VBY1JvYWpCU01pQzJVWmxWeGgvTWQvdGFkMzlRRXQ1?=
 =?utf-8?B?M2pwTUhMTVMwUkgrdWhkbW1EcDNPSTk1VFplTlZJRG9WTmdwcEM1NlB6b0dp?=
 =?utf-8?B?eXQwVmdHRWRlVG9Pa0pxZFA1NG9Yc2pUWEx4eHYwMEgrWUM0YkZKN1U4OFBz?=
 =?utf-8?B?QjVhOXNlMmI0NiszNTI5UG1Hb3FtZG9pQUhEbGVQaG45RFZUdWpSdWdOZ2Jw?=
 =?utf-8?B?cGhmMGxsVmozZnpnOTBiSUxrdXdWc1ZZc0VWZjdNUnNvZjdKMG5iRGdFVkVO?=
 =?utf-8?B?NGV3QjFrUGpxRm8wKzNteGNrRnBsYm5NOUhER09pcG5DUVlsZXYwa2VnVnBt?=
 =?utf-8?B?UklXd3NTT2NjdExiSE56M0xWK1h6SFBPcS9zSE9jSWVzQjVEVDk1eHFrOFM1?=
 =?utf-8?B?SjZ6SDRRdENTb0tESkxGM2JQQWtXNGo1L0FzVFpYT2hCdHBVRXhCUGV3OTdW?=
 =?utf-8?B?YW4yUTQrMVowUGk4QUNzVWRiSDVSZmNGbllzT3R2ZzFBeGkyYnhUMStGV1JQ?=
 =?utf-8?B?SDhLd1Rjb24rblhDYTgrS0UwR0JBa2xJRmdaYXg0Kzc5OGx0WkJGQ1l3TW5G?=
 =?utf-8?B?MUF5Wi9FOUZpWDRlM2ZvaGhGZGNRTGYxSFk3U1YyNVFFcUpXTnM5bWM1c28y?=
 =?utf-8?B?bXhhekt6N1BjVE1tbmh3azVqRkJpUnl5L3B5TFRwSVROMEhlTXo1bFFBTlI3?=
 =?utf-8?B?eCtheHZBR29NTFFraXBhRVB6dDNyeUk3OXpQVXNPYTlDbnUwd0RUdlJYQWlh?=
 =?utf-8?B?T2FiNTZNeE8wWjRwNkoxME1vUGlzcEdCL2grY0RoUks3OUFHMklKT2R3QndC?=
 =?utf-8?B?TGN5TVBnd0RGQWJaUGJ4cTRhamFybVRYRnlnQmxGNTVKMHB0T3lvbXFmUWda?=
 =?utf-8?B?aWVob0JZbFg0ZkIyN2E3ZUdaNVJkdjNxc1A2b3FIanlKUjRlazBuN25lMkVm?=
 =?utf-8?B?VW81dWtQL0JESU11VVdMSTVBOWRacC93bCtkbkZEOFEvRzFCVGw3RmYvVTEx?=
 =?utf-8?B?MStPWkZCdHQxTWtNY011NERsRGlzblZFUDVNNytXZ1Ntd05zQ3k0d0lhOVVP?=
 =?utf-8?B?MGpSaDZIZU1kNjJYSk41d0JuWjYyK0cxcC9nc0FLTUdDR29VSWowTDZtR1hv?=
 =?utf-8?B?djNSWlFWU2lyMGtwdXFzQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFAzYU8zaG1kbjlOZ0lxS1JDTkg5QzVzblR0SHdQVkpTZVNrbkNyWTgyWC9w?=
 =?utf-8?B?S1pJTU9CV0tNVmwwNWhBWjlqbmFMQ240Y2lEaHYxb0N3Slk2NUZEU09mdjBu?=
 =?utf-8?B?Y3p4dCtnSzFHSldsWXNsc1dGeVhJMVNoNm9nUTlTd2tDb1lGdEVHM0U5Tkxx?=
 =?utf-8?B?N2ZpVU5sdGhpaUFUMk1hSnpwb002MzdhZ3p6OUpHWlB3WTdzS3pqT1hKWStr?=
 =?utf-8?B?UUVDb0lwbXBjVjYyUkNVdkZvOTNFRkxRUzFEcEROVVJRcjZLVEtlV1VzT2Zz?=
 =?utf-8?B?TnFPcHdNNk5vWmMxTlltdDBFSDB5QmlKcFBnRnBYWlBlbVpoc2U5NVRnWEx6?=
 =?utf-8?B?T0I0bmRhNDJQbDVJZ2didjB0U0ZHNm5mdGM4dUxid3N6Tkl4WnBLblFzNk1Q?=
 =?utf-8?B?SHQvWjZ6VG1TSmZXMWRVQVcyTEhVUWlDU3h1a2Q3eUtoSUJMcGtLUmNNM242?=
 =?utf-8?B?NUJDY1NEYWNPUWZnMFJuZk9taTlKRGVKcGdHeUtjaU85KzYvc3d0NTBLMCty?=
 =?utf-8?B?VVM2U240Z3NIeXJGK3BWQVBpVTRNb2JNbDY5bWZIRHppdUFHNm41N3E1Nm9Y?=
 =?utf-8?B?OFJPc3J5ZmlFR3B2K0IxYVgxcHZEbFRlR3hWeDVEVFA1TUp4bCtrWUdZcHcw?=
 =?utf-8?B?SzVPbXZ6R3ZnMWg4VldCR0NIWGhEUlpGSjlHUzR4QXI4TytrbzRJY1ZyTElo?=
 =?utf-8?B?NUN2d2Q4Mi9WeDI3V2szeWprMnliR2VOdmtvVXlmMGdxcmIrRzQ2SWtmTU82?=
 =?utf-8?B?K2tlL1ZuZys4TlpUMHMyQVJIQ0h6S3dJcDBtV1M0eWttckp4cWhmNVc4V2Q4?=
 =?utf-8?B?SjZGbVVDNGpRZlRUNm10MVdNeTArSHhyUmg3ZWVaMGVRNThTaDZubVpCbHpz?=
 =?utf-8?B?VjF5MUc3d1VrTk1YUENkeUtLQnEvazI1WEgzWHBGYjBQYXFpSTV2aVp2c0xZ?=
 =?utf-8?B?aVp2TXI3a3piR292Wjh2WjFxcS9NNTVHTThLZTFQVndkYklqbThLc25uN0Nx?=
 =?utf-8?B?Y3h3Z1h3bTlPaTlLZzBTYmk4MWV4ZmhWVEZHUElUZzFsNWQ4RlN3T0cvZjdV?=
 =?utf-8?B?b0VySTRONjBBZ0NtbDFKekdZSVVjL1dXazJkamVxZXZ2VEprR3BJTG4rSS9X?=
 =?utf-8?B?dUF2VTUxM21GR3ZXZ1FqN0lJbHZtY2lZYVV4OHlmV0JCZzgzdkt0UnExdkt2?=
 =?utf-8?B?d3Q0aUtvVTdLRkRBbEpLR3NHNlNMQUJoaUtVYmhKSzlWNWhrUWRUMlIrcFRR?=
 =?utf-8?B?blAwOXExRFFXRGVDZ2QydkEwZFhhMlpxVVR3WmRVSFRGQUx5ajJsRHlpWkVF?=
 =?utf-8?B?dFFTb3Y3MnVYalRRZGgzSTZvNWIySGJiSVdSZ2puNGVab1hlVFlvMFNMM0h5?=
 =?utf-8?B?SkF5RXBkSUZ5UUN6SVorb0x1b3RpaWt3SGFZQ2FMOG9ZSVJmN2tnUXBQTHBt?=
 =?utf-8?B?OXVhQUw5NnFZZWV6UUpHT2Fya2ViUyttUXNtcGR4Z2kycnh1cTVNOHRjblBG?=
 =?utf-8?B?ajVFc3ozNVBVMGppM1BBalNwSmtXd1A4M3ZLQ2FBaWM2Ri9vUFNzRWRrMnQx?=
 =?utf-8?B?U3ZCRGNyTFZkeUcxazJuTFExWktxbzRjNDA3UU9pZE9XMEFhYjRORVRyMUtV?=
 =?utf-8?B?czhhb3FIM1BPNnZ4TW8wbnlKaWRmNHM0VnpvL3dQNGFPSzc1clcrUHhTU0ZP?=
 =?utf-8?B?YVgrRWttQk1mU3lhZXR6bGRCeTZVbm9rMm5FUDlmRUVkSGpsL3dXdkpteEsz?=
 =?utf-8?B?M2pJN010OVJWN2NOaGloNlNVVzBsTnVFTmsyemlhOVA3dW1PanhhdVNZNlJX?=
 =?utf-8?B?UUoyL2djTTJFNmYwcDM1YzQwUkY1Ynp6QjFHUDNSS1B3dWk5bjlWT2VFU3J4?=
 =?utf-8?B?SkZvVXhOWDcrbGlJbzllZXgrY1BuVVRWRXlEZ0lsM0kyWjJzWWI2NERtTE1r?=
 =?utf-8?B?MEE5V21KWHhLaG1JQm5Jam9BM1RsbkVzblIzb1VacGFmdUxZNi9lYTlmcFJh?=
 =?utf-8?B?OXFrNW5qaldnaHdaNVd5SkFjcGVuem43OVJTWkoyYmtLYlI4am92S01ONEI5?=
 =?utf-8?B?S0tvdFUxTWJmSkN2YUJKek1mSjdXUzhaNzVuVWVFOXVyVndmd0t2djFxamNT?=
 =?utf-8?Q?n0OcqPbbXIk439v2dUUiEsCDs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 307fbdd9-2839-4d3e-04ac-08dcb6b2689d
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 07:27:35.6880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UNpaWX9SBh6491vF0crDJDs4rqtLxOrCSFvo5CcWCX/wCcYOGjuJqu9YJ36dQzrO5QHAWz5OiKNkuXlsCKFTDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4363

On 8/2/2024 10:16 PM, Sean Christopherson wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Use this_cpu_ptr() instead of open coding the equivalent in various
> user return MSR helpers.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Yuan Yao <yuan.yao@intel.com>
> [sean: massage changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
> 
> Not entirely sure where this came from, found it in one of my myriad branches
> while doing "spring" cleaning.
> 
>   arch/x86/kvm/x86.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index af6c8cf6a37a..518baf47ef1c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -427,8 +427,7 @@ static void kvm_user_return_msr_cpu_online(void)
>   
>   int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
>   {
> -	unsigned int cpu = smp_processor_id();
> -	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
> +	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
>   	int err;
>   
>   	value = (value & mask) | (msrs->values[slot].host & ~mask);
> @@ -450,8 +449,7 @@ EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
>   
>   static void drop_user_return_notifiers(void)
>   {
> -	unsigned int cpu = smp_processor_id();
> -	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
> +	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
>   
>   	if (msrs->registered)
>   		kvm_on_user_return(&msrs->urn);
> 
> base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f


