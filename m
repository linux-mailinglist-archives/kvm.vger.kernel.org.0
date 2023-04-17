Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFB96E4A1A
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 15:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjDQNjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 09:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjDQNja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 09:39:30 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBD2BA;
        Mon, 17 Apr 2023 06:39:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3aKjHjINfKlw/qN655XWRM3KoCgGt1Tp4qK8mLocN22kRHuKs1A0wHjI6PZyFzQJFO8k/mtzgLSbzzGzeKRJ957wEPHuORjVPwom+8dA4+d3URLgF52SS0qrpqRTr1JcW8pvPdkZh+iR6ALZvDMjglHzeaxLNVWuOfHT0asqhxhs3sc1Ia2Uxvv+aAv1T57+4QYpsQJ+GCIjxA+PsjvtCmtgOo/h8zkxYBf61i4JJw6Rf+V54rdGhtVddxW7aE0LBG7iokrLA+kfosngUJb351tcU7aQ/QAN7yu8RJncO2aBG3WTy4nZLToxYhlINjm9vPi1sQLX00haYmihN85YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Qb4NN47CoUk9o2sgxqJ7XaULZarcclH/Pgn2LYfHSo=;
 b=GdCGZVULm2p4eTcA3LlfxK0+ZDkMHM5OeGXmz9CaTvV20zmbgk4Zf3zLthssUGkcQlo5gBBBUGZzRVXr+VBd9zl1RssfOVnqjac40286YLb/1KPxbO734twa2MBZFSMTn/NXPcSrceWk46vFNH0OnRxUrZDTlWnFcDOZ8GgQpAiBGAlpU1kFyt7+atduPBl3VLaQk6X8G0P2LvIZFq/Zcv9wS9ZVU+3GFPV4eSe2VXtDu3nt0s4Uo1jgf1bsnOwGAGevHC8ZS2N+ueAPoOagZoXYjjhZOPp+dqNrLgMMqO7PUklGXk8zeIqKxcIeJE3ayjlsMvKwv4siOCPx0IYc5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Qb4NN47CoUk9o2sgxqJ7XaULZarcclH/Pgn2LYfHSo=;
 b=YJuAhFTjXP1OlaC2umb3IoJTOb3SxCrYodZhTynTJwFEzV3bjJRDgv6RGRMBDdIOCW0cdMJFPM0yYuTHCAe4FzFpYgVbvV7WpxANfMuZU+hFrFVZwFq/r0CveIa8mNnHk4WqlrhWjsklYnjUhgh0o9hvhbNOvqmA5Fy5UApoKBOl7sz69E4C5dgF3xUfMwOf4nMRvq4Ioew9lCbzzyoigDnLp42NGclo3eMCX+kJZOX3o9Xtv3Xg8VtMItT3F+3QS9JxUAb9sgSnaDrZ9ISAd1UT5H/h37yx9QCOYu+Lf9Sp7g/Oyf2ddtHVH3tx2wDpgesJfjFWEH3nAdAKSvqhXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB4525.namprd12.prod.outlook.com (2603:10b6:806:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 13:39:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 13:39:25 +0000
Date:   Mon, 17 Apr 2023 10:39:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <ZD1MCc6fD+oisjki@nvidia.com>
References: <20230411111117.0766ad52.alex.williamson@redhat.com>
 <ZDWph7g0hcbJHU1B@nvidia.com>
 <20230411155827.3489400a.alex.williamson@redhat.com>
 <ZDX0wtcvZuS4uxmG@nvidia.com>
 <20230412105045.79adc83d.alex.williamson@redhat.com>
 <ZDcPTTPlni/Mi6p3@nvidia.com>
 <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZDfslVwqk6JtPpyD@nvidia.com>
 <20230413120712.3b9bf42d.alex.williamson@redhat.com>
 <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:a03:100::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB4525:EE_
X-MS-Office365-Filtering-Correlation-Id: b473c7dc-a5ee-4222-ca5d-08db3f492891
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ahvoZzYpxSLW1DHbRl/+eg6cXDXht1hPisK72O/sonr+8/k9bqowflCaDGBmT+l6Gp9EG/Y9HgIyunE4sdhNg4ReAZSnqFQVDYzBLobI+u2YQpYemuTS3fVf9hcN0nlQ3V8wUmHIj20Fwtut2yXUtwTZ4WzdQ+CeKlt2HXxS/ZWhElxYU5ssI4V/wMZpG0bRC09B6bhBh6sX8sUcjtd2VFW7bbtIRiZsfausjkJwFFY/+8Bgdyg748LWvEqLLLrYBGcem0/1TSAg/pMnHmzNDjMr9LfFkBlUeN8QXQ7osc4ux0inIEDLBDVwMDjXM2MhuFBKizJwmJg1i7RDEbOIDyKIYTP7u/yIAQ1Fa9YiUc48HkqIAk4gHVoK6xcUPKnkSdiYJxijdpuolppsqej4CIE/Bu9xKkgXDYapc8+y+kJyAYvdZdohlzgZzyziWbfxdT3RAvw/91CYZsB7ybrYDg4pEss/5a2cUZB3Y01DsJubuNiIEm1a1PwRqZHFGb6tUkTMXEsFENNWhithzJNnzlchzxoLaiCM42lTAMmYlGbyuE5VfpE3lF+IHA6ahOGidQm+woljYU0V1GraBgAeiF4+iTPN+r/LhJbTvlfHAk0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199021)(36756003)(7416002)(2906002)(5660300002)(8936002)(8676002)(41300700001)(86362001)(38100700002)(478600001)(54906003)(2616005)(26005)(6506007)(6512007)(186003)(6666004)(6486002)(6916009)(4326008)(66476007)(66556008)(66946007)(316002)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gtie6Fom+r9Dh0k0e8WK2NW3eymffhWUERvq3+ughQBv5DxMK5SziB7tY2le?=
 =?us-ascii?Q?4KBfpaCMpL9nZQaQTmwfweW4j/0Z1isLEM/sNcJJSBr4tbxRnU8KZ3S1AqvK?=
 =?us-ascii?Q?0c9BU0l8Ygji35rrFRtZdA4EwEIjcPq42bZkn4MiGubFh29gMgU2Glx+4TKx?=
 =?us-ascii?Q?L4q9cjfQYlm/mdo9Rq7tZ3rf7ggKdDrQv3hZvmK1KhtHmfQWIO1FhSrTTRun?=
 =?us-ascii?Q?kKb4FmWXnwYhEhAMgPAK0N1dscAbeGZQxzvsIzDX7MU/DqIONWt1UfFq+/Am?=
 =?us-ascii?Q?SUoSprGX/L8to1SBo5BlcoI6HZKHtQjWsWdD+W5uXpCVnvKq4Q0K7J9Gxh2k?=
 =?us-ascii?Q?MRDAMSWt33KkWm/7h0LOypMBfjratKNUsALgbZ+F4qkU/UbslrGpqwn0VmZL?=
 =?us-ascii?Q?kUIvMxQT6udDzKrAYokIPA3Ddox/fCeGwqHc9o7d7CT6ITmXhctTYYa2dYBT?=
 =?us-ascii?Q?d2plE2i3W0R5SNz7MsV6p/nN8Fnli0pyMI/VeL7P3iGUTXYr94283qBNidwJ?=
 =?us-ascii?Q?JfPxLyurAViX5AUEpAYw4CR0D128/B3iVIRW6OQiXcjWkhzI0ZRbH7IE+RhX?=
 =?us-ascii?Q?sa3qDO2Cod7x2jlPIyaI94MulaltOI+1NIhEivOtwNZdWSeP8TDIyrOFy5Ha?=
 =?us-ascii?Q?6eYzt9uh6ASOMYnVC1u0/aa/7bfXJQ066WST9WBbnjfrI4NIu8nDw9+hrynj?=
 =?us-ascii?Q?gNcNYc/BbPGZ4ie5JRPTT3bWC6ana5jSVjUEpPF/cScFvSvjY5SZqcSrx3e4?=
 =?us-ascii?Q?7eKQ2NrAICPo/A68XMV/IFTvOUKvRIwQ8FW1SLCBgWonkgDff0DMf7fPF2/O?=
 =?us-ascii?Q?E5tG7VjmW3YU3jkvry2MPBUyS51CbRldhwMTOoIU0CzLN169setEIrQcHYl5?=
 =?us-ascii?Q?VgLtXfejy/kwVd/p3cAZLI71481jhOM08R2odwvjp8Weps51FJEZKSEEwQYR?=
 =?us-ascii?Q?zUVywgTaEuJ6UMsCytw8riUMXGfdQjKYBqK3f5CGzlktTQ9XG74JP9Rfzcna?=
 =?us-ascii?Q?G+xLmEXNn/skbRV+XTaTW6jKEMvaLbWnFxEeEym/cFJ9kpisJ3UKKCQX/orq?=
 =?us-ascii?Q?6rEi/dTNad3ROgs6nStqRw1Vjlwp6xCGGo3ya8a3sS0ld+Reb+3+tZaTPNOr?=
 =?us-ascii?Q?DAS/GAhBk7cQIj4RB+5Nl1gWqLuP9HW0x8WwVMVdFfYhQ+Tm9hf5Pwzb8nW+?=
 =?us-ascii?Q?zRh9TisW57SeWx3TYx1Qz/JS2sWnrr8jVpOsahG+az0y5KNmuRWBaTMf5DVu?=
 =?us-ascii?Q?5RRqpcFD3NbFoCe+b9WAamDMN/rbqaXeFZdxyH8imXb4LKxNTg3PHru5+mVS?=
 =?us-ascii?Q?DHqc+V6q+SXlBU3sGC41L0YJwPE+drov3PIdm0RZa5AfbYjtXzQp0ILVU9C2?=
 =?us-ascii?Q?7jAq4dxzDlRXaAOXSUDUu9YRWaUj8IrarmOESIu9rbL/6oQoD4w3ADJ7rsLN?=
 =?us-ascii?Q?naApW+JAz8eaA11+8Ixo9zE6nkY/Uzz98pflp3V/cs5ZSqFMR0bYXYsp+ASE?=
 =?us-ascii?Q?VdH3BJceqvYRD3Zs9kf8330XZe4gY1p1iBOs6Ct/Ml7RvPt8a9zHiucvfgLJ?=
 =?us-ascii?Q?gJ/6/vydioIIdzYZqOebw/Gcu2YGSIun4Cf4D/41?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b473c7dc-a5ee-4222-ca5d-08db3f492891
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 13:39:25.0984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ft1Vg4Q0Cx2/oODktrlgIk8WbVwym0mfPnXza7Xyh7Dxx6L8X1gfWdSLXt/JPLXX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4525
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 14, 2023 at 09:11:30AM +0000, Tian, Kevin wrote:

> The only corner case with this option is when a user mixes group
> and cdev usages. iirc you mentioned it's a valid usage to be supported.
> In that case the kernel doesn't have sufficient knowledge to judge
> 'resettable' as it doesn't know which groups are opened by this user.

IMHO we don't need to support this combination.

We can say that to use the hot reset API the user must put all their
devices into the same iommufd_ctx and cover 100% of the known use
cases for this.

There are already other situations, like nesting, that do force users
to put everything into one iommufd_ctx.

No reason to make things harder and more complicated.

I'm coming to the feeling that we should put no-iommu devices in
iommufd_ctx's as well. They would be an iommufd_access like
mdevs. That would clean up the complications they cause here.

I suppose we should have done that from the beginning - no-iommu is an
IOMMUFD access, it just uses a crazy /proc based way to learn the
PFNs. Making it a proper access and making a real VFIO ioctl that
calls iommufd_access_pin_pages() and returns the DMA mapped addresses
to userspace would go a long way to making no-iommu work in a logical,
usable, way.

Jason
