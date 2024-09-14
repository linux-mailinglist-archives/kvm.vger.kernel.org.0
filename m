Return-Path: <kvm+bounces-26926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FAEE97914A
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 16:14:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AA511F2274C
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 14:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D541CFEBC;
	Sat, 14 Sep 2024 14:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mq85L5PH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126BF1369BC
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726323238; cv=fail; b=NFJXq1aCSiMliOaxSF4CtCjph4pnIBTunoqezaMC7qq9uOGOBALLQEX0t01ru3t8s3OAIDNBnNyLsPthbvCe+O+KzHLGaFJgw4hYneAY3gr6SF6Ad/7r0hrRqjR2LkSTqm0AbcVfcoLqtTU/9OJETpynj+zlb2r1SqsJ69z1ET0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726323238; c=relaxed/simple;
	bh=IEpwWctHoaLIwadfwP5luQQhWBqtyBAU1N8oZG1lAmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X+D+oRCARe2rdygw7IkK6U7f8NTY/yDyOjS7NwN6HxT0dUVU2Jrmrfy1sEqkAuxTdYxTOFoK+hULKvX7j4q3FrGxHdOMU4gVgCNiRQueK9hCUQ3shfH7/kFTZkaLLzDXa/aINnMaIfCJNY3CBF9U3WaJm9AEYzE0804/pDraDF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mq85L5PH; arc=fail smtp.client-ip=40.107.223.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GTf83POzhNGqeG4R9sLmam8O/LmT6F3aNQcnh6gyj0k+JtSh9C81CelmFrICxcoZwj5QEYlwVxWKGIIgdk3K2lULYPSZj1C6MAI4fjfkjaQ/VYgrY9D1rdDC9VN5+O946A/Gc1s6DuXa8oXDzf/3ssihpZL9/meCQtgkQJTCV1nO4E94HEqOlJi9WirS8kw7AkPUC9/iMeXQGzBSmCNY2/iq7tet+2KuK6kvtxiRb6O64Wqdq6FG3lFGxpPiW2CqqySosUyYDFVFL+Sx1zcZOpxI9ZrdZ7Xs/3p4LAhkUXd+yHtZY79V/669uR+dZkMMmZiFbS5e/ZVG9Mi9Mi0Srg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ZRaUOqzBgwnCbaiqqs1V62D0U8ECwjPaqO6ZcH0JZg=;
 b=uagxAhLwQysrq61Pne+7deNhs/WRL9DMf8F+H3ImFwCR5VDQr/BG3ZonIrKe48VIXqAEL5i92UR8nChtew7//5WbNxBVOSmvjLPtConoXnsU11m4BfQJMBGCgt6bGID17oQODuoLj7CO5NlE4uH6Ide6tSlOmrrSeHOd7u3kae7Q/CjdieJ4UKlJ98G+1dqEvhmHOyLj/5Phls5UmY/mfrjU74buzQafCrRwaMAJBIEnbpQG2VZOZqNcLAr4hGBs8Dn2TEy2xI4e1s6rbORjbEzajlDZX/T0m0g+awRqcQfzBZPrE4hcZiLUKVMtpe1ezFVoPikU8FTzg2Zg6nMePw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZRaUOqzBgwnCbaiqqs1V62D0U8ECwjPaqO6ZcH0JZg=;
 b=mq85L5PHiXh34qPG1y/mEY+8Ah3aiMrsoQUyZ2AbWDDTtTxIvD8XKKPhDEQsXMiKGE/yb+DS5Yc4M3Z+3VqH90oXV7pOaw8nDEr/kmFci1D9gfXTufPxtcu7IDowirsFnv6fqwTBM/VYJDML+hLPdW8ocblp8uxXAHYb3pFXaJqFsK+Bbj6GX4hleUVM1gYje6mZNbvQwz7MbQksATxLs1HwmOFQE9gfoBuRy+eYnJXXQqZ7Vi1XvO7nYt7gDxjIuycE2dy9z5IUTpeF+OqbjUwtLuLU1mxVFo0KfCmFl+haSoS2R/XeWuOgTbAhJLASRIxoLtw0DZiYSREbf2KZQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MN2PR12MB4143.namprd12.prod.outlook.com (2603:10b6:208:1d0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.20; Sat, 14 Sep
 2024 14:13:53 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%5]) with mapi id 15.20.7962.022; Sat, 14 Sep 2024
 14:13:51 +0000
Date: Sat, 14 Sep 2024 11:13:50 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, nicolinc@nvidia.com,
	kvm@vger.kernel.org, iommu@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH 0/2] iommufd: Misc cleanups per iommufd iopf merging
Message-ID: <20240914141350.GU58321@nvidia.com>
References: <20240908114256.979518-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240908114256.979518-1-yi.l.liu@intel.com>
X-ClientProxiedBy: BN8PR04CA0041.namprd04.prod.outlook.com
 (2603:10b6:408:d4::15) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MN2PR12MB4143:EE_
X-MS-Office365-Filtering-Correlation-Id: e9ff7d1e-927f-4244-c019-08dcd4c77591
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2POPoByqAHiqppycokzmbAxC4OpudK2XOfgnHVscsKquMO3Y8elQKyr5lmRv?=
 =?us-ascii?Q?o8dapjS8VR8vQx4kFrKlVJdeHkpOdRhn+rbycQyEgRf4V90vy+say3E48U0F?=
 =?us-ascii?Q?xPi0EXV+29Vo8/eqKM3EobBYbsssefIVu+vbb2zV2+CvRSxGvFmMDzLk/EQT?=
 =?us-ascii?Q?cReyaWCA+lHCf3jHUKDJVKqqB1u4TMxKtHMOm+eYHVOSNlE3+zIyffzeDE28?=
 =?us-ascii?Q?QhZaitXjA52EBZyaoCbzOGkd8SsuHLzFnpcCsM9l7pz5kqL03gURltJ45qps?=
 =?us-ascii?Q?7J2qcy3fQT2yBD1I+1lMSTzkGKf7cbru4JEaay0HzGdg69veIGU+bBW2rFmJ?=
 =?us-ascii?Q?j1ufx45YANq8P4Lb/hplKvIOes/gm/WvaPpKmNFvTx6+MkBvq9M0vEIxJmxT?=
 =?us-ascii?Q?uF9xhkN579Y/1xxLWOLez1bmInO+Y3wUL9AOsBwo2t73Ta6eRPGnTXcQBtgq?=
 =?us-ascii?Q?Mrf3JUYC5aRzTa9hctFNGMzKrIOaWk+2eqiDGDnI/HAdRC/MgEb4VG3zh5he?=
 =?us-ascii?Q?U+PPOXxgKKHeh/BHZLLnQqd1qq1Zc5JAAEKnjZypZuv73vd+dYzgTRmi5+iH?=
 =?us-ascii?Q?u3KPxy+TZUrwXp7p8V7zMPu7y5HFiWI81xqkRPDSailbJcK70oeGgerqPs8H?=
 =?us-ascii?Q?87T5SgkIZ1jKNJzZrAEvXvgrZ1YBd+GE3m/BWhGpUwQ1cpft371lhr07OeMG?=
 =?us-ascii?Q?lgK4YU/b9ppiBvOvgetBIYOB34SG6gb04oFGXHAsBQhxKgR/iOKc3+4TS07M?=
 =?us-ascii?Q?LSCpfs2fJUelBZti85kM2rJm8NT3zPUqJg/OA5tIkU7ELtrfub2+7/Jm2Yu4?=
 =?us-ascii?Q?pnx0GfKHvpFS7U2uMG1meHpl9ELXgA4DBep9gU3IMtq1sznNVsYJGRbyPzJM?=
 =?us-ascii?Q?CnX4Vh6fmpQ5NZUcma8NmpHjWcolFoPeL1XbGMO7tjRvfhSinNhx61bbKmXR?=
 =?us-ascii?Q?PVYnOO9a3pL/Jk9GmhmFojTbXHPkX0o2nTMPWFsQ7Vuqoiz22j0iHa0vn7ZK?=
 =?us-ascii?Q?DUmVT2sVbEJZ/oS7dHE2aVZ7aWGLUifswVvk1qG5LBHxxhh1JybsGQoY1HV/?=
 =?us-ascii?Q?e+JQVAYSOCWlb2aYy+XFeq6gvYZsLy/K0ubvEsDZYSwA2LYBVkruKwdXWuMx?=
 =?us-ascii?Q?SBBg+p8ld4KIHFM0NoW9OVNSiyxi0uQgQ/YVYB98OPPj7vMHO/KMdbJFHK7e?=
 =?us-ascii?Q?0xbs9nM+eS8bJENRgaXXmRfVzwWvn5UreuA6ntyGiQNtOMf71gDoHRq/XNVU?=
 =?us-ascii?Q?oCRsiKD1JDWsgfc3kEJMLTO1rqGA0I9qnnG61rWXbQK/aPa1mVXqrWh6dov8?=
 =?us-ascii?Q?eCIWGQAdx1N3er1nMqWPRSw1iVHXhABiPfO5FQmznBOgSQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r/5fDXhwSwxuEvBgtGrlfTQLT32x2unFBbytXLh3g/q87JumTa8IoguYfOA/?=
 =?us-ascii?Q?gud6n5yCLcRUthhC6hGvhDZ+bR3bZLjGgMIpDIeW4H/2hl/Bgj52qeBFMj0z?=
 =?us-ascii?Q?KaUJdaM1F55guRGL5CYpAXMDMHMorFJCE2U9KKhXTzW7EjX8kY3S92083q7S?=
 =?us-ascii?Q?gkNFI9tSK7mZllsQccU6mRWsqHodnjZmSwvcJ3I+1PBemMCjdR8Mc3V6kIWX?=
 =?us-ascii?Q?+aLeWew9Hw/a40bhqjZh3NituN4qF+0QadDzCpgMHosZ5frHvlsEUhT2Lu7f?=
 =?us-ascii?Q?0D2oHTEYMMF3CtJDD21uN1eYFvEctfU5X3PrNv9nyTwpDluz4cqravj16oo/?=
 =?us-ascii?Q?eCUAg6Nr/7IUqSKzf2Z3TO1oJjuv4z96Cea/XhXcNGNrG1pV5DCxPjC6SVLO?=
 =?us-ascii?Q?ERWGM6+xPbXd7MD6oM4bzri0kWaqJkeSAW5fXRJ2xSyDLmoYeVCZ1+pJis/j?=
 =?us-ascii?Q?KOD7c2CeeLcoaW+wgH1wAhvRAzAPWrEynuaqf/nfC37ZMTp44z+/Wr4L0bQ8?=
 =?us-ascii?Q?N/oDK4usZnja+EO+RWKlsy4GoJmUiTeXyR8BcmhJ8cV30ZhknMLHfToRbqow?=
 =?us-ascii?Q?24DtkzxYwi2vU94Tt3/wtpzxlmiV3TcfF+JtxoajQUnhGLTTeqIrA6i6Wqo0?=
 =?us-ascii?Q?XxF1/31upL3At4bhs8u4iWuZRK3vToBq5quSM6RYRH2yaamSAd4W51tLuob1?=
 =?us-ascii?Q?+PID3godXvFp94dczoAK6qXT0HAAxgeUNZVzRFnb84dvIrB8/QtslQumfs1D?=
 =?us-ascii?Q?lvq3bFi/v9VVXcCdqC2OsYq1Z0knE8xi2sB6Cn0G/2mZICKFaCqhDGPt5JYt?=
 =?us-ascii?Q?n5BCLrIyWN1ImKM+xLaDxar3dk0imDHqwQiDw4IaEOLuil3llP3Eazj1kWYQ?=
 =?us-ascii?Q?sseHUDPj3dwU24b7ltC5s6Mnt6NnuD17wcRbdPczrZMYDDcLKKQZKer62dWz?=
 =?us-ascii?Q?0YKFrCKhqa719w6gM6whlejEgWtAwX/Yw2Zd7WTfFpNfpnFxMRO+W2TP6MDT?=
 =?us-ascii?Q?L+cXGo83x5v0cgoFCgxGv+uK+7lULJHiBWI8zr+SsIu1XY0m+koEKk1EHn94?=
 =?us-ascii?Q?tFmQuwZxplVMzIUHhDHDcQjLgjWUawpZChNGi6MGzthuVoKKylUkVh/T/jzJ?=
 =?us-ascii?Q?LATpiEbpMW5CzQQZJ608Pw8XNy1uoDOb1b1/wvKceWA6XayWvjO5Xi6R7Of2?=
 =?us-ascii?Q?sytcF0XcUrWCGISYPuzeBzEZ58xRf+k9oFZKybbjKxhqEJ2n+lHstU6546BP?=
 =?us-ascii?Q?4gfqi2k3YB/bz9b9nJhkLAR/zbPlhSRIy677l/wUgUH8JXtKkp7rwac5hHOy?=
 =?us-ascii?Q?uAnyrMY7Uhm7hzpQmtDM259BigAVVTycVlhR1CxDTKWS2Y7jh8XTLj+pqabl?=
 =?us-ascii?Q?Yg271nGU++lhH1jn6sbEovFmXE9DxSO1CTLre036aeRfvKLekdQcUBgjt69H?=
 =?us-ascii?Q?0PMIEcX16yoHXHfxAYYIHKtBdQMaR6pS3B3dP0uDbHvUj8wv86PsOsdOt2Gm?=
 =?us-ascii?Q?YRmtlUfMljy6OE6hvEMDAWEgzjRwn7BGibMxwFM1AJgLNSmo4XzPUAzhBb7P?=
 =?us-ascii?Q?rr2xoc0ufUWfEiceKtQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9ff7d1e-927f-4244-c019-08dcd4c77591
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2024 14:13:51.7072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QeSAh6vKrtb9xWWpcXXZfOZsMVYAUN0RAGQlDOTl5RERrZk0YD8SKmRsW+/gsUz8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4143

On Sun, Sep 08, 2024 at 04:42:54AM -0700, Yi Liu wrote:
> Hi,
> 
> Two misc patches per the iommufd iopf merging. Please feel free comment.
> 
> Regards,
> 	Yi Liu
> 
> Yi Liu (2):
>   iommufd: Avoid duplicated __iommu_group_set_core_domain() call
>   iommu: Set iommu_attach_handle->domain in core

Applied to for-next, thanks

Jason

