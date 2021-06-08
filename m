Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AEC39F638
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 14:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhFHMSw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 08:18:52 -0400
Received: from mail-co1nam11on2072.outbound.protection.outlook.com ([40.107.220.72]:63816
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232428AbhFHMSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 08:18:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/fyP765pP/gs5xNUf/YGKkqCeIedXWQB+Rz1HtHLhEmE5vRPyzVi/r12STJmxhR0p2Bayw7cho0BPuEVrAgo1zIcA62lhmVv8Ao1RdXqsQFRmoynJJo3Jx7HZV1qB2axKE4bVitGcZqxbBEa0NBi0AgVAdFRnn3DU5Snn52GqOq+h+yIcNdGxn99+4WHSvW9n3VPc6BAk5F+/VktNUteNRS0K8tqdPOvdGBV5+YIgrSdUAJl1oD/0WF1ta7wCxv+dJ4UFpeXNfT+71y3WcQIO9JwZ7WVTXbi0R8s5zBd0bLsXl4URl1ldiolJ8Rl6G+9f6hnIchTq70t3V/Ka60ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4lem4qgedCuBQdD8y7eBqbYJW24Hl8SRonUB05Fi0E=;
 b=KuIArdUKq0B3sEYL/UcnkYNJd0um1kgOIQHnJvdxpABpJoxoF9R6lva1tzKC71Dfnxkkf2tmJYiUzMTR85313chFmm1GEXkec+EwxnBWXeFqTcrqf+ynhNOAGRkzpxnedMVrDEEoO2fMhOUjuVeiKywaRfGE1VODKCZlUHpFIxNHOKzNy7sHfCjnTG3o2lHqNmglTTXlEUilf4ufdWiHLcf/EkFHysIT7ZSVc9+KD/3X9Hkbzp/mbCq60JDR13S7vtgfVv1YJoQLE8es5H7dun8OuL+s6oT0X3K+Tvg6xdsZaBUj0EgopbUk4zplcXE/1gFTBdy5apE88VcGcGFhKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4lem4qgedCuBQdD8y7eBqbYJW24Hl8SRonUB05Fi0E=;
 b=rnFX/rFYVl+gNJ3OmYlgBT8Qvh2kHBHkClqtp+dIaYUbgfXOV//oAi2TJ/qVxzb6ZrL74BEoH6gLd0W9gNpXJwu6roEow2S5QvUDkPKAgHOQw+nSGfvf++J7oKh1R13BLS2XDPvYvj2lgdqv8HsNOWgLiG2HzgpxeeAv1oDPLjOjnvhgY6239f3rR08YgER5xJR+busvFP9iSdhfCgLOKUwCKNoOKFB8Kqxe1K2qTf5ati3YHlxQMKeAknZVb5Ln7BDSyx6cq+Sd31FpQbqMfE3e+gycbAL1myz8VnGcBDLgqKjOoEEwamPmZ51HJxT54nMTl1r8Gf+mu/WLEZKgEA==
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5255.namprd12.prod.outlook.com (2603:10b6:208:315::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Tue, 8 Jun
 2021 12:16:56 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 12:16:56 +0000
Date:   Tue, 8 Jun 2021 09:16:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 01/10] driver core: Do not continue searching for drivers
 if deferred probe is used
Message-ID: <20210608121654.GX1002214@nvidia.com>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <1-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <YL8RxPEMCDTXnPDg@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL8RxPEMCDTXnPDg@kroah.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0339.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0339.namprd13.prod.outlook.com (2603:10b6:208:2c6::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.10 via Frontend Transport; Tue, 8 Jun 2021 12:16:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqaf8-003om0-9s; Tue, 08 Jun 2021 09:16:54 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ff47cb1-710b-49a3-4516-08d92a774e9b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5255:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52556881ED157F6D45D30178C2379@BL1PR12MB5255.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ws5R+U2fXhQfCdmJdoul7MNbRuFZRWoabwBIMOK0Jb40r/ItYoqDX/IeFm8/NHtg26eBmybbU+s3ilTXiUpO9EjFMe5RpBBKbgz+HbBMNS+GGG/AYYMx8+BRt+qPGXuxMziV8x3X7XGgWRj8d1QI0S7Arh0B9RFk4pz3TVVZiMARMv9IpixUUb7zfGNjmEzsCNcZXOsP/kx2tW4CqXeoAohn7EMubcmd/Yj6ESlIwGHqQEwvfJgakUUCT5ZIO6+TSc3E0KWx32nIQ5+VHiDVVLVSiGbgS3gYBEIqwR3Q4FyfCjNCmrXUqMzGb7AeEjcIxRsT7CHjW5DQOe7/Hv4ULuQ6tBxPSPVkD0pYodU1iFckFZxoUff3jRrwP5bzE6Rtl0M1BbH2P7mXwPvCwGa7Z3QLzecnSTDnymuouR78FhhISHdhYbgmNCqmp60wVspkRGXKwtC+U3ur6Pct+ZygTEj6B9hMvfpKgjiUFogQzzVoEeI9hM4s72Cv904gvWviA5OYM29k6ryKH5elE1hKQ5PLqFMi4ERMCyTMBNwjhKeYUAxdWGgA2cllI+9vnSQXQZOJQ3qnaNHdKHaVznta4MS9gEaFXfGcuMVltMwwom3W/ofeHJkfB/rrI2Q4mJu5QmBBR1YgrkxW2/exX82EFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(366004)(426003)(86362001)(1076003)(83380400001)(9786002)(66946007)(66556008)(8676002)(36756003)(66476007)(9746002)(26005)(2616005)(5660300002)(4326008)(316002)(6916009)(478600001)(2906002)(33656002)(8936002)(38100700002)(186003)(51383001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dyvTIDKspe2K2R6zIMcA2BdnKyPm1ayKMkd0v/HVQ0zipwIKMiA/gF9t1kG+?=
 =?us-ascii?Q?WK9j0nsrV/DxYC4T0X+Wb7rXt2nDxUwO2GML1riYcFaMm6+WUJ+0iLxGIX3X?=
 =?us-ascii?Q?1JrdzdxkAL/Y9HWsnhRJR2O/soD/g6QgqZO45oJFoIodquO2HllvcM0zyoeY?=
 =?us-ascii?Q?TP426TlZq+TGK4jbNfnKZD7XiNezx2voM7WKS6jQLf3nIP/9Ko4YYECc+HmM?=
 =?us-ascii?Q?Wkrjx5iae+ZgETEUl/tD7c0xu8/zo6Uj+c2GEgF8PI7wCc13mi24oSdKFZvt?=
 =?us-ascii?Q?zNV8u5QN+HezcbF+VRzZ1ZhV2IwHDTT/lnVeC5eIG1nty85soiCT5oZdY/NI?=
 =?us-ascii?Q?eO/z1Nmh349jayg1Sc5eMlYtBl6OZMRuS0d00f8y2ab24DiRuxqfVljZ7nvI?=
 =?us-ascii?Q?C0kH1ADD33Nvm83QgcT8j0Dgsnd93dP0aW8q9Ycwc8jNG4e2HiUv+SLtFQfu?=
 =?us-ascii?Q?NH69dtWd0L+O4N7M1SW2LXDf3lWrYSUtLIFLCdpO0xaDPZWgaylC5KycoGvM?=
 =?us-ascii?Q?J7xT0wNWdQNBq5onQvzpyAYA3jDb3rVs4/b4vVBzbsyMNikAEAwoF4xgZGRz?=
 =?us-ascii?Q?TAJJgHkMMU86Yd80T887NyGZUB+xzpIN7CuIaiGxmW4NtTFjS+YfUSyWTcZ4?=
 =?us-ascii?Q?crxHhY0AD5MN6V/xKjjQBOb+qW0eikD1JRVs38lxWQQBFh3hKFs70wpQPuox?=
 =?us-ascii?Q?gKUem4G0sXsG+3CyhAr01wOGJny9Hy7UAiyUFzeizhTRdJQfegp3afIKR94h?=
 =?us-ascii?Q?WdYVKkGsavFjVg4yx022jEXsXrR+GewW4VGB2AXNpcFO1PCf4XHOX0ECmRma?=
 =?us-ascii?Q?rlsjRc2HCwlyDUrqV1K9aucAaDUfFV44c64qeQyPb2kU4kzvPGNsHkJZGfrZ?=
 =?us-ascii?Q?I35GIysbn008Wg3AydTuXW5D2cTqSIcRkDK1T34C/xzDq6GoaJ2GFzTnb/Ei?=
 =?us-ascii?Q?pLi4WkltbmWVgFgCoqXjK9fTpgNzK97zLzqc9hKKCKGCLwoJk77Jbdem6BTn?=
 =?us-ascii?Q?DavVWnd4OGVL18RUF2XZxltzvmKXZ6l94elPqinMB7BbltNhqw0o3EiNy9Ng?=
 =?us-ascii?Q?/yADSPwXqeOaT4P6aR+v94pG/ee61nd2bbEjMi7jwYMTjAUl+eD66kG8MjCY?=
 =?us-ascii?Q?riN31Q5gWoSTS3Im/Gtbfo+GW1ODTvYuY7IczhmUcEs+s72us7oj1Hc+/3VL?=
 =?us-ascii?Q?PgGRRCa++x5ezc8USHIUdxYd+M5tMUigMsSr/yBwDymYBth0qb/Idrm1PuNi?=
 =?us-ascii?Q?0qkad3KVh23NxhKI3YGScwUz4bMSivJ3EvJlPu74wEVfcgnV6KljBYvWF6yv?=
 =?us-ascii?Q?TkbPKlWf9Aioqk6pDpe1KBjx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ff47cb1-710b-49a3-4516-08d92a774e9b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 12:16:55.9432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ugJgTifzNNKsiGbz/tVVoKWUWej7CI2+NwVNQU3YR6ivJUyYM2PjsnRf+gAdQVqx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5255
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 08:44:20AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jun 07, 2021 at 09:55:43PM -0300, Jason Gunthorpe wrote:
> > Once a driver has been matched and probe() returns with -EPROBE_DEFER the
> > device is added to a deferred list and will be retried later.
> > 
> > At this point __device_attach_driver() should stop trying other drivers as
> > we have "matched" this driver and already scheduled another probe to
> > happen later.
> > 
> > Return the -EPROBE_DEFER from really_probe() instead of squashing it to
> > zero. This is similar to the code at the top of the function which
> > directly returns -EPROBE_DEFER.
> > 
> > It is not really a bug as, AFAIK, we don't actually have cases where
> > multiple drivers can bind.
> 
> We _do_ have devices that multiple drivers can bind to.  Are you sure
> you did not just break them?

I asked Cornelia Huck who added this code if she knew who was using it
and she said she added it but never ended up using it. Can you point
at where there are multiple drivers matching the same device?

If multiple drivers are matchable what creates determinism in which
will bind?

And yes, this would break devices with multiple drivers that are using
EPROBE_DEFER to set driver bind ordering. Do you know of any place
doing that?

> Why are you needing to change this?  What is it helping?  What problem
> is this solving?

This special flow works by returning 'success' when the driver bind
actually failed. This is OK in the one call site that continues to
scan but is not OK in the other callsites that don't keep scanning and
want to see error codes.

So after the later patches this becomes quite a bit more complicated
to keep implemented as-is. Better to delete it if it is safe to delete.

Jason
