Return-Path: <kvm+bounces-67990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AD41ED1BBC8
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 00:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1CDF8300B89E
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 23:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D342C36BCE8;
	Tue, 13 Jan 2026 23:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RSZMbuHP"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011016.outbound.protection.outlook.com [40.93.194.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C31136B04B;
	Tue, 13 Jan 2026 23:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768347489; cv=fail; b=RmaXK+DxgHRMpSlbT6aT92O7Pr5rP/kz69E+Y0TPkMMIB+k+7Jl63UJ1oXvfQ0mC+hJqJKYD8bUXvf9fsmXS0c6bUfzkZztbpXVj6nEhiP93GaQNwqU+eHVk2nkC+209yLgbPwsJpnzkIut4CFrAJlDLN9pduSLedh7OK2O6IDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768347489; c=relaxed/simple;
	bh=W3QKDvrRzkaaU8WRePEMQPOyKuTLA0+m/jDIefSAPSc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bfc1jQHv7a29IBsVMTc0AFA7+Rn0dnwTMNLP0LAfK3uLrId0rEXRYSed7jkxOtz9l2r8cWYuXpGXjdqBHhsRbTVaWHMrr5DHP18KfJTf9zgbLu9iA3hcZBzqZUu34K+K/9g0OGyS/W6GgIAVdHFSUUaL9+MyE8GhVmz1zI+sIEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RSZMbuHP; arc=fail smtp.client-ip=40.93.194.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ReLxHC17zSZELsIwQKr38KsB5lbYdqoLg4FvbI0FCbnsTLjrCN8hGwW8pKVF2SQYZNo5VHqFSKuH75/ofFwU5yGTKN5hXFnBPBXtNb+NYDbh6YKIneIIt26CadJbJl7NGeXCWXqMjUsOBSiPKyC0y79tSBL/hEK8+/sh+9xf3OpDROEYytP2EMiu0pWHvhmjrz3YCRmKPjnlPzpFToHJN7JjeGSz4LS3UrlTssuM1NsUNgsgWkdyfy4xYC8stzns+buttpDfR7Xtq9xLHpOr1xjnPbRaudPYzJcLo9GUKbVOARH/bmUwzhqxgzkh2sxLli3A6q4STpqW9QJN3SeXcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fnKk9XUw9zPWLaUi1Id/9JXuBKrPg6kFb/CR5hLQp7M=;
 b=SyDpKPwZaq0ZVRNk25hiP0st/IrPG51Vy7ip3NP3wgFNyU8Uc3nSKsgcxjhmBy31h39vvjjwgPATJ5X/7ahJ4SS9eiAaiVlsET6L1H6AQusKREI0vYZW3V6k/L7MhLIiDhSYNm8oAbGWXsjPxh1glasWMC4xeSMIdBho1/Lg/uxRCRvC3aMnSxaM9ynCyvtG5IxLW0K2wu/mK8Yj7PZIs6C3f2tEdtc9yUO4rQMErOVNHoEehSvwGMWXsAXXjzsIUG5dC0eN/MvBuhY4fDptP5m6PnspTAnGk4dkJPNqhmt1DXuttMetewaDOJrBoYjsDoU9hjLnzqwz33r46MivIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=nokia.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnKk9XUw9zPWLaUi1Id/9JXuBKrPg6kFb/CR5hLQp7M=;
 b=RSZMbuHPjYWpp/vxh9J+zhrWaEnnG9+2qpDKfi7HJNqIoD55Cyas53KqUvW0LpsIZDbUQdNjaTJCnlyCp+HrUM+xjE0XlSrdwqfZv64vbUlxKemPTcOMt2bzq0qDTFe7UYsooJ4OivusemmPSerV0wXu/GDGCrM3NOA5cZsuSCnHP0upuEEgvu0rN+WBKyV6Igtl52U/Hk+ayavDaJFObTjenAwwcXrP2nD6uTuMANIL1G4u7d4426YP23cBMcdfw+CgZNHbEyMFPWLe2gJLc+BIU8Q0zNnwuVUs6+NAdrCmNe+/4IQ5QLuPkt5jwtWl0UPyfKcDW5aClWaemHy9UQ==
Received: from CH0PR08CA0005.namprd08.prod.outlook.com (2603:10b6:610:33::10)
 by DS0PR12MB8365.namprd12.prod.outlook.com (2603:10b6:8:f8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Tue, 13 Jan
 2026 23:38:04 +0000
Received: from DS2PEPF00003439.namprd02.prod.outlook.com
 (2603:10b6:610:33:cafe::9c) by CH0PR08CA0005.outlook.office365.com
 (2603:10b6:610:33::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.7 via Frontend Transport; Tue,
 13 Jan 2026 23:37:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF00003439.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Tue, 13 Jan 2026 23:38:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 13 Jan
 2026 15:37:47 -0800
Received: from nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 13 Jan
 2026 15:37:47 -0800
Date: Tue, 13 Jan 2026 16:37:46 -0700
From: Alex Williamson <alex.williamson@nvidia.com>
To: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Nathan Chen <nathanc@nvidia.com>, "Jason
 Gunthorpe" <jgg@nvidia.com>
Subject: Re: [PATCH] PCI: Lock upstream bridge for pci_try_reset_function()
Message-ID: <20260113163746.107aaeb2@nvidia.com>
In-Reply-To: <BN0PR08MB69514F34E3CA505AE910F2F8838EA@BN0PR08MB6951.namprd08.prod.outlook.com>
References: <BN0PR08MB69514F34E3CA505AE910F2F8838EA@BN0PR08MB6951.namprd08.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003439:EE_|DS0PR12MB8365:EE_
X-MS-Office365-Filtering-Correlation-Id: eb46b615-a22c-46bf-261f-08de52fccbf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h/L4f2YW1VakyxFEPi2HYHbZ09e7Eg8nRkW+ZMyLIR63jF0xHHKmAKv091W9?=
 =?us-ascii?Q?PMA05VsWSYsooM1MK9fmGyuPAMRNza0rc+MKckMZxiLAi5pVo7bGpRjqh5rV?=
 =?us-ascii?Q?vJTMsZ1bEmYCER6d4XKPVtilR07YfbM1FZEBqpV6dIfxDagp+khilY5TBZVw?=
 =?us-ascii?Q?2eVpaF09yT8q/y3pXJ4Nqpm3EVAfHmy4XoyptV0E2DoiGJJOBD8e2afUAWAE?=
 =?us-ascii?Q?YQtLKT2OQ+Hb663kg/4+sDHLMDVorD9ExTmUySz/S8wj3g248ltddKXfa2gz?=
 =?us-ascii?Q?VlcOkzGcbrvjZUgULSOQs+Rfx1cPwIaxQ0JfnFiMGn1slGkFtmQkZWpvp+Zk?=
 =?us-ascii?Q?p0VeRp5rzfnMmvGJQWhrLBdxxhK+TT1xtfv3/lhkbbeYHcNoaMK/5F54ZcJ+?=
 =?us-ascii?Q?sEdwBGH3JbXyp2WXoRxolBpvxsvYSCfQbDmMv2J7eD4vC3AFFPu/r8vu5FN2?=
 =?us-ascii?Q?R+F09gzSWZYPUkdHX8b9GnPqeWzctddpBnpehYwgrIdNG21WxpTq8Xfkk2O9?=
 =?us-ascii?Q?IPvs/n7BipqBz87AhAbzWKYzA/NEamIf8Zn5I7usP6sQ/xsXaRx3ss/Gp2sX?=
 =?us-ascii?Q?hxe5F2gpaAKWbXivD0FKhzAEVufcBtmA/U6czfjp+wB5x9WX0pM0cia5zGSk?=
 =?us-ascii?Q?+6dk9Gw7h2WO1a5a/forJMosUvs8AQ5rSVK5lQ2DgxjXMgVwm0AU/Ee87zeL?=
 =?us-ascii?Q?y04nM9rmoEPJUrIwABL0Zq5PisX/gphUTq0vPFmplyqvNfF+zck18a/onIbJ?=
 =?us-ascii?Q?Xga8gmbk99kBlUWXvQoHH2QSXgLM+f7u8JKYxs8vX8dlENQ6ZZifBvmHy0lN?=
 =?us-ascii?Q?hcnsM9iIyywd9M6WeLxWf8lBDkzlk21Z3ktZ/32EvQ+L8qPUb4Os0CKRV05o?=
 =?us-ascii?Q?J+EuzaLZvugM2oUX2iQPKSPnxh6ys8m/IR6ReMrnvpLIqHyss5AWbk8eTFgy?=
 =?us-ascii?Q?mlHanJr2JhmMn1UvPF7lYfzaM+XOrShdS9RXf1BAfqlmH3BCl6kqqHEFIIW3?=
 =?us-ascii?Q?GjWfR+89OssEctPxelzR1MHBN1NDrBzxBferw5AfhxKtR089CcRhwwDSuaLv?=
 =?us-ascii?Q?U/cY4lMlD5/4ug+Y7Jgle2f69H6MQoU/8Z6ldHKbwv7lglCZdRW5piVV82hg?=
 =?us-ascii?Q?4ChA7p3ea6H/Ct7Yq8RfIuplmpRFeQdyDc+KaAqJb0jCXRqavg3YvHrIaFcp?=
 =?us-ascii?Q?10R4On1IqGD5IyD0NYeMQxVR+JbDKi+fKcMCHJTbLe+v4n2uCDIscyooIOYa?=
 =?us-ascii?Q?5a5/Z96jroJm42zLQ9qugoYTgK5PGJ5wTtU0N44X3JEe+vy/7oz4h4PtQj4O?=
 =?us-ascii?Q?a1oTfSObH82OPCb8i95DiJR1UJ1IdKM7YekilahYZiqtOCLm53/z1Jyhjf2t?=
 =?us-ascii?Q?4m7RqiNLi1txpAdgx5lhoiYeYNfzoCaSs9Z2sCaaYX+749VRgzeGaJAyxwPJ?=
 =?us-ascii?Q?/Zggqxp6l3O/zDOZIJlV8vIidsyy9a7GoxNtM2AGMtD/mFx9rWZ9vwBXOv4e?=
 =?us-ascii?Q?QYrFi+czrKpYZ2553F6kYM51dDe9JCeXGu4RDc+mwq1JA6XFgzybZQ2UBMQf?=
 =?us-ascii?Q?+2T9pkkw92R0yvjz9I0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 23:38:03.8870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb46b615-a22c-46bf-261f-08de52fccbf7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003439.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8365

On Tue, 13 Jan 2026 21:21:25 +0000
"Anthony Pighin (Nokia)" <anthony.pighin@nokia.com> wrote:

> Address this issue:
> [  125.942583] pcieport 0000:00:00.0: unlocked secondary bus reset via:
>                pci_reset_bus_function+0x188/0x1b8
> 
> which flows from a VFIO_GROUP_GET_DEVICE_FD ioctl when a PCI device is
> being added to a VFIO group.
> 
> Commit 920f6468924f ("Warn on missing cfg_access_lock during secondary
> bus reset") added a warning if the PCI configuration space was not
> locked during a secondary bus reset request. That was in response to
> commit 7e89efc6e9e4 ("Lock upstream bridge for pci_reset_function()")
> such that remaining paths would be made more visible.
> 
> Address the pci_try_reset_function() path.
> 

Fixes: 7e89efc6e9e4 ("PCI: Lock upstream bridge for pci_reset_function()")

> Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>
> ---
>  drivers/pci/pci.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)


Reviewed-by: Alex Williamson <alex.williamson@nvidia.com>


> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 13dbb405dc31..ff3f2df7e9c8 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -5196,19 +5196,34 @@ EXPORT_SYMBOL_GPL(pci_reset_function_locked);
>   */
>  int pci_try_reset_function(struct pci_dev *dev)
>  {
> +	struct pci_dev *bridge;
>  	int rc;
>  
>  	if (!pci_reset_supported(dev))
>  		return -ENOTTY;
>  
> -	if (!pci_dev_trylock(dev))
> +	/*
> +	 * If there's no upstream bridge, no locking is needed since there is
> +	 * no upstream bridge configuration to hold consistent.
> +	 */
> +	bridge = pci_upstream_bridge(dev);
> +	if (bridge && !pci_dev_trylock(bridge))
>  		return -EAGAIN;
>  
> +	if (!pci_dev_trylock(dev)) {
> +		rc = -EAGAIN;
> +		goto out_unlock_bridge;
> +	}
> +
>  	pci_dev_save_and_disable(dev);
>  	rc = __pci_reset_function_locked(dev);
>  	pci_dev_restore(dev);
>  	pci_dev_unlock(dev);
>  
> +out_unlock_bridge:
> +	if (bridge)
> +		pci_dev_unlock(bridge);
> +
>  	return rc;
>  }
>  EXPORT_SYMBOL_GPL(pci_try_reset_function);


