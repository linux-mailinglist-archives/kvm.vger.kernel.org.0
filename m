Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897737B051D
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 15:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbjI0NSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 09:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbjI0NSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 09:18:23 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCC2F5
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 06:18:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFnOVacRF91U0e3G4MRey1Ac14gaHGs2Xpwa11RZrouVh0Lfh0TH0YjBaUwePKqjKyjdcPP2Kug2ULrWGSVKUtQWhZnZYZxi6EIwytnZe+pn+u3n3PQvyx4VWp3aEyRaRjGKWjwNvr9PSQZ6Sq6FwqzyHpzNWogqZlcU694FYod6Pe3wzR99gnVsIHOLRBE4EQKRyrRkruV509KjF7DzmZKKkuaMI2jRCLd8hmbinwlrpcRH7Xo0h9rRjPGCcChwbSZyWhsm0S73jqjUzsUGf4v3HOgAKKkPQLqid+F1tdfMZiTtoTnl4oPBSaNpoKIWsihOSMSwZ6hg66DLvTVDrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SryUiuwjjSqn42huF7C0n5MnS5q+6pzEvbndRzDz8JM=;
 b=AUmq742pLQn6ZaUboMcQm7gdQHBSAmwnQLVUom+cBs85W5rcmf8bSGCyh87PopLagPW9wy7TnAb38hONzpAivgFJo+AkwK4bzndz2I5pBkku1/1cXq5HgEOYWRLAxO5MyjS3QZ9maEp5/lnRxThJ3r+daeUJSTignPeJtNjm06xBYh5AstVa3SQvWRnDsPwEpXrpucdWg39jAnvfUA4s8YNybFC+ztfarVqBwew3gLodLRcII/KLA8nwt3VZe2HjrJNLExAcvxJk1DoFOuChopM0dj6QaZYDu+pV7w2OWx5fWRIRzSmiFyuYz/jeaIj8JB9WSQCvOqHgLqGhBwSHvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SryUiuwjjSqn42huF7C0n5MnS5q+6pzEvbndRzDz8JM=;
 b=U+Tie3AnL1Q9CN/Tt3unzRQOdKYeWhEuVVO0lQaxc6mcX5aoViVgiYRmg6hhK3kbRUNgOyL8lK/cgCbUaCwGrYygNZDuBaBz1jZegrcm2OxBl6viMJL8AX2d3FF1ylvXEbYanqd58lsv1JZpQjdhzvuaEFmZB/rgThkhoIsdxANPo8I+GwlpAe6dgqtPSWBvS957q6MW+rPe6ZvSivM3teU5HuyNpEgqHNXl1G+GvAo0AedV58jkUcOcLJ0R0N7wc1jAmsP47B6WnZlIdoCl2oPt9ObFvbq5De8tem8Xq8NfmnTGDe/YKPRrPVMXfqCwEJkJe7yuwc4Q5xpil2B8Yw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7364.namprd12.prod.outlook.com (2603:10b6:930:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 13:18:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%5]) with mapi id 15.20.6838.016; Wed, 27 Sep 2023
 13:18:20 +0000
Date:   Wed, 27 Sep 2023 10:18:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        maorg@nvidia.com, virtualization@lists.linux-foundation.org,
        jiri@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20230927131817.GA338226@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
 <20230922055336-mutt-send-email-mst@kernel.org>
 <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926072538-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BL1PR13CA0326.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: 3972c7be-4db6-4dd9-4b62-08dbbf5c3731
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hrXsfijlxbdI4JVNUG2t+8om/sczbXzb9D5KkSQ/TQ7fb223Ehqr1pn9I4KWYQ0DJi7ZcFPCNt1+xin6CS4vTWt1yGuv12VJGS/bEnc7DZp2bcnhQpO6yytFNiykJdsNpbrb82ppDVgGysIxXYRiOFuRFGitJURxnsqqJ7TnOn3K9EF5KMakTZwRjG+akB7+GjpAtUMMYcq+zbXF3LjDvZGdS4yckAp9N3E1pcTjC4kVPpmXrCo9tKX3ku5zAH8go3AEMqdqr8pVdp+9hQkQo4nDNqgDIyVr3WcWNKCFkxG7BdP1l2qqtpHaY//kjnWpCY+YJ8LdCVfsIxDKhqAep9OCw5hHs7pCXHKIAaSnDteXbIzEjpeOL+CEsH+uLJoVOmvTUOfS6pn5hgMOt11UC7l9+KAoYvP5mfxqeCdhpz5Bv4MvRBwecCJnjcNhnxxdsozOOlBujX8PYzZjcjMBAgekufi/jH0EO6urp1o8TvGOzDfIa6X/Bq+Iz1+giOIDoHeEbVxHc6pX+LzK4HMbZdFRIOeNKUPEoQi1agoKTSpYNFpQ9hBDptr4U+15eK3vxseLLNd4XH8zN0ibu491BUYokCaXHWNLd4Ma3ey5GWX6zU8Q0HqtgETQ123ailWp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(366004)(346002)(376002)(230922051799003)(451199024)(1800799009)(186009)(6666004)(6506007)(6486002)(83380400001)(2906002)(478600001)(6862004)(1076003)(5660300002)(8676002)(107886003)(4326008)(26005)(66556008)(66946007)(8936002)(2616005)(41300700001)(66476007)(316002)(38100700002)(6512007)(86362001)(33656002)(36756003)(66899024)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JjPzeS1jX5x1HAIubMHUIjpADfI0sgPSBeHuBfAOau1yAgLSMkG6UDuX/3JR?=
 =?us-ascii?Q?Qvg95iagiGFletlZZPYSqrw3U6zhXR2YfcnGtvN45uIryKh8TXJNlLVc8V+q?=
 =?us-ascii?Q?3bVWDzm74hM5yQY7qkYXApMzFb+X45RXgqvwgsahuvXFTDSESnwPZsbOROll?=
 =?us-ascii?Q?nMrkyaDf5DVsNkDxy904lCG9uJ9ZkvKVGlI8UFXpyc0CGSBpwbkuqUTeCNpQ?=
 =?us-ascii?Q?CSwIk7nYAntPIiI0J8oyZqG9gDC4ncom5/KshT0ReQulzvqs1FlO3JwMLh1o?=
 =?us-ascii?Q?2JQ6Vw66mTU5hBBRYmML/qzaWlVMzWa/wZwU8kqXnYT0+pgBkK5aYlSHyql6?=
 =?us-ascii?Q?WNAtYjh95GIary7oS3SrshMMh4LigffAt6bKcYGUiYcIEbZIsWg6+SO1Fg1A?=
 =?us-ascii?Q?SKc1PfSykyNidfgOHCkip8beUW6aHnJhGFbAguP3OMY3sVu3FPFxdyPYXMj/?=
 =?us-ascii?Q?G6DON7w2LwpAy3oFHsaSh7hGjI6jW2QCQvGKuX0Ll+fHa6tjf8G0hJUD16ji?=
 =?us-ascii?Q?+v5WAo4wTydpjtUFLgri/zgVq2PUpEsfWZHzIDrelMjc6sOFKUbi+Kubnpoo?=
 =?us-ascii?Q?0rh+zljhAvYEvsqn+04D2/MnW5okI1wFCERlungt8KI7w6hHLvCwsUQQCvxY?=
 =?us-ascii?Q?w552JuYVWy8g9MD5KjMSliG0v+S1nrtUPxV698YRifuCMKkXF6mcvHOUMOg3?=
 =?us-ascii?Q?NQ2UsGcwulLL/fmYBq0+XqSkaiTSeJ0tTDxZRGLThCgMpxcORt2BJA0oT8NZ?=
 =?us-ascii?Q?XtuNH/kDj3VzOoTK9Rxlu/vsL4vtQLsDP1whvsmzV+e4QxfXfSOf1xo/lZNe?=
 =?us-ascii?Q?cBDR8dl3gWjxHfiBJC7yWyqsIFH/1UAXiSAhnel3MVCfw8NqQh6wSWJZZ5PG?=
 =?us-ascii?Q?RnZ9I1eu1ibXTTZ4aRFGE3NcTn+WT7LzVyVTNVVo/u3oaylcdubXULph7Rge?=
 =?us-ascii?Q?TBzP3jVzL6TChBfQr0BL4AuPcrp0QeubN96y/hki9q6KvKuaqIqG4HFx9gOX?=
 =?us-ascii?Q?dlVBRBgF5NrdAZxrtrfXYmT87jBJXd0HWLK9vKqYiHi3Ak6Ev8WsmoPqIrwo?=
 =?us-ascii?Q?BRQ4/VzG6k696TY+LAJCQRkphkNyWVPAQnPJjHVF9FU5WJHF4aD3FLrGZYYF?=
 =?us-ascii?Q?+qvGfDm0mI84Z9OW6KYgfXx36Vo9M1SQTt3fjC2QxA3TGyvniaHXkh0tzDGT?=
 =?us-ascii?Q?nYxICSLYp+8da1v/556Rw2/mEvShv0Ih/1gce6g8CITMYcRNrMBysjzXJv6M?=
 =?us-ascii?Q?xgPFfGI5grVWkW7VmTX2yinG7/oHPuuRPq5bcYuEL8EK3kryX4rk0IvXVPxd?=
 =?us-ascii?Q?Z5vXmH+dybCZEa1x4/JJB7rMPS0mcIt6uMvdQcUi37elRDbutLmtiKta31pk?=
 =?us-ascii?Q?/Rvga6lohdyJu2sHbqFP6Nz/RinCHWU3UekmALwSj7m4+rx+USCbWLg2/4l+?=
 =?us-ascii?Q?HJ9qwOjpzPw11looV/WEKOxJK7M6XiOCzR37y4KGJtkZkND8uQBN9ltC5pAB?=
 =?us-ascii?Q?AnfZhiU0QvPm1mXg3qpRNOQsSYQSvZTo7wgwGLpDxQni1fEc+srGI3UHvXx0?=
 =?us-ascii?Q?s32n5sggJd5vQH3D1Ikrqes4rzSQ5+zxueVVsNWj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3972c7be-4db6-4dd9-4b62-08dbbf5c3731
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 13:18:18.8223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H1q8pkeg5EnaY+Y9VA5LVW88CxEFxceuiUPU/wyRuL8HfQfmoHd3aLmSKZZNen6H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7364
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 07:41:44AM -0400, Michael S. Tsirkin wrote:

> > By the way, this follows what was done already between vfio/mlx5 to
> > mlx5_core modules where mlx5_core exposes generic APIs to execute a command
> > and to get the a PF from a given mlx5 VF.
> 
> This is up to mlx5 maintainers. In particular they only need to worry
> that their patches work with specific hardware which they likely have.
> virtio has to work with multiple vendors - hardware and software -
> and exposing a low level API that I can't test on my laptop
> is not at all my ideal.

mlx5 has a reasonable API from the lower level that allows the vfio
driver to safely issue commands. The API provides all the safety and
locking you have been questioning here.

Then the vfio driver can form the commands directly and in the way it
needs. This avoids spewing code into the core modules that is only
used by vfio - which has been a key design consideration for our
driver layering.

I suggest following the same design here as it has been well proven.
Provide a solid API to operate the admin queue and let VFIO use
it. One of the main purposes of the admin queue is to deliver commands
on behalf of the VF driver, so this is a logical and reasonable place
to put an API.

> > This way, we can enable further commands to be added/extended
> > easily/cleanly.
> 
> Something for vfio maintainer to consider in case it was
> assumed that it's just this one weird thing
> but otherwise it's all generic vfio. It's not going to stop there,
> will it? The duplication of functionality with vdpa will continue :(

VFIO live migration is expected to come as well once OASIS completes
its work.

Parav, are there other things?

Jason
