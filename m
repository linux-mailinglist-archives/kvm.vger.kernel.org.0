Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B65E4D9128
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 01:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244984AbiCOAWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 20:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiCOAWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 20:22:39 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2061.outbound.protection.outlook.com [40.107.236.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272CE3BA6C;
        Mon, 14 Mar 2022 17:21:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDACaqsZC6QnsTvwX4NaBhFgUiwoy1LUdKszfRZ3oqFK69K4GA4sGBUGSoZaFVR/IGLyLV5Bhp3BdsG53AjJcMTLlgiYhPgBDOGYyRGEmOSPWNC2Sm8heK3tBD+NHEJVrhobEUcAQ33ALxlhtafW33IfypjDsMZPx5mwz11y819bYxPBW/zgyNLkp0etZT2fATTXi/HoHQ7WpzppMtJ1+cOk3s59FaNc7sZASKPp+ZxY08kMm1fF21fUzwOJdPH48OIOKI+dNjiVza1kBnki35iMSfS8zZJZHgOxznOYyqZV1GVXcDMy23/E7Ar1TT2kxyyjLOo1bOnxIh8XUIX6BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SHA4OMOCUl1HYoG2QLcaafJ6FG6OjkweJ2kcI7qgZ9s=;
 b=njZgY+zV/p2P/BDdR60loWlYcY2SR7VimfWd31sTlRzZmTuwoXYyxNzqY+1qGT2kLTASLIPlMTgvu42/lCFLtOCWdXLUPfKuWKcRiw4qrrdCIKWNVvS/JQNmPj98gCRjI4kIy2tbNPL12jpvfUZNVCGsid6EAsPYyq9Ry2buruG+SRmeJ4pw2MNPQmDkoV7Avo2/4GUCmCLEaH7DXsesIcyzWzJK0CX2CMiYfKn/jjiw2xf47l9JoubGRO4N6MC/esxiKGkqNZgmYtlShsdmgV7ru4SEH00wc9VWtXx0ebNd3zTs3QH0CnclP/bjRykBS3iF9DSY0SKqO8jOsC/amQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SHA4OMOCUl1HYoG2QLcaafJ6FG6OjkweJ2kcI7qgZ9s=;
 b=IqZYi9EDtnRi+iqM6cSlmsI50po27hLff+b1IZSbx3Hwq1Pr6L9uJPj/uQYr9LXpRvlRH9ZBjDzOnR3XpAQASvVys0ajHNuyFBFBFjF7NZYa+JXh7rxq++JiQRKTpOSqEFP3goXIah9x4SPNpbZTtw0G+r+rpbfKsP5MqAwbd6H+yY9utgwckyydK/tPG2fqMDvu7ERfMqrV8CVGevinMQ6FILktBL3e2WsI6Jd8kxWBClrxtNDyFnYiGlHos2hQW5mTVu/AiBIy2F9mpIx9C3qZ+YVgAnlULLGk30JHspS1NjzkXJzmFLurX/0uKVvTVEbCq++zlke2OI02QSMA9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Tue, 15 Mar
 2022 00:21:27 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5061.028; Tue, 15 Mar 2022
 00:21:26 +0000
Date:   Mon, 14 Mar 2022 21:21:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/11] Fix BUG_ON in vfio_iommu_group_notifier()
Message-ID: <20220315002125.GU11336@nvidia.com>
References: <20220308054421.847385-1-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308054421.847385-1-baolu.lu@linux.intel.com>
X-ClientProxiedBy: BL1PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:208:256::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c95f2ebb-43ae-492e-1425-08da0619be43
X-MS-TrafficTypeDiagnostic: SN1PR12MB2590:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB2590FFF757E74BCC2BB52437C2109@SN1PR12MB2590.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zUAb67HHe0Lcbba8gEU26JGabEjxcN4Bzp/hzFL1tn+b6Rbrk7zVrctHGq3WcYsOiX5SixXjzZM7cDQPNsy94/umhxfb+iCEjaT3y6izolfImVK1UJZAf7AtuD8UO9Q8DSKBW/Y7Wv3Axju1bnDLOTYtYPF6sURD1B1NhH1TSfejiTxCnZDpJRuJeCGiDexkaLNwP9l3ec3lXOpSAe012fv9nLJQmkcj2QKUkABR/28FPqekk3IXaDvjCqSVhOr/GALHoh1I8wXktplbmeexYu8M70K/lE9QUUzh6yundRiEoFv6aBEvqrS48+1B9d0RFrAfUA9yxCYFaQ4Ma29S5Umc+KLYZ7iit17irNej2vjlFt+apZp+2Q4NfLfh4iqprGNEC/sTHUReayUs/Ey+o69cWMApKie9TP/pnV/Hb6OTQF8SVjPzML2ZGuIfWmRh6b20zhq/bFlq+O8hG1/GIcT1FNUTun1QhF/oGWSXfH4+svpbTgj7jwtctmVo66tA1nW4FMu39fwyt7FRnj4k8fXI0ypXZaycxO/E8wWqB0Gn1n3Kxy1JUWZZE26zA1J8yUx5Nb+2QF/xqujc1CD+cz91SqrIObGowvL+nO6ghox7Ieo0EvcpsXnKkMT0iS/Cg33vQH43V0vs3ZiuLNtXGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(38100700002)(8936002)(6506007)(6512007)(36756003)(6486002)(508600001)(7416002)(5660300002)(26005)(1076003)(2616005)(4326008)(110136005)(8676002)(66556008)(66476007)(316002)(2906002)(54906003)(66946007)(33656002)(4744005)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2BeG50apAi9xQ4LEMb0xBkzRnEHTO2C75KpC4rb1/9zGeiYTMTpydq+pCiha?=
 =?us-ascii?Q?Tuw6hplTtV4Oiekwhi0ub386UU1HdvwSiL4xjlJVjeFwtKGORc3ZxWvzy06U?=
 =?us-ascii?Q?XG7IIlu5RAbi2UT86jr43ccyFf5ivok0ejgPgeuQN8UbGSSVXGnxz1jzsbyd?=
 =?us-ascii?Q?JYqw6MCr2cMQGZImROEw57n8bM1iILWLFZ/6AvIXGrFY8s/+snOctyhhte4Z?=
 =?us-ascii?Q?LUn01u9V6a9z3vFuAB8vZMTG57o0fihqDvN3UmoIyBs/ppWgUE4XK7eLYfTT?=
 =?us-ascii?Q?vPbo+HxbjvHMF0TySpu8dOdaLJnKcWl2JIGayNPjExWULgtRsDtmAQgaSsoI?=
 =?us-ascii?Q?cTgU7TpV9/K2UQmLFeWKGOG7w81DxCDfknqh0kJ6el2WxgHOnF+uHxWmzEzL?=
 =?us-ascii?Q?se0m8qTYOmnlIe6i6DTTDkyRjCScb64f7ZPgQSNsuja0k8+HUV/y4IbKwTRh?=
 =?us-ascii?Q?O6LnMFv57epUl9X8DmytmIX6hXf3rApaVLCzMWCp8Nro0JfiVVqCQ2q3p22q?=
 =?us-ascii?Q?Sng9tp6TIL7h9BUrlwL7d3Yk/EcGBxpqDEtwXqxk4ghLDAXSvVkO5Fuh+AR1?=
 =?us-ascii?Q?QfREzGkaM3+lOlLHUPlIAvLH3R0ApAr/2wqHQEb0ibD9BVZ2LppoYj5WYABb?=
 =?us-ascii?Q?6WGi3YVWXfLuV9NS/a4acACqQ/pMU5NOLMeSnFjnrZMjHApgWWXJYYkdYZ8h?=
 =?us-ascii?Q?ixIrQkZnX0Ao1vCxq7z9IuOcMRecLvAq9rl1/ohwTLwqE1rtHp2XIdUO29rH?=
 =?us-ascii?Q?zoQwfwJn9LbZis1XcwbZIyIcHtVkFoJtQVVGY/2i9IiL6T016lx8411qCa9n?=
 =?us-ascii?Q?57N2A/z5t8HiPBEwAB7+VnifTURv1vMZOdFSuhtxCuFO8cj68HAwpvt/vviy?=
 =?us-ascii?Q?qZU186piPV4HW3xKPeyjpEDGdrbkXs060YBaDeMr0jxAktYPv5RIxVGXnWXe?=
 =?us-ascii?Q?eDSI2S2zowlvTXdYCstgn1RCi5C/2X1sdwY58yw2ZeSK7XbyjXJyjHoAVytv?=
 =?us-ascii?Q?bnQhy2AckX6GKSFch+Z6MnrXiudHFCnrLxiFgVQ9+vH0ettc/TMViHDIhZBG?=
 =?us-ascii?Q?oXAE/9delphD8eXp+IDTerf2grG2M1BEwzTlFA4YFIAV+x3PvNn8jRRsHXFy?=
 =?us-ascii?Q?PjUtLA5ncazCIANICZ0RoVhLKbntUCQWhrA+qIm/YDj0T0pKcd0yemc++06L?=
 =?us-ascii?Q?+sa3PNRqYX11Z+AtXV3bqYNWvMDxqt+lEomW5Nj+S6zfJv/0HqvZ4aNshSTA?=
 =?us-ascii?Q?3TDXhyrA/jcVkpISp68d9daZIcBAiKb2U1U/kRaCpJSd6EdtPgb8PeI4PvJV?=
 =?us-ascii?Q?u4muY03/VK2p5jJKb7dUiYvIiB9mBZbg9l+55DlnYyyMGaPPfQKTk/J6SiHv?=
 =?us-ascii?Q?0Bm6bw1O18befqr/I/scC8sJcGiHPn4/7WM74nwnP3sX1SOXM2eoBLc1+IIh?=
 =?us-ascii?Q?PAQjD3i+dLeOAGTtwWomLgkrh/78AAp/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95f2ebb-43ae-492e-1425-08da0619be43
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 00:21:26.5330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yqdl1RRZxGLBUzUORcxTRhruROcwGi+8w4OMna9Psybe6WycmPcfdKvk/yNfKNm8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2590
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 08, 2022 at 01:44:10PM +0800, Lu Baolu wrote:
> Hi folks,
> 
> The iommu group is the minimal isolation boundary for DMA. Devices in
> a group can access each other's MMIO registers via peer to peer DMA
> and also need share the same I/O address space.

Joerg, are we good for the coming v5.18 merge window now? There are
several things backed up behind this series.

Thanks,
Jason
