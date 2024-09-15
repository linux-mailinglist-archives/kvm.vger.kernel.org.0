Return-Path: <kvm+bounces-26951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF4FC97993A
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 23:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97EB3280D6E
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 21:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3158E131BDD;
	Sun, 15 Sep 2024 21:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lec51Nw4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D74812C54B;
	Sun, 15 Sep 2024 21:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726436374; cv=fail; b=b8ChcutapamqA9fsu+fQhuxQhmgkYBcUxdkVnPtIvT9hK+z356EWst8GO2whM02b8kGRAkSJjAjNZiCYjnjTQEAa7EoDrr9kVaYBrbql9H3H1d1u961XJEV3gbxKLHEjEHRQ8g6PsjLpvRDmV1zTGMiuGDFVb1CBKosE0KTeLsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726436374; c=relaxed/simple;
	bh=GG3DVw6LzBiKGQKb3SYJ8N/93a9y6C2lsjIHtH+ADeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kqxkSlVc4Hm+XFE6QnRZ90NmgtrZ8pB120cRgFFT1EQ3tk6IQqEh0gU20ESMv6JQ8+9v2KxV9VtHTTJN00Nv6qavgpis6r9O0KpqwEr1Q4rvyFMjcTSJzWlVj+PdThXyQo9k+9BaSanJvY4U/+jjRHFxcn+jk+J8Okwhr4SZEtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lec51Nw4; arc=fail smtp.client-ip=40.107.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rXPjqqqWBKBCmQN11Ge7SqcWxe0diId5gQ0m/8cL79p4YnRmq4z5gCsj+C1FwDxBE5M6MNTuXQhzEOYBtTDENQdG/MB1GHZnyJRDv8ZkOwVFz73ahnhSMMl7u8adfvobYKLXVTMRgY/ZianDwt7JFkeyg2iMk7EuPCNq9VANOYrICJgGwLUBQzYeTTl7xy8n5W7coJ2ebF1O0LRfm/j8Z+0hg8eUl9GNeoHAWkEP8JwtK1GPIBkDx/yHW5T4JHqINaeqm1gKCYONdhWxiSSlyM7NOrYa2nYjObq5OE0sk0cbB9MdXMuQsSPhzKk6GuDMLohatCS+22IP9chqE07NPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k2inQbJVJqXLhqHIxSstTiHCJXGxdS6aTZgPPMCh0bw=;
 b=vKCuGtL/Be1k+y4ZLuKJLvEqaxUt547C8fPvg02M18fMzd74d5kKIThyKT0cn55k8emb57Zm/S2uIsER9wSUUc6gu2C5oMX36LxcopapVarVEsAhILp7NqV3uSSHYTXd1irfNVi6dr4ml3Ykf0Fgq7b65V4TVh6d69142VfsthkfXWZDBPLugDOdPsVUVRQgkURmw9Ve4kk4fCGgDyzN9LGjo3+t1LOjfcZDwwvtN/MkMps9eNXOv4BM/FT3icUcFYm9Hp12Ju/nlmkrhm+2NKp1NiUT49ozoPzf9t2OsEO/QgRAcWJ/1zBS24Z7wyeDuT/Xhl9AqOz0myHeV6LtKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k2inQbJVJqXLhqHIxSstTiHCJXGxdS6aTZgPPMCh0bw=;
 b=lec51Nw4h1PJXqxvmK8DE/AGYMB+VMXMriaNZ2AytC5tuQnZjeUcN34wHwGhba+L0yvoY1PzfGpWDjhAXvEdmd/vHjCT6L51aIdgnTq0Weunatn1HWScqyHWMPNaRDjit+1hBCMWX9vqMoZc1bK2wj8vvHkI6HKVrMfTyN156VO6zzbPVWbLZB668SW+eJCaMIRAfKCKocrfYq1yCW0lT8VFa99Rna4czcM3p3FIqDIkG6E01DsGozx3NoU4asixVx4ejUFZi2lN0c8wM+Y52BUy7aNqSC5F5ey8crS25wGX8+9do2Gv8Svx3lEp4Dy51LUg8EU0ejj4peCFikJ9Cg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SA1PR12MB7223.namprd12.prod.outlook.com (2603:10b6:806:2bc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.23; Sun, 15 Sep
 2024 21:39:27 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%5]) with mapi id 15.20.7962.022; Sun, 15 Sep 2024
 21:39:26 +0000
Date: Sun, 15 Sep 2024 18:39:24 -0300
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
Message-ID: <ZudUDG5GHXct51tZ@nvidia.com>
References: <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHuoDWbe54H1nhZ@google.com>
 <20240830170426.GV3773488@nvidia.com>
 <ZtWMGQAdR6sjBmer@google.com>
 <20240903003022.GF3773488@nvidia.com>
 <ZtbQMDxKZUZCGfrR@google.com>
 <20240903235532.GJ3773488@nvidia.com>
 <Ztrigx4LmpbFiMba@google.com>
 <20240906133444.GE1358970@nvidia.com>
 <ZuAplEO7wyFahr6Z@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZuAplEO7wyFahr6Z@google.com>
X-ClientProxiedBy: YQZPR01CA0009.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::22) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SA1PR12MB7223:EE_
X-MS-Office365-Filtering-Correlation-Id: b5681174-f359-4d57-9a51-08dcd5cedef6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmhjT3RpOFo1a2JRUU4vLzJ0bmFBWFJFdEN5eDRtWFAvbTRJS1NOYXcyK1dO?=
 =?utf-8?B?cjlpcGNxV2R3Ymd3UzE3amFlREFSVGtLNHNrbGFRekd5MlFTWmhoWDJva1ZP?=
 =?utf-8?B?dnVMUjJabEhBUmRMQ3gzYXI5czdWeWJucHltMytpMm9mTkJWODJBdG5SazM5?=
 =?utf-8?B?RmFTVDRwSUR2UTNsbXZWNFR3ZUg3cnBvYlUyYkdZOTBFbGFVLy85bmU4elBu?=
 =?utf-8?B?UzVUbjBXemVYWjRSbjg0dC9hU24wMkZVOU5KajdBanZucXAwVWtEYjBLblpD?=
 =?utf-8?B?L1NMK3FMcWp4Y21Tc29IOUFWWW9GT0lDdDlRb09JMEJuU2ZOTTJNNWtVcEVp?=
 =?utf-8?B?Q0lCSFBESFpGWjhacS94Y3FDZkNybEpiSmpIS21WNDVwYkV5UWpRSkc4WUNK?=
 =?utf-8?B?ZFRjTTJSbFpYRG9MS0JpMUtOYjV4MmdWQ1VrUEtSNk1zMUx6QlVpTEZJSXlk?=
 =?utf-8?B?c0Q2UHJlSzdXVTJJdWhvQVBFOXF4djBjQ1FXWkl1NGgzdXlDT2dqQ1FyME9v?=
 =?utf-8?B?cUpEUUtRNlR0ZGZ2YzU2dzRnWHFEeXN6dThwd01XTG95WjZkOTBQQW8wQVpR?=
 =?utf-8?B?N0Vsenc1dzZoTW0vNjVDRHJMT25MdzZCamk4U0pQdEZ3UklNUVNlU2NvS1pT?=
 =?utf-8?B?dnk0YTVUbTJBQ1pjQjhKSlZLM2lhMGh0TjUwRTcyYzRCVEc3aW1ETU9idDM0?=
 =?utf-8?B?cTlXOWl2cVVnNHV2Q2dJTlZXdmR0UzMvclZ2b0o5UUthK3Y3TGlPNzk4cE5X?=
 =?utf-8?B?bWdrV3c2dDF2elQ0SVE2WGQwZDJXK0p5Ry9aU1FoYmNDbWZWeTFjWi92dElX?=
 =?utf-8?B?MFFmeE01NDNZYVZObDlyRGkrcG5zMlZSakU0bmwxb3V4T1BOVzlhaVI5K3hV?=
 =?utf-8?B?cTF1ejNjWFNIQTdCS1lNQjdrQ2J0ZDVKKy8zbElvNk9mWUpUYm5SQnpjNzVR?=
 =?utf-8?B?SEpnTU81R3MrNVNCTEEvYnc0cnNiODlwdC9DZ0JsQUxIakNtYTRBSGJwY2N1?=
 =?utf-8?B?eTRIdk92VUF0bW1lU0p4OWUxU1p0YVdhcW1hOFJYVHZ4RXU0ZzAwSUxDMGJ4?=
 =?utf-8?B?V3V5M3JHeThVZ0hrWFNqMEhLZDZYc1FtWnQwU1dwWHUxbm5CSyswRFR3Y2dW?=
 =?utf-8?B?Qm5XL1c5aUp0TUJDelp4N0piZnRLSWlwL29weEZvdGN4Nms3NzROcjFoZlo0?=
 =?utf-8?B?aHUvdEZ5ZjM3Mkxzckl0MkVZb0RlRXJ6RWtEbGRQQUJMNXdNamhmYks0dUFU?=
 =?utf-8?B?a3dNbU1jUFRoS05wM2xSalVHcTQ2VHlydHVUU2wyVnNFN0djUGZBUGpTa2ZZ?=
 =?utf-8?B?emkvemJDb0JsQlRkMnFmak5lV2Nta3RTWG40US9uUUg3OFAxRmlrSjhwU1lu?=
 =?utf-8?B?bmd1Y1VkcFczVmhualQyQURlUXFwTGZzV2pvVCsvUkU4M3NldElQa1g0WXlt?=
 =?utf-8?B?ajFoU2NkMWhFMmpVTkhGalRReFUyRVJsQmovRldrWTJQallGZTM1RnNqQ0N0?=
 =?utf-8?B?MDIvY1F3aVVKTDZrdWFFeTBWTWxMTThSMlZ3M21uZEp6WDRPSm1pMWVDa3VX?=
 =?utf-8?B?YXdhSThYVy9YWXV4WEkxK1pPakhUK08vdmpmR2lxK0p0SU9HRithaE1LY0Yw?=
 =?utf-8?B?dy8wdy9MZnV6N2IxQnhZaUo0NWU3Q05MRWpWejVPU21zaUNER1RZVEdNSEhN?=
 =?utf-8?B?TExiQWlCVG12Wk01ZHNER3V5N1VxUjFnNG42TCtWcGJaaGRQN2trZjJzVVdQ?=
 =?utf-8?B?RmdKTTgyYmxaQXRaeVJRVFMyeGtGZEJNTU1LcWI3Q2pIclF0MFc5b3Y2anc1?=
 =?utf-8?B?VkRkN3VGcDdobVpsTlNadz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1JHUHZscG9GQlZhbFRCeE83b1k1aHo4emE2VWJPMkphcmRvdlF5V0EwT1ho?=
 =?utf-8?B?YU82WFBibnV4U0ZQd05xUHB5TndsYlR4T1c0WXhEZzRhd0diUjZFQlZxS1o2?=
 =?utf-8?B?QnRRWTdVT1FJZmFBZ0dsUzhmVmFOWFA1OHJudDhpcEJvV3JJUDlLdnVmM1Y2?=
 =?utf-8?B?Vi9PWkNMUVhzSTBwczBjYUZDSWZFVmcrM2tITEozakdMYVk5M3VwYVp5eith?=
 =?utf-8?B?WjRzMEdaY0hKeUpvaWI2SVdtZncyZm5BYWYvZkF6ck9NYm5uLzQ3bEdxdnds?=
 =?utf-8?B?UFhUcTNGVGZHT2RFWWltRkR6UzRSQ3RVcFhMYzBiaEVhVzdzMkJJZnpONUl3?=
 =?utf-8?B?Rnl3YWxxMDQxZ05ka1dwbUt5Z2JWVDZaRmZOUXl2dEttUThjWm1MK0JxRXNa?=
 =?utf-8?B?NHlET3BDL2FmY3VzN2JJNWxtSE9BWW00K3UxbUtNUWEvc2JySHJ2L0wxVk5s?=
 =?utf-8?B?V0dONE1tdXZyUC9WbjB4d0hCN2xzZEl1ZUJqRzE1M1hIZC9CWCtPN050K0J6?=
 =?utf-8?B?WjdsN1prSS9ST1VZcGozdXZqTmtZNDVpVllRNjBodE9OcXdGZXpiSFFScEpP?=
 =?utf-8?B?YkhkMmMycnpNK3RhVmdIRCtEVktKQytvZm56MDkwRm11cm9JNkZuYnVnNjNq?=
 =?utf-8?B?d3ZqbFRGaFRqNDJiT1R3bEdiSEwrUDFQdysrLzJGTWo1TmlhZEFRVG04aFkr?=
 =?utf-8?B?SVFxRVpiOFowa2F0dHBCRHpyU1JrVjdCUWZXemJkSFdTT3Ezd3BmK1d6eFZ3?=
 =?utf-8?B?WFVOV3VuamVqOGo4dlY1c3VIdldYVDJ0RUZmdzdaYlJoVTQwcjhjVnJEMGli?=
 =?utf-8?B?RXlGZ3JZUXdiYXJWamVHQXh3UjVoUDlacVZtZm9WTE5aV0lDdldJZXJ5NlVr?=
 =?utf-8?B?TTdsdkVnRTdLQzNqTktqVG1qN01jVUVYN2J3T05iTW1BN0hDSGFFVlg4VU92?=
 =?utf-8?B?UHBJUVhybEt2V3NZVVRYcDhyMTVId3ZLTStVaWRDTGl0dnBmb0dpY2F6eFlr?=
 =?utf-8?B?VUhhT3BDc0VWWFNnVDdYUmJOY1NjNjdVeVN2NUJnRDc2YkZMUGxDcjErVlUx?=
 =?utf-8?B?T21LVllrVFlYbkFyZXpoYXlvSGVJUzNqcHBhQitPcEJ1cWZIMGc4b3ppdWpH?=
 =?utf-8?B?RnlSclZHbWZTakNJTXUvQlZzNi9vWUhSdkxjc1lrWWltVmU5d0ZUb0tGREdT?=
 =?utf-8?B?TmtxMjBHLzhpMFNNY0Z4a1krV3luYVc5Rmp4SnkzSGl2VTkzNDdzSUZTb29x?=
 =?utf-8?B?TGFZdjVYU2lMSndoYi9TOE1RdDdsZ2JXS1hUZjJjakVzclJLNmV0d1JGb25F?=
 =?utf-8?B?ekJKQktTVDgyeWVxN3VnMms5SVVIYzhVVmloaktvNUtmWFlzTmlvQVZ0ZVVl?=
 =?utf-8?B?U05TSWt4RHNpdlNTUkFVemVXY1ZSeVhYa2Y0YURRNW5wRVNxMisxUmNyblRj?=
 =?utf-8?B?L1hocGlZcDJudzE3c1lCNFFPTWdvOStXV2pVZFYrQWV4TGNlNVl5d00vdlh1?=
 =?utf-8?B?VTZYSmk5UWxyVEpjcUxWTEliMGk5c213bkxhNkNJYXp0dWFWTGJxUEFzUXF4?=
 =?utf-8?B?a2E0Ry9KZHVVWjhFTFZYYm05VzhxS1dYbGFBVEQvZW9vZkxQenRoWlZqU2tR?=
 =?utf-8?B?RzJuK2FMTUNhUWJxOURJT1hIUDNSS2FJSDQ5Nnk5VTFlOEV6Y3FvVS9jNnlK?=
 =?utf-8?B?QjAxVnE5TkpDclBiNGlnSUs4a2ptNlRnTVgvK21iOXY4SEFsMm9tTHlYb3B3?=
 =?utf-8?B?OGY2NTVTcEJBOHdkaG1JaEdGZ1lHN3M3V1oyck1xL1pzYndHWmtBNVVGUHQ2?=
 =?utf-8?B?WFkwOTBwVmUzLzJqWUgrMzlPVm1sNjE0cGZjUWV1ajB5YzdqT1BHR1M2VHZp?=
 =?utf-8?B?R0JKUktmMlhUazgvRkFNM3VUbXRPbEdXdER1MGhRQjE1VzJWREhiZFlnSHhB?=
 =?utf-8?B?Wk9MUmdxcmxVU2pZNkZiTVh0K3VOVHNOODY2cSsxcjh4ZEpDaUFhcGR0VXVm?=
 =?utf-8?B?dlNjd0ovNXhmbmFqcFdWUlcwdE9vQkg3VEZ2cUZJRE1EMWpoM3RXRUs4UGlv?=
 =?utf-8?B?bXNvV1JRbTNwbHZpNEtjZElrZDMrL3UxZHNveHhEdFdEdXp3MWh6b3UvdUdk?=
 =?utf-8?Q?rFXxGhu6qYf6bc8c/DycsQRyz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5681174-f359-4d57-9a51-08dcd5cedef6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2024 21:39:26.2144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8TXWU/yX8F6ytcdWmVOE7+owoaDlM+F8sKxCks1cNWC3XjcDB7Cnt9cflDc32c5b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7223

On Tue, Sep 10, 2024 at 11:12:20AM +0000, Mostafa Saleh wrote:
> On Fri, Sep 06, 2024 at 10:34:44AM -0300, Jason Gunthorpe wrote:
> > On Fri, Sep 06, 2024 at 11:07:47AM +0000, Mostafa Saleh wrote:
> > 
> > > However, I believe the UAPI can be more clear and solid in terms of
> > > what is supported (maybe a typical struct with the CD, and some
> > > extra configs?) I will give it a think.
> > 
> > I don't think breaking up the STE into fields in another struct is
> > going to be a big improvement, it adds more code and corner cases to
> > break up and reassemble it.
> > 
> > #define STRTAB_STE_0_NESTING_ALLOWED                                         \
> > 	cpu_to_le64(STRTAB_STE_0_V | STRTAB_STE_0_CFG | STRTAB_STE_0_S1FMT | \
> > 		    STRTAB_STE_0_S1CTXPTR_MASK | STRTAB_STE_0_S1CDMAX)
> > #define STRTAB_STE_1_NESTING_ALLOWED                            \
> > 	cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |   \
> > 		    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |   \
> > 		    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_EATS)
> > 
> > It is 11 fields that would need to be recoded, that's alot.. Even if
> > you say the 3 cache ones are not needed it is still alot.
> 
> I was thinking of providing a higher level semantics
> (no need for caching, valid...), something like:

Well, that isn't higher level semantics, really, it is just splitting
up the existing fields.

We do need to do something with valid as well as the VM can create a
non-valid STE and we still have to wrap a nesting domain around it to
ensure that event routing can work.

> struct smmu_user_table {
> 	u64 cd_table;
> 	u32 smmu_cd_cfg;  /* linear or 2lvl,.... */
> 	u32 smmu_trans_cfg; /* Translate, bypass, abort */
> 	u32 dev_feat; /*ATS, STALL, …*/
> };
> 
> I feel that is a bit more clear for user space?

Having done these sorts of interfaces over a long time, I belive it is
not. Deviating from the native HW format and re-marshalling into
something else is error prone and can become a problem when the
transformation from the well known HW format to the intermediate
format becomes a source of confusion too.

> Instead of partially setting the STE, and it should be easier to
> extend than masking the STE.

It is not going to partially set, it is going to validate a mask from
the original vSTE and if the mask fails then it will create a
non-valid STE instead.

We can't eliminate the mask because the VMM needs to mask and check
always no matter what the kernel interface is.

One option for the vmm is to just pass the vSTE entirely to the kernel
and let it validate it. If validation fails then use a V=0 STE
instead.
x
> I’am not opposed to the vSTE, I just feel it's loosely defined,
> that's why I was asking for the docs.

The kdoc lists all the fields and it is reflected directly to HW, and
there is a bitmask above being very explicit about what bits are
allowed. Where is the loosely defined you see?

If we broaden the mask down the road then we'd need some feature bits
to inform the VMM that the kernel supports a wider vSTE mask.

Thanks,
Jason

