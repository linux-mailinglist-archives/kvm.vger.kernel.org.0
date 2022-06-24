Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19513559B08
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 16:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiFXOGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 10:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiFXOGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 10:06:01 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FAE4EDD2
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 07:06:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOTDXvPTKUSHmqbDK0RgJpMdj51stv7J16A8eVaLh4GwEm++zKiy4QtEXnNkx5BVblFwu3T4wyltB/ZRZ5LnhUppLaZopzpUAfah43Pb8uIQvrKlXK4V1tpaB1eoNgCz2oZJ3MWOzDijbnGZi/yu4Zx3ssdzODVo2PLKSEQJm9vg1CYAMMdedegg2vw05/npUcv27nOiikV9wy+Oje8TJSt3K8DbkRZv0j9e7g6eYxE+lBPcoBZX+lvFUUIIT/z7Zz358CghFEUPWlt4L2RApZ0DTnm1LRw7YTGLy9BDn2mmGP7V9kw7h36MCZs+tMIVzatOXo0nZXzxJQw5fJxayQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wYCyn48+oIDqkfQryUiftea8TFCk9H+qeNo0mVUMsU=;
 b=Xj6jQRkf7jSX9v+hU+PqWSkhuLUW398tdCO4x7jjmiAPwjTaV9nFJCZz+79rEFURSYOZP95z++e3OcFtprkuNu36SXHt+T64jSd8PV49gVDj6PBx570tEArmmCkQk8nOq7FTzAn1JWYeAdo61lu++mKo1xhZAo69t7s+kig5qvi1na1XxpccyAtzrFUYn1Ci8eGmLCBsCz0UV1yue8j5qZQizpZnbDt0wslB29nYdhI6/lbklAnoIfMYr1uydtAqHMdZAyv0rQEQ71xlcylgS2FK2oCoRXO4xy2cdGOFtWd6xxIh4X/gwYdUL0cDneBYh98pkCLP4gQZkayyOpbJEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wYCyn48+oIDqkfQryUiftea8TFCk9H+qeNo0mVUMsU=;
 b=hAImdBgqR/p8CV8xT/n/dbGl56sdsoqP09QzqInrgrU0JcljspPS2nruJtZcyBK2MnWOMHanlgBeMl1C/eohHuY2A4zDPbcziJLI0Foi6lrmZa8xn/mxZHqqXgxpvpsDY9GSgws0YQPCBko7PBjV37UpCMyieOVQD+6w+2d8IiPOSr3g4xDn45yZGl23/WtSJbX09rgPYWpblQBPArl167CgvaQjuJZdPbbR7+BJKiLwUlID4EjyD82Lny7VOl+PiLRAzmQmoei64/pzjXAzuqYixAUX6ddfdughjKQASx8X6dwJuhMFRSej7+aQbrakpojchecGkXwMKxrD/nCc8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4869.namprd12.prod.outlook.com (2603:10b6:a03:1d9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 24 Jun
 2022 14:05:57 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Fri, 24 Jun 2022
 14:05:57 +0000
Date:   Fri, 24 Jun 2022 11:05:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        kvm@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [Patch 1/1] vfio: Move "device->open_count--" out of group_rwsem
 in vfio_device_open()
Message-ID: <20220624140556.GP4147@nvidia.com>
References: <20220620085459.200015-1-yi.l.liu@intel.com>
 <20220620085459.200015-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620085459.200015-2-yi.l.liu@intel.com>
X-ClientProxiedBy: BL0PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:208:2d::37) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed6fe866-6a59-49e9-fce4-08da55eaa92d
X-MS-TrafficTypeDiagnostic: BY5PR12MB4869:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oUsSikT/iTzmld2T1jDjyJU4H6TZjo/pA/h91VBTuYh5ZnfSbYsqN859qJlEWQyLL469ZIgSfK7sPej8AYEZ+h4C0bZSga2Fc9oJsoL45yvk8JtgivPnQvExiItOv/sfBUk/SmCZaEkvT2mLDNa/eujXPvtR+s2w3t9t+z0iCEx3CN930hYMcK4er5y9nKsSWBpsz31X25siMW6RWfFouA8k2NrVThvHrE3h1hO+boQTsfR1KTD5dBGPnh5V3DryrWt9JKWxGtTyK6EFq9d1Yc4HASWPVjeC9Q5hw215FgaSWWGvWoOkCBnGpmMnX0qNcAwRLVnSHVOX7VVyoplNbwTJbhAgjAMXbKlAqcVjwW52VhMUW/SnwOlEZLPuNZXbMtX+2tooXMtCQhhFE3TB5IagansXAbqs89Oj1r3mNjwI1oe3NX/7XcOhJbVXFIb7JPwbL5D1svEoIBsBfGhJYENqQfAE5bOwRrJK7uvO+BdUonvxUN7MEWbvbVIct7kAlPeEYmOS0YJliNmacoWykqpsoSe+r8mN28LKMTJtFVtjbQRXYqn0MFKsCHDy66Q/szP3BY20xVwTOH3+68ycmX2GKdIal4gvok5/Faf9f4tYd/H15tngvvn0OSRveoqfwZyBea3YCotM9aqnqOd4TKghs9Awq3KPbRtOvkZteMANUcTiktOlv0+eNi7fmfMgddPF0roNJ/Mtvw17eJuj1A+cZUg24tAyFpI8cNE6jAuJdus1vlS0iJajSq6j5PoF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(66946007)(8936002)(2616005)(6916009)(66476007)(4326008)(8676002)(66556008)(4744005)(1076003)(86362001)(5660300002)(186003)(6512007)(6506007)(41300700001)(26005)(36756003)(33656002)(38100700002)(83380400001)(2906002)(6486002)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YsiOmC7b+d6GAha7Mh7/VexLdXSngMMwU4vYApTlnaUKS4+0f4YsiwP7jyHr?=
 =?us-ascii?Q?NHcBKQQL7vtclcHMyM3c3rfRkDZcSlwtN1bvQ6CajvCh4UdWGqJnzvtPl4sm?=
 =?us-ascii?Q?YfMiE6LoGrA5eXsa1tXdvCwNr4UWA/OqK2OXnWfSTZ3qfrebKVeSUdB/HkkG?=
 =?us-ascii?Q?EBXcVPBepXZquwXpLK5+GTpGDBtsRYx5LTCNfyhBT8Ucr8mXtDbqkRDNpG28?=
 =?us-ascii?Q?jcYn+imJdsbpgyiD38mhvSLYPBE0u/P/fGcSYdff0ren6cWl8KyGt063TUiU?=
 =?us-ascii?Q?0auWhhWRxjaD6Je285p9yMI89hqR/d6a6MJ9OA8lum7qSnK2MVRY7VfDi3nb?=
 =?us-ascii?Q?3/8XRnNerpAGsIuDFdnbVAuiGYKD6oApI1Iv1j9DPdtnjpd38hEkOdQsEa/e?=
 =?us-ascii?Q?3ndUcp+ZNRMHWIyHfnahv2cGDPoif8XGAN4rJmKYfq6XCqT6JOyQhtkhh+3q?=
 =?us-ascii?Q?i5tUH+fziRyw3dZPyt0YYfaVKdlFsA1omfa2uIn7Ezrjbd6e6Dz0rLlDqsVS?=
 =?us-ascii?Q?vTWv4gJoIhztkQpOXBUbY5K1U4dbSQGv60t4EqP2HUhBMdcmH0yVWMwn/1sX?=
 =?us-ascii?Q?qsRZPmCWBrGHEzeYCIWDsiosRX448CpKfv6l1XQq81D4Ef6AX0Wm94x7HtmU?=
 =?us-ascii?Q?m6mYVK/kVIlHzlPLLCoCDCpNXRkiPVpM+3TQhuKYkCNaphiV8PMtflzibLmn?=
 =?us-ascii?Q?V2sUjnlvyOYa+JKs/1O7hNVjJz8A/fKw98QEcMw528Shuxcpd1SBm6S4duUx?=
 =?us-ascii?Q?7qAyf9sI+tqIjTQfhXcs506wW9HSTrJmWneYiQkE+Nf/M27qfMXV4rzXIojg?=
 =?us-ascii?Q?hbT+2/93BmVGuLnxDi9eYi056AfKgetIDqVK/TO5twVDrGeDBO6lSIUqX+ko?=
 =?us-ascii?Q?kU06nCWBHSvjIoK/9a4tOA/ghoHOQuMDsRciSsPraGdN5RsjgkQMGa8WQUs2?=
 =?us-ascii?Q?qXIlJqx1ieB9CBEoRm2bRaGxlJfSsIZl8fz6tXEuL/1yh4+iu5byNnv/G1x2?=
 =?us-ascii?Q?ql5dSRK0plylijR8rmcy68Cev/7n1JhXja91Rkzb/0RjNWe+nGwbuv1m52zO?=
 =?us-ascii?Q?hUymNph+ZlD7Ky6ym8gf+ZD72EfnnZduBAYe/QE9MCdpAmcTTEmhl0kXdN1f?=
 =?us-ascii?Q?IjFkG++MHe0ZjFoRUBMG3XhFgVqll7Mz6DFORBSA0uReHEOIqn5YOQ3K1ZbO?=
 =?us-ascii?Q?kFCKj3etS47UUcgJ1grMTLZ399eDJfpUJjNsTNBloSaleULGYp1qmQQ0tj0S?=
 =?us-ascii?Q?iRzBf+VOZkk8XmqqK1BCYHx/GemI8YBjkSmnH4jGJcXnQqKLhkYiTSbwObbr?=
 =?us-ascii?Q?7IEoERMitJocvxM8gQ4tfkw6bx7TEuwNE4g9RbZq56R6FaqGXKn6HKSF7ea1?=
 =?us-ascii?Q?1aI4jSx/6Em8ebEa3G9Gb1YuCdzd61UJKrI6uMKlPZxHYGnOxNkfPdkbtD/y?=
 =?us-ascii?Q?j4inXeinQ72/XVQd2VZDNaQjPr5R7ScNPnNckP+/CAGG4qGaEBo+C9h9B65b?=
 =?us-ascii?Q?mN3P5uwXFlQu8m5uzmGV+KqgQo5+/dLxuisTOuMYaXvk7oaSQj1+CmLNLbiP?=
 =?us-ascii?Q?K963X3ACG2xpdN6XvK5Mtg6ZQY+3HzLhp0+QDIGE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed6fe866-6a59-49e9-fce4-08da55eaa92d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 14:05:57.7136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VdNP44qAXYQ/5tnHOlVDOwlimsPwzRhdaibAQiSfzKCNsLh3xKKyl4lsh7g4pDg2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4869
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 01:54:59AM -0700, Yi Liu wrote:
> No need to protect open_count with group_rwsem

You should explain why this is a good change as you did in the emails
here, and no cover letter required for single patches
 
> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
> 

Extra space after fixes line.
No Fixes line for things that are not bugs.

> cc: Matthew Rosato <mjrosato@linux.ibm.com>
> cc: Jason Gunthorpe <jgg@nvidia.com>

Cc:

> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

It seems OK but a bit unnecessary.

Jason
