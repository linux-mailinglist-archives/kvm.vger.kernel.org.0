Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E83E717273
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 02:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbjEaAc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 20:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbjEaAcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 20:32:55 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2079.outbound.protection.outlook.com [40.107.101.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F660F3;
        Tue, 30 May 2023 17:32:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3hl0Cr+Nbi3ocKKnjzyJAzeMuxkbA5yRRC5zxN2jQmONh2oxgEqjLEiQiCBplTeDdH6bmBBXSi1JKai0P4DdVx723mAz++wGS9Or1t1SDL4AWkM81gLoYEtWhqd8I2i+sfa9iwpY2dOns1K8hCeRBwEJ7ottj06HqkMjfEI0zDRG50r+ummQ0AXw8peqhuUldi9GcE31y1+dNhmXzYlTtqdbyy8MzRgraujWVPlmBahed7M4IXdSOriR6ZYv1+enluQxe5YcuvbFOfOiRCDGiQG82iJN/dxoOUMQ605t76wdaIi9/iPNyIZpJEuVLUKf39db2F2CFufnpmeJ1zv6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nUq/G63Ze/hbu5o2G42g/d88pZKzZlUAVjgqMFqzEc=;
 b=acd2hlRD2CKt332kcirfqTdwOl78bI8hW+jNxEEDmv1uz3rndCf5zToEjd2Bhyeu8XXP2fI/uyuhYQo0LkWCtBjOKV08v6Whl0pijG2UKMwBpIQOd9vg9qtoht8LQefxOaCOOzA3hAmwy1ed/oJlXk5YbKnAQBYj5MMrmeu1QIKgH5z5lV4AyERVgtL9mKvY06MydX65OQ+C1/ylzsJcoVkGp4Y2AhQRC3oygXKJlAzGTQdMe5xPGNimCSqDrFKg+S0DaVcM5CEf+VZVfhjbG1VRgDkL2WbajdI2TQBV6RAMXDVw/KrNy03n80W60cIIzNBUYRbyqMzMv99sWoCWpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nUq/G63Ze/hbu5o2G42g/d88pZKzZlUAVjgqMFqzEc=;
 b=F+8L41Rd+NGxM5uv0bo0erruDas3leeP8t+lgWzOFwV5BdSj08PDWt7Y7zkD/c3v5Uvn8o+ck+phmhJ04+5xX9Dd5lAxDeCEMQC0GGTvY2UVagwDk7bzr69BADNywfqY5kJ77s30fkbTsvyngZJwbsfyud4Y3vJ+Ppjz7eFN+JjQol2FlpX56f1aXVUexO8dyURvx8shQe75ccZ/H3tlItL7MMnmCblsSxOCp8KWYVHMGUhU7qMoVKJQzxck40Cc2aGMNW15AZ+AQPCPPGQXKt682nvWvA719xUY2xIEtE2UufojUvy804dEUxzD33/xSZv4b0U97XyK0X05pgGA2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV2PR12MB5871.namprd12.prod.outlook.com (2603:10b6:408:174::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Wed, 31 May
 2023 00:32:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6433.017; Wed, 31 May 2023
 00:32:51 +0000
Date:   Tue, 30 May 2023 21:32:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>, zhi.wang.linux@gmail.com
Subject: Re: [PATCH 2/2] arm64: Notify on pte permission upgrades
Message-ID: <ZHaVsa3oXfXqE1Pu@nvidia.com>
References: <ZHKaBQt8623s9+VK@nvidia.com>
 <87pm6ii6qi.fsf@nvidia.com>
 <ZHXj/6Bjraxqk4YR@nvidia.com>
 <d2e591c1-eb43-377b-d396-8335f77acef6@arm.com>
 <ZHXxkUe4IZXUc1PV@nvidia.com>
 <89dba89c-cb49-f917-31e4-3eafd484f4b2@arm.com>
 <ZHYCygONW53/Byp3@nvidia.com>
 <ZHZuSDp6ioPqI272@google.com>
 <ZHaCAJI+OgIfDWSx@nvidia.com>
 <87v8g9qr2z.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8g9qr2z.fsf@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0413.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV2PR12MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: f29b84a6-1425-4475-b1b0-08db616e912f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vv9eOq7Fq/6W/A/OWMf+wsKO8082LY3VDmjiIyVZw2jGVBmfx7IrW8YtqCKkuU6Nv++LOvwn4pkVLhzYLYhWpnKYXJpOvjUCdP9yXI35Q8lTj1X0y8ZcxOm4kJcSaoH+NztNjn9JGxKMrCz/12i3y1kYQnEArfUoZ9fUWgDS6/TEqdnC2VMpG8wDzs+8UtD37OCKNxuyIMIrOzxID1C6mHp+QzK1WmOq6mPP1ojFrDelBnXO0CI1Ps5IBhiwN4GqnUuNejPi3X+WlYJJ8PAHux44Kr0kCYiC4nEyi+HCTKrRI5jao8wCXEo/67w9/XH/vlpkF6isMu5rRpz6ZQBA1CPLYEmI0zBJG0qaMY3qJj7EG9zMe+6OCJg1zRUBTHZYje/0c2rm2vGY3rGpCJCDBKgsAWO9+awD89ZlJHX4k8B+nKjtg7vlHoVPmP5usAl6NcBs+brCWbUd6fgYuIcWuXJZDfJ7BXnjf/TBL+q1Emq7Ff8/ObG+319rjy+J+P3n/bjisSHY7HV38/rtGa34jEclSYuEJdX5um4n0Srg9kmodO6KikcwS+je6dL909Ik
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(451199021)(41300700001)(6486002)(7416002)(86362001)(83380400001)(26005)(6862004)(6506007)(8676002)(6512007)(2616005)(4744005)(2906002)(36756003)(38100700002)(5660300002)(186003)(8936002)(66556008)(6636002)(66946007)(54906003)(66476007)(478600001)(4326008)(37006003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jIYIOJRqzjvdoQCvfrw9o4MoJrHc/RUiOq0w7jDIj1Wv/Vyb3QAmBeknrNTY?=
 =?us-ascii?Q?UIkn13Z7UejLfIa63JZlSoEXqAO5sTfsAeurNzjOT6n4P1owb8II2vtM2Cxz?=
 =?us-ascii?Q?dYPxm4jWf9Qny09xJ+YAi+pRgeM0VXS7o8chGpMBorbMXEO+AiFBqp98klL2?=
 =?us-ascii?Q?i43LAaMqMDh7qC2h/RbZz8ev+8w8LCFHUWJxCUYSIJRIL9h6L6fMydr2er7g?=
 =?us-ascii?Q?djyH8xOFc5CyrJgxkCJAiUDp/ujKxri2lK61qMDl9hpLvalMpXftQyeE2KX1?=
 =?us-ascii?Q?FXQL11F0XFmOTleVwRZoffZLnx38kIuPVDjmMs2oTE2SJNZPXjJU/QgnTeG3?=
 =?us-ascii?Q?aeMmW9L/AW+o5BzehYumJeOpisAw3mrVE36DRiPCD5o79OXZanTmP//bDGGX?=
 =?us-ascii?Q?ZRkhw3a/Wzk9u8p6PFmrX34OTKx8gyjbu84BKcs73TETa7ai/aYqZRl+AEEv?=
 =?us-ascii?Q?Rj1zu86SXQxbe/14N3U/RdsAOoSsisTzOwEaK2dGUNBcz5zstGHlC/iSl3S0?=
 =?us-ascii?Q?lO4c8BQmd6VlYIuC8kjBLG5iURMy/IhuGN1P6spKTyTQyszQSqg6ovMzASd3?=
 =?us-ascii?Q?Z5lUrsHq67gTrfZdv9rWuHZNmfrgvWd1jinYziIkebdZ6nxoDfs6XhyPau4N?=
 =?us-ascii?Q?jQYL/jTPCfDIyda46HJEdAo/p7KE/XDetjeIja26a2gAAAo20ESzaoNJhFSX?=
 =?us-ascii?Q?PkYbQ6UsohtJfbIO1k/6sha2uNBmEfQbTYH4Dylof5HRCsupI1e1loSXVmfe?=
 =?us-ascii?Q?TYAlGUbEg3ph/Zw8EoS7MWQ7FL0cH0dcrFKO2z3U5Utxo2CW/OUDl16B9w/+?=
 =?us-ascii?Q?aUGN3qGCrfg6bjq56e7Z5pVg1z5dRof/HEf5aBgHlPQdVM8BPgJJKFDZWQ1d?=
 =?us-ascii?Q?cBJ5o371TSdhRVA6THEBCK6JRQR2v84Adyf48tiEUF+Nui1CytPU4uOuuFtD?=
 =?us-ascii?Q?nVv3TkK+d1hsx+4OAw7rZhhj/E15YDzfbEMkkFjxc0Vfv0q86XLgU254ti4I?=
 =?us-ascii?Q?DrWVa/HDOYRcqI47TrC+wVyPLd0/hwtWOgjgUcZTJKo/s0LgviFdtTzdb9Fs?=
 =?us-ascii?Q?cRMohpbnqNccf3M7wWQe0WYcEf8GatSpGtyTQ5EaSU7xgfy72rzFPmLJ63re?=
 =?us-ascii?Q?kqX1CgTvgHBhDnrVCQ0RJR9vCO2ABjRBPbTHnCdGBwGSoNsD3yhzwASbQp5c?=
 =?us-ascii?Q?9eBtPJlQD+9gPXqswN9q6s4agAgP4HyT3XDIS5jDU4K6rS7i560x45hpvnIB?=
 =?us-ascii?Q?evGlAnneQcx8Tzkilnzh/F8ovx6eCUr4GdXX9SoSvtzY9AcK8jzGLdjLy5WT?=
 =?us-ascii?Q?ROKXxYWxHb4dhHk2gljTZM9IiIUtpiNRVu0ONGpgOfD5tapH0NBvIm11Rnmn?=
 =?us-ascii?Q?iawPcKi6BvBUC1GSlN5NaZ3QlGbZoo/gHcl4Is5M8vKn6+5ZqsevmCxuTYX/?=
 =?us-ascii?Q?eSrhG7qig2RsxyGsPDgqtJ7WvJSW9f4EVqO/QGu2kNY5AUJom610sknM6zDC?=
 =?us-ascii?Q?3P0sJWFJJy9tTnegN2KbAdZXMDekuT7N2OD2tnTXgS3IaGCbMbeeCbD7g2tZ?=
 =?us-ascii?Q?bqMUHBgWGyctbToIpkTHnEXNiOwso8HRe3Jg2BOG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f29b84a6-1425-4475-b1b0-08db616e912f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 00:32:51.5087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RH06v/5yOT6hNr1Xu87oz7vFLtk7T8HCg8NyFldW6HCkyU0EtZXfeqQsrOIjGCgH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5871
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 10:30:48AM +1000, Alistair Popple wrote:

> So I'd rather keep the invalidate in ptep_set_access_flags(). Would
> renaming invalidate_range() to invalidate_arch_secondary_tlb() along
> with clearing up the documentation make that more acceptable, at least
> in the short term?

Then we need to go through removing kvm first I think.

Jason
