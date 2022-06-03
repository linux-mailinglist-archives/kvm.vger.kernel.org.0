Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9191153CABE
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 15:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238609AbiFCNhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 09:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiFCNhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 09:37:18 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5E55FB7;
        Fri,  3 Jun 2022 06:37:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxeFS06+NtUvAxjNS0dtowuIR6kcxUA2u6HKO1x5V3jHWwPEiERLgsNJ4276xKCGdj0Nczhzeb2Gj2MuSGz3oFz5BOd6h0djkHxWh1VBeeSwVGSf7CDcU5a9qiWL+nyFmHebi2rSMJ2kXNzqRJlcgu5kMHmZXpPKEXlJ1oUWtJuX78pcVyz5s5UHBdaX/KbCKfOZlbZGKxjjv45ZyWubkbmThi255tpU1B76e6czFMU7H61xpP1nacA4+lcB8IlSvI9i5FMrrLDUeYVpBQ6CByltewaZ0Y1yMp9EmTilUayhYh8S0v3ArIaRaELPfNgJ7Xfh/PwQAypM0aYy8lW45g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h75YBVdWjDDhMOswN0rvs3ClDy3jbpwi8GCx7p3QgoY=;
 b=WBgu9rOAdR9hmFhz/pSafRlP0M+E/Oc3d0/Kl7bS4A/1CxtPK9/qvucNjpw6RRvabtj3qkgMjN6xKT7NzTk20rY3Q6frbMNR44jvKNkUdCECgjAC9zGJM2RWFy2cJsqyvLywfU0EoKguQizysiRLvNvekx2boyvO8LP7OZnYU7S6zwCdzyKMb3UEcuxhFNOs7LXiOEGCMTmzc7qHJRGXtScBdTG2P4q27r+8DClsGYVR2oIFcRwQkc5jDxR+c17faKiZ0pkCIHK31Osw3FIWbn+/ONCQRImiAJ1u/AaVgrU6wCbxBJ/m0sZEqet3TE8rgCOYsqex3iYQlgsSye9VkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h75YBVdWjDDhMOswN0rvs3ClDy3jbpwi8GCx7p3QgoY=;
 b=RY/P37pvVQSwLRCsfyLY4yhrr1LKyGtbV3uEdX6rIiWytyu/KAHwsNo01OFh481vdR64Y/kjV6dQGpFr6w+Lw+YT7TYXP6kS5Ozy1oAgSd7zx/YJNS5UMcJFk96BnmTE+oriFuH/q/jAGngvNULiJUBHunZv1IYUqSuh0ILq5rsr79kw27mLI5w2bu4QFrf4yOgW5y3blr71q3M0Dif6I8exn3b5BszDRwBiyMpxjIajRrb6ezVDItNkRK7cCQGy60G3EFgahnQrIQ22rFj8/J/8codPjasyLzxHJrS87RJ/j/6R0GtbTDm7UIxvWRYdy+02lLOPMULG4JRdEUxamg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB4799.namprd12.prod.outlook.com (2603:10b6:208:a2::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Fri, 3 Jun
 2022 13:37:14 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.015; Fri, 3 Jun 2022
 13:37:14 +0000
Date:   Fri, 3 Jun 2022 10:37:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 03/18] vfio/ccw: Ensure mdev->dev is cleared on mdev
 remove
Message-ID: <20220603133713.GZ1343366@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-4-farman@linux.ibm.com>
 <65153af9-be41-8f20-98f1-bc047518c3ae@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65153af9-be41-8f20-98f1-bc047518c3ae@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0273.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::8) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efb86d95-a36e-4457-0c67-08da45662b1d
X-MS-TrafficTypeDiagnostic: MN2PR12MB4799:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB47990E80D5FAF92EE41BBCFDC2A19@MN2PR12MB4799.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SOOl1Oz3ZATdClOZWpGplCMSHmFYECGKIJNtD1VWdY3cmXA2My0cUoi9dDAQW92YQwGVg+106qeHt7q/Ek0QtQg7JEgCiR3Tu+/f5mM5YzMnWOW5OZTVDkuGZGJCQMIshNcETVeMUZaBoF9DhOGFq4nPT9nTySgE6cRG7Ftm4BcaHdDdNQPrzyP1wdbSFZ2TWlcyWAPOhPlgxE0Oz0IW5tAlJ5CSYjGb6TdRxCiUVggcTTAdilc21U868AXz5TFXvXtVSFKwInzDQzhEl9nRbx/CpZNN5Fvb9IUJt3mSLS/uC9HydFOXwFE9GfTv3A4OtHL5ZKBaR/HegyTKGQ1shge4PBKMd89CzOYe3kvfva4AvX3XxvcXCZXDhCHEA0O1hBWdvOXBE2Qt1Zj7eX1mnijPQISaSLSYZHH/CDTUr/hVePw/HAZChp5NALsjdYAsXucU0C1qaJVQwSHfm/+ntR91RKrtuuYi/Kh15dqF1w3gbq/SsDvKqvZrqh8I+h5dQDdcZet+Z9XYM9peCL45E/RVifPHkWX5BEcNY7SKJqOA92I88khQ0L6s874vd9SFt+hMsDGw3oYGVuZcwZFHCqahveFgAxVSsSZA8O8J3F20ikh6Ce6s3KC9QKtjHX5XPC7Tt53f5SzJPx6xlq0eqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(53546011)(186003)(6916009)(508600001)(2906002)(54906003)(33656002)(4326008)(8676002)(66556008)(8936002)(66476007)(66946007)(5660300002)(6512007)(1076003)(2616005)(26005)(86362001)(6506007)(316002)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xYYcfwouiecDrwF88JXJBwpkvEO6pMLgB6bAuguk0QYZmf+mSK6YJqV/A6R3?=
 =?us-ascii?Q?PGxzRDEq22byb/J3Sgdx3YNiJsw1uoaznlQEYluyOelVP20Ba/U1mOOollx2?=
 =?us-ascii?Q?6ezdBWq6DBhS8/SxpuD/6Z8Zzo2sh3TEl/MxfQmIwF3Vscfiwwvji47yl0Js?=
 =?us-ascii?Q?z0M71FgcI4QdmGZ1y9iNaSZf1Cw7GdPwVqmloFDC1lBHF0j+KBfXifu1Fv/G?=
 =?us-ascii?Q?Qm1ugrU5imXoQKGQwbuCDJjiGjtA0w49rPdacR1btilE7UiZIe39XIJksHaf?=
 =?us-ascii?Q?6mAffZuU/HpnZeEQNJUYlaYR8MZBERgkTcgEJ0L36enYuucohIZeXT2hrRMA?=
 =?us-ascii?Q?z5m5/q1munGlrhNaSJUfNXAVf4djbsa71UQ7/pePpl56RIP3/um3hb+xgy1M?=
 =?us-ascii?Q?QdlI3uZHdoKdkv07NosUlvrKPxBoQ1AyAaZ8gLp3bW2MTPj2dumUgBQCeyRb?=
 =?us-ascii?Q?WtSo9sHVPXNbHObLpmphRQ7ny5KdDmEX6OJMbB7m55gkp0l9qe+YKWq4qFPS?=
 =?us-ascii?Q?ZirDZPsznJBDnUHOVJssl+Y+IKtB4oEEa94SfsaqeGQ6MhOfF7PvNV1OXIr+?=
 =?us-ascii?Q?1URatzqjIXFrHtHOApz9T0k9LA8/Mmkl66toLrTBv7lwCX712LahHbw1E2Z4?=
 =?us-ascii?Q?jXBV3oX4FHbxAc0PUNat4dZf1X1Q5r4DR9EIOWvJInNcQQXbYlU/CrzVSyiv?=
 =?us-ascii?Q?LknDtPeFDoTZeQ+nETb1L81FCBpnFD9R7F29vgnnB8mRF1AoXSpbapPRpoVe?=
 =?us-ascii?Q?2u6x6Awq+WWXzkcqgxN52XrfwRW49Dw8HhjMUwRiD8gF76O0iVdjGtddho+Q?=
 =?us-ascii?Q?tqRT+JlIqZ/DD1HZVVcMhnHHl77TDXL5rlfXm3HYlipVVYTYQQPqASShb7KA?=
 =?us-ascii?Q?FKXXg5iYeVHQ1tLdUWMG0LrlBFv+uNL2FPlpMyEYUzj5JXhEHOsED6maXUOD?=
 =?us-ascii?Q?SZeH9yyieNTVjiitKzRu8202ucdB9xGCBvGJU/E3DaNnquQDi6XR/uYCXj4k?=
 =?us-ascii?Q?XZw4+raG+amtd5UN7wZGnIFyy0I8OXeuMVmIwkLytLSN1dKmXbjL2MWZa4Rw?=
 =?us-ascii?Q?d+QBAr/VV1g1WkGI7j++sSQ2Ny/7w8bghPbVsRgJgx5jPVCi60oylDWaNviX?=
 =?us-ascii?Q?GBmOtvOc9DiE6oepgjMoLrEqn14e19+wCTgy3A0B/xAGv08ETuAb4ohTBTlW?=
 =?us-ascii?Q?Ot9xQpMAs5x1I7vPw8Fv9sBkRk55YWfG1INCqt76m9ng/GAIvv40LIiMVm15?=
 =?us-ascii?Q?GCeAYX+RmejhsJWgxCiUCHVF34S1VCZRpsBUT8y0ufGIeNOLfcinWlJ4FPK0?=
 =?us-ascii?Q?OXBNtjVYvyLgtdAr4fdu7TdL1sJ6raF7/JcAQpr8eaeO7USmZcljwTBGfg5p?=
 =?us-ascii?Q?FJIDjq/mtc/bD9UO7dNJRPkbpXrmygw9H/61PgxqC1QNMDELf1q1rl5CIY+z?=
 =?us-ascii?Q?pf7MjldwkzzfH8KILk+WU/XPYztaa7GAvHvPAwHPR7Jxc7JYYJLXVNb0cobV?=
 =?us-ascii?Q?enkgmLscG6SCsKIojYYAy38n0SK+y5WIlLiAXUGLu+OxjC2j7zv/WzDrTvlm?=
 =?us-ascii?Q?L/cASOT2x4BQhF5SD4rRybfUqfeCxWBsowLtKvIjhNAM+RFvgbDHYCxSpQew?=
 =?us-ascii?Q?1hprORno01SQTgozA/thHyE7sAshe6JovLPATz2efYy2y0YnVgAqG8Xgklhn?=
 =?us-ascii?Q?f6ai8uNJXxUMN9gXD4rCs6V2knSyqlU13cFnD7OEsON4wjao49s7C+qtLu8F?=
 =?us-ascii?Q?4aZPhtpnQg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efb86d95-a36e-4457-0c67-08da45662b1d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 13:37:13.9901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bf4OraLZDj734eOoM1koUOji2j9Y5f+PDTquGUhH86GvFiyJw7UE/wZ2iIhr6vma
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4799
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 09:25:19AM -0400, Matthew Rosato wrote:
> On 6/2/22 1:19 PM, Eric Farman wrote:
> > The mdev is linked with the vfio_ccw_private pointer when the mdev
> > is probed, but it's not cleared once the mdev is removed.
> > 
> > This isn't much of a concern based on the current device lifecycle,
> > but fix it so that things make sense in later shuffling.
> > 
> > Fixes: 3bf1311f351ef ("vfio/ccw: Convert to use vfio_register_emulated_iommu_dev()")
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> >   drivers/s390/cio/vfio_ccw_ops.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> > index a403d059a4e6..a0a3200b0b04 100644
> > +++ b/drivers/s390/cio/vfio_ccw_ops.c
> > @@ -159,6 +159,7 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
> >   			   private->sch->schid.ssid,
> >   			   private->sch->schid.sch_no);
> > +	dev_set_drvdata(&mdev->dev, NULL);
> >   	vfio_unregister_group_dev(&private->vdev);
> >   	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
> 
> Seems harmless enough.
> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 
> But is this just precautionary or is it fixing a real problem (if the former
> I don't think a fixes tag makes sense)
> 
> I also ask because I note vfio-ap clears its driver_data in mdev_remove but
> also leaves the pointer set, meaning they might need a similar cleanup and
> should probably have a look (CC Tony & Jason H)

There should be no reason to clear the drvdata on remove - the driver
must be designed to guarentee all references to the dev stop before
the remove function returns.

Jason
