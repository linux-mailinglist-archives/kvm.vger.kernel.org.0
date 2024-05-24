Return-Path: <kvm+bounces-18120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B538CE61F
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 15:24:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 791671F212AA
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 13:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C80312BF26;
	Fri, 24 May 2024 13:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NBkxC05s"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2085.outbound.protection.outlook.com [40.107.95.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DD012BE90
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 13:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716557081; cv=fail; b=NC8/BymAUHlCLW5U+3R1ain+pPo3TXyE8BnqI2Za+CC74ukzTbeZ5F7Bpgkg4HYV/MNuGtSr9v8Wh9vOikqZnRuXbeoYktoLGGeoywa1n/cQuOO0EXk2yoom/z9+jU4a1OGA+aGuC5ZIzBx6Jtnoh1u27/ERgJG8TV/BsL/om/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716557081; c=relaxed/simple;
	bh=tPjov48gRSjImA/0NzMdNc/y50E2oiXQyjR7k2/73gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T1ZeO9VJ/Rs9yIXGiAluRcBcWFpVE7HE0g25VUNtLErENW/FPZtS+ZOYSN+4IhBsNlPURK6zEyf9vyUAupMgeOsm/WLr+b6gs/VBWp5o32vz6ehBQs4Mhauhim+T8DZc8YMJORI1bwOTo/WFiOiyoxivBDfe17BtHgOBl4QSwDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NBkxC05s; arc=fail smtp.client-ip=40.107.95.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9V9Xc5AWYPEi7znQIuH665ZZD1eelDAwDfDNeEIw3HgOFwNm1C9JVC2koRmVn498b5LcQVg0V7lJj7DMldg+uHcsrTgqeZXFG7e8xzNhl8BVa9mylOExssUC42LnmIlmbIXLslyxTZiLSlKuUZvmQohsPYK8FOXoVBegioM4uiDXOY3cdhhE8s6qTk5gaRglfgSXO5g7tMDbbsU/snyq+ue8U4HH4yJVIXX5dlW+rVcrfn9rPeGzGDvEpav49m/vb5Zu/cReJi/5bE0Q/6/ADoCyykr36reeVU21AmKUPkQa/Y87Jp+narqMZoFRFE/3UiXydjgsYDJEdhyL0Os1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqbWlRdjYQuHwQgo83QxThHwUEHFPKCQf1Ja6hAyMMA=;
 b=KHs6Dwkbkulxg/FAL+WzNBG9HGOoE1b6fCCWJyppQJlLRj9oTo5NdjQsu8vCT9aM50xHPJRlgdSzKjflpyFAK0FcNelzFXM8/Z5tPE7gZLTw8oQvVvU5hNxGNfGxgQbRrbRBNLzdiOriBcLeFYVbaywDBzU1EhRkggwL31o/7Wxh1rYh3TnPEtevLZCR9MkCrJM/29JoD8YJgqRjetJuozA7PWJ+h58z6gWTrAvzKiw8o7cBi5ztG9hP7Cq0nPyyID0Zpy0ROyEsfvNEg5XG+jNn5o8827OZSjsD+EvBXWUJIIKc20CRi2DLmIU6eCqHPY7bI+5ahLSZ+ubhc1qHBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iqbWlRdjYQuHwQgo83QxThHwUEHFPKCQf1Ja6hAyMMA=;
 b=NBkxC05sOZ/9QLxwfL4UkJsBuWgOikIza0QfUP/ijLE+VTmHGMy95cdhGP2hVxQ+2AB5pA53yIy9S5Q//UapfZURVqHTqxp0HutUl6rzrhLmvaLv9AkP/62ym3IQiiHSIrOPeC+2v6hWRJnYe5ribfLVz8CLRORtZlD90pSTUwrD2eykyXPIveStpvCYbYzYDYhejO1s3+ybwQ/RDC7lb5d7f+gqgGOMsaRT/14xJSS2eslYcau6DV6q8LmzolWoKhKfD66ZobtDkN5co7nsEL8u0q7lZGlHo5QR6EQYnTtq/vN/bk65sLSOWIMnlBhN11Y03C4IXpcYuO8zoenWjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6955.namprd12.prod.outlook.com (2603:10b6:510:1b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Fri, 24 May
 2024 13:24:35 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 13:24:35 +0000
Date: Fri, 24 May 2024 10:24:33 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, ajones@ventanamicro.com, yan.y.zhao@intel.com,
	kevin.tian@intel.com, peterx@redhat.com
Subject: Re: [PATCH 1/2] vfio: Create vfio_fs_type with inode per device
Message-ID: <20240524132433.GW20229@nvidia.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
 <20240523195629.218043-2-alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523195629.218043-2-alex.williamson@redhat.com>
X-ClientProxiedBy: YT4PR01CA0045.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::13) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6955:EE_
X-MS-Office365-Filtering-Correlation-Id: 561a4e98-2de5-42e3-51c0-08dc7bf4db0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rv97oB4Mb8X9i2fE/yRJSjmlfKHUETCN86duoxnEhKChES4W56aq0n+v2A4r?=
 =?us-ascii?Q?Yh8vzf7U3kuv11AuUBZfVqgMQlb/vzq6e4tprTZasg+DRQT2UOrwWsd47RpS?=
 =?us-ascii?Q?DDh0Q9EjhGrwYG2qa4Vmcu5oeOJl/onffgYpAO4dnWchi+1LlSBRJDHOVCB8?=
 =?us-ascii?Q?KOrTG+cgwaUERKP//JWgwwUNrc5BOQN+t+l+Aw4su7p9LOkbVUlRwge8B8Oa?=
 =?us-ascii?Q?IGj+lm0KWfMOmQJyUFjh902r69dZI2vmlhG2+wCcuHQua2L8L/oonsLlCzId?=
 =?us-ascii?Q?Wfx25G9U4URzQ87+2i9o+H2/Ya8BIe3IOaO7c8ApiVKKOnbFj3Fpb9xOaLbI?=
 =?us-ascii?Q?TYDUEqXFIDanhvUBJf14zdFPZ5f7+dgQeclFJ/QBm8l0pdl91JULjJUw8UuL?=
 =?us-ascii?Q?f+CrovaAC+nXiE/Fei4zEYqE5+yaTiSfqjBiKyWeULKRdoLflteJxW6yK4Ia?=
 =?us-ascii?Q?T2rD3jxJqq7fsQtp0CAt0evGtQVsmvwQH/OwjFtkZrW3r2z2ZUVmkkcSGraT?=
 =?us-ascii?Q?tvHAGlO1VCumbci8vJus1MnNLKGDRnnWqpksaFuaP20P9Y9LW7atJUGyFgEj?=
 =?us-ascii?Q?YmKihvYPtdZe+IQD8dnjiN4pifa+yz2+Vh+VIUKyTNBjHxnXRd4UhYTfaZKC?=
 =?us-ascii?Q?aDYEAYQRtLY1OiE8/sH0K5N4XwHsotVpZkbXvZZeriOFI49NahZ98f+dwcan?=
 =?us-ascii?Q?Rk5+o6BsVuZMQiNxrAZc61TQB3cMbMvgbLMb3nK7OCTQycrwVA3Z3UcsNIWz?=
 =?us-ascii?Q?ViZS0OHeuGId3skUr0KpBaGkjrVOvZYMwi1271v3bBE/JYuJs7Yx/QaksB47?=
 =?us-ascii?Q?9OdvOHEYUv9M8/35g/DoHp6gf2a7lfUXxoO8j3vpaap9UZFWfj4l+xzHMd18?=
 =?us-ascii?Q?0IPKRUU+N4NdZAUQl+bXapHAmrQM4sP/Wn7tC6TJwqz+c8B6JOEyjjA9Ot2E?=
 =?us-ascii?Q?rO7GtRSuX9S8r0tXuD2AqvfPAutqTlLkPwmQc92hOmrZ0xWAE1YqW/wj2Wt/?=
 =?us-ascii?Q?DvDRcDtYcN2OtXxX42x6Ipz6/s/JxtIDx7aVSjUzg9ZA2lnLRHLizSOEkAtH?=
 =?us-ascii?Q?53lrIZbjsLZ7tfNHg5ja4amoPnzXbMFjnc4qmhfAN739D+Vzu0aDqGavxxn6?=
 =?us-ascii?Q?iHimrXEnKDWqVoUP8zOgVjAbWO/Emg0N34dxV/pmWuy32cWDVFjbZoCvtCq5?=
 =?us-ascii?Q?l01Hg+NtgxQ/SEQXprJUFZd1dqxop15evivbSBaAG6Z0KqnSKgDHL/5lHaNs?=
 =?us-ascii?Q?6WOtWbaoo2p6QBrMdafAedORYEzF5iaIjuBUwZ2Xtw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?slEj5At75tqRn+ghVZizPN6HNNmsmSsp0/qjogg5N70zCcjP3DPsPeAhCydx?=
 =?us-ascii?Q?XVnG5O4NqeVgJfBfIm6+m1ni+13gXvV/OPOfcsE7Yp/0M22UgLSwRQd5eUUN?=
 =?us-ascii?Q?nxzWHhlD2Gji6ZfvIteedIoFWVvggXeZfjCJ8KBDNfba5fNsbXgsjqNSySqP?=
 =?us-ascii?Q?nzDwUjuYzNkyk0TEau32xW7XbDOWt9rQhkCxmS41aEMLDarZhFnuXR3JOcx5?=
 =?us-ascii?Q?KfI2GDbO1l0sWrdBJ/5aQcU5KX0MQ26bgl18sfUFa9cZnO12CG0UfG6VL6ZV?=
 =?us-ascii?Q?AESxvbkUhJds0ZK+IL8LLApbl9NlIToskZvvclHbkONhQEe3ropCd17g8MVQ?=
 =?us-ascii?Q?x4cbenIKxIX4sNIkpxoO7xdfXw8p0dBBz30KnSU8xcaIW06FUDasnwE5K4fR?=
 =?us-ascii?Q?tl5MZ8qJIdGNjaoM66rp9ELVb9LpsZXD3Gktp/PXGBgzxxQOBSkmvz1znhmv?=
 =?us-ascii?Q?22OkVPvy2cvPoZvWs3KsxBogKeAY+OMskHTXsBa0qjI+LsT5iS7UknO7ZFHP?=
 =?us-ascii?Q?E6E4BcJafQBwPBMbyQpjSCJ4sdwDuxLIK6HFhY01C8xr1AFPuaevHq236bhQ?=
 =?us-ascii?Q?adMGE+OJK8QTQGO64z4pe4pSKqvdDJ5EZCcaTmWKFkB84Snt3l/027ElmwtH?=
 =?us-ascii?Q?289FCB2oMFQFqC+Mzp3rJ9RLmIr73MdodnY8JZH5MHPWob8ZSTKZzUGMZlcX?=
 =?us-ascii?Q?4ngR/NF/zmhVnjlgy66FWOMynrZYqfSrne5LvBuLd9FS65sfpSMnZYD9LoS8?=
 =?us-ascii?Q?PKqowxXVgMnUEJHbNkrfyPX9Ed00RBztV6fRwCFq1RbLUq3duTA0QXDzaZSN?=
 =?us-ascii?Q?C/uVSlkfWFYG8oGjRJmh10gTEMvD6W1BIVmOyWKnDCjPuu04S8khfAUM3jgw?=
 =?us-ascii?Q?Ar7FOEQmwtTk+y2RCQICK823AA+EadatXYJTV1YNoE8qTs8CmrJwIUgPkbSR?=
 =?us-ascii?Q?6OW9yyHAdqOmJxfrLHU59bE+k2cKkwFmvD3HTmHFWwY9hqJHobfLyO5cCG+h?=
 =?us-ascii?Q?GcAgzDNWALgynmxVY2AD5I78/6/jmJ+LD5vhrQiwD+/F7z14mBKpimlJy8zR?=
 =?us-ascii?Q?AnjFXI3KC6MPDYKUabK+EPRLX9wWs8hZRCyuAYtyFRYf3Q2C0Pnz3Qxn2WK3?=
 =?us-ascii?Q?hkTr0fulmuZ3wz+zHbcNA6zbth/hL8yQ6tDRlW+mLVadFKyZfn7i8qA/5jwl?=
 =?us-ascii?Q?Nh+N3LT40SJ6lLfGaQu/XhziMN5Tm6Zj9EKMlcU3Qv46IJdJ4aH/0D5D0PoD?=
 =?us-ascii?Q?t4FAiWPDQ7KcWMXemyrPi08zRzCDiIGz1YIVD45vESLXIiWrBPEiGBBnJ4Mk?=
 =?us-ascii?Q?VKb+YL8kf2S0RGb6N5lOY1rKhpV/itPXa0lyNUFWGoamg2wX8Ca/L3X6xd+i?=
 =?us-ascii?Q?SMo56Om2lKlVmURfhUR9QoPJxy6+vtzJBVTHtqLbkNh0AlYOtwmDVwdWhpBN?=
 =?us-ascii?Q?DYCPi9kmf8kqDmokoa6Pd0hXULRQUKzRH+xICOKxpwRYKX2VjupPQHuIYLOJ?=
 =?us-ascii?Q?4GzP5MDu/cFzXapurjEoAk9zPL8NGp9WFhlmTdP3FVPM19cqeYpBKkrnzVQO?=
 =?us-ascii?Q?qb/UmZSQHErORSCK/uy8s1zEOEWXvlo5hC5H5jY+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 561a4e98-2de5-42e3-51c0-08dc7bf4db0b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 13:24:35.8149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m9NudTzbVbUDJptNlL0t0fL/fxaImsPYUfCYjmQcdMT7kteCBzA9njFijE1LJaUB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6955

On Thu, May 23, 2024 at 01:56:26PM -0600, Alex Williamson wrote:
> By linking all the device fds we provide to userspace to an
> address space through a new pseudo fs, we can use tools like
> unmap_mapping_range() to zap all vmas associated with a device.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/device_cdev.c |  7 ++++++
>  drivers/vfio/group.c       |  7 ++++++
>  drivers/vfio/vfio_main.c   | 44 ++++++++++++++++++++++++++++++++++++++
>  include/linux/vfio.h       |  1 +
>  4 files changed, 59 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

