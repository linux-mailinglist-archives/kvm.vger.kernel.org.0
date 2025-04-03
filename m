Return-Path: <kvm+bounces-42578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE429A7A2F5
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 14:36:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42E681745E8
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 12:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB2124DFE0;
	Thu,  3 Apr 2025 12:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ss6ic35L"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFCA19E97C;
	Thu,  3 Apr 2025 12:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743683778; cv=fail; b=QV/GzMqkdr0n90Cqn72+28TGxUyNek0KhCDH9HbxFm3BB75zDPpwphBzic8mbZAWVWXH1p2KKggm/bnE7qL/TWgnM8pGh554UspQ+ny4R4YHoIJHzDsvYOyiidlp9rBF737hbAjO9BpYyCe1bjRudC5E6lkywh2zU8b/jjUg8cU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743683778; c=relaxed/simple;
	bh=D/u2BHenMZumyrLMyLGaCJagim5ckEGR2MwL8Ho4taA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QC+UQaW7wFR2EBxbp6b6Une1hANnG2i7CnNlwhkAquX+SwSG0lDDIsesTbjgZPXpmy5Th7mDB4IQraA1cYEf7L7y7ZRvVayi7oubS+fRINf+iPYtfUjyUa9L5Fvzxsiwnm16kBMdazIPeqy0M+2hbpcjiyxEGEi+6k0QSxd49X8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ss6ic35L; arc=fail smtp.client-ip=40.107.244.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cmEPU6Z+lJ21tWECCzP1Ki6nv3DGL5UTo5ENZKvq9qsi2rnsI+w14MlF0eL6U7zLpGwbBKGwgsLgRPpPvXXLw2UH2r7qBNXXj6blsiBw6/69lfqbiRiaurHSMrJG+7bwDxaq7FqsOdo0l+KTLiktPFmxQe1CNY1SGG075KgLLeeY1CwI1DNGzRXBt7Ln6vSX/hzizFKVHIMXf+oKjmwAWpF5yyau3rlrlK0jjI2X86660952VrzJL1JexdC61XlyHjCiMI9/GFZmTiSLSK4EWa4pe7aQabu2sN8REl9adpkbRZ9lQKouFN+9125WdcwQjHdvFrpjufEnKBUwEcVoEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zt99MCqRFNOdM/ynZ0mWS0PfGHUe7VZakeDfAI/Hv5g=;
 b=DucHXhz6YTioI37QEGNeHgb3zbP5zeIU40ywXVHmSBxEDe8BRzbXXrnYUegWQBwwe7/mZBmGTd0XRfPw8UIqLegUheDGpoTFGj7LGeYO2JmdvOEWreq9e9knRmPUhMkA8b9BSUzEFfWnPJlgibFgyfHUBoHe5tRdEw10yJE6D8Cr5tZ52fxN0eMi0XWMA5uKPiWnxAt7qsdi0lTRtQnYdh5WsYfpBqYLhExnW3hYsdYeVzpG0b8rmFej9k+jQI2nPRxxI95KxfUqK856NbIYJWVKLJoc4ncOggBwNmiOqRfmkX6dWFF4K2+qmWpu0NsrFeol2vbH7XNA83Q+DIW+cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zt99MCqRFNOdM/ynZ0mWS0PfGHUe7VZakeDfAI/Hv5g=;
 b=Ss6ic35L3DFfz2KUG1795AI6ZE3OGPvYwrXvmVZ7i0K7VkRpuU2cyFJtiihWfnr8GcoY3Fms+1jc7PQ+R9gZwmTN4CJG+Ud5SbvdSMV1ckfa9i+2QFbo+0s6QkkAkbsIFKQpcaGBYmGdKjczB/jE2Fn/uVQRb1AChKRYTb3sbDw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 BL3PR12MB6377.namprd12.prod.outlook.com (2603:10b6:208:3b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.43; Thu, 3 Apr
 2025 12:36:13 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.043; Thu, 3 Apr 2025
 12:36:13 +0000
Message-ID: <bd1869cb-f898-4bb8-883e-cfc5522eca94@amd.com>
Date: Thu, 3 Apr 2025 18:06:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/17] x86/apic: Support LAPIC timer for Secure AVIC
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
 <20250401113616.204203-8-Neeraj.Upadhyay@amd.com> <87v7rlv3wo.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <87v7rlv3wo.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0174.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::30) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|BL3PR12MB6377:EE_
X-MS-Office365-Filtering-Correlation-Id: 42411425-8779-4acd-d9dc-08dd72ac1e71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SG9hOHNPWkUrTmtoZWFqbWhqMmYyZGI3Y2dLRnlEZkdKZnprdnQzcnREdFEv?=
 =?utf-8?B?WFllYWhIOHJsKzhaVjBTbURDVy90RmlMdTRtT0FYeGcvdXFWeWZRTjdGQXZW?=
 =?utf-8?B?eFhoVW1pcFJpVEtpR1NkVUdmaEFsNlJYdVJxOUxucHV0akQ1d0lTVVloYW01?=
 =?utf-8?B?T2lEMEI4a0ZkalZIUjBhd3MrdU13TUxEbkY4YjhCRWt5amRGTXAwM1Y3MjEv?=
 =?utf-8?B?Mzd0aWpVeWZVcnk2YjZDNGxJS25uazFZNlFid01FL3M3a1Bid1dNMzl2RGN0?=
 =?utf-8?B?ZkdvOVlQQlgrMUhIS3lBWFBrSE1YV0FoSDBiVG5Kd1pBSUVkazEySzRMd1BJ?=
 =?utf-8?B?czhOYjlLZU1ieVcwQW96SGZnYmFmNDZ4SkcwQ3BrdFYxb2c3U3NKTy8yVnV5?=
 =?utf-8?B?VmlvV015aS9QcjVwVHY1SnVocStrUzFNWE1TbWJ4b3JzUUZBMnp6enYvWng3?=
 =?utf-8?B?QTBuV2E3SEs4OUhNd1JYZmtWSnluKytNcUpJQUdubndocGNJdzFmbFMrL3Bs?=
 =?utf-8?B?OHN3VllwTWdHSGJoZ2tzeFBmbXdFKzQyZ21mdm9UTzJXcmgwcUovMGtZSVk0?=
 =?utf-8?B?NG1GTi85WEI4UlJFR24yUm5sNXJ5RnNGTFlGVkVtUXhwd0x0ZXl0WjJ4VlBo?=
 =?utf-8?B?ZXRIUHZ3NHc2RUJuRE5GL3A2VXFFQUkxZzFpS1FJRUhsNm5ZbU80bmljdU5B?=
 =?utf-8?B?UVVMVDJLaGRGTVBNdW1YeXozRTA3N0xIakE0S0tIcHk5NndZWGVMeGJwWnI5?=
 =?utf-8?B?VzRWTGpqWHdJTG1rTkdXZzBYSHBCM0dBOE1ZNHlodXZUMHhGMUFQTzRWem4z?=
 =?utf-8?B?SzdWRFlaZTVna2tPY3RKMFFEUDh3akoyWHhBZTd5RXc4LzF1L3ZUVXAwWFVG?=
 =?utf-8?B?Z3ZLNk9IQUFxYVoyZzNnMVB2ZFViZ0FmNTRUUUVwQXVjQnhVQ29MYWd6di9X?=
 =?utf-8?B?TFB3TUUrS1lvVzBBeFRzOTVCbjNCRHEvS1IyRGVEdEFoR0xsaHF1ZzRpY0pE?=
 =?utf-8?B?RVk2Ly9NRzF2MmI2VlV0ejV2R1BBV1E3WGNRcG51TXlCMno2OGJZTDE3VWl2?=
 =?utf-8?B?RkN5a2owODVQRXZKajB6a29WOVpGL3dwWlNiMktUcStSSHY2S2lQN0UvL3E1?=
 =?utf-8?B?ZTNObDBhQ3VCL1A0SkJaZXVVTjRtS3B6NjZrcUg0S1lHMFltNjd4K21XdWt3?=
 =?utf-8?B?OGJlK0s1TUR2QjZlOStSQnlTUUFNUEpaRGFDcVJnelV3UDMybHEvS3FzUXFD?=
 =?utf-8?B?VXk5OTRXSnh3a2RKWjVzZlIzdS9XT1NFVWpOY2YzRDh6RlFucnFLK2pSQ2FC?=
 =?utf-8?B?REYzaVJadXBMcEFZbmlwbk5EeHNqQUdES3lVQlFDY09FY2FqNmJmNkVpWDNm?=
 =?utf-8?B?andwMlY4Z011R2ZwbFpFV21yUDFBZkdRVmtoWFVaaUtrYnBLOW93bVNEcXVF?=
 =?utf-8?B?cWpLNmRzdC9ESHFwSG9UcmJocVpHY3BtMGNWVE44SUZ2cEJnSHFGRzFzZU4y?=
 =?utf-8?B?MFVlaU1GUFdGUXFpNW5kQTZPSzR0eTIwNVpDSkNMTld6OGxvV2VQelRpUFBY?=
 =?utf-8?B?Tjd1OGVyRDNuL256K1lrdjYzVVdsQ0tIUFN2cGhiRmVxZ01WdGp1bzVXTW14?=
 =?utf-8?B?RkVRZzNJVDBxZE95ME5DMG92c1dLWXhXSmpxNDkwNzRqNGxXUE1GVmJab0hy?=
 =?utf-8?B?T2UyamY2WXhOVElIS2h1dENHRXdJRElQS3YrRUQ5Wm1RNjdGbXlhVEYvNEFu?=
 =?utf-8?B?WnkzL3BLRDhpYXIxWGh6OU9ZV1MzUDJOOW1mbU1NS2hEKzBqeXNZR05QSW5T?=
 =?utf-8?B?TWxTRVdmR1BvUTdmeUxUT3pDSHNVTmFlSlRONkp0UHJNZjZVZTg2akV0QWhW?=
 =?utf-8?B?N29MeGoydnFDV0tPWXRYZXZ3NXVWdDZ5NmM4b2UyRUdXUVo0YVBwc05TOURT?=
 =?utf-8?Q?Zp8gRb/fCRE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0cxdzFYRTJxRlhFREpHdW9wdmZLVFFIbWRnRUw4TjcycnNNdGszSXAwZWd4?=
 =?utf-8?B?a2NyT0RBYmc3TUZjVjRDNmdQemVkOVprVXlQcVVIWVU3Z1NZNVdSbm1MeXRJ?=
 =?utf-8?B?YXNSc2xpRnlSckg1Mm1weUZYOWppOU9pWG9ab3Y1Qng3Q2tUTWJ4T3ZNb2FI?=
 =?utf-8?B?UlhsUDk3Q1piaTBiZmhkSXhLTGxKNTQwQlFGS3p5Y3owVGVTR0QvdGpCclhP?=
 =?utf-8?B?ZHhrb0tjNkVZS2traHBrdjNtTFVGWWhRWWtGcWI0b1d2RjB3WnpBSkFJaWNU?=
 =?utf-8?B?djRtSG1rTnViWFFhY05qcGtRbi9lZGFtS05iY003MlJFZTlpLzNFTlRza1B2?=
 =?utf-8?B?SE9ZaWFJRE9FWmVoaHpjdUFpTGNtWisxSXNEMVlvUmp2UUlnTTRuOHNYV2Z5?=
 =?utf-8?B?RTA0cm51cjdjbCtVSHg1MUlMMERNWmpLY2ZjeWdKeEFRMVVSSUx4Zlk4T3Js?=
 =?utf-8?B?bGhQb0YxNVE0L1JuUXMwakFVVmRrOGRMclhnSHZjWk9tUURNN0JSTndjRjVj?=
 =?utf-8?B?TEc3b0dQb2o1dmhKUjl3dGJlbk0vc0pqSGxTUnpOZmVpVzAzNmk0d2ZkWEFH?=
 =?utf-8?B?cFhTYzdUSi94am9VcWhSQ0xoT1JkY2RGSGhJTTUwTnFuRGI2T3pycmFuRlJO?=
 =?utf-8?B?TUpnL3NiUlhlQmFrdUNqSjRNaUZHSHNvZTNldllyNzFrcnB2Q1V4ekZvQmMx?=
 =?utf-8?B?MXJBY001d0s5WnNDN0FtRTM2RTcyN0RKNmJLcU52bzNqRTM1MmlEemZ4T05B?=
 =?utf-8?B?ajhvZEg4a1FnNHRuT2s4blBLZWJ2R3A5WS9YVmQrMTJINzBnbUZqMjgwNzl2?=
 =?utf-8?B?SkJCTjBaTktDUEtjbEpRd3M5bEZoZW4zMFFjeDRsbVZlcXRMYWl0TmY1TTYx?=
 =?utf-8?B?U1hhdjczdy80RUdjcWFtTGR5dTdSOEZkMEl5bWQ3U2M4WU95TjE5a252VnJW?=
 =?utf-8?B?Z3VRWkU3eWt4TWFLRXkxbUJuZEVndUtQTVBXWk5TeTN0eCtDUmlCNExidjdQ?=
 =?utf-8?B?MTJGN0hOWW9GeGtmaVRQQmRtaFZDMVR2a3laeURSVzZyWGZNUzJhZXM5NTFU?=
 =?utf-8?B?bFNVNTJVc0NEdDg0SmQ1YWNLU3RUY2l0cW1FOTlBZGw4d2FsQUhEYkcrdHZ4?=
 =?utf-8?B?bEtBb2h2OW1reFBPYi96OGRSNFA2RkF2bG9iazRXNGtLRklmSG8wSWNQQnFp?=
 =?utf-8?B?QzVlK2ZYeG5yYnJSb3dOYjF5dGk3bEcyT3hvMERUY3ZHKy9WR3lnRGlIUHov?=
 =?utf-8?B?dFh6aDFFclo5SEFQa2trN3ZPMUFKYU9uK2VWa3N1QUN3aXA2Rjd4ZW9UR0tJ?=
 =?utf-8?B?RmkzTldHTUM0aVRFSDJRdGdWVENvKzRtSlZPckIrc3B1R0NZMVFaUzJjelVE?=
 =?utf-8?B?OGozSlh6OUg3dUp3REVhTjF5akNUckJxOXVJcTBVczlIb3RoeHYvWFF5U0tO?=
 =?utf-8?B?QytPcXVWTHJzWFlBd1VKSkVHK1cvVml5ZXlCcmQ5NGtXVE1kZXFuYVF6ZWJq?=
 =?utf-8?B?QmEyWkhGSHJjMWpsR0daRWNMREVVazlya3lPeGtZNFFwdnFvWE5JMlFqZjIz?=
 =?utf-8?B?U2VRZGxJaGRMeVJwQzN2bGdWQWhTWWxjSkxmZ2ZtbzZqNWxTa2RrWUtJYXQx?=
 =?utf-8?B?SmhXTzdGL2x0ZVFYOG1BSmlOV2VSZFRzdS9LNXY5UTRraEZLQ25PNldyNHNI?=
 =?utf-8?B?L2FyY1RCVTVpZktmaTRmMDhaOG1EMFg5UmVYNFBsRzlacTJscVBQVDRQYUVj?=
 =?utf-8?B?ZndtMFFqS2VWeW04Vm9DUiszUkVkeElWVGdCQUJrMlhIb2JRaWcxdG55UTRW?=
 =?utf-8?B?ZFdKSlQrWHFSdGhPTUZXbnl6VndSS1ZLeTF2TUx0Sm9MOG05ajNDK1NwZFQ5?=
 =?utf-8?B?NzhRYUpnaW93MU5nemFUdWhQVWlORWdSbWw5YWdoR0NDc0JDbStjN2pMVG9R?=
 =?utf-8?B?NCtrYUZRRnovaC96TjVXcCtzOEltbkZHWWNZc3plYWZPVjU2bHZPT1J1M3Bq?=
 =?utf-8?B?VHhseDJRdmQxdWFSZDNkT3d6TTVzZGdYdkQ0N1VQZmQvdDhKTVVSTndkK1lj?=
 =?utf-8?B?U2RkU0tZWmlPbFdNR1M0bWJLSWo0TXlJeWlGRnU4cUEwNGlMdlY1Wm1zQUZG?=
 =?utf-8?Q?cf1v9ONonMlZnP2Fo216H7mD0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42411425-8779-4acd-d9dc-08dd72ac1e71
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 12:36:13.0978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hmlZwjfAgNmDZVKrdLcCQaqGja4jA3imAgCIySOpxRGRzsN12ETftYpkknvvot88Y1BVetarASVZTsCI5Lf6MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6377



On 4/3/2025 5:43 PM, Thomas Gleixner wrote:
> On Tue, Apr 01 2025 at 17:06, Neeraj Upadhyay wrote:
>> In addition, add a static call for apic's update_vector() callback,
>> to configure ALLOWED_IRR for the hypervisor to inject timer interrupt
>> using LOCAL_TIMER_VECTOR.
> 
> How is this static call related to the timer vector? It just works with
> the conditional callback. apic_update_vector() is not used in a
> hotpath.
>

No it is not related. I missed the point that static call is only for
callbacks which are used in hotpaths. I thought that they are for
callbacks which are called from multiple call sites. So, when I added
second caller here (first was added in 05/17, in vector.c), I converted
local apic_update_vector() in vector.c to static call.

 
> Even if there is a valid reason for the static call, why is this not
> part of the patch, which adds the update_vector() callback?
> 

Again, this was based on incorrect understanding mentioned above.

> It's well documented that you should not do random unrelated things in
> patches.
> 
> You really try hard to make review a pain.
> 

Apologies for that.


- Neeraj

> Thanks,
> 
>         tglx
> 
> 


