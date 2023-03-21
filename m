Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93816C34E2
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 15:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjCUO6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 10:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjCUO6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 10:58:08 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF4C109;
        Tue, 21 Mar 2023 07:58:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcuQqaWOU0R2lP7ZmTPFFf7GcIhtc1wz2KswXLsD+VgLaKkeA9EvaKRyS3Tg2217idNrcA4XQgB1QiQe0cAdbeJuSLdYOBiRI3GIw9fKf+opAXw+EiHenFRLU43X5Tl5Akyr77RX+ljnh+XOKwpjoppq/LykMH4rrucUq+nLcPuPhdp60hdYK95JIjH6aKhqW6L9wds7IVjYG07JbGlXs0axEQ/gtYPEc1x9cgDDA8utoHcAAieJ1ICq3Rr36Xg28AF3q2WspKX4mtRLxcSEmCxD90DBSQwis1QzlqUa6NyQeKX+EheKjNB07h7r9vqN980UHsr6jbdtywnhSlDpuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WbbX5Pf1GdRVDoSa2mI086PbRzgCLgHCXaaA23M+EcQ=;
 b=AYT5ujQozvD7cl1mOUThnyJiQO+L5BdrkB7LTqEVOHJslGykayi+lVC428gHCLgSqauNAD52c5BkTXvgsw2IRMfah5qQMPOB14wt0MW8BNVX2vNBMTcaOwtjc6ZWxJNpP0SdYMVCiu52LxUaYiJWZDktIyb2CdeGNDKbKsVGN3lSWoXsAb2760ozCmcLMXMzD15ZurDaHmNKOWn1foNB2PcX3LgbuMeGuMmQRAx+RyD+OL1zUQ4sl6/+c7RYo1cbp6i2gtpwMApAgr75eCSHFi6x1wx0tRsJbEQ38w1g2olLxqLhkh+enJKdQnf9Gq1Vl25VYlQ+fK0A0TQbyW0k/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbbX5Pf1GdRVDoSa2mI086PbRzgCLgHCXaaA23M+EcQ=;
 b=Sk4ssPy7z2is2Cva+7Tp5FwCj9gwhaJH8iQxvV88mKzZmUWyCFT+z72ilYsLO4QX0bZQyhjMKMrM6nx3Ka2ruOVELnqgMdJe82wf/BcFee39kt8l8Lw+mr9pFGTw94zxB/P9nR+MMt0/PxTfI/UpMClP9fNPM0I0HwOqQQaklnTQnYUcQttHS+78ipiv0zdqLl7rIRaa0DesahBRDCldrlJRQ/3eIrA+NNUGo+PVqbiNtbN+ZVa9mV9LPaPsw455C+4iVZUBWP1f0y2PG9Ghi867aTui0AyEu9zvN4dW+UkZ+fGLEP0b9NDVqrXcghMacdpdxyphpDHZmjF8r30X5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5875.namprd12.prod.outlook.com (2603:10b6:208:397::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 14:58:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 14:58:04 +0000
Date:   Tue, 21 Mar 2023 11:58:03 -0300
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
Message-ID: <ZBnF+6mestV2tCiQ@nvidia.com>
References: <BN9PR11MB5276684B2C0CD076FA3CD0938CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752922A0C9058583F677369EC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBhpNyrBr9nm5Ae+@nvidia.com>
 <9875e60c-68a7-b360-9d52-66d4915808a0@intel.com>
 <ZBiU8KoSmiM+JkAw@nvidia.com>
 <BN9PR11MB527605E6609222431DFB8AA58C819@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBmcbMuE4lyDIpT6@nvidia.com>
 <DS0PR11MB7529569D40415AA283E1EA55C3819@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBnB/mOIvzYEPdsj@nvidia.com>
 <DS0PR11MB752959B246705258EEC4109AC3819@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB752959B246705258EEC4109AC3819@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:208:160::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5875:EE_
X-MS-Office365-Filtering-Correlation-Id: f93a0498-e01f-4bb2-0e4c-08db2a1cac20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BFgpfacddJwU/l54LnfaQKG6JclAswr38sYIBThHTxZ/JrvWVUfjZRfRYAOTJORpSAUVgcgzQUaEVY8yVabS1TRPJSVpen8/4LUysERHwYSLL0CGQssDn4UPoGRtF0cvoOMCc+a0RxeJweQlxnrw2/IXqF+fPV/yCBLPpqiWbo24xpw7nHswmNG/CXVaOwZD84kyxHLOCgoVISWipkv2B43aiyspdtGhqxK2tASayq1YvptSlLuEn+pLbbyNP3CBrrt69VkIaE3oWA9XKIihlk04UuLAa583AXJ6tSq5MrLl2XbexdsbXhdiLj0oSBlIoKtQ1GagDbgel0e9QunnSWRyeCFT63S9CC6dmgFmMq/PZ1foUQnjQNHI3Bjmtj5PkgGrF1SChU7ZZcztiXbSHCkrQ3sCkBP+/n8+eQMnF3ctmZK4iBSNY7i73itj9+2ZFcuWcnFQ5qADP0elGx++PKWSCLVavMBVpriL3Md1Ltt/Gxnl7Kp96MKZVrXiwCpnM6PsrqLYqiaPZFE7LmWPfe+mo8TV/bUyHjT+P/RWLNrILMDLjUTmngfzX9xpaBzMJkp0hFbziLe/PwxxnYm14n695RwPceZJjqEXH6bpgXWlxpX5W+z+fesXn+WuWxgo7dRwM906B5wv0phFvpFHrFvUrMwZvGH+XsNHPa9l3URauMu26JHQSvdPnASFr1Mq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(451199018)(36756003)(38100700002)(86362001)(6512007)(26005)(41300700001)(66946007)(6506007)(8676002)(6916009)(4326008)(66476007)(66556008)(6486002)(54906003)(478600001)(7416002)(316002)(5660300002)(2906002)(186003)(4744005)(8936002)(2616005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J0ws1SA5xJSOhX8L883Npa4gcoP2WhO7JepfPA7KGV/cICelBg6AQu/TmW/0?=
 =?us-ascii?Q?gJkdw2owoduEiuq93uKVSShTv4GR9BsUVhzK8ARSgKelrWt5hCMyRh2ujbaV?=
 =?us-ascii?Q?J37Fw+YW6s7FFwjZdsUIzZ1RtRy/QxCiEx7pLzTzAqAUiipKiXbvFo9s1Lst?=
 =?us-ascii?Q?enc1853PZSJrue98AF/YNDLpx63JCE4Cn/ZGrz5vMydzHj5IiUWFRJhm1MAJ?=
 =?us-ascii?Q?zBJ6FdTti7FaPtProxoCQLdr27r15G6S5CSb1nvJWsj5Xywd02jIoTI+VFZ2?=
 =?us-ascii?Q?1vBFnV4nw/S9bEm+WEkt1alpaSFGcK0zcScHnosykUBUlmbgiCZV/QmP23zg?=
 =?us-ascii?Q?uBgosXqsS5S+iAZqFHiBroar0dtW/Oh950sD1ywNko2ED2yQGeVVmB9QhTKP?=
 =?us-ascii?Q?yF9eqictocCvTKrgqWEgi5cxYx7uda/1At65VFuHbzlBQzXKyAK/veIllhue?=
 =?us-ascii?Q?/YTRxIABoTcpm+GGOZSLJMcH1QiIJ/mT8TGJ/tLrc0Tl6hacyES/rEWgaRsI?=
 =?us-ascii?Q?J3Hk89W4jnTWvQSpu6sp4wM1tfcRDAbsN0gd+PsdL50N7QU0oq6AxREDw2D8?=
 =?us-ascii?Q?YM5MqC0Bbm6q90cn7JhXr8uJqPQnKCo0HseFgtQEyH+DWeSk08/N24MTVMMV?=
 =?us-ascii?Q?XndRUaskl2SYWLMAsbHTdnRpXA9n8J6mwyE7eFw9qG94zNEJK3sDpeSUph8Z?=
 =?us-ascii?Q?pDrKPNAlrS4B4K+D7fX5DhBL5EirR3j9+XUWSm6jNrWD8EXeQDnSkjdzq3ek?=
 =?us-ascii?Q?8FRa1mVwlsk2pAVDdm2gqhFhoPlfSn/PGWcViRTlZOI02I9ThQHepJpOUsr2?=
 =?us-ascii?Q?LJhMkiMatqzdrZLztVhC6siUxr62eo8dUwzFgeGIpvvN3Mirj57TNtqTG3S7?=
 =?us-ascii?Q?3hSon7isQ4gOj8moYGzIh17g5VUNiy12TRzTMoazCoHc6e2JatZ9u6XKPYnn?=
 =?us-ascii?Q?u2M8vkwsJufD55cGiOU888hRSWBx9mt72CWuNrcdbpgU+qekQVujnFHAD/nr?=
 =?us-ascii?Q?P60ujL0xY+h9gBB3Z8120sCjKFlV9qaFPIBJLPvy35hjCQb4BmeFf6jsCzRF?=
 =?us-ascii?Q?aMKybv8dibUyQMtiJ0kXzeZoFdkj5y3GwxOXVXxOFQa+vvvfiUq8QYogAXfr?=
 =?us-ascii?Q?j6VVFIGjJtKN7keu7RDRkpSNjEEtnE0ZzTXHzJDCuRv9PeIjkWpw32jxvD4m?=
 =?us-ascii?Q?e1cCoAkP+4Wgu/kc6lVtu58Ilbjy4dkiwww/pX4yIkERNHsAsE0pdmnDF22/?=
 =?us-ascii?Q?u9h2wrdsEP8PAzTcfvjIPIBCA6QJRpZIKHo+007qAr7eeI6V2AEXx8xF6knt?=
 =?us-ascii?Q?1SFVEwqn9Xk1jsJUSYfF9l2ZaEfvU27Yqc761lVdghN/5BNwD1GU/JfwnHYL?=
 =?us-ascii?Q?L6MH9xOzOtOAkXoJp3P5ueFYaK32Kn29pDrEhL9AFokdvzdYnEJKCme13sng?=
 =?us-ascii?Q?Zn68/cu/+zdcBsl4kgF7ySe49wL/c8O8Cci5Mkjf+mwl0ALCuG+X2LkjdQTv?=
 =?us-ascii?Q?tsm+G90VsazYJm92K4R4ganMVv5RkP1exqmXaweLyjG1cfsBNTSA/HHCfyaY?=
 =?us-ascii?Q?cIZIcvU+myCxhSpTPqXSYK6hYl52k8blLXfiLVrH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f93a0498-e01f-4bb2-0e4c-08db2a1cac20
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 14:58:04.1272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yp+uzMmEb+quCNkpxNyGGWxPpgerQ0/3W0XalNQQ4RbduKE4otX2IdoqOpLOJSc9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5875
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 02:51:20PM +0000, Liu, Yi L wrote:
> > But still, this check should be done at device creation time just like
> > in group mode, not during each attach call.
> 
> Seems like requiring a noiommu_capable flag in vfio_device. We
> set this flag only when the vfio_group->type==VFIO_NO_IOMMU
> or no real iommu_group (for the case in which vfio group code is
> compiled out). Perhaps the below check should be added as well.
> Then in the time of bind, just check the noiommu_capable flag
> and capable(CAP_SYS_RAWIO).
> 
> if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)

Yes, and also only for physical devices

Jason
