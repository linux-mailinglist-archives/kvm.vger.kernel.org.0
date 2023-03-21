Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661686C3DA8
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 23:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjCUWUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 18:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjCUWUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 18:20:44 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86822365F;
        Tue, 21 Mar 2023 15:20:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMu+be4E2cezzlW3xQG/kuHFg8aONlYtv/LbZYtXKCd4+/90pu0wOnRcsNzJcXxARU42F7u68kf/cJ+l069dWtblSSCwoFSdcmwX7B3anCefP5GWeK5AfrgcKI26D8g3Oe4HTo3l6cfkvHQL8ysdQ2BHiJqkBE4Ywtxnqlttyt+saEgIcpDn9PQyMwW7CIlTbBrphI1RoZ28RFTF6nmC8QLJfUF86SG86RlWzQgrANLxyZUPf0AKnGr6FntJCuIRQz1OCcFyLefaAeRHHq7nmz3nZJWPVc56TVqQ95yGhHv62TtBAMllsJKABhYoddZOnMapkz7j4/BxBbb8BNdkdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ky09bLiIGYgg+uU8sChMH79b26Y8kq8au11+px232O0=;
 b=Hsrzb1+3CC/eSD4Dndv0Gi4/cq1g7KI8cEeAPuQwDv2gWz31i0lbmhgkmFnt4EXJHuLjQRSPtwQKekN8fwIx6aXXSsEcgiLfgSqJhhlCnMhO9KmifkDkkT0gzeiICWIPU0r2Cl6kR/TxdBll347sgOa3Q9eN467tDHVw+3kerSLdBeoqztiJJHaPpRDkC+2nQdOODJj4X0wZ5ygr7Yp3gCMRJ4g+TfombuwPM8NwBzPM28BSI/keRAzyj3wdOKkxgTtukjpxyIfvtJZXr8AWdKABoDtK0CgvewCwKTmPjI1GMkjMi0mGPoUMjD+QUaeDOyPNO2NWhPJnRA9jjcyKKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ky09bLiIGYgg+uU8sChMH79b26Y8kq8au11+px232O0=;
 b=B45kNG4jPabcOmssHJq1+HjJ0X5drJk5xqD5J1p57+WTo9oTmUisMqaUqrPQ00RMSlNxt/ADiaGrKT7Jx5wFj0Y5AGaA3KvIfp77h2gb9ZrTKL2/s6ygUg56BzUxSFy6PUEZzN/2WivNjk1/8ejH1KhMpfvAd4/fybwIktjXKo15B5nX9FKrlrzvKzIaDf0KyDCq3oGunPGOEpeR1t1bVhggKDXce41KVdV68PodX/1MBCj2q0DtXt0q77ZLhY+DAByHSeGkuGCKyfva0XkNYSZhREZ+oyg7mX4Rn1cnWecA0q4AqIc0FSKKzH1U9EHWD6hYDzJ1oga+eFRLFpuQRw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6329.namprd12.prod.outlook.com (2603:10b6:208:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 22:20:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 22:20:38 +0000
Date:   Tue, 21 Mar 2023 19:20:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZBottXxBlOsXmnmX@nvidia.com>
References: <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230316182256.6659bbbd.alex.williamson@redhat.com>
 <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230317091557.196638a6.alex.williamson@redhat.com>
 <ZBiUiEC8Xj9sOphr@nvidia.com>
 <20230320165217.5b1019a4.alex.williamson@redhat.com>
 <ZBjum1wQ1L2AIfhB@nvidia.com>
 <20230321143122.632f7e63.alex.williamson@redhat.com>
 <ZBoYgNq60eDpV9Un@nvidia.com>
 <20230321150112.1c482380.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321150112.1c482380.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:208:256::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6329:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aaa27ef-af1b-4116-bcca-08db2a5a7fe8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s1pZlzhcj9hlUqUbP6YwA5FJ/lYIyXlDQB7lNaqKokfikYW/vX4w5yD1RsnXCYLfNLNKcrSPF2GdB0bwHcyAPC/H6H/TItWQFYowM8YBHSyLM5easlvawRNq62k7x6v+PzYb/nIM5sXjUoCpklKBdHiiXrpJJyzBWRCG3Y6z0ARZxlvdJ4kSJo1yN3qlxsVleEAFYJF63wneWkua9knFGpJNbsqCrB4xxtSYb4WrsjPdtaskVSlrTfX0tDe9v8jFHfHCb5JOn135uLal6rKrLckqEWvYwxat8gNQzsqeC9IkHIAJQuTbmro1QZ7IsTJijIXmu8i4sRq5fQ7pPPxC/YVOgd/qFrGiw5CBjY/VU3x1URD4m3TdM+kojET8B1z8KmA126sv0UIXnM9/n/7NoATpczvm9Pzn98bPho8eMXwMwrQvgav3bzFb+lHUn5rpAR/YYk42MeDpb3M1yasfBAM/9OPgf95vX/B353W0+s7h7WKddXSJjycxw/p14SoVOo4GsweomNGFlEKklB5oK+T7BsQKQoYaTBh178kw6IDiK3cMO579yj3BEcQjpLeRFK3gTXtI9ykCRzwYFS7Nw676JCI4egVLJHRJCz/wUmK8h3OppBVHKlSgjyWp06C9MXQ61G3X+Koz52HO61LO5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199018)(8936002)(4744005)(41300700001)(7416002)(5660300002)(36756003)(86362001)(4326008)(38100700002)(2906002)(54906003)(6506007)(83380400001)(6512007)(478600001)(186003)(26005)(6486002)(8676002)(66476007)(66556008)(6916009)(66946007)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BYZnLJVUNtHKNs76ZMjzuI+Cs5fE8VhJsb6mDoY5avNOtYbx+DiMYarW2OFO?=
 =?us-ascii?Q?O05J15+z7hTmqJKMQ7uBKViOW7xvh5oVDUI26w3JQvcoRCOnlWBKb3MCToiD?=
 =?us-ascii?Q?uSuqEx8U9whifOg+Lt0CigJCJDYYSY5vdQNlUmYADTFCKiWy6LnepzLnRNXv?=
 =?us-ascii?Q?v3EpMq0/syzG3H6DcLL9w0+nRyqrfK4Fy6uMuJEB/3Rd/JsDiElyaT6boYXn?=
 =?us-ascii?Q?cZELdrlkMgIKDPfxhCER+9i8WmQOT2XTd41wzEotqbqY8VDOKAFyInO5MIM3?=
 =?us-ascii?Q?B4HT/4xWbvWABZ1sJMZw3jmPY+d47d6yJvz99o1PpQHMphVqbc2aIlRbF65G?=
 =?us-ascii?Q?TiZlb5R2zRsoHKeCSgWmMq1d9bDTENzlL8d/jjJT6+FqhfWjDYojq5nYPt2C?=
 =?us-ascii?Q?v1/kLKgm4vN1nLmCkgsI0ifRj4YWPGK8Dhor8A8N0LhDjsuWjXaLRGPPt3Fv?=
 =?us-ascii?Q?rvokAnRQ7hgQ4hF70qcgS6UklEofvQ1NDgv165up51CUzBxEhDPKAXT5znLI?=
 =?us-ascii?Q?O6tAAmf2buUdpI51iJLxCB6j4l8yvSPYBLkx4rZWwLAr5nZk6av50rohrlaV?=
 =?us-ascii?Q?+oNCpcaFIH6lg33G9K89NoTH1g/VSCpLKpiPfsFc9dOfvasy9w5mK0YqQcsL?=
 =?us-ascii?Q?b6CbZ41rHc7TibkbzQajYPJGOddP05Pp2hVqNSGsKbYHCzgGxyeCbuU7nYOO?=
 =?us-ascii?Q?LwOKs8UkyExiylK/+gGFI/9El24gUrEIsHLSKcdmQeumX0hEGDc22I0vjqid?=
 =?us-ascii?Q?qEvZp/CO9MbXKcAm80IO9Ii6LJdCK250ailDTx0qbEL00oQ1Ru4+U5pDozXe?=
 =?us-ascii?Q?0F+YXxkdwtkx8NmmuTH3Um6SFJl3evoHzNPzEQofeEPUEaxBMyj/jf9h8Utn?=
 =?us-ascii?Q?KLcqmHlFlzRs/mu7vNvi/pk0/Ggmgmb2DLQ/yyptNchTICa5mbfUjLfTe8G/?=
 =?us-ascii?Q?7fgbphtkWGswWGQF5Pw7+KYSIAwrXOZRuptY1BTNKtkDuud0EllgXWI3b3Lx?=
 =?us-ascii?Q?xtNMYenkgFhl2GPzrb+LWF4U31mnRdLRFMjYgfpd5EzdCpRyRvTsqtqFVJkP?=
 =?us-ascii?Q?VPx99luIo23w1bR96OSml78gz0tObmkuT+Cxshhslo5mIGmFUKwaRyXQxMEy?=
 =?us-ascii?Q?3xcOPXvLZvUvrYobf5pOSjbiQX47VCEn7wpGbnRQxE8/PICTdeBdipbkh2S2?=
 =?us-ascii?Q?GiHCa/dv+SXZThgrWrIq0ZoTmVmSXQjX6HJyLQ6UwIcU2jvnqucbcgAoWkqd?=
 =?us-ascii?Q?2GbMVKs9QiBe7EKg/okthcWkNRXEsW9RU34KBaAphtesw39EuJ8wIpjpL0uZ?=
 =?us-ascii?Q?u53BYIF3po1QSpM+MeSSTBpfRGbF8kSanrHZJiD8Fluv0woaBvKdUwrS0kff?=
 =?us-ascii?Q?YgV36hlSlWYb/1HV3aRBeD8Xh/pqRgeNVGvnYP4TjG8ALq0Df3Qa3E5Kayty?=
 =?us-ascii?Q?88ngsj/s+NMPddeCjGE941/PwpnPNxn6B8/7vgzpkibQe1inh0gll51zpm++?=
 =?us-ascii?Q?tuuybDmAm9f9BcfGGAsSd4O0Krma9Bs3F12JhjYDABo/EVeT4jTyicBvE7cV?=
 =?us-ascii?Q?ZtgjIzyRSydZh8DDb+S3q0tVoC9zlBAhimKr9xZa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aaa27ef-af1b-4116-bcca-08db2a5a7fe8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 22:20:38.6314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oUmZBIXYkp8x/EcnGNI58L6H2TkHCHxfOOeBo9DVeuqHnzQPM+VRNbsaTarAOtTo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 03:01:12PM -0600, Alex Williamson wrote:

> > Though it would be nice if qemu didn't need two implementations so Yi
> > I'd rather see a new info in this series as well and qemu can just
> > consistently use dev_id and never bdf in iommufd mode.
> 
> We also need to consider how libvirt determines if QEMU has the kernel
> support it needs to pass file descriptors.  It'd be a lot cleaner if
> this aligned with the introduction of vfio cdevs.

Yes, that would be much better if it was one package.

But this is starting to grow and we have so many threads that need to
progress blocked on this cdev enablement :(

Could we go forward with the cdev main patches and kconfig it to
experimental or something while the rest of the parts are completed
and tested through qemu? ie move the vfio-pci reset enablment to after
the cdev patches?

Jason
