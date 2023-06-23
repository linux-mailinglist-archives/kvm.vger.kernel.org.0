Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7A773B9AC
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 16:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjFWOQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 10:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjFWOQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 10:16:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2862136;
        Fri, 23 Jun 2023 07:16:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8aemCV8WWTWcI/G8/cWzJPie5aE9JyPeJ+rf8a2jTSWanRC7RITBUu0dhehoAQ5AlHX5prJqqgZ0wKbvXEtz9UZhEIb/r6mYFajReGRA4gNgPzuF2OVTEbD7hs9B6pbxUtUgDE7crnUa3667ILmT1sIwJ3Eg3ebpGGTJPwBKnJOCK57rrPAXLIUZt+rNxXn+JMlGdH2bCl0uo/d12l2KsBy6jv6mgRiGljtTQNtr4gMAE0g1E0Wc+6lJ2UZU7MrBo8S9WBi3CN1X5doOs5jgX1mA6ftkk9O0QCc7Adl77qMqxOYNOEb5L1gu4P5pvgePrScDaU1clyUxw+3TiYG/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/SU7go6RE/1PoKzRr0zqJohwIBmNpRNkcHSCTcd/Ugs=;
 b=N3c7ZHuZnY1vJS7C/U8a5GbimU/aDzg+cmZXRy1Kjbu2FSqvER7JqV7+ajgd4YEokQiCuqAe5lPJgNMcsy8Y3hUXii73MuEZr9hZKba4te6xkistFTfuHk/Op+1jCtC7XzUj1Ilzoobogol0n9Z9wbgcbWNJm3igtWpxU5hYNm2beHaPGqHXapZML7N/8qhui/zfOgUS+NiAu4xh+EnkWJoGUIaHeRunLeAX53i+wh/Ck/Fu5ckbO9Po9ZS6TtiwL+S+j0jhXDNm/pbLkMBH57T9DGmo/NN0xm9e89F8ChiniCI50SrO0U0vr0iFd3drGXXSrWR+J4fd5ULjdlD2Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SU7go6RE/1PoKzRr0zqJohwIBmNpRNkcHSCTcd/Ugs=;
 b=DK16Qy+kQpUox0xwKYyBDDOODGqATyq99pXIA9lu2BGITHdl2IZq1cVn/K11EIFTRzIGwjFV5L35cuRy4+Xue4GHTZgxWktDhzCwtsLBKgL1aQV/JwBqApA+R71SCKeHNWAjxLbyPeZfViumbVvo3lMUNzyrtbEome+4jRB8UCr2x6GKzKO3thl/0TsIOI79rHaVOfuwk8qZc72uqPgzNJw8a1WGRMpM/8mhHxt7zFJLa9RNQSNxWsTCab52Oh4bprzbqbjiUcrSyYsVMxAo0EDQes8xIpziA+jbUV5jA8WZPhIco/uA1K8Eg8q9SzledIs+up6GJZwXGhYCuhxOCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB9275.namprd12.prod.outlook.com (2603:10b6:8:1be::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.9; Fri, 23 Jun
 2023 14:16:19 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 14:16:19 +0000
Date:   Fri, 23 Jun 2023 11:16:17 -0300
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
Subject: Re: [PATCH v12 15/24] vfio-iommufd: Add detach_ioas support for
 emulated VFIO devices
Message-ID: <ZJWpMTazhb9TkEk5@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-16-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121653.80017-16-yi.l.liu@intel.com>
X-ClientProxiedBy: YT4PR01CA0432.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB9275:EE_
X-MS-Office365-Filtering-Correlation-Id: 26c02046-cebd-4d47-eecc-08db73f46a04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eYN0226GmlYwxMLxFy84Ab9LbA0z0Smv0ehHBM8OFqTgQPwbTPxt+HiSnTqY4ZQDWkOjOxYjRdvwl6UJ28H6v4FvWMe9IfWwbni68Nf/XMOufPJANsVs9dwyfeZ+YFx8CtQPZkTSF762xumFh0QZ4j0tYJ5zKJzFkRaNentcMKxL7Dw5b0fZ4/lqQSdAidXXgSRh5Qh44BGrFWyXefAP1wc7hM/0ejD0jhPDnu2aDZ2qy6yIgbn2+1iFPYawqjI13c6aDe7f9r7wxYl9yc94WBCM5rfthPRRNQYD5W2l+wS8adwDGmw06AXDQDkMruostB7ga3Mz3BlDObma7LkI3PZwnlQ4sXmfStXkPr1avf07EEhj/lHYW+Kmw3ZI89kheuztcMw+8WEMkjhQzUSbX4B7/U/Yi32uH2yrGxz9SzfduaSnF8CoRtLXjKg+kEv1Gr2hZvNpjNvQAyMAiUpAdYtUVCLckFQlvo4D/5TZ0g6v7NfShb2mywJ793+lFsT2tj6hlSjcIjT/1YdqBX3Psd7OOxT0wGEKOMzbVt1fWvCugNcl/Dojv6S2jZFd4JWQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(451199021)(478600001)(66556008)(66946007)(66476007)(6916009)(36756003)(4326008)(6486002)(38100700002)(316002)(86362001)(26005)(6506007)(6512007)(186003)(2616005)(2906002)(4744005)(8676002)(41300700001)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KIN9iadIGppc6FKQzWJR0QwgpdSKrtDIDZtuwjk2EKNyw5ZjO73ULlgT8lcw?=
 =?us-ascii?Q?2Ek52kyZ1l89X6OaHzZwDEm4VHSIhPjrHVqvQke7xWTqFvPPRnF52IKCNw8V?=
 =?us-ascii?Q?lIQ+yi3IXmvfRLgCnDpreYSpasUPsK9GkqmuEvVfsWNC1TCo2NHt+8NEfGdj?=
 =?us-ascii?Q?ufB+koGVCe54/OWMVSseGC2Yo+/N12/HMdaD4J9edORr1mqkof5W0tSMmhwm?=
 =?us-ascii?Q?hCVWLQSeiCUtHZVVirALZrCWiohkvoIjeXEv0Pl4lQi4y5qnN+p5b/gp540f?=
 =?us-ascii?Q?AD0+HhNWIEDdv8Vhd8igX8R//r29ZtKjcdzMr0JETg0t847FiThz3aacufla?=
 =?us-ascii?Q?0mEFBgmDNHRKvbS2meWagK/Ps+a6lPeVyp0c1GMrJetQf0XRuWvKxrf8aFsr?=
 =?us-ascii?Q?zxojPwQGqXU6gVQnvKtimEsaLWppPSmi7fMqqZPSp4QDnntrm8v0ZsOze8tW?=
 =?us-ascii?Q?lLCw3qoGSZoyJWZ2KOXTUpL+b6400beUK1RF3beQvMVECtC0lCtmUkwJ4pUn?=
 =?us-ascii?Q?+FIVrgphuUw7wts4TjQluka9KunQ8h4XkUKwYs9XIcRPC6WoInPU7IvGE7aY?=
 =?us-ascii?Q?Q135NrYvkgwQVfXk3XCfAohsAVh53nd7C0pv62iLESxAEawfxbC6H7HVl+kv?=
 =?us-ascii?Q?c9w5UH+yUm5HivUteSDFzuYeASBFAO6mmF3s36mFCoS9K0Pm0zdj9utN9myI?=
 =?us-ascii?Q?xZhpQqI1uxXWb+bI/vLpC+yLvZYocLCY0o+yGEDJcQ5tKYdhJXVmPWX+PVAm?=
 =?us-ascii?Q?LvfEYGm1/kilT6KB0Ncq+3dHqdiuqGIlmW5rjtAPoaT4IG3JWTyovB5c+Aol?=
 =?us-ascii?Q?WDXCS31gkNsoBkwKLEmWs3MqdEApf7SYY0K8JFmHvgs5hEGjV1IqpNpdOmJq?=
 =?us-ascii?Q?KaygOdcR/GBIQfR8FiAIxPXkR9CNezSpsh0GIu1zaQMTUoxbtbmA1saJ+hoJ?=
 =?us-ascii?Q?xRt0RxlR41Etofhu9wmPQUKUauPnGxvTxTD/DOClyDJw4NJLP9qOio6/j+98?=
 =?us-ascii?Q?yVpjXlPuoQgSlJoqfSKIond5hv7XutZerO+53qczlLiY5E99kwkZ2JiB5wZd?=
 =?us-ascii?Q?VS94GYPPJ4qnPN73MXIdieo1oaRD0usa0Ql9p5cjGXsL7UuCGgtpmN7qJxzf?=
 =?us-ascii?Q?VRH39rsl7qKLUkfoR0Ehzv27Wr6RoroWvOAIhROyesF8FZHM5uB6oTgBntML?=
 =?us-ascii?Q?m+/zMJ+Lm/JomUt7iwPMTAOE3hM0GUVMt1iwHCiWAfy3gp12HpmQPjZKGq/F?=
 =?us-ascii?Q?XYrM21IhEVojJTfj5cf/x01dXIZkz5mF/WtbmSQmzst+PgJ21cKWPtB31hei?=
 =?us-ascii?Q?TVKg41VMhA/w3VROB3S85+cv4m405ju0xq+owSgr91zAbNOBy9O+67pO4b+3?=
 =?us-ascii?Q?8oJOeFTvbtJqEgBsSW9mX7/7qNQMA5JJ/IWxc7w9XoUhJ+D/lSpGxRRfg5Z2?=
 =?us-ascii?Q?JB/uBuy89RpNloaN+GC/85xCBpKXlPwFAJ/FC35Xnfe3E3fhxM1qpoTLAefc?=
 =?us-ascii?Q?3Vu6AZsftHHWChyMKuyZHlYsuAVAstPeVQ0U2b+1GrN+T6h7Ogs/a4JyVgLs?=
 =?us-ascii?Q?hqVXdfUzBbPP8vTk2W1hy6VlgMPGi5DG0IccCp/G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c02046-cebd-4d47-eecc-08db73f46a04
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 14:16:19.2479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QTZWOSJmn+M71U9EfDGYEKAwORE+h9cq9izXDkXu0aBO3QavKUwAmW1dqOv/yRPr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9275
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

On Fri, Jun 02, 2023 at 05:16:44AM -0700, Yi Liu wrote:
> This prepares for adding DETACH ioctl for emulated VFIO devices.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c  |  1 +
>  drivers/s390/cio/vfio_ccw_ops.c   |  1 +
>  drivers/s390/crypto/vfio_ap_ops.c |  1 +
>  drivers/vfio/iommufd.c            | 13 +++++++++++++
>  include/linux/vfio.h              |  3 +++
>  samples/vfio-mdev/mbochs.c        |  1 +
>  samples/vfio-mdev/mdpy.c          |  1 +
>  samples/vfio-mdev/mtty.c          |  1 +
>  8 files changed, 22 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
