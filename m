Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D236D13BF
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 01:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjC3XvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 19:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbjC3XvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 19:51:02 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2076.outbound.protection.outlook.com [40.107.101.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16A412852;
        Thu, 30 Mar 2023 16:50:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZjDygt4tBFLnGTITmxeyzTcMgatGDzjq4KSD8BD5zXtlGC6NpFOFpH8dg8gKJg9AUUExTKfq0lAHXkYcADKJFtkLN/SFaitgEaqxO7JXqPiXaT6Zdigk0LOrlA49KXafTGyX4nTQ0EzfCWAADjkepELDnH4+4fIx3bjFT3/AyRiTtskblIEH3D+Q+1i4W+Obxxff/gIidaatkuAEjz1gjVn7plGycv+Oudee3sSEigKy7VbbqBkieGZhbxqaLKkNimzvAX91gd6TWk45aatuWcteaSV/TmiweDWZxVgFR2t+AxceW0FV+/0eBSmJ3RfyNrJYzkVus6jOnL5bJSe3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xHCyfXVAIjIoLmvKwLrpm4YvGUCXT/wPoX6wsnVAhIw=;
 b=DnZ5ixaDvhZfcVAXmVSAfa+y2zxOSgWbSlfJfbtoDL7GKrsqygxW72nggld1RneEkoNyv1hJPdtpub+yA1ItiHwPIyTNZWo21lA54FhsvGmVYb2ru15rbyOdC7Ctky6DPfOTpB/eSb94Tq0ssMMjoaGVoEP0Wx42P81WURgVxs0pFlOh92Xhly6/saaZ8F4vIZPu8I6SgPyEvHNtzGeIWX6T0Ct4o8kmuPrFqUXYcDoiXwPqKjYywwYW9RBm+thKZGBC3INcAQKbL4j4mcejEdkX975q6sjaRSW5+xKmXN+xzEzSRZGsUUtVPFnKeM3pZ5PM3oqpt+E1sZSpNqfOLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHCyfXVAIjIoLmvKwLrpm4YvGUCXT/wPoX6wsnVAhIw=;
 b=J0SPgfOeKYRMPaMSVzSzTo39IrQiYXpUYRBhw5CQc+NgSCtbuH1HHg6abZ2aj8FT97p3IpVD17poyNQmEmZ2pXedDtjYRTfHctA3X6bKfKki0gPwfKz4bos0+krNwvGsklrzKJ7cId+HEfACXjp2vescVTzDJ7eviVYrNbYnZuE23OAwuE40rW4YKXXjF9bHTh+0PeMX8s04TpqRh9Xo9phrd7ZY01dUkJrP4PBeO6bH0p4iVWKryYyY+PuraVY3y415H+OzqWh7lEFqsAntKSE4sVrKcihwb2N04KkGaZnTdu3YHnFhZ8bNEnDjRr7WoMspgpRbgPs8hHZrQBhXYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7889.namprd12.prod.outlook.com (2603:10b6:510:27f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 23:50:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 23:50:53 +0000
Date:   Thu, 30 Mar 2023 20:50:51 -0300
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
        yanting.jiang@intel.com
Subject: Re: [PATCH v8 03/24] vfio: Remove vfio_file_is_group()
Message-ID: <ZCYgW6HuCcFh4pjI@nvidia.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
 <20230327094047.47215-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327094047.47215-4-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0428.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7889:EE_
X-MS-Office365-Filtering-Correlation-Id: ed6dbeb9-ed4c-46d7-74fe-08db317998f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WjgGlvO5yJA/yy9gvYhq1Ca7UapKjETjWwPBZUsmWi/CknzzEk2qOwifELHDy988nZLK3gGxvXUKm//V7oY1HI5jy4pDhDPCWTeBJUagDvmS6/lgURL9EUbuI30hMdZkSyZwtMWdePfOqamjsFv4dIrr5LOzU5lupjgVOuW8A34WsC1/sQd3DuEX+7X65dW0Sq5V7/cUs1O8hxnLzTM9PmfJj1bsqttjqYo7Usc9RYQIvCY8t5Q6yg24uYVP8fkuJdaNSpA3llf7hU7eNB0WROf9OMnFJbeOKTFFWszJuH262TUqZeH4Mf/QDh7EJwsA4FBACqIFoBWyCFriNwUXhHIz4vitifFeo1509w6rnm4ZNxGp14OavmvEbhxK5vsXSPv9IA7m+1aK5CPAhluMWin2id8YsUR6k9IfOLgEFMcdLl9dOR4lPJktxAn67v38aysPCGV0Sfk9pKjrSNCFJWbHBLaRf9ifSaCLQ87lRBHYYfF96FXv16V4SMT/05B6/oYq+/fIl8DKBeOduG81STMmA3W4NPUl2DyM5QwOU7hq36qqgUvzVRrXEbECTgE8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(83380400001)(8936002)(6486002)(2616005)(4744005)(7416002)(5660300002)(2906002)(38100700002)(36756003)(41300700001)(8676002)(6916009)(4326008)(186003)(66476007)(66946007)(66556008)(86362001)(6512007)(6506007)(26005)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uv2hAVX7O2oTAmZBInzu8veGpzJsUGwfEpcohjQe8LiPNrqAPweAvMFkCmXk?=
 =?us-ascii?Q?YAW8moq/pzr2qVYjNkbTPLKgxo5VQLksPA/ZN7ORX+De5fwZlfBAPulX6YAr?=
 =?us-ascii?Q?SbHtOV0VN7JQ+yL6Yi5nqOGbIJwlRMi/wAw7qmYr7TV3mR7nzLrfpdLJL0wR?=
 =?us-ascii?Q?ARsZySKKQ50kEMhBjd6dyOTwLWUbkMadycpj/r9UhA4inw70d3OPiFK6KKoj?=
 =?us-ascii?Q?rpxDOHftrlj0Xn6/DFf2uUJv5a5DNhvq4F0vtB9LfolNbBgWHCW9f4EL9fpd?=
 =?us-ascii?Q?pKg5ETs2QvquMusjHraZ09lb5bKaFzleT+L0DbjlPHOwPw3ECA3wEUsv6iPP?=
 =?us-ascii?Q?C2DeA3MNEgCFqIVRYopYkLFD7Et+aEF2xlPvbhQLcBSnym7HuhEfmQA/LAro?=
 =?us-ascii?Q?h3WwyIDC+WXXY6GEb3cSD7qWa0xOd/UtC+ZyZAv913nhooSB88vWb227Yd0v?=
 =?us-ascii?Q?E6pgQXzTz5ivPAo6JyDsFsxRg5tArA1BbcwdYbc2z5zQaC1c1AVW+qNCtZAY?=
 =?us-ascii?Q?MC4jx4j5++DlBuPoH5zS58ofoxWwfmLbSM4ojO0aAsvaIGxs4u4Y1cHSIAqw?=
 =?us-ascii?Q?pZHajs7YLDSLaVWOY/lXjftz2vb4oc2QqFBN1piSauCPTFZCtlN22buuAfZr?=
 =?us-ascii?Q?qIELCgg+J+NKFis5hw2OaqFEMwTJ01LJVCHvK+n4sO9aaZgcKErabZxDgpTv?=
 =?us-ascii?Q?H70Ykk9w6G2wcw8DhwoCfn33jjLA0fm2LxdUymGG3V6pHPWh+U1vmsAKVyoK?=
 =?us-ascii?Q?CX9Sc69FQ2PYXHHV8lEerVMS1f1HERumySSHQfFs+K6sFUEyAxeK17YzleNH?=
 =?us-ascii?Q?tMn2uIjELGWLWc0kCwsj/VTjH+S6+fNofyMnXQB178UIDIML35V+XpF5TzVz?=
 =?us-ascii?Q?RU8Y9oDpVYehDGAeORsWh3fiRwAMMFljGL1N1OIXM5GyKEaqVp3girlDhzL4?=
 =?us-ascii?Q?3pAvlRkN1LNIb6uOZyzrOyg+F97UGr/S9x8Wkdz6z+BnO6QDEUAdv3K70aqt?=
 =?us-ascii?Q?Yd2P7y9s+aIZfxh8esx0DaqG1tywlNRmjza2+srqordxcBg/3yVrgTNfw8Zl?=
 =?us-ascii?Q?FA6UfxZPWAJbL0ETYaBC/LJYFHR3l/y201UOp+2qc2II1rUoZ4f5C8RPVehQ?=
 =?us-ascii?Q?Zbb5RjV82uAcCeZ3biMtuSAi6p4NJbsLuuO8lVEO8U81yFy65m5L+dz3MWud?=
 =?us-ascii?Q?156+4JMhMjbqVF6P4bCkTbQiWA8/P02xKGEQZd6LN/GVYshig6kIGxQwQDDT?=
 =?us-ascii?Q?Jugt3UCFOUQaaz2U3LbGJj3uFuMfaXCgsQU/d2gxcRF2eDO507ykG/m62rJB?=
 =?us-ascii?Q?mbmd3rZq078ESIWfz+4NU+Kn8oT8g7xFRpv16Ay0YEytv4IaQ0e2onuqU75o?=
 =?us-ascii?Q?dMP0CY1peN9lkRCfHEvF+r6QZs17arzc8kyZcQseOvtkPB2W4pcVqXHYJ36l?=
 =?us-ascii?Q?pIY70MU27yqPBvRyIg3IODHypqEVKcU9TDtc6kpnoX7pkc8ECYWBEcqd2eD+?=
 =?us-ascii?Q?HJkMBTOChWOFhuNA5oD1fxJ4EP+z9+dH6bXgPN66qqD75boYN3X+gs5vKl+7?=
 =?us-ascii?Q?ZUB8EMaf/vw8v36av1VZzDjpc8VVLrtseKSqbPEr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed6dbeb9-ed4c-46d7-74fe-08db317998f6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:50:53.1555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H3be8Uau9lj4u2UmCkAfNRcM/RWGd09VqS1qcGsMisaGjAnqw520rs2kDxbSpSG7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7889
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:40:26AM -0700, Yi Liu wrote:
> since no user of vfio_file_is_group() now.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c | 10 ----------
>  include/linux/vfio.h |  1 -
>  2 files changed, 11 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
