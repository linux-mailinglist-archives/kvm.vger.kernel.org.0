Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC537562D5
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 14:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjGQMeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 08:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjGQMeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 08:34:03 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569B491;
        Mon, 17 Jul 2023 05:34:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vzc/7j97TuLCAxogPIyiHtwLvH+acTsD+ZMwp2meB33FCbB/0XlEKJZEg9MwOJ0/7wTqlFB9NTW6YZA6jNA721pnbp5cDz6V+uvY1b2zod2no79At/WWVnI8gb1SJJGPLMg8KKPFj8Dgd8wIxizKeffBi1JJIuQ3ENI+yPGcMi9NGD/9u3AChlaL0CYHwnJU7JtJGWLqJYT0utEXCczjuLlUKw84CfWklIGdQQH6e7eiv2rMm3gHbpy39kLcz0ZZPie6uA1sk8GM4sOz99NO3UMoi55sw84NPmQLdGmghq5eo0qgSn2Za08ohm6m/JMx3GAOZ7mt91JtBQ9eSpdN7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BWnZJYMGWdXtBCB4MObkrtnMI6Lj2VUeE11sF74qIfY=;
 b=Y7LJnogfbFY6P/sLov+fMfeM+ZUNerAXI/QhZaPumGeD0/szUQkRMSVHrmUyP+SO4MrqDryTq2AA6douzchAlUuXWKzE76fHTJF+I72agqztiyu4pHAbe5BExL9aQGoNhMj/5s6qXYfT14ofOhtbbbcD+JnSa2SqLTpLOLOLpakOawHSO1UT1VGXvSIWFwqy7M8TG8tmjwIpWSYpHdgDSOSzHlxbs8hTy9BnjweOlkQxtwspe0avFDWJU9dm3do832fLMZuniyjV/GxHXaS34IPsh0KncbEYHuGD5AS96XMayzWyTNkNqa9xUWehDHGwlAPST+ypbdBHF/9Q3bCU2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWnZJYMGWdXtBCB4MObkrtnMI6Lj2VUeE11sF74qIfY=;
 b=i1sgbtI0hpUE3jyW32L7/a+QHTbFAlQmM14C3cyGEDI6DR6vJ3dHqlhD1cmCXFO/nAxkSlm0Xlt5uZMqsXCXkJV4MWWyFoDwTmWIT0nctObcPFxJ6Dum8/LIz6HyGA/3WER1VP8XNjv8g10Vv8CTSDPNYeptsW/FbD/pH4kIkIeburOolTX6sdFlUoKeKiQ+2V5TT8Xdzx5oOx4DMd1J3cIzDAtf95PCZ0dksUMMdf/eD4MbtmjbUFZ5SFuJVQVpqB7nsl9ABF8a5DZKco1iCrZizN4O/gy0wcMVYI7QUsU6jQKM+l0iKT2D8OnXxNcnAVcegWhqMdG9gyy1JeDUiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5745.namprd12.prod.outlook.com (2603:10b6:8:5c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6588.31; Mon, 17 Jul 2023 12:34:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 12:34:00 +0000
Date:   Mon, 17 Jul 2023 09:33:56 -0300
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v13 21/22] vfio: Compile vfio_group infrastructure
 optionally
Message-ID: <ZLU1NKfKQkIPUIxw@nvidia.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
 <20230616093946.68711-22-yi.l.liu@intel.com>
 <DS0PR11MB7529C571419F1DB629AB7E92C33BA@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529C571419F1DB629AB7E92C33BA@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: SJ0PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:a03:333::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5745:EE_
X-MS-Office365-Filtering-Correlation-Id: c6e87de2-cb11-4b64-8fa6-08db86c2189c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Fa+j1y1Lq9Hy3zXK6uaJfxDouRVEcy+xtyEy/eFZpe/kK6r+Rp4PBcNerMOEwKV1Sk3qYdaYTM8Ea09J90P6BHzANqx8q0aY7XmMQJ3Vv54WyHhCk55UsIFH2e02+utoeh8Q/MhcyNBpTqXCL6bEDQ/OFvYKJimHhJDe1OtN7IOlmkBoRRHh6ZD0Lp1Ib9617AtUM8XwB4ao8dqSlS5f1mpUiB0AcWuQQsuCiGAVrsdyHBR44Rt3Z/o+W/uMqe7HyqHBin2Tf9m5UrOARa6ODU3EEweo1OiA1nfYZroKJlS1mY5KAReCW85GArrr2YI+ufXiCW++MWxuGB56AtdjCRiGU/in7xTDVBl/WRBpbwX0F9I8hTF4FwQ8E3ImbYizqy4/J8PyMVJHzKb8IgLa9suD6BCNiE2GMVcLInQYF5Xs7VtGJLfdku2WRzSh0EaJJ7UTKtpbnK23+OIhz+gLcd4Hor+Wj1++Rm0UDVYgl0sopd65cP9JKo29jzVjXN6DJUNwDA766IA2bL/yFdHAwUjbXDL322y9ebqnKDHWoyJ7fmuyOt4ACltZ+RkShV5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199021)(478600001)(6486002)(6666004)(54906003)(83380400001)(86362001)(2906002)(4744005)(36756003)(186003)(6506007)(2616005)(26005)(6512007)(316002)(38100700002)(66556008)(4326008)(6916009)(66946007)(66476007)(41300700001)(8936002)(8676002)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A66NISPZqvFvLizbv/MX+tR5SC1F8iccwPaZyyaklz18jbqilcBwq4fXLLax?=
 =?us-ascii?Q?NpQ/DEhGJsraNWyf9UrPrv1uqM+YVwVfvUo4KhXQVMiPQv6TeesUl17RpjHo?=
 =?us-ascii?Q?+r1XnC/c51dl8Z2fvRVwXDTNXPTAWz/J/3axHcS9tC+pOD9xIxwSfnvQLBgB?=
 =?us-ascii?Q?Ob/8U9s54fBJD2ozqcIMY5RSZ3UflEiYPpE5vqg40gWIBmkb6CDtNpeX4+xq?=
 =?us-ascii?Q?L/BkUH3qo7eLLWj+HqC07DmaKuALgRnGrPOTtWO7iv5Z1ZUeKF3jLE85nx0h?=
 =?us-ascii?Q?A+txuDKz7TOQY+7plNd7tKJs8kDVVeVbGwTucP68CHrw4WN28O5Nh5kQt/O3?=
 =?us-ascii?Q?f6JXl5xI4qN3I3pI5vTp+uUlw2m6/VdGX/a5iGRZ+r7KYkNColeTN9qLeiA0?=
 =?us-ascii?Q?Oi0Vo6yFCbg6LKJIp7mwN+rzwxufbdT8vzSc9Jmxup+oAWKHI5V/ZUI9qsi5?=
 =?us-ascii?Q?DclQJVoPzda1czks7UOEo2oYqQRx1QmfhJth5rEe7pnb7osn6zT54RAe402e?=
 =?us-ascii?Q?BuRPVZJ52ohox3vQH22DISNk3ZpbNtmKxpzhv7rs4df36JJq9qe9CIxMfk3c?=
 =?us-ascii?Q?eiYssp38VGYj94dsVA3a3JIxcSpMzEXCbQxHSDg95exA1LfduhWIFSKhLZw3?=
 =?us-ascii?Q?rW4vmtwxqKb7eKAIOuds3HjaD6pXNzVq3FVJrqRvxXETa95n0WT3EcbdfH+x?=
 =?us-ascii?Q?2IWN5Fv0RLP1PQuaGhq3iMqE4OPZFtW3RUP0luKU5+exI4AmNiXhGGudANft?=
 =?us-ascii?Q?M9M3NaVelnXLfeFQBml5vQUBpvZt0/Veu4xrgM1jlKg7emuDBDLSHVh6TWsB?=
 =?us-ascii?Q?BnRzf6QRHt18alWQkejSjaAZU454ruSIVSdadxexds+ePapn8gWf1rHWd+71?=
 =?us-ascii?Q?wQFc2vb7vT8RbeqVMro+B8HQapoc1eiwNYfDFz/u8naA4ra+lUXOYr0fsonJ?=
 =?us-ascii?Q?iYyHPUzX88yIJ2Gc+YlDcKqnWjDLG4inJS84eDnP4l2DrnP5aUy/PgzlmHui?=
 =?us-ascii?Q?BzTsW9/f32Txzh0A/myWZtSmHjOpEf3rI+aSxtAvEjYH57/2kwNB4Yrl3ZZh?=
 =?us-ascii?Q?SHTwzJtMJRRek/zatUA1acsatqrYCFjVJ93NPAMHgJEPeCKTlmgTj9SzK4ki?=
 =?us-ascii?Q?jV9Zf4YESzy1ibcERV2hmNPG8HNxeZvJO+9l12fC+iU2zH9+2/3pn6aZF+Yh?=
 =?us-ascii?Q?t6euEVWGTsIUZ+2NV3Z1zdTW+FioZotChR3qbNBPt763hrkVax4Xf49cediD?=
 =?us-ascii?Q?Elm6dqXQJy+6EwwuQL6YoSRfnYVq3oqDCnbMiUYblBJrkhAGFsA/tcJ0tOdc?=
 =?us-ascii?Q?Cu+UjcmesfPOLRNlh5JNL8+hOqfUXt2iCvmwIn5mNCBkKaopNaC6xEMTJUDY?=
 =?us-ascii?Q?8dpvX2effaIztBqftY7Ie+QKoAD/ChamEaLI7IKg7PHTeuFlWbVEa5T7ChKx?=
 =?us-ascii?Q?dpbziz8+fy0rAJqKh2b4u2P6Qy+72kMDTgiItTompSp55xIhXJQdqtw8vDgA?=
 =?us-ascii?Q?y6ncJ1oXMeWcpZ6VWUTwulKEFzzU4yBqDHzS3aBR6Y72wk34PZUuuWwT1woU?=
 =?us-ascii?Q?yvElWdDsM0ijGonyfVvTh5CA/DCJHhghNHo/ftN5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e87de2-cb11-4b64-8fa6-08db86c2189c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 12:33:59.9193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36MGBEFXSzqKMbmtxN60u4a+M1OurdmyAFaYIYjdg6FH6EuilLQI2yd9ALoK5w8R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5745
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 17, 2023 at 06:36:19AM +0000, Liu, Yi L wrote:
> Hi Alex, Jason,
> 
> I found a minor nit on the kconfig. The below configuration is valid.
> But user cannot use vfio directly as there is no /dev/vfio/vfio. Although
> user can open /dev/iommu instead. This is not good.
> 
> CONFIG_IOMMUFD=y
> CONFIG_VFIO_DEVICE_CDEv=n
> CONFIG_VFIO_GROUP=y
> CONFIG_VFIO_CONTAINER=n
> CONFIG_IOMMUFD_VFIO_CONTAINER=n
> 
> So need to have the below change. I'll incorporate this change in
> this series after your ack.

This is fine, we decided to allow this in the original vfio series. It
is usable in that you have to use iommufd natively with the group
interface. It won't be backwards compatible with current userspace.

Jason
