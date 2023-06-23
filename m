Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F03873B9FE
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 16:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbjFWOWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 10:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjFWOWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 10:22:48 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA54A2;
        Fri, 23 Jun 2023 07:22:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4lUBHyIGSB+MK5r0c65lJQfaV6iTJPJ5AXjYr84MI6+W7InKEGEoKYTw3pGR+7pCvcZyaaU6MDx2tfZ6R1WWJE85GOeY1NPSFmzMqNKi2VLIHuVTzbpgHO9Ycqn3c8kYqaE1xQZrhhDX5gJCnQfLnnVhyIDjOlx4G//kkrQFDP6tR8WNq6e/NkOtDnBqFq/TA7TsTkRTMzx/r29qS5UBmnluOXMVcmObQzPbaJVYfd4IPzklE7sSEbp/PpFov6gC8gltbDC8ok49xUMel251oEFRUvL+MOPEBClw90IuishMRVG1fY61znOig09Ocfo4DSlsgtiWTCP8ZOGCTJtPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LMRaTDl2dBA3njqhP91fAVbvd61tK0oSfUWmkOogNBc=;
 b=T16MHpRN3FwKAC5KmtVxBBli91PMnveYpapyssgRkcbwVJGkhIdaku972KAzcEzIGi8kUHtsAM1fmkE69ZEPPdpnrmRpJWSHAEtL98ywaZh6BWIopkrA1fXiRR+tn4olwayzIiIBBz98gDi13XcTBh0+DuuIi8uK2mnE0wMuX+JsFh3DUzEKIgVl8RDzgV6vSSg5ZUpi9NlSme8TDFaM/nXxbnLzSvIWgn8ZZ4e84j+OiTVuqXUUmqUnjPcPBJeNowwqHLSYICglDOngXo1iKklPgqlu6BV/HQD2TvlCYnfc8Aj8K75IrhupqcYGnTKlU0xMAE8G995ja38H1NgzuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMRaTDl2dBA3njqhP91fAVbvd61tK0oSfUWmkOogNBc=;
 b=cwhUvg/a2cxWqlybFmUGnB+9ZBFHs78kwhz6eLNVTDKVyk2RBxLi3B8YA81Tme/rjHf72v45hnYj+apWAzucnJudMvPW3XK3E9Fiwwt+DVAP9fofLTkbhWwU+V1+qVOR3V2WlC5SqUL4ZITDfejHLpWZbXLUvGjBEzNEp+0Mjw8xW4ksTY3CJZFfftewa76r+kXuZhsRLKKqYc3SFr4XucP0wLxJVh5ZEaqwZJY/sAKs+Wl2HzgFFgQlqm7HYl5TO1oquEKcILdF5lTLoZwpDvr6NXjXDCy12+zADtEKiQaL40oVfDkN4e7xLnbAQ5sh2x5GhxFAP8Q7YQeFTYu9FQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4178.namprd12.prod.outlook.com (2603:10b6:a03:20e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Fri, 23 Jun
 2023 14:22:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 14:22:44 +0000
Date:   Fri, 23 Jun 2023 11:22:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v12 16/24] vfio: Move vfio_device_group_unregister() to
 be the first operation in unregister
Message-ID: <ZJWqskf3xbR6C02w@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-17-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121653.80017-17-yi.l.liu@intel.com>
X-ClientProxiedBy: CH2PR14CA0031.namprd14.prod.outlook.com
 (2603:10b6:610:56::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4178:EE_
X-MS-Office365-Filtering-Correlation-Id: c60fa397-9442-4ee7-e660-08db73f54f90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6cAiN98+E6SzlJehce4VkheTqTLOxYH6xDl/AYynsSqzSgW2Twn1gQzULk0BZryOODAYoxWPGzOtctIuwvhWE31oOC+JUaZldfnJyiGdQw8nYKH7RBIMQ6YPOrO5az9hMqMtsJCnkSdfU0nTH5QqEj9y0qbPZCzCCIoQMnoXrLTibikWn8vb9pHdC5oHe8egT4bb32B6uzKPMZa2Ji3fTIY/loyW1plLA9gbVwQsu5sccrDElgdTmcQU8uyoI60UHd2gleYFuQrMjUG4d24AdnRm4vZdj28KARZlEVCVLtDl5vlp+1D+ga1dgtSYTHydD75aR84BQ1riE+QqT8R8wMkXDCteoFm9+hMozVq+EC3jfbmSEzG0dF6dZhrDMcu0oNBgYRcNM1M7oMwuPQGwVhXVzXnQfamM1uYR7Nzh1N1QIw00ZK7K81QNzQMyWMx0prQHtmzLUWg/ghk4oBiAR7p/AA/Gqs1Wc9w/b9wEm+6SV4eCptdz6klaOjJlU4TbHtaM4jWFNXVoWGuHntUm5xfvQ/moxxzuXYKq6D1BNTnDNpHkzyrFR8yXluXBQio1/BFVLwhgzeTnNDt2DhAiVT/wGf/lzTahAhWhSHxTRcA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199021)(478600001)(6512007)(26005)(6506007)(6486002)(7416002)(5660300002)(2906002)(36756003)(4744005)(4326008)(66556008)(66476007)(6916009)(66946007)(86362001)(8936002)(8676002)(41300700001)(83380400001)(316002)(38100700002)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VAvzj10wnhwnTL29sIphu5pl9qOsIiEZ7NglYHkmpDbqCDSEbJ0x702khVz3?=
 =?us-ascii?Q?6odiA0lm1EH0bJu6kC2aPItpxRmBG+2STVj7hXi/CAAtDaDXb64Ac9bovsES?=
 =?us-ascii?Q?0r2UTJ3UG11SGyGQp+VWeo09Ojub4U4id+7U51RhWQpqjIoDZKHwCJYkU09F?=
 =?us-ascii?Q?EfRtgEXKng/HyrZZ1fan1qhfyUufmSgIy+71qfCoFCJ/5gYzGGHk61KQZVuR?=
 =?us-ascii?Q?0mOW2z4MX3/zxTwa2Am6Hpbr+jMPvH5es8IK7NE5RXlD1lMQNv4DD0IP2Z8q?=
 =?us-ascii?Q?3kS2fU/XsiV/oghWTDmIql4miomPy8LG7E0LJSzlBAg5HTCusn6Stz4YTVZN?=
 =?us-ascii?Q?/BK9BjmZBvjzpaXeVH3TaHHUR2htu3Setlr+Pl8fWcNhWioL47WkxwEBItdm?=
 =?us-ascii?Q?6Das4RWZlJWa7i5cGMcNUzPQ9Hf1c8X6S7XNILylXpPcCL3gASsiL/m80DIv?=
 =?us-ascii?Q?eAKc8SGTxg6hoAMTIj+hYwlRli0P3kowSsqaT2eTkhanxPkgcRS8llcJdGpx?=
 =?us-ascii?Q?SRmhktiqVJauxv0IVSN/VlX3moBNAcVHUOmsb1o2AhIeW1siaQBGdwi0LsLn?=
 =?us-ascii?Q?KUeRiYC33lNMbyTCCT5THrMiLezGLORBCwQdWPe2G7OvTSrVWBlBpuH+tdL6?=
 =?us-ascii?Q?EKw0wDMHCSc4rtF0ZHNe3dY3+lhpzh49VSgRu+i9PJ8QaXfFX3BlbsKKDV48?=
 =?us-ascii?Q?/KowCIp80EhIrjaslXTfF8+MP7DOHW0lfNjYNhPFsa8M4BdalKDnPtfQb4qh?=
 =?us-ascii?Q?G+24AOSk/FNemFlSsCrqyIchDRixcEYWeEragExlWWPdLhz2ZmCXJBLITa/Y?=
 =?us-ascii?Q?GnCeHUJKBm+7xrC3ARMg3hTYssNZrxR6vzPLFbhzW4dXulcvYomDlNT2kFG2?=
 =?us-ascii?Q?qdd0WxNQkmTYXvnOEDkx93F3LHHgu1yLfpmEK69+N2esjZf0fVbVjCuDPFFq?=
 =?us-ascii?Q?zSSHPxFIcO6qz+fux2magmcjLa+OoE/tlDjF27RMGTE8w7MGHs2cmlTBMPqf?=
 =?us-ascii?Q?snVrnvFSUfMJJxJGQLzLRffgtey0Uj4xINPw/SDfQ3CLpTzS/jSqTXW9QZjN?=
 =?us-ascii?Q?gOX4fGTjZCQYYOirXbtzJlHs0YlUbU0W3T47ucfEyNREmu2c7FHLCkKbknY/?=
 =?us-ascii?Q?vXQVQYCkxQun0Takaxei097IcroXxS7Wrq+cYgFydOg6OWV5DOqO01LYDj3x?=
 =?us-ascii?Q?4GAWsW7tu52R7O+bZUdtiUu6YwLjQTYVVtVFk+Oc2P1OkZhQhDMpSbVfxOH5?=
 =?us-ascii?Q?6BDWzcm8ZCkzz0NCwH5sxyIDQft9iExsgqx7nziJ+zSRNALxyaQVgGayfHg0?=
 =?us-ascii?Q?5OPRrOTzxwUDJA3ATUEb32/iJ48sQzsC76bGCwksNC061D8VJmS65m7BEhus?=
 =?us-ascii?Q?A+KCN0SbH1EaMAo/ztVxeNJoNO49BMxu53Z8Y7kYzP7lgpE9wuyTGL0VZdUs?=
 =?us-ascii?Q?+LyK63PSK/a38YFmueJU2kqTSbAzlnv6g9KQGMWoiF5awIebX3Gwyh5g6JFq?=
 =?us-ascii?Q?oO20KIVjKg28CBXfHo9V0l48OGURIRlTQbo6SMV7+5DSnz90wxmat70F23fh?=
 =?us-ascii?Q?8AUHkGC7lW+YCvpycOKfhELkDkSHoV7TEP5jncsE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c60fa397-9442-4ee7-e660-08db73f54f90
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 14:22:44.3505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o24aE7aGsqEpzAITWmMpXMRDqRSaZeap7B0EdUH06xQINkRsu7bSGYgeoAN+oX9K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4178
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023 at 05:16:45AM -0700, Yi Liu wrote:
> This avoids endless vfio_device refcount increasement by userspace,
> which would keep blocking the vfio_unregister_group_dev().
> 
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

It looks OK, at least I couldn't find a reason why the group list
would need to continue to be valid while we are waiting for the
registration lock to release.

Jason
