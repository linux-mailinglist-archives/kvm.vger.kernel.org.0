Return-Path: <kvm+bounces-31725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BB639C6E1B
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:45:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B8E02823B2
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 11:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 779AD2003D1;
	Wed, 13 Nov 2024 11:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p15q0mVK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0362003CC
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 11:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731498315; cv=fail; b=MUwRuuutT3UHsSZ8FhDzJ6A3iI3g5tQrzJFTy9TTsu5VvkPgmTmPR+rDpT9D2gcK0gDftWncS86i7q9U4OL/kuLoZWFv7PpT3CO10o3pdJ/8z9tgW+QhC1MKIFuFS6o16uVhrZgTzt2OIBGRM+AV8JAt9dCXCZs1WZabp7A0ubQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731498315; c=relaxed/simple;
	bh=t/r+qrf+YGLAesgCw+ILVkFBDutAowX5zbQWOmGX3lE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YusGIfc2cLF/QkdtIJXLIfxHYzzUWHEIwGjQuw5rvSv/YbiQ/XzPW79W6EMAZ6Dw1S5roJbyIG7L8mZnvLmIbV66pdfsrkm38/EJdj2UezQ3MD238r1MUVyr46EyTiOv/egl2PeuepBTOqKHV1Dfg8TlDInDT962+a334oCHiuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p15q0mVK; arc=fail smtp.client-ip=40.107.95.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EkPrHtMTeApDk8fIq/nd4oekHM6LMiAjWxN/vsOHtu900+//plDaKzVXYWSt99VIdAa9Pem6vfQ3nyS/xPc3N2spWkBb+nGRUg91BQfnfFpDCG00oELeyCeyKf3kkXtghItqBGLCpzMlA4VC3Ytt/kSGSBCW0zJb0Q831ZzIkcOHJK9TKb46c36Oy0Jny+6nUNiKzleQNEzQfZoFWU5I3oduGIPJUOPACGp3OmndxFh577ziuEe04aunB2iluuBlaeflvDTWntYaQSbzl7GTxogr+YE56XNvvNIm1lnZKH65AQjqXU3tlebyK/auQ1/mEDwh2qZHNMRGTBYHBeUDnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CJkVQrQHLjPAIHYyRQo9XlzdTWEcWqlYU30h7F7NNcM=;
 b=JyoDBxCMaoDs8yyjYSLKkr78+7Ap3QYOgcjntIt/ceCHl0H7HcLezcxD0YX166n60UbnLxwyl8ZFxpZDrXzBci0upQCHgkBakuGyiWMt56kK+hP+gPaRy2zrcntvryHxXf8ffhUci2N6/E7XFPdR/67XVZbKay7ki+J4e0DrN3M9vXsDgoro8zIrs7TaUqUah8rpy/XRGv6yAzM35E6TNzfIfS911TOMZ5uWx7pob/QEcRtO7bgyNiGQscJXPALvYebWZo/0j9+eVf43x5uQZ+/PDMlLWCOx6kDeq4xJxpsm2uR2pzceDVOYK0un8jww0EPTSa5lbhgEmr9mJj8sOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJkVQrQHLjPAIHYyRQo9XlzdTWEcWqlYU30h7F7NNcM=;
 b=p15q0mVK5OKgekV55OaVvh+bfeOWMzj/VPY8IS9HGS5sKgVmqg0ENX8aFhan85nR/58uU2cqepA8hlGKy0yNtQnmi1vcFsFUuWXPiN+ktMfV0bgkbb2qmLeLCn9QS1Mtl2b/Y7xcQPXfFZJtqOTR9tdi8g1sVRR/j+ojZoA6l/p/XapCEXd4NYtjsVMg3IxxrMRW1RcumMup+kCsz1AdD5jbk9K5tVDy+7fWLDzJviGmiapI7T6m813Z/Np50o8w+cU49GY99EiZzaYYXYq+Q8ESYGEtZr3NAWMqiRQV6KRHu6WIwvegw6qgCU2SnA2gZveZIPFoJTKmCDRIbZADbw==
Received: from BN0PR04CA0147.namprd04.prod.outlook.com (2603:10b6:408:ed::32)
 by DM4PR12MB6279.namprd12.prod.outlook.com (2603:10b6:8:a3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Wed, 13 Nov
 2024 11:45:10 +0000
Received: from BL6PEPF0001AB4F.namprd04.prod.outlook.com
 (2603:10b6:408:ed:cafe::75) by BN0PR04CA0147.outlook.office365.com
 (2603:10b6:408:ed::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16 via Frontend
 Transport; Wed, 13 Nov 2024 11:45:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB4F.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Wed, 13 Nov 2024 11:45:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:44:55 -0800
Received: from [172.27.52.206] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:44:51 -0800
Message-ID: <55ea503c-e8a5-4dfc-a7ea-284e6138a45e@nvidia.com>
Date: Wed, 13 Nov 2024 13:44:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 vfio 5/7] vfio/virtio: Add support for the basic live
 migration functionality
To: Alex Williamson <alex.williamson@redhat.com>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
References: <20241112083729.145005-1-yishaih@nvidia.com>
 <20241112083729.145005-6-yishaih@nvidia.com>
 <20241112140151.3c03ff98.alex.williamson@redhat.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20241112140151.3c03ff98.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4F:EE_|DM4PR12MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: 68cefb98-0bb9-46eb-7651-08dd03d8a0f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RHZFNy9RL001alk1Qk1GbkMvZ3Zsb0tILzJFYjZHZUV3RDJkNm1LYXk1S3RF?=
 =?utf-8?B?V0lqdUF3MnRXeVNsT1VRbWZqQnd0azlNdWZTNmNFcXFUVVVnTUFoTzV6c3Fy?=
 =?utf-8?B?UFluU21aZHhacXNaV0FsTXovNGJtT0VFeExKZEkzeENQSXlKd0lFclp3WTNL?=
 =?utf-8?B?a1hqeElMdXFhWXkvY21IcjZvYzIraFNNUlhWQVdEd2gveXE5MG9RUjBCMFVT?=
 =?utf-8?B?Qkk2c0VmRzQ4ODJTYnpidjluMnk5QkRQdjdnWWtPVTVwOXRPd3VwMHNjY2dp?=
 =?utf-8?B?dmpCOHBGeisxQlFXYkhWVGNHaUtOOWNSNkJOaDRiQWJNWkpKOVdIRk9KZzdH?=
 =?utf-8?B?MEZNdHh3dnhZenhxYk5RNGt1SFhISXlwSzZHOGViYWMreUN0am9UaTQ3bjRv?=
 =?utf-8?B?VU1nNnllN0FUM3ZIekJ1dkZiUUNzN0NkVkV0bmZJSHpXcHFRS3VDQzJaVS9H?=
 =?utf-8?B?Zmo0S2NaMXp4NDFzTFVVbWoxL2VEQkNSKzRQZHNlVkVEVmlWdWljaFZDbTNa?=
 =?utf-8?B?T1hYNXNhenBJZ1dmM2g0MXhrZTNYK0RrS2NHNG45ck80SUx4Tjd6d2JRT205?=
 =?utf-8?B?VjRUczQ4MnNwUGkwdVJTOHlJK01HM1hKNTB5V0p2eDdiM1NWZ1VacjJyZ1Q1?=
 =?utf-8?B?blY1WGJ6bmFkc0V5RVN1Slg3YjlETDhRRGMxUXp4RFptOHEvKzd2UXFDbkh5?=
 =?utf-8?B?L0JnZkMxM2FGakNFZGZITzQ2dHFsdWtQVkNsaXYxQ3dXWDZOanEvSkp1M3Fx?=
 =?utf-8?B?WEozWGRFUWtsV0tFSE11cytxaWdhaFU5V2lNdmdZcm5PTWh1a3lmOGJsNGdN?=
 =?utf-8?B?NTZVdEhTOU1meHVFaDcwdFQ2eC9DenJXbGdmUU1pWWRzSzh1Y3NZNjJFQ2Np?=
 =?utf-8?B?QndERzNvUDJGbnlTVnNVU1ZhZ0pObnBtYUFYOXZaM0dudzhwVzdEZTFLQzkw?=
 =?utf-8?B?aFROZlNIN2N5Z0EwN3g1SHdFRDI0SmZWTnpVUWxqLzliMjEwek1zb3hJR0Zq?=
 =?utf-8?B?Z0VzT1ZaQnlPRW05OEpCeTlWMTB2M3JrUFhLL29YVHNROWw4NXNqRDNFeTJL?=
 =?utf-8?B?eXYxdDJqR2p5S1pwZFB1TGV6cFdwWktKRU8xU0pXMW9lYmFxeExYY2MyS0Vo?=
 =?utf-8?B?MWV1MHBkNDRQMnU3bVlPb0hNTHlUNklRRHU4eEtvWHIvTGRlc1R6ZEtQa2FX?=
 =?utf-8?B?QWJRZ016VlpvekNtVS9nWGF6eDJlYmZPYmVJWGgzcmU5U0JtYThKWDB5NkhX?=
 =?utf-8?B?ZEQrbjA3dEo2OG1IUzBIak0zajMwcUN5eXJVOFlqSFZJUmQ4VER1blNHN2dw?=
 =?utf-8?B?ME16U09SVWt6T2NWYWJ0L0QvUFlLQ1hyMGpuNlNZRkZGRnozSmJqWmNiQ2I4?=
 =?utf-8?B?OW56UXo2VlAyd09OaDdReGlsOG9NZEh3L0tKcWNwWjlQK1FjQmRpYkFiMDdQ?=
 =?utf-8?B?NUcwbXJ1Rk9NK1dORzMySk9vTzBKeWIxaVNxcnV1NE1NNEFJaGs2aHhxRjda?=
 =?utf-8?B?SEZUV0Z0bVZ1QTVEZG5vMjB2eWphODRDZ0hmYU1iVG9BOWlLU2tqQ0Z6N3BK?=
 =?utf-8?B?Y3ordXM5OXJRTnUwbG1hdW1QMXRnVDdMT3VWRDJRQlFDbFltWFhGSldpMmdN?=
 =?utf-8?B?WkhqeXlqaitSOS9CWVZBa0JVVHBWaSsvZERydHhnc0ZHbHhlMlZ1TGZ0aGhK?=
 =?utf-8?B?b3VoUHhkTVliS3hvTVpYZFNHTktDa25ZVzZ5dnBpM0I5NjU3MlErc21tK005?=
 =?utf-8?B?MUEzYmgzbjhSYlZWQkduZXRwUjB4ZzRyS1J4b3NvSGx2UVd2SDhXeWl3YUNG?=
 =?utf-8?B?SlBtd0JDMmM5N2xjbDdwRy90cGJ1d1pGQjBBS3lTOTdhNkpRazVqdUc4T3Z1?=
 =?utf-8?B?TVhEdEQ1Q09tMGgrVlFXZ096ZExteTdURk1HcURUS2VxTmc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 11:45:10.2838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68cefb98-0bb9-46eb-7651-08dd03d8a0f7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6279

On 12/11/2024 23:01, Alex Williamson wrote:
> On Tue, 12 Nov 2024 10:37:27 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
>> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
>> new file mode 100644
>> index 000000000000..3d5eaa1cbcdb
>> --- /dev/null
>> +++ b/drivers/vfio/pci/virtio/migrate.c
> ...
>> +static int virtiovf_add_migration_pages(struct virtiovf_data_buffer *buf,
>> +					unsigned int npages)
>> +{
>> +	unsigned int to_alloc = npages;
>> +	struct page **page_list;
>> +	unsigned long filled;
>> +	unsigned int to_fill;
>> +	int ret;
>> +
>> +	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
>> +	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
>> +	if (!page_list)
>> +		return -ENOMEM;
>> +
>> +	do {
>> +		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_fill,
>> +						page_list);
>> +		if (!filled) {
>> +			ret = -ENOMEM;
>> +			goto err;
>> +		}
>> +		to_alloc -= filled;
>> +		ret = sg_alloc_append_table_from_pages(&buf->table, page_list,
>> +			filled, 0, filled << PAGE_SHIFT, UINT_MAX,
>> +			SG_MAX_SINGLE_ALLOC, GFP_KERNEL_ACCOUNT);
>> +
>> +		if (ret)
>> +			goto err;
> 
> Cleanup here has me a bit concerned.  I see this pattern in
> mlx5vf_add_migration_pages() as well.  IIUC, if we hit the previous
> ENOMEM condition we simply free page_list and return error because any
> pages we've already added to the sg table will be freed in the next
> function below.  But what happens here?  It looks like we've allocated
> a bunch of pages, failed to added them to the sg table and we drop them
> on the floor.  Am I wrong?

You are right, thanks for pointing that out.

In V4 we may have the below extra chunk [1].

[1]
index 70fae7de11e9..aaada7abfffb 100644
--- a/drivers/vfio/pci/virtio/migrate.c
+++ b/drivers/vfio/pci/virtio/migrate.c
@@ -69,6 +69,7 @@ static int virtiovf_add_migration_pages(struct 
virtiovf_data_buffer *buf,
         unsigned long filled;
         unsigned int to_fill;
         int ret;
+       int i;

         to_fill = min_t(unsigned int, npages, PAGE_SIZE / 
sizeof(*page_list));
         page_list = kvzalloc(to_fill * sizeof(*page_list), 
GFP_KERNEL_ACCOUNT);
@@ -88,7 +89,7 @@ static int virtiovf_add_migration_pages(struct 
virtiovf_data_buffer *buf,
                         SG_MAX_SINGLE_ALLOC, GFP_KERNEL_ACCOUNT);

                 if (ret)
-                       goto err;
+                       goto err_append;
                 buf->allocated_length += filled * PAGE_SIZE;
                 /* clean input for another bulk allocation */
                 memset(page_list, 0, filled * sizeof(*page_list));
@@ -99,6 +100,9 @@ static int virtiovf_add_migration_pages(struct 
virtiovf_data_buffer *buf,
         kvfree(page_list);
         return 0;

+err_append:
+       for (i = filled - 1; i >= 0; i--)
+               __free_page(page_list[i]);
  err:
         kvfree(page_list);
         return ret;


Regarding mlx5vf_add_migration_pages(), I may need to send a matching 
patch. However, this area is just WIP to be changed as part of the DMA 
API series from Leon, so it might not be applicable for the coming 
kernels but to old ones. I may hold on for a moment for mlx5 and see 
when/what to send here.

Note:
Once I was on that to enforce/test, I fixed another unwind flow at 
virtiovf_pci_save/resume_device_data() to not kfree the migf upon 'end' 
as it will be done as part of fput(migf->filp) -> virtiovf_release_file().

This will be part of V4 and I'll send a matching one for mlx5.


> 
>> +		buf->allocated_length += filled * PAGE_SIZE;
>> +		/* clean input for another bulk allocation */
>> +		memset(page_list, 0, filled * sizeof(*page_list));
>> +		to_fill = min_t(unsigned int, to_alloc,
>> +				PAGE_SIZE / sizeof(*page_list));
>> +	} while (to_alloc > 0);
>> +
>> +	kvfree(page_list);
>> +	return 0;
>> +
>> +err:
>> +	kvfree(page_list);
>> +	return ret;
> 
> If ret were initialized to zero it looks like we wouldn't need
> duplicate code for the success path, but that might change if we need
> more unwind for the above.  Thanks,
> 

Yes, as of the above extra unwind flow, this will stay as it's now.

Thanks,
Yishai

