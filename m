Return-Path: <kvm+bounces-25693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB89E969090
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 02:06:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C4EB1F2352B
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 00:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 227F91877;
	Tue,  3 Sep 2024 00:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TP8b737z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820A236C;
	Tue,  3 Sep 2024 00:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725321953; cv=fail; b=qQdrtt2yydl+WeO0+hxwYnDEJcepkX6ZevlUnbiTpj2fA2Q+2YVknNNxymGVzIzLbHtIcpuUBZ5XiN8AKNfa8BnXFCH6fppbxN+FA9UIz091m9D7+XC9OXDgrRuTMy3QTl+UKGxp01rUbWJZCZTyaSuP+VSx/1KOwX61Q4jOGs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725321953; c=relaxed/simple;
	bh=5G+wyvr+uoJFrN/7/9zaV8HAlcZHUNkxxnAwW8TxsgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hhlvhZ+884gTyTKU4ci5TUV3jxYHkaJRjimNk7C6fNg1CzFKR54uzG6wzqEpW1tDpSVoHLJh2xogidxrrmj+h1hn35e+FoC1NNCGhL8iPWsM/FKBDW4jks4sjsTWXAUw2K0bwMFbD1pGKx3tFX3wn66U5AIsv0ohIIcgSHaaXIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TP8b737z; arc=fail smtp.client-ip=40.107.92.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IyoLem5W8xlyugefpCUhXdAVmGJ0to7sEDvvnVNE65hhjagKQZWkGiUan90z3qKtchKetke7Ng46jEJrlo0oY3HG/qX3VwoVXc/5+GAo3CyWxqahV/7q+t/aUfqmz5Q3taW1oKZyZ7ife5y0vRDS9uUt4cpVstqnqenKvslLcQ/rYaj+QRpNLsFcUAtWuZKNgeO0vhmgup4iop690y4ZPcSIpuvP4rKexvm5RdVLv6eRim1oeFqfHcSLkF172MOQ/WeskJvOg56yYLFuAMWyp5mUbB4xLiLFBStCUjznHb+cz4Pdq9Fou9XfLtIuJ8bJd48j2pjDS4/vZdX+BTki+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fyv/F8zIO0g0ofa8qGDQQXHFhZXD6q+aegY6yxn2kJE=;
 b=AjluHqWdzVOnoUGWLNWkOOCyTCnZ8LcLVC2ISCoYzRyLOsCx0B7i4iHTj4Dz1b4YTsE7TRMENmlBlHLI/Byv2c9/XbZyQwP5YhgSOJGvqUt6N+luqHlYxFNGhXITeK0iukdtKJur2Raf5blQ9ouLDSgPJ9rXRBFHNFpbhhMCep2X7yAlM3cF7LIKiecgvDukX+FowUN3EbSRaKmIsvaO4+oE9eotphgu+QeJgtXRV+oOcg3F7hkopT7Nh5ke9bHU9zo3IN0KqFjP74oBy0ABvuAQTj6RM7jOEPYAmyznoWl626LD79PQd9Ryoyw6SWOVGPfVFGAOmHvsUQZADtLy6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fyv/F8zIO0g0ofa8qGDQQXHFhZXD6q+aegY6yxn2kJE=;
 b=TP8b737z3Wnl9G4Sc9FpPVp359t/N1VKrJ3TPLLi7kQsi+3LQxN/OHkq7cbaZ+++k/EdOkLtq3c6Y9PQT10vi1Gs4KVxtrQ0ww04FtxlMiPwAr2Em4Z8MTRrlV2vAw58kaF2Xi+SYqUh7htTwrjz66bQe4885NZLfmyntusrpRa6NcE5QOka0CzkBhWoJmblfFFsg1emOzljAFYuNMHYxfPcuDMYd/hhJOfjBsN6zpgtLmKEYhnheyh6vNUZY1Q+x/XTn8rL/qKF+PoYbHbZbHjRQzguEML361Doz90Oq4wWtnkWAex/U22mEwrgkSF0axapQRpX+iEwxNBKO5Z8HA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SJ2PR12MB8882.namprd12.prod.outlook.com (2603:10b6:a03:537::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Tue, 3 Sep
 2024 00:05:47 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 00:05:47 +0000
Date: Mon, 2 Sep 2024 21:05:46 -0300
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
Message-ID: <20240903000546.GD3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHhdj6RAKACBCUG@google.com>
 <20240830164019.GU3773488@nvidia.com>
 <ZtWFkR0eSRM4ogJL@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtWFkR0eSRM4ogJL@google.com>
X-ClientProxiedBy: BN9PR03CA0341.namprd03.prod.outlook.com
 (2603:10b6:408:f6::16) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SJ2PR12MB8882:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c1941f2-60e2-4416-a0ba-08dccbac29cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NEpXbC9zQnhkN2thcGJQRTVheUIwQ2VjeXQraGU2UFRXRlVtRTRlYWxDVHBa?=
 =?utf-8?B?dTRiL0NBcHQrK1FXWEt0TGxha29UNW15MUtNdWZmKzhLRzQyU3hFelMrT3Jp?=
 =?utf-8?B?UHlOcEFMQTByeThPVU04ZE1pTFNKV1lzSmVCVTB1UFBORXpwcit6cTYyUHpm?=
 =?utf-8?B?aXlpcWcyL2VGTGttTit0ZUUvcWsvc1NWbUFwOTJLVVVLd1pwbyt3V3BseDVQ?=
 =?utf-8?B?enM5Y2ZWc0c3SEY5a1IzMWN3WERhME1aQ3pwTnlZWEdJa3Qvc2daK3BQNTVF?=
 =?utf-8?B?b01CcDBsYlBRR3JVSmxheDVrbHZja3UrekF6UjNEMmpucEVSZHpBRUpiYkZR?=
 =?utf-8?B?TmhTV1VTV1pBS0x1amxZUkxONDh3c2U4Tmg0TjVDeUlxN2sxTnJoN3RXTWZJ?=
 =?utf-8?B?aklJZGJETVJtdzhUVm91WTVXSVdqd0doaTRaWldyeGVTZWpWUmdEcG90Z3RI?=
 =?utf-8?B?TFlGQk4rNStpdm54Tk1FMlRoWXNSOHFzaWVkbFFMZExtWWFtaUJLeEZnR3N2?=
 =?utf-8?B?bk8rdW1uaFdGQklIOGphOWl6am1xQ0dKNjB2SUwrTDVLRi96RkZ3ZUJoV2Rr?=
 =?utf-8?B?QVJTU0UrU1B6Y2N5M3Q3MFByWXc2OW9YTWJsZXM0Y3BLU0o2dHdneXVJOUk1?=
 =?utf-8?B?QkpGVy9mWE4rQ3c5OU9vTldwc2xpS1dEb2RRM251QTRSaDlBcVZDTEJ5UThT?=
 =?utf-8?B?RHE2WFdkUWFscCtsa1hkY1JOMlIxS3M3bWpNa0FWdnRkUVVZK0VJRTZOaStw?=
 =?utf-8?B?SmhoK3RsZmtpWUo2bkRSVHlVMDlOOExDOVRVbHhGWWtEc3ZudFRhL05pWUlG?=
 =?utf-8?B?VUdWKzZqTzgwTVE1L3VzczJtMDhsdEhaT1JDTmpXaUpRZnJ0Ymo1Zm5XeWtw?=
 =?utf-8?B?R2dMSXo5alkyeDBOZk9heWt1bTMweHBMemxIaUNqTTQ5RmprOXRtOU11czNr?=
 =?utf-8?B?Y0RLZ1drdjZmUVJZMERlbi9EY0EvRjNtNWlRemJwMEZxdXFHVE9qbGkrSklL?=
 =?utf-8?B?ZHJod24yd21zS3pxV1NFZXFWdHUyWG1LWlJkT2lUVUNsTk92d2QrMXB4MUZM?=
 =?utf-8?B?U2w0MWUxRDllMHF1ZWNxeFZ5bGRmck9FaDdaWjN1UlFqSDJIQW1rTnFPTUV6?=
 =?utf-8?B?NUtEUUZsWjNuL1lsZ2k4c280TWFudXNPY0V0S2dFb2RCQUtLZURwSG9rbE5s?=
 =?utf-8?B?eDdwK2NOYS9XMklSdSthUzNydFROY2FhYmpONkR6U1h1RFhYbkNMTXMwOUxV?=
 =?utf-8?B?SEh6OU5rekZ6aW5Fdng3R1hRb25qa3VBWWM1bWpRazhZczVvZ0daNmtMWFRk?=
 =?utf-8?B?UGg2TExXVUYzNE96R3I1cmFJR3lQRmJ6cDNmVGt1REVIbUd0aGR0aVJmMXJu?=
 =?utf-8?B?bG92MXlPYVdldW1JeVhEWDlkZjF6U21FV2lXYkxRZ0JaU2JCczYveUk5bWFr?=
 =?utf-8?B?U3NuVXJzNC9JK2trQy9BMXQwckRqaDNVMTY1TWY5YW5ibmJoQitDYlduWXlz?=
 =?utf-8?B?NE1OeGRwT0kybElvL2RraUdWYnpWV1VjWkl5R1JmbVp4ZU1FM3k3MUNOVERC?=
 =?utf-8?B?YUE0Qzd0cll6NkVwYzY3YW9SUGtrUyt2N0dJaWE1ZXVUT1FQQ3NTUFpYa2o2?=
 =?utf-8?B?VjVaME1WVGZtd0ZXdWlwaFRhZWsvTmU1QWZlakUrRGpZWFY2eEpQTVpiSjBq?=
 =?utf-8?B?L2tnL041a1lYTUJOQUs1WGlWVlVRcXIwdE1sZVpRcDRhblozcnVvSzFVa3BJ?=
 =?utf-8?B?V3J0citwdmczNFc2Z2NCSE01R0VVaGxDdVRIOXpCYlhUb1l4RGpRTUcyR1ps?=
 =?utf-8?B?cFZqbG42R2lOSEtxOGpUUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUx4aGtYbzBXNmdZT2tSRVpla2RmdEJyQm5WU2Z3NXF2RTBVbGlYazV5MUJ2?=
 =?utf-8?B?R0Z5Y21PNGlSdGRNUHExcUl6WGw5WlRaaE1Xc2xIdGhhR1ZpcktpeldVODJE?=
 =?utf-8?B?R1ZHOC85MFBlSmdONjZkb0VQODd4WWZ2ZFozVjFuRGhZZ2pEMGN2K05IbHFR?=
 =?utf-8?B?U3NkU1RwMllZcU5lR3RmdTI4Sk9oL1lzKzVrQW5DaHc0SkxscnVjZ0FqUmRD?=
 =?utf-8?B?eG5GWFl1aDRIV09VVFNrdllKNVRNR1lQNEoySzUyNThGNlc2VFY1QXF3dXds?=
 =?utf-8?B?ck1Ddi9ZM2dySm4yakV3N2pkZ2hDOXNwMENDSjE3T1hXSmJZcHVuNndyYzFI?=
 =?utf-8?B?VU5qZ2N4TG1NY2pHWE1FRE51cDdpTElkNGNFQ2lNUFc2d21PNDZIWkNXM1px?=
 =?utf-8?B?ZEdDNHEra2hldXlFNzl5cHh1RnRlamlwV0d6SnBOSUQ3RG1obU0vS3hESmZo?=
 =?utf-8?B?TTBCamVlZFpwZ3pVS29STXcrWmlaVnRnR0JsQ0VuaWo2S0gvbU5JUU85M3Rm?=
 =?utf-8?B?c0dDS0lvanc3RGRuZXl5MGN5a1E0ZnN1TFJhSXlacDVBSE8wMXU3dW1BekJp?=
 =?utf-8?B?RkhUMEdoQ1FqcDhTRFE4cDBBMmRoQnpmOVdRdSs3T3BsRlNsTkZXb2RKR2py?=
 =?utf-8?B?YjQvMXVDSTA5b0RUKzJOTWZXU1M3dGgzMjZNM2xXSXl1cWRJdjZ6S2lXMW1t?=
 =?utf-8?B?M3U0NFgrQWdUZ3R5T1NLZ0VxZ1hweXdaVnI4Y3ZVUitJNXR4UllCTkI1RXI0?=
 =?utf-8?B?NmkxYVVqN2ZIVnlVM3hvZGhkanlaRFUyTkt2eXJ1T1RBNTlOQi9sNjkvRkRl?=
 =?utf-8?B?LzJaajZzTHRvaGVEVFZWdTNRanVxTW1UdFVTNnh3VGJVampaczY1NVdvZEhi?=
 =?utf-8?B?eXpxMldJS2F6bUhxaTNCUTRERk5HS3hVOVJiMnd2cU9JV3NzbVY4eG9UK1E2?=
 =?utf-8?B?ZVZ0ZTIwSHY4ZmlGZmZzRWRnR3c2REhsdU1tRUJGTW9CYUI0enVvYzNCZXRD?=
 =?utf-8?B?K2lqT0Z6dHpVNWJPRjJFYlBYRkFabTRJT1ZYRWZNU0VGYWNkdytOMVFJY01n?=
 =?utf-8?B?QVRTN0NyQUNBVHpSMXBDaS8wWUdmTG9xVjVnem56R0lLSjV0eHo2UngzUUNO?=
 =?utf-8?B?TTZSZFhmRXZ5N2xaR2t3eHNDRVZoSWtzeUc0aEJKWndMVTh6L3BIVXM1ditW?=
 =?utf-8?B?MGJ1RlgyWVA5TWk5Y25RZXNYWHVmUjRYT3pOTUFsN1Y4TkJMWkh5L2NOckJW?=
 =?utf-8?B?VzNwaXM4TXgvRVA0ME1mZHF5MXNieXJpRUZ0ZTBZeHlFSWpTRDNRakJhZGJn?=
 =?utf-8?B?czNUV3paU1ZlUGlIdnU5YVhTelJQTEVzTjZrWjN2b3V3UmxYRUQ0dzhDZ3A4?=
 =?utf-8?B?Q1E5bVBJNkRhc0ZWamNrQVFseW5Jb3FrQ2xWZFZ6NVdCSWcwV2tVTmtpNms2?=
 =?utf-8?B?Q3NYOS9WeEdRMkhWcUhuRkgrTCt3SlF1UEhMeDV0S2FEQzRCbGhpUWN4eWgx?=
 =?utf-8?B?Z0RaUE5ib1IwR3daN3A1RFdjN2tQa1BqR1Blb2tLRWhmWlNuNzFkYUFUZklq?=
 =?utf-8?B?OXo2WjBFVjFCN08rRGVwb3RFYlowRERhVFpHakFGTWdvSS9wcjhOa3JtSElC?=
 =?utf-8?B?QjRMWXNWV21kakRSWkNtd1E3N24zUlR6UWlueXBJRTl5VDA1blF1dlQ2MW5H?=
 =?utf-8?B?TGludHFWU3ZQRDd6dHZWZFNCelk1SXdVamxvbU5OVWZzZW54QUdMUHBnUWVW?=
 =?utf-8?B?ZWRVK1Y1WHM3d1pva0U1aTVJWmNJVkptV1orRzk1QzlhaWswMCtmRVliZGE2?=
 =?utf-8?B?eDF5WDF5blVDZ0lNdGRzU09QUGlyZHBzN1hzajRIdE9CZ0tHeVlJSEIzMkRY?=
 =?utf-8?B?Y1JqQm4wQWNTVDZPMFJ5VGF1c0pxNGFiUkVtYUt0cnJ4ZHlOU2FVNG5XZnBR?=
 =?utf-8?B?T2RGY1gweXUwNlN5UGkrc0xZd3h0VHRzL05wOXg2RkhBQWIxYVBHTXAraE5R?=
 =?utf-8?B?WkJPZ0RGbitvWnM0K1Y2aGE0QVhhRmFCZlVWMVN5ZUFSZVVCdU9uR3JJMkhu?=
 =?utf-8?B?QURVWjlEaFkxbGFhdG9EZFZyUDY5R2JCNnV6VDlPUEdzRXM2RUc3RHJ2U0l6?=
 =?utf-8?Q?fI4ZnLphDV9AK0Ex35O8W+rB+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c1941f2-60e2-4416-a0ba-08dccbac29cb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 00:05:47.6931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6GGQ7VB3RKUrC0lbhiOtBAyNiFkxR3u/dFPyQMTv5MPesj2Ju8BWh6X8xmMIB3ey
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8882

On Mon, Sep 02, 2024 at 09:29:53AM +0000, Mostafa Saleh wrote:
> On Fri, Aug 30, 2024 at 01:40:19PM -0300, Jason Gunthorpe wrote:
> > On Fri, Aug 30, 2024 at 03:12:54PM +0000, Mostafa Saleh wrote:
> > > > +	/*
> > > > +	 * If for some reason the HW does not support DMA coherency then using
> > > > +	 * S2FWB won't work. This will also disable nesting support.
> > > > +	 */
> > > > +	if (FIELD_GET(IDR3_FWB, reg) &&
> > > > +	    (smmu->features & ARM_SMMU_FEAT_COHERENCY))
> > > > +		smmu->features |= ARM_SMMU_FEAT_S2FWB;
> > > I think that’s for the SMMU coherency which in theory is not related to the
> > > master which FWB overrides, so this check is not correct.
> > 
> > Yes, I agree, in theory.
> > 
> > However the driver today already links them together:
> > 
> > 	case IOMMU_CAP_CACHE_COHERENCY:
> > 		/* Assume that a coherent TCU implies coherent TBUs */
> > 		return master->smmu->features & ARM_SMMU_FEAT_COHERENCY;
> > 
> > So this hunk was a continuation of that design.
> > 
> > > What I meant in the previous thread that we should set FWB only for coherent
> > > masters as (in attach s2):
> > > 	if (smmu->features & ARM_SMMU_FEAT_S2FWB && dev_is_dma_coherent(master->dev)
> > > 		// set S2FWB in STE
> > 
> > I think as I explained in that thread, it is not really correct
> > either. There is no reason to block using S2FWB for non-coherent
> > masters that are not used with VFIO. The page table will still place
> > the correct memattr according to the IOMMU_CACHE flag, S2FWB just
> > slightly changes the encoding.
> 
> It’s not just the encoding that changes, as
> - Without FWB, stage-2 combine attributes
> - While with FWB, it overrides them.

You mean there is some incomming attribute in the transaction
(obviously not talking PCI here) and S2FWB combines with that?

> So a cacheable mapping in stage-2 can lead to a non-cacheable
> (or with different cachableitiy attributes) transaction based on the
> input. I am not sure though if there is such case in the kernel.

If the kernel supplies IOMMU_CACHE then the kernel also skips all the
cache flushing. So it would be a functional problem if combining was
causing a non-cachable access through a IOMMU_CACHE S2 already. The
DMA API would fail if that was the case.

> > If anything should be changed then it would be the above
> > IOMMU_CAP_CACHE_COHERENCY test, and I don't know if
> > dev_is_dma_coherent() would be correct there, or if it should do some
> > ACPI inspection or what.
> 
> I agree, I believe that this assumption is not accurate, I am not sure
> what is the right approach here, but in concept I think we shouldn’t
> enable FWB for non-coherent devices (using dev_is_dma_coherent() or
> other check)

The DMA API requires that the cachability rules it sets via
IOMMU_CACHE are followed. In this way the stricter behavior of S2FWB
is a benefit, not a draw back.

I'm still not seeing a problm here??

Jason

