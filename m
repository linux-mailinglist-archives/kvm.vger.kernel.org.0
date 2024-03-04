Return-Path: <kvm+bounces-10808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A70F987048E
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 15:53:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34043B2358E
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 14:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65ABC4597F;
	Mon,  4 Mar 2024 14:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HPrR6a06"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D89326AE7;
	Mon,  4 Mar 2024 14:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709563992; cv=fail; b=bOkc/9PhzQDEQQCPw68oiaQO5XHBLnPq2CFTpzjsByS8/fTsIttw3K5N3yPC1CdT2EwnTfDrOlOD5mkh6f7cwmdu/LlLJAQ5D7MeyIe0wu33cbd6Urbjawa8fmgkKvgNKs+h22kpNyEpCrkO0FGQjbhG21TeK5tqLurEQEqk7nA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709563992; c=relaxed/simple;
	bh=LDckUK8f11ef7G3cR55JUlpL4wgvySlecA2s9bR168A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EFywPNlFQv5h7c9U2w0J6/4uR2ppjpzRf538tjK+qI/qzr3SbI0jAOdWhYC2P0TjW2T64PGVRblo29j/6Ochr1se4UclRhlG10Xw68H/i3IKvO9t2+VoWTIslqk35vZsyGMEjobvsWR6PxbZfhYmGNNoxg74v/pqw6yyrnU0N1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HPrR6a06; arc=fail smtp.client-ip=40.107.212.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbYt/7aEBmSrT6LOhRI25JvbY67pK/6CAAg0KfeR3V5TZ2zOfEkKL+3IDAIaeelNPWHtvVbN6lsq1CA9bYjsxrd3C62qOCb7IQyU8nDniRtCvY2qeLWIgHp/ty0F8bZwHWWgx88IRRXnU6SSYBV+p0JAwpiZUUxZtZVobJNlgsAbvs8YYPHJgG8PGitdsPyuF9FZaKgIXPRa3jN5tOL3cXEhZDilnuZ243FB0y6NPBKmO3jAwkV1gn01lBtU+TEXKnj+qQr+GsOV7Dp8/uChDkfJgDFdHCXWp5f+HxrcD7WcQau5SWwUF/WkzsSmsWRT/r9rOEzHH3AT2fYkFRt9FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bp0XpIogAtx0/V1Bx9inWMhX7knkclCA/dDCu62b+hE=;
 b=BSl5aBJyl6JbcUahgl50OlQ3TyWJW9QWiP/q753wg11eMwIPOdiPYfuirzZqnK64yh4z+Fxo3ENAFquHYqq7BzlJLkegE21Yvq4DmB79MC2GHiVA2aXBrRKQJw/GScxHfxcLmLmDgeIfdZW8RoLbmjbZDzVFYD4/yH7YNwNPVsFiiW05k/Ji4oCWcrFUDgWRcMH9L//w96MqYHfUtalkC01mv04NA1SO6JaFRUjbJ5p4vNVsmeusseeBUyW+6HQV7W30KF53SZk3kJQnmmMwebrh+mi1+LctvQoz+Hg/d/wOoW+IylT27+Up885I0wYREUcQGjQ6u3yOOpuQun1wlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bp0XpIogAtx0/V1Bx9inWMhX7knkclCA/dDCu62b+hE=;
 b=HPrR6a06v6IvEcHs5ga5BnuY3IbG5G9QOl6W5UAua7ju+h9ezC0sO37aRRZlji/0U8WsijBMyhmP2PDoBSVMPuFB6azOQA079vxTXaG9AkceqLWEXk33UEsNnF0tUx2gvlpEvGi31DQH+IK5NR8iXPR31SKWtGHpJPoas38lNqE/9hV7Ou+28Z1uVPS6UMXuGshpcBQIeuOiJsNS9WfqaQmqlHhxUIloxi/o9DuNzrU6wTqmcmAdXKnnLt6a0kwtX5jNCKxwqNA6pvxOq6rzyGy9zBeL2yH0G8OOYfBAPrZJlJiZ11pfeJMsU3JQGXY+Ba6eAsAduolZY+VQwISP+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CYYPR12MB8750.namprd12.prod.outlook.com (2603:10b6:930:be::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 14:53:07 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 14:53:07 +0000
Date: Mon, 4 Mar 2024 10:53:05 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: ankita@nvidia.com
Cc: alex.williamson@redhat.com, yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	rrameshbabu@nvidia.com, zhiw@nvidia.com, anuaggarwal@nvidia.com,
	mochs@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] vfio/nvgrace-gpu: Convey kvm to map device memory
 region as noncached
Message-ID: <20240304145305.GX9179@nvidia.com>
References: <20240229193934.2417-1-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229193934.2417-1-ankita@nvidia.com>
X-ClientProxiedBy: DM6PR07CA0117.namprd07.prod.outlook.com
 (2603:10b6:5:330::32) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CYYPR12MB8750:EE_
X-MS-Office365-Filtering-Correlation-Id: 949a9a7f-3d35-4565-7ed9-08dc3c5acd81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	l0WU94vKecgaQyAfaIU61RwSe768h2b6eO3g9sJWuzW7SqoyeBFsS7b1Oh/VP5PMSb0gfj9gCMfUN9seHiPnHiCNdOYmB7fjvBRXIzuq0fytgVNwpma/rHUfC0XQZCI233o0XNrtpdnAQoluvxDUk6Rs5CXjNTd0TLCWTVwtNSQkpggQ2YFJfQNZ7Xdij08zvzHCrMAfg7+Hv0QkXo4+fSz84vVxiAgrTzHud8tf+YfnPNVOnZkyDKI0073Be36HZrQtCyvm2P3GrZdr5Q25IhwyYByn+YBY0Vhyp8LB02LEY70zf2mScKmrFuodigc2i4MoZfvFJseXLglzXNKICLAACB1ORisMH9FGjvuWmA4k7d0TX61ZreigRu8JgzCJlzR/GDse+/tI9A6qCU48iT0f3zJz4z4ty+xiU1vefZsgZ89Q7k/Yp8L/2jSLl9dk5OIodccCQ49ZMZhWDSjuy3hDgnTHO6lOapKa9a8yVwCpOHZNWXHDjwQHT0exwmZRZOy7vOUsD4GtfMl/ItlyrWuJJJLRVxpuACc9amrZOd+7FoUgRTgKMLeaeTvX6AcvU2oDcggwAwxgVjPROcZlJnJXYwVAfTdrM41oaeehuxTTcgV9cclRcLDhz2Oc8EAixGgK0YRd36vXTPLw9ZO6PNB10L+nTy3LwMwT/H5chW4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/CYwH6TinYaf+ojwf5pmhci68wi/I12HBbz/Ocfryt3oU8ufcx0ooynAmxeo?=
 =?us-ascii?Q?HzAO76M8rkjCVaZqpHsqKeguiFyJGR+1kCfpp/GQhuQv9tJe4S4/OYc2q4zU?=
 =?us-ascii?Q?6nCUStQkYLu1a5VIpERd/oyBSLhMMmTpgVHImM2R/+y8IDDyzsdlqxFqFBM4?=
 =?us-ascii?Q?5rmyfcMw0WNdGkd99uVUnxwEV0+mOENYnDz5Q2sCf2aMNF9G4YJiIY5ONi0G?=
 =?us-ascii?Q?g+05F9oQrYQl337jYT0ZT07oEXVYmCNe5LLWSmSYYB+/S0fwY4hmgB+aLvVJ?=
 =?us-ascii?Q?ROfVZSQV/jn4tcFuExGjKlqg/7C8T69ygK8M7wpKeFf2XztMIyquNSZWAhHS?=
 =?us-ascii?Q?H10NiLrss9sG/jEH/CCKkELSlUAKfhg04ZeWMjvORuptteToK9eCAtRwLfM3?=
 =?us-ascii?Q?Vh9H3IkNElez4lGbLoxO5xc7TweTcmcHhPAnV0QmjdNmllZIFzQt+q/acFaf?=
 =?us-ascii?Q?i8MprwCpktbT3aIPe+XsRRn+42+sKwBMk//riIL3nwtr/0bX96qfwk0nmbga?=
 =?us-ascii?Q?7iQKorMSToLhsnavk4FnuzcHEjL7LgsFmewT8LYd6JpD1GWHPuDeV12VN9/I?=
 =?us-ascii?Q?ogxOHiQyiTmtlDZHJz0iOZdyJMdslDS6kxa0V5t6f6EtMdhrI6m2H9wWTo7F?=
 =?us-ascii?Q?EJBWkWyTSrRRrhY27nWre0japyFiMVyReqQJUfggQBjPwy1ug8BxLJ91Rggg?=
 =?us-ascii?Q?tvs045ltWLWCd3n7wpC4qF4NsLyumcsmGVdgnjTgB61zfREI6yapjFt92CGL?=
 =?us-ascii?Q?BkjrnbaeBVDbMD7V6LBskawJOgF6oZIvuX7UDkuWg02lviX0k9jdY315DUJs?=
 =?us-ascii?Q?7blKZphw/b+MCtGnd4CjxaI3e8jR3epVZhxfs6xggh6VaTYnTWwNPOweDOki?=
 =?us-ascii?Q?eilp0Hu/8lExwTtEX9C7jRx/PvNlc0EnRlVD1Zipvm4Lw9Br4DT9EpmHOyKM?=
 =?us-ascii?Q?msGfxepnMf4rQQ0ZD1OW3sOCfT/MTGXx55a+uCIXm/OodBvGtJ4B9WP2bHty?=
 =?us-ascii?Q?Bej3j6NsEEfKKYxdsAqDFTDFcUH5q3p9SdYuHcLS/4GVQTdihKS+B1MbM2NA?=
 =?us-ascii?Q?IsjeWtRgUX8cyuzDJjw3ey4XCufUd71hdNkR5XeewkVx0ybMT4/Q52XO8ypQ?=
 =?us-ascii?Q?wspRc0uPYqL8hG5ToopIdgI4/O/0P1fscK+bVrxXffofzFfj6k0HoT4km4KO?=
 =?us-ascii?Q?/GKz//aVu7z56nSNCGyRigNDZLPMPknBlD0GZBcuZUo+OvBb6VpDfzyfMzD6?=
 =?us-ascii?Q?AHfpI6JG/kY9oLCx1cHiBxIHgq8oiP2t72Ap/9I0MXH9C9vp7GwOz0A3aG81?=
 =?us-ascii?Q?FyQ3GsTPZr+83tbz55DuPgZeOQQzArzdmsASN3sNCUrNqR2IXj94WB0G1ous?=
 =?us-ascii?Q?FSVwZeMTfeigYXOIVRiMj3Jt0sP1u1eDRGH4n/8jrdI3QhWJ1H2Aag9/0zOY?=
 =?us-ascii?Q?qtigG+5HrpcXTR9VpVyGYKMzlqjrTOZH4K7j09guXvXC6+vdFi70Jkf/zWOj?=
 =?us-ascii?Q?yQX7dZeOcktdgBbMtaTvLNDuTEe7zlxupxxHaGGHGhEZzKuv5q1icID3WXLc?=
 =?us-ascii?Q?jU4xEiMB17BhbuSIo0gLTILjO6sdUNW7HBjY/blM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 949a9a7f-3d35-4565-7ed9-08dc3c5acd81
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 14:53:07.4918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3cncKe7MjPlda19IfA18c4v8SF+l3HsLjVR5oGn+/KR4TnG5G5UUhjCpUCJUA80o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8750

On Thu, Feb 29, 2024 at 07:39:34PM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The NVIDIA Grace Hopper GPUs have device memory that is supposed to be
> used as a regular RAM. It is accessible through CPU-GPU chip-to-chip
> cache coherent interconnect and is present in the system physical
> address space. The device memory is split into two regions - termed
> as usemem and resmem - in the system physical address space,
> with each region mapped and exposed to the VM as a separate fake
> device BAR [1].
> 
> Owing to a hardware defect for Multi-Instance GPU (MIG) feature [2],
> there is a requirement - as a workaround - for the resmem BAR to
> display uncached memory characteristics. Based on [3], on system with
> FWB enabled such as Grace Hopper, the requisite properties
> (uncached, unaligned access) can be achieved through a VM mapping (S1)
> of NORMAL_NC and host mapping (S2) of MT_S2_FWB_NORMAL_NC.
> 
> KVM currently maps the MMIO region in S2 as MT_S2_FWB_DEVICE_nGnRE by
> default. The fake device BARs thus displays DEVICE_nGnRE behavior in the
> VM.
> 
> The following table summarizes the behavior for the various S1 and S2
> mapping combinations for systems with FWB enabled [3].
> S1           |  S2           | Result
> NORMAL_NC    |  NORMAL_NC    | NORMAL_NC
> NORMAL_NC    |  DEVICE_nGnRE | DEVICE_nGnRE
> 
> Recently a change was added that modifies this default behavior and
> make KVM map MMIO as MT_S2_FWB_NORMAL_NC when a VMA flag
> VM_ALLOW_ANY_UNCACHED is set [4]. Setting S2 as MT_S2_FWB_NORMAL_NC
> provides the desired behavior (uncached, unaligned access) for resmem.
> 
> To use VM_ALLOW_ANY_UNCACHED flag, the platform must guarantee that
> no action taken on the MMIO mapping can trigger an uncontained
> failure. The Grace Hopper satisfies this requirement. So set
> the VM_ALLOW_ANY_UNCACHED flag in the VMA.
> 
> Applied over next-20240227.
> base-commit: 22ba90670a51
> 
> Link: https://lore.kernel.org/all/20240220115055.23546-4-ankita@nvidia.com/ [1]
> Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [2]
> Link: https://developer.arm.com/documentation/ddi0487/latest/ section D8.5.5 [3]
> Link: https://lore.kernel.org/all/20240224150546.368-1-ankita@nvidia.com/ [4]
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Vikram Sethi <vsethi@nvidia.com>
> Cc: Zhi Wang <zhiw@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

