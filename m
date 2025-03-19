Return-Path: <kvm+bounces-41512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE7E6A697CC
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 19:16:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 889C14812F8
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 18:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E45521DF747;
	Wed, 19 Mar 2025 18:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xofb6H+X"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529FA1DC9A7
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 18:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742407981; cv=fail; b=JBJd8OoRHu/n562yyqwo4Q1VHkQAH1fyGfs3mN79PLwWBQzYeKWYLyE8p6lADL2jA8T9HQNKlSZtQZuaQTUheX8Je6KjOXsfLKGYoJZNYyOoSELGx0n06HjYlHX5nHdVDr8Euhtmnaghh29hVB6E4d5pmkrDzfVh+dJUUmc4DCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742407981; c=relaxed/simple;
	bh=Oe5qTa3suq2T9nraryxhP4pVFb2lN+LbErByAKQ0YKY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ck2YuOv6b6kRR/s7SB0IlZcZ+N5DuhaJiN2SVvxdH1S8zezIkIotrHtiBfqBlvak+ku4xrPUKfGd4Lj+XpbDQbm+YjlJ0kX4nO33wZ5UhzfcnBsujxyVR1Ag/6tX3006KskJvMqq8i62Q7FNvjDzoRLJsNno3xbsWy/U1/48z2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xofb6H+X; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DR7tmBfmejoWXOR562d4B6J8sbvjUrpguYgXTm48rZSnHYinaMlvI8/hJL9mY2FBqj5kQeHgo/eEgAuXrDZwA0D872sI7Sl3FetV4iww5Nz6PUjAGCfXIyGQviF+jhtmF/jrKquCxkejZE9zKdrrhmIvNnz+EvMClAes25pWjxObH3in0v3hlxpJ08G55G/fEVoFkhoie0XDwAF7dFJrEe3lPBgkE71dHdMQWv+NIkwqgolloqAw3NWJEKjvECRzKCpMU6HA1bNhY4OotYRidaerPG9CaK4mWmbeD4jomPWrByTK0WP7nF0wUvF0d6v6lxJytmth5Y7JlBBweE46vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WP1jVF1z/l1ThOB4/EN5tVcGr2AV4aLtJ13q1avCGCQ=;
 b=AD4Kh2hy3QqucLiaoc0BGOMXNLB/R/gdULav3eKpujrergqzp86UwXCStheDlIWvoR44WuHzsA8k7qpXFGqtc35PA2ogRSR4E4WfAqRDR8lJ2bTe4JnujdID/y1qCpEm5U7eBCRunK/Q3KCsIt5+n9dJqdYpWnctpxSOVMrAROOuefgoVZqCHAdZdh1+Z0tlx4qnptbkFSPm4tS7yfh6eXdmqTK3k1rKYvZuCLS5liqVDpXNdIBAJJmUn9jn3hx/QbjoMQm/z9jsM20Cibptui7dPFxH7LEI+0zm5mygXF6r3MpcDVRkEEiHslO8U7gxigXk9bV2jcGMHgwrkceqzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WP1jVF1z/l1ThOB4/EN5tVcGr2AV4aLtJ13q1avCGCQ=;
 b=Xofb6H+X7C3/TGawjO1pUdU7kf0Fl79Nkr2uuBpkyQCpMkzp7ixQZiaX/7al06SDI7jLmCBfUT+qcYRJBTna+RIg0MMv/ZYDB4aT3HCkFnfLArJv5SVKAJMeJtsRDWy8ns/RNeaRTCyXYYGtGezQQY3wLIVvjz2a4ssYKonsNBXOufO6VmL2PG+0lErf0MhbCSocZ48rSlTZ2njdIIBkWL6AdJ5n7etTdF2/EbOF/O16DDu3EGCvQEAonbLJMHQchfLX3KJC4m2nSYeWHkOP2TpH2WJz6+N2jaDo5OJ5fQlwFjpvRdhNxzVaei+UWALUAtJ0H3LTCHPExzUrgF2dKA==
Received: from SJ0PR13CA0123.namprd13.prod.outlook.com (2603:10b6:a03:2c6::8)
 by SA5PPF7D510B798.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Wed, 19 Mar
 2025 18:12:57 +0000
Received: from CO1PEPF000075EE.namprd03.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::7f) by SJ0PR13CA0123.outlook.office365.com
 (2603:10b6:a03:2c6::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.33 via Frontend Transport; Wed,
 19 Mar 2025 18:12:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075EE.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Wed, 19 Mar 2025 18:12:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 19 Mar
 2025 11:12:37 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 19 Mar
 2025 11:12:37 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 19 Mar 2025 11:12:36 -0700
Date: Wed, 19 Mar 2025 11:12:34 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 5/5] iommufd/selftest: Add coverage for reporting
 max_pasid_log2 via IOMMU_HW_INFO
Message-ID: <Z9sJEu7Q71f8V4Ju@Asurada-Nvidia>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250313124753.185090-6-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250313124753.185090-6-yi.l.liu@intel.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075EE:EE_|SA5PPF7D510B798:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dd57384-eb0c-460a-4356-08dd6711abe8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|7416014|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NLiZXhcoVhcY4veH1cvb6RxOryQZaJMp0uv7izxjhFufnb0/8Mi0c12+Z3Ix?=
 =?us-ascii?Q?4OMOStHqGha7E1b5+7jjuDq0g1niWQQadRVywqaEtka8Vo6roFKMqdmOyXLf?=
 =?us-ascii?Q?3qsi5b89fvWh6eGg48Y8cI6F9mqzeFlbJl+cOXI6468eJDjIthqaWeptI8Yh?=
 =?us-ascii?Q?94S9wMeX83k4L9TSBHUXepjlo6GA4oBp9SwpgOMSI6cqvrvtDOBJqPLN9JZ6?=
 =?us-ascii?Q?DjAcknsbwwYb3FHUgKuaqm8TQA5Wl1+BHp8kivvJyW5ht+ELZv25pi/mYWV/?=
 =?us-ascii?Q?cAgLphJB4fU4P3mjG2bR9469GqBexwR20PnMgQEv0VHHylJrzq+TCj75obRI?=
 =?us-ascii?Q?A3SqO+CTSMWPX7e97O0kittMDPX1xOuHVZ0+zG80B1I8tQ7jgQrhx6qIrTTo?=
 =?us-ascii?Q?jKj4hbI0fzGYsGue5mEmIZnpg6PN/bkxxkW5J0ch8QPrnVUw6xI0e7MYa/Wj?=
 =?us-ascii?Q?3sRUJlpI5/w/Dl5WusjY32vmbxmNG2WpdpHyuCecAZDd/cKljmWW9Fnm/nFv?=
 =?us-ascii?Q?lMzauzkXSxLi9Nrhpyri/y2tLl9lQ2wdIptORQV2bEnIAa/IJohAOsHiXYZC?=
 =?us-ascii?Q?ltKfUZoXEHWZeYatp05hUMtHoDC0PuBBfKP7hZnCn/nyv7PF4ODVKjSL7vxb?=
 =?us-ascii?Q?OHZg5doHSVBYBEcmONp8NXmxjfrfh9APLCZeIaLgk8NJNS9ldO5rXI4cCWbC?=
 =?us-ascii?Q?QMhQWTNWemEcC/3CjjMl9JP/fFCkn1CMU7A24eJT4X4/c/n6rqnfm6gz0LRc?=
 =?us-ascii?Q?rHSeXsH/kONTcQ80bNjC4YP6o3wXw7GLU4wlF/w5B+IbnQ5JvJk3wbw7ysY8?=
 =?us-ascii?Q?oRgxPvB3Hr3yHeGzHm7OW5nGAv026sIpmV+PAR7ATgKzgS9TXIAEWbdHu/KR?=
 =?us-ascii?Q?4hjeNlVF+f6HlcE1a9ALe5EaXxM9FzJV9xKh15uwBn0UrJMWJVtmOqRcwNsS?=
 =?us-ascii?Q?McvThSwdfi6Dw/+P46QJibN3HC1j3ok/OVVG60ENLWqlyWzeT6wJt7lS84wf?=
 =?us-ascii?Q?dvHGKTqhwQ8rkUxUzKY4nQVpBup/CwYS2OnMMvGO8bedcGwjT8wLk3k93Qsb?=
 =?us-ascii?Q?eRF+FcqP6A9wYQQS6uCeF9xP1/YwGcKUuK+5zvNNHXdht7YAKDtvpvXvepJA?=
 =?us-ascii?Q?u7tmch+P/up8wPdy1mQiMlmou1QSOnLFUPXi3cKfNKGQM95jNZtxn5u9Gesl?=
 =?us-ascii?Q?e8i635cjGBwhIGBe94bhS9ZfbDbPGUcl3DbJvB8VM9Uw+/VQHng/ryiGK/HP?=
 =?us-ascii?Q?G6rA/WcQvEa3nKaDSd8tVujO5oDmnj6cEzFVarZZvJa8iO7GLVnYNL4k0/rH?=
 =?us-ascii?Q?nuY86Gxfl4gQrc0D2SZGyXkPknsYaD3vGGwjBRxIt7pkIIGVvCanOZWWbNIC?=
 =?us-ascii?Q?A5dSVoDWqGUSWF7O4041+08NDhPW0UcpJOE++vs7K49UQ6QIghR3OqqQ1VNu?=
 =?us-ascii?Q?oEQFodHs9hEg2BDasKhucdGZ2qfaaPItmkLbkLHF4znnWMoPdsMH0Frc5VET?=
 =?us-ascii?Q?KH7n9DfAY5prsHA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(7416014)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 18:12:55.1301
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dd57384-eb0c-460a-4356-08dd6711abe8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075EE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF7D510B798

On Thu, Mar 13, 2025 at 05:47:53AM -0700, Yi Liu wrote:
> IOMMU_HW_INFO is extended to report max_pasid_log2, hence add coverage
> for it.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

Two nits:

> @@ -342,12 +342,14 @@ FIXTURE(iommufd_ioas)
>  	uint32_t hwpt_id;
>  	uint32_t device_id;
>  	uint64_t base_iova;
> +	uint32_t pasid_device_id;

Maybe "device_pasid_id", matching with "MOCK_FLAGS_DEVICE_PASID"?

> +		if (variant->pasid_capable) {
> +			test_cmd_get_hw_info_pasid(self->pasid_device_id,
> +						   &max_pasid);
> +			ASSERT_EQ(20, max_pasid);

Maybe add a define in the iommufd_test.h file? Since the selftest
in the kernel needs to provide a "20" also.

Thanks
Nicolin

