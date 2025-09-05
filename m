Return-Path: <kvm+bounces-56880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0E89B45938
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 15:37:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A51A1B232F9
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 13:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398B73451AF;
	Fri,  5 Sep 2025 13:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="siQbMdfl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897B21AAE13;
	Fri,  5 Sep 2025 13:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757078807; cv=fail; b=eAifUFhqxD/ogK0BVAlXINGaaYRVvg8fd/Rh93/A9PwqmA9hW3OJrp/QntwLpRHt7+YMvdGnHXW8DBEJEU77Ffng0BzQ06+ZYowL3Gt4v5iZlZ0ojYnglOZhycaXD2IQ57aCyTm+n+5s5LxW1dldFJjvLLsKqSZznyOPMY+CAW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757078807; c=relaxed/simple;
	bh=qdD/3TjijmqI1Z7o4SIMbFJXnOVExv4JD5xfG6kDqYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fqQIYKYLEgHkkiBn/Cek7Eop+1fIxKi1KnoiFoj1GQONie8GJtOQhgAEcauf2FmW7c0fc5pp9hLlfy6hA2MpyFskjGHW7wRZESmuMPkcFpwizOfvzlCr6iS03pJskGJUprf3DZam8OkNx2ZHayqtHAiSpauALrxKdJjkSH0IbL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=siQbMdfl; arc=fail smtp.client-ip=40.107.243.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k9Z8y4/kVZ7aqVDaeJqNZduLa0O2XzQ43Cgb2AVt7tskJby6aciquwhX7BlsITEacUP/xV09VxIcQMV+VxpmMpNHeMJmrXvVZUYRAYhhHWvKCrOH/onHeQJJIAyk4kr6nzlX5FPAUW2ulGZ1qPJwX6ZBF28skcog0umYTAX1sZefpiXFiAqr7tEZOl9zF19Q17PiRlM2Dh3Ny8dGXkKFWaBIHCzD7aPmYq5hCzjd8fiXGZu8VQeVpZ97YwoJumtKZuH97G04gOEtt+CyqexPhnJRmmKp4rBY4g0vPncNdwxxfeNr2lfIlzy5wElPQXyh3JctFuHsmzu38DG8nv6kog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tIjwYCXZ4UFoqsV7uoHGQVDpmdVev+cycLASA/e/o7g=;
 b=JgxKDgNLznlb3b3BajaGhwvJsS6ttmw63OgDFKd1BugQGO6zMYIbNdqe0AcOWpcV81zGV0ZPpcPSHhUYVxhrdmoRO6/RTONXu949FBKHMn6OR9mGan3YFYyrZ63cHKIA8XrPoXOg1roNJYX/1hMK94mnfTxk11zVDKekBX8If510Gbb4mCbiT0uIKxOwRjJPOZqEBKs5+rm0C4WkvCqVfdoOARntovknqj/Gng2fahGz6vbkXU2R27OUvMuwMAVH7ZGlV7dwbiFThs+jXSSU1/bfREXdDXyZuW9f1CZD/ZTsD21+fl5PUT7JFyrW9fwCTe69uzfy+rLiGntnadmGBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIjwYCXZ4UFoqsV7uoHGQVDpmdVev+cycLASA/e/o7g=;
 b=siQbMdflSfsKhK+WisOac4e/4R4xpPnN/EFCHYeDZ5QGK4vEnQImVfw2OzOrKJgRXgExUxrEEfs2WyyfCGaPqDxe260mWy06vuQ3V1QbfWxwE6tltQ4resalZO9V5o/aVPB5VoKjNjJsvyr6lbLL8+P31YGYz+N8MKo1//wex0A/KSbvg8AQ0XE2XNK/2an61SZW2LdnLpm2zabjIrRv5+HFGlFmdn5zVZDutjdRIpvRPO1N5imY2WoBkVu/9RzgnQWRzF3ks5ohTKg4GlLexR0bXuke6oxqSViylVoIiqMG0ZZmmM9YfUrIQH0CWOHch+HcJjwp/lfjZAFLDPE+/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DM6PR12MB4332.namprd12.prod.outlook.com (2603:10b6:5:21e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 13:26:43 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 13:26:43 +0000
Date: Fri, 5 Sep 2025 10:26:41 -0300
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
Subject: Re: [RFC 05/14] vfio/nvgrace-egm: Introduce module to manage EGM
Message-ID: <20250905132641.GC616306@nvidia.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
 <20250904040828.319452-6-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904040828.319452-6-ankita@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0419.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::6) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DM6PR12MB4332:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b760642-82c1-491b-481c-08ddec7fda7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2nSYlX6FumzGMYHahUrgTjvq134OO26XQZ3+K1/SUAC+YqtkSggXvjxQye6j?=
 =?us-ascii?Q?XYHexK53SaD3YEwDDeWaxgaS8u3F0eRhPWRFC2vhct6Jxr+DNdhjhULoCAyW?=
 =?us-ascii?Q?2T9jIXsenhfCzhjpQVPAWC3Spflo8sdWraEQcRsmOFgD1bmq9Zx1WEAFtZv/?=
 =?us-ascii?Q?xFEDZpNnUBCtvg/b9auhDPd9s1Sr9e6ZwGdQhY29bTfPszNFvPK+tuE2FClB?=
 =?us-ascii?Q?QG/TCvry67eJtY3MsQW5z+YD3lWWxwd59DdIoz/0NbXuu1gWCzeD+Dld4OcX?=
 =?us-ascii?Q?yWBtY5TAxX1lJRHW7HB6/AVcbbsjm/YH+lGlRGx95l+LdI0UZXn1MR/ZvZ8K?=
 =?us-ascii?Q?jdVnTlHYkYFk2KzZDLPYBbczJksSZNHv9T4TdNcnj4T5Q2poLJuE1k6rC4eW?=
 =?us-ascii?Q?zrJ+TWZKYvSc4T7Msd8GY3ORcsZStNsNH00lUrr0kLCeCiG4poxNPIjKU/xz?=
 =?us-ascii?Q?cBsC0MkxYMmyHjaLF6EqE+JQd7GAC7USwMecWT+IV8+k7sAsWPulgRCYEphD?=
 =?us-ascii?Q?8hKDQGqby39djjtwBycIBnbVS5HXF3wf680yW/itPhP0ws2/M36Ir/jvR1LP?=
 =?us-ascii?Q?ft1mZeiFHfd/FNz1//tNB5GWmwmvYC4+KW5ETPsq8HAfqfLsP6yZ6wttIx0j?=
 =?us-ascii?Q?HlBN7iCXOsIibwtJTTyF5PziEIA5ML2GT6WNdG0YUKF/K+Vg6Gi6ZsMPX72t?=
 =?us-ascii?Q?+5C6dbVyLjmoVyz32dLYSny8qgyG/KOI0P8qncL7EE+JOdVmCUlaVo8MsmQe?=
 =?us-ascii?Q?uN2bJCygVHL3AE0PlkEHYP2CyCH0mMNxfpGKvy0syzhfEC5FFR/WvqAPbAuQ?=
 =?us-ascii?Q?jpYKVMiH+mNahxGpSu5rF5vMrmgL+fSsJjKeaJl+x8x3q4fOectb+YHQo43A?=
 =?us-ascii?Q?o/L4P52IwVsahq7hupn377+MuY9GS7z0dmt17fuOdtBh6+xb0BapFvER9Bsj?=
 =?us-ascii?Q?klFC4DuARlwrODAn7hWFIZELiD2f4XKmdjeCT/ydSU5/EByHAiZwuSKcmblZ?=
 =?us-ascii?Q?9sxJElZPPp4pVeV7ZWWHPgYV/T93AeD8JpFzStrWOfh2jbxPceDJGmtJOraO?=
 =?us-ascii?Q?FO/BjI5yNHYwJJOUuT2KWS5h6H7YkLiaeKUxHDLxP+NkSpgUOrIbjajQI0Tm?=
 =?us-ascii?Q?MQA/EGNHpB+OKSF67R9M4oNFpAojTtiSyvKve7AEc92+6WY9+zGMVHK0vyh8?=
 =?us-ascii?Q?buzGggPmdHikqJR2UU7k0yg4bJP977Zz1qNnNqg93EwtStHIhw+UYEJdwnui?=
 =?us-ascii?Q?tzvSQEXjgK4luE+XI4X21ZwgD0mPPmtDK1hGuN4vHnMKdwdmEKn1ZHiPuaVf?=
 =?us-ascii?Q?H6A0jVXPuG6NzXQDvlVknvVGDEaAOQc7rwMUs4IK1tHbD98eOWEBNM2YD/FJ?=
 =?us-ascii?Q?qV4wlYLfNKbKwMLTKCPYka7OLf+k+eZX+0J6l2ssuMwFOY2Tbg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nU5dnndZUYanmB4wsEialLcEBqzISkg12HCoLK2/+lB8zTdVfgE0/Kzdi8BI?=
 =?us-ascii?Q?suZgHnc2mwYtjjZ24fB/CA+xv6Yeh+vfWzdoFpq1e6l7G+HkmAqsoAVP7oF+?=
 =?us-ascii?Q?WOwXJJHcbXKh5A3mCwP9BQ5N/iepeDRIoNrJHrDNhoB2i3RoHjjs6TObQsd6?=
 =?us-ascii?Q?4ZqdEfObZ9Bp0QzAHHJSoTP8FcCudW2S3PDZ+ru0yfIGsxDzbNb4JTPWljX9?=
 =?us-ascii?Q?8hDXsHM4MYzf6OzLVhX3TG+vmMqomCcsLroJk56vkjP7UnwK4lUC0JTrD1E4?=
 =?us-ascii?Q?HwBIrMpe+BKanDt1AwLn4GWO9LFtu8Xk6U95Ae1CvI8Plxa2/A8sPA/0ZpXd?=
 =?us-ascii?Q?YV4sIFFszjHekGpXmopG7FGXGWEKyMYRrxvHV6YRgxFJxQbcxuAHbL0T2+BG?=
 =?us-ascii?Q?Hf0SUSPydY+uJYE5YpDVHhMxEnUFFO6UaXrEl39jBw7yvYiZBLZt6f3SKuay?=
 =?us-ascii?Q?qNQSGL9D5x51jmy3wI6+MYli6FFG2bMqKHzA9C9sEeq9XEea9bEmW2RgVHQ+?=
 =?us-ascii?Q?ikFPqpRL/rJ42ruckEQzN61DS7GPaq8Bh2NR6qrwKEe1sMT4wUJyELokdUez?=
 =?us-ascii?Q?bNjjNnz/78X0G2mB9N8DKMINerGSA5Lq64QLddddSG3h+BuvYajwsgF9eq4i?=
 =?us-ascii?Q?RC5O6nsKQXFL3U51lToKm8YEW8KKtSQfeA56mh5Mc3/OrbWjeqkgYq3DjXhs?=
 =?us-ascii?Q?OuWhf112D0PQDYz93heUdeesTBSun5m3/aHCscxF0oi3XDQrOT5+/UVkh1ov?=
 =?us-ascii?Q?9H8uKsZznrJWV/F8BgdRN8YAPAg5tEo00oOBCMESusIiKbPLkzNRba0P01L1?=
 =?us-ascii?Q?l0ycSUUt7fsdGZa30pOugBatKfV/rM1OvN2kdQ1pd+EvBYAAreuNK9XvByFY?=
 =?us-ascii?Q?li5Ckj4vDlihrdlpxM4sNhfuk7FKgPpFsXc6hYE17lk3+tFFJqLH6v9u67fn?=
 =?us-ascii?Q?Glxlx/5TUddk8ZJHxxlhUuRSWjuZQVAR6rkD9AMiAjhhal2jdxzq1+qO2wQu?=
 =?us-ascii?Q?O35qlj4F1pzUB36FjgEgKEGzC8k8KWABRRoo0bs6F3Z289Wg0da+lEDljm5U?=
 =?us-ascii?Q?3WnsOTxVAL/uNBcv4oo61Xk/dJsTIYU5nOkpAKnVGFwvc+WWmq+AUBzQYtCj?=
 =?us-ascii?Q?6zfn0Nr+2dxyNZCRVYMIZyDTJzihzy735sd8GVJ6ZV+2SX4+6XrRxO94/fIV?=
 =?us-ascii?Q?rjowiaC8adubDTszBf4UCj9qE7VCQ4vIjhVjgxMN4Woch+sCYURGle2kyE7y?=
 =?us-ascii?Q?zapWnBOBjhe1rivRncRDRKeK4OAhivZSQMSI/tLG/IvNDbJIE3MGkDy8XNpS?=
 =?us-ascii?Q?2XWyY7Owutfj7sCn/KXOawOYcA7dX/2dl04QCcFC7yh/UcqlOQWaUYHW0tRA?=
 =?us-ascii?Q?RUgaWUEnIVlaVgNE7fV6f4mW44Bx+KGcWxWfXydzK8RIaE4XEEdRTBTYbA00?=
 =?us-ascii?Q?vJ4Pnw9N9Ud/MynvHDcH4uKF75a8C0Qc6FHxW4w2AFMgrBTdhRwM+GRVNb3p?=
 =?us-ascii?Q?GDlxM8q9lk1dcHklJIEz/8ariBiR+5cwlWFDVRl0k8LToL9fC8jD2gLjF9OD?=
 =?us-ascii?Q?Sm8npZVeGHgvxPfsW6E=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b760642-82c1-491b-481c-08ddec7fda7b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 13:26:42.9130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nUKJL4FOWZIU/Dn58RsKFVmgQDR5ZqvR6X2MTMfhqApAtZWurFCdx8dRI02dXeVW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4332

On Thu, Sep 04, 2025 at 04:08:19AM +0000, ankita@nvidia.com wrote:
> @@ -1125,3 +1125,4 @@ MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
>  MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
>  MODULE_DESCRIPTION("VFIO NVGRACE GPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");
> +MODULE_SOFTDEP("pre: nvgrace-egm");

There sholdn't be softdeps, automatic struct device based probing
should be sufficient.

Jason

