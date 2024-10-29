Return-Path: <kvm+bounces-29961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0029B4F93
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 17:39:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1C841C227D2
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 16:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2A41D8DFE;
	Tue, 29 Oct 2024 16:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IOzXP1dE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4B61D932F
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 16:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730219911; cv=fail; b=l9o0Z05AIIJMOvaVqjm4hu29hF4n/f/p9+WKkD4ajUQiB1QjRjsBEZ+UYlANF2cDosofOaoXL0BBtPwqTKkJgf6Oo1XRhWj8Tw5kgpGdSaB1Gu9KsVATF3oC7jjlDNFhb3Wp4Gkd2nVEz7FZOLxgORjPVIkonznT0Z/6IU9g7wk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730219911; c=relaxed/simple;
	bh=WuNmWdLAqQYOs1FDITwpQxSrUMhs+WAWZwrih3N/iHo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iVY9mAWKy8X40XthBRlXT9E8gAoPOlSwATheJ9vyvOUpcmkS6BLAwSHYkuGK6nbqSFfPY9vzbQTw0xcSpes7cPf/6eB//3V1VciIsfRGv5XFHw6pPKHczuGqjWXXFiPhdbzE5oDOC4ZgKlb2lUS0gZJKPJBXVO2SmuO07snr/oA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IOzXP1dE; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ElnP1HKChsU5CIwvmw3l5LfZZFPHWwof3ekf0oLhX1xZRu16FL5Fiw0JxjIsaiqqs1GorVPyLrRikxZHkVCHtOT6h0jvAVi8oSyaw8gJ7Usg557js4Ehr5owje8hjUJdo0I9LvuR2hb7hX6KXccf6eFM4WSXKIzDGwDLnZ1AQQu316e4pATRLIBCZkZtJiAv8p/nHV5uwvaHnzrjPMG/Y8TyUJl5gsyCfb/TsrL/or5RQwsC/kN0AYcOQS7DASuiD8s+WczOXtVJyrGBfIdC28+Fd8LcjNWSsnIWqyG9DdSFlkcHe+JKMFbK4V211Mij6rMGWYImQr7eQ56e0UUVSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/4en8R5hRIMhjju4qxuJuRwpzeG7jNbKTvNgrngxgg=;
 b=cbTgKKY3SJIyk0X2CYTMg69SgMfumpfh8RaCUGPSv2SV/XXOgWRN9zcX+5FWT3ROKZ1jcQEI4lO1qS1Wj/ciffeRJioJfxUq1QxNbs3TDVQUdHKM0W4X0fKWW96LzSVXFA8zJeyTt5ujqza9ziYc+Lx/eRatIvzXyy8YLmX4w6rDfmgvUhJOFuUhxrFOlB28daOlR4krevTdqAFmmyCmSPIK4Tc9Givy9Cel5GzGOKypuo866XgzDES3r/YxlpMgbZJ+LjmJoDfAbH1AkgJa6OucMotg7w3zpznl+M7NgCijk6ZF8wjRji20S1tna6/Mni1Gf3NjKie5TyH5o3JgZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/4en8R5hRIMhjju4qxuJuRwpzeG7jNbKTvNgrngxgg=;
 b=IOzXP1dEzsayT9GkioJ7yrm4ZzBbsHDh56h2geW5qsvLD9wWyTy2kx2ef7Ee/hdQjm53aFMfXX1BhW5aO/gfMhuLvn5As0cug1Be7kZaVRgPjvWmlh81jhkRaXmV0bJjx+tWawHymy6WOFoIVWk5ZBIeYVmNt8MTNFWEJ0B/6lQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 IA1PR12MB9062.namprd12.prod.outlook.com (2603:10b6:208:3aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Tue, 29 Oct
 2024 16:38:25 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%4]) with mapi id 15.20.8093.027; Tue, 29 Oct 2024
 16:38:25 +0000
Message-ID: <4210b105-9ca0-4ae9-b8f7-f87e7c9b3844@amd.com>
Date: Tue, 29 Oct 2024 22:08:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] iommu: Add a wrapper for remove_dev_pasid
To: Yi Liu <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
 will@kernel.org, alex.williamson@redhat.com, eric.auger@redhat.com,
 nicolinc@nvidia.com, kvm@vger.kernel.org, chao.p.peng@linux.intel.com,
 iommu@lists.linux.dev, zhenzhong.duan@intel.com
References: <20241018055824.24880-1-yi.l.liu@intel.com>
 <20241018055824.24880-2-yi.l.liu@intel.com>
 <20241018143924.GH3559746@nvidia.com>
 <9434c0d2-6575-4990-aeab-e4f6bfe4de45@intel.com>
 <20241021123354.GR3559746@nvidia.com>
 <91141a3f-5086-434d-b2f8-10d7ae1ee13c@intel.com>
 <e937b08c-4648-4f92-8ef6-16c52ecd19fa@amd.com>
 <305bc6ba-13c5-4b3a-b3c0-284fc573a3ff@intel.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <305bc6ba-13c5-4b3a-b3c0-284fc573a3ff@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0159.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::14) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|IA1PR12MB9062:EE_
X-MS-Office365-Filtering-Correlation-Id: 11614097-13a6-4316-b4c6-08dcf8381be7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmlSR1diYWRNSE1mbmh4YVFyRlI4dUxpeERJWHdFbnpGMHpzNVYxeTA1ZWw4?=
 =?utf-8?B?aTRqbGsyNnpUZ2QyN0JsN2VTWEhiR0toY04yYWxVRzJwNzFUangvVGJxL2Ro?=
 =?utf-8?B?Um5qczVEWDFJSmNYS1crRElmRjRReXVpemNUTGlLUTFDWXRraUQ3RFlhYmRt?=
 =?utf-8?B?SzFSQ2I2anpHcGNERElnbjBGU1c3TWZHZlhIVlFmcFVFODQyeTFLZi9hWHoz?=
 =?utf-8?B?MkRSaE90TUZZekxQaHZTZzZ5QzB5OUJsVmZ5bkVrY1d0TFlZTEUwZnNXcFVw?=
 =?utf-8?B?eXdWS3R1OVRIbE5kb1gwR3ZFWFVnVnhOeUJQR3N2U0lYWlBLSWEvR1R4dU5G?=
 =?utf-8?B?N1hpWm9YcHcvNXlpdmRqQmkwbzJrei91b1AyaWFMM0ppWHVKY3VTakNiNDdZ?=
 =?utf-8?B?dXY1YTViQVdoVjN5Ui91Z2hRd2hBaG45T3d4U1ZrS0hLRmpKZDhaTmRjWkJP?=
 =?utf-8?B?TmhTdjFQNGd2MGVkWThReXdudDczZlErVzhQK1RxREtrZVVDSW5IS0srQm43?=
 =?utf-8?B?QjAvajROTFlJRkxHRklMRHBNMlpIekgzWVhnQ1lHTkQ4TzF4bEl0YU5od1du?=
 =?utf-8?B?RWoybEZvVklyWGltOUhmTUh3RGV6cGM4c215Zlhqc1RuL0ZJcHNjWFYyYThh?=
 =?utf-8?B?eEVWOTQzWlpzZkR1cHgyaEdiM1hMYVBuYStWME1BaVRpSGswWUtUNU1IMGh6?=
 =?utf-8?B?WlJiWU9vNDBqcXA0ZXUrNmtaOWkyQnVGUnBKNWNNSjZEM0ZJek9IUXBtUlRp?=
 =?utf-8?B?dGN0bkthcHd1QmRxTlZWM3c1MUIza0YrMXpzbktNU1J6bU0wVTFTSkpLcVp3?=
 =?utf-8?B?VXExQ3Y2cUhiQzBUdTV4WklzSFI4TEVHQVdsNXMwamoxWCt2NDUwT21FaTk5?=
 =?utf-8?B?RDVGdlViRVJscVhxV2R3VmFsbVZSYytSMEZUMHh3dlVZRTRTTnQ2TEhOdWdL?=
 =?utf-8?B?VU5OaXNWZ1M1L25vNytoR1ZiR3RQSmdUSGFzb1lUU3dBeFcydGxJNDhxNm0w?=
 =?utf-8?B?Y2R2YTV3K2dhbnQ1T1YwcXkwUzcrSVdsWFdYcW40aU1CeWcyRVBxZmd4TkF5?=
 =?utf-8?B?UlMramFkRkVlek53QitGTmlsZWZJaUp5NmYvQ0FnY3ErQ3FQaHNiaGMxS2pG?=
 =?utf-8?B?NG1hVExWQjdtdFRVQ0kvRTNvdk5OdzdZMVZqajZFd1JHclJBTlRLdHAwUzlQ?=
 =?utf-8?B?RWpxdVQxUUQ5TkduSnUyQngzaXIybVNZZXFkbEQxeEhGcVpyaVVoUWt0N1Yy?=
 =?utf-8?B?QVNBeFZHOThvOTgyRS9FVE5PMFJ1REdtUWZ3d0NSWVA0R0lSRXpzRFdIekg0?=
 =?utf-8?B?TkVObytnelpVNHg4bE5HeVVHb3R4ZkZISzVqVWpyMlVNTFkxaWNRelplQjI0?=
 =?utf-8?B?Mk15ai9Od0RzOC9Gekx3QkJ6UGxEMTZ5RkJWS0lueE5GT3hBelZ2aGo0Nkls?=
 =?utf-8?B?bjFoMHUrOVRSbmVFTDJ2YjFxUUdVYTJpM0FKSW1TVVRVdWhUOU9vK0VNSndr?=
 =?utf-8?B?MlFwVkxGOHN4R09Kc3RxTUFuWXBpejFYQms4Wk5yR3dkaGc0MVhOL3RkK0lh?=
 =?utf-8?B?cEZDNVB5TkVPd0ZESDRvN2NJSFI0cWtiazErWktsUlhJL2s1VHdvZ2FoNWg3?=
 =?utf-8?B?aUphMFdMQnZ6ak91d3BjQkhQTkZWZFhnb3JRSGJWeVkxckI3ZDJwejFUeTBj?=
 =?utf-8?B?NGduNDBwQjIrNWV0am8wTkk1U0tpVHhqSzlEdG9TOTZBbWtudHlpZGU4WFFm?=
 =?utf-8?Q?8fhzOYCpxd/TMEjbv4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VC9xUU1RS0JIU1RaNS94b0k4TEV5UGRNNEs0VjZuZm5KRXBRQ1FLdVhIcXYr?=
 =?utf-8?B?enkrM2F0SUlEbU53K3Nud0RlTUVLbGFmQmVwOFBzTGFHL2F0bHcvSTBoMGI0?=
 =?utf-8?B?d2phVGhySDg1QkgvdklpR3B6VkNvdzVxVld3YlB0ZHpBdVFZYVFNWE5IVUdP?=
 =?utf-8?B?NGprSEV6NXF4N0JMMnRRbk5URlFRMDhjRStuWTZxU29zMGxkenBpZHZsbVAy?=
 =?utf-8?B?ZmE0N3NoQmIzaUN4alVpOFJnMUNaRzlxSW9NcVpMai9qdGl6NTB1YjJuWWcw?=
 =?utf-8?B?UzZoNGJFdlU5R0lucHN0cmg3bjZibC8xQy9CM3EyWmZvaTZPanA2MlJrV3Vs?=
 =?utf-8?B?UlZHUlJlS3pjVjIveW1jVmdDWjNudCtmVUtnWVNLVHVvZ1MxTVpiQXZLS2d4?=
 =?utf-8?B?WDJTTTRZc1VDRXVZdWtQWnRQN1lDaWJWN2dzWkJpSjFKMlVMQzJxdG44YUxw?=
 =?utf-8?B?eXR4RHpQYXA1dzdrM254Mkd3bjE5L0p6cndsSnhHa2dEbEI4emQ5alk0ZmFI?=
 =?utf-8?B?aVZ0dUpuNHBKdVFIMEYzNWMwK2dxbm1jM3V2V3FKVUdYdmJSNllHZEg2OVA3?=
 =?utf-8?B?d1FHaDFxbXZRZ1VFdStFVWJzU2JZU3d6dlByK0xXait2OHc4cEg2QTN1dnpQ?=
 =?utf-8?B?WHNxNHBhcWVTMm1iQTJndDZXc3lGcmVSRGF4MWMza0xKTm1nQk1wOXd5ZUVH?=
 =?utf-8?B?WkVHK3FaRFJUUXNRN3RpMEZDOGgxYXY2WHV4aXlOZkl5Q3IvQUJta21wdmNa?=
 =?utf-8?B?TGpFWDZacFExVkFTeHd2a2swOHJkNlQ3OG05b0NwUXdsaE1SOUg4UzhqNFpp?=
 =?utf-8?B?aXZQeGM1N3F3eUZsUE92MnB5QmdBb25LWUtxZk9heUJDTmZ4azJLT2ptNXUx?=
 =?utf-8?B?ck8xSzVnRDJ2MlBZUGNFajIxcWJvYnU4Q09TSDlVYWsvR01jS1o0Y1RMeFFu?=
 =?utf-8?B?dk13K0ZmeUZrRmlJRUpsZW9tSHV3Zi9mRDF3ZkdwdTZ2dmJDNW13bEFhL2Vi?=
 =?utf-8?B?dFpPM1lxOVV5aVYxSGZtSnV0a0ZSMUkwU3cvNENOUFhOR0JoS0lRTEplTkh4?=
 =?utf-8?B?NURxcmkzUjZueWFWbTBBQzU4OHRrVFZkUW93ckRaeEpyREVVOFE2N2RFdFhv?=
 =?utf-8?B?Tm9zb0tnNXJzMW92S2QrOE0xRVFySjhORVQySm01R3I4N1RoV3daTzlmWWRQ?=
 =?utf-8?B?WXc0MS9vZFRzTXBUNmFWYURkWE1TeGtDdWhMc3Y4bnZyQjkwYUdQbEpYV2xT?=
 =?utf-8?B?WkkwU2dVaEdWb2JMdXhuai8rNVNIZmxRbi93eG8rampZbVBqM0xaeFNGdHZV?=
 =?utf-8?B?UmZIRU13UGt6dGM4RDV2K1E2SFRJbVlNMXZTRTduaFlhbEJ1WmlhclBTbnkv?=
 =?utf-8?B?c084Tk54TGtZRlV6eUFCUGJJL3hYT1hxdmM5VXd5bEFBQ1JsS2JEOU9IZk1K?=
 =?utf-8?B?OG13U1lKTWprWHIzZG0wRHFhTXRFcEQ1YTlHc091NzR4UjhhclZYUEtxZFhQ?=
 =?utf-8?B?UTRZWEVxR3lYMlE4bjV3VitpMXJKeFZTVmdKQnV2VUFmeFB3Ti8vYXFGa3ZO?=
 =?utf-8?B?L01McENNaTEyZnFTU1JPL25id2h3UFFlSlh4RHkyTXJ4QlpHQ3I0Nk1FQU15?=
 =?utf-8?B?Wk94UDNQSWNmTXZRd1Y5Q3JLdURRbmxIYWx3UFZyekU2eE84S3VGQTNuYTBi?=
 =?utf-8?B?aGt4ekVoczNpYjhTeGRYYnZSaTB2eVBhSld3MzJsZ0dISTJyeSt0ZDBTN2ww?=
 =?utf-8?B?WEE4a01pQ1JqcUV0eTRJVGkrZVdreWxqY2llT2p2eEdDK0FzM2ZXN3pPNktT?=
 =?utf-8?B?dGpYTHM3MUVwQVZHNGtzb2pKQmJhNFdHQjBvUlJScnpQWmFtdWFZSGF3a1BW?=
 =?utf-8?B?TE8yVDdkMEoxREJodG1IRk1mbjdxQ1ZFZWtUWWN6MkltbE1wdy9lc2ltTGRG?=
 =?utf-8?B?K1JQMFZTWWdFRHFZTTAvQWwxdVkzN1ZjdDltTUlKRE9TTWd0QmRxVmlJVzFx?=
 =?utf-8?B?YXZ4d09ZcW9XQjg5UkxTSVU4eHhwKzJ0N0lQL2Z4empBQjNZTy9lUEZyVGZJ?=
 =?utf-8?B?M2c0YzB1Slg3SEgrc0syZEU3alVXdHU0cjI2S2huZUdNV25BT2VXRzJDUURD?=
 =?utf-8?Q?kIKXy0zXfSQVs09t87rgSUFle?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11614097-13a6-4316-b4c6-08dcf8381be7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 16:38:25.3658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8zxd6QIVbA7T07ak+cjt5ergb1UtaEyVsbZ7NOnrGCyby1OTGwZMRoQEsZrHs3xxS/17P0QUDofCdkFOTym7mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9062

Yi,


On 10/29/2024 10:50 AM, Yi Liu wrote:
> On 2024/10/23 19:10, Vasant Hegde wrote:
>> Hi Yi,
>>
>>
>> On 10/22/2024 6:21 PM, Yi Liu wrote:
>>> On 2024/10/21 20:33, Jason Gunthorpe wrote:
>>>> On Mon, Oct 21, 2024 at 05:35:38PM +0800, Yi Liu wrote:
>>>>> On 2024/10/18 22:39, Jason Gunthorpe wrote:
>>>>>> On Thu, Oct 17, 2024 at 10:58:22PM -0700, Yi Liu wrote:
>>>>>>> The iommu drivers are on the way to drop the remove_dev_pasid op by
>>>>>>> extending the blocked_domain to support PASID. However, this cannot be
>>>>>>> done in one shot. So far, the Intel iommu and the ARM SMMUv3 driver have
>>>>>>> supported it, while the AMD iommu driver has not yet. During this
>>>>>>> transition, the IOMMU core needs to support both ways to destroy the
>>>>>>> attachment of device/PASID and domain.
>>>>>>
>>>>>> Let's just fix AMD?
>>>>>
>>>>> cool.
>>>>
>>>> You could probably do better on this and fixup
>>>> amd_iommu_remove_dev_pasid() to have the right signature directly,
>>>> like the other drivers did
>>>
>>> It might make sense to move the amd_iommu_remove_dev_pasid() to the
>>> drivers/iommu/amd/iommu.c and make it to be the blocked_domain_set_dev_pasid().
>>
>> I wanted to keep all PASID code in pasid.c. I'd say for now lets keep it in
>> pasid.c only.
> 
> ok. If so, we may just let the blocked_domain_set_dev_pasid() call
> amd_iommu_remove_dev_pasid().

Sure. Lets do that for now.

-Vasant


