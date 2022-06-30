Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0DB56273B
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 01:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbiF3XoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 19:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiF3XoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 19:44:19 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A670313BB;
        Thu, 30 Jun 2022 16:44:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZDubsS8zNcdIAqbxYGMBkPwRnU/UkrLQiDvnSH7ojYNjRjuL31cpWPtgA+8Lg8AXFfcpAPcqMvzZxKgWEqn5WxVeuHRZo7g+tpWWZ8YbGCjlucGbF5IfFTzW66+g9jiJDbI31FA3s5+OTQv5tKm9ZF+65Vgyfk9a+fb7HwPyQ8YHccwi8HYbZxNuNgQHZe97++5IajF9rUCXOy66tbA7at6wT/awLxBzU2udYO37O5Wly+re932gZ+byAQtp/f8TXmC6KlJopoGC9sCB+/Pw8iOZo/X8kFNazbxXzzyAou/DfP9fm1NoKrNZ4GuFw8AqFeqIaN5Gi8I6TIKGZsY8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ThiCwWD73k0/5iUyogczMz517on0EPPXyN3KVIEfvc=;
 b=ZHDElqUVIOx8cd+snOTvLEyJ+4GJaIe42RKXDiipcR/J6DlIbvlTVDcvCPLcl1GV7iiYLEmGd1IZau+j1Klhu+9sOu4LiQR7Xu1ZsuWMZAtwQNzTgTJxFg5Ll+jdfDjHa+y2RKzm7HGb74aGe2a+2Ry1DmwLYBQLK/zO2wj9VkVcrygkpImI5ted0uasESSLYf32THEzJHSu/KIJik/SmvqWgJnevUIMdswaLYC52sPUhlavC6rxDCceJtyBzWN2uCWqSALsRPjzPGxNJzSMoJ2Gi3CfP5fe4hwBGbsp+Cx2yuZjHQi2tBQhK9cZPubPBNCqqICA51HKoYwDwVkrog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ThiCwWD73k0/5iUyogczMz517on0EPPXyN3KVIEfvc=;
 b=Rt9YLz/EAoakn6EBwQlpxWkGkCsdljdiF3UUU+TaNckxHeUwvLP5wM0u9dyjPeIa0z9Dq4l4zYAhN96WxERd2GQ8zCdpk5Z6cqfcbdK6pXfXwa+kYXXX1jx+QocTUfDdEGDKeB8eD97++SCUhO6B23quVqhhO4XPSAM2SICznUi7pIX/dRIV6bK7V/Vs6R6dbZWOrExqw4wDb78/1vzFHF+Xcn13D70oVoLmsUO+S0Y1ALH9qc/Q/KO8PXZghiX9TalhN6lgcsRApG/hbv/X4TX+rZ+vgdSm70XNCeQ2niS4oYmPHmDSfUMue2oYGuQkknv/KnBSDIaw8IHDZ2LSxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY5PR12MB6621.namprd12.prod.outlook.com (2603:10b6:930:43::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 23:44:13 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5395.015; Thu, 30 Jun 2022
 23:44:13 +0000
Date:   Thu, 30 Jun 2022 20:44:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v3 00/11] s390/vfio-ccw rework
Message-ID: <20220630234411.GM693670@nvidia.com>
References: <20220630203647.2529815-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630203647.2529815-1-farman@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:208:256::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acc1941d-ba98-4631-b57a-08da5af26fb7
X-MS-TrafficTypeDiagnostic: CY5PR12MB6621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ZHIT7qr5h6QipyL+FYesq8eyvRmkaSSUINN4b6943tIUo6t3EFdv9wf1k2v1mnRaOc8kAHbQLLpoVqEKOSKIyth3HrgQeKR9M+WHHxoBvbi+VQeza0XJ50zEcQ63Rw9vKhiGufPsHFcNURLj+bVzDY9W4t34rP8EA6U+JLrTNOP4o8CD0YhYzxr3GgYnpUqSDtihixBgl/bWNqaoB8CTpk5Hbm+qz9jzeQScIYsrWyeaaars6HK4nlpgVZwyCerX3lvnb6S8BgI/m45H5Wtf7X8vptjinxrg4B4B1lxvJ7bHkGVy/RRFDzTRrE2uwC/w2mQ745849BqQYNmYhfHks1Sfu2VQ7CpzIQLxm7MGjTASLcojmsRtqbY3at0hYmWl7Th4bswHqiNzYiY9rHboIR4yT5clyqFN7YuYI4taFF8uXrJuBF8VxWzofxnYte0ALIU1rLJ+0isO8C4Vj/S7Ooxi6N33f5yWd1MN8UH55MaG7VNjsrthpd72QbyN0IX9ZYDs1SHdfEJJnWESLa03zAI8dqtVccTda75Yw1qM/E9tuWnPoArnR4sDGdZjpvlGbgwnUs15aN4V3x2ukO+OaBS8WNNa18SJ+CCHvCxeWDnyUTcPD4TjAFJnNSRius+mpQL7MJXOW7jmF/r5eTFczD6G/A/pWpDcER1X3CjWbDlzwv0Iu2YNnqt8PsGNJYWjU3dFhWK3OogCz62Hl2kaaySvnqiYk0leyJrJ+uZF8BQdJzK4Z3AeeOgplC/PP9EY9mjr2TvfLfj+k094xcqJYtXd+MMZYzpz9HrAmNOatTxr2NN+0Tg9ek4oygUBgQo5KSzY1dD/0GMCkcxvPN39clBglRpcYDJDwoQvvlS88+8ep0PM5YpecCgC4DgR5HT/J8kIvKuD244sUtZewnI3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(6486002)(478600001)(966005)(2906002)(4326008)(26005)(6512007)(6916009)(316002)(54906003)(8936002)(86362001)(5660300002)(8676002)(2616005)(107886003)(66556008)(1076003)(36756003)(66946007)(66476007)(33656002)(83380400001)(186003)(6506007)(38100700002)(41300700001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/9YH30lXtC9sW3TBTa3O3Nbw8f+YXpJDLhkCTuh0XDo2vkcOHjm2Q274iBS4?=
 =?us-ascii?Q?RJA5ViSx7hM7u/5EREuN5Tdct2KDeLHBmcEOVbeESi4EY5oahtUPPOR061lK?=
 =?us-ascii?Q?DEL31zNZMXsH8XY/Uxv2vnFAZzfeymQr/6T3H4nzy7V35+3PImwjHaC1uye8?=
 =?us-ascii?Q?+ieeI1stK+mcX9r/ah6Jta/GrqhzdadHGstn8qzQy8SyMee0f8/uRh42vlaZ?=
 =?us-ascii?Q?8XkPkXD1Opq4QUqYuwUbadgPUlj7IFbchh7oJNmsziBzjZOSdpn0NqoncaMz?=
 =?us-ascii?Q?9iHQBQXZwaKAeyBWX80DOcDvyUtKA+RoGQr2AntXvyuQwxlBzvDW7xA/Anhq?=
 =?us-ascii?Q?1cUETkHWNyc8XtDAohbWhL8LtRgRACew392fvYGqWFiiq9+QqluKgc+0YUdK?=
 =?us-ascii?Q?Thx/olkk/J04bJrgY2/UNieyqFKtq3VnOEheKPmBioPmYji7zsXnBxdl71Mr?=
 =?us-ascii?Q?3BlUp5Re0eUX89AAyVxoGwcr4Q4XVtAwVcAP39oPqFfWSsilGQxXbKIQMCZf?=
 =?us-ascii?Q?B/OiD5gi7wdnrUu1dyinVv8Cs9mzPOWygrL4dMQx0ht+vB6zngK0Kb0uLgsn?=
 =?us-ascii?Q?ro32RcZ76LwKC4xmITBHrUKAdHpvHUKVE4ZiUCWOD+Vku8M6dudvgEC947oA?=
 =?us-ascii?Q?QZkrEFdlnFBPFOBWsQMu5WB4juWdBFAixuOIaiTtHQWSXE27sDNBHjoHgKNc?=
 =?us-ascii?Q?8tzgXgs5vKHkZ+rxjuqt1WE9aSg4fNlANVQyqns03Vod2ySs3jHd0IR/2ZW/?=
 =?us-ascii?Q?WIyFHvluoKPFhVBQ78tmQCh6WIX7faVl9ezsAlnSus5dFqFKmW9QfuPfKT3M?=
 =?us-ascii?Q?pGG/JIc7SXjE5GaM5tD9wLKf+AX6zpRX6PNA1bJscmgACA0ta8d0FDdFvNgG?=
 =?us-ascii?Q?QWNceyWefVaH90TJuOwFRGRzAcP4D7PSJmHc0BKdVEo+77tjyWgpNZT9XXMg?=
 =?us-ascii?Q?fTFzBEIr0RQ+oJyIdb8n7KkMF+pf3Qb05fTddlEF04yC1qiceKSaBnjS4ksO?=
 =?us-ascii?Q?XhV5cd65xTn41a1G9Ebfi7w/V2gBhOsPj1Sl8uxpDFCHp/ih5NxAtSitrs8C?=
 =?us-ascii?Q?IAov6Fp6t3xWFXnOtZMjbichyun0JLhhkFMPKA65kfmoMbQlTJU4vOgC6qij?=
 =?us-ascii?Q?rPkAdoMHwvCELQS1TQg8omZoyok54gDv+Qt5Z0x+sSd6zi+zjBy0DATuiXYc?=
 =?us-ascii?Q?Z/UIfWca7JX1ImBjGoIOu3+naQwwVOKONmsE3WrFxocFFkBl1ktBbGrMtfLW?=
 =?us-ascii?Q?M2h5gn2sNhw/RJaokhsYLOmh4qTYQhAxlkTmmjDPRs118qNv2nf+ZNUSiFek?=
 =?us-ascii?Q?WfDuFzIfqZalmHM/SXfPM5xULBiebF4WZ3KAjLtX06T7sYQeyN8/oe2mtkhk?=
 =?us-ascii?Q?uZxwfG+5fwbFvs4Jw5OnZQ+du7+dIv2DN9IuL9RluS4HcVqeF/aqV1M07php?=
 =?us-ascii?Q?eWK2DMNjQ9XUjXHwl7x72j2D8qoCdat7miqZ4tpLG0B2g0SX10Wv1KMTJ6Sa?=
 =?us-ascii?Q?KWRM5g8PQfbMVAUzJlkibJ0KWNHf63bXCbH8oXchHM4N00HVkv3TY6IQAitu?=
 =?us-ascii?Q?Tok+5rOu6TvAyYe6bUt9ICcgDiYP68XOqYpZzPfr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acc1941d-ba98-4631-b57a-08da5af26fb7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 23:44:13.0961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V+XH6ke9fRIze4eJBahubwpIIfVrPIncK0y8v0bwSyWPfek94EfY5ui+0pvk03W9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6621
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 30, 2022 at 10:36:36PM +0200, Eric Farman wrote:
> Here's an updated pass through the first chunk of vfio-ccw rework.
> 
> As with v2, this is all internal to vfio-ccw, with the exception of
> the removal of mdev_uuid from include/linux/mdev.h in patch 1.
> 
> There is one conflict with the vfio-next branch [2], on patch 6.

What tree do you plan to take it through?

> The remainder of the work that Jason Gunthorpe originally started [1]
> in this space remains for a future day.

Lets see.. These were already applied:

  vfio/ccw: Remove unneeded GFP_DMA
  vfio/ccw: Use functions for alloc/free of the vfio_ccw_private
  vfio/ccw: Pass vfio_ccw_private not mdev_device to various functions
  vfio/ccw: Convert to use vfio_register_emulated_iommu_dev()

This series replaces this one:
  vfio/ccw: Make the FSM complete and synchronize it to the mdev

Christoph recently re-posted this:
https://lore.kernel.org/kvm/20220628051435.695540-10-hch@lst.de/
  vfio/mdev: Consolidate all the device_api sysfs into the core code

So this is still left ?
  vfio/ccw: Remove private->mdev
  vfio: Export vfio_device_try_get()
  vfio/ccw: Move the lifecycle of the struct vfio_ccw_private to the
    mdev

IIRC Kevin's team needs those for their device FD patches?

Thanks,
Jason
