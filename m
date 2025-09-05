Return-Path: <kvm+bounces-56883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B493B45941
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 15:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 819B44838FA
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 13:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9630A217F53;
	Fri,  5 Sep 2025 13:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fvHNpAuw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2042.outbound.protection.outlook.com [40.107.96.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAC634A333;
	Fri,  5 Sep 2025 13:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757079390; cv=fail; b=B4VTEiFDUXmqvgoAzpwrE9AUdQlulAZdAtHOyXaxAfx8hobqFTregy/MjORJjmJ4KG1Rz8LfzPi9y7SrH/RgmtAhe3s75dRU/iM5vpxHYwxn4f7XdGElJTJbXB3w/SwRpjIf7qd8rDCTT/Rg4ksTreBitkonmKO0drZz0TiksHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757079390; c=relaxed/simple;
	bh=FwQnlaKoRv7HE71CsDvsqin1PzXqpMHPJX5gM02Kugw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EXVhqX3TMbh6MdROA/gsAzUZKDtyv5K+uG20x7Eu5AKOfUtDxcwK9OQH6FDh7wQgRauq29FxudlcrH4TVrqSDygZ2rfQ5CpssKNhEgG/I04uU3yp6xK2lS5AfnacqIC3s1r+IvUs7vb/286iTjXgW43bAJbNsaPF0G8rpvYDUrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fvHNpAuw; arc=fail smtp.client-ip=40.107.96.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N/k277MD1gr39WV4oY2X2EDRhB/+pAj1G91CkByIGLrMx/bS1TM7W4A7tuZNW3KFTJQ3o22Wf/YTnBvL8na/E5PAinGMZ6/ECapy4MjokPau7BcIoFF9Ud2beXorGuvw4KJM/bL3e34V/qX+KP5y2XVlgBEY28KugTn2INeNNku1kfpOL/f0twtNrPMrWqn+4zGKR4uurBRyI4xXXNWS8Wd+GKtgaAe/bYLKBccy8pUNuOW/HHLZNGLMJ7dU+fCTiQ6tB7KI5cfp/M7FELV/G32AWvTX79jS+EGQH0U5XkPYk5paNyjwC4nuMVFeLKjSnj/dXZiELwyew9fWsvu7iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HpcXKCmMKBZRBEze62pilb6UKfZTknGX1y+0FM1i5tI=;
 b=uQrR2EZHoekof+iWTtqF3VXOxJVCa1XmtrIpRzLYqWdVTuesF1OuDoMQGjjHtsOQoyzUFaPGnqEQbxxIGKsSuTUSw2BOROg7GidfqdncfBtUXq0zTDmgdwyW/qenusPac8HYFB7UG1sV4ij0pvM/v/W3xbxunESp0U12cR6JTk4oRVm6BJ/KlbqQaKuFC9S+E8Ecbu94yTUk7yaj7+oDelLIhxbrFzf76DLfObvFUK74Mn2e11+0BL4oT5WMIFr5wtf9oTYmB0soSxjX/nGBWzqOE8uvO+EHMEvcEtd02QWQWaKgPe5+Xb2uK92QBk/6tREB3Z3x+37neeKuIjR6sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpcXKCmMKBZRBEze62pilb6UKfZTknGX1y+0FM1i5tI=;
 b=fvHNpAuwGt0dQ3d0F3wtJulOKf/5pNb1qewTOI34SlwYNXUwyGCUsbT1xz9uE13e1arwnQdpCuNTh82CZxd7QpZZHF5lymJWlxFk8dbpWUVy4lNOG57vh9cJVtK+/ThaGxAEiJE+KqVKNDFSNbaIrOsD7VsaRUT3UgEW4x+p6JATbSWfsfL1jMIx0Xuz0dwFIshmvUm8hcYabLUuaD2UOw2T3lxQf/oPIMYpF56uVdtp2PArhvIJCMekV1cfyMl+PzZ0B0+oEfK+ZlR1STH0KbVqDEXx5d030nDQC3yFGXjeSEjaiw2ZvBdiopaIxIDEtXUTbhyuphBSrIGT3JcSEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CYYPR12MB8871.namprd12.prod.outlook.com (2603:10b6:930:c2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 13:36:26 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 13:36:26 +0000
Date: Fri, 5 Sep 2025 10:36:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: ankita@nvidia.com
Cc: alex.williamson@redhat.com, yishaih@nvidia.com, skolothumtho@nvidia.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, zhiw@nvidia.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	anuaggarwal@nvidia.com, mochs@nvidia.com, kjaju@nvidia.com,
	dnigam@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 09/14] vfio/nvgrace-egm: Add chardev ops for EGM management
Message-ID: <20250905133624.GF616306@nvidia.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
 <20250904040828.319452-10-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904040828.319452-10-ankita@nvidia.com>
X-ClientProxiedBy: YT1PR01CA0044.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::13) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CYYPR12MB8871:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f5515e9-71b5-4cfe-cce8-08ddec81364c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0ySkRLL6P8C1MlHQIqH5/BG/obu0w+v4Zvzjvnna/u3i6FvgIQqNfEvA+qt0?=
 =?us-ascii?Q?XamxRaBRHLvZUz0UhPSvvpW3wwtMc7xhe+22AMdcuhvhfIT43p+xU3cwcWNP?=
 =?us-ascii?Q?o6p+TGdqxyPSwQ9BAlYq6GtJa5O24vLbDam/MAm5jMBKV1WE1NA7mnvP0yOB?=
 =?us-ascii?Q?pKaxByjHw2BOvjMVVs2yLMJ+KKSPvV+/VPGQcaakkBr4H0CCs/ArGZ4/39oY?=
 =?us-ascii?Q?3CInHhL2XjoJKt7blSOGfehfKiiPPly6uKrUrdPwVUVKf2COzM30pfeCOXFv?=
 =?us-ascii?Q?WRtB7ugsvA44dk5k0PJgh6x5NnSobW/YT/r5wqT1/E/ZjupdKA1YJVcUwciX?=
 =?us-ascii?Q?kgi0Kdjy6jsh/P7xlZ1qMm2VqwiuUoC7PXq8TeHFK6othQpxJyRT4NuCOk86?=
 =?us-ascii?Q?JStW8EWzK8DPmkqxVu6zAYaXc86/2c2e9P7jBlpnPCQEVOz4bJI3p7IVc5Ty?=
 =?us-ascii?Q?Z6UAbL8DVRMrrIKjHDGD6kPLxOCwqOixUo+ZvE6GjuPnk0Ebhfvh0Zk+3gXr?=
 =?us-ascii?Q?SwbQlikSS0t2OBg019RUnPKCBlmZ1Qc3IV4ebYpn8U+ZtPD56zF4oBKCNaeW?=
 =?us-ascii?Q?+Yx82lEMuleOcHOBzPI4t7Df4H14mF+Sz40SDxRS4PlJtJWCNddrAo0j/vcH?=
 =?us-ascii?Q?wzQygHIQ37tph60JfifDQjv6zPjRAwTqQzT9Pi0eOh5C8ca3kBDdW+oWS5T/?=
 =?us-ascii?Q?E5CdY/Ve9GylP3ls6UXVJrJLKPLWY3Upd9Q66iraJIGojb5o5TEFP12nVuOx?=
 =?us-ascii?Q?dNflucegU02J9R8WettiCrnYSF8Du9QpAFtgensC+MekGX/Qb1umellw4YOe?=
 =?us-ascii?Q?VeSvenc/3154hHa6jseHf1UXBmTj9/M2+Y5SoRLrExE5WDI840w2c+3QAKYR?=
 =?us-ascii?Q?8CAkx+Gt7pKVTK22Nce3dVFHekYC/XTC5yvKJQRXvVDTnHIoOlSbSYl0t6hf?=
 =?us-ascii?Q?sNXlveZsu++1Ezqb+d47FkLmgQjz9Yjp8IQLQn9p4BS4C3pa5sTf5eUcdyLI?=
 =?us-ascii?Q?At9mV5tKT/HTQ+vGcwEvF1HttC2NOE1WvqidUZj4t0HSMCYN1gBUpLltigaf?=
 =?us-ascii?Q?fZcgEn0gNbXVKLcu+9U8ynqwwFr8OhL9JdpukE/UK5t3GdNCkBejMedyAGPV?=
 =?us-ascii?Q?Emkn05X+f3QFxJbdAt5BHeto7eru3cyZ0SxzjCw1TC3BNxPB2WLbeyFndlFG?=
 =?us-ascii?Q?HQi8DuP38hVXip5/Ejs3xd1u+lEeMmh3jIY0tB9q2XBLV34epqX4yCno0LNO?=
 =?us-ascii?Q?aTQBqO7B6dPYP+dCAjzx4u9LKb1y/IO7sYENVS4DRyfV/W8PyCDM3fb8baQ0?=
 =?us-ascii?Q?uvo2+r2BLxTA0zt7+h+6x0cgmNOASgOGUZRYSY2j9Y+TDmTkTU2kgpY0axHz?=
 =?us-ascii?Q?cxUTxz5DVKZKAE0xWIE84wG+E/t6hk4Pla3/mZ8tpqZpCyaef31S782dc85g?=
 =?us-ascii?Q?Wk0iMSIwf6g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P7eZ8ijevNQ3/+6ceyPddLS8TX7gmGcaFyPIBwa6T12La/ShepNCKRUKAY7S?=
 =?us-ascii?Q?Tka8hnvJVqAMITYvIgfh/K9s4l23+czvWYI1t4At9+22gKoinjU56Q9NNLEu?=
 =?us-ascii?Q?EUAWyM1Ij3npS6CuEqb1RqdLE1J+QF2w5IEuJzn+8qospxM+AonEK+OEzKqt?=
 =?us-ascii?Q?iSn86+3asR14PS27tmKnrgo3qddW72nKiR6RsT39QtwiMBJyukAGLQU5nW3V?=
 =?us-ascii?Q?AMa7nqrAhRIRBsLKCNsRx+AiKYswXauHXlJ407W79M3kImF2Rsw9liykY9um?=
 =?us-ascii?Q?HdDyjow9QNl7LqOSXlfbYLP5kYILs4DOICJDol1iO4Qlu45CGolS9tXUuh+J?=
 =?us-ascii?Q?E4usCkrGsFtImv8RMHO4wQIhtSfDE9bvmuLz8Ans/m23Ceibf4ia8x/zMR2t?=
 =?us-ascii?Q?3pIVvzUfLI60/3Xl6ILO0sfhCrV2MPbj7+/ulK3LW3I9nRzts16t+IBzhJSZ?=
 =?us-ascii?Q?Je0DM094HW5CwmF+rJE41XubUbGL6A8D3tLOLwv8BR2xPMesSNy2bp421kHs?=
 =?us-ascii?Q?WoghlJdxNrn2ABl8TBQKm49NjXd1ChsNG87rh1s0dMZQTNUsbHGTMPro/wIk?=
 =?us-ascii?Q?eh2qQr5h+5nqJ4QyedQy0X7PKQeUTikIUETwsvCZtADTozcCfvCRyy5n44AG?=
 =?us-ascii?Q?FGKAy7l09RtowCyldjuG7L0ugXrm+vT39iyXMDUK+aUBA01jCdbdQhSc814h?=
 =?us-ascii?Q?h/CwMNFYxDSatzI+f0YGt8rEF9blGlretDO8QtCiO0LR1sAvoW3NtD3QsZjN?=
 =?us-ascii?Q?yaH1q+OeUwNqzNpezRpqSIXdB+lnRr/WiDA+WC2Geskq2jF3nwtm44RK6jWH?=
 =?us-ascii?Q?kQADoi7Cshpe1kj0dttStbWU+HeW1/986tNR70C7OmNr5cMMrfDWUSJ66vup?=
 =?us-ascii?Q?pN+4A+KXXAfYnOA9/NKK/2wdekADoN4YeQ4vkI5rG9JVVcWczpOrPEbRzmuo?=
 =?us-ascii?Q?g/N2v+fTExUju8CpIPRaKBbFsGznefFhRq7mnxclYMx3N4yo6VgijrdmCSyG?=
 =?us-ascii?Q?bYZz30Mas8Zn8WC8Q8oalYyfbTJoZ1Wp/I5J0fpYkVeEA27ugfzMfimfKgiA?=
 =?us-ascii?Q?NpqtC/Zn51u5qDLAjCmVd93y8Xb8ne389P+rru88P8OP6P4xwqIcmXhhRQYv?=
 =?us-ascii?Q?/dKGGw8t+WBVZCw4DLrKvSsTstDyeJ0J/2v8F1AuxSVoPba720WCp6BQJw7q?=
 =?us-ascii?Q?lRacoSUICiIhZCi8D9Sgxh+tu8h+NXNwy4SsLLb2yJDqSnJUxYEcGPSBvPlu?=
 =?us-ascii?Q?sGtKU5vy3a2T7jZyavsHxsq+/BmhtnT9oiFGTE8+r4BeTZit7Hg/at1Pcd6C?=
 =?us-ascii?Q?TufTfoiFEObyRoXzN0AGBLB7NTANc5VhZVR1CB8zgNXgPyYnhqBsqxhrlszL?=
 =?us-ascii?Q?Xrq79iAc4fTrPGRutrgHnQsXQynqzu0gUerrCce1G+445uIBsdkMhKvoq0iD?=
 =?us-ascii?Q?bdME9QkqRp+yC6FA+DtgnebJHOgq/yGj7UJ4ioF6/FpJocjcicHawnrfVxlH?=
 =?us-ascii?Q?RfkfWcfyrX7fmv6yAIAWePCM9zO6cua/7wXRXV4ldZh7nSi/lnunGLArHM9F?=
 =?us-ascii?Q?tLT0CSq5fpXMd32XEg4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f5515e9-71b5-4cfe-cce8-08ddec81364c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 13:36:26.4392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36RFsWpfUyV6ZbVuwbY/LgSGzio2am+f+ohWf6w6nNAx7mjd6cTzadQER2oAFxC4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8871

On Thu, Sep 04, 2025 at 04:08:23AM +0000, ankita@nvidia.com wrote:
>  static int nvgrace_egm_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> -	return 0;
> +	struct chardev *egm_chardev = file->private_data;
> +	struct nvgrace_egm_dev *egm_dev =
> +		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
> +
> +	/*
> +	 * EGM memory is invisible to the host kernel and is not managed
> +	 * by it. Map the usermode VMA to the EGM region.
> +	 */
> +	return remap_pfn_range(vma, vma->vm_start,
> +			       PHYS_PFN(egm_dev->egmphys),
> +			       (vma->vm_end - vma->vm_start),
> +			       vma->vm_page_prot);

This needs to handle vm_pgoff and sanity check end - start!!

It should also reject !MAP_SHARED

Jason

