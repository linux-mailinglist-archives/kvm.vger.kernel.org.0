Return-Path: <kvm+bounces-48139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8222FAC9C78
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 21:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4190B17DB5E
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 19:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 829B11A23BE;
	Sat, 31 May 2025 19:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="arc1YP4D"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418A42907;
	Sat, 31 May 2025 19:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748718898; cv=fail; b=ip9pdHY0gIYGYpIzpPU4HSdx81x4NwHxeRblb1KAX4bPN5Hs7W2YyYjuNvtHNScUA0f/kZ5WlJN0qDpcas7zgATrL/jlze1QpJNJ7jV5DvnajFQzjD/q8zmUYSXYKteZnCaITz2xnJ+vw6K4DNKP6R4B/YgbAO6Fi8MCWPkZSY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748718898; c=relaxed/simple;
	bh=/dag4xhcL4EUthTwQrCBHq9qfDElhUtcJtNMe0tFYTQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pBapqZ8vV91kELJtJvH1rO5NuS/CLHaxm7MT4Rst3FagI80HOmnV410pxBd9pfEpJynds933XjqwNQKrnzTecZH5mqTxGO7JmYZoiAMIeQ/yHPFXwuiSUOo5AJ+xwbCEmQ7hZ5dx+/dzJyjJCN1MkzDMN2AzYChWSFZiHZNs1xE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=arc1YP4D; arc=fail smtp.client-ip=40.107.223.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ps0600ZrWMRziZaFCNnHFgNl2Zb/LuLYc/c1Dz+FC4d1iv10yvJjtS6euCEEoy3WOedinC1ipi0YgVQMatwJfg7ICJLyZ8g4mvO7OsXziERQG6ImDxawZ+VsFLL27ncO+snPhpP0V3ZV4jAsXvDTfBf3LI3RKxC8JRuNd8bdX2rrI5ugx/jiftWSJbQKq2r1xmMq3T0Hf/Z1cmkdSZ3UV1Pqbx7GmZIdDAAksgVFn94cKJvO8VYhR5fpPJ5dzD5aop9YIOY9F2TQ6KeErMbRi4am7gHicJcv0PMe5wJCQgpwfMkLrICrL5ihJTF5FEpuiak7v9xEjLHta5QMHQmXXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HY+dbQ4mK6VplXk8jNllMuY5rkl0JLdcMwbYH5bE5zE=;
 b=X91Nf4uCitKZtTdjil2lQtcZCbr4mwa3YenqmkG9Vvq79Ka/3cXl11mY99rgBNsJ34jM4G4+9yruEBzTfYVshgb7zMXzuxPMahB2Qsh+LXAe5vYCKCcznU2tuarp6omNZp8OLt2rAJBIJCIqHpw/bmWsO0cI522Wn1YXvTeaLLeIf0kUUjN7SsQQMEe9pvVgcTNk0o8iHF2I6kfYXh8KowlLyIxV7XXT4ARJqVx1fTbW2V7LHiwRxWcKRIBbxNzzscbsbpfDv0BNJ8H77YdY1peqMJpF1WWoFXzyJ/jBdTWM+/1gyNiGhiQvoU9W3Q71G3blmnFJ1GCpnBHWMMsUBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HY+dbQ4mK6VplXk8jNllMuY5rkl0JLdcMwbYH5bE5zE=;
 b=arc1YP4DyBfjoBX7b38OWjQc8AzcgA0Qq4Yc7/EEWHIY7XI+62ORkzO/tyJNy1w+DX+bO/XjtUO8ufbXk1agWt3D0c4M8ZDr0DtsFSDRrcIyIFKKJuCLf6j/XeyrLDU15XBX+POQF/klSWojJdN5/XXe93cPiS4k9GU8++BaBMo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by PH0PR12MB5605.namprd12.prod.outlook.com (2603:10b6:510:129::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.36; Sat, 31 May
 2025 19:14:54 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8769.033; Sat, 31 May 2025
 19:14:54 +0000
Message-ID: <44cc05f5-dc39-4063-874d-16f0ca145ecb@amd.com>
Date: Sun, 1 Jun 2025 00:44:27 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/16] KVM: Fix comments that refer to slots_lock
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250527180245.1413463-1-tabba@google.com>
 <20250527180245.1413463-7-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250527180245.1413463-7-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0102.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2ac::7) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|PH0PR12MB5605:EE_
X-MS-Office365-Filtering-Correlation-Id: f36b2146-5977-4997-0137-08dda0776c8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZTgxdFg2MUtVQkJOejVVZTV2V25ibzgxTFFFSjVPaWdjSWF3MTdGakZXT2tP?=
 =?utf-8?B?bVdhMU1zcWZyM0E2QlQwVXBDbnZreDZFNS9LSVUrNmN1MzU5T3JIL0Q5TXVr?=
 =?utf-8?B?emhqUkc2Z3FCQk5zNWhvNVhvWXRSVW5xUDVYWjdFeXp0a1gxUmliQWVYUkJJ?=
 =?utf-8?B?WFV4RVJwVWJmMklPVDVnWmpyNmZpN29UaitBYlJOQlFSTGJkVWZXT3E5QjBh?=
 =?utf-8?B?T2lMWVE5ZE8yUVVJUWVGSVg3RmF5TldvTU53S2RCU2xKcHovYWYyd0xPKyt4?=
 =?utf-8?B?UlJuTCt1TnJtM0xmd3dOYkhZUU5nY0ljMEN4MlJqd3FuNnpmYmxlbDR6NWRJ?=
 =?utf-8?B?anlDYVpTaTFjV0lvMWRiK29KSHV0VzVkSG5iZVJGaFUrN2F5M2h5YXZDM1Vz?=
 =?utf-8?B?NVBIME5RR2NmeUxiTmY5VkRHa1dWSGdTTG1zRURyU3duanRzVVB1d1Ywd083?=
 =?utf-8?B?SHhMcGJEVCtGcHN1M2Z6b21OczlJci9INUEzTW03d3NFUm5WRGowYmc2RnJx?=
 =?utf-8?B?UFdhNDdaNFBBU1FrMEVEMmVCQWdFNzlRYjB6QUpBb3ZlRUcwSmpIbitsOWJE?=
 =?utf-8?B?V2Zvc1F4S01UNWZwZko4aXZraTJVWWRIUVJ5NnNXNlJGQTFPdzhTVjR3QzVK?=
 =?utf-8?B?eVkwZTUvNkl4L05VNm1DdW5lTUlkQTZ2azV6QVpGK0dZOTFmbm9zZm9MRXVU?=
 =?utf-8?B?UjdmYnN4Wm1IeXFoNFA5bGxGM1lLOXI0bm5tY3kzWGZOTGZqUjNTM21oYTNM?=
 =?utf-8?B?aXExbHV5T0FsRUFJWW9GUVRNSXdlaHh4MnN1N2xmTHltQjJ1Z2pJd1FBM2F4?=
 =?utf-8?B?L0dYeHhTNCt3N0h2aTlySDhYYU1BSnV1WU03MTNOT0xsZ2w3MFFyeERRQ1dV?=
 =?utf-8?B?U095dzhlN2EvdUhVdGRtRmRCUHFQYlhUemhab014N3Rta1hsdDlkT29aVis1?=
 =?utf-8?B?OFc5NUlNTUpRUTFFTEpkQ2x1aUh6U3lzM1h4TnNNeFcwQWIwY3NZVVZ5SVlP?=
 =?utf-8?B?eFQ2MHBkTVBjL1g5K1BNZGRINUJoemZrQ3ArMjgvZnBBUFBmSnp5RlNaRCtW?=
 =?utf-8?B?VEE2Kyt4UzRGOUlVVGVLSEJ2RnRGTy9KdU1RVEtaMkg4Y2ZESXpkeUl4ci9k?=
 =?utf-8?B?bjBRKzI1T2NSc3RvOEdIVGZxdmZCQUdNTldmRHhuYVN6Z2hDZ082YmxWb1VW?=
 =?utf-8?B?aGFQbGlYWnpFc1dpamRBNyt4Sk85WGpZMTI1V0hUTGJFMnI0eXNBcUlXWm1k?=
 =?utf-8?B?dlIyOG1LRFZ4RFIvVHpYZUhyNmNYNmpWeExGVG9ESnpZZWU5a05UY2M2QVJW?=
 =?utf-8?B?RlZlM3ZJZFZCTDlSN2lwVDJzR3AxU08zcC9XL2lvQjI2em9TbnAwMkkyNzBl?=
 =?utf-8?B?bTZXcXlXUytEemdDeE5PMFR1akVzUTVWWTBaVC9Ec29kUGRUOU5HTmdDZmZv?=
 =?utf-8?B?K0IvT0h4VWs5NmV2Vi9HYlVIMmM5WkpiMjlHU25WWU54THBvUEppSFdOVXMz?=
 =?utf-8?B?Z2V3SlkyRzhPL0MzQUZWR25NNWZqMmxiUjNJamIwdzJIa3pwSVNiK3ZOS0k3?=
 =?utf-8?B?UTJkdXoySk5IQ2s5Q0o4NjN5djlYWEE2ZVpkZEVVQ05QdVlIVUhMeEhuUlM5?=
 =?utf-8?B?aTlrSk55RzQxYzRBeUZManlmbGJyeDQ0RjAvMFVJNFFjQStKVCtUcGYvRk43?=
 =?utf-8?B?QVJTQWQ3U1lrdGx0Z25zeFZaQThhZXRCdjJYeFJ6d0l3L1FsaUtIQUc4cWVY?=
 =?utf-8?B?ZmVZK1pLeEl1TGZsVmg5N3cxdjladWpjaTdwUnludGUzcERXa1BwcFAzUkll?=
 =?utf-8?B?QlNiM3ZtVVl4WXRmdHNwVW01bUpVZ0dYcnlGa0YwUDZWZC9HeVR0clBFQVlh?=
 =?utf-8?B?M3V4ZDNmNlNVN2RiNGxEZERhZHZqS2R6M2hCS1FDUjR3S1kzcCtIRUI2Z29G?=
 =?utf-8?Q?6aHVvHsmgjk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dk1qUkZyaTR3SGdLS0RqSGdNSFNrMEU4Rk1RMmJCcjFiTlM3L2hjdDU2cmtm?=
 =?utf-8?B?RjJISTAwUThaVlFFb2hMc0hxRkYyZnJ6SWZTdW1VS2pTY0g0RUs3ZWJ1R2No?=
 =?utf-8?B?S1ZxNStsZk0zR3Y2a2p6ZUJXRGthNkpTeU13S0g0RHpKYzlMeUtMMnptTyta?=
 =?utf-8?B?K1B5NDY1blZMVGNwL0F2U2JSRDh4eXk0bzJ1cUtqZ1h3VFZCZnFDa3dSeTIy?=
 =?utf-8?B?L0VReTlwdkx0OGZvdWQzeGdLSVhTRjZZaFpRZHd3SDQzMC9iZG9tcEl4R0NE?=
 =?utf-8?B?VUJ3bURtc3JBYUwxWGVVR252emptYUhjQ3laT2RzdHZtOFc3bUlEM2Vod2Nq?=
 =?utf-8?B?L2NVdFZMQ0M5SjdTUk1aTjZOQmxzazQ5VmFKSzEzbDI0bHQ2UWp0TDN2WCty?=
 =?utf-8?B?Sk9DaThMUFpMQUoxQzFnZVVwZFY0ZUR5RHhjd20vZ2I5QURqaEpFMm44bmgr?=
 =?utf-8?B?cys2b2s1VVdtd1dFaWhnNitvVkp2YkJyeGZrem90VW1uK0hNOHM2RHViTGlm?=
 =?utf-8?B?R3pJaWEzUHZTTEEzbS9pVUM0M1BvaEtrbzlHblVNVGpPbTcrQjVUTkt5dWJq?=
 =?utf-8?B?S3BpbUVzNzRiOG14WkdZcDFwdVMzQ3dDSzFpNWZJMjZkdm4wY29yZFREZlFY?=
 =?utf-8?B?cWhPWXU0Nkd1cHhnRVJydzdPOUZKK3psRmU3U25HUWI0L1ZTdnk5dkhsNWpC?=
 =?utf-8?B?TzFQblhkMEdhQ003cG9JQjZnZ0NpdkU0SDhwcGhyWUsrazRSSGQyVTZTeHJk?=
 =?utf-8?B?ZVlOL0lPWjF5UXZQeVZQSDVzNGpKeXdUUHo0QjZTakUrd3ViVkpuSUJXSCtp?=
 =?utf-8?B?OHdJVUpxUUY1Sy9lbjRhQlVtODgwbTFOMFFQa0IwRmZZaU5xQmdxMEZBS1M3?=
 =?utf-8?B?OXJFOTg3QkkyY2FUenJ1YmVucDN1R0ZhYjdHY1ljYWtUM0lhQzlFOVRzWC9n?=
 =?utf-8?B?VEVLalFKcEMzWEViOVEwRlhpdTlySGJUR3pjVHNsYVJBTGtUZHFIellyT24w?=
 =?utf-8?B?N2pseHZXaFh2b0ZhVktpL1RoazdKNG45eUlhSkcvZlhhb0o1ZzVMSkxvVUNi?=
 =?utf-8?B?eEltQktlbEszS0xTb3h4NXBRNGw1eUVSSGxIamwzREJISmN5a0RBN3IwTm1Y?=
 =?utf-8?B?VFdnOERVRi83c2t2UGUxY21RbktYU3o1dWRPQW1BdlhDS0t5eHRqZDFBbS85?=
 =?utf-8?B?VVNPczRyay9IRDdSTk9lOHVqTHFJN0htblp3TFhscUE1ajBhR204bTU1eC9D?=
 =?utf-8?B?LzBtZ1lCS3pmY05ITEIxRWRyRFkxZEJVejdrNmJqeVF0LzBNdi8xbTJTOUxz?=
 =?utf-8?B?Sysrb0ZiTFhkeUFpM0lLTkd0am9UZUFDdmFJTTE3WkFRb3pYQlFGUWVlMStZ?=
 =?utf-8?B?aHR2Rk5MVzdURE1Xb1ZXbWMweDhlNER1cWg2ZGZVaG9wbCtmT3A0MGZ5Nk5Q?=
 =?utf-8?B?SEE5NXkxUGR1N05XdnJWY0RUQmZyVjVTV0pSNzc3L1FYL0h3MmpMdkFmK3lU?=
 =?utf-8?B?MVptWG1QL0YvUnYwUWpOTWErdUxPU2NhYUE1cFVOYTNpUzZBMk1SY29tZGp1?=
 =?utf-8?B?OXJyMDY1TTRNMXQxZm1Vd0cza25nWHEvdzMxUXpEaloxQmNvaFZwbXVXWjJV?=
 =?utf-8?B?VDBmdUpiYk1ndHZYeCtvcUhYR3VwSkFPWEt5T1FUVE1WVWh4NVVDVzVhK2ZP?=
 =?utf-8?B?MmpMRGZJdVYxUXM4SjR5THVaRk5nQ05Eb1R5aTBDMC9yTllTRmxSOGdOUnFL?=
 =?utf-8?B?S2dKYVZ4RVlOVFg5TDF5b1gzQjlFSVFSL2pQL0k4K3ArK3B1NWtDUGQ5Zmo1?=
 =?utf-8?B?RmMrOXlJdlQzNWlFTXRuREprajVjMVEySkNBRXpKdC9YdlF3MEZ1UFB2NkhL?=
 =?utf-8?B?Nk1CWDZhcVdtNFNxNGV3MSs5ek5pSGdRQ2RFZkIxK0ZpQkRPSlp2V0hYZXUy?=
 =?utf-8?B?TkJuSWVXa3A3emc4VFh3eUJSYjdTSzU4TWNsSmIvRFVSZ3lPTkd4M2gxRkQw?=
 =?utf-8?B?ZEV4WU51eXJuVGY3dWl3OEs1c0NYdnVRaWo4bG5PZTBqMWl6L3licFh6czgw?=
 =?utf-8?B?bDJuaGZrYmFxZytGeTg3WVpoS0hoZlRSOU9SRWFaYkFrNEljRWdHSVR2UGFu?=
 =?utf-8?Q?z9rJXor0msvN7WEsMY7yB3572?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f36b2146-5977-4997-0137-08dda0776c8f
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2025 19:14:54.1767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3QCUVOt7jqPFMDs6tf/0TFIrts0wE/7mPFM+yUZ8J6dL5xit2aiYlRl8gCVGLH9LKHsNwtKXEjN+GMeyc3cj7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5605



On 5/27/2025 11:32 PM, Fuad Tabba wrote:
> Fix comments so that they refer to slots_lock instead of slots_locks
> (remove trailing s).
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/linux/kvm_host.h | 2 +-
>  virt/kvm/kvm_main.c      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d9616ee6acc7..ae70e4e19700 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -859,7 +859,7 @@ struct kvm {
>  	struct notifier_block pm_notifier;
>  #endif
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> -	/* Protected by slots_locks (for writes) and RCU (for reads) */
> +	/* Protected by slots_lock (for writes) and RCU (for reads) */
>  	struct xarray mem_attr_array;
>  #endif
>  	char stats_id[KVM_STATS_NAME_SIZE];
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2468d50a9ed4..6289ea1685dd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -333,7 +333,7 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
>  	 * All current use cases for flushing the TLBs for a specific memslot
>  	 * are related to dirty logging, and many do the TLB flush out of
>  	 * mmu_lock. The interaction between the various operations on memslot
> -	 * must be serialized by slots_locks to ensure the TLB flush from one
> +	 * must be serialized by slots_lock to ensure the TLB flush from one
>  	 * operation is observed by any other operation on the same memslot.
>  	 */
>  	lockdep_assert_held(&kvm->slots_lock);

Reviewed-by: Shivank Garg <shivankg@amd.com>


