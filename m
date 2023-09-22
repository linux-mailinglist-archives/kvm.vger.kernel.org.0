Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8154B7AB1E1
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 14:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbjIVMLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 08:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbjIVMLm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 08:11:42 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AF592
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 05:11:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mv33NegHGHCFEHr3XCH/k4kIMu77gzDItq0o+uxtGQcfGlOftzSYOsMar8tXr1kzY1hWU2tkjaorE8fmJ5TyLSJFNUQPnT3GjY5PUY5nWfdjexT7dcfaj1noQdRPkn0R2lDvamNSC0REPiwgOXyTJnNvqH06NUDB1GhGcT9IP5Nbd+ucOIYFMu9MGVZ251xUmHbYmHHabXiEzE4mATV5LJc3AYqONb6O4P2axflXPWQfZUKKFMnonqP86IDETwBhFVxf7WK36s8ZzrLRdYmKNQI2sl9q2zyEYDhBTCzdssOKzo9DexoFtKdoqZW/ykZL9Fq0GA1lWo2WkuFqmqAoMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14i2wKkODebNr6x5hdhFjwpLGSwSzxfEdsmpu2cXfAU=;
 b=BSsdSYTzrQlLFSK6LQmZhx40K2DxVQpNmKnXcxt94h+OcnoGxw1rDa6MaRbbjwprZKJjisqhIoyKyLJtOKUVT8BVlg24+YLB8vC2jn5hzU240bgieXQ815Cw5yk0ImjvLj9Q0yP8OMgZyeQmuefcNvpbsnvaNNmgEkOHiFVIDskogicW7ZQJGqXHXGYhdJTTpcZmMIZJf6xGDikQme2G/IzjxJaQ4JsOHbtNhJ1mtLMSVHKSn3NXdHZl6ke+7shIEF0yMuZB4SIo2h6wg0R/AlO6Acn/ICX3ZJsTUvgM0aLISgoDO1p2mzk/dULYhF6gLKI9zXEaYFs/hp8spuWbog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14i2wKkODebNr6x5hdhFjwpLGSwSzxfEdsmpu2cXfAU=;
 b=jOErSWdSsSiwBYg0FKyROFZLy7mX7IEf2G4KKmyqC47UWg83NJCyBHrnx6kmv2Mk8I1esoPtJ2kIrudSbpsTMP2sVJaY29bO4nF6CdG+XxdoBGbnOIsOzFMElRbpc0OuU4KW8C8MRjvS2OyerbYWv50T7WoylUuxowqux+VkUDeQHWrubJr2p4nlMO4NN10Cy0plFCTind1HNDtnoPFMvYHOWzmFuIJnMMoIeuKRljNyalyMVUl8rvXCPyPHUJ18AP/ehVk8OUqPwwDOJsS+gwONkTiV6MbnLsOXUpKLQgDMQ+DHCajyQ70vMiLV1Z0eAM/w8M/8laVq5OAUD3H7RA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6823.namprd12.prod.outlook.com (2603:10b6:806:25e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.31; Fri, 22 Sep
 2023 12:11:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Fri, 22 Sep 2023
 12:11:33 +0000
Date:   Fri, 22 Sep 2023 09:11:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922121132.GK13733@nvidia.com>
References: <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com>
 <CACGkMEvMP05yTNGE5dBA2-M0qX-GXFcdGho7_T5NR6kAEq9FNg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEvMP05yTNGE5dBA2-M0qX-GXFcdGho7_T5NR6kAEq9FNg@mail.gmail.com>
X-ClientProxiedBy: BLAPR03CA0038.namprd03.prod.outlook.com
 (2603:10b6:208:32d::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: 3055fbe8-41dd-4c39-667e-08dbbb650f94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rVp/IWItgWEKIzxAOdJRe8z3DlCdwMabvIQVWoZr3Yig3egkgcD8Z4Gj5NSs1lw4W2av9KFAfusP/J7BTcItV1efOA3ax8vn8DjRPcqNNJoZRTdmXDgyhRiJIp7jVRR4GJBsfF3otTmOGe4O4ipnu1sE10s5f/0DSTxbwjQi9skl9wKTLRiJQQF3e/93f3fsghMxusdjSsCa1fh+bTz6c1Y7u6VeSUHtY2WjBq3sjVbb/TOvkWPNsGVoXK9dDrDQy/uCPEdH/wSzolR9vnaOvtafipiQKc8fgMIigM9yWSj6OuEgZb13ljqSs8zULMj/JMWHUso2L3jsi1DDVBrm9u92axk7PB3AjogYtsADtVYVEYkDvqSeCoNkvxA+YxjDMY+dbMSuujKI4OCK9YN5ZBso5q2108ITQOMnA6wRyZfDGvcc/PHZhyWs2/g/8tOhhacQBRlyi9uzUyIPu2ekINP+F+qLpTkwrnq5+qkKib6r2CXqcT2zS43MVf4qymuwn/ofi0ZbuttsrTiRJhRVk0yV+hJClI3uc8VY4j75RfjxPbc0L/jo0EORzNSoFI9L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(366004)(396003)(376002)(186009)(1800799009)(451199024)(54906003)(6512007)(316002)(26005)(66946007)(38100700002)(6916009)(66556008)(1076003)(41300700001)(107886003)(36756003)(478600001)(2616005)(6506007)(6486002)(66476007)(33656002)(2906002)(4326008)(8676002)(8936002)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QYExFbmW2jbG17VkXWOsSEgz9CmGioqLz1w9KPfKfTt9YAgFpz2PORjSWvQY?=
 =?us-ascii?Q?x3Y1fa+f/eDH+bCTQ8SxB2z8Qb7z0AzlROm2A9vKm2gnKOJSya/bgugnFiHa?=
 =?us-ascii?Q?MROun8Fme5OYzOTa9dZAvY4KdDeIDeEr1qbd6jgB58QhKkxL6ZVbYoS0Z0TF?=
 =?us-ascii?Q?pmQRrLMotBhz3rHx6EZHwj7/O4Z4RF0J6ISVQjY5T5xFMcxPz2hFcFVlmPEK?=
 =?us-ascii?Q?/ikL/Wi9PvQJXB5xMuENJaMTb/r/X2VZv/vDyCrK8CjvzLwX1RyIMwmlwCmx?=
 =?us-ascii?Q?lbzCO7sTs5tRwguuo/m6r2Vg8MZshyMhqJFJCoGCRxXjdT85LnVKIKb66yh6?=
 =?us-ascii?Q?RpKs26OF3uO5roYvZbovLnQjNrMlFhy0JvAM4NVdEWZ4x5RxtS3H0dCrru/I?=
 =?us-ascii?Q?IRbu+J+wf0NSRUov3CxdNH+xKoewjN99kTUzwV1YRyRdgvl1fRJFI5Tw3O5E?=
 =?us-ascii?Q?d4ny0Zdf+4Qos1FLkIbp8BKB8ZHxVFdS4IQ8AQOtXxr+7vv++nmxtyLlX3Vq?=
 =?us-ascii?Q?pOwsKU4w9o6BMUSYmaNUd0LXsJvH+x3mr0jzAlgjsHM/j7gyBV+Des0irI8T?=
 =?us-ascii?Q?2SO4NKy4olwFD4stvj/Rxxuarm4Igrkpfpo3/GfSsUT0xX1hL8m3P8uZ8Tro?=
 =?us-ascii?Q?DPRxeU4pw4Gy8C17QFg7tUQQ1kL+oeE0P7pZ5j15NBZl6iKpniTwE131nBgg?=
 =?us-ascii?Q?LXqq0TJ2I5/sTsRrOCUanPdSqm0rXwTDqXV5lXhiIQBOv/C1TguSP+7w7tDm?=
 =?us-ascii?Q?uxXzWOrMm024v2a7vPhtj18EbxtGjGfHofIiUrfpmS6uhJ6WHxcfuSC+8I4P?=
 =?us-ascii?Q?aGy9ZX3QS2uXNq9pjG9b/1OMoyWD8xHRRUiLtA2SjfJhh20iDjajXun2CFGL?=
 =?us-ascii?Q?/cpGVU0kkOXH1p9W/VZBElG6On3BRjVWjMzONHPusrsp8HWK6lsZpE1fMCAq?=
 =?us-ascii?Q?ZDYFhQNSz4Dr/32i4eqtynLz6hq6M7/CEwbbzzl9OCV99TVIpR3CpCsLyokr?=
 =?us-ascii?Q?AeMcJjkk9ldt+cwAzO2z+dVsa5GKRICVcqj3csaE/5d0k6r/nG6lJW0fxska?=
 =?us-ascii?Q?fh+vvrkoRLJv0xhAu7W4EDLUdX/k7GYMt57Xd2vqLk+ju+k1eR4jkAFgWN+7?=
 =?us-ascii?Q?DXUtNoFUhSmcG0F+g8atuU/1xgtbvf30PzRUzho/hV7iVzX9sEATPDHcYCZ0?=
 =?us-ascii?Q?vD/fk5jJEBAGnuYQfyNhAjarUq0JlscufrUqexSK2goF+HXGmjC4OPkkxd6R?=
 =?us-ascii?Q?eZ9sYotSWYKMKpJSaOqbcC6VQNhAut2sxQIOuXWGlIL3h2eASGNPDm0NRbzD?=
 =?us-ascii?Q?d2qJSuiGgve0aPIfloVpa0F1kFMfx8HrO1M2tJPrGWwHFItnyuNWduEn2PoU?=
 =?us-ascii?Q?Iw/GEYPB1d1sq+zENBoN4MxWzH6nl8QJ3OzixTisDKcLzV1ZqvlAUEah5WoQ?=
 =?us-ascii?Q?3Dr8EZBEKCXBeYwCDBt0cn7aBSu3YnkXYRIg83lL2dB8yKudwIG/LTYeWxve?=
 =?us-ascii?Q?sjmkvPkBqI2CY3ld8KLkmHcKHRhWtUH9oPfgDkNjtnj1Erf0Kn1c0aYHXTRb?=
 =?us-ascii?Q?y63hLi1lh/YEl4YAlbWj6uUQvCLlEPEaa4n8cg2f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3055fbe8-41dd-4c39-667e-08dbbb650f94
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 12:11:33.2334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JnmCScZDO/s+zz7SHqjUlEKsrmgItyO0o2eJnue8Y7csa+qTBA4YMSSF4BCpx73s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6823
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 11:01:23AM +0800, Jason Wang wrote:

> > Even when it does, there is no real use case to live migrate a
> > virtio-net function from, say, AWS to GCP.
> 
> It can happen inside a single cloud vendor. For some reasons, DPU must
> be purchased from different vendors. And vDPA has been used in that
> case.

Nope, you misunderstand the DPU scenario.

Look at something like vmware DPU enablement. vmware runs the software
side of the DPU and all their supported DPU HW, from every vendor,
generates the same PCI functions on the x86. They are the same because
the same software on the DPU side is creating them.

There is no reason to put a mediation layer in the x86 if you also
control the DPU.

Cloud vendors will similarly use DPUs to create a PCI functions that
meet the cloud vendor's internal specification. Regardless of DPU
vendor.

Fundamentally if you control the DPU SW and the hypervisor software
you do not need hypervisor meditation because everything you could do
in hypervisor mediation can just be done in the DPU. Putting it in the
DPU is better in every regard.

So, as I keep saying, in this scenario the goal is no mediation in the
hypervisor. It is pointless, everything you think you need to do there
is actually already being done in the DPU.

Once you commit to this configuration you are committed to VFIO in the
hypervisor. eg your DPU is likely also making NVMe and other PCI
functions too.

> The problem is the mediation (or what you called relaying) layer
> you've invented.

It is not mediation, it is implementing the OASIS spec for VFIO
support of IO BAR.

Jason
