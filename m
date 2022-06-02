Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBF253BE8B
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiFBTRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbiFBTRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:17:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8A43587F;
        Thu,  2 Jun 2022 12:17:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCDjBEoAk81EuoydqFLDUTLo20R+M9xMCcsrKVnPbTbHWbi16TS/1be3fqW2cJ/5H/xFke0eeQppt90bnne0MHO5Oy3BiEC05mnDUQBQ5Wuy9HPEFb/OqO0N+Ruc9hLL8joueG2LrPl0p9rm42/K4w3RZ1yQ88DOH2ELL1v02yoNHH+zF2kveBoX0GJl35dzKp1Hy7ZBkokmfDFiwpLIo7fX3oYsn1/C+G64VozFik+DR1gkiNsYn6AEjTY2ewZ3iM7WTGH9AVenzhSVbQ/1QVxrDzjbbP25+lL1dZ+J7U+pANcnKmZzssiFRtirRCjingsHqNv2Ru2SN6k/DPAEZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QIOedUnBhckgW6az1QVUHFjbkXtb8jNmpESbHKwk+2s=;
 b=e1eg7HMjmmQYHExpPxmhJUKvLw5u94ted1MRUMIRurrA2+/ScktNwB6dcVn3Baa7Oh2p1Z9tjDYaoFSvf+Dj12aCQyEaOmBHAJENr45oY4R3OPAQgBmGtC5S6wZdPfBqE+CPN1zQiiakbjFCnCNctngkleON4BF3JtTZ/hwhG1DQijXTVNvdiiRpJ98v23i7KhjMGc8X6yJq6XC59Wbr/GZA+Fw14yZmBC++UxCcQOCYbeibOKS4i3WpU/yHcDI10Y9zIMJby9DKqXg25gp4jnST2IzeNrHvWC5UodDkw0zjYNGJ5R6hRc9WNykxQlQXLUEEdsharrgSXD/ZcLJ1lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QIOedUnBhckgW6az1QVUHFjbkXtb8jNmpESbHKwk+2s=;
 b=B799zFlo3bbsSnPFx0yfT1s3vTTE1PbWJZDK5jfxXJlVPTDlB54Xfr+Bl++VvWMpC0irtqxHfTRckeo1FweWzLE7A/pt9J9F7BE/FA5C8VjJBHTOYTg8nnAEuFqaaKeJle3rWKqpyDx4iUJjQHXUDIV4aT/JlEdohsj2ZVPZh3BdBTGng/b8NKKtN0X7uz/3NuOB7254zyiSzxbnmy/opRBkGRMfiFa57rLEq7eON6SAhc95dNc0GyxTFwYXTTua2tzcaGNh8c5qXFY0xMfKq23NOKWX1tx0Pf1nFVnkMu9ZtvQSfPFGv8d/1WLYdEOHoKXXQFQN4NFCUdwi/lWICw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 19:17:41 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.015; Thu, 2 Jun 2022
 19:17:41 +0000
Date:   Thu, 2 Jun 2022 16:17:40 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 16/18] vfio/ccw: Create a get_private routine
Message-ID: <20220602191740.GJ3936592@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-17-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602171948.2790690-17-farman@linux.ibm.com>
X-ClientProxiedBy: MN2PR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b0c7410-8a6d-4067-512f-08da44cc906d
X-MS-TrafficTypeDiagnostic: DM4PR12MB5150:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB51507987F067E9CFA546F8B9C2DE9@DM4PR12MB5150.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YqpsaCh1D5+IkTZCn9kbdwZp7aGJNMY+rKuqReScWx4kgfZYOTi563i3v/EgDG8edKCD0eAWhkwapslq5S0u/sasxGzHBvMhVeMexyeNauJnz52lg+gKpBsmfcz2AtrNNyVAANiWqIy2jtxDgDxupffh9WHBn7rHjj2aRdo4tAuxTloMget9lsoKxOmObvZSdGOoRfxS+cD/vM/WaVu2rzgXnsmiB8k7V4UVXVReAM2FUYGZbzwGxmxtqUzC8DOn1GK8Ong1yCOiy1s+o8lQ1DM7D2j6/5mXZmofbjkSAxN0KVWWQiznIfCKWbC98xeT7gfzmpgz2TJvLoeNqFcTzaDVjTPcgsfv0A99YZVy5phVAgiO4yD+A1aZzeLI5aCXhLvqpKLrmmDWWW0twF5UJScWiQl2VHS2ISZNtoUotSTtgQGN0zxTIn+Nm2hbQNYhbIkuEHwgGazCBnwY+GQxLFRD/oCTbdNRzN0T4dAV7KqSAW6GotLvGx7Rzohyy9A/8mne9mXhx4nycG+Ptb0H8t5e7ljmkvcblULMj6I0gjHPH2eLJQYCn3m81buwH+HyFQ1ZiqFaJVgO03/DftNxrKWxYOpfBMuE+aVUSNC6cuZGc8vVbnU7KXxd+YAL0Aufx/HNot+FluxbH7EsQlG7bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(26005)(2906002)(6486002)(1076003)(6512007)(2616005)(186003)(316002)(8936002)(36756003)(4744005)(33656002)(86362001)(4326008)(8676002)(66946007)(66556008)(66476007)(6916009)(38100700002)(508600001)(54906003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VkrLPimspOQicAhD8bwRBQfP4amOc/lHyqCzcsfhUIaVAE6HiWy3gC7OltI9?=
 =?us-ascii?Q?pQ8rqY+zXWWT/eiB+n8bOkrMF/yM2IKhlopzRWum//joTsGC+XiZi71f9tt4?=
 =?us-ascii?Q?vnWiDJVBBsja2qlaY6Gm8aDCWH+/rV9izTmp+vF24vfiQCiwVczQ7phcWHPd?=
 =?us-ascii?Q?Bn0HDKdxqlvVtldzkHXaaiYBZKMObQcSjgTIUKopv3fdu/xsoMt4ofZcfDzG?=
 =?us-ascii?Q?WDxQWWa+3Eibs/7BXOJCLzZGch4BzhLw15xvYBBEJaRBnNXaL4X/96mM6v/d?=
 =?us-ascii?Q?67+L9C2+arEZYogld9Go4NlAiY1yalR04Ibh/K2dC96VXVHlc8pcTHKGBEge?=
 =?us-ascii?Q?Z0ua2pzFP2yCxxU3GOP4CpPfyh91L0GMKQhq6Ms2Lk/ZqLEiXC+TGZr8Ch8R?=
 =?us-ascii?Q?l48FgqyElVSC8Mc3XCBysMbEDmVtAXTf8+HyeQXHrs6qdhift/OzvrwYNilZ?=
 =?us-ascii?Q?rwIXERl6hxatrTzQV2mRno9GrTo8QsXjXG5BsERBL7ciltZalLKcwptk5r8w?=
 =?us-ascii?Q?c8Slbqfv5yRF0jDpXuZ//CJVTkibersdBjg9PStg+FLQWDOYBWrpYxjozfET?=
 =?us-ascii?Q?0U/zTkHxE4KcsmcP6r2DJ5wVVoNtPkkAPbD8OCX7YZOyBrvcSDQgtPSfp/IU?=
 =?us-ascii?Q?XA5dAY5ytseg7qgmqKfIuhuWHV9d3LQuOASgGoj8Ikk0uwQGdM3F/E3SBcIu?=
 =?us-ascii?Q?wdJ1DlIrAsXxx+X+WGv9c5oSk6pkxKAaUt7xGhqPm9QcxhhK8rc/LS20md9N?=
 =?us-ascii?Q?gHpg4fpFURwC8tjv51D3jtoOcTc+P1Fyv0nNBVNSHvGH2Et3tnEwyjf8b1EX?=
 =?us-ascii?Q?oQ1jm1eW/hzvuEwXu27javG2WkDSEptcRD7AcybFZ9LQsyuCIVAB5gKv2+Dl?=
 =?us-ascii?Q?R+PIqhDnIqSyqLVSEqkJiLw9RbMswE+teJui15p35gpW3V1GBEw5FBvjUpP9?=
 =?us-ascii?Q?Z+9sxFYI2y1yUCh0crWSpCC9NZfHANsSSIVe2rFWNe0kHl/VTDHBwAR3bNZp?=
 =?us-ascii?Q?6MSRE52gm6Cp8yyHE6ElrEBF9qY3XSViDGulaeTvfgJ5j9vlJz5BarkM4gzF?=
 =?us-ascii?Q?CJDoJqU4hOCVCm8yGtSQttyGRK2r/TgNf9X6Xo90q37quae4zBdPplIqZJcW?=
 =?us-ascii?Q?WX5fAkJBi5qj25rOdFteC4/akNShqdbH//JshkJ8nQhM+LP4dSZUEWuG+Dnm?=
 =?us-ascii?Q?VCkHOu4FZ8H9oGzfJWpwuf+y8UHUGMww7u1iX8w/zRtEWS1d4bbG9Ai/wAl2?=
 =?us-ascii?Q?vX+LRudzVB+pNB/UP0zsc9aLfJb0WvOrFWvB9XiJuCcE43eqitRmTwA3Mq1c?=
 =?us-ascii?Q?f465XvYkI+V7izZ8WFSvILd9d7NjF1R3cc/pVTq6waGxFrcgHqMm1h2ne77g?=
 =?us-ascii?Q?AUlxH9UgDTi1GobFpDAPo1vnGMR3mscmOWtadiMCpeMeYvptlib8xKsdH17o?=
 =?us-ascii?Q?qkIh+JKLBVyp1o4/Eh3MRsvrJyG+hDX1PvYHK4+kBISXahSCyAyVzJZjIDr8?=
 =?us-ascii?Q?Ip3gUQRrwuROYp+ImxGjnEp+ZT/Nh5qYIAlTtfM/NgoX9/ZMjaIysCl2ONw4?=
 =?us-ascii?Q?Qp5RJg+8NZVLUzQTwmJAk4Bx01eJtaA+1LcKqzNTyPN792yxFgtk70i9PRyn?=
 =?us-ascii?Q?ErZacICcJVHseVhHFncN8or7kvC+NEpPdIynkUxoczA6PW4uZJJ7AC2jjHmm?=
 =?us-ascii?Q?z+N7GXDezAxqLTYLweKSTsB2sDKs1jo6lAsniKZNCbVT/BdHMBMQf/8FTlnc?=
 =?us-ascii?Q?L280Q09wmQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b0c7410-8a6d-4067-512f-08da44cc906d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 19:17:41.4228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WsLM6NmvW0yiAOZpDwVdbI08bvjMncMOJhAsXzKLJOTLPy32+EsCYmJEy+bJKn6a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5150
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 07:19:46PM +0200, Eric Farman wrote:

> @@ -125,6 +127,18 @@ extern struct mdev_driver vfio_ccw_mdev_driver;
>  extern const struct mdev_parent_ops vfio_ccw_mdev_ops;
>  extern const struct vfio_device_ops vfio_ccw_dev_ops;
>  
> +static inline struct vfio_ccw_private *vfio_ccw_get_private(struct subchannel *sch)
> +{
> +	struct vfio_ccw_private *private;
> +
> +	if (!sch)
> +		return NULL;

WARN_ON?

Jason
