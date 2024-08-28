Return-Path: <kvm+bounces-25309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2816896366E
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 01:50:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4537285B0E
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 23:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFF461AC8AC;
	Wed, 28 Aug 2024 23:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C2PY3bsb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C297146A63;
	Wed, 28 Aug 2024 23:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724889005; cv=fail; b=UNwI9lN9twhy4PMfPzCzgtu+B5loam6J9MRZ4XRRSj/BQ1HCa3heaweHlqGKFTAVhykP14fncQW9ml0sKnW/qKov+OooCTIVWWs4nglnwqRyKg+hI/orpQ5mTkc3v6w62DaoupTYJ524YoIpPT3Gb/24PKB5xZY80oj8txlwugk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724889005; c=relaxed/simple;
	bh=lgaeZWZnpfk1SQaravjMc+uq5FwsjBhjHxwEsL5EOfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UTrwsbjbcpxHSBuwR12XPKqIfzd5a6qCzqGAUjxzhdPMpVYa9QBwP2JRyqvVP8LtsxfBqwekMdqr+5x/sgXWfuFSjXgukcU3QacDcFxjuS5EKIZrV7QD9D+S6qFJkKxdajtiLIrSbHkLRyAXt01vhjYwXv4WIOmqD4EoOEdWqDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=C2PY3bsb; arc=fail smtp.client-ip=40.107.220.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C44FfaFt35tCf2ZdAWT7Kh4iUZJl11o688dJtf7AvNQxBKJvtavHra5s6MkXb7XhaSZqfWXMUjVGbFyAdtrBkBVAhQq5h81uNkSWPohc0ofYAKMLxMgBKQfx9ua0gE9BHl2wuIumkyv1BQ3WYiNUr+Rgj0oWumglb/VOgce0rn3CsyAfUaRK8RKb7yGDluHxJw5LdlDcMV7Gyyg9UPclA9TAbA/UIHyf/pH6YsaUEM4MbK4UGQ9dmC78G/ZJTXwSquQfGTxw7vYEMItUrZgojyspu/L/w77XCUW/AfZnflGWbLZ6C3vEMjsStPgbxUvitmsyBX5OUwWhhZlBTTzD7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8oHuvN0evqrdAlDpE2XPPOR1uGO7MdcuMyrbiid5omE=;
 b=Ak5+oSPfHmTUrCNc+nu31SwJ9jDncrlNc4CAxXvgXG2FwH/oMQNN/i477Lu39KlzmweXLquWi8TyZpwZ6JeWEQKsZhRANJ56Vo2DGq2EWnnIxNlWiW3FeJyvLkH4cjPPjXhB6ZCjYoTRYJcSmLfSiSFlrwSsyKsNTZhAleWJ3M7mQiDrAbm/JPL8v9jwAHVE9q9fXns7CvididqfH6tSvOSb6vQmUbdbmR6XT2prZ97kWyj/8DTw9fEmtz7+8CWxObtXtBktqjWDB/JC4X8P/mA2xP9kniFJypJnOdd2XglNn7q8dhIf+TFkDCCpOqkgAFa3FNdb3JSVHMYUxlV8Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8oHuvN0evqrdAlDpE2XPPOR1uGO7MdcuMyrbiid5omE=;
 b=C2PY3bsbYA3lxvxmed3ixts1p8bf/jXF5n0qG2FB+qeGsqc69W55fATP7FaT2m8PiJV6NrEtI3OwwWaSHGLsYxv/8/yBqSAEVhoVWKJxu6CLG8svz8TSwvJ6pvJOoVZucJ39hybV9i+qOM4dYnhHfn5hIoh2YFrZkpzq60m4DaTzhdc0SmPnZonDANH+oUlY5X1zBYX6WV/GSwBy8iIIqkI2uKKYR4EZpEVEFJTnpiZUpYsTo9+8BIE1F7VdNNJpeYRT/ws8oFVtSX0V7bDfesNWqmleaMMDSSAh+FqYKT66nqGR546DK5f6nuzq3ZJBTYJLpqCRucJAvjJ+RQ1Z5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SA1PR12MB7412.namprd12.prod.outlook.com (2603:10b6:806:2b2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Wed, 28 Aug
 2024 23:49:59 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 23:49:59 +0000
Date: Wed, 28 Aug 2024 20:49:58 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
Message-ID: <20240828234958.GE3773488@nvidia.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <CACw3F50Zi7CQsSOcCutRUy1h5p=7UBw7ZRGm4WayvsnuuEnKow@mail.gmail.com>
 <Zs5Z0Y8kiAEe3tSE@x1n>
 <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
 <20240828142422.GU3773488@nvidia.com>
 <CACw3F53QfJ4anR0Fk=MHJv8ad_vcG-575DX=bp7mfPpzLgUxbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACw3F53QfJ4anR0Fk=MHJv8ad_vcG-575DX=bp7mfPpzLgUxbQ@mail.gmail.com>
X-ClientProxiedBy: MN0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:208:52c::24) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SA1PR12MB7412:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bb91d09-bdde-4689-af74-08dcc7bc20af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SUNkMjhVK1JaWlkrK1J3eU1DNEZwU2p3enpVV1MyK0VDQkhEVE0vWkVYd3h6?=
 =?utf-8?B?Tkt3cE5WTmJKWk1XS3F5QVBVd2h5TVE3S2RNaEVxQTJpNDVSWmQvQ3FOSXEy?=
 =?utf-8?B?bExNRGNMbys3VlJMVGFLOGQzUHAzNlMvZHE5Ynl1cjdhaUNxNm94TWozYmx1?=
 =?utf-8?B?Z1ZSaVFqVHNJRFk1SVg2LzZFdW55YlRUVDJKR1VidWR5TlZoQk5LemIyeGVa?=
 =?utf-8?B?RG9KKzdnNUJyTnhUVW15YVlHU0FnV1ROaU9QbjE1ME5LeDUrcGRRdDZhTVMz?=
 =?utf-8?B?TVVRaExBb3A2NHIzY0dCemQwNUY1MFIzRGdUeG5DcCtiblo1R3RPMEFGdG15?=
 =?utf-8?B?V1FTcEtSeTZETWFvendDczdmVitzOC9CMksxZWNidktTdks0LzY5SXFDSGJp?=
 =?utf-8?B?LzkvcVN4c2FHQlk4bjlFSHVVK3RCWjRXaVRBbitzNjM5bC9tZzgwYzVYQjlx?=
 =?utf-8?B?MGJ3aFM1d3pkSTJZdFJjWjE4VHB0SmNiL3BnRVh1MkVtM2lleElBWlNyejFa?=
 =?utf-8?B?Qm0vakQzbS8rREIwaWNGY1JGRGM3Z2dlYU02UHF3amp4VnlCMUhUQzJjNlNP?=
 =?utf-8?B?U2luOGNTcXd1dW5oL0xQSnI0MFl1aGQ4NHVON3hqWFJtZlhYWHV4QWJIL0F3?=
 =?utf-8?B?SzNyRjJjYXhXcmcwdjRJZS9OQ1hDYXFXMDZLdlp5eko0RERpSjJ4WkZDMmpT?=
 =?utf-8?B?WHlWOFJUaUFBZWtEdWxwRlNYSUpRQ0FDREIrb3BUWTk0aWZCWGxnNmYvWXlu?=
 =?utf-8?B?TitRSUNmbnQ5MVdERTZvUHhnc3h2b2RST3VlVnQvWjc0VkQ4aWtteXlFQ1Uy?=
 =?utf-8?B?SXRiOU9IbFZtR2xUQktkVEJQQUtnYmdsWlJJSlFkWlBubTZMbk53YjNHNmc5?=
 =?utf-8?B?UHQ0SHYrQmRlSWZRVUw1NWNOcEFIbEw5SURkTFV6Vzc0a0hRNzVEMDFyWWh2?=
 =?utf-8?B?QzhnRTQwbHI5YTQ3aXY5cTVjV2o0OXU1cjExdkZXSDRKL1JBZG1MdHp1S0Vp?=
 =?utf-8?B?ZGZBUlZaK3FvdDdPQjVDdmZYU1FsK2FOdDJUTEo3TnRBWHQxLzNVZ3FRYzJx?=
 =?utf-8?B?S0gwbFNaQS9DRFVRTldEVG05OERsam9Mb0Z0ZDNqQ2cwVUpTaTllZk1zTktn?=
 =?utf-8?B?Wm8yVU1DUUpZRHluejEvaG1XYVQwQ1N5T205dDErYWVDdWs2Q094MXI5c1By?=
 =?utf-8?B?cGc3dWlGbk5MVDFGZmxRQ0ZHdGxYUU9VZEtpb1I0NTBwMHV1VDh2M1hqaVR5?=
 =?utf-8?B?TjJOcXZaajhEWDdZaXpxeFN0UTQ3OVpLaEd2dWE4eTd4UGVlMGR5eFNSTENR?=
 =?utf-8?B?S0h6cEU4RVhLMFdIMnlLbUJHTGd2d3M4VEN2YkZLQzdWaFJuZGx1V2E5OGRO?=
 =?utf-8?B?bjZNOU9DQjdaWEZjcUwxUWY1Rm1PL01MTTFuckRndEpUODNWeE1CL2pOR2Vm?=
 =?utf-8?B?TTQ5cG9Tb3lzVkVEa3lJbEk4dmdJYjNLc1NQQzh1MDNOUEFnK2xsd1VITkFw?=
 =?utf-8?B?ODBialBTeFZRcDRlMGl0YndnRlBRUytLTTZ0Z2w4aHN1YmpCeTdVTi90MXZk?=
 =?utf-8?B?OEQ2RWs5VktzKzVwN1VRUk05eTVySEZwSEwwbVk4d2VKZnFUOVlIcThQdmRO?=
 =?utf-8?B?RVZsbUl1UHM5a0kwZkFnVjNJUzNzeVZyNFduUktHRm5WQWw3bThvZmJsdXVh?=
 =?utf-8?B?Z3NtRVNIK0Q3VlRtK3VJMkVWc2RlZHNBT1ZoM3l4UHdaV1p6c1MxWHdGSkla?=
 =?utf-8?B?aHdpcWJwdlNmZUpBaFFVMU9kRHFIUzc4TkFSSE5zVjRIMUhnV3kzelB2WVpC?=
 =?utf-8?B?dExJY0w5NkNXM1libkxvZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjkrR3I1Q0xMc2xmSjJuaVYxNkgvaTB1YXJPYll1N2ZnaExHbzA4NUwxL3Nv?=
 =?utf-8?B?cnJUeVBRWkVHU0VPb1d4eU1QcnZlTVR3enlFMW5KNW9pVEVNOEhyam8rQlBG?=
 =?utf-8?B?VHlianJVM2FZamRYNTBnV3ExSXJRbElWTy9IbWJ0RThlMEsxNE9FQjhHU0Qz?=
 =?utf-8?B?Rkl6Nk8xVWdZenF1M1RBamZIWU43b3p1a1JzU3NuV1BLSzdNV3dHQ0FvS3FX?=
 =?utf-8?B?R0FrYmZwdFdlUVB3bHlOWERidkRnTll4cldXZThMVGlmai82NFVxOWNOU2tF?=
 =?utf-8?B?YTJ0aW95RHRuM21MUDJMeC9ERWNUb0E4bFdWaGxxR1E1cW9sektFVDVkaVNY?=
 =?utf-8?B?UU12V2hwUEJ2bUl3ZjBJN0tXVjRoYUlQVnpOLzhyREhINkpxSHNPQkI1dlZC?=
 =?utf-8?B?dDBqUnBHTmFhU2E2K29KRE52b09PQ0pSUG9YVll1aU0ycXZmeEl3bWNySlJT?=
 =?utf-8?B?UTFFdGVNQ2xUUXlLZVlZd2s4SGh5OTlTWVp1YzRNeE1lbmhoS2RtVWJ0aTBp?=
 =?utf-8?B?RnpxdGlsTEU5Mm5JZS9LVndOalRiTVkvR0lVaG0wblEwYndRSnE5Zy9uVHYw?=
 =?utf-8?B?MzJSelE1ekdrSGY5SHZqbU1JZlhSc2lISzdFZTdPZXlDNS9xQ3VPam84L3JX?=
 =?utf-8?B?a3Fpby9OcEJQcEE2eHUxYzI3WmpnS2IzN3U3TUUzZkNGcmRZZXA4Um5KVzZG?=
 =?utf-8?B?Ui8ycDRjSVhtQS94TUgvaVVVc0tva0QwVkx6OWlKTWxmRG9ud2FyUDdVZGhi?=
 =?utf-8?B?YVR6b1BaRHhIRklrb29WaERHY3V0OE9ZUmRpci8rMldSZ29BMjdZajRaOTVi?=
 =?utf-8?B?NmZaNWtTSk1MUXBYck02ZHJySnJibWs5M2tBSkRtZFZTSkxpVDR4aVRCTlRG?=
 =?utf-8?B?cnRQRnUyK3I2RUpFNjJNV0FkeHNzbXF5MHZIYmVIbHlMWjFocUFZbEQ2UWxB?=
 =?utf-8?B?RFhqQ3NMbzBEeDBBKzRkdkZHUGtCcFpWdFRBS0tLTVJJMVM2Qyt5aEZRZ3ln?=
 =?utf-8?B?RHV4YzEwcHhQeEJHQXZnKzRaYUxwcS9jRzFCbmZrMThIZHRRN0MrRXpKWUxa?=
 =?utf-8?B?VXVrd1NEK3ltUHVrNk96MVNaRCtEd0t2bGdCRisyQ05NaEdjMnc5R1p3U3cv?=
 =?utf-8?B?c2MrTE5sSXQxV2RmQ2x5VXByQXlGNUdER3RQcVgwTkplb3c5MGVaa01PQmh1?=
 =?utf-8?B?TWo2Zk05b1FJd3M2MFJsdjVzOEpCL2dWKzk4S2U0MmpySCtiY3BTd2txbTJ0?=
 =?utf-8?B?NmQ2eE5velJVQUQ1Nk9EcjRTNE9ZL0pCWVAyRGtGSVFxRDRCTFVhUlhHQ0dr?=
 =?utf-8?B?SkZnU1M0Z2dJQkx4cFNnREdWUUt4WkpWOVlPWTYzZkwyODI5V1VHZDhHU0NZ?=
 =?utf-8?B?TDlPNlc4Q256OWJzV3VUeUNNVWZSSi9tU2NXRU9maEhaU0lZV1VUODIrWk0r?=
 =?utf-8?B?VjNNUG9BVit4VWlEcDI4a1drdFdqWEtVeFpSbjNpS3haR0hzSDlQbHV4UXNt?=
 =?utf-8?B?OEFaTFIvTXZXS2VuWTdUTUloVnRDRjZtU28xbHBVcVBRVTFUL0Q0R2tyT0U2?=
 =?utf-8?B?SUkrdVpNU1BkcE1OOW0rNEtNNzRtWDlYK2JkNmw5djhFOEgrVzE0WVh6Z2xO?=
 =?utf-8?B?cE9BWGlJTVZHd0pDb2FOZmdhb3IvV3diazZxc3JCNG1sZHY3MjVZUTI3Wmcw?=
 =?utf-8?B?bjc3NForUDZmOFpUSDAxZ1lXL2NWYnZuWHNIVktNaDZVRHY3QjUyVWdPeDlw?=
 =?utf-8?B?ZTRtMDVNSmczL3hSam1FN0g2MHZ2OXMwazB3MGk0emQ4WkU1MFppcUl5b1JS?=
 =?utf-8?B?c2liRGNsS0dwSGk0eWIwamI5UWoxY0NyMHUvWEx0bXlTOU1CeTBRby9GQVpj?=
 =?utf-8?B?WUNpQjBHRjFhQW5paUt4YW9XQjBQVUd6L1ZIYVRYVmVpM3F6YzZkT25LWlJ5?=
 =?utf-8?B?eG50R3RyZ1lGdnBXcys2T2VabzdhUVJwY2tLaWFWa0t2bk5rLzVkSk1obUZs?=
 =?utf-8?B?OEpXZk5KbnFYWnFmVFNEcGRiTkJHaFVpMkNoNEFVbkczbloyLytaRjZXSTVP?=
 =?utf-8?B?c3NBNHlaL1oyblN1aHpSYzIyUWY4UXV1Sk1pdzdBZmVNWk5IZlVmckJMUUZ4?=
 =?utf-8?Q?icLSDqDzQBisuV873Y2VBCRw0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bb91d09-bdde-4689-af74-08dcc7bc20af
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 23:49:59.7403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qGBXz1Y5N4iY/vHdo/77TqQAxysAGmpcrPWH0SuJXLY9WmzuUPlAMx49AlxUJSqN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7412

On Wed, Aug 28, 2024 at 09:10:34AM -0700, Jiaqi Yan wrote:
> On Wed, Aug 28, 2024 at 7:24 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Tue, Aug 27, 2024 at 05:42:21PM -0700, Jiaqi Yan wrote:
> >
> > > Instead of removing the whole pud, can driver or memory_failure do
> > > something similar to non-struct-page-version of split_huge_page? So
> > > driver doesn't need to re-fault good pages back?
> >
> > It would be far nicer if we didn't have to poke a hole in a 1G mapping
> > just for memory failure reporting.
> 
> If I follow this, which of the following sounds better? 1. remove pud
> and rely on the driver to re-fault PFNs that it knows are not poisoned
> (what Peter suggested), or 2. keep the pud and allow access to both
> good and bad PFNs.

In practice I think people will need 2, as breaking up a 1G mapping
just because a few bits are bad will destroy the VM performance.

For this the expectation would be for the VM to co-operate and not
keep causing memory failures, or perhaps for the platform to spare in
good memory somehow.

> Or provide some knob (configured by ?) so that kernel + driver can
> switch between the two?

This is also sounding reasonable, especially if we need some
alternative protocol to signal userspace about the failed memory
besides fault and SIGBUS.

Jason

