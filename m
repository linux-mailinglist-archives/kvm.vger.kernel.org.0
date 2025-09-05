Return-Path: <kvm+bounces-56885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3128CB45962
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 15:43:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EC22485BB5
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 13:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB068352FF3;
	Fri,  5 Sep 2025 13:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H9XJEviG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB80C2750F0;
	Fri,  5 Sep 2025 13:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757079745; cv=fail; b=HYmFqwJ2HxzQxV4gd8cMD0rq8svC+pC8i70zv0h0ATnmmNKJYkIn2sMjVarM+D3fiwlUeQxmLFyhZVu6db3RfN3svc9Pe+peLxldb002sF9I9u6SCUagzRoVhgdfj7Zc/zwDz0l9/70OtYubx7ZxJmkRT5YXXeKm2dH33f9f9xo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757079745; c=relaxed/simple;
	bh=Ni9xfA78+cNJaIHDDbUBPIWwQhS71QU+42f+nxdI1Vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dhXafJZ0hTTZhTj6BxFb7xODKifXARrnty6VoWvQa4A+ZLNtraQrE+Qtp8+DEne9Kg+AX51W+GSR/qhejOJXmj1Ej1H4tDn3YM+zTUdOk52TjMRETNAhSkY9ihAadKa+lU3StCWngHsSeGKGZcAOzBjXibCrkeTHQ2Vdn9vZqw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H9XJEviG; arc=fail smtp.client-ip=40.107.223.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X5c/oElzc9fTNGkoo/JCNDWtG3bqoIiNOY3mPJphJCfgXHxckY8XI1A/nofXsXSOJKvfRpvCWvQpSNsz8aHsonk+rguMV6P6gESSsanQveu6RHzenWVmuwtpAi/ET4SyhxKr9DCHRSYQrXNjZHAPonXebyYABTNb+gbhoUHsWr2duElRnv2lpW2PmEru4JKusC7LoayYqF+l0R4KDtJs7e2bZRnLcGMsjQRxC/qeOtw2iyvUabtjvVSDWMExNZmBssw3ejwE9S18CfVqOOfxFElBVU/Xw2EEiwDenp3n5L8mEqPZK85a/jtc/3npJtKpCDcKdGffHkgtN+WkoYF9Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AF3eTrnvrdFyMBQYzFwsLTAp6YtGHqgmWa1FIGap4CA=;
 b=h0rVf+vvLnHcUhVRMSkdtbZr8o1oxolpQaHFXOrIv3T/fzzm3OV5UG3ZaS82Mjxs22+/qkPHLcpAgQx2cLikmPuOPvO5f6HLRPUJsDX1iI1PP8cAQVSCOjaFY5StFMlhfonedGX1BX44FYiqeTMWZY/ptQPRR6MO+clwyGXnYhhFk0nMrY483AZptm83Ad9y4WD318Opd1b4HmeN8ftXVNXJ7YAtd2v06h5PiDkg6N7mSWrGMO7ZVregcZ7BkJqfVSbaEZgzKWyGEyp54eVVtHJL8WKYcnk+0Rx0urTnAZMGRcUm4xdL+Pwg1NJOQAVRKcKusC4ir8sFJAL1zecYpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AF3eTrnvrdFyMBQYzFwsLTAp6YtGHqgmWa1FIGap4CA=;
 b=H9XJEviGHgmbG24YySo15QIpXWHxcJsymK3zmL9ZBkCIT7V9578a1ScHznYoW6ky6jzECOuaX6GHVMdTE9DhBVb/Co8PlcgFpYRZe2nD163JwmRUtmo8vvGs78w6uiv7lvcNa/Ej1h/yPenkOlB4ajpcyIzDcat9XxEcOkCG0SerOxhNjRXVfbueg2MbIkOvyZibn2Ky7QTS/UDPtwMyhPvx2sHrJykk2klkvguFVezpftY2zeFHjEU/JWoRNiRewkeiT7qCaqkQfuQeNFwkoIyu7CbgzJ+XoxDdxEs/E8WQTIeJ9CYsv6ukL2i59Ljd1ZxuyiVku6BW8qptb5ZGng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CYYPR12MB8871.namprd12.prod.outlook.com (2603:10b6:930:c2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 13:42:21 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 13:42:20 +0000
Date: Fri, 5 Sep 2025 10:42:19 -0300
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
Subject: Re: [RFC 14/14] vfio/nvgrace-gpu: Add link from pci to EGM
Message-ID: <20250905134219.GH616306@nvidia.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
 <20250904040828.319452-15-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904040828.319452-15-ankita@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0308.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::19) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CYYPR12MB8871:EE_
X-MS-Office365-Filtering-Correlation-Id: b8a85799-230a-40a0-a6bc-08ddec82098a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yCVnou6OnIF8EqR/F9OXysg+phpxC3AQ8lGvZ+8fG/jJLs/l1nAZVTIGvAKJ?=
 =?us-ascii?Q?/R153+AL4B96laOtGm6zgWC4CALstlpfwSVVhqxJXYEq82rIbyS2hfp27a3y?=
 =?us-ascii?Q?aozlOfNibTDHcISPFUfVF0MdYDX/8PioWwUY5c19Nw+Y87zN15NL00yxtQaK?=
 =?us-ascii?Q?x1F01xos/IWVi+NdaNhXUrN6/Q9qq82nfcyF/BVVLhwC3klTV54f3OwE8j6e?=
 =?us-ascii?Q?yKYgrhyFaxXJyKg/ZxA1LWIL6vqPlqXMHzML2UorbD/R+XkgrKZ3uKUIz2XU?=
 =?us-ascii?Q?dlHA8+3KEbYVE/M5Pv3ITRj+bLGNYucKbaOlLb6+CTDKcbqsq98Tvljintdj?=
 =?us-ascii?Q?ijy+t6+R7J89CKR3dHrZ8jQo/+Q7l/YXSrbs33+bVJsrcALkLc4F3kntHzaF?=
 =?us-ascii?Q?5GPEGILg8S3EGg9ifoSLGGEClB0FkqrdA5k8Ho7/ITAfc+6CIJqr6EA0VTw0?=
 =?us-ascii?Q?9m15/oPmTZba16rekKdilFjOuPR/n9EAtcGxkNa6UIYQ1Bu5XRReE3tO/5Ww?=
 =?us-ascii?Q?dUG3d3k7KOQPOJN2v+wS60Q/+Mfm1btcXKYo0+6KamWmsJQ0gc7reRA/5tY9?=
 =?us-ascii?Q?OfauznyoC1jE6pKwRNzu0rSRHNJiRq61HfNUz3NSLO5xBBIy2ByF7oeXv12A?=
 =?us-ascii?Q?csBPD1esycrlTBk8QmJYiQd3EtDUQPHKHHEIB9Vv+mFkR9iZVsUj3rUz8sj7?=
 =?us-ascii?Q?9gQuN0HZYBNgctbv6EUyGMyYG3lCHSvFu0IcbrUTbGgObD+XFggez2zBLXkp?=
 =?us-ascii?Q?xZ2NDzhyiRm2SgVKU0f2Ps00IkM+YFYcm6m4qZUAQtmEPxZ27P8h5noCc8lL?=
 =?us-ascii?Q?+h2QnIUrbbhuBtHDxldPchQGksuZPgQJ0E/eRfjEmbJWesiqLaTc4kZ1Jbr1?=
 =?us-ascii?Q?yDyInyq2tICukymvftl8JWcXOulW2L+oHytenC2x5dPzahfwhCeZsXHhqeZ6?=
 =?us-ascii?Q?dvUECXTTsDIJKoHFRjn2g6VUmJSGc1xh00HmmpFU38iJ7FdYfVI41uRvHr9V?=
 =?us-ascii?Q?ViSgTkKGpDdLdJOWBsS/NscikQSovXN8Q2Q73DYhvPcJN+rcFciggGN51f6i?=
 =?us-ascii?Q?l7colYSKXT5CzgVm7DZ7aO59in7nKYxY9ORBg0qvpMJll32dQMqbI4eqlWlC?=
 =?us-ascii?Q?DTtDpTW8i/ki0QtDOPxqMswVz/4WZjdN84xbyQTDpsXiohw7LOFslbwR63Ys?=
 =?us-ascii?Q?Lwf1k3bd5Bv1jn2APn0JkSfc7SF+KKfJEQIcH7+U612F4E3TIQ/H1xYDX0R5?=
 =?us-ascii?Q?4q+iks9tkymElY+dtsB40RcTdW+bQ8ZbDIh2fI3CLZzkvmiSCCuT0IKFkWib?=
 =?us-ascii?Q?Op/A0Oz88Q4+7xUyz30tE5x9rqau735Ps3pSM1Zlu6ubMv7/LbUUhT+C/wU8?=
 =?us-ascii?Q?la1/+eDAQb0dEqkLa3/divzWFV4UXP5BTO3SDd1shq6sUIDnvaw0xIUXfZRw?=
 =?us-ascii?Q?O5OMhhpye4k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AN4OUx3s89iJXzxR615FWfuTstmipAnZpB3MgEQRNeNvxmSJJpNrvUYa4BmM?=
 =?us-ascii?Q?TTap6KgQzBva1O18B2BHmEvqX0vyxrpqvnUdMIF27wH7Sns/RcDcR+hfWyNS?=
 =?us-ascii?Q?f0vJiIujkYNbAOeG7uqymQ7j9Hj1AgskV9DKHBRVoYYtmWR9Luk7NPfbBv5Z?=
 =?us-ascii?Q?2STdCUVZLjoioUEGUZdC1NfpUyxixh77181LMXYz5zTxE7x8qxi/JSoF0JVK?=
 =?us-ascii?Q?QWnjya6nmqOzLNTWsotaddWJxI6QJdPiqq4dzmyaIdUYLQvgtKNYfN3yuT4n?=
 =?us-ascii?Q?E/ONNNFDdPAsD0UFFrRR5S3TIttH8Jx57cU+t9md0+W7lidYcP29ASDCZM3N?=
 =?us-ascii?Q?XS4445YwrCWsuXOfKwW5VO8Yju8xTiRXZodRX21uUG5qq2grsQ2AHYbJEs1x?=
 =?us-ascii?Q?uyQ5IObDeMlbOBSxPCOa+z7UILCzZptdYAcPzp2BmE0FJoIKlCJyreFamqkB?=
 =?us-ascii?Q?xga/juBWMjRxutr14FYMa+Lr4xSd/lRKyt0h2+epHca6DBwVKya4LXvmbXG0?=
 =?us-ascii?Q?AilzBTSUiNDt4g0C1mtTcQ9XJigsCRa/PuZRoaJCeNPq0FLuaI7KyhS3K4Nd?=
 =?us-ascii?Q?qknV8uOK+cFpFJ0Jix82BVqnfDj5KziPpJsO0Migsnm89wrUD4/6h9brQHpZ?=
 =?us-ascii?Q?eFRAVYUILll0y4jWTSt0x2JfMTrlCpKwTdNA5ZFhw8csDelMLsB4eiukAyMi?=
 =?us-ascii?Q?cWHu/jaeWxLlV/O4GaBVqCbgxcyGT8VeXZDtyWiIlIDRnfwcKS4gWJujid+m?=
 =?us-ascii?Q?eXyUzFv89A7kSZ7DGbmHxC2/7KZaao9+/0/v6vX7C+27EOQjFnmlee64+Nnx?=
 =?us-ascii?Q?8BpLLyV5v1Y09d2TnUdsrh+n5PLX5GYPzPRQmTYWUEU/1n17CspaO0me7ghn?=
 =?us-ascii?Q?mr12wPA1B3pAliozMwnpckppRKG9dHObwCPl5s4uLGobM85JW2/EB2asFNFd?=
 =?us-ascii?Q?iMQjLrudOQO4/MZXe/rj20R8lMmUbyZl9H+AZ2jtTL07SGtePILY80xebCOA?=
 =?us-ascii?Q?jANRxocf3jeTCegpU+pEe6dNxyhW9TNzXvxWSoeO/Itvxab4cveWeXhbTBQb?=
 =?us-ascii?Q?wWW1yoJ35xvI/x9lFmUS88OFfyfBDYtzeX2ace4XwXQIY/2E5sdA0Qut78TM?=
 =?us-ascii?Q?cGxKUa0Ng9ohWgjk3SlKOYIeNF0DXpfQoLzlNON8tVt4mkBSYpKYrqQwkEos?=
 =?us-ascii?Q?xD93Kgy/ZktsoopB2IfuV931KiROolKXHTbnfSuR71DJLo5KNvwW7VkFzWX4?=
 =?us-ascii?Q?ugEgmwO+saC5K/C13Nm447IDhsUnfVKm9MmmQ87QNoPsNmC3lZ+ptaH5i5dg?=
 =?us-ascii?Q?FGWZ1k8C5CBAhLBkYguBDt3knvlpMU0b+4KSHq0Xgv1RX/SGLl+E0WP94y4M?=
 =?us-ascii?Q?I/XVYmOo28GKHYWF8yJRoAfg6XHRgCffW+kPaZ0yWZUvFkao3IBHmTBUJDKG?=
 =?us-ascii?Q?GD2z0i11FtDs2/RwpgwlEyt9ncT7/mqfBsBpeE3of+ILXEh1/0xHyoigodQJ?=
 =?us-ascii?Q?JlmEefF0BiFhTqpXag2gDeiKkBw71cFHr4O7SFAhEhEvLiVkrCPY6Z7nTL5z?=
 =?us-ascii?Q?K6TbZN9Qll3ubP1LD3w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8a85799-230a-40a0-a6bc-08ddec82098a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 13:42:20.8279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Rdd/w2ukx+Zl9gi7tG+t0nX1abqgPi0/5Hlb0TGK8uuvf6JTFjbL85I78f+87CY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8871

On Thu, Sep 04, 2025 at 04:08:28AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> To replicate the host EGM topology in the VM in terms of
> the GPU affinity, the userspace need to be aware of which
> GPUs belong to the same socket as the EGM region.
> 
> Expose the list of GPUs associated with an EGM region
> through sysfs. The list can be queried from the auxiliary
> device path.
> 
> On a 2-socket, 4 GPU Grace Blackwell setup, it shows up as the following:
> /sys/devices/pci0008:00/0008:00:00.0/0008:01:00.0/nvgrace_gpu_vfio_pci.egm.4
> /sys/devices/pci0009:00/0009:00:00.0/0009:01:00.0/nvgrace_gpu_vfio_pci.egm.4
> pointing to egm4.
> 
> /sys/devices/pci0018:00/0018:00:00.0/0018:01:00.0/nvgrace_gpu_vfio_pci.egm.5
> /sys/devices/pci0019:00/0019:00:00.0/0019:01:00.0/nvgrace_gpu_vfio_pci.egm.5
> pointing to egm5.
> 
> Moreover
> /sys/devices/pci0008:00/0008:00:00.0/0008:01:00.0/nvgrace_gpu_vfio_pci.egm.4
> /sys/devices/pci0009:00/0009:00:00.0/0009:01:00.0/nvgrace_gpu_vfio_pci.egm.4
> lists links to both the 0008:01:00.0 & 0009:01:00.0 GPU devices.
> 
> and
> /sys/devices/pci0018:00/0018:00:00.0/0018:01:00.0/nvgrace_gpu_vfio_pci.egm.5
> /sys/devices/pci0019:00/0019:00:00.0/0019:01:00.0/nvgrace_gpu_vfio_pci.egm.5
> lists links to both the 0018:01:00.0 & 0019:01:00.0.

This seems backwards, I would rather the egm chardev itself have a
directory of links to the PCI devices not have EGM manipulate the
sysfs belonging to some other driver and subsystem..

Jason


