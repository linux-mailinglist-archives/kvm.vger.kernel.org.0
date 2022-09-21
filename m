Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02885E56B3
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 01:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiIUXUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 19:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiIUXUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 19:20:34 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EAA86899
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 16:20:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJ7HDnSJ8+52AZ/cYlXq2EbvfDss9vaXIBzwjfVcuw1/fdS6FE8DLjdyXYaqI9v8Y48y6dIAuX7fr9nhE12+AiforV+tAtte3C5V2FUgRwPG4mdKsEdpaP/Amuk9cTvDIaVsq3kO5hUnOLgjcwHmVXPtjLx2fIetai53y/RGGNageBMPG7h/seJN13J3YzMMeukokX+HBpMYkPCLlXsJ99o8+gIsXOg/jzdrKNjPA0FmE2qNixGpVKYSOqY0fQnhSUvO2YL8ylnLR8q7AhIXq0asF2AmBkJ6/OEd4HJWX5RGjI6n8B7BJlbt/HaGzbaQvJnJcmXyvJpHylJXl53XaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBBd/RZ/g/kEUUShrS0J+pWhQGkNerJJ2K2cEKh8GN0=;
 b=hpi6M2g3nKKNkEGupCy3cEgGX/K2ClEwLFOJsUx/Ay5OlsuKhjFz2y6kz4jlSit3jNmfyHDstzBs3TbZEjpMvSwkVFGuHnN/1FoUR32w4VnDnQecV5n8zchmR65blTVGJJZzmL39X9RmL48eXxAhI5PgDx8IzvB2l3jFUcRqslHrYl5yQmYRoT357iNedSxQT084jGRsCrA4NaRqfHg9VdjdCwjtABzDp/qE1H6dFQlzrM3igIGWArgGXbeqTrtKcqvGSdciGNvkwLF7KL0Y2Y4Oz764eRUudMqST8oWDm/0ez/hXSWh7t0rSY3wpK7BmoUA684vwrzCEVUrbOU9NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBBd/RZ/g/kEUUShrS0J+pWhQGkNerJJ2K2cEKh8GN0=;
 b=kEBleXsyrulPlyIr7g/tMfFQWd4XfscCGI4g/4eNBAq2gkxY6z4ucm8mbe5AHATb1yNED9MdLFUaeXd7piwrEWwON8IgidAduJpqDJIIOvJtM4iot6JUlb4FB9iNuRJLyrDW6+ZrlUgLXUXLgnG2Mv7TugUE5AMOjh0vD4NHnEM54bxdq4T/nQIwgzohuc+YbVJ1/UVFaSbI0+whHG2Uf7RpjlmeFSvo48+3BV3hD0kjHuQqcBR/FUywvSahSQKGGaWixQTcYxtnfqyN56IWixdH+ukfZnPcQ1I9zYHbcxHdxxaotmOKa5cHuGcXfhQiYtJ7u5Lh8M0LDYI0YSXQOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DS7PR12MB5717.namprd12.prod.outlook.com (2603:10b6:8:70::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Wed, 21 Sep
 2022 23:20:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.018; Wed, 21 Sep 2022
 23:20:31 +0000
Date:   Wed, 21 Sep 2022 20:20:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <YyucNnYlPgj/v6vN@nvidia.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YytbiCx3CxCnP6fr@nvidia.com>
X-ClientProxiedBy: MN2PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:208:c0::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|DS7PR12MB5717:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bed5e7d-3699-45ca-86b9-08da9c27e010
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2f5pQ+VkZg5BsVWm0503eWAbiZttYRIrw7a+aCEXqGhvEsqU8KNZlyYx/2k09KbdSt3NIax7ggcsKRbElwNp3cxBTmIxu5Fn/cLfiOA9/+MPhb0BEEswEX57LvZsUXJJBGvvmFiDhU7znt5FVUo649DCYv26aWLd6jJQNTPeNJMZWPIGtDgbufXBBG5rph/sTr09rvpc0iViju6O0SrImKPDvvV586qmxIC6gt8QJOmgDb6QGxPXMAqtKMUfojt8O+Y0vTcE8Azgyx7/B0b+h8IgDkTYbB+Hfm2JYg14ik9nHaJNm9LZTyh6MjEuaYdG/FP/wZxb44SPyT9sk/0xKw6tMet6+RSnA5cjv+WQydpOY/ZvpUSrbDnvXRX1oMQ2XAeVcCELVbBz2Ftqtouu4get6KvbZBnrsjED8MY1eC5PhjcofgMJeeyFXFFBPHHxSEJtWDnlnlB9PmYYv2I2b6irPuc2nTSIBP/32FkEuFfG1AxNUuJKB5FDqcJNTtgyQIqmQpytgvNDOfNlU/hhV9Z4mei11E0eMLS68bZj3a4yCZNJo9vlH/u3aB/EuhPaIRQZljGeBH/1V3ZEUQfCp4EYRiY+DkOkeBRzyAPB8q1RVJQrIwo9QRKiT4HFK4DnO6blwA5mD2MTfuhYlTe8PXvrUeUiXcBzkwoRVRSEX2VjjJkLOUoVq3WU/ps8pHXzLOZTyLLPR6iVUZxJoz3PmNwpS6SvOAaxEZNIgAV3YxMAzbB5543jjDFs9sYtlZIY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199015)(26005)(6506007)(2616005)(6512007)(478600001)(38100700002)(6486002)(86362001)(5660300002)(7416002)(2906002)(8676002)(36756003)(83380400001)(66476007)(6666004)(316002)(186003)(41300700001)(4326008)(8936002)(66946007)(66556008)(6916009)(54906003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SHfHCaGHglXAPjWPeOL7NgSaTmjGW0f1fB3bnmVUJzW2vfmYTgCM4tI4+g34?=
 =?us-ascii?Q?TVUI/8rYJOb9eOPeHO4Xgn/F3l+GnEf8IWZTwIBdswPMBcZ6IKeRURqdlprc?=
 =?us-ascii?Q?PMnSYoQfUs1WLeDWBZu+7wHpKguOs37Ccubhzg1kpTMeAgp7FhU3ZdaA8i6T?=
 =?us-ascii?Q?1A1ExKYKK9UZ3Q0nL7zniQefo32H5LWUV2PXKI6YNmUCely3Zo3njAHIl05+?=
 =?us-ascii?Q?ioD4cS9wkvF4XkZs/0IHE78mgh4sgE1azsGo5tn+uqt7PlPa329tkiHoWedy?=
 =?us-ascii?Q?Q2x5+cqOyLLNMevGixTTHupO57fJBUo3Oon4IhPL7wyOoJ4BrXsc+P1exrPF?=
 =?us-ascii?Q?LQzjxXwhW4Q7uY9RB0EygR/5gsXM8Sq9KcFeWzDsIJyG+q1vpM0Af/S1Noaj?=
 =?us-ascii?Q?PwSvTujBYV0ijhu4XkDjatJX29n9lKyoLm7DHfIDvPB6PJIjUULUvv2tA+t4?=
 =?us-ascii?Q?aWrlOI34TolJrgdta48YuvJxbS9JuKx5IvOVh5oDEZYS9MdjmMlSGsPu9hlk?=
 =?us-ascii?Q?MUC+q952cZQRBpZPIlsNjbOqeOHv6gIKb5KAwlfDZNjwPl1JNILvvp7H5Dze?=
 =?us-ascii?Q?Nbb2iJa2Nd3b8h3I7UYS9hdKtiTrdnWrq402Ybq8TQcQGzQtDLgb6ltN/wk+?=
 =?us-ascii?Q?TWAvGtt0X6h1kNnmNIZp97/SDA+HKVTly1GCQcn3g4mt/+U3tZEOVnBrbWtE?=
 =?us-ascii?Q?klJNjsrYiwicKwtQ0CMj+vAAeOm1vkKEJY6/WcjyQPT3rOaun8/UwOI9CJNi?=
 =?us-ascii?Q?zIl7X6/0U6S18rn23CJIv0HpnbDRKhEubxAKW0/00qoRO1bNHavcXOftwGr2?=
 =?us-ascii?Q?FfyKYRLkgmkIOYyRdH6XRjxZFRlpRxRhhfh1zjIvNiTByCKj2Wmh5LA++YvO?=
 =?us-ascii?Q?mtJgF/hZMowh8/wKO/RCZnfdxX8/vstsKODPO2KuVbBjMvcMLVdCXFdSHz1u?=
 =?us-ascii?Q?hniZUpehXNObYjrnRrQyhj2pvR30Uv9Nv3QjMWPy6DBCYuCuie+I0O1JFq0J?=
 =?us-ascii?Q?lsS7Gqx/5OvQDCQWOqjSHMapzI73TMdPY4S5Jp1uYzTtDwiMliPEcQCUBBev?=
 =?us-ascii?Q?RmI039VhvRlyOFsxwukWllGBgGXTASy9X/X0f1w/8qkAc4v1SbaBQjtbINgo?=
 =?us-ascii?Q?GvD73hsJLUBdL2csOWF9Gnf1tLw4pfJ2zf2T7hpkz4zLGZQOJg0zQXmDR3U+?=
 =?us-ascii?Q?eURwZc9HzL9pNTqbaLMrGeU/LewTwVfmOFzpL/R4lR8oWVxW36g82D7pkcgw?=
 =?us-ascii?Q?K4CUG4vYUisGWSB0pbtCtDRZYwdQFgd6YG8tED+M3JjrvQtT9Tewyf7jp5kj?=
 =?us-ascii?Q?8Og8RgR2OUdtb9EegHQV16wiAh2EzYINfK4HIM55rwcirKX4tLKoMw0QCWJc?=
 =?us-ascii?Q?NbRvZc+3GCHVBgwNinwnGEvP1kzp8YyIFQKdo3inBnaqkRyVdHxb9mcHtL6o?=
 =?us-ascii?Q?xp/bi5kY6XBd220m+8SjP7x64aDeooFoi/SGSXMf7dQrSTzuORLv4uykL1fS?=
 =?us-ascii?Q?HLQn7MYmygao8xg9jVgDXVrmaTKPsuCmeq1ECp8lwFUt5eo6AB9vIPavfL0a?=
 =?us-ascii?Q?z6jASHkmOWKCaJCUqMQJ+tf9E0Gk7XUU4iN5eujl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bed5e7d-3699-45ca-86b9-08da9c27e010
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 23:20:30.8651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WcHmJF9vqGf+ABBHQGuM4nlke3BHKDqzZLjaDEd8b+f8u4LsiayvAH8fbYh1MfBf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5717
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 03:44:24PM -0300, Jason Gunthorpe wrote:

> If /dev/vfio/vfio is provided by iommufd it may well have to trigger a
> different ulimit tracking - if that is the only sticking point it
> seems minor and should be addressed in some later series that adds
> /dev/vfio/vfio support to iommufd..

And I have come up with a nice idea for this that feels OK

- Add a 'pin accounting compat' flag to struct iommufd_ctx (eg per FD)
  The flag is set to 1 if /dev/vfio/vfio was the cdev that opened the
  ctx
  An IOCTL issued by cap sysadmin can set the flag

- If the flag is set we do not do pin accounting in the user.
  Instead we account for pins in the FD. The single FD cannot pass the
  rlimit.

This nicely emulates the desired behavior from virtualization without
creating all the problems with exec/fork/etc that per-task tracking
has.

Even in iommufd native mode a priviledged virtualization layer can use
the ioctl to enter the old mode and pass the fd to qemu under a shared
user. This should ease migration I guess.

It can still be oversubscribed but it is now limited to the number of
iommufd_ctx's *with devices* that the userspace can create. Since each
device can be attached to only 1 iommufd this is a stronger limit than
the task limit. 1 device given to the qemu will mean a perfect
enforcement. (ignoring that a hostile qemu can still blow past the
rlimit using concurrent rdma or io_uring)

It is a small incremental step - does this suitably address the concern?

Jason
