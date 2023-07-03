Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4771474649A
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 23:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjGCVD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 17:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjGCVD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 17:03:57 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4AEE59
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 14:03:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRkTg48QgXMFflMITrnB3p7recnwHc95EpwcwByH6zuoW2i2+YH6w4RigItXbpkrhWcoPlzc7x5mwdBzA6+TbLwzhZsNug2ufluqLyMUaydZc57Rdk5Bw97HnJ1d6Ruo5t4VKRes2biVwQK2CMrdArXfOqc8bfFAjyNOP0koafifkyOlVMv2+Nf8PlxK3Ys7tA2QPLqT356uN+jQdQY/Nc3JFNed/fQI+G3+Lt5H/T4h4CQ/+93OYl705wQ1ypR3OC2/gBneFWMWqMqZPphzqtSQ5ipW4+OlWOtFt+1yWEakLqCUHvzL56YQxjkj+OfgjmR8f9mrcOFgUi+tLr4tQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qlp0aSYJcMnoA3h6RPh5LP0WQbT0vWUhhkAEGJUDP7A=;
 b=nlxSeMfE/goHq4IRQtZ0a/DKiIZ46mIUMEQbS/GTL1T8Sl9GfXmAU8hIp7P9t5PE4egl+kHGgNVTiK/esvxMNTqpNflmZl1zXil8imQlIf0M7I6j3HxiO7H94J0AhdEdKGGE1MBMkBQ+fNFRK6JdYSgY3s/zcNmA8W7viJMJW2FJVE9bLG3pggjPHxUBF9lFZ5v4z2SXRhKKixZH4PQ9LQZjJWbKlMoLwGJkSK4kEq35ROmmA2Av2wGvFeCkFNUu/rdVJSY5Ri7ruj0prz7IbqEz/rNRm89PJZkEwg0TEFTFvC9emqy2LTFXamDmZJl660lvKWeM9dLHn/9evfka0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qlp0aSYJcMnoA3h6RPh5LP0WQbT0vWUhhkAEGJUDP7A=;
 b=MCJKpH2h9oY1EjP5d6zgUK1kA58YfJsgVnIUaNAoWgtENLvuKs/YVnnbJsB89w2skZqWryN8WCnYRnBsNlW00isDSMthAavGq9ffOxNU+YtfBdPpGb4bC1JW7JiS3La//MLX3Cr4hyHHEJvwOfnc3rYz804PgnleZTc62v9qtRvm3psRfnEFLVTi+Nzs+1YdRK7PnatJE2CIcD6jq0bMBUp0+tOSGyaZQldcy5/4dda8kVjvJji+Q3fMxJpki92axG/Y+qGbbUgKDLtVmSBfddHdkxAmuWNw6LGi1HzIYfyUFA4dq+imN8DN21Bu1AO36UpTirK1EjYR+9eFUzdpcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7911.namprd12.prod.outlook.com (2603:10b6:806:32a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Mon, 3 Jul
 2023 21:03:54 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::b26d:72b8:be41:2f0c]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::b26d:72b8:be41:2f0c%4]) with mapi id 15.20.6544.024; Mon, 3 Jul 2023
 21:03:54 +0000
Date:   Mon, 3 Jul 2023 18:03:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Cao, Yahui" <yahui.cao@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Lingyu" <lingyu.liu@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [Intel-wired-lan] [PATCH iwl-next V2 10/15] ice: save and
 restore TX queue head
Message-ID: <ZKM3t7FDH09zeJg1@nvidia.com>
References: <20230621091112.44945-1-lingyu.liu@intel.com>
 <20230621091112.44945-11-lingyu.liu@intel.com>
 <ZJMLHSq9rjGIVS4V@nvidia.com>
 <BN9PR11MB5276EAA78AD4E3B7B7A93B168C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ba8ccf89-6045-4fd7-02b9-308d50226251@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba8ccf89-6045-4fd7-02b9-308d50226251@intel.com>
X-ClientProxiedBy: BY5PR17CA0006.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a0d455-206e-4c5a-8757-08db7c09025f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Rp+ZUtfIbEKunuTa5j0Kg/fuCGaL69G5bglpNrcoDTuVOgOAbwDlR2E+icCtn/z3RdExQTYw+RQfpb7vnUwdwpzMRV6NSel82hGY/z0wIjcJVugfa21LVYQw55jsdhUaYYHapGC977C8TMCRTjZ4kxmijaLL6cyhAtvfJYniTLG8sicFIp/DpktnT8hYl/uwy6eX285xjPYAO5sILV5RLF6pBA+nHz+pSO5uAOgMsThXpDnMLbEJTETZWrP57bNc3u049GMswjEFOc3mHsD0SDHIbJTXwCcVD4vHRL7KVpc60krt+MwNfbFCY+txVbkThvyQLsLvrtzRsoQIDhgOlT/gg2MVS1dhPd6WyttLHSEyVWMCmqoy7e5CRRm8mQvTfpEwXYqyo4efQYQ+Nu0WaxmIdwO/wCh3AMs1nSd+EE1zfbDVdUfXoTCSiTa5VKOuAvaEnOpWsmwdBl5GuRO79mUswHGkm9xRxYMsKqskxlV5JNO1k0o9TxUlSAzOLxOzclrYFgyUo1O0XVNUfpXDAQTcJTSPu9o96bYI2iMnnvBbl/RGSm5SN4lN6wsfLxa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199021)(66556008)(6506007)(6916009)(66946007)(4326008)(66476007)(478600001)(41300700001)(38100700002)(316002)(2616005)(83380400001)(186003)(26005)(6512007)(54906003)(2906002)(5660300002)(6486002)(36756003)(86362001)(8936002)(6666004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z0kGs0IoqkZx9qLZZpaJJ2bmUE/51JiPTEYCwryjAmxAD/mqiENtPW/61duo?=
 =?us-ascii?Q?J+zOHJAKoQFLybhqcgHyoj6CnxGnArMXKGtaME4QBRhJGx3QTlkjU052n/J1?=
 =?us-ascii?Q?lJVfWt4hRIzFia6dYTTLZfcRlf0hszkNu0L9DFtqfJv2j26wDgc29kSvr6Qp?=
 =?us-ascii?Q?ECkEeoyKxhlcT9GqYeuhWLl8+wqsDDg46/dXXBkEQj2hGk+/ZbkVsqmnS1d7?=
 =?us-ascii?Q?0mc/9D65dS6LqSwJbFJahqatVLF+UwHqazx6/njkUcSKDfwDK77UrBMAU1Fg?=
 =?us-ascii?Q?UDNXwHjfPhrs+tJJGR3nk0qFLXVbf8+wUSn8CVAbMeHolus9iSkax8h7EGpP?=
 =?us-ascii?Q?YF4OjYVksk40Y1J8VW2MabwKoT9KA6wwM6TQrr1n2fem+g9QRaPexW3WAQo/?=
 =?us-ascii?Q?6FE+F4jidVdsUi1nhDmXkH7fWJboiHO0bHRZG1aiVQ7k/wm5p1vIaU17dapk?=
 =?us-ascii?Q?Yi4AwjsJqNhi85nY15XLh+uj7z365xUAu3Mu0g1DopQz7ebhpVH/7WAOxxtg?=
 =?us-ascii?Q?lcqUp3GYtRUGKRr0tGTZYZ+ced1I1t/VoFUXNFi4A4aWeVSO8uFgfohMSzPo?=
 =?us-ascii?Q?EwOAGW+PNn/nMi5ln5I3VeKvLvQtjbliz2TgkiRkLgMJeY8BuLhtYG5hFwdY?=
 =?us-ascii?Q?wF4YBD2txfjLcTRhqBKjiDhVox4Ba0fez1lBwEiuS9fXLmkWPgLhkoaBf8WO?=
 =?us-ascii?Q?iY1IY8YYW91nrOZNGR/cbbFzudcHqZZlpqnkyC2y7Y9A0elGFFWlUdiDd2r/?=
 =?us-ascii?Q?HXRfd3poaoJtS5MiejxiTwksAToMPdqqe4j8dtslSZ+ZuWodX0ELjJb2CpiO?=
 =?us-ascii?Q?aDpVhtU5+j1EuoQSi/3vl/PXiWx/ItQtPvmRf/YI9bBawzChrwQn4vZSdl9c?=
 =?us-ascii?Q?KdP+3WHmK3HMD3E7KbwNkY8T9yB9T1685yx5zUoZ5oU5vySb3JUgqTC1g1l4?=
 =?us-ascii?Q?qXcn91JJQq0O/SjCwRdkgXh2d83z6V7w0AVKS4qQ+/uc6+5aYLXWCJKvjP6c?=
 =?us-ascii?Q?sLexZkZNYdehgbQ8Orry3dVQNbqh1IyGdurzFvEfRC3YTFSUQvlTvHKnc6H7?=
 =?us-ascii?Q?h+9SKhI3FuY5J7aB5akx84vz5/qVLQrZN65boL0dGoSgxla+26GRgoZn0JXl?=
 =?us-ascii?Q?1lcfJ8eDs9TiXm/KHgWOTQ+sZbD6KhqIlU/qKFy6RvD8v6T1EZeDga7vkJPj?=
 =?us-ascii?Q?LNT0xVmB1nTMg3PSdwOk6R4KLdp8r3Ku8ZMUGAix13SZC89xGKDw79m0jE9Q?=
 =?us-ascii?Q?Q3WLlWvCUMNoikbNsPgsDIQcMSsVdKP407BSMkVJ1a2/NrcaeuljPHsNa3PL?=
 =?us-ascii?Q?TYh7ecWllx8MCAEbFVV0enalUEAnI45Kl5RcC9ZmPavxJcLeWO4uZcIbGHgx?=
 =?us-ascii?Q?DTVjA0cAx/AywrP40fXaSFTQEaDBGLmMa23bTCGJYxxNrLzFLrsfQQnP6CTu?=
 =?us-ascii?Q?hyx5pLzNWnKYZ+P7TFjJIAVmZPSPK3k0Ac6WSswqftnsFwxdSphTO4GxTtnp?=
 =?us-ascii?Q?dwrl7jEFcOGJCVRYTrOhumaSwg06MMiM9fl9A2kGVtBvdsUof2igP832FSYT?=
 =?us-ascii?Q?QTWgFPSzPKx/NOP23/NNKKpUp8D2/tz6FayNQjjp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a0d455-206e-4c5a-8757-08db7c09025f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2023 21:03:54.0579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O0rKOW092b5Q01Wuc9e5wlMow+DxiHGo1sTAlo9456LtH/7kSSKSb5nA2iXMceuJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7911
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 03, 2023 at 01:27:51PM +0800, Cao, Yahui wrote:

> > > You can't call VFIO functions from a netdev driver. All this code
> > > needs to be moved into the varient driver.
> 
> Will move vfio_dma_rw() into vfio driver and passing callback function into
> netdev driver

Please make proper layers, you should not need to stitch your driver
together with weird function pointers. 
 
> > > We also don't have any guarentees defined for the VFIO protocol about
> > > what state the vIOMMU will be in prior to reaching RUNNING.
> > This is a good point. Actually it's not just a gap on vIOMMU. it's kind
> > of a dependency on IOMMUFD no matter the IOAS which the migrated
> > device is currently attached to is GPA or GIOVA. The device state can
> > be restored only after IOMMUFD is fully recovered and the device is
> > re-attached to the IOAS.
> > 
> > Need a way for migration driver to advocate such dependency to the user. 
> 
> Since this part is new to me, may need further guidance on how to resolve
> the dependency from you and other community experts.

Personally I'm quite uncomfortable with a driver that tries to work
this way, I'm not sure we should encourage this. Can Intel really be
convincing that this is safe and correct?

Jason
