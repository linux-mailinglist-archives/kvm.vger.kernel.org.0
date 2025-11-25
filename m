Return-Path: <kvm+bounces-64561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89A40C870A9
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:29:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 977723B4A3B
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C290633C501;
	Tue, 25 Nov 2025 20:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BzmIHsqM"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010000.outbound.protection.outlook.com [52.101.46.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BADC2737F2;
	Tue, 25 Nov 2025 20:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764102575; cv=fail; b=c2bSBjBsRh2gfSug34/bysYeixiNYVBZc00T7yBsZcckub+Z00XYRUV9YvoQ+Pp+owN0XB1dRiEOWcfnXv8LS+au9P3y/2l9v3LcIH0mVYSwRSozF/ypoCfgSTiQRmSM3EPx187VxYx5b42BdpLXoOWqX6Ea/mEiRjvVkPcT99A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764102575; c=relaxed/simple;
	bh=5Cdd7qt0jx9OuuRNgLkX1vzcDigu/f//1H5hV4vsncw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t4l9HbiFti6tiVoGLsJJUx4xEIyYcPa8VqurUmeOV+8u8Ui1Y4f44wgolY+vhhefuakFuk408C7k2iCJsMQEVVwCQ8bC1f8wRxVbf2COApBo0qQ1RZBPF8PG6QzbPSTwM5pNQyrDV7cakqny2EQjuCYiN/hNgWDylHs57/zbc2o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BzmIHsqM; arc=fail smtp.client-ip=52.101.46.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H5WyHRwYqrz++p7xQwS7aZbl+tH6qBG/fDe/ZngQ7aBSInP5y0bFgjx2WyB25ss5940XcHRY7rJsGlAUEcTgFSjrI+lf7Pi1GUr6cgidi+ioLSOwFxIS7JLbIKBMwHG3DEI4Ng3J+wPsHSpE7/FNk7jgsmqoqR+d4J0vEkeWRvZoR16nfIecgi1qGWS+v1KTeWRIJrn/yhxaupr/pNv2CCgvAvm1r9lWg8s+0QLDwaDNkhS6WVeMGWcvEqBZPEcv2IMdZpqcHAT76nZRGzhJ2dscEykxWWwx/+ewjDPuds0toY5IU5UbvlUJhoYsvHQM6gJe5I+xCACInchQTiW66A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fWsiQci2lC15YznIuSRmxlshitVwMJERqgAG7F4tj54=;
 b=CKsxn6KB/Hqe72aMwNbY/qvF1mccGF8Vkt8oSC4M/aKUi01EjdzK3gkUhJ01LLMAoOIHAZTkyoVUHjluxXeDdlgYAcza7l0by3eCRF75aBNi3x5d9gr97hfgTe0o7lnfB5dw0HnxpB9EM9lYFcpDBbTtwpzSoyOB7n+TG4/g/0wZKkDWEyUqHiFa/xFBpaTtpBC+N1iNBv4Z8r2yjWpdN6PcOa1CiaWRAfve2CCH8OmKYnjXg/Q6gmXEeKAux5e1brAhHZq7gkVopegZnKNT9zuSt1HkkbVYVzPZh1JGwJVKPa4I4Sfz0Jrafk9Fhew2pApW1mbpt/CVdS2/Z7UjMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWsiQci2lC15YznIuSRmxlshitVwMJERqgAG7F4tj54=;
 b=BzmIHsqMWxR68ttfrTCHoQdIVfGGlHBUL9iZQ4DcDD62ZKpNJqRM2EKpzyOz9QgYpLegwoEMEzPFhEDgYApiNRW0lmZfmBMbzOKGXkxm6U6yl2P54o/8EANHPpI9divHAmKGDF4Ja4cUpLpf44J0ZIr2fNH2Bb2ESsfI+S1PjW8SG1ZXgnSIfqa3t9gicRqiwibuf2dy7H3AP2tqxhhcJUs7qaWflkHIz9pQNDhrAOVenXyH1MK8SHNO0c0gdlP5x68sioL4Y2ZoVEhGkBNNSF/rxr7Wh3TP0eK8/gLGQWiU9zXFu3ST9xlaCdlWyBo+cAfbj6XmqYLuSvbRDEeRmQ==
Received: from BLAPR03CA0061.namprd03.prod.outlook.com (2603:10b6:208:329::6)
 by BL3PR12MB9051.namprd12.prod.outlook.com (2603:10b6:208:3ba::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 20:29:30 +0000
Received: from BL6PEPF00022575.namprd02.prod.outlook.com
 (2603:10b6:208:329:cafe::12) by BLAPR03CA0061.outlook.office365.com
 (2603:10b6:208:329::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.17 via Frontend Transport; Tue,
 25 Nov 2025 20:29:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00022575.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 20:29:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 12:29:07 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 12:29:06 -0800
Received: from inno-thin-client (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 25
 Nov 2025 12:28:59 -0800
Date: Tue, 25 Nov 2025 22:28:58 +0200
From: Zhi Wang <zhiw@nvidia.com>
To: <ankita@nvidia.com>
CC: <jgg@ziepe.ca>, <yishaih@nvidia.com>, <skolothumtho@nvidia.com>,
	<kevin.tian@intel.com>, <alex@shazbot.org>, <aniketa@nvidia.com>,
	<vsethi@nvidia.com>, <mochs@nvidia.com>, <Yunxiang.Li@amd.com>,
	<yi.l.liu@intel.com>, <zhangdongdong@eswincomputing.com>,
	<avihaih@nvidia.com>, <bhelgaas@google.com>, <peterx@redhat.com>,
	<pstanner@redhat.com>, <apopple@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <danw@nvidia.com>, <dnigam@nvidia.com>,
	<kjaju@nvidia.com>
Subject: Re: [PATCH v6 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be
 ready
Message-ID: <20251125222858.7839ee83.zhiw@nvidia.com>
In-Reply-To: <20251125173013.39511-7-ankita@nvidia.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
	<20251125173013.39511-7-ankita@nvidia.com>
Organization: NVIDIA
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022575:EE_|BL3PR12MB9051:EE_
X-MS-Office365-Filtering-Correlation-Id: 67e546e3-7e4b-4e84-3b8d-08de2c615667
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gUJLc17ASntMWzoH4kbYv3vJRrUYm3mR9SFaiS7S3DfqzaqHbfvIGM35h5rR?=
 =?us-ascii?Q?72sHZj4/hPGmMcfRh8xsroXzeCAdYlE2NDSUeyhdAWTQ9o3r7VmH2QJWu7p+?=
 =?us-ascii?Q?bRjXejQxf3GvNvqJTklx2SZFQLivHbiEwJUNEY3GofQ0CJoW7Q46ffwBssTv?=
 =?us-ascii?Q?0CpKX3xZPCRC2pldGwy0/kQOghMD/6pYHEGNg688c5V2ig0WHA9fkEaJYcAc?=
 =?us-ascii?Q?NJiyrr6rmp/jyqTHq6CI3OYPEIaAQs14AqqeOHOjYAawX2U4hMmKPPvsNLpT?=
 =?us-ascii?Q?JZWQdAEET2SqvkiJ3etj6eswAY6JfbAjDtGnW4Nfie3BqfgAAcbRYmbekmb8?=
 =?us-ascii?Q?3zwRySXCIkZqb6jlfZxg/dabX5z1kUrLXdqEtteQ7aGPKVeKCRsOgYkr0Thz?=
 =?us-ascii?Q?+x8YVQlk7giu6riG+UuUvIWyPHWqFyEEscJgiUny1jzBTN7RkEeiKymvarKh?=
 =?us-ascii?Q?d6oiTFZTOspbz/ylfP7U6v3fHCh9NYX7m8GXTxbe/UYSYm5I233kSbiSQN4V?=
 =?us-ascii?Q?dGwxpC0njdraFQFGjvERmBhCMC/pT7kqWEmrbv808/DNmHJnDPwgC344iW+c?=
 =?us-ascii?Q?sNtuLXUG/eZg9GrcdHy/U92LKags/+NKJdEssvRjGOu7qmeLWtyfLNlG3FAq?=
 =?us-ascii?Q?kOvVGebylMhYZM3w2R7lYLPjdUGELOZ5cYwchGvpjeEiNDAndPmApCnNKGI6?=
 =?us-ascii?Q?kpC9hzBYbK/oGGvID11xICnTRLsojlfZHpjt9EuGWPHVInJvUEF5BIVpVASh?=
 =?us-ascii?Q?MwgDvJN/y7chDyDF0IGYmZ7jzQJh20bsVpZ1C2ZQXJshpsfaAhGZH0lmoklS?=
 =?us-ascii?Q?BlHaJXSWpiRjvkenHRSHVyIyPM7123t2ZmbHXQeONCWFq6tVfddcqzUrQBIQ?=
 =?us-ascii?Q?rZPepbEdJwUJuYK1rpQvlqcYfyBs3fDe+nX5O2XI2mRZbsjbj04VoT97XSTf?=
 =?us-ascii?Q?EpTv1d2O71+ashLOr25tVUsPm78f0A0tPhJjH/LD2G6hRabyVEZY33NwW9Ez?=
 =?us-ascii?Q?3QNxPxkRwP+DGsN3+JJOE7wiOWgWF7JeeR4+Qqrn1Q/FyNIFF7htFZ6B048I?=
 =?us-ascii?Q?nbNaYLTsByyUKgVxVSRA6QLbPZnji7Ssxhbi4GA9unz2R+K/NYb2dXqBIXin?=
 =?us-ascii?Q?sYCMIbrlmcT44MS51b1ucbRAlxCKVjf3lVuAuy/9Shjf/0ykcNMLRB6PGAmA?=
 =?us-ascii?Q?Ewx9qmiITqsegaIM2/Th2clDvncW+1TuZtGh4qwv1jh3UNpUBkJmZ79L5wm+?=
 =?us-ascii?Q?xX1CPe7jtmQOs3+HSlEAqkcnCItCRqALI5pm8N+o7Qxtxw35obCgD7HvpdSB?=
 =?us-ascii?Q?xhmiEMbiFMGdFzjfnhk/kLXCDUV+zhANH41muPdJTe8Ry554kS5w0cfrtUSy?=
 =?us-ascii?Q?NWlOJAqNHXzvR3yXbHpAF2moykg5FgJybsAkx+0h0mNd77r0gidcKON8PlZC?=
 =?us-ascii?Q?kAYxUH9swwGbVV5koWtwbJLOfqKznaKLgMbDfO99MTD9zeKxoP41JIjCc/jp?=
 =?us-ascii?Q?aBN/rbgBbTmECkbIfuYBhxTlmoLIuxvtiZFUZYvs7mf6xw4vNfbj6knjIPOi?=
 =?us-ascii?Q?xQ5ypS4PC9Tb7b6DtRs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 20:29:30.3889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67e546e3-7e4b-4e84-3b8d-08de2c615667
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022575.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB9051

On Tue, 25 Nov 2025 17:30:13 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Speculative prefetches from CPU to GPU memory until the GPU is
> ready after reset can cause harmless corrected RAS events to
> be logged on Grace systems. It is thus preferred that the
> mapping not be re-established until the GPU is ready post reset.
> 
> The GPU readiness can be checked through BAR0 registers similar
> to the checking at the time of device probe.
> 
> It can take several seconds for the GPU to be ready. So it is
> desirable that the time overlaps as much of the VM startup as
> possible to reduce impact on the VM bootup time. The GPU
> readiness state is thus checked on the first fault/huge_fault
> request or read/write access which amortizes the GPU readiness
> time.
> 

snip

> @@ -179,8 +215,12 @@ static vm_fault_t
> nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf, pfn & ((1 <<
> order) - 1))) return VM_FAULT_FALLBACK;
>  
> -	scoped_guard(rwsem_read, &vdev->memory_lock)
> +	scoped_guard(rwsem_read, &vdev->memory_lock) {
> +		if (nvgrace_gpu_check_device_ready(nvdev))
> +			return ret;
> +

I would suggest opening the error code if we don't have a "bailing
out without touching the ret" similar to vfio_pci_mmap_huge_fault(),
since this looks unnecessarily confusing.

Please also fix the same in PATCH 2. 

>  		ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
> +	}
>  
>  	dev_dbg_ratelimited(&vdev->pdev->dev,
>  			    "%s order = %d pfn 0x%lx: 0x%x\n",
> @@ -592,9 +632,15 @@ nvgrace_gpu_read_mem(struct



