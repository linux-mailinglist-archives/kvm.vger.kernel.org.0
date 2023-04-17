Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87516E4AC6
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 16:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjDQOGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 10:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjDQOGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 10:06:08 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E5576A3;
        Mon, 17 Apr 2023 07:05:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E3OSdnYycFvlkjlrGikfIQ407CH/4eROyN85itALEJOVSk2EuSyZfgbhypDoxyGfoEiugSTRsiDaFm5vrKkeprFfCsaOu2BSAtFd0bQNYzU7GW7Bgmew56wqiDjSRTQbK2zToa9AuYEiq8n6/20L++TdJvGlfdKYWRQXwlrDwl1/+D6gkqAzfZQRgCgf4gqtkAAyW1Fxu5H1y0hQkUgMG/OmDdjdMFsrboRxbFYIXFikj6yD4bZjYQQBR997GR4bQ5GY2eWwkWx+ivWC3xjJa83wYH9EE9rGNRTmNVr1fdA4qdgLwnPd4GwL6wVVfjRJcmhexZX5in1c4Th9sT+Oeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eaOujoy9GiOjbGc4gNIvB35Mqs0EHO8/SlZkUunU2TY=;
 b=e1jldd3c8wEwt+bSzvRHEA27s792RsWGCvnkHMknzH02hifSJB+/npXmmULONqXc4PJrA3y/hR5kyqMz3iVmXf8I91WqrwfAD0GB+JmokYkdnlkoSD7H0CcSBnouryhj0+7pnp4QddYs/M8g0AD4yfiFyIn3ZkTCkcHHnzny9ooLlIWxgOANQvmRqgAPQT9mNygqlR45eEJdZuIWt4nd7Fsg+LPl6+Z26QrUIJxjyRIInDyayXCF3iJGKX2AuuC0knnBF9q+OXpEh1+fzeHd5XOrsNxFrOJ5fDI3WRSrN1kz3YKCQED/dmn2M1yRNuCeyN73LC64cY3FE+Dt8iEVqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaOujoy9GiOjbGc4gNIvB35Mqs0EHO8/SlZkUunU2TY=;
 b=kCSvqdyTTuuDYQKs+JBAbLJS73Tw9Ruyh7+5Zeg00bhnj/yDFARPAGBAp28nlf5ESrt7dfxOB6xRpCYwp+P7AZrYb72mPqtz2mm72zhbZp30ybdZlbp3wlhV1xxNVcpfDxN28S9kIKIcQWwkQ0EL8KiBiM3nNi8E8VQRL5o8yyqGIAs+dwS52XO2BweScV6aAaMJO5CqTs/e3cyxX0pRthCs0Uq06eYucE/madbd7B3UG50rB6d7p6uF3xO7L/vKP7QPzaG0RuzNLCT3STtNJB1VCgQv73cfHY3iDDMZiSoVkouCu2isrtuotsIoVdR5xCNC9o9Bnaa3mTn/yA2xfA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB6708.namprd12.prod.outlook.com (2603:10b6:303:1ed::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 14:05:23 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 14:05:23 +0000
Date:   Mon, 17 Apr 2023 11:05:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZD1SH8/bpcytlp+E@nvidia.com>
References: <20230411095417.240bac39.alex.williamson@redhat.com>
 <20230411111117.0766ad52.alex.williamson@redhat.com>
 <ZDWph7g0hcbJHU1B@nvidia.com>
 <20230411155827.3489400a.alex.williamson@redhat.com>
 <ZDX0wtcvZuS4uxmG@nvidia.com>
 <20230412105045.79adc83d.alex.williamson@redhat.com>
 <ZDcPTTPlni/Mi6p3@nvidia.com>
 <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZDfslVwqk6JtPpyD@nvidia.com>
 <20230413120712.3b9bf42d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413120712.3b9bf42d.alex.williamson@redhat.com>
X-ClientProxiedBy: BYAPR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::48) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB6708:EE_
X-MS-Office365-Filtering-Correlation-Id: 414b1ed4-af11-47dd-f8af-08db3f4cc8cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n4ObFVROTlUhXtkcky32cgS9a6BL1ENhzzveLXu/sKxWdzHGtmBsuNdF+7XyGNBjl9tc0ruE4wkrnaFAzZSlOK81MpL00TlDREMarDd37HiTwaJ4dJV2kK0389j3u2WnfgAXedmmf9opjZKT5iWxQw6+O9cYM4KxYtwmqsKofRbc+g8bbvjkSfS5yzs7KSjQI2qatAEI1tPNFhb1Ix3X5VTazH1JtY8tydiox9Z3GCVcyU57LQeatczxF4DczOOQ2mcrXUOa8HlkmXqsWs6oC2RAYCz1zG6faWaVzg4H2F8ivl0ymLh+D2DYjkZmwvy5CEIHlfiCBUL0HXxJIXiLMrEbfes+4WKra+0LHz+bPCsIWkiIhJ7bKoSwj5ZZYIWfzLi9/sA1gthXIRZ9KWw0EuJiMaQL9cHIiA2UqqHDGxQUDAHYVWz4DR0RwcglfyJG4sXcICJ15JeeWt3+PxFmyZ8sf28VfpIEXWbAIfx9Tbv+FmOj5kcTHK13bJc8ZIwNqoQCUaPvzpcqHmHvSlAr45ljdN2qJFJAqJke7AtI0mEnGjHYbBqAMdlMXqge1sVZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199021)(36756003)(6916009)(54906003)(4326008)(316002)(66556008)(66946007)(66476007)(6486002)(478600001)(6666004)(5660300002)(8936002)(8676002)(41300700001)(7416002)(2906002)(86362001)(38100700002)(2616005)(26005)(6512007)(6506007)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Wiplzo2qJTqs11FXYkVsX4TDIsSH2SGHpmtG40f5bbmLx1tEDt3YWShwQCu?=
 =?us-ascii?Q?bpowlONaRg8XvqDHpgEmgPOhRalmwJhOYCCdf4deQRbgnG0DP+yDbBGAGMDA?=
 =?us-ascii?Q?YEC2Lq89G3IIf48oS/46YUjHTY/rp0f1FUIusP3T4hfJfsPL7fE6Jh11zqAK?=
 =?us-ascii?Q?6q4LYMZU43LfPC7U3jzU6DqFGsHRzMbLtwire7hvG8TxoLOj5LmOIUe/aas1?=
 =?us-ascii?Q?iue2FeZdikDRb2dfjwici9L64uNtOJ8tQP3NmCN8aBnaJmjhTC0w1FMo/BS3?=
 =?us-ascii?Q?ZsgZ2YrzA9RDacbwzoK/dtd1VxJL8SlGmiHPo2uvcFPAOKbHhyL8uE7sClIg?=
 =?us-ascii?Q?6t64L9Vaunhoa7GjSfsjgvXhR3C+YOctzIaoIYySR31m1YNeFqy7GKhSDYJN?=
 =?us-ascii?Q?3USrIL8pHuLDAy7JfVUTdgoBo9V0jWVB32Re/zRiemzBSkIB1vKp1PKIoZeR?=
 =?us-ascii?Q?2IT3qNG+E8uFoIfQU+Tvbbljs5sM/61Z+yNg7MCoPqqj7nkP0RWH1GTCmCl+?=
 =?us-ascii?Q?Iir23IXPW1T7b1J5jL+eqrKUnxYQoTmvLOKSRWMQsa/OLwi0X74hGuGyjb9D?=
 =?us-ascii?Q?5e21GTUb8Fa0o7f6BDpAJMk5sZPmXoL/SmaQ5R0uug/1x7aPsbl2Z2MrPvXJ?=
 =?us-ascii?Q?es5Qvw4NoHMSeC2KuwnEyA71gpeldlsSgs4a3DyHT4ukStym7oNSzcEZWjix?=
 =?us-ascii?Q?X6MKp6cza4T95vZJx3TrjpJ6Himn1LnD/N9j8TM8aC10TijGbuQtWxd8Ut2X?=
 =?us-ascii?Q?Y6+U4EFOfUA5hlMyyWKTG/gza+WziiP/bDd+1G9fcqr+bCEis4UXe6H76ZLA?=
 =?us-ascii?Q?JZYazBJ+I4saoQEXC3Bov/gXZwxHEjZbotrh5QJl3p9WkGMwX6SP7KK0EkEn?=
 =?us-ascii?Q?WZTLVOgTcML8IE9WTXZ47CLdBKkfgp4hBiYv54pCERD/0klje8ECi24qa8up?=
 =?us-ascii?Q?jCk5jcI6HMlETtqvLeVzNJ7xU5l1w2tVGm4kNs+8Wp5IWv3370koKzlUUUVx?=
 =?us-ascii?Q?msBJrDuOv+RZ/GWtcaJV24erccg3bnNZANerc+a2RSmddA0Qspx3I0CqpXF/?=
 =?us-ascii?Q?0lpmznkr8NU1rGzICz35+FTWudF9l/5in1N2pVnYqielY/Vqv6U6ZUZtXKxm?=
 =?us-ascii?Q?rkvSNztBq7hwDfJ2CO3pSdl3viub4NFHHjdodMzbV8bezBAVOi3Nl4iWC4+Q?=
 =?us-ascii?Q?VZ0Z0uu00UHNmWfw0/5w7GYu2Nd+FlGVFi5z/WTL7aBxMMB2YwT08hQHWXaJ?=
 =?us-ascii?Q?1/2/MJsEVl4RdUD25TfM5od4Q3GhAazhQx/K2H+LNl5M2O2MvrUqkkxWRbKy?=
 =?us-ascii?Q?TDlPs3Jn1srCUqnjt20M/Jz6kwbe+rpN3VDnEjA1XAu9QmJtRmOxXqLSNy7F?=
 =?us-ascii?Q?2ztCr8yHV/vLmeLVx9V+t6q9GrOM2TBYZlh93/YWAtaT6caOPonT4EdRIEhm?=
 =?us-ascii?Q?7OT/rOEfsOjDvVMVKUOO5gJyHLMi8lNvNMYwHL7W2FgOoB4fVI7xIboAgHCD?=
 =?us-ascii?Q?yQ6BCEo+JxKTT9b8ell+pk3wW9C0HQsXrG/mW2FNorKsUlCN7wkvUAn6AOnY?=
 =?us-ascii?Q?VgvB0HMr4hhIddas3D8Ep98X09DZAixDFFjled9M?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 414b1ed4-af11-47dd-f8af-08db3f4cc8cd
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 14:05:23.3120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZtLoIT3c2IVS8RVzP0m0yG+T1HMNNFOwHptGV4XH61wN1eytzH/Vk47Y9RGci5vI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6708
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023 at 12:07:12PM -0600, Alex Williamson wrote:

> IIUC, the semantics we're proposing is that an INFO2 ioctl would return
> success or failure indicating whether the user has sufficient ownership
> of the affected devices, 

Or a flag, but yes

> and in the success case returns an array of
> affected dev-ids within the user's iommufd_ctx.  Unopened, affected
> devices, are not reported via INFO2, and unopened, affected devices
> outside the user's scope of ownership (ie. outside the owned IOMMU
> group) will generate a failure condition.

Yes

> As for the INFO ioctl, it's described as unchanged, which does raise
> the question of what is reported for IOMMU groups and how does the
> value there coherently relate to anything else in the cdev-exclusive
> vfio API...

For cdev mode the value of the group_id has no functional
purpose. INFO has no functional purpose beyond debugging. The cdev
enabled userspace should print the BDFs from the INFO in a debug
message and ignore the group_id.

Kernel will still fill the group_id using the iommu_get_group() stuff,
and set -1 for no-iommu.

> We had already iterated a proposal where the group-id is replaced with
> a dev-id in the existing ioctl and a flag indicates when the return
> value is a dev-id vs group-id.  This had a gap that userspace cannot
> determine if a reset is available given this information since un-owned
> devices report an invalid dev-id and userspace can't know if it has
> implicit ownership.

IIRC, yes.

> It seems cleaner to me though that we would could still re-use INFO in
> a similar way, simply defining a new flag bit which is valid only in
> the case of returning dev-ids and indicates if the reset is
> available.

Yes, it could be done like this as well. INFO2 is more a discussion
object, how we encode it in the uAPI matters a lot less. The point is
that INFO2, as an idea, returns information that no other existing API
returns: the "ownership passed flag" and "dev_id list"

Then as I said in the other mail we roll no-iommu into an iommufd_ctx
object and just follow the design that userspace must have a single
iommufd_ctx containing all the devices to use the hot reset feature.

Jason
