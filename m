Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBC3766D40
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 14:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235855AbjG1Mbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 08:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbjG1Mbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 08:31:39 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EDE19A7;
        Fri, 28 Jul 2023 05:31:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9x91hnrIgJfQOE2XW8qhjImocDySfWNdFmGHa+WHV5HhPuidBu2xkMchZjk1urDrry0ApB+vczshwohtx5+1bx3QxSZkuz0+DP0GATHS6O/ritHBSpHlWGCcmH1470vgS/pa8Hn5ouNoEDQWsANPZr+aBZPZ8g+17AoV+Os6IIYTEtU7dtaUgU4ecMhL9vsZ5ew4XuOWdFPxP7w0VmD7DK47DBeV0n+97wyMSWWoGwmX7FnM6ylbSkV55x+LiuUP815QB61erbFymJF/LtMzpK0fawJiXk/h+v2wtPuDCQmcAK2hoiPzuKBgx8lVrM4fJETW+FX1TG+gIOcflTa/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6u5TQugoNrT+0mDDgG08AO4iAErmF8FHJE4JafqrYJE=;
 b=eP894++jOSulOEjyzpXoAaCBrtzl7JPVE0HDrZhxgB2CO2zHAMNnGfB0ya0eIltBxXgClNzrbnmKBh9WIqyzJIoLUlG9cpaNhGa0DOQ9vKXCYTKq4R50WQp0rNHC86RzUTL8Ld3tHEoU07VMYvfAP7RMCKXE53kAElnRHhKCTYAKPOsB1TV/7XHWMtZfv2DWu4RC8R5i7pnJPidp9NlbcqgnmJTThj63tvMKDrXBpbHnSpIAn2K9H8ZyaADIUf2XqwmDdlhVJ9u2gyEcEju/4bTHt0C/gWrZhz0iel+bbWhcuNpqgLeAQuU0yyJhzgnpO/0EdXvIvzCe3frulyDanQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6u5TQugoNrT+0mDDgG08AO4iAErmF8FHJE4JafqrYJE=;
 b=CCtITc+tW74L7ZfD89pLTKutOdFCx3G3NJ3OZZ2PbOPIk9Szmi4C/awPKx9+qNPMgFZ+ZitC1b5Jt30I2seXzGHTNenUe8qnVvzBBnoWrbmleSd4c3zqtT59qYO5WrU3MQqKaOK6Sb9+OmzkdBG3m8lQzPB3IXHP9t0PcotygFjsefkO5bleE65YLsh/PrnekQjOWfP9US+cnOgH6lppruTunnRg5mBCzD4KQ08SxX5oXa9kz2zGKYDuCOuqdJOoxaTOf0MjtaOG6TbqAlsFbWztcBnsgn/qsL6jkL8k/MdYjUvGz9hICYKLs6Y3qKAD0OwLepu+vmEFdmyIF8f5nw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5139.namprd12.prod.outlook.com (2603:10b6:610:be::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Fri, 28 Jul
 2023 12:31:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6631.034; Fri, 28 Jul 2023
 12:31:34 +0000
Date:   Fri, 28 Jul 2023 09:31:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Ankit Agrawal <ankita@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZMO1H/uepDTtAaet@nvidia.com>
References: <20230716174333.8221-1-ankita@nvidia.com>
 <20230727142937.536e7259.alex.williamson@redhat.com>
 <BY5PR12MB3763F22DF104E2B3BC65C628B006A@BY5PR12MB3763.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB3763F22DF104E2B3BC65C628B006A@BY5PR12MB3763.namprd12.prod.outlook.com>
X-ClientProxiedBy: BY3PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:217::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5139:EE_
X-MS-Office365-Filtering-Correlation-Id: ecb0c8cc-04bb-4caf-af1a-08db8f669459
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E8FLOMRr9YlRxZLGNoBgf6UE/iTK7z/1f+aRbJFC0q7YW85aPozfUv1zYXeVuD9T6Q53hcdmvSAFZu+EhbiqEZxtRP3Gt6YPZ2Pt0f4In7iTCm4bEEeDRbeVzOO8MPosfa45VHhuDYBESxu2s8UruNL0WrrveGQaxolpwRqeQbSt76k4U/fvP2fLeF0jhCtkD56RVc/1kG6H2ggX2ukF9QNlXdIDWZUOUCfRvaa6oV/rsYv0/JmzeJaktuJ12XhoGrWsgFif8vCdVgZKC8/U+o+kTVN0a+B0wBQ5w4z2FTBkX3B7mfOm8HjtlGm2frr6gaxBnaixr+bO4NLhU3pYzWvB+3jj/NWC7cG/dvFmeD38AnEbjF1INg3ru3yUaTwL5nJARxi5hElFmRyQic0eGdDjmcITrgVWnGDtsdmL1I1BaISXRuQIfgbRw3fV8VnZ4Gcd+LhF3gh6ehGpCwg5nZmlBN/jgecd9honECS4EUHnI6zlo88dVygzKG8QkgeHWShyRi+q9om21nKBT8oFmUskkct+2Li61sLvu1SUWCd2xq9Xi5ExAUktod5IWeIz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199021)(2616005)(83380400001)(66946007)(86362001)(66476007)(38100700002)(36756003)(5660300002)(6862004)(316002)(4326008)(66556008)(41300700001)(8676002)(8936002)(6636002)(6512007)(6486002)(6666004)(6506007)(186003)(26005)(37006003)(478600001)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7spfB7VfsUap4/xUG5WBElKtVEAdUXC3TVpY6Cm5Qre2QKkTScie0AIyVEDw?=
 =?us-ascii?Q?3ex9gmR+wyahHG3W+Svar0ebhiv0J7EcgrZEZ3x6I9puJwyYA9y5I3rh9OSI?=
 =?us-ascii?Q?EL8eN+QD3qqVxStsn2ogiW+JDKe9aKwr8RUmdkSF2ZGmi3eupgUOhjzi1fUu?=
 =?us-ascii?Q?cX/2ztV/1wuhPaz+rXR0IYzIySclzPi4XQjCl+8DkueBoiMLP8qfFzVXtKz8?=
 =?us-ascii?Q?ENeqZyRwfR71OZwim+LdfUnnvw5fcOlViBRWvP+kRwiM5c5QpKTdn1xVxVeE?=
 =?us-ascii?Q?mUnBwJz8mS7yGpdTAOieg4oo40UhFFfjryoWEjMYu4OZtJzHvzbKLxc8mqaK?=
 =?us-ascii?Q?ClOLRG1T015NxfExlK/vkJwh700FfdoM3YTsoGMTTW+szUFxnjcL5q+1sgMp?=
 =?us-ascii?Q?ztipaVPtYPBMAFRDhgU1Iq9Xhn1NQIymx/HZRqPTiTpalcCA6TcqjaNV5wmy?=
 =?us-ascii?Q?gS7x7UZFHTS6r3cuch5NSfH1aLo+IlmLJuM99l2558qDnBDB2rZnjtmz1iPL?=
 =?us-ascii?Q?HcMxwEJH2P8qbUD6KOpwb34qUUhSDZ8LgB4cnGniW9Y0T1v/fJRKj5FyzR4F?=
 =?us-ascii?Q?PGi88u1rPW7onCxyTAm/auQaGBEQvIKeTpMVnvJAktWAywQQNtISdkxyClc5?=
 =?us-ascii?Q?8ImDyMv72HVUJ9E+48pGsJYWHGQhMq41gm63+HaDAu6D49fmlo4lUNAI8Xrt?=
 =?us-ascii?Q?W45+Y96V7IfhJHgX1J8Zhx8wO6CptnxnOSpwZxEICU15AgJTKdWG1qxdxIe7?=
 =?us-ascii?Q?5EZT67vd5RjLwSjJBN84uBgB9jp9wqTUpUL0o0Rrm935zLoWuom0SYQinvhA?=
 =?us-ascii?Q?EG0YYwP9TG/Bv3GiuOES5l56j1NMNZjxNBOsP7yJZDvLyiUfspR/5A7waDpN?=
 =?us-ascii?Q?sIdOCtpE8CQp+GJW2Dr+wAY+lD7FKG3JqINgUq++Q0hrNesKMCy3ycms8I1r?=
 =?us-ascii?Q?MzFIDw/xM7E8naPMku++W3Y/F3M8fzJQYX7DfQyoxs9LYMjzGwLv9nRJumfF?=
 =?us-ascii?Q?+jb21ZRqV0pfmL0JVTvEOYeMxeYj9z43GXH+WagTIgBpBbjInc2vfS0pJgzt?=
 =?us-ascii?Q?CqeTkUkBXfezn1bDG1wpngN0yU6E1BmRFlAqe3wzP+oRmBOuHlhNLJaFLDw2?=
 =?us-ascii?Q?L7G0zmrfF2xBt8vKN8CceT5b2wV9/1eyYqKqnGm7YR1BjTGZez1RtEKAiniy?=
 =?us-ascii?Q?rd/Eu0V8OUGoez17Tk/DZd9HbQPqBK3Jb90qTI1fsvGqUSObzB1SSMHti4rz?=
 =?us-ascii?Q?IvxqC8z/zYFMqqOnQTPvlxFbJnnJnhmle5vFcE/oIzfPDhK8eQnVBSg0AHX/?=
 =?us-ascii?Q?TleUrbg4GSSylPyH3jmQesNkgVNf2zE6RDLWPrh+FFYNx3fYlD9SG56tjTCl?=
 =?us-ascii?Q?lmEzcbUZS2pu9E3HzAd4nJAQaCSDHJIiIGPm/Te7SSxSFGxBdW9Lmsyg9SDD?=
 =?us-ascii?Q?9Ym6754uOcX+womPFnfnk1elCgdyYniwc1FYqCaV3F8c+AkRdKezgKcgxoXC?=
 =?us-ascii?Q?d11GNHRwJmK4sHcKntYCKZ2Njnl0Td5jOysZ2EUwOROPFyuO+TRStuluruwB?=
 =?us-ascii?Q?qNVh/1ozpZbfgS6qlvtXjPEKUifyjHta3ZbHkZ96?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecb0c8cc-04bb-4caf-af1a-08db8f669459
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2023 12:31:34.3107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqklqHC4kzVKz/p7pluxY8y09D8oJSanGNxXtoye9wwFQ20mfLK2LeAc4817Y11k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5139
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 28, 2023 at 04:36:05AM +0000, Ankit Agrawal wrote:
> 
> >> +static ssize_t nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
> >> +             char __user *buf, size_t count, loff_t *ppos)
> >> +{
> >> +     unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> >> +     struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> >> +             core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> >> +     u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> >> +     u8 val = 0xFF;
> >> +     size_t i;
> >> +
> >> +     /*
> >> +      * Only the device memory present on the hardware is mapped, which may
> >> +      * not be power-of-2 aligned. A read to the BAR2 region implies an
> >> +      * access outside the available device memory on the hardware.
> >> +      */
> >
> > This is not true, userspace has no requirement to only access BAR2 via
> > mmap.  This should support reads from within the coherent memory area.
> 
> Just to confirm, the ask is to just update the comment to reflect the behavior,
> right? (I missed to do that in this posting). Because we do redirect the call to
> vfio_pci_core_read() here which will perform the read that is within the device
> region. The read response to synthesize -1 is only for the range that is outside
> the device memory region.

This doesn't seem right, vfio_pci_core_read() will use pci_iomap() to
get a mapping which will be a DEVICE mapping, this will make the
access incoherent with any cachable mappings.

Jason
