Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03BA864F007
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 18:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbiLPRH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 12:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbiLPRHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 12:07:23 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0759923E83
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 09:07:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ou3tnZTmQMCJK/HGBmwji6taRjxZdwirqEchdPtrQqrdN/my359C1Qk+xeKOaB/k8Vo3xgmQRcdmMWwZgSyUr6WVfzBBla1wML1NY3TQde1Q3Oygjro4Ml36vF+BvWTADsLcR9ByOy8AopI/BGXTeDluXu3221SIsnEYhSzxmpMEV6jQ6fiWT/w2Na1PoCuwmKomGQHlM1KlizIQJPCwakRXYbwwaY2peE78s1ohBnVSDr174gxZtXlLLE/D1ezlr9bGPk7jixZHYP/QcrIR7lIItyS3cpZ+wkQYIgUkvS6g9DXBIXYpCg83F4ypFebNiSM3p9L4T22oF4y2DpK+iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gY9sf4Dkrl/8fSKt1B0S2XmmWa8slnMgjAbBXa2604A=;
 b=JhADwT3ToKsPCYkc3cgFIFrpQcPc6HqgJyseudS08BM1QMClv6aa11kxvOQQP0upgd/3tekV6VGyeMGqN3wwh5hYCyjggQMVMhyvOJGdzpfGYNsrV/AjWeK5wlwijfPFWmyxpkSWRBWQWyUVITZO69bUjSkIq53dGvW5P0YB7AdLQ9KNAjoSA8dGFiMFbLK3EiQwEnk0mFCdQ346KSWkOE+rXIYwIvIyrmCXO7gZEGFVxqE37S6zeaSTqmrYnUhTImzHWYFpZwYR8gu2FIl4oQRCXqlv1c1JcnGWaRns5Go6Pgqlq9MDVhWzBCOVbotfRmN4MAbtyxm7+bq0EmazUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gY9sf4Dkrl/8fSKt1B0S2XmmWa8slnMgjAbBXa2604A=;
 b=f3NUHJ03NaFBMb1Bbq2+HlG9MoFFDZAVY5ExeLOVFLCwtb88M0PQEjnQWLy3p+IruoQD/TdrS4yTjwT5Rk2/jIssFyWYig/ZtZ6Bke0eyU0ZafBquggChx8WA0mTIMwBGXPSFNZn9hP9lnmO1K0lnNuLSYnM1UuFjw7OnDD1qp7eSB22TV1a8jfrcXm6umT6gu+MZERbIyGOxZ2KM83SMQsLwwSvefqLVyII4sMlOSRaOQT4E9JmyQQ/3oWq/elO7EpzgunN0kNhEvjHyAfjdMohpnodIDAfkKCHoMcYWWWYM1UbkAX9ZrBsJ7g3G1FQhX6fGVeQrQ94Sa4/I4EHgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by DM4PR12MB5916.namprd12.prod.outlook.com (2603:10b6:8:69::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Fri, 16 Dec
 2022 17:07:21 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::463f:4cb7:f39a:c4da]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::463f:4cb7:f39a:c4da%9]) with mapi id 15.20.5924.012; Fri, 16 Dec 2022
 17:07:21 +0000
Date:   Fri, 16 Dec 2022 13:07:20 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V5 2/7] vfio/type1: prevent locked_vm underflow
Message-ID: <Y5ylyIwCFF1u/RjW@nvidia.com>
References: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
 <1671141424-81853-3-git-send-email-steven.sistare@oracle.com>
 <Y5x8HoAEJA7r8ko+@nvidia.com>
 <12c07702-ac7a-7e62-8bea-1f38055dfbf3@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12c07702-ac7a-7e62-8bea-1f38055dfbf3@oracle.com>
X-ClientProxiedBy: BL1PR13CA0387.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::32) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|DM4PR12MB5916:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ac34b69-fb83-466f-25e5-08dadf87febc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xWHsMg1+pcBqqS6Fe3WvGDO/H9hibAiVo27gNcW0aWLDtI68Oq1YP+tGlX3XWrujCgdp2CbM/OYALPAUne/JMo8oscRgyoG85iL7iFPZMH7obFVLsX3bvSILplEcveYC3Pp9NMzVXgPMzzPEsIZFL2ROFiv2vi2thLQHux65jWcniE3rq3kRtAivbiUUdz63lIfwDRXXTG3SuzWdXmy3k2jeZHyOdMqcu+w4rvXcP5ThydaCUxDcY+rTKpRSwf/hdJhv/Gje8XvWpTeQplxa8JAxuIOSMIA3ATJdF3ZlIj/iG7a3UM5Z5oK6UO6FOEJHf/ahd8OJm02zGQi0XW/BB1tA5lemdhzv5B1x7Za9fc5MWlTEwR+/BN1rZ9MLWfgiAgTgb2D3lrmuVTSLlrWinBs4QDEmiiMvZBtK+kLI35Cl//h/t3yRMGa8acPP/Z50tq0bVj/bvh9osG9andfEavvXGqbz4w5waQIDEfBWQRil5fwPx9uGOGtXubfRJ4hdZX8LKh06IAqBvwUskhMvLTBj5vdx7U/PkvreUQdYy62n7BnSaL72bPZsxM1JTGJYEVGvpD9Pcg1nC53aVoE6qIi7VxNiensD7sxxS01ZaQpyFpuvYZGaHTz0AZvYecnDq4tykJEMCIXtvlx6CRJ7Pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199015)(6486002)(8936002)(478600001)(86362001)(53546011)(38100700002)(6506007)(26005)(186003)(6512007)(2906002)(41300700001)(8676002)(6916009)(54906003)(316002)(83380400001)(36756003)(66556008)(4326008)(66476007)(66946007)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+2823T3Bn7IbUpuoQWZnZbiUjps3J3YBYI41y7xIHcsDSDAfXEN4NhrOMSxm?=
 =?us-ascii?Q?oAf4SQLn+Gn1vWePzJ7DHSfvlZKRHvnaTf8mcgGyB9PrHPVPMef0AiwGByPn?=
 =?us-ascii?Q?Nl6QP4rQClZJ5pGQNW+BbAhml4Q9vJrgtqPbkHNj2juWUydGQnawEhXUd9qk?=
 =?us-ascii?Q?41WQD8ak1W6HC0292knFPXD/s0v1oaT0xluPMnCW0r0jukwkcHb6Lz2TMEr0?=
 =?us-ascii?Q?gXqZkNGJGP14CdBb2IHuyiJ5De+/WUHbtweBOu/HGynmC5FxShjaztkCvfPt?=
 =?us-ascii?Q?HrwfUWFG6Dra3bMhhZBraEOj09iDgCmyF/t0wNRDm3o9nntde3L98pSv9ktZ?=
 =?us-ascii?Q?ACA2l49G/F/7RWaGXKkwzOGQCziBQclNOqVi1D0+aL/28YuisARGc928fERv?=
 =?us-ascii?Q?KO+UDboedyYW86Lvx+HXaFoGcKh1627PFn5Mm2n9t02MVPR4WWOVcG0rmqqX?=
 =?us-ascii?Q?8BYdThv1png9vffTyMFlZTHIDexoJKwp4F1DUhnOgs+UsALOoQ823HrWS4oB?=
 =?us-ascii?Q?rmwi6RTzL4LwLGm8IVVQHpQHKWfWezeGCLTGcFi7g3PP9+3eYw3JiLMU1olO?=
 =?us-ascii?Q?Y8WrFSBAGtCpvKg1pECbmz1u+8jEJRD0kaHyg3B4tmhcLTvzOrr6kCPTPe83?=
 =?us-ascii?Q?Jg1r52DBc9XjkW57zoImOv2cYdv6lj0RoUxvJsY1VJxDtUBe7KPhrqXOXgDq?=
 =?us-ascii?Q?gbLth+o0RdxSkrnr9fpFvtCTguTaIfwaHnIht0r5yId/adGAAErwfEeezkCG?=
 =?us-ascii?Q?KLN4x8gopuOIxvJSo5UkKWcahNrtc/kaAIiMtoxALK85FknAVVO19CJPKC70?=
 =?us-ascii?Q?y49OkWdjiShUmuVbAKBo7QdHFRa9ABAtmAmzcnAtm/xGOYsm1ozxnzU++pK5?=
 =?us-ascii?Q?egnAgbcROf/BeNFegHDRmJfL/Jw0R7M0Seb/7qI9H3692cv4/qoQUg0yLn6g?=
 =?us-ascii?Q?jayARigIxWUtdVj2VS4Eqm+BQGzBsJApobR6/FN3Nkumho3z31Fo9xrRdEbS?=
 =?us-ascii?Q?u3MREVT2GiL2wP+eqDlBj9pAomZ/Tu32SLv3ZAMGQLBoepJm6zz19Rz9Chap?=
 =?us-ascii?Q?5VvcFY9wswdNZH5dYXQjKPZXlOBkx8FkGTyTCuhrlzA+tgxrghikh9hubK2K?=
 =?us-ascii?Q?iRms6C8pE1g6F3IuBVvliJ58ohhQS6X2r1FUUI1NPcTyM4AF96Fk8WgOiwpz?=
 =?us-ascii?Q?9cfWrpSOVeNM0xjITjeLYh650t9bwaLLndb8dvTEaF20lt2vDAba14Jd0yEn?=
 =?us-ascii?Q?J8OtJNuSh9WVaCk9MI6sPHtS8e+bKvno4fixJ3SJ45ZX5X2C/in2t3pSy9s/?=
 =?us-ascii?Q?pmKRqjBLKlKeBkl8PwC1g75ZfjU49YYd7iWTA1I/N6J7Tk0e5dPqXHZbHB2z?=
 =?us-ascii?Q?GmyKt8uCh9exdsdjsH2/FSGJ3rXQ9t2srQLHIJf924JqY7F3NbChx67ZiRfe?=
 =?us-ascii?Q?zob3eKa/sqLf6RVs1ASlDLGqDmBQNAAZAR+34uoT6aejSvgJndh5gYyWL1To?=
 =?us-ascii?Q?oZjXTUmTPVwp5SXTdAKwNHBZ88n4QiXE6esOFtMVE4RLpWukLEd8kSHcDvXP?=
 =?us-ascii?Q?JNTmdNjuMkYyWDc9WTA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ac34b69-fb83-466f-25e5-08dadf87febc
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 17:07:21.5387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lBkAQ6jajhQPKRY1/lmGbor7Z/xChM/wxAoon67/Dsi7Xdtiz/cLjen3QX0foRUk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5916
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 16, 2022 at 10:42:13AM -0500, Steven Sistare wrote:
> On 12/16/2022 9:09 AM, Jason Gunthorpe wrote:
> > On Thu, Dec 15, 2022 at 01:56:59PM -0800, Steve Sistare wrote:
> >> When a vfio container is preserved across exec, the task does not change,
> >> but it gets a new mm with locked_vm=0.  If the user later unmaps a dma
> >> mapping, locked_vm underflows to a large unsigned value, and a subsequent
> >> dma map request fails with ENOMEM in __account_locked_vm.
> >>
> >> To avoid underflow, grab and save the mm at the time a dma is mapped.
> >> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
> >> task's mm, which may have changed.  If the saved mm is dead, do nothing.
> >>
> >> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> >> ---
> >>  drivers/vfio/vfio_iommu_type1.c | 17 ++++++++++-------
> >>  1 file changed, 10 insertions(+), 7 deletions(-)
> > 
> > Add fixes lines and a CC stable
> 
> This predates the update vaddr functionality, so AFAICT:
> 
>     Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
> 
> I'll wait on cc'ing stable until alex has chimed in.

Yes

> > The subject should be more like 'vfio/typ1: Prevent corruption of mm->locked_vm via exec()'
> 
> Underflow is a more precise description of the first corruption. How about:
> 
> vfio/type1: Prevent underflow of locked_vm via exec()

sure
 
> >> @@ -1687,6 +1689,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
> >>  	get_task_struct(current->group_leader);
> >>  	dma->task = current->group_leader;
> >>  	dma->lock_cap = capable(CAP_IPC_LOCK);
> >> +	dma->mm = dma->task->mm;
> > 
> > This should be current->mm, current->group_leader->mm is not quite the
> > same thing (and maybe another bug, I'm not sure)
> 
> When are they different -- when the leader is a zombie?

I'm actually not sure if they can be different, but if they are
different then group_leader is the wrong one. Better not to chance it

Jason
