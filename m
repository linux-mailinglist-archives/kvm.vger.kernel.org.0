Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C367E6627C1
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 14:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbjAINwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 08:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbjAINwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 08:52:35 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2081.outbound.protection.outlook.com [40.107.95.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C0DDD7
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 05:52:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmnDtI2Dsrnuw2fR93zfcX+gPPbVRcdZ8RXVs70oYwK//MUfWq663PLXUFJOmkH/tqy2cMjI5O/mr/+XmxU+RBkYiunlShaSF0khAw1SCfTKFtd3h7mmPdbeE6FHepEwaFKvMR+/jo1z6ww5ufbAKmdZ9u08fUruk3KhMWIpuyNLLJThsNmv5z/P5e4kFXXWvvBziEJLDwdoTKs6zHb0bcvThWfE7LkryBiH0NNijIv7vnvzcv4tO3PfpFQqD00jg9K0ZFjfy6jFOlvkgBvdFvGbCbT2ssIzv/TXxsN2SljzoiH+SlackZmkPW05z4TH+e56vFIn23HsrNRSLJIYwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WWz67RvKGwUoqwyWgIwxyKywp+Pz4TIvDywHdFJcAYw=;
 b=Ti2FHGokp5pXAm0yb8jknOe8odLT0TBM/wWX5qH2jWYDJEeboCPTCVuF4LPNJ1T38IOP6Q5gru78V+Dn4RhmjzfxgqMVxQN0wND5XUDym8+yojVQvMv0rpzBg7ZqNHqThmo1RH7qEI/QvjU3Sde9rg4GWMBJcdjOBgd3XM2Sx51NyYdbDlvkHArLqWAKivc5J7L+rsmqUeEDROKwQ0Exf5BzYHqYU5Be3zA1wlPy1wPhrmllALJ2x9XZBatwxrXy0195tfyHt3PenRpEKqi9u/dW7A/VISi4e4//kQLMgNOBwx9kpYIF6zJqT2U+py3M5LehZSJHMsT9m+jUaqaSEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWz67RvKGwUoqwyWgIwxyKywp+Pz4TIvDywHdFJcAYw=;
 b=Dr5PfXF8UAvSKiZSNyqBnDl+3+vc1/WIoi02BWfCuVr4D7OoNFRHOZYAmjbQrutv28ER6yVMaaWC+mAp9mxZ2A+NQKm1OqxTBT8Hl7fhe7J/eqy5Ks0OfXgJfvSuBotL4Sphz+sKpqaHSqHwEFGjznorS061iIo4jqu6uBeGUQIFaSaLgK79gsP68ykbtnYLUBeR0dlrgor5MBosEwk6Z6sKZQENmJtA7DTOb1b92KWk87ZyCOS4wwi6YUA13cdwKLoIvlrarSkifVBPJ8cGlqoOIzRwf4C2fJFOYEixgV4+mZ8mSnoT2LgujUDu1dRWxw/iUxPyWtUKz3qKyS7NJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4370.namprd12.prod.outlook.com (2603:10b6:5:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:52:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:52:31 +0000
Date:   Mon, 9 Jan 2023 09:52:30 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V7 2/7] vfio/type1: prevent underflow of locked_vm via
 exec()
Message-ID: <Y7wcHg0d0ebC6h+3@nvidia.com>
References: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
 <1671568765-297322-3-git-send-email-steven.sistare@oracle.com>
 <Y7RHtRnHOcrBuxBi@nvidia.com>
 <61e24891-28a6-8012-c2c3-f90f9c81c1c0@oracle.com>
 <Y7SAA6eJKK91F6rE@nvidia.com>
 <3ee416e7-f997-60b0-e35f-b610e974bb97@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ee416e7-f997-60b0-e35f-b610e974bb97@oracle.com>
X-ClientProxiedBy: MN2PR05CA0062.namprd05.prod.outlook.com
 (2603:10b6:208:236::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4370:EE_
X-MS-Office365-Filtering-Correlation-Id: 42b3e1fb-9af3-448e-7afd-08daf248c097
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Y9ym6HPNZ2xCDXKTlQm3XFNRT6uu1RwuXbEIDAn4R0FJi+yJuErQT9XVimwmVY/9vuIJXl1Ju5hoSpSm0irPxkoyCcBjcLnSUyxXJ+WceyouUGqjt0AWsO4xc48vhfAyFKw0uwvTb6BruWoCsyoy3W/8X3LXW7R7DqysRttTQKMrPHzUCxlj+RcY4zTAKbKb3Ov4TRY8wOMswMeTh8btH83v/Glzj6Wdhmg1ZGY10xJaVM1qy8PQ2eYGz/DIewXCLNstVD1qwzVeTIfwL57hb5eu0LRW6w2X8zKyp6F/bvp0cjMdyRJKzjjjzdPDDxkM06Bbe9V1oQQda6e9JTt1I7qWPKWUW6DDEuudjeHuVjMoybCaZ6kobTeEKH2Y7wnYxE3Er+W177liYF0pxbnOB5Gfwtkbas9X6FjzTSMhTBJVbobCtGS2HMR/iHE0UvADQ/ZAfKMdBPU8wJSVCgGFANgSxhRCie7N2RmJw8161jX9xK3ryze+vopRnQBWVQU6YRvsBHnt6n9LCTbq40BvdT1yHkLmLlgK1Byf4JDaE6q6RNRDpw4hwmUWKcf0p64/CfsPvgEWnCKXZhu37VY8eDZAODA7rIFy24TgG/zx07szkcS1EYjHgleYKLBCIwofLEzJiNCpnnYP1swzo6p79hoV2hIQeUlzeZtUbVN8Z4CjbaBfrOyCy+m+WHb6Dio
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199015)(8936002)(2906002)(5660300002)(41300700001)(66476007)(66556008)(4326008)(6916009)(8676002)(316002)(66946007)(54906003)(186003)(26005)(6512007)(2616005)(38100700002)(83380400001)(86362001)(36756003)(478600001)(6486002)(6506007)(53546011)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ho8OC8qzwfRRbW+rFstLCkWogns3faKm+LEuk/N6KdhYstZj6aBouq/1O7CS?=
 =?us-ascii?Q?tcPFCYHn/jsHrmTzYumXFB3ZxPqU80etkPbN+twvWMbh4ll6FNjva2057+mA?=
 =?us-ascii?Q?k6mh4QFTegHkIgNGgknmr/aLS9tGXioU5ntBSq+eRDyu0wmb/sn8dBUM3t/4?=
 =?us-ascii?Q?34lYyJBSYd/pOR7r0+TYbtX1+h3qxYxpLNfZXQ7OCjur7ubOUKlv3WJixAO4?=
 =?us-ascii?Q?g3FTJvzi0Co6DY0ovDhIfNkG+juAp0riAkfhDinRGk7lKAF16ybtsJ5WvByO?=
 =?us-ascii?Q?CP5+o8xRwvlcUUWfhsme6zsrv1YUjIow1hxZqdf04EFykwF+aw6dqTYKNmnE?=
 =?us-ascii?Q?ooEcFjxbjFiZFZm07WnniZT3DkDVs0Bky8MOczQa4XKQc184aPXB5KjgFwFA?=
 =?us-ascii?Q?sEPcdyzO3KZGGYDuCIvZc2WcDUNdSs3cV4Z28RioXBxxXlIrf+agMJWc456f?=
 =?us-ascii?Q?4sJVtv/f2isfC8cohgMQSNYtxZNAHFuIgwRx2w6fyISOICxlHxnZGanwBxjW?=
 =?us-ascii?Q?hSPeuYRZar8k4bgfHQX99cLRB57AWIIk9Pa6hZrMZoTRep3qDdtuJmqZ1bY1?=
 =?us-ascii?Q?TPkZkjdq2ezqGebd/SDzcs8C7siMaLoYkVow9hIeza0KwbPaudkCnb8tckFe?=
 =?us-ascii?Q?EpoaqEOMzIHZYyXHvtvmiCkgViBycrtakjEH6JaExkGMZ8PS0YovdXYC6FAi?=
 =?us-ascii?Q?00wXNryEYB+W4XxUcCyiKWH+PxYKx+1cpREgxJpFsp0wRBvlzvC+IJg+p2Hw?=
 =?us-ascii?Q?rh4A0Yqtbi6cFxA8fWcZQ9kKNGXHfdu3qYlqTkMj9+XlqSGoKPyfFZ9UVJdk?=
 =?us-ascii?Q?z6QoC61gaZ1N2RRgTYDtSS3iaxAz0K/oGwYpe20wFWrbaWW7QcixQ16WOms3?=
 =?us-ascii?Q?9geUQ9fQnwCmxqt6qyh+IcziDv8BumlHHu7XurYDxOK5Ri1r9E7lLk5jx6+y?=
 =?us-ascii?Q?oqsRYwk1GJym1+k/v4ZRKuVDeRylH621jtDRQGJieErFNlms5OMSmr28rYNj?=
 =?us-ascii?Q?Q4BHw6JQbWmMU/GwgrO8PajLf9YPQoqJ8WyykoAFrZ9glOawrIkt2tPNCm41?=
 =?us-ascii?Q?iRAvgiSSY4qMwSXMKPvwQzpBbVx7Lj8ey97MfnxDmHc+yMqgDNKuDaqv9Lje?=
 =?us-ascii?Q?RtH4uuTrqlsiLk6kpJA3k8+DsNG+rKQD8Rdae2wmjax3vs9fH91sCUDFP9Tl?=
 =?us-ascii?Q?SoHpH2LYsrN13m7ge3wr+joPzmC+6qszdMutsdOSVQcAgcB0xRNsKec8Rm35?=
 =?us-ascii?Q?1QABQQ71ZbvHSjawLmdDLGwaNAgTOW+EUY3MBdKhOCJ9Fq4yKzaZ80uF03Y/?=
 =?us-ascii?Q?b6LK8yOD3/W+ptR6QnzMTXkkIk5nJ3J5HPzsN6HJYn7ZOhndiEIrmYsXyXZG?=
 =?us-ascii?Q?t1YSwBXm9WCt9dKE2auyLiCGQiIeEHB7YeEW5KTDAmFGv8QcUC4xI5eiOXEE?=
 =?us-ascii?Q?DSBby9KWfvx+YQmVFQJ7x+vpoTT5Udb32U67igPlWf8p+OIa4gr1hVuVvxgr?=
 =?us-ascii?Q?zR/hfTAUvShlG7b3lDkLWX7kAg/NtWZLDebMRlGU0zZNj6aVcO6MMcDTgKJi?=
 =?us-ascii?Q?6C7wjwvJZduR+74mBDdj1ZPj9V/UIJfzw+OoVwfR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42b3e1fb-9af3-448e-7afd-08daf248c097
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:52:31.0160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rCtUmzBagDYTTlONjpvjVl7y+cw8cHnpw4sHCJc5VLqp34Rg03cWJyNxQNopyxwg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4370
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 06, 2023 at 10:14:57AM -0500, Steven Sistare wrote:
> On 1/3/2023 2:20 PM, Jason Gunthorpe wrote:
> > On Tue, Jan 03, 2023 at 01:12:53PM -0500, Steven Sistare wrote:
> >> On 1/3/2023 10:20 AM, Jason Gunthorpe wrote:
> >>> On Tue, Dec 20, 2022 at 12:39:20PM -0800, Steve Sistare wrote:
> >>>> When a vfio container is preserved across exec, the task does not change,
> >>>> but it gets a new mm with locked_vm=0, and loses the count from existing
> >>>> dma mappings.  If the user later unmaps a dma mapping, locked_vm underflows
> >>>> to a large unsigned value, and a subsequent dma map request fails with
> >>>> ENOMEM in __account_locked_vm.
> >>>>
> >>>> To avoid underflow, grab and save the mm at the time a dma is mapped.
> >>>> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
> >>>> task's mm, which may have changed.  If the saved mm is dead, do nothing.
> >>>>
> >>>> locked_vm is incremented for existing mappings in a subsequent patch.
> >>>>
> >>>> Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
> >>>> Cc: stable@vger.kernel.org
> >>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> >>>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> >>>> ---
> >>>>  drivers/vfio/vfio_iommu_type1.c | 27 +++++++++++----------------
> >>>>  1 file changed, 11 insertions(+), 16 deletions(-)
> >>>>
> >>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >>>> index 144f5bb..71f980b 100644
> >>>> --- a/drivers/vfio/vfio_iommu_type1.c
> >>>> +++ b/drivers/vfio/vfio_iommu_type1.c
> >>>> @@ -100,6 +100,7 @@ struct vfio_dma {
> >>>>  	struct task_struct	*task;
> >>>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> >>>>  	unsigned long		*bitmap;
> >>>> +	struct mm_struct	*mm;
> >>>>  };
> >>>>  
> >>>>  struct vfio_batch {
> >>>> @@ -420,8 +421,8 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
> >>>>  	if (!npage)
> >>>>  		return 0;
> >>>>  
> >>>> -	mm = async ? get_task_mm(dma->task) : dma->task->mm;
> >>>> -	if (!mm)
> >>>> +	mm = dma->mm;
> >>>> +	if (async && !mmget_not_zero(mm))
> >>>>  		return -ESRCH; /* process exited */
> >>>
> >>> Just delete the async, the lock_acct always acts on the dma which
> >>> always has a singular mm.
> >>>
> >>> FIx the few callers that need it to do the mmget_no_zero() before
> >>> calling in.
> >>
> >> Most of the callers pass async=true:
> >>   ret = vfio_lock_acct(dma, lock_acct, false);
> >>   vfio_lock_acct(dma, locked - unlocked, true);
> >>   ret = vfio_lock_acct(dma, 1, true);
> >>   vfio_lock_acct(dma, -unlocked, true);
> >>   vfio_lock_acct(dma, -1, true);
> >>   vfio_lock_acct(dma, -unlocked, true);
> >>   ret = mm_lock_acct(task, mm, lock_cap, npage, false);
> >>   mm_lock_acct(dma->task, dma->mm, dma->lock_cap, -npage, true);
> >>   vfio_lock_acct(dma, locked - unlocked, true);
> > 
> > Seems like if you make a lock_sub_acct() function that does the -1*
> > and does the mmget it will be OK?
> 
> Do you mean, provide two versions of vfio_lock_acct?  Simplified:
> 
>     vfio_lock_acct()
>     {
>         mm_lock_acct()
>         dma->locked_vm += npage;
>     }
> 
>     vfio_lock_acct_async()
>     {
>         mmget_not_zero(dma->mm)
> 
>         mm_lock_acct()
>         dma->locked_vm += npage;
> 
>         mmput(dma->mm);
>     }

I was thinking more like 

vfio_lock_acct_subtract()
         mmget_not_zero(dma->mm)
	 mm->locked_vm -= npage

Jason
