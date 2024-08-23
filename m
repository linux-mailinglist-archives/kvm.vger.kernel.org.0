Return-Path: <kvm+bounces-24952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C1895D91B
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 00:12:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DECE828290C
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 22:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB3BB1C8709;
	Fri, 23 Aug 2024 22:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QSxw98S4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E767195;
	Fri, 23 Aug 2024 22:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724451164; cv=fail; b=eY5Nfp7Y49DbSwxwMZBucE0OKEr+S3tYLOgCh/bHgrBJmd+SeM6Mr8hdTa9xU8QJJ3ynJOLpTcxK8z1WJcTKwtj+jJc/Mb60s0a7UBOHJPpuv1TfWs7J3dk9EP89dppFVrQeDjZxB0erbMSBLUNV+4uYej7XtPn3sJnEt/wiVdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724451164; c=relaxed/simple;
	bh=+gs0ajvs1dAdWe98iP2AOuUBYdTIM98fmrm/MXrLzAE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U2EmC5nqCO0MQR1k9aRq+SrBXTiDI+A/RtuRIiGz4RAW4YpNDGlZU18CLlH2pQLTldp6OB/cxdvtxdp6glK8k81bJuTsAYAOXRJIJskufPbEHEjPHNadRcS1BCW4gfntkQS/FyJkmIy+RL+MR/f7DLOsppgiHFcyEOQlXEBcJok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QSxw98S4; arc=fail smtp.client-ip=40.107.237.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nbkW3sBhfL3187y36H63dncgb5AXB6u8PT3bXaAX5O3RCv4oiBqi/rN3dAtbZepC80w7R7SfQZx9lodtr6SNNgi4MJZlrh5GDMcLRxXRunBqkH1Sv7UyKanCnr3nHLB+r6kzDEA4+zVPbsGz/OviPXwAqg89R8Xz9gJQLxh/0YojG5ibGOSibeBWCW9dU39g4Suuafnn+ud6tSAu0RpBUcMceJZxCdwUArytxsjCjrYkqv2VB7l8SOIp50Q7muXhgMYwfwrg9sIkRgORHwLGdy827wQdDKWiaS0Fmh+V4ysoJbRihf++5p7zx93Kjz6LxgAECzeeiS+TKFag5OW8DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gp5r77ATFaoae72AgQjGsi88QOtMf8xwi6WvB69PjtU=;
 b=tEislHvb0wGd9djROSs0FkI53LWZOpeqV/Y/MN9G1scmy4mbD8K1xNACAl3To/mcMcHx1O+AiR3Ja7LPOpT6jekpfw98rNSY8J+nDQwBZfuqzscCVBqVqVjk7r39vzFB133pG8TRBugCcRtoCGQefv/BTFpCK/Hb8zxll8iHmgHoomFi7Nf0xHHyW1+todW3oWmD4n25Oyr/lyjcahfotLn7A4OP/gS/Vd4d6HwzQgSqPsB34rFwcO1GEKD6mpY0FqnUJZI03ykpwQox/uhORzyTrKyl0swczuogs2h5/6JFpUwx635S7V7ZoydsQAfZ+Z1CZK3RU27Geh4BRNVEcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gp5r77ATFaoae72AgQjGsi88QOtMf8xwi6WvB69PjtU=;
 b=QSxw98S4nT7yE7j2Z+U/WR41MMMruaHxXgy3IsHWaQWUXiHvmpe3fPei9S5w3Ks3JZZB74BQvtK6aKUrdTsuNIqwgDQQ/7dSDlpkzO8mAiL8h1RhWEmL8snZXut3w2yOGCV6P9iF33KDglxOL5+lFT3PlPYPtILeNfgQ3Vg6A64=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Fri, 23 Aug
 2024 22:12:38 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 22:12:37 +0000
Message-ID: <59449778-ad4e-69c6-d1dc-73dacb538e02@amd.com>
Date: Fri, 23 Aug 2024 17:12:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 4/4] KVM: x86: AMD's IBPB is not equivalent to Intel's
 IBPB
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sandipan Das <sandipan.das@amd.com>,
 Kai Huang <kai.huang@intel.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Venkatesh Srinivas <venkateshs@chromium.org>
References: <20240823185323.2563194-1-jmattson@google.com>
 <20240823185323.2563194-5-jmattson@google.com>
 <26e72673-350c-a02d-7b77-ebfd42612ae6@amd.com> <Zsj2anWub8v9kwBA@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <Zsj2anWub8v9kwBA@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0182.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::7) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BY5PR12MB4322:EE_
X-MS-Office365-Filtering-Correlation-Id: 623052b1-9eaa-46f6-95f8-08dcc3c0b2a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHA3WXkyREFVbkhZb2lTeFpXOEpFaEpHTXNxc2M3dmFicWFFODNkV2J2MklO?=
 =?utf-8?B?U1JpZG5HYWtnT1QwQm1Da2V5MlI0UEUwNXM5eFRZZlVrVE12bTB4MzNjKzNr?=
 =?utf-8?B?UDVYYnpkNCtQaEJHR2R6TWViSWlDVnY5QTVnTThKa1hxK0x5SzJLMUpTZFdM?=
 =?utf-8?B?M05sUXFSRGNTdlZIa1dHMzk0bUYxN2RSQjBJRUIvdTQ3eTRyWG5FdGFCMi85?=
 =?utf-8?B?NHlpUldPbStvS3dKbkx3SnJSakEvLy9JRzF6VG4zTk9pc2tWZU8welZBK2RU?=
 =?utf-8?B?cWJFTGRRcjhGUktmQk8zMFJoTHlIVi9mbCs2L3pyZmJqL3BVNURRcGNhVE9T?=
 =?utf-8?B?M3FTRVVuNFlEMUZVUFdyU0FpZWUwWDd3cEl3citoWDN2UVI0VUhrQm15NnYx?=
 =?utf-8?B?K053OWFqMFkvR1RRT0p2cGtIS29sb3gwejhVOTJSNHovYllzTVF5Sy9FZEFR?=
 =?utf-8?B?RFBXRmc0UzJsZmxVdjhrNk9mVENwMzJFLzRiUWoxWU1EbGRuYUh2UEMzWE9a?=
 =?utf-8?B?aFZ3b1R4ZHdZVEJUVm44a0h4WTN0dS83alJHVVBONVRkSno0bFJvbHNyUFZH?=
 =?utf-8?B?ai9TbnNSd1hyaUNsbFZHODFsaFZDWWZISi9QbUF2RERNVUpRd2QxYzMwNDFo?=
 =?utf-8?B?eHlDaVdRYi82bCtEcGxNNks3cER2blhEWUMzSWlWUUZibks1dFB3K1JBWDBz?=
 =?utf-8?B?QzZwVmlvYTI5b0RUUzVGT2ROUFpSTzNNVkJMOUthWFVGQVFqeFhDMDZKem9S?=
 =?utf-8?B?K1FEMkI5dThTUWZJTWJUampLSGMwQ3N6K3k2ekk4MWRmT3FxMVFrM21LS1JS?=
 =?utf-8?B?dEI4MjBaMTFVbWIvbDM4aWxlc211UWdEZ2NTMDlWT0lFK0lpQ1ZpRVA2bU1u?=
 =?utf-8?B?VjRuRkVydDNLU2NzcXp1OFBDbDhaeEtsN1dldExPSFJDS3hhQ3VuN3gxZHNF?=
 =?utf-8?B?UWZrdm5PU0FHS2luVHVVU24rcTVjb0lzajRYWmVadFByVTE1eGRuKzFDTnlS?=
 =?utf-8?B?Szl2QXBrMUJNbS9PdzB2cFk2YXJWRjlwejhNZmRMNUt6ajh5NEMyZXoxbkJp?=
 =?utf-8?B?MzFHSVdvT3p3VEU0bStWRStxQnBZNVdwdE5pTGhqL3pjZkMxZXBzcnJnWUVR?=
 =?utf-8?B?bG5YL0t1SmlxOGJQM2lobEk5bkdrcEtBcHZrOUlFRHY2ZFpHcHQ5RDdneHhh?=
 =?utf-8?B?NFlmTDY5bGV1cmt6L2ZOSGZpNm9wRDBQTit1QlRKL253YjNLdUlIMndubFVw?=
 =?utf-8?B?MzI0SHdLM1V4RHRhb1F3QW1SdWxZb0RIcXNmRGVxbitaWkwzenhMck13NTVy?=
 =?utf-8?B?R1lFUC94ekRYY0tCTWJ6Mzd5bUtsanBtS0xWNlpXMktNN3BhbVA1NGRqNm5k?=
 =?utf-8?B?TzlRcW9FRTZXUy95dGQzRGhUcDlWd0pPR2JRR3J1eHF3bm0vOHVqVlNoOXdk?=
 =?utf-8?B?YklXb0dXTEYrTU5CTFZ3U1ErL2UwL1I0SElleG5MTzQ5Sks4bWlSbFVzNEhz?=
 =?utf-8?B?OGtTdmtlWTJreXBBQ2lQY0Y3TkZWQWpoN0tWM2trTDNTMzczNFJqWHEyTnRI?=
 =?utf-8?B?RDNHVzcyMmlwSkhKRXVHOTNaa0dneGlKQnhUUmNXZVZZeTEvc2hlRlFTaktU?=
 =?utf-8?B?OGVwTnVSMDlaQ1ZaclpDL2hlVlY2TmVId1lLZGdKeEtFK1l3L0hLVXVTdTF0?=
 =?utf-8?B?RkpIaDN6WUI2TzhOazdockEybmhLSk9idmlhR2VMdUF6TmtmVmxUOXR6SzY3?=
 =?utf-8?Q?NSBllrK4UtRbof+3wr5LINCRMJYkiRo91+s5Uec?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alU2dmlGYXhaMmpHR3FHK3pBTHkzWTFXaGVhMlJMRVg4eTM1Zm04NzMxZS94?=
 =?utf-8?B?R3JqQ0R3NFhlTk55QkNFMG9UdUl4WHpHa28ydEg1MFNGeEJHd3hzWFZSREl6?=
 =?utf-8?B?UzVJTHBFaThReGZlNDAzTDdhKzdlS2gyeFo5blI4aXJRQjk3Y1N3L3FtZHY1?=
 =?utf-8?B?SmpPSDY3L1lIdXlEZFdGZ24yU0t0OXVKREx6V0F5aGdNMmRNKzhkNUh1dTQv?=
 =?utf-8?B?bWZEN3A0Wk9mU2xkZ0p1VFJJWG55YWZlTGorbkhCaXcwZVZkR2hMa1FNT21z?=
 =?utf-8?B?K2orUlRkVGNISXBhTXcxS1YrdDJydFhvKy9BV2lmTmhmUnVJU3BOaW05ajBK?=
 =?utf-8?B?cU1ObW9XVmFJcFZNbjF4ejVqL2V5dldCdlBjbmNUUmZjU1JMaE1hckErT0Vr?=
 =?utf-8?B?OFpXV3IyTENTc3ZMZGFSWXpCWUxXUHFCYnc1MGUraXFtQUc5VGk2VVQvOStR?=
 =?utf-8?B?QnRXZ3Y0WHpVVThVZlh0bXNFQzJkc3ZZL3VNUGJFZ0IzZ2ZRNUpNQ09JT1ZV?=
 =?utf-8?B?T1RiR09JcFpLbHgvemh1UTNROXBYQ3dXQXJpanB1RXF5SkU5S2RGTkdLK1U2?=
 =?utf-8?B?akxQVkxRcWJvdm1ITlowZ0M4TE8zUE4wSU5jSXcxbDdNbXUxYVViWnZhVnFa?=
 =?utf-8?B?cmJ4RXFsQXVpR0p5ZDd5Z05GMVN0TTUrT01WY3RWVkl1d1ZPdGpiMFJ3ZWor?=
 =?utf-8?B?Qk5Rcmw4VE1OZ1FuLzFHaDBaZ1o2L1ZSZ01iaHJqVnl2ZzNKMTFpaHBCaFlF?=
 =?utf-8?B?SkhUamlmck5XWFpWVFI0ZUd5QzRXZUVyNE5ub0lzdXU4QUNjN0xCeEw3MnlL?=
 =?utf-8?B?UFpFb0o3ZkdsRy84R0JScVFic2JockJSM3Bib1pVOGd5eEo2L0ErTktyN0o4?=
 =?utf-8?B?L3lpUUxrZHN3UXdlNFFOTXZ3akhRWGtFVlhmalVoaGx2cTF0cmdqV0tlQkVs?=
 =?utf-8?B?OW1WSHFpL1V6bmVUbGdha1VJbk12MXBoQURVRHBtYWlwelBsN2xreTBlaUdY?=
 =?utf-8?B?Yi91R09qVk9BWTRsSmZsbnhtcEFjdmZSNWNrU0o2R2REYVBSMkhUdm5mamp0?=
 =?utf-8?B?OHFWZ2l3VUV6ZlljR3VFU0tOTUFrdldQMktyNlU2aWlqK2RzenU2cldqSnpL?=
 =?utf-8?B?OWhNQ0Zid3BXSGpINkNycWR0cjlqaHR3U3NrRFdrYlBQbUJMTmtGcHM2RWRq?=
 =?utf-8?B?UnFmdlo2eTBvNGtjWE5EMGJiNmZva2pMK0s2cEhoSW1FU0hmUGZoRC91cEVo?=
 =?utf-8?B?cU9HSm1lSzcycVh1MWxaTjNuUmZrc3hmNHVWR2o0VDJQeVZTQUk3dW50Tjhy?=
 =?utf-8?B?YW5zM2s3ZE0wTThXR0NTU1JPR3JPRUFPQ2VxQUVhRWFuU0o0RmpQMXdPbFpB?=
 =?utf-8?B?WEIrUGQ0YVNpMWpHTld5NUFRS09CL1VqQkh4bE81dmRJLytjQ3gvM3ZGSHhl?=
 =?utf-8?B?ZndUWlBBa0lsYzFEL0dzR1dLZ1BiOXpOZTYzZkQvdEw3RmZLbzI4WS9oVjc2?=
 =?utf-8?B?Lzl4VllZODVEU2F5a3RPOHVaL25RRU8yclJYZFIzbVFkYUY1YjEzU0tVZkZv?=
 =?utf-8?B?YkpIOHp0N2hwYTlHSFd4eEZDVGRjbElLbFEveE5QTi9BZTdMTW16c1JGdUFC?=
 =?utf-8?B?MVh2MlA0Q2xBTWpleDV6UkMzSG4wS251RnRiT1oyekNXY09zQVlPcGxsSnlV?=
 =?utf-8?B?YldtTHUrVlNkaUordFNMRUpsWm0rdGc2K2JQamtkNXpWeDlrTHg1WWZ6Y3ZP?=
 =?utf-8?B?SndmWUJ5T1Y3L1hLQ3lIbnp6NVp5SmxhajZ1dWkxNHdJaDhUemk5R2lUaU5P?=
 =?utf-8?B?MCtySFdiRlhNU1JxVXk1YUhMQVd2TFZGTnp5bFBkNkhPV1RFcDg5dmJyRnI3?=
 =?utf-8?B?SE5LYi80RlFNSVdKa3JHejJXNVEwc1Y1bWtIMTUrOXlRVkRJTWR6TkY2MmdG?=
 =?utf-8?B?c0JzY2IxQXNZc0tHVTMyKzRsclJRZGlyYm0vRmdpT3RUcHpJTnEzWHhYYVhk?=
 =?utf-8?B?TkdGemRBbnQxOHArQ0pmNmRqQnNEZkR0L1hyZUtHMGxtRWZUb1pWQVliMmxK?=
 =?utf-8?B?azBQV3dnWm9kcG1YL3c3MUFST3ZkbDlmVnN1TG9GTGJuSG1VL0R0SnJPRHFE?=
 =?utf-8?Q?Usdac+SSwOqukEED28HMvbaIL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 623052b1-9eaa-46f6-95f8-08dcc3c0b2a5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 22:12:37.9160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gi3xcoi1jkXFl9YY2V7K9qnbxkokqi549NlIrr2KVs5aXqUIu0AL6mfuOUfkVdjZfZ7xs0sB9ZZKk48dJmYuHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322

On 8/23/24 15:51, Sean Christopherson wrote:
> On Fri, Aug 23, 2024, Tom Lendacky wrote:
>> On 8/23/24 13:53, Jim Mattson wrote:
>>> From Intel's documention [1], "CPUID.(EAX=07H,ECX=0):EDX[26]
>>> enumerates support for indirect branch restricted speculation (IBRS)
>>> and the indirect branch predictor barrier (IBPB)." Further, from [2],
>>> "Software that executed before the IBPB command cannot control the
>>> predicted targets of indirect branches (4) executed after the command
>>> on the same logical processor," where footnote 4 reads, "Note that
>>> indirect branches include near call indirect, near jump indirect and
>>> near return instructions. Because it includes near returns, it follows
>>> that **RSB entries created before an IBPB command cannot control the
>>> predicted targets of returns executed after the command on the same
>>> logical processor.**" [emphasis mine]
>>>
>>> On the other hand, AMD's IBPB "may not prevent return branch
>>> predictions from being specified by pre-IBPB branch targets" [3].
>>>
>>> However, some AMD processors have an "enhanced IBPB" [terminology
>>> mine] which does clear the return address predictor. This feature is
>>> enumerated by CPUID.80000008:EDX.IBPB_RET[bit 30] [4].
>>>
>>> Adjust the cross-vendor features enumerated by KVM_GET_SUPPORTED_CPUID
>>> accordingly.
>>>
>>> [1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/cpuid-enumeration-and-architectural-msrs.html
>>> [2] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/speculative-execution-side-channel-mitigations.html#Footnotes
>>> [3] https://www.amd.com/en/resources/product-security/bulletin/amd-sb-1040.html
>>> [4] https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/24594.pdf
>>>
>>> Fixes: 0c54914d0c52 ("KVM: x86: use Intel speculation bugs and features as derived in generic x86 code")
>>> Suggested-by: Venkatesh Srinivas <venkateshs@chromium.org>
>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>> ---
>>>  arch/x86/kvm/cpuid.c | 6 +++++-
>>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index ec7b2ca3b4d3..c8d7d928ffc7 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -690,7 +690,9 @@ void kvm_set_cpu_caps(void)
>>>  	kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
>>>  	kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
>>>  
>>> -	if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
>>> +	if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
>>> +	    boot_cpu_has(X86_FEATURE_AMD_IBPB) &&
>>> +	    boot_cpu_has(X86_FEATURE_AMD_IBRS))
>>>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
>>>  	if (boot_cpu_has(X86_FEATURE_STIBP))
>>>  		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
>>> @@ -759,6 +761,8 @@ void kvm_set_cpu_caps(void)
>>>  	 * arch/x86/kernel/cpu/bugs.c is kind enough to
>>>  	 * record that in cpufeatures so use them.
>>>  	 */
>>> +	if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
>>> +		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
>>
>> If SPEC_CTRL is set, then IBPB is set, so you can't have AMD_IBPB_RET
>> without AMD_IBPB, but it just looks odd seeing them set with separate
>> checks with no relationship dependency for AMD_IBPB_RET on AMD_IBPB.
>> That's just me, though, not worth a v4 unless others feel the same.
> 
> You thinking something like this (at the end, after the dust settles)?
> 
> 	if (WARN_ON_ONCE(kvm_cpu_cap_has(X86_FEATURE_AMD_IBPB_RET) &&
> 			 !kvm_cpu_cap_has(X86_FEATURE_AMD_IBPB)))
> 		kvm_cpu_cap_clear(X86_FEATURE_AMD_IBPB_RET);		

I was just thinking more along the lines of:

	if (boot_cpu_has(X86_FEATURE_IBPB)) {
		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
		if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
			kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
	}

Thanks,
Tom

>>
> 
>> Thanks,
>> Tom
>>
>>>  	if (boot_cpu_has(X86_FEATURE_IBPB))
>>>  		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
>>>  	if (boot_cpu_has(X86_FEATURE_IBRS))

