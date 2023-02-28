Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6616A590C
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjB1MbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB1MbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:31:11 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA282DE62;
        Tue, 28 Feb 2023 04:31:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jcCUbvn5VNMzlVSRZKtu2zBPPVPNU8xp+Nkc/bJeEv9uptfb92F0g8K/YaA5ZChAAqdq8roXaJc7/dKjkLsfxEqa0/cMeo7mBk9oYVelAbIYsUPXtCF/yhV06EJtpC/JAtrQz86oPrq2zBxxspS3IrhxZZs6c9K2/KDjCnL6ARchC2c04U/rlbyBLdeYp6KWKG5Dk/TIkWsXapT3zj2B5m6lfYTFm6StO0uBuEdPat9WihIOjJ9ZfQ8x4hcpwvwssNrVhb7QMGlNrZV7tLxrVRVZncoePMvAX35o4Q2KTkE2gqpl36jprTCu5B8lqhMZNT5qmldlZbOD1EKylnR91A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L+dqDfWFj3VdY8cU5U7FRCqbULraCxgVtJ/LqY4y3Do=;
 b=Fz6ADCFvnpXIAh3N8AHnCpBSO54dNREj8ggsZAN+aFU+ZAMA5GnL035Bk+0rKPwg9x6zx9mdLEKqWJgNweBAMee9CUf2hCHNVndeSBL7OLCfdm7pfOZbAJMrw2sBSX1DqadvgW43mpNWD1IGsWRhxlaymE7wpgkY+6FEdkEdVRqU//OZSpXNfspfKhcXdtMmzyyLrjzAE4xbx9UG7+PEU9muUSFTw2sRBqpRKMt42Im1T9kC/kQecu/loCzuKQ2u+KABon0OFjtX/dt1Rqu/u85RbIJY+Qs/ZLbgy9IJj0hg6zi3HWxydPO7yUw7kBO55tHwkYKafpJAhTXdaNExaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+dqDfWFj3VdY8cU5U7FRCqbULraCxgVtJ/LqY4y3Do=;
 b=GHBejPrUEXSW4yGwjz6RakXRLWxPsm+GNj9Tu041TSJ08PlwjrqCBZkkvXslSF/CFo6BeCTXVSPln8IXBSrfTiGqKYHbNDnrEpjUOMWdnrBTjDKXNXIQ8qAORt79p3WYiVFZIytA3riKhxZ6jWX37oxMuycZjwiwWQ4NJ4MviPHgL8BlaSlfSjwne7GrdVlTsoNKfHQo1l/3LuIohuvhFO5gcJNKEMEy5m9GFHraBBqw1i7Ww7S6hgc8KYZxwkoh43koVNPe40HdaCFhJKMIISQxU9RlFmaWhSPRfEaw/NmF0ZbhrTbfJubunKNdY90xzNQ2tZRGCJmuF2VKSgHjkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5069.namprd12.prod.outlook.com (2603:10b6:5:388::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 12:31:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 12:31:07 +0000
Date:   Tue, 28 Feb 2023 08:31:06 -0400
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
Message-ID: <Y/30CgUSbkpFN20b@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-11-yi.l.liu@intel.com>
 <Y/z2mY97uPsCs6Ix@nvidia.com>
 <DS0PR11MB75292E7DCC6FFEBF5B5DF66AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB75298144318DBA9690DC756FC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB75298144318DBA9690DC756FC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR15CA0003.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5069:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e056f55-9602-465d-cefc-08db1987aa65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cpGw7c8AROUC5CIx4o6smVGF0/aqxDwRbS744wNAOCpkuV0jVJGIz7k+u6k3PCgaQ6TUPdjebShNhpo37SN6udXmyRzhfLUSxBCfmv0je4/UjkH0UVeOVZu18IMteloXHGwc9QTjKVdoiTWJFcE48Lc3grgQewTj2EG+ZdHXnLi7KU+k+sS9EGQ+9eyG4/Il0HKpTcZyutuCMxHBmEhQIE4KKU87IDdcRSWNKc3keUHJsy3lxsv7qv9tnsZV9e0NuJ7h4RH2/Hajy701Hwx6cJMXeWmQ2p0klTtHqBiOHfe7qSFUQIOSyfuR0nHSNFhRlSuYKHQhgvN/NX1a/g5d47SR1VMfjiZUhE8H1OWVE+I/Qvnq7/Y6jDahUYZ7f0FU58uyJLcTmC8PFn58QrhrEIcwJXkHCGvHdjHuEsqvY+QlO8EAaMN4iQCYPpta/KqQOCkJFYHvzRJzA/byB1d0/098eBwmoqjjuI/N+50SaWVohRkxTKgRsVBRmTV0/CL/zXiIijnBra2WPV/YsgY/zpyPO3t07UmORHvA87toFvskv223nIsTq6t3YjNLIkcfKZ81FsiH+QPYqvQ83VrmKgGQ4u07eRvFdANVVVmXZc2dTPXJ4tuCalvnH27TxdVRQbDgD1EEnpLGBTEUeEf8mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199018)(38100700002)(86362001)(36756003)(2906002)(4744005)(66476007)(7416002)(8676002)(6916009)(66556008)(4326008)(8936002)(66946007)(41300700001)(5660300002)(2616005)(26005)(6506007)(6512007)(186003)(54906003)(316002)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oh7NDfr+rL9XvPU+ab3QgkwXB8ccDX8n3XtYkeRkHM85wJt7Qwcn+iDsQwka?=
 =?us-ascii?Q?/94B/zxMQlFfAy4+v8lk9edWzpYcc+Rv9yKX8sTZSkVc/bGfKdJr43PxgQqm?=
 =?us-ascii?Q?GupWVX+Xc88Ij0LZ7X9EEdeURNjMUlLbKaiQRZGRu2iciJND2kz5YhgWMBmJ?=
 =?us-ascii?Q?96al6fsWFd0iqixqMGZdHsOirOAyMcSoPiSNrUqfvjItY5bc1qmRjOUkfW3M?=
 =?us-ascii?Q?KihfVPAGJJxloVQpTiFmcAgwK2KqtX7rfBsjTyMukJlMTHTZHuDNc+OxudgF?=
 =?us-ascii?Q?ECvpeY8WKqT6kIR+9AWwrWifWosJceyaJvRlF0vyqKCUQGQYx9y4hWRHIeLU?=
 =?us-ascii?Q?8gfmwzaYcSPib2kOGCSmOy/y6zjEhP/HravBc3u/8f3+1AE5IJCBRx6Aepiu?=
 =?us-ascii?Q?XzjvFA4zhiSRRjrWF2vkNMnhj20SEf3c2AezSmcERwSCrxmJJW4gRBBjSsJz?=
 =?us-ascii?Q?Y8Ht40mpEo2PJyPtdWnlhWJomOqetEGcVFT1FsxiGqT9sK1fI+8Mq/lgbWQw?=
 =?us-ascii?Q?Jyy1rEi9lQ0wDntcVREWEU5uU1Jmxw/mnK/ybjx77Ysvi61FpX6aB/SRqFkT?=
 =?us-ascii?Q?O8GJ9U+ddFzJjS6EUpXbPJ8RyfRFA4jFttYZmGLRCLdz778k13Yzgfx7+cgq?=
 =?us-ascii?Q?Kzvc3v4eA4LCI40AMrkjAGqppQGZ5yQXZL8X/AD3Ilztk7JecObq1Ogl5hR8?=
 =?us-ascii?Q?QBVBkmXvO/hPMHwBUomRxpg1lndn0hStsyiQp43E9KsETxj6mVcpnJaXOtsM?=
 =?us-ascii?Q?EGdhEH2QEtg0730C/ejBEr5MYNi4x14E7HYrZ5XbU5R49m6oOQMnrTdkNZyD?=
 =?us-ascii?Q?sWgvGibD6EeEKYVMQ66xkTBM10O+CtIIH+ckOSD7wOMGdpVGHcJRcS9izIEJ?=
 =?us-ascii?Q?Omg1Mxjcbk/e8ueGKONVfQ0sJjjnf9r0E4Ztsaqg4jSaMISzBQfTqJpzrjOq?=
 =?us-ascii?Q?3C4MqCaW6NdiTzayeY1AGo/bze5RWxd8uOYKArJKEDkQIL9w6oAI0ZNwUL7A?=
 =?us-ascii?Q?zhFvVhHfXPSiDlMOldbtSKTLw0C8lgHFuHdzkSsYmCybtdBm6b06SSvnBWkv?=
 =?us-ascii?Q?kA5WLHS+FDe6E8FzBaMeIdmHIpre1BsvkrYnA5BbUBIWJ3wNqXfHkLWjdcro?=
 =?us-ascii?Q?Sj6VLpL5egc4N9e/b/9SYNKXlDSR4VcfIUtUTXTUPZD0gmDZaVvyOfhgmYdH?=
 =?us-ascii?Q?pngrAsxn53d9HQVUhQ3jQVrF8hb5XjywMh2XLrLqm++OhTuLwJixPI+1H+z6?=
 =?us-ascii?Q?IvA9FxrArcaHzKotEOGXJdO7VXbGHRvSHL3ag7DKYKa2RnabDXmqhSSukbln?=
 =?us-ascii?Q?02KYhmKziAKnwKTt9bhMgRvd8vGnTZJRnIBXxXqLlu65ixRLHNu/i9djsply?=
 =?us-ascii?Q?TbS9cnOfKM6PnLHwyRYwx7FYU7K/EjMu8s0DKWSQITCwKijpBc8mU/rdSnGI?=
 =?us-ascii?Q?+WX4NABTbfYr1Nn7u9/HWDwjghewVeP3d1jrtLqHYqDVLQ70sJAI1BrIjn8+?=
 =?us-ascii?Q?rqcTvxm5gKUfnP/KCVLiAUlnjViHxQ21V1i/iZT5s6X88m/Pbfe2B1j2taVn?=
 =?us-ascii?Q?EDdoHWsHW0ZVxTSks0gVmRfRjN7WkTIUcoob087T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e056f55-9602-465d-cefc-08db1987aa65
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 12:31:07.5791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vajeDfIeEAYjj5hUBP+xVWAfervrcYkrf8S6ASaudUCippi5D/lB36pdj4Q6dY/h
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

On Tue, Feb 28, 2023 at 06:58:38AM +0000, Liu, Yi L wrote:

> Seems like pt_id is no more needed in the vfio_iommufd_bind()
> since it can get compat_ioas_id in the function itself. Cdev path
> never passes a pt_id to vfio_iommufd_bind() as its attach is done
> by separate ATTACH ioctl. Can we use the dev_id pointer to indicate
> if it needs to get the compat ioas and attach it?

In this case you need to split the group code to also use the two step
attach and then the attach will take in the null pt_id.

Jason
