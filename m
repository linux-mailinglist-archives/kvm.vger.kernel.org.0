Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A9D7706ED
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 19:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjHDRSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 13:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjHDRSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 13:18:49 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94178198B;
        Fri,  4 Aug 2023 10:18:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d4BJNbeuVOVUm7W4B+oaFWBNgiyzr+xYOHz3/plMsMeydqgAjADUVEoN5F9FaWspzVoza3X0HUNg0an/ibYtrASOEGJNConXE9Un01qE45JzR487/WcSdP9n/8h0JZhUozyKkb7bE++Ct51iXCu+M6Lz68wV19vxY/5qMo4tMDoYev9BGWcZrqLoV+xud3jMvZPD5ruNVi2sPLOzlVVvfkuK//9/F3KPM2H8z8Eg/xF8HHBGcQAH3ncRsZjQKfBwVWT6PLzzT4eCRSdwKo5SPMkA40IehbkWVd8I0Ry6U/OB04qZhfEHLbbdl9cJkRYLJs1HrzhpONotKoGnem59tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZIXBtDltIZ1aX8qWXEJnNDIhYV3F402tWJ2kPR4E6g=;
 b=B0CaVH2ErQtuUfJ+ATR30/j4dU1rXu9opY2WJ4lMCsx/1rQi4MRNKM0/6T6gT5P8m2r1cOIOaAPu9dR8egPjgzBktNhy0PZbMLIYQcpCw1RvyEo+0dS+v8KMvCA6tnt7yuojtNnBEpJEP30VS8bO632WIBeCICWiFp2jJ8DcAjxxEituUygdnIVZS0J7k5M5wpylA3itb3gg9bkI4EQ2Zfp3hEEYF/BQGquN4KE7TvOCBiLm1CbnQnrutvLuZWP7H2xVqMols/Awv4LhL22zNGsUmmCmUne923E3UUgxV9jUAAawblabeTmv+wziEY1lV59roQG7ZW1F00njZPrJtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZIXBtDltIZ1aX8qWXEJnNDIhYV3F402tWJ2kPR4E6g=;
 b=URwbmpKa05lhG0DSK4SQjtCTxHVw7Ri7DAHuN5YV96xx4FPG5WVqKTBSUnfYn16cHZv5t0i91MSVaVN5VwhM8V7wF/qWkmULuyvxvh3sUTVKfVcmalSZmHoHq5FG9JBh+omW+PQJOqFrIgrXf32VPfVrdvhfD4/ogV540qEekzmI1Yo4RkmdtXq6oI7PEo+3lpQ4JdzUBSxPGMP3zp9D1Axw1ln52KzQM+BIUODeaUpBujiJTqhrrq8iN5rw6qKvsAEhw2TtMFdbhvMqBYacY3Vkxzp+0jH1mYYwGsRRgZBf6dLiuPFA6YfvCs2IItU8f5NdXEcjNc/Q2/cKNmOCgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB8120.namprd12.prod.outlook.com (2603:10b6:806:331::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.21; Fri, 4 Aug
 2023 17:18:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6631.046; Fri, 4 Aug 2023
 17:18:45 +0000
Date:   Fri, 4 Aug 2023 14:18:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        simon.horman@corigine.com, shannon.nelson@amd.com
Subject: Re: [PATCH v13 vfio 6/7] vfio/pds: Add support for firmware recovery
Message-ID: <ZM0y9H0UbHHW8qJV@nvidia.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
 <20230725214025.9288-7-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725214025.9288-7-brett.creeley@amd.com>
X-ClientProxiedBy: BLAPR03CA0040.namprd03.prod.outlook.com
 (2603:10b6:208:32d::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB8120:EE_
X-MS-Office365-Filtering-Correlation-Id: c5e41d2e-996b-41af-20e0-08db950edc05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V+V9twg6JzMH7rS5tAxF7EhFEGc7TBYfMmNcGSS0AOPZi1bWleWIOserwNOITvJ/hpF4oIvjODW3ZfSfpxGNyFyu4MrsmcaPzgnTtpT+bb8mRCURsFiKv9543ekVpvzVarDYwWxV6Iffxxw3hwNRQynSG10QWc805aaiafQ2Z6L+dBC71gb9B9DYDQTKiiY40SRcwHkpqex8K6H4l7tQX0NAVcQuicdXrU8AMXddYAH2kKLS3QaCaEO8xbZerx/xl95CU/l7HxkZmufbzOnoKVwEhJ2FoEUr+uTpdFaA/KCwnoefUvgtwJAJaq7WACUVjWqHWeiAMjdfhtXzVc8Snr2IF/WBDYgqGQNyehfE++ADJ0qCtUBwMHejdqwHRw+4oQM1tCAd0BqbJW4w4aZRXJbhFFiAQES5YJ4eni/ZR5INIybA2QTFzcgmrWjZ8DVKkFl7PydSNMRHI8ivVwlfSn1+7wgS5GuoGdvSqOJHqiQ0g15VYwo7IH/HyytVYFRueXcyaEMvRwxsDd/5Yigy0YzXhDnB8ES3w/xyYwz5yvx4HHdV9tYTB9aj48yaZC4Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(186006)(451199021)(1800799003)(66476007)(66946007)(66556008)(4326008)(6916009)(2906002)(38100700002)(2616005)(6506007)(83380400001)(86362001)(6512007)(26005)(478600001)(36756003)(6486002)(8936002)(8676002)(5660300002)(41300700001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4OU9Nu8hY5KUhhDyq3NfGWFZwg3pORY6Ra8pyJZyXjOAXkr6DCHI7BkgQspU?=
 =?us-ascii?Q?inA6FroYcnnME+NNJyaJaXoazxTIh6zfCfKcntqLhNvWRIwyQ0M/k7IUFmG5?=
 =?us-ascii?Q?rBj/KOCjqYoIUqjYlUPrAqqJgVpVVSgNwwUsQlYtAWwHS3eMiqS0glAnoqXK?=
 =?us-ascii?Q?q5Ou1WHQkXdiE7PTg2W6zRbJPglqJkePEc6IoJXKZaH68daE+WE91L3YDVmx?=
 =?us-ascii?Q?bBN2P9pGCMnLLTugh0tsaO0gXEKvi7hosaIqvEbeRabwcNQIkYWIQUy4tdNO?=
 =?us-ascii?Q?vIbf7oOfVE7GcD8VAewo7C1pcqmdRYJfVdPUHOUIAZMyOpnBEjFi7T+CJ80I?=
 =?us-ascii?Q?mDDuJ7cyc/8V8V3b23Zvhs7SdDGAdNhXavLWHqlidNzA2JjRDbPNI4kzGBvf?=
 =?us-ascii?Q?1o8nGcm7lrTyF4gVwYApYcw7KMLOmquzOkw9yBFh689RnfuOvEwcbeWMCTkX?=
 =?us-ascii?Q?Aje6CPoSngREPusXABIMhKMnftLzlqJH1oxlozSRSHOjab/dUIQn78pqunsN?=
 =?us-ascii?Q?JutzbhW5txQbJitcboKXQt5YL+aD7kHq1KGrX42HztG49BoCRLfSxhzFQFG5?=
 =?us-ascii?Q?ahpLamBd3BpMYEjDnwKTjHPGYgt10tkP5k8KDe8N2QbmZX5/FJYdkXLjiRG+?=
 =?us-ascii?Q?0jaZY6ncT/L7TraHRWgzdw4pZqDKhaakfCqqU5gxGeWYMPdmUvKI1xZyWYmh?=
 =?us-ascii?Q?uIJcyrzXExlUZw8d30I5byw9XLY87KTisMgT1PwuIEfGG6uCD4k8JgpkLQC1?=
 =?us-ascii?Q?ldDzvYXKDo3SozRAKbZC/zTzZdGTVJfrPPlyPTfj6PEk3WCEkOy3cZL2IPTI?=
 =?us-ascii?Q?xhI+i9wj/1PsRM+reF542pd2D2p9X9/8kS1uHDs2V5oPSJQYDd3G3cK3jGgj?=
 =?us-ascii?Q?V7KZ0YkUCeJNflRferkxEWrTabv8nJM9adwZEjavNmuPWqOysQjMv3Y5PN9c?=
 =?us-ascii?Q?J54DLCcrxfANaZ5qt7lNhd0WNaFk1/kZxaZT2Kabtm5fZlfUhLrtLh6SOWkO?=
 =?us-ascii?Q?3nPAurGUPqml8E0mmqqQu3UVYTqoZvQcJg48lrIfp9uKfXEZpU1jdg92bwt4?=
 =?us-ascii?Q?xpKI0pI2Q5s/9UzonbT4CZW8hYUjhP7S1f1KZc/If8zkkOnT3aMNotTY9Pas?=
 =?us-ascii?Q?hqV4U/v9Y6Eb6GUivvGYaQerrOoGRk9DE5QaDSAveh0QjN1huSr8EieuQjSY?=
 =?us-ascii?Q?HH0PRY1kfRVutzlNgRIbU1RJxJW8Zuz32L9ZxyGZDbLIF88xQdRZWsjrRhPw?=
 =?us-ascii?Q?GYCy9U/v+sM0p2H1llujnkhpesvuLRwANi8HKI8VMpa3N9vs4qfiE3XnWvDr?=
 =?us-ascii?Q?5zsKBbM0jGqPuQjkSrM/UDwmCOdnTJVpf0J89oK1K1/DulMxl2RfsV2CSzDr?=
 =?us-ascii?Q?MjjRfUOwAo3N39R1YT55ZxvO/OT2a8m6BNG3H5RdoA9/I4uTGKb4zUcVfkDU?=
 =?us-ascii?Q?9g9ui8cwRCR2i8wMOU/8B1b/7n2CtHUoF0ut02jOIGWuyb2tVZuXs8lAeV6Z?=
 =?us-ascii?Q?KqLuS6qB+ROYZDacSkW36ZtIATX8q9mF3/NGuHkbl7FvlB+EKAwmasXa2nug?=
 =?us-ascii?Q?rKkatuxR2O5YPzmAK8T43lAb8ORavaH9KyD1N/38?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e41d2e-996b-41af-20e0-08db950edc05
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 17:18:45.7779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ORWV5cmnDHVaTj3z8zFjfy9A2/qgXBwXktPzQgYGb9e/wjboWYXRR5XNXlcAY4r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8120
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023 at 02:40:24PM -0700, Brett Creeley wrote:
> It's possible that the device firmware crashes and is able to recover
> due to some configuration and/or other issue. If a live migration
> is in progress while the firmware crashes, the live migration will
> fail. However, the VF PCI device should still be functional post
> crash recovery and subsequent migrations should go through as
> expected.
> 
> When the pds_core device notices that firmware crashes it sends an
> event to all its client drivers. When the pds_vfio driver receives
> this event while migration is in progress it will request a deferred
> reset on the next migration state transition. This state transition
> will report failure as well as any subsequent state transition
> requests from the VMM/VFIO. Based on uapi/vfio.h the only way out of
> VFIO_DEVICE_STATE_ERROR is by issuing VFIO_DEVICE_RESET. Once this
> reset is done, the migration state will be reset to
> VFIO_DEVICE_STATE_RUNNING and migration can be performed.

Have you actually tested this? Does the qemu side respond properly if
this happens during a migration?

Jason
