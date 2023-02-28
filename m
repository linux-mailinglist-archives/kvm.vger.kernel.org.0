Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC6B6A591A
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjB1Mdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjB1Mdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:33:53 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A531C30C;
        Tue, 28 Feb 2023 04:33:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ww2TS0CI5WBEbwthTSqnlfBI6iZEEcFSlxRqu6+fEnSvYXLisSjcASzWNM5VSsXMF2OdInvcAeWxvo/Kuf2oeExXN3l/KEvbpFxGzD9s/LxwJJBs2cvs6FXGAbQ46M1cfEQHqlogblYzjbShEA+K18AJZp+6wemF3EXfNs0jhMLTtJ1ZJgPUkAVbwKBHYcrgmKQtweFd/PIHGkxQnns3SNzs53KRZMspvopDLGlJD1HNcun5IM2UCWrBGPpKgdaSsxGpfglUKo8JkidTOx7bod2/HVrmQfldQD8hY2TgftFi4WGqQP25kCgZ9SP01uIFocXaRvg7XOZUpSA26aBJ2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sj8+WKIahjVgN68C7aYpXUAeDm4qmLrZ6crYmJeOoJM=;
 b=fF7OUFmVRXKd3aQvwUzb441tM3QYlOXRqWWctPzIC+JV25tV3U+6idnjKBt4AHT0pPwdTnpGAj9seQzNZ+S1o7hIO9KT7GG39V/KmMstbwQ7YTBGSpmWcHYkn066W2SfzXsr6JLFKsAbCLy/Vgti68AkBC4oxZ+s3QrPROc4Waw6NryWU2mycwydraWNvf3aUt3GifLVYs57muiQiGqG+5k+a9fHU6EAZdk/WbH0UR8UC2PsRKVzX6l6oTZ0wRyq/8W1shPl4vGdekZm6RaGBwhCyRz70AE/to5gBSBzc2BxUvuwxbrFc9r764FBXxNjAXTm53nqQja07TmcsWhsmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj8+WKIahjVgN68C7aYpXUAeDm4qmLrZ6crYmJeOoJM=;
 b=r1SYznUVT7I9N9sadMPwfcumQCvknOC+tQ1N2s9sK46e3p2fnJyZXKrxcssl7JA3lBsvnfwOUItxVG1d82Q0expE0U9F9+evdBBXm0Yhe0taJFm/8CJkLtDiTJEunS5LNNR5s6UC6f6acS4inkYRqP2C+OEEwtLnd351eddIx11H6A0gpB/+twd4zY5aQpzlf/ODRs+Lx0kUt3m1HiEtoQoEHE/GF39JzcIjMoAfOLkWVy65USSXB3YJp5GFVlYgVZjL/3aAQscMYdVRgdwOC27q1utv3FiCK97mSetIGN7WsJRMXPwVIRmQI2uu8BPeqoBc/Mo6PtD/+ksQdD3fxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5069.namprd12.prod.outlook.com (2603:10b6:5:388::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 12:33:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 12:33:48 +0000
Date:   Tue, 28 Feb 2023 08:33:46 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 14/19] vfio: Make vfio_device_open() single open for
 device cdev path
Message-ID: <Y/30qnOdKLeBjpGv@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-15-yi.l.liu@intel.com>
 <Y/z72jEID0QHgaLl@nvidia.com>
 <DS0PR11MB7529F1D9FE0F751E45363606C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529F1D9FE0F751E45363606C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR08CA0009.namprd08.prod.outlook.com
 (2603:10b6:208:239::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5069:EE_
X-MS-Office365-Filtering-Correlation-Id: b965e57e-533d-4708-d4be-08db19880a8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q3LFfaewIuTv9QkSvM0FPKcGv46YoYx/JPk/xi2Df0RF/kgdlSs5QcslnTxahbyjwKKEsizrVYVR6KJsTpvzVYpKqHGZRZJAm3AvJQvBx5Mbt/ETfVb/3h/YZijOfLXk2+50oDY+bdAA3oM9CnND04iUhgZQE7rqY4keCjcdPFUGmxC6MYZJ6BzpJ9S7M6NTUXP+SMSnCKliH3Nd7JzmLdgS2gPvcgJZAxLQ3QyEH/D6GmfHZQHTnXAHZtVUC/rJLnTobXhUfmOq5E5p1JEHAr9JYyQElu43zBgxuE5zN32sA7AKyonR05r3z9iAw2OpkQiBGP7buQ2orwmZ7+WuSjtaSxpfnGEN/GBCPMeANk5Nvdue/ejoGudxq3mJbrvRf5ZB5RrWXm86mJOmiXBwl5/pC4+WsLfby3FWJRNItDtjk49pCS5g5/fJvRYyRlGAWtuWZgrJ4aUyUWjW84Ioizn7MikkQ0IJwosawMjY4QOVdPWBAdq5ycMa+/+Vg3OC1OrzXGwSxkcbSxJT3wEv9o2OqVFREoEuL7iKl972Q3ofON1Nv2JSUTH2RBitjPudtWW9kMEAeuQr9Pf0v06P4CF85Vd0XBOdgzM4rJ0KyV4/FEXEf14yxG95isVY8tqINgMYX7M0FUnSqm2U4hFAJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199018)(38100700002)(86362001)(36756003)(2906002)(4744005)(66476007)(7416002)(8676002)(6916009)(66556008)(4326008)(8936002)(66946007)(41300700001)(5660300002)(2616005)(26005)(6506007)(83380400001)(6512007)(186003)(54906003)(316002)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BRxrVcqBCt5rFuxYUDhY/I2aBlZsCfq6l/kpO2bELYf2rTFquyygzGrEn5uc?=
 =?us-ascii?Q?wjk5msArxXvFbrw5IYykfwc1OhZ2MxBYsTu2mWKYOyPHbys7xragID6nTEkO?=
 =?us-ascii?Q?y/xtYWhtgHAn2IUviNpAxDJI5cQV+aXrVjNM8SddqPQl09H2dgmNkVd5lWZL?=
 =?us-ascii?Q?V/3X8JbJ1YCnGW/rKKW+8VpQaWFcioZKGtno5fFBqchTotf220fgrVnYnZZY?=
 =?us-ascii?Q?vvXzLs1hFJXeT4fgry8BxLbWNVyBfi18BbhTq/ZaW78Pqg6cFR7zyziZuoyr?=
 =?us-ascii?Q?7UEtCZZnU/pxmYaGtpcZHbMu5sfVQC3t63Vtz3wdsy5spcFplDFTHSDwBmpE?=
 =?us-ascii?Q?oT+sV3a9E91DSro42fVQ1opo1F61x0xYTj7o9kTYBgvFqMjQ40GbeaHs3SIP?=
 =?us-ascii?Q?fSWHaCWzXD+y29mwy+b9rHkaIbj65yRkPveRBGd2MonV2oz7oEPmzkhP7Ioa?=
 =?us-ascii?Q?So0oMxZdF1/tehUPm6MQkBhUFlzIcKipTZyeGtX8R27qewB6Qrqn+kliTZaJ?=
 =?us-ascii?Q?dNtbpkxfDuJkGLqslI+SnI1uiQiPqF+YLS0yj/wz+JQ9M3sKYDE7AenLkhSX?=
 =?us-ascii?Q?zobzhI+6vm1BspzfoFSFQRYEF03cprREs6s4XIjk/zoS3QwD+oWTKA7eXP6I?=
 =?us-ascii?Q?edCrA+1IhopSvO3k5eBAoV9+dJhJ2TzBl6HNw1UCaT0Es8jRWzsGLX/weYth?=
 =?us-ascii?Q?XkLGcYuk3spi/qS5L8MaVHsg7S4SJSFHK/Gqr4vh4gTUedwOlnPnc43C/CjB?=
 =?us-ascii?Q?6xPcLvDkieUSH//Et5eqJO6Jof06oglGk38XS3zfONFF9l4wLMSZFM9Y9HH0?=
 =?us-ascii?Q?pJrOxNwhLLZl1HTwZ8jTqfv7fgdMGivocw+D1eGMzvctnnGTr4VQ19gqq08y?=
 =?us-ascii?Q?wk2Qfu76yN8l1XAUl8g6SPA+ii6FFDdwv2sO4eViOmuCX1Em9VLzxv08tez2?=
 =?us-ascii?Q?ujJ5XKDY72Uk4VL/io4ktcYbQr26W9twYG7G1PPsDNf9Rk74GbOKMF4Lk99V?=
 =?us-ascii?Q?J46vITpuEhfAISjygmrE8C0zFesJ9a8ABxwYzKd0ViTuEiU3J2+aGMkunCKs?=
 =?us-ascii?Q?qZKl4lOe7NjoZ32IOueDNK1BjXLnCYDmODCI3BQEjVXCCAj+/lxtwnC2rbJj?=
 =?us-ascii?Q?BtXu3u9lMqNSUQu+pDtSvPNI2Y+i/+roCIT4m+KlbZFsLyh12HPMmL5FBSBp?=
 =?us-ascii?Q?o7iVzs0tmOVI8nJF2XfCsv7EwQ/iytH6XltO/0JrHQOn69816VdSecISS5UF?=
 =?us-ascii?Q?1jCA7wQD4aU2YqCq6RJ12KiCIqceBdvZiaOhjr9VRZON1MOPnofcbJAKc4Rb?=
 =?us-ascii?Q?PXGjVLyyWMRTi8VB7bNP5ndlzKcxK5trqwQSau8/II79uQctj7I1AQ16esEy?=
 =?us-ascii?Q?qoj5WeUGRa94foblpnQpGuDyOZooLhRkvVQUupPMs1zmG3LLrltXcsU7F2U5?=
 =?us-ascii?Q?i8TGn9yxZIoe2DOOYJ2IQ2C2/03FmN/j+WS1nrw8CqMS8ul8Qis59U82L6kp?=
 =?us-ascii?Q?cw/MW5Z0ad9KSbce8uc8cj8J7h8qq5XWCW/Q2SK0Cjr3rkojaYm+cEnzLZ04?=
 =?us-ascii?Q?fdIkyfDqAU22LTrb/jB/03Yfmccny4Ltu+ea6Qag?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b965e57e-533d-4708-d4be-08db19880a8f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 12:33:48.8689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tXhQJcNRILM2cZuLA/pVk3vAqBo2zJWCXSfGpkGQkFzspGk6bbVC7qY9CnDMnG1F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5069
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 03:11:34AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 28, 2023 2:52 AM
> > 
> > On Mon, Feb 27, 2023 at 03:11:30AM -0800, Yi Liu wrote:
> > > @@ -535,7 +542,8 @@ static int vfio_device_fops_release(struct inode
> > *inode, struct file *filep)
> > >  	struct vfio_device_file *df = filep->private_data;
> > >  	struct vfio_device *device = df->device;
> > >
> > > -	vfio_device_group_close(df);
> > > +	if (!df->is_cdev_device)
> > > +		vfio_device_group_close(df);
> > 
> > This hunk should go in another patch
> 
> Patch 15 or 16? Which one is your preference? To me, I guess patch
> 15 is better since the user may open cdev fds after it. But its release
> op should not call vfio_device_group_close();

It should go with the patch that allows creating the struct file
withotu calling vfio_device_group_open()

Jason
