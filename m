Return-Path: <kvm+bounces-8013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65DF0849B16
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 13:55:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A9FD1C21980
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 12:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20A4C4D131;
	Mon,  5 Feb 2024 12:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gwVpvDGT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C644D106
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 12:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707137343; cv=fail; b=FfqnbS8q5Sx8Cy6fz2aGSE647ILk5AfRP486jZeEiYnlkGoK7SD4yC+gTdf4BYiXcboWktC80KhGRdVDOoO90fndBcB8Z+FPqc8CiptJkPp+TCo9Ln/XSXsqwIOqFdq4TK8Tq3Ko27wAT0m70GHG/f3SocetOzv19h4eqtAPkxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707137343; c=relaxed/simple;
	bh=SwdNE3Rz4YPENg42Zp7Y82Z+3nH27Z3uyNsskhxqOI4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KsOmsywQM/GvH5T3R4dPyWxFe0F/Ji4kioHO/Y2hdZxjynxZOxZQ6EFUoCfC+iXQXECGOATgIqeMoFXVNqb3OGkdn8KYllnVDWZkCMLujyVLnLB09bJBe5XqmMzX68LA2uSMMm+1+CtRDg8lQvjXI9omLqdBM62PPbZ2hV+KvLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gwVpvDGT; arc=fail smtp.client-ip=40.107.243.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S++jBdvz8BhMRc1zgLh3QFAAyU0gyEgpX0Dw1lRZWUpbTgRiTJOt11lq4sU0nF5LROHOG7XsOPFnqluc2NHQvjt/m4hYD8QhS/dbCg/9SGvOwsJJeDANLTzpINeMfX1lS2rCFC7u2lD5pZf4oIYUjaxihreVRktCPGyE4el1whz5Zq4p/zuVVjJO175ixvNZHDz78U1razxYtHnV5+BmZ8aFTyVijXrznj38+KwJVg8pK1gQ0Cohm4X5PWmx8q3hDhKj064VrhgSarV+zbp2M+VPAGHk7hDqr/GE64WGa411n5dQiYmFVv54qZBlp1sPMtmpzmFLT+uuJnJXBUApVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+ukItFLrdKdwKB2FgRUA1cn2vWi+2BViG0vYU2JWBE=;
 b=VENCR+k9/7DM+ySjYIY1W9sSQefIktyJF6qeCneIavLKzXcgL9Kr9axb6kP56pNronhXybZisrGYjhufJkxGys2N1uABecK87FDvdAOFOY4zpHZkV8+sOFJloR9vae0ZTBRSFC8iTGor8eXvfFaTt93LNI11Qq1sXNhDf5qXoSaSMhU/7rKD8mQJMBpc+CB2ggcW+lZxsE/IQK0BfG7uPv5lBKuilESP1PCxsH4xg1avp7nd3t569f6POzWbtKkLMND5sLz3Fsau+J7/WWmKtXDaQDcnBO0Ozvxj4SiDA7iQqyMOKv0oGqBiplluIVNcnZuDau51hCGoGTgZlBBtdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+ukItFLrdKdwKB2FgRUA1cn2vWi+2BViG0vYU2JWBE=;
 b=gwVpvDGTHZP6pJlq0rIIaeMjKEtRaD3NQzgsC7US1vlvnuEa/VN8t9kPc53JFNk0MccCVjdXDwnRgwO7NBNBjAALnf+1VGZLgXBUe99Zgw28RIMPQexL+UPFsXiibYIDJCn+hDeeDtT97UTiOdFVVkAI+6H4PjVF8vbDHozZjH3FnRIa6vkk44ub8qSCV81Abg244vO4MLNqkz3uy8hnMVb9o41iKhITCQ9Cl6U2MPEx+dC7bKcdYoW08esDAQuv1KEWOXT0SmL0127GVeo2miEjUu5K3iLfDiwCBJ53s45xP+4l/HLCI6c3+Mk9qiQ9JHa/XCOApA98ENIJUvgxmQ==
Received: from MW4PR04CA0262.namprd04.prod.outlook.com (2603:10b6:303:88::27)
 by PH7PR12MB5808.namprd12.prod.outlook.com (2603:10b6:510:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.24; Mon, 5 Feb
 2024 12:48:58 +0000
Received: from CO1PEPF000042A8.namprd03.prod.outlook.com
 (2603:10b6:303:88:cafe::b4) by MW4PR04CA0262.outlook.office365.com
 (2603:10b6:303:88::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36 via Frontend
 Transport; Mon, 5 Feb 2024 12:48:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000042A8.mail.protection.outlook.com (10.167.243.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Mon, 5 Feb 2024 12:48:57 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 04:48:48 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 04:48:47 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1258.12 via Frontend Transport; Mon, 5 Feb
 2024 04:48:45 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V1 vfio 0/5] Improve mlx5 driver to better handle some error cases
Date: Mon, 5 Feb 2024 14:48:23 +0200
Message-ID: <20240205124828.232701-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A8:EE_|PH7PR12MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ced7c55-360d-47b8-a402-08dc2648d1d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uYDiIjTuF9Yv+O+SjqCwl7cSO5GCesGffsIFNMakcz5E6UF8IEaAVoWyWCcWi5x8VtaaWT4t1Z6mfat5ONNLP8//7hG/BRr1c0SIEooVcsJNuSE3FcWiKb5tu1PYOzxCXScx6V+710Q1e5Ytm8zfvxMoAPy0ZMtpsp9ARZGrN152+KQdVjh7kpx01/z4JCFPhuJPVrTPkg+S/CID+O2tU4WrzwbqKUr2Wb/WeI1Uu8Zygzk67aQDYxQQU0fMPx4dk/TczgENeEkuRnkPE73tZRhEjVVLspTUb13/t0RAeohqdy1Mz67kq5VrRpA2fcgFcf0HN+85va9mgOqMkrM5lQ3wJDUbsbV6UR7IrYC7hm/3GO1TXrbpbeLTtNnovkPswIr2EEeau6/TgdQiyphIeifVxVdn/fiborLnf5DmEo+p3glw5s6y6FpO01B9EqnX/FzV1Mt7hSOCAycdzH10zUa0vwKDJhFygpJEvXQz9/MelbVQZ2OsFAwyRTX6SYrLXUvGaLkSK5C/CXsNPg+AVws7Dw+aIkSvcrbWr3MZoxt96b/8ziIsvSBa7m4Utgqz2ztqKlYhPLoplciSbjm/x5eKNhNywV9ysVoEYUQkfVyYTiCM51jVd0PAasLLG+Gzyt/wX8aUQa0O5DXWarKGndyFpy3C8xcTRcUevEY4fg0rpUr8KrBz/n2QZGA73Bf1BW8yGWZCyy0V2VmWqtHp4boq1aYJgFShi+LsLF1nHrDtCySfGe84oajVu+Sve0V2ssr1YjUIWu3qMcPcdOW+3sKgtcmUm0qNKpzhLkHlj74=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(376002)(346002)(39860400002)(230922051799003)(451199024)(82310400011)(1800799012)(64100799003)(186009)(40470700004)(46966006)(36840700001)(40480700001)(36860700001)(316002)(54906003)(356005)(6636002)(2906002)(82740400003)(40460700003)(8936002)(70206006)(36756003)(4326008)(47076005)(110136005)(86362001)(7636003)(8676002)(70586007)(5660300002)(26005)(107886003)(426003)(336012)(2616005)(1076003)(83380400001)(478600001)(6666004)(7696005)(41300700001)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 12:48:57.8407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ced7c55-360d-47b8-a402-08dc2648d1d9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5808

This series improves the mlx5 driver to better handle some error cases
as of below.

The first two patches let the driver recognize whether the firmware
moved the tracker object to an error state. In that case, the driver
will skip/block any usage of that object.

The next two patches (#3, #4), improve the driver to better include the
proper firmware syndrome in dmesg upon a failure in some firmware
commands.

The last patch follows the device specification to let the firmware know
upon leaving PRE_COPY back to RUNNING. (e.g. error in the target,
migration cancellation, etc.).

This will let the firmware clean its internal resources that were turned
on upon PRE_COPY.

Note:
As the first patch should go to net/mlx5, we may need to send it as a
pull request format to vfio before acceptance of the series, to avoid
conflicts.

Changes from V0: https://lore.kernel.org/kvm/20240130170227.153464-1-yishaih@nvidia.com/
Patch #2:
- Rename to use 'object changed' in some places to make it clearer.
- Enhance the commit log to better clarify the usage/use case.

The above was suggested by Tian, Kevin <kevin.tian@intel.com>.

Yishai

Yishai Hadas (5):
  net/mlx5: Add the IFC related bits for query tracker
  vfio/mlx5: Add support for tracker object change event
  vfio/mlx5: Handle the EREMOTEIO error upon the SAVE command
  vfio/mlx5: Block incremental query upon migf state error
  vfio/mlx5: Let firmware knows upon leaving PRE_COPY back to RUNNING

 drivers/vfio/pci/mlx5/cmd.c   | 74 ++++++++++++++++++++++++++++++++---
 drivers/vfio/pci/mlx5/cmd.h   |  5 ++-
 drivers/vfio/pci/mlx5/main.c  | 39 ++++++++++++++----
 include/linux/mlx5/mlx5_ifc.h |  5 +++
 4 files changed, 110 insertions(+), 13 deletions(-)

-- 
2.18.1


