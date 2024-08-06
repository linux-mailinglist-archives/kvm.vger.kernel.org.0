Return-Path: <kvm+bounces-23456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C808949C72
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 01:42:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9103B1F22498
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 23:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A0C178372;
	Tue,  6 Aug 2024 23:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d1hzAf/1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AFB178380;
	Tue,  6 Aug 2024 23:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987698; cv=fail; b=TjSbxNorAKY1q4EExeooeJwUQ8da1uAW/iLBVhwA6eXAFueUSobJHEBS+bzn2zu4MRubd06bmsywcinTwpQLweBg9xxNc8xDug9BLjiTo/bxFYWAQ8TRcZX6JJgswU2n/CWOtZuOaKsgdMBp+beqJjW6VUHvKaGKHelncK617Hk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987698; c=relaxed/simple;
	bh=R0FaVOwdlMrturQCTgl0y46nnQtivF8qLpj1PWj+n2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WJxdebYGroWjRdv3tSJbbwgfP6UMiFAx6qvUV2Wvc4KaBE9UpZjt4mj9Vw9h4M0mvx1h3tFDpT74ZPTtL+mje6H1s/DuJcJIWCGXdR26rTPoftodjXDHf/urEU16sVPX+uLOmb3W4O9Ey4t5RwEkICDs812PxOaQ/4vDSTvxRnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=d1hzAf/1; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hnmElfbtV8ye05VHpIaj//ehPbYeWaNIznVfzmHMz9pSqTHO7QUlWFv9rYOQzQz8kO7406APCMaYq8UURB+8vIPI8OSEX/YYxoGu3ASLb0ARoA5Et0fclPldp87VLzQXNMB4u0QjHTA0xLSzKimD39M/T2H6nA2WYilwBYOFy15oV5G7P62GF3Da/MF0m6xEaoyoutI5DBjI24TJQ62Nx2vxsQn/SEdscIx7l/df2V4j0IAX/0lePC+ACFSVKKGtTou6cC9Zbzu58Sl4XUY2CKLzb0osTKzE69v/0BFjjscVS0CxpEAHL3RPCfiFAjO1rzSKzLOCly9ci4trSMUSkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mo2Q5pdm1DdrPQ+FTWWBO7OGIkGdgEa++hYa2Vljj6w=;
 b=ZwOlGu9VZJVPcuut6oJyzeRGFl3yFWBuu/nnuWMzelk/hexvqAvtDMDeljHaIDwkw0a+LyT+TrUE7lNQEhqoWr+JIz51moPII1QmT0Z7WV4XtUF7qHfp/vgmt8gKOHCzZELYq+358yzDkx2dRgTu/i8orJ6o+MbmvIJeVCp9Qp+FSfmh40Z7GCYr6JuJ2yreV0H0CHDZL2hcHyJ9DwTlDJpVdBLMuMKbzH1LdLTO01gFB12JWCdlhPLWecqDiLxnGzxJ8R1fQxEtPGPvLJg3JIOf8i4wGw6BdRnQe7B3w3JVqdzxAZ+KSnEL1wovDBkQGb/Syz7IF8mI6zqgJaraxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mo2Q5pdm1DdrPQ+FTWWBO7OGIkGdgEa++hYa2Vljj6w=;
 b=d1hzAf/1sc9DEX+4BGJzMglMV/LlnPe9hkOscuYXC0zPTRDljRqSs0pvIDPM1OWpvOn+0/xqr844sZ5kmBwuOALZeRykaxbKO6yRRSRqy9dT7qLgr2216SK49KNJvxoep+fJg/xPjZQuLW9ctQXImvtJf9NWT37t89gZu87Bnf1GbnuSWBwLJKUq+4vmewQ7/TTHS1nDxoXK/fXoC6dnsAdPsEwMbun8q5nnkYRp+QndikAJDefF/ETr/g67BW0/h4YWa8vEVtwMLD6LGvlkp3VlfMIZIT10hyBJ/wy7PbrWUFB95j6NkoWQeyuS9vvupyh+uu+DYQlFm/l6eoQ/FQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB9422.namprd12.prod.outlook.com (2603:10b6:8:1bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 23:41:27 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:41:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH 7/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Date: Tue,  6 Aug 2024 20:41:20 -0300
Message-ID: <7-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0987.namprd03.prod.outlook.com
 (2603:10b6:408:109::32) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB9422:EE_
X-MS-Office365-Filtering-Correlation-Id: 400cba6c-8055-40d0-84c8-08dcb6714840
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tS9ZYbuk8BhU7njM8vP7odz4zP+2lRahef8rFy/+VnZyI/8qDd5G1+84AHSh?=
 =?us-ascii?Q?aAGfxbiCTo+PQtLlTT7+AE6JtwLRK1JS3kkGcVVBu7FgUbgQHJ14jxhkU29h?=
 =?us-ascii?Q?rMJHAJzmz77jfpJcvvV/rHRCSUDwJr9gMoOQicXkOeKFzmj/DsaHCXxte0QE?=
 =?us-ascii?Q?19lWD3m07tkCodT5sEvp4bB5dLZKau8C6NRFJg6kWtWFLphfucoCi2Q37uF/?=
 =?us-ascii?Q?TdpJQzUOfBvYBcvUPZos7lbMqTxbM3dhCkY8xYBBU/pyEKClY6kZ9YJm8G2N?=
 =?us-ascii?Q?wyjx0VEDV7ZFrdvkVIWkksjuzgkvcJ2/5RDzvjiYnYO5slArkpPmRVROHtdC?=
 =?us-ascii?Q?ru9mtldyhVvEUODVEFoqwl13ijOqDP4iTlkSIxUWDSXN/CsLRVMzddQFPiz/?=
 =?us-ascii?Q?HVHg8mWuSCqWlpx5CEhl7kHTnfye1ZElTtZqyqsdU2W7vkxE1kbV2c4xhh3C?=
 =?us-ascii?Q?S4YIOu37cKWbG7K5dDtg4mbBj+k1HC+3cTNvcFuw5KTlfw7tZP9pM+RQ17qh?=
 =?us-ascii?Q?SmCDjzP9sAwDFkZZ2DLtsVOQ2yLLwPKH9yKbX2MuEzz0eHn+XQYMf5EH/ryM?=
 =?us-ascii?Q?Gh73OfdBCdva/508nZCNAjnT39pYWOyxOlAhiDpUocQZQkef4JyD/SBZ3pCq?=
 =?us-ascii?Q?LvDJ146vQ9AB5ie+LL8T1fR6MWCZlO4IUJah9KFI0DQ1x+fuSuNHMENdoley?=
 =?us-ascii?Q?NKbmCAtoEoU3OuE4D/53HNCCr8aOJBk1xi5Ic/s0LYGUdmLDQ5QSYDQrvoUM?=
 =?us-ascii?Q?wbCQVAfdukkbrt5z9va5rjjgrctGnTafZ1wsdjYWzhOHEWjsdvw0mZD3ZyaB?=
 =?us-ascii?Q?6KrOytNeWcY2VJa/XKT8FkzODwyypJRu8Olnt9PQsv+RGJb0F/ZXYbgsorXS?=
 =?us-ascii?Q?bM6fyD3ExcOidK4f4Y9HvQ2YXsMVgVwo6jd4qe9MXJRwWtsJHMFVCaPDtjBX?=
 =?us-ascii?Q?uuGTIn7CU9yfLNp9cAJyUl6CgeRwakSZMWz8dKsN3QZVIXHiTZQFQmnMcwaI?=
 =?us-ascii?Q?icxe0PCtkGbnOXDUOtfnX8dx0/1okgVeQKO5D9A0kIV/w+o0Mj0K2rgbAAxi?=
 =?us-ascii?Q?botVpU8ghs4pHryetrp89p0qP+dJLK+7qBJCMqN6ht55sahwMYP5oTka9CJH?=
 =?us-ascii?Q?ZNgTBobm8O5ltftVTs0EzuJqEc5I1/g++aBrACSUOvwmyrza/VYrRQ1PgDzA?=
 =?us-ascii?Q?VP0KjE+Kpt8hhlUEPV3MuRl/D160l3xbucDmSTmZ9Qn/bK9Dc6rtGOlvqQsU?=
 =?us-ascii?Q?xFnhZiPhHt61zwpe8EGKMuJLamheitgc6YxJpkEXkiQAfevVjDjyKnJWu/K1?=
 =?us-ascii?Q?MaNnmIgZvCW1BN9xgAh/6bl9YuDbJtRIRv0lIQIx/Vh3m8UU7EePgu6tFwII?=
 =?us-ascii?Q?ZNiPagE6w6pdDAzNn8Mi/Nqnsv9L?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HrGEFV6yAk6YanW9AtbZViZB2HmSgeGVbve9vyGYj3+JnXRVy39i6dhmRjuK?=
 =?us-ascii?Q?4ji+AqVLbY5tSu38fLlxguU2eCszXHipOsnVIe28sQTC8J6X4uF7FGkXU2XP?=
 =?us-ascii?Q?/w8CkWmeRmMxcLNljFoX81o2eYUdApywt3hr3vcAgIbRD9C1ZzgoRRXWKktO?=
 =?us-ascii?Q?7AVoHQS9mn8hF6ala+fkalQE5+jntgni05IkY6aeosJqkPm9bF6wHUBYmLZH?=
 =?us-ascii?Q?aOTr3DJEXuyRtOe1Yz4a1CVl91I3Ck5QODYscO7YvpvN272w1DMr6gHtCZUN?=
 =?us-ascii?Q?dEz+3Mi1VjwKM8urj5sszLO19Z8h9iA4MPIntem1sMFbNyqC8p+OeD0PZzmX?=
 =?us-ascii?Q?GsjJ9U9NN8lj4CkjEOULZaABWikDCXkN4v6qq4A5FUJV4R+AFLHTerrt5H9F?=
 =?us-ascii?Q?x+M69cc/zlvd+gFkgiYwLpzF8COSxGUBMWSJFUSldLj4hn2FZrOtWblwiv87?=
 =?us-ascii?Q?a7h1oBrUJZFWr+xHlXDfO+MGLKWNh1oaAN1vv+7QBMWfyMu1BhN/6JeaVROP?=
 =?us-ascii?Q?RuR4Isd9oevkEjssFJ/xr2PQpFa/0XHuWLx17Fjl6gdqxP3Gc2I1ecizzSnF?=
 =?us-ascii?Q?Ccy82sr7rehihN8gdXGrfQqtPkIbrYm7BqgH3iWb2pcDAOgwmgDwBgd3yTDL?=
 =?us-ascii?Q?xtdPwajRCg+kQRLFbxgZLwnmsAhB6zlQ/Mud8Eh1w28J7zyBjrfesOuDya2V?=
 =?us-ascii?Q?RvQDu36Zck8mpCIMxBoX/JIUfgk+ZD0p5X6iVbkjJArqzu7StVE9rVFGewxn?=
 =?us-ascii?Q?mZodbFvwSDVtOMIY3Y6x1KVDtHp0pXbhTp7hijnOmVXDEo2IF8Viweki2F9+?=
 =?us-ascii?Q?l5kbMDaRKUd2ps9fo01czzba2k9ekJ5djlLEzHXKcPxqW2vflT5wHhLd8+sd?=
 =?us-ascii?Q?Wk/QhI+/o68u/TusC2ZnOwSaUaAVTUQhogqocHowV8rZB1W7DfmmKuSYzA4g?=
 =?us-ascii?Q?Wi/RyGuz0YoBRas4/N+R6Sv1yMBADx0gYaZ1ey/lRi7MD0gN1DSDyclpfXol?=
 =?us-ascii?Q?ftKkXKXtk+0V6hmOfYITevrwhhWM4w4gBMbHHUTC3mdpFkpYgYRtoMD8p4w6?=
 =?us-ascii?Q?/FPnKYRz8pnJbJS418XPBY+55qMthUHUmUheAGOCObnWRvgdFPKxfln2vR4+?=
 =?us-ascii?Q?TQ0EsrI28OoowrMFUdVhRN0HDh/hjN2r+nbZXZKWS17wxPXVJsgqXt3t2QL/?=
 =?us-ascii?Q?16CrLb62NZVAgOPz1bWIZ7WJolljTJmEmGrU+OYTeg1m16S6cvBaySWraawA?=
 =?us-ascii?Q?cMe3kvwpiV8U9ZiflGpec5Pcikb4r2Ha8S+ZwNSlv6cvZ73rPyqAV27fPGV7?=
 =?us-ascii?Q?4suWkpLahSUbnVJoFNNY+lJq89Cih7oqX30wrUIaCgFrT+dt5aA9L11vIhfo?=
 =?us-ascii?Q?Mu4elnz1jrJ5S7+5FZynF2e5rX5h0lprLpPTzeKrm3CNfFoub/Jh/3VnpcSR?=
 =?us-ascii?Q?JzBg+VDnNt0RqzIyWfvmIoNDVDSqIL5MsAdpEJdIBHxmESidac0OmmYk4Rqx?=
 =?us-ascii?Q?ir7nIog0cDrriOfXkv/q2QQclfVeTb4t0VyAi8JsaQd2oicYi8BFq7pqHa2q?=
 =?us-ascii?Q?RgGzZ0k3bKULVfe2JFI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 400cba6c-8055-40d0-84c8-08dcb6714840
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:41:24.1804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kWOkmsdZHp0AE/+4O+p2T3ZcU6JvkwDU51lDMMkYkESaoyK0ECkX6p3OMetbZGQD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9422

For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2 iommu_domain acting
as the parent and a user provided STE fragment that defines the CD table
and related data with addresses translated by the S2 iommu_domain.

The kernel only permits userspace to control certain allowed bits of the
STE that are safe for user/guest control.

IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
translation, but there is no way of knowing which S1 entries refer to a
range of S2.

For the IOTLB we follow ARM's guidance and issue a CMDQ_OP_TLBI_NH_ALL to
flush all ASIDs from the VMID after flushing the S2 on any change to the
S2.

Similarly we have to flush the entire ATC if the S2 is changed.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 211 +++++++++++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  20 ++
 include/uapi/linux/iommufd.h                |  20 ++
 3 files changed, 247 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5faaccef707ef1..5dbaffd7937747 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -295,6 +295,7 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
 	case CMDQ_OP_TLBI_NH_ASID:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
 		fallthrough;
+	case CMDQ_OP_TLBI_NH_ALL:
 	case CMDQ_OP_TLBI_S12_VMALL:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
 		break;
@@ -1640,6 +1641,59 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 }
 EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_s2_domain_ste);
 
+static void arm_smmu_make_nested_cd_table_ste(
+	struct arm_smmu_ste *target, struct arm_smmu_master *master,
+	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
+{
+	arm_smmu_make_s2_domain_ste(target, master, nested_domain->s2_parent,
+				    ats_enabled);
+
+	target->data[0] = cpu_to_le64(STRTAB_STE_0_V |
+				      FIELD_PREP(STRTAB_STE_0_CFG,
+						 STRTAB_STE_0_CFG_NESTED)) |
+			  (nested_domain->ste[0] & ~STRTAB_STE_0_CFG);
+	target->data[1] |= nested_domain->ste[1];
+}
+
+/*
+ * Create a physical STE from the virtual STE that userspace provided when it
+ * created the nested domain. Using the vSTE userspace can request:
+ * - Non-valid STE
+ * - Abort STE
+ * - Bypass STE (install the S2, no CD table)
+ * - CD table STE (install the S2 and the userspace CD table)
+ */
+static void arm_smmu_make_nested_domain_ste(
+	struct arm_smmu_ste *target, struct arm_smmu_master *master,
+	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
+{
+	/*
+	 * Userspace can request a non-valid STE through the nesting interface.
+	 * We relay that into a non-valid physical STE with the intention that
+	 * C_BAD_STE for this SID can be delivered to userspace.
+	 */
+	if (!(nested_domain->ste[0] & cpu_to_le64(STRTAB_STE_0_V))) {
+		memset(target, 0, sizeof(*target));
+		return;
+	}
+
+	switch (FIELD_GET(STRTAB_STE_0_CFG,
+			  le64_to_cpu(nested_domain->ste[0]))) {
+	case STRTAB_STE_0_CFG_S1_TRANS:
+		arm_smmu_make_nested_cd_table_ste(target, master, nested_domain,
+						  ats_enabled);
+		break;
+	case STRTAB_STE_0_CFG_BYPASS:
+		arm_smmu_make_s2_domain_ste(
+			target, master, nested_domain->s2_parent, ats_enabled);
+		break;
+	case STRTAB_STE_0_CFG_ABORT:
+	default:
+		arm_smmu_make_abort_ste(target);
+		break;
+	}
+}
+
 /*
  * This can safely directly manipulate the STE memory without a sync sequence
  * because the STE table has not been installed in the SMMU yet.
@@ -2065,7 +2119,16 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
 		if (!master->ats_enabled)
 			continue;
 
-		arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size, &cmd);
+		if (master_domain->nested_parent) {
+			/*
+			 * If a S2 used as a nesting parent is changed we have
+			 * no option but to completely flush the ATC.
+			 */
+			arm_smmu_atc_inv_to_cmd(IOMMU_NO_PASID, 0, 0, &cmd);
+		} else {
+			arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size,
+						&cmd);
+		}
 
 		for (i = 0; i < master->num_streams; i++) {
 			cmd.atc.sid = master->streams[i].id;
@@ -2192,6 +2255,16 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
 	}
 	__arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
 
+	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
+	    smmu_domain->nesting_parent) {
+		/*
+		 * When the S2 domain changes all the nested S1 ASIDs have to be
+		 * flushed too.
+		 */
+		cmd.opcode = CMDQ_OP_TLBI_NH_ALL;
+		arm_smmu_cmdq_issue_cmd_with_sync(smmu_domain->smmu, &cmd);
+	}
+
 	/*
 	 * Unfortunately, this can't be leaf-only since we may have
 	 * zapped an entire table.
@@ -2608,13 +2681,15 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 			    ioasid_t ssid)
 {
 	struct arm_smmu_master_domain *master_domain;
+	bool nested_parent = smmu_domain->domain.type == IOMMU_DOMAIN_NESTED;
 
 	lockdep_assert_held(&smmu_domain->devices_lock);
 
 	list_for_each_entry(master_domain, &smmu_domain->devices,
 			    devices_elm) {
 		if (master_domain->master == master &&
-		    master_domain->ssid == ssid)
+		    master_domain->ssid == ssid &&
+		    master_domain->nested_parent == nested_parent)
 			return master_domain;
 	}
 	return NULL;
@@ -2634,6 +2709,9 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 	if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
 	    domain->type == IOMMU_DOMAIN_SVA)
 		return to_smmu_domain(domain);
+	if (domain->type == IOMMU_DOMAIN_NESTED)
+		return container_of(domain, struct arm_smmu_nested_domain,
+				    domain)->s2_parent;
 	return NULL;
 }
 
@@ -2664,6 +2742,7 @@ struct arm_smmu_attach_state {
 	struct iommu_domain *old_domain;
 	struct arm_smmu_master *master;
 	bool cd_needs_ats;
+	bool disable_ats;
 	ioasid_t ssid;
 	/* Resulting state */
 	bool ats_enabled;
@@ -2716,7 +2795,8 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		 * enabled if we have arm_smmu_domain, those always have page
 		 * tables.
 		 */
-		state->ats_enabled = arm_smmu_ats_supported(master);
+		state->ats_enabled = !state->disable_ats &&
+				     arm_smmu_ats_supported(master);
 	}
 
 	if (smmu_domain) {
@@ -2725,6 +2805,8 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 			return -ENOMEM;
 		master_domain->master = master;
 		master_domain->ssid = state->ssid;
+		master_domain->nested_parent = new_domain->type ==
+					       IOMMU_DOMAIN_NESTED;
 
 		/*
 		 * During prepare we want the current smmu_domain and new
@@ -3097,6 +3179,122 @@ static struct iommu_domain arm_smmu_blocked_domain = {
 	.ops = &arm_smmu_blocked_ops,
 };
 
+static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
+				      struct device *dev)
+{
+	struct arm_smmu_nested_domain *nested_domain =
+		container_of(domain, struct arm_smmu_nested_domain, domain);
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_attach_state state = {
+		.master = master,
+		.old_domain = iommu_get_domain_for_dev(dev),
+		.ssid = IOMMU_NO_PASID,
+		/* Currently invalidation of ATC is not supported */
+		.disable_ats = true,
+	};
+	struct arm_smmu_ste ste;
+	int ret;
+
+	if (arm_smmu_ssids_in_use(&master->cd_table) ||
+	    nested_domain->s2_parent->smmu != master->smmu)
+		return -EINVAL;
+
+	mutex_lock(&arm_smmu_asid_lock);
+	ret = arm_smmu_attach_prepare(&state, domain);
+	if (ret) {
+		mutex_unlock(&arm_smmu_asid_lock);
+		return ret;
+	}
+
+	arm_smmu_make_nested_domain_ste(&ste, master, nested_domain,
+					state.ats_enabled);
+	arm_smmu_install_ste_for_dev(master, &ste);
+	arm_smmu_attach_commit(&state);
+	mutex_unlock(&arm_smmu_asid_lock);
+	return 0;
+}
+
+static void arm_smmu_domain_nested_free(struct iommu_domain *domain)
+{
+	kfree(container_of(domain, struct arm_smmu_nested_domain, domain));
+}
+
+static const struct iommu_domain_ops arm_smmu_nested_ops = {
+	.attach_dev = arm_smmu_attach_dev_nested,
+	.free = arm_smmu_domain_nested_free,
+};
+
+static struct iommu_domain *
+arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
+			      struct iommu_domain *parent,
+			      const struct iommu_user_data *user_data)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
+	struct arm_smmu_nested_domain *nested_domain;
+	struct arm_smmu_domain *smmu_parent;
+	struct iommu_hwpt_arm_smmuv3 arg;
+	unsigned int eats;
+	unsigned int cfg;
+	int ret;
+
+	if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/*
+	 * Must support some way to prevent the VM from bypassing the cache
+	 * because VFIO currently does not do any cache maintenance.
+	 */
+	if (!(fwspec->flags & IOMMU_FWSPEC_PCI_RC_CANWBS) &&
+	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	ret = iommu_copy_struct_from_user(&arg, user_data,
+					  IOMMU_HWPT_DATA_ARM_SMMUV3, ste);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (flags || !(master->smmu->features & ARM_SMMU_FEAT_TRANS_S1))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (!(parent->type & __IOMMU_DOMAIN_PAGING))
+		return ERR_PTR(-EINVAL);
+
+	smmu_parent = to_smmu_domain(parent);
+	if (smmu_parent->stage != ARM_SMMU_DOMAIN_S2 ||
+	    smmu_parent->smmu != master->smmu)
+		return ERR_PTR(-EINVAL);
+
+	/* EIO is reserved for invalid STE data. */
+	if ((arg.ste[0] & ~STRTAB_STE_0_NESTING_ALLOWED) ||
+	    (arg.ste[1] & ~STRTAB_STE_1_NESTING_ALLOWED))
+		return ERR_PTR(-EIO);
+
+	cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(arg.ste[0]));
+	if (cfg != STRTAB_STE_0_CFG_ABORT && cfg != STRTAB_STE_0_CFG_BYPASS &&
+	    cfg != STRTAB_STE_0_CFG_S1_TRANS)
+		return ERR_PTR(-EIO);
+
+	eats = FIELD_GET(STRTAB_STE_1_EATS, le64_to_cpu(arg.ste[1]));
+	if (eats != STRTAB_STE_1_EATS_ABT)
+		return ERR_PTR(-EIO);
+
+	if (cfg != STRTAB_STE_0_CFG_S1_TRANS)
+		eats = STRTAB_STE_1_EATS_ABT;
+
+	nested_domain = kzalloc(sizeof(*nested_domain), GFP_KERNEL_ACCOUNT);
+	if (!nested_domain)
+		return ERR_PTR(-ENOMEM);
+
+	nested_domain->domain.type = IOMMU_DOMAIN_NESTED;
+	nested_domain->domain.ops = &arm_smmu_nested_ops;
+	nested_domain->s2_parent = smmu_parent;
+	nested_domain->ste[0] = arg.ste[0];
+	nested_domain->ste[1] = arg.ste[1] & ~cpu_to_le64(STRTAB_STE_1_EATS);
+
+	return &nested_domain->domain;
+}
+
 static struct iommu_domain *
 arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 			   struct iommu_domain *parent,
@@ -3108,9 +3306,13 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 	struct arm_smmu_domain *smmu_domain;
 	int ret;
 
+	if (parent)
+		return arm_smmu_domain_alloc_nesting(dev, flags, parent,
+						     user_data);
+
 	if (flags & ~PAGING_FLAGS)
 		return ERR_PTR(-EOPNOTSUPP);
-	if (parent || user_data)
+	if (user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	smmu_domain = arm_smmu_domain_alloc();
@@ -3123,6 +3325,7 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 			goto err_free;
 		}
 		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
+		smmu_domain->nesting_parent = true;
 	}
 
 	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 58cd405652e06a..e149eddb568e7e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -240,6 +240,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 #define STRTAB_STE_0_CFG_BYPASS		4
 #define STRTAB_STE_0_CFG_S1_TRANS	5
 #define STRTAB_STE_0_CFG_S2_TRANS	6
+#define STRTAB_STE_0_CFG_NESTED		7
 
 #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
 #define STRTAB_STE_0_S1FMT_LINEAR	0
@@ -291,6 +292,15 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 
 #define STRTAB_STE_3_S2TTB_MASK		GENMASK_ULL(51, 4)
 
+/* These bits can be controlled by userspace for STRTAB_STE_0_CFG_NESTED */
+#define STRTAB_STE_0_NESTING_ALLOWED                                         \
+	cpu_to_le64(STRTAB_STE_0_V | STRTAB_STE_0_CFG | STRTAB_STE_0_S1FMT | \
+		    STRTAB_STE_0_S1CTXPTR_MASK | STRTAB_STE_0_S1CDMAX)
+#define STRTAB_STE_1_NESTING_ALLOWED                            \
+	cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |   \
+		    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |   \
+		    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_EATS)
+
 /*
  * Context descriptors.
  *
@@ -508,6 +518,7 @@ struct arm_smmu_cmdq_ent {
 			};
 		} cfgi;
 
+		#define CMDQ_OP_TLBI_NH_ALL     0x10
 		#define CMDQ_OP_TLBI_NH_ASID	0x11
 		#define CMDQ_OP_TLBI_NH_VA	0x12
 		#define CMDQ_OP_TLBI_EL2_ALL	0x20
@@ -792,6 +803,14 @@ struct arm_smmu_domain {
 	u8				enforce_cache_coherency;
 
 	struct mmu_notifier		mmu_notifier;
+	bool				nesting_parent : 1;
+};
+
+struct arm_smmu_nested_domain {
+	struct iommu_domain domain;
+	struct arm_smmu_domain *s2_parent;
+
+	__le64 ste[2];
 };
 
 /* The following are exposed for testing purposes. */
@@ -830,6 +849,7 @@ struct arm_smmu_master_domain {
 	struct list_head devices_elm;
 	struct arm_smmu_master *master;
 	ioasid_t ssid;
+	u8 nested_parent;
 };
 
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 83b6e1cd338d8f..76e9ad6c9403af 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -394,14 +394,34 @@ struct iommu_hwpt_vtd_s1 {
 	__u32 __reserved;
 };
 
+/**
+ * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 Context Descriptor Table info
+ *                                (IOMMU_HWPT_DATA_ARM_SMMUV3)
+ *
+ * @ste: The first two double words of the user space Stream Table Entry for
+ *       a user stage-1 Context Descriptor Table. Must be little-endian.
+ *       Allowed fields: (Refer to "5.2 Stream Table Entry" in SMMUv3 HW Spec)
+ *       - word-0: V, Cfg, S1Fmt, S1ContextPtr, S1CDMax
+ *       - word-1: S1DSS, S1CIR, S1COR, S1CSH, S1STALLD
+ *
+ * -EIO will be returned if @ste is not legal or contains any non-allowed field.
+ * Cfg can be used to select a S1, Bypass or Abort configuration. A Bypass
+ * nested domain will translate the same as the nesting parent.
+ */
+struct iommu_hwpt_arm_smmuv3 {
+	__aligned_le64 ste[2];
+};
+
 /**
  * enum iommu_hwpt_data_type - IOMMU HWPT Data Type
  * @IOMMU_HWPT_DATA_NONE: no data
  * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
+ * @IOMMU_HWPT_DATA_ARM_SMMUV3: ARM SMMUv3 Context Descriptor Table
  */
 enum iommu_hwpt_data_type {
 	IOMMU_HWPT_DATA_NONE = 0,
 	IOMMU_HWPT_DATA_VTD_S1 = 1,
+	IOMMU_HWPT_DATA_ARM_SMMUV3 = 2,
 };
 
 /**
-- 
2.46.0


