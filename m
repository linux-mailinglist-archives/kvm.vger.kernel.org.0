Return-Path: <kvm+bounces-25803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F18BF96AD20
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 01:55:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21A531C2436C
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 23:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F5741D79A9;
	Tue,  3 Sep 2024 23:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BZoQ8xv6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2072.outbound.protection.outlook.com [40.107.96.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DB71EBFFA;
	Tue,  3 Sep 2024 23:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725407747; cv=fail; b=nxn9iXIN5o79j8bP56CrwkD6AdmbIjz31MAAvjmdxqZDuGZ1nna1d80e2Yf3Ekt2yYwxmUJij+KQAE18cZLE5mfIxVcihC79M9GugcApiWTdYge7qiNo3BEL3/0xqdMNc1TWkCjbYaoqCFsNPQoq5HvOuqFiK56kXovpCnssqY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725407747; c=relaxed/simple;
	bh=JNOPHNph1NSgJIn7Xku/wMPVKWR9fMXiFyDhCXpx7fs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gHfVf0UlsgAbEQU+mw406J6GWt3iALer8GqKXF34kxPzNTtBUAoKNHf/Y9YUE2qd1x+PSVXVmUekMzzSupshKhoN2KaP9CMHAowDkVS2Jk6M7tfUaxGNuG1e5XeDKceKbY0SfKO/0S2hy3JqirUSF0Q+dI9vN+0XcG13PqCWOb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BZoQ8xv6; arc=fail smtp.client-ip=40.107.96.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aelOw2uUR/xzDIwpdGalGCaEDBtMQcBj/FJoO5dzC/aPeP1ttInM6XmINRGFh7kzr2gOkXEjLu+EaddXSZyk0cc6hBxhrP0A6FDAsjk/2i3h+56b7ycOeoGyxIB+zww+6M8gcOKW1bU5E4kilvBtvYzrMfItDOXXBl8IBIaaERgxajJbuo2o/Pa5WGq0lOaLCSkPD+AJ1IdaD9JuvGrbOU205Af8gu3h3e+3XNIVVjJovRuvkg0e4YdoXDNN3XnRYeA/Qq48fnKtYNQlr9iS3P13KLglg5U5Dd/ukYyaqy30DMBxN4lNr4lWjjYseAznl5hL1kLjs8ARYYctZ0ZgGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L99GWHjFsIToFLzZD+jhtC7qgIXECTVS+TnFWTDtwmU=;
 b=YuwEOnLitwolqC3TcqLHywTMRa5ZxF5mNw6FSvg6PTTHMYycIT/sNlHeM6ozZRqU0gikZ3rb9uNc6qLsA0shuJTTMGCpb/pTUk3SUJ+8VcNyh5YTOQR0ka9PfjJEZNa3hXw4NBU5hJtuwx5GR0mV1y1L/8opOZZiSiXd2wsm5N/OsTx8ru76yDMc6MTlYewyw5L8+hRysWTKGhu3inB5JQSCoSz1dBGqP7LSe4Ob5uuV45HSAFDmHQM89a9CeGvkph9SbkM3/+6Z5PMuuKNsmQkPrfeXfpG8dTDq/2ye45sN5AM1x82m4R6FurUBidjC/X1C1xTlrR89gGKBqei4gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L99GWHjFsIToFLzZD+jhtC7qgIXECTVS+TnFWTDtwmU=;
 b=BZoQ8xv62//W97gKEEMMFJ9uQ9vM2JWqyvw1O3bFASr19r5sZhYaPAj3nz8/yaS3shTSy3dyDfwv1xRkv+q94gfLKwlMiUtk0MwXF+OsEsGkrhK00bt2/R/Wy7Mgmuc9O5RRS9mqWxXberbe3e6GUlMHvFNZmZK1aOxDY+ahAzbJmkCW64eGKEg24WpVo8qJer52FsnHwYk277gXYJ/EBUwxES/GdPQsGe+kuAGtCj7Iegj7mm7aFZEHLw+PtKY3p8S1f9kkHMipfrsN6ImIZ7K31xpBKxgxTtD+uTeSCpIdOScGIAQsGn1JAzbjIeQT1V8FGtz4gofR6GM7uAxHPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CY5PR12MB6154.namprd12.prod.outlook.com (2603:10b6:930:26::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 3 Sep
 2024 23:55:41 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 23:55:33 +0000
Date: Tue, 3 Sep 2024 20:55:32 -0300
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
Message-ID: <20240903235532.GJ3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHuoDWbe54H1nhZ@google.com>
 <20240830170426.GV3773488@nvidia.com>
 <ZtWMGQAdR6sjBmer@google.com>
 <20240903003022.GF3773488@nvidia.com>
 <ZtbQMDxKZUZCGfrR@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtbQMDxKZUZCGfrR@google.com>
X-ClientProxiedBy: BN9PR03CA0720.namprd03.prod.outlook.com
 (2603:10b6:408:ef::35) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CY5PR12MB6154:EE_
X-MS-Office365-Filtering-Correlation-Id: 28705fc3-7b02-43e8-336b-08dccc73e62d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dU5KVUdWSzBHdnZmMjlYUG50MmpZNnEvS2RmTnRxaDNjRnNPbGpQL0pQYjFk?=
 =?utf-8?B?bXVCek5HOENhcFYxWDBFNGkwWG1CY3N2d3RRNGNqTHk3ZTBBMGFNMER6OXRZ?=
 =?utf-8?B?OTJFQkxBeldqdFpWdzhWNExnb0VBZFJXK2t1ZXVBR3VqK0JETDZnRmdKdVFB?=
 =?utf-8?B?RnBoMENUNWpvdG9RdTlwb3BLdDg0Y0dSNjRsc1RVUHI3dzVrOTJwem03ZGNy?=
 =?utf-8?B?WVhCcmxPSVQ5NEdrTkR3VytLNTNCL3VOYmNnNFF1bWprWnhmRFlwbFp3NUtP?=
 =?utf-8?B?WTNNTk1GZkNjNkhqQloyTllWRXJMUHZNNGxBU2RDb3hsWXVRRFhhVThIQVFO?=
 =?utf-8?B?Q0ZzUUlkazZ4TWdDRHVMc1hta3c3d21iN0pwNm0ydG9OYzV1RkIyOExTbUpt?=
 =?utf-8?B?QStSamNIbkYwMW40YW8zMVBycjJOOXQ3N3Q1eFllaUM5TXFzWUpmWU83YjlS?=
 =?utf-8?B?STEzMW9TV1ZOUXlVRms4TXRxVlNQcEg1VHNnM0kxd2IwVlBUbExNcElNTEI3?=
 =?utf-8?B?eFhEc3Q5TENhditsRjFZRGxLbk9mRVo3b05QRUlSQzZMN1oyRmU5eTJIVVR3?=
 =?utf-8?B?dExNbjBLSU5RcUkzamFQRks2ckRWclJtMGFGY1RqMGtNeVlGeEhDWlFZL256?=
 =?utf-8?B?RmpDTHN6bUhzVy9yeVJ3bmJxaHFORkU5YzlTZVVENEY0V1NxYkltN1RrUkxk?=
 =?utf-8?B?bVBPSmxUMHNUN1ZxZVhsbnBqcWJGY1RpSk9leWNybFN4RWFZUUk2UzFtQXRz?=
 =?utf-8?B?ZWQ1NHd3Wlo5cGV2VWs1Y3JNcXRtNHdqSnFQQ0IzSFF3dmR1aFBPYW5scHgr?=
 =?utf-8?B?UW5YQmR3N3JJYkpFS1NaLzRXM1JzNDdvNGtjSUZCbkRUcE9MR3h5V3VzWW9s?=
 =?utf-8?B?UUNtUDFUNEt3eUMxdnhma0lzTHJDZmwyUlBlc1NXQTJHNWRRZGxNQzlyOHpP?=
 =?utf-8?B?Z0RaVmgrTTVMZ2JYczc1QjVKOWd2RTN0QS9hb2tZOTdlNmI1SFRXT0ZSZ29R?=
 =?utf-8?B?d1lsRUdwMW5qOTlFYWZKb0srZ3hFUlkzMlUwdDdxUUpid1g1SStDRDdvaHg5?=
 =?utf-8?B?RDY5V2NxSzJIM0pkU3pIaHZPREFtYmhqSWtpMDRlSmJ5OHR3R1JlaWpQMDFn?=
 =?utf-8?B?MTJEQ3dqM1hjNWxaZkw0dzBRZVBBWkkra3ppcm40S3hSMWp2d3d3dFJSZ09w?=
 =?utf-8?B?K2R0aDBZRWt3NVNEVCtPVjhkWTI5Vk1jaVc3a2M4dXNlQXpLYXdHdFlmcGo5?=
 =?utf-8?B?ZWt5a0FVcU1oKzhkRW5WVWlyUDdERjhMZ0tEYm5JNEVGL3NjdUVqaEc1Y2x5?=
 =?utf-8?B?dlI3YlNFVE9tR2c2Vi9zV29OMlgzY2psTUY3eDdvaXNDbmlvRGl4SVFFMDdm?=
 =?utf-8?B?SW9LckR0TlNKYzk0UExBWjZVeCtRZE51T3ZLdE82S2NHNnl0cm1sK3VwVi9X?=
 =?utf-8?B?MFNHUFZyd0xWK2ZQcW50T3pGT1lQbEdxamlKenB5eitNc3ZLUE5KM0I1WjE1?=
 =?utf-8?B?aFNKY1pqS29kUzZrdE9pdEZHbWNXbFBBWVNJOU8yR3VqeU9MWDdBQXVETlQy?=
 =?utf-8?B?TVFEbTQ2bHNndE9WUExJNnMvTWJJeVNudHh1UVRUMFRQemRvWFc4algzd1BQ?=
 =?utf-8?B?emU1ejJ4WnJEYjY3QXV4cGR5UDdDNXRFVkZ0OUlhVkEvS2Q0L1lSZERwVlk2?=
 =?utf-8?B?Q0lxQUFFK3lqSGFRYzFwVW4wd0FCZERpWmJaRHZ2RUd6eG80OFVucXBMNDlM?=
 =?utf-8?B?OWVYRUZzK3k2U0xYSFJWTnh6aGhoZ1I0UXFDMURGcEsvUEF4U25FbTBlZ1pO?=
 =?utf-8?B?S2xML3B3VFRQR1I4UGxWZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0N3eUx1RDhaVy9mZytZeCtpZlFJV0NCVFYvWXlOaCtvK2t4TFZrZzJOWDg2?=
 =?utf-8?B?cDFjNVk1VkpkUkhDeS81Snhla3RlYk43bE9YVEE2eVl4a1VVTUo1bjF6Qjdz?=
 =?utf-8?B?VnZTWVRDTHZWYi8yU0dkaktqYzZqd2NzSmdWOExwaTFUUTRwYWJ4YW16YnB4?=
 =?utf-8?B?UjJNbmRYdWU4RHF5ck1PVzFWNWx1dlM1K09lQTdpTkZFaW45a0VIWHZBMDg3?=
 =?utf-8?B?UU1uMzJ4Q3JxZ0JQVHp3c0lrV1krbEhDMmt2RkloVXIxRi81T1hlMjRQQjZL?=
 =?utf-8?B?bDN1dGpFcXBZb1R0S0cyVzVSclNDWkxjbngzZWdVSzdIRGU4RkQvQ3hWaFhW?=
 =?utf-8?B?blBZYWIyTmNhcHBkNzMzdVRhQzhGMGpRVHFOWXlVZnJwUHB3Kzl2UFh0cjRT?=
 =?utf-8?B?MlBaemNHbHNWeU9lVS9jdlFsSXg0TFVHd09MTTVoY08vRUxmOTNibTJ4d3BI?=
 =?utf-8?B?SlNwamhoMS9kYzZwQjlwRnBjNEZvakFWWHJQNmthalVrcVFLemFYTTJWQkJy?=
 =?utf-8?B?N0ZCMWt1ZXUyeDFLRm11VGVMb0NEOHZKNGQxaFZVbWJ4MnFrTGp6YlVCcVFT?=
 =?utf-8?B?SlUreFBiR0FLUmxPKzhOUlVuMTNYVEJ1bmZsRnZ5WDVyWUEvWW1rRk1ZMUlq?=
 =?utf-8?B?M0xmT3JjTDNzWFYzdTBuN0FtaEJHYzJwVUZGQnEvSWFzM2tEd2o4cjZrdmxi?=
 =?utf-8?B?YmZtY3ZpNlhPUi8vTVlVckVsN0VRWnpTdU9YSWY5dURCRVNZLytFb2RCVFhK?=
 =?utf-8?B?Q1BqVW9va1BYQXdmdSs0OTZNUnBuWHZ3b25rV0x5NlRocGl3VXlRSFJiOUxz?=
 =?utf-8?B?V1BLYUFPb1lTbXZPYXVPbjJ4OVJmQ2JuSXlMQmxoYzZic1FOcTZZdDRVL0FD?=
 =?utf-8?B?ZUhPb2g3SGhFekN6Y0MwaDZSak9hU2IvcEVoM1lqVzJ0c2xralYybnJaT0x1?=
 =?utf-8?B?UlZadUV4UnQyUDFxTmJXREZKcTk0ZFU3VyttNFFsaTRxbGQxdC9aeDVBQmQv?=
 =?utf-8?B?aUZLczQ0ZFRZeDNRK3ZKZ0lCVmdkcnM2OGt1MllGejcyMldWaklraVR3S1Uw?=
 =?utf-8?B?VmJ2TzZHMWExdGN1VzI1bmpsN1QrQVBLWDlNdDdsbVl5Smk2ZlRMTVdEKzN1?=
 =?utf-8?B?aVNEM2t0RDI3NUc3eEtRUHVRbUU1UUJWMExJSlByenJrdmdUUyttTTJ1bDVy?=
 =?utf-8?B?RCtuWlNyK1Qzc2NieXY2NFFpUTJtc05RZXV2cHdWUldodVV2Qjk4QzVoL3Va?=
 =?utf-8?B?TlNCdWttYUV1NTBkV0FWdzgvNjVlUTdBdHc0UFZPSFljdlhzN3NDUVFhQzBl?=
 =?utf-8?B?SklEclN0YWQyaVgveTkxTmdGNkV1R2VxZFhSRkRMNjV6OUg2dVNZK2RQdlV0?=
 =?utf-8?B?SWxJWm1USzZtbUozcWMxYkxLVHlLUG1PT0Z0RFVVTERPVnZReGdPY1FiRUtW?=
 =?utf-8?B?NHNwTXc2V3ZSbFAzUEVaTGFTWXU0Q2htUG4zV0U3a0IxMEMvT0lHYW5hbXcx?=
 =?utf-8?B?am1FVGR1N01LdHBFYnhGZGRlQng4VzFqR3U3UWxNRmd6NUpMWkhGMW85S3JO?=
 =?utf-8?B?TTRxdlR0ZExZY3ZCYmpSZ1BjZFhzSkpnK0hPak5mbHVWRFJjdHhobEtWWmdO?=
 =?utf-8?B?WG11OVZTMk9EUUowNjJOeVEvMFM4TytudzVsRFVPbmNxeGNiZ2pPVllLd2hU?=
 =?utf-8?B?dnVXQlBrSnJMUmtQeEh3VWpLTTJLbWNKdDBpbmswSS9SeFVMU09SdDZDSUN4?=
 =?utf-8?B?WVZ0RFpqdEF4SEdzaVN4Sld2bUxtbDVQWS9IWDg4WmZoU0RoUThubEI5U1FW?=
 =?utf-8?B?R2x5bEd6ZkVxOG96Umh5cWhGYnlkem8xVXlIOS8yL1VaM0NjTkFEcmNRUmJh?=
 =?utf-8?B?T3VEdS9nL3pxMW84VDkrNVcyV3pWczRLM1ozRVRnRkQ0dC81c1RFcE1HUWlx?=
 =?utf-8?B?S1dObml0bWlnUGZxQmZxdkxjcHlDeVdkcjVkWXo0cHAvbFBhOG04NjZWRGx5?=
 =?utf-8?B?dGlkQ0lPTXk0WlE2VjFzSFBnWVRNMzRWSlFGWjBlSTR2S0QrT1BKVk5YNWtV?=
 =?utf-8?B?SUdBdytFbXFPTXR0cVVzbmVrUmx3d3Ixc3NnMmNDUGhwWXo4aFR3UExmOW9I?=
 =?utf-8?Q?ouiV8PgFdLdsoVT2yrhwPDEyM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28705fc3-7b02-43e8-336b-08dccc73e62d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 23:55:33.6056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ntwhNvzP+BBLitxsZJ1rfG7+C2aNR0NintNZhdNswKK14x9ogLqIUHwANN+s24Ro
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6154

On Tue, Sep 03, 2024 at 09:00:32AM +0000, Mostafa Saleh wrote:
> On Mon, Sep 02, 2024 at 09:30:22PM -0300, Jason Gunthorpe wrote:
> > On Mon, Sep 02, 2024 at 09:57:45AM +0000, Mostafa Saleh wrote:
> > > > > 2) Is there a reason the UAPI is designed this way?
> > > > > The way I imagined this, is that userspace will pass the pointer to the CD
> > > > > (+ format) not the STE (or part of it).
> > > > 
> > > > Yes, we need more information from the STE than just that. EATS and
> > > > STALL for instance. And the cachability below. Who knows what else in
> > > > the future.
> > > 
> > > But for example if that was extended later, how can user space know
> > > which fields are allowed and which are not?
> > 
> > Changes the vSTE rules that require userspace being aware would have
> > to be signaled in the GET_INFO answer. This is the same process no
> > matter how you encode the STE bits in the structure.
>
> How? 

--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -504,6 +504,11 @@ struct iommu_hw_info_vtd {
        __aligned_u64 ecap_reg;
 };
 
+enum {
+       /* The kernel understand field NEW in the STE */
+       IOMMU_HW_INFO_ARM_SMMUV3_VSTE_NEW = 1 << 0,
+};
+
 /**
  * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
  *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
@@ -514,6 +519,7 @@ struct iommu_hw_info_vtd {
  * @iidr: Information about the implementation and implementer of ARM SMMU,
  *        and architecture version supported
  * @aidr: ARM SMMU architecture version
+ * @kernel_capabilities: Bitmask of IOMMU_HW_INFO_ARM_SMMUV3_*
  *
  * For the details of @idr, @iidr and @aidr, please refer to the chapters
  * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
@@ -535,6 +541,7 @@ struct iommu_hw_info_arm_smmuv3 {
        __u32 idr[6];
        __u32 iidr;
        __u32 aidr;
+       __u32 kernel_capabilities;
 };
 
 /**

For example. There are all sorts of rules about 0 filling and things
that make this work trivially for the userspace.

> And why changing that in the future is not a problem as
> sanitising IDRs?

Reporting a static kernel capability through GET_INFO output is
easier/saner than providing some kind of policy flags in the GET_INFO
input to specify how the sanitization should work.

> > This confirmation of kernel support would then be reflected in the
> > vIDRs to the VM and the VM could know to set the extended bits.
> > 
> > Otherwise setting an invalidate vSTE will fail the ioctl, the VMM can
> > log the event, generate an event and install an abort vSTE.
> > 
> > > > Overall this sort of direct transparency is how I prefer to see these
> > > > kinds of iommufd HW specific interfaces designed. From a lot of
> > > > experience here, arbitary marshall/unmarshall is often an
> > > > antipattern :)
> > > 
> > > Is there any documentation for the (proposed) SMMUv3 UAPI for IOMMUFD?
> > 
> > Just the comments in this series?
> 
> But this is a UAPI. How can userspace implement that if it has no
> documentation, and how can it be maintained if there is no clear
> interface with userspace with what is expected/returned...

I'm not sure what you are looking for here? I don't think an entire
tutorial on how to build a paravirtualized vSMMU is appropriate to
put in comments?

The behavior of the vSTE processing as a single feature should be
understandable, and I think it is from the comments and code. If it
isn't, lets improve that.

There is definitely a jump from knowing how these point items work to
knowing how to build a para virtualized vSMMU in your VMM. This is
likely a gap of thousands of lines of code in userspace :\

> But we have a different model, with virtio-iommu, it typically presents
> the device to the VM and on the backend it calls VFIO MAP/UNMAP.

I thought pkvm's model was also map/unmap - so it could suppor HW
without nesting?

> Although technically we can have virtio-iommu in the hypervisor (EL2),
> that is a lot of complexit and increase in the TCB of pKVM.

That is too bad, it would be nice to not have to do everything new
from scratch to just get to the same outcome. :(

> I haven’t been keeping up with iommufd lately, I will try to spend more
> time on that in the future.
> But my idea is that we would create an IOMMUFD, attach it to a device and then
> through some extra IOCTLs, we can configure some “virtual” topology for it which
> then relies on KVM, again this is very early, and we need to support pKVM IOMMUs
> in the host first (I plan to send v2 RFC soon for that)

Most likely your needs here will match the needs of the confidential
compute people which are basically doing that same stuf. The way pKVM
wants to operate looks really similar to me to how the confidential
compute stuff wants to work where the VMM is untrusted and operations
are delegated to some kind of secure world.

So, for instance, AMD recently posted patches about how they would
create vPCI devices in their secure world, and there are various
things in the works for secure IOMMUs and so forth all with the
intention of not trusting the VMM, or permitting the VMM to compromise
the VM.

I would *really* like everyone to sit down and figure out how to
manage virtual device lifecycle in a single language!

> > I haven't heard if someone is going to KVM forum to talk about
> > vSMMUv3? Eric? Nicolin do you know?
> 
> I see, I won’t be in KVM forum, but I plan to attend LPC, we can discuss
> further there if people are interested.

Sure, definately, look forward to meeting you!

Jason

