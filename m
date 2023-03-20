Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD5E6C1468
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 15:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbjCTOKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 10:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbjCTOKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 10:10:05 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDD759C4;
        Mon, 20 Mar 2023 07:10:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDQoolACmBEJtnIFinp/Ul/xTOJj/YrxdPnC+Yr7QgXAWm+lmyF06/flnfz7J/KPbOFZP+J6PvTEoIqFx5a8WmA4P2Hv+YiBdhSdbq5+6nVyLvzG8HgsUclFvZ3kcTy8CDJN23IWNhPIA/uIdYyMMxD/7ly8PsvNtIh3DvTEYL2hnb5WMwqQrmrXGojkW2/R4XYVcfJ9pYj8serQid5JPPXfrv2wcCFDYjHrAnT69IbVrYWLFrP++aQjF16DB17nimb2otEgMvPP5wQ7GHH8PNz+9iHThKEt8zZc0cp1jUfpEUjTbmjM4QjArYfU+/7HXFHbJlXuKzxWlbacdscpIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2VdCG4/ZGlQchCRCP4RQNupoabzADS8RgLRpXRFwm0=;
 b=GkOvCejzIhjsxQx4tUpEvPYk+M54MPPKb2e8EL7/md8xe96iSbUbnBG5W95ggwigyuVygIz+jFFT7ff3X6CYbKFGjQN1n3cbeToINz/9OmMRKV8rb4j2IyxGaSGGo3PkJjVowls3SQGVhboW0WD8pEof3MLhc/2l5q3ypInrkddrTshH1pomDUyip0foIQXTUJzCQP7EQ+hD04EETiycFKZP8S/5jTPk1xVOb1IWbJ2i5002r51SHYla/RN5BJvBjDS8sxkmW6T2xTnbOoYLb1bcEaB1oc5Pk5e2xdkb/Gd3x5NBvL9XinITAJ+84yRRmjbkM+IN+ByYaF4K4DCyQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2VdCG4/ZGlQchCRCP4RQNupoabzADS8RgLRpXRFwm0=;
 b=DRQNr4zzQcWufHkKVy5VcAUowG7m1hM9LHc126lfa6UZZu5I4x65B+8KVdrjSM3E2ohsLPwhNhf71PIXlATyh/+OSoi+Kgc0bqfsZvgjxqSlGNsGIwajLcoUnE0o5dv5y+Vp+zxdhVysmyee2XEiZds8O3t/w19w7B/zi3KvXOS32WCWebjR1Xx54KVf4QmKL+G2QwXg69angW6YKafep1BDSEE4g2XHWwwQ7Z4JPmm7PcW5xJg/sewIhu41hPoecI6x5roNCj3Mw/d+Q2/OrkUJDOZ7eUYNvG7AjyCl/d3v5pkav8ODBCrih00j/IYxJq1gHD7tQH1jhRHIw2EGkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7727.namprd12.prod.outlook.com (2603:10b6:8:135::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 14:10:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 14:10:01 +0000
Date:   Mon, 20 Mar 2023 11:09:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZBhpNyrBr9nm5Ae+@nvidia.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-22-yi.l.liu@intel.com>
 <BN9PR11MB527665CA5753E413CB4291AE8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529B3BFD999C9720836F049C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276684B2C0CD076FA3CD0938CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752922A0C9058583F677369EC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB752922A0C9058583F677369EC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0392.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cf94b8e-66c8-4796-8fa7-08db294ccb53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XzgTGQ231tyTmH1Y/V80QQPBXuKJFFLZwpU6vb4r3zpp5yzfY8e3x9jFbwStg0o/u8Xqe6tpfV20xsDUbhEnHOFItZ7eAW8rNeKt0+9LtTnjSiIk055XtiiVtrZx0tHl00rwt3/BluZkiXc34sc1P1v1mP655zDApiqsymVgXdn4+MgsoQlNX5Ppxbx5MBFvvZamIYsfS1SPeeqNuX0uE39mTu06KiwkeRB6WuF4cfIxA6oe7OoDt9LQl2NM1RuBPBkFJ6nOiHbFLyzx2e3Jt/vnO4d6Gx/nUrurZ/jjS6R6VYqSPkm1IcAe4eSqdJJkWgx5s3UEpiY9OpfWGLYoE35Z+UbNn0FmJVtgqIzP1Jd+4rb4p9aEWnjOCngb+z//js0PDF9jFuukHaXVTnz/dBmhk8QhIgHgZuhZj5HwtJXYeHcXM3ltW4CfzWgI3Domjk68f6WP6w6noT67hkh8UxFYQU/lTODGT0mrwJeVamhzv0uy84Sw8aEuMkeH9EKydN7RUe1jJu1KFV3md4Hi3LBtOC/RchRaeepBAs1TuWzarGGg8CljjCce8O9/5Zz9FfGAPKQKg0HF21vkP7WE0CwG60gOS/wVbwzfWJjOEinceMeDb72DHzMwqpN6CJRN8oSC37+7+F6SPnf3uHE9og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199018)(316002)(54906003)(38100700002)(6916009)(66946007)(8676002)(4326008)(478600001)(66476007)(66556008)(2906002)(6486002)(2616005)(41300700001)(186003)(26005)(86362001)(8936002)(6512007)(6506007)(36756003)(5660300002)(7416002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Shn7IV2Tr0KHY/twrNDKpZWEuMmr7PZ8nQ/kEKNrs0/AKCTklb/6qz/4HDQq?=
 =?us-ascii?Q?1CqEuXNngHXBSEPHS+CPQX3MQD21CDTJHHYS+e6/ojl8/TH7YmuosmIGLQCA?=
 =?us-ascii?Q?FVSB4tVvsKwAfeCkVkTFqBi6z2yxgdcRLQV9nrGpUWnioFig9wBT0BUXqsPI?=
 =?us-ascii?Q?hX/UJlkEzVIYOMzBP4Ht0N6d/qeL7ODdpr86RTPR4bh3+/bn3EHResf5gMFS?=
 =?us-ascii?Q?8RKm0rDTeekoLLU5erAS0j5rMaK9E/ScuY+ldsgWi+hEtjKOcZzSOMoAqjeF?=
 =?us-ascii?Q?+E2Jqb26Ky7CrFV5g56nnCGYTBu9M0+mVqB9pbHATtHIDsDphZBKJFBzWsaq?=
 =?us-ascii?Q?A4/WrfNJDt4JbUAL4PH5VqYRFdCnPkte9oUnT2Rkc/pvizgxs+SUrvfJcXIR?=
 =?us-ascii?Q?L3iw+T5AMLlh1n1H5znY+5bKiLxQj74d5gwNfBHmu8CDwRzNKbv1rX3XqT9N?=
 =?us-ascii?Q?sBwG4PwPNMg03HFUnHo1vGPUzxO5qE3Sleu83DnMHHk7nE4CqLO2F/XaClD9?=
 =?us-ascii?Q?XuVDWcCsI+F9dXFVDAmJsH9Be/qlu1wUQDi0TVHU1DzH43A0Ugatn+YgmN/z?=
 =?us-ascii?Q?3FDsy0LtX9QTlV/DC9YrOt1Dx5kzIGiw2Y6WZezqIGzjWxsh+iRltyzp/LnC?=
 =?us-ascii?Q?1Ns6NoUA0RAyre/MsFMSSsQUE8QTm6dBprh/QErkelUcIy8njMuwcCxHGlzs?=
 =?us-ascii?Q?sQAD4RTKgxs2RkC4FDav1B+qfA0XzioppRSG7OKmZCMI+rQpkTpLxo1nj9SJ?=
 =?us-ascii?Q?WI3xc4wwU4eeAXxopTyD8/gQS4e5kIGm2xDXPuqyRKZ3deBv8KmDqCcVHRZs?=
 =?us-ascii?Q?RnLJGjxWVeZuvGriIVfYbTj7lntKhRHkA0y4/6xN+eTmqLwv1Q2ewC1aj51i?=
 =?us-ascii?Q?ImF3gQUW49x4f5mhtWrXNA2TbL/P3Wr7mFC5PV/XSRiRqwaZzAdwiJyBxOC7?=
 =?us-ascii?Q?i8WVPXGxlG6WDOfLdHQjTldtFIHOaFMwApWJnG7i15jQCUl6j+Kw2JNZzbO7?=
 =?us-ascii?Q?n8eDE2NO57DMC1ifOEqc8V/IX60s86jkThJ6wf3MrQ3EBpDmnHaW6qbGMx2D?=
 =?us-ascii?Q?Yjw7SHGK8GCvo+eYpgjayTCK40vL7jWRLmS94u56j53EgH4EWdzTMVQAb/rq?=
 =?us-ascii?Q?ipF4fiY+FN/2uJx2Mbnm/IyesO6d1DK8GJJz0M5a0D8U/AqfDDU9dMu5AOoP?=
 =?us-ascii?Q?oD2cJAuabfgoXGQAbIT9A/FpHK2NKky2gMZSs1mmmpXN3x+uWDN/FOkKQ4lv?=
 =?us-ascii?Q?dgrMC51jAyBfZRbmPBvVuOTxi1cfTuKyvERHFhMi/zicjnygGJvBaUKfbsq4?=
 =?us-ascii?Q?v2pjkLtAX/KASSnUMKlX61HNK/wKBlx2ZtiCvXRGaK7b8Gzk45UffHAmlUpo?=
 =?us-ascii?Q?qClyLp9bHTNxW8rHBnAx7eZtTb2S1qyK2y2PA+HNiolLEA/XqFZMrh7q7tge?=
 =?us-ascii?Q?ywoR0JTDs69q68rXxx3a/fatBUzbj+97r+XkknCX95uZyAqNhrLaNzOHjPNh?=
 =?us-ascii?Q?SlOb35n4YWQC4d22Ir8EU7c0EEtQOD+waGncewVuU7W44vEzxG/igOSH6dRm?=
 =?us-ascii?Q?72qyi2NKMX2ovbs32r9d1oEvkgwdcDJ5SfBH/f9y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf94b8e-66c8-4796-8fa7-08db294ccb53
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 14:10:01.0123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/LXDlDeJ0V/8b+shtxfwa4k/v8WzTPIngM59w3DeOmpDKL29AInrldkIq8HfVVH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7727
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 04:40:19AM +0000, Liu, Yi L wrote:

> # if IS_ENABLED(CONFIG_VFIO_GROUP)
> static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> {
>         return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
>                vdev->group->type == VFIO_NO_IOMMU;
> }
> #else
> static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> {
>         struct iommu_group *iommu_group;
> 
>         if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
>                 return -EINVAL;
> 
>         iommu_group = iommu_group_get(vdev->dev);
>         if (iommu_group)
>                 iommu_group_put(iommu_group);
>
>         return !iommu_group;

If we don't have VFIO_GROUP then no-iommu is signaled by a NULL
iommu_ctx pointer in the vdev, don't mess with groups

Jason
