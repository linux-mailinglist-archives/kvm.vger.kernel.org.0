Return-Path: <kvm+bounces-8098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3265D84B5A6
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 13:55:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC6242893A9
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 12:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C76130E37;
	Tue,  6 Feb 2024 12:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WcsFywPt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4647F12FF7B;
	Tue,  6 Feb 2024 12:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707224107; cv=fail; b=G7hbwLlSpBKTaJ448pN+Ab8XpbRf4ITyxwWx0OTDpSu4E1UyNyJ2xF0+FHiOoaNWY4iAtdSlw78Cu/c62/9wCVwzFmp/McTEP9HJQnJyBrtrskUqj7Z6rqV6HNMhHQXUmwZ4FaSJPwYIDtyxdM60GC5lm8RhGU0zixd+QWmj0J0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707224107; c=relaxed/simple;
	bh=DZbpghp2Ny1uL3gbO1DmBRpP9CHPa0WV3beZEnOPdqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QBys2qLzxahzefRbv1x5RI7BwdVnx5lnjZ3bX+p4/JsWqbozoT+lBTft+T+FjarSomZ2J+V5WFgWdfYY0Anni9WxPYl/32XDcfkmXGsnGlhU80eRAG/AACSvqPtK1SJ6lvOSQCrMkuFn24OMA8PsXdVMJWQB9mOeR69NzgHGNSE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WcsFywPt; arc=fail smtp.client-ip=40.107.223.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8b5qCkaZW4Iu4KHGV5k8VZKMZHBslcfHwxhuk1/WtWccVq5HXT9Wdu8JoUesmooEyNfORyKZRwqzp8metsEgrBOM1de9KGgE7ZzSKR1iqN9wWfrN8T1Pj/NEpZhjPnJiXdU8AjedwB5uLejhdMEPHk/tMkubxQEnVl2RKtQHS/3sRNHyEmXSzZKoMiqMf4aWRGhCuPBRM0tRMOu6FMrh7RfrueG4ncXzqnKjwh4YoTzW4sGbrEnSZRms+RV3Nk5DvyxU1fLt/UXxODOB5FGxyPo+ufM54w3IuFzuJWo6N1w1gSzYkbZVYolb9az3N4NVhgQlgjxypfOYBrOCl6hhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQrGLGx3xAYBTJL4W91ebpwrlK8LrFCQLy0frg7OmLY=;
 b=ELYgEisKUkduhgzrjNztBLNCpmqnlK0GSdLgDC7Kg1rtnZX5vyQpi3t/ZohouCcQ62B/eXlf+ecWVz9AzrBaX31jc37rVA2rZHSG5TGBbCB5ztnEDKx3vyENm8YCX1SjkcL8eD8VAgaD1rH4w6bBfSF4eayP3L7st7slietOzfaiAGxfL2HrhUUgbP67TbR3xcWyOtscpqVRICjcYJGYSVx0Vj8TyK5VkmS8TagcKFwTAqc32eimfHVSJ1Jk+Cj42ftDX5+4hPO6gRlrp7d2AOfnebBjx028W+IUk7XDdKlSSfKqdFmEvHe4CPwH8p8K+itwlvXkoCndp4+VVNep8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQrGLGx3xAYBTJL4W91ebpwrlK8LrFCQLy0frg7OmLY=;
 b=WcsFywPtIH3Wwxyc2stNaWDopR3Ls5my7iNUShsVSECp2t8w+Zoa+UhLZTtfIH6dgy5NiDoEDk2re5gUaQkDKwNWIWo2Vi3PAx5rZg5/7IcdanauqIlRLlbAT8nkPbfHTyqpZzscn5qODWYYocvO5+GiJGOlta4teYRsN81sdCXaGi2CunScdS+wxt8t3xM+TxZXQGXZGRJx6fkZZlbuX9kQ8D4yxZLBamiZl24pa3AYWRH4Msrge29LZ0/uI0NiQnQcFicgX7aWfmRR3YsFT+GkeN1EmCD0sw8v9LmvzSzaUgwo0Tz+y1ZSVpcBSNfjiFKr6DiDCE6kBOOs7Lvxew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4539.namprd12.prod.outlook.com (2603:10b6:303:59::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.17; Tue, 6 Feb
 2024 12:55:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 12:55:01 +0000
Date: Tue, 6 Feb 2024 08:55:00 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Xin Zeng <xin.zeng@intel.com>
Cc: herbert@gondor.apana.org.au, alex.williamson@redhat.com,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, qat-linux@intel.com,
	Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240206125500.GC10476@nvidia.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
 <20240201153337.4033490-11-xin.zeng@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240201153337.4033490-11-xin.zeng@intel.com>
X-ClientProxiedBy: MN2PR22CA0019.namprd22.prod.outlook.com
 (2603:10b6:208:238::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4539:EE_
X-MS-Office365-Filtering-Correlation-Id: bfea4604-692c-4ed8-ff9e-08dc2712d502
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LGs0szeBLMC0z/vP6gtHWFzavfmHgJaYFss6NyRAyKxzdAHpVjrNkVFYra+ewNpAk/+gjJ/Sj/rVC2oyQwvao6M6SC4pt6/khk/2SaboMqnCI7RApAYOB3zYplk5WjEY1GdrvRmhrtfyu5aJnqoBj8+tDFAXW3ZWIK/G7Uq8Jl/1Po956T7XC4H7DaVJtmbuLg40ggbt+UqXM7GubfLnEp7agx3FitUmY3xquQWUfD1jEMVeiwjES6OlK07nLT+JfGB3iSYK53dFWc4YzTqCKpq0ai8rqfbgOW1tw2Ef6oVrEDrnpbQJ8rJ2dKKJWaqaot+RVZVdoezp3P6a4uc4fMc+s0z1wgSKMzK5K7pFfXQ8Rj1Hnt7RYAEHJIZNqhuFBY4YpdjtE993G+hbAbWZFZRj3aVerfzjt5Sv8DLYgoanTTwxEpOpS1wP43q897DiNFjWGwC5TCiNQvwGa8x1SlWEyo8rrCZDh37ApJFOGMZvRkFSrLOvylavf4TqIhSH7ahV3foNqSoGVsjpDU2HZRIfijN9xzjL03wVD8FtzaBbfCtd7VkT8MEPzbsuOPvw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(136003)(376002)(39860400002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(41300700001)(8676002)(4326008)(66946007)(36756003)(8936002)(6486002)(66556008)(66476007)(6916009)(316002)(5660300002)(86362001)(2906002)(478600001)(38100700002)(2616005)(6512007)(6506007)(26005)(33656002)(1076003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bFvk1PsV/WOLVWQupHAVnjZcJlXDpHz3XNu3uf5COgc/CT15EmI/dvnzu56s?=
 =?us-ascii?Q?MlVwcDrBGbac64WLSiJlruWhivlxSy9Xnufu3H0xDOAqwTp7k7G2pG3iu401?=
 =?us-ascii?Q?IJokpV5dEPBx3vwL0AHqNTA083Muqbb2lfy/HAOSgst57CesNCdD7UIGGnzM?=
 =?us-ascii?Q?D+g72eHqrnnltCby21rjRzh38ibJj4RHX0+kwvgQJ3JYmcjV7TX9Mfs9MiFt?=
 =?us-ascii?Q?3aja8BwByc8pOblWJ9IDloxDeWDctReSWN5/lI4KDRFORECHIKGBQsq63cdg?=
 =?us-ascii?Q?d0Fj8mGRhIjbZ8MX6exFUh2ihVTyAKLnJ/6mfqCKwZCMonBIlyAACbdZjXCZ?=
 =?us-ascii?Q?9gIeGdj8KWcLx3jdNoMv/2TlAoISQvTsSGKqdUZ6Yxk6kVEmlpmFkkGZLOJu?=
 =?us-ascii?Q?FQe3TNW0qXTKO62vUyHvnRu2LtEKCIuRqbewFzSTYo72HIPXZQXazXR1PeHL?=
 =?us-ascii?Q?Nm5eB2sqBi4W0rA4ClyYtBcNaJifCOmrq3Skg1BmMMEiSysqgFEpQMZ++1eG?=
 =?us-ascii?Q?vfGhLWLp5t6m7I7C3qO/qOHvsAduIchz3ERvVNYi6EhwTKAx32ax3GNvp+J2?=
 =?us-ascii?Q?y8TK7uaJypFSq/1htVHJGdPvWdq8Ni6AfmdW1k8BoRzBUVoFTpatYkAFi8W4?=
 =?us-ascii?Q?/shiHCS9Gdcc9lGn7t0Z8xcGVZWdW6UA6pPV1Ufj0wJ6yIzRkB2L8YKO5zKI?=
 =?us-ascii?Q?j8VK3vtZtOk9K0T194oW/weQ8CTBvzZY6dqZFRoZkRcS8RgzUacQB8aBYoKr?=
 =?us-ascii?Q?+tHg2t+aVTlUENYon8d6oezl6+2KyvUrDXsVL05zMmlWJ85l8Yolz+pOZFcB?=
 =?us-ascii?Q?T6Cz+IuZfydtuNMZ01Fezk8Xe2QLzPfqOBejnm623p69YlANDpijVJVwD3Xl?=
 =?us-ascii?Q?kIM9HzxB+pmVju6QcWpMy66n184OBg/AFlcEVEkXFO/WLAbuLpsIhvGZ45Y5?=
 =?us-ascii?Q?sjISv3tbm2exLWIu/ECyoy87oK3GgfXX84C+8ilR5HLRwZ2U4pNZ9EVRTqcN?=
 =?us-ascii?Q?73X05f0X0psGagV3MKwh7t+QRhCRPAN8r6W+tXTcRuVVwdpMxfsmxqfOvn6F?=
 =?us-ascii?Q?G2dEGBGZejLHm5zGPTlrnZaUnwjZalwtpZ5pd22PAToIgijUF+mUAeCQRTLb?=
 =?us-ascii?Q?WELzbfA5LUdLG/IlcF/SsOin3hgv1tbDwQqhlczZlt8mn0m3QetM2Tn7l/ur?=
 =?us-ascii?Q?JUgXYRx51HKb+nuEJ1xy6v+Ltwts4lvgI6rguQbfQeqY7dxf8/QhE8m7fpUy?=
 =?us-ascii?Q?OhLNGtFzv7vBpjGuwZ9IpVY3QXQ9//GxOQYCOpHmG98pkUENVLi5istLAdCB?=
 =?us-ascii?Q?1xHgsCJKyxwGScwjotvYBIwUGlUL6gmgRKi0/BcfpU15rFhjMZy80bYDxIQ3?=
 =?us-ascii?Q?AOWJCl9UMw80edGAcoq23O1UBoJc1qz3V4qZJOfZk7bqQ0IWguTFVPD8AlZf?=
 =?us-ascii?Q?mHI8q9hnbvd+K8ogIaaiQtLV6gAekwNkHL08HRXr7EMG60gVUS8nHoZmACmH?=
 =?us-ascii?Q?IESj5nr/l97/uAQy/sZBDAskyvjNituSC48rtq3pHI4xstqipgPci4cvogNE?=
 =?us-ascii?Q?E1EepfbMlAefhUoKv/U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfea4604-692c-4ed8-ff9e-08dc2712d502
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 12:55:01.7496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/+iUhTMSBsfLazB9e7V/9T3t3Le/kfkWKMi32CBzRxSluIAsx3vMe48vpZSpAjp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4539

On Thu, Feb 01, 2024 at 11:33:37PM +0800, Xin Zeng wrote:

> +static int qat_vf_pci_init_dev(struct vfio_device *core_vdev)
> +{
> +	struct qat_vf_core_device *qat_vdev = container_of(core_vdev,
> +			struct qat_vf_core_device, core_device.vdev);
> +	struct qat_migdev_ops *ops;
> +	struct qat_mig_dev *mdev;
> +	struct pci_dev *parent;
> +	int ret, vf_id;
> +
> +	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
> +	core_vdev->mig_ops = &qat_vf_pci_mig_ops;
> +
> +	ret = vfio_pci_core_init_dev(core_vdev);
> +	if (ret)
> +		return ret;
> +
> +	mutex_init(&qat_vdev->state_mutex);
> +	spin_lock_init(&qat_vdev->reset_lock);
> +
> +	parent = qat_vdev->core_device.pdev->physfn;
> +	vf_id = pci_iov_vf_id(qat_vdev->core_device.pdev);
> +	if (!parent || vf_id < 0) {
> +		ret = -ENODEV;
> +		goto err_rel;
> +	}
> +
> +	mdev = qat_vfmig_create(parent, vf_id);
> +	if (IS_ERR(mdev)) {
> +		ret = PTR_ERR(mdev);
> +		goto err_rel;
> +	}
> +
> +	ops = mdev->ops;
> +	if (!ops || !ops->init || !ops->cleanup ||
> +	    !ops->open || !ops->close ||
> +	    !ops->save_state || !ops->load_state ||
> +	    !ops->suspend || !ops->resume) {
> +		ret = -EIO;
> +		dev_err(&parent->dev, "Incomplete device migration ops structure!");
> +		goto err_destroy;
> +	}

Why are there ops pointers here? I would expect this should just be
direct function calls to the PF QAT driver.

> +static void qat_vf_pci_aer_reset_done(struct pci_dev *pdev)
> +{
> +	struct qat_vf_core_device *qat_vdev = qat_vf_drvdata(pdev);
> +
> +	if (!qat_vdev->core_device.vdev.mig_ops)
> +		return;
> +
> +	/*
> +	 * As the higher VFIO layers are holding locks across reset and using
> +	 * those same locks with the mm_lock we need to prevent ABBA deadlock
> +	 * with the state_mutex and mm_lock.
> +	 * In case the state_mutex was taken already we defer the cleanup work
> +	 * to the unlock flow of the other running context.
> +	 */
> +	spin_lock(&qat_vdev->reset_lock);
> +	qat_vdev->deferred_reset = true;
> +	if (!mutex_trylock(&qat_vdev->state_mutex)) {
> +		spin_unlock(&qat_vdev->reset_lock);
> +		return;
> +	}
> +	spin_unlock(&qat_vdev->reset_lock);
> +	qat_vf_state_mutex_unlock(qat_vdev);
> +}

Do you really need this? I thought this ugly thing was going to be a
uniquely mlx5 thing..

Jason

