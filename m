Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953A953BE5B
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbiFBTGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238376AbiFBTF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:05:57 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134C4322;
        Thu,  2 Jun 2022 12:05:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIown9GnYsiE24rhc0u6SW+j/OYalRaR3PsLIIYDLWzTW1hCj3zlxbtyXYi7yxzRkX8pA3wR0M+K97CMtSIeoDoqxU/zZbzHvdpffe4PWxHgWSLBx4pEG1YHmmQv00m7rw0zdSJdEeMQ/zL22rUH5E/HNvefFqrdbnpyErKF3U1/Bm3PJ/SzpmuryN5pNvgz+SvoG/1PWT96Q3sqLrz6hWg+LvnhcWJ7nsB4X8MNhm4iWRUhwG+Xw7FI/33QGdFj/Qhk96mc0KvUpTui8/amGKVDFOMXMq9tyXTk9zmxn94a2egerz7htX+pghqb3cLQJAqZyiJDY3x675CV9iCFQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K65YQuj0qllBpCbvgOXuBb7sHu74sMRgIOmdYAj6PkI=;
 b=WdRQzUQavpiJl6tCzNTXzfO0C6ylQQ6Ie0mDqfnW836i1SWy43GogclwYzVpPS11RzXlx5E0VGJdASM4AYeIDzW0+Oeu2oO7cdCTTjwmoi5kZu+yq+J8lRCez10rmyvNe07CwRYvJuJDxznb7Zd4Y71aD7TZ1zgcmL5B99ZZZ0pxhYm37hTfbiTanKN68i8jGqKzVWvOoceLOLXtg9whFknOksuBQ9pr6dHId+HSJVLgAfSPFbKQSmFe5QrGTXQaVShsCU6rBLZF3elrT6FLepqNcw9jfs5E1Dh6D9s47m1aCrncfN6/tisrGBp3jYvbVDZl7ESAvssNJkTBBDS/Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K65YQuj0qllBpCbvgOXuBb7sHu74sMRgIOmdYAj6PkI=;
 b=TFFJhyxJhujadgaR6aGMsXl2RR7wfDrDMEUHWAx3EVKnxYzjW5ZKLJBAAlc1JX7UTdHNqWWK7L1hjbEL+J3QQSC9XRn158oftOdw6AkowVmaiAkNeP97mwYCG6kBlPe5lygUc1gOhxkrwJLFAf963xJWesz0QJsnorwPlyCEo03Yd1ibWhzDKbf2CUE7GkAFMYL2fqfs6skY2eB5HwhyH0CSwLlok+M4XebOzl5QayPfFsKvMNm5kD7t2EP499kijaTRa4nMmGPH+DE9aJatcyavPoDzu3YDK+18886RMSr5/l6AcqC4ZTtEvd5o3cUtZDywk2DMmlvSEVxKNAaT4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1930.namprd12.prod.outlook.com (2603:10b6:3:10d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.16; Thu, 2 Jun
 2022 19:05:55 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.015; Thu, 2 Jun 2022
 19:05:55 +0000
Date:   Thu, 2 Jun 2022 16:05:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 08/18] vfio/ccw: Check that private pointer is not NULL
Message-ID: <20220602190554.GE3936592@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-9-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602171948.2790690-9-farman@linux.ibm.com>
X-ClientProxiedBy: MN2PR11CA0014.namprd11.prod.outlook.com
 (2603:10b6:208:23b::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 793b24cc-a5c6-457a-921a-08da44caeb7d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1930:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1930B42E125A32CB13CF46EDC2DE9@DM5PR12MB1930.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r0F5hcuVgH2R6BhmS6dbcBQjPmINiHQ1GxpQwSZ5DxzZWQ51elucKWNtKtJ4WdlziGmmZLfNqNztm6EzyvcwBG1eqBKcNY2v7XWbvsEgliukn4+T4nl5LYov9RAKUlZD26sCDV+2gbMNI28PwABs98LYPgaJIJXLobT+2UXS4P7QX9t8ZlxJo4Etn4HeR3bn6xx1JwFtxuSHh3Wd/PJBliG1QA77V6Q7YBD/E7doy8p0xiyQGEdlTOponM8D3+rxyLjRNKiHOzbV69aEyVzbqmtyLH0CxGzblVMW3HQsOuf8Mfg9+GK5ZDR1+CGmfS/jtWW64NTpAZvVd0BpxVGEgEcTcE4MYMuYSQZc5yEpxCatWjPK6oEssuhtevQvJN08iqiPfkwJCVCTVlG+b3rI1yKXovsDoJC3XAUGkiuZ6TrgAApTR8Ackf6IrbvMvtMriPXCEboktsIcaNUPxNtxGDOOlK7KbRyuHIi+ZngrrmHeut+6N2g3nNPUJyG72rukIJcKzLjsZBvLg6YXQ73RS2LyRZo3ZAeQXhguBjVQpMzqM4a2BmWRgcAcfXWav8YZVuy+0yeMX+wLmADaOlX4ms1ey36R4EQWZpgYVTKM9CJqvqg8Q55NJC7oFApfNHJzoqE5uEzuIbdONcu2sE4BpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(6916009)(6506007)(26005)(4744005)(8936002)(6512007)(38100700002)(1076003)(33656002)(5660300002)(2616005)(2906002)(86362001)(8676002)(66946007)(66556008)(4326008)(66476007)(316002)(36756003)(6486002)(508600001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZkM6WcbHMBtTxNJkwZEMVvMKIGlcx+vJQ96JQALHKLAy/YMZWB+gXAx/oizy?=
 =?us-ascii?Q?Kfkx7rdmnC6LsZOZilJO8gnS4L6xu2I8cWRoNYzxr9lb9/zS74O1JW/dhQd5?=
 =?us-ascii?Q?99s2FYOB12mToNtkH6vZDdc5/ujnRsSLqV+7XiKWfjDUW93kENBM/hSskReT?=
 =?us-ascii?Q?Ycu8TzbDFU/LZhlh0BNvD+XUE+xQgq3r0zmvNGncYTbZmdqA0ZIGZMiEGr1/?=
 =?us-ascii?Q?HqMUwDyj/vRtlf3fufW2DB3cHn9xOCpAmrefVPkvtapM428oECUrYi7we1L/?=
 =?us-ascii?Q?mO9o+KKvHyXppz7xYSv9pmYGQpfL0F4FVPLxZyYuXdweknymB45qul0GzU4v?=
 =?us-ascii?Q?xK4o0rdfIbograXpudRShEhwxZCXDTt572nJ36H5APtGGkoWmOXDjBNGMxvd?=
 =?us-ascii?Q?Z3Tud0DaSaG06d4ECuUZa053GlA+VWz5a9uZxwsvNS8If57UThBHqPl0tSCk?=
 =?us-ascii?Q?GdZKmvTH1HAJGJvBx9HZpv/l8T2hZAYnGNWsAOv0SW87eK0zv2p5EJUiv3s/?=
 =?us-ascii?Q?49BZL6TzJNm7mIfn6LUmboe1cfi0HREfmMpIbCK7Uf8+8QGDPbpFj+G3O/jX?=
 =?us-ascii?Q?e8yihmJMVeyxQud7Hd909R5V5XiFlQzftSVD5mcF6IJZuYNXl/Q44cRfXLP+?=
 =?us-ascii?Q?lL/kCm1w4GZ0MzGo1YPu3klYB/PbHM7WbaGYlBYxZFfVY+hcIvkrgdBnkcDL?=
 =?us-ascii?Q?DL4b+U4eVZCsdE3DfGDS50vD/QjdUXu7FkTdNgT/BoA5ZYavDsiVWIe1/uU3?=
 =?us-ascii?Q?4+jL6nNLLFtzXGjyL9eK5Ozfei8gDYe/M9Su+RyRpjuwUHiYu+913+z+5z+j?=
 =?us-ascii?Q?4N6/IkdgFGRbELiuHFbdmbG4JXyeEVYdCbs3o3f7S0VBRuneV3qUbD5vJ7YR?=
 =?us-ascii?Q?NnUs5G58+usbrlySeplTsimhCNMKMe58LAlSapph2Q7je/acrr8+RYRyRSYZ?=
 =?us-ascii?Q?TrYXJT1BIJ2gJKtx7qPsUlSlKWn6iqTlLiUuZiqxYvPMhTRo/p+PYEuhTWMr?=
 =?us-ascii?Q?TancwLGZRs14s1ipVOubJKjgfNKpWRIlJq5HMMI9atyueVNgNuGWREQKeKGu?=
 =?us-ascii?Q?7ykepVwGIaLRa4Wby8aqttBsu8l2QDa9xoSjAPXSdL8f6+rXOvN3S6qZBhAj?=
 =?us-ascii?Q?ddA7mUtPcN/0mBt5PDRaZOm14hmIEk+rU5MKaR3bujnfkxV9oYDUN3KCLnIK?=
 =?us-ascii?Q?SPzoNbdm+JaxPlC/6LGS34MGVmWLKjZAEAYVGzdyB7cUhFlx+ywh1MHWvHDp?=
 =?us-ascii?Q?DbHudUNEAFTKkyQ5BfLJoCxojsTtXuwKyDLXv7nbcflyBpkYkjdZ7nrdIA0o?=
 =?us-ascii?Q?zfwhXqL4IQb3yhvtRfQD9W1Zty2jI6vN2Qr78SgQJTdt+TP9Hy7mNVNpszMQ?=
 =?us-ascii?Q?CxvtkZIGN9Ec1/6amzWxxej5P93ZEIfRX76adGOTxQ+qTN/l7YoAcoCSkI5z?=
 =?us-ascii?Q?ViHmw8VGW4xfBFVCDfE/9gFV2AZfswledS4Ci6GFavE6jOxk1tNg9VA2D9K2?=
 =?us-ascii?Q?M582bUA201nE143jd1l51+xiLnAudDRHRVDhzAtTQQyosBUFHhsKcSmhSLZl?=
 =?us-ascii?Q?4Uc2hJlYeBeIb1dPgBiu/BOQcpcuwwoH4c4leHF5GrcDNjg56Wjku5bhlHa8?=
 =?us-ascii?Q?WU3975DTpRDyPEso/FB4Y0KOJcM3UwtEXkG72VxhWFbZmqNcNi/MT3c4Sqsf?=
 =?us-ascii?Q?KeSfCskV+Z9WTyp0abuZpZj5VIrUOM8BvzuZfSrsS0YwSQ1/6Yq3DUtTXXpZ?=
 =?us-ascii?Q?dGP1duMP5Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 793b24cc-a5c6-457a-921a-08da44caeb7d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 19:05:55.2553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4OELuG0nd9XgzJRrtpVWzcIbR9wA8+OL+PfoOX9a3lMFYOp3OCpuia78oBaew5tR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1930
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 07:19:38PM +0200, Eric Farman wrote:
> The subchannel->dev->drvdata pointer is set in vfio_ccw_sch_probe()
> and cleared in vfio_ccw_sch_remove(). In a purely defensive move,
> let's check that the resultant pointer exists before operating on it
> any way, since some lifecycle changes are forthcoming.

There should be no possibility for the drvdata to be NULL in any of
these routines, if that happens there is some kernel race bug with
removal.

Thus all of these should be WARN_ON to document that they cannot happen.

Jason
