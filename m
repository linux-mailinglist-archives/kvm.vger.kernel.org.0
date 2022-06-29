Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE5055FFA3
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 14:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbiF2MSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 08:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiF2MRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 08:17:48 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6827231340;
        Wed, 29 Jun 2022 05:17:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DyrMJ5aK/aw9W+Mr5EDicVikmTCX1WsIe0Pkhlw4rCi6+wVr5ON0CxF4+iLxHnMoGoh+zOE6Q8cf2f6vcG29/eHN4wwZgi968TYQ63+A4tlG7hbmYiDaen11/PA40I3lAv/EH5exOll5QuziuEFrUzvgTOkPI2pB4AYsf4ce24JfB95p1BFC1wd0Nr3afte5a9dv9QE+/ftYJFc6xccaDM86qSZcyQXwlShcDmG7S7iuExgV0Q0q9jPFVa2CwOf9nsf5UsD3QOhd+umNIx+1bUmMdsLfGKPzR4u1RhF4Uf9nJgjngZvTLW29L0TObvPm/gU0WtF/AAJnpe4R4NyujQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csq6VlZcJEO5HlTS49064aX5FhKLh5OFmvCMk7SyhYg=;
 b=N41wH9OXOD3NcA+8QCQVFRM2xtkTWSPgdUPSsRhoZRbMZYtGl9q17FfEPI6mcUlvlvT5ioFEs/xQXSg5JS3FZueQKmgQFqB9xwfoRnf0RqXuA9RMXXFEsdaBkXVm3LT4oB7oSkyg/jd2t2hfwIUXNQgW3mMCa2JvKFBzXVTKJvxmRTU3YYw0N/O3B59TQUyEHLa13al+f50RSqBeZ8utej4obIgQw7adxrr87m/cI7C1oUAHd30n+FC6vTTSIG7GKLM1nyuCRH+SXCIX90Rxg5gIoIO2n0R0TccKHojcDUPXsUOyGus83iA2f1WLW0jWAa2OJEc61+JKnk5KXfd5RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csq6VlZcJEO5HlTS49064aX5FhKLh5OFmvCMk7SyhYg=;
 b=ogwjbCVBY9OStXn8wRpnfGP23GGyapfCCilhevx16Wy0ZY4G4WuSzba0TMSmi6XZJIZX05zot9DNx7JxjP9GPxyf2CwG6EcZINrVqDvGpuUurzAWfYM9xMcD1brPMgiUfYdNnA4bUZYrehfQAMzyEugeyuu0NIgFCsq/5fSnMBFdMNfQrg+yvCf1cUfH1WCHjsl9w3lOm2YXcukQzaOr1U4uCSMqptpUUPJvXzS3xV5Rn4poXuHw2C6Z5PULZ5O5zR7MXfo+glD3L3JNdTksUpCjLJM6qSMj+93wKN2B/wt/NQxG8BnEn93u0/YGwJsxcnSQXZtSYamLpKnXKl89zw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5372.namprd12.prod.outlook.com (2603:10b6:610:d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Wed, 29 Jun
 2022 12:17:10 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.022; Wed, 29 Jun 2022
 12:17:10 +0000
Date:   Wed, 29 Jun 2022 09:17:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 04/13] vfio/mdev: simplify mdev_type handling
Message-ID: <20220629121709.GI693670@nvidia.com>
References: <20220628051435.695540-1-hch@lst.de>
 <20220628051435.695540-5-hch@lst.de>
 <20220628155915.060ba2d9.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628155915.060ba2d9.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR01CA0026.prod.exchangelabs.com (2603:10b6:208:10c::39)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2df90611-0a08-4d03-885d-08da59c94ab9
X-MS-TrafficTypeDiagnostic: CH0PR12MB5372:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oK95/DwLuS+PqFSv5tYTvXxgWNiuRRwolKVKMM6MoBZ2c36Aekdo4wg+TUOTYODpuYW9N00pgbNVgVtw0nwNOZPNaOhPuU5Nb9+yKG6NAkMepB1bbhbMY1yAtaN/Lb1bjm23wlV9umjzIf/4R/Qt8o3E9+sRSHg7igXCxsNlMBoKQA1+X8bbOeJLLoBar0p1F3TXl4MUC4RDJvCQ0m+MV+r5+DJ57FU//wVypVj8wRtG23UIDfSpdggq4My0KpC5WIdHBWp4mSFz7NAtmv+zEAc55wUQzIy3loRYaHfd/DiaKlQt4cbqQWC7+X9Vp81NrV33FRzuynC25j3r5ArhYMg6xCuEwHpyv7SeSS3iVzZltaz4EX1NgfjI2nHgzTaT0LTdohJ7a1ZgLlWd7UhfpE7TiFHCsOGDRXhZ+C1rdlFVvSRaJ6aj7SHdwfRjEPIOpcy62KSxRMqdnmK3v8UQSIUJGnm/w3cxWRLZe1bUUJ0TcfMaGvv99K0wjJxZx931qATFkJ4cP9ZhZ1bex4sB6NTNcqITUTaeVq630RgpIZbExunkrMp+uq7z3Qn7xZL8ccT9RXrDZxg3zMBsAZKVArh6fuIo3naie6fAJqd+y69XBiIIbTU3rs90MKclzzdWExTUM9cGoyCRsyRhKbOGFDFpVVHAg/eteFgm8ku9r00f+Eg4NmUiwmF+C3uqJ5+1+WaKOlOknedpk0BdT1/mwLz0lwSKIpSOTqnxiYTei3vE0lP3wxfQzs+owwA2aWkc/eE12msgLK6FP9l8xcVMLSg2Z2FbH6zSYC12+KkKygs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(5660300002)(1076003)(41300700001)(2616005)(7416002)(8936002)(186003)(478600001)(6506007)(86362001)(33656002)(4744005)(6486002)(2906002)(26005)(6512007)(36756003)(54906003)(38100700002)(6916009)(66556008)(66476007)(4326008)(8676002)(66946007)(316002)(83380400001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DjIeAfBOqEctSvuzHKa13UmmcWMxwgyl48qdIEgqKEnLYp3egPGMI3GtG1CI?=
 =?us-ascii?Q?t5zKfKXFljDc5dhzFgnnqbFZCJvX5397DGTybW4ZDJlRXJPDVDt1ZSODI+VI?=
 =?us-ascii?Q?NzNnJIBoVSAe7E0Bri/hoaa7GG1PBUyWIkx45IQHc0Oxm8Diw7OHYayYQu8s?=
 =?us-ascii?Q?VpGmoA9Tq/6/noGz3qSLTlc+BvyinTBG+HoIc301Eqd73bYQ/l0Wau8Mwnnf?=
 =?us-ascii?Q?qxaqxaIxPqxj37UtvncZo5MDHbooycMMq3s0pdEWRPaHQrwn4r0RY6bmCy+X?=
 =?us-ascii?Q?Q1Z5/fWzskC6/4tMvzo05IPbC/MblLYojHOEGzc0l8TXwjFQ3EHlIUHVJd6I?=
 =?us-ascii?Q?OtHwAt42MgIe0TQEF5bp5jj9ZVVhqcToDEvTE+yd6WpZ2nR2usj1Tn/yP+nJ?=
 =?us-ascii?Q?4bgTutXFM+jTVBpXMH1VgFR1uNA37FU16bA6b0QwEq/5kmx/7tp6PY6nsTwX?=
 =?us-ascii?Q?PCMDC31fPjAUIxGe8sfBBRedIbD1RJ5dI1D77il/+Zk6vw+eyXdqUINrhrfK?=
 =?us-ascii?Q?SLEwDnoJIWOtcxFYOivCtrG+7nfF5vPqw+Z1Fb4k6iPs0+e/W/NylY8UroJQ?=
 =?us-ascii?Q?6vbl4Zlek4m8zoYa01wxMpn2KOR2fxv0JaVh81CruVIKor+9HLDON2Kf+SyN?=
 =?us-ascii?Q?+ZI4byHMDjWRJMj6hhhiIlxXB6rvAI5vaKYPgUgobtUnh3PUzlnl2tE4K1b0?=
 =?us-ascii?Q?gPUxLiKgp8Omxy/d7E3T3ItjMGl4zprLgjwX59FAg8BR0oLKeIHbWAoRA8cQ?=
 =?us-ascii?Q?qMTNPBH2xzeqIqh6Ngjuhh+NLnhcDbio7nWRroqY3xrzwkMXqPWGhNiLPUnk?=
 =?us-ascii?Q?oNJxLsG7DcGHcaefhavwInDYhFTr/oGhaZrllOgVYXwR/McroCwMaZvHJEuo?=
 =?us-ascii?Q?E6i/PBIL1Wncqaw47Ev/N8lw0t8PDKo4y32km8OgpgKd8nJHKrUWYXGCxW5z?=
 =?us-ascii?Q?H/ei1f98rNO/++68/9zZlGelpSOPKvZ46Ijx0pODexF/+882imBnI9FmWGmB?=
 =?us-ascii?Q?NSzd+I35skfcQ7rZ0uQR7eyhw+bAlc1Fs8GS8AmOhUS3c7F99tRCNQGt9O0n?=
 =?us-ascii?Q?M8syCsm3BgNhDgaut4s6fQpJIEih/spBtK8YhW/ONHPHohvFNScNR9siJyIf?=
 =?us-ascii?Q?Ggzg8Ljhs+T4XlIxyfANE3febi9BRIaAJAAnGKz2Tbf+6RNniU7Q6+PK2Vzw?=
 =?us-ascii?Q?hQjPn/3NWSDQkkSzdCkadXKXJjC5iF97ai5pW0yT/pH/GMWP0c6vNtcSvVJm?=
 =?us-ascii?Q?xFcnj9WKz+RtmvTJnfBA6sc/BQed85DjRgCOghpgiveyyN6/bH6oFvr8izdj?=
 =?us-ascii?Q?qS2fjAIGrHAVSZ+3vUl3m2JL+aLLLnW5IcJOuAUBk2aJEaMqh0vEpHeU10B2?=
 =?us-ascii?Q?lqd0ymq3WNSi/rCsBguR3d7dYvW/B7+vUDs20ZtQgYU0I9ZkKGIXpJHtaxWz?=
 =?us-ascii?Q?WaoqP9b4JFhHHjbmE6wwYuO2uH7owO3IV1AFdbFSnPVDQAThIEgK/eFBpqTm?=
 =?us-ascii?Q?9fZbMfNH2c+qdR4Xx7f2iIHPkRQGaRqDdL2X44likux3+hK22y3GJLXicOeB?=
 =?us-ascii?Q?z4akJjDmvHN2+iRE5h5roqFRbGtfqTzxdY+iIvNs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2df90611-0a08-4d03-885d-08da59c94ab9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 12:17:10.4712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fiJ2I/rdf0NyRLt2JwyYcpX1Y6Sgc1foPg3Vggwi/1H2x+2h/QTWgSNlUwgzyJRM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5372
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 03:59:15PM -0600, Alex Williamson wrote:
> > +	strcpy(matrix_dev->mdev_type.sysfs_name, VFIO_AP_MDEV_TYPE_HWVIRT);
> 
> And then this might as well be an snprintf() as well too.

Kees has setup FORTIFY so the above will actually throw a compile
warning in build bots if the array size is too small. Changing it to
snprintf would loose this and cause undetected string truncation.

Jason
