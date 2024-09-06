Return-Path: <kvm+bounces-26010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65ACA96F579
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 15:35:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1A741F251D8
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 13:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A943E1CEAD5;
	Fri,  6 Sep 2024 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QCZNHTm9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A94212F5A5;
	Fri,  6 Sep 2024 13:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725629692; cv=fail; b=iYCadmLQixctshY7wXztX/AUvelWWYgPTX5VmP2Jdbup3EpvPbTamu+8p7Wtas4cEpvjXWpr6XwuHMS6qA1QRWuyMTpI6/zn2KMtOj/aIR+kg6nqZKDO0vY+5vl24+nYS4lBJ4JnPMg1Pzn6IXez+L29Y7NOmS/eFOE/+B0/JZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725629692; c=relaxed/simple;
	bh=0F/JGCAqkcZuVZFoH5d4GfdYUPNhaz5Y+L/e0xfNKu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gj74zS2HrOBVl0fdSS+fluLOM2t2CSv8WXaXTtIaQk6YwJOmMiRjigCmL0BP1TK9ryr1A3o47UeJgRajOIWy8kAZAzZuMkYmgAQZIRli/QuYLVLYxYX8EocwgGg44lWRtIjpzJNJ2yUbDabH0dQXxdFXnDlsTTK9FsbGM+VJwf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QCZNHTm9; arc=fail smtp.client-ip=40.107.243.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EkvnpJbEESO+T56mRM61E7wPfrfMyP+xqZy7DmOKAFe7SviVV45pDdxypVxhUfcf94IIb5ogxDjfGysOU3zg3rS6FWl7Qw0H/b+DQpToLC1uO89Vrz2NKU8eydDYfvO/J0nm0768uXRGIKb/neWF1OeSodUxM/ZmKJLNH1SPiL7Ki128ypZhls9R7i8EcjydU2Hy3/a/MvK2XlHOqp0sWka65Fsv/4MC1tFc5zCt1yhaQqNa6IwS9LO0BVBC+oMbT+4fBmgodsmM22S9Kip1nGqPxsf/U/pPfysbiW6pc0T7JfTHMZcT6l4B6cO1OyJINFFJF+eanE6GY+Hmkdv0QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ykm/MZmT8sfOubtCYf2fVvnZ0YifIoU6gWOS4bi6mhU=;
 b=PLE/+zSAytadtlemmJlKDi1AjvSEWUZRWJ220gFfRlvfHk8V6ntH8YAJhw+2O3Hlh/fXu3Ipy18d76bVkvlrF8aDEHKZmTu+9PP8xwDdN8HwCVyl7b0nWWQD6q4rS1lzijp3H7tBi2llYldI/yLpPIAgMb0AaNGh4F2WudpGVM6sbrziGlUMfPbPou/JLdivJOgxUH4aDllQ7n1mJHVco5D05xMMb5EX6Ng/ptNNymApbfWulJsKZzZ1VtuhZUC5f+exF0Hn1VqusSMQm5jfvFFgQxATRxkH/lRTqON7flcuGq52Aqr9pSE/dtEHgxEQHejsF1V+bR0+MVS3nsAQCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ykm/MZmT8sfOubtCYf2fVvnZ0YifIoU6gWOS4bi6mhU=;
 b=QCZNHTm9RqyyfsDYkeYNKd+UWeNmEiROC7cs9q70DRrP6cjfeK/804nIHwA6gdPAlX4HIj3YwcGS372MLhC++x65hR7EMhMmAmhyKbZ1xRNmxi1x195qTuw25kRaphpifVHtua69EbUikGjU7a8Jru/URcAGJk5jY6NTemsxWlKLWOiwDRBZoRu6xSVi6OhMIW6ZL+q4fEM3rdHaUULeW6ahZ8o78MxcNpKOBhjJ7Cp7imYY/01A83FJSBZ//0lJngNyLH46rNTZP4raZTMAiNq3KeBJ8oa/dKgSAdlmzvdyWrfj/71PiQLFfkikHe4MzQioTWRYB+NlGAm3A1nhbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MW4PR12MB5601.namprd12.prod.outlook.com (2603:10b6:303:168::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Fri, 6 Sep
 2024 13:34:46 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 13:34:46 +0000
Date: Fri, 6 Sep 2024 10:34:44 -0300
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
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <20240906133444.GE1358970@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHuoDWbe54H1nhZ@google.com>
 <20240830170426.GV3773488@nvidia.com>
 <ZtWMGQAdR6sjBmer@google.com>
 <20240903003022.GF3773488@nvidia.com>
 <ZtbQMDxKZUZCGfrR@google.com>
 <20240903235532.GJ3773488@nvidia.com>
 <Ztrigx4LmpbFiMba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ztrigx4LmpbFiMba@google.com>
X-ClientProxiedBy: BLAPR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:208:32d::10) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MW4PR12MB5601:EE_
X-MS-Office365-Filtering-Correlation-Id: 932a25bc-1222-4356-2a24-08dcce78ac4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N0FaWENhSHg0dFRxTXgwUzA1NjBUSDhWOGppTklDNlRDY09BbEZlS1Q0dmI5?=
 =?utf-8?B?djl3a3poaEk4YllYZVNnY1d0MTFqMmo2ZjFlQU1NVURtN1hsVmVKeExlS0w5?=
 =?utf-8?B?MFVQZXZGa1N2aDdiMGsrdjQva3NJNzk2UC9UNXNrRWtzTmwvWUl5am8xeERw?=
 =?utf-8?B?K3Q0Vmowamt2M1NFN1dESDUweFIyVytKenhqMFVqRWlEb0tBY1JzM29qZWty?=
 =?utf-8?B?YWMway82WEVySThNNS9aaTJDSmdwbUlzTS91c0x2MnM2eTVCYjZxWWhMTFBI?=
 =?utf-8?B?blE1Yk9OZDBackl4TzFtR1pEV0xDMWw0YTNTb3hmOXZyelYzby9Xc1RqUm91?=
 =?utf-8?B?UEdFRHZlZ0YyZy9ENVd3NERDREE1QzFzS3FuMStNUk1OWHNiZXJUWkV0L0Fw?=
 =?utf-8?B?NEVDdktrL0I1bkpPK3ZkeEl2MUpFYmNSRUg2OFpoUk13VG95MTdwWGF6UU82?=
 =?utf-8?B?T2ltOUNNZkp0RjU1Rnp6OVE3K0hQd0hOdzRKdzZLYWdlMEkvclY2SktyZXY5?=
 =?utf-8?B?dVNnMkw1cGJyZXIxR0sxekVYbkd3Zk5kNWRmWW9zUFNhV1hLbzVZTlU1MktP?=
 =?utf-8?B?bDAxZ090dFlTUVZCQlJUSmxEeFhlakM4ZXBkNmc1VXFKbWd3RVhWWC9FKzYz?=
 =?utf-8?B?NnlBTTFDMmM5b2RrWklYcGk1UlhHaDMvdEJBZHdBVGFwNytwVWJ6Sk5wWVZi?=
 =?utf-8?B?NlpZN0JnVU5wVkJ3VFFDK2xzSjEyS0ZLQ3Yxekh5WnBWRzllSEM5a1ZtZWZv?=
 =?utf-8?B?eDFxcUJyMUNZNHJWY1NiYUpBRU5nL0ZSeUo5RGVpcmNMeERROTFiM2pwRmUx?=
 =?utf-8?B?eHdzbFpleFFpZXJvVnR0TGJXb3RKNVpLdFpPaGZPOG1vRFJoQmtTTjRTeS9D?=
 =?utf-8?B?ZVZwcW95SGpxaGJqaXVWeWxVaHI3SER3ZE81dlplMTZSRVJmWkU1VXJRWUty?=
 =?utf-8?B?UmpTNjVVREttVndkdGw1K1ZyQWhLOGFqN3VNMWFGb1J0QkhDNnZVOUplamgr?=
 =?utf-8?B?cGd3WmFCcWh0U0NPNGJrUm1mcVVCZDNabFN3MHFNUzNRRWorT2hldzJ6aUJz?=
 =?utf-8?B?MmdQRVpkZlFEMWQxTmRKVjNkTFZFdGZITXdnUytza3F3dEZOMHBFWlprRDll?=
 =?utf-8?B?ZlBXeUtUd2twNVR4cWVPdnNCMFliOFIyajVSbHMxMU42ZTcrZk9hRlRYcGhJ?=
 =?utf-8?B?cjRwSGpNeW1mVXhFKzcySiszb2VRZ29xZlJ0bG50TURERVFHRi8vV2dwNnZH?=
 =?utf-8?B?MGxtR3JUNmliTWZtMlJ0bEVqcDlONEtlem50V3lGNUQ1cit4UC9RK1E0WTJO?=
 =?utf-8?B?b3AzNGorNFptVysvTjN4dXN3N2ZKR0gzRWhtNnNKYUFnUnZDSGtYdjNXd0ow?=
 =?utf-8?B?d2lHM3pVZm1acTg2SWw5QjlsbmJTZnhZejFTTklocDFqeGMrUkVEUVA4Sjgz?=
 =?utf-8?B?Mk1nQXBqcTVXWTZyYlcwMUFjS24wOGF6cHBac2tJZ2c4NXl2bWJRTWVhMUFT?=
 =?utf-8?B?RGtvRnQ2K3BSRVQzeWVZRTFGZ2dDdEQ0NHkvNHVpcUVqNmo1Y1RaNWc5bTRm?=
 =?utf-8?B?eThKN0RQRUFKcEVYN3BPc2dIcHpwNnZjSmg4VjNySU9xQklqcEcyQTN2MXdT?=
 =?utf-8?B?bE9tMmRsL3pQVjdSVFFHMHBXQjNUSlErVnh3QzUwNEVUU3Fmc0g2MUVibkZ3?=
 =?utf-8?B?Q3h1RWphSExKWDFSZEZ0RmpLZklORGorSlZrV0pjSjlXRm1yamRscG1lbG5E?=
 =?utf-8?B?NlN2K0JBbDZINldxUmpxWlp6Q1doOTVhdW1TWGtLVXMxaC9Kd1hlWmE4dkd1?=
 =?utf-8?B?UFJ6TUJSR3UyYmt3NFZMdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cndxOUx5TDhFaDhkeUxxeXZrYnFHMWFkODlMMExNQ2lDUm96dWRpMVFQQzZC?=
 =?utf-8?B?MElEeUlQdStETFdnc01SQVNBM1hQVDE5NnhyTzVHdFIxeWg1c0hrUW5NVzgz?=
 =?utf-8?B?V0VFaUplWEdRSDhaY0ZoaWljTFhBK0E0QURzRU91ZHVIN2dxUDY2VDhHU0xC?=
 =?utf-8?B?dm4yT1IyVnR0ZkhsNlVhQ01NVGcwcStqK3NoMTBRcEREUWM4RjhYSWJ1ci9k?=
 =?utf-8?B?TlJOR1VBRGJaUUFwTE5vWlNFV1dPUVUvWU5tV0w2UGowZ2JxTlJVWDhqVjZq?=
 =?utf-8?B?QXQ0aVFYL0pTVHg2bUxpRm44L1ZKNUF1LzFsU0FZWlQ3WHZSbzV5S0dvMDVF?=
 =?utf-8?B?Q2hLYmk5U0tyZzNLK3JaUzhpOEpvVnc0TW41UzQyRWZ2TVM0YlpGaUJBK1ox?=
 =?utf-8?B?YXRRcVNHSTgwMUs1ZzE2RmczbEZPcXB2dzNuM2JPQUZWY0tiSkFMVm9hK0Zn?=
 =?utf-8?B?NTF1SDhDc0Y3aFFCeFBBZUloZ05IMEw0OEUyNW1HdzYxenFUaGZud25Gc0xH?=
 =?utf-8?B?TGxjZDdFRnV1Z3ZHWE96MFNOYU5jWHFraUNReWl5ZmR6S1Y2SEswSkRLZUNv?=
 =?utf-8?B?WlFqRWNrU3ZLU2VPYUZ6eEY2WG1VRFUwd09xYTY3SmRUNVRSbEh4K1FObklT?=
 =?utf-8?B?cEdpbkVxVTkxY1V3VCtLOGs2RHhFbFN4Sk5hUVdsYzVDU2FMWVJmeVYrM2VZ?=
 =?utf-8?B?UzlzOEpyR3dpTkt0RURvU2UzY3BqeGc5endqRVZTMlJCUHhlMS84MXloSzJk?=
 =?utf-8?B?Z0NMbGtzNWZkN1BQalRHVzh2YVBkMVU0dXdCbE52VUdZVGhtWkpIcjIxQWlx?=
 =?utf-8?B?K2l0SDlGRlVIbjJVRFdXQ3U2ZGJoK2FIYjNod1NrcjdTM093NHIrY2wrQ1Bx?=
 =?utf-8?B?WFBuUDN3YXR3SjFId0h2T0FldysrbU0wZjdNQzMyU1pvZU9zZ0lUbVdqM2Fk?=
 =?utf-8?B?cmRJNjk2TmRxeVV3OTEvV2hUSmNnVk52ZXA3b1RCeWNkNnBiei9Td3dlc3Vs?=
 =?utf-8?B?ak9RcWE0TE52ZGdGdWF1eE5IU3Q4OEI1d1Jxc1ZaOGdkck5yU0ZKMWdCR2dU?=
 =?utf-8?B?bmk1SFlFTkpvekVITVVRbkRMMzJQaWd6RGxZZ2hGL21jc01vUjVxazF0WVRH?=
 =?utf-8?B?UFBlWDZ6dGVUdENJU3AraWVYaFM5dExZUjMrRFJoZW01WjhvRTdZQXQ5d0Qr?=
 =?utf-8?B?K3JieEtuYVpVNGZvQ0VRWkk1ZE8ybVFmVFZpSVRVd2lTRXAzbkJOeFR4S1NM?=
 =?utf-8?B?N2Z6WHk4WE9GZ0cwb25ka0xWMThZenlxeUMxWXVHN0R1YjVGSlJVUnJTaGNj?=
 =?utf-8?B?NHJEbHFTRmgwWVVPc05UZDZIUE1KZ2VBcm8vZGova1pmK09wQVE5bnBSYVdW?=
 =?utf-8?B?dUtlR2pnZFlvS24yMldIMFBDQXpkaGFSK3JXZEJoWnJBOEZpdUlxSHVCUjlw?=
 =?utf-8?B?SHZsUUFydGNGUmVxTS9LaUExdUI5bEhBYWdSckhIMUZoWC8vKy8yV0h1aXFE?=
 =?utf-8?B?aGpFSC9wSmNxSExuNUdpa2gzdExZUXFFWXVpOEhCZThuTFhIL2xBeWVFQjR5?=
 =?utf-8?B?emRBTjU5Q1puODJGOHVDU0htNVgzNUpjaWEvQjVmekdpcmFiWVM3WWFhVnJD?=
 =?utf-8?B?SnpPay9PUlJ4aS80SmRsY0dZRml6Rm1oMSs2MGZwZzJ2a3lpbjJiY2U3RFRs?=
 =?utf-8?B?L3oycTQvRUFKMEJhTUYydjIyYzlQaWFGZXhsazZGN21nUGVaZjhoRFdmZ0M2?=
 =?utf-8?B?TWxreXM0WHQ5N1R2Mnk5OS8rQlVKTWhWdjJyazg1czd6WXAySWUvcTM2UFVT?=
 =?utf-8?B?NExtUDgydTBuM0Y3U053WUplc1BEUEpXdnpMVTlUdzBrVmdBdXI4ZTFhSmtz?=
 =?utf-8?B?T2kwRHp5OXZFMTh3L3ZMWFA4NWh0RGdiQmFqaElMY3NzMlFGaEk4SHlhVzdY?=
 =?utf-8?B?cC81dTh1SExrcDdNRVoxaFpZZzU1cWhyY1NRYlpNMW5QOGE0VVlXNzZxdmlI?=
 =?utf-8?B?eXpQemp1ZjJZOS95OG0zRHowdUFyencrSEU0Z0pGYzJFa0dXN1JwTGlZcXNO?=
 =?utf-8?B?b1dtKzhUNCtpRHUyYUtQWnNVakNYalhtMmR4RzVPbUQ4L3dqZm1Ga3RwT0NL?=
 =?utf-8?Q?jMaNWP4oCcLuK0uvG0BDD1Axq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 932a25bc-1222-4356-2a24-08dcce78ac4c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 13:34:46.3362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: scKwjmt7g7NuT14blxQi5Ridpahap7cVk+Lzqc+JjywsPdwmhosWFxZuw1Rj/Z1Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5601

On Fri, Sep 06, 2024 at 11:07:47AM +0000, Mostafa Saleh wrote:

> However, I believe the UAPI can be more clear and solid in terms of
> what is supported (maybe a typical struct with the CD, and some
> extra configs?) I will give it a think.

I don't think breaking up the STE into fields in another struct is
going to be a big improvement, it adds more code and corner cases to
break up and reassemble it.

#define STRTAB_STE_0_NESTING_ALLOWED                                         \
	cpu_to_le64(STRTAB_STE_0_V | STRTAB_STE_0_CFG | STRTAB_STE_0_S1FMT | \
		    STRTAB_STE_0_S1CTXPTR_MASK | STRTAB_STE_0_S1CDMAX)
#define STRTAB_STE_1_NESTING_ALLOWED                            \
	cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |   \
		    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |   \
		    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_EATS)

It is 11 fields that would need to be recoded, that's alot.. Even if
you say the 3 cache ones are not needed it is still alot.

> > Reporting a static kernel capability through GET_INFO output is
> > easier/saner than providing some kind of policy flags in the GET_INFO
> > input to specify how the sanitization should work.
> 
> I don’t think it’s “policy”, it’s just giving userspace the minimum
> knowledge it needs to create the vSMMU, but again no really strong
> opinion about that.

There is no single "minimum knowledge" though, it depends on what the
VMM is able to support. IMHO once you go over to the "VMM has to
ignore bits it doesn't understand" you may as well just show
everything. Then the kernel side can't be wrong.

If the kernel side can be wrong, then you are back to handshaking
policy because the kernel can't assume that all existing VMMs wil not
rely on the kernel to do the masking.

> > > But this is a UAPI. How can userspace implement that if it has no
> > > documentation, and how can it be maintained if there is no clear
> > > interface with userspace with what is expected/returned...
> > 
> > I'm not sure what you are looking for here? I don't think an entire
> > tutorial on how to build a paravirtualized vSMMU is appropriate to
> > put in comments?
> 
> Sorry, I don’t think I was clear, I meant actual documentation for
> the UAPI, as in RST files for example. If I want to support that
> in kvmtool how can I implement it? 

Well, you need thousands of lines of code in kvtool to build a vIOMMU :)

Nicolin is looking at writing something, lets see.

I think for here we should focus on the comments being succinct but
sufficient to understand what the uAPI does itself.

> > I would *really* like everyone to sit down and figure out how to
> > manage virtual device lifecycle in a single language!
> 
> Yes, just like the guest_memfd work. There has been also
> some work to unify some of the guest HVC bits:
> https://lore.kernel.org/all/20240830130150.8568-1-will@kernel.org/

I think Dan Williams is being ringleader for the PCI side effort on CC

Jason

