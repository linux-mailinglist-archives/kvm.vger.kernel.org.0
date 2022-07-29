Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62872585482
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 19:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237990AbiG2Rax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 13:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiG2Raw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 13:30:52 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C934F15702;
        Fri, 29 Jul 2022 10:30:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARq4JLa2TpLcf5Cv0Ua3QM2QZ08h/GgOqhaxJMSnADnKbhYES1bhH6ZGA7BN00pkh4RHlfLzX6FVSUs1ME4xW4Ou56ht1oUX6jBT3/9sIyCSP3QYkG9AKmyAhvmuFKdmsjemrsl9UsBVp8GL3KlL406DeJUYmMPzuerpn358cjeoSr4vlhP+nq9ofioUkgs+f77DcYCqATJ+kLTr+/tbn4oetCZ6oMirYTebZXScAC+peIU7Crt2QmAvz18b9yJWmQ+DOGskCRAQtjmnQMfI6z1HMuKGVROxlP5AqZsGRb/o7E3b1yqwB/xLEIMDtRIiMlvEYYr4KadSm7IKYk2A9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pqe+kn79OT7U5c0eVBU632BleNTIEotu1HEBxBf0+Kw=;
 b=fsZFGm944hi/HtXmifQLTUuGwRhXl+lVnlbh2hgvXjpSDyQN7MJGjDitBXbAZE6X+5VrteDhcYqnnONCPqvIRSnCmaxdYnYINRZbza3zXoGXrznxkDdGbn051Sp3fsv8ms5JahxGYHrUeshsGYxDeUTmUhbVqeR2eMqQ8tfM8sWeuLVOeBGthFTmAlF9escq5SkB4DdobHFFS/TOEkASx2cWraQP2Qp6jQhdoXZ7MtmFUWRwsaN9qGBzzMvkmAyJWxAjQQGJvg9970MFOK6oT6uFBymzIIfDTCY9v9V35V/h0/W2XfV/T8Zk8l2m1lG776I3FBYOEwrZzA+pBA/Cyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqe+kn79OT7U5c0eVBU632BleNTIEotu1HEBxBf0+Kw=;
 b=rgyrYdgM2S8F7vPJsC7pKBskdZPXPZyTZQ5XMovrvEca4mk1qHwDttWZiQIN9EwnDt1/WJnUO9Su9kmXJGvV7QoAy+DFDIGNx5WZ+LmfgUVxGuUpy8IaE9L42kvxEOpSWGm5oZ1LmNuk5Qs0oFECcpwk4d7s8QkkKpEwYuytJlrAZGntqqjSgOh9k6wVbkApcORmO2m3/4rUAc4d54J2Og32ehLWEE6sm42oenxDAaLtbygJtUUWJgDEN+KyMZqGUPFwW4i8ENNG0/Ikvmoms5XV41XAMCxoOxEkHuU0am+7k4mGXOOSN0/eqkMIEv0fofjlL8hTWwySkrU37KsaCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DS7PR12MB5909.namprd12.prod.outlook.com (2603:10b6:8:7a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 17:30:50 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58%8]) with mapi id 15.20.5482.006; Fri, 29 Jul 2022
 17:30:50 +0000
Date:   Fri, 29 Jul 2022 14:30:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     joro@8bytes.org, will@kernel.org, marcan@marcan.st,
        sven@svenpeter.dev, robin.murphy@arm.com, robdclark@gmail.com,
        baolu.lu@linux.intel.com, orsonzhai@gmail.com,
        baolin.wang7@gmail.com, zhang.lyra@gmail.com,
        jean-philippe@linaro.org, alex.williamson@redhat.com,
        kevin.tian@intel.com, suravee.suthikulpanit@amd.com,
        alyssa@rosenzweig.io, dwmw2@infradead.org, mjrosato@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, thierry.reding@gmail.com,
        vdumpa@nvidia.com, jonathanh@nvidia.com, cohuck@redhat.com,
        thunder.leizhen@huawei.com, christophe.jaillet@wanadoo.fr,
        chenxiang66@hisilicon.com, john.garry@huawei.com,
        yangyingliang@huawei.com, iommu@lists.linux-foundation.org,
        iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <YuQZSfQtBTBtJOq2@nvidia.com>
References: <20220701214455.14992-1-nicolinc@nvidia.com>
 <20220701214455.14992-2-nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701214455.14992-2-nicolinc@nvidia.com>
X-ClientProxiedBy: MN2PR15CA0031.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::44) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87e2ff84-ba7f-4720-ee4a-08da71881479
X-MS-TrafficTypeDiagnostic: DS7PR12MB5909:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9n9UroDb54XvkUGt+Q7JyxKJdHq+AqLoS+Ivj1cfkgciJ+GxL/qaOce2l+Q8aaGCp9tlO8GuRqjVLb4klRd1OfsipmijqLUBsVNmXRcCDkoihR1wnpi24+vzTDXuT50/rKkhcJbU/zDYkcP92A0REfHM8H8tiZgKkoZsl7Lw/TzJjXMdRAbiTxAP9c0rmgJkiGcjD5zZ/I5+UxMdf9XB4jBaCqKzPHG1c+v9Ld/0NuRxkgqjlsXY4sVA5OWOKcp8I8nl1PBKqFJdIau6pqx6KpqjTcRtEAfGhxpaljaXRvNdC07OaZ3/f1fqvZ1hxA99341kEX5XklQbsz54VwfkTRRQ/mntg0H/MfVz88ODe+ovE4MRScSgzMy3qqILcMAUWzYU/WnRRpY8cAxInmoOAeY+daaVksAtHmQJfeYLE9vpE0KT4UZ05C0xFjYQ44dQWda+HkRCVToHu3upybFcSLCm7lwTQqFL6TewCyW9ktr8/F15J6beGUZfyhl6zrht7YnLTjY4x4VzJm2QilYPq7X7EdkhA+veUWEaCzk/ve3ZiEQc+IuQzD6eGi9oZJEq6pnz0pg22QeCCI4mNOLTGWyCbYlEwt1w/uBWwtfT+KF0WWx7uITB1qqz34hjMQdyE9jCKH2LmaepafTwkqprVWSYcyTB8uB18iw3XPyWERzcNYgXVkk3z1U0jUS4hFMBPMJuKmHHOb29rpbkO4ozGfcwtkoFlEv0AgjjJPPkenZn4VIin8gTdGcgjvh3XsIs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(41300700001)(26005)(6506007)(86362001)(6512007)(6486002)(38100700002)(2616005)(83380400001)(186003)(4326008)(6862004)(5660300002)(7406005)(7416002)(8936002)(66476007)(66556008)(66946007)(36756003)(37006003)(2906002)(8676002)(478600001)(316002)(6636002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pAf4BFuYy6/pnZBg47tXnnF7rsJt9qgpO9/+gm8EhGJDVyk3weqSpR5Z8P8J?=
 =?us-ascii?Q?JWqOnl/2vMYrJ5fT2sWJBx0O4Fhbsmu+FGL2cs3BqFjryxYVIy2F8AfEYC/G?=
 =?us-ascii?Q?ZZ2sDQ3/IeXT7IlODwGh+aFc1W2izwHPJMuFmzbG/pKg9Z9maZdRiDtgSHab?=
 =?us-ascii?Q?vSo71NK6IT1sEJ2DlTITflKSyI2fI77c7nTEbNKcW5LSID8yeWp56V/0mbcT?=
 =?us-ascii?Q?F8uXETRE42oPdOnqSb8imeHEvvHN7YnH51SHCgHhAUfQP0hCrDjatb1HOVsI?=
 =?us-ascii?Q?4Gs0j8q5MRT/q+QM7uuOTWDC5xEtKAWuXiCw9eskIRk+wxG1A+jijt7z95W2?=
 =?us-ascii?Q?4iPVRECK+/oHGpErVHjzannxZzt5NyQ8TYfsrmZsXnb3qD2A3ht2e7FEJR5Q?=
 =?us-ascii?Q?PDh7mcGBo3Z03fEwjWNdLY3zeBcs0fBLv7csRSI1MaDLBHBeb3z3EAJR4LDX?=
 =?us-ascii?Q?M/VA892y8QHaisvXDR+9altc15qI5VYK8UiYEr6uNEx11Bg9dWfq0toUbCBB?=
 =?us-ascii?Q?MZNCbk5issm4nPtYqVMwll3ql86Z8oZoPZm5sHkCTH+D5YeZPokucTRBS2Ck?=
 =?us-ascii?Q?Wcru1hZxlXgKFQaCQzU61ZQmwBzL1ODFxMmpUVCYKbj5jxv+O0Hc6OZgTc/h?=
 =?us-ascii?Q?bW1jxCmWJIjTrXMnrq1spSMMcbK/FR8OjRdyhAGDTe4Iu4L+zxL9Hn7IuhL1?=
 =?us-ascii?Q?vFTyauceDy2LODgckNBb6/bKhHF6S1DjiLDrkI0RLseYGLALDGMGUJllZD1h?=
 =?us-ascii?Q?Od3+bqPANTjEtTK4epN5WemyobvWAy20rqUouQOutFlTRvl8D65vb32/O2P+?=
 =?us-ascii?Q?xnDB6ZLnUk+sFSwmRJ94i7fmqwBHRnmWJcEy5AB2PGOeodBsiZdmdabvPGni?=
 =?us-ascii?Q?wv4SBPIPOWp2enHAjbrVjDS3MF0mT5lxYXuJdLvbRMTayLsbXR5d+vnybqM+?=
 =?us-ascii?Q?JPm/3WVwu/drkDoQY2HCwR+vaZeVToHsy4yvGazZeWLhJLGM7FYiLpC2g4b9?=
 =?us-ascii?Q?LMuaIGG0FaH3jIteP6KyEh7dzTIPqniZlXmf7c2KT92v7QXeCcyfUOUJInok?=
 =?us-ascii?Q?ZzhaPgt1aSRbhyopj6mxnogfHZvGAZkr5MvRxxWpL1w1MAV3CW2/Ei/h0ecY?=
 =?us-ascii?Q?W8XZLIOu75tzyO0R//ug1waH1CNj6lyZ3tDsmLFNMBBEBlhAaJPACLx32BBH?=
 =?us-ascii?Q?zq/phbYlnG8FFiqdLcvjVk6ewCvoz1ZQBfneJBl7cnmVPRyn0YI0K9k5QCHX?=
 =?us-ascii?Q?L72Q0vr1R93Rx++faCbgnbRieDtPPx7mU7Qc8BzNrTCfBDjniD/SQ4eU1yRa?=
 =?us-ascii?Q?qy74pIN6bu9/myqYoiAL/c38bPYIWfo+s/Tq8LOmaO42IOYHNWCA9VG9+paC?=
 =?us-ascii?Q?/v4XK0iCv1rzwcOXtk1ZTm91+AvG+QfGJevog2UcorBYyPYppEbLpmkjBt+F?=
 =?us-ascii?Q?cfApVYmh/OwUWwEsPKeAHDTMofHudD8Te555bySL9d5BFJdbkEmjs6vWgnmc?=
 =?us-ascii?Q?DQET+jZIpOHhu9+wa4p7AAdCEYMOWs/ACeGUZ9vLbKAGxJbHjRkDHaAtz+Fc?=
 =?us-ascii?Q?zsSUkHRWwScNUBmlAdu94zmS9Jbo6k0lAZIM4Uuu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e2ff84-ba7f-4720-ee4a-08da71881479
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 17:30:50.1247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SG227D2e0Gq+RHV7KxGVYZsYYZdv6z2kuP/5esO/GzUanlRwXfpzHpXlLPBFsrpb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5909
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 01, 2022 at 02:44:51PM -0700, Nicolin Chen wrote:
> Cases like VFIO wish to attach a device to an existing domain that was
> not allocated specifically from the device. This raises a condition
> where the IOMMU driver can fail the domain attach because the domain and
> device are incompatible with each other.
> 
> This is a soft failure that can be resolved by using a different domain.
> 
> Provide a dedicated errno from the IOMMU driver during attach that the
> reason attached failed is because of domain incompatability. EMEDIUMTYPE
> is chosen because it is never used within the iommu subsystem today and
> evokes a sense that the 'medium' aka the domain is incompatible.
> 
> VFIO can use this to know attach is a soft failure and it should continue
> searching. Otherwise the attach will be a hard failure and VFIO will
> return the code to userspace.
> 
> Update all drivers to return EMEDIUMTYPE in their failure paths that are
> related to domain incompatability. Also remove adjacent error prints for
> these soft failures, to prevent a kernel log spam, since -EMEDIUMTYPE is
> clear enough to indicate an incompatability error.
> 
> Add kdocs describing this behavior.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/amd/iommu.c                   |  2 +-
>  drivers/iommu/apple-dart.c                  |  4 +--
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 15 +++--------
>  drivers/iommu/arm/arm-smmu/arm-smmu.c       |  5 +---
>  drivers/iommu/arm/arm-smmu/qcom_iommu.c     |  9 ++-----
>  drivers/iommu/intel/iommu.c                 | 10 +++-----
>  drivers/iommu/iommu.c                       | 28 +++++++++++++++++++++
>  drivers/iommu/ipmmu-vmsa.c                  |  4 +--
>  drivers/iommu/omap-iommu.c                  |  3 +--
>  drivers/iommu/s390-iommu.c                  |  2 +-
>  drivers/iommu/sprd-iommu.c                  |  6 ++---
>  drivers/iommu/tegra-gart.c                  |  2 +-
>  drivers/iommu/virtio-iommu.c                |  3 +--
>  13 files changed, 47 insertions(+), 46 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
