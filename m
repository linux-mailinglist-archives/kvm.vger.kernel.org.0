Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936037AA55A
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 00:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjIUW4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 18:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbjIUW4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 18:56:18 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB932129
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 15:55:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jG0LIf0MCV/5TIn1v4prAMK0ThsB5Qz5cdx82uMLoljbt3eTWHm8bYqKDuLtvtMHtC0isctB0S4ZqyHDC95uZaIRpmUkU13TimRpLWrSFr6x66Y2p72eVt6mjqU5XiQb1KRhvp7IeqZLmM8TqOyyYxpLj9H2OJ+rYqH4N3E4le+FBVh+O8x1bEtsebKZTzl1qaUrlHZKMSrvENEfb3L0jgQYpTRyE0oaDjc/MZcps+aWvQZKtMIZpH3E5xFj8l6VNc7+Z7z6a4plKoXhOMZa2PCC4OtP1n9Z0+t39LRv9WsZjtheewk06YlTrOUpF0FU+CmmohtpyR5w6A/Nn2iUgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uoVZjPvOfEOJVxzAkJLEcljlz1O3YfRoS/MR3j7fhwc=;
 b=THmhhuk5IzhC4aN101qFYHQ6hofbgdsetKmy2/CwhdestQXMpIO6SbuMWE3YQI1SC21asgRRl/DRq04LHTE2+yej/JfTpw9vSu8y7AIWGLkRftnMV70V8KZLrmJm/rgOB1nHpd6e0xhHRdTiTQFgkizb1uqr37dd41HRUAzOI3JJ6ZnVlezsN2XEAc1FbbRIr9LaWq6YBWHOMsjp9IfTVkqVszKfeSjF7BnA7riG3wACYixSng4GcBd6U7vG72JwLKO783JYINeRHmi+eUK9QNNlwSA1ydsG4AEqUHtVInvNp2nDFCwDxL265gEZe52Tc8XZD8UIj5Hjpj2b7AAt3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoVZjPvOfEOJVxzAkJLEcljlz1O3YfRoS/MR3j7fhwc=;
 b=f/p4ZkWrk/hp4QB+HVTVVeeyFkpIevlJl0W/VFVInwnO1d3e/3pDhGcREmHx5BlyhnRctfTwbETS3KK8yGqUPrzDBeQj5OqBxYpdTeS/sgjX8kJiHVEl8/3sE7gRooUpARPakz8x9UOJUiklUHyx6BQsXPIZMBSOyYaWlfZu0KXTrQ1ZYakz0a3VjvNOjn8naM126jJxMhhzKcicJ/28vHsdJsWSDB2LBa3o3k89+VheTpcqyhxxoUiyVRYw1VTKhG0IZ4SmWCBUIUHOlgTEISsLnqgiVSnNpVP/3djRk5V0aSi8aOcRg0/jeI4l4XQKqnoYv5OmXQhtl6zzE4rlgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4370.namprd12.prod.outlook.com (2603:10b6:5:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Thu, 21 Sep
 2023 22:55:27 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 22:55:27 +0000
Date:   Thu, 21 Sep 2023 19:55:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921225526.GE13733@nvidia.com>
References: <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com>
 <20230921163421-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921163421-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: MN2PR20CA0052.namprd20.prod.outlook.com
 (2603:10b6:208:235::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4370:EE_
X-MS-Office365-Filtering-Correlation-Id: 4759e856-aaf8-4b02-69fa-08dbbaf5d8d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ULRVYL9cVrYjEuHEons0XtxQtfcFDSjWBrmNSDm4eK0tFOnq+O7qcrGTJ9pWbCnw8XptxRmfZWUducrotTR0Bugit16d6/a8apiFga4RBKDJaRZzxUVRIGECzqmhL/6OF2Xpr+abMYpr9Z2/9ZLfpPfawYWGmRXuP8AEpUuGBJbIR7LSkArfkEfYXRgnIUAiG00Zub+ftLHxR+FCHVwSedUWiTa+s4wGJtlF6cadyrl8eJGwFg7doxFf+x0x49zpJ6nnno8wrD9OyCajvtSVbLwEjelksV8U7I86iIk1gwRRgAJDRnUg9CuuKFo1Bot6tP2ChKflPAlUiXr537GC9eBRU7u4JYzQx+oJkl7xvNdfzBeWFt2e83MSlhevfFnKhfqcgPPqAyIWRgHZ36c4kKu5tRO0axrjzDeY7Gi0FX6pz2fM5idOsQpftbxxbTgpZ3aR+OyiDo9SIe5AWpt5MnuPMdUjVdf5WqZC8RJEMRZYARq/0LS4SAjLMtXXW2B8COBMwInE14MlMS80U7Pg2IjlLqqVxoLYoDfuQ/ZT1ZptrvTFqUl9POO0AyEZmz0M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199024)(1800799009)(186009)(83380400001)(6512007)(6506007)(36756003)(316002)(5660300002)(4326008)(2906002)(2616005)(41300700001)(8676002)(6916009)(33656002)(478600001)(66556008)(66946007)(86362001)(6486002)(66476007)(8936002)(38100700002)(107886003)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?st5pgfoGfEMfdP2w3VtVXxwXVl89QGCL8UR0CK8Fl1WcPp7JFYn/N+MqtGnZ?=
 =?us-ascii?Q?MMmsZQXc9hDahnDzPas+xHJBA/Eza/XFqB7vYkPN+DeiJicfIOXrfsGGuFvi?=
 =?us-ascii?Q?I7xaNo5GmIcTWRfOkTPS5Z5Z+7WNhJ7mwrNEw6M0JSx8tw7dg1+q/LnDpRe3?=
 =?us-ascii?Q?D/WMixArhxD6KrKRgOiIE7WoCT0OlX1ngxQrTMwalLtJ5oZTdKWAaAXMTsd3?=
 =?us-ascii?Q?rSu3lLx2vaunkhNmXkjIayVhVu+zANIv7EXx2nI2eb10xVw/B+78hPRYuUoi?=
 =?us-ascii?Q?E9nIeAHOPfOq3Hzca+BESu3AixYp51LWPKvoGLcyhaIAtaXd6z7rM/WX2L3b?=
 =?us-ascii?Q?S7UoP4cAhaKoJNXqxdFf8ls+pEUllf71bZnWqHbGozIu+foEdBAsCWEMIz6v?=
 =?us-ascii?Q?vwVeLs1BFSevCh9RUzKLBlDgm/5OOXjkwo7yGKj1NnNOwqAoluN+izJVosGJ?=
 =?us-ascii?Q?XIUxR8akp3zEs6WQZrKBcrPzN7eI3d7WNsi3+fZYrzhPub/UCVq6GfSPtpnn?=
 =?us-ascii?Q?mrsOk75A8If82Xxtndnn/FEORlZHdXPjwpy9YTozWLMtD4njrhmFgVwo12Gk?=
 =?us-ascii?Q?AVeyN4D6rMnvdRzdG5aWqQJQ6VHmnWOBxVyLgQHAtAc05Wov+iGVZ1+zCLUZ?=
 =?us-ascii?Q?xc+nojIU2Xcphlfta36pPFLg3IKyIVVx7xIJGBHQgkAmN1sgsGYjQPReMxc0?=
 =?us-ascii?Q?exbhSCaB3VcrFzXoOAjZ7wFSgejb+h7W7cvhpSX2RtapJKRDMUXVMkhXovUC?=
 =?us-ascii?Q?nGOSAA8j5mwOemhk61OIFroD6j1Q3usJsO3XBt59q6xg/JEzRmSffj+9PI5M?=
 =?us-ascii?Q?xIQadak4xZbK6/hFOvWc5g854JNlbHnqyQoe5Pifg6Wo29ZaC+uJakrgm+Ki?=
 =?us-ascii?Q?qv0jDQ48cN63J6fZ8ODP5nPqzLrcFqaRU0tu70+aeFiQcC7+kXwcgzVX2DMX?=
 =?us-ascii?Q?SwaozvIpkfsrQvAlyxc2LMvYFCOdH+4+Gk1/QnBnHYMeeDChemIw6fTFIUyN?=
 =?us-ascii?Q?7fURCEYAbYzNb5nSVVYcsVIJCCIt7EfOn7aJJdQF3MQw2F/HeN/YzqtXn76n?=
 =?us-ascii?Q?dCSWYWp1py7AMC9pMM/kXsaHbBUWaKaGFnYrU+0kEC+enmC7ii73KmCE/t8J?=
 =?us-ascii?Q?1eotYsnvJKOyQZ2Tu/w+IebSCqJP1x6NpBOOs/m5haEiWLfTTQwyRfH+oG6Z?=
 =?us-ascii?Q?8ozUTNXTrgAEjz6MkRpWZ5eeHePW/UOMPnoJGpmsS71FqXE+or1qaHMfOiXM?=
 =?us-ascii?Q?wpAZl6rvGcQ9rwYReIxrFUwFvPZGjnl51JYqfUSSdhBIOpezpGcFKCrjxBCS?=
 =?us-ascii?Q?RFbZF0wYEaaEljSRfjduHUeyeohksFFuGf0XQY/Mdkgm9VwZ/hDQ443Tv7m6?=
 =?us-ascii?Q?22exMt3wLanrg4AUsL/77L6oeU4Z69qRJQ1a3QqVu/RGc+a5MAbbf04U+t/p?=
 =?us-ascii?Q?OMXgeCHRMNzwWkM4ce4Enq04kNJFP/vhIIgGwsMu5jvwEZDKgRlCtu5BiCjO?=
 =?us-ascii?Q?HAEsAK03prtKJGG0MpNAAj79NUIelEr6sMlDnDzp3xv+7FpjEMbtoSOMNs1W?=
 =?us-ascii?Q?PbTWP7+D0U2f12AsMmu0Y43Lo/FG3MUK9SwtT6V3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4759e856-aaf8-4b02-69fa-08dbbaf5d8d7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 22:55:27.2041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bgg+n4tDPAAYCcP46Dv6947//UOcwJqhHGcQbmaEe+o/o7kEl/yO+7iF8sOnEX5U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4370
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 04:45:45PM -0400, Michael S. Tsirkin wrote:
> On Thu, Sep 21, 2023 at 04:49:46PM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 21, 2023 at 03:13:10PM -0400, Michael S. Tsirkin wrote:
> > > On Thu, Sep 21, 2023 at 03:39:26PM -0300, Jason Gunthorpe wrote:
> > > > On Thu, Sep 21, 2023 at 12:53:04PM -0400, Michael S. Tsirkin wrote:
> > > > > > vdpa is not vfio, I don't know how you can suggest vdpa is a
> > > > > > replacement for a vfio driver. They are completely different
> > > > > > things.
> > > > > > Each side has its own strengths, and vfio especially is accelerating
> > > > > > in its capability in way that vpda is not. eg if an iommufd conversion
> > > > > > had been done by now for vdpa I might be more sympathetic.
> > > > > 
> > > > > Yea, I agree iommufd is a big problem with vdpa right now. Cindy was
> > > > > sick and I didn't know and kept assuming she's working on this. I don't
> > > > > think it's a huge amount of work though.  I'll take a look.
> > > > > Is there anything else though? Do tell.
> > > > 
> > > > Confidential compute will never work with VDPA's approach.
> > > 
> > > I don't see how what this patchset is doing is different
> > > wrt to Confidential compute - you trap IO accesses and emulate.
> > > Care to elaborate?
> > 
> > This patch series isn't about confidential compute, you asked about
> > the future. VFIO will support confidential compute in the future, VDPA
> > will not.
> 
> Nonsense it already works.

That isn't what I'm talking about. With a real PCI function and TDISP
we can actually DMA directly from the guest's memory without needing
the ugly bounce buffer hack. Then you can get decent performance.

> But I did not ask about the future since I do not believe it
> can be confidently predicted. I asked what is missing in VDPA
> now for you to add this feature there and not in VFIO.

I don't see that VDPA needs this, VDPA should process the IO BAR on
its own with its own logic, just like everything else it does.

This is specifically about avoiding mediation by relaying directly the
IO BAR operations to the device itself.

That is the entire irony, this whole scheme was designed and
standardized *specifically* to avoid complex mediation and here you
are saying we should just use mediation.

Jason
