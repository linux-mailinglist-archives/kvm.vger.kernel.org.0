Return-Path: <kvm+bounces-25800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0241396ACE9
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 01:33:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 272211C2424D
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 23:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC1A1D7986;
	Tue,  3 Sep 2024 23:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rFi2cF7r"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFD61B12FA;
	Tue,  3 Sep 2024 23:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725406427; cv=fail; b=pyo2RbXnCfRpSLPUtT/KvnwjvsZl65iQOMU55rXcGGS7ZCFV011m4SaaXzKH4BFs9EBgnA9ChVQ1vJ10z1uydM5WJ9c8kym9YFJbBQTDOxrr/Q0IqyLo8xGGD2crHPxqevL8gwIaSZV9EzsX2EmvGmU2HrGV6JtnN+rv3ysSSqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725406427; c=relaxed/simple;
	bh=nuDJ9tendgPYTg1DcMnXoJTHRXoysmbYb+yCD3pM3dQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ALbvmen5xpisN+dMGtEtrgNPbUQk155HVM35q3a5WUVlaCw33arNXS5FTNKwBI63+N827tk3GqQSb4XwlAH+SgAR9VpoDFR2xh5nbIoACX6LDV6UyVH+VHrON8GMbMoPcPS14Ee5wxoLCSRvwhQuFDYAXcFbWvToyZZIOE8hDy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rFi2cF7r; arc=fail smtp.client-ip=40.107.237.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R+EmyrgK/EuG6cYrZbJNtO8LKTif/QsZJuSxMsoH935id0Bj/H+ZZrww3O28aW87HR3pPPOGjy+0Tau7i9RT95PAMAIX21K2xY1qPBYxcCzuLGL50gfNRNIXNykorG62ttGmosgUKaPdbcYwSbNE0MEbj4RKCwVnQOjuHgcb86ujudXfaPstJ9JXIyofEjwXBYwjah/ERqdIoevEQUCgPO+4frL9Q5AekkuXbbKwYTOPNRDOj+NRY7Iqv1KiYHQPIWaFDbKQU4r8h5AqT/55inzJNQADaBH4L28nZYoKUzIppJ2JKL+WY/6r6em12LHJ+y8j3Vvp7tSLqE7WA2sSqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mmrwcrix7gx3anfAClcD6u4mliCdf+qdQoemNeIQY5c=;
 b=dqg8HUWet75FjkdOc/M9WzLlohpfPfILOkHzeobQd1ZCNnTXIOJkPPsGRNB7DhVCRziDyqEyznEqYC2T59JAaM6Ou7bHOlhRkF9TwRYN9z4slRezauYjrBIlpa5whIS0h626WTmDc7uFAszOjxU59Qqk+66CGzBxBLcqiiK85vE02haLJZt7gqKoLXVPTuq19yzO1acDASZA72Iq3xkk0Eh9pyyvFPgbwPTDCVTZJ9say3k2aV0LYD6KYc/ID0+Sdvfjh9EdbwaP5ExWzSkg3apIdnDIIngLbodT/m02krWX3iICwHx6yoIsQNEU2XEzAHkSY0fU9CShNW2bq8s3Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mmrwcrix7gx3anfAClcD6u4mliCdf+qdQoemNeIQY5c=;
 b=rFi2cF7rASBaSVBKwIRt+MuPauBa7XUgdC1WKg2w3SmZK4G+qCtuHJYRxbkibKu+A+wuSRV0Cl0YZiFeg52tIiJW05P5AFg0fTPv0x0Jt0fue9LCmwdYJewyYcFLLcegZ8+iUY1G7tRj7jEqRIZ1DtA+WvwZ8jbwR82TCVkyuZCoL+nWeNzZhdQXWz/12k5LVQgOh2++xAQwXXvCf5lW2wVIK4TIQ1WEp4tEXTTTa+Rp6AUtrWaW8md7gkbF9PuT2ksVYFrP9hfn2Sd5Ku5xYh/7iofG8zn/mBMbmf3g0cHx5uhiID22DESePemnWqxU4y4Vz2L9Ag9IxVH1A3COYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB6938.namprd12.prod.outlook.com (2603:10b6:510:1bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 3 Sep
 2024 23:33:42 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 23:33:42 +0000
Date: Tue, 3 Sep 2024 20:33:40 -0300
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
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <20240903233340.GH3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHhdj6RAKACBCUG@google.com>
 <20240830164019.GU3773488@nvidia.com>
 <ZtWFkR0eSRM4ogJL@google.com>
 <20240903000546.GD3773488@nvidia.com>
 <ZtbBTX96OWdONhaQ@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtbBTX96OWdONhaQ@google.com>
X-ClientProxiedBy: BN9PR03CA0800.namprd03.prod.outlook.com
 (2603:10b6:408:13f::25) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB6938:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b385402-1620-4702-92c0-08dccc70d869
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dklJOFYxZjVITFMxNWc2Rm8wSVZ2YXhDYTEvYlpSZkFTN01OKzRETGwrTDFh?=
 =?utf-8?B?MWwvaEdVVkxmbkZGNnJ6YmswNFJ4SUVkOXJhZEF6M0ZtK0trMlo3WjRCU2dJ?=
 =?utf-8?B?WVErTGF2Q24xMzFGSHlCSUMxaWZuMTFJSnkzM3RFTitmZVNka1c1bFJnVWFS?=
 =?utf-8?B?cng0UlN5cXZXT1F5QjhiVFlheHFlWjJHWWZnWlduVkhWRlJWaVJCbWlhRVdX?=
 =?utf-8?B?dkExKzJSaytNV0NFR3c2RkkzRU5GcVg2NjhYc0xtd1FVMll0TytXME9CQU8v?=
 =?utf-8?B?NThwUFJ4a0lSdEFsa2hZYW9ZTVZJNVN5dVp0TWMyTkg3ekNBUUtVUGlOV1pw?=
 =?utf-8?B?anVvN0h0ZlpYNmVPMWVEQmRaNldPOXJiNEdrUnBjZ1UrY1p5RzhpNi9pYVA4?=
 =?utf-8?B?WndtZ0lYNzVlTVVKK3dXTjE3TU1STHRTSEwyMFEzZ0lPMlpCcHZYS2xMNXFY?=
 =?utf-8?B?VzlHaTNTeWRoeVRvRVRBdnJPU2IrS2ljVWh2YUVjTENKNDI3K0hGa1R0TllV?=
 =?utf-8?B?bndieUFoWlhqc2VrbXk1aU56NVI1aXdiSnlNdzh2OU9iaHBleldMV203Q1hH?=
 =?utf-8?B?czZidzdLS0ExdFBpZWN2cUZIVGo2Vzl2UzRVUlpoeW5hZXJwSGh3MTVkUVlE?=
 =?utf-8?B?K1lQb1dWaWhDR3habWcveVRId3AwcjZ1eVNvOEluWWcxR2JKN3Q0aUp4SXpr?=
 =?utf-8?B?NUZrNHZmOGhmNTVHVGo2ZTNmbzd1OVJwUGZGV3RMMEdNanhDaFoxd2NDWlJQ?=
 =?utf-8?B?TWRONGZPUWw4cllzQmNoSm1acG85SW5IakhlMEJNSW1KVzF5dTBXdGZrTHln?=
 =?utf-8?B?RWZyYXlWbHhCRVVpWEVZdTZyNjJhcm13eFFtbEE3MkZxYW8zVVQxSUZoTmdx?=
 =?utf-8?B?NHMrQW53SWJiV01JbWtaQmJDWnh3SFk0QkYrZ1BaeERDODg3M2hGK2RINmcz?=
 =?utf-8?B?anZSc0VWSHVKN0JMb1RrZ25EeTQ3anpEMXhoOVA0NkFZR2wvNVZhTUltN1Zw?=
 =?utf-8?B?Qno3YUFzb1k0dEo0dm1lVUNDTkxDSUNKWEI4WHdUMXBMMVdmQmR3UnQ3SHh0?=
 =?utf-8?B?dEwrZENBSmhLbXNua1EyTW9ITkxKUElXUkQxdk1FeGJNdjAwNTlMRVB1eDd1?=
 =?utf-8?B?T3BkMEE3bzBWZWhhT2k2NlFZWFRpZWlLcVF5cDBuQ1R5VDVlaXNJMXRJYWdG?=
 =?utf-8?B?VUQ0aXNuRGh4TFJiTkdxeVgrUUJxbU54ZXNRWDJldTZYSFA0ajNscHBSMmJL?=
 =?utf-8?B?YTBSUmgxcFA1STJROUpQNkJGUTlmRExtSFQyY0dTSlZlaDFpbEFJeW9WTkYz?=
 =?utf-8?B?Um9mR0N4Y0MzdGpXZ0ZEM05HMDlDZVdtd1Z5SnNUbnY0ZVNMUGdYbndrV0VN?=
 =?utf-8?B?cnJZZmI3c0RYUVAxM050OUQ3Y1VzQXFoS0M5ei9XcG52a0Q2K2pzMXdLcy9y?=
 =?utf-8?B?eHFpOWFwSnIwQzRZUlUvUkRBSjZHUWhWRXJJYm4yQWFucVlzZDFYTmFlR0w0?=
 =?utf-8?B?Mjg0cnFRNXNtMEN0UWJNOWJueVNUU2dNdmRsbWhEMVhMSjlLOTFLREZjemF1?=
 =?utf-8?B?UHFlbWJjN01tTnpHTHRpU1NnLzJoUWp3NDZvM2c3akticHZYWTNxMHMyL0Ju?=
 =?utf-8?B?T2dPR2dlQkxTVEJnak1WU2JFOXNxbzUzaE1xaENJdzI2VG9KTDI0WWdYajJ4?=
 =?utf-8?B?SXdOWWZiNTFZNUdSYWxJSmtvVyt2L1VHdmx0OTU1QUREZkVhbEJ0NlhwQ3pO?=
 =?utf-8?B?VjB2VWhVM1g2WGhzN0NVZlQwRHRLVGVKdjdscnFnMVlVMWhYRzdoTjFnRU1o?=
 =?utf-8?B?UVZJQmlISEY1SzJ0Qmd6QT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmpXQmw0OUZQREFkdHN0VDhpYzR1aXBCMlo4OVgyVkZZU1gzbHlLUXUyR0wz?=
 =?utf-8?B?U0xYb0l6L1JxdXlCakw4Skc0a0I4ZXo0b2FTU1dHNFZPWVZrMkc4QmJMeFJn?=
 =?utf-8?B?VVBmNGVZeEJqc09vRW5nQTdiTEx4d1RWRHR3ZHdkQXo1amdYY1VyNmpibVhl?=
 =?utf-8?B?ZElwSGg4b3I5b240ZlU4dXVMWFlycEsrZUphdlR4SlBVRXNzVi9BTHRWNEVN?=
 =?utf-8?B?bXIzSklOd2RBUithYkNaT2dRSGpVcUdtV0wvejZSbmF1MHdiTEJkd0FFZUdu?=
 =?utf-8?B?N3N5M2NBZnp5clkySm1IQlR3MjA1OVJxRitBTmVyWlVTaDlkNkxNL1ovR293?=
 =?utf-8?B?Z3o4aFcyTk5KWVFKMHZkdktPaXd4ZmlZZTJYMEdaMUx3cVJJZ0lPS2lXcXlQ?=
 =?utf-8?B?OUdZUFlZRURwQlg1QW5tQjhPNThEcGF3UXNjWXVSeVB2T1NzcmxaanhOMDVu?=
 =?utf-8?B?OFllejhxWE11Sy9XWE5iSU5Zc3pYOVpvTFc4a3k2bGdQb3Z5SnFYYUJudWI4?=
 =?utf-8?B?M0d5ZCt3MDQzdXBlVUYxTkhyMVVad1kxZi9jUkdjcjFldXFLQWdRZjVaNmFB?=
 =?utf-8?B?MUYyUEhJdHdPTzg2WEdkb21jK0l4NTdISlZkVEFhdGZ0ZTVnRHhVL1pncTVI?=
 =?utf-8?B?cDIwZTJxMjU3S3pQdFM4WG9ZRWlkcWxrSFo4aG8rRStLd004UkNMRkduYW4w?=
 =?utf-8?B?TENRazJqeXdzUEFndmEyOCtYdWJVRWErMEJCVDVjcno1Uy9CbEpGenZBSldD?=
 =?utf-8?B?d3JuRVVLcjI3RjN1c1NqS2FQS3RSOXhyQmYzdGR2aVJwZ1J2eWtYWTFUeStT?=
 =?utf-8?B?QkVyNjdxM0hZMnN5UzFjY2tzODRuZHZLUFFWTTVqOHRBYzl4dGlVWlRRSXpJ?=
 =?utf-8?B?Ykt1Zk5veFVlWlREZCtoR1kzZ3FhVWdHQUc0aElzbWVDUUZEWkZsaFp5MmtV?=
 =?utf-8?B?SlIwZy9QT0kvRlRxanprajdMNXVDQnR0dThLNUt1Unk2NHAxVjk0SjhFOTdp?=
 =?utf-8?B?dExzZ0ZnOW50bEROdzg2VmI3Rms1ZW5pbDdqL3RwYTFQYVhqcUJmMlpxV3gz?=
 =?utf-8?B?S2U1djNZNXZ1YmhUUlNvZEh2VU5JT0JJaXBrVDlHdEFBL1gxbmRVbUlRZEhw?=
 =?utf-8?B?M2luMGx3UHVzc3R5RkJxZndhRnBEOVM3VXhRUkxuNmJkNUdPL2J2QlZJU1hQ?=
 =?utf-8?B?ZTEyV3dTY2xOT2RWYm1aTHhtOGJyWm5objRTUTVVckRVb1B1Qm43NmczQmF1?=
 =?utf-8?B?Ri9HR1hBbk9Va1BLSUE3NVRqRkd2V1pFa3NLcGF5N3JHQmFXYkh5M3BGSFY3?=
 =?utf-8?B?cS9YS21WUXlnY0kyTVowMkJScW4xd0JUaWpTR0YxNTlOZk1Ubjhtekl4Z0Fp?=
 =?utf-8?B?MWlIVkpLb0Y1Y05TdVFtckVJNjBrTjA0UzdMdUlwVWZDWG9TTndnRE1RRkdy?=
 =?utf-8?B?cFlNK2ZkSlNXaWRacHc4OWNqN2RaZ2ZtNjl1SmYzeEVVUVZOQ1QyM1hzVWdn?=
 =?utf-8?B?WHF2azhZcmY0Vnh0MTQzNmdLZkNZNlZsUG9aRW9xV1FyVmFROTRUc2hudG96?=
 =?utf-8?B?MXZJckNpbHdaR3c0dys4VjdxWkZhb0l5QW9ySUpxSDNTTHVqajlONWNPZzM2?=
 =?utf-8?B?eFd5UWUzWU95WEsvNW1aWnN5R2J0QUJ4d0ZqZ283RDhONVRxS0o2amVrOVho?=
 =?utf-8?B?KzUzb0tPaHZCRjNiR0NDQTBuL0ZERllMVWVwNHNKc1Z6eDBwcGEwUHpFd3FL?=
 =?utf-8?B?Uk0wTjM1U1htV1pnSytpcGZjRUJ4dVhUQ1hjc2JZMmRiRWwzdVFEUkVhQVF0?=
 =?utf-8?B?Rk5CNGFwQS9WNVRCdnI3ZUhTV2wyRXJXQy94L2VNTm5HeDYzbmVPc29OOVlu?=
 =?utf-8?B?Z1FuNjRwVmM1elJrMjBLblB6TmxZZzNJcUZJUkZzWjFXUlN2bncwQ2dvREU1?=
 =?utf-8?B?M2Z2MklWaXhVeEdQeTFmV1NxS290SDZWTlJOVGNMcmpDbmV5ZTBxZ3gxeVVo?=
 =?utf-8?B?VDNwQ0RjZ3dZNXkyNXFZZWxIYVZJamxRd0NicUhScjl6dVllMGs0bUtFMFJ4?=
 =?utf-8?B?aTBXQ3JDWHBLNmpHcmRUalZVVlNJTERtck52anIyc3ArSy9UWmM3aXNUZlVZ?=
 =?utf-8?Q?0bsyrSs0SLekEB0XHgABt03Ud?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b385402-1620-4702-92c0-08dccc70d869
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 23:33:42.0362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTDpyX0DLYxh3jzO5HTtLjYI7g37OSZEvHe31xY3Mgxwq0XrKeyw3ao6BYWvxG69
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6938

On Tue, Sep 03, 2024 at 07:57:01AM +0000, Mostafa Saleh wrote:

> Basically, I believe we shouldn’t set FWB blindly just because it’s supported,
> I don’t see how it’s useful for stage-2 only domains.

And the only problem we can see is some niche scenario where incoming
memory attributes that are already requesting cachable combine to a
different kind of cachable?

> And I believe making assumptions about VFIO (which actually is not correctly
> enforced at the moment) is fragile.

VFIO requiring cachable is definately not fragile, and it also sets
the IOMMU_CACHE flag to indicate this. Revising VFIO to allow
non-cachable would be a signficant change and would also change what
IOMMU_CACHE flag it sets.

> and we should only set FWB for coherent
> devices in nested setup only where the VMM(or hypervisor) knows better than
> the VM.

I don't want to touch the 'only coherent devices' question. Last time
I tried to do that I got told every option was wrong.

I would be fine to only enable for nesting parent domains. It is
mandatory here and we definitely don't support non-cachable nesting
today.  Can we agree on that?

Keep in mind SMMU S2FWB is really new and probably very little HW
supports it right now. So we are not breaking anything existing
here. IMHO it is better to always enable the stricter features going
forward, and then evaluate an in-kernel opt-out if someone comes with
a concrete use case.

Jason

