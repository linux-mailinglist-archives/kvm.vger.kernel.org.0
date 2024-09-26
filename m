Return-Path: <kvm+bounces-27591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4BA8987B6D
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 00:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98264284669
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 22:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F5C1AFB2E;
	Thu, 26 Sep 2024 22:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="epBka6Uu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FDE18CBFB
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 22:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727391376; cv=fail; b=qyIVpyKgIDlxnJ6c+HGrGvogAHQIqwiRzhlZs3EHtEj+4Hm5wLoxzOyhS/d4YOKOWiWsKiJUp1W8MPaSBIWUQEfcLStsySlYOJB907tieLc3LLXRCDVr7KIop1td5nsDBZIUnsVraqkSkC/9BX9ReUO8e8N2U6ekjrLgO9VQTxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727391376; c=relaxed/simple;
	bh=Jx+FMbcVx0DoB3TrOrM+6iwbJt8DAXcIMcIZsExlV1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Kx0/LEKg+jEoeyZZIIMOKz0PlBn+72lq+/LedNrBZz4iOyMOtLg4yNIjVROv47FWXwFS20dLqpI138aPGR3j5qQ2XhuFHhaO/lN5cStducjJoimAFo172yHHV8l7cWr0PsX7TsU0iyf03Xx4+fUnkGwGeZATj+AWTD3GbwnPDWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=epBka6Uu; arc=fail smtp.client-ip=40.107.93.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AugpG9sbtECNaTlJDoBkc261ErAOnKMyyS+pC8k1Uo2Vn6cguwZR6fbIXYwDQX1QONCRk+Se6LpCdQss4wAVr7v5MTBoQaHAC7zgMJBRoPnMew7b2yQ23ea14tNYnpSHouvejKYeY2O27Wlk8J5LfbqWTm4Fj3m665sIfyH4gCADRi4LYHRd1FdcAvVH9js8tvGU4DHHmblIxXmBAyvRjC60il823hF7DangOXD0klHPTa8pzaS42mGVjpB1cxoac6h8GDD7HAdA2fMohGriRDBhlmsI8rSu2ONeMEMu5KR4zWPnp5AM5g+aMGNMfjXCl5Luo4Ap8wMMTSkiuuQhKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KY5yKOKhE3m+akQJ7aHACECxN+EUeMn1pMTsnnPOOPU=;
 b=e1cbQLSdMh6R+tFsSyUDQXRsRuQNE/CPvw8euSQ7caxltfrzvPBx/IbzNJgBNnvFNoqM9SXW0lVFVlCbwq328EdTYiel6sshxVAB4UWtKFZnZW7gVscGrHN6fvCa2FeuxQVivWft8dd8yQc5bM2pTNjymnz58jA75RVJ6G9kzN/OiAJqtM2v1w1jqGetApGw+YdE1jeBvjLgJegisd7YsYqruEARZo0nrKxPLmOj1UE0QEJFd7NhTfd3DmDvV6obs/63DPHb9IJnWvvQO6dVjiAn+FNJSClQSob1Nr2HKrEoW5HdWxachKoRvPolwivpjbEmhD0D77g6C02VmpYgnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KY5yKOKhE3m+akQJ7aHACECxN+EUeMn1pMTsnnPOOPU=;
 b=epBka6Uujusum0ch0C7qFWTc5asf6HcgQ7e0Ssoa6g/HAIHMdaiSGn9xCrC9/ysjcsOAcsgObJPgk4oUjj3uRcvEoUPDVGt2WKBCe+t06OXeAGBT36fr06No0Xh+mGTLX/gUPTY4u5IrhWvHvko5mvGxFcLKTN3KIYwJ7siclbsDmcrdUtBgREj5HLnAnN9SQXMaAZY8ClOV4FbmtW830xhIRrgdoMl9dlVr85WGudkjCdM3FCKJiJz1F2onX+ExGz32On50yJrSxYf0SDyXclCUXOg9XQlAPsJjJcpca1ixYs1EnlADmbbvrspiAsZ/NC2VrW+H3vKIbuEW21M/0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH8PR12MB6794.namprd12.prod.outlook.com (2603:10b6:510:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.21; Thu, 26 Sep
 2024 22:56:11 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 22:56:11 +0000
Date: Thu, 26 Sep 2024 19:56:10 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, airlied@gmail.com,
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com,
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 18/29] nvkm/vgpu: introduce pci_driver.sriov_configure() in
 nvkm
Message-ID: <20240926225610.GW9417@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-19-zhiw@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240922124951.1946072-19-zhiw@nvidia.com>
X-ClientProxiedBy: BN7PR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:408:20::46) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH8PR12MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fc818f4-3a1d-4a9f-9892-08dcde7e6a99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rpXBBls+mk2CwA1kNv01Xrye3WLSpuUBkNEQsSNXbismJXck4bgL5SdNrKQQ?=
 =?us-ascii?Q?oYdIOjPVJxqFUpbsrDEHoax55+dcrPf8t4tXF6wgNakrFHgezSQPqs6ej3Rx?=
 =?us-ascii?Q?+M8OAOow811n97t6ScZ509euT8KPuZFL86iqxFPYKW0O4Tizi2pl0kOYqbe8?=
 =?us-ascii?Q?Bc4uS61p0ipobC2ygSMEPbot6oJj+x0Nk1AeE285BuegRBamSzyw2cpczHFx?=
 =?us-ascii?Q?Z4LnFzk12fjOJaOKFK123xxjM/db3R154IN6GdVzilAfq/FgZE77C1QP84qc?=
 =?us-ascii?Q?LPXwt5lw3EYHRsiTGxW1AiHhan1P69HcZYOOGaJ/yzMNrfs78ID1yRoprHCX?=
 =?us-ascii?Q?xeQEsjRbuiGXvpW0t5W0zRgjrxEdsvf2/vF0GGwmLQuGGQrU+/1EsZbaCNIp?=
 =?us-ascii?Q?iFwhAgxTU5EGj2cxqw4phQcnbnjfaCv84i0P05mn64mzSLL4+opZ/FwSzEM2?=
 =?us-ascii?Q?o7lHYrvYCnYCZ1t/gYNzQmAFuQPSsaiDhud2fwiI8Nhfb7oSFPoQjY6B0gHL?=
 =?us-ascii?Q?MsII0FtfWVcjs+u9e7lCGLZnddqyWk88rj+7+R2KiIhoE9ldsWsXIdeygq0t?=
 =?us-ascii?Q?Vvn5vW3e86sWfsvNPf2OrkMcoTCsP0P2mQ3Svhuj4ybo9gH90kAnwFFk/rJC?=
 =?us-ascii?Q?mIgptA5DgxUR6GOM8SUgE1mu/2Y8AXRRJPVECwtC/CDjKGC+iYNewJeFv0Yl?=
 =?us-ascii?Q?69OIXCFt8YdGA7Qs/Ouveo7hpwRilTnAZ6SQUFGwywkC4iYdeHMrSGm0HtKJ?=
 =?us-ascii?Q?jQrz3xSiWsEAZpItPitNOc0cwDEYJsCLMrKE79LAuxAbqV3e8abMC74ueFDb?=
 =?us-ascii?Q?3+ftRG9MZBvE0cgEibbE6AJYyq09mIgKFwlav3PsQrqZx9s48EKMt06l8q5e?=
 =?us-ascii?Q?TlmwaImNbKIogTylvmUu8uIoTQvOrJVTQMLzMqGjvMnxxnIGOhscvPB6+e7g?=
 =?us-ascii?Q?bncXPm38zGMIaK94kRrdkR6663bsmow8OHdVrFQMHUyoIg1ZzmsNCGrubVsq?=
 =?us-ascii?Q?uuWMGh50UfJuGwjw1AWu27JXOH3y1h6zDrwpS2g2ucKY84A7x+9cdtqiW2Th?=
 =?us-ascii?Q?7+DlGTFs0WMgE0mG6aTCjKT4mLKZLsbMKyxCP0NIn8RuHmD/H/WZOeVoMbQd?=
 =?us-ascii?Q?NNVYKY0W4oJWGQ22TN4rMDJSOfQlF2/Z3bH3jZ0dVnfl/Bk3OwFZ09Dxav8I?=
 =?us-ascii?Q?+HYUMmbKeNYxXYx3W8ar/Mq8IwpTv8KocRKIeI+yRDv3VVpLl8FfAeQdJn/j?=
 =?us-ascii?Q?LfViaTxJ8Kdp4LQZN+yRENo5tPTxAM/LMNFLBJQF/Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4mHw9852YbwXLNnkbVVjAKRJWfzU0YOxxO/Ts9m+6p7q2tPpdSQylSquNQVA?=
 =?us-ascii?Q?n59YZRqJ55cUuWQkAKHneUma2pI3x+siszlK2IYRcJPz/he5sCjagiU2gIja?=
 =?us-ascii?Q?JWt6azRbYHbwGMEi/9tH2vn3NjCUupn7owoMIlwDDziS7/PI4BBEJeiXcnzy?=
 =?us-ascii?Q?cJtkwlSt29byjcA9ulxrYWQp7BCWDqXrdyarRX0m8kdntYLRn6ei1o9kvpRA?=
 =?us-ascii?Q?bwSHaqThJQEv4JQN77/JIVTItVCv6eSBf6MJswzp3nY0ejKhBWs0305IgQuZ?=
 =?us-ascii?Q?pk9UA9A4gHlTY9hk0Z4CYdNI1nwKYTH+Ne0So7PiVa4UwTJCEdGXAFGPnJO7?=
 =?us-ascii?Q?UR5kjuWvR3gyN/ILlRrYacyhQmndjmZnO2MZ/v5h76Is9fgaFSl7Oybn0ADD?=
 =?us-ascii?Q?/Gl9RKyeVvhr+mKC6/ncZp+WaBdHLv9zTV8AGSjtQPVRKAL/Vc1HxKrPlul5?=
 =?us-ascii?Q?53JMcOeKqR0hCyy3+g9J8/QWYhPIpzmPS8O8AiBBCXVjx3eJha8WVgUHiqbq?=
 =?us-ascii?Q?XAhElO3fHIulj6sxzEM/lkZMs0RDrBFKwvENt7hKznmNm1JgMzPUGQn5AJ2Q?=
 =?us-ascii?Q?0WaIOEuKDxPzEhR1xHJyTsqoO30KKlTS37ovIWCqrGVfQAIZPQ8SpIgQcLgM?=
 =?us-ascii?Q?ep8xRmLjLzIswGNG92la7L31DKYZbBCBVml4vE7gDxVVvMv2RWEz0fdxJhlN?=
 =?us-ascii?Q?m2vYI1ZVAZkELxZitr8vAMz6GQTksg43lUXbs2e6qoEZI6JoZLo6gZurV37m?=
 =?us-ascii?Q?VRm/iYwJu1Ww0b8Gz+rGqKepQc8ylIdR2JIgxRnjygtXBSOvV5UoiEtl12Qs?=
 =?us-ascii?Q?FaDxxuBrpDgQxgaEOE+Z6ZLhqjP8FLaIQkzoNJtHki8GYCLDh9wmKCuNoNAz?=
 =?us-ascii?Q?jKT0ouYREzolF+7sK9bfh6j4/7LDhhnS4kXX87vWoqYZOBRc5NEo51jAb//p?=
 =?us-ascii?Q?m6bvB5qu7N6sBz30khlF3XTWT3xYsfWKElCemB8ohkaq14bGujPr2rujq6Uq?=
 =?us-ascii?Q?9XNW3t2M2oiFrZJy/Y0+Sc0Do/Qqn068OI9Xi+yaJcfaN7LCzS7WPA772EjU?=
 =?us-ascii?Q?hmYC3Y8xvJkY94whvDIonQPEDLe9ISUxHP0dkZ/wsStotm/iDdT8gkj0x22R?=
 =?us-ascii?Q?0G0sikqxNcRWFdgwlqGyZYKhTFy4as3yABnhYEyLXebfkJl+7f3hZ9kh/OQ1?=
 =?us-ascii?Q?AN9At5Eytlo82jrFm6c8Ft2LhD1m9DT6FwrRsgKv6Px9ztFn3IUIQNAsCNpd?=
 =?us-ascii?Q?bhoaw/yZxl9warVDtYGFnd5xwyaAk/zXeDF4kc+dYrRGEkZFmfT50jkyI4xe?=
 =?us-ascii?Q?wyWS5XSx7qx0y5EC3c7MH6L9GVE+EdYkQP/7/l7kPm0KgQD8sQu/Ylz5qV+/?=
 =?us-ascii?Q?2Foefz31AeMrrbSBX0CK+aFCYSQtJ3GG+RkdPZpGcY94oY8QMfmz8nL7Qmj7?=
 =?us-ascii?Q?+d/guV0Nob6r5KQFFzyfIwceZ6Z7TSdtwXfxctrz9KNeRWhq7zWGM9OMkdN0?=
 =?us-ascii?Q?2WszDfBIuqYzq9GZ3Kp2XOfrN5S2gFuJDZPlC7Sb0nPCu68sYJgKXuD5v5rP?=
 =?us-ascii?Q?L6ThNp/L3WVzY+PDWFU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc818f4-3a1d-4a9f-9892-08dcde7e6a99
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 22:56:11.7153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j7WjzH559XpYmnpLZCuIedD7/HMB2VEdbPvuvHxitrz4Oa6sCTBmaKWZSi9bRi4c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6794

On Sun, Sep 22, 2024 at 05:49:40AM -0700, Zhi Wang wrote:

> diff --git a/include/drm/nvkm_vgpu_mgr_vfio.h b/include/drm/nvkm_vgpu_mgr_vfio.h
> index d9ed2cd202ff..5c2c650c2df9 100644
> --- a/include/drm/nvkm_vgpu_mgr_vfio.h
> +++ b/include/drm/nvkm_vgpu_mgr_vfio.h
> @@ -6,8 +6,13 @@
>  #ifndef __NVKM_VGPU_MGR_VFIO_H__
>  #define __NVKM_VGPU_MGR_VFIO_H__
>  
> +enum {
> +	NVIDIA_VGPU_EVENT_PCI_SRIOV_CONFIGURE = 0,
> +};
> +
>  struct nvidia_vgpu_vfio_handle_data {
>  	void *priv;
> +	struct notifier_block notifier;
>  };

Nothing references this? Why would you need it?

It looks approx correct to me to just directly put your function in
the sriov_configure callback.

This is the callback that indicates the admin has decided to turn on
the SRIOV feature.

Jason

