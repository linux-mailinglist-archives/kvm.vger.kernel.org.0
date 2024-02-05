Return-Path: <kvm+bounces-8017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DF98B849B1B
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 13:56:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46250B260CD
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 12:56:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A4B1BC59;
	Mon,  5 Feb 2024 12:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uOk8t+DV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2072.outbound.protection.outlook.com [40.107.212.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1655F3B18D
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 12:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707137356; cv=fail; b=rtCfGKVeUYly8IFkSGxX+xVxAyfGjdcu0aN9Z+8Ywv3iKoi55qhux5rZFGCXuvwtVTFyf4KFyvdK8s3GsokY2UVb7yky5GPTcqwsFXWmDtD7Ty5/9btNB05BMIEcdAvHeDXj3vskj5IpcVRRODIfW+7vhNLU5BtzsX1Lf0D9Na4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707137356; c=relaxed/simple;
	bh=kKY44mAbkzvQDJa1uCVN+G1ZxLpMZEV/V+DwtkdC8Yg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h8EAb5M+IYgeU5+34O6jjXH3Xya21rdzUbrcqa2YgKMvejmdlPuRaC7RaY+S9bnQ9RFQdXFJ8fu8FoImpCj1QrfkDYb7Q26aqJuyFtSr1WEBHHCMmSGjS3rdoaf5rtjBVTDTSxhZVkPmto4a5mb8zvnTtDqEb8etq/k0NyAdoTs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uOk8t+DV; arc=fail smtp.client-ip=40.107.212.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VIBr2vIpNEyE9HFSsD//+M8VEUUY5CJ9CTyuc0gBhX2lXwf62ea9EM06OzXg9xwo0R2rGAfxMCUm2cL08yHaZg4eCllYML8fiolExm6rBtiPxt43AC085pnEh8IBvhjgQnMvYWFi0AJoFRAfDWiD0ICmKzRLt5xM/VNAmfPyCe6cwnGUtgTQTp6Q49h91yveKaeIgNA93Kedp2n5N4zRo1FGNMumm3gHaGTa+8AmqmGaSPSSi8p/AKU+tkUA0BksQ19XndkwNH1c3pTUkmslEjbxpWtOpbpTHHU34H0BR9GlozpS0c/KHkZoXrtXf/jkXhyYu0gSn1SAOBWMhLNXPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xqWsz5I2xppMYSxuzY+0NPD+ByLi9NzvBqvqTVebFgw=;
 b=UmRCvjMmlih0mRV+LzZgKm/WuAfgDhK71KfjaBAdZZ5DJKsNQZNmBzE+MT+h0PG1KX06SKNZudtb1lP5UsNK+fIxrA/yDyhZ0TmxsaM5v5YvXGTar8qycxvaq3AKGF7Hbo1JZEWNEv/3ouLjY9Wi9n/is+bYgRe2WEvNdwbDqu0s/+XkRCOl4NVxyYzwpSk0InbOFHXU5Wm02PPN/vapn8EvsGkwniiScMRiepbjdIJG+J+Dq+vub+6edi3E9gqJ6lxn2GMm6pRAoafN86BUmEVV7DPiu8X7L0+30hL5HjZnooCwbOUblzy81fYcW5npONQLrPxJDH30Cu2zFSqgsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xqWsz5I2xppMYSxuzY+0NPD+ByLi9NzvBqvqTVebFgw=;
 b=uOk8t+DVsbBtrKgCXwpQLGHHjP6lNuo3Tm7TOwRhAZJpUJU/qJt32cPhN2nRMZTll1vvvOe70MvJAZJ9XUTkt2hXbQIG0Z+PfJ/Q3ByRqSkBRtKgdyMNRC1ejFOB8iZK6oCmhL7BsnK2G4Vi7mnkasECLJSFbP09hlXTTXqJwvPzCBDKA0bBZ5TQ8Py5x+lGfogHyWX7h4wjls9dRm/M/3qmjWYeE+brJsl4Tow5hmhSt4QJeLmxYcVFqXo3+AeSZI0cNP5REoOHaaAAeH+MGjW6JQ0hW+iUIPdIZ8rXK6dtxndQN/EPy1obQLXv5DoCf1uHIJ+dgzupNCtd5m8iyw==
Received: from BYAPR05CA0087.namprd05.prod.outlook.com (2603:10b6:a03:e0::28)
 by CYYPR12MB8729.namprd12.prod.outlook.com (2603:10b6:930:c2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Mon, 5 Feb
 2024 12:49:11 +0000
Received: from CO1PEPF000042A9.namprd03.prod.outlook.com
 (2603:10b6:a03:e0:cafe::1c) by BYAPR05CA0087.outlook.office365.com
 (2603:10b6:a03:e0::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.17 via Frontend
 Transport; Mon, 5 Feb 2024 12:49:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000042A9.mail.protection.outlook.com (10.167.243.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Mon, 5 Feb 2024 12:49:11 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 04:48:58 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 04:48:58 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1258.12 via Frontend Transport; Mon, 5 Feb
 2024 04:48:56 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V1 vfio 4/5] vfio/mlx5: Block incremental query upon migf state error
Date: Mon, 5 Feb 2024 14:48:27 +0200
Message-ID: <20240205124828.232701-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20240205124828.232701-1-yishaih@nvidia.com>
References: <20240205124828.232701-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A9:EE_|CYYPR12MB8729:EE_
X-MS-Office365-Filtering-Correlation-Id: 32912d1d-28c4-4fdd-c4d6-08dc2648d9de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uxHBKHNQi4Y3DuSj0qM5wb8V4sIvt/zA3t6jXt5P1LlgTnxCnPV+7oMZ8Rl+qNuZAeKRljcNvWeTsL8+tik0J3QSii2lr8p7Am3hUOb0ObzLXC4Tl5/IgHfPQuZjnGrrgiflqLW8T0D2lJiSC9puBLUb4dvDrhng3ANDrc5UFRemftOCLuuEzBf/F75HqcxdeL6dBsyo+BMP+0UjfWfI0YlYj1U7mjDpqM0pk814cyB6mttHrIG9w04wp6T/CtY6jYhoGDGgJzqAX1F2gnA/ne1kbiayDeULeLb5Vb4rcRxZ197ABzsGV4B97nbWvQCyg1Lg9Q9g3Sbz4rQt2x5J0xFKEL2EQAy/dhKyIcUIic6phZLkqy//0+gNQe9REIXHhL5EpkvO9L5/ZAmOXvIM6YvjErcgN4qevRBGk69w1xn4gzoc1J7v31nDTLmzWuaDDj7puvVUiTUb+/Uj/LvKPuE5Oy2AS1ZAF2dH9jGnmGRga4XrJ+5HgxiVMm9SXx8PazLk+uPVe6u7r4IP54KiNTF0N87ZfTqsQot1TRx1eDJiW4kaYUCvzurKrKFQUah6iUCf8jbq9Y+MJCLo4WfhnCPCaGhygAGSg/Rh95pqVUA92c7SY1fHim930oo4r2UObP/xkmK0oyORkXcVZKl6mM8Rj16YFdb++hWherYgLzZ8FInOASSjczFwp6sMPrPQ1TXwQIJ+yqeQ4CBk9bOAlwM0LxmX5ael+VjABml5M0JxLbd1QkHkaT3z/+duAPPr
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(39860400002)(376002)(346002)(230922051799003)(451199024)(186009)(82310400011)(64100799003)(1800799012)(40470700004)(46966006)(36840700001)(336012)(2616005)(426003)(1076003)(40460700003)(40480700001)(107886003)(26005)(41300700001)(36860700001)(70586007)(478600001)(36756003)(47076005)(54906003)(316002)(6636002)(70206006)(6666004)(7696005)(83380400001)(7636003)(82740400003)(356005)(5660300002)(4744005)(2906002)(86362001)(110136005)(8936002)(4326008)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 12:49:11.2961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32912d1d-28c4-4fdd-c4d6-08dc2648d9de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8729

Block incremental query which is state-dependent once the migration file
was previously marked with state error.

This may prevent redundant calls to firmware upon PRE_COPY which will
end-up with a failure and a syndrome printed in dmesg.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 6b45bd7d89ad..6800e4ffe9ee 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -121,6 +121,11 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 			}
 			query_flags &= ~MLX5VF_QUERY_INC;
 		}
+		/* Block incremental query which is state-dependent */
+		if (mvdev->saving_migf->state == MLX5_MIGF_STATE_ERROR) {
+			complete(&mvdev->saving_migf->save_comp);
+			return -ENODEV;
+		}
 	}
 
 	MLX5_SET(query_vhca_migration_state_in, in, opcode,
-- 
2.18.1


