Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087606282BD
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 15:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbiKNOiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 09:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235468AbiKNOiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 09:38:04 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C098C28E08;
        Mon, 14 Nov 2022 06:38:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3KLpLzUp7sFkLSuhPH+fzpnhU0+HzSgF5hxk3CzhsRYqKq3Jqc6JHi/opzlY0uGx/AC+FWoTtlOuLQjznMhT1pCDg91NGDLBbIuHGMWXhajM4fSFMAPZ55f6TpsCZbaLC3csI9oNnvugiIbnOKCCRe5qjYhRMZKXZP/CeBbFNvak5iYR0lC1752DYqJafRwwZjiEbQmUHg2Go8mbfw4bDRSxCMBhqFWJiIVYD4TaHQDXEN/0r9YPF+PEtdO5BCm1Y80qiO4B54BaYslA5DTHo6xl8VGUNRWkX+fCDWvab6lBYdDFZ3fv6AkCx52vO87kWN5t26YKTrAQHl6vVURAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D6rqRkw89Y6vmGv893Edq0+RC51C9UruFoYJaz+Ig1M=;
 b=QR4E0LyPFMccaUCGiMJJM4lyB/xu+t9xYG2twEXbBOBB14DjHa82e56PBqf9bMSPNN8R8BUaSJvmfKbjx03jD2PvfUOs1kanYaRHTGTU740iTxw5eo7l+8gdCD7YvYtyUjfSEb7rLB1lYkoyjmauLRfE9b+MmjE5dSPEO11aZnuvLr6OqaMHle9c8IhH/hWk4MI6F7XqP/DjPK+bVcdyvK6PIrCLDwqFEGyppwWZssn7YZUTYOroRKzvTqFS0c83LcSmZXPHq8qzKFdf6AGgmnuFEWAsuO55syHJZ+iVRfhKryXFBG3D1kyq3gCnXg7ceBDXcY07pyYCt8gZlvEEWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6rqRkw89Y6vmGv893Edq0+RC51C9UruFoYJaz+Ig1M=;
 b=KuQM5EFFsUWYhyK2WxTS7/OLfUV5Dsam/xGz41mwMBwT0jpW/o/xH5T/7q75AO03+cW6Pc987xz8sQ0Cn6EoeslPraJl5Y+qIHOYObHPfq51sNffTT5XnFMiMH4xt04scRtaz2nDeWEnTxd2eqpNKe0rsWzR9KO5qsL5PwdC8QYxAWlLBSttkRZofBHbX6WAW34UN8tM80rdJfJnHpr3S9MsapBKvMXydvWFR1VARJGnmO4zFHb4PGXCWF0lGDY6NxSoJYrVHBYftF7p6gTKSaObEuMM+4QuPDfzUnxQVBAYyZcJ9AKt1W5cCRo5VZ5NcOOqrA/X3KS6PZTu9I5m3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM8PR12MB5448.namprd12.prod.outlook.com (2603:10b6:8:27::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 14:38:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 14:38:02 +0000
Date:   Mon, 14 Nov 2022 10:38:01 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     Nicolin Chen <nicolinc@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@gmail.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, iommu@lists.linux.dev,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Longfang Liu <liulongfang@huawei.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "He, Yu" <yu.he@intel.com>, "Yang, Lixiao" <lixiao.yang@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v2 00/11] Connect VFIO to IOMMUFD
Message-ID: <Y3JSyQRtGTkZpFFi@nvidia.com>
References: <0-v2-65016290f146+33e-vfio_iommufd_jgg@nvidia.com>
 <Y2ofNKmmAIMGYLFK@Asurada-Nvidia>
 <9b2bb9f2-fc82-dd01-84ff-c2fe45e1a48a@intel.com>
 <Y2vb4fuPZdYKR1M1@nvidia.com>
 <127303b5-8753-f866-1811-a67ff4bc021b@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <127303b5-8753-f866-1811-a67ff4bc021b@intel.com>
X-ClientProxiedBy: MN2PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:208:23a::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM8PR12MB5448:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bf9009e-fad0-471b-cf9a-08dac64dd554
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E8Ip9ENj4YZvqbEn8GZ0qYErQSFahPBUH584Hec1o+SsfksAEca5tpNRRqq3lkp4dgNPnrMVGb6AcreVA8UsUPiC//JmD/eswwc9fM9yJFKGYDre7L9tALTSFo1RTASTnRKOGM8BlVoEzjPLQLoJs8ra8U1X0tVM7HQo90SJUvAaoKb88hvG8Y+nrtgtzqj+pFVIfb7mmpBo28bjiZo3OJxd0+6gxOL35Ug7NbsWqGRMbu8HZhfubF5ED0aHUrkMMH/+qakaWCeVh9EjTgtLKNklGwHHcDcK5oAfXhYo9PQnWolXHtcL1v51FtR6TJv5M0apuQkCCVuCehOq1ir/EkW3BSNM5vHkpRzvxVUyRlO1/5o2JMzfyUWnbNg7zOaZpp/gbnWVo+BfIJOeHoYirEqHb5VSLk8FOBA2mbJSnUtDs9TondEqgb2j+AfsM6ppL3K9d0+cAJYJbHYAGautUEJjnmeupkhDFAaSpgOW1ZMgrbQFAtn9yu0qbMc/vCjeyakxwZ8LWMZT+dvoVTLqmmCUrObjMGUiAY6nVSLfAbCWEx9gjqiHkNbN+w/kRI2NhrmuRTeetcTXb8CqXV0K5qYR2lZVHwuZ5gE5IGN1Ji3keeiSREuH5sCnaxfeHvGhtLGK5rfECrjx6hIyfL5usI/U8gIOVu+TfGkSCmL0xEH5jNWoIp77RN1E/TYjyoZs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(2906002)(7406005)(7416002)(66476007)(66946007)(5660300002)(8936002)(66556008)(4326008)(41300700001)(8676002)(6506007)(6486002)(36756003)(2616005)(6512007)(26005)(316002)(186003)(54906003)(6916009)(38100700002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zlbPfeK4c25GKjafkt65R1RuehKeQGTJGM2y+VQiskX8/gTd13psy4LIqSwE?=
 =?us-ascii?Q?e029hoNaBZhAig1i1+BL946KHnX7PPwRCe+Dol6KJ3cEfGHrdeT3Iz+JkziV?=
 =?us-ascii?Q?zfukmE9yBumvQ6A/xO6NrVgbTL4yZC6ICemH1MfmIWDxcLRPZcyM7h9njmp0?=
 =?us-ascii?Q?5Qbm0uupxkx+j72rBFkCplzsAZPHllroq3t7kE0GXcMBfGS5JUwunODIHB6w?=
 =?us-ascii?Q?Bd8KN5LuOYqNX5gPmlp0bGnR2L6lqAjsVlXqy5lVnOm+GpcJ5/j/FDu80MOV?=
 =?us-ascii?Q?o4UZA2/LUrLBepFefw9Kz0yRf79e5oT/Tham0rOkcY6aGvOMXvyYhOI/hnUn?=
 =?us-ascii?Q?YVNSfCtzLP1EAOpZj/EVoxCvddD3T1A0/DSr8DoKH4LH55VJRaDj50zOm5I4?=
 =?us-ascii?Q?jF3E+UPMfVL5BD2vaZxA5RQNwXs0862/0X3lz/mjMu10ZIA0G9fQAkArO073?=
 =?us-ascii?Q?Kjbfg8wxwkQbQGztMfb49trGHTpauHxaeEK38wsQQaEHjshTYFw1nX1xhfvh?=
 =?us-ascii?Q?oAnlLnJbwiEwMSTIeayS5OITyQX1Po7OzWwYG6hA3o/P+yMcgtKh2ulVnR08?=
 =?us-ascii?Q?VcObGsSLPghWI0wznRtjCIGBR3PdSLXTqZ7JMj4J+Y6MKRt3oMBEC+/SHLzX?=
 =?us-ascii?Q?AVkWwNfpTUewIKT8GhLOxZfsgsHhOV/VzQFHjuKbFAdyxAoqCKiGt9RZ/tEP?=
 =?us-ascii?Q?ZEgz8S0b2JLfT49bk5jTGPLUFbiXnjnzX2XPhSKz9Yz/iuo35d5PGSoevTRx?=
 =?us-ascii?Q?UOIi3gfMtw/T/dAgL5svXeMZ6tIr6lOdm37QDCrmxIGaqj3ivSSPPwO3zi1r?=
 =?us-ascii?Q?D2EvM553xDErtFb3XkUKYdaJgCLQYFUndYRk04RgGS+xXKijsBDx0P4Mxyly?=
 =?us-ascii?Q?HeCJyz/33zFvZoNPxAtYmyzj66UqhTXI2J92teKtD/sKVI0LpfbottWOHx0u?=
 =?us-ascii?Q?dyX9CJ85zvav1EipH5BMqHqDTF2QUMWxqI8HuQUhwkrDUsluZnnweeJRw1DU?=
 =?us-ascii?Q?0HltaJzHDeLic9zjJi/Kn1rAHcOxZBNPSuIchqg+EBiKmZLc2+E4VbbiP0sL?=
 =?us-ascii?Q?gx1vtDYfRpvryYAoS6DD/arz7a3lBkUxm0w9HCVb+t+jWBkxwGWgFtwX/T3i?=
 =?us-ascii?Q?VEcWZuZ7i91AKTtkCyymF397nNJZzraAKVhh96W1Bltuo9I7GRHXUdSMDZ4c?=
 =?us-ascii?Q?ld152FZ+Sk6n8FF4qtdHVoW74AoLHtAn/U7RMyrwT7JaCSvWmy31yDkBSnSY?=
 =?us-ascii?Q?lBs2ZwxuLigbyKK1sYn2BczTTFXfAGRnURJbzT0GQtWfzJLQgeHxJU2+kBWZ?=
 =?us-ascii?Q?CV594IxOImU2OLB/Aw7zA6Qhi5x/xBcMmi+ZT4VnH3VB4bXMj0Lo7n37LK1h?=
 =?us-ascii?Q?UVF+ShhemZva9RMjzdMIWQdLSOkZs1ec6zRd99uZEdIw4HIpl0OlpL+TIqFY?=
 =?us-ascii?Q?sXf82YGBl7jk2SgKgpAKl9OOJnC/2nUXBiKoj0LQsLTFAcknoFO1F+WRTRK9?=
 =?us-ascii?Q?ldZI8HPx6tR+kPNfWR8ntTGJ1Eg2WOLIHev4eXFjhlbWFQaINFCJ+zWFO0er?=
 =?us-ascii?Q?3HYLWV+6gi3edBlChB8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf9009e-fad0-471b-cf9a-08dac64dd554
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 14:38:02.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vmUvv4cL4F9MpvkTuBuHRgy3JbcBOe6Ov1sOe2OgplaFN3WJiPe24gW0rUlr8F7v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5448
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022 at 08:51:58PM +0800, Yi Liu wrote:

> Our side, Yu He, Lixiao Yang has done below tests on Intel platform with
> the above kernel, results are:
> 
> 1) GVT-g test suit passed, Intel iGFx passthrough passed.
> 
> 2) NIC passthrough test with different guest memory (1G/4G), passed.
> 
> 3) Booting two different QEMUs in the same time but one QEMU opens
> legacy /dev/vfio/vfio and another opens /dev/iommu. Tests passed.
> 
> 4) Tried below Kconfig combinations, results are expected.
> 
> VFIO_CONTAINER=y, IOMMUFD=y   -- test pass
> VFIO_CONTAINER=y, IOMMUFD=n   -- test pass
> VFIO_CONTAINER=n, IOMMUFD=y , IOMMUFD_VFIO_CONTAINER=y  -- test pass
> VFIO_CONTAINER=n, IOMMUFD=y , IOMMUFD_VFIO_CONTAINER=n  -- no
> /dev/vfio/vfio, so test fail, expected
> 
> 5) Tested devices from multi-device group. Assign such devices to the same
> VM, pass; assign them to different VMs, fail; assign them to a VM with Intel
> virtual VT-d, fail; Results are expected.
> 
> Meanwhile, I also tested the branch in development branch for nesting,
> the basic functionality looks good.
> 
> Tested-by: Yi Liu <yi.l.liu@intel.com>

Great thanks!

In future I also recommend running tests with the CONFIG_IOMMUFD_TEST
turned on, it enables a bunch more fast path assertions that might
catch something interesting

Jason
