Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACA7331BB2
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 01:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhCIAeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 19:34:17 -0500
Received: from mail-dm6nam11on2088.outbound.protection.outlook.com ([40.107.223.88]:12800
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230116AbhCIAdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 19:33:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4GYrrvVWnE+k4ffAK72RHWklenMCDC/NpilH2H48AqBAgINqhLzl1DrBYlEPxp0IuryQSpxsXV6qCNu+IYtGVw1qa4vUkB586DB1hGeoEST6R21snrZE8Salboz36oGme5piSmh8+opT4TOMyPlPTvS+LGyM6Tum1wapDee6Ua3RaD3z8FOrao9TTvox5vonNre2dJvWIn/2J8csBIGANN1NMA0TuH4xT07+c3sOpvC23jJXKqAJUZ3jcIHNrL3Zggpj97KS8d0PKjqMxZ0oRPue0EPUokTId3QdTwZpPS2eZP32pOYy0xaU776vVvqrUj8/ID9bwbikW2xsHx4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXiTrBxrgdckf0pEDi0Z3ly2qYbvhUTHRt0sfq0UXSI=;
 b=LW0GRNvPtM6lIu9erO1jjH+uRGp2RrpSsgJX05GMn0tLAxkqiKFh8eb9B8RRdnJUGHqR5g8dYQ7UhtK8S/+KIZm5UTJKAn82PA34NEPZ0XZ87oKZ4NN3OWNrMOVG8agcM6ZVMnR/tjMK0x+Qp8g7mYv+dxHy+FGopWYQ7c/zZE4PsSlaRNlnCg0GTv9XtPViXYsmcwvgvGCXcPo79MqSrZlrzsBO+Cg5Dc+ZBnUjpic5prlKT0DuaRlRMy+UjoVH+YkooULP72f9aVJya+1GtC2teo8S+FP2o+nzBT4p2xSeHRLGbwQMHhIdC3BOfgB5XaK4/s3okH7iqsEdNrtIbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXiTrBxrgdckf0pEDi0Z3ly2qYbvhUTHRt0sfq0UXSI=;
 b=vTNFHJFdYGbOiRXgbKKNr+CJ9cAiT7VSriTruoUvzQLPYfKlEUEDXmFzLAqT6R6Rz5/TYRr8Q5dzivi/dvNueHf7tFBa2QBcXj3cfIc18sFUC7CCjNhDP+S7dtWAukJ7FH48EcBCa80qpEZ7dxMW81asS6SzTGVfrSIcTMSHjrI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1754.namprd12.prod.outlook.com (2603:10b6:3:10f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Tue, 9 Mar
 2021 00:33:46 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 00:33:45 +0000
Date:   Mon, 8 Mar 2021 20:33:44 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH v1 06/14] vfio: Add vma to pfn callback
Message-ID: <20210309003344.GC4247@nvidia.com>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524009646.3480.6519905534709638083.stgit@gimli.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161524009646.3480.6519905534709638083.stgit@gimli.home>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR18CA0012.namprd18.prod.outlook.com
 (2603:10b6:208:23c::17) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR18CA0012.namprd18.prod.outlook.com (2603:10b6:208:23c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 00:33:45 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJQJk-009sWK-If; Mon, 08 Mar 2021 20:33:44 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33dd2ead-33e5-4973-8bf8-08d8e292ffbf
X-MS-TrafficTypeDiagnostic: DM5PR12MB1754:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1754C6D817D088EC44531DEEC2929@DM5PR12MB1754.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2NXwoi1dCzotFcMmGNMnC/3fLJ8I4voPPkuwlyWV99+tLginV1QwcWwoEyIwEkHV8ayG3zPHI4YbUtMQ6OlpIcvkaambWJOUg/Q6t77MC8tJYy8jpwdZellkOGKCXm40cDxASjU4p4jYvOI8ky9ghKC3/LyDiB8P2nUcEMHs32sBaxjwE+6xlxykmKneDwm3LQmUBjbO8+9dJrfNFIwEE0IC1xkJkBNejw6IYuLjm+Lgzhsb6n0EteLGCaFolUrUI4wXtTuhMeX+6dXj2Ag7b/4koio7bZ4+U94gjDrryBExxgavSAxrvtTrplxGTcuqUT+tDthARFuc6oA/S5uy/LVZRzHeJCq6i0CNLw0yVWVIy4Em6AC6GVj0Yf0L0A+Hz14dYqRE2gpxesmvg+zucn0FQvnwm+ZRSULvQIVmkKizoEYLjkAU6GycItPQTqfAy2Gu8TtvHnep1QIlkdoZYtBGPZhI9aKfY+OZwRYym+Ak0EuLOvsdtT+k3acsCZsbY6YtzDFenSOucLL6xfVrkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(316002)(8936002)(8676002)(2906002)(9786002)(478600001)(9746002)(83380400001)(66476007)(66556008)(2616005)(6916009)(4326008)(426003)(66946007)(86362001)(186003)(26005)(1076003)(36756003)(33656002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?p7D/zm03YDHMmDkmBBJUTHZdomYzLdStQlQjoemcmr7Yts3HHVdFDlL/sIO3?=
 =?us-ascii?Q?1z8cIJh3jt32ikXiHI79993PZOhVO06/YVSkVZfJAgekmSqAGMSxyznDEMSb?=
 =?us-ascii?Q?6lDAC3x50/MQGwllHGPAz/AL953M7ZMMj9BJhP7mOJFRwZb2BfyqyO3ohF1d?=
 =?us-ascii?Q?7yPtpSlqkFv6hCDDNf5oihouFIEsfWDT/KNul8L8TLOCWbd1e0T5bkzSvmXP?=
 =?us-ascii?Q?5TBUGo+trMt30/rykUlUN0QB3KGqhjO+PrlgrJp4MuERDz/LZec7RRR7z37k?=
 =?us-ascii?Q?0So2R61d2z7NkX9aZU7dLrk1ROaq5Mb/qzp4FgT5qV14pmPt38S+ZwLHSTAQ?=
 =?us-ascii?Q?ZmqjrOShaa4st7/JKQ+vshw93o+N4vyrWERkBj3ZOKV7CgJI9et0TupRhCFO?=
 =?us-ascii?Q?kd9wTG26ygpOje12GmnEFsFQLFAlEOg/JhWYqtKy9/M+DbR+I2n8xWpdAqNB?=
 =?us-ascii?Q?O6x9S3lS0Diy/bDqv5OLKL9EKVN4Gts2AppbjraN01R/nb/ntHT/YKtq0IJ1?=
 =?us-ascii?Q?VfR2RXKKoR2f3rBm7YUyJXG8FNFngMvxnwT1U3ImLvzd7b3l1n2/bEQvIJYS?=
 =?us-ascii?Q?Sn9HdbotDw3wJ9uS6/TsRFxCNJ4gTSh2GPWVvyNcTxEApdUapmSTyQwqlLmU?=
 =?us-ascii?Q?He1uiCyTPWaedkWUwAnpIVTlUvJVdsT77w972n4jcxwOCakaeTnyQf8er4qF?=
 =?us-ascii?Q?rBimaYMvc5hMDZ0AnyaXKkPmEA9lImCnLQJ4M22xZQQgtCJb4GOu6iIfEHM1?=
 =?us-ascii?Q?10OM3LpUQFYaTFE3bN1ZZV8htBmZcEL0PEIT0UaJvSYhQYBj3YK9XE+4+cJl?=
 =?us-ascii?Q?QMT2R5VBpeFn3RD+guenej1G21Rgt5u5k0I9CoRMpeaP9fuLRoR2zuFGnxaP?=
 =?us-ascii?Q?Njy1nw0mRmrSUT7j3uDnTgevPn9F/BeopG0a4K4KzmBUvzXLRBvLsKHWNlke?=
 =?us-ascii?Q?NZY4r9Ax26WdIu9hGgI4VeZqAs0jbSqXRF6idmZ7sAW9zKgg5BbwKNNx2jfx?=
 =?us-ascii?Q?mQES/egedrWUvfV3sbasiEPgvJA34hDxRpoSN27mWzSSxv7OYfWfTbBCuvZe?=
 =?us-ascii?Q?ayASqJMBP/82OTwODgEpsgtzKMkOoVNTKezZl1IyboYn72uopYaefAup4bpj?=
 =?us-ascii?Q?jlCNdC+rzDtYmYcHd14+BqIPqz0V/Ma/2JPV9oA9/oHypzY0CtXcn5MzzfA7?=
 =?us-ascii?Q?+4gm9jbu+KVH//tJi98thbZWwLnQiUg/Geh+kAz6hIF2sgAb+g800D8KaiwP?=
 =?us-ascii?Q?XdnBgpSLpRw462J07qI4cccTqXOalKWdnHV0T2HbjClfOiT451TNiGmyDLlk?=
 =?us-ascii?Q?E4FDGcUAjnj6nutZYlmAboqx5h6cAXLUOtX/KdfNOefiBg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33dd2ead-33e5-4973-8bf8-08d8e292ffbf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 00:33:45.9159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: phUqUO76KW81aDoNosMyAB8lYDq9z8bwtRdkQHutasnWOWvNhYKiOkFjd1/SAEB/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1754
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 02:48:16PM -0700, Alex Williamson wrote:
> Add a new vfio_device_ops callback to allow the bus driver to
> translate a vma mapping of a vfio device fd to a pfn.  Plumb through
> vfio-core.  Implemented for vfio-pci.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>  drivers/vfio/pci/vfio_pci.c |    1 +
>  drivers/vfio/vfio.c         |   16 ++++++++++++++++
>  include/linux/vfio.h        |    3 +++
>  3 files changed, 20 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 415b5109da9b..585895970e9c 100644
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1756,6 +1756,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
>  	.mmap		= vfio_pci_mmap,
>  	.request	= vfio_pci_request,
>  	.match		= vfio_pci_match,
> +	.vma_to_pfn	= vfio_pci_bar_vma_to_pfn,
>  };
>  
>  static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 3a3e85a0dc3e..c47895539a1a 100644
> +++ b/drivers/vfio/vfio.c
> @@ -944,6 +944,22 @@ struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma)
>  }
>  EXPORT_SYMBOL_GPL(vfio_device_get_from_vma);
>  
> +int vfio_vma_to_pfn(struct vm_area_struct *vma, unsigned long *pfn)
> +{
> +	struct vfio_device *device;
> +
> +	if (!vma->vm_file || vma->vm_file->f_op != &vfio_device_fops)
> +		return -EINVAL;
> +
> +	device = vma->vm_file->private_data;

Since the caller has the vfio_device already I would pass in the
vfio_device here rather than look it up again.

If you are really worried about API mis-use then use a protective
assertion like this:

  if (WARN_ON(vma->vm_file->private_data != device))
        return -EINVAL;

Jason
