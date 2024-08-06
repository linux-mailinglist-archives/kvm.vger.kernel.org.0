Return-Path: <kvm+bounces-23379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9ED39492BB
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D763281DF3
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7C118D640;
	Tue,  6 Aug 2024 14:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bmP7qZxe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070.outbound.protection.outlook.com [40.107.100.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F0618D624;
	Tue,  6 Aug 2024 14:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722953548; cv=fail; b=gIItdveoSEs3bGcrRQG0yN3DbEA8boj9RKqpg4J2di01xDfJu4uxJgMNTc+UT2e2j7roOTsnsKlTIypXy5qngiuK5bt1nMLqiMtvXXoRUQU89sdlvA/pWUchEkQClIsD/QY7Cgw2xrzz6y25EviFPqffjEvT94J7SSzLRSvNW+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722953548; c=relaxed/simple;
	bh=DME9hv14GTXY3WWqYplIVgxx+Ldj9mnVUXfkEvNkjyo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D8idT841EjX8AZOpWBzSGafGrPRQ+xt6wnRU02F2wfjdZkHOVAoMKqrT2Bpiuo+U9s/YnSdzErBprbBbA1OLUOBa76eL0fxUspcaizjt58a3izY2srCRPKQYHyCWwJm5PhIrx6kmYF6GK5mj9PSezawDLaPTUM+lvua8T5x17lU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bmP7qZxe; arc=fail smtp.client-ip=40.107.100.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NueDxx0ZuxjHEvq+dACKQFpwtdZ0iy4tdfkxV2C/hbEuaZg3V043iMJoIEFkUOkNu57p8KTZqkLVvM/dIGMQE3HuKyqjCsyoManjy7PNaMtw+ipWwCA1i81n3ILaN11Cv6rfW5RghbGNFqLNyEP+QIBh3gm40MGk5eXf5kiAb5Djk7edgmhoA+xpfvDgCLk7S13BnV97+kcsyGP5LWYGF8j/O0qwPrQE74DRcIE2DbxlvazAKFaXlgZANF5Tm2QmRmIom7nV21qWpugqaw+I46ch5wW9trKikIsk2s7Y2CgeOTqzXSfhfmCmsGjC/9UdrG/nP1L9XKGXDrXKFEsHNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9L6NANQHrM7GeUjSHXSEr0A5lcZ1jEX6/HxX8wzWSg=;
 b=MlAwCMI7M+/ql8+os4WGh9hF9gSlEDkwyRO+1+JRgCr2H4bJW0QpLjeFXcEDSGgjRdFxY5y8Fr/Cei2ENcr5LEiPi3W0zVvET+53LTGVqQHuSgzd+BxE6ceMVyBU6tviAVIdsK/1YvAgTfWjsZO7E9+/WMw/eymDilKBQy7oVwag5148ZUdKYTYVfP450Is+D4kR/nR00af8y/8aJTDpwnzIgjPPnjlX2XyD+0CaIWlJC56XRkptENWOTqG4wTTjuIi6JENg6CoPwe7n1PKuJeMlpMLLPqRYCsyhIwoWKb92GZ147HTkzcWxCO7EgLc9QFoellODK0j4bDD97fN3pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9L6NANQHrM7GeUjSHXSEr0A5lcZ1jEX6/HxX8wzWSg=;
 b=bmP7qZxeNSjL8W9vkntDS0b1Vfo3kq+NCOeUebgOWkfvno3E+AR0pisG0wFZxVN3Zxz3lmzttRot2COupEKWjvQdQx2QYptqG3qMLn+BI5250UClOtU3G30yYvHu+zljC4HDvZq0aRCjGFr0pQJhAXz4xYD0Wthl9S271UTIUEI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB6189.namprd12.prod.outlook.com (2603:10b6:8:9a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 14:12:23 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 14:12:23 +0000
Message-ID: <59a6157f-973d-8568-7b3f-bb9290cece99@amd.com>
Date: Tue, 6 Aug 2024 09:12:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 3/4] KVM: SVM: Don't advertise Bus Lock Detect to guest
 if SVM support is missing
Content-Language: en-US
To: Ravi Bangoria <ravi.bangoria@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 seanjc@google.com, pbonzini@redhat.com, jmattson@google.com
Cc: hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
 james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
 j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com,
 manali.shukla@amd.com
References: <20240806125442.1603-1-ravi.bangoria@amd.com>
 <20240806125442.1603-4-ravi.bangoria@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240806125442.1603-4-ravi.bangoria@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0227.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB6189:EE_
X-MS-Office365-Filtering-Correlation-Id: ce319854-f0d0-4683-32b4-08dcb621caa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?LzgvZjNRc21rT1FaT2d6bjJrRXlpM0lnUTlkVUxqeFRVVVJuR3Q0b0cvZ2xF?=
 =?utf-8?B?cE82U1VTdDlPdnVaWVdMeXZFT3MxVVIxbU5ydnViZ2VhSDRhYUhRV3VVdFJF?=
 =?utf-8?B?TWNPeXEzZ2Y2ZU5JVjBZbWIreDVqRUNORS9sODVwYjgwRzVXU3I0UjFsWkRa?=
 =?utf-8?B?WjRSVHJjTlVBeUtXV1FFSUxHeFBTOTY4eTlXSlBBR3pLTXhmekduYTEyWUZt?=
 =?utf-8?B?WWd1ZTN0ckZ1SmdTRDlmOGlTNk11V2kwOFJxRGhjUmttZFEzdlFkZ3lpOW5k?=
 =?utf-8?B?THR5YXU3VFZvUWM4YkJNR2lLcEx6OXBOcVJwN25nL3ZUKzVGOWx5SWxwZVI5?=
 =?utf-8?B?b0RxNXJUVWNTaDFhRE9SK1AvS3ZDUXNWQ0FDVWFJbnJobGZ5TjlhSHVzdzAw?=
 =?utf-8?B?cUkxZU9KYmdOa21qQTdiSVpZTVp5ZGdtM3lTK3RYNUkvMG9ZUFhxZWVDZmkw?=
 =?utf-8?B?VVlJYjI4Q3lHczFoV0crcU9zamw3bEtIMUtDRmp2cEk2cFNDekVXNlM5RHZ2?=
 =?utf-8?B?U2JmMGxuOU54bUpsMmZZZDJLOFJlNjYzSjJlcm1mdnJIbkNobGIrZXNnRHYv?=
 =?utf-8?B?UkoxRHBBOTRIbUFHZ0VYRVRnQkl3RURac25HdVQ3d0cvV1FsL01WN0tGZyti?=
 =?utf-8?B?V2V4VUFqeGhTeERPWC9XY2lKYnFPWHE5SDV4UlJiNzQ5dnFVVXo1RklkK0dQ?=
 =?utf-8?B?MUpUMGVReTBNeWlQczROdXE0V0tnS3dwU29XVGdqTFRGbTNaWFZTa0pHL3ZN?=
 =?utf-8?B?T3NjY2V3bnYyWTVVa2lNZnhMdXYzV09aMHlseSt4STFOeXJqRzIvaC8zK2lt?=
 =?utf-8?B?b29HSzVVMHRreFZrQjhDQjNSL0NxSGR5SVVQd0xiNFdDSGxoSTJvTE1Yc1Rr?=
 =?utf-8?B?Qjg0dEIwdlk5ditYMEVHT2ozckhNN1hwUDdscjR5UXlhMkU3NllNaDY0T1hl?=
 =?utf-8?B?ZlFSZTBYZUcvcndNb2RKNzVBelBEMVN6dTVoTW11VzNGYTRjaTVrYm5pdE9y?=
 =?utf-8?B?TGg1cnpYbWc5R1lLaXR6TFNDWW96bklEd1pZc2ZjNGxSS1ZudlpmYXR2eWIv?=
 =?utf-8?B?N0ZkQTJPUXJjQXRMekZsNjdxNmNCNlMvUENYV2lyaERTMHpsTktxSjZRR2Vr?=
 =?utf-8?B?aTg0emwvZWdnMCtxQXk4MTZvQTU5NW9hWDdiMkhEZkVUQzI0MUVsT3ozNVdt?=
 =?utf-8?B?OUs5dEhITkFLK3JYbWNBWndDSnRjNWEwQnZKR0JBRlhmOUwvSUhwNmNEN3JP?=
 =?utf-8?B?Q2F5aERONDB1RHlrUUhmaUpNbzBOR0ZNdFIyVko4ZFJtdk9ONndGNlFMQVNv?=
 =?utf-8?B?U242K2VXOW9GamtCTHE4Y0s1QXdkdFZkRTF2SVB2YjEzOUJDaldubHl2Wm9H?=
 =?utf-8?B?SjV3bmg4Zzd0VEY3d2RYUlpNLzZvZEI0dG5UcEM0L05UaFhSTkN5dWY1OGRR?=
 =?utf-8?B?bXVlSlRHTkF3RHZVeGN0SXFCRGt6WHEvS2RiV1NIWGx6N0dzR3pGb1NSQ3lr?=
 =?utf-8?B?S2NnT0lwSTNUby80R0VmYVZrWW92SHNOL3VDV3BNUm9QbHFHdFVxYWtDcVFB?=
 =?utf-8?B?SHl4U2pIUExnYlpDdUNHeWpJWWMvcys3UjhFNHd6NFZTeXZTTG8zRXFMeUI2?=
 =?utf-8?B?Rk0ycnhEVnVLK2NGaFNKemVXdER0akY3OTZrZFlkNjFyWHBLSU4vQjc0MU1R?=
 =?utf-8?B?RFdGeW1HK2EvOWVxTWdnN280aks4L1JiWjNOVmJEZk5JaVVVN0wzbkY0Nnlt?=
 =?utf-8?Q?kmjx0ViQaYn7SCwm5s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUdkeEZjY2V0MXBDZWxBRk5ycVNreGFKamg1cjUzSmIwQU1sRGtxcm84RFM3?=
 =?utf-8?B?WDdjYW9nd2xvYUIwVEo4TFRKZlVnK1FmUDA0WFZqeEtCRTA3MDI2UGhQalNC?=
 =?utf-8?B?WVBIcytoVXVQYS84UmVsL0tJT2lnMGhvSldKeHVtU0p5bTN4MTNwdVhDUDhY?=
 =?utf-8?B?NzRCM0k0MkwzQWRtWm9pczZsazBBSGtubVhwRVQ3UUVhTUhsWmVmMkVaNnBt?=
 =?utf-8?B?clVtU3RTYk5OenVjVHV0VXpzK2p6cHJwVlpxdEJBeEFJalZidmJEYVpTOFd5?=
 =?utf-8?B?OGNKeVZMSlZJYnNOV2VGWHFUQ2ZoNTA0b25nVi84dVRKdWI1RE9UYWxkK0pU?=
 =?utf-8?B?ZlRrQkt4RFZXSU9aU1hPZnY1MFI5SFdlRGF5bXIvVjcxMVd3Z3U5TGkwclZN?=
 =?utf-8?B?QVpvSjE0ZG1HRTNiczlPSTZ6NGZsR1lKMCtpT081MUsrS0VhRmM4OTMxK1do?=
 =?utf-8?B?S21pQVVFQmZrZnI3eUhvYUUrQXdmdnVtNWRGRGh3eEdrT0IrbHFmNVB5VlJX?=
 =?utf-8?B?Q2JDRWxEUTNiR0dxcTU4M1RQTCtiQlFTTXJQcHdhU2hoYlBCWXR1ckgxcUhT?=
 =?utf-8?B?UG1zTHhnbWJWSXdVZ1d1Wkpyd3JhbXgwWW9FMmZ1S21RVG5yY0h3bUowQXRH?=
 =?utf-8?B?WlVYaUFreTlBWEdVdkRsc0d2WkVkTVNVSitEZGx4OXRMWGZ0czFMbHpuZ0lu?=
 =?utf-8?B?WU16aUJnMUhXUjQ3cUxBYzBPOGdRUjVBcHVNblpvekErUFB0Y2VhUTZsejYw?=
 =?utf-8?B?Y28wVG8yQXNyenY4Mm5CMGJQV0dhZjV2TlhtdUphWTdzcVNVNjZucFRyWlBl?=
 =?utf-8?B?dyt4ZjJrb3NvNzB5a0Rkai83Qi81UGc3TjBDQ0lkSWFmUzBndDY1RVNraU8v?=
 =?utf-8?B?ejU2R0VyQ2tkL2RaSU1TT3MrRUtBamlIY2JzZFRnUjJpQmprTHJEVFNXU3hj?=
 =?utf-8?B?Q3lnSXFuc0F3TjdUNjJEYSsycUJORlJnSHhyUHZBTU1tSFZzcXdrUFlMV0d4?=
 =?utf-8?B?UjNGaGwxVGxxMko0R1lFMHNxSlVRWlVXWUhiWURyYlVJZklqSkE2Tjg3KzVU?=
 =?utf-8?B?WXBjTThKMzhWZzJZcUd3ZFhYTzI5SlQrUlFldWFIcE5lNUNXcStjQjhNL3pk?=
 =?utf-8?B?cXpMM1R3WEthSzB1NzNDMnNCQU1zM3hEQ2IwRkZ4SWw1UjkyWmp2QnhqYzVH?=
 =?utf-8?B?VjRhMVluK2dMVjJMRFVKZjFRb0ZEWml6cHNITUR3aHVZT2grTkczU3lMOE9T?=
 =?utf-8?B?ZjJpczRVaHpVZU5yYS9rY2luSktCcTV2M0RYUVh6MjFTcTRLa3dnV3JhT3ZT?=
 =?utf-8?B?WG92d09PS0lHQXZLaEVocFVNZVlJTi9hN3h3SE5SYTk1SHNqbjVMeW1pREs0?=
 =?utf-8?B?QktxS2REU3RMcGJUTU51bVkvTjZndStmRGxDaUZIQ3JLTVc3cHkwaWFQYU1O?=
 =?utf-8?B?ODNueU5hRVhmRG5VMGZ4QXVmR1hmblVKQVlsZEhPU2FUNEVoVEtsV3hwY2xr?=
 =?utf-8?B?anVUTUdzNEo3RHN2RlppNWFSUUxONENWMHZOak5PVVNNL3YyOVVDTFNjTEN6?=
 =?utf-8?B?OWo3T1dhU1hiYUorWDQvYzNEdmxhWjQyYlF4Qy9JcjVBVGd4eDRMOGpJQ2c2?=
 =?utf-8?B?N0trWG0vTUZmUVVWTnhlN29KSVdpNnpsSXhuL0JQUkNQdUZQakNhdzFMbXV6?=
 =?utf-8?B?NUwvMjlrcEVTQmJ1Qng4cUl3aVBYN3ZKekJIT2laMjhYL01OTWNVcjkwVDY3?=
 =?utf-8?B?VmllZnowaHZGUERQYnpHaFpYa3ppOGdmWmlzWk5TTkxHQmNjU0lRdzNGVml2?=
 =?utf-8?B?ZlVyVFhDKzZqdnVoL2JYdjZUNXJlUjZNZS9ydW5LOVJGaXZ2UE5KNjFmMFdr?=
 =?utf-8?B?S3hoV2tnTDkxZjd0czRQa0d4K1hua0E1NHJ5VHFieitQd3I1Z3JTZ1RabFN6?=
 =?utf-8?B?V0xmclpPdW95OXcrTFlFNEhNcmpMYTZlUEtSWThqY3JIcUluNnJ3WU9CdFJB?=
 =?utf-8?B?SENMR0tkeDFlMHUrTHd3NEVzMkQxdnJUbHNGemkxaTM1Rk5ZaVJXNURBTklU?=
 =?utf-8?B?Rm12cno5RVdTc2xrOEtaWHNMenhCaG1NZUFhc3NUREdKN3ZLZm9NV29lcGhs?=
 =?utf-8?Q?DbCy2GsSnewQGZ0lJM5LFX2j8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce319854-f0d0-4683-32b4-08dcb621caa4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 14:12:23.2404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Drlej/gWG31xcCTaKtKoYPewNDlZkmfv5Dkxds/B6k6QQg89BqotyPoYGNQUI0f8g18Qg8m5KgBHLXw7IUeppw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6189

On 8/6/24 07:54, Ravi Bangoria wrote:
> If host supports Bus Lock Detect, KVM advertises it to guests even if
> SVM support is absent. Additionally, guest wouldn't be able to use it
> despite guest CPUID bit being set. Fix it by unconditionally clearing
> the feature bit in KVM cpu capability.
> 
> Reported-by: Jim Mattson <jmattson@google.com>
> Closes: https://lore.kernel.org/r/CALMp9eRet6+v8Y1Q-i6mqPm4hUow_kJNhmVHfOV8tMfuSS=tVg@mail.gmail.com
> Fixes: 76ea438b4afc ("KVM: X86: Expose bus lock debug exception to guest")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/svm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c115d26844f7..85631112c872 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5223,6 +5223,9 @@ static __init void svm_set_cpu_caps(void)
>  
>  	/* CPUID 0x8000001F (SME/SEV features) */
>  	sev_set_cpu_caps();
> +
> +	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
> +	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
>  }
>  
>  static __init int svm_hardware_setup(void)

