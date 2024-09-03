Return-Path: <kvm+bounces-25694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABAF296909B
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 02:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6125F284106
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 00:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C264A03;
	Tue,  3 Sep 2024 00:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NMnS+NcC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCA8A32;
	Tue,  3 Sep 2024 00:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725322621; cv=fail; b=gglpa8vyYE6rDzcbxOcPJ8OMueIRBgpEzrZeKfHIIhZ3pAn8x+LAiIIDOnYtDQ324nb8ObzZnmkq0AktNxCgRErhbGHiPsu+9w2jATphqHAONAT7NX/vBcJ72EEe86GetcIzDPhrO3Axfz59hXheFoamaflTACES13sNWrquF6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725322621; c=relaxed/simple;
	bh=s3Pgul8w9BUN1QK/0CxC0sdkihJiDA34qMjel+GcXkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qwLiJyxKJEUQhHZOrdWc/WlOLqHWazHTL42GP78MGlnhAJoOFfeUfO1cjsMuUr5tgCBkhR+pl59/HIQPqZ972gCEOOZGKF5lLgDvVtLJMxvlOIWMf2iu42kOQkIhI4oLfJ4P0KKG17efxTWC2M75ilNvDDZjXVB1HVQAr7gGVCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NMnS+NcC; arc=fail smtp.client-ip=40.107.94.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n0vz9Nlz2yJ7pqwjsRY4xYHvQo6vfBkkfHYdBTHiPcCD8vO7cRMw4fDxHCMt7td2la7T/Gn82Yw3I3d+3flZtX/ynUCtgsv4yBvbmnLaUfDv1KR5QaVZVwmBgjdWOZ8KlphiM3GGHaNPSCb5/vB008b+riYMO93A04AOr+8WOzxBZU+zaj6Ag0G1cc2/RguCXOb+tvPfpbLc2pI3l6RJQfgf18LvSXS5r8ZDFpOz+qLn5sfuX3EzxFi4Z4Ym86sVCQTOqkMbr2c9KXCYjg1LeA5+1Y/4iNY5hf7wc8hPkO/1fVldoHHO9ZLnRzT3+f8LLv/n6nViWdZFn4jOOkrBGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIE0Rh4SVTx1mC81JMY89thFp9gf6M6BtDHNW72CvXE=;
 b=cxWnfPiquzALc8Dzg+7OJtNNhzLo/PriSvnspIQbEWYP2nJQPSJNzeGDx6O7/UWus6W/0qjOTIYtD49xwJ3Dk0+mC7/ASNxXZRhxf+L6WfUMMHSb1bMqTf59bO5qEVweA183+uxxUTEVxiKPt3QoWOaxdJd3+QjsRqsfroDhHbKFG3dFn9LzxoyWwkS6fKPxKrTNH86lBGHX9hFaPCbQC0BB6YFB5m/PbUrc488m+bn8DZ7FoPAUqtit3K3Y1bqhIO0blrlvbBvXIBEDcxEuonvNZdIsWyMJLafNNfgKBwBKCHrDoV5fPLWPuvIXV0ZOGA1Kqrt80VJmpT5gUTgCRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qIE0Rh4SVTx1mC81JMY89thFp9gf6M6BtDHNW72CvXE=;
 b=NMnS+NcCzD3dBsMlFa7+xwwYnpPjFj17LQO0wh9x6zX4MFtlYAc76pk2uGpD+bV5A2eOwNK9qGHxNC7VQbolDr9JO2L7Su3TyVOF/0SjcYj312Aygrc1/nt/QdXGkObT82csSNdcCeJ/6BFmQh2QK0i4+tRQXHWu53pMy68TsNhIHbuIzUO7Qp1R3tHVYbrcVoJPbFVmbhSGdWR5lhTAa4RbvR/s8lEZGk77102b2Rt9dv9FMQAqOkaCU60FX353rEDxxjnlI3jtSXTNnuYNF7e6OJmfPQEpmLZR0pDbotA5zUpp6WdCUhQSxsr+78VSuev04hGYP0VU8fsw6rmSGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB7534.namprd12.prod.outlook.com (2603:10b6:8:139::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Tue, 3 Sep
 2024 00:16:55 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 00:16:55 +0000
Date: Mon, 2 Sep 2024 21:16:54 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Message-ID: <20240903001654.GE3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHj_X6Gt91TlUZG@google.com>
 <20240830171602.GX3773488@nvidia.com>
 <ZtWPRDsQ-VV-6juL@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtWPRDsQ-VV-6juL@google.com>
X-ClientProxiedBy: MN2PR22CA0012.namprd22.prod.outlook.com
 (2603:10b6:208:238::17) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: a091962e-2596-40aa-4018-08dccbadb790
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TU56RUZEREFRTW15OERSbmtnL2I4akM4Rnh5MGFhN3FOdFJmSER6NEhFRnU5?=
 =?utf-8?B?azBTcWpaZlJKMWFXREpQV1lhU1JoYkY4TE9hSWZtdGJJbGNKUmIvamtGUExN?=
 =?utf-8?B?bnVUWTJKZW9tZzEzTWdWdjE3eUVzMzVJR3VUV3RJR3R0OEdvZWFUQTd5YzE2?=
 =?utf-8?B?R3VRUXpxSGMzVVlrOUlVN3Nld3Z2Sm40Z2V0QkNHRnRXRHFRcHFVUDZ3bkpz?=
 =?utf-8?B?TVJYeEEzYUxXcjZwakFJVWRuSzZnUXJkTTFFV2xSQTZBU2srOE1YZjlaTFM4?=
 =?utf-8?B?R2JGV01MNENVYTNjb0tXZ0t6RlVjTGR4Uk1tSEhWTmFXeVUyRXI5SmxKbWFr?=
 =?utf-8?B?Mjl3VEp4RldjTlNYS296cDd6L3phVDJ3endiZHNSbmtaRlBiYTlpRVFlWGFP?=
 =?utf-8?B?Q1hNN2VkaVFPZk14bTd0WFdVNEtKWFFVdGJxTk5MZmo3S3NyWE9XQ3dPbkdt?=
 =?utf-8?B?SWo0SWRlK3FNMHBsY0xiMzZ4eVlTN3JnUlR3SHRxaFNTNTk4anZXWllwZmdH?=
 =?utf-8?B?YnltL0VmUWc4NGR5UFlpcFY3UjhVZ1ZHTmIzaXo4dElhQWRtaVpjWENMQUdz?=
 =?utf-8?B?YXVld3dtbVBpM2NXUWJMcmh0d3owL21ocm01SmVRV0pUcHRvYXFvV0MvM05V?=
 =?utf-8?B?SUxLTmNucFdPUEl0UTh4ZDREZWw4K3FlSWpxb2dCbzJFQ0gvU3h6Z1BoUFB3?=
 =?utf-8?B?dWNXRFA0d1RXZzh0R3c2YXdQSTdudVJuQnFWbzlrSWVTL3dSOFlQZ2creGZ2?=
 =?utf-8?B?RXB6ME1rblZiakVqZmRFYjVocC9mblN2T0t4aTdkejJoR0o4UmRpM3pLSldy?=
 =?utf-8?B?a2ZIN2loTUNocCsvTXlKMnpGOTQ5dkxDb0tJVmcvVDdCM3lyREVHZ2I2NGtC?=
 =?utf-8?B?TzJQTGEwclFhNmlFZHdnZXpPZ0gzdjFFVVBaVmZJclRmWTFwS1FsalNTS3N6?=
 =?utf-8?B?bFVzN3gydU1GVWZOT0NHUWIyM0FVMk83Z3V3cGdVbU9oZ01MK1NpdVdYYmxS?=
 =?utf-8?B?RVVkYzZvZS9pTjEvRlIxVUtxSy96RmMrUTA0cW9jMmxYanYwSnFyQjBnU3cr?=
 =?utf-8?B?cDUxckF5NUx3S01OVXlucGwxcDlUQ1d1d2YwRVdNUitFMWVmclZYQWFFamI4?=
 =?utf-8?B?SFFYZTVtZ2wzRXpHa0ZhdHB0c1lHSUJpU1JGKzROYTBybHMwZ281dDgyVVlH?=
 =?utf-8?B?NGZXQkxCNWtJM0UrSlNBTUExK091bWZrclNOTnRTaVlWT2JvcXFvTVJzZHZK?=
 =?utf-8?B?Q1lwYU80VEFpNkp1bnJKbVE5R2hlOE5BdDFIbFJmU1QwdWg1Qm5jalh3VXBF?=
 =?utf-8?B?TTYyRHJGVHhJOEpaWTVQY1Ava0pBNG13aHZwVzFZT1VyWnNoS0FNY1k3c01U?=
 =?utf-8?B?R3JGRlBpU3lxU3BYNjFtcytDUTI0RThIakp2ZjIrMzNoZ3BlTytuTEVzNldj?=
 =?utf-8?B?OGoxU0dTMlpWVUlscmMzRU9MSW1EUGZPRjVtczMza21zN0VyQUNvTmV2QUdh?=
 =?utf-8?B?RUpBdG5MSFgrM1orbHNrTEoxMm42cG54aDVjWk9KL0ZEbTNVOWRwR0JXbXA4?=
 =?utf-8?B?bVFHVS9NYld2N0NjWGdwQzZjM3FHWkU1K2JPWmVTZ01HUEEvOXo4Nm9CQ2dQ?=
 =?utf-8?B?ZEFobUpYdDB0ZVdlNkVoK2ZkbjBoR09WMis3c1IrYjNXSVVPem4zQnA0cy81?=
 =?utf-8?B?bXl0WlhqMUNEanZ6ZkNmZlhUeHk5UXZnNGhrVkQ4U0ZZWGk1bndHek9FSTVu?=
 =?utf-8?B?ZndRSk1NQlp5eTNEd1V0TWJzWEhLYVMrTmdxME5MUGVCeHRjWUZVS2FmSFlq?=
 =?utf-8?B?M0MzSlFWZUo0RnJQMUNzZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3lZY1FNTzJKY1VLS3NnU3A0SmlGbnRiN0h5Tm9XdGwzdEhYVUtNNjRubHE1?=
 =?utf-8?B?L0RvR3J6aEVLeVpvanVVbkxNcXBpdWlQclNFL1VtNlJKeWkwTEFIcjNNb01S?=
 =?utf-8?B?WitnZXNTTEZ1cFBndVRFUzJicmk1YWpteTk4NDhGaWRleEszNFFBV2V3UzdG?=
 =?utf-8?B?Q3RmU1hvUStzbno1UWdrWlE5VFRuQWIzQmhHMHp6YVM5Z3dVa0E4YkJueEht?=
 =?utf-8?B?Zkp5UW8yQ3I3QmZTYXUvbUNHYmpnSERscng0M0dlZnZKVjBZb2pMcGtrelhC?=
 =?utf-8?B?SEVWbnIrYVpWeVdQdmJxcmpmSXhYbEszdXREM2g5NUFQUmI0MU9nY3ZTYzNJ?=
 =?utf-8?B?MVRYNWVyV3hTeXNhV0Fnei9KR1B3b3lkNXpJY0hLMU5wcXRkZVdYcXZ3aXd0?=
 =?utf-8?B?RngvRXNueUs0MHRvZExWZEVSbkEwSkw1RHMydFB2bmhEU3JTclJmYlVZRi9a?=
 =?utf-8?B?VWVHVUpMMWExWXBpdHp4cE1zVWhDeVN4S0hXQjRFQXhsUDZpOE5EN0FpTXZR?=
 =?utf-8?B?MzFBUzlibTZxOHpIempmMU9oRDBidDFEWlZLWlcySVRsSXBZVEE3THhnVVBE?=
 =?utf-8?B?WDNNV3hXQU43eEJ6NGtjWDdsRXNndHA5eTBuVEdPbUxBZC8rRmN5Wmd4d29q?=
 =?utf-8?B?a1c3MkpoY0cwWUI5ZWtqQlZ3TTJVc1lxMHF0N1E1dkt3U2ordmdGVllqNCs0?=
 =?utf-8?B?SzFlUTJvZkovazA5WkptZUF3MkdjeWMvWmFOaFF1OWdmUTh1M0Vnalp5Yisw?=
 =?utf-8?B?NEY3YWFrc2pSVGhzVHFWcmRhMEpZb2x2U3ZmSjZFdnZ5UmQrYTduMFRsVE1s?=
 =?utf-8?B?OXM4MmQxRmIzcnllR1ByZ3FzOTB5VW1JakZZUnV4a1IrSWpML1RTYittOWhW?=
 =?utf-8?B?RXNEMzgwMnROaWlqckxLRkxsOFlMS3RZOEdjM1FMUjdkKytZSjN0WFZMSEN0?=
 =?utf-8?B?TEkyb3l4VktoRXNjZ0hUSnFYL3RxaHlyOUVGK2p6V2d5cUl4R0ZhV0V4VmFt?=
 =?utf-8?B?d2J6OGs5NG9sTjVsMHNweTdXcE8zc0RsQ1lJREpIUkdUa00zU0Fub3Q0b0dl?=
 =?utf-8?B?cXZyYVZpdk9uSE9OM0dhZ0ZrZW9oWjllekFHalZxdEVOUytQcFV6djVmMWRS?=
 =?utf-8?B?WHJQblg3SU55cUh5dzduTHFlVHNlY1dyZ2F3UU1jY1QwUmEySlE2MWZoR2My?=
 =?utf-8?B?aWl5VGs1UFhsWDA1dkRreGU0eG5XbC9Ra1B6VTRKS0ZjQkd3S09aV3NwN3g4?=
 =?utf-8?B?c1lsL0NTUGRjM1A5YWMreVBqZmlhajVwa0IveTM4aVZ1ZGlWVWpmdjBGRGNQ?=
 =?utf-8?B?UnZFY2pqRk9CSjN0akJIRHZFNFBVU0Y1cFVKeTlDeUc1bmd6MU5MdklkTmtT?=
 =?utf-8?B?b2N6bkcxWlVsa1o5WVU1R2k2cW9DOThIeVN3amM4ZGRHTEh4ZFEzYm5mSWJi?=
 =?utf-8?B?QWlqM1pHRDVGSXRKNDhic0gvZElOSE5UZWNiZy9lV2E0Nm1JVndZTlRuWmtC?=
 =?utf-8?B?MUF6aFpacjRiYkN2VjRPbHdaWVpyeXFMakVKN2owV1FsUDdTTzJnVUx4WFdS?=
 =?utf-8?B?c0hNcWxRelJKSXlEWEdxbzZRR2dWVEtua25wYWJuTmtSQjM5L2NjdXF6Y2Rl?=
 =?utf-8?B?Zm0yY2haVlBqMy9kVzdVNVNNQVkvSW1kSGtLZWQxMmR2bGFpR3d5aTNicTEr?=
 =?utf-8?B?akU4Q1RzQ0ROdW1LKzlhWFJLcER2cnJleElmMmNlL2FvbEwxRGJhQ1drSm5j?=
 =?utf-8?B?SThrZ1BaeXFnWVBuMVovaHl0S2tLbkgvbXlmaGd6VFIvOCs0UDJZZ3RLT3pm?=
 =?utf-8?B?Y3g0dFVrZXBBdFBlQXZKeTZPLzNqaDRDZVNkVXlHY0RiWGlDbnFKZ0h0SjJB?=
 =?utf-8?B?eGZIZ2R1dU1DQlVTNzJMRzZCR0JEcDJpZ1ZNTHZSS3NqTi8vbDdpemsyTXNR?=
 =?utf-8?B?QVloYjVMZWlpU0lmUGoweEs1ZlV0RW91SlVnK1M5MVNnYndmSWxkK1RiQ3lt?=
 =?utf-8?B?TnNrQU1XaEg3NEZZdDk0dHphU2RIK2RlaFZUcm1OR0JLODFkcjRXam1DNjlB?=
 =?utf-8?B?TlpXdy96S3BuaVFQOGl4TGhsUjl2cGpUeWZTeCtQeDJJaUNWWmt5RVBrM3h6?=
 =?utf-8?Q?ml18=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a091962e-2596-40aa-4018-08dccbadb790
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 00:16:55.1330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqQp3T0Y2j7Vvhsq7wqm62SbtjpK0VP0EbG5Iv7VnJLrWto1DMDhng2GJSvoBJ8H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7534

On Mon, Sep 02, 2024 at 10:11:16AM +0000, Mostafa Saleh wrote:

> > What is the harm? Does exposing IDR data to userspace in any way
> > compromise the security or integrity of the system?
> > 
> > I think no - how could it?
> 
> I don’t see a clear harm or exploit with exposing IDRs, but IMHO we
> should deal with userspace with the least privilege principle and
> only expose what user space cares about (with sanitised IDRs or
> through another mechanism)

If the information is harmless then why hide it? We expose all kinds
of stuff to userspace, like most of the PCI config space for
instance. I think we need a reason. 

Any sanitization in the kernel will complicate everything because we
will get it wrong.

Let's not make things complicated without reasons. Intel and AMD are
exposing their IDR equivalents in this manner as well.

> For example, KVM doesn’t allow reading reading the CPU system
> registers to know if SVE(or other features) is supported but hides
> that by a CAP in KVM_CHECK_EXTENSION

Do you know why?

> > As the comments says, the VMM should not just blindly forward this to
> > a guest!
> 
> I don't think the kernel should trust userspace.

There is no trust. If the VMM blindly forwards the IDRS then the VMM
will find its VM's have issues. It is a functional bug, just as if the
VMM puts random garbage in its vIDRS.

The onl purpose of this interface is to provide information about the
physical hardware to the VMM.

> > The VMM needs to make its own IDR to reflect its own vSMMU
> > capabilities. It can refer to the kernel IDR if it needs to.
> > 
> > So, if the kernel is going to limit it, what criteria would you
> > propose the kernel use?
> 
> I agree that the VMM would create a virtual IDR for guest, but that
> doesn't have to be directly based on the physical one (same as CPU).

No one said it should be. In fact the comment explicitly says not to
do that.

The VMM is expected to read out of the physical IDR any information
that effects data structures that are under direct guest control.

For instance anything that effects the CD on downwards. So page sizes,
IAS limits, etc etc etc. Anything that effects assigned invalidation
queues. Anything that impacts errata the VM needs to be aware of.

If you sanitize it then you will hide information that someone will
need at some point, then we have go an unsanitize it, then add feature
flags.. It is a pain.

Jason

