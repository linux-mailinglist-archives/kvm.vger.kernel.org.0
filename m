Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3862A565849
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 16:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbiGDOIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 10:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbiGDOIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 10:08:45 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAC5205;
        Mon,  4 Jul 2022 07:08:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UAPaLFrjW1vzysObPkYuF/kRS8TQ6CYOmesz1MZflE4otleA5jjfpi0Kc3RlaK+UDw95ysf6n5maNr6Bph8LClYhLsc7xGC1r8HW++z1v1lSgVATY97n/AtjiLQO/r/HHnbfVR2HVsoGBO2aGuyUnYA+nJ1bWMjqKhYwgWBuUo5PzKsaaK9koa66jh4X3Lrvos5VL1f5YwriQpF1itHP6TxV2/L+35ejfQfpmEqKrM/xDBRizQkjeatfvt9ZLlTRe9Z761uZA7H0Zz8Mj7kUgBD9f+7dZNTyZGCoYHXSXib9oK8/m1/lYneCQi4in5WPflWZHLVbuBkXrhjBM4pwZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ws+X0TdhlGq37YkS42G+P8W9maKS3W+Dw4NLnk/Ct4U=;
 b=mzXzZHY0qRmz2WN9nXFMhS1fNLVPObNEtJOGrpqq7ua+gFP/7wGSnmc1AgZsNZg0VBze8aZHVPez8l7cwGa3O2Tn74nx4z+psEbhOb8sCzjxPkLgtmPzD1iQ15voi79HVD0x14qiqtOGzk80UBpNjYPx5/9ONFoUaZRhiNTyLYVzfD2V01fGNmCByKjWFEtDdiRcDkiZ6pJ0DQKf8VDID8k7chyi+itXq95imdPrHmQZb6485r2mr74E0HsFZ0jalHRL4k1Ms579qyY6hTrNa7lejaqOO3ZAObbf88RTS4/cwz8HNv/QeKXVWZY5iNclj/+m1ZnilSZoDHGlw5imqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ws+X0TdhlGq37YkS42G+P8W9maKS3W+Dw4NLnk/Ct4U=;
 b=eGekeOixedluuzOtIUCM7fk9O0uwlVrjFaSaFw/7tuknEClUxhhPmpZLtfUT3nB3s2A44IvNVMMjD50BAVRak6N6K6g0/H9QrkH7RWNCZsCdj6wsYDnR94AXGXxv/74NbRGHnezDp1Iey+cSYHdSxcNCsWZ+MsO9a9wPSN+cEaKMIvcuWq9gF8X5dC7xfow/bdi/r/YL5DVfQUrQvco736DVeNHBR8a9T4uX82Q2hE1TbCzXnc9JxSy8IRst11NBa8NwE082a6osTMlA0WNP5hUOr5ZXkIss0U1uMC8R5/ly1+kyq0rp7ERdAsFvuW27Hf99YX3i6YJZJ4AHeknlHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1646.namprd12.prod.outlook.com (2603:10b6:301:10::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 14:08:43 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 14:08:43 +0000
Date:   Mon, 4 Jul 2022 11:08:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 01/14] drm/i915/gvt: fix a memory leak in
 intel_gvt_init_vgpu_types
Message-ID: <20220704140842.GA1423020@nvidia.com>
References: <20220704125144.157288-1-hch@lst.de>
 <20220704125144.157288-2-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704125144.157288-2-hch@lst.de>
X-ClientProxiedBy: BL0PR0102CA0025.prod.exchangelabs.com
 (2603:10b6:207:18::38) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02ad2774-f921-457b-124e-08da5dc6b458
X-MS-TrafficTypeDiagnostic: MWHPR12MB1646:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7zXD9XqJSojIl6Ik99lCu2T5AqlNxLCyYiLI/8RmjYB0oZfmU0OV3rCZAwNjuOsuTQjZhEol5GdixHH0hETGsbgleYdYbJaWxrbFAkdUBkd48j90/kaq6iddEQVkEdPuc1kPT4DyFdYEH6lpEPkRW7W0awm7A81fERFOpOG39CwPiU2XngrCQY849WIW+4uC3Q9spPA87QuODHQ82U9Mwnoyed1Bfx6EJ4FXtpU5skFhzBK4uHfTu3Pydvt/D185gU43boXWagYegPFfb18vjkwjRurgJ7E5GzyLiWBuRE3Sbq1Mawe47dp5fM9RMzTWfYrKOdutR9VDDCIJwaVTWbxY/pnV+dZbBDChjpjtrwno0X+Of1bz9L9shPFFuRoW5LzmrvxDYU84tPSqN3VdaQVXVnDee5N+GYxuMiq7kVQn3iQjHIgYyCRo/8XouCRCXBxfEEwxLWIh5//LbKQyQY8MHo3tQQM8SDqATTfdw5RXbrDMLHHlX4mx7a0ANTN/AigePUR103DsP3bdeSoDz1iOg26wxGiNrqkSOlqNd8UICwIH5cNJamm2YsTVusKu8BfqI03eE8mhFFAfnHl6wBpnGocg+S2+djlCaeh9NGLme83+myEiVpTqEvLmugJpvYBmYGlPmrKi/z8vWq8ZqZgl2A1q4lAd7lwlSX6q6WYfANLwnPu+0NkahHvjMo7AdgVON9/kzjF9Oj6Y/ebVBXDcDM0h1uUILMBhuqQIpcEaBI76LIedQhS7DjFAtWz5QtH5PPikXlzbepG7nJKiwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(39860400002)(366004)(346002)(6486002)(6512007)(41300700001)(6506007)(26005)(478600001)(7416002)(1076003)(186003)(2616005)(83380400001)(2906002)(5660300002)(4744005)(6916009)(54906003)(8936002)(8676002)(4326008)(38100700002)(66556008)(36756003)(66476007)(316002)(66946007)(86362001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AOkpEHJWy5U5EIbERW8KjUkXuSI0Ak82LoOt9Ef5s1MIy/EI1NYlWuIjUYk6?=
 =?us-ascii?Q?foOjCkH0X0+iXvrugnZ8HgiHpDeZdWCuiQjdiZoMASLxH+hlJ1eyOteCyELN?=
 =?us-ascii?Q?Jv9X5wRcljFkzXzIiYhphMOXGmbRkAqKED9nEAKdnpeGSmgVTm9SkIRASozL?=
 =?us-ascii?Q?PBc453OYeon10pO2E8w1EKtkUfj56PiRGqMZ9tCMXQB/a/2fr4IIfYr6yTGA?=
 =?us-ascii?Q?u+NkiAodvqsr8SZNRO5ncM545TzSQVLAtWVqKdNrp9y/dKqla5mmF5Q7rhKB?=
 =?us-ascii?Q?7XmU8L4Qqocd9+GCzoOo/rG77JZomseFi8sQMWo0yLma5NkZtQeqkBTaTnqC?=
 =?us-ascii?Q?18sFe0Y4RKcTRVW+7h/SbqDP3WrdKTADkl6PP6oGXoiFbDoQfKUAYCZpUSiH?=
 =?us-ascii?Q?Iij1QTvkZMy1Al0BHO0eLVjibzGdliPDUh69nn2xE0Whx/kdpPMmOKA0aX/d?=
 =?us-ascii?Q?4o+EjjLpHLNSBdXcb5hfVQySgAeqMlDSxtLvkFa4kd0ggH1qpykIso+DKhWp?=
 =?us-ascii?Q?6f9SugR1UIt5SatDUxuF1ec+waVVf/uqYu3aNnAFwICnuXY0abqgkJlqEwTs?=
 =?us-ascii?Q?0qA4ecMCZUr1z/blqBxZbWs1lzzXwJQ1qVTDg4iyL9eTDd849pH+rKYvpRyc?=
 =?us-ascii?Q?WI7o2vR7NCn9cMJYdVhupk0fjX8SCZjgVQ5c/EpmWp+p+KhkHm36AE6xUVzh?=
 =?us-ascii?Q?973UJ8VJNruLkUg1PSAKYsyApTEI02nwyU1esAAyrZC2bRZbC7saV8iH/xrg?=
 =?us-ascii?Q?bcxgPNZpswJctvb1Is2norybjCj4HW4hhq1EQlizzuG+p3/dhfOZ+tDSvKI/?=
 =?us-ascii?Q?N/aEZWvgs28sPqPdzIlhUYp+DzIAttaNtXAydZoUckcM4TtHH7odhFctNIYi?=
 =?us-ascii?Q?mOdoS/QdBYsE6/qRkdznnlKbQIy7GQ4ZeFTZhJ5sisUhG4AKrlp9wz6CtpL0?=
 =?us-ascii?Q?2gwZEP+hd193pFUaz0cCwf8ciyty36mV0tWlghHQs8BbQtgqA1/9rxzHREDt?=
 =?us-ascii?Q?zxTb7QRtQ+c/osu3CrBj4fSV4F4bcretYsEY2Q0l6Mo0pUB8fnvMuZ+WCYf1?=
 =?us-ascii?Q?RaSiIcd8RlDFvSUcBqo4kMZ3kyAkxgu7gcdXQaTuPElJYFHG2sPpCo+/72CE?=
 =?us-ascii?Q?DXHaVZdEQjLwKu63M7R1spHTA+y8s79koHEVjTNWYjXUYnoQ1UFqWzQ/GyVG?=
 =?us-ascii?Q?bEgJYwxqWtepo3U3VacdIvuRMvmWBO4OTJsUn3gujRyqG1tDwCIoXHyhF9IL?=
 =?us-ascii?Q?mdPbcIT+Aqc235a3i36jfMc3CutWK0cMwNG4DOIkYOYgjFcKJVvIhAV39nUL?=
 =?us-ascii?Q?/oIbhLOzhzVzFSmVSLU9FElZqe9gbiJU8S71c0wqdnVBTyhiDQuzUWD5Z53P?=
 =?us-ascii?Q?gWHVnfpRRDKsZ6S+oaWrvaoHjZKMSHUWhJ9dj42amaRZkDaimiw+kgYOLv7W?=
 =?us-ascii?Q?pg7c2YLNVAKu8m1eRNAg/KTJbH3ACzSdehRiSNvkv0YvbNoJxiFQ3Cxsqz2e?=
 =?us-ascii?Q?onR253K29XVdR+GDnveps4PAxkN4SCFiV7fGmUCPs1GkVMW4BhhWmAuSXh+R?=
 =?us-ascii?Q?u2c+qc4YasJDhSOFUiwkxWnIvFbIMBEfvjOfBFPJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ad2774-f921-457b-124e-08da5dc6b458
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 14:08:43.7862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yIb7LyrBk+q4hawHfp9xhSX0IWfeLvx5/d7LPJ6CGnOE3pwtNr/DljCUcs5S4bcm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1646
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 04, 2022 at 02:51:31PM +0200, Christoph Hellwig wrote:
> gvt->types needs to be freed on error.
> 
> Reported-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/vgpu.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Fixes line?

Jason
