Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E8F6A5976
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjB1MwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB1MwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:52:19 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2088.outbound.protection.outlook.com [40.107.100.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9A830283;
        Tue, 28 Feb 2023 04:52:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDBzZcF5fnePBQyvxx5LrLh1zEFJ4EchRcEdD33rSpnnA8GcOpePMuKUJ6NrArg8bkiybcGYkHr0oHwcWm7lovnl2xcHQEaEdtrmin/vO9rgK0+i8YHU/aaMzy7KVGQYY5D9TaEFVwy74exm324o9l+r5F3OevWKJPMw9D0x1bhmgoEKA+OVg9avOcfO8U8W6mv1CbYJ6geRAwd+LfhsRyr2bJrbNG0tDecJDmzMzr28WAjpqTZKSN3Ncpct+So3wzSD8CZsfqi9Eb6fMlYgIV0DRRypEETW5iigU7v3LuAyfsUdkcbmpwXD8iZ9MdCBi5S8GixqnIkXFXur59LU9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2URn/KS4s8xStjeoq3Fg/TqgT0vkir4c1WLB0zohYc=;
 b=UotnPW9PBGPBUX7t4TTKX9eH0o5wGb5lp5MpsnazeMLyYm1AyAuGKjWrZ3u/j5jre3V4ymecSq0KXctEpsdXn92tBHNoFosa18t5bE708iQ2weekk5nTQLR8yNLbUYqPPpopCLevP4fSlL9SJMssOL2W5zHJXc3WinlMXlep4tsYvRaQLxueeRzsJ5rdTwaWqJNxT+ES9WhncnbrmPMggGzmqFD9RfDGuCJaSTfvfgxeKbGtv52hxEbHL6kM0g8k6VO1Qvc/OBwhJIKe1cO2xwHYFFcbrIlPNoi9pHujY4WPGt+53AhUamh5mAD4O/uWmIf63uG3InGPFkV3Caw9HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2URn/KS4s8xStjeoq3Fg/TqgT0vkir4c1WLB0zohYc=;
 b=KPsEY+RfP7GkWoP8DjNSMQ/Rv2WoPga0fiBE8OpMZcvg+ouc7Pp6CqXlR2BTx+ikY/xVX9NJQBkO9kuHow/9k0cGHosPKVVF3uzkEvr2XUJDCIH5qcwqv8380Ss/uChwRUmzBJsKmduMIciAyKAHotUXooz+guAFj17otI9gb5ai5FRZS6iRrw7Pn16b6t+yE2DgRqUEe3obW2qS1yB/o6ZDZAhpzV1MGxM/GTbKOYFTDIq2mgdGrDDj0Bvbn78ZStpf8fUQ8VMdp0eXltV4lLJAM2nHDyMtrOSIxSD/4G/5mBRjFnKcxXYShcQc94+3wbASqeaKaLLdlfjVFIRqAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4148.namprd12.prod.outlook.com (2603:10b6:a03:208::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 12:52:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 12:52:10 +0000
Date:   Tue, 28 Feb 2023 08:52:09 -0400
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
Subject: Re: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from
 userspace
Message-ID: <Y/34+Vr4Mblf1G4i@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-11-yi.l.liu@intel.com>
 <Y/z2mY97uPsCs6Ix@nvidia.com>
 <DS0PR11MB75292E7DCC6FFEBF5B5DF66AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB75298144318DBA9690DC756FC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30CgUSbkpFN20b@nvidia.com>
 <DS0PR11MB75293900EA1FAD0EFD13EA2AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB75293900EA1FAD0EFD13EA2AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:208:335::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4148:EE_
X-MS-Office365-Filtering-Correlation-Id: b8049446-eb6a-4b90-1d31-08db198a9aff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQW7zO+xsioBfnJmChEuaOHQhka52ZV5Qg5+TjneR2V3VnquZ9lyHa9Ik0tr8h2xL4Qb09QMhf4+OpCFsS5SPItkTeIoRHo1143ct8ZqYW9C8AhMBF1ru8fRtSerGRmHVO22jyesa9ixhjkLUvQfj6duAOE1K60XdcnT+flaDHecDv23P56j8g0yVgNinGLfcDhf4txqr74tVU1rD0WXcllI1frFnYhg+p2WLxx1zY9i4BSVg8JG91ZTPPi96GFmYQ6gpGIJ2IIKTnz4nleqVHyOO5Hsld/NpZHsYMzSAK0ohqtAfBUmPQMizSs/GA7rbdLs3P9SA5/ENZyvjZWddpKZCjRNPcrZJpcHKInv2nlR6c4MTVprD8SL+cKRW51U8I5DfYJA7pLEP/xOxk5nIkbtqdsHe4rqfXkzthCqPQSDSbRfy0gfvcmeOafHVdTKMHWSFneclHuMEO0WYYqRVobjS9piNKbgOtCC1Wz92/fdEt372e0Xz4gadH7UUc+79rXZIiNquB0RLcmv2VUX+qDT7J0mbWowJJ/MxKqt43jT0Bf2gB7D5ummm9OuMkcO44AF77uOLEA3dM6Bt92FHqTIVNrtWihZ5kCmkLnKi+t1bEVwodT7E9SNCujzo2OeF6MBADhFeYcrPo1Su6yFmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199018)(86362001)(36756003)(41300700001)(66946007)(66556008)(66476007)(7416002)(8936002)(5660300002)(4326008)(8676002)(2906002)(6916009)(38100700002)(6486002)(478600001)(54906003)(316002)(2616005)(186003)(26005)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5b11t1XIvD/w1TlLNPevoyOLg55ZE5yKu3rc3pfSQuUTZaox+ijGPKWDZC5C?=
 =?us-ascii?Q?LGSIps5MyOLZ/reU3Ewtekhdgg7xrvxy95CP20SLucNwxYU4iQHN1HqH58Yr?=
 =?us-ascii?Q?T9R6V7gB7Dmxmrlrj8qju4J6M4knv1k8XUISkrNHsbvVYlJ9AMksdyQNtm2i?=
 =?us-ascii?Q?HdKEMvgIMfBXb20XgFDkV+u+fefKzkBqmOTNCQ7eUFzU9QJ5TKjsy0r0/rjj?=
 =?us-ascii?Q?IOhUIFzbzjXCb3G4r7RpqsaVzvwJgNN2sPxVij48YSknm6Ngty4QGAr61dgY?=
 =?us-ascii?Q?292VNW0Eu+G1u8Ki5WZ5mGmphHoasaeGqHNNgjdaS4KGnV9bOiO0Bz2V+77U?=
 =?us-ascii?Q?6GKArOxGhkb/FX2l2OqcBiHnAQdTn0N9N/P76M8p9PQkYDNuSRb89Hp/Ws2a?=
 =?us-ascii?Q?gCHKNTttiyFieQf4PAqIm78rAyBXbI48z/rhTjOPgAMQzyxqXp0OvA9odBwq?=
 =?us-ascii?Q?mp8262DZddJO/12fCSfanPjbhEkw1dhSgc1RCCQs3HJbZeC5Q/4SvW7m+Cbu?=
 =?us-ascii?Q?ofrYv6agS6PlHY7crI0dZWhOu06ltFzf4Sn3ehFQXF6cKoetGIRud6M5ktCf?=
 =?us-ascii?Q?2ZonvRiDMERwV1MQ38oQU6DY2LFdvc5Aat0evVk3e4/JxHvBDWVxIYJICiX9?=
 =?us-ascii?Q?VMDfvEYJ6XEab0fYhwecshs8bZ76ngmZFo5yxQ+4tun2YsI7CdX+nu3dPPGb?=
 =?us-ascii?Q?nwI4n7EAA0rcxY/QY6cr7o4515Ajc6lRFoINMxvOoRXpRFtuPyF8CMe5TBkN?=
 =?us-ascii?Q?xPWxJHd8sLOfexIhQX9gUmZ5ypXvLt9LtRf4VjbqCTLQ2yAD5C9pTqn8qOBx?=
 =?us-ascii?Q?hyEu/gYeGHPnQd254fKGMOGLVI7lXPRHih7jZf/0n0/CHt8i3A1kbGfIXEB+?=
 =?us-ascii?Q?H0GZKcf6H5Z7TWznro7RJ0lC3M8Mk2n8nH+G/yi9aM2OBgm3mKuef6nOKomh?=
 =?us-ascii?Q?OIulll5v9ojmH5rN1UWyRgwGEC30AV7PM3nK+5UoC5KuWh+HNg9LCtUqcmXC?=
 =?us-ascii?Q?M+iw4e5mUyeLDzAbo5dH1uVPNoeVEV6i0352cH3R8SChjIbmJnZUyDdnVfJb?=
 =?us-ascii?Q?0tlrKwhMRbeRaQux9y8DG1fS3XsjirTZGjFPTDFg+yWknk3lW3M8JzWKc5re?=
 =?us-ascii?Q?BklYVEUoFjZGqIRjlv2doOxqHl/P7jwAGE/JfeccXo6r58uXmDMD6d05YBzy?=
 =?us-ascii?Q?+G9IfFxkuWXnZJBiGCcaHK7FHEykZLwoGzVIXLEQOcXWiJOsbQQSBfFpNXql?=
 =?us-ascii?Q?2zWYjQRiErkcF+JklARnBWbu4yxca9kBJi+DdEYaVkCr833fLA5Sjm8HJipG?=
 =?us-ascii?Q?GZHlVLzztKUJRN4GHg4g6iabvhAFXdAHcJ+6gc8uaoiPrXBZA1RHk18NEpo5?=
 =?us-ascii?Q?9vIdYUYp8GBqA7IF6TjRwdSSPtTzbwDbUPmPY9MohuDoavKO0IKEoIYLBWQT?=
 =?us-ascii?Q?DpbyvQqdNFznC4Ow/O4/gtHSrPwFbqTULDcQ2EwfDxQJXBPPwP6Xz1jM09bV?=
 =?us-ascii?Q?4YUkPQ0HDGjLuda24LIT8qY1AhYH4VcnFf9AOstsofVK6IdvRxkcW1hO8Ntr?=
 =?us-ascii?Q?vSYuRSJW4Wn37rXINkSS/Q8cjLZFp54qNNoqLlvz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8049446-eb6a-4b90-1d31-08db198a9aff
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 12:52:10.1836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Csz12qRs2hJzpDF9hiCW2VAsBWBL9unPSCNfFOt8a4+Y5fqRl/EIZRBokabGIqA5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4148
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 12:45:47PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 28, 2023 8:31 PM
> > 
> > On Tue, Feb 28, 2023 at 06:58:38AM +0000, Liu, Yi L wrote:
> > 
> > > Seems like pt_id is no more needed in the vfio_iommufd_bind()
> > > since it can get compat_ioas_id in the function itself. Cdev path
> > > never passes a pt_id to vfio_iommufd_bind() as its attach is done
> > > by separate ATTACH ioctl. Can we use the dev_id pointer to indicate
> > > if it needs to get the compat ioas and attach it?
> > 
> > In this case you need to split the group code to also use the two step
> > attach and then the attach will take in the null pt_id.
> 
> This seems to be the current way in this patch. Right? Group code passes
> a pt_id pointer to vfio_iommufd_bind(). While the cdev path just passes
> in a null pt_id pointer. Its attach is done later when user gives pt_id.

I mean actually explicitly call attach and remove the implicit attach
during bind flow entirely.

Jason
