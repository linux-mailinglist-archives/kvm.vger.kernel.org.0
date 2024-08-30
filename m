Return-Path: <kvm+bounces-25549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 996E5966715
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 18:40:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24F501F24744
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 16:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE82F1B652F;
	Fri, 30 Aug 2024 16:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QxEM37IU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9739E135417;
	Fri, 30 Aug 2024 16:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725036030; cv=fail; b=gDK/CBIyYJC5qeByLbO254Pk63aGA7nTyfIMMpGCsf45Sh3O+OGgrTxJmvSSNj1iL1fx/pCL0K4ALGWKhuqprO6n+PqZg91XVXqBu5zg0z8Zp3hFmDsguP3ma/7S78EIUYrrNqn8KvL8otjEDIGtjfFDaD7peS7MD7wBLnm+QdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725036030; c=relaxed/simple;
	bh=I1k9bOXaxgUo+d6LBkk2BSHIit63H1rLpZzZLOpw/dY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E145Owo1aeWn6fJGXxI4LnabCYKGQbPJYTD9ry2oC202e2boVmOrdST3YUV5fQuj7faAPlQtoasPKVlhTD3VC6rVa9QoubEUTtopXS3C7jd/T5wrPFNoc+10LMNmnB/JBP4fB8eB7f2nYFRzZcpK2J+o8sCmCkgK/bHEztPZ69k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QxEM37IU; arc=fail smtp.client-ip=40.107.93.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M0Btz5gcuDqz1x6hzwPI5lKXylanUpYq2alPSLMtIEaSNaBbnpwBKTRArtx3V3gNkapk+8skZJ7CSEGDS80/l82HBT+IlqP1C5hKT81nvIP/LDKUSzeHMmlZew+sw7rWMblejgpzoxVC5fb21Mlc1J0wmIzdI84ioaaTSAzKnLTjhONh4LUq5KM7/dUXu4AHWO4p/+rG3/lTh0/442umhBIcO9PhmZvdUKhDztkCsl6fzxqq1rEihbyBQd+mmxD0j0PO/X396EhKHbGREqw9LyQdAkfrSHT92vkdFI4+J2DfJXrAMhtywpWsM/R+AWqoDbVUZH+Wq3SvN1Gr6Ul5AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VwoQa/iR9ZRuTYT5sqaKbOaVNMTSbQRY6UMLTR24eY=;
 b=UpXQ8SmofPcwdc8Z11G0TXHnewRz6FOJE4+uBtD/pTIVDh4fllt4U4q8SQsdDB5AedtxCPgUUHupnC6poSjGhP4oyuERz3DQ5H8HQExREvSpZoibPW11Q8lWHVpvVHABKiBrJyDjqasErZKQGrKn8gxhaHYKC6Gilj68GK7byClJDksXZNNl0M+b68vP9nbeR6cFXHhDZtMOg6+PS7RHeg0citTaFpVGmzspfBKTS3GvreQz41TB0K1SrMr6DYRLDcDLTRFRthVZSOsmuvFjXTqXnbnEkN70BKSL+SwPtLL1h2FWS5236HzUVBZthEE/Bzj/1Z8qqLezB+qrvxV9zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VwoQa/iR9ZRuTYT5sqaKbOaVNMTSbQRY6UMLTR24eY=;
 b=QxEM37IU+coWUkUWIV3UAWvOhfFVOv3rF8uM4iTfm3zg5qMSW2JXUpAKOwK8NJ45ZBhZP/5oYRb67QqaLbFURPZ0OA+GzqU24PtIqv5Xol76qkJCMpIpDYVxC+/NcvFm5ucEAQg1tv4SueaK8vaCADXPaB02d32K78DTSBEMyROkwj8U5WC3kgC5eOasdteWiwEbEDZ+NmEs1sg8TfK/MCLBB5a9L42+mYDd0ItiJbfeoEgcW+zQzFXj4G1KTiIusD7MmkyHeQdD8St6pyoTaUdLhCH4mQDXn52Wm+RixPN3eUYr36rgXFzCPysmPL/fH0x0mxroxq5gNdjbw3N0BA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH7PR12MB7259.namprd12.prod.outlook.com (2603:10b6:510:207::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 16:40:22 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 16:40:21 +0000
Date: Fri, 30 Aug 2024 13:40:19 -0300
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
Message-ID: <20240830164019.GU3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHhdj6RAKACBCUG@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtHhdj6RAKACBCUG@google.com>
X-ClientProxiedBy: MN0PR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:208:52c::27) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH7PR12MB7259:EE_
X-MS-Office365-Filtering-Correlation-Id: e93909a0-479c-48d8-6c17-08dcc9127038
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VS9TZVJVRHBYWWp1cWZxc29MeXZ6T0lXWVNlZlJsYXFUaUhZTlB2cldOSDRV?=
 =?utf-8?B?M1RHNis1c2lDNGpGKzJMcUFqeXBEUTRudXliUXhwcVU5b29WMG9MQmN5OFJJ?=
 =?utf-8?B?T2E5QWIxRHozRVdoUlNZNjNjcmY1NnFWY0xvbTFzVHd0WjVScEJHVFNIbGhV?=
 =?utf-8?B?LzZsVmU5YzRoN0VJL3g2OXJCVXBYOXFZOVV0L09ySU1Udkp3RHd0aUFpa2VR?=
 =?utf-8?B?UllRYmhGeEx2YzdMMlE3bG5ndWdRWnk5TEIzK1ZPM2RXYUFGaWV1SCt4aGl6?=
 =?utf-8?B?QTBwZVBxTnorS0ptNmk3VFFCa2VMVGIxOFR3SVA2UldtWGpBSkMySkhSdm5J?=
 =?utf-8?B?emtndTBuY0loR3IwdDZnYnhON0JwWkFqOC9HbjhZZUZyWlJQOFREZWlld0ZH?=
 =?utf-8?B?UnQyZGd6K1RNbW5UMG4vN1VGbnU4T3FzNW9BQXNLSjd5MW1kd2E3ZVlEUHMy?=
 =?utf-8?B?anhkbWhzTnJiamRDY0xWalkvcXhaUWZIc3h5WWE0S2ZNLy9VZ2plZ0lIbEdM?=
 =?utf-8?B?S2pqQVd3alVuQWpEN0tPbEtBTzNwNTRMUmlZa0N4Y3NsV21DTkxwaCt3dUVy?=
 =?utf-8?B?Y2tBekxLUjU3eCtJQUtrQmJiOVBXeG45ZXZuMm1XV0RmWGZ3eE9XejlPeE5z?=
 =?utf-8?B?Zmgvazd6U0lXUVd0d3NwZWJvVmt6VC9nSG5ZbDJjaGEyRFNCdXdCOERSa085?=
 =?utf-8?B?ZVpWT0VmM1BZQXRpeG5sajhXYkhkNXZOeW1OZUswaWFQYzNxK2RnRlFnSVNl?=
 =?utf-8?B?R1dXU2ZPblU0WnNZWkFSRUdYUGRkSzJIVVI0c0VFWG91S2V0TEszKy9wTk9U?=
 =?utf-8?B?eklHT2tBSVVNN3l3UlVPK2dGbHMvUml3VHZFN2owQ21aQUlwN1BXaTYySmZo?=
 =?utf-8?B?UUFRT2x0SVRGcTJnTE9MdmJ1V28wcU9WTUcybnJHRmNXMjFua0lpMkVSR3Zl?=
 =?utf-8?B?c2NWRVpjNzQzbjh3Ym1yeTQ5L2pwMllSU3UvQVd2L0ZrVVQvVWRxbVI3NjdL?=
 =?utf-8?B?bmNaVTZseW1vNUwraXY5ODU2bG1Vc21BbDNCTWZVbC9kU3pzOEtBeTY4Q0kv?=
 =?utf-8?B?VlVHKzZWbTJYR1RuNWFaTVVrclRHWitoQTA4WXNqN1ExbXpISE1DM0NWOW02?=
 =?utf-8?B?QU93NytVbWxXNk53bm1MNnZRMzRXbFVkenpuQTlkbW00T3ZYSWFwaWF4N0ZM?=
 =?utf-8?B?ODV0Mmp5QjM3MzQ0a3krRTR5UEwxb3N6TkZqd0ROSmlCQ3BBNDNLSFByZFhM?=
 =?utf-8?B?ditCVkQ5QVhxTEtheUNHZFNzN0hmWVovOFhUMmNNNGxVQjBxOWdxekcwRU1a?=
 =?utf-8?B?MTZlRjlSakZOa1htTlAvaFRUTUwyR3YzaTRBaXhJajBlMzJGazh5dG5XUDMr?=
 =?utf-8?B?eGMxbTFLUkdEVzlZZTlUcG5ua25zU1N0b0hUaEthRFRKZXBGZjB6dWREWDFj?=
 =?utf-8?B?R2dRR0lrc2dHelI3YTVORDlwMW4xTjRIWEphbVE4N3VBMnJlajhkQ3NlMERP?=
 =?utf-8?B?YW5qWTE0bEE4NG9rT2Fmbm15MGVrU2d5U0Ztb1NrWFZ3WVBzMDF4K0JDUGNr?=
 =?utf-8?B?QUNUbm1FVFNEN3hXUk8xYjlmRHE4cVgwZTNsVzdDellPNlZVZWJrU0dGMHpW?=
 =?utf-8?B?cGV5MzJjZkw0U2ZkckxOS1Axc2crV3g0MnVhZE1janR3Q0hLUldmUFhoLzBT?=
 =?utf-8?B?UUZGNTl0bGwwdWVNRmVLM2JwZzRmUlhJYmJLcTZtSUVJbVFja3BoR3drZ29V?=
 =?utf-8?B?MWw4UUxvR1FTUkd4NFdBTmx0NXRpaXFpYkhINUhjb0FROXdyMHFrd2FVdnFB?=
 =?utf-8?B?UWtiL0tDYVB3MUhWN2xqUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z0hvQW05aSs0bk5pWHpYR3BXZG1RZjR5WFFlT09zUS9mc1VQQ1RwUVV1VDY2?=
 =?utf-8?B?UEZZREZPbnJNblgvRXRJVldJS2FoblR5a0Z0MHp4a2hocSs3ZWtESjlHVUF1?=
 =?utf-8?B?NVYrbm1XS1lHbHJpRnorYkZpMWZtS0pOaE51cmdyUytrT3puZk53YjBLQ3JF?=
 =?utf-8?B?R0NTU1BSWkk3eXBBVHM5RDVHcWptclBkTkVqYjlzWnphUWExZmJBcFFNVGFy?=
 =?utf-8?B?LzU0SDY2eld5cVhOSmFQNWFtUExxdndvMm9JdEZETm9mWmloWTlYa3NqQU4z?=
 =?utf-8?B?ajF4Y1dGN3hMaFluNDNpTmFVSU83enBuTnVXNzZkVkdiZWVzNTduREFFemlM?=
 =?utf-8?B?eEg3U0RBVkVIOTJQQkJ4dXBISktrSjViNUcwd3dtb1JGWVQ3LzhmdldXc1kr?=
 =?utf-8?B?MXdWL1NOZEpqaXc3MDN4b3J0YXlNZFVQRjhTcUx4QnhSM0o0M0VFSy84VjNS?=
 =?utf-8?B?L1lmM0UzbFc3ZkNnM0JJYVRRRnZPVWliSW5xcUhFSE1pYmNCaDBBRlFFQlJR?=
 =?utf-8?B?UDAwZEZBZ1FFWHRvZjFVajQ4ZGRjMVRWelZmbklXZE5QWkNRNmMydVpTRnhj?=
 =?utf-8?B?KzB2ZVhXR2RkUEw5bzlQTWtCbWVuTGptN24zUmNrUlpqRXgvaTVkUmxFbnNC?=
 =?utf-8?B?SUZjcnluUDdaQm5pWVN5eWFJOFRXanFvNVZHdnk0VXNWMS9Ib1hZcHVJUzQ2?=
 =?utf-8?B?MGF2WHRBR3htWFZPaGU0ZjljTFVsNlIxKzdadlNORFlsS2hwUTNVUTFGeW1B?=
 =?utf-8?B?U2gxNzZTNEtQNVBFZzFua1dZSjlUOGRJM01SUFNncU80QWdlS0Q0V3pSMk8z?=
 =?utf-8?B?SWx3K1J2eDdTOEg0ZEY0NjdSbHdZdmk0LzU1Z0hsMVpRNDhyaUVMNCsraElP?=
 =?utf-8?B?YmgvcS84TWhYMUloNTRSNGtXeHBwVFNVSWJ0MkhQQ1NyRlc1Q0JYVllud1pm?=
 =?utf-8?B?S1hucTNlS0JadndNQVBLSFZuYVJmQVdxY0VQWnJGQ1hqSHE0UHJCdWJzck9s?=
 =?utf-8?B?ZzJTREQ3MytFczUvNTdHUXhBV2t5M1FrN2trR1FqT0N5YlVpRGlFMUNwZmpV?=
 =?utf-8?B?V3RDVG9xVGczSkljZDYrZktBOXVYcUltb1Nlcnoxd0loYUQ0YS91dXdES2Zp?=
 =?utf-8?B?WTVoR09MNldBdSsrYUlxSGx5OXV6UVJsSWE2cVFLU25UbVFPTGpUQWpFQ1VO?=
 =?utf-8?B?UUxHTVg5alg4aHRJU3g5N0ZyOW1uVW5NMXRJTDZGOElzbkE3VG5LL0dRYVZ1?=
 =?utf-8?B?UGtxN3ZMZjRpUWNzbDA0VllLRTAxcCt5T0Qwdmdvak93Wnh1S3R0aVJkWnZS?=
 =?utf-8?B?VWwzRll3TGdzeG1ZMFNEbThEY2lCSXZNWEwrYXVDd0JhYW9PeGNiMUFwOU13?=
 =?utf-8?B?QnRNeWprVkdndFNtRkttaWJoL2RDVisyMnpwZ3FwYytQWmUrNyt6RWxTSHRC?=
 =?utf-8?B?YTdUMHRXZkwrQzlwbE5vOHNTT2NwRGUrMzZtOGtVZFp3bTRnTllZYkxzazlh?=
 =?utf-8?B?L0VwQzFoRkhFckJnR09SNllDOGYzMnhJODJkU3RQajRSQkY3bThIQXZRVDFB?=
 =?utf-8?B?QkpqNGpVOXRNNmV3emRoVldqdExIT1c3aGE3UmkzYnhnRU1iMGliTzJiKy9h?=
 =?utf-8?B?aWlBOW9Sb3BoTUVzUzExbnFBOHVDNUwvS0pOWTZRQ01xUW5JTnAxeW4rMFRQ?=
 =?utf-8?B?dDJpWHZWZTVtK1h2Z1B1eXowUXo0c0hVT1VCRkszdkxMc0RQY1d2ZndQMnFm?=
 =?utf-8?B?S2ZGd0VTVGNRbktZRGdZaXhYK2RvaElERmRtTU4wS1RQbmtFQ21QUmczUTBl?=
 =?utf-8?B?cHIzaktuUlNkWEhTWGwydUNVTHVNaFNFL0pqSm1UYytmVHdCaFA1Wm9ZU050?=
 =?utf-8?B?SnVKaFpYeU1MODljM2JzV0szQ3lYeExxOUQ3alZYM1F1VGFwemRHRWpPVTFQ?=
 =?utf-8?B?OE9lajVRVjVHUDN3bm1XUzYvS01WRFdjNmxPL3l2c1ljeGtTU25IVUhlbjds?=
 =?utf-8?B?ZHl2SFUvYnJCNHUwbFN4YThYa3B1Zml1TVVQZEFPM2FNdDhKd2FwYWt0ajRB?=
 =?utf-8?B?QlVBUDJxR1J6MW1LcG9UUmV2anpqZDNrNHJlUjJxTnhyTFIzdzlrTU5LTE5s?=
 =?utf-8?Q?CVAt/SxBB0NF0gFDSs9ubU8xm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e93909a0-479c-48d8-6c17-08dcc9127038
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 16:40:21.0880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3VWQBc7dafhDA2LsuIOXi29EoMRFnWbSCS1co77iRHeao3OIVRBnqItiMG0vxVkA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7259

On Fri, Aug 30, 2024 at 03:12:54PM +0000, Mostafa Saleh wrote:
> > +	/*
> > +	 * If for some reason the HW does not support DMA coherency then using
> > +	 * S2FWB won't work. This will also disable nesting support.
> > +	 */
> > +	if (FIELD_GET(IDR3_FWB, reg) &&
> > +	    (smmu->features & ARM_SMMU_FEAT_COHERENCY))
> > +		smmu->features |= ARM_SMMU_FEAT_S2FWB;
> I think that’s for the SMMU coherency which in theory is not related to the
> master which FWB overrides, so this check is not correct.

Yes, I agree, in theory.

However the driver today already links them together:

	case IOMMU_CAP_CACHE_COHERENCY:
		/* Assume that a coherent TCU implies coherent TBUs */
		return master->smmu->features & ARM_SMMU_FEAT_COHERENCY;

So this hunk was a continuation of that design.

> What I meant in the previous thread that we should set FWB only for coherent
> masters as (in attach s2):
> 	if (smmu->features & ARM_SMMU_FEAT_S2FWB && dev_is_dma_coherent(master->dev)
> 		// set S2FWB in STE

I think as I explained in that thread, it is not really correct
either. There is no reason to block using S2FWB for non-coherent
masters that are not used with VFIO. The page table will still place
the correct memattr according to the IOMMU_CACHE flag, S2FWB just
slightly changes the encoding.

For VFIO, non-coherent masters need to be blocked from VFIO entirely
and should never get even be allowed to get here.

If anything should be changed then it would be the above
IOMMU_CAP_CACHE_COHERENCY test, and I don't know if
dev_is_dma_coherent() would be correct there, or if it should do some
ACPI inspection or what.

So let's drop the above hunk, it already happens implicitly because
VFIO checks it via IOMMU_CAP_CACHE_COHERENCY and it makes more sense
to put the assumption in one place.

Thanks,
Jason

