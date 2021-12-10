Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD8B46F86F
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 02:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235401AbhLJB3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 20:29:07 -0500
Received: from mail-bn8nam08on2060.outbound.protection.outlook.com ([40.107.100.60]:62593
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230304AbhLJB3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 20:29:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzauoE/boV1lyFU75xhI6EvwbfQRDUyomGhNcIBt6GWWiQldx8wT4QqVE+VnL2kkkC8OVolBEN0/vXFWM5XMd+HxKG3TfzIhhDWA66PhXVg9h0mCIz6R1DfUlkbc7R6nmfjQTRUJRqT5GneDAUlatXP2DDGRMrrwPEjcmloTOX25IXtEo0IiMpRz8opSo9cUexjLAYU3vEGqEyvQAcljHNqwsUNfUEyxQrUUQFAhp5aRlSrIkW3G9MP+XGQmyY31e2Ss1zQ8erUGwgLF8+yFsrYX/EeMh9vEC6zGsNBlnWZgeJ6/AgKs1QqB5abzq9/Cw6uBnCOLUVzFW7deRZeYWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESe6U6dsU0HZpOJaXtcQhjJLenbrQPmV2lf6TXBD2Eg=;
 b=bkcT2/NquITaUClvj0TLlOJ9XoNqC+z8ZopCeyRhXnNw2L1w2fyqRCoxEbzPrx0vGCcjg1fQMuEV/t7F66SwW0jGbPMR4nmmGtRpmb5mNTmFpN+NN9F8dW5Ua805LO+2M7teD7eqMd6OjhRTdmeiZqhlyMGJ040MQFIhwE7colNRrRwR1LzLE9qw+Nq5S/FRd601qtV4oXQsGJSv+0lNCJ3vQ6S2i7kGzBp8t8NAkv8vt7gnGG/+P0dU1IjLVO/y5wYFzbTsm3XYIH3FyHy4aQQ8k2ZshDljEKq1qHv/5E8vgl9yy/B2mEuqacv5C4L44JYdfKxqhxAOlvnfcbDgUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESe6U6dsU0HZpOJaXtcQhjJLenbrQPmV2lf6TXBD2Eg=;
 b=QTwlqyBPMHroj45R8QSEDIotetyzrx+9q+UvZP6IVRrSasvFywnk7SrA3YTfiqZkAiIcgrNH4+ksXnXwZxaodU/mTf/bNBPGALjVpKuc/lFTV2cpVgF5T7X/ZRolwBcRl+Q52vvs8qk739cnbrS51MHEBWeSLkqXsJUEGOgBdD85v5thd4V/Jz3+zuAjflURuq7QHV2DoBgkXq+RZ5AqiBq5mulZHdpFJKYwHVO3pDA1YKfIXTE229BHtEEx84lB3UVN0t7q52/uHbFub53918/57Xgei0pFbrzMvVuUfZvxBJ54y8cdwHlEnwoEPdObpq8PgdGpbrBhgsjng1x4IA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5352.namprd12.prod.outlook.com (2603:10b6:208:314::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 01:25:31 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4778.014; Fri, 10 Dec 2021
 01:25:31 +0000
Date:   Thu, 9 Dec 2021 21:25:29 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20211210012529.GC6385@nvidia.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163909282574.728533.7460416142511440919.stgit@omen>
X-ClientProxiedBy: YT1PR01CA0084.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::23) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4215445b-d88f-4deb-b11d-08d9bb7bf4c2
X-MS-TrafficTypeDiagnostic: BL1PR12MB5352:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB53527B76F417BD64CD32B559C2719@BL1PR12MB5352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 146sBX08skqQu4AdtbzufIz9iFXE517iBXaNAKlIYrXLPf11X3rKjepL57RgidJnn0Rz3WJu6k7EgWXiB3iUCWnc3KuaD6xicWvpRBzF9ZU0TfQ6rv165fWKoc2j0EK/QQpa3bxbQ812kCa0WiRvocRjBD+RgMyCbSUPbN9Qwv/544kuJu0g33IGp1bC/Yx/a8T5NCm0EpjldULlOLIQ47Va1MqMQt/7rl1wyYLmpG7ovts8cMPo9OBLWzDwsE/LFcULa0v3W7ElokAvS4fGXAt4rIsH4offSk7j+Hf5iGYH0TQ30Yu1jHWBmOkuNxKCJW7fQFxZMPZDEdF+xjNw1x7GeKSju++27atm8LG/ubjy6WQjGrV3f2PQwZwYWDLcV1TFqWSqEAZCElKI3SdvJRkvjJEkxPOhVgHwRcwFpWVA4acQE8lbL3LJeOdXOcl/dLnlo8WEC6SM/OgP/r1e4nQG23+Tgn9O/pylqlMBjKG6NXsEnbB7AsDz6F5ba5+k74yzcYOVwJBMSQJfY6dh+eyjMnJf9S9w7GebsQO29rBwwzfYCeoQb2IM+KetA3FSye7pmvyBYCE+LQZo3h87K5XrwavGJVc3DrYYGNo5D5u0Il3TcZC35fzyMLW7NS7YlXi1OV6xprALL7lajLIHnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(83380400001)(8936002)(2616005)(6506007)(508600001)(5660300002)(36756003)(86362001)(186003)(66476007)(66946007)(66556008)(26005)(33656002)(38100700002)(6916009)(316002)(6486002)(15650500001)(6512007)(2906002)(1076003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8QeSTtW1+y3gWCrFh5U/fiUbvkWNiLiE9cHfyhbDofEhK/W1rEd1WJzAGc6P?=
 =?us-ascii?Q?9OojXr+GlwwXpeW7GcMfZI8ly0t7TrZvM3+zWDv5U8ijwifwKkVFleNgx6p2?=
 =?us-ascii?Q?XzwDHnFIyGOlX3yi2GccPySSBDoGSf2LzSVbHhUSnYHXX5vaZy3D5zB9m60l?=
 =?us-ascii?Q?D0O1ok6V9NpHtphyaaqigHbCcjp4g0Ni/2VU/HA0H5Rtalwj7/kkYLsXMzFV?=
 =?us-ascii?Q?DpsCx4ei7sx/5eMG+Chu3ZemGztS1KWnIzV9+hntGeJcaRZpEUpXsix5ynkb?=
 =?us-ascii?Q?GQw6Pnq8AcX6yyTX3B94sRq2RL1nsZa85ejeW1wooboyH/z+bXj4BOGX/LxT?=
 =?us-ascii?Q?EpzetV6dDVPWyx8h7wSzKVL+GFvWrUDyMgZ5yy3kJOMMuhdnNiLFCxCekQrU?=
 =?us-ascii?Q?YGzr8NqXtvOHw9gws5rXhabH/YjSuet4u6GZxCppisIba1sV02VMxT9rqbDZ?=
 =?us-ascii?Q?obzrsFmWDiUfchMJg553EOkWTFV4szSS6Pq4eqHs8E3/6gxkHqbNYluakpFd?=
 =?us-ascii?Q?dFnNyBW+6efUZ0+X6a9hm8HWwvEeBhrvvyIEvuB0uWX2jt77SchrG295qggI?=
 =?us-ascii?Q?VjVZOrLcOYwEHUvR8X+QnR4VTaashp36lwQJCIQf4EbXMJlKEWpNl1zNjx+t?=
 =?us-ascii?Q?A9StU3t3WHnAbdX8qyZ5lLty8F1IcTml2SgqpejA7l6Qsz2MTrUVLdmV26KM?=
 =?us-ascii?Q?Txg29jfmQ2xz1cMT/MHDSTEUuQUzbkm+HShegf6loOGTy6mC4A+0nenV8Htc?=
 =?us-ascii?Q?/N2Zoy7FW0c5tmd/z8zqj6YImfEMk3hAwObzta05X9PMVAb7NV6HtIMktYPS?=
 =?us-ascii?Q?ljSG1G/wext5lW7YQxlSDDydkY0vGdX+w/TaC+KdbljJ6YYmWwXAIBadxLv1?=
 =?us-ascii?Q?sNIZ9vNdNjR65AQxa5rkyBXLXLZ4FcI5GVa03f32ZK0Xz8NqFF2v2j7Z0aUF?=
 =?us-ascii?Q?JC/vuDwmmh8dCNMGu+AKCYvnoMkWmo0qgqoHsCud7hFA+UMsCCCv43t1f0a4?=
 =?us-ascii?Q?20SCfEePYa16RvFc5mGi1CQr7C4vee/di/hhS5sL6yS5jgkA4tAutEqy5E6R?=
 =?us-ascii?Q?MsbAlU2N1tm/9NbOPQk2/DMaseU9tKWxhAZPmBMiE8OtJq69p3UT0sHx9TTM?=
 =?us-ascii?Q?nVIRtau3frwrVM5hx57DHBw25zFcQ0dDF3WvS0ZbQSUzGRH+/hGRTN0IyWwY?=
 =?us-ascii?Q?z4Z+SQ3A2fTKE2QEvEodZ8vbuu3d2ondGyhLahV6NOtYxbx7j1z+OUbWiu/d?=
 =?us-ascii?Q?tkGvLqoaH78Ho5N4IC4CTW9/canzyvIulrZexsn9ogBX6bsCH68W2slxw9xR?=
 =?us-ascii?Q?/9ZwkFwnd4rAy/XuzzJzU4zs4diNQ3ybxPcLfkixHSxtHw0umuTerSSFmuM/?=
 =?us-ascii?Q?NbjZ3C4vCm60A7BmKSOQW7WCIF6dCXCj2zsBUX2z4RBLo7fB1oI/SHdMRi60?=
 =?us-ascii?Q?GyCuRd6YbJE1HxIRtmBghXXdWYBN6NN/YvbrL+0mXokURGpOUHxzh3s/yePB?=
 =?us-ascii?Q?oHrx3uDpZ5toQ5Q5G/+vEM3dUtS8zSnqZr6i6IX6w+lnHh4tSFDz5s9vXZi5?=
 =?us-ascii?Q?hWgcDYF7SHTsEUoFJZI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4215445b-d88f-4deb-b11d-08d9bb7bf4c2
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 01:25:31.2969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g70Wds2sgtHKCaNXAy2YAPX11U+OI8hmoiIX4gUghyS2kHa2BGDpiD3Mv+JHlmGC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5352
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021 at 04:34:29PM -0700, Alex Williamson wrote:
> A new NDMA state is being proposed to support a quiescent state for
> contexts containing multiple devices with peer-to-peer DMA support.
> Formally define it.
> 
> Clarify various aspects of the migration region data fields and
> protocol.  Remove QEMU related terminology and flows from the uAPI;
> these will be provided in Documentation/ so as not to confuse the
> device_state bitfield with a finite state machine with restricted
> state transitions.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>  include/uapi/linux/vfio.h |  405 ++++++++++++++++++++++++---------------------
>  1 file changed, 214 insertions(+), 191 deletions(-)

I need other peope to look this over, so these are just some quick
remarks. Thanks for doing it, it is very good.

Given I'm almost on vacation till Jan I think we will shortly have to
table this discussion to January.

But, if you are happy with this as all that is needed to do mlx5 we
can possibly have the v6 updated in early January, after the next
merge window.

Though lets try to quickly decide on what to do about the "change
multiple bits" below, please.

> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ef33ea002b0b..1fdbc928f886 100644
> +++ b/include/uapi/linux/vfio.h
> @@ -408,199 +408,211 @@ struct vfio_region_gfx_edid {
>  #define VFIO_REGION_SUBTYPE_MIGRATION           (1)
>  
>  /*
> + * The structure vfio_device_migration_info is placed at the immediate start of
> + * the per-device VFIO_REGION_SUBTYPE_MIGRATION region to manage the device
> + * state and migration information for the device.  Field accesses for this
> + * structure are only supported using their native width and alignment,
> + * accesses otherwise are undefined and the kernel migration driver should
> + * return an error.
>   *
>   * device_state: (read/write)
> + *   The device_state field is a bitfield written by the user to transition
> + *   the associated device between valid migration states using these rules:
> + *     - The user may read or write the device state register at any time.
> + *     - The kernel migration driver must fully transition the device to the
> + *       new state value before the write(2) operation returns to the user.
> + *     - The user may change multiple bits of the bitfield in the same write
> + *       operation, so long as the resulting state is valid.

I would like to forbid this. It is really too complicated, and if
there is not a strongly defined device behavior when this is done it
is not inter-operable for userspace to do it.

> + *     - The kernel migration driver must not generate asynchronous device
> + *       state transitions outside of manipulation by the user or the
> + *       VFIO_DEVICE_RESET ioctl as described below.
> + *     - In the event of a device state transition failure, the kernel
> + *       migration driver must return a write(2) error with appropriate errno
> + *       to the user.
> + *     - Upon such an error, re-reading the device_state field must indicate
> + *       the device migration state as either the same state as prior to the
> + *       failing write or, at the migration driver discretion, indicate the
> + *       device state as VFIO_DEVICE_STATE_ERROR.

It is because this is complete nightmare. Let's say the user goes from
0 -> SAVING | RUNNING and SAVING fails after we succeed to do
RUNNING. We have to also backtrack and undo RUNNING, but what if that
fails too? Oh and we have to keep track of all this backtracking while
executing the new state and write a bunch of complicated never tested
error handling code.

Assuming we can even figure out what the precedence of multiple bits
even means for interoperability.

Backed into this is an assumption that any device transition is fully
atomic - that just isn't what I see any of the HW has done.

I thought we could tackled this when you first suggested it (eg copy
the mlx5 logic and be OK), but now I'm very skeptical. The idea that
every driver can do this right in all the corner cases doesn't seem
reasonable given we've made so many errors here already just in mlx5.

> + *     - Bit 1 (SAVING) [REQUIRED]:
> + *        - Setting this bit enables and initializes the migration region data

I would use the word clear instead of initialize - the point of this
is to throw away any data that may be left over in the window from any
prior actions.

> + *          window and associated fields within vfio_device_migration_info for
> + *          capturing the migration data stream for the device.  The migration
> + *          driver may perform actions such as enabling dirty logging of device
> + *          state with this bit.  The SAVING bit is mutually exclusive with the
> + *          RESUMING bit defined below.
> + *        - Clearing this bit (ie. !SAVING) de-initializes the migration region
> + *          data window and indicates the completion or termination of the
> + *          migration data stream for the device.

I don't know what "de-initialized" means as something a device should
do? IMHO there is no need to talk about the migration window here,
SAVING says initialize/clear - and data_offset/etc say their values
are undefined outside SAVING/RUNNING. That is enough.

> + *     - Bit 2 (RESUMING) [REQUIRED]:
> + *        - Setting this bit enables and initializes the migration region data
> + *          window and associated fields within vfio_device_migration_info for
> + *          restoring the device from a migration data stream captured from a
> + *          SAVING session with a compatible device.  The migration driver may
> + *          perform internal device resets as necessary to reinitialize the
> + *          internal device state for the incoming migration data.
> + *        - Clearing this bit (ie. !RESUMING) de-initializes the migration
> + *          region data window and indicates the end of a resuming session for
> + *          the device.  The kernel migration driver should complete the
> + *          incorporation of data written to the migration data window into the
> + *          device internal state and perform final validity and consistency
> + *          checking of the new device state.  If the user provided data is
> + *          found to be incomplete, inconsistent, or otherwise invalid, the
> + *          migration driver must indicate a write(2) error and follow the
> + *          previously described protocol to return either the previous state
> + *          or an error state.

Prefer this is just 'go to an error state' to avoid unnecessary
implementation differences.

> + *     - Bit 3 (NDMA) [OPTIONAL]:
> + *        The NDMA or "No DMA" state is intended to be a quiescent state for
> + *        the device for the purposes of managing multiple devices within a
> + *        user context where peer-to-peer DMA between devices may be active.
> + *        Support for the NDMA bit is indicated through the presence of the
> + *        VFIO_REGION_INFO_CAP_MIG_NDMA capability as reported by
> + *        VFIO_DEVICE_GET_REGION_INFO for the associated device migration
> + *        region.
> + *        - Setting this bit must prevent the device from initiating any
> + *          new DMA or interrupt transactions.  The migration driver must

I'm not sure about interrupts.

> + *          complete any such outstanding operations prior to completing
> + *          the transition to the NDMA state.  The NDMA device_state

Reading this as you wrote it and I suddenly have a doubt about the PRI
use case. Is it reasonable that the kernel driver will block on NDMA
waiting for another userspace thread to resolve any outstanding PRIs?

Can that allow userspace to deadlock the kernel or device? Is there an
alterative?

> + *   All combinations for the above defined device_state bits are considered
> + *   valid with the following exceptions:
> + *     - RESUMING and SAVING are mutually exclusive, all combinations of
> + *       (RESUMING | SAVING) are invalid.  Furthermore the specific combination
> + *       (!NDMA | RESUMING | SAVING | !RUNNING) is reserved to indicate the
> + *       device error state VFIO_DEVICE_STATE_ERROR.  This variant is
> + *       specifically chosen due to the !RUNNING state of the device as the
> + *       migration driver should do everything possible, including an internal
> + *       reset of the device, to ensure that the device is fully stopped in
> + *       this state.  

Prefer we don't specify this. ERROR is undefined behavior and
userspace should reset. Any path that leads along to ERROR already
includes possiblities for wild DMAs and what not, so there is nothing
to be gained by this other than causing a lot of driver complexity,
IMHO.

> + *   Migration drivers should attempt to support any transition between valid

should? must, I think.

The whole migration window definition seems quite straightforward now!

> + * a) The user reads pending_bytes.  If the read value is zero, no data is
> + *    currently available for the device.  If the device is !RUNNING and a
> + *    zero value is read, this indicates the end of the device migration
> + *    stream and the device must not generate any new migration data.  If
> + *    the read value is non-zero, the user may proceed to collect device
> + *    migration data in step b).  Repeated reads of pending_bytes is allowed
> + *    and must not compromise the migration data stream provided the user does
> + *    not proceed to the following step.

Add what to do in SAVING|RUNNING if pending bytes is 0?

>  #define VFIO_DEVICE_STATE_SET_ERROR(state) \
> -	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
> -					     VFIO_DEVICE_STATE_RESUMING)
> +	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_ERROR)

We should delete this macro. It only makes sense used in a driver does
not belong in the uapi header.

Thanks,
Jason
