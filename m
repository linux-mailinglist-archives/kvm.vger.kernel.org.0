Return-Path: <kvm+bounces-49426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 388ADAD8F5A
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:22:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2140176D20
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:18:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68BDB433B3;
	Fri, 13 Jun 2025 14:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PA0DcLhv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2069.outbound.protection.outlook.com [40.107.236.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E80190679;
	Fri, 13 Jun 2025 14:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749824293; cv=fail; b=VKQLY0Tr8XYDTYR2REglqJS20BftgbuQJdgy++ROy+uDcLcsSsXIjhzUvuioFQ7LiXEePjS2bLa21KkQgPjSD0MqZhcgw5SlnkTp3Uv38Ba9Ygmjuecfbx9C1hF5hLN8Vd3b7uQQBrGHnQ6RD8hG70qwrPYOOUq4bfbHM8yr+4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749824293; c=relaxed/simple;
	bh=VN86TTXVhS7Wg4nNrsxphafEcjvw8Z7pSG9m3P0orrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FzqUD2I9aD7fmGvRiNN17TNqM6z0f4ZkOkH9JX0ZMMYRG+EwK4MhtB5rvlHzgPGyA0xTpo8O/Hw7GJEMhzQJS0bGNIMqLpCrDdd9wFzEIN0sqNCkACUeh7Ac3X2ohhjZdXticsa+dWD2L0iq0NGqZG9MXCMFF40lfMXOt5dDzvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PA0DcLhv; arc=fail smtp.client-ip=40.107.236.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lhy0vD+MttDosrZohAFJwAlyLpO/VKmO6g6qYDSoZzuFY2hTOsK8p3u21nhf6wsNRjjYA1/qArOdlj2iTaLR78UlCq5lTWUIQkn90BHgGHg9AgZehA3MC75k27ibYa8g2otsds9Ebehj05ys1MNPjJAwVwe4q5/DrpruOU4cpEEAeRXzoxINrQKcSiemF6CXZNYlHacS1ZreDM5BpxLL660Zn4VTQVt5mzCQfPDAsgKzJxx+2FBWr2NUrnssfjUyHitcyMx+e8McNutohtcnRCh7aZOhBqpiBEMLn7Vj5+LmEMcWSCEbgMNv/zHle5Bf0yOfPITCMpbSbcMQ9m+lpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPzI5PctdFhW3FUNP62CJoNcawyXI/2D7MgnDbJ6Rvc=;
 b=TsLDG8AE8OEGwpNqoTXEm1MUBDHTiXwWS5b6GXv96+DiPnlYgPLsF+ZSTNvimdZtYVdyviMgvvFJVdB6P02CHS0RpkzXpsO9ISF2B342SX4MhzN2dPvVFdULh43mKYvOiOzRhXUwzUT49RsjOKw2YNrswZB5natVzaGVrBKebb4NZhLwzIYxGsZvUUbTFZNekgPdfpuVV5QHjOHmr89FYwLR5MNsE+ErqJ1+YIg7IIDNW7qtLHEh7SBPrt++gNIt5o4NUOQvxW4XAWKP+EzVRS7DxISJJeVjHf47cgDUvAEzRjM5zygaE6VzGqFHwsR7ywpPAMY4Fwtv6HC3DkRWJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPzI5PctdFhW3FUNP62CJoNcawyXI/2D7MgnDbJ6Rvc=;
 b=PA0DcLhvi0LmC4Pg2WME+pMI3dGaUG/WPNp6Fc5gKP59s+6eaza7Ss8oC+geHqMaPulPW18Ai99kyt5W9fChrHvgTWZmFwj03QdPzP9UW4g3WIHu6E+Yrp/J+uXeklw/mjeoZ9I/Ge6ki+2V+VBuEC1AjKvbtkjraaZzsBgqdNH62iGs6GRkg/MqVrcSi1Gd75ywcHlogJI8yGsdDpJk0hys3AKLivVJN7/NV6wpLntA6wjgwB3VgHj9An1W6HVq+o8s8Ssk+jjsVl7XemWHTHiPBvfm6D6/wrDKG3QrXO2huwpPMWJ81IVazElSgi+2cjyE4ov66SUJXO3NyOp9TA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB7151.namprd12.prod.outlook.com (2603:10b6:806:2b1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Fri, 13 Jun
 2025 14:18:09 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 14:18:08 +0000
Date: Fri, 13 Jun 2025 11:18:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 4/5] vfio: Introduce vfio_device_ops.get_unmapped_area
 hook
Message-ID: <20250613141807.GK1174925@nvidia.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-5-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613134111.469884-5-peterx@redhat.com>
X-ClientProxiedBy: YT3PR01CA0048.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB7151:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ceeb7ba-4982-4d82-fbbd-08ddaa851f1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vaR6x/z8HMbpY2wyRTFvkfOBR/+nohd5Ni1B/N5NlOKiduoJagEl53UCF49r?=
 =?us-ascii?Q?avauUIuVY6NXJ1dwWgFp1M8T0OtzQqdqwKKBdFqN+5H0zs8Gt0m/BEDMlQ/v?=
 =?us-ascii?Q?IzIkjS05vNMf/fALT43gnzDCSxBbaH7DG0IPWn5eHkTx7pxkFrTxgk2SnPIx?=
 =?us-ascii?Q?550lAf9L6fIez5mHdSTM1hJtj03uLGtXxydyh1hI7FGOslZP1Y6ullvSgsWi?=
 =?us-ascii?Q?85CSHwA6aI72kJ8/Ux1ky0AyyaT3cafWtpgXMxE0oK3DyCObwd5390TPk+Za?=
 =?us-ascii?Q?5kDtFpYMoBGbDyl+7RQatqvW7Fu/Wj20I7v8ruKn+8Aj24ob0mbEnFD6iFxj?=
 =?us-ascii?Q?U7Ar2ylSzJ5Ndd5LhtL0shoRT3n7KdF7w6Q/3L4FgXnFFv89htmYJae64GCw?=
 =?us-ascii?Q?7bicX5tJrySDvuOCpdJQwGD+p0zUkoSwVLi/8xNg3zAsGJIJNrGUMALGeBRr?=
 =?us-ascii?Q?wv6FBrgLO9UIzaIljNS27LnW/bW593xCNdTV0NM12ErQ5P2zNGyGsDajJ1rh?=
 =?us-ascii?Q?Mm+Ii0PYMicCzkD3rGIDLWSLchNtLJV/jYLy1SyBm2l0f74/PzfQX2MebYO3?=
 =?us-ascii?Q?khaFbqppuVI92wzOsK3OhSnsh4S1e2Ecjj6oPgjkl+feYjd7fPlaJQEuQhem?=
 =?us-ascii?Q?K3Fy38uJpWlLwsPbNeO6ZDDG3RXSEj6gjWiXWu5qGGbkgPSL4cYwtdAWf+oD?=
 =?us-ascii?Q?p0M2qDEGv4JHRox/sIaWUwjp0ZLRUnfWWb4mbpO1BpBOmVbSXGAMY9q52lju?=
 =?us-ascii?Q?3VkUaP344LQMu0Q1lbK9XOlsYdWgodGmPQHcdiN6v55fsbPnoWhmWHd5eyqm?=
 =?us-ascii?Q?RnZr7yU5XZHF6E/WONneGtxpULDOycqib+kbsGUjhBp0VxlmCiJRm1HXdf7L?=
 =?us-ascii?Q?6JeYFNMY1okKaN9fMBp5sxudHpCU5a/5n1WZHMkeE4n+22zdyfZhvAdVa7Hi?=
 =?us-ascii?Q?DiELJTVo/VEmksrO10i6bHRDbxzEj+ldXbowL/zVXtHBj/h9YM7sAy2YFAAd?=
 =?us-ascii?Q?jIeAFt7dqJlZkMcZ1NARWI9LZYxIThiUowRXGQNbKcCxSZaluM5AwKEISE4C?=
 =?us-ascii?Q?bvoJ00C9647RXn2sJjiuQ/DczuPZ72C1kE89T60pgOxsftx05QKGvtFZmt6r?=
 =?us-ascii?Q?uxCUsIKAcLOp+kHPpSZizIn5UU0gwQDglo2UPns3aNsd9sxlTsCWRHlzpebG?=
 =?us-ascii?Q?s2B87597xhvsP6rGwFVYLSQDjb2pC+MtgPf72OJInXyX28SAEBYCPqPsKYlA?=
 =?us-ascii?Q?klLbW72Rl2JdJagVzt1kT7T2pdhD4g68E+1IzfhWxZguQ92M1FR4Hril2Bs9?=
 =?us-ascii?Q?VIsuiETHOaS0ee0FZYeAS/VojSYXoeMoXWIwVEyVQG5wXdEmxwVq4NK5w/D+?=
 =?us-ascii?Q?jjKwywG/x+ycXE2uxJaerkwEjxOAJ76P3B8Ee3jYnpzRJZv7ogE7Fp2gMGEW?=
 =?us-ascii?Q?hKoXPhTaC7g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yIg9SUMpigf21mhBUy3iOU49GVUiw2GOTJWc/B62okMFtxj64Ih3YnStH/C1?=
 =?us-ascii?Q?DWEgiapE+DzyomkJeIV7Wv3erhTp3k87iuXOGfBZxRF/DLAQ59rvcYZZ7TTf?=
 =?us-ascii?Q?59tzvPOyRz9UkerzdvKqZOQ0RiDNFUgcWbHCiVPvrqfbJdb790V1ac0vy+mZ?=
 =?us-ascii?Q?irzWcZgKwngQJ0GS/iAgtgKvVwjd6/USLa+iW528CwRH/MhFc0qasviywltF?=
 =?us-ascii?Q?Yc3nBokq+XzK/jPYzwr2cq5FlevjyDaBeCoufu2pBaiInyKrrj9o7k1/XUC/?=
 =?us-ascii?Q?5dx/0e8DB8nVireZiP5Q4uzRsv51wmAhg5cKIkcP4ecSP5EyiqGQZVolWUj9?=
 =?us-ascii?Q?OXjsNsNmnpW+QgID937XbAp2XJ4N+7Lx/wGoNiaancEWIJ4cpkwdCmvAk5A8?=
 =?us-ascii?Q?ZOOPV1z1GfpRzjOdf+2v08rPgicWWHnAN65GejrBwW7l367kPvNQvXL6SvL3?=
 =?us-ascii?Q?wBJ77/bSg15oOvjok55OJXMZV74EB0ANiGQCEXf17fCAh9qRANLOc/e6I6CB?=
 =?us-ascii?Q?E85BB2ilMyDViEO2rLw1PENAIp7PGxf0wKaI0eEVe/BnfY7cTTBWHbbGSgI/?=
 =?us-ascii?Q?poGh/ZxqDwQbO/LCXDpduDMlZz9g8CcSUpSQz4WuhOSab3jN+jjdGZmaqreA?=
 =?us-ascii?Q?XsdfGC8ZnHXgRkdkbHlWS09kNGeTCoKHtZ8+4rds1ZZ1g2FmGij8tqqEsDZa?=
 =?us-ascii?Q?tumjILUbe5POoz2omurssjWmPJG5+82UJGpo5jojnMucNwe/jI6yaURvXmht?=
 =?us-ascii?Q?x1Z0zPhjvhmrHYmI4rrRvcgpTHEe5P4q/PMET4rhVCJOnmx0Jq3tvfGnT4DN?=
 =?us-ascii?Q?3mEG4ylhRWpGpGUbJvybxWG+Cfs2FJ69HAcpOJbF9riYQeaYx5Efaz8uNFZr?=
 =?us-ascii?Q?ocjDXavVU5Bg8em9bGzrlzTStwlYXHNqXEsY4Lzcy62xJGLkb1KOeNbJRxxW?=
 =?us-ascii?Q?BmUzs+6FhC+/6n2Z7AVw+1sEnP2u9a9Bq5zPazAIpXL8kznMUPiN0U3/vwuu?=
 =?us-ascii?Q?Q28OL0VmSEOYNNr00SDcf0dzi80m0GLf9aftHGn40rOdTyC/CkmPdj1hDWH8?=
 =?us-ascii?Q?8zyhy4HkgyUHuZODkHS7wWa9rhe67SXqjgXyw1yxysreOpEOhIICYEpA2K4g?=
 =?us-ascii?Q?UACNOqaz3/kEf4jyRH5hRNlouXBIAjMBpEj2YhEkrrl36XDqnrHtGxUhczpS?=
 =?us-ascii?Q?BIpIPJoPxr3ErLIuwmt9gGAfJXQGhbPocqiwYtxX8be5cOwKgCaPSmb8XXA5?=
 =?us-ascii?Q?GNxCm+w8i+a4KqeBw13RBRWxIh2G0OJdLOwieDqk9ahr/fMW7nsFY8I6qEXM?=
 =?us-ascii?Q?EmI+jdcQi0BWXpdVs1y8CgJg6DeYZ3Zxqz65qpOBF2KNyLHuxZZKLt8zSTSj?=
 =?us-ascii?Q?qzaZVMDO2jcfW9KsiY98AymtGkzyWcwe4hU/qkvhQss95HBVqCii6wogaQSP?=
 =?us-ascii?Q?BBcVPScE9W6p/F7MvlgY4GlDCtlPACDVXKvxpWemSrXCNPV4nU3tWDQeS4rm?=
 =?us-ascii?Q?kf6U9sLfuyNylgMa6JHpap48032Q7nYloYNa4dLaKvr27HkiA6tLzaTI4exu?=
 =?us-ascii?Q?t5xHeRLkoa8Lyf3/CHbrADcgrKAxoLV8if1eFj6h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ceeb7ba-4982-4d82-fbbd-08ddaa851f1d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 14:18:08.9193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGy5EgH1LEWDC71OJP2B0NEr5z1L1yYB+kkUAKFjPKSJtXQf7g7Gn4BusVokM4xL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7151

On Fri, Jun 13, 2025 at 09:41:10AM -0400, Peter Xu wrote:
> Add a hook to vfio_device_ops to allow sub-modules provide virtual
> addresses for an mmap() request.
> 
> Note that the fallback will be mm_get_unmapped_area(), which should
> maintain the old behavior of generic VA allocation (__get_unmapped_area).
> It's a bit unfortunate that is needed, as the current get_unmapped_area()
> file ops cannot support a retval which fallbacks to the default.  So that
> is needed both here and whenever sub-module will opt-in with its own.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  drivers/vfio/vfio_main.c | 18 ++++++++++++++++++
>  include/linux/vfio.h     |  7 +++++++
>  2 files changed, 25 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

