Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0243E34EE7A
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 18:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhC3QvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 12:51:04 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:3584
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232001AbhC3Quq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 12:50:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YpRK0QcwE1QtUEfaxkPgEaCV78IqF9xa4xx5p7t9IgOdq/BgBMNHV8YZg11uxPWZRxoCFzgL1l8FDhIegFlCi1AYNjKkGHamNqF+AOo8gFNogNHoTfvVWy4xCGxNm1C9OIUU82/cf3dimKXqvfG2Qt+N5RMcPuSOXUQzBb2W2QQ8QimLkqIkL2CLUmdasm/ZTEmXPxqd/gV7ZUCYfXFwWQDWaGFSpX8M411gXIzcu1W9Un0wMluJRRxo6ERX+hAYCCMNOVuKv5QF4Y3JPlW3FfgqizvvkdszZfYMHnQM642frFJz9of74ZGLu00NABzP+yS1X4vr8Klu8HFj+KTlyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMzvo7MvpqROcd+nA+QOvF12vX06/focqJ5OC7xJ/FI=;
 b=nBIkYohnGsdpaSXbQQ9+lagTTDEmhFUiYjoF6EgRqWetyJ5s4L7tbKJZcyT81s88iZiRT1j74PjV1NvM8Co9DhuTZfMEqFEdokkt12X58dpRxwuwNMMC+KrFpCm54IbuKy2uBD1s4ZIdmixVEuVwHUVI0d49oDo69QgURDy4PAo6tdmM9oPhwp+g/zU2CPVOZZIvnLfCEVKh1hRSKVAE7GKa2vF3EZZa959wpCC/W2QXsBJ6bIeZljQxGblzeMxJdTWPkxvxFaPvGk0q3ajunnJp1z271TyHUnIRUP1xhrA/PrhIQ45jjhNnuhiJWRHlAIP9Y+R1/cBylO74B/J/jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMzvo7MvpqROcd+nA+QOvF12vX06/focqJ5OC7xJ/FI=;
 b=FYdHtns6k8zWiqq12GTUyIhm6dM4MRMytTMYRQeWlmQajsG9u+1Lxz7SPBTKXqOy/6iR8qLGljZ4MDIFPzqY89aazAM6Ys+9Znd3grnkW6aPcQFCAU42Rh4Q51RnPGdWHgEw+eo15uUF8C6/nKa7l7H/FxxJZnCiYuLwVTzxOAjZQKpscNa+oMnYDhlBBNhWbfNhdQHEjGfl4nn66Lv7RGxt2ZlgtVJy8WksMfY0Bwg/AYB0UeQYP6VkWPTOn04cymNduVAi9D3H+2snOXZJDX+mL2dB+7/RNZ8F3bqV6rOOW6ujaRsVgPOikUASa4OA5Ojlzx9k5k5VGHmhdDfAkw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1436.namprd12.prod.outlook.com (2603:10b6:3:78::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.25; Tue, 30 Mar 2021 16:50:45 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 16:50:45 +0000
Date:   Tue, 30 Mar 2021 13:50:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 10/18] vfio/mdev: Remove duplicate storage of parent in
 mdev_device
Message-ID: <20210330165043.GT2356281@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <10-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <MWHPR11MB18864F0836984277A52BB4CB8C619@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210326115350.GM2356281@nvidia.com>
 <20210330181413.4602f816.cohuck@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330181413.4602f816.cohuck@redhat.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0076.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0076.namprd13.prod.outlook.com (2603:10b6:208:2b8::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.14 via Frontend Transport; Tue, 30 Mar 2021 16:50:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lRHZj-005x6d-Ku; Tue, 30 Mar 2021 13:50:43 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bad8fc48-43fe-4953-dfec-08d8f39bf638
X-MS-TrafficTypeDiagnostic: DM5PR12MB1436:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB14365CE361FCF857CFEEF511C27D9@DM5PR12MB1436.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cSM+cfr/SMBw0vBYHTgZNqCdTM7vbIRPM1TNnstX+NBPBWyy5dUF9ePeQLHKM6oDJZgZwe67pHO1VOX0obrbcCWenCIBIpuOWIku2cW21cfRquMKuvPXIlvjj4UFlHK5pA5eJxdoiNU7P6vEFNlSvh6XWJfO1V+Jh7EyhwS5tpLL16rr6eKaMVtJKif+0DEYY2ZnNLJvh4HaeQxKYneLLWe+aA0LmxhtGawUn6QbHI5HDTcmq6fELI19fuRV8+8Vn3Dkk3mhbuQlYhIyMTullDtWOyXVSJ6gsaNxm/mPNXTtaa9b1wL8tnv5ci7iuw2zpBwGAVZncPxlmpuW5ebf+6uupNOCw90MPFse8K2SV2FQRrhVEkGxamNTPvXVwfw+0rQ8jnR33j8b4afD2n59u6F9JS0M6n8cTRzZ3LKVIYuQbI7J9gvr/uZ0o5nxHiraCBTWqj3TXCdPIRObPJXUAPVuZkybPX6AIhZks2CekPuZNjSHTBNXFp8P6h+Nj0yzpodUgSsMBJ5WLQuk6Nxj2RVYTaFyFv0a0/4thW8umwf17xLcbMOhjLFIm24iy4pIzo+wGH4PCmPVLvm+Dc7OhwKpRwN3pZ2068gFI8P9v26GogBWYTqU/Ui9unpUDmP5r1XjeWO5CSSk6bnKVyUjw2dVAMtg3JOmKz9fA/PPHmM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(36756003)(478600001)(316002)(2616005)(66556008)(66476007)(66946007)(426003)(86362001)(38100700001)(83380400001)(33656002)(6916009)(54906003)(186003)(2906002)(26005)(4326008)(9746002)(8676002)(5660300002)(107886003)(8936002)(9786002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?24ekUvk+0Vn5eXFrQk/yhygBXoMcsON0thjZs/fUZvNbgHmOzFrGo1yjPDAK?=
 =?us-ascii?Q?jF1sIwGepkwDTppBg6lu3eHBrOxG2oB+6GaFLcHS1xtkgXfXpDaCQTdK0twZ?=
 =?us-ascii?Q?Z1vLoeiLGefT4ZHUNEmOyOs7Qxc4UUJng/nNxfYvWaiMS0uGApDk6mbZ2Mcl?=
 =?us-ascii?Q?8CcHN4+rJXcm4xZHin3bamm7SblzN3sYM+t1ZoXaxK3x4Q19Xf0YAHi6CySx?=
 =?us-ascii?Q?v+9MHBoPU+VAy9HDRGmE2LN2FIFUNzR9ANQUQC/53ybFc8UpHnhJvNJnO23j?=
 =?us-ascii?Q?70ug8UjiUynHSzFbZYTtvS2LDFtgrvYBvu5YIVw5OJbGH+dQJOnItXuusakt?=
 =?us-ascii?Q?YWdFp3EB/5c2OsqtMDawLr4VVqBAug8ANEX2kJJmBMflzYwunqbPS1NiBFrP?=
 =?us-ascii?Q?wo81Sa9OnvDn1tdkmBgy1axKqS8cbbEpcO4wQ/gg7um+R5ohFhpRnhG8K26H?=
 =?us-ascii?Q?Vl5YG6S+O11CLJB+BPe894463RUqkCYBbcc5fSZ1JhIERepNz5G6TuptbBOi?=
 =?us-ascii?Q?SLlX+IB8ELSMbMEhXcau6OYh1cAQmTeReMBCQAy6k5ZB++nm1UsfRrj/r+Kf?=
 =?us-ascii?Q?itcDwoMlKnqybX8bw9X13PF4z7b/9D8ZjXVVSYrfeiZPEQfzp+c9xMiM9ICe?=
 =?us-ascii?Q?ooJe3c7/rJBoFqLxNmPVnyaf6RqpjNlxBJa7OEJpjR3/tCTVzoPcNXWm5bnS?=
 =?us-ascii?Q?/3T5pN77pZRBritr13csNY6sPBbSc7BUL1q9z/lvDNOyMd1Gp+BdEMaqaCIX?=
 =?us-ascii?Q?46zNA3MtDRkV5J/++sHoMWgwoW/W5ISKt/M/B4zJg0zd7aIQ7y9+MYpVd6ST?=
 =?us-ascii?Q?pRZiVpNfMX8SWm+Qkh14UJ5ifbq19uQA7lnx7N35/JSY2WMkQI20ZRCmt9uz?=
 =?us-ascii?Q?IKTxrOC/5vl935/34OCTqKvNjZwAqlQQwpXzJVd9Jj95+4GFxlctJBgTVODi?=
 =?us-ascii?Q?Jvj1gbnbgmvP4E4JtszdIQpsx7MyDOUr8HNvPkr118Cst1CM79vbK2ib2DpZ?=
 =?us-ascii?Q?P7QjA9ooLRO8sgTX0P/QFLDBlLvpCcgN1JjNXl8g6JhyY8NIOfSFwSam7yq6?=
 =?us-ascii?Q?+E3ufzQBTtY5oW0tvss13BN+dOEJgBU6r384KN/CAEF6uqpvWpLqKPQiORRn?=
 =?us-ascii?Q?OyeBFkhuJmukVg3ivMdUP2UW5uoNVd4U7dY6QrnsAqJHHfkiTV6otUlkIGci?=
 =?us-ascii?Q?diYjUUu3wFXRxbjIBT/sc0KAkrrxEBy2O+9XHaMhlGVhULPM2Ks6Dnp50vl7?=
 =?us-ascii?Q?kl8s/gp/QF2ITUgwqHRs+5nsFICAtKeSujpn8kXjdu8XUjGU/zVGZyNvlP/p?=
 =?us-ascii?Q?Dfcs2I9z0mZd7v1GXDirY49TrRulhpqVDLT3FV2IJersmQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bad8fc48-43fe-4953-dfec-08d8f39bf638
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 16:50:45.2286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CKhx1bpHd/nvMgo5FZ1moYMu0RiQ4G2V/69zObFMeeCWdMKZdmpeUXrtxaJtgmbh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1436
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 30, 2021 at 06:14:13PM +0200, Cornelia Huck wrote:
> On Fri, 26 Mar 2021 08:53:50 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Fri, Mar 26, 2021 at 03:53:10AM +0000, Tian, Kevin wrote:
> > 
> > > > @@ -58,12 +58,11 @@ void mdev_release_parent(struct kref *kref)
> > > >  /* Caller must hold parent unreg_sem read or write lock */
> > > >  static void mdev_device_remove_common(struct mdev_device *mdev)
> > > >  {
> > > > -	struct mdev_parent *parent;
> > > > +	struct mdev_parent *parent = mdev->type->parent;  
> > > 
> > > What about having a wrapper here, like mdev_parent_dev? For
> > > readability it's not necessary to show that the parent is indirectly
> > > retrieved through mdev_type.  
> > 
> > I think that is too much wrappering, we only have three usages of the
> > mdev->type->parent sequence and two are already single line inlines.
> 
> I'm counting more of those in this patch... or do you mean at the end
> of the series?

I'm thinking of either moving them to inlines earlier or moving them
all as a final patch. Given how far we've come review wise I'm
inclined to do the latter

Thanks,
Jason 
