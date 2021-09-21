Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B083841382A
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhIURQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 13:16:04 -0400
Received: from mail-dm3nam07on2061.outbound.protection.outlook.com ([40.107.95.61]:29515
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229622AbhIURQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 13:16:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGAgXfeBYEjEq/+S1rN/5gAMD67Ld7gOBfxKCVVbIHBATtRmy0PwinZEBZCIObjzk8JFRXwEygpUCTBBrFKM1iszSAv0sslouqPBlHhIT6DmRlCXwQ6JsOr49kvvcPRhUdukFLoJSl9CP8/G76StPEvaP3bt02bjUxjA8eIHKVSUgXpD2MVxpAsk7OpxC2gW6pv3nmhOSUKmRSmGfOgw2KnRegC8+NYLvUg0SSmqIx4Ig8jAYpPSyvQFtI4MY4p2tEvpxZNKsBTn8Z2iTs75xlMMaGI+FRW8pQtquWk8Xd95hzu5TJ3l5X+I/lgY7c0t035az4JvsfGCgoIzV2eZ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=msDcqT0j10uFAf99Oa55ggPgGB9M6SlA26iRFoOPWwc=;
 b=hpEzIv5TYVCS6DxPOFtAYWXc8grsshGk3c/b6os7b3WR0r72O0yKQdzziydDMkomCD02VXn5rk2LsG4RWCBiDrPoLsEQy4/5NNRhHaqGgvgh35fWMTR3QAINqX6cz3aMv/1ucT9he7/2bFbJjWVI3cqHbnhDMTR2AjEMCmHFuqJIGf/SYcAm5w0dSbDrbx6g8t5M2I6hpLzWvS+L91emvs1JhodE54lWsM/c2HIxQKuX/06ekYBjGIaPNfdQAKvHfTRrv3qZctHhhyOPSYjW1laqHm++Ob3zLe2Lc3jR3++PnAL1tnovPEceP7hDjXrG/JcW9Byq2fBDvbxagu+D+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msDcqT0j10uFAf99Oa55ggPgGB9M6SlA26iRFoOPWwc=;
 b=PI7xyCNcUQi05CJHvt1xThHTrO8cK37vU79RVzWylas9FyJSG7nw+zl19DTkM2WnIyE0FYqtz85jBotmWpy1wNQl45Gmf0o3xyN32dF06iOgn0d0WbOuDAJlNukLl/zUIFmi38k5OlWsKPxnhChS0i9y84CI/Yv0eCTLIPweNBT+hfUMcD/T5eKhSDi0drY3UL0xErtjja6oeV7FXhUB0Kd7PW4Q9aEvrasb/eU0uf0iGT0TrmkZxvQtPbOMb8GTys0l5wzA2UTH91X/uYkLtA6ukA9TdEav5L4P1eEFUWslIRshu8Djcc2zqAAxwccAQX85pVHuHl/P8iEIv5CpRg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5045.namprd12.prod.outlook.com (2603:10b6:208:310::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 17:14:33 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Tue, 21 Sep 2021
 17:14:33 +0000
Date:   Tue, 21 Sep 2021 14:14:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, jean-philippe@linaro.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 07/20] iommu/iommufd: Add iommufd_[un]bind_device()
Message-ID: <20210921171431.GT327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-8-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-8-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR01CA0014.prod.exchangelabs.com (2603:10b6:208:10c::27)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR01CA0014.prod.exchangelabs.com (2603:10b6:208:10c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 17:14:32 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mSjLj-003Wai-JK; Tue, 21 Sep 2021 14:14:31 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d595ca19-219e-473f-b067-08d97d234783
X-MS-TrafficTypeDiagnostic: BL1PR12MB5045:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5045CB9AEA572413192DE4E4C2A19@BL1PR12MB5045.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yPSujwx6ksYtJgVgTYapM5WwwsgkP7NECci850tn6PNi5OOlbs94rvyozc0CKUnEvVBhEOE/fyVcR3zmxINn3MsTLj4JPC8e1nnJ/DXK49biWSPTUDBtfL34O4wav3r9QC1UBCpj3juxdOmrC/MTO2gglAgzBrqTyDwTQA1VRVa+ge3lUC8y6RvZihV+yRMHFkGvw1VGOAMUMzYGp92Q9EWnoSNv47ny1ghs34O30vtDD0FBcFJ1akHFJ4JWByxU9aUrEeYBbKrEXEijCRwQvKS5SFamRDjCSzIqEDI+hl0utNS8+/cVQFWCttghOeSKa8y6T7Jns6I4+CjPvIiLkHeb8N10gC6EQBlu8NXPj1j92ZTbv15slmA6NFd9W+2E3VN+EJgRbETegZ1KpkHpVJgvLgxrxQlascSTgQ6+v9MBH4XjcNplS9OSv7KD6hW967laJ6mWtFWKD54MSlERLVbXUkP5hn6MSHbX3SzHQ4q36rHGePstgAsPB2/iSi3CQlEOZiVLTP1e8vNBQU1EBobOOR2Op1nGkX4sarhVZRhsLN+4aOABrJaVkSpuyBvVq/QmtUVKYoaLLn/myeHZ02BhM6SXk201Fwf10ZERDlPqMruPS1T9EPMgcejCRGr3592LJcIw7NJIxayt+7EKxdOgyMYBjuS37OuU0HihxkJw1ABgrL2CE4wDxbA24cHO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(36756003)(5660300002)(6916009)(508600001)(1076003)(426003)(4326008)(86362001)(83380400001)(2616005)(107886003)(66556008)(26005)(38100700002)(316002)(66946007)(2906002)(9786002)(7416002)(9746002)(33656002)(8676002)(186003)(66476007)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C9AnAIMQ9aywsrfOaMUI56ndZTVXRFoQcz6dVAaSzfXvqeSFjt1qVESrid6l?=
 =?us-ascii?Q?02XwPV6GCF6Pk/02pnMI9aTAFW/eamLiUc2aqtc/J05jlGIGaacwLlbsbc4k?=
 =?us-ascii?Q?csAEOP2df/pjfQ2JUeYs4DUA8RkzfhZYn2113xU9E3ppI2vMxMZ1C76rnp2U?=
 =?us-ascii?Q?avDo43Z19wl8b++BLlfz/ttFWSmhm5vXmDaEoy5YcEWXxkOBaLcg7yMkI/Ic?=
 =?us-ascii?Q?20hODDMgU9tUJbXIyfjB++yl4PxyoXCAWlhvxHtCy/buPAlt4k1JjJjjq1h5?=
 =?us-ascii?Q?90Bkc6ZimknQFHGbrd4b21gFcThzvNIMkuwvlk8hBVcTZagUoDYsH/TcV6JA?=
 =?us-ascii?Q?OOtEGS4CyG4p4NWyN1V97YODHUo/dBzwNEUYnddm4u5CTYU2LcZfMB+B06wA?=
 =?us-ascii?Q?EFSfjdjao0oMCUWAW0zKuM44Y3LHtEINn+JzWS5OoBw1+qlBnctZvfjjTm1k?=
 =?us-ascii?Q?/EaLeCJ3sDqzOf7xiIz/0UTYLnBmkM1BsZBUb99JXIatPBQAuoFGSqbmo+ou?=
 =?us-ascii?Q?WwY1vMTMdr+xQ8pz9iXm7hyY0fWbxtV1P2F2RmILRPDVZSiBO68AvF+Ofq9C?=
 =?us-ascii?Q?x1NPJ84n5AIvelduMqnekPZHxMuD/1uvYCMDqzRxvUOGqcKogsaQoxAVBFDF?=
 =?us-ascii?Q?2TsVUi40O72bbsV3yboubOSLi+9xMIeNOHqs/fi+xHpVtddyETIDzjMS0rnB?=
 =?us-ascii?Q?sOBs7XSrNNx7x8q9rlerURgtxppxxIMy9SjNcsM5659OkyMkl5xCUySqQ+m4?=
 =?us-ascii?Q?Vh8IxzEI++6doo6iz+P8PDo83xbhVwlhpC6En5qLFQePOpAKjKpwGxJy7Qp5?=
 =?us-ascii?Q?tzXpszC+rSut5S5q82aOf0zeWSn1P/bJP2pefoZhkReW6w1v/l8EnSRrBA6s?=
 =?us-ascii?Q?5X1XrY1eMluQOc4fOjZ/S2cZJlGTIFhkeQ+s8XlVaqPD9NoFkWfzAzB6jwv6?=
 =?us-ascii?Q?Bn6HoCyHax4nX+XpSI+r3AtPdx0pg5XW7HjrhowrHxQ22GK3B2uN4tylcNil?=
 =?us-ascii?Q?ZJ16v6hgUD8qUot/H3WD1BxBR4OFUo416kRNEXFhA9dNpW8MgDqH5cg/4ytL?=
 =?us-ascii?Q?+ZD/3IJzZOV9zRN27qw1A0X6nwq+w3GV17vNkLf3yjwksKw7AAp6oLKs6DpW?=
 =?us-ascii?Q?C4sTyU0NvIvWtwNikZJy9GqUcdO54UFkEmcP06WoGaIrM3USLBACl0mlbIT0?=
 =?us-ascii?Q?GjM5MDIRHxAfO/CPTY8pXUeR1khYstJsZ8/O7rmZSPQZdU8f1AaB7fhJsZT8?=
 =?us-ascii?Q?72qf0ZwhESZmy8HBWiPKqyujn0cTu+AJXrsBH46H6VUHbJvks+oA75sXqXdS?=
 =?us-ascii?Q?vOfYvd8WuOeWD7mtLulXFprM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d595ca19-219e-473f-b067-08d97d234783
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 17:14:33.0977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zAmwuesY6zMukI+6bLI+DUAMzwaVTbKc/1jAdgaK6wRKkZkUyhL7nhrct+jQgPuo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021 at 02:38:35PM +0800, Liu Yi L wrote:

> +/*
> + * A iommufd_device object represents the binding relationship
> + * between iommufd and device. It is created per a successful
> + * binding request from device driver. The bound device must be
> + * a physical device so far. Subdevice will be supported later
> + * (with additional PASID information). An user-assigned cookie
> + * is also recorded to mark the device in the /dev/iommu uAPI.
> + */
> +struct iommufd_device {
> +	unsigned int id;
> +	struct iommufd_ctx *ictx;
> +	struct device *dev; /* always be the physical device */
> +	u64 dev_cookie;
>  };
>  
>  static int iommufd_fops_open(struct inode *inode, struct file *filep)
> @@ -32,15 +52,58 @@ static int iommufd_fops_open(struct inode *inode, struct file *filep)
>  		return -ENOMEM;
>  
>  	refcount_set(&ictx->refs, 1);
> +	mutex_init(&ictx->lock);
> +	xa_init_flags(&ictx->device_xa, XA_FLAGS_ALLOC);
>  	filep->private_data = ictx;
>  
>  	return ret;
>  }
>  
> +static void iommufd_ctx_get(struct iommufd_ctx *ictx)
> +{
> +	refcount_inc(&ictx->refs);
> +}

See my earlier remarks about how to structure the lifetime logic, this
ref isn't necessary.

> +static const struct file_operations iommufd_fops;
> +
> +/**
> + * iommufd_ctx_fdget - Acquires a reference to the internal iommufd context.
> + * @fd: [in] iommufd file descriptor.
> + *
> + * Returns a pointer to the iommufd context, otherwise NULL;
> + *
> + */
> +static struct iommufd_ctx *iommufd_ctx_fdget(int fd)
> +{
> +	struct fd f = fdget(fd);
> +	struct file *file = f.file;
> +	struct iommufd_ctx *ictx;
> +
> +	if (!file)
> +		return NULL;
> +
> +	if (file->f_op != &iommufd_fops)
> +		return NULL;

Leaks the fdget

> +
> +	ictx = file->private_data;
> +	if (ictx)
> +		iommufd_ctx_get(ictx);

Use success oriented flow

> +	fdput(f);
> +	return ictx;
> +}

> + */
> +struct iommufd_device *iommufd_bind_device(int fd, struct device *dev,
> +					   u64 dev_cookie)
> +{
> +	struct iommufd_ctx *ictx;
> +	struct iommufd_device *idev;
> +	unsigned long index;
> +	unsigned int id;
> +	int ret;
> +
> +	ictx = iommufd_ctx_fdget(fd);
> +	if (!ictx)
> +		return ERR_PTR(-EINVAL);
> +
> +	mutex_lock(&ictx->lock);
> +
> +	/* check duplicate registration */
> +	xa_for_each(&ictx->device_xa, index, idev) {
> +		if (idev->dev == dev || idev->dev_cookie == dev_cookie) {
> +			idev = ERR_PTR(-EBUSY);
> +			goto out_unlock;
> +		}

I can't think of a reason why this expensive check is needed.

> +	}
> +
> +	idev = kzalloc(sizeof(*idev), GFP_KERNEL);
> +	if (!idev) {
> +		ret = -ENOMEM;
> +		goto out_unlock;
> +	}
> +
> +	/* Establish the security context */
> +	ret = iommu_device_init_user_dma(dev, (unsigned long)ictx);
> +	if (ret)
> +		goto out_free;
> +
> +	ret = xa_alloc(&ictx->device_xa, &id, idev,
> +		       XA_LIMIT(IOMMUFD_DEVID_MIN, IOMMUFD_DEVID_MAX),
> +		       GFP_KERNEL);

idev should be fully initialized before being placed in the xarray, so
this should be the last thing done.

Why not just use the standard xa_limit_32b instead of special single
use constants?

Jason
