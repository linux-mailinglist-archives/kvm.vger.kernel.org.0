Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002893F4C34
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 16:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhHWOTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 10:19:05 -0400
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:2758
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229518AbhHWOTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 10:19:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjxbjfmPGhrS6Ygnd7gKs1hW9Pk7sLiyJ/FeMUUH17+aKq9KrRpdtGr4vUAMvxGTqsnw7jYTNoPuAbJGjoFEhMNUzx5YkwM3uIsW5pjvWTJmWAtY0MQq/L/r6vTHncbcsgHvI8rCqMEQ/gnRe4JYSB10nKyWrcStnHYXKUdpw/WREjs7JbVz0aNy08dxYu9OXlQEMszomRZuplB955xFAdOJQ+4nyEMVEAHlajQLEOaKnwokcNeqYB75SiIv4ckUyZ7Cev+F4ra2sd8g0mrwOV32IvyOay1eMtBq4gkgVnY+pjEj5aJxKGYFBJrsUkXMVCPX6m4qqEECbogfknb7bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czTUI5+V3LUtzZLdBeutBdEm35DdFZS2p2KtjekM+E8=;
 b=L/3Omlh0Hq26hA8etpqFOy1pSsmmY1lo1ERUgcuVmDdWxOZTjcqzUCLjfFVE8LDePttgdLVOkAMzARgw83X6X0ViLZ9+IYOSSQ0mqhoKt+1enkMwcN5vSxyqD5zaUruAL6YLRyLhnbf+zGWYJgrfs27WCPejcU7XIn1qk68McziOmZDMB/t0hvi0isqg4HJ6C0/LEb9x6aSfdWalAez9Akv4JvLA5y2+sBxerhug3dER4iR3uVuoILA6hIIUckkTdx4d0CeAAACTnOc5TYAfKkuSpfYhhgz+D8inAcfq+80ko1AHOn5iTXKwPhxiBHE/P27cRUWatep7JRLBWUqFuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czTUI5+V3LUtzZLdBeutBdEm35DdFZS2p2KtjekM+E8=;
 b=fnL9APoC5rSJZaGfS8TXlrz6zAO/BX2UR43lu9JeI0Cr8aX1O/6GxQkXQnpaZ3Q9r0z6xmKhP182bEsPldEnXi9bvUrTVQqi6RJgF6Rj86grKm4DCq/ItmFsbYeUBLhaC67CsXEjFciKh/1k6kvO6sv3BnDTkMsMQ5eCsegS/NFLx02oZCTk9kEiA5ewGJ/7cpWmGVaPNuTVvj2yGeEk0bt22pP/qisLEuWO4Utkim+wpxEeDPdlJIwF6eWuPRDjHyE/9/+IskxDEvV80+xhzZoM9zHlQDdOj73aLLiOAQxjFz6T1+R4dvD3hp6tEupgYmH30PNj0+639REt/bUFUw==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5286.namprd12.prod.outlook.com (2603:10b6:208:31d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 14:18:14 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 14:18:13 +0000
Date:   Mon, 23 Aug 2021 11:18:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3] vfio/ap_ops: Convert to use vfio_register_group_dev()
Message-ID: <20210823141812.GH1672295@nvidia.com>
References: <0-v3-9f48485c5e22+3cb9-vfio_ap_jgg@nvidia.com>
 <20210810083355.GB21036@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810083355.GB21036@lst.de>
X-ClientProxiedBy: MN2PR02CA0035.namprd02.prod.outlook.com
 (2603:10b6:208:fc::48) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR02CA0035.namprd02.prod.outlook.com (2603:10b6:208:fc::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Mon, 23 Aug 2021 14:18:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIAmC-003guT-Qh; Mon, 23 Aug 2021 11:18:12 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 779c72c0-4f12-48f0-4154-08d96640d7f8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5286:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5286770A457246C8D68FA97CC2C49@BL1PR12MB5286.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dmwKuMJruGpHq0kLo0L3IqXRWJdXl6PLTPwTyqkhnyPXLUBhBQZrNIffDtNKHW4Wv5la4E22+e2/0i5Aw/Ix9tstLcyLpds+WjcQqeOZP5x3NyuetsKsnW7AzxHHqB6N3TgypPP0ZF3GpSuXFTEheu8C8irc2t2phe8XZB4JPu0NzU8Ti9QWb6RqyDYen+8y5Rqj5YGH3gcDieRwVTyD0CP0a6BqgQw02ZLgzTO9i/NcHjONLV7dlbkX2GEBVsEQPG0k9LqeiHsjWuvyvWw908rIVSD+Dc3dD4ZV/XqbTEoPcYpU9d5VBvIMqCxbmUQjTktTBmn4JEKYd7JwvmYMh+YzOMUWkWB9xTphCSaxxJSi3TGhOBTONrokjc6I6mv0z4NzYI9rr2y0zeeDqNQEjl9epqgNV/yF4onXwJeNK2mLc+CRPcqicY9hH8ei6Poy1ur8tbVShUYFKPCWD7IA19PItw6iAwGiEr9/4e9pnh54VXB4rSJS6Or+SdRt4K8JEnlcM+FsF9kTJQnVSF55pldH3Snvk2wkq6O7uiJ/7UabRCADtFXjmvTphf7a9xjliwr1YVERFGKRWIEWdYFkQDHN19b0dLTNAhKOUXjld0/u05xmF5tt0Qr0TvXR/9nmgfWJSvCcvoqNCKzQG9u2kexyMZ7/qREoJMXlrd5cv2+0PKHOPkMWRuT1m9y4nRalrPyn4UqBVSFXDAO6FgY+SQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(6916009)(9786002)(7416002)(33656002)(26005)(36756003)(2906002)(8936002)(9746002)(4744005)(186003)(5660300002)(478600001)(426003)(54906003)(316002)(66946007)(8676002)(1076003)(4326008)(66476007)(966005)(86362001)(2616005)(38100700002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w9R2rfvjBw4bteEhhdxAEDiRSX1AWRODCup0k9RKg9okrLaB0XofRUmBIMy/?=
 =?us-ascii?Q?gsceIaCCQqVHZaUx8c0e7eK6xh/Fru5kmP5Bj00NRKbZodvUZD7Sx2xh2AeB?=
 =?us-ascii?Q?C0R6i8iyiuor+lyGEryy0HCPlkioTYJ8UHFbRr0Wf9tR8cJVsNba/5OT+wDe?=
 =?us-ascii?Q?KNM3L79You4R30ijm6FPX/tsvrnqgpCbEX0ymZVoWBaf7qNDlQNbuZDQ/3OW?=
 =?us-ascii?Q?qjvrwF1pSwA6t2e4ntEBvXo9p+QvmyOR/62wHzZ5QsvQtW9eo/Usfj4RY8Do?=
 =?us-ascii?Q?EqOV5rAOnxfP+Z051bzKBf6J/RGie+ETOTOF3yWuLUfyT5XqEbZF6SUpkrMW?=
 =?us-ascii?Q?FuwAB7jYetVZOVifsGBXtP4++4CH+OMvQGylL6PdZtGHaZNfg3uEamzVaWA0?=
 =?us-ascii?Q?yNUDGNS/lhgtQGthuC2EcY5bB1JE7cqNzSuSvXwg95rb5jYOv2qsOvuhX+jJ?=
 =?us-ascii?Q?psndjC2QAdNTvaysWea/avk74jJw2ZvFwCDLMGZI+pwFOzp4IB/fPobMLSA3?=
 =?us-ascii?Q?pdssDxgeGrw7+wyLqZS8+dBf3vjvG94/yFaMl9pSCqu7NMjnEJL8HNPgVXOo?=
 =?us-ascii?Q?RLwNMhkGw+YoAz0rm3Lkj5NsBKw/NAN2bhz9Sb3kPU/oeSb2g8N7jKagtZ0i?=
 =?us-ascii?Q?IrBzw2luYdSAR4D4h/D/2jNDTvp9p6SzAVWiUYZnTvfLNzv2AUkKoW0Zh7MD?=
 =?us-ascii?Q?yRsoUYEzHixYKKR2Yjq0D3d613xWSahXSsKjkE7Gjxnd6Z2T6L4dECv22v2L?=
 =?us-ascii?Q?dfc1S+JDbavPj8RbLz3W1IvSY5w8VBQO3jXksPm2yvb6wkm/aaQhJGPm5yww?=
 =?us-ascii?Q?gG3TL/uVKSs2CAb3zjD9hA/h7rJuxhiti+73/Mpti3v4SAxdD1XWtNmn9yuc?=
 =?us-ascii?Q?4UuoBor1FkaZ5uQsgMFs+aBbxQJ1z4gWgXiN0neja/AHeD3KivUK1v9Fqmyu?=
 =?us-ascii?Q?CuZj5BiH56codf7A23Q3UsxpNL/1c2YJQ311qC0nOuQ6ImBa5YXUWyPmH5OQ?=
 =?us-ascii?Q?98ySSXsww/1QlLglxcROne5gH1FDuMMvYDd2Uq0qIV92mac+aCARRoreKaz6?=
 =?us-ascii?Q?eJeLsRWV4Rh6fh6L17+8FD/aVanxOKnyKR8hftvRWpQNXcNNuP0vO21A4hAN?=
 =?us-ascii?Q?PDoR+uWqlBTJhb8Ke44KjMjQPAqp5hlEvU3rdlwFr9+8SfcQczfT/WEfCscG?=
 =?us-ascii?Q?IQFEwcSjOlPaPLpyLS6soEULydHoBM7V4O6WlX/+cfK17/Kvl94VKDbka9xv?=
 =?us-ascii?Q?ewCgHsM46kUHf0+kJnTO/Jn7ESmKnqxICu4sgKGB9iVlg++IncPRuNDL9XoA?=
 =?us-ascii?Q?ZHBvbv8yQ40UA9jlxsXTx5ew?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 779c72c0-4f12-48f0-4154-08d96640d7f8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 14:18:13.8042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pAwb02yj+/XTM6hevcHNmSILHMX2B37FBqHEOjPz2mcwUCYUJD6IwuViUz4fhlhK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5286
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 10:33:55AM +0200, Christoph Hellwig wrote:

> > -		atomic_inc(&matrix_dev->available_instances);
> > -		return -ENOMEM;
> > +		ret = -ENOMEM;
> > +		goto err_atomic;
> 
> Nit: the label naming here is very strange.  Somethig like
> err_dec_avaiable would be much more descriptive.

Sure
 
> > +static struct mdev_driver vfio_ap_matrix_driver = {
> > +	.driver = {
> > +		.name = "vfio_ap_mdev",
> > +		.owner = THIS_MODULE,
> > +		.mod_name = KBUILD_MODNAME,
> 
> No need to set mod_name.

We talked about this before:

https://lore.kernel.org/kvm/20210326121048.GN2356281@nvidia.com/

Thanks,
Jason
