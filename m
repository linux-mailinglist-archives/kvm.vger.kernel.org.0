Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA7B5137DA
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 17:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348382AbiD1POD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 11:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348895AbiD1PN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 11:13:56 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2059.outbound.protection.outlook.com [40.107.236.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAE05DD33
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 08:10:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6jATZoOiTV2kX4g3kdveA9MIpQZHvnDwUZIJspQSIT09fEq/Ajo7iD6nHGfv8ecATiWzqgN+Qu5AWrYTivK+tOZQZKX2gkG3Tj8JCbR156+Nqe9A58eHvLWyTuZ7YoUT7CPwD8/0qjzrH4SEXNXdA4FGMyHO07saJ+Fj/ZMpp88i4gK/S15fzUFv8MIWgqRc30sfAyapNt2x/WAuqd+oqPjKKytPH6VuFl4eToO1oPzIRzMBJ0pDzpq7V1WSHRA3+Mj1CLXJe2F37eJbDkhscdC1AwJ+muKpnDW1UwHPD1BI1dhyCDMDAtZQGDexukSVYe7/NlepvOGMqVmzWLyPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRalykXXjP2I/KZrmPIHoBBHh+ma2ThPUsu0EzJ41jo=;
 b=fVDNpJqgztqaGEtk6eMp6ridL0frfXu3KriAxBncIJRgS3WRoe763/WiWEJQI+zpNyVCbieC5kIKghY493iMi0je7v6U9eTi8JFwVCOm+fqVuqarHykYAnLnscGjWbpRS+NnKcEqsKhjXA7kAFn4bwKXecRRiYD6jx64NObzh9vpLkO3y5KfrSp/VEz+jTTcH+IDBU9mRGAsKN4BeCS+nlesYr4cGYuCffUnMOwvDJZJ/0AVfMN7S3xiGco/ic9yGpM3xsx38Z3rNvDOzPnCPmlQivEtUMSbYdqnHvknpsg1DAfexdnozcY7L5moGqyr+VR8gKRlQO72a2FOyX/2fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRalykXXjP2I/KZrmPIHoBBHh+ma2ThPUsu0EzJ41jo=;
 b=UtMMcNkf1/5aDvqepExOS7SgJOjWoEAUDsdz/+oLVJhP6uHuqQYUoHOkAoHLnw0QxC8NYEwhkYG0WXtfqb97Lzbq+/ur0FLh3LM7NDoW9RUqZ8Z6dU3kkqslYBIbdjkT7M+F86JmlCKD0OYRK/yvKaVMNwrZT2hDovPhW72cJN2AR6nmWxaJrSWK701+c6yQSjN1wqT0vOzBCgRuqWSTLlTSwPUH//asYNyfpKKZL6UBfF+o48OpwDPIASXl6gh2ylbE5ZLmzck9pAUPgm/7I51cTwjXIbtDa6Z+9Z1LnpUnxVT/XV+uWHkChdE8azt10NbjEkGk9JZhEgTFkANU4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB3926.namprd12.prod.outlook.com (2603:10b6:610:27::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.17; Thu, 28 Apr
 2022 15:10:39 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.023; Thu, 28 Apr 2022
 15:10:39 +0000
Date:   Thu, 28 Apr 2022 12:10:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Message-ID: <20220428151037.GK8364@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
 <YmqqXHsCTxVb2/Oa@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmqqXHsCTxVb2/Oa@yekko>
X-ClientProxiedBy: MN2PR22CA0007.namprd22.prod.outlook.com
 (2603:10b6:208:238::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8be46bb6-7552-4b5f-c3db-08da29294105
X-MS-TrafficTypeDiagnostic: CH2PR12MB3926:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB392697C1B9CC8573A69B3C15C2FD9@CH2PR12MB3926.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TALl3MSzJ4BRu/zTZinHyX0DAdeezjG9Hn6meEq4BEAbO3+dUHP7KbQ+eXMkja2xH6Maqs+jqsoy1DbnLOZIJcy0Yhr4ySmLsK5HPpaEicTfgArhxxfGpY70i+dfUQMjua2rMx/4YrKxfG7xSEd9DBHQLoQISuzjk3pZbjxWia6C2BQj9CPIrJISJ/HHp2f9tSkjoItCBkSW9RQPlCJ6Bv0oUaCumtV2KRmVEgSsYIOBVsXIvMOwVX0XGL8cf8w5yy5s6FpHYWsFgPolUOlubhobBdkZdHCbZHh+2zBzan0zmsIFeUVqeLdw8HPx6Xm5UjOMMhSjpf4fqHsxkSTFKI7eL0cbHsxJ5TqVNtPBk+tJg0rQ8S+IVS6MZbfBiIcTS5K40OpSxGdeQfw66y3xRh23AZEAS9cu2s3LdOoZTJARZ/E+pMmWS9clKhtZoRTgvyo04zll242cswXHKRKsrsCw5fVTTqPjCxviXM3cgCF6oNOvO42CufgjjWwLsMf86QtK/GfUxyW4Sih9LQrJFeoBc+QBiXhy/+5kYFID1Qr0/Sgu4w4JyPiHcDmviHgDPWCF81wPIfnii1FZjRYLc4zaIwadN3+Uv7MGixKcDdWIIAHk104iL8RFhpn9QonmTKZAc1jK5H49/i14z60y9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(66946007)(66476007)(66556008)(186003)(5660300002)(6486002)(33656002)(1076003)(8676002)(83380400001)(2616005)(4326008)(8936002)(7416002)(54906003)(6916009)(6512007)(26005)(316002)(6506007)(38100700002)(36756003)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6mchjOrGn1xAktYEk0IpEgebiVE31DZCF1q4Ukj+e3jnZRUGD/iW2nGHAjNK?=
 =?us-ascii?Q?CkD18TH0IExTo4hq8mKqXLCdgm+AapI6Tk0+0+ravHuotJQ1eHZ6BS2NaZOO?=
 =?us-ascii?Q?H9gseB8hoLDiN+PT3psRDIDiyQzZE5149J4JBC7Et690lrUUvLuR//5du4us?=
 =?us-ascii?Q?ZOSQsGwjq82H/Q77XIC//1rDASBnPFRDj1xvSFp83SbUfUYPTbhZkUDUzDbI?=
 =?us-ascii?Q?yFIwbY2arzDPq5DKB4mkVvM1SWjJJl84uopngoIVsYpLNf8Ca9zLWK1vItNV?=
 =?us-ascii?Q?MgXS0059DQVL15eIOLwCB9vh6VgRcup51kHL+jOVGlNvocKXHljldjhsynh6?=
 =?us-ascii?Q?AREK+3SCmGLQdI4Fe7hji+VMrnpal16/8eVamvpdRMXqgk8Cv45Gg9sFH2Ej?=
 =?us-ascii?Q?kjjWNOxGimiI5DLqOer+ZgKks4G44F/lxuyewQibvhkfbrizv88rvG409Q+U?=
 =?us-ascii?Q?GgawrEYxwuExtXa3m7T/uXKwNmujvsj0+eBg118v1zn8h/sgTBnZ1OZCcB7H?=
 =?us-ascii?Q?23U6cRMeWu+muCWmyksIgxIPn2TguN7uXqs9TnjoKiU6BpWiMOHFxKZxanN5?=
 =?us-ascii?Q?ME07xyHZQsKTWcsyGRQEzWhkWWXONzMRlNQ/U2OQHLxQ7+ZN/E2ZUAYkb9SJ?=
 =?us-ascii?Q?/c8lAVd5Ix24poQBHabzj8IA0dz7/5mhc4oEO8M6Ze7qBq5u6RYqEGX4fczB?=
 =?us-ascii?Q?ejNVBnI4SarFnAqNRtF9HpE+6GcOO+yU1nL/uu10kftrO/aIvmyBKlZNYW5U?=
 =?us-ascii?Q?5VsIxot6l176bY/kaJPTCgQzAFNzPEv9F+D7jcAQngM4VTK4GHL1yLGuy1sy?=
 =?us-ascii?Q?+f7as5dl88ap5CKg5I+8/Y4CoAzV1PbnYIHS+PpIE2bVpqMVEnX5DoHQR0o+?=
 =?us-ascii?Q?lR1Hh/sEe9+ewFG2GTaVJZMClOrJqjPx8vmc8qlha7+LhQKh6Ot6T6UIVBw2?=
 =?us-ascii?Q?ncwxdlTCrchzL4/Npz/YQJ41CTOwczJFqiHWb9BLpCqfn5vkgw3JxnJacdRF?=
 =?us-ascii?Q?TZYWX5cGbRSBz0D9Y66KZfgKO5mhzRZia32XHhvShOynj1yk90EznYUaex8w?=
 =?us-ascii?Q?U0QMviGFVnooJsBp3B1rVH5LY4bmEt51U6zuOq8hdaWZZWSzcr2+pndn0dyd?=
 =?us-ascii?Q?C7qewKCuZWSypTIZdXc2ynnpcTBSZvvoXioFSCDRs9jgzgoM1cg9Yufg8vG0?=
 =?us-ascii?Q?IozM2tef6dF3kz6MYXJqEaQ49mBXxDXIO6E/BOXfW05+zjDoAKBsYEF3JFIb?=
 =?us-ascii?Q?7PHzlyQ3TW/Jcigb5RkFdWrZUv2i9DonOWXrVhjqE2omImBCd/sUlsVui5d3?=
 =?us-ascii?Q?rn5eSuDbTq6Vaj8ByWioKTRrHwlpwtKHmRdvh9XOBqhbOvRdAmhwDj2je18f?=
 =?us-ascii?Q?TOIHo9LYjUFIED971flodIJuACylpXcUWTINrOFuECKo555WvwG+eMXq4A3V?=
 =?us-ascii?Q?bgJIaP1lAlfV2atEaUExTBlZHH+RsdLEpGtQPyBYKiqpu2ZQP5GySf9n+rLp?=
 =?us-ascii?Q?xvtJ9xSEYpb42A6d2YU4Dq7hVAceDRQXwHupKqxnlOj8cJ8CyZS9Np/cZ8n0?=
 =?us-ascii?Q?DmmQE2t22xh6gTzu3r6r8iUhLk2aQ/4xi1AbIps0s7uANSCK3gZ2jA0XwYbR?=
 =?us-ascii?Q?ddc5L2I8V5BV1yElWl8vgSi3CzjoqB4ZCMFhw45AlvbXdXjn83yHNdUNLmjL?=
 =?us-ascii?Q?f/esGjjr9KG3dwUrcIJZXkiULZ4YjkPBAvnkjF4jJGLhYZnFnbUnReN5ax2k?=
 =?us-ascii?Q?ZBDbtu0qIg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be46bb6-7552-4b5f-c3db-08da29294105
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 15:10:39.0911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oyX3Z41MnohUmJ6A9I0e7Jk0rVG6imHfcoQmqA2BLE4ylwt8J137YQQr6efih109
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3926
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 12:53:16AM +1000, David Gibson wrote:

> 2) Costly GUPs.  pseries (the most common ppc machine type) always
> expects a (v)IOMMU.  That means that unlike the common x86 model of a
> host with IOMMU, but guests with no-vIOMMU, guest initiated
> maps/unmaps can be a hot path.  Accounting in that path can be
> prohibitive (and on POWER8 in particular it prevented us from
> optimizing that path the way we wanted).  We had two solutions for
> that, in v1 the explicit ENABLE/DISABLE calls, which preaccounted
> based on the IOVA window sizes.  That was improved in the v2 which
> used the concept of preregistration.  IIUC iommufd can achieve the
> same effect as preregistration using IOAS_COPY, so this one isn't
> really a problem either.

I think PPC and S390 are solving the same problem here. I think S390
is going to go to a SW nested model where it has an iommu_domain
controlled by iommufd that is populated with the pinned pages, eg
stored in an xarray.

Then the performance map/unmap path is simply copying pages from the
xarray to the real IOPTEs - and this would be modeled as a nested
iommu_domain with a SW vIOPTE walker instead of a HW vIOPTE walker.

Perhaps this is agreeable for PPC too?

> 3) "dynamic DMA windows" (DDW).  The IBM IOMMU hardware allows for 2 IOVA
> windows, which aren't contiguous with each other.  The base addresses
> of each of these are fixed, but the size of each window, the pagesize
> (i.e. granularity) of each window and the number of levels in the
> IOMMU pagetable are runtime configurable.  Because it's true in the
> hardware, it's also true of the vIOMMU interface defined by the IBM
> hypervisor (and adpoted by KVM as well).  So, guests can request
> changes in how these windows are handled.  Typical Linux guests will
> use the "low" window (IOVA 0..2GiB) dynamically, and the high window
> (IOVA 1<<60..???) to map all of RAM.  However, as a hypervisor we
> can't count on that; the guest can use them however it wants.

As part of nesting iommufd will have a 'create iommu_domain using
iommu driver specific data' primitive.

The driver specific data for PPC can include a description of these
windows so the PPC specific qemu driver can issue this new ioctl
using the information provided by the guest.

The main issue is that internally to the iommu subsystem the
iommu_domain aperture is assumed to be a single window. This kAPI will
have to be improved to model the PPC multi-window iommu_domain.

If this API is not used then the PPC driver should choose some
sensible default windows that makes things like DPDK happy.

> Then, there's handling existing qemu (or other software) that is using
> the VFIO SPAPR_TCE interfaces.  First, it's not entirely clear if this
> should be a goal or not: as others have noted, working actively to
> port qemu to the new interface at the same time as making a
> comprehensive in-kernel compat layer is arguably redundant work.

At the moment I think I would stick with not including the SPAPR
interfaces in vfio_compat, but there does seem to be a path if someone
with HW wants to build and test them?

> You might be able to do this by simply failing this outright if
> there's anything other than exactly one IOMMU group bound to the
> container / IOAS (which I think might be what VFIO itself does now).
> Handling that with a device centric API gets somewhat fiddlier, of
> course.

Maybe every device gets a copy of the error notification?

ie maybe this should be part of vfio_pci and not part of iommufd to
mirror how AER works?

It feels strange to put in device error notification to iommufd, is
that connected the IOMMU?

Jason
