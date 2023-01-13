Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0466466A264
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 19:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjAMSxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 13:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjAMSxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 13:53:00 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2041.outbound.protection.outlook.com [40.107.212.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC2F53706;
        Fri, 13 Jan 2023 10:52:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvLBVGcBeupYCjijsIN+FHYb2FBBPKCJJxpUcwocVp2DsAr3ZiS41vG3DZClVagICjtbSD0p1RQKF6spVxrgTxNQrpTZq8y77kluvRJCowtBR2DB97vA2i/alCWSNcPtX4rthvouokTSmdyi1EpQ3sAPBYf+qQitpEceqOhr95VXDTpT+MCYhb8X68GVspta4KHAsepvn5u2EKJkyjRzllO+quDiy2etpS5eGrWWVYrSFdtArsmo3f0OA3Cihl5R7ecupkO101pMmU5VDloNQfUleLcuBLMylDtUbEG9rXs7DSo5LMxjzeXcWwQ3ZqZ0mbA+mHVbYBS+haqDdxxZ2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSnVaVzwRzi5/Y6iGq6bdWY3VspgrXK1BwMadvyf8uQ=;
 b=c/xmtuIcGZyePgcHZ7on1y+5vIeFKmuN4n1Y3YuW/joyE30wOOQGakUNvU+b9hG6K/9bakvWuGmoyCxIfqs6cq4IQ2BVRgHiYlwHhkci3Zy9xNcC4kD1wvJj4f3Daj/7TvLyBIK7D14UxcZkBlmwc+7N/GM6TaX6VgnYffVr7cHZkNZ4pI8ZC/G5yHZZrA68zcrPQ95kw1VwydPEc52yNubactocVI4uWJwloCOOwU40Xsd/hxadkExwsT1t+a+Pn9kM9NcPyNY0cT2EFa03cSkqzpSOZnvarZNP/tzNWr6V3VAdZFnHEICJNBwZiDVr0KoVubAsjF64LuPr2iuHXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSnVaVzwRzi5/Y6iGq6bdWY3VspgrXK1BwMadvyf8uQ=;
 b=hsDwVA0O7RSy48Mhe7NWMb8tjn15TWEJoVlt3QzkzavAnaXOL8kEGS01VnU9cLjhCRRPPcSfoDzeMzJXYhOMOuox/Ot4I12ZYCdzsk/GjBnBITzcUsTQP7xN3s8/8Sv/UDVM5/xApqXFM+WVsSCdOnXfIz4zy1D3mAOS7Y8SNemMQsUxXtxTKEaT0HRbgbO9p7qsvsW/eE2+eT00vBlSi0E/01JxVszazTvISYG0Wfanvt1EvktpUrsZ0JjwNoW+Tilv5KeD7M06rdYN+4BSEBrQunQlXoIBDZR2qnMAqTNNYxoTtmYti4bZWLqDIYk2sm0FuOGclYXgNl2w+/WTbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7129.namprd12.prod.outlook.com (2603:10b6:806:2a1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 18:52:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Fri, 13 Jan 2023
 18:52:57 +0000
Date:   Fri, 13 Jan 2023 14:52:56 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, pbonzini@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, seanjc@google.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfio: fix potential deadlock on vfio group lock
Message-ID: <Y8GoiCBQNiAuVcNw@nvidia.com>
References: <20230113171132.86057-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113171132.86057-1-mjrosato@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0181.namprd13.prod.outlook.com
 (2603:10b6:208:2be::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: f3ee1e7a-0170-44d6-6458-08daf59762b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E7ydpYnXQmh9K31D3wl4tzrdkCKlrkGRBZGa4WgXUHoPQXJldi2dyctCm7GT9xyt7cMw5R9Mc3tj7JnwXEGfM0Ws2nD9sb0voZ4sUV1AojPjhaXmpLr6qewNGJ2E1z4YgaTisBvW/P11JqKCBi+PgtrLa6tvaEMz7o1yJdZEL8mVAuIO1aNjy2WCgk7RC1YFHmKsPGJhdTQlRxOKAwTc64DzbVxH4hn602sMCc6eXyoNRL6SozXVJI6RWuH8niz2kKnV1IBz0CL9VQNngUrM+B8n3YgdNhmhxIlA4Fg5LFWxTHUIev260xlRiIj/01IaMgEX84Mkfp6cZKboAaE3ZlSmefhoZfPKWx85mGfRr8x3FE8XKUd55JkfLsFovGOHmQmxCFkOhw+B6zZJXDTHUIOyjtVCYd7OAPrmy4oBDcCmx9cP309DqXDsyvcZnZxRYT3b5KT+dsUAoVm7kpCMhDngr+c0LMlHuNssLTyOpWMXpFJpK8cremFBFdSOjWiibGxMqZDOZXwO7kb5JMKHXEsvn5gmEpY66TfTPWLQMBIZSD8k4axvHu0lIZrnAKWY1Wzy4BSJnE1UJoPAudBkXMkbivWTzf+XUgrpQUet8/LiLmh854/ma1OMZTqltdrIB2GzzxBfEUNQ3kC6c3F69A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199015)(6506007)(7416002)(36756003)(2906002)(5660300002)(83380400001)(8936002)(4744005)(6916009)(4326008)(8676002)(38100700002)(6512007)(6486002)(41300700001)(478600001)(66946007)(66556008)(186003)(66476007)(26005)(86362001)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xrLkPnGGNn+PcR00I/9tYoYSk9RB1brWY24QGJYS1bAN26dqbfMFywwuYari?=
 =?us-ascii?Q?8JAZDbf9oPvDC622gGOsb3Bo7HX5jm/nK54j1zX7EEAr0zU4tMC82Zxq3TRZ?=
 =?us-ascii?Q?QEysvzfraaQfAWOLAwSsxW1IdHbPeh+djNq4XXZNMTbA7HKxLdbKFwAO6wP0?=
 =?us-ascii?Q?4CDc3CVHprYqcpvYSDTX8uaYavs3+pXz+T88QTQoiDYVerjknANOWOj2Ecjp?=
 =?us-ascii?Q?hD90a7CJwrqgyGflFvAJ7qABSRLm6LqmGYgQ+ysdjZSqVQkoabWjccn0ibGW?=
 =?us-ascii?Q?EJYsQQWuOylSc9ydktJbNzrozu1mqBfgmP3FgWr2+rJ6wbJ/KSZT8w3spOS+?=
 =?us-ascii?Q?8ReMD4E92+Ql/QgLmN7ESIG2Bo0bz/8iDm7UGYSzQXG8foXTD4PiiSsi0BWS?=
 =?us-ascii?Q?pqxPUVNwq2LRhQWhi75TSW5KaizrJWEW43YqD2nm73hqPX7giaLH/VV33NEd?=
 =?us-ascii?Q?EzmgjLAJ51XRfXIucqsbvEFaJYdHfYhtFft8C49XDfsx37UBRVnHeqAenlL1?=
 =?us-ascii?Q?agyXQMd+3UkUo8XZqAgYYW3cSBU6gdXtNUBlirnxtAUiGa/gDP/MVm6VONbw?=
 =?us-ascii?Q?ypopkSDGGSl+5gGHSVcukbQgqsqIkhVBxkd0f1sQgaYvL+qFQwPhYpYeklAh?=
 =?us-ascii?Q?BC5WNhWwmKjs7x2Zub6NBYSIFZh6TfDKDakkarZg0uEh3Mq8rC4tkxvqwoZj?=
 =?us-ascii?Q?KOrkpAoaAZLI6aE+HVvvW10Wr1uxdqb8B1NX5/9J2+s3YGLznCs4EGjihNGn?=
 =?us-ascii?Q?u04sbgrRKdha1svnuDOd5DM4j9Qro5FFVMuSj11DHrkvatgR3WGtfOyfuixk?=
 =?us-ascii?Q?ZgISldEE4F8hjuoiFv99WFwaZXs75nwTt33/U28aL1nsc/xZkC+ZeStFaUub?=
 =?us-ascii?Q?/Y3w4wLDkHUx3X+kco7R78UqmB3qI0lml+X76KmpGdV71gLEOfwG0YQts7Cg?=
 =?us-ascii?Q?lh4fX2JPCv2OXBt9ZHxe0rCwQsKaJ/qUfRHZhUChVCybdTnfgaDD9VVl8QGm?=
 =?us-ascii?Q?zGWbeoFNrd89MobHqwWfaIXTGKE5J9vJ7Fe5+Y84+mweAN8slPFx1/AayHy/?=
 =?us-ascii?Q?on6w2/zNZixCwRo4fxZgrPANr8rUrJILgTS2nYnquSeo/V/r/guNall3mbsj?=
 =?us-ascii?Q?FVWilGUpyP3QqSq79PeDaTlOXHTFgOuGpBYMRnOyGclw2/FT/4b5FuEyFQad?=
 =?us-ascii?Q?ZunLqpLjdU1LYX9a804yatBft560OZCZ0foJr5+WWixYEnzEi64hXw4Wglp7?=
 =?us-ascii?Q?iFO1uri956GsJpiLDe0DYu8jit8d6sWqKEraJY2muKjwHmdcYM9YPiHhs3eW?=
 =?us-ascii?Q?Fb/x4znYl1d5FSH8/GZaS4GDunnI/OgJOAtKNw4Wkfych3JqrNpQe2KAgVf5?=
 =?us-ascii?Q?ATF4AxwKXMBiwaCCI6qKew4dY0nWEGu8QuilnIBniLQsKslf2GFoghpeU+BN?=
 =?us-ascii?Q?LUilpeyQuVsx/gCOElzZ7C9IZEYE42bXw6ZAEUWdqsPDFjBkqvO2TOR9djkz?=
 =?us-ascii?Q?jam4aNh7MXbR651Y8DCsBzKG0AfXNsc6yR2UdSOvZf9GE6OGo7b2z25CS/Ca?=
 =?us-ascii?Q?GdFKL0iJ++dQtkc0P1Bl8LGfCAXImHm/6qxuZZZ1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ee1e7a-0170-44d6-6458-08daf59762b6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 18:52:57.3833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LxeqD03n/2RS/HBYEjNeoOWYcOzMBYVX7D+CvGBA75Y6jUSuQXRwy6AwA2va0jOT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7129
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023 at 12:11:32PM -0500, Matthew Rosato wrote:
> @@ -462,9 +520,19 @@ static inline void vfio_device_pm_runtime_put(struct vfio_device *device)
>  static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  {
>  	struct vfio_device *device = filep->private_data;
> +	struct kvm *kvm = NULL;
>  
>  	vfio_device_group_close(device);
>  
> +	mutex_lock(&device->dev_set->lock);
> +	if (device->open_count == 0 && device->kvm) {
> +		kvm = device->kvm;
> +		device->kvm = NULL;
> +	}
> +	mutex_unlock(&device->dev_set->lock);

This still doesn't seem right, another thread could have incr'd the
open_count already 

This has to be done at the moment open_count is decremented to zero,
while still under the original lock.

Jason
