Return-Path: <kvm+bounces-25890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C66E396C1B8
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 17:05:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0789B29B69
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 15:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B0A1D88D0;
	Wed,  4 Sep 2024 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j7g3gB95"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB2D1DA2FE;
	Wed,  4 Sep 2024 15:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725462027; cv=fail; b=rfhuJIQW8CHQ+fJg9sf+Pf9wtCARtEp4B8ysceXCgppETpaLJi1mz9Sb9aE4iOccDtPJ746pbARAMSyt332JOfXDxn1F9BgqRjmoOE+k1RG/D2jgYhda9oiuqTxl9XK383fdY77oTFmVCtX/PfJnvwT6RZgqbp+WzjOlWhNwrz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725462027; c=relaxed/simple;
	bh=fAnYm4mCU0Rkgw4c9WsygQGODo6wZAjdxDqw+NJkMtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PqsFqS/7+L3dZwSkp6jGp6CrXX7yL0VkIJCTXBY5IBr8X4ZZEPeust7bTXwMXPDWg9ptJNq8mm+dvgffWxSSG1RyobTuy5wiypPBKmJ3VFWzg0XScYEPPqeNXckTKE3R3cIoc7lScOLy3S3uWyCQWoWjEKgZuiVKyo0FyBS7f4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j7g3gB95; arc=fail smtp.client-ip=40.107.237.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HML9Hw2eoIIrx6UQyWyvr4C0GcPZS0NyN1OZGy9mQRgGjpbYA2/886lJVR7K7gQn6oPX8SdZjbJ4/rn6de5HphMZHNmT5Jib1AvBLxs4zDyfBZcnWaRD/LprUl5CYKtbYDKyAg9ol55oELS5gS3CmTyw2czykgJCdtQ30r/oomP+ypgkSn8y2ah/1rFuPlV4MdpCOUKYZ1XdjZsZJFQAZatV6+Tjj2+9LeTN9kQFcoRto/pdTw5HBIny8wW459tpbkwJbW2NNsqerqrLtK12ME1Ts9UyqWbLL8TsWTn/8Klaq8NScs6BgW6sGNOwFwAEY9qu0XywzdGmzDXfIcq3sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XmYch1hvL3yG63Lsk2BIIcOBg+wKzHbf9ioN4O7U2vA=;
 b=oWIX4duHQESWjg0eV9RA40Pbdqo+nCKmozVIxkMImWumlj9S9BfGGqN4m+i/mRv/9ie6ZfF1SRR6GAIHJg/t3o7AxueIN1YI3phe/6Enkfd8Igub9n/Rc/jF1ZmW6hxA05GtU3+Pky+fCO35zTwBsIgDdMug16YlrA5pJhjORB4EAXyiEQyW2+oqIxsvUe5qaoP9cOVXguatSLmEXHcR71yS4U12fxThujthWdgOITMLU0npXGIr4J4iiN39BJPvqNgvP018HjOOnnncfWt9VmuFZVowpTxSVTNRwTYwfan/OP4rJHHYtC2j/0D/sV8zOCjoGtIYlE5WcqpsGatOlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmYch1hvL3yG63Lsk2BIIcOBg+wKzHbf9ioN4O7U2vA=;
 b=j7g3gB95rDLsmMDMTW0K2VzPQZ+r7+PDyEJ9fV7wxkoFfjSSQcTVgC0WZmP2F2oXRNX5zUM/P/SbXz5sD6iHqlWvLzhlt5BD30TOCI577RfqlzlUEzfL9dWsUgrFau3GSOd3KNnkJLYOj3uLBDStkAgjnO0wEE+/ERC/+1Uy7gV7ukAhHkBdjekC4lKbWj/Zve6FX74bPXf0LenHTc7a+133xE07HPJF6ZJXHeIkHLc96MEn6yvoVCo5CEesOWA913CjFPaHFLjfkJd0Jn5fZZcC2J1rIZA2WKWAqQTn3TudWLILVw7G8WZQNsOA76KQZ5T7DHe/UXPX0mxfVOLNGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH0PR12MB7958.namprd12.prod.outlook.com (2603:10b6:510:285::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Wed, 4 Sep
 2024 15:00:17 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 15:00:16 +0000
Date: Wed, 4 Sep 2024 12:00:15 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>,
	"Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
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
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <20240904150015.GH3915968@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <85aa5e8eb6f243fd9df754fdc96471b8@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85aa5e8eb6f243fd9df754fdc96471b8@huawei.com>
X-ClientProxiedBy: BN6PR17CA0052.namprd17.prod.outlook.com
 (2603:10b6:405:75::41) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH0PR12MB7958:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ce6ab47-e806-4b1b-6055-08dcccf24979
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6HT/FDct1N24tTmvjBvVR1NE+fdlOiOrSfXbMtkXnkuILsXtPAH+mw3q9stD?=
 =?us-ascii?Q?+U4A4PO/WAQOIKEQAe0jGrcVTte3/baE12I2fYDXThKttvYpaauolAmOc+0b?=
 =?us-ascii?Q?5eFqJ+nX9RGscRGZIYs1rpe1+wPL1J0V3nFv01UxGL1HoJDyRlf4jUsPdrE6?=
 =?us-ascii?Q?G4E9DnsuwM0mGKwoSi8f+JubwcKKBsBQAbaSuzKmTNDAHbLXp8FqfPnaE6ou?=
 =?us-ascii?Q?YnFfMOWGk3YC1kkju8CfBE81c7/70ckjQ0Jty7gsj14ckXuOTUG0+rVvRbTG?=
 =?us-ascii?Q?eiF+UqmQed/JNbLALHEfe31pCp2o3/a4LZNGRrI5YJYy2NW5dnJb1tQuIgnN?=
 =?us-ascii?Q?Aad+mENXSjpfUiVF3QSl4TFqATdnvLQFwRN7oezSByIpOZIQgt6d9JDQ7/Wv?=
 =?us-ascii?Q?632qtPRvqT0xNym6vwUWiCkC2jHIwtbluCbJxTEED1diGlsleNmgYzPXU8eO?=
 =?us-ascii?Q?TotxVv+my7Msiy3lra7XWNrhtn5qpYVVSZA3DFDqe9VXCw9OmP8UwnVZzfzI?=
 =?us-ascii?Q?EkHN4YRpytRLJFHMv1DUpP/gbNQ9aVpAwLZzKNWS2mRH9MaerqH1dBjVue94?=
 =?us-ascii?Q?rvyH/YESI/Kzx7pVp6zGzjaZrENN2YOjKlT2aFr1s9IswAff4bxFEvd8b6m9?=
 =?us-ascii?Q?PDsglD5UH+xGxQ1C8Bj7ACOLX7J10PMmsFtIPvi3y+AuCOgHu0APDyPcN1+a?=
 =?us-ascii?Q?dl85Pu5YkAL/cXijri2QKjpbuOabWJ3HF0EkVik5XiCOA4MRwWT8ftX2g4AW?=
 =?us-ascii?Q?snVgiCL2b5R0WlZLLNusB+FDbPGaPFJWT+qnDFoYz29RwCNEQWqu0WHpS100?=
 =?us-ascii?Q?zC66mSpyb7eK/49cavwDDv7RWtV+OLUAnUTTBsSW6Elrr5lVa3AuPWp6t9u2?=
 =?us-ascii?Q?39pkVuyBnOFA4U1GzTOKblx2OM80F+z+Otql1P81iPKf53TV4Ua/uKkIGbYi?=
 =?us-ascii?Q?vFpihBbVc4Tm7OuRpCZKs0bvwPZ23BjN6630cp666TkxWq8Rsutf6rTz08sP?=
 =?us-ascii?Q?7q4PiVTaf6kon1nhCU21ozDfdH3etS1jG9GSTgIsN5A69civFFLIwLQt85fT?=
 =?us-ascii?Q?zGIZBSp10WjmIQsQUDSluMWxEfFCcOvNZy5bstJEKk5qvVlrmWx4tZrXhLQy?=
 =?us-ascii?Q?EZC12SYni03KLvRnRXmJCw9PtcrUomQ+o6GyGnA6NyUVd3loMEiPBQrFZLu0?=
 =?us-ascii?Q?yBvPE56nQA4StJG/VrBnM7fos+wZjDPgfGNE7ncSSOTd4uLjKRYpx/RhqWqH?=
 =?us-ascii?Q?kFXEMoYsi5HuBOsetEpeSiya3OlnsyhbfM4Fpgw+OS49h0vJoaA6DaEiFjZB?=
 =?us-ascii?Q?B1/vyhcpaaGGZNojadl6zFteSQCCB+IlOEbldT7m3NwkMg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AwmFEvzwf8/4idZkaNTYT3u1rM9Nzo2ccJe0uMIpwwsmSHJt17woNpyQ/eNJ?=
 =?us-ascii?Q?CpR0nWf2TTIBrNdGtIqJROdFEoqEg5Z7omJi2IzEaRyoOW0aul4L1x4U8qHQ?=
 =?us-ascii?Q?rrzUPyRBXPv7P72w3WqxSfXUWpt8FROwXhGFYz/kT+n7Ts0Tu5r46InXhc3x?=
 =?us-ascii?Q?d/YKiuqEQ9uqW8DvTntSCf3WVISSSbBsP6mEX5MO2CamljNdIMbgK6Nhj7yb?=
 =?us-ascii?Q?yB9adH1KAtKH3j3/9y50nzNiBRpTpPeSVGbhxr+KpQefirUNsc/QJhjRKPrq?=
 =?us-ascii?Q?YWWqloCk17l4ETxlxZ23swC8+jNFVulf+LHNOmkGk1uIcUOMm1WIDMVf42Xj?=
 =?us-ascii?Q?lq0I/xTCGXPakC4Zp69Ogg1Jd58IH9H9S8gRcwZztbY1ehqsuIGYKrPmHhW4?=
 =?us-ascii?Q?trlbxmAnstWFKxMBHdJLD0WUYYBe8osHmJ9t7P6r4cTAhh/v4zwr3UWcITe5?=
 =?us-ascii?Q?ojlXzv32myxNvpN48gL8/zcXnRP38I2cu7Ue/Kvac2mQXBBQnavbRuN1EMhc?=
 =?us-ascii?Q?2Wd4c/p9Zx4RzGTYU4cCsMECrYklA0FYP0SPhItOSjON/aFuTxJJED5Dvv6F?=
 =?us-ascii?Q?RJYgCttwyod1j70tVc7KiTPhNhD7x1/GGrD+VHFSjoBYhJgpibxzK7EzbuS4?=
 =?us-ascii?Q?GWMWAaZbPV42oQKomFEF/rdji25qN1/46/2qEmccMKJF2D9x0y3Ij9x29OGx?=
 =?us-ascii?Q?WpSew8B3i9qcUlquCgeltPvewT6UcISqLa20vmc8ULkjMi/nG98+Po52pw4T?=
 =?us-ascii?Q?PxNJQrnU3xhYD9r+CBTOmc9C1OaPIbxndIAcnqU3WEyoSBa2XuWveH24I3/4?=
 =?us-ascii?Q?eHSG0Os6zIdDl72jMLMa1AUE/mVBFK20YsVYJioggnZN4uK3GN+rBxR/FGMG?=
 =?us-ascii?Q?yXL+NYdY3CbtcSOdAU0PoYTCDu9p9Wq3spneqtAkyC5LhvB7poPtmwMY97w3?=
 =?us-ascii?Q?h+vvbYYf531Ho+dSiphUTvwp6jULupp2s1ZBOW7xgNqGatmi70wEZslB/nUz?=
 =?us-ascii?Q?3CeBRFVey982qP06HRmIipiCstCXfMUuybNZscXLVCq4oIBIxQZM90AnN5vf?=
 =?us-ascii?Q?R03ynV2mgD9lfIiEAowhIpOId701G29EHJ6NSAHy+ke+snRtCTpKrzSkIz/f?=
 =?us-ascii?Q?lZYh3gLamtB4pmIvmbXv93Rm+F7lwvo02kfR5K4lajA3I3nZpBc9xIFrcwPc?=
 =?us-ascii?Q?Hb+iYKVU2MepKa5gLgtaowBUI85w1T6fOIWDC32BxK8MVADqsU0BDqOWLtOT?=
 =?us-ascii?Q?P+hupDf12E2PT1/qzYziMdxLoODfRFPmy6aDi0ywRmZbgsh01Gje3X8i6MgJ?=
 =?us-ascii?Q?NCWoPLVw2LePTz4H8BMSUek62vrVdzU8sgN/cQUUGKRgOuArFppTyUcOZXQP?=
 =?us-ascii?Q?7iHNsAuI+RJP2Rshg4jzW3vQU+SjSbPMvEpO7hyTg/8rOKE1k/6kzz0RlNJd?=
 =?us-ascii?Q?O5xY+Wluu/452ISPwSwrPOZ4lVZHf7qfYUZrBlECOroEKsCC9iJxH7IYUdd+?=
 =?us-ascii?Q?Ne6wxxXgrrGawc80truxhdeRL598hTV+TeRQjfPFw1d2Cuss/dKaI0I4ysZF?=
 =?us-ascii?Q?OL3To0Om1kqZxmd775pZa6WhdTCYu3UZrzpNpEbZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce6ab47-e806-4b1b-6055-08dcccf24979
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 15:00:16.8204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 72oAthn3WcRh6k9jPpYhoS8cLqPM2QuqlvRLTtoFXH9DX5SncFq2mnkcXcYTcHp/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7958

On Wed, Sep 04, 2024 at 02:20:36PM +0000, Shameerali Kolothum Thodi wrote:

> This should be added to arm_64_lpae_alloc_pgtable_s2(), not here.

Woops! Yes:

-       /* The NS quirk doesn't apply at stage 2 */
-       if (cfg->quirks)
+       if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_S2FWB))
                return NULL;

> With the above fixed, I was able to assign a n/w VF dev to a Guest on a
> test hardware that supports S2FWB.

Okay great
 
> However host kernel has this WARN message:
> [ 1546.165105] WARNING: CPU: 5 PID: 7047 at drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c:1086 arm_smmu_entry_qword_diff+0x124/0x138
> ....

Yes, my dumb mistake again, thanks for testing

@@ -1009,7 +1009,8 @@ void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
        /* S2 translates */
        if (cfg & BIT(1)) {
                used_bits[1] |=
-                       cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
+                       cpu_to_le64(STRTAB_STE_1_S2FWB | STRTAB_STE_1_EATS |
+                                   STRTAB_STE_1_SHCFG);

> root@localhost:/# ping 150.0.124.42
> PING 150.0.124.42 (150.0.124.42): 56 data bytes
> 64 bytes from 150.0.124.42: seq=0 ttl=64 time=47.648 ms

So DMA is not totally broken if a packet flowed.

> [ 1395.958630] hns3 0000:c2:00.0 eth1: NETDEV WATCHDOG: CPU: 1: transmit queue 10 timed out 5260 ms

Timeout? Maybe interrupts are not working? Does /proc/interrupts
suggest that? That would point at the ITS mapping

Do you have all of Nicolin's extra patches in this kernel to make the
ITS work with nesting?

From a page table POV, iommu_dma_get_msi_page() has:

	int prot = IOMMU_WRITE | IOMMU_NOEXEC | IOMMU_MMIO;

So the ITS page should be:

		if (prot & IOMMU_MMIO) {
			pte |= ARM_LPAE_PTE_MEMATTR_DEV;

Which which still looks right under S2FWB unless I've misread the manual?

> [ 1395.960187] hns3 0000:c2:00.0 eth1: DQL info last_cnt: 42, queued: 42, adj_limit: 0, completed: 0
> [ 1395.961758] hns3 0000:c2:00.0 eth1: queue state: 0x6, delta msecs: 5260
> [ 1395.962925] hns3 0000:c2:00.0 eth1: tx_timeout count: 1, queue id: 10, SW_NTU: 0x1, SW_NTC: 0x0, napi state: 16
> [ 1395.964677] hns3 0000:c2:00.0 eth1: tx_pkts: 0, tx_bytes: 0, sw_err_cnt: 0, tx_pending: 0
> [ 1395.966114] hns3 0000:c2:00.0 eth1: seg_pkt_cnt: 0, tx_more: 0, restart_queue: 0, tx_busy: 0
> [ 1395.967598] hns3 0000:c2:00.0 eth1: tx_push: 1, tx_mem_doorbell: 0
> [ 1395.968687] hns3 0000:c2:00.0 eth1: BD_NUM: 0x7f HW_HEAD: 0x0, HW_TAIL: 0x0, BD_ERR: 0x0, INT: 0x1
> [ 1395.970291] hns3 0000:c2:00.0 eth1: RING_EN: 0x1, TC: 0x0, FBD_NUM: 0x0 FBD_OFT: 0x0, EBD_NUM: 0x400, EBD_OFT: 0x0
> [ 1395.972134] hns3 0000:c2:00.0: received reset request from VF enet
> 
> All this works fine on a hardware without S2FWB though.
> 
> Also on this test hardware, it works fine with legacy VFIO assignment.

So.. Legacy VFIO assignment will use the S1, no nesting and not enable
S2FWB?

Try to isolate if S2FWB is the exact cause by disabling it in the
kernel on this system vs something else wrong?

Jason

