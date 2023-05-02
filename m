Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4786F49A2
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 20:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbjEBSWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 14:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjEBSWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 14:22:10 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD9F129;
        Tue,  2 May 2023 11:22:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+vNyNjIbs2mfKLss3+oDrKyBZ/Hj4AWmF8WdM6BIP7lpFa6h7QzHDIHMFftWZAZqr0jD+dJw2BXDFnPbvrrqtfISWr4hafy8MaffFri0blEF8fonok1PFvHvlDMx/durjtXFtjTwhLo13YbHR0CXz5YDaxiXcXjc4nQ4jRHY98UcdD0BcpO6rS4I9xxJBROLWrpLYdhp7vQ5n9sBLtCbnN7CMAKITwMT8THXwlIkjax78oatzBwmdCtoMIqbqpp3o63t2XW4I3AAOax9W8vimo39VL5iGjs6mE4IotymPYQFeH/dMyPlHidw5RuU7Bgf7tJ1u7hoE7J0qCFM1dYKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bAwkeqVJWmMdHCilcQtUPKdVLV/3t1pv9kHNji3qvg=;
 b=cQ1cCWc5agJm/Cl3e/7ngz45psVcM3YkJDAu0Y4nD84W/5aLcAYmEk/PPJuLU+YgzgvOWdV/CaQcgnXLuXG/a097ShCNFpW2HEyGZ4JsneOfHuhtRGOR0fBBok+FcWaI7QFgaWZ9LS1tcy7AMURrZl3am+qSTLa03UMOFJA0uHCfU8vCvX2ciqmIsA9a/CGPHoO5xd9meEx370iyTtwjwJA3g22uYd/dcQGLYwu0oo2tInV3Yy7yeKpyK2xMDE+cwUWbgSRu8tarBY3EZX9Fc1aOEVXsU8V0lsMMYAkqizu/1FQ7b5gRICouLbnzk9n8X82br+s2PvX/lNE60M6ztQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bAwkeqVJWmMdHCilcQtUPKdVLV/3t1pv9kHNji3qvg=;
 b=g0aYZlTtOWTuLG8+XRpVNVnU28e09NCNdy7/9n9L1qiYyWfNFtCR1ocTuEFC/VgPYtHjSAGlXzE7kLefRUVIS4KKeGEMLGtaSdxBAWgnCXnaHDL72nOoXsLhZmmKJ5gom5dCRxIS2fqOEPDQ4QKPDKhxLqUGhIRj7ei8loubCQIshvoX8vp11TKeXeXpX9vwsmQngxQ6ke9Izn8rTSRY+qKihMixint5A9lbSQ/qAXTcOXNUu023LDSgpmcEXKLbxqatrknQev+CEk6ep7nR8LMU0ad/GPqajgCn/QNlyJ21O51WqWTJzNWWaN+hHJs5Qi7Mx5jb0rkEFbW590yEjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5391.namprd12.prod.outlook.com (2603:10b6:5:39a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Tue, 2 May
 2023 18:22:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 18:22:04 +0000
Date:   Tue, 2 May 2023 15:22:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Message-ID: <ZFFUyhqID+LtUB/D@nvidia.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-3-yi.l.liu@intel.com>
 <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230427123203.22307c4f.alex.williamson@redhat.com>
 <c203f11f-4d9f-cf43-03ab-e41a858bdd92@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c203f11f-4d9f-cf43-03ab-e41a858bdd92@intel.com>
X-ClientProxiedBy: MN2PR16CA0063.namprd16.prod.outlook.com
 (2603:10b6:208:234::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5391:EE_
X-MS-Office365-Filtering-Correlation-Id: c07b167c-c1a0-43da-dadb-08db4b3a2151
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: reKGePkC37v3AB4G/WFcg18oQf9gMxt3D3PeeJ284eAaLke32PU9NdDgn890ezC9ejmTZ471FKVYJ5YHjzMK+sazlEriWw0GJdfiNiGYYifPxOBTTRY0yLBl8+EopmQKZR3hItkA1zHpfnJyPjCkxDEBNWm13vm1DYzR2qiptqL07E3MEPs3LnC+saday+95Z/EzJJ6vihwlOltY2okNl/E3iLSMA/+afE18LA1mlfhrQAZVsSUwgicSeLgd+cGHPQgSAtcS7bkXd7QKF8IM5TrMNHBltwNNPmoajErtSmK4KwaxTa80SSCRqOLQnGXEEiUaE20gIUKz6JmjIs/kSXaJD3US0HO44C11edwv0eX0OsKJYCHF0TNLXNcn6QtPT0CF0eR1N5PSV9XVyrt8KNBRX9+PWbPk7Qd33G2MNujHHs9PR/8PgdmJ7znCst+EWbO8tKuVLE5rrq2UA1TOOJmTZlsM2KU45tv9tefiGc1aZ8s99MPz5aGQt3fvk32x32y+g3gkD8h928inMRfSl4z57g6eXCOvDLsU+2WFkgst/nZvfwH4JEVNajJExGl/9eZgQ9ME8Tamg9tIA3sOg61T5rfO/yYfOpg75PLqaKyMicAxxIUFNGkt6UqkFm8MPZEYl3utqqj0jJtDk7WPww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199021)(8676002)(8936002)(26005)(2616005)(38100700002)(6506007)(6512007)(478600001)(5660300002)(7416002)(36756003)(316002)(2906002)(54906003)(186003)(86362001)(6486002)(83380400001)(66556008)(66476007)(6916009)(4326008)(66946007)(41300700001)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JCc3NtZVoIu8DTlQ3PT02227w0+mdbC4vLzmDmnXDym3s/QXE5dzbNz4J3rp?=
 =?us-ascii?Q?wcOMYaKmNp3G08cea0sM6WzMgeh8gcUdhKsJpFzy4/BvZE2q0xP+/I/3xSRe?=
 =?us-ascii?Q?AF6LJwvTUAIoD9yWOGQdNDlzDvIEe6PYeCi7WBCIsjxc4J0L2x54b4GdDsZJ?=
 =?us-ascii?Q?4X7p7NuM/tKmh5duRjGuyBF5cVducbUUwjFiu8uiiXUkRSGU8WG2U8MnjY53?=
 =?us-ascii?Q?6FNYdhld9yPFNDF+6Pw+9TZNjc8hEw4cAPabNvDn3iLivox2Q3rNvCY7MmT3?=
 =?us-ascii?Q?Injlu+hYUew8/MdkPyHlVOqPrszED0RyMQOMKrd70+WpCaQhcavy3r9YpvOM?=
 =?us-ascii?Q?KXfMzHrzjHcMs6fMeEtVefKyz0E2zyhQcWPGnVx2hqTOh19U6R4hRLRi4KRB?=
 =?us-ascii?Q?vAAyV8RL6UclosdwYt1cAO2Nq/BKRZbOB5QlOqoDj/Ck0DR0hYSn9Khg/0FL?=
 =?us-ascii?Q?jLpqTVNWq+IJ05Jz2Z4CGtulZJYim0h2ipOsg5TcNS+ll1JihyxZS3PbLoO2?=
 =?us-ascii?Q?MeVcQQBBjgA9Xvize5vxvmf/ewzOLFIQXxwOt7UEccrFiGyIdoX3wNvkjVfs?=
 =?us-ascii?Q?dGBLEcEpEPvgrl6gOYKRyoEGD6rGjtaYOKjy3Nq2g/JexXqIsz037hiNUSmO?=
 =?us-ascii?Q?t0itkHky2GDQAMJvvMyqZK45SZcP4DfbfikEh8+IcNX5Geu0LTvwIOBBvu71?=
 =?us-ascii?Q?6a541uy8gCKKz63T+cdlQuuhk7r1VHZ0NpNuqsTr/uBXL6fcvFOnnDZSKlzG?=
 =?us-ascii?Q?BWJ4278RJp/Kz6o5TPL2RCo+J/3MfnyKV5IZy5HAaig0odY0rTp17SWNWUbX?=
 =?us-ascii?Q?TUgC7L43fkNDBfCgoFHH3Q/zLcEpizT9sMQCsjBBhPuLTHm0moFCkXSRV8Dg?=
 =?us-ascii?Q?2j+3QF590+7y/MB8r9X7rUeYOr2kgQ3mrNQeztdrbyF50xZZFPJTey2lsjx6?=
 =?us-ascii?Q?+go+R/vd6Jghl5kp1h7stp3Eb8STOmyLDEYmlc3ESO7126ZWWiCpvnt9/TFq?=
 =?us-ascii?Q?q1k+gNOuMY+b/d756j/+YYTCy9MNGdhhqehYOLlxtj2KzW7F4nZcxhqlnSon?=
 =?us-ascii?Q?Y+Na6G9wzWggAo2yCkFUpYgBhHqnpJwWaCfGCi5YxzWRJEv787GMYmfe4nvo?=
 =?us-ascii?Q?YCa20HwwrevcnVZyB4hRfptqsCWFKZfQQ6BF45ULGxm/Bu2hXmvwfBpGV8F+?=
 =?us-ascii?Q?TokM3VxRCHnoukL0JT9pkk+funh1P1bJhujXMNK+Ti67djHS19LBb4bJPkMp?=
 =?us-ascii?Q?dIhux+nRXTO19pt61N/UHEhG1jyHX62AHzODfoFd4gH6TpcAiPVqX3FUec4y?=
 =?us-ascii?Q?uI4hDXBAWVWmLHTcbeApc7lHd4ybRXi+PhZvJaQ94zCB2G1ONes2RfFfO2rJ?=
 =?us-ascii?Q?61iE0h5KdBVb0pItnITircRGssjXzayUkHSmQ/sN8IzoqJBwfA95nHKddxcS?=
 =?us-ascii?Q?QVrDYwp1MhyXqgn2LBteLbCNh0XSBc8ThVx9OLJUKINNYBEYR9rjSC+S/uKv?=
 =?us-ascii?Q?4z+5kO3O192hPKcvLGCzjyuK/DsDSyZNwxXa6beDJ9AIG5rYjYsb6gjH475h?=
 =?us-ascii?Q?Tit2hzpr1NHKCxQ7nKUooSlLyTwCuWPcLcZvhFRz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c07b167c-c1a0-43da-dadb-08db4b3a2151
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 18:22:04.4512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xu6tnyuKl+TSiVVMQNgH+eLYvROvut9vFBpAk7NAg4r/Tu56xWmCCnzSHUTe0/vM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5391
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 29, 2023 at 12:13:39AM +0800, Yi Liu wrote:

> > Whoa, noiommu is inherently unsafe an only meant to expose the vfio
> > device interface for userspace drivers that are going to do unsafe
> > things regardless.  Enabling noiommu to work with mdev, pin pages, or
> > anything else should not be on our agenda.  Userspaces relying on niommu
> > get the minimum viable interface and must impose a minuscule
> > incremental maintenance burden.  The only reason we're spending so much
> > effort on it here is to make iommufd noiommu support equivalent to
> > group/container noiommu support.  We should stop at that.  Thanks,
> 
> btw. I asked a question in [1] to check if we should allow attach/detach
> on noiommu devices. Jason has replied it. If in future noiommu userspace
> can pin page, then such userspace will need to attach/detach ioas. So I
> made cdev series[2] to allow attach ioas on noiommu devices. Supporting
> it from cdev day-1 may avoid probing if attach/detach is supported or
> not for specific devices when adding pin page for noiommu userspace.
> 
> But now, I think such a support will not in plan, is it? If so, will it
> be better to disallow attach/detach on noiommu devices in patch [2]?
> 
> [1] https://lore.kernel.org/kvm/ZEa+khH0tUFStRMW@nvidia.com/
> [2] https://lore.kernel.org/kvm/20230426150321.454465-21-yi.l.liu@intel.com/

If we block it then userspace has to act quite differently, I think we
should keep it.

My general idea to complete the no-iommu feature is to add a new IOCTL
to VFIO that is 'pin iova and return dma addr' that no-iommu userspace
would call instead of trying to abuse mlock and /proc/ to do it. That
ioctl would use the IOAS attached to the access just like a mdev would
do, so it has a real IOVA, but it is not a mdev.

unmap callback just does nothing, as Alex says it is all still totally
unsafe.

This just allows it use the mm a little more properly and safely (eg
mlock() doesn't set things like page_maybe_dma_pinned(), proc doesn't
reject things like DAX and it currently doesn't make an adjustment for
the PCI offset stuff..) So it would make DPDK a little more robust,
portable and make the whole VFIO no-iommu feature much easier to use.

To do that we need an iommufd access, an access ID and we need to link
the current IOAS to the special access, like mdev, but in any mdev
code paths.

That creating the access ID solves the reset problem as well is a nice
side effect and is the only part of this you should focus on for now..

Jason
