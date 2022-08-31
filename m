Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB8F5A859D
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 20:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbiHaS3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 14:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbiHaS2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 14:28:53 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369AE63F29
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 11:24:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bT4pOZU7tV4CgNAnyq2xFO7ywmSEukeOKbG/16Hl2ewfX2tgTul+bLydmfxjJy2mammBM4epIIEun/O94cvwKAGQxSt1FSDYMEwTrx0flcTnCXsEeXIG2+GWR6d/KqAv1ouol8xTXCKTLPW/YywRby2UjDETOk1/oPZD8/SjMsSkXRhmW5rJjgmiDIZYYLUQcpnsEzE4bFkNeJ2YoNqARonwRJjAEk2RkmxmxuUqqAHC3kNjY6RY0eL4CAKSyoj1zN340OrIL8wR7mSQlHmHx4+TW7shl8qRuc/f/8AVNMGXERR7o3ENoeBQw8lSqBC3t+UoERg+iOpjT7hpjFFYfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4Il0/TdsUOEJ06K89UaZFQeUmp1i/JrNo384xJxX7k=;
 b=F1PsFtJlbaN2KtovS3idc5ISWOanr8lBPJIS+GA1uOZoGRjo7HgEp9DjgCzybN7lJ5SNkiHek/ZgBs0ITOjptj+/fSXH0zXQ9pP+10uVn0bBJGRDRIKS35h166EfuwtwxJR39txAKQnrfKLrklN+hpY/xTVPGARsdY/Bds2bHSPFZs3kKb2u7ByXQQ5ecIiX0LYAEP1tRhlZMmO3Aglu6H53NLA5HkfUfGpBXq4/xzK1JNBuRR5voctgb0I8UyCSIWYDapRxwBdVJCJnVQ8VEKuM/49F64xrJ7rUlnerzDvtZE8JDY2mRyteWncIP4uge5F991af8TLOgTUjIf6rAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4Il0/TdsUOEJ06K89UaZFQeUmp1i/JrNo384xJxX7k=;
 b=K6bfWhC0evIdKVBaX2nOzJa8sDmuVh1TRWBINwJAZH5lNKOhqg+ukyBWCQlIfo2V/A34S2NLdFG9YJt5/Zh71HU8LDni7vmxADa3nvVJcwF5fT+SQ3Ve8R16Q3u4smjsfbRt2mWgUkgZNSiE1lu7n8r8zKwU9VFKeYwGm9m3YA7pnnoDnBNmqpCVZv0+jSxjOXnZJ53XMOEWPTgNbJProAgXJZUelPYA0HIEXU2FMhWbYR9GdZyTmHHAV2azZ98nYjA+xJbIpe719xbVdZmtGv2FmkgdXYcitzT6XXYdo1kM5uSQM9k1mauxflgaxYUtYdI5uvpk/m9DRzqcbZ8ZLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by BL1PR12MB5255.namprd12.prod.outlook.com (2603:10b6:208:315::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 31 Aug
 2022 18:24:41 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 18:24:41 +0000
Date:   Wed, 31 Aug 2022 15:24:40 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/8] vfio: Add header guards and includes to
 drivers/vfio/vfio.h
Message-ID: <Yw+naMPLU9gD0oTR@nvidia.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <1-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <BN9PR11MB52764F22F96E12177D50C8068C789@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Yw9/4h3mlN4LuBz8@nvidia.com>
 <20220831120231.320081f0.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831120231.320081f0.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::10) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1d851e3-5c8e-468e-601d-08da8b7e11fe
X-MS-TrafficTypeDiagnostic: BL1PR12MB5255:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +3JjZp+bSvedgjcSU5Mmf2lyRw0injDsqQTAEP7EMu0UtbrTavoTd8yWzHM3O2FDq7mMHdvh/gKEh11iRe6deM5UDbbjFf670JfO7l7TjDBJjfL1DYzuudDwcJA9vM7r8VP6gjMW4N3B0RtMwrAsKqj1qh0dS8vyL+jvVlOP7X8YnKmbfMj+jT4p0w77x7iHpixkMHseDw/7KfMGCqIzwrMR0ICGcH4BJ5AFAG4duy6VpTuhMzWQoAKWmbqOquuG1U0MM71qKh6MvGn2pwBIW+WMYjqfDcNxTYj7RnS0hftoVA9YP0LZzrakYlyZh9IL7tyI22DM0CvU+heJ3RjKMD7c3VGW/XJwm98WmSVRlpZlcQZaBr65KDiEN44hYVcQcmqVDTV9VWG1egTI8suuAoxmSG2ADAl+WDaSfrK7d8f8AIekoAZWIoIiXgiBWxeM7GN8oNGCvb00hnDps+GzcVbGVVkppgKRd3OXwJASuu8Xn7SYT792UVhxJXNF0cEi3CGe09QnvNf4ba+Veij69IpQrN1nYNPS+rDo7bUfY0AXZkdS5e9ham8oQ2f7pGSkpbQYDzUiCpaO1uMmnZYctD9YhaXi+AHGTIj26Q9RC6eC38bpMUQaFJNCbajNG9ollqC4vVu3pz0nFMlJwY000f2kIbZ8porLaeHgFKhEMsEUtVWOFmbrLtxljV7SAQXYSWBuc1yyZ2xiXnE4t8RIuWRu/TOyZTJhkee8FiRXtTVeo3RvtBdK8B+o4BoGe5ibgKSrs5a4iL4EwlMgjI3TKHIn1vKwmRhpN7G+SS3IAzsscFl0iEDWXWMOGuYA8zQ92UdRj/mHWlL+I6oKkml5pA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(66556008)(66946007)(54906003)(8936002)(8676002)(66476007)(4326008)(5660300002)(2616005)(2906002)(6916009)(316002)(36756003)(478600001)(6506007)(966005)(41300700001)(6486002)(6512007)(86362001)(83380400001)(26005)(186003)(38100700002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WgNYFUd9dhK4e+BtB2TKbsIqm142h3/QrjWVvwb1xCVuU2pBm7z4DRYUttVp?=
 =?us-ascii?Q?+hQNrreZH9rW0j5a9lHrdQNNqUglk2rWHpMN0Zogt8zDIXsm68h7pn6RYO5c?=
 =?us-ascii?Q?5oQ8DSBtj9BWN7S7sJWolbURKNIw6hMuTVv9ff2979sG18ThZFBG7tRHq5fV?=
 =?us-ascii?Q?iBjMm99J9TaFwR4k6aAjFloeOIyx99azsPUc/7PhwmkcJOsRlwO+Nbp4s7dH?=
 =?us-ascii?Q?I1foG4wBLHVFl+oYyBAlWfy2t/S9R6jhObKoJV21jh8VRgULHLDNYFS7QEJ3?=
 =?us-ascii?Q?bAKP0qPLCpMN61S9lUdUhRorxkgIC1NosFVjpWh8ew/AHTLcArX1koEy7Z9J?=
 =?us-ascii?Q?SFzUtAFxZ20sKT4VF3SBdeQHcMs45a2hc5cmp9x80NlrdB1cOZX1T6Qjhx0h?=
 =?us-ascii?Q?sMWPEOlNW6Elr0s1ljC28nSKVJ87LhFd2X8A6cLnEle3iV6h/9WW7vF6Z0fO?=
 =?us-ascii?Q?0hZHDc5GP57wF2QcbqS6j8gXZJUS7d4uSFpnJj9t6tT4HczrT24oT2eXqlwd?=
 =?us-ascii?Q?kM8b1ptJMcfOXbbv7zDCo4ENFiLk9DKHysVksytmPG+HjnLBNjLCKWjceT4v?=
 =?us-ascii?Q?p3Vim49uAXW/86D1kOWMd8TqBJJZ0eHvPeg7ESITfIa7WqRLjXM1Uc3Zsbaj?=
 =?us-ascii?Q?keGMxmChBs3gctlNPXAwwdqabAcA0ady9hblF97vaJBHshlOWaNwsATvhw2E?=
 =?us-ascii?Q?2uCrPVpj7CocF48U+vOEIVg2khcp7YEmmoJq+bUJOhmMAe96Wjr3tQCkoUKx?=
 =?us-ascii?Q?b5c98I0nFE+xQiBKVfTONGY7cM+8ZcJc+rjcNZUw6wfZIJWpXf01lCL0cSdX?=
 =?us-ascii?Q?dBm7nY2JbJ+VY8x2no+GeSaOK2NpXv1ruXYSrcyl3ZFpfTRAu3SMsO7f33nS?=
 =?us-ascii?Q?Dr4206uO7HB7vKgqLZpGuA0OkuY7NIZNC8j8awYhspECA4NN4NCmzk7SjUAt?=
 =?us-ascii?Q?WiJPGmSjF7XEzsP9R75IUPaD8JaS+9Nw6lEgRljomEnBHgXVAwWnTEvAJYrI?=
 =?us-ascii?Q?mexph0ip9AcrzXGNj8FpYqtvzye93A/rwohma7hG3x/APBaN2ZxvKSpND26z?=
 =?us-ascii?Q?qbWaURYeQikMmw5ZJTlorZ9W08nWKgcz+nvY8QRng3xcdOHZ2gxW2qZ3ji05?=
 =?us-ascii?Q?f1b9xlSnerStPvoz2bHB5pjAjxkL26J801IMSf5ywWVGaUoaf8a6aZ+Qa0At?=
 =?us-ascii?Q?b9SNqq1SQ6GaJn7MlIfXpY8m92EIHnSLvuIcqwbiKG75RncVhgvd1ILSdD0q?=
 =?us-ascii?Q?oLI0dnMRvLpIJZeirq5JPxWl6/maiGlWL1K7zxGbfqEg6Ndji4vikYhUn0pP?=
 =?us-ascii?Q?47HxnjdtdtYadRMCFLAajkKN4yZPaXPK6PoZvt7pHqeq+1BEpqINLr/0uSnQ?=
 =?us-ascii?Q?HD7WSIgTzFS40tYDEbW5D5Zz1+Ljtjrx70x/vHobkpsMZrPJPbu3/fzk16D0?=
 =?us-ascii?Q?TSvFMIsfbX6/UivKBQDaEXGd1VBqbR/ijriIN7boX0TeMqtGS8yIgBWWxHYK?=
 =?us-ascii?Q?9H6bU9ngLmeqhfB+zT6TaaTgSd0kE+0kpyXT/h+rrErYWqH4wGoUwiwp1Ad4?=
 =?us-ascii?Q?BA05Ipvfhsk798hVhW72savCTQvcrMgMEWNy98GL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d851e3-5c8e-468e-601d-08da8b7e11fe
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 18:24:41.1151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +uZR7hRZ4lMMlUuHaCKoqimijf7WSa13HfOjbhdg84Tm500VjvFscsdnqJVTYRPQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5255
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022 at 12:02:31PM -0600, Alex Williamson wrote:

> > The criteria I like to use is if the header is able to compile
> > stand-alone.
> 
> Is this stream of consciousness or is there some tooling for this? ;)

In my case I'm using clangd https://clangd.llvm.org/ in the editor,
which checks header files for self-consistency.

But there is also https://include-what-you-use.org/ (though I have
never tried it)

But the above wack of text is just the normal compiler invocation of
vfio_main.c with main.c replaced by the header.

> > > btw while they are moved here the inclusions in vfio_main.c are
> > > not removed in patch8.  
> > 
> > ?  I'm not sure I understand this
> 
> I think Kevin is asking why these includes were not also removed from
> vfio_main.c when adding them to vfio.h.  Thanks,

Oh, I am actually unclear what is policy/preference/consensus in that
area.

I know a strong camp is to avoid implicit includes, so the duplicated
includes are welcomed. include-what-you-use for instance is that
philosophy.

Do you have a preference?

Jason
